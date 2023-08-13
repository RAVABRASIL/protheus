#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR013D
//Objetivo: Relatório de Acompanhamento por Cliente (COLETORES)  -  Ano 
//			Emitir relatório das vendas por representante e enviar por e-mail
//          aos mesmos individualmente.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 04/02/2010
//--------------------------------------------------------------------------
/*/

************************************
User Function FATR013D()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Acomp. de Cliente para Representantes. "
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
Private nomeprog     := "FATR013D" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR013D" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FTR013"
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
Private cWeb		:= Space(2000)
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private nLinhas		:= 80 
Private nLin        := 80
Private cCodRepre 	:= ""
Private cNomeRepre	:= ""
Private cMailRepre	:= ""

Private nMes6 
Private	nMes5
Private	nMes4
Private	nMes3
Private	nMes2
Private	nMes1

//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dData2 := LastDay(dDatabase)
dData1 := dData2 - 90 //- 180 foi solicitado em 14/2010 alteração do período de análise de 6 para 3 meses


cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Acompanhamento (Vendas de COLETORES) por Cliente (p/ Representantes)  -  " + cStrAno + ""

//Compor o array com o número dos meses do ano
cAnoM1 := ""
cAnoM2 := ""
cAnoM3 := ""
cAnoM4 := ""
cAnoM5 := ""
cAnoM6 := ""

aMeses:= {}
aMeses:= { 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 }

nPosMes := Ascan( aMeses, Month(dData2) )


If nPosMes = 1         //se for Janeiro 
		
	nMes3 := aMeses[nPosMes]     //1
	nMes2 := aMeses[nPosMes + 11 ]     //12
	nMes1 := aMeses[nPosMes + 10 ]     //11

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10 
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	//dez/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//nov/09

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


//EM 11/06/10 FOI SOLICITADO PELOS COORDENADORES E SR. VIANA QUE SE RETIRASSE AS COLUNAS "KG" E ACRESCENTASSE 
//UMA COLUNA "MÉDIA"

//Cabec1         := "CLIENTE        |    "+ cMes1 + cAnoM1 +     "          |   "+ cMes2 + cAnoM2 +      "        |   "+ cMes3 + cAnoM3 +       "         |   "+ cMes4 + cAnoM4 + "         |   "+ cMes5 + cAnoM5 + "         |  "+ cMes6 + cAnoM6 + "    |         MÉDIA  "
//Cabec2		   := "               |    R$                    |    R$                 |  R$                    | R$                     |   R$                   |  R$              |        R$ "

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
Local nTotMedia:= 0
Local cRepreAnt:= "" 
Local cUltimaComp := ""
Local cAtivo	:= ""


cQuery := " SELECT ROUND(SUM(C6_QTDVEN),2) AS QTDE ,  " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR, C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NOME,C5_EMISSAO, A3_GEREN " + LF
//, A3_SUPER
cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( RTRIM(A3_SUPER) <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " , A3_EMAIL, A3_ATIVO " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' " +LF

cQuery += " AND RTRIM(B1_TIPO) != 'AP' " +LF //Despreza Apara 
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' " +LF      //somente CAIXAS

cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_PRODUTO = B1_COD     "  +LF
cQuery += " AND C6_NUM = C5_NUM      " +LF

cQuery += " AND C6_CLI = C5_CLIENTE " +LF
cQuery += " AND C6_LOJA = C5_LOJACLI       " +LF

cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF

cQuery += " AND C5_VEND1 = A3_COD " +LF
//cQuery += " AND A1_VEND = A3_COD " + LF

//cquery += " AND RTRIM(C5_CLIENTE) = '001704' AND RTRIM(C5_LOJACLI) = '01' " + LF
cQuery += " AND ( RTRIM(A3_SUPER) <> '' or RTRIM(A3_GEREN) = '0249'  ) " + LF

//cQuery += " AND RTRIM(C5_VEND1) = '0151' " + LF 		//Caso precise emitir de um Vendedor em específico, habilitar esta linha

cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_VEND1,C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO " +LF
//MemoWrite("C:\Temp\FATR013D.sql", cQuery )
          
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
    
    
    cCodRepre 	:= REP->C5_VEND1
	cNomeRepre	:= REP->A3_NOME
	cMailRepre	:= REP->A3_EMAIL
	cAtivo		:= REP->A3_ATIVO
	cCliente	:= REP->C5_CLIENTE
	cLoja		:= REP->C5_LOJACLI
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
	
	If !Empty(REP->SUPER)              ///é representante
		cSuper:= REP->SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME
	
	Else
		cSuper 		:= REP->C5_VEND1
		cNomeSuper	:= REP->A3_NOME
	Endif
	

	Do While Alltrim(REP->C5_CLIENTE) == Alltrim(cCliente) .AND. Alltrim(REP->C5_LOJACLI) == Alltrim(cLoja)
		Do Case
			Case Month( REP->C5_EMISSAO ) = nMes1
				nTotVM1 += REP->VALOR
				nTotPM1 += REP->QTDE
			Case Month( REP->C5_EMISSAO ) = nMes2
				nTotVM2 += REP->VALOR
				nTotPM2 += REP->QTDE
			Case Month( REP->C5_EMISSAO ) = nMes3
				nTotVM3 += REP->VALOR
				nTotPM3 += REP->QTDE
			/*
			Case Month( REP->C5_EMISSAO ) = nMes4
				nTotVM4 += REP->VALOR
				nTotPM4 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes5
				nTotVM5 += REP->VALOR
				nTotPM5 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes6
				nTotVM6 += REP->VALOR
				nTotPM6 += REP->PESO
			*/
		Endcase	
	
		REP->(DBSKIP())	
	Enddo


	//nMedia := ( (nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4 + nTotVM5 + nTotVM6) / 6 )
	
	nMedia := ( (nTotVM1 + nTotVM2 + nTotVM3) / 3 )
	
	If Alltrim(cSuper) = '0255' .and. Alltrim(cAtivo) != "N"
		//					1			2		  3	  		4		 5         6		7           8		9        10
		Aadd(aDadRep, { cCodRepre, cNomeRepre, cMailRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper , cGeren, cNomeGeren , ;
	   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
	   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, nMedia, cAtivo } )
	   				//    17		18		19		20	    	21		22		23		24		
	 
	 Elseif Alltrim(cSuper) != '0255'
	 		//					1			2		  3	  		4		 5         6		7           8		9        10
		Aadd(aDadRep, { cCodRepre, cNomeRepre, cMailRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper , cGeren, cNomeGeren , ;
	   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
	   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, nMedia, cAtivo } )
	   				//    17		18		19		20	    	21		22		23		24		
	 Endif

