-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- User Management Queries

-- 1. Retrieve all members
-- Selected the necessary columns from the members table
SELECT
    member_id, 
    first_name, 
    last_name, 
    email, 
    join_date
FROM 
    members;

-- 2. Update a member's contact information
-- Changes the email and phone number fields in the members table, for member with member id = 5
UPDATE members
SET email = 'emily.jones.updated@email.com', phone_number = '555-9876'
WHERE member_id = 5;

-- 3. Count total number of members
-- Counts individual member id's from members and names it 'member_count'
SELECT COUNT(member_id) AS member_count
FROM members;

-- 4. Find member with the most class registrations
SELECT -- Selects 'member id', 'first name', 'last name' fields from members table 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    rc.registration_count -- Selects 'registration count' field from table aliased as 'rc'
FROM 
    (
        SELECT 
            member_id, -- Selects member id field from class attendance table
            COUNT(*) AS registration_count -- Counts all those registered in class attendance table and stores value as 'registration_count'
        FROM 
            class_attendance
        GROUP BY 
            member_id -- Group by member id to give the corresponding registration count for each member
JOIN 
    members m -- Joins members table on member id from 'rc' table 
ON 
    m.member_id = rc.member_id
WHERE -- Joins members table on condition that registration count is equal to the maximum count
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
SELECT -- Selects 'member id', 'first name', 'last name' fields from members table 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    rc.registration_count -- Selects 'registration count' field from table aliased as 'rc'
FROM 
    (
        SELECT 
            member_id, -- Selects member id field from class attendance table
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
WHERE -- Joins members table on condition that registration count is equal to the minimum count
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
    (CAST(attendance_member_count AS FLOAT) / member_count * 100) AS percentage_members -- Casts 'attendance_member_count' to float so it can be used in percentage calculation
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
                SELECT -- Counts members who have attended at least one class 
                    member_id, 
                    COUNT(*) AS attendance_count
                FROM 
                    class_attendance
                WHERE 
                    attendance_status = 'Attended'
                GROUP BY
                    member_id
            ) AS attendance_count -- Creates implicit table called 'attendance_count' with each member id with their corresponding attendance count
    );