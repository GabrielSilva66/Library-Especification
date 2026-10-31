require usuario usuario.mod

mod! COLECAO-USUARIOS {
    protecting(USUARIO)
    protecting(STRING)
    protecting(IDENTIFICADORES)

    -- Multiconjunto: todo usuário é uma coleção unitária de usuários.
    [ Usuario < ConjuntoUsuarios ]

    -- Construtores do Monóide (coleção comutativa com elemento neutro)
    op vazioUsuarios : -> ConjuntoUsuarios { constr }
    op __ : ConjuntoUsuarios ConjuntoUsuarios -> ConjuntoUsuarios { constr assoc comm id: vazioUsuarios }

    -- Modificadores
    op iniciarColecao : -> ConjuntoUsuarios
    op adicionarUsuario : Usuario ConjuntoUsuarios -> ConjuntoUsuarios
    op removerUsuario : UsuarioId ConjuntoUsuarios -> ConjuntoUsuarios

    -- Consultas
    op qtdUsuarios : ConjuntoUsuarios -> Nat

    -- Predicados
    pred pertence? : UsuarioId ConjuntoUsuarios
    pred idsUnicos? : ConjuntoUsuarios
    pred todosValidos? : ConjuntoUsuarios

    -- Variáveis usadas nas equações
    var  US   : ConjuntoUsuarios
    var U    : Usuario
    var ID   : UsuarioId
    vars N N2 E E2 : String

    -- Construtor de coleção vazia
    eq iniciarColecao = vazioUsuarios .

    -- Adiciona um usuário à coleção, sem duplicatas
    eq adicionarUsuario(U, US) = 
        if not(pertence?(id(U), US)) and valido?(U)
        then U US  
        else US
        fi .

    -- Remove todas as ocorrências do ID, inclusive com atributos diferentes.
    eq removerUsuario(ID, vazioUsuarios) = vazioUsuarios .
    eq removerUsuario(ID, U US) = 
        if ID == id(U) 
        then removerUsuario(ID, US) 
        else U removerUsuario(ID, US) 
        fi .

    
    -- Consulta a quantidade de usuários cadastrados
    eq qtdUsuarios(vazioUsuarios) = 0 .
    eq qtdUsuarios(U US) = 1 + qtdUsuarios(US) .

    -- Predicado de pertinência
    eq pertence?(ID, vazioUsuarios) = false .
    eq pertence?(ID, U US) = 
        if ID == id(U) 
        then true 
        else pertence?(ID, US) 
        fi .

    -- Predicado que verifica se todos os IDs são únicos
    eq idsUnicos?(vazioUsuarios) = true .
    eq idsUnicos?(U US) = 
        if pertence?(id(U), US)
        then false
        else idsUnicos?(US)
        fi .

    eq todosValidos?(vazioUsuarios) = true .
    eq todosValidos?(U US) = 
        if valido?(U)
        then todosValidos?(US)
        else false
        fi .
}

provide colecao-usuarios
