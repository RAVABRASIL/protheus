#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
Programa: MT120FIM - Ponto de entrada após gravar o pedido de compra
Autoria : Flávia Rocha
Data    : 18/02/11
Objetivo: Ao final do Pedido, gravar o campo NCM do PC no cadastro de produtos SB1

*/

*************************
User Function MT120FIM()
*************************


//Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario 

Local cNumPC := PARAMIXB[2]   // Numero do Pedido de Compras
Local cFornece   := ""
Local cLojFor	 := ""
Local cNomeFor   := ""
Local nUltPreco  := 0
Local lMaiorPrc	 := .F.
Local LF		 := CHR(13) + CHR(10)  
Local lMaiorPrc	 := .F.
Local nRecOC	 := 0	 

Private aPC		 := {}
Private cCoduser := __CUSERID

//Local nOpcA  := PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.

//MSGBOX("PEDIDO: " + PARAMIXB[2]) 

cQuery := " select top 1 C7_NUM, R_E_C_N_O_ AS REGISTRO, * " + LF
cQuery += "  from " + LF
cQuery += " " + RetSqlName("SC7") + " SC7 " + LF
        
cQuery += " where C7_NUM = '" + Alltrim( cNumPC ) + "' " + LF
      
cQuery += " and C7_FILIAL = '" + xFilial("SC7") + "' " + LF
cQuery += " and SC7.D_E_L_E_T_ = '' " + LF
cQuery += " Order by R_E_C_N_O_ " + LF
        
MemoWrite("C:\Temp\RECSC7.sql", cQuery)
If Select("SC7XX") > 0
	DbSelectArea("SC7XX")
	DbCloseArea()
EndIf
	
TCQUERY cQuery NEW ALIAS "SC7XX"
TCSetField( 'SC7XX', "C7_EMISSAO", "D" )
	
SC7XX->( DBGoTop() )
Do While !SC7XX->( Eof() )
    nRecOC		:= SC7XX->REGISTRO
	cNumPC		:= SC7XX->C7_NUM
				
	DbselectArea("SC7XX")
	SC7XX->(Dbskip())
Enddo
 
//SC7->(Dbsetorder(1))
//If SC7->(Dbseek(xFilial("SC7") + cNumPC )) 
DbselectArea("SC7")
If nRecOC > 0
	DbgoTo(nRecOC)

 	While SC7->(!EOF()) .AND. xFilial("SC7") == SC7->C7_FILIAL .AND. SC7->C7_NUM == cNumPC
    	//MSGBOX("ENTROU NO SC7")
    	
		///Chamado 001964 - Flávia Rocha 03/02/11
		///atualiza o cadastro de produtos com a NCM (Classificação Fiscal)		
		SB1->(Dbsetorder(1))
		    
		If SB1->(Dbseek(xFilial("SB1") + SC7->C7_PRODUTO ))
		   	RecLock("SB1",.F.)
		   	SB1->B1_POSIPI := SC7->C7_NCM
		   	SB1->(MsUnlock())    	
		Endif
		
		If Inclui
		
			////localiza último preço de compra
			///LOCALIZA SC7
		    cQuery := " select top 1 C7_PRODUTO, C7_PRECO, C7_FORNECE,C7_LOJA, A2_COD,A2_LOJA,A2_NOME " + LF
		    cQuery += "  from " + LF
		    cQuery += " " + RetSqlName("SC7") + " SC7, " + LF
		    cQuery += " " + RetSqlName("SA2") + " SA2 " + LF
		    
		    cQuery += " where C7_PRODUTO = '" + Alltrim( SC7->C7_PRODUTO ) + "' " + LF
		    cQuery += " and C7_PRODUTO <> 'ST0178' " + LF
		    cQuery += " and C7_NUM <> '" + Alltrim(cNumPC) + "' " + LF    //exceto o próprio PC incluído agora
		    
		    cQuery += " and (C7_FORNECE + C7_LOJA) = (A2_COD + A2_LOJA) " + LF
		    cQuery += " and C7_FILIAL = '" + xFilial("SC7") + "' " + LF
		    cQuery += " and SC7.D_E_L_E_T_ = '' " + LF
		    cQuery += " and SA2.D_E_L_E_T_ = '' " + LF
		    cQuery += " Order by C7_PRECO DESC " + LF
		        
		    MemoWrite("C:\Temp\PRECOSC7.sql", cQuery)
		    If Select("SC7XX") > 0
				DbSelectArea("SC7XX")
				DbCloseArea()
			EndIf
			
			TCQUERY cQuery NEW ALIAS "SC7XX"
			TCSetField( 'SC7XX', "C7_EMISSAO", "D" )
			
			SC7XX->( DBGoTop() )
			If !SC7XX->(EOF())
				Do While !SC7XX->( Eof() )
				
					cFornece   := SC7XX->C7_FORNECE
					cLojFor	   := SC7XX->C7_LOJA
					cNomeFor   := SC7XX->A2_NOME
					nUltPreco  := SC7XX->C7_PRECO
				
						
					DbselectArea("SC7XX")
					SC7XX->(Dbskip())
				Enddo
				
				If SC7->C7_PRECO > nUltPreco
					//msgbox("preço maior")
					RecLock("SC7",.F.)
			   		SC7->C7_MAIORVL := "S"
			   		SC7->(MsUnlock())				
					lMaiorPrc := .T.		
					aAdd(aPC, {SC7->C7_NUM, SC7->C7_PRODUTO, SC7->C7_ITEM, SC7->C7_QUANT, SC7->C7_PRECO, nUltPreco, SC7->C7_EMISSAO, cNomeFor } )
				Endif
				
			Endif 
			
		Endif   //endif do if inclui 
		
		SC7->(DBSKIP())
	 Enddo
 
	 If Inclui
		 If lMaiorPrc
		 	U_fEnvPRCMAIOR(aPC)
		 Endif
	 Endif
	 
