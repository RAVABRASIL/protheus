#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDescricao ³ Relatorio gerencial da cobranca - vencidos                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cobranca - Rava Embalagens                         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COBR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Gerencial da Cobranca - Vencidos"
Local cPict          := ""
Local titulo       := "Gerencial - Vencidos por "
Local nLin         := 80
/*
local Cabec1 := "DE/A |         7 Dias        |        15 Dias        |        30 Dias        |        60 Dias        |        90 Dias        |       120 Dias        |       150 Dias        |       180 Dias        |       365 Dias        |       730 Dias        |      +730 Dias        |"
local Cabec2 := "     |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |AReceber Vencidos   %  |"
//
//                     9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99
//               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7
//                                                                                                    1                                                                                                   2
*/
local cabec1       := "DE/ATE           |     7 Dias      |    15 Dias      |    30 Dias      |    60 Dias      |    90 Dias      |   120 Dias      |    150 Dias     |   180 Dias      |   365 Dias      |   540 Dias      |  +730 Dias      |"
//                     +730 | A Receber | 999,999.99"
//                          | Vencidos/%| 999,999.99 99.99
//                              9,999.99 99.99  9,999.99 99.99
//                     0123456789012345678901234567890123456789012345678901234567890123456
//                               1         2         3         4         5         6
//                     12 123456 12 1234567890123456789012345678901234567890 123456789012345 123456789012345 123456789012345 1234567890123456789012345678901234567890 1234567890123456789012345 12345678901234567890 12345678
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
Local Cabec2       := ""

