DROP TABLE IF EXISTS newly_acquired_stocks;

CREATE TABLE newly_acquired_stocks (
    symbol TEXT NOT NULL,
    num_shares INT NOT NULL,
    date_acquired DATE NOT NULL
);

INSERT INTO
    newly_acquired_stocks (symbol, num_shares, date_acquired) (
        SELECT
            symbol,
            num_shares,
            date_acquired
        FROM
            stocks
        LIMIT
            3
    );