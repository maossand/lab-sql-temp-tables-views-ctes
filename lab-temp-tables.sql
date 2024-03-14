## LAB 4, WEEK 3

USE sakila;

## Challenge
## Creating a Customer Summary Report

## In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

## Step 1: Create a View
## First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info AS
SELECT rental.customer_id, customer.last_name, customer.email, COUNT(*) AS rental_count
FROM rental
INNER JOIN customer
	ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id, customer.last_name, customer.email
ORDER BY rental.customer_id;

## Step 2: Create a Temporary Table
## Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.


CREATE TEMPORARY TABLE total_paid AS
SELECT payment.customer_id, last_name, email, rental_count, SUM(payment.amount) as totalAamount
FROM payment
LEFT JOIN rental_info
	USING (customer_id)
GROUP BY payment.customer_id, last_name, email, rental_count;

	## create a table that groups payment by customer_id
    ## Join the view? 
    ##IT works, we cannot see the table though, this is normal

## Step 3: Create a CTE and the Customer Summary Report
## Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

## Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH cs_report AS (
    SELECT 
        tp.*, 
        tp.totalAamount / tp.rental_count AS average_payment_per_rental
    FROM 
        total_paid AS tp
)
SELECT 
    customer_id, 
    last_name, 
    email, 
    rental_count, 
    totalAamount, 
    average_payment_per_rental
FROM 
    cs_report;






