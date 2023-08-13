#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR024
//Objetivo: Relatório 03 - Venda de Sacos por Clientes Ativos ( Compraram nos últimos 119 Dias)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 24/11/2010
//Alterado por Flavia Rocha em: 12/08/11 - chamado 002244 - Janderley:
//Conforme abaixo: 
// 1) Coluna "Último Faturamento" alterar para "Último Pedido", considerando a 
//    data de FATURAMENTO/PROGRAMAÇÃO. Nessa coluna deve-se levar em consideração 
//    em primeiro lugar o "Último Pedido" pendente para depois considerar o "Último Pedido" 
//    atendido de cada cliente. 
// 2) Colocar uma TARJA nos pedidos que estão "ABERTO/PENDENTES" 

//AGENDAMENTO: semanal, toda 5a. feira - TODOS COORDENADORES
//AGENDAMENTO:  Flavia Leite e cada representante recebe o seu Todo dia 15 do mês.

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
NOVA ALTERAÇÃO: EMAIL DE FLAVIA VIANA - 20/04/12 - MUDANÇA NO AGENDAMENTO: TODO DIA 15 e dia 1o. do mês:

PARA FLÁVIO ALVES dia 1o.:
- Relatório 03 - Venda de SACOS/CAIXAS por Clientes (Públicos) Ativos
(ENVIO MENSAL todo dia 1 de cada mês, para o Coordenador Flavio Alves responsável por tais clientes)

PARA JACQUELINE E FLAVIA NORAT dia 15:
- Relatório 03 - Venda de SACOS/CAIXAS por Clientes (Privados) Ativos
(ENVIO MENSAL todo dia 15 de cada mês, para os Coordenadores Flavia Norat e Jaqueline Melo responsáveis por tais representantes)

//AGENDAMENTO: semanal, toda 5a. feira - TODO o restante dos COORDENADORES
****************************************************************************************
NOVA ALTERAÇÃO REALIZADA EM 10/10/2012 - SOLICITADA NO CHAMADO:
ALTERADO POR FLAVIA ROCHA - FR

Chamado: 00000056 - Abertura: 15/08/12 - 10:49:59
Solicitante: JANAINA NASCIMENTO
Tipo: MICROSIGA - Prioridade: NORMAL - Classificação: REABERTURA P/ CORRECAO

Ocorrência: Olá Eurivan...

Conforme conversamos favor alterar o prazo para clientes ativos de 90 dias para 119 dias 
para que logo passado esses dias passe para rel de inativos sem intervalo como está acontecendo.


