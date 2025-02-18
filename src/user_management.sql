-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- User Management Queries

-- 1. Retrieve all members
SELECT
    member_id, 
    first_name, 
    last_name, 
    email, 
    join_date
FROM 
    members;

-- 2. Update a member's contact information
UPDATE members
SET email = 'emily.jones.updated@email.com', phone_number = '555-9876'
WHERE member_id = 5;

-- 3. Count total number of members
SELECT COUNT(member_id) AS member_count
FROM members;

-- 4. Find member with the most class registrations
SELECT
    m.member_id, 
    m.first_name, 
    m.last_name, 
    rc.registration_count
FROM 
    (
        SELECT 
            member_id,
            COUNT(*) AS registration_count -- Counts all those registered in class attendance table and stores value as 'registration_count'
        FROM 
            class_attendance
        GROUP BY 
            member_id -- Group by member id to give the corresponding registration count for each member
JOIN 
    members m -- Joins members table on member id from 'rc' table 
ON 
    m.member_id = rc.member_id
WHERE -- Only joins records where the registration count is equal to the MAXIMUM registration count
    rc.registration_count = (
        SELECT 
            MAX(registration_count)
        FROM 
            (
                SELECT 
                    COUNT(*) AS registration_count
                FROM 
                    class_attendance
                GROUP BY 
                    member_id
            ) AS registration_counts
    );

-- 5. Find member with the least class registrations
SELECT
    m.member_id, 
    m.first_name, 
    m.last_name, 
    rc.registration_count
FROM 
    (
        SELECT 
            member_id,
            COUNT(*) AS registration_count -- Counts all those registered in class attendance table and stores value as 'registration_count'
        FROM 
            class_attendance
        GROUP BY 
            member_id -- Group by member id to give the corresponding registration count for each member
    ) AS rc
JOIN 
    members m -- Joins members table on member id from 'rc' table 
ON 
    m.member_id = rc.member_id
WHERE -- Only joins records where registration count is equal to the MINIMUM count
    rc.registration_count = (
        SELECT 
            MIN(registration_count)
        FROM 
            (
                SELECT 
                    COUNT(*) AS registration_count
                FROM 
                    class_attendance
                GROUP BY 
                    member_id
            ) AS registration_counts
    );

-- 6. Calculate the percentage of members who have attended at least one class
SELECT -- Takes 2 implicit tables (member count and attendance count) and divides one by the other and multiplies by 100 to get the percentage
    (CAST(attendance_member_count AS FLOAT) / member_count * 100) AS percentage_members
FROM 
    (
        SELECT -- Counts individual members from members table and stores value as 'attendance_member_count'
            COUNT(member_id) AS attendance_member_count, 
            (
                SELECT 
                    COUNT(member_id) 
                FROM 
                    members
            ) AS member_count
        FROM 
            (
                SELECT -- Counts members who have attended at least one class and stores value as 'attendance_count'
                    member_id, 
                    COUNT(*) AS attendance_count
                FROM 
                    class_attendance
                WHERE 
                    attendance_status = 'Attended'
                GROUP BY
                    member_id
            ) AS attendance_count
    );