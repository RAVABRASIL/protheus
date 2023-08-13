#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR11CMNU
//Objetivo: Relatório de Acompanhamento por Cliente  -  Ano 
//			Emitir (dentro do Siga) relatório das vendas por representante e enviar por e-mail
//          para a supervisão (dos seus respectivos representantes)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 13/04/2010
//
//--------------------------------------------------------------------------
/*/

********************************
User Function FATR11CMNU()
********************************


/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Previsao de entrega Transportadora "
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	"" 
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd 			 := {}
Local nLin			 := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR11CMNU" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR11CMNU" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FTR011C"
Private cString 	 := ""

titulo         		 := "Relatorio de Acompanhamento por Cliente (p/ Coordenadores)

Pergunte( cPerg ,.T. )

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


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
Local cQuery	:= ''
Local cQuery2	:= ""
Local nQTD:=0 
Local aDadSu	:= {}
Local aDadSup	:= {}
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

Local cCliente	:= ""
Local cLoja	  	:= ""
Local cNomeCli	:= ""
Local cCodRepre	:= ""
Local cCodUser	:= ""
Local cCoordenador:= ""
Local cAnoM1 := ""
Local cAnoM2 := ""
Local cAnoM3 := ""
Local cAnoM4 := ""
Local cAnoM5 := ""
Local cAnoM6 := ""

Local cAnoMe1 := ""
Local cAnoMe2 := ""
Local cAnoMe3 := ""
Local cAnoMe4 := ""
Local cAnoMe5 := ""

Local cMes5	:= ""
Local cMes4	:= ""
Local cMes3	:= ""
Local cMes2	:= ""
Local cMes1	:= ""

Local nMes5	:= ""
Local nMes4	:= ""
Local nMes3	:= ""
Local nMes2	:= ""
Local nMes1	:= ""
Local nMedia	:= 0
Local cUFRepre	:= ""
Local lEnviou	:= .F.

Private cMailDestino := ""
Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")
Private aMeses		:= {}
Private aNomMeses	:= {}
Private nPosMes		:= 0
Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 

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
Private aUsua		:= {}


cCodUser := __CUSERID
//msgbox(cCodUser)

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailDestino := Alltrim(aUsua[1][14])
Endif



dData2 := LastDay(dDatabase)
dData1 := dData2 - 180

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Acompanhamento (Vendas de Sacos) por Cliente (p/ Coordenadores) - " + cStrAno + ""

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

cMes6   := ""
cMes5	:= ""
cMes4	:= ""
cMes3	:= ""
cMes2	:= ""
cMes1	:= ""

nMes6   := ""
nMes5	:= ""
nMes4	:= ""
nMes3	:= ""
nMes2	:= ""
nMes1	:= ""

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
	nMes1 := aMeses[nPosMes + 8 ]     //8
		
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10 
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ) ,3,2)  	//dez/09
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//nov/09
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//out/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//set/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)		//ago/09
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//jan/10
	cAnoMe5 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	cAnoMe4 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//out/09
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//set/09

Elseif nPosMes = 2   //se for Fevereiro
//set, out, nov, dez, jan, fev
	nMes6 := aMeses[nPosMes]         //2
	nMes5 := aMeses[nPosMes - 1 ]    //1
	nMes4 := aMeses[nPosMes + 11]    //12
	nMes3 := aMeses[nPosMes + 10]    //11
	nMes2 := aMeses[nPosMes + 9]     //10
	nMes1 := aMeses[nPosMes + 8 ]    //09
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//fev/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//jan/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//dez/09
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//nov/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//out/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)		//set/09   
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//fev/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe4 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//out/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//set/09
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//mar/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 		//fev/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 )	//dez/09
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//nov/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//out/09
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )    	//abr/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 		//mar/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 		//fev/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//dez/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//nov/09
	
Elseif nPosMes = 5	// se for Maio
//dez, jan, fev, mar, abr, maio
	nMes6 := aMeses[nPosMes]         //5
	nMes5 := aMeses[nPosMes - 1 ]    //4
	nMes4 := aMeses[nPosMes - 2 ]    //3
	nMes3 := aMeses[nPosMes - 3 ]    //2
	nMes2 := aMeses[nPosMes - 4 ]    //1
	nMes1 := aMeses[nPosMes + 7 ]    //12
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)   	//maio/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jan/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1 , 4 ),3,2)	//dez/09
	
	cAnoMe6 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//mar/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//fev/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//jan/10
	cAnoMe1 	:= StrZero( Year(dData2) - 1 , 4 )	//dez/09
	
Elseif nPosMes = 6	// se for Junho
//jan, fev, mar, abr, maio, jun
	nMes6 := aMeses[nPosMes]         //6
	nMes5 := aMeses[nPosMes - 1 ]    //5
	nMes4 := aMeses[nPosMes - 2 ]    //4
	nMes3 := aMeses[nPosMes - 3 ]    //3
	nMes2 := aMeses[nPosMes - 4 ]    //2
	nMes1 := aMeses[nPosMes - 5 ]    //1
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2),  4 ),3,2)   	//junho/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//fev/10 
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jan/10 
	
	cAnoMe6 	:= StrZero( Year(dData2),  4 ) 	//junho/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//mar/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//fev/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//jan/10
		
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )  	//julho/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//mar/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//mar/10
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )  	//ago/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//abr/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//abr/10
	
Elseif nPosMes = 9	// se for Setembro
//abr, maio, jun, jul, ago, set
	nMes6 := aMeses[nPosMes]        //9
	nMes5 := aMeses[nPosMes - 1 ]   //8
	nMes4 := aMeses[nPosMes - 2 ]   //7
	nMes3 := aMeses[nPosMes - 3 ]   //6
	nMes2 := aMeses[nPosMes - 4 ]   //5
	nMes1 := aMeses[nPosMes - 5 ]   //5
	
	cAnoM6 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//set/10
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//maio/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//abr/10
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )   //set/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//maio/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//abr/10
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )  	//out/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//junho/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//maio/10
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )  	//nov/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//out/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//julho/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//junho/10
	
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
	
	cAnoMe6 	:= StrZero( Year(dData2), 4 )  	//dez/10
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//nov/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//out/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 )	//ago/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//jul/10
	
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


Cabec1         := "CLIENTE                |   "+ cMes1 + cAnoM1+"        |    "+ cMes2 + cAnoM2+"        |  "+ cMes3 + cAnoM3 + "          |  "+ cMes4 + cAnoM4 + "          |   "+ cMes5 + cAnoM5 + "        | " + cMes6 + cAnoM6 + "           |       MEDIA "
Cabec2		   := "                       |    R$         KG      |  R$           KG       | R$          KG         |   R$        KG         |  R$            KG     |    R$            KG    |           R$"           

///////fim da montagem do cabeçalho


/////////////////////////////////////////////

/* 
cQuery := " SELECT PESO=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0) "+LF
cQuery += " ELSE SUM(D2_QUANT*B1_PESOR) END, " +LF
cQuery += " VALOR=SUM(D2_TOTAL), F2_VEND1, A3_NOME, F2_CLIENTE, F2_LOJA, A1_NREDUZ,F2_EMISSAO, A3_GEREN, A3_SUPER " +LF
cQuery += " FROM SD2020 SD2 WITH (NOLOCK),  "+LF
cQuery += " SB1010 SB1 WITH (NOLOCK), "+LF
cQuery += " SF2020 SF2 WITH (NOLOCK), "+LF
cQuery += " SA3010 SA3 WITH (NOLOCK),  "+LF
cQuery += " SA1010 SA1 WITH (NOLOCK)   "+LF
cQuery += " WHERE D2_EMISSAO >= '" + DTOS(dData1) + "' AND D2_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "+LF
cQuery += " AND D2_TIPO = 'N' " +LF
cQuery += " AND RTRIM(D2_TP) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND D2_COD = B1_COD     "+LF
cQuery += " AND D2_DOC = F2_DOC      "+LF
cQuery += " AND D2_SERIE = F2_SERIE  "+LF
cQuery += " AND D2_CLIENTE = F2_CLIENTE "+LF
cQuery += " AND D2_LOJA = F2_LOJA       "+LF
cQuery += " AND F2_CLIENTE = A1_COD     "+LF
cQuery += " AND F2_LOJA = A1_LOJA       "+LF
cQuery += " AND F2_VEND1 = A3_COD "+LF
//cQuery += " AND A3_SUPER <> '' "+LF
cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(mv_par01) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(mv_par02) + "' "+LF
cQuery += " AND F2_DUPL <> ' '          "+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''     "+LF
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF

//cQuery += " AND RTRIM(A3_SUPER) = '0248' " + LF

cQuery += " GROUP BY D2_SERIE, F2_VEND1, A3_NOME, F2_CLIENTE, F2_LOJA, A1_NREDUZ, F2_EMISSAO, A3_GEREN, A3_SUPER "+LF
cQuery += " ORDER BY A3_SUPER, F2_VEND1, F2_CLIENTE, F2_LOJA, F2_EMISSAO "+LF
*/

