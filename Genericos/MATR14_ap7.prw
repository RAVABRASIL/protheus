#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MATR14()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCOL,WNREL,CDESC1,CDESC2,CDESC3,LEND")
SetPrvt("TITULO,ARETURN,ALINHA,NOMEPROG,NLASTKEY,CSTRING")
SetPrvt("CPERG,LI,M_PAG,CGRUPO,NCONTADOR,J")
SetPrvt("CABEC1,CABEC2,CABEC3,TAMANHO,CBCONT,AMESES")
SetPrvt("AORDEM,CMESES,NANO,NMES,CMES,CCAMPOS")
SetPrvt("CDESCRI,I,LIMITE,NTIPO,MV_PAR08,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR140  ³ Autor ³ Fabricio Carlos David ³ Data ³ 21.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao das Solicitacoes de Compras                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nCol:=""
wnrel:=""
cDesc1 := "Emissao das solicitacoes de compras cadastradas"
cDesc2 := ""
cDesc3 := ""
lEnd:= .F.

titulo := "S o l i c i t a c a o   d e   C o m p r a    Numero : "
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
aLinha:= { }
nomeprog:="MATR140"
nLastKey := 0
cString  := "SC1"
cPerg      := "MTR140"
wnrel    := "MATR140"
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR140",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Do Numero                                        ³
//³ mv_par02    Ate o Numero                                     ³
//³ mv_par03    Todas ou em Aberto                               ³
//³ mv_par04    A Partir da data de emissao                      ³
//³ mv_par05    Ate a data de emissao                            ³
//³ mv_par06    Do Item                                          ³
//³ mv_par07    Ate o Item                                       ³
//³ mv_par08    Campo Descricao do Produto.                      ³
//³ mv_par09    Imprime Empenhos ?                               ³
//³ mv_par10    Utiliza Amarracao ?  Produto   Grupo             ³
//³ mv_par11    Imprime Qtos Pedido Compra?                      ³
//³ mv_par12    Imprime Qtos Fornecedores?                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	DBSetFilter()
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> 	__Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	DBSetFilter()
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> 	__Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
Endif

#IFDEF WINDOWS
    RptStatus({|| R140Imp() },Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     RptStatus({|| Execute(R140Imp) },Titulo)
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     Function R140Imp
Static Function R140Imp()
#ENDIF

cGrupo:=""
nContador:=""
j:=""
cabec1   := ""
cabec2   := ""
cabec3   := ""
tamanho:= " "
cbCont := 0
aMeses := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
aOrdem := {}
cMeses:=""
nAno:=""
nMes:=""
cMes:=""
cCampos:=""
cDescri:=""
i:=""

limite := 115
nTipo  := IIF(aReturn[4]==1,15,18)

dbSelectArea("SC1")
SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa as Solicitacoes de Compra a serem impressas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set SoftSeek On
DBSeek (xFilial()+mv_par01)
Set SoftSeek Off

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !EOF() .And. C1_FILIAL==xFilial() .And. C1_NUM>=mv_par01 .And. C1_NUM<=mv_par02

	#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		EndIf
	#ENDIF

	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as que ja' tem pedido cadastrado                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par03 == 2
		If (C1_QUANT - C1_QUJE) == 0
			dbSkip()
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra a data de emissao e os itens a serem impressos        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C1_EMISSAO < mv_par04 .Or. C1_EMISSAO > mv_par05
		dbSkip()
		Loop
	EndIf

	If C1_ITEM < mv_par06 .Or. C1_ITEM > mv_par07
		dbSkip()
		Loop
	EndIf
	
	If li > 55
		titulo := Subs(titulo,1,54) + SC1->C1_NUM + "  C.Custo : " + SC1->C1_CC
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona os arquivos no registro a ser impresso             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial()+SC1->C1_PRODUTO)
	cGrupo := SB1->B1_GRUPO
	
	If mv_par10 == 1
		dbSelectArea("SA5")
		dbSetOrder(2)
		dbSeek(xFilial()+SC1->C1_PRODUTO)
	Else
		dbSelectArea("SAD")
		dbSetOrder(2)
		dbSeek(xFilial()+cGrupo)
	EndIf
	
	dbSelectArea("SB2")
	dbSeek(xFilial()+SC1->C1_PRODUTO+SC1->C1_LOCAL)
	
	dbSelectArea("SB3")
	dbSeek(xFilial()+SC1->C1_PRODUTO)
	
	dbSelectArea("SD4")
	dbSeek(xFilial()+SC1->C1_PRODUTO)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o descricao do Produto conf. parametro digitado.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescri := " "
	If Empty(mv_par08)
		mv_par08 := "B1_DESC"
	EndIf
	If AllTrim(mv_par08) == "C1_DESCRI"    // Impressao da Descricao do produto
		cDescri := SC1->C1_DESCRI           // do arquivo de Solicitacao.
	EndIf
	If AllTrim(mv_par08) == "B5_CEME"      // Descricao cientifica do Produto.
		dbSelectArea("SB5")
		dbSetOrder(1)
		dbSeek( xFilial()+SC1->C1_PRODUTO )
		If Found()
			cDescri := B5_CEME
		EndIf
	EndIf
	If Empty(cDescri)                      // Impressao da descricao do Produto SB1.
		dbSelectArea("SB1")
		dbSeek( xFilial()+SC1->C1_PRODUTO )
		cDescri := SB1->B1_DESC
	EndIf

	A140Solic(cDescri,@li)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao das observacoes da solicitacao (caso exista)       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC1->C1_OBS)
		li:=li+1
		@ li,000 PSAY REPLICATE("-",132)
		li:=li+1
		@ li,000 PSAY "OBSERVACOES:"
		li:=li+1
		For i:= 1 To 258 Step 129
			@ li,003 PSAY Subs(SC1->C1_OBS,i,129)   Picture "@!"
			li:=li+1
			If Empty(Subs(SC1->C1_OBS,i+129,129))
				Exit
			Endif
		Next i
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da requisicoes empenhadas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li:=li+1
	If mv_par09 == 1
		@ li,000 PSAY REPLICATE("-",132)
		li:=li+1
		@ li,000 PSAY "REQUISICOES EMPENHADAS:"
		li:=li+1
		dbSelectArea("SD4")
		If EOF()
			@ li,002 PSAY "Nao existem requisicoes empenhadas deste item."
			li:=li+1
		Else
			@ li,000 PSAY "Ordem de        Produto a ser           inicio        quantidade |Ordem de        Produto a ser           inicio        quantidade |"
			li:=li+1
			@ li,000 PSAY "Producao        produzido              previsto       necessaria |Producao        produzido              previsto       necessaria |"
