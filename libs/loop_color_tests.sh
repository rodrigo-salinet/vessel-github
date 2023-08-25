#!/bin/bash

# Variáveis de Ambiente das cores de textos do vessel (Vessel Environments colors)

echo -e "default"

echo -e "\033[0m"

echo -e "\033[0m NC"

echo -e "\033[0m"

echo -e "\033[7;34m B_BLUE"

echo -e "\033[0m"

echo -e "\033[1;34m B_BLU"

echo -e "\033[0m"

echo -e "\033[1;31m B_RED"

echo -e "\033[0m"

echo -e "\033[7;31m B_LRED"

echo -e "\033[0m"

echo -e "\033[1;37m B_WHI"

echo -e "\033[0m"

echo -e "\033[1;33m B_YELLOW"

echo -e "\033[0m"

echo -e "\033[7;32m B_GREL"

echo -e "\033[0m"

echo -e "\033[1;32m B_GRE"

echo -e "\033[0m"

echo -e "\033[0;34m BLUE"

echo -e "\033[0m"

echo -e "\033[0;34m BLU"

echo -e "\033[0m"

echo -e "\033[0;31m RED"

echo -e "\033[0m"

echo -e "\033[0;31m LRED"

echo -e "\033[0m"

echo -e "\033[0;37m WHI"

echo -e "\033[0m"

echo -e "\033[0;33m YELLOW"

echo -e "\033[0m"

echo -e "\033[0;32m GREL"

echo -e "\033[0m"

echo -e "\033[0;32m GRE"

echo -e "\033[0m"

# ---------------------------------------

# Font styles tests

# 1 = default
# 2 = dark
# 3 = italic
# 4 = underline
# 5 = blink
# 6 = blink
# 7 = background
# 8 = transparent
# 9 = striked

for i in 1 2 3 4 5 6 7 8 9
do
    echo -e "---------------------------------------"

    echo -e "\e[0m"

    echo -e "\"$i\""

    echo -e "\e[0m"

    echo -e "\e[$i;30m Black"

    echo -e "\e[0m"

    echo -e "\e[$i;34m Blue"

    echo -e "\e[0m"

    echo -e "\e[$i;32m Green"

    echo -e "\e[0m"

    echo -e "\e[$i;36m Cyan"

    echo -e "\e[0m"

    echo -e "\e[$i;31m Red"

    echo -e "\e[0m"

    echo -e "\e[$i;35m Purple"

    echo -e "\e[0m"

    echo -e "\e[$i;33m Yellow"

    echo -e "\e[0m"
done

# Color tests

for i in 30m 31m 32m 33m 34m 35m 36m 37m 38m 39m 40m 41m 42m 43m 44m 45m 46m 47m 48m 49m 50m 51m 52m 53m 54m 55m 56m 57m 58m 59m 60m 61m 62m 63m 64m 65m 66m 67m 68m 69m 70m 71m 72m 73m 74m 75m 76m 77m 78m 79m 80m 81m 82m 83m 84m 85m 86m 87m 88m 89m 90m 91m 92m 93m 94m 95m 96m 97m 98m 99m 100m 101m 102m 103m 104m 105m 106m 107m
do
    echo -e "---------------------------------------"

    echo -e "\033[0m"

    echo -e "\"$i\""

    echo -e "\033[0m"

    echo -e "\033[0;$i Text \e[0m"

    echo -e ""
done
