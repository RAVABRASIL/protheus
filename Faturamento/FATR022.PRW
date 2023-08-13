#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//-----------------------------------------------------------------------------------------//
//Programa: FATR022                                                                        //
//Objetivo: Relatório 01 - Venda de Sacos por Coordenadores                                //
//			                                                                               //
//Autoria : Flávia Rocha                                                                   //
//Empresa : RAVA                                                                           //
//Data    : 23/11/2010                                                                     //
//Agendamento: mensal, 1o. dia útil do mês                                                 //
//Flávia Leite solicitou não receber mais em 08/09/11 - 12:03                              //
//Flávia Leite pediu de volta para receber, em 08/09/11 - 17:40                            //
//Revisão do agendamento e destinatários em 23/04/12 - conforme email de Flavia Viana      //
//FR - FLAVIA ROCHA - ALTERAÇÃO:                                                           //
//22/06/12 - Eurivan solicitou que:                                                        //
//deverá ser separado por meta: tambem deverá considerar hospitalar e indt/dom             //
//e as metas obedecendo o mesmo criterio                                                   //
                                                                                           //
//-----------------------------------------------------------------------------------------//
// 01/11/12 - Alteração solicitada por Flavia Viana:                                       //
// -> capturar pela nova regra: carteira imediata + faturado                               //
//-----------------------------------------------------------------------------------------//   
/*/


************************************
User Function FATR022()
************************************

Local nFam := 0
Local nLinha:= 0
Private lDentroSiga := .F.



/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f22( 1, 1 )		//família = sacos , linha = instituc. doméstica  	
  	Reset environment
  	
  	/////////////////////////////////////////////////////////////////////////////////  	
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f22( 1, 2 )		//família = sacos , linha = hospitalar
  	Reset environment 
  	
  	///////////////////////////////////////////////////////////////////////////////////
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f22( 1, 3 )		//família = sacos , linha = todas
  	Reset environment
  	
  	///////////////////////////////////////////////////////////////////////////////////
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	//f22( 2 , 1  )	//família = caixas , linha = instituc. doméstica
  	Reset environment
  	
  	///////////////////////////////////////////////////////////////////////////////////
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f22( 2 , 2  )	//família = caixas , linha = hospitalar 
  	Reset environment
  	
  	//////////////////////////////////////////////////////////////////////////////////
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	//f22( 2 , 3  )	//família = caixas , linha = todas
  	Reset environment
  	
  	
  
Else
  //conOut( "Programa WFFAT006 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  	lDentroSiga := .T.
	Pergunte("FATR022",.T.)    //INFORME A FAMÍLIA -> 1-SACOS / 2-CAIXAS
	nFam := mv_par01
	nLinha := MV_PAR02
	f22( nFam, nLinha )
 
  
EndIf
  

Return

**********************
Static Function f22( nFam, nLinha )
**********************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. 01 - Vendas por Coordenadores"
Local cPict          := ""
Local titulo         := "" 

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}

Local cCodUser		 := ""

Local dDTPar		 := Ctod("  /  /    ")
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR022" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR022" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "" //"FTR012"
Private cString := ""

Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")
Private aMeses		:= {}
Private aNomMeses	:= {}
Private nPosMes		:= 0
Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private cDir		:= ""
Private cArq		:= "" 
Private nHandle	    := 0
Private lDir		:= .F.
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
Private nMediaTotal := 0
Private nParticip	:= 0
Private nParticTot	:= 0
Private nMesData2
Private cAnoM1 := ""
Private cAnoM2 := ""
Private cAnoM3 := ""
Private cAnoM4 := ""
Private cAnoM5 := ""
Private cAnoM6 := ""
Private cMes6  := ""
Private cMes5  := ""
Private cMes4  := ""
Private cMes3  := ""
Private cMes2  := ""
Private cMes1  := ""


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
	//dData2 := Ctod("31/05/2011")
Endif
dData1 := dData2 - 90		//3 meses - Sr. Viana em 17/12/10 pediu para alterar novamente

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif
If nLinha = 1
	cLinha := "LINHA INST. / DOMESTICA"
Elseif nLinha = 2
	cLinha := "LINHA HOSPITALAR"
Else
	cLinha := "TODAS AS LINHAS"
Endif

titulo := "Relatorio 01 - "
If nFam = 1
	titulo += "VENDA DE SACOS POR COORDENADORES - " + cLinha
Elseif nFam = 2
	titulo += "VENDA DE CAIXAS POR COORDENADORES - " + cLinha
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
	/*
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)	
	nTipo := If(aReturn[4]== 1,15,18)
    */
    If MsgYesNo("Deseja Gerar o Relatório 01 ?")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, nFam, nLinha) },Titulo)      
	Endif

Else
	//se for pelo Schedule
	RunReport(Cabec1,Cabec2,Titulo,nLin, nFam, nLinha)

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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, nFam, nLinha)

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
Local nTotMedKG:= 0

Local nPorcMedia:= 0 
Local nPorcMeta := 0
Local nMediaSMeta:= 0
Local nTotPorc  := 0
Local nTotMedMet := 0

Local nCartR   := 0
Local nCartK   := 0

Local nTotCartR:= 0
Local nTotCartK:= 0

Local nTotMetaR := 0
Local nTotMetaK := 0

Local nMedia	:= 0
Local nMediaKG	:= 0

