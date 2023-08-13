#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR023
//Objetivo: Relatório 02 - Venda de Caixas por Representantes
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 07/01/2011  
//AGENDAMENTO: Mensal, todo 1o. dia útil do mês - TODOS COORDENADORES
//AGENDAMENTO: Semanal para Flavia Leite, toda 2a. feira
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR023CX()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	f23()	//chama a função do relatório
  
Else
  //conOut( "Programa WFFAT006 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  lDentroSiga := .T.
  f23()
  
EndIf
  

Return


**********************
Static Function f23()
**********************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. 02 - Venda de Caixas por Representantes."
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
Private nomeprog     := "FATR023CX" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR023CX" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR023" //"FTR012"
Private cString := ""

Private dData		:= Ctod("  /  /    ")
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
Private nMediaTotal := 0
Private nParticip	:= 0
Private nParticTot	:= 0
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



//dData2 := GETMV("RV_ULT12C")  
//dData2 := Lastday(dDatabase)
//dData1 := dData2 - 90		//-> 3 meses


cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

titulo := "Relatorio 02 - "
titulo += "VENDA DE CAIXAS POR REPRESENTANTES"


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
	
	//nMes4 := aMeses[nPosMes]	      //1
	//nMes3 := aMeses[nPosMes + 11]     //12
	//nMes2 := aMeses[nPosMes + 10 ]     //11
	//nMes1 := aMeses[nPosMes + 9 ]     //10  
	
	nMes3 := aMeses[nPosMes]	      //1
	nMes2 := aMeses[nPosMes + 11]     //12
	nMes1 := aMeses[nPosMes + 10]     //11

		
	//cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10 
	//cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	//dez/09
	//cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//nov/09
	//cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//out/09
	//cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//set/09
	//cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)		//ago/09
	
	//cAnoM4 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	// /10     // exibe: barra + ano com 2 digitos
	//cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	// /09 
	//cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	// /09
	//cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	// /09
	

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ) ,3,2)  	// /10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	// /09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	// /09
		
	//cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//jan/10     
	//cAnoMe5 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	//cAnoMe4 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	//cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//out/09
	//cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	//cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	
	//cAnoMe4 	:= StrZero( Year(dData2), 4 )    	//jan/10     //2010      // exibe o ano com 4 dígitos
	//cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 )  	//dez/09     //2009
	//cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09     //2009
	//cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//out/09     //2009
	
	cAnoMe3 	:= StrZero( Year(dData2), 4 )    	//jan/10     //2010      // exibe o ano com 4 dígitos
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )  	//dez/09     //2009
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09     //2009
	

Elseif nPosMes = 2   //se for Fevereiro
//dez, jan, fev
	/*
	nMes4 := aMeses[nPosMes]         //2
	nMes3 := aMeses[nPosMes - 1 ]    //1
	nMes2 := aMeses[nPosMes + 10]    //12
	nMes1 := aMeses[nPosMes + 9 ]    //11

	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		// /10	// exibe: barra + ano com 2 digitos
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		// /10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	// /09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	// /09
                                                   
	cAnoMe4 	:= StrZero( Year(dData2), 4 )    	//fev/10	// 2010      // exibe o ano com 4 dígitos
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//jan/10    // 2010
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09    // 2009
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09    // 2009
    */
    
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
Elseif (nPosMes >=3) // (nPosMes = 3 )	// se = Março
	/*
	nMes4 := aMeses[nPosMes]          //3
	nMes3 := aMeses[nPosMes - 1 ]     //2
	nMes2 := aMeses[nPosMes - 2 ]     //1
	nMes1 := aMeses[nPosMes + 9 ]     //12

	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		//mar/10	// /10  	// exibe: barra + ano com 2 digitos
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//fev/10	// /10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//jan/10	// /10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ),3,2) 	//dez/09	// /09

	cAnoMe4 	:= StrZero( Year(dData2) , 4 )    	//mar/10		//2010		// exibe o ano com 4 dígitos
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//fev/10		//2010
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//jan/10		//2010	
	cAnoMe1 	:= StrZero( Year(dData2) - 1 , 4 )	//dez/09		//2009	
    */
    
    nMes3 := aMeses[nPosMes]          //3
	nMes2 := aMeses[nPosMes - 1 ]     //2
	nMes1 := aMeses[nPosMes - 2 ]     //1

	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    		//mar/10	// /10  	// exibe: barra + ano com 2 digitos
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//fev/10	// /10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//jan/10	// /10

	cAnoMe3 	:= StrZero( Year(dData2) , 4 )    	//mar/10		//2010		// exibe o ano com 4 dígitos
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//fev/10		//2010
	cAnoMe1 	:= StrZero( Year(dData2) , 4 ) 		//jan/10		//2010	

