*** Settings ***
Documentation    Ponto de entrada único do projeto. Centraliza todas as libraries,
...              resources e variáveis utilizadas nas suites de teste.
...              Os arquivos de teste importam apenas este arquivo.
Library          RequestsLibrary
Library          OperatingSystem
Library          String
Library          Collections
Resource         config.resource
Resource         ../resources/requests/api_testing_usuarios.resource


*** Keywords ***
Criar Sessão Na ServeRest
    [Documentation]    Cria uma sessão HTTP reutilizável apontando para ${BASE_URL}.
    ...                Chamada uma única vez no Suite Setup via Setup Test Environment.
    ...                disable_warnings=1 suprime os InsecureRequestWarning do urllib3.
    ${headers}=    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    Create Session
    ...    alias=ServeRest
    ...    url=${BASE_URL}
    ...    headers=${headers}
    ...    disable_warnings=1

Setup Test Environment
    [Documentation]    Keyword de setup da suite: configura ambiente, URL base
    ...                e cria a sessão HTTP reutilizável para todos os testes.
    Set Execution Environment
    Set Base URL
    Criar Sessão Na ServeRest

Teardown Test Environment
    [Documentation]    Keyword de teardown da suite: encerra todas as sessões HTTP.
    Delete All Sessions
