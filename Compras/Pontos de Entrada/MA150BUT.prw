#Include "Rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


/*
/////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: MA150BUT - Ponto de Entrada na Atualização da Cotação
//Objetivo: Adiciona botões na enchoice (botão para informar o valor do frete - irá gravar
//          no campo padrão C8_VALFRE
//Autoria : Flávia Rocha
//Data    : 30/07/13        
////////////////////////////////////////////////////////////////////////////////////////////////
*/                      

************************
User Function MA150BUT
************************	

//Para inserir uma opção chamando o cadastro de clientes.
aBotao := {}

AAdd( aBotao, { "PRODUTO", { || fCotFRe() }, "FRETE" } )

Return( aBotao )

****************************
Static Function fCOTFRE()
****************************


Local nOpcA   := 0
Local nPOSFRE := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C8_VALFRE" } )
Local nPOSCOND:= aScan( aHeader,{ |x| AllTrim( x[2] ) == "C8_CNDPFRE" } )
Local x       := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nValFrete  := 0
Private cSayFret   := Space(1)
Private cValFrete  := Space(1)
Private cPrzPFre   := Space(6)
Private cDescPrz   := Space(30)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSayVFre","oValFrete","oSBtn1","oSBtn2","oCondPFre","oSayPFre","cDescPrz","oDescPRZ")

//If Inclui .or. Altera
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	//oDlg1      := MSDialog():New( 088,232,292,692,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	//oGrp1      := TGroup():New( 016,004,068,212,"  Favor Informar o Valor do Frete:   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oDlg1      := MSDialog():New( 088,232,292,670,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 008,004,076,212,"  Caso NECESSÁRIO, Favor Informar o Valor e Prazo Pagto. do Frete:   ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	
	oSayVFre      := TSay():New( 032,012,{||"Valor Frete R$ :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oValFrete  := TGet():New( 032,056,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)
	
	oSayPFre   := TSay():New( 060,012,{||"Cond. Pag. Frete :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oCondPFre  := TGet():New( 059,056,{|u| If(PCount()>0,cPrzPFre:=u,cPrzPFre)},oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cPrzPFre",,)
	
	oDescPRZ := TGet():New( 059,108,,oGrp1,90,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescPrz",,)
	oDescPRZ :bSetGet := {|u| cDescPrz := Posicione('SE4',1,xFilial("SE4")+ cPrzPFre,"E4_DESCRI")} 
	
	oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )	
	oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
	  
	oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
	oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
	
	oDlg1:Activate(,,,.T.)
	x:= 0
	If nOpcA = 1 
		//msgbox("valor frete ok: " + str(nValFrete) )
		For x:= 1 To Len(aCols)	
			If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada						
				aCols[x,nPOSFRE]:= nValFrete  
				aCols[x,nPOSCOND]:= cPrzPFre  
				nValFrete := 0  //coloca zero nos demais itens
				cPrzPFre  := ""
			Endif
		Next                                              
		
	Endif 
//Else
//	MsgInfo("SEM PERMISSÃO para Alterar No modo Visualizar !")
//Endif

Return 

