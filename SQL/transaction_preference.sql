

-- Which transaction_type do pple prefer to pay with & does it affect the sales

WITH transaction_sales  AS(
SELECT 
      "year",
	  transaction_type,
	  COUNT(transaction_type) AS tot_order,
	  SUM(transaction_amount) AS tot_sales,
	  SUM(SUM(transaction_amount))OVER() AS overall_sales
	  FROM sales_clean
	  GROUP BY transaction_type, "year")
SELECT 
      "year",
	  transaction_type,
	  tot_order,
	  tot_sales,
	  overall_sales,
	  ROUND((tot_sales/tot_order)*100,2) AS avg_sales_to_order
	  FROM transaction_sales
	  ORDER BY "year", avg_sales_to_order;