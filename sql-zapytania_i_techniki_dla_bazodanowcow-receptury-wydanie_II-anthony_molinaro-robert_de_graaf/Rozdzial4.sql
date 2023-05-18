-- Rozdział 4. Wstawianie, aktualizowanie i usuwanie

-- 4.1. Wstawianie nowych rekordów
-- Problem: Chcemy wstawić nowy rekord do istniejącej tabeli. Przykładowo, chcemy wstawić nowy wiersz do tabeli DEPT. Nowy rekord powinien zawierać w kolumnie DEPTNO
-- wartość 50, w kolumnie DNAME wartość PROGRAMMING i w kolumnie LOC wartość BALTIMORE.

INSERT INTO dept (deptno, dname, loc)
VALUES (50, 'PROGRAMMING', 'BALTOMORE');

-- 4.2. Wstawianie wartości domyślnych
-- Problem: Chcemy, aby w określonej kolumnie naszej tabwli były wstawiane wartości domyślne zawsze  wtedy, gdy użytkownik nie zdefiniuje konkretnej wartości podczas
-- dodawania wiersza. Przeanalizujmy następującą tabelę:
--create table D (id integer default 0)
-- Chcemy, aby w kolumnie ID była wstawiana wartość zerowa bez konieczności definiowania tej wartości wprost na liście po słowie kluczowym VALUES w wyrażeniu INSERT. 

INSERT INTO D DEFAULT VALUES;

-- 4.3. Zastępowanie wartości domyślnych wartością NULL
-- Problem: Wstawiamy wiersz do tabeli zawierającej kolumnę, dla której zdefiniowano wartość domyślną, ale chcemy umieścić właśnie w tej kolumnie wartość NULL. 
-- Przeanalizujmy następującą tabelę:
--create table D (id integer default 0, foo varchar(10))
-- Chcemy wstawić do tabeli D nowy wiersz zawierający wartość NULL w kolumnie ID.

INSERT INTO D (id, foo) VALUES (NULL, 'Brighten');

-- 4.4. Kopiowanie wierszy pomiędzy tabelami
-- Problem: Chcemy skopiować wiersze z jednej tabeli do drugiej za pomocą pojedynczego zapytania. Chcemy skopiować wiersze z tabeli dept do tabeli dept_east.
-- Przyjmijmy, że tabela dept_east została utworzona, jej struktura i typ kolumn) jest identyczna ze strukturą tabeli dept i obecnie nie zawiera żadnych danych.

INSERT INTO dept_east (deptno, dname, loc)
SELECT deptno, dname, loc
FROM dept
WHERE loc IN ('NEW YORK', 'BOSTON');

-- 4.5. Kopiowanie definicji tabel
-- Problem: Chcemy stworzyć nową tabelę, która będzie się składała z takich samych kolumn jak tabela już istniejąca. Przyjmijmy, że chcemy stworzyć kopię tabeli dept
-- nazwaną dept_2. Nie chcemy kopiować wierszy tabeli- naszym celem jest wyłącznie powielenie struktury kolumn tej tabeli.

SELECT *
INTO dept_2
FROM dept
WHERE 1 = 0;

-- 4.7. Blokowanie możliwości wstawiania wartości do wybranych kolumn
-- Problem: Chcemy uniemożliwić użytkownikow lub źle napisanym aplikacjom wstawianie wartości do określonych kolumn tabeli. Chcemy zazwolić ptogramom zewnętrznym na
-- wstawianie nowych wierszy do tabeli emp, ale tylko do kolumn empno, ename i job.

CREATE VIEW new_emps AS
SELECT empno, ename, job
FROM emp;

-- 4.8. Modyfikowanie rekordów tabeli
-- Problem: Chcemy zmodyfikować wartości składowane w wybranej części lub we wszystkich wierszach jakiejś tabeli. Chcemy podnieść pensje wszystkich pracowników działu
-- dwudziestego o 10 procent.

UPDATE emp
SET sal = sal * 1.10
WHERE deptno = 20;

-- 4.9. Aktualizowanie danych pod warunkiem istnienia w tabeli określonych wierszy
-- Problem: Chcemy zaktualizować wiersze jednej tabeli pod warunkiem istnienia odpowiadających im wierszy w innej tabeli. Chcemy zwiększyć o 20% pensje (w tabeli emp)
-- wszystkich pracowników, którzy są wymienieni w tabeli emp_bonus.
--select empno, ename
--from emp_bonus;
--EMPNO	ENAME
--7369	SMITH
--7900	JAMES
--7934	MILLER	