/*    
//Elseif (nPosMes >= 4 )	// se >= Abril até Dezembro
	
	nMes4 := aMeses[nPosMes]          //4
	nMes3 := aMeses[nPosMes - 1 ]     //3
	nMes2 := aMeses[nPosMes - 2 ]     //2
	nMes1 := aMeses[nPosMes - 3 ]     //1

	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)   		//abr/10	// /10		// exibe: barra + ano com 2 digitos
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//mar/10	// /10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 		//fev/10	// /10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)   		//jan/10	// /10

	cAnoMe4 	:= StrZero( Year(dData2) , 4 )    	//abr/10		//2010		// exibe o ano com 4 dígitos
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//mar/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//fev/10	
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )		//jan/10	
    */
    
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


If lDentroSiga

	//se for pelo menu Siga, mostra tela de confirmação da impressão
	Pergunte("FATR023",.T.)    //INFORME O COORDENADOR
	/*
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)	
	nTipo := If(aReturn[4]== 1,15,18)
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório 02 ? " )
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)      
	Endif

Else
	//se for pelo Schedule
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery:=''
Local cQuery2 := ""
Local nQTD:=0 
Local aDados 	:= {}
Local aDadSuper := {}
Local aDadAux	:= {}
Local aDadSS	:= {}

Local nTotPM1 := 0
Local nTotPM2 := 0   
Local nTotPM3 := 0
Local nTotPM4 := 0
Local nTotPM5 := 0
Local nTotPM6 := 0
Local nMedia  := 0
Local nMediaKG:= 0
Local nTotMedia:= 0
Local nTotMedKG:= 0
Local nPorcMedia:= 0
Local nTotPorc  := 0
Local nMediaSMeta:= 0
   
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
Local nRegTot	:= 0
Local nTotMedMet:= 0
Local nDiaSemana := 0
Local lEhSegunda := .F.
Local aMetas	 := {}




Private cSuper		:= ""
Private cNomeSuper 	:= ""
Private cGeren		:= ""
Private cNomeGeren 	:= "" 

////VERIFICA O DIA DA SEMANA, SE FOR UMA 2A. FEIRA FAZ O ENVIO PARA FLÁVIA LEITE
nDiaSemana := DOW( dDatabase )
If nDiaSemana = 2
	lEhSegunda := .T.
Endif

cQuery := " SELECT ROUND(SUM(C6_QTDVEN),2) AS QTDCX ," + LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR , A3_GEREN " + LF
cQuery += " , C5_VEND1 " + LF
cQuery += " , C5VEND1 = CASE WHEN C5_VEND1 LIKE ('%VD') THEN LEFT(C5_VEND1,4) ELSE C5_VEND1 END " + LF

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

cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF    //
cQuery += " AND C6_FILIAL = C5_FILIAL "+LF 

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

cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' "+LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_NUM = C5_NUM      "+LF

cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF

cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF

cQuery += " AND C5_VEND1 = A3_COD "+LF
//cQuery += " AND A1_VEND = A3_COD " + LF    //existem pedidos em que o C5_VEND1 está diferente do A1_VEND

If lDentroSiga
	cQuery += " AND ( RTRIM(A3_SUPER) = '" + Alltrim(mv_par01) + "'  or RTRIM(C5_VEND1) = '" + Alltrim(mv_par01) + "'  ) " + LF    //qdo quiser tirar de um supervisor específico, habilitar essa linha
Elseif lEhSegunda
	cQuery += " AND A3_SUPER = '0255' " + LF
Endif

///NÃO IMPRIMIR REPRESENTANTES INATIVOS
cQuery += " AND RTRIM(A3_ATIVO) <> 'N' " + LF
cQuery += " AND A3_COD NOT IN ('0248', '0245' ) " + LF    //FR - Solicitado por Janderley, em 04/07/11 retirar o código de vendedor dele do relatório
                                                  		  //FR - Solicitado por Fulgêncio, em 18/07/11 retirar o código de vendedor dele do relatório

cQuery += " GROUP BY C5_VEND1, C5_CLIENTE, C5_LOJACLI, A3_NOME, A3_EST, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO, C5_TIPOCLI " + LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI "+LF
//MemoWrite("C:\Temp\FATR023.sql", cQuery )

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

	cCodRepre := SUP12->C5VEND1
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
		cSuper := SUP12->C5VEND1
		cNomeSuper := SUP12->A3_NOME
	Endif
	 	 	
	//Do While ( Alltrim(SUP12->C5_VEND1) = Alltrim(cCodRepre) .or. Alltrim(SUP12->C5_VEND1) = Alltrim(cCodRepre + "VD") )
	Do While ( Alltrim(SUP12->C5VEND1) = Alltrim(cCodRepre) .or. Alltrim(SUP12->C5VEND1) $ Alltrim(cCodRepre + "VD") )
	
		Do Case
			Case Month( SUP12->C5_EMISSAO ) = nMes1			
			    nTotVM1 += SUP12->VALOR
			    nTotPM1 += SUP12->QTDCX
			Case Month( SUP12->C5_EMISSAO ) = nMes2
			   	nTotVM2 += SUP12->VALOR
			    nTotPM2 += SUP12->QTDCX
			Case Month( SUP12->C5_EMISSAO ) = nMes3
			    nTotVM3 += SUP12->VALOR
			    nTotPM3 += SUP12->QTDCX			    
  			/*			
			Case Month( SUP12->C5_EMISSAO ) = nMes4
			    nTotVM4 += SUP12->VALOR
			    nTotPM4 += SUP12->PESO		
		    */
		Endcase
		nRegTot++	           	
		SUP12->(Dbskip())
	Enddo
	nMedia := ( nTotVM1 + nTotVM2 + nTotVM3) / 3				 
	nMediaKG := ( nTotPM1 + nTotPM2 + nTotPM3) / 3
	nPorcMedia	:= Round( (nTotPM3 / nMediaKG) * 100 , 0 )

		Aadd(aDadSS, { cCodRepre,;		//1
						cNomeRepre,;    //2
						cSuper,;        //3
						cNomeSuper,;    //4
					 	nTotVM1,;       //5
					 	nTotPM1,;       //6
					 	nTotVM2,;       //7
					 	nTotPM2,;       //8
					 	nTotVM3,;       //9
					 	nTotPM3,;       //10
					 	nTotVM4,;       //11
					 	nTotPM4,;       //12
					 	nTotVM5,;       //13
					 	nTotPM5,;       //14
					 	nTotVM6,;       //15
					 	nTotPM6,;       //16
					 	cUFRepre,;      //17
					 	nMedia,;        //18
					 	cAtivo,;        //19
					 	cTipoCli,; 		//20 		
					 	nMediaKG,;  	//21
					 	nPorcMedia } )  //22
	 		

