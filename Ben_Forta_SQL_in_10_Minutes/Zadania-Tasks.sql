------------------------------
-- Zadania - Tasks
------------------------------

------------------------------
-- Rozdzia� 2 - Chapter 2
------------------------------

-- 1. Napisz w SQL-u instrukcj�, kt�ra pobiara identyfikatory wszystkich klient�w (kl_id) z tabeli Klienci.

SELECT kl_id
FROM Klienci;

-- 2. Tabela ElementyZamowienia zawiera wszystkie zam�wione produkty (niekt�re wielokrotnie). Napisz w SQL-u instrukcj�, kt�ra pobiera list� zam�wionych produkt�w (prod_id).
--   Istrukcja ma zwraca� tylko list� unikatowych produkt�w, a nie wszystkie wyst�pienia produkt�w z ka�dego zam�wienia.

SELECT DISTINCT prod_id 
FROM ElementyZamowienia;

-- 3. Napisz w SQL-u instrukcj� pobieraj�c� wszystkie kolumny z tabeli Klienci i inn� instrukc� SELECT, kt�ra pobiera tylko identyfikatory klient�w. 
--   Ukryj w komentarzu jedn� instrukcj� SELECT, aby m�c uruchomi� drug�.

SELECT *
--SELECT kl_id
FROM Klienci;

------------------------------
-- Rozdzia� 3 - Chapter 3
------------------------------

-- 1. Napisz w SQL-u instrukcj�, kt�ra pobiera nazwy wszystkich klient�w (kl_nazwa) z tabeli Klienci. Wy�wietl wyniki posortowane od Z do A.

SELECT kl_nazwa 
FROM Klienci
ORDER BY kl_nazwa DESC;

-- 2. Napisz w SQL-u instrukcj�, kt�ra pobiera identyfikator klienta (kl_id) i numer zam�wienia (zam_numer) z tabeli Zamowienia oraz sortuje wyniki najpierw wed�ug 
--	identyfikator�w klient�w, a nast�pnie wed�ug daty zam�wienia w odwrotnej kolejno�ci chronologicznej (czyli od najnowszych).

SELECT kl_id, zam_numer
FROM Zamowienia
ORDER BY kl_id, zam_data DESC;

-- 3. Napisz w SQL-u instrukcj�, kt�ra wy�wietla liczb� sztuk i cen� jednostkow� (prod_cena) z tabeli ElementyZamowienia. Wyniki maj� by� posortowane od najwi�kszej 
--	liczby sztuk i najwy�szych cen.

SELECT ilosc, cena_elem
FROM ElementyZamowienia
ORDER BY ilosc DESC, cena_elem DESC;

------------------------------
-- Rozdzia� 4 - Chapter 4
------------------------------

-- 1. Napisz instrukcj�, kt�ra pobiera identyfikator (prod_id) i nazw� produktu (prod_nazwa) z tabeli Produkty oraz zwraca tylko produkty o cenie r�wnej 12.99.

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_cena = 12.99;

-- 2. Napisz instrukcj�, kt�ra pobiera identyfikator (prod_id) i nazw� produktu (prod_nazwa) z tabeli Produkty oraz zwraca tylko produkty o cenie r�wnej 15 lub wi�kszej.

SELECT prod_id, prod_nazwa
FROM Produkty
WHERE prod_cena >= 12.99;

-- 3. Napisz instrukcj�, kt�ra pobiera z tabeli ElementyZamowienia unikatow� list� numer�w zam�wie� (zam_numer) obejmuj�cych przynajmniej 100 sztuk dowolnego produktu.

SELECT DISTINCT zam_numer
FROM ElementyZamowienia
WHERE ilosc >= 100;

-- 4. Napisz instukcj�, kt�ra pobiera z tabeli Produkty nazw� (prod_nazwa) i cen� (prod_cena) wszystkich produkt�w o cenie z przedzia�u od 20 do 40. Posortuj wyniki wed�ug ceny. 

SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena BETWEEN 20 AND 40
ORDER BY prod_cena;

------------------------------
-- Rozdzia� 5 - Chapter 5
------------------------------

-- 1. Napisz instukcj�, kt�ra pobiera z tabeli Dostawcy nazw� dostawcy (dost_nazwa) i zwraca tylko dostawc�w z wojew�dztwa mazowieckiego. Wymago to filtrowania zar�wno 
--	wed�ug pa�stwa Polska, jak i stanu, MAZ.

