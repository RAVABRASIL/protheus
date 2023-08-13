#Include "QIPR040.CH"
#Include "PROTHEUS.CH"
#Include "REPORT.CH"
#Include "Rwmake.ch" 
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QIPR040	³ Autor ³ Marcelo Pimentel      ³ Data ³ 21.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Produtos - Uso        			       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ QIPR040()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Siga Quality - Celerina                            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³ 			                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                          
//Function QIPR040(cProg,cOrdProd,cLote,cNumSer)
***********************
User Function QIPR001()
***********************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	 ³
//³ mv_par01			  // Da Ordem de Produ‡Æo     ?    		 ³
//³ mv_par02			  // Do Lote   			   	  ?    		 ³
//³ mv_par03			  // Do Numero de Serie	      ?    		 ³
//³ mv_par04			  // Ate' Ordem de Produ‡Æo   ?       	 ³
//³ mv_par05			  // Ate Lote  			      ?    		 ³
//³ mv_par06			  // Ate Numero de Serie      ?    		 ³
//³ mv_par07			  // Da Operacao      		  ?		 	 ³
//³ mv_par08			  // Ate Operacao      		  ?	  	 	 ³
//³ mv_par09			  // Apenas a Ult. Operacao   ? 		 ³
//³ mv_par10			  // Cliente 	? 		                 ³
//³ mv_par11			  // Loja 	? 		                     ³  
//³ mv_par12			  // Laboratorio De                      ³  
//³ mv_par13			  // Laboratorio Ate                     ³  
//³ mv_par14			  // Imprime textos justificados ?       ³  
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QIPR040	³ Autor ³ Marcelo Pimentel      ³ Data ³ 21.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Produtos - Uso        			       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ QIPR040()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Siga Quality - Celerina                            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Piment³26/09/01³------³ Melhoria de Performance-Implementado   ³±±
±±³              ³        ³      ³ TCQUERY.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                          

//Static Function QIPR040R3(cOrdProd)
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel 	:="QIPR001"
LOCAL cString	:="QPK"
LOCAL cDesc1	:="Neste relat¢rio serao relacionados os ensaios a serem realizados em ca-"
LOCAL cDesc2	:="da laboratorio, para a validacao da producao."
LOCAL cDesc3	:=""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cTitulo		:= "CHECK-LIST OP"
PRIVATE cRelatorio	:= "QIPR001"
PRIVATE nTamanho	:= "M"
PRIVATE nPagina		:= 1
PRIVATE nRecnoQPK	:= QPK->(Recno())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn	:= {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 , cPerg := "QPR0040"
PRIVATE cArqTRB	:= ''

Private cLote   := "" //If(cLote==NIL .Or. Len(cLote)==0,CriaVar("QPK_LOTE"),cLote) 
Private cNumSer := "" //If(cNumSer==NIL .Or.Len(cNumSer)==0,CriaVar("QPK_NUMSER"),cNumSer)
                                                                                            


PRIVATE cPerg 		:= "QPR0040" //"QPR040"                    
PRIVATE lExisAlEsp	:= Iif(QP6->(FieldPos("QP6_ALTESP")) > 0,.T.,.F.)

PRIVATE cTmpAlias := "TRB" 
Private cOrdProd  := ""

Pergunte(cPerg, .T.)

//QIPR040R3(MV_PAR01)	//OP COMO PARÂMETRO
cOrdProd := MV_PAR01
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	 ³
//³ mv_par01			  // Da Ordem de Produ‡Æo     ?    		 ³
//³ mv_par02			  // Do Lote   			   	  ?    		 ³
//³ mv_par03			  // Do Numero de Serie	      ?    		 ³
//³ mv_par04			  // Ate' Ordem de Produ‡Æo   ?       	 ³
//³ mv_par05			  // Ate Lote  			      ?    		 ³
//³ mv_par06			  // Ate Numero de Serie      ?    		 ³
//³ mv_par07			  // Da Operacao      			?		 ³
//³ mv_par08			  // Ate Operacao      			?		 ³
//³ mv_par09			  // Apenas a Ult. Operacao 	? 		 ³
//³ mv_par10			  // Cliente 	? 		                 ³
//³ mv_par11			  // Loja 	? 		                     ³
//³ mv_par12			  // Laboratorio De                      ³  
//³ mv_par13			  // Laboratorio Ate                     ³  
//³ mv_par14			  // Imprime textos justificados ?       ³  
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.F.)
//If cProg == "MATA650"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obs.: Na funcao QPR040FIC ‚ atualizado o mv_par com o valor  ³
	//³  dos registros correntes.                					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	cPerg := ""
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC2")
DbSelectArea("QPK")
wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,nTamanho)

If nLastKey <> 27
	SetDefault(aReturn,cString)
	
	If nLastKey <> 27
		//If cProg == "MATA650"
		//	dbGoTo(nRecnoQPK)
		//Endif
		RptStatus({|lEnd| R040Imp(@lEnd,wnRel,cString,cOrdProd)},cTitulo)
	EndIf
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ R040Imp	³ Autor ³ Marcelo Pimentel      ³ Data ³ 21.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Ensaios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ R040Imp(lEnd,wnRel,cString)								  ³±±
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
Static Function R040Imp(lEnd,wnRel,cString,cOrdProd)
Local CbCont
Local cOperac	:= ''
Local cDescEns 	:= Space(30)
Local nQtAmostra:= 0  
Local cAMUnica  := ""
Local nContLi	:= 0  
Local nY        := 0
Local aTexto	:= {}
Local aEnsaios 	:= {}
Local lFirst	:= .T.
Local cTipoEns	:=	''
Local cOp		:=	''
Local cProduto	:=	''
Local cRoteiro	:=	''
Local cUnimed	:= ''
Local cTamAmo	:= ''
Local cFatCon	:= ''
Local cTipCon	:= ''
Local cSkTes	:= ''
Local cGrupo	:= ''
Local lProximo	:= .F.
Local aImpPl	:= {}
Local aAmostra  := {}

Local nCount	:= 0
Local aAreaQPK	:= GetArea()
Local cMemo		:= ''
Local nMCount	:= ''
Local nLoop		:= 0
Local cLinha	:= ""
Local cALTESP	:= ""        
Local nC        := 0
Local nCont     := 0
Local cCarta    := "" 
Local cTexObs   := ""
Local aTexObs   := ""
Local cQuery    := ""

Private Titulo	:= cTitulo
Private Cabec1	:= ""
Private Cabec2	:= ""
Private	nomeprog:= "QIPR001"
Private cTamanho:= "M"
Private nTipo	:= 0 
/*
If cProg == "MATA650"
	cPerg := "QPR040"
	Pergunte(cPerg,.F.)
	mv_par01 := cOrdProd
	mv_par02 := cLote   
	mv_par03 := cNumSer  
	mv_par04 := cOrdProd
	mv_par05 := cLote    
	mv_par06 := cNumSer 
	mv_par07 := '  '
	mv_par08 := 'ZZ'
	mv_par09 := 2
	mv_par10 := Space(6)
	mv_par11 := Space(2)
	mv_par12 := Space(6)
	mv_par13 := "ZZZZZZ"
	mv_par14 := 1
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li 		:= 80
m_pag 	:= 1
cbTxt	:= Space(10)
cbCont	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
R040GTrab()
dbSelectArea("TRB")
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cArqTRB+GetDBExtension())
	dbSelectArea("QPK")
	Ferase(cArqTRB+OrdBagExt())
	dbSetOrder( 1 )
	Return .T.
Else
	IndRegua("TRB",cArqTRB,"OP+PRODUT+REVI+ROTEIRO+OPERAC+LABOR+SEQLAB",,,STR0006)      //"Selecionando Registros..."
Endif
*/

///QUERY PRINCIPAL - SELECIONA A OP x ESPECIFICAÇÃO
cQuery := " SELECT " + CHR(13) + CHR(10)
cQuery += " QQK.QQK_CODIGO ROTEIRO, QPK.QPK_OP OP,  QPK.QPK_TAMLOT QUANT, QPK.QPK_UM C2UNIMED , QPK.QPK_LOTE LOTE, QPK.QPK_NUMSER NUMSER " + CHR(13) + CHR(10)
cQuery += " ,QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI, QQK.QQK_OPERAC OPERAC, QQK.QQK_DESCRI DESCRI " + CHR(13) + CHR(10)
cQuery += " ,QP6.QP6_FATCO1 FATCO1,QP6.QP6_TIPCO1 TIPCO1,QP6.QP6_FATCO2 FATCO2,QP6.QP6_TIPCO2 TIPCO2 " + CHR(13) + CHR(10)
cQuery += " ,QP6.QP6_DESCPO DESCPO,QP6.QP6_DTCAD DTCAD,QP6.QP6_DTDES DTDES,QP6.QP6_RVDES RVDES " + CHR(13) + CHR(10)
cQuery += " ,QP6.QP6_DTINI DTINI,QP6.QP6_DOCOBR DOCOBR,QP6.QP6_UNMED1 UNMED1,QP6.QP6_UNMED2 UNMED2 " + CHR(13) + CHR(10)
cQuery += " ,QQK.QQK_CHAVE CHAVE,QQK.QQK_OPERGR OPERGRP " + CHR(13) + CHR(10)
cQuery += " ,QP6.QP6_HISTOR HISTOR " + CHR(13) + CHR(10)
cQuery += " FROM " + CHR(13) + CHR(10)
cQuery += " " + RetSqlName("QPK") + " QPK, " + CHR(13) + CHR(10)
cQuery += " " + RetSqlName("QP6") + " QP6 , "+ CHR(13) + CHR(10) 
cQuery += " " + RetSqlName("QQK") + " QQK , "+ CHR(13) + CHR(10)
cQuery += " " + RetSqlName("SC2") + " SC2  "+ CHR(13) + CHR(10)


cQuery += " WHERE  LEFT(QPK.QPK_OP,6) ='" + Alltrim(mv_par01) + "' "  + CHR(13) + CHR(10)
cQuery += "  AND QQK.QQK_REVIPR = SC2.C2_REVI "  + CHR(13) + CHR(10)

cQuery += " AND Substring(QPK.QPK_OP,1,6)  = SC2.C2_NUM"+ CHR(13) + CHR(10)
cQuery += " AND Substring(QPK.QPK_OP,7,2)  = SC2.C2_ITEM"+ CHR(13) + CHR(10)
cQuery += " AND Substring(QPK.QPK_OP,9,3)  = SC2.C2_SEQUEN"+ CHR(13) + CHR(10)
cQuery += " AND Substring(QPK.QPK_OP,12,2) = SC2.C2_ITEMGRD"+ CHR(13) + CHR(10)

cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") + "' " + CHR(13) + CHR(10)
cQuery += " AND QQK.QQK_FILIAL = '" + xFilial("QQK") + "' " + CHR(13) + CHR(10)
cQuery += " AND QPK.QPK_FILIAL = '" + xFilial("QPK") + "' " + CHR(13) + CHR(10)
cQuery += " AND SC2.C2_FILIAL = '"  + xFilial("SC2") + "' " + CHR(13) + CHR(10) 

cQuery += "  AND QP6.QP6_PRODUT = SC2.C2_PRODUTO " + CHR(13) + CHR(10)
cQuery += "  and QP6.QP6_PRODUT = QPK.QPK_PRODUT " + CHR(13) + CHR(10)
cQuery += "  and QP6.QP6_PRODUT = QQK.QQK_PRODUT " + CHR(13) + CHR(10)
cQuery += "  and QP6.QP6_REVI   = QPK.QPK_REVI  " + CHR(13) + CHR(10)
cQuery += "  and QP6.QP6_REVI   = SC2.C2_REVI   " + CHR(13) + CHR(10)
cQuery += "  AND QPK.QPK_FILIAL = SC2.C2_FILIAL  " + CHR(13) + CHR(10)
cQuery += "  AND QQK.QQK_REVIPR = QPK.QPK_REVI  " + CHR(13) + CHR(10)

cQuery += " AND QPK.D_E_L_E_T_ <> '*' "+ CHR(13) + CHR(10)
cQuery += " AND QP6.D_E_L_E_T_ <> '*'  " + CHR(13) + CHR(10)
cQuery += " AND QQK.D_E_L_E_T_ <> '*'  " + CHR(13) + CHR(10)
cQuery += " AND SC2.D_E_L_E_T_ <> '*'  " + CHR(13) + CHR(10)
cQuery += " ORDER BY  QP6_PRODUT,QP6_REVI, QQK.QQK_OPERAC " + CHR(13) + CHR(10)
MemoWrite("C:\TEMP\TRB.SQL", cQuery)
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TRB"
TcSetField( "TRB", "DTCAD"	,"D")
TcSetField( "TRB", "DTDES"	,"D")
TcSetField( "TRB", "DTINI"	,"D")

