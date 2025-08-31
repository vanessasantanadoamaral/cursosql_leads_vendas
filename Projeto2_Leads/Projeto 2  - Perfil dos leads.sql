-- Dashboard 2:

-- (Query 1) Gênero dos leads
-- Colunas: gênero, leads(#)

SELECT
	CASE
	WHEN ibge.gender = 'male' THEN 'homens'
	WHEN ibge.gender = 'female' THEN 'mulheres'
		END AS "gênero",
	COUNT (*) AS "leads (#)"

FROM sales.customers AS cus
LEFT JOIN temp_tables.ibge_genders AS ibge
	ON LOWER (cus.first_name) = LOWER(ibge.first_name)
GROUP BY ibge.gender


-- (Query 2) Status profissional dos leads
-- Colunas: status profissional, leads (%)
SELECT
	CASE
		WHEN professional_status = 'freelancer' THEN 'freelancer'
		WHEN professional_status = 'retired' THEN 'aposentado'
		WHEN professional_status = 'clt' THEN 'clt'
		WHEN professional_status = 'self_employed' THEN'autônomo'		
		WHEN professional_status = 'other' THEN 'outro'
		WHEN professional_status = 'businessman' THEN 'empresário'
		WHEN professional_status = 'civil_servant' THEN 'funcionário público'
		WHEN professional_status = 'student' THEN 'estudante'
		END AS "status profissional",
	(COUNT(*)::float)/(SELECT COUNT(*) FROM sales.customers) AS "leads (%)"

FROM sales.customers
GROUP BY professional_status
ORDER BY "leads (%)"


-- (Query 3) Faixa etária dos leads
-- Colunas: faixa etária, leads (%)

SELECT	
	CASE
		WHEN datediff('years', birth_date, CURRENT_DATE) < 20 THEN '0-20'
		WHEN datediff('years', birth_date, CURRENT_DATE) < 40 THEN '20-40'
		WHEN datediff('years', birth_date, CURRENT_DATE) < 60 THEN '40-60'
		WHEN datediff('years', birth_date, CURRENT_DATE) < 80 THEN '60-80'
		ELSE '80+' END "faixa etária",
		COUNT (*)::float/(SELECT COUNT(*) FROM sales.customers) AS "leads (%)"

FROM sales.customers
GROUP BY "faixa etária"
ORDER BY "faixa etária" DESC


-- (Query 4) Faixa salarial dos leads
-- Colunas: faixa salarial, leads (%), ordem

SELECT
	CASE
		WHEN income < 5000 THEN '0-5000'
		WHEN  income < 10000 THEN '5000-10000'
		WHEN  income < 15000 THEN '10000-15000'
		WHEN  income < 20000 THEN '15000-20000'
		ELSE '20000+' END "faixa salarial",
		count(*)::float/(SELECT COUNT(*) FROM sales.customers) AS "leads (%)",
	CASE
		WHEN  income < 5000 THEN 1
		WHEN  income < 10000 THEN 2
		WHEN  income < 15000 THEN 3
		WHEN  income < 20000 THEN 4
		ELSE 5 END "ordem"

FROM sales.customers
GROUP BY "faixa salarial", "ordem"
ORDER BY "ordem" DESC

-- (Query 5) Classificação dos veículos visitados
-- Colunas: classificação do veículo, veículos visitados (#)
-- Regra de negócio: Veículos novos tem até 2 anos e seminovos acima de 2 anos

WITH classificacao_veiculos AS (
	SELECT
	fun.visit_page_date,
	pro.model_year,
	EXTRACT('year' FROM visit_page_date) - pro.model_year::int AS idade_veiculo,
	CASE
		WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=2 THEN 'novo'
		ELSE 'seminovo'
		END AS "classificação do veículo"
		
	FROM sales.funnel AS fun
		LEFT JOIN sales.products AS pro
			ON fun.product_id = pro.product_id	
	)
	SELECT
	"classificação do veículo",
	COUNT (*) AS "veículos visitados (#)"
	FROM classificacao_veiculos
	GROUP BY "classificação do veículo"

-- (Query 6) Idade dos veículos visitados
-- Colunas: Idade do veículo, veículos visitados (%), ordem

WITH faixa_de_idade_dos_veiculos AS (
		SELECT
			fun.visit_page_date,
			pro.model_year,
			EXTRACT('year' FROM visit_page_date) - pro.model_year::int AS idade_veiculo,
			CASE
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=2 THEN 'até 2 anos'
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=4 THEN 'de 2 à 4 anos'
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=6 THEN 'de 4 à 6 anos'
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=8 THEN 'de 6 à 8 anos'
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=10 THEN 'de 8 à 10 anos'
				ELSE 'acima de 10 anos'
				END AS "idade do veículo",
			CASE
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=2 THEN 1
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=4 THEN 2
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=6 THEN 3
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=8 THEN 4
				WHEN (EXTRACT('year' FROM visit_page_date) - pro.model_year::int)<=10 THEN 5
				ELSE 6
				END AS "ordem"
		FROM sales.funnel AS fun
		LEFT JOIN sales.products AS pro
			ON fun.product_id = pro.product_id
)
SELECT
	"idade do veículo",
	COUNT(*)::float/(SELECT COUNT(*) FROM sales.funnel) AS "veículos visitados (%)",
	ordem
FROM faixa_de_idade_dos_veiculos
GROUP BY "idade do veículo", ordem
ORDER BY ordem


-- (Query 7) Veículos mais visitados por marca
-- Colunas: brand, model, visitas (#)

SELECT
	pro.brand,
	pro.model,
	COUNT (*) AS "visitas (#)"

FROM sales.funnel AS fun
LEFT JOIN sales.products AS pro
	ON fun.product_id = pro.product_id
GROUP BY pro.brand, pro.model
ORDER BY pro.brand, pro.model, "visitas (#)"

