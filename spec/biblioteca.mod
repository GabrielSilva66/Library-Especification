require acervo acervo.mod
require colecao-usuarios colecao-usuarios.mod
require emprestimo emprestimo.mod


mod! BIBLIOTECA {
  protecting(ACERVO)
  protecting(COLECAO-USUARIOS)
  protecting(EMPRESTIMO)

  [ Biblioteca ]

}

provide biblioteca
