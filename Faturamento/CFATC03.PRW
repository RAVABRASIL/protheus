#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//Definicao do tipo de cliente
#DEFINE DESC0    000
#DEFINE DESC1    001
#DEFINE DESC2    002
#DEFINE MB_YESNO 4
#DEFINE IDYES    6

#DEFINE CDESC0   0.00
#DEFINE CDESC1   0.10
#DEFINE CDESC2   0.05

*********************************
user function CFATC03(cCod,cLoja)
*********************************

Local nTpDesc
Local nDesc   := CDESC0
Local sMSG    := ""
Local aLinhas := verLinha()
Local cNComp

if Len(aLinhas) > 0
   for _x := 1 to Len(aLinhas)
      nTpDesc := verDesc(cCod,cLoja,aLinhas[_x][1]) 
      if nTpDesc == DESC1 
         nDesc   := CDESC1 
         cNComp  := "1ª" 
      elseif nTpDesc == DESC2
         nDesc := CDESC2
         cNComp  := "2ª"      
      endif

      if nDesc > 0
         sMSG := "O sistema identificou que o cliente deste pedido tem direito a um DESCONTO de: "
         sMSG += Alltrim(Transform(nDesc*100,"@E 99.9"))+"%, por se tratar de um Cliente NOVO ou REATIVADO na RAVA ou na LINHA, e ser a "+cNComp+" Compra."+chr(13)+chr(13)
         sMSG += "O desconto será aplicado no Produto: "+AllTrim(aLinhas[_x][2])+" - "+aLinhas[_x][1]+chr(13)
         sMsg += chr(13)
         sMSG += "Confirma a aplicação do desconto?"
         if MessageBox(sMSG," Aplicar Desconto",MB_YESNO) == IDYES
            //Aplicar o desconto
            descon(nDesc*100,aLinhas[_x][3])            
         endif   
      endif            
   next   
endif

return

******************************************
static function verDesc(cCod,cLoja,cLinha)
******************************************

Local nRet   := DESC0
Local nVenda := 1
Local nDias1 := 0
Local cQuery := ""

cQuery += "SELECT TOP 2 "
cQuery += "   COD, "
cQuery += "   LOJA, "
cQuery += "   DTUPED, "
cQuery += "   DIAS "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "          PV = SC5.C5_NUM, "
cQuery += "         COD = SC5.C5_CLIENTE, "
cQuery += "        LOJA = SC5.C5_LOJACLI, "
cQuery += "       LINHA = CASE "
cQuery += "                  WHEN B1_GRUPO IN('D','E')     THEN 'DOMESTICA' "
cQuery += "                  WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery += "                  WHEN B1_GRUPO IN('C')         THEN 'HOSPITALAR' "
cQuery += "                  ELSE B1_GRUPO "
cQuery += "               END, "
cQuery += "      DTUPED = SC5.C5_ENTREG, "
cQuery += "        DIAS = CAST( CONVERT(DATETIME,  convert(varchar, getdate(), 112) )- CONVERT(DATETIME,C5_ENTREG) AS INTEGER ) "
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6 "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "      SC5.C5_CLIENTE = '"+cCod+"' AND SC5.C5_LOJACLI = '"+cLoja+"' AND C5_NUM <> '"+M->C5_NUM+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND SC5.C5_ENTREG <> '' AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      SC5.C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ENTREG, "
cQuery += "      CASE "
cQuery += "         WHEN B1_GRUPO IN('D','E')     THEN 'DOMESTICA' "
cQuery += "         WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery += "         WHEN B1_GRUPO IN('C')         THEN 'HOSPITALAR' "
cQuery += "         ELSE B1_GRUPO "
cQuery += "      END "
cQuery += ") AS VENDAS "
cQuery += "WHERE "
cQuery += "   LINHA = '"+cLinha+"' "
cQuery += "ORDER BY "
cQuery += "   DTUPED DESC "

