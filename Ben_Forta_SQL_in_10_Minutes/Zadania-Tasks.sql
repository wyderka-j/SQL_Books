------------------------------
-- Zadania - Tasks
------------------------------

------------------------------
-- Rozdzia³ 2 - Chapter 2
------------------------------

-- 1. Napisz w SQL-u instrukcjê, która pobiara identyfikatory wszystkich klientów (kl_id) z tabeli Klienci.

SELECT kl_id
FROM Klienci;

-- 2. Tabela ElementyZamowienia zawiera wszystkie zamówione produkty (niektóre wielokrotnie). Napisz w SQL-u instrukcjê, która pobiera listê zamówionych produktów (prod_id).
--   Istrukcja ma zwracaæ tylko listê unikatowych produktów, a nie wszystkie wyst¹pienia produktów z ka¿dego zamówienia.

SELECT DISTINCT prod_id 
FROM ElementyZamowienia;

-- 3. Napisz w SQL-u instrukcjê pobieraj¹c¹ wszystkie kolumny z tabeli Klienci i inn¹ instrukcê SELECT, która pobiera tylko identyfikatory klientów. 
--   Ukryj w komentarzu jedn¹ instrukcjê SELECT, aby móc uruchomiæ drug¹.

SELECT *
--SELECT kl_id
FROM Klienci;

------------------------------
-- Rozdzia³ 3 - Chapter 3
------------------------------

-- 1. Napisz w SQL-u instrukcjê, która pobiera nazwy wszystkich klientów (kl_nazwa) z tabeli Klienci. Wyœwietl wyniki posortowane od Z do A.

SELECT kl_nazwa 
FROM Klienci
ORDER BY kl_nazwa DESC;

-- 2. Napisz w SQL-u instrukcjê, która pobiera identyfikator klienta (kl_id) i numer zamówienia (zam_numer) z tabeli Zamowienia oraz sortuje wyniki najpierw wed³ug 
--	identyfikatorów klientów, a nastêpnie wed³ug daty zamówienia w odwrotnej kolejnoœci chronologicznej (czyli od najnowszych).

SELECT kl_id, zam_numer
FROM Zamowienia
ORDER BY kl_id, zam_data DESC;

-- 3. Napisz w SQL-u instrukcjê, która wyœwietla liczbê sztuk i cenê jednostkow¹ (prod_cena) z tabeli ElementyZamowienia. Wyniki maj¹ byæ posortowane od najwiêkszej 
--	liczby sztuk i najwy¿szych cen.

SELECT ilosc, cena_elem
FROM ElementyZamowienia
ORDER BY ilosc DESC, cena_elem DESC;

------------------------------
-- Rozdzia³ 4 - Chapter 4
------------------------------

-- 1. Napisz instrukcjê, która pobiera identyfikator (prod_id) i nazwê produktu (prod_nazwa) z tabeli Produkty oraz zwraca tylko produkty o cenie równej 12.99.

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_cena = 12.99;

-- 2. Napisz instrukcjê, która pobiera identyfikator (prod_id) i nazwê produktu (prod_nazwa) z tabeli Produkty oraz zwraca tylko produkty o cenie równej 15 lub wiêkszej.

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_cena >= 12.99;

-- 3. Napisz instrukcjê, która pobiera z tabeli ElementyZamowienia unikatow¹ listê numerów zamówieñ (zam_numer) obejmuj¹cych przynajmniej 100 sztuk dowolnego produktu.

SELECT DISTINCT zam_numer
FROM ElementyZamowienia
WHERE ilosc >= 100;

-- 4. Napisz instukcjê, która pobiera z tabeli Produkty nazwê (prod_nazwa) i cenê (prod_cena) wszystkich produktów o cenie z przedzia³u od 20 do 40. Posortuj wyniki wed³ug ceny. 

SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena BETWEEN 20 AND 40
ORDER BY prod_cena;

------------------------------
-- Rozdzia³ 5 - Chapter 5
------------------------------

-- 1. Napisz instukcjê, która pobiera z tabeli Dostawcy nazwê dostawcy (dost_nazwa) i zwraca tylko dostawców z województwa mazowieckiego. Wymago to filtrowania zarówno 
--	wed³ug pañstwa Polska, jak i stanu, MAZ.

SELECT dost_nazwa
FROM Dostawcy
WHERE dost_kraj = 'Polska' AND dost_woj = 'MAZ';

