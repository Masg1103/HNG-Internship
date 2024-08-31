-- Create Database
CREATE DATABASE DA_AbenaGyasi;
USE DA_AbenaGyasi;

-- Droping and recreating tables
DROP TABLE IF EXISTS FactSales;
DROP TABLE IF EXISTS PartDim;
DROP TABLE IF EXISTS JobDim;
DROP TABLE IF EXISTS InvoiceDim;
DROP TABLE IF EXISTS VehicleDim;
DROP TABLE IF EXISTS CustomerDim;
DROP TABLE IF EXISTS Date;
DROP TABLE IF EXISTS LocationDim;
DROP PROCEDURE IF EXISTS PopulateDateDimension;

-- Create Date Table
CREATE TABLE Date (
    DateID INT PRIMARY KEY,
    Date DATE,
    DayOfWeek VARCHAR(10),
    Month VARCHAR(20),
    Quarter VARCHAR(2),
    Year INT,
    DayOfYear INT,
    IsWeekday BOOLEAN,
    IsWeekend BOOLEAN,
    IsHoliday BOOLEAN
);
DELIMITER $$
CREATE PROCEDURE PopulateDateDimension(StartDate DATE, EndDate DATE)
BEGIN
    DECLARE vDate DATE;
    DECLARE vDateID INT DEFAULT 1;
    SET vDate = StartDate;

    WHILE vDate <= EndDate DO
        INSERT INTO Date (DateID, Date, DayOfWeek, Month, Quarter, Year, DayOfYear, IsWeekday, IsWeekend, IsHoliday)
        VALUES (
			vDateID,
            vDate,
            DAYNAME(vDate),
            MONTHNAME(vDate),
            QUARTER(vDate),
            YEAR(vDate),
            DAYOFYEAR(vDate),
            CASE WHEN WEEKDAY(vDate) BETWEEN 0 AND 4 THEN 1 ELSE 0 END,
            CASE WHEN WEEKDAY(vDate) IN (5, 6) THEN 1 ELSE 0 END,
            0 -- Placeholder for holiday logic
        );
        SET vDate = DATE_ADD(vDate, INTERVAL 1 DAY);
        SET vDateID = vDateID + 1;
    END WHILE;
END$$
DELIMITER ;

CALL PopulateDateDimension('2023-01-01', '2024-12-31');

-- Create Customer Table
CREATE TABLE CustomerDim (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(40),
    Street VARCHAR(20),
    City VARCHAR(10),
    State VARCHAR(5),
    Zip VARCHAR(10),
    Phone VARCHAR(15)
);

-- Create Vehicle Table
CREATE TABLE VehicleDim (
    VehicleID INT PRIMARY KEY,
    VIN VARCHAR(25),
    Make VARCHAR(10),
    Model VARCHAR(10),
    Year INT,
    Color VARCHAR(10),
    Mileage INT,
	CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES CustomerDim(CustomerID)
);

