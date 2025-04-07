-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- pozn. tady mi ze zadání není jasné, jeslti mám použít průměr nárůstu cen jednotlivých potravin nebo nárůst součtu cen všech potravin pro jednotlivé roky.
-- Přikláním se k variantě součtu cen všech potravin, ze kterého pak počítám meziroční nárůst.

-- ZÁVĚR: V žádném roce není nárůst cen potravin výrazně vyšší (o více jak 10 % bodů) než nárůst průměrných mezd

-- Vytvoří pohled přírůstek průměrné mzdy za každé odvětví pro jednotlivé roky
CREATE OR REPLACE VIEW v_Lukas_Karasek_change_payroll_per_year AS
	WITH payroll_avg_per_year AS (
		WITH payroll_avg_per_year_per_brunch AS ( -- průměrná mzda pro každé odvětví v každém toce 
			SELECT
				AVG(tf.payroll_avg) AS payroll_avg_per_year_per_brunch_value,
				year,
				payroll_brunch_name 
			FROM t_Lukas_Karasek_project_SQL_primary_final tf
			GROUP BY tf.year, tf.payroll_brunch_name
		)
		SELECT -- průměrná mzda za všechny odvětví v každém roce
			year,
			ROUND(AVG(payroll_avg_per_year_per_brunch.payroll_avg_per_year_per_brunch_value), 2) AS payroll_avg_per_year_value 
		FROM payroll_avg_per_year_per_brunch
		GROUP BY payroll_avg_per_year_per_brunch.year
	),
	payroll_changes AS ( -- pomocný sloupec předchozích hodnot mzdy pro výpočet nárůstu
		SELECT 
			*,
			ROUND(LAG(papy.payroll_avg_per_year_value) OVER (ORDER BY papy.year), 2) AS payroll_previous
		FROM payroll_avg_per_year papy
	)
	SELECT -- rok a nárůst mzdy oproti předchozímu roku
		pch.year,
		ROUND((pch.payroll_avg_per_year_value - pch.payroll_previous) / pch.payroll_previous * 100 ,2) AS payroll_change
	FROM payroll_changes pch;


-- Vytvoří pohled nárůst ceny všech potravin
CREATE OR REPLACE VIEW v_Lukas_Karasek_change_price_per_year AS
	WITH total_prices AS ( -- součet cen všeh potravin pro jednotlivé roky
		SELECT
			tf.year,
			SUM(tf.price_avg) AS total_price_per_year
		FROM t_Lukas_Karasek_project_SQL_primary_final tf
		GROUP BY tf.year
	),
	previous_prices AS ( -- pomocný sloupec předchozích hodnot součtu cen
		SELECT 
			*,
			LAG(total_prices.total_price_per_year) OVER (ORDER BY total_prices.year) AS previous_price
		FROM total_prices
	)
	SELECT 
		previous_prices.year,
		ROUND((previous_prices.total_price_per_year - previous_prices.previous_price) / previous_prices.previous_price * 100,2) AS price_change
	FROM previous_prices;


-- spojím tabulky a zjistím rozdíl nárůstu cen potravin a průměrné mzdy a sečtu roky, kdy byla hodnota větší než deset
WITH differences AS (
	SELECT
		vpaych.year,
		vpaych.payroll_change,
		vprich.price_change,
		vprich.price_change - vpaych.payroll_change AS diff_prices_payrolls,
		CASE
			WHEN (vprich.price_change - vpaych.payroll_change) > 10 THEN 'větší než 10 %'
			ELSE 'menší než 10 %'
		END AS high_difference
	FROM v_Lukas_Karasek_change_payroll_per_year vpaych
	INNER JOIN v_Lukas_Karasek_change_price_per_year vprich ON vpaych.year = vprich.year
)
SELECT COUNT(1) AS count_of_high_difference -- vypíše počet řádků, kdy hodnota sloupce high_difference začíná na 'větší'
FROM differences 
WHERE high_difference LIKE 'větší%';