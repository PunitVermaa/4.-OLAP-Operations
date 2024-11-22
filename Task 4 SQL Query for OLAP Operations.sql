-- Database and Table Creation

-- Create the database
CREATE DATABASE sales_analysis1;

-- Create the sales_sample table
CREATE TABLE sales_sample (
    Product_Id INTEGER PRIMARY KEY,
    Region VARCHAR(50),
    Sales_Date DATE,
    Sales_Amount NUMERIC
);

-- Step 2: Insert Sample Data

INSERT INTO sales_sample (Product_Id, Region, Sales_Date, Sales_Amount) VALUES
(1, 'North', '2024-11-01', 1000),
(2, 'South', '2024-11-02', 1500),
(3, 'East', '2024-11-03', 2000),
(4, 'West', '2024-11-04', 1200),
(5, 'North', '2024-11-05', 1100),
(6, 'South', '2024-11-06', 1300),
(7, 'East', '2024-11-07', 1700),
(8, 'West', '2024-11-08', 1800),
(9, 'North', '2024-11-09', 1600),
(10, 'South', '2024-11-10', 1400);

-- Step 3: Perform OLAP Operations

-- Drill Down- Analyze sales data by breaking it down from the region level to the product level.

SELECT 
    Region, 
    Product_Id, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Region, Product_Id
ORDER BY 
    Region, Product_Id;

-- Rollup- Summarize sales data at different levels, such as region totals.

SELECT 
    Region, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    ROLLUP(Region);

-- Cube (Analyze Sales by Product, Region, and Date)- Generate aggregated data for all combinations of product, region, and date.

-- Aggregated by Product, Region, and Date
SELECT 
    Product_Id, 
    Region, 
    Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Product_Id, Region, Sales_Date

UNION ALL

-- Aggregated by Product and Region
SELECT 
    Product_Id, 
    Region, 
    NULL AS Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Product_Id, Region

UNION ALL

-- Aggregated by Region and Date
SELECT 
    NULL AS Product_Id, 
    Region, 
    Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Region, Sales_Date

UNION ALL

-- Aggregated by Product
SELECT 
    Product_Id, 
    NULL AS Region, 
    NULL AS Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Product_Id

UNION ALL

-- Aggregated by Region
SELECT 
    NULL AS Product_Id, 
    Region, 
    NULL AS Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Region

UNION ALL

-- Aggregated by Date
SELECT 
    NULL AS Product_Id, 
    NULL AS Region, 
    Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
GROUP BY 
    Sales_Date

UNION ALL

-- Overall Total
SELECT 
    NULL AS Product_Id, 
    NULL AS Region, 
    NULL AS Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample;
    
-- Slice (Filter Sales Data by Specific Region)- Analyze sales data for a specific region (e.g., North).

SELECT 
    Product_Id, 
    Sales_Date, 
    Sales_Amount
FROM 
    sales_sample
WHERE 
    Region = 'North';

-- Dice (Filter Sales Data for Multiple Conditions)- Analyze sales data for specific regions and a specific time range.

SELECT 
    Region, 
    Sales_Date, 
    SUM(Sales_Amount) AS Total_Sales
FROM 
    sales_sample
WHERE 
    Region IN ('North', 'South') 
    AND Sales_Date BETWEEN '2024-11-01' AND '2024-11-10'
GROUP BY 
    Region, Sales_Date
ORDER BY 
    Region, Sales_Date;
