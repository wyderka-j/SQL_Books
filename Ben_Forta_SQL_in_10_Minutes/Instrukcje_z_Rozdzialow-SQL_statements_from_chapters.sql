--------------------------------------------------------------------------------------------------------------------------
--Rozdział 2 / Chapter 2 
--Pobieranie danych / Retrieving Data
--------------------------------------------------------------------------------------------------------------------------

-- Pobieranie pojedynczych kolumn - retrieving individual columns
SELECT prod_nazwa
FROM Produkty;

-- Pobieranie wielu kolumn - retrieving multiple columns
SELECT prod_id, prod_nazwa, prod_cena
FROM Produkty;

-- Pobieranie wszystkich kolumn - retrieving all columns 
SELECT *
FROM Produkty;

-- Pobieranie jedynie unikatowych wierszy - retrieving distinct rows
SELECT dost_id 
FROM Produkty;

SELECT DISTINCT dost_id 
FROM Produkty;

-- Ograniczenie liczby zwracanych wyników - limiting results
SELECT TOP 5 prod_nazwa 
FROM Produkty;

--------------------------------------------------------------------------------------------------------------------------
--Rozdział 3 / Chapter 3 
--Sortowanie pobranych danych / Sorting Retrieved Data
--------------------------------------------------------------------------------------------------------------------------

-- Sortowanie danych - sorting data
SELECT prod_nazwa 
FROM Produkty;

SELECT prod_nazwa 
FROM Produkty
ORDER BY prod_nazwa;

-- Sortowanie na podstawie wielu kolumn - sorting_multiple_columns
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
ORDER BY prod_cena, prod_nazwa;

-- Sortowanie na podstawie położenia kolumny - sorting by column position
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
ORDER BY 2,3;

-- Określenie kierunku sortowania - specifying sort direction
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
ORDER BY prod_cena DESC;

SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
ORDER BY prod_cena DESC, prod_nazwa;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 4 / Chapter 4 
--Filtrowanie danych / Filtering Data
--------------------------------------------------------------------------------------------------------------------------

-- Stosowanie klauzuli WHERE - using the where clause
SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena = 9.99;

SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena < 30;

SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena <= 30;

-- Pobieranie niepasujących danych - checking for nonmatches
SELECT dost_id, prod_nazwa
FROM Produkty
WHERE dost_id <> 'DLL01';

SELECT dost_id, prod_nazwa
FROM Produkty
WHERE dost_id != 'DLL01';

-- Sprawdzanie zakresu wartości - checking for a range of values
SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena between 10 and 30;

-- Sprawdzenie braku wartości - checking for a null value
SELECT prod_nazwa
WHERE prod_cena is null;

SELECT kl_nazwa
FROM Klienci
WHERE kl_email is null;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 5 / Chapter 5 
--Zaawansowane filtrowanie danych / Advanced Data Filtering
--------------------------------------------------------------------------------------------------------------------------

-- Użycie operatora AND - using the and operator
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
WHERE dost_id = 'DLL01' AND prod_cena <= 10;

-- Użycie operatora OR - using the or operator
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
WHERE dost_id = 'DLL01' OR dost_id = 'BRS01';

-- Kolejność wykonywania działań - understanding order of evaluation
SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
WHERE (dost_id = 'DLL01' OR dost_id = 'BRS01') AND prod_cena >=50;

-- Operator IN - using the in operator
SELECT prod_cena, prod_nazwa
FROM Produkty
WHERE dost_id IN ('DLL01' ,'BRS01')
ORDER BY prod_nazwa;

SELECT prod_id, prod_cena, prod_nazwa
FROM Produkty
WHERE dost_id = 'DLL01' OR dost_id = 'BRS01'
ORDER BY prod_nazwa;

-- Operator NOT - using the not operator
SELECT prod_nazwa
FROM Produkty
WHERE NOT dost_id = 'DLL01'
ORDER BY prod_nazwa;

SELECT prod_nazwa
FROM Produkty
WHERE NOT dost_id <> 'DLL01'
order by prod_nazwa;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 6 / Chapter 6 
--Filtrowanie za pomocą znaków wieloznacznych / Using Wildcard Filtering
--------------------------------------------------------------------------------------------------------------------------

