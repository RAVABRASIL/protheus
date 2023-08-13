#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'


/*O ponto de entrada MT106GRV é chamado antes de ser 
gerada a pre-requisição e antes de baixar o saldo no estoque. 
Pode ser utilizado para se validar qual o almoxarifado 
será baixada a quantidade da pre-requisição.*/
************************
User Function MT106GRV()
************************
	//msgalert("MT106GRV")
   TelaAlt()   
Return

/*O ponto se encontra antes da montagem do array aCols onde se encontra 
o conteúdo dos campos a serem mostrados na baixa da pre-requisição Modelo 2*/
***********************
User function MT185BX()
***********************
local aRet := {}
  aAdd(aRet,{	.F.			,;									// Marca de selecao
				CP_NUM		,; 									// Numero da SA
   			    CP_ITEM		,;									// Item da SA
				CP_PRODUTO	,;									// Produto
				CP_DESCRI	,;									// Descricao do Produto
				CP_LOCAL	,;									// Armazem
				CP_UM		,;									// UM
				Transform(CP_QTDSOL,PesqPictQt('D3_QUANT')),;	// Qtd. a Requisitar (Formato Caracter)
				CP_QTDSOL	,;									// Qtd. a Requisitar (Campo customizado RAVA)
				CP_CC		,;									// Centro de Custo
				CP_SEGUM	,;									// 2a.UM
				CP_QTSEGUM	,;									// Qtd. 2a.UM
				CP_OP		,;									// Ordem de Producao
				CP_CONTA	,;									// Conta Contabil
				CP_ITEMCTA	,;									// Item Contabil
				CP_CLVL		,;									// Classe Valor
				CriaVar('AFH_PROJET',.F.),; 				 	// Projeto
				CP_NUMOS 	,;									// Nr. da OS
				CriaVar('AFH_TAREFA',.F.),;				 		// Tarefa
				"SCP"	,;										// Alias Walk-Thru
				SCP->(RecNo()) 	})								// Recno Walk-Thru


return aRet

*****************************
Static Function TelaAlt()
*****************************


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCod       := SCP->CP_PRODUTO
Private cDesc      := SCP->CP_DESCRI
Private cUM        := SCP->CP_UM
Private nQuant     := SCP->(CP_QUANT - CP_QUJE) //Saldo
Private cNumOs     := Space(6)
Private lValMan    := fValiManut()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSBtn1","oBtn2","oSBtn2","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oGet1","oGet2","oGet3","oGet4","oGet5")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


