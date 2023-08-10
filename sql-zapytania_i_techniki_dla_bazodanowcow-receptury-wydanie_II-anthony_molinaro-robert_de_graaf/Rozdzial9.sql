-- Rozdział 9. Przetwarzanie dat

-- 9.2. Określanie liczby dni w roku
-- Problem: Chcemy określić liczbę dni w bieżącym roku.

SELECT DATEDIFF(d, curr_year, dateadd(yy, 1, curr_year))
FROM (
SELECT DATEADD(d, -datepart(dy, getdate())+1, getdate()) curr_year
FROM T1
	) x

-- 9.3. Wyodrębnianie jednostek czasu z dat wejściowych
-- Problem: Chcemy rozbić bieżącą datę i godzinę na sześć części: dzień, miesiąc, rok, sekundęm minutę i godzinę.

SELECT DATEPART( hour, getdate()) hr,
		DATEPART( minute, getdate()) minu,
		DATEPART( second, getdate()) sec,
		DATEPART( day, getdate()) dy,
		DATEPART( month, getdate()) mon,
		DATEPART( year, getdate()) yr
	FROM T1;

-- 9.4. Określanie pierwszego i ostatniego dnia miesiąca
-- Problem: Chcemy określić pierwszy i ostatni dzień bieżącego miesiąca.

SELECT DATEADD(day, -day(getdate())+1, getdate()) firstday,
		DATEADD(day,
				-day(getdate()),
				DATEADD(month, 1, getdate())) lastday
	FROM T1

-- 9.5. Określanie wszystkich dat występowania konkretnego dnia tygodnia w ciągu danego roku
-- Problem: Chcemy wygenerować listę wszystkich dat w danym roku, które przypadają na konkretny dzień tygodnia. Np. wszystkich piątków.

WITH x (dy, yr)
	AS (
SELECT dy, YEAR(dy) yr
	FROM (
SELECT GETDATE()-DATEPART(dy, getdate())+1 dy
	FROM T1
		) tmp1
UNION ALL
SELECT DATEADD(dd, 1, dy), yr
	FROM x
	WHERE YEAR(DATEADD(dd, 1, dy)) = yr
)
SELECT x.dy
	FROM x
	WHERE DATENAME(dw, x.dy) = 'friday'
	OPTION (maxrecursion 400)

-- 9.6. Określanie dat pierwszego i ostatniego wystąpienia określonego dnia tygodnia w danym miesiącu
-- Problem: Chcemy znaleźć daty reprezentujące np. pierwszy i ostatni pi=oniedziałek w bieżącym miesiącu.

WITH x (dy, mth, is_monday)
	AS (
SELECT dy, mth,
		CASE WHEN DATEPART(dw, dy) = 2
			THEN 1 ELSE 0
		END
	FROM (
SELECT DATEADD(day, 1, dateadd(day, -day(getdate()), getdate())) dy,
		MONTH(getdate()) mth
	FROM T1
		) tmp1
UNION ALL
SELECT DATEADD(day, 1, dy),
		mth,
		CASE WHEN DATEPART(dw, dateadd(day, 1, dy)) = 2
			THEN 1 ELSE 0
		END
	FROM x
	WHERE MONTH(dateadd(day, 1, dy)) = mth
)
SELECT MIN(dy) first_monday,
		MAX(dy) last_monday
	FROM x
	WHERE is_monday = 1

