-- ✅ TEST 1: Insert order WITHOUT providing OrderDate
-- Trigger should automatically set OrderDate to SYSDATE

INSERT INTO Orders (
    Order#, Customer#, ShipDate, ShipStreet, ShipCity, ShipState, ShipZip, ShipCost
) VALUES (
    2014, 1005, TO_DATE('2025-04-10', 'YYYY-MM-DD'), '123 Elm St', 'Chicago', 'IL', '60601', 9.99
);

-- 🔍 Verify OrderDate was auto-set
SELECT Order#, Customer#, TO_CHAR(OrderDate, 'YYYY-MM-DD') AS OrderDate, ShipCity, ShipState
FROM Orders
WHERE Order# = 2014;

-- ✅ TEST 2: Insert order WITH a specific OrderDate
-- The provided date should remain unchanged

INSERT INTO Orders (
    Order#, Customer#, OrderDate, ShipDate, ShipStreet, ShipCity, ShipState, ShipZip, ShipCost
) VALUES (
    2015, 1006, TO_DATE('2024-12-15', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'),
    '456 Maple Ave', 'Dallas', 'TX', '75201', 11.50
);

-- 🔍 Confirm OrderDate was not overwritten
SELECT Order#, Customer#, TO_CHAR(OrderDate, 'YYYY-MM-DD') AS OrderDate, ShipCity, ShipState
FROM Orders
WHERE Order# = 2015;



CREATE OR REPLACE TRIGGER trg_set_order_date
BEFORE INSERT ON Orders
FOR EACH ROW
DECLARE
  e_general_error EXCEPTION;
BEGIN
  IF :NEW.OrderDate IS NULL THEN
    :NEW.OrderDate := SYSDATE;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20010, 'Error setting default order date: ' || SQLERRM);
END;
/


SET SERVEROUTPUT ON;

DECLARE
    v_new_customer_id Customers.Customer#%TYPE;
BEGIN
    add_customer(
        p_LastName    => 'Taylor',
        p_FirstName   => 'Michael',
        p_Address     => '1600 Pennsylvania Ave',
        p_City        => 'Washington',
        p_State       => 'DC',
        p_Zip         => '20500',
        p_Email       => 'michael.taylor@example.com',
        p_Customer_ID => v_new_customer_id
    );

    DBMS_OUTPUT.PUT_LINE('Returned Customer ID: ' || v_new_customer_id);
END;
/


SET SERVEROUTPUT ON;

BEGIN
    show_top_selling_books(3);
END;
/
-- Show top 5 selling books
BEGIN
    book_sales_pkg.show_top_selling_books(5);
END;
/

-- Get the single top-selling book
SELECT book_sales_pkg.get_top_selling_book FROM dual;
