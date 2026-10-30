-- ============================================================
-- livro.mod: Especificação da entidade Livro
-- ============================================================
require identificadores identificadores.mod

mod! LIVRO {
  protecting(IDENTIFICADORES)
  protecting(STRING)
  protecting(NAT)
  protecting(BOOL)

  -- Sort principal da entidade
  [ Livro ]
  
  -- Construtor: cria um Livro a partir de (ID/Tombo, ISBN, Título, Autor, Ano)
  op livro : LivroId ObraId String String Nat -> Livro { constr }

  -- Projeções (Getters): extraem os atributos de um Livro
  op id     : Livro -> LivroId
  op obra   : Livro -> ObraId
  op titulo : Livro -> String
  op autor  : Livro -> String
  op ano    : Livro -> Nat

  -- Predicados
  pred valido? : Livro

  -- Variáveis usadas nas equações
  var ID   : LivroId
  var Obra : ObraId
  vars T A : String
  var Ano  : Nat

  -- Equações de projeção: retornam o respectivo campo do construtor
  eq id(livro(ID, Obra, T, A, Ano))     = ID . 
  eq obra(livro(ID, Obra, T, A, Ano))   = Obra . 
  eq titulo(livro(ID, Obra, T, A, Ano)) = T . 
  eq autor(livro(ID, Obra, T, A, Ano))  = A . 
  eq ano(livro(ID, Obra, T, A, Ano))    = Ano . 

  -- Predicado de validação: um livro é válido se título e autor não forem vazios e o ano for positivo
  eq valido?(livro(ID, Obra, T, A, Ano)) = (T =/= "") and (A =/= "") and (Ano > 0) .
}

provide livro
