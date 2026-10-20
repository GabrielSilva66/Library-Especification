mod! LIVRO {
  protecting(IDENTIFICADORES)
  protecting(STRING)
  protecting(NAT)
  protecting(BOOL)

  [ Livro ]
  
  -- Construtor de Produto Cartesiano (ID, Título, Autor, Ano)
  op livro : LivroId String String Nat -> Livro {constr}

  -- Projeções Canônicas Nomeadas
  op id : LivroId -> LivroId
  op titulo : LivroId -> String
  op autor : LivroId -> String
  op ano : LivroId -> Nat

  op valido? : Livro -> Bool

  var ID : LivroId
  vars T A : String
  var Ano : Nat

  eq id(livro(ID, T, A, Ano)) = ID . 
  eq titulo(livro(ID, T, A, Ano)) = T . 
  eq autor(livro(ID, T, A, Ano)) = A . 
  eq ano(livro(ID, T, A, Ano)) = Ano . 

  eq valido?(livro(ID, T, A, Ano)) = (T =/= "") and (A =/= "") and (Ano > 0) .

}