Local imprime      := .T.
Local aOrd := {"Natureza","Representante","Portador"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 270
Private tamanho          := "G"
Private nomeprog         := "COBR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "COBR01"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COBR01" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cComple1 :=Space(79)
PRIVATE cComple2 :=Space(79)
PRIVATE cComple3 :=Space(79)

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem := aReturn[8]
If nOrdem == 1 //Natureza
	Private   cOrdem    := "Natureza"
	Titulo     += "Natureza"
	Private	cFilOrdem  := "E1_NATUREZ"
	Private	cFilt      := "ED_CODIGO"
	Private	cDesc      := "ED_DESCRIC"
	Private	cAliasProc := "SED"
	Private	cCod1      := mv_par01
	Private	cCod2      := mv_par02
ElseIf nOrdem == 2 //Representante
	Private   cOrdem    := "Representante"
	Titulo     += "Representante"
	Private	cFilOrdem  := "E1_VEND1"
	Private	cFilt      := "A3_COD"
	Private	cDesc      := "A3_NOME"
	Private	cAliasProc := "SA3"
	Private	cCod1      := Subst(mv_par01,1,6)
	Private	cCod2      := Subst(mv_par02,1,6)
ElseIf nOrdem == 3 //Portador
	Private	cOrdem     := "Portador"
	Titulo     += "Portador"
	Private	cFilOrdem  := "E1_PORTADO"
	Private	cFilt      := "A6_COD"
	Private	cDesc      := "A6_NOME"
	Private	cAliasproc := "SA6"
	Private	cCod1      := Subst(mv_par01,1,3)
	Private	cCod2      := Subst(mv_par02,1,3)
Endif


//Se for analitico imprime uma pagina por registro
If mv_par03 == 1
	
	Dbselectarea(cAliasProc)
	dbgotop()
	Dbseek(xFilial()+cCod1,.t.)
	cTeste := ''
	While !eof() .And. &cFilt <= cCod2
		
		If cTeste == &cFilt
			dbskip()
			Loop
		Endif
		If nOrdem == 2 //Representante
			//Acumulado Geral
			Dbselectarea("ZZ9")
			cCond := " SELECT SUM(ZZ9_VALPAG) ACUMULADO"
			cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("ZZ9")+" ZZ9"
			cCond += " WHERE A1_VEND = '"+&(cAliasProc+"->"+cFilt)+"' "
			cCond += "   AND A1_COD+A1_LOJA = ZZ9_CODIGO+ZZ9_LOJA "
			cCond += "   AND ZZ9.D_E_L_E_T_ = ''"
			cCond += "   AND SA1.D_E_L_E_T_ = ''"
			
			TCQUERY cCond ALIAS ZZ9N NEW
			
			Dbselectarea("ZZ9N")
			nAcumGer := ZZ9N->ACUMULADO
			dbclosearea()			
		Else
			nAcumGer := 0
		Endif
		
		Dbselectarea(cAliasProc)			
		cTeste := &cFilt
		dbSelectArea(cString)
		dbSetOrder(1)
		SetRegua(12)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//Inicia impressao
		@ nlin, 000 pSay cOrdem+": "+&(cAliasProc+"->"+cFilt)+" - "+&(cAliasProc+"->"+cDesc)
		nlin := nlin + 2
		
		For i := 1 to 12
			
			IncRegua()

			@ 10,10 Say "                                "
			@ 10,10 Say &(cAliasProc+"->"+cFilt)+" - "+Alltrim(Str(i))+"/12"
			
			iF i == 1
				dVencIni := dDatabase - 1
				cImp := "1"
			ElseIf i == 2
				dVencIni := dDatabase - 7
				cImp := "7"
			ElseIf i == 3
				dVencIni := dDatabase - 15
				cImp := "15"
			ElseIf i == 4
				dVencIni := dDatabase - 30
				cImp := "30"
			ElseIf i == 5
				dVencIni := dDatabase - 60
				cImp := "60"
			ElseIf i == 6
				dVencIni := dDatabase - 90
				cImp := "90"
			ElseIf i == 7
				dVencIni := dDatabase - 120
				cImp := "120"
			ElseIf i == 8
				dVencIni := dDatabase - 150
				cImp := "150"
			ElseIf i == 9
				dVencIni := dDatabase - 180
				cImp := "180"
			ElseIf i == 10
				dVencIni := dDatabase - 365
				cImp := "365"
			ElseIf i == 11
				dVencIni := dDatabase - 540//730
				cImp := "540"
			ElseIf i == 12 //mais de 730 dias
				dVencIni := dDatabase - 730
				cImp := "+730"
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o cancelamento pelo usuario...                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@ nlin, 000 pSay cImp
			@ nlin, 005 pSay "| A Receber |"
			nCol1     := 19  //A receber
			aVencidos := {}
			For j := 1 To 11
				If j == 1
					dVencFim := dDatabase - 7
				Elseif j == 2
					dVencFim := dDatabase - 15
				Elseif j == 3
					dVencFim := dDatabase - 30
				Elseif j == 4
					dVencFim := dDatabase - 60
				Elseif j == 5
					dVencFim := dDatabase - 90
				Elseif j == 6
					dVencFim := dDatabase - 120
				Elseif j == 7
					dVencFim := dDatabase - 150
				Elseif j == 8
					dVencFim := dDatabase - 180
				Elseif j == 9
					dVencFim := dDatabase - 365
				Elseif j == 10
					dVencFim := dDatabase - 540//730
				Elseif j == 11 //Mais de 730 dias
					dVencFim := ctod('01/01/80')
				Endif
				
				//A receber
				Dbselectarea("SE1")
				cCond := " SELECT SUM(E1_VALOR) AS AREC"
				cCond += " FROM "+RETSQLNAME("SE1")
				cCond += " WHERE E1_VENCTO BETWEEN '"+DtoS(dVencFim)+"' AND '"+DtoS(dVencIni)+"' "
				cCond += "   AND "+cFilOrdem+" = '"+&(cAliasProc+"->"+cFilt)+"' "
				cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "				
				cCond += "   AND E1_PREFIXO <> 'COM' "
				cCond += "   AND E1_PREFIXO <> 'CHD' "
				cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
				cCond += "   AND D_E_L_E_T_ = '' "
				
				TCQUERY cCond ALIAS SE1N NEW
				TCSetField("SE1N", "E1_VALOR"  ,"N",14,2)
				
				Dbselectarea("SE1N")
				naReceber := SE1N->AREC/1000
				dbclosearea()
				
				//Vencidos
				Dbselectarea("SE1")
				cCond := " SELECT SUM(E1_SALDO) AS SALDO"
				cCond += " FROM "+RETSQLNAME("SE1")
				cCond += " WHERE E1_SALDO > 0 "
				cCond += "   AND E1_VENCTO BETWEEN '"+DtoS(dVencFim)+"' AND '"+DtoS(dVencIni)+"' "
				cCond += "   AND "+cFilOrdem+" = '"+&(cAliasProc+"->"+cFilt)+"' "
				cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
				cCond += "   AND E1_PREFIXO <> 'COM' " //CHEQUES A RECEBER	//Mudar prefixo
				cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
				cCond += "   AND D_E_L_E_T_ = '' "
				
				TCQUERY cCond ALIAS SE1N NEW
				TCSetField("SE1N", "E1_SALDO"  ,"N",14,2)
				
				Dbselectarea("SE1N")
				nSaldo := SE1N->SALDO/1000
				dbclosearea()
				
				//Adiciona a coluna nsaldo
				AAdd( aVencidos,{j, naReceber, nSaldo } )
				
				//IMPRIME VALORES
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o cancelamento pelo usuario...                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				//"DE/A             |     7 Dias      |    15 Dias      |    30 Dias      |    60 Dias      |    90 Dias      |   120 Dias      |    150 Dias     |   180 Dias      |   365 Dias      |   730 Dias      |  +730 Dias      |"
				// +730 | A Receber | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      |"
				//      | Vencidos/%| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99|"
				// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				//           1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
				
				@ nlin, nCol1 pSay naReceber Picture "@E 999,999.99"
				nCol1 += 18
			Next
			
			nCol2 := 19 //Vencidos
			nCol3 := 30 //Percentual
			nlin ++
			@ nlin,005 pSay "| Vencidos/%|"
			For k := 1 To Len(aVencidos)
				@ nlin, nCol2 pSay aVencidos[k,3] Picture "@E 999,999.99" //Vencidos
				@ nlin, nCol3 pSay Round((aVencidos[k,3]/aVencidos[k,2])*100,2) Picture "@E 99.99"
				nCol2 += 18
				nCol3 += 18
			Next
			nlin ++
			@ nlin, 000 pSay Replicate("-",220)
			nlin ++
		Next
		nlin := 80
		Dbselectarea(cAliasProc)
		dbskip()
	End
Endif
//TOTAL GERAL
dbSelectArea(cString)
dbSetOrder(1)
SetRegua(12)

nlin := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

//Inicia impressao
@ nlin, 000 pSay "TOTAL GERAL"
nlin := nlin + 2

//Acumulado Geral
Dbselectarea("ZZ9")
cCond := " SELECT SUM(ZZ9_VALPAG) ACUMULADO"
cCond += " FROM "+RetSqlname("ZZ9")+" ZZ9"
cCond += " WHERE D_E_L_E_T_ = ''"

TCQUERY cCond ALIAS ZZ9N NEW

Dbselectarea("ZZ9N")
nAcumGer := ZZ9N->ACUMULADO
dbclosearea()

For i := 1 to 12
	
	IncRegua()

	@ 10,10 Say "                                    "	
	@ 10,10 Say "Total Geral - "+Alltrim(Str(i))+"/12"	

	iF i == 1
		dVencIni := dDatabase - 1
		cImp := "1"
	ElseIf i == 2
		dVencIni := dDatabase - 7
		cImp := "7"
	ElseIf i == 3
		dVencIni := dDatabase - 15
		cImp := "15"
	ElseIf i == 4
		dVencIni := dDatabase - 30
		cImp := "30"
	ElseIf i == 5
		dVencIni := dDatabase - 60
		cImp := "60"
	ElseIf i == 6
		dVencIni := dDatabase - 90
		cImp := "90"             
	ElseIf i == 7
		dVencIni := dDatabase - 120
		cImp := "120"
	ElseIf i == 8
		dVencIni := dDatabase - 150
		cImp := "150"
	ElseIf i == 9
		dVencIni := dDatabase - 180
		cImp := "180"
	ElseIf i == 10
		dVencIni := dDatabase - 365
		cImp := "365"
	ElseIf i == 11
		dVencIni := dDatabase - 540//730
		cImp := "540"
	ElseIf i == 12 //mais de 730 dias
		dVencIni := dDatabase - 730
		cImp := "+730"
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@ nlin, 000 pSay cImp
	@ nlin, 005 pSay "| A Receber |"
	nCol1     := 19  //A receber
	aVencidos := {}
	For j := 1 To 11
		If j == 1
			dVencFim := dDatabase - 7
		Elseif j == 2
			dVencFim := dDatabase - 15
		Elseif j == 3
			dVencFim := dDatabase - 30
		Elseif j == 4
			dVencFim := dDatabase - 60
		Elseif j == 5
			dVencFim := dDatabase - 90
		Elseif j == 6
			dVencFim := dDatabase - 120
		Elseif j == 7
			dVencFim := dDatabase - 150
		Elseif j == 8
			dVencFim := dDatabase - 180
		Elseif j == 9
			dVencFim := dDatabase - 365
		Elseif j == 10
			dVencFim := dDatabase - 540//730
		Elseif j == 11 //Mais de 730 dias
			dVencFim := ctod('01/01/80')
		Endif

		//A receber
		Dbselectarea("SE1")
		cCond := " SELECT SUM(E1_VALOR) AS AREC"
		cCond += " FROM "+RETSQLNAME("SE1")
		cCond += " WHERE E1_VENCTO BETWEEN '"+DtoS(dVencFim)+"' AND '"+DtoS(dVencIni)+"' "
		cCond += "   AND "+cFilOrdem+" BETWEEN '"+cCod1+"' AND '"+cCod2+"' "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "				
		cCond += "   AND E1_PREFIXO <> 'CHD' "  //Mudar prefixo
		cCond += "   AND E1_PREFIXO <> 'COM' "	//Mudar prefixo	
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND D_E_L_E_T_ = '' "
		
		TCQUERY cCond ALIAS SE1N NEW
		TCSetField("SE1N", "E1_VALOR"  ,"N",14,2)
		
		Dbselectarea("SE1N")
		naReceber := SE1N->AREC/1000
		dbclosearea()
		
		//Vencidos
		Dbselectarea("SE1")
		cCond := " SELECT SUM(E1_SALDO) AS SALDO"
		cCond += " FROM "+RETSQLNAME("SE1")
		cCond += " WHERE E1_SALDO > 0 "
		cCond += "   AND E1_VENCTO BETWEEN '"+DtoS(dVencFim)+"' AND '"+DtoS(dVencIni)+"' "
		cCond += "   AND "+cFilOrdem+" BETWEEN '"+cCod1+"' AND '"+cCod2+"' "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //CHEQUES A RECEBER	//Mudar Prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND D_E_L_E_T_ = '' "
		
		TCQUERY cCond ALIAS SE1N NEW
		TCSetField("SE1N", "E1_SALDO"  ,"N",14,2)
		
		Dbselectarea("SE1N")
		nSaldo := SE1N->SALDO/1000
		dbclosearea()
		
		If j == 11 //+ 730 dias
			naReceber += nAcumGer
		Endif
		
		//Adiciona a coluna nsaldo
		AAdd( aVencidos,{j, naReceber, nSaldo } )
		
		//IMPRIME VALORES
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//"DE/A             |     7 Dias      |    15 Dias      |    30 Dias      |    60 Dias      |    90 Dias      |   120 Dias      |    150 Dias     |   180 Dias      |   365 Dias      |   730 Dias      |  +730 Dias      |"
		// +730 | A Receber | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      | 999,999.99      |"
		//      | Vencidos/%| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99| 999,999.99 99.99|"
		// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//           1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
		
		If j == 11 //+ 730 dias
			@ nlin, nCol1-3 pSay naReceber Picture "@E 99,999,999.99"
		Else
			@ nlin, nCol1 pSay naReceber Picture "@E 999,999.99"
		Endif	
		nCol1 += 18
	Next
	
	nCol2 := 19 //Vencidos
	nCol3 := 30 //Percentual
	nlin ++
	@ nlin,005 pSay "| Vencidos/%|"
	For k := 1 To Len(aVencidos)
		
		@ nlin, nCol2 pSay aVencidos[k,3] Picture "@E 999,999.99" //Vencidos
		@ nlin, nCol3 pSay Round((aVencidos[k,3]/aVencidos[k,2])*100,2) Picture "@E 99.99"
		
		nCol2 += 18
		nCol3 += 18
	Next
	nlin ++
	@ nlin, 000 pSay Replicate("-",220)
	nlin ++
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidPerg³Autor ³ Silvano da Silva Araujo   ³Data³ 25/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica perguntas, incluindo-as caso nao existam.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SX1                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

Local _sAlias  := Alias()
Local aRegs    := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Do codigo        :","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate o Codigo     :","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Tipo             :","","","mv_ch3","N",01,0,0,"C","","mv_par03","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)
Return


//"DE/A |         7 Dias        |        15 Dias        |        30 Dias        |        60 Dias        |        90 Dias        |       120 Dias        |       150 Dias        |       180 Dias        |       365 Dias        |       730 Dias        |      +730 Dias        |
//"+730 |
//       9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99 9,999.99 9,999.99 99.99
// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7
//                                                                                                    1                                                                                                   2
