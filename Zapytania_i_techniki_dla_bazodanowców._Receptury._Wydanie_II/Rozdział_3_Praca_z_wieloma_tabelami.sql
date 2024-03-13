--Rozdzia³ 3. Praca z wieloma tabelami
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--3.1. Umieszczanie jednego zbioru wierszy ponad drugim
-- Chcemy otrzymaæ zbiór wynikowy pochodz¹cy z wiêcej ni¿ jednej tabeli. Chcemy otrzymaæ zbiór wynokowy z nazwiskami pracowników zatrudnionych w dziesi¹tym dziale firmy wraz
-- z numerem tego dzia³u oraz nawiskami i numerami wszystkich dzia³ów tej samej firmy

SELECT  ename AS ename_and_dname, deptno
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '--------------', null
FROM t1
UNION ALL 
SELECT dname, deptno
FROM dept;

--3.2. £¹czenie wzajemnie powi¹zanych wierszy
-- Chcemy uzyskaæ nazwiska wszystkich pracowników 10 dzia³u wraz z miastem, w którym mieœci siê siedziba tego dzia³u
SELECT e.ename, d.loc
FROM emp AS e, dept AS d
WHERE e.deptno = d.deptno
	AND e.deptno = 10;

--3.3. Odnajdywanie wspólnych wierszy pomiêdzy dwiema tabelami
-- Mamy widok 
--create view Vi 
--as
--select ename, job, sal
--from emp
--where job = 'Clerk'
-- Chcemy otrzymaæ zbiór wynikowy obejmuj¹cy wartoœci zawarte w kolumnach empno, ename, job, sal i depno wszystkich pracowników reprezentowanych w tabeli emp, którzy pasuja do
-- wierszy wzróconych w widoku

SELECT e.empno, e.ename, e.job, e.sal, e.deptno
FROM emp AS e, Vi
WHERE e.ename =Vi.ename
	AND e.job = Vi.job
	AND e.sal = Vi.sal;

--3.4. Uzyskiwanie z jednej tabeli tylko tych wartoœci, które nie wystêpuj¹ w innej tabeli
-- Chcemy zidentyfikowaæ te dzia³y firmy reprezentowane w tabeli dept, które nie s¹ reprezentowane w tabeli emp

SELECT deptno FROM dept
EXCEPT 
SELECT deptno FROM emp;

--3.5. Uzyskiwanie z jednej tabeli tylko tych wierszy, dla których nie istniej¹ odpowiedniki w innej tabeli
-- Chcemy wskazaæ dzia³y firmy, które nie zatrudnia¹ ¿adnych pracowników

SELECT d.*
FROM dept AS d 
LEFT OUTER JOIN  emp AS e
	ON d.deptno = e.deptno
WHERE e.deptno IS NULL;

--3.6. Dodawanie z³¹czeñ do zapytañ bez koniecznoœci modyfikowania pozosta³ych, ju¿ istniej¹cych z³¹czeñ
-- Chcemy uzyskaæ  dane wszystkich pracowników, nazwy miast, w których znajduj¹ siê siedziby zatrudniaj¹ce tych pracowników, oraz daty ich ostatnich premii

SELECT e.ename, d.loc, eb.received
FROM emp AS e 
join dept AS d 
	ON e.deptno = d.deptno
LEFT JOIN emp_bonus AS eb
	ON e.empno = eb.empno
ORDER BY 2;

--3.7. Okreœlanie, czy dwie tabele zawieraj¹ te same dane
-- mamy widok
--create view va
--as
--select * from emp where deptno != 10
--union all
--select * from emp where ename = 'Ward'
-- Chcemy okreœliæ czy ten widok zawiera dok³adnie te same dane co tabela emp

SELECT *
 FROM (
SELECT e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, e.deptno, COUNT(*) AS cnt
FROM emp AS e
GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
) AS e
WHERE NOT EXISTS (
SELECT NULL 
 FROM (
SELECT va.empno, va.ename, va.job, va.mgr, va.hiredate, va.sal, va.comm, va.deptno, COUNT(*) AS cnt
FROM va
GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
)  va
WHERE va.empno = e.empno
	AND va.ename = e.ename
	AND va.job = e.job
	AND va.mgr = e.mgr
	AND va.hiredate = e.hiredate
	AND va.sal = e.sal
	AND va.deptno = e.deptno
	AND va.cnt = e.cnt
	AND COALESCE(va.comm, 0) = COALESCE (e.comm, 0)
)
UNION ALL
SELECT *
 FROM (
SELECT va.empno, va.ename, va.job, va.mgr, va.hiredate, va.sal, va.comm, va.deptno, COUNT(*) AS cnt
FROM va
GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
)  va
WHERE NOT EXISTS (
SELECT NULL 
 FROM (
 SELECT e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, e.deptno, COUNT(*) AS cnt
FROM emp AS e
GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
) AS e
WHERE va.empno = e.empno
	AND va.ename = e.ename
	AND va.job = e.job
	AND va.mgr = e.mgr
	AND va.hiredate = e.hiredate
	AND va.sal = e.sal
	AND va.deptno = e.deptno
	AND va.cnt = e.cnt
	AND COALESCE(va.comm, 0) = COALESCE (e.comm, 0)
);
--3.8. Identyfikowanie i eliminowanie iloczynów kartezjañskich
-- Chcemy uzyskaæ wszystkie nazwiska pracowników zatrudnionych w dziesiatym dziale wraz z nazw¹ miasta

SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno = 10 AND d.deptno = e.deptno;

--3.9. Stosowanie z³¹czeñ w zapytaniach wykorzystuj¹cych funkcje agreguj¹ce
-- Chcemy wyznaczyæ sumê pensji otrzymywanych przez pracowników zatrudnionych w dziale 10 oraz sumê wyp³aconych im premii 

SELECT deptno, 
		SUM(DISTINCT sal) AS total,
		SUM(bonus) AS total_bonus
FROM (
SELECT e.empno,
		e.ename,
		e.sal,
		e.deptno,
		e.sal * CASE WHEN eb.type = 1 THEN .1
					WHEN eb.type = 2 THEN .2
					ELSE .3
				END as bonus
FROM emp e, emp_bonus eb
WHERE e.empno = eb.empno
	AND e.deptno = 10
) x
GROUP BY deptno;

--3.10. Stosowanie z³¹czeñ zewnêtrznych w zapytaniach wykorzystuj¹cych funkcje agreguj¹ce
-- Podobnie jak w poprzednim zadaniu, ale nie wszyscy pracownicy dzia³u 10 otrzymali premie

SELECT deptno, 
		SUM(DISTINCT sal) AS total,
		SUM(bonus) AS total_bonus
FROM (
SELECT e.empno,
		e.ename,
		e.sal,
		e.deptno,
		e.sal * CASE WHEN eb.type IS NULL THEN 0
					WHEN eb.type = 1 THEN .1
					WHEN eb.type = 2 THEN .2
					ELSE .3
				END as bonus
FROM emp e LEFT OUTER JOIN emp_bonus eb 
	ON e.empno = eb.empno
WHERE  e.deptno = 10
) x
GROUP BY deptno;

