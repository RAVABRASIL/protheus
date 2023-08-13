#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//--------------------------------
//Programa: GERALISTA-2.PRW
//Data    : 05/10/09
//Autoria : Flávia Rocha
//Função  : TMKC002
//--------------------------------

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
   



**********************************************************
User function TMKC002A()
**********************************************************        

	// Habilitar somente para Schedule
	
	RPCSetType( 3 )
  	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"    //sacos
  	sleep( 5000 )	

	conout(Replicate("*",60))
	conout("Gera Pos-Vendas - INICIO")
	conout("TMKC002A - Lista Pos-Vendas - Emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
	conout(Replicate("*",60))
	
	Gera_PosV()     // ASISTENTE-000006-UF-'AL','CE','PE','SE','AC','AM','RO','TO','PA','RR','MS','MT','ES','PR','RS','SC' 
    
   // Gera_PosVR()	// ASISTENTE-000016-UF- 'BA','MA','PB','PI','RN','AP','DF','GO','SP','MG','RJ'
	
	Reset Environment
	
	//Habilitar somente para Schedule
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06"      //NOVA
	sleep( 5000 )
		
	conout(Replicate("*",60))
	conout("Gera Pos-Vendas - NOVA - INICIO")
	conout("LISTAPOSCX - Lista Pos-Vendas - Emp. 02 filial 06 " + Dtoc( Date() ) + ' - ' + Time() )
	conout(Replicate("*",60))
	
	Gera_PosV()	
	
	//Gera_PosVR()
	Reset Environment

	//Habilitar somente para Schedule
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "07"      //TOTAL
	sleep( 5000 )
		
	conout(Replicate("*",60))
	conout("Gera Pos-Vendas - TOTAL - INICIO")
	conout("LISTAPOSCX - Lista Pos-Vendas - Emp. 02 filial 07 " + Dtoc( Date() ) + ' - ' + Time() )
	conout(Replicate("*",60))
	
	Gera_PosV()	
	
	//Gera_PosVR()
	Reset Environment
	*/
Return


	
***************************
Static Function Gera_PosV()	
*************************** 

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
Local cMsgTrans := "GEROU LISTA TRANSP"
Local cSeg1		:= '000009'		//Órgãos públicos
Local cSeg2		:= '000099'		//Representante RAVA
Local cSeg3		:= '000100'		//Transportadoras
Local cSeg4		:= '000101'		//Fornecedores
Local cQuery    := ""
Local dData1    := CtoD("  /  /    ")
Local dData2    := CtoD("  /  /    ")
Local dPrazoE   := CtoD("  /  /    ")
Local cRedesp   := ""
Local LF		:= CHR(13) + CHR(10)
Local cOper		:= GetNewPar("MV_XOPERTM","000018")

// Habilitar somente para Schedule
/*
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

conout(Replicate("*",60))
conout("Gera Pos-Vendas - INICIO")
conout("TMKC002A - Lista Pos-Vendas - Emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))
*/
//LISTA PÓS-VENDAS:
	
//Em 27/10/09 - Foi Definido:
//Esta query seleciona as notas que estão com previsao de chegada com data anterior a data que está sendo executado o programa
// (dDatabase - 1) para que o operador ligue para os clientes para confirmar o recebimento.

//Parte 1 - seleciona clientes para lista Pós-Vendas

cQuery := "SELECT F2_CLIENTE, F2_LOJA , F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP, F2_PREVCHG, A4_CODCLIE " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SF2") +" SF2, " + LF
cQuery += " " + RetSqlName("SD2") +" SD2, " + LF
cQuery += " " + RetSqlName("SA1")+" SA1 "  + LF

//FR - 18/05/2011 - NFs de ressarcimento para Transportadora, não entram na lista pós-vendas
cQuery += " LEFT OUTER JOIN "
cQuery += " " + RetSqlName("SA4") + " SA4 " + LF
cQuery += " on SA1.A1_COD IN (SA4.A4_CODCLIE) AND SA4.A4_CODCLIE IS NULL " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SA4.D_E_L_E_T_ = '' " + LF
//até aqui

cQuery += " WHERE A1_COD = F2_CLIENTE " + LF
cQuery += " AND A1_LOJA  = F2_LOJA " + LF
cQuery += " and SA1.A1_CGC NOT LIKE ('28924778%') " + LF     //exceto notas da RAVA para RAVA
cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE) " + LF
cQuery += " AND F2_FILIAL  = D2_FILIAL  " + LF

cQuery += " AND F2_PREVCHG >= '" +Dtos(dDataBase-1) + "' AND F2_PREVCHG <=  '" + Dtos(dDataBase-1) + "' " + LF
cQuery += " AND F2_REALCHG = '' "
// UF DO ASSISTNTE  - 000006
//cQuery += " AND F2_EST IN('AL','CE','PE','SE','AC','AM','RO','TO','PA','RR','MS','MT','ES','PR','RS','SC')  " + LF


//cQuery += " AND F2_DTEXP >= '20140509' " + LF
//cQuery += " AND F2_DOC NOT IN ( '000035517','000035532','000035577','000003809','000003811') " + LF
//cQuery += " AND F2_CLIENTE <> '031248' "	 + LF	//MIX-KIT logística por enquanto é para gerar sim.

cQuery += " AND F2_TIPO = 'N' " + LF
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
//Filtrar as NF's que não são de mercadorias para clientes da lista de ligações do SAC (excluir remessa venda ordem e para conserto)
//FR - 25/07/2011 - POR SOLICITAÇÃO DE DANIELA, voltar a geração da lista para as notas Conta e Ordem (Tes 535) E EXCLUIR TES AMOSTRA
cQuery += " AND D2_TES NOT IN ( '502' , '516', '507' , '543' , '547', '528' , '504' , '619' , '578', '603' ) " + LF  
//FR - 26/03/2012 - retirar da geração , as notas de amostra (TES acima)
//FR - 04/04/12 - retirar TES 504 - simples remessa
//FR - 04/04/12 - retirar TES 528 - cta e ordem
//FR - 15/01/13 - retirar TES 619 - ressarcimento 
//FR - 18/02/13 - retirar TES 578 - remessa comodato
//FR - 12/05/14 - retirar TES 603 - VENDAS MERC ADQ TERC
														
cQuery += " AND F2_TRANSP <> '024'  " + LF
//cQuery += " AND F2_TRANSP <> '025'  " + LF

cQuery += " AND F2_CLIENTE <> '001588' " + LF        //Clientes que compram aparas
cQuery += " AND F2_CLIENTE <> '002655' " + LF
cQuery += " AND F2_CLIENTE <> '001276' " + LF

//cQuery += " AND A1_ATIVO <> 'N' "		 + LF //Por solicitação de Daniela e Aprovação de Eurivan, retirei esta cláusula - 24/02/10
//cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' "  + LF 

cQuery += " AND A1_SATIV1 <> '" + cSeg2 + "' " + LF
cQuery += " AND A1_SATIV1 <> '" + cSeg3 + "' " + LF
cQuery += " AND A1_SATIV1 <> '" + cSeg4 + "' " + LF

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' " + LF

cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP, F2_PREVCHG, A4_CODCLIE " + LF
cQuery += " ORDER BY F2_DOC, F2_SERIE " + LF

Memowrite("C:\Temp\POSV-" + Dtos( dDatabase) + ".SQL",cQuery)
//Memowrite("C:\POSV-" + Dtos( dDatabase) + ".SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TLM1") > 0
	DbSelectArea("TLM1")
	DbCloseArea()	
EndIf

//conout(cQuery)

TCQUERY cQuery NEW ALIAS "TLM1" 

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
  
cU4Codlig := fMaxU4Lig()
cU6Codlig := cU4Codlig

Aadd(aCab,	{xFilial("SU4"),; 				//1->U4_FILIAL
			cLista,;                		//2->U4_LISTA
			cU4Codlig,;                		//3->U4_CODLIG
			"PREV. ENTREGA: " + cLista,; //4->U4_DESC
			DataValida(dDatabase) ,;        //5->U4_DATA
			"1",;       					//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
			"1",;       					//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
			"1",;        					//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
			"4",;                           //9->U4_TIPOTEL
			"1",;     						//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
			Time(),;                        //11->U4_HORA1
			cOper } ) //"000017"					
			//Jan/2011- entrada da Mariana como operador, deixar operador em branco, para Daniela e Mariana visualizarem
			
			
			//"" })                     //12->U4_OPERAD
			//Operador em Branco -> todos os operadores visualizam as listas

cU6Codigo := fMaxU6Cod()
cCliAntes := ""
cLjCliAn  := ""
cTransp	  := ""

While !TLM1->(EOF())    
	   
	   //Em 13/01/10 - Durante a Conferência com Marcelo, Eurivan e Daniela, foi solicitado que a lista seja gerada 
	   //por NF e não somente por Cliente, para que os feed-backs sejam criados por NF também.
	   
	   /*
	   If ( TLM1->F2_CLIENTE + TLM1->F2_LOJA ) == ( cCliAntes + cLjCliAn )
	   		TLM1->(Dbskip())
	   		Loop
	   Endif
	   */
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
	                	    cOper			,;	 	//16->U6_CODOPER	// 000017 - Pablo
	                	    cRedesp			,;		//17->U6_REDESP		//Transportadora em caso de redespacho
	                        cTransp			})		//18->U6_TRANSP
	                
	   If Len(aItens) > 0
	   		lGravaPos := .T.
	   Else
	   		//Msgbox("Array aItens - Pós_Vendas - vazio")
	   		ConOut( "Tmkc002A- Array aItens vazio - sem itens Pos-Vendas " + Dtoc( Date() ) + ' - ' + Time() )
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
cMsg := ""
eEmail := ""
subj    := ""
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
    
    //PutMV( "RV_SEQPOSV" , "P" + StrZero(VAL(SUBSTR( cSeqLista ,2,5)) + 1 ,5) )
    
    For u6 := 1 to Len(aItens)
    	If !SU6->(Dbseek(xFilial("SU6") + aItens[u6][13] + aItens[u6][14] ))
	    	Reclock("SU6",.T.)
			SU6->U6_FILIAL	:= xFilial("SU6")
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
		//Else
		//	msgbox("Encontrou a nf: " + aItens[u6][13] )
		Endif	   		   	
    Next 
    //MsgInfo("Lista Pós-Vendas gerada","Informação")
    //MemoWrite("\Temp\POSV-" + Dtos( dDatabase) + ".TXT", cMsgPos )
    cMsg   := "Lista pos-vendas gerada - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	//eEmail := "gustavo@ravaembalagens.com.br"
    eEmail := "sac@ravaembalagens.com.br; gustavo@ravaembalagens.com.br"	
	subj   := "Lista Pos-Vendas-06 GERADA OK - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" )

