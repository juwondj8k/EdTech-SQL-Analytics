# 🎓 SkillFlow EdTech Platform — SQL Data Analytics Project

## 📌 Project Overview
This project models and analyzes user engagement, course retention, and learning progress for **SkillFlow**, an online learning platform. Using **PostgreSQL**, this analysis answers key business questions around student retention, engagement metrics, and course drop-off rates.

---

## 🛠️ Tech Stack & SQL Skills Used
* **Database Management System:** PostgreSQL (via pgAdmin)
* **SQL Concepts Applied:**
  * **DDL & DML:** Database schema creation, `FOREIGN KEY` relationships with `CASCADE`, and constraint handling.
  * **Aggregation & Grouping:** `SUM`, `AVG`, `COUNT(CASE WHEN...)` conditional aggregation.
  * **Window Functions:** `DENSE_RANK()` for student performance ranking and `LAG()` for session-over-session watch time tracking.
  * **CTEs (Common Table Expressions):** Modular query structuring for multi-stage calculations.

---

## 🗂️ Database Schema
The database consists of 4 relational tables:
1. **`users`**: Contains learner demography, subscription tiers (`Free`, `Basic`, `Premium`), and signup dates.
2. **`courses`**: Stores course metadata, pricing, difficulty levels, and subject categories.
3. **`enrollments`**: Tracks completion status (`In Progress`, `Completed`, `Dropped`) and completion percentages.
4. **`user_activity`**: Logs session-level learning activity, including watch time (minutes) and quiz scores.

---

## 💡 Key Business Insights & Analytical Queries

### 1. Course Performance & Category Insights
Identifies completion rates and overall engagement across course categories.
```sql
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
