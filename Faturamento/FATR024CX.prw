#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR024CX
//Objetivo: Relatório 03 - Venda de Caixas por Clientes Ativos ( Compraram nos últimos 90 Dias)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 07/01/2011
//Alterado por Flavia Rocha em: 12/08/11 - chamado 002244 - Janderley:
//Conforme abaixo: 
// 1) Coluna "Último Faturamento" alterar para "Último Pedido", considerando a 
//    data de FATURAMENTO/PROGRAMAÇÃO. Nessa coluna deve-se levar em consideração 
//    em primeiro lugar o "Último Pedido" pendente para depois considerar o "Último Pedido" 
//    atendido de cada cliente. 
// 2) Colocar uma TARJA nos pedidos que estão "ABERTO/PENDENTES" 

//AGENDAMENTO: semanal, toda 5a. feira - TODOS COORDENADORES
//AGENDAMENTO:  Flavia Leite e cada representante recebe o seu Todo dia 15 do mês.
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR024CX()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
   	//RAVA EMB
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f24()	//chama a função do relatório
  	
  	//RAVA CAIXAS
  	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	f24()	//chama a função do relatório
  
Else
  lDentroSiga := .T.
  f24()
  
EndIf
  

Return

************************************
Static Function f24()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório 03 - Venda de Sacos por Clientes Ativos ( Compraram nos últimos 90 Dias)"
Local cPict          := ""
Local titulo         := "" 


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
Private nomeprog     := "FATR024CX" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR024CX" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR024"
Private cString := ""

Private dData		:= Ctod("  /  /    ")
Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")

Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 

Private cWeb		:= Space(2000)
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private nLinhas		:= 80 
Private nLin        := 80
Private cCodRepre 	:= ""
Private cNomeRepre	:= ""
Private cMailRepre	:= ""


Private aMeses		:= {}
Private aNomMeses	:= {}
Private nPosMes		:= 0


Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private lUltimo		:= .F.
Private nCta		:= 0
Private nMesData2
	


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
dData1 := dData2 - 90		//3 meses - Sr. Viana em 17/12/10 pediu para alterar novamente



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


titulo         := "Relatorio 03 - VENDA DE CAIXAS POR CLIENTES ATIVOS (COMPRARAM NOS ULTIMOS 90 DIAS) - POR REPRESENTANTE"