//--------------------------------------------------------------------------
/*/


************************************
User Function FATR024()
************************************

Local nLinha   := 0
Private lDentroSiga := .F.
Private nFamilia := 0
Private nTipoCli := 0


/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0  

  
  /////SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  nFamilia := 1
  nTipoCli := 1  
  //tipo = 1 - Sacos / clientes privados
  f24( nFamilia, nTipoCli, nLinha )      
  //Reset Environment   //deixei na saída da função do relatório
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )  
  nFamilia := 1
  nTipoCli := 2  
  //f24( 1, 2 )       //tipo = 1 - Sacos / clientes públicos
  f24( nFamilia, nTipoCli, nLinha )      
  //Reset Environment
     
  ///CAIXAS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )  
  nFamilia := 2
  nTipoCli := 1
  //tipo = 2 - Caixas / clientes privados 
  f24( nFamilia, nTipoCli, nLinha )      

  //Reset Environment
  
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  //tipo = 2 - Caixas / clientes públicos
  nFamilia := 2
  nTipoCli := 2
  f24( nFamilia, nTipoCli, nLinha )     
  //Reset Environment
                          
Else
  lDentroSiga := .T.
  Pergunte("FATR024",.T.)    //INFORME O VENDEDOR
	nFamilia := mv_par04    //Família -> Sacos ou Caixas 
	nTipoCli := mv_par05    //Tipo Cliente -> Público ou Privado
    nLinha   := mv_par06    //Linha -> Doméstica ou Hospitalar
  f24( nFamilia, nTipoCli, nLinha )
  
EndIf

  

Return

************************************
Static Function f24( nFamilia, nTipoCli, nLinP )
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório 03 - Venda de Sacos por Clientes Ativos ( Compraram nos últimos 119 Dias)"
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
Private nomeprog     := "FATR024" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR024" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR024"
Private cString := ""

Private dData		:= Ctod("  /  /    ")
Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")

Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 

//Private cWeb		:= Space(2000)
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private nLinhas		:= 80 
Private nLin        := 80
Private cCodRepre 	:= ""
Private cRegiao     :=" "
Private cNomeRepre	:= ""
Private cMailRepre	:= ""
Private cUfRepre    := ""

Private aMeses		:= {}
Private aNomMeses	:= {}
Private nPosMes		:= 0


Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private lUltimo		:= .F.
Private nCta		:= 0
Private nMesData2
Private cDir		:= ""
Private cArq		:= ""
Private nDias		:= 0
Private cFamilia    := ""
Private cTipoCli    := ""
Private cLinha		:= ""
Private titulo         := "" 

////cálculo do intervalo de data a ser utilizado no relatório
////este relatório será executado todo dia 1o. do mês, então o intervalo deverá ser: último dia do mês anterior - 90 dias
///exemplo: execução dia 01/01/2011 - o intervalo será 31/12/2010 - 90 dias = 02/10/2010
If !lDentroSiga
	If Month(dDatabase) = 01
		nMesData2 := Month(dDatabase)  
		dData := Ctod("01/" + Strzero( (nMesData2 + 11),2) + "/" + Strzero(Year(dDatabase) - 1,4) ) //se for Janeiro/2011, irá transformar em 01/12/2010
	Else		
		nMesData2 := Month(dDatabase)		
		If Substr(DtoS(dDatabase),7,2) = "01" 
			dData := Ctod("01/" + Strzero( (nMesData2 - 1 ),2) + "/" + Strzero(Year(dDatabase),4) )
		Else
			dData := Ctod("01/" + Strzero( (nMesData2),2) + "/" + Strzero(Year(dDatabase),4) )
		Endif
	Endif

	dData2 := LastDay(dData)    //pega a data 01/<mes>/ano e transforma-a no último dia do <<mes>> em questão ex: 31/12/2010
Else
	dData2 := LastDay(dDatabase)
Endif

If nTipoCli = 1
	dData1 := dData2 - 119 //- 90		//3 meses - Sr. Viana em 17/12/10 pediu para alterar novamente
								//119 dias - Janaina solicitou pelo chamado 00000056
	nDias  := 119  //90
Elseif nTipoCli = 2
	dData1 := dData2 - 60		//chamado 002372 e 002373 - para órgãos públicos, será o período de 60 dias
	nDias := 60
Endif



//dData2 := LastDay(dDatabase)
//dData1 := dData2 - 90

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )

cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Compor o array com o número dos meses do ano
cAnoM1 := ""
cAnoM2 := ""
cAnoM3 := ""
cAnoM4 := ""
cAnoM5 := ""
cAnoM6 := ""

cAnoMe1 := ""
cAnoMe2 := ""
cAnoMe3 := ""
cAnoMe4 := ""
cAnoMe5 := ""
cAnoMe6 := ""

aMeses:= {}
aMeses:= { 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 }

nPosMes := Ascan( aMeses, Month(dData2) )


If nPosMes = 1         //se for Janeiro 
//ago, set, out, nov, dez, jan

	nMes3 := aMeses[nPosMes]	      //1
	nMes2 := aMeses[nPosMes + 11]     //12
	nMes1 := aMeses[nPosMes + 10 ]     //11
	
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	// /10     // exibe: barra + ano com 2 digitos
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	// /09 
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	// /09
	
	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//jan/10     //2010      // exibe o ano com 4 dígitos
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )  	//dez/09     //2009
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09     //2009
	

Elseif nPosMes = 2   //se for Fevereiro
//dez, jan, fev
	
	nMes3 := aMeses[nPosMes]         //2
	nMes2 := aMeses[nPosMes - 1 ]    //1
	nMes1 := aMeses[nPosMes + 10]    //12

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		// /10	// exibe: barra + ano com 2 digitos
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		// /10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	// /09
                                                   
	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//fev/10	// 2010      // exibe o ano com 4 dígitos
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//jan/10    // 2010
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09    // 2009

//aMeses:= { 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 }		
Elseif (nPosMes >= 3 )	// se = Março
	
	nMes3 := aMeses[nPosMes]          //3
	nMes2 := aMeses[nPosMes - 1 ]     //2
	nMes1 := aMeses[nPosMes - 2 ]     //1

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		//mar/10	// /10  	// exibe: barra + ano com 2 digitos
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//fev/10	// /10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//jan/10	// /10

	cAnoMe3 	:= StrZero( Year(dData2) , 4 )    	//mar/10		//2010		// exibe o ano com 4 dígitos
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//fev/10		//2010
	cAnoMe1 	:= StrZero( Year(dData2) , 4 ) 		//jan/10		//2010	

Endif			

//Compor o array com o Nome dos meses do ano
aNomMeses:= {}
//					1			2			3		 	  4		  		5		    6			7			  8			9				10			11			12
aNomMeses:= { " JANEIRO ", "FEVEREIRO", "  MARCO  ", "  ABRIL  ", "   MAIO  ", "  JUNHO  ", "  JULHO  ", "  AGOSTO ", "SETEMBRO ", " OUTUBRO ", "NOVEMBRO ", "DEZEMBRO "}

//cMes6 := aNomMeses[nMes6]
//cMes5 := aNomMeses[nMes5]
//cMes4 := aNomMeses[nMes4]
cMes3 := aNomMeses[nMes3]
cMes2 := aNomMeses[nMes2]
cMes1 := aNomMeses[nMes1] 

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

If nLinP = 1
	cLinha := "LINHA DOMESTICA"
Elseif nLinP = 2
	cLinha := "LINHA HOSPITALAR
Else
	cLinha := "TODAS AS LINHAS"
Endif

//titulo         := "Relatorio 03 - VENDA DE SACOS POR CLIENTES (PRIVADOS) ATIVOS (COMPRARAM NOS ULTIMOS 90 DIAS) - POR REPRESENTANTE"
//titulo         := "Relatorio 03 - VENDA DE " + cFamilia + " POR CLIENTES (" + cTipoCli + ") ATIVOS (COMPRARAM NOS ULTIMOS " + Alltrim(str(nDias)) + " DIAS) - " + cLinha + " - POR REPRESENTANTE"
titulo         := "Relatorio 03 - VENDA DE " + cFamilia + " POR CLIENTES (" + cTipoCli + ") ATIVOS (COMPRARAM NOS ULTIMOS " + Alltrim(str(nDias)) + " DIAS) - " + cLinha + " - "


If lDentroSiga
	
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório 03 ?")
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, nLinP) },Titulo)
	Endif
Else
	RunReport(Cabec1,Cabec2,Titulo,nLin, nLinP)
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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, nLinhaPro)

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
Local cRepreAnt:= "" 
Local cUltimaComp := ""
Local cAtivo	:= ""
Local cCodUser	:= ""
Local nRegTot	:= 0
Local dUltima	:= Ctod("  /  /    ")
Local nHandle  
Local nHand
Local aUltima	:= {}
Local lAtendido := .F.
Local cSegmento := ""
Local cContato  := ""
Local cTel      := "" 
Local aLici     := {}
Local cLiciprod := ""
Local cLici		:= ""
Local nLiciSaldo:= 0
Local nLicSalQT := 0
Local cWeb		:= ""
Local cCliAnt   := ""
Local cLjAnt    := ""
Local Tit	    := ""
Private nTotMedia := 0
Private	nTotMedKG := 0
Private	nTotUltRS := 0				
Private	nTotUltKG := 0	
Private cMailTo	:= "" 
Private cCopia	:= ""
Private cAssun	:= ""
Private cCorpo	:= ""
Private cAnexo	:= ""
////NOVA QUERY   
cQuery := " SELECT A1_EST,CASE WHEN A3_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte' " + LF
cQuery += "          ELSE CASE WHEN A3_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste' " + LF
cQuery += "          ELSE CASE WHEN A3_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste' " + LF
cQuery += "          ELSE CASE WHEN A3_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste' " + LF
cQuery += "          ELSE CASE WHEN A3_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE '' END  END END END END REGIAO " + LF
cQuery += " ,A3_EST " + LF 
cQuery += " ,A3COD = CASE WHEN A3_COD LIKE ('%VD') THEN LEFT(A3_COD,4) ELSE A3_COD END " + LF

//cQuery += " , A3_SUPER " + LF  
//ABAIXO MUDEI PARA QUE POSSA SER SELECIONADO TANTO O VENDEDOR QUE TEM SUPERVISOR, QTO O VENDEDOR QUE É O PRÓPRIO SUPERVISOR:
cQuery += " ,SUPER = ( SELECT SA33.A3_SUPER FROM " + RetSqlName("SA3") +"  SA33 " + LF
cQuery += "            WHERE SA33.A3_COD = SA3.A3_COD AND ( SA33.A3_SUPER <> '' OR RTRIM(SA33.A3_GEREN) = '0249') AND SA33.D_E_L_E_T_ = '' ) " + LF

cQuery += " , A3_NOME, A3_EST, A3_EMAIL, A3_ATIVO , A1_COD, A1_LOJA, A1_NOME, A1_SATIV1, A1_TEL, A1_CONTATO, A1_ULTCOM  "+LF
//EMAIL DOS ASSISTENTES DE VENDA:
//cQuery += " , A3_ASSIST1, A3_ASSIST2, A3_ASSIST3 " + LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK)  "+LF
cQuery += " , " + RetSqlName("SA1") + " SA1 WITH (NOLOCK)  "+LF

cQuery += " WHERE " + LF  
cQuery += " SA3.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA3.A3_COD = SA1.A1_VEND "+LF

If nTipoCli = 1
	cQuery += " AND A1_SATIV1 <> '000009' " + LF // EXCLUI OS ÓRGÃOS PÚBLICOS
Elseif nTipoCli = 2
	cQuery += " AND A1_SATIV1 = '000009' " + LF // somente ÓRGÃOS PÚBLICOS
Endif

If lDentroSiga
	cQuery += " AND (A3_COD) >= '" + Alltrim(MV_PAR01) + "' AND (A3_COD) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND (A3_SUPER) = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif
Else
    
    //cQuery += " AND  A3_SUPER  =  '0315' " + LF	//retirar
    //cQuery += " AND  A3_SUPER  =  '0316' " + LF	//retirar

Endif

///NÃO IMPRIMIR REPRESENTANTES INATIVOS
cQuery += " AND A3_ATIVO <> 'N' " + LF
///NÃO IMPRIMIR CLIENTES JÁ MARCADOS COMO INATIVOS
cQuery += " AND A1_ATIVO <> 'N' " + LF
cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - nDias) + "' " + LF 
cQuery += " GROUP BY A1_EST,A3_EST,A3_COD, A3_SUPER, A3_NOME, A3_EST, A3_EMAIL, A3_ATIVO , A1_COD, A1_LOJA, A1_NOME, A1_SATIV1, A1_TEL, A1_CONTATO, A1_ULTCOM "+LF
If lDentroSiga
   cQuery += " ORDER BY A3_SUPER, A3_COD, A1_COD, A1_LOJA " + LF  
else
   cQuery += " ORDER BY REGIAO,A3_SUPER, A3_COD, A1_COD, A1_LOJA " + LF  
endif

MemoWrite("C:\Temp\fatr024.sql", cQuery )
////FIM NOVA QUERY

////NOVO LAÇO          
If Select("REP") > 0
	DbSelectArea("REP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "REP"
//TCSetField( "REP", "C5_EMISSAO", "D")
REP->( DbGoTop() )
While REP->( !EOF() )

	cSuper 		:= ""
    cNomeSuper 	:= ""
    cMailSuper  := ""
    cGeren		:= ""
	cNomeGeren	:= ""
	cMailAss1   := ""
	cMailAss2   := ""
	cMailAss3   := ""
	    
    cCodRepre 	:= REP->A3COD
	cRegiao 	:= REP->REGIAO
	cNomeRepre	:= REP->A3_NOME
	cMailRepre	:= REP->A3_EMAIL
	cAtivo		:= REP->A3_ATIVO
	cUfRepre    := REP->A3_EST
	
	cCliente	:= REP->A1_COD
	cCliuf      := REP->A1_EST
	cLoja		:= REP->A1_LOJA
	cSegmento   := REP->A1_SATIV1
	cContato    := REP->A1_CONTATO
	cTel        := Transform(REP->A1_TEL , PesqPict("SA1","A1_TEL") ) 
	//cMailAss1   := REP->A3_ASSIST1
	//cMailAss2   := REP->A3_ASSIST2
	//cMailAss3   := REP->A3_ASSIST3
	
	aLici       := {}
	cLiciprod   := ""
	cLici		:= ""
	nLiciSaldo  := 0
	nLicSalQT   := 0
	
	
	cNomeCli	:= Alltrim(REP->A1_NOME)
	
	nTotPM1 := 0
	nTotPM2 := 0   
	nTotPM3 := 0
	nTotPM4 := 0
	nTotPM5 := 0
	nTotPM6 := 0
   
	nTotVM1 := 0
	nTotVM2 := 0   
	nTotVM3 := 0
	nTotVM4 := 0
	nTotVM5 := 0
	nTotVM6 := 0
	
	nMedia	:= 0
	nMediaKG:= 0
	nUltimaRS:= 0
	nUltimaKG:= 0
	dUltima	:= Ctod("  /  /    ")
	aUltima := {}
	lAtendido := .F.
	
	
	If !Empty(REP->SUPER)              ///é representante
		cSuper:= REP->SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME
		cMailSuper := SA3->A3_EMAIL
	
	Else
		cSuper 		:= REP->A3COD
		cNomeSuper	:= REP->A3_NOME
		cMailSuper  := REP->A3_EMAIL
	Endif
	tit := ""
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLjAnt)
		
		///captura o valor, kg e data da última compra
		aUltima	    := fUltiCompra( cCliente, cLoja, cCodRepre, nFamilia, dData1, cSuper )
		//Aadd(aRetorno, { dUltima , nReais , nKilos ,lAtendido } )
		If Len(aUltima) > 0
			dUltima		:= aUltima[1,1]
			nUltimaRS	:= aUltima[1,2]
			nUltimaKG	:= aUltima[1,3]
			lAtendido	:= aUltima[1,4] 
		Endif
		
		If !Empty(dUltima)
			IF (dDatabase - dUltima) <= 119 
				If !lDentroSiga
				    If Alltrim(cSuper) $ "0315/0316"  ///0320"
				    	nLinhaPro := 2   //se forem coordenadores associados a FLAVIA VIANA, calcula somente HOSPITALAR
				    	//tit := "Relatorio 03 - VENDA DE " + cFamilia + " POR CLIENTES (" + cTipoCli + ") ATIVOS (COMPRARAM NOS ULTIMOS " + Alltrim(str(nDias)) + " DIAS) - LINHA HOSPITALAR - "
				    Else
				    	nLinhaPro := 0   //se não forem os coordenadores associados a FLAVIA VIANA, calcula sobre TODAS AS LINHAS
				    Endif				    
				    If !Empty(tit)
				    	titulo         := tit
				    Endif

			    Endif
			    
				//mês 1
				dImed1 := FirstDay(dData1)     //01/08/12
				dImed2 := LastDay(dImed1)      //31/08/12
				nMes   := Month(dImed1)	       //08
				nTotVM1 := U_pddMes(dImed1, dImed2  , .T.  , dImed1, dImed2, 1    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro) 
				//      U_pddMes( dDataIni, dDataFim, lFora, dExec1, dExec2, nRSKG, cTipoA3, cCodA3                   , nFam    , nLinha )
				nTotPM1 := U_pddMes(dImed1,dImed2   , .T.  , dImed1, dImed2, 2    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro)
				
				//mês 2
				//dImed1 := Ctod("01/" + str(nMes2) +'/'+ Right(StrZero(Year(dData1),4),2) )  
				dImed1 := Ctod("01/" + str(nMes + 1) +'/'+ Right(StrZero(Year(dData1),4),2) )  //01/09/12 
				dImed2 := LastDay(dImed1)                                                      //30/09/12
				nMes   := Month(dImed1)  //09	
				nTotVM2 := U_pddMes(dImed1, dImed2  , .T.  , dImed1, dImed2, 1    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro) 		
				nTotPM2 := U_pddMes(dImed1,dImed2   , .T.  , dImed1, dImed2, 2    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro) 
				
				If nDias > 60      //se nDias for > 60, ou seja, 119 dias, fará o cálculo dos períodos seguintes
					//mês 3
					dImed1 := Ctod("01/" + str(nMes + 1) +'/'+ Right(StrZero(Year(dData1),4),2) )     //01/10/12
					dImed2 := LastDay(dImed1)                                                      //31/10/12
					nMes   := Month(dImed1)	   //10			
					nTotVM3 := U_pddMes(dImed1, dImed2  , .T.  , dImed1, dImed2, 1    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro) 		
					nTotPM3 := U_pddMes(dImed1,dImed2   , .T.  , dImed1, dImed2, 2    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro)
										
					//mês 4				
					dImed1 := Ctod("01/" + str( (nMes + 1) ) +'/'+ Right(StrZero(Year(dData1),4),2) )  //01/11/12
					dImed2 := LastDay(dImed1)                                                           //30/11/12
					
					nTotVM4 := U_pddMes(dImed1, dImed2  , .T.  , dImed1, dImed2, 1    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro) 		
					nTotPM4 := U_pddMes(dImed1,dImed2   , .T.  , dImed1, dImed2, 2    , "C"    , Alltrim(cCliente + cLoja), nFamilia, nLinhaPro)
				Endif      
		
				If nTipoCli = 2   //se for órgão público
					//Aadd(aRetorno, { LICX->Z17_NREDIT, LICX->Z18_PROD,  Alltrim(Substr(LICX->B1FAMILIA,1,35)), LICX->SALDOVL, LICX->SALDOQT } ) 
					aLici := TrazLici(cCliente,cLoja , nFamilia)
					If Len(aLici) > 0
						cLici     := aLici[1,1]
						cLiciprod := aLici[1,3]  //aLici[1,2]+ '-' + aLici[1,3]
						nLiciSaldo:= aLici[1,4]  //saldo a fornecer em R$
						nLicSalQT := aLici[1,5]  //saldo a fornecer em KG / QT
					Endif
				
				Endif
				/*
				//calcular a média só depois de ter o valor do faturado
				If nTipoCli = 1          //se for cliente PRIVADO, a média é 119 dias
					nMedia		:= Round( (nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4)  / (nDias / 30),2 )
					nMediaKG	:= Round( (nTotPM1 + nTotPM2 + nTotPM3 + nTotPM4)  / (nDias / 30),2 )
				
				Elseif nTipoCli = 2		//se for cliente PÚBLICO, a média é 60 dias
					nMedia		:= Round( (nTotVM1 + nTotVM2 ) / (nDias / 30),2 ) 
					nMediaKG	:= Round( (nTotPM1 + nTotPM2 ) / (nDias / 30),2 ) 
				Endif
				*/
				
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
			   				nTotVM1,;           //11
			   				nTotPM1,;           //12
			   				nTotVM2,;           //13
			   				nTotPM2,;           //14
			   				nTotVM3,;           //15
			   				nTotPM3,;           //16
			   				nTotVM4,;           //17
			   				nTotPM4,;           //18
			   				nTotVM5,;           //19
			   				nTotPM5,;           //20
			   				nTotVM6,;           //21
			   				nTotPM6,;           //22
			   				nMedia,;            //23
			   				cAtivo,;			//24
			   				nMediaKG,;			//25
			   				nUltimaRS,;			//26
			   				nUltimaKG,;			//27
			   				dUltima,; 			//28
			   				cMailSuper,;		//29
			   				lAtendido,;    		//30
			   				cContato ,;    		//31
			   				cTel,;				//32
			   				cLici,;				//33
							cLiciprod,;			//34
							nLiciSaldo,;		//35
							nLicSalQT ,;        //36
							cUfRepre,;          //37
							cRegiao ,;          // 38
							cCliuf } )   		//39
		
		    ENDIF // do Database <= 119				
		Endif  //do !Empty dUltima
			cCliAnt := cCliente
			cLjAnt  := cLoja
			nRegTot++
							
	Endif //endif do cliant = cli agora
	REP->(DBSKIP())
					
