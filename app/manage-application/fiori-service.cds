/*
  Annotations for the Manage Books App
*/

using ManageApplicationService from '../../srv/manage-application-service';

annotate ManageApplicationService.Applications with @(
	UI: {
		LineItem: [
			{Value: ID, Label:'{i18n>ID}'},
			{Value: applicant.name, Label:'{i18n>Applicant}'},
			{Value: team.name, Label:'{i18n>Team}'},
			{Value: status, Label:'{i18n>Status}'},
			{$Type: 'UI.DataFieldForAction', Label: '{i18n>ProcessApplication}', Action: 'ManageApplicationService.takeAction'},
		],
		HeaderInfo: {
			TypeName: '{i18n>Application}', TypeNamePlural: '{i18n>Applications}',
			Title: {
				Label: '{i18n>Applicant}',
				Value: applicant.name
			},
			Description: {Value: status}
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Application}', Target: '@UI.FieldGroup#Descr'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Team}', Target: '@UI.FieldGroup#Team'},
		],
		FieldGroup#Descr: {
			Data: [
				{Value: applicant_ID, Label: '{i18n>Applicant}'},
				{Value: applicant.email},
				{Value: resume}
			]
		},
		FieldGroup#Team: {
			Data: [
				{Value: team_ID, Label: '{i18n>Team}'},
				{Value: team.name},
				{Value: team.location},
			]
		},
		Capabilities: { // only allow create & delete
			InsertRestrictions: {Insertable: true},
			UpdateRestrictions: {Updatable: false},
			DeleteRestrictions: {Deletable: true},
    	},
	}
) {
	status @Common.FieldControl: #ReadOnly;
};

annotate ManageApplicationService.Applications actions {
	takeAction(
		accepted @title: '{i18n>AcceptApplication}',
		position @title: '{i18n>Position}'
	)
}