Else
    //MsgInfo("Sem dados para gerar pos-vendas","Informação")
    //MemoWrite("\Temp\POSV-" + Dtos( dDatabase) + ".TXT","Sem dados para gerar pos-vendas.")
    cMsg   := "Sem dados para o pos-vendas - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	//eEmail := "gustavo@ravaembalagens.com.br"
    eEmail := "sac@ravaembalagens.com.br; gustavo@ravaembalagens.com.br"	
	subj   := "Lista Pos-Vendas-06 NAO GERADA - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" )
    ROLLBACKSX8()
Endif

conout(Replicate("*",60))
conout("Gera Pos-Vendas - FIM")
conout("TMKC002A - Lista Pos-Vendas - Fil. " + xFilial() + "  "  + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))
////////////////////////////////////////////////Fim parte Pós-Vendas

// Habilitar somente para Schedule
//Reset environment

Return 


//GERA LISTA TRANSP - filial 01-Rava Emb
**********************************************************
User function TMKC002C()
**********************************************************      
 
	// Habilitar somente para Schedule
	RPCSetType( 3 )
  	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"    //sacos
  	sleep( 5000 )	
	U_GeraTransp()
	
	Reset Environment
	
	// Habilitar somente para Schedule
	RPCSetType( 3 )  	 
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06"    //NOVA 
	sleep( 5000 )	
	U_GeraTransp()		
	Reset Environment	

Return 

/*
//GERA LISTA TRANSP - filial 03 Caixas
**********************************************************
User function LISTTransCX()
**********************************************************      
 
	// Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
		U_GeraTransp()
		
	Reset Environment	
	
Return
*/

*******************************
User Function GeraTransp()
*******************************
Local aCabTrans:= {}
Local aItTrans := {}
Local lOk
Local lDireto  		:= .F.
Local lMais60  		:= .F.
Local lNovoCli 		:= .F.
Local lGeraLista 	:= .F. 
Local lGravalista	:= .F.
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
Local cMsgTrans := "GEROU LISTA TRANSP"
Local cSeg1		:= '000009'		//Órgãos públicos
Local cSeg2		:= '000099'		//Representante RAVA
Local cSeg3		:= '000100'		//Transportadoras
Local cSeg4		:= '000101'		//Fornecedores
Local cQuery    := ""
Local dData1    := CtoD("  /  /    ")
Local dData2    := CtoD("  /  /    ")
Local dPrazoE   := CtoD("  /  /    ")
Local cRedesp   := ""
Local LF		:= CHR(13) + CHR(10)

// Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

cQuery    := ""

dData1    := ( dDatabase - 30 ) 

If dData1 = FirstDay( dData1)
	dData1 := dData1 + 1
Endif

//PÓS-VENDAS - TRANSPORTADORAS
//Parte 2 - seleciona clientes para lista Transportadoras
conout(Replicate("*",60))
conout("Gera Lista-Transp - INICIO")
conout("TMKC002C - Lista Transp - Emp. 02 - Filial: " + xFilial() + " - "  + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))

cQuery := " SELECT F2_DOC, F2_SERIE, F2_TRANSP, F2_DTEXP, F2_EMISSAO, F2_REDESP, A4_COD, A4_DIATRAB, A1_COD, A1_LOJA,  A1_SATIV1, ZZ_PRZENT " + LF
cQuery += " FROM " + LF 
cQuery += " " + RetSqlName("SF2") +" SF2, " + LF
cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SZZ") + " SZZ " + LF

cQuery += " WHERE F2_TRANSP  = A4_COD " + LF
cQuery += " AND F2_TRANSP = ZZ_TRANSP " + LF
cQuery += " AND F2_LOCALIZ = ZZ_LOCAL " + LF
cQuery += " AND F2_CLIENTE = A1_COD " + LF
cQuery += " AND F2_LOJA = A1_LOJA " + LF
//cQuery += " AND F2_DTEXP >= '" + Dtos( dData1 ) + "' "  + LF //VOLTAR  DEVIDO A TRANSP RAMOS NÃO ESTAR TENDO FATURAMENTO POR EQTO
cQuery += " AND ( F2_DTEXP >= '" + Dtos( dData1 ) + "' OR A4_COD = '14' )"  + LF //TEMPORARIO
cQuery += " AND F2_TRANSP <> '' " + LF
cQuery += " AND F2_REDESP = '' " + LF
cQuery += " AND F2_TRANSP <> '024' " + LF
//cQuery += " AND F2_CLIENTE <> '031248' " + LF
cQuery += " AND F2_CLIENTE <> '001588' " + LF
cQuery += " AND F2_CLIENTE <> '002655' " + LF
cQuery += " AND F2_CLIENTE <> '001276' " + LF
cQuery += " AND F2_TIPO = 'N' " + LF
cQuery += " AND A1_ATIVO <> 'N' " + LF
//cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg2 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg3 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg4 + "' " + LF

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " + LF

cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA4.D_E_L_E_T_ = '' " + LF
cQuery += " AND SZZ.D_E_L_E_T_ = '' " + LF
//
cQuery += " AND SZZ.ZZ_FILIAL='"+XFILIAL('SZZ')+"' " + LF
//
cQuery += " GROUP BY F2_DOC, F2_SERIE, F2_TRANSP, F2_DTEXP, F2_EMISSAO, F2_REDESP, A4_COD, A4_DIATRAB, A1_COD, A1_LOJA,  A1_SATIV1, ZZ_PRZENT " + LF
cQuery += " ORDER BY F2_TRANSP, F2_DTEXP DESC " + LF

Memowrite("c:\Temp\TRANS-" + Dtos( dDatabase ) + ".SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TLMT") > 0
	DbSelectArea("TLMT")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLMT" 

TCSetField( "TLMT", "F2_EMISSAO", "D")
TCSetField( "TLMT", "F2_DTEXP"  , "D")

TLMT->(DbGoTop())

DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      

aCabTrans 	:= {}
aItTrans  	:= {}

cLista    := GetSxENum("SU4","U4_LISTA")

while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end                                     

//cLista :=  GETMV("RV_SEQPOSV")
//cSeqLista := Substr( cLista, 2, 5 )


cU4Codlig := fMaxU4Lig()
cU6Codlig	:= cU4Codlig

cNFCli		:= ""
cSeriNF		:= ""
 

Aadd(aCabTrans,	{xFilial("SU4"),; 				//1->U4_FILIAL
				cLista,;                		//2->U4_LISTA
				cU4Codlig,;                		//3->U4_CODLIG
				"LISTA Transp: " + cLista,;     //4->U4_DESC
				dDatabase ,;                    //5->U4_DATA
				"1",;       					//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
				"1",;       					//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
				"1",;        					//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
				"4",;                           //9->U4_TIPOTEL
				"1",;     						//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
				Time() ,;  						//11->U4_HORA1 
				"" } ) 
				
			 //	"000006" })                    	//12->U4_OPERAD

cU6Codigo   := Strzero(Val(cU6Codigo) + 1,6)  
lGeraTrans  := .F.
lGeraRed    := .F.
lGravaTrans := .F.
dPrazoE		:= CtoD("  /  /    ")
cRedesp		:= ""
cTransp		:= ""

