#!/bin/bash

ShowMenu() {
    clear
    NotifyHeader "Vessel CLI $VER - A bash GUI for Bis2bis Development"

    Notify "Obs: todos os comandos abaixo podem ser utilizados diretamente pelo terminal
Por exemplo: se digitar '$YELLOW vessel s2 $NC' e teclar $YELLOW ENTER $NC (no terminal) irá (re)iniciar os containeres de lojas magento 2"

    NotifyTitle "COMANDOS DE USO GERAL"
    echo ""

    NotifyMenu "[ av     ]  Atualizar Vessel"
    NotifyMenu "[ q      ]  Sair"
    NotifyMenu "[ sc     ]  Parar containers"
    NotifyMenu "[ hst    ]  Adicionar loja ao Hosts"
    NotifyMenu "[ zd     ]  Zerar docker"
    NotifyMenu "[ mig    ]  Migração git2bis"

    NotifyTitle "COMANDOS DE MANUTENÇÃO DE CONTAINERES"
    echo ""

    NotifyMenu "[ s1     ]  (re)Inicializar containers magento1"
    NotifyMenu "[ s2     ]  (re)Inicializar containers magento2"
    NotifyMenu "[ ssh    ]  Acessar container via ssh"
    NotifyMenu "[ dcup   ]  Inicializar containers com logs"

    NotifyTitle "COMANDOS DE INSTALAÇÃO DE LOJA"
    echo ""

    NotifyMenu "[ dump   ]  Restaurar dump"
    NotifyMenu "[ imc    ]  Instalar módulo composer"
    NotifyMenu "[ ilm15  ]  Instalar loja 1.5"
    NotifyMenu "[ ilm19  ]  Instalar loja 1.9"
    NotifyMenu "[ ilm24  ]  Instalar loja 2.4"
    NotifyMenu "[ rl     ]  Remover loja"

    NotifyTitle "COMANDOS DE CONFIGURAÇÃO DE LOJA"
    echo ""

    if [  $MAGENTO == 1  ]; then
        NotifyMenu "[ djcss  ]  Desativar a opção Juntar Arquivos CSS"
        NotifyMenu "[ djjs   ]  Desativar a opção Juntar Arquivos JS"
        NotifyMenu "[ dri    ]  Desativar Recaptcha Ilitia"
        NotifyMenu "[ dsfx   ]  Desativar a opção Sufix JS/CSS"
    fi

    if [  $MAGENTO == 2  ]; then
        NotifyMenu "[ clm2   ]  Configurar Loja M2"
    fi

    if [  $MAGENTO == 1  ]; then
        NotifyTitle "COMANDOS DE FRONTEND/BACKEND DE LOJA"
        echo ""

        NotifyMenu "[ ahf    ]  Ativar Hints Front/Loja"
        NotifyMenu "[ dhf    ]  Desativar Hints Front/Loja"
        NotifyMenu "[ ahb    ]  Ativar Hints Back/Admin"
        NotifyMenu "[ dhb    ]  Desativar Hints Back/Admin"
    fi

    NotifyTitle "COMANDOS DE MANUTENÇÃO DE LOJA"
    echo ""

    NotifyMenu "[ cup    ]  Composer update"

    if [  $MAGENTO == 1  ]; then
        NotifyMenu "[ aml    ]  Ativar Media Local"
        NotifyMenu "[ amp    ]  Ativar Media Produção"
        NotifyMenu "[ cc1    ]  Compass compile"
        NotifyMenu "[ css    ]  Configurar o 'compass watch' em uma loja"
        NotifyMenu "[ dch    ]  Desativar Cache do Magento"
        NotifyMenu "[ lc     ]  Limpar cache"
        NotifyMenu "[ rck    ]  Remover Cookies"
        NotifyMenu "[ clone1 ]  Clonar Loja M1"
        NotifyMenu "[ csdmg  ]  Mergear branch master da loja CSD em todos os repositórios"
        NotifyMenu "[ ev     ]  Instalar visualizador de todos os eventos da loja"
    fi

    if [  $MAGENTO == 2  ]; then
        NotifyMenu "[ clone2 ]  Clonar Loja M2"
        NotifyMenu "[ ant    ]  Adicionar NGROK Tunel"
    fi

    Notify "As opções acima estão disponíveis apenas para lojas Magento $MAGENTO"

    NotifyInfo "Para acessar outras opções, reinicie os containers conforme a vesão do Magento [ s1 ou s2 ]"

    NotifyGreenAlert "Digite um dos comandos acima (exemplo: s1) e tecle ENTER"
}
