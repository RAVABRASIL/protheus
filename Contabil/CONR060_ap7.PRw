#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/04/03
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function CONR060()        // incluido pelo assistente de conversao do AP5 IDE em 15/04/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("LEND,WNREL,CDISCO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,TITULO,TAMANHO,ARETURN,NOMEPROG,ALINHA")
SetPrvt("NLASTKEY,CPERG,CBTXT,CBCONT,LIMITE,NQUEBRA")
SetPrvt("ACAMPOS,NTOTDEB,NTOTCRD,CCONTANT,NSALDOATU,AINICIOMES")
SetPrvt("LIMPRANT,DDATAINICIAL,DDATAFINAL,DDATAANT,LCENTRODECUSTO,LIMPCC")
SetPrvt("LSALTO,NSALTO,LIMPITEM,NTAMLINHA,CINICIO,CPER17")
SetPrvt("CPER17ANT,LRESUMIDO,NDEBITODIA,NCREDITDIA,NSALDOSDIA,NPAGINICIAL")
SetPrvt("DDATALANC,BSINAL,LNAODEB,LNAOCRED,LIMP,LESTRANG")
SetPrvt("LCUSTO,LCOMPLHIST,NCODNOR,CITEMINICIAL,CITEMFINAL,CDIGVER")
SetPrvt("NREINICIA,CDESCRICAO,CTITULOR,CCABECR,CTITULOA,CABEC1")
SetPrvt("CABEC2,CCABECA1,CCABECA2,LFIRSTPAGE,CMES17INI,CMES17FIM")
SetPrvt("CPERIODOINICIAL,CPERIODOATUAL,CSINTANT,CCONTASINT,CDESC,LI")
SetPrvt("M_PAG,CCONTAINICIAL,CCONTAFINAL,CCUSTOINICIAL,CCUSTOFINAL,M_PAGINICIAL")
SetPrvt("M_PAGFIM,CCABECA,CNOMEARQ,CDC,NVALOR,CFLAG")
SetPrvt("CCONTA,CCPAR,CCONTAREPL,CCUSTOREPL,CITEMREPL,CCODIGO")
SetPrvt("NMOEDA,LRETORNO,NREGISTRO,CAREA,CCONTAC,NSAL")
SetPrvt("CALIAS,NREG,COLDAREA,NOLDORD,LSINT,NTAMCONTA")
SetPrvt("NPOSSI1,APERG,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 15/04/03 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컫컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇� DATA   � BOPS 쿛rogr. 쿌LTERACAO                                       낢�
굇쳐컴컴컴컵컴컴컴탠컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�03.03.98�      쿛ilar  쿬ompatibilizadas perguntas do relatorio/consulta낢�
굇�08.04.98퀈xxxxx쿛ilar  쿌 funcao TM() deve levar em consideracao a      낢�
굇�        �      �       쿹ingua na qual esta sendo impresso o relatorio  낢�
굇�23.04.98퀈xxxxx쿛ilar  쿔ncluido parametro MV_DIGVER p/ imprimir o digi 낢�
굇�        �      �       퀃o de controle ou nao junto � conta contabil    낢�
굇�05.05.98�      쿛ilar  쿌lterado tamanho do campo I2_NUM (7->10)        낢�
굇�27.07.98�      쿛ilar  쿎hamada direta pela consulta em tela            낢�
굇�26.09.98�      쿌ndreia쿌lteracao do Lay-out para ativar set century    낢�
굇�02.10.98�      쿌ndreia쿌lteracao do cabecalho quando imprimir C.Custo  낢�
굇�16.12.98�18926A쿛ilar  쿌o pesquisar por descricao, trava a consulta    낢�
굇�05.01.99�18064A쿛ilar  쿚pcao p/ imprimir Do Item - Ate Item            낢�
굇�17.03.99퀈xxxxx쿛ilar  쿌certar incrementacao da pagina                 낢�
굇�30.03.99쿘ETA  쿕ulio  쿣erifica뇙o de Par긩etros de Controle do Rel.   낢�
굇�23.06.99퀈xxxxx쿛ilar  쿎riar pergunta: Reinicia numeracao de pagina	   낢�
굇�16.07.99퀈xxxxx쿕ulio  쿎orrecao na AjustaSx1                           낢�
굇�30.07.99�23090A쿕ulio  쿎orrecao no tamanho do Relatorio                낢�
굇�05.08.99�      쿛ilar  쿎ontrole da 1a. pagina a ser impressa           낢�
굇�28.09.99�24109A쿛ilar  쿌umentar picture do campo saldo atual -> form G 낢�
굇쳐컴컴컴컨컴컴컴탠컴컴컴탠컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴캑굇
굇� Rdmake 2/4.07 쿌utor  � Walter C. Silva   � Data �     23/11/99        낢�
굇읕컴컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Conr060  � Autor � Wagner Xavier         � Data � 26.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emiss꼘 do Raz꼘 zebrado                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Conr060(void)                                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
lEnd:=.F.
WnRel:=""
cDisco:=NIL
cDesc1 := "Este programa ira imprimir o Razao Contabil, de  acordo  com"
cDesc2 := "os parametros solicitados pelo usuario. Caso seja  escolhida"
cDesc3 := "a impressao do Centro de Custo, o relatorio sera comprimido."
cString:="SI2"
titulo  :="Emissao do Razao em " + GetMV("MV_MOEDA1")
Tamanho :="M"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "", 1 }
nomeprog := ""
aLinha   := {}
nLastKey := 0
cPerg    := ""
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define os par꼖etros do relat줿io                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_AjustaSX1()
If ( cDisco == NIL )
   Pergunte ( "COR060", .F. )
   nomeprog := "CONR060"
   cPerg    := "COR060"
   wnRel    := "CONR060"
