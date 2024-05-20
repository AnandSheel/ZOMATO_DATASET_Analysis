# ZOMATO_DATASET_Analysis

Zomato Data Exploration and Analysis with MySQL.

Most of us know that Zomato is an Indian multinational restaurant aggregator and food delivery company. The idea of analysing the Zomato_dataset is to get an overview of what is happening in their business. Zomato Dataset consists of more than 9000 rows with columns such as Restaurants_id, Restaurants_name, City, Location, Cuisines, and many more...

## Data Exploration
  1. Table Details: Examined column names, data types, and constraints.
  2. Duplicate Check: Identified duplicates in the 'RestaurantId' column.
  3. Column Cleanup: Removed unnecessary columns.
  4. Table Merge: Combined tables to add a 'Country_Name' column using 'CountryCode' as the primary key.
  5. Correction: Fixed misspelled city names.
  6. Rolling Count: Calculated the number of restaurants using window functions.
  7. Statistics: Find the minimum, maximum, and average for votes, ratings, and currency.
  8. Rating Category: Created a new category column based on ratings.

## Data Analysis
  #### 1. Restaurant Distribution:

     • 90.67% of data is related to restaurants listed in India.

     • 4.45% of data is from the USA.
  #### 2. Online Delivery: Out of 15 Countries only 2 countries provide Online delivery options to their customers

     • Only India and UAE provide online delivery options.

     • 28.01% of Indian restaurants and 46.67% of UAE restaurants offer online delivery.
  #### 3. Focus on Indian Restaurants:

     • Connaught Place, New Delhi has the most restaurants (122), followed by Rajouri Garden (99) and Shahdara (87).

     • The most popular cuisine in Connaught Place is North Indian Food.

     • 54 out of 122 restaurants in Connaught Place offer table booking facilities to their customers.

     • Restaurants with table booking in Connaught Place have an average rating of 3.9/5, compared to 3.7/5 for those without table booking facilities.
  #### 4. Best Moderately Priced Restaurant:

     • Located in Kolkata, India: "India Restaurant" (RestaurantID - 20747).

     • Criteria: Average cost for two < 1000, rating > 4, votes > 4, offers both table booking and online delivery and serves Indian cuisine.
