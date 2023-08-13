#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR11DMNU
//Objetivo: Relatório de Acompanhamento por Cliente  -  Ano 
//			Emitir relatório das vendas por representante e enviar por e-mail
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 05/08/2010
//--------------------------------------------------------------------------
/*/

/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/


//REPRESENTANTES
//SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
************************************
User Function FATR11DMNU()
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
Private nomeprog     := "FATR11DMNU" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR11DMNU" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FTR011D"
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

//Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

Pergunte( cPerg ,.T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dData2 := LastDay(dDatabase)
dData1 := dData2 - 180

//dData2 := CTOD("31/03/2010")
//dData1 := dData2 - 1


cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Acompanhamento (Vendas de Sacos) por Cliente (p/ Representantes)  -  " + cStrAno + ""

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


//Cabec1         := "CLIENTE        |    "+ cMes1 + cAnoM1 +     "          |   "+ cMes2 + cAnoM2 +      "        |   "+ cMes3 + cAnoM3 +       "         |   "+ cMes4 + cAnoM4 + "         |   "+ cMes5 + cAnoM5 + "         |  "+ cMes6 + cAnoM6 + ""
//Cabec2		   := "               |    R$        KG          |    R$         KG      |  R$           KG       | R$          KG         |   R$        KG         |  R$            KG "

//EM 11/06/10 FOI SOLICITADO PELOS COORDENADORES E SR. VIANA QUE SE RETIRASSE AS COLUNAS "KG" E ACRESCENTASSE 
//UMA COLUNA "MÉDIA"

Cabec1         := "CLIENTE                       |    "+ cMes1 + cAnoM1 +     "            |   "+ cMes2 + cAnoM2 +      "         |   "+ cMes3 + cAnoM3 +       "             |   "+ cMes4 + cAnoM4 + "            |   "+ cMes5 + cAnoM5 + "             |  "+ cMes6 + cAnoM6 + "              |         MÉDIA  "
Cabec2		   := "                              |    R$           KG         |    R$         KG       |  R$          KG            | R$           KG           |   R$         KG            |  R$              KG        |        R$ "

///////fim da montagem do cabeçalho
//COMENTAR O BLOCO ABAIXO QDO USAR PREPARE ENVIRONMENT

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

////FIM DO BLOCO

//RunReport(Cabec1,Cabec2,Titulo,nLin)

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
//Local aDados 	:= {}
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
Local cAtivo		:= ""

cCodUser := __CUSERID
//msgbox(cCodUser)

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailDestino := Alltrim(aUsua[1][14])
Endif

cQuery := " SELECT PESO = SUM(C6_QTDVEN * B1_PESOR) ,  " +LF
cQuery += " VALOR = SUM(C6_VALOR), C5_VEND1, A3_NOME, C5_CLIENTE, C5_LOJACLI, A1_NOME,C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF
cQuery += " WHERE C5_EMISSAO >= '" + DTOS(dData1) + "' AND C5_EMISSAO <= '" + DTOS(dData2) + "' " +LF
cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' " +LF
cQuery += " AND RTRIM(B1_TIPO) != 'AP' " +LF //Despreza Apara 
cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF

cQuery += " AND RTRIM(SB1.B1_SETOR) <> '39' " +LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND SC6.D_E_L_E_T_ = '' " +LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  " +LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  " +LF
cQuery += " AND SC5.D_E_L_E_T_ = '' "  +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  " +LF
cQuery += " AND C6_PRODUTO = B1_COD     "  +LF

cQuery += " AND C6_NUM = C5_NUM      " +LF
cQuery += " AND C6_CLI = C5_CLIENTE " +LF
cQuery += " AND C6_LOJA = C5_LOJACLI       " +LF
cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF
cQuery += " AND C5_VEND1 = A3_COD " +LF
cQuery += " AND A3_SUPER <> '' " 	 +LF //É REPRESENTANTE:SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO

//cQuery += " AND A3_SUPER = '0255' " + LF
cQuery += " AND RTRIM(C5_VEND1) >= '" + MV_PAR01 + "' AND RTRIM(C5_VEND1) <= '" + MV_PAR02 + "' "+LF
//cquery += " AND RTRIM(C5_CLIENTE) = '001704' AND RTRIM(C5_LOJACLI) = '01' " + LF

cQuery += " GROUP BY C5_VEND1,C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO " +LF
//MemoWrite("C:\Temp\fatr011D.sql", cQuery )
          
If Select("REP") > 0
	DbSelectArea("REP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "REP"

TCSetField( "REP", "C5_EMISSAO", "D")

REP->( DbGoTop() )

SetRegua(0)

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
    cSuper 		:= REP->A3_SUPER
    
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
	
	If !Empty(REP->A3_SUPER)              ///é representante
		cSuper  := REP->A3_SUPER	
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME	
		//cGeren     := SA3->A3_GEREN
			
		//SA3->(Dbsetorder(1))
		//SA3->(Dbseek(xFilial("SA3") + cGeren ))
		//cNomeGeren := SA3->A3_NOME
	
	Endif
	

	Do While Alltrim(REP->C5_CLIENTE) == Alltrim(cCliente) .AND. Alltrim(REP->C5_LOJACLI) == Alltrim(cLoja)
		Do Case
			Case Month( REP->C5_EMISSAO ) = nMes1
				nTotVM1 += REP->VALOR
				nTotPM1 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes2
				nTotVM2 += REP->VALOR
				nTotPM2 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes3
				nTotVM3 += REP->VALOR
				nTotPM3 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes4
				nTotVM4 += REP->VALOR
				nTotPM4 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes5
				nTotVM5 += REP->VALOR
				nTotPM5 += REP->PESO
			Case Month( REP->C5_EMISSAO ) = nMes6
				nTotVM6 += REP->VALOR
				nTotPM6 += REP->PESO
		Endcase	
	
		REP->(DBSKIP())	
	Enddo


	nMedia := ( (nTotVM1 + nTotVM2 + nTotVM3 + nTotVM4 + nTotVM5 + nTotVM6) / 6 )
	
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

////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
cDirHTM  := "\Temp\"    
cArqHTM  := "FATR011D.HTM"   
nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		    
If nHandle = -1
     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

Do While nCta <= Len(aDadRe)


	   
   If nCta = 1
   		cCodRepre := aDadRe[nCta,1]
   		cNomeRepre:= aDadRe[nCta,2]
   		cMailRepre:= aDadRe[nCta,3]
   		cSuper	  := aDadRe[nCta,7]
   		/*
	   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
	   	cDirHTM  := "\Temp\"    
		cArqHTM  := "FATR011D" + Alltrim(cCodRepre) +".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		*/	
	Endif
	
	
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
   
   If nCta = 1
	   nLin++
	   @nLin,00 PSAY "Representante: " + Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(cNomeRepre)
	   @nLin,70 PSAY "Coordenador: " + Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8])
	   nLin++
	   nLin++
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
   		
   		//If nCta > 1 
   			//cWeb += '<div class="quebra_pagina"></div>'+LF
   		//Endif
   		/////CABEÇALHO PÁGINA
		cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
		cWeb += '<html><head>'+ LF
		cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
		cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
		cWeb += '<tr>    <td>'+ LF
		cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+ LF
		cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
		cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
		cWeb += '<tr>        <td>SIGA /FATR011D/v.P10</td>'+ LF
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
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr><br>'+LF
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr><br>'+LF
			cWeb += '</table>' + LF
		
		Endif		
		
		nLinhas++
		nLinhas++
		
		///Cabeçalho relatório	      
		cWeb += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
		cWeb += '<td rowspan="2" width="1300" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
		//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
		cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
		cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
		
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
   		nLinhas++
   		
		nPag++

   Endif
      		
   		If nCta > 1
   		
   			If ( Alltrim(aDadRe[nCta,1]) != Alltrim(cCodRepre) )     ////se mudou o representante...totaliza			
   			
			
			   @nLin,00 PSAY Replicate("-",220)
			   nLin++
			   @nLin,000 PSAY "Total: " 	
			   @nLin,030 PSAY TRANSFORM( nTotVM1,"@E 9,999,999.99")
			   @nLin,044 PSAY TRANSFORM( nTotPM1,"@E 9,999,999.99") 
			   @nLin,057 PSAY TRANSFORM( nTotVM2,"@E 9,999,999.99")
			   @nLin,071 PSAY TRANSFORM( nTotPM2,"@E 9,999,999.99") 
			   @nLin,085 PSAY TRANSFORM( nTotVM3,"@E 9,999,999.99")
			   @nLin,099 PSAY TRANSFORM( nTotPM3,"@E 9,999,999.99") 
			   @nLin,114 PSAY TRANSFORM( nTotVM4,"@E 9,999,999.99")
			   @nLin,128 PSAY TRANSFORM( nTotPM4,"@E 9,999,999.99") 
			   @nLin,142 PSAY TRANSFORM( nTotVM5,"@E 9,999,999.99")
			   @nLin,156 PSAY TRANSFORM( nTotPM5,"@E 9,999,999.99") 
			   //@nLin,143 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
			   //@nLin,157 PSAY TRANSFORM( nTotCartK,"@E 999,999.99")
			   @nLin,171 PSAY TRANSFORM( nTotVM6,"@E 9,999,999.99")
			   @nLin,185 PSAY TRANSFORM( nTotPM6,"@E 9,999,999.99")
			   @nLin,199 PSAY TRANSFORM( nTotMedia, "@E 99,999,999.99")			   
			   nLin++
			   @nLin,000 PSAY cMailRepre
			   nLin++
			   @nLin,00 PSAY Replicate("=",220)
			   nLin++		    
		   
				cWeb += '<td width="1300"><span class="style3"><b>TOTAL.....:</span></b></td>'
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")+ '</b></span></td>'+LF
				//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</b></span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</b></span></td>'+LF
				cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
				cWeb += '</tr></table>'+LF
				
				nLinhas++
				//If nLinhas <= 40
					cWeb += '<div class="quebra_pagina"></div>'+LF
				//Endif
				
				cRepreAnt := aDadRe[nCta,1] //cCodRepre
				
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
				
				///GRAVA O HTML
			    Fwrite( nHandle, cWeb, Len(cWeb) )
			    cWeb := ""
			    
			   	////NOVO REPRESENTANTE...
			   	cCodRepre := aDadRe[nCta,1]
	   			cNomeRepre:= aDadRe[nCta,2]
				cMailRepre:= aDadRe[nCta,3]
				cSuper    := aDadRe[nCta,7]
				
				//nPag := 1
				
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
				cWeb += '<tr>        <td>SIGA /FATR011D/v.P10</td>'+ LF
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
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr><br>'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr><br>'+LF
				cWeb += '</table>' + LF     
				
				nLinhas++
				nLinhas++
				
				///Cabeçalho relatório	      
				cWeb += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="1300" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTE</span></div></B></td>'+ LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>
				cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
				//cWeb += '<td><div align="center"><span class="style3"><b>'+ Alltrim(cMes6) + cAnoM6 +'</span></div></b></td>'+LF
				cWeb += '<td><div align="center"><span class="style3"><b>MEDIA</span></div></b></td>'+LF
				
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
		        
				nLinhas++
				
				nPag++		
				
				
				
				nLin++
			   @nLin,00 PSAY "Representante: " + Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(cNomeRepre)
			   @nLin,70 PSAY "Coordenador: " + Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8])
			   nLin++
			   nLin++
			   
			   
			Endif
		Endif
	
        	        		
        		@nLin,000 PSAY Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,18))	PICTURE "@!"  ////NOME CLIENTE
        		cWeb += '<td width="1300"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF		////CLIENTE
        		cUltimaComp := ""
				If Alltrim(cSuper) = '0255'
					cUltimaComp := U_fUltiCompra( aDadRe[nCta,4] , aDadRe[nCta,5], aDadRe[nCta,1])		//irá capturar os dígitos do mês que foi realizada a última compra do cliente
				Endif
								
				////mês 1
				@nLin,030 PSAY aDadRe[nCta,11]		PICTURE "@E 9,999,999.99"
				@nLin,044 PSAY aDadRe[nCta,12]		PICTURE "@E 9,999,999.99"
				nTotVM1 += aDadRe[nCta,11]									  					
				nTotPM1 += aDadRe[nCta,12]									  					
			
				If nMes1 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
					//amarelo
					//cWeb += '<td width="300" bgcolor="#03E517" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					//verde
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,11], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
								
				////mês 2
				@nLin,057 PSAY aDadRe[nCta,13]	PICTURE "@E 9,999,999.99"
				@nLin,071 PSAY aDadRe[nCta,14]	PICTURE "@E 9,999,999.99"
				nTotVM2 += aDadRe[nCta,13]
				nTotPM2 += aDadRe[nCta,14]									  													
				If nMes2 = Val(cUltimaComp)	    		
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,14], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
									
				////mês 3
				@nLin,085 PSAY aDadRe[nCta,15]	PICTURE "@E 9,999,999.99"
				@nLin,099 PSAY aDadRe[nCta,16]	PICTURE "@E 9,999,999.99"
				nTotVM3 += aDadRe[nCta,15]
				nTotPM3 += aDadRe[nCta,16]									  									
				If nMes3 = Val(cUltimaComp)	    		
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,15], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,16], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
								
				////mês 4
				@nLin,114 PSAY aDadRe[nCta,17]	PICTURE "@E 9,999,999.99"
				@nLin,128 PSAY aDadRe[nCta,18]	PICTURE "@E 9,999,999.99"
				nTotVM4 += aDadRe[nCta,17]
				nTotPM4 += aDadRe[nCta,18]									  									
				If nMes4 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,17], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,18], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
									
				////mês 5
				@nLin,142 PSAY aDadRe[nCta,19]	PICTURE "@E 9,999,999.99"
				@nLin,156 PSAY aDadRe[nCta,20]	PICTURE "@E 9,999,999.99"
				nTotVM5 += aDadRe[nCta,19]
				nTotPM5 += aDadRe[nCta,20]									  									
				If nMes5 = Val(cUltimaComp)				
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,20], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,19], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,20], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
				
				////MÊS 6
				@nLin,170 PSAY aDadRe[nCta,21]		PICTURE "@E 9,999,999.99"
				@nLin,185 PSAY aDadRe[nCta,22]		PICTURE "@E 9,999,999.99"
				nTotVM6 += aDadRe[nCta,21]
				nTotPM6 += aDadRe[nCta,22]									  									
				If nMes6 = Val(cUltimaComp)
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" bgcolor="#CBC967" align="right"><span class="style3">' + Transform(aDadRe[nCta,22], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Else
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,21], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
					cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,22], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
				Endif
								
				//// MÉDIA
				@nLin,199 PSAY aDadRe[nCta,23]		PICTURE "@E 99,999,999.99"
				nTotMedia += aDadRe[nCta,23]				
				cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,23], "@E 9,999,999.99")  + '</span></td>'+LF  //R$								
				cWeb += '</tr>'+LF 		//finaliza a linha
        	
      
   		nCta++
   		nLin++
     	nLinhas++    
    
     

