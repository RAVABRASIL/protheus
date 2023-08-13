#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIVRO0809 º Autor ³ Eurivan Marques    º Data ³  15/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Registro de controle da produção e do estoque, modelo 3.   º±±
±±º          ³ Relatório solicitado por Porto.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIVRO0809()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Registro de Controle da Produção e do Estoque"
Local cPict          := ""
Local titulo       	 := "Registro de Controle da Producao e do Estoque"
Local nLin         	 := 80
Local Cabec1       	 := "                                                                                            REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 		 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "LVRCTB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt     	 := Space(10)
Private cbcont     	 := 00
Private CONTFL    	 := 01
Private m_pag     	 := 02
Private cPerg        := "LVRCTB"
Private wnrel     	 := "LVRCTB" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !Pergunte(cPerg,.T.)
	return
endif

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***************


Local cCodAnt  := cMes := " "
Local nEstoque := nTotSai := nTotEnt := 0
Local _aStru := {}
Local _cTemp
Local nLin := 80

if MV_PAR01 == 1
	Private cNumOp01 := '10131109325'
	Private cNumOp02 := '10131111450'
	Private cNumOp03 := '10131123548'
	Private cNumOp04 := '10131134244'
	Private cNumOp05 := '10131143547'
	Private cNumOp06 := '10131156287'
	Private cNumOp07 := '10131162247'
	Private cNumOp08 := '10131169500'
	Private cNumOp09 := '10131172574'
	Private cNumOp10 := '10131182109'
	Private cNumOp11 := '10131191026'
	Private cNumOp12 := '10131202215'
elseif MV_PAR01 == 2
	Private cNumOp01 := '10131100325'
	Private cNumOp02 := '10131112450'
	Private cNumOp03 := '10131124548'
	Private cNumOp04 := '10131135244'
	Private cNumOp05 := '10131144547'
	Private cNumOp06 := '10131156287'
	Private cNumOp07 := '10131163247'
	Private cNumOp08 := '10131160500'
	Private cNumOp09 := '10131173574'
	Private cNumOp10 := '10131183109'
	Private cNumOp11 := '10131192026'
	Private cNumOp12 := '10131203215'
elseif MV_PAR01 == 3
	Private cNumOp01 := '10131101328'
	Private cNumOp02 := '10131113453'
	Private cNumOp03 := '10131125553'
	Private cNumOp04 := '10131136247'
	Private cNumOp05 := '10131145550'
	Private cNumOp06 := '10131157290'
	Private cNumOp07 := '10131164250'
	Private cNumOp08 := '10131161503'
	Private cNumOp09 := '10131174577'
	Private cNumOp10 := '10131184112'
	Private cNumOp11 := '10131193029'
	Private cNumOp12 := '10131204218'
ELSE
	Private cNumOp01 := '10131102331'
	Private cNumOp02 := '10131114456'
	Private cNumOp03 := '10131126556'
	Private cNumOp04 := '10131137250'
	Private cNumOp05 := '10131146553'
	Private cNumOp06 := '10131158293'
	Private cNumOp07 := '10131165253'
	Private cNumOp08 := '10131162506'
	Private cNumOp09 := '10131175580'
	Private cNumOp10 := '10131185115'
	Private cNumOp11 := '10131194032'
	Private cNumOp12 := '10131205221'

endif

