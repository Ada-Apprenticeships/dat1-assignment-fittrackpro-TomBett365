-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Membership Management Queries

-- 1. List all active memberships
SELECT m.member_id, m.first_name, m.last_name, ms.type AS membership_type, m.join_date
FROM memberships ms
JOIN members m ON m.member_id = ms.member_id;

-- 2. Calculate the average duration of gym visits for each membership type
SELECT membership_type, AVG(((no_classes_per_member * duration_of_class) + duration_sessions)) AS avg_visit_duration_minutes
FROM (SELECT m.type AS membership_type, nc.member_id, nc.no_classes_per_member, dc.duration_of_class, ds.duration_sessions
      FROM (SELECT member_id, schedule_id, COUNT(*) AS no_classes_per_member
            FROM class_attendance 
            WHERE attendance_status = 'Attended'
            GROUP BY member_id) nc,
            (SELECT schedule_id, ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60) AS duration_of_class
            FROM class_schedule
            GROUP BY schedule_id) dc,
            (SELECT member_id, SUM(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_sessions
            FROM personal_training_sessions
            GROUP BY member_id) ds
            JOIN memberships m ON nc.member_id = m.member_id AND nc.schedule_id = dc.schedule_id AND nc.member_id = ds.member_id)
GROUP BY membership_type;

-- 3. Identify members with expiring memberships this year
SELECT m.member_id, m.first_name, m.last_name, m.email, ms.end_date
FROM (SELECT member_id, end_date
      FROM memberships
      WHERE (julianday(end_date) - julianday(date('now'))) <= 365) ms
JOIN members m ON m.member_id = ms.member_id;