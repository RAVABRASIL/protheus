#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR012C
//Objetivo: Relatório de Fechamento do Mês  -  Ano 2010
//			Emitir relatório das vendas por representante e enviar por e-mail
//          para os supervisores
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 11/02/2010
//Alterações: em 02/08/2010 - incluído subtotal antes dos representantes: 0153, 0159 e 0201
//Alteração: 22/10/2010 - Mudar o período de avaliação de 6 para 3 meses,
//                      - Incluir resumo no final (qtde de clientes novos,
//                      - qtde. de clientes que passaram a ser antigos (mais de 3 meses),
//                      - qtde. de clientes que passaram a comprar (3 meses)
//--------------------------------------------------------------------------
/*/



//DIRETORIA - RECEBE DE TODOS 
/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/
************************************
User Function FATR012C()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Fechamento do Mes."
Local cPict          := ""
Local titulo         := "" 

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local cText			 := ""
Local imprime        := .T.
Local aOrd := {}

Local dDTPar		 := Ctod("  /  /    ")		//grava a nova data limite no parâmetro 


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR012C" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR012C" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "" //"FTR012"
Private cString := ""

Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")
Private aMeses		:= {}
Private aNomMeses	:= {}
Private nPosMes		:= 0
Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 
Private lEnviou		:= .F.
Private cCodRepre   := ""
Private cUFRepre	:= ""
Private cNomeRepre  := ""
Private aRepre		:= {}
Private aSuper		:= {}
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nLin        := 80
Private nCta		:= 0


//Compor o array com o número dos meses do ano
Private cAnoM1 := ""
Private cAnoM2 := ""
Private cAnoM3 := ""
Private cAnoM4 := ""
Private cAnoM5 := ""
Private cAnoM6 := ""

///ESTAS VARIÁVEIS SERÃO UTILIZADAS NO COMPARATIVO DO MES/ANO DA META
Private cAnoMe1 := ""
Private cAnoMe2 := ""
Private cAnoMe3 := ""
Private cAnoMe4 := ""
Private cAnoMe5 := ""
Private cAnoMe6 := ""

Private nMes1 := 0
Private nMes2 := 0
Private nMes3 := 0

//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dData2 := GETMV("RV_ULT12C")  
//dData2 := Ctod("31/10/2010")
dData1 := dData2 - 90 //- 180


cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Fechamento (Vendas de Sacos) do Mes (p/ Coordenadores)  -  " + cStrAno + ""





aMeses:= {}
aMeses:= { 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 }

nPosMes := Ascan( aMeses, Month(dData2) )


If nPosMes = 1         //se for Janeiro 
//ago, set, out, nov, dez, jan
	
	//nMes6 := aMeses[nPosMes]          //1
	//nMes5 := aMeses[nPosMes + 11]     //12
	//nMes4 := aMeses[nPosMes + 10]     //11
	//nMes3 := aMeses[nPosMes + 9 ]     //10
	//nMes2 := aMeses[nPosMes + 8 ]     //9
	//nMes1 := aMeses[nPosMes + 8 ]     //8
		
	nMes3 := aMeses[nPosMes]     //1
	nMes2 := aMeses[nPosMes + 11 ]     //12
	nMes1 := aMeses[nPosMes + 10 ]     //11
		
	//cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10 
	//cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	//dez/09
	//cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//nov/09
	//cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//out/09
	//cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//set/09
	//cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)		//ago/09
	
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10 
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	//dez/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//nov/09
		
	//cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//jan/10
	//cAnoMe5 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	//cAnoMe4 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	//cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//out/09
	//cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	//cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	
	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//jan/10
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	

Elseif nPosMes = 2   //se for Fevereiro
//dez, jan, fev
	
	nMes3 := aMeses[nPosMes]         //2
	nMes2 := aMeses[nPosMes - 1 ]    //1
	nMes1 := aMeses[nPosMes + 11]    //12

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//fev/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//jan/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//dez/09
                                                   
	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//fev/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
		
Elseif (nPosMes >= 3 )	// se for maior que Março até Dezembro
	
	nMes3 := aMeses[nPosMes]          //3
	nMes2 := aMeses[nPosMes - 1 ]     //2
	nMes1 := aMeses[nPosMes - 2 ]     //1

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//mar/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10

	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//mar/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//fev/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 ) 		//jan/10	
	
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


//Cabec1         := "REPRESENTANTE         |   META MENSAL            |   "+cMes1+cAnoM1+"           |   "+ cMes2 +cAnoM2+"             |    "+ cMes3 +cAnoM3+"            |     "+ cMes4 +cAnoM4+"           |   "+ cMes5 +cAnoM5+"              |  "+ cMes6 +cAnoM6+" " 
//Cabec2		   := "                      |    R$        KG          |    R$         KG         |  R$           KG           | R$          KG             |      R$        KG          |  R$            KG           |     R$            KG "

RunReport(Cabec1,Cabec2,Titulo,nLin)

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery:=''
Local cQuery2 := ""
Local nQTD:=0 
Local aDados 	:= {}
Local aDadSuper := {}
Local aDadSS	:= {}

Local nTotPM1 := 0
Local nTotPM2 := 0   
Local nTotPM3 := 0
Local nTotPM4 := 0
Local nTotPM5 := 0
Local nTotPM6 := 0
Local nMedia  := 0
Local nTotMedia:= 0
   
Local nTotVM1 := 0
Local nTotVM2 := 0   
Local nTotVM3 := 0
Local nTotVM4 := 0
Local nTotVM5 := 0
Local nTotVM6 := 0
Local nTotCartR:= 0
Local nTotCartK:= 0

Local nTotMetaR := 0
Local nTotMetaK := 0
Local cAtivo	:= ""
Local cTipoCli	:= ""

Private cSuper		:= ""
Private cNomeSuper 	:= ""
Private cGeren		:= ""
Private cNomeGeren 	:= "" 


/*
cQuery := " SELECT PESO=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0) "+LF
cQuery += " ELSE SUM(D2_QUANT*B1_PESOR) END, " +LF
cQuery += " VALOR=SUM(D2_TOTAL), F2_VEND1, A3_GEREN, A3_SUPER, F2_CLIENTE, A3_NOME, A1_NREDUZ,F2_EMISSAO, A3_EMAIL "+LF
cQuery += " FROM SD2020 SD2 WITH (NOLOCK),  "+LF
cQuery += " SB1010 SB1 WITH (NOLOCK), "+LF
cQuery += " SF2020 SF2 WITH (NOLOCK), "+LF
cQuery += " SA3010 SA3 WITH (NOLOCK),  "+LF
cQuery += " SA1010 SA1 WITH (NOLOCK)   "+LF
cQuery += " WHERE D2_EMISSAO >= '" + DTOS(dData1) + "' AND D2_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "+LF
cQuery += " AND D2_TIPO = 'N' " +LF
cQuery += " AND RTRIM(D2_TP) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND SD2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND D2_COD = B1_COD     "+LF
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND D2_DOC = F2_DOC      "+LF
cQuery += " AND D2_SERIE = F2_SERIE  "+LF
cQuery += " AND D2_CLIENTE = F2_CLIENTE "+LF
cQuery += " AND D2_LOJA = F2_LOJA       "+LF
cQuery += " AND F2_CLIENTE = A1_COD     "+LF
cQuery += " AND F2_LOJA = A1_LOJA       "+LF
cQuery += " AND F2_VEND1 = A3_COD "+LF
cQuery += " AND F2_DUPL <> ' '          "+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''     "+LF
cQuery += " AND A3_SUPER <> '' "+LF

//cQuery += " AND RTRIM(A3_SUPER) = '0248' " + LF

cQuery += " GROUP BY D2_SERIE, F2_VEND1,F2_CLIENTE, A3_NOME, A1_NREDUZ, F2_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL " + LF
cQuery += " ORDER BY A3_SUPER, F2_VEND1,F2_EMISSAO, F2_CLIENTE "+LF
*/

