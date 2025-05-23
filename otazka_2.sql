-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- ZÁVĚR: 
	-- V roce 2006 je možné si za průměrnou mzdu ze všech odvětví koupit 1 287 kg chleba a 1 437 litrů mléka
	-- V roce 2018 je možné si za průměrnou mzdu ze všech odvětví koupit 1 342 kg chleba a 1 641 litrů mléka

-- Vytvoří pohled kde jsou údaje pouze za mléko a chleba v prvním (nejnižším) a posledním (nejvyšším) sledovaném roce a průměr mezd za všechna odvětví

CREATE OR REPLACE VIEW v_lukas_karasek_kchleb_mleko_prvni_posledni_rok AS
	WITH chleb_a_mleko AS (
		SELECT 
			tfinal.payroll_avg,
			-- tfinal.payroll_brunch_name, -- pomocná linka pro přehled
			tfinal.price_avg,
			tfinal.price_name,
			tfinal.year,
			tfinal.price_value,
			tfinal.price_unit 
		FROM t_Lukas_Karasek_project_SQL_primary_final tfinal
		WHERE 1
			AND (tfinal.price_name LIKE 'Chléb%'
			OR tfinal.price_name LIKE 'Mléko%')
	)
	SELECT 
		AVG(payroll_avg) AS avg_payroll_all_brunches,
		price_avg,
		price_name,
		year,
		price_value,
		price_unit
	FROM chleb_a_mleko
	WHERE 1
		AND (year = (SELECT MIN(year) FROM chleb_a_mleko)
		OR year = (SELECT MAX(year) FROM chleb_a_mleko))
	GROUP BY price_name, year;

-- Dotaz pro získání možného počtu koupených chlebů nebo mléka za průměrnou mzdu v prvním a poseldním roce

SELECT 
	*,
	FLOOR(vchm.avg_payroll_all_brunches / vchm.price_avg) AS possible_to_buy, -- funkce FLOOR() odstraní desetiná místa (zaokrouhlení vždy dolů), protože můžeme koupit jen celé kg nebo litry
FROM v_lukas_karasek_kchleb_mleko_prvni_posledni_rok vchm;