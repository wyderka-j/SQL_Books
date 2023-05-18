-- Rozdzia� 4. Wstawianie, aktualizowanie i usuwanie

-- 4.1. Wstawianie nowych rekord�w
-- Problem: Chcemy wstawi� nowy rekord do istniej�cej tabeli. Przyk�adowo, chcemy wstawi� nowy wiersz do tabeli DEPT. Nowy rekord powinien zawiera� w kolumnie DEPTNO
-- warto�� 50, w kolumnie DNAME warto�� PROGRAMMING i w kolumnie LOC warto�� BALTIMORE.

INSERT INTO dept (deptno, dname, loc)
VALUES (50, 'PROGRAMMING', 'BALTOMORE');

-- 4.2. Wstawianie warto�ci domy�lnych
-- Problem: Chcemy, aby w okre�lonej kolumnie naszej tabwli by�y wstawiane warto�ci domy�lne zawsze  wtedy, gdy u�ytkownik nie zdefiniuje konkretnej warto�ci podczas
-- dodawania wiersza. Przeanalizujmy nast�puj�c� tabel�:
--create table D (id integer default 0)
-- Chcemy, aby w kolumnie ID by�a wstawiana warto�� zerowa bez konieczno�ci definiowania tej warto�ci wprost na li�cie po s�owie kluczowym VALUES w wyra�eniu INSERT. 

INSERT INTO D DEFAULT VALUES;

-- 4.3. Zast�powanie warto�ci domy�lnych warto�ci� NULL
-- Problem: Wstawiamy wiersz do tabeli zawieraj�cej kolumn�, dla kt�rej zdefiniowano warto�� domy�ln�, ale chcemy umie�ci� w�a�nie w tej kolumnie warto�� NULL. 
-- Przeanalizujmy nast�puj�c� tabel�:
--create table D (id integer default 0, foo varchar(10))
-- Chcemy wstawi� do tabeli D nowy wiersz zawieraj�cy warto�� NULL w kolumnie ID.

INSERT INTO D (id, foo) VALUES (NULL, 'Brighten');

-- 4.4. Kopiowanie wierszy pomi�dzy tabelami
-- Problem: Chcemy skopiowa� wiersze z jednej tabeli do drugiej za pomoc� pojedynczego zapytania. Przyk�adowo, chcemy skopiowa� wiersze z tabeli dept do tabeli dept_east.
-- Przyjmijmy, �e tabela dept_east zosta�a utworzona, jej struktura i typ kolumn) jest identyczna ze struktur� tabeli dept i obecnie nie zawiera �adnych danych.

INSERT INTO dept_east (deptno, dname, loc)
SELECT deptno, dname, loc
FROM dept
WHERE loc IN ('NEW YORK', 'BOSTON');

-- 4.5. Kopiowanie definicji tabel
-- Problem: Chcemy stworzy� now� tabel�, kt�ra b�dzie si� sk�ada�a z takich samych kolumn jak tabela ju� istniej�ca. Przyjmijmy, �e chcemy stworzy� kopi� tabeli dept
-- nazwan� dept_2. Nie chcemy kopiowa� wierszy tabeli- naszym celem jest wy��cznie powielenie struktury kolumn tej tabeli.

SELECT *
INTO dept_2
FROM dept
WHERE 1 = 0;

-- 4.7. Blokowanie mo�liwo�ci wstawiania warto�ci do wybranych kolumn
-- Problem: Chcemy uniemo�liwi� u�ytkownikow lub �le napisanym aplikacjom wstawianie warto�ci do okre�lonych kolumn tabeli. Chcemy zazwoli� ptogramom zewn�trznym na
-- wstawianie nowych wierszy do tabeli emp, ale tylko do kolumn empno, ename i job.

CREATE VIEW new_emps AS
SELECT empno, ename, job
FROM emp;

-- 4.8. Modyfikowanie rekord�w tabeli
-- Problem: Chcemy zmodyfikowa� warto�ci sk�adowane w wybranej cz�ci lub we wszystkich wierszach jakiej� tabeli. Chcemy podnie�� pensje wszystkich pracownik�w dzia�u
-- dwudziestego o 10 procent.

UPDATE emp
SET sal = sal * 1.10
WHERE deptno = 20;

-- 4.9. Aktualizowanie danych pod warunkiem istnienia w tabeli okre�lonych wierszy
-- Problem: Chcemy zaktualizowa� wiersze jednej tabeli pod warunkiem istnienia odpowiadaj�cych im wierszy w innej tabeli. Chcemy zwi�kszy� o 20% pensje (w tabeli emp)
-- wszystkich pracownik�w, kt�rzy s� wymienieni w tabeli emp_bonus.
--select empno, ename
--from emp_bonus;
--EMPNO	ENAME
--7369	SMITH
--7900	JAMES
--7934	MILLER	

UPDATE emp
SET sal = sal * 1.20
WHERE empno IN (SELECT empno FROM emp_bonus);

