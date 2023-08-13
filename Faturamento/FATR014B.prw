#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR014B
//Objetivo: Relatório de Fechamento do Mês - COLETORES -  Ano XXXX
//			Emitir relatório das vendas por representante e enviar por e-mail
//          para os gerentes contendo seus respectivos supervisores 
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 05/11/2010
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR014B()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. de Fechamento do Mes. "
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
Private nomeprog     := "FATR014B" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR014B" // Coloque aqui o nome do arquivo usado para impressao em disco
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
Private cNomeRepre  := ""
Private aRepre		:= {}
Private aSuper		:= {}
Private aDadG		:= {}

Private cSuper		:= ""
Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private aGeren		:= {}
Private cGeren		:= ""
Private cNomeGeren	:= ""
Private cMailGeren	:= ""
//SetPrvt("OHTML,OPROCESS")
Private lUltimo		:= .F.
Private nLin		:= 80
Private nLinhas		:= 80



//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dData2 := Ctod("31/10/2010")
dData2 := GETMV("RV_ULT14B")  
//msgbox("Data limite: " + dtoc(dData2) )             

dData1 := dData2 - 90	// - 180

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Fechamento (Vendas de COLETORES) do Mes (p/ Gerentes)  -  " + cStrAno + ""


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

//Cabec1         := "COORDENADOR         |   META MENSAL            |    "+ cMes1 + cAnoM1 + "            |    "+ cMes2 + cAnoM2 + "            |   "+ cMes3 + cAnoM3 + "             |   "+ cMes4 + cAnoM4 + "             |     "+ cMes5 + cAnoM5 + "           |  "+ cMes6 + cAnoM6 + ""
//Cabec2		   := "                    |    R$        KG          |    R$         KG           |  R$           KG           | R$          KG             |   R$        KG             |  R$            KG          |     R$            KG "

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

Local nTotMedia:= 0

Local nCartR   := 0
Local nCartK   := 0

Local nTotCartR:= 0
Local nTotCartK:= 0

Local nTotMetaR := 0
Local nTotMetaK := 0

Local nMedia	:= 0

Local aDadGer	:= {}



cQuery := " SELECT ROUND(SUM(C6_QTDVEN),2) AS QTDE , " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR " +LF
cQuery += " ,C5_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ,C5_EMISSAO, " +LF

//--AQUI OS SUPERVISORES
cQuery += " SUPER =(SELECT A3_SUPER FROM SA3010 SA3 WHERE A3_COD = C5_VEND1 and SA3.D_E_L_E_T_ != '*') " +LF
cQuery += " FROM " +LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " +LF
//cQuery += " --SA3010 SA3 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " +LF

cQuery += " WHERE " +LF
cQuery += " C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND C5_TIPO = 'N' " + LF 
cQuery += " AND " +LF
cQuery += " RTRIM(B1_TIPO) <> 'AP' " +LF
//cQuery += " AND " +LF
//cQuery += " RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND " +LF
cQuery += " C6_PRODUTO = B1_COD " +LF

cQuery += " AND C6_TES = F4_CODIGO " + LF
cQuery += " AND F4_DUPLIC = 'S' " + LF

cQuery += " AND " +LF
cQuery += " RTRIM(SB1.B1_SETOR) = '39' " +LF		//SOMENTE CAIXAS

cQuery += " AND " +LF
cQuery += " SB1.B1_TIPO = 'PA' "+LF

cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND " +LF
cQuery += " C6_NUM = C5_NUM " +LF

cQuery += " AND " +LF
cQuery += " C6_CLI = C5_CLIENTE " +LF

cQuery += " AND " +LF
cQuery += " C6_LOJA = C5_LOJACLI " +LF

cQuery += " AND " +LF
cQuery += " C5_CLIENTE = A1_COD " +LF

cQuery += " AND " +LF
cQuery += " C5_LOJACLI = A1_LOJA " +LF

//cQuery += " -- AQUI O PULO DO GATO " +LF
cQuery += " AND " +LF
cQuery += " C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 " +LF
cQuery += " WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE RTRIM(A3_GEREN) ='0249' and SA3.D_E_L_E_T_ != '*' ) " +LF
cQuery += " and SA3.D_E_L_E_T_ != '*' ) " +LF

cQuery += " AND " +LF
cQuery += " SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' " +LF
//cQuery += " --AND SA3.A3_FILIAL = ' ' AND SA3.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = '' " +LF

