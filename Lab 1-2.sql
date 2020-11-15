# LAB 1

#Instructions

    # 1. List number of films per category.
    
SELECT c.category_id, c.name, count(f.film_id) as 'Film_Count' FROM sakila.category c
LEFT JOIN sakila.film_category f
ON c.category_id = f.category_id
group by c.category_id
    
    # 2. Display the first and last names, as well as the address, of each staff member.
    
SELECT s.staff_id, s.first_name, s.last_name, s.address_id, a.address, a.district from staff s
LEFT JOIN address a
ON s.address_id = a.address_id

    # 3. Display the total amount rung up by each staff member in August of 2005.
 
 #amount of transactions
SELECT s.staff_id, s.first_name, s.last_name, Count(r.rental_id) as 'rentals processed' from staff s
LEFT JOIN rental r
ON s.staff_id = r.staff_id
WHERE r.rental_date like '2005-08-%'
GROUP BY s.staff_id

#amount of cash
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) as 'Total cash' from staff s
LEFT JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date like '2005-08-%'
GROUP BY s.staff_id

#other date filter options:
WHERE DATE_FORMAT(payment_date, '%m%Y') = 082005
WHERE YEAR(payment_date) = 2005 AND MONTH(payment_date) = 08

    # 4. List each film and the number of actors who are listed for that film.
    
SELECT f.title, count(a.actor_id) as 'amount actors', a.film_id from film f
INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY  f.title
ORDER BY count(a.actor_id) desc
    
    # 5. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

SELECT c.first_name, c.last_name, c.customer_id, SUM(p.amount) as 'Total Amount' from customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY SUM(p.amount) desc


# LAB 2

#Instructions

    # 1. Write a query to display for each store its store ID, city, and country.
    
SELECT s.store_id, ci.city, co.country, a.address from store as s
JOIN address as a ON s.address_id = a.address_id
JOIN city as ci ON a.city_id = ci.city_id
JOIN country as co ON ci.country_id = co.country_id

    
    # 2. Write a query to display how much business, in dollars, each store brought in.
    
SELECT s.store_id, SUM(p.amount) as 'cash amount' from store as s
JOIN payment as p on s.manager_staff_id = p.staff_id
GROUP BY s.store_id

    # 3. What is the average running time of films by category?
    
SELECT c.name, ROUND(AVG(f.length),0) as 'Avg Length' from category as c
JOIN film_category as fc ON c.category_id = fc.category_id
JOIN film as f on fc.film_id = f.film_id
GROUP BY c.name
ORDER BY ROUND(AVG(f.length),0) DESC
    
    # 4. Which film categories are longest?
    
-- GAMES: avg length: 128 min
    
    # 5. Display the most frequently rented movies in descending order.
    
SELECT f.title, i.inventory_id, COUNT(r.rental_id) as 'Rental Freq' from film as f
JOIN inventory as i ON f.film_id = i.film_id 
JOIN rental as r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC


    # 6. List the top five genres in gross revenue in descending order.
    
SELECT c.name as 'Category', SUM(f.rental_rate) as 'Gross Revenue' from category as c
JOIN film_category as fc ON c.category_id = fc.category_id
JOIN film as f on fc.film_id = f.film_id
GROUP BY c.name
ORDER BY SUM(f.rental_rate) DESC
LIMIT 5

#SOLUTION   #USING instead of ON when join column name is the same
select name, category_id, sum(amount) as `gross revenue`
from sakila.payment
join (sakila.rental join (sakila.inventory join (sakila.film_category join sakila.category using (category_id)) using (film_id)) using (inventory_id)) using (rental_id)
group by category_id
order by `gross revenue` desc
limit 5;

    # 7. Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title, i.store_id from film as f
JOIN inventory as i ON f.film_id = i.film_id
WHERE f.film_id = 1

							# ANSWER: Yes, 4 copies

