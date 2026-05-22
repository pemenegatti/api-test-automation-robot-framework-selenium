*** Settings ***
Documentation    Keywords de requisições HTTP para o recurso /usuarios da API ServeRest.
Resource         ../base.resource


*** Variables ***
${USUARIOS_ENDPOINT}    /usuarios


*** Keywords ***
# ──────────────────────────────────────────────
#  FACTORIES / BUILDERS
# ──────────────────────────────────────────────

Gerar Email Aleatório
    [Documentation]    Gera um e-mail único usando sufixo aleatório de 8 letras.
    ...                8 chars = 26^8 combinações, eliminando risco de colisão em paralelo.
    ...                Armazena o resultado em ${EMAIL_TESTE} (escopo de teste).
    ${sufixo}=         Generate Random String    length=8    chars=[LETTERS]
    ${sufixo}=         Convert To Lower Case     ${sufixo}
    ${email}=          Set Variable              ${sufixo}@${USUARIOS}[DOMINIO_EMAIL]
    Set Test Variable  ${EMAIL_TESTE}            ${email}

Montar Body De Usuário
    [Documentation]    Retorna um dicionário com os dados padrão de um usuário.
    ...                Aceita sobrescrita de qualquer campo via argumentos nomeados.
    [Arguments]
    ...    ${nome}=${USUARIOS}[NOME_PADRAO]
    ...    ${email}=${EMAIL_TESTE}
    ...    ${password}=${USUARIOS}[PASSWORD_PADRAO]
    ...    ${administrador}=${USUARIOS}[ADMINISTRADOR]
    ${body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    RETURN    ${body}


# ──────────────────────────────────────────────
#  AÇÕES (POST / GET / PUT / DELETE)
# ──────────────────────────────────────────────

Cadastrar Usuário Via API
    [Documentation]    Envia POST /usuarios e armazena a resposta em ${RESPOSTA}.
    ...                Salva ${ID_USUARIO} quando o status retornado for 201.
    ...                Reutiliza a sessão ServeRest criada no Suite Setup.
    [Arguments]    ${email}=${EMAIL_TESTE}    ${status_code_esperado}=201
    ${body}=        Montar Body De Usuário    email=${email}
    ${resposta}=    POST On Session
    ...    alias=ServeRest
    ...    url=${USUARIOS_ENDPOINT}
    ...    json=${body}
    ...    expected_status=${status_code_esperado}
    IF    ${resposta.status_code} == 201
        Set Test Variable    ${ID_USUARIO}    ${resposta.json()["_id"]}
    END
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Consultar Usuário Por ID Via API
    [Documentation]    Envia GET /usuarios/{id}.
    ...                Armazena a resposta em ${RESP_CONSULTA} e ${RESPOSTA}.
    [Arguments]    ${id}=${ID_USUARIO}    ${status_code_esperado}=200
    ${resposta}=    GET On Session
    ...    alias=ServeRest
    ...    url=${USUARIOS_ENDPOINT}/${id}
    ...    expected_status=${status_code_esperado}
    Set Test Variable    ${RESP_CONSULTA}    ${resposta.json()}
    Set Test Variable    ${RESPOSTA}         ${resposta.json()}

Listar Usuários Via API
    [Documentation]    Envia GET /usuarios e armazena a resposta em ${RESP_LISTA}.
    [Arguments]    ${status_code_esperado}=200
    ${resposta}=    GET On Session
    ...    alias=ServeRest
    ...    url=${USUARIOS_ENDPOINT}
    ...    expected_status=${status_code_esperado}
    Set Test Variable    ${RESP_LISTA}    ${resposta.json()}

Atualizar Usuário Via API
    [Documentation]    Envia PUT /usuarios/{id} com os dados fornecidos.
    [Arguments]
    ...    ${id}=${ID_USUARIO}
    ...    ${nome}=${USUARIOS}[NOME_PADRAO]
    ...    ${email}=${EMAIL_TESTE}
    ...    ${password}=${USUARIOS}[PASSWORD_PADRAO]
    ...    ${administrador}=${USUARIOS}[ADMINISTRADOR]
    ...    ${status_code_esperado}=200
    ${body}=        Montar Body De Usuário
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    ${resposta}=    PUT On Session
    ...    alias=ServeRest
    ...    url=${USUARIOS_ENDPOINT}/${id}
    ...    json=${body}
    ...    expected_status=${status_code_esperado}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Excluir Usuário Via API
    [Documentation]    Envia DELETE /usuarios/{id}.
    [Arguments]    ${id}=${ID_USUARIO}    ${status_code_esperado}=200
    ${resposta}=    DELETE On Session
    ...    alias=ServeRest
    ...    url=${USUARIOS_ENDPOINT}/${id}
    ...    expected_status=${status_code_esperado}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}


# ──────────────────────────────────────────────
#  ASSERÇÕES
# ──────────────────────────────────────────────

Validar Cadastro Realizado Com Sucesso
    [Documentation]    Verifica mensagem de sucesso e presença do _id na resposta.
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${RESPOSTA}    _id

Validar Email Já Cadastrado
    [Documentation]    Verifica que a API rejeitou e-mail duplicado.
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Validar Dados Do Usuário Consultado
    [Documentation]    Confirma que os dados retornados pelo GET correspondem ao cadastro.
    ...                Recebe a resposta como argumento para evitar dependência implícita de escopo.
    [Arguments]
    ...    ${resposta}=${RESP_CONSULTA}
    ...    ${nome}=${USUARIOS}[NOME_PADRAO]
    ...    ${email}=${EMAIL_TESTE}
    ...    ${password}=${USUARIOS}[PASSWORD_PADRAO]
    ...    ${administrador}=${USUARIOS}[ADMINISTRADOR]
    Dictionary Should Contain Item    ${resposta}    nome           ${nome}
    Dictionary Should Contain Item    ${resposta}    email          ${email}
    Dictionary Should Contain Item    ${resposta}    password       ${password}
    Dictionary Should Contain Item    ${resposta}    administrador  ${administrador}
    Dictionary Should Contain Item    ${resposta}    _id            ${ID_USUARIO}

Validar Atualização Realizada Com Sucesso
    [Documentation]    Verifica mensagem de sucesso na atualização.
    Dictionary Should Contain Item    ${RESPOSTA}    message    Registro alterado com sucesso

Validar Exclusão Realizada Com Sucesso
    [Documentation]    Verifica mensagem de sucesso na exclusão.
    Dictionary Should Contain Item    ${RESPOSTA}    message    Registro excluído com sucesso

Validar Lista De Usuários Não Está Vazia
    [Documentation]    Verifica que a listagem retornou ao menos um usuário.
    ${quantidade}=    Get From Dictionary    ${RESP_LISTA}    quantidade
    Should Be True    ${quantidade} > 0

Validar Campos Obrigatórios Ausentes
    [Documentation]    Verifica que a API retornou erros de validação para todos os campos obrigatórios.
    [Arguments]    ${resposta}
    Dictionary Should Contain Key    ${resposta}    nome
    Dictionary Should Contain Key    ${resposta}    email
    Dictionary Should Contain Key    ${resposta}    password
    Dictionary Should Contain Key    ${resposta}    administrador

Validar Usuário Não Encontrado
    [Documentation]    Verifica mensagem de usuário não encontrado (status 400).
    Dictionary Should Contain Item    ${RESPOSTA}    message    Usuário não encontrado
