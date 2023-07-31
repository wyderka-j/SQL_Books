--		Rozdzia³ 7. Praca z liczbami

-- 7.1. Wyznaczanie wartoœci œredniej
-- Problem: Chcemy wyznaczyc œredni¹ arytmetyczn¹ dla wartoœci sk³aowanych w wybranej kolumnie. Np. Œrednie wynagrodzenie wyp³acanego wszystkim pracownikom lub
-- œrednich wynagrodzeñ pracowników zatrudnionych w poszczególnych dzia³ach

-- wszyscy
SELECT AVG(sal) AS avg_sal
FROM EMP;

-- poszczególne dzia³y
SELECT deptno, AVG(sal) AS avg_sal
FROM EMP
GROUP BY deptno;

-- 7.2. Identyfikacja minimalnej i maksymalnej wartoœci w kolumnie
-- Problem: Chcemy odnaleŸæ maksymaln¹ i minimaln¹ wartoœæ sk³adowan¹ w okreœlonej kolumnie tabeli. Np. wyznaczenie najwy¿szej i najni¿szej wysokoœci pensji
-- spoœród wszystkich pracowników lub w poszczególnych dzia³ach

-- wszyscy pracownicy
SELECT MIN(sal) AS min_sal, MAX(sal) AS max_sal
FROM EMP;

-- poszczególne dzia³y
SELECT deptno, MIN(sal) AS min_sal, MAX(sal) AS max_sal
FROM EMP
GROUP BY deptno;

-- 7.3. Sumowanie wartoœci sk³adowanych w kolumnie
-- Problem: Chcemy wyznaczyæ sumê wszystkich wartoœci sk³adowanych w jednej z kolumn naszej tabeli, np. sumê wynagrodzeñ wyp³acanych pracownikom

-- wszyscy pracownicy
SELECT SUM(sal)
FROM EMP;

-- poszczególne dzia³y
SELECT deptno, SUM(sal) AS total_for_dept
FROM EMP
GROUP BY deptno;

-- 7.4. Zliczanie wierszy tabeli
-- Problem: Chcemy wyznaczyæ liczbê wierszy sk³adowanych w tabeli lub zliczyæ wartoœci sk³adowane w jednej z kolumn. Np. wyznaczenie ³¹cznej liczby pracowników
-- jak i liczby pracowników zatrudnionych w poszczególnych dzialach

-- wszyscy pracownicy
SELECT COUNT(*)
FROM EMP;

-- poszczególne dzia³y
SELECT deptno, COUNT(*)
FROM EMP
GROUP BY deptno;

-- 7.5. Zliczanie ró¿nych wartoœci w kolumnie
-- Problem: Chcemy wyznaczyæ liczbê sk³adowanych w wybranej kolimnie wartoœci ró¿nych od NULL. Np. okreœlenie liczby pracowników wynagradzanych w systemie 
-- prowizyjnym

SELECT COUNT(comm)
FROM EMP;

-- 7.6. Generowanie sum bie¿¹cych
-- Problem: Chcemy wyznaczyæ sumê bie¿¹c¹ (narastaj¹c¹) dla wartoœci sk³adowanych w okreœlonej kolumnie

SELECT ename, sal,
	SUM(sal) OVER (ORDER BY sal, empno) AS running_total
FROM EMP
ORDER BY 2;

-- 7.7. Generowanie iloczynów bie¿¹cych
-- Problem: Chcemy wyznaczyæ iloczyn bie¿¹cy (narastaj¹cy) kolumny zawieraj¹cej dane liczbowe.

SELECT empno, ename, sal,
	EXP(SUM(LOG(sal))OVER(ORDER BY sal,empno)) AS running_prod
FROM EMP
WHERE deptno=10;

--	7.9. WYznaczenie wartoœci modalnej (dominanty)
-- Problem: Chcemy znaleŸæ wartoœæ modaln¹ wœród wartoœci okreœlonej kolumny. Np. wartoœæ modalna wœród wynagrodzeñ pracowników dzia³u 20. Dane wejœciowe:
		--SELECT sal
		--FROM EMP
		--WHERE deptno = 20
		--ORDER BY sal;
-- Wartoœci
		--800
		--1100
		--2975
		--3000
		--3000

SELECT sal
	FROM (
SELECT sal,
		DENSE_RANK()OVER(ORDER BY cnt desc) AS rnk
	FROM (
SELECT sal, COUNT(*) AS cnt
	FROM EMP
	WHERE deptno=20
	GROUP BY sal
	) x 
	) y
	WHERE rnk = 1;

