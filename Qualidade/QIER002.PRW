#INCLUDE "PROTHEUS.CH"
//#INCLUDE "QIER200.CH"
#INCLUDE "Report.CH"
#INCLUDE "Rwmake.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIER002   ºAutoria  ³ Flávia Rocha     º Data ³  14/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Formulário Check-List de Inspeção                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Qualidade                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±, ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                         
//Function QIER200(cProg,lImpres,nConta,aGravDad,lReport)

User Function QIER002


Local oReport
Local nX        := ""
//Local cPerg     := Padr("QIER002",10)
//Local cPerg     := Padr("QIER002_",10)
Local cProg		:= "QIER002"         


//Pergunte(cPerg,.T.)

QIER200R3(cProg,.T.,0)
	    
Return


		
*************************************************
Static Function QIER200R3(cProg,lImpres,nConta)
*************************************************

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   := "QIER002"
Local cString := "QEK"
Local cDesc1  := OemToAnsi("Neste relat¢rio serao relacionados os ensaios a serem realizados em ca-")
Local cDesc2  := OemToAnsi("da laboratorio, para a validação da Entrada.")
Local cDesc3  := ""               
Local aPerg   := {}
Local nX     

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec    ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo	   := "Formulario Check-List" //GetMv("MV_QEFICHP")+ " - USO"
Private cRelatorio := "QIER002"
Private cTamanho   := "M"
Private nPagina    := 1
Private nRecno     := QEK->(Recno())
Private nomeprog   := "QIER002"
Private nTipo      := 0
Private Cabec1     := ""
Private Cabec2     := ""
Private CbTxt  := 0
Private cbCont := 0
Private cDescProd := ""

//If cProg <> "QIER220"                                     
	li 	  := 80
	m_pag := 1 
//EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aReturn    := {"Zebrado", 1,"Administracao",  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cPerg      := Padr("QIER002_",10)

Pergunte(cPerg,.T.)

lReport:=.f.
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros PADRÃO						 ³
//³ mv_par01 = Fornecedor			?				 			 ³
//³ mv_par02 = Loja Fornecedor		?    		 				 ³
//³ mv_par03 = Produto				?			 				 ³
//³ mv_par04 = Da Data de Entrada 	?			 				 ³
//³ mv_par05 = Do Lote				?			 				 ³
//³ mv_par06 = Do Laborat¢rio 	    ?				     		 ³
//³ mv_par07 = At‚ Laborat¢rio      ?					 		 ³
//³ mv_par08 = Considera Entrada    ? 1)-Normal		 	 		 ³
//³  							  	  2)-Beneficiamento 	 	 ³
//³  							  	  3)-Devolucoes     	 	 ³
//³ mv_par09 = Considera Lote	    ? 1)-Sim	 		 	 	 ³
//³ 							  	  2)-Nao 			 		 ³
//³ mv_par10 = Skip-Teste           ? 1)- Todos    		 		 ³
//³ 								  2)- A Inspecionar	 		 ³
//³ mv_par11 = Linhas para Medicoes ? 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros neste relatório         ³
//³ mv_par01 = NF               	?			 				 ³
//³ mv_par02 = Série				?			 				 ³
//³ mv_par03 = PRODUTO   	    ?				     		 ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT 						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,'',,cTamanho,,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se apertou o botao cancela ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLastKey <> 27
			
		SetDefault(aReturn,cString)
		
		If nLastKey <> 27			
			RptStatus({|lEnd| A200Imp(@lEnd,wnRel,cString,cProg,lImpres,@nConta)},cTitulo)
		EndIf
			
	Endif

	
Return
          

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Ensaios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ A200Imp(lEnd,wnRel,cString)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd		-	A‡Æo do CodeBlock 							  ³±±
±±³			 ³ wnRel 	-	T¡tulo do relat¢rio							  ³±±
±±³			 ³ cString	-	Mensagem 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A200Imp(lEnd,wnRel,cString,cProg,lImpres,nConta)
Local lRet 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que imprime a Ficha com os dados da Entrada posicionada. ³
//³ Esta rotina tambem é chamada do QIER210, que imprime as fichas  ³
//³ dos Produtos importados, que estejam marcados para inspecao.	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//lRet := A200IFic(lEnd,cProg,lImpres,@nConta)