-- 2. Napisz instrukcje, która znajduje wszystkie zamówienia obejmuj¹ce przynajmniej 100 sztuk produktu BR01, BR02 lub BR03. Nale¿y zwróciæ numer zamówienia (zam_numer) 
--	i liczbê sztuk (ilosc) z tabeli ElementyZamowienia. Dane nale¿y przefiltrowaæ na podstawie identyfikatora produktu i liczby sztuk. 

-- Rozwi¹zanie 1
SELECT zam_numer, prod_id, ilosc
FROM ElementyZamowienia
WHERE (prod_id = 'BR01' OR prod_id = 'BR02' OR prod_id = 'BR03') AND ilosc >= 100;

--Rozwi¹zanie 2
SELECT zam_numer, ilosc
FROM ElementyZamowienia
WHERE prod_id IN ('BR01', 'BR02', 'BR03') AND ilosc >= 100;

-- 3. Napisz instukcjê, która pobiera z tabeli Produkty nazwê (prod_nazwa) i cenê (prod_cena) wszystkich produktów o cenie z przedzia³u od 20 do 40. U¿yj operatora AND i
-- posortuj wyniki wed³ug ceny
SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena >= 20 AND prod_cena <= 40
ORDER BY prod_cena;

------------------------------
-- Rozdzia³ 6 - Chapter 6
------------------------------

