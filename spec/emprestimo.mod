require identificadores identificadores.mod

mod! EMPRESTIMO {
  protecting(NAT)
  protecting(BOOL)
  protecting(IDENTIFICADORES)

  [ Emprestimo < ConjuntoEmprestimos ]

  -- Operador construtor de um empréstimo individual: "emprestar livro L ao usuário U"
  op emprestar : LivroId UsuarioId -> Emprestimo { constr }

  -- Elemento neutro (nenhum empréstimo realizado)
  op semEmprestimo : -> ConjuntoEmprestimos { constr }

  -- União de multiconjuntos: cada ocorrência de empréstimo é contada.
  op __ : ConjuntoEmprestimos ConjuntoEmprestimos -> ConjuntoEmprestimos { constr assoc comm id: semEmprestimo }

  vars L L2 : LivroId
  vars U U2 : UsuarioId
  var  ES   : ConjuntoEmprestimos

  -- Sem idempotência: E E tem duas ocorrências, coerentemente com qtdEmprestimos.
  
  -- Consulta: Verifica se um determinado livro está emprestado
  pred emprestado? : LivroId ConjuntoEmprestimos
  eq emprestado?(L, semEmprestimo) = false .
  eq emprestado?(L, emprestar(L, U) ES) = true .
  ceq emprestado?(L, emprestar(L2, U) ES) = emprestado?(L, ES) if L =/= L2 .
  
  -- Consulta: Verifica se determinado usuário possui determinado livro
  pred temLivro? : UsuarioId LivroId ConjuntoEmprestimos
  eq temLivro?(U, L, semEmprestimo) = false .
  eq temLivro?(U, L, emprestar(L, U) ES) = true .
  ceq temLivro?(U, L, emprestar(L2, U2) ES) = temLivro?(U, L, ES) if (L =/= L2) or (U =/= U2) .
  
  -- Operação da coleção: remove todos os registros do livro, mesmo em
  -- coleções inconsistentes. A autorização do usuário caberá a BIBLIOTECA.
  op devolver : LivroId ConjuntoEmprestimos -> ConjuntoEmprestimos
  eq devolver(L, semEmprestimo) = semEmprestimo .
  eq devolver(L, emprestar(L, U) ES) = devolver(L, ES) .
  ceq devolver(L, emprestar(L2, U) ES) = emprestar(L2, U) devolver(L, ES) if L =/= L2 .

  -- Consulta: Quantidade de empréstimos ativos
  op qtdEmprestimos : ConjuntoEmprestimos -> Nat
  eq qtdEmprestimos(semEmprestimo) = 0 .
  eq qtdEmprestimos(emprestar(L, U) ES) = 1 + qtdEmprestimos(ES) .
}

provide emprestimo