UPDATE emp
SET sal = sal * 1.20
WHERE empno IN (SELECT empno FROM emp_bonus);

-- 4.10. Aktualizowanie wartości według zawartości innej tabeli
-- Problem: chcemy zaktualizować wiersze jednej z tabel za pomocą wartości składowanych w innej tabeli. Dysponujemy tabelą new_sal, w której są składowane nowe 
-- wysokości wynagrodzeń wybranej grupy pracowników.
--select * from new_sal
--DEPTNO	SAL
--10		4000
-- Chcemy zaktualizować reprezentowaną w tabeli emp wysokość wynagrodzeń i prowizji wypłacanych niektórym pracownikom według wartości reprezentowanych w tabeli new_sal
-- jeśli wartość koluny emp.deptno jest równa wartości kolumny new_sal.deptno należy zaktualizować odpowiedni wiersz tabeli emp, przypisując kolumnie emp.sal wartość 
-- składowaną w kolumnie new_sal.sal i przypisując kolumnie emp.com 50 procent wartości składowanej w kolumnie new_sal.sal.

UPDATE e
SET e.sal = ns.sal,
	e.comm = ns.sal/2
FROM emp e,
	new_sal ns
WHERE ns.deptno = e.deptno;

-- 4.11. Scalanie rekordów
-- Problem: Chcemy uzależnić operacje wstawiania, aktualizowania lub usuwania rekordów tabeli od tego, czy dana tabela zawiera odpowiednie rekordy (jeśli wskazany
-- rekord instnieje, należy go zaktualizować, jeśli nie, należy wstawić nowy rekord; jeśli po aktualizacji wiersz nie spełnia określonych kryteriów, należy go usunąć)
-- Chcemy zmodyfikowaćc tabelę emp_commission w następujący sposób
-- Jeśli któryś z pracowników w tabeli emp_commission jest reprezentowany także w talebi emp, należy ustalić prowizję wypłacaną temu pracownikowi (w kolumnie comm) na
-- poziomie 1000.
-- Dla każdego pracownika zakwalifikowanego jako potencjalnego kandydata do aktualizacji wysokości prowizji comm do 1000 należy sprawdzić, czy jego podstawowe 
-- wynagrodzenie jest mniejsze od 2000- jeśli tak, należy go usunąć
-- W przeciwnym razie należy wstawić odpowiednie wartości kolumn empno, ename i deptno z tabeli emp do nowego wiersza tabeli emp_commission
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

-- 4.12. Usuwanie wszystkich rekordów z tabeli
-- Problem: Chcemy usunąć wszystkie rekordy z jakiejś tabeli.

DELETE FROM emp;

-- 4.13. Usuwanie rekordów spełniających określone kryteria
-- Problem: Chcemy usunąć z tabeli rekordy spełniające pewne kryteria.

DELETE FROM emp WHERE deptno = 10;

-- 4.14. Usuwanie pojedynczych rekordów
-- Problem: Chcemy usunąć z tabeli tylko jeden rekord.

DELETE FROM emp WHERE empno = 7782;

-- 4.15. Usuwanie wierszy naruszających integralność referencyjną
-- Problem: Chcemy usunąć z tabeli rekordy, które odwołują się do nieistniejących rekordów w innej tabeli. Przypuśćmy że część pracowników błędnie przypisano do 
-- nieistniejących działów firmy.

DELETE FROM emp
WHERE NOT EXISTS (
	SELECT * FROM dept
	WHERE dept.deptno = emp.deptno;

-- 4.16. Usuwanie powtarzających się rekordów
-- Problem: Chcemy usunąć z tabeli powtarzające się rekordy
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

-- 4.17. Usuwanie rekordów na podstawie danych z innej tabeli
-- Problem: Chcemy usunąć z tabeli tylko te rekordy, na które wskaża dane pozyskane z innej tabeli. 
--create table dept_acciedents
--(deptno integer,
--accident_name varchar(20));
--insert into dept_acciedents values (10, 'BROKEN FOOT')
--insert into dept_acciedents values (10, 'FLESH WOUND')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FLOOD')
--insert into dept_acciedents values (30, 'BRUISED GLUTE')
-- Chcemy usunąć z tabeli emp rekordy reprezentujące pracowników zatrudnionych w dziale, w którym miały miejsce co najmniej trzy wypadki.

DELETE FROM emp
WHERE deptno IN (SELECT deptno 
				FROM dept_acciedents
				GROUP BY deptno
				HAVING	COUNT(*) >= 3)