Else
   Pergunte ( "COC010", .F. )
   nomeprog := "CONC010"
   cPerg    := "COC010"
   wnRel    := "CONC010"
EndIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If cDisco != Nil		// Para consulta nao pode alterar perguntas
	wnrel := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Else
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
EndIf

If nLastKey == 27
	Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
   Return
Endif

#IFDEF WINDOWS
     RptStatus({|| Cr060Imp()},titulo)// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==>      RptStatus({|| Execute(Cr060Imp)},titulo)
     Return
// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==>      Function Cr060Imp
Static Function Cr060Imp()
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇� Fun뇚o    � Cr060Imp � Autor � Wagner Xavier         � Data � 05/11/93 낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇� Descri뇚o � Impressao do Razao                                         낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Sintaxe   � Cr060Imp(lEnd,wnRel,cString)                               낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Uso       � SIGACON                                                    낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿛arametros � lEnd    - A눯o do Codeblock                                낢�
굇�           � wnRel   - T죜ulo do relat줿io                              낢�
굇�           � cString - Mensagem                                         낢�
굇읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CbTxt:=""
cbcont:=""
tamanho:="M"
limite := 132
nQuebra:=0
aCampos:={}
nTotDeb:=0
nTotCrd:=0
cContAnt:=""
nSaldoAtu:=0
aInicioMes:={}
lImprAnt:=.F.
dDataInicial   := CtoD ( Space ( 08 ) )
dDataFinal     := CtoD ( Space ( 08 ) )
dDataAnt       := CtoD ( Space ( 08 ) )
lCentroDeCusto := .T.
lImpCC                    :=.F.
lSalto:=.F.
nSalto:=0
lImpItem                  := .F.
nTamLinha := 132
cInicio:=""
cPer17:=""
cPer17Ant:=""
lResumido   := .F.     // relatorio resumido (s� totais) ou completo
nDebitoDia  := 0       // total de debitos do dia
nCreditDia  := 0       // total de creditos do dia
nSaldosDia  := 0       // saldo final do dia
nPagInicial := 1       // numero da pagina inicial
dDataLanc   := CtoD ( Space ( 08 ) )           // data de lancamento
bSinal            := { | nSaldo | Iif( nSaldo < 0 , "D", Iif( nSaldo > 0 , "C"," " ) ) }
lNaoDeb := lNaoCred := .F.
lImp := .F.
lEstrang:=.F.
lCusto:=.F.
lComplHist := .T.
nCodNor   := 1
cItemInicial:=""
cItemFinal:=""
cDigVer   := GetMv("MV_DIGVER")
nReinicia:=0
cDescricao:=""  // descricao da conta
cTituloR:="RAZAO  ANALITICO  (TOTAIS)  DE " //"RAZAO  ANALITICO  (TOTAIS)  DE "
cCabecR :="DATA                                                                           D E B I T O   C R E D I T O   SALDO ATUAL"
cTituloA:="RAZAO  ANALITICO  DE "
Cabec1  := cabec2 := ""
cCabeca1:="DATA       NUMERO           H I S T O R I C O                       CONTRA PARTIDA"
cCabeca2:="D E B I T O   C R E D I T O   SALDO ATUAL"
lFirstPage:=.T.

