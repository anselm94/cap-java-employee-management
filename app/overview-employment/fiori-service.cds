/*
  Annotations for the Manage Books App
*/

using OverviewService from '../../srv/overview-service';

annotate OverviewService.Parameters with @UI.SelectionFields : [ID];

annotate OverviewService.Teams with @(UI : {
    LineItem #List                         : [
        {
            $Type : 'UI.DataField',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Value : location,
        },
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#DP',
        },
    ],
    Chart #BudgetOverview                  : {
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
    DataPoint #DP                          : {
        $Type : 'UI.DataPointType',
        Title : 'Team Budget',
        Value : budget
    },
    Identification #NavToTeamsApp          : [{
        $Type          : 'UI.DataFieldForIntentBasedNavigation',
        SemanticObject : 'manage',
        Action         : 'teams'
    }]
});

annotate OverviewService.Employees with @(
    Communication.Contact : {
        fn    : name,
        photo : imgUrl,
        org   : membership.team.name,
        role  : membership.position,
        tel   : [],
        email : [{
            type    : [
                #preferred,
                #work
            ],
            address : email
        }]
    },
    UI                    : {
        HeaderInfo                        : {
            $Type          : 'UI.HeaderInfoType',
            TypeName       : '{i18n>Employee}',
            TypeNamePlural : '{i18n>Employees}',
            Title          : {
                $Type : 'UI.DataField',
                Label : '{i18n>Name}',
                Value : name,
            },
            Description    : {
                $Type : 'UI.DataField',
                Label : '{i18n>YearsOfExperience}',
                Value : yearsOfExperience
            },
            ImageUrl       : imgUrl,
            TypeImageUrl   : imgUrl
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
    }
);

