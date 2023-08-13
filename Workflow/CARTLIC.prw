#include "rwmake.ch"
#include "TbiConn.ch"
//#include "TbiCode.ch"
#include "topconn.ch"

*************

User Function CARTLIC()

*************

conOut( "Iniciando programa CARTLIC - " + Dtoc( Date() ) + ' - ' + Time() )

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "CARTLIC" Tables "SC9", "SC6", "SC5", "SB1"
  sleep( 5000 )
  conOut( "Programa CARTLIC na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  EnviaEmail()
Else
  conOut( "Programa CARTLIC sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  EnviaEmail()
EndIf
conOut( "Finalizando programa CARTLIC em " + Dtoc( DATE() ) + ' - ' + Time() )

RETURN//main

***************

Static Function EnviaEmail()

***************

local lOk 		 := .F.
Local cQuery 	 := ''
Local x 		 := 1
Local _nX		 := 0
Local aCABC		 := {}
Local aCART		 := {}
private aABC 	 := {}
private cCliVip  := ''

U_ABC50(@aABC,@cCliVip) 

While x <= 2
	cQuery := "SELECT distinct SC6.C6_PREPED,SC5.C5_NUM, SC5.C5_ENTREG, SC5.C5_EMISSAO , SA1.A1_NOME, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) VAL_RS, sum(SC6.C6_QTDVEN/SB1.B1_CONV) VAL_KG, "
	cQuery += "SC5.C5_CLIENTE "
	cQuery += "FROM " +retSqlName('SB1')+ " SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9, "+retSqlName('SA1')+" SA1 "
	cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
	cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_CLIENTE +SC5.C5_LOJACLI = SA1.A1_COD +SA1.A1_LOJA  AND "
	cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//	cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
	cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
    cQuery += "C6_PREPED!='' AND " // INFORMACOES DOS PEDIDOS QUE FORAM GERADOS DO PRE-PEDIDO
	if x = 1
   		cQuery += "SC5.C5_CLIENTE IN ("+cCliVip+") AND "
	else
   		cQuery += "SC5.C5_CLIENTE NOT IN ("+cCliVip+") AND "   
	endif
	cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
	cQuery += "group by SC6.C6_PREPED,SC5.C5_NUM, SC5.C5_ENTREG, SC5.C5_EMISSAO, SA1.A1_NOME, SC5.C5_CLIENTE "
//	cQuery += "order by SC5.C5_NUM "
	cQuery := ChangeQuery( cQuery )
	if x == 1
		TCQUERY cQuery NEW ALIAS "CARX"
		CARX->( DbGoTop() )
		do while ! CARX->( EoF() )
			 
			 cMod  :=" "
			 cNredi:=" "
			 cDtabe:=" "
			 cOrgao:=" "
			 
		   	 dbSelectArea("SZ5") // POSICIONANDO NO PRE-PEDIDO
             dbSetOrder(1) 
			 if dbSeek(xFilial("SZ5")+CARX->C6_PREPED)
			 
			    dbSelectArea("Z17") // POSICIONANDO NO EDITAL
                dbSetOrder(1) 
			    dbSeek(xFilial("Z17")+SZ5->Z5_EDITAL)
			    cMod:=iif(alltrim(Z17->Z17_MODALI)  == '01', "PP",    iif( alltrim(Z17->Z17_MODALI) == '02', "PE" ,;
                      iif( alltrim(Z17->Z17_MODALI) == '03', "CP",    iif( alltrim(Z17->Z17_MODALI) == '04', "TP" ,;
                      iif(alltrim(Z17->Z17_MODALI)  == '05', "CC",    iif( alltrim(Z17->Z17_MODALI) == '06', "DL",;
	                  iif( alltrim(Z17->Z17_MODALI) == '07', "CE ",   iif( alltrim(Z17->Z17_MODALI) == '08', "EP",iif(alltrim(Z17->Z17_MODALI) =='09','AD',iif(alltrim(Z17->Z17_MODALI) =='10','PRO',iif(alltrim(Z17->Z17_MODALI) =='11','ACR',iif(alltrim(Z17->Z17_MODALI) =='12','CVE','')))) ) ) ) ) ) ) ) )
			    cNredi:=Z17->Z17_NREDIT
			    cDtabe:=Z17->Z17_DTABER
			    cOrgao:=Z17->Z17_LICITA
			 
			 Endif       
		 
			_nX := Ascan( aABC, {|x| x[2] == CARX->C5_CLIENTE } )
			aAdd( aCABC, { aABC[_nX][1], CARX->C5_NUM, CARX->C5_ENTREG, CARX->C5_EMISSAO, CARX->A1_NOME, CARX->VAL_RS, CARX->VAL_KG,;
								  CARX->C5_CLIENTE,cMod,cNredi,cDtabe,cOrgao  } )
			CARX->( dbSkip() )
		endDo
		aSort( aCABC, , , {|x,y| x[1] < y[1]  } )
		CARX->( dbCloseArea() )
	else
		TCQUERY cQuery NEW ALIAS "CARY"
		CARY->( DbGoTop() )
		do while ! CARY->( EoF() )
			 
			 cMod  :=" "
			 cNredi:=" "
			 cDtabe:=" "
			 cOrgao:=" "
			 
		 	 dbSelectArea("SZ5") // POISCIONANDO NO PRE-PEDIDO
             dbSetOrder(1) 
			 if dbSeek(xFilial("SZ5")+CARY->C6_PREPED)
			 
			    dbSelectArea("Z17")  // POSICIONADO NO EDITAL
                dbSetOrder(1) 
			    dbSeek(xFilial("Z17")+SZ5->Z5_EDITAL)
			    cMod:=iif(alltrim(Z17->Z17_MODALI)  == '01', "PP",    iif( alltrim(Z17->Z17_MODALI) == '02', "PE" ,;
                      iif( alltrim(Z17->Z17_MODALI) == '03', "CP",    iif( alltrim(Z17->Z17_MODALI) == '04', "TP" ,;
                      iif(alltrim(Z17->Z17_MODALI)  == '05', "CC",    iif( alltrim(Z17->Z17_MODALI) == '06', "DL",;
	                  iif( alltrim(Z17->Z17_MODALI) == '07', "CE ",   iif( alltrim(Z17->Z17_MODALI) == '08', "EP",iif(alltrim(Z17->Z17_MODALI) =='09','AD',iif(alltrim(Z17->Z17_MODALI) =='10','PRO',iif(alltrim(Z17->Z17_MODALI) =='11','ACR',iif(alltrim(Z17->Z17_MODALI) =='12','CVE','')))) ) ) ) ) ) ) ) )
			    cNredi:=Z17->Z17_NREDIT
			    cDtabe:=Z17->Z17_DTABER
			    cOrgao:=Z17->Z17_LICITA         
			 
			 Endif      
			
			aAdd( aCART, { 'XXX', CARY->C5_NUM, CARY->C5_ENTREG, CARY->C5_EMISSAO, CARY->A1_NOME, CARY->VAL_RS, CARY->VAL_KG,;
								  CARY->C5_CLIENTE,cMod,cNredi,cDtabe,cOrgao  } )
			CARY->( dbSkip() )
		endDo
		CARY->( dbCloseArea() )
	endIf
	x++
endDo

oProcess:=TWFProcess():New("CARTLIC","Carteira ABC/Normal")
oProcess:NewTask('Inicio',"\workflow\http\emp01\CARTLIC.htm")
oHtml   := oProcess:oHtml

for z := 1 to len(aCABC)
   aadd( oHtml:ValByName("it.pos") , 		 aCABC[z][1] 			                                             )
   aadd( oHtml:ValByName("it.num") , 		 aCABC[z][2] 			                                             )
   aadd( oHtml:ValByName("it.dtfatur"), 	 StoD( aCABC[z][3] )    						                     )
   aadd( oHtml:ValByName("it.dtdig"), 		 StoD( aCABC[z][4] )    						                     )
   aadd( oHtml:ValByName("it.dcart"), 		 alltrim( str( dDataBase - StoD( aCABC[z][3] ) ) )                   )
   aadd( oHtml:ValByName("it.cliente"),	     aCABC[z][5] 									                     )
   aadd( oHtml:ValByName("it.rs"), 		 	 transform( aCABC[z][6], "@E 999,999.99" )                           )
   aadd( oHtml:ValByName("it.kg"), 	         transform( aCABC[z][7], "@E 999,999.99" )                           ) 
   // INFORMACOES DO EDITAL 
   aadd( oHtml:ValByName("it.mod") , 		 aCABC[z][9] 									                     )
   aadd( oHtml:ValByName("it.Nedi") , 		 aCABC[z][10] 			                                             )
   aadd( oHtml:ValByName("it.dtaber") , 	 aCABC[z][11] 			                                             ) 
   aadd( oHtml:ValByName("it.orgao") , 		 alltrim(Posicione('Z15',1,xFilial("Z15")+aCABC[z][12],"Z15_NOMLIC")))
next

   aadd( oHtml:ValByName("it.pos") , 		 "----" )
   aadd( oHtml:ValByName("it.num") , 		 "----" )
   aadd( oHtml:ValByName("it.dtfatur"), 	 "----" )
   aadd( oHtml:ValByName("it.dtdig"), 		 "----" )
   aadd( oHtml:ValByName("it.dcart"), 		 "----" )   
   aadd( oHtml:ValByName("it.cliente"),	 	 "----" )
   aadd( oHtml:ValByName("it.rs"), 		 	 "----" )
   aadd( oHtml:ValByName("it.kg"), 	 		 "----" )

   aadd( oHtml:ValByName("it.mod") , 		 "----" )
   aadd( oHtml:ValByName("it.Nedi") , 		 "----" )
   aadd( oHtml:ValByName("it.dtaber") ,      "----" ) 
   aadd( oHtml:ValByName("it.orgao") , 	     "----" )

for z := 1 to len(aCART)
   aadd( oHtml:ValByName("it.pos") , 		 aCART[z][1] 		                                                	)
   aadd( oHtml:ValByName("it.num") , 		 aCART[z][2] 		                                                	)
   aadd( oHtml:ValByName("it.dtfatur"), 	 StoD( aCART[z][3] ) )
   aadd( oHtml:ValByName("it.dtdig"), 		 StoD( aCART[z][4] )                                                    )
   aadd( oHtml:ValByName("it.dcart"), 		 alltrim( str( dDataBase - StoD( aCART[z][3] ) ) )                      )      
   aadd( oHtml:ValByName("it.cliente"),	     aCART[z][5] 		                                                 	)
   aadd( oHtml:ValByName("it.rs"), 		 	 transform( aCART[z][6], "@E 999,999.99" )                              )
   aadd( oHtml:ValByName("it.kg"), 	         transform( aCART[z][7], "@E 999,999.99" )                              )
   //INFORMACOES DO EDITAL 
   aadd( oHtml:ValByName("it.mod") , 		 aCART[z][9] 			                                                )
   aadd( oHtml:ValByName("it.Nedi") , 		 aCART[z][10] 			                                                )
   aadd( oHtml:ValByName("it.dtaber") ,      aCART[z][11] 			                                                ) 
   aadd( oHtml:ValByName("it.orgao") , 		 alltrim(Posicione('Z15',1,xFilial("Z15")+aCART[z][12],"Z15_NOMLIC"))	)  

next

_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
oProcess:cTo	:= "licitacao@ravaembalagens.com.br" //;vendas.sp@ravaembalagens.com.br" //em 02/0/12 Flavia Viana solicitou retirar este email
//oProcess:cCC	:= "informatica@ravaembalagens.com.br"
subj	:= "Carteira cliente VIP e outros."
oProcess:cSubject  := subj
conOut( "Carteira ABC e Normal gerado em: " + Dtoc( DATE() ) + ' - ' + Time() )
oProcess:Start()
WfSendMail()
Sleep( 5000 )
oProcess:Finish()

return