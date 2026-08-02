-- Drop tables if they exist
DROP TABLE IF EXISTS user_activity;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;

-- 1. Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE NOT NULL,
    subscription_tier VARCHAR(20) CHECK (subscription_tier IN ('Free', 'Basic', 'Premium')),
    country VARCHAR(50)
);

-- 2. Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced'))
);

-- 3. Enrollments Table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    completion_status VARCHAR(20) CHECK (completion_status IN ('In Progress', 'Completed', 'Dropped')),
    completion_percentage INT CHECK (completion_percentage BETWEEN 0 AND 100)
);

-- 4. User Activity Log Table
CREATE TABLE user_activity (
    activity_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE,
    activity_date DATE NOT NULL,
    watch_time_minutes INT CHECK (watch_time_minutes >= 0),
    quiz_score INT CHECK (quiz_score BETWEEN 0 AND 100)
);

-- Insert Courses
INSERT INTO courses (title, category, price, difficulty_level) VALUES
('Data Analytics Fundamentals', 'Data Science', 49.99, 'Beginner'),
('Advanced SQL for Analysts', 'Data Science', 79.99, 'Intermediate'),
('Python for Automation', 'Programming', 59.99, 'Intermediate'),
('UI/UX Design Essentials', 'Design', 39.99, 'Beginner'),
('Machine Learning Masterclass', 'Data Science', 129.99, 'Advanced');

-- Insert Users
INSERT INTO users (full_name, email, signup_date, subscription_tier, country) VALUES
('Alice Johnson', 'alice@example.com', '2026-01-15', 'Premium', 'Nigeria'),
('Bob Smith', 'bob@example.com', '2026-01-20', 'Free', 'United Kingdom'),
('Chidi Okoro', 'chidi@example.com', '2026-02-01', 'Basic', 'Nigeria'),
('Diana Prince', 'diana@example.com', '2026-02-10', 'Premium', 'United States'),
('Ethan Hunt', 'ethan@example.com', '2026-03-05', 'Free', 'Canada');

-- Insert Enrollments
INSERT INTO enrollments (user_id, course_id, enrollment_date, completion_status, completion_percentage) VALUES
(1, 1, '2026-01-16', 'Completed', 100),
(1, 2, '2026-02-01', 'In Progress', 65),
(2, 1, '2026-01-22', 'Dropped', 20),
(3, 1, '2026-02-02', 'Completed', 100),
(3, 3, '2026-02-15', 'In Progress', 40),
(4, 5, '2026-02-12', 'In Progress', 80),
(5, 4, '2026-03-06', 'Dropped', 10);

-- Insert User Activity
INSERT INTO user_activity (user_id, course_id, activity_date, watch_time_minutes, quiz_score) VALUES
(1, 1, '2026-01-17', 45, 90),
(1, 1, '2026-01-18', 60, 95),
(1, 2, '2026-02-03', 30, 85),
(2, 1, '2026-01-23', 15, 50),
(3, 1, '2026-02-03', 50, 88),
(3, 1, '2026-02-05', 55, 92),
(4, 5, '2026-02-14', 120, 98),
(5, 4, '2026-03-07', 10, 40);
