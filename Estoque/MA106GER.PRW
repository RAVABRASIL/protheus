#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "Topconn.ch"

User Function MA106GER()

 
If MsgNoYes("Atende minha condi��o?"," MsgNoYes ")
	aRotina[3]:={"Requisitar","A106Proc",0,4,0, NIL}         //O bot�o tinha que ficar Requisitar eu acho...
Else 
	aRotina[3]:={"Requisitar","U_TesteMTA106",0,3}           //aqui tambem
EndIf

Return() 
	
User Function TesteMTA106
	ALERT("Usu�rio n�o atende condi��o!!")
Return 