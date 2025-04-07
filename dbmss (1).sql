SELECT * FROM supermarket_sales;
--create table 
CREATE TABLE supermarket_sales (
    Invoice_ID VARCHAR(20) PRIMARY KEY,
    Branch CHAR(1),
    City VARCHAR(50),
    Customer_type VARCHAR(20),
    Gender VARCHAR(10),
    Product_line VARCHAR(100),
    Unit_price DECIMAL(10,2),
    Quantity INT,
    Tax_5 DECIMAL(10,2),
    Total DECIMAL(10,2),
    Date DATE,
    Time TIME,
    Payment VARCHAR(20),
    cogs DECIMAL(10,2),
    gross_margin_percentage DECIMAL(10,6),
    gross_income DECIMAL(10,2),
    Rating DECIMAL(3,1)
);


--Q1 Total rupee Sales Per Branch

SELECT Branch, SUM(Total) AS Total_Sales FROM supermarket_sales 
GROUP BY Branch;

-- Q2 TOTAL number of sales per branch
SELECT branch , COUNT(*) AS Total_count FROM supermarket_sales 
GROUP BY Branch ;

--Q3 average customer rating for each product line and average unit price of each product line
SELECT "product_line", AVG(rating) AS avg_rating , AVG("unit_price") AS avg_unit_price 
FROM supermarket_sales 
GROUP BY "product_line";


--Q4  total payment method and total sales from each payment method?
SELECT DISTINCT payment , SUM(TOTAL) AS total_sum z
FROM supermarket_sales 
GROUP BY payment;


--Q5 Which branch  and city  has the highest gross income?
SELECT branch,  city,  SUM(gross_income) AS total_gross_income
FROM supermarket_sales
GROUP BY branch , city 
ORDER BY total_gross_income  DESC
LIMIT 1;

--Q6 Calculate total gross margin for each month

SELECT 
    TO_CHAR(TO_DATE(Date, 'MM/DD/YYYY'), 'YYYY-MM') AS month, 
    SUM("gross_income") AS total_gross_income
FROM supermarket_sales
GROUP BY month
ORDER BY month;

--Q7  Best-Selling Product Line
SELECT "product_line" , SUM(total) AS total_revenue
FROM supermarket_sales
GROUP BY "product_line"
ORDER BY total_revenue DESC
LIMIT 1; 

--Q8 SELECT Most Preferred Payment Method

SELECT 
    Payment, 
    COUNT(*) AS total_transactions , SUM(total) AS total_amount
FROM supermarket_sales
GROUP BY Payment
ORDER BY total_transactions DESC
LIMIT 3;

--Q9 Average Spending per Customer Type and gender
SELECT 
    customer_type, 
    gender, 
    ROUND(AVG(total), 2) AS avg_spending
FROM supermarket_sales
GROUP BY customer_type, gender
ORDER BY avg_spending DESC;


--Q10 branch and city-Wise Monthly Revenue
SELECT 
    Branch, 
    City,
    TO_CHAR(TO_DATE(Date, 'MM/DD/YYYY'), 'YYYY-MM') AS month, 
    SUM(Total) AS total_revenue
FROM supermarket_sales
GROUP BY Branch, City, month
ORDER BY Branch, month;


--Q11 top 3 most profitable product lines per city.




WITH Profit_Calculation AS (
    SELECT 
        City,
        Product_line,
        SUM(Total - (Quantity * Unit_price)) AS Total_Profit
    FROM supermarket_sales
    GROUP BY City, Product_line
),
Top_Products AS (
    SELECT 
        City, 
        Product_line, 
        Total_Profit,
        ROW_NUMBER() OVER (PARTITION BY City ORDER BY Total_Profit DESC) AS Row_Num
    FROM Profit_Calculation
)
SELECT City, Product_line, Total_Profit
FROM Top_Products
WHERE Row_Num <= 3
ORDER BY City, Total_Profit DESC;


 










