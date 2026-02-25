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

#DML

INSERT INTO departament (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Research', 1, 123456789, '2018-01-01'),
('Administration', 2, 987654321, '2019-03-15'),
('IT', 3, 456789123, '2020-06-01'),
('HR', 4, 321654987, '2017-09-10'),
('Finance', 5, 741852963, '2021-02-20');

INSERT INTO dept_locations (Dnumber, Dlocation) VALUES
(1, 'New York'),
(1, 'Boston'),
(2, 'Chicago'),
(3, 'San Francisco'),
(3, 'Seattle'),
(4, 'Miami'),
(5, 'Dallas');

INSERT INTO project (Pname, Pnumber, Plocation, Dnumb) VALUES
('AI Research', 10, 'New York', 1),
('Payroll System', 20, 'Chicago', 2),
('Cloud Migration', 30, 'San Francisco', 3),
('Recruitment Portal', 40, 'Miami', 4),
('Budget Analysis', 50, 'Dallas', 5);

INSERT INTO employee 
(Fname, Minit, Lname, Ssn, Bdate, Adress, Sex, Salary, Super_ssn, Dno, Dnumber) VALUES
('John', 'A', 'Smith', 123456789, '1980-05-10', 'NY Street 1', 'M', 8000.00, NULL, 1, 1),
('Anna', 'B', 'Johnson', 987654321, '1985-08-20', 'Chicago Ave 5', 'F', 7500.00, 123456789, 2, 2),
('Mark', 'C', 'Brown', 456789123, '1990-11-02', 'SF Road 12', 'M', 9000.00, 123456789, 3, 3),
('Julia', 'D', 'Taylor', 321654987, '1988-03-15', 'Miami Blvd 9', 'F', 7000.00, 987654321, 4, 4),
('Robert', 'E', 'Wilson', 741852963, '1979-07-30', 'Dallas St 22', 'M', 9500.00, 987654321, 5, 5);

INSERT INTO works_on (Essn, Pno, Hours) VALUES
(123456789, 10, 20.00),
(987654321, 20, 15.50),
(456789123, 30, 30.00),
(321654987, 40, 18.75),
(741852963, 50, 25.00);

INSERT INTO dependent (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
(123456789, 'Michael Smith', 'M', '2010-04-12', 'Son'),
(987654321, 'Laura Johnson', 'F', '2012-06-30', 'Daughter'),
(456789123, 'Emma Brown', 'F', '2015-09-01', 'Daughter'),
(741852963, 'Paul Wilson', 'M', '2008-01-20', 'Son');

#DML - Parte 2 --> dados aleatorios
INSERT INTO employee
(Fname, Minit, Lname, Ssn, Bdate, Adress, Sex, Salary, Super_ssn, Dno, Dnumber) VALUES
('Carlos', 'A', 'Mendes', 111111111, '1982-04-10', 'Rua Alpha, 100', 'M', 6200.00, NULL, 1, 1),
('Fernanda', 'B', 'Oliveira', 222222222, '1990-09-22', 'Av Beta, 245', 'F', 5800.00, 111111111, 1, 1),
('Ricardo', 'C', 'Souza', 333333333, '1985-12-05', 'Rua Gamma, 78', 'M', 7100.00, 111111111, 2, 2),
('Patricia', 'D', 'Lima', 444444444, '1992-07-18', 'Av Delta, 910', 'F', 5400.00, 333333333, 2, 2),
('Eduardo', 'E', 'Ramos', 555555555, '1978-02-28', 'Rua Épsilon, 56', 'M', 8800.00, NULL, 3, 3),
('Mariana', 'F', 'Costa', 666666666, '1988-11-11', 'Av Zeta, 300', 'F', 7600.00, 555555555, 3, 3),
('Lucas', 'G', 'Pereira', 777777777, '1995-01-03', 'Rua Eta, 42', 'M', 4900.00, 555555555, 4, 4),
('Renata', 'H', 'Alves', 888888888, '1986-06-14', 'Av Theta, 77', 'F', 6700.00, NULL, 4, 4),
('Thiago', 'I', 'Barbosa', 999999999, '1991-03-27', 'Rua Iota, 890', 'M', 7300.00, 888888888, 5, 5),
('Aline', 'J', 'Nascimento', 101010101, '1994-10-09', 'Av Kappa, 15', 'F', 5200.00, 888888888, 5, 5);

INSERT INTO dependent
(Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
(111111111, 'Bruno Mendes', 'M', '2010-05-12', 'Son'),
(222222222, 'Laura Oliveira', 'F', '2015-08-30', 'Daughter'),
(333333333, 'Ana Souza', 'F', '2012-11-20', 'Daughter'),
(555555555, 'Paulo Ramos', 'M', '2008-03-14', 'Son'),
(666666666, 'Helena Costa', 'F', '2016-07-25', 'Daughter'),
(888888888, 'Miguel Alves', 'M', '2013-09-02', 'Son');

INSERT INTO works_on (Essn, Pno, Hours) VALUES
-- Departamento 1 – Research
(111111111, 10, 32.00),
(222222222, 10, 28.50),

-- Departamento 2 – Administration
(333333333, 20, 35.00),
(444444444, 20, 26.75),

-- Departamento 3 – IT
(555555555, 30, 40.00),
(666666666, 30, 30.25),

-- Departamento 4 – HR
(777777777, 40, 22.00),
(888888888, 40, 34.50),

-- Departamento 5 – Finance
(999999999, 50, 36.00),
(101010101, 50, 24.00);










