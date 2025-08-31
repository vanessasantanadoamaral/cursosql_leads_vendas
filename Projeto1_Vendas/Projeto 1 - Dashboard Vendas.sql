-- Dashboard 1:

-- (Query 1) Receita, leads, conversão e ticket médio mês a mês
-- Colunas: mês, leads (#), vendas (#), receita (k, R$), conversão (%), ticket médio (k, R$)

WITH leads AS (
	SELECT
		date_trunc('month', visit_page_date)::date AS visit_page_month, 
		COUNT(*) AS visit_page_count
	FROM sales.funnel
	GROUP BY visit_page_month
	ORDER BY visit_page_month
),
	payments AS (
	SELECT
		date_trunc('month', fun. paid_date)::date AS paid_month,
		COUNT (fun.paid_date) AS paid_count,
		SUM(pro.price* (1 + fun.discount)) AS receita
	FROM sales.funnel AS fun
	LEFT JOIN sales.products AS pro
		ON fun.product_id = pro.product_id
	WHERE fun.paid_date IS NOT NULL
	GROUP BY paid_month
)
	SELECT
		l.visit_page_month AS "mês",
		l.visit_page_count AS "leads (#)",
		COALESCE(p.paid_count, 0) AS "vendas (#)",
		(COALESCE(p.receita, 0)/1000) AS "receita (k, R$)",
		(COALESCE(p.paid_count:: float, 0) / NULLIF(l.visit_page_count::float, 0)) AS "conversão (%)",
		(COALESCE(p.receita, 0) / NULLIF (p.paid_count, 0)/1000) AS "ticket médio (k, R$)"
	FROM leads l
	LEFT JOIN payments p
		ON l.visit_page_month= p.paid_month
	ORDER BY l.visit_page_month

-- (Query 2) Estados que mais venderam
-- Colunas: país, estado, vendas (#)

SELECT
	'Brasil' AS país,
	cus.state AS estado,
	COUNT (fun.paid_date) AS "vendas (#)" 
	FROM sales.funnel AS fun
		LEFT JOIN sales.customers AS cus
			ON fun.customer_id = cus.customer_id
	WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'
	GROUP BY país, estado
	ORDER BY "vendas (#)" DESC
	LIMIT 5

-- (Query 3) Marcas que mais venderam no mês
-- Colunas: marca, vendas (#)


SELECT
	pro.brand AS marca,
	COUNT (fun.paid_date) AS "vendas (#)"
	FROM sales.funnel AS fun
		LEFT JOIN sales.products AS pro
			ON fun.product_id = pro.product_id
	WHERE paid_Date BETWEEN '2021-08-01' AND '2021-08-31'
	GROUP BY marca
	ORDER BY "vendas (#)" DESC
	LIMIT 5

-- (Query 4) Lojas que mais venderam
-- Colunas: loja, vendas (#)


SELECT
	sto.store_name AS loja,
	COUNT (fun.paid_date) AS "vendas (#)"
	FROM sales.funnel AS fun
		LEFT JOIN sales.stores AS sto
			ON fun.store_id = sto.store_id
	WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31' GROUP BY Loja
	ORDER BY "vendas (#)" DESC
	LIMIT 5

-- (Query 5) Dias da semana com maior número de visitas ao site
-- Colunas: dia_semana, dia da semana, visitas (#)

SELECT
	EXTRACT('dow' FROM visit_page_date) as dia_semana,
	CASE
	WHEN EXTRACT('dow' FROM visit_page_date) = 0 THEN 'domingo'
	WHEN EXTRACT('dow' FROM visit_page_date) = 1 THEN 'segunda'
	WHEN EXTRACT('dow' FROM visit_page_date) = 2 THEN 'terça'
	WHEN EXTRACT('dow' FROM visit_page_date) = 3 THEN 'quarta'
	WHEN EXTRACT('dow' FROM visit_page_date) = 4 THEN 'quinta'
	WHEN EXTRACT('dow' FROM visit_page_date) = 5 THEN 'sexta'
	WHEN EXTRACT('dow' FROM visit_page_date) = 6 THEN 'sábado'
	ELSE NULL end AS "dia da semana",
	COUNT (*) AS "visitas (#)"

FROM sales.funnel
WHERE visit_page_date BETWEEN '2021-08-01' and '2021-08-31'
GROUP BY dia_semana
ORDER BY dia_semana