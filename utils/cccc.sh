#!/bin/bash

if [ -d ./var ]; then
    rm -rf ./var && echo "Diretório var excluído do projeto" || echo "Por algum motivo acima não foi possível excluir o diretório var do projeto"
fi

compass clean && echo "compass clean executado com sucesso" || echo "Por algum motivo acima não foi possível executar o compass clean"

compass compile && echo "compass compile executado com sucesso" || echo "Por algum motivo acima não foi possível executar o compass compile"
