#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINFRE     º Autor ³ Esmerino Neto     º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Fretes por Notas Fiscais de entrada           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//±±º MV_PAR01 ³ Pesquisa por Conhecimento (Frete) ou NF ?            º±±
//±±º MV_PAR02 ³ Do conhecimento ?                                    º±±
//±±º MV_PAR03 ³ Ate o conhecimento ?                                 º±±
//±±º MV_PAR04 ³ Da Nota Fiscal ?                                     º±±
//±±º MV_PAR05 ³ Ate a Nota Fiscal ?                                  º±±
//±±º MV_PAR06 ³ Da Emissao ?                                         º±±
//±±º MV_PAR07 ³ Ate a Emissao ?                                      º±±
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

********************
User Function FINFRE()
********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este relatorio ira mostrar todas as NF de entrada  "
Local cDesc2         := "com seus respectivos conhecimentos (fretes).        "
Local cDesc3         := "Relacao de NF de entrada com Frete"
Local cPict          := ""
Local titulo       := "Relacao de NF de Entrada com Frete"
Local nLin         := 80

Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "FINFRE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "FINFRE"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FINFRE" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD1"

SetPrvt("cNfOrig,CSeOrig,aNFs")

dbSelectArea("SD1")
dbSetOrder(1)


pergunte(cPerg,.T.)
Cabec1 := Cabecalho( MV_PAR01 )
If MV_PAR01 == 1
	titulo := "Relacao de Conhecimentos e das NF de Entrada entre " + DtoC( MV_PAR06 ) + " e " + DtoC( MV_PAR07 )
ElseIf MV_PAR01 == 2
	titulo += " entre " + DtoC( MV_PAR06 ) + " e " + DtoC( MV_PAR07 )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

********************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
********************

	Local nOrdem
	aNFs   := {}
	aFrete := {}

	If ! Empty( Alltrim( MV_PAR02 ) ) .OR. ! Empty( Alltrim( MV_PAR04 ) )
		dbSelectArea( cString )
		dbSetOrder(1)
		If MV_PAR01 == 1
			dbSeek(xFilial( cString ) + Alltrim( MV_PAR02 ), .F.)
		Else
			dbSeek(xFilial( cString ) + Alltrim( MV_PAR04 ), .F.)
		EndIf
	Else
		dbSelectArea( cString )
		dbSetOrder(3)
		dbSeek(xFilial( cString ) + DtoS( MV_PAR06 ), .T.)
	EndIf
	While !EOF() .AND. xFilial() == SD1->D1_FILIAL .AND. SD1->D1_DOC <= Iif( MV_PAR01 == 1, MV_PAR03, MV_PAR05 );
				.AND. SD1->D1_EMISSAO <= MV_PAR07

		//If D1_TES $ "/001 /010 /012 /015 /024 /132" //Filtra listagem para exibir so NFs de Materia Prima
			If MV_PAR01 == 1 .AND. SD1->D1_TIPO $ 'C'
				If Len(	aNFs ) == 0
					aAdd( aNFs, { SD1->D1_DOC, SD1->D1_SERIE } )
				ElseIf Empty( nTeste := aScan( aNFs, { |X| X[1] == SD1->D1_DOC } ) )
					aAdd( aNFs, { SD1->D1_DOC, SD1->D1_SERIE } )
				EndIf
			ElseIf  MV_PAR01 == 2 .AND. SD1->D1_TIPO $ 'N'
				If Len(	aNFs ) == 0
					aAdd( aNFs, { SD1->D1_DOC, SD1->D1_SERIE } )
				ElseIf Empty( nTeste := aScan( aNFs, { |X| X[1] == SD1->D1_DOC } ) )
					aAdd( aNFs, { SD1->D1_DOC, SD1->D1_SERIE } )
				EndIf

			EndIf
		//EndIf

		DbSkip()

	EndDo

//dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetRegua( Len(aNFs) )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      //Exit
      Return
   Endif

	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³ Impressao do cabecalho do relatorio. . .                            ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	 If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 	 Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 nLin := 8
	 Endif

	 If MV_PAR01 == 1  //Se pesquisa por Conhecimento
			For x := 1 To Len( aNFs )
				U_InfoFrete( aNFs[ X, 1 ], aNFs[ X, 2 ], MV_PAR01 )
				For w := 1 To 2
					@nLin,00 PSAY aInfoFre[1,1]
					@nLin,07 PSAY aInfoFre[1,2]
					@nLin,13 PSAY aInfoFre[1,3]
					@nLin,19 PSAY " - " + Substring( aInfoFre[1,4], 1, 30 )
					@nLin,55 PSAY Substring( aInfoFre[1,5], 1, 8 )
					@nLin,63 PSAY " - " + Substring( aInfoFre[1,6], 1, 30 )
					@nLin,99 PSAY aInfoFre[1,7] Picture "@E 9,999.99"
					@nLin,109 PSAY aInfoFre[1,8] + " - " + aInfoFre[1,9]
				Next
				nLin := nLin + 1 // Avanca a linha de impressao

   			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   			//³ Impressao do cabecalho do relatorio. . .                            ³
   			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   			If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   				 nLin := 8
   	 		Endif

				If Len( aInfoFre ) > 1
					For y := 2 To Len( aInfoFre )
						//@nLin,00 PSAY aInfoFre[y,1]
						//@nLin,07 PSAY aInfoFre[y,2]
						@nLin,13 PSAY aInfoFre[y,3]
						@nLin,19 PSAY " - " + Substring( aInfoFre[y,4], 1, 30 )
						@nLin,55 PSAY Substring( aInfoFre[y,5], 1, 8 )
						@nLin,63 PSAY " - " + Substring( aInfoFre[y,6], 1, 30 )
						@nLin,99 PSAY aInfoFre[y,7] Picture "@E 9,999.99"
						//@nLin,109 PSAY aInfoFre[y,8] + " - " + aInfoFre[y,9]
						nLin := nLin + 1 // Avanca a linha de impressao

   					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   					//³ Impressao do cabecalho do relatorio. . .                            ³
   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   					If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   					   nLin := 8
   					Endif

					Next
					For z := 1 To Len( aInfoFre )
						@nLin,04 PSAY "NF Original -> Fornecedor: " + aInfoFre[z,10]+ " - " + Substring( aInfoFre[z,11], 1, 30 )
						@nLin,73 PSAY "Prod.: " + Substring( aInfoFre[z,13], 1, 8 )
						@nLin,89 PSAY "Pr.Compra: R$"// + " " + aInfoFre[1,12]
						@nLin,103 PSAY aInfoFre[z,12] Picture "@E 999,999.99"
						nLin := nLin + 1 // Avanca a linha de impressao

   					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   					//³ Impressao do cabecalho do relatorio. . .                            ³
   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   					If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   					   nLin := 8
   					Endif

					Next
					nLin := nLin + 1 // Avanca a linha de impressao

   				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   				//³ Impressao do cabecalho do relatorio. . .                            ³
   				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   				If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   				   nLin := 8
   				Endif

				Else
					@nLin,04 PSAY "NF Original -> Fornecedor: " + aInfoFre[1,10]+ " - " + Substring( aInfoFre[1,11], 1, 30 )
					@nLin,73 PSAY "Prod.: " + Substring( aInfoFre[1,13], 1, 8 )
					@nLin,89 PSAY "Pr.Compra: R$"// + " " + aInfoFre[1,12]
					@nLin,103 PSAY aInfoFre[1,12] Picture "@E 999,999.99"
					nLin := nLin + 2 // Avanca a linha de impressao

   				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   				//³ Impressao do cabecalho do relatorio. . .                            ³
   				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   				If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   				   nLin := 8
   				Endif

				EndIf
		  Next
	 Else
			For x := 1 To Len( aNFs )
				U_InfoFrete( aNFs[ X, 1 ], aNFs[ X, 2 ], MV_PAR01 )
				If ! Empty( aInfoFre )
					For w := 1 To 2
						@nLin,00 PSAY aInfoFre[1,8]
						@nLin,07 PSAY aInfoFre[1,9]
						@nLin,13 PSAY aInfoFre[1,10]
						@nLin,19 PSAY " - " + Substring( aInfoFre[1,11], 1, 30 )
						@nLin,55 PSAY Substring( aInfoFre[1,13], 1, 8 )
						@nLin,63 PSAY " - " + Substring( aInfoFre[1,6], 1, 30 )
						@nLin,98 PSAY aInfoFre[1,12] Picture "@E 99,999.99"
						@nLin,109 PSAY aInfoFre[1,1] + " - " + aInfoFre[1,2]
					Next
					nLin := nLin + 1 // Avanca a linha de impressao

   				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   				//³ Impressao do cabecalho do relatorio. . .                            ³
   				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   				If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   					 nLin := 8
   		 		Endif

					If Len( aInfoFre ) > 1
						For y := 2 To Len( aInfoFre )
							//@nLin,00 PSAY aInfoFre[y,1]
							//@nLin,07 PSAY aInfoFre[y,2]
							@nLin,13 PSAY aInfoFre[y,10]
							@nLin,19 PSAY " - " + Substring( aInfoFre[y,11], 1, 30 )
							@nLin,55 PSAY Substring( aInfoFre[y,13], 1, 8 )
							@nLin,63 PSAY " - " + Substring( aInfoFre[y,6], 1, 30 )
							@nLin,98 PSAY aInfoFre[y,12] Picture "@E 99,999.99"
							//@nLin,109 PSAY aInfoFre[y,8] + " - " + aInfoFre[y,9]
							nLin := nLin + 1 // Avanca a linha de impressao

   						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   						//³ Impressao do cabecalho do relatorio. . .                            ³
   						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   						If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   							 nLin := 8
   						Endif

						Next
						For z := 1 To Len( aInfoFre )
							@nLin,04 PSAY "NF Conhec. --> Transport.: " + aInfoFre[z,03]+ " - " + Substring( aInfoFre[z,04], 1, 30 )
							@nLin,73 PSAY "Prod.: " + Substring( aInfoFre[z,05], 1, 8 )
							@nLin,89 PSAY "Custo Fr.: R$"// + " " + aInfoFre[1,12]
							@nLin,103 PSAY aInfoFre[z,07] Picture "@E 999,999.99"
							nLin := nLin + 1 // Avanca a linha de impressao

   						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   						//³ Impressao do cabecalho do relatorio. . .                            ³
   						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   						If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   							 nLin := 8
   						Endif

						Next
						nLin := nLin + 1 // Avanca a linha de impressao

   					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   					//³ Impressao do cabecalho do relatorio. . .                            ³
   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   					If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   						 nLin := 8
   					Endif

					Else
						@nLin,04 PSAY "NF Conhec. --> Transport.: " + aInfoFre[1,03]+ " - " + Substring( aInfoFre[1,04], 1, 30 )
						@nLin,73 PSAY "Prod.: " + Substring( aInfoFre[1,05], 1, 8 )
						@nLin,89 PSAY "Custo Fr.: R$"// + " " + aInfoFre[1,12]
						@nLin,103 PSAY aInfoFre[1,07] Picture "@E 999,999.99"
						nLin := nLin + 2 // Avanca a linha de impressao

   					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   					//³ Impressao do cabecalho do relatorio. . .                            ³
   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   					If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	 							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   						 nLin := 8
   					Endif
					EndIf
				EndIf
			Next
	 EndIf

	 IncRegua()

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()
Return