While !TLMT->(EOF())     
	   
	   	   
	   If TLMT->F2_TRANSP == cTrspAnt
	   		TLMT->(Dbskip())
	   		Loop
	   Endif
	   
	   cCliente := TLMT->A1_COD
	   cLoja    := TLMT->A1_LOJA
	   cEntida  := TLMT->( cCliente + cLoja )
	   cTransp  := TLMT->F2_TRANSP 
	   cRedesp  := TLMT->F2_REDESP
	   //cNFCli	:= TLMT->F2_DOC
       //cSeriNF	:= TLMT->F2_SERIE
       
       dPrazoE  := U_Calprv( TLMT->F2_DTEXP , TLMT->A4_DIATRAB, TLMT->ZZ_PRZENT )
              
	  
	   ///If dPrazoE >= dDatabase
	   	
			DbSelectArea("AC8")
			DbSetOrder(2)   
			
			If AC8->(DbSeek(xFilial("AC8")+"SA4"+"  "+ cTransp ))
				cCodContat := AC8->AC8_CODCON
			Else
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cTransp ))
				   		
				cCodContat		:= GETSX8NUM("SU5","U5_CODCONT")
				SU5->(Dbsetorder(1))
				If !SU5->(Dbseek(xFilial("SU5") + cCodContat ))
			   		RecLock("SU5", .T.)
			   		SU5->U5_FILIAL  := xFilial("SU5")
					//SU5->U5_CLIENTE := cCliente       //FR: se for transportadora, não poderá gravar, por isso, comentei estas 2 passagens
					//SU5->U5_LOJA    := cLoja
			   		SU5->U5_CODCONT := cCodContat    		
			   		SU5->U5_CONTAT  := iif(!Empty(SA4->A4_CONTATO),SA4->A4_CONTATO,SA4->A4_NOME)
			   		SU5->U5_CELULAR := SA4->A4_CELUL
			   		SU5->U5_DDD     := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,2,2) , SA4->A4_DDD )
			   		SU5->U5_EMAIL   := SA4->A4_EMAIL
			   		SU5->U5_FCOM1   := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,5,11), SA4->A4_TEL )
			   		SU5->U5_CPF		:= SA4->A4_CGC
			   		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			   		SU5->(MsUnlock())
			   		CONFIRMSX8()
			   		fCriaCont( "SA4", cTransp , cCodContat )
			   	Else
			      		
			   		cCodContat := fMaxSU5()		      	
			   		SU5->(Dbsetorder(8))		//U5_FILIAL + U5_CPF
			     		
			   		If !SU5->(Dbseek(xFilial("SU5") + SA4->A4_CGC ))
			     		RecLock("SU5", .T.)
			      		SU5->U5_FILIAL  := xFilial("SU5")
						//SU5->U5_CLIENTE := cCliente
						//SU5->U5_LOJA    := cLoja
			   			SU5->U5_CODCONT := cCodContat    		
			   			SU5->U5_CONTAT  := iif(!Empty(SA4->A4_CONTATO),SA4->A4_CONTATO,SA4->A4_NOME)
			   			SU5->U5_CELULAR := SA4->A4_CELUL
			   			SU5->U5_DDD     := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,2,2) , SA4->A4_DDD )
			   			SU5->U5_EMAIL   := SA4->A4_EMAIL
			   			SU5->U5_FCOM1   := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,5,11), SA4->A4_TEL )
			   			SU5->U5_CPF		:= SA4->A4_CGC
			   			SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			     		SU5->(MsUnlock())			      				      	
			      	Else
			      		cCodContat := SU5->U5_CODCONT
			      	Endif	
				      	fCriaCont( "SA4", cTransp , cCodContat )   
			      	Endif	
			    Endif   
			  
		         
		      Aadd(aItTrans,{   xFilial("SU6") 	,;  //1->U6_FILIAL
		                	 	cLista		   	,;  //2->U6_LISTA
			   					cU6Codigo	  	,;  //3->U6_CODIGO
		                		"SA4"          	,;  //4->U6_ENTIDA
		                		cTransp        	,;  //5->U6_CODENT
		                 		"1"            	,;  //6->U6_ORIGEM
		                	 	cCodContat     	,;  //7->U6_CONTATO
		                	 	cU6Codlig  		,;  //8->U6_CODLIG
		                 		dDatabase		,;  //9->U6_DATA
		                		Time() 			,;  //10->U6_HRINI
		                		"23:59"			,;  //11->U6_HRFIM
		                		"1"             ,;	//12->U6_STATUS
		                		cNFCli			,; 	//13->U6_NFISCAL
		                	    cSeriNF			,;	//14->U6_SERINF
		                	    "1"				,;  //15->U6_TIPO
		                	    cOper			,; 	//16->U6_CODOPER
		       	                cRedesp         ,;	//17->U6_REDESP
		       	                cTransp			})	//18->U6_TRANSP
			  
		       If Len(aItTrans) > 0
		       		lGeraTrans := .T.
		       Endif
		       
		       cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)
	   ///Endif	          
	   cTrspAnt := cTransp	   
	   DbSelectArea("TLMT")
	   TLMT->(DbSkip())
Enddo

DbselectArea("TLMT")
DbCloseArea("TLMT")

////// 2A. PARTE TRANSPORTADORAS - COM REDESPACHO
//PÓS-VENDAS - TRANSPORTADORAS
//Parte 2 - seleciona clientes para lista Transportadoras
cQuery := " SELECT F2_DOC, F2_SERIE, F2_TRANSP, F2_DTEXP, F2_EMISSAO, F2_REDESP, A4_COD, A4_DIATRAB, A1_COD, A1_LOJA,  A1_SATIV1, ZZ_PRZENT " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SF2") +" SF2, " + LF
cQuery += " " +  RetSqlName("SA4") + " SA4, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SZZ") + " SZZ " + LF 

cQuery += " WHERE F2_REDESP  = A4_COD " + LF
cQuery += " AND F2_REDESP = ZZ_TRANSP " + LF
cQuery += " AND F2_LOCALIZ = ZZ_LOCAL " + LF
cQuery += " AND F2_CLIENTE = A1_COD " + LF
cQuery += " AND F2_LOJA = A1_LOJA " + LF
cQuery += " AND F2_DTEXP >= '" + Dtos( dData1 ) + "' " + LF
cQuery += " AND F2_TRANSP <> '' " + LF
cQuery += " AND F2_REDESP <> '' " + LF
cQuery += " AND F2_TRANSP <> '024' " + LF
//cQuery += " AND F2_CLIENTE <> '031248' " + LF
cQuery += " AND F2_CLIENTE <> '001588' " + LF
cQuery += " AND F2_CLIENTE <> '002655' " + LF
cQuery += " AND F2_CLIENTE <> '001276' " + LF
cQuery += " AND F2_TIPO = 'N' " + LF
cQuery += " AND A1_ATIVO <> 'N' " + LF
//cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg2 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg3 + "' " + LF
cQuery += " AND A1_SATIV1 <> '"   + cSeg4 + "' " + LF

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " + LF
cQuery += " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'"  + LF
//
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA4.D_E_L_E_T_ = '' " + LF
cQuery += " AND SZZ.D_E_L_E_T_ = '' " + LF
cQuery += " GROUP BY F2_DOC, F2_SERIE, F2_TRANSP, F2_DTEXP, F2_EMISSAO, F2_REDESP, A4_COD, A4_DIATRAB, A1_COD, A1_LOJA,  A1_SATIV1, ZZ_PRZENT " + LF
cQuery += " ORDER BY F2_REDESP , F2_DTEXP DESC " + LF

Memowrite("c:\Temp\TRANSRED-" + Dtos( dDatabase ) + ".SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("REDESP") > 0
	DbSelectArea("REDESP")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "REDESP" 

TCSetField( "REDESP", "F2_EMISSAO", "D")
TCSetField( "REDESP", "F2_DTEXP"  , "D")

REDESP->(DbGoTop())
cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)  

lGeraRed    := .F.
cRedesp     := ""
cTransp 	:= ""
cRedespAnt  := ""
cNFAnt      := ""
cSeriAnt    := ""
dPrazoE     := CtoD("  /  /    ")
cNFCli		:= ""
cSeriNF		:= ""
cU6Codigo 	:= Strzero(Val(cU6Codigo) + 1,6)


While !REDESP->(EOF())     
	   
	   	   
	   If REDESP->F2_REDESP == cRedespAnt
	   		REDESP->(Dbskip())
	   		Loop
	   Endif
	   
	   cCliente := REDESP->A1_COD
	   cLoja    := REDESP->A1_LOJA
	   cEntida  := REDESP->( cCliente + cLoja )
	   cRedesp  := REDESP->F2_REDESP 
	   cTransp  := REDESP->F2_TRANSP
	   //cNFCli	:= REDESP->F2_DOC
       //cSeriNF	:= REDESP->F2_SERIE

       
       
       dPrazoE := U_Calprv( REDESP->F2_DTEXP , REDESP->A4_DIATRAB, REDESP->ZZ_PRZENT )
       	  
	   //If dPrazoE >= dDatabase
	   	
			DbSelectArea("AC8")
			DbSetOrder(2)   
			
			If AC8->(DbSeek(xFilial("AC8")+"SA4"+"  "+ cRedesp ))
				cCodContat := AC8->AC8_CODCON
			Else
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cRedesp ))
				   		
				cCodContat		:= GETSX8NUM("SU5","U5_CODCONT")
				SU5->(Dbsetorder(1))
				If !SU5->(Dbseek(xFilial("SU5") + cCodContat ))
			   		RecLock("SU5", .T.)
			   		SU5->U5_FILIAL  := xFilial("SU5")
					//SU5->U5_CLIENTE := cCliente       //FR: se for transportadora, não poderá gravar, por isso, comentei estas 2 passagens
					//SU5->U5_LOJA    := cLoja
			   		SU5->U5_CODCONT := cCodContat    		
			   		SU5->U5_CONTAT  := iif(!Empty(SA4->A4_CONTATO),SA4->A4_CONTATO,SA4->A4_NOME)
			   		SU5->U5_CELULAR := SA4->A4_CELUL
			   		SU5->U5_DDD     := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,2,2) , SA4->A4_DDD )
			   		SU5->U5_EMAIL   := SA4->A4_EMAIL
			   		SU5->U5_FCOM1   := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,5,11), SA4->A4_TEL )
			   		SU5->U5_CPF		:= SA4->A4_CGC
			   		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			   		SU5->(MsUnlock())
			   		CONFIRMSX8()
			   		fCriaCont( "SA4", cRedesp , cCodContat )
			   	Else
			      		
			   		cCodContat := fMaxSU5()		      	
			   		SU5->(Dbsetorder(8))		//U5_FILIAL + U5_CPF
			     		
			   		If !SU5->(Dbseek(xFilial("SU5") + SA4->A4_CGC ))
			     		RecLock("SU5", .T.)
			      		SU5->U5_FILIAL  := xFilial("SU5")
						//SU5->U5_CLIENTE := cCliente
						//SU5->U5_LOJA    := cLoja
			   			SU5->U5_CODCONT := cCodContat    		
			   			SU5->U5_CONTAT  := iif(!Empty(SA4->A4_CONTATO),SA4->A4_CONTATO,SA4->A4_NOME)
			   			SU5->U5_CELULAR := SA4->A4_CELUL
			   			SU5->U5_DDD     := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,2,2) , SA4->A4_DDD )
			   			SU5->U5_EMAIL   := SA4->A4_EMAIL
			   			SU5->U5_FCOM1   := iif(Substr(SA4->A4_TEL,1,1) == "(" , Substr(SA4->A4_TEL,5,11), SA4->A4_TEL )
			   			SU5->U5_CPF		:= SA4->A4_CGC
			   			SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			     		SU5->(MsUnlock())			      				      	
			      	Else
			      		cCodContat := SU5->U5_CODCONT
			      	Endif	
				      	fCriaCont( "SA4", cRedesp , cCodContat )   
			      	Endif	
			    Endif   
			  
		         
		      Aadd(aItTrans,{   xFilial("SU6") 	,;  //1->U6_FILIAL
		                	 	cLista		   	,;  //2->U6_LISTA
			   					cU6Codigo	  	,;  //3->U6_CODIGO
		                		"SA4"          	,;  //4->U6_ENTIDA
		                		cRedesp        	,;  //5->U6_CODENT
		                 		"1"            	,;  //6->U6_ORIGEM
		                	 	cCodContat     	,;  //7->U6_CONTATO
		                	 	cU6Codlig  		,;  //8->U6_CODLIG
		                 		dDatabase		,;  //9->U6_DATA
		                		Time() 			,;  //10->U6_HRINI
		                		"23:59"			,;  //11->U6_HRFIM
		                		"1"             ,;	//12->U6_STATUS
		                		cNFCli			,; 	//13->U6_NFISCAL
		                	    cSeriNF			,;	//14->U6_SERINF
		                	    "1"				,;	//15->U6_TIPO
		                	    cOper			,; 	//16->U6_CODOPER
		       	                cRedesp			,;	//17->U6_REDESP
		       	                cTransp			})	//18->U6_TRANSP
			  
		       If Len(aItTrans) > 0
		       		lGeraRed := .T.
		       Endif
		       
		       cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)
	   //Endif	          
	   cRedespAnt := cRedesp
	   //cNFAnt   := cNFCli
       //cSeriAnt := cSeriNF
	   DbSelectArea("REDESP")
	   REDESP->(DbSkip())
