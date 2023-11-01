#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Rodrigo Miguel Cosme dos Santos  Nº: a111255     Nome: Rodrigo Miguel Cosme dos Santos
## Nome do Módulo: regista_utilizador.sh
## Descrição/Explicação do Módulo: Os comentrários estao ao lado das implementações
##
##
###############################################################################

#1

#1.1

#1.1.1 avalia se há 3 ou 4 argumentos (nome, senha, saldo a adicionar e NIF (opcional)), se sim dá success 1.1.1, caso contrário dá erro 1.1.1 e termina
(( $# == 3 || $# == 4 )) && ./success 1.1.1 || { ./error 1.1.1; exit 1; } 


#1.1.2 verifica se o nome $1 inserido pertence há base de dados de utilizadores, se sim dá success 1.1.2, caso contrário dá erro 1.1.2 e termina
cut -d: -f5  /etc/passwd | cut -d, -f1 | grep -xq "$1" && ./success 1.1.2 ||  { ./error 1.1.2; exit 1; } 

#1.1.3 verifica se o saldo a adicionar $3 é um número inteiro maior que zero, se for dá success 1.1.3, caso contrário dá erro 1.1.3 e termina
[[ $3 =~ ^-?[0-9]+$ && $3 -ge 0 ]] && ./success 1.1.3 || { ./error 1.1.3; exit 1; }

#verifica se o NIF existe e verifica se tem 9 números, se sim dá success 1.1.4, tem  caso contrario dá erro 1.1.4 e termina
[[ ${#4} == 9 &&  $4 =~ ^-?[0-9]+$ ]] && ./success 1.1.4 || { [[ $4 ]] && ./error 1.1.4 && exit 1; } 

#1.2

#1.2.1 1.2.2 verifica se o ficheiro utilizadores.txt exsite, caso exista dá success 1.2.1, caso não existe cria-se um no novo ficheiro utilizadores.txt, se não for executável dá erro 1.2.2 e termina o programa
[[ -f utilizadores.txt ]] &&  ./success 1.2.1 ||  { ./error 1.2.1 && > utilizadores.txt && ./success 1.2.2  || { ./error 1.2.2 && exit 1; } }

#1.2.3 verifica se o Nome passado existe no ficheiro utilizadores.txt, caso exista dá success 1.2.3, caso contrário dá error 1.2.3 e verifica se existe NIF, se sim dá success 1.2.4, caso contrário dá error 1.2.4 e termina o programa
if cut -d: -f2  utilizadores.txt | grep -xq "$1"; then 
    ./success 1.2.3

    #1.3

   #1.3.1 cria uma nova string OldLine com o conteúdo da linha com o mesmo nome $1 no utilizadores.txt, e retira a senha registada nessa linha, depois compara a linha registada com a linha inserida, se for a mesma dá success 1.3.1, se não dá erro 1.3.1
    oldLine=$( awk -F: '{ if ($2 == "'"$1"'") print }' utilizadores.txt ); 
    senha1=$( echo $oldLine | cut -d: -f3 ); 
    [[ $2 == $senha1 ]] && ./success 1.3.1 || { ./error 1.3.1; exit 1; }
    
    #1.3.2 guarda o valor do saldo,e adiciona o saldo a adicionar, depois troca o valor antigo do saldo pelo novo saldo na linha, se der certo dá success 1.3.2 $NewSaldo, caso contrário dá error 1.3.1
    oldSaldo=$( echo $oldLine | cut -d: -f6 ); 
    (( newSaldo = $oldSaldo + $3 )); 
    newLine="$( echo $oldLine | awk -F: -v OFS=: '{$6="'"$newSaldo"'"; print}' )"; 
    sed -i "s/$oldLine/$newLine/" utilizadores.txt && ./success 1.3.2 $newSaldo || { ./error 1.3.2; exit 1; }

else 
    ./error 1.2.3
    if  [[ $# == 4 ]]; then
        ./success 1.2.4
   #1.2.5 se utilizadores.txt esitver vazio, dá erro 1.2.5 'ID' e coloca o ID_utilizador a 1, caso contrário calcula o próximo ID, dá success 1.2.5 'ID'
    ! [[ -s utilizadores.txt ]] &&  id1=1 &&  ./error 1.2.5 $id1 ||  id1=$(($(tail -1 utilizadores.txt | cut -f1 -d':') +1)) && ./success 1.2.5 $id1 

    #1.2.6 cria um array 'a' com o conteúdo de $1 tira do $1 o primeiro e último nome (String) e coloca um '.' no meio e acrescente o domínio kiosk-iul.pt, se tudo der certo dá success 1.2.6 'email', caso contrario dá error 1.2.6 e termina
    a=($1) && email1="${a[0],,}.${a[${#a[@]} - 1],,}@kiosk-iul.pt" && ./success 1.2.6 $email1 || { ./error 1.2.6; exit 1; }


    #1.2.7 junto as variávis ID, Nome, Senha, email, NIF e saldo ($id1, $1, $2, $email1, $4 e $3) tudo numa string com ':' a separar e escrevo no utilizadores.txt, se der certo dá success 1.2.7 ID (número da linha), se der errado dá error 1.2.7 e termina
    linha="$id1:$1:$2:$email1:$4:$3"
    echo $linha >> utilizadores.txt && ./success 1.2.7 "$linha" || { ./error 1.2.7 && exit 1; }
    
    else    
        ./error 1.2.4 
        exit 1
    fi
fi
   
#1.4

#1.4.1 organiza o ficheiro utilizadores.txt por ordem numérica decrescente do valor de saldo (t: -k6) e cria um novo ficheiro saldos-ordenados.txt com essa ordenação, e der certo dá success 1.4.1 caso contrário dá error 1.4.1 e termina
sort -nrt: -k6 utilizadores.txt > saldos-ordenados.txt && ./success 1.4.1 || { ./error 1.4.1 && exit 1; }