-- ------------------------------------------------------------------------------
-- Rozdział 5. Zapytania zaawansowane
-- ------------------------------------------------------------------------------

-- -- Aliasy

-- Alias kolumny
SELECT first_name AS 'First Name', last_name AS 'Last Name'
FROM actor LIMIT 5;

-- porównanie długości kodu z aliasem i bez
SELECT CONCAT(first_name, ' ', last_name, ' played in ', title) AS movie
FROM actor INNER JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
ORDER BY movie LIMIT 20;

SELECT CONCAT(first_name, ' ', last_name, ' played in ', title) AS movie
FROM actor INNER JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
ORDER BY CONCAT(first_name, ' ', last_name, ' played in ', title)
LIMIT 20;

-- nie można stosować aliasów z klauzulami WHERE, USING i ON
SELECT first_name AS name FROM actor WHERE name = 'ZERO CAGE'; -- wstąpi błąd

-- słowo kluczowe AS jest opcjonalne
SELECT actor_id AS id FROM actor WHERE first_name ='ZERO';

SELECT actor_id  id FROM actor WHERE first_name ='ZERO';

-- Aliasy tabel 
SELECT ac.actor_id, ac.first_name, ac.last_name, fl.title 
FROM actor AS ac INNER JOIN film_actor AS fla USING (actor_id)
INNER JOIN film AS fl USING (film_id)
WHERE fl.title = 'AFFAIR PREJUDICE';

-- czy dwa filmy w tabeli film mąję tę samą nazwę
SELECT m1.film_id, m2.title
FROM film AS m1, film AS m2
WHERE m1.title = m2.title
AND m1.film_id <> m2.film_id;

-- -- Agregowanie danych

-- Klauzula DISTINCT
SELECT first_name
FROM actor JOIN film_actor USING (actor_id);

SELECT DISTINCT first_name
FROM actor JOIN film_actor USING (actor_id);

SELECT DISTINCT first_name, last_name
FROM actor JOIN film_actor USING (actor_id);

-- Klauzula GROUP BY
SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL');

SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL')
GROUP BY first_name;

-- w ilu filmach wystąpił dany aktor
SELECT first_name, last_name, COUNT(film_id) AS num_films 
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY first_name, last_name
ORDER BY num_films DESC LIMIT 10;

-- ilu różnych aktorów zagrało w danym filmie
SELECT title, name AS category_name, COUNT(*) AS cnt
FROM film INNER JOIN film_actor USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY film_id, category_id
ORDER BY cnt DESC LIMIT 5;

-- którzy klienci zwykle wypożyczają filmy z tej samej kategorii
SELECT email, name AS category_name, COUNT(category_id) AS cnt
FROM customer cs INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category cat USING (category_id)
GROUP BY 1, 2
ORDER BY 3 DESC LIMIT 5;

-- czy istnieją duplikaty
SELECT a1.actor_id, a1.first_name, a1.last_name
FROM actor AS a1, actor AS a2
WHERE a1.first_name = a2.first_name
AND a1.last_name = a2.last_name
AND a1.actor_id <> a2.actor_id;

-- Klauzula HAVING

-- ilu jest popularnych aktorów
SELECT first_name, last_name, COUNT(film_id)
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, first_name, last_name
HAVING COUNT(film_id) > 40
ORDER BY COUNT(film_id) DESC;

-- lista 5 najczęściej wypożyczanych filmów
SELECT title, COUNT(rental_id) AS num_rented 
FROM film INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
GROUP BY title
HAVING num_rented > 30
ORDER BY num_rented DESC LIMIT 5;

-- w ilu filmach zagrał dany aktor
SELECT first_name, last_name, COUNT(film_id) AS film_cnt
FROM actor INNER JOIN film_actor USING (actor_id)
WHERE first_name = 'EMILY' AND last_name = 'DEE'
GROUP BY actor_id, first_name, last_name;

-- Złączenia zaawansowane
SELECT first_name, last_name, film_id 
FROM actor INNER JOIN film_actor USING (actor_id)
LIMIT 20;

SELECT first_name, last_name, film_id 
FROM actor, film_actor 
WHERE actor.actor_id = film_actor.actor_id
LIMIT 20;

SELECT first_name, last_name, film_id 
FROM actor INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
LIMIT 20;

-- iloczy kartezjański
SELECT first_name, last_name, film_id
FROM actor, film_actor LIMIT 20;

-- Unia

-- wszyscy aktorzy, klienci i filmy
SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
UNION
SELECT title FROM film;

-- lista pięciu najczęściej i najrzadziej wypożyczanych filmów
(SELECT title, COUNT(rental_id) AS num_rented
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title ORDER BY num_rented DESC LIMIT 5)
UNION
(SELECT title, COUNT(rental_id) AS num_rented
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title ORDER BY num_rented ASC LIMIT 5);

-- porównanie UNION i UNIO ALL
SELECT first_name FROM actor WHERE actor_id = 88
UNION
SELECT first_name FROM actor WHERE actor_id = 169;

