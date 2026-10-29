require usuario usuario.mod

mod! COLECAO-USUARIOS {
    protecting(USUARIO)
    protecting(STRING)
    protecting(IDENTIFICADORES)

    -- Multiconjunto: todo usuário é uma coleção unitária de usuários.
    [ Usuario < ConjuntoUsuarios ]

    -- Elemento neutro (conjunto vazio)
    op vazioUsuarios : -> ConjuntoUsuarios { constr }

    -- União de multiconjuntos: repetições são preservadas pela contagem.
    op __ : ConjuntoUsuarios ConjuntoUsuarios -> ConjuntoUsuarios { constr assoc comm id: vazioUsuarios }

    var  US   : ConjuntoUsuarios
    vars ID ID2 : UsuarioId
    vars N N2 E E2 : String

    -- Sem idempotência: U U tem duas ocorrências, coerentemente com qtdUsuarios.

    -- Predicado de pertinência
    pred pertence? : UsuarioId ConjuntoUsuarios
    eq pertence?(ID, vazioUsuarios) = false .
    eq pertence?(ID, usuario(ID, N, E) US) = true .
    ceq pertence?(ID, usuario(ID2, N2, E2) US) = pertence?(ID, US) if ID =/= ID2 .

    -- Remove todas as ocorrências do ID, inclusive com atributos diferentes.
    op removerUsuario : UsuarioId ConjuntoUsuarios -> ConjuntoUsuarios
    eq removerUsuario(ID, vazioUsuarios) = vazioUsuarios .
    eq removerUsuario(ID, usuario(ID, N, E) US) = removerUsuario(ID, US) .
    ceq removerUsuario(ID, usuario(ID2, N2, E2) US) = usuario(ID2, N2, E2) removerUsuario(ID, US) if ID =/= ID2 .  

    -- Consulta: Quantidade de usuários cadastrados
    op qtdUsuarios : ConjuntoUsuarios -> Nat
    eq qtdUsuarios(vazioUsuarios) = 0 .
    eq qtdUsuarios(usuario(ID, N, E) US) = 1 + qtdUsuarios(US) .
}

provide colecao-usuarios
