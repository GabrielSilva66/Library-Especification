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
│   ├── demo.cafe           # 19 illustrative reductions
│   ├── teste-carregamento.cafe # Module loading checks
│   ├── teste-colecao-usuarios.cafe # User collection assertions
│   ├── teste-emprestimo.cafe # Loan collection assertions
│   ├── teste-regressoes.cafe # Duplicate IDs, searches, removals and algebraic laws
│   ├── teste-estado-biblioteca.cafe # 46 assertions about states and observers
│   └── testes.cafe         # Boolean suite: 101 assertions
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
OK: 101/101 assercoes verdadeiras; 101 reducoes executadas.
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

A suíte foi executada em macOS com CafeOBJ 1.6.2. O modo padrão usa recursos
portáveis, mas ainda não foi validado em uma máquina Linux. O resultado esperado
também no Linux é `OK: 101/101 assercoes verdadeiras; 101 reducoes executadas.`

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
prints books, numbers and booleans for inspection; it is not part of the 101 assertions.

Dependencies use `require`/`provide` to avoid repeated definitions. Restart CafeOBJ
after editing modules, since `require` caches loaded features within a session.

## Changes

### Current collection semantics

All three collections are commutative monoids representing multisets: repeated
records are retained and counted. Searches by book ID return `livroInexistente`,
the unique book, or `livroDuplicado`. Collection-level removals remove every
occurrence of the requested ID, independently of term order.

For example, a multiset containing `a a b` has three occurrences; a set would
collapse it to `a b`. Two distinct copies of the same work remain distinct books
because their `LivroId` values differ. Repeating the same `LivroId` can represent
invalid input, which the low-level collections must handle deterministically;
the future library operations will enforce uniqueness and loan authorization.

### Global state and observers (last change)

`biblioteca(A, US, ES)` combines the book collection, registered users and loan
records into one visible state. `bibliotecaVazia` denotes the state with all three
collections empty. The projections `acervo`, `usuarios` and `emprestimos` retrieve
the original components without changing them.

State queries use the library as the first argument: `pertenceAcervo?(B, ID)`,
`usuarioRegistrado?(B, UID)`, `emprestado?(B, ID)`, `temLivro?(B, UID, ID)` and
`disponivel?(B, ID)`. The existing counters also accept `Biblioteca`:
`qtdAcervo(B)`, `qtdUsuarios(B)` and `qtdEmprestimos(B)`.
`qtdDisponiveis(B)` independently counts collection entries without a loan record.

Borrowed books remain in the collection. Availability requires both collection
membership and absence of a loan. The constructor represents data, including
inconsistent states; guarded updates and global validity predicates are still
pending. Loan queries report the stored relation, not an authorization decision.