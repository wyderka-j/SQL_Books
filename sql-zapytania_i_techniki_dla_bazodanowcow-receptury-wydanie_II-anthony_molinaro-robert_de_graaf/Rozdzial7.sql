--		Rozdzia� 7. Praca z liczbami

-- 7.1. Wyznaczanie warto�ci �redniej
-- Problem: Chcemy wyznaczyc �redni� arytmetyczn� dla warto�ci sk�aowanych w wybranej kolumnie. Np. �rednie wynagrodzenie wyp�acanego wszystkim pracownikom lub
-- �rednich wynagrodze� pracownik�w zatrudnionych w poszczeg�lnych dzia�ach

-- wszyscy
SELECT AVG(sal) AS avg_sal
FROM EMP;

-- poszczeg�lne dzia�y
SELECT deptno, AVG(sal) AS avg_sal
FROM EMP
GROUP BY deptno;

-- 7.2. Identyfikacja minimalnej i maksymalnej warto�ci w kolumnie
-- Problem: Chcemy odnale�� maksymaln� i minimaln� warto�� sk�adowan� w okre�lonej kolumnie tabeli. Np. wyznaczenie najwy�szej i najni�szej wysoko�ci pensji
-- spo�r�d wszystkich pracownik�w lub w poszczeg�lnych dzia�ach

-- wszyscy pracownicy
SELECT MIN(sal) AS min_sal, MAX(sal) AS max_sal
FROM EMP;

-- poszczeg�lne dzia�y
SELECT deptno, MIN(sal) AS min_sal, MAX(sal) AS max_sal
FROM EMP
GROUP BY deptno;

-- 7.3. Sumowanie warto�ci sk�adowanych w kolumnie
-- Problem: Chcemy wyznaczy� sum� wszystkich warto�ci sk�adowanych w jednej z kolumn naszej tabeli, np. sum� wynagrodze� wyp�acanych pracownikom

-- wszyscy pracownicy
SELECT SUM(sal)
FROM EMP;

-- poszczeg�lne dzia�y
SELECT deptno, SUM(sal) AS total_for_dept
FROM EMP
GROUP BY deptno;

-- 7.4. Zliczanie wierszy tabeli
-- Problem: Chcemy wyznaczy� liczb� wierszy sk�adowanych w tabeli lub zliczy� warto�ci sk�adowane w jednej z kolumn. Np. wyznaczenie ��cznej liczby pracownik�w
-- jak i liczby pracownik�w zatrudnionych w poszczeg�lnych dzialach

-- wszyscy pracownicy
SELECT COUNT(*)
FROM EMP;

-- poszczeg�lne dzia�y
SELECT deptno, COUNT(*)
FROM EMP
GROUP BY deptno;

-- 7.5. Zliczanie r�nych warto�ci w kolumnie
-- Problem: Chcemy wyznaczy� liczb� sk�adowanych w wybranej kolimnie warto�ci r�nych od NULL. Np. okre�lenie liczby pracownik�w wynagradzanych w systemie 
-- prowizyjnym

SELECT COUNT(comm)
FROM EMP;

-- 7.6. Generowanie sum bie��cych
-- Problem: Chcemy wyznaczy� sum� bie��c� (narastaj�c�) dla warto�ci sk�adowanych w okre�lonej kolumnie

SELECT ename, sal,
	SUM(sal) OVER (ORDER BY sal, empno) AS running_total
FROM EMP
ORDER BY 2;

-- 7.7. Generowanie iloczyn�w bie��cych
-- Problem: Chcemy wyznaczy� iloczyn bie��cy (narastaj�cy) kolumny zawieraj�cej dane liczbowe.

SELECT empno, ename, sal,
	EXP(SUM(LOG(sal))OVER(ORDER BY sal,empno)) AS running_prod
FROM EMP
WHERE deptno=10;

--	7.9. WYznaczenie warto�ci modalnej (dominanty)
-- Problem: Chcemy znale�� warto�� modaln� w�r�d warto�ci okre�lonej kolumny. Np. warto�� modalna w�r�d wynagrodze� pracownik�w dzia�u 20. Dane wej�ciowe:
		--SELECT sal
		--FROM EMP
		--WHERE deptno = 20
		--ORDER BY sal;
-- Warto�ci
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
-- Problem: Chcemy wyznaczy�median� w ramach kolumny zawieraj�cej dane liczbowe. Np. odnale�� median� dla wszystkich wynagrodze� wyp�acanych pracownikom dzia�u
-- 20. Przyjmijmy, �e nasz zbi�r wej�ciowy ma nast�puj�c� posta�:
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

--	7.11. Okre�lanie procentowego udzia�u w warto�ci ��cznej
-- Problem: Chcemy okre�li� procentowy udzia� poszczeg�lnych warto�ci sk�adowych w okre�nowej kolumnie wzgl�dem sumy wszystkich warto�ci. Np. musimy okre�li�, 
-- jaki jest procentowy udzia� wynagordze� pracownik�w dzia�u 10 we wszystkich wynagrodzeniach wyp�acanych przez firm�

SELECT DISTINCT 
	cast(d10 as decimal)/total*100 AS pct
	FROM(
SELECT deptno,
		SUM(sal)OVER() total,
		SUM(sal)OVER(PARTITION BY deptno) d10
	FROM EMP
		) x
	WHERE deptno=10;

--	7.12. Agregowanie kolumn zawieraj�cych warto�ci NULL
-- Problem: Chcemy dokona� agregacji kolumny, kt�ra mo�e zawiera� warto�� NULL. Np. musimy okre�li� �redni� wysoko�� prowizji wyp�acanych pracownik�w dzia�u 30,
-- ale dzia� 30 zatrudnia pracownik�w, kt�rzy w og�le nie s� wynagradzani w tym trybie. 

SELECT AVG(coalesce(comm,0)) AS avg_comm
FROM EMP
WHERE deptno = 30;

--	7.13. Wyznaczanie warto�ci �rednich z wy��czeniem warto�ci spoza okre�lonego przedzia�u
-- Problem: Chcemy wyznaczy� warto�� �redni� ale tak, by w obliczeniach pomin�� skrajne - najwy�sze i najni�sze warto�ci. Np. obliczenie �redniego wynagrodzenia
-- wszystkich pracownik�w z wyj�tkiem tych, kt�rzy zarabiaj� najmniej i najwi�cej.

SELECT AVG(sal)
	FROM (
SELECT sal, MIN(sal)OVER() min_sal, MAX(sal)OVER() max_sal
	FROM EMP
	) x
	WHERE sal NOT IN (min_sal, max_sal);

--	7.14. Wyodr�bnianie liczb z �a�cuch�w alfanumerycznych
-- Problem: Dysponujemy danymi alfanumerycznymi i chcieliby�my otrzyma� wy��cznie liczby sk�adowane w tych danych. Np. z �a�cucha "paul123f321" chcieliby�my 
-- otrzyma� 123321.

SELECT CAST(
	REPLACE(
	TRANSLATE('paul123f321', 
			'abcdefghijklmnopqrstuvwxyz', 
			replicate('#', 26)), '#', '')
	AS integer) AS num
FROM t1

--	7.15. Modyfikowanie warto�ci uwzgl�dnianych w sumach bie��cych
-- Problem: Chcemy modyfikowa� warto�ci uwzgl�dniane w sumach bie��cych z zale�no�ci od warto�ci sk�adowych w okre�lonej kolumnie. 
-- Np. chcemy wygenerowa� histori� dokonywanych za pomoc� karty kredytowej wraz z bie��cym stanem rachunku. Mamy:
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
-- Chcemy otrzyma�:
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

