*** Settings ***
Documentation    Arquivo responsável pelas configurações iniciais do ambiente de execução.
Resource         base.resource
Variables        config/config.yaml


*** Keywords ***
Set Execution Environment
    [Documentation]    Define o ambiente de execução: PROD ou HML.
    ...                Prioriza variável de ambiente; usa config.yaml como fallback.
    ${execution_environment}=    Get Environment Variable
    ...    EXECUTION_ENVIRONMENT
    ...    default=${CONFIG}[DEFAULT][EXECUTION_ENVIRONMENT]
    Set Global Variable    ${EXECUTION_ENVIRONMENT}    ${execution_environment}

Set Base URL
    [Documentation]    Define a URL base de acordo com o ambiente de execução.
    ${base_url}=    Get Environment Variable
    ...    BASE_URL
    ...    default=${CONFIG}[${EXECUTION_ENVIRONMENT}][BASE_URL]
    Set Global Variable    ${BASE_URL}    ${base_url}