Enddo

DbselectArea("REDESP")
DbCloseArea("REDESP")




lGravaTrans := iif(lGeraTrans, .T., iif( lGeraRed , .T. , .F. ) )

If lGravaTrans  

	For u4 := 1 to Len(aCabTrans)
		Reclock("SU4",.T.)
		
		SU4->U4_FILIAL 		:= aCabTrans[u4][1]
		SU4->U4_LISTA  		:= aCabTrans[u4][2]
		SU4->U4_CODLIG  	:= aCabTrans[u4][3]
		SU4->U4_DESC		:= aCabTrans[u4][4]
		SU4->U4_DATA		:= aCabTrans[u4][5]
		SU4->U4_TIPO		:= aCabTrans[u4][6]
		SU4->U4_FORMA		:= aCabTrans[u4][7]
		SU4->U4_TELE		:= aCabTrans[u4][8]
		SU4->U4_TIPOTEL		:= aCabTrans[u4][9]           
		SU4->U4_STATUS		:= aCabTrans[u4][10]
		SU4->U4_HORA1		:= aCabTrans[u4][11]
		SU4->U4_OPERAD		:= aCabTrans[u4][12]
	   	
	   	SU4->(MsUnlock())
	   	CONFIRMSX8()
    Next
 	//PutMV( "RV_SEQPOSV" , "P" + StrZero(VAL(SUBSTR( cSeqLista ,2,5)) + 1 ,5) )
 	   
    For u6 := 1 to Len(aItTrans)
    	Reclock("SU6",.T.)
		SU6->U6_FILIAL  := xFilial("SU6")
		SU6->U6_FILENT	:= aItTrans[u6][1]
	   	SU6->U6_LISTA	:= aItTrans[u6][2]
	   	SU6->U6_CODIGO  := aItTrans[u6][3]
	   	SU6->U6_ENTIDA	:= aItTrans[u6][4]
	   	SU6->U6_CODENT	:= aItTrans[u6][5]  
	   	SU6->U6_ORIGEM	:= aItTrans[u6][6]            	//1=Lista 2=Manual 3=Atendimento
	   	SU6->U6_CONTATO	:= aItTrans[u6][7]
	   	SU6->U6_CODLIG	:= aItTrans[u6][8]         
	   	SU6->U6_DATA	:= aItTrans[u6][9]
	   	SU6->U6_HRINI	:= aItTrans[u6][10] 
	   	SU6->U6_HRFIM	:= aItTrans[u6][11]   
	   	SU6->U6_STATUS	:= aItTrans[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado	   
	   	SU6->U6_NFISCAL := aItTrans[u6][13]
	   	SU6->U6_SERINF	:= aItTrans[u6][14]
	   	SU6->U6_TIPO    := aItTrans[u6][15]
	   	SU6->U6_CODOPER := aItTrans[u6][16]
	   	SU6->U6_REDESP  := aItTrans[u6][17]
	   	SU6->U6_TRANSP  := aItTrans[u6][18]
	   	SU6->(MsUnlock())	   	
    Next
    //MsgInfo("Lista TRANSP gerada","Informação")
    cMsg   := "Lista Transp gerada - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	eEmail := "gustavo@ravaembalagens.com.br"
	subj   := "Lista Transp GERADA OK - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" )

Else
	//MsgInfo("Sem dados para gerar lista transp.","Informação")
//    MemoWrite("\Temp\TRANSP.TXT", "Sem dados para gerar lista transp.")
	cMsg   := "Sem dados p/ lista transp - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	eEmail := "gustavo@ravaembalagens.com.br"
	subj   := "Lista Transp NAO GERADA - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" ) 
    
//    MemoWrite("\Temp\TRANSP.TXT",cMsgTrans)
    ROLLBACKSX8()

Endif    

conout(Replicate("*",60))
conout("Gera Lista-Transp - FIM")
conout("TMKC002C - Lista Transp - Emp. 02 - Filial: " + xFilial() + " - "  + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))
//Fim parte - TRANSPORTADORAS



// Habilitar somente para Schedule
Reset environment

Return 

//////----> FIM do gera telemarketing ////////

