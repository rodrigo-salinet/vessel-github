#!/bin/bash

if [ -d ./var/cache ]; then
    rm -rf ./var/cache && echo "Diretório var/cache excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o diretório var/cache do projeto"
fi
