#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR025CX
//Objetivo: Relatório 04 - CLIENTES INATIVOS - CAIXAS(NÃO Compraram nos últimos 120 Dias)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 07/01/2011
//Alterações:
//FR : 05/04/2011  - Atendendo ao chamado 002064
//Alterar período de análise de 90 para 120 dias 
//Retirar do relatório clientes inativos com pendências financeiras >= 120 dias
//AGENDAMENTO: semanal, toda 6a. feira - TODOS COORDENADORES
//AGENDAMENTO:  Flavia Leite e cada representante recebe o seu Todo 1o. dia útil do mês.
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR025CX()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	//RAVA EMB
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f25()	//chama a função do relatório    
  	
  	//RAVA CAIXAS
  	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	f25()	//chama a função do relatório
  
Else
  lDentroSiga := .T.
  f25()
  
EndIf
  

Return

************************************
Static Function f25()
************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório 04 - CLIENTES INATIVOS (NÃO Compraram nos últimos 120 Dias)"
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
Private nomeprog     := "FATR025CX" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR025CX" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR025"
Private cString := ""



Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 

Private cWeb		:= Space(2000)
Private cSuper		:= ""
Private cNomeSuper	:= ""
Private nLinhas		:= 80 
Private nLin        := 80
Private cCodRepre 	:= ""
Private cNomeRepre	:= ""
Private cMailRepre	:= ""

Private cNomeSuper	:= ""
Private cMailSuper	:= ""
Private lUltimo		:= .F.
Private nLinhas		:= 80
Private nCta		:= 0


titulo         := "Relatorio 04 - CLIENTES INATIVOS - CAIXAS - (NAO COMPRARAM NOS ULTIMOS 120 DIAS) - POR REPRESENTANTE"

If lDentroSiga
	
	Pergunte("FATR025",.T.)    //INFORME O VENDEDOR
	/*
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    */
    If MsgYesNo("Deseja Gerar o Relatório 04 ? ")
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Else

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
Local nMediaKG := 0
Local nTotMedia:= 0
Local nTotMedKG:= 0
Local cRepreAnt:= "" 
Local cUltimaComp := ""
Local cAtivo	:= ""
Local cCodUser	:= ""
Local cMailTo	:= "" 
Local cCopia	:= ""
Local cAssun	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Local nRegTot	:= 0
Local dUltima	:= Ctod("  /  /    ")
Local nTotUltRS := 0
Local nTotUltKG := 0 
Local nHandle
Local cCliente	:= ""
Local cLoja		:= ""
Local cCliAnt	:= ""
Local cLjAnt	:= "" 
Local lPendFIN  := .F.

Local aPendentes:= {} 
Local lEhSexta  := .F.
Local nDiaSemana:= 0
Local cSegmento := ""

////VERIFICA O DIA DA SEMANA, SE FOR UMA 2A. FEIRA FAZ O ENVIO PARA FLÁVIA LEITE
nDiaSemana := DOW( dDatabase )
If nDiaSemana = 6
	lEhSexta := .T.
Endif


/*
//MV_PAR01 - DO VENDEDOR
//MV_PAR02 - ATÉ VENDEDOR
//MV_PAR03 - COORDENADOR ?
//MV_PAR04 - IMPRIME APENAS: 1 - EXISTE COMERCIALMENTE / 2 - NAO EXISTE COMERCIALMENTE / 3 - TODOS
*/

///reune todos os clientes com pendências financeiras e adiciona ao array aPendentes
cQuery += " Select A3_SUPER, A1_COD,A1_LOJA,A1_VEND, E1_BAIXA  from "
cQuery += " " + RetSqlName("SE1") + " SE1, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 " + LF

cQuery += " where (SA1.A1_COD + SA1.A1_LOJA) = (SE1.E1_CLIENTE + SE1.E1_LOJA) " + LF
cQuery += " and SA1.A1_VEND = SA3.A3_COD " + LF
cQuery += " and SE1.E1_VEND1 = SA3.A3_COD " + LF

cQuery += " and SE1.E1_FILIAL = '" + xFilial("SE1") + "' " + LF
cQuery += " and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " + LF
cQuery += " and SA3.A3_FILIAL = '" + xFilial("SA3") + "' " + LF

