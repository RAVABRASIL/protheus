#INCLUDE "RWMAKE.CH"  
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//*****************************************************************************************
// Programa: MA103BUT - pto de entrada
// Descricao -> Rotina para apresenta um botao na linha superior do recebimento 
// Usado na inclusão da nf entrada - PARA INFORMAR O VALOR FRETE
// Autoria: Flávia Rocha
// Data   : 04/06/12 
//*****************************************************************************************

************************
USER FUNCTION MA103BUT
************************

//Public F1HistFin := Space(200)

aButtons := {}
//Aadd(aButtons,{"S4WB005N",&("{||U_RECE01()}"),"Alteração da Descrição do Item"})
//Aadd(aButtons,{"S4WB006N",&("{||U_RECE02()}"),"Selecionar Pedidos (Atos)"})
//Aadd(aButtons,{"S4WB007N",&("{||U_RECE03()}"),"Historico para o Financeiro (Atos)"})  

Aadd(aButtons,{"BUDGET",&("{|| u_finfoFre()}"),"Insere Valor Frete"})

//if !inclui
// F1HistFin := SF1->F1_HistFin
//endif  

Return(aButtons)   


****************************
User Function finfoFre()
****************************


Local nOpcA   := 0

Local x       := 0 
Local fr 	  := 0
Local cNomeCond := Space(10)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nPosFRET   := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VALFRE' })			//Posicao VALOR FRETE no acols SD1

Private nValFrete  := 0
Private cSayFret   := Space(1)
Private nValFrete  := 0
Private cCond      := Space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oValFrete","oSBtn1","oSBtn2", "oSay2","oCondPag", "oNomeCond", "oSay2", "oSay3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 088,232,292,670,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 008,004,076,212,"  Por Favor, Informe:   ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

//oSay3      := TSay():New( 023,117,{||"Descrição"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
//código da cond. pagto
//oSay2      := TSay():New( 032,012,{||"Cond. Pagto.   :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
//oCondPag   := TGet():New( 032,056,{|u| If(PCount()>0,cCond:=u,cCond)},oGrp1,045,008,'@X',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cCond",,)
//nome da cond. pagto
//oNomeCond  := TGet():New( 032,117,{|| cNomeCond := fTrazCond(cCond) },oGrp1,060,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeCond",,)
//oNomeCond  :lReadOnly   := .T. 

//oSay1      := TSay():New( 052,012,{||"Valor Frete R$ (Caso Haja):"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
//oSay1      := TSay():New( 052,012,{||"Valor Frete R$ (Caso Haja):"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,024)
//oValFrete  := TGet():New( 052,056,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)
oSay1      := TSay():New( 032,012,{||"Valor Frete R$ (Caso Haja):"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,024)
oValFrete  := TGet():New( 032,056,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)

oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )
oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
  
oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  

oDlg1:Activate(,,,.T.)

If nOpcA = 1 

	For fr := 1 to Len(aCols)	
		//If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada
			aCols[fr][nPosFRET] := nValFrete
		//Endif
	Next
	
Endif

//Return(nValFrete)
Return
