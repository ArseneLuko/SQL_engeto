-- 
WITH avg_prices_for_years AS (
	SELECT 
		tf.price_avg,
		tf.price_name,
		tf.price_year
	FROM t_Lukas_Karasek_project_SQL_primary_final tf
	GROUP BY tf.price_name, tf.price_year
	ORDER BY tf.price_name, tf.price_year;
)
SELECT 
	*,
	CASE
		LAG OVER ()
	END
	


SELECT *
FROM t_Lukas_Karasek_project_SQL_primary_final tf;


