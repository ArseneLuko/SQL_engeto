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
**Ano, mzdy rostou ve všech odvěcích**, ale ne v každém sledovaném roce. V některých letech mzdy klesají, ale ve většině sledovaných let – 89,91 % mzdy stoupají. Ve skriptu jsou také SQL sady pro zobrazení počtu let, kdy mzda klesá (ř. 28) a odvětví, které zaznamenalo nejčastěji pokles (ř. 36).

## Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* V roce **2006** je možné si za průměrnou mzdu ze všech odvětví koupit **1 287 kg chleba** a **1 437 litrů mléka**.
* V roce **2018** je možné si za průměrnou mzdu ze všech odvětví koupit **1 342 kg chleba** a **1 641 litrů mléka**.

## Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Nejpomaleji zdražuje kategorie **Cukr krystalový**, její průměrné meziroční zdražení je: -1,92 % (tedy zlevňuje).<br>
Pokud bereme v úvahu pouze kategorie, které opravdu zdražují, tak nejpomaleji zdražují Banány žluté: 0,81 %

## Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
V žádném roce není nárůst cen potravin výrazně vyšší (o více jak 10 % bodů) než nárůst průměrných mezd.

## Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
Roky kdy výrazněji vzrostlo HDP (pozn. ty jsou počítány tak, kdy byla hodnota růstu HDP 2x větší než průměrný růst HDP za všechny roky): 2007, 2015 a 2017<br>

* Roky kdy rostlo HDP výrazněji
    * V těchto letech rostly také ceny potravin - růst byl větší než průměr růstu cen potravin za celé sledované období
    * Mzdy rostly jen ve dvou případech v letech 2007 a 2017, v roce 2015 byl růst mezd pod průměrem růstu mezd za celé sledované bdobí
* Roky následující po výrazném růstu HDP 2008, 2016 a 2017
	* Růst ceny potraviny byl větší než průměrný růst pouze v jednom případě (2008)
	* Růst mezd byl nadprůměrný v letech 2008 a 2018, v roce 2016 byl růst mezd podprůměrný 
		* Zde můžeme vidět podobný vzorec: když rostlo HDP výrazně a přírůstek mzdy byl nadprůměrný (2007 a 2017), byly přírůstky nadprůměrné i v následujících letech (2008 resp. 2018)
		* Naopak, když rostlo HDP výrazně a přírůstek mzdy byl podprůměrný (2015), byl přírůstek také podprůměrný (2016)<br>

Růst cen potravin takový vzorec nevykazují na první pohled 
* V roce 2015 byl růst cen potravin nadprůměrný (3,27 %) ale nižší oproti růstu cen potravin v letech 2007 a 2017
* V roce 2018 byl růst také podprůměrný, ale opět byl prostřední rok (2016) nejnižší z oněch tří let následujících<br>

**Nelze tedy jednoznačně říct, jeslti měl růst hdp přímý vliv na růst ceny potravin a mezd.** Protože ne vždy, když rostlo HDP výrazněji rostly výrazněji oboje další kategorie v témže a následujícím roce.