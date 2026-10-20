in identificadores.mod


mod! ACERVO {
  protecting(NAT)
  protecting(BOOL)
  protecting(IDENTIFICADORES)

  [ Acervo ]

  -- Construtores do Monóide
  op vazioAcervo : -> Acervo { constr }
  op [livro_] : LivroId -> Acervo { constr }
  op __ : Acervo Acervo -> Acervo { constr assoc comm id: vazioAcervo }

  -- Observadores
  op pertenceAcervo? : LivroId Acervo -> Bool
  op qtdAcervo : Acervo -> Nat

  vars L L' : LivroId
  var A : Acervo

  eq pertenceAcervo?(L, vazioAcervo) = false .
  eq pertenceAcervo?(L, [livro L'] A) = (L = L') or pertenceAcervo?(L, A) .

  eq qtdAcervo(vazioAcervo) = 0 .
  eq qtdAcervo([livro L] A) = 1 + qtdAcervo(A) .
}
