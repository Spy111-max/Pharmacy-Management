-- ============================================
-- TRIGGERS
-- ============================================

USE pharmacy_management;

DELIMITER //


-- ============================================
-- TRIGGER 1
-- CHECK STOCK BEFORE SALE
-- ============================================

CREATE TRIGGER check_stock_before_sale

BEFORE INSERT
ON Sale_Medicine

FOR EACH ROW

BEGIN

    DECLARE available_stock INT;


    SELECT stock_quantity

    INTO available_stock

    FROM Medicine

    WHERE medicine_id =
        NEW.medicine_id;


    IF available_stock IS NULL THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
        'Medicine does not exist';


    ELSEIF available_stock < NEW.quantity THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
        'Insufficient medicine stock';

    END IF;

END //


-- ============================================
-- TRIGGER 2
-- REDUCE STOCK AND UPDATE SALE TOTAL
-- ============================================

CREATE TRIGGER after_medicine_sale

AFTER INSERT
ON Sale_Medicine

FOR EACH ROW

BEGIN

    -- Reduce medicine stock

    UPDATE Medicine

    SET stock_quantity =
        stock_quantity - NEW.quantity

    WHERE medicine_id =
        NEW.medicine_id;


    -- Update sale amount

    UPDATE Sale

    SET total_amount =
        total_amount
        +
        (NEW.quantity * NEW.selling_price)

    WHERE sale_id =
        NEW.sale_id;

END //


DELIMITER ;