#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR012D
//Objetivo: Relatório de Fechamento por Cliente  -  p/ Representantes 
//			Emitir relatório das vendas por representante e enviar por e-mail
//          para a supervisão (dos seus respectivos representantes)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 03/08/2010
//Alteração: 22/10/2010 - Mudar o período de avaliação de 6 para 3 meses,
//                      - Incluir resumo no final (qtde de clientes novos,
//                      - qtde. de clientes que passaram a ser antigos (mais de 3 meses),
//                      - qtde. de clientes que passaram a comprar (3 meses)
//--------------------------------------------------------------------------
/*/

********************************
User Function FATR012D()
********************************

/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/


//COORDENADORES - A3_SUPER
//SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Acomp. de Clientes para Coordenadores. "
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {} 
Local dDTPar		 := Ctod("  /  /    ")

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR012D" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR012D" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FTR012"
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
Private aSuper		:= {}
Private aRepre		:= {}
Private aMetas		:= {}
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private cCodSuper	:= ""
Private nHandle		:= 0
Private cNomeRepre	:= ""
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nLin        := 80

//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dData2 := Ctod("31/08/2010")
dData2 := GETMV("RV_ULT12D")  
dData1 := dData2 - 90


cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Fechamento (Vendas de Sacos) por Cliente (p/ Representantes) - " + cStrAno + ""

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


//Cabec1         := "CLIENTE            |   "+ cMes1 + cAnoM1+"        |    "+ cMes2 + cAnoM2+"        |  "+ cMes3 + cAnoM3 + "          |  "+ cMes4 + cAnoM4 + "          |   "+ cMes5 + cAnoM5 + "        |      CARTEIRA "
//Cabec2		   := "                   |    R$         KG      |  R$           KG       | R$          KG         |   R$        KG         |  R$            KG     |    R$            KG       "           

//Cabec1         := "CLIENTE            |   "+ cMes1 + cAnoM1+"        |    "+ cMes2 + cAnoM2+"        |  "+ cMes3 + cAnoM3 + "          |  "+ cMes4 + cAnoM4 + "          |   "+ cMes5 + cAnoM5 + "        |  "+ cMes6 + cAnoM6 + ""
//Cabec2		   := "                   |    R$         KG      |  R$           KG       | R$          KG         |   R$        KG         |  R$            KG     |    R$            KG       |    R$            KG       "           


RunReport(Cabec1,Cabec2,Titulo,nLin)	/////USAR VIA SCHEDULE

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

Local cQuery	:=''
Local cQuery2	:= ""
Local nQTD:=0 
Local aDadSu	:= {}
Local aDadSup	:= {}
Local aDadJan	:= {}
Local aTotRepre := {}
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
Local cText1	:= ""
Local cText2	:= ""


Local nMetaR	:= 0
Local nMetaK	:= 0

Local nTotMetaR := 0
Local nTotMetaK := 0

Local nMetaR1 := 0
Local nMetaK1 := 0
Local nMetaR2 := 0
Local nMetaK2 := 0
Local nMetaR3 := 0
Local nMetaK3 := 0
Local nMetaR4 := 0
Local nMetaK4 := 0
Local nMetaR5 := 0
Local nMetaK5 := 0
Local nMetaR6 := 0
Local nMetaK6 := 0


Local cCliente	:= ""
Local cLoja	  	:= ""
Local cNomeCli	:= ""
Local cCodRepre	:= ""
Local nMedia	:= 0
Local nTotMedia := 0
Local cAtivo	:= ""
Local cMailRepre:= ""


cQuery := " SELECT ROUND(SUM(C6_QTDVEN * B1_PESOR),2) AS PESO , " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR , C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO, A3_EMAIL " +LF
cQuery += " FROM " + RetSqlName("SC6") + " SC6  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK)   "+LF
cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF

cQuery += " AND RTRIM(SB1.B1_TIPO) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND C6_TES = F4_CODIGO " + LF
cQuery += " AND F4_DUPLIC = 'S' " + LF

cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF
cQuery += " AND C6_PRODUTO = B1_COD     "+LF
cQuery += " AND C6_NUM = C5_NUM      "+LF
cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF
cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF

cQuery += " AND C5_VEND1 = A3_COD "+LF
cQuery += " AND A1_VEND = A3_COD " + LF

cQuery += " AND A3_SUPER <> '' "+LF
//cQuery += " AND A3_ATIVO <> 'N' " + LF

cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ''  "+LF

//cQuery += " AND RTRIM(A3_COD) in ( '0153', '0159' , '0201' ) " + LF     //teste retirar
//cQuery += " AND RTRIM(A3_COD) in ( '0153' ) " + LF                      //teste retirar

cQuery += " AND RTRIM(A3_SUPER) in ( '0244', '0245' , '0248' ) " + LF

cQuery += " GROUP BY C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO, A3_EMAIL "+LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO "+LF
//MemoWrite("\TempQry\fatr012D.sql", cQuery )
If Select("SUP") > 0
	DbSelectArea("SUP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUP"

TCSetField( "SUP", "C5_EMISSAO", "D")



SUP->( DbGoTop() )

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
While SUP->( !EOF() )
        

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
	nTotCartR:= 0
	nTotCartK:= 0
	
	nMedia	 := 0
	cSuper 		:= SUP->A3_SUPER
	cNomeSuper 	:= ""
	cMailSuper  := ""
	
	cCodRepre	:= SUP->C5_VEND1
	cNomeRepre	:= SUP->A3_NOME
	cAtivo		:= SUP->A3_ATIVO
	cMailRepre	:= SUP->A3_EMAIL
	
	cCliente	:= SUP->C5_CLIENTE
	cLoja		:= SUP->C5_LOJACLI
	cNomeCli	:= SUP->A1_NREDUZ
	
	If !Empty( cSuper )
		DBSELECTAREA("SA3")
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)	    
	Endif
	
	
	
	Do While Alltrim(SUP->C5_CLIENTE) == Alltrim(cCliente) .AND. Alltrim(SUP->C5_LOJACLI) == Alltrim(cLoja)
		Do Case
			Case Month( SUP->C5_EMISSAO ) = nMes1
				nTotVM1 += SUP->VALOR
				nTotPM1 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes2
				nTotVM2 += SUP->VALOR
				nTotPM2 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes3
				nTotVM3 += SUP->VALOR
				nTotPM3 += SUP->PESO
			/*
			Case Month( SUP->C5_EMISSAO ) = nMes4
				nTotVM4 += SUP->VALOR
				nTotPM4 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes5
				nTotVM5 += SUP->VALOR
				nTotPM5 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes6
				nTotVM6 += SUP->VALOR
				nTotPM6 += SUP->PESO
			*/
		Endcase	
	
	
		SUP->(DBSKIP())	
	Enddo
	
	nMedia := ( ( nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4 + nTotVM5 + nTotVM6 ) / 6 )
	
	If Alltrim(cSuper) = '0255' .and. Alltrim(cAtivo) != "N"   			
	////27/07/10 - Flávia Leite pediu que para ela não precisa mostrar os Inativos(A3_ATIVO = 'N')
		
		////				1			2		  3		  4		 5         6		7
		Aadd(aDadSup, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper ,;
	   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
	   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, cMailSuper, nMedia, cAtivo, cMailRepre } )		
	       ////				14		15		16		17			18		19		20			21		22			23
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	Elseif Alltrim(cSuper) = '0248'  ////o Janderley pediu para visualizar todos, não só o Bergamo
			
			Aadd(aDadJan, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper ,;
	   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
	   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, cMailSuper, nMedia, cAtivo, cMailRepre } )		
		
	Elseif Alltrim(cSuper) $ "0244/0245"     ////Para Fulgêncio e Saraiva, só incluir o 0153 e 0159
		
		If Alltrim(cCodRepre) $ "0153/0159"
		
			Aadd(aDadSup, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper ,;
	   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
	   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, cMailSuper, nMedia, cAtivo, cMailRepre } )
		
		Endif
	
	Endif
 	
 		 
