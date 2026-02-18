# 🛒 Projeto 1 – Banco de Dados E-commerce com Stored Procedures (MySQL)

Este projeto implementa um banco de dados relacional para um **sistema de e-commerce**, com foco em **modelagem**, **integridade referencial** e **uso de stored procedures** para manipulação de dados.

---

## 📌 Descrição Geral

O banco de dados foi projetado para representar um cenário real de e-commerce, abrangendo clientes (pessoa física e jurídica), produtos, pedidos, pagamentos, estoque, parceiros, fornecedores e vendedores.

Além da estrutura relacional, foram criadas **stored procedures** que concentram operações de **inserção, consulta, atualização e exclusão**, controladas por uma **variável de decisão**, conforme proposto no enunciado.

---

## 🧱 Estrutura do Banco de Dados

Principais entidades:

- Plataforma  
- Cliente  
- Pessoa Física  
- Pessoa Jurídica  
- Endereço e Endereço Extra  
- Pedido  
- Produto  
- Estoque  
- Pagamento (Cartão, PIX, Boleto)  
- Parceiro  
- Fornecedor  
- Vendedor  

Relacionamentos relevantes:
- Relacionamentos N:N (Pedido × Produto, Produto × Vendedor)
- Especialização de Cliente em Pessoa Física e Pessoa Jurídica
- Uso extensivo de chaves primárias e estrangeiras para garantir integridade referencial

---

## ⚙️ Stored Procedures

As procedures seguem o padrão **CRUD**, utilizando:

- Variável de controle (`p_acao`)
- Estruturas condicionais (`IF / ELSEIF`)

### Ações da variável de controle:
- `1` → SELECT  
- `2` → INSERT  
- `3` → UPDATE  
- `4` → DELETE  

### Exemplo de chamada:
```sql
CALL sp_cliente_crud(
  2, NULL,
  'Rua A', '123', 'Apto 10',
  'Centro', '01001000', 'SP', 'Brasil'
);

---

## 📁 README – Projeto 2 (Company)

```markdown
# 🏢 Projeto 2 – Banco de Dados Company com Índices e Queries (MySQL)

Este projeto implementa um banco de dados corporativo com foco na **criação estratégica de índices** e na **otimização de consultas SQL**, a partir de perguntas de negócio previamente definidas.

---

## 📌 Descrição Geral

O banco de dados simula um ambiente empresarial contendo departamentos, empregados, projetos, localizações e dependentes.

O principal objetivo é demonstrar **como e por que criar índices**, considerando:
- Dados mais acessados
- Dados mais relevantes para o contexto
- Impacto dos índices na performance das consultas

---

## 🧱 Estrutura do Banco de Dados

Tabelas principais:

- `departament`
- `employee`
- `dept_locations`
- `project`
- `works_on`
- `dependent`

O modelo utiliza chaves primárias e estrangeiras para garantir integridade e consistência dos dados.

---

## 🔍 Perguntas Respondidas (Queries)

1. **Qual o departamento com maior número de pessoas?**  
2. **Quais são os departamentos por cidade?**  
3. **Relação de empregados por departamento?**  

As consultas utilizam:
- `INNER JOIN`
- `GROUP BY`
- `ORDER BY`
- Funções de agregação (`COUNT`)

---

## 🚀 Índices Criados e Justificativas

Os índices foram criados **com base nas queries**, evitando indexações desnecessárias.

| Tabela | Índice | Tipo | Justificativa |
|------|------|------|------|
| departament | Dname | BTREE | Utilizado em projeções e ordenações |
| employee | Dnumber | BTREE | Chave estrangeira usada em JOINs |
| employee | (Fname, Lname) | BTREE composto | Otimiza listagem e ordenação de empregados |
| PKs / FKs | Automáticos | BTREE | Garantem integridade e melhor desempenho |

> Observação: índices melhoram a performance de leitura, mas impactam operações de escrita. Por isso, foram criados apenas quando necessários.

---

## 🎯 Objetivos Atendidos

- Criação consciente e justificada de índices
- Otimização de consultas SQL
- Aplicação prática de PKs e FKs
- Documentação das decisões técnicas

---

## 🛠 Tecnologias Utilizadas

- MySQL 8.x  
- SQL (DDL e DML)  
- Índices BTREE  

---

## 📚 Considerações Finais

Este projeto reforça a importância da análise das consultas antes da criação de índices, demonstrando boas práticas de desempenho e organização em bancos de dados relacionais corporativos.