-- Znak procentu % - percent_sign_wildcard
SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_nazwa LIKE 'Rybka%';

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_nazwa LIKE '%szmacianka%';

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_nazwa LIKE 'p%m';

-- Znak podkreślenia _ - underscore wildcard
SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_nazwa LIKE 'Pluszowy miś __ cm';

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_nazwa LIKE 'Pluszowy miś % cm';

-- Znaki nawiasów kwadratowych - brackets wildcard
SELECT kl_kontakt
FROM Klienci
WHERE kl_kontakt LIKE '[JM]%'
ORDER BY kl_kontakt;

SELECT kl_kontakt
FROM Klienci
WHERE kl_kontakt LIKE '[^JM]%'
ORDER BY kl_kontakt;

SELECT kl_kontakt
FROM Klienci
WHERE NOT kl_kontakt LIKE '[JM]%'
ORDER BY kl_kontakt;

--------------------------------------------------------------------------------------------------------------------------
--rozdzial 7 / Chapter 7 
--Tworzenie pól obliczanych / Creating Calculated Fields
--------------------------------------------------------------------------------------------------------------------------

-- Konkatenacja pól - concatenating fields
SELECT dost_nazwa + ' (' + dost_kraj + ')'
FROM Dostawcy
ORDER BY dost_nazwa;

SELECT RTRIM(dost_nazwa) + ' (' + RTRIM(dost_kraj) + ')'
FROM Dostawcy
ORDER BY dost_nazwa;

-- Stosowanie aliasów - Use of aliases
SELECT RTRIM(dost_nazwa) + ' (' + RTRIM(dost_kraj) + ')' AS dost_TYTUL
FROM Dostawcy
ORDER BY dost_nazwa;

-- Przeprowadzanie obliczeń matematycznych - Performing mathematical calculations
SELECT prod_id, ilosc, cena_elem
FROM ElementyZamowienia
WHERE zam_numer = 20008;

SELECT prod_id, ilosc, cena_elem, ilosc * cena_elem AS wartosc
FROM ElementyZamowienia
WHERE zam_numer = 20008;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 8 / Chapter 8 
--Modyfikacja danych za pomocą funkcji / Using Data Manipulation Functions
--------------------------------------------------------------------------------------------------------------------------

-- Funkcje tekstowe - text manipulation
SELECT dost_nazwa, UPPER(dost_nazwa) AS dost_nazwa_duze
FROM Dostawcy
ORDER BY dost_nazwa;

SELECT kl_nazwa, kl_kontakt
FROM Klienci
WHERE kl_kontakt = 'Michael Znany';

SELECT kl_nazwa, kl_kontakt
FROM Klienci
WHERE SOUNDEX(kl_kontakt) = SOUNDEX('Michael Znany');

-- Funkcje daty i czasu - date and time manipulation
SELECT zam_numer
FROM Zamowienia
WHERE DATEPART(yy, zam_data) = 2002;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 9 / Chapter 9 
-- Funkcje agregujące / Summarizing Data
--------------------------------------------------------------------------------------------------------------------------

-- AVG()
SELECT AVG(prod_cena)
FROM Produkty;

SELECT AVG(prod_cena) AS sr_cena
FROM Produkty
WHERE dost_id = 'DLL01';

-- COUNT()
SELECT COUNT(*) AS liczba_klientow 
FROM Klienci;

SELECT COUNT(kl_email) AS liczba_klientow 
FROM Klienci;

-- MAX()
SELECT MAX(prod_cena) AS max_cena 
FROM Produkty;

-- MIN()
SELECT MIN(prod_cena) AS max_cena 
FROM Produkty;

-- SUM()
SELECT SUM(ilosc) AS elementy_zamowienia
FROM ElementyZamowienia
WHERE zam_numer = 20005;

SELECT SUM(cena_elem*ilosc) AS laczna_cena
FROM ElementyZamowienia
WHERE zam_numer = 20005;

