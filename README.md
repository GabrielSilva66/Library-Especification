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
- **Paradigm**: Algebraic specification with visible sorts and equational term rewriting.

---

## 4. Repository Structure

```text
.
├── README.md               # Project presentation and documentation
├── spec.md                 # Formal planning, architecture, and task checklist
├── doc/estado-biblioteca.md # Global state, observer decisions and test guide
├── scripts/testar.py       # Test runner with assertion/error checking
├── spec/                   # Formal specifications in CafeOBJ (.mod / .cafe)
│   ├── identificadores.mod # Core sorts (LivroId, UsuarioId, ObraId)
│   ├── livro.mod           # Book entity
│   ├── usuario.mod         # User entity
│   ├── acervo.mod          # Collection monoid and book operations
│   ├── colecao-usuarios.mod # User collection and queries
│   ├── emprestimo.mod      # Loan relationships and pending items
│   ├── biblioteca.mod      # Global state, projections and queries
│   ├── demo.cafe           # Real-world scenario reductions (lifecycle, rules, invariants)
│   ├── teste-carregamento.cafe # Module loading checks
│   ├── teste-colecao-usuarios.cafe # User collection assertions
│   ├── teste-emprestimo.cafe # Loan collection assertions
│   ├── teste-regressoes.cafe # Duplicate IDs, searches, removals and algebraic laws
│   ├── teste-estado-biblioteca.cafe # 46 assertions about states and observers
│   ├── teste-transicoes-biblioteca.cafe # 64 assertions about transitions, queries, and invariants
│   └── testes.cafe         # Boolean suite: 165 assertions
└── ref/                    # Reference materials and course examples
    ├── Banco/              # Banking specification example in CafeOBJ
    ├── Trabalho-Pratico.pdf # Practical assignment specification (DIM0167)
    └── cafeobj_apresentacao.pdf
```

---

## 5. How to Run the Specification

### Prerequisites
CafeOBJ installed and accessible in your shell environment (`command -v cafeobj`).
The optional test runner requires Python 3 and uses only the standard library.

### Automated verification

From the repository root:

```bash
python3 scripts/testar.py
```

For the Homebrew/CLISP installation where `-batch` only prints the CLISP directory
or startup reports `No such file: std`, use:

```bash
python3 scripts/testar.py --homebrew
python3 scripts/testar.py --homebrew --verbose
```

The Homebrew option locates the installed prelude and loads the standard modules
before running the suite. It does not change the installation. Successful output:

```text
OK: 165/165 assercoes verdadeiras; 165 reducoes executadas.
```

The runner fails on false/unresolved assertions, missing reductions, warnings,
errors, nonzero process status or a 60-second timeout. A CafeOBJ exit status of
zero alone is not sufficient evidence of success.

### Linux: instruções para os integrantes do grupo

Com Python 3 e CafeOBJ instalados, execute na raiz do clone:

```bash
python3 --version
command -v cafeobj || command -v CafeOBJ
python3 scripts/testar.py
python3 scripts/testar.py --verbose
```

Não é necessário editar caminhos, instalar pacotes com `pip` ou usar Homebrew.
O script encontra `cafeobj` ou `CafeOBJ` no `PATH`, localiza `spec/` a partir do
próprio arquivo e executa os mesmos testes `.cafe` em qualquer clone. Python apenas
inicia CafeOBJ e verifica sua saída; as equações e os testes são executados em CafeOBJ.

Se o executável não for encontrado, configure o `PATH` da instalação de CafeOBJ.
Se `-batch` falhar, examine a saída de `--verbose`; a opção `--homebrew` só se aplica
a uma instalação feita pelo Homebrew, não é uma opção genérica para Linux.

O resultado esperado também no Linux é `OK: 165/165 assercoes verdadeiras; 165 reducoes executadas.`

### Interactive Execution
With a normally configured CafeOBJ installation, launch it from `spec/` so that
relative includes resolve:

```bash
cd spec
cafeobj
```

Inside the interactive shell:
```cafeobj
in testes.cafe
in demo.cafe
quit
```

### Batch Execution
To run tests and reductions directly from the terminal:

```bash
cd spec
cafeobj -batch testes.cafe
cafeobj -batch demo.cafe
```

The suite expects `(true):Bool` for every assertion. The separate `demo.cafe`
prints books, numbers and booleans for inspection; it is not part of the 165 assertions.

Dependencies use `require`/`provide` to avoid repeated definitions. Restart CafeOBJ
after editing modules, since `require` caches loaded features within a session.

## Changes

### Current collection semantics

All three collections are commutative monoids representing multisets: repeated
records are retained and counted. Searches by book ID return `livroInexistente`,
the unique book, or `livroDuplicado`. Collection-level removals remove every
occurrence of the requested ID, independently of term order.
Adding a book or user requires validity (`valido?`) and uniqueness of the identifier.

### Global state, observers and catalog queries

`biblioteca(A, US, ES)` combines the book collection, registered users and loan
records into one visible state. `bibliotecaVazia` denotes the state with all three
collections empty. The projections `acervo`, `usuarios` and `emprestimos` retrieve
the original components without changing them.

State queries use the entity ID as the first argument:
`pertenceAcervo?(LID, B)`, `usuarioRegistrado?(UID, B)`, `emprestado?(LID, B)`,
`temLivro?(UID, LID, B)` and `disponivel?(LID, B)`.
Global counters accept `Biblioteca`: `qtdAcervo(B)`, `qtdUsuarios(B)`, `qtdEmprestimos(B)`
and `qtdDisponiveis(B)`.
Catalog queries are forwarded to the active collection: `buscarLivro(LID, B)`,
`buscarTitulo(T, B)`, `qtdExemplaresObra(OID, B)`, and `tituloDeAutor(T, B)`.

### State transitions and global integrity invariants (latest change)

Guarded state transitions ensure business rules are enforced:
- `registrarLivro(L, B)`: adds book if valid and not already present.
- `removerLivro(LID, B)`: removes book only if currently available (not loaned).
- `registrarUsuario(U, B)`: registers user if valid and ID is unique.
- `removerUsuario(UID, B)`: removes user only if they have no active loans.
- `emprestarLivro(LID, UID, B)`: creates loan only if book is available and user is registered.
- `devolverLivro(LID, UID, B)`: returns book only if actively on loan to that specific user.

Global consistency is formalized by `valido?(B)` and `emprestimosValidos?(B)`, verifying
that all items are valid, IDs are unique across collections, and every active loan
references a valid book in the collection and a registered user.
These rules and edge cases are validated by the 64 assertions in `teste-transicoes-biblioteca.cafe`.