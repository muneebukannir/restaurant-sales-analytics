

-- busiest time 

SELECT 
      "year",
      time_of_sale,
	  SUM(quantity) AS quantity_sold,
	  SUM(transaction_amount) AS tot_sales,
	  COUNT(time_of_sale) AS tot_order
	  FROM sales_clean
	  GROUP BY time_of_sale, "year"
	  ORDER BY quantity_sold DESC ,"year";	

