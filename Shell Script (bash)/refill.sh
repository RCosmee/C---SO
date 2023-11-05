#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Rodrigo Miguel Cosme dos Santos   Nº: a111255      Nome: Rodrigo Miguel Cosme dos Santos
## Nome do Módulo: refill.sh
## Descrição/Explicação do Módulo: Os comentrários estao ao lado das implementações
##
##
###############################################################################

#3

#3.1

#3.1.1 verifica a existência de produtos.txt e reposicão.txt, caso se verifique dá success 3.1.1, caso contrário dá erroe 3.1.1 e termina
[[ -f produtos.txt && -f reposicao.txt ]] && ./success 3.1.1 || { ./error 3.1.1 && exit 1; }

#3.1.2 guarda em $erroStock os produtos que tem em <Nr_Itens_a_Adicionar> algum !(NUMERO maior que zero), caso essa variável tenha algo lá, dá error 3.1.2 "nome produto" e termina, caso contrário dá success 3.1.2
erroStock=$( awk -F: '{ if (! ( $3 ~ /^-?[0-9]+$/ && $3 > 0 )) printf "*"$1"*" }' reposicao.txt ) && ! [[ -z $erroStock ]] && { ./error 3.1.2 "$erroStock" && exit 1; } || ./success 3.1.2

#3.2

#3.2.1 
echo "**** Produtos em falta em $(date +%F) ****" > produtos-em-falta.txt || { ./error 3.2.1 && exit 1; } #cria o ficheiro produtos-em-falta.txt e coloca na primeira linha "**** Produtos em falta em DATE ****", se der errado dá error 3.2.1 e termina
awk -F: '{ if ($5 - $4 > 0) print ""$1": "($5 - $4)" unidades" }' produtos.txt >> produtos-em-falta.txt && ./success 3.2.1 || { ./error 3.2.1 && exit 1; } #escreve em produtos-em-falta.txt o nome do produto e o stock que falta (caso exista), se der certo dá success 3.2.1, caso contrário dá error 3.2.1 e termina

#3.2.2
while read linhaRefill; do #enquanto recebe cada linha de reposicao.txt e guarda em $linhaRefill, faz o que esta a seguir
    nameStock=$( echo $linhaRefill | cut -d: -f1 ); #guarda em $nameStock o nome do produto que esta numa linha de reposicao.txt que esta agora guardada em $linhaRefill
    Stock=$( echo $linhaRefill | cut -d: -f3 );  #guarda em $Stock a quantidade de produto para repor que se encontra  numa linha de reposicao.txt que esta agora guardada em $linhaRefill

    oldLine=$( awk -F: '{ if ( $1 == "'"$nameStock"'" && $5 - $4 > 0 ) print }' produtos.txt ); #caso o produto em questão ($nameStock) exista e tenha um stock menor que o máximo possivel ($5 - $4 > 0), guarda a linha desse produto em reposição em $oldLine

    if ! [[ -z $oldLine ]]; then  #se $oldLine nao estiver valor (se tiver vazia)
        newLine="$( echo $oldLine | awk -F:  -v OFS=: '{ $4 += "'"$Stock"'"; if ( $4 > $5 ) $4 = $5; print}')"; #guarda em $newLine o que esta guardado em $oldLine mas mudando o stock atual pelo os stocks disponiveis em reposicao.txt, se o stock ultrupassar o valor do stock máximo, fica com o valor do stock máximo (if ($4 > $5) $4 = $5)
        sed -i "s/$oldLine/$newLine/" produtos.txt || { ./error 3.2.2 && exit 1; } #altera a linha do produto com o novo stock, se der errado dá error 3.2.2 e termina
    fi
done < reposicao.txt #escreve para o 'read' o ficheiro reposicao.txt linha a linha
./success 3.2.2 #caso tenha mudado ou nao os stocks, dá success 3.2.2

#3.3

#3.3.1 cron.def