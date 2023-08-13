#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

*************

User Function  FATC006()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oGet1","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 240,483,357,620,"Pre-Pedido",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 006,002,{||"Numero Pre-Pedido:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,006)
oGet1      := TGet():New( 015,002,{|u| If(PCount()>0,cPrePed:=u,cPrePed)},oDlg1,063,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ5","cPrePed",,)
oSBtn1     := SButton():New( 036,002,1,,oDlg1,,"", )
oSBtn1:bAction := {||ok()}

oSBtn2     := SButton():New( 036,040,2,,oDlg1,,"", )
oSBtn2:bAction := {||oDlg1:end()}


oDlg1:Activate(,,,.T.)


Return 

***************

Static Function ok() 

***************

DbSelectArea("SZ5")
DbSetOrder(1)
SZ5->(DbSeek(xFilial("SZ5")+cPrePed))

DbSelectArea("SA1")
DbSetOrder(1)
SA1->(DbSeek(xFilial("SA1")+SZ5->Z5_CLIENTE+SZ5->Z5_LOJACLI))

IF U_GetSldPP(cPrePed)>0

	M->C5_CLIENTE:=SZ5->Z5_CLIENTE
	M->C5_LOJACLI:=SZ5->Z5_LOJACLI
	M->C5_TIPOCLI:=SA1->A1_TIPO
   	U_ItensPre()
   	U_CLITES(SZ5->Z5_CLIENTE,SZ5->Z5_LOJACLI)    
	U_COMISS(SZ5->Z5_EDITAL,1)
    
ENDIF
oDlg1:end()
Return 