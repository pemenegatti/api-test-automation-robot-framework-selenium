*** Settings ***
Resource         ../resources/common.resource
Suite Setup      Setup Test Environment
Suite Teardown   Desconectar a api


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na ServeRest
    [Documentation]    Esse teste realizado o cadastro de um novo usuário na api ServeRest
    [Tags]             regressivo    smoke    cadastro
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Conferir se o usuário foi cadastrado corretamente

Cenário 02: Cadastrar um usuário já existente
    [Documentation]    Esse teste realizado o cadastro de um usuário ja existente
    [Tags]             regressivo    smoke    cadastro
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Vou repetir o cadastro do usuário
    Verificar se a API não permitiu o cadastro repetido

Cenário 03: Consultar os dados de um novo usuário
    [Documentation]    Esse teste realizado a consulta de dadis de um usuário
    [Tags]             regressivo    smoke    cadastro    consultar
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Consultar os dados do novo usuário
    Conferir os dados retornados