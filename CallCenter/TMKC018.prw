#include "rwmake.ch"        
#include "topconn.ch"

/* 
///////////////////////////////////////////////////////////////////
//Programa: TMKC018                                              //
//Objetivo: Apresenta tela modelo 3 do Atendimento do Call Center//
//          É chamada através da U_TK271CALL (U_TMKC014)         //
//Autoria : Flávia Rocha                                         //
//Data    : 18/02/2010.                                          //
///////////////////////////////////////////////////////////////////
*/



*************
User Function TMKC018( cEntidade, cUCcodigo, cUCNF, cUCserie, lAltera )
*************

Local aOrdem   		:= {}
Local aHeader2 		:= {}
Private aHeader	:= {}
Private nUsado		:= 0
Private cCadastro	:= "FeedBack dos Atendimentos"
Private aCols	:= {} 
Private lMSErroAuto := .F.
Private lMsHelpAuto := .F.
Private aSvAtela    := {{},{}}
Private aSvAGets    := {{},{}}
Private aTela       :={}
Private aGets       :={} 
Private cChave		:= ""
Private cUsuario	:= ""

Private aRotina := {{"Pesquisar" , "AxPesqui", 0 , 1},;
            {"Visualizar", "U_SUCVis", 0 , 2},;
            {"Incluir"   , "U_SUCInc", 0 , 3},;
            {"Alterar"   , "U_SUCAlt", 0 , 4}}


cUsuario := __CUSERID

aAltEnChoice := {}	//CAMPOS P/ ALTERAR NA ENCHOICE
nCnt    := 0
nOpca   := 4
//aColunas   := {}

lGrava	:= .F.
lHabilita := .F.
lAchou	:= .F.  
cCABALIAS := "SUC"		//CABEÇALHO
cITEALIAS := "SUD"  	//ITENS

DbselectArea("SUC")
Dbsetorder(1)
If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))
	cChave := SUC->UC_CHAVE
	lAchou := .T.
Else
	Msgbox("Atendimento não localizado")
Endif

If lAchou
	//////CAMPOS P/ MOSTAR NO GETDADOS/ITEM
	aAltGetDados := {"UD_PRODUTO", "UD_DESCPRO", "UD_N1", "UD_DN1", "UD_N2", "UD_DN2", "UD_N3", "UD_DN3", "UD_N4", "UD_DN4", "UD_N5", "UD_DN5",;
				     "UD_OPERADO", "UD_DESCOPE", "UD_OBS", "UD_DATA" , "UD_RESOLVI", "UD_FLAGAT", "UD_CODUSER", "UD_MAILCC", "UD_STATUS", "UD_JUSTIFI" }  
	//////CAMPOS P/ NAO MOSTAR NO GETDADOS/ITEM
	aCpoGetDados := {"UD_DTEFETI", "UD_EFETIVO",  "UD_GRADE", "UD_EVENTO", "UD_ASSUNTO",;
				     "UD_OCORREN", "UD_DESCOCO", "UD_SOLUCAO", "UD_DESCSOL","UD_DESCASS", "UD_DTEXEC", "UD_OBSEXEC" }	
	
	aCpoEnChoice := {"UC_CODIGO","UC_CODCONT","UC_DESCCHA", "UC_PENDENT", "UC_NFISCAL","UC_SERINF", "UC_RETENC", "UC_OBS" }  //CAMPOS P/ MOSTRAR NA ENCHOICE
	                               
	For nI := 1 to Len(aCpoGetDados)
	   aCpoGetDados[nI] := Padr(aCpoGetDados[nI],10)
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o aHeader e o aCols estiverem declarados (se esta       ³
	//³rotina estiver sendo chamada de outra qq, como o MATA103), ³
	//³guardo os valores dos mesmos para depois restaurar.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If (Type("aHeader")!="U")
		_aHeaderSave := aClone(aHeader)
		_aColsSave   := aClone(aCols)    
		aHeader      := {}
		aCols        := {}
	EndIf
	*/
	
	RegToMemory("SUD",.F., .F.)
	//MontaHead()	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cITEALIAS )
	While !Eof() .And. (X3_ARQUIVO == cITEALIAS)
	   nPosNao := Ascan(aCpoGetDados,X3_CAMPO)      //faz scan no array dos campos que não são para serem mostrados, se igual = 0, não achou, então entra no aheader
	   IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. Empty(nPosNao) 
	    nUsado:=nUsado+1
	    AADD(aHeader,{ Trim(X3Titulo()), ;
	                  X3_CAMPO,;
	                  X3_PICTURE, ;
	                  X3_TAMANHO, ;
	                  X3_DECIMAL, ;
	                  "AllwaysTrue()" , ;
	                  X3_USADO,;
	                   X3_TIPO, ;
	                   X3_ARQUIVO,;
	                   X3_CONTEXT } )
	   
	   ELSEIF (AllTrim(X3_CAMPO) == "UD_ITEM" .OR. X3_CAMPO == "UD_PRODUTO" .OR. X3_CAMPO == "UD_OPERADO" .OR. X3_CAMPO == "UD_OBS" .OR. X3_CAMPO == "UD_DESCOPE" )
	    nUsado:=nUsado+1
	    AADD(aHeader,{ Trim(X3Titulo()), ;
	                  X3_CAMPO,;
	                  X3_PICTURE, ;
	                  X3_TAMANHO, ;
	                  X3_DECIMAL, ;
	                  "AllwaysTrue()" , ;
	                  X3_USADO,;
	                   X3_TIPO, ;
	                   X3_ARQUIVO,;
	                   X3_CONTEXT } )   
	   EndIF
	   dbSkip()
	Enddo 

	
	MontaCols2( cUCcodigo )	
	cUDcodigo 	:= cUCcodigo	
	lRet := FRMod3( cCadastro, cCABALIAS, cITEALIAS, aCpoEnChoice, "U_TMKLINOK", "U_TMKLINOK", 2, 4,,.F.,999, aAltEnchoice, "", aAltGetDados )	
	If lRet	
		
		If lAltera
			lGrava := FR272Grv(	cUCNF, cUCserie, cEntidade, cChave, cUDcodigo , nOpca, .F., nil)
		    If lGrava
		    	MsgInfo("Dados gravados com sucesso!")
		    Else 
		    	Msgbox("Não gravou")
		    Endif
	    Endif
	
	Endif
Endif	

Return

******************************************
Static Function MontaCols2( cUCcodigo )
******************************************

Local cUdcodigo := ""
Local cQuery 	:= ""
Local aItens	:= {}

cCABALIAS := "SUC"		//CABEÇALHO
cITEALIAS := "SUD"  	//ITENS

//aColunas := {}


DbSelectArea( cITEALIAS )
DbSetOrder(1)
If DbSeek( xFilial( cITEALIAS ) + cUCcodigo )
	cUdcodigo := SUD->UD_CODIGO
Endif

While !Eof() .And. SUD->UD_CODIGO == cUdcodigo .and. xFilial( cITEALIAS ) == SUD->UD_FILIAL
  AADD(aCols,Array(nUsado+1))
  For _ni:=1 to nUsado
    If ( aHeader[_ni][10] != "V")
      aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
    
    Elseif ( aHeader[_ni,2] == 'UD_DN1' .or. aHeader[_ni,2] == 'UD_DN2' .or. aHeader[_ni,2] == 'UD_DN3';
      .or. aHeader[_ni,2] == 'UD_DN4' .or. aHeader[_ni,2] == 'UD_DN5' )
      	//aCols[Len(aCols),_ni] :=  CriaVar(aHeader[_ni,2],.t.)       
      	aCols[Len(aCols),_ni] := Posicione("Z46",1,xFilial("Z46") + &(Substr( aHeader[_ni,2],1,3) + Substr( aHeader[_ni,2], 5,2 )) ,"Z46_DESCRI")
    Else
      	aCols[Len(aCols),_ni] :=  CriaVar(aHeader[_ni,2],.t.)   
    EndIf
  Next
  aCols[Len(aCols),nUsado+1]:=.F.
  dbSkip()
EndDo



Return

****************************************************************
Static Function FRMod3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze)
****************************************************************


Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno()),oDlg
Local oEnchoice
Local cTudoOk 	:= "U_fVldEncerr"

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE := If(nOpcE==Nil,3,nOpcE)
nOpcG := If(nOpcG==Nil,3,nOpcG)
lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 38,120	of oMainWnd

