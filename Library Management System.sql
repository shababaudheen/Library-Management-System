-- Library Management System

CREATE DATABASE LIBRARY; 

USE LIBRARY;

CREATE TABLE BRANCH ( 
BRANCH_NO INT PRIMARY KEY, 
MANAGER_ID INT, 
BRANCH_ADDRESS VARCHAR(50), 
CONTACT_NO INT8 CHECK (CONTACT_NO BETWEEN 1000000000 AND 9999999999)
);

INSERT INTO BRANCH VALUES 
(101, 2001, '123 Main St', 5551234567),
(102, 2002, '456 Elm St', 5557890123),
(103, 2003, '789 Oak St', 5554567890),
(104, 2004, '1011 Pine St', 5552468135),
(105, 2005, '1314 Spruce St', 5559876543);

SELECT * FROM BRANCH;

CREATE TABLE EMPLOYEE ( 
EMP_ID INT PRIMARY KEY, 
EMP_NAME VARCHAR(50), 
POSITION VARCHAR(50), 
SALARY DECIMAL(10, 2), 
BRANCH_NO INT, 
FOREIGN KEY (BRANCH_NO) REFERENCES BRANCH(BRANCH_NO) 
); 

INSERT INTO EMPLOYEE VALUES 
(2001, 'John Smith', 'Branch Manager', 75000, 101),
(2002, 'Jane Doe', 'Librarian', 50000, 102),
(2003, 'Michael Lee', 'Assistant Librarian', 40000, 103),
(2004, 'Sarah Jones', 'Shelving Assistant', 30000, 104),
(2005, 'David Miller', 'Customer Service Representative', 35000, 105);

SELECT * FROM EMPLOYEE;

CREATE TABLE BOOKS ( 
ISBN INT8 PRIMARY KEY, 
BOOK_TITLE VARCHAR(75), 
CATEGORY VARCHAR(50), 
RENTAL_PRICE DECIMAL(10, 2), 
STATUS ENUM('YES', 'NO'), 
AUTHOR VARCHAR(50), 
PUBLISHER VARCHAR(100) 
); 

INSERT INTO BOOKS VALUES 
(9780140444486, 'The Lord of the Rings', 'Fantasy', 10, 'Yes', 'J. R. R. Tolkien', 'Houghton Mifflin Harcourt'),
(9780316069471, 'Pride and Prejudice', 'Romance', 8, 'No', 'Jane Austen', 'Penguin Classics'),
(9780061120084, 'To Kill a Mockingbird', 'Fiction', 7, 'Yes', 'Harper Lee', 'HarperCollins'),
(9780385490747, 'The Hitchhiker\'s Guide to the Galaxy', 'Science Fiction', 9, 'Yes', 'Douglas Adams', 'Pan Macmillan'),
(9780446670704, 'Harry Potter and the Sorcerer\'s Stone', 'Fantasy', 5, 'No', 'J. K. Rowling', 'Scholastic Inc.'); 

SELECT * FROM BOOKS;

CREATE TABLE CUSTOMER ( 
CUSTOMER_ID INT PRIMARY KEY, 
CUSTOMER_NAME VARCHAR(50), 
CUSTOMER_ADDRESS VARCHAR(50), 
REG_DATE DATE 
); 

INSERT INTO CUSTOMER VALUES 
(3001, 'Alice Brown', '234 Maple Ave', '2023-01-10'),
(3002, 'Bob Johnson', '567 Elm St', '2022-12-01'),
(3003, 'Charlie Williams', '890 Oak St', '2023-02-15'),
(3004, 'Diana Davis', '1213 Pine St', '2021-08-20'),
(3005, 'Ethan Garcia', '1516 Elm st', '2023-09-30'); 

SELECT * FROM CUSTOMER;

CREATE TABLE ISSUESTATUS ( 
ISSUE_ID INT PRIMARY KEY, 
ISSUED_CUST INT, 
ISSUE_BOOK_NAME VARCHAR(75), 
ISSUE_DATE DATE, 
ISBN_BOOK INT8, 
FOREIGN KEY (ISSUED_CUST) REFERENCES CUSTOMER(CUSTOMER_ID), 
FOREIGN KEY (ISBN_BOOK) REFERENCES BOOKS(ISBN) 
); 

INSERT INTO ISSUESTATUS VALUES 
(4001, 3001, 'The Lord of the Rings', '2023-02-20', 9780140444486),
(4002, 3002, 'To Kill a Mockingbird', '2023-04-15', 9780061120084),
(4003, 3003, 'The Hitchhiker\'s Guide to the Galaxy', '2023-06-01', 9780385490747); 

SELECT * FROM ISSUESTATUS;

CREATE TABLE RETURNSTATUS ( 
RETURN_ID INT PRIMARY KEY, 
RETURN_CUST INT, 
RETURN_BOOK_NAME VARCHAR(75), 
RETURN_DATE DATE, 
ISBN_BOOK2 INT8, 
FOREIGN KEY (ISBN_BOOK2) REFERENCES BOOKS(ISBN) 
);
SELECT * FROM RETURNSTATUS; 

-- Retreive the book title, category and rental price of all available books. 
SELECT BOOK_TITLE, CATEGORY, RENTAL_PRICE FROM BOOKS WHERE STATUS = 'YES'; 

-- List the employee name and their respective salaries in descending order of salary. 
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC; 

-- Retrieve the book titles and the corresponding customers who have issued those books. 
SELECT I.ISSUE_BOOK_NAME, C.CUSTOMER_NAME FROM 
ISSUESTATUS I LEFT JOIN CUSTOMER C ON I.ISSUED_CUST = C.CUSTOMER_ID; 

-- Display the total count of books in each category. 
SELECT CATEGORY, COUNT(*) Total_No_of_Books FROM BOOKS 
GROUP BY CATEGORY; 

-- Retreive the employee names and their positions for the employees whose salaries are above Rs. 50,000. 
SELECT EMP_NAME, POSITION FROM EMPLOYEE 
WHERE SALARY > 50000; 

-- List the customer name who registered before 2022-01-01 and have not issued any books yet. 
SELECT CUSTOMER_NAME FROM CUSTOMER 
WHERE REG_DATE < '2022-01-01' 
AND CUSTOMER_ID NOT IN (SELECT DISTINCT ISSUED_CUST FROM ISSUESTATUS); 

-- Display the branch numbers and the total count of employees in each branch. 
SELECT BRANCH_NO, COUNT(*) Total_Count FROM EMPLOYEE 
GROUP BY BRANCH_NO; 

-- Display the names of customers who have issued books in the month of June 2023. 
SELECT C.CUSTOMER_NAME FROM 
CUSTOMER C RIGHT JOIN ISSUESTATUS I 
ON C.CUSTOMER_ID = ISSUED_CUST
WHERE MONTH(I.ISSUE_DATE) = 6 AND YEAR(I.ISSUE_DATE) = 2023; 

-- Retreive BOOK_TITLE from book table containing history. 
SELECT BOOK_TITLE FROM BOOKS WHERE CATEGORY = 'History'; 

-- Retrieve the branch numbers along with the count of employees for branches having more than 1 employees. 
SELECT BRANCH_NO, COUNT(*) FROM EMPLOYEE 
GROUP BY BRANCH_NO HAVING COUNT(*) > 1;
