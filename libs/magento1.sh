#!/bin/sh

M1Start() {
  NotifyInfo "Configurando variável de ambiente MAGENTO.\n"
  if [ -z $MAGENTO ]; then
    sed -i "s/MAGENTO=/MAGENTO=1/g" $V_PATH/.env
  else
    sed -i "s/MAGENTO=2/MAGENTO=1/g" $V_PATH/.env
  fi

  StopContainers

  NotifyInfo "Inicializando containers do Magento 1 sem logs"
  cd ${V_M1_PATH} && docker-compose up -d

  MAGENTO=1
  M_PATH=$V_M1_PATH
  M_WWW_PATH=$V_M1_WWW_PATH
  M_ENV_FILE=$V_M1_ENV_FILE
}

M1Certbot() {
  PNameLocal

  NotifyInfo "Adicionando certificado"
  MExecute "sudo certbot --nginx -d $P_NAME.loc --register-unsafely-without-email"
  MExecute "sudo certbot renew --dry-run"
}

LimparCache() {
  PNameLocal

  NotifyInfo "Limpando cache e sessão da loja $P_NAME"

  rm -rf ${M_WWW_PATH}/${P_NAME}/var/cache/* && rm -rf ${M_WWW_PATH}/${P_NAME}/var/session/* && NotifySuccess "Cache e sessão limpos" || NotifyError "Por algum motivo acima não foi possível limpar o cache e sessão"

  sleep 0.5 && GoHome
}

RemoveCookies() {
  PNameLocal

  ApagaVar

  NotifyInfo "Removendo cookies de domínio"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"\" WHERE path LIKE \"%cookie_domain%\";'" && NotifySuccess "Cookies de domínio removidos com sucesso" || NotifyError "Por algum motivo acima não foi possível remover os cookies de domínio"

  NotifyInfo "Removendo cookies regex"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"\" WHERE path LIKE \"%cookie_regex%\";'" && NotifySuccess "Cookies regex removidos com sucesso" || NotifyError "Por algum motivo acima não foi possível remover os cookies regex"

  NotifyInfo "Removendo cookies target"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"\" WHERE path LIKE \"%cookie_target%\";'" && NotifySuccess "Cookies target removidos com sucesso" || NotifyError "Por algum motivo acima não foi possível remover os cookies target"
}

DesativarJuntarCSS() {
  PNameLocal

  ApagaVar

  NotifyInfo "Ativando a opção Juntar Arquivos CSS"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE path LIKE \"%css%\" AND config_id = \"669\";'" && NotifySuccess "Opção Juntar Arquivos CSS desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Juntar Arquivos CSS"
}

DesativarRecaptchaIlitia() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando captcha do admin (ilitia)"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE path = \"admin/captcha/enable\";'" && NotifySuccess "Captcha do admin (ilitia) desativado com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar o captcha do admin (ilitia)"
}

DesativarJuntarJS() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando a opção Juntar Arquivos Javascript"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE path LIKE \"%javascript%\" AND config_id = \"445\";'" && NotifySuccess "Opção Juntar Arquivos Javascript desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Juntar Arquivos Javascript"
}

DesativarSufixo() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando a opção Sufix JS/CSS"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE path LIKE \"%css%\" AND config_id = \"1332\";'" && NotifySuccess "Opção Sufix JS/CSS desativada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Sufix JS/CSS"
}

AtivarHintsFront() {
  PNameLocal

  ApagaVar

  NotifyInfo "Ativando/inserindo a opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope, scope_id, path, value) VALUES (\"stores\", 1, \"dev/debug/template_hints\", \"1\");'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja ativada/inserida com sucesso" || NotifyError "Por algum motivo acima não foi possível inserir a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Ativando/atualizando a opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"1\" WHERE scope_id = 1 AND path = \"dev/debug/template_hints\";'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja ativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar/atualizar a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Ativando/inserindo a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope, scope_id, path, value) VALUES (\"stores\", 1, \"dev/debug/template_hints_blocks\", \"1\");'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja ativada/inserida com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"

  NotifyInfo "Ativando/inserindo a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"1\" WHERE scope_id = 1 AND path = \"dev/debug/template_hints_blocks\";'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja ativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar/atualizar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"
}

DesativarHintsFront() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando/atualizando a opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE scope_id = 1 AND path = \"dev/debug/template_hints\";'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Front/Loja desativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Desativando/atualizando a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE scope_id = 1 AND path = \"dev/debug/template_hints_blocks\";'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Front/Loja desativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"
}

AtivarHintsBack() {
  PNameLocal

  ApagaVar

  NotifyInfo "Ativando/inserindo a opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope, scope_id, path, value) VALUES (\"stores\", 0, \"dev/debug/template_hints\", \"1\");'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin ativada/inserida com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Ativando/atualizando a opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"1\" WHERE scope_id = 0 AND path = \"dev/debug/template_hints\";'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin ativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar/atualizar a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Ativando/inserindo a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'REPLACE INTO core_config_data (scope, scope_id, path, value) VALUES (\"stores\", 0, \"dev/debug/template_hints_blocks\", \"1\");'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin ativad/inserida com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"

  NotifyInfo "Ativando/atualizando a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"1\" WHERE scope_id = 0 AND path = \"dev/debug/template_hints_blocks\";'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin ativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível ativar/atualizar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"
}

DesativarHintsBack() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando/atualizando a opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE scope_id = 0 AND path = \"dev/debug/template_hints\";'" && NotifySuccess "Opção Exibir Caminho das Telas (Template Path Hints) de Back/Admin desativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar a opção Exibir Caminho das Telas (Template Path Hints)"

  NotifyInfo "Desativando/atualizando a opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin"
  MExecute "$MySQLConn $P_NAME -e 'UPDATE core_config_data SET value = \"0\" WHERE scope_id = 0 AND path = \"dev/debug/template_hints_blocks\";'" && NotifySuccess "Opção Exibir Nome dos Blocos (Add Block Names to Hints) de Back/Admin desativada/atualizada com sucesso" || NotifyError "Por algum motivo acima não foi possível adestivar a opção Exibir Nome dos Blocos (Add Block Names to Hints)"
}

DesativarCache() {
  PNameLocal

  ApagaVar

  NotifyInfo "Desativando cache do magento"
  MExecute "$MySQLConn $P_NAME -e 'DELETE FROM core_cache_option;'" && NotifySuccess "Cache do magento desativado com sucesso" || NotifyError "Por algum motivo acima não foi possível desativar o cache do magento"
}

setMediaProd() {
  PNameLocal

  NotifyInfo "Copiando arquivos do core do magento"
  cp -rf $V_PATH/utils/media_prod/* $M_WWW_PATH/$P_NAME/ && NotifySuccess "Arquivos do core do magento copiados com sucesso" || NotifyError "Por algum motivo acima não foi possível copiar os arquivos do core do magento"
}

setMediaLocal() {
  PNameLocal

  NotifyInfo "Copiando arquivos do core do magento"
  cp -rf $V_PATH/utils/media_local/* $M_WWW_PATH/$P_NAME/ && NotifySuccess "Arquivos do core do magento copiados com sucesso" || NotifyError "Por algum motivo acima não foi possível copiar os arquivos do core do magento"
}

installComposerModule() {
  PNameLocal

  NotifyAsk "Digite ou cole a URL SSH do repositório do módulo a ser instalado e tecle ENTER"
  read URL_SSH_REPOSITORY
  case $URL_SSH_REPOSITORY in
    "")
      NotifyError "URL SSH do repositório do módulo não foi informada. Voltando..."
      sleep 2
      Main
      ;;
    *)
      NotifyInfo "Capturando REPOSITORY_NAME env"
      IFS='/' read -ra ITEM <<< "$URL_SSH_REPOSITORY"
      for i in "${ITEM[@]}"; do
        if [[ $i == *".git"* ]]; then
          REPOSITORY_NAME=$(echo $i | sed 's/\.git//g' | sed 's/-//g')
        fi
      done
      ;;
  esac

  NotifyAsk "Digite ou cole a branch ou tag do repositório do módulo a ser instalado e tecle ENTER."
  Notify "Exemplos: dev-master, dev-1.0.0, 1.0.0, ^1"
  read BRANCH_REPOSITORY
  case $BRANCH_REPOSITORY in
    "")
      NotifyError "Branch/Tag do repositório do módulo não foi informada. Voltando..."
      sleep 2
      Main
      ;;
  esac

  NotifyAsk "Digite ou cole o NAMESPACE do repositório do módulo a ser instalado e tecle ENTER."
  Notify "Exemplos: phpcs, magestore..."
  read REPOSITORY_NAMESPACE
  case $REPOSITORY_NAMESPACE in
    "")
      NotifyError "NAMESPACE do repositório do módulo não foi informado. Voltando..."
      sleep 2
      Main
      ;;
  esac

  NotifyInfo "Adicionando o repositório do módulo ao composer.json da loja $P_NAME"
  JSON_REPOSITORY="\"$REPOSITORY_NAME\": {
      \"type\": \"vcs\",
      \"url\": \"$URL_SSH_REPOSITORY\"
    }"
  $V_PATH/utils/jq ".repositories += { $JSON_REPOSITORY }" $M_WWW_PATH/$P_NAME/composer.json > $M_WWW_PATH/$P_NAME/composer.json.tmp && mv $M_WWW_PATH/$P_NAME/composer.json.tmp $M_WWW_PATH/$P_NAME/composer.json && NotifySuccess "JSON do repositório adicionado com sucesso" || NotifyError "Por algum motivo acima não foi possível adicionar o JSON do repositório"

  NotifyInfo "Adicionando a branch do repositório do módulo ao composer.json da loja $P_NAME"
  JSON_REQUIRE="\"$REPOSITORY_NAMESPACE/$REPOSITORY_NAME\": \"$BRANCH_REPOSITORY\""
  $V_PATH/utils/jq ".require += { $JSON_REQUIRE }" $M_WWW_PATH/$P_NAME/composer.json > $M_WWW_PATH/$P_NAME/composer.json.tmp && mv $M_WWW_PATH/$P_NAME/composer.json.tmp $M_WWW_PATH/$P_NAME/composer.json && NotifySuccess "JSON da branch do repositório adicionado com sucesso" || NotifyError "Por algum motivo acima não foi possível adicionar o JSON da branch do repositório"

  NotifyInfo "Instalando módulo $REPOSITORY_NAME:$BRANCH_REPOSITORY. Aguarde..."
  ComposerUpdate && NotifySuccess "Módulo $REPOSITORY_NAME:$BRANCH_REPOSITORY instalado com sucesso" || NotifyError "Por algum motivo acima não foi possível instalar o módulo $REPOSITORY_NAME:$BRANCH_REPOSITORY"
}

VerEventosMage() {
  PNameLocal

  NotifyInfo "Copiando arquivo eventos.php para o diretório da loja $P_NAME"
  cp $V_PATH/utils/eventos.php $M_WWW_PATH/$P_NAME && NotifySuccess "Arquivo eventos.php copiado com sucesso" || NotifyError "Por algum motivo acima não foi possível copiar o arquivo eventos.php para o diretório da loja $P_NAME"

  Notify "Acesse https://$P_NAME.loc/eventos.php para ver todos os eventos registrados da loja $P_NAME"
}
