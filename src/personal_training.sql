-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_key = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer

