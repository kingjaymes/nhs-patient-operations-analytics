# Data Model

## 1. Purpose

This document defines the relational data model for the NHS Patient Operations & No-Show Analytics project.

The model is designed to support analysis of patient attendance, appointment timing, clinical operations, departmental performance, and the estimated operational cost of unused appointment capacity.

The database uses a normalized relational structure, with `Appointments` serving as the central transaction table.

---

## 2. Appointment Grain

The grain of the `Appointments` table is:

> **One row represents one scheduled patient appointment.**

A patient may therefore have multiple appointment records over the analysis period.

---

## 3. Core Tables

### Patients

Stores patient demographic and registration information.

| Column              | Key |
| ------------------- | --- |
| Patient_ID          | PK  |
| Date_of_Birth       |     |
| Gender              |     |
| Postcode_Area       |     |
| GP_Practice         |     |
| Registration_Date   |     |
| Long_Term_Condition |     |
| Previous_No_Shows   |     |

### Doctors

Stores information about doctors and their employment characteristics.

| Column                    | Key |
| ------------------------- | --- |
| Doctor_ID                 | PK  |
| Doctor_Name               |     |
| Department_ID             | FK  |
| Specialty                 |     |
| Grade                     |     |
| Employment_Type           |     |
| Contracted_Hours_Per_Week |     |
| Active_Flag               |     |

### Departments

Stores information about clinical departments.

| Column                         | Key |
| ------------------------------ | --- |
| Department_ID                  | PK  |
| Department_Name                |     |
| Department_Type                |     |
| Department_Head_Doctor_ID      | FK  |
| Licensed_Beds                  |     |
| Standard_Hourly_Operating_Cost |     |
| Active_Flag                    |     |

### Clinics

Stores information about appointment locations and capacity.

| Column                     | Key |
| -------------------------- | --- |
| Clinic_ID                  | PK  |
| Clinic_Name                |     |
| Facility_Location_Code     |     |
| Department_ID              | FK  |
| Opening_Time               |     |
| Closing_Time               |     |
| Daily_Appointment_Capacity |     |

### Appointments

The central transaction table. Each row represents one scheduled appointment.

| Column                     | Key |
| -------------------------- | --- |
| Appointment_ID             | PK  |
| Patient_ID                 | FK  |
| Doctor_ID                  | FK  |
| Department_ID              | FK  |
| Clinic_ID                  | FK  |
| Appointment_Type_ID        | FK  |
| Referral_Source_ID         | FK  |
| Appointment_Status_ID      | FK  |
| Booking_Date               |     |
| Scheduled_Date_Time        |     |
| Arrival_Time               |     |
| Consultation_Start_Time    |     |
| Consultation_End_Time      |     |
| Estimated_Appointment_Cost |     |
| Satisfaction_Score         |     |
| Follow_Up_Required         |     |

### Appointment_Types

Defines the type of appointment.

| Column                    | Key |
| ------------------------- | --- |
| Appointment_Type_ID       | PK  |
| Appointment_Type_Name     |     |
| Standard_Duration_Minutes |     |

### Referral_Sources

Defines how patients entered the service.

| Column               | Key |
| -------------------- | --- |
| Referral_Source_ID   | PK  |
| Referral_Source_Name |     |

### Appointment_Statuses

Defines the outcome/status of an appointment.

| Column                | Key |
| --------------------- | --- |
| Appointment_Status_ID | PK  |
| Status_Name           |     |

---

## 4. Relationships

The primary relationships are:

* One patient can have many appointments.
* One doctor can have many appointments.
* One department can have many appointments.
* One clinic can have many appointments.
* One appointment type can apply to many appointments.
* One referral source can apply to many appointments.
* One appointment status can apply to many appointments.

Conceptually:

```text
Patients 1 ───────── * Appointments
Doctors 1 ────────── * Appointments
Departments 1 ────── * Appointments
Clinics 1 ────────── * Appointments
Appointment_Types 1 ─ * Appointments
Referral_Sources 1 ─ * Appointments
Appointment_Statuses 1 ─ * Appointments
```

---

## 5. Derived Metrics

The following metrics will be calculated rather than stored directly in the transaction table:

* Booking Lead Days
* Clinic Wait Minutes
* Consultation Duration
* No-Show Rate
* Cancellation Rate
* Clinic Utilisation
* Doctor Utilisation
* Estimated Cost of Missed Appointments
* Repeat No-Show Rate

This reduces unnecessary duplication and allows metrics to be recalculated consistently.

---

## 6. Design Principles

The model follows these principles:

1. Each table has a clearly defined business purpose.
2. Primary keys uniquely identify records.
3. Foreign keys establish relationships between related entities.
4. The `Appointments` table represents the central unit of analysis.
5. Derived analytical metrics are calculated from underlying data where appropriate.
6. Personally identifiable information that is unnecessary for analysis is excluded.
7. The model is designed to support SQL analysis and downstream Power BI reporting.
