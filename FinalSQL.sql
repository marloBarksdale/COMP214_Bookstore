-- Dropping sequences if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE customers_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE orders_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE publisher_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE author_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE books_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE orderitems_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE bookauthor_seq';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN 
    EXECUTE IMMEDIATE 'DROP INDEX idx_customers_lastname';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN 
    EXECUTE IMMEDIATE 'DROP INDEX idx_orders_customer';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN 
    EXECUTE IMMEDIATE 'DROP INDEX idx_books_category';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
    



-- Dropping tables if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE BookAuthor CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE OrderItems CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Books CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Author CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Publisher CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Orders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Customers CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Book_Audit CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/









-- Creating sequences for primary keys

CREATE SEQUENCE customers_seq START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE orders_seq START WITH 2001 INCREMENT BY 1;
CREATE SEQUENCE publisher_seq START WITH 10 INCREMENT BY 1;
CREATE SEQUENCE author_seq START WITH 200 INCREMENT BY 1;
CREATE SEQUENCE books_seq START WITH 300 INCREMENT BY 1;
CREATE SEQUENCE orderitems_seq START WITH 400 INCREMENT BY 1;
CREATE SEQUENCE bookauthor_seq START WITH 500 INCREMENT BY 1;






-- Creating tables


CREATE TABLE Book_Audit (
    AuditID     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISBN        VARCHAR2(20),
    Title       VARCHAR2(200),
    AddedOn     DATE,
    AddedBy     VARCHAR2(30)
);



CREATE TABLE Customers (
    Customer# NUMBER(4),
    LastName VARCHAR2(10) NOT NULL,
    FirstName VARCHAR2(10) NOT NULL,
    Address VARCHAR2(50),
    City VARCHAR2(50),
    State VARCHAR2(2),
    Zip VARCHAR2(5),
    Email VARCHAR2(50),
    CONSTRAINT customers_customer#_pk PRIMARY KEY (Customer#)
    
);

CREATE TABLE Orders (
    Order# NUMBER(4),
    Customer# NUMBER(4),
    OrderDate DATE NOT NULL,
    ShipDate DATE,
    ShipStreet VARCHAR2(50),
    ShipCity VARCHAR2(50),
    ShipState VARCHAR2(2),
    ShipZip VARCHAR2(5),
    ShipCost NUMBER(4,2),
    CONSTRAINT orders_order#_pk PRIMARY KEY (Order#),
    CONSTRAINT orders_customer#_fk FOREIGN KEY (Customer#) REFERENCES Customers(Customer#)
);

CREATE TABLE Publisher (
    PubID NUMBER(2),
    Name VARCHAR2(30),
    Contact VARCHAR2(30),
    Phone VARCHAR2(20),
    CONSTRAINT publisher_pubid_pk PRIMARY KEY (PubID)
);

CREATE TABLE Author (
    AuthorID VARCHAR2(4),
    Lname VARCHAR2(10),
    Fname VARCHAR2(10),
    CONSTRAINT author_authorid_pk PRIMARY KEY (AuthorID)
);

CREATE TABLE Books (
    ISBN VARCHAR2(10),
    Title VARCHAR2(50),
    PubDate DATE,
    PubID NUMBER(2),
    Cost NUMBER(5,2),
    Retail NUMBER(5,2),
    Discount NUMBER(4,2),
    Category VARCHAR2(25),
    CONSTRAINT books_isbn_pk PRIMARY KEY (ISBN),
    CONSTRAINT books_pubid_fk FOREIGN KEY (PubID) REFERENCES Publisher (PubID)
);

CREATE TABLE OrderItems (
    Order# NUMBER(4),
    Item# NUMBER(2),
    ISBN VARCHAR2(10),
    Quantity NUMBER(3) NOT NULL,
    PaidEach NUMBER(5,2) NOT NULL,
    CONSTRAINT orderitems_pk PRIMARY KEY (Order#, Item#),
    CONSTRAINT orderitems_order#_fk FOREIGN KEY (Order#) REFERENCES Orders (Order#),
    CONSTRAINT orderitems_isbn_fk FOREIGN KEY (ISBN) REFERENCES Books (ISBN),
    CONSTRAINT orderitems_quantity_ck CHECK (Quantity > 0)
);

CREATE TABLE BookAuthor (
    ISBN VARCHAR2(10),
    AuthorID VARCHAR2(4),
    CONSTRAINT bookauthor_pk PRIMARY KEY (ISBN, AuthorID),
    CONSTRAINT bookauthor_isbn_fk FOREIGN KEY (ISBN) REFERENCES Books (ISBN),
    CONSTRAINT bookauthor_authorid_fk FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID)
);




