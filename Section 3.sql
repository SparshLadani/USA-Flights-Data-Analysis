-- Query 1: Extract flight details including tail number, scheduled departure and arrival times, departure delay, arrival delay, and total delay for each flight
SELECT TAIL_NUMBER, SCHEDULED_DEPARTURE, SCHEDULED_ARRIVAL, DEPARTURE_DELAY, ARRIVAL_DELAY, (DEPARTURE_DELAY + ARRIVAL_DELAY) AS TOTAL_DELAY
FROM flight1
WHERE SCHEDULED_ARRIVAL>100;

-- Query 2: Extract flight details along with the states of origin and destination airports
SELECT flight1.*, origin_airport.STATE AS origin_state, destination_airport.STATE AS destination_state
FROM flight1 INNER JOIN airports AS origin_airport ON origin_airport.IATA_CODE = flight1.ORIGIN_AIRPORT
INNER JOIN airports AS destination_airport ON destination_airport.IATA_CODE = flight1.DESTINATION_AIRPORT
ORDER BY flight1.ORIGIN_AIRPORT DESC, flight1.DESTINATION_AIRPORT DESC;

-- Query 3: Count the total number of flights departing from each state
SELECT airports.STATE, COUNT(flight1.TAIL_NUMBER) AS total_flights
FROM flight1
INNER JOIN airports ON airports.IATA_CODE = flight1.ORIGIN_AIRPORT
GROUP BY airports.STATE;

-- Query that selects the information of all flights that are not cancelled
SELECT flight_counts.*, c.CANCELLATION_DESCRIPTION
FROM (
    -- Subquery to select all columns from the flight1 table where the cancellation reason is not 'N'
    SELECT f.*
	FROM flight1 f 
    INNER JOIN cancellation_codes c
    ON f.CANCELLATION_REASON = c.CANCELLATION_REASON
    WHERE f.CANCELLATION_REASON != 'N'
) AS flight_counts

-- Joining the flight_counts subquery with the cancellation_codes table based on the cancellation reason
INNER JOIN cancellation_codes c
ON flight_counts.CANCELLATION_REASON = c.CANCELLATION_REASON;


-- Drop the existing view named flight_details if it exists
DROP VIEW IF EXISTS flight_details;

-- Create a new view named flight_details, combining data from airports and flight1 tables
CREATE VIEW flight_details AS

-- Query that selects flights departing from California
SELECT a.IATA_CODE, a.STATE, f.*
FROM airports a 
INNER JOIN flight1 f ON f.ORIGIN_AIRPORT = a.IATA_CODE
WHERE a.STATE = 'CA';

-- Select all rows from the newly created flight_details view
SELECT * FROM flight_details;

-- Update the flight1 table, setting the CANCELLATION_REASON to 'A' for flights with departure delay greater than 50 minutes
UPDATE flight1 SET CANCELLATION_REASON = 'A' WHERE DEPARTURE_DELAY > 50;

-- Select all rows from the flight_details view again to observe any changes resulting from the update operation
SELECT * FROM flight_details;