//cQuery := " SELECT PESO=CASE WHEN C5_VEND1 NOT LIKE '%VD%' THEN Sum(0) "+LF
cQuery := " SELECT PESO = SUM(C6_QTDVEN * B1_PESOR) , " +LF
cQuery += " VALOR=SUM(C6_VALOR), C5_VEND1, A3_NOME, A3_EST, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ,C5_EMISSAO, A3_GEREN, A3_SUPER " +LF
cQuery += " FROM " +LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + LF
cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' "+LF
cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' "+LF
cQuery += " AND RTRIM(SB1.B1_TIPO) != 'AP' "+LF //Despreza Apara 
cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' "+LF
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
cQuery += " AND C6_PRODUTO = B1_COD     "+LF
cQuery += " AND C6_NUM = C5_NUM      "+LF
cQuery += " AND C6_CLI = C5_CLIENTE "+LF
cQuery += " AND C6_LOJA = C5_LOJACLI       "+LF
cQuery += " AND C5_CLIENTE = A1_COD     "+LF
cQuery += " AND C5_LOJACLI = A1_LOJA       "+LF
cQuery += " AND C5_VEND1 = A3_COD "+LF
cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(mv_par01) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(mv_par02) + "' "+LF
cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF

//cQuery += " AND RTRIM(A3_SUPER) = '0248' " + LF

