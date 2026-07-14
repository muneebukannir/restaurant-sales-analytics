
-- Revenue By Items n quantity sold

WITH rev_by_items AS(
SELECT 
     "year",
	 item_name,
	 item_type,
	 SUM(transaction_amount) AS sales,
	 SUM(SUM(transaction_amount)) OVER(PARTITION BY YEAR) AS tot_sales,
	 SUM(quantity) AS quantity_sold,
	 item_price
FROM sales_clean
GROUP BY "year", item_name,item_type, item_price
ORDER BY "year")
SELECT
      "year",
	  item_name,
	  item_type,
	  sales,
	  tot_sales,
	  ROUND((sales/tot_sales)*100,2) AS "rev_%",
	  quantity_sold,
	  item_price
FROM rev_by_items
ORDER BY "year",(sales/tot_sales)*100 DESC ;


WITH rev_by_items AS(
SELECT 
     "year",
	 "month",
	 "month_name",
	 item_name,
	 item_type,
	 SUM(transaction_amount) AS sales,
	 SUM(SUM(transaction_amount)) OVER(PARTITION BY MONTH,YEAR) AS tot_sales,
	 SUM(quantity) AS quantity_sold,
	 item_price
FROM sales_clean
GROUP BY "month_name","month", item_name,item_type, item_price, "year"
ORDER BY "year", "month")
SELECT
      "year",
      "month",
	  "month_name",
	  item_name,
	  item_type,
	  sales,
	  tot_sales,
	  ROUND((sales/tot_sales)*100,2) AS "rev_%",
	  quantity_sold,
	  item_price
FROM rev_by_items
ORDER BY "year", "month" ASC, (sales/tot_sales)*100 DESC ;
