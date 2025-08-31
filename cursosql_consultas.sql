SELECT *
FROM sales.customers

SELECT email, first_name, last_name
FROM sales.customers

SELECT brand
FROM sales.products

-- Comando DISTINCT
SELECT DISTINCT brand
FROM sales.products

SELECT DISTINCT brand, model_year
FROM sales.products

-- Comando WHERE
SELECT email, state
FROM sales.customers
WHERE state = 'SC'

SELECT email, state
FROM sales.customers
WHERE state = 'SC' or state = 'MS'

SELECT email, state, birth_date
FROM sales.customers
WHERE (state = 'SC' or state = 'MS') and birth_date < '1991-12-28'

-- Comando ORDER BY
SELECT *
FROM sales.products
ORDER BY price

SELECT *
FROM sales.products
ORDER BY price DESC

SELECT DISTINCT state
FROM sales.customers
ORDER BY state

-- Comando LIMIT
SELECT *
FROM sales.funnel
LIMIT 10

SELECT *
FROM sales.products
ORDER BY price DESC
LIMIT 10

-- Desafio
SELECT *
FROM sales.customers

SELECT DISTINCT city
FROM sales.customers
WHERE state = 'MG'
ORDER BY city

SELECT *
FROM sales.funnel

SELECT visit_id
FROM sales.funnel
ORDER BY paid_date DESC

-- (Exercício 3) Selecione todos os dados dos 10 clientes com maior score nascidos
-- após 01/01/2000 (dados da tabela sales.customers)
SELECT *
FROM sales.customers

SELECT *
FROM sales.customers
WHERE birth_date > '2000-01-02'
ORDER BY score
LIMIT 10

-- Operadores aritméticos
SELECT * 
FROM sales.customers
LIMIT 10

SELECT 
email,
birth_date,
(current_date - birth_date) / 365 as idade
FROM sales.customers
ORDER BY idade
LIMIT 10

SELECT 
email,
birth_date,
(current_date - birth_date) / 365 as "idade do cliente"
FROM sales.customers

SELECT 
first_name || ' ' || last_name as nome
FROM sales.customers
ORDER BY nome

-- Operadores de comparação
SELECT 
customer_id, 
first_name,
professional_status,
professional_status = 'clt' as "cliente clt"
FROM sales.customers

-- Operadores lógicos
SELECT *
FROM sales.products
WHERE price >= 100000 and price <= 200000

SELECT *
FROM sales.products
WHERE price between 100000 and 200000

SELECT *
FROM sales.products
WHERE price < 100000 or price > 200000

SELECT *
FROM sales.products
WHERE price not between 100000 and 200000

SELECT *
FROM sales.products
WHERE brand = 'HONDA' or brand = 'TOYOTA' or brand = 'RENAULT'

SELECT *
FROM sales.products
WHERE brand IN ('HONDA','TOYOTA','RENAULT')

SELECT *
FROM sales.products
WHERE brand NOT IN ('HONDA','TOYOTA','RENAULT')

SELECT DISTINCT first_name
FROM sales.customers
WHERE first_name LIKE '%ANA'

SELECT DISTINCT first_name
FROM sales.customers
WHERE first_name ILIKE '%ANA'

SELECT * 
FROM temp_tables.regions
WHERE population IS NULL

-- Desafio

-- (Exercício 1) Calcule quantos salários mínimos ganha cada cliente da tabela 
-- sales.customers. Selecione as colunas de: email, income e a coluna calculada "salários mínimos"
-- Considere o salário mínimo igual à R$1200

SELECT
email,
income,
(income / 1200) as "salarios minimos"
FROM sales.customers

-- (Exercício 2) Na query anterior acrescente uma coluna informando TRUE se o cliente
-- ganha acima de 5 salários mínimos e FALSE se ganha 4 salários ou menos.
-- Chame a nova coluna de "acima de 4 salários"

SELECT
	email,
	income,
	(income) / 1200 as "salários mínimos",
	((income) / 1200) > 4 as "acima de 4 salários"
FROM sales.customers

-- (Exercício 3) Na query anterior filtre apenas os clientes que ganham entre
-- 4 e 5 salários mínimos. Utilize o comando BETWEEN

SELECT
	email,
	income,
	(income) / 1200 as "salários mínimos",
	((income) / 1200) > 4 as "acima de 4 salários"
