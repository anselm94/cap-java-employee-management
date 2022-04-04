using {com.sample as schema} from '../db/schema';
using { cuid } from '@sap/cds/common';

///////////////////////////////////////////////////////////////////////
// Service providing an overview information of employee management
//
@path : 'overview'
service OverviewService @(requires : 'authenticated-user') {

    entity Teams     as projection on schema.Teams;

    entity Members   as projection on schema.Members;

    entity Employees as projection on schema.Employees;

    entity Skill as projection on schema.Skills;

    entity Parameters : cuid {}
}
