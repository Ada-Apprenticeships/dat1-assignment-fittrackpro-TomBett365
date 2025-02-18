-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Membership Management Queries


-----------------------------------------------------------------------------------------------------------------------------------------

-- 1. List all active memberships


SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    ms.type AS membership_type,  -- Select and alias the membership type for clarity in the result set
    m.join_date
FROM 
    members m
JOIN 
    memberships ms ON m.member_id = ms.member_id;  -- Join members with memberships to link membership types to members


-----------------------------------------------------------------------------------------------------------------------------------------
    
-- 2. Calculate the average duration of gym visits for each membership type


SELECT 
    membership_type,
    AVG(
        (
            (no_classes_per_member * duration_of_class) + duration_sessions
        )
    ) AS avg_visit_duration_minutes -- Calculates the average visit duration in minutes per membership type
FROM 
    (
        SELECT 
            m.type AS membership_type, -- Retrieves the type of membership for each member
            nc.member_id, -- Retrieves the member's ID
            nc.no_classes_per_member, -- Retrieves the number of classes attended by the member
            dc.duration_of_class, -- Retrieves the duration of each class in minutes
            ds.duration_sessions -- Retrieves the cumulative duration of personal training sessions for the member in minutes
        FROM 
            (
                SELECT 
                    member_id, 
                    schedule_id, 
                    COUNT(*) AS no_classes_per_member -- Counts the number of classes each member has attended
                FROM 
                    class_attendance
                WHERE 
                    attendance_status = 'Attended' -- Filters to include only classes that were attended
                GROUP BY 
                    member_id, schedule_id -- Groups the count by member and schedule for summarization
            ) AS nc
        JOIN 
            (
                SELECT 
                    schedule_id, 
                    ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60) AS duration_of_class -- Calculates the duration of each class in minutes
                FROM 
                    class_schedule
                GROUP BY 
                    schedule_id -- Groups by schedule ID for accurate duration calculations
            ) AS dc ON nc.schedule_id = dc.schedule_id -- Joins tables on the schedule ID
        JOIN 
            (
                SELECT 
                    member_id, 
                    SUM(ROUND((julianday(end_time) - julianday(start_time)) * 24 * 60)) AS duration_sessions -- Sums the duration of personal training sessions in minutes for each member
                FROM 
                    personal_training_sessions
                GROUP BY 
                    member_id -- Groups by member ID to ensure each member's session durations are summed
            ) AS ds ON nc.member_id = ds.member_id -- Joins tables on the member ID
        JOIN 
            memberships m ON nc.member_id = m.member_id -- Joins to get the membership type based on member ID
    ) AS subquery
GROUP BY 
    membership_type; -- Groups the final average calculations by membership type


-----------------------------------------------------------------------------------------------------------------------------------------

-- 3. Identify members with expiring memberships this year


SELECT 
    m.member_id, r
    m.first_name, 
    m.last_name, 
    m.email, 
    ms.end_date
FROM 
    (
        SELECT 
            member_id, 
            end_date
        FROM 
            memberships
        WHERE 
            (julianday(end_date) - julianday(DATE('now'))) <= 365 -- Filters memberships that expire within the next 365 days
    ) AS ms
JOIN 
    members m ON m.member_id = ms.member_id; -- Joins the filtered memberships with members on member_id