-- Create Invoice Table
CREATE TABLE InvoiceDim (
    InvoiceID INT PRIMARY KEY,
    InvoiceDate DATE,
    Subtotal DECIMAL(5,2),
    SalesTaxRate DECIMAL(5,2),
    SalesTax DECIMAL(5,2),
    TotalLabour DECIMAL(5,2),
    TotalParts DECIMAL(5,2),
    Total DECIMAL(10,2),
    CustomerID INT,
    VehicleID INT,
    FOREIGN KEY (CustomerID) REFERENCES CustomerDim(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES VehicleDim(VehicleID)
);

-- Create Job Table
CREATE TABLE JobDim (
    JobID INT PRIMARY KEY,
    VehicleID INT,
    Description VARCHAR(40),
    Hours DECIMAL(5,2),
    Rate DECIMAL(5,2),
    Amount DECIMAL(5,2),
    InvoiceID INT,
    FOREIGN KEY (VehicleID) REFERENCES VehicleDim(VehicleID),
    FOREIGN KEY (InvoiceID) REFERENCES InvoiceDim(InvoiceID)
);

-- Create Part Table
CREATE TABLE PartDim (
    PartID INT PRIMARY KEY,
    JobID INT,
    PartNumber VARCHAR(6),
    PartName VARCHAR(20),
    Quantity INT,
    UnitPrice DECIMAL(5,2),
    Amount DECIMAL(5,2),
    InvoiceID INT,
    FOREIGN KEY (JobID) REFERENCES JobDim(JobID),
    FOREIGN KEY (InvoiceID) REFERENCES InvoiceDim(InvoiceID)
);

-- Create Location Table
CREATE TABLE LocationDim (
    LocationID INT PRIMARY KEY,
    ShopName VARCHAR(40),
    Street VARCHAR(20),
    City VARCHAR(10),
    State VARCHAR(5),
    Zip VARCHAR(10),
    Phone VARCHAR(15)
);

INSERT INTO LocationDim (LocationID, ShopName, Street, City, State, Zip, Phone)
VALUES (1, 'Latino Garage', '111McPhillips', 'Winnipeg', 'MB', 'R3J 1X7', '204-984-8458');

-- Sanity Check
Select * From LocationDim;

-- Create Factsales Table
CREATE TABLE FactSales (
    FactSalesID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    VehicleID INT,
    JobID INT,
    PartID INT,
    InvoiceID INT,
    DateID INT,
    LocationID INT,
    TotalSales DECIMAL(10,2),
    LaborCost DECIMAL(10,2),
    PartsCost DECIMAL(10,2),
    Profit DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES CustomerDim(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES VehicleDim(VehicleID),
    FOREIGN KEY (JobID) REFERENCES JobDim(JobID),
    FOREIGN KEY (PartID) REFERENCES PartDim(PartID),
    FOREIGN KEY (InvoiceID) REFERENCES InvoiceDim(InvoiceID),
    FOREIGN KEY (DateID) REFERENCES Date(DateID),
    FOREIGN KEY (LocationID) REFERENCES LocationDim(LocationID)
);

-- Load Customer data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE CustomerDim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, CustomerName, Street, City, State, Zip, Phone);

Select * From CustomerDim;

-- Load Vehicle data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vehicle.csv'
INTO TABLE VehicleDim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(VehicleID,  Make, Model, Year, Color, VIN, Mileage, CustomerID);

Select * From VehicleDim;

-- Load Invoice data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/invoice.csv'
INTO TABLE InvoiceDim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceID, InvoiceDate, Subtotal, SalesTaxRate, SalesTax, TotalLabour, TotalParts, Total, CustomerID, VehicleID);

Select * From InvoiceDim;

-- Load Job data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job.csv'
INTO TABLE JobDim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(JobID, VehicleID, Description, Hours, Rate, Amount, InvoiceID);

Select * From JobDim;

-- Load Part data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/parts.csv'
INTO TABLE PartDim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(PartID, JobID, PartNumber, PartName, Quantity, UnitPrice, Amount, InvoiceID);

select * From PartDim;

-- Data Cleaning
-- Jobs without matching parts
SELECT j.JobID, j.Description, j.InvoiceID
FROM JobDim j
LEFT JOIN PartDim p ON j.JobID = p.JobID
WHERE p.JobID IS NULL;

-- Update Part table to correct the association for Job ID 1
UPDATE PartDim
SET JobID = 1
WHERE PartID = 3 AND InvoiceID = 12345;

-- Update Part table to correct the association for Job ID 1
UPDATE PartDim
SET JobID = 3
WHERE PartID = 2 AND InvoiceID = 12345;

-- Insert missing part information for Job ID 4 (Oil change)
INSERT INTO PartDim (PartID, JobID, PartNumber, PartName, Quantity, UnitPrice, Amount, InvoiceID)
VALUES (11, 4, '76322', 'Oil Change Materials', 1, 86, 86, 12346);

-- Sanity check 
select * From PartDim;

-- Insert data into FactSales table ensuring unique job entries
INSERT INTO FactSales (CustomerID, VehicleID, JobID, PartID, InvoiceID, DateID, LocationID, TotalSales, LaborCost, PartsCost, Profit)
SELECT 
    i.CustomerID,
    j.VehicleID,
    j.JobID,
    p.PartID,
    i.InvoiceID,
    d.DateID,
    1, -- Assuming all data is from 'Latino Garage Winnipeg North'
    i.Total,
    j.Amount AS LaborCost,
    IFNULL(p.Amount, 0) AS PartsCost,
    (i.Total - j.Amount - IFNULL(p.Amount, 0)) AS Profit
FROM InvoiceDim i
JOIN Date d ON i.InvoiceDate = d.Date
JOIN JobDim j ON i.InvoiceID = j.InvoiceID
LEFT JOIN PartDim p ON j.JobID = p.JobID;

SELECT * FROM FactSales;

