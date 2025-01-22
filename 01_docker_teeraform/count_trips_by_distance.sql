SELECT
    range_name,
    COUNT(*) AS trip_distance
FROM (
    SELECT
        CASE
            WHEN trip_distance <= 1 THEN 'Up to 1 Miles'
            WHEN trip_distance > 1 AND trip_distance <= 3 THEN 'Between 1 Miles and 3 Miles'
            WHEN trip_distance > 3 AND trip_distance <= 7 THEN 'Between 3 Miles and 7 Miles'
            WHEN trip_distance > 7 AND trip_distance <= 10 THEN 'Between 7 M ilesand 10 Miles'
            WHEN trip_distance > 10 THEN 'Over 10 Miles'
            ELSE 'Unknown'
        END AS range_name
    FROM
        ny_green_taxi 
    WHERE
        lpep_pickup_datetime >= '2019-10-01 00:00:00' AND lpep_dropoff_datetime < '2019-11-01 00:00:00' 
) AS subquery
GROUP BY
    range_name
ORDER BY
    CASE range_name
        WHEN 'Up to 1 Miles' THEN 1
        WHEN 'Between 1 Miles and 3 Miles' THEN 2
        WHEN 'Between 3 Miles and 7 Miles' THEN 3
        WHEN 'Between 7 M ilesand 10 Miles' THEN 4
        WHEN 'Over 10 Miles' THEN 5
        ELSE 6
    END;
