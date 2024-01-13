-- Lab 5 Unit 3
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from sakila.film;

select film_id from sakila.film
where title = "HUNCHBACK IMPOSSIBLE";

select count(*) from sakila.inventory
where film_id = (select film_id from sakila.film
where title = "HUNCHBACK IMPOSSIBLE");

-- 2. List all films whose length is longer than the average of all the films.
select avg(length) from sakila.film;

select title from sakila.film
where length > (select avg(length) from sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select film_id from sakila.film
where title = "ALONE TRIP";

select actor_id from sakila.film_actor
where film_id = (select film_id from sakila.film
where title = "ALONE TRIP");

select first_name, last_name from sakila.actor
where actor_id in (select actor_id from sakila.film_actor
where film_id = (select film_id from sakila.film
where title = "ALONE TRIP"));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select category_id from sakila.category
where name = "Family";

select film_id from sakila.film_category
where category_id = (select category_id from sakila.category
where name = "Family");

select title from sakila.film
where film_id in (select film_id from sakila.film_category
where category_id = (select category_id from sakila.category
where name = "Family"));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- with subqueries
select country_id from sakila.country
where country = "Canada";

select city_id from sakila.city
where country_id = (select country_id from sakila.country
where country = "Canada");

select address_id from sakila.address
where city_id in (select city_id from sakila.city
where country_id = (select country_id from sakila.country
where country = "Canada"));

select first_name, email from sakila.customer
where address_id in (select address_id from sakila.address
where city_id in (select city_id from sakila.city
where country_id = (select country_id from sakila.country
where country = "Canada")));

-- with joins
select a.first_name, a.email from sakila.customer as a
join sakila.address as b
on a.address_id = b.address_id
join sakila.city as c
on b.city_id = c.city_id
join sakila.country as d
on c.country_id = d.country_id
where country = "Canada";

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select actor_id, count(film_id) from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1; -- actor_id = 107

select film_id from sakila.film_actor
where actor_id = 107;

select title from sakila.film
where film_id in (select film_id from sakila.film_actor
where actor_id = 107);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select customer_id, sum(amount) from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1; -- customer_id = 526

select inventory_id from sakila.rental
where customer_id = 526;

select film_id from sakila.inventory
where inventory_id in (select inventory_id from sakila.rental
where customer_id = 526);

select title from sakila.film
where film_id in (select film_id from sakila.inventory
where inventory_id in (select inventory_id from sakila.rental
where customer_id = 526));

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select avg(amount) from sakila.payment;

select customer_id, sum(amount) from sakila.payment
group by customer_id
having sum(amount) > (select avg(amount) from sakila.payment);
