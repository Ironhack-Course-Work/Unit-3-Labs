"Lab 3 | SQL Self and cross join

In this lab, you will be using the Sakila database of movie rentals.
Instructions"

 1.   Get all pairs of actors that worked together.

select fa1.film_id, CONCAT(a1.first_name,' ',a1.last_name) as Actor1, CONCAT(a2.first_name,' ',a2.last_name) as Actor2 from actor a1
join film_actor fa1 on a1.actor_id = fa1.actor_id
join film_actor fa2 on (fa1.film_id = fa2.film_id) and (fa1.actor_id != fa2.actor_id)
join actor a2 on fa2.actor_id = a2.actor_id   

 
 2.   Get all pairs of customers that have rented the same film more than 3 times.
 
 Select r1.customer_id as Cus1, r2.customer_id as Cus2, count(i.film_id) from rental r1
 join inventory i on r1.inventory_id = i.inventory_id
 join rental r2 on (r1.customer_id = r2.customer_id) and (r1.inventory_id = r2.inventory_id)
 
 
 3.   Get all possible pairs of actors and films.



"Lab 4 | SQL Subqueries

In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
Instructions"

1.    How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(film_id) as film_copies from inventory
WHERE (SELECT title from film WHERE title like 'HUNCH%')

2.    List all films whose length is longer than the average of all the films.

SELECT title, length from film
WHERE length > (SELECT avg(length) from film) 

3.    Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(a.first_name,' ',a.last_name) as Actor, f.title 
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE f.title in (SELECT title from film where title like 'ALONE%')

4.    Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.film_id, f.title, fc.category_id from film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE category_id = (SELECT category_id from category WHERE name like 'Family')

5.    Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT c.first_name, c.last_name, c.email, co.country from customer c
JOIN address a on a.address_id = c.address_id
JOIN city ct on  ct.city_id = a.city_id
JOIN country co on co.country_id = ct.country_id
WHERE co.country like 'CANADA'

6.    Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title from film
WHERE film_id =
(
SELECT COUNT(fa.film_id) as amount_films from actor a
JOIN film_actor fa on fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY amount_films desc
limit 1
)
'a.first_name, a.last_name, a.actor_id, '

7.    Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT c.customer_id from customer c
JOIN payment p on c.customer_id = p.customer_id
HAVING SUM(p.amount) = MAX(SUM(p.amount))
GROUP BY c.customer_id

8.    Customers who spent more than the average payments.
