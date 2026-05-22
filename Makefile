# ──────────────────────────────────────────────────────────────────────────────
#  Makefile — API Test Automation (Robot Framework)
# ──────────────────────────────────────────────────────────────────────────────
#  Uso rápido:
#    make install          → instala dependências
#    make test             → executa todos os testes (sequencial)
#    make test-parallel    → executa todos os testes (paralelo com pabot)
#    make test-tag TAG=smoke → executa testes por tag
#    make report           → abre o relatório no browser
#    make clean            → remove artefatos gerados
# ──────────────────────────────────────────────────────────────────────────────

# ── Configurações padrão (sobrescrevíveis via linha de comando) ───────────────
ENV              ?= HML
BASE_URL         ?= https://serverest.dev
TAG              ?=
RESULTS_DIR      := tests/results
PABOT_PROCESSES  ?= 4

# ── Detecta o comando python disponível ──────────────────────────────────────
PYTHON := $(shell command -v python3 2>/dev/null || command -v python 2>/dev/null)

# ── Cores para output legível ─────────────────────────────────────────────────
CYAN  := \033[0;36m
RESET := \033[0m

.DEFAULT_GOAL := help

# ──────────────────────────────────────────────────────────────────────────────
#  AJUDA
# ──────────────────────────────────────────────────────────────────────────────
.PHONY: help
help:
	@echo ""
	@echo "$(CYAN)Comandos disponíveis:$(RESET)"
	@echo ""
	@echo "  make install              Instala as dependências do requirements.txt"
	@echo "  make setup                Executa o setup.sh (aliases + dependências)"
	@echo ""
	@echo "  make test                 Roda todos os testes (sequencial)"
	@echo "  make test-parallel        Roda todos os testes em paralelo (pabot)"
	@echo "  make test-tag TAG=<tag>   Roda testes filtrados por tag"
	@echo "  make smoke                Atalho: roda testes com tag 'smoke'"
	@echo "  make regressivo           Atalho: roda testes com tag 'regressivo'"
	@echo ""
	@echo "  make report               Abre o relatório HTML no browser"
	@echo "  make clean                Remove artefatos de execução"
	@echo ""
	@echo "  Variáveis configuráveis:"
	@echo "    ENV=$(ENV)  BASE_URL=$(BASE_URL)  PABOT_PROCESSES=$(PABOT_PROCESSES)"
	@echo ""


# ──────────────────────────────────────────────────────────────────────────────
#  INSTALAÇÃO
# ──────────────────────────────────────────────────────────────────────────────
.PHONY: install
install:
	@echo "$(CYAN)→ Instalando dependências...$(RESET)"
	$(PYTHON) -m pip install --upgrade pip setuptools
	$(PYTHON) -m pip install -r requirements.txt

.PHONY: setup
setup:
	@echo "$(CYAN)→ Executando setup.sh...$(RESET)"
	bash setup.sh


# ──────────────────────────────────────────────────────────────────────────────
#  EXECUÇÃO DE TESTES
# ──────────────────────────────────────────────────────────────────────────────

# Sequencial — todos os testes
.PHONY: test
test:
	@echo "$(CYAN)→ Executando todos os testes [$(ENV)]...$(RESET)"
	EXECUTION_ENVIRONMENT=$(ENV) BASE_URL=$(BASE_URL) \
	$(PYTHON) -m robot \
		--outputdir $(RESULTS_DIR) \
		--loglevel DEBUG \
		tests

# Paralelo — todos os testes
.PHONY: test-parallel
test-parallel:
	@echo "$(CYAN)→ Executando testes em paralelo [$(ENV)] — $(PABOT_PROCESSES) processos...$(RESET)"
	EXECUTION_ENVIRONMENT=$(ENV) BASE_URL=$(BASE_URL) \
	$(PYTHON) -m pabot \
		--processes $(PABOT_PROCESSES) \
		--outputdir $(RESULTS_DIR) \
		--loglevel DEBUG \
		tests

# Filtrado por tag (sequencial)
.PHONY: test-tag
test-tag:
	@[ -n "$(TAG)" ] || (echo "Informe a tag: make test-tag TAG=<tag>" && exit 1)
	@echo "$(CYAN)→ Executando testes com tag '$(TAG)' [$(ENV)]...$(RESET)"
	EXECUTION_ENVIRONMENT=$(ENV) BASE_URL=$(BASE_URL) \
	$(PYTHON) -m robot \
		--outputdir $(RESULTS_DIR) \
		--include $(TAG) \
		--loglevel DEBUG \
		tests

# Atalhos de tag
.PHONY: smoke
smoke:
	$(MAKE) test-tag TAG=smoke

.PHONY: regressivo
regressivo:
	$(MAKE) test-tag TAG=regressivo

.PHONY: cadastro
cadastro:
	$(MAKE) test-tag TAG=cadastro

.PHONY: consulta
consulta:
	$(MAKE) test-tag TAG=consulta

.PHONY: atualizacao
atualizacao:
	$(MAKE) test-tag TAG=atualizacao

.PHONY: exclusao
exclusao:
	$(MAKE) test-tag TAG=exclusao


# ──────────────────────────────────────────────────────────────────────────────
#  RELATÓRIO
# ──────────────────────────────────────────────────────────────────────────────
.PHONY: report
report:
	@echo "$(CYAN)→ Abrindo relatório...$(RESET)"
	open $(RESULTS_DIR)/report.html 2>/dev/null || xdg-open $(RESULTS_DIR)/report.html


# ──────────────────────────────────────────────────────────────────────────────
#  LIMPEZA
# ──────────────────────────────────────────────────────────────────────────────
.PHONY: clean
clean:
	@echo "$(CYAN)→ Removendo artefatos...$(RESET)"
	rm -rf $(RESULTS_DIR)/output.xml \
	       $(RESULTS_DIR)/log.html \
	       $(RESULTS_DIR)/report.html \
	       $(RESULTS_DIR)/pabot_results \
	       .pabotsuitenames
	@echo "Pronto."
