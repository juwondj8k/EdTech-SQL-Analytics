-- ===================================================
-- SKILLFLOW EDTECH PLATFORM ANALYTICAL QUERIES
-- ===================================================

-- 1. Course Performance & Category Completion Rates
SELECT 
    c.category,
    COUNT(DISTINCT e.user_id) AS total_unique_students,
    COUNT(e.enrollment_id) AS total_enrollments,
    ROUND(AVG(e.completion_percentage), 2) AS avg_completion_pct,
    COUNT(CASE WHEN e.completion_status = 'Completed' THEN 1 END) AS completed_count,
    COUNT(CASE WHEN e.completion_status = 'Dropped' THEN 1 END) AS dropped_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.category
ORDER BY avg_completion_pct DESC;


-- 2. User Engagement & Performance Scorecard
SELECT 
    u.user_id,
    u.full_name,
    u.subscription_tier,
    u.country,
    COALESCE(SUM(ua.watch_time_minutes), 0) AS total_watch_time_mins,
    ROUND(AVG(ua.quiz_score), 1) AS avg_quiz_score,
    COUNT(ua.activity_id) AS total_learning_sessions
FROM users u
LEFT JOIN user_activity ua ON u.user_id = ua.user_id
GROUP BY u.user_id, u.full_name, u.subscription_tier, u.country
ORDER BY total_watch_time_mins DESC;


-- 3. Top Student Ranking per Course (Window Function: DENSE_RANK)
WITH StudentCourseScores AS (
    SELECT 
        u.full_name,
        c.title AS course_title,
        MAX(ua.quiz_score) AS max_quiz_score
    FROM user_activity ua
    JOIN users u ON ua.user_id = u.user_id
    JOIN courses c ON ua.course_id = c.course_id
    GROUP BY u.full_name, c.title
)
SELECT 
    course_title,
    full_name,
    max_quiz_score,
    DENSE_RANK() OVER (PARTITION BY course_title ORDER BY max_quiz_score DESC) AS student_rank
FROM StudentCourseScores;


-- 4. Session-over-Session Engagement Delta (Window Function: LAG)
WITH UserSessions AS (
    SELECT 
        u.full_name,
        c.title AS course_title,
        ua.activity_date,
        ua.watch_time_minutes,
        LAG(ua.watch_time_minutes, 1) OVER (
            PARTITION BY ua.user_id, ua.course_id 
            ORDER BY ua.activity_date
        ) AS previous_session_mins
    FROM user_activity ua
    JOIN users u ON ua.user_id = u.user_id
    JOIN courses c ON ua.course_id = c.course_id
)
SELECT 
    full_name,
    course_title,
    activity_date,
    watch_time_minutes,
    COALESCE(previous_session_mins, 0) AS previous_session_mins,
    (watch_time_minutes - COALESCE(previous_session_mins, 0)) AS watch_time_change_mins
FROM UserSessions
ORDER BY full_name, activity_date;
