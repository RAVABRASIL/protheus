#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR025
//Objetivo: Relatório 04 - CLIENTES INATIVOS - SACOS (NÃO Compram há mais de 120 Dias)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 25/11/2010
//Alterações:
//FR : 05/04/2011  - Atendendo ao chamado 002064
//Alterar período de análise de 90 para 120 dias
//Retirar do relatório clientes inativos com pendências financeiras >= 120 dias  
//AGENDAMENTO: semanal, toda 6a. feira - TODOS COORDENADORES
//AGENDAMENTO:  Flavia Leite e cada representante recebe o seu Todo 1o. dia útil do mês.

//Alterado por Flavia Rocha em 18/10/2011 conforme solicitado por Janderley:
***********************************************************************************
EMAIL DE 21/09/2011 - Janderley
Favor providenciar a alteração conforme solicitado por Marcos Cunha e 
colocar nesse relatório a denominação: CLIENTES PRIVADOS.
Nesses mesmos dois relatórios, 3 e 4, incluir três colunas:

Nr. Licit.    Saldo a Fornecer    Produto(Família)

Esse relatório com as colunas acima sair com a denominação: CLIENTES PÚBLICOS.
Marcos irá abrir o chamado para o relatório com a denominação: CLIENTES PRIVADOS.
Janderley irá abrir o chamado para o relatório com a denominação: CLIENTES PÚBLICOS.

SDS

Janderley
***********************************************************************************
NOVA ALTERAÇÃO - 08/11/11 - CHAMADOS 002372 E 002373 DE 04/11/11
Fazer as modificações no RELATÓRIO 03 conforme modelo abiaxo somente para ORGÃOS PÚBLICOS:

Relatório 03 - VENDA DE SACOS POR CLIENTES(PÚBLICOS) ATIVOS (COMPRARAM NOS ÚLTIMOS 60 DIAS) - POR REPRESENTANTE

ÚLTIMO PEDIDO ÚLTIMA LICITAÇÃO
R$ KG DATA DIGITAÇÃO NR LICITAÇÃO SALDO FORNECER(R$) SALDOFORNECER(KG) PRODUTO/FAMILIA

***********************************************************************************
NOVA ALTERAÇÃO: EMAIL DE FLAVIA VIANA - 20/04/12 - MUDANÇA NO AGENDAMENTO: TODO DIA 1o. do mês:
CLIENTES PRIVADOS VAI PARA: JACQUELINE E FLAVIA NORAT
Dia 1o.:
- Relatório 04 - Venda de SACOS/CAIXAS por Clientes (Privados)Inativos 
(ENVIO MENSAL todo dia 1o. de cada mês, para os Coordenadores Flavia Norat e Jaqueline Melo responsáveis por tais clientes)

Dia 1o.:
CLIENTES PÚBLICOS VAI PARA: FLAVIO ALVES
- Relatório 04 - Venda de SACOS/CAIXAS por Clientes (Públicos) Inativos
(ENVIO MENSAL todo dia 1o. de cada mês, para os Coordenador Flavio Alves responsável por tais clientes)

SEMANAL, TODA 6A. FEIRA:
PARA OS DEMAIS, CONTINUA O ENVIO SEMANAL TODA 6A.FEIRA

//AGENDAMENTO: semanal, toda 6a. feira - TODO o restante dos COORDENADORES
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR025()
************************************


Private lDentroSiga := .F.
Private nFamilia := 0
Private nTipoCli := 0
Private nDIASINAT:= 0


/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0 

  	//RPCSetType( 3 )
   	//Habilitar somente para Schedule
	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	//sleep( 5000 )
  
  	//f25()	//chama a função do relatório
  	
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  nFamilia := 1
  nTipoCli := 1  
  f25( nFamilia, nTipoCli )       //tipo = 1 - Sacos / clientes privados
  
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  nFamilia := 1
  nTipoCli := 2   
  f25( nFamilia, nTipoCli )       //tipo = 1 - Sacos  / clientes públicos  *
  

  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  nFamilia := 2
  nTipoCli := 1 
  nDIASINAT:= 121  
  f25( nFamilia, nTipoCli, nDIASINAT )       //tipo = 2 - Caixas / clientes privados


  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  nFamilia := 2
  nTipoCli := 2
  nDIASINAT:= 121   
  f25( nFamilia, nTipoCli, nDIASINAT )        //tipo = 2 - Caixas / clientes públicos
  
Else
  lDentroSiga := .T.
  Pergunte("FATR025",.T.)    //INFORME O VENDEDOR
	nFamilia := mv_par05
	nTipoCli := mv_par06
	If !Empty(mv_par07)
    	nDIASINAT:= mv_par07
 	Else
 		nDIASINAT:= 121
 	Endif
  f25( nFamilia, nTipoCli, nDIASINAT)
  
EndIf
  

Return

************************************
Static Function f25( nFamilia, nTipoCli, nDIASINAT )
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório 04 - CLIENTES INATIVOS - nFam - (NÃO Compraram nos últimos 120 Dias)"
Local cPict          := ""



//Local Cabec1         := "Relatorio de Acompanhamento por Cliente  -  " + StrZero( Year( dDatabase), 4 ) + ""

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR025" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR025" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR025"
Private cString := ""
Private titulo         := "" 


Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 

//Private cWeb		:= Space(2000)
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private nLinhas		:= 80 
Private nLin        := 80
Private cRegiao     :=" "
Private cCodRepre 	:= ""
Private cUfRepre    := ""
Private cNomeRepre	:= ""
Private cMailRepre	:= ""

Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nCta		:= 0

Private cDir		:= ""
Private cArq		:= ""
Private cFamilia    := ""
Private cTipoCli	:= ""
Private nTotUltRS := 0
Private nTotUltKG := 0 

If nFamilia = 1
	cFamilia := "SACOS"
Elseif nFamilia = 2
	cFamilia := "CAIXAS"
Endif

If nTipoCli = 1
	cTipoCli := "PRIVADOS"
Else
	cTipoCli := "PUBLICOS"
Endif

titulo         := "Relatorio 04 - CLIENTES (" + cTipoCli + ") INATIVOS - " + cFamilia + " - (NAO COMPRAM HA MAIS DE 120 DIAS) - "

If lDentroSiga
	
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    If MsgYesNo("Deseja Gerar o Relatório 04 ? ")
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin ) },Titulo)
	Endif
Else
	RunReport(Cabec1,Cabec2,Titulo,nLin )
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

**********************************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin )
**********************************************************************
Local nOrdem

Local cQuery:=''
Local cQuery2:= ""
Local cQuery2 := ""
Local nQTD:=0 
Local aDadRe	:= {}
Local aDadRep := {}

Local nTotPM1 := 0
Local nTotPM2 := 0   
Local nTotPM3 := 0
Local nTotPM4 := 0
Local nTotPM5 := 0
Local nTotPM6 := 0
   
Local nTotVM1 := 0
Local nTotVM2 := 0   
Local nTotVM3 := 0
Local nTotVM4 := 0
Local nTotVM5 := 0
Local nTotVM6 := 0

