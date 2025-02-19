-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- TODO: Create the following tables:
-- 1. locations
-- 2. members
-- 3. staff
-- 4. equipment
-- 5. classes
-- 6. class_schedule
-- 7. memberships
-- 8. attendance
-- 9. class_attendance
-- 10. payments
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS months;
DROP TABLE IF EXISTS day_of_week;

-- 'locations' table
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for location ID
    name VARCHAR(255) CHECK(length(name) <= 255),  -- Name of the location, maximum 255 characters
    address VARCHAR(255) CHECK(length(address) <= 255),  -- Address with a more practical maximum length of 255
    phone_number VARCHAR(8) CHECK(length(phone_number) = 8),  -- Phone number must be exactly 8 characters
    email VARCHAR(255) CHECK(email LIKE '%@%' AND length(email) <= 255),  -- Valid email format with a maximum length of 255
    opening_hours VARCHAR(10) CHECK(length(opening_hours) = 10)  -- Opening hours format must be exactly 10 characters
);
  
-- `members` table  
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for member ID
    first_name VARCHAR(255) CHECK(length(first_name) <= 255),  -- First name, maximum length of 255 characters
    last_name VARCHAR(255) CHECK(length(last_name) <= 255),  -- Last name, maximum length of 255 characters
    email VARCHAR(255) CHECK(email LIKE '%@%' AND length(email) <= 255),  -- Valid email format and maximum length of 255 characters
    phone_number VARCHAR(20) CHECK(length(phone_number) = 8 AND phone_number LIKE '%-%'),  -- Phone number: 8 characters including a hyphen
    date_of_birth DATE,  -- Date of birth, stored as a DATE type
    join_date DATE,  -- Join date, stored as a DATE type
    emergency_contact_name VARCHAR(255),  -- Emergency contact name, maximum 255 characters
    emergency_contact_phone VARCHAR(20) CHECK(length(emergency_contact_phone) = 8 AND emergency_contact_phone LIKE '%-%')  -- Emergency contact phone: 8 characters including a hyphen
);
  
-- `staff` table  
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for staff ID
    first_name VARCHAR(255) CHECK(length(first_name) <= 255),  -- First name, max length of 255 characters
    last_name VARCHAR(255) CHECK(length(last_name) <= 255),  -- Last name, max length of 255 characters
    email VARCHAR(255) CHECK(email LIKE '%@%' AND length(email) <= 255),  -- Valid email format and length constraint
    phone_number VARCHAR(20) CHECK(length(phone_number) = 8 AND phone_number LIKE '%-%'),  -- Phone number: 8 characters including a hyphen
    position VARCHAR(40) CHECK(position IN ('Maintenance', 'Trainer', 'Manager', 'Receptionist')),  -- Position must be one of the specified roles
    hire_date DATE,  -- Hire date stored as a DATE type
    location_id INTEGER,  -- Foreign key referencing locations
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  -- Foreign key constraint to ensure location ID reference integrity
); 
  
-- `equipment` table  
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for equipment ID
    name VARCHAR(255) CHECK(length(name) <= 255),  -- Name of the equipment, maximum length of 255 characters
    type VARCHAR(40) CHECK(type IN('Cardio', 'Strength')),  -- Type must be 'Cardio' or 'Strength'
    purchase_date DATE,  -- Date when the equipment was purchased
    last_maintenance_date DATE,  -- Date of the most recent maintenance
    next_maintenance_date DATE,  -- Scheduled date for the next maintenance
    location_id INTEGER,  -- Foreign key referencing the location of the equipment
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  -- Maintain referential integrity with 'locations' table
);
  
-- `classes` table  
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for class ID
    name VARCHAR(255) CHECK(length(name) <= 255),  -- Name of the class, maximum length of 255 characters
    description VARCHAR(255) CHECK(length(description) <= 255),  -- Description of the class, maximum length of 255 characters
    capacity INTEGER CHECK(capacity >= 1),  -- Capacity must be at least 1
    duration INTEGER CHECK(duration >= 1),  -- Duration must be at least 1, indicating the minimum time span
    location_id INTEGER,  -- Foreign key referencing the location
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  -- Maintain referential integrity with 'locations' table
);
  
