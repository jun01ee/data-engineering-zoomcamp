DROP TABLE IF EXISTS events;
CREATE TABLE events (
    lpep_pickup_datetime TIMESTAMP NOT NULL,
    lpep_dropoff_datetime TIMESTAMP NOT NULL,
    PULocationID INT NOT NULL,
    DOLocationID INT NOT NULL,
    passenger_count DOUBLE PRECISION,
    trip_distance DOUBLE PRECISION,
    fare_amount DOUBLE PRECISION
);

DROP TABLE IF EXISTS processed_events_aggregated;
CREATE TABLE processed_events_aggregated (
    window_start TIMESTAMP(3),
    window_end TIMESTAMP(3),
    PULocationID INT,
    DOLocationID INT,
    num_trips BIGINT
);

SELECT *, window_end - window_start AS streak_duration
FROM processed_events_aggregated
ORDER BY num_trips DESC
LIMIT 1;