Endif
 
 	

Return                 

***********************************
User Function fEnvPRCMAIOR(aPC)
***********************************

Local cDesc 	:= "" 
Local _nX 		:= 0 
Local aUsu	   	:= {} 
Local eEmail	:= ""
Local cUsu		:= ""

//MSGBOX("CAIU NA FUNÇAO DO HTML")

SetPrvt("OHTML,OPROCESS")

//aAdd(aOP, {cOPRD, SC2->C2_PRODUTO, SC2->C2_QUANT, SC2->C2_QUJE } )

// Inicialize a classe de processo:
oProcess:=TWFProcess():New("SIGACOM","Compras")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\Prc_Maior.htm")
oHtml   := oProcess:oHtml

//msgbox("envia html")

PswOrder(1)
If PswSeek( cCodUser, .T. )     
  
	aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
	//cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário 
	cUsu   := Alltrim( aUsu[1][4] )      //Nome completo do usuário 
	eEmail := Alltrim( aUsu[1][14] )     //E-mail do usuário (que incluiu o PC)
	//cSup	  := aUsu[1][11]             //código do usuário superior 
   ///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   /*
   PswOrder(1)
   If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif
   */
   
Endif

oHtml:ValByName("cPC"  , Substr(aPC[1][1] ,1,6) )
oHtml:ValByName("dEmissao"  , DtoC( aPC[1][7] ) )
oHtml:ValByName("cUsuario"  , cUsu )
oHtml:ValByName("cNomeFor"  , aPC[1][8] )


//aAdd(aPC, {SC7->C7_NUM, SC7->C7_PRODUTO, SC7->C7_ITEM, SC7->C7_QUANT, SC7->C7_PRECO, nUltPreco, SC7->C7_EMISSAO, cNomeFor } )
//               1           2                   3           4                5            6             7             8
For _nX := 1 to Len(aPC)

	aadd( oHtml:ValByName("it.cITEM")  ,  aPC[_nX,3] )
	aadd( oHtml:ValByName("it.cPROD")  ,  aPC[_nX,2] )
		
	SB1->(Dbsetorder(1))
	If SB1->(Dbseek(xFilial("SB1") + aPC[_nX,2] ) )
		cDesc := SB1->B1_DESC
	Endif
      
   aadd( oHtml:ValByName("it.cDESC")  ,  cDesc     )	
   aadd( oHtml:ValByName("it.nQTDE"), Transform(aPC[_nX,4], "@E 99,999,999.99")  )
   aadd( oHtml:ValByName("it.nPRECO") , Transform(aPC[_nX,5], "@E 99,999,999.99") )
   aadd( oHtml:ValByName("it.nPRECOANT"), Transform( aPC[_nX,6], "@E 99,999,999.99")  )
   
Next _nX


//oProcess:cTo      := "flavia.rocha@ravaembalagens.com.br"
oProcess:cTo      :=  "marcelo@ravaembalagens.com.br"
oProcess:cTo      +=  "rodrigo.pereira@ravaembalagens.com.br"
oProcess:cCC	  := eEmail    //e-mail do comprador
//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"
oProcess:cSubject := "Pedido de Compra - Preço maior que último praticado"

// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
oProcess:Start()

WfSendMail()
//MSGINFO("EMAIL ENVIADO")

Return