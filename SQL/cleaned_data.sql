CREATE TABLE sales (
order_id INT PRIMARY KEY,
"date" TEXT, 
item_name VARCHAR(100),
item_type VARCHAR(100),
item_price NUMERIC(10,2),
quantity INT,
transaction_amount NUMERIC(1000,2),
transaction_type VARCHAR(100),
received_by TEXT,
time_of_sale VARCHAR(100)
)


SELECT * FROM sales;

CREATE TABLE sales_clean AS
SELECT * FROM sales;

SELECT* FROM sales_clean;

/* updating NULL values, the Begin statement basically works as a mcm sep plc
for u to try ur update b u rly commit the update so eg if u update edi n its wrong,
u type rollback n evt will be rollbacked */

BEGIN;
UPDATE sales_clean
SET transaction_type = 'Unknown'
WHERE transaction_type IS NULL;
ROLLBACK;
COMMIT;


SELECT * FROM sales_clean
ORDER BY order_id;

/* how to convert a text "date" data type to date data type with multiple date formats 
and standardising into 1 date format */

ALTER TABLE sales_clean
ADD COLUMN date_clean DATE;

BEGIN;
UPDATE sales_clean
SET date_clean =
CASE 
    WHEN "date" ~ '^\d{2}/\d{2}/\d{4}$' 
	  AND SPLIT_PART("date",'/',1) :: INT > 12
	   THEN TO_DATE("date", 'DD/MM/YYYY')
	  
	WHEN "date" ~ '^\d{2}/\d{2}/\d{4}$' 
	 AND SPLIT_PART("date",'/',2) :: INT > 12
	  THEN TO_DATE("date", 'MM/DD/YYYY')
    
	WHEN "date" ~ '^\d{1}/\d{2}/\d{4}$' 
	 AND SPLIT_PART("date",'/',2) :: INT > 12
	  THEN TO_DATE("date", 'MM/DD/YYYY')
	 
	WHEN "date" ~ '^\d{2}-\d{2}-\d{4}$' 
	 THEN TO_DATE("date", 'DD/MM/YYYY')
	
	WHEN "date" ~ '^\d{2}/\d{2}/\d{4}$' 
	 THEN TO_DATE("date", 'DD/MM/YYYY')

ELSE NULL
END;

ROLLBACK;
COMMIT;

ALTER TABLE sales_clean
ADD COLUMN "year" INT;

BEGIN;
UPDATE sales_clean
SET "year" =
EXTRACT(YEAR FROM date_clean);

ALTER TABLE sales_clean
ADD COLUMN "month" INT;


BEGIN;
UPDATE sales_clean
SET "month" =
EXTRACT(MONTH FROM date_clean)

ALTER TABLE sales_clean
ADD COLUMN "day" INT;

BEGIN;
UPDATE sales_clean
SET "day" =
EXTRACT(DAY FROM date_clean);
COMMIT;


ALTER TABLE sales_clean
ADD COLUMN "week" INT;

BEGIN;
UPDATE sales_clean
SET "week" =
CASE 
    WHEN "day" BETWEEN 1 AND 7 THEN 1
	WHEN "day" BETWEEN 8 AND 14 THEN 2
	WHEN "day" BETWEEN 15 AND 21 THEN 3
	WHEN "day" BETWEEN 22 AND 31 THEN 4

ELSE NULL
END;
COMMIT;

BEGIN;

ALTER TABLE sales_clean
ADD COLUMN "month_name" TEXT;


UPDATE sales_clean
SET "month_name" =
TO_CHAR("date_clean", 'Month');

COMMIT;
