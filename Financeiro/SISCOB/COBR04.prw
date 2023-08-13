#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDescricao ³ Relatorio gerencial da cobranca - vencidos por tipo de     º±±
±±º          ³ cliente                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cobranca - Rava Embalagens                         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COBR04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Inadimplencia por Representante/Tipo de Cliente"
Local cPict        := ""
Local titulo       := "Inadimplencia por Representante/Tipo de Cliente"
Local nLin         := 80
local cabec1       := "Representante                 |      Faturado      Recebido       Vencido   % Inad |     A Receber       Vencido   % Inad |     A Receber       Vencido   % Inad |     A Receber       Vencido  % Inad"
Local Cabec2       := "Tipo Cliente                  |                                                    |      365 Dias      365 Dias     365d |       60 Dias       60 Dias      60d |       30 Dias       30 Dias     30d"
//                     1234567890123456789012345       99,999,999.99 99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8        9          0         1         2         3         4         5         6         7         8         9         0
//                                                                                                                                                                                                                               2
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "COBR04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "COBR04"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COBR04" // Coloque aqui o nome do arquivo usado para impressao em disco

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

Local nOrdem := aReturn[8]

//cria aqruivo de trabaho
Dbselectarea("SA3")
dbgotop()
Dbseek(xFilial()+mv_par01,.t.)
SETREGUA((SA3->(LASTREC())-Recno()))

nTotFatF    := 0
nTotRecF    := 0
nTotVencF   := 0
nTotVe365F := 0
nTotVen60F := 0
nTotVen30F := 0
nTotFatJ    := 0
nTotRecJ    := 0
nTotVencJ   := 0
nTotVe365J := 0
nTotVen60J := 0
nTotVen30J := 0
nTotFa365F  := 0
nTotFat60F  := 0
nTotFa365J  := 0
nTotFat60J  := 0
nTotFat30F  := 0
nTotFat30J  := 0

