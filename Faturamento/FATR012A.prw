#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR012A
//Objetivo: Relatório de Fechamento do Mês  -  Ano 2010
//			Emitir relatório das vendas por representante e enviar por e-mail
//          para a diretoria 
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 11/02/2010
//--------------------------------------------------------------------------
/*/



//DIRETORIA - RECEBE DE TODOS    
/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/
************************************
User Function FATR012A()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Previsao de entrega Transportadora "
Local cPict          := ""
Local titulo         := "" 

//Local Cabec1         := "Relatorio de Acompanhamento por Cliente  -  " + StrZero( Year( dDatabase), 4 ) + ""

Local Cabec1         := "" //"CLIENTE        |     JANEIRO           |       FEVEREIRO       |       MARÇO          |      ABRIL           |      MAIO             |     JUNHO      " 
Local Cabec2		 :=	""//               |    R$        KG       |    R$         KG      |  R$           KG     | R$          KG       |   R$        KG        |  R$         KG "
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR012A" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR012A" // Coloque aqui o nome do arquivo usado para impressao em disco
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
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private cMailSuper	:= ""
//SetPrvt("OHTML,OPROCESS")
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nLin        := 80
Private nCta		:= 0

//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dData2 := Lastday(dDatabase)
dData1 := dData2 - 180

//dData2 := ctod("31/03/2010") 
//dData1 := dData2 - 15

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Acompanhamento por Cliente (p/ Diretoria)  -  " + cStrAno + ""
//+ StrZero( Year( dData1), 4 ) + "/" + StrZero( Year( dData2), 4 ) + ""


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
//ago, set, out, nov, dez, jan
	nMes6 := aMeses[nPosMes]          //1
	nMes5 := aMeses[nPosMes + 11]     //12
	nMes4 := aMeses[nPosMes + 10]     //11
	nMes3 := aMeses[nPosMes + 9 ]     //10
	nMes2 := aMeses[nPosMes + 8 ]     //9
	nMes1 := aMeses[nPosMes + 7 ]     //8
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 2 ) ,3,2)    	//jan/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) - 1, 2 ), 3,2) 	//dez/09
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 2 ),3,2) 	//nov/09
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 2 ),3,2) 	//out/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 2 ),3,2)	//set/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 2 ),3,2)	//ago/09

Elseif nPosMes = 2   //se for Fevereiro
//set, out, nov, dez, jan, fev
	nMes6 := aMeses[nPosMes]         //2
	nMes5 := aMeses[nPosMes - 1 ]    //1
	nMes4 := aMeses[nPosMes + 10]    //12
	nMes3 := aMeses[nPosMes + 9]     //11
	nMes2 := aMeses[nPosMes + 8 ]    //10
	nMes1 := aMeses[nPosMes + 7 ]    //9
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//fev/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//dez/09
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//nov/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//out/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//set/09
	
Elseif nPosMes = 3	// se for Março
//out, nov, dez, jan, fev, mar
	nMes6 := aMeses[nPosMes]          //3
	nMes5 := aMeses[nPosMes - 1 ]     //2
	nMes4 := aMeses[nPosMes - 2 ]     //1
	nMes3 := aMeses[nPosMes + 9]      //12
	nMes2 := aMeses[nPosMes + 8 ]     //11
	nMes1 := aMeses[nPosMes + 7 ]     //10
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//mar/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//dez/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//nov/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//out/09
	
Elseif nPosMes = 4	// se for Abril
//nov, dez, jan, fev, mar, abr
	nMes6 := aMeses[nPosMes]         //4
	nMes5 := aMeses[nPosMes - 1 ]    //3
	nMes4 := aMeses[nPosMes - 2 ]    //2
	nMes3 := aMeses[nPosMes - 3 ]    //1
	nMes2 := aMeses[nPosMes + 8 ]    //12
	nMes1 := aMeses[nPosMes + 7 ]    //11
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//abr/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//dez/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//nov/09	
	
Elseif nPosMes = 5	// se for Maio
//dez, jan, fev, mar, abr, maio
	nMes6 := aMeses[nPosMes]         //5
	nMes5 := aMeses[nPosMes - 1 ]    //4
	nMes4 := aMeses[nPosMes - 2 ]    //3
	nMes3 := aMeses[nPosMes - 3 ]    //2
	nMes2 := aMeses[nPosMes - 4 ]    //1
	nMes1 := aMeses[nPosMes + 7 ]    //12
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)    	//maio/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jan/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//dez/09
	
Elseif nPosMes = 6	// se for Junho
//jan, fev, mar, abr, maio, jun
	nMes6 := aMeses[nPosMes]         //6
	nMes5 := aMeses[nPosMes - 1 ]    //5
	nMes4 := aMeses[nPosMes - 2 ]    //4
	nMes3 := aMeses[nPosMes - 3 ]    //3
	nMes2 := aMeses[nPosMes - 4 ]    //2
	nMes1 := aMeses[nPosMes - 5 ]    //1
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2),  4 ),3,2)    	//junho/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//fev/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jan/10
		
Elseif nPosMes = 7	// se for Julho
//fev, mar, abr, maio, jun, julho
	nMes6 := aMeses[nPosMes]         //7
	nMes5 := aMeses[nPosMes - 1 ]    //6
	nMes4 := aMeses[nPosMes - 2 ]    //5
	nMes3 := aMeses[nPosMes - 3 ]    //4
	nMes2 := aMeses[nPosMes - 4 ]    //3
	nMes1 := aMeses[nPosMes - 5 ]    //2
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//julho/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//mar/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//fev/10
	
Elseif nPosMes = 8	// se for Agosto
//mar, abr, maio, jun, jul, ago
	nMes6 := aMeses[nPosMes]        //8
	nMes5 := aMeses[nPosMes - 1 ]   //7
	nMes4 := aMeses[nPosMes - 2 ]   //6
	nMes3 := aMeses[nPosMes - 3 ]   //5
	nMes2 := aMeses[nPosMes - 4 ]   //4
	nMes1 := aMeses[nPosMes - 5 ]   //3
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//ago/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//abr/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//mar/10
	
Elseif nPosMes = 9	// se for Setembro
//abr, maio, jun, jul, ago, set
	nMes6 := aMeses[nPosMes]        //9
	nMes5 := aMeses[nPosMes - 1 ]   //8
	nMes4 := aMeses[nPosMes - 2 ]   //7
	nMes3 := aMeses[nPosMes - 3 ]   //6
	nMes2 := aMeses[nPosMes - 4 ]   //5
	nMes1 := aMeses[nPosMes - 5 ]   //4
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//set/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//maio/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//abr/10
	
Elseif nPosMes = 10	// se for Outubro
//maio, jun, jul, ago, set, out
	nMes6 := aMeses[nPosMes]        //10
	nMes5 := aMeses[nPosMes - 1 ]   //9
	nMes4 := aMeses[nPosMes - 2 ]   //8
	nMes3 := aMeses[nPosMes - 3 ]   //7
	nMes2 := aMeses[nPosMes - 4 ]   //6
	nMes1 := aMeses[nPosMes - 5 ]   //5
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//out/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//junho/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//maio/10
	
Elseif nPosMes = 11	// se for Novembro
//jun, jul, ago, set, out, nov
	nMes6 := aMeses[nPosMes]        //11
	nMes5 := aMeses[nPosMes - 1 ]   //10
	nMes4 := aMeses[nPosMes - 2 ]   //9
	nMes3 := aMeses[nPosMes - 3 ]   //8
	nMes2 := aMeses[nPosMes - 4 ]   //7
	nMes1 := aMeses[nPosMes - 5 ]   //6
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//nov/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//out/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//julho/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//junho/10
	
Elseif nPosMes = 12	// se for Dezembro
//jul, ago, set, out, nov, dez
	nMes6 := aMeses[nPosMes]        //12
	nMes5 := aMeses[nPosMes - 1 ]   //11
	nMes4 := aMeses[nPosMes - 2 ]   //10
	nMes3 := aMeses[nPosMes - 3 ]   //9
	nMes2 := aMeses[nPosMes - 4 ]   //8
	nMes1 := aMeses[nPosMes - 5 ]   //7
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//dez/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//nov/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//out/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//ago/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jul/10
	
Endif			

//Compor o array com o Nome dos meses do ano
aNomMeses:= {}
//					1			2			3		 	  4		  		5		    6			7			  8			9				10			11			12
aNomMeses:= { " JANEIRO ", "FEVEREIRO", "  MARCO  ", "  ABRIL  ", "   MAIO  ", "  JUNHO  ", "  JULHO  ", "  AGOSTO ", "SETEMBRO ", " OUTUBRO ", "NOVEMBRO ", "DEZEMBRO "}

cMes6 := aNomMeses[nMes6]
cMes5 := aNomMeses[nMes5]
cMes4 := aNomMeses[nMes4]
cMes3 := aNomMeses[nMes3]
cMes2 := aNomMeses[nMes2]
cMes1 := aNomMeses[nMes1] 


Cabec1         := "REPRESENTANTE         |   META MENSAL            |   "+ cMes1 +"             |    "+ cMes2 +"              |    "+ cMes3 +"               |   "+ cMes4 +"            |   "+ cMes5 +"               |     "+ cMes6 +"   " 
Cabec2		   := "                      |    R$        KG          |    R$         KG        |  R$           KG          | R$          KG             |   R$        KG         |  R$            KG         |     R$            KG "

///////fim da montagem do cabeçalho

//Ativar o bloco abaixo qdo for chamar o relatório pelo menu:
///////início do bloco
/*
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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)         //Mostra telinha do "aguarde...imprimindo"
*/
///////fim do bloco

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
Local nQTD:=0 
//Local aDados 	:= {}
Local aDadDir	:= {}
Local aTotRepre := {}
Local nTotV:=nTotQ:=nTotP:=0
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
Private cSuper		:= ""
Private cNomeSuper 	:= ""
Private cGeren		:= ""
Private cNomeGeren 	:= ""


