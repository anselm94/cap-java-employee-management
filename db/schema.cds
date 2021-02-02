namespace com.sample;
using { managed, cuid } from '@sap/cds/common';

// A 'Team' has multiple employees assigned as members
entity Teams : cuid, managed {
  name     : String(111);
  descr    : String;
  location : String;
  members  : Composition of many Members on members.team = $self;
}

// A 'Member' is an employee assigned to a team and has a position
entity Members : cuid {
  team     : Association to Teams;
  employee : Association to one Employees;
  position : String(111);
}

// An 'Employee' is assigned to a team and will have a set of skills
entity Employees : cuid, managed {
  name       : String(111);
  dob        : Date;
  email      : String(111);
  membership : Association to one Members on membership.employee = $self;
  skills     : Composition of many Skills on skills.employee = $self;
}

// 'Skills' may have multiple employees associated, and allows managers to search for employees with skills while assigning to a project/team
entity Skills : cuid {
  name      : String(111);
  employee  : Association to Employees;
}

type Status: String enum {
    IN_PROCESS = 'In Process';
		ACCEPTED   = 'Accepted';
		REJECTED   = 'Rejected';
};

// 'Applications' are created by unassigned employees while applying for teams
entity Applications : cuid, managed {
  applicant : Association to one Employees;
  team      : Association to one Teams;
  status    : Status default 'In Process';
  resume    : String;
}