#!/bin/sh

M2Start() {
  NotifyInfo "Configurando variável de ambiente MAGENTO.\n"
  if [ -z $MAGENTO ]; then
    sed -i "s/MAGENTO=/MAGENTO=2/g" $V_PATH/.env
  else
    sed -i "s/MAGENTO=1/MAGENTO=2/g" $V_PATH/.env
  fi

  StopContainers

  NotifyInfo "Inicializando containers do Magento 2"
  cd ${V_M2_PATH} && docker-compose up -d

  MAGENTO=2
  M_PATH=$V_M2_PATH
  M_WWW_PATH=$V_M2_WWW_PATH
  M_ENV_FILE=$V_M2_ENV_FILE
}

M2DeveloperEnable() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  NotifyInfo "deploy:mode:set developer"
  MExecute "$MAGENTO_EXEC deploy:mode:set developer"
}

M2ScheduleEnable() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  NotifyInfo "indexer:set-mode schedul"
  MExecute "$MAGENTO_EXEC indexer:set-mode schedule"
}

M2RewritesEnable() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  NotifyInfo "urlrewrites:regenerate"
  MExecute "$MAGENTO_EXEC ok:urlrewrites:regenerate"
}

M2CleanCache() {
  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  # NotifyInfo "Removendo cache (rm -rf...)"
  # withSudo "rm -rf var/cache/* pub/static/frontend/* pub/static/adminhtml/* var/page_cache/* var/di/*"

  NotifyInfo "Limpando cache (cache:clean)"
  MExecute "$MAGENTO_EXEC cache:clean"

  NotifyInfo "Liberando cache (cache:flush)"
  MExecute "$MAGENTO_EXEC cache:flush"
}

AtualizaM2() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  Notify "Atualizando, aguarde..."

  M2CleanCache

  NotifyInfo "Aplicando permissões em todos os arquivos/pastas da loja"
  MExecute "cd $P_NAME && sudo chown -R :www-data ." && NotifySuccess "Permissões aplicadas com sucesso" || NotifyError "Por algum motivo acima não foi possível aplicar as permissões"

  NotifyInfo "Atualizando configuração (setup:upgrade)"
  MExecute "$MAGENTO_EXEC setup:upgrade"

  NotifyInfo "Compilando configuração (setup:di:compile)"
  MExecute "$MAGENTO_EXEC setup:di:compile"
}

M2DisableModule() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  NotifyInfo "Desabilitando módulo $1"
  MExecute "$MAGENTO_EXEC module:disable $1 -f --clear-static-content"
}

