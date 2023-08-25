#!/bin/bash

addRepository() {
    REPOSITORY_NAME=""
    REPOSITORY_URL=""
    REPOSITORY_BRANCH="master"

    echo -e "Digite o nome do repositório remoto, por exemplo 'xxx' (sem as aspas) e tecle ENTER para continuar"
    read REPO_NAME
    case "$REPO_NAME" in
    "" )
        echo -e "Nome do repositório remoto não informado. Tente novamente."
        exit
        ;;
    * )
        REPOSITORY_NAME=$REPO_NAME
        ;;
    esac

    echo -e "Digite a URL|HTTPS do repositório remoto e tecle ENTER para continuar"
    read REPO_URL
    case "$REPO_URL" in
    "" )
        echo -e "URL do repositório não informado. Tente novamente."
        exit
        ;;
    * )
        REPOSITORY_URL=$REPO_URL
        ;;
    esac

    echo -e "Digite a BRANCH do repositório remoto e tecle ENTER para continuar"
    read REPO_BRANCH
    case "$REPO_BRANCH" in
    "" )
        echo -e "BRANCH do repositório não informada. Será utilizada a branch master por padrão."
        exit
        ;;
    * )
        REPO_BRANCH="${REPO_BRANCH//["/"]/"\\/"}"
        echo "${REPO_BRANCH//["/"]/"\\/"}"
        REPOSITORY_BRANCH=$REPO_BRANCH
        ;;
    esac

    echo -e "Adicionando URL $REPOSITORY_URL do repositório remoto $REPOSITORY_NAME"
    git remote add $REPOSITORY_NAME $REPOSITORY_URL && echo -e "Repositório remoto $REPOSITORY_NAME da URL $REPOSITORY_URL adicionado com sucesso" || echo -e "Por algum motivo acima não foi possível adicionar o repositório remoto $REPOSITORY_NAME da URL $REPOSITORY_URL"

    echo -e "Buscando (fetch) da branch $REPOSITORY_BRANCH da URL $REPOSITORY_URL do repositório remoto $REPOSITORY_NAME"
    git fetch $REPOSITORY_NAME $REPOSITORY_BRANCH && echo -e "Branch $REPOSITORY_BRANCH da URL $REPOSITORY_URL do repositório remoto $REPOSITORY_NAME encontrada com sucesso" || echo "Por algum motivo acima não foi possível encontrar a branch $REPOSITORY_BRANCH da URL $REPOSITORY_URL do repositório remoto $REPOSITORY_NAME"
}

cherryPick() {
    echo -e "Digite o código SHA do commit para executar o cherry-pick e tecle ENTER para continuar/sair"

    read COMMITSHA
    case "$COMMITSHA" in
    "" )
        echo -e "Saindo, mas antes executando pull e push para enviar as alterações"
        git pull && echo "git pull executado com sucesso" || "Por algum motivo acima não foi possível executar o git pull"
        git push && echo "git push executado com sucesso" || "Por algum motivo acima não foi possível executar o git push"
        exit
        ;;
    * )
        echo -e "Adicionando commit $COMMITSHA"
        git cherry-pick -x $COMMITSHA && echo "Commit $COMMITSHA adicionado com sucesso" || echo "Por algum motivo acima não foi possível adicionar o commit $COMMITSHA"

        cherryPick
        ;;
    esac
}

addRepository

cherryPick