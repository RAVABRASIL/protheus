#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "Topconn.ch"

User Function MA106GER()

 
If MsgNoYes("Atende minha condição?"," MsgNoYes ")
	aRotina[3]:={"Requisitar","A106Proc",0,4,0, NIL}         //O botão tinha que ficar Requisitar eu acho...
Else 
	aRotina[3]:={"Requisitar","U_TesteMTA106",0,3}           //aqui tambem
EndIf

Return() 
	
User Function TesteMTA106
	ALERT("Usuário não atende condição!!")
Return 