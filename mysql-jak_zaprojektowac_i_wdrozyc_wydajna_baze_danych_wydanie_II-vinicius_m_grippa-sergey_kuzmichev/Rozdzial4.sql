-- ------------------------------------------------------------------------------
-- Rozdział 4. Praca ze strukturami bazy danych
-- ------------------------------------------------------------------------------

-- -- Tworzenie i używanie baz danych

-- utworzenie bazy danych
CREATE DATABASE lucy;

-- użycie bazy danych
USE lucy;

-- próba ponownego stworzenia bazy
CREATE DATABASE lucy;

CREATE DATABASE IF NOT EXISTS lucy;

-- -- Tworzenie tabeli

-- Podstawy
-- usunięcie i utworzenie bazy sakila
DROP DATABASE sakila;

CREATE DATABASE sakila;

USE sakila;

-- utworzenie tabeli
CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  first_name VARCHAR(45) DEFAULT NULL,
  last_name VARCHAR(45),
  last_update TIMESTAMP,
  PRIMARY KEY  (actor_id)
);

-- 	pokazanie wszystkich table
SHOW tables;

-- dadanie wartości do tabeli
INSERT INTO actor(first_name) VALUES ('John');

-- Kodowanie znaków i ich kolejność

-- wyświetlenie listy dostępnych typów kodowania
SHOW CHARACTER SET;

-- 	wyświetlenie dostępnych kolejności znaków i systemy kodowania znaków
SHOW COLLATION;

-- wyświetlenie bieżących ustawień dpmyślnych dotyczących kodowania znaków i ich kolejności
SHOW VARIABLES LIKE 'c%';

-- użycie kodowania znaków utf8mb4 i kolejności utf8mb4_ru_0900_as_cs
CREATE DATABASE rose DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_ru_0900_as_cs;

-- Inne funkcjonalności

CREATE TABLE IF NOT EXISTS actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id),
  KEY idx_actor_last_name (last_name)
);

-- wyświetlenie ostrzeżeńalter
SHOW WARNINGS;

-- informacje o utworzonej tabeli
SHOW CREATE TABLE actor

-- Typy kolumn

-- typy w postaci liczb całkowitych
CREATE TABLE test_bigint (id BIGINT UNSIGNED);

INSERT INTO test_bigint VALUES (18446744073709551615);

INSERT INTO test_bigint VALUES (18446744073709551615-1);

INSERT INTO test_bigint VALUES (184467440737095516*100);

CREATE TABLE test_bool (i BOOL);

INSERT INTO test_bool VALUES (true), (false);

INSERT INTO test_bool VALUES (1), (0), (-128), (127);

SELECT i, IF (i, 'true', 'false') FROM test_bool;

-- typy zmiennoprzecinkowe
CREATE TABLE wage ( monthly DOUBLE);

-- pensja 50000 rocznie
INSERT INTO wage VALUES (50000/12);
-- miesięcznie
SELECT * FROM wage;
-- przybliżony wynik
SELECT monthly*12 FROM wage;
-- pierwotna wartosc
SELECT ROUND(monthly*12,5) FROM wage;
-- zwiekszenie dokładności po przecinku, nie spowoduje przywrócenia pierwotnej wartości
SELECT ROUND(monthly*12,8) FROM wage;

-- typy ciągów znakowych
CREATE TABLE test_varchar_trailing(d VARCHAR(2) UNIQUE);

INSERT INTO test_varchar_trailing VALUES ('a'), ('a ');
-- wystąpi błąd
INSERT INTO test_varchar_trailing VALUES ('a  ');
SELECT d, LENGTH(d) FROM test_varchar_trailing;

-- tworzenie tabeli wykorzystującej kolejność znaków obsługującą atrybut PAD SPACE:
CREATE TABLE test_varchar_pad_collation(
data VARCHAR(5) CHARACTER SET latin1
COLLATE latin1_bin UNIQUE);

INSERT INTO test_varchar_pad_collation VALUES ('a');
-- wystąpi błąd
INSERT INTO test_varchar_pad_collation VALUES ('a ');

