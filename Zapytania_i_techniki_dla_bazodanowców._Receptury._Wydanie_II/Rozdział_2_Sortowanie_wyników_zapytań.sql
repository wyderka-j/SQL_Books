--Rozdzia³ 2. Sortowanie wyników zapytañ
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--2.1. Zwracanie wyników zapytañ posortowanych w okreœlonym porz¹dku
-- Chcemy wyœwietliæ nazwiska, stanowiska pracy i wysokoœæ wynagrodzeñ pracowników zatrudnionych w dziesi¹tym dziale. Dodatkowo chcemy, aby zbiór wynikowy by³ uporz¹dkowany
-- wed³ug wysokoœci pensji pracowników *od najni¿szej do najwy¿szej)

SELECT ename, job, sal
FROM emp
WHERE deptno = 10
ORDER BY sal;

--2.2. Sortowanie zbioru wynikowego wed³ug zawartoœci wielu pól
-- Chcemy posortowaæ wiersze tabeli EMP - najpierw rosn¹co wed³ug numerów dzia³ów a potem malej¹co wed³ug wynagrodzenia

SELECT empno, deptno, sal, ename, job
FROM emp
ORDER BY deptno, sal DESC;

--2.3. Sortowanie wed³ug pod³añcuchów
-- Chcemy posortowaæ zbiór wynikowy zwrócony przez zapytanie wed³ug okreœlonych fragmentów ³añcucha. Chcemy, aby nazwiska pracowników i stanowiska pracy zwrócone z tabeli
-- by³y posortowane wed³ug ostatnich trzech znaków w kolumnie job.

SELECT ename, job
FROM emp
ORDER BY SUBSTRING(job, LEN(job) -2, 3);

--2.4. Sortowanie wymieszanych danych alfanumerycznych
-- Wymieszaliœmy w jednej kolumnie wynikowej ró¿ne dane alfanumeryczne i chcemy posortowaæ tê wspóln¹ kolumnê albo wed³ug czêœci liczbowej, albo wed³ug czêœci znakowej.
--CREATE VIEW V
--AS
--SELECT ename || ' ' || deptno AS data
--from emp;
--SELECT * FROM V;

-- sortowanie wed³ug zawartoœci kolumny deptno
SELECT data
FROM V
ORDER BY REPLACE(data,
		REPLACE(
		TRANSLATE(data, '0123456789', '##########'), '#', ''), '');
-- sortowanie wed³ug zawartoœci kolumny ename
SELECT data
FROM V
ORDER BY REPLACE(
		TRANSLATE(data, '0123456789', '##########'), '#', '');

--2.5. Obs³uga wartoœci pustych w zapytaniach sortuj¹cych
-- Chcemy posortowaæ dane odczytane z tabeli emp wed³ug zawartoœci kolumny comm, która w czêœci wierszy zawiera wartoœæ NULL.

-- NULL na koñcu zbioru wynikowego a wartoœc ró¿ne od NULL sortowane w porz¹dku rosn¹cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null DESC, comm;

-- NULL na koñcu zbioru wynikowego a wartoœc ró¿ne od NULL sortowane w porz¹dku malej¹cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null DESC, comm DESC;

-- NULL na pocz¹tku zbioru wynikowego a wartoœc ró¿ne od NULL sortowane w porz¹dku rosn¹cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null, comm;

-- NULL na pocz¹tku zbioru wynikowego a wartoœc ró¿ne od NULL sortowane w porz¹dku malej¹cym
SELECT ename, sal, comm
FROM (
	SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp) x
ORDER BY is_null, comm DESC;


--2.6. Sortowanie wed³ug klucza zale¿nego od danych
-- Chcemy posortowaæ zbiór wynikowy wed³ug logiki warunkowej. Np. jeœli dany rekord zawiera w kolumnie job wartoœæ Salesman, chcemy, aby jego pozycja w zbiorze wynikowym 
-- zale¿a³a od wartoœci sk³adowanej w kolumnie comm, w przecziwnym razie pozycja rekordu w zbiorze wynikowym powinna zale¿ej od wartoœci w kolumnie sal.

SELECT ename, sal, job, comm
FROM emp
ORDER BY CASE WHEN job = 'Salesman' THEN comm ELSE sal END;
