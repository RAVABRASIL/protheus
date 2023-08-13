#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*-------------------------------------------------------------------------------------*/
//Programa: TMKC-Resp.prw
//Autoria : Flávia Rocha
//Data    : 08/10/09
//Objetivo: Mostrar browse dos atendimentos relativos ao responsável pelos mesmos.
// O responsável irá interagir com os atendimentos colocando uma data de resposta 
// e observação. Após esta ação, será enviado um email ao solicitante para conhecimento.
//Alterado em 15/03/11 - ch 002069: prazo para solução digitado deverá respeitar fórmula:
// Dt. inclusão da ocorrência + 6 dias úteis
/*-------------------------------------------------------------------------------------*/

*************************
User Function TMKC003()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltraSUD    := ""
Local aIndexSUD		:= {}
Local cNomeUser     := ""
Local aUsua			:= {}
Local cUsua			:= ""
Local aSup			:= {}
Local cSup			:= ""
Local aCampos		:= {}
Local LF      	:= CHR(13)+CHR(10)


/*
Local aCores		:= {	{ 'UD_RESOLVI = "S" .Or. UD_STATUS ="2"' , 'BR_VERMELHO'  },;	// Atendimento resolvido/encerrado
							{ 'Empty(UD_DATA)'  , 'BR_VERDE' },;                        		// Atendimento não respondido
							{'!Empty(UD_DATA) .And. UD_RESOLVI != "S"'  , 'BR_AMARELO'   } }			//Atendimento respondido e não resolvido 

*/

Local aCores		:= {	{ 'UD_RESOLVI = "S" .Or. UD_STATUS ="2"' , 'BR_VERMELHO'  },;	// Atendimento resolvido/encerrado
							{ 'Empty(UD_DATA)'  , 'BR_VERDE' },;                        		// Atendimento não respondido
							{'!Empty(UD_DATA) .AND. (UD_NRENVIO = 1) ', 'BR_AMARELO'   },;			//Atendimento respondido e não resolvido 
							{'!Empty(UD_DATA) .AND. (UD_NRENVIO > 1) .And. UD_RESOLVI  !="S"'   , 'BR_PINK'   } }

Private cCadastro	:= "Solicitações de Atendimento"
Private bFiltraBrw	:= {|| Nil}	
							

Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar"   ,	"U_TMKVisu"  	,0,2},;  	// Visualizar
							{"Responder"     ,	"U_TMKRes()"	,0,4},;	    // Responde com uma previsão de Dt. para Ação
							{"Logistica"     ,	"U_TMKLog()"	,0,4},;	    // Encerra com Dt. Ação podendo até ser 7 dias úteis após dt. inclusão
								{"Legenda"   ,	"U_TMKLeg()"	,0,5}}	    // Legenda							
						

Private cCodResp	:= ""
Private cMailResp	:= ""
Private cMailSup	:= ""		//email do superior do responsável pela ocorrência 
Private cNomeSup	:= ""

cCodResp := __CUSERID

PswOrder(1)
If PswSeek( cCodResp, .T. )
   	aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   	//cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   	cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   	cMailResp := Alltrim(aUsua[1][14])     // e-mail do usuário
	cSup   := aUsua[1][11]
	///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   	PswOrder(1)
   	If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif

Endif


Aadd(aCampos, { SUD->UD_FILIAL,;		//1
				SUD->UD_CODIGO,;        //2
         		SUD->UD_ITEM,;			//3
         		SUD->UD_OPERADO } )     //9


If Upper(Substr(cUsuario,7,15))  != 'DANIELA' .and. Upper(Substr(cUsuario,7,15))  != 'ADMIN' .and. Upper(Substr(cUsuario,7,15))  != 'FLAVIA.ROCHA'
//para usuários diferentes de Daniela e Admin, filtra apenas os seus respectivos atendimentos
	cFiltraSUD:= "UD_OPERADO = '" + cCodResp + "' .and. UD_FILIAL = '" + xFilial("SUD") + "' "
Else
	cFiltraSUD := "UD_FILIAL = '" + xFilial("SUD") + "' "       //para Usuários: Daniela e Admin e flavia.rocha, a visualização é completa
Endif	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro, utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SUD")
dbSetOrder(1)
bFiltraBrw 	:= {|| FilBrowse( "SUD", @aIndexSUD, @cFiltraSUD ) }
Eval(bFiltraBrw)


mBrowse( 6, 1,22,75, "SUD",,,,,,aCores)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("SUD", aIndexSUD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SUD")
dbSetOrder(1)
dbClearFilter()
	
Return(Nil)




******************************************************************************************************
User Function TMKRes()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaSUD	:= SUD->(GetArea())
Local dDataResp	:= CriaVar("UD_DATA",.F.,.F.)
Local cObsSUD	:= SUD->UD_OBS //CriaVar("UD_OBS",.F.,.F.)
Local cObsSUD2	:= SUD->UD_OBS 
Local cFil      := SUD->UD_FILIAL

Local cObsResp  := SUD->UD_JUSTIFI //CriaVar("UD_JUSTIFI", .F.,.F.)
Local cEntidade := ""		//vai armazenar se é SA1 ou SA2
Local cSUDChave := ""		//vai armazenar o codigo+loja
Local cCliente  := ""
Local cLojaCli  := ""
Local dDtInclu  := SUD->UD_DTINCLU
Local cHoraIncl := SUD->UD_HRINCLU
Local cSUDResp  := SUD->UD_OPERADO 

Local cNomeUser := ""
Local lEfetiv	:= .F.
Local cTransp	:= ""
Local cNomTransp:= ""
Local cRedesp   := ""
Local cNomRedesp:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local nOpcA	
Local dDtREAT	  := Ctod("  /  /    ")	
Local lAntiga	  := .F.
Local lReativ	  := .F.

//Private lReativ   := .F.   //ESTA VARIÁVEL IRÁ SINALIZAR SE A OCORRÊNCIA FOI REATIVADA OU NÃO, CASO SIM, NÃO IRÁ PRECISAR DE PRAZO PARA SOLUÇÃO 5 DIAS
//Private lAntiga   := .F.   //ESTA VARIÁVEL IRÁ SINALIZAR SE A OCORRÊNCIA É ANTIGA - ABERTA ANTES DE 15/03 - CASO POSITIVO, NÃO IRÁ PRECISAR DE PRAZO PARA SOLUÇÃO 5 DIAS

Private cAtend    := SUD->UD_CODIGO
Private cItemSUD  := SUD->UD_ITEM
Private cUserSAC  := SUD->UD_CODUSER
Private cNF		:= ""
Private cSeriNF	:= ""
If Upper(Substr(cUsuario,7,15))  != 'DANIELA' .and. Upper(Substr(cUsuario,7,15))  != 'ADMIN' .and. Upper(Substr(cUsuario,7,15))  != 'FLAVIA.ROCHA'
	If ( SUD->UD_RESOLVI = "S" .or. SUD->UD_STATUS = "2" )
		Aviso(	cCadastro,;
					"O atendimento já foi resolvido ou encerrado. Contate o SAC.",;
					{"&Continua"},,;
					"Atendimento/Item: " + SUD->UD_CODIGO + "/" + SUD->UD_ITEM )
					Return(Nil)
	EndIf
Endif

DEFINE MSDIALOG oDlg5 FROM 000,000 TO 500,590 TITLE "Resposta ao Atendimento" PIXEL

//Esse bloco irá buscar pelo atendimento qual foi a Entidade (SA1 ou SA2) e trazer o nome
SUC->(Dbsetorder(1))
If SUC->(Dbseek(xFilial("SUC") + cAtend ))
	cEntidade := SUC->UC_ENTIDAD
	cSUDChave := SUC->UC_CHAVE
	//dDtInclu  := SUC->UC_DATA
	//cHoraIni  := SUC->UC_INICIO
	cNF		  := SUC->UC_NFISCAL
	cSeriNF	  := SUC->UC_SERINF
	If Alltrim(SUC->UC_REATIVA ) = "S"
		lReativ := .T.
		If Empty(SUC->UC_DTREATI)
			RECLOCK("SUC", .F.)
			SUC->UC_DTREATI := dDtInclu
			SUC->(MsUnlock())
			dDtREAT := dDtInclu
			
		Else		
			dDtREAT := SUC->UC_DTREATI
		Endif
	Endif
Endif 

If DtoS(dDtInclu) <= '20110315'
	lAntiga := .T.
Endif


SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + cNF + cSeriNF ))
cTransp := SF2->F2_TRANSP
cRedesp := SF2->F2_REDESP

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp))
cNomTransp := SA4->A4_NREDUZ   

SA4->(Dbseek(xFilial("SA4") + cRedesp))
cNomRedesp := SA4->A4_NREDUZ

cCliente := Substr(cSUDChave,1,6)
cLojaCli := Substr(cSUDChave,7,2)	

@ 005,007 SAY "Atendimento" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET SUD->UD_CODIGO					WHEN .F.	PICTURE PesqPict("SUD","UD_CODIGO")		OF oDlg5 SIZE 040,006 PIXEL

@ 005,157 SAY "Item" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 017,157 MSGET SUD->UD_ITEM					WHEN .F.	PICTURE PesqPict("SUD","UD_ITEM")		OF oDlg5 SIZE 040,006 PIXEL 

