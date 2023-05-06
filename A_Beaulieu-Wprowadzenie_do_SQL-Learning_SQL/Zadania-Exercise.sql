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
-- Utwórz zapytanie zwracające wartość bezwzględną ze znakiem (-1,0,1) dla liczby -25,7823. Wygenerowane dane powinny zawierać również liczbę zaokrągloną do najbliższych 
-- setnych części.
-- Write a query that returns the absolute value and sign ( −1 , 0 , or 1 ) of  −25.76823 . Also return the number rounded to the nearest hundredth.

SELECT SIGN(-25.76823) AS sign, ABS(-2576823) AS abs, ROUND(-25.76823, 2) AS round;

-- Zadanie / Exercise 7.3
-- Utwórz zapytanie zwracające bieżący miesiąc.
-- Write a query to return just the month portion of the current date.

SELECT EXTRACT(MONTH FROM CURRENT_DATE());

------------------------------
-- Rozdział 8 / Chapter 8
------------------------------

-- Zadanie / Exercise 8.1
-- Utwórz zapytanie zliczające rekordy w tabeli payment. /  Construct a query that counts the number of rows in the payment table.

SELECT COUNT(*) AS rekoedy FROM payment;

-- Zadanie / Exercise 8.2
-- Zmodyfikuj zapytanie z ćwiczenia 8.1 w taki sposób, aby zliczało liczbę płatności dokonanych przez poszczególnych klientów. Dane wyjściowe powinny zawierać identyfikator
-- klienta i całkowitą kwotę jego płatności. /
-- Modify your query from Exercise 8-1 to count the number of payments made by each customer. Show the customer ID and the total amount paid for each customer.

SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id;

-- Zadanie / Exercise 8.3
-- Zmodyfikuj zapytanie z ćwiczenia 8.2 w taki sposób, aby uwzględniono jedynie tych klientów, którzy dokonali przynajmniej 40 płatności. /
-- Modify your query from Exercise 8-2 to include only those customers who have made at least 40 payments.

SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id
HAVING count(*) >=40;

------------------------------
-- Rozdział 9 / Chapter 9
------------------------------

-- Zadanie / Exercise 9.1
-- Utwórz zapytanie do tabeli film wykorzystujące warunek filtrowania z niepowiązanym podzapytaniem do tabeli category w celu znalezienia wszystkich filmów akcji / 
-- Construct a query against the film table that uses a filter condition with a noncorrelated subquery against the category table to find all action films
-- (category.name = 'Action')

SELECT f.title
FROM film f 
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc INNER JOIN category c
  	 ON fc.category_id = c.category_id
        WHERE c.name = 'Action');

-- Zadanie / Exercise 9.2
-- Zapytanie z ćwiczenia 9.1 zmodyfikuj w taki sposób, aby używało powiązanego podzapytania do tabel category i film_category w celu wygenerowania tych samych danych. /
-- Rework the query from Exercise 9-1 using a correlated subquery against the category and film_category tables to achieve the same results.

SELECT f.title
FROM film f 
WHERE EXISTS
(SELECT 1
FROM film_category fc INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Action'
AND fc.film_id = f.film_id);

-- Zadanie / Exercise 9.3
-- Przeprowadź złączenie następującego zapytania z podzapytaniem do tabeli film_actor w celu wyświetlenia informacji o poziomie poszczególnych aktorów:
-- Join the following query to a subquery against the film_actor table to show the level of each actor:
-- 			SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
-- 			UNION ALL
-- 			SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
-- 			UNION ALL
-- 			SELECT 'Newcomer' level, 1 min_roles, 19 max_roles
-- Podzapytanie do tabeli film_actor powinno zliczać rekordy dla każdego aktora za pomocą GROPU BY actor_id, a następnie ta wartość powinna zostać porównana z kolumnami 
-- min_roles i max_roles w celu ustalenia poziomu danego aktora.
-- A subquery to the film_actor table should count the records for each actor using GROUP BY actor_id, and then this value should be compared to the min_roles and max_roles
-- columns to determine the actor's level.