Local aDadGer	:= {}
Local nRegTot	:= 0
Local cMailTo	:= ""
Local cCopia	:= ""
Local cAssun	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Private mGer    := {}
/////////////////////
//query antiga
/*
cQuery := " SELECT " + LF
If nFam = 1
	cQuery += " ROUND(SUM(C6_QTDVEN * B1_PESO),2) AS PESO , " +LF
Elseif nFam = 2
	cQuery += " ROUND(SUM(C6_QTDVEN),2) AS PESO , " +LF
Endif
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR " +LF
cQuery += " ,C5_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ,C5_EMISSAO, C5_ENTREG, A3_GEREN" +LF

//--AQUI OS SUPERVISORES
//cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
//cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " ,SUPER = (CASE WHEN A3_GEREN <> '' THEN C5_VEND1 ELSE A3_SUPER END) " + LF

cQuery += " FROM " +LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK), " +LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " +LF 
cQuery += " " + RetSqlName("SC9") + " SC9 WITH (NOLOCK) " +LF

cQuery += " WHERE " +LF
cQuery += " C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND C5_TIPO = 'N' " + LF 
cQuery += " AND " +LF
cQuery += " (B1_TIPO) <> 'AP' " +LF
//cQuery += " AND " +LF
//cQuery += " (C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND " +LF
cQuery += " C6_PRODUTO = B1_COD " +LF

cQuery += " AND C6_TES = F4_CODIGO " + LF
cQuery += " AND F4_DUPLIC = 'S' " + LF

cQuery += " AND " +LF
If nFam = 1
	cQuery += " SB1.B1_SETOR <> '39' " +LF
Elseif nFam = 2
	cQuery += " SB1.B1_SETOR = '39' " +LF
Endif

cQuery += " AND " +LF
cQuery += " SB1.B1_TIPO = 'PA' "+LF

//verifica a linha:
if nLinha = 1
	//Grupo Linha Domestica
	cQuery += " AND SB1.B1_GRUPO IN ('A', 'B' , 'D', 'E' , 'F' , 'G' ) " + LF
elseif nLinha = 2  
	//Grupo Hospitalar
	cQuery += " AND SB1.B1_GRUPO IN ('C' ) " + LF
Endif

///COPIADO DO FATPFIV5:
cQuery += " and SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM " + LF
cQuery += " and SC9.C9_FILIAL = SC5.C5_FILIAL " + LF
// NOVA LIBERACAO DE CRETIDO
cQuery += " and SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' " + LF
///FIM DO FATPFIV5


cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND " +LF
cQuery += " C6_NUM = C5_NUM " +LF
cQuery += " AND " +LF
cQuery += " C6_FILIAL = C5_FILIAL " +LF

cQuery += " AND " +LF
cQuery += " C6_CLI = C5_CLIENTE " +LF

cQuery += " AND " +LF
cQuery += " C6_LOJA = C5_LOJACLI " +LF

cQuery += " AND " +LF
cQuery += " C5_CLIENTE = A1_COD " +LF

cQuery += " AND " +LF
cQuery += " C5_LOJACLI = A1_LOJA " +LF

//cQuery += " -- AQUI O PULO DO GATO " +LF
//cQuery += " AND " +LF
//cQuery += " C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 " +LF
//cQuery += " WHERE A3_ATIVO <> 'N' AND A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE (A3_GEREN) ='0249' and SA3.D_E_L_E_T_ != '*' ) " +LF
//cQuery += " and SA3.D_E_L_E_T_ != '*' ) " +LF

cQuery += " -- AQUI O PULO DO GATO para trazer as vendas dos próprios supervisores " +LF
cQuery += " AND " +LF
cQuery += " C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 " +LF
cQuery += " WHERE A3_ATIVO <> 'N' AND ( A3_SUPER <> '' or  A3_GEREN ='0249' ) " +LF
cQuery += " and SA3.D_E_L_E_T_ != '*' ) " +LF

cQuery += " AND C5_VEND1 = A3_COD " + LF      //deixar assim senão, não mostra as vendas em que o Coordenador é o C5_VEND1
cQuery += " AND A3_ATIVO <> 'N' " + LF                          
cQuery += " AND " +LF
//cQuery += " SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' " +LF
cQuery += " SC6.D_E_L_E_T_ = '' " +LF

cQuery += " AND " +LF
cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' " +LF

cQuery += " AND " + LF
cQuery += " SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' " +LF

cQuery += " AND " +LF
//cQuery += " SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' " +LF
cQuery += " AND " +LF
cQuery += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = '' " +LF

cQuery += " GROUP " +LF
cQuery += " BY C5_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, C5_ENTREG, A3_SUPER, A3_GEREN " +LF
cQuery += " ORDER " +LF
cQuery += " BY SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO " +LF
MemoWrite("C:\Temp\fatr022.sql", cQuery )
///////////////

TCQUERY cQuery NEW ALIAS "DIR12"

TCSetField( "DIR12", "C5_EMISSAO", "D")
TCSetField( "DIR12", "C5_ENTREG", "D")


DIR12->( DbGoTop() )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄgÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
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
	
	nPorcMedia:= 0    

    cSuper		:= DIR12->SUPER 
	cNomeSuper  := ""
	cGeren		:= ""
	cNomeGeren	:= ""
	
	nMedia		:= 0
	dImed1      := Ctod("  /  /    ")
	dImed2      := Ctod("  /  /    ")
			
	////LOCALIZA O GER. ASSOCIADO A ESTE COORDENADOR
	cQry := " SELECT S.A3_COD CODSUP, S.A3_SUPER , S.A3_GEREN AS CODGEREN, S.A3_NREDUZ AS NOMESUP, S.A3_ATIVO, "  + LF
	cQry += " G.A3_COD AS CODGEREN, G.A3_SUPER, G.A3_GEREN, G.A3_NOME AS NOMEGEREN, G.A3_ATIVO " + LF
	cQry += " FROM SA3010 S, SA3010 G " + LF
	cQry += " WHERE S.A3_GEREN = G.A3_COD " + LF
	cQry += " AND S.A3_COD = '" + Alltrim(cSuper) + "' " + LF
	cQry += " AND G.A3_GEREN = '' AND G.A3_SUPER = '' " + LF
	cQry += " AND S.D_E_L_E_T_ = '' " + LF
	cQry += " AND G.D_E_L_E_T_ = '' " + LF
	cQry += " ORDER BY S.A3_GEREN, S.A3_COD " + LF
	
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
    	cNomeSuper := Alltrim(SA3->A3_NREDUZ)
        	
    Endif
 
    ////ACUMULA O TOTAL DE VENDAS POR COORDENADOR
	Do While Alltrim(DIR12->SUPER) == Alltrim(cSuper)
		dImed1 := FirstDay(DIR12->C5_EMISSAO)
		dImed2 := LastDay(DIR12->C5_EMISSAO)			    
		Do Case
			Case Month( DIR12->C5_EMISSAO ) = nMes1
				//considerar somente Carteira imediata:
				If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
					nTotVM1 += DIR12->VALOR
					nTotPM1 += DIR12->PESO
				Endif
			Case Month( DIR12->C5_EMISSAO ) = nMes2
				//considerar somente Carteira imediata:
				If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
					nTotVM2 += DIR12->VALOR
					nTotPM2 += DIR12->PESO 
				Endif
			Case Month( DIR12->C5_EMISSAO ) = nMes3
				//considerar somente Carteira imediata:
				If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
					nTotVM3 += DIR12->VALOR
					nTotPM3 += DIR12->PESO 
				Endif	
				
		
		Endcase
		nRegTot++
		DIR12->(DBSKIP())	
	Enddo 
	
	nMedia 		:= 0 //( nTotVM1 + nTotVM2 + nTotVM3) / 3
	nMediaKG	:= 0 //( nTotPM1 + nTotPM2 + nTotPM3) / 3 
	nPorcMedia	:= 0 //Round( (nTotPM3 / nMediaKG) * 100 , 0 )      // % s/ média mensal
	
	nCtaSubiu	:= 0
	nCtaDesceu	:= 0
	nCtaNovo	:= 0
	nSaldo		:= 0
	
   	////Verifica QTOS CLIENTES NOVOS
	//nCtaNovo := U_EhCliNovo(cSuper)
		
	////verifica qtos clientes foram REATIVADOS
	//nCtaSubiu := U_fReativou(cSuper ) 
			
	////verifica qtos clientes foram INATIVADOS
	//nCtaDesceu := U_fInativou( cSuper )
			
	//nSaldo	:= ( (nCtaNovo + nCtaSubiu) - nCtaDesceu ) 


	                                                               
 	Aadd(aDadGer, { cSuper,;			//1
 					 cNomeSuper,;		//2
 					 cGeren,;			//3
 					 cNomeGeren,;		//4
   				     nTotVM1,;			//5
   				     nTotPM1,;			//6
   				     nTotVM2,;			//7
   				     nTotPM2,;			//8
   				     nTotVM3,;			//9
   				     nTotPM3,;			//10
   					 nTotVM4,;			//11
   					 nTotPM4,;			//12
   					 nTotVM5,;			//13
   					 nTotPM5,;			//14
   					 nTotVM6,;			//15
   					 nTotPM6,;			//16
   					 nMedia,;			//17
   					 nMediaKG,; 		//18
   					 nPorcMedia,;	    //19    /// % do mês atual sobre a média
   					 nCtaNovo,;         //20
   					 nCtaSubiu,;        //21
   					 nCtaDesceu,;       //22
   					 nSaldo } )         //23
	
Enddo
*/

////nova query
cQuery := " SELECT " + LF
cQuery += " A3_COD, A3_SUPER,  A3_GEREN" +LF
cQuery += " ,SUPER = (CASE WHEN A3_GEREN <> '' THEN A3_COD ELSE A3_SUPER END) " + LF
cQuery += " FROM " +LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " +LF
cQuery += " WHERE " +LF
cQuery += " A3_ATIVO <> 'N' " + LF                          
cQuery += " AND A3_GEREN <> '' " + LF

//cQuery += " AND A3_GEREN = '0249' " + LF  //RETIRAR

cQuery += " AND " + LF
cQuery += " SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' " +LF