cMes17Ini:=""
cMes17Fim:=""
cPeriodoInicial:=""
cPeriodoAtual:=""
cSintAnt:=""  //Vari쟶el auxiliar
cContaSint:="" //1a Conta sint굏ica Anterior
cDesc:=""      //Nome da 1a Conta Sint굏ica Anterior

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ( cDisco == NIL )
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis utilizadas para parametros ( COR060 )              �
   //� mv_par01            // da conta                              �
   //� mv_par02            // ate a conta                           �
   //� mv_par03            // da data                               �
   //� mv_par04            // Ate a data                            �
   //� mv_par05            // junta as contas c/mesmo centro custo  �
   //� mv_par06            // verifica se imprime o Centro de Custo �
   //� mv_par07            // Salto de pagina                       �
   //� mv_par08            // Pagina Inicial                        �
   //� mv_par09            // Pagina Final                          �
   //� mv_par10            // Analitico ou Resumido dia (resumo)    �
   //� mv_par11            // Imprime conta sem movimento?          �
   //� mv_par12            // Descricao Nacional ou Estrangeira?    �
   //� mv_par13            // Do Centro de Custo                    �
   //� mv_par14            // At� o Centro de Custo                 �
   //� mv_par15            // Imprime Cod (Normal / Reduzida)       �
	//� mv_par16            // Imprime Item?	                       �
   //� mv_par17            // Do Item                               �
   //� mv_par18            // Ate Item                              �
   //� mv_par19            // Numero da Pag p/ Reiniciar            �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   cContaInicial  := Mv_Par01
   cContaFinal    := Mv_Par02
	cCustoInicial	:= mv_par13
	cCustoFinal		:= mv_par14
   dDataInicial   := Mv_Par03
   dDataFinal     := Mv_Par04
   lCentroDeCusto := ( Mv_Par05 == 1 )
	Tamanho	  		:= "M"
	lImpCC	  		:= (Mv_Par06==1 .And. mv_par10=1)
	lImpItem  		:= (Mv_Par16==1 .And. mv_par10=1)
	nTamLinha 		:= If((lImpItem .Or. lImpCC .And. mv_par10=1),220,nTamLinha)
	nSalto	  		:= mv_par07
	m_pag	  			:= mv_par08
	m_paginicial	:= mv_par08
	m_pagfim  		:= mv_par09
	lResumido 		:= If(mv_par10==2,.T.,.F.)
	lImp				:= If(mv_par11==1,.t.,.f.)
	nCodNor			:= mv_par15
	cItemInicial   := mv_par17
	cItemFinal     := mv_par18
	nReinicia		:= mv_par19

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se descricao em outra lingua      	 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	lEstrang := .F.
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("I1_DESCEST")
	If X3USO(X3_USADO)
		If mv_par12 == 2
			lEstrang := .T.
		EndIf
	EndIf
	lCusto := .F.
	dbSeek("I2_CCD")
	If X3USO(X3_USADO)
		dbSeek("I2_CCC")
		If X3USO(X3_USADO)
			lCusto := .T.
		EndIf
	EndIf
	dbSetOrder(1)
	dbSelectArea("SI1")
Else
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis utilizadas para parametros ( COC010 )              �
   //� mv_par01            // do dia                                �
   //� mv_par02            // Ate o dia                             �
   //� mv_par03            // Considera os Centro de Custo          �
   //� mv_par04            // Pagina Inicial			    				  �
   //� mv_par05            // Pagina Final		            		  �
   //� mv_par06            // Descricao Nacional ou Estrangeira	  �
   //� mv_par07            // Considera os Items               	  �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   dDataInicial  	:= Mv_Par01
   dDataFinal    	:= Mv_Par02
	cCustoInicial 	:= Space(9)
	cCustoFinal		:= Replicate("Z",9)
   lImpCC			:= ( Mv_Par03 == 1 )
	lImpItem			:= ( mv_par07 == 1 )
	Tamanho			:= "M"
   m_pag  		  	:= mv_par04
	m_paginicial   := mv_par04
   m_pagfim		  	:= mv_par05
   nSalto		  	:= 2   	// Nao Salta Pagina
	lImp			  	:= .t.
	nCodNor		  	:= 1
	cItemInicial	:= Space(09)
	cItemFinal		:= Replicate("Z",9)
	nReinicia	   := mv_par04
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se descricao em outra lingua      	 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	lEstrang := .F.
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("I1_DESCEST")
	If X3USO(X3_USADO)
		If mv_par06 == 2
			lEstrang := .T.
		EndIf
	EndIf
	dbSetOrder(1)
	dbSelectArea("SI1")
End
nPagInicial       := m_pag

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se datas informadas estao corretas	                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ! DataMoeda(1, @cMes17Ini, dDataInicial)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF
	Help(" ",1,"MESINVALID")
	Return
End
If ! DataMoeda(1, @cMes17Fim, dDataFinal)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF
	Help(" ",1,"MESINVALID")
	Return
End

aInicioMes := CalcData(dDataInicial,1)
If aInicioMes[2] >= dDataInicial
	aInicioMes[2] := dDataInicial
End

cCabeca2 := Iif(lImpItem .Or. lImpCC,"       DEBITO               CREDITO             SALDO ATUAL ",cCabeca2)

dataMoeda(1, @cPeriodoInicial, aInicioMes[2])
cCabecA := 	cCabeca1 + ;
        Iif(lImpCC,Space(03)+Upper(RetTitle("I3_CUSTO",09))+Space(03),Iif(lImpItem,Space(15),Space(09)))+;
        Iif(lImpItem,Space(03)+Upper(RetTitle("I4_ITEM",09))+Space(03),Iif(lImpCC,Space(15),"")) + cCabeca2
If lResumido
	titulo:=cTituloR
	cabec1:=cCabecR
Else
	titulo:=cTituloA
	cabec1:=cCabecA
Endif
titulo:= titulo+        Dtoc(dDataInicial) + " A " + Dtoc(dDataFinal)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Cria Arquivo de Trabalho                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