cQuery := " SELECT ROUND(SUM(C6_QTDVEN * B1_PESOR),2) AS PESO ," + LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR , C5_VEND1, A3_GEREN " + LF
//cQuery += " , A3_SUPER " + LF  
//ABAIXO MUDEI PARA QUE POSSA SER SELECIONADO TANTO O VENDEDOR QUE TEM SUPERVISOR, QTO O VENDEDOR QUE É O PRÓPRIO SUPERVISOR:
cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " , C5_CLIENTE, C5_LOJACLI, A3_NOME, A3_EST, A1_NREDUZ,C5_EMISSAO, A3_EMAIL, A3_ATIVO, C5_TIPOCLI  "+LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK)  "+LF

cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' "+LF
cQuery += " AND RTRIM(B1_TIPO) != 'AP' "+LF //Despreza Apara 
//cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF

cQuery += " AND C6_TES = F4_CODIGO " + LF
cQuery += " and F4_DUPLIC = 'S' " + LF //tem q ter duplicata, pq senão contará as bonificaçoes, e estas não devem entrar

cQuery += " AND RTRIM(C5_TIPO) = 'N' " + LF
cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA3.D_E_L_E_T_ = '' "+LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF

cQuery += " AND C6_PRODUTO = B1_COD     "+LF

cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_NUM = C5_NUM      "+LF

cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF

cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF

cQuery += " AND C5_VEND1 = A3_COD "+LF
//cQuery += " AND A1_VEND = A3_COD " + LF    //existem pedidos em que o C5_VEND1 está diferente do A1_VEND

///Marcos solicitou que não mostrasse neste relatório os vendedores abaixo:
cQuery += " AND RTRIM(A3_COD) NOT IN ('0227' , '0227VD' ) " + LF

//Em 07/10/10 Flávia Viana pediu para retirar do relatório o Sr.Manoel (0067)
cQuery += " AND RTRIM(A3_COD) NOT IN ('0067' ) " + LF                 
//cQuery += " AND ( A3_SUPER = '0255' or RTRIM(C5_VEND1) = '0255'  ) " + LF    //qdo quiser tirar de um supervisor específico, habilitar essa linha

cQuery += " GROUP BY C5_VEND1, C5_CLIENTE, C5_LOJACLI, A3_NOME, A3_EST, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO, C5_TIPOCLI " + LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI "+LF
//MemoWrite("C:\Temp\fatr012C.sql", cQuery )

TCQUERY cQuery NEW ALIAS "SUP12"

TCSetField( "SUP12", "C5_EMISSAO", "D")

SUP12->( DbGoTop() )

//SetRegua(0)		//Ativar qdo chamar pelo menu ->não funciona via prepare environment

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While SUP12->( !EOF() )

	cCodRepre := SUP12->C5_VEND1
	cNomeRepre:= SUP12->A3_NOME
	cUFRepre  := SUP12->A3_EST
	cAtivo	  := SUP12->A3_ATIVO
	cTipoCli  := SUP12->C5_TIPOCLI
	
	nTotCartR := 0
	nTotCartK := 0
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
	
	cSuper	:= ""
	cNomeSuper := "" 
	
	If !Empty( SUP12->SUPER )
		cSuper  := SUP12->SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME		
	Else
		cSuper := SUP12->C5_VEND1
		cNomeSuper := SUP12->A3_NOME
	Endif
	 	 	
	Do While ( Alltrim(SUP12->C5_VEND1) = Alltrim(cCodRepre) .or. Alltrim(SUP12->C5_VEND1) = Alltrim(cCodRepre + "VD") )
	
		Do Case
			Case Month( SUP12->C5_EMISSAO ) = nMes1			
			    nTotVM1 += SUP12->VALOR
			    nTotPM1 += SUP12->PESO
			Case Month( SUP12->C5_EMISSAO ) = nMes2
			   	nTotVM2 += SUP12->VALOR
			    nTotPM2 += SUP12->PESO
			Case Month( SUP12->C5_EMISSAO ) = nMes3
			    nTotVM3 += SUP12->VALOR
			    nTotPM3 += SUP12->PESO			    
			/*
			Case Month( SUP12->C5_EMISSAO ) = nMes4
			    nTotVM4 += SUP12->VALOR
			    nTotPM4 += SUP12->PESO		
			Case Month( SUP12->C5_EMISSAO ) = nMes5
			    nTotVM5 += SUP12->VALOR
			    nTotPM5 += SUP12->PESO
			Case Month( SUP12->C5_EMISSAO ) = nMes6
			    nTotVM6 += SUP12->VALOR
			    nTotPM6 += SUP12->PESO				
		   */
		Endcase	           	
		SUP12->(Dbskip())
	Enddo
	nMedia := ( nTotVM1 + nTotVM2 + nTotVM3) / 3				 
	
	If ( Alltrim(cSuper) = '0255' .and. Alltrim(cAtivo)!= "N")
		Aadd(aDadSS, { cCodRepre, cNomeRepre, cSuper, cNomeSuper,;
					 nTotVM1, nTotPM1, nTotVM2, nTotPM2  ,;
					 nTotVM3, nTotPM3, nTotVM4, nTotPM4  ,;
					 nTotVM5, nTotPM5, nTotVM6, nTotPM6, cUFRepre, nMedia, cAtivo, cTipoCli } )	 		
	
	Elseif Alltrim(cSuper) != '0255' 
		Aadd(aDadSS, { cCodRepre, cNomeRepre, cSuper, cNomeSuper,;
					 nTotVM1, nTotPM1, nTotVM2, nTotPM2  ,;
					 nTotVM3, nTotPM3, nTotVM4, nTotPM4  ,;
					 nTotVM5, nTotPM5, nTotVM6, nTotPM6, cUFRepre, nMedia, cAtivo, cTipoCli } )	 		
	Endif			 
	 		

