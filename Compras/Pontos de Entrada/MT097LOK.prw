#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT097LOK  บAutor  ณGustavo Costa       บ Data ณ  01/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE Utilizado para Substituir programa de libera็ใo         บฑฑ
ฑฑบ          ณ do pedido de compra.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
LOCALIZAวรO   :  Function A097LIBERA - Fun็ใo da Dialog de libera็ใo e bloqueio 
dos documentos com al็ada. 

EM QUE PONTO :  O ponto se encontra no inicio da fun็ใo A097LIBERA antes da 
cria็ใo da dialog de libera็ใo e bloqueio, pode ser utilizado par validar se 
a opera็ใo deve continuar ou nใo conforme seu retorno, ou ainda pode ser usado 
para substituir o programa de libera็ใo por um especifico do usuario.

*/
User Function MT094LOK() 
//User Function MT097LOK() 
/*

Local lRet 		:= .T.
Local nVerba		:= 0
Local nGasto		:= 0
Local nTotPC		:= 0
Local nEmPCAbe	:= 0
Local cContaAdm	:= ""
Local cContaPro	:= ""
Local cContaC		:= ""
Local nSaldoV		:= 0
Local nResult		:= 0
Local cNumSC		:= ""
Local cCC			:= ""
Local cSolic		:= ""
Local cNum			:= ""
Local aAreaSCR	:= GetArea("SCR")
Local lContinua	:= .T.
Local oFont1     	:= TFont():New('Courier New',22,22,.F.,.T.,5,.T.,5,.F.,.F.)

Public cObs		:= ""

//Se nao for um pedido de compra, nao valida.
If SCR->CR_TIPO <> "PC"

	Return .T.
	
EndIf

//Se for Fabrica CAIXA, nao valida.
If SM0->M0_CODFIL = "03"

	Return .T.
	
EndIf

dbSelectArea("SC7")
dbsetOrder(1)
SC7->(dbSeek(xFilial("SC7") + Alltrim(SCR->CR_NUM) ))

cCC				:= SC7->C7_CC
cContaProd		:= Posicione("SB1",1,xFilial("SB1") + SC7->C7_PRODUTO, "B1_XCCPROD")
cContaAdm		:= Posicione("SB1",1,xFilial("SB1") + SC7->C7_PRODUTO, "B1_XCCADM")
cSolic			:= Posicione("SC1",1,xFilial("SC1") + SC7->C7_NUMSC, "C1_SOLICIT")


While SC7->(!EOF()) .AND. Alltrim(SC7->C7_NUM) == Alltrim(SCR->CR_NUM)

	nTotPC	+= SC7->C7_TOTAL + SC7->C7_FRETE
	
	If POSICIONE("SB1",1,xfilial("SB1") + SC7->C7_PRODUTO, 'B1_TIPO') $ GetNewPar("MV_XTPLIB","MP") // tipos dos produtos liberados da valida็ใo do or็amento
		lContinua	:= .F.
	EndIf
	
	SC7->(dbSkip())

EndDo

If !lContinua

	Return .T.
	
EndIf

If SubStr(cCC,1,1) == "7"
	nVerba 		:= fVerba(cCC, cContaProd)
	nGasto			:= fGastoCta(cCC, cContaProd)
	nEmPC 			:= fTotPCA(cCC, cContaProd)
	cContaC		:= cContaProd
Else
	nVerba 		:= fVerba(cCC, cContaAdm)
	nGasto			:= fGastoCta(cCC, cContaAdm)
	nEmPC 			:= fTotPCA(cCC, cContaAdm)
	cContaC		:= cContaAdm
EndIf


nSaldoV 	:= nVerba - nGasto - nEmPC
nResult 	:= nSaldoV - nTotPC

If nResult < 0

	lRet	:= .F.
	MsgAlert("Impossํvel liberar!")
	
EndIf 

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
/*
SetPrvt("oDlg1","oPanel1","oSay1","oGet1","oSay2","oGet2","oPanel2","oSay3","oGet3","oPanel3","oSay4")
SetPrvt("oSay5","oGet5","oSay6","oGet6","oSBtn1","oSBtn2","oSay7","oGet7","oSay8","oGet8","oSay9","oGet9","oSay10")
SetPrvt("oSBtn3","oGrp1","oMGet1","oBtn1")

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
/*
oDlg1      := MSDialog():New( 160,342,545,735,"Libera็ใo",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 004,003,"",oDlg1,,.F.,.F.,,,194,028,.T.,.F. )
oSay1      := TSay():New( 004,004,{||"Solicitante"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 012,004,,oPanel1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSolic",,)
oGet1:bSetGet := {|u| If(PCount()>0,cSolic:=u,cSolic)}

oSay2      := TSay():New( 004,076,{||"Centro de Custo"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet2      := TGet():New( 012,076,,oPanel1,114,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCC",,)
oGet2:bSetGet := {|u| If(PCount()>0,cCC:=u,Alltrim(cCC) + " - " + Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01"))}

oPanel2    := TPanel():New( 032,003,"",oDlg1,,.F.,.F.,,,194,028,.T.,.F. )
oSay3      := TSay():New( 004,004,{||"Conta"},oPanel2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 012,004,,oPanel2,187,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cContaC",,)
oGet3:bSetGet := {|u| If(PCount()>0,cContaC:=u,AllTrim(cContaC) + " - " + Posicione("CT1",1,xFilial("CT1")+cContaC,"CT1_DESC01"))}

oPanel3    := TPanel():New( 061,003,"",oDlg1,,.F.,.F.,,,194,070,.T.,.F. )

oSay4      := TSay():New( 004,004,{||"Verba"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet4      := TGet():New( 012,004,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVerba",,)
oGet4:bSetGet := {|u| If(PCount()>0,nVerba:=u,nVerba)}

oSay6      := TSay():New( 026,004,{||"Em Ped. Comp."},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet6      := TGet():New( 034,004,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nEmPC",,)
oGet6:bSetGet := {|u| If(PCount()>0,nEmPC:=u,nEmPC)}

oSay8      := TSay():New( 050,004,{||"Total Gasto"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet8      := TGet():New( 058,004,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nGasto",,)
oGet8:bSetGet := {|u| If(PCount()>0,nGasto:=u,nGasto)}

oSay5      := TSay():New( 004,125,{||"Saldo"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 012,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nSaldoV",,)
oGet5:bSetGet := {|u| If(PCount()>0,nSaldoV:=u,nSaldoV)}

oSay7      := TSay():New( 026,125,{||"Total Pedido"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet7      := TGet():New( 034,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTotPC",,)
oGet7:bSetGet := {|u| If(PCount()>0,nTotPC:=u,nTotPC)}

oSay9      := TSay():New( 050,125,{||"Previsใo"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet9      := TGet():New( 058,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nResult",,)
oGet9:bSetGet := {|u| If(PCount()>0,nResult:=u,nResult)}

oGrp1      := TGroup():New( 130,003,178,194,"Observa็ใo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1     := TMultiGet():New( 138,008,,oGrp1,182,035,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cObs:=u,cObs)}

If Val(SubStr(DtoC(dDataBase),1,2)) > 24
	cObs		:= "DATA DE CORTE ATINGIDA"
	oMGet1:SetFont(oFont1)
EndIf

oSBtn1     := SButton():New( 180,128,1,,oDlg1,,"", )
oSBtn1:bAction := {|| cOk := .T. , oDlg1:End() }
oSBtn2     := SButton():New( 180,164,2,,oDlg1,,"", )
oSBtn2:bAction := {|| oDlg1:End(), cOk:= .F.}
oSBtn3     := TButton():New( 180,060,"&Solicitar Verba",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oSBtn3:bAction := { || U_fSolVerba(cContaC, cCC, nSaldoV) }

oBtn1      := TButton():New( 094,068,"Det...",oDlg1,,024,010,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || Processa({|| fDetPCA(cCC, cContaC)}) }

If nResult > 0
	oSBtn3:lActive := .F.
EndIf

oDlg1:Activate(,,,.T.)

RestArea(aAreaSCR)
*/
Return .T. //lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerba    บAutor  ณGustavo Costa       บ Data ณ  17/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor da verba por conta.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fVerba(cCC, cConta)
************************

