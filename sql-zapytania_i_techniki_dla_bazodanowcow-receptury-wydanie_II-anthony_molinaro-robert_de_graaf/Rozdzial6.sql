-- �	Rozdzia� 6. Praca z �a�cuchami

-- 6.1. Przechodzenie pomi�dzy znakami �a�cucha
-- Problem: Chcemy przeszuka� �a�cuch w taki spos�b, aby jego kolejne znaki znalaz�y si� w osobnych wierszach. Chcemy wy�wietli� w czterech kolejnych wierszach 
-- (z kt�rych ka�dy b�dzie zawiera� jedn� liter�) �a�cuch KING znajduj�cy si� w kolumnie ENAME tabeli EMP.

SELECT SUBSTRING(e.ename, iter.pos, 1) AS C
FROM (SELECT ename FROM emp WHERE ename = 'KING') AS e,
	(SELECT id AS pos from t10) AS iter
WHERE iter.pos <= DATALENGTH(e.ename)

-- 6.2. Umieszczanie apostrof�w w sta�ych �a�cuchowych
-- Problem: Chcemy umie�ci� znaki apostrof�w w sta�ych �a�cuchowych. Celem jest wygenerowanie wykinu podobnego do tego:
--		QMARKS
--		g'day mate
--		beavers' teeth
--		'