cQuery += " and SE1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA3.D_E_L_E_T_ = '' " + LF


If lDentroSiga
	If mv_par04 = 1
		cQuery += " AND A1_EXISCOM <> 'N' " + LF
	Elseif mv_par04 = 2
		cQuery += " AND A1_EXISCOM = 'N' " + LF
	Endif
	 
	cQuery += " AND RTRIM(E1_VEND1) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(E1_VEND1) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND RTRIM(A3_SUPER) = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif	

Else
	cQuery += " AND A1_EXISCOM = 'S' " + LF		//se for via schedule já escolhe apenas os que existem comercialmente
	cQuery += " AND RTRIM(E1_VEND1) >= ''  AND RTRIM(E1_VEND1) <= 'ZZZZZZ' " + LF
	If lEhSexta
		cQuery += " AND (A3_SUPER) <> '0255' " + LF	
	Endif
	
	If Substr(DtoS(dDatabase),7,2) = "01" //no dia 1 de cada mês, só executa o de Flávia Leite (0255)
		cQuery += " AND (A3_SUPER) = '0255' " + LF	
	Endif	 	

Endif

cQuery += " and E1_VENCTO <= '" + DtoS(dDatabase - 121) + "' " + LF
cQuery += " and E1_BAIXA = '' " + LF
cQuery += " Group by A3_SUPER, A1_COD,A1_LOJA,A1_VEND, E1_BAIXA  " + LF
cQuery += " order by A1_COD, A1_LOJA " + LF

//MemoWrite("C:\Temp\cli_pend.sql",cQuery)