-- Unikatowe wartości - distinct values
SELECT AVG(DISTINCT prod_cena) AS laczna_cena
FROM Produkty
WHERE dost_id = 'DLL01';

-- Łączenie funkcji agregujących - multiple calculations
SELECT COUNT(*) AS liczba_el,
MIN(prod_cena) AS cena_max,
MAX(prod_cena) AS cena_nim,
AVG(prod_cena) AS avg_cena
FROM Produkty;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 10 / Chapter 10 
--Grupowanie danych / Grouping Data
--------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS liczba_prod
FROM Produkty
WHERE dost_id = 'DLL01';

-- Tworzenie grup - creating group 
SELECT dost_id, COUNT(*) AS liczba_prod
FROM Produkty
GROUP BY dost_id;

-- Filtrowanie grup - filtering groups
SELECT kl_id, COUNT(*) AS zamowienia
FROM Zamowienia
GROUP BY kl_id
HAVING COUNT(*) >= 2;

SELECT dost_id, COUNT(*) AS liczba_prod
FROM Produkty
WHERE prod_cena >= 10
GROUP BY dost_id
HAVING COUNT(*) >= 2;

SELECT dost_id, COUNT(*) AS liczba_prod
FROM Produkty
GROUP BY dost_id
HAVING COUNT(*) >= 2;

-- Grupowanie i sortowanie - grouping and sorting
SELECT zam_numer, COUNT(*) AS elementy
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING COUNT(*) >= 3;

SELECT zam_numer, COUNT(*) AS elementy
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING COUNT(*) >= 3
ORDER BY elementy, zam_numer;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 11 / Chapter 11 
--Zapytania zagnieżdżone / Working with Subqueries
--------------------------------------------------------------------------------------------------------------------------

-- Filtrowanie na podstawie zapytań zagnieżdżonych - Filtering based on nested queries
SELECT zam_numer
FROM ElementyZamowienia
WHERE prod_id = 'RGAN01';

SELECT kl_id
FROM Zamowienia
WHERE zam_numer IN (20007, 20008);

SELECT kl_id
FROM Zamowienia
WHERE zam_numer in (SELECT zam_numer
				FROM ElementyZamowienia
				WHERE prod_id = 'RGAN01');

SELECT kl_nazwa, kl_kontakt
FROM Klienci
WHERE kl_id IN (SELECT kl_id
			FROM Zamowienia
			WHERE zam_numer IN (SELECT zam_numer
							FROM ElementyZamowienia
							WHERE prod_id = 'RGAN01'));

-- Zapytania zagnieżdżone jako pola obliczane - Nested queries as calculated fields
SELECT COUNT(*) AS zamowienia
FROM Zamowienia
WHERE kl_id = '1000000001';

SELECT kl_nazwa,
       kl_woj,
       (SELECT COUNT(*)
        FROM Zamowienia
        WHERE Zamowienia.kl_id = Klienci.kl_id) AS Zamowienia
FROM Klienci
ORDER BY kl_nazwa;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 12 / Chapter 12 
--Złączanie tabel / Joining Tables
--------------------------------------------------------------------------------------------------------------------------

-- Tworzenie złączeń - Create joins
SELECT dost_nazwa, prod_nazwa, prod_cena
FROM Dostawcy, Produkty
WHERE Dostawcy.dost_id = Produkty.dost_id;

-- iloczyn kartezjański - cartesian product
SELECT dost_nazwa, prod_nazwa, prod_cena
FROM Dostawcy, Produkty;

-- Złączenie wewnętrzne - inner join
SELECT dost_nazwa, prod_nazwa, prod_cena
FROM Dostawcy
INNER JOIN Produkty ON Dostawcy.dost_id = Produkty.dost_id;

-- Złączanie  wielu tabel - multiple tables
SELECT prod_nazwa, dost_nazwa, prod_cena, ilosc
FROM ElementyZamowienia, Dostawcy, Produkty
WHERE Dostawcy.dost_id = Produkty.dost_id
	AND ElementyZamowienia.prod_id = Produkty.prod_id
	AND zam_numer = 20007;

