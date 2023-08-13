#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRAZO     º Autor ³ AP6 IDE            º Data ³  04/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³ Chamado 000081                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GPRZ()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aData := {}

if !empty(M->C5_CONDPAG) .and. !empty(M->C5_LOCALIZ) .and. !empty(M->C5_TRANSP) .and. !empty(M->C5_ENTREG)
	if alltrim(M->C5_TRANSP) $ "024"
		return .T.
	endIf
	if !SZZ->( dbSeek( xFilial("SZZ") + M->C5_TRANSP + M->C5_LOCALIZ, .F. ) )
		 
		//U_FZ40()// FUNCAO QUE LEVA O PEDIDO PARA TABELA DE LIBERACAO DE PEDIDO

		/*alterado em 18/02/09 chamado 000891
		msgAlert("A transportadora escolhida não entrega para essa localidade. Favor corrigir ou liberar!")
		if !U_Senha2("13",1)[1] 
			M->C5_TRANSP  := space(6)
			M->C5_LOCALIZ := space(6)
			Return .F.
		else
			msgAlert("Liberado!")
			Return .T.
		endIf*/
		
	endIf
	aData := Condicao(999, M->C5_CONDPAG,,M->C5_ENTREG)
	//msgAlert(dtoc(aData[1][1]) + " " + dtoc(M->C5_ENTREG) )
    if alltrim(M->C5_CONDPAG) $ "/001/003/002/012/212"
    	return .T.
    elseIf aData[1][1] <= M->C5_ENTREG
    	return .T.
    endIf
	/*if !SZZ->( dbSeek( xFilial("SZZ") + M->C5_TRANSP + M->C5_LOCALIZ, .F. ) )
		msgAlert("A transportadora escolhida não entrega para essa localidade. Favor corrigir!")
		M->C5_TRANSP  := space(6)
		M->C5_LOCALIZ := space(6)
		Return .F.
		Saiu daqui para o topo em 29/01/2009, chamado n. 000841
	endIf*/
	if aData[1][1] < M->C5_ENTREG + SZZ->ZZ_PRZENT
        Aviso("AVISO ! ! !", "O vencimento da primeira parcela ("+dtoc(aData[1][1])+") é inferior ao prazo de entrega("+dtoc(M->C5_ENTREG + SZZ->ZZ_PRZENT)+"). Confirma?", {"OK"})
		//Return .F.
	endIf
endIf

Return .T.

*************

User Function FZ40()

*************

//Posiciona na Tab. de Liberacao Pedido  
		DbSelectArea("Z40")
		DbSetOrder(1)      
		If DbSeek(xFilial("Z40")+M->C5_NUM+'T')  
           If Z40->Z40_STATUS='B'	 // Bloqueado	       
              Alert( "Pedido ainda não foi Liberado para a Transportadora escolhida !!" )
              M->C5_TRANSP  := space(6)
			  M->C5_LOCALIZ := space(6)
              Return .F.
           ElseIf  Z40->Z40_STATUS='J' // Liberado
              Alert( "Pedido precisa de uma  Nova Liberação para  a Transportadora escolhida !!" )
              M->C5_TRANSP  := space(6)
			  M->C5_LOCALIZ := space(6)
              Return .F.   
           ElseIf  Z40->Z40_STATUS='L' // Liberando...	       
              RecLock("Z40",.F.) 
              Z40->Z40_STATUS:='J'	// finaliza a liberacao e muda o status para liberado	       
              Z40->(MsUnLock())
              Return .T.
           Endif      
        Else
              RecLock("Z40",.T.)
              Z40->Z40_FILIAL:=xFilial("Z40")
              Z40->Z40_PEDIDO:=M->C5_NUM
              Z40->Z40_DTEMIS:=M->C5_EMISSAO
              Z40->Z40_STATUS:='B'
              Z40->Z40_TIPO:='T'
              Z40->(MsUnLock())
               M->C5_TRANSP  := space(6)
			   M->C5_LOCALIZ := space(6)
              Alert( "A transportadora escolhida não entrega para essa localidade. Favor corrigir ou liberar!" )
              Return .F.
        Endif

Return 