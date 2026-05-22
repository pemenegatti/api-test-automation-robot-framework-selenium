*** Settings ***
Documentation    Suite de testes para o recurso /usuarios da API ServeRest.
...              Cobre os fluxos de cadastro, consulta, atualização e exclusão.
Resource         ../resources/base.resource
Suite Setup      Setup Test Environment
Suite Teardown   Teardown Test Environment


*** Test Cases ***
# ──────────────────────────────────────────────
#  CADASTRO (POST /usuarios)
# ──────────────────────────────────────────────

CT-001: Cadastrar um novo usuário com sucesso
    [Documentation]    Verifica que um usuário válido é criado com status 201
    ...                e que a resposta contém _id e mensagem de sucesso.
    [Tags]             regressivo    smoke    cadastro
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Validar Cadastro Realizado Com Sucesso

CT-002: Impedir cadastro com e-mail já existente
    [Documentation]    Verifica que a API retorna 400 ao tentar cadastrar
    ...                um e-mail que já está em uso.
    [Tags]             regressivo    smoke    cadastro    negativo
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Cadastrar Usuário Via API    status_code_esperado=400
    Validar Email Já Cadastrado

CT-003: Impedir cadastro com body vazio
    [Documentation]    Verifica que a API retorna 400 com erros de validação por campo
    ...                quando o body enviado está vazio.
    [Tags]             regressivo    cadastro    negativo
    ${body}=        Create Dictionary
    ${resposta}=    POST On Session
    ...    alias=ServeRest
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=400
    Validar Campos Obrigatórios Ausentes    ${resposta.json()}


# ──────────────────────────────────────────────
#  CONSULTA (GET /usuarios)
# ──────────────────────────────────────────────

CT-004: Consultar dados de um usuário cadastrado
    [Documentation]    Verifica que o GET /usuarios/{id} retorna os dados
    ...                exatamente como foram enviados no cadastro.
    [Tags]             regressivo    smoke    consulta
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Consultar Usuário Por ID Via API
    Validar Dados Do Usuário Consultado

CT-005: Consultar usuário com ID inexistente
    [Documentation]    Verifica que a API retorna 400 para um ID válido (16 chars)
    ...                que não corresponde a nenhum usuário cadastrado.
    [Tags]             regressivo    consulta    negativo
    Consultar Usuário Por ID Via API    id=aaaaaaaaaaaaaaaa    status_code_esperado=400
    Validar Usuário Não Encontrado

CT-006: Listar todos os usuários cadastrados
    [Documentation]    Verifica que o GET /usuarios retorna ao menos um registro.
    [Tags]             regressivo    consulta
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Listar Usuários Via API
    Validar Lista De Usuários Não Está Vazia


# ──────────────────────────────────────────────
#  ATUALIZAÇÃO (PUT /usuarios)
# ──────────────────────────────────────────────

CT-007: Atualizar dados de um usuário com sucesso
    [Documentation]    Verifica que o PUT /usuarios/{id} atualiza o registro
    ...                e retorna mensagem de sucesso.
    [Tags]             regressivo    atualizacao
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Gerar Email Aleatório
    Atualizar Usuário Via API    nome=Ciclano Atualizado    status_code_esperado=200
    Validar Atualização Realizada Com Sucesso

CT-008: Impedir atualização com e-mail já utilizado por outro usuário
    [Documentation]    Verifica que a API retorna 400 ao tentar atualizar
    ...                um usuário com e-mail pertencente a outro cadastro.
    [Tags]             regressivo    atualizacao    negativo
    # Cadastra o primeiro usuário e guarda o e-mail
    Gerar Email Aleatório
    ${email_usuario_1}=    Set Variable    ${EMAIL_TESTE}
    Cadastrar Usuário Via API    status_code_esperado=201

    # Cadastra o segundo usuário
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201

    # Tenta atualizar o segundo com o e-mail do primeiro
    Atualizar Usuário Via API
    ...    id=${ID_USUARIO}
    ...    email=${email_usuario_1}
    ...    status_code_esperado=400
    Validar Email Já Cadastrado


# ──────────────────────────────────────────────
#  EXCLUSÃO (DELETE /usuarios)
# ──────────────────────────────────────────────

CT-009: Excluir um usuário com sucesso
    [Documentation]    Verifica que o DELETE /usuarios/{id} remove o registro
    ...                e retorna mensagem de sucesso.
    [Tags]             regressivo    exclusao
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    Excluir Usuário Via API
    Validar Exclusão Realizada Com Sucesso

CT-010: Consultar usuário após exclusão retorna erro
    [Documentation]    Verifica que após a exclusão o GET retorna 400.
    [Tags]             regressivo    exclusao    negativo
    Gerar Email Aleatório
    Cadastrar Usuário Via API    status_code_esperado=201
    ${id_excluido}=    Set Variable    ${ID_USUARIO}
    Excluir Usuário Via API
    Consultar Usuário Por ID Via API    id=${id_excluido}    status_code_esperado=400
    Validar Usuário Não Encontrado