Enddo

////PARA QUE O ÚLTIMO NÃO FIQUE SEM IMPRIMIR O TOTAL:
nLin++
@nLin,00 PSAY Replicate("-",220)
nLin++
@nLin,000 PSAY "Total: " 	
@nLin,030 PSAY TRANSFORM( nTotVM1,"@E 9,999,999.99")
@nLin,044 PSAY TRANSFORM( nTotPM1,"@E 999,999.99") 
@nLin,057 PSAY TRANSFORM( nTotVM2,"@E 9,999,999.99")
@nLin,071 PSAY TRANSFORM( nTotPM2,"@E 999,999.99") 
@nLin,085 PSAY TRANSFORM( nTotVM3,"@E 9,999,999.99")
@nLin,099 PSAY TRANSFORM( nTotPM3,"@E 999,999.99") 
@nLin,114 PSAY TRANSFORM( nTotVM4,"@E 9,999,999.99")
@nLin,128 PSAY TRANSFORM( nTotPM4,"@E 999,999.99") 
@nLin,142 PSAY TRANSFORM( nTotVM5,"@E 9,999,999.99")
@nLin,156 PSAY TRANSFORM( nTotPM5,"@E 999,999.99") 
//@nLin,143 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
//@nLin,157 PSAY TRANSFORM( nTotCartK,"@E 9,999,999.99") 
@nLin,170 PSAY TRANSFORM( nTotVM6,"@E 99,999,999.99")
@nLin,185 PSAY TRANSFORM( nTotPM6,"@E 9,999,999.99") 
@nLin,199 PSAY TRANSFORM( nTotMedia,"@E 9,999,999.99") 
nLin++
@nLin,000 PSAY cMailRepre
nLin++
@nLin,00 PSAY Replicate("=",220)
		   
