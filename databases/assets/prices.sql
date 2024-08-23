DROP TABLE IF EXISTS stock_prices;

CREATE TABLE stock_prices AS (
    SELECT
        symbol,
        CURRENT_DATE AS quote_date,
        20.150 AS price
    FROM
        stocks
);