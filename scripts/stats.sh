#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Rodrigo Miguel Cosme dos Santos Nº: a111255      Nome: Rodrigo Miguel Cosme dos Santos
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo: Os comentrários estao ao lado das implementações
##
##
###############################################################################

#4

#4.1

#4.1.1 se for 2 argumentos e o primeiro for popular, ou se for só 1 argumento e se for ou listar ou histograma, dá success 4.1.1, caso contrário dá erro
[[ ( $# == 2 && $1 == "popular" ) ||  $# == 1 && $1 == "listar" || $# == 1 && $1 == "histograma" ]] && ./success 4.1.1 || { ./error 4.1.1 && exit 1; }

#4.2

case $1 in
    listar) #4.2.1
        ! [[ -f relatorio_compras.txt ]] || [[ -z relatorio_compras.txt ]]  && { ./error 4.2.1 && exit 1; } #se não encontrar o ficheiro relatorio_compras.txt ou se estiver vazio, dá error 4.2.1 e termina
        cat relatorio_compras.txt | cut -d: -f3 | sort | uniq -c | sort -r > stats.txt #se recebermos na entrada "listar", escrevemos em stats.txt o número de compras por cada ID de utilizador
     
        while read linhaUser; do
            
            ##ID é o ID do utilizador na linha do utilizadores.txt, e o IDNome é o nome do mesmo
            ID=$( echo $linhaUser | cut -d: -f1 )
            IDName=$( echo $linhaUser | cut -d: -f2 ) 

            #$oldLine é a linha do stats.txt que tem o mesmo ID do utilizador a ser analisado
            oldLine=$( awk -F' ' '{ if ( $2 == "'"$ID"'" ) print }' stats.txt );

            #depois subsitui-se em stats.txt essa linha $oldLine por uma nova $newLine com o formato "$IDName: $nCompras compra(s)", $nCompras é o numero de compras feito por esse utilizador, se der errado dá error 4.2.1
            if [[ -n $oldLine ]]; then
                nCompras=$( awk -F' ' '{ if ( $2 == "'"$ID"'" )  print $1}' stats.txt )
                newLine=$( [[ $nCompras == 1 ]] && echo "$IDName: $nCompras compra" || echo "$IDName: $nCompras compras" )
                sed -i "s/$oldLine/$newLine/" stats.txt || { ./error 4.2.1 && exit 1; } 
            fi

        done < utilizadores.txt #escreve para o 'read' o ficheiro utilizadores.txt linha a linha
        ./success 4.2.1 #caso tenha escrito em stats.txt ou não, dá success 4.2.1

    ;;
    
    popular) #4.2.2
        ! [[ $2 =~ ^-?[0-9]+$ && $2 -ge 1 ]] && ./error 4.2.2
        ! [[ -f relatorio_compras.txt ]] || [[ -z relatorio_compras.txt ]]  && { ./error 4.2.2 && exit 1; } #se não encontrar o ficheiro relatorio_compras.txt ou se estiver vazio, dá error 4.2.2 e termina
        cat relatorio_compras.txt | cut -d: -f1 | sort | uniq -c | sort -r > statts.txt #se recebermos na entrada "pupular + nr", escrevemos em statts.txt (ficheiro temporario depois removido) o número de compras por cada ID de utilizador
        
        #se tiver só um compra, dá print a ""$2": "$1" compra", se houver mais que uma compra, dá print a ""$2": "$1" compras", depois mostra apenas os $2 produtos mais vendidos (com o head -$2) e escreve em stats.txt, se der success 4.2.2, caso contrário da error 4.2.2 e termina
        awk -F' ' '{ if ( $1 == 1 )  { print ""$2" "$3": "$1" compra" } else if ( $1 > 1 ) { print ""$2" "$3": "$1" compras" } }' statts.txt | head -$2 > stats.txt && ./success 4.2.2 || { ./error 4.2.2 && exit 1; }
        
        rm statts.txt #elimina o ficheiro temporario statts.txt do registo
    ;;

    histograma) #4.2.3
        ! [[ -f relatorio_compras.txt ]] || [[ -z relatorio_compras.txt ]]  && { ./error 4.2.3 && exit 1; } #se não encontrar o ficheiro relatorio_compras.txt ou se estiver vazio, dá error 4.2.3 e termina
         cat relatorio_compras.txt | cut -d: -f2 | sort | uniq -c > stats.txt #se recebermos na entrada "histograma", escrevemos em stats.txt o número de compras por cada categoria

        while read linhaProduto; do

            #nCompras é o número de compras na linha do stats.txt, e o catgItem é a categoria do mesmo
            nCompras=$( echo $linhaProduto | cut -d' ' -f1 )
            catgItem=$( echo $linhaProduto | cut -d' ' -f2 )
           
            #$oldLine é a linha do stats.txt que tem a mesma categoria do item a ser analisado
            oldLine=$( awk -F' ' '{ if ( $2 == "'"$catgItem"'" ) print }' stats.txt );

            #depois subsitui-se em stats.txt essa linha $oldLine por uma nova $newLine com o formato ""categoria do item"   *(consoante o número de vendas de esse produto, os asteriscos estao em formato justificado)", $nCompras é o numero de compras feito por esse utilizador, se der errado dá error 4.2.3
            if [[ -n $oldLine ]]; then
                newLine=$( echo "$(printf "%-10s" $catgItem) $(printf '%0.s*' $( seq $nCompras))" )
                sed -i "s/$oldLine/$newLine/" stats.txt || { ./error 4.2.3 && exit 1; } 
            fi
        
        done < stats.txt #escreve para o 'read' o ficheiro stats.txt linha a linha
        ./success 4.2.3 #caso tenha escrito em stats.txt ou não, dá success 4.2.3
       
    ;;

esac      
