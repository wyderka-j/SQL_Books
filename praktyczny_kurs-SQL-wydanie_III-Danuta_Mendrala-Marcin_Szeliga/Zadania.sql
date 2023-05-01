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

------------------------------
-- Rozdział 5
------------------------------

-- 1. Odczytaj alfabetycznie uporzadkowaną listę nazw produktów sprzedawanych kiedykolwiek klientom o imieniu Jeffrey.

SELECT DISTINCT P.Name
FROM SalesLT.Product AS P
JOIN SalesLT.SalesOrderDetail AS OD
	ON P.ProductID=OD.ProductID
JOIN SalesLT.SalesOrderHeader AS OH
	ON OD.SalesOrderID=OH.SalesOrderID
JOIN SalesLT.Customer AS C
	ON C.CustomerID=OH.CustomerID
WHERE C.FirstName = 'Jeffrey';

-- 2. Odczytaj imiona i nazwiska klientów, którzy nie złożyli ani jednego zamówienia.

SELECT FirstName, LastName
FROM SalesLT.Customer AS C
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS OH
	ON C.CustomerID = OH.CustomerID
WHERE OH.CustomerID IS NULL;

--3. Bez używania funkcji CASE napisz zapytanie zwracające numer zamówienia (kolumna [SalesOrderID]), wysokość opłaty (kolumna [Freight]) i wyraz High lub Low, 
-- przy czym za kosztowne uznaj te zamówienia, których wartość opłaty przekracza 100, a pozostałe oceń jako małe. 

SELECT SalesOrderID, Freight, 'High'
FROM SalesLT.SalesOrderHeader 
WHERE Freight > 100
UNION ALL
SELECT SalesOrderID, Freight, 'Low' 
FROM SalesLT.SalesOrderHeader 
WHERE Freight <= 100;

------------------------------
-- Rozdział 6
------------------------------

-- 1. Odczytaj z tabeli [SalesLT].[SalesOrderHeader] wartości zamówień o najwyższych opłatach za wysyłkę zrealizowanych w każdym dniu dla poszczególnych klientów.

SELECT OrderDate, CustomerID, MAX(Freight)
FROM SalesLT.SalesOrderHeader
GROUP BY OrderDate, CustomerID;

-- 2. Odczytaj nazwy produktów, które zostały sprzedane więcej niż trzy razy. Dadaj do wyniku liczbę tych produktów.

SELECT Name, COUNT(P.ProductID)
FROM SalesLT.Product AS P
JOIN SalesLT.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID
GROUP BY Name
HAVING COUNT(P.ProductID) > 3;

-- 3. Uruchom poniższy skrypt tworzący tabelę tymczasową i wstawiający do niej dane u numerach wybranych klientów, miesiącach złożenia przez nich zamówień i 
--	wartościach poszczególnych zamówień:
--				CREATE TABLE #Sprzedaz
--				([ID klienta] INT NOT NULL,
--				Miesiac INT NOT NULL,
--				Wartosc MONEY NOT NULL);
--				Go
--				INSERT INTO #Sprzedaz
--				SELECT [CustomerID], DATEPART(MONTH, [OrderDate]), [TotalDue]
--				FROM [SalesLT].[SalesOrderHeader];
--				Go

SELECT *
FROM #Sprzedaz
PIVOT (SUM(Wartosc) 
FOR Miesiac IN ([4], [6])) 
AS Piv;

------------------------------
-- Rozdział 7
------------------------------

-- 1. Policz, ile razy sprzedany został każdy produkt, a następnie ponumeruj wiersze wyniku tego zapytania na dwa sposoby: w jednej kolumnie umieść numery od jednego
-- (najczęściej sprzedawany produkt) do ostatniego na podstawie pozycji wiersza z danym produktem, w drugiej wstaw numery na podstawie liczby sprzedaży danego towaru
-- (towary sprzedane tyle samo razy powinny mieć taki sam numer). Częściowy wynik pokazany został poniżej:
--					ProductNumber	SalesCount	(No column name)	(No column name)
--					LJ-0192-L		10			1			1
--					VE-C304-S		10			2			1
--					SJ-0194-X		9			3			2
--					CA-1098			9			4			2
--					SJ-0194-L		8			5			3
--					RA-H123			8			6			3

SELECT ProductNumber, COUNT(P.ProductID) AS SalesCount, 
	ROW_NUMBER() OVER (ORDER BY COUNT(P.ProductID) DESC), 
	DENSE_RANK() OVER (ORDER BY COUNT(P.ProductID) DESC)
