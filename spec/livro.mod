-- ============================================================
-- livro.mod: Especificação da entidade Livro
-- ============================================================

mod! LIVRO {
  protecting(IDENTIFICADORES)
  protecting(STRING)
  protecting(NAT)
  protecting(BOOL)

  -- Sort principal da entidade
  [ Livro ]
  
  -- Construtor: cria um Livro a partir de (ID, Título, Autor, Ano)
  op livro : LivroId String String Nat -> Livro { constr }

  -- Projeções (Getters): extraem os atributos de um Livro
  op id     : Livro -> LivroId
  op titulo : Livro -> String
  op autor  : Livro -> String
  op ano    : Livro -> Nat

  -- Predicado de validação: verifica se os dados do livro são válidos
  op valido? : Livro -> Bool

  -- Variáveis usadas nas equações
  var ID : LivroId
  vars T A : String
  var Ano : Nat

  -- Equações de projeção: retornam o respectivo campo do construtor
  eq id(livro(ID, T, A, Ano))     = ID . 
  eq titulo(livro(ID, T, A, Ano)) = T . 
  eq autor(livro(ID, T, A, Ano))  = A . 
  eq ano(livro(ID, T, A, Ano))    = Ano . 

  -- Um livro é válido se título e autor não forem vazios e o ano for positivo
  eq valido?(livro(ID, T, A, Ano)) = (T =/= "") and (A =/= "") and (Ano > 0) .
}
