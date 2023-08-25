#!/bin/bash

# versão
VER="2.0.0"

# caminho (path) absoluto do vessel
V_PATH=$(pwd)

# caminho (path) absoluto do arquivo .env do vessel
V_ENV_FILE=${V_PATH}/.env

# caminho (path) absoluto das libs do vessel
V_LIBS_PATH=${V_PATH}/libs

# caminho (path) absoluto do magento1 do vessel
V_M1_PATH=${V_PATH}/magento1

# caminho (path) absoluto do arquivo .env do magento1
V_M1_ENV_FILE=${V_M1_PATH}/.env

# caminho (path) absoluto do magento2 do vessel
V_M2_PATH=${V_PATH}/magento2

# caminho (path) absoluto do arquivo .env do magento2
V_M2_ENV_FILE=${V_M2_PATH}/.env

# caminho (path) absoluto das lojas m1 do vessel
V_M1_WWW_PATH=${V_M1_PATH}/data/www

# caminho (path) absoluto das lojas m2 do vessel
V_M2_WWW_PATH=${V_M2_PATH}/data/www

# Git2bis URL's
GIT2BIS_BASE_URL=https://git2bis.com.br/api/v4/
GIT2BIS_M15_STORES_URL=https://git2bis.com.br/bis2bis/bis2bis-stores/
GIT2BIS_M19_STORES_URL=https://git2bis.com.br/bis2bis/bis2bis-stores/magento-1.9/
GIT2BIS_M24_STORES_URL=https://git2bis.com.br/bis2bis/bis2bis/m2/lojas/

# Conexão com mysql
MySQLConn="mysql -h mysql -uroot -pmagento -f"

# chamando arquivos de configuração
source ${V_LIBS_PATH}/color.sh
source ${V_LIBS_PATH}/notify.sh
if [ ! -f "$V_PATH/.env" ]; then
    NotifyInfo "Criando arquivo .env"
    cp "$V_PATH/.envexample" "$V_PATH/.env" && NotifySuccess "Arquivo .env criado com sucesso" || NotifyError "Por algum motivo acima não foi possível criar o arquivo .env"
fi
source ${V_PATH}/.env
source ${V_PATH}/utils/aliases.sh
source ${V_LIBS_PATH}/menu.sh
source ${V_LIBS_PATH}/common.sh
source ${V_LIBS_PATH}/magento1.sh
source ${V_LIBS_PATH}/magento2.sh

# caminho (path) do container/lojas magento atual
M_PATH=$V_M1_PATH
M_WWW_PATH=$V_M1_WWW_PATH
M_ENV_FILE=$V_M1_ENV_FILE
if [ $MAGENTO == 2 ]; then
    M_PATH=$V_M2_PATH
    M_WWW_PATH=$V_M2_WWW_PATH
    M_ENV_FILE=$V_M2_ENV_FILE
fi

# Opções de execução do composer
COMPOSER_OPTIONS=''

# desativar interações
# COMPOSER_OPTIONS='--no-interaction'

# ignorar requires platform
# COMPOSER_OPTIONS='--ignore-platform-reqs'

# ativar debug verboses
# COMPOSER_OPTIONS='-vvv'

M1_ADMIN_USER='admin'
M1_ADMIN_PASS='admin'

M2_ADMIN_USER='local'
M2_ADMIN_PASS='local123'

LOCAL_ADMIN_USER=$M1_ADMIN_USER
LOCAL_ADMIN_PASS=$M1_ADMIN_PASS

if [ $MAGENTO == 2 ]; then
    LOCAL_ADMIN_USER=$M2_ADMIN_USER
    LOCAL_ADMIN_PASS=$M2_ADMIN_PASS
fi

# caminho executável do magento, da raiz de qualquer loja
BIN_MAGENTO='./bin/magento'

# ativar debug verboses
# BIN_MAGENTO='./bin/magento -vvv'