oEnchoice := Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{25,1,70,315},aAltEnchoice,3,,,,,,lVirtual)

oGetDados := MsGetDados():New(75,1,143,315,nOpcG,cLinOk,cTudoOk,"",.T.,,nFreeze,,nLinhas,cFieldOk)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1, If(oGetDados:TudoOk(), oDlg:End() ,nOpca := 0)},{||oDlg:End()}),;
AlignObject(oDlg,{oEnchoice:oBox,oGetDados:oBrowse},1,,{110})) 


lRet:=( nOpca ==1 )

Return ( lRet )

***********************************
User Function fVldEncerr()

Local lRet		:= .T.
Local lSenha	:= .F.
Local aArea		:= getArea()
Local cUdResolvBase	:= ""
Local nPosCod	:= aScan( aHeader, {|x| alltrim(x[2]) == "UD_CODIGO" }) 
Local nPosIT	:= aScan( aHeader, {|x| alltrim(x[2]) == "UD_ITEM" }) 
Local nPosRes	:= aScan( aHeader, {|x| alltrim(x[2]) == "UD_RESOLVI" }) 

For x := 1 To Len( aCOLS )
	If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada
	
		dbSelectArea("SUD")
		dbSetOrder(1)
		If	SUD->(DbSeek(xFilial("SUD") + aCols[x][ nPosCod ] + aCols[x][ nPosIT ] ))
			cUdResolvBase	:= SUD->UD_RESOLVI
		EndIf
							
		If aCols[x][ nPosRes ] == 'S' .and. cUdResolvBase <> 'S'
			lSenha	:= .T.
		EndIf
		
		cUdResolvBase	:= ""
		
    EndIf
Next

If lSenha

	MSGAlert("Para finalizar um atendimento, necessita da autorização da diretoria!")
	if U_Senha2("07",1)[1]
		lRet := .T.
	Else
		lRet := .F.
	EndIf

EndIf

RestArea(aArea)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Tk271GrvTmk³                              ³ Data ³01/02/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function FR272GrvTmk( cUDcodigo, nOpc, l380, aSx3SUC)
Static Function FR272Grv( cUCNF, cUCserie, cEntidade, cChave, cUDcodigo, nOpc, l380, aSx3SUC)

Local lTMKMOK	 := FindFunction("U_TMKMOK")				// P.E. no TMK
Local lTMKGRAVA  := FindFunction("U_TMKGRAVA")				// P.E. no TMK	
Local cMay		 := ""										// Variavel auxiliar
Local cHisTmk    := ""										// Monta a descricao do historico
Local cNumAux	 := cUDcodigo 								// Variavel auxiliar
Local cCampo     := ""										// Variavel auxiliar para o SX3
Local bCampo    											// Macro do SX3
Local nY		 := 0                               		// Contador de Linhas 
Local nX 		 := 0										// Contador de Colunas
Local cI		 := "00"									// Inicializador do ITEM para SUD
Local lNovo      := .F.										// Flag para o Reclock TRUE (inclusao) ou FALSE (alteracao)
Local nPos 		 := 0 										// Contador
Local nPosSUC	 := 0										// Posicao atual do registro do SUC na tabela
Local cCidade	 := ""										// Cidade do contato	
Local cEst		 := ""										// Estado do contato
Local cTelRes	 := ""										// Telefone residencial do contato
Local cTelCom1	 := ""										// Telefone Comercial do contato
Local cDDD    	 := ""										// DDD do contato 
Local cEnd		 := ""										// Endereco do contato 
Local cBairro	 := ""										// Bairro do Contato
Local cDescCnt	 := ""										// Nome do Contato
Local lRet		 := .F.										// Retorno da funcao
Local nCont		 := 0 										// Contador para gravacao dos campos no SUC
Local cNovoItem	 := "00"									// Valor do NOVO ITEM que sera incluido no SUD
Local lGravaHist := (GetNewPar("MV_TMKHIST", "S") == "S")	// Verifica se eh permitida a gravacao do campo A1_CODHIST
Local lGravaFNC  := .F.										// Define se ira ser aberta uma FNC 
Local aCpoQNC 	 := {}    									// Array com Campos  que  serão preenchidos na FNC
Local aRetQNC 	 := {}    									// Array retorno com dados a serem gravados na FNC
Local aUser 	 := {}										// Array com dados do usuario para  FNC
Local aRespo	 := {} 
Local aResponsav := {}
Local cResponsav := ""
Local cQuery 	 := ""
Local cTransp	 := ""
Local cRedesp	 := ""
Local lEnvio	 := .F.
Local lRenvio	 := .F.
Local nQtEnvio	 := 0
Local LF		 := CHR(13)+CHR(10)
Local lReagendar := .F. 


If lTMKMOK
	If !U_TMKMOK(M->UC_CODIGO,M->UC_CHAVE,M->UC_CODCONT,M->UC_OPERADO,M->UC_OPERACA,M->UC_STATUS)
		Return(lRet)
	Endif
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for uma ALTERACAO		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpc == 4) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a ligacao estava cancelada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SUC->UC_CODCANC)
		If !lTk271Auto
			Help(" ",1,"CANCELADA")
		Endif
		Return(lRet)
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a ligacao estava encerrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !Empty(SUC->UC_CODENCE)
	   if Type("lTk271Auto")<> "U" 
			  If !lTk271Auto
				  Help(" ",1,"ENCERRADA")
			  Endif
		   Return(lRet)
	   endif
	Endif
	

Endif



