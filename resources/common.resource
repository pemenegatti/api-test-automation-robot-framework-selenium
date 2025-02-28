*** Settings ***
Documentation  Arquivo responsavel pelo compartilhamentos de resources
Library        RequestsLibrary
Library        SeleniumLibrary
Library        FakerLibrary
Library        String
Library        Collections
Resource       config.resource
Resource       ../resources/requests/api_testing_usuarios.resource