//////novo
@ 035,007 SAY "Nota Fiscal" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,007 MSGET cNF					WHEN .F.	PICTURE PesqPict("SUC","UC_NFISCAL")		OF oDlg5 SIZE 046,006 PIXEL

@ 035,075 SAY "Transportadora" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,075 MSGET cNomTransp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ") OF oDlg5 SIZE 055,006 PIXEL

@ 035,157 SAY "Redespacho" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,157 MSGET cNomRedesp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ")	OF oDlg5 SIZE 055,006 PIXEL
//////novo

@ 065,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
@ 075,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
@ 075,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
					                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL

@ 095,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 102,003 TO 150,292 OF oDlg5 PIXEL
@ 105,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUD","UD_DTINCLU")		OF oDlg5 SIZE 040,006 PIXEL

@ 095,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 105,157 MSGET cHoraIncl						WHEN .F.	PICTURE PesqPict("SUD","UD_HRINCLU")	    OF oDlg5 SIZE 040,006 PIXEL

@ 120,007 SAY "Observações do Atendimento: " 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 127,007 MSGET Substr(cObsSUD,1,75)						   /*	VALID(!Empty( cObsSUD ))*/ WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL
@ 136,007 MSGET Substr(cObsSUD2,76,52)						   /*	VALID(!Empty( cObsSUD ))*/ WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL

PswOrder(1)
If PswSeek( cSUDResp, .T. )
	aUser      := PSWRET() 				 // Retorna vetor com informações do usuário
	cNomeUser  := Alltrim(aUser[1][2])   // Nome do usuário	
Endif

@ 152,007 SAY "Responsável pelo Atendimento" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 159,003 TO 224,292 OF oDlg5 PIXEL
@ 162,007 MSGET cNomeUser						WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL

@ 177,007 SAY "Data para solução:" 				OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 187,007 MSGET dDataResp						WHEN .T.;
 VALID(!Empty( dDataResp ) .And.dDataResp >= Date() .and. FdtValida(dDataResp, dDtInclu, dDtREAT, lAntiga, lReativ, cAtend, cItemSUD  )  ) PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 202,007 SAY "Obs. do Responsável: " 					OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 209,007 MSGET cObsResp VALID( FObsValida(cObsResp) ) WHEN .T.	PICTURE "@S60"    				OF oDlg5 SIZE 273,006 PIXEL

DEFINE SBUTTON FROM 226,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
DEFINE SBUTTON FROM 226,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	dbSelectArea("SUD")
	dbSetOrder(1)
	//Procura o atendimento (itens) e grava a data de resposta		
	If SUD->(DbSeek(xFilial("SUD")+ cAtend + cItemSUD ))
		While !Eof() .And. SUD->UD_FILIAL == xFilial("SUD") .And.  SUD->UD_CODIGO == cAtend .And. SUD->UD_ITEM == cItemSUD
			
			RecLock("SUD",.F.)
			dDataResp		:= DataValida(dDataResp)
			SUD->UD_DATA	:= dDataResp
			//SUD->UD_OBS  	:= cObsSUD		//Obs do atendimento, agora ficará apenas para o operador preencher.
			SUD->UD_USERESP	:= Substr(cUsuario,7,15)
			SUD->UD_DTRESP  := Date()
			SUD->UD_HRRESP	:= Time()
			SUD->UD_JUSTIFI := cObsResp		//Obs preenchida pelo responsável		
			
			SUD->(MsUnLock())                              
			//FR - 21/11/13
	        ///////////////////////////////////////////////
	        ///ATUALIZA TABELA Z10 - PROCESSOS DEVOLUÇÃO   
	        ///////////////////////////////////////////////
			If SUD->UD_N1 = '0001'
				If SUD->UD_N2 = '0002'
					If SUD->UD_N3 = '0005' 
						DbselectArea("Z10")
						Z10->(DBSETORDER(2))
						If Z10->(Dbseek(xFilial("Z10") + cNF + cSeriNF + cAtend + cItemSUD ))  //se encontrar, complementa o registro com novas informações da NFD
							RecLock("Z10", .F.)
							//Z10->Z10_CODIGO := _SUDX->UD_CODIGO
							//Z10->Z10_ITEM   := _SUDX->UD_ITEM
							//Z10->Z10_NF     := cNOTACLI
							//Z10->Z10_SERINF := cSERINF
							//Z10->Z10_EMINF  := SF2->F2_EMISSAO
							//Z10->Z10_DTDEVO := SF1->F1_DTDIGIT  //DATA EM QUE A NF FOI DEVOLVIDA
							Z10->Z10_STATUS := '02'       //RESPOSTA P/ SAC -> status na X5 -> ZG
							Z10->Z10_DTSTAT := DATE()
							Z10->Z10_HRSTAT := TIME()
							Z10->Z10_USER   := __CUSERID
							Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
							Z10->(MsUnlock())
	                    Endif //seek no Z10
	      			Endif //ud_n3
	      		Endif //ud_n2
	      	Endif //ud_n1
						
							
			dbSelectArea("SUD")
			SUD->(dbSkip())
		EndDo
		
		
		nrEnvio := 0
		lPendente := .F.		//variável lógica para saber se existe um envio/reenvio pendente para resposta
								// ou se a resposta será simplesmente adicionada ao histórico sem reenvio associado
		cQuery := " SELECT TOP 1 ZUD_FILIAL,ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, " +LF
		cQuery += " ZUD_DTENV, ZUD_NRENV, ZUD_OPERAD, ZUD_DTSOL, ZUD_DTRESP, ZUD_OBSRES " +LF
		cQuery += " FROM "+RetSqlName("ZUD")+" ZUD "     +LF
		cQuery += " WHERE RTRIM(ZUD_CODIGO) = '" + Alltrim(cAtend) + "' " +LF
		cQuery += " AND RTRIM(ZUD_ITEM) = '"  + Alltrim(cItemSUD)   + "' " +LF
		cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' " +LF
		cQuery += " AND ZUD.D_E_L_E_T_ = '' " +LF
		cQuery += " ORDER BY ZUD_CODIGO, ZUD_ITEM, ZUD_DTENV+ZUD_NRENV DESC "	 +LF
		Memowrite("C:\Temp\ZUDResp.SQL",cQuery)
		If Select("ZUDX1") > 0		
			DbSelectArea("ZUDX1")
			DbCloseArea()			
		EndIf
		TCQUERY cQuery NEW ALIAS "ZUDX1"
		TCSetField( "ZUDX1", "ZUD_DTSOL"   , "D")
		TCSetField( "ZUDX1", "ZUD_DTRESP"   , "D")
		ZUDX1->(DbGoTop())
		While !ZUDX1->(Eof())		
		
			If Empty(ZUDX1->ZUD_DTRESP)
				nrEnvio 	:= ZUDX1->ZUD_NRENV
				lPendente 	:= .T.
			Endif
			ZUDX1->(Dbskip())
		Enddo
		
		DbSelectArea("ZUD")    
		ZUD->(DbsetOrder(1)) 		//ZUD_CODIGO + ZUD_ITEM + ZUD_DTENV + ZUD_NRENV 
		If lPendente        //se a resposta for respectiva a um envio/reenvio que está sem resposta, gravará nele
			If ZUD->(Dbseek(xFilial("ZUD") + cAtend + cItemSUD ))
				While !ZUD->(EOF()) .and. ZUD->ZUD_CODIGO == cAtend .and. ZUD->ZUD_ITEM == cItemSUD			 	
				 
				 	If ZUD->ZUD_NRENV = nrEnvio   //faz a atualização no registro do último envio (no histórico)
				 		
				 		RecLock("ZUD", .F.)			 		  
				 		
				 		ZUD->ZUD_DTSOL := dDataResp     //data para solução
				 		ZUD->ZUD_OBSRES:= Alltrim(cObsResp)
				 		ZUD->ZUD_DTRESP:= Date()        //data que registrou a resposta
				 		ZUD->ZUD_HRRESP:= Time()
				 		
				 		ZUD->(MsUnlock())
				 	Endif				 	
					ZUD->(DBSKIP())
					
				Enddo
			Endif 
		Else		//caso contrário, isto é, se a resposta que o responsável efetuou é independente de qq envio, irá criar um registro novo
			RecLock("ZUD", .T.)
			ZUD->ZUD_FILIAL := xFilial("SUD")			 		  
	 		ZUD->ZUD_CODIGO:= cAtend
	 		ZUD->ZUD_ITEM  := cItemSUD
	 		ZUD->ZUD_DTSOL := dDataResp     //data para solução
	 		ZUD->ZUD_OBSRES:= Alltrim(cObsResp)
	 		ZUD->ZUD_DTRESP:= Date()        //data que registrou a resposta
	 		ZUD->ZUD_HRRESP:= Time()
	 		ZUD->ZUD_OPERAD:= cSUDResp
	 		ZUD->ZUD_OBSATE:= cObsSUD
	 		ZUD->(MsUnlock())
			
		
		Endif
			
		
		
	Endif
	
	U_ReagRESP( cFil, cAtend, cNF , cSeriNF )        	//refaz o agendamento
	U_TMKRetorno( cAtend, cItemSUD, cCliente, cLojaCli, cNF, cSeriNF, cNomTransp, cNomRedesp ) 				//envia o email para o operador que abriu o atendimento avisando que já existe resposta.


EndIf

RestArea(aAreaSUD)
RestArea(aAreaAtu)