SELECT first_name FROM actor WHERE actor_id = 88
UNION ALL
SELECT first_name FROM actor WHERE actor_id = 169;

-- lista informacji o wypożyczeniach danego filmu, przyklady kolejności wyświetlania rekordów 
(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998);

(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC);

(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC LIMIT 5);

(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC)
UNION ALL
(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC LIMIT 5);

(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC)
UNION ALL
(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC LIMIT 5)
ORDER BY rental_date DESC;

-- inny przykład
(SELECT first_name, last_name FROM actor WHERE actor_id < 5)
UNION
(SELECT first_name, last_name FROM actor WHERE actor_id > 190)
ORDER BY first_name LIMIT 4;

SELECT first_name, last_name FROM actor 
WHERE actor_id < 5 OR actor_id > 190
ORDER BY first_name LIMIT 4;

-- Złączenia lewe i prawe

-- lista wszystkich filmów z datami wypożyczenia
SELECT title, rental_date
FROM film LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id);

-- wyświetlenie klientów wypożyczających wiele filmów z tej samej kategorii
SELECT email, name AS category_name, COUNT(cat.category_id) AS cnt
FROM customer cs INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category cat USING (category_id)
GROUP BY email, category_name
ORDER BY cnt DESC LIMIT 5;

-- Złączenie naturalne
SELECT first_name, last_name, film_id
FROM actor_info NATURAL JOIN film_actor
LIMIT 20;

SELECT first_name, last_name, film_id
FROM actor_info JOIN film_actor
WHERE (actor_info.actor_id = film_actor.actor_id)
LIMIT 20;

-- Wyrażenia stałych w złączeniach 

--  porównanie wyników
SELECT email, name AS category_name, COUNT(rental_id) AS cnt
FROM category cat LEFT JOIN film_category USING (category_id)
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id)
LEFT JOIN customer cs USING (customer_id)
WHERE cs.email = 'WESLEY.BULL@sakilacustomer.org'
GROUP BY email, category_name
ORDER BY cnt DESC;

SELECT email, name AS category_name, COUNT(rental_id) AS cnt
FROM category cat LEFT JOIN film_category USING (category_id)
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id)
LEFT JOIN customer cs ON rental.customer_id = cs.customer_id
AND cs.email = 'WESLEY.BULL@sakilacustomer.org'
GROUP BY email, category_name
ORDER BY cnt DESC;

-- -- Zapytania zagnieżdżone

-- Podstawy zapytań zagnieżdżonych
-- zapytanie ze złączeniem INNER JOIN i zapytanie z zapytaniem zagnieżdzonym dające te same wyniki
SELECT first_name, last_name 
FROM actor INNER JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
WHERE title = 'ZHIVAGO CORE';

SELECT first_name, last_name 
FROM actor INNER JOIN film_actor USING (actor_id)
WHERE film_id = (SELECT film_id FROM film
WHERE title = 'ZHIVAGO CORE');

-- zapytanie wewnętrzne i zewnętrzne
SELECT film_id FROM film WHERE title = 'ZHIVAGO CORE';

SELECT first_name, last_name 
FROM actor INNER JOIN film_actor USING (actor_id)
WHERE film_id = 998;

-- który film został ostatnio wypożyczony przez klienta
SELECT MAX(rental_date) FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org';

SELECT title FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org'
AND rental_date = '2005-08-23 15:46:33';

