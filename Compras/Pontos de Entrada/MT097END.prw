#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function MT097END() 

Local cQuery:=''
Local cDocto     := PARAMIXB[1]
Local cTipoDoc   := PARAMIXB[2]
Local nOpcao     := PARAMIXB[3]
Local cFilDoc    := PARAMIXB[4]
Local cUser      := __CUSERID
Local cTeste     := "" 
Local cPC        := SC7->C7_NUM 
Local aUsers     := {}						// Retorna vetor com informa��es do usu�rio
Local cNomeuser  := ""		// Nome do usu�rio aprovador
Local cMailuser  := ""     // e-mail do usu�rio aprovador
Local cDeptoAprov:= ""
Local cSolicitante := ""   // c�digo do solicitante
Local cNomeSolic   := ""   //nome do solicitante
Local cMailSolic   := ""   // email do solicitante
Local cSuperior  := ""  //c�digo superior do usu�rio
Private cEmpresa := SM0->M0_FILIAL
Private oHtml

IF nOpcao = 3

	If cTipoDoc <> "PC"
		//Msgalert("N�o Envia E-mail!")
		Return
	EndIf

	DLG := CHR(13) + CHR(10)
	eEmailG := "compras@ravaembalagens.com.br"      
	//eEmailG += ";romildo@ravaembalagens.com.br" //retirar
	//eEmailG += ";flavia.rocha@ravaembalagens.com.br" //retirar
	//eEmailG += ";flah.rocha@gmail.com"
	cMsgG := "O Pedido de Compra: " + SC7->C7_NUM + " foi BLOQUEADO:" + " na f�brica de " + cEmpresa + DLG
	cMsgG += DLG
	cMsgG += "C�digo do Fornecedor = " + SC7->C7_FORNECE + ", Nome do Fornecedor = " + posicione("SA2",1,xFilial('SA2') + SC7->C7_FORNECE,"A2_NOME") + DLG
	cMsgG += DLG								  

	cQuery := "SELECT CR_OBS FROM SCR020 WHERE CR_TIPO = " + "'" + cTipoDoc + "'" + " AND CR_NUM = " + DLG
	cQuery += "'" + SC7->C7_NUM + "' " + " AND CR_USER = " + "'" + cUser + "' " + "AND D_E_L_E_T_ <> '*' "
      
	If Select("XIT") > 0
		DbSelectArea("XIT")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "XIT"
	TcSetField("XIT", "CR_OBS", "C")

	cTeste := XIT->CR_OBS
	cMsgG += "A observa��o do Bloqueio �: " + cTeste
										  
	subjF := "Pedido de Compra BLOQUEADO pelo Aprovador"                   
	
	U_SendFatr11(eEmailG, "", subjF, cMsgG, "" )
	MsgInfo("Email enviado P/ Compras")

ENDIF

IF nOpcao = 2      //libera

	//If cTipoDoc <> "PC"
	//	Msgalert("N�o Envia E-mail!")
	//	Return
	//EndIf

	DLG := CHR(13) + CHR(10)
	IF ALLTRIM(SC7->C7_COND) = '003'
		eEmailG := "regina@ravaembalagens.com.br;deise@ravaembalagens.com.br;compras@ravaembalagens.com.br"
	ELSE
		eEmailG := "compras@ravaembalagens.com.br"
		//eEmailG += ";flavia.rocha@ravaembalagens.com.br" //retirar
		//eEmailG += ";flah.rocha@gmail.com"
	ENDIF
	cMsgG := "O Pedido de Compra: " + SC7->C7_NUM + " foi APROVADO:" + " na f�brica de " + cEmpresa + DLG
	cMsgG += DLG
	cMsgG += "C�digo do Fornecedor = " + SC7->C7_FORNECE + ", Nome do Fornecedor = " + posicione("SA2",1,xFilial('SA2') + SC7->C7_FORNECE,"A2_NOME") + DLG
	cMsgG += DLG
	cMsgG += "Condi��o de Pagamento desse Pedido �: " + SC7->C7_COND + " " + posicione("SE4",1,xFilial('SE4') + SC7->C7_COND,"E4_DESCRI") + DLG							  

	cQuery := "SELECT CR_OBS FROM SCR020 WHERE CR_TIPO = " + "'" + cTipoDoc + "'" + " AND CR_NUM = " + DLG
	cQuery += "'" + SC7->C7_NUM + "' " + " AND CR_USER = " + "'" + cUser + "' " + "AND D_E_L_E_T_ <> '*' "
      
	If Select("XIT") > 0
		DbSelectArea("XIT")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "XIT"
	TcSetField("XIT", "CR_OBS", "C")

	cTeste := XIT->CR_OBS
