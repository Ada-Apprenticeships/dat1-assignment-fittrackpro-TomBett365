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