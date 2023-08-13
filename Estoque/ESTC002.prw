#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ESTC002   บ Autor ณ Eurivan Marques   บ Data ณ  13/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calcula estoque m้dio de produtos                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Modulo Estoque                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

***********************
User Function ESTC002()
***********************

conOut( " " )
conOut( "***************************************************************************" )
conOut( "Programa de calculo de fat.dia e estoq.dia p/giro.                         " )
conOut( "***************************************************************************" )
conOut( " " )

if Select( 'SX2' ) == 0
   RPCSetType( 3 )  //Nao consome licensa de uso
   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "ESTC002" Tables "Z45"
   Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
  
   CalcEMed()
else 
   MsAguarde( {|| CalcEMed() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Calculando Giro..." ) )    
endif


Return

***************************
Static Function CalcEMed()
***************************

Local aEstoque := {}
Local nEstoq   := 0
Local nFatur   := 0
Local dData    := dDatabase
Local cQuery   

//Calculo o Estoque em Kgs
cQuery := "Select B1_DESC, B1_COD, B1_PESOR, B1_CONV, B1_TIPCONV "
cQuery += "from " + RetSqlName("SB1") + " where B1_ATIVO = 'S' and B1_TIPO = 'PA' "
cQuery += "and B1_COD BETWEEN '   ' and 'ZZZZZZZZZZZZZZZ' "
cQuery += "and B1_FILIAL  = '" + xFilial( "SB1" ) + "' and D_E_L_E_T_ = ' '  "
cQuery += "and LEN( B1_COD ) <= 7 "
cQuery += "order by B1_COD "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SBBX"

SBBX->( dbgotop() )

DbSelectArea("Z45")
DbSetOrder(1)

while ! SBBX-> ( EOF() )
   nSoma  := 0
   aEstoque := CalcEst(SBBX->B1_COD, '01', dData ) //Estoque de Produtos Acabados
   if aEstoque != Nil
      nSoma += aEstoque[1] + CalcEst(SBBX->B1_COD, '02', dData )[1] //Estoque de Produtos Incompletos
   endif
   nEstoq += (SBBX->B1_PESOR * nSoma) //Estoque em Kgs
   SBBX->( dbskip() )
end

SBBX->( DbCloseArea() )

//Calculo a quantidade faturada em Kgs
cQuery := "SELECT PESO=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0) "
cQuery += "ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "VALOR=SUM(D2_TOTAL) "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SF2")+" SF2 "
cQuery += "WHERE D2_EMISSAO BETWEEN "+DtoS(dData-1)+" AND "+DtoS(dData-1)+" "
cQuery += "AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' "
cQuery += "AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQuery += "AND F2_DUPL <> ' ' "
cQuery += "AND SF2.D_E_L_E_T_ = '' "
cQuery += "GROUP BY D2_SERIE, F2_VEND1 "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SF2X"

while !SF2X->(EOF())
   nFatur += SF2X->PESO                   
   SF2X->(DbSkip())
end
SF2X->( DbCloseArea() )

lInc := !Z45->(DbSeek(xFilial("Z45")+Dtos(dData-1),.F. ) )
RecLock("Z45",lInc)
Z45->Z45_FILIAL := xFilial("Z45")
Z45->Z45_DATA   := dData-1
Z45->Z45_FATUR  := nFatur
Z45->Z45_ESTOQ  := nEstoq
Z45->(MsUnLock())

Return Nil