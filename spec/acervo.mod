-- ============================================================
-- acervo.mod: Coleção de livros (Acervo) modelada como Monóide
-- ============================================================
require livro livro.mod

mod! ACERVO {
  protecting(NAT)
  protecting(BOOL)
  protecting(LIVRO)

  -- LivroOuErro é supersort de Livro para retorno seguro em buscas que falham
  [ Livro < LivroOuErro ]

  -- Injeção por Subsort: todo Livro é um Acervo unitário 
  [ Livro < Acervo ]

  -- Construtor de erro: retornado quando o livro não é encontrado
  op livroInexistente : -> LivroOuErro { constr }
  op livroDuplicado : -> LivroOuErro { constr }

  -- Construtores do Monóide (coleção comutativa com elemento neutro)
  op vazioAcervo : -> Acervo { constr }
  op __          : Acervo Acervo -> Acervo { constr assoc comm id: vazioAcervo }

  -- Operadores Observadores e Consultas
  op pertenceAcervo?   : LivroId Acervo -> Bool
  op buscarLivro       : LivroId Acervo -> LivroOuErro
  -- Busca em duas etapas: filtra pelo ID e distingue zero, um ou varios resultados.
  op filtrarId         : LivroId Acervo -> Acervo
  op resultadoBusca    : Acervo -> LivroOuErro
  op buscarTitulo      : String Acervo -> Acervo 
  op qtdAcervo         : Acervo -> Nat
  op qtdExemplaresObra : ObraId Acervo -> Nat
  op tituloDeAutor     : String Acervo -> Acervo

  -- Operações sobre o Acervo
  op removerDoAcervo   : LivroId Acervo -> Acervo

  -- Predicados de Integridade e Validade
  op idsUnicos?        : Acervo -> Bool
  op todosValidos?     : Acervo -> Bool

  -- Variáveis usadas nas equações
  var ID : LivroId
  var O : ObraId
  vars L L' : Livro
  var A : Acervo
  var T : String

  -- Verificação de pertinência: busca pelo ID do livro no acervo
  eq pertenceAcervo?(ID, vazioAcervo) = false .
  eq pertenceAcervo?(ID, L A)         = (ID == id(L)) or pertenceAcervo?(ID, A) .

  -- Numa coleção comutativa não existe um "primeiro" livro com o ID.
  -- Duplicidades, inclusive de exemplares identicos, retornam erro explicito.
  eq buscarLivro(ID, A) = resultadoBusca(filtrarId(ID, A)) .
  eq filtrarId(ID, vazioAcervo) = vazioAcervo .
  eq filtrarId(ID, L A) =
    if ID == id(L) then L filtrarId(ID, A) else filtrarId(ID, A) fi .
  eq resultadoBusca(vazioAcervo) = livroInexistente .
  eq resultadoBusca(L) = L .
  eq resultadoBusca(L L' A) = livroDuplicado .

  -- Quantidade total de livros no acervo (cardinalidade da coleção)
  eq qtdAcervo(vazioAcervo) = 0 .
  eq qtdAcervo(L A)         = 1 + qtdAcervo(A) .

  -- Quantidade total de exemplares de uma obra específica
  eq qtdExemplaresObra(O, vazioAcervo) = 0 .
  eq qtdExemplaresObra(O, L A) =
    if O == obra(L)
    then 1 + qtdExemplaresObra(O, A)
    else qtdExemplaresObra(O, A) 
    fi .

  -- Filtro por título: retorna um sub-acervo apenas com os livros do título informado
  eq buscarTitulo(T, vazioAcervo) = vazioAcervo .
  eq buscarTitulo(T, L A) =
    if T == titulo(L) 
    then L buscarTitulo(T, A)
    else buscarTitulo(T, A)
    fi .

  -- Filtro por autor: retorna um sub-acervo apenas com os livros do autor informado
  eq tituloDeAutor(T, vazioAcervo) = vazioAcervo .
  eq tituloDeAutor(T, L A) = 
    if T == autor(L) 
    then L tituloDeAutor(T, A) 
    else tituloDeAutor(T, A)
    fi .

  -- Remove todas as ocorrencias do ID, sem depender da ordem de casamento.
  -- Se o ID nao existe, mantem o acervo inalterado.
  eq removerDoAcervo(ID, vazioAcervo) = vazioAcervo .
  eq removerDoAcervo(ID, L A) =
    if ID == id(L)
    then removerDoAcervo(ID, A)
    else L removerDoAcervo(ID, A)
    fi .

  -- Verificação de unicidade dos identificadores de livros
  eq idsUnicos?(vazioAcervo) = true .
  eq idsUnicos?(L A)         = not(pertenceAcervo?(id(L), A)) and idsUnicos?(A) .

  -- Verificação de que todos os livros cadastrados atendem ao predicado valido?
  eq todosValidos?(vazioAcervo) = true .
  eq todosValidos?(L A)         = valido?(L) and todosValidos?(A) .
}

provide acervo
