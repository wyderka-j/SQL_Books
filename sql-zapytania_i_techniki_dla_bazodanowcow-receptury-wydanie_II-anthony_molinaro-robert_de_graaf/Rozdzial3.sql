--Rozdzia� 3. Praca z wieloma tabelami

--3.1. Umieszczanie jednego zbioru wierszy ponad drugim
-- Problem: Chcemy otrzyma� zbi�r wynikowy z danymi pochodz�cymi z wi�cej niz jednej tabeli. W praktyce jeden zbi�r wynikowy powinien zosta� umieszczony ponad drugim.
-- B�dziemy chcieli zbudowa� zbi�r wynikowy z nazwiskami pracownik�w zatrudnionych w dziesi�tym dziale firmy wraz z numerem tego dzia�u (niezb�dne dane s� sk�adowane w
-- tabeli emp) oraz nazwiskami i numerami wszystkich dzia��w tej samej firmy (te dane pochodz� z tabeli dept).

SELECT ename AS ename_and_dname, deptno
	FROM emp
	WHERE deptno = 10
UNION ALL
	SELECT '----------', NULL
	FROM t1
UNION ALL
	SELECT dname, deptno
	FROM dept;

--3.2. ��czenie wzajemnie powi�zanych wierszy
-- Problem: Chcemy skonstruowa� zbi�r wynikowy z�o�ony z wierszy pochodz�cych z wielu tabel- zbi�r ma powsta� przez z��czenie wed�ug wsp�lnej kolumny lub kolumn 
-- zawieraj�cych wsp�lne warto�ci. Przyk�adowo mo�emy stan�� przed konieczno�ci� uzyskania nazwisk wszystkich pracownik�w dziesi�tego dzia�u firmy wraz z miastem,
-- w kt�rym mie�ci si� siedziba tego dzia�u.

SELECT e.ename, d.loc 
FROM emp e, dept d
WHERE e.deptno = d.deptno
	AND e.deptno = 10;

--3.3. Odnajdywanie wsp�lnych wierszy pomi�dzy dwiema tabelami
--Problem: Chcemy odnale�� wsp�lne wiersze w dw�ch tabelach, lecz istnieje kilka kolumn, kt�re mog� pos�u�y� do z��czenia. Rozwa�my poni�szy widok utworzony na 
-- podstawie tabeli emp
--create view V
--as select ename, job, sal 
--	from emp 
--	where job = 'CLERK';
--select * from V;
-- Chcemy otrzyma� zbi�r wynikowy obejmuj�cy warto�ci zawarte w kolumnach empno, ename, job, sal i deptno wszystkich pracownik�w reprezentowanych w tabeli emp, kt�rzy
-- pasuj� do wierszy zwr�conych w widoku V.

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

--3.4. Uzyskiwanie z jednej tabeli tylko tych warto�ci, kt�re nie wyst�puj� w innej tabeli
-- Problem: Chcemy odnale�� w tabeli (�r�d�owej) warto�ci, kt�re nie maj� swoich odpowiednik�w w drugiej tabeli (docelowej). Chcemy zidentyfikowa� te dzia�y firmy
-- (je�li takowe istniej�) reprezentowane w tabeli dept, kt�re nie s� reprezentowane w tabeli emp.

SELECT deptno FROM dept
EXCEPT 
SELECT deptno FROM emp;

--3.5. Uzyskiwanie z jednej tabeli tylko tych wierszy, dla kt�rych nie istniej� odpowiedniki w innej tabeli
-- Problem: Chcemy odnale�� wiersze, kt�re wyst�puj� w jednej tabeli, ale nie maj� swoich odpowiednik�w w drugiej tabeli. Obie weryfikowane tabele maj� wsp�lne klucze.
-- Chcemy wskaza� dzia�y firmy, kt�re nie zatrudniaj� �adnych pracownik�w.

SELECT d.*
FROM dept d LEFT OUTER JOIN emp e
	ON (d.deptno = e.deptno)
WHERE e.deptno IS NULL;

