-- ============================================================
-- acervo.mod: Coleção de livros (Acervo) modelada como Monóide
-- ============================================================
in identificadores.mod
in livro.mod

mod! ACERVO {
  protecting(NAT)
  protecting(BOOL)
  protecting(LIVRO)

  -- LivroOuErro é supersort de Livro para retorno seguro em buscas que falham
  [ Livro < LivroOuErro ]
  [ Acervo ]

  -- Construtor de erro: retornado quando o livro não é encontrado
  op livroInexistente : -> LivroOuErro { constr }

  -- Construtores do Monóide (coleção comutativa com elemento neutro)
  op vazioAcervo : -> Acervo { constr }
  op [livro_]    : Livro -> Acervo { constr }
  op __          : Acervo Acervo -> Acervo { constr assoc comm id: vazioAcervo }

  -- Operadores Observadores e Consultas
  op pertenceAcervo? : LivroId Acervo -> Bool
  op buscarLivro     : LivroId Acervo -> LivroOuErro
  op buscarTitulo    : String Acervo -> Acervo 
  op qtdAcervo       : Acervo -> Nat
  op tituloDeAutor   : String Acervo -> Acervo

  -- Variáveis usadas nas equações
  var ID : LivroId
  vars L L' : Livro
  var A : Acervo
  var T : String

  -- Verificação de pertinência: busca pelo ID do livro no acervo
  eq pertenceAcervo?(ID, vazioAcervo) = false .
  eq pertenceAcervo?(ID, [livro L] A) = (ID == id(L)) or pertenceAcervo?(ID, A) .

  -- Busca por ID: retorna o Livro se encontrado, ou livroInexistente se vazio/não achado
  eq buscarLivro(ID, vazioAcervo) = livroInexistente .
  eq buscarLivro(ID, [livro L] A) = if ID == id(L) then L else buscarLivro(ID, A) fi .

  -- Quantidade total de livros no acervo (cardinalidade da coleção)
  eq qtdAcervo(vazioAcervo) = 0 .
  eq qtdAcervo([livro L] A) = 1 + qtdAcervo(A) .

  -- Filtro por título: retorna um sub-acervo apenas com os livros do título informado
  eq buscarTitulo(T, vazioAcervo) = vazioAcervo .
  eq buscarTitulo(T, [livro L] A) =
    if T == titulo(L) 
    then [livro L] buscarTitulo(T, A)
    else buscarTitulo(T, A)
    fi .

  -- Filtro por autor: retorna um sub-acervo apenas com os livros do autor informado
  eq tituloDeAutor(T, vazioAcervo) = vazioAcervo .
  eq tituloDeAutor(T, [livro L] A) = 
    if T == autor(L) 
    then [livro L] tituloDeAutor(T, A) 
    else tituloDeAutor(T, A)
    fi .
}
