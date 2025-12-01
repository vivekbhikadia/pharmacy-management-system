-- Pharmacy Management System Database Schema

-- Users Table (Admin & Staff)
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'staff')),
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers Table
CREATE TABLE customers (
    customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_type VARCHAR(20) NOT NULL CHECK (customer_type IN ('retail', 'wholesale', 'distributor')),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    gstin VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    area VARCHAR(50),
    credit_limit DECIMAL(12,2) DEFAULT 0,
    payment_terms VARCHAR(20) DEFAULT 'cash',
    outstanding_amount DECIMAL(12,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    gstin VARCHAR(15),
    address TEXT,
    payment_terms VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products/Medicines Table
CREATE TABLE products (
    product_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_name VARCHAR(200) NOT NULL,
    generic_name VARCHAR(200),
    company_id UUID REFERENCES suppliers(supplier_id),
    hsn_code VARCHAR(20),
    gst_rate DECIMAL(5,2) NOT NULL CHECK (gst_rate IN (0, 5, 18)),
    mrp DECIMAL(10,2) NOT NULL,
    retail_price DECIMAL(10,2) NOT NULL,
    wholesale_price DECIMAL(10,2),
    distributor_price DECIMAL(10,2),
    unit VARCHAR(20) DEFAULT 'strip',
    min_stock_level INTEGER DEFAULT 10,
    product_image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory/Stock Table
CREATE TABLE inventory (
    inventory_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(product_id),
    batch_number VARCHAR(50) NOT NULL,
    expiry_date DATE NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    allocated_retail INTEGER DEFAULT 0,
    allocated_wholesale INTEGER DEFAULT 0,
    purchase_price DECIMAL(10,2),
    supplier_id UUID REFERENCES suppliers(supplier_id),
    received_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id, batch_number)
);

-- Sales Orders Table
CREATE TABLE sales_orders (
    order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('retail', 'wholesale')),
    customer_id UUID REFERENCES customers(customer_id),
    user_id UUID REFERENCES users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    gst_amount DECIMAL(12,2) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20) DEFAULT 'pending',
    payment_terms VARCHAR(20),
    due_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sales Order Items Table
CREATE TABLE sales_order_items (
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES sales_orders(order_id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(product_id),
    inventory_id UUID REFERENCES inventory(inventory_id),
    batch_number VARCHAR(50),
    expiry_date DATE,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,
    gst_rate DECIMAL(5,2) NOT NULL,
    gst_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Purchase Orders Table
CREATE TABLE purchase_orders (
    purchase_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_number VARCHAR(50) UNIQUE NOT NULL,
    supplier_id UUID REFERENCES suppliers(supplier_id),
    user_id UUID REFERENCES users(user_id),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(12,2) NOT NULL,
    gst_amount DECIMAL(12,2) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Purchase Order Items Table
CREATE TABLE purchase_order_items (
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_id UUID REFERENCES purchase_orders(purchase_id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(product_id),
    batch_number VARCHAR(50),
    expiry_date DATE,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    gst_rate DECIMAL(5,2) NOT NULL,
    gst_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES sales_orders(order_id),
    customer_id UUID REFERENCES customers(customer_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    reference_number VARCHAR(100),
    notes TEXT,
    created_by UUID REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Schemes/Discounts Table
CREATE TABLE schemes (
    scheme_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scheme_name VARCHAR(100) NOT NULL,
    scheme_type VARCHAR(20) CHECK (scheme_type IN ('percentage', 'flat', 'buy_x_get_y')),
    discount_value DECIMAL(10,2),
    min_quantity INTEGER,
    applicable_to VARCHAR(20) CHECK (applicable_to IN ('all', 'retail', 'wholesale')),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors Table
CREATE TABLE doctors (
    doctor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    hospital VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prescriptions Table
CREATE TABLE prescriptions (
    prescription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customers(customer_id),
    doctor_id UUID REFERENCES doctors(doctor_id),
    prescription_date DATE DEFAULT CURRENT_DATE,
    prescription_image_url TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Activity Logs Table
CREATE TABLE activity_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    details JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Salesman Table
CREATE TABLE salesmen (
    salesman_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    commission_rate DECIMAL(5,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Deliveryman Table
CREATE TABLE deliverymen (
    deliveryman_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    vehicle_number VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Performance
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_expiry ON inventory(expiry_date);
CREATE INDEX idx_sales_orders_date ON sales_orders(order_date);
CREATE INDEX idx_sales_orders_customer ON sales_orders(customer_id);
CREATE INDEX idx_customers_type ON customers(customer_type);
CREATE INDEX idx_activity_logs_user ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_date ON activity_logs(created_at);

-- Views for Reports

-- Sales Summary View
CREATE VIEW v_sales_summary AS
SELECT 
    DATE(order_date) as sale_date,
    order_type,
    COUNT(*) as total_orders,
    SUM(subtotal) as total_subtotal,
    SUM(discount_amount) as total_discount,
    SUM(gst_amount) as total_gst,
    SUM(total_amount) as total_sales
FROM sales_orders
GROUP BY DATE(order_date), order_type;

-- Low Stock View
CREATE VIEW v_low_stock AS
SELECT 
    p.product_id,
    p.product_name,
    p.min_stock_level,
    SUM(i.quantity) as current_stock
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name, p.min_stock_level
HAVING SUM(COALESCE(i.quantity, 0)) <= p.min_stock_level;

-- Expiring Soon View (Next 90 days)
CREATE VIEW v_expiring_soon AS
SELECT 
    p.product_name,
    i.batch_number,
    i.expiry_date,
    i.quantity,
    (i.expiry_date - CURRENT_DATE) as days_to_expire
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.expiry_date <= CURRENT_DATE + INTERVAL '90 days'
AND i.quantity > 0
ORDER BY i.expiry_date;

-- Customer Outstanding View
CREATE VIEW v_customer_outstanding AS
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    c.credit_limit,
    c.outstanding_amount,
    (c.credit_limit - c.outstanding_amount) as available_credit
FROM customers c
WHERE c.outstanding_amount > 0
ORDER BY c.outstanding_amount DESC;
