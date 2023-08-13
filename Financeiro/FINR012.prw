#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FINR012 - Relatório de títulos em atraso
//Objetivo: RELATÓRIO DIÁRIO DE TÍTULOS EM ABERTO 
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 05/11/2013
//AGENDAMENTO : SEMANAL
//Solicitado por: Ana Nóbrega - Financeiro
//--------------------------------------------------------------------------
/*/

********************************
User Function FINR012()
********************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	///FAZ O ENVIO DE UM ARQUIVO CONTENDO VÁRIOS REPRESENTANTES
  	
  	//ALERT("HUMBERTO .F.")
  	///RAVA EMB
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	TitAberto( .F. )	//chama a função do relatório    //TitAberto(lHumberto) -> se lHumberto = .T., envia um arquivo só contendo todos os representantes
  	Reset Environment
  	
  	///RAVA CAIXAS
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	TitAberto()	
  	Reset Environment
  	
  
Else
  lDentroSiga := .T.
  TitAberto( .F. )
  
EndIf


Return 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*******************************
Static Function TitAberto() 
*******************************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Diario de Titulos em Aberto "
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FINR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR012" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FINR012"
Private cString := ""
Private nLin		 := 80
Private cEmpresa:= ""

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava - " + SM0->M0_FILIAL
Endif

///
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 

If lDentroSiga
	MsgInfo( "Iniciando programa: Rel.Titulos Abertos: " + Dtoc( Date() ) + ' - ' + Time() )
Endif
   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "RELATORIO DIARIO DE TITULOS EM ABERTO POR REPRESENTANTE - ORGAOS PUBLICOS - VENCIDOS HA MAIS DE 45 DIAS - " + cEmpresa 

//
//CABECs :
/*
CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	  DIAS	    VALOR	  %COMISSÃO	  %BÔNUS	VALOR PREV. 	VALOR PREV.  TOTAL PREV.
TÍTULO	CLIENTE			                EMISSÃO	  VENCIDOS	TÍTULO	  PREVISTA	  PREVISTO	COMISSÃO	    BÔNUS	     A RECEBER

*/


Cabec1         := ""
Cabec2		   := ""



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
Local cTitulo := ""
Local cParcela:= ""
Local cCliente:= ""
Local cLoja   := ""
Local cNomeCli:= ""
Local nPrazo  := 0
Local nValTit := 0
Local nValMerc:= 0
Local nPorcomis:= 0
Local nValcomis:= 0
Local nValbonus:= 0
Local cPedido  := ""
Local cModal   := ""
Local cNomeModal:= ""

Local nTotRec  := 0
Local nTotTit  := 0
Local nTotcomis:= 0
Local nTotbonus:= 0
Local nTotRecGer:= 0

Local acomis   := {}
Local acomis2  := {}
Local nPorcbonus:= 0

Local cVendedor := ""
Local cVendAnt  := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local dEmissao 	:= Ctod("  /  /    ")
Local dBaixa 	:= Ctod("  /  /    ")
Local dPagto   	:= Ctod("  /  /    ")
 
Local aUsua  	:= {}
Local cNomeuser := ""
Local cMailDestino := ""
Local cCodUser	:= ""
Local nLinhas	:= 80 
Local cWeb		:= "" 
Local nPag		:= 1

Local nPag := 1   
Local nLinhas := 80
Local cWeb	:= ""
Local nCta	:= 1

Local cMailTo := ""
Local cCopia  := ""
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local nHandle := 0
Local aUsua	  := {}

Local cCabec1 := ""
Local cCabec2 := "NÚMERO" + Space(6) + "CÓDIGO DO" +Space(5)+"NOME DO CLIENTE"+Space(5)+"DATA"+Space(8)+   "DATA"+Space(7)+ "PRAZO"+ Space(7)+  "VALOR"+Space(7)+ "%" + Space(9)      + "%" + Space(10) + "VALOR"+Space(14)+"VALOR" + Space(10)+ "TOTAL A"

Local cCabec3 := "TÍTULO"+Space(6)+   "CLIENTE"+ Space(27)+                          "EMISSÃO"+Space(5)+"PAGTO."+Space(5)+"RECBTO."+ Space(4)+ "TÍTULO"+Space(4)+"COMISSÃO"+Space(3)+"BÔNUS"+Space(8)+"COMISSÃO"+Space(10)+"BÔNUS"+Space(11)  +"RECEBER"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10) 

