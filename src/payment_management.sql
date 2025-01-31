-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES
(11, 50, datetime('now'), 'Credit Card', 'Monthly membership fee');


-- 2. Calculate total revenue from membership fees for each month of the last year
SELECT  
    strftime('%m', payment_date) AS month,  
    SUM(amount) AS total_revenue  
FROM  
    payments  
GROUP BY  
    strftime('%m', payment_date)  
ORDER BY  
    month; 


-- 3. Find all day pass purchases
SELECT payment_id, amount, payment_date, payment_method
FROM payments
WHERE payment_type = 'Day pass';