//                                                         12345678901     123456789012345        12/12/12      999999999.99|1234567890      123456789012345        12/12/12      999999999.99|
//                                                              0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                                                              0         1         2         3         4         5         6         7         8         9         0         1         2         3
			li:=li+1
			nCol := 0
			While !EOF() .And. D4_FILIAL+D4_COD == xFilial()+SC1->C1_PRODUTO
				If D4_QUANT == 0
					dbSkip()
					Loop
				Endif
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					li := 6
					A140Solic(cDescri,@li)
				EndIf
				dbSelectArea("SC2")
				dbSeek(xFilial()+SD4->D4_OP)
				dbSelectArea("SD4")
				@ li,nCol    PSAY D4_OP
				@ li,nCol+16 PSAY SC2->C2_PRODUTO
				@ li,nCol+39 PSAY D4_DATA
				@ li,nCol+53 PSAY D4_QUANT       Picture PesqPictQt("D4_QUANT",12)
				@ li,nCol+65 PSAY '|'
				nCol:=66
				nCol:=nCol+1
				If nCol > 66
					li:=li+1
					nCol := 0
				EndIf
				dbSkip()
			End
			If nCol == 66
				@ li,nCol+65 PSAY '|'
			EndIf
			li:=li+1
		EndIf
	EndIf

	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 6
		A140Solic(cDescri,@li)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Consumos nos ultimos 12 meses                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1
	@ li,000 PSAY "CONSUMO DOS ULTIMOS 12 MESES:"
	li:=li+1
	dbSelectArea("SB3")
	If EOF()
		@ li,002 PSAY "Nao existe registro de consumo anterior deste item."
		li:=li+1
	Else
		cMeses := "   "
		nAno := YEAR(dDataBase)-1900
		nMes := MONTH(dDataBase)
		aOrdem := {}
		For j := nMes To 1 Step -1
			//cMeses:=cMeses+1
			cMeses := aMeses[j]+"/"+StrZero(nAno,2)+Space(4)
			AADD(aOrdem,j)
		Next j
		nAno:=nAno-1
		For j := 12 To nMes+1 Step -1
			//cMeses:=cMeses+1
			cMeses := aMeses[j]+"/"+StrZero(nAno,2)+Space(4)
			AADD(aOrdem,j)
		Next j
