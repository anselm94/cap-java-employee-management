/*
  Annotations for the Manage Books App
*/

using MyProfileService from '../../srv/my-profile-service';

annotate MyProfileService.Employee with @(
	UI: {
		HeaderInfo: {
			TypeName: '{i18n>MyProfile}', TypeNamePlural: '{i18n>MyProfile}',
			Title: {
				Label: '{i18n>Name}',
				Value: name
			},
			Description: {Value: email},
			ImageUrl: imgUrl
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Team}', Target: '@UI.Identification'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Description}', Target: '@UI.FieldGroup#Descr'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Modified}', Target: '@UI.FieldGroup#Modified'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Skills}', Target: 'skills/@UI.LineItem'},
		],
		FieldGroup#Descr: {
			Data: [
				{Value: dob},
				{Value: salary},
				{Value: yearsOfExperience},
			]
		},
		FieldGroup#Modified: {
			Data: [
				{Value: modifiedBy},
				{Value: modifiedAt},
			]
		},
        Identification: [
			{Value: membership.team.name, Label:'{i18n>Team}'},
			{Value: membership.position, Label:'{i18n>Position}'}
		],
	},
	Capabilities: { // only allow update
        InsertRestrictions: {Insertable: false},
        UpdateRestrictions: {Updatable: true},
        DeleteRestrictions: {Deletable: false},
        SearchRestrictions: {Searchable: false},
    },
) { // make name & email as readonly, and employee will not be able to change his/her name or email
	name @Common.FieldControl: #ReadOnly;
	email @Common.FieldControl: #ReadOnly;
	membership @Common.FieldControl: #ReadOnly;
};

annotate MyProfileService.Skills with @(
	UI: {
		LineItem: [
			{Value: name, Label:'{i18n>Skill}'}
		]
	}
);