//cQuery += " AND SA3.A3_COD = '0229' " + LF //TESTE
//cQuery += " AND SA3.A3_COD = '0244' " + LF //TESTE
//cQuery += " AND SA3.A3_COD = '0245' " + LF //TESTE
//cQuery += " AND SA3.A3_COD = '0306' " + LF //TESTE
//cQuery += " AND SA3.A3_COD = '0315' " + LF //TESTE
cQuery += " ORDER " +LF
cQuery += " BY A3_GEREN, A3_COD " +LF
MemoWrite("C:\Temp\fatr022.sql", cQuery )
///////////////

TCQUERY cQuery NEW ALIAS "DIR12"

DIR12->( DbGoTop() )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄgÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
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
	
	nPorcMedia:= 0    
	nPorcMeta := 0

    cSuper		:= DIR12->SUPER 
	cNomeSuper  := ""
	cGeren		:= ""
	cNomeGeren	:= ""
	
	nMedia		:= 0
	dImed1      := Ctod("  /  /    ")
	dImed2      := Ctod("  /  /    ")
			
	////LOCALIZA O GER. ASSOCIADO A ESTE COORDENADOR
	cQry := " SELECT S.A3_COD CODSUP, S.A3_SUPER , S.A3_GEREN AS CODGEREN, S.A3_NREDUZ AS NOMESUP, S.A3_ATIVO, "  + LF
	cQry += " G.A3_COD AS CODGEREN, G.A3_SUPER, G.A3_GEREN, G.A3_NOME AS NOMEGEREN, G.A3_ATIVO " + LF
	cQry += " FROM SA3010 S, SA3010 G " + LF
	cQry += " WHERE S.A3_GEREN = G.A3_COD " + LF
	cQry += " AND S.A3_COD = '" + Alltrim(cSuper) + "' " + LF
	cQry += " AND G.A3_GEREN = '' AND G.A3_SUPER = '' " + LF
	cQry += " AND S.D_E_L_E_T_ = '' " + LF
	cQry += " AND G.D_E_L_E_T_ = '' " + LF
	cQry += " ORDER BY S.A3_GEREN, S.A3_COD " + LF
	
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
    	cNomeSuper := Alltrim(SA3->A3_NREDUZ)
        	
    Endif
 
    ////ACUMULA O TOTAL DE VENDAS POR COORDENADOR
	Do While Alltrim(DIR12->SUPER) == Alltrim(cSuper)
		//dImed1 := FirstDay(DIR12->C5_EMISSAO)
		//dImed2 := LastDay(DIR12->C5_EMISSAO)			    
		//Do Case
			//Case Month( DIR12->C5_EMISSAO ) = nMes1
				//considerar somente Carteira imediata:
				//If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
				//	nTotVM1 += DIR12->VALOR
				//	nTotPM1 += DIR12->PESO
				//Endif
			//mes1
			//IF !lDentroSiga
			//	If Alltrim(cGeren) = '0256'
			//		nLinha := 2
			//	Endif
			//ENDIF
			
			dImed1 := Ctod("01/" + str(nMes1) +'/'+ Right(StrZero(Year(dData1),4),2) )
			dImed2 := LastDay(dImed1)
				
			nTotVM1 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 1, "S", cSuper, nFam, nLinha)	//linha 1 = instituc. doméstica
			nTotPM1 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 2, "S", cSuper, nFam, nLinha)   //linha 2 = hospitalar
			
			//mes2
			dImed1 := Ctod("01/" + str(nMes2) +'/'+ Right(StrZero(Year(dData1),4),2) )
			dImed2 := LastDay(dImed1)
				
			nTotVM2 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 1, "S", cSuper, nFam, nLinha)
			nTotPM2 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 2, "S", cSuper, nFam, nLinha) 
			
			//mes3
			dImed1 := Ctod("01/" + str(nMes3) +'/'+ Right(StrZero(Year(dData1),4),2) )
			dImed2 := LastDay(dImed1)
				
			nTotVM3 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 1, "S", cSuper, nFam, nLinha)
			nTotPM3 := U_pddMes(dImed1,dImed2, .T., dImed1, dImed2, 2, "S", cSuper, nFam, nLinha)   
			
			/*
			Case Month( DIR12->C5_EMISSAO ) = nMes2
				//considerar somente Carteira imediata:
				If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
					nTotVM2 += DIR12->VALOR
					nTotPM2 += DIR12->PESO 
				Endif
			Case Month( DIR12->C5_EMISSAO ) = nMes3
				//considerar somente Carteira imediata:
				If DIR12->C5_ENTREG >= dImed1 .and. DIR12->C5_ENTREG <= dImed2			    	
					nTotVM3 += DIR12->VALOR
					nTotPM3 += DIR12->PESO 
				Endif	
				
		
		Endcase
		*/
		nRegTot++
		DIR12->(DBSKIP())	
	Enddo 
	
	nMedia 		:= 0 //( nTotVM1 + nTotVM2 + nTotVM3) / 3
	nMediaKG	:= 0 //( nTotPM1 + nTotPM2 + nTotPM3) / 3 
	nPorcMedia	:= 0 //Round( (nTotPM3 / nMediaKG) * 100 , 0 )      // % s/ média mensal
	nPorcMeta   := 0 //% participação do mês corrente em relação à meta
	
	nCtaSubiu	:= 0
	nCtaDesceu	:= 0
	nCtaNovo	:= 0
	nSaldo		:= 0
	
   	////Verifica QTOS CLIENTES NOVOS
	//nCtaNovo := U_EhCliNovo(cSuper)
		
	////verifica qtos clientes foram REATIVADOS
	//nCtaSubiu := U_fReativou(cSuper ) 
			
	////verifica qtos clientes foram INATIVADOS
	//nCtaDesceu := U_fInativou( cSuper )
			
	//nSaldo	:= ( (nCtaNovo + nCtaSubiu) - nCtaDesceu ) 


	                                                               
 	Aadd(aDadGer, { cSuper,;			//1
 					 cNomeSuper,;		//2
 					 cGeren,;			//3
 					 cNomeGeren,;		//4
   				     nTotVM1,;			//5
   				     nTotPM1,;			//6
   				     nTotVM2,;			//7
   				     nTotPM2,;			//8
   				     nTotVM3,;			//9
   				     nTotPM3,;			//10
   					 nTotVM4,;			//11
   					 nTotPM4,;			//12
   					 nTotVM5,;			//13
   					 nTotPM5,;			//14
   					 nTotVM6,;			//15
   					 nTotPM6,;			//16
   					 nMedia,;			//17
   					 nMediaKG,; 		//18
   					 nPorcMedia,;	    //19    /// % do mês atual sobre a média
   					 nCtaNovo,;         //20
   					 nCtaSubiu,;        //21
   					 nCtaDesceu,;       //22
   					 nSaldo } )         //23
	
Enddo


////fim nova query / laço


DIR12->( DbCloseArea() )