-- `class_schedule` table  
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for schedule ID
    class_id INTEGER,  -- Foreign key referencing classes
    staff_id INTEGER,  -- Foreign key referencing staff
    start_time DATETIME,  -- Start time of the class
    end_time DATETIME,  -- End time of the class
    FOREIGN KEY (class_id) REFERENCES classes(class_id),  -- Maintain referential integrity with the 'classes' table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Maintain referential integrity with the 'staff' table
);
  
-- `memberships` table  
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for membership ID
    member_id INTEGER,  -- Foreign key referencing the member associated with this membership
    type VARCHAR(255) CHECK(length(type) <= 255),  -- Type of membership, maximum length of 255 characters
    start_date DATE,  -- Start date of the membership
    end_date DATE,  -- End date of the membership
    status VARCHAR(40) CHECK(status IN('Active', 'Inactive')),  -- Membership status, allowed values: 'Active' or 'Inactive'
    FOREIGN KEY (member_id) REFERENCES members(member_id)  -- Maintain referential integrity with the 'members' table
);
  
-- `attendance` table  
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for attendance record
    member_id INTEGER,  -- Foreign key referencing the member associated with this attendance record
    location_id INTEGER,  -- Foreign key referencing the location where the attendance was recorded
    check_in_time DATETIME,  -- The datetime the member checked in
    check_out_time DATETIME,  -- The datetime the member checked out
    FOREIGN KEY (member_id) REFERENCES members(member_id),  -- Maintain referential integrity with the 'members' table
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  -- Maintain referential integrity with the 'locations' table
); 
  
-- `class_attendance` table  
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for class attendance records
    schedule_id INTEGER,  -- Foreign key referencing the class schedule
    member_id INTEGER,  -- Foreign key referencing the member associated with this attendance record
    attendance_status VARCHAR(40) CHECK(attendance_status IN('Registered', 'Attended', 'Unattended')),  -- Status must be one of the specified values
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),  -- Maintain referential integrity with the 'class_schedule' table.
    FOREIGN KEY (member_id) REFERENCES members(member_id)  -- Maintain referential integrity with the 'members' table
);
  
-- `payments` table  
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for payment records
    member_id INTEGER,  -- Foreign key referencing the member making the payment
    amount DECIMAL(10, 2),  -- Payment amount with two decimal places
    payment_date DATE,  -- Date when the payment was made
    payment_method VARCHAR(40) CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),  -- Valid payment methods
    payment_type VARCHAR(40) CHECK(payment_type IN('Day pass', 'Monthly membership fee')),  -- Valid payment types
    FOREIGN KEY (member_id) REFERENCES members(member_id)  -- Maintain referential integrity with the 'members' table
); 
  
-- `personal_training_sessions` table  
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for each training session
    member_id INTEGER,  -- Foreign key referencing the member participating in the session
    staff_id INTEGER,  -- Foreign key referencing the staff member conducting the session
    session_date DATE,  -- Date of the training session
    start_time TIME,  -- Start time of the session
    end_time TIME,  -- End time of the session
    notes VARCHAR(255),  -- Additional notes about the session, max length of 255 characters
    FOREIGN KEY (member_id) REFERENCES members(member_id),  -- Enforce referential integrity with 'members' table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Enforce referential integrity with 'staff' table
);
  
-- `member_health_metrics` table  
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for each health metric record
    member_id INTEGER,  -- Foreign key referencing the member whose metrics are being recorded
    measurement_date DATE,  -- Date when the measurements were taken
    weight DECIMAL(5, 2),  -- Member's weight with two decimal places
    body_fat_percentage DECIMAL(5, 2),  -- Body fat percentage with two decimal places
    muscle_mass DECIMAL(5, 2),  -- Muscle mass with two decimal places
    bmi DECIMAL(5, 2),  -- Body Mass Index with two decimal places
    FOREIGN KEY (member_id) REFERENCES members(member_id)  -- Maintain referential integrity with the 'members' table
);
  
