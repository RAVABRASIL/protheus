#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณPrograma  :NEWSOURCE ณ Autor :TEC1 - Designer       ณ Data :16/10/2012 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao :                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametros:                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   :                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       :                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fDetPC(cNUM, cTP)

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis do Tipo Local, Private e Public                 ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local nOpc 		:= GD_INSERT+GD_DELETE+GD_UPDATE

Local cTipoDoc	:= AllTrim(cTP)
LOCAL cQry			:= ''
Local nTotalPC	:= 0
Local nVlFret   := 0
local nPercFrt	:= 0
Local cFornece	:= ""
Local dPrevisao
local aCampos		:= {}
Local aUltimoP
Local cCondica := ""
Local cUsuario := ""
Local aUsu     := ""
Local cUsu     := ""
Local cC       := ""
Local cCC      := ""
Local cTPFrete := ""
//fUltPreco()
Local nVerba	:= 0
Local nGasto	:= 0
Local nSaldoV	:= 0
Local nResult	:= 0
Local nEmPCAbe:= 0
Local cContaAdm	:= ""
Local cContaPro	:= ""
Local cCodProd	:= ""

Private aCoBrw3 := {}
Private aHoBrw3 := {}
Private noBrw3  := 0
Private cCodPed := AllTrim(cNUM)
Private cSolic := ""

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGet1","oGet2","oGet3","oGet4","oGet5")
SetPrvt("oGrp2","oBrw1","oBrw2","oGrp3","oBrw3","oSBtn1")
Private LF := CHR(13) + CHR(10)

If cTipoDoc <> "PC"
	Msgalert("Nใo ้ um Pedido!")
	Return
EndIf

cQry	:= " SELECT " + LF 
 
//DT ULT PREวO
cQry    += " DTULTPRE = ( " + LF

	cQry	+= "SELECT TOP 1 A.D1_DTDIGIT FROM " + RETSQLNAME("SD1") + " A " + LF
	cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " AF4 " + LF 
	cQry	+= " ON A.D1_TES = AF4.F4_CODIGO " + LF 
	cQry	+= " WHERE A.D1_COD = SC7.C7_PRODUTO " + LF 
	cQry	+= " AND A.D1_FILIAL = '" + xFilial("SD1") + "' " + LF 
	cQry	+= " AND A.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND AF4.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND AF4.F4_DUPLIC = 'S' " + LF 
	cQry	+= " ORDER BY A.D1_DTDIGIT DESC " + LF 
cQry	+= " ) " + LF + LF

//QT DO ULT PREวO
cQry    += " , QTULTPRE = ( " + LF

	cQry	+= "SELECT TOP 1 B.D1_QUANT FROM " + RETSQLNAME("SD1") + " B " + LF
	cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " BF4 " + LF 
	cQry	+= " ON B.D1_TES = BF4.F4_CODIGO " + LF 
	cQry	+= " WHERE B.D1_COD = SC7.C7_PRODUTO " + LF 
	cQry	+= " AND B.D1_FILIAL = '" + xFilial("SD1") + "' " + LF 
	cQry	+= " AND B.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND BF4.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND BF4.F4_DUPLIC = 'S' " + LF 
	cQry	+= " ORDER BY B.D1_DTDIGIT DESC " + LF 
cQry	+= " ) " + LF + LF

//ULTIMO PREวO UNIT
cQry    += " , ULTPREU = ( " + LF

	cQry	+= "SELECT TOP 1 C.D1_VUNIT FROM " + RETSQLNAME("SD1") + " C " + LF 
	cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " CF4 " + LF 
	cQry	+= " ON C.D1_TES = CF4.F4_CODIGO " + LF 
	cQry	+= " WHERE C.D1_COD = SC7.C7_PRODUTO " + LF 
	cQry	+= " AND C.D1_FILIAL = '" + xFilial("SD1") + "' " + LF 
	cQry	+= " AND C.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND CF4.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND CF4.F4_DUPLIC = 'S' " + LF 
	cQry	+= " ORDER BY C.D1_DTDIGIT DESC " + LF 
cQry	+= " ) " + LF + LF 

