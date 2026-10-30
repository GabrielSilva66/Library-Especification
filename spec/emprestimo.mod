require identificadores identificadores.mod

mod! EMPRESTIMO {
  protecting(NAT)
  protecting(BOOL)
  protecting(IDENTIFICADORES)

  [ Emprestimo < ConjuntoEmprestimos ]

  -- Construtores do Monóide (coleção comutativa com elemento neutro)
  op semEmprestimo : -> ConjuntoEmprestimos { constr }
  op emprestar : LivroId UsuarioId -> ConjuntoEmprestimos { constr }
  op __ : ConjuntoEmprestimos ConjuntoEmprestimos -> ConjuntoEmprestimos { constr assoc comm id: semEmprestimo }

  -- Modificadores
  op iniciarEmprestimos : -> ConjuntoEmprestimos
  op emprestar : LivroId UsuarioId ConjuntoEmprestimos -> ConjuntoEmprestimos
  op devolver : LivroId ConjuntoEmprestimos -> ConjuntoEmprestimos

  -- Consultas
  op qtdEmprestimos : ConjuntoEmprestimos -> Nat

  -- Predicados
  pred emprestado? : LivroId ConjuntoEmprestimos
  pred temLivro? : UsuarioId LivroId ConjuntoEmprestimos
  pred temLivro? : UsuarioId ConjuntoEmprestimos
  pred livrosUnicos? : ConjuntoEmprestimos

  -- Variáveis usadas nas equações
  vars LID LID2 : LivroId
  vars UID UID2 : UsuarioId
  var  ES   : ConjuntoEmprestimos

  -- Construtor de coleção vazia
  eq iniciarEmprestimos = semEmprestimo .

  -- Adiciona um emprestimo à coleção, sem duplicatas
  eq emprestar(LID, UID, ES) = 
    if temLivro?(UID, LID, ES) 
    then ES 
    else emprestar(LID, UID) ES 
    fi .

  -- Devolver um livro remove todos os registros do livro, mesmo em coleções inconsistentes.
  eq devolver(LID, semEmprestimo) = semEmprestimo .
  eq devolver(LID, emprestar(LID2, UID) ES) =
    if LID == LID2 
    then devolver(LID, ES) 
    else emprestar(LID2, UID) devolver(LID, ES) 
    fi .

  -- Consulta a quantidade de empréstimos ativos
  eq qtdEmprestimos(semEmprestimo) = 0 .
  eq qtdEmprestimos(emprestar(LID, UID) ES) = 1 + qtdEmprestimos(ES) .
  
  -- Predicado que verifica se um determinado livro está emprestado
  eq emprestado?(LID, semEmprestimo) = false .
  eq emprestado?(LID, emprestar(LID2, UID) ES) = 
    if LID == LID2 
    then true 
    else emprestado?(LID, ES) 
    fi .
  
  -- Predicado que verifica se determinado usuário possui determinado livro
  eq temLivro?(UID, LID, semEmprestimo) = false .
  eq temLivro?(UID, LID, emprestar(LID2, UID2) ES) = 
    if (LID == LID2) and (UID == UID2) 
    then true 
    else temLivro?(UID, LID, ES) 
    fi .

  -- Predicado que verifica se determinado usuário possui qualquer livro
  eq temLivro?(UID, semEmprestimo) = false .
  eq temLivro?(UID, emprestar(LID, UID2) ES) = 
    if (UID == UID2) 
    then true 
    else temLivro?(UID, ES) 
    fi .

  -- Predicado que verifica se cada livro emprestado é único, ou seja, não há duplicatas de empréstimos do mesmo livro.
  eq livrosUnicos?(semEmprestimo) = true .
  eq livrosUnicos?(emprestar(LID, UID) ES) = 
    if emprestado?(LID, ES)
    then false
    else livrosUnicos?(ES)
    fi .
}

provide emprestimo