//o LAÇO ABAIXO É PARA CAPTURAR O FATURADO EM CADA MÊS LIDO (MÊS 1, 2, 3 DA GRADE)
//COLOQUEI AQUI FORA, POIS, SE A QUERY NÃO TROUXER NENHUM RESULTADO, PELO MENOS O FATURADO VAI ALIMENTAR O ARRAY
dExec := Ctod("  /  /    ")
nVALFAT1:= 0
nKGFAT1 := 0
nVALFAT2:= 0
nKGFAT2 := 0
nVALFAT3:= 0
nKGFAT3 := 0
mm := 1
mSuper := ""
While mm <= Len(aDadGer)
	mSuper := aDadGer[mm,1]
	Do While mm <= Len(aDadGer) .and. Alltrim(aDadGer[mm,1] ) = Alltrim(mSuper)
		//mês 1			 	
		dExec := Ctod("01/" + str(nMes1) +'/'+ Right(StrZero(Year(dData1),4),2) )
		nVALFAT1 := U_FatMes(1, "", 1, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha)        //U_FatMes(nOpc, cDev, nPAR04, cVend_R02, dExec, lFora, nFam, cTipoA3,nLinha)
		nKGFAT1  := U_FatMes(1, "", 2, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha) 	 	
					
		//mês 2
		dExec := Ctod("01/" + str(nMes2) +'/'+ Right(StrZero(Year(dData1),4),2) )
		nVALFAT2 := U_FatMes(1, "", 1, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha)        //U_FatMes(nOpc, cDev, nPAR04, cVend_R02, dExec, lFora, nFam, cTipoA3,nLinha)
		nKGFAT2  := U_FatMes(1, "", 2, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha) 	 	
					
		//mês 3
		dExec := Ctod("01/" + str(nMes3) +'/'+ Right(StrZero(Year(dData1),4),2) )
		nVALFAT3 := U_FatMes(1, "", 1, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha)        //U_FatMes(nOpc, cDev, nPAR04, cVend_R02, dExec, lFora, nFam, cTipoA3,nLinha)
		nKGFAT3  := U_FatMes(1, "", 2, aDadGer[mm,1], dExec, .T., nFam, "S",nLinha)

		aDadGer[mm,5] += nVALFAT1
		aDadGer[mm,6] += nKGFAT1
		aDadGer[mm,7] += nVALFAT2
		aDadGer[mm,8] += nKGFAT2
		aDadGer[mm,9] += nVALFAT3
		aDadGer[mm,10]+= nKGFAT3
		            //mês 1             mês 2            mês 3
		nMedia :=  ( aDadGer[mm,5] + aDadGer[mm,7] + aDadGer[mm,9] ) / 3	 //média em R$ do coordenador			 
		nMediaKG := ( aDadGer[mm,6] + aDadGer[mm,8] + aDadGer[mm,10]) / 3    //média em kg do coordenador
		nPorcMedia	:= Round( ( aDadGer[mm,10] / nMediaKG) * 100 , 0 ) //valor em kg do mês corrente (3) / média em kg do coordenador
		
		aDadGer[mm,17] := nMedia    //em R$
		aDadGer[mm,18] := nMediaKG
		aDadGer[mm,19] := nPorcMedia
		
		mm++
	Enddo
Enddo
///FIM DA CAPTURA FATURADO MÊS		

aDadG := Asort( aDadGer,,, { |X,Y| X[3] + Transform(X[18],"@E 99,999,999.99") <  Y[3] + Transform(Y[18] ,"@E 99,999,999.99") } )

nMediaTotal := 0 		//total da média em KG - será usado no cálculo da % de participação em relação ao total da média em kg

nAux := 1
mGerE := ""
mGer := {}
nMediaTotal := 0
//For nAux := 1 to Len(aDadG)
While nAux <= Len(aDadG)
	mGerE := aDadG[nAux,3]
	Do While nAux <= Len(aDadG) .and. Alltrim(aDadG[nAux,3] ) = Alltrim(mGerE)
		nMediaTotal += aDadG[nAux,18]   //soma o total por gerente 
		nAux++
	Enddo
	Aadd(mGer , { mGerE, nMediaTotal } )
	nMediaTotal := 0
Enddo

//msgbox( str(nMediaTotal) )

//msgbox(str(nRegTot))
////////////////////
If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif


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
nTotMedKG	:= 0
nPorcMedia	:= 0
nTotPorc	:= 0
nTotMedMet  := 0

nTotMetaR	:= 0
nTotMetaK	:= 0 

nTotCartR	:= 0
nTotCartK	:= 0

