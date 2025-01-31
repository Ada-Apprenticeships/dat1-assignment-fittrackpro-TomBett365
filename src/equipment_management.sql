-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
SELECT equipment_id, name, next_maintenance_date
FROM equipment
WHERE (julianday(next_maintenance_date) - julianday(date('now'))) <= 30;

-- 2. Count equipment types in stock
SELECT RTRIM(RTRIM(RTRIM(RTRIM(name, '1'), '2'), '3'), '4') AS equipment_type, COUNT(DISTINCT name)
FROM equipment
GROUP BY equipment_type;

-- 3. Calculate average age of equipment by type (in days)
SELECT RTRIM(RTRIM(RTRIM(RTRIM(name, '1'), '2'), '3'), '4') AS equipment_type, (julianday(date('now')) - julianday(purchase_date)) AS age_equipment
FROM equipment;