cWeb += '<td width="1000"><span class="style3"><b>TOTAL.....:</span></b></td>'
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM1,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM1,"@E 999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM2,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM2,"@E 999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM3,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM3,"@E 999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 9,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 999,999.99")  + '</b></span></td>'+LF
//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")+ '</b></span></td>'+LF
//cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM6,"@E 99,999,999.99")+ '</b></span></td>'+LF
cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM6,"@E 9,999,999.99")  + '</b></span></td>'+LF
cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF

cWeb += '</tr></table>'+LF     ////finaliza a linha e a tabela

////

/////FECHA O HTML GERADO PARA ENVIO
cWeb += '</body> '
cWeb += '</html> '

/////////GRAVA O HTML
Fwrite( nHandle, cWeb, Len(cWeb) )
FClose( nHandle )
nRet := 0
nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //esta funcionou, OK
			
//////ENVIA PARA O REPRESENTANTE (último)

cMailTo := cMailDestino
cCopia  := "flavia.rocha@ravaembalagens.com.br"
If Alltrim(cSuper) = '0255'
  	cCopia += ";patricia.oliveira@ravaembalagens.com.br" //";patricia.oliveira@ravaembalagens.com.br;flavia@ravaembalagens.com.br"		//email do sup. de vendas (ex: Patricia Oliveira)
Endif
cCorpo  := titulo + " -   Este arquivo é melhor visualizado no navegador Mozilla Firefox."
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
		
lEnviou := U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )		    

//U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
////////

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

If lEnviou
	MsgInfo("Você acaba de receber este relatório por E-mail !")
Endif

MS_FLUSH()

//Msginfo("FATR011D - Processo finalizado")

// Habilitar somente para Schedule
//Reset environment


Return

