#!/usr/bin/env bash

PNameLocal() {
  if [ -z "$P_NAME" ]; then
    NotifyInfo "Foram encontradas as seguintes lojas instaladas:"
    NotifySuccess "$(ls -1 $M_WWW_PATH)"
    echo ""

    Notify "Digite, ou copie acima e cole, o nome da loja local e tecle ENTER"
    echo ""

    read P_NAME
    case $P_NAME in
    "")
      NotifyError "Nome do projeto local não pode ser vazio"
      PNameLocal
      ;;
    esac
  fi
}

MExecute() {
  [ -z "$1" ] && Notify "Por favor informe o comando (ex. ls)" && GoHome

  (cd ${M_PATH} && docker-compose exec --user devilbox php bash -c "$@")
}

continuar() {
  NotifyAsk "Pressione ENTER para continuar"
  read -p "$*"
}

MCompassWatch() {
  PNameLocal

  NotifyInfo "Executando compass watch"
  MExecute "cd ${M_WWW_PATH}/$P_NAME && compass watch &>/dev/null &" && NotifySuccess "Compass watch executado com sucesso" || NotifyError "Por algum motivo acima não foi possível executar o compass watch"
}

cfgGit2bisTokenNull() {
  NotifyInfo "Acesse https://git2bis.com.br/-/profile/personal_access_tokens para gerar um novo token"
  Notify "Digite o seu token de acesso ao Git2bis e tecle ENTER"
  read GLTKN
  case $GLTKN in
  "")
    NotifyError "Token não configurado"
    checkEnv
    ;;
  * )
    NotifyInfo "Configurando a variável de ambiente GIT2BIS_TOKEN no arquivo .env"
    GIT2BIS_TOKEN="$GLTKN"
    sed -i "s/GIT2BIS_TOKEN=/GIT2BIS_TOKEN=$GLTKN/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente GIT2BIS_TOKEN configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente GIT2BIS_TOKEN"
    ;;
  esac
}

cfgGit2bisUsernameNull() {
  Notify "Digite o seu username de acesso ao Git2bis e tecle ENTER"
  read GLUN
  case $GLUN in
  "")
    NotifyError "Username não configurado"
    checkEnv
    ;;
  * )
    NotifyInfo "Configurando a variável de ambiente GIT2BIS_USERNAME no arquivo .env"
    GIT2BIS_USERNAME="$GLUN"
    sed -i "s/GIT2BIS_USERNAME=/GIT2BIS_USERNAME=$GLUN/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente GIT2BIS_USERNAME configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente GIT2BIS_USERNAME"
    ;;
  esac
}

cfgGit2bisUseremailNull() {
  Notify "Digite o seu email de acesso ao Git2bis e tecle ENTER"
  read GLUE
  case $GLUE in
  "")
    NotifyError "Email não configurado"
    checkEnv
    ;;
  * )
    NotifyInfo "Configurando a variável de ambiente GIT2BIS_USEREMAIL no arquivo .env"
    GIT2BIS_USEREMAIL="$GLUE"
    sed -i "s/GIT2BIS_USEREMAIL=/GIT2BIS_USEREMAIL=$GLUE/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente GIT2BIS_USEREMAIL configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente GIT2BIS_USEREMAIL"
    ;;
  esac
}

cfgRootUserNull() {
  Notify "Digite o seu usuário local de acesso root ao Linux e tecle ENTER"
  read LROOT
  case $LROOT in
  "")
    NotifyError "Usuário local de acesso root ao Linux não configurado"
    checkEnv
    ;;
  * )
    NotifyInfo "Configurando a variável de ambiente USER no arquivo .env"
    USER="$LROOT"
    sed -i "s/USER=/USER=$LROOT/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente USER configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente USER"
    ;;
  esac
}

cfgRootPasswordNull() {
  Notify "Digite o sua senha de acesso ao Linux e tecle ENTER"
  read LROOTP
  case $LROOTP in
  "")
    NotifyError "Senha de acesso ao Linux não configurada"
    checkEnv
    ;;
  * )
    NotifyInfo "Configurando a variável de ambiente ROOT_PASSWORD no arquivo .env"
    ROOT_PASSWORD="$LROOTP"
    sed -i "s/ROOT_PASSWORD=/ROOT_PASSWORD=$LROOTP/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente ROOT_PASSWORD configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente ROOT_PASSWORD"
    ;;
  esac
}

cfgM1StorePathNull(){
  Notify "Digite o path (caminho absoluto) do local de acesso às lojas M1 e tecle ENTER"
  read M1SPATH
  case $M1SPATH in
  "")
    NotifyError "Path (caminho absoluto) do local de acesso às lojas M1 não configurado"
    checkEnv
    ;;
  * )
    M1SPATH="${M1SPATH//["/"]/"\\/"}"
    M1_STORE_PATH="$M1SPATH"

    if [[ $(grep "^M1_STORE_PATH" $V_ENV_FILE | wc -l) == 0 ]]; then
      NotifyInfo "Inserindo variável de ambiente M1_STORE_PATH em $V_ENV_FILE"
      withSudo "echo \"M1_STORE_PATH=${M1SPATH}\" >> $V_ENV_FILE" && NotifySuccess "variável de ambiente M1_STORE_PATH inserida com sucesso em $V_ENV_FILE." || NotifyError "Por algum motivo acima não foi possível inserir a variável de ambiente M1_STORE_PATH em $V_ENV_FILE."
    else
      NotifyInfo "Configurando a variável de ambiente M1_STORE_PATH no arquivo $V_ENV_FILE"
      sed -i "s/M1_STORE_PATH=/M1_STORE_PATH=${M1SPATH}/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente M1_STORE_PATH configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente M1_STORE_PATH"
    fi
    ;;
  esac
}

cfgM2StorePathNull(){
  Notify "Digite o path (caminho absoluto) do local de acesso às lojas M2 e tecle ENTER"
  read M2SPATH
  case $M2SPATH in
  "")
    NotifyError "Path (caminho absoluto) do local de acesso às lojas M2 não configurado"
    checkEnv
    ;;
  * )
    M2SPATH="${M2SPATH//["/"]/"\\/"}"
    M2_STORE_PATH="$M2SPATH"

    if [[ $(grep "^M2_STORE_PATH" $V_ENV_FILE | wc -l) == 0 ]]; then
      NotifyInfo "Inserindo variável de ambiente M2_STORE_PATH em $V_ENV_FILE"
      withSudo "echo \"M2_STORE_PATH=${M2SPATH}\" >> $V_ENV_FILE" && NotifySuccess "variável de ambiente M2_STORE_PATH inserida com sucesso em $V_ENV_FILE." || NotifyError "Por algum motivo acima não foi possível inserir a variável de ambiente M2_STORE_PATH em $V_ENV_FILE."
    else
      NotifyInfo "Configurando a variável de ambiente M2_STORE_PATH no arquivo $V_ENV_FILE"
      sed -i "s/M2_STORE_PATH=/M2_STORE_PATH=${M2SPATH}/g" $V_ENV_FILE && NotifySuccess "Variável de ambiente M2_STORE_PATH configurada com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar a variável de ambiente M2_STORE_PATH"
    fi
    ;;
  esac
}

