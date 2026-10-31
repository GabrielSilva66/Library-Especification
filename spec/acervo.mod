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

  -- Modificadores
  op iniciarAcervo     : -> Acervo
  op adicionarLivro : Livro Acervo -> Acervo
  op removerDoAcervo   : LivroId Acervo -> Acervo

  -- Consultas
  op buscarLivro       : LivroId Acervo -> LivroOuErro
  op filtrarId         : LivroId Acervo -> Acervo
  op resultadoBusca    : Acervo -> LivroOuErro
  op buscarTitulo      : String Acervo -> Acervo 
  op qtdAcervo         : Acervo -> Nat
  op qtdExemplaresObra : ObraId Acervo -> Nat
  op tituloDeAutor     : String Acervo -> Acervo

  -- Predicados
  pred pertenceAcervo?   : LivroId Acervo
  pred idsUnicos?        : Acervo
  pred todosValidos?     : Acervo

  -- Variáveis usadas nas equações
  var ID : LivroId
  var O : ObraId
  vars L L' : Livro
  var A : Acervo
  var T : String

  -- Construtor de coleção vazia
  eq iniciarAcervo = vazioAcervo .

  -- Adiciona um livro ao acervo, sem duplicatas
  eq adicionarLivro(L, A) = 
    if not(pertenceAcervo?(id(L), A)) and valido?(L) 
    then L A
    else A
    fi .

  -- Remove todas as ocorrências do ID, sem depender da ordem de casamento.
  eq removerDoAcervo(ID, vazioAcervo) = vazioAcervo .
  eq removerDoAcervo(ID, L A) =
    if ID == id(L)
    then removerDoAcervo(ID, A)
    else L removerDoAcervo(ID, A)
    fi .

  -- Consulta um livro pelo seu ID, retornando um LivroOuErro
  eq buscarLivro(ID, A) = resultadoBusca(filtrarId(ID, A)) .

  -- Filtro por ID: retorna um sub-acervo apenas com os livros do ID informado
  eq filtrarId(ID, vazioAcervo) = vazioAcervo .
  eq filtrarId(ID, L A) =
    if ID == id(L) 
    then L filtrarId(ID, A) 
    else filtrarId(ID, A) 
    fi .
  
  -- Retorna erro se o acervo filtrado estiver vazio, ou erro de duplicidade se houver mais de um livro com o mesmo ID.
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

  -- Predicado de pertinência: busca pelo ID do livro no acervo
  eq pertenceAcervo?(ID, vazioAcervo) = false .
  eq pertenceAcervo?(ID, L A) =
    if ID == id(L)
    then true
    else pertenceAcervo?(ID, A) 
    fi .

  -- Predicado de unicidade dos identificadores de livros
  eq idsUnicos?(vazioAcervo) = true .
  eq idsUnicos?(L A) = 
    if pertenceAcervo?(id(L), A)
    then false
    else idsUnicos?(A) 
    fi .

  -- Predicado de que todos os livros cadastrados são válidos
  eq todosValidos?(vazioAcervo) = true .
  eq todosValidos?(L A) = 
    if not(valido?(L)) 
    then false
    else todosValidos?(A) 
    fi .
}

provide acervo
