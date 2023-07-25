-- •	Rozdzia³ 6. Praca z ³añcuchami

-- 6.1. Przechodzenie pomiêdzy znakami ³añcucha
-- Problem: Chcemy przeszukaæ ³añcuch w taki sposób, aby jego kolejne znaki znalaz³y siê w osobnych wierszach. Chcemy wyœwietliæ w czterech kolejnych wierszach 
-- (z których ka¿dy bêdzie zawiera³ jedn¹ literê) ³añcuch KING znajduj¹cy siê w kolumnie ENAME tabeli EMP.

SELECT SUBSTRING(e.ename, iter.pos, 1) AS C
FROM (SELECT ename FROM emp WHERE ename = 'KING') AS e,
	(SELECT id AS pos from t10) AS iter
WHERE iter.pos <= DATALENGTH(e.ename)

-- 6.2. Umieszczanie apostrofów w sta³ych ³añcuchowych
-- Problem: Chcemy umieœciæ znaki apostrofów w sta³ych ³añcuchowych. Celem jest wygenerowanie wykinu podobnego do tego:
--		QMARKS
--		g'day mate
--		beavers' teeth
--		'

SELECT 'g''day mate' qmarks FROM T1 UNION ALL
SELECT 'beavers'' teeth' FROM T1 UNION ALL
SELECT '''' FROM t1

-- 6.3. Zliczanie wyst¹pieñ znaku w ³añcuchu wejœciowym
-- Problem: Chcemy wyznaczyæ liczbê wyst¹pieñ znaku lub pod³añcucha w danym ³añcuchu wejœciowym. Dysponujemy nastêpuj¹cym ³añcuchem: 10,CLARK,MANAGER. 
-- Za³ó¿my, ¿e chcemy okreœliæ, ile przecinków znajduje siê w tym ³añcuchu.

SELECT(LEN('10,CLARK,MANAGER')-LEN(REPLACE('10,CLARK,MANAGER',',','')))/LEN(',') AS cnt
FROM t1

-- 6.4. Usuwanie z ³añcucha niechcianych znaków
-- Problem: Chcemy usun¹æ z danych wejœciowych okreœlone znaki. 
--			ENAME	SAL
--			SMITH	800
--			ALLEN	1600
--			WARD	1250
--			JONES	2975
--			MARTIN	1250
-- Chcemy usun¹æ wszystkie zera i samog³oski
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
-- Problem: Chcemy oddzieliæ dane znakowe od danych numerycznych np. 
-- Data		chcemy otrzymaæ		ENAME	SAL
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

-- 6.6. Okreœlanie, czy ³añcuch jest ci¹giem alfanumerycznym
-- Problem: Chcemy otrzymaæ zbiór wynikowy zawieraj¹cy tylko te wiersze tabeli, które w interesuj¹cej nas kolumnie nie zawieraj¹ innych znaków ni¿ cyfry i litery.
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
-- Naszym celem jest otrzymanie zbioru wynikowego zawieraj¹cego wy³¹cznie nastêpuj¹ce rekordy:
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

-- 6.7. Okreœlanie inicja³ów na podstawie ca³ych imion i nazwisk
-- Problem: Chcemy dokonaæ konwersji pe³nego imienia i nazwiska na inicja³y. Np. mamy ³añcuch wejœciowy: Stewie Griffin i chcemy otrzymaæ wyra¿enie: S.G.

SELECT REPLACE(
	REPLACE(
	TRANSLATE(REPLACE('Stewie Griffin', '.',''),
		'abcdefghijklmnopqrstuvwxyz',
		REPLICATE('#',26)), '#', ''), ' ', '.') + '.'
from T1

-- 6.8. Sortowanie kolumn wed³ug wybranych fragmentów ³añcuchów
-- Problem: Chcemy posortowaæ rekordy wed³ug ostatnich dwóch znaków nazwisk sk³adajacych siê w kolumnie ENAME

SELECT ename
FROM emp
ORDER BY SUBSTRING(ename, LEN(ename)-1,2)

-- 6.9. Sortowanie danych wed³ug liczb zapisanych w ³añcuchach
-- Problem: Chcemy posortowaæ zbiór wynikowy wed³ug liczb zapasanych w ³añcuchach wejœciowych. Mamy nastêpuj¹cy widok:
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
-- Chcemy posortowaæ zbiór wynikowy wed³ug liczbowych identyfikatorów przypisanych poszczególnym pracownikom
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

-- 6.10. Tworzenie listy wartoœci oddzielonych przecinkami z danych zawartych w wierszach tabeli
-- Problem: Chcemy otrzymaæ tabelê z³o¿on¹ z wierszy w formie ³añcuchów nazwisk oddzielonych za pomoc¹ wybranego separatora (np. przecinków). Zbiór wynikowy ma
-- zostaæ utworzony na podstawie tradycyjnych pionowych kolumn. Chcemy przekszta³ciæ:
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

--	6.12. Sortowanie znaków w ³añcuchach w porz¹dku alfabetycznym
-- Problem: Chcemy posortowaæ w porz¹dku alfabetycznym poszczególne znaki w ramach ³añcuchów reprezentowanych w naszej tabeli. Mamy zbiór wynikowy:
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
-- a chcemy otrzymaæ: 
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

