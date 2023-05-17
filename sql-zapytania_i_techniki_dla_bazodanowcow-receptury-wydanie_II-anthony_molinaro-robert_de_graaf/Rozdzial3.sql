--Rozdzia³ 3. Praca z wieloma tabelami

--3.1. Umieszczanie jednego zbioru wierszy ponad drugim
-- Problem: Chcemy otrzymaæ zbiór wynikowy z danymi pochodz¹cymi z wiêcej niz jednej tabeli. W praktyce jeden zbiór wynikowy powinien zostaæ umieszczony ponad drugim.
-- Bêdziemy chcieli zbudowaæ zbiór wynikowy z nazwiskami pracowników zatrudnionych w dziesi¹tym dziale firmy wraz z numerem tego dzia³u (niezbêdne dane s¹ sk³adowane w
-- tabeli emp) oraz nazwiskami i numerami wszystkich dzia³ów tej samej firmy (te dane pochodz¹ z tabeli dept).

SELECT ename AS ename_and_dname, deptno
	FROM emp
	WHERE deptno = 10
UNION ALL
	SELECT '----------', NULL
	FROM t1
UNION ALL
	SELECT dname, deptno
	FROM dept;

--3.2. £¹czenie wzajemnie powi¹zanych wierszy
-- Problem: Chcemy skonstruowaæ zbiór wynikowy z³o¿ony z wierszy pochodz¹cych z wielu tabel- zbiór ma powstaæ przez z³¹czenie wed³ug wspólnej kolumny lub kolumn 
-- zawieraj¹cych wspólne wartoœci. Przyk³adowo mo¿emy stan¹æ przed koniecznoœci¹ uzyskania nazwisk wszystkich pracowników dziesi¹tego dzia³u firmy wraz z miastem,
-- w którym mieœci siê siedziba tego dzia³u.

SELECT e.ename, d.loc 
FROM emp e, dept d
WHERE e.deptno = d.deptno
	AND e.deptno = 10;

--3.3. Odnajdywanie wspólnych wierszy pomiêdzy dwiema tabelami
--Problem: Chcemy odnaleŸæ wspólne wiersze w dwóch tabelach, lecz istnieje kilka kolumn, które mog¹ pos³u¿yæ do z³¹czenia. Rozwa¿my poni¿szy widok utworzony na 
-- podstawie tabeli emp
--create view V
--as select ename, job, sal 
--	from emp 
--	where job = 'CLERK';
--select * from V;
-- Chcemy otrzymaæ zbiór wynikowy obejmuj¹cy wartoœci zawarte w kolumnach empno, ename, job, sal i deptno wszystkich pracowników reprezentowanych w tabeli emp, którzy
-- pasuj¹ do wierszy zwróconych w widoku V.

SELECT e.empno, e.ename, e.job, e.sal, e.deptno
FROM emp e, V
WHERE e.ename = V.ename
	AND e.job = V.job
	AND e.sal = V.sal;

-- lub
SELECT e.empno, e.ename, e.job, e.sal, e.deptno
FROM emp e JOIN V
ON (e.ename = V.ename
	AND e.job = V.job
	AND e.sal = V.sal);

--3.4. Uzyskiwanie z jednej tabeli tylko tych wartoœci, które nie wystêpuj¹ w innej tabeli
-- Problem: Chcemy odnaleŸæ w tabeli (Ÿród³owej) wartoœci, które nie maj¹ swoich odpowiedników w drugiej tabeli (docelowej). Chcemy zidentyfikowaæ te dzia³y firmy
-- (jeœli takowe istniej¹) reprezentowane w tabeli dept, które nie s¹ reprezentowane w tabeli emp.

SELECT deptno FROM dept
EXCEPT 
SELECT deptno FROM emp;

--3.5. Uzyskiwanie z jednej tabeli tylko tych wierszy, dla których nie istniej¹ odpowiedniki w innej tabeli
-- Problem: Chcemy odnaleŸæ wiersze, które wystêpuj¹ w jednej tabeli, ale nie maj¹ swoich odpowiedników w drugiej tabeli. Obie weryfikowane tabele maj¹ wspólne klucze.
-- Chcemy wskazaæ dzia³y firmy, które nie zatrudniaj¹ ¿adnych pracowników.

SELECT d.*
FROM dept d LEFT OUTER JOIN emp e
	ON (d.deptno = e.deptno)
WHERE e.deptno IS NULL;

--3.6. Dodawanie z³¹czeñ do zapytañ bez koniecznoœci modyfikowania pozosta³ych, ju¿ istniej¹cych z³¹czeñ
-- Problem: Dysponujemy zapytaniem, które zwraca wynik zgodny z naszymi oczekiwaniami. Po jakimœ czasie okazuje siê, ¿e potrzebujemy dodatkowych informacji, lecz próba
-- ich pozyskania powoduje utratê danych z oryginalnego zbioru wynikowego. Przyk³adowo, chcemy uzyskaæ dane wszystkich pracowników, nazw miast, w których znajduj¹ siê 
-- siedziby zatrudniaj¹ce tych pracowników, oraz daty wyp³at ostatnich premii.
--select * from emp_bonus
--empno	received	type
--7369	2005-03-14	1
--7900	2005-03-14	2
--7788	2005-03-14	3
-- Nasze oryginalne zapytanie ma nastêpuj¹c¹ postaæ:
--select e.ename, d.loc
--from emp e, dept d
--where e.deptno = d.deptno
-- Chcemy do³¹czyæ do tego zbioru wynikowego daty wyp³at ostatnich premii pracowniczych.