Enddo

//aDadSu := aDadSup

	aDadSu := Asort( aDadSup,,, { |X,Y| X[6] + X[1] + Transform(X[21],"@E 99,999,999.99")  <  Y[6] + Y[1] + Transform(Y[21] ,"@E 99,999,999.99") } ) 
	
	aDadJan := Asort( aDadJan,,, { |X,Y| X[1] + Transform(X[21],"@E 99,999,999.99")  <  Y[1] + Transform(Y[21] ,"@E 99,999,999.99") } ) 
	
	

SUP->( DbCloseArea() ) 
//MSGBOX("Array Criado")

nTotPM1 := 0
nTotPM2 := 0   
nTotPM3 := 0
nTotPM4 := 0
nTotPM5 := 0
nTotPM6 := 0
  
nTotVM1 	:= 0
nTotVM2 	:= 0   
nTotVM3 	:= 0
nTotVM4 	:= 0
nTotVM5 	:= 0
nTotVM6 	:= 0

nTotMedia	:= 0

nTotCartR	:= 0 
nTotCartK	:= 0

nTotMedia	:= 0

nMetaR	 	:= 0
nMetaK   	:= 0

nTotMetaR	:= 0
nTotMetaK	:= 0

nMetaR1 := 0
nMetaK1 := 0
nMetaR2 := 0
nMetaK2 := 0
nMetaR3 := 0
nMetaK3 := 0
nMetaR4 := 0
nMetaK4 := 0
nMetaR5 := 0
nMetaK5 := 0
nMetaR6 := 0
nMetaK6 := 0

cWeb	 	:= ""
cMailSuper 	:= ""
nTamSuper  	:= 0
cRepreAnt  	:= "" 
cAtivo		:= ""


nCta := 1

