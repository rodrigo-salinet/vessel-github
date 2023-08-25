#!/bin/bash

if [ -d ./var ]; then
    rm -rf ./var && echo "Diretório var excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o diretório var do projeto"
fi

if [ -d ./vendor ]; then
    rm -rf ./vendor && echo "Diretório vendor excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o diretório vendor do projeto"
fi

#composer update --ignore-platform-reqs && echo "composer update (--ignore-platform-reqs) executado com sucesso" || echo "Por algum motivo acima não foi possível executar o composer update"

composer update --prefer-source --ignore-platform-reqs && echo "composer update executado com sucesso" || echo "Por algum motivo acima não foi possível executar o composer update"

if [ -e ./composer.lock ]; then
    rm -rf ./composer.lock && echo "Aquivo composer.lock excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o arquivo composer.lock do projeto"
fi