//                "   001/99    002/99    003/99    004/99    005/99    006/99    007/99    008/99    009/99    010/99    011/99    012/99    Media C"
//                 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12345678 A
//                 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                 0         1         2         3         4         5         6         7         8         9         0         1         2         3
		@ li,000 PSAY Trim(cMeses)+"    Media C"
		li:=li+1
		nCol := 0
		For j := 1 To Len(aOrdem)
			cMes    := StrZero(aOrdem[j],2)
			cCampos := "B3_Q"+cMes
			@ li,nCol PSAY  &cCampos                PicTure PesqPictQt("B3_Q01",09)
			nCol := 10
			nCol:=nCol+1
		Next j
		@ li,120 PSAY B3_MEDIA                     PicTure  PesqPictQt("B3_MEDIA",8)
		@ li,129 PSAY B3_CLASSE
		li:=li+1
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rotina para imprimir dados dos ultimos pedidos               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1
	@ li,000 PSAY "ULTIMOS PEDIDOS:"
	li:=li+1
	dbSelectArea("SC7")
	dbSetOrder(4)
	Set SoftSeek On
	dbSeek(xFilial()+SC1->C1_PRODUTO+"z")
	Set SoftSeek Off
	dbSkip(-1)
	If xFilial()+SC1->C1_PRODUTO <> C7_FILIAL+C7_PRODUTO
		@ li,002 PSAY "Nao existem pedidos cadastrados para este item."
		li:=li+1
	Else
		@ li,000 PSAY "Numero It C.Forn Lj Nome              Quantidade Vlr.Unitario  Valor Total Emissao   Neces.  Prz Cond Qtde Entr.      Saldo Res.Eli."
//                  111111 11 111111 11 12345678901234567 1234567890 123456789.12 123456789.12 11/11/11 11/11/11 123  123 1234567890 1234567890
//                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                  0         1         2         3         4         5         6         7         8         9         0         1         2         3
		li:=li+1
		nContador := 0
		While !BOF() .And. xFilial()+SC1->C1_PRODUTO == C7_FILIAL+C7_PRODUTO
			dbSelectArea("SA2")
			dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
			dbSelectArea("SC7")
			nContador:=nContador+1
			If nContador > mv_par11
				Exit
			EndIf
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 6
				A140Solic(cDescri,@li)
			EndIf
			@ li,000 PSAY C7_NUM
			@ li,007 PSAY C7_ITEM
			@ li,010 PSAY C7_FORNECE
			@ li,017 PSAY C7_LOJA
			@ li,020 PSAY SubStr(SA2->A2_NOME,1,17)
			@ li,038 PSAY C7_QUANT  Picture PesqPictQt("C7_QUANT",10)
			@ li,049 PSAY C7_PRECO  Picture Right(PesqPict("SC7","c7_preco"),12)
			@ li,062 PSAY C7_TOTAL  Picture Right(PesqPict("SC7","c7_total"),12)
			@ li,075 PSAY C7_EMISSAO
			@ li,084 PSAY C7_DATPRF
			@ li,093 PSAY C7_DATPRF-C7_EMISSAO  Picture "999"
			@ li,096 PSAY "D"
			@ li,098 PSAY C7_COND
			@ li,102 PSAY C7_QUJE     Picture PesqPictQt("C7_QUJE",10)
			@ li,113 PSAY If(Empty(C7_RESIDUO),C7_QUANT-C7_QUJE,0)  Picture PesqPictQt("C7_QUJE",10)
			@ li,126 PSAY If(Empty(C7_RESIDUO),'Nao','Sim')
			li:=li+1
			dbSkip(-1)
		End
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os fornecedores indicados para este produto          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1
	@ li,000 PSAY "FORNECEDORES:"
	li:=li+1
	
	If mv_par10 == 1                                                                // Amarracao por Produto
		dbSelectArea("SA5")
		If EOF()
			@ li,002 PSAY "Nao existem fornecedores cadastrados para este item."
			li:=li+1
		Else
			@ li,000 PSAY "Codigo Lj Nome                           Telefone        Contato    Fax             Ul.Compr Municipio       UF Ris Cod. no Fornec."
