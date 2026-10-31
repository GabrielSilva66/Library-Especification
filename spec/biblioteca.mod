require acervo acervo.mod
require colecao-usuarios colecao-usuarios.mod
require emprestimo emprestimo.mod
mod! BIBLIOTECA {
  protecting(ACERVO)
  protecting(COLECAO-USUARIOS)
  protecting(EMPRESTIMO)

  [ Biblioteca ]

  -- Construtores
  op bibliotecaVazia : -> Biblioteca
  op biblioteca : Acervo ConjuntoUsuarios ConjuntoEmprestimos -> Biblioteca { constr }

  -- Projeções
  op acervo : Biblioteca -> Acervo
  op usuarios : Biblioteca -> ConjuntoUsuarios
  op emprestimos : Biblioteca -> ConjuntoEmprestimos

  -- Modificadores
  op registrarLivro : Livro Biblioteca -> Biblioteca
  op removerLivro : LivroId Biblioteca -> Biblioteca
  op registrarUsuario : Usuario Biblioteca -> Biblioteca
  op removerUsuario : UsuarioId Biblioteca -> Biblioteca
  op emprestarLivro : LivroId UsuarioId Biblioteca -> Biblioteca
  op devolverLivro : LivroId UsuarioId Biblioteca -> Biblioteca

  -- Consultas
  op qtdAcervo : Biblioteca -> Nat
  op qtdUsuarios : Biblioteca -> Nat
  op qtdEmprestimos : Biblioteca -> Nat
  op qtdDisponiveis : Biblioteca -> Nat
  op buscarLivro : LivroId Biblioteca -> LivroOuErro
  op buscarTitulo : String Biblioteca -> Acervo
  op qtdExemplaresObra : ObraId Biblioteca -> Nat
  op tituloDeAutor : String Biblioteca -> Acervo
  op contarDisponiveis : Acervo ConjuntoEmprestimos -> Nat

  -- Predicados
  pred pertenceAcervo? : LivroId Biblioteca
  pred usuarioRegistrado? : UsuarioId Biblioteca
  pred emprestado? : LivroId Biblioteca
  pred temLivro? : UsuarioId LivroId Biblioteca
  pred temLivro? : UsuarioId Biblioteca
  pred disponivel? : LivroId Biblioteca
  pred emprestimosValidos? : Biblioteca
  pred valido? : Biblioteca

  -- Variáveis usadas nas equações
  var B : Biblioteca
  var A : Acervo
  var U : Usuario
  var US : ConjuntoUsuarios
  var ES : ConjuntoEmprestimos
  var L : Livro
  var LID : LivroId
  var UID : UsuarioId
  var T : String
  var OID : ObraId

  -- Construtor de biblioteca vazia
  eq bibliotecaVazia = biblioteca(vazioAcervo, vazioUsuarios, semEmprestimo) .

  -- Projeções: recuperam exatamente os componentes armazenados.
  eq acervo(biblioteca(A, US, ES)) = A .
  eq usuarios(biblioteca(A, US, ES)) = US .
  eq emprestimos(biblioteca(A, US, ES)) = ES .

  -- Adiciona um livro ao acervo da biblioteca
  eq registrarLivro(L, biblioteca(A, US, ES)) = biblioteca(adicionarLivro(L, A), US, ES) .

  -- Remove um livro do acervo da biblioteca
  eq removerLivro(LID, biblioteca(A, US, ES)) = 
    if disponivel?(LID, biblioteca(A, US, ES)) 
    then biblioteca(removerDoAcervo(LID, A), US, ES)
    else biblioteca(A, US, ES) 
    fi .

  -- Registra um usuário na biblioteca
  eq registrarUsuario(U, biblioteca(A, US, ES)) = biblioteca(A, adicionarUsuario(U, US), ES) .

  -- Remove um usuário da biblioteca: apenas se não tiver empréstimos ativos.
  eq removerUsuario(UID, biblioteca(A, US, ES)) = 
    if not(temLivro?(UID, ES))
    then biblioteca(A, removerUsuario(UID, US), ES)
    else biblioteca(A, US, ES)
    fi .

  eq emprestarLivro(LID, UID, biblioteca(A, US, ES)) = 
    if disponivel?(LID, biblioteca(A, US, ES)) and usuarioRegistrado?(UID, biblioteca(A, US, ES))
    then biblioteca(A, US, emprestar(LID, UID, ES))
    else biblioteca(A, US, ES)
    fi .

  eq devolverLivro(LID, UID, biblioteca(A, US, ES)) = 
    if temLivro?(UID, LID, biblioteca(A, US, ES)) 
    then biblioteca(A, US, devolver(LID, ES))
    else biblioteca(A, US, ES)
    fi .

  -- Consulta a quantidade de livros do acervo
  eq qtdAcervo(B) = qtdAcervo(acervo(B)) .

  -- Consulta a quantidade de usuários cadastrados
  eq qtdUsuarios(B) = qtdUsuarios(usuarios(B)) .

  -- Consulta a quantidade de empréstimos ativos
  eq qtdEmprestimos(B) = qtdEmprestimos(emprestimos(B)) .

  -- Consulta um livro pelo seu ID, retornando um LivroOuErro
  eq buscarLivro(LID, B) = buscarLivro(LID, acervo(B)) .
  
  -- Consulta livros pelo título, retornando um sub-acervo
  eq buscarTitulo(T, B) = buscarTitulo(T, acervo(B)) .

  -- Consulta a quantidade de exemplares de uma obra específica
  eq qtdExemplaresObra(OID, B) = qtdExemplaresObra(OID, acervo(B)) .

  -- Consulta livros de um autor específico, retornando um sub-acervo
  eq tituloDeAutor(T, B) = tituloDeAutor(T, acervo(B)) .  

  -- Consulta a quantidade de livros disponíveis para empréstimo
  eq qtdDisponiveis(B) = contarDisponiveis(acervo(B), emprestimos(B)) .

  eq contarDisponiveis(vazioAcervo, ES) = 0 .
  eq contarDisponiveis(L A, ES) =
    if emprestado?(id(L), ES)
    then contarDisponiveis(A, ES)
    else 1 + contarDisponiveis(A, ES)
    fi .

  -- Predicado que verifica se um livro está no acervo da biblioteca
  eq pertenceAcervo?(LID, B) = pertenceAcervo?(LID, acervo(B)) .

  -- Predicado que verifica se um usuário está registrado na biblioteca
  eq usuarioRegistrado?(UID, B) = pertence?(UID, usuarios(B)) .
  
  -- Predicado que verifica se um livro está emprestado
  eq emprestado?(LID, B) = emprestado?(LID, emprestimos(B)) .

  -- Predicado que verifica se um determinado usuário possui um determinado livro emprestado
  eq temLivro?(UID, LID, B) = temLivro?(UID, LID, emprestimos(B)) .

  -- Predicado que verifica se um determinado usuário possui qualquer livro emprestado
  eq temLivro?(UID, B) = temLivro?(UID, emprestimos(B)) .

  -- Predicado que verifica se um livro está disponivel para empréstimo
  eq disponivel?(LID, B) = pertenceAcervo?(LID, B) and not emprestado?(LID, B) .

  -- Predicado que verifica se todos os empréstimos são válidos, ou seja, se cada livro emprestado pertence ao acervo e cada usuário que possui um livro emprestado está registrado na biblioteca.
  eq emprestimosValidos?(biblioteca(A, US, semEmprestimo)) = true .
  eq emprestimosValidos?(biblioteca(A, US, emprestar(LID, UID) ES)) = 
    pertenceAcervo?(LID, A) and pertence?(UID, US) and emprestimosValidos?(biblioteca(A, US, ES)) .

  -- Predicado que verifica se a biblioteca está em um estado válido
  eq valido?(biblioteca(A, US, ES)) = 
    idsUnicos?(A) and todosValidos?(A) and idsUnicos?(US) and todosValidos?(US) and
    livrosUnicos?(ES) and emprestimosValidos?(biblioteca(A, US, ES)) .
}

provide biblioteca