BEGIN TRANSACTION

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia a gravacao dos itens do atendimento  - SUD  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aCols)

		cI := SomaIt(cI)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existem itens que foram deletados no Atendimento atual e apaga do que foi gravado anteriormente ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aCols[nX][Len(aHeader)+1]
			DbSelectArea( "SUD" )
			DbSetOrder(1)
			If DbSeek(xFilial("SUD") + cUDcodigo + cI)
				
				Reclock("SUD",.F.)
				DbDelete()
				MsUnlock()	
			
			Endif                                   
		Endif
		
	Next nX
	
	cI := "00"
	///////////////////////////
	////GRAVA OS ITENS NO SUD 
	//////////////////////////
	For nY:=1 To Len(aCols) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se a linha atual nao estiver deletada grava no SUD³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cI := aCols[nY][ascan(aheader,{|x|upper(alltrim(x[2]))=="UD_ITEM"})] //SomaIt(cI)
		If ! aCols[nY][Len(aHeader)+1] 
			
			//Se o item e valido grava no SUD - verifica se e novo ou nao
			cNovoItem := SomaIt(cNovoItem)
			
			DbSelectArea("SUD")
			DbSetOrder(1)
			If DbSeek(xFilial("SUD") + cUDcodigo + cI)
           	   lNovo := .F.
       	    Else
   	           lNovo := .T.
            Endif

			Reclock("SUD",lNovo)
			bCampo := {|nCPO| Field(nCPO) }

			Replace SUD->UD_FILIAL With xFilial("SUD")
			Replace SUD->UD_CODIGO With cUDcodigo //M->UC_CODIGO
			Replace SUD->UD_ITEM   With cNovoItem
            nRECSUD := 0 //SUD->(Recno())
            
			For nX := 1 To SUD->(FCount())

				If (EVAL(bCampo,nX) <> "UD_FILIAL") .AND. (EVAL(bCampo,nX) <> "UD_CODIGO")

					nPos:= Ascan(aHeader,{|x| ALLTRIM(EVAL(bCampo,nX)) == ALLTRIM(x[2])})
					If (nPos > 0)
						If (aHeader[nPos][10] <> "V" .AND. aHeader[nPos][08] <> "M")
							
							Replace SUD->&(EVAL(bCampo,nX)) With aCols[nY][nPos]
							
						Endif
					Endif
					
				Endif
				
			Next nX                         
			
			MsUnlock()
			Dbcommit()
			nRECSUD := SUD->(Recno())
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//AQUI STARTA O PROCESSO DE DEVOLUÇÃO, QDO A OCORRÊNCIA PARA LOGÍSTICA É INCLUÍDA
			//GRAVA NA TABELA Z10, PARA MARCAR NA MESMA A DATA DE INICIO DO PROCESSO,
			//HORA, E UMA FORMA DE COBRAR OS ENVOLVIDOS, ATRAVÉS DA VERIFICAÇÃO DESTES CAMPOS.                        
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			If lNovo  //se incluiu um item novo
				If SUD->UD_N1 = '0001'
					If SUD->UD_N2 = '0002'
						If SUD->UD_N3 = '0005'
							//LOCALIZA A NF NO SF2 PARA OBTER O CÓDIGO DO CLIENTE/LOJA
							DbselectArea("SF2")
							SF2->(Dbsetorder(1))
							SF2->(Dbseek(xFilial("SF2") + cUCNF + cUCserie )) 
											
							//FR - 06/11/13 - Comentei porque nem sempre na inclusao da ocorrência, a NF já 
							//foi devolvida no SF1/SD1
							//DTDIGIT := CTOD("  /  /    ")
							//DbSelectArea("SD1")
							//SD1->(Dbsetorder(10))
							//COM CÓDIGO DO CLIENTE E LOJA, PROCURO NO SD1, PARA OBTER A DATA DE ENTRADA DESTA NF DEVOLUÇÃO
											
							//If SD1->(Dbseek(xFilial("SD1") + SF2->F2_CLIENTE + SF2->F2_LOJA  )) 
							//	While SD1->(!EOF()) .and. SD1->D1_FORNECE == SF2->F2_CLIENTE .and. SD1->D1_LOJA == SF2->F2_LOJA
							//		If Alltrim(SD1->D1_TIPO) = "D" //DEVOLUÇÃO
							//			If Alltrim(SD1->D1_NFORI) = SF2->F2_DOC .and. Alltrim(SD1->D1_SERIORI) = SF2->F2_SERIE
							//				DTDIGIT := SD1->D1_DTDIGIT	
							//			Endif
							//		Endif
							//		SD1->(Dbskip())
							//	Enddo
											
							DbselectArea("Z10")
							Z10->(DBSETORDER(1))
							If !Z10->(Dbseek(xFilial("Z10") + cUCNF + cUCserie ))  //se não encontrar, cria registro												
								RecLock("Z10", .T.)
								Z10->Z10_FILIAL := xFilial("Z10")
								Z10->Z10_CODIGO := cUDcodigo  //SUD->UD_CODIGO
								Z10->Z10_ITEM   := cNovoItem  //SUD->UD_ITEM
								Z10->Z10_NF     := cUCNF
								Z10->Z10_SERINF := cUCserie
								Z10->Z10_EMINF  := SF2->F2_EMISSAO
								//Z10->Z10_DTDEVO := DTDIGIT  //D1_DTDIGIT -> DATA EM QUE A NF FOI DEVOLVIDA
								//Z10->Z10_DTINI  := DATE()
								//Z10->Z10_HRINI  := TIME()
								Z10->Z10_STATUS := '01'       //OCORRENCIA INCLUÍDA -> status na X5 -> ZG
								Z10->Z10_DTSTAT := DATE()
								Z10->Z10_HRSTAT := TIME()
								Z10->Z10_RECSUD := nRECSUD
								Z10->Z10_USER   := __CUSERID
								Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
								Z10->(MsUnlock())
							Endif
										
						//Endif //SEEK NO D1
						Endif //SE UD_N3 = 0005
					Endif //SE UD_N2 = 0002
				Endif   //SE UD_N1 = 0001 
			Endif //if lNovo
			
		
		Endif ///se não estiver deletada a linha do acols
			
	Next nY

	lRet := .T.
	


END TRANSACTION 


nNRENV := 0
nRegZUD:= 0
cQuery := ""	
//vai mostrar todos os regs do SUD que existem...
cQuery := " SELECT * " + LF
cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
cQuery += " AND ( UD_RESOLVI <> ''  or UD_STATUS = '2' ) "+LF
cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "
							
If Select("RESOL") > 0		
	DbSelectArea("RESOL")
	DbCloseArea()			
EndIf
TCQUERY cQuery NEW ALIAS "RESOL"
TCSetField( "RESOL", "UD_DTRESOL"   , "D")
						
RESOL->(DbGoTop())
If !RESOL->(EOF())	
	While !RESOL->(Eof())
		////verifica qual o número máximo de envios do item lido...	
		//irá gravar no histórico
		cQuery := " SELECT TOP 1 ZUD.R_E_C_N_O_ AS REGZUD , *  " + LF
		cQuery += " FROM "+RetSqlName("ZUD")+" ZUD "+LF
		cQuery += " WHERE ZUD_CODIGO = '" + Alltrim(RESOL->UD_CODIGO) + "' "+LF
		cQuery += " AND ZUD_ITEM = '" + Alltrim(RESOL->UD_ITEM) + "' " + LF
		cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
		cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
		cQuery += " ORDER BY ZUD.R_E_C_N_O_ DESC "			+LF
		If Select("ZUDX") > 0		
			DbSelectArea("ZUDX")
			DbCloseArea()			
		EndIf
		TCQUERY cQuery NEW ALIAS "ZUDX"										
		ZUDX->(DbGoTop())
		If !ZUDX->(EOF())
			While !ZUDX->(Eof())
				nRegZUD := ZUDX->REGZUD      //pega o recno do ZUD
				ZUDX->(Dbskip())
			Enddo
			DbSelectArea("ZUDX")
			DbCloseArea()
			////grava no item do histórico, dentro da última resposta efetuada se foi resolvido (direto no recno encontrado)
			///serve também qdo o usuário responde mais respostas do que o número de envios gerados 
			///(envio 0 qdo o usuário responde sem um envio / reenvio específico				
			DbselectArea("ZUD")						
			ZUD->(DBGOTOP())
			ZUD->(Dbgoto(nRegZUD))  //vai direto no registro						
			If Alltrim(ZUD->ZUD_CODIGO) = Alltrim(RESOL->UD_CODIGO) .And. Alltrim(ZUD->ZUD_ITEM) = Alltrim(RESOL->UD_ITEM)						
				RecLock("ZUD", .F.)
				ZUD->ZUD_RESOLV := RESOL->UD_RESOLVI    //GRAVA O RESOLVIDO ( S / N )
				If Alltrim(SUD->UD_RESOLVI) = 'S'       //SE O RESOLVIDO FOI "SIM" , GRAVA A DATA E HORA QUE FOI REGISTRADO
					ZUD->ZUD_DTRESO := RESOL->UD_DTRESOL
					ZUD->ZUD_HRRESO := RESOL->UD_HRRESOL
				Endif		
				ZUD->ZUD_OBSENC := RESOL->UD_OBSENC          //grava a OBS de encerramento
				ZUD->(MsUnlock())									
			Endif
		Endif  //endif do ZUDX->(!EOF())		
		RESOL->(DBSKIP())
	Enddo
		    	    
