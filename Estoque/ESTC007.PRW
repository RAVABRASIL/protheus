#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*-------------------------------------------------------------------------------------*/
//Programa: ESTC007 - Cadastro de Solicita��o para inclus�o em Estoque M�nimo
//Autoria : Fl�via Rocha
//Data    : 14/05/10
//
/*-------------------------------------------------------------------------------------*/

*************************
User Function ESTC007()
*************************

Local aCores		:= {	{ 'Z56_APROVA = "S"' , 'BR_AZUL'  },;			// Solicita��o aprovada
							{ 'Empty(Z56_APROVA)'  , 'BR_VERDE' },;         // Solicita��o n�o analisada
							{'Z56_APROVA = "N"'  , 'BR_VERMELHO'   } }		// Solicita��o REprovada


Private cCadastro	:= "Cadastro de Inclus�o em Estoque M�nimo"


Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar"   ,	"U_VisForm()"  	,0,2},;  	// Visualizar
							{"Incluir"     ,	"U_IncForm()"	,0,3},;	    // Incluir
							{"Alterar"	   ,    "U_AltForm()"   ,0,4},;
							{"Aprovar"	   ,    "U_AprovForm()"   ,0,4},;
							{"Excluir"	   ,    "U_ExcForm()"   ,0,4},;
							{"Legenda"   ,	"U_EminLeg()"	,0,5}}	    // Legenda	}


//mBrowse( 6, 1,22,75, "Z56",,,,,,)
mBrowse( 6, 1,22,75, "Z56",,,,,,aCores)


//�������������������������������Ŀ
//�Restaura a condicao de Entrada �
//���������������������������������
dbSelectArea("Z56")
dbSetOrder(1)
	
Return(Nil)




******************************************************************************************************
User Function IncForm()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZ56	:= Z56->(GetArea())

Local cCodigo  	:=  CriaVar("Z56_CODIGO",.F.,.F.)
Local dData		:= Ctod("  /  /    ")
Local cCoduser  := __CUSERID
Local cNomeuser := ""
Local aUsua		:= {}

Local cProduto	:= CriaVar("Z56_PRODUT",.F.,.F.) 
Local cDescprod := ""
Local nEstmin	:= CriaVar("Z56_ESTMIN",.F.,.F.)
Local nLote		:= CriaVar("Z56_LOTE",.F.,.F.)
Local cMAQ		:= CriaVar("Z56_MAQ",.F.,.F.)
Local cObs		:= CriaVar("Z56_OBS",.F.,.F.)  
Local oObs
Local cAnoMes	:= ""
Local oDlg5 
Local aSolicit	:= {}
Local nOpcA
dData := dDatabase

cCodigo := MaxCodZ56()

while Z56->( DbSeek( xFilial( "Z56" ) + cCodigo ) )
   ConfirmSX8()
   cCodigo := Strzero(Val(cCodigo) + 1,6)
end

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informa��es do usu�rio
   //cCodUser  := Alltrim(aUsua[1][1])  	//c�digo do usu�rio no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usu�rio
Endif





DEFINE MSDIALOG oDlg5 FROM 000,000 TO 400,590 TITLE "Inclus�o - Solicita��o de Inclus�o em Estoque M�nimo" PIXEL
//                                    o 300 � a altura, o 590 � a largura

