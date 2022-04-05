using { com.sample as schema } from '../db/schema';

/////////////////////////////////////////////////////////////////////////////////////////
// Service to accept/reject job applications by managers and apply for jobs by employees
//
@path: 'manage-application'
service ManageApplicationService @(requires: 'authenticated-user') {

  @readonly entity Teams as projection on schema.Teams excluding {
    createdAt,
    createdBy,
    modifiedAt,
    modifiedBy
  };

  @readonly entity Employees as projection on schema.Employees;

  entity Applications as projection on schema.Applications actions {
    action takeAction(accepted: Boolean, position: String) returns Applications;
  };
}

// Enable Fiori Draft
annotate ManageApplicationService.Applications with @odata.draft.enabled;