LOCAL cQry		:=''
local nRet		:= 0

cQry	:= " SELECT CV1_VALOR FROM " + RETSQLNAME("CV1")
cQry	+= " WHERE D_E_L_E_T_ <> '*' "
cQry	+= " AND CV1_CT1INI = '" + cConta + "' "
cQry	+= " AND CV1_CTTINI = '" + cCC + "' "
cQry	+= " AND CV1_DTINI <= '" + DtoS(dDataBase) + "' "
cQry	+= " AND CV1_DTFIM >= '" + DtoS(dDataBase) + "' "

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

If XTMP->(!EOF())
   
   nRet	:= XTMP->CV1_VALOR
   
Endif

XTMP->(DBCLOSEAREA())

Return  nRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGastoCta บAutor  ณGustavo Costa       บ Data ณ  17/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor gasto por conta contabil no periodo.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fGastoCta(cCC, cConta)
************************

LOCAL cQry		:=''
local nRet		:= 0

cQry	:= " SELECT SUM(D1_TOTAL) VTOTAL FROM " + RETSQLNAME("SD1") + " D1 "
cQry	+= " INNER JOIN  " + RETSQLNAME("SB1") + " B1 "
cQry	+= " ON B1_COD = D1_COD "
cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " F4 "
cQry	+= " ON D1_TES = F4_CODIGO "
cQry	+= " WHERE D1.D_E_L_E_T_ <> '*' "
cQry	+= " AND B1.D_E_L_E_T_ <> '*' "
cQry	+= " AND F4_DUPLIC = 'S' "
cQry	+= " AND F4.D_E_L_E_T_ <> '*' "
cQry	+= " AND D1_CC = '" + cCC + "' "
If SubStr(cCC,1,1) == "7"
	cQry	+= " AND B1_XCCPROD = '" + cConta + "' "
