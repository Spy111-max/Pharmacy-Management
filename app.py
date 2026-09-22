from flask import Flask, render_template, request, redirect, url_for
from database import get_connection

app = Flask(__name__)


# ============================================================
# DASHBOARD
# ============================================================

@app.route("/")
def dashboard():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Total medicines
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM Medicine
    """)
    total_medicines = cursor.fetchone()["total"]

    # Total customers
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM Customer
    """)
    total_customers = cursor.fetchone()["total"]

    # Total suppliers
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM Supplier
    """)
    total_suppliers = cursor.fetchone()["total"]

    # Low stock medicines
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM Medicine
        WHERE stock_quantity < 20
    """)
    low_stock = cursor.fetchone()["total"]

    # Total sales
    cursor.execute("""
        SELECT COALESCE(SUM(total_amount), 0) AS total
        FROM Sale
    """)
    total_sales = cursor.fetchone()["total"]

    # Low stock medicine list
    cursor.execute("""
        SELECT *
        FROM Medicine
        WHERE stock_quantity < 20
        ORDER BY stock_quantity ASC
        LIMIT 5
    """)
    low_stock_medicines = cursor.fetchall()

    # Medicines expiring in next 30 days
    cursor.execute("""
        SELECT *
        FROM Medicine
        WHERE expiry_date BETWEEN CURRENT_DATE
        AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)
        ORDER BY expiry_date ASC
        LIMIT 5
    """)
    expiring_medicines = cursor.fetchall()

    # Recent sales
    cursor.execute("""
        SELECT
            s.sale_id,
            s.sale_date,
            s.total_amount,
            c.customer_name
        FROM Sale s
        JOIN Customer c
            ON s.customer_id = c.customer_id
        ORDER BY s.sale_id DESC
        LIMIT 5
    """)
    recent_sales = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "index.html",
        total_medicines=total_medicines,
        total_customers=total_customers,
        total_suppliers=total_suppliers,
        low_stock=low_stock,
        total_sales=total_sales,
        low_stock_medicines=low_stock_medicines,
        expiring_medicines=expiring_medicines,
        recent_sales=recent_sales
    )


# ============================================================
# MEDICINES
# ============================================================

@app.route("/medicines")
def medicines():

    search = request.args.get("search", "").strip()

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    if search:

        cursor.execute("""
            SELECT
                m.medicine_id,
                m.medicine_name,
                m.stock_quantity,
                m.expiry_date,
                m.selling_price,
                s.supplier_name,
                mg.manager_name
            FROM Medicine m
            JOIN Supplier s
                ON m.supplier_id = s.supplier_id
            JOIN Manager mg
                ON m.manager_id = mg.manager_id
            WHERE m.medicine_name LIKE %s
            ORDER BY m.medicine_id DESC
        """, (f"%{search}%",))

    else:

        cursor.execute("""
            SELECT
                m.medicine_id,
                m.medicine_name,
                m.stock_quantity,
                m.expiry_date,
                m.selling_price,
                s.supplier_name,
                mg.manager_name
            FROM Medicine m
            JOIN Supplier s
                ON m.supplier_id = s.supplier_id
            JOIN Manager mg
                ON m.manager_id = mg.manager_id
            ORDER BY m.medicine_id DESC
        """)

    medicines_list = cursor.fetchall()

    # Suppliers for Add Medicine form
    cursor.execute("""
        SELECT supplier_id, supplier_name
        FROM Supplier
        ORDER BY supplier_name
    """)
    suppliers = cursor.fetchall()

    # Managers for Add Medicine form
    cursor.execute("""
        SELECT manager_id, manager_name
        FROM Manager
        ORDER BY manager_name
    """)
    managers = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "medicines.html",
        medicines=medicines_list,
        suppliers=suppliers,
        managers=managers,
        search=search
    )


# ============================================================
# ADD MEDICINE
# ============================================================

@app.route("/add-medicine", methods=["POST"])
def add_medicine():

    medicine_name = request.form["medicine_name"]
    stock_quantity = request.form["stock_quantity"]
    expiry_date = request.form["expiry_date"]
    selling_price = request.form["selling_price"]
    supplier_id = request.form["supplier_id"]
    manager_id = request.form["manager_id"]

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO Medicine
        (
            medicine_name,
            stock_quantity,
            expiry_date,
            selling_price,
            supplier_id,
            manager_id
        )
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (
        medicine_name,
        stock_quantity,
        expiry_date,
        selling_price,
        supplier_id,
        manager_id
    ))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect(url_for("medicines"))


# ============================================================
# CUSTOMERS
# ============================================================

