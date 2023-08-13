#Include "topconn.ch"
#INCLUDE "Protheus.ch"                                
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#include 'rwmake.ch'

********************************************************************************* 
user function trackPV(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
*********************************************************************************

//http://10.0.0.11/u_trackPV.apl?cnpj=17498163000149
local cHTML := ''
local nX
//"17498163000149" 

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 1000 )   	
endif

if Len(__aProcParms) = 0 
   cHTML += '<p>Nenhum parâmetro informado na linha de URL.' 
else 
   cHTML := getJSONPV(__aProcParms[1,2])
endif
 
return(cHTML)
 
                                                                     
******************************
static function getJSONPV(cCNPJ)
******************************

local nQtdPed := 6
local aaTrack := Array(#)
local aPV := {}
local aIt := {}
local aSt := {} 

aPV := getPV(cCNPJ,nQtdPed)
//Varredura nos pedidos
for nX := 1 to len(aPV)  
   if nX = 1
      //Preenche informacoes do Cliente
      aaTrack[#'Cliente'] := Array(1)
      aaTrack[#'Cliente'][1] := Array(#)
      aaTrack[#'Cliente'][1][#'Codigo']    := aPV[nX,5]
      aaTrack[#'Cliente'][1][#'Loja']      := aPV[nX,6]
      aaTrack[#'Cliente'][1][#'Nome']      := aPV[nX,7]
      aaTrack[#'Cliente'][1][#'CNPJ']      := cCNPJ
      aaTrack[#'Cliente'][1][#'CodMun']    := aPV[nX,8]
      aaTrack[#'Cliente'][1][#'Municipio'] := aPV[nX,9]
      aaTrack[#'Cliente'][1][#'UF']        := aPV[nX,10]
   
      aaTrack[#'Pedidos'] := Array(aPV[nX,1])      
   endif   
   //Preenche informacoes do Pedido
   aaTrack[#'Pedidos'][nX] := Array(#)
   aaTrack[#'Pedidos'][nX][#'Numero']  := aPV[nX,3]
   aaTrack[#'Pedidos'][nX][#'Emissao'] := DtoC(aPV[nX,4])
   aIt := getIPV(aPv[nX,2],aPV[nX,3])
   //Varredura nos itens do pedido
   for nY := 1 to Len(aIt)
      if nY = 1
         aaTrack[#'Pedidos'][nX][#'Itens'] := Array(aIt[nY,1])
      endif
      //Preenche informacoes dos itens do pedido
      aaTrack[#'Pedidos'][nX][#'Itens'][nY] := Array(#)         
      aaTrack[#'Pedidos'][nX][#'Itens'][nY][#'Produto']    := aIt[nY,2]
      aaTrack[#'Pedidos'][nX][#'Itens'][nY][#'Descricao']  := aIt[nY,3]
      aaTrack[#'Pedidos'][nX][#'Itens'][nY][#'UM']         := aIt[nY,4]
      aaTrack[#'Pedidos'][nX][#'Itens'][nY][#'Quantidade'] := aIt[nY,5]
      aaTrack[#'Pedidos'][nX][#'Itens'][nY][#'Preco']      := aIt[nY,6]            
   next nY
   aSt := getSTA(aPv[nX,2],aPV[nX,3])
   //Varredura nos status do Pedido
   for nY := 1 to Len(aSt)
      if nY = 1
         aaTrack[#'Pedidos'][nX][#'Status'] := Array(aSt[nY,1])
      endif
      //Preenche informacoes dos status
      aaTrack[#'Pedidos'][nX][#'Status'][nY] := Array(#)         
      aaTrack[#'Pedidos'][nX][#'Status'][nY][#'Status']    := aSt[nY,2]
      aaTrack[#'Pedidos'][nX][#'Status'][nY][#'Descricao'] := aSt[nY,3]
      aaTrack[#'Pedidos'][nX][#'Status'][nY][#'Data']      := aSt[nY,4]
      aaTrack[#'Pedidos'][nX][#'Status'][nY][#'Hora']      := aSt[nY,5]            
   next nY   
next nX
        
//alert( JsonPrettify( ToJson(aaTrack), 3) )

Return ToJson( aaTrack )


**********************************
static function getPV(cCnpj,nQtPV)
**********************************
local nNumPed
local aRet := {}
local cQuery1, cQuery2, cQuery3

cQuery1 := "SELECT NPED=COUNT(FILIAL) FROM ( "
cQuery2 := "SELECT TOP "+Alltrim(Str(nQtPV))+" "
cQuery2 += "   FILIAL=C5_FILIAL,PEDIDO=C5_NUM,EMISSAO=C5_EMISSAO,CLIENTE=C5_CLIENTE,LOJA=C5_LOJACLI,NOME=A1_NOME,CODMUN=A1_COD_MUN,MUN=A1_MUN,UF=A1_EST "
cQuery2 += "FROM "
cQuery2 += "   "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA1")+" SA1 "
cQuery2 += "WHERE "
cQuery2 += "   C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1_CGC = '"+cCnpj+"' AND "
cQuery2 += "   SC5.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ <> '*' "
cQuery2 += "ORDER BY "
cQuery2 += "   C5_EMISSAO DESC "
cQuery3 := ") AS PEDIDOS "

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1+cQuery2+cQuery3),"QRY1",.T.,.T.)},"Aguarde...","Processando Dados...")
nNumPed := QRY1->NPED
QRY1->(DbCloseArea())

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRY1",.T.,.T.)

TCSetField( "QRY1", "EMISSAO", "D")

while !QRY1->(EOF())
   Aadd(aRet, {nNumPed,QRY1->FILIAL,QRY1->PEDIDO,QRY1->EMISSAO,QRY1->CLIENTE,QRY1->LOJA,;
               Alltrim(QRY1->NOME),QRY1->CODMUN,Alltrim(QRY1->MUN),QRY1->UF} )
   QRY1->(DbSkip())
end

QRY1->(DbCloseArea())

return aRet

********************************
static function getIPV(cFil,cPV)
********************************
local nNumIte
local aRet := {}
local cQuery1, cQuery2, cQuery3

cQuery1 := "SELECT NITEM=COUNT(PRODUTO) FROM ( "
cQuery2 := "   SELECT "
cQuery2 += "      PRODUTO= "
cQuery2 += "         CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
cQuery2 += "          CASE when (Substring( C6_PRODUTO, 4, 1 ) = 'R') or  (Substring( C6_PRODUTO, 5, 1 ) = 'R') "
cQuery2 += "          then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cQuery2 += "          else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end "
cQuery2 += "          ELSE rtrim(C6_PRODUTO) "
cQuery2 += "         END,  "
cQuery2 += "      UM=C6_UM,QUANT=C6_QTDVEN,PRECO=C6_PRCVEN "
cQuery2 += "   FROM "
cQuery2 += "      "+RetSqlName("SC6")+" SC6 "
cQuery2 += "   WHERE "
cQuery2 += "      C6_FILIAL='"+cFil+"' AND C6_NUM='"+cPV+"' AND SC6.D_E_L_E_T_ <> '*' "
cQuery3 := ") AS ITENS "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1+cQuery2+cQuery3),"QRY1",.T.,.T.)
nNumIte := QRY1->NITEM
QRY1->(DbCloseArea())

cQuery2 += "ORDER BY C6_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRY1",.T.,.T.)

DbSelectArea("SB1")
DbSetOrder(1)

while !QRY1->(EOF())
   SB1->(DbSeek(xFilial("SB1")+PADR(QRY1->PRODUTO,15) ) )
   Aadd(aRet, {nNumIte,Alltrim(QRY1->PRODUTO),Alltrim(SB1->B1_DESC),QRY1->UM,QRY1->QUANT,QRY1->PRECO} )
   QRY1->(DbSkip())
end

QRY1->(DbCloseArea())

return aRet


********************************
static function getSTA(cFil,cPV)
********************************
local nNumSta
local aRet := {}
local cQuery

cQuery1 := "SELECT NSTAT=COUNT(STATUS) FROM ( "
cQuery2 := "SELECT "
cQuery2 += "   STATUS=ZAC_STATUS,DESCST=ZAC_DESCST,DTSTATUS=ZAC_DTSTAT,HRSTATUS=ZAC_HRSTAT,USUARIO=ZAC_USER "
cQuery2 += "FROM "
cQuery2 += "  "+RetSqlName("ZAC")+" ZAC "
cQuery2 += "WHERE "
cQuery2 += "  ZAC_FILIAL = '"+cFil+"' AND ZAC_PEDIDO = '"+cPV+"' AND ZAC.D_E_L_E_T_ <> '*' "
cQuery3 := ") AS STATUS "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1+cQuery2+cQuery3),"QRY1",.T.,.T.)
TCSetField( "QRY1", "DTSTATUS", "D")
nNumSta := QRY1->NSTAT
QRY1->(DbCloseArea())

cQuery2 += "ORDER BY ZAC_STATUS, ZAC_DTSTAT, ZAC_HRSTAT "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRY1",.T.,.T.)

TCSetField( "QRY1", "DTSTATUS", "D")

while !QRY1->(EOF())
   Aadd(aRet, {nNumSta,QRY1->STATUS,QRY1->DESCST,DtoC(QRY1->DTSTATUS),QRY1->HRSTATUS,QRY1->USUARIO} )
   QRY1->(DbSkip())
end

QRY1->(DbCloseArea())

return aRet