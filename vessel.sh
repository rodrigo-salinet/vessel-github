#!/bin/bash

Main() {
  if [ ! $@ ]; then
    CleanVars && sleep 0.2 && ShowMenu
    read opt
  else
    opt=$@
  fi

  case $opt in

  S1 | s1)

    clear && M1Start && GoHome
    ;;

  S2 | s2)

    clear && M2Start && GoHome
    ;;

  sc | SC)

    clear && StopContainers && GoHome
    ;;

  ssh | SSH)

    clear && SSH && GoHome
    ;;

  ILM15 | ilm15)

    clear && InstalarLojaM15 && GoHome
    ;;

  ILM19 | ilm19)

    clear && InstalarLojaM19 && GoHome
    ;;

  ILM24 | ilm24)

    clear && InstalarLojaM24 && GoHome
    ;;

  RL | rl)

    clear && RemoveLoja && GoHome
    ;;

  DUMP | dump)

    clear && Dump && GoHome
    ;;

  LC | lc)

    clear && LimparCache && GoHome
    ;;

  U | u)

    clear && UpdateVessel && GoHome
    ;;

  css | CSS | scss | SCSS)

    clear && MCompassWatch && GoHome
    ;;

  ZD | zd)

    clear && ZeraDocker && GoHome
    ;;

  cup | CUP)

    clear && ComposerUpdate && GoHome
    ;;

  cc1 | CC1)

    clear && CompassCompile && GoHome
    ;;

  xml1 | XML1)

    clear && StoreFiles && GoHome
    ;;

  cbt1 | CBT1)

    clear && M1Certbot && GoHome
    ;;

  clone1 | CLONE1)

    clear && M1Clone && GoHome
    ;;

  clone2 | CLONE2)

    clear && M2Clone && GoHome
    ;;

  rck | RCK)

    clear && RemoveCookies && GoHome
    ;;

  djcss | DJCSS)

    clear && DesativarJuntarCSS && GoHome
    ;;

  dri | DRI)

    clear && DesativarRecaptchaIlitia && GoHome
    ;;

  djjs | DJJS)

    clear && DesativarJuntarJS && GoHome
    ;;

  dsfx | DSFX)

    clear && DesativarSufixo && GoHome
    ;;

  ahf | AHT)

    clear && AtivarHintsFront && GoHome
    ;;

  dhf | DHT)

    clear && DesativarHintsFront && GoHome
    ;;

  ahb | AHT)

    clear && AtivarHintsBack && GoHome
    ;;

  dhb | DHT)

    clear && DesativarHintsBack && GoHome
    ;;

  dch | DCH)

    clear && DesativarCache && GoHome
    ;;

  dcup | DCUP)

    clear && MStartLog
    ;;

  amp | AMP)

    clear && setMediaProd && GoHome
    ;;

  aml | AML)
  
    clear && setMediaLocal && GoHome
    ;;

  Q | q | quit | QUIT | exit | EXIT)

    NotifyAsk "Digite s para sair ou n para voltar, depois tecle ENTER"

    read SNE
    case $SNE in
    y | yes | Y | YES | s | sim | S | SIM | "")
      clear && exit
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
    ;;

  hst | HST)

    clear && AddHost && GoHome
    ;;

  imc | IMC)

    clear && installComposerModule && GoHome
    ;;

  clm2 | CLM2)

    clear && configM2Store && GoHome
    ;;

  csdmg | CSDMG)

    clear && csdMergeAll && GoHome
    ;;

  ev | EV )

    clear && VerEventosMage && GoHome
    ;;

  ant | ANT )

    clear && AddNgrokHttpTunnel && GoHome
    ;;

  mig | MIG )

    clear && GitMigrate && GoHome
    ;;

  *)

    NotifyError "Ops! Opção inválida, voltando..."
    sleep 2
    Main
    ;;

  esac
}

V_PATH=$(dirname "$0")

cd ${V_PATH}

source ./libs/config.sh

#UpdateVessel

checkEnv

Main $@
