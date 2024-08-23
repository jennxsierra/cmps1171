-- [CMPS1171-1] Introduction to Databases Project 1
-- Andres Hung & Jennessa Sierra
-- 2024/02/23

/* QUERIES */

-- 1. For each show, the artists who are performing at that show
SELECT S.name AS show_name, A.first_name, A.last_name
FROM shows AS S
INNER JOIN performances AS P
USING (show_id)
INNER JOIN artists AS A
USING (artist_id);

-- 2. The district which has the most venues
SELECT D.name AS most_venues_district, COUNT(V.venue_id) AS venue_count
FROM districts AS D
INNER JOIN venues AS V
ON D.district_id = V.district
GROUP BY D.name
ORDER BY venue_count DESC
LIMIT 1;

-- 3. For each venue, the shows that are performed there
SELECT V.name AS venue_name, S.name AS show_name
FROM venues AS V
LEFT OUTER JOIN shows AS S
ON V.venue_id = S.venue;

-- 4. The district where the most artists live
SELECT D.name AS most_artists_district, COUNT(A.artist_id) AS artist_count
FROM districts AS D
INNER JOIN artists AS A
ON D.district_id = A.district
GROUP BY D.name
ORDER BY artist_count DESC
LIMIT 1;

-- 5. The most expensive show and when and where that show occurred
SELECT S.name AS show_name, V.name AS venue_name, S.start_date, S.end_date, S.price
FROM shows AS S
INNER JOIN venues AS V
ON S.venue = V.venue_id
ORDER BY S.price DESC
LIMIT 1;