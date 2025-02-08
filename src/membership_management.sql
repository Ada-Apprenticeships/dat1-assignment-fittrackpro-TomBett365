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



SELECT ns.member_id, ns.no_sessions_per_member, AVG(no_sessions_per_member * duration_classes) AS avg_duration
FROM (SELECT member_id, schedule_id, COUNT(*) AS no_sessions_per_member
                        FROM class_attendance
                        WHERE attendance_status = 'Attended'
                        GROUP BY member_id) ns,
        (SELECT schedule_id, AVG(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_classes
                        FROM class_schedule
                        GROUP BY schedule_id) dc
JOIN no_sessions ns ON ns.schedule_id = dc.schedule_id;



-- 2. Calculate the average duration of gym visits for each membership type

SELECT ns.member_id, ns.no_sessions_per_member, AVG(no_sessions_per_member * duration_classes) AS avg_duration
FROM (SELECT member_id, schedule_id, COUNT(*) AS no_sessions_per_member
                        FROM class_attendance
                        WHERE attendance_status = 'Attended'
                        GROUP BY member_id) ns,
        (SELECT schedule_id, AVG(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_classes
                        FROM class_schedule
                        GROUP BY schedule_id) dc
JOIN no_sessions ns ON ns.schedule_id = dc.schedule_id;



SELECT m.membership_type, (SELECT AVG(duration)
                            FROM average_duration ad
                            GROUP BY member_id)
FROM memberships m, (SELECT member_id, AVG(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_personal_training
                        FROM personal_training_sessions
                        GROUP BY member_id),
                    (SELECT member_id, schedule_id, COUNT(*) AS no_sessions_per_member
                        FROM class_attendance
                        WHERE attendance_status = 'Attended'
                        GROUP BY member_id) ns, 
                    (SELECT schedule_id, AVG(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_classes
                        FROM class_schedule
                        GROUP BY schedule_id) dc

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

    
