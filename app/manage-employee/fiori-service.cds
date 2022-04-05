/*
  Annotations for the Manage Books App
*/

using ManageEmployeeService from '../../srv/manage-employee-service';

annotate ManageEmployeeService.Employees with @(
	UI: {
		LineItem: [
			{Value: imgUrl},
			{Value: name, Label:'{i18n>Name}'},
			{Value: dob, Label:'{i18n>DOB}'},
			{Value: email, Label:'{i18n>Email}'},
		],
		HeaderInfo: {
			TypeName: '{i18n>Employee}', TypeNamePlural: '{i18n>Employees}',
			Title: {
				Label: '{i18n>Employee}',
				Value: name
			},
			Description: {Value: email},
			ImageUrl: imgUrl
		},
		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Created}', Target: '@UI.FieldGroup#Created'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Modified}', Target: '@UI.FieldGroup#Modified'},
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Team}', Target: '@UI.Identification'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Description}', Target: '@UI.FieldGroup#Descr'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Skills}', Target: 'skills/@UI.LineItem'},
		],
		FieldGroup#Descr: {
			Data: [
				{Value: dob},
				{Value: email},
				{Value: yearsOfExperience},
			]
		},
		FieldGroup#Created: {
			Data: [
				{Value: createdBy},
				{Value: createdAt},
			]
		},
		FieldGroup#Modified: {
			Data: [
				{Value: modifiedBy},
				{Value: modifiedAt},
			]
		},
        Identification: [ //Is the main field group
			{Value: membership.team.name, Label:'{i18n>Team}'},
			{Value: membership.position, Label:'{i18n>Position}'}
		],
	}
);

annotate ManageEmployeeService.Skills with @(
	UI: {
		LineItem: [
			{Value: name, Label:'{i18n>Skill}'}
		]
	}
);
