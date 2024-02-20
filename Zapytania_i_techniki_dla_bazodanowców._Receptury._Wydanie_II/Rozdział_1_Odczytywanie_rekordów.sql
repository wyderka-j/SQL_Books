-- Mircosoft SQL Server

--Rozdzia³ 1. Odczytywanie rekordów
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--1.1. Odczytywanie wszystkich wierszy i kolumn tabeli
-- Chcemy zapoznaæ siê ze wszystkimi zawartymi danymi w tabeli
SELECT *
FROM emp;

--1.2. Odczytywanie podzbioru wierszy tabeli
-- Chcemy wyœwietliæ tylko te wiersze, które spe³niaj¹ okleœlony warunek
SELECT *
FROM emp
WHERE deptno =10;

--1.3. Odnajdywanie wierszy spe³niaj¹cych wiele warunków
-- Chcemy wyœwietliæ tylko te wiersze, które spe³niaj¹ kilka warunków
SELECT *
FROM emp
WHERE (deptno =10 OR comm IS NOT NULL OR sal <= 2000 )
	AND deptno =20;

--1.4. Odczytywanie podzbioru kolumn tabeli
-- Chcemy wyœwietliæ tylko okreœlone kolumny
SELECT ename, deptno, sal
FROM emp;

--1.5. Definiowanie sensownych nazw kolumn
-- Chcemy wyœwietliæ kolumny ze zmienionymi nazwami
SELECT sal AS salary, comm AS commission
FROM emp;

--1.6. Odwo³ania do aliasów kolumn w klauzuli WHERE
-- Chcemy odwo³aæ siê do kolumn reprezentowanych przez aliasy
SELECT *
FROM (
	SELECT sal AS salary, comm AS commission
	FROM emp) x
WHERE salary < 5000;

--1.7. Konkatenacja wartoœci kolumn
-- Chcemy zwróciæ wartoœci sk³adowane w wielu kolumnach w formie pojedynczej kolumny.
SELECT ename + ' works as a ' + job AS msg
FROM emp
WHERE deptno = 10;

--1.8. Stosowanie logiki warunkowej w wyra¿eniu SELECT
-- Chcemy uzyskaæ zbiór wynikowy, w którym kolumna Status bêdzie zawiera³a wartoœæ Underpaid dla pracowników zarabiaj¹cych mniej ni¿ 2000, wartoœæ Overpaid dla pracowników
-- zarabiaj¹cych powy¿ej 4000 lub wartoœæ OK dla pracowników, których zarobki mieszcz¹ siê pomiêdzy 2000 a 4000
SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'Underpaid'
		WHEN sal >= 4000 THEN 'Overpaid'
		ELSE 'OK'
	END AS status
FROM emp;

--1.9. Ograniczanie liczby zwracanych wierszy
-- Chcemy ograniczyæ liczbê wyœmietlanych wierszy
SELECT TOP 5 *
FROM emp;

--1.10. Zwracanie n losowych rekordów tabeli
-- Chcemy zwróciæ okreœlon¹ liczbê losowo wybranych rekordów
SELECT TOP 5 ename, job
FROM emp
ORDER BY newid();

--1.11. Odnajdywanie wartoœci pustych (NULL)
-- Chcemy odnaleŸæ wszystkie wiersze, które zawieraj¹ puste wartoœci w okreœlonej kolumnie
SELECT *
FROM emp
WHERE comm IS NULL;

--1.12. Przekszta³canie wartoœci pustych w rzeczywiste
-- Chcemy aby w miejsce pustej wartoœci zwracane by³y inne wartoœci
SELECT COALESCE(comm, 0)
FROM emp;

-- lub
SELECT CASE	
	WHEN comm IS NULL THEN 0
	ELSE comm
	END
FROM emp;

--1.13. Poszukiwanie wzorców
-- Chcemy aby zbiór wynikowy zawiera³ nazwiska i stanowiska pracy tylko tych pracowników dziesi¹tego i dwudziestego dzia³u, których nazwiska zawieraj¹ literê I lub których
-- nazwa stanowiska pracy koñczy siê liretami ER
SELECT ename, job
FROM emp
WHERE deptno IN (10, 20)
	AND (ename LIKE '%I%' OR job LIKE '%er');