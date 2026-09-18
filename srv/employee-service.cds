using { empportal.db as db } from '../db/schema';

/**
 * EmployeeService — the OData V4 service. Projections rather than raw
 * entities so we control the exposed shape independently of the DB model.
 */
service EmployeeService @(path: '/odata/v4/employee') {

  entity Employees   as projection on db.Employees;
  entity Departments as projection on db.Departments;
  entity Addresses   as projection on db.Addresses;
  entity Contacts    as projection on db.Contacts;

  // Bound actions — operate on one Employee record
  action activateEmployee(employeeId: Employees:ID)   returns Employees;
  action deactivateEmployee(employeeId: Employees:ID) returns Employees;

  // Unbound function — simple read-only computation
  function employeeCount() returns Integer;
}
