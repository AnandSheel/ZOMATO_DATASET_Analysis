-- ZOMATO_DATA_ANALYSIS

SELECT * FROM zomato_dataset;	

-- ROLLING/MOVING COUNT OF RESTAURANTS IN INDIAN CITIES
SELECT 
	country_name, 
    City, 
    Locality, COUNT(Locality) AS Total_Rest,
    SUM(COUNT(Locality)) OVER(PARTITION BY City ORDER BY Locality DESC) AS Roll_Count
FROM zomato_dataset
WHERE country_name = "India"
GROUP BY country_name, City, Locality
ORDER BY 1,2,3 DESC;

-- SEARCHING FOR PERCENTAGE OF RESTAURANTS IN ALL THE COUNTRIES

CREATE VIEW TOTAL_count AS (
	SELECT
		DISTINCT(country_name),
        (SELECT COUNT(*) FROM zomato_dataset) AS Total_Rest
	FROM zomato_dataset);
    
SELECT * FROM TOTAL_count;
    
WITH CTE1 AS (
	SELECT 
		country_name, 
        COUNT(RestaurantID) AS Rest_count
	FROM zomato_dataset
    GROUP BY country_name
)
SELECT 
	A.country_name,
    A.Rest_count,
    ROUND((A.Rest_count/B.Total_Rest)*100,2) AS Rest_pct_per_country
FROM CTE1 A JOIN Total_count B
ON A.country_name  =B.country_name
ORDER BY 3 DESC;

-- WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
	
WITH Country_Rest AS (
	SELECT 
		country_name, 
        COUNT(RestaurantID) AS Rest_count
	FROM zomato_dataset
    GROUP BY country_name
)
SELECT 
	A.country_name, 
    COUNT(A.RestaurantID) AS Total_Rest,
    ROUND((COUNT(A.RestaurantID)/B.Rest_Count)*100,2) AS online_delivery_pct
FROM zomato_dataset A 
	JOIN Country_Rest B
	ON A.country_name = B.country_name
WHERE A.Has_Online_delivery = 'Yes'
GROUP BY A.country_name,B.Rest_count
ORDER BY 2 DESC;

-- FINDING FROM WHICH CITY AND LOCALITY IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

SELECT * FROM zomato_dataset;

WITH CTE AS (
	SELECT 
		City, Locality,
		COUNT(RestaurantID) AS Rest_count
    FROM zomato_dataset
    WHERE country_name = "INDIA"
    GROUP BY City, Locality
    )
SELECT * 
FROM CTE 
ORDER BY Rest_count DESC
LIMIT 3;

-- TYPES OF FOODS ARE AVAILABLE IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

SELECT * FROM zomato_dataset;

WITH CTE1 AS (
	SELECT 
		City, Locality,
		COUNT(RestaurantID) AS Rest_count
    FROM zomato_dataset
    WHERE country_name = "INDIA"
    GROUP BY City, Locality
),
CTE2 AS (
	SELECT
		City, Locality, 
        Rest_count
	FROM CTE1 
    WHERE Rest_count = (SELECT MAX(Rest_count) FROM CTE1)
),
CTE3 AS (
	SELECT 
		City, Locality, 
        Cuisines
	FROm zomato_dataset
)
SELECT
	 A.Locality, 
     B.Cuisines
FROM CTE2 A JOIN CTE3 B
on
A.Locality = B.Locality;

SELECT * FROM zomato_dataset;

-- WHICH LOCALITIES IN INDIA HAS THE LOWEST RESTAURANTS LISTED IN ZOMATO
WITH CTE1 AS (
	SELECT 
		City, Locality,
		COUNT(RestaurantID) AS Rest_count
    FROM zomato_dataset
    WHERE country_name = "INDIA"
    GROUP BY City, Locality
)
SELECT * FROM CTE1 
WHERE Rest_count = (SELECT MIN(Rest_count) FROM CTE1)
ORDER BY City;

-- HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

WITH CTE1 AS (
	SELECT 
		City, Locality,
		COUNT(RestaurantID) AS Rest_count
    FROM zomato_dataset
    WHERE country_name = "INDIA"
    GROUP BY City, Locality
	),
CTE2 AS (
	SELECT * FROM CTE1
    WHERE Rest_count = (SELECT MAX(Rest_count) FROM CTE1)
    ),
CTE3 AS (
	SELECT 
		Locality, 
        Has_Table_booking AS Table_booking
        FROM zomato_dataset
	)
SELECT 
	A.Locality, 
    COUNT(B.Table_booking) AS Table_booking_option
FROM CTE2 A JOIN CTE3 B
ON A.Locality = B.Locality
WHERE B.Table_booking = "Yes"
GROUP BY A.Locality;

-- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
SELECT Has_Table_booking, 
       COUNT(*) AS TOTAL_REST, 
       ROUND(AVG(Rating), 2) AS AVG_RATING
FROM zomato_dataset
WHERE Locality = 'Connaught Place'
GROUP BY Has_Table_booking;

SELECT * FROM zomato_dataset;

-- Avg Rating OF RESTS Location wise

SELECT 
	country_name, 
    City, Locality,
    COUNT(RestaurantID) AS Total_Rest,
    ROUND(AVG(Rating),2) AS Avg_Rating
FROM zomato_dataset
GROUP BY country_name, Locality, City
ORDER BY 4 DESC;

-- FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
SELECT *
FROM zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
  AND Has_Table_booking = 'YES'
  AND Has_Online_delivery = 'YES'
  AND Price_range <= 3
  AND Votes > 1000
  AND Average_Cost_for_two < 1000
  AND Rating > 4
  AND Cuisines LIKE '%Indian%'