While !eof() .And. A3_COD <= mv_par02

	If !A3_ATIVO $ 'Ss' //Se nao estiver ativo, pula o registro
		dbskip()
		Loop
	Endif

	INCREGUA()

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
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,{'Inadimplencia do Representante'+space(200)+" Emissao: "+dtoc(DDataBase)})
		nLin := 9
	Endif

	cVend      := A3_COD
	nFatJ      := 0
	nFatF      := 0
	nRecebidoF := 0
	nVencidoF  := 0
	nVenc60F   := 0
	nVenc30F   := 0
	nRecebidoJ := 0
	nVencidoJ  := 0
	nVenc60J   := 0
	nVenc30J   := 0

	//RECEBIDO
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_VALOR-E1_SALDO) RECEBIDO"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'CHD' " //Mudar prefixo
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_ORIGEM <> 'FINA280' " //FATURAS A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nRecebidoF := SE1N->RECEBIDO
		Else
			nRecebidoJ := SE1N->RECEBIDO
		Endif
		dbclosearea()

	Next

	//VENCIDOS
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_SALDO) VENCIDOS"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_SALDO > 0"
		cCond += "   AND E1_VENCREA < '"+dTos(dDatabase)+"' "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nVencidoF := SE1N->VENCIDOS
		Else
			nVencidoJ := SE1N->VENCIDOS
		Endif
		dbclosearea()

	Next

	//A Receber 365 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_VALOR) FAT365"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-365)+"' AND '"+dTos(dDatabase-1)+"' "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_PREFIXO <> 'CHD' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nFat365F := SE1N->FAT365
		Else
			nFat365J := SE1N->FAT365
		Endif
		dbclosearea()

	Next

	//VENCIDOS a 365 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_SALDO) VENCIDOS365"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-365)+"' AND '"+dTos(dDatabase-1)+"'  "
		cCond += "   AND E1_SALDO > 0"
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nVenc365F := SE1N->VENCIDOS365
		Else
			nVenc365J := SE1N->VENCIDOS365
		Endif
		dbclosearea()

	Next

	//A Receber 60 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_VALOR) FAT60"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-60)+"' AND '"+dTos(dDatabase-1)+"'  "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_PREFIXO <> 'CHD' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nFat60F := SE1N->FAT60
		Else
			nFat60J := SE1N->FAT60
		Endif
		dbclosearea()

	Next

	//VENCIDOS a 60 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_SALDO) VENCIDOS60"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-60)+"' AND '"+dTos(dDatabase-1)+"'   "
		cCond += "   AND E1_SALDO > 0"
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nVenc60F := SE1N->VENCIDOS60
		Else
			nVenc60J := SE1N->VENCIDOS60
		Endif
		dbclosearea()

	Next

	//Faturados a 30 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_VALOR) FAT30"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-30)+"' AND '"+dTos(dDatabase-1)+"'  "
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_PREFIXO <> 'CHD' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nFat30F := SE1N->FAT30
		Else
			nFat30J := SE1N->FAT30
		Endif
		dbclosearea()

	Next

	//VENCIDOS a 30 dias
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
		cCond := " SELECT SUM(E1_SALDO) VENCIDOS30"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("SE1")+" SE1"
		cCond += " WHERE E1_VEND1 = '"+SA3->A3_COD+"' "
		cCond += "   AND E1_VENCREA BETWEEN '"+dTos(dDatabase-30)+"' AND '"+dTos(dDatabase-1)+"'  "
		cCond += "   AND E1_SALDO > 0"
		cCond += "   AND E1_TIPO NOT IN ('RA','VA','JP','AB-','NCC','NDC') "
		cCond += "   AND E1_PREFIXO <> 'COM' " //Mudar prefixo
		cCond += "   AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
		cCond += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND SE1.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS SE1N NEW

		Dbselectarea("SE1N")
		If i == 1
			nVenc30F := SE1N->VENCIDOS30
		Else
			nVenc30J := SE1N->VENCIDOS30
		Endif
		dbclosearea()

	Next

	//Acumulado
	For i := 1 To 2 //1 = Pessoa Fisica e 2 = Pessoa Juridica
