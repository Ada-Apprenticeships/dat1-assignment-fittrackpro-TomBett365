-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Staff Management Queries


---------------------------------------------------------------------------------------------------------------

-- 1. List all staff members by role


SELECT 
    staff_id, 
    first_name, 
    last_name, 
    position AS role  -- Rename the 'position' column to 'role' for output purposes
FROM 
    staff             -- Specify the 'staff' table as the data source
ORDER BY 
    role;             -- Order the results by the 'role' column (formerly 'position')


---------------------------------------------------------------------------------------------------------------

-- 2. Find trainers with one or more personal training session in the next 30 days


SELECT 
    s.staff_id AS trainer_id,      -- Alias staff_id as trainer_id for clarity
    s.first_name || ' ' || s.last_name AS trainer_name,  -- Concatenate first and last name to create trainer_name
    sc.session_count               -- Select the count of sessions from the subquery
FROM 
    staff AS s                     -- Use the 'staff' table with an alias 's'
JOIN 
    (
        SELECT 
            staff_id, 
            COUNT(*) AS session_count  -- Count the number of training sessions
        FROM 
            personal_training_sessions -- From the 'personal_training_sessions' table
        WHERE 
            (julianday(session_date) - julianday(DATE('now'))) BETWEEN 0 AND 30  -- Filter sessions within the last 30 days
        GROUP BY 
            staff_id                -- Group by staff_id to count sessions per trainer
    ) AS sc ON sc.staff_id = s.staff_id  -- Join subquery results on matching staff_id
GROUP BY 
    s.staff_id, s.first_name, s.last_name;  -- Group by staff details to ensure unique rows per trainer