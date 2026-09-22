-- ============================================
-- CURSOR
-- ============================================

USE pharmacy_management;

DELIMITER //


CREATE PROCEDURE CalculateTotalStockValue()

BEGIN

    -- Flag for detecting end of cursor

    DECLARE done INT DEFAULT 0;


    -- Variables for current medicine

    DECLARE med_stock INT;

    DECLARE med_price DECIMAL(10,2);


    -- Variable for final total

    DECLARE total_value
        DECIMAL(15,2)
        DEFAULT 0;


    -- Create cursor

    DECLARE medicine_cursor CURSOR FOR

        SELECT
            stock_quantity,
            selling_price

        FROM Medicine;


    -- End-of-data handler

    DECLARE CONTINUE HANDLER
    FOR NOT FOUND

        SET done = 1;


    -- Open cursor

    OPEN medicine_cursor;


    -- Start loop

    read_loop:

    LOOP


        -- Get next medicine

        FETCH medicine_cursor

        INTO
            med_stock,
            med_price;


        -- Stop when there are no more rows

        IF done = 1 THEN

            LEAVE read_loop;

        END IF;


        -- Calculate current medicine value

        SET total_value =

            total_value
            +
            (med_stock * med_price);


    END LOOP;


    -- Close cursor

    CLOSE medicine_cursor;


    -- Display final answer

    SELECT
        total_value
        AS Total_Stock_Value;

END //


DELIMITER ;


-- ============================================
-- CALL CURSOR PROCEDURE
-- ============================================

CALL CalculateTotalStockValue();