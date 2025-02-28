*** Settings ***
Documentation    Arquivo responsavel pelas configurações iniciais.
Library          OperatingSystem
Resource         common.resource
Variables        config/config.yaml


*** Keywords ***
Set Execution Environment
    [Documentation]    Set the execution environment to production PROD or homologation HML

    ${execution_environment}=    Get Environment Variable    EXECUTION_ENVIRONMENT    default=${CONFIG}[DEFAULT][EXECUTION_ENVIRONMENT]
    Set Global Variable    ${EXECUTION_ENVIRONMENT}    ${execution_environment}

Set Base URL
    [Documentation]    Set the base URL for the system

    ${base_url}=    Get Environment Variable    BASE_URL    default=${CONFIG}[${EXECUTION_ENVIRONMENT}][BASE_URL]
    Set Global Variable    ${BASE_URL}    ${base_url}

Setup Test Environment
    Set Execution Environment
    Set Base URL

Desconectar a api
    [Documentation]    Encerra a sessão
    Delete All Sessions

