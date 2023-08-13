#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//--------------------------------------------------------------------------
//Programa: ESTR005
//Objetivo: Mostrar os produtos que não possuem estoque mínimo, mas que tem
//          saldo em estoque.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 10/03/10
//Alterado em: 12/04/2010 - ref. Chamado 001553: 
// Conforme conversamos, favor colocar no relatório " PRODUTOS S/ ESTOQ. MINIMO x SALDO"
// os seguintes campos " Data de entrada e solicitante". conforme relatório entregue em mãos.
//--------------------------------------------------------------------------
***********************
User Function ESTR005()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

tamanho   := "M"
titulo    := PADC("PRODUTOS S/ ESTOQ. MINIMO x SALDO" , 74 )
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de produtos que não tem estoque mínimo "
cDesc3    := "mas possuem saldo no estoque."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "ESTR005"
cPerg     := "ESTR05"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTR005"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .F. )               // Pergunta no SX1
//titulo := AllTrim( titulo ) + "  " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )

cString := "SB2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RptDetail()})  // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
Return


//------------------------------
Static Function RptDetail()     
//------------------------------

Local  cAtivo	:= ""
Local aResult	:= {}
Local nConta	:= 1
Local cPar		:= ""
Local nPos		:= 0
Local cNF		:= "" 
Local cPedCompra:= ""
Local cNumSC	:= ""
Local cItemSC	:= ""
Local cSolicitante := ""
Local LF := CHR(13)+CHR(10) 
Local cQuery := ""
Local cQuery2 := ""


//Parâmetros:
//--------------------------------
// mv_par01 - Produto de
// mv_par02 - Produto até
// mv_par03 - Tipo de
// mv_par04 - Tipo até
// mv_par05 - Local de
// mv_par06 - Local até
// mv_par07 - Estoque > 0 (Sim / Não)
// mv_par08 - Produto Ativo (Sim / Não)
// mv_par09 - Exceto Tipos
//---------------------------------


Cabec1 := "PRODUTO          DESCRICAO                                 TIPO   ATIVO  LOCAL  SLD. ESTQ.  DT.ENTRADA  SOLICITANTE      VLR.ESTOQUE"
Cabec2 := "" 
Cabec3 := ""
//         999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX     XXX    99    999,999.99  99/99/9999  XXXXXXXXXXXXXXX   999,999,99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13
//			COD. = 15C		DESC.= 40C		

////monta a variável do parâmetro mv_par09 para incluir na query
////CADA TIPO DE PRODUTO DEVERÁ ESTAR NO PARÂMETRO SEPARADO POR VÍRGULA
While nConta <= Len( Alltrim(mv_par09) )

	 If AT( "," , Substr( mv_par09, nConta, 5 ) ) > 0
	 	nPos := Len( Substr( mv_par09, nConta, AT(",",mv_par09) ))
	 	
	 	If Empty( cPar )
	 		cPar := "'" + Substr( mv_par09 , nConta, nPos - 1) + "'"
	 	Else
	 		cPar += "," + "'" + Substr( mv_par09 , nConta, nPos - 1) + "'"
	 	Endif
     	
	 Else
	 	nPos :=Len( Substr( mv_par09, nConta, AT(",",mv_par09) ))
	 	cPar += "," + "'" + Substr( mv_par09 , nConta, nPos ) + "'"
	 Endif
	 nConta += nPos      
Enddo

cQuery := " SELECT B1_UM,B1_COD AS CODIGO, B1_DESC AS DESCRICAO, B1_ATIVO, B1_TIPO, B1_EMIN, B2_COD, B2_LOCAL, B2_QATU "+LF
cQuery += ",(SELECT MAX(D1_DTDIGIT) FROM "+RetSqlName("SD1")+" SD1 WHERE D1_COD = SB1.B1_COD AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '') AS ULTCOMPRA"+LF
cQuery += ",(SELECT TOP 1 D1_DOC+D1_SERIE FROM "+RetSqlName("SD1")+" SD1 WHERE D1_COD = SB1.B1_COD AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' ORDER BY D1_DTDIGIT DESC) AS ULTNF"+LF
cQuery += ",(SELECT TOP 1 D1_PEDIDO+D1_ITEMPC FROM "+RetSqlName("SD1")+" SD1 WHERE D1_COD = SB1.B1_COD AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' ORDER BY D1_DTDIGIT DESC) AS ULTPC"+LF
//Incluido por Eurivan - 09/03/11 - Chamado: 002057 - Alexandre
cQuery += ",(SELECT TOP 1 D1_VUNIT FROM "+RetSqlName("SD1")+" SD1 WHERE D1_COD = SB1.B1_COD AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' ORDER BY D1_DTDIGIT DESC) AS ULTPRC"+LF
cQuery += " FROM " + RetSqlName("SB1") + " SB1, "+LF
cQuery += " " + RetSqlName("SB2") + " SB2 "+LF
cQuery += " WHERE B1_COD = B2_COD "+LF
cQuery += " AND B1_EMIN <= 0 " +LF
cQuery += " AND B1_COD >= '" + mv_par01 + "' AND B1_COD <= '" + mv_par02 + "' " +LF
cQuery += " AND ( B1_TIPO NOT IN ( " + cPar + " )  AND B1_TIPO >= '" + mv_par03 + "' AND B1_TIPO <= '" + mv_par04 + "') " +LF
cQuery += " AND B2_LOCAL >= '" + mv_par05 + "' AND B2_LOCAL <= '" + mv_par06 + "' " +LF
If mv_par07 == 1		//Sim
	cQuery += " AND B2_QATU > 0 " +LF
