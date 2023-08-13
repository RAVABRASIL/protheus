#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FATR054    ³ Autor ³ Gustavo Costa        ³ Data ³06.03.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio LEVANTAMENTO FATURAMENTO ENTRE AS DUAS EMPRESAS    .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR054()

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "FATR054" Tables "SD2"
  sleep( 5000 )
  conOut( "Programa FATR054 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  //Exec()
  sleep( 5000 )
  Exec07()
Else
  conOut( "Programa FATR054 sendo executado pelo MENU " + Dtoc( Date() ) + ' - ' + Time() )
  //Exec()
  sleep( 5000 )
  Exec07()
EndIf
  conOut( "Finalizando programa FATR054 em " + Dtoc( DATE() ) + ' - ' + Time() )


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de avaliação de clientes XDD.     .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Exec()


Local cQuery 		:= ""
Local nValorNH		:= 0
Local nValorNI		:= 0
Local nQuantNH		:= 0
Local nQuantNI		:= 0
Local nPedNH		:= 0
Local nPedNI		:= 0
Local nValorR		:= 0
Local nValorPA		:= 0
Local nValorPI		:= 0
Loca cMensagem 		:=""

cMensagem+="<!DOCTYPE html><html lang='pt-br'><head>    <meta charset='UTF-8'>    <title>FATURAMENTO CLIENTE INATIVO</title>    <style> "        
cMensagem+="div#interface {            width: 800px;            font-family: Arial;            font-size: 14px;        } " 
cMensagem+="       div#interface h1 {            display: block;            overflow: hidden;            height: 32px; "  
cMensagem+="          width: 600px;            padding-bottom: 50px;            background-position: 0 -43px; "      
cMensagem+="      background-image: url('http://ravabrasil.com.br/assets/img/sprite/standard-sc18fe437b4.png'); "     
cMensagem+="       background-repeat: no-repeat;            background-size: 40%;        } "        
cMensagem+="div#interface h1 p {            text-align: right;            font-size: 20px;        } "        
cMensagem+="div#corpo h3 {            text-align: center;            font-size: 18px;        } "        
cMensagem+="div#corpo h2 {            text-align: center;            font-size: 16px;        } "        
cMensagem+="table#status {            font-size: 20px;        }        table#status td.a1 { "            
cMensagem+="background-color: red;        }        table#status td.a2 {            background-color: orange;        } " 
cMensagem+="       table#status td.a3 {            background-color: gold;        }  "       
cMensagem+="table#status td.a4 {            background-color: greenyellow;            visibility: hidden;        } " 
cMensagem+="       table#status td.a5 {            background-color: limegreen;            visibility: hidden;        } " 
cMensagem+="       table#geral {            border-spacing: 0px;        }        table#geral td { "         
cMensagem+="   border: 1px solid black;            padding: 2px;        }  "       
cMensagem+="table#geral td.tit {            font-weight: bold;            background-color: rgba(180,255,166,0.65);        } "    
cMensagem+="</style></head><body><div id='interface'>    <h1>      <p>&nbsp;</p> "    
cMensagem+="</h1>    <div id='corpo'>        <h3>ACOMPANHAMENTO DO FATURAMENTO RAVA P/ NOVA</h3> "  
      
cMensagem+="<h2>PERÍODO " + DtoC(FirstDate(ddatabase)) + " ATÉ " + DtoC(ddatabase) + "</h2>  "       
cMensagem+="<table id='geral'> "

//***********************************
// Monta a tabela de vendas da NOVA
//***********************************

cQuery := " SELECT 	SUM( CASE WHEN D2_GRUPO = 'C' THEN ((D2_QUANT-D2_QTDEDEV))*D2_PRCVEN ELSE 0 END ) AS VHOSP,  " 
cQuery += "			SUM( CASE WHEN D2_GRUPO <> 'C' THEN ((D2_QUANT-D2_QTDEDEV))*D2_PRCVEN ELSE 0 END ) AS VINSTITUCIONAL,   "
cQuery += " 		SUM( CASE WHEN D2_GRUPO = 'C' THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QHOSP,  " 
cQuery += "			SUM( CASE WHEN D2_GRUPO <> 'C' THEN ((D2_QUANT-D2_QTDEDEV))*D2_PESO ELSE 0 END ) AS QINSTITUCIONAL   "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         WHERE D2_FILIAL = '06' AND "
cQuery += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQuery += " 		SD2.D2_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND " 
cQuery += "         SD2.D_E_L_E_T_ =   '' "
cQuery += " 		AND D2_SERIE <> '' " 

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nValorNH := TMP->VHOSP
	nValorNI := TMP->VINSTITUCIONAL
	nQuantNH := TMP->QHOSP
	nQuantNI := TMP->QINSTITUCIONAL

Else

	nValorNH := 0
	nValorNI := 0
	nQuantNH := 0
	nQuantNI := 0

EndIf

cQuery := " SELECT "
cQuery += "SUM( CASE WHEN B1_GRUPO = 'C' THEN  C6_QTDVEN*C6_PRCVEN ELSE 0 END ) AS VHOSP, "  
cQuery += "SUM( CASE WHEN B1_GRUPO <> 'C' THEN  C6_QTDVEN*C6_PRCVEN ELSE 0 END ) AS VINSTITUCIONAL, "  
cQuery += "SUM( CASE WHEN B1_GRUPO = 'C' THEN  C6_QTDVEN ELSE 0 END ) AS QHOSP, "  
cQuery += "SUM( CASE WHEN B1_GRUPO <> 'C' THEN  C6_QTDVEN*B1_PESO ELSE 0 END ) AS QINSTITUCIONAL "  
cQuery += "FROM SC6020 SC6 WITH (NOLOCK) "
cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) "
cQuery += "ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM  "
cQuery += "INNER JOIN SB1010 SB1 "
cQuery += "ON C6_PRODUTO = B1_COD "
cQuery += "WHERE C6_FILIAL = '06' AND  "
cQuery += "SUBSTRING(SC6.C6_CF,1,2) IN ('51','61','59','69') AND  "
cQuery += "SC5.C5_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND "  
cQuery += "SC6.D_E_L_E_T_ =   '' AND  "
cQuery += "SC5.D_E_L_E_T_ =   '' AND "
cQuery += "SB1.D_E_L_E_T_ =   '' AND "
cQuery += "SC6.C6_NOTA = '' " 

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nPedNH  := TMP->VHOSP
	nPedNI  := TMP->VINSTITUCIONAL
	nPedNHQ := TMP->QHOSP
	nPedNIQ := TMP->QINSTITUCIONAL