SELECT kl_nazwa, kl_kontakt
FROM Klienci
WHERE kl_id IN (SELECT kl_id 
			FROM Zamowienia 
			WHERE zam_numer IN (SELECT zam_numer 
							FROM ElementyZamowienia 
							WHERE prod_id = 'RGAN01'));

SELECT kl_nazwa, kl_kontakt
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
	AND ElementyZamowienia.zam_numer = Zamowienia.zam_numer
	AND prod_id = 'RGAN01';

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 13 / Chapter 13 
--Tworzenie zaawansowanych złączeń / Creating Advanced Joins
--------------------------------------------------------------------------------------------------------------------------

-- Stosowanie aliasów tabel - aliases
SELECT RTRIM(dost_nazwa) + ' ('+RTRIM(dost_kraj) + ')' AS dost_tytul
FROM Dostawcy
ORDER BY dost_nazwa;

SELECT kl_nazwa, kl_kontakt
FROM Klienci AS K, Zamowienia AS Z, ElementyZamowienia AS E
WHERE K.kl_id = Z.kl_id
	AND E.zam_numer = Z.zam_numer
	AND prod_id = 'RGAN01';

-- Tworzenie złączeń własnych - self join
SELECT kl_id, kl_nazwa, kl_kontakt
FROM Klienci 
WHERE kl_nazwa = (SELECT kl_nazwa 
				FROM Klienci 
				WHERE kl_kontakt = 'Danuta Sroka');

SELECT K1.kl_id, K1.kl_nazwa, K1.kl_kontakt
FROM Klienci AS K1, Klienci AS K2
WHERE K1.kl_nazwa = K2.kl_nazwa
	AND K2.kl_kontakt = 'Danuta Sroka';

-- Złączenia naturalne
SELECT K.*, Z.zam_numer, Z.zam_data, E.prod_id, E.ilosc, E.cena_elem
FROM Klienci AS K, Zamowienia AS Z, ElementyZamowienia AS E
WHERE K.kl_id = Z.kl_id
	AND  e.zam_numer = z.zam_numer
	AND prod_id = 'RGAN01';

-- Złączenia zawnętrzne - outer join
SELECT Klienci.kl_id, Zamowienia.zam_numer
FROM Klienci
INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id;

SELECT Klienci.kl_id, Zamowienia.zam_numer
FROM Klienci
LEFT OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id;

SELECT Klienci.kl_id, Zamowienia.zam_numer
FROM Klienci
RIGHT OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id;

SELECT Klienci.kl_id, Zamowienia.zam_numer
FROM Klienci
FULL OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id;

-- Złączenia i funkcje agregujące - aggregate functions
SELECT Klienci.kl_id, COUNT(Zamowienia.zam_numer) AS liczbs_zam
FROM Klienci
INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
GROUP BY Klienci.kl_id;

SELECT Klienci.kl_id, COUNT(Zamowienia.zam_numer) AS liczbs_zam
FROM Klienci
LEFT OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
GROUP BY Klienci.kl_id;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 14 / Chapter 14 
--Łączenie zapytań / Combining Queries
--------------------------------------------------------------------------------------------------------------------------

-- Stosowanie operatora UNION - Using the UNION operator
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_woj IN ('MAL', 'MAZ', 'WKP');

SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_nazwa = 'Zabawa dla wszystkich';

SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_woj IN ('MAL', 'MAZ', 'WKP')
UNION
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_nazwa = 'Zabawa dla wszystkich';

SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_woj IN ('MAL', 'MAZ', 'WKP')
	OR kl_nazwa = 'Zabawa dla wszystkich';

-- Dołączanie lub eliminowanie zdublowanych wierszy - Include or eliminate duplicate rows
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_woj IN ('MAL', 'MAZ', 'WKP')
UNION ALL
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_nazwa = 'Zabawa dla wszystkich';