FROM SalesLT.Product AS P
JOIN SalesLT.SalesOrderDetail AS SOD 
	ON P.ProductID = SOD.ProductID
GROUP BY ProductNumber;

-- 2. Policz sumę zamówień na poziomie dni, miesięcy i lat dat zapłaty za poszczególne zamówienia (wartości kolumny DueDate). Dadaj też do zapytania sumę wartości 
-- wszystkich zamówień. Częściowy wynik pokazany został poniżej:
--				year	month	day	SalesPerDay	SalesPerMonth	SalesPerYear	OverallSales
--				2008	7	16	1170,5376	751225,2685	956303,5949	1157312,3799
--				2008	7	17	2361,6403	751225,2685	956303,5949	1157312,3799
--				2008	7	18	70742,0359	751225,2685	956303,5949	157312,3799
--				2008	7	18	70742,0359	751225,2685	956303,5949	1157312,3799
--				2008	8	7	101811,538	111088,344	956303,5949	1157312,3799
--				2008	8	7	101811,538	111088,344	956303,5949	1157312,3799

SELECT YEAR(DueDate) AS year, MONTH(DueDate) AS month, DAY(DueDate) AS day, 
	SUM(TotalDue) OVER (PARTITION BY DAY(DueDate)) AS SalesPerDay, 
	SUM(TotalDue) OVER (PARTITION BY MONTH(DueDate)) AS SalesPerMonth, 
	SUM(TotalDue) OVER (PARTITION BY YEAR(DueDate)) AS SalesPerYear, 
	SUM(TotalDue) OVER () AS OverallSales
FROM SalesLT.SalesOrderHeader;

-- 3. Policz różnicę wartości pomiędzy dwoma kolejnymi zamówieniami (przyjmij, że kolejność zamówień wyznaczana jest przez wartość SalesOrderID). Częściowy wynik 
-- pokazany został poniżej:
--					SalesOrderID	TotalDue	(No column name)
--					71774		972,785		NULL
--					71776		87,0851		-885,6999
--					71780		42452,6519	42365,5668
--					71782		43962,7901	1510,1382

SELECT SalesOrderID, TotalDue, 
	TotalDue - LAG(TotalDue) OVER (ORDER BY SalesOrderID)
FROM SalesLT.SalesOrderHeader;

------------------------------
-- Rozdział 8
------------------------------

-- 1. Odczytaj za pomocą podzapytania numery zamówień złożonych przez klienta o nazwisku Eminhizer.

SELECT SalesOrderID
FROM SalesLT.SalesOrderHeader AS OH
WHERE OH.CustomerID IN (SELECT CustomerID FROM SalesLT.Customer WHERE LastName = 'Eminhizer');

-- 2. Klauzula TOP pozwala odczytać określoną liczbę wierszy, ale zaczynając zawsze od pierszego lub ostatniego. Chociaż serwer SQL umożliwia określenie nie tylko liczby 
--    wierszy, lecz także pozycji pierwszego zaklasyfikowanego wiersza, to niektóre serwery nie mają takiej funkcjonalmości. Zadanie polega na odczytaniu przy użyciu 
--    niepowiązanego podzapytania, ale bez klauzuli OVER, wartości pięciu zamówień posortowanych według ich wartosci i zwróceniu zamówień znajdujących się na pozycjach od 
--    10. do 15.

SELECT TOP 5 SalesOrderID, TotalDue
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID NOT IN (SELECT TOP 10 SalesOrderID FROM SalesLT.SalesOrderHeader ORDER BY TotalDue DESC)
ORDER BY TotalDue DESC;

-- 3. Odczytaj numery (kolumna SalesOrderID), daty zapłaty (kolumna DueDate) i numery klientów (kolumna CustomerID) dla zamówień złożonych ostatniego roboczego dnia każdego
--    miesiąca.
--    Podpowiedź: ponieważ ostatni roboczy dień może być inny dla poszczególnych miesięcy, użyj podzapytania niepowiązanego zwracającego ostatnią (największą datę złożenia 
--    zamówienia w każdym miesiącu).

SELECT SalesOrderID, DueDate, CustomerID
FROM SalesLT.SalesOrderHeader
WHERE OrderDate IN (SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader GROUP BY YEAR(OrderDate), MONTH(OrderDate));

------------------------------
-- Rozdział 9
------------------------------

-- 1. Poniższe zapytanie zwracające nazwy produktów i kategorii działa zbyt wolno. Jak można poprawić jego wydajność?
--					SELECT Name
--					FROM SalesLT.Product
--					UNION 
--					SELECT Name
--					FROM SalesLT.ProductCategory

