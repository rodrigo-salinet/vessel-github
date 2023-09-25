#!/bin/sh

DbxStart() {
  NotifyInfo "Configurando variável de ambiente MAGENTO.\n"
  if [ -z $MAGENTO ]; then
    sed -i "s/MAGENTO=/MAGENTO=3/g" $V_PATH/.env
  else
    sed -i "s/MAGENTO=1/MAGENTO=3/g" $V_PATH/.env
  fi

  StopContainers

  NotifyInfo "Inicializando containers do Devilbox..."
  cd ${V_M3_PATH} && docker-compose up -d

  MAGENTO=3
  M_PATH=$V_M3_PATH
  M_WWW_PATH=$V_M3_WWW_PATH
  M_ENV_FILE=$V_M3_ENV_FILE
}