A200IFic(lEnd,cProg,lImpres,@nConta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra a impressao desta ficha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda(CbCont,Cbtxt)

	Set Device To Screen

	If aReturn[5] == 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	EndIf

	MS_FLUSH()

Return

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Ficha do Produto com os dados da Entrada posicio-³±±
±±³			 ³ nada. 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 -		A‡Æo do CodeBlock 							  ³±±
±±³			 ³ ExpC1 - Origem do prg: Menu relatorio ou cad./imp. entreg. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A200Imp(QIER200.PRW) e A210Imp(QIER210.PRW)				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A200IFic(lEnd,cProg,nConta) 

Local cLaborat
Local cUnimed
Local cLaudo
Local cSkipLote
Local cDescLab
Local cChaveQEK1
Local cDescEns 	:= Space(30)
Local aEntrada 	:= {}
Local aEnsaios 	:= {}
Local nRecQEK
Local nRecTRB
Local lImp		:= .T.
Local cFor
Local cLojFor
Local CGrupo
Local cSkTes    := "   "
Local lFirst
Local cTipoEns	:= ''
Local aLabEns   := {}
Local cUM       := ""
Local lSkpLot   := .F.
Local cAmIns    := " " 
Local nColEns
Local nX
Local nC
Local nY
Local nCont
Local cNiseri   := ""
Local cCpo		:= ""
Local lRet		:=.T. 
Local nAmostra 
Local nFator
Local nResult
Local LF := CHR(13) + CHR(10)
Local cQuery := ""

Local cQuery := ""
Local LF := CHR(13) + CHR(10)
Local lPeso := .F.
Local cPeso := ""
Local cQ6UM := ""
Local nPos	:= 0
Local nTam	:= 0
Local nValor:= 0

Private aCampos := {}
Private cArqTrb
Private cProduto

/*
dbSelectArea("QEK")  
dbSetOrder(14)
If QEK->(DbSeek(xFilial("QEK")+ mv_par01 + mv_par02 + mv_par03 + mv_par04 + mv_par05 ))			

	nRecQEK    := QEK->(Recno())
	cChaveQEK1 := QEK->QEK_PRODUT + Inverte(QEK->QEK_REVI)
	cFor	   := QEK->QEK_FORNEC
	cLojFor	   := QEK->QEK_LOJFOR
Endif
*/
///LOCALIZA QEK
    cQuery := " select top 1 R_E_C_N_O_ AS REGISTRO, * from " + RetSqlName("QEK") + " QEK " + LF
    //cQuery += " where QEK_NTFISC = '" + Alltrim(mv_par02) + "' " + LF
    //cQuery += " and QEK_SERINF = '" + Alltrim(mv_par03) + "' " + LF
    //cQuery += " and QEK_PRODUT = '" + Alltrim(mv_par01) + "' " + LF
    
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
	//TCSetField( 'SD7X', "D7_DATA", "D" )
	
	QEKX->( DBGoTop() )
	
	Do While !QEKX->( Eof() )
		nRecQEK    := QEKX->REGISTRO
		cChaveQEK1 := QEKX->QEK_PRODUT + Inverte(QEKX->QEK_REVI)
		cFor	   := QEKX->QEK_FORNEC
		cLojFor	   := QEKX->QEK_LOJFOR
			
		DbselectArea("QEKX")
		QEKX->(Dbskip())
	Enddo
    DbselectArea("QEKX")
    DBCLOSEAREA()



                   
//Numero de linhas padrao para Impressao das colunas de medicoes
//mv_par11 := If(mv_par11==0,1,mv_par11)

If QEK->(!EOF())
	dbSelectArea("QE6")
	dbSetOrder(1)
	dbSeek(xFilial("QE6")+ cChaveQEK1)
	IF !Found() .Or. !lImp
		Set Device to Screen
		Help(" ",1,"QE_NAOPRRV",,QEK->QEK_PRODUT+" / "+QEK->QEK_REVI,2,1) // "Produto/Revisao nao cadastrados:
		dbSelectArea("QEK")
		dbSetOrder(1)
		Return(.F.)
	EndIf
	
	cProduto := QE6->QE6_PRODUT + QE6->QE6_REVI
	cPeso := ""
	If QE6->(dbSeek(xFilial("QE6")+ cChaveQEK1))
		If Alltrim(QE6->QE6_UNMED1) = 'KG'
			cPeso := QE6->QE6_FATCO1
			lPeso := .T.            
			cQ6UM := QE6->QE6_UNMED1
			
			SAH->(Dbsetorder(1))
			If SAH->(Dbseek(xFilial("SAH") + cQ6UM ))
				cQ6UM := SAH->AH_DESCPO
			Endif
			
		Endif
	Endif
	
	
	
	dbSelectArea("QE7")
	dbSetOrder(1)
	dbSeek(xFilial("QE7")+cProduto)
	dbSelectArea("QE8")
	dbSetOrder(1)
	dbSeek(xFilial("QE8")+cProduto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Arquivo de Trabalho. 									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTam:=TamSX3("QEK_PRODUTO")
	AADD(aCampos,{"PRODUTO",   "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QEK_REVI")
	AADD(aCampos,{"REVI",   "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_ENSAIO")
	AADD(aCampos,{"ENSAIO", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_METODO")
	AADD(aCampos,{"METODO", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_TIPO")
	AADD(aCampos,{"TIPO",   "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_UNIMED")
	AADD(aCampos,{"UNIMED", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_NOMINA")
	AADD(aCampos,{"NOMINA", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_LIE")
	AADD(aCampos,{"LIE", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_LSE")
	AADD(aCampos,{"LSE","C",aTam[1],aTam[2]})
	aTam:=TamSX3("QF4_PLAMO")
	AADD(aCampos,{"PLAMO",  "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_NIVEL")
	AADD(aCampos,{"NIVEL", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_AM_INS")
	AADD(aCampos,{"AM_INS", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_LABOR")
	AADD(aCampos,{"LABOR",  "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_SEQLAB")
	AADD(aCampos,{"SEQLAB", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE7_MINMAX")
	AADD(aCampos,{"MINMAX", "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QE8_TEXTO")
	AADD(aCampos,{"TEXTO",  "C",aTam[1],aTam[2]})
	aTam:=TamSX3("QEK_VERIFI")
	AADD(aCampos,{"Ok","C",aTam[1],aTam[2]})
	
	cArqTrb := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTrb, "TRB", .F., .F. )
	dbSelectArea("QE7")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Funcao para gerar arquivo de Trabalho			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	GeraTrab()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identifica o Grupo do Produto								   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QEA->(dbSetOrder(2))
	QEA->(dbSeek(xFilial("QEA")+QEK->QEK_PRODUT))
	cGrupo := QEA->QEA_GRUPO
	QEA->(dbSetOrder(1))
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqTrb,"LABOR+SEQLAB",,,"Selecionando Registros...")
	TRB->(dbGoTop())
	
	If BOF() .and. EOF()
		HELP(" ",1,"RECNO")
		TRB->(dbCloseArea())
		
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		dbSelectArea("QEA")
		Return(.F.)
	Endif
	
	SetRegua(RecCount())
	
	While TRB->(!EOF())
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Flag Verifica se j  foi impresso o laboratorio 				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->OK == "S"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		EndIf	
			
		If TRB->LABOR != cLaborat
			cLaborat := TRB->LABOR
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Descricao do Laboratorio									  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(TRB->LABOR)
			cDescLab := Tabela("Q2",TRB->LABOR)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ARMAZENA NO ARRAY AS ULTIMAS ENTRADAS 				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("QEK")
		dbSetOrder(2) 
		dbGoto(nRecQEK)
		nCont   := 0
		lSkpLot := .F.
		While QEK_FILIAL+QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO == ;
			xFilial("QEK")+cFor+cLojFor+Substr(cProduto,1,15) .and. nCont < 4     
			
			cSkipLote := Iif (QEK_VERIFI <> 2 , "NAO","SIM")
			cChaveQEL := QEK_FORNEC+QEK_LOJFOR+QEK_PRODUTO+DTOS(QEK_DTENTR)+QEK_LOTE+;
			Space(TamSX3("QEL_LABOR")[1])
			
			dbSelectArea("QEL")
			cNiseri := QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
			QEL->(dbSetOrder(3))
			cChaveQEL := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO+cNiseri+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
			Space(TamSX3("QEL_LABOR")[1])
	
			If dbSeek(xFilial("QEL")+cChaveQEL)
				QED->(dbSetOrder(1))
				QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
				cLaudo := QaxIdioma("QED->QED_DESCPO","QED->QED_DESCIN","QED->QED_DESCES")
			Else
				cLaudo := Space(TamSX3("QED_DESCPO")[1])
			EndIf
			cLaudo:= ""
			dbSelectArea("QEK")
			AADD(aEntrada,{QEK_DTENTR,QEK_LOTE,Upper(cSkipLote),cLaudo,QEK_DOCENT})
			nCont++
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Entrada atual esta em regime de Skip-Lote		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nCont == 1
				If QEK->QEK_VERIFI == 2
					lSkpLot := .T.
				EndIf
			EndIf
			
			dbSkip()
		Enddo
		dbSelectArea("QEK")
		dbGoTo(nRecQEK)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados dos ensaios 						   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aEnsaios := {}
		aLabEns  := {}
		dbSelectArea("TRB")
		nRecTRB := Recno()
		While !EOF() .and. cLaborat == TRB->LABOR
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o skip-teste										 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSkTes := "   "
			// Verifica se tem skip-teste definido
			QEH->(dbSetOrder(1))
			If QEH->(dbSeek(xFilial("QEH")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				QEK->QEK_PRODUT+TRB->ENSAIO))
				cSkTes := "CER"
				// Verifica o historico skip-teste individual
	
				QEY->(dbSetOrder(4))
				If QEY->(dbSeek(xFilial("QEY")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
					QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO))
					cSkTes := "INS"
				EndIf
	
			Else
				cSkTes := "N/A"   // indica que nao foi definido
			EndIf			
			If Empty(cSkTes) .Or. cSkTes == "N/A"
				// Verifica o historico skip-teste por grupo
	
				cNiseri := QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
	           	cSeek := xFilial("QEZ")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+cGrupo+cNiseri+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO
				QEZ->(dbSetOrder(3))
	
				If QEZ->(dbSeek(cSeek))
					cSkTes := "INS"
				Else
					// Verifica se tem skip-teste definido
					QEI->(dbSetOrder(1))
					If QEI->(dbSeek(xFilial("QEI")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
							cGrupo+TRB->ENSAIO))
						cSkTes := "CER"
					Else
						cSkTes := "N/A" //indica que nao foi definido
					EndIf
				EndIf
			EndIf      
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se os Ensaios a Inspecionar serao impressos na Fi-  ³
			//³ do Produto conforme selecao do parametro.				     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//If mv_par10 == 2
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Quando a Entrada atual estiver em regime de Skip-Lote, somen-³
				//³ te serao impressos os ensaios em Skip-Teste.				 ³ 
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lSkpLot 
					If cSkTes # "INS" 
						RecLock("TRB",.F.)
						TRB->OK	 := "S"
						MsUnLock()
						TRB->(dbSkip())
						Loop
					EndIf	
				Else	
					If (cSkTes # "N/A") .And. (cSkTes # "INS") 
						RecLock("TRB",.F.)
						TRB->OK	 := "S"
						MsUnLock()
						TRB->(dbSkip())
						Loop
					EndIf	
				EndIf
			//EndIf
			
			RecLock("TRB",.F.)
			TRB->OK	 := "S"
			MsUnLock()
			dbSelectArea("QE1")
			dbSetOrder(1)
			IF dbSeek(xFilial("QE1")+TRB->ENSAIO)
				cDescEns := Substr(QE1_DESCPO,1,30)
				cTipoEns := QE1_CARTA
			Endif
			
			dbSelectArea("TRB")
			AADD(aEnsaios,{ENSAIO,cTipoEns})
	
			If cTipoEns <> "TXT"
				SAH->(dbSetOrder(1))
				If SAH->(dbSeek(xFilial("SAH")+TRB->UNIMED))
					cUM := SAH->AH_UMRES
				Else
					cUM := " "
				EndIf
			EndIf       
	
			If (AM_INS == "1" )
				cAmIns := "AMO"
			ElseIf (AM_INS == "2")
				cAmIns := "INS"
			ElseIf (AM_INS == "3")
				cAmIns := "A/I"
			Else 
				cAmIns := " "	
			EndIf
						
			Aadd(aLabEns,{ENSAIO+" "+cDescEns,SubStr(METODO,1,13),TIPO,cTipoEns,cUM,NOMINA,;
				MINMAX,LIE,LSE,	Left(TEXTO,34),Subs(TEXTO,35,34),Subs(TEXTO,69),;
				PLAMO,NIVEL,cAmIns,	cSkTes})
			
			dbSelectArea("TRB")
			dbSkip()
			
		Enddo
		dbGoTo(nRecTRB)                             
		
		If Len(aLabEns) == 0
			TRB->(dbSkip())
			Loop
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ‚ nova pagina 									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Li > 65
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
		Endif
	
	
		IF ( lEnd )
			@Prow()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			Return(.T.)
		EndIf
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO PRODUTO 										     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Produto - Revisao .........:
		@ Li, 001 PSAY AllTrim(TitSX3("QE6_PRODUT")[1])+" - "+AllTrim(TitSX3("QE6_REVI")[1])+Replicate(".",38-(len(Alltrim(TitSx3("QE6_PRODUT")[1]))+len(Alltrim(TitSx3("QE6_REVI")[1]))))+":"
		//código produto - revisão
		@ Li, 044 PSAY QE6->QE6_PRODUT + " - " + QE6->QE6_REVI
		Li++
	
		If __LANGUAGE == "PORTUGUESE"
			cCpo := "QE6_DESCPO"
		ElseIf __LANGUAGE == "ENGLISH"
			cCpo := "QE6_DESCIN"
		ElseIf __LANGUAGE == "SPANISH"
			cCpo := "QE6_DESCES"
		Endif
	    
		//Descrição .....:
		@ Li, 001 PSAY AllTrim(TitSX3(cCpo)[1])+REPLICATE(".",41-Len(AllTrim(TitSX3(cCpo)[1])))+":"
		//descrição do produto
		@ Li, 044 PSAY QE6->&(cCpo)
		Li++
		Li++
		cDescProd := QE6->&(cCpo)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona em registros de outros Arquivos p/dados Fornecedor  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA5")
		dbSetOrder(2)
		dbSeek(xFilial("SA5")+QEK->QEK_PRODUTO+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
		dbSelectArea("QEG")
		dbSetOrder(1)
		dbSeek(xFilial("QEG")+SA5->A5_SITU)
		
		If Li > 65  
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados do Fornecedor/Cliente           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If __LANGUAGE == "PORTUGUESE"
			cCpo := "QEG_NIVEL"
		ElseIf __LANGUAGE == "ENGLISH"
			cCpo := "QEG_NIVING"
		ElseIf __LANGUAGE == "SPANISH"
			cCpo := "QEG_NIVESP"
		Endif
	
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	        //Forn/Cliente ...:
			@ Li, 01 PSAY AllTrim(TitSX3("QEK_FORNEC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_FORNEC")[1])))+":"
			//código fornecedor / loja - nome fornecedor
			@ Li, 27 PSAY QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA2->A2_NREDUZ+;
			"   ("+QEG->&(cCpo)+")"     
	
		
		//Li++
		//@ Li, 01 PSAY AllTrim(TitSX3("A5_CODPRF")[1])+Replicate(".",23-Len(AllTrim(TitSX3("A5_CODPRF")[1])))+":"
		//@ Li, 27 PSAY SA5->A5_CODPRF
		Li++	
		@ Li, 01 PSAY AllTrim(TitSX3("QEK_NTFISC")[1])+ "/Série " + Replicate(".",11)+":"
		@ Li, 32 PSAY Alltrim(QEK->QEK_NTFISC) + '/' + Alltrim(QEK->QEK_SERINF)
					
		Li++		
		@ Li, 01 PSAY "Data N.Fisc" + Replicate(".",11) +":"
		@ Li, 27 PSAY QEK->QEK_DTENTR
		
		Li++
		@ Li, 01 PSAY "No. Pedido" + Replicate(".", 11)  +":"
		@ Li, 27 PSAY QEK->QEK_PEDIDO		
	
		//Li++
		//@ Li, 01 PSAY "Doc. Entrada"  +Replicate(".", 11) +":"
		//@ Li, 27 PSAY QEK->QEK_DOCENT
		//@ Li, 62 PSAY AllTrim(TitSX3("QEK_CERFOR")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_CERFOR")[1])))+":"
		//@ Li, 85 PSAY QEK->QEK_CERFOR
		
		//Li++ 
		//Li++
		//@ Li, 01 PSAY AllTrim(TitSX3("QEK_LOTE")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_LOTE")[1])))+":"
		//@ Li, 27 PSAY QEK->QEK_LOTE
		
		Li++
		@ Li, 01 PSAY AllTrim(TitSX3("QEK_TAMLOT")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_TAMLOT")[1])))+":"
		SAH->(dbSetOrder(1))
		SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
		@ Li, 27 PSAY QEK->QEK_TAMLOT + "  " + SAH->AH_UMRES    //tamanho lote na unidade de compra
		
		Li++
		@ Li, 01 PSAY "Tam. Lote ...........: "
		//@ Li, 01 PSAY AllTrim(TitSX3("QEK_TAMLOT")[1]) + Replicate(".",23-Len(AllTrim(TitSX3("QEK_TAMLOT")[1])))+":"
		cUniMed:= Iif ( QEK->QEK_UNIMED == QE6->QE6_UNMED1 ,QE6->QE6_UNAMO1 , Iif (QEK->QEK_UNIMED == QE6->QE6_UNMED2, QE6->QE6_UNAMO2, Space(6) ))
		//If Empty(cUniMed)
			//QE6->(dbSetOrder(3))     //QE6_PRODUT + QE6_REVI
			//QE6->(dbSeek(xFilial("QE6") + cUniMed))
			//cUniMed := QE6->QE6_UNAMO1
		//EndIf
		
		//SD1->(Dbsetorder(1))
		//If SD1->(Dbseek(xFilial("SD1") + QEK->QEK_NTFISC + QEK->QEK_SERINF + QEK->QEK_FORNEC + QEK->QEK_LOJFOR + QEK->QEK_PRODUT ))
			@ Li, 25 PSAY QEK->QEK_TAMAMO  //Transform( SD1->D1_QTSEGUM,"@E 9,999,999")
		//Else
			//msgbox("NÃO ENCONTROU SD1: "  + QEK->QEK_NTFISC + '/' + QEK->QEK_SERINF + '/' + QEK->QEK_FORNEC + '/' + QEK->QEK_LOJFOR + '/' + QEK->QEK_PRODUT )
		//Endif
		
		
		@ Li, 40 PSAY AllTrim(cUnimed)
		QF5->(Dbsetorder(1))
		QF5->(Dbseek(xFilial("QF5") + QEK->QEK_CHAVE ))
		@ Li, 62 PSAY "Tamanho da Amostra ..: 
		@ Li, 85 PSAY QF5->QF5_TAMA1 Picture "@E 99,999,999.99"
	
		Li+= 2
	
		//Descricao do Laboratorio 
		@ Li, 001 PSAY "LABORATORIO ==> " + TRB->LABOR + " - " + cDescLab      //"LABORATORIO ==> "
		Li+= 2
		
		//=====================================================================================================================================
		//Ensaio 											Metodo		 Familia Instrum. Un.Med	 Nominal 	L.I.E.	L.S.E. Pl Caracterist.	 A/I ST
		//=====================================================================================================================================
		//XXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXXXXXX XXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX X  XXXXXXXXXXXXXX XXX XXX
		// 			1			 2 		  3			4			 5 		  6			7			 8 		  9			10 		 11		  12			13
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		
		@ Li, 000 PSAY Replicate("=",132)
		Li++
		@ Li, 000 PSAY TitSX3("QE7_ENSAIO")[1]
		//@ Li, 040 PSAY TitSX3("QE7_METODO")[1]
		//@ Li, 053 PSAY TitSX3("QE7_TIPO")[1]
		@ Li, 040 PSAY "Un. Med." //070 PSAY "Un. Med."
		@ Li, 058 PSAY "Nominal" //080 PSAY "Nominal"
		@ Li, 070 PSAY "Limite Inferior" //091 PSAY "Limite Inferior"
		@ Li, 090 PSAY "Limite Superior" //100 PSAY "Limite Superior"
		//@ Li, 107 PSAY "Pl "
		//@ Li, 110 PSAY TitSX3("QE7_NIVEL")[1]
		//@ Li, 125 PSAY "A/I"
		//@ Li, 129 PSAY "ST"
		Li++
		@ Li, 000 PSAY Replicate("=",132)
		    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime os Ensaios associados ao Laboratorio				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(aLabEns)
		
			If Li > 65
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
			Endif
	
			Li++ 
			
			/*
			
				Aadd(aLabEns,{ENSAIO +" "+ cDescEns,   1
							SubStr(METODO,1,13),       2
							TIPO,                      3
							cTipoEns,                  4
							cUM,                       5
							NOMINA,                    6
							MINMAX,                    7
							LIE,                       8
							LSE,                       9
							Left(TEXTO,34),            10
							Subs(TEXTO,35,34),         11
							Subs(TEXTO,69),            12
							PLAMO,                     13
							NIVEL,                     14
							cAmIns,	cSkTes})           15
			
		 
			
			@ Li, 000 PSAY TitSX3("QE7_ENSAIO")[1]
			@ Li, 040 PSAY "Un. Med." //070 PSAY "Un. Med."
			@ Li, 058 PSAY "Nominal" //080 PSAY "Nominal"
			@ Li, 070 PSAY "Limite Inferior" //091 PSAY "Limite Inferior"
			@ Li, 085 PSAY "Limite Superior" //100 PSAY "Limite Superior"
		    */
			
		                      
			@ Li, 000 PSAY Substr(Alltrim(aLabEns[nX,1]),1,36)
			
			//@ Li, 040 PSAY aLabEns[nX,2]
		    //@ Li, 053 PSAY aLabEns[nX,3]
			If aLabEns[nX,4] <> "TXT"
				@ Li, 040 PSAY aLabEns[nX,5]     //UM
				@ Li, 058 PSAY aLabEns[nX,6]     //nominal
				
				If aLabEns[nX,7] == "1"          //min e max
					@ Li, 070 PSAY aLabEns[nX,8]
					@ Li, 090 PSAY aLabEns[nX,9]
				ElseIf aLabEns[nX,7] == "2"       //min
					@ Li, 070 PSAY aLabEns[nX,8]
					@ Li, 090 PSAY ">>>"
				ElseIf aLabEns[nX,7] == "3"      //max
					@ Li, 070 PSAY "<<<"
					@ Li, 090 PSAY aLabEns[nX,9]
				EndIf                           
			Else 
				@ Li, 70 PSAY aLabEns[nX,10]
			EndIf			
	
			//@ Li, 107 PSAY aLabEns[nX,13]
	
			//If !Empty(aLabEns[nX,14])
			//	@ Li, 110 PSAY Substr(TABELA("Q6",aLabEns[nX,14]),1,10)
			//Endif
			//@ Li, 125 PSAY aLabEns[nX,15]
			//@ Li, 129 PSAY aLabEns[nX,16]
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime restante do aTexto 									 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aLabEns[nX,4] == "TXT"
				If !Empty (aLabEns[nX,11])
					Li++
					@ Li, 70 PSAY aLabEns[nX,11]
				Endif
				If !Empty (aLabEns[nX,12])
					Li++
					@ Li, 70 PSAY aLabEns[nX,12]
				Endif
			Endif
			Li++
			@ Li, 000 PSAY Replicate("-",132)
		
		Next nX
		If lPeso     //FR - 17/04/11 - solicitado por Eligia, imprimir de forma informativa o Peso da Chapa após a última linha de ensaio.
			Li++
			@ Li,000 PSAY "PESO de: " + Substr(cDescProd,1,28)
			@ Li,040 PSAY cQ6UM 
			@ Li,059 PSAY cPeso 
			Li++
			@ Li, 000 PSAY Replicate("-",132)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIME MENSAGEM DE NOVAS ESPECIFICACOES 	         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QEK->QEK_ALTESP
			Li+=2
			@ Li, 01 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ>>   "+;
			Upper("Entrada com novas Especificacoes")+"   <<ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" // "Entrada com novas Especificacoes"
			Li++
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CABE€ALHO DAS ULTIMAS ENTRADAS						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Ultimas Entradas:  Data Entrada	Lote				  Skip-Lote   Laudo									 Doc-Entrada
		// 			1			 2 		  3			4			 5 			6			7			 8 		  9			100
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		li+=2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Cabe‡alho das ultimas Entradas				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//@ Li, 01 PSAY "Ultimas Entradas:"
		//@ Li, 20 PSAY "Data Entrada"
		//@ Li, 34 PSAY "Lote"
		//@ Li, 51 PSAY "Skip-Lote"
		//@ Li, 63 PSAY "Laudo"
		//@ Li, 95 PSAY "Doc.Entrada"
		Li++
		
		For nC:= 1 to Len(aEntrada)
		
			If Li > 65
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
			Endif
		
			//@ Li,20 PSAY aEntrada[nC,1]
			//@ Li,34 PSAY aEntrada[nC,2]
			//@ Li,51 PSAY aEntrada[nC,3]
			@ Li,63 PSAY aEntrada[nC,4]
			//@ Li,95 PSAY aEntrada[nC,5]
			Li++
		Next nC
		aEntrada:={}
		Li++
		
		
		@ Li,01 PSAY "DEFINIÇÕES PARA INSPEÇÃO SEGUNDO PLANO AMOSTRAGEM/NORMA:"
		Li++
		        
		lFirst := .T.
		QF5->(dbSetOrder(1))
		QF5->(dbSeek(xFilial("QF5")+QEK->QEK_CHAVE))
		If QF5->(!Eof())
			While QF5->(!Eof()) .And. QEK->QEK_CHAVE == QF5->QF5_CHAVE 
			            
				If Ascan(aEnsaios,{|x|x[1]==QF5->QF5_ENSAIO}) >  0
	
					If QF5->QF5_TAMA1 > 0            
						If lFirst
							QF4->(dbSetOrder(1))
							QF4->(dbSeek(xFilial("QF4")+QF5->QF5_FORNEC+QF5->QF5_LOJFOR+QF5->QF5_PRODUT+QF5->QF5_REVI+QF5->QF5_ENSAIO))
							Li+=2
							//@ Li, 48 PSAY "|-------------Normal-------------|"     
							//@ Li, 82 PSAY "|-------------Severo-------------|"   
							Li++  
							@ Li, 01 PSAY "Ensaio"      
							@ Li, 11 PSAY "Plano"    
							@ Li, 18 PSAY "Desc. Plano"    
							@ Li, 31 PSAY "UM" 
							@ Li, 42 PSAY "Tipo" 
	
							@ Li, 49 PSAY "Amostragem"    
							@ Li, 63 PSAY "Aceite"   
							@ Li, 72 PSAY "Rejeite"
							//@ Li, 83 PSAY "Amostragem"    
							//@ Li, 95 PSAY "Aceite"   
							//@ Li, 106 PSAY "Rejeite"
							Li++
							lFirst := .F.
						EndIf	
						Li++                            
						If QEK->QEK_TIPONF $ "BßD" 
							QF6->(dbSetOrder(1))
							QF6->(dbSeek(xFilial("QF6")+QF5->QF5_FORNEC+QF5->QF5_LOJFOR+QF5->QF5_PRODUT+QF5->QF5_REVI+QF5->QF5_ENSAIO))
							@ Li, 01 PSAY QF6->QF6_ENSAIO
							@ Li, 13 PSAy QF6->QF6_PLAMO
						Else                                                
							QF4->(dbSetOrder(1))
							QF4->(dbSeek(xFilial("QF4")+QF5->QF5_FORNEC+QF5->QF5_LOJFOR+QF5->QF5_PRODUT+QF5->QF5_REVI+QF5->QF5_ENSAIO))
	                        
							cCodNorma := QA_Plano(QF4->QF4_TIPAMO)
	
							@ Li, 01 PSAY QF4->QF4_ENSAIO
							@ Li, 11 PSAy QF4->QF4_PLAMO
							@ Li, 18 PSAY cCodNorma
							@ Li, 31 PSAY AllTrim(cUnimed)
	
							If QF4->QF4_PLAMO == "PI"
					  			aAmostra := QEP_RetAmostra(QF4->QF4_TIPAMO,QF4->QF4_PLAMO,QF4->QF4_NIVEL,QF4->QF4_NQA,QEK->QEK_TAMAMO,"QEK_TAMAMO")
	
								For nY:=1 to Len(aAmostra)
								   	QE1->(Dbsetorder(1))
								   	If QE1->(Dbseek(xFilial("QE1") + QF4->QF4_ENSAIO ) )
								   		If Alltrim(QE1->QE1_CARTA) != 'P'
										   	@ Li, 43 PSAY aAmostra[nY,7]      //TIPO
											@ Li, 48 PSAY aAmostra[nY,3]  Picture PesqPict("QF5","QF5_TAMA1")    //TAMANHO AMOSTRA
											@ Li, 63 PSAY aAmostra[nY,1]  Picture PesqPict("QF5","QF5_ACEI1")    //QTDE ACEITE
											@ Li, 73 PSAY aAmostra[nY,2]  Picture PesqPict("QF5","QF5_REJEI1")   //QTDE REJEITE 
											//@ Li, 83 PSAY aAmostra[nY,6]  Picture PesqPict("QF5","QF5_TAMA1")
											//@ Li, 97 PSAY aAmostra[nY,4]  Picture PesqPict("QF5","QF5_ACEI1")
											//@ Li, 106 PSAY aAmostra[nY,5]  Picture PesqPict("QF5","QF5_REJEI1")
										Else
											QE7->(Dbsetorder(3))    //filial + ensaio + produto + revisão
											QE7->(Dbseek(xFilial("QE7") + QF4->QF4_ENSAIO + QF4->QF4_PRODUT + QF4->QF4_REVI ))
											@ Li, 43 PSAY aAmostra[nY,7] 
											@ Li, 48 PSAY aAmostra[nY,3]  Picture PesqPict("QF5","QF5_TAMA1")
											@ Li, 63 PSAY Round( aAmostra[nY,3] * (QE7->QE7_AFS / 100),0 )  Picture PesqPict("QF5","QF5_ACEI1")
											@ Li, 73 PSAY Round( ( aAmostra[nY,3] * (QE7->QE7_AFS / 100) + 1 ) ,0 )  Picture PesqPict("QF5","QF5_REJEI1")    
										
										
										Endif
										
									Endif    
									Li++
							    Next nY
	                		Else
	                		  /*
								@ Li, 49  PSAY QF5->QF5_TAMA1  Picture PesqPict("QF5","QF5_TAMA1")
								@ Li, 63  PSAY QF5->QF5_ACEI1  Picture PesqPict("QF5","QF5_ACEI1")
								@ Li, 73  PSAY QF5->QF5_REJEI1 Picture PesqPict("QF5","QF5_REJEI1")
								//@ Li, 83  PSAY QF5->QF5_TAMA2  Picture PesqPict("QF5","QF5_TAMA1")
								//@ Li, 97  PSAY QF5->QF5_ACEI2  Picture PesqPict("QF5","QF5_ACEI1")
								//@ Li, 106 PSAY QF5->QF5_REJEI2 Picture PesqPict("QF5","QF5_REJEI1")
							  */
							  QE1->(Dbsetorder(1))
								If QE1->(Dbseek(xFilial("QE1") + QF4->QF4_ENSAIO ) )
									If Alltrim(QE1->QE1_CARTA) != 'P'									   
										@ Li, 49 PSAY QF5->QF5_TAMA1  Picture PesqPict("QF5","QF5_TAMA1")    //TAMANHO AMOSTRA
										@ Li, 63 PSAY QF5->QF5_ACEI1      Picture PesqPict("QF5","QF5_ACEI1")    //QTDE ACEITE
										@ Li, 73 PSAY QF5->QF5_REJEI1  Picture PesqPict("QF5","QF5_REJEI1")   //QTDE REJEITE 
								
									Else
										QE7->(Dbsetorder(3))    //filial + ensaio + produto + revisão
										QE7->(Dbseek(xFilial("QE7") + QF4->QF4_ENSAIO + QF4->QF4_PRODUT + QF4->QF4_REVI ))
										//MSGBOX(QF4->QF4_ENSAIO + ' - ' + QE7->QE7_LSE)
										nPos := AT(",",QE7->QE7_LSE)
										nTam := Len(QE7->QE7_LSE)
										nValor := Val( Substr(QE7->QE7_LSE,1,nPos - 1) + '.' + Substr(QE7->QE7_LSE,nPos+1,nTam - nPos) )
										
										@ Li, 49 PSAY QF5->QF5_TAMA1  Picture PesqPict("QF5","QF5_TAMA1")
										@ Li, 63 PSAY Round(  ( QF5->QF5_TAMA1 * nValor ) / 100     ,0 )  Picture PesqPict("QF5","QF5_ACEI1")
										@ Li, 73 PSAY Round(  ( QF5->QF5_TAMA1 * nValor ) / 100 + 1 ,0 )  Picture PesqPict("QF5","QF5_REJEI1")    
										
									Endif
							    Endif
							  
							EndIf 
							If Li > 65    
								Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
							Endif
						EndIf
					Endif
				EndIf
				QF5->(dbSkip())
			EndDo
		EndIf 	
		
		Li++
		Li++
		Li++
		//@ Li, 01 PSAY AllTrim(TitSX3("QER_RASTRE")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QER_RASTRE")[1])))+":"
		//@ Li, 27 PSAY "__________________"
		//@ Li, 62 PSAY AllTrim(TitSX3("QEL_DTENLA")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEL_DTENLA")[1])))+":"
		//@ Li, 85 PSAY "__________________"
		
		
		Li := 80
		
		If Li > 65    
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
		Endif
		
	
		Li+= 2
		@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		Li++
		//@ Li, 01 PSAY "|                | "+Left(TitSX3("QET_INSTR")[1],9)+"  |     Ensaiador     |                                     M E D I C O E S                           |"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
		@ Li, 01 PSAY   "|                |      Ensaiador                 |                                     M E D I C O E S                           |"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
		Li++
		//@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
		@ Li, 01 PSAY "|----------------+--------------------------------+---------------+---------------+---------------+---------------+---------------|"
		Li++
		
		For nCont := 1 to Len(aEnsaios)
		                  
			//Imprime n linhas p/ as medicoes       
			//For nColEns := 1 to mv_par11 
	
				If Li > 65 .And. Len(aEnsaios) >= nCont
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
				Endif
		
				If aEnsaios[nCont,2] <> "TXT"
					//@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |               |               |               |               |               |"
					@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |                                |               |               |               |               |               |"
					Li++
					//@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
					@ Li, 01 PSAY "|----------------+--------------------------------+---------------+---------------+---------------+---------------+---------------|"
					Li++
				Else
					//@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |                                                                               |"
					@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |                                |                                                                               |"
					Li++
					@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
					Li++
				EndIf
	
				If Li > 65  
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
				Endif
		
			//Next nColEns
	
			If Li > 65  
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
			Endif
	
		Next nCont
		
		Li++
		@ Li, 01 PSAY "Laudo : "+"________________________"      //"Laudo : "
		Li++
		Li++
		@ Li, 01 PSAY "Data da Inspeção: ________________________________"
		Li++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Converte a chave passada como param. p/ chave do texto		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChave := QE6->QE6_CHAVE
		cEspeci:="QIEA010 "
		dbSelectArea("QA2")
		QA2->(dbSetOrder(1))
		dbSeek(xFilial("QA2")+cEspeci+cChave)
		Do While !EOF() .and. QA2->QA2_FILIAL+QA2->QA2_ESPEC+QA2->QA2_CHAVE ==;
			xFilial("QA2")+cEspeci+cChave
			Li++
			If Li > 65
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho) 
			Endif
			@ Li, 01 PSAY StrTran(QA2_TEXTO,"\13\10","")
			dbSkip()
		Enddo
		If nConta <> NIL
			nConta++
		Endif	
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Entrada foi importada e marca que já imprimiu a Ficha ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QEP")
	QEP->(dbSetOrder(1))
	If dbSeek(xFilial("QEP")+"1"+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
		DtoS(QEK->QEK_DTENTR)+QEK->QEK_LOTE)
		RecLock("QEP",.F.)
		QEP->QEP_IMPFIC := "S"
		MsUnLock()
	EndIf
	
	dbSelectArea("TRB")
	dbCloseArea()
	
	Ferase(cArqTrb+GetDBExtension())
	Ferase(cArqTrb+OrdBagExt())
Else
	MessagedLG("Não existe entrada cadastrada para o produto selecionado")
	lRet:=.F.
Endif
	
Return(lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³GeraTrab	³                          	    ³Data  ³11.03.98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ GeraTrab()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion GeraTrab(lR4, oReport)
Local cCondR47 			:= ''
Default lR4  			:= .F.
Default oReport			:= Nil

If lR4
	If !Empty(AllTrim(oReport:Section(1):GetAdvplExp("QE7")))
		cCondR47 := oReport:Section(1):GetAdvplExp("QE7") 
	EndIf

	If !Empty(cCondR47)
		While !Eof() .And. xFilial("QE7")==QE7_FILIAL .And. QE7_PRODUTO+QE7_REVI == cProduto .And. QE7->(&(cCondR47))
			RecLock("TRB",.T.)
			TRB->PRODUTO	:= QEK->QEK_PRODUTO
			TRB->REVI		:= QEK->QEK_REVI
			TRB->ENSAIO 	:= QE7->QE7_ENSAIO
			TRB->METODO 	:= QE7->QE7_METODO
			TRB->TIPO		:= QE7->QE7_TIPO
			TRB->UNIMED 	:= QE7->QE7_UNIMED
			TRB->NOMINA 	:= QE7->QE7_NOMINA
			TRB->LIE 		:= QE7->QE7_LIE
			TRB->LSE 		:= QE7->QE7_LSE
			TRB->PLAMO		:= QE7->QE7_PLAMO
			TRB->NIVEL  	:= QE7->QE7_NIVEL
			TRB->AM_INS 	:= QE7->QE7_AM_INS
			TRB->LABOR		:= QE7->QE7_LABOR
			TRB->SEQLAB 	:= QE7->QE7_SEQLAB
			TRB->MINMAX 	:= QE7->QE7_MINMAX
			MsUnlock()
			dbSelectArea("QE7")
			dbSkip()
		Enddo
	Else 
		While !Eof() .And. xFilial("QE7")==QE7_FILIAL .And. QE7_PRODUTO+QE7_REVI == cProduto 
			RecLock("TRB",.T.)
			TRB->PRODUTO	:= QEK->QEK_PRODUTO
			TRB->REVI		:= QEK->QEK_REVI
			TRB->ENSAIO 	:= QE7->QE7_ENSAIO
			TRB->METODO 	:= QE7->QE7_METODO
			TRB->TIPO		:= QE7->QE7_TIPO
			TRB->UNIMED 	:= QE7->QE7_UNIMED
			TRB->NOMINA 	:= QE7->QE7_NOMINA
			TRB->LIE 		:= QE7->QE7_LIE
			TRB->LSE 		:= QE7->QE7_LSE
			TRB->PLAMO		:= QE7->QE7_PLAMO
			TRB->NIVEL  	:= QE7->QE7_NIVEL
			TRB->AM_INS 	:= QE7->QE7_AM_INS
			TRB->LABOR		:= QE7->QE7_LABOR
			TRB->SEQLAB 	:= QE7->QE7_SEQLAB
			TRB->MINMAX 	:= QE7->QE7_MINMAX
			MsUnlock()
			dbSelectArea("QE7")
			dbSkip()
		Enddo
	Endif	
Else
	While !Eof() .And. xFilial("QE7")==QE7_FILIAL .And. QE7_PRODUTO+QE7_REVI == cProduto
		RecLock("TRB",.T.)
		TRB->PRODUTO	:= QEK->QEK_PRODUTO
		TRB->REVI		:= QEK->QEK_REVI
		TRB->ENSAIO 	:= QE7->QE7_ENSAIO
		TRB->METODO 	:= QE7->QE7_METODO
		TRB->TIPO		:= QE7->QE7_TIPO
		TRB->UNIMED 	:= QE7->QE7_UNIMED
		TRB->NOMINA 	:= QE7->QE7_NOMINA
		TRB->LIE 		:= QE7->QE7_LIE
		TRB->LSE 		:= QE7->QE7_LSE
		TRB->PLAMO		:= QE7->QE7_PLAMO
		TRB->NIVEL  	:= QE7->QE7_NIVEL
		TRB->AM_INS 	:= QE7->QE7_AM_INS
		TRB->LABOR		:= QE7->QE7_LABOR
		TRB->SEQLAB 	:= QE7->QE7_SEQLAB
		TRB->MINMAX 	:= QE7->QE7_MINMAX
		MsUnlock()
		dbSelectArea("QE7")
		dbSkip()
	Enddo
Endif

dbSelectArea("QE8")
While !Eof() .And. xFilial("QE8")==QE8_FILIAL .And. QE8_PRODUTO+QE8_REVI == cProduto 

	If lR4
		If !Empty(AllTrim(oReport:Section(1):GetAdvplExp("QE8")))
			If !QE8->(&(oReport:Section(1):GetAdvplExp("QE8")))
				QE8->(dbSkip())
				Loop
			Endif
		EndIf
	Endif

	RecLock("TRB",.T.)
	TRB->PRODUTO := QEK->QEK_PRODUTO
	TRB->REVI    := QEK->QEK_REVI
	TRB->ENSAIO  := QE8->QE8_ENSAIO
	TRB->METODO  := QE8->QE8_METODO
	TRB->TIPO    := QE8->QE8_TIPO
	TRB->TEXTO   := QE8->QE8_TEXTO
	TRB->PLAMO   := QE8->QE8_PLAMO
	TRB->NIVEL   := QE8->QE8_NIVEL
	TRB->AM_INS  := QE8->QE8_AM_INS
	TRB->LABOR   := QE8->QE8_LABOR
	TRB->SEQLAB  := QE8->QE8_SEQLAB
	MsUnlock()
	dbSelectArea("QE8")
	dbSkip()
Enddo
Return .T.