Return(Nil)   

//////visualiza
******************************************************************************************************
User Function TMKVisu()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaSUD	:= SUD->(GetArea())
Local dDataResp	:= SUD->UD_DATA 
Local cObsSUD	:= SUD->UD_OBS //CriaVar("UD_OBS",.F.,.F.)
Local cObsSUD2	:= SUD->UD_OBS 
Local cFil      := SUD->UD_FILIAL
Local cAtend    := SUD->UD_CODIGO
Local cItemSUD  := SUD->UD_ITEM
Local cObsResp  := SUD->UD_JUSTIFI 
Local cEntidade := ""		//vai armazenar se é SA1 ou SA2
Local cSUDChave := ""		//vai armazenar o codigo+loja
Local cCliente  := ""
Local cLojaCli  := ""
Local dDtInclu  := SUD->UD_DTINCLU
Local cHoraIncl := SUD->UD_HRINCLU
Local cSUDResp  := SUD->UD_OPERADO
Local cNomeUser := ""
Local lEfetiv	:= .F.
Local cNF		:= ""
Local cSeriNF	:= ""
Local cTransp	:= ""
Local cNomTransp:= ""
Local cRedesp   := ""
Local cNomRedesp:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local nOpcA		


DEFINE MSDIALOG oDlg5 FROM 000,000 TO 500,590 TITLE "Resposta ao Atendimento" PIXEL

//Esse bloco irá buscar pelo atendimento qual foi a Entidade (SA1 ou SA2) e trazer o nome
SUC->(Dbsetorder(1))
If SUC->(Dbseek(xFilial("SUC") + cAtend ))
	cEntidade := SUC->UC_ENTIDAD
	cSUDChave := SUC->UC_CHAVE
	//dDtInclu  := SUC->UC_DATA
	//cHoraIni  := SUC->UC_INICIO
	cNF		  := SUC->UC_NFISCAL
	cSeriNF	  := SUC->UC_SERINF
Endif 


SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + cNF + cSeriNF ))
cTransp := SF2->F2_TRANSP
cRedesp := SF2->F2_REDESP

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp))
cNomTransp := SA4->A4_NREDUZ   

SA4->(Dbseek(xFilial("SA4") + cRedesp))
cNomRedesp := SA4->A4_NREDUZ

cCliente := Substr(cSUDChave,1,6)
cLojaCli := Substr(cSUDChave,7,2)	

@ 005,007 SAY "Atendimento" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET SUD->UD_CODIGO					WHEN .F.	PICTURE PesqPict("SUD","UD_CODIGO")		OF oDlg5 SIZE 040,006 PIXEL

@ 005,157 SAY "Item" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 017,157 MSGET SUD->UD_ITEM					WHEN .F.	PICTURE PesqPict("SUD","UD_ITEM")		OF oDlg5 SIZE 040,006 PIXEL 

//////novo
@ 035,007 SAY "Nota Fiscal" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,007 MSGET cNF					WHEN .F.	PICTURE PesqPict("SUC","UC_NFISCAL")		OF oDlg5 SIZE 046,006 PIXEL

@ 035,075 SAY "Transportadora" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,075 MSGET cNomTransp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ") OF oDlg5 SIZE 055,006 PIXEL

@ 035,157 SAY "Redespacho" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,157 MSGET cNomRedesp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ")	OF oDlg5 SIZE 055,006 PIXEL
//////novo

@ 065,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
@ 075,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
@ 075,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
					                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL

@ 095,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 102,003 TO 150,292 OF oDlg5 PIXEL
@ 105,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUD","UD_DTINCLU")		OF oDlg5 SIZE 040,006 PIXEL

@ 095,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 105,157 MSGET cHoraIncl						WHEN .F.	PICTURE PesqPict("SUD","UD_HRINCLU")	    OF oDlg5 SIZE 040,006 PIXEL

@ 120,007 SAY "Observações do Atendimento: " 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 127,007 MSGET Substr(cObsSUD,1,75)						    WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL
@ 136,007 MSGET Substr(cObsSUD2,76,52)						    WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL

PswOrder(1)
If PswSeek( cSUDResp, .T. )
	aUser      := PSWRET() 				 // Retorna vetor com informações do usuário
	cNomeUser  := Alltrim(aUser[1][2])   // Nome do usuário	
Endif

@ 152,007 SAY "Responsável pelo Atendimento" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 159,003 TO 224,292 OF oDlg5 PIXEL
@ 162,007 MSGET cNomeUser						WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL

@ 177,007 SAY "Data para solução:" 				OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 187,007 MSGET dDataResp						WHEN .F. PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 202,007 SAY "Obs. do Responsável: " 					OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 209,007 MSGET cObsResp VALID( FObsValida(cObsResp) ) WHEN .F.	PICTURE "@S60"    				OF oDlg5 SIZE 273,006 PIXEL

DEFINE SBUTTON FROM 226,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
DEFINE SBUTTON FROM 226,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

RestArea(aAreaSUD)
RestArea(aAreaAtu)

Return(Nil)   

******************************************************************************************************
User Function TMKLog()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaSUD	:= SUD->(GetArea())
Local dDataResp	:= CriaVar("UD_DATA",.F.,.F.)
Local cObsSUD	:= SUD->UD_OBS //CriaVar("UD_OBS",.F.,.F.)
Local cObsSUD2	:= SUD->UD_OBS 
Local cFil      := SUD->UD_FILIAL

Local cObsResp  := SUD->UD_JUSTIFI //CriaVar("UD_JUSTIFI", .F.,.F.)
Local cEntidade := ""		//vai armazenar se é SA1 ou SA2
Local cSUDChave := ""		//vai armazenar o codigo+loja
Local cCliente  := ""
Local cLojaCli  := ""
Local dDtInclu  := SUD->UD_DTINCLU
Local cHoraIncl := SUD->UD_HRINCLU
Local cSUDResp  := SUD->UD_OPERADO 

Local cNomeUser := ""
Local lEfetiv	:= .F.
Local cNF		:= ""
Local cSeriNF	:= ""
Local cTransp	:= ""
Local cNomTransp:= ""
Local cRedesp   := ""
Local cNomRedesp:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local nOpcA	
Local dDtREAT	  := Ctod("  /  /    ")	

Local lReativ   := .F.   //ESTA VARIÁVEL IRÁ SINALIZAR SE A OCORRÊNCIA FOI REATIVADA OU NÃO, CASO SIM, NÃO IRÁ PRECISAR DE PRAZO PARA SOLUÇÃO 5 DIAS
Local lAntiga   := .F.   //ESTA VARIÁVEL IRÁ SINALIZAR SE A OCORRÊNCIA É ANTIGA - ABERTA ANTES DE 15/03 - CASO POSITIVO, NÃO IRÁ PRECISAR DE PRAZO PARA SOLUÇÃO 5 DIAS

Private cAtend    := SUD->UD_CODIGO
Private cItemSUD  := SUD->UD_ITEM

Private cUserSAC  := SUD->UD_CODUSER

//If Alltrim(cCodResp) != '000161'  
If Alltrim(cCodResp) != '000105' .AND. cCodResp !=  '000003'   //João Emanuel e Alexandre
//Upper(Substr(cUsuario,7,15))  != 'ALEXANDRE' .AND. Upper(Substr(cUsuario,7,15))  != 'JOAO.EMANUEL'
	Aviso(	cCadastro,;
				"Esta Opção é destinada apenas ao Depto. Logística.",;
				{"&Continua"},,;
				"Atendimento/Item: " + SUD->UD_CODIGO + "/" + SUD->UD_ITEM )
	Return(Nil)

ElseIf ( SUD->UD_RESOLVI = "S" .or. SUD->UD_STATUS = "2" )
	Aviso(	cCadastro,;
				"O atendimento já foi resolvido ou encerrado. Contate o SAC.",;
				{"&Continua"},,;
				"Atendimento/Item: " + SUD->UD_CODIGO + "/" + SUD->UD_ITEM )
	Return(Nil)
	
Elseif Empty(SUD->UD_DATA)
	Aviso(	cCadastro,;
				"Não é Permitido encerrar sem Responder.",;
				{"&Continua"},,;
				"Atendimento/Item: " + SUD->UD_CODIGO + "/" + SUD->UD_ITEM )
	Return(Nil) 
EndIf

DEFINE MSDIALOG oDlg5 FROM 000,000 TO 500,590 TITLE "Encerrar Resposta ao Atendimento - Para Logística Utilizar" PIXEL

//Esse bloco irá buscar pelo atendimento qual foi a Entidade (SA1 ou SA2) e trazer o nome
SUC->(Dbsetorder(1))
If SUC->(Dbseek(xFilial("SUC") + cAtend ))
	cEntidade := SUC->UC_ENTIDAD
	cSUDChave := SUC->UC_CHAVE
	//dDtInclu  := SUC->UC_DATA
	//cHoraIni  := SUC->UC_INICIO
	cNF		  := SUC->UC_NFISCAL
	cSeriNF	  := SUC->UC_SERINF
	If Alltrim(SUC->UC_REATIVA ) = "S"
		lReativ := .T.
		If Empty(SUC->UC_DTREATI)
			RECLOCK("SUC", .F.)
			SUC->UC_DTREATI := dDtInclu
			SUC->(MsUnlock())
			dDtREAT := dDtInclu
			
		Else		
			dDtREAT := SUC->UC_DTREATI
		Endif
	Endif
