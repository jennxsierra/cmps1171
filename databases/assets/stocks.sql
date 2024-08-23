DROP TABLE IF EXISTS STOCKS;

CREATE TABLE stocks (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL,
    num_shares INT NOT NULL,
    date_acquired DATE NOT NULL DEFAULT CURRENT_DATE
);

--\copy stocks (symbol, num_shares, date_acquired) FROM './stocks.txt' DELIMITER ',';