-- Sortowanie zwróconych połączonych wyników - sorting union
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_woj IN ('MAL', 'MAZ', 'WKP')
UNION
SELECT kl_nazwa, kl_kontakt, kl_email
FROM Klienci
WHERE kl_nazwa = 'Zabawa dla wszystkich'
ORDER BY kl_nazwa, kl_kontakt;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 15 / Chapter 15 
--Wstawianie danych / Inserting Data
--------------------------------------------------------------------------------------------------------------------------

-- Wstawianie całych wierszy - insert complete rows
INSERT INTO Klienci
VALUES('1000000006',
       'Zabawkolandia',
       '1Miodowa 12',
       'Katowice',
       'SLK',
       '41-200',
       'Polska',
       NULL,
       NULL);

INSERT INTO Klienci(kl_id,
                      kl_nazwa,
                      kl_adres,
                      kl_miasto,
                      kl_woj,
                      kl_kod,
                      kl_kraj,
                      kl_kontakt,
                      kl_email)
VALUES('1000000006',
       'Zabawkolandia',
       '1Miodowa 12',
       'Katowice',
       'SLK',
       '41-200',
       'Polska',
       NULL,
       NULL);

-- Wstawianie niepełnych wierszy - insert partial rows
INSERT INTO Klienci(kl_id,
                      kl_nazwa,
                      kl_adres,
                      kl_miasto,
                      kl_woj,
                      kl_kod,
                      kl_kraj)
VALUES('1000000006',
       'Zabawkolandia',
       '1Miodowa 12',
       'Katowice',
       'SLK',
       '41-200',
       'Polska');

-- Wstawianie pobranych danych - insert select
INSERT INTO Klienci(kl_id,
                      kl_nazwa,
                      kl_adres,
                      kl_miasto,
                      kl_woj,
                      kl_kod,
                      kl_kraj)
VALUES kl_id,
       kl_nazwa,
       kl_adres,
       kl_miasto,
       kl_woj,
       kl_kod,
       kl_kraj
FROM KlienciNowi;

-- Kopiowanie z jednej tabeli do innej - copying a table
SELECT * INTO KopiaKlienci FROM Klienci;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 16 / Chapter 16 
--Aktualizacja i usuwanie danych / Updating and Deleting Data
--------------------------------------------------------------------------------------------------------------------------

-- Aktualizacja jednej kolumny - update single column
UPDATE Klienci
SET kl_email = 'ms@skladzabawek.pl'
WHERE kl_id = '1000000005';

-- Aktualizacja większej liczby kolumn - update multiple columns
UPDATE Klienci
SET kl_kontakt = 'Marek Zatorowski',
	kl_email = 'ms@skladzabawek.pl'
WHERE kl_id = '1000000006';

-- Usuwanie jednego wiersza - delete single row
DELETE FROM Klienci
WHERE kl_id = '1000000006';

--------------------------------------------------------------------------------------------------------------------------
--rozdzial 17 / Chapter 17 
--Tworzenie i aktualizacja tabel / Creating and Manipulating Tables
--------------------------------------------------------------------------------------------------------------------------

-- Tworzenie prostej tabeli - Create a simple table
CREATE TABLE Produkty
(
  prod_id     char(10)      NOT NULL ,
  dost_id     char(10)      NOT NULL ,
  prod_nazwa  char(255)     NOT NULL ,
  prod_cena   decimal(8,2)  NOT NULL ,
  prod_opis   varchar(1000) NULL 
);

-- Podawanie wartości domyślnych -  Providing default values
CREATE TABLE ElementyZamowienia
(
  zam_numer  	int          NOT NULL ,
  zam_element 	int          NOT NULL ,
  prod_id    	char(10)	 NOT NULL ,
  ilosc 		int          NOT NULL  DEFAULT 1,
  cena_elem 	decimal(8,2) NOT NULL 
);

-- Aktualizacja tabel - Updating the tables
ALTER TABLE Dostawcy
ADD dost_telefon CHAR(20);

ALTER TABLE Dostawcy
DROP COLUMN dost_telefon;

-- Usuwanie tabel - Deleting tables
DROP TABLE KopiaKlienci;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 18 / Chapter 18 
--Stosowanie perspektyw / Using Views
--------------------------------------------------------------------------------------------------------------------------

