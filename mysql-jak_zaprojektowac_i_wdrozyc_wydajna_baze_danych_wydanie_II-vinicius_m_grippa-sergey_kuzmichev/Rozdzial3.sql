-- ------------------------------------------------------------------------------
-- Rozdział 3 Podstawy języka SQL
-- ------------------------------------------------------------------------------

-- Używanie bazy danych sakila
-- ----------------------------------

-- Wybranie bazy danych
USE sakila;

-- Sprawdzenie która baza danych jest aktywna
SELECT DATABASE();

-- Sprawdzenie z jakich tabel składa się baza danych
SHOW TABLES;

-- Wyświetlenie kolumn tabeli
SHOW COLUMNS FROM actor;

DESC actor;

DESC city;

-- Zapytania SELECT i podstawowe techniki wykonywania zapytań: 
-- ------------------------------------------------------------

-- Zapytania SELECT dotyczące pojedynczej tabeli

-- Pobranie wszystkich danych z jednej tabeli
SELECT * FROM language;

SELECT * FROM city;

-- wybór kolumn
SELECT city FROM city;

SELECT city, city_id FROM city;

-- kolumnę można wyświetlić więcej niż raz
SELECT city, city FROM city;

SELECT name FROM sakila.language;

-- Wybieranie rekordów za pomocą klauzuli WHERE

-- szczegóły dotyczące języka angielskiego
SELECT * FROM sakila.language WHERE name = 'English';

-- imię aktora o identyfikatorze 4
SELECT first_name FROM actor WHERE actor_id = 4;

-- wszystkie miasta z Brazylii, której identyfikator ma wartość 15
SELECT city FROM city WHERE country_id = 15;

-- wartości pochodzące z pewnego zakresu
SELECT city FROM city WHERE city_id < 5;

-- wszystkie języki o identyfikatorze innym niż 2
SELECT language_id, name FROM sakila.language
WHERE language_id <> 2;

-- wszystkie imiona zaczynające się na literę mniejszą niż B
SELECT first_name FROM actor WHERE first_name < 'B';

-- działanie operatora LIKE na ciągach tekstowych
SELECT title FROM film WHERE title LIKE '%family%';

SELECT title FROM film_list WHERE actors LIKE 'NAT_%';

-- operatory AND, OR, NOT i XOR

-- wszystkie filmy z kategorii sci-fi i oznaczone jako PG
SELECT title FROM film_list WHERE category LIKE 'Sci-Fi' AND rating LIKE 'PG';

-- wszystkie filmy z kategorii Children lub Family
SELECT title FROM film_list WHERE category LIKE 'Children' OR category LIKE 'Family';

-- filmy zaliczane do kategorii Sci-Fi lub Family oraz ocenione jako 'PG'
SELECT title FROM film_list 
WHERE (category LIKE 'Sci-Fi' OR category LIKE 'Family') AND rating LIKE 'PG';

-- kolejność działań
SELECT (2+2)*3;
SELECT 2+2*3;

-- wszystkie języki o identyfikatorze innym niż 2 za pomocą operatora NOT
SELECT language_id, name FROM sakila.language
WHERE NOT (language_id = 2);

-- wszystkie filmy o identyfikatorze mniejszym od 7, ale jednocześnie nie te o identyfikatorze 4 lub 6
SELECT fid, title FROM film_list
WHERE FID < 7 AND NOT (FID = 4 OR FID =6);

-- operator BETWEEN
-- filmy dostępne w cenie od 2 do 4 dolarów, zaliczane do kategorii Documentary lub Horror, oraz w których wystąpił aktor o imieniu Bob
SELECT title FROM film_list
WHERE price BETWEEN 2 AND 4
AND (category LIKE 'Documentary' OR category LIKE 'Horror')
AND actors LIKE '%Bob%';

-- klauzula ORDER BY

-- pierwszych 10 klientów
SELECT name FROM customer_list
ORDER BY name
LIMIT 10;

-- sortowanie w kolejności rosnącej na podstawie wartości kolumny last_update
SELECT address, last_update FROM address
ORDER BY last_update LIMIT 5;

-- sortowanie na podstawie więcej niż jednej kolumny
SELECT address, district FROM address
ORDER BY district, address;