/*
///foi feito, mas atualmente não é utilizado - desde 2010 até hoje não foi mais solicitado gerar - 29/03/2011.
//Gera TeleVendas  - opção 2
***************************************
User Function TMKC002B()
***************************************

Local aCabTLV     := {}
Local aItTLV      := {}
Local lOk
Local lDireto  		:= .F.
Local lMais60  		:= .F.
Local lMais90  		:= .F.
Local lNovoCli 		:= .F.
Local lGeraLista 	:= .F. 
Local lGravalista	:= .F. 
Local cQuery 		:= "" 

Local cCliente  := ""
Local cCliLJAnt := ""
Local cLoja	    := ""
Local cVendedor := ""
Local cCodContat:= ""
Local cLista	:= ""
Local cU4Codlig := ""
Local nLista    := 0 
Local aCab		:= {}
Local aItens	:= {}
Local cU6Codigo := ""
Local cNFiscal  := ""
Local cSerNF	:= ""
Local cVendedor := ""
Local cMsgInf1  := "GEROU TELEVENDAS CLIENTES NÃO-DIRETOS" 
Local cMsgInf2  := "GEROU TELEVENDAS CLIENTES DIRETO" 
Local cSeg1		:= '000009'
Local cSeg2		:= '000099'
Local cSeg3		:= '000100'
Local cSeg4		:= '000101'
Local dDTPartida:= CtoD("  /  /    ")
Local lLigAberto:= .F.

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


///------------compram DIRETO

//Critérios

//1) Os clientes compram Direto da RAVA

//2) Os clientes novos que fazem contato para comprar.	
	
//3) Classificar por frequência de compras.	
	
//4) Volume de compras

	

cQuery := ""
aCabTLVD := {}
aItTLVD  := {}

DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      

cLista    := GetSxeNum("SU4","U4_LISTA")
while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end


//cLista :=  GETMV("RV_SEQTLV")
//cSeqLista := Substr( cLista, 2, 5 )

cU4Codlig := fMaxU4Lig()
cU6Codlig := cU4Codlig

Aadd(aCabTLVD,	{xFilial("SU4"),; 					//1->U4_FILIAL
				cLista,;                			//2->U4_LISTA
				cU4Codlig,;                			//3->U4_CODLIG
				"LISTA TeleV-Direto: " + cLista,;   //4->U4_DESC
				dDatabase ,;                       	//5->U4_DATA
				"3",;       						//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
		   		"1",;       						//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
		   		"2",;        						//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
		   		"4",;                           	//9->U4_TIPOTEL
		   		"1",;     							//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
		   		Time(),;                          	//11->U4_HORA1
		   		"000007"	})                   	//12->U4_OPERAD

cU6Codigo := fMaxU6Cod()

cNFiscal:= ""
cSerNF	:= ""

dDTPartida := ( dDatabase - 90 )
//Clientes DIRETOS RAVA
cQuery := " SELECT F2_CLIENTE,F2_LOJA,A1_COD,A1_LOJA, A1_VEND, F2_VALBRUT, F2_EMISSAO, A1_SATIV1 "
cQuery += " FROM " + Retsqlname("SA1") + " SA1 "
cQuery += " INNER JOIN " + RetSqlname("SF2") + " SF2 " 
cQuery += " ON  A1_COD = F2_CLIENTE "
cQuery += " WHERE A1_LOJA = F2_LOJA "
cQuery += " AND F2_EMISSAO >= '" + DtoS( dDTPartida ) + "' "
cQuery += " AND F2_CLIENTE <> '031248' "
cQuery += " AND F2_CLIENTE <> '001588' "
cQuery += " AND F2_CLIENTE <> '002655' "
cQuery += " AND F2_CLIENTE <> '001276' "
cQuery += " AND F2_TIPO = 'N' "
cQuery += " AND (  RTRIM( A1_VEND )  = '0018'   " 
cQuery += " 	OR RTRIM( A1_VEND )  = '0018VD' "
cQuery += "     OR RTRIM( A1_VEND )  = '0227'   "
cQuery += "     OR RTRIM( A1_VEND )  = '0228'   "
cQuery += "     OR RTRIM( A1_VEND )  = '0229' ) "
cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg2 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg3 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg4 + "' "
cQuery += " AND A1_ATIVO <> 'N' "
cQuery += " AND SA1.D_E_L_E_T_ <>'*' "
cQuery += " AND SF2.D_E_L_E_T_ <>'*' "
cQuery += " GROUP BY F2_CLIENTE, F2_LOJA,A1_COD,A1_LOJA, A1_VEND, F2_VALBRUT, F2_EMISSAO, A1_SATIV1 "
cQuery += " ORDER BY F2_CLIENTE, F2_LOJA, F2_VALBRUT DESC "
//Memowrite( "\Temp\TLVD-" + Dtos( dDatabase ) + ".SQL",cQuery )

cQuery := ChangeQuery( cQuery )

If Select("TLV2B") > 0
	DbSelectArea("TLV2B")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLV2B" 

TLV2B->(DbGoTop())


DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      

cU6Codigo 	:= Strzero(Val(cU6Codigo) + 1,6)
cCliente 	:= ""
cLoja    	:= ""
cEntida  	:= ""
cCodContat	:= ""
cNFiscal 	:= ""
cSerNF		:= ""
cVendedor   := ""

While !TLV2B->(EOF())

	   lMais60 		:= .F.
	   lMesAtu 		:= .T.
	   lGeraLista	:= .F.
	   lGravalista  := .F.
	   lNovoCli     := .F.
	   lLigAberto	:= .F.
	   lVerSUA		:= .F.
	   lDireto		:= .F.	   
	   	   	   
	   If (TLV2B->F2_CLIENTE + TLV2B->F2_LOJA) == cCliLJAnt
			TLV2B->(Dbskip())
			Loop
       Endif            
       
             
       	cCliente 	:= TLV2B->A1_COD
		cLoja    	:= TLV2B->A1_LOJA
		cEntida  	:= cCliente + cLoja
		cCodContat	:= ""	
		cVendedor   := TLV2B->A1_VEND	   
	   
	   //Primeiro verifica na lista SU6 se existe alguma ligação ainda não realizada para o cliente
	   //Se existir, não irá gerar ligação para o cliente posicionado
	   
	   cQryU6 := " SELECT U6_FILIAL, U6_DATA, U6_CODENT, U6_STATUS, U6_TIPO "
	   cQryU6 += " FROM " + RetSqlName("SU6") + " SU6 "
	   cQryU6 += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
	   cQryU6 += " AND RTRIM(U6_CODENT) = '" + Alltrim(cEntida) + "' "
	   cQryU6 += " AND U6_TIPO = '3' "
	   cQryU6 += " AND SU6.D_E_L_E_T_ <>'*' "
	   cQryU6 += " GROUP BY U6_FILIAL, U6_DATA, U6_CODENT, U6_STATUS, U6_TIPO "
	   cQryU6 += " ORDER BY U6_FILIAL, U6_CODENT "
//	   Memowrite( "\Temp\LGU6.SQL",cQryU6 )

       cQryU6 := ChangeQuery( cQryU6 )

	   If Select("LGU6") > 0
	   		DbSelectArea("LGU6")
			DbCloseArea()	
	   EndIf

	   TCQUERY cQryU6 NEW ALIAS "LGU6" 

       LGU6->(DbGoTop())
              
       While !LGU6->(EOF())
       
       		If LGU6->U6_STATUS = "1"
		   			lLigAberto := .T.
		   				
		  	ElseIf LGU6->U6_STATUS != "1"		   			
		   		
		   		If ( dDatabase - StoD( LGU6->U6_DATA)  ) >= 2		   		
			   		DbSelectArea("SUA")
		   			SUA->(DbsetOrder(6))
		   			If SUA->(Dbseek(xFilial("SUA") + Substr( Alltrim(LGU6->U6_CODENT),1,6) + Substr( Alltrim(LGU6->U6_CODENT),7,2 ) ))
		   			
			   			While SUA->(!EOF()) .And. SUA->UA_FILIAL == xFilial("SUA") .And. SUA->UA_CLIENTE == Substr( Alltrim(LGU6->U6_CODENT),1,6);
			   		   		.And. SUA->UA_LOJA == Substr( Alltrim(LGU6->U6_CODENT),7,2 )
			   				
			   				If !Empty(SUA->UA_PROXLIG)
			   					If SUA->UA_PROXLIG >= dDatabase
			   						lLigAberto := .T.	   			
			   					Else
			   						lLigAberto := .F.
			   					Endif
			   				Endif   					
			   				SUA->(Dbskip())	   		
			   			Enddo		   
			   		Else
			   			lLigAberto := .F.			   			
			   		Endif
		   		Else 
		   			lLigAberto := .F.		   			
		   		Endif		   				   			
		    Endif                 
       		LGU6->(Dbskip())
       Enddo	   
	   
	   DbSelectArea("LGU6")
       DbCloseArea()
       
       
	   DbselectArea("TLV2B")	   
	   
	   If !lLigAberto
	   
		   DbselectArea("SF2")
	       SF2->(DbsetOrder(2))
		   If !SF2->(Dbseek(xFilial("SF2") + cCliente + cLoja ))
		   		lNovoCli := .T.	       
	       Endif

//A3_COD  A3_NOME - ATENDIMENTO DIRETO:
//0018  	RAVA EMBALAGENS IND. COM. LTDA                              
//0227  	RAVA EMBALAGENS IND. COM. LTDA  ( MARCOS )                  
//0228  	RAVA EMBALAGENS IND. COM. LTDA ( JOSENILDO )                
//0229  	RAVA EMBALAGENS IND. COM. LTDA (MARCILIO)                   
//0018VD	RAVA EMBALAGENS IND. E COM. LTDA 	   
		   
		   //lDireto := Alltrim( cVendedor ) $ '0018/0018VD/0227/0228/0229'		   	         
		   
		   //If lDireto  									//Atendidos direto pela RAVA
	   	   		lMesAtu := fMesAtu( cCliente, cLoja )   //Se retornar falso, é porque não comprou no mês atual
	   	   //Endif
		   
		   If lNovoCli
		   		lGeraLista := .T.
		   ElseIf  !lMesAtu
		   		lGeraLista := .T.             	//Se é atendido direto pela RAVA e se não comprou no mês atual
		   Endif		   		   
		   //---------------------------------------------------------------------------------------------------
		   If lGeraLista             //Aqui define se irá gravar a ligação para o cliente selecionado ou não
		   		lGravalista := .T.
		   Else
		   		lGravalista := .F.
		   Endif
		   //---------------------------------------------------------------------------------------------------
		   If lGravalista
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
			      		SU5->U5_CONTAT  := SA1->A1_CONTATO
			      		SU5->U5_CELULAR := SA1->A1_CELULAR
			      		SU5->U5_DDD     := SA1->A1_DDD
			      		SU5->U5_EMAIL   := SA1->A1_EMAIL
			      		SU5->U5_CPF		:= SA1->A1_CGC
			      		SU5->U5_FCOM1   := SA1->A1_TEL
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
				      		SU5->U5_CONTAT  := SA1->A1_CONTATO
				      		SU5->U5_CELULAR := SA1->A1_CELULAR
				      		SU5->U5_DDD     := SA1->A1_DDD
				      		SU5->U5_EMAIL   := SA1->A1_EMAIL
				      		SU5->U5_FCOM1   := SA1->A1_TEL
				      		SU5->U5_CPF		:= SA1->A1_CGC
				      		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
				      		SU5->(MsUnlock())				      	
			      		Endif
			      		fCriaCont( "SA1", cCliente+cLoja , cCodContat )   
			      	Endif	
			   Endif
			   
			   
				Aadd(aItTLVD,{	xFilial("SU6") 	,;  //1->U6_FILIAL
		                	 	cLista		   	,;  //2->U6_LISTA
			   					cU6Codigo	  	,;  //3->U6_CODIGO
		                		"SA1"          	,;  //4->U6_ENTIDA
		                		cEntida        	,;  //5->U6_CODENT
		                 		"1"            	,;  //6->U6_ORIGEM
		                	 	cCodContat     	,;  //7->U6_CONTATO
		                	 	cU6Codlig  		,;  //8->U6_CODLIG
		                 		dDatabase		,;  //9->U6_DATA
		                		Time() 			,;  //10->U6_HRINI
		                		"23:59"			,;  //11->U6_HRFIM
		                		"1"             ,;  //12->U6_STATUS
		                		cNFiscal		,;	//13->U6_NFISCAL
								cSerNF			,;  //14->U6_SERINF
								"3"				,;	//15->U6_TIPO
								"000007"		} ) //16->U6_CODOPER
			  	                
			   
			   
		       cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)   
	   	   Endif
	   Endif
	   cCliLJAnt := cCliente + cLoja
   	   DbSelectArea("TLV2B")
	   TLV2B->(DBSKIP())
Enddo

DbselectArea("TLV2B")
DbCloseArea("TLV2B")

If lGravalista
    
	For u4 := 1 to Len(aCabTLVD)
		Reclock("SU4",.T.)
		
		SU4->U4_FILIAL 		:= aCabTLVD[u4][1]
		SU4->U4_LISTA  		:= aCabTLVD[u4][2]
		SU4->U4_CODLIG  	:= aCabTLVD[u4][3]
		SU4->U4_DESC		:= aCabTLVD[u4][4]
		SU4->U4_DATA		:= aCabTLVD[u4][5]
		SU4->U4_TIPO		:= aCabTLVD[u4][6]
		SU4->U4_FORMA		:= aCabTLVD[u4][7]
		SU4->U4_TELE		:= aCabTLVD[u4][8]
		SU4->U4_TIPOTEL		:= aCabTLVD[u4][9]           
		SU4->U4_STATUS		:= aCabTLVD[u4][10]
		SU4->U4_HORA1		:= aCabTLVD[u4][11]
		SU4->U4_OPERAD		:= aCabTLVD[u4][12]
	   	
	   	SU4->(MsUnlock())
	   	CONFIRMSX8()
    Next
    //PutMV( "RV_SEQTLV" , "T" + StrZero(VAL(SUBSTR( cSeqLista ,2,5)) + 1 ,5) )
    
    For u6 := 1 to Len(aItTLVD)
    	Reclock("SU6",.T.)
		
		SU6->U6_FILENT	:= aItTLVD[u6][1]
	   	SU6->U6_LISTA	:= aItTLVD[u6][2]
	   	SU6->U6_CODIGO  := aItTLVD[u6][3]
	   	SU6->U6_ENTIDA	:= aItTLVD[u6][4]
	   	SU6->U6_CODENT	:= aItTLVD[u6][5]  
	   	SU6->U6_ORIGEM	:= aItTLVD[u6][6]            	//1=Lista 2=Manual 3=Atendimento
	   	SU6->U6_CONTATO	:= aItTLVD[u6][7]
	   	SU6->U6_CODLIG	:= aItTLVD[u6][8]         
	   	SU6->U6_DATA	:= aItTLVD[u6][9]
	   	SU6->U6_HRINI	:= aItTLVD[u6][10] 
	   	SU6->U6_HRFIM	:= aItTLVD[u6][11]   
	   	SU6->U6_STATUS	:= aItTLVD[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado
	   	SU6->U6_NFISCAL := aItTLVD[u6][13]
	   	SU6->U6_SERINF	:= aItTLVD[u6][14]
	    SU6->U6_TIPO	:= aItTLVD[u6][15]
	    SU6->U6_CODOPER	:= aItTLVD[u6][16]
	   	
	   	SU6->(MsUnlock())
    Next
    //MsgInfo("Lista TELEV-Diretos. gerada","Informação")
//    MemoWrite("\Temp\TLVD.TXT", cMsgInf2)

Else
	//MsgInfo("Lista TELEV-Diretos - Sem dados para geração","Informação")
//    MemoWrite("\Temp\TLVD.TXT", "Sem dados para a geração." )
    ROLLBACKSX8()
	
Endif

///------------FIM geração - compram direto






//Critérios

//CLIENTES NÃO-DIRETOS
//1) Os clientes que não compram a mais de 60 dias.	

//2) Os clientes novos que fazem contato para comprar.	
	
//3) Classificar por frequência de compras.	
	
//4) Volume de compras

	

cQuery := ""
aCabTLV := {}
aItTLV  := {}

DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      

cLista    := GetSxeNum("SU4","U4_LISTA")
while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end


//cLista 		:=  GETMV("RV_SEQTLV")
//cSeqLista 	:= Substr( cLista, 2, 5 )

cU4Codlig := fMaxU4Lig()
cU6Codlig := cU4Codlig

Aadd(aCabTLV,	{xFilial("SU4"),; 						//1->U4_FILIAL
				cLista,;                				//2->U4_LISTA
				cU4Codlig,;                				//3->U4_CODLIG
				"LISTA TeleV-Indiretos: " + cLista,;    //4->U4_DESC
				dDatabase ,;                       		//5->U4_DATA
				"3",;       							//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
		   		"1",;       							//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
		   		"2",;        							//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
		   		"4",;                           		//9->U4_TIPOTEL
		   		"1",;     								//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
		   		Time(),;                                //11->U4_HORA1
		   		"000007"     })                   		//12->U4_OPERAD

cU6Codigo := fMaxU6Cod()

cNFiscal:= ""
cSerNF	:= ""

dDTPartida := ( dDatabase - 90 )
//Clientes não atendidos DIRETO pela RAVA
cQuery := " SELECT F2_CLIENTE,F2_LOJA,A1_COD,A1_LOJA, A1_VEND, F2_VALBRUT, F2_EMISSAO, A1_SATIV1 "
cQuery += " FROM " + Retsqlname("SA1") + " SA1 "
cQuery += " INNER JOIN " + RetSqlname("SF2") + " SF2 " 
cQuery += " ON  A1_COD = F2_CLIENTE "
cQuery += " WHERE A1_LOJA = F2_LOJA "
cQuery += " AND F2_EMISSAO >= '" + DtoS( dDTPartida ) + "' "
cQuery += " AND F2_CLIENTE <> '031248' "
cQuery += " AND F2_CLIENTE <> '001588' "
cQuery += " AND F2_CLIENTE <> '002655' "
cQuery += " AND F2_CLIENTE <> '001276' "
cQuery += " AND F2_TIPO = 'N' "
cQuery += " AND RTRIM( A1_VEND )  <> '0018'   " 
cQuery += " AND RTRIM( A1_VEND )  <> '0018VD' "
cQuery += " AND RTRIM( A1_VEND )  <> '0227'   "
cQuery += " AND RTRIM( A1_VEND )  <> '0228'   "
cQuery += " AND RTRIM( A1_VEND )  <> '0229'   "
cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg2 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg3 + "' "
cQuery += " AND A1_SATIV1 <> '" + cSeg4 + "' "
cQuery += " AND A1_ATIVO <> 'N' "
cQuery += " AND SA1.D_E_L_E_T_ <>'*' "
cQuery += " AND SF2.D_E_L_E_T_ <>'*' "
cQuery += " GROUP BY F2_CLIENTE, F2_LOJA,A1_COD,A1_LOJA, A1_VEND, F2_VALBRUT, F2_EMISSAO, A1_SATIV1 "
cQuery += " ORDER BY F2_CLIENTE, F2_LOJA, F2_VALBRUT DESC, F2_EMISSAO DESC "
//Memowrite( "\Temp\TLVND-" + Dtos( dDatabase ) + ".SQL",cQuery )

cQuery := ChangeQuery( cQuery )

If Select("TLV2") > 0
	DbSelectArea("TLV2")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLV2" 
TCSetField( "TLV2" , "F2_EMISSAO", "D")

TLV2->(DbGoTop())


DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      

cU6Codigo 	:= Strzero(Val(cU6Codigo) + 1,6)
cCliente 	:= ""
cLoja    	:= ""
cEntida  	:= ""
cCodContat	:= ""
cNFiscal 	:= ""
cSerNF		:= ""

While !TLV2->(EOF())
	  
	   lMais60 		:= .F.
	   lMais90 		:= .F.
	   lGeraLista	:= .F.
	   lGravalista  := .F.
	   lNovoCli     := .F.
	   lLigAberto	:= .F.
	   lVerSUA		:= .F.	   
	    	   
	   If (TLV2->F2_CLIENTE + TLV2->F2_LOJA) == cCliLJAnt
			TLV2->(Dbskip())
			Loop
       Endif
       
       	cCliente 	:= TLV2->A1_COD
		cLoja    	:= TLV2->A1_LOJA
		cEntida  	:= cCliente + cLoja
		cCodContat	:= ""	
		cVendedor   := TLV2->A1_VEND	   
	   
	   //Primeiro verifica na lista SU6 se existe alguma ligação ainda não realizada para o cliente
	   //Se existir, não irá gerar ligação para o cliente posicionado
	   
	   cQryU6 := " SELECT U6_FILIAL, U6_DATA, U6_CODENT, U6_STATUS, U6_TIPO "
	   cQryU6 += " FROM " + RetSqlName("SU6") + " SU6 "
	   cQryU6 += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
	   cQryU6 += " AND RTRIM(U6_CODENT) = '" + Alltrim(cEntida) + "' "
	   cQryU6 += " AND U6_TIPO = '3' "
	   cQryU6 += " AND SU6.D_E_L_E_T_ <>'*' "
	   cQryU6 += " GROUP BY U6_FILIAL, U6_DATA, U6_CODENT, U6_STATUS, U6_TIPO "
	   cQryU6 += " ORDER BY U6_FILIAL, U6_CODENT "
//	   Memowrite( "\Temp\LIGU62.SQL",cQryU6 )

       cQryU6 := ChangeQuery( cQryU6 )

	   If Select("LIGU6") > 0
	   		DbSelectArea("LIGU6")
			DbCloseArea()	
	   EndIf

	   TCQUERY cQryU6 NEW ALIAS "LIGU6" 

       LIGU6->(DbGoTop())
              
       While !LIGU6->(EOF())
       
       		If LIGU6->U6_STATUS = "1"
		   			lLigAberto := .T.
		   				
		  	ElseIf LIGU6->U6_STATUS != "1"		   			
		   		
		   		If ( dDatabase - StoD( LIGU6->U6_DATA)  ) >= 2		   		
			   		DbSelectArea("SUA")
		   			SUA->(DbsetOrder(6))
		   			If SUA->(Dbseek(xFilial("SUA") + Substr( Alltrim(LIGU6->U6_CODENT),1,6) + Substr( Alltrim(LIGU6->U6_CODENT),7,2 ) ))
		   			
			   			While SUA->(!EOF()) .And. SUA->UA_FILIAL == xFilial("SUA") .And. SUA->UA_CLIENTE == Substr( Alltrim(LIGU6->U6_CODENT),1,6);
			   		   		.And. SUA->UA_LOJA == Substr( Alltrim(LIGU6->U6_CODENT),7,2 )
			   				
			   				If !Empty(SUA->UA_PROXLIG)
			   					If SUA->UA_PROXLIG >= dDatabase
			   						lLigAberto := .T.	   			
			   					Else
			   						lLigAberto := .F.
			   					Endif
			   				Endif   					
			   				SUA->(Dbskip())	   		
			   			Enddo		   
			   		Else
			   			lLigAberto := .F.			   			
			   		Endif
		   		Else 
		   			lLigAberto := .F.		   			
		   		Endif		   				   			
		    Endif                 
       		LIGU6->(Dbskip())
       Enddo	   
	   
	   DbSelectArea("LIGU6")
       DbCloseArea()
       
       
	   DbselectArea("TLV2")	   
	   
	   If !lLigAberto
	   
		   DbselectArea("SF2")
	       SF2->(DbsetOrder(2))
		   If !SF2->(Dbseek(xFilial("SF2") + cCliente + cLoja ))
		   		lNovoCli := .T.	       
	       Endif

//A3_COD  A3_NOME - ATENDIMENTO DIRETO:
//0018  	RAVA EMBALAGENS IND. COM. LTDA                              
//0227  	RAVA EMBALAGENS IND. COM. LTDA  ( MARCOS )                  
//0228  	RAVA EMBALAGENS IND. COM. LTDA ( JOSENILDO )                
//0229  	RAVA EMBALAGENS IND. COM. LTDA (MARCILIO)                   
//0018VD	RAVA EMBALAGENS IND. E COM. LTDA 		   

		   //lMais60 := fProcF260( cCliente,cLoja )     //Não compra há mais de 60 dias
		   lMais90 := fProcF290( cCliente,cLoja )     //Não compra há mais de 90 dias 
		   
		   If lMais90
			   	
			   	//DbselectArea("SA1")
			   	//SA1->(Dbsetorder(1))
			   	//SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
			   	//While !SA1->(EOF()) .And. SA1->A1_COD == cCliente .And. SA1->A1_LOJA == cLoja
			   	//	Reclock("SA1",.F.)
			   	//	SA1->A1_VEND := '0227'		//se não compra há mais de 90 dias, irá ser atendido pelo vendedor MARCOS - 0227
			   	//	SA1->(MsUnlock())		   		
			   	//	SA1->(DBSKIP())
			   	//Enddo
			   			//Em 07/01/10 - foi solicitado (Marcos/Eurivan) que não se altere mais o vendedor, caso o cliente não compre há mais de 90 dias.
			   	
			   	lGeraLista := .T.	   		   	         
		   
		   //ElseIf lMais60								//Se Este cliente não compra há mais de 60 dias = .T.
		  		
		  		//10/12/09--> Por solicitação de Marcos/Eurivan, não precisa gerar se for maior q 60 e menor q 90 dias
		  		//lGeraLista := .T.
		   ElseIf lNovoCli    							   //Se é somente cliente novo = .T.
		   		lGeraLista := .T.		   
		   Endif		   		   
		   //---------------------------------------------------------------------------------------------------
		   If lGeraLista             //Aqui define se irá gravar a ligação para o cliente selecionado ou não
		   		lGravalista := .T.
		   Else
		   		lGravalista := .F.
		   Endif
		   //---------------------------------------------------------------------------------------------------
		   If lGravalista
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
			      		SU5->U5_CONTAT  := SA1->A1_CONTATO
			      		SU5->U5_CELULAR := SA1->A1_CELULAR
			      		SU5->U5_DDD     := SA1->A1_DDD
			      		SU5->U5_EMAIL   := SA1->A1_EMAIL
			      		SU5->U5_CPF		:= SA1->A1_CGC
			      		SU5->U5_FCOM1   := SA1->A1_TEL
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
				      		SU5->U5_CONTAT  := SA1->A1_CONTATO
				      		SU5->U5_CELULAR := SA1->A1_CELULAR
				      		SU5->U5_DDD     := SA1->A1_DDD
				      		SU5->U5_EMAIL   := SA1->A1_EMAIL
				      		SU5->U5_FCOM1   := SA1->A1_TEL
				      		SU5->U5_CPF		:= SA1->A1_CGC
				      		SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
				      		SU5->(MsUnlock())				      	
			      		Endif
			      		fCriaCont( "SA1", cCliente+cLoja , cCodContat )   
			      	Endif	
			   Endif
			   
			   Aadd(aItTLV,{	xFilial("SU6") 	,;  //1->U6_FILIAL
		                	 	cLista		   	,;  //2->U6_LISTA
			   					cU6Codigo	  	,;  //3->U6_CODIGO
		                		"SA1"          	,;  //4->U6_ENTIDA
		                		cEntida        	,;  //5->U6_CODENT
		                 		"1"            	,;  //6->U6_ORIGEM
		                	 	cCodContat     	,;  //7->U6_CONTATO
		                	 	cU6Codlig  		,;  //8->U6_CODLIG
		                 		dDatabase			,;  //9->U6_DATA
		                		Time() 			,;  //10->U6_HRINI
		                		"23:59"			,;  //11->U6_HRFIM
		                		"1"             ,;  //12->U6_STATUS
		                		cNFiscal		,;	//13->U6_NFISCAL
								cSerNF			,;  //14->U6_SERINF
								"3"				,;	//15->U6_TIPO	                			              
								"000007"		} ) //16->U6_CODOPER
			  
		       cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)   
	   	   Endif
	   Endif
	   cCliLJAnt := cCliente + cLoja
   	   DbSelectArea("TLV2")
	   TLV2->(DBSKIP())
Enddo

DbselectArea("TLV2")
DbCloseArea("TLV2")

If lGravalista
    
	For u4 := 1 to Len(aCabTLV)
		Reclock("SU4",.T.)
		
		SU4->U4_FILIAL 		:= aCabTLV[u4][1]
		SU4->U4_LISTA  		:= aCabTLV[u4][2]
		SU4->U4_CODLIG  	:= aCabTLV[u4][3]
		SU4->U4_DESC		:= aCabTLV[u4][4]
		SU4->U4_DATA		:= aCabTLV[u4][5]
		SU4->U4_TIPO		:= aCabTLV[u4][6]
		SU4->U4_FORMA		:= aCabTLV[u4][7]
		SU4->U4_TELE		:= aCabTLV[u4][8]
		SU4->U4_TIPOTEL		:= aCabTLV[u4][9]           
		SU4->U4_STATUS		:= aCabTLV[u4][10]
		SU4->U4_HORA1		:= aCabTLV[u4][11]
		SU4->U4_OPERAD		:= aCabTLV[u4][12]
	   	
	   	SU4->(MsUnlock())
	   	CONFIRMSX8()
    Next  
    //PutMV( "RV_SEQTLV" , "T" + StrZero(VAL(SUBSTR( cSeqLista ,2,5)) + 1 ,5) )
    
    For u6 := 1 to Len(aItTLV)
    	Reclock("SU6",.T.)
		
		SU6->U6_FILENT	:= aItTLV[u6][1]
	   	SU6->U6_LISTA	:= aItTLV[u6][2]
	   	SU6->U6_CODIGO  := aItTLV[u6][3]
	   	SU6->U6_ENTIDA	:= aItTLV[u6][4]
	   	SU6->U6_CODENT	:= aItTLV[u6][5]  
	   	SU6->U6_ORIGEM	:= aItTLV[u6][6]            	//1=Lista 2=Manual 3=Atendimento
	   	SU6->U6_CONTATO	:= aItTLV[u6][7]
	   	SU6->U6_CODLIG	:= aItTLV[u6][8]         
	   	SU6->U6_DATA	:= aItTLV[u6][9]
	   	SU6->U6_HRINI	:= aItTLV[u6][10] 
	   	SU6->U6_HRFIM	:= aItTLV[u6][11]   
	   	SU6->U6_STATUS	:= aItTLV[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado
	   	SU6->U6_NFISCAL := aItTLV[u6][13]
	   	SU6->U6_SERINF	:= aItTLV[u6][14]
	   	SU6->U6_TIPO	:= aItTLV[u6][15]
	   	SU6->U6_CODOPER	:= aItTLV[u6][16]
	   
	   	
	   	SU6->(MsUnlock())
    Next
    //MsgInfo("Lista TELEV. ND - gerada","Informação")
//    MemoWrite("\Temp\TLVND.TXT", cMsgInf1)

Else
	//MsgInfo("Lista TELEV. ND - Sem dados para geração","Informação")
//    MemoWrite("\Temp\TLVND.TXT", "Sem dados para a geração." )
    ROLLBACKSX8()
	
Endif




// Habilitar somente para Schedule
Reset environment	


Return
//FIM do gera televendas 

*/