TRB->(dbGoTop())
SetRegua(RecCount())
While TRB->(!EOF())
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ‚ nova pagina 							   	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	
	If Li > 65
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	ENDIF
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO PRODUTO 											 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ Li, 001 PSAY AllTrim(TitSX3("QPK_OP")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_OP")[1])))+":"
		@ Li, 044 PSAY TRB->OP 
		
		If !Empty(TRB->LOTE)
			@ Li, 064 PSAY STR0045 
			@ Li, 070 PSAY TRB->LOTE 
		EndIf
		
		If !Empty(TRB->NUMSER)
			@ Li, 094 PSAY STR0046
			@ Li, 112 PSAY TRB->NUMSER 
		EndIF
		
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QPK_TAMLOT")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_TAMLOT")[1])))+":"
		@ Li, 044 PSAY AllTrim(Str(TRB->QUANT))    + " " +  TRB->C2UNIMED
		@ Li, 092 PSAY "Data        ____ /____ /____"
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_PRODUT")[1])+" - "+AllTrim(TitSX3("QP6_REVI")[1])+Replicate(".",38-(len(Alltrim(TitSx3("QP6_PRODUT")[1]))+len(Alltrim(TitSx3("QP6_REVI")[1]))))+":"
		@ Li, 044 PSAY TRB->PRODUT + " - " + TRB->REVI
		Li++
		
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_DESCPO")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_DESCPO")[1])))+":"
		@ Li, 044 PSAY TRB->DESCPO
		
		Li++
		@ Li, 001 PSAY "Data do cadastro" +REPLICATE(".",41 - Len(AllTrim("Data do cadastro") ) )+":"
		@ Li, 044 PSAY DTOC(TRB->DTINI)
		Li++
	//Endif
    
	IF ( lEnd )
		@Prow()+1,001 PSAY OemToAnsi(STR0007)	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no grupo de produtos 								  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrupo := Posicione("QPA",2,xFilial("QPA")+TRB->PRODUT,"QPA_GRUPO")
	
	If TRB->OPERAC	!= cOperac
		cOperac := TRB->OPERAC
	EndIf
	
	If lFirst .Or. cOp != TRB->OP+TRB->LOTE+TRB->NUMSER
		cOP := TRB->OP+TRB->LOTE+TRB->NUMSER
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define o Fator Conversao, se nao estiver definido             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->UNMED1 == TRB->C2UNIMED
			cFatCon := TRB->FATCO1
			cTipCon := TRB->TIPCO1
		ElseIf TRB->UNMED2 == TRB->C2UNIMED
			cFatCon := TRB->FATCO2
			cTipCon := TRB->TIPCO2
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Tamanho da Amostra                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
		If Superval(cFatCon) <> 0
			cFatCon := StrTran(cFatcon,",",".")
			If cTipCon == "D"
				cTamAmo := Str(TRB->QUANT / Superval(cFatCon))
			Else
				cTamAmo := Str(TRB->QUANT * Superval(cFatCon))
			EndIf                 
		Else
			cTamAmo := Str(TRB->QUANT)
		EndIf
				
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exibe Historico do Produto	 ( campo memo )       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMemo	:= MSMM(TRB->HISTOR)
		nMCount	:= MlCount( cMemo, 80 )
				
		If !Empty(nMCount)
			@ Li, 001 PSAY AllTrim(TitSX3("QP6_HISTOR")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_HISTOR")[1])))+":"
			For nLoop := 1 To nMCount
				cLinha := MemoLine( cMemo, 80, nLoop )
				@li,044 PSAY StrTran( cLinha, Chr(13)+Chr(10), "" )
				li++
			Next nLoop 
		EndIf
	
		//@ Li, 001 PSAY STR0011+ TRB->ROTEIRO		//"ROTEIRO  ==> "
		//Li++
		lFirst := .F.
	EndIf
	@ Li, 001 PSAY STR0012 + TRB->OPERAC + " - " + TRB->DESCRI	//"OPERACAO ==> "
	Li++
	@li,000 PSAY __PrtThinLine()
	Li++
	
		
	@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
	//@ Li, 035 PSAY STR0013	//"Labor."
	@ Li, 015 PSAY "Descrição"
	//@ Li, 042 PSAY TitSX3("QP7_METODO")[1]
	@ Li, 055 PSAY STR0014	//"Un. Med."
	@ Li, 069 PSAY STR0015	//"Nominal"
	@ Li, 079 PSAY "Limite Inf." //STR0016	//"L.I.E."
	@ Li, 092 PSAY "Limite Sup." //STR0017	//"L.S.E."
	@ Li, 105 PSAY "Tam.Amostra RAVA" //STR0018	//"Pl "
	//@ Li, 099 PSAY TitSX3("QP7_NIVEL")[1]
	//@ Li, 112 PSAY TitSX3("QQ1_INSTR")[1]
	//@ Li, 129 PSAY "ST"
	Li++
	@li,000 PSAY __PrtThinLine()
    
	If lExisAlEsp	
		cALTESP	:= TRB->ALTESP
	Endif
	
	cChave	:=TRB->CHAVE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados dos ensaios 						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEnsaios := {}
	dbSelectArea("TRB")
	
	While !EOF() .And. cOperac == TRB->OPERAC .And. cOp == TRB->OP+TRB->LOTE+TRB->NUMSER
		
		If Li > 65
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ DADOS DO PRODUTO 											 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ Li, 001 PSAY AllTrim(TitSX3("QPK_OP")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_OP")[1])))+":"
			@ Li, 044 PSAY TRB->OP 
			
			If !Empty(TRB->LOTE)
				@ Li, 064 PSAY STR0045 
				@ Li, 070 PSAY TRB->LOTE 
			EndIf
			
			If !Empty(TRB->NUMSER)
				@ Li, 094 PSAY STR0046
				@ Li, 112 PSAY TRB->NUMSER 
			EndIF
			
			Li++
			@ Li, 001 PSAY AllTrim(TitSX3("QPK_TAMLOT")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_TAMLOT")[1])))+":"
			@ Li, 044 PSAY AllTrim(Str(TRB->QUANT))    + " " +  TRB->C2UNIMED
			@ Li, 092 PSAY "Data        ____ /____ /____"
			Li++
			@ Li, 001 PSAY AllTrim(TitSX3("QP6_PRODUT")[1])+" - "+AllTrim(TitSX3("QP6_REVI")[1])+Replicate(".",38-(len(Alltrim(TitSx3("QP6_PRODUT")[1]))+len(Alltrim(TitSx3("QP6_REVI")[1]))))+":"
			@ Li, 044 PSAY TRB->PRODUT + " - " + TRB->REVI
			Li++
			
			@ Li, 001 PSAY AllTrim(TitSX3("QP6_DESCPO")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_DESCPO")[1])))+":"
			@ Li, 044 PSAY TRB->DESCPO
			
			Li++
			@ Li, 001 PSAY "Data do cadastro" +REPLICATE(".",41 - Len(AllTrim("Data do cadastro") ) )+":"
			@ Li, 044 PSAY DTOC(TRB->DTINI)
			Li++
			
			@ Li, 001 PSAY STR0012 + TRB->OPERAC + " - " + TRB->DESCRI	//"OPERACAO ==> "
			Li++
			@li,000 PSAY __PrtThinLine()
			Li++
			
			@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
			//@ Li, 035 PSAY STR0013	//"Labor."
			@ Li, 015 PSAY "Descrição"
			//@ Li, 042 PSAY TitSX3("QP7_METODO")[1]
			@ Li, 055 PSAY STR0014	//"Un. Med."
			@ Li, 069 PSAY STR0015	//"Nominal"
			@ Li, 079 PSAY "Limite Inf." //STR0016	//"L.I.E."
			@ Li, 092 PSAY "Limite Sup." //STR0017	//"L.S.E."
			@ Li, 105 PSAY "Tam.Amostra RAVA" //STR0018	//"Pl "
			//@ Li, 099 PSAY TitSX3("QP7_NIVEL")[1]
			//@ Li, 112 PSAY TitSX3("QQ1_INSTR")[1]
			//@ Li, 129 PSAY "ST"
			Li++
			@li,000 PSAY __PrtThinLine()
		Endif
		
		cProduto	:=TRB->PRODUT
		cRoteiro	:=TRB->ROTEIRO
		cOperac		:=TRB->OPERAC
		cUnimed		:=TRB->C2UNIMED
		
	
		    ///////////QUERY PARA ENSAIOS TIPO TEXTO - QP8
			//cKey   := "QP6_PRODUT+QP6_REVI+QP8_CODREC+QP8_OPERAC+QP8_LABOR+QP8_SEQLAB"
			cKey   := "QP6_PRODUT+QP6_REVI+QP6_CODREC+QQK_OPERAC "
			cQuery := "SELECT "   + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP8.QP8_CODREC CODREC, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP8.QP8_OPERAC OPERAC, QP8.QP8_LABOR LABOR, QP8.QP8_SEQLAB SEQLAB, "  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, "  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, "  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, "  + CHR(13) + CHR(10)		 
			cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP8.QP8_ENSAIO ENSAIO, QP8.QP8_ENSOBR ENSOBR, QP8.QP8_TEXTO TEXTO, QP8.QP8_METODO METODO, "	  + CHR(13) + CHR(10)		 
		
			cQuery += " QP6.QP6_HISTOR HISTOR, "  + CHR(13) + CHR(10)		 
			If lExisAlEsp
				cQuery += " QP6.QP6_ALTESP ALTESP, "  + CHR(13) + CHR(10)		 
			EndIf			
			cQuery += " QP8.QP8_PLAMO PLAMO, QP8.QP8_DESPLA DESPLA, QP8.QP8_NIVEL NIVEL "   + CHR(13) + CHR(10)		 
	
			cQuery += "FROM "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QPK") + " QPK, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QP6") + " QP6, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QQK") + " QQK, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QP8") + " QP8 "   + CHR(13) + CHR(10)		 
	
			cQuery += "WHERE "   + CHR(13) + CHR(10)		 
	 
			cQuery += " QPK.QPK_OP ='"			+TRB->OP + "'"		  + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.QPK_LOTE ='"	+TRB->LOTE + "'"		  + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.QPK_NUMSER ='"	+TRB->NUMSER + "'"	  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_OPERAC ='"	+ cOperac + "'"	  + CHR(13) + CHR(10)		 
					
			cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.QP8_FILIAL = '" + xFilial("QP8") +"'"  + CHR(13) + CHR(10)		 
		
			cQuery += " AND QP6.QP6_PRODUT = '"	+ TRB->PRODUT	+"'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QP6.QP6_REVI = '" 	+ TRB->REVI		+"'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_PRODUT ='" 	+ TRB->PRODUT	+"'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_CODIGO ='"  + TRB->ROTEIRO   +"'"  
			cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"			  + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.QP8_PRODUT = QP6.QP6_PRODUT "		  + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.QP8_REVI = QPK.QPK_REVI "			  + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.QP8_CODREC = QQK.QQK_CODIGO "		  + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.QP8_OPERAC = QQK.QQK_OPERAC "		 		 + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.D_E_L_E_T_ <> '*'"  + CHR(13) + CHR(10)		 
			cQuery += " AND QP6.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QP8.D_E_L_E_T_ <> '*'" 	 + CHR(13) + CHR(10)		 
			cQuery += " ORDER BY " + SqlOrder(cKey) + CHR(13) + CHR(10)		 
			cQuery := ChangeQuery(cQuery)
			MemoWrite("C:\Temp\TRB1.SQL" , cQuery )  
			If Select("TRB1") > 0
				DbSelectArea("TRB1")
				DbCloseArea()
			EndIf
			
			TCQUERY cQuery NEW ALIAS "TRB1"
		
		//Else
			////////////////////QUERY DOS ENSAIOS QP7 - NÃO TEXTO
			cKey   := "QP6_PRODUT+QP6_REVI+QP6_CODREC+QQK_OPERAC "
			cQuery := "SELECT "  
			cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP7.QP7_CODREC CODREC, " + CHR(13) + CHR(10)		 
			cQuery += " QP7.QP7_OPERAC OPERAC, QP7.QP7_LABOR LABOR, QP7.QP7_SEQLAB SEQLAB, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "		  + CHR(13) + CHR(10)		 
			cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, "	  + CHR(13) + CHR(10)		 
			cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "		  + CHR(13) + CHR(10)		 
			cQuery += " QP7.QP7_ENSAIO ENSAIO, QP7.QP7_ENSOBR ENSOBR, QP7.QP7_UNIMED UNIMED, "	  + CHR(13) + CHR(10)		 
			cQuery += " QP7.QP7_NOMINA NOMINA, QP7.QP7_LIE LIE, QP7.QP7_NIVEL NIVEL, QP7.QP7_METODO METODO, "   + CHR(13) + CHR(10)		 
				
			cQuery += " QP6.QP6_HISTOR HISTOR,"   + CHR(13) + CHR(10)		 
			If lExisAlEsp
				cQuery += " QP6.QP6_ALTESP ALTESP,"   + CHR(13) + CHR(10)		 
			EndIf
				
			cQuery += " QP7.QP7_LSE LSE, QP7.QP7_PLAMO PLAMO, QP7.QP7_DESPLA DESPLA, "   + CHR(13) + CHR(10)		 
			cQuery += " QP7.QP7_MINMAX MINMAX "   + CHR(13) + CHR(10)		 
		
			cQuery += " FROM "   + CHR(13) + CHR(10)		 
			
			cQuery += "	" + RetSQLName("QPK") + " QPK, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QP6") + " QP6, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QQK") + " QQK, "   + CHR(13) + CHR(10)		 
			cQuery += "	" + RetSQLName("QP7") + " QP7 "   + CHR(13) + CHR(10)		 
	
			cQuery += "WHERE "   + CHR(13) + CHR(10)		 
			cQuery += " QPK.QPK_OP ='"			+TRB->OP + "'"		  + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.QPK_LOTE ='"	+TRB->LOTE + "'"		  + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.QPK_NUMSER ='"	+TRB->NUMSER + "'"	  + CHR(13) + CHR(10)		 
		    cQuery += " AND QQK.QQK_OPERAC ='"	+ cOperac + "'"	  + CHR(13) + CHR(10)		 
		    				
			cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'"	  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'"	  + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.QP7_FILIAL = '" + xFilial("QP7") +"'"	  + CHR(13) + CHR(10)		 
		
			cQuery += " AND QP6.QP6_PRODUT = '" + TRB->PRODUT +"'"	  + CHR(13) + CHR(10)		 
			cQuery += " AND QP6.QP6_REVI = '" + TRB->REVI +"'"	  + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_PRODUT ='" + TRB->PRODUT +"'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_CODIGO ='" + TRB->ROTEIRO +"'"  
			cQuery += " AND QQK.QQK_OPERAC = '" + TRB->OPERAC	+ "' " + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"		  + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.QP7_PRODUT = QP6.QP6_PRODUT "	  + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.QP7_REVI = QPK.QPK_REVI " 		  + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.QP7_CODREC = QQK.QQK_CODIGO "	  + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.QP7_OPERAC = QQK.QQK_OPERAC "	  + CHR(13) + CHR(10)		 
			cQuery += " AND QPK.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QP6.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QQK.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
			cQuery += " AND QP7.D_E_L_E_T_ <> '*'"   + CHR(13) + CHR(10)		 
		
			cQuery += " ORDER BY " + SqlOrder(cKey) + CHR(13) + CHR(10)		 
			MemoWrite("C:\TEMP\TRB2.SQL", cQuery )
			///////////////////FIM DA QUERY DOS ENSAIOS QP7
			If Select("TRB2") > 0
				DbSelectArea("TRB2")
				DbCloseArea()
			EndIf
			
			TCQUERY cQuery NEW ALIAS "TRB2"
		//Endif
		DbSelectArea("TRB1")
		If !TRB1->(EOF())      //texto
			While !TRB1->(EOF())
				QP1->(dbSetOrder(1))
				IF QP1->(dbSeek(xFilial("QP1")+TRB1->ENSAIO))
					cDescEns := Alltrim(Substr(QP1->QP1_DESCPO,1,30))
					cTipoEns := QP1->QP1_TPCART
					nQtAmostra := QP1->QP1_QTDE
					cAMUnica   := QP1->QP1_AMUNIC  //SE A AMOSTRA FOR ÚNICA não imprime a qtde cadastrada no ensaio
				Endif
		
		
				////imprime os ensaios relativos à 1a. query TR1 - CASO HAJA
				AADD(aEnsaios,{TRB1->ENSAIO,cTipoEns,TRB1->PLAMO,TRB1->DESPLA,cProduto,TRB1->REVI,cRoteiro,cOperac,cTamAmo, cDescEns})
				Li++
				@ Li, 000 PSAY Iif(TRB1->ENSOBR=="S","* ","  ") + TRB1->ENSAIO + " " + Subs(cDescEns,1,23)
				
				@ Li, 042 PSAY TRB1->METODO
				nContLi	:= 0
				If cTipoEns == "X"		//Se o tipo da carta for igual a "TXT"
					//aTexto := {}
					Aadd(aTexto,Substr(TRB1->TEXTO,1,34))
					Aadd(aTexto,Substr(TRB1->TEXTO,35,35))
					Aadd(aTexto,Substr(TRB1->TEXTO,70,31))
					@ Li, 056 PSAY TRB1->UNMED1  //aTexto[1]
					@ Li, 070 PSAY aTexto[1]
					For fr := 1 to Len(aTexto)
						If nContLi < 2
							If !Empty (aTexto[2])
								Li++
								@ Li, 070 PSAY aTexto[2]
								nContLi++
							EndIf
						EndIf
			
						If nContLi < 3
							If !Empty (aTexto[3])
								Li++
								@ Li, 070 PSAY aTexto[3]
								nContLi++
							Endif
						EndIf
						
					Next
					
					aTexto 	:= {}					
					nContLi	:= 0
		       
				EndIf
		        
				If Alltrim(cAMUnica) = "S"
					@ Li, 110 PSAY "Unica"
				Else
					@ Li, 110 PSAY nQtAmostra Picture "@ 99,999.99"
				Endif				
				Li++
				
				@li,000 PSAY __PrtThinLine()
				Li++
				If Li > 65
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
					@li,000 PSAY __PrtThinLine()
					Li++
					@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
					@ Li, 035 PSAY "Descrição"
					@ Li, 059 PSAY "Un. Med."
					@ Li, 069 PSAY "Nominal"
					@ Li, 079 PSAY "Limite Inf." //STR0016	//"L.I.E."
					@ Li, 092 PSAY "Limite Sup." //STR0017	//"L.S.E."
					@ Li, 105 PSAY "Tam.Amostra Rava" //STR0018	//"Pl "		
					@ Li, 096 PSAY "Tam.Amostra Rava"
					Li++
					@li,000 PSAY __PrtThinLine()
				Endif		
				///fim da impressão dos ensaios query TR1 
				DbSelectArea("TRB1")
				TRB1->(DBSKIP())
			Enddo
		Endif
	
		
		If !TRB2->(EOF())  //não texto 
			While !TRB2->(EOF())
				QP1->(dbSetOrder(1))
				IF QP1->(dbSeek(xFilial("QP1")+TRB2->ENSAIO))
					cDescEns := Substr(QP1->QP1_DESCPO,1,30)
					cTipoEns := QP1->QP1_TPCART
					nQtAmostra := QP1->QP1_QTDE
				Endif
		
		
				////imprime os ensaios relativos à 1a. query TR1 - CASO HAJA
				AADD(aEnsaios,{TRB2->ENSAIO,cTipoEns,TRB2->PLAMO,TRB2->DESPLA,cProduto,TRB2->REVI,cRoteiro,cOperac,cTamAmo, cDescEns })
				Li++
				@ Li, 000 PSAY Iif(TRB2->ENSOBR=="S","* ","  ") + TRB2->ENSAIO + " " + Subs(cDescEns,1,23)
				
				@ Li, 042 PSAY TRB2->METODO
			
				If cTipoEns != "X"	
					@ Li, 055 PSAY Posicione("SAH",1,xFilial("SAH")+TRB2->UNIMED,"AH_UMRES")
					@ Li, 072 PSAY AllTrim(TRB2->NOMINA)
					
					If TRB2->MINMAX == "1"           //controla min e max
						@ Li, 079 PSAY AllTrim(TRB2->LIE)
						@ Li, 092 PSAY AllTrim(TRB2->LSE)
					ElseIf TRB2->MINMAX == "2"      //controla min
						@ Li, 079 PSAY AllTrim(TRB2->LIE)
						@ Li, 092 PSAY "---" //">>>"
					ElseIf TRB2->MINMAX == "3"      //controla max
						@ Li, 079 PSAY "---" //"<<<"
						@ Li, 092 PSAY AllTrim(TRB2->LSE)
					EndIf
					
				EndIf
		        
				
				@ Li, 110 PSAY nQtAmostra Picture "@ 99,999.99"
				
				Li++
				//Li++
				@li,000 PSAY __PrtThinLine()
				Li++
				If Li > 65
					Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
					@li,000 PSAY __PrtThinLine()
					Li++
					@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
					@ Li, 035 PSAY "Descrição"
					@ Li, 059 PSAY "Un. Med."
					@ Li, 069 PSAY "Nominal"
					@ Li, 079 PSAY "Limite Inf." //STR0016	//"L.I.E."
					@ Li, 092 PSAY "Limite Sup." //STR0017	//"L.S.E."
					@ Li, 105 PSAY "Tam.Amostra Rava" //STR0018	//"Pl "		
					//@ Li, 096 PSAY "Tam.Amostra Rava"
					Li++
					@li,000 PSAY __PrtThinLine()
				Endif		
				///fim da impressão dos ensaios query TR1
				DbselectArea("TRB2")
				TRB2->(DBSKIP())
			Enddo
		
		Endif
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o skip-teste										 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Verifica se tem skip-teste definido
		cSkTes := "   "
		QPH->(dbSetOrder(1))
		If QPH->(dbSeek(xFilial("QPH")+cProduto+cRoteiro+cOperac+TRB->ENSAIO))
			cSkTes := "CER"
			// Verifica o historico skip-teste individual
			QPY->(dbSetOrder(1))
			If QPY->(dbSeek(xFilial("QPY")+cRoteiro+cOperac+cProduto+Dtos(TRB->C2EMISSAO)+TRB->LOTE+TRB->ENSAIO+If(FieldPos("QPY_ORDPRD") > 0,TRB->OP,"")))
				cSkTes := "INS"
			EndIf
		Else
			cSkTes := "N/A"   // indica que nao foi definido
		EndIf			
		If Empty(cSkTes) .Or. cSkTes == "N/A"
			// Verifica o historico skip-teste por grupo
			QPZ->(dbSetOrder(1))
			If QPZ->(dbSeek(xFilial("QPZ")+cGrupo+Dtos(TRB->C2EMISSAO)+padr(cOp,16)+TRB->ENSAIO))
				cSkTes := "INS"
			Else
				// Verifica se tem skip-teste definido
				QPI->(dbSetOrder(1))
				If QPI->(dbSeek(xFilial("QPI")+cGrupo+cRoteiro+cOperac+TRB->ENSAIO))
					cSkTes := "CER"
				Else
					cSkTes := "N/A" //indica que nao foi definido
				EndIf
			EndIf
		EndIf      
		//@Li, 129 PSAY cSkTes
		*/		
		dbSelectArea("TRB")
		TRB->(dbSkip())
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CABECALHO DO PLANO DE AMOSTRAGEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aEnsaios) > 0	
		Li+=2             
		
		@ Li, 000 PSAY AllTrim(TitSX3("QP7_ENSAIO")[1])
		@ Li, 009 PSAY "Aceite"
		@ Li, 018 PSAY "Rejeite"
		@ Li, 027 PSAY "Tam.Amostra NORMA"
		@ Li, 050 PSAY 'Plano de Amostragem'
		Li++
		@li,000 PSAY __PrtThinLine()
		Li++
		If Li > 65
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif

		For nC := 1 To Len(aEnsaios)
			If Li > 65
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			Endif     
		    
		//AADD(aEnsaios,{TRB->ENSAIO,cTipoEns,TRB->PLAMO,TRB->DESPLA,cProduto,TRB->REVI,cRoteiro,cOperac,cTamAmo})
			cCarta := QPCarta(aEnsaios[nC,1])
			QQH->(dbSetOrder(1))
			If QQH->(dbSeek(xFilial('QQH')+aEnsaios[nC,5]+aEnsaios[nC,6]+aEnsaios[nC,7]+aEnsaios[nC,8]+aEnsaios[nC,1]))
				
				cAmost  := QQH->QQH_AMOST
				aImpPl  := QEP_RetAmostra(aEnsaios[nC,3],QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(aEnsaios[nC,9])),8),"QPK_TAMLOT",.F.)
				aAmostra:= QEP_RetAmostra(aEnsaios[nC,3],QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(aEnsaios[nC,9])),8),"QPK_TAMLOT",.F.)
				//msgbox("CAIU AQUI")
				//IMPRIME PLANO AMOSTRAGEM / TAM. AMOSTRA
				//estava comentado
				If aEnsaios[nC,3]=="I"
					
					For nCount := 1 To Len(aImpPl)
						@ Li,000 PSAY aEnsaios[nC,1]
						@ Li,009 PSAY aImpPl[nCount,1]
						@ Li,018 PSAY aImpPl[nCount,2]
						@ Li,032 PSAY aAmostra[nCount,1]
						@ Li,045 PSAY aEnsaios[nC,3]
   			 			@ Li,050 PSAY Alltrim(aEnsaios[nC,4])+STR0045+aImpPl[nCount,7] //"  Tipo : "
						Li++
					Next nCount 
				
					
				Else 
					@ Li,000 PSAY aEnsaios[nC,1]	//codigo ensaio
					@ Li,009 PSAY aImpPl[2]         //aceite   	
					@ Li,018 PSAY aImpPl[3]         //rejeite
					@ Li,032 PSAY aAmostra[1]       //tam amostra
					If aEnsaios[nC,3] !="N"
						@ Li,045 PSAY aEnsaios[nC,3]    //código do plano amostragem = N
   						@ Li,050 PSAY Substr(aEnsaios[nC,4],1,90)   //NQA 1.5 Nivel Amost. 02 Amostragem SN
   					Else
   						@Li,050 PSAY "NORMA NBR5426" + " - " + Substr(aEnsaios[nC,4],1,90)
   					Endif
					Li++
				EndIF
				///estava comentado	
			EndIF						
		
		Next
		@li,000 PSAY __PrtThinLine()
		Li++
	//Else
		//alert("não entrou no array")
	EndIf
	
	//If Li > 54
	//	Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	//Endif
	Li++
	@Li,001 PSAY "Inspetor(a)"
	@ Li,034 PSAY "Supervisor"
	@ Li,062 PSAY "Resp.Qualidade"       
	@ Li,095 PSAY "Coordenador(a)"
	Li+=3 
	@ Li,001 PSAY "_________________________"
	@ Li,034 PSAY "_______________________"
	@ Li,062 PSAY "_________________________"
	@ Li,095 PSAY "_________________________"

	//Li+= 4
	//@ Li,034 PSAY "Superv.Produção: _________________________"
	Li+=2
	
	
	//If Li > 50
	//	Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	//Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME MENSAGEM DE NOVAS ESPECIFICACOES 	         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExisAlEsp
		If cALTESP == "S"
			Li+=2
			@ Li, 45 PSAY "*** ORDEM DE PRODUCAO COM NOVAS ESPECIFICACOES ***"
			Li+=2
		EndIf
	EndIf
	
	@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
	Li++
	//@ Li, 01 PSAY "|                | "+Left(TitSX3("QPT_INSTR")[1],9)+"  |"+STR0025+"|"+STR0026+"|"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
	@ Li, 01 PSAY "|          |       NÃO CONFORMIDADE                         |  1a.Inspeção          |     2a.Inspeção         |    3a.Inspeção    |"                      
	Li++
	//@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
	@ Li, 01 PSAY "|----------+------------------------------------------------+-----------------------+-------------------------+-------------------|"
	                                                                         //+  1a.Inspeção          +     2a.Inspeção         +    3a.Inspeção    |
	Li++
	
	//If Li > 52
	//	Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	//Endif
	nEspacos := 47
	For nCont := 1 to Len(aEnsaios)
		//If aEnsaios[nCont,2] <> "X"
			//@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |               |               |               |               |               |"
			@ Li, 01 PSAY "| " + Alltrim(aEnsaios[nCont,1]) +  "   | " + aEnsaios[nCont,10] + Space(nEspacos - Len(aEnsaios[nCont,10]))  + "|                       |                         |                   |"
			Li++
			//@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			@ Li, 01 PSAY "|----------+------------------------------------------------+-----------------------+-------------------------+-------------------|"
			Li++
		//Else
		//	@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |                                                                               |"
		//	Li++
		//	@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		//	Li++
		//Endif
		If Li > 65 .And. Len(aEnsaios) > nCont
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
			Li++
			//@ Li, 01 PSAY "|                | "+Left(TitSX3("QPT_INSTR")[1],9)+"  |"+STR0025+"|"+STR0026+"|"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
			@ Li, 01 PSAY "|          |       NÃO CONFORMIDADE                         |  1a.Inspeção          |     2a.Inspeção         |    3a.Inspeção    |"                      
			Li++
			//@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			@ Li, 01 PSAY "|----------+------------------------------------------------+-----------------------+-------------------------+-------------------|"
			Li++
		Endif
	Next
	fr := 1
	Li++
	Li++
	For fr := 1 to 3
		If Li > 65 
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif
		
		@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		Li++
		@ Li, 01 PSAY "| "+Alltrim(Str(fr)) + "a.Inspeção                                                                                                                     |"
		Li++                                                                                                                                               
		@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		Li++
		@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		Li++
		//@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		//Li++
		//@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		//Li++
		//@ Li, 01 PSAY "| 2a.Inspeção                                                                                                                     |"
		//Li++
		//@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
		//Li++
		//@ Li, 01 PSAY "| 3a.Inspeção                                                                                                                     |"
		//Li++
		//@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
	Next
	@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
	Li++
	Li++
	@ Li, 01 PSAY "Laudo: __________________________________________"
	
	Li++
	
	aEnsaios:={}
	//Li++
	//@ Li, 01 PSAY STR0027+"_______________________"      //"Laudo : "
	//Li++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Converte a chave passada como param. p/ chave do texto		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTexObs:= QA_Rectxt(cChave,"QIPA010 ")
	Li++         
	
	//If mv_par14 == 1
		//aTexObs := JustificaTXT(cTexObs,130) 
		//For nY:=1 to Len(aTexObs)
		//	Li++
		//	If Li > 65
		//		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		//	Endif
		//	@ Li, 01 PSAY aTexObs[nY]
		//Next nY
    /*
    Else                               
		aTexObs := {}
		Q_MemoArray(cTexObs,aTexObs,130)
		For nY:=1 to Len(aTexObs)
			Li++
			If Li > 52
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			Endif
			@ Li, 01 PSAY aTexObs[nY]
		Next nY

	EndIF
	*/
	
	Li:=80

	