//ULTIMO PREวO TOTAL
cQry    += " , ULTPRET = ( " + LF

	cQry	+= "SELECT TOP 1 D.D1_TOTAL FROM " + RETSQLNAME("SD1") + " D " + LF
	cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " DF4 " + LF 
	cQry	+= " ON D.D1_TES = DF4.F4_CODIGO " + LF 
	cQry	+= " WHERE D.D1_COD = SC7.C7_PRODUTO " + LF 
	cQry	+= " AND D.D1_FILIAL = '" + xFilial("SD1") + "' " + LF 
	cQry	+= " AND D.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND DF4.D_E_L_E_T_ <> '*' " + LF 
	cQry	+= " AND DF4.F4_DUPLIC = 'S' " + LF 
	cQry	+= " ORDER BY D.D1_DTDIGIT DESC " + LF 
cQry	+= " ) " + LF  + LF
//
cQry    += " , * FROM " + RETSQLNAME("SC7") + " SC7 " + LF
cQry	+= " WHERE SC7.C7_NUM = '" + cCodPed + "'AND C7_FILIAL = '" +xFilial("SC7")+ "' AND SC7.D_E_L_E_T_ = '' "
MemoWrite("C:\TEMP\COMC009.SQL", cQry )
If Select("XIT") > 0
	XIT->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "XIT"
TcSetField("XIT", "DTULTPRE", "D")

cFornece  := Posicione("SA2",1,xFilial("SA2")+XIT->C7_FORNECE,"A2_NOME")
dPrevisao := StoD(XIT->C7_DATPRF)
cCondica  := Posicione("SE4",1,xFilial("SE4")+XIT->C7_COND,"E4_DESCRI")
cUsuario  := Posicione("SC1",1,xFilial("SC1")+XIT->C7_NUMSC,"C1_SOLICIT")
cC        := Posicione("CTT",1,xFilial("CTT")+XIT->C7_CC,"CTT_DESC01")
cTPFrete  := ALLTRIM(XIT->C7_TPFRETE)
//Alert(cUsuario)
cCC			:= XIT->C7_CC
cCodProd	:= XIT->C7_PRODUTO

PswOrder(1)               //SELECIONA A ORDEM DE PESQUISA DO USUมRIO UTILIZADA PELA PSWSEEK ABAIXO
If PswSeek( Alltrim(cUsuario) , .T. ) //SE USUมRIO LOGADO ESTIVER NO SIGAPSW ENTRA  
   aUsu   := PSWRET() 	  //JOGA NA aUsu O VETOR COM INFORMAวีES DO USUมRIO			
   //cUsu   := Substr(aUsu[1][22],1,5)  
   cUsu := aUsu[1][22]
  // cUsu   := Alltrim( aUsu[1][22] )
  Alert(cUsu)
Endif