FROM sales.customers
WHERE (income) / 1200 BETWEEN 4 and 5

-- (Exercício 4) Selecine o email, cidade e estado dos clientes que moram no estado de 
-- Minas Gerais e Mato Grosso. 

SELECT
email,
city,
state
FROM sales.customers
WHERE state IN ('MG', 'MT')


-- (Exercício 5) Selecine o email, cidade e estado dos clientes que não 
-- moram no estado de São Paulo.

SELECT
email,
city,
state
FROM sales.customers
WHERE state = 'SP'

-- (Exercício 6) Selecine os nomes das cidade que começam com a letra Z.
-- Dados da tabela temp_table.regions

SELECT 
city
FROM temp_tables.regions
WHERE city LIKE 'Z%'

-- Funções de agregação
SELECT
state,
COUNT (*) as contagem
FROM sales.customers
GROUP BY state
ORDER BY contagem DESC

SELECT
state,
professional_status,
COUNT (*) as contagem
FROM sales.customers
GROUP BY 
state,
professional_status
ORDER BY 
state, contagem DESC

SELECT DISTINCT 
state
FROM sales.customers

SELECT state
FROM sales.customers
GROUP BY state

SELECT 
state,
count (*)
FROM sales.customers
GROUP BY state
HAVING count (*) > 100

-- Desafios

-- EXERCÍCIOS ########################################################################

-- (Exercício 1) Conte quantos clientes da tabela sales.customers tem menos de 30 anos

SELECT COUNT (*)
FROM sales.customers
WHERE ((current_date - birth_date) / 365) < 30

-- (Exercício 2) Informe a idade do cliente mais velho e mais novo da tabela sales.customers

SELECT 
	MAX((current_date - birth_date) / 365 ),
	MIN((current_date - birth_date) / 365 )
from sales.customers

-- (Exercício 3) Selecione todas as informações do cliente mais rico da tabela sales.customers
-- (possívelmente a resposta contém mais de um cliente)

SELECT *
FROM sales.customers
WHERE income = (SELECT MAX (income) FROM sales.customers)


-- (Exercício 4) Conte quantos veículos de cada marca tem registrado na tabela sales.products
-- Ordene o resultado pelo nome da marca

SELECT 
brand,
COUNT (*) 
FROM sales.products
GROUP BY brand
ORDER BY brand


-- (Exercício 5) Conte quantos veículos existem registrados na tabela sales.products
-- por marca e ano do modelo. Ordene pela nome da marca e pelo ano do veículo

SELECT 
brand,
model_year,
COUNT (*) 
FROM sales.products
GROUP BY brand, model_year
ORDER BY brand, model_year

SELECT *
FROM sales.products
LIMIT 10

-- (Exercício 6) Conte quantos veículos de cada marca tem registrado na tabela sales.products
-- e mostre apenas as marcas que contém mais de 10 veículos registrados

SELECT *
FROM sales.products
LIMIT 10

SELECT 
brand,
COUNT (*) 
FROM sales.products
GROUP BY brand
HAVING COUNT (*) > 10

-- Joins
SELECT *
FROM temp_tables.tabela_1

SELECT *
FROM temp_tables.tabela_2

-- LEFT JOIN: Puxa os dados da tabela 1 (esquerda), e preenche apenas o que tem na tabela 2
SELECT
t1.cpf,
t1.name,
t2.state
FROM temp_tables.tabela_1 as t1 
 	left join temp_tables.tabela_2 as t2
  		on t1.cpf = t2.cpf

-- RIGHT JOIN: Puxa os dados da tabela 2 (direita), e preenche apenas o que tem na tabela 1
SELECT
t1.cpf,
t1.name,
t2.state
FROM temp_tables.tabela_1 as t1 
 	right join temp_tables.tabela_2 as t2
  		on t1.cpf = t2.cpf
  

-- INNER JOIN: Puxa todos os dados que existem tanto na tabela 1, quanto na tabela 2
SELECT
t1.cpf,
t1.name,
t2.state
FROM temp_tables.tabela_1 as t1 
 	inner join temp_tables.tabela_2 as t2
  		on t1.cpf = t2.cpf

