using EmployeeService as service from './employee-service';

// =========================================================================
// List Report — Employees
// =========================================================================

annotate service.Employees with @(

  UI.HeaderInfo : {
    TypeName       : 'Employee',
    TypeNamePlural : 'Employees',
    Title          : { Value: name },
    Description    : { Value: employeeId }
  },

  // Drives the SmartFilterBar / FE filter bar fields on the List Report
  UI.SelectionFields : [
    employeeId,
    name,
    department_ID,
    status
  ],

  // Drives the List Report table columns
  UI.LineItem : [
    { Value: employeeId,      Label: 'Employee ID' },
    { Value: name,             Label: 'Name' },
    { Value: department.name, Label: 'Department' },
    { Value: email,            Label: 'Email' },
    {
      Value       : status,
      Label       : 'Status',
      Criticality : statusCriticality
    }
  ],

  // Object Page layout: one general-info section, plus sub-object-node
  // sections for the composition children
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'GeneralInfoFacet',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#GeneralInfo'
    },
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'AddressFacet',
      Label  : 'Address',
      Target : 'address/@UI.FieldGroup#AddressInfo'
    },
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'ContactsFacet',
      Label  : 'Contacts',
      Target : 'contacts/@UI.LineItem'
    }
  ],

  UI.FieldGroup #GeneralInfo : {
    Data : [
      { Value: employeeId },
      { Value: name },
      { Value: email },
      { Value: department_ID, Label: 'Department' },
      { Value: status }
    ]
  }
);

// =========================================================================
// Object Page sub-sections — Address (1:1 composition) and Contacts (1:n)
// =========================================================================

annotate service.Addresses with @(
  UI.FieldGroup #AddressInfo : {
    Data : [
      { Value: street },
      { Value: city },
      { Value: state },
      { Value: zipCode },
      { Value: country }
    ]
  }
);

annotate service.Contacts with @(
  UI.LineItem : [
    { Value: type,  Label: 'Type' },
    { Value: value, Label: 'Value' }
  ]
);

// =========================================================================
// Value Help — Department (dialog-based: dynamic, growing entity list)
// =========================================================================
// Text + TextArrangement give the LineItem/FieldGroup a readable department
// name instead of the raw GUID; Common.ValueList wires up the F4 dialog.

annotate service.Employees {
  department_ID @(
    Common.Label            : 'Department',
    Common.Text             : department.name,
    Common.TextArrangement  : #TextOnly,
    Common.ValueList        : {
      Label          : 'Departments',
      CollectionPath : 'Departments',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterInOut',
          LocalDataProperty : department_ID,
          ValueListProperty : 'ID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'name'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'costCenter'
        }
      ]
    }
  )
};

// =========================================================================
// Fixed Values — Status (rendered as a dropdown, no F4 dialog)
// =========================================================================
// ValueListWithFixedValues tells Fiori Elements to skip the dialog and
// render a select list instead, backed by the small StatusValues entity.

annotate service.Employees {
  status @(
    Common.Label                     : 'Status',
    Common.ValueListWithFixedValues  : true,
    Common.ValueList                 : {
      Label          : 'Status',
      CollectionPath : 'StatusValues',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterInOut',
          LocalDataProperty : status,
          ValueListProperty : 'code'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'text'
        }
      ]
    }
  )
};
