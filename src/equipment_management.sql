-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Equipment Management Queries


-----------------------------------------------------------------------------------------------------------------------------------------

-- 1. Find equipment due for maintenance


SELECT 
    equipment_id,
    name,
    next_maintenance_date
FROM 
    equipment
WHERE 
    (julianday(next_maintenance_date) - julianday(DATE('now'))) <= 30; -- Filters for equipment that needs maintenance in the next 30 days


-----------------------------------------------------------------------------------------------------------------------------------------

-- 2. Count equipment types in stock


SELECT 
    RTRIM(RTRIM(RTRIM(RTRIM(name, '1'), '2'), '3'), '4') AS equipment_type, -- Removes any trailing '1', '2', '3', or '4' from the name to determine the equipment type
    COUNT(DISTINCT name) AS count -- Counts the number of distinct names for each equipment type
FROM 
    equipment
GROUP BY 
    equipment_type;


-----------------------------------------------------------------------------------------------------------------------------------------

-- 3. Calculate average age of equipment by type (in days)


SELECT 
    sub.equipment_type,
    AVG(sub.age_equipment) AS avg_age_days -- Calculates the average age in days of the equipment for each type
FROM 
    (
        SELECT 
            RTRIM(RTRIM(RTRIM(RTRIM(name, '1'), '2'), '3'), '4') AS equipment_type, -- Determines equipment type by removing specific trailing characters from the name
            (julianday(DATE('now')) - julianday(purchase_date)) AS age_equipment -- Computes the age of the equipment in days from the purchase date to today
        FROM 
            equipment
    ) AS sub -- Defines a subquery named sub which calculates the age of each equipment
GROUP BY 
    sub.equipment_type; -- Groups results by equipment type for calculating the average age