Enddo

aDadSuper := Asort( aDadSS,,, { |X,Y| X[3] + Transform(X[21],"@E 99,999,999.99")  <  Y[3] + Transform(Y[21] ,"@E 99,999,999.99") } ) 
aDadAux   := Asort( aDadSS,,, { |X,Y| X[3] + Transform(X[21],"@E 99,999,999.99")  <  Y[3] + Transform(Y[21] ,"@E 99,999,999.99") } ) 

//For nAux := 1 to Len(aDadSuper)
//	nMediaTotal += aDadSuper[nAux,21]
//Next
								 
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
nTotMedKG := 0
nTotPorc  := 0
		   
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
nTotMedMet:= 0
nPassou	:= 0
cRepre	:= ""

////VERIFICA O DIA DA SEMANA, SE FOR UMA 2A. FEIRA FAZ O ENVIO PARA FLÁVIA LEITE
nDiaSemana := DOW( dDatabase )
If nDiaSemana = 2
	lEhSegunda := .T.
Endif

If Len(aDadSuper) > 0
	If lDentroSiga
		SetRegua( nRegTot )	
	Endif
	
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
		
		nMediaTotal := 0
	 	For nAux := 1 to Len(aDadSuper)
	 		If Alltrim(aDadSuper[nAux,3]) = Alltrim(cSuper)
				nMediaTotal += aDadSuper[nAux,21]
			Endif
		Next
		
		cWeb := ""
		nLinhas := 80
		/////CRIA O HTML
		cDirHTM  := "\Temp\"    
		cArqHTM  := "REL02_" + Alltrim(cSuper) + "_CX.HTM"    //relatório P/ SUPERVISORES
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
		
		cWeb := ""
		cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
	   	////div para quebrar página automaticamente
		cWeb += '<style type="text/css">'+LF
		cWeb += '.quebra_pagina {'+LF
		cWeb += 'page-break-after:always;'+LF
		cWeb += 'font-size:12px;'+LF
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
			//cWeb := ""
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR023/v.P10</td>'+ LF
			cWeb += '<td align="left">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF      
				      
			/////NOME DO SUPERVISOR RESPONSÁVEL	
			cWeb += '<table width="1500" border="0" style="font-size:13px;font-family:Arial">'
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailSuper) + '</span></td></tr>'+LF
			cWeb += '</table>' + LF
			/////
			
			///Cabeçalho relatório
			cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="510" font-family: Arial><div align="center"><span class="style3" style="font-size:13px"><B>REPRESENTANTE</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF
			
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
			
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
			
			cWeb += '<td><div align="center"><span class="style3"><b>% DA MEDIA(QTD) Sobre a META(QTD)</span></div></b></td>'+LF						
			
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MES ATUAL ' + LF + Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
			/// % do mês atual (3) sobre a média
			cWeb += '<td><div align="center"><Font-size="12px"><b>% DE ' + Alltrim(cMes3) + cAnoM3 + ' Sobre a MEDIA(QTD)</font></div></b></td>'+LF						
			/// % da média kg sobre a média total
			cWeb += '<td><div align="center"><Font-size="12px"><b>% PARTICIPACAO MEDIA(QTD) EM RELACAO A MEDIA TOTAL(QTD)</font></div></b></td>'+LF						
			
			cWeb += '<tr>'+ LF
			
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //KG COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS 1 R$
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 1 KG
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//MÊS 2 R$
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 2 KG
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS 3 R$
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 3 KG
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MEDIA R$
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MEDIA KG
			cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF	//% MEDIA SOBRE META
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS ATUAL R$
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF        //MÊS ATUAL KG
			
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        // % DO MÊS ATUAL S/MÉDIA KG
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        // % PARTICIPAÇÃO DA MÉDIA EM REL. A MEDIA TOTAL
			
			cWeb += '</strong></tr><br>'+ LF
		    nPag++
		    nLinhas := 5
		    
		    
		    
		Endif
			
	 
			
		   Do While nCta <= Len(aDadSuper)  .and. Alltrim(aDadSuper[nCta,3]) = Alltrim(cSuper)
		    
			   	
			   			   
			   If nLinhas >= 35	  
			   		///Cabeçalho html
			      	cWeb += '<div class="quebra_pagina"> </div>'+LF
      				
			      	cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
					cWeb += '<html><head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR023/v.P10</td>'+ LF
					cWeb += '<td align="left">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
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
					cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="510" font-family: Arial><div align="center"><span class="style3" style="font-size:13px"><B>REPRESENTANTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF
					
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
					
					cWeb += '<td><div align="center"><span class="style3"><b>% DA MEDIA Sobre a META</span></div></b></td>'+LF						
					
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MES ATUAL ' + LF + Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					cWeb += '<td><div align="center"><Font-size="12px"><b>% DE ' + Alltrim(cMes3) + cAnoM3 + ' Sobre a MEDIA(QTD)</font></div></b></td>'+LF						
					cWeb += '<td><div align="center"><Font-size="12px"><b>% PARTICIPACAO MEDIA(QTD) EM RELACAO A MEDIA TOTAL(QTD)</font></div></b></td>'+LF						
											
					cWeb += '<tr>'+ LF
					
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //KG COLUNA META MENSAL
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS 1 R$
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 1 KG
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//MÊS 2 R$
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 2 KG
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS 3 R$
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MÊS 3 KG
					
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MEDIA R$
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        //MEDIA KG
					
					cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF	//% MEDIA SOBRE META
					//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF        //MÊS ATUAL R$
					//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF        //MÊS ATUAL KG
					
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        // % DO MÊS ATUAL S/MÉDIA KG
					cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF        // % PARTICIPAÇÃO DA MÉDIA EM REL. A MEDIA TOTAL
					
					cWeb += '</strong></tr><br>'+ LF
									
					nPag++
					nLinhas := 5
			
			   Endif
			   
			 /////////////////////////////////////////////////////////////
			////TRAZ A META DO REPRESENTANTE DO COORDENADOR
			////////////////////////////////////////////////////////////
			aMetas := {}
			aMetas := TrazMeta( aDadSuper[nCta,1] , aDadSuper[nCta,3] ) 
			nMetaR := aMetas[1]
			nMetaK := aMetas[2]
			
						   					
			If !Alltrim(aDadSuper[nCta,1]) $ "0151/0153/0159/0194/0201"       //se não forem esses representantes...						 
			
				/////IMPRESSÃO DOS DADOS....								
				////representante
				cWeb += '<td width="1600"><span class="style3">'+ Alltrim(aDadSuper[nCta,1]) + "-" + Alltrim(SUBSTR( aDadSuper[nCta,2],1,20)) + " - " + Alltrim(aDadSuper[nCta,17]) +'</span></td>'+LF   //REPRESENTANTE
					
				////meta
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaR , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaK , "@E 999,999.99")+' </span></td>'+LF        //META KG
				
				///meses 1,2,3 r$ / kg
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,5],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,6],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,7],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,8],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,9],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,10],"@E 999,999.99")  + '</span></td>'+LF
					
				///Média
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadSuper[nCta,18] , "@E 9,999,999.99")+' </span></td>'+LF        //KG				
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadSuper[nCta,21] , "@E 9,999,999.99")+' </span></td>'+LF        //KG				
				
				//% Média sobre a Meta
				nMediaSMeta	:= Round( ( aDadSuper[nCta,21] / nMetaK) * 100 , 0 )
				cWeb += '<td width="300" align="right"><span class="style3">'+Transform( nMediaSMeta,"@E 9999") + "%" + '</span></td>'+LF  // % MEDIA KG / sobre a Meta
					
				///mês atual r$ / kg
				//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,11],"@E 9,999,999.99")+ '</span></td>'+LF
				//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,12],"@E 999,999.99")  + '</span></td>'+LF
					
				/// % mês atual (3) s/ media kg
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadSuper[nCta,22],"@E 9999")+ "%" +'</span></td>'+LF
				
				/// % de participação da média em relação a média total
				nParticip := Round( (aDadSuper[nCta,21] / nMediaTotal) * 100, 0 )
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( Round(nParticip,0),"@E 9999")+ "%" +'</span></td>'+LF
				nParticTot += nParticip					
									
				cWeb += '</tr>'+LF				
					
			    ////ACUMULADORES PARA O TOTAL NO FINAL
				nTotMetaR += nMetaR 
				nTotMetaK += nMetaK
				
				nTotVM1 += Round( aDadSuper[nCta,5], 2)   //totais valores / peso
				nTotPM1 += Round( aDadSuper[nCta,6], 2)
				nTotVM2 += Round(aDadSuper[nCta,7] , 2)
				nTotPM2 += Round(aDadSuper[nCta,8] , 2)
				nTotVM3 += Round(aDadSuper[nCta,9] , 2)
				nTotPM3 += Round(aDadSuper[nCta,10], 2)
				//nTotVM4 += Round(aDadSuper[nCta,11], 2)
				//nTotPM4 += Round(aDadSuper[nCta,12],2)			
				nTotMedia += Round(aDadSuper[nCta,18], 2)
				nTotMedKG += Round(aDadSuper[nCta,21], 2)				
			   
	         Endif
	         
	         		
	         
	         	nCta++
	        	nLinhas++
	        	If lDentroSiga
					IncRegua()	
				Endif       	 	
	       
	       Enddo
	       If Alltrim(cSuper) $ '0244/0245/0248'
	       //////////SUBTOTAL
	            		cWeb += '<td width="1600" align="left"><span class="style3"><b>SubTotal.....:</span></td>'+LF
						///meta r$ / kg
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF
						
						//meses 1,2,3 r$ / kg
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF
						
						//média r$ / kg
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 9,999,999.99")  + '</span></td>'+LF
						
						//% média s/ meta
						nMediaSMeta	:= Round( ( nTotMedKG / nTotMetaK) * 100 , 0 )
						cWeb += '<td width="900" align="right"><span class="style3"><b>'+Transform( nMediaSMeta,"@E 9999") + "%" + '</b></span></td>'+LF  // % MEDIA KG / sobre a Meta
						
						//mês atual r$ / kg
						//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
						//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
						
						// % mês atual (3) s/ média kg
						nTotPorc := (( nTotPM3 / nTotMedKG ) * 100)
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPorc,"@E 9999")  + "%" + '</span></td>'+LF
						
						///% de participação da média sobre o total da média (em kg)
						nParticTot := (( nTotMedKG / nMediaTotal ) * 100 )						
						/*
						If nParticTot <= 99 
							nParticTot := 100
						
						Elseif nParticTot > 100 
							msginfo("maior que 100")
							nParticTot := 100
						Endif
						*/
						cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( Round(nParticTot,0),"@E 9999")  + "%" + '</span></td>'+LF
											
						cWeb += '</tr>'+LF
						////linha em branco
						cWeb += '<td width="1600" height="20" colspan="16" align="left"><span class="style3"></span></td>'+LF
						cWeb += '</tr>'+LF
						
						//nPassou++	//para não fazer 2 vezes a linha "SUBTOTAL"			
	         		//////////SUBTOTAL
	       //Endif
	       
	       For nAux := 1 to Len(aDadAux)
	       		If Alltrim(aDadAux[nAux,1]) $ "0151/0153/0159/0194/0201" .and. Alltrim(aDadAux[nAux,3]) = Alltrim(cSuper)
	         	
	         		/////////////////////////////////////////////////////////////
					////TRAZ A META DO REPRESENTANTE DO COORDENADOR
					////////////////////////////////////////////////////////////
					aMetas := {}
					aMetas := TrazMeta( aDadSuper[nAux,1] , aDadSuper[nAux,3] ) 
					nMetaR := aMetas[1]
					nMetaK := aMetas[2]
					
	         	/////IMPRESSÃO DOS DADOS....								
				////representante
				cWeb += '<td width="1600"><span class="style3">'+ Alltrim(aDadSuper[nAux,1]) + "-" + Alltrim(SUBSTR( aDadAux[nAux,2],1,20)) + " - " + Alltrim(aDadSuper[nAux,17]) +'</span></td>'+LF   //REPRESENTANTE
					
				////meta
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaR , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( nMetaK , "@E 999,999.99")+' </span></td>'+LF        //META KG
				
				///meses 1,2,3 r$ / kg
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,5],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,6],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,7],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,8],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,9],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,10],"@E 999,999.99")  + '</span></td>'+LF
					
				///Média
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadAux[nAux,18] , "@E 9,999,999.99")+' </span></td>'+LF        //KG				
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform( aDadAux[nAux,21] , "@E 9,999,999.99")+' </span></td>'+LF        //KG				
				
				//% Média sobre a Meta
				nMediaSMeta	:= Round( ( aDadAux[nAux,21] / nMetaK) * 100 , 0 )
				cWeb += '<td width="300" align="right"><span class="style3">'+Transform( nMediaSMeta,"@E 9999") + "%" + '</span></td>'+LF  // % MEDIA KG / sobre a Meta
					
				///mês atual r$ / kg
				//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,11],"@E 9,999,999.99")+ '</span></td>'+LF
				//cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,12],"@E 999,999.99")  + '</span></td>'+LF
					
				/// % do mês atual (3) s/ media kg
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( aDadAux[nAux,22],"@E 9999")+ "%" +'</span></td>'+LF
				
				/// % participação da média sobre o total media kg
				nParticip := Round( (aDadAux[nAux,21] / nMediaTotal) * 100, 0 )
				cWeb += '<td width="300" align="right"><span class="style3">'+ TRANSFORM( nParticip,"@E 9999")+ "%" +'</span></td>'+LF
				//nParticTot += nParticip
					
									
				cWeb += '</tr>'+LF
				
				////ACUMULADORES PARA O TOTAL NO FINAL
				nTotMetaR += nMetaR 
				nTotMetaK += nMetaK
				
				nTotVM1 += Round( aDadAux[nAux,5], 2)   //totais valores / peso
				nTotPM1 += Round( aDadAux[nAux,6], 2)
				nTotVM2 += Round(aDadAux[nAux,7] , 2)
				nTotPM2 += Round(aDadAux[nAux,8] , 2)
				nTotVM3 += Round(aDadAux[nAux,9] , 2)
				nTotPM3 += Round(aDadAux[nAux,10], 2)
				nTotVM4 += Round(aDadAux[nAux,11], 2)
				nTotPM4 += Round(aDadAux[nAux,12],2)			
				nTotMedia += Round(aDadAux[nAux,18], 2)
				nTotMedKG += Round(aDadAux[nAux,21], 2)
				
	         	Endif  //endif da pergunta se são os repres:  "0151/0153/0159/0194/0201"
	       
	       
	       Next
	       Endif
	     	
			////TOTAIS VENDAS
			////linha em branco
			cWeb += '<td width="1600" height="20" colspan="16" align="left"><span class="style3"></span></td>'+LF
			cWeb += '</tr>'+LF
		
			cWeb += '<td width="1600" align="left"><span class="style3"><b>Total.....:</span></td>'+LF
			
			//meta r$ / kg
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF
			
			//meses 1,2,3 r$ / kg
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF
			
			//média r$ / kg
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 9,999,999.99")  + '</span></td>'+LF	
		
			nTotMedMet := (( nTotMedKG / nTotMetaK ) * 100)
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedMet,"@E 9999")  + "%" + '</span></td>'+LF    //% MÉDIA sobre META
			
			//mês atual r$ / kg
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
			
			// % do mês atual (3) sobre a MÉDIA KG
			nTotPorc := (( nTotPM3 / nTotMedKG ) * 100)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPorc,"@E 9999")  + "%" + '</span></td>'+LF		
			// % de participação da média sobre a média total (total geral da %)
			If nParticTot <= 99 
				nParticTot := 100
						
			Elseif nParticTot > 100 
				//msginfo("-maior que 100")
				nParticTot := 100
			Endif						
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( Round(nParticTot,0),"@E 9999")  + "%" + '</span></td>'+LF		
			
			cWeb += '</tr>'+LF
			
			//If nLinhas >= 35
				//If nCta > 1
					///Cabeçalho html
			      	//cWeb += '<div class="quebra_pagina"> </div>'+LF
			  	//Endif
			//Endif
			

			
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
	        nTotMedKG	:= 0
	        nTotPorc	:= 0
	        
	        /////FECHA A TABELA DO HTML
			cWeb += '</table><br>'
			
			
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
		    
			//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
	        
	        //////GRAVA O HTML 
	    	Fwrite( nHandle, cWeb, Len(cWeb) )
	    	cWeb := ""	    
		   			
			cWeb += '</body> '
			cWeb += '</html> '
			//////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			nRet := 0
			//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browser
			
			//////SELECIONA O EMAIL DESTINATÁRIO 		
			If lDentroSiga
			
				cCodUser := __CUSERID     
				//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo

				PswOrder(1)
				If PswSeek( cCoduser, .T. )
				   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
				   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
				   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
				   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
				Endif
				cCopia  := ""
			Else
				cMailTo := cMailSuper
				cCopia := "flavia.rocha@ravaembalagens.com.br"
				
				If Alltrim(cSuper) = '0229'
					cMailTo += ";janaina@ravaembalagens.com.br"				
				
				Elseif Alltrim(cSuper) = '0244'
					cMailTo += ";janaina@ravaembalagens.com.br"
					
				Elseif Alltrim(cSuper) = '0245'
					cMailTo += ";marcos@ravaembalagens.com.br"
				
				Elseif Alltrim(cSuper) = '0248'
					cMailTo += ";josenildo@ravaembalagens.com.br" 
					
				Elseif Alltrim(cSuper) = '0255'
					cMailTo += ";vendas.sp@ravaembalagens.com.br"
				Endif  
				
			Endif			
			
			cCorpo  := titulo  + " -   Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo 
			//////ENVIA O HTML COMO ANEXO
			
			If !lDentroSiga
				If Alltrim(cSuper) = '0255' .and. lEhSegunda
					U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 		
				Else
					U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 		
				Endif
			Else
				U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 		
			Endif

	Enddo