IF lValman
	oDlg1      := MSDialog():New( 205,395,367,1150,"Alteração de Itens",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 003,005,042,360,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay5      := TSay():New( 012,290,{||"Ordem Serviço"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
	oGet5         := TGet():New( 021,290,,oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"STJ","cNumOS",,)
	oGet5:bSetGet := {|u| If(PCount()>0,cNumOS:=u,cNumOS)}  // <--acho que esse sai -->
	oGet5:bValid := {||fValOrdem(cNumOS)}
else
	oDlg1      := MSDialog():New( 205,395,367,1004,"Alteração de Itens",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 003,005,042,292,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
ENDIF
oSBtn1     := SButton():New( 053,264,1,{||Ok()},oDlg1,,"", )
oSBtn1:bAction := {||Ok()}

//oBtn2 := SButton():New( 053,295,2,,oGrp1,,"&Sair", )
//oBtn2:bAction := {|| oDlg1:end()}

oSay1      := TSay():New( 012,010,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 012,059,{||"Descrição"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 012,207,{||"UM"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,009,008)
oSay4      := TSay():New( 012,226,{||"Quantidade"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGet1      := TGet():New( 021,010,,oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,)
oGet1:Disable()
oGet1:bSetGet := {|u| If(PCount()>0,cCod:=u,cCod)}

oGet2      := TGet():New( 021,059,,oGrp1,143,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,)
oGet2:Disable()
oGet2:bSetGet := {|u| If(PCount()>0,cDesc:=u,cDesc)}

oGet3      := TGet():New( 021,206,,oGrp1,016,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cUM",,)
oGet3:Disable()
oGet3:bSetGet := {|u| If(PCount()>0,cUM:=u,cUM)}

oGet4      := TGet():New( 021,226,,oGrp1,060,008,'@E 999999.9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nQuant",,)
oGet4:bSetGet := {|u| If(PCount()>0,nQuant:=u,nQuant)}
oGet4:bValid := {||fQuant()}

//oGet3         := TGet():New( 031,047,,oGrp1,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US5","cMatricu",,)
//oGet3:bSetGet := {|u| If(PCount()>0,cMatricu:=u,cMatricu)}

oDlg1:Activate(,,,.T.)

if !fQuant() 
    TelaAlt()
ELSE
   RecLock("SCP",.F.)
   SCP->CP_QTDSOL := nQuant   
   // QUANTO FOR MASTER E FITA NAO FICA COM SALDO, A QUANTIDADE FINAL fica igual QUANTIDADE SOLICITADA 
   IF (ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDMAST") ).OR.( ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDFITA") )  
      SCP->CP_QUANT := nQuant 
   Endif
   MsUnLock()
Endif

IF lValman .AND. EMPTY(cNUmOS)
    TelaAlt()
endif

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Ok()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function Ok()
   
   fQuant() 
   
   RecLock("SCP",.F.)
   SCP->CP_QTDSOL := nQuant
   SCP->CP_NUMOS := cNumOS    
   // QUANTO FOR MASTER E FITA NAO FICA COM SALDO, A QUANTIDADE FINAL fica igual QUANTIDADE SOLICITADA 
   IF (ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDMAST") ).OR.( ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDFITA") )
      SCP->CP_QUANT := nQuant  
   Endif
   
   MsUnLock()
   oDlg1:End()
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Cancel()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function Cancel()
   oDlg1:End()
Return

***************

Static Function fQuant()

***************
local nQtdCP:=SCP->(CP_QUANT - CP_QUJE) 

if nQuant=0
   Alert('Quantidade Zerada')
   RETURN .F.
ENDIF

if nQuant>nQtdCP
   Alert('Quantidade Maior '+alltrim(str(nQuant))+' que a da solicitacao '+alltrim(str(nQtdCP)))
   RETURN .F.
ENDIF

If !EMPTY(SCP->CP_OP)
   
   IF ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDMAST")
	   nResto := Mod( nQuant, 25 )
	   If nResto<>0
	      ALERT('Master: A Quantidade nao e Multiplo de 25 ')
	      RETURN .F.
	      //nQuant:=(int(nQuant/25)+1)*25
	   Endif	                                                                	
   Endif
   IF ALLTRIM(SCP->CP_PRODUTO) $ GetMV("MV_PRDFITA")
	  If ( nQuant - Int( nQuant ) ) > .00999
	      ALERT('A Quantidade nao pode ser fracionada ')
	      RETURN .F.
	  Endif
	  //nQuant:=round(nQuant,0)                            
   Endif
   
Endif

Return .T.

*************

User Function fVldIncl()

*************
//If Inclui 
	if  alltrim(upper(FunName())) == "MATA105"  // nao pode gerar manual 
	    If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "03" // filial caixa
	        IF ALLTRIM(M->CP_PRODUTO) $ GetMV("MV_PRDFITA")
		      alert('Esse produto nao pode ser incluido manualmente.')
		      RETURN .F.
	        Endif   
	    ELSEIf  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "01" // filial SACO
	        IF ALLTRIM(M->CP_PRODUTO) $ GetMV("MV_PRDMAST")
		       alert('Esse produto e um Master, nao pode ser incluido manualmente.')
		       RETURN .F.
	        Endif
	        IF ALLTRIM(M->CP_PRODUTO) $ GetMV("MV_PRDFITA")
		       alert('Esse produto nao pode ser incluido manualmente.')
		       RETURN .F.
	        Endif
	    ENDIF
	ENDIF
//endif
Return .T. 

static function fValiManut()

Local lRet   := .F.
Local cUser  := __CUSERID
Local cQuery := ''

cQUERY := " SELECT * FROM SX5020 WHERE X5_TABELA = 'ST' AND X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "' AND D_E_L_E_T_ = '' "
cQUERY += " AND X5_DESCRI IN ('000002','000005') AND X5_CHAVE = '" + cUser + "'"

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf
	
TCQUERY cQuery NEW ALIAS "TMPX"

IF TMPX->(!EOF())
	lRet := .T.
END

Return lRet

static function fValOrdem(cOrdem)

	Local lRet := .F.
	cQuery := "SELECT TJ_ORDEM FROM STJ020 WHERE TJ_TERMINO <> 'S' AND D_E_L_E_T_ = '' AND TJ_FILIAL = '"+ Alltrim(xFilial("STJ")) +"' "

	If Select("TMPP") > 0
		DbSelectArea("TMPP")
		DbCloseArea()
	EndIf
	
TCQUERY cQuery NEW ALIAS "TMPP"

TMPP->(DbGoTop()) 
While TMPP->(!EOF())

	IF TJ_ORDEM = cOrdem
		lRet := .T.
		Return lRet
	EndIf

TMPP->(DbSkip())
EndDo

TMPP->(DbCloseArea())	

Alert("Essa Ordem de Serviço não é válida. Digite uma Ordem de Serviço Válida!!!")	

TelaAlt()
	
Return lRet
