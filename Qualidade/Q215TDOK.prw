#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/////////////////////////////////////////////////////////////////////////////
//Programa: Q215TDOK - PTO DE ENTRADA NA CONFIRMAÇÃO DA ROTINA RESULTADOS
//Autoria : Flávia Rocha
//Data    : 25/04/2011 
//Usado em: Inspeção Processos
//Solicitado por Marcelo: Quando uma inspeção for reprovada, BLOQUEAR A Op
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


//A variável nOpcX armazena o número da opção escolhida:
//1-Pesquisar
//2-Visualizar
//3-Resultados
//4-Excluir

//MSGBOX("OPÇÃO: " + STR(nOpcX) + ' - ' + cLaudo )
//Como este P.E. é executado toda vez em que se clica no botão "OK", resolvi filtrar
//pela opção "Resultados" pois quando clicar em "Excluir" não será necessário a execução do mesmo.
//FR - 27/04/2011

cLaudo := M->QPM_LAUDO   //será usado o laudo da operação
//cLaudo := M->QPL_LAUDO   //Laudo geral 
////////////////////////////////////////////////////////////////////////////////////////////////
//Flavia Rocha - em 14/05 em reunião conferência com Marcelo e Eurivan,
// ficou definido que a verificação de bloqueio/desbloqueio deverá ser por laudo de operação
// e não por Laudo final (Laudo Geral que é dado ao final de todo o processo)
////////////////////////////////////////////////////////////////////////////////////////////////


/*
LAUDOS FINAIS:
A - APROVADO SEM RESTRIÇÕES
B - ACEITO COM DESVIO SIMPLES
C - ACEITO COM DESVIO GRAVE
D - COM SELEÇÃO PELO FORNECEDOR
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

If nOpcX = 3 //.and. !Empty(aResultados[nFldLauGer,1,3])  //verifica se o Laudo Geral está preenchido
 
	//MSGBOX("OPÇÃO: " + STR(nOpcX) + ' - tem laudo geral' )
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
					MsgInfo("Laudo Operação APROVADO, OP será DESBLOQUEADA." )	
				Else 
					RecLock("SC2",.F.)		
					SC2->C2_BLOQUEA := '*'		//bloqueia a OP
					SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
					SC2->C2_OBSBLOQ:= "Bloq Insp: " + cDescLaudo
					SC2->( MSUnlock() )
					MsgInfo("Laudo Operação REPROVADO, OP ficará BLOQUEADA." )			
				Endif
			Else
				MsgInfo("Laudo Operação NÃO CONCLUÍDO, a OP continuará bloqueada." )	
			Endif
		//Else 
			//msgbox("NÃO achou OP")		
		EndIf
Else
	//alert("sem laudo op")
Endif

Endif /*FALTAVA ESSE ENDIF - TESTE AI...*/


Return(.T.)

