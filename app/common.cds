/*
  Common Annotations shared by all apps
*/

using {com.sample as schema} from '../db/schema';
using {cuid} from '@sap/cds/common';

annotate schema.Teams with @(UI : { // Value Help
    Identification  : [{Value : name}], // search
    SelectionFields : [
        ID,
        name,
        location
    ], // filterbar
    LineItem        : [
        {Value : ID},
        {Value : name},
        {Value : location}
    ],
    HeaderInfo      : {
        TypeName       : '{i18n>Team}',
        TypeNamePlural : '{i18n>Teams}',
        Title          : {Value : name},
        Description    : {Value : descr}
    },
}) { // translation texts
    ID        @title            : '{i18n>ID}'  @UI.HiddenFilter;
    members   @ValueList.entity : 'Employees';
    name      @title            : '{i18n>Name}';
    descr     @UI.MultiLineText;
    location  @title            : '{i18n>Location}';
    latitude   @title            : '{i18n>Latitude}';
    longitude   @title            : '{i18n>Longitude}';

    @Analytics.Measure
    @Measures.Unit       :        budgetUoM
    @Aggregation.default :        #SUM
    budget    @title            : '{i18n>Budget}';

    @Common.IsUnit
    budgetUoM @title            : '{i18n>BudgetUoM}'
};

annotate schema.Members with {
    ID       @title            : '{i18n>ID}'  @UI.HiddenFilter;
    employee @ValueList.entity : 'Employees';
    team     @title            : '{i18n>Team}'  @ValueList.entity : 'Teams';
};

annotate schema.Employees with @(UI : { // Value Help
    Identification  : [{Value : name}],
    SelectionFields : [
        ID,
        email,
        skills.name
    ],
    LineItem        : [
        {Value : ID},
        {Value : name},
        {Value : dob},
        {Value : email},
    ]
}) { // translation texts
    ID                @title            : '{i18n>ID}'  @UI.HiddenFilter;
    name              @title            : '{i18n>Name}';
    dob               @title            : '{i18n>DOB}';

    @UI.IsImageURL       :                true
    imgUrl            @title            : '{i18n>Image}';

    @Analytics.Measure
    @Measures.Unit       :                salaryUoM
    @Aggregation.default :                #MAX
    @Common              :                {
        Text            : salaryUoM,
        TextArrangement : #TextLast
    }
    salary            @title            : '{i18n>Salary}';

    @Common.IsUnit
    salaryUoM         @title            : '{i18n>SalaryUoM}';

    email             @title            : '{i18n>Email}';

    @Analytics.Measure
    @Aggregation.default :                #MAX
    @Common              :                {
        Text            : 'Years',
        TextArrangement : #TextLast
    }
    yearsOfExperience @title            : '{i18n>YearsOfExperience}';

    skills            @ValueList.entity : 'Skills';
};

annotate schema.Applications with @(UI : { // Value Help
    Identification  : [{Value : applicant.name}], // search
    SelectionFields : [
        ID,
        status
    ], // filterbar
    LineItem        : [
        {Value : ID},
        {Value : applicant.name},
        {Value : team.name}
    ]
}) { // translation texts
    ID        @title            : '{i18n>ID}'  @UI.HiddenFilter;
    applicant @ValueList.entity : 'Employees';
    team      @ValueList.entity : 'Teams';
    resume    @title            : '{i18n>Resume}'  @UI.MultiLineText;
};

annotate schema.Skills with {
    ID       @title            : '{i18n>ID}'  @UI.HiddenFilter;
    name     @title            : '{i18n>Skill}';
    employee @ValueList.entity : 'Employees';
};

//	Fiori requires generated IDs to be annotated with @Core.Computed
annotate cuid with {
    ID @Core.Computed
}

annotate schema.Status with {
    IN_PROCESS @title : '{i18n>InProcess}';
    ACCEPTED   @title : '{i18n>Accepted}';
    REJECTED   @title : '{i18n>Rejected}';
};
