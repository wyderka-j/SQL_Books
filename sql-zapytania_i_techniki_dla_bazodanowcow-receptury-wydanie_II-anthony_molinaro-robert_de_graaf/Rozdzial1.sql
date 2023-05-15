--Rozdzia³ 1. Odczytywanie rekordów

--1.1. Odczytywanie wszystkich wierszy i kolumn tabeli
--Problem: Dysponujemy tabel¹ bazy danych i chcemy siê zapoznaæ ze wszystkimi zawartymi w niej danymi

SELECT *
FROM emp;

--1.2. Odczytywanie podzbioru wierszy tabeli
--Problem: Dysponujemy tabel¹ bazy danych i chcemy zapoznaæ siê wy³¹cznie z zawartoœci¹ tych wierszy, które spe³niaj¹ okreœlony warunek

SELECT * 
FROM emp
WHERE deptno = 10;

--1.3. Odnajdywanie wierszy spe³niaj¹cych wiele warunków
--Problem: Chcemy uzyskaæ wiersze, które spe³niaj¹ wiele warunków

SELECT * 
FROM emp
WHERE deptno = 10
	OR comm IS NOT NULL
	OR sal <= 2000 AND deptno = 20;

--1.4. Odczytywanie podzbioru kolumn tabeli
--Problem: Dysponujemy tabel¹ bazy danych i chcemy siê zapoznaæ z wartoœciami okreœlonych kolumn zamiast z zawartoœci¹ wszystkich kolumn danej tabeli

SELECT ename, deptno, sal
FROM emp;

--1.5. Definiowanie sensownych nazw kolumn
--Problem: Chcielibyœmy tak zmieniæ nazwy kolumn uwzglêdnianych w zbiorze wynikowym wygenerowanym przez zapytanie, aby by³y bardziej czytelne. Przeanalizujmy zapytanie
-- zawieraj¹ce wysokoœæ wynagrodzeñ i prowizji otrzymanych przez pracowników:
-- SELECT sal, comm
-- FROM emp

SELECT sal AS salary, comm AS commission
FROM emp;

--1.6. Odwo³ania do aliasów kolumn w klauzuli WHERE
--Problem: U¿ywaliœmy ju¿ aliasów do definiowania bardziej zrozumia³ych nazw kolumn, tym razam chcielibyœmy dodatkowo wy³¹czyæ czêœæ wierszy za pomoc¹ klauzuli WHERE.
-- Okazuje siê jednak, ¿e próba bezpoœredniego odwo³ania do nazw aliasów tej klauzuli koñczy siê niepowodzeniem:
-- SELECT sal AS salary, comm AS commission
-- FROM emp
-- WHERE salary < 5000

SELECT * 
FROM (
SELECT sal AS salary, comm AS commission
FROM emp
) x
WHERE salary < 5000;

--1.7. Konkatenacja wartoœci kolumn
--Problem: Chcemy zwróciæ wartoœci sk³adowane w wielu kolumnach w formie pojedynczej kolumny. WyobraŸmy sobie, ¿e chcemy skonstruowaæ zapytanie, które na podstawie
-- tabeli emp wygeneruje nastêpuj¹cy zbiór wynikowy
-- CLARK WORKS AS A MANAGER
-- KING WORKS AS A PRESIDENT
-- MILLER WORKS AS A CLERK
-- Dane potrzebne do wygenerowania tego rodzaju wyników pochodz¹ z dwóch ró¿nych kolumn tabeli emp:
-- SELECT ename, job FROM emp WHERE deptno = 10

SELECT ename + ' WORKS AS A ' + job as msg
FROM emp
WHERE deptno = 10;

--1.8. Stosowanie logiki warunkowej w wyra¿eniu SELECT
--Problem: Chcemy wykonaæ operacje IF-ELSE na wartoœæiach zwróconych przez wyra¿enie SELECT. Przyk³adowo, planujemy uzyskaæ zbiór wynikowy, w którym kolumna STATUS
-- bêdzie zawiera³a wartoœæ UNDERPAID dla pracowników zarabiaj¹cych nie wiêcej ni¿ 2000 dolarów, wartoœæ OVERPAID dla pracowników zarabiaj¹cych co najmniej 4000 dolarów 
-- lub wartoœæ OK dla pracowników, których zarobki mieszcz¹ siê w przedziale od 2000 do 4000.

SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'UNDERPAID'
		 WHEN sal >= 4000 THEN 'OVERPAID'
		 else 'OK'
	END AS stutus
FROM emp;

--1.9. Ograniczanie liczby zwracanych wierszy
--Problem: Chcemy ograniczyæ liczbê wierszy zwracanych przez nasze zapytanie. Nie interesuje nas porz¹dek wierszy w zbiorze wynikowym- chcemy tylko, by ich liczba 
-- wynosi³a dok³adnie n.

SELECT TOP 5 *
FROM emp;

--1.10. Zwracanie n losowych rekordów tabeli
--Problem: Chcemy zwróciæ okreœlon¹ loczbê losowo wybranych rekordów z tabeli. Naszym celem jest taka modyfikacja poni¿szego wyra¿enia, która spowoduje, ¿e nastêpujace
-- po sobie wywo³ania bêd¹ zwraca³y ró¿ne zbiory, przy czym ka¿dy z nich bêdzie siê sk³ada³ z piêciu losowo wybranych wierszy.
-- select ename, job from emp

SELECT TOP 5 ename, job
FROM emp
ORDER BY NEWID();

--1.11. Odnajdywanie wartoœci pustych (NULL)
--Problem: Chcemy odnaleŸæ wszystkie wiersze, które zawieraj¹ wartoœci puste w okreœlonej kolumnie.

SELECT * 
FROM emp
WHERE comm IS NULL;

--1.12. Przekszta³canie wartoœci pustych w rzeczywiste
--Problem: Mamy do czynienia z wierszami zawieraj¹cymi wartoœci puste i chcielibyœmy, aby w ich miejsce by³y zwracane inne, konkretne wartoœci.

SELECT COALESCE(comm, 0)
FROM emp;

--1.13. Poszukiwanie wzorców
--Problem: Chcemy zwróciæ wiersze spe³niaj¹ce okreœlone kryteria- wiersze, których zawartoœæ mo¿na dopasowaæ do okreœlonego pod³añcucha lub wzorca. Przeanalizujmy
-- poni¿sze zapytanie
-- select ename, job from emp where deptno in (10, 20)
-- Chcemy, aby zbiór wynikowy zawiera³ nazwiska i stanowiska pracy tylko tych pracowników dziesi¹tego i dwudziestego dzia³u, których nazwiska zawieraj¹ literê I lub
-- których nazwa stanowiska przacy koñczy siê literami ER.

SELECT ename, job
FROM emp
WHERE deptno IN (10, 20)
	AND (ename LIKE '%I%' OR job LIKE '%ER');