#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

*********************************
User function CFATC02(cCod,cLoja)
*********************************
Local aMedPed := fMedPed(cCod,cLoja)

//Brasileirinho
Local nBRAVM  := 0
Local nBRAPM  := 0
Local nBRAVP  := 0
Local nBRAPP  := 0
Local nBRADes := 0
   
//Infectante
Local nINFVM  := 0
Local nINFPM  := 0
Local nINFVP  := 0
Local nINFPP  := 0
Local nINFDes := 0
   
//Hamper
Local nHAMVM  := 0
Local nHAMPM  := 0
Local nHAMVP  := 0
Local nHAMPP  := 0
Local nHAMDes := 0

//Obito
Local nOBIVM  := 0
Local nOBIPM  := 0
Local nOBIVP  := 0
Local nOBIPP  := 0
Local nOBIDes := 0

Private aItensCam    := {}


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oDlg1","oGrp1","oGrp2","oTitBRA","oBRAVM","oBRAPM","oBRAVP","oBRAPP","oBRADes")
SetPrvt("oINFVM","oINFPM","oINFVP","oINFPP","oINFDes","oTitHAM","oHAMVM","oHAMPM","oHAMVP","oHAMPP","oHAMDes")
SetPrvt("oOBIVM","oOBIPM","oOBIVP","oOBIPP","oOBIDes","oSay13","oSay14","oSay15","oSay20","oSay25","oBtn1")
/*
01  TABX->SLINHA,;  
02  TABX->MEDIAKG,;
03  TABX->PRCMEDIO,;
04  TABX->VLRMEDIO,;
05  TABX->INC1,;
06  TABX->FATOR1,;
07  TABX->DESC1,;
08  TABX->INC2,;
09  TABX->FATOR2,;
10  TABX->DESC2,;
11  TABX->INC3,;
12  TABX->FATOR3,;
13  TABX->DESC3,;
14  0,; volume pedido
15  0   fator  pedido
*/

for _x := 1 to Len(aMedPed)
   nDesc := 0
   //Comparo o pedido com o intervalo 3
   if     ( aMedPed[_x,14] >= aMedPed[_x,11] ) .and. ( aMedPed[_x,15]*(1-aMedPed[_x,13] ) >= aMedPed[_x,12] )
      nDesc := aMedPed[_x,13]
   //Comparo o pedido com o intervalo 2
   elseif ( aMedPed[_x,14] >= aMedPed[_x,08] ) .and. ( aMedPed[_x,15]*(1-aMedPed[_x,10] ) >= aMedPed[_x,09] )
      nDesc := aMedPed[_x,10]
   //Comparo o pedido com o intervalo 1
   elseif ( aMedPed[_x,14] >= aMedPed[_x,05] ) .and. ( aMedped[_x,15]*(1-aMedPed[_x,07] ) >= aMedPed[_x,06] )
      nDesc := aMedPed[_x,7]
   endif
   //                Linha        VolMedKG        PrcMedio      VolPedido     PrcMedioPedido  %Desc
   Aadd( aItensCam, { aMedPed[_x,1], aMedPed[_x,2], aMedPed[_x,3], aMedPed[_x,14], aMedPed[_x,15], nDesc } )                       
next _x

