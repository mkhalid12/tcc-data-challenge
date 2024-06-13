CREATE TABLE IF NOT EXISTS stg.time (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    year INT,
    quarter INT,
    month INT,
    day INT,
    day_of_week INT,
    day_name VARCHAR(10),
    week_of_year INT,
    is_weekend BOOLEAN
);