/*
		cCond := " SELECT SUM(ZZ9_VALPAG) ACUMULADO"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("ZZ9")+" ZZ9"
		cCond += " WHERE A1_VEND = '"+SA3->A3_COD+"' "
		cCond += "   AND A1_COD+A1_LOJA = ZZ9_CODIGO+ZZ9_LOJA "
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND ZZ9.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

*/
		cCond := " SELECT SUM(ZZ9_VALPAG) ACUMULADO"
		cCond += " FROM "+RetSqlname("SA1")+" SA1,"+RetSqlname("ZZ9")+" ZZ9"
		cCond += " WHERE ZZ9_CODVEN = '"+SA3->A3_COD+"' "
		cCond += "   AND A1_COD+A1_LOJA = ZZ9_CODIGO+ZZ9_LOJA "
		If i == 1
			cCond += "   AND A1_PESSOA = 'F' "
		Else
			cCond += "   AND A1_PESSOA = 'J' "
		Endif
		cCond += "   AND ZZ9.D_E_L_E_T_ = ''"
		cCond += "   AND SA1.D_E_L_E_T_ = ''"

		TCQUERY cCond ALIAS ZZ9N NEW

		Dbselectarea("ZZ9N")
		If i == 1
			nRecAcuF := ZZ9N->ACUMULADO
		Else
			nRecAcuJ := ZZ9N->ACUMULADO
		Endif
		dbclosearea()

	Next

	Dbselectarea("SA3")
	//Se nao houver nenhum valor pula o registro
	If nRecebidoF+nVencidoF+nVenc60F+nVenc30F+nRecAcuF+nRecebidoJ+nVencidoJ+nVenc60J+nVenc30J+nRecAcuJ == 0
		dbskip()
		loop
	Endif

	@ nlin,000 pSay A3_COD+" - "+A3_NOME
	nlin ++
	//"Representante                 |      Faturado      Recebido       Vencido   % Inad |     A Receber       Vencido   % Inad |     A Receber       Vencido   % Inad |     A Receber       Vencido  % Inad"
	//"Tipo Cliente                  |                                                    |      365 Dias      365 Dias     365d |       60 Dias       60 Dias      60d |       30 Dias       30 Dias     30d"
	// 1234567890123456789012345       99,999,999.99 99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99   99,999,999.99 99,999,999.99   999.99
	// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//           1         2         3         4         5         6         7         8        9          0         1         2         3         4         5         6         7         8         9         0

	@ nlin,000 pSay "Pessoa Fisica"
	@ nlin,022 pSay ((nRecebidoF+nVencidoF+nRecAcuF)/(nRecebidoJ+nVencidoJ+nRecAcuJ+nRecebidoF+nVencidoF+nRecAcuF))*100 Picture "@E 999.99"
	if mv_par04 = 1
		@ nlin,032 pSay nRecebidoF+nVencidoF+nRecAcuF Picture "@E 99,999,999.99"
		@ nlin,046 pSay nRecebidoF+nRecAcuF Picture "@E 99,999,999.99"
		@ nlin,060 pSay nVencidoF  Picture "@E 99,999,999.99"
	endif
	@ nlin,076 pSay (nVencidoF/(nRecebidoF+nVencidoF+nRecAcuF))*100   Picture "@E 999.99"
	if mv_par04 = 1
		@ nlin,085 pSay nFat365F Picture "@E 99,999,999.99"
		@ nlin,099 pSay nVenc365F   Picture "@E 99,999,999.99"
	endif
	@ nlin,115 pSay (nVenc365F/(nFat365F))*100   Picture "@E 999.99"
	if mv_par04 = 1
		@ nlin,124 pSay nFat60F Picture "@E 99,999,999.99"
		@ nlin,138 pSay nVenc60F   Picture "@E 99,999,999.99"
	endif
	@ nlin,154 pSay (nVenc60F/(nFat60F))*100   Picture "@E 999.99"
	if mv_par04 = 1
		@ nlin,163 pSay nFat30F Picture "@E 99,999,999.99"
		@ nlin,177 pSay nVenc30F   Picture "@E 99,999,999.99"
	endif
	@ nlin,193 pSay (nVenc30F/(nFat30F))*100   Picture "@E 999.99"

	nlin ++
	@ nlin,000 pSay "Pessoa Juridica"
	@ nlin,022 pSay ((nRecebidoJ+nVencidoJ+nRecAcuJ)/(nRecebidoJ+nVencidoJ+nRecAcuJ+nRecebidoF+nVencidoF+nRecAcuF))*100 Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,032 pSay nRecebidoJ+nVencidoJ+nRecAcuJ Picture "@E 99,999,999.99"
		@ nlin,046 pSay nRecebidoJ+nRecAcuJ Picture "@E 99,999,999.99"
		@ nlin,060 pSay nVencidoJ  Picture "@E 99,999,999.99"
	endif

	@ nlin,076 pSay (nVencidoJ/(nRecebidoJ+nVencidoJ+nRecAcuJ))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,085 pSay nFat365J Picture "@E 99,999,999.99"
		@ nlin,099 pSay nVenc365J   Picture "@E 99,999,999.99"
	endif

	@ nlin,115 pSay (nVenc365J/(nFat365J))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,124 pSay nFat60J Picture "@E 99,999,999.99"
		@ nlin,138 pSay nVenc60J   Picture "@E 99,999,999.99"
	endif

	@ nlin,154 pSay (nVenc60J/(nFat60J))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,163 pSay nFat30J Picture "@E 99,999,999.99"
		@ nlin,177 pSay nVenc30J   Picture "@E 99,999,999.99"
	endif
	@ nlin,193 pSay (nVenc30J/(nFat30J))*100   Picture "@E 999.99"
	nlin ++

	@ nlin,000 pSay "Total "
	@ nlin,022 pSay 100 Picture "@E 999.99"
	if mv_par04 = 1
		@ nlin,032 pSay nRecebidoJ+nVencidoJ+nRecAcuJ+nRecebidoF+nVencidoF+nRecAcuF Picture "@E 99,999,999.99"
		@ nlin,046 pSay nRecebidoJ+nRecAcuJ+nRecebidoF+nRecAcuF Picture "@E 99,999,999.99"
		@ nlin,060 pSay nVencidoJ+nVencidoF  Picture "@E 99,999,999.99"
	endif

	@ nlin,076 pSay ((nVencidoJ+nVencidoF)/(nRecebidoJ+nVencidoJ+nRecAcuJ+nRecebidoF+nVencidoF+nRecAcuF))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,085 pSay nFat365F+nFat365J Picture "@E 99,999,999.99"
		@ nlin,099 pSay nVenc365F+nVenc365J   Picture "@E 99,999,999.99"
	endif

	@ nlin,115 pSay ((nVenc365F+nVenc365J)/(nFat365F+nFat365J))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,124 pSay nFat60F+nFat60J Picture "@E 99,999,999.99"
		@ nlin,138 pSay nVenc60J+nVenc60F   Picture "@E 99,999,999.99"
	endif

	@ nlin,154 pSay ((nVenc60J+nVenc60F)/(nFat60F+nFat60J))*100   Picture "@E 999.99"

	if mv_par04 = 1
		@ nlin,163 pSay nFat30F+nFat30J	Picture "@E 99,999,999.99"
		@ nlin,177 pSay nVenc30J+nVenc30F   Picture "@E 99,999,999.99"
	endif

	@ nlin,193 pSay ((nVenc30J+nVenc30F)/(nFat30F+nFat30J))*100   Picture "@E 999.99"
	nlin ++
	@ nlin,000 pSay Replicate("-",220)

	If mv_par03 == 1  //Salta pagina por representante
		nlin := 80
	Else
		nlin ++
	Endif
	nTotFatF    += nRecebidoF+nVencidoF+nRecAcuF
	nTotRecF    += nRecebidoF+nRecAcuF
	nTotVencF   += nVencidoF
	nTotVe365F  += nVenc365F
	nTotVen60F  += nVenc60F
	nTotVen30F  += nVenc30F
	nTotFa365F  += nFat365F
	nTotFat60F  += nFat60F
	nTotFat30F  += nFat30F

	nTotFatJ    += nRecebidoJ+nVencidoJ+nRecAcuJ
	nTotRecJ    += nRecebidoJ+nRecAcuJ
	nTotVencJ   += nVencidoJ
	nTotVe365J  += nVenc365J
	nTotVen60J  += nVenc60J
	nTotVen30J  += nVenc30J
	nTotFa365J  += nFat365J
	nTotFat60J  += nFat60J
	nTotFat30J  += nFat30J

	dbskip()