-- Perspektywy - Views
SELECT kl_nazwa, kl_kontakt
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
	AND ElementyZamowienia.zam_numer = Zamowienia.zam_numer
	AND prod_id = 'RGAN01';

CREATE VIEW ProduktyKlientow AS
SELECT kl_nazwa, kl_kontakt, prod_id
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
	AND ElementyZamowienia.zam_numer = Zamowienia.zam_numer;

SELECT kl_nazwa, kl_kontakt
FROM ProduktyKlientow
WHERE prod_id = 'RGAN01';

--Formatowanie zwracanych danych za pomocą perspektyw - Formatting the returned data with views

SELECT RTRIM(dost_nazwa) + ' ('+RTRIM(dost_kraj) + ')' AS dost_tytul
FROM Dostawcy
ORDER BY dost_nazwa;

CREATE VIEW LokalizacjeKlientow AS
SELECT RTRIM(dost_nazwa) + ' ('+RTRIM(dost_kraj) + ')' AS dost_tytul
FROM Dostawcy;

-- Użycie perspektywy do filtrowania niechcianych danych - Use a view to filter out unwanted data
CREATE VIEW AdresyEmailKlientow AS
SELECT kl_id, kl_nazwa, kl_email
FROM Klienci
WHERE kl_email IS NOT NULL;

-- Perspektywy z polami obliczanymi - Views with calculated fields
SELECT prod_id, ilosc, cena_elem, ilosc * cena_elem AS wartosc
FROM ElementyZamowienia
WHERE zam_numer = 20008;

CREATE VIEW WartoscElementowZamowienia AS
SELECT zam_numer, 
	prod_id, 
	ilosc, 
	cena_elem, 
	ilosc * cena_elem AS wartosc
FROM ElementyZamowienia;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 19 / Chapter 19
--Korzystanie z procedur składowanych / Using Views
--------------------------------------------------------------------------------------------------------------------------

--Yworzenie procedur - create procedure
CREATE PROCEDURE ZliczenieListyMailingowej
AS
DECLARE @cnt INTEGER
SELECT @cnt = COUNT(*)
FROM klienci
WHERE NOT kl_email IS NULL;
RETURN @cnt;

DECLARE @ReturnValue INT
EXECUTE @ReturnValue=ZliczenieListyMailingowej;
SELECT @ReturnValue;

-- kolejny przyklad - next example
CREATE PROCEDURE NoweZamowienie @kl_id CHAR(10)
AS
-- \deklarowanie zmiennej dla numeru zamówienia - Declare variable for order number
DECLARE @zam_numer INTEGER
-- Pobranie największego numeru zamówienia - Get current highest order number
SELECT @zam_numer=MAX(zam_numer)
FROM Zamowienia
-- Określenie następnego numeru zamówienia - Determine next order number
SELECT @zam_numer=@zam_numer+1
-- Wstawianie nowego zamówienia - Insert new order
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(@zam_numer, GETDATE(), @kl_id)
-- Zwrócenie numeru zamówienia -  Return order number
RETURN @zam_numer;

DECLARE @ReturnValue INT
EXECUTE @ReturnValue=NoweZamowienie '1000000005'
SELECT @ReturnValue;

--------------------------------------------------------------------------------------------------------------------------
--Rozdzial 20 / Chapter 20
--Zarządzanie transakcjami / Managing Transaction Processing
--------------------------------------------------------------------------------------------------------------------------

BEGIN TRANSACTION
INSERT INTO Klienci(kl_id, kl_nazwa)
VALUES('1000000010', 'Imperium zabawek');
SAVE TRANSACTION PoczZamowienia;
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20100,'2001/12/1','1000000010');
IF @@ERROR <> 0 ROLLBACK TRANSACTION PoczZamowienia;
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20100, 1, 'BR01', 100, 5.49);
IF @@ERROR <> 0 ROLLBACK TRANSACTION PoczZamowienia;
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20100, 2, 'BR03', 100, 10.99);
IF @@ERROR <> 0 ROLLBACK TRANSACTION PoczZamowienia;
COMMIT TRANSACTION
