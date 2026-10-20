# Sistema de Biblioteca — Especificação Algébrica Formal

Projeto prático desenvolvido para a disciplina **Estruturas Algébricas (DIM0167)** da Universidade Federal do Rio Grande do Norte (**UFRN**), ministrada pelo **Prof. Valdigleis S. Costa**.

---

## 1. Visão Geral do Projeto

O objetivo deste projeto é aplicar os conceitos de **estruturas algébricas**, **lógica equacional** e **sistemas de reescrita de termos** na especificação formal de um **Sistema de Biblioteca**.

O foco é a construção de um modelo matemático abstrato, rigoroso e consistente, definindo:
- **Sorts e Subsorts** (universos de termos / tipos);
- **Operadores Construtores** (que geram as estruturas canônicas do sistema, como monóides comutativos);
- **Operadores Definidos / Observadores** (consultas e predicados sobre o estado);
- **Equações e Regras de Transição** (que governam as mudanças de estado e preservam os invariantes);
- **Tratamento de Operações Inválidas e Casos de Fronteira**.

---

## 2. O Domínio do Sistema (Biblioteca)

O sistema gerencia um acervo bibliográfico e os empréstimos realizados por usuários registrados:

### Entidades e Conceitos Principais
- **Identificadores Únicos**: `LivroId` e `UsuarioId`.
- **Acervo**: Coleção algébrica dos livros pertencentes à biblioteca.
- **Usuários**: Coleção algébrica dos usuários cadastrados.
- **Empréstimos**: Relação algébrica que associa um livro a um usuário mutuamente.
- **Biblioteca**: O estado consolidado do sistema contendo o acervo, a base de usuários e os empréstimos ativos.

### Regras de Negócio Fundamentais
1. Um livro só pode ser emprestado se pertencer ao acervo da biblioteca.
2. Um livro não pode ser emprestado se já estiver emprestado a qualquer usuário.
3. A devolução de um livro torna-o imediatamente disponível no acervo.
4. Um usuário só pode devolver um livro que de fato esteja emprestado a ele.
5. A remoção de um livro do acervo só é permitida se o livro estiver disponível (não emprestado).
6. A identificação de cada livro e de cada usuário deve ser única.
7. Conservação de cardinalidade: $\text{Livros Disponíveis} + \text{Livros Emprestados} = \text{Total no Acervo}$.

---

## 3. Ferramenta Utilizada

- **Linguagem / Sistema**: [CafeOBJ](https://cafeobj.org/) (versão 1.6.2).
- **Paradigma**: Especificação algébrica baseada em Lógica Equacional e Lógica Oculta (Hidden Algebra / Rewriting Logic).

---

## 4. Estrutura do Repositório

```text
.
├── README.md               # Apresentação e guia do projeto
├── spec.md                 # Planejamento formal, arquitetura e checklist de tarefas
├── Trabalho-Pratico.pdf    # Especificação do trabalho prático (DIM0167)
├── spec/                   # Especificações formais em CafeOBJ (.mod / .cafe)
│   ├── identificadores.mod # Sorts fundamentais (LivroId, UsuarioId)
│   ├── acervo.mod          # Monóide do acervo e operações de livros
│   ├── usuarios.mod        # Gestão e pertinência de usuários
│   ├── emprestimo.mod      # Relações de empréstimo e pendências
│   ├── biblioteca.mod      # Estado global da biblioteca e transições
│   └── demo.cafe           # Testes experimentais e reescrita de termos
└── ref/                    # Materiais de referência e exemplos do curso
    ├── Banco/              # Exemplo de especificação bancária em CafeOBJ
    └── cafeobj_apresentacao.pdf
```

---

## 5. Como Executar a Especificação

### Pré-requisitos
Ter o CafeOBJ instalado no ambiente (verifique com `cafeobj --version` ou `which cafeobj`).

### Execução Interativa
Abra o CafeOBJ no diretório do projeto ou carregue o módulo desejado:

```bash
cafeobj
```

Dentro do shell interativo:
```cafeobj
CafeOBJ> in spec/identificadores.mod .
CafeOBJ> in spec/acervo.mod .
CafeOBJ> in spec/usuarios.mod .
CafeOBJ> in spec/emprestimo.mod .
CafeOBJ> in spec/biblioteca.mod .
CafeOBJ> in spec/demo.cafe .
```

### Execução em Lote (Batch)
Para processar os testes e reduções diretamente via terminal:

```bash
cafeobj -batch spec/demo.cafe
```