-- kolejność znaków
INSERT INTO test_varchar_pad_collation VALUES ('ä'), ('z');

SELECT * FROM test_varchar_pad_collation
ORDER BY data COLLATE latin1_german1_ci;

SELECT * FROM test_varchar_pad_collation
ORDER BY data COLLATE latin1_swedish_ci;

-- ciągi tekstowe o stałej długości
CREATE TABLE test_char_length(
utf8char CHAR(10) CHARACTER SET utf8mb4,
asciichar CHAR(10) CHARACTER SET binary);

INSERT INTO test_char_length VALUES ('Plain text', 'Plain text');

SELECT LENGTH(utf8char), LENGTH(asciichar) FROM test_char_length;

-- binarne ciągi tekstowe
CREATE TABLE test_binary_data (
d1 BINARY(16),
d2 VARBINARY(16),
d3 CHAR(16),
d4 VARCHAR(16)
);

INSERT INTO test_binary_data VALUES (
'something',
'something',
'something',
'something'
);

SELECT d1, d2, d3, d4 FROM test_binary_data;

SELECT UPPER(d2), UPPER(d4) FROM test_binary_data;

-- jawne rzutowanie danych binarnych na tekstowe
SELECT CAST(d1 AS CHAR) d1t, CAST(d2 AS CHAR) d2t FROM test_binary_data;

-- kolumna typu ENUM
CREATE TABLE fruits_enum
(fruit_name ENUM('Apple', 'Orange', 'Pear'));
-- próba wstawienia wartości której nie ma na liście- wystąpi błąd
INSERT INTO fruits_enum VALUES ('Banana');
-- próba wstawienia jednocześnie więcej niż jednej wartości- wystąpi błąd
INSERT INTO fruits_enum VALUES ('Apple,Orange');
-- wyświetlenie wstawionych wartości
SELECT * FROM fruits_enum;

-- zdefiniowana wartość domyślna
CREATE TABLE new_fruits_enum
(fruit_name ENUM('Apple', 'Orange', 'Pear')
DEFAULT 'Pear');

INSERT INTO new_fruits_enum VALUES();

SELECT * FROM new_fruits_enum;

-- typ SET
CREATE TABLE fruits_set
(fruit_name SET('Apple', 'Orange', 'Pear'));

INSERT INTO fruits_set VALUES('Apple');
INSERT INTO fruits_set VALUES('Banana'); -- wystąpi błąd
INSERT INTO fruits_set VALUES('Apple,Orange');

SELECT * FROM fruits_set;

-- typy daty i godziny

-- date
CREATE TABLE testdate (mydate DATE);

INSERT INTO testdate VALUES('2020/02/0'); -- wystąpi bład
INSERT INTO testdate VALUES('2020/02/1');
INSERT INTO testdate VALUES('2020/02/31'); -- wystąpi błąd

SELECT * FROM testdate;

-- time
CREATE TABLE test_time (id SMALLINT, mytime TIME);

INSERT INTO test_time VALUES(1, "2 13:25:59"); 
INSERT INTO test_time VALUES(2, "35 13:25:59");  -- wystąpi błąd
INSERT INTO test_time VALUES(3, "900.32"); 

SELECT * FROM test_time;

CREATE TABLE mytime (testtime TIME);

INSERT INTO mytime VALUES
('-1:1:1'), ('1:1:1'),
('1:23:45'), ('123:4:5'),
('123:45:6'), ('-123:45:6');

SELECT * FROM mytime;

-- Klucze i indeksy

-- wyświetlenie dostępnych indeksów w tabeli
SHOW INDEX FROM category;

-- informacje o tabeli
SHOW CREATE TABLE actor;

-- zmodyfikowana wersja tabeli customer
CREATE TABLE customer_mod (
customer_id smallint unsigned NOT NULL AUTO_INCREMENT,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL,
email VARCHAR(50) DEFAULT NULL,
PRIMARY KEY  (customer_id),
KEY idx_names_email (first_name, last_name, email));

SELECT * FROM customer_mod WHERE
first_name = 'Rose' AND
last_name = 'Williams' AND
email = 'rose.w@nonexistent.edu';

