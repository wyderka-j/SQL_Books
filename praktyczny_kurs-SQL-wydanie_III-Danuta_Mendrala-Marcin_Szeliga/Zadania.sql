 --Zadania zostawy wykonane przy użyciu Microsoft SQL Server
 
 ------------------------------
-- Zadania 
------------------------------

------------------------------
-- Rozdział 1
------------------------------
 
-- 1.Wyodrębnij kolumny, które zgodnie z definicją 3PN, powinny być przeniesione do tabel słownikowych.
-- Płyty {ID płyty, Nazwa wykonawcy, Nazwa gatunku, Czas trwania, Opinia, Narodowość wykonawcy}

 /*
 Rozwiązanie
 Płyty {ID Płyty, ID Wykonawcy, ID Gatunku, Czas trwania, Opinia}
 Wykonawcy {ID Wykonawcy, Nazwa wykonawcy, ID Kraju }
 Gatunki { ID Gatunku, nNazwa gatunku}
 Kraje {ID kraju, Nazwa kraju}
 */

-- 2. Jak przekształcić poniższe tabele, aby każda książka mogła mieć dowolnie wielu autorów, a każdy autor mógł napisać dowolną liczbę książek?
-- Autorzy {ID autora, Imię, Nazwisko}
-- Książki {ID książki, Tytuł, ID autora1, IDautora2, IDautora3}

 /*
 Autorzy {ID autora, Imię, Nazwisko}
 Książki (ID książki, Tytuł}
 AutorKsiażka {ID autora, ID książki}
 */ 

-- 3. Doprowadź poniższą tabelę kolejno do pierszej, drugiej i trzeciej postaci normalnej.
-- Uczniowie {Imię, Nazwisko, Adres, Ocena, Data wystawienia oceny, Uwagi}

 /*
 1PN
 Uczniowie {Uczeń ID, Imię, Nazwisko, Miasto, Kod pocztowy, Ulica i nr domu, Ocena, Data wystawienia oceny, Uwagi}

 2PN
 Uczniowie {Uczeń ID, Imię, Nazwisko, Adres ID, Ocena, Data wystawienia oceny, Uwagi}
 Adresy {Adres ID, Miasto, Kod pocztowy, Ulica i nr domu}

 3PN
 Uczniowie {Uczeń ID, Imię, Nazwisko, Adres ID, Uwagi}
 Oceny {Ocena ID, Ocena}
 UczniowieOceny {Uczeń ID, Ocena ID, Data wystawienia oceny}
 Adresy {Adres ID, Miasto, Kod pocztowy, Ulica i nr domu} 
 */
 
------------------------------
-- Rozdział 2
------------------------------

-- 1. Zaimplementuj w jęzuku SQL poniższy, zapisany w pseudokodzie, algorytm przeszukiwania tabeli:
--	a) Odczyta wiersz tabeli Customer
--	b) Sprawdź, czy w kolumnie LasName znajduje się wartość Kumar
--	c) Jeśli tak, skopiuj wiersz do tabeli tymczasowej
--	d) Sprawdź, czy tabela zawiera dalsze wiersze:
--		- Jeżeli tak, powtórz poprzednie kroki
--		- Jeżeli nie, zwróć użytkownikowi zawartość tabeli tymczasowej

SELECT *
FROM Customer
WHERE LastName = 'Kumar'

-- 2. Czy potrafisz bez wykonywania poniższych instrukcji powiedzieć, jakie będą ich wyniki?
		SELECT 1
		WHERE NOT NULL = - NULL;
--
		SELECT 1 + '1' +NULL;

--Tak. 
--Pierwsze zapytanie nie zwróci żadnych danych, ponieważ wartość NULL nie jest ani równa innym wartościom, ani od nich różna, w tym od siebie samej. 
-- Wynikiem porównań z wartościąNULL jest wartość nieznana.

--Drugie natomiast zwróci wartość NULL, ponieważ winikiem dowolnej operacji z wartością NULL, w tym dodawania i łączenia ciągów znaków jest NULL.

-- 3. Czy to, że SQL jest językiem interpretowanym, a serwer bazodanowy wykona każdą poprawną instrukcję przysłaną przez użytkownika, może mieć wpływ na bazpieczeństwo?
--	Uzasadnij swoją odpowiedź, podając przykład.

--Tak. Jako przykład można podać metodę ataku SQL Injection.
 