CREATE OR REPLACE FUNCTION get_customer_order_count (
    p_customer_id IN Customers.Customer#%TYPE
) RETURN NUMBER
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Orders
    WHERE Customer# = p_customer_id;

    RETURN v_count;

EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
/






CREATE OR REPLACE FUNCTION get_order_total (
    p_order_id IN Orders.Order#%TYPE
) RETURN NUMBER
AS
    v_total   NUMBER := 0;
    v_ship    NUMBER := 0;
BEGIN
    -- Get shipping cost
    SELECT ShipCost INTO v_ship
    FROM Orders
    WHERE Order# = p_order_id;

    -- Calculate item total: (PaidEach - Book.Discount) * Quantity
    SELECT SUM((oi.PaidEach - NVL(b.Discount, 0)) * oi.Quantity)
    INTO v_total
    FROM OrderItems oi
    JOIN Books b ON oi.ISBN = b.ISBN
    WHERE oi.Order# = p_order_id;

    RETURN v_total + v_ship;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;
/



--Triggers

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


CREATE OR REPLACE TRIGGER BOOK_INSERT_AUDIT_TRG
AFTER INSERT ON Books
FOR EACH ROW
DECLARE
    e_insert_failed EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insert_failed, -20099);
BEGIN
    INSERT INTO Book_Audit (ISBN, Title, AddedOn, AddedBy)
    VALUES (
        :NEW.ISBN,
        :NEW.Title,
        SYSDATE,
        USER
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Optional: log to an error table, or just raise a custom error
        RAISE_APPLICATION_ERROR(-20099, 'Failed to log book insert: ' || SQLERRM);
END;
/

--Triggers End

--PROCEDURES

CREATE OR REPLACE PROCEDURE get_order_details (
    p_order_id IN Orders.Order#%TYPE
)
AS
    lv_customer_id   Orders.Customer#%TYPE;
    lv_orderdate     Orders.OrderDate%TYPE;
    lv_shipdate      Orders.ShipDate%TYPE;
    lv_street        Orders.ShipStreet%TYPE;
    lv_city          Orders.ShipCity%TYPE;
    lv_state         Orders.ShipState%TYPE;
    lv_zip           Orders.ShipZip%TYPE;
    lv_shipcost      Orders.ShipCost%TYPE;

    CURSOR order_items_cursor IS
        SELECT b.Title, oi.Quantity, oi.PaidEach, NVL(b.Discount, 0)
        FROM OrderItems oi
        JOIN Books b ON oi.ISBN = b.ISBN
        WHERE oi.Order# = p_order_id;

    lv_title       Books.Title%TYPE;
    lv_quantity    OrderItems.Quantity%TYPE;
    lv_paideach    OrderItems.PaidEach%TYPE;
    lv_discount    Books.Discount%TYPE;

    lv_total       NUMBER;
BEGIN
    -- Fetch order header info
    SELECT Customer#, OrderDate, ShipDate, ShipStreet, ShipCity, ShipState, ShipZip, ShipCost
    INTO lv_customer_id, lv_orderdate, lv_shipdate, lv_street, lv_city, lv_state, lv_zip, lv_shipcost
    FROM Orders
    WHERE Order# = p_order_id;

    DBMS_OUTPUT.PUT_LINE('Order Number : ' || p_order_id);
    DBMS_OUTPUT.PUT_LINE('Customer ID  : ' || lv_customer_id);
    DBMS_OUTPUT.PUT_LINE('Order Date   : ' || TO_CHAR(lv_orderdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Ship Date    : ' || TO_CHAR(lv_shipdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Shipping To  : ' || lv_street || ', ' || lv_city || ', ' || lv_state || ' ' || lv_zip);
    DBMS_OUTPUT.PUT_LINE('Shipping Cost: $' || TO_CHAR(lv_shipcost, '9990.99'));

    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Items Ordered:');
    OPEN order_items_cursor;
    LOOP
        FETCH order_items_cursor INTO lv_title, lv_quantity, lv_paideach, lv_discount;
        EXIT WHEN order_items_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('- Title     : ' || lv_title);
        DBMS_OUTPUT.PUT_LINE('  Quantity  : ' || lv_quantity);
        DBMS_OUTPUT.PUT_LINE('  Unit Price: $' || TO_CHAR(lv_paideach, '9990.99'));
        DBMS_OUTPUT.PUT_LINE('  Discount  : $' || TO_CHAR(lv_discount, '9990.99'));
        DBMS_OUTPUT.PUT_LINE('  Line Total: $' || TO_CHAR((lv_paideach - lv_discount) * lv_quantity, '9990.99'));
    END LOOP;
    CLOSE order_items_cursor;

    -- Use function to get total
    lv_total := get_order_total(p_order_id);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Amount (Incl. Shipping): $' || TO_CHAR(lv_total, '9990.99'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order found with Order# ' || p_order_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/







CREATE OR REPLACE PROCEDURE add_customer (
    p_LastName    IN  Customers.LastName%TYPE,
    p_FirstName   IN  Customers.FirstName%TYPE,
    p_Address     IN  Customers.Address%TYPE,
    p_City        IN  Customers.City%TYPE,
    p_State       IN  Customers.State%TYPE,
    p_Zip         IN  Customers.Zip%TYPE,
    p_Email       IN  Customers.Email%TYPE,
    p_Customer_ID OUT Customers.Customer#%TYPE
)
AS
BEGIN
    -- Get next customer ID
    SELECT customers_seq.NEXTVAL INTO p_Customer_ID FROM dual;

    -- Insert the new customer
    INSERT INTO Customers (
        Customer#, LastName, FirstName, Address, City, State, Zip, Email
    ) VALUES (
        p_Customer_ID, p_LastName, p_FirstName, p_Address, p_City, p_State, p_Zip, p_Email
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer added successfully with ID: ' || p_Customer_ID);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error adding customer: ' || SQLERRM);
        p_Customer_ID := NULL;
END;
/
--PROCEDURES END

--PACKAGE
CREATE OR REPLACE PACKAGE book_sales_pkg AS
    -- Global constant
    c_max_top_books CONSTANT PLS_INTEGER := 2;

    -- Public procedures/functions
    PROCEDURE show_top_selling_books(p_top_n IN NUMBER);
    FUNCTION get_top_selling_book RETURN VARCHAR2;
END book_sales_pkg;
/
CREATE OR REPLACE PACKAGE BODY book_sales_pkg AS

    -- Private variable to count rows returned
    v_row_counter PLS_INTEGER := 0;

    FUNCTION get_top_selling_book RETURN VARCHAR2
    AS
        v_title Books.Title%TYPE;
    BEGIN
        SELECT b.Title
        INTO v_title
        FROM OrderItems oi
        JOIN Books b ON oi.ISBN = b.ISBN
        GROUP BY b.Title
        ORDER BY SUM(oi.Quantity) DESC
        FETCH FIRST 1 ROWS ONLY;

        RETURN v_title;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'No sales yet';
        WHEN OTHERS THEN
            RETURN 'Error: ' || SQLERRM;
    END get_top_selling_book;

    PROCEDURE show_top_selling_books (
        p_top_n IN NUMBER
    )
    AS
        CURSOR top_books_cursor IS
            SELECT 
                b.ISBN,
                b.Title,
                b.Category,
                SUM(oi.Quantity) AS QuantitySold,
                b.Retail
            FROM OrderItems oi
            JOIN Books b ON oi.ISBN = b.ISBN
            GROUP BY b.ISBN, b.Title, b.Category, b.Retail
            ORDER BY QuantitySold DESC
            FETCH FIRST LEAST(p_top_n, c_max_top_books) ROWS ONLY;

        v_isbn     Books.ISBN%TYPE;
        v_title    Books.Title%TYPE;
        v_category Books.Category%TYPE;
        v_quantity NUMBER;
        v_retail   Books.Retail%TYPE;
    BEGIN
        v_row_counter := 0;  -- Reset before use

        DBMS_OUTPUT.PUT_LINE('Top ' || p_top_n || ' Best-Selling Books (max ' || c_max_top_books || ')');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');

        OPEN top_books_cursor;
        LOOP
            FETCH top_books_cursor INTO v_isbn, v_title, v_category, v_quantity, v_retail;
            EXIT WHEN top_books_cursor%NOTFOUND;

            v_row_counter := v_row_counter + 1;

            DBMS_OUTPUT.PUT_LINE('Title    : ' || v_title);
            DBMS_OUTPUT.PUT_LINE('ISBN     : ' || v_isbn);
            DBMS_OUTPUT.PUT_LINE('Category : ' || v_category);
            DBMS_OUTPUT.PUT_LINE('Sold     : ' || v_quantity);
            DBMS_OUTPUT.PUT_LINE('Retail   : $' || TO_CHAR(v_retail, '9990.99'));
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
        END LOOP;
        CLOSE top_books_cursor;

        DBMS_OUTPUT.PUT_LINE('Total books shown: ' || v_row_counter);

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END show_top_selling_books;

END book_sales_pkg;
/


--Package END




-- Inserting new customer data
INSERT INTO CUSTOMERS VALUES (customers_seq.NEXTVAL, 'JOHNSON', 'EMILY', '123 APPLE ST', 'NEW YORK', 'NY', '10001', 'emilyj@gmail.com');
INSERT INTO CUSTOMERS VALUES (customers_seq.NEXTVAL, 'BROWN', 'DANIEL', '456 OAK AVE', 'LOS ANGELES', 'CA', '90012',  'danbrown@ymail.com');
INSERT INTO CUSTOMERS VALUES (customers_seq.NEXTVAL, 'MARTIN', 'SOPHIA', '789 MAPLE LN', 'CHICAGO', 'IL', '60601', 'sophiam@outlook.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'NELSON', 'MEGAN', '207 ALEXIS LOAF APT. 296', 'ANDREASTAD', 'OH', '52783', 'fhorne@haley-hartman.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'II', 'MARIO', '130 WARREN CORNER', 'CARLOSTON', 'VA', '66951', 'sara81@williams-chang.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'COLE', 'ERICA', '50108 DARRELL HEIGHTS SUITE 357', 'PAYNEVIEW', 'CT', '65098', 'janeshaw@chambers.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'HERNANDEZ', 'WESLEY', '628 STACY LOCKS SUITE 884', 'JEFFERYMOUTH', 'TX', '15150', 'ericksoncarl@hotmail.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'CUMMINGS', 'SARAH', '95421 DONNA STREETS', 'DAWNTON', 'LA', '76288', 'djames@campbell.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'GONZALEZ', 'JAMES', '60816 WATERS PARKS APT. 775', 'MELISSAVIEW', 'MI', '96090', 'marychang@daniels-morrison.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'KING', 'AMBER', '165 TRAVIS CANYON APT. 418', 'NORTH SAVANNAHMOUTH', 'NJ', '09149', 'william65@hotmail.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'WONG', 'ERIC', '99118 CARROLL RIDGE', 'SOUTH SERGIO', 'ME', '73818', 'gibsonmelissa@hotmail.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'DAVIES', 'BRENDA', '178 SCOTT SHOAL', 'LONGTOWN', 'DE', '03730', 'housealexa@gmail.com');
INSERT INTO Customers VALUES (customers_seq.NEXTVAL, 'PAYNE', 'JORGE', '4465 HOBBS STREET', 'HESTERVIEW', 'NH', '18176', 'williamskatherine@wilson-kemp.com');

-- Inserting new order data
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1001, TO_DATE('05-MAR-2022','DD-MON-YYYY'), TO_DATE('10-MAR-2022','DD-MON-YYYY'), '123 APPLE ST', 'NEW YORK', 'NY', '10001', 5.00);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1002, TO_DATE('12-JUL-2023','DD-MON-YYYY'), TO_DATE('20-JUL-2023','DD-MON-YYYY'), '456 OAK AVE', 'LOS ANGELES', 'CA', '90012', 6.00);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1003, TO_DATE('22-SEP-2021','DD-MON-YYYY'), TO_DATE('30-SEP-2021','DD-MON-YYYY'), '789 MAPLE LN', 'CHICAGO', 'IL', '60601', 7.00);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1001, TO_DATE('11-NOV-2022','DD-MON-YYYY'), TO_DATE('16-NOV-2022','DD-MON-YYYY'), '123 APPLE ST', 'NEW YORK', 'NY', '10001', 7.08);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1004, TO_DATE('03-AUG-2023','DD-MON-YYYY'), TO_DATE('12-AUG-2023','DD-MON-YYYY'), '9537 BROWN UNDERPASS SUITE 705', 'NORTH BRANDON', 'UT', '37297', 7.79);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1005, TO_DATE('18-MAY-2021','DD-MON-YYYY'), TO_DATE('26-MAY-2021','DD-MON-YYYY'), '703 PRATT LOCK SUITE 547', 'EAST STEVENTON', 'MS', '02930', 12.90);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1002, TO_DATE('09-APR-2024','DD-MON-YYYY'), TO_DATE('17-APR-2024','DD-MON-YYYY'), '46573 SMITH PLACE APT. 488', 'WEST VICTORIASIDE', 'FL', '90958', 8.21);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1006, TO_DATE('27-OCT-2023','DD-MON-YYYY'), TO_DATE('04-NOV-2023','DD-MON-YYYY'), '1976 MATTHEW PINE', 'BENNETTMOUTH', 'IN', '02677', 11.43);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1007, TO_DATE('14-JUN-2022','DD-MON-YYYY'), TO_DATE('21-JUN-2022','DD-MON-YYYY'), '628 STACY LOCKS SUITE 884', 'JEFFERYMOUTH', 'TX', '15150', 14.57);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1003, TO_DATE('01-FEB-2021','DD-MON-YYYY'), TO_DATE('09-FEB-2021','DD-MON-YYYY'), '789 MAPLE LN', 'CHICAGO', 'IL', '60601', 11.88);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1008, TO_DATE('19-AUG-2023','DD-MON-YYYY'), TO_DATE('27-AUG-2023','DD-MON-YYYY'), '95421 DONNA STREETS', 'DAWNTON', 'LA', '76288', 8.70);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1009, TO_DATE('22-DEC-2022','DD-MON-YYYY'), TO_DATE('30-DEC-2022','DD-MON-YYYY'), '60816 WATERS PARKS APT. 775', 'MELISSAVIEW', 'MI', '96090', 7.67);
INSERT INTO Orders VALUES (orders_seq.NEXTVAL, 1004, TO_DATE('15-JAN-2023','DD-MON-YYYY'), TO_DATE('21-JAN-2023','DD-MON-YYYY'), '32478 CHRISTOPHER ISLANDS', 'JONATHANMOUTH', 'CO', '28836', 10.33);



