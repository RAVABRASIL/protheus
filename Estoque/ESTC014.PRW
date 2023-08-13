#include "RwMake.ch"
#include "topconn.ch"

***************
User Function ESTC014()
***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 14/11/03 ³±±
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

	cDESC1   := "Impressao de Etiquetas de Aparas da Producao"
	cDESC2   := ""
	cDESC3   := ""
	aRETURN  := { "Zebrado", 1, "Financeiro", 2, 2, 1, "", 1 }
	cARQUIVO := ""
	aORD     := {}
	cNOMREL  := "ESTC014"
	cTITULO  := "Impressao de Etiquetas de Aparas"
	nLASTKEY := 0
	cTAMANHO := "M"
	M_PAG    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( 'ESTC014', .T. )
   // iif(MV_PAR08 > 30,MV_PAR08 := 30,)
  	cNOMREL := setprint( cARQUIVO, cNOMREL, "ESTC014", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )

 	If nLastKey == 27
	   Return
	Endif

/* 	SC2->( DBSETORDER( 1 ) )
 	SC2->( DBSEEK( XFILIAL( 'SC2' ) + MV_PAR01, .T. ) )
 	cPROD := AllTrim( SC2->C2_PRODUTO )

	SB1->( DBSETORDER( 1 ) )
	SB1->( DBSEEK( XFILIAL( 'SB1' ) + cPROD, .T. ) )
	SB5->( DBSETORDER( 1 ) )
	SB5->( DBSEEK( XFILIAL( 'SB5' ) + cPROD, .T. ) )*/

 //	If DtoS(SC2->C2_DATRF) <> ' '
 //		MsgBox ( "A OP selecionada ja foi encerrada.", "Erro", "STOP" )
 //		Return .F.
 //	EndIf
	

//	If SC2->C2_QUANT <= SC2->C2_CONTETI + ( SC2->C2_QUANT * 0.05 )
// 		MsgBox ( "O nº máximo de impressão de etiquetas já foi atingido!", "Erro", "STOP" )
// 		if !U_senha2("01",2)[1]
// 			Return .F.
// 		endIf
//	EndIf

//	If Alltrim( SB1->B1_CODFARD ) == ' ' .and. Substr( cPROD, 1, 1 ) $ "D*E"
// 		MsgBox ( "Produto da Linha Domestica sem o CODIGO DE BARRA para FARDO. Cadastre o Codigo de Barra.", "Erro", "STOP" )
// 		Return .F.
//	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	cData :=DTOS( dDATABASE )
//	cMes  :=Substr(cData,5,2)
//	cAno  :=Substr(cData,1,4)
	
   	   //	nSpaco := 0
		cLINHA1 := PADR("Ord Producao:" , 20)
		cLINHA2 := PADR("Maquina:    Lado:" , 20)
		cLINHA3 := PADR("Matricula: " , 20)
		cLINHA4 := PADR("Dia Apara:" , 20)
		cLINHA5 := PADR("Turno:( )1( )2( )3", 20)
		cLINHA6 := PADR("Motivo:" , 20)
		cLINHA7 := PADR(" " , 20)      
		
		
	   //	cLINHA7 := PADR("Motivo:" , 20)
		//cLINHA5 := Padr( "FAB: " + DTOC( dDATABASE ) + iif(alltrim(cPROD)!="GUB290","  SAC: 08007271915",""), 50 )
		//cLINHA6 := Padr( "EMB: ???" + " LADO MAQ: " + Alltrim(MV_PAR05) + " TURNO: ???", 50 )
	    //cLINHA7 := Padr( "Lote:" +Substr( alltrim(cPROD), 2, 1 )+'-'+alltrim(cMes)+'/'+alltrim(cAno)+iif(SB1->B1_SETOR!='39' ,'-Val. Indeterminada','') , 50 )
		
		
		@ 000,000 TO 275,335 DIALOG oDLG1 TITLE "Layout da etiqueta"
		@ 010,010 GET cLINHA1 SIZE 150,10 OBJECT oLINHA1
		@ 025,010 GET cLINHA2 SIZE 150,10 OBJECT oLINHA2
		@ 040,010 GET cLINHA3 SIZE 150,10 OBJECT oLINHA3
		@ 055,010 GET cLINHA4 SIZE 150,10 OBJECT oLINHA4
		@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5
        @ 085,010 GET cLINHA6 SIZE 150,10 OBJECT oLINHA6
        @ 085,010 GET cLINHA7 SIZE 150,10 OBJECT oLINHA7
      //  @ 100,010 GET cLINHA7 SIZE 150,10 OBJECT oLINHA7				
		//@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5

		//@ 085,010 GET cLINHA6 SIZE 150,10 OBJECT oLINHA6

		@ 120,050 BMPBUTTON TYPE 1 ACTION OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
		@ 120,090 BMPBUTTON TYPE 2 ACTION Close( oDLG1 )
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

		nHANDLE   := -1
		cPORTAIMP := "3"

		nCONT := 1
		Do While nCONT <= ( MV_PAR01 )
			If Abre_Impress()		//voltar
			   //	IF nSpaco > 0
				    //voltar este bloco oficial
				   
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA1, .T. )
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA2, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA3, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA4, .F. )
				    @ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA5, .F. ) 
				    @ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA6, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "B" + cLINHA7, .F. )				
				
				
					//@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )
				    //@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA7, .F. )
				
			
					/*if SB1->B1_SETOR='39'                           
					   @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "Validade: INDETERMINADA/USO UNICO", 50 ), .F. )
				       @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "MANTER FORA DO ALCANCE DE CRIANCAS. ", 50 ), .F. )
					endif
		
					if cPROD != "GUB290"
						@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					else 
						@ Prow()+1,000 PSAY Inc_Linha( "GUB290", .F. )
					endIf*/					
					
					Fecha_Impress()		//voltar
					
					++nCONT
			   //	Else 
					
			  /*		@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA1, .T. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA2, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA3, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA4, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA5, .F. )
					@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )        */
					//@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA5, .F. )
					//@ Prow()+1,000 PSAY Inc_Linha( "A" + cLINHA6, .F. )
				    
				/*	if SB1->B1_SETOR='39'                           
					   @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "Validade: INDETERMINADA/USO UNICO", 50 ), .F. )
				       @ Prow()+1,000 PSAY Inc_Linha( "A" +Padr( "MANTER FORA DO ALCANCE DE CRIANCAS. ", 50 ), .F. )
					endif      */
					//chamado 001607 josenildo
					
					/*Chamado   29/01/2009*/
					//@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
				  /*	if cPROD != "GUB290"
						@ Prow()+1,000 PSAY Inc_Linha( Iif( Alltrim( SB1->B1_CODFARD ) == "", "RAVA", Alltrim( SB1->B1_CODFARD ) ), .F. )
					else 
						@ Prow()+1,000 PSAY Inc_Linha( "GUB290", .F. )
					endIf    */
					/*Chamado   29/01/2009*/
				  //	Fecha_Impress()		//VOLTAR
				//	++nCONT
			 //	ENDIF
			//voltar
			Else
				Alert("Problemas na funcao Abre_Impress")
				Exit
			EndIf
		EndDo
        /*RecLock("SC2",.F.)
        SC2->C2_CONTETI += MV_PAR08
        SC2->( MSUnlock() ) */
		/*
		If aReturn[ 5 ] == 1
			dbCommitAll()
			ourspool( cNOMREL )
		Else
		
		//voltar
		EndIf
	    */
	
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

		ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )		//voltar

	Return NIL

Return NIL

