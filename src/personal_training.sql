-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
SELECT 
    pt.session_id, 
    m.first_name || ' ' || m.last_name AS member_name,  -- Concatenate first and last name to create member_name
    pt.session_date, 
    pt.start_time, 
    pt.end_time
FROM 
    (
        SELECT 
            * 
        FROM 
            staff
        WHERE 
            first_name = 'Ivy' 
            AND last_name = 'Irwin'  -- Select only the staff member whose first and last name match 'Ivy' and 'Irwin'
    ) AS s
JOIN 
    personal_training_sessions AS pt ON s.staff_id = pt.staff_id  -- Join with sessions where Ivy Irwin is the trainer
JOIN 
    members AS m ON pt.member_id = m.member_id;  -- Join with members to get their full name in the output