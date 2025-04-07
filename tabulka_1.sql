-- Vytvoření první tabulky. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final 
-- (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky)
-- t_Lukas_Karasek_project_SQL_primary_final
-- DISCORD: lukaskarasek__77224


-- vytvoří pohled s průměrným platem podle roku a odvětví (GROUP BY), rok a napojí tabulku s názvem odvětví

CREATE OR REPLACE VIEW v_Lukas_Karasek_avg_payroll AS
	SELECT
		cp.payroll_year AS payroll_year, 
		cpib.name AS payroll_brunch_name,
		ROUND(AVG(cp.value), 2) AS payroll_avg
	FROM czechia_payroll cp
	INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
	WHERE 1
		AND cp.industry_branch_code is not NULL -- vynech řádky kde není zadáno odvětví
		AND cp.value_type_code = (SELECT code FROM czechia_payroll_value_type WHERE name = 'Průměrná hrubá mzda na zaměstnance') -- vyber řádky pouze s údaji o průměrné hrubé mzdě na zaměstnance (podle tabulky czechia_payroll_value_type)
	GROUP BY 
		cp.payroll_year,
		cp.industry_branch_code;

-- vytvořá pohled s pruměrnými cenami podle kategorie a roku (GROUP BY), názvem produktu a rokem

CREATE OR REPLACE VIEW v_Lukas_Karasek_avg_price AS
	SELECT
		YEAR(cp.date_from) AS year, -- rok
		cpc.name price_name, -- název produktu
		ROUND(AVG(cp.value),2) AS price_avg, -- hodnota průměrné ceny za daný rok
		cpc.price_value, -- jednotkové množství
		cpc.price_unit -- jednotka
	FROM czechia_price cp
	INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	GROUP BY cp.category_code, YEAR(cp.date_from);
	
-- předchozí dotaz používá rok ze sloupce date from, níže je konrola, že ve sloupci date_to nenní na žádném řádku jiný rok
SELECT COUNT(1)
FROM czechia_price
WHERE YEAR(date_from) != YEAR(date_to);	



-- Finální dotaz vytvoří tabulku napojením předchozích pohledů na rok
CREATE OR REPLACE TABLE t_Lukas_Karasek_project_SQL_primary_final
	SELECT
		vpy.payroll_brunch_name,
		vpy.payroll_avg, -- z pohledu vpy (payroll) vybere jen dva sloupce, ať neexistují zbytečně duplicitní sloupec pro roky
		vpr.*
	FROM v_Lukas_Karasek_avg_payroll vpy
	INNER JOIN v_Lukas_Karasek_avg_price vpr ON vpy.payroll_year = vpr.year;

SELECT *
FROM t_Lukas_Karasek_project_SQL_primary_final;

	