-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
SELECT 
    pt.session_id, 
    m.first_name || ' ' || m.last_name AS member_name, 
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
            AND last_name = 'Irwin'
    ) AS s
JOIN 
    personal_training_sessions AS pt ON s.staff_id = pt.staff_id
JOIN 
    members AS m ON pt.member_id = m.member_id;