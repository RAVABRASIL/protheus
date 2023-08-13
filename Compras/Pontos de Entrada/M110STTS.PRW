#INCLUDE "TOPCONN.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*
///////////////////////////////////////////////////////////////////////////////////
PONTO.......: M110STTS           PROGRAMA....: MATA110
DESCRIÇÄO...: APOS GRAVACAO DO SC1
UTILIZAÇÄO..: Executado apos gravacao da solicitação de compra, enviará e-mail para  
              o gestor responsável de acordo com o tipo de produto.
              000119-Nilton  AC/ME
			  000008-Jorge   CL/MH/MQ
			  000112-Michele ML/RM
			  000188-Regineide  GG/MC/MA
			  000003-Alexandre WFGERASC
PARAMETROS..: Nenhum
RETORNO.....: Nenhum
Autoria.....: Flávia Rocha
Data........: 13/08/2010
Alterado em : 10/02/2014 - Chamado: 00000590 - Abertura: 10/01/14 - 16:21:16
							Solicitante: ALINE FARIAS
////////////////////////////////////////////////////////////////////////////////////
*/ 


User Function M110STTS()

cArea    := GetArea()         // salva área do arquio atual
cAreaSC1 := SC1->(GetArea())  // salva área do arquivo SD1



If Inclui	
	
	U_MailSC(CA110NUM)		//se for inclusão, é necessário utilizar a chamada com a variável de memória
//Else	
	//U_MailSC(SC1->C1_NUM)	///se for alteração, pode-se chamar com o registro posicionado	
Endif

RestArea(cArea)            // restaura área do arquivo atual

Return

******************************************************
User Function MAILSC( cNumSC )
******************************************************

Local aSC 	:= {}
Local dEmissao	:= Ctod("  /  /    ")
Local _nX    	:= 0

Local aUsu		:= {} 
Local eEmail	:= ""
Local cCodUser  := ""	//código do usuário que está logado
Local cUserMail := ""   //irá armazenar o email do usuário logado
Local LF      	:= CHR(13)+CHR(10) 
Local aGestores := {} 
Local aGestores2:= {}
Local cMailGestor:= ""
Local cNomeGestor:= ""
Local cCodGestor := ""
Local cSolicitante:= ""  
Local cTiProd     := "" //tipo do produto



Local cCodUser := ""
Local cNomearray := ""
Local cPreManut  := GetMv("RV_110STTS") //tipos de produtos que precisam de pré-aprovação do ger. manutenção
Local cRespManut:= GetMv("RV_110BLO1")  //Codigo usuário responsável pela Manutenção -> 000008 - JORGE     
Local cMsgMail  := ""
Local cPREAPROV := "" //INDICA SE NO SB1 O PRODUTO JÁ É PRÉ-APROVADO
SetPrvt("OHTML,OPROCESS")


/////////////////////////////////////////////
////Informações do usuário que está logado...
cCodUser := __CUSERID

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cUserMail := Alltrim( aUsu[1][14] )     
Endif
////////////////////////////////////////////

///arrays de cada Gestor
aNilton		:= {}
aJorge		:= {}
aMichele	:= {}
aRegina		:= {}


Dbselectarea("SC1")
If SC1->(Dbseek(xFilial("SC1") + cNumSC ))


	
	dEmissao := SC1->C1_EMISSAO
	cSolicitante := SC1->C1_SOLICIT
	
	/*
	000119-Nilton  AC/ME
  	000008-Jorge   CL/MH/MQ
  	000112-Michele ML/RM
  	000188-Regineide  GG/MC/MA
  	000003-Alexandre WFGERASC
	*/
   	
   	
	While SC1->(!EOF())  .AND. SC1->C1_FILIAL == xFilial("SC1") .AND. SC1->C1_NUM == cNumSC

	    //FR - 29/08/13 - INCLUÍDO POR FLÁVIA ROCHA, SOLICITADO POR ORLEY
	    SB1->(Dbseek(xFilial("SB1") + SC1->C1_PRODUTO ))
	    cTiProd   := SB1->B1_TIPO
	    cPREAPROV := SB1->B1_PREAPRO //INDICA SE NO SB1 O PRODUTO JÁ É PRÉ-APROVADO, CASO SEJA, A SC JÁ "NASCE" APROVADA
	    
	    RecLock("SC1",.F.)             
  	    
        If Alltrim(cPREAPROV) != "S"
        	//Incluido por Eurivan - 14/11/10 -Toda SC ficara bloqueada na inclusao