Enddo
////FIM NOVO LAÇO

//o LAÇO ABAIXO É PARA CAPTURAR O FATURADO EM CADA MÊS LIDO (MÊS 1, 2, 3 DA GRADE)
//COLOQUEI AQUI FORA, POIS, SE A QUERY NÃO TROUXER NENHUM RESULTADO, PELO MENOS O FATURADO VAI ALIMENTAR O ARRAY
mm := 1
mCli := ""
While mm <= Len(aDadRep)
	//mRepre := aDadSS[mm,1]
	mCli := Alltrim(aDadRep[mm,4]) + Alltrim(aDadRep[mm,5])
	dExec:= Ctod("  /  /    ")
	nVALFAT1 := 0
	nKGFAT1  := 0 
	
	nVALFAT2 := 0
	nKGFAT2  := 0
	
	nVALFAT3 := 0
	nKGFAT3  := 0
	
	nVALFAT4 := 0
	nKGFAT4  := 0
	
	nMedia   := 0
	nMediaKG := 0
	
	Do While mm <= Len(aDadRep) .and. (Alltrim(aDadRep[mm,4]) + Alltrim(aDadRep[mm,5])) = Alltrim(mCli)
		If !lDentroSiga
		    If Alltrim(cSuper) $ "0315/0316/0320"
		    	nLinhaPro := 2   //se forem coordenadores associados a FLAVIA VIANA, calcula somente HOSPITALAR
		    Else
		    	nLinhaPro := 0   //se não forem os coordenadores associados a FLAVIA VIANA, calcula sobre TODAS AS LINHAS
		    Endif
	    Endif
		//mês 1			 	
		//dExec := Ctod("01/" + str(nMes1) +'/'+ Right(StrZero(Year(dData1),4),2) ) 
		dExec := FirstDay(dData1)     //01/08/12
		nMes  := Month(dExec)         //08
		nVALFAT1 := U_FatMes(1, "", 1, mCli, dExec, .T., nFamilia, "C", nLinhaPro)        //U_FatMes(nOpc, cDev, nPAR04, cCodA3, dExec, lFora, nFam, cTipoA3, nLinha)    
		nKGFAT1  := U_FatMes(1, "", 2, mCli, dExec, .T., nFamilia, "C", nLinhaPro) 	 	
					
		//mês 2
		//dExec := Ctod("01/" + str(nMes2) +'/'+ Right(StrZero(Year(dData1),4),2) )
		dExec   := Ctod("01/" + str(nMes + 1) +'/'+ Right(StrZero(Year(dData1),4),2) )  //01/09/12
		nMes    := Month(dExec)      //09
		nVALFAT2 := U_FatMes(1, "", 1, mCli, dExec, .T., nFamilia, "C", nLinhaPro)        //U_FatMes(nOpc, cDev, nPAR04, cCodA3, dExec, lFora, nFam, cTipoA3, nLinha)    
		nKGFAT2  := U_FatMes(1, "", 2, mCli, dExec, .T., nFamilia, "C", nLinhaPro) 	 	
		
		aDadRep[mm,11] += nVALFAT1
		aDadRep[mm,12] += nKGFAT1
		aDadRep[mm,13] += nVALFAT2
		aDadRep[mm,14] += nKGFAT2
					
		If nDias > 60	//se nDias for > 60, ou seja, 119 dias, fará o cálculo dos períodos seguintes
			//mês 3
			dExec := Ctod("01/" + str(nMes + 1) +'/'+ Right(StrZero(Year(dData1),4),2) )		
			nMes  := Month(dExec)   //10
			nVALFAT3 := U_FatMes(1, "", 1, mCli, dExec, .T., nFamilia, "C", nLinhaPro)        //U_FatMes(nOpc, cDev, nPAR04, cCodA3, dExec, lFora, nFam, cTipoA3, nLinha)    
			nKGFAT3  := U_FatMes(1, "", 2, mCli, dExec, .T., nFamilia, "C", nLinhaPro)
			
			//mês 4			
			dExec    := Ctod("01/" + str( (nMes + 1) ) +'/'+ Right(StrZero(Year(dData1),4),2) )  //01/11/12  
			nVALFAT4 := U_FatMes(1, "", 1, mCli, dExec, .T., nFamilia, "C", nLinhaPro)        //U_FatMes(nOpc, cDev, nPAR04, cCodA3, dExec, lFora, nFam, cTipoA3, nLinha)    
			nKGFAT4  := U_FatMes(1, "", 2, mCli, dExec, .T., nFamilia, "C", nLinhaPro) 
			
			aDadRep[mm,15] += nVALFAT3
			aDadRep[mm,16] += nKGFAT3 
			
			aDadRep[mm,17] += nVALFAT4
			aDadRep[mm,18]+= nKGFAT4
			
		Endif	
			
		If nTipoCli = 1          //se for cliente PRIVADO, a média é 119 dias
			nMedia   := Round(( aDadRep[mm,11] + aDadRep[mm,13] + aDadRep[mm,15] + aDadRep[mm,17] ) / (nDias / 30) , 2 )				 
			nMediaKG := Round(( aDadRep[mm,12] + aDadRep[mm,14] + aDadRep[mm,16] + aDadRep[mm,18] ) / (nDias / 30) , 2 )
		Elseif nTipoCli = 2     //se for cliente PÚBLICO, a média é 60 dias
			nMedia   := Round(( aDadRep[mm,11] + aDadRep[mm,13] ) / (nDias / 30) , 2 )				 
			nMediaKG := Round(( aDadRep[mm,12] + aDadRep[mm,14] ) / (nDias / 30) , 2 )
		Endif		
		
		aDadRep[mm,23] := nMedia
		aDadRep[mm,25] := nMediaKG
				
		mm++
	Enddo
