--Rozdzia� 3. Praca z wieloma tabelami
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--3.1. Umieszczanie jednego zbioru wierszy ponad drugim
-- Chcemy otrzyma� zbi�r wynikowy pochodz�cy z wi�cej ni� jednej tabeli. Chcemy otrzyma� zbi�r wynokowy z nazwiskami pracownik�w zatrudnionych w dziesi�tym dziale firmy wraz
-- z numerem tego dzia�u oraz nawiskami i numerami wszystkich dzia��w tej samej firmy

SELECT  ename AS ename_and_dname, deptno
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '--------------', null
FROM t1
UNION ALL 
SELECT dname, deptno
FROM dept;

--3.2. ��czenie wzajemnie powi�zanych wierszy
-- Chcemy uzyska� nazwiska wszystkich pracownik�w 10 dzia�u wraz z miastem, w kt�rym mie�ci si� siedziba tego dzia�u
SELECT e.ename, d.loc
FROM emp AS e, dept AS d
WHERE e.deptno = d.deptno
	AND e.deptno = 10;

--3.3. Odnajdywanie wsp�lnych wierszy pomi�dzy dwiema tabelami
-- Mamy widok 
--create view Vi 
--as
--select ename, job, sal
--from emp
--where job = 'Clerk'
-- Chcemy otrzyma� zbi�r wynikowy obejmuj�cy warto�ci zawarte w kolumnach empno, ename, job, sal i depno wszystkich pracownik�w reprezentowanych w tabeli emp, kt�rzy pasuja do
-- wierszy wzr�conych w widoku

SELECT e.empno, e.ename, e.job, e.sal, e.deptno
FROM emp AS e, Vi
WHERE e.ename =Vi.ename
	AND e.job = Vi.job
	AND e.sal = Vi.sal;

--3.4. Uzyskiwanie z jednej tabeli tylko tych warto�ci, kt�re nie wyst�puj� w innej tabeli
-- Chcemy zidentyfikowa� te dzia�y firmy reprezentowane w tabeli dept, kt�re nie s� reprezentowane w tabeli emp

SELECT deptno FROM dept
EXCEPT 
SELECT deptno FROM emp;

--3.5. Uzyskiwanie z jednej tabeli tylko tych wierszy, dla kt�rych nie istniej� odpowiedniki w innej tabeli
-- Chcemy wskaza� dzia�y firmy, kt�re nie zatrudnia� �adnych pracownik�w

SELECT d.*
FROM dept AS d 
LEFT OUTER JOIN  emp AS e
	ON d.deptno = e.deptno
WHERE e.deptno IS NULL;

--3.6. Dodawanie z��cze� do zapyta� bez konieczno�ci modyfikowania pozosta�ych, ju� istniej�cych z��cze�
-- Chcemy uzyska�  dane wszystkich pracownik�w, nazwy miast, w kt�rych znajduj� si� siedziby zatrudniaj�ce tych pracownik�w, oraz daty ich ostatnich premii

SELECT e.ename, d.loc, eb.received
FROM emp AS e 
join dept AS d 
	ON e.deptno = d.deptno
LEFT JOIN emp_bonus AS eb
	ON e.empno = eb.empno
ORDER BY 2;

--3.7. Okre�lanie, czy dwie tabele zawieraj� te same dane
-- mamy widok
--create view va
--as
--select * from emp where deptno != 10
--union all
--select * from emp where ename = 'Ward'
-- Chcemy okre�li� czy ten widok zawiera dok�adnie te same dane co tabela emp

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
--3.8. Identyfikowanie i eliminowanie iloczyn�w kartezja�skich
-- Chcemy uzyska� wszystkie nazwiska pracownik�w zatrudnionych w dziesiatym dziale wraz z nazw� miasta

SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno = 10 AND d.deptno = e.deptno;

--3.9. Stosowanie z��cze� w zapytaniach wykorzystuj�cych funkcje agreguj�ce
-- Chcemy wyznaczy� sum� pensji otrzymywanych przez pracownik�w zatrudnionych w dziale 10 oraz sum� wyp�aconych im premii 

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

--3.10. Stosowanie z��cze� zewn�trznych w zapytaniach wykorzystuj�cych funkcje agreguj�ce
-- Podobnie jak w poprzednim zadaniu, ale nie wszyscy pracownicy dzia�u 10 otrzymali premie

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

