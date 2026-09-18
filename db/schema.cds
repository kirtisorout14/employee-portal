namespace empportal.db;

using { cuid, managed } from '@sap/cds/common';

/**
 * Departments — simple master data, referenced by Employees.
 */
entity Departments : cuid {
  name        : String(100) @mandatory;
  costCenter  : String(20);
  employees   : Association to many Employees on employees.department = $self;
}

/**
 * Employees — the core entity. Uses `managed` to auto-track
 * createdAt/createdBy/modifiedAt/modifiedBy (shows you know CAP's
 * built-in aspects instead of hand-rolling audit fields).
 */
entity Employees : cuid, managed {
  employeeId        : String(10)  @mandatory;
  name              : String(100) @mandatory;
  email             : String(120);
  status            : String(20)  default 'ACTIVE'; // ACTIVE | INACTIVE
  statusCriticality : Integer     default 3;         // drives UI.Criticality later
  department        : Association to Departments;
  address           : Composition of one  Addresses on address.employee  = $self;
  contacts          : Composition of many Contacts  on contacts.employee = $self;
}

/**
 * Addresses — owned by Employee (Composition = deleted with the parent,
 * deep-create target). One-to-one via a to-one composition.
 */
entity Addresses : cuid {
  employee : Association to Employees;
  street   : String(100);
  city     : String(50);
  state    : String(50);
  zipCode  : String(10);
  country  : String(2) default 'IN';
}

/**
 * Contacts — owned by Employee, one-to-many. Lets the deep-create demo
 * (Employee + Address + multiple Contacts in a single POST) be real.
 */
entity Contacts : cuid {
  employee : Association to Employees;
  type     : String(20); // PHONE | EMAIL | EMERGENCY
  value    : String(50);
}