Else

	nPedNH  := 0
	nPedNI  := 0
	nPedNHQ := 0
	nPedNIQ := 0

EndIf



//nValor := 0

//***********************************
// Monta a tabela de vendas da RAVA p/ NOVA
//***********************************

cQuery := " SELECT 	SUM( CASE WHEN D2_TP = 'PA' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS VFATPA, "  
cQuery += "			SUM( CASE WHEN D2_TP <> 'PA' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS VFATPI,  "
cQuery += " 		SUM( CASE WHEN D2_TP = 'PA' THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QFATPA, "  
cQuery += "			SUM( CASE WHEN D2_TP <> 'PA' THEN (D2_QUANT-D2_QTDEDEV)*D2_PESO ELSE 0 END ) AS QFATPI  "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         WHERE D2_FILIAL = '01' AND "
cQuery += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQuery += " 		SD2.D2_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND " 
cQuery += "         SD2.D_E_L_E_T_ =   '' "
cQuery += " 		AND D2_SERIE <> '' " 
cQuery += "			AND D2_CLIENTE = '006543' "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nValorPA := TMP->VFATPA
	nValorPI := TMP->VFATPI
	nQuantPA := TMP->QFATPA
	nQuantPI := TMP->QFATPI
	nValorR  := TMP->VFATPA + TMP->VFATPI

Else

	nValorPA := 0
	nValorPI := 0
	nQuantPA := 0
	nQuantPI := 0
	nValorR := 0

EndIf


cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> NOVA - FATURAMENTO INS + DOM</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNIQ, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>TOTAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNI + nPedNIQ, '@E 999,999,999.99') + "</strong></div></td></tr> "   
cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'>FATURAMENTO RAVA</td></tr> "
cMensagem+="<tr> <td class='tit'>PI - FATURADO RAVA P/ NOVA</td>   <td class='co'><div align='right'><strong>" + TRANSFORM(nQuantPI, '@E 999,999,999.99') + "</strong></div></td> </tr> "
cMensagem+="<tr bgcolor='#98fb98'> <td class='tit'>DIFERENÇA DO PI</td> " 
cMensagem+="      <td class='tit'><div align='right'>" + TRANSFORM(nQuantPI - nQuantNI - nPedNIQ , '@E 999,999,999.99') + "</div></td> "
cMensagem+="    </tr>            <tr> <td colspan='2' class='tit'><div align='right'></div></td>   </tr> "

cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'> NOVA - FATURAMENTO HOSPITALAR</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="  <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNHQ, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+=" <tr> <td width='327' class='tit'>TOTAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNH + nPedNHQ, '@E 999,999,999.99') + "</strong></div></td></tr> "   
cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'>FATURAMENTO RAVA</td></tr><tr> <td class='tit'>PA - FATURADO RAVA P/ NOVA</td> "   
cMensagem+="      <td class='co'><div align='right'><strong>" + TRANSFORM(nQuantPA, '@E 999,999,999.99') + "</strong></div></td> </tr> "            
cMensagem+=" <tr bgcolor='#98fb98'> <td class='tit'>DIFERENÇA DO PA</td> " 
cMensagem+="        <td class='tit'><div align='right'><strong>" + TRANSFORM(nQuantPA - nQuantNH - nPedNHQ, '@E 999,999,999.99') + "</strong></div></td> "
cMensagem+="      </tr> " 

cMensagem+="     <tr> <td colspan='2' class='tit'></td>   </tr>"
cMensagem+="     <tr> <td colspan='2' class='tit'></td>   </tr>"

cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> NOVA - FATURAMENTO INS + DOM R$</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO EM R$</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>TOTAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNI + nPedNI, '@E 999,999,999.99') + "</strong></div></td></tr> "   

cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'> NOVA - FATURAMENTO HOSPITALAR R$</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO EM R$</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="  <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+=" <tr> <td width='327' class='tit'>TOTAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNH + nPedNH, '@E 999,999,999.99') + "</strong></div></td></tr> "   
       
cMensagem+="</table>  "   
cMensagem+="</div></div></body></html> "

MemoWrite("D:\Temp\FATR054NOVA.html",cMensagem)
dbCloseArea("TMP")

	//cEmail := "gustavo@ravaembalagens.com.br"
	cEmail := SuperGetMV("RV_FATR54", ,"marcelo@ravaembalagens.com.br;giancarlo.sousa@ravaembalagens.com.br;edna@ravaembalagens.com.br")
    cAssunto := "Faturamento Rava p/ Nova"
    //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
    U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

Return


Static Function Exec07()


Local cQuery 		:= ""
Local nValorNH		:= 0
Local nValorND		:= 0
Local nValorNI		:= 0
Local nQuantNH		:= 0
Local nQuantND		:= 0
Local nQuantNI		:= 0
Local nPedNH		:= 0
Local nPedND		:= 0
Local nPedNI		:= 0
Local nValorR		:= 0
Local nValorPA		:= 0
Local nValorPD		:= 0
Local nValorPI		:= 0
Loca cMensagem 		:=""

