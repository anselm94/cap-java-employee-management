using { MyProfileService } from './my-profile-service';
using {com.sample as schema} from '../db/schema';
using { cuid } from '@sap/cds/common';

///////////////////////////////////////////////////////////////////////
// Service providing an overview information of employee management
//
@path : 'overview'
service OverviewService @(requires : 'authenticated-user') {

    entity Teams     as projection on schema.Teams;

    entity Members   as projection on schema.Members;

    @cds.redirection.target
    entity Employees as projection on schema.Employees;

    entity Applications as projection on schema.Applications;

    entity Skills as projection on schema.Skills;

    entity Profile as select from MyProfileService.Profile {
        name,
        dob,
        email,
        salary,
        salaryUoM,
        yearsOfExperience,
        imgUrl,
        membership.position as position,
        membership.team.name as teamName,
        membership.team.location as teamLocation
    };

    entity Parameters : cuid {}
}
