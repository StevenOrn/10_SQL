USE sakila;

SELECT * FROM actor;

## Instructions

# 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name 
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT UPPER(CONCAT(first_name," ", last_name)) 
FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe";

# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE "%GEN%";


# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

# 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(50)
AFTER first_name;


# 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

# 3c. Now delete the `middle_name` column.
ALTER TABLE actor
DROP	COLUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name)>=2;

# 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, 
#		 if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, 
#		 as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
#		 HOWEVER! (Hint: update the record using a unique identifier.)
SELECT first_name,last_name
FROM actor
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS"
or first_name = "HARPO" and last_name = "WILLIAMS";


UPDATE actor
SET first_name =
	CASE
		WHEN first_name =  "HARPO" THEN "GROUCHO"
		WHEN first_name =  "GROUCHO" THEN "MUCHO GROUCHO"
	END 

WHERE first_name = "GROUCHO" and last_name = "WILLIAMS"
or first_name = "HARPO" and last_name = "WILLIAMS"

;



# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
#  * Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>

SHOW CREATE TABLE address;


# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name, last_name, address
FROM staff
JOIN address 
USING(address_id);


# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT first_name, last_name, sum(amount)
FROM staff
JOIN payment
USING(staff_id)
GROUP BY staff_id;


# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, count(actor_id) as "Actor Count"
FROM film
JOIN film_actor
USING(film_id)
GROUP BY film_id;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, count(film_id) as "Inventory Count"
FROM inventory
JOIN film
USING(film_id)
WHERE film.title = "Hunchback Impossible"
GROUP BY film_id;


# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT  last_name,first_name, sum(amount)
FROM customer
JOIN payment
USING(customer_id)
GROUP BY(customer_id)
ORDER BY(last_name);


# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title
FROM film
JOIN language
USING(language_id)
WHERE language.name = 'English'
AND (title LIKE 'K%'
OR title LIKE 'Q%');



# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT last_name, first_name
FROM actor
WHERE actor_id IN 
	(
    SELECT actor_id
    FROM film_actor
    WHere film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
	)
;
    

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT email
FROM customer
JOIN address
USING(address_id)
JOIN city
USING(city_id)
JOIN country
USING(country_id)
WHERE country.country = 'CANADA';


# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT title
FROM film
JOIN film_category
USING(film_id)
JOIN category
USING(category_id)
WHERE category.name = 'Children';


# 7e. Display the most frequently rented movies in descending order.

SELECT film.title,rental.rental_date
FROM film
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
ORDER BY(rental.rental_date) DESC;


# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, sum(payment.amount) AS 'dollars earned'
FROM customer
JOIN payment
USING(customer_id)
GROUP BY(store_id);

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id,city,country
FROM store
JOIN address
USING(address_id)
JOIN city
USING(city_id)
JOIN country
USING(country_id);

# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name,sum(payment.amount) AS 'dollars grossed'
FROM category
JOIN film_category
USING(category_id)
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
JOIN payment
USING(rental_id)
GROUP BY (category.name)
ORDER BY(sum(payment.amount)) DESC
LIMIT 5;


# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top5 AS

SELECT category.name,sum(payment.amount) AS 'dollars grossed'
FROM category
JOIN film_category
USING(category_id)
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
JOIN payment
USING(rental_id)
GROUP BY (category.name)
ORDER BY(sum(payment.amount)) DESC
LIMIT 5;


# 8b. How would you display the view that you created in 8a?

SELECT * FROM sakila.top5;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW sakila.top5;
