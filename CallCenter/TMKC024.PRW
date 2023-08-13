#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//--------------------------------
//Programa: Gera FeedBack - TMKC024.PRW
//Data    : 29/12/2010
//Autoria : Flávia Rocha
//Função  : TMKC024
//--------------------------------   


**********************************
User function TMKC024() 
**********************************

Private Titulo := "GERAÇÃO DE FEED_BACKs"

Pergunte("TMKC024",.T.)    //INFORME a NF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar a Ligação para NF --> " + MV_PAR01 + " ? " )
		//RptStatus({|| U_TMKC024A(MV_PAR01,MV_PAR02) },Titulo)      
		MsAguarde( {|| U_TMKC024A(MV_PAR01,MV_PAR02) }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gerando Ligação..." ) )
	Else
		MsgInfo("Rotina cancelada pelo Usuário.")
	Endif
	
Return


/*
Array aCab - Estrutura do SU4 para rotinas automaticas
ÚÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³01³ U4_FILIAL    ³ Filial  							  									         ³
³02³ U4_LISTA     ³ Codigo sequencial da lista                   									 ³
³03³ U4_DESC      ³ Descricao da lista                           									 ³
³04³ U4_DATA      ³ Data de vigencia   										                       	 ³
³05³ U4_TIPO      ³ Tipo de lista(1-Marketing / 2-Cobranca / 3- Vendas)                              ³
³06³ U4_FORMA     ³ Tipo de Contato (1-Voz/2-Fax/3-Cross Posting/4-Mala direta 5-Pendencia 6-WebSite)³
³07³ U4_TELE      ³ 1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)- USO INTERNO-8.11³
³08³ U4_OPERAD    ³ Operador																		 ³
³09³ U4_CONFIG    ³ Codigo da Configuracao Telemarketing											 ³
³10³ U4_TIPOTEL	  ³ Tipo de telefone( 1-Residencial/ 2-Celular/ 3-Fax/ 4-Comercial 1/ 5- Comercial 2)³
³11³ U4_MALADIR   ³ Arquivo de mala direta														   	 ³
³12³ U4_TIPOEND   ³ Endereco para mala direta														 ³
³13³ U4_LABEL     ³ Etiqueta (1-Sim / 2-Nao)  													   	 ³
³14³ U4_ETIQUET   ³ Arquivo de Etiqueta															     ³
³15³ U4_CODCAMP   ³ Codigo da campanha															     ³
³16³ U4_SCRIPT    ³ Codigo do script 															     ³
³17³ U4_EVENTO    ³ Codigo do evento 														     	 ³
ÀÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Array aItens - Estrutura do SU6 para rotinas automaticas
ÚÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³01³ U6_FILIAL    ³ Filial  							  	   ³
³02³ U6_LISTA     ³ Codigo sequencial da lista                 ³
³03³ U6_CODIGO    ³ Codigo da ligacao                          ³
³04³ U6_FILENT    ³ Filial da entidade 					       ³
³05³ U6_ENTIDA    ³ Entidade       						       ³
³06³ U6_CODENT    ³ Codigo da entidade                         ³
³07³ U6_ORIGEM    ³ Origem (1-Lista/ 2-Manual /3-Atendimento)  ³
³08³ U6_CONTATO   ³ Contato								       ³
³09³ U6_DATA      ³ Data                                       ³
³10³ U6_HRINI     ³ Hora inicial                               ³
³11³ U6_HRFIM     ³ Hora final                                 ³
³12³ U6_STATUS    ³ Status(1-Nao enviado /2- Em uso/ 3-Enviado)³
³13³ U6_CODLIG    ³ Codigo da ligacao efetuada                 ³
ÀÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/         
***********************************************   
User Function TMKC024A( MV_PAR01, MV_PAR02 ) 
***********************************************

Local aCab     := {}
Local aItens   := {}
Local aCabTrans:= {}
Local aItTrans := {}
Local lOk
Local lDireto  		:= .F.
Local lMais60  		:= .F.
Local lNovoCli 		:= .F.
Local lGeraLista 	:= .F. 
Local lGravalista	:= .F.
Local lGravaPos		:= .F.  

Local cCliente  := ""
Local cLoja	    := ""
Local cVendedor := ""
Local cCodContat:= ""
Local cLista	:= ""
Local cU4Codlig := ""
Local nLista    := 0 
Local cU6Codigo := ""
Local cU6Codlig := ""
Local cTransp	:= ""
Local cTrspAnt  := ""
Local cNFAnt    := ""
Local cSeriAnt  := ""
Local cNFCli	:= ""
Local cSeriNF	:= ""
Local cCliAntes := ""
Local cLjCliAn  := ""
Local cMsgPos   := "GEROU POS VENDAS"

Local cSeg1		:= '000009'		//Órgãos públicos
Local cSeg2		:= '000099'		//Representante RAVA
Local cSeg3		:= '000100'		//Transportadoras
Local cSeg4		:= '000101'		//Fornecedores
Local cQuery    := ""
Local dData1    := CtoD("  /  /    ")
Local dData2    := CtoD("  /  /    ")
Local dPrazoE   := CtoD("  /  /    ")
Local cRedesp   := "" 
Local cMsg      := ""
Local subj		:= ""
Local eEmail    := ""      
Local cCopia    := ""
Local cOper		:= GetNewPar("MV_XOPERTM","000018")

// Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"


cQuery := " SELECT F2_CLIENTE, F2_LOJA , F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP, F2_REALCHG "
cQuery += " FROM "+RetSqlName("SF2") +" SF2, " + RetSqlName("SA1")+" SA1 " 		
cQuery += " WHERE A1_COD = F2_CLIENTE "
cQuery += " AND A1_LOJA  = F2_LOJA "							
cQuery += " AND RTRIM(F2_DOC+F2_SERIE) = '" + Alltrim(MV_PAR01 + MV_PAR02) + "'  "
cQuery += " AND F2_TIPO = 'N' " 
cQuery += " AND F2_SERIE = '0' " 

cQuery += " AND SF2.D_E_L_E_T_ = '' and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
cQuery += " AND SA1.D_E_L_E_T_ = '' "
cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP , F2_REALCHG "
cQuery += " ORDER BY F2_DOC, F2_SERIE "

Memowrite("C:\Temp\GERA_FB.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TLM1") > 0
	DbSelectArea("TLM1")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLM1" 
TcSetField("TLM1", "F2_REALCHG" , "D" )
TLM1->(DbGoTop())

DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      
cLista    := GetSxENum("SU4","U4_LISTA")
//cLista :=  GETMV("RV_SEQPOSV")
//cSeqLista := Substr( cLista, 2, 5 )

while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end

If Empty(TLM1->F2_REALCHG)
	cU4Codlig := fMaxU4Lig()
	cU6Codlig := cU4Codlig
	//FeedBack-Cliente: 000233                                    
	Aadd(aCab,	{xFilial("SU4"),; 								//1->U4_FILIAL
				cLista,;                						//2->U4_LISTA
				cU4Codlig,;                						//3->U4_CODLIG
				"FeedBack-Cliente: " + Alltrim(MV_PAR01),; 		//4->U4_DESC -- Nome da lista + número da NF
				DataValida(dDatabase) ,;        //5->U4_DATA
				"1",;       					//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
				"1",;       					//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
				"1",;        					//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
				"4",;                           //9->U4_TIPOTEL
				"1",;     						//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
				Time(),;                        //11->U4_HORA1
				cOper })                     //12->U4_OPERAD
	
	cU6Codigo := fMaxU6Cod()
	cCliAntes := ""
	cLjCliAn  := ""
	cTransp	  := ""
	
	While !TLM1->(EOF())    
		   
		 
		   If ( TLM1->F2_DOC + TLM1->F2_SERIE ) == ( cNFAnt + cSeriAnt )
		   		TLM1->(Dbskip())
		   		Loop
		   Endif
		
		   cCliente := TLM1->F2_CLIENTE
		   cLoja    := TLM1->F2_LOJA
		   cEntida  := TLM1->( cCliente + cLoja )
		   cNFCli	:= TLM1->F2_DOC
	       cSeriNF	:= TLM1->F2_SERIE
	       cRedesp  := TLM1->F2_REDESP
	       cTransp  := TLM1->F2_TRANSP       
		      
	              
			   DbSelectArea("AC8")
			   DbSetOrder(2)   
			
			   If AC8->(DbSeek(xFilial("AC8")+"SA1"+"  "+ cEntida ))
			   		cCodContat := AC8->AC8_CODCON
			   Else
			   		SA1->(Dbsetorder(1))
			   		SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
				   		
			   		cCodContat		:= GETSX8NUM("SU5","U5_CODCONT")
			   		SU5->(Dbsetorder(1))
			   		If !SU5->(Dbseek(xFilial("SU5") + cCodContat ))
				   		RecLock("SU5", .T.)
			      		SU5->U5_FILIAL  := xFilial("SU5")
						SU5->U5_CLIENTE := cCliente
						SU5->U5_LOJA    := cLoja
			      		SU5->U5_CODCONT := cCodContat    		
			      		SU5->U5_CONTAT  := iif(!Empty(SA1->A1_CONTATO), SA1->A1_CONTATO, SA1->A1_NOME )
			      		SU5->U5_CELULAR := SA1->A1_CELULAR
			      		SU5->U5_DDD     := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,2,2) , SA1->A1_DDD )
			      		SU5->U5_EMAIL   := SA1->A1_EMAIL
			      		SU5->U5_FCOM1   := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,5,11), SA1->A1_TEL )
			      		SU5->U5_CPF		:= SA1->A1_CGC
			      		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			      		SU5->(MsUnlock())
			      		CONFIRMSX8()
			      		fCriaCont( "SA1", cCliente+cLoja , cCodContat )
			      	Else
			      		
			      		cCodContat := fMaxSU5()		      	
			      		SU5->(Dbsetorder(8))		//U5_FILIAL + U5_CPF
			      		
			      		If !SU5->(Dbseek(xFilial("SU5") + SA1->A1_CGC ))
				      		RecLock("SU5", .T.)
				      		SU5->U5_FILIAL  := xFilial("SU5")
							SU5->U5_CLIENTE := cCliente
							SU5->U5_LOJA    := cLoja
				      		SU5->U5_CODCONT := cCodContat    		
				      		SU5->U5_CONTAT  := iif(!Empty(SA1->A1_CONTATO), SA1->A1_CONTATO, SA1->A1_NOME )
				      		SU5->U5_CELULAR := SA1->A1_CELULAR
				      		SU5->U5_DDD     := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,2,2) , SA1->A1_DDD )
				      		SU5->U5_EMAIL   := SA1->A1_EMAIL
				      		SU5->U5_FCOM1   := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,5,11), SA1->A1_TEL )
				      		SU5->U5_CPF		:= SA1->A1_CGC
				      		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
				      		SU5->(MsUnlock())			      				      	
				      	Endif	
				      	fCriaCont( "SA1", cCliente+cLoja , cCodContat )   
			      	Endif	
			   Endif
			   	    
		                	    
		    	Aadd(aItens,{	xFilial("SU6") 	,;  	//1->U6_FILIAL
		                	 	cLista		   	,;  	//2->U6_LISTA
			   					cU6Codigo	  	,;  	//3->U6_CODIGO
		                		"SA1"          	,;  	//4->U6_ENTIDA
		                		cEntida        	,;  	//5->U6_CODENT
		                 		"1"            	,;  	//6->U6_ORIGEM
		                	 	cCodContat     	,; 		//7->U6_CONTATO
		                	 	cU6Codlig  		,;  	//8->U6_CODLIG
		                 		dDatabase		,; 		//9->U6_DATA
		                		Time() 			,; 		//10->U6_HRINI
		                		"23:59"			,;  	//11->U6_HRFIM
		                		"1"         	,;  	//12->U6_STATUS
		                	    cNFCli			,;  	//13->U6_NFISCAL
		                	    cSeriNF		    ,;      //14->U6_SERINF
		                	    "1"             ,;      //15->U6_TIPO       // 1=Marketing
		                	    cOper			,;	 	//16->U6_CODOPER	// 000006 - Daniela
		                	    cRedesp			,;		//17->U6_REDESP		//Transportadora em caso de redespacho
		                        cTransp			})		//18->U6_TRANSP
		                
		   If Len(aItens) > 0
		   		lGravaPos := .T.
		   Else
		   		Msgbox("Não Gerou a Ligação - vazio")
		   		//ConOut( "Tmkc002A- Array aItens vazio - sem itens Pos-Vendas " + Dtoc( Date() ) + ' - ' + Time() )
		   Endif	  
	       cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)   
	       cCliAntes := cCliente
	       cLjCliAn  := cLoja
	       cNFAnt    := cNFCli
	       cSeriAnt  := cSeriNF
	       
	   DbSelectArea("TLM1")
	   TLM1->(DbSkip())
	Enddo
	
	DbselectArea("TLM1")
	DbCloseArea("TLM1")
	
	If lGravaPos
	  
		For u4 := 1 to Len(aCab)
			Reclock("SU4",.T.)
			
			SU4->U4_FILIAL 		:= aCab[u4][1]
			SU4->U4_LISTA  		:= aCab[u4][2]
			SU4->U4_CODLIG  	:= aCab[u4][3]
			SU4->U4_DESC		:= aCab[u4][4]
			SU4->U4_DATA		:= aCab[u4][5]
			SU4->U4_TIPO		:= aCab[u4][6]
			SU4->U4_FORMA		:= aCab[u4][7]
			SU4->U4_TELE		:= aCab[u4][8]
			SU4->U4_TIPOTEL		:= aCab[u4][9]           
			SU4->U4_STATUS		:= aCab[u4][10]
			SU4->U4_HORA1		:= aCab[u4][11]
			SU4->U4_OPERAD		:= aCab[u4][12]
		   	
		   	SU4->(MsUnlock())
		   	CONFIRMSX8()
	    Next
	    
	    For u6 := 1 to Len(aItens)
	 		DbselectArea("SU6")
	    	SU6->(Dbsetorder(3))
	    	//If !SU6->(Dbseek(xFilial("SU6") + aItens[u6][13] + aItens[u6][14] ))
		    
		    	Reclock("SU6",.T.)
				SU6->U6_FILIAL	:= xFilial("SU6") //aItens[u6][1]
				SU6->U6_FILENT	:= aItens[u6][1]
			   	SU6->U6_LISTA	:= aItens[u6][2]
			   	SU6->U6_CODIGO  := aItens[u6][3]
			   	SU6->U6_ENTIDA	:= aItens[u6][4]
			   	SU6->U6_CODENT	:= aItens[u6][5]  
			   	SU6->U6_ORIGEM	:= aItens[u6][6]            	//1=Lista 2=Manual 3=Atendimento
			   	SU6->U6_CONTATO	:= aItens[u6][7]
			   	SU6->U6_CODLIG	:= aItens[u6][8]         
			   	SU6->U6_DATA	:= aItens[u6][9]
			   	SU6->U6_HRINI	:= aItens[u6][10] 
			   	SU6->U6_HRFIM	:= aItens[u6][11]   
			   	SU6->U6_STATUS	:= aItens[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado	   
			   	SU6->U6_NFISCAL := aItens[u6][13]
			   	SU6->U6_SERINF	:= aItens[u6][14]
			   	SU6->U6_TIPO    := aItens[u6][15]
			   	SU6->U6_CODOPER := aItens[u6][16]
			   	SU6->U6_REDESP  := aItens[u6][17]
			   	SU6->U6_TRANSP  := aItens[u6][18]
			   	SU6->(MsUnlock())	   	
		    
		    	MsgInfo("LIGAÇÃO GERADA....Por Favor, Agora, Acesse a Agenda do Operador para criar o Atendimento. Obrigado(a).","Informação")
		    	cMsg   := "SAC - Ligação Criada - Filial: " + xFilial("SU4") + CHR(13) + CHR(10)
				cMsg   += "NF / SERIE: " + MV_PAR01 + '/' + MV_PAR02 + CHR(13) + CHR(10)
				cMsg   += "Data: " + Dtoc(Date()) + CHR(13) + CHR(10)
				cMsg   += "Hora: " + Time() + CHR(13) + CHR(10)
				cMsg   += "User: " + Substr(cUsuario,7,15) + CHR(13) + CHR(10)
				eEmail := "sac@ravaembalagens.com.br"  //"daniela@ravaembalagens.com.br"
				cCopia := ""//"flavia.rocha@ravaembalagens.com.br"
				subj   := "SAC - Ligação Criada - Filial: " + xFilial("SU4")
				U_SendFatr11(eEmail, cCopia, subj, cMsg, "" )
						
	    
	    Next
	    
	    
	Else
	    MsgInfo("Sem dados para gerar Ligação","Informação")
	    //MemoWrite("\Temp\POSV-" + Dtos( dDatabase) + ".TXT","Sem dados para gerar pos-vendas.")
	    ROLLBACKSX8()
	Endif
	
Else
	MsgInfo("Esta NF já tem sua Data REAL CHEGADA Confirmada, e NÃO PODERÁ SER GERADA LIGAÇÃO. Favor Comunicar o Administrador do Sistema.")
Endif

////////////////////////////////////////////////Fim parte Pós-Vendas

// Habilitar somente para Schedule
//Reset environment

Return

**************************************
Static Function fMaxU6Cod()     
**************************************

Local cQry 		:= "" 
Local cMaxU6 	:= ""


cQry := " SELECT MAX(U6_CODIGO) as U6_CODIGO "
cQry += " FROM " + RetSqlname("SU6") + " SU6 "
cQry += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQry += " AND SU6.D_E_L_E_T_ <>'*' "
Memowrite("\Temp\MAX_U6.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU6") > 0
	DbSelectArea("MAXU6")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU6" 

MAXU6->(DbGoTop())

While !MAXU6->(EOF())
    cMaxU6 := MAXU6->U6_CODIGO
	MAXU6->(DBSKIP())
Enddo

cMaxU6 := Strzero(Val( cMaxU6 ) + 1,6)

DbCloseArea("MAXU6")

Return(cMaxU6)

**************************************
Static Function fMaxU4Lig()     
**************************************

Local cQry 		:= "" 
Local cMaxU4 	:= ""


cQry := " SELECT MAX(U4_CODLIG) as U4_CODLIG "
cQry += " FROM " + RetSqlname("SU4") + " SU4 "
cQry += " WHERE U4_FILIAL = '" + xFilial("SU4") + "' "
cQry += " AND SU4.D_E_L_E_T_ <>'*' "
//Memowrite("\Temp\MAX_U4.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU4") > 0
	DbSelectArea("MAXU4")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU4" 

MAXU4->(DbGoTop())

While !MAXU4->(EOF())
    cMaxU4 := MAXU4->U4_CODLIG
	MAXU4->(DBSKIP())
Enddo

cMaxU4 := Strzero(Val(cMaxU4) + 1,6)

DbCloseArea("MAXU4")

Return(cMaxU4)


**************************************
Static Function fMaxSU5()     
**************************************

Local cQry 		:= "" 
Local cMaxU5 	:= ""


cQry := " SELECT MAX(U5_CODCONT) as U5_CODCONT "
cQry += " FROM " + RetSqlname("SU5") + " SU5 "
cQry += " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
cQry += " AND SU5.D_E_L_E_T_ <>'*' "
//Memowrite("\Temp\MAX_U5.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU5") > 0
	DbSelectArea("MAXU5")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU5" 

MAXU5->(DbGoTop())

While !MAXU5->(EOF())
    cMaxU5 := MAXU5->U5_CODCONT
	MAXU5->(DBSKIP())
Enddo

cMaxU5 := Strzero(Val(cMaxU5) + 1,6)

DbCloseArea("MAXU5")

Return(cMaxU5)




*******************************************************
static function fCriaCont( cEntidade, cCodEnt, cCodCon )
*******************************************************

DbselectArea("AC8")
RecLock("AC8", .T.)
AC8->AC8_ENTIDA := cEntidade
AC8->AC8_CODENT := cCodEnt
AC8->AC8_CODCON := cCodCon
AC8->(MSUnLock())

return     
******************************************//FIM