-- sprawdzenie, jak zostanie wykonane zapytanie
EXPLAIN SELECT * FROM customer_mod WHERE
first_name = 'Rose' AND
last_name = 'Williams' AND
email = 'rose.w@nonexistent.edu';

-- Funkcjonalność AUTO_INCREMENT 
CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  PRIMARY KEY  (actor_id)
);

-- wstawianie rekordów bez użycia kolumny axtor_id
INSERT INTO actor VALUES (NULL, 'Alexander', 'Kaidanovsky');
INSERT INTO actor VALUES (NULL, 'Anatoly', 'Solonitsyn');
INSERT INTO actor VALUES (NULL, 'Nikolai', 'Grinko');

SELECT * FROM actor;

-- przykładowa tabela
CREATE TABLE count (counter INT AUTO_INCREMENT KEY);

INSERT INTO count VALUES (), (), (), (), (), ();

SELECT * FROM count;

-- usinięcie dwóch rekordów i dodanie kolejnych sześciu
DELETE FROM count WHERE counter >4;

INSERT INTO count VALUES (), (), (), (), (), ();

SELECT * FROM count;

-- wyzerowanie licznika
TRUNCATE TABLE count;

INSERT INTO count VALUES (), (), (), (), (), ();

SELECT * FROM count;

-- -- Modyfikowanie struktury

-- Dodawanie, usuwanie i modyfikowanie kolumn

-- zmiana nazwy kolumny
ALTER TABLE language RENAME COLUMN last_update TO last_updated_time;
-- sprawdzenie
SHOW COLUMNS FROM language;
-- zapytanie alter table ze słowem kluczowym change
ALTER TABLE language CHANGE last_update last_updated_time TIMESTAMP
NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
-- modyfikacja typów i klaulul kolumny
ALTER TABLE language MODIFY name CHAR(20) DEFAULT 'n/a';
-- modyfikacja typów i klaulul kolumny ze słowem change
ALTER TABLE language CHANGE name name CHAR(20) DEFAULT 'n/a';
-- dadanie kolejnej kolumny
ALTER TABLE language ADD native_name CHAR(20);
-- jeśli kolumna ma się pojawić na początku
ALTER TABLE language ADD native_name CHAR(20) FIRST;
-- jeśli kolumna ma się pojawić w konkretnym położeniu
ALTER TABLE language ADD native_name CHAR(20) AFTER name;
-- sprawdzenie
SHOW COLUMNS FROM language;
-- usunięcie kolumny
ALTER TABLE language DROP native_name;
-- wiele zmian za pomocą jednego zapytania
ALTER TABLE language ADD native_name CHAR(255), MODIFY name CHAR(255);

-- Dodawanie, usuwanie i modyfikowanie indeksów

-- dodanie indeksu do już istniejącej tabeli
ALTER TABLE language ADD INDEX idx_name (name);
-- klucz podstawowy dla tabeli już po jej utworzeniu
CREATE TABLE no_pk (id INT);
INSERT INTO no_pk VALUES (1), (2), (3);
ALTER TABLE no_pk ADD PRIMARY KEY (id);
-- usunięcie indeksu
ALTER TABLE language DROP INDEX idx_name;
-- usunięcie klucza podstawowego
ALTER TABLE no_pk DROP PRIMARY KEY;
-- grupowanie operacji
ALTER TABLE language DROP PRIMARY KEY,
ADD PRIMARY KEY (language_id, name);
-- indeks zawiera tylko pierwsze 10 znaków kolumny
ALTER TABLE language DROP INDEX idx_name,
ADD INDEX idx_name (name(10));

-- Zmienianie nazwy tabeli i modyfikowanie innych struktur 
ALTER TABLE language RENAME TO languages;
-- krótsza notacja
RENAME TABLE languages TO language;

-- --  Usuwanie struktur

-- Usuwanie bazy danych
DROP DATABASE sakila;

-- Usuwanie tabel 
CREATE TABLE temp (id SERIAL PRIMARY KEY);
DROP TABLE IF EXISTS temp;
