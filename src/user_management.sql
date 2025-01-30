-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- User Management Queries

-- 1. Retrieve all members
SELECT member_id, first_name, last_name, email, join_date
FROM members;

-- 2. Update a member's contact information
UPDATE members
SET email = 'emily.jones.updated@email.com', phone_number = '555-9876'
WHERE member_id = 5;

-- 3. Count total number of members
SELECT COUNT(member_id) AS member_count
FROM members;

-- 4. Find member with the most class registrations


-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class