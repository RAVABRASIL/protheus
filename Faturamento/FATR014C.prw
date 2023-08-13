#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR014C
//Objetivo: Relatório de Fechamento do Mês  -  SOMENTE COLETORES - Ano 2010
//			Emitir relatório das vendas por representante e enviar por e-mail
//          para os supervisores
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 08/04/2010
//--------------------------------------------------------------------------
/*/



//DIRETORIA - RECEBE DE TODOS 
/*
SE A3_SUPER ESTÁ PREENCHIDO E A3_GEREN VAZIO, É PQ O REGISTRO É UM REPRESENTANTE
SE A3_SUPER ESTÁ VAZIO E O A3_GEREN ESTÁ PREENCHIDO É PQ O REGISTRO É UM COORDENADOR
SE A3_GEREN ESTÁ VAZIO E O A3_SUPER ESTÁ VAZIO, O REGISTRO É UM GERENTE
*/
************************************
User Function FATR014C()
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
Private nomeprog     := "FATR014C" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR014C" // Coloque aqui o nome do arquivo usado para impressao em disco
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
//Private aDadSuper	:= {}
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private cMailSuper	:= ""
//SetPrvt("OHTML,OPROCESS")
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nLin        := 80
Private nCta		:= 0

//Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg ,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dData2 := Lastday( dDatabase)
dData1 := dData2 - 150

//dData2 := Ctod("31/03/2010")
//dData1 := dData2 - 0

cAno1 := StrZero( Year( dData1), 4 )
cAno2 := StrZero( Year( dData2), 4 )
cStrAno := ""

If cAno1 == cAno2
	cStrAno := cAno1
Else
	cStrAno := cAno1 + "/" + cAno2
Endif

//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "Relatorio de Fechamento do Mes (p/ Coordenadores)  -  SOMENTE COLETORES - " + cStrAno + ""
//+ StrZero( Year( dData1), 4 ) + "/" + StrZero( Year( dData2), 4 ) + ""


//Compor o array com o número dos meses do ano
cAnoM1 := ""
cAnoM2 := ""
cAnoM3 := ""
cAnoM4 := ""
cAnoM5 := ""
//cAnoM6 := ""

///ESTAS VARIÁVEIS SERÃO UTILIZADAS NO COMPARATIVO DO MES/ANO DA META
cAnoMe1 := ""
cAnoMe2 := ""
cAnoMe3 := ""
cAnoMe4 := ""
cAnoMe5 := ""

aMeses:= {}
aMeses:= { 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 }

nPosMes := Ascan( aMeses, Month(dData2) )


If nPosMes = 1         //se for Janeiro 
//ago, set, out, nov, dez, jan
	nMes5 := aMeses[nPosMes]          //1
	nMes4 := aMeses[nPosMes + 11]     //12
	nMes3 := aMeses[nPosMes + 10]     //11
	nMes2 := aMeses[nPosMes + 9 ]     //10
	nMes1 := aMeses[nPosMes + 8 ]     //9
		
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ) ,3,2)    	//jan/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ), 3,2) 	//dez/09
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//nov/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//out/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//set/09
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//jan/10
	cAnoMe4 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 ) 	//out/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//set/09

Elseif nPosMes = 2   //se for Fevereiro
//set, out, nov, dez, jan, fev
	nMes5 := aMeses[nPosMes]         //2
	nMes4 := aMeses[nPosMes - 1 ]    //1
	nMes3 := aMeses[nPosMes + 10]    //12
	nMes2 := aMeses[nPosMes + 9]     //11
	nMes1 := aMeses[nPosMes + 8 ]    //10
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//fev/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//dez/09
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2) 	//nov/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//out/09   
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//fev/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe3 	:= StrZero( Year(dData2) - 1, 4 ) 	//dez/09
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 ) 	//nov/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//out/09
	
Elseif nPosMes = 3	// se for Março
//out, nov, dez, jan, fev, mar
	nMes5 := aMeses[nPosMes]          //3
	nMes4 := aMeses[nPosMes - 1 ]     //2
	nMes3 := aMeses[nPosMes - 2 ]     //1
	nMes2 := aMeses[nPosMes + 9]      //12
	nMes1 := aMeses[nPosMes + 8 ]     //11
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//mar/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//dez/09
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//nov/09    
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//mar/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 		//fev/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe2 	:= StrZero( Year(dData2) - 1, 4 )	//dez/09
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//nov/09
	