-- Inserting new publisher data
INSERT INTO PUBLISHER VALUES (publisher_seq.NEXTVAL, 'GLOBAL PRINTS', 'SAMUEL CARTER', '800-123-4567');
INSERT INTO PUBLISHER VALUES (publisher_seq.NEXTVAL, 'BOOK HAVEN', 'LISA HENDERSON', '800-234-5678');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'ANDERSON LLC', 'BRIAN LIU', '(516)601-9401');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'PERRY-VILLANUEVA', 'TINA LOPEZ', '658.691.2048');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'BELL-FITZPATRICK', 'JENNIFER GONZALEZ', '001-539-050-2894');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'PENA AND SONS', 'JUSTIN LARSON', '8855542168');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'BYRD PLC', 'MRS. HANNAH MENDOZA', '(454)764-1293');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'MILLER-MORENO', 'SARAH GRIFFIN', '001-731-385-5957');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'KIM-MOORE', 'DYLAN COOPER', '(833)682-4308');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'HUNTER LLC', 'RYAN CURRY', '836-815-9588');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'STANTON, HAMILTON AND PETERSEN', 'JAMIE COLLINS', '+1-756-896-1165');
INSERT INTO Publisher VALUES (publisher_seq.NEXTVAL, 'MORGAN, SMITH AND MEYER', 'JONATHAN JONES', '(125)696-5448');