Else
	cQry	+= " AND B1_XCCADM = '" + cConta + "' "
EndIf
cQry	+= " AND D1_DTDIGIT BETWEEN '" + DtoS(FIRSTDAY(dDataBase)) + "' AND '" + DtoS(LASTDAY(dDataBase)) + "' "

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

If XTMP->(!EOF())
   
   nRet	:= XTMP->VTOTAL
   
Endif

XTMP->(DBCLOSEAREA())

Return  nRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotPCA   บAutor  ณGustavo Costa       บ Data ณ  18/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor total dos pedidos de comp. aberto.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fTotPCA(cCC, cConta)
************************

LOCAL cQry		:=''
local nRet		:= 0                 
Local aPreco	:= {}

cQry	:= " SELECT SUM((C7_QUANT - C7_QUJE)*C7_PRECO) AS TOTALPCA FROM " + RETSQLNAME("SC7") + " C7 "
cQry	+= " INNER JOIN " + RETSQLNAME("SB1") + " B1 "
cQry	+= " ON B1_COD = C7_PRODUTO "
cQry	+= " WHERE C7.D_E_L_E_T_ <> '*' "
cQry	+= " AND C7_QUANT - C7_QUJE > 0 "
cQry	+= " AND C7_CONAPRO = 'L' "
cQry	+= " AND C7_RESIDUO <> 'S' "
cQry	+= " AND C7_CC = '" + cCC + "' "

If SubStr(cCC,1,1) == "7"
	cQry	+= " AND B1_XCCPROD = '" + cConta + "' "
Else
	cQry	+= " AND B1_XCCADM = '" + cConta + "' "
EndIf

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

nRet	:= XTMP->TOTALPCA
   
XTMP->(DBCLOSEAREA())

Return  nRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotSolA   บAutor  ณGustavo Costa       บ Data ณ  18/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor total das solicitac๕es abertas.   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fTotSolA(cCC, cConta)
************************

LOCAL cQry		:=''
local nRet		:= 0                 
Local aPreco	:= {}

cQry	:= " SELECT C1_PRODUTO, C1_QUANT FROM " + RETSQLNAME("SC1") + " C1 "
cQry	+= " INNER JOIN " + RETSQLNAME("SB1") + " B1 "
cQry	+= " ON B1_COD = C1_PRODUTO "
cQry	+= " WHERE C1.D_E_L_E_T_ <> '*' "
cQry	+= " AND C1_QUANT - C1_QUJE > 0 "
cQry	+= " AND C1_APROV = 'L' "
cQry	+= " AND C1_CC = '" + cCC + "' "
If SubStr(cCC,1,1) == "7"
	cQry	+= " AND B1_XCCPROD = '" + cConta + "' "
Else
	cQry	+= " AND B1_XCCADM = '" + cConta + "' "
EndIf

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

If XTMP->(!EOF())
                            
   aPreco	:= U_fUltPreco(XTMP->C1_PRODUTO)
   
   nRet	+= XTMP->C1_QUANT * aPreco[1]
   
   XTMP->(dbskip())
   
Endif

XTMP->(DBCLOSEAREA())

Return  nRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSolVerba  บAutor  ณGustavo Costa       บ Data ณ  18/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para solicitar verba para um orcamento contabil.     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function fSolVerba(cConta, cCC, nSld)

Local cRec
Local cHoraI
Local cHoraF
Local cHoraD
local dDataI
local dDataF
LOCAL cQry		:=''
Local nValor := 0
Local cRevisa	:= GetNewPar("MV_XREVISA","001")
Local aArea	:= GetArea()

If cCC == "" .OR. cConta == ""
	MsgAlert("Erro no Cadastro!")
	Return
EndIf

dbSelectArea("SX5")
dbSetOrder(1)

