-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- pomocí tabulky t_Lukas_Karasek_project_SQL_primary_final seřazené podle let porovnám dvě následující hodnoty podle let a doplním sloupec, jestli klesají nebo stoupají

-- ZÁVĚR: Mzdy nerostou ve všech odvětvích v každém roce, ale ve většině sledovaných let – 89,91 %

-- vytvoří pohled: odvětví, rok a průměrná mzda a přidá slupec předchozí hodnoty mzdy a sloupec 'is_decreasing' s hodnotami 1 nebo 0 / 1 = pravda že klesá

CREATE OR REPLACE VIEW v_is_decreasing AS
	WITH orig_values AS (
	    SELECT DISTINCT
	        payroll_brunch_name,
	        payroll_year,
	        payroll_avg
	    FROM t_Lukas_Karasek_project_SQL_primary_final
		)
		SELECT
		    orig_values.*,
		    LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY payroll_year) AS payroll_avg_previous,
		    CASE
			    WHEN LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY payroll_year) IS NULL THEN NULL -- 
		    	WHEN LAG(payroll_avg) OVER (PARTITION BY payroll_brunch_name ORDER BY payroll_year) > payroll_avg THEN 1 -- předchozí rok je větší (mzda klesla), takže do 'is_decreasing' uložím 1, jako pravda
		    	ELSE 0
		    END	AS is_decreasing
		FROM orig_values;

-- jednotlivé odvětví a roky, kdy mzda klesla oproti minulému roku v témže odvětví
SELECT *
FROM v_is_decreasing
WHERE is_decreasing = 1;


-- počet jedinečných let a odvětví, kdy mzda klesá a stoupá a celkový počet sledovaných roků
SELECT
	COUNT(CASE WHEN is_decreasing = 1 THEN 1 END) AS count_decreasing, -- celkový počet let, kdy mzda klesá
	ROUND(COUNT(CASE WHEN is_decreasing = 1 THEN 1 END) / COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) * 100, 2) AS percent_years_decreasing, -- procent z celkového počtu porovnávaných roků 
	COUNT(CASE WHEN is_decreasing = 0 THEN 1 END) AS count_increasing, -- celkový počet let, kdy mzda stopá
	ROUND(COUNT(CASE WHEN is_decreasing = 0 THEN 1 END) / COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) * 100, 2) AS percent_years_increasing, -- procent z celkového počtu porovnávaných roků 
	COUNT(CASE WHEN is_decreasing IS NOT NULL THEN 1 END) AS count_total_years -- nespočítá první roky pro každé odvětví, protože mají hodnotu NULL - nebylo s čím porovnávat
FROM v_is_decreasing;