-- Inserting new author data
INSERT INTO AUTHOR VALUES ('A' || author_seq.NEXTVAL, 'WILLIAMS', 'OLIVIA');
INSERT INTO AUTHOR VALUES ('A' || author_seq.NEXTVAL, 'TAYLOR', 'JACKSON');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'LLOYD', 'ROBERT');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'MYERS', 'VERONICA');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'ALVAREZ', 'LINDSEY');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'BROWN', 'TERESA');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'HO', 'LAUREN');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'BARTLETT', 'NICOLE');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'LANE', 'DANIEL');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'BARNETT', 'RACHEL');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'LARA', 'LISA');
INSERT INTO Author VALUES ('A' || author_seq.NEXTVAL, 'ANDERSON', 'VALERIE');

-- Inserting new book data
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The Future of AI', TO_DATE('05-MAR-2024','DD-MON-YYYY'), 14, 25.50, 39.95, NULL, 'Technology');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Modern Cooking', TO_DATE('12-MAY-2012','DD-MON-YYYY'), 17, 18.75, 29.95, NULL, 'Cooking');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Midnight in the Capital', TO_DATE('15-AUG-2008','DD-MON-YYYY'), 10, 14.93, 59.46, 8.57, 'Political Science');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Letters to My Wife', TO_DATE('20-NOV-2004','DD-MON-YYYY'), 11, 13.81, 50.52, 15.87, 'Historical Fiction');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Strategic Choices', TO_DATE('03-SEP-2019','DD-MON-YYYY'), 20, 23.01, 54.78, 5.13, 'Business');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Organizing Innovation', TO_DATE('22-JAN-2003','DD-MON-YYYY'), 15, 17.60, 57.58, 12.94, 'Research');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Cinema Reimagined', TO_DATE('11-JUL-2001','DD-MON-YYYY'), 12, 11.71, 55.22, 2.44, 'Film Studies');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The Sunday Paper', TO_DATE('19-MAR-2020','DD-MON-YYYY'), 19, 29.68, 56.03, 10.79, 'Media and Journalism');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Understanding Inclusion', TO_DATE('06-OCT-2006','DD-MON-YYYY'), 14, 28.75, 45.68, 3.48, 'Sociology');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Election Season', TO_DATE('09-JUN-2014','DD-MON-YYYY'), 10, 28.62, 31.75, 11.24, 'Political Science');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The Mystery Box', TO_DATE('02-FEB-2000','DD-MON-YYYY'), 18, 15.16, 47.64, 5.29, 'Mystery');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Managing Money Today', TO_DATE('17-DEC-2009','DD-MON-YYYY'), 21, 12.21, 44.84, 11.98, 'Finance');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Artificial Intelligence Now', TO_DATE('12-NOV-2017','DD-MON-YYYY'), 14, 27.90, 41.50, NULL, 'Technology');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The Everyday Chef', TO_DATE('08-APR-2006','DD-MON-YYYY'), 17, 15.45, 28.75, NULL, 'Cooking');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Democracy and Power', TO_DATE('01-SEP-2010','DD-MON-YYYY'), 10, 19.80, 52.60, 6.40, 'Political Science');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'A Soldier’s Promise', TO_DATE('27-OCT-2002','DD-MON-YYYY'), 11, 17.25, 48.00, 9.90, 'Historical Fiction');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Winning Strategy', TO_DATE('19-MAY-2016','DD-MON-YYYY'), 20, 21.35, 46.80, 4.85, 'Business');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Research that Changed the World', TO_DATE('03-MAR-2005','DD-MON-YYYY'), 15, 16.95, 55.00, 7.50, 'Research');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Understanding Cinema', TO_DATE('14-JAN-2013','DD-MON-YYYY'), 12, 13.60, 49.75, 3.10, 'Film Studies');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The News Cycle', TO_DATE('25-JUN-2018','DD-MON-YYYY'), 19, 26.40, 58.25, 9.20, 'Media and Journalism');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Sociology for a New Age', TO_DATE('30-AUG-2007','DD-MON-YYYY'), 14, 22.15, 46.90, 5.75, 'Sociology');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'The Campaign Trail', TO_DATE('07-DEC-2001','DD-MON-YYYY'), 10, 20.25, 39.99, 6.99, 'Political Science');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Locked Room Secrets', TO_DATE('18-MAR-2015','DD-MON-YYYY'), 18, 14.95, 50.00, 4.10, 'Mystery');
INSERT INTO Books VALUES ('B' || books_seq.NEXTVAL, 'Personal Finance Essentials', TO_DATE('21-SEP-2004','DD-MON-YYYY'), 21, 11.80, 38.45, 6.25, 'Finance');