//        	SC1->C1_APROV:='B' // Bloqueado
        Else                               
        	SC1->C1_APROV:='L' // Liberada
        Endif
        
        //FR - 29/08/13 - INCLUÍDO POR FLÁVIA ROCHA, SOLICITADO POR ORLEY
        //QUE TODO PRODUTO TIPO MH, MQ, AS SUAS SCs DEVERÃO SER PRE-APROVADAS POR JORGE
        //ANTES DE SEREM APROVADAS POR ORLEY      
        If (cTiprod $ cPreManut) .OR. (Substr(SC1->C1_PRODUTO,1,2) $ cPreManut )     
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        //se o tipo do produto está definido como passível de pre-aprovação do responsável Manutenção (Jorge)
        //FR - 31/10/13:
        //caso o produto começe com MQ / MH mas no B1_TIPO estiver diferente, faço a validação pelo
        //substr(C1_PRODUTO,1,2), pego as 2 primeiras posições pra saber se é MQ / MH
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        	
        	SC1->C1_PREAPRO := '*'   //aqui grava * para saber se precisa (*) pré-aprovação ou não (vazio)
        	
        	//envia email ao gerente manutenção
        	//captura o email do cRespManut
			aUsu := {}
			PswOrder(1)
			If PswSeek( cRespManut, .T. )
			   aUsu := PSWRET() 						// Retorna vetor com informações do usuário				  
			   eEmail := Alltrim( aUsu[1][14] )                                                 
			Endif
				
        	subj    := "Solicitação Pré-Aprovação de SC: " + SC1->C1_NUM + CHR(13) + CHR(10) //assunto 
			cMsgMail:= "Prezado(a) Gerente Manutenção, " + CHR(13) + CHR(10)
			cMsgMail+= "A Seguinte SC Necessita de Sua Pré-Aprovação SC: " + SC1->C1_NUM + "." + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
            cMsgMail+= "Por Favor, Acesse Módulo: Compras -> Atualizações -> Solicitações de Compra -> Ações Relacionadas: Pré-Aprovação."+ CHR(13) + CHR(10)
            cMsgMail+= "Qualquer Dúvida, Favor entrar em contato com Depto. TI "
            //eEmail += ";flavia.rocha@ravaembalagens.com.br" //retirar depois
			U_SendFatr11(eEmail, "", subj, cMsgMail, "" )
        Endif		
        
        SC1->(MsUnLock())
	
	
	
	       
			DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
				
				If Alltrim(SC1->C1_TPPROD) $ Alltrim(SX5->X5_DESCRI)
					cCodGestor := SX5->X5_CHAVE
				/*
				Elseif ( Alltrim(SC1->C1_TPPROD) != "AC" .and. Alltrim(SC1->C1_TPPROD) != "ME" .and. Alltrim(SC1->C1_TPPROD) != "CL" ;
				.and. Alltrim(SC1->C1_TPPROD) != "MH" .and. Alltrim(SC1->C1_TPPROD) != "MQ" .and. Alltrim(SC1->C1_TPPROD) != "ML";
				.and. Alltrim(SC1->C1_TPPROD) != "RM" .and. Alltrim(SC1->C1_TPPROD) != "GG" .and. Alltrim(SC1->C1_TPPROD) != "MC";
				.and. Alltrim(SC1->C1_TPPROD) != "MA" )
					//msgbox(SC1->C1_TPPROD)
					cCodGestor := "000003"
				*/
				Endif
				SX5->(Dbskip())
			Enddo
			
			If cCodGestor != ""
				PswOrder(1)
				If PswSeek( cCodGestor, .T. )
				   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
				   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
				   cNomeGestor := Alltrim(aUsu[1][2])		// Nome do usuário
				   cMailGestor := Alltrim( aUsu[1][14] )     
				Endif
				
				aAdd( aGestores2, { SC1->C1_ITEM,;		//1
				      			 SC1->C1_PRODUTO,;		//2
				      			 SC1->C1_TPPROD,;		//3
				       			 SC1->C1_DESCRI,;   	//4
				   			     SC1->C1_QUANT,;	  	//5
				   			     SC1->C1_OBS,;    		//6
				   			     SC1->C1_DATPRF,;		//7
				   			     cMailGestor ,;			//8
				   			     cNomeGestor,;			//9
				   			     SC1->C1_SOLICIT,;		//10
				   			     cCodGestor	})			//11
		    Endif
		    
			SC1->(DBSKIP())
			
		Enddo 

