-- Create the database
CREATE DATABASE HealthInsurance;
USE HealthInsurance;

-- Create the Patients table
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100)
);

-- Create the InsurancePolicies table
CREATE TABLE IF NOT EXISTS InsurancePolicies (
    PolicyID INT AUTO_INCREMENT PRIMARY KEY,
    PolicyNumber VARCHAR(50),
    PatientID INT,
    CoverageAmount DECIMAL(10, 2),
    PolicyType VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Create the Treatments table
CREATE TABLE IF NOT EXISTS Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentName VARCHAR(100),
    TreatmentCost DECIMAL(10, 2)
);

-- Create the Claims table
CREATE TABLE IF NOT EXISTS Claims (
    ClaimID INT AUTO_INCREMENT PRIMARY KEY,
    PolicyID INT,
    ClaimDate DATE,
    ClaimStatus VARCHAR(20),
    ClaimAmount DECIMAL(10, 2),
    TreatmentID INT,
    FOREIGN KEY (PolicyID) REFERENCES InsurancePolicies(PolicyID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID)
);

-- Create the Payments table
CREATE TABLE IF NOT EXISTS Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    ClaimID INT,
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID)
);

-- Insert sample data into Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber, Email)
VALUES
('John', 'Doe', '1980-01-15', 'Male', '123 Elm St', '555-1234', 'john.doe@example.com'),
('Jane', 'Smith', '1992-07-22', 'Female', '456 Oak St', '555-5678', 'jane.smith@example.com');

-- Insert sample data into InsurancePolicies
INSERT INTO InsurancePolicies (PolicyNumber, PatientID, CoverageAmount, PolicyType, StartDate, EndDate)
VALUES
('POL12345', 1, 10000.00, 'Health', '2024-01-01', '2024-12-31'),
('POL67890', 2, 15000.00, 'Dental', '2024-01-01', '2024-12-31');

-- Insert sample data into Treatments
INSERT INTO Treatments (TreatmentName, TreatmentCost)
VALUES
('Blood Test', 150.00),
('X-Ray', 300.00),
('MRI Scan', 500.00);

-- Insert sample data into Claims
INSERT INTO Claims (PolicyID, ClaimDate, ClaimStatus, ClaimAmount, TreatmentID)
VALUES
(1, '2024-03-15', 'Pending', 150.00, 1),
(1, '2024-04-01', 'Approved', 300.00, 2),
(2, '2024-05-10', 'Denied', 500.00, 3);

-- Insert sample data into Payments
INSERT INTO Payments (ClaimID, PaymentDate, PaymentAmount)
VALUES
(1, '2024-04-01', 150.00),
(2, '2024-04-15', 300.00);

-- Queries

-- 1. Track the status of claims
SELECT ClaimID, ClaimStatus
FROM Claims;

-- 2. Calculate claim amounts based on treatments and policy coverage
SELECT c.ClaimID, SUM(t.TreatmentCost) AS TotalClaimAmount
FROM Claims c
JOIN Treatments t ON c.TreatmentID = t.TreatmentID
GROUP BY c.ClaimID;

-- 3. Generate reports

-- Claim Approval Rates
SELECT ClaimStatus, COUNT(*) AS NumberOfClaims
FROM Claims
GROUP BY ClaimStatus;

-- Total Claims Processed
SELECT COUNT(*) AS TotalClaims
FROM Claims;

-- Insurance Payouts
SELECT SUM(p.PaymentAmount) AS TotalPayments
FROM Payments p
JOIN Claims c ON p.ClaimID = c.ClaimID
WHERE c.ClaimStatus = 'Approved';

SHOW TABLES;
-- SELECT * FROM Patients;
SELECT * FROM InsurancePolicies;
-- SELECT * FROM Treatments;
-- SELECT * FROM Claims;
-- SELECT * FROM Payments;