Enddo
///FIM DA CAPTURA FATURADO MÊS		



//aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Dtos(X[28]) < Y[7] + Y[1] + Dtos(Y[28])  } )  //ordena por representante + dt. ultima compra (mais antiga)
//FR - 09/06/2011 - Solicitado por Janderley alterar a ordem, por qtde comprada  
//aDadRe := Asort( aDadRep,,, { |X,Y| X[38] + X[7] + X[1] + Transform( X[27], "@E 99,999,999.99" ) > Y[38] + Y[7] + Y[1] + Transform( Y[27], "@E 99,999,999.99" )  } )  //ordena por representante + dt. ultima compra (mais antiga)
aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Dtos(X[28]) < Y[7] + Y[1] + Dtos(Y[28])  } )  //ordena por representante + dt. ultima compra (mais antiga)


REP->( DbCloseArea() )

nTotPM1 := 0
nTotPM2 := 0   
nTotPM3 := 0
nTotPM4 := 0
nTotPM5 := 0
nTotPM6 := 0
  
nTotVM1 := 0
nTotVM2 := 0   
nTotVM3 := 0
nTotVM4 := 0
nTotVM5 := 0
nTotVM6 := 0

nTotUltRS := 0
nTotUltKG := 0

cWeb		:= ""
nTotCartR	:= 0
nTotCartK	:= 0
cMailRepre 	:= ""
nLinhas 	:= 80
nMedia  	:= 0
nTotMedia	:= 0
cRepreAnt	:= ""
aDadRep		:= {}

nHandle := 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif

nCta := 1