********************
Static Function Cabecalho( nOP )
********************
	If nOP == 1
		cCabec1 := "NF Conhec  |             Transportadora              |                  Produto                  | Custo R$ | NF Original"
						  //999999 UNI   999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   9.999,99  999999 - xxx
							//    NF Original -> Fornecedor: 999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   Prod.: xxxxxx   Pr.Compra: R$ 999.999,99
							//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
						  //          1         2         3         4         5         6         7         8         9        10        11        12        13
	ElseIf nOP == 2
		cCabec1 := "Codigo NF  |               Fornecedor                |                  Produto                  | Preco R$ | NF Conhec."
						  //999999 UNI   999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99.999,99  999999 - xxx
							//    NF Conhec. --> Transport.: 999999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   Prod.: xxxxxx   Custo Fr.: R$ 999.999,99
							//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
						  //          1         2         3         4         5         6         7         8         9        10        11        12        13
	EndIf

Return cCabec1
/*
********************
Static Function InfoFrete( cCodigo, cSerie, nOP )
********************

	Local cQuery
	Public aInfoFre := {}

	cQuery := "SELECT 	SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, SF8.F8_NFORIG, SF8.F8_SERORIG, SA2.A2_COD, SA2.A2_NOME, SD1.D1_COD, "
	cQuery += "SB1.B1_DESC, SD1.D1_TOTAL, SF8.F8_TRANSP, SF8.F8_LOJTRAN "
	cQuery += "FROM " + RetSqlName('SF8') + " SF8, " + RetSqlName('SD1') + " SD1, " + RetSqlName('SA2') + " SA2, " + RetSqlName('SB1') + " SB1 "
	cQuery += "WHERE SF8.F8_NFDIFRE = SD1.D1_DOC AND SF8.F8_SEDIFRE = SD1.D1_SERIE "
	cQuery += "AND SF8.F8_FORNECE = SA2.A2_COD AND SF8.F8_LOJA = SF8.F8_LOJA "
	cQuery += "AND SD1.D1_COD = SB1.B1_COD AND SD1.D1_LOCAL = SB1.B1_LOCPAD "
	If nOp == 1
		cQuery += "AND SF8.F8_NFDIFRE = '" + cCodigo + "' AND SF8.F8_SEDIFRE = '" + cSerie + "' "
	ElseIf nOp == 2
		cQuery += "AND SF8.F8_NFORIG  = '" + cCodigo + "' AND SF8.F8_SERORIG = '" + cSerie + "' "
	EndIf
	cQuery += "AND SF8.F8_FILIAL = '" + xFilial( "SF8" ) + "' AND SF8.D_E_L_E_T_ = ' ' "
	cQuery += "AND SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "' AND SD1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SF8X"

	SF8X->( DbGoTop() )
		While ! SF8X->( EoF() )
			cAnAlias := Alias()
			DbSelectArea( "SA2" )
			DbSetOrder( 1 )
			DbSeek( xFilial() + SF8X->F8_TRANSP + SF8X->F8_LOJTRAN, .T. )
			cNTrans := SA2->A2_NOME
			DbSelectArea( "SD1" )
			DbSetOrder( 2 )
			DbSeek( xFilial() + SF8X->D1_COD + SF8X->F8_NFORIG + SF8X->F8_SERORIG, .T. )
			aAdd( aInfoFre,  {SF8X->F8_NFDIFRE,; // 1-NF de Frete
												SF8X->F8_SEDIFRE,; // 2-Serie de Frete
												SF8X->F8_TRANSP, ; // 3-Codigo do Fornecedor do Frete
												cNTrans,				 ; // 4-Nome do Fornecedor do Frete
												SF8X->D1_COD,		 ; // 5-Codigo do Produto
												SF8X->B1_DESC,	 ; // 6-Descricao do Produto
												SF8X->D1_TOTAL,	 ; // 7-Preco do Frete do Produto
												SF8X->F8_NFORIG, ; // 8-Codigo da NF original
												SF8X->F8_SERORIG,; // 9-Serie da NF original
												SF8X->A2_COD,		 ; //10-Codigo do Cliente da NF original
												SF8X->A2_NOME,	 ; //11-Nome do Cliente da NF original
												SD1->D1_TOTAL,   ; //12-Valor do Produto da NF original
												SD1->D1_COD } )		 //13-Codigo do Produto da NF original
			DbSelectArea( cAnAlias )
			SF8X->( DbSkip() )
		EndDo
  SF8X->( DbCloseArea() )
Return aInfoFre
 */
