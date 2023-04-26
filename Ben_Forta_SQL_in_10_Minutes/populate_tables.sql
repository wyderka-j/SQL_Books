-----------------------------------------------------------------
-- Skrypt wype�niania tabel dla bazy danych Microsoft SQL Server.
-- Example table population scripts for Microsoft SQL Server.
-----------------------------------------------------------------


-----------------------------
-- Wype�nienie tabeli Klienci
-- Populate Customers table
-----------------------------
INSERT INTO Klienci(kl_id, kl_nazwa, kl_adres, kl_miasto, kl_woj, kl_kod, kl_kraj, kl_kontakt, kl_email)
VALUES('1000000001', 'Zabawki wiejskie', 'Konopi 11', 'Warszawa', 'MAZ', '44-444', 'Polska', 'Jan Kowalski', 'sprzedaz@zabawkiwiejskie.pl');
INSERT INTO Klienci(kl_id, kl_nazwa, kl_adres, kl_miasto, kl_woj, kl_kod, kl_kraj, kl_kontakt)
VALUES('1000000002', '�wiat dziecka', 'Zwyci�stwa 23', 'Krak�w', 'MAL', '43-333', 'Polska', 'Michelle Znany');
INSERT INTO Klienci(kl_id, kl_nazwa, kl_adres, kl_miasto, kl_woj, kl_kod, kl_kraj, kl_kontakt, kl_email)
VALUES('1000000003', 'Zabawa dla wszystkich', 'S�oneczna 1', 'Gliwice', 'SLK', '42-222', 'Polska', 'Piotr Nowak', 'pnowak@zdw.pl');
INSERT INTO Klienci(kl_id, kl_nazwa, kl_adres, kl_miasto, kl_woj, kl_kod, kl_kraj, kl_kontakt, kl_email)
VALUES('1000000004', 'Zabawa dla wszystkich', 'Alei WP 2', 'Pozna�', 'WKP', '88-888', 'Polska', 'Danuta Sroka', 'dsroka@zdw.pl');
INSERT INTO Klienci(kl_id, kl_nazwa, kl_adres, kl_miasto, kl_woj, kl_kod, kl_kraj, kl_kontakt)
VALUES('1000000005', 'Sk�ad zabawek', 'Polna 121', 'Gda�sk', 'POM', '54-545', 'Polska', 'Maria Skowronek');

------------------------------
-- Wype�nienie tabeli Dostawcy
-- Populate Vendors table
------------------------------
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('BRS01','Misie Pysie','Dolna 111','Misiowo','MAZ','44-444', 'Polska');
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('BRE02','Misiowe Imperium','Chopina 32','Gliwice','SLK','44-333', 'Polska');
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('DLL01','Lalki S.A.','Matejki 23','Stasz�w','SWK','99-999', 'Polska');
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('FRB01','Furball Inc.','1000 5th Avenue','New York',NULL,'11111', 'USA');
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('FNG01','Fun and Games','42 Galaxy Road','London', NULL,'N16 6PS', 'Anglia');
INSERT INTO Dostawcy(dost_id, dost_nazwa, dost_adres, dost_miasto, dost_woj, dost_kod, dost_kraj)
VALUES('JTS01','Jouets et ours','1 Rue Amusement','Paris', NULL,'45678', 'Francja');

------------------------------
-- Wype�nienie tabeli Produkty
-- Populate Products table
------------------------------
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BR01', 'BRS01', 'Pluszowy mi� 20 cm', 25.99, 'Pluszowy mi� 20 cm, dostarczany z czapk� i kurtk�');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BR02', 'BRS01', 'Pluszowy mi� 30 cm', 38.99, 'Pluszowy mi� 30 cm, dostarczany z czapk� i kurtk�');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BR03', 'BRS01', 'Pluszowy mi� 40 cm', 51.99, 'Pluszowy mi� 40 cm, dostarczany z czapk� i kurtk�');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BNBG01', 'DLL01', 'Rybka szmacianka z sypkim wype�nieniem', 9.99, 'Rybka szmacianka z sypkim wype�nieniem, dodatkowo robaki szmacianki');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BNBG02', 'DLL01', 'Ptaszek szmacianka z sypkim wype�nieniem', 9.99, 'Ptaszek szmacianka z sypkim wype�nieniem, bez jajek');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('BNBG03', 'DLL01', 'Kr�liczek szmacianka z sypkim wype�nieniem', 9.99, 'Kr�liczek szmacianka z sypkim wype�nieniem, dodatkowo marchewki szmacianki');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('RGAN01', 'DLL01', 'Raggedy Ann', 12.99, '40 cm lalka Raggedy Ann');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('RYL01', 'FNG01', 'Lalka kr�la', 39.49, '30 cm lalka kr�la z odpowiednimi szatami i koron�');
INSERT INTO Produkty(prod_id, dost_id, prod_nazwa, prod_cena, prod_opis)
VALUES('RYL02', 'FNG01', 'Lalka kr�lowej', 39.49, '30 cm lalka kr�lowej z odpowiednimi szatami i koron�');

--------------------------------
-- Wype�nienie tabeli Zamowienia
-- Populate Orders table
--------------------------------
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20005, '2012-05-01', '1000000001');
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20006, '2012-01-12', '1000000003');
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20007, '2012-01-30', '1000000004');
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20008, '2012-02-03', '1000000005');
INSERT INTO Zamowienia(zam_numer, zam_data, kl_id)
VALUES(20009, '2012-02-08', '1000000001');

----------------------------------------
-- Wype�nienie tabeli ElementyZamowienia
-- Populate OrderItems table
----------------------------------------
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20005, 1, 'BR01', 100, 24.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20005, 2, 'BR03', 100, 49.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20006, 1, 'BR01', 20, 25.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20006, 2, 'BR02', 10, 38.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20006, 3, 'BR03', 10, 51.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20007, 1, 'BR03', 50, 50.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20007, 2, 'BNBG01', 100, 9.49);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20007, 3, 'BNBG02', 100, 9.49);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20007, 4, 'BNBG03', 100, 9.49);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20007, 5, 'RGAN01', 50, 11.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20008, 1, 'RGAN01', 5, 12.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20008, 2, 'BR03', 5, 51.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20008, 3, 'BNBG01', 10, 9.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20008, 4, 'BNBG02', 10, 9.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20008, 5, 'BNBG03', 10, 9.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20009, 1, 'BNBG01', 250, 8.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20009, 2, 'BNBG02', 250, 8.99);
INSERT INTO ElementyZamowienia(zam_numer, zam_element, prod_id, ilosc, cena_elem)
VALUES(20009, 3, 'BNBG03', 250, 8.99);
