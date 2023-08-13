#Include "QIER050.Ch"
#Include "PROTHEUS.CH"
#Include "Topconn.ch"
#define Confirma 1
#define Redigita 2
#define Abandona 3


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Programa: QIER003 - CERTIFICADO DE QUALIDADE
Autoria : Flávia Rocha
Data    : 03/06/2011
Objetivo: Imprimir o certificado de Qualidade após as inspeções realizadas
Melhoria das perguntas (SX1), reduzindo apenas para 3: NF, SÉRIE, PRODUTO
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
***********************
User Function QIER003
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc    :=0 
Local oDlg
Local cText1  :=""
Local i       :=1
Local oListBox
Local nOpcA   :=2
Local oDlgGet
 
Local cDesc1   :=STR0009		//"Neste relatorio sera impresso os Certificados"
Local cDesc2   :=""
Local cDesc3   :=""

Private wnrel      := "QIER003" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cTamanho   := "M"
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} 
Private nTipo      := 0 
Private cRelatorio := "QIER003"  //QIER050


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0011, 1,STR0012,  1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private nLastKey := 0  
Private Perg     := "QER050_"
Private cSeek := ""
Private cCond := ""

Private lEnd  :=.F.
Private lEdit := .t.	// Para editar os textos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aListBox  :={}
Private aMsg      :={}
Private aSel      :={}
Private aValid    :={}
Private aConteudo :={}
Private cPerg1    := "QER051"   
Private cRelDir   :=GetMv("MV_RELT") 
Private lNFQEL  := IIF(QEL->(FieldPos('QEL_NISERI')) > 0,.t.,.f.)
Private par01  
Private par02
Private par03
Private par04
Private par05
Private par06
Private par07
Private par08
Private par09 
Private par10
Private par11

Private LF := chr(13) + chr(10)
Private lGerTXT := .F. 
Private aDados := {}
Private cString  :="QER"
Private cTitulo    := STR0010	//"Certificado Qualidade"
Private li       := 80
Private m_pag    := 1
Private Cabec1   := ""
Private Cabec2   := ""
Private nomeprog := "QIER003"