cQuery += " GROUP " +LF
cQuery += " BY C5_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO " +LF
cQuery += " ORDER " +LF
cQuery += " BY SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO " +LF
//MemoWrite("C:\Temp\fatr014B.sql", cQuery )

TCQUERY cQuery NEW ALIAS "DIR12"

TCSetField( "DIR12", "C5_EMISSAO", "D")


DIR12->( DbGoTop() )

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

While DIR12->( !EOF() )

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

    cSuper		:= DIR12->SUPER 
	cNomeSuper  := ""
	cGeren		:= ""
	cNomeGeren	:= ""
	
	nMedia		:= 0
			
	////LOCALIZA O GER. ASSOCIADO A ESTE COORDENADOR
	cQry := " SELECT S.A3_COD CODSUP, S.A3_SUPER , S.A3_GEREN AS CODGEREN, S.A3_NOME AS NOMESUP, S.A3_ATIVO, "  + LF
	cQry += " G.A3_COD AS CODGEREN, G.A3_SUPER, G.A3_GEREN, G.A3_NOME AS NOMEGEREN, G.A3_ATIVO " + LF
	cQry += " FROM SA3010 S, SA3010 G " + LF
	cQry += " WHERE S.A3_GEREN = G.A3_COD " + LF
	cQry += " AND RTRIM(S.A3_COD) = '" + Alltrim(cSuper) + "' " + LF
	cQry += " AND G.A3_GEREN = '' AND G.A3_SUPER = '' " + LF
	cQry += " AND S.D_E_L_E_T_ = '' " + LF
	cQry += " AND G.D_E_L_E_T_ = '' " + LF
	cQry += " ORDER BY S.A3_GEREN, S.A3_COD " + LF
	//MemoWrite("\TempQry\SG12b.sql" , cQry )
	If Select("GEREN") > 0
		DbSelectArea("GEREN")
		DbCloseArea()
	EndIf
	TCQUERY cQry NEW ALIAS "GEREN"			
	GEREN->( DbGoTop() )			
	If !GEREN->(EOF())
		While GEREN->( !EOF() )
			cNomeSuper  := GEREN->NOMESUP
			cGeren		:= GEREN->CODGEREN
			cNomeGeren  := GEREN->NOMEGEREN
			GEREN->(DBSKIP())
		Enddo
	Else
		//cGeren := ""    
	   	cGeren := '0249  '      ///se não houver gerente para este coordenador, assume o ger. 0249 - Sr. Viana
	   	cNomeGeren := 'RAIMUNDO VIANA DE ASSIS'
	   	SA3->(Dbsetorder(1))
    	SA3->(Dbseek(xFilial("SA3") + cSuper ))
    	cNomeSuper := Alltrim(SA3->A3_NOME)
        	
    Endif
 
    ////ACUMULA O TOTAL DE VENDAS POR COORDENADOR
	Do While Alltrim(DIR12->SUPER) == Alltrim(cSuper)
		Do Case
			Case Month( DIR12->C5_EMISSAO ) = nMes1
				nTotVM1 += DIR12->VALOR
				nTotPM1 += DIR12->QTDE
			Case Month( DIR12->C5_EMISSAO ) = nMes2
				nTotVM2 += DIR12->VALOR
				nTotPM2 += DIR12->QTDE
			Case Month( DIR12->C5_EMISSAO ) = nMes3
				nTotVM3 += DIR12->VALOR
				nTotPM3 += DIR12->QTDE
			/*
			Case Month( DIR12->C5_EMISSAO ) = nMes4
				nTotVM4 += DIR12->VALOR
				nTotPM4 += DIR12->PESO
			Case Month( DIR12->C5_EMISSAO ) = nMes5
				nTotVM5 += DIR12->VALOR
				nTotPM5 += DIR12->PESO  
			Case Month( DIR12->C5_EMISSAO ) = nMes6
				nTotVM6 += DIR12->VALOR
				nTotPM6 += DIR12->PESO
			*/
		Endcase
		DIR12->(DBSKIP())	
	Enddo 
	
	nMedia := ( nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4 + nTotVM5 + nTotVM6) / 6
	                                                               
 	Aadd(aDadGer, { cSuper, cNomeSuper , cGeren, cNomeGeren , ;
   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
   					nTotVM4, nTotPM4, nTotVM5, nTotPM5, nTotVM6, nTotPM6, nMedia } )
   					
	
