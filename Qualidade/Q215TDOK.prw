#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/////////////////////////////////////////////////////////////////////////////
//Programa: Q215TDOK - PTO DE ENTRADA NA CONFIRMA��O DA ROTINA RESULTADOS
//Autoria : Fl�via Rocha
//Data    : 25/04/2011 
//Usado em: Inspe��o Processos
//Solicitado por Marcelo: Quando uma inspe��o for reprovada, BLOQUEAR A Op
/////////////////////////////////////////////////////////////////////////////

****************************************
User Function Q215TDOK()
****************************************


Local cOP 		:= QPK->QPK_OP     //JUNTOS: C2_NUM + C2_ITEM + C2_SEQUEN
Local cProduto	:= QPK->QPK_PRODUT
Local cStatus	:= QPK->QPK_SITOP
Local cLaudo	:= ""
//Local cOperacao := M->QPL_OPERAC
Local cDescLaudo:= ""


//A vari�vel nOpcX armazena o n�mero da op��o escolhida:
//1-Pesquisar
//2-Visualizar
//3-Resultados
//4-Excluir

//MSGBOX("OP��O: " + STR(nOpcX) + ' - ' + cLaudo )
//Como este P.E. � executado toda vez em que se clica no bot�o "OK", resolvi filtrar
//pela op��o "Resultados" pois quando clicar em "Excluir" n�o ser� necess�rio a execu��o do mesmo.
//FR - 27/04/2011

cLaudo := M->QPM_LAUDO   //ser� usado o laudo da opera��o
//cLaudo := M->QPL_LAUDO   //Laudo geral 
////////////////////////////////////////////////////////////////////////////////////////////////
//Flavia Rocha - em 14/05 em reuni�o confer�ncia com Marcelo e Eurivan,
// ficou definido que a verifica��o de bloqueio/desbloqueio dever� ser por laudo de opera��o
// e n�o por Laudo final (Laudo Geral que � dado ao final de todo o processo)
////////////////////////////////////////////////////////////////////////////////////////////////


/*
LAUDOS FINAIS:
A - APROVADO SEM RESTRI��ES
B - ACEITO COM DESVIO SIMPLES
C - ACEITO COM DESVIO GRAVE
D - COM SELE��O PELO FORNECEDOR
E - REJEITADO TOTALMENTE

*/

If Alltrim(cLaudo) = "A"
	cDescLaudo := "A - APROVADO SEM RESTRICOES"
Elseif Alltrim(cLaudo) = "B"
	cDescLaudo := "B - ACEITO COM DESVIO SIMPLES"
Elseif Alltrim(cLaudo) = "C"
	cDescLaudo := "C - ACEITO COM DESVIO GRAVE"
Elseif Alltrim(cLaudo) = "D"
	cDescLaudo := "D - COM SELECAO PELO FORNECEDOR"
Elseif Alltrim(cLaudo) = "E"
	cDescLaudo := "E - REJEITADO TOTALMENTE"
Endif

If nOpcX = 3 //.and. !Empty(aResultados[nFldLauGer,1,3])  //verifica se o Laudo Geral est� preenchido
 
	//MSGBOX("OP��O: " + STR(nOpcX) + ' - tem laudo geral' )
	SC2->(Dbsetorder(1)) 
	If xFilial("SC2") == '03'
		If SC2->(Dbseek(xFilial("SC2") + cOP  ))
			If !Empty(cLaudo) //.AND. Alltrim(cLaudo) != '0'	   		
	   
			   IF Alltrim(cLaudo) $ "A/B/C"			
					RecLock("SC2",.F.)
					SC2->C2_BLOQUEA := ''      //libera a OP
					SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
					SC2->C2_OBSBLOQ:= cDescLaudo
					SC2->( MSUnlock() )
					MsgInfo("Laudo Opera��o APROVADO, OP ser� DESBLOQUEADA." )	
				Else 
					RecLock("SC2",.F.)		
					SC2->C2_BLOQUEA := '*'		//bloqueia a OP
					SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
					SC2->C2_OBSBLOQ:= "Bloq Insp: " + cDescLaudo
					SC2->( MSUnlock() )
					MsgInfo("Laudo Opera��o REPROVADO, OP ficar� BLOQUEADA." )			
				Endif
			Else
				MsgInfo("Laudo Opera��o N�O CONCLU�DO, a OP continuar� bloqueada." )	
			Endif
		//Else 
			//msgbox("N�O achou OP")		
		EndIf
Else
	//alert("sem laudo op")
Endif

Endif /*FALTAVA ESSE ENDIF - TESTE AI...*/


Return(.T.)

