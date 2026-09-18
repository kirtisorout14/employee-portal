const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Employees } = this.entities;

  // --- Validation -----------------------------------------------------

  this.before('CREATE', 'Employees', (req) => {
    if (!req.data.name) req.error(400, 'Name is required');
    if (!req.data.employeeId) req.error(400, 'Employee ID is required');
  });

  this.before('UPDATE', 'Employees', (req) => {
    if (req.data.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(req.data.email)) {
      req.error(400, 'Invalid email format');
    }
  });

  // --- Custom actions ---------------------------------------------------

  this.on('activateEmployee', async (req) => {
    const { employeeId } = req.data;
    await UPDATE(Employees, employeeId).with({ status: 'ACTIVE', statusCriticality: 3 });
    return SELECT.one.from(Employees).where({ ID: employeeId });
  });

  this.on('deactivateEmployee', async (req) => {
    const { employeeId } = req.data;
    await UPDATE(Employees, employeeId).with({ status: 'INACTIVE', statusCriticality: 1 });
    return SELECT.one.from(Employees).where({ ID: employeeId });
  });

  // --- Custom function ---------------------------------------------------

  this.on('employeeCount', async () => {
    const result = await SELECT.one`count(*) as count`.from(Employees);
    return result.count;
  });

  // --- Post-processing ----------------------------------------------------

  this.after('READ', 'Employees', (employees) => {
    const list = Array.isArray(employees) ? employees : [employees];
    list.forEach((emp) => {
      if (emp) emp.statusCriticality = emp.status === 'ACTIVE' ? 3 : 1;
    });
  });
});