Enddo

aDadRe := Asort( aDadRep,,, { |X,Y| X[1] + Transform(X[23],"@E 99,999,999.99") < Y[1] + Transform(Y[23],"@E 99,999,999.99")  } )  

REP->( DbCloseArea() )
//MSGBOX("Array Criado...")

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

cWeb		:= ""
nTotCartR	:= 0
nTotCartK	:= 0
cMailRepre 	:= ""
nLinhas 	:= 80
nMedia  	:= 0
nTotMedia	:= 0
cRepreAnt	:= ""

nCta := 1
Do While nCta <= Len(aDadRe)


	   
   If nCta = 1
   		cCodRepre := aDadRe[nCta,1]
   		cNomeRepre:= aDadRe[nCta,2]
   		cMailRepre:= aDadRe[nCta,3]
   		cSuper	  := aDadRe[nCta,7]
	   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
	   	cDirHTM  := "\Temp\"    
		cArqHTM  := "FATR013D" + Alltrim(cCodRepre) +".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
			
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
   
   If nLinhas >= 42  		////Em 11/06 - foi solicitado pelos coord. de venda e Sr. Viana que seja um representante por página      		
   		
   		If nCta > 1 
   			cWeb += '<div class="quebra_pagina"></div>'+LF
   		Endif
   		/////CABEÇALHO PÁGINA
		cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
		cWeb += '<html><head>'+ LF
		cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
		cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
		cWeb += '<tr>    <td>'+ LF
		cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
		cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
		cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
		cWeb += '<tr>        <td>SIGA /FATR013D/v.P10</td>'+ LF
		cWeb += '<td align="center">' + titulo + '</td>'+ LF
		cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
		cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
		cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
		cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
		cWeb += '</table></head>'+ LF
		
		nLinhas := 5
	
		If nCta = 1 
			/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += '<table width="1000" border="0" style="font-size:12px;font-family:Arial">'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
			cWeb += '</table>' + LF
		
		Endif		
		
		nLinhas++
		nLinhas++
		
		///Cabeçalho relatório	      
		cWeb += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
		cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
		cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
		cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
		cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
		cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
		
		cWeb += '<tr>'+ LF
		cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF    //mes 1
		cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF    //mes 2
		cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF    //mes 3
		cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF    //média
		//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
		//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
		//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
		cWeb += '</strong></tr>'+ LF				
   		nLinhas++
   		
		nPag++

   Endif
      		
   		If nCta > 1
   			//If ( aDadRe[nCta,1] != aDadRe[nCta - 1,1] )     ////se mudou o representante...totaliza
   			If ( Alltrim(aDadRe[nCta,1]) != Alltrim(cCodRepre) )     ////se mudou o representante...totaliza			
   					       
				cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</b></span></td>'+LF
				//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</b></span></td>'+LF
				//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</b></span></td>'+LF
				//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
				cWeb += '</tr></table>'+LF
				
				nLinhas++
				
								
				////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
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
				
				nTotMedia:= 0
				
				//////GRAVA O HTML 
			    Fwrite( nHandle, cWeb, Len(cWeb) )
			    cWeb := ""
			    
			    //////////////////////////////////////////////////////////////////////
			    //chama função que traz clientes que não compram há mais de 6 meses
			    //para mostrar na última página do html
			    /////////////////////////////////////////////////////////////////////
			    cText := Maior6Meses( cCodRepre, cNomeRepre, cWeb, nHandle )
			    cWeb := cWeb + cText
				//MSGBOX(cCodRepre)			   
			    ///FECHA O HTML PARA ENVIO
				cWeb += '</body> '
				cWeb += '</html> '
				
			    ///GRAVA O HTML
			    Fwrite( nHandle, cWeb, Len(cWeb) )
				FClose( nHandle )
				                      
				/////ENVIA PARA O REPRESENTANTE 
				cMailTo := cMailRepre //e-mail
				//cMailTo := "" 
				cCopia  := "flavia.rocha@ravaembalagens.com.br"
				If Alltrim(cSuper) = '0255'
				  cCopia += ";patricia.oliveira@ravaembalagens.com.br" //";flavia@ravaembalagens.com.br;patricia.oliveira@ravaembalagens.com.br"	  // af 	//email do sup. de vendas (ex: Patricia Oliveira)
				Endif
				cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := titulo
				
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			
				////REINICIALIZA CWEB PARA NOVO HTML DO REPRESENTANTE...
				cWeb := ""
			    ////////
			    ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
	   			cDirHTM  := "\Temp\"    
				cArqHTM  := "FATR013D" + Alltrim(aDadRe[nCta,1]) +".HTM"   
				nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		    
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
			  
			   	////NOVO REPRESENTANTE...
			   	cCodRepre := aDadRe[nCta,1]
	   			cNomeRepre:= aDadRe[nCta,2]
				cMailRepre:= aDadRe[nCta,3]
				cSuper    := aDadRe[nCta,7]
				
				nPag := 1
				
				//nLinhas := 80
				
								
				/////CABEÇALHO PÁGINA
				cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html><head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR013D/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				cWeb += '</table></head>'+ LF			
				
				nLinhas := 5
				
				/////////////////////////////////////
				////LINHA REPRESENTANTE E SUPERVISOR
				/////////////////////////////////////
				cWeb += '<table width="900" border="0" style="font-size:12px;font-family:Arial">'+LF
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
				cWeb += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
				cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
				cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
				cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
				cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
				
				cWeb += '<tr>'+ LF
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//mes 1			
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 		//mes 2		
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 		//mes 3		
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//mes 4		
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '</strong></tr>'+ LF				
		        
				nLinhas++
				
				nPag++						
					   
			Endif
		Endif
	
        	        		
        		//@nLin,000 PSAY SUBSTR(aDadRe[nCta,6],1,15)	PICTURE "@!"  ////NOME CLIENTE
        		
        		cWeb += '<td width="920"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF		////CLIENTE
        		cUltimaComp := ""
				If Alltrim(cSuper) = '0255'
					cUltimaComp := fUltiCompra( aDadRe[nCta,4] , aDadRe[nCta,5], aDadRe[nCta,1])		//irá capturar os dígitos do mês que foi realizada a última compra do cliente
				Endif
								
				////mês 1
				nTotVM1 += aDadRe[nCta,11]									  					
			
				If nMes1 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					//amarelo
					//cWeb += '<td width="300" bgcolor="#03E517" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					//verde
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
								
				////mês 2
				nTotVM2 += aDadRe[nCta,13]								
				If nMes2 = Val(cUltimaComp)	    		
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
									
				////mês 3
				nTotVM3 += aDadRe[nCta,15]				
				If nMes3 = Val(cUltimaComp)	    		
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
								
				////mês 4
				/*
				nTotVM4 += aDadRe[nCta,17]				
				If nMes4 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
									
				////mês 5
				nTotVM5 += aDadRe[nCta,19]				
				If nMes5 = Val(cUltimaComp)				
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
				
				////MÊS 6
				nTotVM6 += aDadRe[nCta,21]				
				If nMes6 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
				Endif
				*/				
				//// MÉDIA
				nTotMedia += aDadRe[nCta,23]				
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '</tr>'+LF 		//finaliza a linha
        	
      
   		nCta++
   		//nLin++
     	nLinhas++    
    
     