-- 1. Napisz instrukcjê, która pobiera nazwê (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w których opisie wystêpuje s³owo szmacianka.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%szmacianka%';

-- 2. Napisz instrukcjê, która pobiera nazwê (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w których opisie nie wystêpuje s³owo szmacianka.
-- Posortuj wyniki wed³ug nazw produktów.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE NOT prod_opis LIKE '%szmacianka%'
ORDER BY prod_nazwa;

-- 3. Napisz instrukcjê, która pobiera nazwê (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w których opisie wystêpuj¹ jednoczeœnie s³owa
-- szmacianka i Rybka. Zastosuj operator AND i dwa porównania LIKE.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%szmacianka%' AND prod_opis LIKE '%Rybka%';

-- 4. Napisz instrukcjê, która pobiera nazwê (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w których opisie wystêpuj¹ s³owa Rybaka i
-- szmacianka w takiej w³aœnie kolejnoœci. 

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%Rybka%szmacianka%';

------------------------------
-- Rozdzia³ 7 - Chapter 7
------------------------------

-- 1. Napisz instrukcjê, która pobiera z tabeli Dostawcy pola dost_id, dost_nazwa, dost_adres i dost_miasto. Nazwê pola dost_nazwa zamieñ na dnazwa, dost_miasto na dmiasto,
-- a dost_adres na dadres. Posortuj wyniki wed³ug nazw dostawców.

SELECT dost_id, dost_nazwa AS dnazwa, dost_adres AS dadres, dost_miasto AS dmiasto
FROM Dostawcy
ORDER BY dost_nazwa;

-- 2. Napisz instrukcjê, która zwraca pola prod_id, prod_cena i cena_wyprz z tabeli Produkty. Pole cena_wyprz jest polem obliczanym zawieraj¹cym cenê wyprzeda¿ow¹ (rabat 10%)

SELECT prod_id, prod_cena, prod_cena * 0.9 AS cena_wyprz
FROM Produkty;

------------------------------
-- Rozdzia³ 8 - Chapter 8
------------------------------

-- 1. Napisz instrukcjê, która zwraca identyfikator klienta (kl_id), nazwê klienta (kl_nazwa) i login (uzyt_login). Login ma sk³adaæ siê z wielkich liter i zawieraæ dwa 
--    pierwsze znaki danych kontaktowych klienta (kl_kontakt) i trzy pierwsze znaki miasta (kl_miasto).

SELECT kl_id, kl_nazwa, UPPER(LEFT(kl_kontakt, 2)) + UPPER(LEFT(kl_miasto, 3)) AS uzyt_login
FROM Klienci;

-- 2. Napisz instrukcjê, która zwraca numer (zam_numer) i datê (zam_data) wszystkich zamówieñ z³o¿onych w styczniu 2020r. Dane maj¹ byæ posortowane wed³ug daty zamówienia.

SELECT zam_numer, zam_data
FROM Zamowienia
WHERE DATEPART(yy, zam_data) = 2020 AND DATEPART(mm, zam_data) = 1
ORDER BY zam_data;

------------------------------
-- Rozdzia³ 9 - Chapter 9
------------------------------

-- 1. Napisz instrukcjê, aby ustaliæ ³¹czn¹ liczbê sprzedanych produktów.

SELECT SUM(ilosc) AS zamowione_produkty
FROM ElementyZamowienia;

-- 2. Zmodyfikuj instrukcjê z zadania 1, aby ustaliæ ³¹czn¹ liczbê sprzedanych produktów (prod_id) BR01.

SELECT SUM(ilosc) AS zamowione_produkty
FROM ElementyZamowienia
WHERE prod_id = 'BR01';

-- 3. Napisz instrukcjê, aby ustaliæ cenê (prod_cena) najdro¿szego produktu z tabeli Produkty, które kosztuje nie wiêcej ni¿ 10. Obliczone pole nazwij cena_maks.

SELECT MAX(prod_cena) AS cena_maks
FROM Produkty
WHERE prod_cena <= 10;

------------------------------
-- Rozdzia³ 10 - Chapter 10
------------------------------

-- 1. Tabela ElementyZamowienia zawiera pojedyncze pozycje ka¿dego zamówienia. Napisz instrukcjê, która zwraca liczbê pozycji (jako pole zam_pozycje) dla ka¿dego numeru 
-- zamówienia (zam_numer). Posortuj wed³ug pola zam_pozycje.

SELECT zam_numer, COUNT(*) AS zam_pozycje
FROM ElementyZamowienia
GROUP BY zam_numer
ORDER BY zam_pozycje;

-- 2. Napisz instrukcjê która zwraca pole o nazwie najtanszy_prod, zawieraj¹ce najtañszy produkt od ka¿dego producenta (u¿yj pola prod_cena z tabeli Produkty). Posortuj 
-- wyniki od najtañszego produktu do najdro¿szego.

SELECT dost_id, MIN(prod_cena) AS najtanszy_prod
FROM Produkty
GROUP BY dost_id
ORDER BY najtanszy_prod;

-- 3. Napisz instrukcjê, która zwraca numery (zam_numer z tabeli ElementyZamowienia) wszystkich zamówieñ obejmuj¹cych przynajmniej 100 elementów.

SELECT zam_numer
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING SUM(ilosc) >= 100
ORDER BY zam_numer;

-- 4. Napisz instrukcjê, która zwraca numery (zam_numer z tabeli ElementyZamowienia) wszystkich zamówieñ, w których ³¹czna cena wynios³a przynajmniej 1000. (musisz obliczyæ
--  sumaryczn¹ cenê produktów cena_elem mno¿one prze ilosc). Posortuj wyniki wed³ug numerów zamówieñ.

SELECT zam_numer, SUM(cena_elem*ilosc) AS cena_w_sumie
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY zam_numer;

------------------------------
-- Rozdzia³ 11 - Chapter 11
------------------------------

-- 1. U¿ywaj¹c zapytania zagnie¿d¿onego, zwróæ listê klientów, którzy kupili produkty o cenie 10 lub wy¿szej. U¿yj tabeli ElementyZamowienia, aby znaleŸæ odpowiednie numery
-- zamówieñ (zam_numer), a nastêpnie tabeli Zamowienia, by pobraæ identyfikatory klientów (kl_id) powi¹zane z tymi zamówieniami.

SELECT kl_id
FROM Zamowienia
WHERE zam_numer IN (SELECT zam_numer
                    FROM ElementyZamowienia
                    WHERE cena_elem >= 10);

-- 2. Chcesz ustaliæ daty, w których zamówiono produkt BR01. Napisz instrukcjê z zapytaniem zagnie¿d¿aj¹cym, aby okreœliæ w których zamówieniach (z tabeli ElementyZamowienia)
-- znalaz³y siê elementy o identyfikatorze (prod_id) BR01. Nastêpnie zwróæ identyfikator klienta (kl_id) i datê zamówienia (zam_data) dla ka¿dego takiego zamówienia z tabeli
-- Zamowienia. Wyniki posortuj wed³ug daty zamówienia.

SELECT kl_id, zam_data
FROM Zamowienia
WHERE zam_numer IN (SELECT zam_numer
                    FROM ElementyZamowienia
                    WHERE prod_id = 'BR01')
ORDER BY zam_data;

-- 3. Zamieñ poprzednie zadanie tak aby instrukcja zwraca³a emaile (kl_email z tabeli Klienci) wszystkich klientów, którzy zakupili produkty o identyfikatorze (prod_id) BR01. 

SELECT kl_email FROM Klienci
WHERE kl_id IN (SELECT kl_id
                FROM Zamowienia
                WHERE zam_numer IN (SELECT zam_numer
                                    FROM ElementyZamowienia
                                    WHERE prod_id = 'BR01'));

-- 4. Napisz instrukcjê, która zwraca identyfikator klienta (kl_id z tabeli Zamowienia) i wartoœæ wartosc_zam. U¿yj zapytania zagnie¿d¿onego, aby zwróciæ sumê wartoœci 
-- zamówieñ ka¿dego klienta. Posortuj wyniki wed³ug wydatków poszczególnych klientów (od najwy¿szych do najni¿szych).

SELECT kl_id,
       (SELECT SUM(cena_elem*ilosc)
        FROM ElementyZamowienia
        WHERE Zamowienia.zam_numer = ElementyZamowienia.zam_numer) 
        AS wartosc_zam
FROM Zamowienia
ORDER BY wartosc_zam DESC;

-- 5. Napisz instrukcjê, która pobiera z tabeli Produkty wszystkie nazwy produktów (prod_nazwa), a tak¿e obliczon¹ kolumnê o nazwie sprzedano_sztuk zawieraj¹c¹ ³¹czn¹ liczbê
-- sprzedancyh sztuk ka¿dego produktu. Tê liczbê pobierz za pomoc¹ zapytania zagnie¿d¿onego i funkcji SUM(ilosc) operuj¹cej na tabeli ElementyZamowienia.

SELECT prod_nazwa,
       (SELECT SUM(ilosc)
        FROM ElementyZamowienia
        WHERE Produkty.prod_id=ElementyZamowienia.prod_id) AS sprzedano_sztuk
FROM Produkty;

------------------------------
-- Rozdzia³ 12 - Chapter 12
------------------------------

-- 1. Napisz instrukcjê, która zwraca nazwê klienta (kl_nazwa) z tabeli Klienci i numery powi¹zanych zamówieñ (zam_numer) z tabeli Zamówienia. Wynik posortuj najpierw wed³ug
-- nazw klientów, a nastêpnie wed³ug numerów zamówieñ. Spróbuj wykonaæ to zadania dwukrotnie - raz z u¿yciem prostej sk³adni z³¹czeñ wewnêtrznych i raz za pomoc¹ sk³adni INNER JOIN.

-- Sk³adnia z³¹czeñ wewnêtrznych
SELECT kl_nazwa, zam_numer
FROM Klienci, Zamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- Sk³adnia ANSI INNER JOIN
SELECT kl_nazwa, zam_numer
FROM Klienci INNER JOIN Zamowienia
ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- 2. Oprócz zwracania nazwy klienta i numeru zamówienia z poprzedniego zadania dodaj trzeci¹ kolumnêk wartosc_zam, zawieraj¹c¹ ³¹czn¹ wartoœæ ka¿dego zamówienia. Mo¿esz to 
-- zrobiæ na dwa sposoby: tworz¹c kolumnê wartosc_zam za pomoc¹ zapytania zagnie¿d¿onego z u¿yciem tabeli ElementyZamowienia lub z³¹czaj¹c tabelê ElementyZamowienia z innymi
-- tabelami i u¿ywaj¹c funcji agregujacej.

-- Rozwi¹zanie z u¿yciem zapytañ zagnie¿d¿onych
SELECT kl_nazwa,
       zam_numer,
       (SELECT SUM(cena_elem*ilosc)
       FROM ElementyZamowienia
       WHERE Zamowienia.zam_numer=ElementyZamowienia.zam_numer) 
       AS wartosc_zam
FROM Klienci, Zamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- Rozwi¹zanie z u¿yciem z³¹czeñ
SELECT kl_nazwa,
       Zamowienia.zam_numer,
       SUM(cena_elem*ilosc) AS wartosc_zam
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
 AND Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa, Zamowienia.zam_numer
ORDER BY kl_nazwa, zam_numer;

-- 3. Napisz instrukcjê, która pobiera daty zamówienia produktu BR01, przy czym u¿yj z³¹czenia i prostej sk³adni z³¹czeñ wewnêtrznych.

SELECT kl_id, zam_data
FROM Zamowienia, ElementyZamowienia
WHERE Zamowienia.zam_numer = ElementyZamowienia.zam_numer
AND prod_id = 'BR01'
ORDER BY zam_data;

-- 4. Napisz instrukcjê, która zwraca³a emaile (kl_email z tabeli Klienci) wszystkich klientów, którzy zakupili produkty o identyfikatorze (prod_id) BR01. U¿yj sk³adni ANSI INNER JOIN.

SELECT kl_email
FROM Klienci
 INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
 INNER JOIN ElementyZamowienia 
            ON Zamowienia.zam_numer = ElementyZamowienia.zam_numer
WHERE prod_id = 'BR01';

-- 5. Napisz instrukcjê, która za pomoc¹ z³¹czeñ zwraca nazwy klientów (kl_nazwa) z tabeli Klienci i wartoœci ich zamówieñ z tabeli ElementyZamowienia. Aby po³¹czyæ te tabele,
-- musisz uwzglêdniæ tak¿e tabelê Zamówienia. Posortuj wyniki wed³ug nazw klientów.

-- Sk³adnia z³¹czeñ wewnêtrznych
SELECT kl_nazwa, SUM(cena_elem*ilosc) AS wydatki_razem
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
 AND Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY kl_nazwa;

-- Sk³adnia ANSI INNER JOIN
SELECT kl_nazwa, SUM(cena_elem*ilosc) AS wydatki_razem
FROM Klienci
INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id 
INNER JOIN ElementyZamowienia 
           ON Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa
HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY kl_nazwa;


------------------------------
-- Rozdzia³ 13 - Chapter 13
------------------------------

-- 1. Napisz instrukcjê ze z³¹czeniem INNER JOIN, aby pobraæ nazwy klientów (kl_nazwa z tabeli Klienci) i wszystkie numery zamówieñ (zam_numer z Zamowienia) ka¿dego klienta.

SELECT kl_nazwa, zam_numer
FROM Klienci
JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa;

-- 2. Zmodyfikuj instrukcjê z poprzedniego zadania, tak aby wyœwietla³a wszystkie nazwy klientów (nawet tych którzy nie z³o¿yli ¿adnych zamówieñ).

SELECT kl_nazwa, zam_numer
FROM Klienci
LEFT OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa;

-- 3. U¿yj z³¹czenia OUTER JOIN, aby z³¹czyæ tabele Produkty i ElementyZamowienia. Instrukcja ma zwracaæ posortowan¹ listê nazw produktów (prod_nazwa) i numerów zamówieñ 
-- (zam_numer) powi¹zanych z ka¿dy produktem.

SELECT prod_nazwa, zam_numer
FROM Produkty
LEFT OUTER JOIN ElementyZamowienia ON Produkty.prod_id = ElementyZamowienia.prod_id
ORDER BY prod_nazwa;

-- 4. Zmodyfikuj utworzon¹ w zadaniu 3 instrukcjê, aby zwraca³a ³¹czn¹ liczbê zamówieñ ka¿dego produktu (zamiast numerów zamówieñ).

SELECT prod_nazwa, COUNT(zam_numer) AS liczba_zam
FROM Produkty
LEFT OUTER JOIN ElementyZamowienia ON Produkty.prod_id = ElementyZamowienia.prod_id
GROUP BY prod_nazwa
ORDER BY prod_nazwa;

-- 5. Napisz instrukcjê, która wyœwietla dostawców (dost_id z tabeli Dostawcy) i liczbê produktów oferowanych przez ka¿dego z nich. Nale¿y pokazaæ tak¿e dostawców, którzy 
-- nie oferuj¹ ¿adnych produktów. Zastosuj z³¹czenie OUTER JOIN i funkcjê agreguj¹c¹ COUNT(), aby zliczyæ, ile produktów z talebi Produkty oferuje ka¿dy dostawca.

SELECT Dostawcy.dost_id, COUNT(prod_id) 
FROM Dostawcy 
LEFT OUTER JOIN Produkty ON Dostawcy.dost_id = Produkty.dost_id
GROUP BY Dostawcy.dost_id;

------------------------------
-- Rozdzia³ 14 - Chapter 14
------------------------------

-- 1. Napisz instrukcjê, która obejmuje dwie instrukcje SELECT pobieraj¹ce identyfikator produktu (prod_id) i ilosc z tabeli ElementyZamowienia. Filtrowanie w jednej 
-- instrukcji SELECT ma zwracaæ tylko te wiersze z kolumn¹ iloœæ równ¹ 100. a w drugiej wiersze z produktami o identyfikatorze rozpoczynaj¹cym siê od liter BNBG. Wyniki 
-- posortuj wed³ug identyfikatorów produktów.

SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE ilosc = 100
UNION
SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 2. Zmodyfikuj utworzon¹ w zadaniu 1 instrukcjê, u¿ywaj¹c tylko jednej instrukcji SELECT.

SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE ilosc = 100 OR prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 3. Napisz instrukcjê, która zwraca i ³¹czy nazwê produktu (prod_nazwa) z tabeli Produkty i nazwê klienta (kl_nazwa) z tabeli Klienci. Wyniki posortuj wed³ug nazw produktów.

SELECT prod_nazwa
FROM Produkty
UNION
SELECT kl_nazwa
FROM Klienci
ORDER BY prod_nazwa;

------------------------------
-- Rozdzia³ 15 - Chapter 15
------------------------------

-- 1. U¿ywaj¹c instrukcji INSERT i dostêpnych kolumn, dodaj swoje dane do tabeli Klienci. Bezpoœrednio podaj dodawane kolumny i u¿yj tylko tych, których potrzebujesz.

INSERT INTO Klienci(kl_id,
                    kl_nazwa,
                    kl_adres,
                    kl_miasto,
                    kl_woj,
                    kl_kod,
                    kl_kraj,
                    kl_email)
VALUES(1000000042,
       'Zabawki Bena',
       '123 Ulica',
       'Kraków',
       'MAL',
       '48237',
       'Polska',
       'nowy@poczta.com');

-- 2. Utwórz kopie zapasowe tabel Zamowienia i ElementyZamowienia.

SELECT * INTO ZamowieniaKopia FROM Zamowienia;
SELECT * INTO ElementyZamowieniaKopia FROM ElementyZamowienia;

------------------------------
-- Rozdzia³ 16 - Chapter 16
------------------------------

-- 1. Skróty nazw polskich województw powinny sk³adaæ siê z wielkich liter. Napisz instrukcjê, która modyfikuje wszystkie adresy z Polski - zarówno pole dost_woj w tabeli 
-- Dostawcy, jak i pole kl_woj w tabeli Klienci. Tak aby skróty nazw województw by³y zapisane wielkimi literami.

UPDATE Dostawcy
SET dost_woj = UPPER(dost_woj)
WHERE dost_kraj = 'Polska';

UPDATE Klienci
SET kl_woj = UPPER(kl_woj)
WHERE kl_kraj = 'Polska';

-- 2. Usuñ dane dodane w zadaniu 1 w rozdziale 15. Najprierw przetestuj klauzulê za pomoc¹ instrucji SELECT.

-- tylko te dane, które chcesz usun¹æ
SELECT * FROM Klienci
WHERE kl_id = 1000000042;

-- Nastêpnie usuñ dane
DELETE Klienci
WHERE kl_id = 1000000042;

------------------------------
-- Rozdzia³ 17 - Chapter 17
------------------------------

-- 1. Dodaj kolumnê z adresem witryny (dost_witryna) do tabeli Dostawcy. Potrzebne jest tu pole tekstowe wystarczaj¹co d³ugie aby zmieœciæ adres URL.

ALTER TABLE Dostawcy
ADD dost_witryna CHAR(100);

-- 2. U¿yj instrukcji UPDATE, aby zmodyfikowaæ rekordy z tabeli Dostawcy i dodaæ do nich adres witryny. 

UPDATE Dostawcy
SET dost_witryna = 'https://google.com/'
WHERE dost_id = 'DLL01';

------------------------------
-- Rozdzia³ 18 - Chapter 18
------------------------------

-- 1. Utwórz perspektywê KlienciZZamowieniami zawieraj¹c¹ wszystkie kolumny z tabeli Klenci, ale obejmuj¹c¹ tylko wiersze klientów, którzy z³o¿yli jakieœ zamówienia.

CREATE VIEW KlienciZZamowieniami AS
SELECT Klienci.kl_id,
       Klienci.kl_nazwa,
       Klienci.kl_adres,
       Klienci.kl_miasto,
       Klienci.kl_woj,
       Klienci.kl_kod,
       Klienci.kl_kraj,
       Klienci.kl_kontakt,
       Klienci.kl_email
FROM Klienci
JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id;