SELECT dost_nazwa
FROM Dostawcy
WHERE dost_kraj = 'Polska' AND dost_woj = 'MAZ';

-- 2. Napisz instrukcje, kt�ra znajduje wszystkie zam�wienia obejmuj�ce przynajmniej 100 sztuk produktu BR01, BR02 lub BR03. Nale�y zwr�ci� numer zam�wienia (zam_numer) 
--	i liczb� sztuk (ilosc) z tabeli ElementyZamowienia. Dane nale�y przefiltrowa� na podstawie identyfikatora produktu i liczby sztuk. 

-- Rozwi�zanie 1
SELECT zam_numer, prod_id, ilosc
FROM ElementyZamowienia
WHERE (prod_id = 'BR01' OR prod_id = 'BR02' OR prod_id = 'BR03') AND ilosc >= 100;

--Rozwi�zanie 2
SELECT zam_numer, ilosc
FROM ElementyZamowienia
WHERE prod_id IN ('BR01', 'BR02', 'BR03') AND ilosc >= 100;

-- 3. Napisz instukcj�, kt�ra pobiera z tabeli Produkty nazw� (prod_nazwa) i cen� (prod_cena) wszystkich produkt�w o cenie z przedzia�u od 20 do 40. U�yj operatora AND i
-- posortuj wyniki wed�ug ceny
SELECT prod_nazwa, prod_cena
FROM Produkty
WHERE prod_cena >= 20 AND prod_cena <= 40
ORDER BY prod_cena;

------------------------------
-- Rozdzia� 6 - Chapter 6
------------------------------

