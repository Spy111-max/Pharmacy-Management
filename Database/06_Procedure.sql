-- ============================================
-- STORED PROCEDURES
-- ============================================

USE pharmacy_management;

DELIMITER //


-- ============================================
-- PROCEDURE 1: ADD STOCK
-- ============================================

CREATE PROCEDURE AddStock(
    IN p_medicine_id INT,
    IN p_quantity INT
)

BEGIN

    IF p_quantity <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Quantity must be greater than zero';

    ELSE

        UPDATE Medicine

        SET stock_quantity =
            stock_quantity + p_quantity

        WHERE medicine_id =
            p_medicine_id;

    END IF;

END //


-- ============================================
-- PROCEDURE 2: CHECK STOCK
-- ============================================

CREATE PROCEDURE CheckStock(
    IN p_medicine_id INT
)

BEGIN

    DECLARE current_stock INT;


    SELECT stock_quantity
    INTO current_stock

    FROM Medicine

    WHERE medicine_id =
        p_medicine_id;


    IF current_stock IS NULL THEN

        SELECT
            'Medicine Not Found'
            AS Status;


    ELSEIF current_stock = 0 THEN

        SELECT
            'Out of Stock'
            AS Status;


    ELSEIF current_stock < 20 THEN

        SELECT
            'Low Stock'
            AS Status;


    ELSE

        SELECT
            'Stock Available'
            AS Status;

    END IF;

END //


DELIMITER ;


-- ============================================
-- CALL PROCEDURES
-- ============================================

CALL AddStock(1, 20);

CALL CheckStock(1);