-- `equipment_maintenance_log` table  
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-incrementing primary key for each maintenance log entry
    equipment_id INTEGER,  -- Foreign key referencing the equipment undergoing maintenance
    maintenance_date DATE,  -- Date when the maintenance was performed
    description VARCHAR(255),  -- Description of the maintenance work, up to 255 characters
    staff_id INTEGER,  -- Foreign key referencing the staff member who performed the maintenance
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),  -- Enforce relationship with 'equipment' table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Enforce relationship with 'staff' table
); 




-- Sample data for locations
INSERT INTO locations (name, address, phone_number, email, opening_hours)
VALUES 
('Downtown Fitness', '123 Main St, Cityville', '555-1234', 'downtown@fittrackpro.com', '6:00-22:00'),
('Suburb Gym', '456 Oak Rd, Townsburg', '555-5678', 'suburb@fittrackpro.com', '5:00-23:00');

-- Sample data for members
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES 
('Alice', 'Johnson', 'alice.j@email.com', '555-1111', '1990-05-15', '2024-11-10', 'Bob Johnson', '555-1112'),
('Bob', 'Smith', 'bob.s@email.com', '555-2222', '1985-09-22', '2024-12-15', 'Alice Smith', '555-2223'),
('Carol', 'Williams', 'carol.w@email.com', '555-3333', '1992-12-03', '2025-01-20', 'David Williams', '555-3334'),
('David', 'Brown', 'david.b@email.com', '555-4444', '1988-07-30', '2024-11-25', 'Emily Brown', '555-4445'),
('Emily', 'Jones', 'emily.j@email.com', '555-5555', '1995-03-12', '2024-12-30', 'Frank Jones', '555-5556'),
('Frank', 'Miller', 'frank.m@email.com', '555-6666', '1983-11-18', '2025-01-10', 'Grace Miller', '555-6667'),
('Grace', 'Davis', 'grace.d@email.com', '555-7777', '1993-01-25', '2024-11-20', 'Henry Davis', '555-7778'),
('Henry', 'Wilson', 'henry.w@email.com', '555-8888', '1987-08-05', '2024-12-15', 'Ivy Wilson', '555-8889'),
('Ivy', 'Moore', 'ivy.m@email.com', '555-9999', '1991-04-09', '2025-01-01', 'Jack Moore', '555-9990'),
('Jack', 'Taylor', 'jack.t@email.com', '555-0000', '1986-06-28', '2024-11-12', 'Kelly Taylor', '555-0001'),
('Karen', 'Lee', 'karen.l@email.com', '555-1313', '1989-02-14', '2024-12-05', 'Liam Lee', '555-1314'),
('Liam', 'Anderson', 'liam.a@email.com', '555-1515', '1994-07-19', '2025-01-01', 'Mia Anderson', '555-1516'),
('Mia', 'Thomas', 'mia.t@email.com', '555-1717', '1991-11-30', '2025-01-10', 'Noah Thomas', '555-1718'),
('Noah', 'Roberts', 'noah.r@email.com', '555-1919', '1987-04-25', '2025-01-15', 'Olivia Roberts', '555-1920'),
('Olivia', 'Clark', 'olivia.c@email.com', '555-2121', '1993-09-08', '2025-01-20', 'Peter Clark', '555-2122');

