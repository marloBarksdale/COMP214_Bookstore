
-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- 🔹 Test 1: add_customer (with OUT parameter)
DECLARE
    v_customer_id Customers.Customer#%TYPE;
BEGIN
    add_customer(
        p_LastName    => 'Doe',
        p_FirstName   => 'Jane',
        p_Address     => '456 Main St',
        p_City        => 'New York',
        p_State       => 'NY',
        p_Zip         => '10001',
        p_Email       => 'jane.doe@example.com',
        p_Customer_ID => v_customer_id
    );
    DBMS_OUTPUT.PUT_LINE('New Customer ID: ' || v_customer_id);
END;
/

-- 🔹 Test 2: get_customer_order_count
SELECT get_customer_order_count(1001) AS OrderCount FROM dual;

-- 🔹 Test 3: get_order_total
SELECT get_order_total(2001) AS OrderTotal FROM dual;

-- 🔹 Test 4: get_order_details (uses get_order_total internally)
BEGIN
    get_order_details(2001);
END;
/

-- 🔹 Test 5: show_top_selling_books (inside package)
BEGIN
    book_sales_pkg.show_top_selling_books(5);
END;
/

-- 🔹 Test 6: get_top_selling_book (inside package)
SELECT book_sales_pkg.get_top_selling_book AS TopBook FROM dual;

-- 🔹 Test 7: trg_set_order_date (trigger test)
-- Skip providing OrderDate and verify it gets set
INSERT INTO Orders (
    Order#, Customer#, ShipDate, ShipStreet, ShipCity, ShipState, ShipZip, ShipCost
) VALUES (
    2014, 1001, TO_DATE('2025-04-06', 'YYYY-MM-DD'), 
    '123 Oak Ave', 'Chicago', 'IL', '60616', 12.99
);

SELECT Order#, OrderDate FROM Orders WHERE Order# = 2014;

-- 🔹 Test 8: BOOK_INSERT_AUDIT_TRG (trigger test)
INSERT INTO Books (ISBN, Title, PubDate, PubID, Cost, Retail, Discount, Category)
VALUES ('B999', 'Trigger Test Book', TO_DATE('2025-04-06', 'YYYY-MM-DD'), 10, 15.00, 25.00, 2.00, 'Test');

SELECT * FROM Book_Audit WHERE ISBN = 'B999';
