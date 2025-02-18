-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Class Scheduling Queries


--------------------------------------------------------------------------------------------------------------------------

-- 1. List all classes with their instructors


SELECT 
    c.class_id, 
    c.name AS class_name,  -- Rename the class name for clarity in the result set
    printf('%s %s', s.first_name, s.last_name) AS instructor_name  -- Concatenate first and last name of instructor
FROM 
    class_schedule cs
JOIN 
    classes c ON c.class_id = cs.class_id  -- Join to get class details with schedule
JOIN 
    staff s ON cs.staff_id = s.staff_id  -- Join to get instructor details for each class
GROUP BY 
    cs.schedule_id;  -- Group results by schedule_id to ensure unique entries for each class schedule


-------------------------------------------------------------------------------------------------------------------------

-- 2. Find available classes for a specific date


SELECT 
    c.class_id, 
    c.name, 
    cs.start_time, 
    cs.end_time, 
    (c.capacity - COALESCE(rc.reg_count, 0)) AS available_spots  -- Calculate available spots by subtracting registered count from capacity
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id  -- Join to link classes with their schedules
LEFT JOIN 
    (SELECT 
        schedule_id, 
        COUNT(*) AS reg_count  -- Count the number of registered attendees for each schedule
     FROM 
        class_attendance  
     GROUP BY 
        schedule_id) rc ON rc.schedule_id = cs.schedule_id;  -- Left join to include all class schedules even if no registrations exist

----------------------------------------------------------------------------------------------------------------------------

-- 3. Register a member for a class


INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES
    (7, 11, 'Registered');  -- Add a record showing that member 11 is registered for the class with schedule ID 7


----------------------------------------------------------------------------------------------------------------------------

-- 4. Cancel a class registration


DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;  -- Remove the record for member 2 attending the class with schedule ID 7


----------------------------------------------------------------------------------------------------------------------------

-- 5. List top 3 most popular classes


SELECT 
    c.class_id, 
    c.name AS class_name,  -- Alias the class name for clarity in the results
    SUM(rc.reg_count) AS reg_count  -- Sum the registration counts for each class
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id -- Join classes with their schedules
JOIN 
    (
        SELECT 
            schedule_id, 
            COUNT(*) AS reg_count  -- Count the number of registrations for each scheduled class
        FROM 
            class_attendance
        GROUP BY 
            schedule_id
    ) rc ON cs.schedule_id = rc.schedule_id  -- Join registration counts with class schedules
GROUP BY 
    c.class_id, 
    c.name  -- Group by class ID and name to aggregate registration counts for each class
ORDER BY 
    reg_count DESC  -- Order results by registration count in descending order
LIMIT 3;  -- Limit the output to the top 3 classes with the highest registration counts


----------------------------------------------------------------------------------------------------------------------------

-- 6. Calculate average number of classes per member


SELECT 
    AVG(classes_per_member) AS average_classes_per_member  -- Calculate the average number of classes attended per member
FROM 
    (
        SELECT 
            member_id, 
            COUNT(*) AS classes_per_member  -- Count the number of classes each member has attended
        FROM 
            class_attendance
        GROUP BY 
            member_id  -- Group by member_id to get individual attendance counts
    ) AS subquery;  -- Use a subquery to first calculate classes attended per member