cQuery += " GROUP BY C5_VEND1, A3_NOME, A3_EST, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, C5_EMISSAO, A3_GEREN, A3_SUPER "+LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO "+LF
MemoWrite("\TempQry\fatr11Cmnu.sql", cQuery )
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
	cSuper 		:= SUP->A3_SUPER
	cNomeSuper 	:= ""
	cMailSuper  := ""
	cUFRepre		:= SUP->A3_EST
	
	cCodRepre	:= SUP->C5_VEND1
	cNomeRepre	:= SUP->A3_NOME
	
	cCliente	:= SUP->C5_CLIENTE
	cLoja		:= SUP->C5_LOJACLI
	cNomeCli	:= SUP->A1_NREDUZ
	nMedia		:= 0
	
	If !Empty( cSuper )
		DBSELECTAREA("SA3")
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)	    
	Endif
	
	
	////////////////////////////////////////////////////////////////
	//VERIFICA OS PEDIDOS EM CARTEIRA DESTE VENDEDOR/REPRESENTANTE
	////////////////////////////////////////////////////////////////
	cQuery2 := ""
	/////LEVANTA OS TOTAL EM R$ E KG DOS PEDIDOS EM CARTEIRA DESTE REPRESENTANTE
	cQuery2 := " SELECT  SC5.C5_VEND1, SUM( SC6.C6_VALOR ) AS TOTALPED, "+LF
	cQuery2 += " SUM( SC9.C9_QTDLIB * SB1.B1_PESOR ) AS TOTALPESO "+LF
	cQuery2 += " FROM " + RetSqlName( "SB1" ) + " SB1, " +LF
	cQuery2 += " " + RetSqlName( "SC5" ) + " SC5, " +LF
	cQuery2 += " " + RetSqlName( "SC6") + " SC6, " +LF
	cQuery2 += " " + RetSqlName( "SC9") + " SC9 " +LF
	cQuery2 += " WHERE C5_TIPO = 'N' " +LF
	cQuery2 += " AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 " +LF
	cQuery2 += " and RTRIM(SC5.C5_CLIENTE) = '" + Alltrim(cCliente) + "' "+LF	
	cQuery2 += " and RTRIM(SC5.C5_LOJACLI) = '" + Alltrim(cLoja) + "' "+LF	
	cQuery2 += " AND SC5.C5_NUM = SC6.C6_NUM "+LF
	cQuery2 += " AND SC6.C6_NUM = SC9.C9_PEDIDO "+LF
	cQuery2 += " AND SC6.C6_ITEM = SC9.C9_ITEM "+LF
	cQuery2 += " AND SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '10' "+LF
	cQuery2 += " AND SC6.C6_BLQ <> 'R' " +LF
	cQuery2 += " AND SB1.B1_TIPO <> 'AP' " +LF //= 'PA' "
	cQuery2 += " AND SC6.C6_PRODUTO = SB1.B1_COD "+LF
	cQuery2 += " AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "+LF
	cQuery2 += " AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "+LF
	cQuery2 += " AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "+LF
	cQuery2 += " AND SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "+LF
	cQuery2 += " GROUP BY SC5.C5_NUM , SC5.C5_VEND1 "+LF 
	cQuery2 += " ORDER BY SC5.C5_NUM "+LF
	//MemoWrite("C:\CARTEIRA.SQL" , cQuery2)	
	If Select("CART") > 0
		DbSelectArea("CART")
		DbCloseArea()
	EndIf
	TCQUERY cQuery2 NEW ALIAS "CART"
	CART->( DbGoTop() )
	While CART->( !EOF() )
		nTotCartR  += CART->TOTALPED
		nTotCartK  += CART->TOTALPESO	    	
    	CART->(DBSKIP())
	Enddo
	
	
	Do While Alltrim(SUP->C5_CLIENTE) = Alltrim(cCliente) .AND. Alltrim(SUP->C5_LOJACLI) = Alltrim(cLoja)
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
			Case Month( SUP->C5_EMISSAO ) = nMes4
				nTotVM4 += SUP->VALOR
				nTotPM4 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes5
				nTotVM5 += SUP->VALOR
				nTotPM5 += SUP->PESO
			Case Month( SUP->C5_EMISSAO ) = nMes6
				nTotVM6 += SUP->VALOR
				nTotPM6 += SUP->PESO
		Endcase	
	
	
		SUP->(DBSKIP())	
	Enddo
	
/*
	//					1			2		  3		  4		 5         6		7
	Aadd(aDadSu, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper ,;
   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotCartR, nTotCartK, cMailSuper, SUP->A3_EST } )		
 	
*/

	nMedia := ( (nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4 + nTotVM5 + nTotVM6 ) / 6 )

	//					1			2		  3		  4		 5         6		7
	Aadd(aDadSup, { cCodRepre, cNomeRepre, cCliente, cLoja, cNomeCli, cSuper, cNomeSuper ,;
   					nTotVM1, nTotPM1, nTotVM2, nTotPM2,	nTotVM3, nTotPM3,;
   					nTotVM4, nTotPM4, nTotVM5, nTotPM5,	nTotVM6, nTotPM6, cMailSuper, cUFRepre, nMedia } )		
//						14		15		16		17		18			19		20		  21        22
 		 
Enddo

//aDadSu := aDadSup    
aDadSu := Asort( aDadSup,,, { |X,Y| X[6] + X[1] + Transform(X[22],"@E 99,999,999.99")  <  Y[6] + Y[1] + Transform(Y[22] ,"@E 99,999,999.99") } ) 


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
nTotVM6 := 0