/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg1      := MSDialog():New( 006,195,493,1110,"Detalhe Pedido",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,002,079,378,"Cabe็alho",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,009,{||"Pedido"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 034,009,{||"Vl. Fret"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 054,008,{||"% Frete"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 054,100,{||"Total"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 032,160,{||"Previsao"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 032,265,{||"Cond Pag"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 012,265,{||"Solicitante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 054,160,{||"C. Custo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 034,100,{||"TP Frete"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 054,265,{||"Conta C."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGrp4      := TGroup():New( 000,380,231,460,"Or็amento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay11     := TSay():New( 012,390,{||"Verba"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 034,390,{||"Em PC Aberto"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 056,390,{||"Total Gasto"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay14     := TSay():New( 078,390,{||"Saldo"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 100,390,{||"Pedido"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 122,390,{||"Previsใo"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGet1      := TGet():New( 012,036,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCodPed",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCodPed:=u,cCodPed)}

oGet2      := TGet():New( 012,104,,oGrp1,137,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFornece",,)
oGet2:bSetGet := {|u| If(PCount()>0,cFornece:=u,cFornece)}

oGet3      := TGet():New( 032,036,,oGrp1,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVlFret",,)
oGet3:bSetGet := {|u| If(PCount()>0,nVlFret:=u,nVlFret)}

oGet4      := TGet():New( 054,036,,oGrp1,060,008,'@E 99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nPercFrt",,)
oGet4:bSetGet := {|u| If(PCount()>0,nPercFrt:=u,nPercFrt)}

oGet5      := TGet():New( 054,125,,oGrp1,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTotalPC",,)
oGet5:bSetGet := {|u| If(PCount()>0,nTotalPC:=u,nTotalPC)}

oGet6      := TGet():New( 032,190,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dPrevisao",,)
oGet6:bSetGet := {|u| If(PCount()>0,dPrevisao:=u,dPrevisao)}

oGet7      := TGet():New( 032,295,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCondica",,)
oGet7:bSetGet := {|u| If(PCount()>0,cCondica:=u,cCondica)}

oGet8      := TGet():New( 012,295,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cUsuario",,)
oGet8:bSetGet := {|u| If(PCount()>0,cUsuario:=u,cUsuario)}

oGet9      := TGet():New( 054,190,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cC",,)
oGet9:bSetGet := {|u| If(PCount()>0,cC:=u,cC)}

oGet17     := TGet():New( 054,295,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cContaC",,)
oGet17:bSetGet := {|u| If(PCount()>0,cContaC:=u,cContaC)}

oGe10      := TGet():New( 032,125,,oGrp1,010,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cTPFrete",,)
oGe10:bSetGet := {|u| If(PCount()>0,cTPFrete:=u,cTPFrete)}

oGet11      := TGet():New( 020,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVerba",,)
oGet11:bSetGet := {|u| If(PCount()>0,nVerba:=u,nVerba)}

oGet12      := TGet():New( 042,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nEmPCAbe",,)
oGet12:bSetGet := {|u| If(PCount()>0,nEmPCAbe:=u,nEmPCAbe)}

oGet13      := TGet():New( 064,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nGasto",,)
oGet13:bSetGet := {|u| If(PCount()>0,nGasto:=u,nGasto)}

oGet14      := TGet():New( 086,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nSaldoV",,)
oGet14:bSetGet := {|u| If(PCount()>0,nSaldoV:=u,nSaldoV)}

oGet15      := TGet():New( 108,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTotalPC",,)
oGet15:bSetGet := {|u| If(PCount()>0,nTotalPC:=u,nTotalPC)}

oGet16      := TGet():New( 130,390,,oGrp4,060,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nResult",,)
oGet16:bSetGet := {|u| If(PCount()>0,nResult:=u,nResult)}

oGrp2      := TGroup():New( 080,002,159,378,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

AADD(aCampos,{"C7_ITEM" 		,"","Item"  			,""  	})					
AADD(aCampos,{"C7_PRODUTO" 		,"","Produto"			,""  	})					
AADD(aCampos,{"C7_DESCRI"		,"","Descri็ใo" 		,""		})					
AADD(aCampos,{"C7_PRECO"		,"","Val. PC" 		,""		})					
AADD(aCampos,{"C7_QUANT"	    ,"","Quant. PC"	,""		})					
AADD(aCampos,{"D1_DTDIGIT"		,"","Data Ult Compra",""})
AADD(aCampos,{"D1_QUANT"		,"","Quant Ult Compra",""})
AADD(aCampos,{"D1_VUNIT"		,"","Ult Pre็o Comp Unit",""})
AADD(aCampos,{"D1_TOTAL"		,"","Ult Pre็o Comp Total",""})
AADD(aCampos,{"C7_DETPEDI"      ,"","Informa็๕es Comprador - Diretoria",""})
AADD(aCampos,{"C7_OBS"		    ,"","Observa็ใo do P.C",""})					

oTbl1()
Dbselectarea("TMP1")

XIT->(dbgotop())

While XIT->(!EOF())

	nTotalPC	+= XIT->C7_TOTAL
	nVlFret	:= XIT->C7_VALFRET
	nPercFrt := XIT->C7_VALFRET / nTotalPC * 100
//	nPercFrt += XIT->C7_VALFRET * XIT->C7_PRECO/100 
	
	reclock("TMP1", .T.)
		TMP1->C7_ITEM    := XIT->C7_ITEM
		TMP1->C7_PRODUTO := XIT->C7_PRODUTO
		TMP1->C7_DESCRI  := XIT->C7_DESCRI
		TMP1->C7_PRECO   := Transform(XIT->C7_PRECO, "@E 999,999.999999999")
		//TMP1->C7_PRECO := XIT->C7_PRECO
		TMP1->C7_QUANT   := XIT->C7_QUANT
		TMP1->D1_DTDIGIT := XIT->DTULTPRE   
		TMP1->D1_QUANT   := XIT->QTULTPRE   
		TMP1->D1_VUNIT   := Transform(XIT->ULTPREU, "@E 999,999.999999999")    
		TMP1->D1_TOTAL   := Transform(XIT->ULTPRET, "@E 999,999,999.99")
		TMP1->C7_DETPEDI := XIT->C7_DETPEDI
		TMP1->C7_OBS     := XIT->C7_OBS    
	msunlock()
		XIT->(dbSkip())
EndDo

/*nVlFret	:= XIT->C7_VALFRET
nPercFrt := XIT->C7_VALFRET * nTotalPC/100*/

TMP1->(dbgotop())

oBrw1      := MsSelect():New( "TMP1",,,aCampos,.F.,,{090,004,154,375},,, oGrp2 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
oBrw1:oBrowse:bChange := {||fCotacao(TMP1->C7_PRODUTO,cCodPed) }

oGrp3      := TGroup():New( 160,002,231,378,"Cota็๕es",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBtn1     := SButton():New( 232,345,1,{|| oDlg1:end()},oDlg1,,"", )

oTbl2()
DbSelectArea("TMP2")

oBrw2      := MsSelect():New( "TMP2","MARCA","",{{"C8_ITEM ","","Item",""},;
												 {"C8_NUM ","","Num Cotacao",""},;
												 {"C8_FORNECE ","","Cod Forne",""},;
												 {"C8_EMISSAO","","Dt Emissao",""},;
												 {"C8_PRECO","","Pre็o Unit",""},;
												 {"C8_TOTAL","","Pre็o Total",""},;
												 {"C8_QUANT","","Quant",""}},.F.,,{166,004,224,375},,, oDlg1 ) 

oSBtn1     := SButton():New( 232,345,1,{|| oDlg1:end()},oDlg1,,"", )

cContaAdm	:= Posicione("SB1",1,xFilial("SB1")+cCodProd, "B1_XCCADM")
cContaPro	:= Posicione("SB1",1,xFilial("SB1")+cCodProd, "B1_XCCPROD")

If SubStr(cCC,1,1) == "7"
	nVerba 		:= fVerba(cCC, cContaPro)
	nGasto			:= fGastoCta(cCC, cContaPro)
	nEmPCAbe 		:= fTotPCA(cCC, cContaPro)
	cContaC		:= Posicione("CT1",1,xFilial("CT1")+cContaPro,"CT1_DESC01")
Else
	nVerba 		:= fVerba(cCC, cContaAdm)
	nGasto			:= fGastoCta(cCC, cContaAdm)
	nEmPCAbe 		:= fTotPCA(cCC, cContaAdm)
	cContaC		:= Posicione("CT1",1,xFilial("CT1")+cContaAdm,"CT1_DESC01")
EndIf

nSaldoV 	:= nVerba - nGasto - nEmPCAbe
nResult 	:= nSaldoV - nTotalPC

oDlg1:Activate(,,,.T.)
TMP1->(DBCloseArea())
TMP2->(DBCloseArea())
//Ferase(coTbl2)

Return

Static Function fCotacao(cProd, cCodPed)

Local cQryx

cQryx	:= " SELECT * FROM " + RETSQLNAME("SC8")
cQryx	+= " WHERE C8_PRODUTO = '" + cProd + "' "  
cQryx	+= " AND C8_NUMSC IN (SELECT C1_NUM FROM " + RETSQLNAME("SC1")+" SC1 "
cQryx	+= "                  WHERE C1_PEDIDO = '" + cCodPed + "'  "
cQryx	+= "                  AND C1_PRODUTO = '" + cProd + "'  "
cQryx	+= "                  AND SC1.D_E_L_E_T_ = '')"
cQryx   += " AND D_E_L_E_T_ = '' ORDER BY C8_EMISSAO DESC"
MemoWrite("C:\TEMP\TMP2.SQL", cQryx)

If Select("TMPX") > 0
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQryx NEW ALIAS "TMPX"
TcSetField("TMPX", "C8_EMISSAO", "D")
TMP2->( __DbZap() )

WHILE !TMPX->(EOF())
	RECLOCK("TMP2",.T.)
		TMP2->C8_ITEM    := TMPX->C8_ITEM
		TMP2->C8_NUM     := TMPX->C8_NUM
		TMP2->C8_FORNECE := TMPX->C8_FORNECE
		TMP2->C8_EMISSAO := TMPX->C8_EMISSAO
		TMP2->C8_QUANT   := TMPX->C8_QUANT
		TMP2->C8_PRECO   := Transform(TMPX->C8_PRECO, "@E 9,999,999.9999")
		TMP2->C8_TOTAL   := TMPX->C8_TOTAL
	    //TMP2->C8_NUMSC   := TMPX->C8_NUMSC
	MsUnLock()
	TMPX->(DbSKIP())
EndDO

TMPX->(DbcloseArea())
TMP2->(dbgotop())
oBrw2:oBrowse:Refresh()

Return

/*Static Function fUltPrec(cProd)

LOCAL cQryz		:=''

cQryz	:= "SELECT TOP 1 D1_DTDIGIT, D1_QUANT, D1_VUNIT, D1_TOTAL FROM " + RETSQLNAME("SD1") + " D1 "
cQryz	+= " INNER JOIN " + RETSQLNAME("SF4") + " F4 "
cQryz	+= " ON D1_TES = F4_CODIGO "
cQryz	+= " WHERE D1_COD = '" + cProd + "' "
cQryz	+= " AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQryz	+= " AND D1.D_E_L_E_T_ <> '*' "
cQryz	+= " AND F4.D_E_L_E_T_ <> '*' "
cQryz	+= " AND F4_DUPLIC = 'S' "
cQryz	+= " ORDER BY D1_DTDIGIT DESC "

If Select("TMPZ") > 0
	TMPZ->(DbCloseArea())
EndIf

TCQUERY cQryz NEW ALIAS "TMPZ"
TcSetField("TMPZ", "D1_DTDIGIT", "D")
TMPZ->( __DbZap() )

WHILE !TMPZ->(EOF())
	RECLOCK("TMP1",.T.)
		TMP1->D1_DTDIGIT := TMPZ->D1_DTDIGIT
		TMP1->D1_QUANT   := TMPZ->D1_QUANT
		TMP1->D1_VUNIT	 := TMPZ->D1_VUNIT
		TMP1->D1_TOTAL	 := TMPZ->D1_TOTAL
	MsUnLock()
	TMPZ->(DbSKIP())
EndDO

TMPZ->(DbcloseArea())
TMP1->(dbgotop())
oBrw2:oBrowse:Refresh()

Return*/

**************************
Static Function oTbl2()
**************************

Local aFds := {}
Local cQryx := ""

Aadd( aFds , {"C8_ITEM " ,"C",006,000} )
Aadd( aFds , {"C8_NUM "  ,"C",006,000} )
Aadd( aFds , {"C8_FORNECE" ,"C",006,000} )
Aadd( aFds , {"C8_EMISSAO" ,"D",008,000} )
Aadd( aFds , {"C8_PRECO" ,"C",014,004} )
Aadd( aFds , {"C8_TOTAL" ,"N",014,004} )
Aadd( aFds , {"C8_QUANT" ,"N",014,004} )
//Aadd( aFds , {"C8_NUMSC" ,"C",006,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive

Return 

**************************
Static Function oTbl1()
**************************

Local aCampos := {}


AADD(aCampos,{"C7_ITEM" 		,"C",006,000})		
AADD(aCampos,{"C7_PRODUTO" 		,"C",010,000})					
AADD(aCampos,{"C7_DESCRI"		,"C",030,000})					
AADD(aCampos,{"C7_PRECO"		,"C",014,004})					
AADD(aCampos,{"C7_QUANT"	    ,"N",014,004})					
AADD(aCampos,{"D1_DTDIGIT"		,"D",008,000})
AADD(aCampos,{"D1_QUANT"		,"N",011,004})
AADD(aCampos,{"D1_VUNIT"		,"C",014,004})
AADD(aCampos,{"D1_TOTAL"		,"C",014,004})
AADD(aCampos,{"C7_DETPEDI"      ,"C",060,000})
AADD(aCampos,{"C7_OBS"          ,"C",060,000})

coTbl1 := CriaTrab( aCampos, .T. )
Use (coTbl1) Alias TMP1 New Exclusive

Return

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