Endif   //se RESOL não é EOF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o envio de email para os usuarios selecionados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If lRet
	Tk272EnvTmk(cTimeIni	,cTipSta	,cCidade	,cEst		,;
				cTelRes 	,cTelCom1	,cEnd		,cDescCnt	,;
				nOpc		,aSx3SUC	,cDDD		,cEncerra	,;
				cMotivo		,cBairro)
Endif
*/

aRespo    := {}  ///array contendo os dados dos itens do atendimento
aResponsav:= {}  ///array contendo somente os códigos dos responsáveis de cada item
aReenvio  := {}  ///array contendo os dados dos itens para reenvio do atendimento
nItemUD   := 0   ///contador de itens
lEnvio		:= .F.
lRenvio		:= .F.
nQtEnvio	:= 0
cResponsav	:= ""
cRespAnt	:= ""	

Dbselectarea("SF2")
SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + cUCNF + cUCserie ))
cTransp := SF2->F2_TRANSP
cRedesp := SF2->F2_REDESP
					 							
/////////////////////////////////////////////////////////////////////////
////QUERY PRINCIPAL QUE LEVANTARÁ TODOS OS ITENS DO ATENDIMENTO CORRENTE 
/////////////////////////////////////////////////////////////////////////					      
cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_DATA, UD_RESOLVI, UD_DTENVIO,UD_NRENVIO, UD_MAILCC "+LF
cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "			+LF
//Memowrite("C:\fr272grv1.SQL",cQuery)
			
If Select("SUDX1") > 0		
	DbSelectArea("SUDX1")
	DbCloseArea()			
EndIf
			
