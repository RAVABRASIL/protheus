#include "RwMake.ch"
#include "topconn.ch"

***************
User Function ESTETQ3V()
***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 14/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Impressao de Etiquetas do Pacote Domestico na             ³±±
±±³ Impressora TOLEDO                                                    ³±±
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cDESC1   := "Impressao de Etiquetas dos Fardos para Controle de"
	cDESC2   := "Producao."
	cDESC3   := ""
	aRETURN  := { "Zebrado", 1, "Financeiro", 2, 2, 1, "", 1 }
	cARQUIVO := "SC2"
	aORD     := {}
	cNOMREL  := "ESTETQ3V"
	cTITULO  := "Impressao de Etiquetas"
	nLASTKEY := 0
	cTAMANHO := "M"
	M_PAG    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( 'ESTET2', .T. )

	cNOMREL := setprint( cARQUIVO, cNOMREL, "ESTETQ3V", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )

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
    
    //Comentei em 05/08/2010 - Eurivan - Impressao de codigo de barras para todos os produtos.
/*
	If ! Substr( cPROD, 1, 1 ) $ "D E A"
 		MsgBox ( "A OP selecionada nao e de um produto da Linha Domestica ou Institucional.", "Erro", "STOP" )
 		Return .F.
	EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cData :=DTOS( dDATABASE )
	cMes  :=Substr(cData,5,2)
	cAno  :=Substr(cData,1,4)
	
	cLINHA1 := iif( alltrim(cPROD)!="GUB290", Padr( "RAVA EMBALAGENS Ind. e Com.", 50 ), "GUB290")//chamado 29/01/09
	cLINHA2 := Padr( "-MANTER FORA DO ALCANCE DE CRIANCAS", 50 )
    if Substr( cPROD, 1, 1 ) == "C"
	   cLINHA3 := Padr( "-USO EXCLUSIVO PARA LIXO HOSPITALAR", 50 )
	else
	   cLINHA3 := Padr( "-USO EXCLUSIVO PARA LIXO NORMAL", 50 )
   	endif   
	cLINHA4 := Padr( "-NAO ADEQUADO PARA OBJETOS PERFURANTES", 50 )
	//cLINHA5 := Padr( "PROD:" + Alltrim(cPROD) + " OPE:" + MV_PAR03 + " EMB:???" , 50 )
	cLINHA5 := Padr( "PROD:" + Alltrim(cPROD)+"-Lote:" +Substr( alltrim(cPROD), 2, 1 )+'-'+alltrim(cMes)+'/'+alltrim(cAno)+'-Val. Indeter.' , 50 )
	cLINHA6 := Padr(  SB1->B1_DESC, 50 )
	//cLINHA7 := Padr( "QTD:" + AllTrim( Trans( SB5->B5_QTDEMB, "9999") ) + " MAQ:" + MV_PAR04 + " OP:" + Alltrim(MV_PAR01) + " FAB:" + DTOC( dDATABASE ), 50 )
	///FR - 26/05/2011 - solicitado por Ivonei, inclusão do campo LADO MÁQUINA
	
	//cLINHA7 := Padr( "QTD:" + AllTrim( Trans( SB5->B5_QTDEMB, "9999") ) + " MAQ:" + MV_PAR04 + " OP:" + Alltrim(MV_PAR01) + " LADO MAQ:" + Alltrim(MV_PAR05), 50 )
	//Chamado 002285 - Marcio Andrade - Alterado por Flávia Rocha - 13/06/12
	// 1 - INIBIR CAMPO "OPERADOR" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
	// 2 - ALTERAR CAMPOR "DATA" POR "MES/ANO" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
	// 3 - INCLUIR "TURNO" NA ETIQUETA FARDÃO EM TODOS OS PRODUTOS - ESTETQ2V 
	// 4 - NA GERAÇÃO DO CODIGO DE PESAGEM DO FARDO, IMPRIMIR ETIQUETAS COM INFOR MAÇÕES DOS DADOS DO CHECK
	cLINHA7 := Padr( "OP:" + Alltrim(MV_PAR01) + " Contem:" + AllTrim( Trans( SB5->B5_QTDEMB, "9999") )+' '+'Un.' + " MAQ:" + MV_PAR04 + " LD:" + Alltrim(MV_PAR05), 50 )
	
	If  Substr( alltrim(cPROD), 1, 1 ) $ "C" // HOSPITALAR
	   //cLINHA8 := Padr("Reg. M.S.:"+SB1->B1_REGMS+" LT:" + substr(DTOC( dDATABASE ),4,8 ) + " FAB:" +alltrim(cMes)+'/'+alltrim(cAno) , 50 )
	   // 2 - ALTERAR CAMPOR "DATA" POR "MES/ANO" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
	   cLINHA8 := Padr("Reg. M.S.:"+SB1->B1_REGMS + " FAB:" +alltrim(cMes)+'/'+alltrim(cAno) , 50 )
	ELSE
		// 2 - ALTERAR CAMPOR "DATA" POR "MES/ANO" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
	   cLINHA8 := Padr("FAB:" + alltrim(cMes)+'/'+alltrim(cAno), 50 )
	ENDIF


	
	//cLINHA6 := Padr( "FAB: " + DTOC( dDATABASE ) + " SAC: 08007271915 OPERADOR: " + Alltrim( MV_PAR03 ) + " EMBALADOR: ???", 50 )
	// 1 - INIBIR CAMPO "OPERADOR" NA ETIQUETA DE FARDINHO EM TODOS OS PRODUTOS. ok
	//cLINHA8 := Padr( "OPE:" + MV_PAR03 + " EMB:???", 50 )   //inibir o operador
	//cLINHA7 := Padr( "OPERADOR: " + Alltrim( MV_PAR03 ) + "   EMBALADOR: ???", 50 )

	@ 000,000 TO 275,335 DIALOG oDLG1 TITLE "Layout da etiqueta"
	@ 010,010 GET cLINHA1 SIZE 150,10 OBJECT oLINHA1
	@ 025,010 GET cLINHA2 SIZE 150,10 OBJECT oLINHA2
	@ 040,010 GET cLINHA3 SIZE 150,10 OBJECT oLINHA3
	@ 055,010 GET cLINHA4 SIZE 150,10 OBJECT oLINHA4
	@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5
	@ 085,010 GET cLINHA6 SIZE 150,10 OBJECT oLINHA6
	@ 100,010 GET cLINHA7 SIZE 150,10 OBJECT oLINHA7
	//@ 110,010 GET cLINHA8 SIZE 150,10 OBJECT oLINHA8  //deixar somente para testes
	@ 122,050 BMPBUTTON TYPE 1 ACTION OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
	@ 122,090 BMPBUTTON TYPE 2 ACTION Close( oDLG1 )
	ACTIVATE DIALOG oDlg1 CENTER
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

		//nTOLERA := Getmv( "MV_PESOTOL" )
		nHANDLE   := -1
		//cPORTAIMP := "4"
		cPORTAIMP := "3"
		//aIMP      := {}
		//cOP       := Space( 11 )

		//Alert("Inicio da funcao")
		If Abre_Impress()		//voltar
			nCONT := 1
		  
			Do While nCONT <= ( MV_PAR02 )
				
				If Abre_Impress()		//voltar
				    //voltar este bloco  //comentar qdo estiver testando sem impressora específica - FR
				    /////////////
				    
				 	@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA1, .T. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA2, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA3, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA4, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA5, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA7, .F. )
				
					
					IF !EMPTY(cLINHA8)
					   @ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA8, .F. )
					ENDIF
					
					
					@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODPACO ) == "", "RAVA", Alltrim( SB1->B1_CODPACO ) ), .F. )
					
					Fecha_Impress()
					
					///////////// fim do bloco
					
					
					//COMENTAR QDO OFICIAL		
					//bloco teste 
					/*
				 	@ Prow()+1,000 PSAY cLINHA1
					@ Prow()+1,000 PSAY cLINHA2
					@ Prow()+1,000 PSAY cLINHA3
					@ Prow()+1,000 PSAY cLINHA4
					@ Prow()+1,000 PSAY cLINHA5
					@ Prow()+1,000 PSAY cLINHA6
					@ Prow()+1,000 PSAY cLINHA7
					
					IF !EMPTY(cLINHA8)
					   @ Prow()+1,000 PSAY cLINHA8
					ENDIF
					
					@ Prow()+1,000 PSAY Iif( Alltrim( SB1->B1_CODPACO ) == "", "RAVA", Alltrim( SB1->B1_CODPACO ) )
					*/
					//fim bloco teste
					
					
					++nCONT
				
				Else     //voltar
					Alert("Problemas na funcao Abre_Impress")		//voltar
					Exit	//voltar
				EndIf  	//voltar
			EndDo
		
			If aReturn[ 5 ] == 1
				dbCommitAll()
				ourspool( cNOMREL )
			Endif

		Else  //voltar
			Alert("Problemas na funcao Abre_Impress")  //voltar
		EndIf                                        //voltar
	Return Nil

	***************
	Static Function Abre_Impress()
	***************

		//Alert("Acessou a funcao Abre_Impress :)")
		cDLL    := "impressora451.dll"
		nHandle := ExecInDllOpen( cDLL )
		if nHandle = -1
			 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
			 Return .F.
		EndIf
		// Parametro 1 = Porta serial da impressora
		ExecInDLLRun( nHandle, 1, cPORTAIMP )

	Return .T.


	***************
	Static Function Fecha_Impress()
	***************

		//Alert("Acessou a funcao Fecha_Impress :)")
		ExecInDLLRun( nHandle, 3, "" )
		ExecInDLLClose( nHandle )

	Return NIL


	***************
	Static Function Inc_Linha( cIMP, lPRIMLINHA )
	***************

		//Alert("Acessou a funcao Inc_Linha :)")
		// Parametro 1 = Linha a ser impressa
		// Parametro 2 = Limpa buffer
		ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )

	Return NIL


Return NIL
