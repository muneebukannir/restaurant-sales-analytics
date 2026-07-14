
-- monthly sales 

WITH  monthly_sales AS( -- used a CTE to get column current_mon_sales
SELECT
     "year",
	 "month",
	 "month_name",
	 SUM(transaction_amount) AS current_mon_sales
	 FROM sales_clean
	 GROUP BY "month_name","year","month"
	 ORDER BY "month", "year"
),
mon_sales AS( -- used another CTE to get column prev_mon_sales from lag
SELECT
     "year",
	 "month",
	 "month_name",
	 current_mon_sales,
	 LAG(current_mon_sales) OVER(ORDER BY "year","month") AS prev_mon_sales -- if u order by month oni then data is inaccurate as nvr specify year
	 FROM monthly_sales
	 ORDER BY "year","month")
SELECT
     "year",
	 "month",
	 "month_name",
	 current_mon_sales,
	 prev_mon_sales,
	 ROUND(
          CASE WHEN prev_mon_sales IS NOT NULL AND prev_mon_sales != 0 -- != means not equal to
		       THEN ((current_mon_sales - prev_mon_sales)/prev_mon_sales * 100)
			   ELSE NULL END ,2) as "MoM_Growth_%" 
	FROM mon_sales
	ORDER BY "year","month";

-- yearly sales

WITH year_sales AS(
SELECT 
     "year",
	 SUM(transaction_amount) AS yearly_sales
	 FROM sales_clean
	 GROUP BY "year"
	 ORDER BY "year"),
yearly_sales AS(
SELECT 
     "year",
	 yearly_sales,
	 LAG(yearly_sales) OVER(ORDER BY YEAR) AS prev_yearly_sales
	 FROM year_sales
)
SELECT
     "year",
	 yearly_sales,
	 prev_yearly_sales,
	 ROUND(CASE
	           WHEN prev_yearly_sales IS NOT NULL AND prev_yearly_sales != 0 
			   THEN ((yearly_sales - prev_yearly_sales)/prev_yearly_sales)*100 
			   ELSE NULL END ,2 ) AS "YoY_Growth_%",
	FROM yearly_sales
	ORDER BY "year";
	 
	
