
WITH avpr AS (
	SELECT
		ROUND(AVG(value),2) AS avg_price,
		category_code,
		YEAR(date_from) AS year
	FROM czechia_price
	GROUP BY category_code, YEAR(date_from)
	)
	SELECT
	
	SELECT
		ROUND(AVG(cp.value),2) AS avg_price,
		cpc.name,
		YEAR(cp.date_from) AS year
	FROM czechia_price cp
	INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	GROUP BY cp.category_code, YEAR(cp.date_from);