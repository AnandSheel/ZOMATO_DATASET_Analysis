-- ZOMATO_DATA_EXPLORATION
SELECT * FROM zomato_dataset;

-- Check the Datatype of the table
SELECT 
	COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'zomato_dataset';

-- CHECKING FOR DUPLICATE

SELECT RestaurantID,COUNT(RestaurantID) FROM 
Zomato_Dataset
GROUP BY RestaurantID
ORDER BY 2 DESC;

SELECT * FROM country_codes;

-- REMOVING UNWANTED COLUMNS

DELETE FROM zomato_dataset
WHERE country_code IN ('Bar', 'Grill', 'Bakers & More', 'Chowringhee Lane', 'Grill & Bar', 'Chinese');

DELETE FROM zomato_dataset
WHERE RestaurantID = '18306543';

SELECT * FROM zomato_dataset;

-- COUNTRY CODE COLUMN

SELECT 
	A.Country_code, 
	B.Country
FROM zomato_dataset A JOIN country_codes B
ON A.country_code = B.country_code;

-- MERGING AND ADDING COUNTRY DETAILS FROM DIFFERENT TABLE THROUGH UPDATE WITH JOIN STATEMENT

ALTER TABLE zomato_dataset ADD country_name VARCHAR(50);

UPDATE zomato_dataset A
JOIN country_codes B
ON A.country_code = B.country_code
SET country_name = B.country;

-- IDENTIFYING IF THERE ARE ANY MISS-SPELLED WORD

SELECT 
	DISTINCT(City) 
FROM zomato_dataset
WHERE City LIKE "%?%";

-- REPLACING MISS-SPELLED WORD

SELECT 
	CASE 
		WHEN City = 'Bras?lia' THEN REPLACE(City, '?', 'i')
        WHEN City = "?stanbul" THEN REPLACE (City, "?", "i")
        WHEN City = 'S?o Paulo' THEN REPLACE(City, '?', "a")
        ELSE CITY
	END AS City_corrected
FROM zomato_dataset;

-- UPDATING WITH REPLACE STRING FUNCTION

UPDATE zomato_dataset A
JOIN (
	SELECT RestaurantID,
		CASE 
			WHEN City = 'Bras?lia' THEN REPLACE(City, '?', 'i')
			WHEN City = "?stanbul" THEN REPLACE (City, "?", "i")
			WHEN City = 'S?o Paulo' THEN REPLACE(City, '?', "a")
			ELSE CITY
		END AS City_corrected
	FROM zomato_dataset) B
ON A.RestaurantID = B.RestaurantID
SET A.City = B.City_corrected;
    
SELECT * FROM zomato_dataset;
    
-- COUNTING TOTAL REST. IN EACH CITY OF PARTICULAR COUNTRY
SELECT 
	country_name, city, 
    COUNT(city) AS total_rest
FROM zomato_dataset
GROUP BY country_name, city
ORDER BY 1, 2, 3 DESC;

SELECT * FROM zomato_dataset;

-- Locality count / Rolling count
SELECT 
	country_name, city, 
    Locality, 
    COUNT(Locality) AS Count_Locality,
    SUM(COUNT(Locality)) OVER(PARTITION BY City ORDER BY City, Locality) AS Roll_count
FROM zomato_dataset
WHERE country_name = 'India'
GROUP BY Locality, City
ORDER BY 1,2,3 DESC;
    
SELECT Count(Locality) FROM zomato_dataset
WHERE City LIKE "%Gurgaon";
SELECT * FROM zomato_dataset;

-- DROP COLUMN [LocalityVerbose], [Address]

ALTER TABLE zomato_dataset DROP COLUMN Address;
ALTER TABLE zomato_dataset DROP COLUMN LocalityVerbose;

-- cuisines columns

SELECT 
	Cuisines, COUNT(Cuisines) 
FROM zomato_dataset
WHERE Cuisines IS NULL OR Cuisines = ' '
GROUP BY Cuisines
ORDER BY 2 DESC;

SELECT 
	Cuisines ,COUNT(Cuisines) 
FROM zomato_dataset
GROUP BY Cuisines
ORDER BY 2 DESC;

-- CURRENCY COLUMN
SELECT 
	Currency, 
    COUNT(Currency)
FROM zomato_dataset
GROUP BY Currency
ORDER BY 2 DESC;

SELECT * FROM zomato_dataset;

-- YES/ NO Columns

SELECT DISTINCT(Has_Table_booking) FROM zomato_dataset;
SELECT DISTINCT(Has_Online_delivery) FROM zomato_dataset;
SELECT DISTINCT(Is_delivering_now) FROM zomato_dataset;
SELECT DISTINCT(Switch_to_order_menu) FROM zomato_dataset;

-- DROP Column Switch_to_order_menu

ALTER TABLE zomato_dataset DROP COLUMN Switch_to_order_menu;

SELECT * FROM zomato_dataset;

-- PRICE RANGE COLUMN
SELECT DISTINCT(Price_range) FROM zomato_dataset;

-- VOTES COLUMN (CHECKING MIN,MAX,AVG OF VOTE COLUMN)
ALTER TABLE zomato_dataset MODIFY COLUMN Votes INT;

SELECT MIN(Votes) AS MIN_VT,
       AVG(Votes) AS AVG_VT,
       MAX(Votes) AS MAX_VT
FROM zomato_dataset;

-- COST Column
ALTER TABLE zomato_dataset MODIFY COLUMN Average_Cost_for_two FLOAT;

SELECT 
	Currency, 
       ROUND(MIN(Average_Cost_for_two),2) AS MIN_CST,
       ROUND(AVG(Average_Cost_for_two),2) AS AVG_CST,
       ROUND(MAX(Average_Cost_for_two),2) AS MAX_CST
FROM zomato_dataset
GROUP BY Currency;

-- Rating Column
SELECT 
	MIN(Rating),
	ROUND(AVG(Rating),1),
	MAX(Rating)
FROM zomato_dataset;

ALTER TABLE zomato_dataset MODIFY COLUMN Rating DECIMAL;

SELECT Rating FROM zomato_dataset WHERE Rating >= 4;

SELECT
	Rating, 
    CASE
		WHEN Rating >= 1 AND Rating < 2.5 THEN "Poor"
        WHEN Rating >=2.5 AND Rating < 3.5 THEN "Good"
        WHEN Rating > 3.5 AND Rating < 4.5 THEN "Great"
        WHEN Rating >= 4.5 THEN "Excellent"
	END AS Rate_category
FROM zomato_dataset;

-- UPDATING NEW ADDED COLUMN WITH REFFERENCE OF AN EXISTING COLUMN
ALTER TABLE zomato_dataset ADD Rate_category VARCHAR(20);

UPDATE zomato_dataset                                     -- UPDATE WITH CASE-WHEN STATEMENT
SET Rate_Category  = (
	CASE
		WHEN Rating >= 1 AND Rating < 2.5 THEN "Poor"
        WHEN Rating >=2.5 AND Rating < 3.5 THEN "Good"
        WHEN Rating > 3.5 AND Rating < 4.5 THEN "Great"
        WHEN Rating >= 4.5 THEN "Excellent"
	END
);


