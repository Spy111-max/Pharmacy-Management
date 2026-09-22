-- ============================================
-- DQL / SQL QUERIES
-- ============================================

USE pharmacy_management;


-- 1. DISPLAY ALL MEDICINES

SELECT *
FROM Medicine;


-- 2. DISPLAY MEDICINES WITH LOW STOCK

SELECT *
FROM Medicine
WHERE stock_quantity < 20;


-- 3. DISPLAY MEDICINES STARTING WITH A

SELECT *
FROM Medicine
WHERE medicine_name LIKE 'A%';


-- 4. DISPLAY MEDICINES WITH STOCK BETWEEN 50 AND 100

SELECT *
FROM Medicine
WHERE stock_quantity BETWEEN 50 AND 100;


-- 5. DISPLAY MEDICINES FROM SUPPLIER 1 OR 2

SELECT *
FROM Medicine
WHERE supplier_id IN (1, 2);


-- 6. SORT MEDICINES BY STOCK

SELECT medicine_name, stock_quantity
FROM Medicine
ORDER BY stock_quantity DESC;


-- 7. COUNT MEDICINES

SELECT COUNT(*) AS total_medicines
FROM Medicine;


-- 8. TOTAL STOCK

SELECT SUM(stock_quantity) AS total_stock
FROM Medicine;


-- 9. MAXIMUM STOCK

SELECT MAX(stock_quantity) AS maximum_stock
FROM Medicine;


-- 10. MINIMUM STOCK

SELECT MIN(stock_quantity) AS minimum_stock
FROM Medicine;


-- 11. MEDICINES WITH SUPPLIER NAME

SELECT
    m.medicine_id,
    m.medicine_name,
    s.supplier_name
FROM Medicine m
JOIN Supplier s
ON m.supplier_id = s.supplier_id;


-- 12. MEDICINE + SUPPLIER + MANAGER

SELECT
    m.medicine_name,
    s.supplier_name,
    mg.manager_name
FROM Medicine m

JOIN Supplier s
ON m.supplier_id = s.supplier_id

JOIN Manager mg
ON m.manager_id = mg.manager_id;


-- 13. CUSTOMER AND THEIR SALES

SELECT
    c.customer_name,
    s.sale_id,
    s.total_amount
FROM Customer c
JOIN Sale s
ON c.customer_id = s.customer_id;


-- 14. TOTAL PURCHASE BY EACH CUSTOMER

SELECT
    c.customer_name,
    SUM(s.total_amount) AS total_purchase
FROM Customer c

JOIN Sale s
ON c.customer_id = s.customer_id

GROUP BY
    c.customer_id,
    c.customer_name;


-- 15. SUPPLIERS HAVING MORE THAN ONE MEDICINE

SELECT
    supplier_id,
    COUNT(*) AS medicine_count
FROM Medicine

GROUP BY supplier_id

HAVING COUNT(*) > 1;


-- 16. EXPIRED MEDICINES

SELECT *
FROM Medicine
WHERE expiry_date < CURRENT_DATE;


-- 17. MEDICINES EXPIRING WITHIN 30 DAYS

SELECT *
FROM Medicine

WHERE expiry_date
BETWEEN CURRENT_DATE
AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY);


-- 18. TOTAL SALES

SELECT
    SUM(total_amount) AS total_sales
FROM Sale;