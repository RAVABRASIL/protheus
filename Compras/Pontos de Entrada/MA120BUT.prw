#Include "Rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


/*
/////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: MA120BUT - Ponto de Entrada no Pedido de Compra
//Objetivo: Adiciona botões na enchoice (botão para informar o valor do frete - irá gravar
//          no campo específico C7_VALFRET)
//Autoria : Flávia Rocha
//Data    : 08/02/2012        
////////////////////////////////////////////////////////////////////////////////////////////////
*/

**************************
User Function MA120BUT() 
**************************

Local aButtons := {} // Botoes a adicionar

aadd(aButtons,{'CARGA' ,{|| fValFRE()}    ,'Insere Valor FRETE','FRETE'}) 
aadd(aButtons,{'DBG06' ,{|| fURG()}       ,'Define URGÊNCIA','URGENTE?'}) 
AAdd(aButtons,{ "ORDEM", {|| A120Track() }, 'System Tracker', 'Tracker'})  

Return (aButtons )


****************************
Static Function fValFRE()
****************************


Local nOpcA   := 0
Local nPOSFRE := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C7_VALFRET" } )
Local x       := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nValFrete  := 0
Private cSayFret   := Space(1)
Private cValFrete  := Space(1)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oValFrete","oSBtn1","oSBtn2")

If Inclui .or. Altera
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	//oDlg1      := MSDialog():New( 088,232,292,692,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	//oGrp1      := TGroup():New( 016,004,068,212,"  Favor Informar o Valor do Frete:   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oDlg1      := MSDialog():New( 088,232,292,670,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 008,004,076,212,"  Caso NECESSÁRIO, Favor Informar o Valor do Frete:   ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	
	oSay1      := TSay():New( 032,012,{||"Valor Frete R$ :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oValFrete  := TGet():New( 032,076,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)
	oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )
	//oSBtn1:bAction := {|| (nOpcA := 1, GrvFRE(nValFrete))} 
	//oSBtn1:bAction := {|| (nOpcA := 0,oDlg1:End())} 
	oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
	  
	oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
	oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
	
	oDlg1:Activate(,,,.T.)
	x:= 0
	If nOpcA = 1 
		//msgbox("valor frete ok: " + str(nValFrete) )
		For x:= 1 To Len(aCols)	
			If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada						
				aCols[x,nPOSFRE]:= nValFrete  //M->C5_ENTREG	
				nValFrete := 0  //coloca zero nos demais itens
			Endif
		Next                                              
		
	Endif 
Else
	MsgInfo("SEM PERMISSÃO para Alterar No modo Visualizar !")
Endif

Return 


****************************
Static Function fURG()
****************************


Local nOpcA   := 0
Local nPOSURG := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C7__URGEN" } )
Local x       := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nUrgente   := 0
Private cUrgente   := ""
Private cSayURG    := Space(1)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSayURG","oSBtn1","oSBtn2", "oCboxU")

If Inclui .or. Altera
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	//oDlg1      := MSDialog():New( 088,232,292,692,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	//oGrp1      := TGroup():New( 016,004,068,212,"  Favor Informar o Valor do Frete:   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oDlg1      := MSDialog():New( 088,232,292,670,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 008,004,076,212," Favor Definir a Urgência da Compra ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	
	oSayURG      := TSay():New( 032,012,{||"Compra é Urgente ? "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	//oValFrete  := TGet():New( 032,076,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)
	oCBoxU     := TComboBox():New( 032,076,,{"S=Sim","N=Nao"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cUrgente )
	oCBoxU:bSetGet := {|u| If(PCount()>0,cUrgente:=u,cUrgente)}

	oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )
	oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
	  
	oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
	oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
	
	oDlg1:Activate(,,,.T.)
	x:= 0
	If nOpcA = 1 
		For x:= 1 To Len(aCols)	
			If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada						
				aCols[x,nPOSURG]:= cUrgente
			Endif
		Next                                              
		
	Endif 
Else
	MsgInfo("SEM PERMISSÃO para Alterar No modo Visualizar !")
Endif

Return 

