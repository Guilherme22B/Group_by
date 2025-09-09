create schema GE;
create schema FN;
create schema IM;

create table GE.regiao(
id_regiao int not null identity(1,1),
cidade_EST nvarchar(2) not null,
regiao_nome nvarchar(50) not null,
constraint PK_regiao primary key(id_regiao)
);

create table GE.cidade (
id_cidade int not null identity(1,1),
id_regiao int not null,
cidade_EST nvarchar(2) not null,
cidade_nome nvarchar(100) not null,
cidade_POP int null,
cidade_CLA nvarchar(100) null,
constraint PK_cidade primary key(id_cidade),
constraint FK_cidade_regiao foreign key(id_regiao)
  references GE.regiao(id_regiao)
);

create table IM.imovel(
id_imovel int not null identity(1,1),
id_cidade int not null,
tipo_IMV nvarchar(50) not null,
area_IMV decimal(10,2) null,
ano_construcao int null,
constraint PK_imovel primary key(id_imovel),
constraint FK_imovel_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table FN.valor_imovel(
id_valor int not null identity(1,1),
id_imovel int not null,
ano_valor int not null,
valor_imovel decimal(15,2) not null,
mes_valor int not null,
fonte_valor int not null,
constraint PK_valor primary key(id_valor),
constraint FK_imovel_valor foreign key(id_imovel)
  references IM.imovel(id_imovel)
);

create table FN.custo_manutencao(
id_custoMAN int not null identity(1,1),
id_imovel int not null,
ano_MAN int not null,
valor_MAN decimal(15,2) not null,
constraint PK_custo_manutencao primary key(id_custoMAN),
constraint FK_custo_manutencao_imovel foreign key(id_imovel)
   references IM.imovel(id_imovel)
);

create table FN.investimento(
id_invest int not null identity(1,1),
id_imovel int not null,
ano_compra int not null,
valor_compra decimal (15,2) not null,
valor_venda decimal(15,2)  null,
ano_venda int null,
constraint PK_investimento primary key (id_invest),
constraint FK_investimento_imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)
);

create table FN.retorno(
id_retorno int not null identity(1,1),
id_invest int not null,
tempo_INV decimal (5,2) not null,
constraint PK_retorno primary key (id_retorno),
constraint FK_retorno_investimento foreign key (id_invest)
   references FN.investimento (id_invest)
);

create table FN.aluguel(
id_aluguel int not null identity(1,1),
id_imovel int not null,
ano_ALU int not null, 
valor_ALU decimal (15,2),
constraint PK_aluguel primary key (id_aluguel),
constraint FK_aluguel_imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)
);

create table FN.financiamento(
id_financia int not null identity(1,1),
id_imovel int not null,
ano_FIN int null,
valor_FIN decimal (15,2),
prazo_meses int not null, 
juros_FIN decimal (5,2),
constraint PK_financiamento primary key (id_financia),
constraint FK_financiamento_imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)
);

create table FN.taxajuros_historica(
id_taxa int not null identity(1,1),
ano_TAX int not null,
juros_TAX decimal(5,2),
constraint PK_taxa primary key(id_taxa)
);

create table GE.indicadores_economicos(
id_indicador int not null identity(1,1),
id_cidade int not null,
ano_IND int null,
pib_per_capita decimal(15,2) not null,
inflacao decimal(5,2) null,
constraint PK_indicador primary key(id_indicador),
constraint FK_indicadores_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table GE.infraestrutura_urbana(
id_infra int not null identity(1,1),
id_cidade int not null,
ano int null,
indice_QDV decimal(5,2) not null,
constraint PK_infra primary key(id_infra),
constraint FK_infra_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table GE.demografia(
id_demografia int not null identity(1,1),
id_cidade int not null,
ano int null,
faixa_ETA int null,
renda decimal(5,2) not null,
constraint PK_demografia primary key(id_demografia),
constraint FK_demografia_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table IM.oferta_imobiliaria(
id_oferta int not null identity(1,1),
id_cidade int null,
ano_ofertado int null,
unid_cons int null,
unid_lanc int null,
quant_IMV int null,
constraint PK_oferta primary key(id_oferta),
constraint FK_oferta_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table FN.tendencia_mercado(
id_tendencia int not null identity(1,1),
id_cidade int null,
mes_ano date not null,
tend_VLR decimal(5,2) not null,
temp_venda int not null,
constraint PK_tendencia primary key(id_tendencia),
constraint FK_tendencia_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table FN.custos_adicionais(
id_custo_adicional int not null identity(1,1),
id_cidade int not null,
ano_custo int not null,
IPTU_medio decimal(5,2) not null,
seguro_medio decimal(5,2),
constraint PK_custo_adc primary key(id_custo_adicional),
constraint FK_custo_adicionais_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);

create table FN.risco_investimento(
id_risco int not null identity(1,1),
id_cidade int not null,
ano_risco int not null,
ind_VAC decimal(5,2) not null,
volatilidade decimal(5,2) not null,
constraint PK_risco_invest primary key(id_risco),
constraint FK_risco_cidade foreign key(id_cidade)
  references GE.cidade(id_cidade)
);




