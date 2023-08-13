#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINC002   บAutor  ณEurivan Marques     บ Data ณ  08/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o % de bonus de uma comissao, de acordo com a quant. ฑฑ
ฑฑบ          ณde dias, a localidade e a modalidade do edital.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*************************************
user function FINC002(cPedido, nDias, nPrzEnt)
*************************************

local nPerc := 0
local cModal := U_GetModali(cPedido)

/*
01    	PREGAO PRESENCIAL                                      
02    	PREGAO ELETRONICO                                      
03    	CONCORRENCIA PUBLICA                                   
04    	TOMADA DE PRECO                                        
05    	CARTA CONVITE                                          
06    	DISPENSA DE LICITACAO                                  
07    	COTA ELETRONICA                                        
08    	ESTIMATIVA                                             
09    	ADESAO                                                 
10    	PRORROGACAO                                            
11    	ACRESCIMO                                              
12    	CONVITE ELETRONICO                                     
*/

if nDias <= ( 15 + nPrzEnt)

   if cModal $ "01/03/04" 
      nPerc := 2
   elseif cModal $ "05/06/09/10/11" 
      nPerc := 3                          
   elseif cModal $ "02/12" 
      //nPerc := 1
      //FR - Mudou Em 11/11/2010 Janderley passou nova lista de %
      nPerc := 2
   endif   
elseif ( nDias > (15 + nPrzEnt) ) .and. ( nDias <= (30 + nPrzEnt) )
   //if cModal $ "01/03/04/02"
   //FR - Mudou Em 11/11/2010 Janderley passou nova lista de % 
   if cModal $ "01/03/04" 
      //nPerc := 1
      nPerc := 1.5
      
   elseif cModal $ "05/06/09/10/11" 
      nPerc := 2
                                
   elseif cModal $ "12/02" 
      //nPerc := 0.5
      //FR - Mudou Em 11/11/2010 Janderley passou nova lista de %
      nPerc := 1.5
      
   endif        

elseif ( nDias >= (31 + nPrzEnt) ) .and. ( nDias <= (45 + nPrzEnt) )
   if cModal $ "01/03/04" 
      //nPerc := 0.5
      //FR - Mudou Em 11/11/2010 Janderley passou nova lista de %
      nPerc := 1
   
   elseif cModal $ "05/06/09/10/11" 
      nPerc := 1
      
   elseif cModal $ "12/02" 
      //nPerc := 0.25 
      //FR - Mudou Em 11/11/2010 Janderley passou nova lista de %
      nPerc := 1
   endif
              
elseif ( nDias > (45 + nPrzEnt) )    
      nPerc := 0   
endif

return nPerc

//a fun็ใo abaixo retorna o prazo mํnimo (em dias) de entrega para a capital da localidade passada como parametro
**********************************
User Function fPrazoMin( cUF )
**********************************

Local cQuery := ""
Local nPrazo := 0


/*
//antiga
cQuery := " SELECT ZZ_LOCAL,ZZ_DESC, MIN(ZZ_PRZENT) as PRAZO "
cQuery += " FROM " + RetSqlName("SZZ") + " SZZ "
cQuery += " WHERE ZZ_TIPO = 'C' AND ZZ_ATIVO != 'N' AND D_E_L_E_T_ = '' "
cQuery += " and RTRIM(ZZ_LOCAL) = '" + Alltrim(cLocal) + "' "
cQuery += " GROUP BY ZZ_LOCAL,ZZ_DESC "
cQuery += " ORDER BY ZZ_DESC "
*/

cQuery := " SELECT ZZ_LOCAL, ZZ_DESC, MIN(ZZ_PRZENT) PRAZO "
cQuery += " FROM " + RetSqlName("SZZ") + " SZZ, "
cQuery += " " + RetSqlName("SA4") + " SA4 "
cQuery += " WHERE ZZ_TIPO = 'C' AND ZZ_ATIVO != 'N'  "
cQuery += " AND ZZ_TRANSP = A4_COD AND A4_ATIVO != 'N' "
cQuery += " AND SUBSTRING(A4_VIA,1,1) != 'A' "
cquery += " AND ZZ_DESC LIKE '%("+Alltrim(cUF)+")%' "
cQuery += " AND SZZ.D_E_L_E_T_ = '' "
cQuery += " AND SA4.D_E_L_E_T_ = '' "
// 
cQuery += " AND SZZ.ZZ_FILIAL='"+XFILIAL('SZZ')+"' "
//
cQuery += " GROUP BY ZZ_LOCAL,ZZ_DESC "
cQuery += " ORDER BY ZZ_DESC "
//MemoWrite("C:\Temp\fprazomin.sql", cQuery )

If Select("PRZ") > 0
	DbSelectArea("PRZ")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "PRZ"

PRZ->( DbGoTop() )

Do While PRZ->( !EOF() )
	nPrazo := PRZ->PRAZO
	PRZ->(Dbskip())
Enddo


Return(nPrazo)
