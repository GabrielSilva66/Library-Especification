in identificadores.mod

mod! USUARIOS {
  protecting(BOOL)
  protecting(STRING)                                                                                                                                         
  protecting(IDENTIFICADORES)

  [ Usuario ]

  -- Construtor como Tupla do Produto Cartesiano (ID, Nome, Email)
  op usuario : UsuarioId String String -> Usuario { constr }

  op id    : Usuario -> UsuarioId
  op nome  : Usuario -> String
  op email : Usuario -> String

  vars ID : UsuarioId
  vars N E : String

  eq id(usuario(ID, N, E)) = ID .
  eq nome(usuario(ID, N, E)) = N .
  eq email(usuario(ID, N, E)) = E .

  op valido? : Usuario -> Bool
  eq valido?(usuario(ID, N, E)) = (N =/= "") and (E =/= "") .

}