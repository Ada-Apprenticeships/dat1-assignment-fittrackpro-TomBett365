-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Create your tables here
/* CREATE TABLE locations (
    location_id     INT     INT(1)          NOT NULL    PRIMARY KEY             CHECK(length(location_id) = 1),
    name            TEXT    VARCHAR(10),
    address         TEXT    VARCHAR(20),
    phone_number    TEXT    VARCHAR(8)      CHECK(length(phone_number) = 8)     CHECK(phone_number LIKE '%-%'),
    email           TEXT    VARCHAR(20)     CHECK(email LIKE '%@%'),
    opening_hours   TEXT    VARCHAR(10)     CHECK(opening_hours LIKE '%-%')     CHECK(length(opening_hours) = 10)
);

CREATE TABLE members (
    member_id                   INT     INT(1)          NOT NULL    PRIMARY KEY      CHECK(length(member_id) = 1),
    first_name                  TEXT    VARCHAR(10),
    last_name                   TEXT    VARCHAR(10),
    email                       TEXT    VARCHAR(20)     CHECK(email LIKE '%@%'),
    phone_number                TEXT    VARCHAR(8)      CHECK(length(phone_number) = 8)     CHECK(phone_number LIKE '%-%'),
    date_of_birth               TEXT    VARCHAR(10)     CHECK(length(date_of_birth) = 10)   CHECK(date_of_birth LIKE '%-%'),
    join_date                   TEXT    VARCHAR(10)     CHECK(length(join_date) = 10)       CHECK(join_date LIKE '%-%'),
    emergency_contact_name      TEXT    VARCHAR(15),
    emergency_contact_phone     TEXT    VARCHAR(8)      CHECK(length(emergency_contact_phone) = 8)      CHECK(emergency_contact_phone LIKE '%-%')   
);

CREATE TABLE staff (
    staff_id        INT     INT(1)          NOT NULL    PRIMARY KEY,
    first_name      TEXT    VARCHAR(10),
    last_name       TEXT    VARCHAR(10),
    email           TEXT    VARCHAR(20)     CHECK(email LIKE '%@%'),
    phone_number    TEXT    VARCHAR(8)      CHECK(length(phone_number) = 8)     CHECK(phone_number LIKE '%-%'),
    position        TEXT    VARCHAR(10),
    hire_date       TEXT    VARCHAR(10)     CHECK(length(hire_date) = 10)       CHECK(hire_date LIKE '%-%'),
    location_id     INT     INT(1)          CHECK(length(location_id) = 1)
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id            INT     INT(1)          NOT NULL    PRIMARY KEY     CHECK(length(location_id) = 1)
    name                    TEXT    VARCHAR(10),
    type                    TEXT    VARCHAR(10),
    purchase_date           TEXT    VARCHAR(10)     CHECK(length(purchase_date) = 10)                CHECK(purchase_date LIKE '%-%'),
    last_maintainance_date  TEXT    VARCHAR(10)     CHECK(length(last_maintainance_date) = 10)       CHECK(last_maintainance_date LIKE '%-%'),
    next_maintainance_date  TEXT    VARCHAR(10)     CHECK(length(next_maintainance_date) = 10)       CHECK(next_maintainance_date LIKE '%-%'),
    location_id             INT     INT(1)          CHECK(length(location_id) = 1)
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id        INT     INT(1)      NOT NULL    PRIMARY KEY      CHECK(length(location_id) = 1),
    name            TEXT    VARCHAR(10),
    description     TEXT    VARCHAR(35),
    capacity        INT     INT(2)      CHECK(length(capacity) = 2),
    duration        INT     INT(2)      CHECK(length(duration) = 2),
    location_id     INT     INT(1)      CHECK(length(location_id) = 1),
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id     INT     INT(1)      NOT NULL    PRIMARY KEY      CHECK(length(schedule_id) = 1),
    class_id        INT     INT(1)      CHECK(length(class_id) = 1),
    staff_id        INT     INT(1)      CHECK(length(staff_id) = 1),
    start_time      TEXT    VARCHAR(19) CHECK(length(start_time) = 19),
    end_time        TEXT    VARCHAR(19) CHECK(length(end_time) = 19)
);

CREATE TABLE memberships (
    membership_id   INT     INT(1)      NOT NULL    PRIMARY KEY     CHECK(length(membership_id) = 1),
    member_id       INT     INT(1)      CHECK(length(member_id) = 1),
    type            TEXT    VARCHAR(10),
    start_date      TEXT    VARCHAR(10) CHECK(length(end_date) = 10),
    end_date        TEXT    VARCHAR(10) CHECK(length(end_date) = 10),
    status          TEXT    VARCHAR(10) CHECK(length(status) = 6 OR length(status) = 8)
);

*/

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