Enddo

aDadSuper := Asort( aDadSS,,, { |X,Y| X[3] + Transform(X[18],"@E 99,999,999.99")  <  Y[3] + Transform(Y[18] ,"@E 99,999,999.99") } ) 


								 
SUP12->( DbCloseArea() )

///////////////GERA PARA ENVIAR AOS SUPERVISORES
nPag	:= 1
nLin	:= 80 
nLinhas := 80
cWeb	:= ""
cSuper  := ""
cMailSuper := ""
cNomeSuper := ""

nTotPM1 := 0
nTotPM2 := 0   
nTotPM3 := 0
nTotPM4 := 0
nTotPM5 := 0
nTotPM6 := 0

nTotMedia := 0
		   
nTotVM1 := 0
nTotVM2 := 0   
nTotVM3 := 0
nTotVM4 := 0
nTotVM5 := 0
nTotVM6 := 0

nTotMetaR := 0
nTotMetaK := 0
nTotCartR := 0
nTotCartK := 0
cAtivo    := ""
nCta := 1

If Len(aDadSuper) > 0
	
	Do While nCta <= Len(aDadSuper)
	
		nMetaR := 0
		nMetaK := 0
		///totais da meta / representante
		nTotMetaR := 0
		nTotMetaK := 0
		///totais ped. carteira
		nTotCartR := 0
		nTotCartK := 0
		
		cSuper := aDadSuper[nCta,3]
		cNomeSuper := Alltrim(aDadSuper[nCta,4])
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cMailSuper := SA3->A3_EMAIL   ///captura o email do coordenador para posterior envio do arq. html
		
		cWeb := ""
		nLinhas := 80
		/////CRIA O HTML
		cDirHTM  := "\Temp\"    
		cArqHTM  := "FATR012C" + Alltrim(cSuper) + ".HTM"    //relatório P/ SUPERVISORES
		nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
		nPag     := 1    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
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
		//////////	
		
		If nLinhas >= 35	
			///Cabeçalho html
			cWeb := ""
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR012C/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF      
				      
			/////NOME DO SUPERVISOR RESPONSÁVEL	
			cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
			cWeb += '</table>' + LF
			/////
			
			///Cabeçalho relatório
			cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="510" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>REPRESENTANTE</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF
			
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
			cWeb += '<tr>'+ LF
			
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF       //KG COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '</strong></tr><br>'+ LF
		    nPag++
		    nLinhas := 5
		    
		    
		    
		Endif
			
		/////NOME DO SUPERVISOR RESPONSÁVEL
		nLin++
		@nLin,000 PSAY Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) PICTURE "@!"
		@nLin,070 PSAY "E-mail: " + cMailSuper
	 
			
		   Do While nCta <= Len(aDadSuper)  .and. Alltrim(aDadSuper[nCta,3]) == Alltrim(cSuper)
			   	
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
			   
			   If nLinhas >= 35	  
			   		///Cabeçalho html
			      	cWeb += '<div class="quebra_pagina"> </div>'+LF
      				
			      	cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
					cWeb += '<html><head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR012C/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					cWeb += '</table></head>'+ LF   
					
					/////NOME DO SUPERVISOR RESPONSÁVEL	
					cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr><br>'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr><br>'+LF
					cWeb += '</table>' + LF
					/////
			      
			      	///Cabeçalho relatório		      
					cWeb += '<table width="1600" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>REPRESENTANTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF				
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
					cWeb += '<tr>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF       //KG COLUNA META MENSAL
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '</strong></tr><br>'+ LF
									
					nPag++
					nLinhas := 5
			
			   Endif
			   
			   /////////////////////////////////////////////////////////////
				////SOMA AS METAS DE TODOS OS REPRESENTANTES DO COORDENADOR
				////////////////////////////////////////////////////////////
				nMetaR := 0
				nMetaK := 0
				
				cQuery := ""
				cQuery := " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(aDadSuper[nCta,1]) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				cQuery += " AND A3_SUPER <> '' "+LF
				cQuery += " AND RTRIM(Z7_TIPO) = 'SC' " + LF
				cQuery += " AND RTRIM(Z7_MESANO) = '" + Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) ) + "' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				//MemoWrite("C:\Temp\12CMETA.sql", cQuery )
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
				While META->( !EOF() )					
					//If Alltrim(META->Z7_MESANO) = Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) )
						nMetaR += META->Z7_VALOR
						nMetaK += META->Z7_KILO
					//Endif
					META->(Dbskip())
				Enddo
				/*
				If ( Alltrim(aDadSuper[nCta,1]) ) $ "0244/0245/0248/0255"
					nMetaR := 0
					nMetaK := 0
				Endif
			    */
			    
			   	////COMEÇA A IMPRESSÃO...
				/*
				nLin++			   
				@nLin,000 PSAY aDadSuper[nCta,2] + "-" + SUBSTR( aDadSuper[nCta,2],1,20)	PICTURE "@!"   	//Nome Representante
				////META
				@nLin,020 PSAY nMetaR	PICTURE "@E 99,999,999.99" 	//Meta R$
				@nLin,035 PSAY nMetaK	PICTURE "@E 9,999,999.99"     //Meta KG
				*/
				nTotMetaR += nMetaR ///acumula para o total geral
				nTotMetaK += nMetaK
				/*					   
				@nLin,049 PSAY TRANSFORM( aDadSuper[nCta,5],"@E 99,999,999.99")		//VM1 total valor mês 1				
				@nLin,064 PSAY TRANSFORM( aDadSuper[nCta,6],"@E 9,999,999.99")		//PM1 total peso mês 1
				@nLin,078 PSAY TRANSFORM( aDadSuper[nCta,7],"@E 99,999,999.99") 	//VM2 total valor mês 2
				@nLin,093 PSAY TRANSFORM( aDadSuper[nCta,8],"@E 9,999,999.99")		//PM2 total peso mês 2
				@nLin,107 PSAY TRANSFORM( aDadSuper[nCta,9],"@E 99,999,999.99") 	//VM3 total valor mês 3
				@nLin,122 PSAY TRANSFORM( aDadSuper[nCta,10],"@E 9,999,999.99")		//PM3 total peso mês 3
				@nLin,136 PSAY TRANSFORM( aDadSuper[nCta,11],"@E 99,999,999.99")	//VM4 total valor mês 4
				@nLin,151 PSAY TRANSFORM( aDadSuper[nCta,12],"@E 9,999,999.99")		//PM4 total peso mês 4
				@nLin,165 PSAY TRANSFORM( aDadSuper[nCta,13],"@E 99,999,999.99")   	//VM5 total valor mês 5
				@nLin,180 PSAY TRANSFORM( aDadSuper[nCta,14],"@E 9,999,999.99")		//PM5 total peso mês 5
				@nLin,194 PSAY TRANSFORM( aDadSuper[nCta,15],"@E 99,999,999.99")   	//VM5 total valor mês 6
				@nLin,209 PSAY TRANSFORM( aDadSuper[nCta,16],"@E 9,999,999.99")		//PM5 total peso mês 6
				*/
				 
				If Alltrim(aDadSuper[nCta,1]) $ "0153/0159/0201"      	
	        	
					////TOTAIS VENDAS
					cWeb += '<td width="1600" align="left"><span class="style3"><b>SubTotal.....:</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 99,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 9,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</span></td>'+LF				
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '</tr>'+LF
					////linha em branco
					cWeb += '<td width="1600" height="20" colspan="16" align="left"><span class="style3"></span></td>'+LF
					cWeb += '</tr>'+LF				
					                                                                        
				Endif
				 
				 
												
				////TOTAIS DO REPRESENTANTE
				If Alltrim(aDadSuper[nCta,19]) = "N"
				    ////representante
					cWeb += '<td width="1600" bgcolor="#D0D0D0"><span class="style3">'+ Alltrim(aDadSuper[nCta,1]) + "-" + Alltrim(SUBSTR( aDadSuper[nCta,2],1,20)) + " - " + Alltrim(aDadSuper[nCta,17]) +'</span></td>'+LF   //REPRESENTANTE
					////meta
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">' + Transform( nMetaR , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">' + Transform( nMetaK , "@E 999,999.99")+' </span></td>'+LF        //META KG
					
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,5],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,6],"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,7],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,8],"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,9],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,10],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,11],"@E 9,999,999.99")+ '</span></td>'+LF
					//cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,12],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,13],"@E 9,999,999.99")+ '</span></td>'+LF
					//cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,14],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" bgcolor="#D0D0D0" align="right"><span class="style3">' + Transform( aDadSuper[nCta,15] , "@E 99,999,999.99")  + '</span></td>'+LF  //R$
					//cWeb += '<td width="300" bgcolor="#D0D0D0"aligh="right"><span class="style3">' + Transform( aDadSuper[nCta,16] , "@E 9,999,999.99")+' </span></td>'+LF        //KG
				
					///Média
					cWeb += '<td width="300" bgcolor="#D0D0D0" align="right">' + Transform( aDadSuper[nCta,18] , "@E 9,999,999.99")+' </span></td>'+LF        //KG
					cWeb += '</tr>'+LF			
				Else
				
					////representante
					cWeb += '<td width="1600"><span class="style3">'+ Alltrim(aDadSuper[nCta,1]) + "-" + Alltrim(SUBSTR( aDadSuper[nCta,2],1,20)) + " - " + Alltrim(aDadSuper[nCta,17]) +'</span></td>'+LF   //REPRESENTANTE
					////meta
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaR , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaK , "@E 999,999.99")+' </span></td>'+LF        //META KG
					
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,5],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,6],"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,7],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,8],"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,9],"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,10],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,11],"@E 9,999,999.99")+ '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,12],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,13],"@E 9,999,999.99")+ '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,14],"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadSuper[nCta,15] , "@E 99,999,999.99")  + '</span></td>'+LF  //R$
					//cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadSuper[nCta,16] , "@E 9,999,999.99")+' </span></td>'+LF        //KG
					
					///Média
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadSuper[nCta,18] , "@E 9,999,999.99")+' </span></td>'+LF        //KG				
					cWeb += '</tr>'+LF
				Endif
				
				///acumula para o total geral...					
				/*
				nTotVM1 += aDadSuper[nCta,5]   //totais valores / peso
				nTotPM1 += aDadSuper[nCta,6]
				nTotVM2 += aDadSuper[nCta,7]
				nTotPM2 += aDadSuper[nCta,8]
				nTotVM3 += aDadSuper[nCta,9]
				nTotPM3 += aDadSuper[nCta,10]
				nTotVM4 += aDadSuper[nCta,11]
				nTotPM4 += aDadSuper[nCta,12]
				nTotVM5 += aDadSuper[nCta,13]
				nTotPM5 += aDadSuper[nCta,14]				
				nTotVM6 += aDadSuper[nCta,15]
				nTotPM6 += aDadSuper[nCta,16]
				nTotMedia += aDadSuper[nCta,18]
				*/
				///coloquei arredondamento pois estava diferindo em centavos comparado ao Rel.Pos.Vendas 4
				nTotVM1 += Round( aDadSuper[nCta,5], 2)   //totais valores / peso
				nTotPM1 += Round( aDadSuper[nCta,6], 2)
				nTotVM2 += Round(aDadSuper[nCta,7] , 2)
				nTotPM2 += Round(aDadSuper[nCta,8] , 2)
				nTotVM3 += Round(aDadSuper[nCta,9] , 2)
				nTotPM3 += Round(aDadSuper[nCta,10], 2)
				nTotVM4 += Round(aDadSuper[nCta,11], 2)
				nTotPM4 += Round(aDadSuper[nCta,12],2)
				nTotVM5 += Round(aDadSuper[nCta,13],2)
				nTotPM5 += Round(aDadSuper[nCta,14],2)
				nTotVM6 += Round(aDadSuper[nCta,15],2)
				nTotPM6 += Round(aDadSuper[nCta,16],2)
				nTotMedia += Round(aDadSuper[nCta,18], 2)
				
			
	        	nCta++
	        	nLinhas++
	        	
	        	
	       Enddo
	       
	       /*
	       nLin++
	       
	       	nLin++
			@nLin,00 PSAY Replicate("=",220)				
			nLin++
			@nLin,000 PSAY "Total: "
			@nLin,020 PSAY TRANSFORM( nTotMetaR,"@E 99,999,999.99")
			@nLin,035 PSAY TRANSFORM( nTotMetaK,"@E 9,999,999.99")
			@nLin,049 PSAY TRANSFORM( nTotVM1,"@E 99,999,999.99")
			@nLin,064 PSAY TRANSFORM( nTotPM1,"@E 9,999,999.99")
			@nLin,078 PSAY TRANSFORM( nTotVM2,"@E 99,999,999.99")
			@nLin,093 PSAY TRANSFORM( nTotPM2,"@E 9,999,999.99")
			@nLin,107 PSAY TRANSFORM( nTotVM3,"@E 99,999,999.99")
			@nLin,122 PSAY TRANSFORM( nTotPM3,"@E 9,999,999.99")
			@nLin,136 PSAY TRANSFORM( nTotVM4,"@E 99,999,999.99")
			@nLin,151 PSAY TRANSFORM( nTotPM4,"@E 9,999,999.99")
			@nLin,165 PSAY TRANSFORM( nTotVM5,"@E 99,999,999.99")
			@nLin,180 PSAY TRANSFORM( nTotPM5,"@E 9,999,999.99")
			@nLin,194 PSAY TRANSFORM( nTotVM6,"@E 99,999,999.99")
			@nLin,209 PSAY TRANSFORM( nTotPM6,"@E 9,999,999.99")
			//@nLin,194 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
			//@nLin,209 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99")	   
			nLin++
			@nLin,00 PSAY Replicate("=",220)
			nLin++	
		   */		
			////TOTAIS VENDAS
			////linha em branco
			cWeb += '<td width="1600" height="20" colspan="16" align="left"><span class="style3"></span></td>'+LF
			cWeb += '</tr>'+LF
		
			cWeb += '<td width="1600" align="left"><span class="style3"><b>Total.....:</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '</tr>'+LF
			

			
			nTotMetaR	:= 0
	        nTotMetaK	:= 0
	        nTotVM1		:= 0
	        nTotPM1		:= 0
	        nTotVM2		:= 0
	        nTotPM2		:= 0
	        nTotVM3		:= 0
	        nTotPM3		:= 0
	        nTotVM4		:= 0
	        nTotPM4		:= 0
	        nTotVM5		:= 0
	        nTotPM5		:= 0
	        nTotVM6		:= 0
	        nTotPM6		:= 0
	        nTotCartR	:= 0
	        nTotCartK	:= 0
	        
	        nTotMedia	:= 0
	        
	        /////FECHA A TABELA DO HTML
			cWeb += '</table><br>'
			//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
	        
	        //////GRAVA O HTML 
	    	Fwrite( nHandle, cWeb, Len(cWeb) )
	    	cWeb := ""
	    
		    //////////////////////////////////////////////////////////////////////
		    //chama função que traz clientes que não compram há mais de 6 meses
		    //para mostrar na última página do html
		    /////////////////////////////////////////////////////////////////////
		    cText := Maior6Meses( cSuper, cNomeSuper, cWeb, nHandle )
		    cWeb := cWeb + cText        
	        
	        cWeb := ResumoFim( cSuper, cNomeSuper, cWeb, nHandle )
	    	cWeb := cWeb + cText
			
			cWeb += '</body> '
			cWeb += '</html> '
			//////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			nRet := 0
			//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browser
			
			//////SELECIONA O EMAIL DESTINATÁRIO 
			cMailTo := cMailSuper // colocar o e-mail do supervisor
			//cMailTo := ""  		
			cCopia  := "flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo  + " -   Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo 
			//////ENVIA O HTML COMO ANEXO
			U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 		

	Enddo

