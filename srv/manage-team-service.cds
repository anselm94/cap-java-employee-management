using { com.sample as schema } from '../db/schema';

///////////////////////////////////////////////////////////////////
// Service to manage teams and assign employees to team as members
//
@path: 'manage-team'
service ManageTeamService @(requires: 'manager') {

    entity Teams as projection on schema.Teams;

    entity Members as projection on schema.Members;
    
    @readonly entity Employees as projection on schema.Employees;

}

// Deep Search Items
annotate ManageTeamService.Teams with @cds.search : { name, descr };
annotate ManageTeamService.Members with @cds.search : { employee };
annotate ManageTeamService.Employees with @cds.search : { name, email };
annotate ManageTeamService.Skills with @cds.search : { name };

// Enable Fiori Draft
annotate ManageTeamService.Teams with @odata.draft.enabled;
annotate ManageTeamService.Employees with @odata.draft.enabled @Capabilities.Insertable: false;
