--Rozdzia³ 2. Sortowanie wyników zapytañ

--2.1. Zwracanie wyników zapytañ posortowanych w okreœlonym porz¹dku
-- Problem: Chcemy wyœwietliæ nazwiska, stanowiska pracy i wysokoœæ wynagrodzeñ pracowników zatrudnionych w diesi¹tym dziale firmy. Dodatkowo chcemy, aby zbiór 
-- wynikowy by³ uporz¹dkowany wed³ug wysokoœci pensji pracowników (od najni¿szej do najwy¿szej). 

SELECT ename, job, sal
FROM EMP
WHERE deptno = 10
ORDER BY sal ASC;

--2.2. Sortowanie zbioru wynikowego wed³ug zawartoœci wielu pól
--Problem: Chcemy posortowaæ wiersze tabeli emp- najpierw rosn¹co wed³ug numerów dzia³ów (deptno) a potem malej¹co wed³ug wynagrodzenia (sal).

SELECT empno, deptno, sal, ename, job
FROM EMP
ORDER BY DEPTNO, sal DESC;

--2.3. Sortowanie wed³ug pod³añcuchów
-- Problem: Chcemy posortowaæ zbiór wynikowy zwrócony przez zapytanie wed³ug okreœlonych fragmentów ³añcucha. Przyk³adowo chcemy, aby nazwiska pracowników i stanowiska
-- pracy zwrócone z tabeli emp by³y posortowane wed³ug ostatnich trzech znaków w kolumnie job.

SELECT ename, job
FROM emp
ORDER BY SUBSTRING(job, LEN(job) -2, 3);

--2.4. Sortowanie wymieszanych danych alfanumerycznych
-- Problem: Wymieszaliœmy w jednej kolumnie wynikowej ró¿ne dane alfanumeryczne i chcemy posortowaæ tê wspóln¹ kolumnê albo wed³ug czêœci liczbowej, albo wed³ug czêœci
-- znakowej. Przeanalizujmy nastêpuj¹cy widok:
-- create view V as 
-- select ename ||' '||deptno as data from emp
-- select * from V

--sortowanie wed³ug zawartoœci kolumny deptno
SELECT data
FROM V 
ORDER BY REPLACE(data,
		 REPLACE(
		 TRANSLATE(data, '0123456789', '##########'), '#', ''), '')

-- sortowanie wed³ug kolumny ename
SELECT data
FROM V 
ORDER BY REPLACE(
		 TRANSLATE(data, '0123456789', '##########'), '#', '')	

--2.5. Obs³uga wartoœci pustych w zapytaniach sortuj¹cych
-- Problem: Chcemy posortowaæ dane odczytane z tabeli emp wed³ug kolumny comm, która w czêœci wierszy zawiera wartoœæ NULL. Chodzi o to, by wiersze z wartoœci¹ NULL
-- znalaz³y siê na koñcu albo na pocz¹tku zbioru wynikowego.

-- wartoœci ró¿ne od NULL s¹ sortowane w porz¹dku rosn¹cym, wartoœci NULL umieszczane na koñcu zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null desc, comm;

-- wartoœci ró¿ne od NULL s¹ sortowane w porz¹dku malej¹cym, wartoœci NULL umieszczane na koñcu zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null desc, comm DESC;

-- wartoœci ró¿ne od NULL s¹ sortowane w porz¹dku rosn¹cym, wartoœci NULL umieszczane na pocz¹tku zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null, comm;

-- wartoœci ró¿ne od NULL s¹ sortowane w porz¹dku malej¹cym, wartoœci NULL umieszczane na pocz¹tku zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null, comm DESC;

--2.6. Sortowanie wed³ug klucza zale¿nego od danych
-- Problem: Chcemy posortowaæ zbiór wynikowy wed³ug logiki warunkowej. Przyk³adowo, jeœli dany rekord zawiera w kolumnie job wartoœæ salesman, chcemy, aby jego pozycja
-- w zbiorze wynikowym zale¿a³a od wartoœci sk³adowej w kolumnie comm (aby wynik sortowano wed³ug tej kolumny); w przeciwnym razie pozycja rekordu w zbiorze wynikowym 
-- powinna zale¿eæ od wartoœci w kolumnie sal.

SELECT ename, sal, job, comm
FROM emp
ORDER BY CASE WHEN job = 'SALESMAN'	 then comm ELSE sal END