nParticip	:= 0
nParticTot	:= 0

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
		cQry += " Where A3_COD = '" + Alltrim(cGeren) + "' "+LF
		cQry += " and A3_GEREN = '' AND A3_SUPER = '' "+LF
		cQry += " and A3_ATIVO = 'S' "+LF
		cQry += " and SA3.D_E_L_E_T_ = '' "+LF

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
		
			//////////////////////////////////////////////// 
			////reinicializa a variável cWeb para 
			////guardar string do html para novo gerente
			////////////////////////////////////////////////			
			cWeb := ""
			
			//////////////////
			/////CRIA O HTML
			/////////////////
			cDirHTM  := "\Temp\"    
			If nFam = 1
				cArqHTM  := "REL_01_SACOS_"+ ALLTRIM(cGeren) + ".HTM"    //relatório P/ Gerentes
			Elseif nFam = 2
				cArqHTM  := "REL_01_CAIXAS_" + Alltrim(cGeren) + ".HTM"    //relatório P/ Gerentes
			Endif
			//cArqHTM  := "R01_TST_" + Alltrim(cGeren) + ".HTM"    //relatório P/ Gerentes
			nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
			nPag     := 1    
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
			
			If lDentroSiga
				///cria o html local
				////cria o diretório local, caso não exista
				lDir := ExistDir('C:\RELVENDAS') // Resultado: .F.
				cDir := "C:\RELVENDAS\"
				If !lDir
					//msgbox("cria Dir")
					U_CriaDir( cDir ) 
				Endif
				////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE	  
				If nFam = 1
					cArq  := "REL_01_SACOS_"+ ALLTRIM(cGeren) + ".HTM"    //relatório P/ Gerentes
				Elseif nFam = 2
					cArq  := "REL_01_CAIXAS_"+ ALLTRIM(cGeren) + ".HTM"    //relatório P/ Gerentes
				Endif
				nHand := fCreate( cDir + cArq, 0 )			    
				If nHand = -1
				     MsgAlert('o arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
			
			Endif		
		
			cSuper := aDadG[nCta,1]
			cNomeSuper := aDadG[nCta,2]						
				
			nPag := 1
			nLinhas := 80
			
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
								
			If nLinhas >= 35
				///Cabeçalho PÁGINA
				cWeb += fCabeca(nPag, titulo)
						
				///Cabeçalho relatório			
				cWeb += fCabRel( nFam )						
				
							
				cWeb += '</strong></tr>'+ LF
				nLinhas := 1			
				nPag++
				
		    Endif			
						
			Do While nCta <= Len(aDadG)  .and. Alltrim(cGeren) == Alltrim(aDadG[nCta,3]) 	///faça enquanto o gerente atual é igual ao anterior	   	  	   
			
				cSuper		:= aDadG[nCta,1]
				cNomeSuper	:= Alltrim(aDadG[nCta,2])			
						   
				  If nLinhas >= 35	  
				 	  
				  		///Cabeçalho PÁGINA
				  		cWeb += fCabeca(nPag, titulo)
			  			///Cabeçalho relatório	
				  		cWeb += fCabRel( nFam )				  		
				  			
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
				cQuery := " SELECT A3_SUPER " + LF
				//If !lDentroSiga       //FORA DO SIGA, FAZ TODAS AS LINHAS
					//cQuery += ", SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO " + LF
				//	cQuery += ", SUM(Z7_VALOR + Z7_VLRHOSP) as Z7_VALOR, SUM(Z7_KILO + Z7_KGHOSP) as Z7_KILO " + LF						 
				//Else
					If nLinha = 1    //institucional/doméstica                                                                              
						cQuery += ", SUM(Z7_VALOR) as VALOR, SUM(Z7_KILO) as KILO " + LF
					Elseif nLinha = 2  //hospitalar
						cQuery += ", SUM(Z7_VLRHOSP) as VALOR, SUM(Z7_KGHOSP) as KILO " + LF
					Elseif nLinha = 3    //todas                                                                              
						cQuery += ", SUM(Z7_VALOR + Z7_VLRHOSP) as VALOR, SUM(Z7_KILO + Z7_KGHOSP) as KILO " + LF						
					Endif
				//Endif
				cQuery += " , Z7_MESANO , Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				//cQuery += " WHERE RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' "+LF 
				cQuery += " WHERE A3_COD = '" + Alltrim(cSuper) + "' "+LF 
				//cQuery += " AND A3_SUPER = Z7_REPRESE "+LF
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				If nFam = 1
					cQuery += " AND Z7_TIPO = 'SC' " + LF
				Elseif nFam = 2
					cQuery += " AND Z7_TIPO <> 'SC' " + LF
				Endif
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				//cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4),LEFT(Z7_MESANO,2) " + LF
                MemoWrite("C:\Temp\metafatr22.sql",cQuery)
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
				While META->( !EOF() )
					//If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(Month(dDatabase),2) + Strzero(Year(dDatabase),4) )
					If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(Month(dData2),2) + Strzero(Year(dData2),4) )
						nMetaR += META->VALOR
						nMetaK += META->KILO
					Endif
					META->(Dbskip())
				Enddo
				DbSelectArea("META")
				DbCloseArea()
								    				  	
				//cWeb += '<td width="1000"><span class="style3">'+ Alltrim(aDadG[nCta,1]) + "-" + Alltrim(SUBSTR(aDadG[nCta,2],1,30)) + '</span></td>'+LF //COORDENADOR
				cWeb += '<td width="1000"><span class="style3">'+ Alltrim(SUBSTR(aDadG[nCta,2],1,30)) + '</span></td>'+LF //COORDENADOR
				
				///meta
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(nMetaR, "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(nMetaK,"@E 9,999,999.99")+' </span></td>'+LF        //KG
				nTotMetaR += nMetaR
				nTotMetaK += nMetaK
				
								
				///mês 1
				nTotVM1 += Round(aDadG[nCta,5],2)
				nTotPM1 += Round(aDadG[nCta,6],2)
				
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,5], "@E 99,999,999.99")  + '</span></td>'+LF  	//R$
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,6],"@E 9,999,999.99")+' </span></td>'+LF        //KG				
					
				////mês 2			
				nTotVM2 += Round(aDadG[nCta,7],2)
				nTotPM2 += Round(aDadG[nCta,8],2)
							   
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,7], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,8],"@E 9,999,999.99")+' </span></td>'+LF        //KG				
								
				////mês 3					
				nTotVM3 += Round(aDadG[nCta,9],2)
				nTotPM3 += Round(aDadG[nCta,10],2)
								    
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform(aDadG[nCta,9], "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">'+ Transform(aDadG[nCta,10],"@E 9,999,999.99")+' </span></td>'+LF        //KG
						
				///Média
				cWeb += '<td width="900" align="right"><span class="style3">'+Transform(aDadG[nCta,17],"@E 99,999,999.99") +'</span></td>'+LF  //MEDIA R$
				cWeb += '<td width="900" align="right"><span class="style3">'+Transform(aDadG[nCta,18],"@E 99,999,999.99") +'</span></td>'+LF  //MEDIA KG
				nTotMedia += aDadG[nCta,17]
				nTotMedKG += aDadG[nCta,18]
				
				//% Média sobre a Meta
				//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA
				nMediaSMeta	:= Round( ( aDadG[nCta,18] / nMetaK) * 100 , 0 )
				//cWeb += '<td width="400" align="right"><span class="style3">'+Transform( nMediaSMeta,"@E 9999") + "%" + '</span></td>'+LF  // % MEDIA KG / sobre a Meta
								
				//% do mês atual (3) sobre média KG
				//cWeb += '<td width="400" align="right"><span class="style3">'+ Transform(aDadG[nCta,19], "@E 9999") + "%" +'</span></td>'+LF        //KG
				//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, ALTERAR ESTA COLUNA                                                      
				//% do MÊS ATUAL (3) SOBRE A META KG                                                                                                      
				nPorcMeta := ( (aDadG[nCta,10] / nMetaK) * 100 )
				cWeb += '<td width="400" align="right"><span class="style3">'+ Transform( nPorcMeta , "@E 9999") + "%" +'</span></td>'+LF        //KG
				
				//% de participação do coordenador sobre o total da média em kg
				//nParticip := Round( (aDadG[nCta,18]	/ nMediaTotal) * 100 , 0 )  //nMediaTotal foi somado por Gerente no início do programa
				mm := 1
				nParticip := 0    //participação individual por coordenador
				For mm := 1 to Len(mGer)
					If Alltrim(mGer[mm,1]) = Alltrim(cGeren)
						nParticip := (( aDadG[nCta,18] / mGer[mm,2] ) * 100 )									
					Endif
				Next
			
				//					    média kg     / total média kg
				//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA                                                      
				//cWeb += '<td width="400" align="right"><span class="style3">'+ Transform(nParticip, "@E 9999") + "%" +'</span></td>'+LF   
				nParticTot	+= nParticip				
				cWeb += '</tr>'+LF
				
				///zera a meta
				nMetaR := 0
				nMetaK := 0
				
				nLin++		    
				nCta++
				If lDentroSiga
					IncRegua()	
				Endif
				
				nLinhas++
				
			Enddo
		
			////TOTAIS VENDAS
			cWeb += '<td width="1500" align="left"><span class="style3"><b>Total.....:</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaR,"@E 99,999,999.99")+'</span></td>'+LF  //META R$
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+TRANSFORM( nTotMetaK,"@E 99,999,999.99")+'</span></td>'+LF  //META KG
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 99,999,999.99")  + '</span></td>'+LF    //MES 1 R$
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 9,999,999.99")  + '</span></td>'+LF     //MES 1 KG
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 99,999,999.99")  + '</span></td>'+LF    //MES 2 R$
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 9,999,999.99")  + '</span></td>'+LF     //MES 2 KG
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 99,999,999.99")  + '</span></td>'+LF    //MES 3 R$
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 9,999,999.99")  + '</span></td>'+LF     //MES 3 KG
			//total médias: (última linha em negrito)
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF	 //MEDIA R$
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 9,999,999.99")  + '</span></td>'+LF	 //MEDIA KG
			
			///% PARTICIPAÇÃO DA MÉDIA KG SOBRE META KG
			//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA
			nTotMedMet := (( nTotMedKG / nTotMetaK ) * 100)
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedMet,"@E 9999")  + "%" + '</span></td>'+LF    //% MÉDIA sobre META
			
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF	//MES ATUAL R$
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF    //MES ATUAL KG
			
			///% DO MÊS ATUAL (3) SOBRE A MÉDIA KG
			//ex:% DE OUTUBRO/12 Sobre a MEDIA KG
			//nTotPorc := (( nTotPM3 / nTotMedKG ) * 100)
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPorc,"@E 9999")  + "%" + '</span></td>'+LF    //% sobre MÉDIA
			//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, ALTERAR ESTA COLUNA                                                      
			//% do MÊS ATUAL (3) SOBRE A META KG
			nTotPorc := (( nTotPM3 / nTotMetaK ) * 100)
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPorc,"@E 9999")  + "%" + '</span></td>'+LF    //% sobre MÉDIA
						
			//% PARTICIPACAO DA MEDIA(KG) EM RELACAO A MEDIA TOTAL (KG)
			//nParticTot := (( nTotMedKG / nMediaTotal ) * 100 )								
			mm := 1
			nParticTot := 0   //participação total
			For mm := 1 to Len(mGer)
				If Alltrim(mGer[mm,1]) = Alltrim(cGeren)
					nParticTot := (( nTotMedKG / mGer[mm,2] ) * 100 )									
				Endif
			Next
			//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA                                                      
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( Round(nParticTot,0),"@E 9999")  + "%" + '</span></td>'+LF    //% PARTICIPAÇÃO SOBRE MÉDIA
			
						
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
	        nTotMedKG	:= 0
	        nTotPorc	:= 0
	        
	        nTotCartR	:= 0
	        nTotCartK	:= 0
	        
	        /////FECHA A TABELA DO HTML
			cWeb += '</table><br>' + LF
	        
	        ////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
			
			////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
			
			////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
			
			////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
			
			
			
			///quebra a página para imprimir o resumo na próxima página			
			//cWeb += '<div class="quebra_pagina"> </div>'+LF 
			
			//////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
						
			If lDentroSiga
				//////GRAVA O HTML LOCAL
				Fwrite( nHand, cWeb, Len(cWeb) )
				
			Endif
			cWeb := ""
						        
	        ///faz o rodapé
	        cWeb += fRodape()
	       			
			//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
			//////GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
			
				
			//////SELECIONA O EMAIL DESTINATÁRIO
			If lDentroSiga
				
				//////GRAVA O HTML
				Fwrite( nHand, cWeb, Len(cWeb) )
				FClose( nHand )
			
				cCodUser := __CUSERID     
				//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo

				PswOrder(1)
				If PswSeek( cCoduser, .T. )
				   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
				   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
				   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
				   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
				Endif
				
				//////////////////////////////////////
				// Exibe o arquivo HTML no Navegador 
				//////////////////////////////////////
				U_fAbreHTM(cDir, cArq)
				
			Else
				
				cCopia  := ""
			    If Alltrim(cGeren) = '0256' .and. nLinha = 2
					cMailTo := cMailGeren
					//cMailto += ";flavio@ravaembalagens.com.br"
					cMailto += ";vendas.sp@ravaembalagens.com.br"    //JACQUELINE
					
				Elseif Alltrim(cGeren) != '0256' //.and. nLinha = 1 .or. nLinha = 2 .or. nLinha = 3
					cMailTo := cMailGeren
					//cMailTo += ";marcos@ravaembalagens.com.br"				
					cMailTo += ";josenildo@ravaembalagens.com.br"				
					//cMailTo += ";janderley@ravaembalagens.com.br"
					//cMailto += ";antonio.fulgencio@ravaembalagens.com.br"
					//cMailTo += ";alexandre.saraiva@ravaembalagens.com.br"
					//cMailTo += ";marcilio@ravaembalagens.com.br"					
					cMailTo += ";janaina@ravaembalagens.com.br"
				
				Else
					cMailTo := ""
				Endif
				cCopia  += "flavia.rocha@ravaembalagens.com.br"
			
			Endif
			
			cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)
			cCorpo  += titulo + CHR(13) + CHR(10)
			cCorpo  += " Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
			//cMailTo := ""
			//////ENVIA O HTML COMO ANEXO			
			U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo )
						
	  Else
	  	nCta++
	  Endif
	  	
	Enddo
		
	If lDentroSiga
		MsgInfo("Rel 01 - Você recebeu um e-mail deste Relatório.")
	Endif