cWeb := ""
		
If Len(aDadSu) > 0                 		
	Do while nCta <= Len(aDadSu)
	  	    
	    nPag := 1
	   	cCodSuper := aDadSu[nCta,6]
	   	cNomeSuper:= Alltrim(aDadSu[nCta,7])
	   	cMailSuper:= Alltrim(aDadSu[nCta,20])
	   	
	   	cCodRepre := aDadSu[nCta,1]
	   	cNomeRepre:= Alltrim(aDadSu[nCta,2])
	   	cMailRepre:= Alltrim(aDadSu[nCta,23])
	   	
	   	
		cWeb := ""
			
		////CRIA O ARQUIVO DO HTML
		cDirHTM  := "\Temp\"    
		cArqHTM  := "FATR012D-" + Alltrim(cCodRepre) + ".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
							    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif   	
						
		nLinhas := 80
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			nLin++
		Endif
		
		nLin++
	   	@nLin,00 PSAY "Coordenador: " + Alltrim(aDadSu[nCta,6]) + "-" + Alltrim(aDadSu[nCta,7])
	   	nLin++
	   	If !Empty(cMailSuper)
	   		@nLin,000 PSAY cMailSuper
	   	Else 
	   		@nLin,000 PSAY "cMailSuper vazio"
	   	Endif
	   	
	   	nLin++
	   	@nLin,000 PSAY "Representante: " + Alltrim(aDadSu[nCta,1]) + "-" + Alltrim(aDadSu[nCta,2])
	   	nLin++
	   	nLin++
	   	
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
			
		If nLinhas >= 45
		
			nLinhas := 5   
			
		    ///Cabeçalho PÁGINA
	      	//cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html>'+LF
			cWeb += '<head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR012D/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			
			cWeb += '</table></head>'+ LF            
			      
			cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'+LF				
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong> '+ Alltrim(cCodSuper) + " - " + Alltrim(cNomeSuper) + '</div></span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante: </strong>'+ Alltrim(cCodRepre) + " - " + Alltrim(cNomeRepre) + '</div></span></td></tr>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">Email coordenador: '+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
			nLinhas++
			nLinhas++
			nLinhas++
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
						
			//cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
			//cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadSu[nCta,1]) + "-" + Alltrim(aDadSu[nCta,2]) +'</span></td>'+LF				
			cWeb += '</table>' + LF
			//nLinhas++
							
			///Cabeçalho relatório		      
			cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
			cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
			cWeb += '<tr>'+LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td><tr>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			
			cWeb += '</strong></tr>'+ LF			
			
			nLinhas++
			nLinhas++		   
			
		Endif		
		Do while nCta <= Len(aDadSu) .and. Alltrim(aDadSu[nCta,6]) == Alltrim(cCodSuper)
		
			Do while nCta <= Len(aDadSu) .and. Alltrim(aDadSu[nCta,1]) == Alltrim(cCodRepre)
			
			   cCodRepre  := aDadSu[nCta,1]
			   cNomeRepre := aDadSu[nCta,2]
			   cNomeSuper := aDadSu[nCta,7]
		
			   
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
			      nLin++
			   Endif
			   
			   
			   If nLinhas >= 45
				    
				    			    
				    nPag++
				    cWeb += '<br>'+LF    
					///Cabeçalho html
					cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
					cWeb += '<html><head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR012D/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					cWeb += '</table></head>'+ LF   
				
						      	
					///Cabeçalho relatório		      
					cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
					cWeb += '<tr>'+ LF
								
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '</strong></tr>'+ LF
					
					cWeb += '<br>'+LF
					
					
					nLinhas := 5
					nLinhas++		    
								        
			   Endif  
			   	nMetaR1 := 0
			   	nMetaK1 := 0
			   	nMetaR2 := 0
			   	nMetaK2 := 0
			   	nMetaR3 := 0
			   	nMetaK3 := 0
			   	nMetaR4 := 0
			   	nMetaK4 := 0
			   	nMetaR5 := 0
			   	nMetaK5 := 0
			   	nMetaR6 := 0
			   	nMetaK6 := 0
			   		   
			   	cQuery := ""
				cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				//MemoWrite("\TempQry\12DMETA.sql", cQuery )
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
						
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
						
				While META->( !EOF() )
					If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes1,2) + cAnoMe1 )
						nMetaR1 += META->Z7_VALOR
						nMetaK1 += META->Z7_KILO
									
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes2,2) + cAnoMe2 )
						nMetaR2 += META->Z7_VALOR
						nMetaK2 += META->Z7_KILO
											
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes3,2) + cAnoMe3 )
						nMetaR3 += META->Z7_VALOR
						nMetaK3 += META->Z7_KILO
					/*						
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
						nMetaR4 += META->Z7_VALOR					
						nMetaK4 += META->Z7_KILO
										
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
						nMetaR5 += META->Z7_VALOR
						nMetaK5 += META->Z7_KILO
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
						nMetaR6 += META->Z7_VALOR
						nMetaK6 += META->Z7_KILO
					*/
					Endif									
					META->(Dbskip())
				Enddo			
			   			   
			   		   
			   	////mês 1
				////acumulando totais....
				nTotVM1 += Round(aDadSu[nCta,8],2)
				nTotPM1 += Round(aDadSu[nCta,9],2)
						    
				////mês 2
				nTotVM2 += Round(aDadSu[nCta,10],2)
				nTotPM2 += Round(aDadSu[nCta,11],2)
				
				////mês 3
				nTotVM3 += Round(aDadSu[nCta,12],2)
				nTotPM3 += Round(aDadSu[nCta,13],2)
				
				////mês 4
				//nTotVM4 += Round(aDadSu[nCta,14],2)
				//nTotPM4 += Round(aDadSu[nCta,15],2)
				
				////Mês 5
				//nTotVM5 += Round(aDadSu[nCta,16],2)
				//nTotPM5 += Round(aDadSu[nCta,17],2)
								
				////Mês 6
				//nTotVM6 += Round(aDadSu[nCta,18],2)
				//nTotPM6 += Round(aDadSu[nCta,19],2)
						    
			   	cUltimaComp := ""
				If Alltrim(aDadSu[nCta,6]) = '0255'
					cUltimaComp := U_fUltiCompra( aDadSu[nCta,3] , aDadSu[nCta,4], aDadSu[nCta,1])		//irá capturar os dígitos do mês que foi realizada a última compra do cliente
				Endif
				
					
				cWeb += '<td width="1200"><span class="style3">'+ Alltrim(aDadSu[nCta,3]) + "/" + Alltrim(aDadSu[nCta,4]) + "-" + Alltrim(SUBSTR(aDadSu[nCta,5],1,15)) + '</span></td>'+LF      //NOME CLIENTE
				//coluna mês 1
				If nMes1 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,8], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,9], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,8], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,9],"@E 999,999.99")+' </span></td>'+LF        //KG					
				Endif
	
				//coluna mês 2
				If nMes2 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,10], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,10], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,11],"@E 999,999.99")+' </span></td>'+LF        //KG
				Endif
								
				//coluna mês 3
				If nMes3 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,13],"@E 999,999.99")+' </span></td>'+LF        //KG							
				Endif
				/*		
				//coluna mês 4
				If nMes4 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,15],"@E 999,999.99")+' </span></td>'+LF        //KG					
				Endif
					
				//coluna mês5
				If nMes5 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,17],"@E 999,999.99")+' </span></td>'+LF //KG						
				Endif
										
				//coluna mês 6
				If nMes6 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadSu[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,19],"@E 999,999.99")+' </span></td>'+LF   //Kg
				Endif
				*/
				//coluna média
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //MÉDIA R$
				nTotMedia += aDadSu[nCta,21]
				
				cWeb += '</tr>'+LF
				
				nLinhas++
				
				nCta++
				
				////GRAVA O HTML
				Fwrite( nHandle, cWeb, Len(cWeb) )
				cWeb := "" 
				
			Enddo		 
		   
			cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")  + '</b></span></td>'+LF
			cWeb += '</tr>'+LF 
						
			nLinhas++
						
			cWeb += '<td width="900" align="center"><span class="style3"><b>META</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR1,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR2,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR3,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK3,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR4,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK4,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR5,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK5,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR6,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK6,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b></span></td>'+LF //media
			cWeb += '</b></strong></tr></table>'+LF  
				  	
		  	nLinhas++
		  	
		  	If nLinhas <= 40
		   		//cWeb += '<div class="quebra_pagina">A pagina quebra neste ponto->' + str(nLinhas) +'</div>'+LF
		   		cWeb += '<div class="quebra_pagina"> </div>'+LF
		   		nPag++
		   	Endif
		   	nLinhas := 5
		   	
		   	//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			cWeb := ""
			
		   	cText1 := ""
		   	cText1 := Maior6Meses( cCodRepre, cNomeRepre, cWeb, nHandle )
			cWeb := cWeb + cText1
			
			//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			cWeb := ""
			
			cText1 := ""	
			cText1 := ResumoFim( cCodRepre, cNomeRepre, cWeb, nHandle )
			cWeb := cWeb + cText1
		  	
		  	///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
								
			//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			//nRet := 0
			//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browse
				
			//////ENVIA....
			
			cMailTo := cMailSuper 
			//cMailTo := ""
			cCopia  := "flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
								
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			
			///REINICIALIZA A VARIÁVEL QUE ARMAZENA O HTML		
			cWeb := ""
			////////		             	
												
			nTotPM1 := 0
			nTotPM2 := 0   
			nTotPM3 := 0
			nTotPM4 := 0
			nTotPM5 := 0
			nTotPM6 := 0
			nTotCartR:= 0
			nTotCartK:= 0
									   
			nTotVM1 := 0
			nTotVM2 := 0   
			nTotVM3 := 0
			nTotVM4 := 0
			nTotVM5 := 0
			nTotVM6 := 0
				
			nTotMedia:= 0
					
			nMetaR1 := 0
			nMetaK1 := 0
			nMetaR2 := 0
			nMetaK2 := 0
			nMetaR3 := 0
			nMetaK3 := 0
			nMetaR4 := 0
			nMetaK4 := 0
			nMetaR5 := 0
			nMetaK5 := 0
			nMetaR6 := 0
			nMetaK6 := 0
					
			////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			cWeb := "" 
				
			nLin++	
						 
		Enddo
			 	
	Enddo
