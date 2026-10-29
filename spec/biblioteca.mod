require acervo acervo.mod
require colecao-usuarios colecao-usuarios.mod
require emprestimo emprestimo.mod
mod! BIBLIOTECA {
  protecting(ACERVO)
  protecting(COLECAO-USUARIOS)
  protecting(EMPRESTIMO)

  [ Biblioteca ]

  -- Estado visivel: os livros emprestados continuam pertencendo ao acervo.
  -- O construtor representa dados; nao verifica as regras de negocio
  op biblioteca : Acervo ConjuntoUsuarios ConjuntoEmprestimos -> Biblioteca { constr }
  op bibliotecaVazia : -> Biblioteca

  -- Projecoes: recuperam exatamente os componentes armazenados.
  op acervo : Biblioteca -> Acervo
  op usuarios : Biblioteca -> ConjuntoUsuarios
  op emprestimos : Biblioteca -> ConjuntoEmprestimos

  -- Consultas do estado global (estado como primeiro argumento).
  op pertenceAcervo? : Biblioteca LivroId -> Bool
  op usuarioRegistrado? : Biblioteca UsuarioId -> Bool
  op emprestado? : Biblioteca LivroId -> Bool
  op temLivro? : Biblioteca UsuarioId LivroId -> Bool
  op disponivel? : Biblioteca LivroId -> Bool

  -- Sobrecargas das contagens existentes, agora aceitando Biblioteca.
  op qtdAcervo : Biblioteca -> Nat
  op qtdUsuarios : Biblioteca -> Nat
  op qtdEmprestimos : Biblioteca -> Nat
  op qtdDisponiveis : Biblioteca -> Nat
  -- Auxiliar: conta ocorrencias do acervo sem registro de emprestimo.
  op contarDisponiveis : Acervo ConjuntoEmprestimos -> Nat

  var B : Biblioteca
  var A : Acervo
  var US : ConjuntoUsuarios
  var ES : ConjuntoEmprestimos
  var L : Livro
  var ID : LivroId
  var UID : UsuarioId

  eq bibliotecaVazia = biblioteca(vazioAcervo, vazioUsuarios, semEmprestimo) .
  eq acervo(biblioteca(A, US, ES)) = A .
  eq usuarios(biblioteca(A, US, ES)) = US .
  eq emprestimos(biblioteca(A, US, ES)) = ES .

  eq pertenceAcervo?(B, ID) = pertenceAcervo?(ID, acervo(B)) .
  eq usuarioRegistrado?(B, UID) = pertence?(UID, usuarios(B)) .
  eq emprestado?(B, ID) = emprestado?(ID, emprestimos(B)) .
  eq temLivro?(B, UID, ID) = temLivro?(UID, ID, emprestimos(B)) .
  -- Um livro inexistente nunca e considerado disponivel.
  eq disponivel?(B, ID) = pertenceAcervo?(B, ID) and not emprestado?(B, ID) .

  eq qtdAcervo(B) = qtdAcervo(acervo(B)) .
  eq qtdUsuarios(B) = qtdUsuarios(usuarios(B)) .
  eq qtdEmprestimos(B) = qtdEmprestimos(emprestimos(B)) .
  eq qtdDisponiveis(B) = contarDisponiveis(acervo(B), emprestimos(B)) .
  -- Contagem independente, sem subtrair emprestimos do total do acervo.
  eq contarDisponiveis(vazioAcervo, ES) = 0 .
  eq contarDisponiveis(L A, ES) =
    if emprestado?(id(L), ES)
    then contarDisponiveis(A, ES)
    else 1 + contarDisponiveis(A, ES)
    fi .
}

provide biblioteca
