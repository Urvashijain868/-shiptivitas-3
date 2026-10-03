-- TYPE YOUR SQL QUERY BELOW

-- The Kanban Board was released on 2018-06-02 (see README).
-- Logins on or after that day are counted as "After", earlier days as "Before".
-- login_timestamp and timestamp are unix seconds, so date(x, 'unixepoch') gives the calendar day.

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change

-- 1a) Daily average users: one row per period (Before / After).
--     Daily active users (DAU) = number of DISTINCT users who logged in on that day.
--     The average is taken over the days that have at least one login.
WITH daily AS (
    SELECT
        date(login_timestamp, 'unixepoch') AS day,
        COUNT(DISTINCT user_id)            AS daily_active_users
    FROM login_history
    GROUP BY day
)
SELECT
    CASE WHEN day < '2018-06-02' THEN 'Before' ELSE 'After' END AS period,
    COUNT(*)                                                    AS days_with_logins,
    ROUND(AVG(daily_active_users), 2)                           AS avg_daily_active_users
FROM daily
GROUP BY period
ORDER BY period DESC;

-- 1b) The day-by-day numbers behind the graph (one row per day, tagged Before / After).
SELECT
    date(login_timestamp, 'unixepoch')                            AS day,
    COUNT(DISTINCT user_id)                                       AS daily_active_users,
    CASE
        WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'Before'
        ELSE 'After'
    END                                                           AS period
FROM login_history
GROUP BY day
ORDER BY day;


-- PART 2: Create a SQL query that indicates the number of status changes by card

-- A real status change is a row where the card moved from one status to a different one.
-- Rows with oldStatus NULL are the card being created (NULL -> backlog), so they are not counted.
-- LEFT JOIN keeps cards that never changed status, so all 200 cards appear (with 0).
SELECT
    c.id,
    c.name,
    COUNT(h.id) AS status_changes
FROM card AS c
LEFT JOIN card_change_history AS h
       ON h.cardID = c.id
      AND h.oldStatus IS NOT NULL
      AND h.oldStatus <> h.newStatus
GROUP BY c.id, c.name
ORDER BY status_changes DESC, c.id;