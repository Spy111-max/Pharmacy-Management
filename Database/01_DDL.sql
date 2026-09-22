-- ============================================
-- DDL
-- PHARMACY MANAGEMENT SYSTEM
-- ============================================

USE pharmacy_management;


-- ============================================
-- 1. SUPPLIER TABLE
-- ============================================

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL
);


-- ============================================
-- 2. MANAGER TABLE
-- ============================================

CREATE TABLE Manager (
    manager_id INT PRIMARY KEY AUTO_INCREMENT,
    manager_name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15) NOT NULL UNIQUE
);


-- ============================================
-- 3. CUSTOMER TABLE
-- ============================================

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL,
    email VARCHAR(100) UNIQUE
);


-- ============================================
-- 4. MEDICINE TABLE
-- ============================================

CREATE TABLE Medicine (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,

    medicine_name VARCHAR(100) NOT NULL,

    stock_quantity INT NOT NULL DEFAULT 0,

    expiry_date DATE NOT NULL,

    selling_price DECIMAL(10,2) NOT NULL DEFAULT 0,

    supplier_id INT NOT NULL,

    manager_id INT NOT NULL,

    -- CHECK CONSTRAINT
    CONSTRAINT chk_stock
        CHECK (stock_quantity >= 0),

    CONSTRAINT chk_medicine_price
        CHECK (selling_price >= 0),

    -- FOREIGN KEY: SUPPLIER
    CONSTRAINT fk_medicine_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- FOREIGN KEY: MANAGER
    CONSTRAINT fk_medicine_manager
        FOREIGN KEY (manager_id)
        REFERENCES Manager(manager_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================
-- 5. PRESCRIPTION TABLE
-- ============================================

CREATE TABLE Prescription (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,

    customer_id INT NOT NULL,

    dosage VARCHAR(100) NOT NULL,

    prescription_date DATE NOT NULL,

    CONSTRAINT fk_prescription_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================
-- 6. SALE TABLE
-- ============================================

CREATE TABLE Sale (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,

    customer_id INT NOT NULL,

    manager_id INT NOT NULL,

    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,

    sale_date DATE NOT NULL,

    CONSTRAINT chk_sale_amount
        CHECK (total_amount >= 0),

    CONSTRAINT fk_sale_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_sale_manager
        FOREIGN KEY (manager_id)
        REFERENCES Manager(manager_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================
-- 7. BILL TABLE
-- ============================================

CREATE TABLE Bill (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,

    sale_id INT NOT NULL UNIQUE,

    amount DECIMAL(10,2) NOT NULL,

    bill_date DATE NOT NULL,

    CONSTRAINT chk_bill_amount
        CHECK (amount >= 0),

    CONSTRAINT fk_bill_sale
        FOREIGN KEY (sale_id)
        REFERENCES Sale(sale_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================
-- 8. PRESCRIPTION_MEDICINE
-- MANY-TO-MANY BRIDGE TABLE
-- ============================================

CREATE TABLE Prescription_Medicine (
    prescription_id INT NOT NULL,

    medicine_id INT NOT NULL,

    quantity INT NOT NULL,

    PRIMARY KEY (prescription_id, medicine_id),

    CONSTRAINT chk_prescription_quantity
        CHECK (quantity > 0),

    CONSTRAINT fk_pm_prescription
        FOREIGN KEY (prescription_id)
        REFERENCES Prescription(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_pm_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES Medicine(medicine_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================
-- 9. SALE_MEDICINE
-- MANY-TO-MANY BRIDGE TABLE
-- ============================================

CREATE TABLE Sale_Medicine (
    sale_id INT NOT NULL,

    medicine_id INT NOT NULL,

    quantity INT NOT NULL,

    selling_price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (sale_id, medicine_id),

    CONSTRAINT chk_sale_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_sale_medicine_price
        CHECK (selling_price >= 0),

    CONSTRAINT fk_sm_sale
        FOREIGN KEY (sale_id)
        REFERENCES Sale(sale_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sm_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES Medicine(medicine_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);