@ 005,007 SAY "Cod. Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cCodigo					WHEN .F.	PICTURE PesqPict("Z56","Z56_CODIGO")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,075 SAY "Data Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,075 MSGET dData					WHEN .F.	PICTURE PesqPict("Z56","Z56_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,153 SAY "Solicitante:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,153 MSGET cNomeuser					WHEN .F.	 	OF oDlg5 SIZE 085,006 PIXEL


@ 035,007 SAY "Produto" 							OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 045,007 MSGET cProduto	WHEN .T.	PICTURE PesqPict("SB1","B1_COD")	   F3 "SB1"	OF oDlg5 SIZE 046,006 PIXEL 

@ 035,075 SAY "Descri��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + cProduto,1,0)		WHEN .F.	PICTURE PesqPict("SB1","B1_DESC")		OF oDlg5 SIZE 213,006 PIXEL
//MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "02" + cTipo,1,0)

@ 065,007 SAY "Estoque M�nimo:" 			OF oDlg5 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 075,007 MSGET nEstmin				WHEN .T.	PICTURE PesqPict("Z56","Z56_ESTMIN")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,075 SAY "Lote:" 						OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,075 MSGET nLote WHEN .T.	PICTURE PesqPict("Z56","Z56_LOTE") OF oDlg5 SIZE 055,006 PIXEL

@ 065,153 SAY "M�quina em que ser� usado:" 	OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 075,153 MSGET cMAQ WHEN .T.	PICTURE PesqPict("Z56","Z56_MAQ")	OF oDlg5 SIZE 045,006 PIXEL

@ 095,003 SAY "Observa��es:" OF oDlg5 Pixel 
@ 105,003 GET  cObs OBJECT oObs MEMO SIZE 170,50 

@ 165,003 SAY "OS CAMPOS ESTOQUE M�NIMO E LOTE DE COMPRA S�O APENAS UMA SUGEST�O E SER�O DISCUTIDOS" OF oDlg5 PIXEL COLOR CLR_HRED

DEFINE SBUTTON FROM 185,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//bot�o OK
DEFINE SBUTTON FROM 185,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//bot�o Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	SB1->(Dbsetorder(1))
	SB1->(Dbseek(xFilial("SB1") + cProduto ))
	cDescprod := Alltrim(SB1->B1_DESC)
	
	dbSelectArea("Z56")
	dbSetOrder(2)
	If !Z56->(DbSeek(xFilial("Z56")+ cProduto + cMAQ ))
			
			RecLock("Z56",.T.)
			Z56->Z56_FILIAL := xFilial("Z56")
			Z56->Z56_CODIGO := cCodigo
			Z56->Z56_DATA   := dDatabase
			Z56->Z56_PRODUT	:= cProduto
			Z56->Z56_MAQ    := cMAQ
			Z56->Z56_ESTMIN := nEstmin
			Z56->Z56_LOTE	:= nLote
			Z56->Z56_USER	:= cCoduser
			Z56->Z56_SOLICI := cNomeuser
			Z56->(MsUnlock())
			
			MSMM(,,,cObs,1,,,'Z56','Z56_CODOBS')   //para gravar
			//MSMM(SUC->UC_CODOBS,80)              //para carregar
		ConfirmSX8()
		///////////////////////////////////////////////////////////////////////////
		///QUANDO UMA SOLICITA��O FOR INCLU�DA,
		// DEVER� SER ENVIADO UM EMAIL PARA ALEXANDRE XAVIER E P/ O DIR. MARCELO
		///////////////////////////////////////////////////////////////////////////
		Aadd(aSolicit, { cCodigo,;      //1
			     	    dData,;        	//2
			       		cCoduser,;		//3
			       		cNomeuser,;    	//4
			       		cProduto,;     	//5
			       	    cDescprod,;    	//6
			       		nEstmin,;      	//7
			       		nLote,;       	//8
			       		cMAQ,;         	//9
			       	    cObs } )   	    //10
					       	
					       			   
				U_EMIN_Env( aSolicit )
		
	Else
		RollbackSX8()
		Msgbox("J� existe esta informa��o para este Produto/M�quina!!")
	Endif


EndIf

RestArea(aAreaZ56)
RestArea(aAreaAtu)

Return(Nil)   


******************************************************************************************************
User Function VisForm()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZ56	:= Z56->(GetArea())

Local cCodigo  	:= Z56->Z56_CODIGO
Local dData		:= Z56->Z56_DATA
Local cCoduser  := Z56->Z56_USER
Local cNomeuser := Z56->Z56_SOLICI

Local cProduto	:= Z56->Z56_PRODUT 
Local cDescprod := ""
Local nEstmin	:= Z56->Z56_ESTMIN
Local nLote		:= Z56->Z56_LOTE
Local cMAQ		:= Z56->Z56_MAQ
Local cObs		:= MSMM(Z56->Z56_CODOBS,80)                 //para carregar  
Local oObs
Local cAnoMes	:= ""
Local oDlg5
Local nOpcA




DEFINE MSDIALOG oDlg5 FROM 000,000 TO 400,590 TITLE "Visualizar - Solicita��o de Inclus�o em Estoque M�nimo" PIXEL
//                                    o 300 � a altura, o 590 � a largura

@ 005,007 SAY "Cod. Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cCodigo					WHEN .F.	PICTURE PesqPict("Z56","Z56_CODIGO")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,075 SAY "Data Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,075 MSGET dData					WHEN .F.	PICTURE PesqPict("Z56","Z56_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,153 SAY "Solicitante:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,153 MSGET cNomeuser				WHEN .F.	 	OF oDlg5 SIZE 085,006 PIXEL


@ 035,007 SAY "Produto" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,007 MSGET cProduto				WHEN .F.	PICTURE PesqPict("SB1","B1_COD")	   F3 "SB1"	OF oDlg5 SIZE 046,006 PIXEL 

@ 035,075 SAY "Descri��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + cProduto,1,0)		WHEN .F.	PICTURE PesqPict("SB1","B1_DESC")		OF oDlg5 SIZE 213,006 PIXEL

@ 065,007 SAY "Estoque M�nimo:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 075,007 MSGET nEstmin					WHEN .F.	PICTURE PesqPict("Z56","Z56_ESTMIN")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,075 SAY "Lote:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,075 MSGET nLote 					WHEN .F.	PICTURE PesqPict("Z56","Z56_LOTE") OF oDlg5 SIZE 055,006 PIXEL

@ 065,153 SAY "M�quina em que ser� usado:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 075,153 MSGET cMAQ 					WHEN .F.	PICTURE PesqPict("Z56","Z56_MAQ")	OF oDlg5 SIZE 045,006 PIXEL

@ 095,003 SAY "Observa��es:" OF oDlg5 Pixel 
@ 105,003 GET  cObs OBJECT oObs MEMO SIZE 170,50 

@ 165,003 SAY "OS CAMPOS ESTOQUE M�NIMO E LOTE DE COMPRA S�O APENAS UMA SUGEST�O E SER�O DISCUTIDOS" OF oDlg5 PIXEL COLOR CLR_HRED

DEFINE SBUTTON FROM 185,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//bot�o OK
DEFINE SBUTTON FROM 185,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//bot�o Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED


RestArea(aAreaZ56)
RestArea(aAreaAtu)

Return(Nil)   

******************************************************************************************************
User Function AltForm()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZ56	:= Z56->(GetArea())

Local cCodigo  	:= Z56->Z56_CODIGO
Local dData		:= Z56->Z56_DATA
Local cCoduser  := Z56->Z56_USER
Local cNomeuser := Z56->Z56_SOLICI

Local cProduto	:= Z56->Z56_PRODUT 
Local cDescprod := ""
Local nEstmin	:= Z56->Z56_ESTMIN
Local nLote		:= Z56->Z56_LOTE
Local cMAQ		:= Z56->Z56_MAQ
Local cObs		:= MSMM(Z56->Z56_CODOBS,80)                 //para carregar  
Local oObs
Local cAnoMes	:= ""
Local oDlg5     
Local lAlterou  := .F.
Local aSolicit	:= {} 
Local lPermite  := .F.
Local nOpcA

If ( Z56->Z56_APROVA = "S" )
	Aviso(	cCadastro,;
					"Esta solicita��o j� foi aprovada e s� poder� ser alterada mediante Senha espec�fica.",;
					{"&Continua"},,;
					"Produto/M�quina: " + Alltrim(cProduto) + " / " + cMAQ )
	lPermite := U_Senha("15") 
	
	If !lPermite
		MsgAlert("Acesso Negado !!!" )
		Return(Nil)
	Endif
EndIf


DEFINE MSDIALOG oDlg5 FROM 000,000 TO 400,590 TITLE "Altera��o - Solicita��o de Inclus�o em Estoque M�nimo" PIXEL
//                                    o 300 � a altura, o 590 � a largura

@ 005,007 SAY "Cod. Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cCodigo					WHEN .F.	PICTURE PesqPict("Z56","Z56_CODIGO")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,075 SAY "Data Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,075 MSGET dData					WHEN .F.	PICTURE PesqPict("Z56","Z56_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,153 SAY "Solicitante:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,153 MSGET cNomeuser				WHEN .F.	 	OF oDlg5 SIZE 085,006 PIXEL


@ 035,007 SAY "Produto" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,007 MSGET cProduto				WHEN .F.	PICTURE PesqPict("SB1","B1_COD")	   F3 "SB1"	OF oDlg5 SIZE 046,006 PIXEL 

@ 035,075 SAY "Descri��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + cProduto,1,0)		WHEN .F.	PICTURE PesqPict("SB1","B1_DESC")		OF oDlg5 SIZE 213,006 PIXEL

@ 065,007 SAY "Estoque M�nimo:" 					OF oDlg5 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 075,007 MSGET nEstmin					WHEN .T.	PICTURE PesqPict("Z56","Z56_ESTMIN")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,075 SAY "Lote:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,075 MSGET nLote 					WHEN .T.	PICTURE PesqPict("Z56","Z56_LOTE") OF oDlg5 SIZE 055,006 PIXEL

@ 065,153 SAY "M�quina em que ser� usado:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 075,153 MSGET cMAQ 					WHEN .F.	PICTURE PesqPict("Z56","Z56_MAQ")	OF oDlg5 SIZE 045,006 PIXEL

@ 095,003 SAY "Observa��es:" OF oDlg5 Pixel 
@ 105,003 GET  cObs OBJECT oObs MEMO SIZE 170,50 

@ 165,003 SAY "OS CAMPOS ESTOQUE M�NIMO E LOTE DE COMPRA S�O APENAS UMA SUGEST�O E SER�O DISCUTIDOS" OF oDlg5 PIXEL COLOR CLR_HRED

DEFINE SBUTTON FROM 185,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//bot�o OK
DEFINE SBUTTON FROM 185,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//bot�o Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	SB1->(Dbsetorder(1))
	SB1->(Dbseek(xFilial("SB1") + cProduto ))
	cDescprod := Alltrim(SB1->B1_DESC)
	
	dbSelectArea("Z56")
	dbSetOrder(1)
	If Z56->(DbSeek(xFilial("Z56")+ cCodigo + cProduto + cMAQ ))
			
			If (Z56->Z56_ESTMIN != nEstmin .or. Z56->Z56_LOTE != nLote)
				lAlterou := .T.
			Endif
			
			RecLock("Z56",.F.)			
			Z56->Z56_ESTMIN := nEstmin
			Z56->Z56_LOTE	:= nLote
			Z56->Z56_USER	:= cCoduser
			Z56->Z56_SOLICI := cNomeuser
			Z56->(MsUnlock())
			
			MSMM(,,,cObs,1,,,'Z56','Z56_CODOBS')   //para gravar
			
			If lAlterou
			
				Aadd(aSolicit, { cCodigo,;      //1
			     	    dData,;        	//2
			       		cCoduser,;		//3
			       		cNomeuser,;    	//4
			       		cProduto,;     	//5
			       	    cDescprod,;    	//6
			       		nEstmin,;      	//7
			       		nLote,;       	//8
			       		cMAQ,;         	//9
			       	    cObs } )   	    //10
					       	
					       			   
				U_EMIN_Env( aSolicit )
			
			Endif		
	Endif


EndIf


RestArea(aAreaZ56)
RestArea(aAreaAtu)

Return(Nil)   


******************************************************************************************************
User Function ExcForm()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZ56	:= Z56->(GetArea())

Local cCodigo  	:= Z56->Z56_CODIGO
Local dData		:= Z56->Z56_DATA
Local cCoduser  := Z56->Z56_USER
Local cNomeuser := Z56->Z56_SOLICI

Local cProduto	:= Z56->Z56_PRODUT 
Local cDescprod := ""
Local nEstmin	:= Z56->Z56_ESTMIN
Local nLote		:= Z56->Z56_LOTE
Local cMAQ		:= Z56->Z56_MAQ
Local cObs		:= MSMM(Z56->Z56_CODOBS,80)                 //para carregar  
Local oObs
Local cAnoMes	:= ""
Local oDlg5
Local lPermite	:= .F.
//Local cAprova	:= Z56->Z56_APROVA 
Local nOpcA




DEFINE MSDIALOG oDlg5 FROM 000,000 TO 400,590 TITLE "Exclus�o - Solicita��o de Inclus�o em Estoque M�nimo" PIXEL
//                                    o 300 � a altura, o 590 � a largura

@ 005,007 SAY "Cod. Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cCodigo					WHEN .F.	PICTURE PesqPict("Z56","Z56_CODIGO")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,075 SAY "Data Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,075 MSGET dData					WHEN .F.	PICTURE PesqPict("Z56","Z56_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,153 SAY "Solicitante:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,153 MSGET cNomeuser				WHEN .F.	 	OF oDlg5 SIZE 085,006 PIXEL


@ 035,007 SAY "Produto" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,007 MSGET cProduto				WHEN .F.	PICTURE PesqPict("SB1","B1_COD")	   F3 "SB1"	OF oDlg5 SIZE 046,006 PIXEL 

@ 035,075 SAY "Descri��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + cProduto,1,0)		WHEN .F.	PICTURE PesqPict("SB1","B1_DESC")		OF oDlg5 SIZE 213,006 PIXEL

@ 065,007 SAY "Estoque M�nimo:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 075,007 MSGET nEstmin					WHEN .F.	PICTURE PesqPict("Z56","Z56_ESTMIN")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,075 SAY "Lote:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,075 MSGET nLote 					WHEN .F.	PICTURE PesqPict("Z56","Z56_LOTE") OF oDlg5 SIZE 055,006 PIXEL

@ 065,153 SAY "M�quina em que ser� usado:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 075,153 MSGET cMAQ WHEN .F.	PICTURE PesqPict("Z56","Z56_MAQ")	OF oDlg5 SIZE 045,006 PIXEL

@ 095,003 SAY "Observa��es:" OF oDlg5 Pixel 
@ 105,003 GET  cObs OBJECT oObs MEMO	WHEN .F. SIZE 170,50 

@ 165,003 SAY "OS CAMPOS ESTOQUE M�NIMO E LOTE DE COMPRA S�O APENAS UMA SUGEST�O E SER�O DISCUTIDOS" OF oDlg5 PIXEL COLOR CLR_HRED

DEFINE SBUTTON FROM 185,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//bot�o OK
DEFINE SBUTTON FROM 185,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//bot�o Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	If MsgYesNo("Deseja realmente excluir esta solicita��o ?")
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///caso o usu�rio logado for diferente do solicitante, s� permite excluir com a senha de Marcelo
		///////////////////////////////////////////////////////////////////////////////////////////////////
		If ( __CUSERID != cCoduser ) 
			lPermite := U_Senha("15") 
			If lPermite
				dbSelectArea("Z56")
				dbSetOrder(1)
				If Z56->(DbSeek(xFilial("Z56")+ cCodigo + cProduto + cMAQ ))
					While Z56->(!EOF()) .AND. Z56->Z56_FILIAL == xFilial("Z56") .and.  Z56->Z56_CODIGO == cCodigo;
					 .and. Z56->Z56_PRODUT == cProduto .and. Z56->Z56_MAQ == cMAQ
					
						RecLock("Z56",.F.)
						Z56->(Dbdelete())					
						Z56->(MsUnLock())						
						Z56->(DBSKIP())						
					Enddo
					MsgInfo("Solicita��o Exclu�da com Sucesso !!!")		
				Endif
				
			Else
				MsgAlert("N�o � permitido excluir uma solicita��o de outro SOLICITANTE !!")
			Endif		///endif do permite por senha				
					
		
		Else     		////o usu�rio logado � o mesmo solicitante
			dbSelectArea("Z56")
			dbSetOrder(1)
			If Z56->(DbSeek(xFilial("Z56")+ cCodigo + cProduto + cMAQ ))
				////////////////////////////////////////////////////////////////////////////////////////////
				////caso a solicita��o j� tenha sido aprovada, somente poder� exclui-la a senha de Marcelo 
				////////////////////////////////////////////////////////////////////////////////////////////
				If Z56->Z56_APROVA = "S"       		
					lPermite := U_Senha("15") 
					If lPermite
						While Z56->(!EOF()) .AND. Z56->Z56_FILIAL == xFilial("Z56") .and.  Z56->Z56_CODIGO == cCodigo;
					 	.and. Z56->Z56_PRODUT == cProduto .and. Z56->Z56_MAQ == cMAQ
					
							RecLock("Z56",.F.)
							Z56->(Dbdelete())					
							Z56->(MsUnLock())						
							Z56->(DBSKIP())						
						Enddo
						MsgInfo("Solicita��o Exclu�da com Sucesso !!!")		
					Else					
						MsgAlert("N�o � permitido excluir uma solicita��o que j� foi APROVADA !!")	
					Endif
					
				Else		//a solicita��o n�o foi aprovada ainda, ent�o pode excluir
					While Z56->(!EOF()) .AND. Z56->Z56_FILIAL == xFilial("Z56") .and.  Z56->Z56_CODIGO == cCodigo;
					 .and. Z56->Z56_PRODUT == cProduto .and. Z56->Z56_MAQ == cMAQ
					
						RecLock("Z56",.F.)
						Z56->(Dbdelete())					
						Z56->(MsUnLock())						
						Z56->(DBSKIP())						
					Enddo
					MsgInfo("Solicita��o Exclu�da com Sucesso !!!")		
				Endif		
			Endif
		
		Endif		///endif do userid diferente do que est� logado
		
	Endif


EndIf


RestArea(aAreaZ56)
RestArea(aAreaAtu)

Return(Nil) 

******************************************************************************************************
User Function AprovForm()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZ56	:= Z56->(GetArea())

Local cCodigo  	:= Z56->Z56_CODIGO
Local dData		:= Z56->Z56_DATA
Local cCoduser  := Z56->Z56_USER
Local cNomeuser := Z56->Z56_SOLICI

Local cProduto	:= Z56->Z56_PRODUT 
Local cDescprod := ""
Local nEstmin	:= Z56->Z56_ESTMIN
Local nLote		:= Z56->Z56_LOTE
Local cMAQ		:= Z56->Z56_MAQ
Local cObs		:= MSMM(Z56->Z56_CODOBS,80)                 //para carregar  
Local oObs
Local cAnoMes	:= ""
Local oDlg5 
Local oCbx  
Local cAprova	:= CriaVar("Z56_APROVA",.F.,.F.)
Local lPermite := .F.
Local aSolicit := {}
Local nOpcA


DEFINE MSDIALOG oDlg5 FROM 000,000 TO 400,590 TITLE "Aprova��o - Solicita��o de Inclus�o em Estoque M�nimo" PIXEL
//                                    o 300 � a altura, o 590 � a largura

@ 005,007 SAY "Cod. Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cCodigo					WHEN .F.	PICTURE PesqPict("Z56","Z56_CODIGO")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,075 SAY "Data Solicita��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,075 MSGET dData					WHEN .F.	PICTURE PesqPict("Z56","Z56_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 005,153 SAY "Solicitante:" 						OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 017,153 MSGET cNomeuser				WHEN .F.	 	OF oDlg5 SIZE 085,006 PIXEL


@ 035,007 SAY "Produto" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 045,007 MSGET cProduto				WHEN .F.	PICTURE PesqPict("SB1","B1_COD")	   F3 "SB1"	OF oDlg5 SIZE 046,006 PIXEL 

@ 035,075 SAY "Descri��o:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + cProduto,1,0)		WHEN .F.	PICTURE PesqPict("SB1","B1_DESC")		OF oDlg5 SIZE 213,006 PIXEL

@ 065,007 SAY "Estoque M�nimo:" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 075,007 MSGET nEstmin					WHEN .F.	PICTURE PesqPict("Z56","Z56_ESTMIN")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,075 SAY "Lote:" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,075 MSGET nLote 					WHEN .F.	PICTURE PesqPict("Z56","Z56_LOTE") OF oDlg5 SIZE 055,006 PIXEL

@ 065,153 SAY "M�quina em que ser� usado:" 							OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 075,153 MSGET cMAQ WHEN .F.	PICTURE PesqPict("Z56","Z56_MAQ")	OF oDlg5 SIZE 045,006 PIXEL

@ 095,003 SAY "Observa��es:" OF oDlg5 Pixel 
@ 105,003 GET  cObs OBJECT oObs MEMO	WHEN .F. SIZE 170,50 

@ 095,190 SAY "Aprovar (Sim/N�o):" 							OF oDlg5 PIXEL COLOR CLR_HBLUE
//@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
//@ 075,007 MSGET cMes WHEN .T.	PICTURE PesqPict("ZB2","ZB2_MES") OF oDlg5 SIZE 055,006 PIXEL
@ 105,190 COMBOBOX oCbx VAR cAprova ITEMS { " ", "S=Sim" ,"N=Nao" }  WHEN .T. SIZE 46, 27 OF oDlg5 PIXEL		


@ 165,003 SAY "OS CAMPOS ESTOQUE M�NIMO E LOTE DE COMPRA S�O APENAS UMA SUGEST�O E SER�O DISCUTIDOS" OF oDlg5 PIXEL COLOR CLR_HRED

DEFINE SBUTTON FROM 185,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//bot�o OK
DEFINE SBUTTON FROM 185,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//bot�o Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1      //1o
	
	lPermite := U_Senha("15") 
	DbselectArea("SB1")
	SB1->(Dbsetorder(1))
	SB1->(Dbseek(xFilial("SB1") + cProduto ))
	cDescprod := Alltrim(SB1->B1_DESC)
	
	If lPermite          //2o
		dbSelectArea("Z56")
		dbSetOrder(1)
		If Z56->(DbSeek(xFilial("Z56")+ cCodigo + cProduto + cMAQ ))    //3o
				
				RecLock("Z56",.F.)			
				Z56->Z56_APROVA := cAprova			
				Z56->(MsUnlock())		
			
			
				If cAprova = "S"                         //4o
   					DbselectArea("SB1")
					SB1->(Dbsetorder(1))
					SB1->(Dbseek(xFilial("SB1") + cProduto ))
						Reclock("SB1", .F.)
	
							IF SM0->M0_CODFIL = '01'           //5o
	   							SB1->B1_ESTSEG := nEstmin
								SB1->B1_EMIN   := nLote
							elseif SM0->M0_CODFIL = '03'
	   							SB1->B1_ESTSEGX := nEstmin
								SB1->B1_EMINCX := nLote
							Endif                                 //5o
 			//	Endif    //4o

			
		   //	If !Empty(cAprova)
			   /*	If cAprova = "S"
					DbselectArea("SB1")
					SB1->(Dbsetorder(1))
					SB1->(Dbseek(xFilial("SB1") + cProduto ))
					Reclock("SB1", .F.)
					SB1->B1_ESTSEG := nEstmin
					SB1->B1_EMIN   := nLote
					SB1->(MsUnlock())
				
			 Endif  */
			
				Aadd(aSolicit, { cCodigo,;      //1
					     	    dData,;        	//2
					       		cCoduser,;		//3
					       		cNomeuser,;    	//4
					       		cProduto,;     	//5
					       	    cDescprod,;    	//6
					       		nEstmin,;      	//7
					       		nLote,;       	//8
					       		cMAQ,;         	//9
					       	    cObs } )   	    //10
					       	
					       			   
				U_EMIN_APROV( aSolicit, cAprova )
				
			Endif
		Endif
	Else
		MsgBox("Acesso Negado !!!")
	Endif
	

EndIf  //1o


RestArea(aAreaZ56)
RestArea(aAreaAtu)

Return(Nil)  
  
  
**************************************
Static Function MaxCodZ56()     
**************************************

Local cQry 		:= "" 
Local cMaxZ56 	:= ""


cQry := " SELECT MAX(Z56_CODIGO) as Z56_CODIGO "
cQry += " FROM " + RetSqlname("Z56") + " Z56 "
cQry += " WHERE Z56_FILIAL = '" + xFilial("Z56") + "' "
cQry += " AND Z56.D_E_L_E_T_ <>'*' "
//Memowrite("\TempQry\MAXZ56G.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("ZZ56") > 0
	DbSelectArea("ZZ56")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "ZZ56" 

ZZ56->(DbGoTop())

While !ZZ56->(EOF())
    cMaxZ56 := ZZ56->Z56_CODIGO
	ZZ56->(DBSKIP())
Enddo

cMaxZ56 := Strzero(Val(cMaxZ56) + 1,6)

DbCloseArea("ZZ56")

Return(cMaxZ56)

*******************************************
User Function EMIN_Env( aSolicit )
*******************************************

Local cUsu
Local aUsu		:= {}
Local LF      	:= CHR(13)+CHR(10) 
Local cStatus	:= ""
Local eEmail	:= ""

SetPrvt("OHTML,OPROCESS")


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("ESTOQUE","Solicitacao Est.Min")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\WFEstminE.html")
oHtml   := oProcess:oHtml

///pesquisa o email do solicitante
PswOrder(1)
If PswSeek( aSolicit[1][3], .T. )         
										
   aUsu   := PSWRET() 					
   //cUsu   := Alltrim( aUsu[1][2] )      
   eEmail := Alltrim( aUsu[1][14] )     
Endif


oHtml:ValByName("cSolici", aSolicit[1][4] )

					       	
For _nX := 1 to Len(aSolicit)
     
   aadd( oHtml:ValByName("it.codsol")   , aSolicit[_nX,1] )
   aadd( oHtml:ValByName("it.datasol")  , Dtoc(aSolicit[_nX,2]) )	
   aadd( oHtml:ValByName("it.cproduto") , aSolicit[_nX,5] )
   aadd( oHtml:ValByName("it.cdescprod") , aSolicit[_nX,6] )
   aadd( oHtml:ValByName("it.nestmin")  , aSolicit[_nX,7] )
   aadd( oHtml:ValByName("it.nlote")    , aSolicit[_nX,8] )
   aadd( oHtml:ValByName("it.cmaquina") , aSolicit[_nX,9] )
   aadd( oHtml:ValByName("it.cObs")     , aSolicit[_nX,10] )

Next _nX




// Informe a fun��o que dever� ser executada quando as respostas chegarem
// ao Workflow.
oProcess:cTo      :=  eEmail    ///Destino: email do solicitante

/////////////////////////////////////////////////////////////////////////////////////////////////////
////Qdo h� inclus�o/altera��o, o email vai automaticamente com c�pia para Marcelo e Alexandre Xavier 
/////////////////////////////////////////////////////////////////////////////////////////////////////   
oProcess:cCC      :=  "marcelo@ravaembalagens.com.br;alexandre@ravaembalagens.com.br"
//oProcess:cCC      :=  "romildo@ravaembalagens.com.br"

//oProcess:bReturn  := ""   //chamada da fun��o
oProcess:cSubject := "Estoque M�nimo - Solicita��o de Inclus�o " 
//oProcess:bTimeOut := { {"U_TMKTimeout()", 0, 0, 1 } }   

// Neste ponto, o processo ser� criado e ser� enviada uma mensagem para a lista
// de destinat�rios.
oProcess:Start()

WfSendMail()
//MSGBOX("INCLUS�O - ENVIO OK")  

Return

  
  

********************************
User Function EMIN_APROV( aSolicit, cAprova )
********************************

Local cUsu
Local aUsu		:= {}
Local LF      	:= CHR(13)+CHR(10) 
Local cStatus	:= ""
Local eEmail	:= ""

SetPrvt("OHTML,OPROCESS")


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("ESTOQUE","Solicitacao Est.Min")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\WFEstminA.html")
oHtml   := oProcess:oHtml

///pesquisa o email do solicitante
PswOrder(1)
If PswSeek( aSolicit[1][3], .T. )         
										
   aUsu   := PSWRET() 					
   //cUsu   := Alltrim( aUsu[1][2] )      
   eEmail := Alltrim( aUsu[1][14] )     
Endif


oHtml:ValByName("cSolici", aSolicit[1][4] )


If cAprova = "S"
	cStatus := "Aprovada"
Else
	cStatus := "Reprovada"
Endif

oHtml:ValByName("cStatus", cStatus )

					       	
For _nX := 1 to Len(aSolicit)
     
   aadd( oHtml:ValByName("it.codsol")   , aSolicit[_nX,1] )
   aadd( oHtml:ValByName("it.datasol")  , Dtoc(aSolicit[_nX,2]) )	
   aadd( oHtml:ValByName("it.cproduto") , aSolicit[_nX,5] )
   aadd( oHtml:ValByName("it.cdescprod") , aSolicit[_nX,6] )
   aadd( oHtml:ValByName("it.nestmin")  , aSolicit[_nX,7] )
   aadd( oHtml:ValByName("it.nlote")    , aSolicit[_nX,8] )
   aadd( oHtml:ValByName("it.cmaquina") , aSolicit[_nX,9] )
   aadd( oHtml:ValByName("it.cObs")     , aSolicit[_nX,10] )

Next _nX




// Informe a fun��o que dever� ser executada quando as respostas chegarem
// ao Workflow.
oProcess:cTo      :=  eEmail
oProcess:cCC      :=  "marcelo@ravaembalagens.com.br;alexandre@ravaembalagens.com.br"
//oProcess:cCC      :=  "romildo@ravaembalagens.com.br"
//oProcess:bReturn  := "" 	//chamada da fun��o
oProcess:cSubject := "Estoque M�nimo - Solicita��o de Inclus�o ->" + cStatus
//oProcess:bTimeOut := { {"U_TMKTimeout()", 0, 0, 1 } }   

// Neste ponto, o processo ser� criado e ser� enviada uma mensagem para a lista
// de destinat�rios.
oProcess:Start()

WfSendMail()
//MSGBOX("APROV./REPROV - ENVIO OK")  

Return


******************************************************************************************************
User Function EminLeg()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE" ,	"Solicita��o n�o Analisada"},;
									{ "BR_AZUL", "Solicita��o Aprovada" },;
									{"BR_VERMELHO",	"Solicita��o Reprovada"} 	 } )

Return .T.
  