Local MV_PAR01 := Ctod("01/01/2000")     //emissao
Local MV_PAR02 := Ctod("31/12/2049")     //emissao
Local MV_PAR03 := ""
Local MV_PAR04 := "ZZZZZZ"
Local MV_PAR05 := Ctod("01/01/2000") //vencto
Local MV_PAR06 := Ctod("31/12/2049") //vencto
Local nGerTotRec := 0
Local nGerTotTit := 0
Local nGerTotcomis := 0
Local nGerTotbonus := 0

Private cCodUser:= ""


cQuery := "SELECT " + LF
cQuery += " CASE WHEN A1_SATIV1 <> '000009' THEN '000010' ELSE A1_SATIV1 END A1_SATIV1" + LF 
cQuery += " , A3_COD, E1_VEND1, A3_NREDUZ, E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_PEDIDO " + LF
cQuery += " , F2_VALMERC, F2_VALBRUT, E1_COMIS1, E1_VALCOM1, E1_BAIXA " + LF
cQuery += " ,A3_EMAIL, A1_NREDUZ, A1_NOME,E1_CLIENTE,E1_LOJA ,E1_EMISSAO " + LF
cQuery += " ,F2_DOC, F2_SERIE, F2_EMISSAO, D2_PEDIDO, F2_LOCALIZ, F2_EST, F2_REALCHG " + LF 

cQuery += " , CAST(CAST(GETDATE() AS DATETIME) - CAST(E1_VENCREA AS DATETIME)AS INTEGER) AS DIAS " + LF 

cQuery += " FROM " + RetSqlName("SA1") + " SA1  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SE1") + " SE1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SF2") + " SF2 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) "+LF

cQuery += "  WHERE " + LF

cQuery += " E1_EMISSAO >= '" + DTOS(mv_par01) + "'  AND E1_EMISSAO <=  '" + DTOS(mv_par02) + "' "+LF
cQuery += " AND RTRIM(E1_VEND1) >= '" + Alltrim(mv_par03) + "' AND RTRIM(E1_VEND1) <= '" + Alltrim(mv_par04) + "' "+LF
cQuery += " AND E1_VENCTO >= '" + DTOS(mv_par05) + "'  AND E1_VENCTO <=  '" + DTOS(mv_par06) + "' "+LF

cQuery += " AND E1_BAIXA = '' " + LF

cQuery += "  AND E1_NUM = F2_DOC " + LF
cQuery += "  AND E1_NUM = D2_DOC " + LF

cQuery += "  AND D2_DOC = F2_DOC " + LF
cQuery += "  AND D2_SERIE = F2_SERIE " + LF

cQuery += "  AND E1_PREFIXO = F2_SERIE " + LF
cQuery += "  AND E1_PREFIXO = D2_SERIE " + LF

cQuery += "  AND F2_CLIENTE = A1_COD " + LF
cQuery += "  AND F2_LOJA = A1_LOJA" + LF

cQuery += "  AND E1_CLIENTE = F2_CLIENTE" + LF
cQuery += "  AND E1_LOJA = F2_LOJA" + LF

cQuery += "  AND E1_VEND1 = A3_COD " + LF


//cQuery += "  AND RTRIM(A3_SUPER) = '0228'" + LF      ///TESTE, RETIRAR

//cQuery += " AND A3_COD IN ( '0158' , '0195', '0201' ) " + LF          ///TESTE RETIRAR

cQuery += " AND RTRIM(A1_SATIV1) = '000009' " + LF
cQuery += " AND RTRIM(A3_ATIVO) <> 'N' " + LF
cQuery += " AND CAST(CAST(GETDATE() AS DATETIME) - CAST(E1_VENCTO AS DATETIME)AS INTEGER) >= 45 " + LF //vencidos há mais de 45 dias


cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' AND SE1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " +LF
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' " +LF

cQuery += " GROUP BY " + LF
cQuery += " A1_SATIV1 ,A3_COD, E1_VEND1, A3_NREDUZ, E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_PEDIDO " + LF
cQuery += " ,F2_VALMERC, F2_VALBRUT, E1_COMIS1,F2_VALBRUT,E1_VALCOM1, E1_BAIXA, E1_VENCREA, A3_EMAIL  " + LF
cQuery += " ,A1_NREDUZ, A1_NOME,E1_CLIENTE,E1_LOJA ,E1_EMISSAO ,F2_DOC, F2_SERIE, F2_EMISSAO, D2_PEDIDO, F2_LOCALIZ, F2_EST, F2_REALCHG  " + LF
cQuery += "  ORDER BY E1_VEND1, A1_SATIV1, E1_NUM, E1_PREFIXO " + LF
cQuery += " , E1_PARCELA " + LF

