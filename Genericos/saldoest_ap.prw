#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "fivewin.ch"
//User Function SALDOEST( cPROD1, cLOCAL ) retirado em 08/04/09
User Function SALDOEST( cPROD1, cLOCAL, cEst )

Local nQUANT := 0
Local cQUERY
Local cALIASANT := Alias()
Local cQry1 := ""
Default cEst := ""
If ! Empty( cPROD1 )
    If Len( AllTrim( cPROD1 ) ) <= 7
       cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) $ "R/D", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) $ "R/D", 6, 5 ), 2 ), 15 )
    Else
       cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) $ "R/D", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) $ "R/D", 8, 7 ), 2 ), 15 )
    EndIf

    cQuery := "select sum( SC9.C9_QTDLIB ) AS QUANT "
    cQuery += "from " + RetSqlName( "SC9" ) + " SC9 "
    cQuery += "where SC9.C9_PRODUTO IN ( '" + cPROD1 + "', '" + cPROD2 + "' ) AND SC9.C9_LOCAL = '" + cLOCAL + "' "
    //cQuery += "and SC9.C9_BLEST = '  ' AND SC9.C9_BLCRED = '  ' "
    // NOVA LIBERACAO DE CRETIDO 
    cQuery += "and SC9.C9_BLEST = '  ' AND SC9.C9_BLCRED IN( '  ','04') "
    cQuery += "and SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "

    TCQUERY cQuery NEW ALIAS "SC9X"
    nQUANT := Posicione( "SB2", 1, xFilial( "SB2" ) + If( Len( AllTrim( cPROD1 ) ) <= 7, cPROD1, cPROD2 ) + cLOCAL,    "SB2->B2_QATU" )
//    msgAlert( "Saldo fora: "+alltrim(str(nQuant)) )
    if alltrim(cEst) = 'SP'
		cQry1 := "select "
		cQry1 += "(select ISNULL(sum(B6_QUANT),0) "
		cQry1 += "from "+retSqlName("SB6")+" "
		cQry1 += "where B6_CLIFOR = '031248' and B6_LOJA = '01' and B6_PRODUTO = '"+If( Len( AllTrim( cPROD1 ) ) <= 7, cPROD1, cPROD2 )+"' AND B6_SERIE = '0' AND B6_PODER3 = 'R') "
		cQry1 += "- "
		cQry1 += "(select ISNULL(sum(B6_QUANT),0) "
		cQry1 += "from "+retSqlName("SB6")+" "
		cQry1 += "where B6_CLIFOR = '031248' and B6_LOJA = '01' and B6_PRODUTO = '"+If( Len( AllTrim( cPROD1 ) ) <= 7, cPROD1, cPROD2 )+"' AND B6_SERIE = '0' AND B6_PODER3 = 'D') as B6_SALDO "
		TCQUERY cQry1 NEW ALIAS "_TMPY"
		_TMPY->( dbGoTop() )
    	//msgAlert("SP")
	    nQuant += _TMPY->B6_SALDO
	    //msgAlert( "Saldo dentro: "+alltrim(str(nQuant)) )
		_TMPY->( dbCloseArea() )	    
	endIf
    If ! SC9X->( Eof() )
       //nQUANT := If( nQUANT - SC9x->QUANT < 0, 0, nQUANT - SC9X->QUANT )
       nQUANT := nQUANT - SC9x->QUANT
    EndIf
    SC9X->( DbCloseArea() )
    DbSelectArea( cALIASANT )
Endif

Return nQUANT