SELECT actr.actor_id, grps.level
from
(SELECT actor_id, count(*) num_roles
from film_actor
GROUP BY actor_id
) actr
INNER JOIN
(SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles
) grps
ON actr.num_roles BETWEEN grps.min_roles AND grps.max_roles;

------------------------------
-- Rozdział 10 / Chapter 10
------------------------------

-- Zadanie / Exercise 10.1
-- Używając przedstawionych tutaj definicji tabel i ich danych, utwórz zapytanie zwracające rekordy wszystkich klientów wraz z sumą dokonanych przez nich płatności.
-- Using the table definitions and their data presented here, write a query that returns each customer name along with their total payments:
-- 	customer1							payment1
--	+-------------+-------------+					+------------+-------------+--------+
--	| customer_id | name        |					| payment_id | customer_id | amount |
--	+-------------+-------------+					+------------+-------------+--------+
--	|           1 | John Smith  |					|        101 |           1 |   8.99 |
--	|           2 | Kathy Jones |					|        102 |           3 |   4.99 |
--	|           3 | Greg Oliver |					|        103 |           1 |   7.99 |
--	+-------------+-------------+					+------------+-------------+--------+

SELECT c.name, SUM(p.amount) total_payments
FROM customer1 c 
LEFT OUTER JOIN payment1 p 
    ON c.customer_id = p.customer_id
GROUP BY c.name;

-- Zadanie / Exercise 10.2
-- Zmodyfikuj zapytanie w ćwiczeniu 10.1 w taki sposób, aby używało złączenia zewnętrznego. / Modify the query in Exercise 10.1 to use an outer join.

SELECT c.name, SUM(p.amount) total_payments
FROM payment1 p 
RIGHT OUTER JOIN customer1 c
    ON c.customer_id = p.customer_id
GROUP BY c.name;

-- Zadanie / Exercise 10.3
-- Opracuj zapytanie pozwalające wygenerować zbiór {1,2,3, ..., 99, 100}. (Podowiedź użyj złączenia krzyżowego z co najmniej dwoma podzapytaniami kluazuli FROM). /
-- Develop a query to generate the set {1,2,3, ..., 99, 100}. (Prompt use a cross join with at least two subqueries of the FROM clause.)

SELECT ones.x + tens.x + 1
FROM (
SELECT 0 x UNION ALL
SELECT 1 x UNION ALL
SELECT 2 x UNION ALL
SELECT 3 x UNION ALL
SELECT 4 x UNION ALL
SELECT 5 x UNION ALL
SELECT 6 x UNION ALL
SELECT 7 x UNION ALL
SELECT 8 x UNION ALL
SELECT 9 x 
) ones
CROSS JOIN (
SELECT 0 x UNION ALL
SELECT 10 x UNION ALL
SELECT 20 x UNION ALL
SELECT 30 x UNION ALL
SELECT 40 x UNION ALL
SELECT 50 x UNION ALL
SELECT 60 x UNION ALL
SELECT 70 x UNION ALL
SELECT 80 x UNION ALL
SELECT 90 x 
) tens;

------------------------------
-- Rozdział 11 / Chapter 11
------------------------------

-- Zadanie / Exercise 11.1
-- Zmodyfikuj zapytanie wykorzystujące wyrażenie CASE, aby ten sam wynik został wygenerowany po użyciu wyszukiwanego wyrażenia CASE. Postaraj sie użyć jak najmiej klauzul WHEN./
-- Modify the query that uses the CASE expression so that the same result is generated when using the CASE search expression. Try to use as few WHEN clauses as possible.
--				SELECT name,
--				  CASE name
--			 	    WHEN 'English' THEN 'latin1'
--				    WHEN 'Italian' THEN 'latin1'
--				    WHEN 'French' THEN 'latin1'
--				    WHEN 'German' THEN 'latin1'
--				    WHEN 'Japanese' THEN 'utf8'
--				    WHEN 'Mandarin' THEN 'utf8'
--				    ELSE 'Unknown'
--				  END character_set
--				FROM language;

SELECT name,
  CASE name
    WHEN name IN ('English', 'Italian', 'French', 'German') THEN 'latin1'
    WHEN name IN ('Japanese', 'Mandarin') THEN 'utf'
    ELSE 'Unknown'
  END character_set
