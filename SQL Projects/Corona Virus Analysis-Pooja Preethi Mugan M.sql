-- Displying the table contents

select * from coronadataset;





-- altering the column name for convinence 

ALTER TABLE coronadataset RENAME COLUMN `Country/Region` TO country;
select *  from coronadataset;

--  1] Checking for null 
select * from coronadataset
where Province is null or country is null or 
 Latitude is null or Longitude is null or
 Confirmed is null or Deaths is null or
 Recovered is null ;
 
 select 
 sum(case when province is null then 1 else 0 end) as Province_Null_Count,
 sum(case when country is null then 1 else 0 end) as Country_Null_Count,
 sum(case when Latitude is null then 1 else 0 end) as Latitude_Null_Count,
 sum(case when longitude is null then 1 else 0 end) as Longitude_Null_Count,
 sum(case when `Date` is null then 1 else 0 end) as date_Null_Count,
 sum(case when confirmed is null then 1 else 0 end) as confrimed_Null_Count, 
 sum(case when Deaths is null then 1 else 0 end) as Deaths_Null_Count, 
 sum(case when Recovered is null then 1 else 0 end) as Recovered_Null_Count
from coronadataset;

--  Q2] If NULL values are present, update them with zeros for all columns. 

select     Province = coalesce(`Province`,0),
Country =coalesce(`Country`,0),Latitude =coalesce(`Latitude`,0),
Longitude =coalesce(`Longitude` ,0),`Date` =coalesce(`Date`,0),
confirmed=coalesce(`confirmed`,0),Deaths =coalesce(`Deaths`,0),
Recovered =coalesce(`Recovered`,0) from coronadataset;

-- Q3. check total number of rows

select count(*) as Number_of_rows from coronadataset;	

-- Q4. Check what is start_date and end_date
 --adding a couloum 
ALTER TABLE coronadataset
ADD COLUMN corona_date DATE;

SET SQL_SAFE_UPDATES = 0;

-- updating the new coloumn 
UPDATE coronadataset
SET corona_date = STR_TO_DATE(`Date`, '%d-%m-%Y')
WHERE province IS NOT NULL;

-- displaying the start and end date 
select  min(corona_date) as start_date  ,max(corona_date) end_date from coronadataset;

SET SQL_SAFE_UPDATES = 1;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT DATE_FORMAT(corona_date, '%Y-%m')) AS number_of_unique_month_years
FROM coronadataset;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(corona_date, '%Y-%m') AS month,
    AVG(confirmed) AS avg_confirmed,
    AVG(deaths) AS avg_deaths,
    AVG(recovered) AS avg_recovered
FROM coronadataset
GROUP BY month
ORDER BY month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH monthly_confirmed AS
 (
SELECT 
        DATE_FORMAT(corona_date, '%Y-%m') AS month,
        Confirmed,
        COUNT(*) AS Confirmed_count
            FROM coronadataset
    GROUP BY month, Confirmed 
    )
    select `month`,Confirmed_count from monthly_confirmed where confirmed<=1;
    
    WITH monthly_deaths AS
 (
    SELECT 
        DATE_FORMAT(corona_date, '%Y-%m') AS month,
        Deaths,
        COUNT(*) AS death_count
    FROM coronadataset
    GROUP BY month, Deaths
    )
    select `month`,death_count from monthly_deaths where Deaths<=1;
    WITH monthly_recovered AS 
(    SELECT 
        DATE_FORMAT(corona_date, '%Y-%m') AS month,
        Recovered,
        COUNT(*) AS recovered_count
    FROM coronadataset
    GROUP BY month, Recovered)
        select `month` ,recovered_count from monthly_recovered where Recovered <=1;
        
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(corona_date) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM coronadataset
GROUP BY year
ORDER BY year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(corona_date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM coronadataset
GROUP BY year
ORDER BY year;

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    DATE_FORMAT(corona_date, '%Y-%m') AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM coronadataset
GROUP BY month
ORDER BY month;

-- Q11. Check how corona virus spread out with respect to confirmed case

SELECT
    SUM(Confirmed) AS total_confirmed,
    AVG(Confirmed) AS average_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDDEV(Confirmed) AS stdev_confirmed
FROM coronadataset;


-- Q12. Check how corona virus spread out with respect to death case per month
SELECT
    DATE_FORMAT(corona_date, '%Y-%m') AS month,
    SUM(Deaths) AS total_deaths,
    AVG(Deaths) AS average_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDDEV(Deaths) AS stdev_deaths
FROM coronadataset
GROUP BY month
ORDER BY month;

-- Q13. Check how corona virus spread out with respect to recovered case

SELECT
    SUM(Recovered) AS total_recovered,
    AVG(Recovered) AS average_recovered,
    VARIANCE(Recovered) AS variance_recovered,
    STDDEV(Recovered) AS stdev_recovered
FROM coronadataset;

-- Q14. Find Country having highest number of the Confirmed case

SELECT 
    Country AS country,
    SUM(Confirmed) AS total_confirmed
FROM coronadataset
GROUP BY country
ORDER BY total_confirmed DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
    `Country` AS country,
    SUM(Deaths) AS total_deaths
FROM coronadataset
GROUP BY country
ORDER BY total_deaths ASC
LIMIT 1;


-- Q16. Find top 5 countries having highest recovered case

SELECT 
    `Country` AS country,
    SUM(Recovered) AS total_recovered
FROM coronadataset
GROUP BY country
ORDER BY total_recovered DESC
LIMIT 5;