//Else
	//MSGBOX("Array Vazio!")
Endif


//////////////FIM DO GERA PARA GERENTES


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ




//If !lDentroSiga
	// Habilitar somente para Schedule
//	Reset environment
//Endif


Return
        
**************************************
Static Function fCabeca(nPag, titulo)
**************************************

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
cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cWeb += '<tr>    <td>'+ LF
cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cWeb += '<tr>        <td>SIGA /FATR022/v.P10</td>'+ LF
cWeb += '<td align="left">' + titulo + '</td>'+ LF
cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cWeb += '</table></head>'+ LF      

Return(cWeb)

********************************
Static Function fCabRel(nFam)
********************************

Local cWeb := ""

cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:13px"><B>COORDENADOR</span></div></B></td>'+ LF
cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+ LF
cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
			
cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+ LF
//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA
//cWeb += '<td><div align="center"><span class="style3"><b>% DA MEDIA Sobre a META</span></div></b></td>'+LF						
				
//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MES ATUAL ' + LF + Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF

//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, ALTERAR ESTA COLUNA			
//cWeb += '<td><div align="center"><Font-size="12px"><b>% DE ' + Alltrim(cMes3) + cAnoM3 + ' Sobre a MEDIA</font></div></b></td>'+LF
cWeb += '<td><div align="center"><Font-size="12px"><b>% DE ' + Alltrim(cMes3) + cAnoM3 + ' Sobre a META</font></div></b></td>'+LF

If nFam = 1
	//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, ALTERAR ESTA COLUNA				
	//cWeb += '<td><div align="center"><Font-size="12px"><b>% PARTICIPACAO DA MEDIA(KG) EM RELACAO A MEDIA TOTAL (KG)</font></div></b></td>'+LF						
		
	cWeb += '<tr>'+ LF
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //meta R$
	cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //meta KG
					
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 1 R$
	cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //mês 1 KG
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 2 R$
	cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //mês 2 KG				
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 3 R$
	cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //mês 3 KG
				
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF		//média R$  
	cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF        //média KG
	
	//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA				
	//Web += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF	//% MEDIA SOBRE META
					
	//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 4 - atual R$
	//cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //mês 4 - atual KG
									
	cWeb += '<td width="500" align="center"><span class="style3">KG</span></td>'+ LF	//% MES ATUAL (3) SOBRE MEDIA KG				
	//cWeb += '<td width="500" align="center"><span class="style3">KG</span></td>'+ LF	//% PARTICIPAÇÃO EM RELAÇÃO AO TOTAL				

Elseif nFam = 2
	//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, ALTERAR ESTA COLUNA			
	//cWeb += '<td><div align="center"><Font-size="12px"><b>% PARTICIPACAO DA MEDIA(QTD) EM RELACAO A MEDIA TOTAL (QTD)</font></div></b></td>'+LF						
				
	cWeb += '<tr>'+ LF
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //meta R$
	cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF   //meta KG
					
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 1 R$
	cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF   //mês 1 KG
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 2 R$
	cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF   //mês 2 KG				
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 3 R$
	cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF   //mês 3 KG
					
	cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF		//média R$  
	cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF        //média KG
	
	//FR - 05/12/12 - SOLICITADO POR JANAINA, ATRAVÉS DE EMAIL DE EURIVAN, RETIRAR ESTA COLUNA				
	//cWeb += '<td width="400" align="center"><span class="style3">QTD</span></td>'+ LF	//% MEDIA SOBRE META
					
	//cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF   //mês 4 - atual R$
	//cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF   //mês 4 - atual KG
									
	cWeb += '<td width="500" align="center"><span class="style3">QTD</span></td>'+ LF	//% MES ATUAL (3) SOBRE MEDIA KG				
	//cWeb += '<td width="500" align="center"><span class="style3">QTD</span></td>'+ LF	//% PARTICIPAÇÃO EM RELAÇÃO AO TOTAL				
Endif

Return(cWeb)

***************************
Static Function fRodape()
***************************

Local cWeb := ""

cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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

User Function FatMes(nOpc, cDev, nPAR04, cCodA3, dExec, lFora, nFam, cTipoA3, nLinha)    
//nOpc = indica se 1 - Real, 2 - Kg,
//cDev = indica se retorna valor devolvido (cDev != "" , ou valor faturado cDev = vazio )
//nPAR04 = esse parâmetro indica se irá retornar o valor R$ ou KG , vindo externo do REL 02 - FATR023
//cCodA3 = código do vendedor , quando esta função é chamada do REL 02 - FATR023
//dExec  = Data de execução do relatório, esta variável é usada quando a chamada desta função é externa
//lFora  = indica se a chamada desta função é externa ( .T. = REL 02 FATR023 , ou .F. = deste mesmo relatório FATPFIV5 )
//cTipoA3 = indica se: "V" - Vendedor, "S" - Supervisor , "G" - Gerente
//nLinha  = indica se: 1-Doméstica / 2-Hospitalar
***************
local cQry:=''
Local nMesExec := 0
Local dVend1
Local dVend2
Local dExecucao
Local nRet:=0 