cQuery := " SELECT PESO=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0) "
cQuery += " ELSE SUM(D2_QUANT*B1_PESOR) END, " 
cQuery += " VALOR=SUM(D2_TOTAL), F2_VEND1, A3_GEREN, A3_SUPER, A3_NOME, F2_CLIENTE, F2_LOJA, A1_NREDUZ,F2_EMISSAO, A3_EMAIL, Z7_VALOR,Z7_KILO, Z7_MESANO "
cQuery += " FROM SD2020 SD2 WITH (NOLOCK),  "
cQuery += " SB1010 SB1 WITH (NOLOCK), "
cQuery += " SF2020 SF2 WITH (NOLOCK), "
cQuery += " SA3010 SA3 WITH (NOLOCK),  "
cQuery += " SA1010 SA1 WITH (NOLOCK),   "
cQuery += " SZ7020 SZ7 WITH (NOLOCK) "
cQuery += " WHERE D2_EMISSAO >= '" + DTOS(dData1) + "' AND D2_EMISSAO <= '" + DTOS(dData2) + "' "
cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += " AND D2_TIPO = 'N' " 
cQuery += " AND RTRIM(D2_TP) != 'AP' " //Despreza Apara 
cQuery += " AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "
cQuery += " AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND SA1.D_E_L_E_T_ = ''  "
cQuery += " AND SA3.D_E_L_E_T_ = ''  "
cQuery += " AND SF2.D_E_L_E_T_ = '' " 
cQuery += " AND SB1.D_E_L_E_T_ = ''  "
cQuery += " AND SZ7.D_E_L_E_T_ = ''  "
cQuery += " AND D2_COD = B1_COD     "
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "
cQuery += " AND D2_DOC = F2_DOC      "
cQuery += " AND D2_SERIE = F2_SERIE  "
cQuery += " AND D2_CLIENTE = F2_CLIENTE "
cQuery += " AND D2_LOJA = F2_LOJA       "
cQuery += " AND F2_CLIENTE = A1_COD     "
cQuery += " AND F2_LOJA = A1_LOJA       "
cQuery += " AND F2_VEND1 = A3_COD "
cQuery += " AND F2_DUPL <> ' '          "
cQuery += " AND SF2.D_E_L_E_T_ = ''     "
cQuery += " AND SZ7.Z7_MESANO = '102009' "
cQuery += " AND F2_VEND1 = Z7_REPRESE  "
cQuery += " GROUP BY D2_SERIE, F2_VEND1, A3_NOME, F2_CLIENTE, F2_LOJA, A1_NREDUZ, F2_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, Z7_MESANO, Z7_VALOR, Z7_KILO "
cQuery += " ORDER BY A3_SUPER, F2_VEND1, F2_CLIENTE, F2_LOJA, F2_EMISSAO "
//MemoWrite("\Temp\fatr012A.sql", cQuery )

