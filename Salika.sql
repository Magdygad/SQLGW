use sakila;

# 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
 
SELECT ucase(concat(first_name, ' ', lASt_name)) AS 'Actor Name'  FROM actor;

#2a.You need to find the ID number, first name, and lASt name of an actor, of whom you know only the first name, "Joe."

SELECT actor_id, first_name, lASt_name FROM actor WHERE first_name='Joe';

#2b.Find all actors whose lASt name contain the letters GEN 

SELECT actor_id, first_name, lASt_name FROM actor WHERE lASt_name like '%GEN%';

# 2c.Find all actors whose lASt names contain the letters LI. This time, order the rows by lASt name 
-- and first name, in that order

SELECT actor_id, first_name, lASt_name FROM actor 
					WHERE lASt_name like '%LI%' 
						order by lASt_name, first_name;
                        
# 2d.Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China                        
                        
SELECT country_id, country FROM country 
					WHERE country in ('Afghanistan', 'Bangladesh', 'China'); 
                   
# 3a.Add a middle_name column to the table actor. Position it between first_name and lASt_name                   
  
alter table actor
add column middle_name varchar(100) after first_name; 

#  3b.You realize that some of these actors have tremendously long lASt names. 
-- Change the data type of the middle_name column to blobs

alter table actor
modify column middle_name blob;  

# 3c.Now delete the middle_name column

ALTER TABLE actor
DROP COLUMN middle_name;  

# 4a.List the lASt names of actors, AS well AS how many actors have that lASt name

SELECT lASt_name, count(*) FROM actor GROUP BY lASt_name ;

# 4b.List lASt names of actors and the number of actors who have that lASt name, but only for names 
-- that are shared by at leASt two actors

SELECT lASt_name, count(*) FROM actor group by lASt_name having count(*)>=2; 

# 4c.The actor HARPO WILLIAMS wAS accidentally entered in the actor table AS GROUCHO WILLIAMS. 
-- Write a query to fix the record
UPDATE actor
SET first_name ='HARPO' WHERE first_name='GROUCHO' and lASt_name ='WILLIAMS'; 

# 4d. Perhaps we were too hASty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO wAS the correct name after all! In a single query, 
-- if the first name of the actor is currently HARPO, change it to GROUCHO

UPDATE actor 
SET first_name = 'GROUCHO' WHERE first_name ='HARPO' and lASt_name ='WILLIAMS'; 

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

DROP TABLE IF EXISTS address; 

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL)


# Use JOIN to display the first and lASt names, AS well AS the address, of each staff member. 
-- Use the tables staff and address

SELECT a.first_name, a.lASt_name, b.address FROM staff AS a
JOIN
(SELECT address_id, address FROM address) AS b on a.address_id=b.address_id;

# Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment

SELECT a.staff_id, a.first_name, a.lASt_name, b.amnt FROM staff AS a 
join
(SELECT staff_id, sum(amount) AS amnt FROM payment 
				WHERE payment_date>'2005-08-01 08:51:04' and payment_date<='2005-08-23 17:39:35'
						group by staff_id) 
				AS b on a.staff_id=b.staff_id;
               
# List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use INNER JOIN

SELECT a.film_id, a.title, b.number_actor  FROM film AS a 
INNER JOIN
(SELECT film_id, count(actor_id) AS number_actor FROM film_actor group by film_id) AS b on a.film_id=b.film_id; 
               
# How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT a.title, b.`count` FROM film AS a 
JOIN
(SELECT film_id, count(store_id) AS `count` FROM inventory GROUP BY film_id) AS b on a.film_id=b.film_id 
		WHERE a.title= 'Hunchback Impossible';


# Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by lASt name

SELECT a.first_name, a.lASt_name, b.payment FROM customer AS a
JOIN
(SELECT customer_id, sum(amount) AS payment FROM payment GROUP BY customer_id) AS b 
				on a.customer_id = b.customer_id GROUP BY a.lASt_name;
                
#7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- AS an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

  SELECT * FROM (
SELECT a.film_id, a.title FROM film AS a 
JOIN 
(SELECT language_id, `name` FROM `language`) AS b on a.language_id = b.language_id
) AS c WHERE (c.title like 'K%') or (c.title like 'Q%');               



