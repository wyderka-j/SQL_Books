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
-- Utwórz zapytanie do tabeli rental zwracające identyfikatory wszystkich klientów, którzy wypożyczyli film 5 czerwca 2005 roku (wykorzystaj kolumnę rental.rental_date, do
-- zignorowania komponentu godziny możesz użyć funcji date()). Wyświetl tylko po jednym rekordzie dla każdego identyfikatora klienta. /
-- Write a query against the rental table that returns the IDs of the customers who rented a film on July 5, 2005 (use the rental.rental_date column, and you can use the date()
-- function to ignore the time component). Include a single row for each distinct customer ID.

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


------------------------------
-- Rozdział 4 / Chapter 4
------------------------------

-- Zadanie / Exercise 4.1
-- Które wartości payment_id zostaną zwrócone po użyciu tego warunku filtrowania? / Which of the payment IDs would be returned by the following filter conditions?
-- customer_id <> 5 AND (amount > 8 OR date(payment_date) = '2005-08-23')

SELECT DISTINCT customer_id 
FROM payment 
WHERE customer_id <> 5 
	AND (amount > 8 OR date(payment_date) = '2005-08-23');

-- Zadanie / Exercise 4.2
-- Które wartości payment_id zostaną zwrócone po użyciu tego warunku filtrowania? / Which of the payment IDs would be returned by the following filter conditions?
-- customer_id = 5 AND NOT (amount > 6 OR date(payment_date) = '2005-06-19')

SELECT DISTINCT payment_id 
FROM payment 
WHERE customer_id = 5 
	AND NOT (amount > 6 OR date(payment_date) = '2005-06-19');

-- Zadanie / Exercise 4.3
-- Przygotuj zapytanie pobierające wszystkie rekordy tabeli payments, w których wartość kolumny amount wynosi 1.98, 7.98 lub 9.98. / 
-- Construct a query that retrieves all rows from the payments table where the amount is either 1.98, 7.98, or 9.98.

SELECT amount
FROM payment
WHERE amount IN (1.98, 7.98, 9.98);

-- Zadanie / Exercise 4.4
-- Przygotuj zapytanie pobierajace wszystkie rekordy wszystkich klientów, których nazwisko zawiera literę A na drugiej pozycji i literę W na dowolnej pozycji po A.
-- Construct a query that finds all customers whose last name contains an A in the second position and a W anywhere after the A.

SELECT first_name, last_name
FROM customer
WHERE last_name LIKE '_A%W%';

------------------------------
-- Rozdział 5 / Chapter 5
------------------------------