-- Inserting new order items data
INSERT INTO OrderItems VALUES (2012, 1, 'B310', 4, 42.35);
INSERT INTO OrderItems VALUES (2002, 1, 'B318', 2, 46.65);
INSERT INTO OrderItems VALUES (2012, 2, 'B309', 4, 20.51);
INSERT INTO OrderItems VALUES (2009, 1, 'B300', 5, 39.95);
INSERT INTO OrderItems VALUES (2003, 1, 'B311', 4, 32.86);
INSERT INTO OrderItems VALUES (2010, 1, 'B308', 5, 42.20);
INSERT INTO OrderItems VALUES (2008, 1, 'B302', 3, 50.89);
INSERT INTO OrderItems VALUES (2002, 2, 'B317', 2, 47.50);
INSERT INTO OrderItems VALUES (2003, 2, 'B320', 5, 41.15);
INSERT INTO OrderItems VALUES (2001, 1, 'B310', 2, 42.35);
INSERT INTO OrderItems VALUES (2003, 3, 'B304', 2, 49.65);
INSERT INTO OrderItems VALUES (2013, 1, 'B315', 2, 38.10);
INSERT INTO OrderItems VALUES (2005, 1, 'B302', 2, 50.89);
INSERT INTO OrderItems VALUES (2012, 3, 'B316', 4, 41.95);
INSERT INTO OrderItems VALUES (2005, 2, 'B316', 1, 41.95);
INSERT INTO OrderItems VALUES (2006, 1, 'B305', 1, 44.64);
INSERT INTO OrderItems VALUES (2012, 4, 'B305', 3, 44.64);
INSERT INTO OrderItems VALUES (2013, 2, 'B316', 2, 41.95);
INSERT INTO OrderItems VALUES (2004, 1, 'B322', 4, 45.90);
INSERT INTO OrderItems VALUES (2008, 2, 'B304', 1, 49.65);