Enddo

cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</b></span></td>'+LF
//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</b></span></td>'+LF
//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</b></span></td>'+LF
//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF

cWeb += '</tr></table>'+LF     ////finaliza a linha e a tabela

//////GRAVA O HTML 
Fwrite( nHandle, cWeb, Len(cWeb) )
cWeb := ""
		    
//////////////////////////////////////////////////////////////////////
//chama função que traz clientes que não compram há mais de 6 meses
//para mostrar na última página do html
/////////////////////////////////////////////////////////////////////
cText := Maior6Meses( cCodRepre, cNomeRepre, cWeb, nHandle )
cWeb := cWeb + cText

cText := ResumoFim( cCodRepre, cNomeRepre, cWeb, nHandle )
cWeb := cWeb + cText

/////FECHA O HTML GERADO PARA ENVIO
cWeb += '</body> '
cWeb += '</html> '

/////////GRAVA O HTML
Fwrite( nHandle, cWeb, Len(cWeb) )
FClose( nHandle )
//nRet := 0
//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //esta funcionou, OK
			
//////ENVIA PARA O REPRESENTANTE (último)
cMailTo := cMailRepre
//cMailTo := ""
cCopia  := "flavia.rocha@ravaembalagens.com.br"
If Alltrim(cSuper) = '0255'
	cCopia += ";patricia.oliveira@ravaembalagens.com.br;flavia@ravaembalagens.com.br"		//email do sup. de vendas (ex: Patricia Oliveira)