-- sortowanie w kolejności malejącej
SELECT address, district FROM address
ORDER BY district ASC, address DESC
LIMIT 10; 

-- klauzula LIMIT
SELECT name FROM customer_list LIMIT 10;

-- pierwsze pięć rekordów, przy czym pierwsze pięć są pominięte
SELECT name FROM customer_list LIMIT 5, 5;

SELECT id, name FROM customer_list ORDER BY id LIMIT 10;

SELECT id, name FROM customer_list ORDER BY id LIMIT 10 OFFSET 5;

-- złączenie dwóch tabel
SELECT city, country FROM city INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country_id < 5
ORDER BY country, city;

SELECT city, country FROM city
INNER JOIN country using (country_id)
WHERE country.country_id < 5
ORDER BY country, city;

-- zliczenie ile jest miast włoskich w bazie
SELECT COUNT(1) FROM city INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country_id = 49
ORDER BY country, city;

-- Zapytanie INSERT:
-- podstawy zapytania INSERT

SHOW COLUMNS FROM language;

-- dodanie nowego języka, wartość domyślna dla language_id
INSERT INTO language VALUES (NULL, 'Portuguese', NOW());

SELECT * FROM language;

-- dodanie nowego języka, ręczne wstawienie wartości kolumny language_id
SELECT MAX(language_id) FROM language;

INSERT INTO language VALUES (8, 'Russian', '2020-09-26 10:35:00');

SELECT * FROM language;

-- jednoczesne wstawianie wielu wartości
INSERT INTO language VALUES (NULL, 'Spanish', NOW()),
(NULL, 'Hebrew', NOW());

-- składnie alternatywne
INSERT INTO actor (actor_id, first_name, last_name, last_update)
VALUES (NULL, 'Vinicius', 'Grippa', NOW());

DESC city;

INSERT INTO city (city, country_id) VALUES ('Bebedouro', 19);

SELECT * FROM city WHERE city LIKE 'Bebedouro';

INSERT INTO city (city, country_id) VALUES
('San Carlos', 19),
('Araraquara', 19),
('Ribeirao Preto', 19);

INSERT INTO country VALUES (NULL, 'Uruguay', DEFAULT);

INSERT INTO country SET country_id = NULL,
country = 'Bahamas', last_update = NOW();

-- Zapytanie DELETE

-- podstawy pracy z zapytaniem DELETE

-- usunięcie wszystkich rekordów w tabeli
DELETE FROM rental;

SELECT * FROM rental;

-- używanie klauzuli WHERE, ORDER BY, LIMIT

-- usunięcie wszystkich rekordów, których indentyfikator rental_id ma wartość mniejszą niż 10
DELETE FROM rental WHERE rental_id < 10;

-- usunięcie wszystkich płatności Mary Smith
SELECT first_name, last_name, customer.customer_id, amount, payment_date 
FROM payment INNER JOIN customer
ON customer.customer_id = payment.customer_id
WHERE first_name = 'Mary' AND last_name = 'Smith';

DELETE FROM payment WHERE customer_id = 1;

-- ograniczenie liczby usuwanych rekordów
DELETE FROM payment ORDER BY customer_id LIMIT 10000;

-- usuwanie wszystkich rekordów za pomocą zapytania TRUNCATE
TRUNCATE TABLE payment;

-- Zapytanie UPDATE
-- przykłady

-- zwiększenie wszystkich wartości o 10%
UPDATE payment SET amount = amount * 1.1;

UPDATE payment SET last_update = '2021-02-28 17:53:00';

-- używanie klauzul WHERE, ORDER BY, LIMIT

-- uaktualnienie nazwiska
UPDATE actor SET last_name = UPPER('cruz')
WHERE first_name LIKE 'PENELOPE'
AND last_name LIKE 'GUINESS';

-- Przeglądanie baz danych i tabel za pomocą zapytań SHOW i polecenia mysqlshow

-- lista dostępnych baz
SHOW DATABASES;

-- bazy danych zaczynające się na literę s
SHOW DATABASES LIKE 'S%';

-- informacje o zapytaniu użytym do utworzenia bazy danych
SHOW CREATE DATABASE sakila;

-- lista tabel
SHOW TABLES FROM sakila;

-- lista kolumn w tabeli
SHOW COLUMNS FROM country;