Endif


//////////////FIM DO GERA PARA SUPERVISORES

//MSGINFO("FATR012C - Processo finalizado")


dDTPar := LastDay(dDatabase)
PutMV("RV_ULT12C", dDTPar )

// Habilitar somente para Schedule
Reset environment


Return


***********************************
Static Function Maior6Meses(cCodSuper , cNomeSuper, cWeb, nHandle)
***********************************

Local cQuery 	:= ""                                  
Local LF	 	:= CHR(13) + CHR(10)
Local aDados 	:= {}
Local cTexto 	:= ""
Local nCtaLin	:= nLinhas
Local nTotPM 	:= 0  
Local nTotVM 	:= 0
Local cSuper 	:= ""
Local cCodRepre	:= ""
Local cNomeRepre:= ""
Local cAtivo	:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cNomeCli	:= ""
Local nTotreais := 0
Local nTotkilos := 0
Local dUltimaC	:= Ctod("  /  /    ")

cQuery := " SELECT ROUND(SUM(C6_QTDVEN * B1_PESOR),2) AS PESO , " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR, C5_VEND1, A3_NOME, " + LF
cQuery += " C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO " +LF
cQuery += " FROM " + RetSqlName("SC6") + " SC6  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK),   "+LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK)   "+LF
cQuery += " WHERE " + LF