CREATE TABLE locations (  
    location_id INTEGER CHECK(length(location_id) >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    name VARCHAR(255) CHECK(length(name) <= 255),  
    address VARCHAR(20) CHECK(length(address) < 20),  
    phone_number VARCHAR(8) CHECK(length(phone_number) = 8),  
    email VARCHAR(255) CHECK(email LIKE '%@%') CHECK(length(email) <= 255),  
    opening_hours VARCHAR(10) CHECK(length(opening_hours) = 10)  
);  
  
-- `members` table  
CREATE TABLE members (  
    member_id INTEGER CHECK(length(member_id) >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    first_name VARCHAR(255) CHECK(length(first_name) <= 255),  
    last_name VARCHAR(255) CHECK(length(last_name) <= 255),  
    email VARCHAR(255) CHECK(email LIKE '%@%') CHECK(length(email) <= 255),  
    phone_number VARCHAR(20) CHECK(length(phone_number) = 8) CHECK(phone_number LIKE '%-%'),  
    date_of_birth DATE,  
    join_date DATE,  
    emergency_contact_name VARCHAR(255),  
    emergency_contact_phone VARCHAR(20) CHECK(length(emergency_contact_phone) = 8) CHECK(emergency_contact_phone LIKE '%-%') 
);  
  
-- `staff` table  
CREATE TABLE staff (  
    staff_id INTEGER CHECK(length(staff_id) >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(255) CHECK(length(first_name) <= 255),
    last_name VARCHAR(255) CHECK(length(last_name) <= 255),
    email VARCHAR(255) CHECK(email LIKE '%@%') CHECK(length(email) <= 255),
    phone_number VARCHAR(20) CHECK(length(phone_number) = 8) CHECK(phone_number LIKE '%-%'),  
    position VARCHAR(40) CHECK(length(position) <= 40),
    hire_date DATE,
    location_id INTEGER CHECK(length(location_id) >= 1),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);  
  
-- `equipment` table  
CREATE TABLE equipment (  
    equipment_id INTEGER CHECK(length(equipment_id) >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    name VARCHAR(255) CHECK(length(name) <= 255),
    type VARCHAR(40) CHECK(length(type) <= 40) CHECK(type = 'Cardio' OR type = 'Strength'),  
    purchase_date DATE,  
    last_maintenance_date DATE,  
    next_maintenance_date DATE,  
    location_id INTEGER CHECK(length(location_id) >= 1),  
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  
);  
  
-- `classes` table  
CREATE TABLE classes (  
    class_id INTEGER CHECK(class_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    name VARCHAR(255) CHECK(length(name) <= 255),  
    description VARCHAR(255) CHECK(length(description) <= 255),  
    capacity INTEGER CHECK(capacity >= 1),  
    duration INTEGER CHECK(duration) >= 1),  
    location_id INTEGER CHECK(location_id >= 1),  
    FOREIGN KEY (location_id) REFERENCES locations(location_id)  
);  
  
-- `class_schedule` table  
CREATE TABLE class_schedule (  
    schedule_id INTEGER CHECK(schedule_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    class_id INTEGER CHECK(class_id >= 1),  
    staff_id INTEGER CHECK(staff_id >= 1),  
    start_time DATETIME,  
    end_time DATETIME,  
    FOREIGN KEY (class_id) REFERENCES classes(class_id),  
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  
);  
  
-- `memberships` table  
CREATE TABLE memberships (  
    membership_id INTEGER CHECK(membership_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    member_id INTEGER,  
    type VARCHAR(255) CHECK(length(type) <= 255), 
    start_date DATE,
    end_date DATE,
    status VARCHAR(40) CHECK(status = 'Active' OR status = 'Inactive'),  
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);  
  
-- `attendance` table  
CREATE TABLE attendance (  
    attendance_id INTEGER CHECK(attendance_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    member_id INTEGER CHECK(member_id >= 1),  
    location_id INTEGER CHECK(location_id >= 1),  
    check_in_time DATETIME,  
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id),  
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);  
  
-- `class_attendance` table  
CREATE TABLE class_attendance (  
    class_attendance_id INTEGER CHECK(class_attendance_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    schedule_id INTEGER CHECK(schedule_id >= 1),  
    member_id INTEGER CHECK(member_id >= 1),  
    attendance_status VARCHAR(40) CHECK(length(attendance_status) <=40),  
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id), 
    FOREIGN KEY (member_id) REFERENCES members(member_id)  
);  
  
-- `payments` table  
CREATE TABLE payments (  
    payment_id INTEGER CHECK(payment_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    member_id INTEGER CHECK(member_id >= 1),  
    amount DECIMAL(10, 2),  
    payment_date DATE,  
    payment_method VARCHAR(40) CHECK(length(payment_method) <= 40),  
    payment_type VARCHAR(40) CHECK(length(payment_type) <= 40),  
    FOREIGN KEY (member_id) REFERENCES members(member_id)  
);  
  
-- `personal_training_sessions` table  
CREATE TABLE personal_training_sessions (  
    session_id INTEGER CHECK(session_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    member_id INTEGER CHECK(member_id >= 1),  
    staff_id INTEGER CHECK(staff_id >= 1),  
    session_date DATE,  
    start_time TIME,  
    end_time TIME,  
    notes VARCHAR(255) CHECK(length(notes) <= 255),  
    FOREIGN KEY (member_id) REFERENCES members(member_id),  
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  
);  
  
-- `member_health_metrics` table  
CREATE TABLE member_health_metrics (  
    metric_id INTEGER CHECK(metric_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    member_id INTEGER CHECK(member_id >= 1),  
    measurement_date DATE,  
    weight DECIMAL(5, 2),  
    body_fat_percentage DECIMAL(5, 2),  
    muscle_mass DECIMAL(5, 2),  
    bmi DECIMAL(5, 2),  
    FOREIGN KEY (member_id) REFERENCES members(member_id)  
);  
  
-- `equipment_maintenance_log` table  
CREATE TABLE equipment_maintenance_log ( 
    log_id INTEGER CHECK(log_id >= 1) NOT NULL PRIMARY KEY AUTOINCREMENT,  
    equipment_id INTEGER CHECK(equipment_id >= 1),
    maintenance_date DATE,
    description VARCHAR(255) CHECK(length(description) <= 255),
    staff_id INTEGER CHECK(staff_id >= 1),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);  