Endif 

If DtoS(dDtInclu) <= '20110315'
	lAntiga := .T.
Endif


SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + cNF + cSeriNF ))
cTransp := SF2->F2_TRANSP
cRedesp := SF2->F2_REDESP

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp))
cNomTransp := SA4->A4_NREDUZ   

SA4->(Dbseek(xFilial("SA4") + cRedesp))
cNomRedesp := SA4->A4_NREDUZ

cCliente := Substr(cSUDChave,1,6)
cLojaCli := Substr(cSUDChave,7,2)	

@ 005,007 SAY "Atendimento" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET SUD->UD_CODIGO					WHEN .F.	PICTURE PesqPict("SUD","UD_CODIGO")		OF oDlg5 SIZE 040,006 PIXEL

@ 005,157 SAY "Item" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 017,157 MSGET SUD->UD_ITEM					WHEN .F.	PICTURE PesqPict("SUD","UD_ITEM")		OF oDlg5 SIZE 040,006 PIXEL 

//////novo
@ 035,007 SAY "Nota Fiscal" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,007 MSGET cNF					WHEN .F.	PICTURE PesqPict("SUC","UC_NFISCAL")		OF oDlg5 SIZE 046,006 PIXEL

@ 035,075 SAY "Transportadora" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,075 MSGET cNomTransp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ") OF oDlg5 SIZE 055,006 PIXEL

@ 035,157 SAY "Redespacho" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,157 MSGET cNomRedesp WHEN .F.	PICTURE PesqPict("SA4","A4_NREDUZ")	OF oDlg5 SIZE 055,006 PIXEL
//////novo

@ 065,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
@ 075,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
@ 075,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
					                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL

@ 095,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 102,003 TO 150,292 OF oDlg5 PIXEL
@ 105,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUD","UD_DTINCLU")		OF oDlg5 SIZE 040,006 PIXEL

@ 095,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 105,157 MSGET cHoraIncl						WHEN .F.	PICTURE PesqPict("SUD","UD_HRINCLU")	    OF oDlg5 SIZE 040,006 PIXEL

@ 120,007 SAY "Observações do Atendimento: " 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 127,007 MSGET Substr(cObsSUD,1,75)						   /*	VALID(!Empty( cObsSUD ))*/ WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL
@ 136,007 MSGET Substr(cObsSUD2,76,52)						   /*	VALID(!Empty( cObsSUD ))*/ WHEN .F.	PICTURE "@S60"	OF oDlg5 SIZE 273,006 PIXEL

PswOrder(1)
If PswSeek( cSUDResp, .T. )
	aUser      := PSWRET() 				 // Retorna vetor com informações do usuário
	cNomeUser  := Alltrim(aUser[1][2])   // Nome do usuário	
Endif

@ 152,007 SAY "Responsável pelo Atendimento" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 159,003 TO 224,292 OF oDlg5 PIXEL
@ 162,007 MSGET cNomeUser						WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL

@ 177,007 SAY "Data para solução:" 				OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 187,007 MSGET dDataResp						WHEN .T.;
VALID(!Empty( dDataResp ).And.dDataResp >= Date() /*dDatabase*/ .and. FdtLog(dDataResp, dDtInclu, dDtREAT, lAntiga, lReativ)  ) PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL
//VALID(!Empty( dDataResp ).And.FdtLog(dDataResp, dDtInclu, dDtREAT, lAntiga, lReativ)  ) PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL 

@ 202,007 SAY "Obs. do Responsável: " 					OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 209,007 MSGET cObsResp VALID( FObsValida(cObsResp) ) WHEN .T.	PICTURE "@S60"    				OF oDlg5 SIZE 273,006 PIXEL

DEFINE SBUTTON FROM 226,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
DEFINE SBUTTON FROM 226,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	dbSelectArea("SUD")
	dbSetOrder(1)
	//Procura o atendimento (itens) e grava a data de resposta		
	If SUD->(DbSeek(xFilial("SUD")+ cAtend + cItemSUD ))
		While !Eof() .And. SUD->UD_FILIAL == xFilial("SUD") .And.  SUD->UD_CODIGO == cAtend .And. SUD->UD_ITEM == cItemSUD
			
			RecLock("SUD",.F.)
			dDataResp		:= DataValida(dDataResp)
			SUD->UD_DATA	:= dDataResp
			//SUD->UD_OBS  	:= cObsSUD		//Obs do atendimento, agora ficará apenas para o operador preencher.
			SUD->UD_USERESP	:= Substr(cUsuario,7,15)
			SUD->UD_DTRESP  := Date()
			SUD->UD_HRRESP	:= Time()
			SUD->UD_JUSTIFI := cObsResp		//Obs preenchida pelo responsável		
			
			SUD->(MsUnLock())
	
			dbSelectArea("SUD")
			SUD->(dbSkip())
		EndDo
	    
		nrEnvio := 0
		lPendente := .F.		//variável lógica para saber se existe um envio/reenvio pendente para resposta
								// ou se a resposta será simplesmente adicionada ao histórico sem reenvio associado
		cQuery := " SELECT TOP 1 ZUD_FILIAL,ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, " +LF
		cQuery += " ZUD_DTENV, ZUD_NRENV, ZUD_OPERAD, ZUD_DTSOL, ZUD_DTRESP, ZUD_OBSRES " +LF
		cQuery += " FROM "+RetSqlName("ZUD")+" ZUD "     +LF
		cQuery += " WHERE RTRIM(ZUD_CODIGO) = '" + Alltrim(cAtend) + "' " +LF
		cQuery += " AND RTRIM(ZUD_ITEM) = '"  + Alltrim(cItemSUD)   + "' " +LF
		cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' " +LF
		cQuery += " AND ZUD.D_E_L_E_T_ = '' " +LF
		cQuery += " ORDER BY ZUD_CODIGO, ZUD_ITEM, ZUD_DTENV+ZUD_NRENV DESC "	 +LF
		Memowrite("C:\Temp\ZUDResp.SQL",cQuery)
		If Select("ZUDX1") > 0		
			DbSelectArea("ZUDX1")
			DbCloseArea()			
		EndIf
		TCQUERY cQuery NEW ALIAS "ZUDX1"
		TCSetField( "ZUDX1", "ZUD_DTSOL"   , "D")
		TCSetField( "ZUDX1", "ZUD_DTRESP"   , "D")
		ZUDX1->(DbGoTop())
		While !ZUDX1->(Eof())		
		
			If Empty(ZUDX1->ZUD_DTRESP)
				nrEnvio 	:= ZUDX1->ZUD_NRENV
				lPendente 	:= .T.
			Endif
			ZUDX1->(Dbskip())
		Enddo
		
		DbSelectArea("ZUD")    
		ZUD->(DbsetOrder(1)) 		//ZUD_CODIGO + ZUD_ITEM + ZUD_DTENV + ZUD_NRENV 
		If lPendente        //se a resposta for respectiva a um envio/reenvio que está sem resposta, gravará nele
			If ZUD->(Dbseek(xFilial("ZUD") + cAtend + cItemSUD ))
				While !ZUD->(EOF()) .and. ZUD->ZUD_CODIGO == cAtend .and. ZUD->ZUD_ITEM == cItemSUD			 	
				 
				 	If ZUD->ZUD_NRENV = nrEnvio   //faz a atualização no registro do último envio (no histórico)
				 		
				 		RecLock("ZUD", .F.)			 		  
				 		ZUD->ZUD_DTSOL := dDataResp     //data para solução
				 		ZUD->ZUD_OBSRES:= Alltrim(cObsResp)
				 		ZUD->ZUD_DTRESP:= Date()        //data que registrou a resposta
				 		ZUD->ZUD_HRRESP:= Time()
				 		
				 		ZUD->(MsUnlock())
				 	Endif				 	
					ZUD->(DBSKIP())
					
				Enddo
			Endif 
		Else		//caso contrário, isto é, se a resposta que o responsável efetuou é independente de qq envio, irá criar um registro novo
			RecLock("ZUD", .T.)			 		  
	 		ZUD->ZUD_CODIGO:= cAtend
	 		ZUD->ZUD_ITEM  := cItemSUD
	 		ZUD->ZUD_DTSOL := dDataResp     //data para solução
	 		ZUD->ZUD_OBSRES:= Alltrim(cObsResp)
	 		ZUD->ZUD_DTRESP:= Date()        //data que registrou a resposta
	 		ZUD->ZUD_HRRESP:= Time()
	 		
	 		ZUD->(MsUnlock())
			
		
		Endif
			
		
		
	Endif
	
	U_ReagRESP( cFil, cAtend, cNF , cSeriNF )        	//refaz o agendamento
	U_TMKRetorno( cAtend, cItemSUD, cCliente, cLojaCli, cNF, cSeriNF, cNomTransp, cNomRedesp ) 				//envia o email para o operador que abriu o atendimento avisando que já existe resposta.


EndIf

RestArea(aAreaSUD)
RestArea(aAreaAtu)

Return(Nil)   




******************************************************************************************************
User Function TMKLeg()
******************************************************************************************************