EndDo

If Li != 80
	roda(CbCont,cbtxt,nTamanho)
EnDif

QPZ->(dbSetOrder(1))
QPI->(dbSetOrder(1))
dbSelectArea("TRB")
dbCloseArea()

Ferase(cArqTRB+GetDBExtension())
dbSelectArea("QPK")
Ferase(cArqTRB+OrdBagExt())
dbSetOrder( 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o registro QPK         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaQPK)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra a impressao desta ficha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³R040GTrab	³ Autor ³ Marcelo Pimentel 	  	³ Data ³ 11.03.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ R040GTrab()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R040GTrab()

Local cQuery		:= ''
Local cProdRev		:= ''
Local nRecQQK		:= 0
Local cChaveQPK		:= ''
Local cRoteiro		:= ''
Local cCond			:= ''
Local cRevi			:= ''
Local aTam			:= {}
Local aCampos	    := {}      
Local lTop          := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho  									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("QQK_CODIGO")	;AADD(aCampos,{"ROTEIRO"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_OPERAC")	;AADD(aCampos,{"OPERAC"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_CHAVE" ) 	;AADD(aCampos,{"CHAVE"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_DESCRI")	;AADD(aCampos,{"DESCRI"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_OPERGR")	;AADD(aCampos,{"OPERGRP"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_PRODUT")	;AADD(aCampos,{"PRODUT"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_REVI"  )	;AADD(aCampos,{"REVI"     ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_OP"    )	;AADD(aCampos,{"OP"       ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_LOTE"  )	;AADD(aCampos,{"LOTE"     ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_NUMSER")	;AADD(aCampos,{"NUMSER"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO1")	;AADD(aCampos,{"FATCO1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_TIPCO1")	;AADD(aCampos,{"TIPCO1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO2")	;AADD(aCampos,{"FATCO2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO2")	;AADD(aCampos,{"TIPCO2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DESCPO")	;AADD(aCampos,{"DESCPO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTCAD" )	;AADD(aCampos,{"DTCAD"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTDES" )	;AADD(aCampos,{"DTDES"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_RVDES" )	;AADD(aCampos,{"RVDES"    ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTINI" )	;AADD(aCampos,{"DTINI"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DOCOBR")	;AADD(aCampos,{"DOCOBR"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_UNMED1")	;AADD(aCampos,{"UNMED1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_UNMED2")	;AADD(aCampos,{"UNMED2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_ENSAIO")	;AADD(aCampos,{"ENSAIO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_ENSOBR")	;AADD(aCampos,{"ENSOBR"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_UNIMED")	;AADD(aCampos,{"UNIMED"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_NOMINA")	;AADD(aCampos,{"NOMINA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LIE"   )	;AADD(aCampos,{"LIE"      ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LSE"   )	;AADD(aCampos,{"LSE"      ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_PLAMO" )	;AADD(aCampos,{"PLAMO"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_DESPLA")	;AADD(aCampos,{"DESPLA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_NIVEL" )	;AADD(aCampos,{"NIVEL"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LABOR" )	;AADD(aCampos,{"LABOR"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_SEQLAB")	;AADD(aCampos,{"SEQLAB"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_MINMAX")	;AADD(aCampos,{"MINMAX"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_METODO")	;AADD(aCampos,{"METODO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP8_TEXTO" )	;AADD(aCampos,{"TEXTO"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_TAMLOT")	;AADD(aCampos,{"QUANT"    ,"N",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_UM"     )	;AADD(aCampos,{"C2UNIMED" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_EMISSA")	;AADD(aCampos,{"C2EMISSAO","D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_HISTOR")	;AADD(aCampos,{"HISTOR"   ,"C",aTam[1],aTam[2]})
If lExisAlEsp
	aTam:=TamSx3("QP6_ALTESP")	;AADD(aCampos,{"ALTESP"   ,"C",aTam[1],aTam[2]})
EndIf

cArqTRB := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTRB, "TRB", .F., .F. )
dbCreateIndex(cArqTRB,'OP+LOTE+NUMSER', {|| OP+LOTE+NUMSER })

dbSelectArea("QPK")
dbSetOrder(1)
#IFDEF TOP
	If TcSrvType() != "AS/400"  
		lTop := .T.
	Else
		lTop := .F.
	EndIf
#ELSE
	lTop := .F.
#ENDIF	
	
If lTop	
	cQuery := "SELECT "  
	cQuery += " QPK.QPK_OP OP, QPK.QPK_LOTE LOTE, QPK.QPK_NUMSER NUMSER," 
	cQuery += " QPK.QPK_PRODUT PRODUT,QPK.QPK_REVI REVI,SC2.C2_ROTEIRO ROTEIRO," 
	cQuery += " QPK.QPK_TAMLOT QUANT,QPK.QPK_UM C2UNIMED,QPK.QPK_EMISSA C2EMISSAO" 
	cQuery += "FROM " 
	cQuery += "	" + RetSQLName("QPK") + " QPK , "                       
	cQuery += "	" + RetSQLName("SC2") + " SC2 , "                       
	cQuery += "	" + RetSQLName("QP6") + " QP6 "                       
		
	cQuery += "WHERE "
	cQuery += " QPK.QPK_FILIAL = '" + xFilial("QPK") + "'"  
	cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") + "'" 
		 
	cQuery += " AND QPK.QPK_PRODUT = QP6.QP6_PRODUT"  
	cQuery += " AND QPK.QPK_REVI = QP6.QP6_REVI"
	cQuery += " AND Substring(QPK.QPK_OP,1,6)  = SC2.C2_NUM"
   	cQuery += " AND Substring(QPK.QPK_OP,7,2)  = SC2.C2_ITEM"
	cQuery += " AND Substring(QPK.QPK_OP,9,3)  = SC2.C2_SEQUEN"
	cQuery += " AND Substring(QPK.QPK_OP,12,2) = SC2.C2_ITEMGRD"
		
	//cQuery += " AND QPK.QPK_OP >='"	    +mv_par01 + "'"  
	//cQuery += " AND QPK.QPK_LOTE >='"	+mv_par02 + "'"  
	//cQuery += " AND QPK.QPK_NUMSER >='"	+mv_par03 + "'"  
	
	//cQuery += " AND QPK.QPK_OP <='"	    +mv_par04 + "'"  
	//cQuery += " AND QPK.QPK_LOTE <='"	+mv_par05 + "'"  
	//cQuery += " AND QPK.QPK_NUMSER <='"	+mv_par06 + "'"  
	
	cQuery += " AND LEFT(QPK.QPK_OP,6) ='"	    + Alltrim(mv_par01) + "'"  

	cQuery += " AND QPK.D_E_L_E_T_ <> '*' "  
	cQuery += " AND SC2.D_E_L_E_T_ <> '*'"  
	cQuery += " AND QP6.D_E_L_E_T_ <> '*'"  
	cQuery += " ORDER BY " + SqlOrder(QPK->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRBQPK", .F., .T.)
	aTam := TamSx3("QPK_TAMLOT")
	TcSetField( "TRBQPK", "QUANT"	,"N",aTam[1],aTam[2])
	TcSetField( "TRBQPK", "C2EMISSAO"	,"D")
	
	While !Eof()                                                                                                 
	    cKey   := "QP6_PRODUT+QP6_REVI+QP7_CODREC+QP7_OPERAC+QP7_LABOR+QP7_SEQLAB"
		cQuery := "SELECT "  
		cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP7.QP7_CODREC CODREC, "		 
		cQuery += " QP7.QP7_OPERAC OPERAC, QP7.QP7_LABOR LABOR, QP7.QP7_SEQLAB SEQLAB, "	 
		cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, "	 
		cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, "	 
		cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "		 
		cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, "	 
		cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "		 
		cQuery += " QP7.QP7_ENSAIO ENSAIO, QP7.QP7_ENSOBR ENSOBR, QP7.QP7_UNIMED UNIMED, "	 
		cQuery += " QP7.QP7_NOMINA NOMINA, QP7.QP7_LIE LIE, QP7.QP7_NIVEL NIVEL, QP7.QP7_METODO METODO, "  
		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " QQ7.QQ7_CLIENT CLIENT,QQ7.QQ7_LOJA LOJA, SA1.A1_NOME DESCLI, "		 
		//EndIf
		
		cQuery += " QP6.QP6_HISTOR HISTOR,"  
		If lExisAlEsp
			cQuery += " QP6.QP6_ALTESP ALTESP,"  
		EndIf
		
		cQuery += " QP7.QP7_LSE LSE, QP7.QP7_PLAMO PLAMO, QP7.QP7_DESPLA DESPLA, "  
		cQuery += " QP7.QP7_MINMAX MINMAX"  


		cQuery += "FROM "  
		/*
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += "	" + RetSQLName("QQ7") + " QQ7, "   
			cQuery += "	" + RetSQLName("SA1") + " SA1, "   
		EndIf
		*/
		
		cQuery += "	" + RetSQLName("QPK") + " QPK, "  
		cQuery += "	" + RetSQLName("QP6") + " QP6, "  
		cQuery += "	" + RetSQLName("QQK") + " QQK, "  
		cQuery += "	" + RetSQLName("QP7") + " QP7 "  

		cQuery += "WHERE "  
		cQuery += " QPK.QPK_OP>='"			+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE>='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER>='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QPK.QPK_OP<='"		+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE<='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER<='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'"	 
		cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'"	 
		cQuery += " AND QP7.QP7_FILIAL = '" + xFilial("QP7") +"'"	 
		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " AND QQ7.QQ7_FILIAL = '" + xFilial("QQ7") +"'"	 
		//EndIf

		cQuery += " AND QP6.QP6_PRODUT = '" + TRBQPK->PRODUT +"'"	 
		cQuery += " AND QP6.QP6_REVI = '" + TRBQPK->REVI +"'"	 
		cQuery += " AND QQK.QQK_PRODUT ='" + TRBQPK->PRODUT +"'"  
		cQuery += " AND QQK.QQK_CODIGO ='" + TRBQPK->ROTEIRO +"'"  
		//cQuery += " AND QQK.QQK_OPERAC Between '" + mv_par07	+ "' and '" + mv_par08 + "'"  
		cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"		 
		cQuery += " AND QP7.QP7_PRODUT = QP6.QP6_PRODUT "	 
		cQuery += " AND QP7.QP7_REVI = QPK.QPK_REVI " 		 
		cQuery += " AND QP7.QP7_CODREC = QQK.QQK_CODIGO "	 
		cQuery += " AND QP7.QP7_OPERAC = QQK.QQK_OPERAC "	 
		//cQuery += " AND QP7.QP7_LABOR Between '" + mv_par12	+ "' and '" + mv_par13 + "'"  
		/*
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND SA1.A1_COD = '"+ mv_par10 +"'"	 
			cQuery += " AND SA1.A1_LOJA = '" + mv_par11 + "'"	 
			cQuery += " AND QQ7.QQ7_PRODUT = QP7.QP7_PRODUT "	 
			cQuery += " AND QQ7.QQ7_ENSAIO = QP7.QP7_ENSAIO "	 
			cQuery += " AND QQ7.QQ7_LABOR = QP7.QP7_LABOR "		 
			cQuery += " AND QQ7.QQ7_CODREC = QP7.QP7_CODREC "	 
			cQuery += " AND QQ7.QQ7_OPERAC = QP7.QP7_OPERAC " 	 
			cQuery += " AND QQ7.QQ7_CLIENT = '"+ mv_par10 +"'"	 
			cQuery += " AND QQ7.QQ7_LOJA = '" + mv_par11 + "'"	 
		EndIf
		*/
		cQuery += " AND QPK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP6.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QQK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP7.D_E_L_E_T_ <> '*'"  

		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " AND QQ7.D_E_L_E_T_ <> '*'"  
		//EndIf
		cQuery += " ORDER BY " + SqlOrder(cKey)
		cQuery := ChangeQuery(cQuery)
		MemoWrite("C:\Temp\TR1.SQL" , cQuery )
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TR1')
		TcSetField( "TR1", "DTCAD"	,"D")
		TcSetField( "TR1", "DTDES"	,"D")
		TcSetField( "TR1", "DTINI"	,"D")
		QQK->(DbSetOrder(1))
		
		While !Eof()
			/*
			If	mv_par09 == 1	 //Imprime somente a ultima operacao
				If 	QQK->(dbSeek(xFilial("QQK")+TR1->PRODUT+TR1->REVI+If(Empty(TR1->CODREC),;
					"01", TR1->CODREC)))
					dbSelectArea("QQK")
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==TR1->PRODUT+TR1->REVI+If(Empty(TR1->CODREC),;
						"01", TR1->CODREC)
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
					dbSelectArea("TR1")
					If TR1->OPERAC <> QQK->QQK_OPERAC
						DbSkip()
						Loop
					Endif
				Endif
			EndIf
			*/
			
			RecLock("TRB",.T.)
			TRB->OP  		:= TRBQPK->OP  
			TRB->LOTE       := TRBQPK->LOTE 
			TRB->NUMSER     := TRBQPK->NUMSER
			TRB->QUANT		:= TRBQPK->QUANT
			TRB->C2UNIMED	:= TRBQPK->C2UNIMED
			TRB->C2EMISSAO	:= TRBQPK->C2EMISSAO
			TRB->ROTEIRO	:= TR1->CODREC
			TRB->OPERAC		:= TR1->OPERAC
			TRB->CHAVE		:= TR1->CHAVE
			TRB->DESCRI		:= TR1->DESCRI
			TRB->OPERGRP	:= TR1->OPERGRP
			TRB->PRODUT		:= TR1->PRODUT
			TRB->REVI		:= TR1->REVI
			TRB->FATCO1		:= TR1->FATCO1
			TRB->TIPCO1		:= TR1->TIPCO1
			TRB->FATCO2		:= TR1->FATCO2
			TRB->TIPCO2		:= TR1->TIPCO2
			TRB->DESCPO		:= TR1->DESCPO
			TRB->DTCAD		:= TR1->DTCAD
			TRB->DTDES		:= TR1->DTDES
			TRB->RVDES		:= TR1->RVDES
			TRB->DTINI		:= TR1->DTINI
			TRB->DOCOBR		:= TR1->DOCOBR
			TRB->UNMED1		:= TR1->UNMED1
			TRB->UNMED2		:= TR1->UNMED2
			TRB->ENSAIO 	:= TR1->ENSAIO
			TRB->ENSOBR		:= TR1->ENSOBR
			TRB->UNIMED 	:= TR1->UNIMED
			TRB->NOMINA 	:= TR1->NOMINA
			TRB->LIE 		:= TR1->LIE
			TRB->LSE 		:= TR1->LSE
			TRB->PLAMO		:= TR1->PLAMO
			TRB->DESPLA		:= TR1->DESPLA
			TRB->NIVEL 	    := TR1->NIVEL
			TRB->LABOR		:= TR1->LABOR
			TRB->SEQLAB 	:= TR1->SEQLAB
			TRB->MINMAX 	:= TR1->MINMAX
			TRB->METODO 	:= TR1->METODO
			TRB->HISTOR		:= TR1->HISTOR
			If lExisAlEsp
				TRB->ALTESP	:= TR1->ALTESP
			EndIf
			
			MsUnlock()
			dbSelectArea("TR1")
			dbSkip()
		Enddo
		dbSelectArea("TR1")
		dbCloseArea()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Texto 														 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cKey   := "QP6_PRODUT+QP6_REVI+QP8_CODREC+QP8_OPERAC+QP8_LABOR+QP8_SEQLAB"
		cQuery := "SELECT "  
		cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP8.QP8_CODREC CODREC, "	 
		cQuery += " QP8.QP8_OPERAC OPERAC, QP8.QP8_LABOR LABOR, QP8.QP8_SEQLAB SEQLAB, " 
		cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, " 
		cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, " 
		cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "	 
		cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, " 
		cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "	 
		cQuery += " QP8.QP8_ENSAIO ENSAIO, QP8.QP8_ENSOBR ENSOBR, QP8.QP8_TEXTO TEXTO, QP8.QP8_METODO METODO, "	 
		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " QQ7.QQ7_CLIENT CLIENT,QQ7.QQ7_LOJA LOJA, SA1.A1_NOME DESCLI, "	 
		//EndIf
		
		cQuery += " QP6.QP6_HISTOR HISTOR, " 
		If lExisAlEsp
			cQuery += " QP6.QP6_ALTESP ALTESP, " 
		EndIf
		
		cQuery += " QP8.QP8_PLAMO PLAMO, QP8.QP8_DESPLA DESPLA, QP8.QP8_NIVEL NIVEL "  

		cQuery += "FROM "  
		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += "	" + RetSQLName("QQ7") + " QQ7, "  
		//	cQuery += "	" + RetSQLName("SA1") + " SA1, "  
		//EndIf
		cQuery += "	" + RetSQLName("QPK") + " QPK, "  
		cQuery += "	" + RetSQLName("QP6") + " QP6, "  
		cQuery += "	" + RetSQLName("QQK") + " QQK, "  
		cQuery += "	" + RetSQLName("QP8") + " QP8 "  

		cQuery += "WHERE "  
 
		cQuery += " QPK.QPK_OP>='"			+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE>='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER>='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QPK.QPK_OP<='"		+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE<='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER<='"	+TRBQPK->NUMSER + "'"	 
	
		cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'" 
		cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'" 
		cQuery += " AND QP8.QP8_FILIAL = '" + xFilial("QP8") +"'" 
		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " AND QQ7.QQ7_FILIAL = '" + xFilial("QQ7") +"'" 
		//EndIf
		cQuery += " AND QP6.QP6_PRODUT = '"	+ TRBQPK->PRODUT	+"'" 
		cQuery += " AND QP6.QP6_REVI = '" 	+ TRBQPK->REVI		+"'" 
		cQuery += " AND QQK.QQK_PRODUT ='" 	+ TRBQPK->PRODUT	+"'" 
		cQuery += " AND QQK.QQK_CODIGO ='"  + TRBQPK->ROTEIRO   +"'"  
		//cQuery += " AND QQK.QQK_OPERAC Between '" + mv_par07	+ "' and '" + mv_par08 + "'"  
		cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"			 
		cQuery += " AND QP8.QP8_PRODUT = QP6.QP6_PRODUT "		 
		cQuery += " AND QP8.QP8_REVI = QPK.QPK_REVI "			 
		cQuery += " AND QP8.QP8_CODREC = QQK.QQK_CODIGO "		 
		cQuery += " AND QP8.QP8_OPERAC = QQK.QQK_OPERAC "		 
		//cQuery += " AND QP8.QP8_LABOR Between '" + mv_par12	+ "' and '" + mv_par13 + "'"  
		/*
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND SA1.A1_COD = '"+ mv_par10 +"'"	 
			cQuery += " AND SA1.A1_LOJA = '" + mv_par11 + "'" 
			cQuery += " AND QQ7.QQ7_PRODUT = QP8.QP8_PRODUT " 
			cQuery += " AND QQ7.QQ7_ENSAIO = QP8.QP8_ENSAIO " 
			cQuery += " AND QQ7.QQ7_LABOR = QP8.QP8_LABOR "	 
			cQuery += " AND QQ7.QQ7_CODREC = QP8.QP8_CODREC " 
			cQuery += " AND QQ7.QQ7_OPERAC = QP8.QP8_OPERAC "  
			cQuery += " AND QQ7.QQ7_CLIENT = '"+ mv_par10 +"'" 
			cQuery += " AND QQ7.QQ7_LOJA = '" + mv_par11 + "'" 
		EndIf
		*/
		cQuery += " AND QPK.D_E_L_E_T_ <> '*'" 
		cQuery += " AND QP6.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QQK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP8.D_E_L_E_T_ <> '*'" 

		//If !Empty(mv_par10) .And. !Empty(mv_par11)
		//	cQuery += " AND QQ7.D_E_L_E_T_ <> '*'"  
		//EndIf
		cQuery += " ORDER BY " + SqlOrder(cKey)
		cQuery := ChangeQuery(cQuery)
		MemoWrite("C:\Temp\TR2.SQL" , cQuery )
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TR2')
		TcSetField( "TR2", "DTCAD"	,"D")
		TcSetField( "TR2", "DTDES"	,"D")
		TcSetField( "TR2", "DTINI"	,"D")
		
		QQK->(DbSetOrder(1))
		While !Eof()
			/*
			If	mv_par09 == 1	 //Imprime somente a ultima operacao
				If 	QQK->(dbSeek(xFilial("QQK")+TR2->PRODUT+TR2->REVI+If(Empty(TR2->CODREC),;
					"01", TR2->CODREC)))
					dbSelectArea("QQK")
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==TR2->PRODUT+TR2->REVI+If(Empty(TR2->CODREC),;
						"01", TR2->CODREC)
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
					dbSelectArea("TR2")
					If TR2->OPERAC <> QQK->QQK_OPERAC
						DbSkip()
						Loop
					Endif
				Endif
			EndIf
			*/	
			RecLock("TRB",.T.)
			TRB->OP		    := TRBQPK->OP
			TRB->LOTE       := TRBQPK->LOTE 
			TRB->NUMSER     := TRBQPK->NUMSER
			TRB->QUANT		:= TRBQPK->QUANT
			TRB->C2UNIMED	:= TRBQPK->C2UNIMED
			TRB->C2EMISSAO	:= TRBQPK->C2EMISSAO
			TRB->ROTEIRO	:= TR2->CODREC
			TRB->OPERAC		:= TR2->OPERAC
			TRB->CHAVE		:= TR2->CHAVE
			TRB->DESCRI		:= TR2->DESCRI
			TRB->OPERGRP	:= TR2->OPERGRP
			TRB->PRODUT		:= TR2->PRODUT
			TRB->REVI		:= TR2->REVI
			TRB->FATCO1		:= TR2->FATCO1
			TRB->TIPCO1		:= TR2->TIPCO1
			TRB->FATCO2		:= TR2->FATCO2
			TRB->TIPCO2		:= TR2->TIPCO2
			TRB->DESCPO		:= TR2->DESCPO
			TRB->DTCAD		:= TR2->DTCAD
			TRB->DTDES		:= TR2->DTDES
			TRB->RVDES		:= TR2->RVDES
			TRB->DTINI		:= TR2->DTINI
			TRB->DOCOBR		:= TR2->DOCOBR
			TRB->UNMED1		:= TR2->UNMED1
			TRB->UNMED2		:= TR2->UNMED2
			TRB->ENSAIO 	:= TR2->ENSAIO
			TRB->ENSOBR		:= TR2->ENSOBR
			TRB->TEXTO		:= TR2->TEXTO
			TRB->PLAMO		:= TR2->PLAMO
			TRB->DESPLA		:= TR2->DESPLA
			TRB->NIVEL   	:= TR2->NIVEL
			TRB->LABOR		:= TR2->LABOR
			TRB->SEQLAB 	:= TR2->SEQLAB
			TRB->METODO 	:= TR2->METODO
			TRB->HISTOR		:= TR2->HISTOR
			If lExisAlEsp
				TRB->ALTESP	:= TR2->ALTESP
			EndIf

			MsUnlock()
			dbSelectArea("TR2")
			dbSkip()
		Enddo
		dbSelectArea("TR2")
		dbCloseArea()

		dbSelectArea("TRBQPK")
		dbSkip()
	EndDo
	dbSelectArea("TRBQPK")
	dbCloseArea()
/*
Else
	dbSeek(xFilial("QPK")+mv_par01,.T.)
	cCond	:= '!Eof() .And. QPK_FILIAL == "'+xFilial("QPK")+'".And.'+;
				'QPK_OP >= "'+mv_par01+'".And. '+;
				'QPK_LOTE >= "'+mv_par02+'".And. '+;
				'QPK_NUMSER >= "'+mv_par03+'".And. '+;
				'QPK_OP <= "'+mv_par04+'".And. '+;
				'QPK_LOTE <= "'+mv_par05+'".And. '+;
				'QPK_NUMSER <= "'+mv_par06+'"'

	While &cCond
		cRevi		:= Iif(Empty(QPK_REVI),QA_UltRevEsp(QPK_PRODUT,,,,"QIP"),QPK_REVI)
		cRoteiro	:= Posicione("SC2",1,xFilial("SC2")+QPK->QPK_OP,"C2_ROTEIRO")
		cChaveQPK	:= QPK_PRODUT+Inverte(cRevi)
		dbSelectArea("QP6")
		If !dbSeek(xFilial("QP6")+cChaveQPK)
			MsgAlert(STR0028+QPK->QPK_PRODUT+STR0029+cRevi+STR0030,STR0031)		//"O produto :"###"  / Revisao :"###" Nao esta cadastrado. Informe no cadastro de especificacoes."###"Atencao"
			dbSelectArea("QPK")
			dbSetOrder(1)
			dbSkip()
			Loop
		EndIf
		cProdRev := QP6->QP6_PRODUT+QP6->QP6_REVI
		
		dbSelectArea("QQK")
		dbSetOrder(1)
		If dbSeek(xFilial("QQK")+QPK->QPK_PRODUT+QP6->QP6_REVI+cRoteiro)
			While !Eof().And. xFilial("QQK"	) == QQK_FILIAL		.And.;
				QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==QPK->QPK_PRODUT+cRevi+cRoteiro	.And.;
				QQK_OPERAC >= mv_par07 .And. QQK_OPERAC <= mv_par08
				If QQK_REVIPR <> cRevi
					dbSkip()
					Loop
				EndIf
				If	mv_par09 == 1	 //Imprime somente a ultima operacao
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUTO+QQK_REVIPR+QQK_CODIGO==QPK->QPK_PRODUT+cRevi+cRoteiro
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
				EndIf
				
				//Checar se existe ensaios associados.
				dbSelectArea("QP7")
				dbSetOrder(1)
				If dbSeek(xFilial("QP7")+cProdRev+QQK->QQK_CODIGO+QQK->QQK_OPERAC)
					While !Eof() .And. xFilial("QP7")	 == QP7_FILIAL	;
						.And. QP7_PRODUTO+QP7_REVI ==QPK->QPK_PRODUT+QP6->QP6_REVI;	//cProdRev ;
						.And. QP7_CODREC+QP7_OPERAC==QQK->QQK_CODIGO+QQK->QQK_OPERAC
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(mv_par10)
							QQ7->(dbSetOrder(1))
							If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + mv_par10 + mv_par11 + ;
								QP7->QP7_LABOR + QP7->QP7_ENSAIO + QQK->QQK_CODIGO + QQK->QQK_OPERAC))
								dbSelectArea("QP7")
								dbSkip()
								Loop
							EndIf
						EndIf       
						
						//Verifica os Laboratorios selecionados	
						If QP7->QP7_LABOR  < mv_par12 .Or. QP7->QP7_LABOR  > mv_par13
							QP7->(dbSkip())
							Loop
						EndIF
	
						RecLock("TRB",.T.)
						TRB->ROTEIRO	:=	QQK->QQK_CODIGO
						TRB->OPERAC		:=	QQK->QQK_OPERAC
						TRB->CHAVE		:=	QQK->QQK_CHAVE
						TRB->DESCRI		:=	QQK->QQK_DESCRI
						TRB->OPERGRP	:=	QQK->QQK_OPERGRP
						TRB->PRODUT 	:=	QPK->QPK_PRODUT
						TRB->OP	   	    :=	QPK->QPK_OP
						TRB->LOTE	    :=	QPK->QPK_LOTE
						TRB->NUMSER	    :=	QPK->QPK_NUMSER
						TRB->REVI		:=	cRevi

						TRB->FATCO1		:= QP6->QP6_FATCO1 
						TRB->TIPCO1		:= QP6->QP6_TIPCO1
						TRB->FATCO2		:= QP6->QP6_FATCO2
						TRB->TIPCO2		:= QP6->QP6_TIPCO2
						TRB->DESCPO		:= QP6->QP6_DESCPO
						TRB->DTCAD		:= QP6->QP6_DTCAD
						TRB->DTDES		:= QP6->QP6_DTDES
						TRB->RVDES		:= QP6->QP6_RVDES
						TRB->DTINI		:= QP6->QP6_DTINI
						TRB->DOCOBR		:= QP6->QP6_DOCOBR
						TRB->UNMED1		:= QP6->QP6_UNMED1
						TRB->UNMED2		:= QP6->QP6_UNMED2

						TRB->ENSAIO 	:= QP7->QP7_ENSAIO
						TRB->ENSOBR		:= QP7->QP7_ENSOBR
						TRB->UNIMED 	:= QP7->QP7_UNIMED
						TRB->NOMINA 	:= QP7->QP7_NOMINA
						TRB->LIE 		:= QP7->QP7_LIE
						TRB->LSE 		:= QP7->QP7_LSE
						TRB->PLAMO		:= QP7->QP7_PLAMO
						TRB->DESPLA		:= QP7->QP7_DESPLA
						TRB->NIVEL   	:= QP7->QP7_NIVEL
						TRB->LABOR		:= QP7->QP7_LABOR
						TRB->SEQLAB 	:= QP7->QP7_SEQLAB
						TRB->MINMAX 	:= QP7->QP7_MINMAX
						TRB->METODO 	:= QP7->QP7_METODO
						TRB->QUANT		:= QPK->QPK_TAMLOT
						TRB->C2UNIMED	:= QPK->QPK_UM
						TRB->C2EMISSAO	:= QPK->QPK_EMISSA
						TRB->HISTOR		:= QP6->QP6_HISTOR
						If lExisAlEsp
							TRB->ALTESP	:= QP6->QP6_ALTESP
						EndIf
						MsUnlock()
						dbSelectArea("QP7")
						dbSkip()
					Enddo
				EndIf
				
				//Checar os ensaios associados - TXT
				dbSelectArea("QP8")
				dbSetOrder(1)
				If dbSeek(xFilial("QP8")+cProdRev+QQK->QQK_CODIGO+QQK->QQK_OPERAC)
					While !Eof() .And. xFilial("QP8")		  == QP8_FILIAL ;
						.And. QP8_PRODUTO+QP8_REVI  == QPK->QPK_PRODUT+QP6->QP6_REVI;	//cProdRev ;
						.And. QP8_CODREC+QP8_OPERAC == QQK->QQK_CODIGO+QQK->QQK_OPERAC
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(mv_par10)
							QQ7->(dbSetOrder(1))
							If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + mv_par10 + mv_par11 + ;
								QP8->QP8_LABOR + QP8->QP8_ENSAIO + QQK->QQK_CODIGO + QQK->QQK_OPERAC))
								dbSelectArea("QP8")
								dbSkip()
								Loop
							EndIf
						EndIf   
						//Verifica os Laboratorios selecionados	
						If QP8->QP8_LABOR  < mv_par12 .Or. QP8->QP8_LABOR  > mv_par13
							QP8->(dbSkip())
							Loop
						EndIF
						
						RecLock("TRB",.T.)
						TRB->ROTEIRO	:= QQK->QQK_CODIGO
						TRB->OPERAC		:= QQK->QQK_OPERAC
						TRB->CHAVE		:= QQK->QQK_CHAVE
						TRB->DESCRI		:= QQK->QQK_DESCRI
						TRB->OPERGRP	:= QQK->QQK_OPERGR
						TRB->PRODUT		:= QPK->QPK_PRODUT
						TRB->OP	   	    := QPK->QPK_OP
						TRB->LOTE	    := QPK->QPK_LOTE
						TRB->NUMSER	    := QPK->QPK_NUMSER
						TRB->REVI		:= cRevi

						TRB->FATCO1		:= QP6->QP6_FATCO1 
						TRB->TIPCO1		:= QP6->QP6_TIPCO1
						TRB->FATCO2		:= QP6->QP6_FATCO2
						TRB->TIPCO2		:= QP6->QP6_TIPCO2
						TRB->DESCPO		:= QP6->QP6_DESCPO
						TRB->DTCAD		:= QP6->QP6_DTCAD
						TRB->DTDES		:= QP6->QP6_DTDES
						TRB->RVDES		:= QP6->QP6_RVDES
						TRB->DTINI		:= QP6->QP6_DTINI
						TRB->DOCOBR		:= QP6->QP6_DOCOBR
						TRB->UNMED1		:= QP6->QP6_UNMED1
						TRB->UNMED2		:= QP6->QP6_UNMED2
						
						TRB->ENSAIO 	:= QP8->QP8_ENSAIO
						TRB->ENSOBR		:= QP8->QP8_ENSOBR
						TRB->TEXTO		:= QP8->QP8_TEXTO
						TRB->PLAMO		:= QP8->QP8_PLAMO
						TRB->DESPLA		:= QP8->QP8_DESPLA
						TRB->NIVEL   	:= QP8->QP8_NIVEL
						TRB->LABOR		:= QP8->QP8_LABOR
						TRB->SEQLAB 	:= QP8->QP8_SEQLAB
						TRB->METODO 	:= QP8->QP8_METODO
						TRB->QUANT		:= QPK->QPK_TAMLOT
						TRB->C2UNIMED	:= QPK->QPK_UM
						TRB->C2EMISSAO	:= QPK->QPK_EMISSA
						TRB->HISTOR		:= QP6->QP6_HISTOR
						If lExisAlEsp
							TRB->ALTESP	:= QP6->QP6_ALTESP
						EndIf

						
						MsUnlock()
						dbSelectArea("QP8")
						dbSkip()
					Enddo
				EndIf                             
				dbSelectArea("QQK")
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("QPK")
		dbSkip()
	EndDo
*/

EndIF

Return .T.
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QprImpPl	³ Autor ³ Marcelo Pimentel 	  	³ Data ³ 24.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o Aceite/Rejeite/Tam.Amostra do ensaio com Plano Amo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPR040()  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QprImpPl(cEnsaio,cTpCart,cPlamo,cDescPla,cProduto,cRevi,cRoteiro,cOperac,cTamAmo)
Local cPlAmEns	:= ""
Local cIntNor	:= ""
Local cCodAmo	:= ""
Local cAmost	:= ""
Local cNivAm	:= ""
Local nSequen	:= 0
Local aPlInt	:= {}
Local aArea		:= GetArea()
Local cCodNorma := QA_Plano(cPlamo)

cPlAmEns	:= Substr(cDescPla,If(cPlamo<>"B",9,33),2)

If cPlamo == "T"
	cPlAmEns	:= 'T'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Plano de Amostragem definido para o ensaio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QA6->(dbSetOrder(2))
QA6->(dbSeek(xFilial('QA6')+cCodNorma+cPlAmEns+Str(Int(Val(cTamAmo)),8),.T.))
While QA6->(!Eof()) .And. xFilial('QA6')+cCodNorma+cPlAmEns == QA6->QA6_FILIAL+QA6->QA6_PLANO+QA6->QA6_NIVEL
	If QA6->QA6_LOTINF <= Int(Val(cTamAmo)) .And. QA6->QA6_LOTSUP >= Int(Val(cTamAmo))
		cCodAmo := QA6->QA6_CODAMO
		Exit
	EndIf
	QA6->(dbSkip())
EndDo

If cPlamo == "I"	//Definido para Plano de Amostragem - Interno
	cPlAmEns	:= Substr(cDescPla,9,2)
	cIntNor		:= 'I'
	
ElseIf cPlamo == "T"
	cIntNor		:= 'T'
	cPlAmEns	:= 'T'
	Aadd(aPlInt,{0,1,1})
	
ElseIf cPlamo == "N" .Or. cPlamo == "B"
	QQH->(dbSetOrder(1))
	If QQH->(dbSeek(xFilial('QQH')+cProduto+cRevi+cRoteiro+cOperac+cEnsaio))
		cPlAmEns	:= QQH->QQH_NQA
		cIntNor		:= cPlamo
		cAmost		:= QQH->QQH_AMOST
		cNivAm		:= QQH->QQH_NIVAMO
		nSequen		:= If(Subs(QQH->QQH_AMOST,1,1) == 'S' .Or. cPlamo == "B",0,1)
		QA6->(dbSetOrder(2))
		QA6->(dbSeek(xFilial('QA6')+cCodNorma+cNivAm+Str(Int(Val(cTamAmo)),8),.T.))
		While QA6->(!Eof()) .And. xFilial('QA6')+cCodNorma+cNivAm == QA6->QA6_FILIAL+QA6->QA6_PLANO+QA6->QA6_NIVEL
			If QA6->QA6_LOTINF <= Int(Val(cTamAmo)) .And. QA6->QA6_LOTSUP >= Int(Val(cTamAmo))
				cCodAmo := QA6->QA6_CODAMO
				Exit
			EndIf
			QA6->(dbSkip())
		EndDo
	EndIf

ElseIf cPlamo == "Z"
	QQH->(dbSetOrder(1))
	If QQH->(dbSeek(xFilial('QQH')+cProduto+cRevi+cRoteiro+cOperac+cEnsaio))
		cPlAmEns	:= QQH->QQH_NQA
		cIntNor		:= 'Z'
		cNivAm		:= 'QS'

		QA6->(dbSetOrder(2))
		QA6->(dbSeek(xFilial('QA6')+cCodNorma+cNivAm+Str(Int(Val(cTamAmo)),8),.T.))
		While QA6->(!Eof()) .And. xFilial('QA6')+cCodNorma+cNivAm == QA6->QA6_FILIAL+QA6->QA6_PLANO+QA6->QA6_NIVEL
			If QA6->QA6_LOTINF <= Int(Val(cTamAmo)) .And. QA6->QA6_LOTSUP >= Int(Val(cTamAmo))
				cCodAmo := QA6->QA6_CODAMO
				Exit
			EndIf
			QA6->(dbSkip())
		EndDo
	EndIf
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se tiver Pl. Amostragem def. para o ensaio, compara no. medicoes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cPlAmEns)
	If cIntNor == 'I'
		QA7->(dbSetOrder(3))
		If QA7->(dbSeek(xFilial('QA7')+cCodNorma+"ESP"+cPlAmEns+cCodAmo))	//Plano de Amostragem Interno
			While !QA7->(Eof()).And.QA7->QA7_FILIAL==xFilial('QA7') .And. QA7->QA7_PLANO == cCodNorma .And.QA7->QA7_NQA =="ESP"+cPlAmEns .And.  ;
				QA7->QA7_CODAMO == cCodAmo
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Plano de Amostragem Simples Amostragem                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCpo		:= "QA7->QA7_NO_ACE"
				nAceite		:= &cCpo
				cCpo		:= "QA7->QA7_NO_REJ"
				nRejeite	:= &cCpo
				cCpo		:= "QA7->QA7_NO_AMO"
				nTamAmo		:= &cCpo
				cCpo		:= "QA7->QA7_NO_FOR"
				cTamFor		:= &cCpo
				If !Empty(cTamFor) .And. !Empty(cTamAmo)
					cTamFor := AllTrim(StrTran(cTamFor,"#Tam.Lote#",cTamAmo))
					nTamAmo := &(cTamFor)
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratar o tamanho da amostra caso seja valor inferior a 1         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nTamAmo < 1
					nTamAmo := 1
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratar o tamanho da amostra caso seja valor Superior a quantidade³
				//³ da Ordem de Producao                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nTamAmo > Val(cTamAmo)
					nTamAmo := Val(cTamAmo)
				EndIf
				
				Aadd(aPlInt,{nAceite,nRejeite,Int(nTamAmo),cDescPla})
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Plano de Amostragem Dupla Amostragem - para que seja possivel    ³
				//³ utiliza-lo os campos Aceite/Rejeite/Tam.Amostra ou Amostra por   ³
				//³ Formula, devem estar preenchidos.                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCpo		:= "QA7->QA7_SE_ACE"
				nAceite		:= &cCpo
				cCpo		:= "QA7->QA7_SE_REJ"
				nRejeite	:= &cCpo
				cCpo		:= "QA7->QA7_SE_AMO"
				nTamAmo		:= &cCpo
				cCpo		:= "QA7->QA7_SE_FOR"
				cTamFor		:= &cCpo
				If !Empty(cTamFor) .And. !Empty(cTamAmo)
					cTamFor := AllTrim(StrTran(cTamFor,"#Tam.Lote#",cTamAmo))
					nTamAmo := &(cTamFor)
				EndIf
				Aadd(aPlInt,{nAceite,nRejeite,Int(nTamAmo),cDescPla})
				QA7->(dbSkip())
			EndDo
		EndIf
	Else
		If !Empty(cCodAmo)
			QA7->(dbSetOrder(3))
			If QA7->(dbSeek(xFilial('QA7')+cCodNorma+cPlAmEns+cCodAmo+Alltrim(Str(nSequen))))
			
	   	        If cCodNorma == "NB5426"
				  	cTipo := If(Right(cAmost,1) == "A","AT",If(Right(cAmost,1) == "N","NO","SE"))
			    ElseIf cCodNorma == "NB5429"
				  	cTipo := If(AllTrim(cAmost)=="A","AT",If(AllTrim(cAmost)=="N","NO","SE"))
	        	ElseIf cCodNorma == "QS9000"
				  	cTipo := "QS"
		        EndIf
				
				If cPlamo<>'Z'
					cCpo		:= "QA7->QA7_"+cTipo+"_ACE"
					nAceite		:= &cCpo
					cCpo		:= "QA7->QA7_"+cTipo+"_REJ"
					nRejeite	:= &cCpo
					cCpo		:= "QA7->QA7_"+cTipo+"_AMO"
					nTamAmo		:= &cCpo
				Else
					nAceite		:= 0
					nRejeite	:= 1
					cCpo		:= "QA7->QA7_"+cTipo+"_AMO"
					nTamAmo		:= &cCpo
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratar o tamanho da amostra caso seja valor Superior a quantidade³
				//³ da Ordem de Producao                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nTamAmo > Val(cTamAmo)
					nTamAmo := Val(cTamAmo)
				EndIf

				Aadd(aPlInt,{nAceite,nRejeite,Int(nTamAmo),cDescPla})
			EndIf
		EndIf
	EndIf
EndIf           

If Len(aPlInt) == 0
	Aadd(aPlInt,{0,1,1})
EndIf

RestArea(aArea)
Return(aPlInt)
