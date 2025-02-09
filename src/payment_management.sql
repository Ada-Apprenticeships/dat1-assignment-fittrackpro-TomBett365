-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
/*

INSERT INTO payments (
    member_id, 
    amount,
    payment_date, 
    payment_method, 
    payment_type)
VALUES (
    11, 
    50, 
    datetime('now'), 
    'Credit Card', 
    'Monthly membership fee');

*/

-- 2. Calculate total revenue from membership fees for each month of the last year

DROP TABLE IF EXISTS months;

CREATE TABLE months (
    month_index INTEGER PRIMARY KEY, 
    month VARCHAR(9)
);

INSERT INTO months (
    month_index,
    month)
VALUES 
    (01, 'January',
     02, 'February',
     03, 'March',
     04, 'April',
     05, 'May',
     06, 'June',
     07, 'July',
     08, 'August',
     09, 'September',
     10, 'October',
     11, 'November',
     12, 'December');


SELECT  
    strftime('%m', p.payment_date) AS month,  
    SUM(p.amount) AS total_revenue  
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
WHERE 
    payment_type = 'Day pass';