-- Wydajność możemy poprawić poprzez zastosowanie operatora UNION ALL
SELECT Name
FROM SalesLT.Product
UNION ALL
SELECT Name
FROM SalesLT.ProductCategory;

-- 2. Wykonanie poniższego zapytania wymaga przeskanowania (odczytania w całości) indeksu założonego na kolumnie UnitPrice. Przepisz to zapytanie tak, żeby używało argumentu
--    typu SARG.
--					SELECT SalesOrderID
--					FROM SalesLT.SalesOrderDetail
--					WHERE UnitPrice*.77 > 900;

SELECT SalesOrderID
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 900 / 0.77;

-- 3. Znajdź optymalny indeks dla poniższego zapytania:
--					SELECT DueDate, SalesOrderID, TotalDue,
--					LAG(TotalDue) OVER (PARTITION BY DueDate ORDER BY DueDate) AS PreviousTotalDue
--					FROM SalesLT.SalesOrderHeader
--					OEDER BY DueDate;

CREATE INDEX IX_SalesOrderHeader_DueDate
ON SalesLT.SalesOrderHeader (DueDate)		
INCLUDE (SalesOrderID, TotalDue);

------------------------------
-- Rozdział 10
------------------------------

-- 1. Przeceń o 25% wszystkie produkty z kategorii Forks, jednocześnie zwiększając ich koszt standardowy o dwie jednostki.

UPDATE SalesLT.Product
SET ListPrice *= 0.75, StandardCost += 2
FROM SalesLT.ProductCategory AS C
WHERE C.ProductCategoryID = SalesLT.Product.ProductCategoryID AND C.Name = 'Forks';

-- 2. Utwórz tabelę Panie zawierającą identyfikatory, imiona i nazwiska wszystkich klientek firmy AdventureWorks. Przyjmij, że tylko imiona pań kończą się na literę a.

SELECT CustomerID, FirstName, LastName
INTO Panie
FROM SalesLT.Customer
WHERE RIGHT(FirstName, 1) = 'a';

-- 3. Wykonaj poniższe instrukcje modyfikujące dane w utworzonej w poprzednim zadaniu tabeli Panie, a następnie zsynchronizuj zawartość tej tabeli z danymi pań odczytanymi z
--    tabeli [SalesLT].[Customer]:
--					DELETE FROM Panie
--					WHERE [CustomerID] < 50;
--
--					UPDATE Panie
--					SET [FirstName]='X'
--					WHERE [CustomerID]%2=1;
--
--					INSERT INTO Panie ([FirstName], [LastName])
--					VALUES ('Ala', 'Nowak');

WITH Klientki AS
(SELECT CustomerID, FirstName, LastName 
FROM SalesLT.Customer 
WHERE RIGHT(FirstName, 1) = 'a')
MERGE INTO Panie AS C
USING Klientki AS K 
ON C.CustomerID = K.CustomerID
WHEN MATCHED AND C.FirstName <> K.FirstName THEN 
   UPDATE
   SET C.FirstName = K.FirstName
WHEN NOT MATCHED THEN
   INSERT (FirstName, LastName)
   VALUES (K.FirstName, K.LastName)
WHEN NOT MATCHED BY SOURCE THEN
   DELETE;


------------------------------
-- Rozdział 11
------------------------------

-- 1. Twoim zadaniem jest przygotowanie raportu podsumowującego roczną sprzedaż. Wyliczając sumy i średnie wartośvi sprzedaży produktów, kilkaktrotnie musisz odczytać tabelę
--    SalesOrderDetail. Jak zagwarantujesz poprawność wyników raportu?

-- Poprawność wyników raportu można zagwarantować poprzez skopiowanie odpowiednich danych do nowych, osobnych tabel na których możemy pracować wydajniej.

-- 2. Po przerwie na lunch użytkownicy zgłaszają, żr próby dalszej pracy z bazą dancyh kończąsię chwilowym zawieszeniem proramu i wreszcie komunikatem błędu mówiącym, iż 
--    serwer bazodanowy jest niedostępny. Po sprawdzeniu okazuje się, że serwer i sieć działają normalnie, a baza nie została uszkodzona. Co jest najbardziej prowdopodobną
--    przyczyną problemu?

-- Najbardziej prawdopodobną przyczyną tego problemu jest program kliencki, który jawnie rozpoczął transakcję, jeszcze zanim użytkownik wprowadził wszystkie niezbędne dane
-- potrzebne do zakończenia transakcji.

