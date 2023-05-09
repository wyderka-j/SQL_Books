-- ------------------------------------------------------------------------------
-- Rozdział 1 Instalowanie bazy danych MySQL
-- ------------------------------------------------------------------------------

-- Sprawdzenie katalogu MySQL i pliki domyślne

-- Zawartość katologu MySQL
SELECT @@datadir;

-- Podkatalog performance_schema
SELECT * FROM performance_schema.users;

SELECT user, host,
	total_connections AS cxns
FROM performance_schema.accounts
ORDER BY cxns DESC;