-- Data Analysis
-- Customer Analyis
--  Top 5 customers who have spent the most on vehicle repairs and parts
SELECT c.CustomerID, c.CustomerName, SUM(fs.TotalSales) AS TotalSpending
FROM CustomerDim c
INNER JOIN FactSales fs ON c.CustomerID = fs.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpending DESC
LIMIT 5;

-- Determine the average spending of customers on repairs and parts
SELECT AVG(TotalSpending) AS AverageSpendingPerCustomer
FROM (
  SELECT c.CustomerID, SUM(fs.TotalSales) AS TotalSpending
  FROM CustomerDim c
  INNER JOIN FactSales fs ON c.CustomerID = fs.CustomerID
  GROUP BY c.CustomerID
) AS CustomerSpending;

-- Analyze the frequency of customer visits and identify any patterns
SELECT c.CustomerID, COUNT(DISTINCT fs.InvoiceID) AS VisitFrequency
FROM CustomerDim c
INNER JOIN FactSales fs ON c.CustomerID = fs.CustomerID
GROUP BY c.CustomerID
ORDER BY VisitFrequency DESC;

-- Vehicle Analysis
-- Calculate the average mileage of vehicles serviced
SELECT AVG(Mileage) AS AverageMileage
FROM VehicleDim;

-- Identify the most common vehicle makes and models brought in for service
SELECT Make, Model, COUNT(*) AS VehicleCount
FROM VehicleDim
GROUP BY Make, Model
ORDER BY VehicleCount DESC
LIMIT 10;  

-- Analyze the distribution of vehicle ages and identify any trends in service requirements based on vehicle age
SELECT 
    CASE 
        WHEN YEAR(CURDATE()) - Year <= 2 THEN '0-2 Years'
        WHEN YEAR(CURDATE()) - Year BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN YEAR(CURDATE()) - Year BETWEEN 6 AND 8 THEN '6-8 Years'
        ELSE 'Older than 8 Years'
    END AS AgeGroup,
    COUNT(*) AS VehicleCount
FROM VehicleDim
GROUP BY AgeGroup;

SELECT 
    CASE 
        WHEN YEAR(CURDATE()) - v.Year <= 2 THEN '0-2 Years'
        WHEN YEAR(CURDATE()) - Year BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN YEAR(CURDATE()) - Year BETWEEN 6 AND 8 THEN '6-8 Years'
        ELSE 'Older than 8 Years'
    END AS AgeGroup,
    j.Description,
    COUNT(*) AS JobCount
FROM VehicleDim v
INNER JOIN JobDim j ON v.VehicleID = j.VehicleID
GROUP BY AgeGroup, j.Description
ORDER BY AgeGroup;

-- Job Performed Analysis
-- Determine the most common types of jobs performed and their frequency.
SELECT j.Description, COUNT(*) AS Frequency
FROM JobDim j
GROUP BY j.Description
ORDER BY Frequency DESC;

-- Calculate the total revenue generated from each type of job
SELECT j.Description, SUM(j.Amount) AS TotalRevenue
FROM JobDim j
GROUP BY j.Description
ORDER BY TotalRevenue DESC;


-- Sum total of all jobs combined
SELECT SUM(j.Amount) AS TotalRevenue
FROM JobDim j;

-- Identify the jobs with the highest and lowest average costs
SELECT j.Description, AVG(j.Amount) AS AverageCost
FROM JobDim j
GROUP BY j.Description
ORDER BY AverageCost DESC;

-- List the top 5 most frequently used parts and their total usage.
SELECT PartNumber, PartName, SUM(Quantity) AS TotalQuantity
FROM PartDim
GROUP BY PartNumber, PartName
ORDER BY TotalQuantity DESC
LIMIT 5;

-- Calculate the average cost of parts used in repairs.
SELECT AVG(UnitPrice) AS AveragePartCost
FROM PartDim;

-- Determine the total revenue generated from parts sales.
SELECT SUM(p.Amount) AS TotalPartsRevenue
FROM PartDim p;

-- Financial Analyis
-- Calculate the total revenue generated from labor and parts for each month
SELECT DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS Month, SUM(i.TotalLabour) AS TotalLaborRevenue, SUM(i.TotalParts) AS TotalPartsRevenue
FROM InvoiceDim i
GROUP BY Month
ORDER BY Month;

-- Determine the overall profitability of the repair shop.
SELECT SUM(i.Total) - SUM(i.TotalLabour + i.TotalParts) AS Profit
FROM InvoiceDim i;


SELECT SUM(Profit) AS OverallProfit
FROM FactSales;

