<h1 align="center">QA — API Test Automation</h1>

<p align="center">
  <a href="https://robotframework.org/">
    <img src="https://img.shields.io/badge/Robot%20Framework-6.1.1-black?logo=robot-framework" alt="Robot Framework"/>
  </a>
  <a href="https://www.python.org/">
    <img src="https://img.shields.io/badge/Python-3.11-blue?logo=python" alt="Python"/>
  </a>
  <img src="https://img.shields.io/badge/API-ServeRest-green" alt="ServeRest"/>
</p>

<p align="center">Suíte de testes automatizados de API REST desenvolvida com Robot Framework, cobrindo os fluxos de cadastro, consulta, atualização e exclusão de usuários na API <a href="https://serverest.dev">ServeRest</a>.</p>

---

## 🛠 Tecnologias

| Ferramenta | Versão | Finalidade |
|---|---|---|
| [Python](https://www.python.org/) | 3.11 | Runtime |
| [Robot Framework](https://robotframework.org/) | 6.1.1 | Framework de testes |
| [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests) | 0.9.7 | Requisições HTTP |
| [Pabot](https://github.com/mkorpela/pabot) | 2.18.0 | Execução paralela |
| [PyYAML](https://pyyaml.org/) | 6.0.1 | Leitura de configuração |

---

## 📋 Pré-requisitos

- Python 3.11+
- `make` instalado (nativo em macOS e Linux)
- Chave SSH configurada para clonar o repositório:
  - [Gerar chave SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
  - [Adicionar chave SSH no GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

---

## 🚀 Como executar

### 1. Clone o repositório

```bash
git clone git@github.com:pemenegatti/api-test-automation-robot-framework-selenium.git
cd api-test-automation-robot-framework-selenium
```

### 2. Instale as dependências

```bash
make install
```

> Caso prefira usar o script de setup (adiciona aliases pip/python ao shell):
> ```bash
> make setup
> ```

### 3. Execute os testes

```bash
# Todos os testes — sequencial
make test

# Todos os testes — paralelo (4 processos)
make test-parallel

# Filtrado por tag
make test-tag TAG=smoke
```

### 4. Abra o relatório

```bash
make report
```

---

## ⚙️ Variáveis de ambiente

As variáveis abaixo podem ser passadas diretamente no comando `make` ou exportadas no shell:

| Variável | Padrão | Descrição |
|---|---|---|
| `ENV` | `HML` | Ambiente de execução (`HML` ou `PROD`) |
| `BASE_URL` | `https://serverest.dev` | URL base da API |
| `PABOT_PROCESSES` | `4` | Número de processos paralelos |

**Exemplos:**

```bash
make test ENV=PROD
make test-parallel PABOT_PROCESSES=8
make test ENV=PROD BASE_URL=https://minha-api.com
```

---

## 🏷 Tags disponíveis

| Tag | Descrição |
|---|---|
| `regressivo` | Todos os cenários automatizados |
| `smoke` | Cenários principais (caminho feliz) |
| `cadastro` | Testes de POST /usuarios |
| `consulta` | Testes de GET /usuarios |
| `atualizacao` | Testes de PUT /usuarios |
| `exclusao` | Testes de DELETE /usuarios |
| `negativo` | Cenários de erro e validação |

**Atalhos make:**

```bash
make smoke
make regressivo
make cadastro
make consulta
make atualizacao
make exclusao
```

---

## 🗂 Estrutura do projeto

```
.
├── resources/
│   ├── base.resource                        # Ponto de entrada único — todas as libraries e resources
│   ├── config.resource                      # Configuração de ambiente (PROD/HML) e URL base
│   ├── config/
│   │   └── config.yaml                      # URLs e dados padrão de teste
│   └── requests/
│       └── api_testing_usuarios.resource    # Keywords de requisição e asserção do recurso /usuarios
├── tests/
│   ├── api_testing_usuarios.robot           # Casos de teste
│   └── results/                             # Relatórios gerados (gitignored)
├── .github/
│   └── workflows/
│       └── pipeline.yaml                    # Pipeline CI/CD (GitHub Actions)
├── Makefile                                 # Comandos de automação
├── requirements.txt                         # Dependências Python
└── setup.sh                                 # Script de setup do ambiente local
```

---

## 🧪 Casos de teste

| ID | Verbo | Cenário | Tags |
|---|---|---|---|
| CT-001 | POST | Cadastrar novo usuário com sucesso | smoke, cadastro |
| CT-002 | POST | Impedir cadastro com e-mail duplicado | smoke, cadastro, negativo |
| CT-003 | POST | Impedir cadastro com body vazio | cadastro, negativo |
| CT-004 | GET | Consultar dados de usuário cadastrado | smoke, consulta |
| CT-005 | GET | Consultar usuário com ID inexistente | consulta, negativo |
| CT-006 | GET | Listar todos os usuários | consulta |
| CT-007 | PUT | Atualizar dados de usuário com sucesso | atualizacao |
| CT-008 | PUT | Impedir atualização com e-mail de outro usuário | atualizacao, negativo |
| CT-009 | DELETE | Excluir usuário com sucesso | exclusao |
| CT-010 | DELETE | Consultar usuário após exclusão retorna erro | exclusao, negativo |

---

## 🌿 Estratégia de branches

| Branch | Finalidade |
|---|---|
| `master` | Branch principal — dispara o pipeline de regressão |
| `develop` | Base para novas branches de desenvolvimento |
| `feature/<nome>` | Novos cenários ou funcionalidades |
| `fix/<nome>` | Correções de cenários ou configurações |

---

## 🔁 Pipeline CI/CD

O pipeline é executado automaticamente a cada push na `master` e pode ser disparado manualmente via **workflow_dispatch** com os seguintes parâmetros:

| Parâmetro | Padrão | Descrição |
|---|---|---|
| `EXECUTION_ENVIRONMENT` | `HML` | Ambiente de execução |
| `BASE_URL` | `https://serverest.dev` | URL base |
| `test_tag` | `regressivo` | Tag dos cenários |
| `parallel_execution` | `true` | Execução paralela com pabot |
| `SO` | `ubuntu` | Sistema operacional do runner |

Ao final da execução, o relatório HTML é publicado como artefato e uma notificação é enviada ao Slack.
