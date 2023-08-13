#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"

User Function SD1100E()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
///usado no tratamento da Inspeção Qualidade
Local cDocto := SD1->D1_DOC             //número da NF
Local cSeriNF:= SD1->D1_SERIE           //série da NF
Local cFornece := SD1->D1_FORNECE       //código do Fornecedor
Local cLojaFor := SD1->D1_LOJA          //código da Loja 
Local cPC      := SD1->D1_PEDIDO        //número do Pedido de Compra
Local datadigi := SD1->D1_DTDIGIT       //data da Digitação da NF
Local cQuery   := ""
Local LF       := CHR(13) + CHR(10)
Local nD7Recno := 0   //USADO PARA ARMAZENAR O RECNO DO SD7
Local cChave   := "" //chave do QEK
//fim Qualidade

SetPrvt("LFLAG,CALIAS,CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SF1100E                                          ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exclusao de notas fiscais de entrada - RAVA                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

lFlag  := .t.
cAlias := dbSelectArea("SM0")

//If !msgyesno("nota / serie / fornecedor / loja / pedido / datadigi: " + cDocto + " / " + cSeriNF + " / " + cFornece + " / " + cLojaFor + " / " + cPC + " / " + dtoc(datadigi) ) 
//	Return
//Endif

//if SM0->M0_CODIGO == "02" .and. SD1->D1_SERIE == "UNI"
if SM0->M0_CODIGO == "02" .and. SD1->D1_SERIE $ "UNI/0  "

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Exclui cabecalho de nota fiscal na Rava                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XF1" ) == 0
      cArq := "SF1010"
      Use (cArq) ALIAS XF1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 XF1->( DbSetOrder( 1 ) )
   XF1->( dbSeek( xFilial( "SF1" ) + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ) )
   if XF1->( !Eof() )
      RecLock( "XF1", .F. )
      XF1->( dbDelete() )
      XF1->( msUnlock() )
      XF1->( dbcommit() )
   endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Exclui itens de nota fiscal na Rava                          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XD1" ) == 0
      cArq := "SD1010"
      Use (cArq) ALIAS XD1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 XD1->( DbSetOrder( 1 ) )
   XD1->( dbSeek( xFilial( "SF1" ) + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA, .T. ) )
   while XD1->D1_DOC + XD1->D1_SERIE + XD1->D1_FORNECE + XD1->D1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA .and. XD1->( !Eof() )
      RecLock( "XD1", .F. )
      XD1->( dbDelete() )
      XD1->( msUnlock() )
      XD1->( dbSkip() )
   end

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Exclusao Duplicatas na Rava                                  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XE2" ) == 0
      cArq := "SE2010"
      Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   XE2->( dbSetOrder( 6 ) )
   XE2->( dbSeek( xFilial( "SE2" ) + SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC, .T. ) )
   while XE2->E2_FORNECE + XE2->E2_LOJA + XE2->E2_PREFIXO + XE2->E2_NUM == SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_SERIE + SD1->D1_DOC .and. XE2->( !Eof() )
      RecLock( "XE2", .F. )
      XE2->( dbDelete() )
      XE2->( msUnlock() )
      XE2->( dbSkip() )
   end

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Exclui Livros fiscais na Rava                                ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
   if Select( "XF3" ) == 0
      cArq := "SF3010"
      Use ( cArq ) ALIAS XF3 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   XF3->( dbSetOrder( 4 ) )
   XF3->( dbSeek( xFilial( "SF3" ) + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_DOC + SD1->D1_SERIE, .T. ) )
   RecLock( "XF3", .F. )
   XF3->( dbDelete() )
   XF3->( MsUnlock() )
*/
endif


//tratamento da INSPEÇÃO QUALIDADE na exclusão da NF

///LOCALIZA SD7
cQuery := " select SD7.D7_NUMERO, R_E_C_N_O_ AS REGISTRO , * from " + RetSqlName("SD7") + " SD7 " + LF
cQuery += " where D7_DOC = '" + Alltrim(cDocto) + "' " + LF
cQuery += " and D7_SERIE = '" + Alltrim(cSeriNF) + "' " + LF
cQuery += " and D7_FORNECE = '" + Alltrim(cFornece) + "' " + LF
cQuery += " and D7_LOJA = '" + Alltrim(cLojaFor) + "' " + LF
cQuery += " and SD7.D7_FILIAL = '" + xFilial("SD7") + "' " + LF
cQuery += " and SD7.D_E_L_E_T_ = '' " + LF 
cQuery += " Order by SD7.R_E_C_N_O_ " + LF
MemoWrite("C:\Temp\LOCALD7.sql", cQuery)			
If Select("SD7X") > 0
	DbSelectArea("SD7X")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "SD7X"
SD7X->( DBGoTop() )
If !SD7X->( Eof() )
	While !SD7X->( Eof() ) 
		nD7Recno := SD7X->REGISTRO 
		Dbselectarea("SD7") 
		SD7->(DBGOTOP())
		SD7->(DBGOTO(nD7Recno)) //posiciona no registro do SD7	
		Reclock("SD7",.F.)
		SD7->(Dbdelete())
		SD7->(MsUnlock())
		
		DbSelectArea("SD7X")
		SD7X->(DBSKIP())	
	Enddo
Endif
DbselectArea("SD7X")
DBCLOSEAREA()
		    
///LOCALIZA QEP
cQuery := " select * from " + RetSqlName("QEP") + " QEP " + LF
cQuery += " where QEP.QEP_NTFISC = '" + Alltrim(cDocto) + "' " + LF
cQuery += " and QEP.QEP_SERINF = '" + Alltrim(cSeriNF) + "' " + LF
cQuery += " and QEP.QEP_FORNEC = '" + Alltrim(cFornece) + "' " + LF
cQuery += " and QEP.QEP_LOJFOR = '" + Alltrim(cLojaFor) + "' " + LF
cQuery += " and QEP.QEP_PEDIDO = '" + Alltrim(cPC) + "' " + LF
cQuery += " and QEP.QEP_FILIAL = '" + xFilial("QEP") + "' " + LF
cQuery += " and QEP.D_E_L_E_T_ = '' " + LF
cQuery += " Order by QEP.R_E_C_N_O_ " + LF
MemoWrite("C:\Temp\LOCAL_QEP.sql", cQuery)
If Select("QEPX") > 0
	DbSelectArea("QEPX")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "QEPX"
QEPX->( DBGoTop() )
Do While !QEPX->( Eof() )
	DbselectArea("QEP")
	QEP->(Dbsetorder(2)) //QEP_FILIAL+QEP_CODTAB+QEP_FORNECE + QEP_LOJFOR+ QEP_PRODUT + QEP_NTFISC+ QEP_SERINF + QEP_ITEMNF+ QEP_TIPONF
	If QEP->(Dbseek(xFilial("QEP") + QEPX->QEP_CODTAB + QEPX->QEP_FORNECE + QEPX->QEP_LOJFOR + QEPX->QEP_PRODUT + QEPX->QEP_NTFISC + QEPX->QEP_SERINF + QEPX->QEP_ITEMNF + QEPX->QEP_TIPONF )) 
		RecLock("QEP",.F.)
		QEP->(Dbdelete())
		QEP->(MsUnlock())
	//Else
		//msgbox("não achou QEP: " + QEPX->QEP_CODTAB + '/' + QEPX->QEP_FORNECE + '/' + QEPX->QEP_LOJFOR + '/' + QEPX->QEP_PRODUT + '/' + QEPX->QEP_NTFISC + '/' + QEPX->QEP_SERINF + '/' + QEPX->QEP_ITEMNF + '/' + QEPX->QEP_TIPONF )
	Endif
	DbselectArea("QEPX")
	QEPX->(Dbskip())
Enddo
DbselectArea("QEPX")
Dbclosearea()
				
//U_qAtuMatQie(aDados,2,.F.,.F.)    
//LOCALIZA QEK - RESULTADOS
cChave := ""
DbselectArea("QEK")
QEK->(Dbsetorder(15)) //QEK_FILIAL + QEK_NTFISC + QEK_SERINF + QEK_FORNEC+QEK_LOJFOR + QEK_DTENTR                                                                         
QEK->(DBGOTOP())
If QEK->(Dbseek(xFilial("QEK") + cDocto + cSeriNF + cFornece + cLojaFor + DtoS(datadigi)  ))
	While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. Alltrim(QEK->QEK_NTFISC) == Alltrim(cDocto) .and. Alltrim(QEK->QEK_SERINF) == Alltrim(cSeriNF)
		cChave := QEK->QEK_CHAVE
		If Alltrim(QEK->QEK_NTFISC) == Alltrim(cDocto) .and. Alltrim(QEK->QEK_SERINF) == Alltrim(cSeriNF) .and. Alltrim(QEK->QEK_CHAVE) == Alltrim(cChave)
			RecLock("QEK",.F.)
			QEK->(Dbdelete())
			QEK->(MsUnlock())
		Endif
		
		///LOCALIZA QF5
		cQuery := " select * from " + RetSqlName("QF5") + " QF5 " + LF
		cQuery += " where " + LF
		cQuery += " QF5.QF5_CHAVE >= '" + Alltrim(cChave) + "' " + LF
		cQuery += " and QF5.QF5_FORNEC = '" + Alltrim(cFornece) + "' " + LF
		cQuery += " and QF5.QF5_LOJFOR = '" + Alltrim(cLojaFor) + "' " + LF
		cQuery += " and QF5.QF5_FILIAL = '" + xFilial("QF5") + "' " + LF
		cQuery += " and QF5.D_E_L_E_T_ = '' " + LF
		cQuery += " Order by QF5.R_E_C_N_O_ " + LF
		MemoWrite("C:\Temp\LOCAL_QF5.sql", cQuery)
		If Select("QF5X") > 0
			DbSelectArea("QF5X")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "QF5X"
		QF5X->( DBGoTop() )
		If !QF5X->( Eof() )					
			DbselectArea("QF5")
			QF5->(Dbsetorder(1)) //QF5_FILIAL + QF5_CHAVE
			If QF5->(Dbseek(xFilial("QF5") + QF5X->QF5_CHAVE  ))
				While !QF5->(EOF()) .And. QF5->QF5_FILIAL == xFilial("QF5") .And. Alltrim(QF5->QF5_CHAVE) == Alltrim(QF5X->QF5_CHAVE)
					RecLock("QF5",.F.)
					QF5->(Dbdelete())
					QF5->(MsUnlock())
					QF5->(DBSKIP())
				Enddo
			//Else
				//msgbox("não achou QF5 chave: " + cChave)
			Endif
			DbSelectArea("QF5X")
		
		Endif
		DbSelectArea("QF5X")
		DbCloseArea() 
	    
		DbSelectArea("QEK")
		QEK->(DBSKIP())
	Enddo    
		
Endif  //se existe QEK

//fim tratamento Qualidade

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)
Return(lFlag)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
