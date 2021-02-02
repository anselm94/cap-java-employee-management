using { com.sample as schema } from '../db/schema';

///////////////////////////////////////////////////////////////////////
// Service to manage employee's own profile and assign/unassign skills
//
@path: 'my-profile'
service MyProfileService @(requires: 'authenticated-user') {

    @readonly entity Teams as projection on schema.Teams;

    entity Employee @(restrict: [ 
        { grant: ['READ','UPDATE']}
    ]) as projection on schema.Employees excluding {
        createdAt,
        createdBy
    };

    entity Skills as projection on schema.Skills;
}

// Deep Search Items
annotate MyProfileService.Skills with @cds.search : { name };

// Enable Fiori Draft
annotate MyProfileService.Employee with @odata.draft.enabled @Capabilities.Insertable: false @Capabilities.Deletability: false;