If Select("FINX") > 0
	DbSelectArea("FINX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FINX"

FINX->( DbGoTop() )

While FINX->( !EOF() )
	Aadd( aPendentes, (FINX->A1_COD + FINX->A1_LOJA) )
	FINX->(DBSKIP())
Enddo

DbSelectArea("FINX")
DbCloseArea()

cQuery := " SELECT C5_EMISSAO, ROUND(SUM(C6_QTDVEN),2) AS QTDCX ,  " +LF
cQuery += " ROUND(SUM(C6_VALOR),2) AS VALOR, A3_NOME, C5_CLIENTE, C5_LOJACLI, C5_ENTREG, A1_NOME, A3_GEREN " + LF
cQuery += " , C5_VEND1 " + LF
cQuery += " , C5VEND1 = CASE WHEN C5_VEND1 LIKE ('%VD') THEN LEFT(C5_VEND1,4) ELSE C5_VEND1 END " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SC5.C5_VEND1 AND ( RTRIM(A3_SUPER) <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " ,A3_EMAIL, A3_ATIVO, A1_SATIV1 " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

//cQuery += " WHERE SC5.C5_EMISSAO >= '" + Dtos(dDatabase - 90) + "' AND SC5.C5_EMISSAO <= '" + Dtos(dDatabase) + "' " + LF
cQuery += " WHERE " + LF

cQuery += " RTRIM(B1_TIPO) != 'AP' " +LF //Despreza Apara 
//cQuery += " AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SC6.C6_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' " +LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') " +LF

cQuery += " AND C6_PRODUTO = B1_COD     "  +LF
cQuery += " AND C6_NUM = C5_NUM      " +LF
cQuery += " AND C6_FILIAL = C5_FILIAL      " +LF

cQuery += " AND C6_CLI = C5_CLIENTE " +LF
cQuery += " AND C6_LOJA = C5_LOJACLI       " +LF

cQuery += " AND C5_CLIENTE = A1_COD     " +LF
cQuery += " AND C5_LOJACLI = A1_LOJA       " +LF

cQuery += " AND C5_VEND1 = A3_COD " +LF
//cQuery += " AND A1_VEND = A3_COD " + LF
cQuery += " AND A3_ATIVO <> 'N' " + LF
//cQuery += " AND A1_SATIV1 <> '000009' " + LF // EXCLUI OS ÓRGÃOS PÚBLICOS

If lDentroSiga
	If mv_par04 = 1
		cQuery += " AND A1_EXISCOM <> 'N' " + LF
	Elseif mv_par04 = 2
		cQuery += " AND A1_EXISCOM = 'N' " + LF
	Endif
	
	cQuery += " AND RTRIM(C5_VEND1) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(C5_VEND1) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	If !Empty(MV_PAR03)
		cQuery += " AND RTRIM(A3_SUPER) = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif
Else
	cQuery += " AND A1_EXISCOM = 'S' " + LF		//se for via schedule já escolhe apenas os que existem comercialmente
	cQuery += " AND RTRIM(C5_VEND1) >= ''  AND RTRIM(C5_VEND1) <= 'ZZZZZZ' " + LF 
	//cQuery += " AND A3_SUPER = '0244' " + LF
	If Substr(DtoS(dDatabase),7,2) = "01" //no dia 1 de cada mês, só executa o de Flávia Leite (0255)
		cQuery += " AND (A3_SUPER) = '0255' " + LF	
	Else
		cQuery += " AND (A3_SUPER) <> '0255' " + LF		
	Endif	 	
Endif

cQuery += " AND SC6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY C5_VEND1,C5_CLIENTE, C5_LOJACLI, A3_NOME, A1_NOME, C5_EMISSAO, C5_ENTREG, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO, A1_SATIV1 " +LF
cQuery += " ORDER BY A3_SUPER, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_ENTREG DESC " +LF
MemoWrite("C:\Temp\fatr025CX.sql", cQuery )
          
If Select("REP") > 0
	DbSelectArea("REP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "REP"
TCSetField( "REP", "C5_EMISSAO", "D")
TCSetField( "REP", "C5_ENTREG", "D")


REP->( DbGoTop() )

While REP->( !EOF() )

	cSuper 		:= ""
    cNomeSuper 	:= ""
    cGeren		:= ""
	cNomeGeren	:= ""
	    
    cCodRepre 	:= REP->C5VEND1
	cNomeRepre	:= REP->A3_NOME
	cMailRepre	:= REP->A3_EMAIL
	cAtivo		:= REP->A3_ATIVO
	
	cCliente	:= REP->C5_CLIENTE
	cLoja		:= REP->C5_LOJACLI 
	cSegmento   := REP->A1_SATIV1
	
	cNomeCli	:= Alltrim(REP->A1_NOME)

    nUltimaRS:= 0
	nUltimaQT:= 0
	dUltima	:= Ctod("  /  /    ")
		
	If !Empty(REP->SUPER)              ///é representante
		cSuper:= REP->SUPER
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME 
		cMailSuper := SA3->A3_EMAIL
		
	
	Else
		cSuper 		:= REP->C5VEND1
		cNomeSuper	:= REP->A3_NOME
		cMailSuper  := REP->A3_EMAIL
	Endif	
    
	If Alltrim(cCliente + cLoja) != Alltrim(cCliAnt + cLjAnt)
	 //lPendFIN := fVerFIN(cCliente,cLoja)
	 //If !lPendFIN
	 If Ascan(aPendentes, (cCliente + cLoja) ) == 0		//se o cliente não estiver no array dos clientes pendentes
	 
		If REP->C5_ENTREG <= (dDatabase - 121)
				
				If Alltrim(cSuper) != "0255" .and. Alltrim(cSegmento) != '000009'
					nUltimaRS:= REP->VALOR
					nUltimaQT:= REP->QTDCX
					dUltima	 := REP->C5_ENTREG 
					
					Aadd(aDadRep, { cCodRepre,;	//1
						cNomeRepre,;        //2
						cMailRepre,;        //3
						cCliente,;          //4
						cLoja,;             //5
						cNomeCli,;          //6
						cSuper,;            //7
						cNomeSuper,;        //8
						cGeren,;            //9
						cNomeGeren,;        //10	   			
						cAtivo,;			//11
						nUltimaRS,;			//12
						nUltimaQT,;			//13
						dUltima,; 			//14
						cMailSuper } )      //15
				Elseif Alltrim(cSuper) = '0255'
					
					nUltimaRS:= REP->VALOR
					nUltimaQT:= REP->QTDCX
					dUltima	 := REP->C5_EMISSAO 
					
					Aadd(aDadRep, { cCodRepre,;	//1
						cNomeRepre,;        //2
						cMailRepre,;        //3
						cCliente,;          //4
						cLoja,;             //5
						cNomeCli,;          //6
						cSuper,;            //7
						cNomeSuper,;        //8
						cGeren,;            //9
						cNomeGeren,;        //10	   			
						cAtivo,;			//11
						nUltimaRS,;			//12
						nUltimaQT,;			//13
						dUltima,; 			//14
						cMailSuper } )      //15
				
				Endif //cSuper = '0255'
		Endif	
	
		cCliAnt := cCliente
		cLjAnt  := cLoja			
	 
	 Endif     //endif do pendência financeira
	    
	Endif
	nRegTot++
	REP->(DBSKIP())			


Enddo

//aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Dtos(X[14]) > Y[7] + Y[1] + Dtos(Y[14])  } )  //ordena por representante + dt. ultima compra (mais antiga)
//chamado 002064 - 05/04/2011 - FR
aDadRe := Asort( aDadRep,,, { |X,Y| X[7] + X[1] + Transform( X[12] , "@E 99,999,999.99" ) > Y[7] + Y[1] + Transform( Y[12] , "@E 99,999,999.99" )  } )  //ordena por representante + dt. ultima compra (mais antiga)


REP->( DbCloseArea() )


nTotUltRS := 0
nTotUltKG := 0

cWeb		:= ""

cMailRepre 	:= ""
nLinhas 	:= 80
nMedia  	:= 0
nTotMedia	:= 0
cRepreAnt	:= ""
cMailSuper  := ""
nHandle := 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif

nCta := 1

If !lDentroSiga

	If Len(aDadRe) > 0
	  Do While nCta <= Len(aDadRe)
	     
	   		cCodRepre := aDadRe[nCta,1]
	   		cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]
	   		cSuper	  := aDadRe[nCta,7]
	   		cMailSuper:= aDadRe[nCta,15]
	   
		   cWeb := "" 
		   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
		   	cDirHTM  := "\Temp\"    
			cArqHTM  := "REL04_" + Alltrim(cCodRepre) +".HTM"   
			//cArqHTM  := "FLA04_" + Alltrim(cCodRepre) +".HTM"   
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
			
			//If Alltrim(cSuper) != '0229'
			//	titulo         := "Relatorio 04 - CLIENTES INATIVOS - CAIXAS (NAO COMPRAM HA MAIS DE 90 DIAS) - POR REPRESENTANTE"
			//Else
				titulo         := "Relatorio 04 - CLIENTES INATIVOS - CAIXAS (NAO COMPRAM HA MAIS DE 120 DIAS) - POR REPRESENTANTE"
			//Endif
				
	
	     
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
	   
	   If nLinhas >= 55
	   
	   		If nLinhas >= 55 .and. nCta > 1
						
			  		cWeb += '<div class="quebra_pagina"></div>'+LF
			   		//cWeb += '<div class="quebra_pagina">quebra aqui --> '+ str(nLinhas) + '</div>'+LF
			   		//nLinhas := 5 		
			Endif	
	   
	   			
	   	
	   		/////CABEÇALHO PÁGINA
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR025/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF
			
			nLinhas := 5
		
			//If nCta = 1 
				/////////////////////////////////////
				////LINHA REPRESENTANTE E SUPERVISOR
				/////////////////////////////////////
				cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
				cWeb += '</table>' + LF
			
			//Endif		
			
			nLinhas++
			nLinhas++
			
			///Cabeçalho relatório	      
			cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA DOS 90 DIAS</span></div></b></td>'+LF
			cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF			
			cWeb += '<tr>'+ LF
			nLinhas++		
			
			//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
			//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF	//média dos 90 dias
			   
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
			cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
			cWeb += '</strong></tr>'+ LF						
	   		nLinhas++
	   		
			nPag++
	
	   Endif
	   
	   Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) ) //.OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre) + "VD" )
	   		
	   		   		   	
	   		If nLinhas >= 54
	   			   			
	   			 			 		
		   		
		   		/////CABEÇALHO PÁGINA
				cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html><head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR025/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				cWeb += '</table></head>'+ LF
		
				nLinhas := 5
		
				/////////////////////////////////////
				////LINHA REPRESENTANTE E SUPERVISOR
				/////////////////////////////////////
				cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
				cWeb += '</table>' + LF
				nLinhas++
			
			
				///Cabeçalho relatório	      
				cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA DOS 90 DIAS</span></div></b></td>'+LF
				cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF			
				cWeb += '<tr>'+ LF
		        nLinhas++
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
				//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF	//média dos 90 dias
				   
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
				cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
				cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
				cWeb += '</strong></tr>'+ LF						
		   		nLinhas++
			   		
				nPag++
	
		    Endif
	      	
	      	//NOME CLIENTE    		
		    cWeb += '<td width="920"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
		    						
			/// última compra (R$ / KG / DATA)
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
			cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,14])  + '</span></td>'+LF  //DATA
			
			cWeb += '</tr>'+LF 		//finaliza a linha
			nLinhas++			        
		    			
			nTotUltRS += aDadRe[nCta,12]				
			nTotUltKG += aDadRe[nCta,13]
						      
		   	nCta++	   	
		   	   	
		   	   	
		   	If lDentroSiga
				IncRegua()	
			Endif
			
	   Enddo  		
	   			
				  		       
			cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			//nTotMedia:= 0
			//nTotMedKG:= 0
			nTotUltRS:= 0
			nTotUltKG:= 0
					
			////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1000" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
								
			////linha em branco
			cWeb += '<tr>'+LF
			cWeb += '<td width="1000" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
			cWeb += '</tr>'+LF
								
			///faz o rodapé
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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
					
								   			   			    
			///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
					
			///GRAVA O HTML
			Fwrite( nHandle, cWeb, Len(cWeb) )
			FClose( nHandle )
								                      
			cMailTo := cMailRepre + ";" + cMailSuper //e-mail
			//cMailTo := "flavia.rocha@ravaembalagens.com.br" 
			//cCopia  := "" 
			
								
			If Alltrim(cSuper) = '0255'
			  cMailTo += ";vendas.sp@ravaembalagens.com.br"
			
			ElseIf Alltrim(cSuper) = '0229'
				cMailTo += ";janaina@ravaembalagens.com.br"				
			
			Elseif Alltrim(cSuper) = '0244'
				cMailTo += ";janaina@ravaembalagens.com.br"
				
			Elseif Alltrim(cSuper) = '0245'
				cMailTo += ";marcos@ravaembalagens.com.br"
			
			Elseif Alltrim(cSuper) = '0248'
				cMailTo += ";josenildo@ravaembalagens.com.br"
			Endif
			
			cCopia  += ";flavia.rocha@ravaembalagens.com.br"
							
			cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo
					
			If Alltrim(cSuper) = '0255' .and. Substr(DtoS(dDatabase),7,2) = '01'		//o da Flávia Leite só executa mensalmente todo dia 1o.		
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )			
			Elseif Alltrim(cSuper) != '0255'
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			Endif			
							
			nLinhas := 80						
			nPag := 1		
	     
	
	  Enddo
	
	//Else
		//msgbox("array vazio")
	Endif

