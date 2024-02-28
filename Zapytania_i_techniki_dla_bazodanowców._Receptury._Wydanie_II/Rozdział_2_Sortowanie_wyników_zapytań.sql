--Rozdzia� 2. Sortowanie wynik�w zapyta�
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--2.1. Zwracanie wynik�w zapyta� posortowanych w okre�lonym porz�dku
-- Chcemy wy�wietli� nazwiska, stanowiska pracy i wysoko�� wynagrodze� pracownik�w zatrudnionych w dziesi�tym dziale. Dodatkowo chcemy, aby zbi�r wynikowy by� uporz�dkowany
-- wed�ug wysoko�ci pensji pracownik�w *od najni�szej do najwy�szej)

SELECT ename, job, sal
FROM emp
WHERE deptno = 10
ORDER BY sal;

--2.2. Sortowanie zbioru wynikowego wed�ug zawarto�ci wielu p�l
-- Chcemy posortowa� wiersze tabeli EMP - najpierw rosn�co wed�ug numer�w dzia��w a potem malej�co wed�ug wynagrodzenia

SELECT empno, deptno, sal, ename, job
FROM emp
ORDER BY deptno, sal DESC;

--2.3. Sortowanie wed�ug pod�a�cuch�w
-- Chcemy posortowa� zbi�r wynikowy zwr�cony przez zapytanie wed�ug okre�lonych fragment�w �a�cucha. Chcemy, aby nazwiska pracownik�w i stanowiska pracy zwr�cone z tabeli
-- by�y posortowane wed�ug ostatnich trzech znak�w w kolumnie job.

SELECT ename, job
FROM emp
ORDER BY SUBSTRING(job, LEN(job) -2, 3);

--2.4. Sortowanie wymieszanych danych alfanumerycznych
-- Wymieszali�my w jednej kolumnie wynikowej r�ne dane alfanumeryczne i chcemy posortowa� t� wsp�ln� kolumn� albo wed�ug cz�ci liczbowej, albo wed�ug cz�ci znakowej.
--CREATE VIEW V
--AS
--SELECT ename || ' ' || deptno AS data
--from emp;
--SELECT * FROM V;

-- sortowanie wed�ug zawarto�ci kolumny deptno
SELECT data
FROM V
ORDER BY REPLACE(data,
		REPLACE(
		TRANSLATE(data, '0123456789', '##########'), '#', ''), '');
-- sortowanie wed�ug zawarto�ci kolumny ename
SELECT data
FROM V
ORDER BY REPLACE(
		TRANSLATE(data, '0123456789', '##########'), '#', '');

--2.5. Obs�uga warto�ci pustych w zapytaniach sortuj�cych
-- Chcemy posortowa� dane odczytane z tabeli emp wed�ug zawarto�ci kolumny comm, kt�ra w cz�ci wierszy zawiera warto�� NULL.

-- NULL na ko�cu zbioru wynikowego a warto�c r�ne od NULL sortowane w porz�dku rosn�cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null DESC, comm;

-- NULL na ko�cu zbioru wynikowego a warto�c r�ne od NULL sortowane w porz�dku malej�cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null DESC, comm DESC;

-- NULL na pocz�tku zbioru wynikowego a warto�c r�ne od NULL sortowane w porz�dku rosn�cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null, comm;

-- NULL na pocz�tku zbioru wynikowego a warto�c r�ne od NULL sortowane w porz�dku malej�cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null, comm DESC;


--2.6. Sortowanie wed�ug klucza zale�nego od danych
-- Chcemy posortowa� zbi�r wynikowy wed�ug logiki warunkowej. Np. je�li dany rekord zawiera w kolumnie job warto�� Salesman, chcemy, aby jego pozycja w zbiorze wynikowym 
-- zale�a�a od warto�ci sk�adowanej w kolumnie comm, w przecziwnym razie pozycja rekordu w zbiorze wynikowym powinna zale�ej od warto�ci w kolumnie sal.

SELECT ename, sal, job, comm
FROM emp
ORDER BY CASE WHEN job = 'Salesman' THEN comm ELSE sal END;