Endif


//////////////FIM DO GERA PARA SUPERVISORES
If lDentroSiga
	//MSGINFO("FATR023 - Processo finalizado") 
	MsgInfo("Rel 02 - Você recebeu um e-mail deste Relatório.")
Else
	// Habilitar somente para Schedule
	Reset environment
Endif


Return


**********************************************
Static Function TrazMeta(cVendedor, cSuper )
**********************************************
Local nMetaR := 0
Local nMetaK := 0
Local nConta := 0
Local nMetaR1 := 0
Local nMetaK1 := 0
Local aMetas  := {}
Local cQuery  := ""
		
If Alltrim(cVendedor) != Alltrim(cSuper)		//se o vendedor lido não é o próprio supervisor
	cQuery := ""
	cQuery := " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
	cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
	cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
	cQuery += " WHERE A3_COD = '" + Alltrim(cVendedor) + "' "+LF 
	cQuery += " AND A3_COD = Z7_REPRESE "+LF
	cQuery += " AND A3_SUPER = '" + Alltrim(cSuper) + "' " + LF
	cQuery += " AND RTRIM(Z7_TIPO) = 'SC' " + LF
	cQuery += " AND RTRIM(Z7_MESANO) = '" + Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) ) + "' " + LF
	cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
	cQuery += " AND SZ7.D_E_L_E_T_ = ''  "+LF
	cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
	cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				
	MemoWrite("C:\Temp\23META.sql", cQuery )
	If Select("META") > 0
		DbSelectArea("META")
		DbCloseArea()
	EndIf
	TCQUERY cQuery NEW ALIAS "META"
	META->( DbGoTop() )
	While META->( !EOF() )					
					
		nMetaR := META->Z7_VALOR
		nMetaK := META->Z7_KILO
			
		META->(Dbskip())
	Enddo		  
			