-- Sample data for staff
INSERT INTO staff (first_name, last_name, email, phone_number, position, hire_date, location_id)
VALUES 
('David', 'Brown', 'david.b@fittrackpro.com', '555-4444', 'Trainer', '2024-11-10', 1),
('Emma', 'Davis', 'emma.d@fittrackpro.com', '555-5555', 'Manager', '2024-11-15', 2),
('Frank', 'Evans', 'frank.e@fittrackpro.com', '555-6666', 'Receptionist', '2024-12-10', 1),
('Grace', 'Green', 'grace.g@fittrackpro.com', '555-7777', 'Trainer', '2024-12-20', 2),
('Henry', 'Harris', 'henry.h@fittrackpro.com', '555-8888', 'Maintenance', '2025-01-05', 1),
('Ivy', 'Irwin', 'ivy.i@fittrackpro.com', '555-9999', 'Trainer', '2025-01-01', 2),
('Jack', 'Johnson', 'jack.j@fittrackpro.com', '555-0000', 'Manager', '2024-11-15', 1),
('Karen', 'King', 'karen.k@fittrackpro.com', '555-1212', 'Trainer', '2024-12-01', 2);

-- Sample data for equipment
INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
VALUES 
('Treadmill 1', 'Cardio', '2024-11-01', '2024-11-15', '2025-02-15', 1),
('Treadmill 2', 'Cardio', '2024-11-02', '2024-11-20', '2025-02-20', 1),
('Treadmill 3', 'Cardio', '2024-11-03', '2024-11-25', '2025-02-25', 2),
('Treadmill 4', 'Cardio', '2024-11-04', '2024-11-30', '2025-02-28', 2),
('Bench Press 1', 'Strength', '2024-11-05', '2024-12-01', '2025-03-01', 1),
('Bench Press 2', 'Strength', '2024-11-06', '2024-12-05', '2025-03-05', 2),
('Elliptical 1', 'Cardio', '2024-11-07', '2024-12-10', '2025-03-10', 1),
('Elliptical 2', 'Cardio', '2024-11-08', '2024-12-15', '2025-03-15', 2),
('Squat Rack 1', 'Strength', '2024-11-09', '2024-12-20', '2025-03-20', 1),
('Squat Rack 2', 'Strength', '2024-11-10', '2024-12-25', '2025-03-25', 2),
('Rowing Machine 1', 'Cardio', '2024-11-11', '2024-12-30', '2025-03-30', 1),
('Rowing Machine 2', 'Cardio', '2024-11-12', '2025-01-01', '2025-04-01', 2),
('Leg Press 1', 'Strength', '2024-11-13', '2025-01-05', '2025-04-05', 1),
('Leg Press 2', 'Strength', '2024-11-14', '2025-01-10', '2025-04-10', 2),
('Stationary Bike 1', 'Cardio', '2024-11-15', '2025-01-15', '2025-04-15', 1),
('Stationary Bike 2', 'Cardio', '2024-11-16', '2025-01-20', '2025-04-20', 2);

-- Sample data for classes
INSERT INTO classes (name, description, capacity, duration, location_id)
VALUES 
('Yoga Basics', 'Introductory yoga class', 20, 60, 1),
('HIIT Workout', 'High-intensity interval training', 15, 45, 2),
('Spin Class', 'Indoor cycling workout', 20, 50, 1),
('Pilates', 'Core-strengthening exercises', 15, 55, 2),
('Zumba', 'Dance-based cardio workout', 25, 60, 1),
('Strength Training', 'Weight-based resistance training', 12, 45, 2);

-- Sample data for class_schedule
INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES 
(1, 1, '2024-11-01 10:00:00', '2024-11-01 11:00:00'),
(2, 2, '2024-11-15 18:00:00', '2024-11-15 18:45:00'),
(3, 6, '2024-12-03 07:00:00', '2024-12-03 07:50:00'),
(4, 4, '2024-12-20 09:00:00', '2024-12-20 09:55:00'),
(5, 8, '2025-01-05 19:00:00', '2025-01-05 20:00:00'),
(6, 1, '2025-01-20 12:00:00', '2025-01-20 12:45:00'),
(3, 6, '2025-02-01 14:00:00', '2025-02-01 14:50:00'),
(5, 8, '2025-02-01 19:00:00', '2025-02-01 20:00:00'),
(5, 4, '2025-02-15 09:00:00', '2025-02-15 10:00:00');