Elseif nPosMes = 4	// se for Abril
//nov, dez, jan, fev, mar, abr
	nMes5 := aMeses[nPosMes]         //4
	nMes4 := aMeses[nPosMes - 1 ]    //3
	nMes3 := aMeses[nPosMes - 2 ]    //2
	nMes2 := aMeses[nPosMes - 3 ]    //1
	nMes1 := aMeses[nPosMes + 8 ]    //12
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//abr/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//jan/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) - 1, 4 ),3,2)	//dez/09 
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//abr/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 		//mar/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 		//fev/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 		//jan/10
	cAnoMe1 	:= StrZero( Year(dData2) - 1, 4 )	//dez/09
	
Elseif nPosMes = 5	// se for Maio
//dez, jan, fev, mar, abr, maio
	nMes5 := aMeses[nPosMes]         //5
	nMes4 := aMeses[nPosMes - 1 ]    //4
	nMes3 := aMeses[nPosMes - 2 ]    //3
	nMes2 := aMeses[nPosMes - 3 ]    //2
	nMes1 := aMeses[nPosMes - 4 ]    //1
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)    	//maio/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//fev/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//jan/10
	
	cAnoMe5 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//mar/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//fev/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//jan/10
	
Elseif nPosMes = 6	// se for Junho
//jan, fev, mar, abr, maio, jun
	nMes5 := aMeses[nPosMes]         //6
	nMes4 := aMeses[nPosMes - 1 ]    //5
	nMes3 := aMeses[nPosMes - 2 ]    //4
	nMes2 := aMeses[nPosMes - 3 ]    //3
	nMes1 := aMeses[nPosMes - 4 ]    //2
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2),  4 ),3,2)    	//junho/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//mar/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//fev/10 
	
	cAnoMe5 	:= StrZero( Year(dData2),  4 ) 	//junho/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//mar/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//fev/10
		
Elseif nPosMes = 7	// se for Julho
//fev, mar, abr, maio, jun, julho
	nMes5 := aMeses[nPosMes]         //7
	nMes4 := aMeses[nPosMes - 1 ]    //6
	nMes3 := aMeses[nPosMes - 2 ]    //5
	nMes2 := aMeses[nPosMes - 3 ]    //4
	nMes1 := aMeses[nPosMes - 4 ]    //3
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//julho/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//abr/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//mar/10
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )  	//julho/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//abr/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//mar/10
	
Elseif nPosMes = 8	// se for Agosto
//mar, abr, maio, jun, jul, ago
	nMes5 := aMeses[nPosMes]        //8
	nMes4 := aMeses[nPosMes - 1 ]   //7
	nMes3 := aMeses[nPosMes - 2 ]   //6
	nMes2 := aMeses[nPosMes - 3 ]   //5
	nMes1 := aMeses[nPosMes - 4 ]   //4
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//ago/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//maio/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//abr/10
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )  	//ago/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//maio/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//abr/10
	
Elseif nPosMes = 9	// se for Setembro
//abr, maio, jun, jul, ago, set
	nMes5 := aMeses[nPosMes]        //9
	nMes4 := aMeses[nPosMes - 1 ]   //8
	nMes3 := aMeses[nPosMes - 2 ]   //7
	nMes2 := aMeses[nPosMes - 3 ]   //6
	nMes1 := aMeses[nPosMes - 4 ]   //5
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//set/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//junho/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//maio/10
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//set/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//junho/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//maio/10
	
Elseif nPosMes = 10	// se for Outubro
//maio, jun, jul, ago, set, out
	nMes5 := aMeses[nPosMes]        //10
	nMes4 := aMeses[nPosMes - 1 ]   //9
	nMes3 := aMeses[nPosMes - 2 ]   //8
	nMes2 := aMeses[nPosMes - 3 ]   //7
	nMes1 := aMeses[nPosMes - 4 ]   //6
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//out/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//julho/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//junho/10
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//out/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//julho/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//junho/10
	
Elseif nPosMes = 11	// se for Novembro
//jun, jul, ago, set, out, nov
	nMes5 := aMeses[nPosMes]        //11
	nMes4 := aMeses[nPosMes - 1 ]   //10
	nMes3 := aMeses[nPosMes - 2 ]   //9
	nMes2 := aMeses[nPosMes - 3 ]   //8
	nMes1 := aMeses[nPosMes - 4 ]   //7
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//nov/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//out/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//ago/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//julho/10
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//nov/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//out/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//ago/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//julho/10
	
