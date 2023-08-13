#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WFFAT013                              º Data ³  23/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Pedidos Internet Incluídos em database - 1    º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pelo chamado 00000333 - Oziel                   º±±
±±º            Periodicidade: Diária                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

***************************
User Function WFFAT013()
***************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  conOut( "Programa WFFAT013 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  conOut( "Programa GPER013 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
 
  
Else
  conOut( "Programa WFFAT013 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT013 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***********************
Static Function Exec()
***********************


Local cQuery	:=' '
Local LF 		:= CHR(13) + CHR(10)
Local eEmail	:= ""
Local cEmpresa  := ""   
Local cNomeSetor:= ""
Local cHtm		:= "" 
Local cDirHTM   := ""    
Local cArqHTM   := "" 
//Local cMailRH   := GetMv("RV_GERRH")  
Local nHandle   := 0 
Private cCodFil	:= ""  
Private cDestina:= ""

cQuery:=" SELECT  " + LF 
cQuery += " ZC5_FILIAL, ZC5_NUMINT , SUM(ZC6_VALOR) AS TOTAL, A1_COD, A1_LOJA, A1_NOME, ZC5_EMISSA " + LF

cQuery += " From " + RetSqlName("ZC5") + " ZC5   " + LF
cQuery += " , " + RetSqlName("ZC6") + " ZC6 " + LF      
cQuery += " , " + RetSqlName("SA1") + " A1 " + LF      

cQuery += " WHERE ZC5.D_E_L_E_T_='' " + LF
cQuery += " AND   ZC6.D_E_L_E_T_='' " + LF
cQuery += " AND   A1.D_E_L_E_T_='' " + LF
cQuery += " AND ZC5_CLIENT = A1_COD " + LF
cQuery += " AND ZC5_LOJACL = A1_LOJA " + LF
cQuery += " AND ZC5_NUM    = ZC6_NUM " + LF
cQuery += " AND ZC5_FILIAL = ZC6_FILIAL " + LF
cQuery += " AND ZC5_FILIAL = '" + xFilial("ZC5") + "' " + LF
cQuery += " AND ZC5_EMISSA = '" + DTOS(dDatabase) + "' " + LF
cQuery += " AND ZC5_PV = '' " + LF //SEM PEDIDO VENDA GERADO AINDA
cQuery += " GROUP BY ZC5_FILIAL, ZC5_NUMINT , A1_COD, A1_LOJA, A1_NOME, ZC5_EMISSA " + LF
cQuery += " ORDER BY ZC5_FILIAL, ZC5_NUMINT  " + LF
MemoWrite("C:\Temp\WFFAT013.SQL",cQuery)

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUUX"
TcSetField("AUUX", "ZC5_EMISSA" , "D")
AUUX->(DbGoTop())

cCodFil	:= SM0->M0_CODFIL

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava - " + SM0->M0_FILIAL
Endif

cHtm := ""
If !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT013","WFFAT013")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFFAT013.htmL")
	oHtml   := oProcess:oHtml
	
	cDestina:= ""
	cDestina+= GetNewPar("MV_WFAT013","comercial@ravaembalagens.com.br<br>")    
	//cDestina+= "janaina@ravaembalagens.com.br<br>"
    //cDestina+= "amanda@ravaembalagens.com.br<br>"
	//cDestina+= "cecilia@ravaembalagens.com.br<br>"
	//cDestina+= "isaac.oliveira@ravaembalagens.com.br<br>"
	 
	//cDestina+= "flavia.rocha@ravaembalagens.com.br<br>" //retirar depois
	
	cCabeca := "Aviso de Novos Pedidos SFA"
	cMsg    := cDestina + '<br>'
	cMsg    += "Informamos que os Seguintes Pedidos Internet foram Incluídos em Nossa Base de Dados: "

	While AUUX->(!EOF())
	   	
		aadd( oHtml:ValByName("it.cNumint")     , AUUX->ZC5_NUMINT )                                            
		aadd( oHtml:ValByName("it.cCliente")     , AUUX->A1_COD + '/' + AUUX->A1_LOJA + '-' + AUUX->A1_NOME )                                            
		aadd( oHtml:ValByName("it.cFilial") , cEmpresa )    
		aadd( oHtml:ValByName("it.dDatainclu") , Dtoc(AUUX->ZC5_EMISSA) )    
		aadd( oHtml:ValByName("it.nTotPed")    , Transform( (AUUX->TOTAL) , "@E 9,999,999.99") )    
	
		AUUX->(Dbskip())
	Enddo      
			   	
	cNome  := ""		
	cMail  := ""     
	cDepto := ""
	cADMN  := '000000' //USUÁRIO ADMINISTRADOR
	PswOrder(1)
	If PswSeek( cADMN, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
	   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
	   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
		cDepto:= aUsers[1][12]  //Depto do usuário logado	
	Endif
	oHtml:ValByName("CABECA"  , cCabeca )	//título aviso
	oHtml:ValByName("cMSG"  , cMsg )	//texto do aviso	
	oHtml:ValByName("cUser"  , cNome )	//usuário logado que atualizou
	oHtml:ValByName("cDepto"    , cDepto )	//nome do Depto
	oHtml:ValByName("cMail"    , cMail )	//email
	
	 eEmail := ""
	 eEmail += "comercial@ravaembalagens.com.br"    
	 //eEmail += ";janaina@ravaembalagens.com.br"
	 //eEmail += ";amanda@ravaembalagens.com.br"
	 //eEmail += ";cecilia@ravaembalagens.com.br"
	 //eEmail += ";isaac.oliveira@ravaembalagens.com.br"
	 
	 eEmail += ";informatica@ravaembalagens.com.br" //retirar depois
	 oProcess:cTo := eEmail 
	 subj	:= "AVISO Pedidos SFA - " + cEmpresa
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
Endif 
AUUX->(DbCloseArea())

Reset Environment

Return

