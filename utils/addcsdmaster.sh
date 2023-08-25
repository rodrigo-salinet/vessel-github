#!/bin/bash

cherryPick() {

    echo "Digite o código SHA do commit para executar o cherry-pick ou tecle ENTER para sair"

    read COMMITSHA
    case "$COMMITSHA" in
    "")
        echo "Saindo, mas antes executando pull e push para enviar as alterações"
        git pull && echo "git pull executado com sucesso" || "Por algum motivo acima não foi possível executar o git pull"
        git push && echo "git push executado com sucesso" || "Por algum motivo acima não foi possível executar o git push"
        exit
        ;;
    *)
        echo "Adicionando commit $COMMITSHA"
        git cherry-pick -x $COMMITSHA && echo "Commit $COMMITSHA adicionado com sucesso" || echo "Por algum motivo acima não foi possível adicionar o commit $COMMITSHA"

        cherryPick
        ;;
    esac

}

echo "Adicionando repositório remoto da branch master da csd"
git remote add csd git@git2bis.com.br:bis2bis/bis2bis-stores/cidade-cancao-csd.git && echo "repositório remoto da branch master da csd adicionado com sucesso" || echo "Por algum motivo acima não foi possível adicionar o repositório remoto da branch master da csd"

echo "Buscando branch master da csd"
git fetch csd master && echo "Branch master da csd encontrada com sucesso" || echo "Por algum motivo acima não foi possível encontrar a branch master da csd"

cherryPick