/*
BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Atendimento Resolvido/Encerrado"} ,;
									{"BR_VERDE" ,	"Atendimento sem Resposta"},;
									{ "BR_AMARELO", "Atendimento Respondido e NÃO Resolvido" },;
									{ "BR_PINK"   , "Atendimento Reenviado" } } )

*/

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Atendimento Resolvido/Encerrado"} ,;
									{"BR_VERDE" ,	"Atendimento sem Resposta"},;
									{ "BR_AMARELO", "Atendimento Respondido" },;
									{ "BR_PINK"   , "REENVIO do Atendimento" } } )

Return .T.

//------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////
////ALTERADO EM 05/10/2010 POR SOLICITAÇÃO DE DANIELA, 
///PARA QUE OS EMAILS RESPOSTA, CONTENHAM TODO O HISTÓRICO
//////////////////////////////////////////////////////////////////


****************************************************************************************************************
User Function TMKRetorno( cAtendim, cItem, cCliente, cLojaCli, cNF, cSeriNF, cNomTransp, cNomRedesp ) 
****************************************************************************************************************



Local aAtend 	:= {}      
Local _nX    	:= 0 
Local lRespondeu:= .F.
Local cQuery	:= ""
Local aRespost	:= {}
Local cExecutor	:= ""
Local aUsuarios := {}
Local eEmail    := ""
Local cRemete   := ""
Local cDesti    := ""
Local cCC       := ""
Local cCorpoHTM := ""
Local cClihtm   := ""
Local cCodUser  := ""
Local cNomeDesti:= ""   // através de UC_OPERADO, irá armazenar o nome do operador que incluiu o atendimento,
						// para que possa ser enviado para ele, o email de resposta do atendimento 
Local cNomeCli		:= "" 
Local cOperado 	:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local cSetor	:= ""  
Local cMailCopia:= ""
Local cCopiaFIN := ""
Local cSuper	:= ""
Local cMailSuper:= ""
Local cVendedor	:= ""

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCliente + cLojaCli ))
cNomeCli := SA1->A1_NREDUZ


SetPrvt("OHTML,OPROCESS") 

cChave    := (cCliente + cLojaCli)
					      
cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_USERESP, UD_ITEM, UD_DATA,UD_MAILCC "+LF
cQuery += " ,UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO, UD_CODUSER "+LF
cQuery += " ,ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_DTENV, ZUD_NRENV, ZUD_HRENV " + LF
cQuery += " ,ZUD_DTSOL, ZUD_OBSRES, ZUD_DTRESP, ZUD_HRRESP, ZUD_OPERAD "+LF
cQuery += " ,UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, UC_OPERADO, UC_ENTIDAD, ZUD.R_E_C_N_O_ RECZUD " + LF

cQuery += " FROM "+RetSqlName("SUD")+" SUD, "+LF
cQuery += " "+RetSqlName("SUC")+" SUC, "+LF
cQuery += " "+RetSqlName("ZUD")+" ZUD "+LF

cQuery += " WHERE RTRIM(UD_CODIGO) = '" + Alltrim(cAtendim) + "' "+LF

cQuery += " AND RTRIM(UD_ITEM) = '"  + Alltrim(cItem)   + "' "+LF
cQuery += " AND RTRIM(UD_RESOLVI) = 'N' "+LF 

cQuery += " AND RTRIM(UD_CODIGO) = RTRIM(ZUD_CODIGO) "+LF
cQuery += " AND RTRIM(UD_CODIGO) = RTRIM(UC_CODIGO) "+LF
cQuery += " AND RTRIM(ZUD_CODIGO) = RTRIM(UC_CODIGO) "+LF

cQuery += " AND RTRIM(UD_ITEM) = RTRIM(ZUD_ITEM) "+LF
cQuery += " AND UD_FILIAL = '"  + xFilial("SUD") + "' AND SUD.D_E_L_E_T_ = '' "+LF
cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' AND ZUD.D_E_L_E_T_ = '' "+LF

//cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM, ZUD_CODIGO, ZUD_ITEM, ZUD_DTENV+ZUD_NRENV "+LF
cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM, ZUD.R_E_C_N_O_ "+LF
Memowrite("C:\Temp\retorno.SQL",cQuery)
			
If Select("RESP") > 0		
	DbSelectArea("RESP")
	DbCloseArea()			
EndIf
			
TCQUERY cQuery NEW ALIAS "RESP"
TCSetField( "RESP", "UD_DATA"   	, "D")
TCSetField( "RESP", "ZUD_DTSOL"   	, "D") 
TCSetField( "RESP", "ZUD_DTRESP"   	, "D")
TCSetField( "RESP", "UD_DTENVIO"   	, "D")
TCSetField( "RESP", "ZUD_DTENV"   	, "D")

         				 
RESP->(DbGoTop())
If !RESP->(EOF())	
	While !RESP->(Eof())								
		cEntidade := RESP->UC_ENTIDAD
		//cOperado := RESP->UC_OPERADO			
		If !Empty(cUserSAC)
			cOperado := cUserSAC
		Else
			cOperado := RESP->UC_OPERADO
		Endif
		//como todos os feedbacks estão sendo gerados em nome da Andreia, mudei para o UD_CODUSER que fica no item
		//da ocorrência (código do usuário gravado automaticamente
		
		If !Empty(Alltrim( RESP->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
						                
	   		Aadd(aRespost, { RESP->UD_CODIGO,;       //1
		       			    RESP->UD_N1,;            	//2
		       			    RESP->UD_N2,;            	//3
		       			    RESP->UD_N3,;            	//4
		       			    RESP->UD_N4,;            	//5
		       			    RESP->UD_N5,;            	//6
		       			    RESP->UD_OPERADO,;       	//7
		       			    cEntidade,;             	//8
		       			    cChave,;            	    //9
		       			    RESP->ZUD_ITEM,;   	    	//10
		       			    RESP->ZUD_DTSOL,;			//11
		       			    RESP->UD_FILIAL,;			//12
		       			    RESP->ZUD_OBSATE,;     		//13		       			    
		        			RESP->ZUD_OBSRES,;			//14
		        			RESP->UD_USERESP,;			//15
		        			RESP->ZUD_DTRESP,;			//16
		        			RESP->ZUD_HRRESP,;			//17
		        			RESP->ZUD_DTENV,;	 		//18
		        			RESP->ZUD_NRENV,; 			//19 
		        			RESP->ZUD_HRENV,;			//20
		        			RESP->UD_MAILCC } )			//21
		        			
		        		
	   	Endif						        
							  		
	   	RESP->(DBSKIP())
	Enddo
	
Else		
 	/////////////////////////////////////////////////////////
  	////se não existir histórico do atendimento corrente... 
   	/////////////////////////////////////////////////////////
   	cQuery := " SELECT UD_FILIAL, UD_CODIGO, UD_ITEM, UD_OPERADO, UC_OPERADO, " +LF
	cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_JUSTIFI, UD_USERESP, UD_DTRESP, UD_HRRESP," +LF
	cQuery += " UC_ENTIDAD, UC_CHAVE , UD_DATA, UD_OBS, UD_DTENVIO, UD_HRENVIO, UD_NRENVIO, UD_MAILCC " +LF
	
	cQuery += " FROM "+RetSqlName("SUC")+ " SUC, " +RetSqlName("SUD") + " SUD " +LF
	cQuery += " WHERE RTRIM(UC_CODIGO) = '" + Alltrim(cAtendim) + "' " +LF
	cQuery += " AND RTRIM(UD_ITEM) = '" + Alltrim(cItem) + "' " +LF
	cQuery += " AND UD_CODIGO = UC_CODIGO " +LF
	cQuery += " AND UC_FILIAL = '" + xFilial("SUC") + "'  "+LF
	cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' " +LF
	cQuery += " AND UD_DATA <> '' " +LF
	cQuery += " AND SUC.D_E_L_E_T_ = '' AND SUD.D_E_L_E_T_ = '' " +LF
	cQuery += " ORDER BY UD_CODIGO, UD_ITEM " +LF
	//Memowrite("C:\retsemhist.SQL",cQuery)
			
	If Select("RESP2") > 0		
		DbSelectArea("RESP2")
		DbCloseArea()			
	EndIf
				
	TCQUERY cQuery NEW ALIAS "RESP2"
	TCSetField( "RESP2", "UD_DATA"   , "D")
	TCSetField( "RESP2", "UD_DTENVIO"   , "D")
	TCSetField( "RESP2", "UD_DTRESP"   , "D")
	
	RESP2->(DbGoTop())
	While !RESP2->(Eof()) 
		cEntidade 	:= RESP2->UC_ENTIDAD
		//cOperado	:= RESP2->UC_OPERADO															
		If !Empty(cUserSAC)
			cOperado := cUserSAC
		Else
			cOperado := RESP->UC_OPERADO
		Endif
		
		If !Empty(Alltrim( RESP2->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
				          
	    	Aadd(aRespost, { RESP2->UD_CODIGO,;      	// 1
         				 RESP2->UD_N1,;             // 2
         				 RESP2->UD_N2,;             // 3
         				 RESP2->UD_N3,;             // 4
         				 RESP2->UD_N4,;             // 5
         				 RESP2->UD_N5,;             // 6
         				 RESP2->UD_OPERADO,;        // 7
        				 cEntidade,;		        // 8
         				 cChave,;					// 9
         				 RESP2->UD_ITEM,;           //10
         				 RESP2->UD_DATA,;           //11
         				 RESP2->UD_FILIAL,;         //12
         				 RESP2->UD_OBS,;			//13
         				 RESP2->UD_JUSTIFI,;      	//14
         				 RESP2->UD_USERESP,;		//15
         				 RESP2->UD_DTRESP,;			//16
         				 RESP2->UD_HRRESP,;			//17
         				 RESP2->UD_DTENVIO,; 		//18
		     			 RESP2->UD_NRENVIO,;		//19 
		        	     RESP2->UD_HRENVIO,;		//20	
		        	     RESP2->UD_MAILCC } )		//21
							        				
			
	    Endif						        
		RESP2->(DBSKIP())
	Enddo

Endif //se não tem histórico 

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO DAS OCORRÊNCIAS
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNF + cSeriNF ))
	cVendedor := SF2->F2_VEND1
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper := SA3->A3_SUPER
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
Endif
//FR - até aqui

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCliente + cLojaCli ))
cNomeCli := SA1->A1_NREDUZ

