


"Lab 5 | SQL Subqueries

In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
Instructions"

1.    How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(film_id) as film_copies from inventory
WHERE (SELECT title from film WHERE title like 'HUNCH%')

2.    List all films whose length is longer than the average of all the films.

SELECT title, length from film
WHERE length > (SELECT avg(length) from film) 

3.    Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(a.first_name,' ', a.last_name) as 'ACTOR', f.title 
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE f.title like (SELECT title from film where title like 'ALONE%')


4.    Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.film_id, f.title, fc.category_id from film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE category_id = (SELECT category_id from category WHERE name like 'Family')

5.    Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
'
SELECT first_name, last_name, email, address_id from customer
WHERE address_id = (SELECT address_id from address WHERE city_id = (SELECT city_id from city WHERE country_id = (SELECT country_id from country WHERE country = 'Canada')))
'
SELECT CONCAT(c.first_name,' ', c.last_name) as 'Customer', c.email, co.country from customer c
JOIN address a on a.address_id = c.address_id
JOIN city ct on  ct.city_id = a.city_id
JOIN country co on co.country_id = ct.country_id
WHERE co.country like 'CANADA'
'
#Solution
select concat(first_name,' ',last_name) as Customer_Name, email
from sakila.customer
where address_id in (
select address_id
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id in (
select country_id
from sakila.country
where country = 'Canada'
)
)
);
'
6.    Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
	First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

#step 1 - most prolific actor
SELECT a.actor_id, COUNT(fa.film_id) as amount_films from actor a
JOIN film_actor fa on fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY amount_films desc
limit 1

#step 2 - films staring actor
select fa.film_id, f.title from film_actor fa
join film f using (film_id)
where actor_id =
(
SELECT a.actor_id from actor a                 #take out other statements to return only 1 value
JOIN film_actor fa on fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY count(film_id) desc                    #cant use alias 'amount_films'
limit 1
)
order by release_year desc
'
#SOLUTION
-- get most prolific author
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1;

-- now get the films starred by the most prolific actor
select concat(first_name, ' ', last_name) as actor_name, film.title, film.release_year
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join film
using (film_id)
where actor_id = (
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1
)
order by release_year desc;
'

7.    Films rented by most profitable customer. 
	You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
'
SELECT c.customer_id from customer c
JOIN payment p on c.customer_id = p.customer_id
HAVING SUM(amount) = MAX(SUM(amount))
GROUP BY customer_id
'
#SOLUTION
-- most profitable customer

select customer_id
from sakila.customer
inner join payment using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1;

-- films rented by most profitable customer
select film_id, title, rental_date, amount
from sakila.film
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
where rental.customer_id = (
select customer_id
from customer
inner join payment
using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1
)
order by rental_date desc;
'

8.    Customers who spent more than the average payments.


'
#SOLUTION

select customer_id, sum(amount) as payment
from sakila.customer
inner join payment using (customer_id)
group by customer_id
having sum(amount) > (
select avg(total_payment)
from (
select customer_id, sum(amount) total_payment
from payment
group by customer_id
) t
)
order by payment desc;
'