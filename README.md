# Library System — Formal Algebraic Specification

Practical project developed for the **Algebraic Structures (DIM0167)** course at the Federal University of Rio Grande do Norte (**UFRN**), taught by **Prof. Valdigleis S. Costa**.

---

## 1. Project Overview

The objective of this project is to apply concepts from **algebraic structures**, **equational logic**, and **term rewriting systems** in the formal specification of a **Library System**.

The main focus is the construction of an abstract, rigorous, and consistent mathematical model defining:
- **Sorts and Subsorts** (universes of discourse / types);
- **Constructor Operators** (which generate canonical structures, such as commutative monoids);
- **Defined Operators / Observers** (queries and state predicates);
- **Equations and State Transition Rules** (which govern state updates and maintain system invariants);
- **Handling of Invalid Operations and Edge Cases**.

---

## 2. System Domain (Library)

The system manages a library collection and book loans made by registered users:

### Key Entities and Concepts
- **Unique Identifiers**: `LivroId` (Book ID) and `UsuarioId` (User ID).
- **Collection (Acervo)**: Algebraic collection of books belonging to the library.
- **Users (Usuarios)**: Algebraic collection of registered users.
- **Loans (Emprestimos)**: Algebraic relation associating a book with a borrower.
- **Library (Biblioteca)**: The consolidated state of the system encompassing the book collection, registered users, and active loans.

### Fundamental Business Rules
1. A book cannot be borrowed if it does not belong to the library collection.
2. A book cannot be borrowed if it is already on loan to any user.
3. Returning a book makes it immediately available in the collection.
4. A user can only return a book that is currently on loan to them.
5. Removing a book from the collection is only permitted when the book is available (not loaned out).
6. Identifiers for books and users must be unique.
7. Cardinality conservation: $\text{Available Books} + \text{Loaned Books} = \text{Total Books in Collection}$.

---

## 3. Tooling

- **Language / System**: [CafeOBJ](https://cafeobj.org/) (version 1.6.2).
- **Paradigm**: Algebraic specification based on Equational Logic and Hidden Algebra / Rewriting Logic.

---

## 4. Repository Structure

```text
.
├── README.md               # Project presentation and documentation
├── spec.md                 # Formal planning, architecture, and task checklist
├── Trabalho-Pratico.pdf    # Practical assignment specification (DIM0167)
├── spec/                   # Formal specifications in CafeOBJ (.mod / .cafe)
│   ├── identificadores.mod # Core sorts (LivroId, UsuarioId)
│   ├── acervo.mod          # Collection monoid and book operations
│   ├── usuarios.mod        # User management and registration checks
│   ├── emprestimo.mod      # Loan relationships and pending items
│   ├── biblioteca.mod      # Global library state and transitions
│   └── demo.cafe           # Experimental tests and term rewriting
└── ref/                    # Reference materials and course examples
    ├── Banco/              # Banking specification example in CafeOBJ
    └── cafeobj_apresentacao.pdf
```

---

## 5. How to Run the Specification

### Prerequisites
CafeOBJ installed and accessible in your shell environment (verify with `cafeobj --version` or `which cafeobj`).

### Interactive Execution
Launch CafeOBJ in the project directory and load the desired modules:

```bash
cafeobj
```

Inside the interactive shell:
```cafeobj
CafeOBJ> in spec/identificadores.mod .
CafeOBJ> in spec/acervo.mod .
CafeOBJ> in spec/usuarios.mod .
CafeOBJ> in spec/emprestimo.mod .
CafeOBJ> in spec/biblioteca.mod .
CafeOBJ> in spec/demo.cafe .
```

### Batch Execution
To run tests and reductions directly from the terminal:

```bash
cafeobj -batch spec/demo.cafe
```