-- 1. Napisz instrukcj�, kt�ra pobiera nazw� (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w kt�rych opisie wyst�puje s�owo szmacianka.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%szmacianka%';

-- 2. Napisz instrukcj�, kt�ra pobiera nazw� (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w kt�rych opisie nie wyst�puje s�owo szmacianka.
-- Posortuj wyniki wed�ug nazw produkt�w.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE NOT prod_opis LIKE '%szmacianka%'
ORDER BY prod_nazwa;

-- 3. Napisz instrukcj�, kt�ra pobiera nazw� (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w kt�rych opisie wyst�puj� jednocze�nie s�owa
-- szmacianka i Rybka. Zastosuj operator AND i dwa por�wnania LIKE.

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%szmacianka%' AND prod_opis LIKE '%Rybka%';

-- 4. Napisz instrukcj�, kt�ra pobiera nazw� (prod_nazwa) i opis (prod_opis) z tabeli Produkty oraz zwraca tylko te produkty, w kt�rych opisie wyst�puj� s�owa Rybaka i
-- szmacianka w takiej w�a�nie kolejno�ci. 

SELECT prod_nazwa, prod_opis
FROM Produkty
WHERE prod_opis LIKE '%Rybka%szmacianka%';

------------------------------
-- Rozdzia� 7 - Chapter 7
------------------------------

-- 1. Napisz instrukcj�, kt�ra pobiera z tabeli Dostawcy pola dost_id, dost_nazwa, dost_adres i dost_miasto. Nazw� pola dost_nazwa zamie� na dnazwa, dost_miasto na dmiasto,
-- a dost_adres na dadres. Posortuj wyniki wed�ug nazw dostawc�w.

SELECT dost_id, dost_nazwa AS dnazwa, dost_adres AS dadres, dost_miasto AS dmiasto
FROM Dostawcy
ORDER BY dost_nazwa;

-- 2. Napisz instrukcj�, kt�ra zwraca pola prod_id, prod_cena i cena_wyprz z tabeli Produkty. Pole cena_wyprz jest polem obliczanym zawieraj�cym cen� wyprzeda�ow� (rabat 10%)

SELECT prod_id, prod_cena, prod_cena * 0.9 AS cena_wyprz
FROM Produkty;

------------------------------
-- Rozdzia� 8 - Chapter 8
------------------------------

-- 1. Napisz instrukcj�, kt�ra zwraca identyfikator klienta (kl_id), nazw� klienta (kl_nazwa) i login (uzyt_login). Login ma sk�ada� si� z wielkich liter i zawiera� dwa 
--    pierwsze znaki danych kontaktowych klienta (kl_kontakt) i trzy pierwsze znaki miasta (kl_miasto).

SELECT kl_id, kl_nazwa, UPPER(LEFT(kl_kontakt, 2)) + UPPER(LEFT(kl_miasto, 3)) AS uzyt_login
FROM Klienci;

-- 2. Napisz instrukcj�, kt�ra zwraca numer (zam_numer) i dat� (zam_data) wszystkich zam�wie� z�o�onych w styczniu 2020r. Dane maj� by� posortowane wed�ug daty zam�wienia.

SELECT zam_numer, zam_data
FROM Zamowienia
WHERE DATEPART(yy, zam_data) = 2020 AND DATEPART(mm, zam_data) = 1
ORDER BY zam_data;

------------------------------
-- Rozdzia� 9 - Chapter 9
------------------------------

-- 1. Napisz instrukcj�, aby ustali� ��czn� liczb� sprzedanych produkt�w.

SELECT SUM(ilosc) AS zamowione_produkty
FROM ElementyZamowienia;

-- 2. Zmodyfikuj instrukcj� z zadania 1, aby ustali� ��czn� liczb� sprzedanych produkt�w (prod_id) BR01.

SELECT SUM(ilosc) AS zamowione_produkty
FROM ElementyZamowienia
WHERE prod_id = 'BR01';

-- 3. Napisz instrukcj�, aby ustali� cen� (prod_cena) najdro�szego produktu z tabeli Produkty, kt�re kosztuje nie wi�cej ni� 10. Obliczone pole nazwij cena_maks.

SELECT MAX(prod_cena) AS cena_maks
FROM Produkty
WHERE prod_cena <= 10;

------------------------------
-- Rozdzia� 10 - Chapter 10
------------------------------

-- 1. Tabela ElementyZamowienia zawiera pojedyncze pozycje ka�dego zam�wienia. Napisz instrukcj�, kt�ra zwraca liczb� pozycji (jako pole zam_pozycje) dla ka�dego numeru 
-- zam�wienia (zam_numer). Posortuj wed�ug pola zam_pozycje.

SELECT zam_numer, COUNT(*) AS zam_pozycje
FROM ElementyZamowienia
GROUP BY zam_numer
ORDER BY zam_pozycje;

-- 2. Napisz instrukcj� kt�ra zwraca pole o nazwie najtanszy_prod, zawieraj�ce najta�szy produkt od ka�dego producenta (u�yj pola prod_cena z tabeli Produkty). Posortuj 
-- wyniki od najta�szego produktu do najdro�szego.

SELECT dost_id, MIN(prod_cena) AS najtanszy_prod
FROM Produkty
GROUP BY dost_id
ORDER BY najtanszy_prod;

-- 3. Napisz instrukcj�, kt�ra zwraca numery (zam_numer z tabeli ElementyZamowienia) wszystkich zam�wie� obejmuj�cych przynajmniej 100 element�w.

SELECT zam_numer
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING SUM(ilosc) >= 100
ORDER BY zam_numer;

-- 4. Napisz instrukcj�, kt�ra zwraca numery (zam_numer z tabeli ElementyZamowienia) wszystkich zam�wie�, w kt�rych ��czna cena wynios�a przynajmniej 1000. (musisz obliczy�
--  sumaryczn� cen� produkt�w cena_elem mno�one prze ilosc). Posortuj wyniki wed�ug numer�w zam�wie�.

SELECT zam_numer, SUM(cena_elem*ilosc) AS cena_w_sumie
FROM ElementyZamowienia
GROUP BY zam_numer
HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY zam_numer;

------------------------------
-- Rozdzia� 11 - Chapter 11
------------------------------

-- 1. U�ywaj�c zapytania zagnie�d�onego, zwr�� list� klient�w, kt�rzy kupili produkty o cenie 10 lub wy�szej. U�yj tabeli ElementyZamowienia, aby znale�� odpowiednie numery
-- zam�wie� (zam_numer), a nast�pnie tabeli Zamowienia, by pobra� identyfikatory klient�w (kl_id) powi�zane z tymi zam�wieniami.

SELECT kl_id
FROM Zamowienia
WHERE zam_numer IN (SELECT zam_numer
                    FROM ElementyZamowienia
                    WHERE cena_elem >= 10);

-- 2. Chcesz ustali� daty, w kt�rych zam�wiono produkt BR01. Napisz instrukcj� z zapytaniem zagnie�d�aj�cym, aby okre�li� w kt�rych zam�wieniach (z tabeli ElementyZamowienia)
-- znalaz�y si� elementy o identyfikatorze (prod_id) BR01. Nast�pnie zwr�� identyfikator klienta (kl_id) i dat� zam�wienia (zam_data) dla ka�dego takiego zam�wienia z tabeli
-- Zamowienia. Wyniki posortuj wed�ug daty zam�wienia.

SELECT kl_id, zam_data
FROM Zamowienia
WHERE zam_numer IN (SELECT zam_numer
                    FROM ElementyZamowienia
                    WHERE prod_id = 'BR01')
ORDER BY zam_data;

-- 3. Zamie� poprzednie zadanie tak aby instrukcja zwraca�a emaile (kl_email z tabeli Klienci) wszystkich klient�w, kt�rzy zakupili produkty o identyfikatorze (prod_id) BR01. 

SELECT kl_email FROM Klienci
WHERE kl_id IN (SELECT kl_id
                FROM Zamowienia
                WHERE zam_numer IN (SELECT zam_numer
                                    FROM ElementyZamowienia
                                    WHERE prod_id = 'BR01'));

-- 4. Napisz instrukcj�, kt�ra zwraca identyfikator klienta (kl_id z tabeli Zamowienia) i warto�� wartosc_zam. U�yj zapytania zagnie�d�onego, aby zwr�ci� sum� warto�ci 
-- zam�wie� ka�dego klienta. Posortuj wyniki wed�ug wydatk�w poszczeg�lnych klient�w (od najwy�szych do najni�szych).

SELECT kl_id,
       (SELECT SUM(cena_elem*ilosc)
        FROM ElementyZamowienia
        WHERE Zamowienia.zam_numer = ElementyZamowienia.zam_numer) 
        AS wartosc_zam
FROM Zamowienia
ORDER BY wartosc_zam DESC;

-- 5. Napisz instrukcj�, kt�ra pobiera z tabeli Produkty wszystkie nazwy produkt�w (prod_nazwa), a tak�e obliczon� kolumn� o nazwie sprzedano_sztuk zawieraj�c� ��czn� liczb�
-- sprzedancyh sztuk ka�dego produktu. T� liczb� pobierz za pomoc� zapytania zagnie�d�onego i funkcji SUM(ilosc) operuj�cej na tabeli ElementyZamowienia.

SELECT prod_nazwa,
       (SELECT SUM(ilosc)
        FROM ElementyZamowienia
        WHERE Produkty.prod_id=ElementyZamowienia.prod_id) AS sprzedano_sztuk
FROM Produkty;

------------------------------
-- Rozdzia� 12 - Chapter 12
------------------------------

-- 1. Napisz instrukcj�, kt�ra zwraca nazw� klienta (kl_nazwa) z tabeli Klienci i numery powi�zanych zam�wie� (zam_numer) z tabeli Zam�wienia. Wynik posortuj najpierw wed�ug
-- nazw klient�w, a nast�pnie wed�ug numer�w zam�wie�. Spr�buj wykona� to zadania dwukrotnie - raz z u�yciem prostej sk�adni z��cze� wewn�trznych i raz za pomoc� sk�adni INNER JOIN.

-- Sk�adnia z��cze� wewn�trznych
SELECT kl_nazwa, zam_numer
FROM Klienci, Zamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- Sk�adnia ANSI INNER JOIN
SELECT kl_nazwa, zam_numer
FROM Klienci INNER JOIN Zamowienia
ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- 2. Opr�cz zwracania nazwy klienta i numeru zam�wienia z poprzedniego zadania dodaj trzeci� kolumn�k wartosc_zam, zawieraj�c� ��czn� warto�� ka�dego zam�wienia. Mo�esz to 
-- zrobi� na dwa sposoby: tworz�c kolumn� wartosc_zam za pomoc� zapytania zagnie�d�onego z u�yciem tabeli ElementyZamowienia lub z��czaj�c tabel� ElementyZamowienia z innymi
-- tabelami i u�ywaj�c funcji agregujacej.

-- Rozwi�zanie z u�yciem zapyta� zagnie�d�onych
SELECT kl_nazwa,
       zam_numer,
       (SELECT SUM(cena_elem*ilosc)
       FROM ElementyZamowienia
       WHERE Zamowienia.zam_numer=ElementyZamowienia.zam_numer) 
       AS wartosc_zam
FROM Klienci, Zamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa, zam_numer;

-- Rozwi�zanie z u�yciem z��cze�
SELECT kl_nazwa,
       Zamowienia.zam_numer,
       SUM(cena_elem*ilosc) AS wartosc_zam
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
 AND Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa, Zamowienia.zam_numer
ORDER BY kl_nazwa, zam_numer;

-- 3. Napisz instrukcj�, kt�ra pobiera daty zam�wienia produktu BR01, przy czym u�yj z��czenia i prostej sk�adni z��cze� wewn�trznych.

SELECT kl_id, zam_data
FROM Zamowienia, ElementyZamowienia
WHERE Zamowienia.zam_numer = ElementyZamowienia.zam_numer
AND prod_id = 'BR01'
ORDER BY zam_data;

-- 4. Napisz instrukcj�, kt�ra zwraca�a emaile (kl_email z tabeli Klienci) wszystkich klient�w, kt�rzy zakupili produkty o identyfikatorze (prod_id) BR01. U�yj sk�adni ANSI INNER JOIN.

SELECT kl_email
FROM Klienci
 INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
 INNER JOIN ElementyZamowienia 
            ON Zamowienia.zam_numer = ElementyZamowienia.zam_numer
WHERE prod_id = 'BR01';

-- 5. Napisz instrukcj�, kt�ra za pomoc� z��cze� zwraca nazwy klient�w (kl_nazwa) z tabeli Klienci i warto�ci ich zam�wie� z tabeli ElementyZamowienia. Aby po��czy� te tabele,
-- musisz uwzgl�dni� tak�e tabel� Zam�wienia. Posortuj wyniki wed�ug nazw klient�w.

-- Sk�adnia z��cze� wewn�trznych
SELECT kl_nazwa, SUM(cena_elem*ilosc) AS wydatki_razem
FROM Klienci, Zamowienia, ElementyZamowienia
WHERE Klienci.kl_id = Zamowienia.kl_id
 AND Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY kl_nazwa;

-- Sk�adnia ANSI INNER JOIN
SELECT kl_nazwa, SUM(cena_elem*ilosc) AS wydatki_razem
FROM Klienci
INNER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id 
INNER JOIN ElementyZamowienia 
           ON Zamowienia.zam_numer = ElementyZamowienia.zam_numer
GROUP BY kl_nazwa
HAVING SUM(cena_elem*ilosc) >= 1000
ORDER BY kl_nazwa;


------------------------------
-- Rozdzia� 13 - Chapter 13
------------------------------

-- 1. Napisz instrukcj� ze z��czeniem INNER JOIN, aby pobra� nazwy klient�w (kl_nazwa z tabeli Klienci) i wszystkie numery zam�wie� (zam_numer z Zamowienia) ka�dego klienta.

SELECT kl_nazwa, zam_numer
FROM Klienci
JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa;

-- 2. Zmodyfikuj instrukcj� z poprzedniego zadania, tak aby wy�wietla�a wszystkie nazwy klient�w (nawet tych kt�rzy nie z�o�yli �adnych zam�wie�).

SELECT kl_nazwa, zam_numer
FROM Klienci
LEFT OUTER JOIN Zamowienia ON Klienci.kl_id = Zamowienia.kl_id
ORDER BY kl_nazwa;

-- 3. U�yj z��czenia OUTER JOIN, aby z��czy� tabele Produkty i ElementyZamowienia. Instrukcja ma zwraca� posortowan� list� nazw produkt�w (prod_nazwa) i numer�w zam�wie� 
-- (zam_numer) powi�zanych z ka�dy produktem.

SELECT prod_nazwa, zam_numer
FROM Produkty
LEFT OUTER JOIN ElementyZamowienia ON Produkty.prod_id = ElementyZamowienia.prod_id
ORDER BY prod_nazwa;

-- 4. Zmodyfikuj utworzon� w zadaniu 3 instrukcj�, aby zwraca�a ��czn� liczb� zam�wie� ka�dego produktu (zamiast numer�w zam�wie�).

SELECT prod_nazwa, COUNT(zam_numer) AS liczba_zam
FROM Produkty
LEFT OUTER JOIN ElementyZamowienia ON Produkty.prod_id = ElementyZamowienia.prod_id
GROUP BY prod_nazwa
ORDER BY prod_nazwa;

-- 5. Napisz instrukcj�, kt�ra wy�wietla dostawc�w (dost_id z tabeli Dostawcy) i liczb� produkt�w oferowanych przez ka�dego z nich. Nale�y pokaza� tak�e dostawc�w, kt�rzy 
-- nie oferuj� �adnych produkt�w. Zastosuj z��czenie OUTER JOIN i funkcj� agreguj�c� COUNT(), aby zliczy�, ile produkt�w z talebi Produkty oferuje ka�dy dostawca.

SELECT Dostawcy.dost_id, COUNT(prod_id) 
FROM Dostawcy 
LEFT OUTER JOIN Produkty ON Dostawcy.dost_id = Produkty.dost_id
GROUP BY Dostawcy.dost_id;

------------------------------
-- Rozdzia� 14 - Chapter 14
------------------------------

-- 1. Napisz instrukcj�, kt�ra obejmuje dwie instrukcje SELECT pobieraj�ce identyfikator produktu (prod_id) i ilosc z tabeli ElementyZamowienia. Filtrowanie w jednej 
-- instrukcji SELECT ma zwraca� tylko te wiersze z kolumn� ilo�� r�wn� 100. a w drugiej wiersze z produktami o identyfikatorze rozpoczynaj�cym si� od liter BNBG. Wyniki 
-- posortuj wed�ug identyfikator�w produkt�w.

SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE ilosc = 100
UNION
SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 2. Zmodyfikuj utworzon� w zadaniu 1 instrukcj�, u�ywaj�c tylko jednej instrukcji SELECT.

SELECT prod_id, ilosc
FROM ElementyZamowienia
WHERE ilosc = 100 OR prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 3. Napisz instrukcj�, kt�ra zwraca i ��czy nazw� produktu (prod_nazwa) z tabeli Produkty i nazw� klienta (kl_nazwa) z tabeli Klienci. Wyniki posortuj wed�ug nazw produkt�w.

SELECT prod_nazwa
FROM Produkty
UNION
SELECT kl_nazwa
FROM Klienci
ORDER BY prod_nazwa;

------------------------------
-- Rozdzia� 15 - Chapter 15
------------------------------

-- 1. U�ywaj�c instrukcji INSERT i dost�pnych kolumn, dodaj swoje dane do tabeli Klienci. Bezpo�rednio podaj dodawane kolumny i u�yj tylko tych, kt�rych potrzebujesz.

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
       'Krak�w',
       'MAL',
       '48237',
       'Polska',
       'nowy@poczta.com');

-- 2. Utw�rz kopie zapasowe tabel Zamowienia i ElementyZamowienia.

SELECT * INTO ZamowieniaKopia FROM Zamowienia;
SELECT * INTO ElementyZamowieniaKopia FROM ElementyZamowienia;

------------------------------
-- Rozdzia� 16 - Chapter 16
------------------------------

-- 1. Skr�ty nazw polskich wojew�dztw powinny sk�ada� si� z wielkich liter. Napisz instrukcj�, kt�ra modyfikuje wszystkie adresy z Polski - zar�wno pole dost_woj w tabeli 
-- Dostawcy, jak i pole kl_woj w tabeli Klienci. Tak aby skr�ty nazw wojew�dztw by�y zapisane wielkimi literami.

UPDATE Dostawcy
SET dost_woj = UPPER(dost_woj)
WHERE dost_kraj = 'Polska';

UPDATE Klienci
SET kl_woj = UPPER(kl_woj)
WHERE kl_kraj = 'Polska';

-- 2. Usu� dane dodane w zadaniu 1 w rozdziale 15. Najprierw przetestuj klauzul� za pomoc� instrucji SELECT.

-- tylko te dane, kt�re chcesz usun��
SELECT * FROM Klienci
WHERE kl_id = 1000000042;

-- Nast�pnie usu� dane
DELETE Klienci
WHERE kl_id = 1000000042;

------------------------------
-- Rozdzia� 17 - Chapter 17
------------------------------

-- 1. Dodaj kolumn� z adresem witryny (dost_witryna) do tabeli Dostawcy. Potrzebne jest tu pole tekstowe wystarczaj�co d�ugie aby zmie�ci� adres URL.

ALTER TABLE Dostawcy
ADD dost_witryna CHAR(100);

-- 2. U�yj instrukcji UPDATE, aby zmodyfikowa� rekordy z tabeli Dostawcy i doda� do nich adres witryny. 

UPDATE Dostawcy
SET dost_witryna = 'https://google.com/'
WHERE dost_id = 'DLL01';

------------------------------
-- Rozdzia� 18 - Chapter 18
------------------------------

-- 1. Utw�rz perspektyw� KlienciZZamowieniami zawieraj�c� wszystkie kolumny z tabeli Klenci, ale obejmuj�c� tylko wiersze klient�w, kt�rzy z�o�yli jakie� zam�wienia.

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