cQuery += " RTRIM(SB1.B1_TIPO) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF

cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND SC6.C6_QTDENT = SC6.C6_QTDVEN " + LF
cQuery += " AND SC6.C6_NOTA <> '' " + LF

cQuery += " AND C6_PRODUTO = B1_COD     "+LF

cQuery += " AND C6_NUM = C5_NUM      "+LF

cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF
cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF

cQuery += " AND C5_VEND1 = A3_COD "+LF
cQuery += " AND A1_VEND = A3_COD " + LF

cQuery += " AND ( RTRIM(A3_SUPER) = '" + Alltrim(cCodSuper) + "'  OR RTRIM(C5_VEND1) = '"+ Alltrim(cCodSuper) + "' ) " + LF

If Alltrim(cCodSuper) = '0245'
	cQuery += " AND RTRIM(A3_COD) NOT IN ('0227' , '0227VD' ) " + LF
Endif

If Alltrim(cCodSuper) = '0255'
	cQuery += " AND RTRIM(A3_COD) <> '0067' " + LF //Em 07/10/10 Flávia Viana pediu para não mostrar Sr. Manoel
	cQuery += " AND A3_ATIVO <> 'N' " + LF
	cQuery += " AND RTRIM(SC5.C5_TIPOCLI) <> 'F' " + LF		//Flávia Viana pediu para retirar os consumidores finais da lista
