#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fHisLib     ³ Autor :Gustavo Costa       ³ Data :20/05/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Mostra o historico de liberação dos pedidos de venda.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fHisLib()

Local cQuery	:= ''
Local cCampos	:= {}
Local cNunPed := SC5->C5_NUM
Local cCodCli := SC5->C5_CLIENTE + '/' + SC5->C5_LOJACLI
Local cNomCli := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_NOME")
Local cStatus := 'BLOQUEADO - FINANCEIRO'

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oSay1","oGet1","oSay2","oGet2","oSay3","oGet3")

oTbl1()

cCampos := {{"ZB3_STATUS "	,"","Operação",""},;
			 {"ZB3_SEQ "		,"","Seq."		,""},;
			 {"ZB3_DATALI "	,"","Data"		,""},;
			 {"ZB3_HORA"		,"","Hora"		,""},;
			 {"ZB3_USUARI"	,"","Usuário"	,""}}

Dbselectarea("TMP1")

cQuery	:= " SELECT * FROM " + RETSQLNAME("ZB3") + " ZB3 "
cQuery	+= " WHERE ZB3.ZB3_PEDIDO = '" + SC5->C5_NUM + "' " 
cQuery	+= " AND ZB3.ZB3_FILIAL = '" + xFilial("ZB3") + "' "
cQuery	+= " AND ZB3.D_E_L_E_T_ <> '*' "

If Select("XIT") > 0
	XIT->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XIT"
TcSetField("XIT", "ZB3_DATALI", "D")

XIT->(dbgotop())

While XIT->(!EOF())

	reclock("TMP1", .T.)

	TMP1->ZB3_SEQ    		:= XIT->ZB3_SEQ
	TMP1->ZB3_DATALI 		:= XIT->ZB3_DATALI
	TMP1->ZB3_HORA  		:= XIT->ZB3_HORA
	TMP1->ZB3_USUARI  	:= XIT->ZB3_USUARI
	TMP1->ZB3_STATUS  	:= IIF(XIT->ZB3_ORIGEM == 'WF_FATF002', 'Bloqueado', 'Liberado') 

	msunlock()
	XIT->(dbSkip())
EndDo

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,428,836,"Histórico de Liberação do Pedido de Venda",,,.F.,,,,,,.T.,,,.F. )
DbSelectArea("TMP1")
DbGoTop()
oBrw1      := MsSelect():New( "TMP1","","",cCampos,.F.,,{052,000,150,288},,, oDlg1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK

oGrp1      := TGroup():New( 000,000,051,288,"Pedido",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 008,004,{||"Número"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 016,004,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNunPed",,)
oGet1:bSetGet := {|u| If(PCount()>0,cNunPed:=u,cNunPed)}

oSay2      := TSay():New( 028,004,{||"Cod. Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 036,004,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCodCli",,)
oGet2:bSetGet := {|u| If(PCount()>0,cCodCli:=u,cCodCli)}

oSay3      := TSay():New( 028,076,{||"Nome Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 036,076,,oGrp1,205,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomCli",,)
oGet3:bSetGet := {|u| If(PCount()>0,cNomCli:=u,cNomCli)}

dbSelectArea("SC9")
If dbSeek(xFilial("SC9") + cNunPed)

	If SC9->C9_BLCRED == '  '
		cStatus := 'LIBERADO - FINANCEIRO'
	EndIf

Else

		cStatus := 'FALTA LIBERAR QUANTIDADE'

EndIf 

oSay4      := TSay():New( 008,076,{|| "Status" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet4      := TGet():New( 016,076,,oGrp1,205,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cStatus",,)
oGet4:bSetGet := {|u| If(PCount()>0,cStatus:=u,cStatus)}

oDlg1:Activate(,,,.T.)

Return


**************************
Static Function oTbl1()
**************************

Local aCampos := {}


AADD(aCampos,{"ZB3_STATUS"  ,"C",10,000})					
AADD(aCampos,{"ZB3_SEQ" 		,"C",02,000})		
AADD(aCampos,{"ZB3_DATALI" 	,"D",08,000})					
AADD(aCampos,{"ZB3_HORA"		,"C",05,000})					
AADD(aCampos,{"ZB3_USUARI"	,"C",14,000})					

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

coTbl1 := CriaTrab( aCampos, .T. )
Use (coTbl1) Alias TMP1 New Exclusive

Return
