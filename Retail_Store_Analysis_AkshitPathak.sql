SELECT Sub_Category , SUM(Sales), SUM(Quantity), SUM(Profit)
FROM retail.retail 
Group by Sub_Category;

SELECT Customer_ID, Customer_Name, SUM(Sales) AS total_sales
FROM retail.retail 
GROUP BY Customer_ID, Customer_Name
ORDER BY total_sales DESC
LIMIT 1;

SELECT Customer_ID, Customer_Name, COUNT(DISTINCT Region) AS UniqueRegions
FROM retail.retail
GROUP BY Customer_ID, Customer_Name
HAVING UniqueRegions > 1;

SELECT Category, (SUM(Sales) / (SELECT SUM(Sales) FROM retail.retail)) * 100 AS SalesPercentage
FROM retail.retail
GROUP BY Category;

WITH AvgQuantity AS (
    SELECT AVG(Quantity) AS OverallAvgQuantity
    FROM retail.retail
)
SELECT Sub-Category, AVG(Discount) AS AvgDiscount
FROM retail.retail
WHERE Quantity > (SELECT OverallAvgQuantity FROM AvgQuantity)
GROUP BY Sub_Category;


SELECT Sub_Category, Order_Date, Sales
FROM (
    SELECT Sub_Category, Order_Date, Sales,
           LAG(Sales, 1) OVER (PARTITION BY Product_ID ORDER BY Order_Date) AS PrevMonthSales,
           LAG(Sales, 2) OVER (PARTITION BY Product_ID ORDER BY Order_Date) AS TwoMonthsAgoSales
    FROM retail.retail
) AS SalesComparison
WHERE Sales > PrevMonthSales AND PrevMonthSales > TwoMonthsAgoSales
Group By Sub_Category ;



WITH AvgProfitPerOrder AS (
    SELECT City, AVG(Profit) AS CityAvgProfit
    FROM retail.retail
    GROUP BY City
)
SELECT City, CityAvgProfit
FROM AvgProfitPerOrder
WHERE CityAvgProfit < (SELECT AVG(Profit) FROM retail.retail);


SELECT Category, Order_Date, Profit,
       SUM(Profit) OVER (PARTITION BY Category ORDER BY Order_Date) AS CumulativeProfit
FROM  retail.retail;

SELECT *
FROM retail.retail
WHERE (Profit / Sales) > 0.2

SELECT Ship_Mode, AVG(Ship_Date-Order_Date) AS AvgShippingTime
FROM retail.retail
GROUP BY Ship_Mode;

SELECT YEAR(Order_Date) AS OrderYear, MONTH(Order_Date) AS OrderMonth, 
       SUM(Sales) AS TotalSales, SUM(Profit) AS TotalProfit
FROM retail.retail
GROUP BY OrderYear, OrderMonth
ORDER BY OrderYear, OrderMonth;