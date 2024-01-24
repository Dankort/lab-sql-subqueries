use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

select
    film_id,
    title,

    
       ( select COUNT(*)
        from inventory
        where film_id = film.film_id
	)as copies_count
from
    film
where
    title = 'Hunchback Impossible';
    
    
-- 2. List all films whose length is longer than the average of all the films.

select
    film_id,
    title,
    length
from
    film
where
    length > (
        select avg(length)
        from film
    );
    
-- 3 Use subqueries to display all actors who appear in the film Alone Trip.

select
    actor.actor_id,
    actor.first_name,
    actor.last_name
from
    actor
join
    film_actor on actor.actor_id = film_actor.actor_id
join
    film on film_actor.film_id = film.film_id
where
    film.title = 'Alone Trip';
    
-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
    
    
select
    film.film_id,
    film.title,
    film.description,
    film.release_year,
    film.rental_rate,
    film.rating
from
    film
join
    film_category on film.film_id = film_category.film_id
join
    category on film_category.category_id = category.category_id
where
    category.name = 'Family';
    

-- 5. Get name and email from customers from Canada using subqueries


select
    first_name,
    email
from
    customer
where
    address_id in (
        select
            country_id
        from
            country
        where
            country = 'Canada'
    );
    
   -- this one did not run propertly (Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
   
   -- select
   -- c.first_name,
   -- c.last_name,
	-- c.email
-- from
-- customer 
-- join
-- address a on c.address_id = a.address_id
-- where
-- country = 'Canada';
    
    
-- 6.  Step 1: Find the most prolific actor
select
    actor_id,
    COUNT(*) as film_count
from
    film_actor
group by
    actor_id
order by
    film_count desc
limit 1;

-- Step 2: Use the actor_id to find the films starred by the most prolific actor

select
    film.film_id,
    film.title,
    film.description,
    film.release_year,
    film.rental_rate,
    film.rating
from
    film
join
    film_actor on film.film_id = film_actor.film_id
where
    film_actor.actor_id = (select actor_id from film_actor group by actor_id order by COUNT(*) desc limit 1);
    

-- 7. checking the most profitable customer in the customer that has made the largest sum of payments.

select
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    total_payments
from
    (
        select
            customer.customer_id,
            customer.first_name,
            customer.last_name,
            (
                select
                    SUM(payment.amount)
                from
                    payment
                where
                    payment.customer_id = customer.customer_id
            ) as total_payments
        from
            customer
    ) as customer_payments
order by
    total_payments desc
limit 1;


-- I use the most profitable customer_id to find rented films.
-- Films rented by most profitable customer

select
    film.film_id,
    film.title,
    film.description,
    film.release_year,
    film.rental_rate,
    film.rating
from
    film
join
    inventory on film.film_id = inventory.film_id
join
    rental on inventory.inventory_id = rental.inventory_id
where
    rental.customer_id = 526; 
    
    
    
-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

-- Calculate the average total amount spent by each client
select
    customer_id,
    avg(amount) as average_amount_spent
from
    payment
group by
    customer_id;
    


