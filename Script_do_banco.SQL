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
constraint PK custo_manutencao primary key(id_custoMAN),
constraint FK custo_manutencao foreign key(id_imovel)
   references IM.imovel(id_movel)
);

create table FN.investimento(
id_invest int not null identify(1,1),
id_imovel int not null,
ano_compra int not null,
valor_compra decimal (15,2) not null,
valor_venda decimal(15,2)  null,
ano_venda int null,
constraint PK invest primary key (id_invest),
constraint FK imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)

);

create table FN.retorno(
id_retorno int not null identify(1,1)
id_invest int not null,
tempo_INV decimal (5,2) not null,
constraint PK invest primary key (id_retorno),
constraint FK imovel foreign key (id_invest)
   references IM.imovel (id_imovel)

);


create table FN.aluguel(
id_aluguel int not null identify(1,1),
id_imovel int not null,
ano_ALU int not null, 
valor_ALU decimal (15,2),
constraint PK invest primary key (id_aluguel),
constraint FK imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)

);


create table FN.financiamneto(
id_financia int not null identify(1,1),
id_imovel int not null,
ano_FIN int null,
valor_FIN decimal (15,2),
prazo_meses int not null, 
juros_FIN decimal (5,2),
constraint PK invest primary key (id_financia),
constraint FK imovel foreign key (id_imovel)
   references IM.imovel (id_imovel)

);