////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
Else     //se é dentro do siga 
	nCta := 1

	If Len(aDadRe) > 0
		cWeb := ""
		cSuper	  := aDadRe[nCta,7]
		 
	   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
	   	cDirHTM  := "\Temp\"    
		cArqHTM  := "REL04_" + Alltrim(cSuper) +"_CX.HTM"   
		//cArqHTM  := "FLA04_" + Alltrim(cSuper) +".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		
		//If Alltrim(cSuper) != '0229'
		//	titulo         := "Relatorio 04 - CLIENTES INATIVOS - CAIXAS (NAO COMPRAM HA MAIS DE 90 DIAS) - POR REPRESENTANTE"
		//Else
			titulo         := "Relatorio 04 - CLIENTES INATIVOS - CAIXAS (NAO COMPRAM HA MAIS DE 120 DIAS) - POR REPRESENTANTE"
		//Endif
	
	  Do While nCta <= Len(aDadRe)
	     
	   		cCodRepre := aDadRe[nCta,1]
	   		cNomeRepre:= aDadRe[nCta,2]
	   		cMailRepre:= aDadRe[nCta,3]	
	     
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
	   
		If nLinhas >= 54
	   	
	   	
	   		/////CABEÇALHO PÁGINA
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
			cWeb += '<html><head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR025/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
			cWeb += '</table></head>'+ LF
			
			nLinhas := 5
		    nPag++
		Endif
		
			/////////////////////////////////////
			////LINHA REPRESENTANTE E SUPERVISOR
			/////////////////////////////////////
			cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
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
			cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
			cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
			//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA DOS 90 DIAS</span></div></b></td>'+LF
			cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF			
			cWeb += '<tr>'+ LF
			nLinhas++				
			   
			cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
			cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
			cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
			cWeb += '</strong></tr>'+ LF						
	   		nLinhas++
	   		
		   
	   
	   Do While nCta <= Len(aDadRe) .and. (Alltrim(aDadRe[nCta,1]) = Alltrim(cCodRepre) ) //.OR. Alltrim(aDadRe[nCta,1]) $ Alltrim(cCodRepre) + "VD" )
	   		
	   		   		   	
	   		If nLinhas >= 54.5 			   			
	   			 			 		
		   		
		   		/////CABEÇALHO PÁGINA
				cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
				cWeb += '<html><head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:13px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR025/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				cWeb += '</table></head>'+ LF
		
				nLinhas := 4
				nPag++
		
				/////////////////////////////////////
				////LINHA REPRESENTANTE E SUPERVISOR
				/////////////////////////////////////
				cWeb += '<table width="1000" border="0" style="font-size:13px;font-family:Arial">'+LF
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Representante:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,1]) + "-" + Alltrim(aDadRe[nCta,2]) + '</span></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>E-mail:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(cMailRepre) + '</span></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong>Coordenador:</strong></span></div></td>'+LF
				cWeb += '<td colspan="12"><div align="Left"><span class="style3">'+ Alltrim(aDadRe[nCta,7]) + "-" + Alltrim(aDadRe[nCta,8]) + '</span></td></tr>'+LF
				cWeb += '</table>' + LF
				nLinhas++
			
			
				///Cabeçalho relatório	      
				cWeb += '<table width="1500" border="1" style="font-size:13px;font-family:Arial"><strong>'+ LF
				cWeb += '<td rowspan="2" width="920" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>CLIENTES</span></div></B></td>'+ LF
				//cWeb += '<td colspan="2"><div align="center"><span class="style3"><b>MEDIA DOS 90 DIAS</span></div></b></td>'+LF
				cWeb += '<td colspan="3"><div align="center"><span class="style3"><b>ULTIMA COMPRA</span></div></b></td>'+LF			
				cWeb += '<tr>'+ LF
		        nLinhas++
				//cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//media dos 90 dias   
				//cWeb += '<td width="300" align="center"><span class="style3">KG</span></td>'+ LF	//média dos 90 dias
				   
				cWeb += '<td width="300" align="center"><span class="style3">R$</span></td>'+ LF 	//última compra R$  
				cWeb += '<td width="300" align="center"><span class="style3">QTD</span></td>'+ LF 	//última compra KG  
				cWeb += '<td width="300" align="center"><span class="style3">DATA</span></td>'+ LF 	//última compra DATA  	
				cWeb += '</strong></tr>'+ LF						
		   		nLinhas++			   		
					
		    Endif
	      	
	      	//NOME CLIENTE    		
		    cWeb += '<td width="920"><span class="style3">'+ Alltrim(aDadRe[nCta,4]) + "/" + Alltrim(aDadRe[nCta,5]) + "-" + Alltrim(SUBSTR(aDadRe[nCta,6],1,25)) + '</span></td>'+LF        		
		    						
			/// última compra (R$ / KG / DATA)
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,12], "@E 9,999,999.99")  + '</span></td>'+LF  //R$
			cWeb += '<td width="300" align="right"><span class="style3">' + Transform(aDadRe[nCta,13], "@E 9,999,999.99")  + '</span></td>'+LF  //KG
			cWeb += '<td width="300" align="right"><span class="style3">' + Dtoc(aDadRe[nCta,14])  + '</span></td>'+LF  //DATA
			
			cWeb += '</tr>'+LF 		//finaliza a linha
			nLinhas++
			
			If nLinhas = 54
				nLinhas := nLinhas + 0.5
			Endif			        
		    			
			nTotUltRS += aDadRe[nCta,12]				
			nTotUltKG += aDadRe[nCta,13]
						      
		   	nCta++	   	
		   	   	
		   	   	
		   	If lDentroSiga
				IncRegua()	
			Endif
			
	   Enddo  		
	   			
				  		       
			cWeb += '<td width="920"><span class="style3"><b>TOTAL.....:</span></b></td>'
							
			///coluna média 90 dias (R$ e KG)
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedia,"@E 99,999,999.99")+ '</b></span></td>'+LF
			//cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotMedKG,"@E 99,999,999.99")+ '</b></span></td>'+LF
			///coluna última compra (R$, KG, DATA)
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltRS,"@E 99,999,999.99")+ '</b></span></td>'+LF
			cWeb += '<td width="300" align="right"><span class="style3"><b>'+ TRANSFORM( nTotUltKG,"@E 99,999,999.99")+ '</b></span></td>'+LF				
			cWeb += '<td width="300" align="right"><span class="style3"><b></b></span></td>'+LF
			cWeb += '</tr></table>'+LF
					
			nLinhas++
					
			////ZERA OS TOTAIS PARA NOVO REPRESENTANTE
			//nTotMedia:= 0
			//nTotMedKG:= 0
			nTotUltRS:= 0
			nTotUltKG:= 0		
			
			//QUEBRA PÁGINA POR VENDEDOR
			If nCta > 1						
				cWeb += '<div class="quebra_pagina"></div>'+LF
				//cWeb += '<div class="quebra_pagina">quebra aqui --> '+ str(nLinhas) + '</div>'+LF
				nLinhas := 80
			Endif		
				
			
	
	  Enddo  
	  ///TERMINOU DE GERAR TODOS OS REPRESENTANTES NO ARQUIVO	  
	  ///faz o rodapé
		cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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
					
								   			   			    
		///FECHA O HTML PARA ENVIO
		cWeb += '</body> '
		cWeb += '</html> '
					
		///GRAVA O HTML
		Fwrite( nHandle, cWeb, Len(cWeb) )
		FClose( nHandle )
							                      
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
		Endif
	
		cCopia  := ""		
		cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := "REL 04 - " + cSuper // titulo
					
		U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
		MsgInfo("Rel 04 - Você recebeu um e-mail deste Relatório.")
	  
	  
	
	Else
		MsgInfo("Não Existem dados para os parâmetros digitados...")
	Endif
	


Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lDentroSiga
	// Habilitar somente para Schedule
	Reset environment