TCQUERY cQuery NEW ALIAS "DIR"

TCSetField( "DIR", "F2_EMISSAO", "D")
TCSetField( "DIR", "D2_EMISSAO", "D")


DIR->( DbGoTop() )

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

While DIR->( !EOF() )

	cCodRepre := DIR->F2_VEND1
	cNomeRepre:= DIR->A3_NOME
	nMetaR	  := DIR->Z7_VALOR
	nMetaK	  := DIR->Z7_KILO
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
	cSuper	:= ""
	cNomeSuper := "" 
	cGeren	:= ""
	cNomeGeren := ""
	
	If !Empty( DIR->A3_SUPER )                    ////É REPRESENTANTE
		cSuper  := DIR->A3_SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME
		
		If Ascan( aSuper, DIR->A3_SUPER ) = 0
			Aadd( aSuper, DIR->A3_SUPER )	 			
		Endif
		
	Elseif !Empty(DIR->A3_GEREN)				////É SUPERVISOR/COORDENADOR
		cGeren := DIR->A3_GEREN
		cSuper := DIR->F2_VEND1
		cNomeSuper := DIR->A3_NOME
		
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cGeren ))
		cNomeGeren := SA3->A3_NOME
		
	Elseif Empty(DIR->A3_SUPER) .AND. Empty(DIR->A3_GEREN)	////É GERENTE
		cGeren := DIR->F2_VEND1
		cNomeGeren := DIR->A3_NOME
	Endif
	 	 	
	Do While DIR->( !EOF() ) .And. DIR->F2_VEND1 = cCodRepre
	
		Do Case
			Case Month( DIR->F2_EMISSAO ) = nMes1			
			    nTotVM1 += DIR->VALOR
			    nTotPM1 += DIR->PESO
			Case Month( DIR->F2_EMISSAO ) = nMes2
			   	nTotVM2 += DIR->VALOR
			    nTotPM2 += DIR->PESO
			Case Month( DIR->F2_EMISSAO ) = nMes3
			    nTotVM3 += DIR->VALOR
			    nTotPM3 += DIR->PESO			    
			Case Month( DIR->F2_EMISSAO ) = nMes4
			    nTotVM4 += DIR->VALOR
			    nTotPM4 += DIR->PESO		
			Case Month( DIR->F2_EMISSAO ) = nMes5
			    nTotVM5 += DIR->VALOR
			    nTotPM5 += DIR->PESO				
			Case Month( DIR->F2_EMISSAO ) = nMes6
	   		    nTotVM6 += DIR->VALOR
			    nTotPM6 += DIR->PESO
		Endcase	           	
		DIR->(Dbskip())
	Enddo
	Aadd(aDadDIR, { cCodRepre, cNomeRepre, nMetaR, nMetaK ,;
					 nTotVM1, nTotPM1, nTotVM2, nTotPM2  ,;
					 nTotVM3, nTotPM3, nTotVM4, nTotPM4  ,;
					 nTotVM5, nTotPM5, nTotVM6, nTotPM6  ,;
					 cSuper, cNomeSuper, cGeren, cNomeGeren } ) 	 		

