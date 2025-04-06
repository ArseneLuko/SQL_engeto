-- Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky)
-- t_Lukas_Karasek_project_SQL_primary_final

-- 


-- vytvoří pohled s průměrným platem podle roku a odvětví (GROUP BY), rok a napojí tabulku s názvem odvětví

CREATE OR REPLACE VIEW v_Lukas_Karasek_avg_payroll AS
	SELECT
		ROUND(AVG(cp.value), 2) AS payroll_avg,
		cp.payroll_year AS payroll_year,
		cpib.name AS payroll_brunch_name
	FROM czechia_payroll cp
	INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
	WHERE 1
		AND cp.industry_branch_code is not NULL 
		AND cp.value_type_code = 5958
	GROUP BY 
		cp.payroll_year,
		cp.industry_branch_code;

-- vytvořá pohled s pruměrnými cenami podle kategorie a roku (GROUP BY), názvem produktu a rokem

CREATE OR REPLACE VIEW v_Lukas_Karasek_avg_price AS
	SELECT
		ROUND(AVG(cp.value),2) AS price_avg,
		cpc.name price_name,
		YEAR(cp.date_from) AS price_year,
		cpc.price_value, -- jednotkové množství
		cpc.price_unit -- jednotka
	FROM czechia_price cp
	INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	GROUP BY cp.category_code, YEAR(cp.date_from);



-- FINAL dotaz vytvoří tabulku napojením předchozích pohledů pomocí roku
CREATE OR REPLACE TABLE t_Lukas_Karasek_project_SQL_primary_final
	SELECT *
	FROM v_Lukas_Karasek_avg_payroll vpy
	INNER JOIN v_Lukas_Karasek_avg_price vpr ON vpy.payroll_year = vpr.price_year;
-- KONEC
	