aCampos:={ {"CONTA  ","C",20,0},;
			  {"CPAR   ","C",20,0},;
			  {"DC     ","C", 1,0},;
			  {"VALOR"  ,"N",16,2},;
			  {"DDATA"   ,"D",08,0},;
			  {"NUMERO" ,"C",10,0},;
			  {"LINHA"  ,"C",02,0},;
			  {"PERIODO","C",04,0},;
			  {"CCUSTO" ,"C",09,0},;
			  {"ITEM" 	,"C",09,0},;
			  {"HISTOR" ,"C",40,0},;
			  {"FILORIG","C",02,0},;
			  {"EMPORIG","C",02,0} }
If ( Select ( "cNomeArq" ) <> 0 )
	dbSelectArea ( "cNomeArq" )
	dbCloseArea ()
End
cNomeArq:=CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomeArq, "cNomeArq", NIL, .F. )
IndRegua("cNomeArq",cNomeArq,"CONTA+DTOS(DDATA)+NUMERO+LINHA+CCUSTO+EMPORIG+FILORIG",,,"Selecionando Registros...")
dbSelectArea("SI1")
dbSetOrder(1)
dbSeek ( xFilial("SI1") + Alltrim ( cContaInicial ), .T. )
SetRegua(Reccount())

While !Eof() .and. xFilial("SI1") == I1_FILIAL .and. I1_CODIGO <= cContaFinal

   IncRegua()

   IF I1_CLASSE == "S"
      dbSkip()
      Loop
   EndIF

   // 旼컴컴컴컴컴컴컴컴커
   // � Obt굆 os d괷itos �
   // 읕컴컴컴컴컴컴컴컴켸
	dbSelectArea ( "SI2" )
   SI2->( dbSetOrder ( 4 ) )
	lNaoDeb := .T.
   SI2->(dbSeek ( xFilial("SI2") + SI1 -> I1_CODIGO + DTOS(aInicioMes[1]),.t.))
        While !Eof() .and. xFilial("SI2") == I2_FILIAL;
		 .and. I2_DEBITO == SI1->I1_CODIGO .And. I2_DATA <= dDataFinal

		IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
			dbSkip()
			Loop
		EndIF

		IF I2_DC $ "C-"
			dbSkip()
			Loop
		EndIF

		If I2_CCD < cCustoInicial .Or. I2_CCD > cCustoFinal
			dbSkip()
			Loop
		EndIf

		If I2_ITEMD < cItemInicial .Or. I2_ITEMD > cItemFinal
			dbSkip()
			Loop
		Endif

                cDC   :="D"
                nValor:=SI2->I2_VALOR

                // Fun눯o cr060Temp

                cFlag:=""
                cConta:=""
                cCpar:=""
                cContaRepl:=""
                cCustoRepl:=""
                cItemRepl:=""

                nValor:=Iif(nValor==NIL,SI2->I2_VALOR,nValor)
                dbSelectArea ( "cNomeArq" )
                // 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                // � Caso o lan놹mento seja "X", define se � cr괺ito ou d괷ito �
                // 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                //cDc := iIf ( SI2 -> I2_CREDITO == SI1 -> I1_CODIGO, "C", "D" )
                Do Case
                   Case ( cDc == "C" )
                        cFlag := "C"
                        cConta:= "SI2 -> I2_CREDITO"
                        cCpar := "SI2 -> I2_DEBITO"
                   Case ( cDc == "D" )
                        cFlag := "D"
                        cConta:= "SI2 -> I2_DEBITO"
                        cCpar := "SI2 -> I2_CREDITO"
                EndCase

                // 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                // � Verifica se ha registro repetido no arquivo temporario    �
                // 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                cCodigo:=&cConta
                _cr060Join()
                IF lCentroDeCusto .And. lRetorno
                   cContaRepl :=        LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO) + ;
                                                 Space(20-Len(LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)))
                Else
                    cContaRepl := &cConta
                EndIF
                cCustoRepl      := Iif(cDC=="D",SI2->I2_CCD,SI2->I2_CCC)
                cItemRepl       := Iif(cDC=="D",SI2->I2_ITEMD,SI2->I2_ITEMC)

                // Deve permitir imprimir registros repetidos, pois no caso de consolidacoes
                // poderao existir lancamentos iguais!

                Reclock("cNomeArq",.T.)
                Replace DC     With cFlag
                Replace HISTOR WITH SI2->I2_HIST
                Replace NUMERO With SI2->I2_NUM
                cCodigo:= &cConta
                _cr060join()
                IF lCentroDeCusto .And. lRetorno
                   Replace CONTA WITH LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)
                Else
                   Replace CONTA With &cConta
                EndIF
                Replace CPAR    With &cCpar
                Replace LINHA   With SI2->I2_LINHA
                Replace VALOR   With nValor
                Replace DDATA    With SI2->I2_DATA
                Replace PERIODO With SI2->I2_PERIODO
                Replace CCUSTO  With cCustoRepl
                Replace ITEM     With cItemRepl
                Replace FILORIG With SI2->I2_FILORIG
                Replace EMPORIG With SI2->I2_EMPORIG

                MsUnlock()

                // Final da Fun눯o cr060Temp

                lNaoDeb := .F.
		dbSelectArea("SI2")
		dbSkip()
	Enddo

   // 旼컴컴컴컴컴컴컴컴커
   // � Obt굆 os Cr괺itos�
   // 읕컴컴컴컴컴컴컴컴켸
	dbSelectArea ( "SI2" )
   SI2 -> ( dbSetOrder ( 5 ) )
	lNaoCred := .T.
        SI2 -> ( dbSeek ( xFilial("SI2") + SI1 -> I1_CODIGO + DTOS(aInicioMes[1]),.t.) )
        While !Eof() .and. xFilial("SI2") == I2_FILIAL ;
		.and. I2_CREDITO == SI1->I1_CODIGO .And. I2_DATA <= dDataFinal

		IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
			dbSkip()
			Loop
		EndIF

		IF I2_DC $ "D-"
			dbSkip()
			Loop
		EndIF

		If I2_CCC < cCustoInicial .Or. I2_CCC > cCustoFinal
			dbSkip()
			Loop
		EndIf

		If I2_ITEMC < cItemInicial .Or. I2_ITEMC > cItemFinal
			dbSkip()
			Loop
		EndIf

                cDC   :="C"
                nValor:=SI2->I2_VALOR

                // Fun눯o cr060Temp

                cFlag:=""
                cConta:=""
                cCpar:=""
                cContaRepl:=""
                cCustoRepl:=""
                cItemRepl:=""

                nValor:=Iif(nValor==NIL,SI2->I2_VALOR,nValor)
                dbSelectArea ( "cNomeArq" )
                // 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                // � Caso o lan놹mento seja "X", define se � cr괺ito ou d괷ito �
                // 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                //cDc := iIf ( SI2 -> I2_CREDITO == SI1 -> I1_CODIGO, "C", "D" )
                Do Case
                   Case ( cDc == "C" )
                        cFlag := "C"
                        cConta:= "SI2 -> I2_CREDITO"
                        cCpar := "SI2 -> I2_DEBITO"
                   Case ( cDc == "D" )
                        cFlag := "D"
                        cConta:= "SI2 -> I2_DEBITO"
                        cCpar := "SI2 -> I2_CREDITO"
                EndCase

                // 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                // � Verifica se ha registro repetido no arquivo temporario    �
                // 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                cCodigo:=&cConta
                _cr060Join()
                IF lCentroDeCusto .And. lRetorno
                   cContaRepl :=        LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO) + ;
                                                 Space(20-Len(LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)))
                Else
                    cContaRepl := &cConta
                EndIF
                cCustoRepl      := Iif(cDC=="D",SI2->I2_CCD,SI2->I2_CCC)
                cItemRepl       := Iif(cDC=="D",SI2->I2_ITEMD,SI2->I2_ITEMC)

                // Deve permitir imprimir registros repetidos, pois no caso de consolidacoes
                // poderao existir lancamentos iguais!

                Reclock("cNomeArq",.T.)
                Replace DC     With cFlag
                Replace HISTOR WITH SI2->I2_HIST
                Replace NUMERO With SI2->I2_NUM
                cCodigo:= &cConta
                _cr060join()
                IF lCentroDeCusto .And. lRetorno
                   Replace CONTA WITH LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)
                Else
                   Replace CONTA With &cConta
                EndIF
                Replace CPAR    With &cCpar
                Replace LINHA   With SI2->I2_LINHA
                Replace VALOR   With nValor
                Replace DDATA    With SI2->I2_DATA
                Replace PERIODO With SI2->I2_PERIODO
                Replace CCUSTO  With cCustoRepl
                Replace ITEM     With cItemRepl
                Replace FILORIG With SI2->I2_FILORIG
                Replace EMPORIG With SI2->I2_EMPORIG

                MsUnlock()

                // Final da Fun눯o cr060Temp

		lNaoCred := .F.
		dbSelectArea("SI2")
		dbSkip()
	Enddo

	If lImp .And. lNaoDeb .And. lNaoCred .And. !lResumido
                nMoeda:=1
                _cr060NoMov()
	EndIf

   dbSelectArea("SI1")
   dbSkip()

