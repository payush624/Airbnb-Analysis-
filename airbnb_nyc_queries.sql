-- room_types listing

SELECT 
	room_type,
	count(id) as no_of_listings
FROM airbnb_nyc
GROUP BY room_type
ORDER BY COUNT(id) DESC

-- lisitng by neighbourhood

SELECT 
	neighbourhood_group,
	count(id) no_of_listings,
	ROUND(AVG(price),2) as avg_price
FROM airbnb_nyc
GROUP BY neighbourhood_group
ORDER BY no_of_listings DESC

-- listing by areas

SELECT 
	neighbourhood as areas,
	count(id) no_of_listings
FROM airbnb_nyc
GROUP BY neighbourhood
ORDER BY no_of_listings DESC

-- top 5 lisitings by neighbourhood

WITH top_listings AS 
(
SELECT 
	neighbourhood_group,
	name,
	SUM(number_of_reviews) total_reviews,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY SUM(number_of_reviews) DESC) rnk
FROM airbnb_nyc
GROUP BY neighbourhood_group,
		 name
)
SELECT 
	neighbourhood_group,
	name,
	total_reviews
FROM top_listings
WHERE rnk<= 5



-- Lets check how many % of people have multiple lisitngs 

WITH listing_pct AS (
SELECT 
	host_id,
	CASE WHEN count(id) > 1 THEN 'Multiple Listing' ELSE 'Single Lisitng' END listing_category
FROM airbnb_nyc
GROUP BY host_id
	)
SELECT
	listing_category,
	ROUND((count(listing_category)*1.0 / (SELECT count(*) FROM listing_pct))*100,2) AS percentage
FROM listing_pct
GROUP BY listing_category

-- Top 10 hosts

SELECT
	DISTINCT host_name,
	calculated_host_listings_count
FROM airbnb_nyc
ORDER BY calculated_host_listings_count DESC
LIMIT 10
	
-- Average minium nights by each neighbourhood_group
SELECT 
	neighbourhood_group,
	ROUND(AVG(minimum_nights)) AS avg_minimum_nights_available
FROM airbnb_nyc
GROUP BY neighbourhood_group
ORDER BY avg_minimum_nights_available DESC

SELECT 
	DISTINCT room_type
FRom airbnb_nyc

-- Types of room listed
SELECT 
	DISTINCT room_type
FROM airbnb_nyc


-- Room type listing analysis
SELECT
	neighbourhood_group,
	SUM(CASE WHEN room_type IN ('Hotel room') THEN 1 ELSE 0 END) Hotel_Room,
	SUM(CASE WHEN room_type IN ('Private room') THEN 1 ELSE 0 END) Private_Room,
	SUM(CASE WHEN room_type IN ('Shared room') THEN 1 ELSE 0 END) Shared_Room,
	SUM(CASE WHEN room_type IN ('Entire home/apt') THEN 1 ELSE 0 END) Entire_home_apt
FROM airbnb_nyc
GROUP BY neighbourhood_group

-- checking on avg how many days rooms are available by each neighbourhood
SELECT 
	neighbourhood_group,
	ROUND(AVG(availability_365)) AS avg_availability
FROM airbnb_nyc
GROUP BY neighbourhood_group

-- avg minimum nights
SELECT 
	neighbourhood_group,
	ROUND(AVG(minimum_nights)) AS avg_minimum_nights
FROM airbnb_nyc
GROUP BY neighbourhood_group

-- lets check which month has recent review (from below result we can see that most reviews were made on 2022-08, so we can say that it was a peak month)
SELECT 
	to_char(last_review,'YYYY-MM') recent_review_on,
	COUNT(to_char(last_review,'YYYY-MM')) total_review_by_month_year
FROM airbnb_nyc
WHERE last_review is NOT NULL
GROUP BY to_char(last_review,'YYYY-MM') 
ORDER BY recent_review_on DESC 






	