#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110BLO  บAutor  ณEurivan Marques     บ Data ณ  02/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na aprovacao da Solicitacao de Compras     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlterado por ณ Gustavo Costa em 13/09/12                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*****************************
User Function MT110BLO(nOpcA)
*****************************

Local aArea		:= getArea()
local lRet			:= .F.
local cTipos 		:= GetTipos()
local cIdUsu
local aUsu
Local cDono		:= Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC, "CTT_DONO")
Local cContaAdm	:= Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO, "B1_XCCADM")
Local cContaPro	:= Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO, "B1_XCCPROD")
Local nOpcao		:= paramixb[1]
//alert("caiu no MT110BLO") //RETIRAR

If cDono == __cUserId .OR. __cUserId == '000000'	//administrador
	lRet	:= U_fTelaLib(SC1->C1_CC, cContaAdm, cContaPro)
Else
	Alert( "Voc๊ nใo tem acesso a Aprova็ใo desta solicita็ใo. Procure o Diretor responsavel." )
EndIf


If lRet
	Processa( {|| fGrvHist(SC1->C1_NUM, Time(), nOpcao) })
EndIf


RestArea(aArea)

return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110END  บAutor  ณEurivan Marques     บ Data ณ  22/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava data de Aprova็ao da Solicita็ใo                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************************
User Function MT110END(cNumSc,nOpcA)
************************************

RecLock("SC1",.F.)

SC1->C1_DTAPROV := dDataBase

SC1->(MsUnLock())

return


//Retorna o Superior do Usuario
*******************************
User function UserSup(cIDUsu)
*******************************

local aUsu := {}
local aSup := {}
local cSup := ""

PswOrder(1)
if PswSeek( cIDUsu, .T. )
   aUsu := PSWRET() // Retorna vetor com informa็๕es do usuแrio
   PswOrder(1)
   PswSeek(aUsu[1][11],.t.)
   aSup := PswRet(NIL)
   cSup := If(!Empty(aSup),aSup[01][02],"") //Superior
endif

return cSup


//Criado em 16/08/10 - Eurivan Marques
//Retorna todos os tipos com alcada de liberacao
*********************************
Static function GetTipos()
*********************************
local cQuery
local cRet := ""

cQuery := "SELECT RTRIM(X5_DESCRI)+RTRIM(X5_DESCSPA)+RTRIM(X5_DESCENG) AS TIPOS "
cQuery += "FROM "+RetSqlName("SX5")+" WHERE X5_TABELA = 'Z6' AND "
cQuery += "RTRIM(X5_DESCRI) != 'WFGERASC' AND D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "TTT"

DbSelectArea("TTT")

while ! TTT->(Eof())
   cRet += Alltrim(TTT->TIPOS)
   TTT->(DbSkip())
end

DbCloseArea("TTT")

return cRet


//Criado em 16/08/10 - Eurivan Marques
//Retorna usuario tem permissao para aprovar
*********************************
Static function GetAprov(cIdUsu)
*********************************
DbSelectArea("SX5")
DbSetOrder(1)

return SX5->(DbSeek(xFilial("SX5")+"Z6"+cIdUsu ))


//Criado em 16/08/10 - Eurivan Marques
//Retorna tipo de produtos por alcada
*********************************
Static function GetTipo(cIdUsu)
*********************************
local cRet := ""

if GetAprov( cIdUsu )
   cRet := Alltrim(X5_DESCRI)+Alltrim(X5_DESCSPA)+Alltrim(X5_DESCENG)
endif

return cRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณPrograma  :fTelaLib ณ Autor :Gustavo Costa          ณ Data :17/09/2012 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao : Tela de libera็ใo da solicita็ao de compras de acordo com   ณฑฑ
ฑฑณ          : as verbas da conta da solicita็ใo.                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   : T ou F                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       :                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fTelaLib(cCC, cContaAdm, cContaProd)

Local cSolic	:= SC1->C1_SOLICIT
Local cNum		:= SC1->C1_NUM
Local cCC 		:= cCC
Local cContaC	:= cContaAdm
Local nVerba 	:= 0
Local nGasto	:= 0
Local nTotSol 	:= 0
Local nEmSC 	:= 0
Local nSaldoV 	:= 0
Local nResult 	:= 0
Local cOk		:= .F.
Public cObs		:= ""

If SubStr(cCC,1,1) == "7"
	nVerba 		:= fVerba(cCC, cContaProd)
	nGasto		:= fGastoCta(cCC, cContaProd)
	nEmSC 		:= fTotSolA(cCC, cContaProd)
	cContaC		:= cContaProd