Elseif nPosMes = 12	// se for Dezembro
//jul, ago, set, out, nov, dez
	nMes5 := aMeses[nPosMes]        //12
	nMes4 := aMeses[nPosMes - 1 ]   //11
	nMes3 := aMeses[nPosMes - 2 ]   //10
	nMes2 := aMeses[nPosMes - 3 ]   //9
	nMes1 := aMeses[nPosMes - 4 ]   //8
	
	cAnoM5 	:= "/" + Substr(StrZero( Year(dData2), 4 ),3,2)    	//dez/10
	cAnoM4 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//nov/10
	cAnoM3 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//out/10
	cAnoM2 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2) 	//set/10
	cAnoM1 	:= "/" + Substr(StrZero( Year(dData2) , 4 ),3,2)	//ago/10 
	
	cAnoMe5 	:= StrZero( Year(dData2), 4 )    	//dez/10
	cAnoMe4 	:= StrZero( Year(dData2) , 4 ) 	//nov/10
	cAnoMe3 	:= StrZero( Year(dData2) , 4 ) 	//out/10
	cAnoMe2 	:= StrZero( Year(dData2) , 4 ) 	//set/10
	cAnoMe1 	:= StrZero( Year(dData2) , 4 )	//ago/10
	
Endif			

//Compor o array com o Nome dos meses do ano
aNomMeses:= {}
//					1			2			3		 	  4		  		5		    6			7			  8			9				10			11			12
aNomMeses:= { " JANEIRO ", "FEVEREIRO", "  MARCO  ", "  ABRIL  ", "   MAIO  ", "  JUNHO  ", "  JULHO  ", "  AGOSTO ", "SETEMBRO ", " OUTUBRO ", "NOVEMBRO ", "DEZEMBRO "}

//cMes6 := aNomMeses[nMes6]
cMes5 := aNomMeses[nMes5]
cMes4 := aNomMeses[nMes4]
cMes3 := aNomMeses[nMes3]
cMes2 := aNomMeses[nMes2]
cMes1 := aNomMeses[nMes1] 


Cabec1         := "REPRESENTANTE         |   META MENSAL            |   "+cMes1+cAnoM1+"          |   "+ cMes2 +cAnoM2+"            |    "+ cMes3 +cAnoM3+"         |     "+ cMes4 +cAnoM4+"          |   "+ cMes5 +cAnoM5+"            |      CARTEIRA " 
Cabec2		   := "                      |    R$        KG          |    R$         KG        |  R$           KG          | R$          KG          |      R$        KG         |  R$            KG         |     R$            KG "

///////fim da montagem do cabeçalho

//Ativar o bloco abaixo qdo for chamar o relatório pelo menu:
///////início do bloco

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

///////fim do bloco

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
Local cQuery2 := ""
Local nQTD:=0 
Local aDados 	:= {}
Local aDad14C	:= {}
Local aTotRepre := {}

Local nTotPM1 := 0
Local nTotPM2 := 0   
Local nTotPM3 := 0
Local nTotPM4 := 0
Local nTotPM5 := 0
//Local nTotPM6 := 0
   
Local nTotVM1 := 0
Local nTotVM2 := 0   
Local nTotVM3 := 0
Local nTotVM4 := 0
Local nTotVM5 := 0
//Local nTotVM6 := 0
Local nTotCartR:= 0
Local nTotCartK:= 0

Local nTotMetaR := 0
Local nTotMetaK := 0

Private cSuper		:= ""
Private cNomeSuper 	:= ""
Private cGeren		:= ""
Private cNomeGeren 	:= ""


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
cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' "+LF
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
MemoWrite("\TempQry\fatr014C.sql", cQuery )

TCQUERY cQuery NEW ALIAS "SUP14"

TCSetField( "SUP14", "F2_EMISSAO", "D")
TCSetField( "SUP14", "D2_EMISSAO", "D")


SUP14->( DbGoTop() )

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