# Use subqueries to display all actors who appear in the film Alone Trip

SELECT a.actor_id, a.first_name, a.lASt_name  FROM actor AS a
JOIN 
(SELECT b.film_id, b.title, c.actor_id FROM film AS b 
JOIN
(SELECT film_id, actor_id FROM film_actor) AS c on b.film_id = c.film_id
	WHERE b.title = 'Alone Trip'
    ) AS d on a.actor_id = d.actor_id;
    
# You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use JOINs to retrieve this information

SELECT b.`name`, a.email FROM customer AS a 
JOIN
(SELECT ID, `name`, country FROM customer_list) AS b on a.customer_id=b.ID
	WHERE b.country ='Canada';
    
# Sales have been lagging among young families, and you wish to target all family movies for a promotion. List all movies categorized AS famiy films

SELECT a.film_id, a.title, d.`name` FROM film AS a 
JOIN
(SELECT b.film_id, b.category_id, c.`name` FROM film_category AS b 
JOIN
(SELECT category_id, `name` FROM category) AS c on b.category_id =c.category_id
) AS d on a.film_id =d.film_id
	WHERE d.`name` = 'Family';

# Display the most frequently rented movies in descending order

SELECT title, rental_duration FROM film order by rental_duration desc;

# Write a query to display how much business, in dollars, each store brought in

SELECT store, CONCAT('$', FORMAT(total_sales, 2)) FROM sales_by_store;

# Write a query to display for each store its store ID, city, and country

SELECT p.store_id, q.city, q.country FROM 
(SELECT a.store_id AS store_id, b.city_id AS city_id  FROM store AS a 
JOIN
(SELECT address_id, city_id FROM address) AS b on a.address_id = b.address_id) AS p
JOIN 
(SELECT a.city_id AS city_id, a.city AS city, b.country AS country FROM city AS a 
left JOIN
(SELECT country_id, country FROM country) AS b on a.country_id=b.country_id
) AS q on p.city_id =q.city_id;

# List the top five genres in gross revenue in descending order

SELECT t.`name`, sum(amount) AS revenue FROM (
SELECT p.film_id, p.category_id, p.`name`, s.amount AS amount FROM (
SELECT b.film_id, b.category_id, c.`name` FROM film_category AS b 
JOIN
(SELECT category_id, `name` FROM category) AS c on b.category_id =c.category_id
) AS p
JOIN
(SELECT q.rental_id, q.film_id, r.amount FROM 
(SELECT a.rental_id, b.film_id FROM rental AS a 
JOIN 
(SELECT inventory_id, film_id FROM inventory) AS b on a.inventory_id=b.inventory_id) AS q
JOIN 
(
SELECT a.rental_id, b.amount FROM rental AS a 
JOIN
(SELECT * FROM payment) AS b on a.rental_id =b.rental_id
	) AS r on q.rental_id=r.rental_id 
) AS s on p.film_id =s.film_id 
) AS t group by t.`name` order by revenue desc limit 5; 

# Create view to view the Top five genres by gross revenue.

CREATE VIEW top_five_genres AS 
SELECT t.`name`, sum(amount) AS revenue FROM (
SELECT p.film_id, p.category_id, p.`name`, s.amount AS amount FROM (
SELECT b.film_id, b.category_id, c.`name` FROM film_category AS b 
JOIN
(SELECT category_id, `name` FROM category) AS c on b.category_id =c.category_id
) AS p
JOIN
(SELECT q.rental_id, q.film_id, r.amount FROM 
(SELECT a.rental_id, b.film_id FROM rental AS a 
JOIN 
(SELECT inventory_id, film_id FROM inventory) AS b on a.inventory_id=b.inventory_id) AS q
JOIN 
(
SELECT a.rental_id, b.amount FROM rental AS a 
JOIN
(SELECT * FROM payment) AS b on a.rental_id =b.rental_id
	) AS r on q.rental_id=r.rental_id 
) AS s on p.film_id =s.film_id 
) AS t group by t.`name` order by revenue desc limit 5;

# show top_five_genres;

SHOW CREATE VIEW top_five_genres;

# You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres;
