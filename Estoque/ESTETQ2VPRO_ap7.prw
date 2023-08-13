#include "RwMake.ch"
#include "topconn.ch"

***************
User Function ESTETQ2V()
***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 14/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Impressao de Etiquetas da Producao na Impressora TOLEDO    ³±±
±±³						para Fardos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Estoque / Custos                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SETPRVT("???,???")
	SETPRVT("CPROD,NCONT,NLIN,nHANDLE,cPORTAIMP")
	cALIASANT := alias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Parametros Ambientais                                 ³
//³ MV_PAR01 = Numero da Ordem de Producao                       ³
//³ MV_PAR02 = Quantidade de Etiquetas                           ³
//³ MV_PAR03 = Numero do Operador                                ³
//³ MV_PAR04 = Numero da Maquina                                 ³
//³ MV_PAR05 = Lado da Maquina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cDESC1   := "Impressao de Etiquetas dos Fardos para Controle de"
	cDESC2   := "Producao."
	cDESC3   := ""
	aRETURN  := { "Zebrado", 1, "Financeiro", 2, 2, 1, "", 1 }
	cARQUIVO := "SC2"
	aORD     := {}
	cNOMREL  := "ESTETQ2V"
	cTITULO  := "Impressao de Etiquetas"
	nLASTKEY := 0
	cTAMANHO := "M"
	M_PAG    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( 'ESTET2', .T. )
    iif(MV_PAR02 > 30,MV_PAR02 := 30,)
	cNOMREL := setprint( cARQUIVO, cNOMREL, "ESTET2", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )

	If nLastKey == 27
	   Return
	Endif

 	SC2->( DBSETORDER( 1 ) )
 	SC2->( DBSEEK( XFILIAL( 'SC2' ) + MV_PAR01, .T. ) )
 	cPROD := AllTrim( SC2->C2_PRODUTO )

	SB1->( DBSETORDER( 1 ) )
	SB1->( DBSEEK( XFILIAL( 'SB1' ) + cPROD, .T. ) )
	SB5->( DBSETORDER( 1 ) )
	SB5->( DBSEEK( XFILIAL( 'SB5' ) + cPROD, .T. ) )

	If DtoS(SC2->C2_DATRF) <> ' '
 		MsgBox ( "A OP selecionada ja foi encerrada.", "Erro", "STOP" )
 		Return .F.
	EndIf
	

	If SC2->C2_QUANT <= SC2->C2_CONTETI + ( SC2->C2_QUANT * 0.05 )
 		MsgBox ( "O nº máximo de impressão de etiquetas já foi atingido!", "Erro", "STOP" )
 		if !U_senha2("03",2)[1]
 			Return .F.
 		endIf
	EndIf

	If Alltrim( SB1->B1_CODFARD ) == ' ' .and. Substr( cPROD, 1, 1 ) $ "D*E"
 		MsgBox ( "Produto da Linha Domestica sem o CODIGO DE BARRA para FARDO. Cadastre o Codigo de Barra.", "Erro", "STOP" )
 		Return .F.
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cData :=DTOS( dDATABASE )
	cMes  :=Substr(cData,5,2)
	cAno  :=Substr(cData,1,4)
	
	nSpaco := 0
	cLINHA1 := Padr( "   PRODUTO: " + SubStr( AllTrim( cPROD ), 1, 7 ), 20)
	cDesc := Len( Alltrim( SB1->B1_DESC ) )
	IF cDesc > 39
		FOR X := 1 TO cDesc
			IF SubStr( Alltrim( SB1->B1_DESC ), X, 1 ) == " " .AND. ( X >= 25 .AND. X <= 39 )
				nSpaco :=  X
			ENDIF
		NEXT
		cLINHA2 := Padr( SB1->B1_DESC, nSpaco )
		cLINHA3 := Substr( SB1->B1_DESC, nSpaco + 1, cDesc )
		cLINHA4 := Padr( "Contem: " + Iif( Alltrim( SB1->B1_UM ) $ "FD", Trans( SB5->B5_QTDEMB, "999" ) + " X ", " " ) + Trans( StrZero( (SB5->B5_QTDFIM / SB5->B5_QE2), 3 ), "999") + " " + Alltrim( SB1->B1_UM ) + ;
			"  MAQ: " + MV_PAR04 + " OP: " + Alltrim(MV_PAR01), 50 )
		cLINHA5 := Padr( "FAB: " + DTOC( dDATABASE ) + iif(alltrim(cPROD)!="GUB290","  SAC: 08007271915",""), 50 )
		
		//cLINHA6 := Padr( "OPE: " + Alltrim( MV_PAR03 ) + "   EMB: ???" + " LADO MAQ: " + Alltrim(MV_PAR05), 50 )
		//Chamado 002285 - Marcio Andrade - Alterado por Flávia Rocha - 13/06/12
		// 1 - INIBIR CAMPO "OPERADOR" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. OK - fardinho: ESTETQ3V
		// 2 - ALTERAR CAMPOR "DATA" POR "MES/ANO" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. - OK - FARDINHO: ESTETQ3V
		// 3 - INCLUIR "TURNO" NA ETIQUETA FARDÃO EM TODOS OS PRODUTOS. - ok ESTETQ2V - FARDÃO
		// 4 - NA GERAÇÃO DO CODIGO DE PESAGEM DO FARDO, IMPRIMIR ETIQUETAS COM INFORMAÇÕES DOS DADOS DO CHECK
		//cLINHA6 := Padr( "EMB: ???" + " LADO MAQ: " + Alltrim(MV_PAR05), 50 )
		
		// 3 - INCLUIR "TURNO" NA ETIQUETA FARDÃO EM TODOS OS PRODUTOS.
		cLINHA6 := Padr( "EMB: ???" + " LADO MAQ: " + Alltrim(MV_PAR05) + " TURNO: ???", 50 )
	    cLINHA7 := Padr( "Lote:" +Substr( alltrim(cPROD), 2, 1 )+'-'+alltrim(cMes)+'/'+alltrim(cAno)+iif(SB1->B1_SETOR!='39' ,'-Val. Indeterminada','') , 50 )
		
		
		@ 000,000 TO 275,335 DIALOG oDLG1 TITLE "Layout da etiqueta"
		@ 010,010 GET cLINHA1 SIZE 150,10 OBJECT oLINHA1
		@ 025,010 GET cLINHA2 SIZE 150,10 OBJECT oLINHA2
		@ 040,010 GET cLINHA3 SIZE 150,10 OBJECT oLINHA3
		@ 055,010 GET cLINHA4 SIZE 150,10 OBJECT oLINHA4
		@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5

		@ 085,010 GET cLINHA6 SIZE 150,10 OBJECT oLINHA6

		@ 120,050 BMPBUTTON TYPE 1 ACTION OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
		@ 120,090 BMPBUTTON TYPE 2 ACTION Close( oDLG1 )
		ACTIVATE DIALOG oDlg1 CENTER

	Else
		cLINHA2 := Padr( SB1->B1_DESC, 50 )
		cLINHA3 := Padr( "Contem: " + Iif( Alltrim( SB1->B1_UM ) $ "FD", Trans( SB5->B5_QTDEMB, "999" ) + " X ", " " ) + Trans( StrZero( (SB5->B5_QTDFIM / SB5->B5_QE2), 3 ), "999") + " " + Alltrim( SB1->B1_UM ) + ;
			"  MAQ: " + MV_PAR04 + " OP: " + Alltrim(MV_PAR01), 50 )
		cLINHA4 := Padr( "FAB: " + DTOC( dDATABASE ) + iif(alltrim(cPROD)!="GUB290","  SAC: 08007271915",""), 50 )
		cLINHA5 := Padr( "OPE: " + Alltrim( MV_PAR03 ) + "   EMB: ???"  + " LADO MAQ: " + Alltrim(MV_PAR05), 50 )
		///FR - 26/05/2011 - solicitado por Ivonei, inclusão do campo LADO MÁQUINA
		//Chamado 002285 - Marcio Andrade - Alterado por Flávia Rocha - 13/06/12
		// 1 - INIBIR CAMPO "OPERADOR" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
		// 2 - ALTERAR CAMPOR "DATA" POR "MES/ANO" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
		// 3 - INCLUIR "TURNO" NA ETIQUETA FARDÃO EM TODOS OS PRODUTOS.
		// 4 - NA GERAÇÃO DO CODIGO DE PESAGEM DO FARDO, IMPRIMIR ETIQUETAS COM INFOR MAÇÕES DOS DADOS DO CHECK
		
		cLINHA6 := Padr( "Lote:" +Substr( alltrim(cPROD), 2, 1 )+'-'+alltrim(cMes)+'/'+alltrim(cAno)+iif(SB1->B1_SETOR!='39' ,'-Val. Indeterminada','') , 50 )
		
		@ 000,000 TO 275,335 DIALOG oDLG1 TITLE "Layout da etiqueta"
		@ 010,010 GET cLINHA1 SIZE 150,10 OBJECT oLINHA1
		@ 025,010 GET cLINHA2 SIZE 150,10 OBJECT oLINHA2
		@ 040,010 GET cLINHA3 SIZE 150,10 OBJECT oLINHA3
		@ 055,010 GET cLINHA4 SIZE 150,10 OBJECT oLINHA4
		@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5
		@ 120,050 BMPBUTTON TYPE 1 ACTION OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
		@ 120,090 BMPBUTTON TYPE 2 ACTION Close( oDLG1 )
		ACTIVATE DIALOG oDlg1 CENTER

	ENDIF

	Return NIL


	***************
	Static Function OkProc()
	***************

		Close( oDLG1 )
		Processa( {|| Etiqueta() } )   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Processa( {|| Execute(Cap_CCP) } )
		Return NIL


	***************
	Static Function Etiqueta()
	***************

		setdefault( aRETURN, cARQUIVO )
		If nLastKey == 27
		   Return
		Endif

		nMIDIA := aRETURN[ 5 ]

		#IFDEF WINDOWS
		   RptStatus({|| RptDetail()})
		   Return
		   Static Function RptDetail()
		#ENDIF

		nHANDLE   := -1
		cPORTAIMP := "3"

		nCONT := 1
		Do While nCONT <= ( MV_PAR02 )
			If Abre_Impress()		//voltar
				IF nSpaco > 0
				    //voltar este bloco oficial
				   
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA1, .T. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA2, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA3, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA4, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA5, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )
				    @ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA7, .F. )
				
				/*
				//bloco teste
					@ Prow()+1,000 PSAY cLINHA1
					@ Prow()+1,000 PSAY cLINHA2
					@ Prow()+1,000 PSAY cLINHA3
					@ Prow()+1,000 PSAY cLINHA4
					@ Prow()+1,000 PSAY cLINHA5
					@ Prow()+1,000 PSAY cLINHA6
				*/
				
					// chamado 001607 josenildo
					if SB1->B1_SETOR='39'                           
					   @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "Validade: INDETERMINADA/USO UNICO", 50 ), .F. )
				       @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "MANTER FORA DO ALCANCE DE CRIANCAS. ", 50 ), .F. )
					endif
					//chamado 001607 josenildo
					
					/*Chamado   29/01/2009*/					
					//@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					if cPROD != "GUB290"
						@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					else 
						@ Prow()+1,000 PSAY Inc_Linha( "GUB290", .F. )
					endIf
					/*Chamado   29/01/2009*/					
					
					Fecha_Impress()		//voltar
					
					++nCONT
				Else 
					//voltar
					
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA1, .T. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA2, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA3, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA4, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA5, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )
				    
					/*
					@ Prow()+1,000 PSAY cLINHA1
					@ Prow()+1,000 PSAY cLINHA2
					@ Prow()+1,000 PSAY cLINHA3
					@ Prow()+1,000 PSAY cLINHA4
					@ Prow()+1,000 PSAY cLINHA5
					*/
					
					// chamado 001607 josenildo
					if SB1->B1_SETOR='39'                           
					   @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "Validade: INDETERMINADA/USO UNICO", 50 ), .F. )
				       @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "MANTER FORA DO ALCANCE DE CRIANCAS. ", 50 ), .F. )
					endif
					//chamado 001607 josenildo
					
					/*Chamado   29/01/2009*/
					//@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					if cPROD != "GUB290"
						@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					else 
						@ Prow()+1,000 PSAY Inc_Linha( "GUB290", .F. )
					endIf
					/*Chamado   29/01/2009*/
					Fecha_Impress()		//VOLTAR
					++nCONT
				ENDIF
			//voltar
			Else
				Alert("Problemas na funcao Abre_Impress")
				Exit
			EndIf
		EndDo
        RecLock("SC2",.F.)
        SC2->C2_CONTETI += MV_PAR02
        SC2->( MSUnlock() )
		If aReturn[ 5 ] == 1
			dbCommitAll()
			ourspool( cNOMREL )
		Else
			Alert("Problemas na funcao Abre_Impress")		//voltar
		EndIf
	Return Nil

	***************
	Static Function Abre_Impress()
	***************

		cDLL    := "impressora451.dll"
		nHandle := ExecInDllOpen( cDLL )
		if nHandle = -1
			 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
			 Return .F.
		EndIf
		ExecInDLLRun( nHandle, 1, cPORTAIMP )

	Return .T.


	***************
	Static Function Fecha_Impress()
	***************

		ExecInDLLRun( nHandle, 3, "" )
		ExecInDLLClose( nHandle )

	Return NIL


	***************
	Static Function Inc_Linha( cIMP, lPRIMLINHA )
	***************

		// Parametro 1 = Linha a ser impressa
		// Parametro 2 = Limpa buffer
		ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )		//voltar

	Return NIL

Return NIL
