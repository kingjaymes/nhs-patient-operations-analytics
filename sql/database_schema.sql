-- ============================================================
-- NHS Patient Operations & No-Show Analytics
-- Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS nhs_patient_operations;

USE nhs_patient_operations;


-- ============================================================
-- 1. PATIENTS
-- ============================================================

CREATE TABLE Patients (
    Patient_ID VARCHAR(10) PRIMARY KEY,
    Date_of_Birth DATE NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    Postcode_Area VARCHAR(10),
    GP_Practice VARCHAR(100),
    Registration_Date DATE NOT NULL,
    Long_Term_Condition BOOLEAN NOT NULL DEFAULT FALSE,
    Previous_No_Shows INT NOT NULL DEFAULT 0
);


-- ============================================================
-- 2. DEPARTMENTS
-- ============================================================

CREATE TABLE Departments (
    Department_ID VARCHAR(10) PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Department_Type VARCHAR(50) NOT NULL,
    Department_Head_Doctor_ID VARCHAR(10),
    Licensed_Beds INT NOT NULL DEFAULT 0,
    Standard_Hourly_Operating_Cost DECIMAL(10,2) NOT NULL,
    Active_Flag BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- 3. DOCTORS
-- ============================================================

CREATE TABLE Doctors (
    Doctor_ID VARCHAR(10) PRIMARY KEY,
    Doctor_Name VARCHAR(100) NOT NULL,
    Department_ID VARCHAR(10) NOT NULL,
    Specialty VARCHAR(100) NOT NULL,
    Grade VARCHAR(50) NOT NULL,
    Employment_Type VARCHAR(50) NOT NULL,
    Contracted_Hours_Per_Week DECIMAL(5,2) NOT NULL,
    Active_Flag BOOLEAN NOT NULL DEFAULT TRUE,

    FOREIGN KEY (Department_ID)
        REFERENCES Departments(Department_ID)
);


-- ============================================================
-- 4. CLINICS
-- ============================================================

CREATE TABLE Clinics (
    Clinic_ID VARCHAR(10) PRIMARY KEY,
    Clinic_Name VARCHAR(100) NOT NULL,
    Facility_Location_Code VARCHAR(20) NOT NULL,
    Department_ID VARCHAR(10) NOT NULL,
    Opening_Time TIME NOT NULL,
    Closing_Time TIME NOT NULL,
    Daily_Appointment_Capacity INT NOT NULL,

    FOREIGN KEY (Department_ID)
        REFERENCES Departments(Department_ID)
);


-- ============================================================
-- 5. APPOINTMENT TYPES
-- ============================================================

CREATE TABLE Appointment_Types (
    Appointment_Type_ID VARCHAR(10) PRIMARY KEY,
    Appointment_Type_Name VARCHAR(100) NOT NULL,
    Standard_Duration_Minutes INT NOT NULL
);


-- ============================================================
-- 6. REFERRAL SOURCES
-- ============================================================

CREATE TABLE Referral_Sources (
    Referral_Source_ID VARCHAR(10) PRIMARY KEY,
    Referral_Source_Name VARCHAR(100) NOT NULL
);


-- ============================================================
-- 7. APPOINTMENT STATUSES
-- ============================================================

CREATE TABLE Appointment_Statuses (
    Appointment_Status_ID VARCHAR(10) PRIMARY KEY,
    Status_Name VARCHAR(50) NOT NULL
);


-- ============================================================
-- 8. APPOINTMENTS
-- ============================================================

CREATE TABLE Appointments (
    Appointment_ID VARCHAR(12) PRIMARY KEY,
    Patient_ID VARCHAR(10) NOT NULL,
    Doctor_ID VARCHAR(10) NOT NULL,
    Department_ID VARCHAR(10) NOT NULL,
    Clinic_ID VARCHAR(10) NOT NULL,
    Appointment_Type_ID VARCHAR(10) NOT NULL,
    Referral_Source_ID VARCHAR(10) NOT NULL,
    Appointment_Status_ID VARCHAR(10) NOT NULL,

    Booking_Date DATE NOT NULL,
    Scheduled_Date_Time DATETIME NOT NULL,

    Arrival_Time DATETIME NULL,
    Consultation_Start_Time DATETIME NULL,
    Consultation_End_Time DATETIME NULL,

    Estimated_Appointment_Cost DECIMAL(10,2) NOT NULL,
    Satisfaction_Score DECIMAL(3,1) NULL,
    Follow_Up_Required BOOLEAN NOT NULL DEFAULT FALSE,

    FOREIGN KEY (Patient_ID)
        REFERENCES Patients(Patient_ID),

    FOREIGN KEY (Doctor_ID)
        REFERENCES Doctors(Doctor_ID),

    FOREIGN KEY (Department_ID)
        REFERENCES Departments(Department_ID),

    FOREIGN KEY (Clinic_ID)
        REFERENCES Clinics(Clinic_ID),

    FOREIGN KEY (Appointment_Type_ID)
        REFERENCES Appointment_Types(Appointment_Type_ID),

    FOREIGN KEY (Referral_Source_ID)
        REFERENCES Referral_Sources(Referral_Source_ID),

    FOREIGN KEY (Appointment_Status_ID)
        REFERENCES Appointment_Statuses(Appointment_Status_ID)
);