While SUP14->( !EOF() )

	cCodRepre := SUP14->F2_VEND1
	cNomeRepre:= SUP14->A3_NOME
	
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
	
	cSuper	:= ""
	cNomeSuper := "" 
		
	If !Empty( SUP14->A3_SUPER )
		cSuper  := SUP14->A3_SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME		
	Endif
	
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
	//cQuery2 += " and SC6.C6_LOCAL in ('01','10') "+LF
	cQuery2 += " and RTRIM(SC5.C5_VEND1) = '" + Alltrim(cCodRepre) + "' "+LF	
	//cQuery2 += " AND RTRIM(SC6.C6_TES) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "+LF
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
	MemoWrite("\TempQry\14CCARTEIRA.SQL" , cQuery2)
	
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
	 	 	
	Do While Alltrim(SUP14->F2_VEND1) == Alltrim(cCodRepre)
	
		Do Case
			Case Month( SUP14->F2_EMISSAO ) = nMes1			
			    nTotVM1 += SUP14->VALOR
			    nTotPM1 += SUP14->PESO
			Case Month( SUP14->F2_EMISSAO ) = nMes2
			   	nTotVM2 += SUP14->VALOR
			    nTotPM2 += SUP14->PESO
			Case Month( SUP14->F2_EMISSAO ) = nMes3
			    nTotVM3 += SUP14->VALOR
			    nTotPM3 += SUP14->PESO			    
			Case Month( SUP14->F2_EMISSAO ) = nMes4
			    nTotVM4 += SUP14->VALOR
			    nTotPM4 += SUP14->PESO		
			Case Month( SUP14->F2_EMISSAO ) = nMes5
			    nTotVM5 += SUP14->VALOR
			    nTotPM5 += SUP14->PESO		
		Endcase	           	
		SUP14->(Dbskip())
	Enddo
					 
	Aadd(aDad14C, { cCodRepre, cNomeRepre, cSuper, cNomeSuper,;
					 nTotVM1, nTotPM1, nTotVM2, nTotPM2  ,;
					 nTotVM3, nTotPM3, nTotVM4, nTotPM4  ,;
					 nTotVM5, nTotPM5, nTotCartR, nTotCartK } )
	 		
	 		

Enddo

SUP14->( DbCloseArea() )
msgbox("Array criado!")


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
		   
nTotVM1 := 0
nTotVM2 := 0   
nTotVM3 := 0
nTotVM4 := 0
nTotVM5 := 0

nTotMetaR := 0
nTotMetaK := 0
nTotCartR := 0
nTotCartK := 0

nCta := 1

