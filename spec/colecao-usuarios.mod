in usuario.mod
in identificadores.mod

mod! COLECAO-USUARIOS {
    protecting(USUARIO)
    protecting(STRING)
    protecting(IDENTIFICADORES)

    -- Relação de subsort: todo usuário é um conjunto unitário de usuários
    [ Usuario < ConjuntoUsuarios ]

    -- Elemento neutro (conjunto vazio)
    op vazioUsuarios : -> ConjuntoUsuarios { constr }

    -- Operador construtor de união de conjuntos
    op __ : ConjuntoUsuarios ConjuntoUsuarios -> ConjuntoUsuarios { constr assoc comm id: vazioUsuarios }

    vars U U2 : Usuario
    var  US   : ConjuntoUsuarios
    vars ID, ID2 : UsuarioId
    vars N N2 E E2 : String

    -- Axioma de idempotência
    eq U U = U .

    -- Predicado de pertinência
    pred pertence? : UsuarioId ConjuntoUsuarios
    eq pertence?(ID, vazioUsuarios) = false .
    eq pertence?(ID, usuario(ID, N, E) US) = true .
    ceq pertence?(ID, usuario(ID2, N2, E2) US) = pertence?(ID, US) if ID =/= ID2 .

    -- Operador de remoção de um usuário do conjunto
    op removerUsuario : UsuarioId ConjuntoUsuarios -> ConjuntoUsuarios
    eq removerUsuario(ID, vazioUsuarios) = vazioUsuarios .
    eq removerUsuario(ID, usuario(ID, N, E) US) = US .
    ceq removerUsuario(ID, usuario(ID2, N2, E2) US) = usuario(ID2, N2, E2) removerUsuario(ID, US) if ID =/= ID2 .  

    -- Consulta: Quantidade de usuários cadastrados
    op qtdUsuarios : ConjuntoUsuarios -> Nat
    eq qtdUsuarios(vazioUsuarios) = 0 .
    eq qtdUsuarios(usuario(ID, N, E) US) = 1 + qtdUsuarios(US) .
}