#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
	
///ACRESCENTA BOTÕES NA BARRA LATERAL DO BROWSE (aRotina)
*************
User Function MA410MNU

*************

Private aFilBrw := {}

aadd( aRotina,{'Consulta Lib.',"U_fHisLib()" , 0 , 6,0,NIL})
AAdd( aRotina,{ "SAC", "U_fSAC('SC5', SC5->(recno()), 4)", 0, 3, NIL } )
aadd( aRotina,{'Imprimir',"U_FATPDV2" , 0 , 6,0,NIL})
aadd( aRotina,{'Inclui OBS',"U_FINCOBS()" , 0 , 3,0,NIL})
Aadd( aRotina,{ "Danfe"  ,'SPEDNFE' , 0 , 2,0,NIL})   //se usar SPEDDANFE dá erro que não existe variável aFilBrw

Return(aRotina)


**************************

User Function fSAC( cAlias, nReg )
**************************

Local cCliente := ""  //SC5->C5_CLIENTE
Local cLoja    := "" //SC5->C5_LOJACLI

DbSelectArea("SC5")
SC5->(Dbgoto(nReg))

cCliente := SC5->C5_CLIENTE
cLoja    := SC5->C5_LOJACLI

//msgbox("Cliente: " + cCliente)
//msgbox("Loja: " + cLoja)
U_TMKC028(cCliente,cLoja)


Return



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Funcao para incluir observacao no pedido de venda sem alterá-lo         ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

User Function fINCOBS()
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local lContinua		:= .F.
Private cOBS       	:= IIF(Empty(SC5->C5_MENNOTA),Space(130),SC5->C5_MENNOTA)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oPanel1","oSay1","oGet1","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 331,340,428,953,"Mensagem para Nota",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 0-3,000,"",oDlg1,,.F.,.F.,,,300,045,.T.,.F. )
oSay1      := TSay():New( 004,004,{||"Escreva a mensagem para nota fiscal"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,009)
oGet1      := TGet():New( 012,004,,oPanel1,289,013,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cOBS",,)
oGet1:bSetGet := {|u| If(PCount()>0,cOBS:=u,cOBS)}

oSBtn1     := SButton():New( 031,216,1,,oPanel1,,"", )
oSBtn1:bAction := {||lContinua	:= .T., oDlg1:end()}

oSBtn2     := SButton():New( 031,267,2,,oPanel1,,"", )
oSBtn2:bAction := {||lContinua	:= .F., oDlg1:end()}

oDlg1:Activate(,,,.T.)

If lContinua

	RecLock("SC5", .F.)
	SC5->C5_MENNOTA := cOBS
	MsUnLock()
	MsgAlert("Mensagem Gravada!!!")
	
EndIf

Return