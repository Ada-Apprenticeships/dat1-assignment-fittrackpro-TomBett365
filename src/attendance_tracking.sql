-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;


-- Attendance Tracking Queries


-----------------------------------------------------------------------------------------------------------------------------------------

-- 1. Record a member's gym visit


INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES
    (7, 1, datetime('now'));  -- Insert a record indicating member 7 checked in at location 1 with the current date and time


-----------------------------------------------------------------------------------------------------------------------------------------

-- 2. Retrieve a member's attendance history


SELECT 
    DATE(check_in_time) AS visit_date,    -- Extracts the date part from the check_in_time
    TIME(check_in_time) AS check_in_time, -- Extracts the time part from the check_in_time
    TIME(check_out_time) AS check_out_time -- Extracts the time part from the check_out_time
FROM 
    attendance
WHERE 
    member_id = 5;  -- Filters records to include only those for member with ID 5


------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Find the busiest day of the week based on gym visits


DROP TABLE IF EXISTS day_of_week;

-- Creates the 'day_of_week' table to store each day with its corresponding index value (0 = Sunday, ..., 6 = Saturday)
CREATE TABLE day_of_week (
    index_value INT PRIMARY KEY CHECK (index_value BETWEEN 0 AND 6),  -- Index value from 0 (Sunday) to 6 (Saturday)
    day_of_week VARCHAR(9)  -- Name of the day, such as 'Monday'
);

-- Insert the days of the week with their corresponding index values
INSERT INTO day_of_week (index_value, day_of_week)
VALUES
    (0, 'Sunday'),
    (1, 'Monday'),
    (2, 'Tuesday'),
    (3, 'Wednesday'),
    (4, 'Thursday'),
    (5, 'Friday'),
    (6, 'Saturday');

-- Query to find the day of the week with the highest check-in count
SELECT 
    d.day_of_week, 
    COUNT(a.index_value) AS visit_count  -- Count of check-ins for each day
FROM 
    (
        SELECT 
            *, 
            strftime('%w', check_in_time) AS index_value  -- Extract the index value for the day of the week from check_in_time
        FROM 
            attendance
    ) AS a
JOIN 
    day_of_week AS d ON a.index_value = CAST(d.index_value AS TEXT)  -- Join the day_of_week table to map index to day name
GROUP BY 
    d.day_of_week  -- Group by each day of the week
ORDER BY 
    visit_count DESC  -- Order by number of visits in descending order to get the busiest day first
LIMIT 1;  -- Limit the result to the single day with the highest visit count


------------------------------------------------------------------------------------------------------------------------------------------

-- 4. Calculate the average daily attendance for each location


SELECT 
    l.name AS location_name, 
    AVG(vc.visit_count) AS avg_daily_attendance  -- Calculate the average daily attendance from 'vc' table
FROM 
    (
        SELECT 
            d.day_of_week, 
            COUNT(a.index_value) AS visit_count,  -- Count the occurrences of each index value (day of the week)
            a.location_id
        FROM 
            (
                SELECT 
                    *, 
                    strftime('%w', check_in_time) AS index_value,  -- Extract index value for the day of the week from check_in_time
                    location_id
                FROM 
                    attendance
            ) AS a
        JOIN 
            day_of_week AS d ON a.index_value = d.index_value  -- Join with 'day_of_week' to convert index to day name
        GROUP BY 
            d.day_of_week, a.location_id  -- Group by day of the week and location to get visit counts per location, per day
    ) AS vc
JOIN 
    locations AS l ON l.location_id = vc.location_id  -- Join with 'locations' table to get location names
GROUP BY 
    l.name;  -- Group by location name to compute the average attendance for each location