cQry:="SELECT "  + CHR(13) + CHR(10)
If !lFora    //chamado dentro do siga
	//TOTAL KG FATURADO
	cQry+=" FAT_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)  //FATURADO EM KG
	//cQry+=" ELSE (D2_QUANT - D2_QTDEDEV) * D2_PESO END), " + CHR(13) + CHR(10)
	cQry+=" ELSE D2_QUANT * D2_PESO END) " + CHR(13) + CHR(10)
	
	//TOTAL R$ FATURADO
	//cQry+=" FAT_RS = SUM( D2_TOTAL - (D2_QTDEDEV * D2_PRCVEN ) ), " + CHR(13) + CHR(10)  //FATURADO EM REAIS
	cQry+=" , FAT_RS = SUM(D2_TOTAL) " + CHR(13) + CHR(10)  //FATURADO EM REAIS
	
	//TOTAL KG DEVOLVIDO
	cQry+=" , DEV_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)    //DEVOLUÇÃO EM KG
	cQry+=" ELSE D2_QTDEDEV * D2_PESO END) " + CHR(13) + CHR(10)           
	
	//TOTAL R$ DEVOLVIDO
	cQry+=" , DEV_RS = SUM( D2_QTDEDEV * D2_PRCVEN) " + CHR(13) + CHR(10)  //DEVOLUÇÃO EM REAIS 

Else    //chamada de fora
	If nFam = 1 // Sacos
		//TOTAL KG FATURADO
		cQry+=" FAT_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)  //FATURADO EM KG
		//cQry+="ELSE (D2_QUANT - D2_QTDEDEV) * D2_PESO END), " + CHR(13) + CHR(10)
		cQry+=" ELSE D2_QUANT * D2_PESO END) " + CHR(13) + CHR(10)
		
		//TOTAL R$ FATURADO
		cQry+=" , FAT_RS=SUM(D2_TOTAL) " + CHR(13) + CHR(10)  //FATURADO EM REAIS
		//cQry+="FAT_RS=SUM( D2_TOTAL - (D2_QTDEDEV * D2_PRCVEN ) ), " + CHR(13) + CHR(10)  //FATURADO EM REAIS
		
		//TOTAL KG DEVOLVIDO
		cQry+=" , DEV_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)    //DEVOLUÇÃO EM KG
		cQry+=" ELSE D2_QTDEDEV * D2_PESO END) " + CHR(13) + CHR(10)           
		
		//TOTAL R$ DEVOLVIDO
		cQry+=" , DEV_RS = SUM( D2_QTDEDEV * D2_PRCVEN) " + CHR(13) + CHR(10)  //DEVOLUÇÃO EM REAIS		
	
	Else //caixas
		//TOTAL QTDE CX FATURADO
		cQry+=" FAT_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)  //FATURADO EM KG
		//cQry+="ELSE (D2_QUANT - D2_QTDEDEV) END), " + CHR(13) + CHR(10)
		cQry+=" ELSE D2_QUANT END) " + CHR(13) + CHR(10)
		
		//TOTAL R$ CX FATURADO
		cQry+=" ,FAT_RS = SUM(D2_TOTAL) " + CHR(13) + CHR(10)  //FATURADO EM REAIS
		//cQry+="FAT_RS=SUM( D2_TOTAL - (D2_QTDEDEV * D2_PRCVEN ) ), " + CHR(13) + CHR(10)  //FATURADO EM REAIS
		
		
		//TOTAL QTDE CX DEVOLVIDO
		cQry+=" ,DEV_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  " + CHR(13) + CHR(10)    //DEVOLUÇÃO EM KG
		cQry+=" ELSE D2_QTDEDEV END) " + CHR(13) + CHR(10)           
		
		//TOTAL R$ CX DEVOLVIDO
		cQry+=" , DEV_RS = SUM( D2_QTDEDEV * D2_PRCVEN) " + CHR(13) + CHR(10)  //DEVOLUÇÃO EM REAIS
	Endif
Endif
	
cQry+="FROM "
cQry+= " " + retSqlName("SD2")+ " SD2 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SB1")+ " SB1 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SF2")+ " SF2 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SC5")+ " SC5 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SA3")+ " SA3 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SA1")+ " SA1 WITH (NOLOCK) " + CHR(13) + CHR(10)
cQry+= "," + retSqlName("SF4")+ " SF4 WITH (NOLOCK) " + CHR(13) + CHR(10)

cQry+="WHERE " + CHR(13) + CHR(10)
//EM 01/11/12 EURIVAN SOLICITOU (A PEDIDO DE SR. VIANA) CONSOLIDAR AS VENDAS RAVA EMB / RAVA CAIXAS 
//EXISTEM SACOS QUE SÃO VENDIDOS PELA RAVA CAIXAS 
//comentado POR FR
//cQry+="C5_FILIAL='"+XFILIAL('SC5')+"' " + CHR(13) + CHR(10)
//cQry+="AND F2_FILIAL='"+XFILIAL('SF2')+"' " + CHR(13) + CHR(10)
//cQry+="AND D2_FILIAL='"+XFILIAL('SD2')+"' " + CHR(13) + CHR(10)
//cQry+="AND B1_FILIAL='"+XFILIAL('SB1')+"'  " + CHR(13) + CHR(10)
//cQry+="AND A3_FILIAL='"+XFILIAL('SA3')+"' " + CHR(13) + CHR(10)
//cQry+="AND A1_FILIAL='"+XFILIAL('SA1')+"' " + CHR(13) + CHR(10)
//cQry+="AND F4_FILIAL='"+XFILIAL('SF4')+"' " + CHR(13) + CHR(10)
cQry+="SC5.C5_FILIAL = SF2.F2_FILIAL " + CHR(13) + CHR(10)
cQry+="AND SF2.F2_FILIAL = SD2.D2_FILIAL " + CHR(13) + CHR(10)

cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA   " + CHR(13) + CHR(10)
cQry+="AND SA3.A3_COD = SC5.C5_VEND1  " + CHR(13) + CHR(10)
cQry+="AND D2_PEDIDO=C5_NUM "                               + CHR(13) + CHR(10)
cQry+="AND D2_COD = B1_COD  " + CHR(13) + CHR(10)
cQry+="and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA " + CHR(13) + CHR(10)
cQry+="and D2_TES = F4_CODIGO and F4_DUPLIC = 'S' " + CHR(13) + CHR(10)

If !lFora   //se a chamada desta função é deste relatório mesmo, ou de fora (REL 02 - FATR023)
	dExecucao := Ctod(dTExec)
	nMesExec := Month(dExecucao)
	If nOpc=1 // Faturado no Mes

		If Substr(dTExec,1,2) = '01'  //se a execução for num dia 1o., retrocede ao mês anterior para capturar o mês cheio
			dVend1   := CtoD( '01/' + str((nMesExec - 1)) +'/'+Right(StrZero(Year(dDataUso),4),2) )
			dVend2   := LastDay(dVend1) 	
			//cQry+="and C5_EMISSAO between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "+ CHR(13) + CHR(10)
			cQry+="and D2_EMISSAO between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "+ CHR(13) + CHR(10)
		Else
		    //cQry+="and C5_EMISSAO between '"+dtos(FirstDay(dDataUso))+"' and '"+dtos(LastDay(dDataUso))+"' " + CHR(13) + CHR(10)
		    cQry+="and D2_EMISSAO between '"+dtos(FirstDay(dDataUso))+"' and '"+dtos(LastDay(dDataUso))+"' " + CHR(13) + CHR(10)
		Endif
		
	ElseIf nOpc=2 // Faturado no Dia 
	    //cQry+="and C5_EMISSAO='"+dtos(dDataUso)+"' " + CHR(13) + CHR(10)
	    cQry+="and D2_EMISSAO='"+dtos(dDataUso)+"' " + CHR(13) + CHR(10)
	EndIf
	