SELECT e.ename, d.loc, eb.received
FROM emp e JOIN dept d
	ON (e.deptno = d.deptno)
LEFT JOIN emp_bonus eb
	ON (e.empno = eb.empno)
ORDER BY 2;

--3.7. Okreœlanie, czy dwie tabele zawieraj¹ te same dane
-- Problem: Chcemy wiedzieæ, czy dwie tabele lub dwa widoki zawieraj¹ te same dane (zarównow w wymiarze licznoœci, jak i samych wartoœci). Przeanalizujmy widok
--create view v
--as 
--select * from emp where deptno != 10
--union all
--select * from emp where ename = 'WARD';
--select * from v
-- chcemy okreœliæ czy widok V zawiera dok³adnie te same dane co tabela emp.

SELECT *
	FROM (
SELECT e.empno, e.ename, e.job, e.mgr, e.hiredate, 
	   e.sal, e.comm, e.deptno, COUNT(*) AS cnt
	FROM emp e
GROUP BY empno, ename, job, mgr, hiredate, 
	   sal, comm, deptno
	   ) e
WHERE NOT EXISTS (
SELECT NULL
	FROM (
SELECT v.empno, v.ename, v.job, v.mgr, v.hiredate, 
	   v.sal, v.comm, v.deptno, COUNT(*) AS cnt
	FROM V
GROUP BY empno, ename, job, mgr, hiredate, 
	   sal, comm, deptno
	   ) v
WHERE v.empno = e.empno
	AND v.ename = e.ename
	AND v.job = e.job
	AND v.mgr = e.mgr
	AND v.hiredate = e.hiredate
	AND v.sal = e.sal
	AND v.deptno = e.deptno
	AND v.cnt = e.cnt
	AND COALESCE(v.comm, 0) = COALESCE(e.comm, 0)
)
UNION ALL
SELECT *
	FROM (
SELECT v.empno, v.ename, v.job, v.mgr, v.hiredate, 
	   v.sal, v.comm, v.deptno, COUNT(*) AS cnt
	FROM V
GROUP BY empno, ename, job, mgr, hiredate, 
	   sal, comm, deptno
	   ) v
WHERE NOT EXISTS (
SELECT NULL
	FROM (
SELECT e.empno, e.ename, e.job, e.mgr, e.hiredate, 
	   e.sal, e.comm, e.deptno, COUNT(*) AS cnt
	FROM emp e
GROUP BY empno, ename, job, mgr, hiredate, 
	   sal, comm, deptno
	   ) e
WHERE v.empno = e.empno
	AND v.ename = e.ename
	AND v.job = e.job
	AND v.mgr = e.mgr
	AND v.hiredate = e.hiredate
	AND v.sal = e.sal
	AND v.deptno = e.deptno
	AND v.cnt = e.cnt
	AND COALESCE(v.comm, 0) = COALESCE(e.comm, 0)
);

--3.8. Identyfikowanie i eliminowanie iloczynów kartezjañskich
-- Problem: Chcemy uzyskaæ nazwiska wszystkich pracowników zatrudnionych w dziesi¹tym dziale firmy wraz z nazw¹ miasta, w którym mieœci siê siedziba dzia³u. Poni¿sze
-- zapytanie zwraca wynik nieprawid³owy:
--select e.ename, d.loc from emp e, dept d
--where e.deptno = 10

SELECT e.ename, d.loc 
FROM emp e, dept d
WHERE e.deptno = 10
	AND e.deptno = d.deptno;

--3.11. Zwracanie brakuj¹cych danych z wielu tabel
-- Problem: Chcemy otrzymaæ brakuj¹ce dane z wielu tabel jednoczeœnie. Umieszczenie w zbiorze wynikowym tych wierszy sk³adowanych  w tabeli dept, które nie wystêpuj¹ 
-- w tabeli emp i tych wierszy z tabeli emp, które nie wystêpuj¹ w tabeli dept
-- Dodanie nowego pracownika
--insert into emp (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
--select 1111, 'Yoda', 'Jedi', null, hiredate, sal, comm, null from emp
--where ENAME= 'KING'

SELECT d.deptno, d.dname, e.ename
FROM dept d FULL OUTER JOIN emp e
	ON d.deptno = e.deptno;

--3.12. Wykorzystywanie wartoœci NULL w operacjach i porównaniach
-- Problem: Chcemy dokonaæ obliczeñ na zawartoœci koluny, która mo¿e zawieraæ wartoœci NULL, Chcemy traktowaæ tê kolumnê tak, jakby zawiera³a wy³¹cznie konkretne 
-- wartoœci. Przyk³adowo, chcemy odnaleŸæ w tabeli emp wszystkich pracowników, których wynagrodzenie prowizyjne (kolumn comm) jest mniejsze od prowizji wyp³acanych
-- pracownikowi o nazwisku Ward.

SELECT ename, comm
FROM emp
WHERE COALESCE(comm, 0) < (SELECT comm FROM emp WHERE ename = 'WARD');