-- 3. Wramach tworzonej procedury modyfikujesz jeden wiersz, informujący o wykonaniu wszystkich operacji, do tabeli znajdującej się w bazie donych na zdalnym serwerze.
--    Połączenie między serwerami jest mocno obciążone i zdarza się, że czas nawiązywania sesji i przesyłania dancyh pomiędzy serwerami wieloktrotnie się wydłuża. Co zrobić,
--    aby w przypadku zgłoszenia przez proceduję błędu braku połączenia ze zdalnym serwerem nie trzeba było ponownie wykonywać długotrwałych modyfikacji danych?

-- Aby rozwiązać ten problem, należy przed próbą połączenia się ze zdalnym serwerem zapisać stan transakcji za pomocą punktu przywracania.

------------------------------
-- Rozdział 12
------------------------------

-- 1. Na podstawie poniższych informacji utwórz tabelę i nałóż na nią wymagane ograniczenia:
--    Każda osoba musi podać imię i nazwisko oraz adres e-mail i numer telefonu. Większość osób mieszka w Katowicach. Wiek i płeć, tak jak nazwa miasta, są informacjami
--    pocjonalnymi. Osoby muszą się zarejestrować, podając niepowtarzalny 5-znakowy kod promocyjny.

CREATE TABLE Biegacze (
	ID INT PRIMARY KEY,
	Imię VARCHAR(30) NOT NULL,
	Nazwisko VARCHAR(45) NOT NULL,
	Email VARCHAR(75) NOT NULL,
	Telefon VARCHAR(15) NOT NULL,
	Kod CHAR(5) NOT NULL UNIQUE,
	Miasto VARCHAR(30) DEFAULT 'Katowice',
	Wiek TINYINT CHECK(Wiek BETWEEN 5 AND 105),
	Płeć CHAR(1) CHECK (Płeć IN ('K', 'M')));

-- 2. Zaimplementuj opracowany w rozdziale 1. projekt tabel, w których będzie można zapisywać informację o książkach i ich autorac, przy czym jeden aitor będzie mógł 
--    napisać wiele książek, a książka będzie mogła mieć kilku autorów:
--					Autorzy {IDAutora, Imię, Nazwisko}
--					Książki {IDKsiążki, Tytuł, DataWydania}
--					AutorzyKsiażki {IDAutra, IDKsiązki}

CREATE TABLE Autorzy (
   IDAutora INT IDENTITY PRIMARY KEY,
   Imię VARCHAR(30) NOT NULL,
   Nazwisko VARCHAR(45) NOT NULL);

CREATE TABLE Książki (
   IDKsiążki INT IDENTITY PRIMARY KEY,
   Tytuł VARCHAR(100) NOT NULL,
   DataWydania DATE NOT NULL);

CREATE TABLE AutorzyKsiążki (
   IDAutora INT REFERENCES Autorzy,
   IDKsiążki INT REFERENCES Książki);

-- 3. Kolega, któremu zlecono taką zmianę struktury bazy danych, aby możliwe było zapisywanie w niej informacji o modelach towarów, zaproponował poniższe rozwiązanie:
--					ALTER TABLE Produkcja.Towary
--					ADD Model VARCHAR(5) CONSTRAINT CK_TowaryModel CHECK (Model IN ('B1', 'A3', 'X54'));
--    Zakładając, że nazwa modelu musi być sprawdzana i odpowiadać jednej z zatwierdzonych nazw, jak wytłumaczysz koledze, że jego pomysł nie jest najlepszy? Znajdź też
--    właściwe rozwiązanie problemu.


-- Ten pomysł nie jest najlepszy, ponieważ zapisywanie na stałe listy poprawnych nazw modeli w ograniczeniu, może drastycznie wpłynąć na obniżenie wydajności bazy danych.
-- Stanie się tak kiedy będziemy chcieli zmienić listę zatwierdzonych modeli, wtedy wymagana będzie zmiana struktury tabeli.

CREATE TABLE Produkcja.Modele (
Nazwa VARCHAR(5) PRIMARY KEY);
INSERT INTO Produkcja.Modele 
VALUES ('BRAK!');
ALTER TABLE Produkcja.Towary
ADD Model VARCHAR(5) REFERENCES Produkcja.Modele;
UPDATE Produkcja.Towary
SET Model = 'BRAK!';
ALTER TABLE Produkcja.Towary
ALTER COLUMN Model VARCHAR(5) NOT NULL;
