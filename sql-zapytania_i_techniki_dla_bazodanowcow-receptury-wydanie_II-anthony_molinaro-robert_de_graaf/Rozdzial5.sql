-- Rozdział 5. Zapytania przetwarzaj¹ce metadane

-- 5.1. Generowanie listy tabel wchodzących w skład schematu bazy danych
-- Problem: chcemy uzyskaæ listę wszystkich tabel, które utworzono w danym schemacie bazy danych.
-- Pracujemy ze schematem nazwanym SMEAGOL.

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'SMEAGOL';

-- 5.2. Generowanie listy kolumn danej tabeli
-- Problem: Chcemy uzyskaæ listę kolumn interesującej nas tabeli wraz z zadeklarowanymi typami danych tych kolumn oraz oryginalnym porządkiem w tabeli.

SELECT column_name, data_type, ordinal_position
FROM information_schema.columns
WHERE table_schema = 'SMEAGOL'
AND table_name = 'EMP';

-- 5.3. Generowanie listy indeksowanych kolumn danej tabeli
-- Problem: Chcemy uzyskaæ listę indeksów zdefiniowanych dla danej tabeli wraz z kolumnami, których te indeksy dotyczą, i ewentualnymi pozycjami kolumn w ramach tych 
-- indeksów.

SELECT a.name table_name, 
	   b.name index_name,
	   d.name column_name, 
	   c.index_column_id
FROM sys.tables a,
	 sys.indexes b,
	 sys.index_columns c,
	 sys.columns d
WHERE a.object_id = b.object_id
	AND b.object_id = c.object_id
	AND b.index_id = c.index_id
	AND c.object_id = d.object_id
	AND c.column_id = d.column_id
	AND a.name = 'EMP';

-- 4. Generowanie listy ograniczeñ zdefiniowanych dla tabeli
-- Problem: Chcemy uzyskaæ listę ograniczeń (wraz z nazwami odpowiednich kolumn) zdefiniowanych dla pewnej tabeli wchodzącej w skład okreœlonego schematu. 
-- Załóżmy np., że chcemy odnaleźć wszystkie ograniczenia zdefiniowane dla kolumn tabeli EMP.

SELECT a.table_name, 
	   a.constraint_name,
	   b.column_name, 
	   a.constraint_type
FROM information_schema.table_constraints a,
	 information_schema.key_column_usage b
WHERE a.table_name = 'EMP'
	AND a.table_schema = 'SMEAGOL'
	AND a.table_name = b.table_name
	AND a.table_schema =b.table_schema
	AND a.constraint_name = b.constraint_name;

-- 5.5. Generowanie listy kluczy obcych pozbawionych indeksów
-- Problem: Chcemy uzyskaæ listę tabel zawierających tylko te kolumny kluczy obcych, które nie są indeksowane. Przypuśćmy np., że chcemy określić, czy klucze obce w 
-- tabeli EMP są indeksowane.

SELECT fkeys.table_name,
	   fkeys.constraint_name,
	   fkeys.column_name,
	   ind_cols.index_name
FROM (
SELECT a.object_id,
	   d.column_id,
	   a.name table_name,
	   b.name constraint_name,
	   d.name column_name
FROM sys.tables a 
JOIN sys.foreign_keys b
ON (a.name = 'EMP' AND a.object_id = b.parent_object_id)
JOIN sys.foreign_key_columns c
ON (b.object_id = c.constraint_object_id)
JOIN sys.columns d
ON (c.constraint_object_id = d.column_id AND a.object_id = d.object_id)
) fkeys
LEFT JOIN (
SELECT a.name index_name,
	   b.object_id,
	   b.column_id
FROM sys.indexes a,
	 sys.index_columns b
WHERE a.index_id = b.index_id
) ind_cols
ON ( fkeys.object_id = ind_cols.object_id
	AND fkeys.column_id = ind_cols.column_id)
WHERE ind_cols.index_name IS NULL