//FUNÇÕES AUXILIARES:

***************************************
Static Function fMesAtu(cCliente,cLoja)
***************************************
//Função para verificar se o cliente comprou no mês atual,
//Aqui estou usando um critério de ultima data de NF ultrapassa 30 dias.
Local cQry   := ""
Local lMesAtu:= .T.
Local nDias  := 0


cQry := " SELECT TOP 1 F2_CLIENTE,F2_LOJA,F2_EMISSAO "
cQry += " FROM " + RetSqlname("SF2") + " SF2 "
cQry += " WHERE F2_CLIENTE = '" + cCliente + "' "
cQry += " AND F2_LOJA = '" + cLoja + "' "
cQry += " AND F2_TIPO = 'N' "
cQry += " AND SF2.D_E_L_E_T_ <>'*' "
cQry += " ORDER BY F2_EMISSAO DESC"

//Memowrite("\Temp\MESATU.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MESATU") > 0
	DbSelectArea("MESATU")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MESATU"
TCSetField( "MESATU" , "F2_EMISSAO", "D") 

MESATU->(DbGoTop())

While !MESATU->(EOF())
	
	nDias := ( dDatabase - MESATU->F2_EMISSAO )
    MESATU->(Dbskip())

Enddo

If nDias > 30
	lMesAtu := .F.   //Não comprou no mês atual = .F., se tivesse comprado, seria = .T.
