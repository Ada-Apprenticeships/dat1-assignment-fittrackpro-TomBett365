-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT c.class_id, c.name AS class_name, s.first_name, s.last_name
FROM class_schedule cs, staff s
JOIN classes c ON c.class_id = cs.class_id AND cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date

SELECT schedule_id, COUNT(*)
FROM class_attendance  
GROUP BY schedule_id;

SELECT c.class_id, c.name, cs.start_time, cs.end_time, rc.registration_count, cc.capacity
FROM classes c, (SELECT schedule_id, COUNT(*) AS registration_count
                                            FROM class_attendance  
                                            GROUP BY schedule_id) rc, (SELECT class_id, capacity
                                                                        FROM classes) cc 
JOIN class_schedule cs ON rc.schedule_id = cs.schedule_id AND cc.class_id = cs.class_id;

-- 3. Register a member for a class

--INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
--VALUES
--(7, 11, 'Registered');

-- 4. Cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;

-- 5. List top 5 most popular classes
SELECT c.class_id, c.name AS class_name, (SELECT ca.schedule_id, COUNT(*)
                                          FROM class_attendance ca  
                                          GROUP BY ca.schedule_id) AS registration_count 
FROM class_schedule cs, class_attendance ca, registration_count rc
JOIN classes c ON c.class_id = cs.class_id AND cs.schedule_id = rc.schedule_id;

-- 6. Calculate average number of classes per member

SELECT AVG(classes_per_member) AS average_classes_per_member
FROM (SELECT member_id, COUNT(*) AS classes_per_member
      FROM class_attendance
      GROUP BY member_id);