FROM language;

-- Zadanie / Exercise 11.2
-- Zmodyfikuj zapytanie w taki sposób, aby zbiór wynikowy składał się z jednego rekordu z pięcioma kolumnami (po jednej dla każdej ceny). Kolumnom nadaj nazwy 
-- G, PG, PG_13, R i NC_17. /
-- Modify the query so that the result set consists of one record with five columns (one for each price). Name the columns G, PG, PG_13, R i NC_17.
--				SELECT rating, count(*)
--				FROM film
--				GROUP BY rating;
--				+--------+----------+
--				| rating | count(*) |
--				+--------+----------+
--				| G      |      178 |
--				| PG     |      194 |
--				| PG-13  |      223 |
--				| R      |      195 |
--				| NC-17  |      210 |
--				+--------+----------+

SELECT
SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) g,
SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) pg,
SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) pg_13,
SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) r,
SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) nc_17
FROM film;

------------------------------
-- Rozdział 12 / Chapter 12
------------------------------

-- Zadanie / Exercise 12.1
-- Utwórz transakcję umożliwiającą wykonanie przelewu 50 złotych z konta 123 na konto 789. Do tabeli transaction trzeba wstawić dwa rekordy i uaktualnić dwa rekordy w tabeli
-- account. Wykorzystaj następujące definicje tabel i danych.
-- Użyj polecenia txn_type_cd = 'C' do określenia uznania (dodania środków) i txn_type_cd = 'D' do wskazania obciążenia (pobrania środków).
-- Create a transaction to transfer PLN 50 from account 123 to account 789. You need to insert two records into the transaction table and update two records in the account 
-- table. Use the following table and data definitions.
-- Use txn_type_cd = 'C' to indicate credit (add funds) and txn_type_cd = 'D' to indicate debit (debit funds).
--  	Account										Transaction
--	+------------+---------------+--------------------+				+--------+------------+------------+-------------+--------+
--	| account_id | avail_balance | last_activity_date |				| txn_id | txn_date   | account_id | txn_type_cd | amount |
--	+------------+---------------+--------------------+				+--------+------------+------------+-------------+--------+
--	|        123 |           500 | 2019-07-10         |				|   1001 | 2019-05-15 |        123 | C           |    500 |
--	|        789 |            75 | 2019-06-22         |				|   1002 | 2019-06-01 |        789 | C           |     75 |
--	+------------+---------------+--------------------+				+--------+------------+------------+-------------+--------+

START TRANSACTION;

INSERT INTO Transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1003, now(), 123, 'D', 50);

INSERT INTO Transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1004, now(), 789, 'C', 50);

UPDATE Account
SET avail_balance = avail_balance - 50,
last_activity_date = now()
WHERE account_id = 123;

UPDATE Account
SET avail_balance = avail_balance + 50,
last_activity_date = now()
WHERE account_id = 789;

COMMIT;

------------------------------
-- Rozdział 13 / Chapter 13
------------------------------

-- Zadanie / Exercise 13.1
-- Utwórz zapytanie ALTER TABLE dla tabeli rental, aby nastąpiło wygenerowanie błędu, jeśli z tabeli customer zostanie usunięta wartość znajdująca się w kolumnie 
-- rental.customer_id. /
-- Create an ALTER TABLE query on the rental table so that an error is generated if the value in the rental.customer_id column is deleted from the customer table.

ALTER TABLE rental
ADD CONSTRAINT fk_rental_customer_id FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON DELETE RESTRICT;

-- Zadanie / Exercise 13.2
-- Dla tabeli payment utwórz indeks wielokolumnowy, który będzie mógł być później używany w obu przedstawionych tutaj zapytaniach. /
-- For the payment table, create a multi-column index that can later be used in both queries shown here.
--			SELECT customer_id, payment_date, amount
--			FROM payment
--			WHERE payment_date > cast('2019-12-31 23:59:59' AS datetime);
--
--			SELECT customer_id, payment_date, amount
--			FROM payment
--			WHERE payment_date > cast('2019-12-31 23:59:59' AS datetime)
--			AND amount < 5;

CREATE INDEX idx_payment01
ON payment (payment_date, amount);