EndDo

dbSelectArea("cNomeArq")
dbGoTop()

SetRegua(Reccount())

dDataLanc := cNomeArq->DDATA
While ( cNomeArq -> ( ! Eof () ) )

	#IFNDEF WINDOWS
		Inkey()
                If Lastkey() == 286
			lEnd := .T.
		EndIf
	#ENDIF

	IF lEnd
                @Prow()+1,0 PSAY "***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	IF (CONTA < cContaInicial .or. CONTA > cContaFinal)
		dDataLanc := cNomeArq->DDATA
		dbSkip()
		Loop
	EndIF

	IF li>56 .or. lSalto
		lSalto:=.F.
		IF m_pag > nPagInicial .and. cContAnt==CONTA
                        li:=li+1
                        @li,102 PSAY "A TRANSPORTAR : "
			If !lImpItem .And. !lImpCC
        @li,119 PSAY Abs(nSaldoAtu) Picture  tm(Abs(nSaldoAtu),12,,lEstrang)
        @li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,134,17,,.T.,lEstrang)
			EndIf
		EndIF
		If m_pag > m_pagfim
			m_pag := nReinicia
		EndIf
	  CabecCont(Titulo,Cabec1,Cabec2,nomeprog,;
	  				Iif(lImpItem .Or. lImpCC,"G",Tamanho),;
					Iif(lImpItem .Or. lImpCC .or. aReturn[4]==1,GetMv("MV_COMP"),;
					GetMv("MV_NORM")),dDataFinal,lFirstPage)
		li:=9
		lFirstPage := .F.
		IF nQuebra == 1
			dbSelectArea("cNomeArq")
			cDescricao := if(lEstrang,Substr(SI1->I1_DESCEST,1,60),Substr(SI1->I1_DESC,1,60))
			IF cContAnt == CONTA
				If cDigVer == "S"
                                        @li,011 PSAY Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
					mascara(Alltrim(SI1->I1_CODIGO)+SI1->I1_DC),SI1->I1_RES)+"-"+;
					cDescricao
				Else
                                        @li,011 PSAY Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
					mascara(SI1->I1_CODIGO),SI1->I1_RES)+"-"+cDescricao
				EndIf
                                @li,102 PSAY "DE TRANSPORTE : "
				If !lImpItem .And. !lImpCC
          @li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
          @li,131 PSAY Eval ( bSinal , nSaldoAtu )
				Else
					ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
				EndIf
				nSaldosDia := nSaldoAtu
                                li:=li+1
			EndIF
		EndIF
	EndIF

	IF nQuebra == 0
		dbSelectArea("cNomeArq")
		nQuebra:=1
		lImprAnt:=.F.
		cContAnt:=CONTA
		dbSelectArea("SI1")
                dbSeek(xFilial("SI1")+cContAnt)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Calcula o Saldo anterior ao periodo impresso                 �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		nSaldoAtu := CalcSaldo(Val(cMes17Ini)-1,1)
		nTotDeb:=0
		nTotCrd:=0
		dbSelectArea("cNomeArq")
	EndIF

	IF CONTA != cContAnt
		nQuebra 	:= 0
		IF lImprAnt
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� Imprime totais do dia, para opcao de s� totais.              �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If lResumido
                                li:=li+1
				@ li,000 PSAY dDataLanc
				If !lImpItem .And. !lImpCC
					@ li, 93 PSAY nDebitoDia  Picture tm(nDebitoDia,12,,lEstrang)
					@ li,106 PSAY nCreditDia  Picture tm(nCreditDia,12,,lEstrang)
          @ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
          @ li,131 PSAY Eval ( bSinal , nSaldosDia )
				Else
					ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
					ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
					ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
				EndIf
				nDebitoDia := nCreditDia := 0
				dDataLanc := cNomeArq->DDATA
			EndIf

                        li:=li+2
                        @li, 30 PSAY "T o t a i s  d a  C o n t a  ==> "
			If !lImpItem .And. !lImpCC
        @li, 90 PSAY nTotDeb     Picture tm(nTotDeb,12,,lEstrang)
				@li,106 PSAY nTotCrd     Picture tm(nTotCrd,12,,lEstrang)
        @li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
        @li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nTotDeb,li,109,17,,.F.,lEstrang)
				ValorContab(nTotCrd,li,131,17,,.F.,lEstrang)
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
                        li:=li+1
			@li,00 PSAY Replicate("-",nTamLinha)
                        li:=li+1
		EndIf
		If nSalto == 1
			lSalto := .T.
		Endif
		Loop
	EndIf
	dbSelectArea("cNomeArq")
	IF (DDATA >= dDataInicial .and. DDATA <= dDataFinal) .Or. Empty(DDATA)
		IF !lImprAnt
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� Imprime a 1a Conta Sint굏ica Anterior quando for anal죜ica   �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
                        _Cr060Sint()   //Retorna a 1a Conta Sint굏ica Anterior
			If cContaSint != cSintAnt .and. !lResumido
                                @li, 000 PSAY mascara(cContaSint) +"-"+ cDesc
                                li:=li+1
				cSintAnt := cContaSint
			Endif
			cDescricao := if(lEstrang,Substr(SI1->I1_DESCEST,1,60),Substr(SI1->I1_DESC,1,60))
			If cDigVer == "S"
                                @li,011 PSAY Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
                                mascara(Alltrim(SI1->I1_CODIGO)+SI1->I1_DC),SI1->I1_RES)+"-"+cDescricao
			Else
                                @li,011 PSAY Iif(nCodNor==1.Or.Empty(SI1->I1_RES),mascara(SI1->I1_CODIGO),SI1->I1_RES)+"-"+;
				cDescricao
			EndIf
			If !lImpItem .And. !lImpcc
                                @li,102 PSAY "SALDO ANTERIOR : "
			Else
                                @li,109 PSAY "SALDO ANTERIOR : "
			EndIf
			If !lImpItem .And. !lImpCC
        @li,119 PSAY Abs(nSaldoAtu)   Picture tm(Abs(nSaldoAtu),12,,lEstrang)
        @li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
                        li:=li+1
                        lImprAnt:=.T.
			nSaldosDia := nSaldoAtu
		EndIF
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Imprime totais do dia, para opcao de s� totais.              �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If lResumido
			If dDataLanc != cNomeArq->DDATA .And. cNomeArq->CONTA == cContAnt
                                li:=li+1
				@ li,000 PSAY dDataLanc
				If !lImpItem .And. !lImpCC
					@ li, 93 PSAY nDebitoDia  Picture tm(nDebitoDia,12,,lEstrang)
					@ li,106 PSAY nCreditDia  Picture tm(nCreditDia,12,,lEstrang)
          @ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
          @ li,131 PSAY Eval ( bSinal , nSaldosDia )
				Else
					ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
					ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
					ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
				EndIf
				nDebitoDia := nCreditDia := 0
			EndIf
			IF DC == "D"
                                nSaldosDia := nSaldosDia -  cNomeArq -> VALOR
                                nDebitoDia := nDebitoDia + cNomeArq -> VALOR
                                nSaldoAtu  := nSaldoAtu - VALOR
                                nTotDeb    := nTotDeb  + VALOR
			Else
                                nSaldosDia := nSaldosDia + cNomeArq -> VALOR
                                nCreditDia := nCreditDia + cNomeArq -> VALOR
                                nSaldoAtu  := nSaldoAtu + VALOR
                                nTotCrd    := nTotCrd   + VALOR
			EndIF

		Else    //IMPRIME TUDO
                        li:=li+1
			If !Empty(DDATA)
				@li,000 PSAY DDATA
				@li,011 PSAY SUBSTR(NUMERO,1,4)+"/"+Substr(NUMERO,5,6)+"-"+LINHA
			EndIf
      @li,028 PSAY HISTOR
            //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
            //� Tratamento para historico complementar                       �
            //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			dbSelectArea("SI2")
            dbSetOrder(3)
            IF ( dbSeek(xFilial("SI2")+Dtos(cNomeArq->DDATA)+cNomeArq->NUMERO+cNomeArq->LINHA+cNomeArq->EMPORIG+cNomeArq->FILORIG,.T.) )
				dbSkip()
                lComplHist := .T.
                While ( !Eof() .And. ;
                        SI2->I2_DATA == cNomeArq->DDATA       .And.;
                        SI2->I2_NUM  == cNomeArq->NUMERO     .And.;
                        lComplHist )
                     If ( I2_EMPORIG  == cNomeArq -> EMPORIG .And.;
                          I2_FILORIG  == cNomeArq -> FILORIG )
                        If ( SI2->I2_DC == "-" )
                           li:=li+1
                           @li,011 PSAY Substr(I2_NUM,1,4)+"/"+Substr(I2_NUM,5,6)+"-"+I2_LINHA
                           @li,026 PSAY I2_HIST
                        Else
                           lComplHist := .F.
                        EndIf
                     EndIf
                     dbSelectArea("SI2")
                     dbSkip()
                End
			EndIF
			dbSelectArea("cNomeArq")
			IF !Empty(CPAR)
        @li,068 PSAY TRIM(CPAR)
			EndIF

			IF lImpCC
				@li,088 PSAY CCUSTO
			Endif

			If lImpItem
                                @ li,098 PSAY ITEM
			EndIf

			IF DC == "D"
				If !lImpItem .And. !lImpCC
          @li,090 PSAY VALOR    Picture  tm(VALOR,12,,lEstrang)
				Else
					ValorContab(VALOR,li,109,17,,.F.,lEstrang)
				EndIf
                                nSaldoAtu:=nSaldoAtu-VALOR
                                nTotDeb  :=nTotDeb  +VALOR
			Else
				If !lImpItem .And. !lImpCC
          @li,106 PSAY VALOR    Picture tm(VALOR,12,,lEstrang)
				Else
					ValorContab(VALOR,li,131,17,,.F.,lEstrang)
				EndIf
                                nSaldoAtu:=nSaldoAtu+VALOR
                                nTotCrd  :=nTotCrd  +VALOR
			EndIF
			If !lImpItem .And. !lImpCC
        @li,119 PSAY Abs(nSaldoAtu)  Picture tm(Abs(nSaldoAtu),12,,lEstrang)
        @li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
		EndIf
	Else
		IF DC == "D"
                        nSaldoAtu:=nSaldoAtu-IIF(DDATA>dDataFinal,0,VALOR)
		Else
                        nSaldoAtu:=nSaldoAtu+IIF(DDATA>dDataFinal,0,VALOR)
		EndIF
	EndIf
	dDataLanc := cNomeArq->DDATA
	dbSkip( )

