USE pharmacy_management;

-- ============================================
-- 1. INSERT SALES
-- ============================================

INSERT INTO Sale
(customer_id, manager_id, total_amount, sale_date)
VALUES
(1, 1, 0, '2026-09-10');

INSERT INTO Sale
(customer_id, manager_id, total_amount, sale_date)
VALUES
(2, 2, 0, '2026-09-11');


-- ============================================
-- 2. INSERT SALE MEDICINES
-- ============================================

INSERT INTO Sale_Medicine
(sale_id, medicine_id, quantity, selling_price)
VALUES
(1, 1, 2, 25.00);

INSERT INTO Sale_Medicine
(sale_id, medicine_id, quantity, selling_price)
VALUES
(1, 3, 3, 30.00);

INSERT INTO Sale_Medicine
(sale_id, medicine_id, quantity, selling_price)
VALUES
(2, 2, 2, 80.00);


-- ============================================
-- 3. INSERT BILLS
-- ============================================

INSERT INTO Bill
(sale_id, amount, bill_date)
VALUES
(1, 140.00, '2026-09-10');

INSERT INTO Bill
(sale_id, amount, bill_date)
VALUES
(2, 160.00, '2026-09-11');