End
nlin ++
@ nlin,000 pSay "Total Fisica: "
@ nlin,022 pSay (nTotFatF/(nTotFatF+nTotFatJ))*100 Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,032 pSay nTotFatF Picture "@E 99,999,999.99"
	@ nlin,046 pSay nTotRecF Picture "@E 99,999,999.99"
	@ nlin,060 pSay nTotVencF  Picture "@E 99,999,999.99"
endif

@ nlin,076 pSay (nTotVencF/(nTotFatF))*100  	 Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,085 pSay nTotFa365F    Picture "@E 99,999,999.99"
	@ nlin,099 pSay nTotVe365F   Picture "@E 99,999,999.99"
endif
@ nlin,115 pSay (nTotVe365F/(nTotFa365F))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,124 pSay nTotFat60F    Picture "@E 99,999,999.99"
	@ nlin,138 pSay nTotVen60F   Picture "@E 99,999,999.99"
endif

@ nlin,154 pSay (nTotVen60F/(nTotFat60F))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,163 pSay nTotFat30F   Picture "@E 99,999,999.99"
	@ nlin,177 pSay nTotVen30F   Picture "@E 99,999,999.99"
endif

@ nlin,193 pSay (nTotVen30F/(nTotFat30F))*100   Picture "@E 999.99"
nlin ++
@ nlin,000 pSay "Total Juridica: "
@ nlin,022 pSay (nTotFatJ/(nTotFatF+nTotFatJ))*100 Picture "@E 999.99"
if mv_par04 = 1
	@ nlin,032 pSay nTotFatJ Picture "@E 99,999,999.99"
	@ nlin,046 pSay nTotRecJ Picture "@E 99,999,999.99"
	@ nlin,060 pSay nTotVencJ  Picture "@E 99,999,999.99"