If Empty(cUserSAC)
	SU7->(Dbsetorder(1))    			////CADASTRO DE OPERADORES DO CALL CENTER
	SU7->(Dbseek(xFilial("SU7") + cOperado ))
	cCodUser := SU7->U7_CODUSU          //USUÁRIO QUE INCLUIU A OCORRÊNCIA (PÓS-VENDAS)
Else
	cCodUser := cUserSAC
Endif

///BUSCA INFORMAÇÕES DO USUÁRIO QUE ABRIU A OCORRÊNCIA (UC_OPERADO)	
PswOrder(1)
If PswSeek( cCodUser, .T. )
	aUsuarios  := PSWRET() 					 	// Retorna vetor com informações do usuário		
	cNomeDesti := Alltrim(aUsuarios[1][2])     	// Nome do usuário
	eEmail     := Alltrim(aUsuarios[1][14])     // e-mail   (do usuário que incluiu a ocorrência ->ex.: Daniela)
Endif
	
cSetor := aRespost[1][3]
cMailCopia := aRespost[1][21] 

//SE O SETOR FOR FINANCEIRO (0050), Irá com cópia para Alessandra
cCC := ""
If Alltrim(cSetor) = '0050'
	//cCopiaFIN := "alessandra@ravaembalagens.com.br"
	cCopiaFIN	:= GetMv("RV_FINMAIL")
	//cCopiaFIN += ";flavia.rocha@ravaembalagens.com.br"
Endif

eEmail := "sac@ravaembalagens.com.br"   //para Daniela


//remetente da msg
cRemete  := "rava@siga.ravaembalagens.com.br"

///Destinatários:
cDesti   := eEmail + ";" + cMailResp      //email do pós-vendas e o email do responsável
//23/09/10 -> Daniela solicitou que incluisse estes emails qdo o responsável registrar sua resposta
///Com cópia:
//cDesti	+= "; " + "marcelo@ravaembalagens.com.br;marcio@ravaembalagens.com.br
//13/08/11 - Flavia Rocha - solicitado retirar o email de Marcelo - chamado 002177 - substituir pelo Rel. Resumo de Ocorrências SAC - WFTMK003
If !Empty(cMailCopia)
	cDesti += ";" + cMailCopia           //email cópia definido na ocorrência
Endif

If !Empty(cCopiaFIN)
	cDesti += ";" + cCopiaFIN           //email da Ass. Financeiro (qdo pertinente)
Endif

If !Empty(cMailSuper)
	cDesti += ";" + cMailSuper          //email do coordenador respectivo a NF
Endif 

If !Empty(cMailSup)
	cDesti += ";" + cMailSup          //email do superior do responsável pela ocorrência
Endif

cCC := "" //"flavia.rocha@ravaembalagens.com.br" //preciso verificar se as respostas estão indo com o histórico

cAssunto := "Retorno a solicitação - Call Center"	

//monta o html para envio
cCorpoHTM := U_GeraHTML(cNomeDesti, cNomeCli, cNF, cSeriNF, cNomTransp, cNomRedesp, aRespost, cMailCopia)	//Enviar para quem incluiu o atendimento e não para o cliente final

//faz o envio:
//cCC := ""
//cDesti := "flavia.rocha@ravaembalagens.com.br"	
U_EnvEMail( cRemete, cDesti, cCC, cAssunto, cCorpoHTM )  //Envia o email com as informações do html
	
	
Return .T.



//-----------------------------------
User Function GeraHTML(cDestino, cNomeCli, cNF, cSeriNF, cNomTransp, cNomRedesp, aRespost, cMailCopia )
//-----------------------------------
//(cNomeDesti, cNomeCli, cNF, cSeriNF, cNomTransp, cNomRedesp, aRespost)
Local cBody   := ""
Local LF      := CHR(13)+CHR(10) 
Local cDtResp := ""

cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LF
cBody += '<html xmlns="http://www.w3.org/1999/xhtml">' + LF
cBody += '<head>' + LF
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />' + LF
cBody += '<title>Call Center</title>' + LF
cBody += '</head>'+ LF
cBody += '	<title>Call Center</title>'+ LF
cBody += '	<style type="text/css">'+ LF
cBody += '	body{'+ LF
cBody += '		/*'+ LF
cBody += '		You can remove these four options '+ LF
cBody += '		*/'+ LF
cBody += '		background-repeat:no-repeat;'+ LF
cBody += '		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;'+ LF
cBody += '		margin:0px;'+ LF
cBody += '	}'+ LF
cBody += '	#ad{'+ LF
cBody += '		padding-top:220px;'+ LF
cBody += '		padding-left:10px;'+ LF
cBody += '	}'+ LF
cBody += '    </style>'+ LF
cBody += '<style type="text/css">'+ LF
cBody += '#calendarDiv{'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	width:205px;'+ LF
cBody += '	border:1px solid #317082;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	background-color: #FFF;'+ LF
cBody += '	font-family:arial;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '	padding-bottom:20px;'+ LF
cBody += '	visibility:hidden;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv span,#calendarDiv img{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox,#calendarDiv .selectBoxOver{'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{	'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	padding:3px;'+ LF
cBody += '	margin:0px;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox{'+ LF
cBody += '	border:1px solid #E2EBED;		'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxOver{'+ LF
cBody += '	border:1px solid #FFF;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '	color: #FFF;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime{'+ LF
cBody += '	border:1px solid #317082;		'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTimeOver{'+ LF
cBody += '	border:1px solid #216072;	'+ LF
cBody += '	color: #216072;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar{'+ LF
cBody += '	height:16px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .activeDay{	/* Active day in the calendar */'+ LF
cBody += '	color:#FF0000;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	text-align:center;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	bottom:0px;'+ LF
cBody += '	width:201px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate div{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	width:72px;'+ LF
cBody += '	color:#FFF;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	right:0px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker{'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	border:1px solid #AAAAAA;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	left:0px;'+ LF
cBody += '	top:15px;'+ LF
cBody += '	z-index:1000;'+ LF
cBody += '	display:none;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv #monthSelect{'+ LF
cBody += '	width:70px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker div{'+ LF
cBody += '	float:none;'+ LF
cBody += '	clear:both;	'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	margin:1px;	'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearActive{'+ LF
cBody += '	background-color:#317082;'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	text-align:right;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar img{'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '/style>'+ LF

	
cBody += '<style type="text/css">'+ LF
cBody += '<!--'+ LF
cBody += '.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }'+ LF
cBody += '.style21 {font-family: Arial, Helvetica, sans-serif}'+ LF
cBody += '.style22 {color: #FFFFFF}'+ LF
cBody += '.style26 {font-size: 14px}'+ LF
cBody += '-->'+ LF
cBody += '    </style>'+ LF
cBody += '</head>'+ LF
cBody += '<script language="JavaScript">'+ LF
/*-----------------------------------------------------------------------
Máscara para o campo data dd/mm/aaaa hh:mm:ss
Exemplo: <input maxlength="16" name="datahora" onKeyPress="DataHora(event, this)">
-----------------------------------------------------------------------*/
cBody += 'function Data(evento, objeto){'+ LF
cBody += '	var keypress=(window.event)?event.keyCode:evento.which;'+ LF
cBody += '	campo = eval (objeto);'+ LF
cBody += '	if (campo.value == "00/00/00")'+ LF
cBody += '	{'+ LF
cBody += '		campo.value="" '+ LF
cBody += '	}'+ LF

cBody += '	caracteres = "0123456789";'+ LF
cBody += "	separacao1 = '/';"+ LF
cBody += '	conjunto1 = 2;'+ LF
cBody += '	conjunto2 = 5;'+ LF
cBody += '	conjunto3 = 8;'+ LF
cBody += '	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))'+ LF
cBody += '	{'+ LF
cBody += '		if (campo.value.length == conjunto1 )'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '		else if (campo.value.length == conjunto2)'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '	}'+ LF
cBody += '	else'+ LF
cBody += '		event.returnValue = false;'+ LF
cBody += '}'+ LF
cBody += '</script>'+ LF
//AQUI COMEÇA MESMO O HTML DA RAVA
cBody += '<body>'+ LF
cBody += '<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">'+ LF
cBody += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
cBody += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
cBody += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF

cBody += '<p class="style20">======================================<BR>'+LF
//cBody += 'Cc: Marcelo Viana, Marcio Andrade<BR>'+ LF 
cBody += 'Cc: ' + cMailCopia + '<BR>'+LF
cBody += '======================================</p>'+LF

cBody += '<p class="style20">Prezado(a) '+ cDestino +',</p>'+ LF         //Operador do pós-vendas (Daniela)

cBody += '<p class="style20">Referente a:<br>'+ LF
cBody += 'Cliente: '+ cNomeCli +'<br>'+ LF
cBody += 'Nota Fiscal: '+ cNF +'/' + cSeriNF + '<br>'+ LF
cBody += 'Transportadora: '+ cNomTransp +'<br>'+ LF
cBody += 'Redespacho: '+ cNomRedesp +'</p>'+ LF

cBody += '<p class="style20">A(s) ocorrência(s) abaixo foi(ram) respondida(s) por <strong>' + aRespost[1,15] + '</strong>,responsável pela ação,conforme abaixo:<br />'+ LF
cBody += '      <br />  '+ LF
cBody += '<table width="863" height="56" border="1">'+ LF
cBody += '  <tr>'+ LF
cBody += '    <td width="92" height="20" bgcolor="#00CC66"><span class="style9 style21 style22">Atendimento </span></td>'+ LF
cBody += '    <td width="68" bgcolor="#00CC66"><span class="style9 style21 style22">Item</span></td>'+ LF
cBody += '    <td width="587" bgcolor="#00CC66"><span class="style9 style21 style22">Problema</span></td>'+ LF
cBody += '    <td width="587" bgcolor="#00CC66"><span class="style9 style21 style22">Obs. do Atendimento</span></td>' + LF 
cBody += '    <td width="88" bgcolor="#00CC66"><span class="style9 style21 style22">Dt.Envio</span></td>'+ LF
cBody += '    <td width="88" bgcolor="#00CC66"><span class="style9 style21 style22">Hr.Envio</span></td>'+ LF
cBody += '    <td width="88" bgcolor="#CBC967"><span class="style9 style21 style22">Dt.Resposta (dd/mm/aa) </span></td>'+ LF
cBody += '    <td width="88" bgcolor="#CBC967"><span class="style9 style21 style22">Hr.Resposta</span></td>'+ LF
cBody += '    <td width="88" bgcolor="#CBC967"><span class="style9 style21 style22">Dt.Soluç&atilde;o (dd/mm/aa) </span></td>'+ LF
cBody += '    <td width="587" bgcolor="#CBC967"><span class="style9 style21 style22">Obs. do Responsável.</span></td>' + LF
cBody += '    </tr>'+ LF


/*
Aadd(aRespost, { RESP2->UD_CODIGO,;      	// 1
         				 RESP2->UD_N1,;             // 2
         				 RESP2->UD_N2,;             // 3
         				 RESP2->UD_N3,;             // 4
         				 RESP2->UD_N4,;             // 5
         				 RESP2->UD_N5,;             // 6
         				 RESP2->UD_OPERADO,;        // 7
        				 cEntidade,;		        // 8
         				 cChave,;					// 9
         				 RESP2->UD_ITEM,;           //10
         				 RESP2->UD_DATA,;           //11
         				 RESP2->UD_FILIAL,;         //12
         				 RESP2->UD_OBS,;			//13
         				 RESP2->UD_JUSTIFI,;      	//14
         				 RESP2->UD_USERESP,;		//15
         				 RESP2->UD_DTRESP,;			//16
         				 RESP2->UD_HRRESP,;			//17
         				 RESP2->UD_DTENVIO,; 		//18
		     			 RESP2->UD_NRENVIO,;		//19 
		        	     RESP2->UD_HRENVIO } )		//20	
*/


For _nX := 1 to Len(aRespost)
		cBody += '  <tr>'+ LF	   
	   cBody += '    <td height="26"><span class="style7 style21 style26">' + aRespost[_nX,1] + '</span></td>'+ LF    //atendimento
	   cBody += '    <td><span class="style26">' + aRespost[_nX,10] + '</span></td>'+ LF                              //item
	   cBody += '    <td><span class="style7 style21 style26">' +;                                                   //problema
	   		iif(!Empty(aRespost[_nX,2]),     Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,2],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,3],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,4],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,5],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,6],"Z46_DESCRI"),"" )  
	   cBody += '</span></td>'+ LF
	   	   
	   cBody += '	 <td><span class="style7 style21 style26">' + aRespost[_nX,13] + '</span></td>' + LF     		//Observação do atendto.
	   cBody += '    <td><span class="style7 style21 style26">' + DtoC( aRespost[_nX,18] ) + '</span></td>'+ LF		//dt.envio
	   cBody += '    <td><span class="style7 style21 style26">' + aRespost[_nX,20] + '</span></td>'+ LF				//hr.envio
	   cBody += '    <td><span class="style7 style21 style26">' + DtoC( aRespost[_nX,16] ) + '</span></td>'+ LF		//dt.resposta
	   cBody += '    <td><span class="style7 style21 style26">' + aRespost[_nX,17] + '</span></td>'+ LF				//hr.resposta
   	   cBody += '    <td><span class="style7 style21 style26">' + DtoC( aRespost[_nX,11] ) + '</span></td>'+ LF		//dt.solução
	   cBody += '	 <td><span class="style7 style21 style26">' + aRespost[_nX,14] + '</span></td>' + LF     		//Observação responsável   
	   cBody += '    </tr>'+ LF		
Next _nX


cBody += '</table>'+ LF
cBody += '  <p>	  '+ LF
cBody += '  </p>'+ LF
cBody += '	<div id="debug"></div>'+ LF
cBody += '</form>'+ LF
cBody += '</body>'+ LF
cBody += '</html>'+ LF   

Return(cBody)

**************************************************************************
User function EnvEMail( cDe, cPara, cCcopia, cAssunto, cMsgBody )
**************************************************************************


local cServRAV		   := alltrim(GetMV("MV_RELSERV"))   //smtp.siga.ravaembalagens.com.br
local cContaRAV		   := alltrim(GetMV("MV_RELACNT"))   //rava@siga.ravaembalagens.com.br
local cSenhaRAV		   := alltrim(GetMV("MV_RELPSW"))    //admnet1311
local lEnviou		   := .F.
local lConectado	   := .F.
local cMailError	   := ""




CONNECT SMTP SERVER cServRAV ACCOUNT cContaRAV PASSWORD cSenhaRAV Result lConectado


If lConectado

	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )

	SEND MAIL FROM cDe ;
	To cPara ;
	Cc cCcopia ;
	SUBJECT	cAssunto ;
	Body cMsgBody FORMAT TEXT;
	RESULT lEnviou
	
	
	If !( lEnviou )
		GET MAIL ERROR cMailError
		MsgBox("Nao foi possivel enviar o email."+chr(13)+chr(10)+;
		"Procure o Administrador da rede."+chr(13)+chr(10)+;
		"Erro retornado: " + cMailError )
	Else
	    MsgInfo("E-Mail enviado com sucesso!")
	    conout(Replicate("*",60))
	    conout("Call Center - TMKC003")
		conout( "Email: " + cAssunto + "-" + Dtoc( Date() ) + ' - ' + Time() )
		conout( "Para: " + cPara + " / " + cCcopia )
		conout("E-mail enviado com sucesso.")
		conout(Replicate("*",60))			
	Endif
	

	DISCONNECT SMTP SERVER
Else
	// Se nao conectou ao servidor de email, avisa ao usuario
	GET MAIL ERROR _cMailError
	MsgBox("Nao foi possivel conectar ao Servidor de email."+chr(13)+chr(10)+;
	"Procure o Administrador da rede." + chr(13)+chr(10)+;
	"Erro retornado: "+ _cMailError )	

Endif

return lConectado .and. lEnviou



******************************************************************************************
Static function FdtValida( dData, dtInclu, dDtREAT, lAntiga, lReativ, cAtend, cItemSUD  )   
******************************************************************************************

//FdtValida(dDataResp, dDtInclu, dDtREAT, lAntiga, lReativ )
///No dia 03/03/11 - Daniela solicitou que a margem de dias para a solução deve ser = Data da Inclusão + 6 dias úteis
///OU seja, o responsável não poderá inserir uma data para solução maior que 5 dias além do prazo que ele tem para responder (1 dia para responder)

Local lValeDT 		:= .F.
Local nDiaSemana 	:= 0
Local dPrazo	   	:= Ctod("  /  /    ") 
Local nX 
Local lIndefinido   := .F.
Local nPrazoUM      := 0  // FR -> ESPECIFICA QDO HÁ UM TIPO DE OCORRÊNCIA EM QUE A SOLUÇÃO DEVERÁ SER ATÉ NO MÁXIMO UM DIA APÓS A DATA DO DIA (DATE).
						  //E NÃO 5 DIAS, COM É O PADRÃO
nPrazoUM := Prazo1(cAtend, cItemSUD)    //retorna 1 ou 5

nDiaSemana := DOW( dData )
/////////////////////////////////////////////////
////calculo do prazo para digitação da solução
////////////////////////////////////////////////
If !lReativ	
	If nPrazoUM >= 5
		For nX := 1 to 5
			If nX = 1
				dPrazo := DataValida(dtInclu + 1)
			Else
				dPrazo := DataValida(dPrazo + 1)
				//fórmula: data da inclusão + 5 dias úteis
				//se incluiu dia 15/03 o prazo seria dia 20, mas como são dias úteis, será dia 22/03 (sábado 19/03 e domingo 20/03)
			Endif
			If Dow(dPrazo) = 7  //se cair no sábado, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif					
			If Dow(dPrazo) = 1  //se cair no domingo, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif
						
		Next
	Else
		dPrazo := DataValida(dtInclu + 1) 		
	Endif