nTotCartR	:= 0 
nTotCartK	:= 0

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
nTotMedia	:= 0 
lEnviou		:= .F.

nCta := 1
                		
Do while nCta <= Len(aDadSu)
  	    
    nPag := 1
    //cCodSuper := aSuper[fr] 
    //cNomeSuper:= ""
   	cCodSuper := aDadSu[nCta,6]
   	cNomeSuper:= Alltrim(aDadSu[nCta,7])
   	cMailSuper:= Alltrim(aDadSu[nCta,20])
   	
	cWeb := ""
		
	////CRIA O ARQUIVO DO HTML
	cDirHTM  := "\Temp\"    
	cArqHTM  := "FATR11CMNU-" + Alltrim(cCodSuper) +".HTM"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
						    
	If nHandle = -1
	     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
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
		
	If nLinhas >= 49
		
		nLinhas := 5
	    ///Cabeçalho PÁGINA
      	//cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
		cWeb += '<html><head>'+ LF
		cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
		cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
		cWeb += '<tr>    <td>'+ LF
		cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
		cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
		cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
		cWeb += '<tr>        <td>SIGA /FATR11C_MNU/v.P10</td>'+ LF
		cWeb += '<td align="center">' + titulo + '</td>'+ LF
		cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
		cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
		cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
		cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
		cWeb += '</table></head>'+ LF            
		      
		cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'+LF				
		cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
		cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cCodSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr>'+LF
		nLinhas++
		
		////linha em branco
		cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
					
		cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
		cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadSu[nCta,1]) + "-" + Alltrim(aDadSu[nCta,2]) +'</span></td>'+LF				
		cWeb += '</table>' + LF
		nLinhas++
						
		///Cabeçalho relatório		      
		cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
		cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
		//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
		cWeb += '<tr>'+LF
		//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td><tr>'+ LF
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
		cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
		cWeb += '</strong></tr>'+ LF			
		   
		nPag++
				
		nLinhas++
		nLinhas++
		
	Endif		

		Do while nCta <= Len(aDadSu) .and. Alltrim(aDadSu[nCta,6]) == Alltrim(cCodSuper)
		
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
		   
		   If nLinhas >= 49  
		      
		      	nPag++
			    cWeb += '<br>'+LF    
		      	cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html><head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR11C_MNU/v.P10</td>'+ LF
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
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
				cWeb += '<tr>'+ LF
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
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
				cWeb += '</strong></tr>'+ LF
			    
				
				nLinhas := 5
				nLinhas++
		        
		   Endif  
		   
		   
		   If nCta = 1			   
			   	
			   	cQuery := ""
				cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(cCodRepre) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				//cQuery += " AND SZ7.Z7_MESANO = '102009' "+LF
				cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4), LEFT(Z7_MESANO,2) "+LF
				//MemoWrite("\TempQry\11CMETAA.sql", cQuery )
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
										
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
						nMetaR4 += META->Z7_VALOR					
						nMetaK4 += META->Z7_KILO
									
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
						nMetaR5 += META->Z7_VALOR
						nMetaK5 += META->Z7_KILO
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
						nMetaR6 += META->Z7_VALOR
						nMetaK6 += META->Z7_KILO
					Endif				
					META->(Dbskip())
				Enddo			
		   			   
		   Endif
		   	 
		   If nCta > 1                                     ////se o representante atual for diferente do anterior, precisa verificar:
		    If ( Alltrim(aDadSu[nCta,6]) = Alltrim(aDadSu[nCta - 1,6]) )     ////se o Supervisor atual é igual ao anterior, se sim, pode efetuar total por representante
		    										       ///senão o programa irá totalizar antes de começar a imprimir o representante.
		   		If ( Alltrim(aDadSu[nCta,1]) != Alltrim(aDadSu[nCta - 1,1]) )
		   			

				   //nLin++
				   @nLin,00 PSAY Replicate("-",200)
				   nLin++
				   @nLin,000 PSAY "Total: "
				   @nLin,017 PSAY TRANSFORM( nTotVM1,"@E 9,999,999.99")
				   @nLin,030 PSAY TRANSFORM( nTotPM1,"@E 999,999.99") 
				   @nLin,042 PSAY TRANSFORM( nTotVM2,"@E 9,999,999.99")
				   @nLin,056 PSAY TRANSFORM( nTotPM2,"@E 999,999.99") 
				   @nLin,067 PSAY TRANSFORM( nTotVM3,"@E 9,999,999.99")
				   @nLin,081 PSAY TRANSFORM( nTotPM3,"@E 999,999.99") 
				   @nLin,092 PSAY TRANSFORM( nTotVM4,"@E 9,999,999.99")
				   @nLin,106 PSAY TRANSFORM( nTotPM4,"@E 999,999.99") 
				   @nLin,117 PSAY TRANSFORM( nTotVM5,"@E 9,999,999.99")
				   @nLin,131 PSAY TRANSFORM( nTotPM5,"@E 999,999.99") 
				   //@nLin,143 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
				   //@nLin,157 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99") 		   
				   @nLin,143 PSAY TRANSFORM( nTotVM6,"@E 9,999,999.99")
				   @nLin,157 PSAY TRANSFORM( nTotPM6,"@E 999,999.99") 		   
				   @nLin,171 PSAY TRANSFORM( nTotMedia,"@E 9,999,999.99") 		   
			
				   	nLin++
					@nLin,000 PSAY "META: "
					@nLin,017 PSAY TRANSFORM( nMetaR1 ,"@E 9,999,999.99")
					@nLin,030 PSAY TRANSFORM( nMetaK1 ,"@E 999,999.99")
					@nLin,042 PSAY TRANSFORM( nMetaR2,"@E 9,999,999.99")
				   	@nLin,056 PSAY TRANSFORM( nMetaK2,"@E 999,999.99") 
				   	@nLin,067 PSAY TRANSFORM( nMetaR3,"@E 9,999,999.99")
				   	@nLin,081 PSAY TRANSFORM( nMetaK3,"@E 999,999.99") 
				   	@nLin,092 PSAY TRANSFORM( nMetaR4,"@E 9,999,999.99")
				   	@nLin,106 PSAY TRANSFORM( nMetaK4,"@E 999,999.99") 
				   	@nLin,117 PSAY TRANSFORM( nMetaR5,"@E 9,999,999.99")
				   	@nLin,131 PSAY TRANSFORM( nMetaK5,"@E 999,999.99") 
				   	@nLin,143 PSAY TRANSFORM( nMetaR6,"@E 9,999,999.99")
				   	@nLin,157 PSAY TRANSFORM( nMetaK6,"@E 999,999.99") 		   
					nLin++
					@nLin,00 PSAY Replicate("=", 200)
					nLin++	
				   
					cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</span></td>'+LF
					//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")+ '</span></td>'+LF
					//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</b></span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 9,999,999.99")+ '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")  + '</b></span></td>'+LF
					cWeb += '</tr>'+LF //</table><br>'+LF		   		    
					
					nLinhas++
					
					cWeb += '<td width="300" align="center"><span class="style3"><b>META</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR1,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK1,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR2,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK2,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR3,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK3,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR4,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK4,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR5,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK5,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR6,"@E 99,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK6,"@E 9,999,999.99")  + '</span></td>'+LF
					cWeb += '<td width="300" align="right"><span class="style3"><b></span></td>'+LF //media
					cWeb += '</b></strong></tr></table><br>'+LF  
				  
				   	nLinhas++
				   	
				   	If nLinhas <= 40    //SE MUDOU O REPRESENTANTE E NÃO PREENCHEU A PÁGINA, PODE QUEBRAR MESMO ASSIM
				   		//cWeb += '<div class="quebra_pagina">A pagina quebra neste ponto->' + str(nLinhas) +'</div>'+LF
				   		cWeb += '<div class="quebra_pagina"> </div>'+LF
				   		nPag++
				   		
				   	Endif
				   	nLinhas := 5
				   	
				   	nLin++
				   	nLin++
				   	//@nLin,00 PSAY "Coordenador: " + Alltrim(aDadSu[nCta,6]) + "-" + Alltrim(aDadSu[nCta,7])
				   	@nLin,000 PSAY "Representante: " + Alltrim(aDadSu[nCta,1]) + "-" + Alltrim(aDadSu[nCta,2])

		   			nLin++
		   			nLin++											
									
		   			nTotPM1 := 0
					nTotPM2 := 0   
					nTotPM3 := 0
					nTotPM4 := 0
					nTotPM5 := 0
					nTotPM6 := 0
					
					nTotCartR:= 0
					nTotCartK:= 0
					
					nTotMedia:= 0
									   
					nTotVM1 := 0
					nTotVM2 := 0   
					nTotVM3 := 0
					nTotVM4 := 0
					nTotVM5 := 0
					nTotVM6 := 0
					
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
					
					///Cabeçalho html
				    cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
					cWeb += '<html><head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR011C/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					cWeb += '</table></head>'+ LF   
					
					cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Arial">'+LF
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadSu[nCta,1]) + "-" + Alltrim(aDadSu[nCta,2]) + '</span></td>'+LF					
					cWeb += '</table>' + LF
					
					nLinhas++
								
					///Cabeçalho relatório		      
					cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
					cWeb += '<td rowspan="2" width="410" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+ LF
					//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
					cWeb += '</tr>'+LF
					
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
					cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '</strong></tr>'+ LF
					
					nLinhas++
					nLinhas++
					
					nMetaR := 0
					nMetaK := 0
					
					////GRAVA O HTML
					Fwrite( nHandle, cWeb, Len(cWeb) )
					cWeb := "" 
					
					////localiza a meta do representante
					cQuery := ""
					cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
					cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
					cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
					cQuery += " WHERE RTRIM(A3_COD) = '"+ Alltrim(aDadSu[nCta,1]) + "' "+LF 
					cQuery += " AND A3_COD = Z7_REPRESE "+LF
					cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
					cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
					cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
					cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
					cQuery += " ORDER BY RIGHT(Z7_MESANO,4), LEFT(Z7_MESANO,2) "+LF
					
					//MemoWrite("\TempQry\11CMETAA.sql", cQuery )
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
											
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
							nMetaR4 += META->Z7_VALOR					
							nMetaK4 += META->Z7_KILO
										
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
							nMetaR5 += META->Z7_VALOR
							nMetaK5 += META->Z7_KILO
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
							nMetaR6 += META->Z7_VALOR
							nMetaK6 += META->Z7_KILO
						Endif				
						META->(Dbskip())
					Enddo			
				   
		        Endif
		        
		    Else		///mudou o supervisor	    	
		    
				
				////localiza a meta do representante
					cQuery := ""
					cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
					cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
					cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
					cQuery += " WHERE RTRIM(A3_COD) = '"+ Alltrim(cCodRepre) + "' "+LF 
					cQuery += " AND A3_COD = Z7_REPRESE "+LF
					cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
					cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
					cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
					cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
					cQuery += " ORDER BY RIGHT(Z7_MESANO,4), LEFT(Z7_MESANO,2) "+LF
					MemoWrite("\TempQry\11CMETAA.sql", cQuery )
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
											
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
							nMetaR4 += META->Z7_VALOR					
							nMetaK4 += META->Z7_KILO
										
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
							nMetaR5 += META->Z7_VALOR
							nMetaK5 += META->Z7_KILO
						Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
							nMetaR6 += META->Z7_VALOR
							nMetaK6 += META->Z7_KILO
						Endif				
						META->(Dbskip())
					Enddo			    
		    
		    Endif    
		   Endif
		   

			////mês 1
			@nLin,000 PSAY SUBSTR(aDadSu[nCta,5],1,15) + "-" + aDadSu[nCta,21]	PICTURE "@!"     	///NOME
			@nLin,017 PSAY aDadSu[nCta,8]		PICTURE "@E 9,999,999.99"   ///VALOR
			@nLin,030 PSAY aDadSu[nCta,9]		PICTURE "@E 999,999.99"     ///PESO
			////acumulando totais....
			nTotVM1 += aDadSu[nCta,8]
			nTotPM1 += aDadSu[nCta,9]					  
					    
			////mês 2
			@nLin,042 PSAY aDadSu[nCta,10]	PICTURE "@E 9,999,999.99"
			@nLin,056 PSAY aDadSu[nCta,11]	PICTURE "@E 999,999.99"
			nTotVM2 += aDadSu[nCta,10]
			nTotPM2 += aDadSu[nCta,11]			   
			
			////mês 3
			@nLin,067 PSAY aDadSu[nCta,12]	PICTURE "@E 9,999,999.99"
			@nLin,081 PSAY aDadSu[nCta,13]	PICTURE "@E 999,999.99"		
			nTotVM3 += aDadSu[nCta,12]
			nTotPM3 += aDadSu[nCta,13] 
			
			////mês 4
			@nLin,092 PSAY aDadSu[nCta,14]	PICTURE "@E 9,999,999.99"
			@nLin,106 PSAY aDadSu[nCta,15]	PICTURE "@E 999,999.99"
			nTotVM4 += aDadSu[nCta,14]
			nTotPM4 += aDadSu[nCta,15]
			
			////Mês 5
			@nLin,117 PSAY aDadSu[nCta,16]	PICTURE "@E 9,999,999.99"
			@nLin,131 PSAY aDadSu[nCta,17]	PICTURE "@E 999,999.99"
			nTotVM5 += aDadSu[nCta,16]
			nTotPM5 += aDadSu[nCta,17]
			
			////Carteira
			//@nLin,143 PSAY aDadSu[nCta,18]		PICTURE "@E 99,999,999.99"  ///CARTEIRA R$
   			//@nLin,157 PSAY aDadSu[nCta,19]		PICTURE "@E 99,999,999.99"  ///CARTEIRA KG
   			//nTotCartR += aDadSu[nCta,18]
			//nTotCartK += aDadSu[nCta,19]
			
			////Mês 6
			@nLin,143 PSAY aDadSu[nCta,18]		PICTURE "@E 9,999,999.99"  
   			@nLin,157 PSAY aDadSu[nCta,19]		PICTURE "@E 999,999.99"  
   			nTotVM6 += aDadSu[nCta,18]
   			nTotPM6 += aDadSu[nCta,19]
   			
   			////Média
			@nLin,172 PSAY aDadSu[nCta,22]		PICTURE "@E 9,999,999.99"  
   			nTotMedia += aDadSu[nCta,22]

					    
			cWeb += '<td width="1000"><span class="style3">'+ Alltrim(SUBSTR(aDadSu[nCta,5],1,15)) + "-" + Alltrim(aDadSu[nCta,21])+ '</span></td>'+LF      //NOME CLIENTE
			//coluna mês 1
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,8], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,9],"@E 999,999.99")+' </span></td>'+LF        //KG					

			//coluna mês 2
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,10], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,11],"@E 999,999.99")+' </span></td>'+LF        //KG
							
			//coluna mês 3
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,13],"@E 999,999.99")+' </span></td>'+LF        //KG							
					
			//coluna mês 4
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,15],"@E 999,999.99")+' </span></td>'+LF        //KG					
				
			//coluna mês5
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(aDadSu[nCta,17],"@E 999,999.99")+' </span></td>'+LF //KG						
				    
			//coluna carteira
			
			////coluna mês 6
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,19],"@E 999,999.99")+' </span></td>'+LF
			
			//coluna média
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadSu[nCta,22], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '</tr>'+LF        //K
			
			If nCta = Len(aDadSu)		///se for o último representante, para evitar que fique sem fazer o total, coloco agora o TOTAL
				   
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
			   nLin++
			   @nLin,00 PSAY Replicate("-",200)
			   nLin++
			   @nLin,000 PSAY "Total: "
			   		   		   
			   @nLin,017 PSAY TRANSFORM( nTotVM1,"@E 9,999,999.99")
			   @nLin,030 PSAY TRANSFORM( nTotPM1,"@E 999,999.99") 
			   @nLin,042 PSAY TRANSFORM( nTotVM2,"@E 9,999,999.99")
			   @nLin,056 PSAY TRANSFORM( nTotPM2,"@E 999,999.99") 
			   @nLin,067 PSAY TRANSFORM( nTotVM3,"@E 9,999,999.99")
			   @nLin,081 PSAY TRANSFORM( nTotPM3,"@E 999,999.99") 
			   @nLin,092 PSAY TRANSFORM( nTotVM4,"@E 9,999,999.99")
			   @nLin,106 PSAY TRANSFORM( nTotPM4,"@E 999,999.99") 
			   @nLin,117 PSAY TRANSFORM( nTotVM5,"@E 9,999,999.99")
			   @nLin,131 PSAY TRANSFORM( nTotPM5,"@E 999,999.99")
			   //@nLin,143 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
			   //@nLin,157 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99")  
			   @nLin,143 PSAY TRANSFORM( nTotVM6,"@E 9,999,999.99")
			   @nLin,157 PSAY TRANSFORM( nTotPM6,"@E 999,999.99")  
			   @nLin,172 PSAY TRANSFORM( nTotMedia,"@E 9,999,999.99")  
			   				   	
			   ////localiza a meta do representante
				cQuery := ""
				cQuery += " SELECT A3_SUPER, SUM(Z7_VALOR) as Z7_VALOR, SUM(Z7_KILO) as Z7_KILO, Z7_MESANO, Z7_TIPO "+LF 
				cQuery += " FROM SA3010 SA3 WITH (NOLOCK),  "+LF
				cQuery += " SZ7020 SZ7 WITH (NOLOCK) "+LF
				cQuery += " WHERE RTRIM(A3_COD) = '"+ Alltrim(cCodRepre) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				cQuery += " AND RTRIM(SZ7.Z7_TIPO) = 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO, Z7_TIPO "+LF
				cQuery += " ORDER BY RIGHT(Z7_MESANO,4), LEFT(Z7_MESANO,2) "+LF
				//MemoWrite("\TempQry\11CMETAA.sql", cQuery )
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
											
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes4,2) + cAnoMe4 )
						nMetaR4 += META->Z7_VALOR					
						nMetaK4 += META->Z7_KILO
										
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes5,2) + cAnoMe5 )
						nMetaR5 += META->Z7_VALOR
						nMetaK5 += META->Z7_KILO
					
					Elseif Alltrim(META->Z7_MESANO) == Alltrim( Strzero(nMes6,2) + cAnoMe6 )
						nMetaR6 += META->Z7_VALOR
						nMetaK6 += META->Z7_KILO
					Endif				
					META->(Dbskip())
				Enddo			
			    nLin++
				@nLin,000 PSAY "META: "
				@nLin,017 PSAY TRANSFORM( nMetaR1,"@E 9,999,999.99")
				@nLin,030 PSAY TRANSFORM( nMetaK1,"@E 999,999.99")
				@nLin,042 PSAY TRANSFORM( nMetaR2,"@E 9,999,999.99")
				@nLin,056 PSAY TRANSFORM( nMetaK2,"@E 999,999.99") 
				@nLin,067 PSAY TRANSFORM( nMetaR3,"@E 9,999,999.99")
				@nLin,081 PSAY TRANSFORM( nMetaK3,"@E 999,999.99") 
				@nLin,092 PSAY TRANSFORM( nMetaR4,"@E 9,999,999.99")
				@nLin,106 PSAY TRANSFORM( nMetaK4,"@E 999,999.99") 
				@nLin,117 PSAY TRANSFORM( nMetaR5,"@E 9,999,999.99")
			   	@nLin,131 PSAY TRANSFORM( nMetaK5,"@E 999,999.99") 
			   	@nLin,143 PSAY TRANSFORM( nMetaR6,"@E 9,999,999.99")
			   	@nLin,157 PSAY TRANSFORM( nMetaK6,"@E 999,999.99")
				nLin++
				@nLin,00 PSAY Replicate("=", 200)	
			   
				cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 999,999.99")  + '</span></td>'+LF
				////CARTEIRA
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")+ '</span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '</tr>'+ LF //</table>'+LF
				
				nLinhas++
				
				cWeb += '<td width="900" align="center"><span class="style3"><b>META</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR1,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK1,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR2,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK2,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR3,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK3,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR4,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK4,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR5,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK5,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR6,"@E 9,999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK6,"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b></span></td>'+LF    //media
				cWeb += '</b></strong></tr></table>'+LF
				
				nLinhas++
				
				If nLinhas <= 40
					//cWeb += '<div class="quebra_pagina">A pagina quebra neste ponto ->'+ str(nLinhas) + '</div>'+LF
					cWeb += '<div class="quebra_pagina"> </div>'+LF
					nPag++                                                                   
				Endif
				
				nLinhas := 5
				
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
			    
			    
			    lUltimo := .T.
			    
			Endif
				           
		     nLin++	
		 
		 nCta++	
		 nLinhas++		 
		 	
		Enddo
				
		If !lUltimo
			/////TOTALIZA REPRESENTANTE
			//nLin++
			@nLin,00 PSAY Replicate("-",200)
			nLin++
			@nLin,000 PSAY "Total: "			
		   	@nLin,017 PSAY TRANSFORM( nTotVM1,"@E 9,999,999.99")
			@nLin,030 PSAY TRANSFORM( nTotPM1,"@E 999,999.99") 
			@nLin,042 PSAY TRANSFORM( nTotVM2,"@E 9,999,999.99")
			@nLin,056 PSAY TRANSFORM( nTotPM2,"@E 999,999.99") 
			@nLin,067 PSAY TRANSFORM( nTotVM3,"@E 9,999,999.99")
			@nLin,081 PSAY TRANSFORM( nTotPM3,"@E 999,999.99") 
			@nLin,092 PSAY TRANSFORM( nTotVM4,"@E 9,999,999.99")
			@nLin,106 PSAY TRANSFORM( nTotPM4,"@E 999,999.99") 
			@nLin,117 PSAY TRANSFORM( nTotVM5,"@E 9,999,999.99")
			@nLin,131 PSAY TRANSFORM( nTotPM5,"@E 999,999.99") 
			//@nLin,143 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
		   	//@nLin,157 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99") 		   		   
		   	@nLin,143 PSAY TRANSFORM( nTotVM6,"@E 9,999,999.99")
		   	@nLin,157 PSAY TRANSFORM( nTotPM6,"@E 999,999.99") 		   		   
		   	@nLin,171 PSAY TRANSFORM( nTotMedia,"@E 9,999,999.99") 		   		   
			
			nLin++
			@nLin,000 PSAY "META: "
			@nLin,017 PSAY TRANSFORM( nMetaR1,"@E 9,999,999.99")
			@nLin,030 PSAY TRANSFORM( nMetaK1,"@E 999,999.99")
			@nLin,042 PSAY TRANSFORM( nMetaR2,"@E 9,999,999.99")
			@nLin,056 PSAY TRANSFORM( nMetaK2,"@E 999,999.99") 
			@nLin,067 PSAY TRANSFORM( nMetaR3,"@E 9,999,999.99")
			@nLin,081 PSAY TRANSFORM( nMetaK3,"@E 999,999.99") 
			@nLin,092 PSAY TRANSFORM( nMetaR4,"@E 9,999,999.99")
			@nLin,106 PSAY TRANSFORM( nMetaK4,"@E 999,999.99") 
			@nLin,117 PSAY TRANSFORM( nMetaR5,"@E 9,999,999.99")
			@nLin,131 PSAY TRANSFORM( nMetaK5,"@E 999,999.99") 
			@nLin,143 PSAY TRANSFORM( nMetaR6,"@E 9,999,999.99")
		   	@nLin,157 PSAY TRANSFORM( nMetaK6,"@E 999,999.99") 		   		   
			nLin++
			@nLin,00 PSAY Replicate("=", 200)	
								   
			cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 9,999,999.99")+ '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 999,999.99")  + '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")+ '</span></td>'+LF
			//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</span></td></tr>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 9,999,999.99")  + '</span></td>'+LF
			
			cWeb += '</tr>'+LF //</table>'+LF   	    	
			
			nLinhas++
			
			cWeb += '<td width="900" align="center"><span class="style3"><b>META</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR1,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK1,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR2,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK2,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR3,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK3,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR4,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK4,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR5,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK5,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaR6,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nMetaK6,"@E 999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b></span></td>'+LF //MEDIA
			
			cWeb += '</b></strong></tr></table>'+LF
			
			nLinhas++
			
			If nLinhas <= 40
				//cWeb += '<div class="quebra_pagina">A pagina quebra neste ponto -->' + str(nLinhas) +'</div>'+LF
				cWeb += '<div class="quebra_pagina"> </div>'+LF
				nPag++
			Endif
			nLinhas := 5
			   		   		    
			////// FIM DO TOTAL			
			nTotVM1 := 0
			nTotVM2 := 0   
			nTotVM3 := 0
			nTotVM4 := 0
			nTotVM5 := 0
			nTotVM6 := 0 
			
			nTotPM1 := 0
			nTotPM2 := 0   
			nTotPM3 := 0
			nTotPM4 := 0
			nTotPM5 := 0
			nTotPM6 := 0
			
			nTotMedia:= 0
			
			nTotCartR:= 0
			nTotCartK:= 0
			
			nMetaR	 := 0
			nMetaK   := 0
			
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
			
	    
	    Endif
	    
	    
				        
	    ///FECHA O HTML PARA ENVIO
		cWeb += '</body> '
		cWeb += '</html> '
					
	    //////GRAVA O HTML 
	    Fwrite( nHandle, cWeb, Len(cWeb) )
		FClose( nHandle )
		//nRet := 0
		//nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browse
	
		//////ENVIA PARA O COORDENADOR
		cMailTo	  := cMailDestino
		cCopia  := "" 
		cCorpo  := titulo + "     - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := titulo
					
		lEnviou := U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
		nRet := 0
	    nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //esta funcionou, OK			
	
	    ///REINICIALIZA A VARIÁVEL QUE ARMAZENA O HTML		
		cWeb := ""
	    ////////		             	
 
Enddo
                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
If lEnviou
	MsgInfo("Você acaba de receber este relatório por E-mail!")
Endif
// Habilitar somente para Schedule
//Reset environment


Return

