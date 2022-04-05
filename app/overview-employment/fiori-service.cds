/*
  Annotations for the Manage Books App
*/

using OverviewService from '../../srv/overview-service';

annotate OverviewService.Parameters with @UI.SelectionFields : [ID];

annotate OverviewService.Teams with @(UI : {
    Chart #BudgetOverview             : {
        Title               : '{i18n>Teams}',
        ChartType           : #Donut,
        Measures            : [budget],
        MeasureAttributes   : [{
            $Type   : 'UI.ChartMeasureAttributeType',
            Measure : budget,
            Role    : #Axis1
        }],
        Dimensions          : [name],
        DimensionAttributes : [{
            $Type     : 'UI.ChartDimensionAttributeType',
            Dimension : name,
            Role      : #Category,
        }]
    },
    DataPoint #DP                     : {
        $Type : 'UI.DataPointType',
        Title : 'Sales Performance',
        Value : budget
    },
    Identification #NavToTeamsApp     : [{
        $Type          : 'UI.DataFieldForIntentBasedNavigation',
        SemanticObject : 'manage',
        Action         : 'teams'
    }],
    PresentationVariant #Presentation : {SortOrder : []}
});

annotate OverviewService.Employees with @(UI : {
    Chart #YearsOfExperience          : {
        Title               : '{i18n>Employees}',
        ChartType           : #Scatter,
        Measures            : [
            yearsOfExperience,
            salary
        ],
        MeasureAttributes   : [
            {
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : salary,
                Role    : #Axis1
            },
            {
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : yearsOfExperience,
                Role    : #Axis2
            }
        ],
        Dimensions          : [name],
        DimensionAttributes : [{
            $Type     : 'UI.ChartDimensionAttributeType',
            Dimension : name,
            Role      : #Category,
        }]
    },
    Identification #NavToEmployeesApp : [{
        $Type          : 'UI.DataFieldForIntentBasedNavigation',
        SemanticObject : 'manage',
        Action         : 'employees'
    }],
    PresentationVariant #Presentation : {SortOrder : []}
});

annotate OverviewService.Profile with @(UI : {
    HeaderInfo  : {
        $Type : 'UI.HeaderInfoType',
        TypeName : '{i18n>MyProfile}',
        TypeNamePlural : '{i18n>MyProfile}',
    },
    Chart #YearsOfExperience          : {
        Title               : '{i18n>Employees}',
        ChartType           : #Scatter,
        Measures            : [
            yearsOfExperience,
            salary
        ],
        MeasureAttributes   : [
            {
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : salary,
                Role    : #Axis1
            },
            {
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : yearsOfExperience,
                Role    : #Axis2
            }
        ],
        Dimensions          : [name],
        DimensionAttributes : [{
            $Type     : 'UI.ChartDimensionAttributeType',
            Dimension : name,
            Role      : #Category,
        }]
    },
    Identification #NavToEmployeesApp : [{
        $Type          : 'UI.DataFieldForIntentBasedNavigation',
        SemanticObject : 'manage',
        Action         : 'employees'
    }],
    PresentationVariant #Presentation : {SortOrder : []}
});