Local nTotCartR:= 0
Local nTotCartK:= 0
Local nMedia   := 0
Local nMediaKG := 0
Local nTotMedia:= 0
Local nTotMedKG:= 0
Local cRepreAnt:= "" 
Local cUltimaComp := ""
Local cAtivo	:= ""
Local cCodUser	:= ""
Local cMailTo	:= "" 
Local cCopia	:= ""
Local cAssun	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Local nRegTot	:= 0
Local dUltima	:= Ctod("  /  /    ")
Local nHandle
Local nHand
Local cCliente	:= ""
LOCAL cCliUf    := ""
Local cLoja		:= ""
Local cCliAnt	:= ""
Local cLjAnt	:= "" 
Local aPendentes:= {}
Local nDiaSemana:= 0

Local cSegmento := "" 
Local cContato  := ""
Local cTel      := ""
Local lDir		:= .F.
Local aLici     := {}
Local cLiciprod   := ""
Local cLici		:= ""
Local nLiciSaldo  := 0
Local cWeb		:= ""
Private lEhSexta  := .F.
Private lEnviou   := .F.
Private DATAUSO   := CTOD("  /  /    ")
////VERIFICA O DIA DA SEMANA, SE FOR UMA 2A. FEIRA FAZ O ENVIO PARA FLÁVIA LEITE

//nDiaSemana := DOW( dDatabase )
DATAUSO := dDatabase            
nDiaSemana := DOW( DATAUSO )
If nDiaSemana = 6
	lEhSexta := .T.
Endif


/*
//MV_PAR01 - DO VENDEDOR
//MV_PAR02 - ATÉ VENDEDOR
//MV_PAR03 - COORDENADOR ?
//MV_PAR04 - IMPRIME APENAS: 1 - EXISTE COMERCIALMENTE / 2 - NAO EXISTE COMERCIALMENTE / 3 - TODOS
*/


///reune todos os clientes com pendências financeiras e adiciona ao array aPendentes
cQuery += " Select A3_SUPER, A1_COD,A1_LOJA,A1_VEND, E1_BAIXA  from "
cQuery += " " + RetSqlName("SE1") + " SE1, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 " + LF

cQuery += " where (SA1.A1_COD + SA1.A1_LOJA) = (SE1.E1_CLIENTE + SE1.E1_LOJA) " + LF
cQuery += " and SA1.A1_VEND = SA3.A3_COD " + LF
cQuery += " and SE1.E1_VEND1 = SA3.A3_COD " + LF
cQuery += " and SE1.E1_VEND1 = SA1.A1_VEND " + LF

cQuery += " and SE1.E1_FILIAL = '" + xFilial("SE1") + "' " + LF
cQuery += " and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " + LF
cQuery += " and SA3.A3_FILIAL = '" + xFilial("SA3") + "' " + LF

cQuery += " and SE1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA3.D_E_L_E_T_ = '' " + LF


If lDentroSiga
	If mv_par04 = 1
		cQuery += " AND A1_EXISCOM <> 'N' " + LF
	Elseif mv_par04 = 2
		cQuery += " AND A1_EXISCOM = 'N' " + LF
	Endif
	 
	cQuery += " AND (E1_VEND1) >= '" + Alltrim(MV_PAR01) + "' AND (E1_VEND1) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND (A3_SUPER) = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif	

Else
	cQuery += " AND A1_EXISCOM <> 'N' " + LF		//se for via schedule já escolhe apenas os que existem comercialmente
	cQuery += " AND (E1_VEND1) >= ''  AND (E1_VEND1) <= 'ZZZZZZ' " + LF 
	
	//If lEhSexta
	//	cQuery += " AND (A3_SUPER) <> '0255' " + LF		
	//Endif
	//If Substr(DtoS(DATAUSO),7,2) = "01" //no dia 1 de cada mês, só executa o de Flávia Leite (0255)
	//	cQuery += " AND (A3_SUPER) = '0255' " + LF	
	//Else
	//	cQuery += " AND (A3_SUPER <> '0255' or A3_COD <> '0255' ) " + LF		
	//Endif
	

	/*
	If Substr(DtoS(DATAUSO),7,2) = "01" //no dia 1o. de cada mês, só executa estes abaixo: Flávio Alves, Flávia Norat e Jacqueline
		cQuery += " AND  ( A3_SUPER IN (  '0315' , '0316', '0320' ) " + LF
		cQuery += "    OR   A3_COD IN (  '0315' ,  '0316', '0320' )  )" + LF 
	Elseif lEhSexta  
		cQuery += " AND  ( A3_SUPER  NOT IN ( '0255' , '0315' , '0316' , '0320' ) " + LF
		cQuery += "    and   A3_COD NOT IN ( '0255' , '0315' , '0316' , '0320' )  )" + LF
	Endif
	*/	
	
	//cQuery += " AND A3_SUPER = '0316' " + LF	//retirar

		
Endif
cQuery += " AND A1_ATIVO <> 'N' " + LF 

//cQuery += " and E1_VENCTO <= '" + DtoS(DATAUSO - 121) + "' " + LF
cQuery += " and E1_VENCTO <= '" + DtoS(DATAUSO - nDIASINAT) + "' " + LF
cQuery += " and E1_BAIXA = '' " + LF
cQuery += " Group by A3_SUPER, A1_COD,A1_LOJA,A1_VEND, E1_BAIXA  " + LF
cQuery += " order by A1_COD, A1_LOJA " + LF
MemoWrite("C:\Temp\cli_pend.sql",cQuery)