if Select("TABX") > 0
	DbSelectArea("TABX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "TABX"
TABX->(DbGoTop())

if TABX->(eof())
   //Primeira Compra Cliente NOVO
   nRet := DESC1
else
   nDias1 := TABX->DIAS
   while !TABX->(EOF())
      //Primeira Compra Cliente INATIVO
      if nVenda == 1 .AND. TABX->DIAS > SuperGetMV("RV_INATCLI",,120)
         nRet := DESC1
         Exit
      //Segunda Compra Cliente INATIVO
      elseif nVenda == 2 .AND. nDias1 < SuperGetMV("RV_INATCLI",,120) .AND.;
                             TABX->DIAS > SuperGetMV("RV_INATCLI",,120)         
         nRet := DESC2           
      endif
      TABX->(DbSkip())
      if !TABX->(eof())
         nVenda += 1
      endif   
   end
   //Segunda Compra Cliente NOVO
   if ( nVenda == 1 .AND. nDias1 < SuperGetMV("RV_INATCLI",,120)  )
      nRet := DESC2
   endif         
endif
   
if Select("TABX") > 0
	DbSelectArea("TABX")
	DbCloseArea()
endif

return nRet


********************************
static function getLinha(cSetor)
********************************
local cLinha

if cSetor $ "06 54 98 05 37 40 56 08 09 10 11 12 13 14 30 34 35 36 41 55"
   cLinha := "HOSPITALAR"
elseif cSetor $ "23 24 25 26 27 28"
   cLinha := "DOMESTICA"
else
   cLinha := "INSTITUCIONAL"
endif
  
return cLinha

**************************
static function verLinha()
**************************
Local aRet     := {}
Local nPOSPROD := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSDESC := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PDESC" } )
Local cLinha
Local _x

DbSelectArea("SB1")
DbSetOrder(1)
for _x := 1 to Len( aCols )
   SB1->( DbSeek(xFilial("SB1")+aCols[_x,nPOSPROD]) )
   cLinha := getLinha(SB1->B1_SETOR)
   if cLinha <> "INSTITUCIONAL" .AND. aCols[_x,nPOSDESC] == 0 .AND. !aCols[_x,Len(aHeader)+1] 
      Aadd( aRet, {cLinha, aCols[_x,nPOSPROD],_x } )
   endif
next _x

return aRet


***********************************
static Function descon(nDes,nLinha)
***********************************

Private nPDESC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PDESC"  } )
Private nVDESC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_VDESC"  } )
Private nPRUNIT := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Private nPRCVEN := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
Private nVALOR  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_VALOR"  } )
Private nQTDVEN := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN" } )

//So calculo se o valor for diferente do informado anteriormente
if nDes <> aCols[nLinha][nPDESC]
   CalcZero(nLinha)
   //Atualizo o % Desconto
   aCols[nLinha][nPDESC]  := nDes
   //Atualizo C6_PRUNIT
   aCols[nLinha][nPRUNIT] := aCols[nLinha][nPRUNIT]*(1-(nDes/100))
   //Atualizo C6_VDESC
   aCols[nLinha][nVDESC]  := aCols[nLinha][nPRCVEN]-aCols[nLinha][nPRUNIT]
   //Atualizo C6_PRCVEN
   aCols[nLinha][nPRCVEN] := aCols[nLinha][nPRUNIT]
   //Atualizo o Total
   aCols[nLinha][nVALOR]  := aCols[nLinha][nQTDVEN]*aCols[nLinha][nPRUNIT]   
endif

return


//Funcao para zerar o desconto
********************************
static function CalcZero(nLinha)
********************************

//Atualizo C6_PRUNIT
aCols[nLinha][nPRUNIT] := aCols[nLinha][nPRUNIT]+aCols[nLinha][nVDESC]

//Atualizo C6_PRCVEN
aCols[nLinha][nPRCVEN] := aCols[nLinha][nPRUNIT]

//Atualizo C6_VDESC
aCols[nLinha][nVDESC] := 0
//Atualizo o Total
aCols[nLinha][nVALOR] := aCols[nLinha][nQTDVEN]*aCols[nLinha][nPRUNIT]

return