-- 4.10. Aktualizowanie warto�ci wed�ug zawarto�ci innej tabeli
-- Problem: chcemy zaktualizowa� wiersze jednej z tabel za pomoc� warto�ci sk�adowanych w innej tabeli. Dysponujemy tabel� new_sal, w kt�rej s� sk�adowane nowe wysoko�ci
-- wynagrodze� wybranej grupy pracownik�w.
--select * from new_sal
--DEPTNO	SAL
--10		4000
-- Chcemy zaktualizowa� reprezentowan� w tabeli emp wysoko�� wynagrodze� i prowizji wyp�acanych niekt�rym pracownikom wed�ug warto�ci reprezentowanych w tabeli new_sal
-- je�li warto�� koluny emp.deptno jest r�wna warto�ci kolumny new_sal.deptno nale�y zaktualizowa� odpowiedni wiersz tabeli emp, przypisuj�c kolumnie emp.sal warto�� 
-- sk�adowan� w kolumnie new_sal.sal i przypisuj�c kolumnie emp.com 50 procent warto�ci sk�adowanej w kolumnie new_sal.sal.

UPDATE e
SET e.sal = ns.sal,
	e.comm = ns.sal/2
FROM emp e,
	new_sal ns
WHERE ns.deptno = e.deptno;

-- 4.11. Scalanie rekord�w
-- Problem: Chcemy uzale�ni� operacje wstawiania, aktualizowania lub usuwania rekord�w tabeli od tego, czy dana tabela zawiera odpowiednie rekordy (je�li wskazany
-- rekord instnieje, nale�y go zaktualizowa�, je�li nie, nale�y wstawi� nowy rekord; je�li po aktualizacji wiersz nie spe�nia okre�lonych kryteri�w, nale�y go usun��)
-- Chcemy zmodyfikowa�c tabel� emp_commission w nast�puj�cy spos�b
-- Je�li kt�ry� z pracownik�w w tabeli emp_commission jest reprezentowany tak�e w talebi emp, nale�y ustali� prowizj� wyp�acan� temu pracownikowi (w kolumnie comm) na
-- poziomie 1000.
-- Dla ka�dego pracownika zakwalifikowanego jako potencjalnego kandydata do aktualizacji wysoko�ci prowizji comm do 1000 nale�y sprawdzi�, czy jego podstawowe 
-- wynagrodzenie jest mniejsze od 2000- je�li tak, nale�y go usun��
-- W przeciwnym razie nale�y wstawi� odpowiednie warto�ci kolumn empno, ename i deptno z tabeli emp do nowego wiersza tabeli emp_commission
--select deptno, empno, ename, comm
--from emp_commission
--order by 1
--DEPTNO	EMPNO	ENAME	COMM
--10		7782	CLARK
--10		7839	KING
--10		7934	MILLER

MERGE INTO emp_commission ec
USING (SELECT * FROM emp) emp
	ON (ec.empno = emp.empno)
WHEN MATCHED THEN
	UPDATE SET ec.comm = 1000
	DELETE WHERE (sal < 2000)
WHEN NOT MATCHED THEN
	INSERT (ec.empno, ec.ename, ec.deptno, ec.comm)
	VALUES (emp.empno, emp.ename, emp.deptno, emp.comm);

-- 4.12. Usuwanie wszystkich rekord�w z tabeli
-- Problem: Chcemy usun�� wszystkie rekordy z jakiej� tabeli.

DELETE FROM emp;

-- 4.13. Usuwanie rekord�w spe�niaj�cych okre�lone kryteria
-- Problem: Chcemy usun�� z tabeli rekordy spe�niaj�ce pewne kryteria.

DELETE FROM emp WHERE deptno = 10;

-- 4.14. Usuwanie pojedynczych rekord�w
-- Problem: Chcemy usun�� z tabeli tylko jeden rekord.

DELETE FROM emp WHERE empno = 7782;

-- 4.15. Usuwanie wierszy naruszaj�cych integralno�� referencyjn�
-- Problem: Chcemy usun�� z tabeli rekordy, kt�re odwo�uj� si� do nieistniej�cych rekord�w w innej tabeli. Przypu��my �e cz�� pracownik�w b��dnie przypisano do 
-- nieistniej�cych dzia��w firmy.

DELETE FROM emp
WHERE NOT EXISTS (
	SELECT * FROM dept
	WHERE dept.deptno = emp.deptno;

-- 4.16. Usuwanie powtarzaj�cych si� rekord�w
-- Problem: Chcemy usun�� z tabeli powtarzaj�ce si� rekordy
-- create table dupes (id integer, name varchar(10))
--insert into dupes values (1, 'NAPOLEON')
--insert into dupes values (2, 'DYNAMITE')
--insert into dupes values (3, 'DYNAMITE')
--insert into dupes values (4, 'SHE SELLS')
--insert into dupes values (5, 'SEA SHELLS')
--insert into dupes values (6, 'SEA SHELLS')
--insert into dupes values (7, 'SEA SHELLS')

DELETE FROM dupes
WHERE id NOT IN (SELECT MIN(id) FROM dupes GROUP BY name);

-- 4.17. Usuwanie rekord�w na podstawie danych z innej tabeli
-- Problem: Chcemy usun�� z tabeli tylko te rekordy, na kt�re wska�a dane pozyskane z innej tabeli. 
--create table dept_acciedents
--(deptno integer,
--accident_name varchar(20));
--insert into dept_acciedents values (10, 'BROKEN FOOT')
--insert into dept_acciedents values (10, 'FLESH WOUND')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FLOOD')
--insert into dept_acciedents values (30, 'BRUISED GLUTE')
-- Chcemy usun�� z tabeli emp rekordy reprezentuj�ce pracownik�w zatrudnionych w dziale, w kt�rym mia�y miejsce co najmniej trzy wypadki.

DELETE FROM emp
WHERE deptno IN (SELECT deptno 
				FROM dept_acciedents
				GROUP BY deptno
				HAVING	COUNT(*) >= 3)