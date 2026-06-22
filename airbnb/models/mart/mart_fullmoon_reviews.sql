{{ config(materialized = 'table') }}

WITH
    -- Lấy toàn bộ reviews đã được lọc (không null, chỉ có text)
    fct_reviews AS (SELECT * FROM {{ ref('fct_reviews') }}),

    -- Lấy danh sách ngày trăng tròn từ seed CSV
    full_moon_dates AS (SELECT * FROM {{ ref('seed_full_moon_dates') }})

SELECT
    r.*,  -- Giữ nguyên toàn bộ cột từ fct_reviews

    -- Gắn nhãn: review viết vào ngày SAU ngày trăng tròn → 'full moon'
    -- LEFT JOIN nên nếu không khớp ngày nào → fm.full_moon_date = NULL → 'not full moon'
    CASE WHEN fm.full_moon_date IS NULL THEN 'not full moon'
         ELSE 'full moon'
    END AS is_full_moon

FROM fct_reviews r

-- LEFT JOIN: giữ lại toàn bộ reviews, kể cả review không phải ngày trăng tròn
LEFT JOIN full_moon_dates fm
    -- Điều kiện: review_date == full_moon_date + 1 ngày
    -- (người ta thường viết review vào ngày hôm sau, không phải đúng ngày trăng tròn)
    ON r.review_date::DATE = fm.full_moon_date + INTERVAL '1' DAY