Endif


Return


*********************************************************
Static Function fUltiCompra( cCliente, cLoja, cVendedor, cTipo )
*********************************************************

Local cQuery 	:= ""
Local cUltimes 	:= ""
Local LF		:= CHR(13)+CHR(10)
Local dUltima	:= Ctod("  /  /    ")
Local nReais	:= 0
Local nKilos	:= 0 

cQuery := " SELECT TOP 1 F2_EMISSAO, ROUND(SUM(D2_QUANT),2) AS QTDE ,  " +LF
cQuery += " ROUND(SUM(D2_TOTAL),2) AS VALOR, F2_VEND1, A3_NOME, F2_CLIENTE, F2_LOJA, A1_NOME, A3_GEREN " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SF2.F2_VEND1 AND ( RTRIM(A3_SUPER) <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " ,A3_EMAIL, A3_ATIVO " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("SD2") + " SD2 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF2") + " SF2 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SF4") + " SF4 WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF

cQuery += " WHERE SF2.F2_EMISSAO >= '" + Dtos(dDatabase - 90) + "' AND SF2.F2_EMISSAO <= '" + Dtos(dDatabase) + "' " + LF

cQuery += " AND RTRIM(B1_TIPO) != 'AP' " +LF //Despreza Apara 
cQuery += " AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') " +LF
cQuery += " AND SD2.D2_TES = SF4.F4_CODIGO " + LF
cQuery += " AND SF4.F4_DUPLIC = 'S' " + LF

