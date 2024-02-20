-- Mircosoft SQL Server

--Rozdział 1. Odczytywanie rekordów
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--1.1. Odczytywanie wszystkich wierszy i kolumn tabeli
-- Chcemy zapoznać się ze wszystkimi zawartymi danymi w tabeli
SELECT *
FROM emp;

--1.2. Odczytywanie podzbioru wierszy tabeli
-- Chcemy wyświetlić tylko te wiersze, które spełniają okleślony warunek
SELECT *
FROM emp
WHERE deptno =10;

--1.3. Odnajdywanie wierszy spełniających wiele warunków
-- Chcemy wyświetlić tylko te wiersze, które spełniają kilka warunków
SELECT *
FROM emp
WHERE (deptno =10 OR comm IS NOT NULL OR sal <= 2000 )
	AND deptno =20;

--1.4. Odczytywanie podzbioru kolumn tabeli
-- Chcemy wyświetlić tylko określone kolumny
SELECT ename, deptno, sal
FROM emp;

--1.5. Definiowanie sensownych nazw kolumn
-- Chcemy wyświetlić kolumny ze zmienionymi nazwami
SELECT sal AS salary, comm AS commission
FROM emp;

--1.6. Odwołania do aliasów kolumn w klauzuli WHERE
-- Chcemy odwołać się do kolumn reprezentowanych przez aliasy
SELECT *
FROM (
	SELECT sal AS salary, comm AS commission
	FROM emp) x
WHERE salary < 5000;

--1.7. Konkatenacja wartości kolumn
-- Chcemy zwrócić wartości składowane w wielu kolumnach w formie pojedynczej kolumny.
SELECT ename + ' works as a ' + job AS msg
FROM emp
WHERE deptno = 10;

--1.8. Stosowanie logiki warunkowej w wyrażeniu SELECT
-- Chcemy uzyskać zbiór wynikowy, w którym kolumna Status będzie zawierała wartość Underpaid dla pracowników zarabiających mniej niż 2000, wartość Overpaid dla
--  pracowników zarabiających powyżej 4000 lub wartość OK dla pracowników, których zarobki mieszczą się pomiędzy 2000 a 4000
SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'Underpaid'
		WHEN sal >= 4000 THEN 'Overpaid'
		ELSE 'OK'
	END AS status
FROM emp;

--1.9. Ograniczanie liczby zwracanych wierszy
-- Chcemy ograniczyć liczbę wyśmietlanych wierszy
SELECT TOP 5 *
FROM emp;

--1.10. Zwracanie n losowych rekordów tabeli
-- Chcemy zwrócić określoną liczbę losowo wybranych rekordów
SELECT TOP 5 ename, job
FROM emp
ORDER BY newid();

--1.11. Odnajdywanie wartości pustych (NULL)
-- Chcemy odnaleźć wszystkie wiersze, które zawierają puste wartości w określonej kolumnie
SELECT *
FROM emp
WHERE comm IS NULL;

--1.12. Przekształcanie wartości pustych w rzeczywiste
-- Chcemy aby w miejsce pustej wartości zwracane były inne wartości
SELECT COALESCE(comm, 0)
FROM emp;

-- lub
SELECT CASE	
	WHEN comm IS NULL THEN 0
	ELSE comm
	END
FROM emp;

--1.13. Poszukiwanie wzorców
-- Chcemy aby zbiór wynikowy zawierał nazwiska i stanowiska pracy tylko tych pracowników dziesiątego i dwudziestego działu, których nazwiska zawierają literę I lub 
-- których nazwa stanowiska pracy kończy się liretami ER
SELECT ename, job
FROM emp
WHERE deptno IN (10, 20)
	AND (ename LIKE '%I%' OR job LIKE '%er');
