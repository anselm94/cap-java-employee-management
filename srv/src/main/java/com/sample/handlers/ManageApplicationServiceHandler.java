package com.sample.handlers;

import static cds.gen.com.sample.Sample_.APPLICATIONS;
import static cds.gen.com.sample.Sample_.MEMBERS;

import java.util.List;
import java.util.function.Supplier;
import java.util.stream.Stream;

import com.sample.Status;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.Result;
import com.sap.cds.ql.CQL;
import com.sap.cds.ql.Delete;
import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Predicate;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.ql.cqn.CqnModifier;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.ql.cqn.CqnSelectListItem;
import com.sap.cds.reflect.CdsModel;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.cds.CdsService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.messages.Messages;
import com.sap.cds.services.persistence.PersistenceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cds.gen.com.sample.Applications;
import cds.gen.com.sample.Members;
import cds.gen.manageapplicationservice.Applications_;
import cds.gen.manageapplicationservice.Employees;
import cds.gen.manageapplicationservice.Employees_;
import cds.gen.manageapplicationservice.ManageApplicationService_;
import cds.gen.manageapplicationservice.TakeActionContext;

@Component
@ServiceName(ManageApplicationService_.CDS_NAME)
public class ManageApplicationServiceHandler implements EventHandler {

    @Autowired
	private PersistenceService db;

	@Autowired
	private Messages messages;

    private CqnAnalyzer analyzer;
	
	@Autowired
	public ManageApplicationServiceHandler(CdsModel model) {
		// model is a tenant-dependant model proxy
		this.analyzer = CqnAnalyzer.create(model);
	}

    /**
	 * Process a Job application
	 * 
	 * Steps:
	 * 1. get 'Application' information - 'employee_ID' as 'applicant_ID' & 'team_ID'
	 * if 'accept' -> 
	 *        2.1 remove all known memberships from 'Members' entity for 'employee_ID'
	 *        2.2 create a membership in 'Members' entity for 'employee_ID' with 'team_ID' and 'position'
	 *        2.3 mark application as 'Accepted'
	 * if 'reject' ->
	 *        3.1 mark application as 'Rejected'
	 * @param context
	 */
	@On(entity = Applications_.CDS_NAME)
	public void takeAction(TakeActionContext context) {
		boolean isManager = context.getUserInfo().hasRole("manager");
		if (!isManager) {
			throw notAllowed("Only Managers are allowed to process applications").get();
		}

		Boolean isAccepted = context.getAccepted();
		String jobPosition = context.getPosition();

		String applicationId = (String) analyzer.analyze(context.getCqn()).targetKeys().get(Applications.ID);

		Result resultApplicationsQuery = db.run(Select.from(APPLICATIONS).where(o -> o.ID().eq(applicationId)));
		Applications activeApplication = resultApplicationsQuery.first(Applications.class).orElseThrow(notFound(String.format("Application with ID: %s", applicationId)));

		if (!activeApplication.getStatus().equals(Status.IN_PROCESS.toString())) {
			throw notAllowed("Only applications in 'In Process' can be processed").get();
		}

		if(isAccepted) {
			if (jobPosition.isEmpty()) {
				throw notAllowed("'Position' is required for accepting applications").get();
			}

			db.run(Delete.from(MEMBERS).where(m -> m.ID().eq(activeApplication.getApplicantId())));

			Members newMembership = Members.create();
			newMembership.setEmployeeId(activeApplication.getApplicantId());
			newMembership.setTeamId(activeApplication.getTeamId());
			newMembership.setPosition(jobPosition);
			db.run(Insert.into(MEMBERS).entry(newMembership));

			activeApplication.setStatus(Status.ACCEPTED.toString());
			db.run(Update.entity(APPLICATIONS).data(activeApplication));
			messages.success(String.format("Application (%s) is marked accepted", activeApplication.getApplicantId()));
		} else {
			activeApplication.setStatus(Status.REJECTED.toString());
			db.run(Update.entity(APPLICATIONS).data(activeApplication));
			messages.success(String.format("Application (%s) is marked rejected", activeApplication.getApplicantId()));
		}
		context.setCompleted();
	}

	/**
	 * Expand the 'applicant' entity of Applications, if not in a draft mode
	 * @param context
	 */
	@Before(entity = Applications_.CDS_NAME, event = CdsService.EVENT_READ)
	public void beforeReadApplications(CdsReadEventContext context) {
		boolean isManager = context.getUserInfo().hasRole("manager");
		// if the query is not in draft mode, try expanding the 'applicant' entity
		if (!isManager) {
			CqnSelect modifiedQuery = CQL.copy(context.getCqn(), new CqnModifier() {
				@Override
				public List<CqnSelectListItem> items(List<CqnSelectListItem> items) {
					// add an expand for "applicant"
					if (items.size() != 0) { // a hack to determine if in draft mode. TODO: find the right path
						items.add(CQL.to(Applications.APPLICANT).expand(a -> a._all())); 
					}
					return items;
				}
			});
			context.setCqn(modifiedQuery);
		}
	}

	/**
	 * Filter the list of applications to the current employee, else show all the applications if the user is a manager, by
	 * filtering the queried objects
	 * @param context
	 * @param applications
	 */
	@After(entity = Applications_.CDS_NAME, event = CdsService.EVENT_READ)
	public void afterReadApplications(CdsReadEventContext context, Stream<cds.gen.manageapplicationservice.Applications> applications) {
		boolean isManager = context.getUserInfo().hasRole("manager");
		// if user is a manager, return the list of all applications, so he can process thereon
		// but for an employee, he can see only his application
		if (!isManager) {
			String currentUserEmail = (String) context.getUserInfo().getAdditionalAttributes().get("email");
			applications.filter(a -> a.getIsActiveEntity()).filter(a -> a.getApplicant() != null).filter(a -> a.getApplicant().getEmail().equals(currentUserEmail));
		}
	}

	/**
	 * Filter the list of Employees to current employee else show all employees, if the user is a manager by directly 
	 * manipulating the CQL query
	 * @param context
	 */
	@Before(entity = Employees_.CDS_NAME, event = CdsService.EVENT_READ)
	public void beforeReadEmployees(CdsReadEventContext context) {
		boolean isManager = context.getUserInfo().hasRole("manager");
		// if user is a manager, return the list of all employees, so he can create applications on someone's behalf
		// but for an employee, he can create applications only for him/herself
		if (!isManager) {
			String currentUserEmail = (String) context.getUserInfo().getAdditionalAttributes().get("email");
			CqnSelect modifiedQuery = CQL.copy(context.getCqn(), new CqnModifier() {
				@Override
				public Predicate where(Predicate where) {
					Predicate whereExpression = CQL.get(Employees.EMAIL).eq(currentUserEmail);
					return where == null ? whereExpression : where.and(whereExpression);
				}
			});
			context.setCqn(modifiedQuery);
		}
	}

	private Supplier<ServiceException> notAllowed(String message) {
		return () -> new ServiceException(ErrorStatuses.METHOD_NOT_ALLOWED, message);
	}

	private Supplier<ServiceException> notFound(String message) {
		return () -> new ServiceException(ErrorStatuses.NOT_FOUND, message);
	}
}