Endif 


//aGestores := { aNilton, aJorge, aMichele, aRegina }
If Len(aGestores2) > 0
	aGestores := Asort( aGestores2,,, { |X,Y| X[11] + X[1] <  Y[11] + Y[1] } ) 
Endif

_nX := 1

If Len(aGestores) > 0	
	
	While _nX  <= Len(aGestores)
	
		////CRIA O PROCESSO WORKFLOW
		oProcess:=TWFProcess():New("MAIL SC","NOVA SC")
		oProcess:NewTask('Inclusao SC',"\workflow\http\oficial\NovaSC_Aviso.html")
		oHtml := oProcess:oHtml
			
		//oHtml:ValByName("cSolicit", cSolicitante )
		
		oHtml:ValByName("cSC", cNumSC )
		oHtml:ValByName("dEmissao"  , Dtoc(dEmissao)  )  
		
		oProcess:cSubject:= "Nova Solicitação de Compra Incluída no sistema"
		
		cCodGestor := aGestores[_nX,11]
		
		Do while _nX <= Len(aGestores) .and. Alltrim(aGestores[_nX,11]) == Alltrim(cCodGestor)	
				      
			aadd( oHtml:ValByName("it.cItem")  , aGestores[_nX,1] )  					//ITEM
			aadd( oHtml:ValByName("it.cProd")  , aGestores[_nX,2] )  					//COD. PRODUTO
			aadd( oHtml:ValByName("it.cTipoProd")  , aGestores[_nX,3]) 					//TIPO PRODUTO
			aadd( oHtml:ValByName("it.cDesc")  , aGestores[_nX,4] )       				//DESCRIÇÃO PRODUTO
			aadd( oHtml:ValByName("it.nQtde") , aGestores[_nX,5] )     					//QTDE
			aadd( oHtml:ValByName("it.cObs"), aGestores[_nX,6] )         				//OBSERVAÇÃO
			aadd( oHtml:ValByName("it.dDatprf"), Dtoc( aGestores[_nX,7]) )	       		//NECESSIDADE
			cMailGestor		:= aGestores[_nX,8]	      
			cNomeGestor 	:= aGestores[_nX,9]
				      
			_nX++	      
		Enddo
		oHtml:ValByName("cNomeGestor", cNomeGestor )
		oHtml:ValByName("cMailGestor", cMailGestor )      //Nome do Gestor
		
		//oProcess:cTo:= cUserMail      //não precisa enviar ao solicitante
		oProcess:cTo:= cMailGestor
		//oProcess:cCC:= "flavia.rocha@ravaembalagens.com.br" 
		oProcess:cBCC:= ""
		oProcess:Start()
		WfSendMail()
					
	Enddo		
	
Endif


Return