//	cMsgG += "A observa��o da Aprova��o �: " + cTeste
										  
	subjF := "Pedido de Compra APROVADO pelo Aprovador"                   
	
	U_SendFatr11(eEmailG, "", subjF, cMsgG, "" )
	MsgInfo("Email Enviado P/ Compras")
	
	
	//FR - 08/05/13
	//chamado 00000354
	//DO PRAZO DE ENTREGA: DESENVOLVER UM ALERTA POR EMAIL PARA O SOLICITANTE
	// SER INFORMADO DO PRAZO DE ENTREGA NO MOMENTO DA APROVA��O DO PEDIDO DE COMPRA
	oProcess:=TWFProcess():New("MTA097","MTA097")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\MTA097.htm")
	oHtml   := oProcess:oHtml
	cNumSC  := ""
	aSolicitante := {}    //c�digo solicitante
	cMailSolic   := ""    //email do solicitante
	SC7->(Dbsetorder(1))
	SC7->(Dbgotop())
	If SC7->(Dbseek(xFilial("SC7") + cPC  ))
		 	
		Do While SC7->(!EOF()) .AND. SC7->C7_FILIAL = xFilial("SC7") .AND. Alltrim(SC7->C7_NUM) = Alltrim(cPC) 
			    cNumSC := SC7->C7_NUMSC
			    SC1->(Dbsetorder(1))
			    If SC1->(Dbseek(xFilial("SC1") + cNumSC ))
			        Aadd(aSolicitante , SC1->C1_USER )    //localiza a SC para capturar o Solicitante (c�digo usu�rio)
			    Endif
			    
				aadd( oHtml:ValByName("it.cPC")     , SC7->C7_NUM )                                            
				aadd( oHtml:ValByName("it.cItem")     , SC7->C7_ITEM )                                            
			   	aadd( oHtml:ValByName("it.cProd") , SC7->C7_PRODUTO )    
			   	aadd( oHtml:ValByName("it.nQt")    , Str(SC7->C7_QUANT) )    
			   	aadd( oHtml:ValByName("it.nValUni" )   , Transform(SC7->C7_PRECO, "@E 999,999,999.99") ) 
			   	aadd( oHtml:ValByName("it.nValTot")     , Transform(SC7->C7_TOTAL , "@E 999,999,999.99") )       
			   	aadd( oHtml:ValByName("it.dPrev")     , DtoC(SC7->C7_DATPRF) )       
		   	DbSelectArea("SC7")
		    SC7->(Dbskip())
		enddo      
	Endif
	
	//cCodResp := __CUSERID
	cNomeuser  := ""		// Nome do usu�rio aprovador
	cMailuser  := ""     // e-mail do usu�rio aprovador
	cSolicitante := ""   // c�digo do solicitante
	cNomeSolic   := ""   //nome do solicitante
	cMailSolic   := ""   // email do solicitante
	PswOrder(1)
	If PswSeek( __CUSERID, .T. )
	   	aUsers := PSWRET() 						// Retorna vetor com informa��es do usu�rio
	   	//cCodUser  := Alltrim(aUsua[1][1])  	//c�digo do usu�rio no arq. senhas
	   	//cNomeuser := Alltrim(aUsers[1][2])		// Nome do usu�rio aprovador
	   	cNomeuser := Alltrim(aUsers[1][4])		// Nome completo do usu�rio aprovador
	   	cMailuser := Alltrim(aUsers[1][14])     // e-mail do usu�rio aprovador
		//cSuperior   := aUsers[1][11]  //superior do usu�rio
		cDeptoAprov:= aUsers[1][12]  //Depto do usu�rio aprovador
		///verifica o superior do usu�rio para enviar a ocorr�ncia com c�pia ao Superior dele
	   	//PswOrder(1)
	   	//If PswSeek(cSuperior, .t.)
		//   aSup := PswRet()
		//   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
		//   cMailSup := Alltrim( aSup[1][14])                //endere�o e-mail
	   //Endif
	
	Endif
	
	For x := 1 to Len(aSolicitante) 
		If PswSeek( aSolicitante[x], .T. )
			aUsers := PSWRET() 						// Retorna vetor com informa��es do usu�rio
	   		//cCodUser  := Alltrim(aUsua[1][1])  	//c�digo do usu�rio no arq. senhas
	   		//cNomeSolic := Alltrim(aUsers[1][2])		// Nome do usu�rio solicitante
	   		cNomeSolic := Alltrim(aUsers[1][4])		// Nome COMPLETO do usu�rio solicitante
	   		cMailSolic   := Alltrim(aUsers[1][14])     // e-mail do usu�rio solicitante		
	  	Endif
	Next                                                               
	//oHtml:ValByName("cSolicitante"  , cNomeSolic + " - email: " + cMailSolic )	//nome do solicitante
	oHtml:ValByName("cSolicitante"  , cNomeSolic )	//nome do solicitante
	oHtml:ValByName("cAprovador"    , cNomeuser )	//nome do aprovador
	oHtml:ValByName("cDepto"    , cDeptoAprov )	//nome do Depto
	oHtml:ValByName("cMailAprov"    , cMailuser )	//email do aprovador

	 eEmail := cMailuser + ";" + cMailSolic
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br"  //retirar
	 //eEmail += ";romildo@ravaembalagens.com.br"
	 //eEmail += ";flah.rocha@gmail.com"
	 oProcess:cTo := eEmail 
	 subj	:= "Pedido de Compra Aprovado - " + Alltrim(cPC)
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	 MsgInfo("Email Aprova��o Enviado p/ o Solicitante.") 

EndIf

Return