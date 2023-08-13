#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA110BUT  º Autor ³ Flávia Rocha       º Data ³  26/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Descrição: Este ponto de entrada tem o objetivo           º±±
±±º                de permitir ao usuário manipular a barra de botões     º±± 
±±º                nas rotinas de visualização, inclusão, Alteração e     º±±
±±º                exclusão de solcitação de compras.                     º±±
±±º                Exemplo: Possibilita retirar um botão que determinado  º±± 
±±º                usuário não tenha permissão conforme regra de negócio  º±±
±±º                   praticada.                                          º±±
±±º                Localização: Rotina de Solicitação de Compras MATA110()º±±
±±º                                                                       º±±
±±º                   Eventos                                             º±±
±±º                   Antes de montar a tela de Solicitação de Compras    º±±  
±±º                   para cada operação selecionada                      º±±
±±º                   (Visualização, Inclusão, Alteração e Exclusão).     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Compras                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
PARAMIXB[1]			Numérico			Parâmetro numérico contendo a opção de operação da rotina selecionada nOpc:
2 - Visualização
3 - Inclusão
4 - Alteração
5 - Exclusão
										
PARAMIXB[2]			Array of Record			Vetor contendo os botões carregados pela rotina.	
*/

*************************
User Function MA110BUT   
*************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc:= PARAMIXB[1]
Local aBut:= PARAMIXB[2]

//Customização Desejada
If nOpc = 3 .or. nOpc = 4
	aadd(aBut,{'DBG06' ,{|| fURG()}       ,'Define URGÊNCIA','URGENTE?'}) 
Endif

Return aBut





****************************
Static Function fURG()
****************************


Local nOpcA   := 0
Local nPOSURG := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C1__URGEN" } )
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