If !(dbSeek(xFilial("SX5") + "YH" + __CUSERID))
	MsgAlert("Usuแrio nใo autorizado!")
	Return
EndIf

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis                                                 ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Qual o Valor Solicitado?",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Digite o Valor:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nValor:=u,nValor)},oDlg99,060,010,'@R 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nValor",,)
oSBtn1     := SButton():New( 008,080,1,{|| oDlg99:End() },oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

cQry	:= " SELECT * FROM " + RETSQLNAME("CV1")
cQry	+= " WHERE D_E_L_E_T_ <> '*' "
cQry	+= " AND CV1_ORCMTO = '" + SubStr(DtoS(dDataBase),1,4) + "' "
cQry	+= " AND CV1_CT1INI = '" + cConta + "' "
cQry	+= " AND CV1_CTTINI = '" + cCC + "' "
cQry	+= " AND CV1_DTINI <= '" + DtoS(dDataBase) + "' "
cQry	+= " AND CV1_DTFIM >= '" + DtoS(dDataBase) + "' "
cQry	+= " AND CV1_REVISA = '" + cRevisa + "' "

If Select("XTMP") > 0
	XTMP->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

If XTMP->(!EOF())
	
	dbSelectArea("ZB7")
	
	IF ZB7->(dbSeek(xFilial("ZB7") + XTMP->CV1_ORCMTO + XTMP->CV1_CALEND + XTMP->CV1_MOEDA + XTMP->CV1_REVISA + XTMP->CV1_SEQUEN + XTMP->CV1_PERIOD ))
	
		MsgAlert("Solicita็ใo jแ registrada para este perํodo!")
	
	Else
	
		RecLock("ZB7", .T.)
		
		ZB7->ZB7_FILIAL	:= xFilial("ZB7")
		ZB7->ZB7_ORCMTO	:= XTMP->CV1_ORCMTO
		ZB7->ZB7_DESCRI 	:= XTMP->CV1_DESCRI
		ZB7->ZB7_CALEND	:= XTMP->CV1_CALEND
		ZB7->ZB7_MOEDA	:= XTMP->CV1_MOEDA
		ZB7->ZB7_REVISA	:= XTMP->CV1_REVISA
		ZB7->ZB7_SEQUEN	:= XTMP->CV1_SEQUEN
		ZB7->ZB7_CT1INI	:= XTMP->CV1_CT1INI
		ZB7->ZB7_CONTA	:= POSICIONE("CT1", 1, XFILIAL("CT1") + XTMP->CV1_CT1INI, "CT1_DESC01")
		ZB7->ZB7_CTTINI	:= XTMP->CV1_CTTINI
		ZB7->ZB7_CCDESC	:= POSICIONE("CTT", 1, XFILIAL("CTT") + XTMP->CV1_CTTINI, "CTT_DESC01")
		ZB7->ZB7_VALORA	:= XTMP->CV1_VALOR
		ZB7->ZB7_VATUAL	:= nValor
		ZB7->ZB7_PERIOD	:= XTMP->CV1_PERIOD
		ZB7->ZB7_APROV1	:= cUserName
		ZB7->ZB7_DATA		:= dDataBase
		
		ZB7->(MsUnLock())
		
		MsgAlert("Solicita็ใo Incluํda!")
	
	EndIf
   
Endif

dbCloseArea("XTMP")
restArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotPCA   บAutor  ณGustavo Costa       บ Data ณ  18/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor total dos pedidos de comp. aberto.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fDetPCA(cCC, cConta)
************************

LOCAL cQry		:=''
local nRet		:= 0                 
Local aCampos	:= {}
Local cMarca  := GetMark()				//Flag para marcacao
Local lInvert := .F.

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg2","oBrw2")

cQry	:= " SELECT C7_NUM, C7_MEDICAO, B1_COD, C7_DESCRI, C7_CC, B1_XCCPROD, B1_XCCADM, C7_TOTAL, C7_EMISSAO FROM " + RETSQLNAME("SC7") + " C7 "
cQry	+= " INNER JOIN " + RETSQLNAME("SB1") + " B1 "
cQry	+= " ON B1_COD = C7_PRODUTO "
cQry	+= " WHERE C7.D_E_L_E_T_ <> '*' "
cQry	+= " AND C7_QUANT - C7_QUJE > 0 "
cQry	+= " AND C7_CONAPRO = 'L' "
cQry	+= " AND C7_RESIDUO <> 'S' "
cQry	+= " AND C7_CC = '" + cCC + "' "

If SubStr(cCC,1,1) == "7"
	cQry	+= " AND B1_XCCPROD = '" + cConta + "' "
Else
	cQry	+= " AND B1_XCCADM = '" + cConta + "' "
EndIf

If Select("TP2") > 0
	TMP->(dbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TP2"
TCSetField( 'TP2', 'C7_EMISSAO', 'D' )

//oTbl2()
TP2->(dbgotop())
/*
While TP2->(!EOF())

	RecLock("XTP2",.T.)
	
	XTP2->NUM			:= TP2->C7_NUM
	XTP2->MEDICAO		:= TP2->C7_MEDICAO
	XTP2->COD			:= TP2->B1_COD
	XTP2->DESCRI		:= TP2->C7_DESCRI
	XTP2->CC			:= TP2->C7_CC
	XTP2->XCCPROD		:= TP2->B1_XCCPROD
	XTP2->XCCADM		:= TP2->B1_XCCADM
	XTP2->TOTAL		:= TP2->C7_TOTAL
	XTP2->EMISSAO		:= TP2->C7_EMISSAO

	MsUnLock()

	TP2->(dbSkip())
	
EndDo

AADD(aCampos,{"NUM"  			,"","Pedido"         	,""  	})					//Flag marcacao
AADD(aCampos,{"MEDICAO" 			,"","Medi็ใo"  	,""  	})					//Data PDCessa
AADD(aCampos,{"COD" 				,"","Cod. Prod"		,""  	})					//Documento
AADD(aCampos,{"DESCRI"			,"","Desc." 		,""		})					//Item
AADD(aCampos,{"CC"				,"","C. Custo" 	,""		})					//C๓digo do Produto
AADD(aCampos,{"XCCPROD"			,"","Conta Prd"	,"@!"	})					//Descricao do Produto
AADD(aCampos,{"XCCADM"			,"","Conta Adm" 	,""		})					//Quantidade
AADD(aCampos,{"TOTAL"			,"","Total" 	,""		})					//Pre็o de Venda
AADD(aCampos,{"EMISSAO"			,"","Emissใo" 	,""		})					//Total
*/

AADD(aCampos,{"C7_NUM"  				,"","Pedido"      ,""  	})					//Flag marcacao
AADD(aCampos,{"C7_MEDICAO" 			,"","Medi็ใo"  	,""  	})					//Data PDCessa
AADD(aCampos,{"B1_COD" 				,"","Cod. Prod"	,""  	})					//Documento
AADD(aCampos,{"C7_DESCRI"			,"","Desc." 		,""		})					//Item
AADD(aCampos,{"C7_CC"				,"","C. Custo" 	,""		})					//C๓digo do Produto
AADD(aCampos,{"B1_XCCPROD"			,"","Conta Prd"	,"@!"	})					//Descricao do Produto
AADD(aCampos,{"B1_XCCADM"			,"","Conta Adm" 	,""		})					//Quantidade
AADD(aCampos,{"C7_TOTAL"				,"","Total" 		,"@E 999,999.99"		})					//Pre็o de Venda
AADD(aCampos,{"C7_EMISSAO"			,"","Emissใo" 	,""		})					//Total

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg2      := MSDialog():New( 126,254,335,1254,"Lista dos Pedidos de Compra",,,.F.,,,,,,.T.,,,.F. )
DbSelectArea("TP2")
TP2->(dbgotop())
oBrw2      := MsSelect():New("TP2","",,aCampos,@lInvert,@cMarca,{000,000,102,498},)
						  //New( "XTP2","","",{{"","","Pedidos de Compra",""}},.F.,,{000,000,102,498},,, oDlg2 ) 
oBrw2:oBrowse:nClrPane := CLR_BLACK
oBrw2:oBrowse:nClrText := CLR_BLACK

oDlg2:Activate(,,,.T.)
   
TP2->(DBCLOSEAREA())
//XTP2->(DBCLOSEAREA())

Return  nRet 

****************

Static Function oTbl2()

***************

Local aFds := {}
Aadd( aFds , {"NUM"   		,"C",006,000} )
Aadd( aFds , {"MEDICAO"  	,"C",006,000} )
Aadd( aFds , {"COD"   		,"C",015,000} )
Aadd( aFds , {"DESCRI"   	,"C",040,000} )
Aadd( aFds , {"CC"   		,"C",009,000} )
Aadd( aFds , {"XCCPROD"   	,"C",009,000} )
Aadd( aFds , {"XCCADM"   	,"C",009,000} )
Aadd( aFds , {"TOTAL"   		,"N",012,002} )
Aadd( aFds , {"EMISSAO"   	,"D",010,000} )

If Select("XTP2") > 0
	TMP->(dbCloseArea())
EndIf

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias XTP2 New Exclusive

Return 