If !lDentroSiga    		///se estiver sendo executado via SCHEDULE...

	If Len(aDadRe) > 0         
	
	  /////////////////////////
	  ///faz por coordenador 
	  /////////////////////////
	  nCta := 1
	  nTotMedia := 0
	  nTotMedKG := 0
	  nTotUltRS := 0				
	  nTotUltKG := 0		
	  fEnvSUPER(aDadRe, nCta)
	  
	  /////////////////////////
	  ///faz por representante 
	  /////////////////////////
	  nCta := 1
	  nTotMedia := 0
	  nTotMedKG := 0
	  nTotUltRS := 0				
	  nTotUltKG := 0
	  fEnvREPRE(aDadRe, nCta)
	
	Endif   //len aDadre
	
	Reset Environment

Else		//////////emitindo dentro do Siga
	//msginfo("Dentro do Siga")
	nCta := 1
	nTotMedia := 0
	nTotMedKG := 0
	nTotUltRS := 0				
	nTotUltKG := 0		
	fEnvSUPER(aDadRe, nCta)

Endif	//se for dentro do siga

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lDentroSiga
	// Habilitar somente para Schedule
	Reset environment
Endif

Return





*********************************************************
Static Function fUltiCompra( cCliente, cLoja, cVendedor, nFamilia, dData1, cSuper ) 
*********************************************************

Local cQuery 	:= ""
Local cUltimes 	:= ""
Local LF		:= CHR(13)+CHR(10)
Local dUltima	:= Ctod("  /  /    ")
Local nReais	:= 0
Local nKilos	:= 0 
Local aRetorno  := {}
Local cPedido	:= "" 
Local lAtendido := .F.
Local nSaldo	:= 0

////primeiro apura pedido que não foi atendido...
cQuery := " SELECT TOP 1 " + LF
cQuery += " ATEND = (Select SUM(XC6.C6_QTDVEN - XC6.C6_QTDENT) FROM " + RetSqlName("SC6") + "  XC6 WHERE XC6.C6_NUM = SC5.C5_NUM " + LF
cQuery += " AND XC6.D_E_L_E_T_ = '' ) " + LF + LF

cQuery += " ,C5_NUM, C5_ENTREG, C5_EMISSAO, " + LF
cQuery += " MAX(C6_ENTREG) AS ENTREGA, " + LF
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

//cQuery += " WHERE " + LF
cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dData1) + "' " + LF
If Alltrim(cSuper) $ "0255/0315"     //solicitado por Jacqueline
	cQuery += " -- clausula 0255 / 0315: " + LF
	cQuery += " AND SC5.C5_ENTREG <= '" + Dtos(dDatabase + 30) + "' " + LF 
Endif

cQuery += " AND (B1_TIPO) != 'AP' " +LF //Despreza Apara 
//cQuery += " AND (C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

If nFamilia = 1
	cQuery += " AND (SB1.B1_SETOR) <> '39' " +LF
Elseif nFamilia = 2
	cQuery += " AND (SB1.B1_SETOR) = '39' " +LF
Endif
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

//PRIMEIRO VERIFICA OS PEDIDOS EM ABERTO...
cQuery += " AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT) > 0  " + LF

cQuery += " AND C6_PRODUTO = B1_COD     "  +LF

cQuery += " AND C6_NUM = C5_NUM     " +LF
cQuery += " AND C6_FILIAL = C5_FILIAL  " +LF

cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF

cQuery += " AND C5_VEND1 = A3_COD " +LF
//cQuery += " AND A1_VEND = A3_COD " + LF
cQuery += " AND A3_ATIVO <> 'N' " + LF

//cQuery += " AND (C5_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 
cQuery += " AND (C5_CLIENTE) = '" + Alltrim(cCliente) + "' " + LF
cQuery += " AND (C5_LOJACLI) = '" + Alltrim(cLoja) + "' " + LF 

cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_NUM, C5_VEND1, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_ENTREG, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
//cQuery += " ORDER BY C5_ENTREG DESC " +LF
cQuery += " ORDER BY " + LF
cQuery += " CASE WHEN SC5.C5_ENTREG = '' THEN SC5.C5_EMISSAO ELSE SC5.C5_ENTREG END DESC " + LF

MemoWrite("C:\temp\ulticompra1.sql", cQuery)

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
		nKilos  := SC5U->PESO
		cPedido := SC5U->C5_NUM
		nSaldo	:= SC5U->ATEND
		SC5U->(DBSKIP())
	
	Enddo
	//msgbox("saldo: " + str( nSaldo) )
	If nSaldo >  0
		lAtendido := .F.
		//msgbox("não atendido")
	Else
		lAtendido := .T.
	Endif
	Aadd(aRetorno, { dUltima , nReais , nKilos ,lAtendido } )

Else     
	//se não encontrar pedido não atendido, irá capturar o último atendido...
	cQuery := " SELECT TOP 1 " + LF
	cQuery += " ATEND = (Select SUM(XC6.C6_QTDVEN - XC6.C6_QTDENT) FROM " + RetSqlName("SC6") + "  XC6 WHERE XC6.C6_NUM = SC5.C5_NUM " + LF
	cQuery += " AND XC6.D_E_L_E_T_ = '' ) " + LF
	cQuery += " ,C5_NUM, C5_ENTREG, C5_EMISSAO, " + LF
	cQuery += " MAX(C6_ENTREG) AS ENTREGA, " + LF
	cQuery += " ROUND(SUM(C6_QTDVEN * B1_PESO),2) AS PESO ,  " +LF
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
	
	//cQuery += " WHERE " + LF
	cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dData1) + "' " + LF
	//SE NÃO ENCONTRAR PEDIDO NÃO ATENDIDO, VERIFICA O ÚLTIMO QUE FOI ATENDIDO
	cQuery += " AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT) = 0  " + LF
	
	cQuery += " AND (B1_TIPO) != 'AP' " +LF //Despreza Apara 
	//cQuery += " AND (C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
	cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
	cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF
	
	If nFamilia = 1
		cQuery += " AND (SB1.B1_SETOR) <> '39' " +LF
	Elseif nFamilia = 2
		cQuery += " AND (SB1.B1_SETOR) = '39' " +LF
	Endif
	cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
	cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF
	//cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN " + LF
	cQuery += " AND C6_PRODUTO = B1_COD     "  +LF
	
	cQuery += " AND C6_NUM = C5_NUM     " +LF
	cQuery += " AND C6_FILIAL = C5_FILIAL  " +LF
	
	cQuery += " AND C5_CLIENTE = A1_COD     " +LF
	cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF
	
	cQuery += " AND C5_VEND1 = A3_COD " +LF
	//cQuery += " AND A1_VEND = A3_COD " + LF
	cQuery += " AND A3_ATIVO <> 'N' " + LF
	
	//cQuery += " AND (C5_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 
	cQuery += " AND (C5_CLIENTE) = '" + Alltrim(cCliente) + "' " + LF
	cQuery += " AND (C5_LOJACLI) = '" + Alltrim(cLoja) + "' " + LF 
	
	cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
	cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
	cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
	cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
	cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF
	
	
	cQuery += " GROUP BY C5_NUM, C5_VEND1, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_ENTREG, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
	//cQuery += " ORDER BY C5_ENTREG DESC " +LF
	cQuery += " ORDER BY " + LF
	cQuery += " CASE WHEN SC5.C5_ENTREG = '' THEN SC5.C5_EMISSAO ELSE SC5.C5_ENTREG END DESC " + LF
	
	MemoWrite("C:\temp\ulticompra2.sql", cQuery)
	
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
			nKilos  := SC5U->PESO
			cPedido := SC5U->C5_NUM 
			nSaldo	:= SC5U->ATEND
								
			SC5U->(DBSKIP())
		
		Enddo
		
		//msgbox("SALDO: " + str(nSaldo) )
		If nSaldo >  0
			lAtendido := .F. 
			//msgbox("NÃO ATENDIDO")
		Else
			lAtendido := .T.
		Endif
		Aadd(aRetorno, { dUltima , nReais , nKilos ,lAtendido } )	
    Else
    	lAtendido := .T.
    	
    Endif

	
Endif


DbSelectArea("SC5U")
DbCloseArea()


Return(aRetorno)