cfgGit2bisSsh() {
  if [ ! -f "/home/$USER/.ssh/id_ed25519.pub" ]; then
    NotifyAsk "Chave SSH key do Git2bis não encontrada em /home/$USER/.ssh/id_ed25519. Deseja gerar uma nova chave SSH? s/n"

    read YON
    case $YON in
      s | S )
        NotifyInfo "Gerando nova chave SSH key do Git2bis"
        ssh-keygen -t ed25519 -f /home/$USER/.ssh/id_ed25519 -q -N ''
        NotifySuccess "Chave SSH key do Git2bis gerada com sucesso, veja abaixo:\n"
        cat /home/$USER/.ssh/id_ed25519.pub
        NotifyInfo "Para continuar: \n\n 1. Adicione a chave SSH gerada acima ao seu repositório do Git2bis em https://git2bis.com.br/-/profile/keys;\n\n 2. Depois acesse https://git2bis.com.br/-/profile/personal_access_tokens para gerar um novo token de acesso; e,\n\n 3. Depois adicione o token gerado na continuação da instalação do vessel."
        continuar
        checkEnv
        ;;
      n | N | "" | * )
        NotifyInfo "É necessário gerar uma nova chave SSH key do Git2bis para continuar"
        cfgGit2bisSsh
        ;;
    esac
  fi
}

cfgVscode() {
  VSCODE_JSON_UTILS=$V_PATH/utils/settings.json
  VSCODE_JSON_USER=/home/$USER/.config/Code/User/settings.json
  VSCODE_JSON_TMP=/home/$USER/.config/Code/User/settings.json.tmp
  if [ -f "$VSCODE_JSON_USER" ]; then
    if [[ $(grep -F "launch" $VSCODE_JSON_USER | wc -l) == 0 ]]; then
      NotifyInfo "Configurando VS Code"
      $V_PATH/utils/jq -s add $VSCODE_JSON_UTILS $VSCODE_JSON_USER > $VSCODE_JSON_TMP && mv $VSCODE_JSON_TMP $VSCODE_JSON_USER && NotifySuccess "VS Code configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar VS Code"
    fi
  fi

  VSCODE_SNIPPETS_UTILS=$V_PATH/utils/salinet.code-snippets
  VSCODE_SNIPPETS_USER=/home/$USER/.config/Code/User/snippets/salinet.code-snippets
  NotifyInfo "Adicionando Salinet's snippets no VS Code"
  yes | cp -r $VSCODE_SNIPPETS_UTILS $VSCODE_SNIPPETS_USER && NotifySuccess "Salinet's snippets adicionados com sucesso" || NotifyError "Por algum motivo acima não foi possível adicionar Salinet's snippets"
}

checkEnv() {
  if [ ! -f "$M_PATH/backups/mysql/repair_aws_dump.sql" ]; then
    NotifyInfo "Copiando arquivo repair_aws_dump.sql"
    cp $V_PATH/utils/repair_aws_dump.sql $M_PATH/backups/mysql/repair_aws_dump.sql && NotifySuccess "Arquivo repair_aws_dump.sql copiado com sucesso" || NotifyError "Por algum motivo acima não foi possível copiar o arquivo repair_aws_dump.sql"
  fi

  if [ ! -f "$V_PATH/magento1/autostart/install_pv.sh" ]; then
    NotifyInfo "Copiando arquivo install_pv.sh"
    cp $V_PATH/utils/install_pv.sh $V_PATH/magento1/autostart/install_pv.sh && NotifySuccess "Arquivo install_pv.sh copiado com sucesso" || NotifyError "Por algum motivo acima não foi possível copiar o arquivo install_pv.sh"
  fi

  if [ ! -z "$M1_STORE_PATH" ] && [ ! -d "$V_PATH/magento1/data/www" ]; then
    NotifyInfo "Removendo link das lojas M1"
    rm -rf "$V_PATH/magento1/data/www" && NotifySuccess "Link das lojas M1 removido com sucesso" || NotifyError "Por algum motivo acima não foi possível remover o link das lojas M1"

    NotifyInfo "Criando link das lojas M1"
    cd $V_PATH/magento1/data
    ln -s $M1_STORE_PATH www && NotifySuccess "Link das lojas M1 criado com sucesso" || NotifyError "Por algum motivo acima não foi possível criar o link das lojas M1"
  fi

  if [ ! -z "$M2_STORE_PATH" ] && [ ! -d "$V_PATH/magento2/data/www" ]; then
    NotifyInfo "Removendo link das lojas M2"
    rm -rf "$V_PATH/magento2/data/www" && NotifySuccess "Link das lojas M2 removido com sucesso" || NotifyError "Por algum motivo acima não foi possível remover o link das lojas M2"

    NotifyInfo "Criando link das lojas M2"
    cd $V_PATH/magento2/data
    ln -s $M2_STORE_PATH www && NotifySuccess "Link das lojas M2 criado com sucesso" || NotifyError "Por algum motivo acima não foi possível criar o link das lojas M2"
  fi

  if [ -z $GIT2BIS_TOKEN ]; then
    cfgGit2bisTokenNull
  fi

  if [ -z "$GIT2BIS_USERNAME" ]; then
    cfgGit2bisUsernameNull
  fi

  if [ -z "$GIT2BIS_USEREMAIL" ]; then
    cfgGit2bisUseremailNull
  fi

  if [ -z "$USER" ]; then
    cfgRootUserNull
  fi

  if [ -z "$ROOT_PASSWORD" ]; then
    cfgRootPasswordNull
  fi

  if [ -z "$M1_STORE_PATH" ]; then
    cfgM1StorePathNull
  fi

  if [ -z "$M2_STORE_PATH" ]; then
    cfgM2StorePathNull
  fi

  cfgGit2bisSsh

  cfgVscode
}

CleanVars() {
  unset G_NAME
  unset P_NAME
  unset GIT_URL
}

GoHome() {
  continuar
  Main
}

AddHost() {
  PNameLocal

  if [ -z "$1" ]; then
    NOME_LOJA=$P_NAME
  else
    NOME_LOJA=$1
  fi

  if [[ $(grep "^127.0.0.1 $NOME_LOJA.loc$" /etc/hosts | wc -l) == 0 ]]; then
    NotifyInfo "Inserindo URL $P_NAME.loc em /etc/hosts"
    withSudo "echo \"127.0.0.1 $NOME_LOJA.loc\" >> /etc/hosts" && NotifySuccess "URL $NOME_LOJA.loc inserida com sucesso em /etc/hosts." || NotifyError "Por algum motivo acima não foi possível inserir a URL $NOME_LOJA.loc em /etc/hosts"
  fi
}

UpdateVessel() {
  NotifyInfo "Atualizando Vessel, aguarde..."
  git fetch && git pull && NotifySuccess "Vessel atualizado! Continuando..." || NotifyError "Por algum motivo acima não foi possível atualizar o Vessel. Veja acima"
  sleep 2
}

withSudo() {
  [ -z "$1" ] && echo "Por favor informe o comando (ex. ls)" && continuar && Main

  if [ -z "$USER" ]; then
    cfgRootUserNull
  fi

  if [ -z "$ROOT_PASSWORD" ]; then
    cfgRootPasswordNull
  fi

  (echo $ROOT_PASSWORD | sudo -S sh -c "$@" >/dev/null)
}

StopContainers() {
  NotifyInfo "Parando containers do Magento 1"
  cd ${V_M1_PATH} && docker-compose stop -t 1 && NotifySuccess "Containers parados com sucesso!" || NotifyError "Por algum motivo acima não foi possível parar os containers. Veja log acima."

  NotifyInfo "Acessando o diretório do magento 1 | docker-compose rm/down"
  cd ${V_M1_PATH} && docker-compose rm -f && docker-compose down && NotifySuccess "Containers removidos com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover containers. Veja log acima."

  NotifyInfo "Parando containers do Magento 2"
  cd ${V_M2_PATH} && docker-compose stop -t 2 && NotifySuccess "Containers parados com sucesso!" || NotifyError "Por algum motivo acima não foi possível parar os containers. Veja log acima."

  NotifyInfo "Acessando o diretório do magento 2 | docker-compose rm/down"
  cd ${V_M2_PATH} && docker-compose rm -f && docker-compose down && NotifySuccess "Containers removidos com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover containers. Veja log acima."
}

