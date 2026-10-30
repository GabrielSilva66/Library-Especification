-- ============================================================
-- usuario.mod: Especificação da entidade Usuario
-- ============================================================
require identificadores identificadores.mod

mod! USUARIO {
  protecting(BOOL)
  protecting(STRING)                                                                                                                                         
  protecting(IDENTIFICADORES)

  -- Sort principal da entidade
  [ Usuario ]

  -- Construtor: cria um Usuario a partir de (ID, Nome, Email)
  op usuario : UsuarioId String String -> Usuario { constr }

  -- Projeções (Getters): extraem os atributos do usuário
  op id    : Usuario -> UsuarioId
  op nome  : Usuario -> String
  op email : Usuario -> String

  -- Predicado
  pred valido? : Usuario

  -- Variáveis usadas nas equações
  vars ID : UsuarioId
  vars N E : String

  -- Equações de projeção: retornam o respectivo campo do construtor
  eq id(usuario(ID, N, E))    = ID .
  eq nome(usuario(ID, N, E))  = N .
  eq email(usuario(ID, N, E)) = E .

  -- Predicado de validação: um usuário é válido se nome e email não forem strings vazias
  eq valido?(usuario(ID, N, E)) = (N =/= "") and (E =/= "") .
}

provide usuario
