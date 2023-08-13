#Include "Rwmake.ch"
#Include "Protheus.ch"

/*                    
/////////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: TMKC031 - Cancela listas do Call Center
//Objetivo: Quando Daniela precisa cancelar listas, só informar o código dentro da filial desejada
//Autoria : Flávia Rocha
//Data    : 17/08/2012
/////////////////////////////////////////////////////////////////////////////////////////////////////
*/

**********************
User Function TMKC031  
**********************

Local cPerg := "TMKC031"
Local cLista := ""
Local cMsg   := ""
Local eEmail := ""
Local subj   := ""

Pergunte(cPerg, .T.)

cLista := MV_PAR01

If !Empty(cLista)
	If MsgYesNo("CONFIRMA A EXCLUSÃO DA LISTA: " + cLista + " ? " )
		SU4->(DBSETORDER(1))
		If SU4->(Dbseek(xFilial("SU4") + cLista ))
			RecLock("SU4", .F.)
			SU4->(Dbdelete())
			SU4->(MsUnlock())	
		Endif
		
		SU6->(DBSETORDER(1))
		If SU6->(Dbseek(xFilial("SU6") + cLista ))
			While SU6->U6_FILIAL == xFilial("SU6") .AND. Alltrim(SU6->U6_LISTA) = Alltrim(cLista)
				RecLock("SU6", .F.)
				SU6->(Dbdelete())
				SU6->(MsUnlock())
				
				SU6->(DBSkip())
			Enddo	
		Endif
		cMsg   := "SAC - Lista Excluída - Filial: " + xFilial("SU4") + CHR(13) + CHR(10)
		cMsg   += "Lista: " + cLista + CHR(13) + CHR(10)
		cMsg   += "Data: " + Dtoc(Date()) + CHR(13) + CHR(10)
		cMsg   += "Hora: " + Time() + CHR(13) + CHR(10)
		cMsg   += "User: " + Substr(cUsuario,7,15) + CHR(13) + CHR(10)
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		subj   := cMsg
		//U_SendFatr11(eEmail, "", subj, cMsg, "" )
		MsgInfo("Lista Excluída com Sucesso !")
	Endif
Else
	Alert("Lista Informada NÃO Existe ! -> " + cLista)
Endif 

      

REturn