Else    //qdo o coordenador também é vendedor, a meta do coord. como vendedor = soma das metas dos vendedores / número vendedores + o coord.
		//ex: Flávia Leite possui 6 representantes sob sua coordenação, logo o total de vendedores com ela é 7.
	nMetaR1 := 0
	nMetaK1 := 0
	nMetaR  := 0
	nMetaK  := 0
	cQuery := ""
	cQuery := " SELECT A3_SUPER, Z7_VALOR, Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
	cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
	cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
	cQuery += " WHERE " + LF //A3_COD = '" + Alltrim(aDadSuper[nCta,1]) + "' "+LF 
	cQuery += " A3_COD = Z7_REPRESE "+LF
	cQuery += " AND A3_SUPER = '" + Alltrim(cSuper) + "' " + LF //or A3_COD = '" + Alltrim(aDadSuper[nCta,3]) + "' ) "+LF 
	cQuery += " AND RTRIM(Z7_TIPO) = 'SC' " + LF
	cQuery += " AND RTRIM(Z7_MESANO) = '" + Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) ) + "' " + LF
	cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
	cQuery += " AND SZ7.D_E_L_E_T_ = ''  "+LF
	//cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
	cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
				
	MemoWrite("C:\Temp\23META.sql", cQuery )
	If Select("META") > 0
		DbSelectArea("META")
		DbCloseArea()
	EndIf
	TCQUERY cQuery NEW ALIAS "META"
	META->( DbGoTop() )
	nConta := 0
	While META->( !EOF() )					
					
		nMetaR1 += META->Z7_VALOR
		nMetaK1 += META->Z7_KILO
		nConta++
		META->(Dbskip())
	Enddo
	nMetaR := nMetaR1 / (nConta )
	nMetaK := nMetaK1 / (nConta )
			
Endif

Aadd(aMetas, nMetaR )
Aadd(aMetas, nMetaK )

Return(aMetas)