--Amangeldina Sabina 25B031120
create database advanced_lab_5
    with owner = postgres
    encoding = 'UTF8';

--task 1.1
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);
--task 1.2
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
    )
);
--task 1.3
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);
--task 1.4
INSERT INTO employees VALUES (1, 'Anna', 'Smith', 25, 300000);--success
INSERT INTO employees VALUES (2, 'John', 'Brown', 15, 300000);--error age<18

INSERT INTO products_catalog VALUES (1,'Milk',1.50,1.49);--success
INSERT INTO products_catalog VALUES (1,'Cookies',2.50,3.49);--error regular_price<discount_price

INSERT INTO bookings VALUES (1, '2026-10-15', '2026-10-18', 2);--success
INSERT INTO bookings VALUES (1, '2026-10-15', '2026-10-14', 2);--error data_in>date_out

--task 2.1
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

--task 2.2
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

--task 2.3
INSERT INTO customers VALUES (1, 'anna@example.com', NULL, '2026-10-14');--success
INSERT INTO customers VALUES (2, NULL, '123456789', '2026-10-14'); -- error email is null

INSERT INTO inventory VALUES (1, 'item', 3, 4.99);--success
INSERT INTO inventory VALUES (2, NULL, 9, 9.99);--error item_name is null

--task 3.1
CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP
);

--task 3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

--task 3.3
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES (1, 'anna', 'anna@gmail.com', CURRENT_TIMESTAMP);--success
INSERT INTO users VALUES (2, 'anna', 'john@gmail.com', CURRENT_TIMESTAMP);--error , username already exist

--task 4.1
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);
--task 4.2
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

--task 5.1
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO departments VALUES (1, 'IT', 'Almaty'), (2, 'Finance', 'Astana'), (3, 'HR', 'Shymkent');

--test
INSERT INTO employees_dept VALUES(101, 'Anna', 1, '2025-01-10'), (102, 'John', 2, '2025-02-15'),(103, 'Sara', 3, '2025-03-20');--success
INSERT INTO employees_dept VALUES(104, 'Mike', 999, '2025-04-01');--error , department 999 is not exist


--task 5.2
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);
CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);


INSERT INTO authors VALUES
(1, 'George Orwell', 'United Kingdom'),
(2, 'J.K. Rowling', 'United Kingdom'),
(3, 'Leo Tolstoy', 'Russia'),
(4, 'Jane Austen', 'United Kingdom'),
(5, 'Haruki Murakami', 'Japan');

INSERT INTO publishers VALUES
(1, 'Penguin Books', 'London'),
(2, 'Bloomsbury', 'London'),
(3, 'The Russian Messenger', 'Moscow'),
(4, 'T. Egerton', 'London'),
(5, 'Shinchosha', 'Tokyo');

INSERT INTO books VALUES
(001, '1984', 1, 1, 1949, '9780451524935'),
(002, 'Harry Potter and the Philosopher''s Stone', 2, 2, 1997, '9780747532699'),
(003, 'War and Peace', 3, 3, 1869, '9780199232765'),
(004, 'Pride and Prejudice', 4, 4, 1813, '9780141439518'),
(005, 'Norwegian Wood', 5, 5, 1987, '9780375704024');

--task 5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);
CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id)
        ON DELETE RESTRICT
);
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id)
        ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);


INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Books');
INSERT INTO products_fk VALUES
(101, 'Laptop', 1),
(102, 'Mouse', 1),
(103, 'Novel', 2);
INSERT INTO orders VALUES
(201, '2026-10-10'),
(202, '2026-10-11');
INSERT INTO order_items VALUES
(1, 201, 101, 1),
(2, 201, 102, 2),
(3, 202, 103, 1);

--test

DELETE FROM categories WHERE category_id = 1;
SELECT * FROM order_items WHERE order_id = 201;


--task 6.1
--create tables
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL
        CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL
        CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL
        CHECK (total_amount >= 0),
    status VARCHAR(20) NOT NULL
        CHECK (status IN (
            'pending',
            'processing',
            'shipped',
            'delivered',
            'cancelled'
        )),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT
);

CREATE TABLE order_details(
    order_detail_id INTEGER PRIMARY KEY,
    order_id        INTEGER        NOT NULL,
    product_id      INTEGER        NOT NULL,
    quantity        INTEGER        NOT NULL
        CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2) NOT NULL
        CHECK (unit_price >= 0),

    FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT,

    UNIQUE (order_id, product_id)
);

--insert values
INSERT INTO customers
    (customer_id, name, email, phone, registration_date)
VALUES
    (1, 'Anna Smith', 'anna@example.com', '87010000001', '2026-01-10'),
    (2, 'John Brown', 'john@example.com', '87010000002', '2026-02-15'),
    (3, 'Maria Lee', 'maria@example.com', '87010000003', '2026-03-01'),
    (4, 'David Wilson', 'david@example.com', '87010000004', '2026-03-20'),
    (5, 'Sara Kim', 'sara@example.com', '87010000005', '2026-04-05');

INSERT INTO products
    (product_id, name, description, price, stock_quantity)
VALUES
    (1, 'Laptop', 'Laptop', 350000.00, 10),
    (2, 'Mouse', 'Computer mouse', 5000.00, 50),
    (3, 'Keyboard', 'Keyboard', 15000.00, 30),
    (4, 'Headphones', 'Headphones', 25000.00, 20),
    (5, 'Monitor', 'Computer monitor', 80000.00, 15);

INSERT INTO orders
    (order_id, customer_id, order_date, total_amount, status)
VALUES
    (1, 1, '2026-10-01', 355000.00, 'delivered'),
    (2, 2, '2026-10-02', 15000.00, 'shipped'),
    (3, 3, '2026-10-03', 25000.00, 'processing'),
    (4, 4, '2026-10-04', 80000.00, 'pending'),
    (5, 5, '2026-10-05', 40000.00, 'cancelled');

INSERT INTO order_details
    (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 1, 350000.00),
    (2, 1, 2, 1, 5000.00),
    (3, 2, 3, 1, 15000.00),
    (4, 3, 4, 1, 25000.00),
    (5, 4, 5, 1, 80000.00);

--test queries
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_details;
--test
INSERT INTO products VALUES (6, 'Test Product', 'Error_price', -100.00, 10); -- error price<0
INSERT INTO products VALUES (7, 'Test Product', 'Error_stock', 100.00, -5);--error stock<0
INSERT INTO orders VALUES (6, 1, '2026-10-06', 1000.00, 'unknown');--error status
INSERT INTO order_details VALUES (6, 1, 3, 0, 15000.00);--error quantity=0

INSERT INTO customers VALUES (6, 'Test User', 'anna@gmail.com', '87010000006', '2026-10-06');--error, dublicate value customer email
INSERT INTO customers VALUES (6, NULL, 'test@example.com',  '87010000006', '2026-10-06');--error, customer name is null
INSERT INTO customers VALUES (1, 'Another User', 'another@example.com','87010000007', '2026-10-06');--error dublicate primary key

INSERT INTO orders VALUES (6, 999, '2026-10-06', 1000.00, 'pending');--error foreigh key
DELETE FROM products WHERE product_id = 1;--cannot delete product used in order

SELECT * FROM order_details WHERE order_id = 1;-- 0 rows

SELECT 'customers' AS table_name, COUNT(*) AS records FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*)
FROM order_details;

--output
--customers	5
--products	5
--orders	5
--order_details	5
