-- ZÁVĚR: v letech kdy výrazněji vzrostlo HDP (pozn. to je počítáno tak, kdy byl růst 2x větší než průměrný růst)
	-- jedná se o roky 2007, 2015 a 2017
	-- v těchto letech rostly ceny potravin nebo průměrné mzdy také výrazněji oproti průměrému růstu


-- pro vyřešení se používají VIEW vytvořené v otázce č. 4 
-- v_Lukas_Karasek_change_payroll_per_year
-- v_Lukas_Karasek_change_price_per_year
-- je potřeba je vytvořit pokud nexistují

CREATE OR REPLACE VIEW v_lukas_karasek_change_hdp_per_year AS
	WITH czech_hdp AS (
		SELECT *
		FROM t_Lukas_Karasek_project_SQL_secondary_final
		WHERE country LIKE 'Cz%'
	), 
	czech_hdp_change AS (
		SELECT 
			ch.year,
			ch.GDP AS current_hdp,
			LAG(ch.GDP) OVER (ORDER BY ch.year) AS previous_hdp
		FROM czech_hdp ch
	)
	SELECT
		chc.year,
		chc.current_hdp,
		chc.previous_hdp,
		ROUND((chc.current_hdp - chc.previous_hdp) / chc.previous_hdp * 100, 2) AS change_hdp
	FROM czech_hdp_change chc;

CREATE OR REPLACE VIEW v_lukas_karasek_compare_year_changes AS
	SELECT  
		v_price.price_year AS year,
		v_price.price_change,
		v_pay.payroll_change,
		v_hdp.change_hdp,
		v_hdp.current_hdp
	FROM v_lukas_karasek_change_price_per_year v_price
	INNER JOIN v_lukas_karasek_change_payroll_per_year v_pay ON v_price.price_year = v_pay.payroll_year
	INNER JOIN v_lukas_karasek_change_hdp_per_year v_hdp ON v_hdp.year = v_pay.payroll_year;

SELECT *
FROM v_lukas_karasek_compare_year_changes;

-- průměrné růsty za všechny kategorie
SELECT
	AVG(price_change),
	AVG(payroll_change),
	AVG(change_hdp)
FROM v_lukas_karasek_compare_year_changes;

-- vypíše roky, kdy je polovina hodnoty růstu HDP stále větší než průměr růstu HDP - výrazný růst
SELECT 
	comp.year AS year_significant_grow_hdp
FROM v_lukas_karasek_compare_year_changes comp
WHERE comp.change_hdp / 2 > (SELECT AVG(change_hdp) FROM v_lukas_karasek_compare_year_changes);

