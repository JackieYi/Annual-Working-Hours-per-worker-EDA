/*
Annual Working Hours per worker EDA

Author：Jackie Yi
Date: 02/08/2023
*/

--View the data we need
SELECT entity,
year,
average_annual_working_hours_per_worker
FROM Hours;

-- Renaming the column average_annual_working_hours_per_worker to Working_hours, Entity to Country
ALTER TABLE Hours
RENAME COLUMN average_annual_working_hours_per_worker TO Working_hours;

ALTER TABLE Hours
RENAME COLUMN entity TO Country;

--Check the unique years
SELECT DISTINCT(year)
FROM  Hours
ORDER BY Year;
--The year before 1950 are not countinuous, so I would like to delete them.

--Delete the data with a year less than 1950
DELETE  FROM Hours
WHERE year <1950;

--Check if any Working_hours value is less than 0
SELECT Working_hours
from Hours
WHERE Working_hours<0;

-- Which country has the highest average annual working hours per person?
SELECT country,
ROUND(AVG(Working_hours),2) as Average_Working_Hours
FROM Hours
GROUP by country
order by Average_Working_Hours DESC
LIMIT 1;
--South Korea has  the highest average annual working hours per person with 2535.88 Hours.

-- Which country has the highest annual working hours per person in the latest  year? How many hours did a person need to work annually in that country?
SELECT country,
Working_hours,
year
FROM Hours
WHERE Hours.Year = (
SELECT MAX(year)
from Hours
);
ORDER BY working_hours DESC
LIMIT 1;
--Cambodia has the highest annual working hours per person in the latest  year, a person needed to work 2455.55 hours annually in Cambodia.

-- In which year people in the United States worked the least number of hours?
SELECT country,year,Working_hours
FROM Hours
WHERE country like "%States"
ORDER BY 3
LIMIT 1;
-- In 2009. People in the United States only needs to work 1729.96 hours annually.

--What is the pattern of working hour per year in the United States?
SELECT year,
working_hours,
ROUND(working_hours - LAG(working_hours) OVER(ORDER BY year ASC),2) as Growth, -- Working Hours in this year - Working Hours in last year = Growth
ROUND((working_hours - LAG(working_hours) OVER(ORDER BY year ASC)) / LAG (working_hours) OVER (ORDER BY year ASC)*100,2) AS Growth_Rate_Percent --Growth / Working Hours in last year = Growth Rate
from Hours
Where country like "%States";

-- FROM 1950 to 2017, the working hour growth rate in the United States is between -2.3% and 2.08%. 
--In 1970, the working hours growth rate dropped -2.3% compare to 1969, which means people worked last 44.56 hours annually than 1969.
--In 1951, the working hours growth rate increased 2.08% compare to 1950, which means people worked more 41.32 hours annually than 1950.