cMensagem+="<!DOCTYPE html><html lang='pt-br'><head>    <meta charset='UTF-8'>    <title>FATURAMENTO CLIENTE INATIVO</title>    <style> "        
cMensagem+="div#interface {            width: 800px;            font-family: Arial;            font-size: 14px;        } " 
cMensagem+="       div#interface h1 {            display: block;            overflow: hidden;            height: 32px; "  
cMensagem+="          width: 600px;            padding-bottom: 50px;            background-position: 0 -43px; "      
cMensagem+="      background-image: url('http://ravabrasil.com.br/assets/img/sprite/standard-sc18fe437b4.png'); "     
cMensagem+="       background-repeat: no-repeat;            background-size: 40%;        } "        
cMensagem+="div#interface h1 p {            text-align: right;            font-size: 20px;        } "        
cMensagem+="div#corpo h3 {            text-align: center;            font-size: 18px;        } "        
cMensagem+="div#corpo h2 {            text-align: center;            font-size: 16px;        } "        
cMensagem+="table#status {            font-size: 20px;        }        table#status td.a1 { "            
cMensagem+="background-color: red;        }        table#status td.a2 {            background-color: orange;        } " 
cMensagem+="       table#status td.a3 {            background-color: gold;        }  "       
cMensagem+="table#status td.a4 {            background-color: greenyellow;            visibility: hidden;        } " 
cMensagem+="       table#status td.a5 {            background-color: limegreen;            visibility: hidden;        } " 
cMensagem+="       table#geral {            border-spacing: 0px;        }        table#geral td { "         
cMensagem+="   border: 1px solid black;            padding: 2px;        }  "       
cMensagem+="table#geral td.tit {            font-weight: bold;            background-color: rgba(180,255,166,0.65);        } "    
cMensagem+="</style></head><body><div id='interface'>    <h1>      <p>&nbsp;</p> "    
cMensagem+="</h1>    <div id='corpo'>        <h3>ACOMPANHAMENTO DO FATURAMENTO RAVA P/ TOTAL</h3> "  
      
cMensagem+="<h2>PERÍODO " + DtoC(FirstDate(ddatabase)) + " ATÉ " + DtoC(ddatabase) + "</h2>  "       
cMensagem+="<table id='geral'> "

//***********************************
// Monta a tabela de vendas da TOTAL
//***********************************

cQuery := " SELECT 	SUM( CASE WHEN D2_GRUPO = 'C' THEN ((D2_QUANT-D2_QTDEDEV))*D2_PRCVEN ELSE 0 END ) AS VHOSP,  " 
cQuery += "			SUM( CASE WHEN D2_GRUPO IN ('D','E') THEN ((D2_QUANT-D2_QTDEDEV))*D2_PRCVEN ELSE 0 END ) AS VDOM,   "
cQuery += "			SUM( CASE WHEN D2_GRUPO IN ('A','B','G') THEN ((D2_QUANT-D2_QTDEDEV))*D2_PRCVEN ELSE 0 END ) AS VINSTITUCIONAL,   "
cQuery += " 		SUM( CASE WHEN D2_GRUPO = 'C' THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QHOSP,  " 
cQuery += "			SUM( CASE WHEN D2_GRUPO IN ('D','E') THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QDOM,   "
cQuery += "			SUM( CASE WHEN D2_GRUPO IN ('A','B','G') THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QINSTITUCIONAL   "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "			INNER JOIN SB5010 SB5 "
cQuery += "			ON D2_COD = B5_COD "
cQuery += "         WHERE D2_FILIAL = '07' "
cQuery += " 		AND D2_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' )" 
//cQuery += " 		AND D2_CLIENTE NOT IN ('031732','031733','006543','007005')"
cQuery += " 		AND	SD2.D2_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND " 
cQuery += "         SD2.D_E_L_E_T_ =   '' AND "
cQuery += "         SB5.D_E_L_E_T_ =   '' "
cQuery += " 		AND D2_SERIE <> '' " 

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nValorNH := TMP->VHOSP
	nValorND := TMP->VDOM
	nValorNI := TMP->VINSTITUCIONAL
	nQuantNH := TMP->QHOSP
	nQuantND := TMP->QDOM
	nQuantNI := TMP->QINSTITUCIONAL

Else

	nValorNH := 0
	nValorND := 0
	nValorNI := 0
	nQuantNH := 0
	nQuantND := 0
	nQuantNI := 0

EndIf

