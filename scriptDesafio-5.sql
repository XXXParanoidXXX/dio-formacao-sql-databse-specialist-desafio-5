-- *** Indices e queries no bd_company ***

/*
Parte 1 – Criando índices em Banco de Dados 

Criação de índices para consultas para o cenário de company com as perguntas (queries sql) para recuperação de informações. Sendo assim, dentro do script será criado os índices com base na consulta SQL.  

O que será levado em consideração para criação dos índices? 

Quais os dados mais acessados 

Quais os dados mais relevantes no contexto 

Lembre-se da função do índice... ele impacta diretamente na velocidade da buca pelas informações no SGBD. Crie apenas aqueles que são importantes. Sendo assim, adicione um README dentro do repositório do Github explicando os motivos que o levaram a criar tais índices. Para que outras pessoas possam se espelhar em seu trabalho, crie uma breve descrição do projeto. 

 

A criação do índice pode ser criada via ALTER TABLE ou CREATE Statement, como segue o exemplo: 

ALTER TABLE customer ADD UNIQUE index_email(email); 

CREATE INDEX index_ativo_hash ON exemplo(ativo) USING HASH; 

 

Perguntas:  

Qual o departamento com maior número de pessoas? 

Quais são os departamentos por cidade? 

Relação de empregrados por departamento 

 

Entregável: 

Crie as queries para responder essas perguntas 

Crie o índice para cada tabela envolvida (de acordo com a necessidade) 

Tipo de indice utilizado e motivo da escolha (via comentário no script ou readme) 
*/

create database if not exists db_company;

create table if not exists departament(
Dname varchar(20),
Dnumber int,
Mgr_ssn int,
Mgr_start_date date,
primary key(Dnumber)
);

create table if not exists dept_locations(
Dnumber int,
Dlocation varchar(20),
primary key(Dnumber, Dlocation),
foreign key(Dnumber)
	references departament(Dnumber)
);

create table if not exists project(
Pname varchar(20),
Pnumber int,
Plocation varchar(20),
Dnumb int,
primary key(Pnumber),
foreign key(Dnumb)
	references departament(Dnumber)
);

create table if not exists employee (
Fname varchar(20),
Minit varchar(20),
Lname varchar(20),
Ssn int,
Bdate date,
Adress varchar(255),
Sex enum('M', 'F'),
Salary decimal(10,2),
Super_ssn int,
Dno int,
Dnumber int,
primary key(Ssn),
foreign key(Dnumber)
	references departament(Dnumber)
);

create table if not exists works_on(
Essn int,
Pno int,
Hours decimal(4,2),
primary key(Essn, Pno),
foreign key(Essn)
	references employee(Ssn),
foreign key(Pno) 
	references project(Pnumber)
);

create table if not exists dependent(
Essn int,
Dependent_name varchar(60),
Sex enum('M', 'F'),
Bdate date,
Relationship varchar (20),
primary key(Essn, Dependent_name),
foreign key(Essn)
	references employee(Ssn)
);

-- 1) Departamento com maior número de pessoas?
alter table departament add index index_departament_Dname(Dname); -- índice criado por fazer parte da projeção da quey
alter table employee add index index_employee_Dnumber(Dnumber); -- índice criado por ser FK usada no join da query
select d.Dname, count(e.Ssn) as Qtd from departament d 
	inner join employee e on d.Dnumber = e.Dnumber group by d.Dname order by count(e.Ssn) desc;

-- 2) Quais são os departamentos por cidade?
-- Sem criação de novas indexações, pois os atributos que participam da query já foram indexados manualmente ou são PKs.
select dl.Dlocation as Depart_Location, d.Dname as Departament_Name from departament d 
	inner join dept_locations dl on d.Dnumber = dl.Dnumber order by dl.Dlocation;

-- 3) Relação de empregados por departamento?
-- d.Dname já foi indexado manualmente
alter table employee add index index_employee_name(Fname, Lname);
select d.Dname, concat(e.Fname, ' ', e.Lname) from departament d
	inner join employee e on d.Dnumber = e.Dnumber order by d.Dname;

-- *** Procedures no bd_universidade e bd_ecommerce ***
/*
Parte 2 - Utilização de procedures para manipulação de dados em Banco de Dados 

Objetivo:  

Criar uma procedure que possua as instruções de inserção, remoção e atualização de dados no banco de dados. As instruções devem estar dentro de estruturas condicionais (como CASE ou IF).  

Além das variáveis de recebimento das informações, a procedure deverá possuir uma variável de controle. Essa variável de controle irá determinar a ação a ser executada. Ex: opção 1 – select, 2 – update, 3 – delete. 

 

Sendo assim, altere a procedure abaixo para receber as informações supracitadas. 

 

Entregável: 

Script SQL com a procedure criada e chamada para manipular os dados de universidade e e-commerce. Podem ser criados dois arquivos distintos, assim como a utilização do mesmo script para criação das procedures. Fique atento para selecionar o banco de dados antes da criação da procedure. 
*/

show databases;

use db_ecommerce;

USE db_ecommerce;

DELIMITER $$

CREATE PROCEDURE sp_cliente_crud (
    IN p_acao INT,
    IN p_idCliente INT,
    IN p_Rua VARCHAR(45),
    IN p_Numero VARCHAR(10),
    IN p_Complemento VARCHAR(45),
    IN p_Bairro VARCHAR(45),
    IN p_CEP CHAR(8),
    IN p_UF CHAR(2),
    IN p_Pais VARCHAR(45)
)
BEGIN
    IF p_acao = 1 THEN
        -- SELECT
        SELECT * 
        FROM Cliente
        WHERE idCliente = p_idCliente;

    ELSEIF p_acao = 2 THEN
        -- INSERT
        INSERT INTO Cliente
        (Rua, Numero, Complemento, Bairro, CEP, UF, Pais)
        VALUES
        (p_Rua, p_Numero, p_Complemento, p_Bairro, p_CEP, p_UF, p_Pais);

    ELSEIF p_acao = 3 THEN
        -- UPDATE
        UPDATE Cliente
        SET
            Rua = p_Rua,
            Numero = p_Numero,
            Complemento = p_Complemento,
            Bairro = p_Bairro,
            CEP = p_CEP,
            UF = p_UF,
            Pais = p_Pais
        WHERE idCliente = p_idCliente;

    ELSEIF p_acao = 4 THEN
        -- DELETE
        DELETE FROM Cliente
        WHERE idCliente = p_idCliente;
    END IF;
END$$

DELIMITER ;

-- Exemplos de chamadas:
-- INSERT
CALL sp_cliente_crud(
    2, NULL,
    'Rua A', '123', 'Apto 10',
    'Centro', '01001000', 'SP', 'Brasil'
);

-- SELECT
CALL sp_cliente_crud(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- UPDATE
CALL sp_cliente_crud(
    3, 1,
    'Rua B', '456', 'Casa',
    'Jardins', '02002000', 'SP', 'Brasil'
);

-- DELETE
CALL sp_cliente_crud(4, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);










