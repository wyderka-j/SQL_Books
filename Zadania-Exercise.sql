 --Zadania zostawy wykonane przy użyciu MySQL / The tasks were performed using MySQL

------------------------------
-- Rozdział 3 / Chapter 3
------------------------------

-- Zadanie / Exercise 3.1
-- Pobierz identyfikator, imię i nazwisko wszytkich aktorów. Dane posortuj najpierw według nazwiska, a później według imienia.
-- Retrieve the actor ID, first name, and last name for all actors. Sort by last name and then by first name.

SELECT actor_id, first_name, last_name
from actor
ORDER BY last_name, first_name;

-- Zadanie /  Exercise 3.2
-- Pobierz identyfikator, imię i nazwisko wszystkich aktorów, których nazwisko to 'WILLIAMS' lub 'DAVIS'. /
-- Retrieve the actor ID, first name, and last name for all actors whose last name equals 'WILLIAMS' or 'DAVIS'.

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name = 'WILLIAMS' OR last_name = 'DAVIS';

-- drugie roz

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name IN ('WILLIAMS', 'DAVIS');

-- Zadanie / Exercise 3.3 
-- Utwórz zapytanie do tabeli rental zwracające identyfikatory wszystkich klientów, którzy wypożyczyli film 5 czerwca 2005 roku (wykorzystaj kolumnę rental.rental_date, do zignorowania 
-- komponentu godziny możesz użyć funcji date()). Wyświetl tylko po jednym rekordzie dla każdego identyfikatora klienta. /
-- Write a query against the rental table that returns the IDs of the customers who rented a film on July 5, 2005 (use the rental.rental_date column, and you can use the date() function to
-- ignore the time component). Include a single row for each distinct customer ID.

SELECT DISTINCT customer_id
FROM rental
WHERE date(rental_date) = '2005-07-05';

-- Zadanie / Exercise 3.4
-- Uzupełnij zapytanie do wielu tabel, które spowoduje wygenerowanie pokazanych dancyh wyjściowych. Miejsca do uzupełnienia są oznaczone jako <#>. /
-- Fill in the blanks (denoted by <#>) for this multitable query to achieve the following results:
--  	SELECT c.email, r.return_date
-- 	FROM customer c 
--    	INNER JOIN rental as <1>
--    		ON c.customer_id = <2>
-- 	WHERE CONVERT(date, r.rental_date) = '2005-06-14'
-- 	ORDER BY <3> <4>;


SELECT c.email, r.return_date
FROM customer c 
    INNER JOIN rental r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;