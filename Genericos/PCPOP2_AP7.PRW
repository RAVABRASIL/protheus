#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function PCPOP()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Declaracao de variaveis utilizadas no pro§grama atraves da funcao   ³
³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
³ identificando as variaveis publicas do sistema utilizadas no codigo ³
³ Incluido pelo assistente de conversao do AP5 IDE                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NREG,NPVAROP")
SetPrvt("CCODETIQ,CPRODUTO,NOP,AMAT,NQUANT,CMAT")
SetPrvt("NCONT,NDENSIDA,LFLAG,CNUMPI,DEMISPI,CMAQPI")
SetPrvt("NQTDPI,CPRODPI,CCEMEPI,NBOBLGPI,NLFILPI,NESPPI")
SetPrvt("CSANLAMPI,CTRATAMPI,CSLITEXPI,NPTNEVEPI,CMATRIZPI,NLIN")
SetPrvt("NNUMETQ,I,CGILETE,NCTRL, cImpressao,")

cALIASANT := Alias()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de parametrizacao da impressao.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "INDUSTRIAL", 2, 2, 1, "", 1 }
cARQUIVO := "SC2"
aORD     := { "Por OP" }
cNOMREL  := "OP2"
cTITULO  := "Ordem de Producao"
nLASTKEY := 0

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do processamento                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Pergunte("PCPOP1",.F.)
cNOMREL := Setprint( cARQUIVO, cNOMREL, "PCPOP1", @cTITULO, cDESC1, cDESC2, cDESC3, .F., aORD )
If nLastKey == 27
   Return
Endif

Setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do Processamento do Relatorio                         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )
dbselectarea( 'SB5' )
SB5->( dbsetorder( 1 ) )
dbselectarea( 'SC2' )
SC2->( dbsetorder( 1 ) )
DbSeek( xFILIAL("SC2" ) + MV_PAR01, .T. )
dbselectarea( 'Z03' )
Z03->( dbsetorder( 5 ) )
nREG := SC2->( RecNo() )
Count To nREGTOT While SC2->C2_NUM <= MV_PAR02
SC2->( DbGoTo( nREG ) )
nPVarOP := GetMv("MV_PVAROP")
cCodEtiq := ""
SetRegua( nREGTOT )

If MV_PAR03 == 1 .and. subs( SC2->C2_PRODUTO, 4, 1 ) == "R"
   PRN_ROL()
Else
   PRN()
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Aplicação de Controle do Spool de Impressão.                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool( cNomRel )   // Chamada do Spool de Impressao
Endif
MS_FLUSH()   // Libera fila de relatorios em spool

Return


//--------------------------------------------------------------------------------------



/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão das OPs - Produto Em Rolo.               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
**************************

Static Function PRN_ROL()

**************************

local nQtdMax := 0

do While ! SC2->( Eof() ) .and. SC2->C2_NUM <= MV_PAR02

   SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
   SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
   nREGPA := SB5->( Recno() )
   If MV_PAR03 == 1

      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"

      /*
       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       ³ Impressão em Impressora Matricial - Corte                    ³
       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      */

	  @ 00,000 psay " ______________________________________________________________________"
	  @ 01,000 psay "|                                                                      |"
	  @ 02,000 psay "|RAVA Embalagens - Industria e Comercio Ltda.                          |"
	  @ 03,000 psay "|                                                                      |"
	  @ 04,000 psay "|     O R D E M   D E   P R O D U C A O           Numero: ____________ |"
	  @ 04,000 psay ""
	  @ 04,060 psay SC2->C2_NUM
		@ 05,000 psay "|                                                                      |"
		@ 06,000 psay "|                                                 Data:   ____________ |"
		@ 06,000 psay ""
		@ 06,060 psay SC2->C2_EMISSAO
		@ 06,000 psay ""
		@ 06,011 psay "V I A   P A R A   C O R T E"
		@ 07,000 psay ""

		Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )

		IF Z03->Z03_DIAS > 8888
			@ 08,002 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
//		ElseIF SB5->B5_TIPO == '2' .AND. Substring(SB5->B5_COD, 1, 1 ) $ 'C'
//			@ 08,002 psay "ATENCAO: HOSPITALAR MÉDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MÉDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MÉDIO 13% MASTER BRANCO"
		ENDIF

		@ 08,000 psay "|                                                 							  |"
		@ 08,000 psay ""
		@ 09,000 psay "|                                                                      |"
		@ 10,000 psay "|Produto: ____________      Peso: ___________     Qtd: _______________ |"
		@ 10,000 psay ""

		cPRODUTO := Left( SC2->C2_PRODUTO, 8 )

		@ 10,012 psay cPRODUTO
		@ 10,034 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 99999.99"

		If SC2->C2_UM == "MR"
			@ 10,056 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3 ) Picture "@E 9999999.999" + " MR"
		ElseIf SC2->C2_UM == "FD"
			@ 10,056 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + " FD"
		Endif

		@ 11,000 psay ""
		@ 11,000 psay "|                                                                      |"
		@ 12,000 psay "|Descricao: __________________________________________________________ |"
		@ 12,000 psay ""
		@ 12,014 psay Left( SB5->B5_CEME, 60 )
		cImpressao := SB5->B5_CEME
		@ 13,000 psay ""
		@ 13,000 psay "|                                                                      |"
		@ 14,000 psay "|Largura: ___________          Comprimento: _____________              |"
		@ 14,000 psay ""
		@ 14,011 psay SB5->B5_LARG  Picture "999"

		/*@ 14,045 psay SB5->B5_COMPR Picture "@E 9999999.99" ate 29/11/06 apenas essa linha*/
		/*If SB5->B5_COMPR3 == 'S'
			@ 14,045 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
		Else
			@ 14,045 psay SB5->B5_COMPR Picture "@E 9999999.99"
		EndIf*/
		/* Mudancas ate aqui 29/11/06 */
		If SB5->B5_DESCOM != 0
			@ 14,045 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
		Else
			@ 14,045 psay SB5->B5_COMPR Picture "@E 9999999.99"
		EndIf
		/* Mudancas ate aqui 13/12/06 */

		@ 15,000 psay ""
		@ 15,000 psay "|                                                                      |"
		@ 16,000 psay "|Espessura: ___________        Sanf./Lamin.: ___________               |"
		@ 16,000 psay ""
		@ 16,013 psay SB5->B5_ESPESS Picture "@E 99999.9999"
		@ 16,047 psay SB5->B5_SANLAM
		@ 17,000 psay ""
		@ 17,000 psay "|                                                                      |"
		@ 18,000 psay "|Cilindro: _____________       Quantidade de Bobinas: __________       |"
		@ 18,000 psay ""
		@ 18,013 psay SB5->B5_CILIN Picture "@E 9999.99"
		@ 18,054 psay SC2->C2_QTSEGUM / 100 Picture "999"
		@ 19,000 psay ""
		@ 19,000 psay "|                                                                      |"
		@ 20,000 psay "|Batidas/Min: ___________      Quantidade p/ Pacote: ___________       |"
		@ 20,000 psay ""
		@ 20,016 psay SB5->B5_BATPM Picture "9999"
		@ 20,054 psay SB5->B5_QE1 Picture "99999"
		@ 21,000 psay ""
		@ 21,000 psay "|                                                                      |"
		@ 22,000 psay "|Slit: _____________           Altura da Faca : ___________            |"
		@ 22,000 psay ""
		@ 22,009 psay IIf(SB5->B5_SLIT == 'S','SIM','NAO')
		@ 22,050 psay Transform( SB5->B5_ALTFAC, '999' ) + ' mm'
		@ 23,000 psay ""
		@ 23,000 psay "|                                                                      |"
		@ 24,000 psay "|Cilindro de Entrada: _____    Posicao do Peso: __________             |"
		@ 24,000 psay ""
		@ 24,024 psay SB5->B5_CILENT Picture "99"
		@ 24,050 psay IIf(SB5->B5_POSPESO == 'E','ESQ','DIR')
		@ 25,000 psay ""
		@ 25,000 psay "|                                                                      |"
		@ 26,000 psay "|Cil. de Silicone 1: _____     Cil. de Silicone 2: _____               |"
		@ 26,000 psay ""
		@ 26,023 psay SB5->B5_CILS1 Picture "99"
		@ 26,053 psay SB5->B5_CILS2 Picture "99"
		@ 27,000 psay ""
		@ 27,000 psay "|                                                                      |"
        @ 28,000 psay "|Temperatura Solda: _______    Registro de Corrente: ______            |"
		@ 28,000 psay ""
		@ 28,021 psay SB5->B5_CSOLDA PICTURE "@E 999.99"
		@ 28,054 psay SB5->B5_REGCORR PICTURE "999"
		@ 29,000 psay "|_______________________________________________________________________|"
		@ 30,000 psay "|       |         |      HORA        |         |       |        |       |"
		@ 31,000 psay "| No.   |         |                  |  Prod./ | Apara |  Maq.  | Oper. |"
		@ 32,000 psay "|Bobinas|  Data   | Inicio | Termino |  Acum.  |       |        |       |"
		@ 33,000 psay "|_______|_________|__________________|_________|_______|________|_______|"
		@ 34,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 35,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 36,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 37,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 38,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 39,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 40,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 41,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 42,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 43,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 44,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 45,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 46,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 47,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 48,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 49,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 50,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 51,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 52,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 53,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 54,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 55,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 56,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 57,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 58,000 psay "|Observacoes:                                                           |"
		@ 58,014 psay SC2->C2_OBS
		@ 59,000 psay "|_______________________________________________________________________|"
		@ 60,000 psay "|_______________________________________________________________________|"
		@ 61,000 psay "|_______________________________________________________________________|"

	  SB5->( DbGoto( nREGPA ) )

    If SB5->B5_IMPRESO == 'S'
      @ 00,000 psay " ______________________________________________________________________"
      @ 01,000 psay "|                                                                      |"
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.                            |"
      @ 03,000 psay "|                                                                      |"
      @ 04,000 psay "|       O R D E M   D E   P R O D U C A O         Numero.: ___________ |"
      @ 04,000 psay ""
      @ 04,061 psay SC2->C2_NUM
      @ 05,000 psay ""
      @ 05,000 psay "|                                                                      |"
      @ 06,000 psay "|                                                 Data...: ___________ |"
      @ 06,000 psay ""
      @ 06,061 psay SC2->C2_EMISSAO
      @ 06,000 psay ""
      @ 06,008 psay "V I A   P A R A   I M P R E S S A O"
      @ 07,000 psay ""
      @ 07,000 psay "|                                                                      |"

		Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )
		IF Z03->Z03_DIAS > 8888
			@ 08,002 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