******************************
Static Function fCabeca(nPag, titulo,cRegiao) 
******************************

Local cWeb := ""
Local cEmpresa := ""

If SM0->M0_CODFIL = '01' 
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa:= "Rava-" + SM0->M0_FILIAL
Endif

/////CABEÇALHO PÁGINA
cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
cWeb += '<html><head>'+ LF
cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cWeb += '<tr>    <td>'+ LF
cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cWeb += '<tr>        <td>SIGA /FATR024/v.P10</td>'+ LF
cWeb += '<td align="center">' + titulo +cRegiao+ '</td>'+ LF
cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cWeb += '</table></head>'+ LF   

Return(cWeb)



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

LICXX->( DbGoTop() )
If !LICXX->(EOF())
	cCodEdi := LICXX->Z17_NREDIT
	//While LICXX->( !EOF() )         
	
		cFamilia:= LICXX->B1FAMILIA
		cProduto:= LICXX->Z18_PROD
		
		While LICXX->(!EOF()) .AND. Alltrim(LICXX->Z17_NREDIT) == Alltrim(cCodEdi)
			nSaldoVal += LICXX->SALDOVL
			nSaldoQT  += LICXX->SALDOQT
			LICXX->(DBSKIP())
		Enddo
		//Aadd(aRet, { LICXX->Z17_NREDIT, LICXX->Z18_PROD,  Alltrim(Substr(LICXX->B1FAMILIA,1,35)), LICXX->SALDOVL, LICXX->SALDOQT } ) 
		
	//Enddo
	If nSaldoVal < 0
		nSaldoVal := 0
	Endif	
	Aadd(aRet, { cCodEdi, cProduto,  Alltrim(Substr(cFamilia,1,35)), nSaldoVal, nSaldoQT } ) 
Endif


DbSelectArea("LICXX")
DbCloseArea()

Return(aRet)

****************************
Static Function fCabRel(nFamilia, nTipoCli, nLinhas, nDias)
****************************

Local cWeb := ""

///Cabeçalho relatório	      
cWeb += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cWeb += '<td colspan="3" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
cWeb += '<td colspan="2"><div align="center"><span class="style3" style="font-size:14px"><b>VENDA MEDIA DOS ' + Alltrim(str(nDias)) + ' DIAS</span></div></b></td>'+LF
cWeb += '<td colspan="3"><div align="center"><span class="style3" style="font-size:14px"><b>ULTIMO PEDIDO - Programado Para:</span></div></b></td>'+LF			
			
If nTipoCli = 2
	cWeb += '<td colspan="4"><div align="center"><span class="style3" style="font-size:14px"><b>ULTIMA LICITACAO</span></div></b></td>'+LF						
Endif			
cWeb += '</tr>'+ LF			
nLinhas++
						
cWeb += '<tr>'+ LF
cWeb += '<td width="120" align="center"><span class="style3">Nome</span></td>'+ LF 	
cWeb += '<td width="120" align="center"><span class="style3">Contato</span></td>'+ LF
cWeb += '<td width="100" align="center"><span class="style3">Telefone</span></td>'+ LF
If nFamilia = 1   
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
	cWeb += '<td width="200" align="center"><span class="style3">KG</span></td>'+ LF	//média dos 90 dias
				   
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
	cWeb += '<td width="200" align="center"><span class="style3">KG</span></td>'+ LF 	//última compra KG  
	cWeb += '<td width="200" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA
Elseif nFamilia = 2 
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
	cWeb += '<td width="200" align="center"><span class="style3">QTD</span></td>'+ LF	//média dos 90 dias
				   
	cWeb += '<td width="200" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
	cWeb += '<td width="200" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra QTD
	cWeb += '<td width="200" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA			
Endif
			
If nTipoCli = 2
	cWeb += '<td width="200" align="center"><span class="style3">Numero Licitacao</span></td>'+ LF 	//NUMERO LICITAÇÃO
	cWeb += '<td width="200" align="center"><span class="style3">Saldo a Fornecer (R$)</span></td>'+ LF 	//SALDO A FORNECER  
	If nFamilia = 1   //sacos
		cWeb += '<td width="200" align="center"><span class="style3">Saldo a Fornecer (KG)</span></td>'+ LF 	//SALDO A FORNECER
	Elseif nFamilia = 2    //caixas
		cWeb += '<td width="200" align="center"><span class="style3">Saldo a Fornecer (QTD)</span></td>'+ LF 	//SALDO A FORNECER  
	Endif  
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
Static Function fEnvSUPER(aDadRe) 
**********************************
Local lTemDados := .F.
Local cMailAssis:= ""