//                                111111 11 123456789012345678901234567890 123456789012345 1234567890 123456789012345 11/11/11 123456789012345 12 123 123456789012345
//                          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                       0         1         2         3         4         5         6         7         8         9         0         1         2         3
			li:=li+1
			nContador := 0
			While !EOF() .And. xFilial()+SC1->C1_PRODUTO == A5_FILIAL+A5_PRODUTO
				dbSelectArea("SA2")
				dbSeek(xFilial()+SA5->A5_FORNECE+SA5->A5_LOJA)
				If EOF()
					dbSelectArea("SA5")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SA5")
				nContador:=nContador+1
				If nContador > mv_par12
					Exit
				EndIf
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					li := 6
					A140Solic(cDescri,@li)
				EndIf
				@ li,000 PSAY A5_FORNECE
				@ li,007 PSAY A5_LOJA
				@ li,010 PSAY SubStr(SA2->A2_NOME,1,30)
				@ li,041 PSAY SA2->A2_TEL
				@ li,057 PSAY Substr(SA2->A2_CONTATO,1,10)
				@ li,068 PSAY SA2->A2_FAX
				@ li,084 PSAY SA2->A2_ULTCOM
				@ li,093 PSAY SA2->A2_MUN
				@ li,109 PSAY SA2->A2_EST
				@ li,112 PSAY SA2->A2_RISCO
				@ li,116 PSAY SubStr(A5_CODPRF,1,15)
				li:=li+1
				dbSkip()
			End
		EndIf
		dbSelectArea("SA5")
		dbSetOrder(1)
	Else                                                                            // Amarracao por Grupo
		dbSelectArea("SAD")
		If EOF()
			@ li,002 PSAY "Nao existem fornecedores cadastrados para este item."
			li:=li+1
		Else
			@ li,000 PSAY "Codigo Lj Nome                           Telefone        Contato    Fax             Ul.Compr Municipio       UF Ris Cod. no Fornec."
//                      111111 11 123456789012345678901234567890 123456789012345 1234567890 123456789012345 11/11/11 123456789012345 12 123 123456789012345
//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                      0         1         2         3         4         5         6         7         8         9         0         1         2         3
			li:=li+1
			nContador := 0
			
			While !EOF() .And. SAD->AD_FILIAL+SAD->AD_GRUPO == xFilial()+cGrupo
				dbSelectArea("SA2")
				dbSeek(xFilial()+SAD->AD_FORNECE+SAD->AD_LOJA)
				If EOF()
					dbSelectArea("SAD")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SAD")
				nContador:=nContador+1
				If nContador > 9
					Exit
				EndIf
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					li := 6
					A140Solic(cDescri,@li)
				EndIf
				@ li,000 PSAY AD_FORNECE
				@ li,007 PSAY AD_LOJA
				@ li,010 PSAY SubStr(SA2->A2_NOME,1,30)
				@ li,041 PSAY SA2->A2_TEL
				@ li,057 PSAY Substr(SA2->A2_CONTATO,1,10)
				@ li,068 PSAY SA2->A2_FAX
				@ li,084 PSAY SA2->A2_ULTCOM
				@ li,093 PSAY SA2->A2_MUN
				@ li,109 PSAY SA2->A2_EST
				@ li,112 PSAY SA2->A2_RISCO
				li:=li+1
				dbSkip()
			End
		EndIf
		dbSelectArea("SAD")
		dbSetOrder(2)
	EndIf

	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 6
		A140Solic(cDescri,@li)
	EndIf
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o codigo alternativo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li:=li+1
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1

	@ li,002 PSAY "Codigo Alternativo : "
	If !Empty(SB1->B1_ALTER)
		@ li,023 PSAY SB1->B1_ALTER
		@ li,060 PSAY "Saldo do Alternativo :"
		dbSelectArea("SB2")
		dbSeek(xFilial()+SB1->B1_ALTER+SC1->C1_LOCAL)
		@ li,083 PSAY B2_QATU  Picture PesqPictQt("B2_QATU",12)
	Else
		@ li,023 PSAY "Nao ha'"
	EndIf

	li:=li+1
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1

	If li > 35
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 6
		A140Solic(cDescri,@li)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o quadro de concorrencias                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li:=li+1
	@ li,000 PSAY REPLICATE("-",132)
	li:=li+1
	@ li,000 PSAY "|  C O N C O R R E N C I A S | ENTREGA  | OBSERVACOES | COND.PGTO |  CONTATO  |QUANTIDADE|  PRECO UNITARIO  | IPI |     VALOR      |"
	li:=li+1
	@ li,000 PSAY "|----------------------------|----------|-------------|-----------|-----------|----------|------------------|-----|----------------|"
	For j :=1 To 4
		li:=li+1
		@ li,000 PSAY "|                            |          |             |           |           |          |                  |     |                |"
		li:=li+1
		@ li,000 PSAY "|----------------------------|----------|-------------|-----------|-----------|----------|------------------|-----|----------------|"
	Next j
	dbSelectArea("SC1")
	li:=li+1
	@ li,000 PSAY "-----------------------------------------------------------------------------------------------"
	li:=li+1
	@ li,000 PSAY "|                 REQUISITANTE                 |                  AUTORIZANTE                 |"
	li:=li+1
	@ li,000 PSAY "|                                              |                                              |"
	li:=li+1
	@ li,000 PSAY "|   ----------------------------------------   |   ----------------------------------------   |"
	li:=li+1
	@ li,000 PSAY "|                  "+PADC(ALLTRIM(C1_SOLICIT),10)+"                  |                                              |"
	li:=li+1
	@ li,000 PSAY "|                                              |                                              |"
	li:=li+1
	@ li,000 PSAY "-----------------------------------------------------------------------------------------------"
	li:=80
	dbSkip()