Endif

cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO "+LF
cQuery += " ORDER BY C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO DESC "+LF
//MemoWrite("C:\Temp\ultipag12C.sql", cQuery )
If Select("SC6U") > 0
	DbSelectArea("SC6U")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SC6U"

TCSetField( "SC6U", "C5_EMISSAO", "D")

cCliAnt := ""
cLojAnt := ""

SC6U->( DbGoTop() )
While SC6U->( !EOF() )
        

	nTotPM := 0  
	nTotVM := 0        
	
	cSuper := ""
	cCodRepre := ""
	cNomeRepre:= ""
	cAtivo    := ""
	
	cCliente := SC6U->C5_CLIENTE
	cLoja    := SC6U->C5_LOJACLI
	cNomeCli := SC6U->A1_NREDUZ
	
	cSuper 		:= SC6U->A3_SUPER
	If Empty(cSuper)
		cSuper := SC6U->C5_VEND1
	Endif
	
	cCodRepre	:= SC6U->C5_VEND1
	cNomeRepre	:= SC6U->A3_NOME
	cAtivo		:= SC6U->A3_ATIVO	
								
	nTotVM := SC6U->VALOR
	nTotPM := SC6U->PESO
	
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLojAnt) 
		
	  	If SC6U->C5_EMISSAO <= (dDatabase - 91) //(dDatabase - 181)
	  
		  	cQuery := " SELECT TOP 1 F2_CLIENTE, F2_LOJA, F2_EMISSAO, B1_SETOR " + LF  
			cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
			cQuery += " " + RetSqlName("SA3") + " SA3, "+LF
			cQuery += " " + RetSqlName("SD2") + " SD2, "+LF
			cQuery += " " + RetSqlName("SB1") + " SB1 "+LF
		
			cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 
			cQuery += " AND RTRIM(F2_DOC + F2_SERIE) = RTRIM(D2_DOC + D2_SERIE) " + LF
			cQuery += " AND RTRIM(D2_COD) = RTRIM(B1_COD) " + LF
			
			cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
			cQuery += " AND ( RTRIM(A3_SUPER)  = '" + Alltrim(cSuper) + "' or RTRIM(F2_VEND1) = '" + Alltrim(cSuper) + "' ) "+LF  
			
			cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
			cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
			cQuery += " AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"+ LF
			
			cQuery += " AND F2_TIPO = 'N' "+LF
			cQuery += " AND F2_SERIE <> '' "+LF
			cQuery += " AND B1_SETOR <> '39' " + LF
						
			cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_EMISSAO, B1_SETOR " + LF
			cQuery += " ORDER BY F2_EMISSAO DESC " + LF
			//cQuery := ChangeQuery( cQuery )
			//MemoWrite("C:\Temp\FATR016A.sql", cQuery)
			
			If Select("SF2A") > 0
				DbSelectArea("SF2A")
				DbCloseArea()
			EndIf
			
			TCQUERY cQuery NEW ALIAS "SF2A"
			TCSetField( 'SF2A', "F2_EMISSAO", "D" )	
			SF2A->( DBGoTop() )
			If SF2A->F2_EMISSAO <= (dDatabase - 91) //(dDatabase - 181)		
				Do While !SF2A->( Eof() )		
					dUltimaC := SF2A->F2_EMISSAO			
					SF2A->(DBSKIP())			
				Enddo  
	  								
				If Alltrim(cSuper) = '0255' .and. Alltrim(cAtivo) != "N"   			
								
					////				1			2		  3		  4		 5         6		7		8		9       10
					Aadd(aDados, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, nTotVM, nTotPM, dUltimaC, cAtivo } )		
					 
				Elseif Alltrim(cSuper) != '0255'
						////				1		2		  3		  4		  5         6		7		8		9  		10
					Aadd(aDados, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, nTotVM, nTotPM, dUltimaC, cAtivo } )		
					
				Endif
				
			Endif		//endif da f2_emissao > 6 meses		    
		    
	    Endif	//endif do c5_emissao > 6 meses
		
		cCliAnt := cCliente
		cLojAnt := cLoja
		
		SC6U->(DBSKIP())
	Else
		SC6U->(DBSKIP())
	Endif		//endif se cli agora = cli anterior
 	
 		 
Enddo
DbselectArea("SC6U")
DbCloseArea()


	aDados := Asort( aDados,,, { |X,Y| X[2] + Dtoc(X[9])  <  Y[2] + Dtoc(Y[9]) } ) 
	
///Cabeçalho relatório		      
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<table width="800" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td width="800" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES QUE NAO COMPRAM HA MAIS DE 3 MESES (VENDAS DE SACOS):</span></div></B></td>'+ LF
cTexto += '</tr></table>'+LF

cTexto += '<table width="500" border="0" style="font-size:12px;font-family:Arial">'+LF
cTexto += '<td width="250"><div align="Left"><span class="style3"><strong>Coordenador: </strong>' + Alltrim(cCodSuper) + "-" + Alltrim(cNomeSuper) + '</span></td>'+LF					
cTexto += '</table>' + LF

cTexto += '<br>'+LF	

///Cabeçalho relatório		      
cTexto += '<table width="900" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
cTexto += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF
cTexto += '<td colspan="2"><div align="center"><span class="style3"><b>REPRESENTANTE</span></div></b></td>'+LF
cTexto += '</tr>'+LF
					
cTexto += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">COD.</span></td>'+ LF
cTexto += '<td width="900" align="center"><span class="style3">NOME</span></td>'+ LF
cTexto += '</strong></tr>'+ LF

nCtaLin++
nCtaLin++