-- Sample data for memberships
INSERT INTO memberships (member_id, type, start_date, end_date, status)
VALUES
(1, 'Premium', '2024-11-01', '2025-10-31', 'Active'),
(2, 'Basic', '2024-11-05', '2025-11-04', 'Active'),
(3, 'Premium', '2024-11-10', '2025-11-09', 'Active'),
(4, 'Basic', '2024-11-15', '2025-11-14', 'Active'),
(5, 'Premium', '2024-11-20', '2025-11-19', 'Active'),
(6, 'Basic', '2024-11-25', '2025-11-24', 'Inactive'),
(7, 'Premium', '2024-12-01', '2025-11-30', 'Active'),
(8, 'Basic', '2024-12-05', '2025-12-04', 'Active'),
(9, 'Premium', '2024-12-10', '2025-12-09', 'Active'),
(10, 'Basic', '2024-12-15', '2025-12-14', 'Inactive'),
(11, 'Premium', '2024-12-20', '2025-12-19', 'Active'),
(12, 'Basic', '2024-12-25', '2025-12-24', 'Active'),
(13, 'Premium', '2025-01-01', '2025-12-31', 'Active'),
(14, 'Basic', '2025-01-05', '2026-01-04', 'Inactive'),
(15, 'Premium', '2025-01-10', '2026-01-09', 'Active');

-- Sample data for attendance
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES 
(1, 1, '2024-11-01 09:00:00', '2024-11-01 10:30:00'),
(2, 2, '2024-11-15 17:30:00', '2024-11-15 19:00:00'),
(3, 1, '2024-12-03 08:00:00', '2024-12-03 09:15:00'),
(4, 2, '2024-12-20 12:00:00', '2024-12-20 13:30:00'),
(5, 1, '2025-01-05 16:00:00', '2025-01-05 17:45:00'),
(6, 2, '2025-01-10 07:30:00', '2025-01-10 08:45:00'),
(7, 1, '2025-01-15 18:00:00', '2025-01-15 19:30:00'),
(8, 2, '2025-01-20 10:00:00', '2025-01-20 11:15:00'),
(9, 1, '2025-01-25 14:30:00', '2025-01-25 16:00:00'),
(10, 2, '2025-01-28 19:00:00', '2025-01-28 20:30:00');

-- Sample data for class_attendance
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES 
(1, 1, 'Attended'),
(2, 2, 'Attended'),
(3, 3, 'Attended'),
(4, 4, 'Attended'),
(5, 5, 'Attended'),
(6, 6, 'Registered'),
(7, 7, 'Registered'),
(8, 8, 'Registered'),
(1, 9, 'Attended'),
(2, 10, 'Unattended'),
(3, 11, 'Attended'),
(4, 12, 'Unattended'),
(5, 13, 'Attended'),
(6, 1, 'Registered'),
(7, 2, 'Registered'),
(8, 3, 'Registered');

-- Sample data for payments
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES 
(1, 50.00, '2024-11-01 10:00:00', 'Credit Card', 'Monthly membership fee'),
(2, 30.00, '2024-11-05 14:30:00', 'Bank Transfer', 'Monthly membership fee'),
(3, 50.00, '2024-11-10 09:15:00', 'Credit Card', 'Monthly membership fee'),
(4, 30.00, '2024-11-15 16:45:00', 'PayPal', 'Monthly membership fee'),
(5, 50.00, '2024-11-20 11:30:00', 'Credit Card', 'Monthly membership fee'),
(6, 30.00, '2024-11-25 13:00:00', 'Bank Transfer', 'Monthly membership fee'),
(7, 50.00, '2024-12-01 10:30:00', 'Credit Card', 'Monthly membership fee'),
(8, 30.00, '2024-12-05 15:45:00', 'PayPal', 'Monthly membership fee'),
(9, 50.00, '2024-12-10 08:00:00', 'Credit Card', 'Monthly membership fee'),
(10, 30.00, '2024-12-15 17:30:00', 'Bank Transfer', 'Monthly membership fee'),
(11, 15.00, '2025-01-16 09:00:00', 'Cash', 'Day pass'),
(12, 15.00, '2025-01-16 10:30:00', 'Credit Card', 'Day pass'),
(13, 15.00, '2025-01-17 14:00:00', 'Cash', 'Day pass'),
(14, 15.00, '2025-01-18 11:15:00', 'Credit Card', 'Day pass');