aadd( _aStru , {"DOC"       , "C" , 09 , 00 } )
aadd( _aStru , {"PROD"      , "C" , 15 , 00 } )
aadd( _aStru , {"QUANTD3"   , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTIN"   , "N" , 14 , 02 } )
aadd( _aStru , {"SALDO"     , "N" , 14 , 02 } )
aadd( _aStru , {"DIFSLD"    , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTD1"   , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTD2"   , "N" , 14 , 02 } )
aadd( _aStru , {"EMISSAO"   , "C" , 08 , 00 } )
aadd( _aStru , {"SERIE"     , "C" , 03 , 00 } )
aadd( _aStru , {"CONTA"     , "C" , 10 , 00 } )
aadd( _aStru , {"CFOP"      , "C" , 04 , 00 } )
aadd( _aStru , {"TMOP"      , "C" , 03 , 00 } )
aadd( _aStru , {"TMIN"      , "C" , 03 , 00 } )
aadd( _aStru , {"BASEIPI"   , "N" , 14 , 02 } )
aadd( _aStru , {"VALIPI"    , "N" , 14 , 02 } )
aadd( _aStru , {"TPPRO"     , "C" , 02 , 00 } )
aadd( _aStru , {"TIPO"      , "C" , 01 , 00 } )

_cTemp := CriaTrab( _aSTRU, .T. )
Use (_cTemp) Alias TMP New Exclusive
Index On PROD+EMISSAO To (_cTemp)

SetRegua(0)

cQuery := "select  SD3.D3_OP, SD3.D3_COD, sum(SD3.D3_QUANT) TOTAL, SD3.D3_EMISSAO, SD3.D3_TM, SB1.B1_TIPO AS D3_TIPO "
cQuery += "from	"+ retSqlName('SD3') +" SD3, "+ retSqlName('SB1') +" SB1 "
cQuery += "where   SD3.D3_EMISSAO between "
if MV_PAR01 = 1
	cQuery += "'20080101' and '20081231' "
elseif MV_PAR01 == 2
	cQuery += "'20090101' and '20091231' "
elseif MV_PAR01 == 3
	cQuery += "'20100101' and '20101231' "
ELSE
	cQuery += "'20110101' and '20111231' "
endif
cQuery += "and SD3.D3_COD = SB1.B1_COD "
//cQuery += "and SD3.D3_COD in ("+cCodigs+") and SD3.D3_OP != '' "
cQuery += "and SD3.D3_COD in (SELECT CODIGO FROM SALDOS WHERE ANO = '"+if(MV_PAR01==1,'2008',if(MV_PAR01==2,'2009',if(MV_PAR01==3,'2010','2011')))+"' AND FILIAL='"+XFILIAL('SD3')+"' ) and SD3.D3_OP != '' "
cQuery += "and SD3.D3_FILIAL = '"+ xFilial('SD3') +"' and SD3.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*'"
cQuery += "group by SD3.D3_OP, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_TM, SB1.B1_TIPO "
cQuery += "having sum(SD3.D3_QUANT) > 0 "
cQuery += "order by SD3.D3_EMISSAO, SD3.D3_COD "
TCQUERY cQuery NEW ALIAS "TMPX"
TCSetField( 'TMPX', "D3_EMISSAO", "D")
TMPX->( dbGoTop() )

do while( !TMPX->( EoF() ) )
	TMP->( DBAppend() )
	TMP->DOC     := TMPX->D3_OP
	TMP->PROD    := TMPX->D3_COD
	TMP->QUANTD3 := TMPX->TOTAL
	TMP->QUANTD1 := 0
	TMP->QUANTD2 := 0
	TMP->EMISSAO := DTOS(TMPX->D3_EMISSAO)
	TMP->SERIE   := ""
	TMP->CONTA   := ""
	TMP->TMOP    := TMPX->D3_TM
	TMP->BASEIPI := 0
	TMP->VALIPI  := 0
	TMP->TIPO    := ""
	TMP->TPPRO   := TMPX->D3_TIPO
	TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()
endDo
TMPX->( dbCloseArea() )

cQuery := "select	SD2.D2_DOC, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_CF, SD2.D2_CONTA, SD2.D2_TOTAL, SD2.D2_BASEIPI, SD2.D2_VALIPI, SD2.D2_TIPO, SB1.B1_TIPO AS D2_TP "
cQuery += "from	"+ retSqlName('SD2') +" SD2, "+retSqlName('SB1') +" SB1 "
cQuery += "where SD2.D2_EMISSAO between "
if MV_PAR01 = 1
   cQuery += "'20080101' and '20081231' "
elseif MV_PAR01 == 2
   cQuery += "'20090101' and '20091231' "
elseif MV_PAR01 == 3
   cQuery += "'20100101' and '20101231' "   
else
   cQuery += "'20110101' and '20111231' "   
endif
//cQuery += "and SD2.D2_SERIE in ('UNI','0') and ( SD2.D2_COD in ("+cCodigs+") OR LEN(SD2.D2_COD) > 7 ) "
//cQuery += "and SD2.D2_SERIE in ('UNI','0') and ( SD2.D2_COD in ( SELECT CODIGO FROM SALDOS WHERE ANO = '"+if(MV_PAR01==1,'2008',if(MV_PAR01==2,'2009',if(MV_PAR01==3,'2010','2011')))+"' and FILIAL='"+XFILIAL('SD2')+"') OR LEN(SD2.D2_COD) > 7 ) "
cQuery += "and SD2.D2_SERIE in ('UNI','0') and ( SD2.D2_COD in ( SELECT CODIGO FROM SALDOS WHERE ANO = '"+if(MV_PAR01==1,'2008',if(MV_PAR01==2,'2009',if(MV_PAR01==3,'2010','2011')))+"' and FILIAL='"+XFILIAL('SD2')+"') ) "// SEM GENERICO 
cQuery += "and SD2.D2_COD = SB1.B1_COD "
cQuery += "and SD2.D2_FILIAL = '"+ xFilial('SD2') +"' and SD2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_DOC "
TCQUERY cQuery NEW ALIAS "TMPX"
TCSetField( 'TMPX', "D2_EMISSAO", "D")

TMPX->( dbGoTop() )

do while( !TMPX->( EoF() ) )
	TMP->( DBAppend() )
	TMP->DOC     := TMPX->D2_DOC
	TMP->PROD    := TMPX->D2_COD
	TMP->QUANTD3 := 0
	TMP->QUANTD1 := 0
	TMP->QUANTD2 := TMPX->D2_QUANT
	TMP->EMISSAO := DTOS(TMPX->D2_EMISSAO)
	TMP->SERIE   := TMPX->D2_SERIE
	TMP->CONTA   := TMPX->D2_CONTA
	TMP->CFOP    := TMPX->D2_CF
	TMP->BASEIPI := IIF(TMPX->D2_BASEIPI=0,TMPX->D2_TOTAL,TMPX->D2_BASEIPI)
	TMP->VALIPI  := TMPX->D2_VALIPI
	TMP->TIPO    := TMPX->D2_TIPO
	TMP->TPPRO   := TMPX->D2_TP
	TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()
endDo
TMPX->( dbCloseArea() )

cQuery := "select	SD1.D1_DOC, SD1.D1_COD, SD1.D1_QUANT, SD1.D1_TOTAL, SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_CF, SD1.D1_CONTA, SD1.D1_TOTAL, SD1.D1_BASEIPI, SD1.D1_VALIPI, SD1.D1_TIPO, SB1.B1_TIPO AS D1_TP "
cQuery += "from	"+ retSqlName('SD1') +" SD1, "+ retSqlName('SB1') +" SB1 "
cQuery += "where	SD1.D1_DTDIGIT between "
if MV_PAR01 = 1
   cQuery += "'20080101' and '20081231' "
elseif MV_PAR01 == 2
   cQuery += "'20090101' and '20091231' "
elseif MV_PAR01 == 3
   cQuery += "'20100101' and '20101231' "   
else
   cQuery += "'20110101' and '20111231' "   
endif
//cQuery += "and SD1.D1_SERIE in ('UNI','0') and ( SD1.D1_COD in ("+cCodigs+") OR LEN(SD1.D1_COD) > 7 ) "
//cQuery += "and SD1.D1_SERIE in ('UNI','0') and ( SD1.D1_COD in (SELECT CODIGO FROM SALDOS WHERE ANO = '"+if(MV_PAR01==1,'2008',if(MV_PAR01==2,'2009',if(MV_PAR01==3,'2010','2011')))+"' AND FILIAL = '"+ xFilial('SD1') +"' ) OR LEN(SD1.D1_COD) > 7 ) "
cQuery += "and SD1.D1_SERIE in ('UNI','0') and ( SD1.D1_COD in (SELECT CODIGO FROM SALDOS WHERE ANO = '"+if(MV_PAR01==1,'2008',if(MV_PAR01==2,'2009',if(MV_PAR01==3,'2010','2011')))+"' AND FILIAL = '"+ xFilial('SD1') +"' ) ) " // SEM GENERICO 
cQuery += "and SD1.D1_COD = SB1.B1_COD "
cQuery += "and SD1.D1_FILIAL = '"+ xFilial('SD1') +"' and SD1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by SD1.D1_COD, SD1.D1_DTDIGIT, SD1.D1_DOC "
TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( dbGoTop() )

TCSetField( 'TMPX', "D1_DTDIGIT", "D")

do while( !TMPX->( EoF() ) )// .and. nI > 0
	TMP->( DBAppend() )
	TMP->DOC     := TMPX->D1_DOC
	TMP->PROD    := TMPX->D1_COD
	TMP->QUANTD3 := 0
	TMP->QUANTD1 := TMPX->D1_QUANT
	TMP->QUANTD2 := 0
	TMP->EMISSAO := DTOS(TMPX->D1_DTDIGIT)
	TMP->SERIE   := TMPX->D1_SERIE
	TMP->CONTA   := TMPX->D1_CONTA
	TMP->CFOP    := TMPX->D1_CF
	TMP->BASEIPI := IIF(TMPX->D1_BASEIPI=0,TMPX->D1_TOTAL,TMPX->D1_BASEIPI)
	TMP->VALIPI  := TMPX->D1_VALIPI
	TMP->TIPO    := TMPX->D1_TIPO
	TMP->TPPRO   := TMPX->D1_TP
	TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()
endDo

TMPX->( dbCloseArea() )

Marreta()

//         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cCabec0 := "PRODUTO          |                                                                                 |          UNIDADE          |                        CLASSIFICACAO FISCAL                     |      |      |           |"
cCabec1 := "                 |                                                                                 |                           |                                                                 |      |      |           |"
cCabec2 := "           DOCUMENTO             |              LANCAMENTO              |                   ENTRADAS                         |    IPI   |                   SAIDAS                                       |  ESTOQUE  | OBS |"
cCabec3 := "Especie|Serie|  Numero   | Data  |Registros Fiscais|   Codificacao      |        Producao(Qtd)       |  Diversas  |   Valor  |          |          Producao (Qtd)      |  Diversas  |    Valor |   Ipi   |                 |"
cCabec4 := "       |Subs.|           |Dia|Mes|RE/RS| No |Folhas| Contabil   | Fiscal| No estabelec. | Em out.est.|    QTD.    |          |          |   No estabelec. | Em out.est.|     QTD.   |          |         |                 |"


DbSelectArea("TMP")
TMP->(DbGotop())

while !TMP->(EOF())
	
	if lAbortPrint
		@Prow() + 1,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	endif
	
	if (cCodAnt != TMP->PROD) .OR. (nLin > 55) //colocar o bloco abaixo dentro de uma função
		if MV_PAR01 = 1 //2008
		   if m_pag > 392
		      m_pag := 2
		   endif   
		elseif MV_PAR01 == 2 //2009
		   if m_pag > 349
		      m_pag := 2
		   endif   
		elseif MV_PAR01 == 3 //2010
		   if m_pag > 454
		      m_pag := 2
		   endif   	
		else
		   if m_pag > 349
		      m_pag := 2
		   endif   	
		
		endif   
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		
		@ nLin,000 PSAY cCabec0
		nLin += 1
		@ nLin ,000 PSAY cCabec1
		dbSelectArea('SB1')
		SB1->( dbSetOrder( 1 ) )
		SB1->( dbSeek( xFilial('SB1') + TMP->PROD ) )
		@ nLin    ,000 PSAY alltrim(TMP->PROD)
		@ nLin	 ,023 PSAY alltrim(SB1->B1_DESC)
		@ nLin	 ,111 PSAY alltrim(SB1->B1_UM)
		nLin += 1
		@ nLin ,000 PSAY Repl('-',220)
		SB1->( dbCloseArea() )
		nLin += 1
		@ nLin,000 PSAY cCabec2
		nLin += 1
		@ nLin,000 PSAY cCabec3
		nLin += 1
		@ nLin,000 PSAY cCabec4
		nLin += 1
		@ nLin,000 PSAY Repl('-',220)
	endIf
	
	nTotEnt := nTotSai := 0 //estoque mensal
	if cCodAnt != TMP->PROD //zerando o cálculo do estoque do novo produto
		if MV_PAR01 = 1
		   nEstoque := saldo( TMP->PROD, "2007" )  //estoque total do produto
		elseif MV_PAR01 = 2
		   nEstoque := saldo( TMP->PROD, "2008" )  //estoque total do produto		
		elseif MV_PAR01 = 3
		   nEstoque := saldo( TMP->PROD, "2009" )  //estoque total do produto				   
		else
		   nEstoque := saldo( TMP->PROD, "2010" )  //estoque total do produto				   		
		endif
	endIf
	
	cMes    := substr(TMP->EMISSAO,5,2)
	cCodAnt := TMP->PROD
	
	while !TMP->(EOF()) .AND. cCodAnt == TMP->PROD .AND. cMes == substr(TMP->EMISSAO,5,2)
		if nLin > 55
			if MV_PAR01 = 1 //2008
			   if m_pag > 392
			      m_pag := 2
			   endif   
			elseif MV_PAR01 = 2 //2009
			   if m_pag > 349
			      m_pag := 2
			   endif   
			elseif MV_PAR01 = 3 //2010
			   if m_pag > 349
			      m_pag := 2
			   endif   
			else //2011
			   if m_pag > 349
			      m_pag := 2
			   endif   			   
			endif   
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			@ nLin,000 PSAY cCabec0
			nLin += 1
			@ nLin ,000 PSAY cCabec1
			dbSelectArea('SB1')
			SB1->( dbSetOrder( 1 ) )
			SB1->( dbSeek( xFilial('SB1') + TMP->PROD ) )
			@ nLin    ,000 PSAY alltrim(TMP->PROD)
			@ nLin	 ,023 PSAY alltrim(SB1->B1_DESC)
			@ nLin	 ,111 PSAY alltrim(SB1->B1_UM)
			nLin += 1
			@ nLin ,000 PSAY Repl('-',220)
			SB1->( dbCloseArea() )
			nLin += 1
			@ nLin,000 PSAY cCabec2
			nLin += 1
			@ nLin,000 PSAY cCabec3
			nLin += 1
			@ nLin,000 PSAY cCabec4
			nLin += 1
			@ nLin,000 PSAY Repl('-',220)
		endif
		
		if TMP->QUANTD3 > 0
			nLin += 1
			if Len(AllTrim(TMP->PROD)) < 7
				@ nLin, 002 PSAY "OP"
				
				if TMP->QUANTD1 = 0 .AND. TMP->QUANTD2 = 0
					@ nLin, 014 PSAY TMP->DOC  //documento
				else
					&("cNumOp"+cMes) := Soma1( &("cNumOp"+cMes) )
					@ nLin, 014 PSAY &("cNumOp"+cMes)  //documento
				endif
			else
				@ nLin, 002 PSAY "  "
			endif
			
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2) //dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2) //mes
			
			if TMP->TMOP < '500'
				@ nLin, 036 PSAY "RE"
			else
				@ nLin, 036 PSAY "RS"
			endif
			
			if Len(AllTrim(TMP->PROD)) < 7
				if TMP->TMOP > '499'
					@ nLin, 137 PSAY Transform( TMP->QUANTD3,"@E 9,999,999.99" )
				else
					@ nLin, 073 PSAY Transform( TMP->QUANTD3,"@E 9,999,999.99" )
				endif
			else
				if TMP->TMOP > '499'
					@ nLin, 168 PSAY Transform( TMP->QUANTD3,"@E 999,999.99" )
				else
					@ nLin, 089 PSAY Transform( TMP->QUANTD3,"@E 999,999.99" )
				endif
			endif
			
			if TMP->TMOP < '500'
				nEstoque += TMP->QUANTD3
				nTotEnt  += TMP->QUANTD3
			else
				nEstoque -= TMP->QUANTD3
				nTotSai  += TMP->QUANTD3
			endif
			
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif
		
		if TMP->QUANTIN > 0
			nLin += 1
			@ nLin, 002 PSAY "  "
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2) //dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2) //mes
			@ nLin, 036 PSAY iif(Alltrim(TMP->TMIN) < "500", "RE", "RS")
			if Alltrim(TMP->TMIN) < "500"
				@ nLin, 089	PSAY Transform( TMP->QUANTIN,"@E 999,999.99" )
			else
				@ nLin, 168	PSAY Transform( TMP->QUANTIN,"@E 999,999.99" )
			endif
			if Alltrim(TMP->TMIN) < "500"   
				nEstoque += (TMP->QUANTIN)
				nTotEnt  += TMP->QUANTIN
			else
				nEstoque -= (TMP->QUANTIN)
				nTotSai  += TMP->QUANTIN
			endif
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif
		
		If TMP->QUANTD2 > 0
			nLin += 1
			@ nLin, 002 PSAY "NF"
			@ nLin, 014 PSAY AllTrim(TMP->DOC) //documento
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2)//dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2)//mes
			@ nLin, 036 PSAY "RS"
			@ nLin, 052 PSAY SUBSTR(TMP->CONTA,1,10) 				 //Conta contabil
			@ nLin, 065 PSAY Alltrim(TMP->CFOP) //Codigo fiscal
			@ nLin, 137 PSAY Transform( TMP->QUANTD2,"@E 999,999.99" ) //Quantidade vendida do item
			@ nLin, 181 PSAY Transform( TMP->BASEIPI,"@E 999,999.99" )			 //IPI
			@ nLin, 192 PSAY Transform( TMP->VALIPI,"@E 9,999.99" )			 //IPI
			nEstoque -= TMP->QUANTD2
			nTotSai  += TMP->QUANTD2
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif
		
		If TMP->QUANTD1 > 0
			nLin += 1
			@ nLin, 002 PSAY "NF"
			@ nLin, 014 PSAY AllTrim(TMP->DOC) //documento
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2)//dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2)//mes
			@ nLin, 036 PSAY "RE"
			@ nLin, 052 PSAY SUBS(TMP->CONTA,1,10)					//Conta contabil
			@ nLin, 065 PSAY alltrim(TMP->CFOP)//Codigo fiscal
			@ nLin, 073 PSAY Transform( TMP->QUANTD1,"@E 999,999,999.99" ) //Quantidade devolvida do item
			@ nLin, 115 PSAY Transform( TMP->BASEIPI,"@E 999,999.99" ) 		  //BASE IPI
			@ nLin, 126 PSAY Transform( TMP->VALIPI,"@E 9,999.99" ) 		  //VALOR IPI
			nEstoque += TMP->QUANTD1
			nTotEnt  += TMP->QUANTD1
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endIf
		incRegua()
		TMP->(DbSkip())
	end
	nLin += 1
	@ nLin, 026 PSAY "Totais do mes "+ cMes
	
	@ nLin, 048 PSAY "Entradas:  " + Transform( nTotEnt,"@E 999,999.99" )
	@ nLin, 075 PSAY "Saidas:  " + Transform( nTotSai,"@E 999,999.99" )