Endif
cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
		
//lEnviou := U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )		    
U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
	    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Msginfo("FATR013D - Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return

*********************************************************
Static Function fUltiCompra( cCliente, cLoja, cVendedor )
*********************************************************

Local cQuery 	:= ""
Local cUltimes 	:= ""
Local LF		:= CHR(13)+CHR(10) 

cQuery := " SELECT TOP 1 F2_CLIENTE, F2_LOJA, F2_EMISSAO , B1_SETOR " + LF  
cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SD2") + " SD2, "+LF
cQuery += " " + RetSqlName("SB1") + " SB1, "+LF
cQuery += " " + RetSqlName("SF4") + " SF4, "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 "+LF			
	
cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + Alltrim(cCliente + cLoja) + "' "+LF 

cQuery += " AND RTRIM(F2_CLIENTE + F2_LOJA)  = RTRIM(D2_CLIENTE + D2_LOJA) "+LF 
cQuery += " AND RTRIM(F2_FILIAL)  = RTRIM(D2_FILIAL) "+LF 
cQuery += " AND RTRIM(F2_DOC + F2_SERIE)  = RTRIM(D2_DOC + D2_SERIE) "+LF 
cQuery += " AND RTRIM(B1_COD)  = RTRIM(D2_COD) "+LF 
		
cQuery += " AND RTRIM(F2_VEND1)  = RTRIM(A3_COD) "+LF  
cQuery += " AND RTRIM(F2_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 

cQuery += " AND RTRIM(SD2.D2_TES) = RTRIM(SF4.F4_CODIGO) " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF
			
cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"+ LF
cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
cQuery += " AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"+ LF
cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
			
cQuery += " AND F2_TIPO = 'N' "+LF
cQuery += " AND F2_SERIE <> '' "+LF
cQuery += " AND B1_TIPO = 'PA' "+LF

cQuery += " AND B1_SETOR = '39' "+LF  		//SETOR = CAIXAS

cQuery += " AND SD2.D2_TES NOT IN( '540','516') " +LF 
cQuery += " AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " + LF

cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_EMISSAO, B1_SETOR  " + LF

cQuery += " ORDER BY F2_EMISSAO DESC " + LF
//MemoWrite("C:\temp\ulticompra.sql", cQuery)

If Select("SC5U") > 0
	DbSelectArea("SC5U")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SC5U"

//TCSetField( "SF2U", "F2_EMISSAO", "D")

SC5U->( DbGoTop() )
While SC5U->( !EOF() )
	cUltimes := Substr(SC5U->F2_EMISSAO,5,2) 	//ex: 07
	//msgbox(cCliente + "->" + cUltimes)
	SC5U->(DBSKIP())
Enddo

Return(cUltimes)

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


cQuery := " SELECT QTDE = SUM(C6_QTDVEN) , " +LF
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
 
cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' "+LF		//SETOR = CAIXAS

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
	nTotPM := SC6U->QTDE	
	
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
			cQuery += " AND B1_SETOR = '39' "+LF    	//SETOR = CAIXAS
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
cTexto += '<td width="500" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES QUE NAO COMPRAM HA MAIS DE 3 MESES (VENDAS DE COLETORES):</span></div></B></td>'+ LF
cTexto += '</tr></table>'+LF

cTexto += '<table width="500" border="0" style="font-size:12px;font-family:Arial">'+LF
cTexto += '<td width="300"><div align="Left"><span class="style3"><strong>Representante: </strong>'+ Alltrim(cCodRepre) + "-" + Alltrim(cNomeRepre) + '</span></td>'+LF					
cTexto += '</table>' + LF

cTexto += '<br>'+LF	

///Cabeçalho relatório		      
cTexto += '<table width="500" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
cTexto += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
cTexto += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF
//cTexto += '<td colspan="2"><div align="center"><span class="style3"><b>REPRESENTANTE</span></div></b></td>'+LF
cTexto += '</tr>'+LF
					
cTexto += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
cTexto += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF
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

