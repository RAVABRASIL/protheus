#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

***********************
User function FINC0010(cNaturez)
***********************
local cNatu1 := GetMv("MV_NAT1")
local cNatu2 := GetMv("MV_NAT2")
local lNat1  := .F.
local lNat2  := .F.
local cQuery
local lOk := .T.

//1 Titulo - 21115,21116,21104,21208,21102,20130,21206,21508,21601
//2 Titulos - 21605, 20711

if Alltrim(cNaturez) $ cNatu1
   lNat1 := .T.
elseif Alltrim(cNaturez) $ cNatu2
   lNat2 := .T.
else
   Return lOk   
endif

cQuery := "SELECT COUNT(*) AS QTD "
cQuery += "FROM "+RetSqlName("SE2")+" "
cQuery += "WHERE E2_EMISSAO BETWEEN '"+Subs(dtos(dDataBase),1,6)+"01' "
cQuery += "AND '"+Dtos(LastDay(dDataBase))+"' " "
cQuery += "AND E2_NATUREZ = '"+Alltrim(cNaturez)+"' "
cQuery += "AND D_E_L_E_T_ = '' " 

TCQUERY cQuery NEW ALIAS "SE2X"

lOk := ( lNat1 .and. SE2X->QTD < 1 ) .OR. (lNat2 .and. SE2X->QTD < 2 )

if !lOk
   Alert( "O Limite de ("+Alltrim(Str(SE2X->QTD))+") Titulo(s) para essa natureza foi atingido." )
endif


SE2X->(DbCloseArea()) 


return lOk