cQuery := " SELECT "
cQuery += "SUM( CASE WHEN B1_GRUPO = 'C' THEN  C6_QTDVEN*C6_PRCVEN ELSE 0 END ) AS VHOSP, "  
cQuery += "SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN  C6_QTDVEN*C6_PRCVEN ELSE 0 END ) AS VDOM, "  
cQuery += "SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN  C6_QTDVEN*C6_PRCVEN ELSE 0 END ) AS VINSTITUCIONAL, "  
cQuery += "SUM( CASE WHEN B1_GRUPO = 'C' THEN  C6_QTDVEN ELSE 0 END ) AS QHOSP, "  
cQuery += "SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN C6_QTDVEN ELSE 0 END ) AS QDOM, "  
cQuery += "SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN C6_QTDVEN ELSE 0 END ) AS QINSTITUCIONAL "  
cQuery += "FROM SC6020 SC6 WITH (NOLOCK) "
cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) "
cQuery += "ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM  "
cQuery += "INNER JOIN SB1010 SB1 "
cQuery += "ON C6_PRODUTO = B1_COD "
cQuery += "INNER JOIN SB5010 SB5 "
cQuery += "ON C6_PRODUTO = B5_COD "
cQuery += "WHERE C6_FILIAL = '07' AND  "
cQuery += "C6_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND " 
cQuery += "SC5.C5_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND "  
cQuery += "SC6.D_E_L_E_T_ =   '' AND  "
cQuery += "SC5.D_E_L_E_T_ =   '' AND "
cQuery += "SB1.D_E_L_E_T_ =   '' AND "
cQuery += "SB5.D_E_L_E_T_ =   '' AND "
cQuery += "SC6.C6_NOTA = '' " 

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nPedNH  := TMP->VHOSP
	nPedND  := TMP->VDOM
	nPedNI  := TMP->VINSTITUCIONAL
	nPedNHQ := TMP->QHOSP
	nPedNDQ := TMP->QDOM
	nPedNIQ := TMP->QINSTITUCIONAL

Else

	nPedNH  := 0
	nPedND  := 0
	nPedNI  := 0
	nPedNHQ := 0
	nPedNDQ := 0
	nPedNIQ := 0

EndIf



//nValor := 0

//***********************************
// Monta a tabela de vendas da RAVA p/ TOTAL
//***********************************

cQuery := " SELECT 	SUM( CASE WHEN B1_GRUPO = 'C' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS VFATPA, "  
cQuery += "			SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS VFATDOM,  "
cQuery += "			SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS VFATPI,  "
cQuery += " 		SUM( CASE WHEN B1_GRUPO = 'C' THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QFATPA, "  
cQuery += "			SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QFATDOM,  "
cQuery += "			SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN (D2_QUANT-D2_QTDEDEV) ELSE 0 END ) AS QFATPI  "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += "         ON D2_COD = B1_COD " 
cQuery += "			INNER JOIN SB5010 SB5 "
cQuery += "			ON D2_COD = B5_COD "
cQuery += "         WHERE D2_FILIAL = '01' "
cQuery += " 		AND D2_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' )" 
cQuery += " 		AND SD2.D2_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND " 
cQuery += "         SD2.D_E_L_E_T_ =   '' AND "
cQuery += "         SB5.D_E_L_E_T_ =   '' "
cQuery += " 		AND D2_SERIE <> '' " 
cQuery += "			AND D2_CLIENTE = '007005' "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

If Select("TMP") > 0

	nValorPA := TMP->VFATPA
	nValorPD := TMP->VFATDOM
	nValorPI := TMP->VFATPI
	nQuantPA := TMP->QFATPA
	nQuantPD := TMP->QFATDOM
	nQuantPI := TMP->QFATPI
	nValorR  := TMP->VFATPA + TMP->VFATPI + TMP->VFATDOM

Else

	nValorPA := 0
	nValorPD := 0
	nValorPI := 0
	nQuantPA := 0
	nQuantPD := 0
	nQuantPI := 0
	nValorR := 0

EndIf


cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO DOMESTICA </td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> QTD. FATURADA DOMESTICA</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantND, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNDQ, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>QTD. TOTAL DOMESTICA</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantND + nPedNDQ, '@E 999,999,999.99') + "</strong></div></td></tr> "   
cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'>FATURAMENTO RAVA DOMESTICA</td></tr> "
cMensagem+="<tr> <td class='tit'>DOM - FATURADO RAVA P/ TOTAL</td>   <td class='co'><div align='right'><strong>" + TRANSFORM(nQuantPD, '@E 999,999,999.99') + "</strong></div></td> </tr> "
cMensagem+="<tr bgcolor='#98fb98'> <td class='tit'>QTD. DIFERENÇA DOMESTICA</td> " 
cMensagem+="      <td class='tit'><div align='right'>" + TRANSFORM(nQuantPD - nQuantND - nPedNDQ , '@E 999,999,999.99') + "</div></td> "
cMensagem+="    </tr>            <tr> <td colspan='2' class='tit'><div align='right'></div></td>   </tr> "

cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO INSTITUCIONAL </td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> QTD. FATURADA INSTITUCIONAL</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNIQ, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>QTD. TOTAL INSTITUCIONAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNI + nPedNIQ, '@E 999,999,999.99') + "</strong></div></td></tr> "   
cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'>FATURAMENTO RAVA INSTITUCIONAL</td></tr> "
cMensagem+="<tr> <td class='tit'>INS - FATURADO RAVA P/ TOTAL</td>   <td class='co'><div align='right'><strong>" + TRANSFORM(nQuantPI, '@E 999,999,999.99') + "</strong></div></td> </tr> "
cMensagem+="<tr bgcolor='#98fb98'> <td class='tit'>QTD. DIFERENÇA INSTITUCIONAL </td> " 
cMensagem+="      <td class='tit'><div align='right'>" + TRANSFORM(nQuantPI - nQuantNI - nPedNIQ , '@E 999,999,999.99') + "</div></td> "
cMensagem+="    </tr>            <tr> <td colspan='2' class='tit'><div align='right'></div></td>   </tr> "

cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO HOSPITALAR</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> QTD. FATURADA</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="  <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNHQ, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+=" <tr> <td width='327' class='tit'>QTD. TOTAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nQuantNH + nPedNHQ, '@E 999,999,999.99') + "</strong></div></td></tr> "   
cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'>FATURAMENTO RAVA</td></tr><tr> <td class='tit'>HOSP - FATURADO RAVA P/ TOTAL</td> "   
cMensagem+="      <td class='co'><div align='right'><strong>" + TRANSFORM(nQuantPA, '@E 999,999,999.99') + "</strong></div></td> </tr> "            
cMensagem+=" <tr bgcolor='#98fb98'> <td class='tit'>DIFERENÇA DO PA</td> " 
cMensagem+="        <td class='tit'><div align='right'><strong>" + TRANSFORM(nQuantPA - nQuantNH - nPedNHQ, '@E 999,999,999.99') + "</strong></div></td> "
cMensagem+="      </tr> " 

cMensagem+="     <tr> <td colspan='2' class='tit'></td>   </tr>"
cMensagem+="     <tr> <td colspan='2' class='tit'></td>   </tr>"

cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO DOMESTICA R$</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO EM R$</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorND, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedND, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>TOTAL DOMESTICA</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorND + nPedND, '@E 999,999,999.99') + "</strong></div></td></tr> "   

cMensagem+=" <tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO INSTITUCIONAL R$</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO EM R$</td> "  
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNI, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>TOTAL INSTITUCIONAL</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNI + nPedNI, '@E 999,999,999.99') + "</strong></div></td></tr> "   

cMensagem+="<tr bgcolor=#98fb98> <td colspan='2' class='tit'> TOTAL - FATURAMENTO HOSPITALAR R$</td> " 
cMensagem+="</tr>            <tr> <td width='327' class='tit'> FATURADO EM R$</td> "   
cMensagem+="<td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+="<tr> <td width='327' class='tit'>PEDIDO</td> "   
cMensagem+="  <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nPedNH, '@E 999,999,999.99') + "</strong></div></td></tr> "
cMensagem+=" <tr> <td width='327' class='tit'>TOTAL HOSPITALAR</td> "   
cMensagem+="    <td width='459' class='co'><div align='right'><strong>" + TRANSFORM(nValorNH + nPedNH, '@E 999,999,999.99') + "</strong></div></td></tr> "   
       
cMensagem+="</table>  "   
cMensagem+="</div></div></body></html> "

MemoWrite("D:\Temp\FATR054TOTAL.html",cMensagem)
dbCloseArea("TMP")

	//cEmail := "gustavo@ravaembalagens.com.br"
	cEmail := SuperGetMV("RV_FATR54", ,"marcelo@ravaembalagens.com.br;giancarlo.sousa@ravaembalagens.com.br;edna@ravaembalagens.com.br")
    cAssunto := "Faturamento Rava p/ TOTAL"
    //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
    U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

Return