End

IF lImp .Or. ;
	(li != 80 .and. ( nTotDeb != 0 .or. nTotCrd != 0 ) .And. !lEnd)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Imprime totais do dia, para opcao de s� totais.              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If lResumido
                li:=li+1
		@ li,000 PSAY dDataLanc
		If !lImpItem .And. !lImpCC
			@ li,093 PSAY nDebitoDia      Picture tm(nDebitoDia,12,,lEstrang)
			@ li,106 PSAY nCreditDia      Picture tm(nCreditDia,12,,lEstrang)
      @ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
      @ li,131 PSAY Eval ( bSinal , nSaldosDia )
		Else
			ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
			ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
			ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
		EndIf
	EndIf

        li:=li+2
        @li, 30 PSAY "T o t a i s  d a  C o n t a  ==> "
	If !lImpItem .And. !lImpCC
    @li,090 PSAY nTotDeb        Picture tm(nTotDeb,12,,lEstrang)
		@li,106 PSAY nTotCrd        Picture tm(nTotCrd,12,,lEstrang)
    @li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
    @li,131 PSAY Eval ( bSinal , nSaldoAtu )
	Else
		ValorContab(nTotDeb,li,109,17,,.F.,lEstrang)
		ValorContab(nTotCrd,li,131,17,,.F.,lEstrang)
		ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
	EndIf
        li:=li+1
	@li,00 PSAY Repl("-",nTamLinha)
        li:=li+1
	Roda(cbcont,cbtxt,Iif(lImpItem .Or. lImpCC,"G",tamanho))
