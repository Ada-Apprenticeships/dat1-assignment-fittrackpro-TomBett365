-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
SELECT pt.session_id, pt.member_id, pt.session_date, pt.start_time, pt.end_time
FROM (SELECT * 
      FROM staff
      WHERE first_name = 'Ivy' AND last_name = 'Irwin') s
JOIN personal_training_sessions pt ON s.staff_id = pt.staff_id;
