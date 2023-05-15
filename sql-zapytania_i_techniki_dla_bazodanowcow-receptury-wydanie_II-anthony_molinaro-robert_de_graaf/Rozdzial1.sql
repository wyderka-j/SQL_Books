--Rozdzia� 1. Odczytywanie rekord�w

--1.1. Odczytywanie wszystkich wierszy i kolumn tabeli
--Problem: Dysponujemy tabel� bazy danych i chcemy si� zapozna� ze wszystkimi zawartymi w niej danymi

SELECT *
FROM emp;

--1.2. Odczytywanie podzbioru wierszy tabeli
--Problem: Dysponujemy tabel� bazy danych i chcemy zapozna� si� wy��cznie z zawarto�ci� tych wierszy, kt�re spe�niaj� okre�lony warunek

SELECT * 
FROM emp
WHERE deptno = 10;

--1.3. Odnajdywanie wierszy spe�niaj�cych wiele warunk�w
--Problem: Chcemy uzyska� wiersze, kt�re spe�niaj� wiele warunk�w

SELECT * 
FROM emp
WHERE deptno = 10
	OR comm IS NOT NULL
	OR sal <= 2000 AND deptno = 20;

--1.4. Odczytywanie podzbioru kolumn tabeli
--Problem: Dysponujemy tabel� bazy danych i chcemy si� zapozna� z warto�ciami okre�lonych kolumn zamiast z zawarto�ci� wszystkich kolumn danej tabeli

SELECT ename, deptno, sal
FROM emp;

--1.5. Definiowanie sensownych nazw kolumn
--Problem: Chcieliby�my tak zmieni� nazwy kolumn uwzgl�dnianych w zbiorze wynikowym wygenerowanym przez zapytanie, aby by�y bardziej czytelne. Przeanalizujmy zapytanie
-- zawieraj�ce wysoko�� wynagrodze� i prowizji otrzymanych przez pracownik�w:
-- SELECT sal, comm
-- FROM emp

SELECT sal AS salary, comm AS commission
FROM emp;

--1.6. Odwo�ania do alias�w kolumn w klauzuli WHERE
--Problem: U�ywali�my ju� alias�w do definiowania bardziej zrozumia�ych nazw kolumn, tym razam chcieliby�my dodatkowo wy��czy� cz�� wierszy za pomoc� klauzuli WHERE.
-- Okazuje si� jednak, �e pr�ba bezpo�redniego odwo�ania do nazw alias�w tej klauzuli ko�czy si� niepowodzeniem:
-- SELECT sal AS salary, comm AS commission
-- FROM emp
-- WHERE salary < 5000

SELECT * 
FROM (
SELECT sal AS salary, comm AS commission
FROM emp
) x
WHERE salary < 5000;

--1.7. Konkatenacja warto�ci kolumn
--Problem: Chcemy zwr�ci� warto�ci sk�adowane w wielu kolumnach w formie pojedynczej kolumny. Wyobra�my sobie, �e chcemy skonstruowa� zapytanie, kt�re na podstawie
-- tabeli emp wygeneruje nast�puj�cy zbi�r wynikowy
-- CLARK WORKS AS A MANAGER
-- KING WORKS AS A PRESIDENT
-- MILLER WORKS AS A CLERK
-- Dane potrzebne do wygenerowania tego rodzaju wynik�w pochodz� z dw�ch r�nych kolumn tabeli emp:
-- SELECT ename, job FROM emp WHERE deptno = 10

SELECT ename + ' WORKS AS A ' + job as msg
FROM emp
WHERE deptno = 10;

--1.8. Stosowanie logiki warunkowej w wyra�eniu SELECT
--Problem: Chcemy wykona� operacje IF-ELSE na warto��iach zwr�conych przez wyra�enie SELECT. Przyk�adowo, planujemy uzyska� zbi�r wynikowy, w kt�rym kolumna STATUS
-- b�dzie zawiera�a warto�� UNDERPAID dla pracownik�w zarabiaj�cych nie wi�cej ni� 2000 dolar�w, warto�� OVERPAID dla pracownik�w zarabiaj�cych co najmniej 4000 dolar�w 
-- lub warto�� OK dla pracownik�w, kt�rych zarobki mieszcz� si� w przedziale od 2000 do 4000.

SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'UNDERPAID'
		 WHEN sal >= 4000 THEN 'OVERPAID'
		 else 'OK'
	END AS stutus
FROM emp;

--1.9. Ograniczanie liczby zwracanych wierszy
--Problem: Chcemy ograniczy� liczb� wierszy zwracanych przez nasze zapytanie. Nie interesuje nas porz�dek wierszy w zbiorze wynikowym- chcemy tylko, by ich liczba 
-- wynosi�a dok�adnie n.

SELECT TOP 5 *
FROM emp;

--1.10. Zwracanie n losowych rekord�w tabeli
--Problem: Chcemy zwr�ci� okre�lon� loczb� losowo wybranych rekord�w z tabeli. Naszym celem jest taka modyfikacja poni�szego wyra�enia, kt�ra spowoduje, �e nast�pujace
-- po sobie wywo�ania b�d� zwraca�y r�ne zbiory, przy czym ka�dy z nich b�dzie si� sk�ada� z pi�ciu losowo wybranych wierszy.
-- select ename, job from emp

SELECT TOP 5 ename, job
FROM emp
ORDER BY NEWID();

--1.11. Odnajdywanie warto�ci pustych (NULL)
--Problem: Chcemy odnale�� wszystkie wiersze, kt�re zawieraj� warto�ci puste w okre�lonej kolumnie.

SELECT * 
FROM emp
WHERE comm IS NULL;

--1.12. Przekszta�canie warto�ci pustych w rzeczywiste
--Problem: Mamy do czynienia z wierszami zawieraj�cymi warto�ci puste i chcieliby�my, aby w ich miejsce by�y zwracane inne, konkretne warto�ci.

SELECT COALESCE(comm, 0)
FROM emp;

--1.13. Poszukiwanie wzorc�w
--Problem: Chcemy zwr�ci� wiersze spe�niaj�ce okre�lone kryteria- wiersze, kt�rych zawarto�� mo�na dopasowa� do okre�lonego pod�a�cucha lub wzorca. Przeanalizujmy
-- poni�sze zapytanie
-- select ename, job from emp where deptno in (10, 20)
-- Chcemy, aby zbi�r wynikowy zawiera� nazwiska i stanowiska pracy tylko tych pracownik�w dziesi�tego i dwudziestego dzia�u, kt�rych nazwiska zawieraj� liter� I lub
-- kt�rych nazwa stanowiska przacy ko�czy si� literami ER.

SELECT ename, job
FROM emp
WHERE deptno IN (10, 20)
	AND (ename LIKE '%I%' OR job LIKE '%ER');