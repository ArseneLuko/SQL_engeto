-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- ZÁVĚR: Ano, mzdy rostou ve všech odvěcích, ale ne v každém sledovaném roce. V některých letech mzdy klesají, 
-- ale ve většině sledovaných let – 89,91 % mzdy stoupají. Ve skriptu jsou také SQL sady pro zobrazení počtu let, 
-- kdy mzda klesá (ř. 28) a odvětví, které zaznamenalo nejčastěji pokles (ř. 36)

-- Vytvoří pohled: odvětví, rok a průměrná mzda a přidá slupec předchozí hodnoty mzdy a sloupec 'is_decreasing' s hodnotami 1 nebo 0 / 1 = pravda že klesá

CREATE OR REPLACE VIEW v_is_decreasing AS
	WITH orig_values AS (
	    SELECT DISTINCT
	        payroll_brunch_name,
	        year,
	        payroll_avg
	    FROM t_Lukas_Karasek_project_SQL_primary_final
		)
		SELECT
		    orig_values.*,
		    LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY year) AS payroll_avg_previous,
		    CASE
			    WHEN LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY year) IS NULL THEN NULL -- 
		    	WHEN LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY year) > payroll_avg THEN 1 -- předchozí rok je větší (mzda klesla), takže do 'is_decreasing' uložím 1, jako pravda
		    	ELSE 0
		    END	AS is_decreasing
		FROM orig_values;

-- Kolikrát v jednotlivých odvětvích byl zaznamenán meziroční pokles mzdy.
SELECT 
	payroll_brunch_name,
	COUNT(1) AS payroll_decrease
FROM v_is_decreasing
WHERE is_decreasing = 1
GROUP BY payroll_brunch_name;

-- Odvětví s největším počtem let, ve kterých mzda klesá
SELECT 
	payroll_brunch_name,
	COUNT(1) AS payroll_decrease
FROM v_is_decreasing
WHERE is_decreasing = 1
GROUP BY payroll_brunch_name
ORDER BY payroll_decrease DESC
LIMIT 1;

-- Počet jedinečných let a odvětví, kdy mzda klesá a stoupá a jejich prcento z celkového počtu sledovaných let
SELECT
	COUNT(CASE WHEN is_decreasing = 1 THEN 1 END) AS count_decreasing, -- celkový počet let, kdy mzda klesá
	ROUND(COUNT(CASE WHEN is_decreasing = 1 THEN 1 END) / COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) * 100, 2) AS percent_years_decreasing, -- procent z celkového počtu porovnávaných roků 
	COUNT(CASE WHEN is_decreasing = 0 THEN 1 END) AS count_increasing, -- celkový počet let, kdy mzda stopá
	ROUND(COUNT(CASE WHEN is_decreasing = 0 THEN 1 END) / COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) * 100, 2) AS percent_years_increasing, -- procent z celkového počtu porovnávaných roků 
	COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) AS count_total_years -- nespočítá první roky pro každé odvětví, protože mají hodnotu NULL - nebylo s čím porovnávat
FROM v_is_decreasing;