endif

@ nlin,076 pSay (nTotVencJ/(nTotFatJ))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,085 pSay nTotFa365J    Picture "@E 99,999,999.99"
	@ nlin,099 pSay nTotVe365J   Picture "@E 99,999,999.99"
endif

@ nlin,115 pSay (nTotVe365J/(nTotFa365J))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,124 pSay nTotFat60J    Picture "@E 99,999,999.99"
	@ nlin,138 pSay nTotVen60J   Picture "@E 99,999,999.99"
endif

@ nlin,154 pSay (nTotVen60J/(nTotFat60J))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,163 pSay nTotFat30J   Picture "@E 99,999,999.99"
	@ nlin,177 pSay nTotVen30J   Picture "@E 99,999,999.99"
endif


@ nlin,193 pSay (nTotVen30J/(nTotFat30J))*100   Picture "@E 999.99"
nlin ++
@ nlin,000 pSay "Total Geral: "
@ nlin,022 pSay 100 Picture "@E 999.99"
if mv_par04 = 1
	@ nlin,032 pSay nTotFatF+nTotFatJ Picture "@E 99,999,999.99"
	@ nlin,046 pSay nTotRecF+nTotRecJ Picture "@E 99,999,999.99"
	@ nlin,060 pSay nTotVencF+nTotVencJ  Picture "@E 99,999,999.99"
endif

@ nlin,076 pSay ((nTotVencF+nTotVencJ)/(nTotFatF+nTotFatJ))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,085 pSay nTotFa365F+nTotFa365J Picture "@E 99,999,999.99"
	@ nlin,099 pSay nTotVe365F+nTotVe365J   Picture "@E 99,999,999.99"
endif

@ nlin,115 pSay ((nTotVe365F+nTotVe365J)/(nTotFa365F+nTotFa365J))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,124 pSay nTotFat60F+nTotFat60J Picture "@E 99,999,999.99"
	@ nlin,138 pSay nTotVen60F+nTotVen60J   Picture "@E 99,999,999.99"
endif

@ nlin,154 pSay ((nTotVen60F+nTotVen60J)/(nTotFat60F+nTotFat60J))*100   Picture "@E 999.99"

if mv_par04 = 1
	@ nlin,163 pSay nTotFat30F+nTotFat30J Picture "@E 99,999,999.99"
	@ nlin,177 pSay nTotVen30F+nTotVen30J   Picture "@E 99,999,999.99"
endif
@ nlin,193 pSay ((nTotVen30F+nTotVen30J)/(nTotFat30F+nTotFat30J))*100   Picture "@E 999.99"


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

AADD(aRegs,{cPerg,"01","Do Representante   :","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"02","Ate o Representante:","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"03","Salta Pagina p/ Rep:","","","mv_ch3","N",1,0,0,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Imprime valor      :","","","mv_ch4","N",1,0,0,"C","","mv_par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

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
