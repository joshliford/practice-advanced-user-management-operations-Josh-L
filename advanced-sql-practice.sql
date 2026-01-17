drop table if exists orders;
drop table if exists customers;

create table customers (
 id int primary key auto_increment,
 first_name varchar(50),
 last_name varchar(50)
);

create table orders (
 id int primary key,
 customer_id int null,
 order_date date,
 total_amount decimal(10, 2),
 foreign key (customer_id) references customers(id)
);

insert into customers (id, first_name, last_name) values
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Smith'),
(4, 'Bob', 'Brown');

insert into orders (id, customer_id, order_date, total_amount) values
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-02-01', 150.00),
(3, 2, '2023-01-01', 200.00),
(4, 3, '2023-04-01', 250.00),
(5, 3, '2023-04-01', 300.00),
(6, NULL, '2023-04-01', 100.00);

SELECT * FROM customers;
SELECT * FROM orders;

/* 
GROUP BY: use in a SELECT statement to group rows that have the same values in specified columns into summary rows
Used with aggregate functions (SUM, COUNT, AVG, MAX, MIN)
Example: returns a result set that shows total amount spent by each customer using SUM, grouped by customer_id
*/
SELECT customer_id, SUM(total_amount) AS
total_spent FROM orders
GROUP BY customer_id;

-- Example: multiple columns - must add both columns in GROUP BY clause as well as SELECT statement
SELECT customer_id, order_date,
SUM(total_amount) AS
total_spent FROM orders
GROUP BY customer_id, order_date;

/*
HAVING and WHERE clauses
WHERE: filter rows BEFORE aggregation (filter rows before GROUP BY is applied)
HAVING: filter rows AFTER aggregation (filter rows after GROUP BY is applied)
*/
-- WHERE Example: filter results to only include customers who orders are > $200
SELECT customer_id, SUM(total_amount) AS
total_spent FROM orders
WHERE total_amount > 200
GROUP BY customer_id;

-- HAVING Example: filter aggregate columns
-- returns results that shows total spent by each customer, but will only include customers who spend > $200
SELECT customer_id, SUM(total_amount) AS
total_spent FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;

/*
INNER JOINs: specifies joining tables and returns rows that have matching values in BOTH tables
Example: 
- Suppose we want to include customers first & last name in the results
- These are not stored in the orders table, but are stored in the customers table
- We can look up customer name by looking up customer_id in the customers table
- JOINs let us do this lookup and include the results in our final output
- The below query returns results that shows all the orders but also includes customers first and last name
- INNER JOIN specifies we want to join the orders table with the customers table on the customer_id column
in the orders table and the id column in the customers table
- We want to include each of the rows from the orders table, with their corresponding customers first & last name
The result does NOT contain any NULL values and excludes them
*/
SELECT orders.id, customers.first_name, customers.last_name,
orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

/*
LEFT JOINs: includes all rows from the 1st table, even if there is no matching row for the 2nd table
- Returns NULL if there is no matching row in 2nd table
Example: similar to above, but using LEFT JOIN rather than INNER JOIN
The result includes NULL values for id 6
*/
SELECT orders.id, customers.first_name, customers.last_name,
orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

/*
Subqueries: allow you to embed and use the result of one query as the input for another query
Scalar Subqueries: return a single value (single row with a single column)
Example: returns all orders where total_amount >= average total_amount for all orders
*/
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders);

/*
Column Subqueries: return multiple values (multiple rows with a single column)
Used anywhere you would use a list of values (i.e. in an IN clause)
Example: returns all orders where customer_id is in the list of id values of customers with last name 'Smith'
*/
SELECT id, order_date, total_amount, customer_id
FROM orders
WHERE customer_id IN (SELECT id 
FROM customers WHERE last_name = 'Smith');

/*
Table Subqueries: return multiple columns and rows
Used anywhere you would use a table (i.e. FROM clause)
Example: returns all order_date values from the orders table
*/
SELECT order_date
FROM (SELECT id, order_date, total_amount FROM orders)
AS order_summary;
