/*
  Annotations for the Manage Books App
*/

using ManageTeamService from '../../srv/manage-team-service';

annotate ManageTeamService.Teams with @(
	UI: {
		LineItem: [
			{Value: ID, Label:'{i18n>ID}'},
			{Value: name, Label:'{i18n>Name}'},
			{Value: location, Label:'{i18n>Location}'},
		],
		HeaderInfo: {
			TypeName: '{i18n>Team}', TypeNamePlural: '{i18n>Teams}',
			Title: {
				Label: '{i18n>Team}',
				Value: name
			},
			Description: {Value: location}
		},
		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Created}', Target: '@UI.FieldGroup#Created'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Modified}', Target: '@UI.FieldGroup#Modified'},
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Description}', Target: '@UI.FieldGroup#Descr'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Team}', Target: 'members/@UI.LineItem'},
		],
		FieldGroup#Descr: {
			Data: [
				{Value: descr},
				{Value: location},
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
	}
);

annotate ManageTeamService.Members with @(
	UI: {
		SelectionFields: [ employee_ID ],
		LineItem: [
			{Value: employee_ID, Label:'{i18n>ID}'},
			{Value: employee.name, Label:'{i18n>Name}'},
			{Value: position, Label:'{i18n>Position}'},
		],
		HeaderInfo: {
			TypeName: '{i18n>Member}', TypeNamePlural: '{i18n>Members}',
			Title: {
				Label: '{i18n>Member}',
				Value: employee.name
			},
			Description: {Value: employee.email}
		},
		Identification: [ //Is the main field group
			{Value: employee_ID, Label:'{i18n>Member}'},
			{Value: position, Label:'{i18n>Position}'}
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Description}', Target: '@UI.Identification'},
		]
	}
);