Enddo

DIR->( DbCloseArea() )

/////INICIALIZA A VARIÁVEL QUE CONTERÁ O CORPO DO HTML
cWeb	:= ""

/////CRIA O HTML
cDirHTM  := "\Temp\"    
cArqHTM  := "FATR012A-DIR.HTM"    //relatório DIRETORIA
nHandle := fCreate( cDirHTM + cArqHTM, 0 )
    
If nHandle = -1
     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif  


For nCta := 1 to Len(aDadDIR)	
	
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
	      	//cWeb := ""
	      	cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR012A/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF      
	      
	      ///Cabeçalho relatório
	      
			cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+ LF
			cWeb += '<td rowspan="2" width="410" font-family: Verdana><div align="center"><span class="style3" style="font-size:14px"><B>REPRESENTANTE</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center">' + LF
			cWeb += '<span class="style3"><b>META MENSAL</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td><td colspan="2"><div align="center">'+ LF
			cWeb += '<span class="style3" align="center"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td><tr>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF       //KG COLUNA META MENSAL
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '</strong></tr><br>'+ LF
			//cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana">   	'+LF //LINHA CLIENTE		
		
			nPag++
			nLinhas := 1
	
	   Endif	
//						1		2			3		4
//	Aadd(aDadDIR, { cCodRepre, cNomeRepre, nMetaR, nMetaK ,;
//						5		6			7		8
//					 nTotVM1, nTotPM1, nTotVM2, nTotPM2  ,;
//						9		10		11			12
//					 nTotVM3, nTotPM3, nTotVM4, nTotPM4  ,;
//						13		14		15			16
//					 nTotVM5, nTotPM5, nTotVM6, nTotPM6  ,;
//						17		18			19		20
//					 cSuper, cNomeSuper, cGeren, cNomeGeren } )		
	
	
	nLin++			   
	@nLin,000 PSAY Alltrim(SUBSTR( aDadDIR[nCta,2],1,20))	PICTURE "@!"   	//Nome Representante
	@nLin,020 PSAY aDadDIR[nCta,3]	PICTURE "@E 9,999,999.99" 	//Meta R$
	@nLin,033 PSAY aDadDIR[nCta,4]	PICTURE "@E 999,999.99"     //Meta KG
			   
	@nLin,045 PSAY TRANSFORM( aDadDIR[nCta,5],"@E 99,999,999.99")		//VM1 total valor mês 1
	@nLin,058 PSAY TRANSFORM( aDadDIR[nCta,6],"@E 9,999,999.99")		//PM1 total peso mês 1
	@nLin,072 PSAY TRANSFORM( aDadDIR[nCta,7],"@E 99,999,999.99") 		//VM2 total valor mês 2
	@nLin,087 PSAY TRANSFORM( aDadDIR[nCta,8],"@E 999,999.99")		//PM2 total peso mês 2
	@nLin,099 PSAY TRANSFORM( aDadDIR[nCta,9],"@E 99,999,999.99") 		//VM3 total valor mês 3
	@nLin,114 PSAY TRANSFORM( aDadDIR[nCta,10],"@E 9,999,999.99")	//PM3 total peso mês 3
	@nLin,128 PSAY TRANSFORM( aDadDIR[nCta,11],"@E 99,999,999.99")		//VM4 total valor mês 4
	@nLin,143 PSAY TRANSFORM( aDadDIR[nCta,12],"@E 9,999,999.99")	//PM4 total peso mês 4
	@nLin,158 PSAY TRANSFORM( aDadDIR[nCta,13],"@E 99,999,999.99")      	//VM5 total valor mês 5
	@nLin,173 PSAY TRANSFORM( aDadDIR[nCta,14],"@E 9,999,999.99")		//PM5 total peso mês 5
	@nLin,188 PSAY TRANSFORM( aDadDIR[nCta,15],"@E 99,999,999.99") 		//VM6 total valor mês 6
	@nLin,203 PSAY TRANSFORM( aDadDIR[nCta,16],"@E 9,999,999.99")		//PM6 total peso mês 6

	//nLin++
	
	////REPRESENTANTE E SUA META		   
	cWeb += '<td width="1000"><span class="style3">'+ Alltrim(SUBSTR( aDadDIR[nCta,2],1,15)) + '</span></td>'+LF   //REPRESENTANTE
	cWeb += '<td width="900"><span class="style3">' + Transform( aDadDIR[nCta,3] , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
	cWeb += '<td width="900"><span class="style3">' + Transform( aDadDIR[nCta,4] , "@E 999,999.99")+' </span></td>'+LF        //META KG
	////TOTAIS DO REPRESENTANTE
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,5],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,6],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,7],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,8],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,9],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,10],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,11],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,12],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,13],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,14],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,15],"@E 9,999,999.99")+ '</span></td>'+LF
	cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDadDIR[nCta,16],"@E 999,999.99")  + '</span></td>'+LF
	cWeb += '</tr>'+LF
	
	nLinhas++
	
	//////GRAVA O HTML
	Fwrite( nHandle, cWeb, Len(cWeb) )
	/////REINICIALIZA cWeb PARA NOVAS ADIÇÕES DE STRING (EVITA O ESTOURO AO FINAL DO ARRAY)
	cWeb := ""
	
Next

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

//////SELECIONA O EMAIL DESTINATÁRIO (DIRETORIA)
//cMailTo := "eurivan@ravaembalagens.com.br" 
cMailTo	:= "flavia.rocha@ravaembalagens.com.br"  //colocar o e-mail diretoria
cCopia  := ""
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
/*
lEnviou := U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
If lEnviou
     Msginfo("E-mail enviado com sucesso!")
Else
	Msbbox("E-mail não enviado")
Endif
*/

U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif



MS_FLUSH()
*/
// Habilitar somente para Schedule
Reset environment


Return
