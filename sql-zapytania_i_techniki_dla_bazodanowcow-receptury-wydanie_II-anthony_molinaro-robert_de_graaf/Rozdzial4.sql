-- Rozdzia³ 4. Wstawianie, aktualizowanie i usuwanie

-- 4.1. Wstawianie nowych rekordów
-- Problem: Chcemy wstawiæ nowy rekord do istniej¹cej tabeli. Przyk³adowo, chcemy wstawiæ nowy wiersz do tabeli DEPT. Nowy rekord powinien zawieraæ w kolumnie DEPTNO
-- wartoœæ 50, w kolumnie DNAME wartoœæ PROGRAMMING i w kolumnie LOC wartoœæ BALTIMORE.

INSERT INTO dept (deptno, dname, loc)
VALUES (50, 'PROGRAMMING', 'BALTOMORE');

-- 4.2. Wstawianie wartoœci domyœlnych
-- Problem: Chcemy, aby w okreœlonej kolumnie naszej tabwli by³y wstawiane wartoœci domyœlne zawsze  wtedy, gdy u¿ytkownik nie zdefiniuje konkretnej wartoœci podczas
-- dodawania wiersza. Przeanalizujmy nastêpuj¹c¹ tabelê:
--create table D (id integer default 0)
-- Chcemy, aby w kolumnie ID by³a wstawiana wartoœæ zerowa bez koniecznoœci definiowania tej wartoœci wprost na liœcie po s³owie kluczowym VALUES w wyra¿eniu INSERT. 

INSERT INTO D DEFAULT VALUES;

-- 4.3. Zastêpowanie wartoœci domyœlnych wartoœci¹ NULL
-- Problem: Wstawiamy wiersz do tabeli zawieraj¹cej kolumnê, dla której zdefiniowano wartoœæ domyœln¹, ale chcemy umieœciæ w³aœnie w tej kolumnie wartoœæ NULL. 
-- Przeanalizujmy nastêpuj¹c¹ tabelê:
--create table D (id integer default 0, foo varchar(10))
-- Chcemy wstawiæ do tabeli D nowy wiersz zawieraj¹cy wartoœæ NULL w kolumnie ID.

INSERT INTO D (id, foo) VALUES (NULL, 'Brighten');

-- 4.4. Kopiowanie wierszy pomiêdzy tabelami
-- Problem: Chcemy skopiowaæ wiersze z jednej tabeli do drugiej za pomoc¹ pojedynczego zapytania. Przyk³adowo, chcemy skopiowaæ wiersze z tabeli dept do tabeli dept_east.
-- Przyjmijmy, ¿e tabela dept_east zosta³a utworzona, jej struktura i typ kolumn) jest identyczna ze struktur¹ tabeli dept i obecnie nie zawiera ¿adnych danych.

INSERT INTO dept_east (deptno, dname, loc)
SELECT deptno, dname, loc
FROM dept
WHERE loc IN ('NEW YORK', 'BOSTON');

-- 4.5. Kopiowanie definicji tabel
-- Problem: Chcemy stworzyæ now¹ tabelê, która bêdzie siê sk³ada³a z takich samych kolumn jak tabela ju¿ istniej¹ca. Przyjmijmy, ¿e chcemy stworzyæ kopiê tabeli dept
-- nazwan¹ dept_2. Nie chcemy kopiowaæ wierszy tabeli- naszym celem jest wy³¹cznie powielenie struktury kolumn tej tabeli.

SELECT *
INTO dept_2
FROM dept
WHERE 1 = 0;

-- 4.7. Blokowanie mo¿liwoœci wstawiania wartoœci do wybranych kolumn
-- Problem: Chcemy uniemo¿liwiæ u¿ytkownikow lub Ÿle napisanym aplikacjom wstawianie wartoœci do okreœlonych kolumn tabeli. Chcemy zazwoliæ ptogramom zewnêtrznym na
-- wstawianie nowych wierszy do tabeli emp, ale tylko do kolumn empno, ename i job.

CREATE VIEW new_emps AS
SELECT empno, ename, job
FROM emp;

-- 4.8. Modyfikowanie rekordów tabeli
-- Problem: Chcemy zmodyfikowaæ wartoœci sk³adowane w wybranej czêœci lub we wszystkich wierszach jakiejœ tabeli. Chcemy podnieœæ pensje wszystkich pracowników dzia³u
-- dwudziestego o 10 procent.

UPDATE emp
SET sal = sal * 1.10
WHERE deptno = 20;

-- 4.9. Aktualizowanie danych pod warunkiem istnienia w tabeli okreœlonych wierszy
-- Problem: Chcemy zaktualizowaæ wiersze jednej tabeli pod warunkiem istnienia odpowiadaj¹cych im wierszy w innej tabeli. Chcemy zwiêkszyæ o 20% pensje (w tabeli emp)
-- wszystkich pracowników, którzy s¹ wymienieni w tabeli emp_bonus.
--select empno, ename
--from emp_bonus;
--EMPNO	ENAME
--7369	SMITH
--7900	JAMES
--7934	MILLER	