Else
	lMesAtu := .T.
Endif


Return(lMesAtu)


*****************************************
Static Function fProcF260(cCliente,cLoja)
*****************************************
//Função para verificar se o cliente não compra há mais de 60 dias (cliente atendido pela RAVA)
//Aqui estou usando um critério de ultima data de NF ultrapassa 60 dias.
Local cQry := ""
Local lMais60 := .F.
Local nDias	:= 0

cQry := " SELECT TOP 1 F2_CLIENTE,F2_LOJA,F2_EMISSAO "
cQry += " FROM " + RetSqlname("SF2") + " SF2 "
cQry += " WHERE F2_CLIENTE = '" + cCliente + "' "
cQry += " AND F2_LOJA = '" + cLoja + "' "
cQry += " AND F2_TIPO = 'N' "
cQry += " AND SF2.D_E_L_E_T_ <>'*' "
cQry += " ORDER BY F2_EMISSAO DESC"

//Memowrite("\Temp\PROCF2.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("PROCF2") > 0
	DbSelectArea("PROCF2")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "PROCF2" 
TCSetField( "PROCF2" , "F2_EMISSAO", "D") 

PROCF2->(DbGoTop())

While !PROCF2->(EOF())

    nDias := ( dDatabase - PROCF2->F2_EMISSAO )
    
PROCF2->(Dbskip())
Enddo

If nDias >= 60
	lMais60 := .T.
Else
	lMais60 := .F.
Endif

Return(lMais60)



*****************************************
Static Function fProcF290(cCliente,cLoja)
*****************************************
//Função para verificar se o cliente não compra há mais de 60 dias (cliente atendido pela RAVA)
//Aqui estou usando um critério de ultima data de NF ultrapassa 60 dias.
Local cQry := ""
Local lMais90 := .F.
Local nDias	:= 0

cQry := " SELECT TOP 1 F2_CLIENTE,F2_LOJA,F2_EMISSAO "
cQry += " FROM " + RetSqlname("SF2") + " SF2 "
cQry += " WHERE F2_CLIENTE = '" + cCliente + "' "
cQry += " AND F2_LOJA = '" + cLoja + "' "
cQry += " AND F2_TIPO = 'N' "
cQry += " AND SF2.D_E_L_E_T_ <>'*' "
cQry += " ORDER BY F2_EMISSAO DESC"

//Memowrite("\Temp\PROCF290.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("SF290") > 0
	DbSelectArea("SF290")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "SF290" 
TCSetField( "SF290" , "F2_EMISSAO", "D") 

SF290->(DbGoTop())

While !SF290->(EOF())

    nDias := ( dDatabase - SF290->F2_EMISSAO )
    
SF290->(Dbskip())
Enddo

If nDias >= 90
	lMais90 := .T.
Else
	lMais90 := .F.