SELECT 'g''day mate' qmarks FROM T1 UNION ALL
SELECT 'beavers'' teeth' FROM T1 UNION ALL
SELECT '''' FROM t1

-- 6.3. Zliczanie wyst�pie� znaku w �a�cuchu wej�ciowym
-- Problem: Chcemy wyznaczy� liczb� wyst�pie� znaku lub pod�a�cucha w danym �a�cuchu wej�ciowym. Dysponujemy nast�puj�cym �a�cuchem: 10,CLARK,MANAGER. 
-- Za��my, �e chcemy okre�li�, ile przecink�w znajduje si� w tym �a�cuchu.

SELECT(LEN('10,CLARK,MANAGER')-LEN(REPLACE('10,CLARK,MANAGER',',','')))/LEN(',') AS cnt
FROM t1

-- 6.4. Usuwanie z �a�cucha niechcianych znak�w
-- Problem: Chcemy usun�� z danych wej�ciowych okre�lone znaki. 
--			ENAME	SAL
--			SMITH	800
--			ALLEN	1600
--			WARD	1250
--			JONES	2975
--			MARTIN	1250
-- Chcemy usun�� wszystkie zera i samog�oski
--			ENAME	stripped1	SAL	stripped2
--			SMITH	SMITH		800		8 
--			ALLEN	LLEN		1600	16
--			WARD	WRD			1250	125
--			JONES	JONES		2975	2975
--			MARTIN	MRTIN		1250	125

SELECT ename,
	REPLACE(TRANSLATE(ename, 'aaaaa', 'AEIOU'), 'a', '') stripped1,
	sal,
	REPLACE(CAST(sal AS CHAR(4)), '0','') stripped2
FROM emp;

-- 6.5. Oddzielanie danych numerycznych od danych znakowych
-- Problem: Chcemy oddzieli� dane znakowe od danych numerycznych np. 
-- Data		chcemy otrzyma�		ENAME	SAL
-- SMITH800						SMITH	800
-- ALLEN1600					ALLEN	1600

SELECT REPLACE(
	TRANSLATE(data, '0123456789', '0000000000'),'0','') AS ename,
		CAST(
		REPLACE(
	TRANSLATE(lower(data), 'abcdefghijklmnopqrstuvwxyz', REPLICATE('z',26)),'z','') AS integer) AS sal
FROM (
SELECT CONCAT(ename,sal) AS data
FROM EMP
	) x

-- 6.6. Okre�lanie, czy �a�cuch jest ci�giem alfanumerycznym
-- Problem: Chcemy otrzyma� zbi�r wynikowy zawieraj�cy tylko te wiersze tabeli, kt�re w interesuj�cej nas kolumnie nie zawieraj� innych znak�w ni� cyfry i litery.
-- Mamy widok
--create view V as
--select ename as data
--	from emp
--	where deptno = 10
--union all
--select ename +', $' + CAST (sal as char(4)) + '.00' as data
--	from emp
--	where deptno = 20
--union all
--select ename + cast(deptno as char(4)) as data
--	from emp
--	where deptno = 30
-- Otrzymane wyniki:
	--CLARK
	--KING
	--MILLER
	--SMITH, $800 .00
	--JONES, $2975.00
	--SCOTT, $3000.00
	--ADAMS, $1100.00
	--FORD, $3000.00
	--ALLEN30  
	--WARD30  
	--MARTIN30  
	--BLAKE30  
	--TURNER30  
	--JAMES30  
-- Naszym celem jest otrzymanie zbioru wynikowego zawieraj�cego wy��cznie nast�puj�ce rekordy:
	--CLARK
	--KING
	--MILLER
	--ALLEN30  
	--WARD30  
	--MARTIN30  
	--BLAKE30  
	--TURNER30  
	--JAMES30  

SELECT data
FROM V
WHERE TRANSLATE(LOWER(data), 
		'0123456789abcdefghijklmnopqrstuvwxyz', 
		REPLICATE('a',36)) = REPLICATE('a',LEN(data))

-- 6.7. Okre�lanie inicja��w na podstawie ca�ych imion i nazwisk
-- Problem: Chcemy dokona� konwersji pe�nego imienia i nazwiska na inicja�y. Np. mamy �a�cuch wej�ciowy: Stewie Griffin i chcemy otrzyma� wyra�enie: S.G.

SELECT REPLACE(
	REPLACE(
	TRANSLATE(REPLACE('Stewie Griffin', '.',''),
		'abcdefghijklmnopqrstuvwxyz',
		REPLICATE('#',26)), '#', ''), ' ', '.') + '.'
from T1

-- 6.8. Sortowanie kolumn wed�ug wybranych fragment�w �a�cuch�w
-- Problem: Chcemy posortowa� rekordy wed�ug ostatnich dw�ch znak�w nazwisk sk�adajacych si� w kolumnie ENAME

SELECT ename
FROM emp
ORDER BY SUBSTRING(ename, LEN(ename)-1,2)

-- 6.9. Sortowanie danych wed�ug liczb zapisanych w �a�cuchach
-- Problem: Chcemy posortowa� zbi�r wynikowy wed�ug liczb zapasanych w �a�cuchach wej�ciowych. Mamy nast�puj�cy widok:
	--create view Vv as
	--select e.ename + ' ' + CAST (e.empno as CHAR(4)) + ' ' + d.dname as data
	--from emp e, dept d
	--where e.deptno = d.deptno
-- Mamy
	--SMITH 7369 RESEARCH
	--ALLEN 7499 SALES
	--WARD 7521 SALES
	--JONES 7566 RESEARCH
	--MARTIN 7654 SALES
	--BLAKE 7698 SALES
	--CLARK 7782 ACCOUNTING
	--SCOTT 7788 RESEARCH
	--KING 7839 ACCOUNTING
	--TURNER 7844 SALES
	--ADAMS 7876 RESEARCH
	--JAMES 7900 SALES
	--FORD 7902 RESEARCH
	--MILLER 7934 ACCOUNTING
-- Chcemy posortowa� zbi�r wynikowy wed�ug liczbowych identyfikator�w przypisanych poszczeg�lnym pracownikom
	--SMITH 7369 RESEARCH
	--ALLEN 7499 SALES
	--WARD 7521 SALES
	--JONES 7566 RESEARCH
	--MARTIN 7654 SALES
	--BLAKE 7698 SALES
	--CLARK 7782 ACCOUNTING
	--SCOTT 7788 RESEARCH
	--KING 7839 ACCOUNTING
	--TURNER 7844 SALES
	--ADAMS 7876 RESEARCH
	--JAMES 7900 SALES
	--FORD 7902 RESEARCH
	--MILLER 7934 ACCOUNTING

SELECT data
FROM Vv
ORDER BY
	CAST(
	REPLACE( 
	TRANSLATE(data,
	REPLACE(
	TRANSLATE(data, '0123456789','##########'), '#', ' '),
	REPLICATE('#', LEN(data))), '#', '') AS integer)

-- 6.10. Tworzenie listy warto�ci oddzielonych przecinkami z danych zawartych w wierszach tabeli
-- Problem: Chcemy otrzyma� tabel� z�o�on� z wierszy w formie �a�cuch�w nazwisk oddzielonych za pomoc� wybranego separatora (np. przecink�w). Zbi�r wynikowy ma
-- zosta� utworzony na podstawie tradycyjnych pionowych kolumn. Chcemy przekszta�ci�:
	--10	CLARK
	--10	KING
	--10	MILLER
	--20	FORD
	--20	ADAMS
	--20	SCOTT
	--20	SMITH
	--20	JONES
	--30	MARTIN
	--30	BLAKE
	--30	ALLEN
	--30	WARD
	--30	TURNER
	--30	JAMES
-- na:
	--10	CLARK, KING, MILLER
	--20	FORD, ADAMS, SCOTT, SMITH, JONES
	--30	MARTIN, BLAKE, ALLEN, WARD, TURNER, JAMES

SELECT deptno,
	STRING_AGG(ename, ', ') AS emps
FROM EMP
GROUP BY deptno

--	6.12. Sortowanie znak�w w �a�cuchach w porz�dku alfabetycznym
-- Problem: Chcemy posortowa� w porz�dku alfabetycznym poszczeg�lne znaki w ramach �a�cuch�w reprezentowanych w naszej tabeli. Mamy zbi�r wynikowy:
	--ADAMS
	--ALLEN
	--BLAKE
	--CLARK
	--FORD
	--JAMES
	--JONES
	--KING
	--MARTIN
	--MILLER
	--SCOTT
	--SMITH
	--TURNER
	--WARD
-- a chcemy otrzyma�: 
		--ADAMS	AADMS
		--ALLEN	AELLN
		--BLAKE	ABEKL
		--CLARK	ACKLR
		--FORD	DFOR
		--JAMES	AEJMS
		--JONES	EJNOS
		--KING	GIKN
		--MARTIN	AIMNRT
		--MILLER	EILLMR
		--SCOTT	COSTT
		--SMITH	HIMST
		--TURNER	ENRRTU
		--WARD	ADRW

SELECT ename,
	MAX(case when pos=1 then c else '' end)+
	MAX(case when pos=2 then c else '' end)+
	MAX(case when pos=3 then c else '' end)+
	MAX(case when pos=4 then c else '' end)+
	MAX(case when pos=5 then c else '' end)+
	MAX(case when pos=6 then c else '' end)
FROM (
select e.ename,
	SUBSTRING(e.ename, iter.pos, 1) as c,
	ROW_NUMBER() over (
	partition by e.ename
		order by substring(e.ename, iter.pos, 1)) as pos
from emp e,
	(select ROW_NUMBER() over(order by ename) as pos
		from emp) iter
where iter.pos <= LEN(e.ename)
	) x
group by ename

