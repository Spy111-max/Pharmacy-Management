-- ============================================
-- VIEW
-- ============================================

USE pharmacy_management;


CREATE VIEW MedicineDetails AS

SELECT

    m.medicine_id,

    m.medicine_name,

    m.stock_quantity,

    m.selling_price,

    m.expiry_date,

    s.supplier_name,

    mg.manager_name

FROM Medicine m

JOIN Supplier s

ON m.supplier_id =
   s.supplier_id

JOIN Manager mg

ON m.manager_id =
   mg.manager_id;


-- ============================================
-- DISPLAY VIEW
-- ============================================

SELECT *
FROM MedicineDetails;