If Len(aDadRe) > 0	
	Do While nCta <= Len(aDadRe)
	       
	       cSuper	  := aDadRe[nCta,7]
	       cMailAssis := ""
			SA3->(Dbsetorder(1))
			If SA3->(Dbseek(xFilial("SA3") + cSuper))
				//cMailSuper := SA3->A3_EMAIL   ///captura o email do coordenador para posterior envio do arq. html		
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
	       
	       If lDentroSiga
		       	////cria o diretório local, caso não exista
				lDir := ExistDir('C:\RELVENDAS') // Resultado: .F.
				cDir := "C:\RELVENDAS\"
				If !lDir
					//msgbox("cria Dir")
					U_CriaDir( cDir ) 
				Endif
				////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE	  
				cArq  := "REL03_Coord_" + Alltrim(cSuper) + "_.HTM" 	
				nHand := fCreate( cDir + cArq, 0 )			    
				If nHand = -1
				     MsgAlert('o arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
	       Endif
	   				   
		   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
		   	cDirHTM  := "\Temp\"    
			cArqHTM  := "REL03_Coord_" + Alltrim(cSuper) + "_.HTM"  //FR - 08/10/13 - voltou a ser por coordenador
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
	       cWeb := ""
	       
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
	         
	        
	  	nLinhas:= 5  	
	  	//Do While nCta <= Len(aDadRe) .and.  alltrim(aDadRe[nCta,38])==alltrim(cRegiao)
	  	Do While nCta <= Len(aDadRe) .and.  alltrim(aDadRe[nCta,7])==alltrim(cSuper)
	   	   	
	   	   	cCodRepre := aDadRe[nCta,1]
	   		cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]
	   		cMailSuper:= aDadre[nCta,29]
	   	    cUfRepre    := aDadRe[nCta,37]
  		
	   		cWeb += fCabeca(nPag, titulo,cRegiao)  		
	   		/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += LinhaRepSup(aDadRe, nCta, cMailRepre, cMailSuper)		
			
			nLinhas++
			nLinhas++
			
			///Cabeçalho relatório
			cWeb += fCabRel(nFamilia, nTipoCli, nLinhas, nDias)		
			nPag++
	
	 	   
		    //laço para imprimir uma caixinha para cada representante
			Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre)+"VD")
			
			  If nCta <= Len(aDadRe)
		   		
		   		   		   	
		   		If nLinhas >= 54
		   		
		   			cWeb += fCabeca(nPag, titulo,cRegiao)  		
			   		nLinhas := 5
			
					/////////////////////////////////////
					////LINHA REPRESENTANTE E SUPERVISOR
					/////////////////////////////////////
					cWeb += LinhaRepSup(aDadRe, nCta, cMailRepre, cMailSuper)		
									
					nLinhas++
					nLinhas++
				
					///Cabeçalho relatório 
					cWeb += fCabRel(nFamilia, nTipoCli, nLinhas, nDias)			
					nPag++
		
			    Endif
		      	
		      	////IMPRESSÃO DOS DADOS...
		      	If (aDadRe[nCta,30])      //se foi atendido	      	
		      	
			      	If !Empty(aDadRe[nCta,23]) .and. !Empty(aDadRe[nCta,25])
				      	//NOME CLIENTE    		
					    cWeb += '<td width="420"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25))+'- UF:'+Alltrim(aDadRe[nCta,39]) + '</span></td>'+LF        		
					    //NOME CONTATO
					    cWeb += '<td width="120"><span class="style3">'+ Alltrim(aDadRe[nCta,31]) + '</span></td>'+LF        		
					    //TEL CONTATO
					    cWeb += '<td width="100"><span class="style3">'+ Transform( Alltrim(aDadRe[nCta,32]), PesqPict("SA1","A1_TEL") ) + '</span></td>'+LF       		
					    						
						///média 90 dias (R$ / KG)
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						/// última compra (R$ / KG / DATA)
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
					
						If nTipoCli = 2
							///licitação
							cWeb += '<td width="200" align="right"><span class="style3">' + aDadRe[nCta,33] + '</span></td>'+LF  //NUM LIC
							///saldo
							If !Empty(aDadRe[nCta,33])
								cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,35], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO A FORNECER R$
								cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,36], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO A FORNECER QTDE
							Else
								cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
								cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
							Endif
							///produto
							cWeb += '<td width="420" align="left"><span class="style3">' + aDadRe[nCta,34] + '</span></td>'+LF  //PRODUTO
						Endif
						
						///ACUMULA TOTAIS
					    nTotMedia += aDadRe[nCta,23]				
						nTotMedKG += aDadRe[nCta,25]				
						nTotUltRS += aDadRe[nCta,26]				
						nTotUltKG += aDadRe[nCta,27]	
					Endif  //do !Empty valores das médias
					
				Else 
					
					If !Empty(aDadRe[nCta,23]) .and. !Empty(aDadRe[nCta,25])
						//se o pedido estiver pendente, a linha ficará em "cinza"
						//NOME CLIENTE    		
					    cWeb += '<td width="920" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25))+'- UF:'+Alltrim(aDadRe[nCta,39]) + '</span></td>'+LF        		
					    
					    //NOME CONTATO
					    cWeb += '<td width="120" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,31]) + '</span></td>'+LF        		
					    //TEL CONTATO
					    cWeb += '<td width="100" bgcolor="#D0D0D0"><span class="style3">'+ Transform( Alltrim(aDadRe[nCta,32]), PesqPict("SA1","A1_TEL") ) + '</span></td>'+LF        		
					    
					    //bgcolor="#D0D0D0" cinza						
					    //bgcolor="#FFFFC0" amarelo
						///média 90 dias (R$ / KG)
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						/// última compra (R$ / KG / DATA)
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
					
						If nTipoCli = 2
							///licitação
							cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + aDadRe[nCta,33] + '</span></td>'+LF  //NUM LIC
							///saldo
							If !Empty(aDadRe[nCta,33])
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,35], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO a FORNECER R$
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,36], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO a FORNECER QTD
							Else
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
							Endif
							///produto
							cWeb += '<td width="420" align="left" bgcolor="#D0D0D0"><span class="style3">' + aDadRe[nCta,34] + '</span></td>'+LF  //PRODUTO
						Endif
						
						///ACUMULA TOTAIS
					    nTotMedia += aDadRe[nCta,23]				
						nTotMedKG += aDadRe[nCta,25]				
						nTotUltRS += aDadRe[nCta,26]				
						nTotUltKG += aDadRe[nCta,27]	
						
				    Endif //do !Empty valores das médias
				Endif
				cWeb += '</tr>'+LF 		//finaliza a linha
				nLinhas++
				
			 
			   	nCta++
			   	
			   	If nLinhas = 54
			   		nLinhas := nLinhas + 0.5
			   	Endif
			   		   	   	
			   	If lDentroSiga
					IncRegua()	
				Endif
				
			  Else
			  	//msgbox("nCta: " + str(nCta) )
			  Endif	
			Enddo //laço caixinha representante
	    		
	   			
			If nTotMedia <= 0
				cWeb += '<td width="920" colspan="8"><span class="style3">Não Existem Clientes Ativos Para Este Representante</span></td>'+LF
				cWeb += '</tr>'+LF 		//finaliza a linha        		
			Endif	  		       
			cWeb += '<td width="920" colspan="3" align="right"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			If nTipoCli = 2
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			Endif			
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			nTotMedia:= 0
			nTotMedKG:= 0
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
			
					
			//EndDo // fim da quebra por regiao 
		Enddo //fim da quebra por Coordenador
			
			///faz o rodapé
			cWeb += fRodape()			
								   			   			    
			///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
					
			///GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			
			If lDentroSiga
				///GRAVA O HTML
				Fwrite( nHand, cWeb, Len(cWeb) )
				FClose( nHand )
				
				//////////////////////////////////////
				// Exibe o arquivo HTML no Navegador 
				//////////////////////////////////////
				fAbreHTM(cDir, cArq)
										                      
				//////SELECIONA O EMAIL DESTINATÁRIO DO USUÁRIO LOGADO NO SIGA
				cCodUser := __CUSERID     
				//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo
				
				PswOrder(1)
				If PswSeek( cCoduser, .T. )
				   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
				   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
				   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
				   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
				Endif
				
				cCopia	:= ""								
				cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := "Rel. 03 - " + cSuper //titulo
							
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
				MsgInfo("Rel 03 - Você recebeu um e-mail deste Relatório.")
			
			Else					                      
					
				cMailTo := cMailSuper
				cMailTo += ";" + cMailAssis   //emails dos assistentes de vendas
				cCopia  := ""
				
	            //cMailTo:= 'antonio@ravaembalagens.com.br'
	              //FR - 08/10/13 - retirado, voltou a ser por coordenador
	            //cMailTo := ""
				//If ALLTRIM(getReg(cUfRepre))$'NO/CE'   
				//   cMailTo  :='noce@ravaembalagens.com.br' 
				//elseIf ALLTRIM(getReg(cUfRepre))$'NE'   
				//   cMailTo  :='ne@ravaembalagens.com.br' 
				//elseIf ALLTRIM(getReg(cUfRepre))$'SL/SD'   
				//   cMailTo  :='slsd@ravaembalagens.com.br' 
				//Endif			
						
				If Alltrim(cSuper) = '0342' //se Luis Figuera
					cCopia += ";cecilia@ravaembalagens.com.br"  //assistente Luis
					
				ElseIf Alltrim(cSuper) = '2348' .or. Alltrim(cSuper) = '0319' //se Janaina ou George			
					cCopia += ";amanda@ravaembalagens.com.br"  //Assistente Janaina
					
				ElseIf Alltrim(cSuper) = '0228' //se Josenildo
					cCopia += ";isaac.oliveira@ravaembalagens.com.br" //assistente Jojó
														
				ElseIf Alltrim(cSuper) = '0315' //se Jacqueline			  
				  cCopia += ";vendas.sp@ravaembalagens.com.br"	//email assistente Jacque
	
				ElseIf Alltrim(cSuper) = '0316' //Flávio
			   		cCopia  += ";diego.rodrigues@ravaembalagens.com.br"
			   		cCopia  += ";camila.samara@ravaembalagens.com.br"
			   		
				Endif
				cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)
				cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
							
				//cMailTo := "" //retirar
				//cCopia  := "" //retirar
				cCopia  += ";flavia.rocha@ravaembalagens.com.br"
				
							
				cCorpo  += CHR(13) + CHR(10)  + titulo + CHR(13) + CHR(10)  //+cRegiao  + CHR(13) + CHR(10) 
				cCorpo  += "Este arquivo é melhor visualizado no navegador Mozilla Firefox." + CHR(13) + CHR(10)
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := titulo	
			
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
			
			Endif //lDentrosiga
					
			nLinhas := 80						
			nPag := 1		
	     
	
	  	Enddo  //VOLTAR

Else
	lTemDados := .F.
	If lDentroSiga
		If !lTemDados
			MsgInfo("Não foram encontrados Dados para os Parâmetros Selecionados.")	
		Endif		  
	Endif	
Endif //len aDadRe

Return


*******************************************
Static Function LinhaRepSup(aDadRe, nCta, cMailRepre, cMailSuper)  
*******************************************

Local cWebs := ''
////////////////////////////////////
////LINHA REPRESENTANTE E SUPERVISOR
/////////////////////////////////////
cWebs += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
cWebs += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
cWebs += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td>'+LF
cWebs += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
cWebs += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
cWebs += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
cWebs += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td>'+LF
cWebs += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
cWebs += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
cWebs += '</table>' + LF			

