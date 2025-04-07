-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- ZÁVĚR: Roky kdy výrazněji vzrostlo HDP (pozn. ty jsou počítány tak, kdy byla hodnota růstu HDP 2x větší než průměrný růst HDP za všechny roky): 2007, 2015 a 2017<br>

-- Roky kdy rostlo HDP výrazněji
   -- V těchto letech rostly také ceny potravin - růst byl větší než průměr růstu cen potravin za celé sledované období
   -- Mzdy rostly jen ve dvou případech v letech 2007 a 2017, v roce 2015 byl růst mezd pod průměrem růstu mezd za celé sledované bdobí
-- Roky následující po výrazném růstu HDP 2008, 2016 a 2017
	-- Růst ceny potraviny byl větší než průměrný růst pouze v jednom případě (2008)
	-- Růst mezd byl nadprůměrný v letech 2008 a 2018, v roce 2016 byl růst mezd podprůměrný 
		-- Zde můžeme vidět podobný vzorec: když rostlo HDP výrazně a přírůstek mzdy byl nadprůměrný (2007 a 2017), byly přírůstky nadprůměrné i v následujících letech (2008 resp. 2018)
		-- Naopak, když rostlo HDP výrazně a přírůstek mzdy byl podprůměrný (2015), byl přírůstek také podprůměrný (2016)

-- Růst cen potravin takový vzorec nevykazují na první pohled 
	-- V roce 2015 byl růst cen potravin nadprůměrný (3,27 %) ale nižší oproti růstu cen potravin v letech 2007 a 2017
	-- V roce 2018 byl růst také podprůměrný, ale opět byl prostřední rok (2016) nejnižší z oněch tří let následujících

-- Nelze tedy jednoznačně říct, jeslti měl růst hdp přímý vliv na růst ceny potravin a mezd. Protože ne vždy, když rostlo HDP výrazněji rostly výrazněji oboje další kategorie v témže a následujícím roce.


-- pro vyřešení se používají VIEW vytvořené v otázce č. 4 
-- v_Lukas_Karasek_change_payroll_per_year
-- v_Lukas_Karasek_change_price_per_year
-- je potřeba je vytvořit pokud nexistují


-- pohled s procentuálním přírůstekm HDP
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
		ROUND((chc.current_hdp - chc.previous_hdp) / chc.previous_hdp * 100, 2) AS hdp_change
	FROM czech_hdp_change chc;

-- pohled kde spojím všechny přírůstky (potraviny, mzdy a hdp) na roky
CREATE OR REPLACE VIEW v_lukas_karasek_compare_year_changes AS
	SELECT  
		v_price.year,
		v_price.price_change,
		v_pay.payroll_change,
		v_hdp.hdp_change
	FROM v_lukas_karasek_change_price_per_year v_price
	INNER JOIN v_lukas_karasek_change_payroll_per_year v_pay ON v_price.year = v_pay.year
	INNER JOIN v_lukas_karasek_change_hdp_per_year v_hdp ON v_hdp.year = v_pay.year;

SELECT *
FROM v_lukas_karasek_compare_year_changes;

-- pohled průměrné růsty za všechny kategorie
CREATE OR REPLACE VIEW v_lukas_karasek_avg_data_all AS
	SELECT
		ROUND(AVG(price_change), 2) AS avg_price_change,
		ROUND(AVG(payroll_change), 2) AS avg_payroll_change,
		ROUND(AVG(hdp_change), 2) AS avg_hdp_change
	FROM v_lukas_karasek_compare_year_changes;

-- vypíše roky, kdy je polovina hodnoty růstu HDP stále větší než průměr růstu HDP - relativně výrazný růst - a k nim data růstu cen, mezd a hdp
CREATE OR REPLACE VIEW v_lukas_karasek_years_hdp_significant_grow AS
	WITH years_hdp_significant_grow AS (
		SELECT
			comp.year AS year_significant_grow_hdp
		FROM v_lukas_karasek_compare_year_changes comp
		WHERE
			comp.hdp_change / 2 > (SELECT AVG(hdp_change) FROM v_lukas_karasek_compare_year_changes)
	)
	SELECT 
		ygr.*,
		'grow year' AS is_grow_or_next_year,
		cmp.price_change,
		cmp.payroll_change,
		cmp.hdp_change
	FROM years_hdp_significant_grow ygr
	INNER JOIN v_lukas_karasek_compare_year_changes cmp ON cmp.year = ygr.year_significant_grow_hdp;


-- vytvořím 2. pohled - vyberu roky, které následují po letech s výrazným růstem z předchozího pohledu
CREATE OR REPLACE VIEW v_lukas_karasek_years_next_hdp_significant_grow AS
	WITH years_hdp_significant_grow AS (
		SELECT
			comp.year AS next_year_significant_grow_hdp
		FROM v_lukas_karasek_compare_year_changes comp
		WHERE
			comp.year IN (SELECT v_hsg.year_significant_grow_hdp + 1 FROM v_lukas_karasek_years_hdp_significant_grow v_hsg)
	)
	SELECT 
		ygr.*,
		'next year' AS is_grow_or_next_year,
		cmp.price_change,
		cmp.payroll_change,
		cmp.hdp_change
	FROM years_hdp_significant_grow ygr
	INNER JOIN v_lukas_karasek_compare_year_changes cmp ON cmp.year = ygr.next_year_significant_grow_hdp;

-- vytvořím sestavup pomocí UNION, kde vidím roky kdy rostlo HDP a roky které následovaly po těchto letech
-- přidám sloupce price_change a payroll_change a za každý z nich počítám, jestli je změna větší než průměrná změna
-- průměrné změny jsou uložené v poledu v_lukas_karasek_avg_data_all
SELECT 
	vg.year_significant_grow_hdp,
	vg.is_grow_or_next_year,
	vg.price_change,
	CASE 
		WHEN vg.price_change > (SELECT avg_price_change FROM v_lukas_karasek_avg_data_all) THEN 'bigger than average'
		ELSE 'lower or same as average'
	END AS price_change_significant,
	vg.payroll_change,
	CASE 
		WHEN vg.payroll_change > (SELECT avg_payroll_change FROM v_lukas_karasek_avg_data_all) THEN 'bigger than average'
		ELSE 'lower or same as average'
	END AS payroll_change_significant,
	vg.hdp_change
FROM v_lukas_karasek_years_hdp_significant_grow vg
UNION ALL
SELECT 
	vgn.next_year_significant_grow_hdp,
	vgn.is_grow_or_next_year,
	vgn.price_change,
	CASE 
		WHEN vgn.price_change > (SELECT avg_price_change FROM v_lukas_karasek_avg_data_all) THEN 'bigger than average'
		ELSE 'lower or same as average'
	END AS price_change_significant,
	vgn.payroll_change,
	CASE 
		WHEN vgn.payroll_change > (SELECT avg_payroll_change FROM v_lukas_karasek_avg_data_all) THEN 'bigger than average'
		ELSE 'lower or same as average'
	END AS payroll_change_significant,
	vgn.hdp_change
FROM v_lukas_karasek_years_next_hdp_significant_grow vgn;




