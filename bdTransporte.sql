create database Transporte;
go
use Transporte;
go
create table Linha
(
	Codigo smallint identity(1,1) not null,
	Nome varchar(50) not null,
	id_QuadroH smallint null
	constraint pk_linha primary key (Codigo)
);
go
create table Uteis
(
	Codigo smallint not null identity (1,1),
	Horario time not null,
	constraint pk_uteis primary key (Codigo),
	constraint unique_u unique(Horario)
);
go
create table Feriado
(
	Codigo smallint not null identity (1,1),
	Horario time not null,
	constraint pk_feriado primary key (Codigo),
	constraint unique_f unique(Horario)
);
go
create table Sabado
(
	Codigo smallint not null identity (1,1),
	Horario time not null,
	constraint pk_sabado primary key (Codigo),
	constraint unique_s unique(Horario)
);
go
create table Domingo
(
	Codigo smallint not null identity (1,1),
	Horario time not null,
	constraint pk_domingo primary key (Codigo),
	constraint unique_d unique(Horario)
);
go
create table Quadro_horario
(
	Codigo smallint not null,
	id_U smallint,
	id_F smallint,
	id_S smallint,
	id_D smallint,
	constraint pk_qh primary key (Codigo,id_U,id_F,id_S,id_D),
	constraint fk_qh_uteis foreign key (id_U) references Uteis(Codigo),
	constraint fk_qh_feriado foreign key (id_F) references Feriado(Codigo),
	constraint fk_qh_sabado foreign key (id_S) references Sabado(Codigo),
	constraint fk_qh_domingo foreign key (id_D) references Domingo(Codigo)
);
go
create table Logradouro
(
	Codigo smallint identity(1,1) not null,
	nome varchar(50) not null,
	constraint pk_logradouro primary key (Codigo)
);
go
create table Itinerario
(
	id_Linha smallint not null,
	id_Logradouro smallint not null,
	constraint pk_itinerario primary key (id_Linha,id_Logradouro),
	constraint fk_itinerario_linha foreign key (id_Linha) references Linha(Codigo),
	constraint fk_itinerario_logradouro foreign key (id_Logradouro) references Logradouro(Codigo),
);
go
create table Endereco
(
	Codigo smallint identity(1,1) not null,
	Logradouro varchar(60) not null,
	Localidade varchar(60) not null,
	Bairro varchar(50) not null,
	Complemento varchar(50),
	UF char(2) not null,
	Numero varchar(4) not null,
	CEP varchar(8) not null,
	
	constraint pk_endereco primary key (Codigo),
);
go
create table Empresa
(
	CNPJ varchar(14) not null,
	Nome varchar(50) not null,
	Endereco_Web varchar (100) not null,
	id_Endereco smallint not null,
	
	constraint pk_empresa primary key (CNPJ),
	constraint fk_empresa_endereco foreign key (id_Endereco) references Endereco(Codigo)
);
go
create table Telefone
(
	CNPJ varchar(14) not null,
	Numero varchar(14) not null,
	Tipo varchar (20) not null,
	constraint pk_telefone primary key (CNPJ, Numero),
	constraint fk_telefone_empresa foreign key (CNPJ) references Empresa(CNPJ)
);
go
create table Empresa_Linha
(
	CNPJ varchar(14) not null,
	id_Linha smallint not null,
	constraint pk_empresa_linha primary key (CNPJ, id_Linha),
	constraint fk_empresa_empresa_linha foreign key (CNPJ) references Empresa(CNPJ),
	constraint fk_linha_empresa_linha foreign key (id_Linha) references Linha(Codigo)
);
go
insert into Uteis values ('5:00');
insert into Uteis values ('6:00');
insert into Feriado values ('5:20');
insert into Feriado values ('6:20');
insert into Sabado values ('5:30');
insert into Sabado values ('6:30');
insert into Domingo values ('5:40');
insert into Domingo values ('6:40');
insert into Quadro_horario values(1,1,1,1,1);
insert into Quadro_horario values(1,2,2,2,2);
insert into Linha (Nome,id_QuadroH) values ('Br-->Ar',1);
insert into Linha (Nome,id_QuadroH) values ('Pr-->Ur',1);
insert into Logradouro (Nome) values ('Av. Brasil');
insert into Logradouro (Nome) values ('Av. Uruguai');
insert into Logradouro (Nome) values ('Av. Paraguai');
insert into Logradouro (Nome) values ('Av. Argentina');
insert into Logradouro (Nome) values ('Av. Coringa');
insert into Itinerario (id_Linha, id_Logradouro) values (1,1);
insert into Itinerario (id_Linha, id_Logradouro) values (1,4);
insert into Itinerario (id_Linha, id_Logradouro) values (2,3);
insert into Itinerario (id_Linha, id_Logradouro) values (2,2);
insert into Itinerario (id_Linha, id_Logradouro) values (2,5);
insert into Endereco(Logradouro, Localidade, Bairro, UF, Numero, CEP)
values ('Avenida Otto Ernani Muller', 'Araraquara', 'Jardim Tamoio', 'SP', '10', '14800630');
insert into Empresa (CNPJ, Nome, Endereco_Web, id_Endereco) values('51663680000164', 'viação paraty araraquara', 'vparaty.com.br', 1);
insert into Telefone (CNPJ, Numero, Tipo) values ('51663680000164', '1633347800', 'Comercial');
insert into Empresa_Linha (CNPJ, id_Linha) values ('51663680000164', 1);
insert into Empresa_Linha (CNPJ, id_Linha) values ('51663680000164', 2);
--------------------- Consultas ---------------------
--a
select e.Nome as Empresa, e.CNPJ, l.Nome as Linha
from Empresa_Linha el join Linha l
on l.Codigo = el.id_Linha,
Empresa e 
where e.Nome = 'viação paraty araraquara';
-----------------------------------------------------
--b
select l.Nome as Nome_Linha, lg.nome as Itinerario
from Linha l left join Itinerario i on l.Codigo = i.id_Linha,
Logradouro lg
where l.Nome = 'Br-->Ar' and lg.Codigo = i.id_Logradouro;
-----------------------------------------------------
--c
select l.Nome, u.Horario as Uteis, f.Horario as Feriado, s.Horario as Sáb, d.Horario as Dom 
from Linha l join Quadro_horario q on l.id_QuadroH = q.Codigo,
Uteis u, Feriado f, Sabado s, Domingo d
where l.Nome = 'Br-->Ar' and u.Codigo = q.id_U and f.Codigo = q.id_F and s.Codigo = q.id_S and d.Codigo = q.id_D;
-----------------------------------------------------
--d
select l.Nome as Linha, lg.Nome as Logradouro
from Logradouro lg join Itinerario i on i.id_Logradouro = lg.Codigo,
Linha l
where lg.Nome = 'Av. Coringa' and i.id_Linha = l.Codigo;
-----------------------------------------------------

