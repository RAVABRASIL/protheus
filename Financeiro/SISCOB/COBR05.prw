#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDescricao ³ Relatorio gerencial - Limite de credito                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cobranca - Rava Embalagens                         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COBR05()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Limite de credito"
Local cPict        := ""
Local titulo       := "Avaliacao do Cliente"
Local nLin         := 80
local cabec1       := "Representante             |     Vencidos      A Vencer         Pagos|      Cheque Devolvido     |     Limite   Media        Media"
Local Cabec2       := "Cliente                   |                                         |     Principal        Saldo| de Credito  Atraso       Compra"
//                     1234567890123456789012345  99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99  999,999.99 999,999 99,999,999.99
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8        9          0         1         2         3
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "COBR05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "COBR05"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COBR05" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SA3"

dbSelectArea("SA3")
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

Processa( { || ProcRel(Cabec1,Cabec2,Titulo,nLin) } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBR05    ºAutor  ³Microsiga           º Data ³  06/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcRel(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem := aReturn[8]

//cria aqruivo de trabaho
For j := 1 To 2
	
	If j == 1
		cQry := "SELECT Count(A3_COD) REGISTROS"
	Else
		cQry := "SELECT A3_COD, A3_NOME, A1_COD, A1_LOJA, A1_NOME, A1_PESSOA, A1_LC, A1_MATR"
	Endif
	cQry += " FROM "+RetSqlName("SA3")+" SA3,"+RetSqlName("SA1")+" SA1"
	cQry += " WHERE A3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQry += "   AND A3_ATIVO = 'S'"
	cQry += "   AND A3_COD = A1_VEND"
	cQry += "   AND A1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	If mv_par05 == 1 //Pessoa Fisica
		cQry += "   AND A1_PESSOA = 'F' "
	Elseif mv_par05 == 2 //Pessoa Juridica
		cQry += "   AND A1_PESSOA = 'J' "
	Endif
	cQry += "   AND SA1.D_E_L_E_T_ = ''"
	cQry += "   AND SA3.D_E_L_E_T_ = ''"
	If j == 2
		cQry += "   ORDER BY A3_COD,A1_COD,A1_LOJA "
	Endif
	
	TCQUERY cQry ALIAS TMP NEW
	
	Dbselectarea("TMP")
	
	If j == 1
		nRegTot := TMP->REGISTROS
		dbclosearea()
	Endif
Next

TcSetField( "TMP", "A1_LC"   , "N", 12, 2 )
TcSetField( "TMP", "A1_MATR" , "N", 7, 0 )

Dbselectarea("TMP")
dbgotop()
ProcRegua(nRegTot)

nTotVenc := 0
nTotaRec := 0
nTotPago := 0
nTotChdP := 0
nTotChdS := 0

aDados := {}
n := 0
While !eof()
	n ++
	
	INCProc("Processando :"+Alltrim(Str(n))+" de "+Alltrim(Str(nRegTot)))
	
	//VENCIDOS
	cCond := " SELECT SUM(E1_SALDO) VENCIDOS"
	cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
	cCond += " WHERE E1_CLIENTE+E1_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cCond += "   AND E1_SALDO > 0"
	cCond += "   AND E1_VENCREA < '"+dTos(dDatabase)+"' "
	cCond += "   AND E1_TIPO IN ('NF','CD','CC','DP','CH','R$') "
	cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
	cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
	cCond += "   AND SE1.D_E_L_E_T_ = ''"
	cCond += "   AND SA1.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	nVencido := SE1N->VENCIDOS
	dbclosearea()
	
	//A RECEBER
	cCond := " SELECT SUM(E1_SALDO) ARECEBER"
	cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
	cCond += " WHERE E1_CLIENTE+E1_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cCond += "   AND E1_SALDO > 0"
	cCond += "   AND E1_VENCREA >= '"+dTos(dDatabase)+"' "
	cCond += "   AND E1_TIPO IN ('NF','CD','CC','DP','CH','R$') "
	cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
	//		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
	cCond += "   AND SE1.D_E_L_E_T_ = ''"
	cCond += "   AND SA1.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	nAReceber:= SE1N->ARECEBER
	dbclosearea()
	
	//PAGOS
	cCond := " SELECT SUM(E1_VALOR-E1_SALDO) PAGOS"
	cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
	cCond += " WHERE E1_CLIENTE+E1_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cCond += "   AND E1_TIPO IN ('NF','CD','CC','DP','CH','R$') "
	cCond += "   AND E1_PREFIXO <> 'CHD' " //Mudar prefixo
	cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
	cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
	cCond += "   AND E1_ORIGEM <> 'FINA280' " //FATURAS A RECEBER
	cCond += "   AND SE1.D_E_L_E_T_ = ''"
	cCond += "   AND SA1.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	nPagos := SE1N->PAGOS
	dbclosearea()
	
	//CHD PRINCIPAL
	cCond := " SELECT SUM(E1_VALOR) CHDPRIN"
	cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
	cCond += " WHERE E1_CLIENTE+E1_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cCond += "   AND E1_TIPO IN ('NF','CD','CC','DP','CH','R$') "
	cCond += "   AND E1_PREFIXO = 'CHD' " //Mudar prefixo
	cCond += "   AND SE1.D_E_L_E_T_ = ''"
	cCond += "   AND SA1.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	nChdPrin := SE1N->CHDPRIN
	dbclosearea()
	
	//CHD SALDO
	cCond := " SELECT SUM(E1_VALOR) CHDSALDO"
	cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
	cCond += " WHERE E1_CLIENTE+E1_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cCond += "   AND E1_SALDO > 0"
	cCond += "   AND E1_TIPO IN ('NF','CD','CC','DP','CH','R$') "
	cCond += "   AND E1_PREFIXO = 'CHD' " //Mudar prefixo
	cCond += "   AND SE1.D_E_L_E_T_ = ''"
	cCond += "   AND SA1.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	nChdSaldo:= SE1N->CHDSALDO
	dbclosearea()
	
	//FATURAMENTO
	cCond := " SELECT SUM(F2_VALBRUT) VALBRUT, COUNT(F2_VALBRUT) NUM_COM"
	cCond += " FROM "+RetSqlname("SF2")+" SF2"
	cCond += " WHERE F2_CLIENTE+F2_LOJA = '"+TMP->A1_COD+TMP->A1_LOJA+"' "
	cCond += "   AND F2_TIPO  =  'N' "		
	cCond += "   AND F2_DUPL <> '' "	
	cCond += "   AND SF2.D_E_L_E_T_ = ''"
	
	TCQUERY cCond ALIAS SF2N NEW
	
	Dbselectarea("SF2N")
	nValComp := SF2N->VALBRUT
	nNumComp := SF2N->NUM_COM
	dbclosearea()

	//ACUMULADO
	nPagosAc  := 0
	nChdAc    := 0
	nMedAtrAc := 0
	nMedComAc := 0
	Dbselectarea("ZZ9")
	Dbsetorder(1)
	If Dbseek(xFilial()+TMP->A1_COD+TMP->A1_LOJA)
		nPagosAc  := ZZ9_VALPAG
		nChdAc    := ZZ9_VALCHD
	Endif
	
	nMedComAc := Round((ZZ9_VALNOT+nValComp)/(ZZ9_NUMNOT+nNumComp),2)
	
	If mv_par07 == 1 .And. nVencido == 0//so se tiver titulo vencido
		Dbselectarea("TMP")
		dbskip()
		Loop	
	Endif

	AADD(aDados,{TMP->A3_COD, TMP->A3_NOME, TMP->A1_COD,TMP->A1_LOJA,TMP->A1_NOME,nVencido, naReceber, nPagos+nPagosAC,nChdPrin+nChdAC,nChdSaldo,TMP->A1_LC,TMP->A1_MATR,nMedComAc})
	
	Dbselectarea("TMP")
	dbskip()
End

dbclosearea()

//IMPRIME DADOS

nTotVenc := 0
nTotaRec := 0
nTotPago := 0
nTotChdP := 0
nTotChdS := 0
nTotMedCom := 0
cVend    := ''

If mv_par06 == 1 //Vencidos
	aSort(aDados,,,{|x,y| X[1]+STR(9999999999999-X[6]) < Y[1]+STR(9999999999999-Y[6]) })
ElseIf mv_par06 == 2 //Limite Credito
	aSort(aDados,,,{|x,y| X[1]+STR(9999999999999-X[11]) < Y[1]+STR(9999999999999-Y[11]) })
ElseIf mv_par06 == 3 //A vencer
	aSort(aDados,,,{|x,y| X[1]+STR(9999999999999-X[7]) < Y[1]+STR(9999999999999-Y[7]) })
ElseIf mv_par06 == 4 //SAldo CHD
	aSort(aDados,,,{|x,y| X[1]+STR(9999999999999-X[10]) < Y[1]+STR(9999999999999-Y[10]) })
ElseIf mv_par06 == 5 //Principal CHD
	aSort(aDados,,,{|x,y| X[1]+STR(9999999999999-X[9]) < Y[1]+STR(9999999999999-Y[9]) })
Endif

For i := 1 To Len(aDados)
	
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
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If cVend <> aDados[i,1]
		If !Empty(cVend)
			nlin ++
			@ nlin,000 pSay "Total Vendedor: "
			@ nlin,026 pSay nVencVen        Picture "@E 999,999,999.99"
			@ nlin,040 pSay naRecVen        Picture "@E 999,999,999.99"
			@ nlin,054 pSay nPagosVen       Picture "@E 999,999,999.99"
			@ nlin,068 pSay nChdPVen        Picture "@E 999,999,999.99"
			@ nlin,082 pSay nChdSVen        Picture "@E 999,999,999.99"
			@ nlin,116 pSay nMedComVen      Picture "@E 999,999,999.99"			
			nlin ++
			@ nlin,000 pSay Replicate ("-",132)
			nlin++
			
		Endif
		cVend := aDados[i,1]
		@ nlin,000 pSay aDados[i,1]+" - "+aDados[i,3]
		nlin := nlin + 2
		
		nVencVen   := 0
		naRecVen   := 0
		nPagosVen  := 0
		nChdPVen   := 0
		nChdSVen   := 0
		nMedComVen := 0
	Endif
	
	//"Representante             |     Vencidos      A Vencer         Pagos|      Cheque Devolvido     |     Limite   Media        Media"
	//"Cliente                   |                                         |     Principal        Saldo| de Credito  Atraso       Compra"
	// 1234567890123456789012345  99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99  999,999.99 999,999 99,999,999.99
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//           1         2         3         4         5         6         7         8        9          0         1         2         3
	
	//                 1              2              3          4            5         6          7            8                 9           10        11          12
	//	AADD(aDados{TMP->A3_COD, TMP->A3_NOME, TMP->A1_COD,TMP->A1_LOJA,TMP->A1_NOME,nVencido, naReceber, aPagos+nPagosAC,nChdPrin+nChdAC,nChdSaldo,TMP->A1_LC,TMP->A1_MATR})
	
	@ nlin,000 pSay Subst(aDados[i,5],1,25)
	@ nlin,027 pSay aDados[i,6]   Picture "@E 99,999,999.99"
	@ nlin,041 pSay aDados[i,7]   Picture "@E 99,999,999.99"
	@ nlin,055 pSay aDados[i,8]   Picture "@E 99,999,999.99"
	@ nlin,069 pSay aDados[i,9]   Picture "@E 99,999,999.99"
	@ nlin,083 pSay aDados[i,10]  Picture "@E 99,999,999.99"
	@ nlin,098 pSay aDados[i,11]  Picture "@E 999,999.99"
	@ nlin,109 pSay aDados[i,12]  Picture "@E 999,999"
	@ nlin,117 pSay aDados[i,13]  Picture "@E 99,999,999.99"
	nlin ++
	
	nVencVen   += aDados[i,6]
	naRecVen   += aDados[i,7]
	nPagosVen  += aDados[i,8]
	nChdPVen   += aDados[i,9]
	nChdSVen   += aDados[i,10]
	nMedComVen += aDados[i,13]
	
	nTotVenc += aDados[i,6]
	nTotaRec += aDados[i,7]
	nTotPago += aDados[i,8]
	nTotChdP += aDados[i,9]
	nTotChdS += aDados[i,10]
	nTotMedCom += aDados[i,13]
	
Next
nlin ++
@ nlin,000 pSay "Total Vendedor: "
@ nlin,026 pSay nVencVen        Picture "@E 999,999,999.99"
@ nlin,040 pSay naRecVen        Picture "@E 999,999,999.99"
@ nlin,054 pSay nPagosVen       Picture "@E 999,999,999.99"
@ nlin,068 pSay nChdPVen        Picture "@E 999,999,999.99"
@ nlin,082 pSay nChdSVen        Picture "@E 999,999,999.99"
@ nlin,116 pSay nMedComVen      Picture "@E 999,999,999.99"

nlin := nlin + 2
@ nlin,000 pSay "TOTAL GERAL: "
@ nlin,026 pSay nTotVenc        Picture "@E 999,999,999.99"
@ nlin,040 pSay nTotaRec        Picture "@E 999,999,999.99"
@ nlin,054 pSay nTotPago        Picture "@E 999,999,999.99"
@ nlin,068 pSay nTotChdP        Picture "@E 999,999,999.99"
@ nlin,082 pSay nTotChdS        Picture "@E 999,999,999.99"
@ nlin,116 pSay nTotMedCom      Picture "@E 999,999,999.99"

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

AADD(aRegs,{cPerg,"01","Do Representante   ","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"02","Ate o Representante","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"03","Do Cliente         ","","","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
AADD(aRegs,{cPerg,"04","Ate o Cliente      ","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
AADD(aRegs,{cPerg,"05","Tipo de Cliente    ","","","mv_ch5","N",1,0,0,"C","","mv_par05","Pessoa Fisica","","","","","Pessoa Juridica","","","","","Ambos","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ordem              ","","","mv_ch6","N",1,0,0,"C","","mv_par06","Vencidos","","","","","Limite Credito","","","","","A Vencer","","","","","Saldo CHD","","","","","Principal CHD","","","","",""})
AADD(aRegs,{cPerg,"07","So com Tit Vencidos","","","mv_ch7","N",1,0,0,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

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