Else       //se o atendimento foi reativado, irá calcular o prazo com base na data de reativação do mesmo			
	If nPrazoUM >= 5
		For nX := 1 to 5
			If nX = 1
				If dtInclu < dDtREAT
					dPrazo := DataValida(dDtREAT + 1)
				Else
					dPrazo := DataValida(dtInclu + 1)
				Endif
			Else
				dPrazo := DataValida(dPrazo + 1)
				//fórmula: data da reativação + 5 dias úteis				
			Endif
			If Dow(dPrazo) = 7  //se cair no sábado, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif					
			If Dow(dPrazo) = 1  //se cair no domingo, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif
		Next
	Else
		dPrazo := DataValida(dDtREAT + 1)
	Endif
Endif
///fim do cálculo

lIndefinido := PRZIndefinido( cAtend , cItemSUD) 
If lIndefinido 
	lValeDT := .T.   //se o prazo for indefinido, para este tipo de ocorrência, nem faz as validações abaixo, já retorna .T.
Endif

If Upper(Substr(cUsuario,7,15))  != 'DANIELA' .and. Upper(Substr(cUsuario,7,15))  != 'ADMIN' 
//.and. Upper(Substr(cUsuario,7,15))  != 'FLAVIA.ROCHA'  //;
  //.and. Alltrim(cCodResp) != '000105'

	If !lIndefinido //se o prazo não for indefinido, irá calcular normalmente o prazo solução de até 5 dias úteis	
		If !lAntiga			
			If dData <= dPrazo
				If nDiaSemana = 1
					MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
					lValeDT := .F.
				Elseif nDiaSemana = 7
					MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
					lValeDT := .F.
				Else
					lValeDT := .T.
				Endif				
			Else
				Aviso(	"Mensagem:",;
						"A Data para Solução digitada, ultrapassa o prazo MÁXIMO permitido ( " + STR(nPrazoUM) + " dia(s) útil(eis) ). Prazo: " + Dtoc(dPrazo) + ;
						". Caso seja necessário um prazo Maior, favor contatar o Responsável pelo SAC.",;
						{"&Continua"},,;
						"Atendimento/Item: " + Alltrim(cAtend) + "/" + Alltrim(cItemSUD) )
				lValeDT := .T. //não bloquear mais o prazo maior que 5 dias, avisa mas nao bloqueia.
			Endif				
		Else   //se a ocorrência for antiga, não fará a crítica do prazo de 5 dias para solução.
			If nDiaSemana = 1
				MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
				lValeDT := .F.
			Elseif nDiaSemana = 7
				MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
				lValeDT := .F.
			Else
				lValeDT := .T.
			Endif
		Endif   //endif se é ocorrência antiga
			
	Else  //se o tipo da ocorrência pedir solução com prazo = 1 dia...
	/*
		If dData <= dPrazo
			If nDiaSemana = 1
				MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
				lValeDT := .F.
			Elseif nDiaSemana = 7
				MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
				lValeDT := .F.
			Else
				lValeDT := .T.
			Endif				
		Else
			Aviso(	"Mensagem:",;
					"A Data para Solução digitada, ultrapassa o prazo permitido (5 dias úteis). Prazo: " + Dtoc(dPrazo) + ;
					". Caso seja necessário um prazo Maior, favor contatar o Responsável pelo SAC.",;
					{"&Continua"},,;
					"Atendimento/Item: " + Alltrim(cAtend) + "/" + Alltrim(cItemSUD) )
			lValeDT := .F.
		Endif
		*/
		lValeDT := .T.			
	Endif //if do indefinido	
 
Else 		//somente o responsável pelo SAC poderá digitar uma data para solução além do prazo (5 dias úteis)
	
	
	If nDiaSemana = 1
		MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
		lValeDT := .F.
	Elseif nDiaSemana = 7
		MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
		lValeDT := .F.
	Else
		lValeDT := .T.
	Endif	

Endif

return(lValeDT)      
                     
                    
                    
*********************************
Static function FdtLog( dData, dtInclu, dDtREAT, lAntiga, lReativ  )   
*********************************
///Em  28/06/11 Daniela solicitou que fosse criado o botão "Encerrar" na tela de respostas do responsável
///Servirá para que a Logística possa ter um prazo maior quando tiver que colocar a data final que resolveu a ocorrência.
///Prazo será de 5 dias + 2 dias ( 7 dias úteis) para a data digitada como solução.

Local lValeDT 		:= .F.
Local nDiaSemana 	:= 0
Local dPrazo	   	:= Ctod("  /  /    ") 
Local nX 

nDiaSemana := DOW( dData )
	
If !lReativ	
	For nX := 1 to 7
		If nX = 1
			dPrazo := DataValida(dtInclu + 1)
		Else
			dPrazo := DataValida(dPrazo + 1)
			If Dow(dPrazo) = 7  //se cair no sábado, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif
			
			If Dow(dPrazo) = 1  //se cair no domingo, soma 1
				dPrazo := DataValida(dPrazo + 1)
			Endif
			//fórmula: data da inclusão + 7 dias úteis
		Endif
	Next
	//msgbox("prazo: " + dtoc(dPrazo))
	
Else       //se o atendimento foi reativado, irá calcular o prazo com base na data de reativação do mesmo

	For nX := 1 to 7
		If nX = 1
			If dtInclu < dDtREAT
				dPrazo := DataValida(dDtREAT + 1)
			Else
				dPrazo := DataValida(dtInclu + 1)
			Endif
		Else
			dPrazo := DataValida(dPrazo + 1)
			//fórmula: data da reativação + 5 dias úteis
	
		Endif
	Next
	//msgbox("prazo: " + dtoc(dPrazo))
Endif

If !lAntiga
	
	If dData <= dPrazo
		If nDiaSemana = 1
			MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
			lValeDT := .F.
		Elseif nDiaSemana = 7
			MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
			lValeDT := .F.
		Else
			lValeDT := .T.
		Endif
	
	Else
		Aviso(	"Mensagem:",;
					"A Data para Solução digitada, ultrapassa o prazo permitido de ENCERRAMENTO Logística (7 dias úteis). Prazo: " + Dtoc(dPrazo) + ;
					". Caso seja necessário um prazo Maior, favor contatar o Responsável pelo SAC.",;
					{"&Continua"},,;
					"Atendimento/Item: " + Alltrim(cAtend) + "/" + Alltrim(cItemSUD) )
		lValeDT := .F.
	Endif
		
Else   //se a ocorrência for antiga, não fará a crítica do prazo de 7 dias para solução
	If nDiaSemana = 1
		MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
		lValeDT := .F.
	Elseif nDiaSemana = 7
		MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
		lValeDT := .F.
	Else
		lValeDT := .T.
	Endif
		
Endif


return(lValeDT)      
                    
                    

*********************************
Static function FObsValida( cObs )   
*********************************

Local lNaoVazio	:= .F.

If Empty(cObs)
	MsgAlert("Por favor, este campo deve ser preenchido !!","Alerta")
	lNaoVazio := .F.
Else	
	lNaoVazio := .T.
Endif


return(lNaoVazio)      

*****************************************************
Static Function PRZIndefinido( cAtend , cItemSUD)
*****************************************************

Local lRet := .F.
SUD->(DBSETORDER(1))
If SUD->(Dbseek(xFilial("SUD") + cAtend + cItemSUD ))
	////COMERCIAL
	If Alltrim(SUD->UD_N1) = '0001'      //reclamação
		If Alltrim(SUD->UD_N2) = '0034'              //comercial
			If Alltrim(SUD->UD_N3) = '0035'                     //produto
				If Alltrim(SUD->UD_N4) = '0100'						//FALHA
					lRet := .T.					
				Endif
			Endif
		Endif
	Endif
	///////LICITAÇÃO
	//If Alltrim(SUD->UD_N1) = '0001'      //reclamação
		If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
			//Em 29/01/13 - Daniela solicitou que o prazo para Licitação seja indefinido, independente do assunto
			//If Alltrim(SUD->UD_N3) = '0076'                     //produto
			//	If Alltrim(SUD->UD_N4) = '0077'						//FALHA
					lRet := .T.	   //retorna TRUE para prazo INDEFINIDO			
			//	Endif
			//Endif
			//msgbox("Licitação")
		Endif
	//Endif
Endif

Return(lRet)

//FR - Em 03/05/12 - Daniela solicitou que a contagem do prazo para solução, neste tipo de ocorrência fosse apenas UM DIA
//então faço função abaixo para validar se a ocorrência se enquadra nesse filtro:
*******************************************
Static Function Prazo1(cAtend, cItemSUD)
*******************************************

Local lRetorno := .F.
Local nDias    := 5

If Alltrim(SUD->UD_N1) = '0001'      //reclamação
	If Alltrim(SUD->UD_N2) = '0034'              //COMERCIAL
		If Alltrim(SUD->UD_N3) = '0063'                     //CADASTRO CLIENTE
			lRetorno := .T.				
		Endif
	Endif
Endif 

If lRetorno
	nDias := 1
Endif


 

Return(nDias)