--3.6. Dodawanie z��cze� do zapyta� bez konieczno�ci modyfikowania pozosta�ych, ju� istniej�cych z��cze�
-- Problem: Dysponujemy zapytaniem, kt�re zwraca wynik zgodny z naszymi oczekiwaniami. Po jakim� czasie okazuje si�, �e potrzebujemy dodatkowych informacji, lecz pr�ba
-- ich pozyskania powoduje utrat� danych z oryginalnego zbioru wynikowego. Przyk�adowo, chcemy uzyska� dane wszystkich pracownik�w, nazw miast, w kt�rych znajduj� si� 
-- siedziby zatrudniaj�ce tych pracownik�w, oraz daty wyp�at ostatnich premii.
--select * from emp_bonus
--empno	received	type
--7369	2005-03-14	1
--7900	2005-03-14	2
--7788	2005-03-14	3
-- Nasze oryginalne zapytanie ma nast�puj�c� posta�:
--select e.ename, d.loc
--from emp e, dept d
--where e.deptno = d.deptno
-- Chcemy do��czy� do tego zbioru wynikowego daty wyp�at ostatnich premii pracowniczych.

SELECT e.ename, d.loc, eb.received
FROM emp e JOIN dept d
	ON (e.deptno = d.deptno)
LEFT JOIN emp_bonus eb
	ON (e.empno = eb.empno)
ORDER BY 2;

--3.7. Okre�lanie, czy dwie tabele zawieraj� te same dane
-- Problem: Chcemy wiedzie�, czy dwie tabele lub dwa widoki zawieraj� te same dane (zar�wnow w wymiarze liczno�ci, jak i samych warto�ci). Przeanalizujmy widok
--create view v
--as 
--select * from emp where deptno != 10
--union all
--select * from emp where ename = 'WARD';
--select * from v
-- chcemy okre�li� czy widok V zawiera dok�adnie te same dane co tabela emp.

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

--3.8. Identyfikowanie i eliminowanie iloczyn�w kartezja�skich
-- Problem: Chcemy uzyska� nazwiska wszystkich pracownik�w zatrudnionych w dziesi�tym dziale firmy wraz z nazw� miasta, w kt�rym mie�ci si� siedziba dzia�u. Poni�sze
-- zapytanie zwraca wynik nieprawid�owy:
--select e.ename, d.loc from emp e, dept d
--where e.deptno = 10

SELECT e.ename, d.loc 
FROM emp e, dept d
WHERE e.deptno = 10
	AND e.deptno = d.deptno;

--3.11. Zwracanie brakuj�cych danych z wielu tabel
-- Problem: Chcemy otrzyma� brakuj�ce dane z wielu tabel jednocze�nie. Umieszczenie w zbiorze wynikowym tych wierszy sk�adowanych  w tabeli dept, kt�re nie wyst�puj� 
-- w tabeli emp i tych wierszy z tabeli emp, kt�re nie wyst�puj� w tabeli dept
-- Dodanie nowego pracownika
--insert into emp (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
--select 1111, 'Yoda', 'Jedi', null, hiredate, sal, comm, null from emp
--where ENAME= 'KING'

SELECT d.deptno, d.dname, e.ename
FROM dept d FULL OUTER JOIN emp e
	ON d.deptno = e.deptno;

--3.12. Wykorzystywanie warto�ci NULL w operacjach i por�wnaniach
-- Problem: Chcemy dokona� oblicze� na zawarto�ci koluny, kt�ra mo�e zawiera� warto�ci NULL, Chcemy traktowa� t� kolumn� tak, jakby zawiera�a wy��cznie konkretne 
-- warto�ci. Przyk�adowo, chcemy odnale�� w tabeli emp wszystkich pracownik�w, kt�rych wynagrodzenie prowizyjne (kolumn comm) jest mniejsze od prowizji wyp�acanych
-- pracownikowi o nazwisku Ward.

SELECT ename, comm
FROM emp
WHERE COALESCE(comm, 0) < (SELECT comm FROM emp WHERE ename = 'WARD');