end

TMP->(DbCloseArea())

//__CopyFIle(_cTemp+".DBF", "C:\"+_ctemp+".XLS")

Ferase(_cTemp+".DBF")
Ferase(_cTemp+OrdBagExt())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************
Static Function marreta()
***************

local cProd
local nInv := nDifSld := nSldPro := nSldIni := nSldFim := 0
local nSldMov := nEntAc := nD3 := nTotD3 := nTotD1 := nTotD2 := 0
local cData

DbSelectArea("TMP")
DbSetOrder(1)

TMP->(DbGotop())

while !TMP->(EOF())
	cProd   := TMP->PROD
	if MV_PAR01 = 1
	   nSldPro := Saldo( cProd, "2007" )
	elseif MV_PAR01 = 2
	   nSldPro := Saldo( cProd, "2008" )	   
	elseif MV_PAR01 = 3
	   nSldPro := Saldo( cProd, "2009" )	   	   
	else
	   nSldPro := Saldo( cProd, "2010" )	   	   
	endif
	
	if MV_PAR01 = 1
	   nSldFim := Saldo( cProd, "2008" )
	elseif MV_PAR01 = 2
	   nSldFim := Saldo( cProd, "2009" )	   
	elseif MV_PAR01 = 3
	   nSldFim := Saldo( cProd, "2010" )	   	   
	else
	   nSldFim := Saldo( cProd, "2011" )	   	   
	endif   
	nDifSld := 0
	nReg := TMP->(Recno())
	
	while !TMP->(EOF()) .AND. cProd = TMP->PROD
		cData  := TMP->EMISSAO
		while !TMP->(EOF()) .AND. cProd = TMP->PROD .AND. TMP->EMISSAO = cData
			//Ajuste para naum ficar negativo o saldo da movimentacao
			if TMP->TMOP > '499'
				nSldPro += (TMP->QUANTD1-TMP->QUANTD3-TMP->QUANTD2)+nDifSld
			else
				nSldPro += (TMP->QUANTD3+TMP->QUANTD1-TMP->QUANTD2)+nDifSld //original
			endif
			
			if nSldPro < 0
				nDifSld := ABS( nSldPro ) //original
				if TMP->TMOP > '499'
					nD3     := TMP->QUANTD3 - ABS( nSldPro )
				else
					nD3     := ABS( nSldPro ) + TMP->QUANTD3 //original
				endif
			else
				nDifSld := 0
				nD3     := TMP->QUANTD3
			endif
			
			RecLock("TMP",.F.)
			TMP->SALDO    := nSldPro+nDifSld
			TMP->QUANTD3  := nD3
			TMP->DIFSLD   := nDifSld
			MsUnLock()
			TMP->(DbSkip())
			IncRegua()
		end
	end
	nReg := TMP->(Recno())
	
	TMP->(DbSkip(-1))
	
	if TMP->SALDO # nSldFim
		nDifSld := TMP->SALDO - nSldFim
		RecLock("TMP",.F.)
		TMP->QUANTIN := ABS(nDifSld)
		if nDifSld > 0
			TMP->TMIN    := "500"
		else
			TMP->TMIN    := "100"
		endif
		MSUnlock()
	endif
	TMP->(dbGoto(nReg))
end

Return


//Retorna o saldo final do produto no ano
//Parametros Produto e Ano
***********************************
Static Function Saldo( cCod, cAno )
***********************************

Local nSaldo := 0
cQuery := "SELECT * FROM SALDOS where CODIGO = '"+cCod+"' AND ANO = '"+cAno+"' AND FILIAL = '"+ xFilial('SD1') +"' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPR"
TMPR->( dbGoTop() )
nSaldo := TMPR->QUANT
TMPR->(	dbCloseArea() )

Return nSaldo