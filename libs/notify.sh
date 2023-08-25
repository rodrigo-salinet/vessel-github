#!/bin/bash

Notify() {
    if [[ $2 ]]; then
        echo -e "\n$2 $1 $NC"
    else
        echo -e "\n$WHI $1 $NC"
    fi
}

NotifyInfo() {
    echo -e "\n$B_BLU $1 $NC"
}

NotifySuccess() {
    echo -e "\n$B_GRE $1 $NC"
}

NotifyError() {
    echo -e "\n$B_RED $1 $NC"
}

NotifyAsk() {
    echo -e "\n$B_YELLOW $1 $NC"
}

NotifyRedAlert() {
    echo -e "\n$P_RED $1 $NC"
}

NotifyGreenAlert() {
    echo -e "\n$P_GRE $1 $NC"
}

NotifyTitle() {
    echo -e "\n$BG_BLUE $1 $NC"
}

NotifyHeader() {
    echo -e "\n$BG_GRE $1 $NC"
}

NotifyMenu() {
    echo -e "$YELLOW $1 $NC"
}