Endif
If mv_par08 == 1
	cQuery += " AND B1_ATIVO = 'S'" +LF
Endif
cQuery += " AND SB1.D_E_L_E_T_ = '' "+LF
cQuery += " AND SB2.D_E_L_E_T_ = ''  "+LF
cQuery += " AND B1_FILIAL  = '" + xFilial("SB1") + "' "+LF
cQuery += " AND B2_FILIAL  = '" + xFilial("SB2") + "' "+LF
cQuery += " ORDER BY B1_FILIAL,B1_COD,B2_LOCAL "+LF

cQuery := ChangeQuery( cQuery )
//MemoWrite("C:\ESTR005.sql", cQuery)

If Select("ESTR05") > 0
	DbSelectArea("ESTR05")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "ESTR05"
TCSetField( 'ESTR05', "ULTCOMPRA", "D" )


ESTR05->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

aResult 	:= {}

Do While !ESTR05->( Eof() )  
    //verifico se considera itens que tenham chegado a mais de 30 dias
    //Solicitado por Alexandre em 11/10/10 - Nao tinha chamado
    //Alterado por Eurivan
    if MV_PAR10 == 1
       if ( dDataBase - ESTR05->ULTCOMPRA ) < 30
          ESTR05->( DbSkip() )       
          Loop   
       endif    
    endif
    
    cAtivo		:= iif(ESTR05->B1_ATIVO = 'S', "Sim", "Nao") 
    cNF			:= ESTR05->ULTNF
    cPedCompra 	:= ESTR05->ULTPC		//o número está concatenado com o item do PC
    cNumSC	:= ""
    cItemSC := "" 
    cSolicitante:= ""
    cSolicit := ""
    
    cQuery2 := ""
	cQuery2 += " SELECT C7_NUMSC,C7_ITEMSC,C7_NUM,C1_NUM, C1_SOLICIT "+LF
	cQuery2 += " FROM " + RetSqlName("SC7") + " SC7, " + RetSqlName("SC1") + " SC1 "+LF
	cQuery2 += " WHERE RTRIM(C7_NUM+C7_ITEM) = '" + Alltrim(cPedCompra) + "'  "+LF
	cQuery2 += " AND RTRIM(C7_NUMSC) = RTRIM(C1_NUM)  "+LF
	cQuery2 += " AND SC7.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' "+LF
	cQuery2 += " AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' "+LF
	cQuery2 += " AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' "+LF
//	MemoWrite("C:\ESTR05-solic.sql", cQuery2)
    If Select("SOL") > 0
		DbSelectArea("SOL")
		DbCloseArea()
	EndIf	
	TcQuery cQuery2 NEW ALIAS "SOL"
	SOL->( DBGoTop() )	
	While SOL->(!EOF())
		cNumSC := SOL->C1_NUM
		cItemSC:= SOL->C7_ITEMSC
		cSolicit := Substr(SOL->C1_SOLICIT,1,15)
		SOL->(Dbskip())
	Enddo	
    
      
  //						1			2					3			4			5				6					7					8				9			   10      11
	Aadd (aResult, {ESTR05->CODIGO, ESTR05->DESCRICAO, ESTR05->B1_TIPO, cAtivo, ESTR05->B1_EMIN, ESTR05->B2_LOCAL, ESTR05->B2_QATU, ESTR05->ULTCOMPRA, cSolicit, ESTR05->ULTPRC,ESTR05->B1_UM  } )  
	Dbselectarea("ESTR05")
	ESTR05->( DbSkip() )

Enddo


If Len(aResult) <= 0
	Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("ESTR05")
	DbcloseArea()
	Return
EndIF



nVlrTot := 0

If Len(aResult) > 0    

	FOR X := 1 TO Len(aResult)
			
		If lEnd
			@ li,000 PSAY "CANCELADO PELO OPERADOR"
			Exit
		EndIf
			
		If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		Endif
      	 	
		@ li    ,000 PSAY aResult[X,1]  //COD. PRODUTO
	 	@ li    ,017 PSAY Substr(aResult[X,2],1,40)	//DESCRIÇÃO
	 	@ li    ,060 PSAY aResult[X,3]			//TIPO
	 	@ li    ,067 PSAY aResult[X,4]											//ATIVO (SIM/NÃO)
	 	//@ li    ,072 PSAY aResult[X,5]					Picture "@E 999,999.99"	//ESTQ MIN
	 	@ li    ,074 PSAY aResult[X,6]	//LOCAL   
	 	@ li    ,080 PSAY aResult[X,7]					Picture "@E 999,999.99"	//SALDO ESTOQUE
        @ li	,092 PSAY DtoC(aResult[X,8])					//Dt. entrada
        @ li	,104 PSAY Substr(aResult[X,9],1,15)		//Solicitante
        //Incluido por Eurivan - 09/03/11 - Chamado: 002057
        @ li	,121 PSAY (aResult[X,7] * aResult[X,10])	Picture "@E 999,999.99" //Valor do Estoque
        @ li	,132 PSAY aResult[X,11]
        nVlrTot += (aResult[X,7] * aResult[X,10])
        
        li++
	NEXT

EndIF

@ li ,114 PSAY "Total: "+Transform(	nVlrTot, "@E 999,999.99") //Valor Total do Estoque

ESTR05->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif

Return NIL