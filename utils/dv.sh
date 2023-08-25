#!/bin/bash

if [ -d ./var ]; then
    rm -rf ./var && echo "Diretório var excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o diretório var do projeto"
fi
