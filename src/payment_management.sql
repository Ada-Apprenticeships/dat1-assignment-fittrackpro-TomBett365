-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
INSERT INTO payments (
    member_id,
    amount,
    payment_date,
    payment_method,
    payment_type
) VALUES (
    11,
    50,
    datetime('now'),
    'Credit Card',
    'Monthly membership fee'
);

-- 2. Calculate total revenue from membership fees for each month of the last year
DROP TABLE IF EXISTS months;

-- Creates table 'months' to allow day of week to be determined from index value
CREATE TABLE months (
    month_index INTEGER PRIMARY KEY CHECK (month_index BETWEEN 1 AND 12), 
    month_name VARCHAR(9) NOT NULL
);

-- Insert each month along with its corresponding index value into table 'months'
INSERT INTO months (month_index, month_name) VALUES
    (1, 'January'),
    (2, 'February'),
    (3, 'March'),
    (4, 'April'),
    (5, 'May'),
    (6, 'June'),
    (7, 'July'),
    (8, 'August'),
    (9, 'September'),
    (10, 'October'),
    (11, 'November'),
    (12, 'December');

SELECT
    strftime('%m', payment_date) AS month,  -- Extracts index value for month from payment date
    SUM(amount) AS total_revenue  -- Sums the amount paid for each month
FROM  
    payments p
GROUP BY 
    month
ORDER BY
    month;

-- 3. Find all day pass purchases
SELECT
    payment_id, 
    amount, 
    payment_date, 
    payment_method
FROM 
    payments
WHERE -- Only selects records where payment type is 'Day Pass'
    payment_type = 'Day pass';