-- Sample data for personal_training_sessions
INSERT INTO personal_training_sessions (member_id, staff_id, session_date, start_time, end_time, notes)
VALUES 
(1, 1, '2024-11-05', '10:00:00', '11:00:00', 'Focus on upper body strength'),
(2, 2, '2024-11-20', '15:00:00', '16:00:00', 'Cardio and endurance training'),
(3, 6, '2024-12-07', '09:00:00', '10:00:00', 'Core workout and flexibility'),
(5, 8, '2024-12-19', '11:00:00', '12:00:00', 'Full body workout'),
(7, 6, '2025-01-11', '13:00:00', '14:00:00', 'Yoga and stretching'),
(9, 3, '2025-01-15', '08:00:00', '09:00:00', 'Morning cardio session'),
(11, 7, '2025-01-20', '12:00:00', '13:00:00', 'Midday flexibility workout'),
(13, 1, '2025-01-25', '15:00:00', '16:00:00', 'Afternoon endurance training'),
(1, 1, '2025-02-05', '10:00:00', '11:00:00', 'Focus on upper body strength'),
(3, 6, '2025-02-07', '09:00:00', '10:00:00', 'Core workout and flexibility'),
(5, 8, '2025-02-09', '11:00:00', '12:00:00', 'Full body workout'),
(7, 6, '2025-02-11', '13:00:00', '14:00:00', 'Yoga and stretching'),
(9, 3, '2025-02-15', '08:00:00', '09:00:00', 'Morning cardio session'),
(11, 7, '2025-02-18', '12:00:00', '13:00:00', 'Midday flexibility workout'),
(13, 1, '2025-02-20', '15:00:00', '16:00:00', 'Afternoon endurance training');

-- Sample data for member_health_metrics
INSERT INTO member_health_metrics (member_id, measurement_date, weight, body_fat_percentage, muscle_mass, bmi)
VALUES 
(1, '2024-11-01', 70.5, 22.0, 35.0, 23.5),
(2, '2024-11-15', 80.0, 18.0, 40.0, 24.0),
(3, '2024-12-01', 65.0, 24.0, 32.0, 22.5),
(4, '2024-12-15', 75.5, 20.0, 38.0, 23.8),
(5, '2025-01-01', 68.0, 23.0, 34.0, 22.8),
(6, '2025-01-15', 82.5, 17.0, 42.0, 24.5),
(7, '2025-01-20', 62.0, 25.0, 30.0, 21.5),
(8, '2025-01-25', 78.0, 19.0, 39.0, 24.2),
(9, '2025-01-28', 72.5, 21.0, 36.0, 23.2),
(10, '2025-01-28', 85.0, 16.0, 43.0, 25.0);

-- Sample data for equipment_maintenance_log 
INSERT INTO equipment_maintenance_log (equipment_id, maintenance_date, description, staff_id)
VALUES 
(1, '2024-11-15', 'Routine maintenance and belt adjustment', 1),
(2, '2024-11-20', 'Lubrication and safety check', 2),
(3, '2024-11-25', 'Calibration and software update', 3),
(4, '2024-11-30', 'Belt replacement and console check', 4),
(5, '2024-12-01', 'Weight stack inspection and cleaning', 5),
(6, '2024-12-05', 'Cable tension adjustment', 6),
(7, '2025-01-01', 'Pedal replacement and chain lubrication', 7),
(8, '2025-01-05', 'Display repair and sensor calibration', 8),
(9, '2025-01-20', 'Frame inspection and tightening', 1),
(10, '2025-01-25', 'Safety features check and padding replacement', 2);