cQuery += " AND RTRIM(SB1.B1_SETOR) = '39' " +LF
cQuery += " AND SB1.B1_TIPO = 'PA' "+LF
cQuery += " AND SD2.D2_TES NOT IN( '540','516') " +LF

cQuery += " AND D2_COD = B1_COD     "  +LF

cQuery += " AND D2_DOC = F2_DOC     " +LF
cQuery += " AND D2_SERIE = F2_SERIE " +LF
cQuery += " AND D2_FILIAL = F2_FILIAL " +LF

cQuery += " AND F2_CLIENTE = D2_CLIENTE " +LF
cQuery += " AND F2_LOJA = D2_LOJA       " +LF

cQuery += " AND F2_CLIENTE = A1_COD     " +LF
cQuery += " AND F2_LOJA = A1_LOJA       " +LF

//cQuery += " AND F2_VEND1 = A3_COD " +LF
//cQuery += " AND A1_VEND = A3_COD " + LF
cQuery += " AND A3_ATIVO <> 'N' " + LF

//cQuery += " AND RTRIM(F2_VEND1) = '" + Alltrim(cVendedor) + "' " + LF 
cQuery += " AND RTRIM(F2_CLIENTE) = '" + Alltrim(cCliente) + "' " + LF
cQuery += " AND RTRIM(F2_LOJA) = '" + Alltrim(cLoja) + "' " + LF 