if Len(aItensCam) > 0
   for _x := 1 to Len(aItensCam)
      if aItensCam[_x,1] = 'BRA'
         //Brasileirinho
         nBRAVM  := aItensCam[_x,2]
         nBRAPM  := aItensCam[_x,3]
         nBRAVP  := aItensCam[_x,4]
         nBRAPP  := aItensCam[_x,5]
         nBRADes := aItensCam[_x,6]
      elseif aItensCam[_x,1] = 'INF'
         //Infectante
         nINFVM  := aItensCam[_x,2]
         nINFPM  := aItensCam[_x,3]
         nINFVP  := aItensCam[_x,4]
         nINFPP  := aItensCam[_x,5]
         nINFDes := aItensCam[_x,6]
      elseif aItensCam[_x,1] = 'HAM'   
         //Hamper
         nHAMVM  := aItensCam[_x,2]
         nHAMPM  := aItensCam[_x,3]
         nHAMVP  := aItensCam[_x,4]
         nHAMPP  := aItensCam[_x,5]
         nHAMDes := aItensCam[_x,6]
      elseif aItensCam[_x,1] = 'OBI'
         //Obito
         nOBIVM  := aItensCam[_x,2]
         nOBIPM  := aItensCam[_x,3]
         nOBIVP  := aItensCam[_x,4]
         nOBIPP  := aItensCam[_x,5]
         nOBIDes := aItensCam[_x,6]
      endif
   next _x

   /*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
   ±± Definicao do Dialog e todos os seus componentes.                        ±±
   Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
   oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
   oFont2     := TFont():New( "Courier New",0,-16,,.F.,0,,400,.F.,.F.,,,,,, )
   oDlg1      := MSDialog():New( 147,202,392,1051,"Campanha de Preço x Volume - Concessão de Descontos",,,.F.,,,,,,.T.,,,.F. )
   oGrp1      := TGroup():New( 005,006,089,411,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
   oGrp2      := TGroup():New( 010,195,087,196,"",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
   oSay13     := TSay():New( 013,080,{||"Volume Médio"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
   oSay14     := TSay():New( 013,206,{||"Volume Pedido"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
   oSay15     := TSay():New( 013,140,{||"Preço Médio"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
   oSay20     := TSay():New( 013,274,{||"Preço Pedido"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
   oSay25     := TSay():New( 013,338,{||"Desconto Previsto"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)

   oTitBRA    := TSay():New( 028,018,{||"Brasileirinho:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,049,008)
   oTitINF    := TSay():New( 040,018,{||"Infectante:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,049,008)
   oTitHAM    := TSay():New( 053,018,{||"Hamper:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,049,008)
   oTitOBI    := TSay():New( 065,018,{||"Obito:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,049,008)
   
   //Brasileirinho          
   oBRAVM     := TSay():New( 028,078,{||Transform(nBRAVM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oBRAPM     := TSay():New( 028,138,{||Transform(nBRAPM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oBRAVP     := TSay():New( 028,206,{||Transform(nBRAVP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oBRAPP     := TSay():New( 028,272,{||Transform(nBRAPP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oBRADes    := TSay():New( 028,353,{||Transform(nBRADes*100,"@E 99.99")+"%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   
   //Infectante
   oINFVM     := TSay():New( 040,078,{||Transform(nINFVM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oINFPM     := TSay():New( 040,138,{||Transform(nINFPM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oINFVP     := TSay():New( 040,206,{||Transform(nINFVP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oINFPP     := TSay():New( 040,272,{||Transform(nINFPP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oINFDes    := TSay():New( 040,353,{||Transform(nINFDes*100,"@E 99.99")+"%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   
   //Hamper
   oHAMVM     := TSay():New( 053,078,{||Transform(nHAMVM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oHAMPM     := TSay():New( 053,138,{||Transform(nHAMPM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oHAMVP     := TSay():New( 053,206,{||Transform(nHAMVP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oHAMPP     := TSay():New( 053,272,{||Transform(nHAMPP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oHAMDes    := TSay():New( 053,353,{||Transform(nHAMDes*100,"@E 99.99")+"%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)

   //Obito
   oOBIVM     := TSay():New( 065,078,{||Transform(nOBIVM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oOBIPM     := TSay():New( 065,138,{||Transform(nOBIPM ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oOBIVP     := TSay():New( 065,206,{||Transform(nOBIVP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,057,008)
   oOBIPP     := TSay():New( 065,272,{||Transform(nOBIPP ,"@E 999,999.99")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)
   oOBIDes    := TSay():New( 065,353,{||Transform(nOBIDes*100,"@E 99.99")+"%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,050,008)

   oBtn1      := TButton():New( 095,292,"Confirma",oDlg1,,051,014,,,,.T.,,"",,,,.F. )
   oBtn1:bAction := {||ClicaBtn(.T.)}
   oBtn2      := TButton():New( 095,353,"Cancela" ,oDlg1,,051,014,,,,.T.,,"",,,,.F. )
   oBtn2:bAction := {||ClicaBtn(.F.)}

   oDlg1:Activate(,,,.T.)
endif

return


*****************************
static function ClicaBtn(bOk)
*****************************

Local nPOSAPD  := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_APDESC"  } )
Local nPOSPROD := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSQTD  := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN"  } )
Local nPOSPRUN := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT"  } )
Local nPOSPRVE := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRCVEN"  } )
Local nPOSVALO := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR"   } )
Local cLinha
Local _x := nPos := nValor := 0

DbSelectArea("SB1")
DbSetOrder(1)
for _x := 1 to Len( aCols )
   SB1->( DbSeek(xFilial("SB1")+aCols[_x,nPOSPROD]) )
   cLinha := getLinha(SB1->B1_SETOR)
   nPos   := aScan( aItensCam, { |x| AllTrim(x[1]) == cLinha } )
   if nPos > 0 .and. aItensCam[nPos,6] > 0 .AND. aCols[_x, nPOSAPD] <> "S"
      aCols[_x, nPOSAPD] := if( bOk, "S", "N" )  
      if bOk            
         nValor := aCols[_x, nPOSPRUN]*(1-aItensCam[nPos,6])
         aCols[_x, nPOSPRUN ] := nValor
         aCols[_x, nPOSPRVE ] := nValor
         aCols[_x, nPOSVALO ] := aCols[_x, nPOSQTD ] * nValor               
      endif               
   endif   
next _x

oDlg1:End()

return


********************************
static function getLinha(cSetor)
********************************
local cLinha

if cSetor $ "05 37 40 56" 
   cLinha := "HAM"
elseif cSetor $ "08 09 10 11 12 13 14 30 34 35 36 41 55"
   cLinha := "INF"
elseif cSetor $ "06 54 98" 
   cLinha := "OBI"
elseif cSetor $ "23 24 25"
   cLinha := "DON"
elseif cSetor $ "26 27 28"
   cLinha := "BRA
else
   cLinha := "INS"
endif
  
return cLinha

    
***********************************
static function fMedPed(cCod,cLoja)
***********************************
      
Local cQuery
Local aRet := {}
local cLinha := ""
local _X
Local nPOSTOT  := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR" } )
Local nPOSPROD := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSQUAN := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
Local nValTot  := 0

cQuery := "SELECT * FROM TV_MEDIA_VENDA('"+cCod+"','"+cLoja+"' ) "

if Select("TABX") > 0
	DbSelectArea("TABX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "TABX"

while !TABX->(EOF())
   Aadd( aRet, { TABX->SLINHA,;  
                 TABX->MEDIAKG,;
                 TABX->PRCMEDIO,;
                 TABX->VLRMEDIO,;
                 TABX->INC1,;
                 TABX->FATOR1,;
                 TABX->DESC1,;
                 TABX->INC2,;
                 TABX->FATOR2,;
                 TABX->DESC2,;
                 TABX->INC3,;
                 TABX->FATOR3,;
                 TABX->DESC3,;
                 0,;
                 0 } )
   TABX->(DbSkip())
end                   

if Select("TABX") > 0
	DbSelectArea("TABX")
	DbCloseArea()
endif

//14 Volume KG Pedido
//15 Fator     Pedido

DbSelectArea("SB1")
DbSetOrder(1)
for _X := 1 to Len(aCols)
   SB1->( DbSeek(xFilial("SB1")+aCols[_X,nPOSPROD]) )
   cLinha := getLinha(SB1->B1_SETOR)
   nPos   := aScan( aRet, { |x| AllTrim(x[1]) == cLinha } )
   if nPos > 0
      nValTot += aCols[_X,nPOSTOT]
      aRet[nPos,14] += aCols[_X,nPOSQUAN]*SB1->B1_PESO
      aRet[nPos,15] := nValTot/aRet[nPos,14]
   endif
next _X

Return aRet