MemoWrite("C:\Temp\FINR012.sql", cQuery )

If Select("SE1X") > 0
	DbSelectArea("SE1X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE1X"

TCSetField( "SE1X", "E1_EMISSAO", "D")
TCSetField( "SE1X", "E1_BAIXA"  , "D") 
TCSetField( "SE1X", "E1_VENCTO" , "D")
TCSetField( "SE1X", "F2_EMISSAO", "D")
TCSetField( "SE1X", "F2_REALCHG", "D")



SE1X->( DbGoTop() )


//SetRegua(0)

//
//CABECs :
/*
CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	  DIAS	    VALOR	  %COMISSÃO	  %BÔNUS	VALOR PREV. 	VALOR PREV.  TOTAL PREV.
TÍTULO	CLIENTE			                EMISSÃO	  VENCIDOS	TÍTULO	  PREVISTA	  PREVISTO	COMISSÃO	    BÔNUS	     A RECEBER

*/

Do While SE1X->( !EOF() )

    cModal	  := ""
    dRealChg  := Ctod("  /  /    ")
	cVendedor := SE1X->E1_VEND1
	cSegmento := SE1X->A1_SATIV1
	cNomeVend := SE1X->A3_NREDUZ
	cMailVend := SE1X->A3_EMAIL
	
	cTitulo := SE1X->E1_NUM
	cSerie  := SE1X->E1_PREFIXO
	cParcela:= SE1X->E1_PARCELA
	cCliente:= SE1X->E1_CLIENTE
	cLoja   := SE1X->E1_LOJA
	cPedido := SE1X->D2_PEDIDO
	cLocaliz:= SE1X->F2_LOCALIZ
	
	cNomeCli := SE1X->A1_NREDUZ
	dEmissao := SE1X->E1_EMISSAO
	dVencto  := SE1X->F2_EMISSAO
	If !Empty(SE1X->F2_REALCHG)
		dRealChg := SE1X->F2_REALCHG
	Endif
			
	nValbonus	:= 0
	nPorcbonus	:= 0
	nValTit		:= 0
	nValMerc	:= 0
	nPorcomis	:= 0
	nValcomis	:= 0
	nPrazo		:= 0
	
	nDiasVenc := 0
	nPrazoEnt := 0
	//FR - 04/10/12 - CHAMADOS: 00000145 / 00000158
	If Empty(SE1X->F2_REALCHG)  //SE A MERCADORIA AINDA NÃO CHEGOU NO CLIENTE (ENTREGA CONFIRMADA)
		nDiasVenc := Round((dDatabase - dEmissao),0)
		nPrazoEnt := U_fPrazoMin( SE1X->F2_EST )
	Else 
		nDiasVenc := Round((dDatabase - ( dRealChg + 30) ),0)  //(SE1X->F2_REALCHG + 30)
	Endif
	
	
	cModal := U_GetModali(SE1X->E1_PEDIDO)	

	nValTit   := SE1X->F2_VALBRUT  //SE1X->F2_VALMERC CHAMADO 002243 - JANDERLEY SOLICITOU EXIBIR O VALOR DO TÍTULO COM IPI
	nValMerc  := SE1X->F2_VALMERC
	nPorcomis := SE1X->E1_COMIS1
	
	//If (nDiasVenc - nPrazoEnt) > 0
		//nDias := (nDiasVenc - nPrazoEnt)
	//Else
		//nDias := nDiasVenc
	//Endif
	nDias := 0
	
	
	nValcomis := nValMerc * (nPorcomis / 100)  //nValTit * (nPorcomis / 100)
	
	nPorcbonus:= U_FINC002(cPedido, nDiasVenc, nPrazoEnt )
	nValbonus := nValMerc * (nPorcbonus / 100)		//nValTit * (nPorcbonus / 100)	
	
	nTotrec:= ( nValcomis + nValbonus)		

	
	Aadd(acomis2, { cTitulo,;			//1
					 cCliente,;        	//2
					 cLoja,;           	//3
					 cNomeCli,;        	//4
					 dEmissao,;       	//5
					 nDiasVenc,;       	//6
					 nValTit,;         	//7
					 nPorcomis,;       	//8
					 nValcomis,;       	//9
					 nValbonus,;       	//10
					 nTotrec,;         	//11
					 cVendedor,;       	//12
					 cSegmento,; 		//13
					 cNomeVend,;  		//14		
					 nPorcBonus,;		//15
					 cMailVend ,;		//16
					 nPrazoEnt,;		//17
					 nDias,;			//18  
					 cParcela,;  		//19
					 cModal,; 			//20
					 dRealChg } )		//21
					 
	SE1X->(Dbskip())
 
Enddo


acomis := Asort( acomis2,,, { |X,Y| X[12] + X[13] + X[1] + X[19] <  Y[12] + Y[13] + Y[1] + Y[19]  } ) 
//ordena por : Vendedor + Segmento + Título + Parcela
DbSelectArea("SE1X")
DbCloseArea()


nValbonus	:= 0
nPorcbonus	:= 0
nvalTit		:= 0
nPorcomis	:= 0
nValcomis	:= 0
nTotrec		:= 0
nTotRecGer:= 0
nCta		:= 1
cVendedor	:= ""
cVendAnt    := ""
cNomeVend	:= ""
cSegmento	:= ""
cDirHTM		:= ""
cArqHTM		:= ""
lCabec      := .F.

If Len(acomis) > 0


		//se não é dentro do Siga (Schedule) criará um arq. por vendedor
		//se estiver dentro do Siga ou Schedule só para Humberto, criará um arquivo contendo todos os vendedores
		
		////CRIA O ARQUIVO DO HTML
		cDirHTM  := "\Temp\"    
		cArqHTM  := "FINR012_" + Alltrim(cEmpresa) +".HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
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
		
	                		
	Do while nCta <= Len(acomis)
		cVendedor := acomis[nCta,12]
		cNomeVend := Alltrim(acomis[nCta,14]) 
		cMailVend := Alltrim(acomis[nCta,16])					
		cSegmento := acomis[nCta,13]
		cNomeSeg  := ""
		SX5->(Dbsetorder(1))
		If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
			If Alltrim(cSegmento) = '000009'
				cNomeSeg := Alltrim(SX5->X5_DESCRI)
				//cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS PARA LICITACAO"
			Else
				cNomeSeg := "PRIVADO"
				//cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
			Endif
		Endif
	
		If nCta > 1
			cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF					
			cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,12]) + " - " + Alltrim(acomis[nCta,14]) + '</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
			cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,16]) + '</span></div></td>'+LF
			cWeb += '</tr>'+LF
			nLinhas++
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
					
			cWeb += '<td width="700"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg +'</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF
			nLinhas++			
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++		
								
			cWeb += '</table>' + LF
			nLinhas++
						
			///Cabeçalho relatório		      
			cWeb += '<table width="1300" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
			cWeb += '<td width="180"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
			cWeb += '<td width="320"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF 
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>DT CHG.CLIENTE</span></div></b></td>'+LF
			cWeb += '<td width="100"><div align="center"><span class="style3"><b>DIAS VENCIDOS + PRZ.ENTREGA</span></div></b></td>'+LF
			cWeb += '<td width="180"><div align="center"><span class="style3"><b>VALOR TOTAL TITULO (com IPI)</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO PREVISTA</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS PREVISTO</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>VALOR PREV. COMISSAO</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>VALOR PREV. BONUS</span></div></b></td>'+LF
			cWeb += '<td width="150"><div align="center"><span class="style3"><b>TOTAL PREV. A RECEBER</span></div></b></td>'+LF
		
			cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
				
			nLinhas++
			nLinhas++		   
			//nPag++
		
		Endif
        
		Do while nCta <= Len(acomis) .and. Alltrim(acomis[nCta,12]) = Alltrim(cVendedor)
							
				
			If nLinhas >= 45
				cSegmento := acomis[nCta,13]
				cNomeSeg  := ""
				SX5->(Dbsetorder(1))
				If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
					If Alltrim(cSegmento) = '000009'
						cNomeSeg := Alltrim(SX5->X5_DESCRI)
						//cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS PARA LICITACAO"
					Else
						cNomeSeg := "PRIVADO"
						//cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
					Endif
				Endif
					
				If nCta > 1
					cWeb += '</table>'
					cWeb += '<div class="quebra_pagina"></div>'+LF
				Endif
				
										
				nLinhas := 5			
			    ///Cabeçalho PÁGINA
		      	cWeb += '<html>'+LF
				cWeb += '<head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FINR002R/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				cWeb += '</table></head>'+ LF            
					
			
			  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
					
				cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>Data: ' + Dtoc(dDatabase) + '</strong></span></div></td>'+ LF
				cWeb += '</tr>'+LF	//encerra a linha e dá início a uma nova
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,12]) + " - " + Alltrim(acomis[nCta,14]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,16]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++			
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
						
				cWeb += '<td width="700"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg +'</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++			
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++		
									
				cWeb += '</table>' + LF
				nLinhas++
								
				///Cabeçalho relatório		      
				cWeb += '<table width="1300" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
				cWeb += '<td width="180"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
				cWeb += '<td width="320"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF 
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>DT CHG.CLIENTE</span></div></b></td>'+LF
				cWeb += '<td width="100"><div align="center"><span class="style3"><b>DIAS VENCIDOS + PRZ.ENTREGA</span></div></b></td>'+LF
				cWeb += '<td width="180"><div align="center"><span class="style3"><b>VALOR TOTAL TITULO (com IPI)</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO PREVISTA</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS PREVISTO</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>VALOR PREV. COMISSAO</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>VALOR PREV. BONUS</span></div></b></td>'+LF
				cWeb += '<td width="150"><div align="center"><span class="style3"><b>TOTAL PREV. A RECEBER</span></div></b></td>'+LF
			
				cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
					
				nLinhas++
				nLinhas++		   
				nPag++
				lCabec := .T.
				
			Endif
						
			cNomeModal := fNomeModal(acomis[nCta,20])
			////IMPRESSÃO DOS DADOS...	 				
			If ( acomis[nCta,6] ) > 30 //se vencido há mais de 30 dias, pinta de amarelo
				cWeb += '<td width="180" align="left" bgcolor="#FFFFC0"><span class="style3">'+ Alltrim(acomis[nCta,1]) +  " / " + Alltrim(acomis[nCta,19]) + '</span></td>'+LF      				//título/PARCELA
				cWeb += '<td width="320" align="left" bgcolor="#FFFFC0"><span class="style3">'+ Alltrim(acomis[nCta,20]) + " - " + Alltrim(cNomeModal) +'</span></td>'+LF      				//modalidade
				cWeb += '<td width="150" align="left" bgcolor="#FFFFC0"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ '</span></td>'+LF  	//cod.cliente/loja
				cWeb += '<td width="300" align="left" bgcolor="#FFFFC0"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
				cWeb += '<td width="150" align="center" bgcolor="#FFFFC0"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
				cWeb += '<td width="150" align="center" bgcolor="#FFFFC0"><span class="style3">' + Dtoc(acomis[nCta,21]) + ' </span></td>'+LF        			//dt.CHEGADA REAL
				If Empty(acomis[nCta,21])
					cWeb += '<td width="100" align="right" bgcolor="#FFFFC0"><span class="style3">' + Transform(acomis[nCta,6], "@E 9999")  + "+" + Transform(acomis[nCta,17], "@E 9999")+ '</span></td>'+LF  	//Dias vencidos+prazo entrega
				Else
					cWeb += '<td width="100" align="right" bgcolor="#FFFFC0"><span class="style3">' + Transform(acomis[nCta,6], "@E 9999")  + '</span></td>'+LF  	//Dias vencidos (qdo tem data chegada real, não imprime prz entrega
				Endif						
				cWeb += '<td width="180" align="right" bgcolor="#FFFFC0"><span class="style3">'+ Transform(acomis[nCta,7],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
				cWeb += '<td width="150" align="right" bgcolor="#FFFFC0"><span class="style3">' + Transform(acomis[nCta,8], "@E 99.99")  + '</span></td>'+LF  			//% comissão
				cWeb += '<td width="150" align="right" bgcolor="#FFFFC0"><span class="style3">' + Transform(acomis[nCta,15], "@E 99.99")  + '</span></td>'+LF  			//% bonus
				cWeb += '<td width="150" align="right" bgcolor="#FFFFC0"><span class="style3">'+ Transform(acomis[nCta,9],"@E 99,999,999.99")+' </span></td>'+LF        	//Val.comissão
				cWeb += '<td width="150" align="right" bgcolor="#FFFFC0"><span class="style3">' + Transform(acomis[nCta,10], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
				cWeb += '<td width="150" align="right" bgcolor="#FFFFC0"><span class="style3">'+ Transform(acomis[nCta,11],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
				
			Else
				cWeb += '<td width="180" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) +  " / " + Alltrim(acomis[nCta,19]) + '</span></td>'+LF      				//título/PARCELA
				cWeb += '<td width="320" align="left"><span class="style3">'+ Alltrim(acomis[nCta,20]) + " - " + Alltrim(cNomeModal) +'</span></td>'+LF      				//modalidade
				cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
				cWeb += '<td width="300" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
				cWeb += '<td width="150" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
				cWeb += '<td width="150" align="center"><span class="style3">' + Dtoc(acomis[nCta,21]) + ' </span></td>'+LF        			//dt.CHEGADA REAL				
				If Empty(acomis[nCta,21])
					cWeb += '<td width="100" align="right"><span class="style3">' + Transform(acomis[nCta,6], "@E 9999")  + "+" + Transform(acomis[nCta,17], "@E 9999")+ '</span></td>'+LF  	//Dias vencidos+prazo entrega
				Else
					cWeb += '<td width="100" align="right"><span class="style3">' + Transform(acomis[nCta,6], "@E 9999")  + '</span></td>'+LF  	//Dias vencidos+prazo entrega
				Endif
				cWeb += '<td width="150" align="right"><span class="style3">'+ Transform(acomis[nCta,7],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
				cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,8], "@E 99.99")  + '</span></td>'+LF  			//% comissão
				cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,15], "@E 99.99")  + '</span></td>'+LF  			//% bonus
				cWeb += '<td width="150" align="right"><span class="style3">'+ Transform(acomis[nCta,9],"@E 99,999,999.99")+' </span></td>'+LF        	//Val.comissão
				cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,10], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
				cWeb += '<td width="150" align="right"><span class="style3">'+ Transform(acomis[nCta,11],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
			Endif
									
			cWeb += '</tr>'+LF
				
			cSegAnt := acomis[nCta,13]
						
			///totais por vendedor
			nTotRec		+= acomis[nCta,11]  ///comissão + bônus (caso haja)
			nTotTit		+= acomis[nCta,7]
			nTotcomis	+= acomis[nCta,9]
			nTotbonus	+= acomis[nCta,10]
			///total geral (fim do relatório)
			nTotRecGer  += acomis[nCta,11]					
			nGerTotRec  += acomis[nCta,11]
			nLinhas++		 
						 
			nCta++
			If nLinhas < 45
				lCabec := .F.
			Endif
			
		Enddo //CAIXINHA VENDEDOR		
			
		/////TOTALIZA REPRESENTANTE  (no siga fica na mesma página)
		cWeb += '<td width="180"><span class="style3"><b>TOTAL REPRESENTANTE:</span></b></td>' +LF       //titulo
		cWeb += '<td width="320" align="right"><span class="style3"></span></td>'+LF  //modalidade
		cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
		cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF        //nome cliente
		cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
		cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF        //dt.CHEGADA REAL
		cWeb += '<td width="100" align="right"><span class="style3"></span></td>'+LF  //dias vencidos
		cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
		cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
		cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
		cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
		cWeb += '<td width="150" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
		cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
		cWeb += '</strong></tr>'+LF
		nLinhas++
							
		//total geral dentro do Siga				
		nGerTotTit		+= nTotTit
		nGerTotcomis	+= nTotcomis
		nGerTotbonus	+= nTotbonus
		 					  			
		////zera totais
		nTotRec		:= 0
		nTotTit		:= 0 
		nTotcomis	:= 0
		nTotbonus	:= 0
		//////GRAVA O HTML 
		Fwrite( nHandle, cWeb, Len(cWeb) )				
		cWeb := ""
		
		cWeb += '</table>'+LF
		cWeb += '<br>'+LF
		cWeb += '<br>'+LF
	
		//nLinhas := 80
		
		///ZERA O TOTAL GERAL DO REPRESENTANTE
		nTotRecGer := 0
				
	Enddo //geral do array
	
	
	/////TOTALIZA GERAL
	cWeb += '<br>'+LF
	cWeb += '<br>'+LF
	cWeb += '<table width="1300" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
	cWeb += '<td width="180"><span class="style3"><b>TOTAL GERAL </span></b></td>' +LF       //titulo
	cWeb += '<td width="320" align="right"><span class="style3"></span></td>'+LF  //modalidade
	cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
	cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF        //nome cliente
	cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
	cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF        //dt.CHEGADA REAL
	cWeb += '<td width="100" align="right"><span class="style3"></span></td>'+LF  //dias vencidos
	cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nGerTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
	cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
	cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
	cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nGerTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
	cWeb += '<td width="150" align="right"><span class="style3"><b>' + Transform(nGerTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
	cWeb += '<td width="150" align="right"><span class="style3"><b>'+ Transform(nGerTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber

	cWeb += '</strong></tr>'+LF
	nLinhas++
		
	///faz o rodapé
	cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
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
							
	//////GRAVA O HTML 
	Fwrite( nHandle, cWeb, Len(cWeb) )
	FClose( nHandle )
		
	If lDentroSiga	
		///////////ENVIA PARA O USUÁRIO QUE ESTÁ LOGADO NO SISTEMA
		cCodUser := __CUSERID     
							
		PswOrder(1)
		If PswSeek( cCoduser, .T. )
		   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
		   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
		   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
		Endif
				
		cCopia  := ""
		cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := titulo										
		SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	
	
		MsgInfo("Relatório Gerado, Verifique o seu E-mail.")
	
	Else
		
		cMailTo := ""				
		cMailTo += "ana.nobrega@ravaembalagens.com.br"		
		
		cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox." + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
		cCorpo  += cMailTo + CHR(13) + CHR(10)
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := titulo		
										
		//cMailTo := ""  //retirar
		//cCopia  := ";flavia.rocha@ravaembalagens.com.br"
				
		lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
		If !lEnviou         //faz a tentativa 3 vezes
			lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
			If !lEnviou
				lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
				If !lEnviou
					lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
				Endif
			Endif				
		Endif	
	
	Endif //do lDentrosiga
	
Else //len aComis
	If lDentroSiga
		MsInfo("Não existem dados a serem gerados.")
	Endif

Endif



//////////////////
//If !lDentroSiga
//	Reset Environment
//Endif

Return

///Função que retorna o nome da Modalidade baseado no código
*********************************
Static Function fNomeModal(cModal) 
*********************************

Local cNomeModal := ""

/*
01    	PREGAO PRESENCIAL                                      
02    	PREGAO ELETRONICO                                      
03    	CONCORRENCIA PUBLICA                                   
04    	TOMADA DE PRECO                                        
05    	CARTA CONVITE                                          
06    	DISPENSA DE LICITACAO                                  
07    	COTA ELETRONICA                                        
08    	ESTIMATIVA                                             
09    	ADESAO                                                 
10    	PRORROGACAO                                            
11    	ACRESCIMO                                              
12    	CONVITE ELETRONICO                                     
*/



Do case
	Case cModal = '01' 
		cNomeModal := "PREGAO PRESENCIAL"
	
	Case cModal = '02'
		cNomeModal := "PREGAO ELETRONICO"
	
	Case cModal = '03'
		cNomeModal := "CONCORRENCIA PUBLICA"
	
	Case cModal = '04'
		cNomeModal := "TOMADA DE PRECO"
	
	Case cModal = '05'
		cNomeModal := "CARTA CONVITE"
	
	Case cModal = '06'
		cNomeModal := "DISPENSA DE LICITACAO"
	
	Case cModal = '07'
		cNomeModal := "COTA ELETRONICA"
	
	Case cModal = '08'
		cNomeModal := "ESTIMATIVA"
	
	Case cModal = '09'
		cNomeModal := "ADESAO"
	
	Case cModal = '10'
		cNomeModal := "PRORROGACAO"
	
	Case cModal = '11'
		cNomeModal := "ACRESCIMO"
	
	Case cModal = '12'
		cNomeModal := "CONVITE ELETRONICO"
Endcase

Return(cNomeModal)



******************************************************************
Static Function SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= "" //GetMV( "MV_RELACNT" )
cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")
		//conout(Replicate("*",60))
		//conout("FATR011")
	   //	conout("Relatorio Acomp. Cliente " + Dtoc( Date() ) + ' - ' + Time() )
		conout("E-mail nao enviado")
		conout(Replicate("*",60))
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