Return cWebs

***************************************************************
Static Function fEnvREPRE(aDadRe, nCta)
***************************************************************
Local cMailAssis := ""

Do While nCta <= Len(aDadRe)
	    
	       	cCodRepre := aDadRe[nCta,1] 
	       	cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]
	   				   
		   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
		   	cDirHTM  := "\Temp\"    		
            cArqHTM  := "REL03_Repr_" + Alltrim(cCodRepre) + "_.HTM"    
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
	       cWeb := ""
	       
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
	        
	  		nLinhas:= 5  	
	  
		   	cSuper    := aDadRe[nCta,7]
			cMailSuper:= aDadre[nCta,29] 
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
	   	    cUfRepre    := aDadRe[nCta,37]
	   	    cUfRepre    := aDadRe[nCta,37]
	   		cWeb += fCabeca(nPag, titulo,cRegiao)  		
	   		
	   		/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
			cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
			cWeb += '</table>' + LF			
			
			nLinhas++
			nLinhas++
			
			///Cabeçalho relatório	   		
			cWeb += fCabRel(nFamilia, nTipoCli, nLinhas, nDias)		
			nPag++
        
		    //laço para imprimir uma caixinha para cada representante
			Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre)+"VD")
			
			  If nCta <= Len(aDadRe)
		   		
		   		   		   	
		   		If nLinhas >= 54
		   		
		   			cWeb += fCabeca(nPag, titulo,cRegiao)  		
			   		nLinhas := 5
			
					/////////////////////////////////////
					////LINHA REPRESENTANTE E SUPERVISOR
					/////////////////////////////////////
					cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
					cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
					cWeb += '<td width="500"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
					cWeb += '</table>' + LF
									
					nLinhas++
					nLinhas++
				
					///Cabeçalho relatório 
					cWeb += fCabRel(nFamilia, nTipoCli, nLinhas, nDias)			
					nPag++
		
			    Endif
		      	
		      	////IMPRESSÃO DOS DADOS...
		      	If (aDadRe[nCta,30])      //se foi atendido	      	
		      	
			      	If !Empty(aDadRe[nCta,23]) .and. !Empty(aDadRe[nCta,25])
				      	//NOME CLIENTE    		
					    cWeb += '<td width="420"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25))+'- UF:'+Alltrim(aDadRe[nCta,39]) + '</span></td>'+LF        		
					    //NOME CONTATO
					    cWeb += '<td width="120"><span class="style3">'+ Alltrim(aDadRe[nCta,31]) + '</span></td>'+LF        		
					    //TEL CONTATO
					    cWeb += '<td width="100"><span class="style3">'+ Transform( Alltrim(aDadRe[nCta,32]), PesqPict("SA1","A1_TEL") ) + '</span></td>'+LF       		
					    						
						///média 90 dias (R$ / KG)
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						/// última compra (R$ / KG / DATA)
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
					
						If nTipoCli = 2
							///licitação
							cWeb += '<td width="200" align="right"><span class="style3">' + aDadRe[nCta,33] + '</span></td>'+LF  //NUM LIC
							///saldo
							If !Empty(aDadRe[nCta,33])
								cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,35], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO A FORNECER R$
								cWeb += '<td width="200" align="right"><span class="style3">' + Transform(aDadRe[nCta,36], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO A FORNECER QTDE
							Else
								cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
								cWeb += '<td width="200" align="right"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
							Endif
							///produto
							cWeb += '<td width="420" align="left"><span class="style3">' + aDadRe[nCta,34] + '</span></td>'+LF  //PRODUTO
						Endif
						
						///ACUMULA TOTAIS
					    nTotMedia += aDadRe[nCta,23]				
						nTotMedKG += aDadRe[nCta,25]				
						nTotUltRS += aDadRe[nCta,26]				
						nTotUltKG += aDadRe[nCta,27]	
					Endif  //do !Empty valores das médias
					
				Else 
					
					If !Empty(aDadRe[nCta,23]) .and. !Empty(aDadRe[nCta,25])
						//se o pedido estiver pendente, a linha ficará em "cinza"
						//NOME CLIENTE    		
					    cWeb += '<td width="920" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25))+'- UF:'+Alltrim(aDadRe[nCta,39]) + '</span></td>'+LF        		
					    
					    //NOME CONTATO
					    cWeb += '<td width="120" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,31]) + '</span></td>'+LF        		
					    //TEL CONTATO
					    cWeb += '<td width="100" bgcolor="#D0D0D0"><span class="style3">'+ Transform( Alltrim(aDadRe[nCta,32]), PesqPict("SA1","A1_TEL") ) + '</span></td>'+LF        		
					    
					    //bgcolor="#D0D0D0" cinza						
					    //bgcolor="#FFFFC0" amarelo
						///média 90 dias (R$ / KG)
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						/// última compra (R$ / KG / DATA)
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
						cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
					
						If nTipoCli = 2
							///licitação
							cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + aDadRe[nCta,33] + '</span></td>'+LF  //NUM LIC
							///saldo
							If !Empty(aDadRe[nCta,33])
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,35], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO a FORNECER R$
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,36], "@E 9,999,999.99") + '</span></td>'+LF  //SALDO a FORNECER QTD
							Else
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
								cWeb += '<td width="200" align="right" bgcolor="#D0D0D0"><span class="style3">'+ "  " +'  </span></td>'+LF  //SALDO
							Endif
							///produto
							cWeb += '<td width="420" align="left" bgcolor="#D0D0D0"><span class="style3">' + aDadRe[nCta,34] + '</span></td>'+LF  //PRODUTO
						Endif
						
						///ACUMULA TOTAIS
					    nTotMedia += aDadRe[nCta,23]				
						nTotMedKG += aDadRe[nCta,25]				
						nTotUltRS += aDadRe[nCta,26]				
						nTotUltKG += aDadRe[nCta,27]	
						
				    Endif //do !Empty valores das médias
				Endif
				cWeb += '</tr>'+LF 		//finaliza a linha
				nLinhas++				
			   	nCta++
			   	
			   	If nLinhas = 54
			   		nLinhas := nLinhas + 0.5
			   	Endif
			   				
			  Else
			  	//msgbox("nCta: " + str(nCta) )
			  Endif	
			Enddo //laço caixinha representante
	    		
	   			
			If nTotMedia <= 0
				cWeb += '<td width="920" colspan="8"><span class="style3">Não Existem Clientes Ativos Para Este Representante</span></td>'+LF
				cWeb += '</tr>'+LF 		//finaliza a linha        		
			Endif	  		       
			cWeb += '<td width="920" colspan="3" align="right"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			If nTipoCli = 2
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			Endif			
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			nTotMedia:= 0
			nTotMedKG:= 0
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
						
			//cMailTo := "" //retirar
			//cCopia  := "" //retirar
			cCopia  += ";flavia.rocha@ravaembalagens.com.br" //retirar
			
						
			cCorpo  += CHR(13) + CHR(10)  + titulo + CHR(13) + CHR(10)  //+cRegiao  + CHR(13) + CHR(10) 
			cCorpo  += "Este arquivo é melhor visualizado no navegador Mozilla Firefox." + CHR(13) + CHR(10)
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo  //+cRegiao
			
			/*		
			If Substr(DtoS(dDatabase),7,2) = "15" .and. Alltrim(cSuper) $ '0255/0315/0320'   //Flavia Leite só recebe todo dia 15
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			ElseIf Substr(DtoS(dDatabase),7,2) = "01" .and. Alltrim(cSuper) = '0316'   //Flavio Alves só recebe todo dia 1o.
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			
			Elseif Substr(DtoS(dDatabase),7,2) != "15" .and. Alltrim(cSuper) != '0255' .and. Alltrim(cSuper) != '0315';
			  .and. Alltrim(cSuper) != '0316' .and. Alltrim(cSuper) != '0320'
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			Endif
			*/
			
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
			
			nLinhas := 80						
			nPag := 1		
	     
	
	  Enddo  //laço principal do array
Return