//cQuery += " AND SC6.C6_NOTA <> '' " + LF
//cQuery += " AND SC6.C6_QTDENT = SC6.C6_QTDVEN " + LF

/*
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ''  "+LF
*/
cQuery += " AND SD2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.D_E_L_E_T_ = '' " +LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  "+LF


cQuery += " GROUP BY F2_VEND1, F2_CLIENTE, F2_LOJA, A3_NOME, A1_NOME, F2_EMISSAO, A3_GEREN, A3_SUPER, A3_EMAIL, A3_ATIVO " +LF
cQuery += " ORDER BY F2_EMISSAO DESC " +LF

//MemoWrite("C:\temp\ulticompra.sql", cQuery)

If Select("SC5U") > 0
	DbSelectArea("SC5U")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SC5U"

TCSetField( "SC5U", "F2_EMISSAO", "D")

SC5U->( DbGoTop() )
While SC5U->( !EOF() )

	dUltima := SC5U->F2_EMISSAO
	nReais  := SC5U->VALOR
	nQTDE  := SC5U->QTDE
	SC5U->(DBSKIP())

Enddo

If cTipo = "D"
	Return(dUltima)

Elseif cTipo = "R"
	Return(nReais)

Elseif cTipo = "K"
	Return(nQTDE)

Endif


