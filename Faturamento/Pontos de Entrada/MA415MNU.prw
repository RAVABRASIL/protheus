#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
	
///ACRESCENTA BOTÕES NA BARRA LATERAL DO BROWSE (aRotina)
*************
User Function MA415MNU()

*************

Private aFilBrw := {}

AAdd( aRotina,{ "Transf. Orc.", "U_fAltFilEnt()", 0, 3, NIL } )
//AAdd( aRotina,{ "Imediato", "U_FATR052()", 0, 3, NIL } )
//AAdd( aRotina,{ "Consulta CNPJ", "U_WFCNPJ()", 0, 3, NIL } )

Return(aRotina)


/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ PesaMan()()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***************
User Function fAltFilEnt()
***************

Local cFilEnt := Space(2)

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Filial de Entrega",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Entregar pela filial:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,cFilEnt:=u,cFilEnt)},oDlg99,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"SM0","cFilEnt",,)
oSBtn1     := SButton():New( 008,080,1,{||OkAltera(cFilEnt)},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return 

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ OkAltera()()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function OkAltera(cFilEnt)
   
   Local aArea 	:= GetArea("SCK")
   Local lCont	:= .T.
   Local cUF	:= Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_EST")
   //Valida estado de Transferencia
   If cFilEnt == "06" 
   		If !(cUF $ GetNewPar("MV_XUFPD06","PB/RN"))
   			MsgAlert("Não pode faturar para este cliente por esta empresa!")
   			lCont	:= .F.
   		EndIf
   EndIf

   If cFilEnt == "07" 
   		If !(cUF $ GetNewPar("MV_XUFPD07","PE/CE/BA"))
   			MsgAlert("Não pode faturar para este cliente por esta empresa!")
   			lCont	:= .F.
   		EndIf
   EndIf
   
   If lCont
   
	   dbSelectArea("SCK")
	   SCK->(DbSetOrder(1))
	   SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM))
	   
	   While SCJ->CJ_NUM == SCK->CK_NUM
	   
	   		RecLock("SCK",.F.)
	   		
	   		SCK->CK_FILVEN := cFilEnt
	   		SCK->CK_FILENT := cFilEnt
	   		
	   		MsUnLock()
	   		SCK->(DbSkip())
	   	
	   	EndDo

   	EndIf
   	
   oDlg99:End()
   RestArea(aArea)
   
Return