UPDATE emp
SET sal = sal * 1.20
WHERE empno IN (SELECT empno FROM emp_bonus);

-- 4.10. Aktualizowanie wartoœci wed³ug zawartoœci innej tabeli
-- Problem: chcemy zaktualizowaæ wiersze jednej z tabel za pomoc¹ wartoœci sk³adowanych w innej tabeli. Dysponujemy tabel¹ new_sal, w której s¹ sk³adowane nowe wysokoœci
-- wynagrodzeñ wybranej grupy pracowników.
--select * from new_sal
--DEPTNO	SAL
--10		4000
-- Chcemy zaktualizowaæ reprezentowan¹ w tabeli emp wysokoœæ wynagrodzeñ i prowizji wyp³acanych niektórym pracownikom wed³ug wartoœci reprezentowanych w tabeli new_sal
-- jeœli wartoœæ koluny emp.deptno jest równa wartoœci kolumny new_sal.deptno nale¿y zaktualizowaæ odpowiedni wiersz tabeli emp, przypisuj¹c kolumnie emp.sal wartoœæ 
-- sk³adowan¹ w kolumnie new_sal.sal i przypisuj¹c kolumnie emp.com 50 procent wartoœci sk³adowanej w kolumnie new_sal.sal.

UPDATE e
SET e.sal = ns.sal,
	e.comm = ns.sal/2
FROM emp e,
	new_sal ns
WHERE ns.deptno = e.deptno;

-- 4.11. Scalanie rekordów
-- Problem: Chcemy uzale¿niæ operacje wstawiania, aktualizowania lub usuwania rekordów tabeli od tego, czy dana tabela zawiera odpowiednie rekordy (jeœli wskazany
-- rekord instnieje, nale¿y go zaktualizowaæ, jeœli nie, nale¿y wstawiæ nowy rekord; jeœli po aktualizacji wiersz nie spe³nia okreœlonych kryteriów, nale¿y go usun¹æ)
-- Chcemy zmodyfikowaæc tabelê emp_commission w nastêpuj¹cy sposób
-- Jeœli któryœ z pracowników w tabeli emp_commission jest reprezentowany tak¿e w talebi emp, nale¿y ustaliæ prowizjê wyp³acan¹ temu pracownikowi (w kolumnie comm) na
-- poziomie 1000.
-- Dla ka¿dego pracownika zakwalifikowanego jako potencjalnego kandydata do aktualizacji wysokoœci prowizji comm do 1000 nale¿y sprawdziæ, czy jego podstawowe 
-- wynagrodzenie jest mniejsze od 2000- jeœli tak, nale¿y go usun¹æ
-- W przeciwnym razie nale¿y wstawiæ odpowiednie wartoœci kolumn empno, ename i deptno z tabeli emp do nowego wiersza tabeli emp_commission
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
-- Problem: Chcemy usun¹æ wszystkie rekordy z jakiejœ tabeli.

DELETE FROM emp;

-- 4.13. Usuwanie rekordów spe³niaj¹cych okreœlone kryteria
-- Problem: Chcemy usun¹æ z tabeli rekordy spe³niaj¹ce pewne kryteria.

DELETE FROM emp WHERE deptno = 10;

-- 4.14. Usuwanie pojedynczych rekordów
-- Problem: Chcemy usun¹æ z tabeli tylko jeden rekord.

DELETE FROM emp WHERE empno = 7782;

-- 4.15. Usuwanie wierszy naruszaj¹cych integralnoœæ referencyjn¹
-- Problem: Chcemy usun¹æ z tabeli rekordy, które odwo³uj¹ siê do nieistniej¹cych rekordów w innej tabeli. Przypuœæmy ¿e czêœæ pracowników b³êdnie przypisano do 
-- nieistniej¹cych dzia³ów firmy.

DELETE FROM emp
WHERE NOT EXISTS (
	SELECT * FROM dept
	WHERE dept.deptno = emp.deptno;

-- 4.16. Usuwanie powtarzaj¹cych siê rekordów
-- Problem: Chcemy usun¹æ z tabeli powtarzaj¹ce siê rekordy
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
-- Problem: Chcemy usun¹æ z tabeli tylko te rekordy, na które wska¿a dane pozyskane z innej tabeli. 
--create table dept_acciedents
--(deptno integer,
--accident_name varchar(20));
--insert into dept_acciedents values (10, 'BROKEN FOOT')
--insert into dept_acciedents values (10, 'FLESH WOUND')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FIRE')
--insert into dept_acciedents values (20, 'FLOOD')
--insert into dept_acciedents values (30, 'BRUISED GLUTE')
-- Chcemy usun¹æ z tabeli emp rekordy reprezentuj¹ce pracowników zatrudnionych w dziale, w którym mia³y miejsce co najmniej trzy wypadki.

DELETE FROM emp
WHERE deptno IN (SELECT deptno 
				FROM dept_acciedents
				GROUP BY deptno
				HAVING	COUNT(*) >= 3)