-- 9.7. Tworzenie kalendarza
-- Problem: Chcemy stworzyć kompletny kalendarz obejmujący wszystkie dni bieżącego miesiąca. Kolendarz powinien składać się z siedmiu kolumn i (zazwyczaj) 
-- pięciu wierszy.

	WITH x(dy, dm, mth, dw, wk)
	AS (
SELECT dy,
		DAY(dy) dm,
		DATEPART(m, dy) mth,
		DATEPART(dw, dy) dw,
		CASE WHEN DATEPART(dw, dy) = 1
			THEN DATEPART(ww, dy)-1
			ELSE DATEPART(ww, dy)
		END wk
	FROM (
SELECT DATEADD(day, -day(getdate())+1, getdate()) dy
	FROM T1
		) x
UNION ALL
SELECT DATEADD(d, 1, dy), DAY(dateadd(d, 1, dy)), mth,
		DATEPART(dw, dateadd(d, 1, dy)),
		CASE WHEN DATEPART(dw, dateadd(d, 1, dy)) = 1
			THEN DATEPART(wk,dateadd(d, 1, dy))-1
			ELSE DATEPART(wk, dateadd(d, 1, dy))
		END
	FROM x
	WHERE DATEPART(m, dateadd(d, 1, dy)) = mth
)
SELECT MAX(CASE dw WHEN 2 THEN dm END) AS Mo,
		MAX(CASE dw WHEN 3 THEN dm END) AS Tu,
		MAX(CASE dw WHEN 4 THEN dm END) AS We,
		MAX(CASE dw WHEN 5 THEN dm END) AS Th,
		MAX(CASE dw WHEN 6 THEN dm END) AS Fr,
		MAX(CASE dw WHEN 7 THEN dm END) AS Sa,
		MAX(CASE dw WHEN 1 THEN dm END) AS Su
	FROM x
	GROUP BY wk
	ORDER BY wk

-- 9.8. Generowanie dat rozpoczynających i kończących poszczególne kwartały danego roku
-- Problem: Chcemy otrzymać daty pierwszych i ostatnich dni każdego z czterech kwartałów danego roku.

	WITH x (dy, cnt)
		AS (
SELECT DATEADD(d, -(DATEPART(dy, GETDATE())-1), GETDATE()),
		1
	FROM T1
UNION ALL
SELECT DATEADD(m, 3, dy), cnt+1
	FROM x
	WHERE cnt+1 <= 4
)
SELECT DATEPART(q, DATEADD(d, -1, dy)) QTR,
		DATEADD(m, -3, dy) Q_start,
		DATEADD(d, -1, dy) Q_end
	FROM x
	ORDER BY 1

-- 9.9. Określanie daty początkowej i końcowej dla danego kwartału
-- Problem: Mając dany rok i kwartał w formacie YYYYQ (rok reprezentowany przez cztery pierwsze cyfry, numer kwartału preprezentowany jest przez ostatnią cyfrę),
-- chcemy otrzymać daty pierwszego i ostatniego dnia tego kwartału.

SELECT DATEADD(m, -2, q_end) q_start,
		DATEADD(d, -1, DATEADD(m, 1, q_end)) q_end
	FROM (
SELECT CAST(SUBSTRING(CAST(yrq AS varchar), 1, 4)+'-'+
		CAST(yrq%10*3 AS varchar)+'-1' AS datetime) q_end
	FROM (
SELECT 20201 AS yrq FROM t1 UNION ALL
SELECT 20202 AS yrq FROM t1 UNION ALL
SELECT 20203 AS yrq FROM t1 UNION ALL
SELECT 20204 AS yrq FROM t1 
	) x
	) y



-- 9.11. Przeszukiwanie według określonych jednostek czasu
-- Problem: Chcemy odnaleźć w zbiorze wejściowym daty, które są zgodne z określonym wzorcem, np. wypadają danego miesiąca, w określony dzień miesiąca. 
-- Chcemy odnaleźć wszystkich pracowników zatrudnionych w lutym lub grudniu oraz pracowników zatrudnionych we wtorek.

SELECT ename
FROM EMP
WHERE DATENAME(m, hiredate) IN ('February', 'December')
	OR DATENAME(dw, hiredate) = 'Tuesday'

-- 9.12. Porównywanie rekordów według określonych fragmentów dat
-- Problem: Chcemy odszukać pracowników, którzy znajeźli zatrudnienie w danej firmie w tym samym miesiącu i dniu.

SELECT a.ename + 'was hired on the same month and weekday as ' + b.ename msg
FROM EMP a, EMP b
WHERE DATENAME(dw, a.hiredate) = DATENAME(dw, b.hiredate)
	AND DATENAME(m, a.hiredate) = DATENAME(m, b.hiredate)
	AND a.empno < b.empno
ORDER BY a.ename