//		ElseIF SB5->B5_TIPO == '2' .AND. Substring(SB5->B5_COD, 1, 1 ) $ 'C'
//			@ 08,002 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
		ENDIF

      @ 08,000 psay "|                                                 Maquina: ___________ |"
      @ 08,061 psay Iif (! empty (SB5->B5_MAQ),Left(SB5->B5_MAQ,10),'******')
      @ 09,000 psay "|                                                                      |"
      @ 10,000 psay "|Quilos: _____________________________      Produto: ________/________ |"
      @ 10,000 psay ""
			/**/
			cXXX := SC2->C2_NUM
			if SC2->C2_SEQUEN = '001' //P.A.
				SC2->( dbSkip() )
				if SC2->C2_NUM != cXXX
					SC2->( dbSkip(-1) )
				endIf
			endIf
			/**/
      @ 10,009 psay Round(SC2->C2_QUANT*100/(100+nPVarOp),0)  Picture "@E 99999.99"
      @ 10,055 psay Left( SC2->C2_PRODUTO, 8 ) + " " + cPRODUTO

      @ 11,000 psay ""
      @ 11,000 psay "|                                                                      |"
      @ 12,000 psay "|Descricao.....: _____________________________________________________ |"
      //@ 12,019 psay Left(SB5->B5_CEME,60)
			@ 12,014 psay Left( cImpressao, 60 ) //Esmerino Neto (solicitacao de Lindenberg) em 17/02/06
      @ 13,000 psay ""
      @ 13,000 psay "|                                                                      |"
      @ 14,000 psay "|VELOCIDADE(M/MIN): _______    CILINDRO: _______    QTD. COR: _______  |"
      @ 14,000 psay ""
      @ 14,023 psay SB5->B5_VELOCID Picture "999"
      @ 14,044 psay SB5->B5_CILINDR Picture "999"
      @ 14,065 psay SB5->B5_QTDCOR Picture "9"
      @ 15,000 psay "|______________________________________________________________________|"
      @ 16,000 psay "|       |          |              |        |        |                  |"
      @ 17,000 psay "| No.de |          |     Hora     | Bobina | Bobina |                  |"
      @ 18,000 psay "|       |          |              |        |        |                  |"
      @ 19,000 psay "|Bobinas|   Data   |Inicio|Termino|   Km   |   Kg   |     Operador     |"
      @ 20,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 21,000 psay "|       |          |      |       |        |        |                  |"
      @ 22,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 23,000 psay "|       |          |      |       |        |        |                  |"
      @ 24,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 25,000 psay "|       |          |      |       |        |        |                  |"
      @ 26,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 27,000 psay "|       |          |      |       |        |        |                  |"
      @ 28,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 29,000 psay "|       |          |      |       |        |        |                  |"
      @ 30,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 31,000 psay "|       |          |      |       |        |        |                  |"
      @ 32,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 33,000 psay "|       |          |      |       |        |        |                  |"
      @ 34,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 35,000 psay "|       |          |      |       |        |        |                  |"
      @ 36,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 37,000 psay "|       |          |      |       |        |        |                  |"
      @ 38,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 39,000 psay "|       |          |      |       |        |        |                  |"
      @ 40,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 41,000 psay "|       |          |      |       |        |        |                  |"
      @ 42,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 43,000 psay "|       |          |      |       |        |        |                  |"
      @ 44,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 45,000 psay "|       |          |      |       |        |        |                  |"
      @ 46,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 47,000 psay "|       |          |      |       |        |        |                  |"
      @ 48,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 49,000 psay "|       |          |      |       |        |        |                  |"
      @ 50,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 51,000 psay "|       |          |      |       |        |        |                  |"
      @ 52,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 53,000 psay "|       |          |      |       |        |        |                  |"
      @ 54,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 55,000 psay "|       |          |      |       |        |        |                  |"
      @ 56,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 57,000 psay "|       |          |      |       |        |        |                  |"
      @ 58,000 psay "|_______|__________|______|_______|________|________|__________________|"
      @ 59,000 psay "|Observacoes:                                                          |"
      @ 60,000 psay "|______________________________________________________________________|"
      @ 61,000 psay "|Apara KG: __________    Apara KG: __________    Apara KG: _________   |"
      @ 62,000 psay "|______________________________________________________________________|"

		EndIf

      nOP := SC2->C2_NUM

      //SC2->( DbSkip() )

      Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
         SC2->( DbSkip() )
      EndDo
      If SC2->C2_NUM #nOP
         nREG := SC2->( RecNo() )
         IncRegua()
         Loop
      EndIf

      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)

      cQuery := "select  SB1.B1_COD, SB1.B1_DESC, SG1.G1_QUANT, SB1.B1_DENSMAT"
      cQuery += "from    "+ RetSqlName("SB1") +" SB1, "+ RetSqlName("SG1") +" SG1 "
      cQuery += "where   SG1.G1_COD = '"+ alltrim(Left( SC2->C2_PRODUTO, 8 )) +"' "
      cQuery += "and SG1.G1_COMP = SB1.B1_COD "
      cQuery += "and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
      cQuery += "and SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' and SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' "
      cQuery += "order by SB1.B1_DESC desc"
      cQuery := ChangeQuery( cQuery )
      TCQUERY cQuery NEW ALIAS "TMP"
      TMP->( DbGoTop() )
      aProds := {}
      lCond := .F.
      while ! TMP->( EoF() )
        aadd(aProds, {TMP->B1_COD, TMP->B1_DESC, TMP->G1_QUANT, TMP->B1_DENSMAT })
        TMP->( DbSkip() )
      EndDo
      TMP->( DbCloseArea() )
			/*
			 nTot : Soma das quantidades das MP's que compoem o produto final. (primeira coluna na formulacao)
			 nQtdMax :  Calculo da densidade. Ultima informacao da terceira coluna.
			 */
			IF len(aProds) == 5
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3]+aProds[5][3] //100
        lCond := .T.
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) + ((aProds[5][3]/nTot)/aProds[5][4]) )
      ELSEIF len(aProds) == 4
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3] //100
        //lCond := .T.
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) )
      ELSEIF len(aProds) == 3
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3] //100
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) )
      ELSEIF len(aProds) == 2 //mínimo de produtos segundo Lindenberg
        nTot := aProds[2][3]+aProds[1][3]//100
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]))

      ELSEIF  len(aProds) == 1
        nTot := aProds[1][3]
        nQtdMax := 1 / ((aProds[1][3]/nTot)/aProds[1][4])

      ENDIF


     //ALTERADO AQUI
    @ 01,000 psay " ______________________________________________________________________"
    @ 02,000 psay "|                                                                      |"
    @ 03,000 psay "|RAVA Embalagens - Industria e Comercio Ltda.                          |"
    @ 04,000 psay "|                                                                      |"
    @ 05,000 psay "|     O R D E M   D E   P R O D U C A O           Numero:_____________ |"
    @ 05,059 PSay SC2->C2_NUM
    @ 06,000 psay "|       V I A   D E   E X T R U S A O                                  |"
    @ 07,000 psay "|                                                   Data:              |"
    @ 07,059 PSay SC2->C2_EMISSAO
    @ 08,000 psay "|                                                 Maquina:____________ |"
    @ 08,061 psay Iif (! empty (SB5->B5_MAQ),Left(SB5->B5_MAQ,10),'******')

    Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )
		cCodPI := SB5->B5_COD //Neto 06/10/06
		SB5->( DbSeek( xFilial( "SB5" ) + cPRODUTO ), .T. )//Neto 06/10/06
    IF Z03->Z03_DIAS > 8888
      @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
      @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
      @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
    ElseIF SB5->B5_TIPO == '2' .AND. Substring(cPRODUTO, 1, 1 ) $ 'C'
      @ 08,002 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
      @ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
      @ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
    ENDIF
		SB5->( DbSeek( xFilial( "SB5" ) + cCodPI ), .T. )//Neto 06/10/06
    @ 09,000 psay "|  Qtd (Kg):______________                 Produto:_________/_________ |"
    @ 09,014 psay Round(SC2->C2_QUANT*100/(100+nPVarOp),0)  Picture "@E 99999.99"
    @ 09,052 psay Left( SC2->C2_PRODUTO, 8 ) + "   " + cPRODUTO
		/*Incluido em 20/12/06*/
		If mv_par05 == 1
			atualiza(nQtdMax, SC2->C2_PRODUTO, cPRODUTO)
			SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
		EndIf
		/*Fim*/
    @ 10,000 psay "|                                                                      |"
    @ 11,000 psay "|  Descricao:_________________________________________________________ |"
    @ 11,014 psay Left(SB1->B1_DESC,60)

    @ 12,000 psay "|______________________________________________________________________|"
    @ 13,000 psay "|         Dados do Filme           |       Formulacao para 100Kg       |"
    @ 14,000 psay "|__________________________________|___________________________________|"
    @ 15,000 psay "| Largura Filme: _________________ |Produto         Qtd   Qtd.% Densid.|"
    @ 15,018 psay SB5->B5_LARGFIL Picture "@E 999.99"

    @ 16,000 psay "| Largura Bobina: ________________ |______________                     |"
    @ 16,020 psay SB5->B5_BOBLARG Picture "@E 999.99"
    if len(aProds) > 1
      @ 16,037 psay alltrim(aProds[2][2])
      @ 16,052 psay alltrim(transform(aProds[2][3],"@E 999,999.99") )
      //@ 16,059 psay alltrim(transform((aProds[2][3]/(aProds[2][3]+aProds[1][3])) * 100,"@E 999,999.99"))
			@ 16,059 psay alltrim(transform(aProds[2][3],"@E 999,999.99") )
      @ 16,066 psay alltrim(transform(aProds[2][4],"@E 999,999.999"))
    endif

    @ 17,000 psay "| Espessura: _____________________ |______________                     |"
    @ 17,015 psay SB5->B5_ESPESS Picture "@E 9.9999"
    @ 17,037 psay alltrim(aProds[1][2])
    @ 17,052 psay alltrim(transform(aProds[1][3],"@E 999,999.99") )
		if len(aProds) == 1
			@ 17,059 psay "100"
		else
    	    @ 17,059 psay alltrim( transform((aProds[1][3]/(aProds[2][3]+aProds[1][3])) * 100,"@E 999,999.99") ) //"@E 999,999.99"
		endif
    @ 17,066 psay alltrim(transform(aProds[1][4],"@E 999,999.999"))

    @ 18,000 psay "| Tratamento: ____________________ |______________                     |"
    @ 18,015 psay IIf( SB5->B5_TRATAM = 'S', 'SIM', 'NAO' )
    if len(aProds) > 2
      @ 18,037 psay alltrim(aProds[3][2])
      @ 18,052 psay alltrim( transform(aProds[3][3],"@E 999,999.99") )
      //@ 18,059 psay alltrim( transform((aProds[3][3]/nTot) * 100,"@E 999,999.99") )
			@ 18,059 psay alltrim( transform(aProds[3][3],"@E 999,999.99") )
      @ 18,066 psay alltrim(transform(aProds[3][4],"@E 999,999.999"))
    endif

    @ 19,000 PSay "| Slit: __________________________ |______________                     |"
    @ 19,010 psay IIf(SB5->B5_SLITEXT=='S','SIM','NAO')
    if len(aProds) > 3//lCond
      @ 19,037 psay alltrim(aProds[4][2])
      @ 19,052 psay alltrim( transform(aProds[4][3],"@E 999,999.99") )
      //@ 19,059 psay alltrim( transform( (aProds[4][3]/nTot) * 100,"@E 999,999.99" ) )
			@ 19,059 psay alltrim( transform(aProds[4][3],"@E 999,999.99") )
      @ 19,066 psay alltrim(transform(aProds[4][4],"@E 999,999.999"))
      //lCond := .F.
    EndIf

    @ 20,000 psay "| Sanfonado: _____________________ |______________                     |"
    @ 20,015 psay Iif (SB5->B5_SANLAM2 == 'L', 'Lamin.','Sanf.')
		if lCond
      @ 20,037 psay alltrim(aProds[5][2])
      @ 20,052 psay alltrim( transform(aProds[5][3],"@E 999,999.99") )
      //@ 19,059 psay alltrim( transform( (aProds[4][3]/nTot) * 100,"@E 999,999.99" ) )
			@ 20,059 psay alltrim( transform(aProds[5][3],"@E 999,999.99") )
      @ 20,066 psay alltrim(transform(aProds[5][4],"@E 999,999.999"))
      lCond := .F.
    EndIf
                                                                                    //66
    @ 21,000 psay "| Alt.Pesc/Mat:_________/__________|TOTAIS:        100                 |"
    @ 21,015 psay SB5->B5_PTONEVE Picture "@E 999999.99"
    @ 21,026 psay alltrim(Left(SB5->B5_MATRIZ,12))
    @ 21,065 psay alltrim(transform(nQtdMax,"@E 999,999.999"))

    @ 22,000 psay "| Alt.Pesc/Mat:_________/__________|                                   |"
    @ 22,015 psay SB5->B5_PTONEV2 Picture "@E 999999.99"
    @ 22,026 psay alltrim(Left(SB5->B5_MATRIZ2,12))

    @ 23,000 psay "| Peso p/ Metro: _________________ |                                   |"
    nDENSIDA := SB5->B5_DENSIDA
    //@ 23,025 psay SB5->B5_METRBOB Picture "@E 999,999" //METROS POR 100 kgs
    @ 23,017 psay 100/(100 / ( ( SB5->B5_LARGFIL * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 )) Picture "@E 999.999999"
    @ 24,000 PSay "|______________________________________________________________________|"
    @ 25,000 PSay "|                                Producao:                             |"
    @ 26,000 PSay "|Extr. 1:_________(kg/h)Extr.2:___________(kg/h)Extr.3:__________(kg/h)|"
    @ 26,012 PSay  alltrim(transform(SB5->B5_EXT1,"@E 999,999.99"))
    @ 26,034 PSay  alltrim(transform(SB5->B5_EXT2,"@E 999,999.99"))
    @ 26,058 PSay  alltrim(transform(SB5->B5_EXT3,"@E 999,999.99"))


    @ 27,000 psay "|______________________________________________________________________|"
    @ 28,000 psay "| Nro |   Data   |      Hora       |  Peso  | Apara  |     Operador    |"
    @ 29,000 psay "|_Bob_|__________|_Inicio_|_Termin_|_Bobina_|__(Kg)__|_________________|"
    @ 30,000 psay "|     |          |        |        |        |        |                 |"
    @ 31,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 32,000 psay "|     |          |        |        |        |        |                 |"
    @ 33,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 34,000 psay "|     |          |        |        |        |        |                 |"
    @ 35,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 36,000 psay "|     |          |        |        |        |        |                 |"
    @ 37,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 38,000 psay "|     |          |        |        |        |        |                 |"
    @ 39,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 40,000 psay "|     |          |        |        |        |        |                 |"
    @ 41,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 42,000 psay "|     |          |        |        |        |        |                 |"
    @ 43,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 44,000 psay "|     |          |        |        |        |        |                 |"
    @ 45,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 46,000 psay "|     |          |        |        |        |        |                 |"
    @ 47,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 48,000 psay "|     |          |        |        |        |        |                 |"
    @ 49,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 50,000 psay "|     |          |        |        |        |        |                 |"
    @ 51,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 52,000 psay "|     |          |        |        |        |        |                 |"
    @ 53,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 54,000 psay "|     |          |        |        |        |        |                 |"
    @ 55,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 56,000 psay "|     |          |        |        |        |        |                 |"
    @ 57,000 psay "|_____|__________|________|________|________|________|_________________|"
    @ 58,000 psay "|     |          |        |        |        |        |                 |"
    @ 59,000 psay "|_____|__________|________|________|________|________|_________________|"
  //@ 60,000 psay "|     |          |        |        |        |        |                 |"
  //@ 60,000 psay "|_____|__________|________|________|________|________|_________________|"
  //@ 60,000 psay "|     |          |        |        |        |        |                 |"
  //@ 61,000 psay "|_____|__________|________|________|________|________|_________________|"

		Else

      /*
       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       ³ Impressão em Impressora Deskjet - Corte e Extrusao           ³
       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      */

      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"
      nOP  := SC2->C2_NUM

      SC2->( DbSkip() ) //inutil

      Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
         SC2->( DbSkip() )
      EndDo

      lFLAG := If( SC2->C2_NUM #nOP, .F., .T. )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)
      cNUMPI    := SC2->C2_NUM
      dEMISPI   := SC2->C2_EMISSAO
  		cMAQPI    := Left(SB5->B5_MAQ,10)
	    nQTDPI    := Round( SC2->C2_QUANT*100/(100+nPVarOp), 2 )
   	  cPRODPI   := SC2->C2_PRODUTO
      cCEMEPI   := SB5->B5_CEME
      nBOBLGPI  := SB5->B5_BOBLARG
      nLFILPI   := SB5->B5_LARGFIL
      nESPPI    := SB5->B5_ESPESS
      cSANLAMPI := SB5->B5_SANLAM2
      cTRATAMPI := SB5->B5_TRATAM
      cSLITEXPI := SB5->B5_SLITEXT
      nPTNEVEPI := SB5->B5_PTONEVE
      cMATRIZPI := SB5->B5_MATRIZ

      SC2->( DbGoTo( nREG ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      @ 00,000 psay CHR(27)+CHR(38)+"l1O"+chr(27)+CHR(38)+"l26A"+chr(27)+CHR(38)+"l09D"+chr(27)+CHR(38)+"l72P"+chr(27)+"(12U"+chr(27)+"(s0p08h12v0s0b3T"

      @ 00,000 psay ""
      @ 00,000 psay " __________________________________________________"
      @ 00,056 psay If( ! lFLAG, "", " __________________________________________________" )
      @ 01,000 psay "|                                                  |"
      @ 01,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.        |"
      @ 02,056 psay If( ! lFLAG, "", "|RAVA Embalagens Industria e Comercio Ltda.        |" )
      @ 03,000 psay "|                                                  |"
      @ 03,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 04,000 psay "|       ORDEM DE PRODUCAO        Numero.: ________ |"
      @ 04,056 psay If( ! lFLAG, "", "|       ORDEM DE PRODUCAO        Numero.: ________ |" )
      @ 04,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 04,069 psay SC2->C2_NUM
      @ 04,136 psay If( ! lFLAG, "", cNUMPI )
      @ 05,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 05,000 psay "|                                                  |"
      @ 05,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 06,000 psay "|                                Data...: ________ |"
      @ 06,056 psay If( ! lFLAG, "", "|                                Data...: ________ |" )
      @ 06,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 06,068 psay SC2->C2_EMISSAO
      @ 06,135 psay If( ! lFLAG, "", dEMISPI )
      @ 06,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 06,014 psay "VIA PARA CORTE"
      @ 06,080 psay If( ! lFLAG, "", "VIA PARA EXTRUSAO" )
      @ 07,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 07,000 psay "|                                                  |"
      @ 07,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 08,000 psay "|                                Maquina: ________ |"
      @ 08,056 psay If( ! lFLAG, "", "|                                Maquina: ________ |" )
      @ 08,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 08,068 psay If( ! lFLAG, "", "********" )
      @ 08,136 psay If( ! lFLAG, "", cMAQPI )
      @ 09,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 09,000 psay "|                                                  |"
      @ 09,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 10,000 psay "|Prod.: ________   Peso: _______ Qtd:__________ __ |"
      @ 10,056 psay If( ! lFLAG, "", "|Peso: ____________     Produto: ________/________ |" )
      @ 10,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 10,012 psay Left( SC2->C2_PRODUTO, 8 )
      @ 10,032 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 9999.99"

      If SC2->C2_UM == "MR"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  MR'
      ElseIf SC2->C2_UM == "FD"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  FD'
      Endif

      @ 10,080 psay If( ! lFLAG, "", Round(nQTDPI,0) )  Picture If( ! lFLAG, "", "@E 9999.99" )
      @ 10,109 psay If( ! lFLAG, "", Left(cPRODPI,8) + '  ' + Left( SC2->C2_PRODUTO, 8 ) )
      @ 11,000 psay Chr(27)+"(s0p08h12v0s0b3T"
      @ 11,000 psay "|                                                  |"
      @ 11,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 12,000 psay "|Descr.: _________________________________________ |"
      @ 12,056 psay If( ! lFLAG, "", "|Descr.: _________________________________________ |" )
      @ 12,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 12,012 psay SB5->B5_CEME
      @ 12,079 psay If( ! lFLAG, "", cCEMEPI )
      @ 13,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 13,000 psay "|                                                  |"
      @ 13,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 14,000 psay "|Larg. p/ Corte: ___________ Espessura: __________ |"
      @ 14,056 psay If( ! lFLAG, "", "|M.Prim: _________________________________________ |" )
      @ 14,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 14,040 psay SB5->B5_LARG Picture "999.99"
      @ 14,066 psay SB5->B5_ESPESS Picture "@E 9.9999"

      SG1->( DbSeek( xFILIAL("SG1") + cPRODPI, .T. ) )

      aMAT   := {}
      nQUANT := 0

      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cPRODPI
         If Left( SG1->G1_COMP, 4 ) == "MP01"
            SB1->( DbSeek( xFILIAL("SB1") + SG1->G1_COMP ) )
            Aadd( aMAT, { Left( SB1->B1_DESC, 8 ), SG1->G1_QUANT } )
            nQUANT := nQUANT + SG1->G1_QUANT
         EndIf
         SG1->( DbSkip() )
      EndDo

      cMAT  := ""
      nCONT := 1

      Do While nCONT <= Len( aMAT )
         cMAT := cMAT + AllTrim( aMAT[ nCONT, 1 ] ) + " " + Trans( aMAT[ nCONT, 2 ], "999" ) + " Kg "
         nCONT := nCONT + 1
      EndDo

      @ 14,095 psay If( ! lFLAG, "", If( ! Empty( cMAT ), cMAT, "NAO CADASTRADA" ) )
      @ 15,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 15,000 psay "|                                                  |"
      @ 15,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 16,000 psay "|Comp. p/ corte.: __________ Sanf/Lami: __________ |"
      @ 16,056 psay If( ! lFLAG, "", "|Larg. do Filme: ___________ Espessura: __________ |" )
      @ 16,000 psay chr(27)+"(s0p12h12v1s0b3T"

			/*@ 16,040 psay SB5->B5_COMPR Picture "999" ate 29/11/06 apenas essa linha*/
			/*If SB5->B5_COMPR3 == 'S'
				@ 16,040 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
			Else
				@ 16,040 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf*/
			/* Mudancas ate aqui 29/11/06 */

			If SB5->B5_DESCOM != 0
				@ 16,040 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
			Else
				@ 16,040 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf
			/* Mudancas ate aqui 13/12/06 */

      @ 16,069 psay SB5->B5_SANLAM
      @ 16,107 psay If( ! lFLAG, "", nLFILPI ) Picture If( ! lFLAG, "", "@E 999.99" )
      @ 16,134 psay If( ! lFLAG, "", nESPPI ) Picture If( ! lFLAG, "", "@E 9.9999" )
      @ 17,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 17,000 psay "|                                                  |"
      @ 17,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 18,000 psay "|Cilindro:__________________ Qtd. bob.: __________ |"
      @ 18,056 psay If( ! lFLAG, "", "|Larg. da Bobina: __________ Sanf/Lami: __________ |" )
      @ 18,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 18,042 psay SB5->B5_SOLDFL
      @ 18,067 psay Round( SC2->C2_QTSEGUM*100/(100+nPVarOp), 2 ) / 100 Picture "999"
      @ 18,107 psay If( ! lFLAG, "", nBOBLGPI ) Picture If( ! lFLAG, "", "999.99" )
      @ 18,135 psay If( ! lFLAG, "", cSANLAMPI )
      @ 19,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 19,000 psay "|                                                  |"
      @ 19,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 20,000 psay "|No. Batidas/Min: __________ Qtd.p/pac: __________ |"
      @ 20,056 psay If( ! lFLAG, "", "|Tratamento.....: __________ Slit.....: __________ |" )
      @ 20,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 20,042 psay SB5->B5_SANFFL

      nDENSIDA := SB5->B5_DENSIDA

      @ 20,066 psay If( ! lFLAG, "", SB5->B5_QE1 ) Picture If( ! lFLAG, "", "9999" )
      @ 20,106 psay If( ! lFLAG, "", IIf(cTRATAMPI=='S','SIM','NAO') )
      @ 20,133 psay If( ! lFLAG, "", IIf(cSLITEXPI=='S','SIM','NAO') )
      @ 21,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 21,000 psay "|                                                  |"
      @ 21,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 22,000 psay "|Slit: _____________________ Peso p/MR: __________ |"
      @ 22,056 psay If( ! lFLAG, "", "|Metros p/100 kg: __________ Peso p/ Metro:_______ |" )

      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )

      @ 22,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 22,035 psay IIf(SB5->B5_SLIT=='S','SIM','NAO')
      @ 22,065 psay SB1->B1_PESO / SB5->B5_QE2 * 1000  Picture "@E 9,999.999"
      @ 22,104 psay If( ! lFLAG, "", 100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) Picture If( ! lFLAG, "", "@E 999,999" )
      @ 22,134 psay If( ! lFLAG, "", 100/(100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) ) Picture If( ! lFLAG, "", "@E 999.999999" )
      @ 22,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 23,000 psay "|                                                  |"
      @ 23,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 24,056 psay "|Alt.  Pescoco: ____________ Matriz: _____________ |"
      @ 24,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 24,102 psay nPTNEVEPI Picture "999999.99"
      @ 24,133 psay Left(cMATRIZPI,12)
      @ 25,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 25,000 psay "|__________________________________________________|"
      @ 25,056 psay If( ! lFLAG, "", "|__________________________________________________|" )
      @ 26,000 psay "|     |      |           |          |     |        |"
      @ 26,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 27,000 psay "|No.de|      |    Hora   |          |     |        |"
      @ 27,056 psay If( ! lFLAG, "", "| No.|      |   Hora  | Bob. |  Bob. |     |       |" )
      @ 28,000 psay "|     |      |           |          |     |        |"
      @ 28,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 29,000 psay "| Bob.| Data |Inic.|Term.|Quantidade| Kg  |Operador|"
      @ 29,056 psay If( ! lFLAG, "", "|Bob.| Data |Inic|Term|  Km  |   Kg  |Apara|Operad.|" )
      @ 30,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 30,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 31,000 psay "|     |      |     |     |          |     |        |"
      @ 31,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 32,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 32,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 33,000 psay "|     |      |     |     |          |     |        |"
      @ 33,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 34,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 34,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 35,000 psay "|     |      |     |     |          |     |        |"
      @ 35,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 36,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 36,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 37,000 psay "|     |      |     |     |          |     |        |"
      @ 37,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 38,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 38,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 39,000 psay "|     |      |     |     |          |     |        |"
      @ 39,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 40,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 40,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 41,000 psay "|     |      |     |     |          |     |        |"
      @ 41,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 42,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 42,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 43,000 psay "|     |      |     |     |          |     |        |"
      @ 43,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 44,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 44,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 45,000 psay "|     |      |     |     |          |     |        |"
      @ 45,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 46,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 46,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 47,000 psay "|     |      |     |     |          |     |        |"
      @ 47,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 48,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 48,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 49,000 psay "|     |      |     |     |          |     |        |"
      @ 49,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 50,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 50,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 51,000 psay "|     |      |     |     |          |     |        |"
      @ 51,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 52,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 52,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 53,000 psay "|     |      |     |     |          |     |        |"
      @ 53,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 54,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 54,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 55,000 psay "|     |      |     |     |          |     |        |"
      @ 55,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 56,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 56,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 57,000 psay "|     |      |     |     |          |     |        |"
      @ 57,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 58,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 58,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 59,000 psay "|     |      |     |     |          |     |        |"
      @ 59,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 60,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 60,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 61,000 psay "|Observacoes:                                      |"
      @ 61,056 psay If( ! lFLAG, "",  "|Observacoes:                                      |" )
      @ 62,000 psay "|__________________________________________________|"
      @ 62,056 psay If( ! lFLAG, "",  "|__________________________________________________|" )
      @ 63,000 psay "|__________________________________________________|"
      @ 63,056 psay If( ! lFLAG, "",  "|__________________________________________________|" )
      @ 64,000 psay "|__________________________________________________|"
      @ 64,056 psay If( ! lFLAG, "",  "|__________________________________________________|" )

      @ 00,000 psay CHR(27)+CHR(38)+"l0O"+CHR(27)+CHR(38)+"12A"+CHR(27)+CHR(38)+"107D"+CHR(27)+CHR(38)+"l72P(12U(s0p12h12v0s0b3T"

   EndIf

   ETQ()

EndDo

return

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão das OPs - Padrao.                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
**********************

Static Function PRN()

**********************


Do While ! SC2->( Eof() ) .and. SC2->C2_NUM <= MV_PAR02
   SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
   SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
   nREGPA := SB5->( Recno() )
   If MV_PAR03 == 1
      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"
      @ 00,000 psay " ______________________________________________________________________"
      @ 01,000 psay "|                                                                      |"
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.                            |"
      @ 03,000 psay "|                                                                      |"
      @ 04,000 psay "|       O R D E M   D E   P R O D U C A O         Numero.: ___________ |"
      @ 04,000 psay ""
      @ 04,061 psay SC2->C2_NUM
      @ 05,000 psay ""
      @ 05,000 psay "|                                                                      |"
      @ 06,000 psay "|                                                 Data...: ___________ |"
      @ 06,000 psay ""
      @ 06,061 psay SC2->C2_EMISSAO
      @ 06,000 psay ""
      @ 06,011 psay "V I A   P A R A   C O R T E"
      @ 07,000 psay ""
      @ 07,000 psay "|                                                                      |"

		Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )
		IF Z03->Z03_DIAS > 8888
			@ 08,002 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
			@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
//		ElseIF SB5->B5_TIPO == '2' .AND. Substring(SB5->B5_COD, 1, 1 ) $ 'C'
//			@ 08,002 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
		ENDIF

      @ 08,000 psay "|                                                 Maquina: ___________ |"
      @ 08,000 psay ""
      @ 08,060 psay Iif (! empty (SB5->B5_MAQ),Left(SB5->B5_MAQ,10), '******')
      @ 09,000 psay "|                                                                      |"
      @ 10,000 psay "|Produto: ___________      Quilos: _________      Qtd: ___________  __ |"
      @ 10,000 psay ""
      cPRODUTO := Left( SC2->C2_PRODUTO, 8 )
      @ 10,012 psay cPRODUTO
      @ 10,035 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 99999.99"

      If SC2->C2_UM == "MR"
         @ 10,057 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3 ) Picture "@E 9999999.999" + "  MR"
      ElseIf SC2->C2_UM == "FD"
         @ 10,057 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + "  FD"
      Endif

      @ 11,000 psay ""
      @ 11,000 psay "|                                                                      |"
      @ 12,000 psay "|Descricao.....: _____________________________________________________ |"
      @ 12,000 psay ""
      @ 12,019 psay Left( SB1->B1_DESC, 50 )
			cImpressao := SB1->B1_DESC
      @ 13,000 psay ""
      @ 13,000 psay "|                                                                      |"
      @ 14,000 psay "|Largura p/ Corte......: ___________    Espessura.........: __________ |"
      @ 14,000 psay ""
      @ 14,026 psay SB5->B5_LARG  Picture "999"
      @ 14,062 psay SB5->B5_ESPESS Picture "@E 9.9999"
      @ 15,000 psay ""
      @ 15,000 psay "|                                                                      |"
      @ 16,000 psay "|Comprimento para corte: ___________    Sanfonado/Laminado: __________ |"
      @ 16,000 psay ""

			/*@ 16,026 psay SB5->B5_COMPR Picture "999" ate 29/11/06 apenas essa linha*/
			/*If SB5->B5_COMPR3 == 'S'
				@ 16,026 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
			Else
				@ 16,026 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf*/
			/* Mudancas ate aqui 29/11/06 */

			If SB5->B5_DESCOM != 0
				@ 16,026 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
			Else
				@ 16,026 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf
			/* Mudancas ate aqui 13/12/06 */

      @ 16,065 psay Iif (SB5->B5_SANLAM == 'L','Lamin.','Sanf.')
      @ 17,000 psay ""
      @ 17,000 psay "|                                                                      |"
      @ 18,000 psay "|Solda Fundo/Lateral...: ___________    Quantid. bobinas..: __________ |"
      @ 18,000 psay ""
      @ 18,027 psay SB5->B5_SOLDFL
      @ 18,060 psay SC2->C2_QTSEGUM / 100 Picture "999"
      @ 19,000 psay ""
      @ 19,000 psay "|                                                                      |"
      @ 20,000 psay "|Sanf. Fundo/Lateral...: ___________    Quant. p/ pacote..: __________ |"
      @ 20,000 psay ""
      @ 20,027 psay SB5->B5_SANFFL
      @ 20,060 psay SB5->B5_QE1 Picture "9999"
      @ 21,000 psay ""
      @ 21,000 psay "|                                                                      |"
      @ 22,000 psay "|Slit...: __________________________    Peso p/milheiro..: ___________ |"
      @ 22,000 psay ""
      @ 22,012 psay IIf(SB5->B5_SLIT=='S','SIM','NAO')
      @ 22,059 psay SB1->B1_PESO / SB5->B5_QE2 * 1000 Picture "@E 9,999.999"
      @ 23,000 psay ""
      @ 23,000 psay "|                                                                      |"
      @ 24,000 psay "|Temperatura Solda: _______             Batidas/Min: _________________ |"
      @ 24,000 psay ""
      @ 24,021 psay SB5->B5_CSOLDA PICTURE "@E 999.99"
      @ 24,055 psay SB5->B5_BATPM Picture "9999"
      @ 25,000 psay ""
      @ 25,000 psay "|_______________________________________________________________________|"
      @ 26,000 psay "|       |          |                 |             |       |            |"
      @ 27,000 psay "| No.de |          |      Hora       |             | Apara |            |"
      @ 28,000 psay "|       |          |                 |             |       |            |"
      @ 29,000 psay "|Bobinas|   Data   | Inicio | Termino| Quant/Acum  |  KG   |  Operador  |"
      @ 30,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 31,000 psay "|       |          |        |        |      /      |       |            |"
      @ 32,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 33,000 psay "|       |          |        |        |      /      |       |            |"
      @ 34,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 35,000 psay "|       |          |        |        |      /      |       |            |"
      @ 36,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 37,000 psay "|       |          |        |        |      /      |       |            |"
      @ 38,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 39,000 psay "|       |          |        |        |      /      |       |            |"
      @ 40,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 41,000 psay "|       |          |        |        |      /      |       |            |"
      @ 42,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 43,000 psay "|       |          |        |        |      /      |       |            |"
      @ 44,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 45,000 psay "|       |          |        |        |      /      |       |            |"
      @ 46,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 47,000 psay "|       |          |        |        |      /      |       |            |"
      @ 48,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 49,000 psay "|       |          |        |        |      /      |       |            |"
      @ 50,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 51,000 psay "|       |          |        |        |      /      |       |            |"
      @ 52,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 53,000 psay "|       |          |        |        |      /      |       |            |"
      @ 54,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 55,000 psay "|       |          |        |        |      /      |       |            |"
      @ 56,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 57,000 psay "|       |          |        |        |      /      |       |            |"
      @ 58,000 psay "|_______|__________|________|________|_____________|_______|____________|"
      @ 59,000 psay "|Observacoes:                                                           |"
      @ 59,015 psay SC2->C2_OBS
      @ 60,000 psay "|_______________________________________________________________________|"
      @ 61,000 psay "|_______________________________________________________________________|"
      @ 62,000 psay "|_______________________________________________________________________|"

      SB5->( DbGoto( nREGPA ) )


      //Via para Costura incluido por Eurivan  em  01/10/2007 solicitado por Lindenberg

      /*
       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       ³ Impressão em Impressora Matricial - Costura                  ³
       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      */    

      if SB5->B5_COSTUR = "S"
   	     @ 00,000 psay " ______________________________________________________________________"
   	     @ 01,000 psay "|                                                                      |"
	     @ 02,000 psay "|RAVA Embalagens - Industria e Comercio Ltda.                          |"
	     @ 03,000 psay "|                                                                      |"
	     @ 04,000 psay "|     O R D E M   D E   P R O D U C A O           Numero: ____________ |"
	     @ 04,000 psay ""
	     @ 04,060 psay SC2->C2_NUM
	     @ 05,000 psay "|                                                                      |"
	     @ 06,000 psay "|                                                 Data:   ____________ |"
	     @ 06,000 psay ""
	     @ 06,060 psay SC2->C2_EMISSAO
	     @ 06,000 psay ""
	     @ 06,011 psay "V I A   P A R A   C O S T U R A"
	     @ 07,000 psay ""

	     Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )

	     IF Z03->Z03_DIAS > 8888
	  	    @ 08,002 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
	  	    @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
	 	    @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
	     ENDIF

	     @ 08,000 psay "|                                                 							  |"
	     @ 08,000 psay ""
	     @ 09,000 psay "|                                                                      |"
	     @ 10,000 psay "|Produto: ____________      Peso: ___________     Qtd: _______________ |"
	     @ 10,000 psay ""


	     @ 10,012 psay Left( SC2->C2_PRODUTO, 8 )
	     @ 10,034 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 99999.99"

	     If SC2->C2_UM == "MR"
	   	    @ 10,056 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3 ) Picture "@E 9999999.999" + " MR"
	     ElseIf SC2->C2_UM == "FD"
	  	    @ 10,056 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + " FD"
	     Endif

	     @ 11,000 psay ""
	     @ 11,000 psay "|                                                                      |"
	     @ 12,000 psay "|Descricao: __________________________________________________________ |"
	     @ 12,000 psay ""
	     @ 12,014 psay Left( SB5->B5_CEME, 60 )
	     cImpressao := SB5->B5_CEME
	     @ 13,000 psay ""
	     @ 13,000 psay "|                                                                      |"
	     @ 14,000 psay "|Largura: ___________          Comprimento: _____________              |"
	     @ 14,000 psay ""
	     @ 14,011 psay SB5->B5_LARG  Picture "999"

		If SB5->B5_DESCOM != 0
			@ 14,045 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
		Else
			@ 14,045 psay SB5->B5_COMPR Picture "@E 9999999.99"
		EndIf

		@ 15,000 psay ""
		@ 15,000 psay "|                                                                      |"
		@ 16,000 psay "|Espessura: ___________        Sanf./Lamin.: ___________               |"
		@ 16,000 psay ""
		@ 16,013 psay SB5->B5_ESPESS Picture "@E 99999.9999"
		@ 16,047 psay SB5->B5_SANLAM
		@ 17,000 psay ""
		@ 17,000 psay "|                                                                      |"
		@ 18,000 psay "|Cilindro: _____________       Quantidade de Bobinas: __________       |"
		@ 18,000 psay ""
		@ 18,013 psay SB5->B5_CILIN Picture "@E 9999.99"
		@ 18,054 psay SC2->C2_QTSEGUM / 100 Picture "999"
		@ 19,000 psay ""
		@ 19,000 psay "|                                                                      |"
		@ 20,000 psay "|Batidas/Min: ___________      Quantidade p/ Pacote: ___________       |"
		@ 20,000 psay ""
		@ 20,016 psay SB5->B5_BATPM Picture "9999"
		@ 20,054 psay SB5->B5_QE1 Picture "99999"
		@ 21,000 psay ""
		@ 21,000 psay "|                                                                      |"
		@ 22,000 psay "|Slit: _____________           Altura da Faca : ___________            |"
		@ 22,000 psay ""
		@ 22,009 psay IIf(SB5->B5_SLIT == 'S','SIM','NAO')
		@ 22,050 psay Transform( SB5->B5_ALTFAC, '999' ) + ' mm'
		@ 23,000 psay ""
		@ 23,000 psay "|                                                                      |"
		@ 24,000 psay "|Cilindro de Entrada: _____    Posicao do Peso: __________             |"
		@ 24,000 psay ""
		@ 24,024 psay SB5->B5_CILENT Picture "99"
		@ 24,050 psay IIf(SB5->B5_POSPESO == 'E','ESQ','DIR')
		@ 25,000 psay ""
		@ 25,000 psay "|                                                                      |"
		@ 26,000 psay "|Cil. de Silicone 1: _____     Cil. de Silicone 2: _____               |"
		@ 26,000 psay ""
		@ 26,023 psay SB5->B5_CILS1 Picture "99"
		@ 26,053 psay SB5->B5_CILS2 Picture "99"
		@ 27,000 psay ""
		@ 27,000 psay "|                                                                      |"
        @ 28,000 psay "|Temperatura Solda: _______    Registro de Corrente: ______            |"
		@ 28,000 psay ""
		@ 28,021 psay SB5->B5_CSOLDA PICTURE "@E 999.99"
		@ 28,054 psay SB5->B5_REGCORR PICTURE "999"
		@ 29,000 psay "|_______________________________________________________________________|"
		@ 30,000 psay "|       |         |      HORA        |         |       |        |       |"
		@ 31,000 psay "| No.   |         |                  |  Prod./ | Apara |  Maq.  | Oper. |"
		@ 32,000 psay "|Bobinas|  Data   | Inicio | Termino |  Acum.  |       |        |       |"
		@ 33,000 psay "|_______|_________|__________________|_________|_______|________|_______|"
		@ 34,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 35,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 36,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 37,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 38,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 39,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 40,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 41,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 42,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 43,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 44,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 45,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 46,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 47,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 48,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 49,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 50,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 51,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 52,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 53,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 54,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 55,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 56,000 psay "|       |         |        |         |    /    |       |        |       |"
		@ 57,000 psay "|_______|_________|________|_________|_________|_______|________|_______|"
		@ 58,000 psay "|Observacoes:                                                           |"
		@ 58,014 psay SC2->C2_OBS
		@ 59,000 psay "|_______________________________________________________________________|"
		@ 60,000 psay "|_______________________________________________________________________|"
		@ 61,000 psay "|_______________________________________________________________________|"
     endif
    //Via para Costura


   	If SB5->B5_IMPRESO == 'S'
    	  @ 00,000 psay " ______________________________________________________________________"
    	  @ 01,000 psay "|                                                                      |"
    	  @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.                            |"
    	  @ 03,000 psay "|                                                                      |"
    	  @ 04,000 psay "|       O R D E M   D E   P R O D U C A O         Numero.: ___________ |"
    	  @ 04,000 psay ""
    	  @ 04,061 psay SC2->C2_NUM
    	  @ 05,000 psay ""
    	  @ 05,000 psay "|                                                                      |"
    	  @ 06,000 psay "|                                                 Data...: ___________ |"
    	  @ 06,000 psay ""
    	  @ 06,061 psay SC2->C2_EMISSAO
    	  @ 06,000 psay ""
    	  @ 06,008 psay "V I A   P A R A   I M P R E S S A O"
    	  @ 07,000 psay ""
    	  @ 07,000 psay "|                                                                      |"

				Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )
				IF Z03->Z03_DIAS > 8888
					@ 08,002 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
					@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
					@ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
		//		ElseIF SB5->B5_TIPO == '2' .AND. Substring(SB5->B5_COD, 1, 1 ) $ 'C'
		//			@ 08,002 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
		//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
		//			@ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
				ENDIF

    	  @ 08,000 psay "|                                                 Maquina: ___________ |"
    	  @ 08,061 psay Iif (! empty (SB5->B5_MAQ),Left(SB5->B5_MAQ,10),'******')
    	  @ 09,000 psay "|                                                                      |"
    	  @ 10,000 psay "|Quilos: _____________________________      Produto: ________/________ |"
    	  @ 10,000 psay ""
		  /**/
		  cXXX := SC2->C2_NUM
		  if SC2->C2_SEQUEN = '001' //P.A.
		  	  SC2->( dbSkip() )
			  if SC2->C2_NUM != cXXX
				  SC2->( dbSkip(-1) )
			  endIf
		  endIf
		  /**/
    	  @ 10,009 psay Round(SC2->C2_QUANT*100/(100+nPVarOp),0)  Picture "@E 99999.99"
    	  @ 10,055 psay Left( SC2->C2_PRODUTO, 8 ) + " " + cPRODUTO

    	  @ 11,000 psay ""
    	  @ 11,000 psay "|                                                                      |"
    	  @ 12,000 psay "|Descricao.....: _____________________________________________________ |"
    	  //@ 12,019 psay Left(SB5->B5_CEME,60)
				@ 12,014 psay Left( cImpressao, 60 ) //Esmerino Neto (solicitacao Lindenberg) em 17/06/06
    	  @ 13,000 psay ""
    	  @ 13,000 psay "|                                                                      |"
    	  @ 14,000 psay "|VELOCIDADE(M/MIN): _______    CILINDRO: _______    QTD. COR: _______  |"
    	  @ 14,000 psay ""
    	  @ 14,023 psay SB5->B5_VELOCID Picture "999"
    	  @ 14,044 psay SB5->B5_CILINDR Picture "999"
    	  @ 14,065 psay SB5->B5_QTDCOR Picture "9"
    	  @ 15,000 psay "|______________________________________________________________________|"
    	  @ 16,000 psay "|       |          |              |        |        |                  |"
    	  @ 17,000 psay "| No.de |          |     Hora     | Bobina | Bobina |                  |"
    	  @ 18,000 psay "|       |          |              |        |        |                  |"
    	  @ 19,000 psay "|Bobinas|   Data   |Inicio|Termino|   Km   |   Kg   |     Operador     |"
    	  @ 20,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 21,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 22,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 23,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 24,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 25,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 26,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 27,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 28,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 29,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 30,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 31,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 32,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 33,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 34,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 35,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 36,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 37,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 38,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 39,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 40,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 41,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 42,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 43,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 44,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 45,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 46,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 47,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 48,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 49,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 50,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 51,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 52,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 53,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 54,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 55,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 56,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 57,000 psay "|       |          |      |       |        |        |                  |"
    	  @ 58,000 psay "|_______|__________|______|_______|________|________|__________________|"
    	  @ 59,000 psay "|Observacoes:                                                          |"
    	  @ 60,000 psay "|______________________________________________________________________|"
    	  @ 61,000 psay "|Apara KG: __________    Apara KG: __________    Apara KG: _________   |"
    	  @ 62,000 psay "|______________________________________________________________________|"

	EndIf

	nOP := SC2->C2_NUM

    //SC2->( DbSkip() )

    Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
       SC2->( DbSkip() )
    EndDo
      
    If SC2->C2_NUM #nOP
       nREG := SC2->( RecNo() )
       IncRegua()
       Loop
    EndIf

      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)

      cQuery := "select  SB1.B1_COD, SB1.B1_DESC, SG1.G1_QUANT, SB1.B1_DENSMAT"
      cQuery += "from    "+ RetSqlName("SB1") +" SB1, "+ RetSqlName("SG1") +" SG1 "
      cQuery += "where   SG1.G1_COD = '"+ alltrim(Left( SC2->C2_PRODUTO, 8 )) +"' "
      cQuery += "and SG1.G1_COMP = SB1.B1_COD "
      cQuery += "and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
      cQuery += "and SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' and SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' "
      cQuery += "order by SB1.B1_DESC desc"
      cQuery := ChangeQuery( cQuery )
      TCQUERY cQuery NEW ALIAS "TMP"
      TMP->( DbGoTop() )
      aProds := {}
      lCond := .F.
      while ! TMP->( EoF() )
        aadd(aProds, {TMP->B1_COD, TMP->B1_DESC, TMP->G1_QUANT, TMP->B1_DENSMAT })
        TMP->( DbSkip() )
      EndDo
      TMP->( DbCloseArea() )
			/*
			 nTot : Soma das quantidades das MP's que compoem o produto final. (primeira coluna na formulacao)
			 nQtdMax :  Calculo da densidade. Ultima informacao da terceira coluna.
			 */
      IF len(aProds) == 5
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3]+aProds[5][3] //100
        lCond := .T.
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) + ((aProds[5][3]/nTot)/aProds[5][4]) )
      ELSEIF len(aProds) == 4
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3] //100
        //lCond := .T.
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) )
      ELSEIF len(aProds) == 3
        nTot := aProds[2][3]+aProds[1][3]+aProds[3][3] //100
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
                       ((aProds[3][3]/nTot)/aProds[3][4]) )
      ELSEIF len(aProds) == 2 //mínimo de produtos segundo Lindenberg
        nTot := aProds[2][3]+aProds[1][3]//100
        nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]))

      ELSEIF  len(aProds) == 1
        nTot := aProds[1][3]
        nQtdMax := 1 / ((aProds[1][3]/nTot)/aProds[1][4])

      ENDIF


     	//ALTERADO AQUI
    	@ 01,000 PSAY chr(18)
    	@ 01,000 psay " ______________________________________________________________________"
    	@ 02,000 psay "|                                                                      |"
    	@ 03,000 psay "|RAVA Embalagens - Industria e Comercio Ltda.                          |"
    	@ 04,000 psay "|                                                                      |"
    	@ 05,000 psay "|     O R D E M   D E   P R O D U C A O           Numero:_____________ |"
    	@ 05,059 PSay SC2->C2_NUM
    	@ 06,000 psay "|       V I A   D E   E X T R U S A O                                  |"
    	@ 07,000 psay "|                                                   Data:              |"
    	@ 07,059 PSay SC2->C2_EMISSAO
    	@ 08,000 psay "|                                                 Maquina:____________ |"
    	@ 08,061 psay Iif (! empty (SB5->B5_MAQ),Left(SB5->B5_MAQ,10),'******')

    	Z03->( DbSeek( xFILIAL("Z03") + SC2->C2_NUM ) )
			cCodPI := SB5->B5_COD //Neto 06/10/06
			SB5->( DbSeek( xFilial( "SB5" ) + cPRODUTO ), .T. )//Neto 06/10/06
    	IF Z03->Z03_DIAS > 8888
     	 @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
     	 @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
     	 @ 08,003 psay "***ATENCAO: ORDEM DE PRODUCAO DE PRIORIDADE***"
    	ElseIF SB5->B5_TIPO == '2' .AND. Substring(cPRODUTO, 1, 1 ) $ 'C'
     	 @ 08,002 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
     	 @ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
     	 @ 08,003 psay "ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO"
    	ENDIF
			SB5->( DbSeek( xFilial( "SB5" ) + cCodPI ), .T. )//Neto 06/10/06
    	@ 09,000 psay "|  Qtd (Kg):______________                 Produto:_________/_________ |"
    	@ 09,014 psay Round(SC2->C2_QUANT*100/(100+nPVarOp),0)  Picture "@E 99999.99"
    	@ 09,052 psay Left( SC2->C2_PRODUTO, 8 ) + "   " + cPRODUTO

			/*Incluido em 20/12/06*/
			If mv_par05 == 1
		 		atualiza(nQtdMax, SC2->C2_PRODUTO, cPRODUTO)
		 		SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
			EndIf
			/*Fim*/

    	@ 10,000 psay "|                                                                      |"
    	@ 11,000 psay "|  Descricao:_________________________________________________________ |"
    	@ 11,014 psay Left(SB1->B1_DESC,60)

    	@ 12,000 psay "|______________________________________________________________________|"
    	@ 13,000 psay "|         Dados do Filme           |       Formulacao para 100Kg       |"
    	@ 14,000 psay "|__________________________________|___________________________________|"
    	@ 15,000 psay "| Largura Filme: _________________ |Produto         Qtd   Qtd.% Densid.|"
    	@ 15,018 psay SB5->B5_LARGFIL Picture "@E 999.99"

    	@ 16,000 psay "| Largura Bobina: ________________ |______________                     |"
    	@ 16,020 psay SB5->B5_BOBLARG Picture "@E 999.99"
    	if len(aProds) > 1
     	 @ 16,037 psay alltrim(aProds[2][2])
     	 @ 16,052 psay alltrim(transform(aProds[2][3],"@E 999,999.99") )
     	 //@ 16,059 psay alltrim(transform((aProds[2][3]/(aProds[2][3]+aProds[1][3])) * 100,"@E 999,999.99"))
			 @ 16,059 psay alltrim(transform(aProds[2][3],"@E 999,999.99") )
     	 @ 16,066 psay alltrim(transform(aProds[2][4],"@E 999,999.999"))
    	endif

    	@ 17,000 psay "| Espessura: _____________________ |______________                     |"
    	@ 17,015 psay SB5->B5_ESPESS Picture "@E 9.9999"
    	@ 17,037 psay alltrim(aProds[1][2])
    	@ 17,052 psay alltrim(transform(aProds[1][3],"@E 999,999.99") )
			if len(aProds) == 1
		 		@ 17,059 psay "100"
			else
     		@ 17,059 psay alltrim( transform((aProds[1][3]/(aProds[2][3]+aProds[1][3])) * 100,"@E 999,999.99") ) //"@E 999,999.99"
			endif
    	@ 17,066 psay alltrim(transform(aProds[1][4],"@E 999,999.999"))

    	@ 18,000 psay "| Tratamento: ____________________ |______________                     |"
    	@ 18,015 psay IIf( SB5->B5_TRATAM = 'S', 'SIM', 'NAO' )
    	if len(aProds) > 2
     	 @ 18,037 psay alltrim(aProds[3][2])
     	 @ 18,052 psay alltrim( transform(aProds[3][3],"@E 999,999.99") )
     	 //@ 18,059 psay alltrim( transform((aProds[3][3]/nTot) * 100,"@E 999,999.99") )
			 @ 18,059 psay alltrim( transform(aProds[3][3],"@E 999,999.99") )
     	 @ 18,066 psay alltrim(transform(aProds[3][4],"@E 999,999.999"))
    	endif

    	@ 19,000 PSay "| Slit: __________________________ |______________                     |"
    	@ 19,010 psay IIf(SB5->B5_SLITEXT=='S','SIM','NAO')
    	if len(aProds) > 3//lCond
     	 @ 19,037 psay alltrim(aProds[4][2])
     	 @ 19,052 psay alltrim( transform(aProds[4][3],"@E 999,999.99") )
     	 //@ 19,059 psay alltrim( transform( (aProds[4][3]/nTot) * 100,"@E 999,999.99" ) )
			 @ 19,059 psay alltrim( transform(aProds[4][3],"@E 999,999.99") )
     	 @ 19,066 psay alltrim(transform(aProds[4][4],"@E 999,999.999"))
     	 //lCond := .F.
    	EndIf

    	@ 20,000 psay "| Sanfonado: _____________________ |______________                     |"
    	@ 20,015 psay Iif (SB5->B5_SANLAM2 == 'L', 'Lamin.','Sanf.')
			if lCond
      	@ 20,037 psay alltrim(aProds[5][2])
      	@ 20,052 psay alltrim( transform(aProds[5][3],"@E 999,999.99") )
      	//@ 19,059 psay alltrim( transform( (aProds[4][3]/nTot) * 100,"@E 999,999.99" ) )
				@ 20,059 psay alltrim( transform(aProds[5][3],"@E 999,999.99") )
      	@ 20,066 psay alltrim(transform(aProds[5][4],"@E 999,999.999"))
      	lCond := .F.
    	EndIf
     	                                                                               //66
    	@ 21,000 psay "| Alt.Pesc/Mat:_________/__________|TOTAIS:        100                 |"
    	@ 21,015 psay SB5->B5_PTONEVE Picture "@E 999999.99"
    	@ 21,026 psay alltrim(Left(SB5->B5_MATRIZ,12))
    	@ 21,065 psay alltrim(transform(iif(MV_PAR05=1,nQtdMax,0),"@E 999,999.999"))

    	@ 22,000 psay "| Alt.Pesc/Mat:_________/__________|                                   |"
    	@ 22,015 psay SB5->B5_PTONEV2 Picture "@E 999999.99"
    	@ 22,026 psay alltrim(Left(SB5->B5_MATRIZ2,12))

    	@ 23,000 psay "| Peso p/ Metro: _________________ |                                   |"
    	nDENSIDA := SB5->B5_DENSIDA
    	//@ 23,025 psay SB5->B5_METRBOB Picture "@E 999,999" //METROS POR 100 kgs
    	@ 23,017 psay 100/(100 / ( ( SB5->B5_LARGFIL * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 )) Picture "@E 999.999999"
    	@ 24,000 PSay "|______________________________________________________________________|"
    	@ 25,000 PSay "|                                Producao:                             |"
    	@ 26,000 PSay "|Extr. 1:_________(kg/h)Extr.2:___________(kg/h)Extr.3:__________(kg/h)|"
    	@ 26,012 PSay  alltrim(transform(SB5->B5_EXT1,"@E 999,999.99"))
    	@ 26,034 PSay  alltrim(transform(SB5->B5_EXT2,"@E 999,999.99"))
    	@ 26,058 PSay  alltrim(transform(SB5->B5_EXT3,"@E 999,999.99"))


    	@ 27,000 psay "|______________________________________________________________________|"
    	@ 28,000 psay "| Nro |   Data   |      Hora       |  Peso  | Apara  |     Operador    |"
    	@ 29,000 psay "|_Bob_|__________|_Inicio_|_Termin_|_Bobina_|__(Kg)__|_________________|"
    	@ 30,000 psay "|     |          |        |        |        |        |                 |"
    	@ 31,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 32,000 psay "|     |          |        |        |        |        |                 |"
    	@ 33,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 34,000 psay "|     |          |        |        |        |        |                 |"
    	@ 35,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 36,000 psay "|     |          |        |        |        |        |                 |"
    	@ 37,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 38,000 psay "|     |          |        |        |        |        |                 |"
    	@ 39,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 40,000 psay "|     |          |        |        |        |        |                 |"
    	@ 41,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 42,000 psay "|     |          |        |        |        |        |                 |"
    	@ 43,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 44,000 psay "|     |          |        |        |        |        |                 |"
    	@ 45,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 46,000 psay "|     |          |        |        |        |        |                 |"
    	@ 47,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 48,000 psay "|     |          |        |        |        |        |                 |"
    	@ 49,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 50,000 psay "|     |          |        |        |        |        |                 |"
    	@ 51,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 52,000 psay "|     |          |        |        |        |        |                 |"
    	@ 53,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 54,000 psay "|     |          |        |        |        |        |                 |"
    	@ 55,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 56,000 psay "|     |          |        |        |        |        |                 |"
    	@ 57,000 psay "|_____|__________|________|________|________|________|_________________|"
    	@ 58,000 psay "|     |          |        |        |        |        |                 |"
    	@ 59,000 psay "|_____|__________|________|________|________|________|_________________|"
  	//@ 60,000 psay "|     |          |        |        |        |        |                 |"
  	//@ 60,000 psay "|_____|__________|________|________|________|________|_________________|"
  	//@ 60,000 psay "|     |          |        |        |        |        |                 |"
  	//@ 61,000 psay "|_____|__________|________|________|________|________|_________________|"

	 Else

      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"
      nOP  := SC2->C2_NUM
      SC2->( DbSkip() )
      Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
         SC2->( DbSkip() )
      EndDo
      lFLAG := If( SC2->C2_NUM #nOP, .F., .T. )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)
      cNUMPI    := SC2->C2_NUM
      dEMISPI   := SC2->C2_EMISSAO
      cMAQPI    := Left(SB5->B5_MAQ,10)
      nQTDPI    := Round( SC2->C2_QUANT*100/(100+nPVarOp), 2 )
      cPRODPI   := SC2->C2_PRODUTO
      cCEMEPI   := SB5->B5_CEME
      nBOBLGPI  := SB5->B5_BOBLARG
      nLFILPI   := SB5->B5_LARGFIL
      nESPPI    := SB5->B5_ESPESS
      cSANLAMPI := SB5->B5_SANLAM2
      cTRATAMPI := SB5->B5_TRATAM
      cSLITEXPI := SB5->B5_SLITEXT
      nPTNEVEPI := SB5->B5_PTONEVE
      cMATRIZPI := SB5->B5_MATRIZ

      SC2->( DbGoTo( nREG ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
      @ 00,000 psay CHR(27)+CHR(38)+"l1O"+chr(27)+CHR(38)+"l26A"+chr(27)+CHR(38)+"l09D"+chr(27)+CHR(38)+"l72P"+chr(27)+"(12U"+chr(27)+"(s0p08h12v0s0b3T"
      @ 00,000 psay ""
      @ 00,000 psay " __________________________________________________"
      @ 00,056 psay If( ! lFLAG, "", " __________________________________________________" )
      @ 01,000 psay "|                                                  |"
      @ 01,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.        |"
      @ 02,056 psay If( ! lFLAG, "", "|RAVA Embalagens Industria e Comercio Ltda.        |" )
      @ 03,000 psay "|                                                  |"
      @ 03,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 04,000 psay "|       ORDEM DE PRODUCAO        Numero.: ________ |"
      @ 04,056 psay If( ! lFLAG, "", "|       ORDEM DE PRODUCAO        Numero.: ________ |" )
      @ 04,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 04,069 psay SC2->C2_NUM
      @ 04,136 psay If( ! lFLAG, "", cNUMPI )
      @ 05,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 05,000 psay "|                                                  |"
      @ 05,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 06,000 psay "|                                Data...: ________ |"
      @ 06,056 psay If( ! lFLAG, "", "|                                Data...: ________ |" )
      @ 06,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 06,068 psay SC2->C2_EMISSAO
      @ 06,135 psay If( ! lFLAG, "", dEMISPI )
      @ 06,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 06,014 psay "VIA PARA CORTE"
      @ 06,080 psay If( ! lFLAG, "", "VIA PARA EXTRUSAO" )
      @ 07,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 07,000 psay "|                                                  |"
      @ 07,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 08,000 psay "|                                Maquina: ________ |"
      @ 08,056 psay If( ! lFLAG, "", "|                                Maquina: ________ |" )
      @ 08,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 08,068 psay If( ! lFLAG, "", "********" )
      @ 08,136 psay If( ! lFLAG, "", cMAQPI )
      @ 09,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 09,000 psay "|                                                  |"
      @ 09,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 10,000 psay "|Prod.: ________ Quilos: _______ Qtd:__________ __ |"
      @ 10,056 psay If( ! lFLAG, "", "|Quilos: __________     Produto: ________/________ |" )
      @ 10,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 10,012 psay Left( SC2->C2_PRODUTO, 8 )
      @ 10,032 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 9999.99"
      If SC2->C2_UM == "MR"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  MR'
      ElseIf SC2->C2_UM == "FD"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  FD'
      Endif
      @ 10,080 psay If( ! lFLAG, "", Round(nQTDPI,0) )  Picture If( ! lFLAG, "", "@E 9999.99" )
      @ 10,109 psay If( ! lFLAG, "", Left(cPRODPI,8) + '  ' + Left( SC2->C2_PRODUTO, 8 ) )
      @ 11,000 psay Chr(27)+"(s0p08h12v0s0b3T"
      @ 11,000 psay "|                                                  |"
      @ 11,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 12,000 psay "|Descr.: _________________________________________ |"
      @ 12,056 psay If( ! lFLAG, "", "|Descr.: _________________________________________ |" )
      @ 12,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 12,012 psay SB5->B5_CEME
      @ 12,079 psay If( ! lFLAG, "", cCEMEPI )
      @ 13,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 13,000 psay "|                                                  |"
      @ 13,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 14,000 psay "|Larg. p/ Corte: ___________ Espessura: __________ |"
      @ 14,056 psay If( ! lFLAG, "", "|M.Prim: _________________________________________ |" )
      @ 14,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 14,040 psay SB5->B5_LARG Picture "999.99"
      @ 14,066 psay SB5->B5_ESPESS Picture "@E 9.9999"
      SG1->( DbSeek( xFILIAL("SG1") + cPRODPI, .T. ) )
      aMAT   := {}
      nQUANT := 0
      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cPRODPI
         If Left( SG1->G1_COMP, 4 ) == "MP01"
            SB1->( DbSeek( xFILIAL("SB1") + SG1->G1_COMP ) )
            Aadd( aMAT, { Left( SB1->B1_DESC, 8 ), SG1->G1_QUANT } )
            nQUANT := nQUANT + SG1->G1_QUANT
         EndIf
         SG1->( DbSkip() )
      EndDo
      cMAT  := ""
      nCONT := 1
      Do While nCONT <= Len( aMAT )
         cMAT := cMAT + AllTrim( aMAT[ nCONT, 1 ] ) + " " + Trans( aMAT[ nCONT, 2 ] / nQUANT * 100, "999%" ) + " "
         nCONT := nCONT + 1
      EndDo
      @ 14,095 psay If( ! lFLAG, "", If( ! Empty( cMAT ), cMAT, "NAO CADASTRADA" ) )
      @ 15,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 15,000 psay "|                                                  |"
      @ 15,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 16,000 psay "|Comp. p/ corte.: __________ Sanf/Lami: __________ |"
      @ 16,056 psay If( ! lFLAG, "", "|Larg. do Filme: ___________ Espessura: __________ |" )
      @ 16,000 psay chr(27)+"(s0p12h12v1s0b3T"

      /*@ 16,040 psay SB5->B5_COMPR Picture "999" ate 29/11/06 apenas essa linha*/
			/*If SB5->B5_COMPR3 == 'S'
				@ 16,040 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
			Else
				@ 16,040 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf*/
			/* Mudancas ate aqui 29/11/06 */

			If SB5->B5_DESCOM != 0
				@ 16,040 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
			Else
				@ 16,040 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf
			/* Mudancas ate aqui 13/12/06 */

      @ 16,069 psay SB5->B5_SANLAM
      @ 16,107 psay If( ! lFLAG, "", nLFILPI ) Picture If( ! lFLAG, "", "@E 999.99" )
      @ 16,134 psay If( ! lFLAG, "", nESPPI ) Picture If( ! lFLAG, "", "@E 9.9999" )
      @ 17,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 17,000 psay "|                                                  |"
      @ 17,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 18,000 psay "|Solda Fund/Late: __________ Qtd. bob.: __________ |"
      @ 18,056 psay If( ! lFLAG, "", "|Larg. da Bobina: __________ Sanf/Lami: __________ |" )
      @ 18,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 18,042 psay SB5->B5_SOLDFL
      @ 18,067 psay Round( SC2->C2_QTSEGUM*100/(100+nPVarOp), 2 ) / 100 Picture "999"
      @ 18,107 psay If( ! lFLAG, "", nBOBLGPI ) Picture If( ! lFLAG, "", "999.99" )
      @ 18,135 psay If( ! lFLAG, "", cSANLAMPI )
      @ 19,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 19,000 psay "|                                                  |"
      @ 19,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 20,000 psay "|Sanf. Fund/Late: __________ Qtd.p/pac: __________ |"
      @ 20,056 psay If( ! lFLAG, "", "|Tratamento.....: __________ Slit.....: __________ |" )
      @ 20,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 20,042 psay SB5->B5_SANFFL
      nDENSIDA := SB5->B5_DENSIDA
      @ 20,066 psay If( ! lFLAG, "", SB5->B5_QE1 ) Picture If( ! lFLAG, "", "9999" )
      @ 20,106 psay If( ! lFLAG, "", IIf(cTRATAMPI=='S','SIM','NAO') )
      @ 20,133 psay If( ! lFLAG, "", IIf(cSLITEXPI=='S','SIM','NAO') )
      @ 21,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 21,000 psay "|                                                  |"
      @ 21,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 22,000 psay "|Slit: _____________________ Peso p/MR: __________ |"
      @ 22,056 psay If( ! lFLAG, "", "|Metros p/100 kg: __________ Peso p/ Metro:_______ |" )
      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
      @ 22,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 22,035 psay IIf(SB5->B5_SLIT=='S','SIM','NAO')
      @ 22,065 psay SB1->B1_PESO / SB5->B5_QE2 * 1000  Picture "@E 9,999.999"
      @ 22,104 psay If( ! lFLAG, "", 100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) Picture If( ! lFLAG, "", "@E 999,999" )
      @ 22,134 psay If( ! lFLAG, "", 100/(100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) ) Picture If( ! lFLAG, "", "@E 999.999999" )
      @ 22,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 23,000 psay "|                                                  |"
      @ 23,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 24,056 psay "|Alt.  Pescoco: ____________ Matriz: _____________ |"
      @ 24,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 24,102 psay nPTNEVEPI Picture "999999.99"
      @ 24,133 psay Left(cMATRIZPI,12)
      @ 25,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 25,000 psay "|__________________________________________________|"
      @ 25,056 psay If( ! lFLAG, "", "|__________________________________________________|" )
      @ 26,000 psay "|     |      |           |          |     |        |"
      @ 26,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 27,000 psay "|No.de|      |    Hora   |          |Apara|        |"
      @ 27,056 psay If( ! lFLAG, "", "| No.|      |   Hora  | Bob. |  Bob. |Peso |       |" )
      @ 28,000 psay "|     |      |           |          |     |        |"
      @ 28,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 29,000 psay "| Bob.| Data |Inic.|Term.|Quantidade| Kg  |Operador|"
      @ 29,056 psay If( ! lFLAG, "", "|Bob.| Data |Inic|Term|  Km  |   Kg  |Metro|Operad.|" )
      @ 30,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 30,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 31,000 psay "|     |      |     |     |          |     |        |"
      @ 31,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 32,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 32,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 33,000 psay "|     |      |     |     |          |     |        |"
      @ 33,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 34,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 34,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 35,000 psay "|     |      |     |     |          |     |        |"
      @ 35,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 36,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 36,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 37,000 psay "|     |      |     |     |          |     |        |"
      @ 37,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 38,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 38,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 39,000 psay "|     |      |     |     |          |     |        |"
      @ 39,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 40,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 40,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 41,000 psay "|     |      |     |     |          |     |        |"
      @ 41,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 42,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 42,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 43,000 psay "|     |      |     |     |          |     |        |"
      @ 43,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 44,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 44,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 45,000 psay "|     |      |     |     |          |     |        |"
      @ 45,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 46,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 46,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 47,000 psay "|     |      |     |     |          |     |        |"
      @ 47,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 48,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 48,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 49,000 psay "|     |      |     |     |          |     |        |"
      @ 49,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 50,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 50,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 51,000 psay "|     |      |     |     |          |     |        |"
      @ 51,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 52,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 52,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 53,000 psay "|     |      |     |     |          |     |        |"
      @ 53,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 54,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 54,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 55,000 psay "|     |      |     |     |          |     |        |"
      @ 55,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 56,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 56,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 57,000 psay "|     |      |     |     |          |     |        |"
      @ 57,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 58,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 58,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 59,000 psay "|     |      |     |     |          |     |        |"
      @ 59,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 60,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 60,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 61,000 psay "|Observacoes:                                      |"
      @ 61,056 psay If( ! lFLAG, "",  "|Observacoes:                                      |" )
      @ 61,015 psay SC2->C2_OBS
      @ 62,000 psay "|__________________________________________________|"
      @ 62,056 psay If( ! lFLAG, "",  "|                                                  |" )
      @ 63,000 psay "|                                                  |"
      @ 63,056 psay If( ! lFLAG, "",  "|Apara KG:______  Apara KG:_______  Apara KG:______|" )
      @ 64,000 psay "|__________________________________________________|"
      @ 64,056 psay If( ! lFLAG, "",  "|__________________________________________________|" )

    //"&l0O&l2A&l07D&l72P(12U(s0p12h12v0s0b3T

      @ 00,000 psay CHR(27)+CHR(38)+"l0O"+CHR(27)+CHR(38)+"12A"+CHR(27)+CHR(38)+"107D"+CHR(27)+CHR(38)+"l72P(12U(s0p12h12v0s0b3T"

   EndIf

   ETQ()

EndDo

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão das Etiquetas.                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
***************

Static Function ETQ()

***************

nLIN    := 1
nNUMETQ := 0
nCTRL   := 0
SB5->( DbGoto( nREGPA ) )
If mv_par03 == 1
   nNUMETQ := Round( ( SC2->C2_QUANT*100/100+nPVarOp) / 100,0 )
Else
   nNUMETQ := Round( nQTDPI/100,0 )
Endif

For I := 1 To nNUMETQ
//         10        20        30        40        50        60        70        80
//01234567890123456789012345678901234567890123456789012345678901234567890123456789
   @ nLIN,000 PSay Padc("R A V A    E M B A L A G E N S",80)
   @ nLIN,060 pSay cCodEtiq
   @ nLIN+2,005 PSay "N§ da O.P.......:________    Peso(kg)....:________    Bobina N§:_______"
   @ nLIN+2,024 PSay SC2->C2_NUM
   @ nLIN+2,071 PSay StrZero(I,2)
   @ nLIN+3,005 PSay "Desc. do Produto:______________________________________________________"
   If mv_par03 == 1
      //@ nLIN+3,024 PSay Left(SB5->B5_CEME,60)
	 @ nLIN+3,024 PSay Left(SB1->B1_DESC,60) //Esmerino Neto (solicitacao de Lindenberg) em 16/02/06
   Else
      @ nLIN+3,024 PSay Left(cCEMEPI,60)
   Endif

   @ nLIN+4,005 PSay "Larg. do Filme..:________    Compr. Corte:________    Espessura:_______"
   If mv_par03 == 1
      @ nLIN+4,024 PSay SB5->B5_LARGFIL Picture "@E 999.99"

			/*@ nLIN+4,049 PSay SB5->B5_COMPR Picture "@E 999.99" ate 2911/06 apenas essa linha*/
			/*If SB5->B5_COMPR3 == 'S'
				@ nLIN+4,049 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
			Else
				@ nLIN+4,049 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf*/
			/* Mudancas ate aqui 29/11/06 */

			If SB5->B5_DESCOM != 0
				@ nLIN+4,049 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
			Else
				@ nLIN+4,049 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf
			/* Mudancas ate aqui 13/12/06 */

      @ nLIN+4,071 psay SB5->B5_ESPESS Picture "@E 9.9999"
   Else
      @ nLIN+4,024 PSay nLFILPI Picture "@E 999.99"

			//@ nLIN+4,049 PSay SB5->B5_COMPR Picture "@E 999.99"
			/*@ nLIN+4,049 PSay SB5->B5_COMPR Picture "@E 999.99" ate 2911/06 apenas essa linha*/
			/*If SB5->B5_COMPR3 == 'S'
				@ nLIN+4,049 psay SB5->B5_COMPR2 Picture "@E 9999999.99"
			Else
				@ nLIN+4,049 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf*/
			/* Mudancas ate aqui 29/11/06 */

			If SB5->B5_DESCOM != 0
				@ nLIN+4,049 psay SB5->B5_COMPR + SB5->B5_DESCOM Picture "@E 9999999.99"
			Else
				@ nLIN+4,049 psay SB5->B5_COMPR Picture "@E 9999999.99"
			EndIf
			/* Mudancas ate aqui 13/12/06 */

      @ nLIN+4,071 psay nESPPI Picture "@E 9.9999"
   Endif

   @ nLIN+5,005 PSay "Tratamento......:________    Operador:____________    Data: ___/___/___"
   If mv_par03 == 1
      @ nLIN+5,024 Psay IIf(SB5->B5_TRATAM=='S','SIM','NAO')
   Else
      @ nLIN+5,024 Psay IIf(cTRATAMPI=='S','SIM','NAO')
   Endif

   @ nLIN+7,005 PSay 'Cliente: ' + IIf( Empty( MV_PAR04 ), '...Não Informado!', AllTrim( MV_PAR04 ) )
   nLIN := nLIN + 9
   If nLIN >= 64
      nLIN := 1
      If mv_par03 == 2  .And. I # nNUMETQ
         Eject
      Endif
   Endif
	If I == nNUMETQ .and. nCTRL == 0
   	I     := 0
   	nCTRL := 1
	EndIf
Next

nOP := SC2->C2_NUM
Do While SC2->C2_NUM == nOP
   SC2->( DbSkip() )
EndDo
nREG := SC2->( RecNo() )
IncRegua()

//Pular pagina
If ! SC2->( Eof() ) .and. SC2->C2_NUM <= MV_PAR02
//   Eject
Endif

Return

***************

Static Function atualiza(nDensd, cCdPI, cCdPA)

***************

Local nPeso, nIndex
Local cAlias
//cAlias := Alias()
//nIndex := Indexord()

DbSelectArea("SB5")
SB5->( DbSetOrder( 1 ) )
If SB5->( DbSeek( xFilial("SB5") + cCdPA, .T. ) )
	If SB5->( RecLock("SB5", .F.) )
		SB5->B5_DENSIDA := nDensD
		SB5->( MsUnlock() )
		SB5->( DbCommit() )
    nPeso := (SB5->B5_COMPR * SB5->B5_ESPESS * SB5->B5_LARG * SB5->B5_QE2 * nDensd) / 1000
		If SB5->( DbSeek( xFilial("SB5") + cCdPI, .T. ) )
			If SB5->( RecLock("SB5", .F.) )
				SB5->B5_DENSIDA := nDensD
				SB5->( MsUnlock() )
				SB5->( DbCommit() )
				/*Peso do PI - Na extrutra*/
				DbSelectArea("SG1")
				SG1->( DbSetOrder( 1 ) )
				If SG1->( DbSeek( xFilial("SG1") + cCdPA, .F. ))    //COMP
					If SG1->( DbSeek( xFilial("SG1") + SG1->G1_COD + cCdPI, .F. ) )
					//If SG1->( DbSeek( xFilial("SG1") + cCdPA + cCdPI, .F. ) )
						If SG1->( RecLock("SG1", .F.) )
							SG1->G1_QUANT := nPeso
							SG1->( MsUnlock() )
							SG1->( DbCommit() )
						Else
							MsgBox("Nao foi possivel travar o registro: (SG1) " + cCdPI)
						EndIf
					Else
						MsgBox(cCdPI + "nao foi encontrado! (SG1)")
					EndIf
				Else
					MsgBox(cCdPA + "nao possui extrutura! (SG1)")
				EndIf
				/*Fim*/
				/*Peso do PA - No cadastro*/
				DbSelectArea("SB1")
				SB1->( DbSetOrder( 1 ) )
				If SB1->( DbSeek( xFilial("SB1") + cCdPA, .T. ) )
					If SB1->( RecLock("SB1", .F.) )
						SB1->B1_PESO := nPeso
						SB1->B1_CONV := 1 / nPeso
						SB1->( MsUnlock() )
						SB1->( DbCommit() )
					Else
						MsgBox("Nao foi possivel travar o registro: (SB1) " + cCdPA)
					EndIf
				Else
					MsgBox(cCdPA + "nao foi encontrado! (SB1)")
				EndIf
				/*Fim*/
			Else
				MsgBox("Nao foi possivel travar o registro: (SB5) " + cCdPI)
			endif
		Else
			MsgBox(cCdPI + "nao foi encontrado! (SB5) ")
		EndIf
	Else
		MsgBox("Nao foi possivel travar o registro: (SB5) " + cCdPI)
	EndIf
Else
	MsgBox(cCdPA + "nao foi encontrado! (SB5)")
EndIf
//DbSelectArea( cAlias )
//DbSetOrder( nIndex )

Return Nil