If lDentroSiga
	
	Pergunte("FATR024",.T.)    //INFORME O REPRESENTANTE
	/*
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório 03 ?")
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Else

	RunReport(Cabec1,Cabec2,Titulo,nLin)
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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

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
Local nTotUltRS := 0
Local nTotUltKG := 0 
Local nHandle     
Local aUltima	:= {}
Local lAtendido := .F. 
Local cSegmento := ""


cQuery := " SELECT ROUND(SUM(C6_QTDVEN),2) AS QTDCX ,  " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NOME,C5_EMISSAO, A3_GEREN " + LF 
cQuery += " , C5_VEND1 " + LF
cQuery += " , C5VEND1 = CASE WHEN C5_VEND1 LIKE ('%VD') THEN LEFT(C5_VEND1,4) ELSE C5_VEND1 END " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( RTRIM(A3_SUPER) <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " , A3_EMAIL, A3_ATIVO, A1_SATIV1 " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' " +LF
//cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dDatabase - 90) + "' AND SC5.C5_EMISSAO <= '" + Dtos(dDatabase) + "' " + LF

cQuery += " AND RTRIM(B1_TIPO) != 'AP' " +LF //Despreza Apara 
//cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' " +LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_PRODUTO = B1_COD     "  +LF
cQuery += " AND C6_NUM = C5_NUM      " +LF
cQuery += " AND C6_FILIAL = C5_FILIAL      " +LF

cQuery += " AND C6_CLI = C5_CLIENTE " +LF
cQuery += " AND C6_LOJA = C5_LOJACLI       " +LF

cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF

cQuery += " AND C5_VEND1 = A3_COD " +LF
//cQuery += " AND A1_VEND = A3_COD " + LF
cQuery += " AND A3_ATIVO <> 'N' " + LF
//cQuery += " AND A1_SATIV1 <> '000009' " + LF // EXCLUI OS ÓRGÃOS PÚBLICOS

//cquery += " AND RTRIM(C5_CLIENTE) = '001704' AND RTRIM(C5_LOJACLI) = '01' " + LF



If lDentroSiga
	cQuery += " AND RTRIM(C5_VEND1) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(C5_VEND1) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND RTRIM(A3_SUPER) = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif
Else
	cQuery += " AND (C5_VEND1) >= ''  AND (C5_VEND1) <= 'ZZZZZZ' " + LF 
	If Substr(DtoS(dDatabase),7,2) = "15" //no dia 15 de cada mês, só executa o de Flávia Leite (0255)
		cQuery += " AND (A3_SUPER) = '0255' " + LF	
	Else
		cQuery += " AND (A3_SUPER) <> '0255' " + LF		
	Endif

Endif

//cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
//cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
//cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
//cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
//cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
//cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_VEND1,C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO,A1_SATIV1 " +LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO " +LF
MemoWrite("C:\Temp\fatr024CX.sql", cQuery )
          
If Select("REP") > 0
	DbSelectArea("REP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "REP"

TCSetField( "REP", "C5_EMISSAO", "D")

REP->( DbGoTop() )

//SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While REP->( !EOF() )

	cSuper 		:= ""
    cNomeSuper 	:= ""
    cGeren		:= ""
	cNomeGeren	:= ""
	    
    cCodRepre 	:= REP->C5VEND1
	cNomeRepre	:= REP->A3_NOME
	cMailRepre	:= REP->A3_EMAIL
	cAtivo		:= REP->A3_ATIVO
	
	cCliente	:= REP->C5_CLIENTE
	cLoja		:= REP->C5_LOJACLI
	cSegmento   := REP->A1_SATIV1
	
	cNomeCli	:= Alltrim(REP->A1_NOME)
	nTotCartR:= 0
	nTotCartK:= 0
    
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
		cSuper 		:= REP->C5VEND1
		cNomeSuper	:= REP->A3_NOME
		cMailSuper  := REP->A3_EMAIL
	Endif
	
	///captura o valor, kg e data da última compra
	//nUltimaRS	:= fUltiCompra( cCliente, cLoja, cCodRepre, "R" )
	//nUltimaKG	:= fUltiCompra( cCliente, cLoja, cCodRepre, "K" )
	//dUltima		:= fUltiCompra( cCliente, cLoja, cCodRepre, "D" )
	///captura o valor, kg e data da última compra
	
	aUltima	    := fUltiCompra( cCliente, cLoja, cCodRepre )
	//nUltimaRS	:= fUltiCompra( cCliente, cLoja, cCodRepre, "R" )
	//nUltimaKG	:= fUltiCompra( cCliente, cLoja, cCodRepre, "K" )
	//dUltima		:= fUltiCompra( cCliente, cLoja, cCodRepre, "D" )
	//Aadd(aRetorno, { dUltima , nReais , nKilos ,lAtendido } )
	dUltima		:= aUltima[1,1]
	nUltimaRS	:= aUltima[1,2]
	nUltimaKG	:= aUltima[1,3]
	lAtendido	:= aUltima[1,4]
	

	Do While Alltrim(REP->C5_CLIENTE + REP->C5_LOJACLI ) = Alltrim(cCliente + cLoja) 
		Do Case
			Case Month( REP->C5_EMISSAO ) = nMes1
				nTotVM1 += REP->VALOR
				nTotPM1 += REP->QTDCX
			Case Month( REP->C5_EMISSAO ) = nMes2
				nTotVM2 += REP->VALOR
				nTotPM2 += REP->QTDCX
			Case Month( REP->C5_EMISSAO ) = nMes3
				nTotVM3 += REP->VALOR
				nTotPM3 += REP->QTDCX
			
		Endcase
			
	    nRegTot++
		REP->(DBSKIP())	
	Enddo
	
	nMedia		:= ( (nTotVM1 + nTotVM2 + nTotVM3) / 3 )
	nMediaKG	:= ( (nTotPM1 + nTotPM2 + nTotPM3) / 3 )
	
	If Alltrim(cSuper) != '0255' .and. Alltrim(cSegmento) != '000009'
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
	   				cMailSuper,;        //29
	   				lAtendido  } )      //30 
	   				
	   	Elseif Alltrim(cSuper) = '0255'
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
	   				cMailSuper,;        //29
	   				lAtendido  } )      //30
	   				
	   	Endif
	   	
	   			


Enddo

//aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Dtos(X[28]) < Y[7] + Y[1] + Dtos(Y[28])  } )  //ordena por representante + dt. ultima compra (mais antiga)
//FR - 09/06/2011 - Solicitado por Janderley alterar a ordem, por qtde comprada  
aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Transform( X[27], "@E 99,999,999.99" ) > Y[7] + Y[1] + Transform( Y[27], "@E 99,999,999.99" )  } )  //ordena por representante + dt. ultima compra (mais antiga)

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
cMailSuper	:= ""

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
	  Do While nCta <= Len(aDadRe)
	     
	   		cCodRepre := aDadRe[nCta,1]
	   		cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]
	   		cSuper	  := aDadRe[nCta,7] 
	   		cMailSuper:= aDadRe[nCta,29]
	   
		   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
		   	cDirHTM  := "\Temp\"    
			cArqHTM  := "REL03_" + Alltrim(cCodRepre) +".HTM"   
			
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
	   
	   If nLinhas >= 55  	
	   		
	   		cWeb += fCabeca(nPag, titulo)  		
		   	nLinhas := 5
	   		
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
			cWeb += '<table width="1100" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>VENDA MEDIA DOS 90 DIAS</span></div></b></td>'+LF
			cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMO PEDIDO</span></div></b></td>'+LF			
			cWeb += '<tr>'+ LF
			nLinhas++
			
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF	//média dos 90 dias
			   
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
			cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
			cWeb += '</strong></tr>'+ LF				
	   		nLinhas++
	   		
			nPag++
	
	   Endif
	   
	   
		Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre)+"VD")
		
		  If nCta <= Len(aDadRe)
	   		
	   		   		   	
	   		If nLinhas >= 54
	   		
	   			cWeb += fCabeca(nPag, titulo)  		
		   		nLinhas := 5
		
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
				cWeb += '<table width="1100" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>VENDA MEDIA DOS 90 DIAS</span></div></b></td>'+LF
				cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMO PEDIDO</span></div></b></td>'+LF			
				cWeb += '<tr>'+ LF
				nLinhas++
					
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
				cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF	//média dos 90 dias
				   
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
				cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
				cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
				cWeb += '</strong></tr>'+ LF
				nLinhas++
			   		
				nPag++
	
		    Endif
	      	
	      	////IMPRESSÃO DOS DADOS...
	      	If (aDadRe[nCta,30])      //se foi atendido	      	
	      	
		      	//NOME CLIENTE    		
			    cWeb += '<td width="920"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
			    						
				///média 90 dias (R$ / KG)
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				/// última compra (R$ / KG / DATA)
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
			Else 
				//se o pedido estiver pendente, a linha ficará em "amarelo"
				//NOME CLIENTE    		
			    cWeb += '<td width="920" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
			    						
				///média 90 dias (R$ / KG)
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				/// última compra (R$ / KG / DATA)
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
			
			Endif
			
			cWeb += '</tr>'+LF 		//finaliza a linha
			nLinhas++
			
						        
		    ///ACUMULA TOTAIS
		    nTotMedia += aDadRe[nCta,23]				
			nTotMedKG += aDadRe[nCta,25]				
			nTotUltRS += aDadRe[nCta,26]				
			nTotUltKG += aDadRe[nCta,27]	
		      
		   	nCta++
		   	
		   	If nLinhas = 54
		   		nLinhas := nLinhas + 0.5
		   	Endif
		   	/*
		   	If nCta > 5 .and. nLinhas >= 55        //aqui a quebra não funciona
			   cWeb += '<div class="quebra_pagina"></div>'+LF
			   	msgbox("Quebrou: " + str(nLinhas) )
			   	cWeb += fCabeca(nPag, titulo)  
			   	nLinhas := 5	   		
				nPag++
			   		
			Endif
		    */
		   	   	
		   	If lDentroSiga
				IncRegua()	
			Endif
			
		  Else
		  	//msgbox("nCta: " + str(nCta) )
		  Endif	
		Enddo
	    		
	   			
				  		       
			cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
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
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="98%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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
					
								   			   			    
			///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
					
			///GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
								                      
			cMailTo := cMailRepre + ";" + cMailSuper //e-mail
			//cMailTo := "flavia.rocha@ravaembalagens.com.br"  
			cCopia := ""
									
			
			If Alltrim(cSuper) = '0255'
			  cMailTo += ";vendas.sp@ravaembalagens.com.br"
			
			ElseIf Alltrim(cSuper) $ '0229/0244'
				cMailTo += ";janaina@ravaembalagens.com.br"
				
			Elseif Alltrim(cSuper) = '0245'
				cMailTo += ";marcos@ravaembalagens.com.br"
			
			Elseif Alltrim(cSuper) = '0248'
				cMailTo += ";josenildo@ravaembalagens.com.br"
			Endif
			
			cCopia  += ";flavia.rocha@ravaembalagens.com.br"
						
			cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
					
			If Substr(DtoS(dDatabase),7,2) = "15" .and. Alltrim(cSuper) = '0255'
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			Elseif Alltrim(cSuper) != '0255'
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			Endif
				
				
			nLinhas := 80						
			nPag := 1		
	     
	
	  Enddo
	
	Endif
	
	
	
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
Else		//////////emitindo dentro do Siga
	//msginfo("Dentro do Siga")
	
	nCta := 1 
	If Len(aDadRe) > 0
		cSuper	  := aDadRe[nCta,7]
		////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
		cDirHTM  := "\Temp\"    
		cArqHTM  := "REL03_" + Alltrim(cSuper) +"_CX.HTM"   
		//cArqHTM  := "FLA03_" + Alltrim(cSuper) +".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
	    cWeb := ""
	       
	  Do While nCta <= Len(aDadRe)
	     
	   		cCodRepre := aDadRe[nCta,1]
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
	   //nLinhas := 80
	   
	   If nLinhas >= 55  	
	   		
	   		cWeb += fCabeca(nPag, titulo)  		
		   	nLinhas := 5
		   	nPag++
	   Endif
	        /*
	   		If nCta > 1
		   		////linha em branco
		   		cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
				cWeb += '<tr>'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				cWeb += '</table>'+LF
				nLinhas++
	   		
	   		Endif		
	   		*/
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
			cWeb += '<table width="1100" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>VENDA MEDIA DOS 90 DIAS</span></div></b></td>'+LF
			cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMO PEDIDO</span></div></b></td>'+LF			
			cWeb += '<tr>'+ LF
			nLinhas++
			
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF	//média dos 90 dias
			   
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
			cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
			cWeb += '</strong></tr>'+ LF				
	   		nLinhas++
	   		
			//nPag++
	
	   //Endif
	   
	   
		Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) .OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre)+"VD")
		
		  If nCta <= Len(aDadRe)	   		
	   		   		   	
		   		If nLinhas >= 54
		   		
		   			cWeb += fCabeca(nPag, titulo)  		
			   		nLinhas := 4
			   		nPag++
			
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
					cWeb += '<table width="1100" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>VENDA MEDIA DOS 90 DIAS</span></div></b></td>'+LF
					cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMO PEDIDO</span></div></b></td>'+LF			
					cWeb += '<tr>'+ LF
					nLinhas++
						
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF	//média dos 90 dias
					   
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
					cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
					cWeb += '</strong></tr>'+ LF
					nLinhas++
				   		
							
			    Endif
	      	
		      	////IMPRESSÃO DOS DADOS...
	      	If (aDadRe[nCta,30])      //se foi atendido	      	
	      	
		      	//NOME CLIENTE    		
			    cWeb += '<td width="920"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
			    						
				///média 90 dias (R$ / KG)
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				/// última compra (R$ / KG / DATA)
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
			Else 
				//se o pedido estiver pendente, a linha ficará em "amarelo"
				//NOME CLIENTE    		
			    cWeb += '<td width="920" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
			    //bgcolor="#D0D0D0" cinza 
			    //bgcolor="#FFFFC0" amarelo						
				///média 90 dias (R$ / KG)
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,25], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				/// última compra (R$ / KG / DATA)
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,26], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Transform(aDadRe[nCta,27], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				cWeb += '<td width="300" align="right" bgcolor="#D0D0D0"><span class="style3">' + Dtoc(aDadRe[nCta,28])  + '</span></td>'+LF  //DATA
			
			Endif
				
				cWeb += '</tr>'+LF 		//finaliza a linha
				nLinhas++
			
						        
			    ///ACUMULA TOTAIS
			    nTotMedia += aDadRe[nCta,23]				
				nTotMedKG += aDadRe[nCta,25]				
				nTotUltRS += aDadRe[nCta,26]				
				nTotUltKG += aDadRe[nCta,27]	
		      
		   		nCta++
		   	
			   	//If nLinhas = 54
			   		//nLinhas := nLinhas + 0.5
			   	//Endif
			   			   			   	   	
			   	If lDentroSiga
					IncRegua()	
				Endif		  
		  Endif		//if nCta <= Len(aDadRe)
		  	
		Enddo
	    		
	   			
				  		       
			cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			nTotMedia:= 0
			nTotMedKG:= 0
			nTotUltRS:= 0
			nTotUltKG:= 0					
		    
			If nCta > 1  //.and. nLinhas >= 55        //aqui a quebra não funciona
			   cWeb += '<div class="quebra_pagina"></div>'+LF			   
			   	//cWeb += fCabeca(nPag, titulo)  
			   	nLinhas := 80
				//nPag++
			   		
			Endif
		    		
	     
	
	  Enddo
	  
	  ///faz o rodapé
		cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="98%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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
					
								   			   			    
		///FECHA O HTML PARA ENVIO
		cWeb += '</body> '
		cWeb += '</html> '
					
		///GRAVA O HTML
		Fwrite( nHandle, cWeb, Len(cWeb) )
		FClose( nHandle )
								                      
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
    	MsgInfo("Não foram encontrados dados para os parâmetros selecionados.")
    Endif 		//se o tamanho do array for > 0

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
Static Function fUltiCompra( cCliente, cLoja, cVendedor ) //, cTipo )
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

cQuery := " SELECT TOP 1 " + LF
cQuery += " ATEND = (Select SUM(XC6.C6_QTDVEN - XC6.C6_QTDENT) FROM " + RetSqlName("SC6") + "  XC6 WHERE XC6.C6_NUM = SC5.C5_NUM " + LF
cQuery += " AND XC6.D_E_L_E_T_ = '' ) " + LF
cQuery += " ,C5_NUM, C5_ENTREG, C5_EMISSAO, " + LF
cQuery += " MAX(C6_ENTREG) AS ENTREGA, " + LF
cQuery += " ROUND(SUM(C6_QTDVEN),2) AS PESO ,  " +LF
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
//cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dDatabase - 90) + "' AND SC5.C5_EMISSAO <= '" + Dtos(dDatabase) + "' " + LF
//cQuery += " WHERE SC5.C5_ENTREG >= '" + Dtos(dDatabase - 90) + "' " + LF //"' AND SC5.C5_ENTREG <= '" + Dtos(dDatabase) + "' " + LF

cQuery += " (B1_TIPO) != 'AP' " +LF //Despreza Apara 
//cQuery += " AND (C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND (SB1.B1_SETOR) = '39' " +LF
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

//cQuery += " AND (F2_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 
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
	
Else     
	//se não encontrar pedido não atendido, irá capturar o último atendido...
	cQuery := " SELECT TOP 1 " + LF
	cQuery += " ATEND = (Select SUM(XC6.C6_QTDVEN - XC6.C6_QTDENT) FROM " + RetSqlName("SC6") + "  XC6 WHERE XC6.C6_NUM = SC5.C5_NUM " + LF
	cQuery += " AND XC6.D_E_L_E_T_ = '' ) " + LF
	cQuery += " ,C5_NUM, C5_ENTREG, C5_EMISSAO, " + LF
	cQuery += " MAX(C6_ENTREG) AS ENTREGA, " + LF
	cQuery += " ROUND(SUM(C6_QTDVEN),2) AS PESO ,  " +LF
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
	//cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dDatabase - 90) + "' AND SC5.C5_EMISSAO <= '" + Dtos(dDatabase) + "' " + LF
	//cQuery += " WHERE SC5.C5_ENTREG >= '" + Dtos(dDatabase - 90) + "' " + LF //"' AND SC5.C5_ENTREG <= '" + Dtos(dDatabase) + "' " + LF
	
	cQuery += " (B1_TIPO) != 'AP' " +LF //Despreza Apara 
	//cQuery += " AND (C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
	cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
	cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF
	
	cQuery += " AND (SB1.B1_SETOR) = '39' " +LF
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
	
	//cQuery += " AND (F2_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 
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
			
    Else
    	lAtendido := .T.
    Endif


Endif

/*
If cTipo = "D"
	Return(dUltima)

Elseif cTipo = "R"
	Return(nReais)

Elseif cTipo = "K"
	Return(nKilos)

Endif

*/

Aadd(aRetorno, { dUltima , nReais , nKilos ,lAtendido } )
Return(aRetorno)


******************************
Static Function fCabeca(nPag, titulo) 
******************************

Local cWeb := ""

/////CABEÇALHO PÁGINA
cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
cWeb += '<html><head>'+ LF
cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cWeb += '<tr>    <td>'+ LF
cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cWeb += '<tr>        <td>SIGA /FATR024/v.P10</td>'+ LF
cWeb += '<td align="center">' + titulo + '</td>'+ LF
cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cWeb += '</table></head>'+ LF   

Return(cWeb)