Endif ///aDadSup

///array dos representantes do Janderley
nCta := 1
nLinhas := 80
cText2	:= ""
cWeb	:= ""

If Len(aDadJan) > 0

	   	
	Do while nCta <= Len(aDadJan)
	
		cCodSuper := aDadJan[nCta,6]
   		cNomeSuper:= Alltrim(aDadJan[nCta,7])
   		cMailSuper:= Alltrim(aDadJan[nCta,20])
	  	    
	    nPag := 1
	   	
	   	
	   		   	
		cWeb := ""
		
		If nCta = 1
			cCodRepre := aDadJan[nCta,1]
	   		cNomeRepre:= Alltrim(aDadJan[nCta,2])
	   		cMailRepre:= Alltrim(aDadJan[nCta,23])
	   		
			////CRIA O ARQUIVO DO HTML
			cDirHTM  := "\Temp\"    
			cArqHTM  := "FATR012D-" + Alltrim(cCodRepre) + ".HTM"   
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
									    
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif                   
		Endif
			
						
		nLinhas := 80		
	   	
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
			
		
		Do while nCta <= Len(aDadJan) .and. Alltrim(aDadJan[nCta,6]) == Alltrim(cCodSuper)
			
			cCodRepre := aDadJan[nCta,1]
	   		cNomeRepre:= Alltrim(aDadJan[nCta,2])
	   		cMailRepre:= Alltrim(aDadJan[nCta,23])
		
			If nCta > 1
				////CRIA O ARQUIVO DO HTML
				cDirHTM  := "\Temp\"    
				cArqHTM  := "FATR012D-" + Alltrim(cCodRepre) + ".HTM"   
				nHandle := fCreate( cDirHTM + cArqHTM, 0 )
										    
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif  
			
			Endif
		    nLinhas := 80
		    
		    If nLinhas >= 45
		
				nLinhas := 5   
				
			    ///Cabeçalho PÁGINA
		      	//cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html>'+LF
				cWeb += '<head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR012D/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				
				cWeb += '</table></head>'+ LF            
				      
				cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'+LF				
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador: </strong>'+ Alltrim(cCodSuper) + " - " + Alltrim(cNomeSuper) + '</div></span></td></tr>'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante: </strong>'+ Alltrim(cCodRepre) + "-" + Alltrim(cNomeRepre) + '</div></span></td></tr>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">Email coordenador: '+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
				nLinhas++
				nLinhas++
				nLinhas++
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
							
				//cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
				//cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadJan[nCta,1]) + "-" + Alltrim(aDadJan[nCta,2]) +'</span></td>'+LF				
				cWeb += '</table>' + LF
				//nLinhas++
								
				///Cabeçalho relatório		      
				cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
				cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
				cWeb += '<tr>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td><tr>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				
				cWeb += '</strong></tr>'+ LF			
				
				nLinhas++
				nLinhas++		   
			
			Endif		
			
			Do while nCta <= Len(aDadJan) .and. Alltrim(aDadJan[nCta,1]) == Alltrim(cCodRepre)
			
			   cCodRepre  := aDadJan[nCta,1]
			   cNomeRepre := aDadJan[nCta,2]
			   cNomeSuper := aDadJan[nCta,7]  
			   		   
			   
			   If nLinhas >= 45
				    
				    			    
				    nPag++
				    cWeb += '<br>'+LF    
					///Cabeçalho html
					cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
					cWeb += '<html><head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR012D/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					cWeb += '</table></head>'+ LF   
				
						      	
					///Cabeçalho relatório		      
					cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
					cWeb += '<tr>'+ LF
								
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '</strong></tr>'+ LF
					
					cWeb += '<br>'+LF
					
					
					nLinhas := 5
					nLinhas++		    
								        
			   Endif  
			   	nMetaR1 := 0
			   	nMetaK1 := 0
			   	nMetaR2 := 0
			   	nMetaK2 := 0
			   	nMetaR3 := 0
			   	nMetaK3 := 0
			   	nMetaR4 := 0
			   	nMetaK4 := 0
			   	nMetaR5 := 0
			   	nMetaK5 := 0
			   	nMetaR6 := 0
			   	nMetaK6 := 0
			   		   
			   	cQuery := ""
				cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				//MemoWrite("\TempQry\12DMETA.sql", cQuery )
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
						
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
						
				While META->( !EOF() )
					If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes1,2) + cAnoMe1 )
						nMetaR1 += META->Z7_VALOR
						nMetaK1 += META->Z7_KILO
									
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes2,2) + cAnoMe2 )
						nMetaR2 += META->Z7_VALOR
						nMetaK2 += META->Z7_KILO
											
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes3,2) + cAnoMe3 )
						nMetaR3 += META->Z7_VALOR
						nMetaK3 += META->Z7_KILO
					/*						
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
						nMetaR4 += META->Z7_VALOR					
						nMetaK4 += META->Z7_KILO
										
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
						nMetaR5 += META->Z7_VALOR
						nMetaK5 += META->Z7_KILO
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
						nMetaR6 += META->Z7_VALOR
						nMetaK6 += META->Z7_KILO
					*/
					Endif				
					META->(Dbskip())
				Enddo			
			   			   
			   		   
			   	////mês 1
				////acumulando totais....
				nTotVM1 += Round(aDadJan[nCta,8],2)
				nTotPM1 += Round(aDadJan[nCta,9],2)
						    
				////mês 2
				nTotVM2 += Round(aDadJan[nCta,10],2)
				nTotPM2 += Round(aDadJan[nCta,11],2)
				
				////mês 3
				nTotVM3 += Round(aDadJan[nCta,12],2)
				nTotPM3 += Round(aDadJan[nCta,13],2)
				
				////mês 4
				//nTotVM4 += Round(aDadJan[nCta,14],2)
				//nTotPM4 += Round(aDadJan[nCta,15],2)
				
				////Mês 5
				//nTotVM5 += Round(aDadJan[nCta,16],2)
				//nTotPM5 += Round(aDadJan[nCta,17],2)
								
				////Mês 6
				//nTotVM6 += Round(aDadJan[nCta,18],2)
				//nTotPM6 += Round(aDadJan[nCta,19],2)
						    
			   	cUltimaComp := ""
				If Alltrim(aDadJan[nCta,6]) = '0255'
					cUltimaComp := U_fUltiCompra( aDadJan[nCta,3] , aDadJan[nCta,4], aDadJan[nCta,1])		//irá capturar os dígitos do mês que foi realizada a última compra do cliente
				Endif
				
					
				cWeb += '<td width="1200"><span class="style3">'+ Alltrim(aDadJan[nCta,3]) + "/" + Alltrim(aDadJan[nCta,4]) + "-" + Alltrim(SUBSTR(aDadJan[nCta,5],1,15)) + '</span></td>'+LF      //NOME CLIENTE
				//coluna mês 1
				If nMes1 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,8], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,9], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,8], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,9],"@E 999,999.99")+' </span></td>'+LF        //KG					
				Endif
	
				//coluna mês 2
				If nMes2 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,10], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,10], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadJan[nCta,11],"@E 999,999.99")+' </span></td>'+LF        //KG
				Endif
								
				//coluna mês 3
				If nMes3 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadJan[nCta,13],"@E 999,999.99")+' </span></td>'+LF        //KG							
				Endif
				/*		
				//coluna mês 4
				If nMes4 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadJan[nCta,15],"@E 999,999.99")+' </span></td>'+LF        //KG					
				Endif
					
				//coluna mês5
				If nMes5 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadJan[nCta,17],"@E 999,999.99")+' </span></td>'+LF //KG						
				Endif
										
				//coluna mês 6
				If nMes6 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadJan[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else			
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,19],"@E 999,999.99")+' </span></td>'+LF   //Kg
				Endif
				*/
				//coluna média
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadJan[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //MÉDIA R$
				nTotMedia += aDadJan[nCta,21]
				
				cWeb += '</tr>'+LF
				
				nLinhas++
				
				nCta++
				
				////GRAVA O HTML
				Fwrite( nHandle, cWeb, Len(cWeb) )
				cWeb := "" 
				
			Enddo	 ///enddo do enqto for repre	 
		   
			cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")  + '</b></span></td>'+LF
			cWeb += '</tr>'+LF 
						
			nLinhas++
						
			cWeb += '<td width="900" align="center"><span class="style3"><b>META</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR1,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR2,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR3,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK3,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR4,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK4,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR5,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK5,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR6,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK6,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b></span></td>'+LF //media
			cWeb += '</b></strong></tr></table>'+LF  
				  	
		  	nLinhas++
		  	
		  	If nLinhas <= 40
		   		//cWeb += '<div class="quebra_pagina">A pagina quebra neste ponto->' + str(nLinhas) +'</div>'+LF
		   		cWeb += '<div class="quebra_pagina"> </div>'+LF
		   		nPag++
		   	Endif
		   	nLinhas := 5
		   	
		   	////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			cWeb := ""
			
			cText2 := ""			
			cText2 := Maior6Meses( cCodRepre, cNomeRepre, cWeb, nHandle )
			cWeb := cWeb + cText2
			
			////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			cWeb := ""
			
			cText2 := ""
			cText2 := ResumoFim( cCodRepre, cNomeRepre, cWeb, nHandle )
			cWeb := cWeb + cText2
		  	
		  	///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
								
			//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			//nRet := 0
			//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browse
				
			//////ENVIA....
			
			cMailTo := cMailSuper 
			//cMailTo := ""
			cCopia  := "flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
								
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			
			///REINICIALIZA A VARIÁVEL QUE ARMAZENA O HTML		
			cWeb := ""
			////////		             	
															
			nTotPM1 := 0
			nTotPM2 := 0   
			nTotPM3 := 0
			nTotPM4 := 0
			nTotPM5 := 0
			nTotPM6 := 0
			nTotCartR:= 0
			nTotCartK:= 0
									   
			nTotVM1 := 0
			nTotVM2 := 0   
			nTotVM3 := 0
			nTotVM4 := 0
			nTotVM5 := 0
			nTotVM6 := 0
				
			nTotMedia:= 0
					
			nMetaR1 := 0
			nMetaK1 := 0
			nMetaR2 := 0
			nMetaK2 := 0
			nMetaR3 := 0
			nMetaK3 := 0
			nMetaR4 := 0
			nMetaK4 := 0
			nMetaR5 := 0
			nMetaK5 := 0
			nMetaR6 := 0
			nMetaK6 := 0
										
			nLin++	
						 
		Enddo		//enddo do while super			 	
	Enddo		//enddo geral do array
Endif


///fim Janderley

//MSGINFO("FATR012D - OK")

dDTPar := LastDay(dDatabase)
PutMV("RV_ULT12D", dDTPar )

// Habilitar somente para Schedule
Reset environment


Return

******************************************************************
Static Function Maior6Meses(cRepre , cReprenome, cWeb, nHandle)
******************************************************************

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
Local dUltimaC  := Ctod("  /  /    ")


cQuery := " SELECT PESO = SUM(C6_QTDVEN * B1_PESOR) , " +LF
cQuery += " VALOR=SUM(C6_VALOR), C5_VEND1, A3_NOME, " + LF
cQuery += " C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO " +LF
cQuery += " FROM " + RetSqlName("SC6") + " SC6  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK)   "+LF

cQuery += "WHERE " + LF
cQuery += " C6_FILIAL = '" + xFilial("SC6") + "' "+LF
cQuery += " AND RTRIM(SB1.B1_TIPO) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF 

cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF
cQuery += " AND RTRIM(SC6.C6_TES) = RTRIM(SF4.F4_CODIGO) " +LF

cQuery += " AND SC6.C6_QTDENT = SC6.C6_QTDVEN " + LF
cQuery += " AND SC6.C6_NOTA <> '' " + LF

cQuery += " AND C6_PRODUTO = B1_COD     "+LF
cQuery += " AND C6_NUM = C5_NUM      "+LF

cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF

cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF

cQuery += " AND C5_VEND1 = A3_COD "+LF
//cQuery += " AND A1_VEND = A3_COD " + LF

cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cRepre) + "' "+LF

cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_ATIVO "+LF
cQuery += " ORDER BY C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO DESC "+LF
//MemoWrite("C:\Temp\ultipag11D.sql", cQuery )
If Select("SC6U") > 0
	DbSelectArea("SC6U")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SC6U"

TCSetField( "SC6U", "C5_EMISSAO", "D")
TCSetField( "SC6U", "C5_ENTREG", "D")
//TCSetField( "SC6U", "F2_EMISSAO", "D")

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
	dUltimaC	:= Ctod("  /  /    ")
	
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
						
			
			cQuery := " SELECT TOP 1 F2_CLIENTE, F2_LOJA, F2_EMISSAO , B1_SETOR " + LF  
			cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
			cQuery += " " + RetSqlName("SD2") + " SD2, "+LF
			cQuery += " " + RetSqlName("SF4") + " SF4, "+LF
			cQuery += " " + RetSqlName("SB1") + " SB1, "+LF
			cQuery += " " + RetSqlName("SA3") + " SA3 "+LF			
		
			cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 
			cQuery += " AND RTRIM(F2_CLIENTE + F2_LOJA)  = RTRIM(D2_CLIENTE + D2_LOJA) "+LF 
			cQuery += " AND RTRIM(F2_FILIAL)  = RTRIM(D2_FILIAL) "+LF 
			cQuery += " AND RTRIM(F2_DOC + F2_SERIE)  = RTRIM(D2_DOC + D2_SERIE) "+LF 
			cQuery += " AND RTRIM(B1_COD)  = RTRIM(D2_COD) "+LF 
			
			cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
			cQuery += " AND RTRIM(F2_VEND1) = '" + Alltrim(cCodRepre) + "' " + LF
			
			cQuery += " AND RTRIM(SD2.D2_TES) = RTRIM(SF4.F4_CODIGO) " + LF 
			cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF
			
			cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
			cQuery += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"+ LF
			cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
			cQuery += " AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"+ LF
			cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			
			cQuery += " AND F2_TIPO = 'N' "+LF
			cQuery += " AND F2_SERIE <> '' "+LF
			cQuery += " AND B1_SETOR <> '39' "+LF
			cQuery += " AND B1_TIPO = 'PA' "+LF
			cQuery += " AND SD2.D2_TES NOT IN( '540','516') " +LF
			
			cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_EMISSAO, B1_SETOR  " + LF

			cQuery += " ORDER BY F2_EMISSAO DESC " + LF
			//MemoWrite("C:\Temp\ultimac11d.sql", cQuery)
			
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
			  				
                If !Empty(dUltimaC)
					If Alltrim(cSuper) = '0255' .and. Alltrim(cAtivo) != "N"   			
									
						////				1			2		  3		  4		 5         6		7		8		9       10
						Aadd(aDados, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, nTotVM, nTotPM, dUltimaC, cAtivo } )		
						 
					Elseif Alltrim(cSuper) != '0255'
							////				1		2		  3		  4		  5         6		7		8		9  		10
						Aadd(aDados, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, nTotVM, nTotPM, dUltimaC, cAtivo } )		
						
					Endif
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


	aDados := Asort( aDados,,, { |X,Y| X[9] <  Y[9]  } ) 
	
