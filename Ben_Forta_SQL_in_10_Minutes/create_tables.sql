---------------------------------------------------------------
-- Skrypt tworzenia tabel dla bazy danych Microsoft SQL Server.
-- Example table creation scripts for Microsoft SQL Server.
---------------------------------------------------------------


---------------------------
-- Tworzenie tabeli Klienci
-- Create Customers table
---------------------------
CREATE TABLE Klienci
(
	kl_id		char(10)	NOT NULL,
	kl_nazwa	char(50)	NOT NULL,
	kl_adres	char(50)	NULL ,
	kl_miasto	char(50)	NULL ,
	kl_woj		char(20)	NULL ,
	kl_kod		char(10)	NULL ,
	kl_kraj		char(50)	NULL ,
	kl_kontakt	char(50)	NULL ,
	kl_email	char(255)	NULL 
);

--------------------------------------
-- Tworzenie tabeli ElementyZamowienia
-- Create OrderItems table
--------------------------------------
CREATE TABLE ElementyZamowienia
(
  zam_numer  	int          NOT NULL ,
  zam_element 	int          NOT NULL ,
  prod_id    	char(10)    NOT NULL ,
  ilosc 	int          NOT NULL ,
  cena_elem 	decimal(8,2) NOT NULL 
);

------------------------------
-- Tworzenie tabeli Zamowienia
-- Create Orders table
------------------------------
CREATE TABLE Zamowienia
(
  zam_numer  int       NOT NULL ,
  zam_data   datetime  NOT NULL ,
  kl_id      char(10) NOT NULL 
);

----------------------------
-- Tworzenie tabeli Produkty
-- Create Products table
----------------------------
CREATE TABLE Produkty
(
  prod_id     char(10)      NOT NULL ,
  dost_id     char(10)      NOT NULL ,
  prod_nazwa  char(255)     NOT NULL ,
  prod_cena   decimal(8,2)   NOT NULL ,
  prod_opis   varchar(1000) NULL 
);

----------------------------
-- Tworzenie tabeli Dostawcy
-- Create Vendors table
----------------------------
CREATE TABLE Dostawcy
(
  dost_id      char(10) NOT NULL ,
  dost_nazwa   char(50) NOT NULL ,
  dost_adres   char(50) NULL ,
  dost_miasto  char(50) NULL ,
  dost_woj     char(5)  NULL ,
  dost_kod     char(10) NULL ,
  dost_kraj    char(50) NULL 
);

-------------------------------
-- Definiowanie kluczy g³ównych
-- Define primary keys
-------------------------------
ALTER TABLE Klienci WITH NOCHECK ADD CONSTRAINT PK_Klienci PRIMARY KEY CLUSTERED (kl_id);
ALTER TABLE ElementyZamowienia WITH NOCHECK ADD CONSTRAINT PK_ElementyZamowienia PRIMARY KEY CLUSTERED (zam_numer, zam_element);
ALTER TABLE Zamowienia WITH NOCHECK ADD CONSTRAINT PK_Zamowienia PRIMARY KEY CLUSTERED (zam_numer);
ALTER TABLE Produkty WITH NOCHECK ADD CONSTRAINT PK_Produkty PRIMARY KEY CLUSTERED (prod_id);
ALTER TABLE Dostawcy WITH NOCHECK ADD CONSTRAINT PK_Dostawcy PRIMARY KEY CLUSTERED (dost_id);

-----------------------------
-- Definiowanie kluczy obcych
-- Define foreign keys
-----------------------------
ALTER TABLE ElementyZamowienia ADD
CONSTRAINT FK_ElementyZamowienia_Zamowienia FOREIGN KEY (zam_numer) REFERENCES Zamowienia (zam_numer),
CONSTRAINT FK_ElementyZamowienia_Produkty FOREIGN KEY (prod_id) REFERENCES Produkty (prod_id);
ALTER TABLE Zamowienia ADD 
CONSTRAINT FK_Zamowienia_Klienci FOREIGN KEY (kl_id) REFERENCES Klienci (kl_id);
ALTER TABLE Produkty ADD
CONSTRAINT FK_Produkty_Dostawcy FOREIGN KEY (dost_id) REFERENCES Dostawcy (dost_id);