ZeraDocker() {
  NotifyAsk "Tem certeza que deseja zerar o docker?"

  NotifyError "ESTA AÇÃO É IRREVERSÍVEL e irá apagar todas as imagens (docker), volumes (docker), bancos de dados e configurações manuais dos containeres (ssh)."

  Notify "Recomenda-se revisar antes de prosseguir. Faça por sua conta e risco!"

  NotifyInfo "Digite s para continuar ou n para cancelar, depois tecle ENTER."

  read YON
  case "$YON" in
  y | yes | Y | YES | s | sim | S | SIM | "")
    clear

    NotifyInfo "Acessando o diretório do magento $MAGENTO | docker-compose down"
    cd ${M_PATH} && docker-compose down

    NotifyInfo "Matando os containers"
    docker kill $(docker ps -a -q)

    NotifyInfo "Parando todos os containers"
    docker stop $(docker ps -a -q)

    NotifyInfo "Removendo imagens"
    docker rmi -f $(docker images -a -q)

    NotifyInfo "Removendo containers created"
    docker rm -f $(docker ps -a -f status=created -q)

    NotifyInfo "Removendo containers restarting"
    docker rm -f $(docker ps -a -f status=restarting -q)

    NotifyInfo "Removendo containers running"
    docker rm -f $(docker ps -a -f status=running -q)

    NotifyInfo "Removendo containers removing"
    docker rm -f $(docker ps -a -f status=removing -q)

    NotifyInfo "Removendo containers paused"
    docker rm -f $(docker ps -a -f status=paused -q)

    NotifyInfo "Removendo containers exited"
    docker rm -f $(docker ps -a -f status=exited -q)

    NotifyInfo "Removendo containers dead"
    docker rm -f $(docker ps -a -f status=dead -q)

    NotifyInfo "Removendo containers"
    docker rm -f $(docker ps -a -q)

    NotifyInfo "Purgando imagens"
    docker images purge -a

    NotifyInfo "Podando image"
    docker image prune -a -f

    NotifyInfo "Podando system"
    docker system prune -a -f
    docker system prune --volumes -f

    NotifyInfo "Podando volume"
    docker volume prune -f

    NotifyInfo "Podando network"
    docker network prune -f

    NotifyInfo "Podando container"
    docker container prune -f

    NotifyInfo "Podando builder"
    docker builder prune -a -f

    NotifyInfo "Reiniciando o serviço do docker e containerd"
    withSudo "systemctl restart docker.service" && withSudo "systemctl restart containerd.service"
    ;;
  n | no | N | NO | não | NÃO)
    Main
    ;;
  *)
    NotifyError "Ops! Opção inválida, voltando..."
    sleep 2
    Main
    ;;
  esac
}

Git2bisComposerGlobalConfigs() {
  PNameLocal

  if [ -e $M_WWW_PATH/$P_NAME/auth.json ]; then
    NotifyInfo "Removendo arquivo auth.json"
    rm -rf $M_WWW_PATH/$P_NAME/auth.json && NotifySuccess "Aquivo auth.json removido da loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível remover o arquivo auth.json.lock da loja $P_NAME"
  fi

  if [ $MAGENTO == 2 ]; then
    NotifyInfo "Configurando composer global config http-basic"
    MExecute "cd $P_NAME && composer global config http-basic.repo.magento.com 4b5035e90eebe8bb3e77b7fec37f18e2 a5b4ed3838cb726d81054dd1ce528dde" && NotifySuccess "composer global http-basic executado com sucesso!" || NotifyError "Por algum motivo acima não foi possível executar o composer global config http-basic."
  fi

  MExecute "cd $P_NAME && composer global config gitlab-domains \"git2bis.com.br\" \"gitlab.com\"" && NotifySuccess "composer global config gitlab-domains executado com sucesso!" || NotifyError "Por algum motivo acima não foi possível executar o composer global config gitlab-domains."

  NotifyInfo "Configurando token git2bis na loja"
  MExecute "cd $P_NAME && yes | composer global config gitlab-token.git2bis.com.br $GIT2BIS_TOKEN" && NotifySuccess "Token configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o token. Veja acima"

  NotifyInfo "Configurando token gitlab na loja"
  MExecute "cd $P_NAME && yes | composer global config gitlab-token.gitlab.com EPHBxnoKP-cyV8Gvra1J" && NotifySuccess "Token configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o token. Veja acima"
}

ComposerInstall() {
  PNameLocal

  Git2bisComposerGlobalConfigs

  # NotifyInfo "Configurando token git2bis na loja"
  # MExecute "cd $P_NAME && sudo composer config gitlab-token.git2bis.com.br $GIT2BIS_TOKEN" && NotifySuccess "Token configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o token. Veja acima"

  # NotifyInfo "Configurando token gitlab na loja"
  # MExecute "cd $P_NAME && sudo composer config gitlab-token.gitlab.com EPHBxnoKP-cyV8Gvra1J" && NotifySuccess "Token configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o token. Veja acima"

  NotifyInfo "Executando composer install"
  MExecute "cd $P_NAME && composer-1 install $COMPOSER_OPTIONS" && NotifySuccess "Composer instalado com sucesso" || NotifyError "Por algum motivo acima não foi possível instalar o composer"

  NotifyInfo "Criando arquivo composer.json na pasta var/composer_home da loja"
  MExecute "cd $P_NAME/var && mkdir composer_home && cd composer_home && echo '{}' > composer.json" && NotifySuccess "Arquivo composer.json criado com sucesso" || NotifyError "Por algum motivo acima não foi possível criar o arquivo composer.json"
}

ComposerUpdate() {
  PNameLocal

  if [ -e $M_WWW_PATH/$P_NAME/composer.json ]; then

    if [ $MAGENTO == 1 ]; then
      ApagaVar
      ApagaVendor

      if [ -e $M_WWW_PATH/$P_NAME/composer.lock ]; then
        NotifyInfo "Removendo arquivo composer.lock"
        rm -rf $M_WWW_PATH/$P_NAME/composer.lock && NotifySuccess "Aquivo composer.lock removido da loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível remover o arquivo composer.lock da loja $P_NAME"
      fi

      NotifyInfo "Ajustando dependência \"varien\":\"*\" do módulo uploader no arquivo composer.json da loja, antes de continuar."

      MExecute "cd $P_NAME && sudo composer config repositories.varien vcs git@git2bis.com.br:bis2bis/m1/modulos/core/library/varien.git" && NotifySuccess "composer config executado com sucesso!" || NotifyError "Por algum motivo acima não foi possível executar o composer config."

      MExecute "cd $P_NAME && composer require bis2libs/varien:dev-master --no-update" && NotifySuccess "composer require executado com sucesso!" || NotifyError "Por algum motivo acima não foi possível executar o composer require."
    fi

    Git2bisComposerGlobalConfigs

    NotifyInfo "Executando composer update em $M_WWW_PATH/$P_NAME"
    if [ $MAGENTO == 1 ]; then
      MExecute "cd ${P_NAME} && composer-2 update $COMPOSER_OPTIONS" && NotifySuccess "Composer update executado com sucesso na loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível executar o composer update na loja $P_NAME"
    else
      MExecute "cd ${P_NAME} && composer-1 update --no-plugins $COMPOSER_OPTIONS" && NotifySuccess "Composer update executado com sucesso na loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível executar o composer update na loja $P_NAME"
    fi

    if [ $MAGENTO == 1 ]; then
      if [ -e $M_WWW_PATH/$P_NAME/composer.lock ]; then
        NotifyInfo "Removendo arquivo composer.lock"
        rm -rf $M_WWW_PATH/$P_NAME/composer.lock && NotifySuccess "Aquivo composer.lock removido da loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível remover o arquivo composer.lock da loja $P_NAME"
      fi

      # if [ -e $M_WWW_PATH/$P_NAME/auth.json ]; then
      #   NotifyInfo "Removendo arquivo auth.json da loja"
      #   rm -rf $M_WWW_PATH/$P_NAME/auth.json && NotifySuccess "Aquivo auth.json removido da loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível remover o arquivo auth.json da loja $P_NAME"
      # fi
    fi
  else
    NotifyError "Não foi possível encontrar o arquivo composer.json na loja $P_NAME"
  fi
}