If Select("FINX") > 0
	DbSelectArea("FINX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FINX"

FINX->( DbGoTop() )

While FINX->( !EOF() )
	Aadd( aPendentes, Alltrim(FINX->A1_COD + FINX->A1_LOJA) )
	FINX->(DBSKIP())
Enddo

DbSelectArea("FINX")
DbCloseArea()
////////////FIM QUERY PENDÊNCIAS FINANCEIRAS //////////////////////


cQuery := " SELECT  A1_EST,CASE WHEN A3_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte' " + LF
cQuery += "                ELSE CASE WHEN A3_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste' " + LF
cQuery += "                ELSE CASE WHEN A3_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste' " + LF
cQuery += "                ELSE CASE WHEN A3_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste' " + LF
cQuery += "                ELSE CASE WHEN A3_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE '' END  END END END END REGIAO, A3_EST " + LF

cQuery += " ,SA3.A3_NOME, SA1.A1_COD, SA1.A1_LOJA, A1_NOME, SA3.A3_GEREN " + LF
//emails dos assistentes de vendas
//cQuery += " , A3_ASSIST1, A3_ASSIST2, A3_ASSIST3 " + LF

cQuery += " , SA1.A1_VEND " + LF
cQuery += " , A1VEND = CASE WHEN SA1.A1_VEND LIKE ('%VD') THEN LEFT(SA1.A1_VEND,4) ELSE SA1.A1_VEND END " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SA1.A1_VEND AND ( (A3_SUPER) <> '' OR (A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " ,SA3.A3_EMAIL, SA3.A3_ATIVO, SA1.A1_SATIV1, SA1.A1_CONTATO, SA1.A1_TEL " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

cQuery += " WHERE " + LF
cQuery += " SA3.A3_ATIVO <> 'N' " + LF 
cQuery += " AND SA3.A3_COD = SA1.A1_VEND " + LF
If nTipoCli = 1
	cQuery += " AND SA1.A1_SATIV1 <> '000009' " + LF // EXCLUI OS ÓRGÃOS PÚBLICOS
Else
	cQuery += " AND SA1.A1_SATIV1 = '000009' " + LF // somente ÓRGÃOS PÚBLICOS
Endif

If lDentroSiga
	If mv_par04 = 1
		cQuery += " AND SA1.A1_EXISCOM <> 'N' " + LF
	Elseif mv_par04 = 2
		cQuery += " AND SA1.A1_EXISCOM = 'N' " + LF
	Endif	 
	cQuery += " AND SA1.A1_VEND >= '" + Alltrim(MV_PAR01) + "' AND SA1.A1_VEND <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND SA3.A3_SUPER = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif	

Else
	cQuery += " AND SA1.A1_EXISCOM <> 'N' " + LF		//se for via schedule já escolhe apenas os que existem comercialmente
	cQuery += " AND SA1.A1_VEND >= ''  AND SA1.A1_VEND <= 'ZZZZZZ' " + LF 	
	
	//If Substr(DtoS(DATAUSO),7,2) = "01" //no dia 1 de cada mês, só executa o de Flávia Leite (0255)
	//	cQuery += " AND ( SA3.A3_SUPER = '0255' or SA3.A3_COD = '0255' )" + LF
	//Else
	//	cQuery += " AND (SA3.A3_SUPER <> '0255' or SA3.A3_COD <> '0255' ) " + LF	
	//Endif
	
	
	/*
	If Substr(DtoS(DATAUSO),7,2) = "01" //no dia 1o. de cada mês, só executa estes abaixo: Flávio Alves, Flávia Norat e Jacqueline
		cQuery += " AND  ( A3_SUPER IN (  '0315' , '0316', '0320' ) " + LF
		cQuery += "    OR   A3_COD IN (  '0315' ,  '0316', '0320' )  )" + LF 
	Elseif lEhSexta
		cQuery += " AND  ( A3_SUPER  NOT IN ( '0255' , '0315' , '0316' , '0320' ) " + LF
		cQuery += "    and   A3_COD NOT IN ( '0255' , '0315' , '0316' , '0320' )  )" + LF
	Endif
	*/
	
	//cQuery += " AND A3_SUPER = '0316' " + LF   //JACQUE //retirar
	//cQuery += " AND A3_SUPER = '0228' " + LF   //JOJÓ //retirar
	//cQuery += " AND A3_SUPER = '0342' " + LF   //LUIS FIGUERA //retirar
	//cQuery += " AND A3_SUPER = '0229' " + LF   //MARCILIO //retirar
	//cQuery += " AND A3_EST IN ('MG', 'ES', 'RJ', 'SP') " + LF 		

Endif

cQuery += " AND A3_EST <> '' " + LF 
cQuery += " AND A1_ATIVO <> 'N' " + LF 
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += " GROUP BY A1_EST,A3_EST,SA1.A1_VEND , SA1.A1_COD, SA1.A1_LOJA, SA3.A3_NOME, SA1.A1_NOME, SA3.A3_GEREN, SA3.A3_SUPER, SA3.A3_EMAIL " + LF
cQuery += " , SA3.A3_ATIVO, SA1.A1_SATIV1, SA1.A1_CONTATO, SA1.A1_TEL " +LF
IF lDentroSiga
   cQuery += " ORDER BY SA3.A3_SUPER, SA1.A1_VEND, SA1.A1_COD, SA1.A1_LOJA " +LF
else
   cQuery += " ORDER BY REGIAO,SA3.A3_SUPER, SA1.A1_VEND, SA1.A1_COD, SA1.A1_LOJA " +LF
endif
MemoWrite("C:\Temp\fatr025.sql", cQuery )
          
If Select("REP") > 0
	DbSelectArea("REP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "REP"
REP->( DbGoTop() )

While REP->( !EOF() )

	cSuper 		:= ""
    cNomeSuper 	:= ""
    cMailSuper	:= ""
    cGeren		:= ""
	cNomeGeren	:= ""
	cMailAss1   := ""
	cMailAss2   := ""
	cMailAss3   := ""
	    
    cRegiao     :=REP->REGIAO 
    cCodRepre 	:= REP->A1_VEND //C5VEND1
	cUfRepre    := REP->A3_EST 
	cNomeRepre	:= REP->A3_NOME
	cMailRepre	:= REP->A3_EMAIL
	//EMAILS DOS ASSISTENTES DE VENDAS
	//cMailAss1   := REP->A3_ASSIST1
	//cMailAss2   := REP->A3_ASSIST2
	//cMailAss3   := REP->A3_ASSIST3
	
	cAtivo		:= REP->A3_ATIVO
	
	cCliente	:= REP->A1_COD //C5_CLIENTE
	cCliUf      := REP->A1_EST 
	cLoja		:= REP->A1_LOJA //C5_LOJACLI
	cSegmento   := REP->A1_SATIV1 
	cContato    := REP->A1_CONTATO
	cTel	    := REP->A1_TEL
	
	cNomeCli	:= Alltrim(REP->A1_NOME)
	aLici       := {}
	cLiciprod   := ""
	cLici		:= ""
	nLiciSaldo  := 0

    nUltimaRS:= 0
	nUltimaKG:= 0
	dUltima	:= Ctod("  /  /    ")
		
	If !Empty(REP->SUPER)              ///é representante
		
		cSuper:= REP->SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME
		cMailSuper := SA3->A3_EMAIL
	
	Else
		cSuper 		:= REP->A1_VEND //C5VEND1
		cNomeSuper	:= REP->A3_NOME
		cMailSuper  := REP->A3_EMAIL
	Endif	
    
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLjAnt)
	
		If Ascan(aPendentes, ( Alltrim(cCliente + cLoja) ) ) == 0		//se o cliente não estiver no array dos clientes pendentes
			aUltCompra := fUltiCompra( cCliente, cLoja, nFamilia ) 
			//Aadd(aRetorno, { dUltima , nReais , nQTD } )
			If Len(aUltCompra) > 0	
				dUltima	 := aUltCompra[1,1] //REP->C5ENTREG 
				nUltimaRS:= aUltCompra[1,2]	//REP->VALOR
				nUltimaKG:= aUltCompra[1,3] //REP->PESO
			Endif
		   
			If !Empty(dUltima)
				//If dUltima <= (DATAUSO - 121) //FR - 05/04/2011 - CH 002064 - alterar para 120 dias
				//ALERT(nDIASINAT)
				If dUltima <= (DATAUSO - nDIASINAT) //FR - 27/02/14 criei no SX1 uma pergunta em que o usuário informará qtos dias inativos ele deseja visualizar
				
					If nTipoCli = 2   //se for órgão público
						//Aadd(aRet, { cCodEdi, cProduto,  Alltrim(Substr(cFamilia,1,35)), nSaldoVal, nSaldoQT } ) 
						//                1         2                    3                     4          5
						
						aLici := TrazLici(cCliente,cLoja, nFamilia )
						If Len(aLici) > 0
							cLici     := aLici[1,1]
							cLiciprod := aLici[1,3] //aLici[1,2]+ '-' + aLici[1,3]
							nLiciSaldo:= aLici[1,4]
						Endif
					Endif    
					
								
					Aadd(aDadRep, { cCodRepre,;			//1
						cNomeRepre,;        //2
						cMailRepre,;        //3
						cCliente,;          //4
						cLoja,;             //5
						cNomeCli,;          //6
						cSuper,;            //7
						cNomeSuper,;        //8
						cGeren,;            //9
						cNomeGeren,;        //10	   			
						cAtivo,;			//11
						nUltimaRS,;			//12
						nUltimaKG,;			//13
						dUltima,;  			//14
						cMailSuper,;		//15
						cContato  ,;		//16
						cTel,;				//17
						cLici,;				//18
						cLiciprod,;			//19
						nLiciSaldo,;        //20
						cUfRepre,;          //21
						cRegiao,;           //22
						cCliUf   })			//23
						   				
			   	//Else
			   		//msgbox( "DIAS : " + STR( DATAUSO - REP->C5_ENTREG ) )
			   	Endif
		    Endif
			cCliAnt := cCliente
			cLjAnt  := cLoja				   
	   	Endif		//endif da pendência financeira   
	Endif		//cli != cli anterior    
		
	nRegTot++
	REP->(DBSKIP())			


Enddo

aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Dtos(X[14]) > Y[7] + Y[1] + Dtos(Y[14])  } )  

REP->( DbCloseArea() )


nTotUltRS := 0
nTotUltKG := 0

cWeb		:= ""

cMailRepre 	:= ""
cMailSuper  := ""
nLinhas 	:= 80
nMedia  	:= 0
nTotMedia	:= 0
cRepreAnt	:= ""

nHandle := 0
nHand   := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif

nCta := 1

If !lDentroSiga

	If Len(aDadRe) > 0   
		///envia dos representantes
		nCta := 1
		fEnvRepre(aDadRe)
		
		///envia dos coordenadores
		nCta := 1
		fEnvSuper(aDadRe)  
	
	//Else
		//msgbox("array vazio")
	Endif
	Reset Environment
////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
Else     //se é dentro do siga 
	
	//faz o envio por coordenador
	fEnvSuper(aDadRe)   
	
Endif


Return


**************************************
Static Function fAbreHTM(cDir, cArq)  
**************************************

//Tenta com o MOZILLA COMUM
If WinExec("C:\Arquivos de programas\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
	///Se não conseguir, tenta com Mozilla (para Dell)
	If WinExec("C:\Program Files (x86)\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
		//Se não conseguir, tenta com Internet Explorer	
		If WinExec("C:\arquiv~1\intern~1\iexplore.exe " + cDir + cArq) <> 0						
				
			MsgBox("Não foi possível Abrir o Relatório Automaticamente."+Chr(13)+;
			"Por Favor, Verifique seu e-mail, o relatório estará anexado."+Chr(13)+Chr(13)+;
			"", "Atenção")	
	        ///se não conseguir abrir nenhum, irá avisar que o arquivo chegou anexado por email
		EndIf
	Endif
EndIf

Return

***************************
Static Function fCabeca(nPag, titulo,cRegiao)
***************************

Local cWeb := "" 
Local cEmpresa := ""

If SM0->M0_CODFIL = '01' 
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa:= "Rava-" + SM0->M0_FILIAL
Endif

cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
cWeb += '<html><head>'+ LF
cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cWeb += '<table width="1200" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cWeb += '<tr>    <td>'+ LF
cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cWeb += '<tr>        <td>SIGA /FATR025/v.P10</td>'+ LF
//cWeb += '<td align="center">' + titulo+" "+ALLTRIM(cRegiao) + '</td>'+ LF
cWeb += '<td align="center">' + titulo+ '</td>'+ LF
cWeb += '<td align="right">DT.Ref.: '+ Dtoc(DATAUSO) + '</td>        </tr>        <tr>          '+ LF
cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cWeb += '<td align="right">Emissao: '+ Dtoc(DATAUSO) + '</tr>'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cWeb += '</table></head>'+ LF     

Return(cWeb)

****************************
Static Function fRodape()
****************************

Local cWeb := ""

cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
cWeb += '    <tr>'+LF
cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
cWeb += '    </tr>'+LF
cWeb += '    <tr>'+LF
cWeb += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
cWeb += '      <td id="colArial">&nbsp;</td>'+LF
cWeb += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
cWeb += '    </tr>'+LF
cWeb += '    <tr>'+LF
cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
cWeb += '    </tr>'+LF
cWeb += '  </table>'+LF

Return(cWeb)

///LICITAÇÃO
*********************************************
Static Function TrazLici(cCliente,cLoja, nFam) 
*********************************************

Local cQuery   := ""
Local aRet     := {}
Local cCodEdi  := "" 
Local nSaldoVal:= 0
Local nSaldoQT := 0
Local cFamilia := ""
Local cProduto := ""

cQuery += " SELECT " + LF

cQuery += " SA1.A1_COD, SA1.A1_LOJA, Z17.Z17_EMISS, Z17.Z17_CODIGO, Z17.Z17_NREDIT, Z18.Z18_PROD, Z17.Z17_STATUS ," + LF

cQuery += " (SELECT TOP 1 B1_DESC FROM " + RetSqlname("SB1") + " SB1, " + LF
cQuery += " " + RetSqlName("Z18") + "  Z18F " + LF
cQuery += " WHERE Z18F.Z18_PROD = Z18.Z18_PROD" + LF
cQuery += " AND Z18F.Z18_PROD = SB1.B1_COD" + LF
cQuery += " AND Z18F.D_E_L_E_T_=''" + LF
cQuery += " AND SB1.D_E_L_E_T_='') B1DESC, " + LF + LF

cQuery += "  (SELECT TOP 1 X5_DESCRI FROM " + RetSqlName("SB1") + " SB1X, " + LF 
cQuery += " " + RetSqlName("Z18") + " Z18F, " + LF
cQuery += " " + RetSqlName("SX5") + " SX5  " + LF
cQuery += "  WHERE Z18F.Z18_PROD = Z18.Z18_PROD " + LF
cQuery += "  AND Z18F.Z18_PROD = SB1X.B1_COD " + LF
cQuery += " AND SB1X.B1_SETOR = SX5.X5_CHAVE " + LF
cQuery += " AND SX5.X5_TABELA = '72' " + LF
cQuery += "  AND Z18F.D_E_L_E_T_='' " + LF
cQuery += "  AND SB1X.D_E_L_E_T_='') B1FAMILIA " + LF + LF 

cQuery += " ,QTD_ORIG =  (SELECT SUM(Z18Y.Z18_QUANT/SB5Y.B5_QE2) FROM " + RetSqlname("Z18") + " Z18Y " + LF
cQuery += " ,  " + RetSqlname("SB5") + " SB5Y  " + LF
cQuery += "  WHERE Z18Y.Z18_CODEDI= Z17.Z17_CODIGO " + LF
cQuery += " AND SB5Y.B5_COD=Z18Y.Z18_PROD " + LF
cQuery += "  AND Z18Y.Z18_PROD=Z18.Z18_PROD " + LF
cQuery += "  AND Z18Y.D_E_L_E_T_='' " + LF
cQuery += " AND SB5Y.D_E_L_E_T_='' ) " + LF + LF

cQuery += " ,VEND_QT = ( SUM(SD2.D2_QUANT) ) " + LF + LF

cQuery += " ,(SELECT SUM(Z18X.Z18_QUANT/B5_QE2) FROM " + RetSqlname("Z18") + " Z18X " + LF
cQuery += " ,  " + RetSqlname("SB5") + " SB5X  " + LF
cQuery += "  WHERE Z18X.Z18_CODEDI= Z17.Z17_CODIGO " + LF
cQuery += "  AND SB5X.B5_COD=Z18X.Z18_PROD " + LF
cQuery += "  AND Z18X.Z18_PROD=Z18.Z18_PROD " + LF
cQuery += "  AND Z18X.D_E_L_E_T_='' " + LF
cQuery += "  AND SB5X.D_E_L_E_T_='')  " + LF
cQuery += "  - SUM(D2_QUANT) SALDOQT  " + LF+ LF

cQuery += " ,VAL_ORIG = SUM(SZ6.Z6_VALOR) " + LF+ LF

cQuery += " ,VEND_VL = ( SUM(SD2.D2_TOTAL) ) " + LF+ LF

cQuery += " ,SALDOVL = (SUM(SZ6.Z6_VALOR)- SUM(SD2.D2_TOTAL) )  " + LF+ LF

cQuery += " FROM " + RetSqlname("Z17") + " Z17 " + LF 
cQuery += " JOIN " + RetSqlname("Z18") + " Z18 ON Z17_CODIGO=Z18_CODEDI " + LF
cQuery += " AND Z18.D_E_L_E_T_ = '' AND Z17.Z17_FILIAL = Z18.Z18_FILIAL" + LF + LF

cQuery += " JOIN " + RetSqlname("SB1") + " SB1X ON Z18.Z18_PROD = SB1X.B1_COD" + LF
cQuery += " AND SB1X.D_E_L_E_T_ = ''" + LF + LF
 
cQuery += " JOIN " + RetSqlname("SZ5") + " SZ5 ON Z17_CODIGO=Z5_EDITAL " + LF
cQuery += " AND SZ5.D_E_L_E_T_ = '' AND SZ5.Z5_FILIAL = Z17.Z17_FILIAL" + LF + LF

cQuery += " JOIN " + RetSqlname("SZ6") + " SZ6 ON Z5_NUM=Z6_NUM  AND Z18_PROD=Z6_PRODUTO " + LF
cQuery += " AND SZ6.D_E_L_E_T_ = '' AND SZ6.Z6_FILIAL = Z18.Z18_FILIAL" + LF + LF

cQuery += " JOIN " + RetSqlname("SC6") + " SC6 ON Z5_NUM=C6_PREPED  AND Z18_PROD=C6_PRODUTO " + LF
cQuery += " AND SC6.D_E_L_E_T_ = '' AND SZ5.Z5_FILIAL = SC6.C6_FILIAL" + LF + LF

cQuery += " JOIN " + RetSqlname("SC5") + " SC5 ON C5_NUM=C6_NUM " + LF
cQuery += " AND SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL " + LF + LF

cQuery += " JOIN " + RetSqlname("SD2") + " SD2 ON D2_PEDIDO=C5_NUM AND Z18_PROD=D2_COD " + LF
cQuery += " AND SD2.D_E_L_E_T_ = '' AND D2_FILIAL = C5_FILIAL AND SC6.C6_NUM = SD2.D2_PEDIDO " + LF
cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.C6_PRODUTO = SD2.D2_COD AND SC6.C6_ITEM = SD2.D2_ITEMPV " + LF + LF

cQuery += " JOIN " + RetSqlname("SA1") + " SA1 ON SA1.A1_COD = C5_CLIENTE AND SA1.A1_LOJA = C5_LOJACLI " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF + LF

cQuery += " WHERE  " + LF
cQuery += " Z17.D_E_L_E_T_='' " + LF
cQuery += " AND Z17.Z17_STATUS BETWEEN '17' AND '20' " + LF


cQuery += " and SA1.A1_COD = '" + Alltrim(cCliente) + "' " + LF
cQuery += " and SA1.A1_LOJA = '" + Alltrim(cLoja) + "' " + LF
If nFam = 1
	cQuery += " and SB1X.B1_SETOR <> '39'" + LF
Elseif nFam = 2
	cQuery += " and SB1X.B1_SETOR = '39'" + LF
Endif

cQuery += " GROUP BY " + LF
cQuery += " SA1.A1_COD, SA1.A1_LOJA, Z17.Z17_EMISS, Z17.Z17_CODIGO, Z17.Z17_NREDIT, Z18.Z18_PROD, Z17.Z17_STATUS " + LF

cQuery += " order by Z17.Z17_EMISS DESC, Z17.Z17_CODIGO " + LF

MemoWrite("C:\Temp\trazlici.sql",cQuery)
If Select("LICXX") > 0
	DbSelectArea("LICXX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "LICXX"

//TCSetField( "LICX", "C5_EMISSAO", "D")
If !LICXX->(EOF())
	LICXX->( DbGoTop() )
	cCodEdi := LICXX->Z17_NREDIT
	//While LICXX->( !EOF() )         
	
		cFamilia:= LICXX->B1FAMILIA
		cProduto:= LICXX->Z18_PROD
		
		While LICXX->(!EOF()) .AND. Alltrim(LICXX->Z17_NREDIT) == Alltrim(cCodEdi)
			nSaldoVal += LICXX->SALDOVL
			nSaldoQT  += LICXX->SALDOQT
			LICXX->(DBSKIP())
		Enddo
	
	If nSaldoVal < 0
		nSaldoVal := 0
	Endif	
	Aadd(aRet, { cCodEdi, cProduto,  Alltrim(Substr(cFamilia,1,35)), nSaldoVal, nSaldoQT } ) 
Endif
DbSelectArea("LICXX")
DbCloseArea()

Return(aRet)


*********************************************************
Static Function fUltiCompra( cCliente, cLoja, nFamilia ) 
*********************************************************

Local cQuery 	:= ""
Local cUltimes 	:= ""
Local LF		:= CHR(13)+CHR(10)
Local dUltima	:= Ctod("  /  /    ")
Local nReais	:= 0
Local nQTD		:= 0 
Local aRetorno  := {}
Local cPedido	:= "" 
Local lAtendido := .F.
Local nSaldo	:= 0

cQuery := " SELECT TOP 1 " + LF

cQuery += " C5_NUM, C5_ENTREG, C5_EMISSAO, " + LF
cQuery += " MAX(C6_ENTREG) AS ENTREGA, " + LF + LF

If nFamilia = 1
	cQuery += " ROUND(SUM(C6_QTDVEN * B1_PESO),2) AS PESO ,  " +LF
Elseif nFamilia = 2
	cQuery += " ROUND(SUM(C6_QTDVEN),2) AS PESO ,  " +LF
Endif
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR , C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NOME, A3_GEREN " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( (A3_SUPER) <> '' OR (A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " ,A3_EMAIL, A3_ATIVO " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

cQuery += " WHERE " + LF

cQuery += " SB1.B1_TIPO != 'AP' " +LF //Despreza Apara 
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

If nFamilia = 1
	cQuery += " AND (SB1.B1_SETOR) <> '39' " +LF
Elseif nFamilia = 2
	cQuery += " AND (SB1.B1_SETOR) = '39' " +LF
Endif
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_PRODUTO = B1_COD     "  +LF

cQuery += " AND C6_NUM = C5_NUM     " +LF
cQuery += " AND C6_FILIAL = C5_FILIAL  " +LF

cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF

cQuery += " AND C5_VEND1 = A3_COD " +LF
//cQuery += " AND A3_ATIVO <> 'N' " + LF

cQuery += " AND (C5_CLIENTE) = '" + Alltrim(cCliente) + "' " + LF
cQuery += " AND (C5_LOJACLI) = '" + Alltrim(cLoja) + "' " + LF 

cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF

cQuery += " GROUP BY C5_NUM, C5_VEND1, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_ENTREG, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF

cQuery += " ORDER BY " + LF
cQuery += " CASE WHEN SC5.C5_ENTREG = '' THEN SC5.C5_EMISSAO ELSE SC5.C5_ENTREG END DESC " + LF

MemoWrite("C:\temp\ulticompra.sql", cQuery)

If Select("SC5U") > 0
	DbSelectArea("SC5U")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SC5U"

TCSetField( "SC5U", "C5_ENTREG", "D")
TCSetField( "SC5U", "ENTREGA", "D")

If !SC5U->(EOF())

	SC5U->( DbGoTop() )
	While SC5U->( !EOF() )
	
		dUltima := iif(!Empty(SC5U->C5_ENTREG) , SC5U->C5_ENTREG, SC5U->ENTREGA)
		nReais  := SC5U->VALOR
		nQTD    := SC5U->PESO
		cPedido := SC5U->C5_NUM
		SC5U->(DBSKIP())
	
	Enddo
	Aadd(aRetorno, { dUltima , nReais , nQTD } )
Endif


DbSelectArea("SC5U")
DbCloseArea()


Return(aRetorno)

**************************
Static Function fCabRel( nFamilia, nTipoCli )
**************************
Local cWeb := "" 

cWeb += '<table width="100%" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cWeb += '<td colspan="3" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA DOS 90 DIAS</span></div></b></td>'+LF
cWeb += '<td colspan="3"><div align="center"><span class="style3" style="font-size:14px"><b>ULTIMA COMPRA</span></div></b></td>'+LF
If nTipoCli = 2
	cWeb += '<td colspan="3"><div align="center"><span class="style3" style="font-size:14px"><b>ULTIMA LICITACAO</span></div></b></td>'+LF						
Endif			
cWeb += '</tr>'+ LF			
nLinhas++
					
cWeb += '<tr>'+ LF
cWeb += '<td width="120" align="center"><span class="style3">Nome</span></td>'+ LF 	
cWeb += '<td width="120" align="center"><span class="style3">Contato</span></td>'+ LF
cWeb += '<td width="100" align="center"><span class="style3">Telefone</span></td>'+ LF
If nFamilia = 1   
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
	cWeb += '<td width="200" align="center"><span class="style3">KG</span></td>'+ LF 	//última compra KG  
	cWeb += '<td width="200" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA
Else
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
	cWeb += '<td width="200" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra QTD  
	cWeb += '<td width="200" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
Endif 
			
If nTipoCli = 2
	cWeb += '<td width="200" align="center"><span class="style3">Numero Licitacao</span></td>'+ LF 	//NUMERO LICITAÇÃO
	cWeb += '<td width="200" align="center"><span class="style3">Saldo a Fornecer (R$)</span></td>'+ LF 	//SALDO A FORNECER  
	cWeb += '<td width="200" align="center"><span class="style3">Produto/Familia</span></td>'+ LF 	//PRODUTO/FAMILIA
Endif
				
cWeb += '</strong></tr>'+ LF						
nLinhas++

Return(cWeb)



***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return


**********************************
Static Function fEnvRepre(aDadRe) 
**********************************


Local cMailAssis := "" 
nCta := 1

Do While nCta <= Len(aDadRe)
	     
	cCodRepre := aDadRe[nCta,1]
	cUfRepre  := aDadRe[nCta,21] 
	cNomeRepre:= aDadRe[nCta,2]
	cMailRepre:= aDadRe[nCta,3]
	cSuper	  := aDadRe[nCta,7]
	cMailSuper:= aDadRe[nCta,15]
	
	cMailAssis := ""
	SA3->(Dbsetorder(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper))
		If !Empty(SA3->A3_ASSIST1)
			cMailAssis := SA3->A3_ASSIST1
		Endif 
		If !Empty(SA3->A3_ASSIST2)
			cMailAssis += ";" + SA3->A3_ASSIST2
		Endif
		If !Empty(SA3->A3_ASSIST3)
			cMailAssis += ";" + SA3->A3_ASSIST3
		Endif
	Endif
	
	//cRegiao   :=aDadRe[nCta,22] 
	cWeb := "" 
	////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
	cDirHTM  := "\Temp\"    
	cArqHTM  := "REL04_Repre_" + Alltrim(cCodrepre)+"_.HTM"   
			
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		    
	If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
	Endif
	
   cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
   	////div para quebrar página automaticamente
	cWeb += '<style type="text/css">'+LF
	cWeb += '.quebra_pagina {'+LF
	cWeb += 'page-break-after:always;'+LF
	cWeb += 'font-size:10px;'+LF
	cWeb += 'font-style:italic;'+LF
	cWeb += '	color:#F00;'+LF
	cWeb += '	padding:5px 0;'+LF
	cWeb += '	text-align:center;'+LF
	cWeb += '}'+LF
	cWeb += 'p {text-align:right;'+LF
	cWeb += '}'+LF
	cWeb += '</style>'+LF

   nLinhas := 5
	//////////   
   //Do While nCta <= Len(aDadRe) .AND. ALLTRIM(aDadRe[nCta,22]) == ALLTRIM(cRegiao)         // regiao 
	        
	 
	  	
	/////CABEÇALHO PÁGINA
	cWeb += fCabeca(nPag, titulo,cRegiao)

	/////////////////////////////////////
	////LINHA REPRESENTANTE E SUPERVISOR
	/////////////////////////////////////
	cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
	cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
	cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td>'+LF
	cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
	cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
	nLinhas++
	cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
	cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td>'+LF
	cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
	cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
	cWeb += '</table>' + LF
	nLinhas++
			
	///Cabeçalho relatório	      
	cWeb += fCabRel( nFamilia, nTipoCli )
	nPag++
	Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre)  .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre) + "VD" )
			
		If nLinhas >= 54	   			 			 		
		   		
			/////CABEÇALHO PÁGINA
			cWeb += fCabeca(nPag, titulo,cRegiao)  		
			nLinhas := 5
		
			/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += '<table width="1300" border="0" style="font-size:13px;font-family:Arial">'+LF
			cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
			cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td>'+LF
			cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
			nLinhas++
				
			cWeb += '<td width="80"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
			nLinhas++
			cWeb += '</table>' + LF
			nLinhas++
			
			///Cabeçalho relatório
			cWeb += fCabRel( nFamilia, nTipoCli )	      
			nPag++
	    Endif
	   	///IMPRESSAO DADOS
	   	//NOME CLIENTE    		
	    cWeb += '<td width="420"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25))+ "- UF:" + Alltrim(aDadRe[nCta,23]) + '</span></td>'+LF        		
	    //CONTATO    		
	    cWeb += '<td width="120"><span class="style3">'+ Alltrim(aDadRe[nCta,16]) + '</span></td>'+LF        		
	    //TELEFONE
	    cWeb += '<td width="100"><span class="style3">'+ Transform(Alltrim(aDadRe[nCta,17]) , PesqPict("SA1","A1_TEL")) + '</span></td>'+LF
	    //Transform( Alltrim(aDadRe[nCta,32]), PesqPict("SA1","A1_TEL") )        		
	    						
		/// última compra (R$ / KG / DATA)
		cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
		cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
		cWeb += '<td width="200" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,14])  + '</span></td>'+LF  //DATA
		
		If nTipoCli = 2
			///licitação
			cWeb += '<td width="200" align="right"><span class="style3">' + aDadRe[nCta,18] + '</span></td>'+LF  //NUM LIC
			///saldo
			If !Empty(aDadRe[nCta,18])
				cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,20], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO
			Else
				cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
			Endif
			///produto
			cWeb += '<td width="420" align="left"><span class="style3">' + aDadRe[nCta,19] + '</span></td>'+LF  //PRODUTO
		Endif
		
		cWeb += '</tr>'+LF 		//finaliza a linha
		nLinhas++			        
	    			
		nTotUltRS += aDadRe[nCta,12]				
		nTotUltKG += aDadRe[nCta,13]
					      
	   	nCta++	   	
	   	   	
	   	   	
	   	If lDentroSiga
			IncRegua()	
		Endif
		
		
		
	Enddo  		
	cWeb += '<td width="920" colspan="3" align="right"><span class="style3"><b>TOTAL.....:</span></b></td>'
						
	///coluna média 90 dias (R$ e KG)
	///coluna última compra (R$, KG, DATA)
	cWeb += '<td width="200" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
	cWeb += '<td width="200" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
	cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
	If nTipoCli = 2
		cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
		cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
		cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
	Endif
	cWeb += '</tr></table>'+LF
	nLinhas++
					
	///ZERA OS TOTAIS PARA NOVO REPRESENTANTE
	nTotUltRS:= 0
	nTotUltKG:= 0
			
	////linha em branco
	cWeb += '<tr>'+LF
	cWeb += '<td width="1000" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cWeb += '</tr>'+LF
								
	////linha em branco
	cWeb += '<tr>'+LF
	cWeb += '<td width="1000" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cWeb += '</tr>'+LF
								
	///faz o rodapé
	cWeb += fRodape()			
								   			   			    
	//Enddo // por regiao 

	///FECHA O HTML PARA ENVIO
	cWeb += '</body> '
	cWeb += '</html> '
			
	///GRAVA O HTML
	Fwrite( nHandle, cWeb, Len(cWeb) )
	FClose( nHandle )
							
	cMailTo := cMailRepre 
	cCopia  := cMailSuper + ";" + cMailAssis 
				
	cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)                                               
	cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
	cCorpo  += "Este arquivo é melhor visualizado no navegador Mozilla Firefox." + CHR(13) + CHR(10)
						
	//cMailTo := "" //retirar
	//cCopia  := "" //retirar
	cCopia  += ";flavia.rocha@ravaembalagens.com.br" //retirar
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := titulo 
			
	U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )  
				
	nLinhas := 80						
	nPag := 1		
	     
