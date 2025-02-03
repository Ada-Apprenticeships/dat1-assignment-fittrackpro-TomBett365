-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;


-- Attendance Tracking Queries

-- 1. Record a member's gym visit

--INSERT INTO attendance (member_id, location_id, check_in_time)
--VALUES
--(7, 1, datetime('now'))

-- 2. Retrieve a member's attendance history
SELECT date(check_in_time) AS visit_date, time(check_in_time), time(check_out_time)
FROM attendance
WHERE member_id = 5;

-- 3. Find the busiest day of the week based on gym visits
DROP TABLE IF EXISTS day_of_week;

CREATE TABLE day_of_week (
index_value INT PRIMARY KEY CHECK(index_value < 7),
day_of_week VARCHAR(9)
);

INSERT INTO day_of_week(index_value, day_of_week)
VALUES
(0, 'Sunday'),
(1, 'Monday'),
(2, 'Tuesday'),
(3, 'Wednesday'),
(4, 'Thursday'),
(5, 'Friday'),
(6, 'Saturday');

SELECT d.day_of_week, COUNT(a.index_value) AS visit_count
FROM (SELECT *, strftime('%w', check_in_time) AS index_value
      FROM attendance) a
JOIN day_of_week d ON a.index_value = d.index_value
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location