DEFAULT lGerTXT   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := OemToAnsi(STR0001)	//"Certificado de Qualidade"
cText1  := OemToAnsi(STR0002)  	//"Neste relatorio sera impresso o Certificado de Qualidade"

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM  165,115 TO 315,525 PIXEL OF oMainWnd
	@ 03, 10 TO 43, 195 LABEL "" OF oDlg  PIXEL
	@ 10, 15 SAY cText1 SIZE 180, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 50, 112 TYPE 5 ACTION (nOpc:=2,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 141 TYPE 1 ACTION (nOpc:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 170 TYPE 2 ACTION (nOpc:=3,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg




AADD(aListBox," ")
AADD(aListBox,OemToAnsi(STR0004))		//" Texto Superior "
AADD(aListBox,OemToAnsi(STR0005))		//" Texto Inferior "
AADD(aListBox,OemToAnsi(STR0006))		//" Impressao "
AADD(aListBox," ")

For i:= 1 To Len(aListBox)
	aListBox[i] := aListBox[i]
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa ListBox com opcoes para o array da configuracao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgGet TITLE STR0007 FROM  63,1 		TO 275,399 PIXEL OF oMainWnd		//"Certificado de Qualidade"
@ 12, 21 SAY OemToAnsi(STR0008)	SIZE 300, 07 OF oDlgGet PIXEL		//"Itens de Configuracao"
@ 20, 21 TO 82, 181 OF oDlgGet PIXEL
@ 33,28 LISTBOX oListBox VAR cVar FIELDS HEADER "" ON DBLCLICK (R050GetList(oListBox)) SIZE 147,42 PIXEL

oListBox:SetArray(aListBox)
oListBox:bLine := { ||{aListBox[oListBox:nAt]}}

DEFINE SBUTTON FROM 88, 110 TYPE 1 ACTION (nOpca:=1,oDlgGet:End()) ENABLE OF oDlgGet
DEFINE SBUTTON FROM 88, 150 TYPE 2 ACTION (nOpca:=2,oDlgGet:End()) ENABLE OF oDlgGet

ACTIVATE MSDIALOG oDlgGet CENTERED


Pergunte(Perg,.T.)
wnrel  := SetPrint(cString,wnrel,Perg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,,.F.,,,lGerTXT)  

SetPrintFile(wnrel)

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| R050Imp(@lEnd,wnRel,cString,cTitulo,lGerTxt)},ctitulo)   

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R050GetList ³Autor³ Marcelo Pimentel      ³ Data ³ 19.03.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Get para edicao de Elemento relacionado ao ListBox    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIER050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R050GetList(oListBox)
Local nAt :=oListBox:nAt

If nAt == 2 .Or. nAt == 3
	R050TEXT(oListBox)
ElseIf nAt == 4
	Pergunte(cPerg1,.T.)
Endif
Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R050Text    ³Autor³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Tela para preenchimento do conteudo relacionado com o ³±±
±±³          ³ListBox.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIER050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R050Text(oListBox)
Local cTexto      := ""
Local nOpca       := 2
Local oFontMet    := TFont():New("Courier New",6,0)
Local oDlgGet2
Local oTexto
Local oFontDialog := TFont():New("Arial",6,15,,.T.)
Local oBox1

nAt:=oListBox:nAt

cNomeArq := "X"
nHdl:=MSFCREATE(cNomeArq,0)
If nHdl <= -1
	HELP(" ",1,"NODIRCQ")
	Return .T.
Else
	If File(cNomeArq)
		FCLOSE(nHdl)
		FERASE(cNomeArq)
	Endif
Endif

cNomeArq := "QER050"+Str(nAt,1)+".TXT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le arquivo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTexto:=MemoRead(cNomeArq)
		
DEFINE MSDIALOG oDlgGet2 FROM	62,100 TO 345,610 TITLE  OemToAnsi(STR0008) PIXEL FONT oFontDialog		//"Itens de Configuracao"
@ 003, 004 TO 027, 250 LABEL "" 	OF oDlgGet2 PIXEL
@ 040, 004 TO 110, 250				OF oDlgGet2 PIXEL
@ 013, 010 MSGET oBox1 VAR aListBox[nAt] SIZE 235, 010 OF oDlgGet2 PIXEL
oBox1:lReadOnly := .t.

@ 050, 010 GET oTexto VAR cTexto MEMO NO VSCROLL WHEN lEdit SIZE 235, 051 OF oDlgGet2 PIXEL
oTexto:oFont := oFontMet
	
DEFINE SBUTTON FROM 120,190 TYPE 1 ACTION (nOpca := 1,oDlgGet2:End()) ENABLE OF oDlgGet2
DEFINE SBUTTON FROM 120,220 TYPE 2 ACTION (nOpca := 2,oDlgGet2:End()) ENABLE OF oDlgGet2
	
ACTIVATE MSDIALOG oDlgGet2 CENTERED

If nOpca == Confirma
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua gravacao do arquivo                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrit( cNomeArq,cTexto )
EndIf

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R050Imp  ³ Autor ³     Marcelo Pimentel  ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

****************************
Static Function R050Imp()
****************************

Local cData    := ""
Local cArqTxt  :=""
Local cTexto   :=""
Local cImpTxt  :=""
Local cEnsaio  :=""
Local cNomArq
Local cKey     :=""
Local cChave   :=""
Local cLabor   :=""
Local cProduto := ""
Local cRevi    :=""
Local cFornec  :=""
Local cLojFor  :=""
Local dDat     :=Ctod("  /  /  ")
Local cLote    :=""
Local cLaborat :=""
Local cAcentos := "€ú‡úúú…ú†úƒú úúˆú‚ú¡ú“ú”ú¢ú™ú£ú",cAcSubst := "C,c,A~A'a`a~a^a'E'e^e'i'o^o~o'O~U'"
Local aTexto   :={}
Local aTxtRes  :={}
Local aLinha   :={}
Local cImpLinha:={}
Local aMeses   := {STR0021,STR0022,STR0023,STR0024,STR0025,STR0026,STR0027,STR0028,STR0029,STR0030,STR0031,STR0032}	//"Janeiro"###"Fevereiro"###"Marco"###"Abril"###"Maio"###"Junho"###"Julho"###"Agosto"###"Setembro"###"Outubro"###"Novembro"###"Dezembro"
Local CbTxt
Local cbCont   :=00
Local cVlrMin  :=" "
Local cVlrMax  :=" "
Local cVlrUni  :=" "
Local nC       :=0
Local nCount   :=0
Local nV       :=1
Local nRec	   :=0
Local nAmostra :=0
Local nPorcent :=0
Local lUnic    :=.T.
Local nContador:=1
Local lImpTxt  := .T.
Local lMinFora := .F. 
Local cNiseri  := ""
Local lNtEn    := .F.

///

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Fornecedor                             ³
//³ mv_par02           // Loja do Fornecedor                     ³
//³ mv_par03           // Produto                                ³
//³ mv_par04           // Data de Entrada                        ³
//³ mv_par05           // Lote                                   ³
//³ mv_par06           // Nr. de Vias                            ³
//³ mv_par07           // Impr. Ensaio Texto (Primeira/Todas)    ³
//³ mv_par08           // Nota Fiscal   						 ³
//³ mv_par09           // Serie 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(Perg,.T.)

//If lGerTXT 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posições da array para geração do TXT     ³
	//³1 - Codigo do Fornecedor                  ³
	//³2 - Loja do Fornecedor                    ³ 
	//³3 - Nota Fiscal                           ³
	//³4 - Serie			                     ³
	//³5 - Item                                  ³ 
	//³6 - TipoNf                                ³ 
	//³7 - Caminho e nome do TXT que será gerado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	///LOCALIZA QEK
    cQuery := " select top 1 R_E_C_N_O_ AS REGISTRO, * from " + RetSqlName("QEK") + " QEK " + LF
    cQuery += " where QEK_NTFISC = '" + Alltrim(mv_par01) + "' " + LF
    cQuery += " and QEK_SERINF = '" + Alltrim(mv_par02) + "' " + LF
    cQuery += " and QEK_PRODUT = '" + Alltrim(mv_par03) + "' " + LF
    
    cQuery += " and QEK_FILIAL = '" + xFilial("QEK") + "' " + LF
    cQuery += " and QEK.D_E_L_E_T_ = '' " + LF
    cQuery += " Order by R_E_C_N_O_ " + LF
        
    MemoWrite("C:\Temp\LOCALQEK.sql", cQuery)
    If Select("QEKX") > 0
		DbSelectArea("QEKX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QEKX"
	TCSetField( 'QEKX', "QEK_DTENTR", "D" )
	
	QEKX->( DBGoTop() )
	
	Do While !QEKX->( Eof() )
		par01 := QEKX->QEK_FORNEC	
		par02 := QEKX->QEK_LOJFOR
		par03 := QEKX->QEK_PRODUT
		par04 := QEKX->QEK_DTENTR
		par05 := QEKX->QEK_LOTE 
		par08 := QEKX->QEK_NTFISC  
		par09 := QEKX->QEK_SERINF 
	    par10 := QEKX->QEK_REVI
		
		DbselectArea("QEKX")
		QEKX->(Dbskip())
	Enddo
    DbselectArea("QEKX")
    DBCLOSEAREA()
    
    ///LOCALIZA QER
    //cSeek := xFilial("QER")+par03+par10+par01+par02+DTOS(par04)+par05
    nRecQER := 0
    cQuery := " select top 1 R_E_C_N_O_ AS REGISTRO, * from " + RetSqlName("QER") + " QER " + LF
    cQuery += " where QER_PRODUT = '" + Alltrim(par03) + "' " + LF
    cQuery += " and QER_REVI = '" + Alltrim(par10) + "' " + LF
    cQuery += " and QER_FORNEC = '" + Alltrim(par01) + "' " + LF
    cQuery += " and QER_LOJFOR = '" + Alltrim(par02) + "' " + LF
    cQuery += " and QER_DTENTR = '" + DTOS(par04) + "' " + LF 
    cQuery += " and QER_LOTE = '" + Alltrim(par05) + "' " + LF
    cQuery += " and SUBSTRING(QER_NISERI,1,9)= '" +Alltrim(par08)+ "' " + LF
	cQuery += " and SubsTring(QER_NISERI,10,3) ='" +Alltrim(par09)+ "' " + LF    
    cQuery += " and QER_FILIAL = '" + xFilial("QER") + "' " + LF
    cQuery += " and QER.D_E_L_E_T_ = '' " + LF
    cQuery += " Order by R_E_C_N_O_ " + LF
        
    MemoWrite("C:\Temp\LOCALQER.sql", cQuery)
    If Select("QERX") > 0
		DbSelectArea("QERX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QERX"
	TCSetField( 'QERX', "QER_DTENTR", "D" )
	
	QERX->( DBGoTop() )
	
	Do While !QERX->( Eof() ) 
		//alert("pegou QER")
		
		nRecQER := QERX->REGISTRO
		cSeek := QERX->QER_FILIAL + QERX->QER_PRODUT + QERX->QER_REVI + QERX->QER_FORNEC + QERX->QER_LOJFOR+ DTOS(QERX->QER_DTENTR) + QERX->QER_LOTE
		par11 := QERX->QER_NISERI
		
		DbselectArea("QERX")
		QERX->(Dbskip())
	Enddo
    DbselectArea("QERX")
    DBCLOSEAREA()
    
    //If !Empty(par11)
	    cCond := ' QER->QER_FILIAL == "'+xFilial("QER") +'"'
		cCond += ' .And. QER->QER_FORNEC=="'+par01+'" .And. QER->QER_LOJFOR=="'+par02+'"'
		cCond += ' .And. QER->QER_PRODUT=="'+ Alltrim(par03)+'"'
		cCond += ' .And. QER->QER_REVI=="'+par10+'"'
		cCond += ' .And. DTOS(QER->QER_DTENTR)=="'+DTOS(par04)+'" .And. QER->QER_LOTE=="'+ Alltrim(par05)+'"'                                              
		cCond += ' .And. QER->QER_NISERI == "' + par11+ '" ' 
	    MemoWrite("C:\Temp\cCond.txt",cCond)  
	 //Endif
    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1
Cabec1   := ""
Cabec2   := ""
nomeprog := "QIER003"

//If lNFQEL .and. !Empty(par08) .AND. !Empty(par09)
	dbSelectArea("QEK")
	dbSetOrder(14)
	IF !(dbSeek(xFilial("QEK")+par01+par02+par03+par08+par09))
        While !(Eof()) .and. xFilial("QEK")+par01+par02+par03+par08+par09 ==;
	        QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF
    	    If !lNtEn
	    	    If DTOS(par04) <> DTOS(QEK->QEK_DTENTR) .and. par05 <> QEK->QEK_LOTE
					lNtEn := .F.			 
				Else	
					lNtEn := .T.
					Exit
				Endif		
			Endif
			dbSelectArea("QEK")
			dbSkip()
		Enddo
				
		If !lNtEn
			Set Device to Screen
			Help(" ",1,"QE_NAOENTR")	// "Entrada nao cadastrada."
			dbSelectArea("QER")
			dbSetOrder(1)
			Return
		Endif	
	Else
		cTitulo += " - "+ QEK_NTFISC //QEK_CERQUA	
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Resultados:1-Minimo/Maximo 2-Vlr.Unico ³
//³ mv_par02           // Observacao da Entrada:  1-Sim 2-Nao    ³
//³ mv_par03           // Justificativa do Laudo: 1-Sim 2-Nao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg1,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o Fornecedor ou Cliente se a NFE igual  a "B" ou "D"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QEK->QEK_TIPONF $ "D/B"
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	
EndIf

dbSelectArea("QE6")
dbSetOrder(1)
dbSeek(xFilial("QE6")+QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI))

dbSelectArea("QER")
dbGoTop()
QER->(DbgoTo(nRecQER))


//If Empty(par06)
	par06 := 1
//EndIf

//SetRegua(par06)

For nContador := 1 To par06
	//alert("entrou no For" )
	//IncRegua(nContador)		//Incrementar a Regua
	
	m_pag := 1
	Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
    
	@Li,042 PSAY " ***    C E R T I F I C A D O     D E     I N S P E Ç Ã O    *** "
	Li+= 2
	
	cData := AllTrim(SM0->M0_CIDENT)+","+ Str(day(dDataBase)) + STR0014 + aMeses[month(dDataBase)] + STR0014 + StrZero(year(dDataBase),4)		//" de "###" de "
	
	@ Li,132-Len(cData) PSAY cData
	Li+=2
	@Li,01 PSAY AllTrim(TitSX3("QEK_PRODUT")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_PRODUT")[1])))+":"
	@Li,27 PSAY AllTrim(QEK->QEK_PRODUT)+" - "+AllTrim(QE6->QE6_DESCPO) +" - "+QEK->QEK_REVI
	Li++
	@Li,01 PSAY AllTrim(TitSX3("QEK_FORNEC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_FORNEC")[1])))+":"
	If QEK->QEK_TIPONF $ "B/D"
		@Li,27 PSAY QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA1->A1_NOME
	Else
		@Li,27 PSAY QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA2->A2_NOME
	EndIf	
	Li++
	@Li,01 PSAY AllTrim(TitSX3("QEK_DTENTR")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_DTENTR")[1])))+":"
	@Li,27 PSAY QEK->QEK_DTENTR
	@Li,62 PSAY AllTrim(TitSX3("QEK_LOTE")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_LOTE")[1])))+":"
	@Li,85 PSAY QEK->QEK_LOTE
	Li++
	@Li,01 PSAY AllTrim(TitSX3("QEK_NTFISC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_NTFISC")[1])))+":"
	@Li,27 PSAY QEK->QEK_NTFISC
	@Li,62 PSAY AllTrim(TitSX3("QEK_DTNFISC")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_DTNFIS")[1])))+":"
	@Li,85 PSAY QEK->QEK_DTNFISC
	Li++
	@Li,01 PSAY AllTrim(TitSX3("QEK_PEDIDO")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_PEDIDO")[1])))+":"
	@Li,27 PSAY QEK->QEK_PEDIDO
	//@Li,62 PSAY AllTrim(TitSX3("QEK_DOCENT")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_DOCENT")[1])))+":"
	//@Li,85 PSAY QEK->QEK_DOCENT
	//@Li,62 PSAY AllTrim(TitSX3("QEK_ITEMPC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_ITEMPC")[1])))+":"
	//@Li,86 PSAY QEK->QEK_ITEMPC
	Li++
	//@Li,01 PSAY AllTrim(TitSX3("QEK_CERFOR")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_CERFOR")[1])))+":"
	//@Li,27 PSAY QEK->QEK_CERFOR
	@Li,01 PSAY AllTrim(TitSX3("QEK_ITEMPC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_ITEMPC")[1])))+":"
	@Li,28 PSAY QEK->QEK_ITEMPC
	
	@Li,62 PSAY AllTrim(TitSX3("QEK_TAMLOT")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_TAMLOT")[1])))+":"
	SAH->(dbSetOrder(1))
	SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
	@Li,85 PSAY QEK->QEK_TAMLOT+" "+SAH->AH_UMRES
	
	Li++
	@Li,62 PSAY AllTrim(TitSX3("QEK_TAM_AM")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_TAM_AM")[1])))+":" 
	SAH->(dbSetOrder(1))
	SAH->(dbSeek(xFilial("SAH")+QE6->QE6_UNAMO1))
	@Li,85 PSAY Transform(QEK->QEK_TAM_AM,"@E 9,999.99") + " "+ SAH->AH_UMRES
	
	
	//@Li,01 PSAY AllTrim(TitSX3("QE6_APLIC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QE6_APLIC")[1])))+":"
	//@Li,27 PSAY QE6->QE6_APLIC
	//Li++
	//@Li,01 PSAY AllTrim(TitSX3("QE6_CROQUI")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QE6_CROQUI")[1])))+":"
	//@Li,27 PSAY QE6->QE6_CROQUI
	Li+=2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chave de ligacao da medicao com outros arquivos              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave := QER->QER_CHAVE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto de Entrada - QA2        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par01 := 1
	mv_par02 := 1
	mv_par03 := 1
	If mv_par02 == 1
		dbSelectArea("QA2")
		dbSetOrder(1)
		If dbSeek(xFilial("QA2")+"QIEA200 "+cChave)
			While !Eof() .And. xFilial("QA2") == QA2->QA2_FILIAL .And. ;
				QA2->QA2_CHAVE == cChave
				
				@Li,01 PSAY STR0033+StrTran(QA2_TEXTO, "\13\10", "")	//"OBS.: "
				If Li > 56
                    Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
				EndIf
				Li++
				dbSkip()
			EndDo
		EndIf
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto superior                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTxt := "QER0502"+".TXT"
	If File(cArqTxt)
		cTexto:=MemoRead(cArqTxt)
		For nC := 1 To MLCOUNT(cTexto,130)
			aLinha := MEMOLINE(cTexto,130,nC)
			cImpTxt   := ""
			cImpLinha := ""
			For nCount := 1 To Len(aLinha)
				cImpTxt := Substr(aLinha,nCount,1)
				If AT(cImpTxt,cAcentos)>0
					cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
				EndIf
				cImpLinha := cImpLinha+cImpTxt
			Next nCount
			@Li,01 PSAY cImpLinha
			Li++
		Next nC
		Li++
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CABECALHO DOS RESULTADOS ENCONTRADOS          	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//                                                                                  Especificado                    Encontrado
	//Ensaio                                         Metodo            Un.Med      Minimo          Maximo         Minimo           Maximo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo dos Ensaios especificado com Encontrado           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	

	//alert("antes while QER" )
	DbselectArea("QER")
	QER->(Dbgotop())
	QER->(DbgoTo(nRecQER))	
	//While QER->(!Eof()) .and. &cCond
	/*
	par01 := QEKX->QEK_FORNEC	
	par02 := QEKX->QEK_LOJFOR
	par03 := QEKX->QEK_PRODUT
	par04 := QEKX->QEK_DTENTR
	par05 := QEKX->QEK_LOTE 
	par08 := QEKX->QEK_NTFISC  
	par09 := QEKX->QEK_SERINF 
    par10 := QEKX->QEK_REVI
    */
    
	While QER->(!EOF()) .and. QER->QER_FORNEC == par01 .and. QER->QER_LOJFOR == par02 .and. QER->QER_PRODUT == par03 .and. QER->QER_LOTE == par05;
	 .and. QER->QER_REVI == par10 //.and. QER->QER_DTENTR == par04
        //alert("entrou")
		//IncRegua()
	
		If cLabor <> QER->QER_LABOR
			cLabor := QER->QER_LABOR
			Li++
			@Li,01 PSAY STR0015 + QER->QER_LABOR		//"LABORATORIO : "
			Li++
			
			@Li,82 PSAY STR0016		//"Especificado"
			If mv_par01 == 1
				@Li,114 PSAY STR0017	//"Encontrados"
			EndIf	
			Li++
			@Li,001 PSAY TitSX3("QER_ENSAIO")[1]
			@Li,047 PSAY TitSX3("QE7_METODO")[1]
			@Li,065 PSAY Subs(TitSX3("QE7_UNIMED")[1],1,9)
			@Li,077 PSAY STR0018		//"Minimo"
			@Li,093 PSAY STR0019		//"Maximo"
			If mv_par01 == 1
				@Li,108 PSAY STR0018	//"Minimo"
				@Li,125 PSAY STR0019	//"Maximo"
			Else
				@Li,106 PSAY STR0020	//"Encontrado"
			EndIf
			Li++
			@Li,01 PSAY Replicate("=",130)
			Li++
		EndIf
		If Li > 56
            Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		EndIf

		dbSelectArea("QE1")
		dbSetOrder(1)
		If dbSeek(xFilial("QE1")+QER->QER_ENSAIO)
			If QE1->QE1_CARTA <> "TXT"
				@Li,01 PSAY QE1->QE1_DESCPO		
				dbSelectArea("QE7")
				dbSetOrder(1)
				If dbSeek(xFilial("QE7")+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)
					@Li,47 PSAY QE7_METODO
					SAH->(dbSeek(xFilial("SAH")+QE7->QE7_UNIMED))
					@Li,65 PSAY SAH->AH_UMRES
					If QE7_MINMAX == "1"
						@Li,75 PSAY QE7_LIE
						@Li,91 PSAY QE7_LSE
					ElseIf QE7_MINMAX == "2"
						@Li,75 PSAY QE7_LIE
						@Li,94 PSAY "---"
					ElseIf QE7_MINMAX == "3"
						//@Li,75 PSAY "<<<"
						@Li,78 PSAY "---"
						@Li,91 PSAY QE7_LSE
					EndIf
				EndIf
			Else
				@Li,001 PSAY QE1->QE1_DESCPO
				dbSelectArea("QE8")
				dbSetOrder(1)
				dbSeek(xFilial()+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)
				@Li,047 PSAY QE8_METODO
			EndIf
			If Li > 56
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			EndIf
			
			cProduto := QER->QER_PRODUT
			cRevi	 := QER->QER_REVI
			cFornec	 := QER->QER_FORNEC
			cLojFor	 := QER->QER_LOJFOR
			dDat	 := QER->QER_DTENTR
			cLote	 := QER->QER_LOTE
			cLaborat := QER->QER_LABOR
			cEnsaio	 := QER->QER_ENSAIO                                                              
	
	  
			dbSelectArea("QER")
			QER->(dbSetOrder(1))
			cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE+QER_LABOR+QER_ENSAIO"
			cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+DTOS(dDat)+cLote+cLaborat+cEnsaio

			If lNFQEL
				QER->(dbSetOrder(5))
				cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+QER_NISERI+QER_TIPONF+QER_LOTE+QER_LABOR+QER_ENSAIO"			
				cNiseri := QER->QER_NISERI
				cTipNoF := QER->QER_TIPONF			
				cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+cNiseri+cTipNoF+cLote+cLaborat+cEnsaio
			Endif


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao das vari veis para impressao da Cartas de Controle:     ³
			//³ XBR,XBS,XMR,IND,HIS,C,NP,U,P : cVlrMin,cVlrMax,cVlrUni            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lImpTxt:= .T.
			lMinFora := .F.
			While !Eof() .And. cCompQER == &cSeekQER
				
				If li > 56
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
				EndIf

				//IncRegua()
			
				cChave:= QER->QER_CHAVE

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Os tipos de cartas:XBR|XBS|XMR|IND|HIS - Se o param. for "Minimo/  ³
				//³Maximo"-ira considerar o menor e o maior valor. Se o param. for    ³
				//³"Valor Unico-Ser  o maior valor encontrado ou menor fora da espec. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS"
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMin:=If(SuperVal(QES_MEDICA)<SuperVal(cVlrMin) .Or. SuperVal(cVlrMin)==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)

							If mv_par01 == 2 // Valor Unico
								If SuperVal(cVlrMin) < SuperVal(QE7->QE7_LIE)
									cVlrUni := cVlrMin
									lMinFora:= .T.
								EndIf
								If !lMinFora
									If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
										cVlrUni := cVlrMax
									EndIf
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O tipo de Carta:TMP (Tempo).						                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TMP" 
				
	   				dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMin:=If(QA_HTOM(QES_MEDICA)<QA_HTOM(cVlrMin) .Or. Val(QA_HTOM(cVlrMin))==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(QA_HTOM(QES_MEDICA)>QA_HTOM(cVlrMax),QES_MEDICA,cVlrMax)

							If mv_par01 == 2 // Valor Unico
								If QA_HTOM(cVlrMin) < QA_HTOM(QE7->QE7_LIE)
									cVlrUni := cVlrMin
									lMinFora:= .T.
								EndIf
								If !lMinFora
									If QA_HTOM(cVlrMax) > QA_HTOM(QE7->QE7_LSE) .Or. QA_HTOM(cVlrMax) > QA_HTOM(cVlrUni) .Or. Val(QA_HTOM(cVlrUni)) == 0
										cVlrUni := cVlrMax
									EndIf
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O tipo de Carta:TXT ir  o 1o. resultado encontrado.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TXT" .And. ;
						((Len(aTexto) == 0 .And. Len(aTxtRes) == 0) .Or. par07 == 2)  // Imprime Todas Medicoes
					
					If Len(aTexto) == 0
						aTexto := QJustTxt(QE8->QE8_TEXTO,34)
					EndIf
				
					If Len(aTxtRes) == 0
						dbSelectArea("QEQ")
						dbSetOrder(1)
						dbSeek(xFilial()+cChave)
						aTxtRes := QJustTxt(QEQ_MEDICA,25)
					EndIf
				
					nTot:= IIF(Len(aTexto)>Len(aTxtRes),Len(aTexto),Len(aTxtRes))

					For nC := 1 to nTot
						If lImpTxT
							If Len(aTexto) >= nC
								If	!Empty(aTexto[nC])
									@Li,065 PSAY aTexto[nC]
								EndIf
							EndIf	
						EndIf
						If  Len(aTxtRes) >= nC
							If	!Empty(aTxtRes[nC])
								@Li,106 PSAY aTxtRes[nC]
							EndIf
						EndIf
						If Li > 56
							Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
						EndIf
						Li++
					Next nC
					lImpTxt:= .F.
					aTxtRes:= {}
					
				ElseIf QE1->QE1_CARTA$"C  /NP "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Os tipos de carta : C / NP -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 1a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 1 medi‡Æo para cada data/hora.      ³
					//³Se param. for "Valor Unico" - Ser  o maior valor do QES.           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMax := If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
							dbSkip()
						EndDo
						If mv_par01 == 2 // Valor Unico
							If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
								cVlrUni := cVlrMax
							EndIf
						EndIf
					EndIf
			
				ElseIf AllTrim(QE1->QE1_CARTA)=="U"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : U      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 2a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 2 regs. medi‡äes para cada data/hora³
					//³Se param. for "Valor Unico" - Ser  a 2a. medi‡Æo do QES para a 1a. ³
					//³data/hora.                                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							If nV == 2
								cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
								nV:=0
								If mv_par01 == 2 .And. lUnic
									cVlrUni := QES_MEDICA
									lUnic:= .F.
								EndIf
							EndIf
							nV++
							dbSkip()
						EndDo
					EndIf
				
				ElseIf AllTrim(QE1->QE1_CARTA)=="P"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : P      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor de :                      ³
					//³Amostra * (Porcent./100)                                           ³
					//³Se param. for "Valor Unico" - Ser  o maior valor da Amostra:       ³
					//³Amostra * (Porcent./100)                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
													
							If QES_INDMED == "A"
								nAmostra := SuperVal(QES_MEDICA)
							ElseIf QES_INDMED == "P"
								nPorcent := SuperVal(QES_MEDICA)
							EndIf
							If !Empty(nAmostra) .And. !Empty(nPorcent)
								cVlrMax:= If(nAmostra * (nPorcent / 100 )>SuperVal(cVlrMax),AllTrim(Str(nAmostra*(nPorcent/100))),cVlrMax)
								nAmostra:=0
								nPorcent:=0
								If mv_par01 == 2 // Valor Unico
									cVlrUni := IIF(ValType(cVlrMax)=="N",STR(cVlrMax),cVlrMax)
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
				If Li > 56
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
				EndIf
				dbSelectArea("QER")
				dbSkip()
				nRec:=Recno()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz impressÆo de todas as cartas                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS/TMP"
				If mv_par01 == 1
					@Li,099 PSAY PadL(AllTrim(cVlrMin),15)
					@Li,116 PSAY PadL(AllTrim(cVlrMax),15)
				Else
				    @Li,099 PSAY PadL(AllTrim(cVlrUni),15)
				EndIf
			ElseIf AllTrim(QE1->QE1_CARTA)$"C/NP/U/P"
				If mv_par01 == 1
					@Li,099 PSAY PadL("0",15)
					@Li,116 PSAY PadL(AllTrim(cVlrMax),15)
				Else
					@Li,099 PSAY PadL(AllTrim(cVlrUni),15)
				EndIf
			EndIf
			
			If QE1->QE1_CARTA == "TXT"
				aTexto:={}
				aTxtRes:={}
			Else
				cVlrMin := " "
				cVlrMax := " "
				cVlrUni := " "
				lUnic   :=.T.
				Li++
			EndIf	
			Li++
			@Li,01 PSAY Replicate("-",130)
            Li++    
            
            If Li > 56
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			EndIf
						
			dbSelectArea("QER")
			If nRec > 0
				dbGoTo(nRec)
			Else 
				QER->(dbSkip())
			Endif	
		Else
			//alert("não encontrou: " + QER->QER_ENSAIO )
		EndIf
	EndDo

	dbSelectArea("QEL")
	If lNFQEL
		cNiseri := QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
		dbSetOrder(3) 
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO+cNiseri+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
	Else
		dbSetOrder(1) 
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
	EndIf
	
	If dbSeek(xFilial("QEL")+cSeek)
		dbSelectArea("QED")
		dbSetOrder(1)
		dbSeek(xFilial("QED")+QEL->QEL_LAUDO)
		Li+=2
		@Li,01 PSAY AllTrim(TitSX3("QEL_LAUDO")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_LAUDO")[1])))+": "+QED_DESCPO
		Li++
		@Li,01 PSAY AllTrim(TitSX3("QEL_DTLAUD")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_DTLAUD")[1])))+": "+Dtoc(QEL->QEL_DTLAUD)
		Li++
		@Li,01 PSAY AllTrim(TitSX3("QEL_DTVAL")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_DTVAL")[1])))+": "+Dtoc(QEL->QEL_DTVAL)
		Li++
		If !Empty(QEL->QEL_QTREJ)
			SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
			@Li,01 PSAY AllTrim(TitSX3("QEL_QTREJ")[1])+;
				Replicate(".",15-Len(AllTrim(TitSX3("QEL_QTREJ")[1])))+": "+;
				QEL->QEL_QTREJ+" "+SAH->AH_UMRES
			Li++
		EndIf
		If mv_par03 == 1
			@Li,01 PSAY AllTrim(TitSX3("QEL_JUSTLA")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_JUSTLA")[1])))+": "+QEL->QEL_JUSTLA
			Li++
		EndIf
	EndIf

	Li+=2
    

	@Li,001 PSAY "Inspetor(a)"
	@ Li,034 PSAY "Supervisor"
	@ Li,062 PSAY "Resp.Qualidade"       
	@ Li,095 PSAY "Coordenador(a)"
	Li+=3 
	@ Li,001 PSAY "_________________________"
	@ Li,034 PSAY "_______________________"
	@ Li,062 PSAY "_________________________"
	@ Li,095 PSAY "_________________________"
	Li+=3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto inferior                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTxt := "QER0503"+".TXT"
	If File(cArqTxt)
		cTexto:=MemoRead(cArqTxt)
		For nC:=1 To MLCOUNT(cTexto,130)
			aLinha   := MEMOLINE(cTexto,130,nC)
			cImpTxt  := ""
			cImpLinha:= ""
			For nCount  := 1 To Len(aLinha)
				cImpTxt := Substr(aLinha,nCount,1)
				If AT(cImpTxt,cAcentos)>0
					cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
				EndIf
				cImpLinha := cImpLinha+cImpTxt
			Next nCount
			@Li,01 PSAY cImpLinha
			Li++
			If Li > 56
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			EndIf
		Next nC
	EndIf
	Li++
Next nContador

If Li != 80
	roda(CbCont,cbtxt,cTamanho)
EnDif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QER")
Set Filter To
RetIndex("QER")
dbSetOrder(1)

If aReturn[5] == 1 
	Set Printer To 
	dbCommitAll()
	//IIF(!lGerTXt,OurSpool(wnrel),.t.)
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return .T.
