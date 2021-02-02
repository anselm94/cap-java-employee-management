using { com.sample as schema } from '../db/schema';

////////////////////////////////////////////////////////////////////////////
// Service to manage employees like creating, updating and deleting members
//
@path: 'manage-employee'
service ManageEmployeeService @(requires: 'manager') {

  @readonly entity Teams as projection on schema.Teams;

  entity Employees as projection on schema.Employees;

  entity Skills as projection on schema.Skills;
}

// Deep Search Items
annotate ManageEmployeeService.Employees with @cds.search : { name, email };
annotate ManageEmployeeService.Skills with @cds.search : { name };

// Enable Fiori Draft
annotate ManageEmployeeService.Employees with @odata.draft.enabled;