Enddo
DIR12->( DbCloseArea() )

aDadG := Asort( aDadGer,,, { |X,Y| X[3] + Transform(X[17],"@E 99,999,999.99") <  Y[3] + Transform(Y[17] ,"@E 99,999,999.99") } ) 

////////////////////



nPag		:= 1
nLin		:= 80        
cWeb		:= ""
cSuper  	:= ""
cMailSuper	:= ""
cNomeSuper	:= ""
cGeren		:= ""
cNomeGeren	:= ""
cMailGeren	:= ""

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

nTotMedia	:= 0

nTotMetaR	:= 0
nTotMetaK	:= 0 

nTotCartR	:= 0
nTotCartK	:= 0


nCta := 1

If Len(aDadG) > 0
	Do While nCta <= Len(aDadG)		
	
		nMetaR := 0
		nMetaK := 0
					
		nCartR:= 0	///totais de pedidos em carteira
		nCartK:= 0
		
		lEhGeren := .F.
		cGeren := aDadG[nCta,3]
		cNomeGeren := aDadG[nCta,4]
		////////////////////////////////////////////////
	    /////testa o registro corrente se é um gerente
	    ///////////////////////////////////////////////
		cQry := ""
		cQry := "Select A3_COD, A3_SUPER, A3_GEREN, A3_NOME, A3_ATIVO, A3_EMAIL, * "+LF
		cQry += "From " + RetSqlName("SA3") + " SA3 "+LF
		cQry += " Where RTRIM(A3_COD) = '" + Alltrim(cGeren) + "' "+LF
		cQry += " and A3_GEREN = '' AND A3_SUPER = '' "+LF
		cQry += " and RTRIM(A3_ATIVO) = 'S' "+LF
		cQry += " and SA3.D_E_L_E_T_ = '' "+LF
		//MemoWrite("\TempQry\Geren12B2.sql", cQry )
		If Select("GEREN") > 0
			DbSelectArea("GEREN")
			DbCloseArea()
		EndIf			
		TCQUERY cQry NEW ALIAS "GEREN"			
		GEREN->( DbGoTop() )			
	    If !GEREN->(EOF())
			While GEREN->( !EOF() )
				lEhGeren := .T.
				cMailGeren := GEREN->A3_EMAIL     
				GEREN->(DBSKIP())
			Enddo
	    Else
	    	lEhGeren := .F.
	       	//cGeren := '0249  '
	       	//cNomeGeren := 'RAIMUNDO VIANA DE ASSIS'            
	    Endif
	  //////////////////////////////////////////////////          
	  ///se for Gerente, faz a rotina abaixo, 
	  ///senão, passa para o próximo registro do array		
	  /////////////////////////////////////////////////
	  If lEhGeren
	  		///////////////////////////////////////////////////////////////////	
			////Flávia -> 30/03/10
			////por enquanto, deverá ser enviado apenas para Sr. Viana
			////depois, qdo corrigirem os cadastros, haverá apenas um gerente
			///e é no email deste, que será enviado este html
			///////////////////////////////////////////////////////////////////
		
			//////////////////////////////////////////////// 
			////reinicializa a variável cWeb para 
			////guardar string do html para novo gerente
			////////////////////////////////////////////////			
			cWeb := ""
			
			//////////////////
			/////CRIA O HTML
			/////////////////
			cDirHTM  := "\Temp\"    
			cArqHTM  := "FATR014B" + Alltrim(cGeren) + ".HTM"    //relatório P/ Gerentes
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
						
			nLin++
			@nLin,000 PSAY "Gerente: " + Alltrim(cGeren) + "-" + Alltrim(cNomeGeren) PICTURE "@!"  ///código + nome gerente
			@nLin,075 PSAY "E-mail: " + cMailGeren
			nLin++
		
			cSuper := aDadG[nCta,1]
			cNomeSuper := aDadG[nCta,2]
						
				
			nPag := 1
			nLinhas := 80
								
			If nLinhas >= 35
				///Cabeçalho PÁGINA
				cWeb := ""
				cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html><head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR014B/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				cWeb += '</table></head>'+ LF 
						     
				////LINHA GERENTE E SUPERVISOR/COORDENADOR
				cWeb += '<table width="1300" border="0" style="font-size:11px;font-family:Arial">'
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Gerente:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cGeren) + "-" + Alltrim(cNomeGeren) + '</span></td></tr>'+LF  ///CÓDIGO + NOME GERENTE							
				cWeb += '</table>' + LF
						
				///Cabeçalho relatório
				cWeb += '<table width="1300" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>COORDENADOR</span></div></B></td>'+ LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META</span></div></b></td>'+ LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF				
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+ LF
				cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+ LF
				
				cWeb += '<tr>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
				cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '</strong></tr>'+ LF
				nLinhas := 1			
				nPag++
				
		    Endif			
						
			Do While nCta <= Len(aDadG)  .and. Alltrim(cGeren) == Alltrim(aDadG[nCta,3]) 	///faça enquanto o gerente atual é igual ao anterior	   	  	   
			
				cSuper		:= aDadG[nCta,1]
				cNomeSuper	:= Alltrim(aDadG[nCta,2])
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
				 	  
				  		///Cabeçalho PÁGINA
				   		//cWeb := ""
				   		cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
						cWeb += '<html><head>'+ LF
						cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
						cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
						cWeb += '<tr>    <td>'+ LF
						cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
						cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
						cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
						cWeb += '<tr>        <td>SIGA /FATR014B/v.P10</td>'+ LF
						cWeb += '<td align="center">' + titulo + '</td>'+ LF
						cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
						cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
						cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+LF
						cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
						cWeb += '</table></head>'+ LF
					
						///Cabeçalho relatório		         
						cWeb += '<table width="1300" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
						cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>COORDENADOR</span></div></B></td>'+ LF
						cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META</span></div></b></td>'+ LF
						cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
						cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
						cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
						//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
						//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
						//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+ LF
						cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
						cWeb += '<tr>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF
						cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
						cWeb += '</strong></tr>'+ LF
						nLinhas := 1
						nPag++			
						   
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
				//cQuery += " WHERE RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' "+LF 
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(cSuper) + "' "+LF 
				//cQuery += " AND A3_SUPER = Z7_REPRESE "+LF
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				cQuery += " AND RTRIM(Z7_TIPO) <> 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				//MemoWrite("\TempQry\12BMETA.sql", cQuery )
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
				While META->( !EOF() )
					//If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(Month(dDatabase),2) + Strzero(Year(dDatabase),4) )
					If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) )
						nMetaR += META->Z7_VALOR
						nMetaK += META->Z7_KILO
					Endif
					META->(Dbskip())
				Enddo
				
				/////COMEÇA A IMPRESSÃO...
				//@nLin,000 PSAY Alltrim(aDadG[nCta,1]) + "-" + SUBSTR(aDadG[nCta,2],1,12)	PICTURE "@!"      		//COORDENADOR
				//@nLin,020 PSAY nMetaR		PICTURE "@E 99,999,999.99" 		//R$  meta
				//@nLin,035 PSAY nMetaK		PICTURE "@E 9,999,999.99"     	//QTD  meta
				
				////mês 1
				//@nLin,049 PSAY aDadG[nCta,5]		PICTURE "@E 99,999,999.99"  		//R$
				//@nLin,064 PSAY aDadG[nCta,6]		PICTURE "@E 9,999,999.99"     	//QTD
				nTotVM1 += Round(aDadG[nCta,5],2)
				nTotPM1 += Round(aDadG[nCta,6],2)
								    				  	
				cWeb += '<td width="1000"><span class="style3">'+ Alltrim(aDadG[nCta,1]) + "-" + Alltrim(SUBSTR(aDadG[nCta,2],1,30)) + '</span></td>'+LF //COORDENADOR
				
				///meta
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(nMetaR, "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(nMetaK,"@E 9,999,999.99")+' </span></td>'+LF        //QTD
				nTotMetaR += nMetaR
				nTotMetaK += nMetaK
				
				nMetaR := 0
				nMetaK := 0
				///mês 1
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,5], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,6],"@E 9,999,999.99")+' </span></td>'+LF        //QTD
					
				////mês 2
				//@nLin,078 PSAY aDadG[nCta,7]	PICTURE "@E 99,999,999.99"
				//@nLin,093 PSAY aDadG[nCta,8]	PICTURE "@E 9,999,999.99"
				nTotVM2 += Round(aDadG[nCta,7],2)
				nTotPM2 += Round(aDadG[nCta,8],2)
							   
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,7], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,8],"@E 9,999,999.99")+' </span></td>'+LF        //QTD				
								
				////mês 3
				//@nLin,107 PSAY aDadG[nCta,9]	PICTURE "@E 99,999,999.99"
				//@nLin,122 PSAY aDadG[nCta,10]	PICTURE "@E 9,999,999.99"		
				nTotVM3 += Round(aDadG[nCta,9],2)
				nTotPM3 += Round(aDadG[nCta,10],2)
								    
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,9], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,10],"@E 9,999,999.99")+' </span></td>'+LF        //QTD
						
				////mês 4
				//@nLin,136 PSAY aDadG[nCta,11]	PICTURE "@E 99,999,999.99"
				//@nLin,151 PSAY aDadG[nCta,12]	PICTURE "@E 9,999,999.99"
				//nTotVM4 += Round(aDadG[nCta,11],2)
				//nTotPM4 += Round(aDadG[nCta,12],2)
							   
				//cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				//cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,12],"@E 9,999,999.99")+' </span></td>'+LF        //QTD
													
				////mês 5
				//@nLin,165 PSAY aDadG[nCta,13]	PICTURE "@E 99,999,999.99"
				//@nLin,180 PSAY aDadG[nCta,14]	PICTURE "@E 9,999,999.99"
				//nTotVM5 += Round(aDadG[nCta,13],2)
				//nTotPM5 += Round(aDadG[nCta,14],2)
								    
				//cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,13], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				//cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,14],"@E 9,999,999.99")+' </span></td>'+LF        //QTD
							
				////mês 6
				//@nLin,194 PSAY aDadG[nCta,15]		PICTURE "@E 99,999,999.99"		
				//@nLin,209 PSAY aDadG[nCta,16]		PICTURE "@E 9,999,999.99"		
						    
				//cWeb += '<td width="900" align="right"><span class="style3">'+Transform(aDadG[nCta,15],"@E 99,999,999.99") +'</span></td>'+LF 
				//cWeb += '<td width="900" align="right"><span class="style3">'+Transform(aDadG[nCta,16],"@E 9,999,999.99") +'</span></td>'+LF
				//nTotVM6 += Round(aDadG[nCta,15],2)
				//nTotPM6 += Round(aDadG[nCta,16],2)
				
				///Média
				cWeb += '<td width="900" align="right"><span class="style3">'+Transform(aDadG[nCta,17],"@E 99,999,999.99") +'</span></td>'+LF 
				nTotMedia += aDadG[nCta,17]
				
				cWeb += '</tr>'+LF
				nLin++		    
				nCta++	
				nLinhas++
			Enddo
			/*
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
			//@nLin,194 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
			//@nLin,209 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99")	   
			@nLin,194 PSAY TRANSFORM( nTotVM6,"@E 99,999,999.99")
			@nLin,209 PSAY TRANSFORM( nTotPM6,"@E 9,999,999.99")	   
			nLin++
			@nLin,00 PSAY Replicate("=",220)
			nLin++	
			*/	
			////TOTAIS VENDAS
			cWeb += '<td width="1500" align="left"><span class="style3"><b>Total.....:</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 9,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
			
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
	        
	        nTotMedia	:= 0
	        
	        nTotCartR	:= 0
	        nTotCartK	:= 0
			     
			/////FECHA A TABELA DO HTML
			cWeb += '</table><br>'
			//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
			//////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			nRet := 0
			//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //esta funcionou, OK
				
			//////SELECIONA O EMAIL DESTINATÁRIO (GERENTE)
			cMailTo := cMailGeren + ";marcos@ravaembalagens.com.br"
			//cMailTo := "flavia.rocha@ravaembalagens.com.br"  
			cCopia  := "flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
			//////ENVIA O HTML COMO ANEXO			
			U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
			
	  Else
	  	nCta++
	  Endif
	  	
	Enddo

//Else
	//MSGBOX("Array Vazio!")
Endif


//////////////FIM DO GERA PARA GERENTES


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//MSGINFO("FATR014B - Processo finalizado")


dDTPar := LastDay(dDatabase)
PutMV("RV_ULT14B", dDTPar )
//msgbox("Nova Data limite: " + dtoc( dDTPar) )

// Habilitar somente para Schedule
Reset environment


Return
