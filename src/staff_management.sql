-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Staff Management Queries

-- 1. List all staff members by role
SELECT staff_id, first_name, last_name, position AS role
FROM staff 
ORDER BY role;

-- 2. Find trainers with one or more personal training session in the next 30 days
SELECT s.staff_id AS trainer_id, s.first_name || ' ' || s.last_name AS trainer_name, sc.session_count
FROM staff s, (SELECT staff_id, COUNT(*) AS session_count
               FROM personal_training_sessions
               WHERE (julianday(session_date) - julianday(date('now'))) BETWEEN 0 AND 30
               GROUP BY staff_id) sc
JOIN staff ON sc.staff_id = s.staff_id
GROUP BY sc.staff_id;