-- Inserting new book-author relationships
INSERT INTO BookAuthor VALUES ('B300', 'A204');
INSERT INTO BookAuthor VALUES ('B300', 'A205');
INSERT INTO BookAuthor VALUES ('B301', 'A204');
INSERT INTO BookAuthor VALUES ('B302', 'A209');
INSERT INTO BookAuthor VALUES ('B303', 'A200');
INSERT INTO BookAuthor VALUES ('B303', 'A201');
INSERT INTO BookAuthor VALUES ('B304', 'A201');
INSERT INTO BookAuthor VALUES ('B304', 'A206');
INSERT INTO BookAuthor VALUES ('B305', 'A204');
INSERT INTO BookAuthor VALUES ('B306', 'A201');
INSERT INTO BookAuthor VALUES ('B306', 'A211');
INSERT INTO BookAuthor VALUES ('B307', 'A206');
INSERT INTO BookAuthor VALUES ('B307', 'A211');
INSERT INTO BookAuthor VALUES ('B308', 'A207');
INSERT INTO BookAuthor VALUES ('B308', 'A211');
INSERT INTO BookAuthor VALUES ('B309', 'A204');
INSERT INTO BookAuthor VALUES ('B310', 'A204');
INSERT INTO BookAuthor VALUES ('B310', 'A211');
INSERT INTO BookAuthor VALUES ('B311', 'A202');
INSERT INTO BookAuthor VALUES ('B311', 'A209');
INSERT INTO BookAuthor VALUES ('B312', 'A203');
INSERT INTO BookAuthor VALUES ('B313', 'A208');
INSERT INTO BookAuthor VALUES ('B313', 'A210');
INSERT INTO BookAuthor VALUES ('B314', 'A202');
INSERT INTO BookAuthor VALUES ('B315', 'A206');
INSERT INTO BookAuthor VALUES ('B315', 'A211');
INSERT INTO BookAuthor VALUES ('B316', 'A201');
INSERT INTO BookAuthor VALUES ('B316', 'A206');
INSERT INTO BookAuthor VALUES ('B317', 'A208');
INSERT INTO BookAuthor VALUES ('B318', 'A211');
INSERT INTO BookAuthor VALUES ('B319', 'A207');
INSERT INTO BookAuthor VALUES ('B320', 'A200');
INSERT INTO BookAuthor VALUES ('B321', 'A203');
INSERT INTO BookAuthor VALUES ('B322', 'A207');
INSERT INTO BookAuthor VALUES ('B323', 'A205');



-- Index on Customers table for faster search by LastName
CREATE INDEX idx_customers_lastname ON Customers(LastName);

-- Index on Orders table to optimize lookups by Customer#
CREATE INDEX idx_orders_customer ON Orders(Customer#);

-- Index on Books table to speed up searches by Category
CREATE INDEX idx_books_category ON Books(Category);