EndIF

If Li != 80 .Or. Select ( "cNomeArq" ) <> 0
	dbSelectArea("cNomeArq")
	Use
	Ferase(cNomeArq+".DBF")    	// Elimina arquivos de Trabalho
   Ferase(cNomeArq+OrdBagExt())	// Elimina arquivos de Trabalho
End

dbSelectarea("SI1")
dbSetOrder(1)
Set Filter To
dbSelectarea("SI2")
dbSetOrder(1)
#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Cr060Join� Autor � Wagner Xavier         � Data � 26.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Verifica se a conta sera agrupada por centro de custo      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Cr060Join(ExpC1)                                           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� tipo do lancamento                                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � CONR060                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> Function _cr060join
Static Function _cr060join()

lRetorno  := .T.
nRegistro := 0
cArea     := ALias ()

dbSelectArea ( "SI1" )
nRegistro := SI1 -> ( Recno () )
SI1 -> ( dbSeek ( xFilial("SI1") + cCodigo ) )
lRetorno := ( SI1 -> I1_NCUSTO != 0 )
SI1 -> ( dbGoto ( nRegistro ) )

dbSelectArea ( cArea )

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿎r060NoMov� Autor � Pilar S. Albaladejo   � Data � 18.04.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Cria registro para arquivo tempor쟲io para emiss꼘 do      낢�
굇�          � Raz꼘 com contas sem movimento                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Cr060NoMov()                                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � CONR060                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> Function _cr060NoMov
Static Function _cr060NoMov()

