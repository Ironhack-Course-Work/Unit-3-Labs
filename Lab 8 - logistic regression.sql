-- Lab | Making predictions with logistic regression


In order to optimize our inventory, we would like to know which films will be rented next month and we are asked to create a model to predict it.
Instructions

    Create a query or queries to extract the information you think may be relevant for building the prediction model. It should include some film features and some rental features.
    Read the data into a Pandas dataframe.
    Analyze extracted features and transform them. You may need to encode some categorical variables, or scale numerical variables.
    Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.
    Create a logistic regression model to predict this variable from the cleaned data.
    Evaluate the results.


#extract potential workable info about films

select f.film_id, 
		f.title, 
        f.description,
        fc.category_id,
        f.language_id,
        f.length/60 as hours_lenght,
        f.rental_duration,
        f.release_year, 
		f.rating, 
        f.special_features,
        avg(f.rental_duration) * 24  as avg_hours_rental_allowed,
		avg(f.replacement_cost) as avg_replacement_cost,
        count(fa.actor_id) as actors_in_film
from film f
join film_category fc on f.film_id=fc.film_id
join film_actor fa on fa.film_id=f.film_id
group by 1,	2,3,4,5,6,7,8,9,10; 

------------

#extract potential workable info about rentals


select i.film_id,
	count(r.rental_id) as num_times_rented,
    p.amount as rental_cost,
	timestampdiff(hour, r.rental_date, r.return_date) as hours_rented
from rental r 
join payment p on p.rental_id = r.rental_id
join inventory i on i.inventory_id = r.inventory_id
group by 1, 3;


4. Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.

#my attempt:

select film_id over(partition by 'Month')  
from (
select f.film_id, f.title, i.inventory_id, r.rental_id, r.rental_date,
date_format(convert(r.rental_date,date), '%M') as 'Month',
date_format(convert(r.rental_date,date), '%Y') as 'Year'
from film as f
join inventory as i using (film_id)
join rental as r using (inventory_id)
group by title
) sub1

 #andres 
 select film_id,
	case times_rented_last_month
    when times_rented_last_month > 1 then 1
    else 0
    end as rented from
    
 
select film_id, 
	sum(case
    when rental_date between '2005-07-01' and '2005-08-01' then 1
    else 0
    end) as times_rented_last_month
from film left join inverntory using (film_id) left join rental using (inventory_id)
group by 1) as cte