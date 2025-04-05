-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- Vytvořím si view, kde bude průměr meziročního růstu cen za každou kategorii ptravin

-- ZÁVĚR: Nejpomaleji zdražuje kategorie Cukr krystalový, její průměrné meziroční zdražení je -1,92 % (vlastně zlevňuje)
	-- doplnění, když bereme v úvahu kategorie které opravdu zdražují, tak nejpomaleji zdražuje 

CREATE OR REPLACE VIEW v_avg_change_for_all_categories AS
	WITH avg_prices_per_years AS (
		SELECT 
			tf.price_name,
			tf.price_year,
			tf.price_avg,
			LAG(tf.price_avg) OVER (PARTITION BY tf.price_name ORDER BY tf.price_year) AS price_avg_previous_year
		FROM t_Lukas_Karasek_project_SQL_primary_final tf
		GROUP BY tf.price_name, tf.price_year
		ORDER BY tf.price_name, tf.price_year
	), 
	percentage_change_per_years AS (
		SELECT 
			*,
			ROUND((apfy.price_avg - apfy.price_avg_previous_year) / apfy.price_avg_previous_year * 100, 2) AS percent_change
		FROM avg_prices_per_years apfy
	)
	SELECT
		pcpy.price_name,
		ROUND(AVG(pcpy.percent_change), 2) AS avg_percentage_change
	FROM percentage_change_per_years pcpy
	GROUP BY pcpy.price_name;

-- Vyberu z view řádek s nejnižší hodnotou (kde se rovná svému minimu)
SELECT
	*
FROM v_avg_change_for_all_categories
WHERE avg_percentage_change = (SELECT MIN(avg_percentage_change) FROM v_avg_change_for_all_categories vacfac);


-- podmínkou vyřadím záporné hodnoty (ty kategorie které průměrně zlevnily)
SELECT 
	*
FROM v_avg_change_for_all_categories
WHERE avg_percentage_change >= 0
ORDER BY avg_percentage_change
LIMIT 1;