cContac:=""
nSal:=0
cAlias := Alias()
nReg:=0

If nMoeda == 1
	dbSelectArea("SI1")
Else
	dbSelectArea("SI7")
EndIf
nSal := CalcSaldo(Val(cMes17Ini),nMoeda)

If (Int(nSal*100)/100) != 0
	cConta := SI1->I1_CODIGO
	dbSelectArea ( "cNomeArq" )
	Reclock("cNomeArq",.t.)
        Replace HISTOR WITH "CONTA SEM MOVIMENTO NO PERIODO"
	Replace CONTA With cConta
	MsUnlock()
EndIf
dbSelectArea(cAlias)
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿎r060Sint � Autor � Alice Y. Yamamoto     � Data � 18.04.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Retorna a Conta sint굏ica Anterior                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Cr060Sint()                                                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � CONR060                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> Function _Cr060Sint
Static Function _Cr060Sint()
cOldArea := Alias()
nOldOrd   := IndexOrd()
lSint    := .T.
nTamConta :=0   //Tamanho da Conta
nPosSI1:=0    //Guarda a posicao no SI1

nPosSI1 := SI1->(Recno())
cContaSint   := cNomeArq->CONTA
cContaSint:=Alltrim(cContaSint)
nTamConta :=Len(cContaSint)
cContaSint:=Substr(cContaSint,1,nTamConta - 1 )
dbSelectArea("SI1")
dbSetOrder(1)

While lSint
	If	dbSeek(xFilial("SI1")+cContaSint)
		If SI1->I1_CLASSE =="S"
			If !lEstrang
				cDesc := SI1->I1_DESC
			Else
				cDesc := SI1->I1_DESCEST
			EndIf
			lSint := .F.
		Else
                        nTamConta:=nTamConta-1
			cContaSint:=Substr(cContaSint,1,nTamConta)
		Endif
	Endif
Enddo
dbGoTo(nPosSI1)
dbSelectArea(cOldArea)
dbSetOrder(nOldOrd)
Return


// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> FUNCTION _AjustaSx1
Static FUNCTION _AjustaSx1()
cAlias:=Alias()
aPerg := {}
cPerg := "COR060"
Aadd(aPerg,{"No. Pag Reiniciar ? ","N",4})
dbSelectArea("SX1")
If !dbSeek(cPerg+"19")
   RecLock("SX1",.T.)
   Replace X1_GRUPO     with cPerg
   Replace X1_ORDEM     with "19"
   Replace X1_PERGUNT   with aPerg[1][1]
   Replace X1_VARIAVL   with "mv_chg"
   Replace X1_TIPO      with aPerg[1][2]
   Replace X1_TAMANHO   with aPerg[1][3]
   Replace X1_GSC       with "G"
   Replace X1_VAR01     with "mv_par19"
   Replace X1_CNT01     With "2"
EndIf


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 15/04/03

