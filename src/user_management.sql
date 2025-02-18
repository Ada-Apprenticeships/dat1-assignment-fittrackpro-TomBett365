-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- User Management Queries

-- 1. Retrieve all members
SELECT
    member_id,     -- Unique identifier for each member
    first_name,    -- First name of the member
    last_name,     -- Last name of the member
    email,         -- Email address of the member
    join_date      -- Date when the member joined
FROM 
    members;       -- Retrieve data from the 'members' table


-- 2. Update a member's contact information
UPDATE members
SET 
    email = 'emily.jones.updated@email.com',  -- Update the email address for the specified member
    phone_number = '555-9876'                 -- Update the phone number for the specified member
WHERE 
    member_id = 5;                            -- Target the member with ID 5


-- 3. Count total number of members
SELECT 
    COUNT(member_id) AS member_count  -- Count the total number of members and alias the result as member_count
FROM 
    members;                          -- Retrieve the count from the 'members' table


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
            COUNT(*) AS registration_count  -- Count registrations in the class_attendance table and store as 'registration_count'
        FROM 
            class_attendance
        GROUP BY 
            member_id                       -- Group by member_id to count registrations for each member
    ) AS rc
JOIN 
    members m                              -- Join with members table
ON 
    m.member_id = rc.member_id             -- Using member_id to match records between subquery and members table
WHERE 
    rc.registration_count = (
        SELECT 
            MAX(registration_count)        -- Subquery to find the maximum registration count
        FROM 
            (
                SELECT 
                    COUNT(*) AS registration_count  -- Count registrations again in a separate subquery
                FROM 
                    class_attendance
                GROUP BY 
                    member_id                        -- Group by member_id to get counts for each member
            ) AS registration_counts
    );                                      -- Filter to include only those members with the maximum registration count


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
            COUNT(*) AS registration_count  -- Count registrations in the class_attendance table and alias as 'registration_count'
        FROM 
            class_attendance
        GROUP BY 
            member_id                        -- Group by member_id to compute registration count for each member
    ) AS rc
JOIN 
    members m                                -- Join with the members table
ON 
    m.member_id = rc.member_id               -- Match records between subquery and members table using member_id
WHERE 
                                             -- Filter for records where the registration count is the minimum
    rc.registration_count = (
        SELECT 
            MIN(registration_count)          -- Subquery to find the minimum registration count
        FROM 
            (
                SELECT 
                    COUNT(*) AS registration_count  -- Count registrations for each member again in a separate subquery
                FROM 
                    class_attendance
                GROUP BY 
                    member_id                        -- Group by member_id to get registration counts
            ) AS registration_counts
    );


-- 6. Calculate the percentage of members who have attended at least one class
SELECT
    (CAST(attendance_member_count AS FLOAT) / member_count * 100) AS percentage_members  -- Calculate and select percentage of members who attended
FROM 
    (
        SELECT
            COUNT(member_id) AS attendance_member_count,  -- Count unique members who attended at least one class
            (
                SELECT 
                    COUNT(member_id)  
                FROM 
                    members
            ) AS member_count  -- Total number of members in the members table
        FROM 
            (
                SELECT
                    member_id, 
                    COUNT(*) AS attendance_count  -- Count total attendance instances per member
                FROM 
                    class_attendance
                WHERE 
                    attendance_status = 'Attended'  -- Consider only records where attendance status is 'Attended'
                GROUP BY
                    member_id  -- Group by member_id to get attendance counts per member
            ) AS attendance_count
    );