CREATE TABLE produtos (codproduto integer, descricao text);
INSERT INTO produtos VALUES(100, "CAPITAL DE GIRO");
INSERT INTO produtos VALUES(200, "NCE");
INSERT INTO produtos VALUES(300, "CREDITO PESSOAL");
INSERT INTO produtos VALUES(400, "CONSIGNADO");
INSERT INTO produtos VALUES(500, "COMEX");

CREATE TABLE quantidadeContratos (codproduto integer, segmento text, quantidade integer, mes text);
INSERT INTO quantidadeContratos VALUES (100, "CORPORATE", 100, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (200, "CORPORATE", 200, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (500, "CORPORATE", 150, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (300, "PF", 500, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (100, "EMPRESAS", 50, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (200, "EMPRESAS", 100, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (300, "EMPRESAS", 100, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (300, "EMPRESAS", 10, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (400, "PF", 300, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (500, "EMPRESAS", 200, "SETEMBRO");
INSERT INTO quantidadeContratos VALUES (100, "CORPORATE", 130, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (200, "CORPORATE", 260, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (500, "CORPORATE", 195, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (300, "PF", 650, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (100, "EMPRESAS", 65, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (200, "EMPRESAS", 130, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (300, "EMPRESAS", 13, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (400, "PF", 390, "OUTUBRO");
INSERT INTO quantidadeContratos VALUES (500, "EMPRESAS", 260, "OUTUBRO");

SELECT  descricao
       ,SUM(quantidade) AS total_contratos_setembro
FROM produtos produto
JOIN quantidadeContratos quantidadec
ON produto.codproduto = quantidadec.codproduto
WHERE quantidadec.mes = "SETEMBRO"
GROUP BY  produto.descricao;

SELECT  descricao
       ,((CAST(total_contratos_outubro AS DOUBLE) - CAST(total_contratos_setembro AS DOUBLE)) / CAST(total_contratos_setembro AS DOUBLE)) * 100 AS variacao_em_porcentagem
FROM
(
	SELECT  p.descricao
	       ,SUM(CASE WHEN qc.mes = 'SETEMBRO' THEN qc.quantidade ELSE 0 END) AS total_contratos_setembro
	       ,SUM(CASE WHEN qc.mes = 'OUTUBRO' THEN qc.quantidade ELSE 0 END)  AS total_contratos_outubro
	       ,((SUM(CASE WHEN qc.mes = 'OUTUBRO' THEN qc.quantidade ELSE 0 END) - SUM(CASE WHEN qc.mes = 'SETEMBRO' THEN qc.quantidade ELSE 0 END)) / SUM(CASE WHEN qc.mes = 'SETEMBRO' THEN qc.quantidade ELSE 0 END)) * 100 AS variacao_percentual
	FROM produtos p
	JOIN quantidadeContratos qc
	ON p.codproduto = qc.codproduto
	GROUP BY  p.descricao
);

SELECT  DESCRICAO       AS produto
       ,SEGMENTO
       ,MAX(QUANTIDADE) AS quantidade_maxima
FROM produtos p
JOIN quantidadeContratos qc
ON p.codproduto = qc.codproduto
GROUP BY  SEGMENTO
