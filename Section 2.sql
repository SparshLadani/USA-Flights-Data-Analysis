-- Drop the DeleteFromTables procedure if it already exists
DROP PROCEDURE IF EXISTS DeleteFromTables;
-- Drop the UpdateTable procedure if it already exists
DROP PROCEDURE IF EXISTS UpdateTable;

DELIMITER //

-- Create the DeleteFromTables procedure
CREATE PROCEDURE DeleteFromTables(
    IN d_delay INT,
    IN a_delay INT
)
BEGIN
    -- Start a transaction to ensure atomicity
    START TRANSACTION;
    -- Delete flights with departure delay less than the specified departure delay parameter
    DELETE FROM flight1 WHERE DEPARTURE_DELAY < d_delay;
    -- Delete flights with arrival delay less than the specified arrival delay parameter
    DELETE FROM flight1 WHERE ARRIVAL_DELAY < a_delay;
    -- Commit the transaction to make the changes permanent
    COMMIT;
END//

DELIMITER ;

DELIMITER //

-- Create the UpdateTable procedure
CREATE PROCEDURE UpdateTable(
    IN d_delay INT,
    IN a_delay INT
)
BEGIN
    -- Start a transaction
    START TRANSACTION;
    -- Update flights with departure delay less than the specified departure delay parameter, setting cancellation reason to 'A'
    UPDATE flight1 SET CANCELLATION_REASON = 'A' WHERE DEPARTURE_DELAY < d_delay;
    -- Update flights with arrival delay less than the specified arrival delay parameter, setting cancellation reason to 'B'
    UPDATE flight1 SET CANCELLATION_REASON = 'B' WHERE ARRIVAL_DELAY < a_delay;
    -- Commit the transaction to make the changes permanent
    COMMIT;
END//

DELIMITER ;

-- Call the DeleteFromTables procedure to delete flights based on specified delays
CALL DeleteFromTables(10, 20);
-- Call the UpdateTable procedure to update cancellation reasons based on specified delays
CALL UpdateTable(40,50);
