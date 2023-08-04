-- 	Rozdzia� 8. Dzia�ania na datach


-- 8.1. Dodawanie i odejmowanie dni, miesi�cy i lat
-- Problem: Chcemy doda� pewn� liczb� dni, miesi�cy lub lat do okre�lonej daty wej�ciowej lub odj�� od niej. Przyjmijmy, �e na podstawie daty zatrudnienia
-- (HIREDATE) pracownika chcemy uzyska� sze�� r�nych dat: 5 dni przed zatrudnieniem i pi�� dni po zatrudnieniu, pi�� miesi�cy przed i po 
-- zatrudnieniu oraz pi�� lat przed i po zatrudnieniu. 

SELECT DATEADD(day, -5, hiredate) AS hd_minus_5D,
	DATEADD(day, 5, hiredate) AS hd_plus_5D,
	DATEADD(month, -5, hiredate) AS hd_minus_5M,
	DATEADD(month, 5, hiredate) AS hd_plus_5M,
	DATEADD(year, -5, hiredate) AS hd_minus_5Y,
	DATEADD(year, 5, hiredate) AS hd_plus_5Y
FROM EMP
WHERE deptno = 10;

-- 8.2. Okre�lanie liczby dni pomi�dzy dwiema datami
-- Problem: Chcemy znale�� r�nic� dziel�c� dwie daty i wyrazi� uzyskany wynik w dniach. Chcemy obliczy� r�nic� pomi�dzy datami zatrudnienia dw�ch pracownik�w.

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

-- 8.3. Okre�lanie liczby dni roboczych pomi�dzy dwiema datami
-- Problem: Dysponujemy dwiema datami i chcemy okre�li� liczb� dziel�cych je dni roboczych (z uwzgl�dnieniem obu tych dat). Przyjmujemy, �e dniami roboczymi
-- s� wszystkie dni tygodnia poza sobot� i niedziel�.

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

-- 8.4. Okre�lanie liczby miesi�cy lub lat dziel�cych dwie daty
-- Problem: Chcemcy wyznaczy� r�nic� dziel�c� dwie daty. R�nica powinna zosta� wyra�ona w miesi�cech lub latach. Np. liczba miesi�cy i lat kt�re up�yn�y 
-- pomi�dzy dat� zatrudnienia pierwszego pracownika a dat� zatrudnienia pracownika najm�odszego sta�em.

SELECT DATEDIFF(month, min_hd, max_hd),
		DATEDIFF(year, min_hd, max_hd)
	FROM (
SELECT MIN(hiredate) min_hd, MAX(hiredate) max_hd
	FROM EMP
	) x

-- 8.5. Okre�lanie liczby sekund, minut lub godzin dziel�cych dwie daty
-- Problem: Chcemy wyznaczy� r�nic� dziel�c� dwie daty wej�ciowe, kt�ra b�dzie wyra�ona w sekundach. Chcemy otrzyma� liczb� sekund, minut i godzin dziel�cych
-- daty zatrudnienia dw�ch pracownik�w. 

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

-- 8.6. Zliczanie wyst�pie� poszczeg�lnych dni tygodnia w roku
-- Problem: Chcemy wyznaczy� liczb� wyst�pie� poszczeg�lnych dni tygodnia w ci�gu roku.

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