Enddo
	  
Return

***********************************
Static Function fEnvSuper(aDadRe)  
***********************************

Local lTemDados := .T.
Local cCopia    := ""
Local cAssun    := ""
Local cMailTo   := ""
Local cCorpo    := ""
Local cAnexo    := ""
Local cMailAssis:= ""

nCta := 1
If Len(aDadRe) > 0

	cWeb := ""                 
	Do While nCta <= Len(aDadRe)
		cWeb := ""
		cSuper	  := aDadRe[nCta,7]		 
		cMailSuper:= aDadRe[nCta,15]
		
		cMailAssis := ""
		SA3->(Dbsetorder(1))
		If SA3->(Dbseek(xFilial("SA3") + cSuper))
			If !Empty(SA3->A3_ASSIST1)
				cMailAssis := SA3->A3_ASSIST1
			Endif 
			If !Empty(SA3->A3_ASSIST2)
				cMailAssis += ";" + SA3->A3_ASSIST2
			Endif
			If !Empty(SA3->A3_ASSIST3)
				cMailAssis += ";" + SA3->A3_ASSIST3
			Endif
		Endif
		
		//alert("Super: " + cSuper)
	   	////CRIA O HTM COM O CÓDIGO DO COORDENADOR
	   	cDirHTM  := "\Temp\"    
		cArqHTM  := "REL04_Coord_" + Alltrim(cSuper) +"_.HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
				
		If lDentroSiga
			////cria o diretório local, caso não exista
			lDir := ExistDir('C:\RELVENDAS') // Resultado: .F.
			cDir := "C:\RELVENDAS\"
			If !lDir
				//msgbox("cria Dir")
				U_CriaDir( cDir ) 
			Endif
			////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE	   	 
			cArq  := "REL04_Coord_" + Alltrim(cSuper) +"_.HTM"   
			nHand := fCreate( cDir + cArq, 0 )
				    
			If nHand = -1
			     MsgAlert('O arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
		Endif
	
	  	Do While nCta <= Len(aDadRe) .and. ( Alltrim(aDadRe[nCta,7]) = Alltrim(cSuper) .OR. Alltrim(aDadRe[nCta,7]) $ Alltrim(cSuper) + "VD" )
	  	//Do While nCta <= Len(aDadRe) .and. ( Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre) + "VD" )
	     
	   		cCodRepre := aDadRe[nCta,1]
	   		cUfRepre := aDadRe[nCta,21]
	   		cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]
	     
		   	cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
		   	////div para quebrar página automaticamente
			cWeb += '<style type="text/css">'+LF
			cWeb += '.quebra_pagina {'+LF
			cWeb += 'page-break-after:always;'+LF
			cWeb += 'font-size:10px;'+LF
			cWeb += 'font-style:italic;'+LF
			cWeb += '	color:#F00;'+LF
			cWeb += '	padding:5px 0;'+LF
			cWeb += '	text-align:center;'+LF
			cWeb += '}'+LF
			cWeb += 'p {text-align:right;'+LF
			cWeb += '}'+LF
			cWeb += '</style>'+LF
			//////////   
	   
			If nLinhas >= 54
		   		   	
		   		/////CABEÇALHO PÁGINA
				cWeb += fCabeca(nPag, titulo,cRegiao)
				
				nLinhas := 5
			    nPag++
			Endif
			
			/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
			cWeb += '</table>' + LF
			
			nLinhas++
			nLinhas++
			
			///Cabeçalho relatório
			cWeb += fCabRel( nFamilia, nTipoCli )	      
				   
	   		Do While nCta <= Len(aDadRe) .and. ( Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre) + "VD" )
	   		   	   		   		   		   	
		   		If nLinhas >= 40.5 			   			
		   			 			 		
			   		/////CABEÇALHO PÁGINA
					cWeb += fCabeca(nPag, titulo,cRegiao)
			   				
					nLinhas := 4
			
					/////////////////////////////////////
					////LINHA REPRESENTANTE E SUPERVISOR
					/////////////////////////////////////
					cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
					nLinhas++
					
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
					nLinhas++
					
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
					cWeb += '</table>' + LF
					nLinhas++
				
				
					///Cabeçalho relatório
					cWeb += fCabRel( nFamilia, nTipoCli ) 
					nPag++
		
			    Endif
		      	//IMPRESSAO DADOS
		      	//NOME CLIENTE    		
			    cWeb += '<td width="420"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
			    //CONTATO    		
			    cWeb += '<td width="120"><span class="style3">'+ Alltrim(aDadRe[nCta,16]) + '</span></td>'+LF        		
			    //TELEFONE
			    cWeb += '<td width="100"><span class="style3">'+ Transform(Alltrim(aDadRe[nCta,17]) , PesqPict("SA1","A1_TEL")) + '</span></td>'+LF        		
			    						
				/// última compra (R$ / KG / DATA)
				cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				cWeb += '<td width="200" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,14])  + '</span></td>'+LF  //DATA
				
				If nTipoCli = 2
					///licitação
					cWeb += '<td width="200" align="right"><span class="style3">' + aDadRe[nCta,18] + '</span></td>'+LF  //NUM LIC
					///saldo
					If !Empty(aDadRe[nCta,18])
						cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,20], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO
					Else
						cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
					Endif
					///produto
					cWeb += '<td width="400" align="left"><span class="style3">' + aDadRe[nCta,19] + '</span></td>'+LF  //PRODUTO
				Endif
				
				cWeb += '</tr>'+LF 		//finaliza a linha
				nLinhas++
			
				If nLinhas = 54
					nLinhas := nLinhas + 0.5
				Endif			        
			    			
				nTotUltRS += aDadRe[nCta,12]				
				nTotUltKG += aDadRe[nCta,13]
							      
			   	nCta++	   	
			   	   	
			   	   	
			   	If lDentroSiga
					IncRegua()	
				Endif
			
	   	    Enddo //caixinha representante  		
	   			
				  		       
			cWeb += '<td width="620" colspan="3" align="right"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="200" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="200" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
			If nTipoCli = 2
				cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="200" align="right"><span class="style3"><b></b></span></td>'+LF
			Endif
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			//nTotMedia:= 0
			//nTotMedKG:= 0
			nTotUltRS:= 0
			nTotUltKG:= 0		
			
			//QUEBRA PÁGINA POR VENDEDOR
			If nCta > 1						
				cWeb += '<div class="quebra_pagina"></div>'+LF
				//cWeb += '<div class="quebra_pagina">quebra aqui --> '+ str(nLinhas) + '</div>'+LF
				nLinhas := 80
			Endif		
		
	  	Enddo  //coordenador

		///faz o rodapé
		cWeb += fRodape()							
								   			   			    
		///FECHA O HTML PARA ENVIO
		cWeb += '</body> '
		cWeb += '</html> '
					
		///GRAVA O HTML
		Fwrite( nHandle, cWeb, Len(cWeb) )
		FClose( nHandle )
		
		If lDentroSiga
			///GRAVA O HTML para exibir no browser
			Fwrite( nHand, cWeb, Len(cWeb) )
			FClose( nHand )
			
			//////////////////////////////////////
			// Exibe o arquivo HTML no Navegador 
			//////////////////////////////////////
			fAbreHTM(cDir, cArq)
			
			//////SELECIONA O EMAIL DESTINATÁRIO	
			cCodUser := __CUSERID     
			//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo
			PswOrder(1)
			If PswSeek( cCoduser, .T. )
			   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
			   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
			   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
			   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
			Endif	
			cAssun  := "REL 04 - " + cSuper // titulo 
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			MsgInfo("Rel 04 - Você recebeu um e-mail deste Relatório.")
			
		Else //fora do Siga (schedule)
			cMailTo := cMailSuper 
			cMailTo += ";" + cMailAssis
			cCopia  := ""
						
			If Alltrim(cSuper) = '0342' //se Luis Figuera
				cCopia += ";cecilia@ravaembalagens.com.br"  //assistente Luis
			ElseIf Alltrim(cSuper) = '2348' .or. Alltrim(cSuper) = '0319' //se Janaina ou George			
				cCopia += ";amanda@ravaembalagens.com.br"  //Assistente Janaina
			ElseIf Alltrim(cSuper) = '0228' //se Josenildo
				cCopia += ";isaac.oliveira@ravaembalagens.com.br" //assistente Jojó
			ElseIf Alltrim(cSuper) = '0315' //se Jacqueline			  
				cCopia += ";vendas.sp@ravaembalagens.com.br"	//email assistente Jacque
			ElseIf Alltrim(cSuper) = '0316' //Flávio
		   		//cCopia  += ";diego.rodrigues@ravaembalagens.com.br"
		   		cCopia  += ";camila.samara@ravaembalagens.com.br"
			Endif
			cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)
			cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
							
			//cMailTo := "" //retirar
			//cCopia  := "" //retirar
			cCopia  += ";flavia.rocha@ravaembalagens.com.br"  //retirar depois
							
			cCorpo  += CHR(13) + CHR(10)  + titulo + CHR(13) + CHR(10)  
			cCorpo  += "Este arquivo é melhor visualizado no navegador Mozilla Firefox." + CHR(13) + CHR(10)
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo  
		
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

						
			nLinhas := 80						
			nPag := 1		
		Endif  //lDentroSiga
		
	Enddo	//len(aDadRe) laço principal do array
    
Else
	lTemDados := .F.
	If lDentroSiga
		If !lTemDados
			MsgInfo("Não foram encontrados Dados para os Parâmetros Selecionados.")	
		Endif		  
	Endif	
Endif //len aDadRe

 
Return