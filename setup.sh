#!/bin/bash

# Verificar o sistema operacional
if [[ "$SHELL" == *"bash"* ]]; then
    RC_FILE="$HOME/.bashrc"
    echo "Adicionando aliases ao arquivo $RC_FILE"
    echo "alias pip='pip3'" >> "$RC_FILE"
    echo "alias python='python3'" >> "$RC_FILE"
    source "$RC_FILE"
elif [[ "$SHELL" == *"zsh"* ]]; then
    RC_FILE="$HOME/.zshrc"
    echo "Adicionando aliases ao arquivo $RC_FILE"
    echo "alias pip='pip3'" >> "$RC_FILE"
    echo "alias python='python3'" >> "$RC_FILE"
    source "$RC_FILE"
else
    echo "Shell não suportado. O script só suporta Bash e Zsh."
    exit 1
fi

# Atualizar pip e instalar dependências
pip install --upgrade pip
pip install --upgrade setuptools
pip install -r requirements.txt

