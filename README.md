# SQL projekt pro Engeto kurz
Sada SQL dotazů pro zodpovězení otázek, projekt pro Engeto kurz: Datový analytik s Pythonm
Projekt: Data o mzdách a cenách potravin a jejich zpracování pomocí SQL

### Otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

## Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
**Ano, mzdy rostou ve všech odvěcích**, ale ne v každém sledovaném roce. V některých letech mzdy klesají, ale ve většině sledovaných let – 89,91 % mzdy stoupají. Ve skriptu jsou také SQL sady pro zobrazení počtu let, kdy mzda klesá (ř. 28) a odvětví, které zaznamenalo nejčastěji pokles (ř. 36)

## Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* V roce **2006** je možné si za průměrnou mzdu ze všech odvětví koupit **1 287 kg chleba** a **1 437 litrů mléka**.
* V roce **2018** je možné si za průměrnou mzdu ze všech odvětví koupit **1 342 kg chleba** a **1 641 litrů mléka**.

## Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Nejpomaleji zdražuje kategorie **Cukr krystalový**, její průměrné meziroční zdražení je: -1,92 % (tedy zlevňuje).<br>
Pokud bereme v úvahu pouze kategorie, které opravdu zdražují, tak nejpomaleji zdražují Banány žluté: 0,81 %