*******************************************
Static Function fVerFIN(cCliente, cLoja)
*******************************************

Local cQuery := ""
Local LF := CHR(13) + CHR(10) 
Local nQtPEND := 0

Local lTemPend := .F.

cQuery += " Select count(*) as QTPEND from "
cQuery += " " + RetSqlName("SE1") + " SE1 " + LF
cQuery += " where E1_CLIENTE = '" + Alltrim(cCliente) + "' " + LF
cQuery += " and E1_LOJA = '" + Alltrim(cLoja) + "' " + LF
//cQuery += " and SE1.E1_FILIAL = '" + xFilial("SE1") + "' " + LF
cQuery += " and SE1.D_E_L_E_T_ = '' " + LF
cQuery += " and E1_VENCTO <= '" + DtoS(dDatabase - 121) + "' " + LF
cQuery += " and E1_BAIXA = '' " + LF
MemoWrite("C:\Temp\cli_pend.sql",cQuery)

If Select("FINX") > 0
	DbSelectArea("FINX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FINX"
//TCSetField( "REP", "C5_EMISSAO", "D")


FINX->( DbGoTop() )

While FINX->( !EOF() )
	nQtPEND := FINX->QTPEND
	FINX->(DBSKIP())
Enddo

If nQtPEND > 0
	lTemPend := .T.
Endif 

RETURN(lTemPend)