For fr:= 1 to Len(aDados)
	cTexto += '<td width="1200"><span class="style3">'+ Alltrim(aDados[fr,3]) + "/" + Alltrim(aDados[fr,4]) + "-" + Alltrim(aDados[fr,5])+ '</span></td>'+LF      //COD/LOJA-NOME CLIENTE
	cTexto += '<td width="300" align="right"><span class="style3">' + Transform(aDados[fr,7], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
	cTexto += '<td width="300" align="right"><span class="style3">' + Transform(aDados[fr,8],"@E 999,999.99")+' </span></td>'+LF        //KG					
	cTexto += '<td width="300" align="right"><span class="style3">' + Dtoc(aDados[fr,9]) + '</span></td>'+LF  //DATA
	cTexto += '<td width="300" align="right"><span class="style3">'+ aDados[fr,1] + ' </span></td>'+LF        //COD.REPRESENTANTE
	cTexto += '<td width="300" align="left"><span class="style3">' + aDados[fr,2] + '</span></td>'+LF  //NOME REPRESENTANTE
	cTexto += '</tr>'+LF
	nCtaLin++ 
	
	cWeb := cWeb + cTexto
	cTexto := ""
	
	//////GRAVA O HTML 
    Fwrite( nHandle, cWeb, Len(cWeb) )
	cWeb := ""
	//nTotreais += aDados[fr,7]
	//nTotkilos += aDados[fr,8]		 
Next


cTexto += '</b></strong></tr></table>'+LF
nCtaLin++

Return(cTexto)


***********************************
Static Function ResumoFim(cCodSuper , cNomeSuper, cWeb, nHandle)
***********************************

Local cQuery 	:= ""                                  
Local LF	 	:= CHR(13) + CHR(10)
Local aDados 	:= {}
Local cTexto 	:= ""
Local nCtaLin	:= nLinhas
Local nTotPM 	:= 0  
Local nTotVM 	:= 0
Local cSuper 	:= ""
Local cCodRepre	:= ""
Local cNomeRepre:= ""
Local cAtivo	:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cNomeCli	:= ""
Local nTotreais := 0
Local nTotkilos := 0
Local dPriComp	:= Ctod("  /  /    ")
Local dUComp	:= Ctod("  /  /    ")
Local dUComp2	:= Ctod("  /  /    ")

cQuery := " SELECT "
cQuery += " A1_COD, A1_LOJA, A1_VEND, A3_COD, A3_NOME, A3_SUPER, A3_ATIVO " + LF
cQuery += " ,A1_NREDUZ, A3_GEREN " +LF
cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SA1.A1_VEND AND ( A3_SUPER <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK)   "+LF

cQuery += " WHERE " + LF

cQuery += " A1_VEND = A3_COD " + LF

cQuery += " AND (RTRIM(A3_SUPER) = '" + Alltrim(cCodSuper) + "' or RTRIM(A1_VEND) = '" + Alltrim(cCodSuper) + "' )"+LF

If Alltrim(cCodSuper) = '0245'
	cQuery += " AND RTRIM(A3_COD) NOT IN ('0227' , '0227VD' ) " + LF
Endif

If Alltrim(cCodSuper) = '0255'
	cQuery += " AND RTRIM(A3_COD) <> '0067' " + LF //Em 07/10/10 Flávia Viana pediu para não mostrar Sr. Manoel
	cQuery += " AND A3_ATIVO <> 'N' " + LF
Endif

cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += " ORDER BY A3_COD, A1_COD, A1_LOJA "+LF
//MemoWrite("C:\Temp\Resumo11C.sql", cQuery )

If Select("RES1") > 0
	DbSelectArea("RES1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "RES1"


cCliAnt		:= ""
cLojAnt		:= ""
nCtaSubiu	:= 0
nCtaDesceu	:= 0
nCtaNovo	:= 0

RES1->( DbGoTop() )
While RES1->( !EOF() )

	
	cSuper := ""
	cCodRepre := ""
	cNomeRepre:= ""
	cAtivo    := ""
	
	cCliente := RES1->A1_COD
	cLoja    := RES1->A1_LOJA
	cNomeCli := RES1->A1_NREDUZ
	dPriComp := Ctod("  /  /    ")
	nConta	 := 1
	nQtas	 := 0
	dUcomp	:= Ctod("  /  /    ")
	dUComp2 := Ctod("  /  /    ") 
	
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLojAnt) 
		cCodRepre	:= RES1->A3_COD
		cNomeRepre	:= RES1->A3_NOME
		cAtivo		:= RES1->A3_ATIVO
		cSuper		:= RES1->SUPER
		
		If Empty(cSuper)
			cSuper := cCodRepre
		Endif	
	   	cCli := ""
	    cLj  := ""
	    nQtas:= 0
	    ////verifica qtde de clientes NOVOS 
		cQuery  := "Select F2_CLIENTE,F2_LOJA, B1_SETOR, F2_DOC, F2_SERIE, F2_EMISSAO,A3_COD,A3_SUPER " + LF 
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " " + RetSqlName("SD2") + " SD2, "+LF
		cQuery += " " + RetSqlName("SB1") + " SB1, "+LF
		cQuery += " " + RetSqlName("SA3") + " SA3 "+LF
		
		cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 
		cQuery += " AND RTRIM(F2_CLIENTE + F2_LOJA)  = RTRIM(D2_CLIENTE + D2_LOJA) "+LF 
		cQuery += " AND RTRIM(F2_FILIAL)  = RTRIM(D2_FILIAL) "+LF 
		cQuery += " AND RTRIM(F2_DOC + F2_SERIE)  = RTRIM(D2_DOC + D2_SERIE) "+LF 
		cQuery += " AND RTRIM(B1_COD)  = RTRIM(D2_COD) "+LF 
			
		cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
		cQuery += " AND (RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' or RTRIM(F2_VEND1) = '" + Alltrim(cSuper) + "' )"+LF
		
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"+ LF
		cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
		//cQuery += " AND B1_SETOR <> '39' "+LF
		
		cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,B1_SETOR, F2_DOC, F2_SERIE, F2_EMISSAO, A3_COD, A3_SUPER " + LF 
		cQuery += " ORDER BY F2_CLIENTE,F2_LOJA " + LF 
		//Memowrite("C:\Temp\novos.sql",cQuery)
		If Select("SF2A") > 0
			DbSelectArea("SF2A")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "SF2A"
		TcSetField("SF2A", "F2_EMISSAO", "D")
		SF2A->( DBGoTop() )
		While SF2A->( !EOF() )
		    
		    cCli := SF2A->F2_CLIENTE
		    cLj  := SF2A->F2_LOJA 
			dPriComp := SF2A->F2_EMISSAO
		
			nQtas++
			
			DbSelectArea("SF2A")
			SF2A->(DBSKIP())
		Enddo	
	
		If nQtas = 1
			//If Substr(Dtos(dPriComp),1,6) = Substr(Dtos(dDatabase),1,6)	
			If (dDatabase - dPriComp) <= 90
			    nCtaNovo++		
			Endif
		Endif
		nQtas := 0
		
		////verifica qtos clientes "subiram para a grade dos 3 meses"
		dUcomp	:= Ctod("  /  /    ")
		dUComp2 := Ctod("  /  /    ")
		nConta  := 1
				
		cQuery  := "Select TOP 2 F2_CLIENTE,F2_LOJA, F2_DOC, F2_SERIE, F2_EMISSAO,A3_COD,A3_SUPER " + LF 
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " " + RetSqlName("SB1") + " SB1, "+LF
		cQuery += " " + RetSqlName("SA3") + " SA3 "+LF
		
		cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 
					
		cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
		cQuery += " AND (RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' or RTRIM(F2_VEND1) = '" + Alltrim(cSuper) + "' )"+LF
		
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
				
		cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,F2_DOC, F2_SERIE, F2_EMISSAO, A3_COD, A3_SUPER " + LF 
		cQuery += " ORDER BY F2_CLIENTE,F2_LOJA,F2_EMISSAO DESC " + LF 
		//Memowrite("C:\Temp\subiu.sql",cQuery)
		If Select("SF2A") > 0
			DbSelectArea("SF2A")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "SF2A"
		TcSetField("SF2A", "F2_EMISSAO", "D")
		
		nReg 	:= 0
		nConta 	:= 1
		
		cCli	:= ""
		cLj		:= ""
		
		SF2A->( DBGoTop() )
		While SF2A->( !EOF() )
			nReg++
			DbSelectArea("SF2A")
			SF2A->(DBSKIP())			
		Enddo		
		
		If nReg >= 2
			SF2A->( DBGoTop() )
			While SF2A->( !EOF() )
			    
			    cCli := SF2A->F2_CLIENTE
			    cLj  := SF2A->F2_LOJA 
				dUComp := SF2A->F2_EMISSAO
				
				If nConta <= 1
					dUComp2 := dUcomp			
				Endif
				nConta++
	            
				DbSelectArea("SF2A")
				SF2A->(DBSKIP())
				
				
			Enddo
		Else
			dUComp  := Ctod("  /  /    ")
		Endif
				
		If !Empty(dUComp2) .and. !Empty(dUComp)
			If (dDatabase - dUComp2) <= 90  		//a data da última compra entrou na grade
				If (dUComp2 - dUComp) >= 90         //a diferença entre a última compra e a penúltima é maior q 3 meses?
					//msgbox("Conta: " + cCli + "/" + cLj + "  -  " + Dtoc(dUComp) + " / " + Dtoc(dUComp2)) 	 
				    nCtaSubiu++		
				Endif
			Endif
		Endif
		
		////verifica qtos clientes "desceram da grade dos 3 meses"
		dUcomp	:= Ctod("  /  /    ")
		dUcomp2	:= Ctod("  /  /    ")
						
		cQuery  := "Select TOP 1 F2_CLIENTE,F2_LOJA, F2_DOC, F2_SERIE, F2_EMISSAO,A3_COD,A3_SUPER " + LF 
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " " + RetSqlName("SB1") + " SB1, "+LF
		cQuery += " " + RetSqlName("SA3") + " SA3 "+LF
		
		cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 
					
		cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
		cQuery += " AND (RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' or RTRIM(F2_VEND1) = '" + Alltrim(cSuper) + "' )"+LF
		
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
				
		cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,F2_DOC, F2_SERIE, F2_EMISSAO, A3_COD, A3_SUPER " + LF 
		cQuery += " ORDER BY F2_CLIENTE,F2_LOJA,F2_EMISSAO DESC " + LF 
		//Memowrite("C:\Temp\desceu.sql",cQuery)
		
		If Select("SF2A") > 0
			DbSelectArea("SF2A")
			DbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS "SF2A"
		TcSetField("SF2A", "F2_EMISSAO", "D")		
				
		cCli	:= ""
		cLj		:= ""
		
		SF2A->( DBGoTop() )
		While SF2A->( !EOF() )
		    cCli := SF2A->F2_CLIENTE
		    cLj  := SF2A->F2_LOJA 
			dUComp := SF2A->F2_EMISSAO
				
			DbSelectArea("SF2A")
			SF2A->(DBSKIP())
		Enddo
		
		If !Empty(dUComp) 
			If (dDatabase - dUComp) >= 91 .and.  (dDatabase - dUComp) <= 120
				//msgbox("Conta desceu: " + cCli + "/" + cLj + "  -  " + Dtoc(dUComp) ) 	 
			    nCtaDesceu++		
			Endif			
		Endif		 
		
				 
		///////////////////////////			    
		cCliAnt := cCliente
		cLojAnt := cLoja
		
		RES1->(DBSKIP())
		
	Else		//else do cli agora = cli anterior
		RES1->(DBSKIP())
	Endif		//endif se cli agora = cli anterior
 		 
Enddo
DbselectArea("RES1")
DbCloseArea()


///Cabeçalho relatório		      
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<br>'+LF


///Cabeçalho relatório		      
cTexto += '<table width="500" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td width="210" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>RESUMO DO MES: ' + MesExtenso( Month(dDatabase)) + '</span></div></B></td>'+ LF
cTexto += '<td width="50" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>QTDE</span></div></B></td>'+ LF
cTexto += '</tr>'+LF

nCtaLin++
nCtaLin++

cTexto += '<td width="210"><span class="style3">CLIENTES NOVOS</span></td>'+LF   
cTexto += '<td width="50" align="right"><span class="style3">' + Transform(nCtaNovo, "@E 9,999")  + '</span></td>'+LF 
cTexto += '</tr>'+LF
	
cTexto += '<td width="210"><span class="style3">ENTRARAM no QUADRANTE 3 MESES</span></td>'+LF   
cTexto += '<td width="50" align="right"><span class="style3">' + Transform(nCtaSubiu, "@E 9,999")  + '</span></td>'+LF 
cTexto += '</tr>'+LF
	
cTexto += '<td width="210"><span class="style3">SAIRAM do QUADRANTE 3 MESES</span></td>'+LF   
cTexto += '<td width="50" align="right"><span class="style3">' + Transform(nCtaDesceu, "@E 9,999")  + '</span></td>'+LF 
cTexto += '</tr>'+LF
 
cWeb := cWeb + cTexto
cTexto := ""
	
//////GRAVA O HTML 
Fwrite( nHandle, cWeb, Len(cWeb) )
//cWeb := ""
	 
cTexto += '</b></strong></tr></table>'+LF


Return(cTexto)

