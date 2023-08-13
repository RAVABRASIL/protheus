#include "rwmake.ch" 
#include "topconn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetModali ºAutor  ³Eurivan Marques     º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a modalidade no Edital a partir do numero do Pedido º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
User function GetModali(cPedido)
********************************

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

local cModal := "XX"
local cQuery

cQuery := "SELECT Z17_MODALI "
cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
cQuery += "JOIN "+RetSqlName("SZ5")+" SZ5 ON Z5_NUM=C6_PREPED "
cQuery += "AND  SZ5.D_E_L_E_T_!='*' "
cQuery += "JOIN "+RetSqlName("Z17")+" Z17 ON Z17_CODIGO=Z5_EDITAL "
cQuery += "AND  Z17.D_E_L_E_T_ != '*' "
cQuery += "WHERE C6_NUM = '"+cPedido+"' "
cQuery += "AND SC6.D_E_L_E_T_!='*' "
cQuery += "GROUP BY Z17_MODALI"

TCQUERY cQuery NEW ALIAS "_TMPP"
_TMPP->( dbGoTop() )

if ! _TMPP->( Eof() )
   cModal := _TMPP->Z17_MODALI
endif

DbCloseArea("_TMPP")

return cModal