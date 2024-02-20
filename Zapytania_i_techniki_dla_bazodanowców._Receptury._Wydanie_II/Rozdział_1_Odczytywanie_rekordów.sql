-- Mircosoft SQL Server

--Rozdzia� 1. Odczytywanie rekord�w
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--1.1. Odczytywanie wszystkich wierszy i kolumn tabeli
-- Chcemy zapozna� si� ze wszystkimi zawartymi danymi w tabeli
SELECT *
FROM emp;

--1.2. Odczytywanie podzbioru wierszy tabeli
-- Chcemy wy�wietli� tylko te wiersze, kt�re spe�niaj� okle�lony warunek
SELECT *
FROM emp
WHERE deptno =10;

--1.3. Odnajdywanie wierszy spe�niaj�cych wiele warunk�w
-- Chcemy wy�wietli� tylko te wiersze, kt�re spe�niaj� kilka warunk�w
SELECT *
FROM emp
WHERE (deptno =10 OR comm IS NOT NULL OR sal <= 2000 )
	AND deptno =20;

--1.4. Odczytywanie podzbioru kolumn tabeli
-- Chcemy wy�wietli� tylko okre�lone kolumny
SELECT ename, deptno, sal
FROM emp;

--1.5. Definiowanie sensownych nazw kolumn
-- Chcemy wy�wietli� kolumny ze zmienionymi nazwami
SELECT sal AS salary, comm AS commission
FROM emp;

--1.6. Odwo�ania do alias�w kolumn w klauzuli WHERE
-- Chcemy odwo�a� si� do kolumn reprezentowanych przez aliasy
SELECT *
FROM (
	SELECT sal AS salary, comm AS commission
	FROM emp) x
WHERE salary < 5000;

--1.7. Konkatenacja warto�ci kolumn
-- Chcemy zwr�ci� warto�ci sk�adowane w wielu kolumnach w formie pojedynczej kolumny.
SELECT ename + ' works as a ' + job AS msg
FROM emp
WHERE deptno = 10;

--1.8. Stosowanie logiki warunkowej w wyra�eniu SELECT
-- Chcemy uzyska� zbi�r wynikowy, w kt�rym kolumna Status b�dzie zawiera�a warto�� Underpaid dla pracownik�w zarabiaj�cych mniej ni� 2000, warto�� Overpaid dla pracownik�w
-- zarabiaj�cych powy�ej 4000 lub warto�� OK dla pracownik�w, kt�rych zarobki mieszcz� si� pomi�dzy 2000 a 4000
SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'Underpaid'
		WHEN sal >= 4000 THEN 'Overpaid'
		ELSE 'OK'
	END AS status
FROM emp;

--1.9. Ograniczanie liczby zwracanych wierszy
-- Chcemy ograniczy� liczb� wy�mietlanych wierszy
SELECT TOP 5 *
FROM emp;

--1.10. Zwracanie n losowych rekord�w tabeli
-- Chcemy zwr�ci� okre�lon� liczb� losowo wybranych rekord�w
SELECT TOP 5 ename, job
FROM emp
ORDER BY newid();

--1.11. Odnajdywanie warto�ci pustych (NULL)
-- Chcemy odnale�� wszystkie wiersze, kt�re zawieraj� puste warto�ci w okre�lonej kolumnie
SELECT *
FROM emp
WHERE comm IS NULL;

--1.12. Przekszta�canie warto�ci pustych w rzeczywiste
-- Chcemy aby w miejsce pustej warto�ci zwracane by�y inne warto�ci
SELECT COALESCE(comm, 0)
FROM emp;

-- lub
SELECT CASE	
	WHEN comm IS NULL THEN 0
	ELSE comm
	END
FROM emp;

--1.13. Poszukiwanie wzorc�w
-- Chcemy aby zbi�r wynikowy zawiera� nazwiska i stanowiska pracy tylko tych pracownik�w dziesi�tego i dwudziestego dzia�u, kt�rych nazwiska zawieraj� liter� I lub kt�rych
-- nazwa stanowiska pracy ko�czy si� liretami ER
SELECT ename, job
FROM emp
WHERE deptno IN (10, 20)
	AND (ename LIKE '%I%' OR job LIKE '%er');