Else
	nVerba 		:= fVerba(cCC, cContaAdm)
	nGasto		:= fGastoCta(cCC, cContaAdm)
	nEmSC 		:= fTotSolA(cCC, cContaAdm)
	cContaC		:= cContaAdm
EndIf

nTotSol 	:= fTotSol(cNum)
nSaldoV 	:= nVerba - nGasto - nEmSC
nResult 	:= nSaldoV - nTotSol


/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg1","oPanel1","oSay1","oGet1","oSay2","oGet2","oPanel2","oSay3","oGet3","oPanel3","oSay4")
SetPrvt("oSay5","oGet5","oSay6","oGet6","oSBtn1","oSBtn2","oSay7","oGet7","oSay8","oGet8","oSay9","oGet9")
SetPrvt("oSBtn3","oGrp1","oMGet1")

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
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

oSay6      := TSay():New( 026,004,{||"Em Sol. Comp."},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet6      := TGet():New( 034,004,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nEmSC",,)
oGet6:bSetGet := {|u| If(PCount()>0,nEmSC:=u,nEmSC)}

oSay8      := TSay():New( 050,004,{||"Total Gasto"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet8      := TGet():New( 058,004,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nGasto",,)
oGet8:bSetGet := {|u| If(PCount()>0,nGasto:=u,nGasto)}

oSay5      := TSay():New( 004,125,{||"Saldo"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 012,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nSaldoV",,)
oGet5:bSetGet := {|u| If(PCount()>0,nSaldoV:=u,nSaldoV)}

oSay7      := TSay():New( 026,125,{||"Total Solicitado"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet7      := TGet():New( 034,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTotSol",,)
oGet7:bSetGet := {|u| If(PCount()>0,nTotSol:=u,nTotSol)}

oSay9      := TSay():New( 050,125,{||"Previsใo"},oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet9      := TGet():New( 058,125,,oPanel3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nResult",,)
oGet9:bSetGet := {|u| If(PCount()>0,nResult:=u,nResult)}

oGrp1      := TGroup():New( 130,003,178,194,"Observa็ใo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1     := TMultiGet():New( 138,008,,oGrp1,182,035,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cObs:=u,cObs)}

oSBtn1     := SButton():New( 180,128,1,,oDlg1,,"", )
oSBtn1:bAction := {|| cOk := .T. , oDlg1:End() }
oSBtn2     := SButton():New( 180,164,2,,oDlg1,,"", )
oSBtn2:bAction := {|| oDlg1:End(), cOk:= .F.}
//oSBtn3     := SButton():New( 136,164,2,,oDlg1,,"", )
//oSBtn3:bAction := {|| oDlg1:End(), cOk:= .F.}

oDlg1:Activate(,,,.T.)

Return cOk

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

TCQUERY cQry NEW ALIAS "TMP"

TMP->(dbgotop())

If TMP->(!EOF())
   
   nRet	:= TMP->CV1_VALOR
   
Endif

TMP->(DBCLOSEAREA())

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

TCQUERY cQry NEW ALIAS "TMP"

TMP->(dbgotop())

If TMP->(!EOF())
   
   nRet	:= TMP->VTOTAL
   
Endif

TMP->(DBCLOSEAREA())

Return  nRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotSol   บAutor  ณGustavo Costa       บ Data ณ  17/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para pegar o valor total da solicitacao.             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************
Static Function fTotSol(cNumero)
************************

LOCAL cQry		:=''
local nRet		:= 0
Local aPreco	:= {}

cQry	:= " SELECT C1_PRODUTO, C1_QUANT FROM " + RETSQLNAME("SC1") + " C1 "
cQry	+= " WHERE C1_NUM = '" + cNumero + "' "
cQry	+= " AND D_E_L_E_T_ <> '*' "
cQry	+= " AND C1_FILIAL = '" + xFilial("SC1") + "' "

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

While XTMP->(!EOF())
   
   aPreco	:= U_fUltPreco(XTMP->C1_PRODUTO)
   
   nRet	+= XTMP->C1_QUANT * aPreco[1]
   
   XTMP->(dbskip())
   
Enddo

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fGrvHist   บ Autor ณ Gustavo Costa     บ Data ณ  22/10/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para gravar o historico da libera็ใo บฑฑ
ฑฑบ        ณ das solicita็๕es de compra.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fGrvHist(cPed, cHora, nOpcao)

Local aArea		:= GETAREA()
Local nSeq			:= 1
Local cMensagem	:= ""
Local lGrava		:= .T.

dbSelectArea("ZB5")
dbSetOrder(1)

If ZB5->(dbseek(xFilial("ZB5") + cPed ))

	While ZB5->(!EOF()) .AND. cPed == ZB5->ZB5_NUM
		nSeq	:= nSeq + 1
		ZB5->(dbskip())
	EndDo

EndIf

ZB5->(RECLOCK("ZB5",.T.))

ZB5->ZB5_FILIAL	:= XFILIAL("ZB5")
ZB5->ZB5_NUM		:= cPed
ZB5->ZB5_SEQ		:= strZero(nSeq,2)
ZB5->ZB5_DATA		:= dDataBase
ZB5->ZB5_HORA		:= cHora
ZB5->ZB5_TIPO		:= STR(nOpcao)
ZB5->ZB5_USUARI	:= cUserName
//ZB5->ZB5_CODUSU	:= __cUserId
ZB5->ZB5_OBS		:= cObs

MSUNLOCK()

cMensagem += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
cMensagem += '<title>Untitled Document</title>'
cMensagem += '</head>'

cMensagem += '<body>'
cMensagem += '<div align="center">'
cMensagem += '        <table border="0" cellpadding="0" width="680">'
dbSelectArea("SM0")
cMensagem += '          <tr>'
cMensagem += '            <td colspan="6" bgcolor="#66CC66"><p align="center"><strong>' + SM0->M0_FILIAL + '</strong></p></td>'
cMensagem += '          </tr>'
cMensagem += '          <tr>'
cMensagem += '            <td colspan="6" bgcolor="#66CC66"><p align="center"><strong>SOLICITAวรO DE COMPRA - ' + cPed + '</strong></p></td>'
cMensagem += '          </tr>'
cMensagem += '          <tr>'
cMensagem += '            <td width="108" colspan="1"><p><strong>Resultado:</strong></p></td>'

Do Case
	Case nOpcao = 1
		cMensagem += '            <td colspan="5"><p>Aprovada</p></td>'
	Case nOpcao = 2
		cMensagem += '            <td colspan="5"><p>Rejeitada</p></td>'
	Case nOpcao = 3
		cMensagem += '            <td colspan="5"><p>Bloqueada</p></td>'
	Otherwise
		cMensagem += '            <td colspan="5"><p>Reprovado</p></td>'
EndCase

cMensagem += '          </tr>'
cMensagem += '          <tr>'
cMensagem += '            <td><p><strong>Obs:</strong></p></td>'
cMensagem += '            <td colspan="5"><p>' + cObs + '</p></td>'
cMensagem += '          </tr>'
cMensagem += '          <tr>'
cMensagem += '            <td colspan="6"><p>&nbsp;</p></td>'
cMensagem += '          </tr>'
cMensagem += '          <tr bgcolor="#66CC66">'
cMensagem += '            <td colspan="6"><p align="center"><strong>DETALHE DA SOLICITAวรO</strong></p></td>'
cMensagem += '          </tr>'
cMensagem += '          <tr>'
cMensagem += '            <td width="108" colspan="1"><p align="center"><strong> Codigo </strong></p></td>'
cMensagem += '            <td colspan="4"><p align="center"><strong>Descri็ใo</strong></p></td>'
cMensagem += '            <td width="150" colspan="1"><p align="center"><strong>Quantidade</strong></p></td>'
cMensagem += '          </tr>'

dbSelectArea("SC1")
dbSeek(xFilial("SC1") + cPed)

While SC1->(!EOF()) .and. SC1->C1_NUM == cPed
                            
	cMensagem += '          <tr>'
	cMensagem += '            <td colspan="1"><p>' + SC1->C1_PRODUTO + '</p></td>'
	cMensagem += '            <td colspan="4"><p>' + SC1->C1_DESCRI + '</p></td>'
	cMensagem += '            <td colspan="1"><p align="center">' + Transform(SC1->C1_QUANT, "@E 999,999,999") + '</p></td>'
	cMensagem += '          </tr>'
   	SC1->(dbskip())
   
EndDo

cMensagem += '  </table>'
cMensagem += '</div>'
cMensagem += '</body>'
cMensagem += '</html>'

cEmail   	:= GetNewPar("MV_XSCLIB","compras@ravaembalagens.com.br")  //voltar
//cEmail   	:= "flavia.rocha@ravaembalagens.com.br"                    //retirar
cCopia   	:= ""//GetNewPar("gustavo@ravaembalagens.com.br") 
cAssunto 	:= "Solicita็ใo de compra - " + cPed
cAnexo		:= ""

U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )

RESTAREA(aArea)

Return
