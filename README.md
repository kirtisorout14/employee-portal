# Employee Management Portal — Phase 1: CAP Backend

This is the backend for the interview project. It's a real, runnable CAP
service — not pseudocode. Tested locally with an in-memory SQLite DB before
being handed to you.

## Run it

```bash
npm install
npm run watch      # or: npm start
```

Service comes up at `http://localhost:4004`. Try:

```
GET  /odata/v4/employee/Employees?$expand=department,address,contacts
GET  /odata/v4/employee/employeeCount()
POST /odata/v4/employee/deactivateEmployee   body: {"employeeId": "<ID>"}
```

Try posting an `Employees` record with no `name` — CAP's `@mandatory`
annotation rejects it automatically, before your custom handler even runs.

## What this phase covers

| File | Concept |
|---|---|
| `db/schema.cds` | CDS data modeling, `cuid`/`managed` aspects, associations vs. compositions |
| `srv/employee-service.cds` | Service definition, projections, bound actions, unbound function |
| `srv/employee-service.js` | Custom handlers (`before`/`on`/`after`), validation, deep read via `$expand` |
| `db/data/*.csv` | Local mocking / seed data |

## Next phase

Phase 2 adds the Fiori Elements UI on top of this service — CDS UI
annotations (`@UI.LineItem`, `@UI.Facets`), List Report + Object Page,
and draft handling.
