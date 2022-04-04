package com.sample.handlers;

import com.sap.cds.ql.CQL;
import com.sap.cds.ql.Predicate;
import com.sap.cds.ql.cqn.CqnModifier;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.cds.CdsService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import org.springframework.stereotype.Component;

import cds.gen.myprofileservice.Employee;
import cds.gen.myprofileservice.Employee_;
import cds.gen.myprofileservice.Profile_;
import cds.gen.myprofileservice.MyProfileService_;

@Component
@ServiceName(MyProfileService_.CDS_NAME)
public class MyProfileServiceHandler implements EventHandler {

	/**
	 * Filter the list of Employee to current user, by modifying the CQL query
	 * @param context
	 */
	@Before(entity = Employee_.CDS_NAME, event = CdsService.EVENT_READ)
	public void beforeReadEmployee(CdsReadEventContext context) {
		String currentUserEmail = (String) context.getUserInfo().getAdditionalAttributes().get("email");
		CqnSelect modifiedQuery = CQL.copy(context.getCqn(), new CqnModifier() {
			@Override
			public Predicate where(Predicate where) {
				Predicate whereExpression = CQL.get(Employee.EMAIL).eq(currentUserEmail);
				return where == null ? whereExpression : where.and(whereExpression);
			}
		});
		context.setCqn(modifiedQuery);
	}

	/**
	 * Filter the list of Employee to current user, by modifying the CQL query
	 * @param context
	 */
	@Before(entity = Profile_.CDS_NAME, event = CdsService.EVENT_READ)
	public void beforeReadProfile(CdsReadEventContext context) {
		String currentUserEmail = (String) context.getUserInfo().getAdditionalAttributes().get("email");
		CqnSelect modifiedQuery = CQL.copy(context.getCqn(), new CqnModifier() {
			@Override
			public Predicate where(Predicate where) {
				Predicate whereExpression = CQL.get(Employee.EMAIL).eq(currentUserEmail);
				return where == null ? whereExpression : where.and(whereExpression);
			}
		});
		context.setCqn(modifiedQuery);
	}
}