-- FULL JOIN: Une todos os dados de ambas as tabelas, existindo ou não conteúdos
SELECT
t1.cpf,
t1.name,
t2.state
FROM temp_tables.tabela_1 as t1 
	full join temp_tables.tabela_2 as t2
 		on t1.cpf = t2.cpf

-- Desafios
SELECT
cus.professional_status,
count (fun.paid_date) as pagamentos
FROM sales.funnel as fun
	left join sales.customers as cus
		on fun.customer_id = cus.customer_id
GROUP BY cus.professional_status
ORDER BY pagamentos DESC

SELECT *
FROM temp_tables.ibge_genders
LIMIT 10 

SELECT
ibge.gender,
count (fun.paid_date)
FROM sales.funnel as fun
	left join sales.customers as cus
		on fun.customer_id = cus.customer_id
	left join temp_tables.ibge_genders as ibge
	on LOWER (cus.first_name) = ibge.first_name
GROUP BY ibge.gender

-- Union e Union all
SELECT *
FROM sales.products
UNION ALL
SELECT *
FROM temp_tables.products_2

-- Comando WITH 
WITH primeira_visita AS (
SELECT customer_id,
MIN (visit_page_date) AS visita_1
FROM sales.funnel
GROUP BY customer_id
)
SELECT
fun.visit_page_date,
(fun.visit_page_date) <> primeira_visita.visita_1 AS lead_recorrente,
COUNT(*)
FROM sales.funnel AS fun
	LEFT JOIN primeira_visita 
		ON fun.customer_id = primeira_visita.customer_id
GROUP BY fun.visit_page_date, lead_recorrente
ORDER BY fun.visit_page_date DESC, lead_recorrente


WITH preco_medio AS (
SELECT brand,
AVG (price) as preco_medio_da_marca
FROM sales.products
GROUP BY brand
)
SELECT
fun.visit_id,
fun.visit_page_date,
pro.brand,
(pro.price * (1+fun.discount)) as preco_final,
preco_medio.preco_medio_da_marca,
(pro.price * (1+fun.discount)) - preco_medio.preco_medio_da_marca as preco_vs_media
FROM sales.funnel as fun
	LEFT JOIN sales.products as pro
		ON fun.product_id = pro.product_id
	LEFT JOIN preco_medio
		ON pro.brand = preco_medio.brand

-- Desafio

-- (Exercício 1) Crie uma coluna calculada com o número de visitas realizadas por cada
-- cliente da tabela sales.customers

with numero_de_visitas as (

	select customer_id, count(*) as n_visitas
	from sales.funnel
	group by customer_id

)

select
	cus.*,
	n_visitas

from sales.customers as cus
left join numero_de_visitas as ndv
	on cus.customer_id = ndv.customer_id

-- Conversão CAST
SELECT
'2021-10-01':: date - '2021-02-01':: date

SELECT 
'100':: numeric - '10':: numeric

SELECT REPLACE (112122::text,'1','A')

SELECT CAST ('2021-10-01' AS DATE) - CAST ('2021-02-01' AS DATE)

-- CASE WHEN
WITH faixa_de_renda AS (
	SELECT
	income,
		CASE 
			WHEN income < 5000 THEN '0-5000'
			WHEN income >= 5000 AND income < 10000 THEN '5000-10000'
			WHEN income >=10000 AND income <15000 THEN '10000-15000'
			ELSE '15000+'
			END AS faixa_renda
FROM sales.customers
)

SElECT
faixa_renda, COUNT (*)
FROM faixa_de_renda
GROUP BY faixa_renda
ORDER BY count

-- COALESCE
SELECT *
FROM temp_tables.regions
WHERE population IS NULL


SELECT
	*,
	CASE WHEN population IS NOT NULL THEN population
	ELSE (SELECT AVG (population) FROM temp_tables.regions) 
	END AS populacao_ajustada
FROM temp_tables.regions

SELECT
	*,
	COALESCE(population,(SELECT AVG (population) FROM temp_tables.regions)) AS populacao_ajustada
FROM temp_tables.regions

-- Conversão de texto


select 
UPPER('São Paulo') = 'SÃO PAULO'


select
LOWER('São Paulo') = 'são paulo'


select 
TRIM('SÃO PAULO     ') = 'SÃO PAULO'


select 
REPLACE('SAO PAULO', 'SAO', 'SÃO') = 'SÃO PAULO'