configM2Store() {
  PNameLocal

  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  # NotifyInfo "Removendo base de dados $P_NAME, se houver"
  # MExecute "$MySQLConn -e 'DROP DATABASE IF EXISTS $P_NAME;'" && NotifySuccess "Base de dados $P_NAME removida com sucesso" || NotifyError "Não foi encontrada a base de dados $P_NAME para removê-la"

  NotifyInfo "Criando base de dados $P_NAME"
  MExecute "$MySQLConn -e 'CREATE DATABASE IF NOT EXISTS $P_NAME;'" && NotifySuccess "Base de dados $P_NAME criada com sucesso" || NotifyError "Por algum motivo acima não foi possível criar a base de dados $P_NAME"

  # NotifyInfo "Definindo URL's"
  # MExecute "$MAGENTO_EXEC setup:store-config:set \
  #   --base-url=http://$P_NAME.loc/ \
  #   --base-url-secure=https://$P_NAME.loc/"

  Notify "Iniciando fase 1 -> setup:install da loja"

  MExecute "$MAGENTO_EXEC setup:install \
    --db-host=mysql \
    --db-name=$P_NAME \
    --db-user=root \
    --db-password=magento \
    --admin-firstname=Install \
    --admin-lastname=Magento2 \
    --admin-email=install@$P_NAME.loc \
    --admin-user=install \
    --admin-password=install123 \
    --language=pt_BR \
    --currency=BRL \
    --timezone=America/Sao_Paulo \
    --use-rewrites=1 \
    --use-secure=1 \
    --use-secure-admin=1 \
    --backend-frontname=admin \
    --cache-backend=redis \
    --cache-backend-redis-server=redis \
    --cache-backend-redis-port=6379 \
    --cache-backend-redis-password=redis \
    --cache-backend-redis-db=0 \
    --page-cache=redis \
    --page-cache-redis-server=redis \
    --page-cache-redis-port=6379 \
    --page-cache-redis-password=redis \
    --page-cache-redis-db=1 \
    --session-save=redis \
    --session-save-redis-host=redis \
    --session-save-redis-port=6379 \
    --session-save-redis-password=redis \
    --session-save-redis-db=2 \
    --session-save-redis-log-level=4" && NotifySuccess "Fase 1 concluída com sucesso" || NotifyError "Por algum motivo acima não foi possível concluir a fase 1 \
    --search-engine=elasticsearch \
    --elasticsearch-host=localhost \
    --elasticsearch-port=9200 \
    --elasticsearch-index-prefix=magento \
    --elasticsearch-timeout=15"

  NotifyInfo "Configurando URL unsecure"
  MExecute "$MAGENTO_EXEC config:set web/unsecure/base_url 'http://$P_NAME.loc/'"

  NotifyInfo "Configurando URL secure"
  MExecute "$MAGENTO_EXEC config:set web/secure/base_url 'https://$P_NAME.loc/'"

  Notify "Iniciando fase 2 -> config:set da loja"

  NotifyInfo "Configurando admin/dashboard/enable_charts"
  MExecute "$MAGENTO_EXEC config:set admin/dashboard/enable_charts 1 "
  NotifyInfo "Configurando admin/security/admin_account_sharing"
  MExecute "$MAGENTO_EXEC config:set admin/security/admin_account_sharing 1"
  NotifyInfo "Configurando admin/security/lockout_failures"
  MExecute "$MAGENTO_EXEC config:set admin/security/lockout_failures '0'"
  NotifyInfo "Configurando admin/security/lockout_threshold"
  MExecute "$MAGENTO_EXEC config:set admin/security/lockout_threshold ''"
  NotifyInfo "Configurando admin/security/password_is_forced"
  MExecute "$MAGENTO_EXEC config:set admin/security/password_is_forced 0"
  NotifyInfo "Configurando admin/security/password_lifetime"
  MExecute "$MAGENTO_EXEC config:set admin/security/password_lifetime ''"
  NotifyInfo "Configurando admin/security/session_lifetime"
  MExecute "$MAGENTO_EXEC config:set admin/security/session_lifetime 31536000"
  NotifyInfo "Configurando admin/security/use_form_key"
  MExecute "$MAGENTO_EXEC config:set admin/security/use_form_key 0"
  # NotifyInfo "Configurando analytics/subscription/enabled"
  # MExecute "$MAGENTO_EXEC config:set analytics/subscription/enabled 0"
  NotifyInfo "Configurando catalog/custom_options/date_fields_order"
  MExecute "$MAGENTO_EXEC config:set catalog/custom_options/date_fields_order 'd,m,y'"
  NotifyInfo "Configurando catalog/custom_options/time_format"
  MExecute "$MAGENTO_EXEC config:set catalog/custom_options/time_format '24h'"
  NotifyInfo "Configurando catalog/seo/category_url_suffix"
  MExecute "$MAGENTO_EXEC config:set catalog/seo/category_url_suffix ''"
  NotifyInfo "Configurando catalog/seo/product_url_suffix"
  MExecute "$MAGENTO_EXEC config:set catalog/seo/product_url_suffix ''"
  NotifyInfo "Configurando cataloginventory/options/show_out_of_stock"
  MExecute "$MAGENTO_EXEC config:set cataloginventory/options/show_out_of_stock 1"
  NotifyInfo "Configurando customer/password/lockout_failures"
  MExecute "$MAGENTO_EXEC config:set customer/password/lockout_failures 0"
  NotifyInfo "Configurando customer/password/lockout_threshold"
  MExecute "$MAGENTO_EXEC config:set customer/password/lockout_threshold 0"
  NotifyInfo "Configurando customer/password/required_character_classes_number"
  MExecute "$MAGENTO_EXEC config:set customer/password/required_character_classes_number 2"
  NotifyInfo "Configurando dev/image/default_adapter"
  MExecute "$MAGENTO_EXEC config:set dev/image/default_adapter IMAGEMAGICK"
  NotifyInfo "Configurando general/country/allow"
  MExecute "$MAGENTO_EXEC config:set general/country/allow BR"
  NotifyInfo "Configurando general/country/default"
  MExecute "$MAGENTO_EXEC config:set general/country/default BR"
  NotifyInfo "Configurando general/country/destinations"
  MExecute "$MAGENTO_EXEC config:set general/country/destinations BR"
  NotifyInfo "Configurando general/country/optional_zip_countries"
  MExecute "$MAGENTO_EXEC config:set general/country/optional_zip_countries BR"
  NotifyInfo "Configurando general/locale/code"
  MExecute "$MAGENTO_EXEC config:set general/locale/code pt_BR"
  NotifyInfo "Configurando general/locale/timezone"
  MExecute "$MAGENTO_EXEC config:set general/locale/timezone America/Sao_Paulo"
  NotifyInfo "Configurando general/locale/weight_unit"
  MExecute "$MAGENTO_EXEC config:set general/locale/weight_unit kgs"
  NotifyInfo "Configurando general/region/display_all"
  MExecute "$MAGENTO_EXEC config:set general/region/display_all 1"
  NotifyInfo "Configurando general/region/state_required"
  MExecute "$MAGENTO_EXEC config:set general/region/state_required BR"
  NotifyInfo "Configurando general/single_store_mode/enabled"
  MExecute "$MAGENTO_EXEC config:set general/single_store_mode/enabled 1"
  NotifyInfo "Configurando general/store_information/country_id"
  MExecute "$MAGENTO_EXEC config:set general/store_information/country_id BR"
  NotifyInfo "Configurando general/store_information/region_id"
  MExecute "$MAGENTO_EXEC config:set general/store_information/region_id 499"
  NotifyInfo "Configurando general/store_information/name"
  MExecute "$MAGENTO_EXEC config:set general/store_information/name 'Bis2bis E-commerce'"
  NotifyInfo "Configurando general/store_information/phone"
  MExecute "$MAGENTO_EXEC config:set general/store_information/phone '43 3326-1500'"
  NotifyInfo "Configurando general/store_information/postcode"
  MExecute "$MAGENTO_EXEC config:set general/store_information/postcode '86050-435'"
  NotifyInfo "Configurando general/store_information/city"
  MExecute "$MAGENTO_EXEC config:set general/store_information/city 'Londrina'"
  NotifyInfo "Configurando general/store_information/street_line1"
  MExecute "$MAGENTO_EXEC config:set general/store_information/street_line1 'Av Theodoro Victorelli, 150'"
  NotifyInfo "Configurando general/store_information/merchant_vat_number"
  MExecute "$MAGENTO_EXEC config:set general/store_information/merchant_vat_number '10.738.352/0001-00'"
  NotifyInfo "Configurando oauth/access_token_lifetime/customer"
  MExecute "$MAGENTO_EXEC config:set oauth/access_token_lifetime/customer ''"
  NotifyInfo "Configurando oauth/access_token_lifetime/admin"
  MExecute "$MAGENTO_EXEC config:set oauth/access_token_lifetime/admin ''"
  NotifyInfo "Configurando oauth/consumer/expiration_period"
  MExecute "$MAGENTO_EXEC config:set oauth/consumer/expiration_period 31536000"
  NotifyInfo "Configurando sales_email/general/async_sending"
  MExecute "$MAGENTO_EXEC config:set sales_email/general/async_sending 1"
  NotifyInfo "Configurando sitemap/generate/enabled"
  MExecute "$MAGENTO_EXEC config:set sitemap/generate/enabled 1"
  NotifyInfo "Configurando sitemap/generate/time"
  MExecute "$MAGENTO_EXEC config:set sitemap/generate/time '02,00,00'"
  # NotifyInfo "Configurando sitemap/generate/frequency"
  # MExecute "$MAGENTO_EXEC config:set sitemap/generate/frequency Daily"
  NotifyInfo "Configurando sitemap/search_engines/submission_robots"
  MExecute "$MAGENTO_EXEC config:set sitemap/search_engines/submission_robots 1"
  NotifyInfo "Configurando shipping/origin/country_id"
  MExecute "$MAGENTO_EXEC config:set shipping/origin/country_id BR"
  NotifyInfo "Configurando shipping/origin/region_id"
  MExecute "$MAGENTO_EXEC config:set shipping/origin/region_id 499"
  NotifyInfo "Configurando shipping/origin/postcode"
  MExecute "$MAGENTO_EXEC config:set shipping/origin/postcode 86050-435"
  NotifyInfo "Configurando shipping/origin/city"
  MExecute "$MAGENTO_EXEC config:set shipping/origin/city Londrina"
  NotifyInfo "Configurando shipping/origin/street_line1"
  MExecute "$MAGENTO_EXEC config:set shipping/origin/street_line1 'Av. Theodoro Victorelli, 150'"
  NotifyInfo "Configurando system/backup/functionality_enabled"
  MExecute "$MAGENTO_EXEC config:set system/backup/functionality_enabled 1"
  NotifyInfo "Configurando system/currency/installed"
  MExecute "$MAGENTO_EXEC config:set system/currency/installed BRL"
  NotifyInfo "Configurando system/upload_configuration/jpeg_quality"
  MExecute "$MAGENTO_EXEC config:set system/upload_configuration/jpeg_quality 90"
  NotifyInfo "Configurando system/upload_configuration/max_height"
  MExecute "$MAGENTO_EXEC config:set system/upload_configuration/max_height 1080"
  NotifyInfo "Configurando web/seo/use_rewrites"
  MExecute "$MAGENTO_EXEC config:set web/seo/use_rewrites 1"
  NotifyInfo "Configurando web/secure/use_in_adminhtml"
  MExecute "$MAGENTO_EXEC config:set web/secure/use_in_adminhtml 1"
  NotifyInfo "Configurando web/secure/use_in_frontend"
  MExecute "$MAGENTO_EXEC config:set web/secure/use_in_frontend 1"

  Notify "Iniciando fase 3 -> etapas finais"

  NotifyInfo "Modo de aplicação atual é:"
  MExecute "$MAGENTO_EXEC deploy:mode:show"

  NotifyInfo "Configurando Modo de aplicação atual (deploy:mode:set)"
  # MExecute "$MAGENTO_EXEC deploy:mode:set default"
  MExecute "$MAGENTO_EXEC deploy:mode:set developer"
  # MExecute "$MAGENTO_EXEC deploy:mode:set production"

  NotifyInfo "Configurando elasticsearch7"
  MExecute "$MAGENTO_EXEC config:set catalog/search/engine 'elasticsearch7'"

  NotifyInfo "Modo de aplicação atual alterado para:"
  MExecute "$MAGENTO_EXEC deploy:mode:show"

  NotifyInfo "Modo de aplicação atual é:"
  MExecute "$MAGENTO_EXEC deploy:mode:show"

  NotifyInfo "Configurando indexer:set-mode schedule"
  MExecute "$MAGENTO_EXEC indexer:set-mode schedule"

  NotifyInfo "Configurando ok:urlrewrites:regenerate"
  MExecute "$MAGENTO_EXEC ok:urlrewrites:regenerate"
}

deployM2Store() {
  MAGENTO_EXEC="cd $P_NAME && $BIN_MAGENTO"

  NotifyInfo "Implantando configuração de conteúdo estático (setup:static-content:deploy pt_BR en_US -f)"
  MExecute "$MAGENTO_EXEC setup:static-content:deploy pt_BR en_US -f"
}
