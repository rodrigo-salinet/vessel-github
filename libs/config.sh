#!/bin/bash

# versão
VER="3.0.0"

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

# caminho (path) absoluto do devilbox do vessel
V_M3_PATH=${V_PATH}/devilbox-2.3

# caminho (path) absoluto do arquivo .env do devilbox
V_M3_ENV_FILE=${V_M3_PATH}/.env

# caminho (path) absoluto das lojas m1 do vessel
V_M1_WWW_PATH=${V_M1_PATH}/data/www

# caminho (path) absoluto das lojas m2 do vessel
V_M2_WWW_PATH=${V_M2_PATH}/data/www

# caminho (path) absoluto das lojas m3 do vessel
V_M3_WWW_PATH=${V_M3_PATH}/data/www

# Github URL's
GITHUB_BASE_URL=https://github.com/api/v4/
GITHUB_M15_STORES_URL=https://github.com/rodrigo-salinet/stores/magento-1.5/
GITHUB_M19_STORES_URL=https://github.com/rodrigo-salinet/stores/magento-1.9/
GITHUB_M24_STORES_URL=https://github.com/rodrigo-salinet/stores/magento-2.4/

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
source ${V_LIBS_PATH}/dbx.sh

# caminho (path) do container/lojas magento atual
M_PATH=$V_M1_PATH
M_WWW_PATH=$V_M1_WWW_PATH
M_ENV_FILE=$V_M1_ENV_FILE
if [ $MAGENTO == 2 ]; then
    M_PATH=$V_M2_PATH
    M_WWW_PATH=$V_M2_WWW_PATH
    M_ENV_FILE=$V_M2_ENV_FILE
fi

if [ $MAGENTO == 3 ]; then
    M_PATH=$V_M3_PATH
    M_WWW_PATH=$V_M3_WWW_PATH
    M_ENV_FILE=$V_M3_ENV_FILE
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

M3_ADMIN_USER='local'
M3_ADMIN_PASS='local123'

LOCAL_ADMIN_USER=$M1_ADMIN_USER
LOCAL_ADMIN_PASS=$M1_ADMIN_PASS

if [ $MAGENTO == 2 ]; then
    LOCAL_ADMIN_USER=$M2_ADMIN_USER
    LOCAL_ADMIN_PASS=$M2_ADMIN_PASS
fi

if [ $MAGENTO == 3 ]; then
    LOCAL_ADMIN_USER=$M3_ADMIN_USER
    LOCAL_ADMIN_PASS=$M3_ADMIN_PASS
fi

# caminho executável do magento, da raiz de qualquer loja
BIN_MAGENTO='./bin/magento'

# ativar debug verboses
# BIN_MAGENTO='./bin/magento -vvv'