///Cabeçalho relatório		      
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<br>'+LF
cTexto += '<table width="600" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td width="500" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES QUE NAO COMPRAM HA MAIS DE 3 MESES (VENDAS DE SACOS):</span></div></B></td>'+ LF
cTexto += '</tr></table>'+LF

cTexto += '<table width="500" border="0" style="font-size:12px;font-family:Arial">'+LF
cTexto += '<td width="250"><div align="Left"><span class="style3"><strong>Representante: </strong>'+ Alltrim(cCodRepre) + "-" + Alltrim(cNomeRepre) + '</span></td>'+LF					
cTexto += '</table>' + LF

cTexto += '<br>'+LF	

///Cabeçalho relatório		      
cTexto += '<table width="500" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
cTexto += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF
//cTexto += '<td colspan="2"><div align="center"><span class="style3"><b>REPRESENTANTE</span></div></b></td>'+LF
cTexto += '</tr>'+LF
					
cTexto += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF
//cTexto += '<td width="300" align="center"><span class="style3">COD.</span></td>'+ LF
//cTexto += '<td width="900" align="center"><span class="style3">NOME</span></td>'+ LF
cTexto += '</strong></tr>'+ LF

nCtaLin++
nCtaLin++

For fr:= 1 to Len(aDados)
	cTexto += '<td width="1200"><span class="style3">'+ Alltrim(aDados[fr,3]) + "/" + Alltrim(aDados[fr,4]) + "-" + Alltrim(aDados[fr,5])+ '</span></td>'+LF      //COD/LOJA-NOME CLIENTE
	cTexto += '<td width="300" align="right"><span class="style3">' + Transform(aDados[fr,7], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
	cTexto += '<td width="300" align="right"><span class="style3">' + Transform(aDados[fr,8],"@E 999,999.99")+' </span></td>'+LF        //KG					
	cTexto += '<td width="300" align="right"><span class="style3">' + Dtoc(aDados[fr,9]) + '</span></td>'+LF  //DATA
	//cTexto += '<td width="300" align="right"><span class="style3">'+ aDados[fr,1] + ' </span></td>'+LF        //COD.REPRESENTANTE
	//cTexto += '<td width="300" align="left"><span class="style3">' + aDados[fr,2] + '</span></td>'+LF  //NOME REPRESENTANTE
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
Static Function ResumoFim(cRepre , cNomeRepre, cWeb, nHandle)
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

cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cRepre) + "' "+LF

If Alltrim(cRepre) = '0255'
	cQuery += " AND A1_ATIVO <> 'N' " + LF
Endif

cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += " ORDER BY A3_COD, A1_COD, A1_LOJA "+LF
//MemoWrite("C:\Temp\Resumo11D.sql", cQuery )

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
	
	cCodRepre	:= RES1->A3_COD
	cNomeRepre	:= RES1->A3_NOME
	cAtivo		:= RES1->A3_ATIVO
	cSuper		:= RES1->SUPER
		
	If Empty(cSuper)
		cSuper := cCodRepre
	Endif	
		
	dPriComp := Ctod("  /  /    ")
	nConta	 := 1
	nQtas	 := 0
	dUcomp	:= Ctod("  /  /    ")
	dUComp2 := Ctod("  /  /    ") 
	
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLojAnt) 
		
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
		cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF
		
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
			If Substr(Dtos(dPriComp),1,6) = Substr(Dtos(dDatabase),1,6)	
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
		cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF
		
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
		cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF
		
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

