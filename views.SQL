/* 1-Melhores cidades para investimentos imobiliários */
CREATE OR ALTER VIEW FN.view_melhores_cidades AS
SELECT 
    c.cidade_nome,
    r.regiao_nome,
    ri.ind_VAC,
    ri.volatilidade,
    AVG(vi.valor_imovel) AS valor_medio_imovel,
    COUNT(i.id_imovel) AS total_imoveis
FROM GE.cidade c
JOIN GE.regiao r ON c.id_regiao = r.id_regiao
LEFT JOIN FN.risco_investimento ri ON c.id_cidade = ri.id_cidade
LEFT JOIN IM.imovel i ON i.id_cidade = c.id_cidade
LEFT JOIN FN.valor_imovel vi ON vi.id_imovel = i.id_imovel
GROUP BY c.cidade_nome, r.regiao_nome, ri.ind_VAC, ri.volatilidade;


/* 2️-Variação dos valores imobiliários ao longo dos anos */
CREATE OR ALTER VIEW FN.view_valor_imovel_ano AS
SELECT 
    c.cidade_nome,
    i.id_imovel,
    vi.ano_valor,
    AVG(vi.valor_imovel) AS valor_medio
FROM IM.imovel i
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
JOIN FN.valor_imovel vi ON i.id_imovel = vi.id_imovel
GROUP BY c.cidade_nome, i.id_imovel, vi.ano_valor;



/* 3️-Investimento necessário para adquirir e manter um imóvel */
CREATE OR ALTER VIEW FN.view_custo_investimento AS
SELECT 
    c.cidade_nome,
    i.id_imovel,
    inv.valor_compra,
    COALESCE(SUM(cm.valor_MAN),0) AS custo_manutencao_total,
    (inv.valor_compra + COALESCE(SUM(cm.valor_MAN),0)) AS investimento_total
FROM IM.imovel i
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
JOIN FN.investimento inv ON i.id_imovel = inv.id_imovel
LEFT JOIN FN.custo_manutencao cm ON i.id_imovel = cm.id_imovel
GROUP BY c.cidade_nome, i.id_imovel, inv.valor_compra;


/* 4️-Margem de lucro na compra de imóveis */
CREATE OR ALTER VIEW FN.view_margem_lucro AS
SELECT 
    c.cidade_nome,
    i.id_imovel,
    inv.ano_compra,
    inv.valor_compra,
    inv.ano_venda,
    inv.valor_venda,
    CASE 
        WHEN inv.valor_venda IS NOT NULL THEN inv.valor_venda - inv.valor_compra
        ELSE NULL
    END AS lucro_bruto,
    CASE 
        WHEN inv.valor_venda IS NOT NULL THEN 
            (inv.valor_venda - inv.valor_compra) / inv.valor_compra * 100
        ELSE NULL
    END AS margem_percentual
FROM IM.imovel i
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
JOIN FN.investimento inv ON i.id_imovel = inv.id_imovel;


/* 5️-Melhor época do ano para adquirir imóveis */
CREATE OR ALTER VIEW FN.view_melhor_epoca AS
SELECT 
    c.cidade_nome,
    MONTH(t.mes_ano) AS mes,
    AVG(t.tend_VLR) AS valor_medio,
    AVG(t.temp_venda) AS tempo_medio_venda
FROM FN.tendencia_mercado t
JOIN GE.cidade c ON t.id_cidade = c.id_cidade
GROUP BY c.cidade_nome, MONTH(t.mes_ano);


/* 6️-Custo dos aluguéis nas principais cidades */
CREATE OR ALTER VIEW FN.view_aluguel_cidade AS
SELECT 
    c.cidade_nome,
    i.id_imovel,
    alu.ano_ALU,
    AVG(alu.valor_ALU) AS aluguel_medio
FROM FN.aluguel alu
JOIN IM.imovel i ON alu.id_imovel = i.id_imovel
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
GROUP BY c.cidade_nome, i.id_imovel, alu.ano_ALU;


/* 7️-Tempo médio de retorno do investimento */
CREATE OR ALTER VIEW FN.view_tempo_retorno AS
SELECT 
    c.cidade_nome,
    i.id_imovel,
    AVG(r.tempo_INV) AS tempo_medio_retorno
FROM FN.retorno r
JOIN FN.investimento inv ON r.id_invest = inv.id_invest
JOIN IM.imovel i ON inv.id_imovel = i.id_imovel
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
GROUP BY c.cidade_nome, i.id_imovel;


/* 8️-Média de juros de financiamento de imóveis */
CREATE OR ALTER VIEW FN.view_juros_financiamento AS
SELECT 
    c.cidade_nome,
    AVG(f.juros_FIN) AS juros_medio
FROM FN.financiamento f
JOIN IM.imovel i ON f.id_imovel = i.id_imovel
JOIN GE.cidade c ON i.id_cidade = c.id_cidade
GROUP BY c.cidade_nome;


/* 9️-Impacto de indicadores econômicos na valorização dos imóveis */
CREATE OR ALTER VIEW FN.view_valorizacao_economia AS
SELECT 
    c.cidade_nome,
    ie.ano_IND,
    ie.pib_per_capita,
    ie.inflacao,
    AVG(vi.valor_imovel) AS valor_medio
FROM GE.indicadores_economicos ie
JOIN GE.cidade c ON ie.id_cidade = c.id_cidade
JOIN IM.imovel i ON i.id_cidade = c.id_cidade
JOIN FN.valor_imovel vi ON vi.id_imovel = i.id_imovel AND vi.ano_valor = ie.ano_IND
GROUP BY c.cidade_nome, ie.ano_IND, ie.pib_per_capita, ie.inflacao;


/* 10-Correlação entre infraestrutura urbana e preços de imóveis */
CREATE OR ALTER VIEW FN.view_infra_impacto AS
SELECT 
    c.cidade_nome,
    iu.ano,
    iu.indice_QDV,
    AVG(vi.valor_imovel) AS valor_medio
FROM GE.infraestrutura_urbana iu
JOIN GE.cidade c ON iu.id_cidade = c.id_cidade
JOIN IM.imovel i ON i.id_cidade = c.id_cidade
JOIN FN.valor_imovel vi ON vi.id_imovel = i.id_imovel AND vi.ano_valor = iu.ano
GROUP BY c.cidade_nome, iu.ano, iu.indice_QDV;


/* 11-Demografia e demanda por imóveis */
CREATE OR ALTER VIEW FN.view_demografia_demanda AS
SELECT 
    c.cidade_nome,
    d.ano,
    d.faixa_ETA,
    d.renda,
    COUNT(i.id_imovel) AS total_imoveis,
    AVG(alu.valor_ALU) AS aluguel_medio
FROM GE.demografia d
JOIN GE.cidade c ON d.id_cidade = c.id_cidade
LEFT JOIN IM.imovel i ON i.id_cidade = c.id_cidade
LEFT JOIN FN.aluguel alu ON alu.id_imovel = i.id_imovel AND alu.ano_ALU = d.ano
GROUP BY c.cidade_nome, d.ano, d.faixa_ETA, d.renda;
