USE pharmacy_management;

-- ============================================
-- 1. INSERT SUPPLIERS
-- ============================================

INSERT INTO Supplier
(supplier_name, contact_no, address)
VALUES
('MediCare Suppliers', '9876543210', 'Pune'),
('HealthPlus Distributors', '9876543211', 'Mumbai'),
('LifeLine Pharma', '9876543212', 'Nashik');


-- ============================================
-- 2. INSERT MANAGERS
-- ============================================

INSERT INTO Manager
(manager_name, contact_no)
VALUES
('Rahul Sharma', '9000000001'),
('Priya Patil', '9000000002');


-- ============================================
-- 3. INSERT CUSTOMERS
-- ============================================

INSERT INTO Customer
(customer_name, contact_no, address, email)
VALUES
('Aarav Joshi', '9111111111', 'Pune', 'aarav@gmail.com'),
('Sneha Kulkarni', '9222222222', 'Mumbai', 'sneha@gmail.com'),
('Riya Deshmukh', '9333333333', 'Nashik', 'riya@gmail.com');


-- ============================================
-- 4. INSERT MEDICINES
-- ============================================

INSERT INTO Medicine
(medicine_name, stock_quantity, expiry_date, selling_price, supplier_id, manager_id)
VALUES
('Paracetamol', 100, '2027-12-31', 25.00, 1, 1),
('Azithromycin', 50, '2027-10-30', 80.00, 2, 1),
('Cetirizine', 70, '2028-05-20', 30.00, 3, 2),
('Amoxicillin', 40, '2027-09-15', 60.00, 1, 2);


-- ============================================
-- 5. INSERT PRESCRIPTIONS
-- ============================================

INSERT INTO Prescription
(customer_id, dosage, prescription_date)
VALUES
(1, '1 tablet twice daily', '2026-09-01'),
(2, '1 tablet once daily', '2026-09-02');


-- ============================================
-- 6. INSERT PRESCRIPTION MEDICINES
-- ============================================

INSERT INTO Prescription_Medicine
(prescription_id, medicine_id, quantity)
VALUES
(1, 1, 10),
(1, 2, 5),
(2, 3, 10);