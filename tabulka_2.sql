-- Tabulky pojmenujte  t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).
-- t_Lukas_Karasek_project_SQL_secondary_final

-- uloží tabulku pro všechny evropské státy s daty z tabulky economies, 
-- z tabulky countries napojené na economies se použije filtr pro Evropské státy
-- další podmínka: stejném rozmezí let jako je v první tabulce vytvořené pro tento projekt

CREATE OR REPLACE TABLE t_Lukas_Karasek_project_SQL_secondary_final
	SELECT 
		e.*
	FROM economies e
	INNER JOIN countries c ON e.country = c.country
	WHERE 1 
		AND c.continent = 'Europe'
		AND e.year BETWEEN 
			(SELECT MIN(payroll_year) FROM t_Lukas_Karasek_project_SQL_primary_final) 
			AND (SELECT MAX(payroll_year) FROM t_Lukas_Karasek_project_SQL_primary_final);

SELECT *
FROM t_Lukas_Karasek_project_SQL_secondary_final
WHERE country LIKE 'Cz%';