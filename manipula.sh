#!/bin/bash

#variaveis
BANCO=banco.txt
SEP=:
TEMP=temp.$$
MASCARA=§

[ -r "$BANCO" -a -w "$BANCO"  ] || {
echo "Base travada, confira permissões de leitura / escrita"
exit 1
}


mascara(){
tr $SEP $MASCARA;
}

desmascara(){
tr $MASCARA $SEP;
}

pega_campo(){
cut -d : -f 1 "$BANCO" | desmascara | sed 1d | tr \\n ' '
}

tem_chave(){
grep -i -q "$1$SEP" "$BANCO"
}


insere_registro(){

echo "$*" >> "$BANCO"
echo "O registro '$1' foi adicionado!"
return 0

}


apaga_registro(){

grep -i -v "^$1$SEP" "$BANCO" > "$TEMP"
mv "$TEMP" "$BANCO"
echo "O registro '$1' foi removido"

}


altera_registro(){

tem_chave "$1" || return 
sed 's/'$1'/'$2'/' "$BANCO" > "$TEMP"
mv "$TEMP" "$BANCO"

echo "Registro '$1' foi alterado para '$2'"

}


menu(){
echo "1 - ADICIONAR"
echo "2 - DELETAR"
echo "3 - ALTERAR"
echo "4 - LISTAR"
echo "5 - SAIR"
}



while [[ opcao -ne 5 ]];
do

menu

read opcao

case $opcao in

1)

echo
echo
echo "ADICIONAR"
echo
echo "Informe usuário"
read user

[ "$user" ] || {

echo "Usuario vazio!"
exit 1
}

if tem_chave "$user"; then

echo "Usuário já existente!"
exit 1

fi

echo "Informe sua senha"
read -s senha

usern=$(echo "$user" | mascara)
senhan=$(echo "$senha" | mascara)

insere_registro "$usern:$senhan"
 

;;

2)

echo 
echo 
echo "DELETAR"
echo
echo "Usuários do sistema"
pega_campo
echo
echo "Qual usuário deseja deletar?"
read login

if tem_chave "$login"; then
apaga_registro "$login"
else
echo "Usuario inexistente!"
exit 1
fi



;;

3) 

echo
echo "ALTERAR"
echo "Usuários do Sistema"
echo
pega_campo
echo "Qual usuário deseja remover?"
read user
if tem_chave "$user"; then 

echo "Novo User"
read nuser

masc_nuser=$(echo "$nuser" | mascara)

altera_registro "$user" "$masc_nuser"

else
echo "Usuário inexistente!"
exit 1
fi

;;

4)

echo
echo "LISTAR"
echo
pega_campo
echo
echo
;;

*)

if [[ $opcao -ne 5 ]]; then
echo "opção inválida!"
fi

;;


esac

done