Endif

DbSelectArea("SF290")
DbCloseArea()	

Return(lMais90)

**************************************
Static Function fMaxU6Cod()     
**************************************

Local cQry 		:= "" 
Local cMaxU6 	:= ""


cQry := " SELECT MAX(U6_CODIGO) as U6_CODIGO "
cQry += " FROM " + RetSqlname("SU6") + " SU6 "
cQry += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQry += " AND SU6.D_E_L_E_T_ <>'*' "
//Memowrite("\Temp\MAX_U6.SQL",cQry)

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



// ASSISTENTE 000016
***************************
Static Function Gera_PosVR()	
*************************** 

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
Local cMsgTrans := "GEROU LISTA TRANSP"
Local cSeg1		:= '000009'		//Órgãos públicos
Local cSeg2		:= '000099'		//Representante RAVA
Local cSeg3		:= '000100'		//Transportadoras
Local cSeg4		:= '000101'		//Fornecedores
Local cQuery    := ""
Local dData1    := CtoD("  /  /    ")
Local dData2    := CtoD("  /  /    ")
Local dPrazoE   := CtoD("  /  /    ")
Local cRedesp   := ""
Local LF		:= CHR(13) + CHR(10)
Local cOper		:= GetNewPar("MV_XOPERTM","000018")

// Habilitar somente para Schedule
/*
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

conout(Replicate("*",60))
conout("Gera Pos-Vendas - INICIO")
conout("TMKC002A - Lista Pos-Vendas - Emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))
*/
//LISTA PÓS-VENDAS:
	
//Em 27/10/09 - Foi Definido:
//Esta query seleciona as notas que estão com previsao de chegada com data anterior a data que está sendo executado o programa
// (dDatabase - 1) para que o operador ligue para os clientes para confirmar o recebimento.

//Parte 1 - seleciona clientes para lista Pós-Vendas

cQuery := "SELECT F2_CLIENTE, F2_LOJA , F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP, F2_PREVCHG, A4_CODCLIE " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SF2") +" SF2, " + LF
cQuery += " " + RetSqlName("SD2") +" SD2, " + LF
cQuery += " " + RetSqlName("SA1")+" SA1 "  + LF

//FR - 18/05/2011 - NFs de ressarcimento para Transportadora, não entram na lista pós-vendas
cQuery += " LEFT OUTER JOIN "
cQuery += " " + RetSqlName("SA4") + " SA4 " + LF
cQuery += " on SA1.A1_COD IN (SA4.A4_CODCLIE) AND SA4.A4_CODCLIE IS NULL " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SA4.D_E_L_E_T_ = '' " + LF
//até aqui

cQuery += " WHERE A1_COD = F2_CLIENTE " + LF
cQuery += " AND A1_LOJA  = F2_LOJA " + LF
cQuery += " and SA1.A1_CGC NOT LIKE ('28924778%') " + LF     //exceto notas da RAVA para RAVA
cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE) " + LF
cQuery += " AND F2_FILIAL  = D2_FILIAL  " + LF

cQuery += " AND F2_PREVCHG >= '" +Dtos(dDataBase-1) + "' AND F2_PREVCHG <=  '" + Dtos(dDataBase-1) + "' " + LF

// UF DO ASSISTNTE  - 000016
//cQuery += " AND F2_EST IN('BA','MA','PB','PI','RN','AP','DF','GO','SP','MG','RJ')  " + LF



//cQuery += " AND F2_DTEXP >= '20140509' " + LF
//cQuery += " AND F2_DOC NOT IN ( '000035517','000035532','000035577','000003809','000003811') " + LF
//cQuery += " AND F2_CLIENTE <> '031248' "	 + LF	//MIX-KIT logística por enquanto é para gerar sim.

cQuery += " AND F2_TIPO = 'N' " + LF
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
//Filtrar as NF's que não são de mercadorias para clientes da lista de ligações do SAC (excluir remessa venda ordem e para conserto)
//FR - 25/07/2011 - POR SOLICITAÇÃO DE DANIELA, voltar a geração da lista para as notas Conta e Ordem (Tes 535) E EXCLUIR TES AMOSTRA
cQuery += " AND D2_TES NOT IN ( '502' , '516', '507' , '543' , '547', '528' , '504' , '619' , '578', '603' ) " + LF  
//FR - 26/03/2012 - retirar da geração , as notas de amostra (TES acima)
//FR - 04/04/12 - retirar TES 504 - simples remessa
//FR - 04/04/12 - retirar TES 528 - cta e ordem
//FR - 15/01/13 - retirar TES 619 - ressarcimento 
//FR - 18/02/13 - retirar TES 578 - remessa comodato
//FR - 12/05/14 - retirar TES 603 - VENDAS MERC ADQ TERC
														
cQuery += " AND F2_TRANSP <> '024'  " + LF
//cQuery += " AND F2_TRANSP <> '025'  " + LF

cQuery += " AND F2_CLIENTE <> '001588' " + LF        //Clientes que compram aparas
cQuery += " AND F2_CLIENTE <> '002655' " + LF
cQuery += " AND F2_CLIENTE <> '001276' " + LF

//cQuery += " AND A1_ATIVO <> 'N' "		 + LF //Por solicitação de Daniela e Aprovação de Eurivan, retirei esta cláusula - 24/02/10
//cQuery += " AND A1_SATIV1 <> '" + cSeg1 + "' "  + LF 

cQuery += " AND A1_SATIV1 <> '" + cSeg2 + "' " + LF
cQuery += " AND A1_SATIV1 <> '" + cSeg3 + "' " + LF
cQuery += " AND A1_SATIV1 <> '" + cSeg4 + "' " + LF

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' " + LF

cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_REDESP, F2_DTEXP, F2_PREVCHG, A4_CODCLIE " + LF
cQuery += " ORDER BY F2_DOC, F2_SERIE " + LF

Memowrite("C:\Temp\POSV-" + Dtos( dDatabase) + ".SQL",cQuery)
//Memowrite("C:\POSV-" + Dtos( dDatabase) + ".SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TLM1") > 0
	DbSelectArea("TLM1")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLM1" 

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
  
cU4Codlig := fMaxU4Lig()
cU6Codlig := cU4Codlig

Aadd(aCab,	{xFilial("SU4"),; 				//1->U4_FILIAL
			cLista,;                		//2->U4_LISTA
			cU4Codlig,;                		//3->U4_CODLIG
			"PREV. ENTREGA: " + cLista,; //4->U4_DESC
			DataValida(dDatabase) ,;        //5->U4_DATA
			"1",;       					//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
			"1",;       					//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
			"1",;        					//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
			"4",;                           //9->U4_TIPOTEL
			"1",;     						//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
			Time(),;                        //11->U4_HORA1
			cOper } )					
			//Jan/2011- entrada da Mariana como operador, deixar operador em branco, para Daniela e Mariana visualizarem
			
			
			//"" })                     //12->U4_OPERAD
			//Operador em Branco -> todos os operadores visualizam as listas

cU6Codigo := fMaxU6Cod()
cCliAntes := ""
cLjCliAn  := ""
cTransp	  := ""

While !TLM1->(EOF())    
	   
	   //Em 13/01/10 - Durante a Conferência com Marcelo, Eurivan e Daniela, foi solicitado que a lista seja gerada 
	   //por NF e não somente por Cliente, para que os feed-backs sejam criados por NF também.
	   
	   /*
	   If ( TLM1->F2_CLIENTE + TLM1->F2_LOJA ) == ( cCliAntes + cLjCliAn )
	   		TLM1->(Dbskip())
	   		Loop
	   Endif
	   */
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
	                	    cOper			,;	 	//16->U6_CODOPER	// 000016 - Renta lopes 
	                	    cRedesp			,;		//17->U6_REDESP		//Transportadora em caso de redespacho
	                        cTransp			})		//18->U6_TRANSP
	                
	   If Len(aItens) > 0
	   		lGravaPos := .T.
	   Else
	   		//Msgbox("Array aItens - Pós_Vendas - vazio")
	   		ConOut( "Tmkc002A- Array aItens vazio - sem itens Pos-Vendas " + Dtoc( Date() ) + ' - ' + Time() )
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
cMsg := ""
eEmail := ""
subj    := ""
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
    
    //PutMV( "RV_SEQPOSV" , "P" + StrZero(VAL(SUBSTR( cSeqLista ,2,5)) + 1 ,5) )
    
    For u6 := 1 to Len(aItens)
    	If !SU6->(Dbseek(xFilial("SU6") + aItens[u6][13] + aItens[u6][14] ))
	    	Reclock("SU6",.T.)
			SU6->U6_FILIAL	:= xFilial("SU6")
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
		//Else
		//	msgbox("Encontrou a nf: " + aItens[u6][13] )
		Endif	   		   	
    Next 
    //MsgInfo("Lista Pós-Vendas gerada","Informação")
    //MemoWrite("\Temp\POSV-" + Dtos( dDatabase) + ".TXT", cMsgPos )
    cMsg   := "Lista pos-vendas gerada - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	//eEmail := "gustavo@ravaembalagens.com.br"
    eEmail := "sac@ravaembalagens.com.br; gustavo@ravaembalagens.com.br"	
	subj   := "Lista Pos-Vendas-16 GERADA OK - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" )

Else
    //MsgInfo("Sem dados para gerar pos-vendas","Informação")
    //MemoWrite("\Temp\POSV-" + Dtos( dDatabase) + ".TXT","Sem dados para gerar pos-vendas.")
    cMsg   := "Sem dados para o pos-vendas - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	//eEmail := "gustavo@ravaembalagens.com.br"
    eEmail := "sac@ravaembalagens.com.br; gustavo@ravaembalagens.com.br"		
	subj   := "Lista Pos-Vendas-16 NAO GERADA - Filial: "+ xFilial() + LF
	U_SendFatr11(eEmail, "", subj, cMsg, "" )
    ROLLBACKSX8()
Endif

conout(Replicate("*",60))
conout("Gera Pos-Vendas - FIM")
conout("TMKC002A - Lista Pos-Vendas - Emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))
////////////////////////////////////////////////Fim parte Pós-Vendas

// Habilitar somente para Schedule
//Reset environment

Return 
