#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch" 
#include "Ap5mail.ch" 
  

User Function rubem2()
 
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := ""
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FINR003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FINR003" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z62"
Private cPerg     := "FINR003"

Pergunte(cPerg,.F.)


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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery:=" "



cQuery+=" select                                             " +chr(10)
cQuery+=" Z74_GESTOR          GESTOR  ,                      " +chr(10) 
cQuery+=" Z74_TPROD           TIPO_PRODUTO ,                 " +chr(10)
cQuery+=" Z74_LIMITE          META,                          " +chr(10)

cQuery+=" ISNULL((SELECT SUM((C7_QUANT- C7_QUJE)* C7_PRECO)   SALDO FROM SC7020 SC7,SB1010 SB1 " +chr(10)
cQuery+=" WHERE  B1_COD=C7_PRODUTO                           " +chr(10)
cQuery+=" and C7_FILIAL="+valtosql(xFilial('SC7'))                       +chr(10) 
cQuery+=" and B1_FILIAL="+valtosql(xFilial('SB1'))                       +chr(10) 
cQuery+=" AND B1_TIPO=Z74_TPROD                              " +chr(10)
cQuery+=" AND B1_ATIVO='S'                                   " +chr(10)
cQuery+=" AND C7_QUANT- C7_QUJE >0 AND C7_RESIDUO !='S'      " +chr(10)
cQuery+=" AND D1_EMISSAO BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  " +chr(10)
cQuery+=" AND SB1.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" AND SC7.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" ),0)  SALDO_PEDIDO,                                " +chr(10)
                                                             
cQuery+=" ISNULL((SELECT SUM(D1_TOTAL)                       " +chr(10)
cQuery+=" From "+RetSqlName('SD1')+" SD1                     " +chr(10)
cQuery+=" WHERE                                              " +chr(10)
cQuery+=" D1_FILIAL="+valtosql(xFilial('SD1'))+"             " +chr(10)
cQuery+=" AND D1_EMISSAO BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  " +chr(10)
cQuery+=" AND D1_TP=Z74_TPROD                                " +chr(10)
cQuery+=" AND SD1.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" ),0) TOTAL_NFE                                     " +chr(10)
                                                             
cQuery+=" From "+RetSqlName('Z74')+" Z74                     " +chr(10)         
cQuery+=" WHERE                                              " +chr(10)
cQuery+=" Z74_FILIAL="+valtosql(xFilial('Z74'))+"            " +chr(10)
cQuery+=" AND Z74.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" GROUP BY Z74_GESTOR ,                              " +chr(10)
cQuery+=" Z74_TPROD ,                                        " +chr(10)
cQuery+=" Z74_LIMITE                                         " +chr(10)
                                                             

TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

While AUUX->(!EOF())
	//  cUF:=AUUX->Z15_UF
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...    
	                     //         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2         3         4
	                     //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	                     //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Cabec1         := "Gestor             tipo                 Meta           Consumido       saldo da meta"                               
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		
	Endif
 
	cGrupo:=AUUX->GESTOR
  	nTMeta   :=0
	nTConsumo:=0
	nTSaldo  :=0
  
	@nLin  ,000  PSAY U_cod2Nome(AUUX->GESTOR)
	While cGrupo ==  AUUX->GESTOR
 
		@nLin  ,20  PSAY  AUUX->TIPO_PRODUTO
		@nLin  ,30  PSAY  transform(AUUX->META        ,"@E 999,999,999.99")
		@nLin  ,50  PSAY  transform(AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE,"@E 999,999,999.99")
		@nLin  ,70  PSAY  transform(AUUX->META - (AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE)   ,"@E 999,999,999.99")
		nTMeta   +=AUUX->META
		nTConsumo+=AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE	 
		nTSaldo  +=AUUX->META - (AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE) 	 
		
		IncRegua()
		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
        nLin++
	
EndDo  
        nLin++ 
        @nLin  ,00  PSAY  "Total "
        @nLin  ,30  PSAY  transform(nTMeta   ,"@E 999,999,999.99")
		@nLin  ,50  PSAY  transform(nTConsumo,"@E 999,999,999.99")
		@nLin  ,70  PSAY  transform(nTSaldo  ,"@E 999,999,999.99")
		nLin++
		@nLin  ,00  PSAY  replicate("_",84)  
		nLin++
EndDo
 
AUUX-> (dbcloseArea()) 
 
SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return   

static function Func_Nome(cNomeCod)
 
		PswOrder(1)
		If PswSeek( cNomeCod, .T. )
			aUsuarios  := PSWRET()
			cNomeCod := Alltrim(aUsuarios[1][2])
		Endif
return cNomeCod           


 