TCQUERY cQuery NEW ALIAS "SUDX1"
SUDX1->(DbGoTop())
While !SUDX1->(Eof())
    lEnvio := .F.
	lRenvio:= .F.
	lReagendar := .F.
 
 If !Empty(Alltrim( SUDX1->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 + UD_OPERADO ) )  )
		   	
   	If EMPTY(SUDX1->UD_NRENVIO)
		lEnvio := .T.
	Elseif (SUDX1->UD_RESOLVI = 'N' .AND. SUDX1->UD_NRENVIO >= 1)
		lRenvio := .T.
	Endif 
   	
   	If lEnvio
   		//cResponsav := aResponsav[fr]
   		cResponsav := SUDX1->UD_OPERADO
		aRespo:= {}
		
		If cResponsav != cRespAnt
			cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_DATA, UD_RESOLVI, UD_ITEM,"+LF
			cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO, UD_MAILCC "+LF
			cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
			cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
			cQuery += " AND RTRIM(UD_OPERADO) = '"  + Alltrim(cResponsav)   + "' "+LF
			//cQuery += " AND UD_DATA = '' "+LF
			cQuery += " AND UD_NRENVIO = '' "+LF
			cQuery += " AND UD_RESOLVI = '' " + LF
			cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
			cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
			cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
			//Memowrite("C:\fr272grv2.SQL",cQuery)
						
			If Select("ENV") > 0		
				DbSelectArea("ENV")
				DbCloseArea()			
			EndIf
						
			TCQUERY cQuery NEW ALIAS "ENV"
			TCSetField( "ENV", "UD_DATA"      , "D")
			TCSetField( "ENV", "UD_DTENVIO"   , "D")
			ENV->(DbGoTop())
			If !ENV->(EOF())
				While !ENV->(Eof())								
					If !Empty(Alltrim( ENV->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  )
						
						Aadd(aRespo, { ENV->UD_CODIGO,;     //1
								    ENV->UD_N1,;          	//2
								    ENV->UD_N2,;          	//3
								    ENV->UD_N3,;          	//4
								    ENV->UD_N4,;          	//5
								    ENV->UD_N5,;          	//6
								    ENV->UD_OPERADO,;     	//7
								    cEntidade,;             //8
								    cChave,;                //9
								    ENV->UD_ITEM,;        	//10
								    ENV->UD_FILIAL, ;     	//11
								    ENV->UD_OBS	 ,;     	//12
								    ENV->UD_DATA,;    		//13		         
								    ENV->UD_JUSTIFI,;		//14
								    ENV->UD_DTENVIO,; 		//15
								    ENV->UD_NRENVIO,; 		//16
								    ENV->UD_MAILCC } )		//17
								    
						   			nItemUD++
				   	Endif
				   	
				   	DbselectArea("SUD")
				   	Dbsetorder(1)
				   	SUD->(Dbseek(xFilial("SUD") + ENV->UD_CODIGO + ENV->UD_ITEM ))
				   	While !SUD->(EOF()) .AND. SUD->UD_FILIAL == xFilial("SUD") .and. SUD->UD_CODIGO == ENV->UD_CODIGO .And. SUD->UD_ITEM == ENV->UD_ITEM
				   		Reclock("SUD",.F.)
				   		SUD->UD_FLAGAT := 'S'
				   		SUD->(MsUnlock())
				   		SUD->(Dbskip())
				   	Enddo
				   							        
				  	DbselectArea("ENV")
				  	ENV->(DBSKIP())
				  	
				Enddo
				cRespAnt := cResponsav
				If nItemUD > 0
					//MSGBOX("ENVIO")
					lReagendar := .T.
					TMKEnvio(aRespo , cUCNF, cUCserie, cTransp, cRedesp )						
				Endif	////////////////FIM DO ENVIO
				
				 
			Endif	
   	    Endif
   	
   	Elseif lRenvio
   		nItemUD := 0
		//cResponsav := aResponsav[fr]
		cResponsav := SUDX1->UD_OPERADO
		
		If cResponsav != cRespAnt
			aReenvio:= {}
			cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_MAILCC, "+LF
			cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO, "+LF
			cQuery += " ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_DTENV, ZUD_NRENV, ZUD_DTSOL, ZUD_OBSRES, ZUD_DTRESP, ZUD_OPERAD "+LF
			cQuery += " FROM "+RetSqlName("SUD")+" SUD, "+LF
			cQuery += " "+RetSqlName("ZUD")+" ZUD "+LF
			cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
			cQuery += " AND RTRIM(UD_OPERADO) = '"  + Alltrim(cResponsav)   + "' "+LF
			//cQuery += " AND ( UD_DATA <> '' AND RTRIM(UD_RESOLVI) = 'N') "+LF
			cQuery += " AND RTRIM(UD_RESOLVI) = 'N' " + LF
			cQuery += " AND UD_NRENVIO >= 1 "+LF
			cQuery += " AND RTRIM(UD_CODIGO) = RTRIM(ZUD_CODIGO) "+LF
			cQuery += " AND RTRIM(UD_ITEM) = RTRIM(ZUD_ITEM) "+LF
			cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
			cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
			cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
			cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
			cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM, ZUD_CODIGO, ZUD_ITEM, ZUD.R_E_C_N_O_, ZUD_DTENV+ZUD_NRENV "+LF
			Memowrite("C:\tmkc018_renv1.SQL",cQuery)
					
			If Select("RENV") > 0		
				DbSelectArea("RENV")
				DbCloseArea()			
			EndIf
					
			TCQUERY cQuery NEW ALIAS "RENV"
			TCSetField( "RENV", "UD_DATA"   , "D")
			TCSetField( "RENV", "UD_DTENVIO"   , "D")
			TCSetField( "RENV", "ZUD_DTENV"   , "D")
			TCSetField( "RENV", "ZUD_DTSOL"   , "D")
			RENV->(DbGoTop())
			If !RENV->(EOF())
				While !RENV->(Eof())								
											
					If !Empty(Alltrim( RENV->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
								                
			       		Aadd(aReenvio, { RENV->UD_CODIGO,;       //1
					       			    RENV->UD_N1,;            	//2
					       			    RENV->UD_N2,;            	//3
					       			    RENV->UD_N3,;            	//4
					       			    RENV->UD_N4,;            	//5
					       			    RENV->UD_N5,;            	//6
					       			    RENV->UD_OPERADO,;       	//7
					       			    cEntidade,;             	//8
					       			    cChave,;            	    //9
					       			    RENV->UD_ITEM,;        	//10
					       			    RENV->UD_FILIAL,;	      	//11
					       			    RENV->UD_OBS,;      		//12
					       			    RENV->ZUD_DTSOL,;			//13
					        			RENV->ZUD_OBSRES,;			//14
					        			RENV->ZUD_DTENV,;	 		//15
					        			RENV->ZUD_NRENV,;			//16 
					        			RENV->UD_MAILCC,;			//17
					        			RENV->ZUD_OBSATE } )		//18
					        		
								        				
						nItemUD++
					Endif
					
					DbselectArea("SUD")
					Dbsetorder(1)
					SUD->(Dbseek(xFilial("SUD") + RENV->UD_CODIGO + RENV->UD_ITEM ))
					While !SUD->(EOF()) .AND. SUD->UD_FILIAL == xFilial("SUD") .and. SUD->UD_CODIGO == RENV->UD_CODIGO .And. SUD->UD_ITEM == RENV->UD_ITEM
						Reclock("SUD",.F.)
						SUD->UD_FLAGAT := 'S'
						SUD->(MsUnlock())
						SUD->(Dbskip())
					Enddo						        
					
					DbselectArea("RENV")
					RENV->(DBSKIP())				
				
				Enddo
				cRespAnt := cResponsav
				If nItemUD > 0
					//MSGBOX("RE-ENVIO")
					lReagendar := .T.
					TMKRenvio(aReenvio , cUCNF, cUCserie, cTransp, cRedesp )						
				Endif	
	        Else
	        	///////////////////////////////////////////////////////////////////////////
	        	////SE AINDA NÃO EXISTIR HISTÓRICO PARA O ITEM DO ATENDIMENTO CORRENTE,
	        	//// VERIFICA APENAS O SUD (ITENS DO ATENDIMENTO
	        	//////////////////////////////////////////////////////////////////////////
	        	aReenvio:= {}
				cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_MAILCC, "+LF
				cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO "+LF
				cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
				cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
				cQuery += " AND RTRIM(UD_OPERADO) = '"  + Alltrim(cResponsav)   + "' "+LF
				//cQuery += " AND ( UD_DATA <> '' AND RTRIM(UD_RESOLVI) = 'N') "+LF
				cQuery += " AND RTRIM(UD_RESOLVI) = 'N' "+LF
				cQuery += " AND UD_NRENVIO >= 1 "+LF
				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
				cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
				cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
				Memowrite("C:\tmkc018_renv2.SQL",cQuery)
						
				If Select("RENV2") > 0		
					DbSelectArea("RENV2")
					DbCloseArea()			
				EndIf
						
				TCQUERY cQuery NEW ALIAS "RENV2"
				TCSetField( "RENV2", "UD_DATA"   , "D")
				TCSetField( "RENV2", "UD_DTENVIO"   , "D")
				RENV2->(DbGoTop())
				While !RENV2->(Eof())								
											
					If !Empty(Alltrim( RENV2->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
									                
				   		Aadd(aReenvio, { RENV2->UD_CODIGO,;       //1
					       			    RENV2->UD_N1,;            	//2
					       			    RENV2->UD_N2,;            	//3
					       			    RENV2->UD_N3,;            	//4
					       			    RENV2->UD_N4,;            	//5
					       			    RENV2->UD_N5,;            	//6
					       			    RENV2->UD_OPERADO,;       	//7
					       			    cEntidade,;             	//8
					       			    cChave,;            	    //9
					       			    RENV2->UD_ITEM,;        	//10
					       			    RENV2->UD_FILIAL,;	      	//11
					       			    RENV2->UD_OBS,;      		//12
					       			    RENV2->UD_DATA,;			//13
					        			RENV2->UD_JUSTIFI,;			//14
					        			RENV2->UD_DTENVIO,;	 		//15
					        			RENV2->UD_NRENVIO,;			//16 
					        			RENV2->UD_MAILCC } )		//17
									        				
						nItemUD++
					Endif
						
					DbselectArea("SUD")
					Dbsetorder(1)
					SUD->(Dbseek(xFilial("SUD") + RENV2->UD_CODIGO + RENV2->UD_ITEM ))
					While !SUD->(EOF()) .AND. SUD->UD_FILIAL == xFilial("SUD") ;
					  .and. SUD->UD_CODIGO == RENV2->UD_CODIGO .And. SUD->UD_ITEM == RENV2->UD_ITEM
						Reclock("SUD",.F.)
						SUD->UD_FLAGAT := 'S'
						SUD->(MsUnlock())
						SUD->(Dbskip())
					Enddo						        
						
					DbselectArea("RENV2")
					RENV2->(DBSKIP())				
				
				Enddo
				cRespAnt := cResponsav
				If nItemUD > 0
					//MSGBOX("RE-ENVIO")
					lReagendar := .T.
					TMKRenvio(aReenvio , cUCNF, cUCserie, cTransp, cRedesp )						
				Endif	 	        
				
	        Endif
	        ///////////////////FIM DO REENVIO   	
	  	
	  	Endif 	///Endif de repetição do item/responsável
   	
   	Endif		///Endif do Envio/Reenvio
 
 Endif			///Endif principal se existem itens  		
 SUDX1->(DBSKIP())

Enddo

/////////////////////////////////////////////////////////////
////FAZ O REAGENDAMENTO DO ATENDIMENTO, EM VIRTUDE DOS ITENS
/////////////////////////////////////////////////////////////
If lReagendar 
	//MSGBOX("REAGENDA")	
	U_ALTitens( cEntidade, xFilial("SUC") , cUDcodigo , cUCNF, cUCserie )
Endif



Return(lRet)


********************************
Static Function TMKEnvio(aRespo , cNOTACLI, cSERINF, cTransp, cRedesp )
********************************

Local cUsu
Local aUsu			:= {}
Local cResp
Local eEmail 		:= ""
Local eEmailResp	:= "" 
Local cNomTransp 	:= "" 
Local cNomRedesp	:=""
Local LF		 := CHR(13)+CHR(10)
Local cSup			:= ""
Local aSup			:= {}
Local cNomeSup		:= ""
Local cSetor		:= ""

Local cNomeOper		:= ""

Local cVendedor		:= ""
Local cSuper		:= ""

Local cMailSuper	:= ""  //email do coordenador do vendedor
Local cMailCopia	:= ""  //email cópia da ocorrência
Local cCopiaFIN		:= ""  //email cópia do financeiro (qdo pertinente)
Local cMailSup		:= ""  //email do superior do responsável 
Local lMarcelo		:= .F. 
Local fr            := 0
Local aParcelas     := {}
Local cBanco        := "" 
Local cVarP     := ""  //variável da parcela
Local cVarV     := ""  //variável do vencto
Local cVarVal   := ""  //variável do valor da parcela

SetPrvt("OHTML,OPROCESS")


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("CALLCENTER","Call center")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\WFSiga.html")  //VOLTAR
//oProcess:NewTask('Inicio',"\workflow\http\teste\WFSiga.html")
oHtml   := oProcess:oHtml


PswOrder(1)
If PswSeek( aRespo[1][7], .T. )         //O código do responsável pelo atendimento fica no UD_OPERADO, NÃO É o mesmo do UC_OPERADO
										//no SUC, o código que fica no UC_OPERADO, é do operador que incluiu o atendto.
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
   eEmailResp := Alltrim( aUsu[1][14] )     // e-mail
   cSup    := aUsu[1][11]
	///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   PswOrder(1)
   //PswSeek(aUsu[1][11],.t.)
   If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif

Endif

oHtml:ValByName("cSuperior", Alltrim(cNomeSup) )	//com cópia para o superior do responsável
oHtml:ValByName("cResp", cUsu )

///procura o nome do usuário logado para adicionar na assinatura do email.
PswOrder(1)
If PswSeek( cUsuario, .T. )      //USUÁRIO LOGADO QUE INCLUIU A OCORRÊNCIA        
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão   
   
Endif

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO DAS OCORRÊNCIAS
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF ))
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

oHtml:ValByName("cOperador", cNomeOper )

DbSelectArea(aRespo[1,8])
DbSetOrder(1)
DbSeek(xFilial(aRespo[1,8])+AllTrim(aRespo[1,9]))

oHtml:ValByName("cCli", iif(aRespo[1,8]=="SA1",SA1->A1_NOME,iif(aRespo[1,8]=="SA2",SA2->A2_NOME,"") ) )
oHtml:ValByName("cCodCli", Substr(aRespo[1,9],1,6) + '/' + Substr(aRespo[1,9],7,2) )

If !Empty(cNOTACLI)
	oHtml:ValByName("cNF", cNOTACLI )
	oHtml:ValByName("cSERINF", cSERINF )
//FR - 24/08/12
//modificação relativa ao chamado 00000074 - Neide
//incluir na informação da nota fiscal, o banco, parcelas e vencimento	
	SE1->(DbsetOrder(1))
	If SE1->(Dbseek(xFilial("SE1") + cSERINF + cNOTACLI ))  
		While SE1->(!EOF()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. Alltrim(SE1->E1_PREFIXO) = Alltrim(cSERINF) .And. Alltrim(SE1->E1_NUM) = Alltrim(cNOTACLI)
			cBanco := SE1->E1_PORTADO			
			Aadd( aParcelas , {SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_PORTADO, SE1->E1_AGEDEP, SE1->E1_CONTA, SE1->E1_VALOR } ) 
			//                        1               2                  3               4              5               6
			SE1->(DBSKIP())
		Enddo
	Endif
	
Else 
	oHtml:ValByName("cNF", "Sem NF" )
	oHtml:ValByName("cSERINF", "" )
Endif

fr := 1
SA6->(Dbsetorder(1)) 
If Len(aParcelas) > 0
	If SA6->(Dbseek(xFilial("SA6") + aParcelas[1,3] + aParcelas[1,4] + aParcelas[1,5] ))
		//oHtml:ValByName("cBanco", SA6->A6_NOME ) 
		oHtml:ValByName("cBanco", aParcelas[1,3] ) 
	Else 
		oHtml:ValByName("cBanco", "" )
	Endif

Endif

If Len(aParcelas) > 0
	For fr := 1 to 10
		cVarP := '"cParc' + Alltrim(str(fr)) + '"'
		cVarV := '"cVenc' + Alltrim(str(fr)) + '"'	
		cVarVal:= '"cVal' + Alltrim(str(fr)) + '"'	
		If fr <= Len(aParcelas)
			If !Empty(aParcelas[fr,1])
				oHtml:ValByName( &cVarP, aParcelas[fr,1] + " -")   //parcela
			Else
				oHtml:ValByName( &cVarP, " ' ' -" )          //parcela em branco
			Endif
				oHtml:ValByName( &cVarV, " " + Dtoc(aParcelas[fr,2]) )  //vencto
				oHtml:ValByName( &cVarVal, " " + "R$" + Transform(aParcelas[fr,6], "@E 9,999,999.99") + " ;  ")  //vencto

			//ex.  1 - 01/09/2012  R$9.999.999,99 ,
			//ex. '' - 01/09/2012  R$9.999.999,99 ,
			//Else
			//	oHtml:ValByName( &cVarP, "" )
			//	oHtml:ValByName( &cVarV, "" )		
			//Endif
		Endif
	Next
Endif
//fim das modificações relativas ao chamado 00000074

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp ))
cNomTransp := SA4->A4_NREDUZ

oHtml:ValByName("cTransp", cNomTransp )

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cRedesp ))
cNomRedesp := SA4->A4_NREDUZ
oHtml:ValByName("cRedesp", cNomRedesp )


