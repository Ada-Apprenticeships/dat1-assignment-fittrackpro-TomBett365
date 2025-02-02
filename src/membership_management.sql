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
SELECT m.membership_type, (SELECT AVG(*)
                            FROM average_duration ad
                            GROUP BY member_id)

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year