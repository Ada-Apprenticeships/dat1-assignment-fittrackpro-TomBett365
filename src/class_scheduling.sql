-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT c.class_id, c.name AS class_name, printf('%s %s', s.first_name, s.last_name) AS instructor_name
FROM class_schedule cs, staff s
JOIN classes c ON c.class_id = cs.class_id AND cs.staff_id = s.staff_id
GROUP BY cs.schedule_id;

-- 2. Find available classes for a specific date
SELECT c.class_id, c.name, cs.start_time, cs.end_time, (c.capacity - rc.reg_count) AS available_spots
FROM classes c, (SELECT schedule_id, COUNT(*) AS reg_count
                 FROM class_attendance  
                 GROUP BY schedule_id) rc 
JOIN class_schedule cs ON rc.schedule_id = cs.schedule_id AND c.class_id = cs.class_id;

-- 3. Register a member for a class

--INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
--VALUES
--(7, 11, 'Registered');

-- 4. Cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;

-- 5. List top 3 most popular classes
SELECT c.class_id, c.name AS class_name, SUM(rc.reg_count) AS reg_count
FROM class_schedule cs, (SELECT schedule_id, COUNT(*) AS reg_count
                        FROM class_attendance  
                        GROUP BY schedule_id) rc
JOIN classes c ON c.class_id = cs.class_id AND cs.schedule_id = rc.schedule_id
GROUP BY c.class_id
ORDER BY reg_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
SELECT AVG(classes_per_member) AS average_classes_per_member
FROM (SELECT member_id, COUNT(*) AS classes_per_member
      FROM class_attendance
      GROUP BY member_id);