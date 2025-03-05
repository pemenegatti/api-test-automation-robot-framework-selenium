<h1 align="center">QA - API Test Automation</h1>
<h1 align="center">
    <a href="<https://robotframework.org/>">Robot Framework 🤖</a>
</h1>
<p align="center">Este projeto consiste em uma suíte de testes automatizados desenvolvidos utilizando o Robot Framework</p>

### 🛠 Tecnologias
As seguintes ferramentas foram usadas na construção do projeto:
- [Python](<https://www.python.org/>)
- [Robot Framework](<https://robotframework.org/>)
- [Bibliotecas do Robot Framework (As bibliotecas específicas variam conforme os testes. Consulte a documentação para mais informações sobre instalação de bibliotecas.)]

### 📋 Pré-requisitos.
Antes de começar, certifique-se de ter os seguintes requisitos atendidos:
- Python instalado na máquina.
- Robot Framework instalado.
- Para usuários de Mac ou Linux, é necessário que a chave SSH esteja configurada para clonar o repositório: 
    - [Gerar Chave SSH](<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>) 
    - [Adicionar Chave SSH no GitHub](<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>)

<!-- ### Para usuarios de Mac que estejam com dificuldades para executar os comandos pip ou python adicionar as linha no final do arquivo ~/.bashrc ou ~/.zshrc
```bash
- alias pip="pip3"
```
```bash
- alias python="python3"
```
- após adicionar as linhas acimas executar o seguinte comando no seu terminal (source ~/.bashrc ou source ~/.zshrc) -->
### 🚀 Como executar
### 1 Clone este repositório.
```bash
git clone git@github.com:pemenegatti/api-test-automation-robot-framework-selenium.git
```

### 2 Acesse a pasta do projeto.
```bash
cd api-test-automation-robot-framework-selenium
```

### 3 Instale os requisitos do projeto.
Para usuários de Bash:
```bash
bash setup.sh 
```
Para usuários de Zsh:
```bash
zsh setup.sh 
```

### 4 Execute os cenários automatizados
```bash
robot tests
```

### 🗂 Estrutura de branchs:
As seguintes branchs são utilizadas neste projeto:
- main: Branch principal. Utilizada para rodar os testes regressivos.
- develop: Branch de desenvolvimento. Todas as novas branchs devem ser criadas a partir dela.
- feature/nome-do-cenario: Branch para criação de novos cenários. Use este padrão de nomenclatura para identificar o cenário.
- fix/nome-da-alteracao: Branch para correções ou alterações de cenários/configurações. Siga este padrão de nomenclatura.

### 🏷 Tags de cenários:
As seguintes tags podem ser usadas para executar cenários específicos:
- regressivo: Executa todos os cenários automatizados.
- smoke: Executa os principais cenários automatizados.