For _nX := 1 to Len(aRespo)

     
   aadd( oHtml:ValByName("it.cAtend"), aRespo[_nX,1] )
   aadd( oHtml:ValByName("it.cItem"),  aRespo[_nX,10] )	
   aadd( oHtml:ValByName("it.cProb") , iif(!Empty(aRespo[_nX,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI")),"")+;
	                                    iif(!Empty(aRespo[_nX,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI")),"")+;
	                                    iif(!Empty(aRespo[_nX,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI")),"")+;
	                                    iif(!Empty(aRespo[_nX,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI")),"")+;
	                                    iif(!Empty(aRespo[_nX,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI")),"") )
   aadd( oHtml:ValByName("it.Respon"), cUsu )
   aadd( oHtml:ValByName("it.cObs"), aRespo[_nX,12] )   
   aadd( oHtml:ValByName("it.cMailCopia"), aRespo[_nX,17] + ";" )
   aadd( oHtml:ValByName("it.filial"), aRespo[_nX,11] )
   If Alltrim(aRespo[_nX,3]) = '0050'
       cSetor := aRespo[_nX,3]
   Endif 
   cMailCopia +=  aRespo[_nX,17] + ";"
   ///verifica se enquadra nos problemas abaixo, e envia cópia do email para Marcelo
   SUD->(DBSETORDER(1))
	If SUD->(Dbseek(xFilial("SUD") + aRespo[_nX,1] + aRespo[_nX,10] ))
		////COMERCIAL
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0034'              //comercial
				If Alltrim(SUD->UD_N3) = '0035'                     //produto
					If Alltrim(SUD->UD_N4) = '0100'						//FALHA
						lMarcelo := .T.					
					Endif
				Endif
			Endif
		Endif
		///////LICITAÇÃO
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
				If Alltrim(SUD->UD_N3) = '0076'                     //produto
					If Alltrim(SUD->UD_N4) = '0077'						//FALHA
						lMarcelo := .T.				
					Endif
				Endif
			Endif
		Endif
	Endif
    

Next _nX


//SE O SETOR FOR FINANCEIRO (0050), Irá com cópia para Alessandra
If Alltrim(cSetor) = '0050'
	//cCopiaFIN := "alessandra@ravaembalagens.com.br"
	cCopiaFIN	:= GetMv("RV_FINMAIL")
	//cCopiaFIN += ";flavia.rocha@ravaembalagens.com.br"
Endif

// Informe a função que deverá ser executada quando as respostas chegarem
// ao Workflow.
//oProcess:cTo      :=  eEmailResp + ";" + eEmail 
oProcess:cTo      :=  eEmailResp + ";marilia.vieira@ravabrasil.com.br" 		//voltar teste

If !Empty(cMailSuper)
	oProcess:cTo      +=  ";" + cMailSuper     //email do coordenador do vendedor //voltar teste
Endif

If !Empty(cMailSup)
	oProcess:cTo      +=  ";" + cMailSup    //email do superior do responsável  //voltar teste
Endif

If !Empty(cCopiaFIN)
	oProcess:cTo      +=  ";" + cCopiaFIN    //email da Alessandra (qdo ocorrência do FIN, ela recebe cópia)
Endif

If !Empty(cMailCopia)
	oProcess:cTo      +=  ";" + cMailCopia    //email da Alessandra (qdo ocorrência do FIN, ela recebe cópia)
Endif

If lMarcelo
	//oProcess:cTo      += ";marcelo@ravaembalagens.com.br" //";marcelo@ravaembalagens.com.br;flavia@ravaembalagens.com.br"    //af 
Endif

//////////////////

oProcess:cCC := ""
oProcess:cBCC:= ""  //"flavia.rocha@ravaembalagens.com.br" 


oProcess:cSubject := "SAC - NOVA Ocorrência"

// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
//oProcess:cTo    :=  eEmailResp  //email do responsável ação
//oProcess:cCC    := "flavia.rocha@ravaembalagens.com.br"
//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"

oProcess:Start()

WfSendMail()

nEnvio := 0

//Depois que enviar, incrementa o UD_NRENVIO para saber qtas vezes já foi enviada a ocorrência
If Len(aRespo) > 0

	For _nX := 1 to Len(aRespo)
		//atualiza o SUD - Itens do atendimento
		DbSelectArea("SUD")    
		SUD->(DbsetOrder(1))
		If SUD->(Dbseek(xFilial("SUD") + aRespo[_nX,1] + aRespo[_nX,10] ))				
			While SUD->(!EOF()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == aRespo[_nX,1];
			.and. SUD->UD_ITEM == aRespo[_nX,10]
			    If Alltrim( SUD->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) ) != ""
				    //If Empty(SUD->UD_DATA)
				    If Empty(SUD->UD_NRENVIO)
				    	nEnvio := SUD->UD_NRENVIO
					    Reclock("SUD", .F.)
					    SUD->UD_DTENVIO := dDatabase
					    SUD->UD_HRENVIO := Time()					    
					    SUD->UD_NRENVIO := (nEnvio + 1)
					    SUD->(MsUnlock())					
					Endif
				Endif					
			SUD->(DBSKIP())
			Enddo		      
		Endif
		
		///atualiza ZUD - Histórico de ocorrências do atendimento
		DbSelectArea("ZUD")    
		ZUD->(DbsetOrder(1))
		RecLock("ZUD",.T.)
		ZUD->ZUD_FILIAL := xFilial("ZUD")
		ZUD->ZUD_CODIGO := aRespo[_nX,1]
		ZUD->ZUD_ITEM   := aRespo[_nX,10]
		ZUD->ZUD_PROBLE := iif(!Empty(aRespo[_nX,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI")),"")+;
		                   iif(!Empty(aRespo[_nX,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI")),"")+;
		                   iif(!Empty(aRespo[_nX,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI")),"")+;
		                   iif(!Empty(aRespo[_nX,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI")),"")+;
		                   iif(!Empty(aRespo[_nX,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI")),"") 
	   	ZUD->ZUD_OBSATE := aRespo[_nX,12]
		ZUD->ZUD_DTENV := dDatabase
		ZUD->ZUD_HRENV := Time()
		ZUD->ZUD_NRENV := (nEnvio + 1)
		ZUD->ZUD_OPERAD:= aRespo[_nX,7]
		ZUD->(MsUnlock())
		
	Next
Endif

Return 


***************************************************************************
Static Function TMKRenvio(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp )
***************************************************************************

Local cBodyhtm		:= ""
Local aUsu			:= {}
Local cUsu			:= ""
Local eEmail 		:= ""
Local eEmailResp	:= ""
Local LF		 := CHR(13)+CHR(10) 
Local nrEnvio	 := 0
Local nEnvio	 := 0
Local cSup			:= ""
Local aSup			:= {}
Local cNomeSup		:= ""
Local cSetor		:= ""
Local cNomeOper		:= "" 

Local cVendedor		:= ""
Local cSuper		:= ""
Local cMailSuper	:= ""
Local cMailCopia	:= ""
Local cMailSup		:= ""
Local cCopiaFIN		:= "" 
Local lFlavia       := .F.
Local fl            := 0

 

PswOrder(1)
If PswSeek( aReenvio[1][7], .T. )         //O código do responsável pelo atendimento fica no UD_OPERADO, NÃO É o mesmo do UC_OPERADO
										//no SUC, o código que fica no UC_OPERADO, é do operador que incluiu o atendto.
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
   eEmailResp := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão
   cSup   := aUsu[1][11]
   	///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   PswOrder(1)
   If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif
   	
Endif

cSetor	:= aReenvio[1][3]
If Alltrim(cSetor) = '0050'
	//cCopiaFIN	:= "alessandra@ravaembalagens.com.br"
	cCopiaFIN	:= GetMv("RV_FINMAIL")
	//cCopiaFIN	+= ";flavia.rocha@ravaembalagens.com.br"
Endif
		
cMailCopia := aReenvio[1][17] //FR - 14/06/2011 - solicitado por Daniela - chamado 002134 - incluir campo para email cópia da ocorrência

///procura o nome do usuário logado para adicionar na assinatura do email.
PswOrder(1)
If PswSeek( cUsuario, .T. )      //USUÁRIO LOGADO QUE INCLUIU A OCORRÊNCIA        
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão   
   
Endif

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO DAS OCORRÊNCIAS
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF ))
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

cBodyhtm := U_TMKC023(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp, cNomeSup, cNomeOper )

cRemete	:= "rava@siga.ravaembalagens.com.br"
cDesti	:= eEmailResp + ";sac@ravabrasil.com.br;posvendas@ravaembalagens.com.br"
//cDesti  += ";" + "marcelo@ravaembalagens.com.br" //;marcio@ravaembalagens.com.br"		//VOLTAR
//25/07/11 - Flávia Rocha - solicitado por Daniela retirar email de Marcio
//13/08/11 - Flavia Rocha - solicitado retirar email de Marcelo - chamado 002177 - substituir pelo Rel. Resumo Ocorrências SAC


If !Empty(cMailSup)
	cDesti += ";" + cMailSup      //superior do responsável
Endif

If !Empty(cMailSuper)
	cDesti += ";" + cMailSuper	   //coordenador respectivo ao vendedor da NF	//voltar teste
Endif

If !Empty(cMailCopia)
	cDesti += ";" + cMailCopia         //email cópia definido na ocorrência (UD_MAILCC)
Endif

If !Empty(cCopiaFIN)
	cDesti += ";" + cCopiaFIN         //email da Ass.Financeiro (qdo a ocorrência é destinada ao Financeiro)	
Endif

//FR: 22/04/13 - DANIELA SOLICITOU QUE OS REENVIOS P/ COMERCIAL OU LICITAÇÃO, VÃO C/ CÓPIA P/ FLAVIA LEITE
fl := 1
For fl := 1 to Len(aReenvio)
	If SUD->(Dbseek(xFilial("SUD") + aReenvio[fl,1] + aReenvio[fl,10] )) 
		////COMERCIAL
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0034'              //comercial
				//If Alltrim(SUD->UD_N3) = '0035'                     //produto
				//	If Alltrim(SUD->UD_N4) = '0100'						//FALHA
						lFlavia := .T.					
				//	Endif
				//Endif
			Endif
		Endif
		///////LICITAÇÃO
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
				//If Alltrim(SUD->UD_N3) = '0076'                     //produto
				//	If Alltrim(SUD->UD_N4) = '0077'						//FALHA
						lFlavia := .T.				
				//	Endif
				//Endif
			Endif
		Endif
	Endif
	
Next
fl := 0
If lFlavia
	cDesti += ";" + "informatica@ravaembalagens.com.br"
Endif                                             
///FR - 25/04/13

cAssunto := "REENVIO - Identificação de Problema pela Equipe - SAC"

//cDesti		:= eEmailResp + ";flavia.rocha@ravaembalagens.com.br"
cCC		:= ""
//cCC		:= "flavia.rocha@ravaembalagens.com.br"			
U_EnvEMail( cRemete, cDesti, cCC, cAssunto, cBodyhtm )  //Envia o email com as informações do html


nrEnvio := 0
nEnvio  := 0

If Len(aReenvio) > 0
	//MSGBOX("ATUALIZA HIST. ->REENVIO")	
	nrEnvio:= 0
	nEnvio := 0 
	cCodAnt:= ""
	cItAnt := ""
	//Depois que enviar, incrementa o UD_NRENVIO para saber qtas vezes já foi enviada a ocorrência
	For fl := 1 to Len(aReenvio)

	//atualiza o SUD - Itens do atendimento
		DbSelectArea("SUD")    
		SUD->(DbsetOrder(1))
		If Alltrim(aReenvio[fl,1] + aReenvio[fl,10]) != Alltrim(cCodAnt + cItAnt)
			If SUD->(Dbseek(xFilial("SUD") + aReenvio[fl,1] + aReenvio[fl,10] ))				
				
				While SUD->(!EOF()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == aReenvio[fl,1];
				.and. SUD->UD_ITEM == aReenvio[fl,10]
				    
				    If Alltrim( SUD->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) ) != ""
					    //If !Empty(SUD->UD_DATA) .and. SUD->UD_RESOLVI = "N"
					    If SUD->UD_RESOLVI = "N" .And. SUD->UD_NRENVIO >= 1
						    nEnvio := SUD->UD_NRENVIO
						    Reclock("SUD", .F.)
						    SUD->UD_DTENVIO := dDatabase
						    SUD->UD_HRENVIO := Time()						    
						    SUD->UD_NRENVIO := nEnvio + 1
						    SUD->(MsUnlock())					
						Endif
					Endif					
				
				SUD->(DBSKIP())
				Enddo		      
			
			Endif
						
			////////////////////////////////////////////////////////////
			///atualiza ZUD - Histórico de ocorrências do atendimento
			///////////////////////////////////////////////////////////
			cQuery := ""
			cQuery += " SELECT  TOP 1 ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_DTENV, ZUD_NRENV, ZUD_DTSOL, ZUD_OBSRES, ZUD_DTRESP, ZUD_OPERAD "+LF
			cQuery += " FROM " +RetSqlName("ZUD")+" ZUD "+LF
			cQuery += " WHERE ZUD_CODIGO = '" + aReenvio[1,1] + "' "+LF
			cQuery += " AND ZUD_OPERAD = '"  + aReenvio[1,7]   + "' "+LF
			cQuery += " AND ZUD_ITEM = '"  + aReenvio[1,10]   + "' "+LF
			cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
			cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
			cQuery += " ORDER BY ZUD_CODIGO, ZUD_ITEM, ZUD_DTENV+ZUD_NRENV DESC "+LF
			//Memowrite("\TempQry\ZUDREnvio.SQL",cQuery)
			If Select("ZUDX2") > 0		
				DbSelectArea("ZUDX2")
				DbCloseArea()			
			EndIf
			TCQUERY cQuery NEW ALIAS "ZUDX2"
			ZUDX2->(DbGoTop())
			If !ZUDX2->(EOF())
				While !ZUDX2->(Eof())
					nrEnvio := ZUDX2->ZUD_NRENV
									
					DbSelectArea("ZUDX2")
					ZUDX2->(Dbskip())
				Enddo
				DbSelectArea("ZUD")    
				ZUD->(DbsetOrder(1))
				RecLock("ZUD",.T.)
				ZUD->ZUD_FILIAL := xFilial("ZUD")
				ZUD->ZUD_CODIGO := aReenvio[fl,1]
				ZUD->ZUD_ITEM   := aReenvio[fl,10]
				ZUD->ZUD_PROBLE := iif(!Empty(aReenvio[fl,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,2],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,3],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,4],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,5],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,6],"Z46_DESCRI")),"") 
			   	ZUD->ZUD_OBSATE := aReenvio[fl,12]
				ZUD->ZUD_DTENV := dDatabase
				ZUD->ZUD_HRENV := Time()
				ZUD->ZUD_NRENV := (nrEnvio + 1)
				ZUD->ZUD_OPERAD:= aReenvio[fl,7]
				ZUD->(MsUnlock())	
	        Else
	        	////////////////////////////////////////////////////////////
				///caso não possua histórico anterior, captura pelo SUD
				///////////////////////////////////////////////////////////
				cQuery := ""
				cQuery += " SELECT  TOP 1 UD_DTENVIO, UD_NRENVIO, UD_ITEM, UD_OBS, UD_OPERADO "+LF
				cQuery += " FROM " +RetSqlName("SUD")+" SUD "+LF
				cQuery += " WHERE UD_CODIGO = '" + aReenvio[1,1] + "' "+LF
				cQuery += " AND UD_OPERADO = '"  + aReenvio[1,7]   + "' "+LF
				cQuery += " AND UD_ITEM = '"  + aReenvio[1,10]   + "' "+LF
				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
				cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
				cQuery += " ORDER BY UD_CODIGO, UD_ITEM, UD_DTENVIO+UD_NRENVIO DESC "+LF
				//Memowrite("\TempQry\SUDREnvio.SQL",cQuery)
				If Select("SUDX2") > 0		
					DbSelectArea("SUDX2")
					DbCloseArea()			
				EndIf
				TCQUERY cQuery NEW ALIAS "SUDX2"
				SUDX2->(DbGoTop())
	        	While !SUDX2->(Eof())
					nrEnvio := SUDX2->UD_NRENVIO									
					DbSelectArea("SUDX2")
					SUDX2->(Dbskip())
				Enddo
				
				DbSelectArea("ZUD")    
				ZUD->(DbsetOrder(1))
				RecLock("ZUD",.T.)
				ZUD->ZUD_FILIAL := xFilial("ZUD")
				ZUD->ZUD_CODIGO := aReenvio[fl,1]
				ZUD->ZUD_ITEM   := aReenvio[fl,10]
				ZUD->ZUD_PROBLE := iif(!Empty(aReenvio[fl,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,2],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,3],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,4],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,5],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,6],"Z46_DESCRI")),"") 
			   	ZUD->ZUD_OBSATE := aReenvio[fl,12]
				ZUD->ZUD_DTENV := dDatabase
				ZUD->ZUD_HRENV := Time()
				ZUD->ZUD_NRENV := (nrEnvio + 1)
				ZUD->ZUD_OPERAD:= aReenvio[fl,7]
				//ZUD->ZUD_DTSOL := aReenvio[fl,13]
				//ZUD->ZUD_OBSRES:= aReenvio[fl,14]
				ZUD->(MsUnlock())	
	        
	        Endif
	    	cCodAnt := aReenvio[fl,1]
			cItAnt  := aReenvio[fl,10]	    
	    
	    Endif
	    
	Next	

Endif


Return







