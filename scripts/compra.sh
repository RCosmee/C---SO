#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Rodrigo Miguel Cosme dos Santos       Nº: a111255      Nome: Rodrigo Miguel Cosme dos Santos
## Nome do Módulo: compra.sh
## Descrição/Explicação do Módulo: Os comentrários estao ao lado das implementações
##
##
###############################################################################

#2

#2.1

#2.1.1 verifica se os ficheiros produtos.txt e utilizadores.txt existe, se sim dá success 2.1.1, caso contrário dá error 2.1.1 e termina
[[ -f produtos.txt && -f utilizadores.txt ]] && ./success 2.1.1 || { ./error 2.1.1 && exit 1; }

max=$( awk -F: 'BEGIN{i=0} { if ($4 > 0) ++i } END{print i}' produtos.txt); #se o stock é maior que 0, itera i por cada produto que tem stock, e cria uma variável para sabermos qual o ID do último produto que tem stock
awk -F: 'BEGIN{i=0} { if ($4 > 0) print ++i": "$1": "$3" EUR" }' produtos.txt #se houver stock ($4 > 0) vai buscar a produtos.txt o nome dos produtos e o preço ($1 e $3) e dá print a : $1: $3: EUR(: Nome: Preço EUR) por ordem 
echo "0: Sair"; #da print a "0: Sair"
echo; 
echo -n "Insira a sua opção: " #da print a "Insira a sua opção: " sem passar de linha

#2.1.2
read opcao; #guarda na variavel $opcao o que escrevemos
opcaoLine=$( awk -F: 'BEGIN{i=0} { if ($4 > 0) { ++i; if (i == '$opcao') print } }' produtos.txt ); #guarda em $opcaoLine a linha do produto que escolhemos 
[[ $opcao == 0 ]] && { ./success 2.1.2 && exit 1; } #se $opcao for 0, saimos do programa, dá success 2.1.2 e termina
[[ $opcao =~ ^-?[0-9]+$ ]] && (( $opcao <= $max )) && ./success 2.1.2 "$(echo  $opcaoLine | cut -d: -f1)" || { ./error 2.1.2 && exit 1; } #valida se a opção que colocamos é válida (número inteiro e menor q o $max (ID do produto maximo onde há stock)), se for dá success 2.1.2 com a alínea do produto e o nome do produto  , caso contrário da error 2.1.2 e termina


#2.1.3 da print a "Insira o ID do seu utilizador: ", guarda na variaval $ID o que escrevemos e por fim se encontra um utilizador em utilizadores.txt com o mesmo $ID, dá success 2.1.3 "Nome do Utilizador", caso contrário dá error 2.1.3 e termina
echo -n "Insira o ID do seu utilizador: " 
read ID 
userLine=$( awk -F: '{ if ($1 == "'"$ID"'") print }' utilizadores.txt ) 
cut -d: -f1 utilizadores.txt | grep -xq "$ID" && ./success 2.1.3 "$(echo  $userLine | cut -d: -f2)" || { ./error 2.1.3 && exit 1; } 

#2.1.4 da print a "Insira a senha do seu utilizador: ", guarda na variaval $senha o que escrevemos e por fim se encontrar uma senha na linha do utilizador igual à senha lá registada, dá success 2.1.4, caso contrário dá error 2.1.4 e termina
echo -n "Insira a senha do seu utilizador: " 
read senha
echo $userLine | cut -d: -f3 | grep -xq "$senha" && ./success 2.1.4 || { ./error 2.1.4 && exit 1; } 

#2.2

#2.2.1
userSaldo=$(echo $userLine | cut -d: -f6) #guarda em $userSaldo o saldo do utilizador
opcaoSaldo=$(echo $opcaoLine | cut -d: -f3) #guarda em $opcaoSaldo o preço do produto escolhido
(( $userSaldo >= $opcaoSaldo )) && ./success 2.2.1 "$opcaoSaldo" "$userSaldo" || { ./error 2.2.1 "$opcaoSaldo" "$userSaldo" && exit 1; } #se o saldo do utilizador for maior ou igual ao preço do produto dá success 2.2.1 "preço do produto" "saldo do utilizador", caso contrário dá error 2.2.1 "preço do produto" "saldo do utilizador" e termina

#2.2.2 guarda em $newSaldo o valor do saldo do utilizador menos o preço do produto, e depois cria uma nova linha para guardar os valores iguais noutra linha mas com o saldo do utilizador alterado (saldo do utilizador - preço do produto), se for esse o caso dá success 2.2.2, caso contrário dá error 2.2.2 e termina
(( newSaldo = $userSaldo - $opcaoSaldo )); 
newLine="$( echo $userLine | awk -F: -v OFS=: '{$6="'"$newSaldo"'"; print}' )"; 
sed -i "s/$userLine/$newLine/" utilizadores.txt && ./success 2.2.2 || { ./error 2.2.2; exit 1; }

#2.2.3 guarda em $opcaoStock o valor do preço do produto, e depois cria uma nova linha para guardar os valores iguais noutra linha mas com o preço do produto alterado (stock do produto - 1), se for esse o caso dá success 2.2.3, caso contrário dá error 2.2.3 e termina
opcaoStock=$(echo $opcaoLine | cut -d: -f4);
newLine="$( echo $opcaoLine | awk -F: -v OFS=: '{$4="'"$(($opcaoStock - 1))"'"; print}' )"; 
sed -i "s/$opcaoLine/$newLine/" produtos.txt && ./success 2.2.3 || { ./error 2.2.3; exit 1; }

#2.2.4
opcaoName=$(echo  $opcaoLine | cut -d: -f1); #guarda o nome do produto em $opcaoName
opcaoCatg=$(echo $opcaoLine | cut -d: -f2); #guarda a categoria do produto em $opcaoName
echo $opcaoName:$opcaoCatg:$ID:$(date +%F) >> relatorio_compras.txt && ./success 2.2.4 || { ./error 2.2.4; exit 1; } #cria/acrescenta numa nova linha o registo da compra feita em relatorio_compras.txt no formato de Produto>:<Categoria>:<ID_Utilizador>:<Data:YYYY-MM-DD>, se tudo der certo dá success 2.2.4, caso contrário dá error 2.2.4 e termina

#2.2.5  
userName="$(echo  $userLine | cut -d: -f2)" #guarda o nome do utilizador em $userName,
echo "**** $(date +%F): Compras de $userName ****" > lista-compras-utilizador.txt || { ./error 2.2.5 && exit 1; } #cria o ficheiro lista-compras-utilizador.txt e coloca na primeira linha "**** DATE: Compras de $userName ****", de der errado dá error 2.2.5 e termina
awk -F: '{ if ( $3 == '$ID' ) print ""$1", "$4"" }' relatorio_compras.txt  >> lista-compras-utilizador.txt && { ./success 2.2.5 && exit 1; } || { ./error 2.2.5 && exit 1; } #escreve em lista-compras-utilizador.txt o nome do produto e a data da compra que cada linha de relatorio_compras.txt mostra do utilizador, se der certo dá success 2.2.5 e termina, caso contrário dá error 2.2.5 e termina
