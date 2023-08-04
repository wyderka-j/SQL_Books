-- 	Rozdzia³ 8. Dzia³ania na datach


-- 8.1. Dodawanie i odejmowanie dni, miesiêcy i lat
-- Problem: Chcemy dodaæ pewn¹ liczbê dni, miesiêcy lub lat do okreœlonej daty wejœciowej lub odj¹æ od niej. Przyjmijmy, ¿e na podstawie daty zatrudnienia
-- (HIREDATE) pracownika chcemy uzyskaæ szeœæ ró¿nych dat: 5 dni przed zatrudnieniem i piêæ dni po zatrudnieniu, piêæ miesiêcy przed i po 
-- zatrudnieniu oraz piêæ lat przed i po zatrudnieniu. 

SELECT DATEADD(day, -5, hiredate) AS hd_minus_5D,
	DATEADD(day, 5, hiredate) AS hd_plus_5D,
	DATEADD(month, -5, hiredate) AS hd_minus_5M,
	DATEADD(month, 5, hiredate) AS hd_plus_5M,
	DATEADD(year, -5, hiredate) AS hd_minus_5Y,
	DATEADD(year, 5, hiredate) AS hd_plus_5Y
FROM EMP
WHERE deptno = 10;

-- 8.2. Okreœlanie liczby dni pomiêdzy dwiema datami
-- Problem: Chcemy znaleŸæ ró¿nicê dziel¹c¹ dwie daty i wyraziæ uzyskany wynik w dniach. Chcemy obliczyæ ró¿nicê pomiêdzy datami zatrudnienia dwóch pracowników.

SELECT DATEDIFF(day, allen_hd, ward_hd)
	FROM (
SELECT hiredate AS ward_hd
	FROM EMP
	WHERE ename = 'WARD'
		) x,
		(
SELECT hiredate AS allen_hd
	FROM EMP
	WHERE ename = 'ALLEN'
		) y

-- 8.3. Okreœlanie liczby dni roboczych pomiêdzy dwiema datami
-- Problem: Dysponujemy dwiema datami i chcemy okreœliæ liczbê dziel¹cych je dni roboczych (z uwzglêdnieniem obu tych dat). Przyjmujemy, ¿e dniami roboczymi
-- s¹ wszystkie dni tygodnia poza sobot¹ i niedziel¹.

SELECT SUM(CASE WHEN datename(dw, jones_hd+t500.id-1)
				IN ('SATURDAY', 'SUNDAY')
				THEN 0 ELSE 1
			END) AS days
	FROM (
SELECT MAX(CASE WHEN ename = 'BLAKE'
				THEN hiredate
			END) as blake_id,
		MAX(CASE WHEN ename = 'JONES'
				THEN hiredate
			END) AS jones_id
	FROM EMP
	WHERE ename IN ('BLAKE', 'JONES')
		) x,
		t500
	WHERE t500.id <= DATEDIFF(day, jones_hd, blake_hd)+1

-- 8.4. Okreœlanie liczby miesiêcy lub lat dziel¹cych dwie daty
-- Problem: Chcemcy wyznaczyæ ró¿nicê dziel¹c¹ dwie daty. Ró¿nica powinna zostaæ wyra¿ona w miesi¹cech lub latach. Np. liczba miesiêcy i lat które up³ynê³y 
-- pomiêdzy dat¹ zatrudnienia pierwszego pracownika a dat¹ zatrudnienia pracownika najm³odszego sta¿em.

SELECT DATEDIFF(month, min_hd, max_hd),
		DATEDIFF(year, min_hd, max_hd)
	FROM (
SELECT MIN(hiredate) min_hd, MAX(hiredate) max_hd
	FROM EMP
	) x

-- 8.5. Okreœlanie liczby sekund, minut lub godzin dziel¹cych dwie daty
-- Problem: Chcemy wyznaczyæ ró¿nicê dziel¹c¹ dwie daty wejœciowe, która bêdzie wyra¿ona w sekundach. Chcemy otrzymaæ liczbê sekund, minut i godzin dziel¹cych
-- daty zatrudnienia dwóch pracowników. 

SELECT DATEDIFF(HOUR, allen_hd, ward_hd) as hr,
		DATEDIFF(MINUTE, allen_hd, ward_hd) as mi,
		DATEDIFF(SECOND, allen_hd, ward_hd) as sec
	FROM (
SELECT MAX(CASE WHEN ename = 'WARD'
				THEN hiredate
			END) AS ward_hd,
		MAX(CASE WHEN ename = 'ALLEN'
				THEN hiredate
			END) AS allen_hd
	FROM EMP
	) x

-- 8.6. Zliczanie wyst¹pieñ poszczególnych dni tygodnia w roku
-- Problem: Chcemy wyznaczyæ liczbê wyst¹pieñ poszczególnych dni tygodnia w ci¹gu roku.

WITH x (start_date, end_date)
AS (
SELECT start_date,
		DATEADD(YEAR, 1, start_date) end_date
	FROM (
SELECT CAST(
		CAST(year(getdate()) AS varchar) + '-01-01'
			AS datetime) start_date
	FROM T1
		) tmp
UNION ALL
SELECT DATEADD(day, 1, start_date), end_date
	FROM x
	WHERE DATEADD(day, 1, start_date) < end_date
)
SELECT DATENAME(dw, start_date), COUNT(*)
	FROM x
GROUP BY DATENAME(dw,start_date)
OPTION (MAXRECURSION 366)

