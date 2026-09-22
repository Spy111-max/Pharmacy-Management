-- ============================================
-- STORED FUNCTION
-- ============================================

USE pharmacy_management;

DELIMITER //


CREATE FUNCTION StockValue(
    p_medicine_id INT
)

RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

    DECLARE total_value DECIMAL(10,2);


    SELECT
        stock_quantity * selling_price

    INTO total_value

    FROM Medicine

    WHERE medicine_id =
        p_medicine_id;


    RETURN IFNULL(total_value, 0);

END //


DELIMITER ;


-- ============================================
-- USE FUNCTION
-- ============================================

SELECT
    medicine_id,
    medicine_name,
    StockValue(medicine_id)
    AS stock_value

FROM Medicine;