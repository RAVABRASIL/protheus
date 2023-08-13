#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function F070DESC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
//PTO ENTRADA NO FINA070 - BAIXAS A RECEBER
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nDesconto := nDescont
Local lRet      := .T.
 
SetPrvt("NJUROS,")

/*user function F070DESC()

Local nValdesc:= Paramixb[1]
Local lRet:= .T.
Local nLimite:= 30

If nValdesc > nLimite     
	msgAlert("Não poderá ser dado desconto maior que 30,00")
	lRet:= .F.
EndIf

Return lRet
*/

//ALERT("ENTROU NO F070DESC")
//FR - 12/08/13 - COMENTADO POR FLÁVIA ROCHA
//POIS AO BAIXAR O TÍTULO, E ZERAR A TX PERMANÊNCIA, 
//O TÍTULO FICAVA BAIXADO PARCIAL, O QUE É INCORRETO
/*
if !Empty(SE1->E1_BAIXA)

   njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dBaixa - iif(SE1->E1_BAIXA<SE1->E1_VENCREA,SE1->E1_VENCTO,SE1->E1_BAIXA) ), 2 )
  // njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dBaixa - iif(SE1->E1_BAIXA<SE1->E1_VENCREA,SE1->E1_BAIXA,SE1->E1_BAIXA) ), 2 )
else
   if SE1->E1_VENCREA < dBaixa
   
      njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dBaixa - SE1->E1_VENCTO), 2 )
   endif
endif
*/

If nDescont > 0
	If Reclock("SE1",.F.)
		SE1->E1_DESCONT := nDescont
		SE1->(MsUnlock())
	Endif          
	//msgbox("Valor desconto: " + str(SE1->E1_DESCONT))
Endif




//Return(nDesconto)
Return lRet