@app.route("/customers")
def customers():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            customer_id,
            customer_name,
            contact_no,
            address,
            email
        FROM Customer
        ORDER BY customer_id DESC
    """)

    customers_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "customers.html",
        customers=customers_list
    )


# ============================================================
# ADD CUSTOMER
# ============================================================

@app.route("/add-customer", methods=["POST"])
def add_customer():

    customer_name = request.form["customer_name"]
    contact_no = request.form["contact_no"]
    address = request.form.get("address", "")
    email = request.form.get("email", "")

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO Customer
        (
            customer_name,
            contact_no,
            address,
            email
        )
        VALUES (%s, %s, %s, %s)
    """, (
        customer_name,
        contact_no,
        address,
        email
    ))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect(url_for("customers"))


# ============================================================
# SUPPLIERS
# ============================================================

@app.route("/suppliers")
def suppliers():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            supplier_id,
            supplier_name,
            contact_no,
            address
        FROM Supplier
        ORDER BY supplier_id DESC
    """)

    suppliers_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "suppliers.html",
        suppliers=suppliers_list
    )


# ============================================================
# ADD SUPPLIER
# ============================================================

@app.route("/add-supplier", methods=["POST"])
def add_supplier():

    supplier_name = request.form["supplier_name"]
    contact_no = request.form["contact_no"]
    address = request.form.get("address", "")

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO Supplier
        (
            supplier_name,
            contact_no,
            address
        )
        VALUES (%s, %s, %s)
    """, (
        supplier_name,
        contact_no,
        address
    ))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect(url_for("suppliers"))


# ============================================================
# PRESCRIPTIONS
# ============================================================

@app.route("/prescriptions")
def prescriptions():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Prescription records
    cursor.execute("""
        SELECT
            p.prescription_id,
            p.dosage,
            p.prescription_date,
            c.customer_name
        FROM Prescription p
        JOIN Customer c
            ON p.customer_id = c.customer_id
        ORDER BY p.prescription_id DESC
    """)

    prescriptions_list = cursor.fetchall()

    # Customers for dropdown
    cursor.execute("""
        SELECT
            customer_id,
            customer_name
        FROM Customer
        ORDER BY customer_name
    """)

    customers_list = cursor.fetchall()

    # Medicines for dropdown
    cursor.execute("""
        SELECT
            medicine_id,
            medicine_name
        FROM Medicine
        ORDER BY medicine_name
    """)

    medicines_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "prescriptions.html",
        prescriptions=prescriptions_list,
        customers=customers_list,
        medicines=medicines_list
    )


# ============================================================
# ADD PRESCRIPTION
# ============================================================

@app.route("/add-prescription", methods=["POST"])
def add_prescription():

    customer_id = request.form["customer_id"]
    medicine_id = request.form["medicine_id"]
    dosage = request.form["dosage"]
    quantity = request.form["quantity"]
    prescription_date = request.form["prescription_date"]

    conn = get_connection()
    cursor = conn.cursor()

    try:

        # Create prescription
        cursor.execute("""
            INSERT INTO Prescription
            (
                customer_id,
                dosage,
                prescription_date
            )
            VALUES (%s, %s, %s)
        """, (
            customer_id,
            dosage,
            prescription_date
        ))

        prescription_id = cursor.lastrowid

        # Add medicine to prescription
        cursor.execute("""
            INSERT INTO Prescription_Medicine
            (
                prescription_id,
                medicine_id,
                quantity
            )
            VALUES (%s, %s, %s)
        """, (
            prescription_id,
            medicine_id,
            quantity
        ))

        conn.commit()

    except Exception:

        conn.rollback()
        raise

    finally:

        cursor.close()
        conn.close()

    return redirect(url_for("prescriptions"))


# ============================================================
# SALES
# ============================================================

@app.route("/sales")
def sales():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            s.sale_id,
            s.sale_date,
            s.total_amount,
            c.customer_name,
            m.manager_name
        FROM Sale s
        JOIN Customer c
            ON s.customer_id = c.customer_id
        JOIN Manager m
            ON s.manager_id = m.manager_id
        ORDER BY s.sale_id DESC
    """)

    sales_list = cursor.fetchall()

    cursor.execute("""
        SELECT COALESCE(SUM(total_amount), 0) AS total
        FROM Sale
    """)

    total_sales = cursor.fetchone()["total"]

    cursor.close()
    conn.close()

    return render_template(
        "sales.html",
        sales=sales_list,
        total_sales=total_sales
    )


# ============================================================
# BILLS
# ============================================================

@app.route("/bills")
def bills():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            b.bill_id,
            b.sale_id,
            b.amount,
            b.bill_date,
            c.customer_name
        FROM Bill b
        JOIN Sale s
            ON b.sale_id = s.sale_id
        JOIN Customer c
            ON s.customer_id = c.customer_id
        ORDER BY b.bill_id DESC
    """)

    bills_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "bills.html",
        bills=bills_list
    )


# ============================================================
# APPLICATION START
# ============================================================

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=8000,
        debug=True
    )