If Len(aDad14C) > 0
	
	Do While nCta <= Len(aDad14C)
	
		nMetaR := 0
		nMetaK := 0
		///totais da meta / representante
		nTotMetaR := 0
		nTotMetaK := 0
		///totais ped. carteira
		nTotCartR := 0
		nTotCartK := 0
		
		cSuper := aDad14C[nCta,3]
		cNomeSuper := Alltrim(aDad14C[nCta,4])
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cMailSuper := SA3->A3_EMAIL   ///captura o email do coordenador para posterior envio do arq. html
		
		cWeb := ""
		nLinhas := 80
		/////CRIA O HTML
		cDirHTM  := "\Temp\"    
		cArqHTM  := "FATR014C" + Alltrim(cSuper) + ".HTM"    //relatório P/ SUPERVISORES
		nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
		nPag     := 1    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
		Endif	
		
		If nLinhas >= 35	
			///Cabeçalho html
			cWeb := ""
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR014C/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF      
				      
			/////NOME DO SUPERVISOR RESPONSÁVEL	
			cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Verdana">'
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
			cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr><br>'+LF
			//cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana"> '+LF 
			cWeb += '</table>' + LF
			/////
			
			///Cabeçalho relatório
			cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+ LF
			cWeb += '<td rowspan="2" width="410" font-family: Verdana><div align="center"><span class="style3" style="font-size:14px"><B>REPRESENTANTE</span></div></B></td>'+ LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF
			
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
			cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
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
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF
			cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF
			cWeb += '</strong></tr><br>'+ LF
		    nPag++
		    nLinhas := 1
		    
		    
		    
		Endif
			
		/////NOME DO SUPERVISOR RESPONSÁVEL
		nLin++
		@nLin,000 PSAY Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) PICTURE "@!"
	 
			
		   Do While nCta <= Len(aDad14C)  .and. Alltrim(aDad14C[nCta,3]) == Alltrim(cSuper)
			   	
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
					cWeb += '<tr>        <td>SIGA /FATR014C/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: ' + Dtoc(dData2) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF      
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					cWeb += '</table></head>'+ LF   
					
					/////NOME DO SUPERVISOR RESPONSÁVEL	
					cWeb += '<table width="1300" border="0" style="font-size:12px;font-family:Verdana">'
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
					cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cSuper) + "-" + Alltrim(cNomeSuper) + '</span></td></tr><br>'+LF
					//cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana"> '+LF 
					cWeb += '</table>' + LF
					/////
			      
			      	///Cabeçalho relatório		      
					cWeb += '<table width="1300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+ LF
					cWeb += '<td rowspan="2" width="410" font-family: Verdana><div align="center"><span class="style3" style="font-size:14px"><B>REPRESENTANTE</span></div></B></td>'+ LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>META MENSAL</span></div></b></td>'+LF				
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes1) + cAnoM1 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes2) + cAnoM2 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes3) + cAnoM3 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes4) + cAnoM4 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>'+ Alltrim(cMes5) + cAnoM5 +'</span></div></b></td>'+LF
					cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>CARTEIRA</span></div></b></td>'+LF
					cWeb += '<tr>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF		//R$ COLUNA META MENSAL
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF       //KG COLUNA META MENSAL
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">R$</span></td>'+ LF
					cWeb += '<td width="400" align="center"><span class="style3">KG</span></td>'+ LF
					cWeb += '</strong></tr><br>'+ LF
									
					nPag++
					nLinhas := 1
			
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
				cQuery += " WHERE RTRIM(A3_COD) = '" + Alltrim(aDad14C[nCta,1]) + "' "+LF 
				cQuery += " AND A3_COD = Z7_REPRESE "+LF
				//cQuery += " AND Z7_MESANO = '102009' " + LF
				cQuery += " AND RTRIM(Z7_TIPO) = 'SC' " + LF
				cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
				cQuery += " AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ''  "+LF
				cQuery += " GROUP BY A3_SUPER, Z7_MESANO,Z7_TIPO "+LF
				cQuery += " ORDER BY Z7_MESANO "+LF
				MemoWrite("\TempQry\14CMETA.sql", cQuery )
				If Select("META") > 0
					DbSelectArea("META")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "META"
				META->( DbGoTop() )
				While META->( !EOF() )					
					If Alltrim(META->Z7_MESANO) == Alltrim( Strzero(Month(dDatabase),2) + Strzero(Year(dDatabase),4) )
						nMetaR += META->Z7_VALOR
						nMetaK += META->Z7_KILO
					Endif
					META->(Dbskip())
				Enddo
			    
			   	////COMEÇA A IMPRESSÃO...
				nLin++			   
				@nLin,000 PSAY SUBSTR( aDad14C[nCta,2],1,20)	PICTURE "@!"   	//Nome Representante
				////META
				@nLin,020 PSAY nMetaR	PICTURE "@E 99,999,999.99" 	//Meta R$
				@nLin,035 PSAY nMetaK	PICTURE "@E 999,999.99"     //Meta KG
				nTotMetaR += nMetaR ///acumula para o total geral
				nTotMetaK += nMetaK
									   
				@nLin,047 PSAY TRANSFORM( aDad14C[nCta,5],"@E 99,999,999.99")		//VM1 total valor mês 1				
				@nLin,062 PSAY TRANSFORM( aDad14C[nCta,6],"@E 999,999.99")		//PM1 total peso mês 1
				@nLin,074 PSAY TRANSFORM( aDad14C[nCta,7],"@E 99,999,999.99") 	//VM2 total valor mês 2
				@nLin,089 PSAY TRANSFORM( aDad14C[nCta,8],"@E 999,999.99")		//PM2 total peso mês 2
				@nLin,101 PSAY TRANSFORM( aDad14C[nCta,9],"@E 99,999,999.99") 	//VM3 total valor mês 3
				@nLin,116 PSAY TRANSFORM( aDad14C[nCta,10],"@E 9,999,999.99")		//PM3 total peso mês 3
				@nLin,130 PSAY TRANSFORM( aDad14C[nCta,11],"@E 99,999,999.99")	//VM4 total valor mês 4
				@nLin,145 PSAY TRANSFORM( aDad14C[nCta,12],"@E 9,999,999.99")		//PM4 total peso mês 4
				@nLin,159 PSAY TRANSFORM( aDad14C[nCta,13],"@E 99,999,999.99")   	//VM5 total valor mês 5
				@nLin,174 PSAY TRANSFORM( aDad14C[nCta,14],"@E 9,999,999.99")		//PM5 total peso mês 5
				////CARTEIRA PEDIDOS
				@nLin,188 PSAY aDad14C[nCta,15]	PICTURE "@E 99,999,999.99" 	//R$
				@nLin,203 PSAY aDad14C[nCta,16]	PICTURE "@E 9,999,999.99"     //KG
				
				///acumula para o total geral...				
				nTotCartR += aDad14C[nCta,15]
				nTotCartK += aDad14C[nCta,16]
				
				nTotVM1 += aDad14C[nCta,5]   //totais valores / peso
				nTotPM1 += aDad14C[nCta,6]
				nTotVM2 += aDad14C[nCta,7]
				nTotPM2 += aDad14C[nCta,8]
				nTotVM3 += aDad14C[nCta,9]
				nTotPM3 += aDad14C[nCta,10]
				nTotVM4 += aDad14C[nCta,11]
				nTotPM4 += aDad14C[nCta,12]
				nTotVM5 += aDad14C[nCta,13]
				nTotPM5 += aDad14C[nCta,14]
				
				////REPRESENTANTE E SUA META	
				cWeb += '<td width="2700"><span class="style3">'+ SUBSTR( aDad14C[nCta,2],1,20) + '</span></td>'+LF   //REPRESENTANTE
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform( nMetaR , "@E 9,999,999.99")  + '</span></td>'+LF  //META R$
				cWeb += '<td width="900"><span class="style3">' + Transform( nMetaK , "@E 999,999.99")+' </span></td>'+LF        //META KG
				
				////TOTAIS DO REPRESENTANTE
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,5],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,6],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,7],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,8],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,9],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,10],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,11],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,12],"@E 999,999.99")  + '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,13],"@E 9,999,999.99")+ '</span></td>'+LF
				cWeb += '<td width="900" align="right"><span class="style3">'+ TRANSFORM( aDad14C[nCta,14],"@E 999,999.99")  + '</span></td>'+LF
				////PEDIDOS CARTEIRA
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform( aDad14C[nCta,15] , "@E 99,999,999.99")  + '</span></td>'+LF  //R$
				cWeb += '<td width="900" align="right"><span class="style3">' + Transform( aDad14C[nCta,16] , "@E 9,999,999.99")+' </span></td>'+LF        //KG
				cWeb += '</tr>'+LF			
			
	        	nCta++
	        	nLinhas++
	       Enddo
	       nLin++
	       
	       	nLin++
			@nLin,00 PSAY Replicate("=",220)				
			nLin++
			@nLin,000 PSAY "Total: "
			@nLin,020 PSAY TRANSFORM( nTotMetaR,"@E 99,999,999.99")
			@nLin,035 PSAY TRANSFORM( nTotMetaK,"@E 999,999.99")
			@nLin,047 PSAY TRANSFORM( nTotVM1,"@E 99,999,999.99")
			@nLin,062 PSAY TRANSFORM( nTotPM1,"@E 999,999.99")
			@nLin,074 PSAY TRANSFORM( nTotVM2,"@E 99,999,999.99")
			@nLin,089 PSAY TRANSFORM( nTotPM2,"@E 999,999.99")
			@nLin,101 PSAY TRANSFORM( nTotVM3,"@E 99,999,999.99")
			@nLin,116 PSAY TRANSFORM( nTotPM3,"@E 999,999.99")
			@nLin,130 PSAY TRANSFORM( nTotVM4,"@E 99,999,999.99")
			@nLin,145 PSAY TRANSFORM( nTotPM4,"@E 999,999.99")
			@nLin,159 PSAY TRANSFORM( nTotVM5,"@E 99,999,999.99")
			@nLin,174 PSAY TRANSFORM( nTotPM5,"@E 999,999.99")
			@nLin,188 PSAY TRANSFORM( nTotCartR,"@E 99,999,999.99")
			@nLin,203 PSAY TRANSFORM( nTotCartK,"@E 999,999.99")	   
			nLin++
			@nLin,00 PSAY Replicate("=",220)
			nLin++	
				
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
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM4,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM4,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotVM5,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotPM5,"@E 9,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartR,"@E 99,999,999.99")  + '</span></td>'+LF
			cWeb += '<td width="900" align="right"><span class="style3"><b>'+ TRANSFORM( nTotCartK,"@E 9,999,999.99")  + '</span></td>'+LF
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
			
			//////SELECIONA O EMAIL DESTINATÁRIO (DIRETORIA)
			//cMailTo := cMailSuper // colocar o e-mail do supervisor
			cMailTo := "flavia.rocha@ravaembalagens.com.br"  		
			cCopia  := ""
			cCorpo  := titulo
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
			//////ENVIA O HTML COMO ANEXO
			U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 		

	Enddo
Else
     MSGBOX("Array Vazio!")
Endif


//////////////FIM DO GERA PARA SUPERVISORES


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

// Habilitar somente para Schedule
//Reset environment


Return