------------------------------
-- Rozdział 3
------------------------------

-- 1. Odczytaj z tabeli [SalesLT].[Product] nazwy towarów (kolumna [Name]), oraz powiększone o 20% ich ceny katalogowe (oblicz je na podstawie dancyh z kolumny 
--	[ListPrice]).

SELECT Name, ListPrice * 1.2
FROM SalesLT.Product

-- 2. Oblicz, ile dni upłynęło pomiędzy złożeniem  zamówienia a wysłaniem zrealizowanych zamówień (różnice między wartościami kolumn [ShpiDate] i [OrderDate] tabeli
--	[SalesLT].[SalesOrderHeader]).

SELECT SalesOrderID, DATEDIFF (DAY, OrderDate, ShipDate)
FROM SalesLT.SalesOrderHeader

-- 3. Wykorzystaj wiadomości z tego rozdziału, w tym opisane funkcje systemowe, do napisania zapytania, którego sktórony wynik został zamieszczony poniżej:
--			(No column name)			(No column name)		(No column name)
--			Produkt Touring-1000 Blue, 54		kosztuje				2384.10
--			Produkt Touring-1000 Blue, 54		kosztuje				2384.10
--			Produkt Mointain-200 Silver, 38		kosztuje				2320.00
--			Produkt Mointain-200 Silver, 38		kosztuje				2320.00
-- Podpowiedź: dane o produktach znajdują się w tabeli [SalesLT].[Product]/

SELECT 'Produkt ' + Name, 'kosztuje', ROUND(ListPrice, 1)
FROM SalesLT.Product
ORDER BY ListPrice DESC

-- 4. Odczytaj z tabeli [SalesLT].[SalesOrderHeader] ułożoną od najnowszych do najstarszych listę dat wszystkich zamówień. Wynik zapytania powinien mieć formę 
--	rok-miesiąc-dzień.
--			(No colum name)
--			2014-4-1
--			2008-6-1
--	W rozwiązaniu użyj funkcji YEAR(), MONTH() i DAY().

SELECT DISTINCT CAST(YEAR(OrderDate) AS CHAR(4)) + '-' + CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(DAY(OrderDate) AS VARCHAR(2))
FROM SalesLT.SalesOrderHeader
ORDER BY CAST(YEAR(OrderDate) AS CHAR(4)) + '-' + CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(DAY(OrderDate) AS VARCHAR(2)) DESC

-- 5. Odczytaj z tabeli [SalesLT].[Product] kolumny [ProductNumber] oraz [Size] i posortuj wynik rosnąco według wartości kolumny [Size], ale w taki sposób, żeby 
--	wartości NULL znalazły się na końcu, a nie na początku wyniku. 
--	Podpowiedź użyj funkcji CASE.

SELECT ProductNumber, Size
FROM SalesLT.Product
ORDER BY 
CASE
   WHEN Size IS NULL THEN 1
   ELSE 0
END, Size

------------------------------
-- Rozdział 4
------------------------------

-- 1. Odczytaj z tabeli [SalesLT].[Product] nazwy produktów, których koszt jest ponad dwukrotnie niższy od ceny, a ostatnim znakiem kodu towaru jest 4 lub 8.

SELECT Name, ProductNumber, ListPrice
FROM SalesLT.Product
WHERE StandardCost*2<ListPrice
AND (ProductNumber LIKE '%4' OR ProductNumber LIKE '%8');

-- 2 rozwiazanie
SELECT Name, ProductNumber, ListPrice
FROM SalesLT.Product
WHERE StandardCost*2<ListPrice AND RIGHT(ProductNumber,1) IN ('4','8');

-- 2. Z tabeli [SalesLT].[SalesOrderHeader] odczytaj numery (kolumna [SalesOrderID]) i wysokości opłat (kolumna [Freight]) 5% zamówień o najniższym koszcie wysyłki 
--	złożonych (kolumna [OrderDate]) w drugim półroczu 2008 roku.

SELECT TOP 5 PERCENT WITH TIES SalesOrderID, Freight
FROM SalesLT.SalesOrderHeader
WHERE OrderDate BETWEEN '20080701' AND '20081231'
ORDER BY Freight;

-- 3. Napisz zapytanie zwracające za każdym razem nazwę innego, losowo wybranego produktu.

SELECT TOP 1 Name
FROM SalesLT.Product
ORDER BY NEWID();
