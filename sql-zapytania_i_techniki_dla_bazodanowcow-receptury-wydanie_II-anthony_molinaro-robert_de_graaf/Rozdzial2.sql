--Rozdzia� 2. Sortowanie wynik�w zapyta�

--2.1. Zwracanie wynik�w zapyta� posortowanych w okre�lonym porz�dku
-- Problem: Chcemy wy�wietli� nazwiska, stanowiska pracy i wysoko�� wynagrodze� pracownik�w zatrudnionych w diesi�tym dziale firmy. Dodatkowo chcemy, aby zbi�r 
-- wynikowy by� uporz�dkowany wed�ug wysoko�ci pensji pracownik�w (od najni�szej do najwy�szej). 

SELECT ename, job, sal
FROM EMP
WHERE deptno = 10
ORDER BY sal ASC;

--2.2. Sortowanie zbioru wynikowego wed�ug zawarto�ci wielu p�l
--Problem: Chcemy posortowa� wiersze tabeli emp- najpierw rosn�co wed�ug numer�w dzia��w (deptno) a potem malej�co wed�ug wynagrodzenia (sal).

SELECT empno, deptno, sal, ename, job
FROM EMP
ORDER BY DEPTNO, sal DESC;

--2.3. Sortowanie wed�ug pod�a�cuch�w
-- Problem: Chcemy posortowa� zbi�r wynikowy zwr�cony przez zapytanie wed�ug okre�lonych fragment�w �a�cucha. Przyk�adowo chcemy, aby nazwiska pracownik�w i stanowiska
-- pracy zwr�cone z tabeli emp by�y posortowane wed�ug ostatnich trzech znak�w w kolumnie job.

SELECT ename, job
FROM emp
ORDER BY SUBSTRING(job, LEN(job) -2, 3);

--2.4. Sortowanie wymieszanych danych alfanumerycznych
-- Problem: Wymieszali�my w jednej kolumnie wynikowej r�ne dane alfanumeryczne i chcemy posortowa� t� wsp�ln� kolumn� albo wed�ug cz�ci liczbowej, albo wed�ug cz�ci
-- znakowej. Przeanalizujmy nast�puj�cy widok:
-- create view V as 
-- select ename ||' '||deptno as data from emp
-- select * from V

--sortowanie wed�ug zawarto�ci kolumny deptno
SELECT data
FROM V 
ORDER BY REPLACE(data,
		 REPLACE(
		 TRANSLATE(data, '0123456789', '##########'), '#', ''), '')

-- sortowanie wed�ug kolumny ename
SELECT data
FROM V 
ORDER BY REPLACE(
		 TRANSLATE(data, '0123456789', '##########'), '#', '')	

--2.5. Obs�uga warto�ci pustych w zapytaniach sortuj�cych
-- Problem: Chcemy posortowa� dane odczytane z tabeli emp wed�ug kolumny comm, kt�ra w cz�ci wierszy zawiera warto�� NULL. Chodzi o to, by wiersze z warto�ci� NULL
-- znalaz�y si� na ko�cu albo na pocz�tku zbioru wynikowego.

-- warto�ci r�ne od NULL s� sortowane w porz�dku rosn�cym, warto�ci NULL umieszczane na ko�cu zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null desc, comm;

-- warto�ci r�ne od NULL s� sortowane w porz�dku malej�cym, warto�ci NULL umieszczane na ko�cu zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null desc, comm DESC;

-- warto�ci r�ne od NULL s� sortowane w porz�dku rosn�cym, warto�ci NULL umieszczane na pocz�tku zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null, comm;

-- warto�ci r�ne od NULL s� sortowane w porz�dku malej�cym, warto�ci NULL umieszczane na pocz�tku zbioru
SELECT ename, sal, comm
FROM (
SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp
) x
ORDER BY is_null, comm DESC;

--2.6. Sortowanie wed�ug klucza zale�nego od danych
-- Problem: Chcemy posortowa� zbi�r wynikowy wed�ug logiki warunkowej. Przyk�adowo, je�li dany rekord zawiera w kolumnie job warto�� salesman, chcemy, aby jego pozycja
-- w zbiorze wynikowym zale�a�a od warto�ci sk�adowej w kolumnie comm (aby wynik sortowano wed�ug tej kolumny); w przeciwnym razie pozycja rekordu w zbiorze wynikowym 
-- powinna zale�e� od warto�ci w kolumnie sal.

SELECT ename, sal, job, comm
FROM emp
ORDER BY CASE WHEN job = 'SALESMAN'	 then comm ELSE sal END