SELECT title FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE rental_date = (SELECT MAX(rental_date) FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org');

-- Klauzule ANY, SOME, ALL, IN i NOT IN
USE employees;

-- szukamy młodszego inżyniera, który jest zatrudniony dłużej niż nenedżer o najmniejszym doświadczeniu
SELECT emp_no, first_name, last_name, hire_date
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Assistant Engineer'
AND hire_date < ANY (SELECT hire_date FROM 
employees JOIN titles USING (emp_no)
WHERE title = 'Manager');

-- ustalenie, którzy menedżerowie mają jeszcze inne tytuły
SELECT emp_no, first_name, last_name
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Manager'
AND emp_no = ANY (SELECT emp_no FROM employees
JOIN titles USING (emp_no) WHERE 
title <> 'Manager');

SELECT emp_no, first_name, last_name
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Manager'
AND emp_no IN (SELECT emp_no FROM employees
JOIN titles USING (emp_no) WHERE 
title <> 'Manager');

SELECT DISTINCT emp_no, first_name, last_name
FROM employees JOIN titles mgr USING (emp_no)
JOIN titles nomgr USING (emp_no)
WHERE mgr.title = 'Manager'
AND nomgr.title <> 'Manager';

-- znalezienie młodszych inżynierów, którzy mają większe doświadczenie niż menedżerowie, tzw. bardziej doświadczonych od najbardziej diświadczonych menedżerów
SELECT emp_no, first_name, last_name, hire_date
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Assistant Engineer'
AND hire_date < ALL (SELECT hire_date FROM
employees JOIN titles USING (emp_no)
WHERE title = 'Manager');

-- daty zatrudnienia najstarszego menedżera i młodszego inżyniera
(SELECT 'Assistant Engineer' AS title,
MIN(hire_date) AS mhd FROM employees
JOIN titles USING (emp_no)
WHERE title = 'Assistant Engineer')
UNION
(SELECT 'Manager' title,
MIN(hire_date) AS mhd FROM employees
JOIN titles USING (emp_no)
WHERE title = 'Manager');

-- wszyscy menedżerowie, którzy nie są zaliczani do seniorów
SELECT emp_no, first_name, last_name
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Manager' AND emp_no NOT IN
(SELECT emp_no FROM titles
WHERE title = 'Senior Staff');

-- sprawdzenie, czy menedżer miał w tym samym roku kalendarzowym inne stanowisko
SELECT mgr.emp_no, YEAR(mgr.from_date) AS fd
FROM titles AS mgr, titles AS other
WHERE mgr.emp_no = other.emp_no
AND mgr.title = 'Manager'
AND mgr.title <> other.title
AND YEAR(mgr.from_date) = YEAR(other.from_date);

-- sprawdzenie czy dany pracownik zalicza się do seniorów
SELECT first_name, last_name
FROM employees, titles
WHERE (employees.emp_no, first_name, last_name, title) =
(titles.emp_no, 'Marjo', 'Giarratana', 'Senior Staff');

-- Klauzule EXISTS i NOT EXISTS
USE sakila;
-- chcemy ustalić liczbę wszystkich filmów w bazie, ale tylko wtedy, gdy bada danych jest aktywna
SELECT COUNT(*) FROM film
WHERE EXISTS (SELECT * FROM rental);

-- lista wszystkich aktorów, którzy nie występują w określonym filmie w bazie danych
SELECT * FROM actor WHERE NOT EXISTS
(SELECT * FROM film WHERE title = 'ZHIVAGO CORE');

-- lista wszystkich pracowników, którzy wypożyczyli cokolwiek od firmy
SELECT first_name, last_name FROM staff
WHERE EXISTS (SELECT * FROM customer
WHERE customer.first_name = staff.first_name
AND customer.last_name = staff.last_name);

-- dodanie pracownika jako klienta
INSERT INTO customer(store_id, first_name, last_name, email, address_id, create_date)
VALUES (1, 'Mike', 'Hillyer', 'MIKE.HILLYER@sakilastaff.com', 3, NOW());

SELECT first_name, last_name FROM staff
WHERE EXISTS (SELECT * FROM customer
WHERE customer.first_name = staff.first_name
AND customer.last_name = staff.last_name);

-- lista filmów, które są przynajmniej w dwóch kopiach
SELECT COUNT(*) FROM film WHERE EXISTS
(SELECT film_id FROM inventory
WHERE inventory.film_id = film.film_id
GROUP BY film_id HAVING COUNT(*) >= 2);

-- Zapytanie zagnieżdżone w klauzuli FROM

USE employees;
-- wysokość miesięcznego wynagrodzenia
SELECT emp_no, monthly_salary FROM
(SELECT emp_no, salary/12 AS monthly_salary FROM salaries) AS ms
LIMIT 5;

USE sakila;
-- średnia kwota jaką zyskujemy na wypożyczeniu filmu
SELECT AVG(gross) FROM
(SELECT SUM(amount) AS gross
FROM payment JOIN rental USING (rental_id)
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
GROUP BY film_id) AS gross_amount;

-- Zapytanie zagnieżdżone w klauzuli JOIN 
SELECT cat.name AS category_name, cnt
FROM category AS cat
LEFT JOIN (SELECT cat.name, COUNT(cat.category_id) AS cnt
	FROM category AS cat
	LEFT JOIN film_category USING (category_id)
    LEFT JOIN inventory USING (film_id)
    LEFT JOIN rental USING (inventory_id)
    JOIN customer cs ON rental.customer_id = cs.customer_id
    WHERE cs.email = 'WESLEY.BULL@sakilacustomer.org'
    GROUP BY cat.name) customer_cat USING (name)
ORDER BY cnt DESC;

-- -- Zmienne użytkownika 

-- wyszukanie tytułu filmu i zachowanie wyniku zapytania
SELECT @film:=title FROM film WHERE film_id = 1;
-- wyświetlenie wartości zmiennej
SELECT @film;

SET @film := (SELECT title FROM film WHERE film_id = 1);

SELECT title INTO @film FROM film WHERE film_id = 1;

-- zainicjowanie licznika z wartością 0
SET @counter := 0;
-- kilka operacji w jednym zapytaniu
SET @counter = 0, @age = 23;

SELECT 0, 23 INTO @counter, @age;

-- nazwa filmu wypożyczonego przez klienta
SELECT MAX(rental_date) INTO @recent FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org';

SELECT title FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org'
AND rental_date = @recent;