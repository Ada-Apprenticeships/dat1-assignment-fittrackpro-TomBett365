-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;


-- Attendance Tracking Queries

-- 1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES
    (7, 1, datetime('now'));

-- 2. Retrieve a member's attendance history
SELECT 
    DATE(check_in_time) AS visit_date, -- Extracts date from check in time
    TIME(check_in_time) AS check_in_time, -- Extracts time from check in time
    TIME(check_out_time) AS check_out_time -- Extracts time from check out time
FROM 
    attendance
WHERE 
    member_id = 5;

-- 3. Find the busiest day of the week based on gym visits
DROP TABLE IF EXISTS day_of_week;

-- Creates table 'day_of_week' with each day of the week stored with their index value
CREATE TABLE day_of_week (
    index_value INT PRIMARY KEY CHECK (index_value BETWEEN 0 AND 6),
    day_of_week VARCHAR(9)
);

-- Insert days of week and index value pairs
INSERT INTO day_of_week (index_value, day_of_week)
VALUES
    (0, 'Sunday'),
    (1, 'Monday'),
    (2, 'Tuesday'),
    (3, 'Wednesday'),
    (4, 'Thursday'),
    (5, 'Friday'),
    (6, 'Saturday');

SELECT 
    d.day_of_week, 
    COUNT(a.index_value) AS visit_count -- Counts occurances of each index value
FROM 
    (
        SELECT 
            *, 
            strftime('%w', check_in_time) AS index_value -- Extracts index value for day of week from check in time
        FROM 
            attendance
    ) AS a
JOIN 
    day_of_week AS d ON a.index_value = CAST(d.index_value AS TEXT)
GROUP BY 
    d.day_of_week
ORDER BY 
    visit_count DESC
LIMIT 1; -- Only take top record which will have the largest visit count since it is already in descending order

-- 4. Calculate the average daily attendance for each location
SELECT 
    l.name, 
    AVG(vc.visit_count) AS avg_daily_attendance -- Determines average visit count from 'vc' table 
FROM 
    (
        SELECT 
            d.day_of_week, 
            COUNT(a.index_value) AS visit_count, -- Counts occurances of each index value
            a.location_id
        FROM 
            (
                SELECT 
                    *, 
                    strftime('%w', check_in_time) AS index_value, -- Extracts index value for each month from check in time
                    location_id
                FROM 
                    attendance
            ) AS a
        JOIN -- Get actual string for each day of week from table 'day_of_week'
            day_of_week AS d ON a.index_value = d.index_value
        GROUP BY 
            d.day_of_week, a.location_id -- Displays count for each location, for each day of the week
    ) AS vc
JOIN 
    locations AS l ON l.location_id = vc.location_id
GROUP BY 
    l.name; -- Calculates average for each of two locations