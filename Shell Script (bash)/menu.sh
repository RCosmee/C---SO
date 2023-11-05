#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Rodrigo Miguel Cosme dos Santos Nº: a111255      Nome: Rodrigo Miguel Cosme dos Santos
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo: Os comentrários estao ao lado das implementações
##
##
###############################################################################

#5
while :; do #fica num ciclo infinto sempre que chega ao fim do script, até darmos break
    #5.1

    #5.1.1 da print a apresentação do script, esperando receber algo após "Opção: "
    echo;
    echo "MENU:"
    echo "1: Regista/Atualiza saldo utilizador"
    echo "2: Compra produto"
    echo "3: Reposição de stock"
    echo "4: Estatísicas"
    echo "0: Sair"
    echo;
    echo -n "Opção: "

    #5.2

    #5.2.1 lê a opção que colocamos e valida se é um NÚMERO menor que ou igual a 4, se sim dá sucess 5.2.1 "$opcao", caso contrário dá error 5.2.1 "$opcao"
    read opcao; 
    [[ $opcao =~ ^-?[0-9]+$ ]] && (( $opcao <= 4 )) && ./success 5.2.1 $opcao || ./error 5.2.1 $opcao  

    #5.2.2 
    case $opcao in
    
       1) #5.2.2.1 se escoher 1 da print a apresentaço da opção 1, esperando que se coloque as várias variaveis para assim correr o ./regista_utilizador.sh, se der certo dá success 5.2.2.1 e volta para o menu de 5.1
            echo;
            echo "Regista utilizador / Atualiza saldo utilizador: "
            read -p "Indique o nome do utilizador: " nome
            read -p "Indique a senha do utilizador: " senha
            read -p "Para registar o utilizador, insira o NIF do utilizador: " NIF
            read -p "Indique o saldo a adicionar ao utilizador: "  saldo

            ./regista_utilizador.sh "$nome" "$senha" "$saldo" "$NIF"
            ./success 5.2.2.1    
    
        ;;

        2) #5.2.2.2 se escoher 2 da print a apresentaço da opção 2, para assim correr o ./compra.sh, se der certo dá success 5.2.2.2 e volta para o menu de 5.1
            echo;
            echo "Escolha o produto a comprar: "
            ./compra.sh
            ./success 5.2.2.2
    
        ;;

        3) #5.2.2.3 se escoher 3 da print a apresentaço da opção 3, para assim correr o ./refill.sh, se der certo dá success 5.2.2.3 e volta para o menu de 5.1
            echo;
            echo "Refill dos produtos em falta"
            ./refill.sh
            ./success 5.2.2.3
        ;;

        4) #5.2.2.4 se escoher 4 da print a apresentaço da opção 4, 
        
            echo "1: Listar utilizadores que já fizeram compras"
            echo "2: Listar os produtos mais vendidos"
            echo "3: Histograma de vendas"
            echo "0: Voltar ao menu principal"
            echo;
            echo -n "Sub-Opção: "
    
            #lê a opção que colocamos e valida se é um NÚMERO menor que ou igual a 3, se der errado dá error 5.2.2.4
            read subOpcao; 
            [[ $subOpcao =~ ^-?[0-9]+$ ]] && (( $subOpcao <= 3 )) || ./error 5.2.2.4 

            
            case $subOpcao in 
           
                2) #se escolher 2, da print a apresentaço da opção 2 e corre .stats.sh "popular $n" e volta ao menu de 5.1
                    echo;
                    echo "Listar os produtos mais vendidos:"
                    echo -n " Indique o número de produtos mais vendidos a listar: " 
                    read n
                    ./stats.sh popular $n 
                ;;
        
                1) #se escolher 2, da print a apresentaço da opção 1 e corre .stats.sh "listar" e volta ao menu de 5.1
                    echo;
                    echo "Listar utilizadores que já fizeram compras: "
                    echo;
                    ./stats.sh listar
                ;;

                3) #se escolher 3, da print a apresentaço da opção 4 e corre .stats.sh "histograma" e volta ao menu de 5.1
                    echo;
                    echo "Histograma de vendas: "
                    echo;
                    ./stats.sh histograma 
                ;;

                0) #se escolher 0, volta ao menu de 5.1
                    echo;
                    echo "Voltar ao menu principal"
                    echo;
                ;;
                
                *) #se escolher algo sem ser as opções anteriores dá print a "Opcao inválida" e volta ao menu de 5.1
                    echo;
                    echo "Opcao inválida"
                    echo;
                ;;

               
        
            esac
            ./success 5.2.2.4 #se der certo, dá success 5.2.2.4 e volta ao menu de 5.1
        ;;

        0) #se escolher 0, sai do script
            break
        ;;

        *) #se escolher algo sem ser as opções anteriores dá print a "Opcao inválida" e volta ao menu de 5.1
            echo;
            echo "Opcao inválida"
            echo;
        ;;

    esac

done