-- 7.10. Wyznaczanie mediany
-- Problem: Chcemy wyznaczyæmedianê w ramach kolumny zawieraj¹cej dane liczbowe. Np. odnaleŸæ medianê dla wszystkich wynagrodzeñ wyp³acanych pracownikom dzia³u
-- 20. Przyjmijmy, ¿e nasz zbiór wejœciowy ma nastêpuj¹c¹ postaæ:
		--select sal
		--from EMP
		--where deptno=20
		--order by sal
-- Dane:
				--800
				--1100
				--2975
				--3000
				--3000

SELECT PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY sal)
	OVER()
FROM EMP
WHERE deptno=20;

--	7.11. Okreœlanie procentowego udzia³u w wartoœci ³¹cznej
-- Problem: Chcemy okreœliæ procentowy udzia³ poszczególnych wartoœci sk³adowych w okreœnowej kolumnie wzglêdem sumy wszystkich wartoœci. Np. musimy okreœliæ, 
-- jaki jest procentowy udzia³ wynagordzeñ pracowników dzia³u 10 we wszystkich wynagrodzeniach wyp³acanych przez firmê

SELECT DISTINCT 
	cast(d10 as decimal)/total*100 AS pct
	FROM(
SELECT deptno,
		SUM(sal)OVER() total,
		SUM(sal)OVER(PARTITION BY deptno) d10
	FROM EMP
		) x
	WHERE deptno=10;

--	7.12. Agregowanie kolumn zawieraj¹cych wartoœci NULL
-- Problem: Chcemy dokonaæ agregacji kolumny, która mo¿e zawieraæ wartoœæ NULL. Np. musimy okreœliæ œredni¹ wysokoœæ prowizji wyp³acanych pracowników dzia³u 30,
-- ale dzia³ 30 zatrudnia pracowników, którzy w ogóle nie s¹ wynagradzani w tym trybie. 

SELECT AVG(coalesce(comm,0)) AS avg_comm
FROM EMP
WHERE deptno = 30;

--	7.13. Wyznaczanie wartoœci œrednich z wy³¹czeniem wartoœci spoza okreœlonego przedzia³u
-- Problem: Chcemy wyznaczyæ wartoœæ œredni¹ ale tak, by w obliczeniach pomin¹æ skrajne - najwy¿sze i najni¿sze wartoœci. Np. obliczenie œredniego wynagrodzenia
-- wszystkich pracowników z wyj¹tkiem tych, którzy zarabiaj¹ najmniej i najwiêcej.

SELECT AVG(sal)
	FROM (
SELECT sal, MIN(sal)OVER() min_sal, MAX(sal)OVER() max_sal
	FROM EMP
	) x
	WHERE sal NOT IN (min_sal, max_sal);

--	7.14. Wyodrêbnianie liczb z ³añcuchów alfanumerycznych
-- Problem: Dysponujemy danymi alfanumerycznymi i chcielibyœmy otrzymaæ wy³¹cznie liczby sk³adowane w tych danych. Np. z ³añcucha "paul123f321" chcielibyœmy 
-- otrzymaæ 123321.

SELECT CAST(
	REPLACE(
	TRANSLATE('paul123f321', 
			'abcdefghijklmnopqrstuvwxyz', 
			replicate('#', 26)), '#', '')
	AS integer) AS num
FROM t1

--	7.15. Modyfikowanie wartoœci uwzglêdnianych w sumach bie¿¹cych
-- Problem: Chcemy modyfikowaæ wartoœci uwzglêdniane w sumach bie¿¹cych z zaleŸnoœci od wartoœci sk³adowych w okreœlonej kolumnie. 
-- Np. chcemy wygenerowaæ historiê dokonywanych za pomoc¹ karty kredytowej wraz z bie¿¹cym stanem rachunku. Mamy:
	--create view Ve (id, amt, trx)
	--as
	--select 1, 100, 'PR' from T1 union all
	--select 2, 100, 'PR' from T1 union all
	--select 3, 50, 'PY' from T1 union all
	--select 4, 100, 'PR' from T1 union all
	--select 5, 200, 'PY' from T1 union all
	--select 6, 50, 'PY' from T1
--select * from Ve
		--1	100	PR
		--2	100	PR
		--3	50	PY
		--4	100	PR
		--5	200	PY
		--6	50	PY
-- Chcemy otrzymaæ:
		--Purchase	100	100
		--Purchase	100	200
		--Payment	50	150
		--Purchase	100	250
		--Payment	200	50
		--Payment	50	0
SELECT CASE WHEN trx = 'PY'
			THEN 'Payment'
			ELSE 'Purchase'
		END trx_type,
		amt,
		SUM(
		CASE WHEN trx = 'PY'
			THEN -amt ELSE amt
		END
	) OVER (ORDER BY id, amt) AS balance
FROM Ve