-- Zadanie / Exercise 5.1
-- uzupełnij brakujące fragmenty kodu (oznaczone za pomocą <#>) w zapytaniu, które powoduje wygenerowanie pokazanych rekordów. /
-- Fill in the blanks (denoted by <#> ) for the following query to obtain the results that follow.
--			SELECT c.first_name, c.last_name, a.address, ct.city
--			FROM customer c 
--			    INNER JOIN address <1>
--			    ON c.address_id = a.address_id
--			    INNER JOIN city ct 
--			    ON a.city_id = <2>
-- 			WHERE a.district = 'California'
--	+------------+-----------+------------------------+----------------+
--	| first_name | last_name | address                | city           |
--	+------------+-----------+------------------------+----------------+
--	| PATRICIA   | JOHNSON   | 1121 Loja Avenue       | San Bernardino |
--	| BETTY      | WHITE     | 770 Bydgoszcz Avenue   | Citrus Heights |
--	| ALICE      | STEWART   | 1135 Izumisano Parkway | Fontana        |
--	| ROSA       | REYNOLDS  | 793 Cam Ranh Avenue    | Lancaster      |
--	| RENEE      | LANE      | 533 al-Ayn Boulevard   | Compton        |
--	| KRISTIN    | JOHNSTON  | 226 Brest Manor        | Sunnyvale      |
--	| CASSANDRA  | WALTERS   | 920 Kumbakonam Loop    | Salinas        |
--	| JACOB      | LANCE     | 1866 al-Qatif Avenue   | El Monte       |
--	| RENE       | MCALISTER | 1895 Zhezqazghan Drive | Garden Grove   |
--	+------------+-----------+------------------------+----------------+
--	9 rows in set (0.00 sec)


SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer c 
    INNER JOIN address a
    ON c.address_id = a.address_id
    INNER JOIN city ct 
    ON a.city_id = ct.city_id
WHERE a.district = 'California';

-- Zadanie / Exercise 5.2
-- Utwórz zapytanie zwracające tytuł każdego filmu, w którym wystąpili aktorzy o imieniu JOHN.
-- Write a query that returns the title of every film in which an actor with the first name JOHN appeared.

SELECT f.title
FROM film f
    INNER JOIN film_actor fa 
    ON f.film_id = fa.film_id
    INNER JOIN actor a 
    ON a.actor_id = fa.actor_id
WHERE a.first_name = 'JOHN';

-- Zadanie / Exercise 5.3
-- Utwórz zapytanie zwracające wszystkie rekordy klientów mieszkających w tym samym mieście. Musisz przeprowadzić złączenie tabeli address z nią samą, a każdy rekord powinien
-- zawierać dwa różne adresy./ 
-- Construct a query that returns all addresses that are in the same city. You will need to join the address table to itself, and each row should include two different addresses.

SELECT a1.address addr1, a2.address addr2, a1.city_id
FROM address a1
    INNER JOIN address a2 
WHERE a1.city_id = a2.city_id
AND a1.address_id <> a2.address_id;

------------------------------
-- Rozdział 6 / Chapter 6
------------------------------

-- Zadanie / Exercise 6.1
-- Jeżeli mamy zbiory A={L M N O P} i B={P Q R S T}, to jakie zbiory zostaną wygenerowane przez przedstawione tutaj opcje? /
-- If set A = {L M N O P} and set B = {P Q R S T}, what sets are generated by the follow‐ ing operations?
-- 		A union B
--		A union all B
-- 		A intersect B
-- 		A except B


-- A union B  =  {L, M, N, O, P, Q, R, S, T}
-- A union all B  = {L, M, N, O, P, P, Q, R, S, T}
-- A intersect B  = {P}
-- A except B = {L, M, N O}

-- Zadanie / Exercise 6.2
-- Utwórz zapytanie złożone wyszukujące imiona i nazwiska wszystkich aktorów i klientów, których nazwiska rozpoczynają sie na literę L.
-- Write a compound query that finds the first and last names of all actors and customers whose last name starts with L.

SELECT last_name, first_name
FROM actor 
WHERE last_name LIKE 'L%'
UNION
SELECT last_name, first_name
FROM customer 
WHERE last_name LIKE 'L%';

-- Zadanie / Exercise 6.3
-- Wyniki wygenerowane przez zapytanie w ćwiczeniu 6.2 posortuj według kolumny last_name. / Sort the results from Exercise 6-2 by the last_name column.

SELECT last_name, first_name
FROM actor 
WHERE last_name LIKE 'L%'
UNION
SELECT last_name, first_name
FROM customer 
WHERE last_name LIKE 'L%'
ORDER BY last_name;


------------------------------
-- Rozdział 7 / Chapter 7
------------------------------

-- Zadanie / Exercise 7.1
-- Utwórz zapytanie zwracające znaki od 19. do 25. ciągu tekstowego 'Proszę wyodrębnić podciąg tekstowy z danego ciągu tekstowego'.
-- Write a query that returns the 17th through 25th characters of the string 'Proszę wyodrębnić podciąg tekstowy z danego ciągu tekstowego'.

SELECT SUBSTRING('Proszę wyodrębnić podciąg tekstowy z danego ciągu tekstowego', 19, 7);

-- Zadanie / Exercise 7.2
-- Utwórz zapytanie zwracające wartość bezwzględną ze znakiem (-1,0,1) dla liczby -25,7823. Wygenerowane dane powinny zawierać również liczbę zaokrągloną do najbliższych setnych części.
--Write a query that returns the absolute value and sign ( −1 , 0 , or 1 ) of  −25.76823 . Also return the number rounded to the nearest hundredth.

SELECT SIGN(-25.76823) AS sign, ABS(-2576823) AS abs, ROUND(-25.76823, 2) AS round;

-- Zadanie / Exercise 7.3
-- Utwórz zapytanie zwracające bieżący miesiąc.
-- Write a query to return just the month portion of the current date.

SELECT EXTRACT(MONTH FROM CURRENT_DATE());