ApagaVar() {
  PNameLocal

  if [ -d $M_WWW_PATH/$P_NAME/var ]; then
    NotifyInfo "Removendo diretório var do projeto"
    rm -rf $M_WWW_PATH/$P_NAME/var && NotifySuccess "Diretório var removido do projeto com sucesso" || NotifyError "Por algum motivo acima não foi possível remover o diretório var do projeto"
  fi
}

ApagaVendor() {
  PNameLocal

  if [ -d $M_WWW_PATH/$P_NAME/vendor ]; then
    NotifyInfo "Removendo diretório vendor do projeto"
    rm -rf $M_WWW_PATH/$P_NAME/vendor && NotifySuccess "Diretório vendor removido do projeto com sucesso" || NotifyError "Por algum motivo acima não foi possível remover o diretório vendor do projeto"
  fi
}

SSH() {
  NotifyInfo "Acessando container, aguarde..."
  cd ${M_PATH} && docker-compose exec --user devilbox php bash -l
}

Dump() {
  PNameLocal

  # caminho para o diretório de mysql dumps
  DB_MYSQL_PATH=$M_PATH/backups/mysql

  DB_MYSQL_FILE=$P_NAME.sql
  DB_GZ_FILE=$P_NAME.sql.gz
  # PREVIOUS_DIR=$(pwd)

  DOWNLOAD_PATH=/home/$USER/Downloads
  DB_GZ_DOWNLOADED=$P_NAME*.sql.gz
  if [ -e "$DOWNLOAD_PATH/$DB_GZ_DOWNLOADED" ]; then
    NotifyInfo "Movendo arquivo $P_NAME*.sql.gz da pasta Downloads para a pasta de importação mysql, se houver."
    mv $DOWNLOAD_PATH/$DB_GZ_DOWNLOADED $DB_MYSQL_PATH/$DB_GZ_FILE && NotifySuccess "Arquivo $DB_GZ_DOWNLOADED movido com sucesso!" || NotifyError "Erro ao mover arquivo $DB_GZ_DOWNLOADED"
  fi

  if [ -e "$DB_MYSQL_PATH/$DB_GZ_FILE" ]; then
    if [ $MAGENTO == 1 ]; then
      NotifyInfo "Removendo base de dados $P_NAME, se houver"
      MExecute "$MySQLConn -e 'DROP DATABASE IF EXISTS $P_NAME;'" && NotifySuccess "Base de dados $P_NAME removida com sucesso" || NotifyError "Não foi encontrada a base de dados $P_NAME para removê-la"
    fi

    NotifyInfo "Criando base de dados $P_NAME"
    MExecute "$MySQLConn -e 'CREATE DATABASE IF NOT EXISTS $P_NAME;'" && NotifySuccess "Base de dados $P_NAME criada com sucesso" || NotifyError "Por algum motivo acima não foi possível criar a base de dados $P_NAME"

    NotifyInfo "Desativando a opção Confirmação Automática (autocommit)"
    MExecute "$MySQLConn -e 'SET autocommit=0;'" && NotifySuccess "Opção Confirmação Automática (autocommit) desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Confirmação Automática (autocommit)"

    NotifyInfo "Desativando a opção Verificações Únicas (unique_checks)"
    MExecute "$MySQLConn -e 'SET unique_checks=0;'" && NotifySuccess "Opção Verificações Únicas (unique_checks) desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Verificações Únicas (unique_checks)"

    NotifyInfo "Desativando a opção Verificações de Chave Estrangeira (foreign_key_checks)"
    MExecute "$MySQLConn -e 'SET foreign_key_checks=0;'" && NotifySuccess "Opção Verificações de Chave Estrangeira (foreign_key_checks) desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Verificações de Chave Estrangeira (foreign_key_checks)"

    NotifyInfo "Descompactando o arquivo $DB_GZ_FILE. Pode demorar, então aguarde..."
    MExecute "cd /shared/backups/mysql && pv $DB_GZ_FILE | gunzip > $DB_MYSQL_FILE" && NotifySuccess "Arquivo $DB_GZ_FILE descompactado com sucesso" || NotifyError "Por algum motivo acima não foi possível descompactar o arquivo $DB_GZ_FILE"

    NotifyInfo "Excluindo o arquivo $DB_GZ_FILE"
    MExecute "cd /shared/backups/mysql && sudo rm -rf $DB_GZ_FILE" && NotifySuccess "Arquivo $DB_GZ_FILE excluído com sucesso" || NotifyError "Por algum motivo acima não foi possível excluir o arquivo $DB_GZ_FILE"

    NotifyInfo "Verificando COLLATION utf8mb4_unicode_ci no arquivo $P_NAME.sql"
    if [[ $(grep 'utf8mb4_unicode_ci' $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Ajustando COLLATION utf8mb4_unicode_ci do arquivo $P_NAME.sql"
      sed -i 's/utf8mb4_unicode_ci/utf8mb4_general_ci/g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "COLLATION utf8mb4_unicode_ci ajustado para utf8mb4_general_ci com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar o COLLATION utf8mb4_unicode_ci"
    else
      Notify "COLLATION utf8mb4_unicode_ci não encontrado no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Verificando COLLATION utf8mb4_0900_ai_ci no arquivo $P_NAME.sql"
    if [[ $(grep 'utf8mb4_0900_ai_ci' $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Ajustando COLLATION utf8mb4_0900_ai_ci do arquivo $P_NAME.sql"
      sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "COLLATION utf8mb4_0900_ai_ci ajustado para utf8mb4_general_ci com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar o COLLATION utf8mb4_0900_ai_ci"
    else
      Notify "COLLATION utf8mb4_0900_ai_ci não encontrado no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Verificando COLLATION latin1_swedish_ci no arquivo $P_NAME.sql"
    if [[ $(grep 'latin1_swedish_ci' $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Ajustando COLLATION latin1_swedish_ci do arquivo $P_NAME.sql"
      sed -i 's/latin1_swedish_ci/utf8mb4_general_ci/g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "COLLATION latin1_swedish_ci ajustado para utf8mb4_general_ci com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar o COLLATION latin1_swedish_ci"
    else
      Notify "COLLATION latin1_swedish_ci não encontrado no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Verificando CHARSET latin1 no arquivo $P_NAME.sql"
    if [[ $(grep 'latin1' $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Ajustando CHARSET latin1 do arquivo $P_NAME.sql"
      sed -i 's/latin1/utf8mb4/g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "CHARSET latin1 ajustado para utf8mb4 com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar o CHARSET latin1"
    else
      Notify "CHARSET latin1 não encontrado no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Verificando ROW_FORMAT=FIXED no arquivo $P_NAME.sql"
    if [[ $(grep 'ROW_FORMAT=FIXED' $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Removendo a opção ROW_FORMAT=FIXED do arquivo $P_NAME.sql"
      sed -i 's/ROW_FORMAT=FIXED//g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "Opção ROW_FORMAT=FIXED removida com sucesso" || NotifyError "Por algum motivo acima não foi possível remover a opção ROW_FORMAT=FIXED"
    else
      Notify "Opção ROW_FORMAT=FIXED não encontrada no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Verificando USE $P_NAME no arquivo $P_NAME.sql"
    if [[ $(grep "USE $P_NAME" $DB_MYSQL_PATH/$P_NAME.sql) > 0 ]]; then
      NotifyInfo "Removendo USE $P_NAME do arquivo $P_NAME.sql"
      sed -i 's/USE `[a-zA-Z\-\_0-9]*`\;//g' $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "USE $P_NAME removido com sucesso" || NotifyError "Por algum motivo acima não foi possível remover USE $P_NAME"
    else
      Notify "USE $P_NAME não encontrado no arquivo $P_NAME.sql"
    fi

    NotifyInfo "Importando dump $P_NAME.sql"
    MExecute "pv /shared/backups/mysql/$P_NAME.sql | $MySQLConn $P_NAME" && NotifySuccess "Arquivo $P_NAME.sql.gz da pasta $DB_MYSQL_PATH importado com sucesso" || NotifyError "Por algum motivo acima não foi possível importar o arquivo $P_NAME.sql.gz da pasta $V_M1_PATH/backups/mysql"

    NotifyInfo "Compactando arquivo novamente"
    gzip -f $DB_MYSQL_PATH/$P_NAME.sql && NotifySuccess "Arquivo $P_NAME.sql compactado com sucesso" || NotifyError "Por algum motivo acima não foi possível compactar o arquivo $P_NAME.sql"

    NotifyInfo "Inserindo tabelas removidas pelo dump no Git2bis"
    if [ $MAGENTO == 1 ]; then
      MExecute "pv /shared/backups/mysql/repair_aws_dump.sql | $MySQLConn $P_NAME" && NotifySuccess "Tabelas inseridas com sucesso (removidas pelo dump no Git2bis)" || NotifyError "Por algum motivo acima não foi possível inserir as tabelas (removidas pelo Dump no Git2bis)"
    else
      Notify "Não foi necessário inserir as tabelas removidas pelo dump no Git2bis"
    fi

    NotifyInfo "Ativando a opção Confirmação Automática (autocommit)"
    MExecute "$MySQLConn -e 'SET autocommit=1;'" && NotifySuccess "Opção Confirmação Automática (autocommit) ativada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Confirmação Automática (autocommit)"

    NotifyInfo "Ativando a opção Verificações Únicas (unique_checks)"
    MExecute "$MySQLConn -e 'SET unique_checks=1;'" && NotifySuccess "Opção Verificações Únicas (unique_checks) ativada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Verificações Únicas (unique_checks)"

    NotifyInfo "Ativando a opção Verificações de Chave Estrangeira (foreign_key_checks)"
    MExecute "$MySQLConn -e 'SET foreign_key_checks=1;'" && NotifySuccess "Opção Verificações de Chave Estrangeira (foreign_key_checks) ativadas com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Verificações de Chave Estrangeira (foreign_key_checks)"

    Notify "Configurando URL"
    ConfigBaseURL

    if [ $MAGENTO == 1 ]; then
      NotifyInfo "Ajustando senha do admin da loja"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE admin_user SET username = \"$M1_ADMIN_USER\", password = MD5(\"$M1_ADMIN_PASS\") WHERE admin_user.user_id = 1;'" && NotifySuccess "Usuário e senha ajustados com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar o usuário e a senha"

      # Keys Google Recaptcha *.loc
      RECAPTCHA_SITEKEY="6LdlH1cUAAAAAI4BmayaBI9tihlruRccHCgnzVn5"
      RECAPTCHA_SECRETKEY="6LdlH1cUAAAAAMB-reTsR9SiKfugWh7wO2ZtsZ-h"

      NotifyInfo "Configurando site_key (master)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SITEKEY\" WHERE path = \"bis2bis_googlerecaptcha/general/site_key\";'" && NotifySuccess "site_key (master) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o site_key (master)"

      NotifyInfo "Configurando secret_key (master)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SECRETKEY\" WHERE path = \"bis2bis_googlerecaptcha/general/secret_key\";'" && NotifySuccess "secret_key (master) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o secret_key (master)"

      NotifyInfo "Configurando site_key (v1)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SITEKEY\" WHERE path = \"security/general/site_key\";'" && NotifySuccess "site_key (v1) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o site_key (v1)"

      NotifyInfo "Configurando secret_key (v1)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SECRETKEY\" WHERE path = \"security/general/secret_key\";'" && NotifySuccess "secret_key (v1) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o secret_key (v1)"

      NotifyInfo "Configurando site_key (v2)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SITEKEY\" WHERE path = \"security/googleRecaptcha/site_key\";'" && NotifySuccess "site_key (v2) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o site_key (v2)"

      NotifyInfo "Configurando secret_key (v2)"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"$RECAPTCHA_SECRETKEY\" WHERE path = \"security/googleRecaptcha/secret_key\";'" && NotifySuccess "secret_key (v2) configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o secret_key (v2)"

      NotifyInfo "Configurando URL oschttpsurl"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE checkout_config_data SET oschttpsurl = \"https://$P_NAME.loc/osc/onepage/checkout\" WHERE id = 1;'" && NotifySuccess "URL oschttpsurl configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL oschttpsurl"

      NotifyInfo "Configurando URL oscloginhttpsurl"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE checkout_config_data SET oscloginhttpsurl = \"https://$P_NAME.loc/osc/onepage/login\" WHERE id = 1;'" && NotifySuccess "URL oscloginhttpsurl configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL oscloginhttpsurl"

      NotifyInfo "Ativando Método de pagamento por depósito bancário"
      MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"1\" WHERE path LIKE \"%payment/deposito/active%\";'" && NotifySuccess "Método de pagamento por depósito bancário ativado com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar o método de pagamento por depósito bancário"

      NotifyInfo "Removendo loop infinito de redirect do módulo Custom URL Rewrite"
      MExecute "$MySQLConn $P_NAME -e 'DELETE FROM custom_url_rewrite WHERE ((request_path = \"/\"));'" && NotifySuccess "Loop infinito removido com sucesso" || NotifyError "Por algum motivo acima não foi possível remover o loop infinito"

      NotifyInfo "Dropando trigger upd_stock"
      MExecute "$MySQLConn $P_NAME -e 'DROP TRIGGER IF EXISTS upd_stock;'" && NotifySuccess "Trigger upd_stock dropada com sucesso" || NotifyError "Por algum motivo acima não foi possível dropar a trigger upd_stock"
    fi

    if [ $MAGENTO == 2 ]; then
      MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

      NotifyInfo "Corrigindo layout quebrado"
      MExecute "$MySQLConn $P_NAME -e 'INSERT INTO core_config_data (path, value) VALUES (\"dev/static/sign\", 0) ON DUPLICATE KEY UPDATE value = 0;'" && NotifySuccess "Corrigido layout quebrado com sucesso" || NotifyError "Por algum motivo acima não foi possível corrigir layout quebrado"
    fi
  else
    Notify "Arquivo $DB_GZ_FILE não encontrado na pasta '$DB_MYSQL_PATH'. Por favor, verifique e tente novamente."
    echo ""

    NotifyInfo "Foram encontrados os seguintes arquivos na pasta '$DB_MYSQL_PATH':"
    NotifySuccess "$(ls -1 $DB_MYSQL_PATH)"
    echo ""

    continuar

    Notify "Utilize o link abaixo para gerar um novo dump:"
    NotifyAsk "https://git2bis.com.br/bis2bis/bis2bis-stores/dump-bis2bis/-/pipelines/new *"

    Notify "Instruções para gerar um novo dump:"
    echo ""

    continuar

    Notify "1. Acesse o arquivo .gitlab-ci.yml da loja em:"
    NotifyAsk "https://git2bis.com.br/bis2bis/bis2bis-stores/$G_NAME/-/blob/master/.gitlab-ci.yml"
    echo ""
    Notify "2. Para dump S3 AWS utilize:"
    NotifyInfo "  > 2.1 Copie e cole o >> nome << da variável ENV_STORE_NAME no campo 'Input variable key'*;"
    NotifyInfo "  > 2.2 Copie e cole o >> valor << da variável ENV_STORE_NAME no campo 'Input variable value'*;"
    NotifyInfo "  > 2.3 Copie e cole o >> nome << da variável ENV_DB_HOST no outro campo 'Input variable key'*;"
    NotifyInfo "  > 2.4 Copie e cole o >>> valor << da variável ENV_DB_HOST no outro campo 'Input variable value'*;"
    echo ""
    Notify "3. Para dump hauwei utilize:"
    NotifyInfo "  > 2.1 Copie e cole o >> nome << da variável NAMESPACE no campo 'Input variable key'*;"
    NotifyInfo "  > 2.2 Copie e cole o >> valor << da variável NAMESPACE no campo 'Input variable value'*;"
    echo ""
    Notify "4. Feito o acima, clique em 'Run pipeline'*;"
    Notify "5. Depois clique no 'play' da pipeline correspondente, Dump-aws '>' ou Dump-hauwei '>'*;"
    echo ""

    continuar

    NotifyAsk "Utilize as credenciais abaixo para acessar o respectivo dump gerado:\n"

    NotifyInfo "S3 AWS"
    Notify "HOST: https://s3.console.aws.amazon.com/s3/buckets/bisws-dbdumps"
    Notify "ID: bisws"
    Notify "LOGIN: dumps"
    Notify "PASS: Pn\$L7AF4KS9*L@ec\n"

    NotifyInfo "Hauwei"
    Notify "HOST: https://auth.huaweicloud.com/authui/login?id=bis2bis"
    Notify "ID: bis2bis"
    Notify "LOGIN: dbdumps"
    Notify "PASS: qiwluXV&\"6L\$au%G\n"

    NotifyAsk "Deseja continuar? [s/n]"
    read SON
    case "$SON" in
      s | S)
        Dump
        ;;
      n | N)
        exit 1
        ;;
      *)
        NotifyError "Opção inválida"
        continuar
        Dump
        ;;
    esac
  fi
}

Git2bisTypeStoreName() {
  Notify "   1. Acesse >>> $GIT2BIS_STORES_URL <<<;
    2. Procure pela loja;
    3. Copie (CTRL+C) o nome da loja, exatamente como está na URL do repositório do Git2bis, com traços, por exemplo: ana-maria-flores, copiado da URL https://git2bis.com.br/bis2bis/bis2bis-stores/ana-maria-flores;
    4. Cole abaixo (CTRL+SHIFT+V);
    5. Tecle ENTER."
  NotifyInfo "Digite o nome da loja"
  echo ""

  read G_NAME
  case "$G_NAME" in
    "")
      NotifyError "Ops! Nome inválido. Tente novamente."
      continuar
      Git2bisTypeStoreName
      ;;
  esac

  P_NAME=$(echo $G_NAME | sed 's/-//gi')
}

CompassCompile() {
  PNameLocal

  ApagaVar

  # Não utilizar o compass clean & compile no container (MExecute), pois apresenta o erro "Invalid US-ASCII character "\xC3"

  NotifyInfo "Executando compass clean"
  cd $M_WWW_PATH/$P_NAME && compass clean && NotifySuccess "Compass clean executado com sucesso na loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível executar o compass clean na loja $P_NAME"

  NotifyInfo "Executando compass compile"
  cd $M_WWW_PATH/$P_NAME && compass compile && NotifySuccess "Compass compile executado com sucesso na loja $P_NAME" || NotifyError "Por algum motivo acima não foi possível executar o compass compile na loja $P_NAME"
}

ConfigBaseURL() {
  PNameLocal

  if [ $MAGENTO == 1 ]; then
    NotifyInfo "Fazendo backup da URL HTTP da loja de produção"
    MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope,scope_id,path,value) SELECT 1, \"0\", \"web/unsecure/bkp_base_url\", value FROM core_config_data WHERE path = \"web/unsecure/base_url\";'" && NotifySuccess "URL HTTP da loja de produção salva com sucesso" || NotifyError "Por algum motivo acima não foi possível salvar a URL HTTP da loja de produção"

    NotifyInfo "Fazendo backup da URL HTTPS da loja de produção"
    MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope,scope_id,path,value) SELECT 1, \"0\", \"web/secure/bkp_base_url\", value FROM core_config_data WHERE path = \"web/secure/base_url\";'" && NotifySuccess "URL HTTPS da loja de produção salva com sucesso" || NotifyError "Por algum motivo acima não foi possível salvar a URL HTTPS da loja de produção"

    NotifyInfo "Configurando URL unsecure"
    MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"http://$P_NAME.loc/\" WHERE path = \"web/unsecure/base_url\";'" && NotifySuccess "URL unsecure configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL unsecure"

    NotifyInfo "Configurando URL secure"
    MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"https://$P_NAME.loc/\" WHERE path = \"web/secure/base_url\";'" && NotifySuccess "URL secure configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL secure"
  fi

  if [ $MAGENTO == 2 ]; then
    NotifyInfo "Fazendo backup da URL HTTP da loja de produção"
    MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope,scope_id,path,value) SELECT \"default\", 0, \"web/unsecure/bkp_base_url\", value FROM core_config_data WHERE path = \"web/unsecure/base_url\";'" && NotifySuccess "URL HTTP da loja de produção salva com sucesso" || NotifyError "Por algum motivo acima não foi possível salvar a URL HTTP da loja de produção"

    NotifyInfo "Fazendo backup da URL HTTPS da loja de produção"
    MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope,scope_id,path,value) SELECT \"default\", 0, \"web/secure/bkp_base_url\", value FROM core_config_data WHERE path = \"web/secure/base_url\";'" && NotifySuccess "URL HTTPS da loja de produção salva com sucesso" || NotifyError "Por algum motivo acima não foi possível salvar a URL HTTPS da loja de produção"

    NotifyInfo "Configurando URL unsecure"
    MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"http://$P_NAME.loc/\" WHERE path = \"web/unsecure/base_url\";'" && NotifySuccess "URL unsecure configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL unsecure"

    NotifyInfo "Configurando URL secure"
    MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"https://$P_NAME.loc/\" WHERE path = \"web/secure/base_url\";'" && NotifySuccess "URL secure configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o URL secure"

    # NotifyInfo "Configurando URL unsecure"
    # MExecute "$MAGENTO_EXEC config:set web/unsecure/base_url 'http://$P_NAME.loc/'"

    # NotifyInfo "Configurando URL secure"
    # MExecute "$MAGENTO_EXEC config:set web/secure/base_url 'https://$P_NAME.loc/'"

    # MExecute "$MAGENTO_EXEC setup:install \
      # --base-url=http://$P_NAME.loc/ \
      # --base-url-secure=https://$P_NAME.loc/"
  fi
}

M1Reindex() {
  PNameLocal

  NotifyInfo "Reindexando catalog_product_attribute..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_product_attribute" && NotifySuccess "catalog_product_attribute reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_product_attribute"

  NotifyInfo "Reindexando catalog_product_price..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_product_price" && NotifySuccess "catalog_product_price reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_product_price"

  NotifyInfo "Reindexando catalog_url..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_url" && NotifySuccess "catalog_url reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_url"

  NotifyInfo "Reindexando catalog_product_flat..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_product_flat" && NotifySuccess "catalog_product_flat reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_product_flat"

  NotifyInfo "Reindexando catalog_category_flat..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_category_flat" && NotifySuccess "catalog_category_flat reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_category_flat"

  NotifyInfo "Reindexando catalog_category_product..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalog_category_product" && NotifySuccess "catalog_category_product reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalog_category_product"

  NotifyInfo "Reindexando catalogsearch_fulltext..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex catalogsearch_fulltext" && NotifySuccess "catalogsearch_fulltext reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar catalogsearch_fulltext"

  NotifyInfo "Reindexando cataloginventory_stock..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex cataloginventory_stock" && NotifySuccess "cataloginventory_stock reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar cataloginventory_stock"

  NotifyInfo "Reindexando tag_summary..."
  MExecute "cd $P_NAME/shell && php indexer.php --reindex tag_summary" && NotifySuccess "tag_summary reindexado com sucesso" || NotifyError "Por algum motivo acima não foi possível reindexar tag_summary"
}

GitMigrate() {
  PNameLocal

  DIR_LOJA=$M_PATH/data/www/$P_NAME

  NotifyInfo "Acessando diretório da loja $DIR_LOJA"
  cd $DIR_LOJA

  sed -i "s/git@gitlab.com:/git@git2bis.com.br:/g" composer.json && NotifySuccess "Arquivo composer.json migrado com sucesso" || NotifyError "Por algum motivo acima não foi possível migrar o arquivo composer.json"

  sed -i "s/https:\/\/gitlab.com\//https:\/\/git2bis.com.br\//g" composer.json && NotifySuccess "Arquivo composer.json migrado com sucesso" || NotifyError "Por algum motivo acima não foi possível migrar o arquivo composer.json"

  if [ -f "$DIR_LOJA/composer.lock" ]; then
    sed -i "s/git@gitlab.com:/git@git2bis.com.br:/g" composer.lock && NotifySuccess "Arquivo composer.lock migrado com sucesso" || NotifyError "Por algum motivo acima não foi possível migrar o arquivo composer.lock"

    sed -i "s/https:\/\/gitlab.com\//https:\/\/git2bis.com.br\//g" composer.lock && NotifySuccess "Arquivo composer.lock migrado com sucesso" || NotifyError "Por algum motivo acima não foi possível migrar o arquivo composer.lock"
  fi
}

InstalarLojaM15() {
  GIT2BIS_STORES_URL=$GIT2BIS_M15_STORES_URL

  Git2bisTypeStoreName

  GIT_URL="git@git2bis.com.br:bis2bis/bis2bis-stores/$G_NAME.git"

  Notify "Clonando loja"
  GitClone

  Notify "Migrando para git2bis.com.br"
  GitMigrate

  # Notify "Instalação composer"
  # ComposerInstall && NotifySuccess "Instalação composer realizada com sucesso!" || NotifyError "Ops! Não foi possível realizar a instalação composer. Verifique os logs acima."

  Notify "Executando composer update"
  ComposerUpdate

  Notify "Executando compass"
  CompassCompile

  Notify "Executando Dump"
  Dump

  Notify "Copiando arquivos"
  StoreFiles

  Notify "Adicionando host"
  AddHost

  Notify "Reindexando índices"
  M1Reindex

  LojaInstalada ${P_NAME}

  GoHome
}

InstalarLojaM19() {
  GIT2BIS_STORES_URL=$GIT2BIS_M19_STORES_URL

  Git2bisTypeStoreName

  GIT_URL="git@git2bis.com.br:bis2bis/bis2bis-stores/magento-1.9/$G_NAME.git"

  Notify "Clonando loja"
  GitClone

  Notify "Migrando para git2bis.com.br"
  GitMigrate

  # Notify "Instalação composer"
  # ComposerInstall

  Notify "Executando composer update"
  ComposerUpdate

  Notify "Executando compass"
  CompassCompile

  Notify "Executando Dump"
  Dump

  Notify "Copiando arquivos"
  StoreFiles

  Notify "Adicionando host"
  AddHost

  LojaInstalada ${P_NAME}

  GoHome
}

InstalarLojaM24() {
  GIT2BIS_STORES_URL=$GIT2BIS_M24_STORES_URL

  Git2bisTypeStoreName

  GIT_URL="git@git2bis.com.br:bis2bis/m2/lojas/$G_NAME.git"

  Notify "Clonando loja"
  GitClone

  Notify "Migrando para git2bis.com.br"
  GitMigrate

  Notify "Adicionando host"
  AddHost

  # Notify "Adicionando túnel http no NGROK"
  # AddNgrokHttpTunnel

  # Notify "Instalação composer"
  # ComposerInstall

  Notify "Executando composer update"
  ComposerUpdate

  Notify "Executando Dump"
  Dump

  Notify "Configurando Loja"
  configM2Store

  # Notify "Executando Dump"
  # Dump

  Notify "Desabilitando módulo"
  M2DisableModule "Magento_TwoFactorAuth"

  Notify "Limpando/Liberando cache"
  M2CleanCache

  Notify "Atualizando, aguarde..."
  AtualizaM2

  Notify "Deploy, aguarde..."
  deployM2Store

  NotifyInfo "Configurando usuário local"
  MExecute "cd $P_NAME && $BIN_MAGENTO admin:user:create \
    --admin-user=$M2_ADMIN_USER \
    --admin-password=$M2_ADMIN_PASS \
    --admin-email=$M2_ADMIN_USER@$P_NAME.loc \
    --admin-firstname=Local \
    --admin-lastname=Admin" && NotifySuccess "Usuário local configurado com sucesso" || NotifyError "Por algum motivo acima não foi possível configurar o usuário local"

  LojaInstalada ${P_NAME}

  GoHome
}

LojaInstalada() {
  PNameLocal

  Notify "Loja $P_NAME instalada com sucesso!

	URL's de acesso local:

		Loja: https://$P_NAME.loc

		Admin: https://$P_NAME.loc/admin
		Login: $LOCAL_ADMIN_USER
		Senha: $LOCAL_ADMIN_PASS"

  if [ $MAGENTO == 2 ]; then
    Notify "Versão do magento:"
    MExecute "cd $P_NAME && $BIN_MAGENTO --version"
  fi
}

AddNgrokHttpTunnel() {
  PNameLocal

  NotifyInfo "Validando outro(s) túnel(eis) NGROK"
  if [[ $(grep "$P_NAME.loc" $V_M2_ENV_FILE | wc -l) == 0 ]]; then
    NGROK_TUNNEL_TMP=$P_NAME.loc:httpd:80
    NotifyInfo "Adicionando loja $P_NAME.loc na variável de ambiente NGROK_HTTP_TUNNELS"
    if [[ $(grep "^NGROK_HTTP_TUNNELS=$" $V_M2_ENV_FILE | wc -l) == 0 ]]; then
      sed -i "s/^NGROK_HTTP_TUNNELS=/NGROK_HTTP_TUNNELS=$NGROK_TUNNEL_TMP,/g" $V_M2_ENV_FILE
      NGROK_HTTP_TUNNELS=$NGROK_TUNNEL_TMP,$NGROK_HTTP_TUNNELS
    else
      sed -i "s/^NGROK_HTTP_TUNNELS=/NGROK_HTTP_TUNNELS=$NGROK_TUNNEL_TMP/g" $V_M2_ENV_FILE
      NGROK_HTTP_TUNNELS=$NGROK_TUNNEL_TMP
    fi
    NotifyRedAlert "Favor reiniciar os containeres do Magento 2 (terminal -> vessel s2 -> ENTER) para que o túnel seja aplicado"
  fi
}

StoreFiles() {
  PNameLocal

  NotifyInfo "Copiando local.xml"
  cp -f ${V_PATH}/utils/local.xml ${M_WWW_PATH}/${P_NAME}/app/etc/local.xml && NotifySuccess "Arquivo local.xml copiado com sucesso para o diretório app/etc/" || NotifyError "Por algum motivo acima não foi possível copiar o arquivo local.xml para o diretório app/etc/"

  NotifyInfo "Ajustando a senha do local.xml"
  sed -i "s/VESSEL_VAI_MUDAR/$P_NAME/g" ${M_WWW_PATH}/${P_NAME}/app/etc/local.xml && NotifySuccess "Ajustada a senha do arquivo local.xml com sucesso" || NotifyError "Por algum motivo acima não foi possível ajustar a senha do arquivo local.xml"
}

RemoveLoja() {
  PNameLocal

  NotifyAsk "Tem certeza que deseja remover a loja $P_NAME?"
  NotifyInfo "Digite s para confirmar ou n para cancelar, depois tecle ENTER"
  echo ""

  read YON
  case "$YON" in
    y | yes | Y | YES | s | sim | S | SIM | "")
    clear

    NotifyInfo "Excluindo base de dados $P_NAME"
    MExecute "$MySQLConn -e 'DROP DATABASE IF EXISTS $P_NAME;'" && NotifySuccess "Base de dados $P_NAME excluída com sucesso" || NotifyError "Por algum motivo acima a base de dados não foi excluída"

    NotifyInfo "Excluindo arquivos da loja $P_NAME"
    MExecute "sudo rm -rf $P_NAME" && NotifySuccess "Arquivos da loja $P_NAME excluídos com sucesso" || NotifyError "Por algum motivo acima não foi possível excluir os arquivos da loja $P_NAME"

    NotifyInfo "Excluindo a URL $P_NAME.loc de /etc/hosts"
    if [[ $(grep "^127.0.0.1 $P_NAME.loc$" /etc/hosts | wc -l) == 1 ]]; then
      withSudo "sed -i '/127.0.0.1 $P_NAME.loc/d' /etc/hosts" && NotifySuccess "URL $P_NAME.loc excluída de /etc/hosts" || NotifyError "Por algum motivo acima não foi possível excluir a URL $P_NAME.loc de /etc/hosts"
    else
      Notify "URL $P_NAME.loc não encontrada em /etc/hosts"
    fi

    # if [ $MAGENTO == 2 ]; then
    #   NotifyInfo "Verificando a URL $P_NAME.loc em $V_M2_ENV_FILE"
    #   NGROK_URL="$P_NAME.loc:httpd:80"
    #   if [[ $(grep "$P_NAME.loc" $V_M2_ENV_FILE | wc -l) == 1 ]]; then
    #     NotifyInfo "Excluindo a URL $NGROK_URL de $V_M2_ENV_FILE"
    #     withSudo "sed -i '/$NGROK_URL/d' $M2_ENV_FILE" && NotifySuccess "URL $NGROK_URL excluída de $V_M2_ENV_FILE" || NotifyError "Por algum motivo acima não foi possível excluir a URL $NGROK_URL de $V_M2_ENV_FILE"
    #   else
    #     Notify "URL $P_NAME.loc não encontrada em $V_M2_ENV_FILE"
    #   fi

    #   NotifyInfo "Verificando vírgulas duplas ,, em $V_M2_ENV_FILE"
    #   if [[ $(grep ",," $V_M2_ENV_FILE | wc -l) == 1 ]]; then
    #     NotifyInfo "Removendo vírgulas duplas"
    #     withSudo "sed -i 's/,,/,/g' $M2_ENV_FILE" && NotifySuccess "Vírgulas duplas removidas com sucesso" || NotifyError "Por algum motivo acima não foi possível remover as vírgulas duplas"
    #   else
    #     Notify "Não foram encontradas vírgulas duplas ,, na variável de ambiente NGROK_HTTP_TUNNELS de $V_M2_ENV_FILE"
    #   fi

    #   NotifyInfo "Verificando vírgula única , em $V_M2_ENV_FILE"
    #   if [[ $(grep "NGROK_HTTP_TUNNELS=," $V_M2_ENV_FILE | wc -l) == 1 ]]; then
    #     NotifyInfo "Limpando variável de ambiente NGROK_HTTP_TUNNELS"
    #     withSudo "sed -i 's/NGROK_HTTP_TUNNELS=,/NGROK_HTTP_TUNNELS=/g' $M2_ENV_FILE" && NotifySuccess "Variável de ambiente NGROK_HTTP_TUNNELS limpada com sucesso" || NotifyError "Por algum motivo acima não foi possível limpar a variável de ambiente NGROK_HTTP_TUNNELS"
    #   else
    #     Notify "Não foi encontrada vírgula simples , na variável de ambiente NGROK_HTTP_TUNNELS de $V_M2_ENV_FILE"
    #   fi
    # fi

    NotifySuccess "Loja excluida com sucesso"
    ;;
  n | no | N | NO | não | NÃO)
    Main
    ;;
  *)
    NotifyError "Ops! Opção inválida. Voltando..."
    sleep 2
    Main
    ;;
  esac
}

MStartLog() {
  NotifyInfo "Inicializando containers do Magento $MAGENTO com logs"
  cd ${M_PATH} && docker-compose up
}

gitSetBranch() {
  NotifyInfo "Acesse https://git2bis.com.br/-/jira_connect/branches/new?issue_key=feature-hotfix-release-evnnn-action-taken-description para gerar uma nova branch.\n"

  GIT_BRANCH="master"
  if [ $MAGENTO == 2 ]; then
    GIT_BRANCH="main"
  fi

  NotifyAsk "Digite o nome de uma branch existente no repositório e tecle ENTER para continuar,"
  Notify "ou apenas tecle ENTER para continuar da branch $GIT_BRANCH padrão.\n"
  read BRANCH_NAME
  case "$BRANCH_NAME" in
    *)
      if [ ! -z "$BRANCH_NAME" ]; then
        GIT_BRANCH="$BRANCH_NAME"
      fi
      ;;
  esac
}

GitClone() {
  gitSetBranch

  if [ ! -d "$M_WWW_PATH/$P_NAME" ]; then
    NotifyInfo "Clonando a loja $P_NAME"
    git clone $GIT_URL ${M_WWW_PATH}/$P_NAME --branch="$GIT_BRANCH" && NotifySuccess "Loja $P_NAME clonada com sucesso" || NotifyError "Por algum motivo acima não foi possível clonar a loja $P_NAME"
  else
    NotifyInfo "Atualizando repositório"
    cd "$M_WWW_PATH/$P_NAME"&& git fetch && NotifySuccess "Repositorio já clonado e atualizado" || NotifyError "Por algum motivo acima não foi possível atualizar o repositório já clonado"
  fi

  NotifyInfo "Aplicando permissões em todos os arquivos/pastas da loja"
  MExecute "cd $P_NAME && sudo chown -R :www-data ." && NotifySuccess "Permissões aplicadas com sucesso" || NotifyError "Por algum motivo acima não foi possível aplicar as permissões"

  # NotifyInfo "Acessando diretório bin da loja e aplicando permissões no arquivo executável 'bin/magento' da loja"
  # MExecute "cd $P_NAME && sudo chmod u+x bin/magento" && NotifySuccess "Permissões aplicadas com sucesso" || NotifyError "Por algum motivo acima não foi possível aplicar as permissões"
}

MCertbot() {
  PNameLocal

  NotifyInfo "Adicionando certificado"
  M1Execute "sudo certbot --nginx -d $P_NAME.loc --register-unsafely-without-email --agree-tos"
  M1Execute "sudo certbot renew --dry-run"
}
