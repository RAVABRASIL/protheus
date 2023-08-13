#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :10/Mar/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function DTPROD()

MsAguarde( {|| Tela() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Aguarde..." ) )

Return

Static Function Tela()

Local aArray := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw2","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 100,187,370,936,"Prioridades de liberação de estoque",,,.F.,,,,,,.T.,,,.F. )
oTbl1()
DbSelectArea("TMP")
oBrw2      := MsSelect():New( "TMP","","",{{"SVIP","","SVIP",""},;
{"PRODUTO","","Produto",""},;
{"DESC","","Descritivo",""},;
{"VIRTUAL","","Est. Virtual","@E 999,999,999.99"},;
{"KG","","KGs","@E 999,999,999.99"},;
{"QUANT","","Quant. Pedido","@E 999,999,999"},;
{"DTPROD","","Dt. Producao",""}},.F.,,{005,004,100,367},,, oDlg1 ) 
oBtn1      := TButton():New( 112,272,"Dt. Producao",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||ACAOBT1()}

oBtn2      := TButton():New( 112,330,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||ACAOBT2()}

TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 

aArray := Cabec2()   

For nX:=1 to Len( aArray ) 
    
    RecLock("TMP",.T.)
    
    TMP->SVIP:=aArray[nX][1] 
    TMP->PRODUTO:=aArray[nX][2]
    TMP->DESC:=aArray[nX][3]
    TMP->VIRTUAL:=aArray[nX][4]
    TMP->KG:= (aArray[nX][4] * Posicione("SB1",1, xFilial("SB1") + aArray[nX][2], "B1_PESO" ) * -1)
    TMP->QUANT:=QUANTPED(aArray[nX][2]) 
  //  TMP->DTPROD:=PESQDATA(aArray[nX][2])
    
    TMP->(MsUnLock())                             

Next

TMP->( DbGotop() )

   oBrw2:oBrowse:Refresh()
   
   oDlg1:Activate(,,,.T.)
   
   TMP->(DBCloseArea())  
   Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO

   
Return
   
/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"SVIP"    ,"C",004,000} )
Aadd( aFds , {"PRODUTO" ,"C",015,000} )
Aadd( aFds , {"DESC"    ,"C",050,000} )
Aadd( aFds , {"VIRTUAL" ,"N",015,000} )
Aadd( aFds , {"KG"      ,"N",015,000} )
Aadd( aFds , {"QUANT"   ,"N",015,000} )
Aadd( aFds , {"DTPROD"  ,"D",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

***************
Static Function Cabec2()
***************

Local cQuery
Local nSeq 	  := 1
Local cULT 	  := maxPrio()
Local cVIP    := '0050'
Local aABC    := {}
Local cCliVip := ""
Local aRet    := {}
Local aItens  := {}
Local nPos    := 0
cQuery := "select SC5.C5_PRIORES AS SVIP, PRIOX = CAST('' AS CHAR(3) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '*' ELSE '  ' END ) AS MARCA, "
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME, "
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_PRIORES, SC5.C5_ENTREG "

TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )
TCSetField( 'CAB', "C5_ENTREG",  "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )

CAB->(DbGotop())

DbSelectArea("SC5")
DbSetOrder(1)

//U_ABC50(@aABC,@cCliVip)

  ABC(aABC, cCliVip)

while !CAB->(EOF())
  
	_nX := Ascan(aABC, {|x| x[2] == CAB->C5_CLIENTE})
	if _nX > 0
		CAB->SVIP := StrZero(aABC[_nX,1],4)
	else
		if empty( CAB->SVIP ) .or. upper( CAB->SVIP ) == "ZZZZ"
			if val(cULT) <= 50
				CAB->SVIP := cVIP := soma1(cVIP)
			else
				CAB->SVIP := cULT := soma1(cULT)
			endIf
		/*else//Caso um dia seja necessario reordenar
			cVIP := soma1(cVIP)			
			if CAB->SVIP != cVIP
				CAB->SVIP := cVIP// := soma1(cVIP)			
			endIF*/
		endIf				
		//CAB->SVIP := cVIP := soma1(cVIP)
   endif
   
	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
	RecLock("SC5",.F.)
	if !Empty(SC5->C5_PRIORES)
		if SC5->C5_PRIORES # CAB->SVIP
			SC5->C5_PRIORES := CAB->SVIP
		endif
	else
		SC5->C5_PRIORES := CAB->SVIP
	endif
  	MsUnlock()		
	nSeq++
	CAB->( DbSkip() )
end

CAB->( DbGotop() )
do While CAB->( !EoF() )
	if len(aRet) <= 0
    	aRet := itens()
    else
    	aItens := itens()//aAdd(aRet, { 0, TMP->PRODUTO, TMP->DESCRICAO, nTot } )
    	for i := 1 to len(aItens)
    		nPos := aScan( aRet, {|x| x[2] == aItens[i][2] } )
    		if nPos > 0
    			if aItens[i][4] < aRet[nPos][4]
    				aRet[nPos][4] := aItens[i][4]
    			endIf
    			if aItens[i][1] < aRet[nPos][1]
    				aRet[nPos][1] := aItens[i][1]
    			endIf
    		else
    			aAdd(aRet, aItens[i])
    		endIf
    	next
    endIf
	/*aAdd(aRet, { CAB->SVIP, CAB->C5_NUM, CAB->C5_CLIENTE, CAB->C5_LOJACLI, CAB->C5_VEND1, CAB->A3_NREDUZ, CAB->C5_PRIOR, CAB->C5_EMISSAO,;
				 CAB->C5_ENTREG, itens(), CAB->NOME } )*/
	CAB->( dbSkip() )
endDo
CAB->( DbCloseArea() )

Return aRet

***************

Static Function Itens()

***************
Local aRet := {}
Local nTot := 0
cQuery := "select SC6.C6_LOCAL AS LOCAL,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SC6.C6_LOCAL AS LOCAL,SB1.B1_DESC AS DESCRICAO,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, "
cQuery += "SC6.C6_QTDRESE AS RESERVA, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, "
cQuery += "0 AS ESTOQUE,0 AS ALIBERAR "
cQuery += "from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 "
cQuery += "where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD "
//cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC6.C6_FILIAL = '" + xfilial("SC6") + "' and SC6.D_E_L_E_T_ = ' ' "
cQuery += "and SB1.B1_FILIAL = '" + xfilial("SB1") + "' and SB1.D_E_L_E_T_ = ' ' "
cQuery += "order by SC6.C6_ITEM "
TCQUERY cQuery NEW ALIAS "TMPZ"

TCSetField( 'TMPZ', "QTDPED",   "N", 10, 3 )
TCSetField( 'TMPZ', "QTDFAT",   "N", 10, 3 )
TCSetField( 'TMPZ', "QTDLIB",   "N", 10, 3 )
TCSetField( 'TMPZ', "ESTOQUE",  "N", 10, 3 )
TCSetField( 'TMPZ', "ALIBERAR", "N", 10, 3 )
TCSetField( 'TMPZ', "QTDREJ",   "N", 10, 3 )
TCSetField( 'TMPZ', "RESERVA",  "N", 10, 3 )

While ! TMPZ->( Eof() )
	nTot := U_SALDOEST( TMPZ->PRODUTO, TMPZ->LOCAL ) - SALDORES( TMPZ->PRODUTO )
	if nTot < 0
		aAdd(aRet, { CAB->SVIP, alltrim(U_Transgen(TMPZ->PRODUTO)), TMPZ->DESCRICAO, nTot } )
	endIf
	nTot := 0
	TMPZ->( DbSkip() )
End
TMPZ->( DbCloseArea() )

Return aRet

***************

Static function SALDORES( cProd1 )

***************

local nQuant := 0
local cQuery
local cProd2

cALIASANT := Alias()

if ! Empty( cPROD1 )
	if Len( AllTrim( cPROD1 ) ) <= 7
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "select sum( C6_QTDRESE ) AS RESERVA "
	cQuery += "from " + retsqlname("SC6") + " SC6, "+ retsqlname("SC5") + " SC5 "
	cQuery += "where C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) and "
	cQuery += "C6_NUM = C5_NUM AND C5_PRIORES <= '"+CAB->SVIP+"' AND "
	cQuery += "C6_QTDENT < C6_QTDVEN AND C6_QTDRESE > 0 AND C6_FILIAL = '" + xfilial("SC6") + "' and "
	cQuery += "C6_BLQ <> 'R' AND "
	cQuery += "SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' "	
	TCQUERY cQuery NEW ALIAS "C6X"
	DbSelectArea("C6X")
	nQuant := C6X->RESERVA
	C6X->(DbCloseArea())
endif

DbSelectArea(cALIASANT)

return nQuant

***************

Static Function maxPrio()

***************

local cMax := cQuery := ''

cQuery += "select max(SC5.C5_PRIORES) maximo "
cQuery += "from "+retSqlName('SC5')+" SC5, "+retSqlName('SA3')+" SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '01' and SA3.A3_FILIAL = '  ' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS 'TMPX'

TMPX->( dbGoTop() )
cMax := TMPX->maximo

TMPX->( dbCloseArea() )

return cMax

***************

Static Function QUANTPED(cProd1)

***************

Local cQuery := ''
Local nQuant :=0
local cProd2

if ! Empty( cPROD1 )
	
   if Len( AllTrim( cPROD1 ) ) <= 7
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
   else
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
   endif
	
   cQuery := "SELECT  COUNT(DISTINCT C6_NUM)'QUANT' "
   cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9,"+retSqlName('SA1')+" SA1 "
   cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' "
   cQuery += "AND SB1.B1_TIPO = 'PA' AND "
   cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
   cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " 
   cQuery += "and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//   cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
   cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "  
   cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
   cQuery += "SC6.C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) AND "
   cQuery += "SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = ' ' AND "
   cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' "

   TCQUERY cQuery NEW ALIAS 'AUUX'

   if AUUX->(!EOF())
      nQuant:=AUUX->QUANT
   EndIF
   
   AUUX->( dbCloseArea() )

EndIF

Return nQuant

/*
***************

Static Function PESQDATA(cProd1)

***************

Local cQuery := ''
local cProd2
Local cnt:=todas:=0
Local dData:=cRet:= StoD(space(8))

if ! Empty( cPROD1 )
	
   if Len( AllTrim( cPROD1 ) ) <= 7
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
   else
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
   endif
	
   cQuery := "SELECT C6_NUM,C6_DTPRODU  "
   cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9,"+retSqlName('SA1')+" SA1 "
   cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' "
   cQuery += "AND SB1.B1_TIPO = 'PA' AND "
   cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
   cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " 
   cQuery += "and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
   cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
   cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
   cQuery += "SC6.C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) AND "
   cQuery += "SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = ' ' AND "
   cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' "

   TCQUERY cQuery NEW ALIAS 'AUUX'
   TCSetField("AUUX","C6_DTPRODU","D")
   
   Do While AUUX->(!EOF()) 
     If !empty(AUUX->C6_DTPRODU)
       cnt+=1
       dData:=AUUX->C6_DTPRODU
     EndIF
     todas+=1  
     AUUX->(dbSkip())
   EndDo
   
   If (todas - cnt )==0
     cRet:=dData
   Else
     cRet:=StoD(space(8))
   EndIF
   
   AUUX->( dbCloseArea() )
   
EndIF  

Return cRet */


***************

Static Function ACAOBT1()

***************

Local dData:=stod(space(8))

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oGet1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 244,330,319,494,"Dt. Producao",,,.F.,,,,,,.T.,,,.F. )
oGet1      := TGet():New( 006,009,,oDlg2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData",,)
oGet1:bSetGet := {|u| If(PCount()>0,dData:=u,dData)}
oBtn1      := TButton():New( 019,020,"Ok",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||getdata(dData)}


oDlg2:Activate(,,,.T.)


Return  

***************

Static Function getdata(dtprod)

**************
local nRecno := TMP->(Recno())

RecLock("TMP",.F.)

TMP->DTPROD:=dtprod   

TMP->(MsUnLock())                             

TMP->(DbGoto(nRecno))

oDlg2:END()

Return 

***************

Static Function ACAOBT2()

***************

TMP->(DbGotop())

while ! TMP->(EOF())
   
   if !Empty(TMP->DTPROD)
      
       PEDIDO(TMP->PRODUTO)
   
   EndIF

   TMP->(dbSkip())

EndDo

Return                    

***************

Static Function PEDIDO(cProd1)

***************

Local cQuery := ''
local cProd2
if ! Empty( cPROD1 )
	
   if Len( AllTrim( cPROD1 ) ) <= 7
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
   else
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
   endif
	
   cQuery := "SELECT C6_NUM,C6_PRODUTO  "
   cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9,"+retSqlName('SA1')+" SA1 "
   cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' "
   cQuery += "AND SB1.B1_TIPO = 'PA' AND "
   cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
   cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " 
   cQuery += "and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//   cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
   cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "  
   cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
   cQuery += "SC6.C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) AND "
   cQuery += "SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = ' ' AND "
   cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' "

   TCQUERY cQuery NEW ALIAS 'AUUX'
   
   Do While AUUX->(!EOF()) 
     
     dbSelectArea("SC6")
     dbSetOrder(2)  
     If dbSeek(xFilial("SC6")+AUUX->C6_PRODUTO+AUUX->C6_NUM)       
       RecLock("SC6",.F.)   
       SC6->C6_DTPRODU:=TMP->DTPROD
       SC6->(MsUnlock())
         
       dbSelectArea("SC5")
       dbSetOrder(1) 
       If dbSeek(xFilial("SC5")+AUUX->C6_NUM)       
          If SC5->C5_DMAXPRO<TMP->DTPROD
             RecLock("SC5",.F.)   
             SC5->C5_DMAXPRO:=TMP->DTPROD
             SC5->(MsUnlock())
          EndIf
       EndIf
       
     EndIf
     AUUX->(dbSkip())
   EndDo
      
   AUUX->( dbCloseArea() )

   oDlg1:END()
   
EndIF  

Return 

************************
Static function ABC(aABC, cCliVip)
************************

Local nSeq
aABC    := {}
cCliVip := ""

//Curva ABC dos Clientes nos ultimos 6 meses
cQuery := "SELECT DISTINCT   CLIENTE=D2_CLIENTE,NOME=A1_NOME, "
cQuery += "       QUANT=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 "
cQuery += "                ELSE SUM(D2_QUANT) END, "
cQuery += "       PESO=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) "
cQuery += "                ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "       CUSTO=SUM(D2_TOTAL/D2_QUANT), "
cQuery += "       VALOR=SUM(D2_TOTAL) "
cQuery += "FROM   "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" "
cQuery += "SA3 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK), "+RetSQlName("SBM")+" SBM WITH (NOLOCK) "
cQuery += "WHERE  D2_EMISSAO BETWEEN "+DtoS(dDataBase-180)+" AND "+DtoS(dDataBase)+" AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' AND F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' AND SB1.B1_GRUPO = SBM.BM_GRUPO "
cQuery += "GROUP BY D2_CLIENTE,A1_NOME,A1_COD,D2_SERIE,F2_VEND1 "
cQuery += "ORDER BY PESO DESC "
TCQUERY cQuery NEW ALIAS "ABCX"

nSeq := 1
while !ABCX->(EOF())
   Aadd( aABC, { nSeq, ABCX->CLIENTE } )
   cCliVip += "'"+ABCX->CLIENTE+"'"
   nSeq++
   ABCX->(DbSkip())
   if !ABCX->(EOF())
      cCliVip += ","
   endif
end
ABCX->( DbCloseArea() )
aSort( aABC,,,{|x,y| x[2] < y[2]} ) 

return nil