Else   //chamada de fora	
	If nOpc=1 // Faturado no Mes
	    //cQry+="and C5_EMISSAO between '"+dtos(FirstDay(dExec))+"' and '"+dtos(LastDay(dExec))+"' " + CHR(13) + CHR(10)		
	    cQry+="and D2_EMISSAO between '"+dtos(FirstDay(dExec))+"' and '"+dtos(LastDay(dExec))+"' " + CHR(13) + CHR(10)		
	ElseIf nOpc=2 // Faturado no Dia 
	    //cQry+="and C5_EMISSAO='"+dtos(dExecucao)+"' " + CHR(13) + CHR(10)
	    cQry+="and D2_EMISSAO='"+dtos(dExecucao)+"' " + CHR(13) + CHR(10)
	EndIf
Endif

cQry+="and SC5.C5_VEND1 = SA3.A3_COD "+ CHR(13) + CHR(10)
If !lFora
	If !empty(par11)     //Representante
		//cQry+="and SC5.C5_VEND1 = SA3.A3_COD " 
	    cQry+="and SC5.C5_VEND1 in ('"+ Alltrim(par11) +"','"+alltrim(par11) +"VD'"+") " + CHR(13) + CHR(10)
	elseif !empty(par12)  //Coordenador 
	   //cQry+="and SA3.A3_COD = SC5.C5_VEND1  " 
	   cQry+="and ( A3_SUPER LIKE ('" + ALLTRIM(par12) + "%' )  OR C5_VEND1 in ('"+ Alltrim(par12)+"','"+ alltrim(par12) +"VD'"+") )  " 	+ CHR(13) + CHR(10)
	
	elseif !empty(par13)//Gerente
		//cQry+="and SC5.C5_VEND1 = SA3.A3_COD  " 
	    cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(par13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+ CHR(13) + CHR(10)
		cQry += " OR A3_GEREN LIKE ( '" + ALLTRIM(par13) + "%' ) ) "+ CHR(13) + CHR(10)
	/* ANTONIO
	else
		cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE A3_GEREN <> ''  and SA3.D_E_L_E_T_ != '*' ) ) "
	*/
	Endif
	if par07 = 1 //Linha Hospitalar
		cQry+="and SB1.B1_GRUPO IN ('C')  " + CHR(13) + CHR(10)
	elseif par07 = 2 //Linha Dom/Inst
		cQry+="and SB1.B1_GRUPO IN ('D','E')  " + CHR(13) + CHR(10)
	elseif par07 = 3
		cQry+="and SB1.B1_GRUPO IN ('A','B','F','G')  "+ CHR(13) + CHR(10)
	elseif par07 = 5
		cQry+="and SB1.B1_GRUPO IN ('A','B','D','E','F','G')  " + CHR(13) + CHR(10)
	endif
	
	if !empty(par08) .and. empty(par09)
		cQry+="and SA1.A1_EST = '"+par08+"'  " + CHR(13) + CHR(10)
	elseIf empty(par08) .and. !empty(par09)
		cQry+="and SA1.A1_EST != '"+par09+"' " + CHR(13) + CHR(10)
	elseIf !empty(par08) .and. !empty(par09)
		cQry+="and SA1.A1_EST = '"+par08+"' AND SA1.A1_EST != '"+par09+"'  " + CHR(13) + CHR(10)
	endIf

Else
	///qdo chamada de outro programa (REL 01 - FATR022 / REL 02 - FATR023)
	IF cTipoA3 = "V"
		cQry+="and ( C5_VEND1 in ('"+ Alltrim(cCodA3)+"','"+ alltrim(cCodA3) +"VD'"+") )  " 	+ CHR(13) + CHR(10)
	ELSEIF cTipoA3 = "S"
		cQry+="and ( A3_SUPER LIKE ('" + ALLTRIM(cCodA3) + "%' )  OR C5_VEND1 in ('"+ Alltrim(cCodA3)+"','"+ alltrim(cCodA3) +"VD'"+") )  " 	+ CHR(13) + CHR(10)
	ELSEIF cTipoA3 = "G"
		cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(cCodA3) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+ CHR(13) + CHR(10)
		cQry += " OR A3_GEREN LIKE ( '" + ALLTRIM(cCodA3) + "%' ) ) "+ CHR(13) + CHR(10)
	ELSEIF Alltrim(cTipoA3) = "C" 	//CLIENTE	
	    cQry += " and (SC5.C5_CLIENTE + SC5.C5_LOJACLI ) = '" + ALLTRIM(cCodA3) + "' "+LF		
	ENDIF
	
	IF nLinha = 2 //hospitalar
		cQry+="and SB1.B1_GRUPO IN ('C')  " + CHR(13) + CHR(10)	
	ELSEIF nLinha = 1 //Doméstica
		cQry+="and SB1.B1_GRUPO IN ('D','E')  " + CHR(13) + CHR(10)
	ENDIF
Endif

cQry+="AND F2_DUPL <> ' ' "+ CHR(13) + CHR(10)
If !lFora
	cQry+="AND B1_SETOR!='39' "+ CHR(13) + CHR(10)
Else
	If nFam = 1
		cQry+="AND B1_SETOR!='39' "+ CHR(13) + CHR(10)
	Else
		cQry+="AND B1_SETOR = '39' "+ CHR(13) + CHR(10)
	Endif
Endif

If !lFora        //chamado dentro do FATPFIV5
	If par06 = 2	  //verifica parâmetro despreza apara
		cQry+=" AND B1_TIPO != 'AP' " + CHR(13) + CHR(10)
		cQry+=" AND D2_TP != 'AP' "+ CHR(13) + CHR(10)
	Endif                   
Else    //se a chamada for de fora, exclui direto a apara
	cQry+=" AND B1_TIPO != 'AP' " + CHR(13) + CHR(10)
	cQry+=" AND D2_TP != 'AP' "+ CHR(13) + CHR(10)
Endif

cQry+="AND D2_TIPO = 'N'  "+ CHR(13) + CHR(10)
cQry+="AND C5_TIPO='N' "+ CHR(13) + CHR(10) 

//cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' , '6108' )"+ CHR(13) + CHR(10)
cQry+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND SD2.D2_CLIENTE NOT IN ('031732','031732' ) "//Despreza faturamento entre filiais

cQry+="AND SD2.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SB1.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SF2.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SC5.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SA3.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SA1.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
cQry+="AND SF4.D_E_L_E_T_ = '' "+ CHR(13) + CHR(10)
MemoWrite("C:\Temp\fatmes.sql", cQry)
If Select("FATMES") > 0
	DbSelectArea("FATMES")
	DbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS 'FATMES'

FATMES->( dbGoTop() )
If !FATMES->(EoF())
	//nRet := iif( par04 == 1, FATMES->FAT_RS, FATMES->FAT_KG )
	If !lFora
		If Empty(cDev)
			If PAR04 = 1
				nRet := (FATMES->FAT_RS - FATMES->DEV_RS)   
				//nRet := FATMES->FAT_RS 
			Else
				nRet := (FATMES->FAT_KG - FATMES->DEV_KG)
				//nRet := FATMES->FAT_KG
			Endif
		
		Else
			If PAR04 = 1              
				nRet := FATMES->DEV_RS
			Else
				nRet := FATMES->DEV_KG
			Endif
		Endif
	Else   //chamada de fora
		If Empty(cDev)
			If nPAR04 = 1
				nRet := (FATMES->FAT_RS - FATMES->DEV_RS)   
				//nRet := FATMES->FAT_RS
			Else
				nRet := (FATMES->FAT_KG - FATMES->DEV_KG)
				//nRet := FATMES->FAT_KG
			Endif
		
		Else
			If nPAR04 = 1				              
				nRet := FATMES->DEV_RS
			Else
				nRet := FATMES->DEV_KG
			Endif
		Endif
	Endif
	
EndIf
FATMES->( dbCloseArea() )


Return nRet