End

dbSelectArea("SC1")
DBSetFilter()
dbSetOrder(1)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return  (.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function A140Solic//(cDescri,li)
Static Function A140Solic//(cDescri,li)()
j:=""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Linha do Produto Solicitado                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 04,000 PSAY Replicate("*",132)
@ 05,001 PSAY "IT CODIGO PRODUTO  D  E  S  C  R  I  C  A  O        SALDO    UM  PONTO DE   SALDO DA   QUANT /        ULTIMO LEAD DATA     DATA"
@ 06,001 PSAY "                                                    ATUAL         PEDIDO    SOLICIT.   P/EMBAL. PRECO COMPRA TIME NECESSID SOLICIT."
//                                      99 123456789012345 12345678901234567890123456789012345678901 56 123456789 123456789.12 23456789 123456789.12 123  99/99/99 99/99/99
//                                      123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                                      0        1         2         3         4         5         6         7         8         9         0         1         2         3
@ 07,000 PSAY Replicate("*",132)

@ 08,001 PSAY SC1->C1_ITEM                               Picture PesqPict("SC1","C1_ITEM")
@ 08,004 PSAY SC1->C1_PRODUTO
@ 08,020 PSAY SubStr(cDescri,1,30)
@ 08,050 PSAY SB2->B2_QATU                               Picture PesqPictQt("B2_QATU" ,11)
@ 08,062 PSAY SC1->C1_UM
@ 08,065 PSAY SB1->B1_EMIN                               Picture PesqPictQt("B1_EMIN" ,09)
@ 08,075 PSAY SC1->C1_QUANT-SC1->C1_QUJE                                                Picture PesqPictQt("C1_QUANT",12)
@ 08,088 PSAY SB1->B1_QE                                 Picture PesqPictQt("B1_QE"   ,09)
@ 08,097 PSAY SB1->B1_UPRC                               Picture PesqPict("SB1","B1_UPRC",12)
@ 08,110 PSAY CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT)  Picture "999"
@ 08,115 PSAY SC1->C1_DATPRF
@ 08,124 PSAY IF( Empty(CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT)),SC1->C1_DATPRF,(SC1->C1_DATPRF-(CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT))))

li := 9
if Len( AllTrim( cDescri ) ) > 30
   @ 09,020 PSAY Substr( cDescri,31,30 )
   li := 10
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=31 TO Len(Trim(cDescri)) Step 30
	@ li, 20 PSAY SubStr(cDescri,j,30)
	li:=li+1
Next j

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return (.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02


