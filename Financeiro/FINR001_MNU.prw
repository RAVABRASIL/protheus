#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FINR001 - Menu Siga 
//Objetivo: RELATÓRIO DE COMISSÃO DE REPRESENTANTE - LINHA MÉDICO HOSPITALAR
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 18/08/2010
//--------------------------------------------------------------------------
/*/

********************************
User Function FINR001()
********************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

///IMPRIME DENTRO DO SIGA (IMPRESSÃO EM DISCO / SPOOL / DIRETO NA PORTA)
///PORQUE NO REL. HTML NÃO CABIA QUANDO SELECIONADO ' ' a 'ZZZZZZ'
///REALIZADO EM 05/01/2011 - Por Flávia Rocha

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Comissao de Representante."
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
Private nomeprog     := "FINR001_MNU" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR001_mnu" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FINR001S" //"FINR001R"
Private cString := ""
Private nLin		 := 80

Pergunte( cPerg ,.T. )
	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Montagem do cabeçalho de acordo com a data de execução do relatório + 6 meses
titulo         := "RELATORIO DE COMISSAO DE REPRESENTANTE"

//
//CABECs :
/*
CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	  %	VALOR	VALOR	TOTAL A
TÍTULO	CLIENTE			EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER

CLIENTE: PRIVADO										
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	VALOR	TOTAL A
TÍTULO	CLIENTE			EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER

*/



Cabec1         := ""
Cabec2		   := ""

//If Select( 'SX2' ) == 0

	//RunReport(Cabec1,Cabec2,Titulo,nLin)	/////USAR VIA SCHEDULE
//Else
	///////fim da montagem do cabeçalho
	/////PARA SCHEDULE, COMENTAR O BLOCO ABAIXO
	/////INICIO DO BLOCO
	
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
	
	//////FIM DO BLOCO
	
//Endif

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
Local cCliente:= ""
Local cLoja   := ""
Local cNomeCli:= ""
Local nPrazo  := 0
Local nValTit := 0
Local nPorcomis:= 0
Local nValcomis:= 0
Local nValbonus:= 0
Local nTotRec  := 0
Local nTotTit  := 0
Local nTotTitIPI  := 0
Local nTotcomis:= 0
Local nTotbonus:= 0
Local nTotRecGer:= 0
Local nTotSeg  := 0		//total geral do segmento
Local nVALBRUT := 0

Local acomis   := {}
Local acomis2  := {}
Local nPorcbonus:= 0
Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cSegmento := ""
Local cNomeSeg  := ""
Local cNomeModal:= ""
Local cNomeSegAnt:= ""
Local cDemonstrativo := ""
Local cSegAnt	:= ""

Local dEmissao := Ctod("  /  /    ")
Local dBaixa   := Ctod("  /  /    ")
Local dPagto   := Ctod("  /  /    ")
 
Local aUsua  := {}
Local cNomeuser := ""
Local cMailDestino := ""
Local cCodUser	:= ""
Local nLinhas	:= 80 
Local cWeb		:= "" 
Local nPag		:= 1
Local lEnviou	:= .F. 
Local cBonus	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10) 
 
Local PAR01 := 2		//PELA BAIXA

Private nMesIni
Private PAR02 := Ctod("  /  /    ")
Private PAR03 := Ctod("  /  /    ") 


PAR02 := MV_PAR03
PAR03 := MV_PAR04


cCodUser := __CUSERID


PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailDestino := Alltrim(aUsua[1][14])
Endif

/*
MV_PAR01 - Do vendedor
MV_PAR02 - Ate vendedor
MV_PAR03 - Data de
MV_PAR04 - Data até
MV_PAR05 - Coordenador ?
MV_PAR06 - Considera quais: A pagar / Pagas / Ambas
MV_PAR07 - Salta página por vendedor? Sim / Nao
MV_PAR08 - Comissões Zeradas? Sim / Nao

*/

titulo         := "RELATORIO DE COMISSAO DE REPRESENTANTE - Periodo de: " + Dtoc(PAR02) + " a " + Dtoc(PAR03)

//////////seleciona os dados
cQuery := " SELECT " + LF

cQuery += " E3_BONUS,E3_NUM, E3_SERIE, E3_COMIS , E3_PORC, E3_BASE " + LF
cQuery += " ,CASE WHEN A1_SATIV1 <> '000009' THEN '000010' ELSE A1_SATIV1 END A1_SATIV1  " + LF
cQuery += " ,A1_NREDUZ, A1_NOME  " + LF
cQuery += " ,E3_VEND, F2_DOC, F2_SERIE, F2_EMISSAO,F2_VALMERC, F2_LOCALIZ, F2_EST, E3_COMIS " + LF
cQuery += " ,E3_CODCLI,E3_LOJA, E3_PORC, E3_BAIEMI  " + LF
cQuery += " ,A3_COD, A3_NREDUZ, A3_EMAIL  " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SE3.E3_VEND AND ( A3_SUPER <> '' OR A3_GEREN = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " , E3_EMISSAO, E3_DATA, E3_PREFIXO, E3_PARCELA " + LF
cQuery += " , E1_NUM, E1_PREFIXO, E1_PARCELA, E1_EMISSAO, E1_BAIXA, E1_PEDIDO, E1_VALOR " + LF

cQuery += " FROM " + RetSqlName("SA1") + " SA1  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SE3") + " SE3 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SE1") + " SE1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "+LF
cQuery += " WHERE " + LF

cQuery += " E3_EMISSAO >= '" + DTOS(par02) + "'  AND E3_EMISSAO <=  '" + DTOS(par03) + "' "+LF 
cQuery += " AND E1_TIPO = 'NF' " + LF
	
//If par01 == 1
//	cQuery += " AND E3_BAIEMI <> 'B'"  + LF // Baseado pela emissao da NF
//Elseif par01 == 2
//	cQuery += " AND E3_BAIEMI = 'B'"  + LF // Baseado pela baixa do titulo
//Endif

//If mv_par06 = 1 		// Comissoes a pagar
//	cQuery += " AND E3_DATA = '' " + LF
//ElseIf mv_par06 = 2 // Comissoes pagas
//	cQuery += " AND E3_DATA <> '' " + LF
//Endif

If mv_par07 = 1
	cQuery += " AND E3_COMIS <> 0 " + LF
Endif

cQuery += " AND E3_VEND >= '" + Alltrim(MV_PAR01) +"' " + " and E3_VEND <= '" + alltrim(MV_PAR02) + "' " + LF

If !Empty(MV_PAR05)
	cQuery += " AND A3_SUPER = '" + Alltrim(mv_par05) + "' " + LF
Endif


cQuery += " AND E3_NUM = F2_DOC "+LF 
cQuery += " AND E1_NUM = F2_DOC "+LF
cQuery += " AND E3_NUM = E1_NUM "+LF

cQuery += " AND E3_SERIE = F2_SERIE  "+LF
cQuery += " AND E1_PREFIXO = F2_SERIE  "+LF
cQuery += " AND E3_SERIE = E1_PREFIXO "+LF

cQuery += " AND E3_PARCELA = E1_PARCELA "+LF

 
cQuery += " AND E3_CODCLI = A1_COD  "+LF
cQuery += " AND F2_CLIENTE = A1_COD  "+LF
cQuery += " AND E1_CLIENTE = A1_COD "+LF
cQuery += " AND E3_CODCLI = E1_CLIENTE "+LF
cQuery += " AND E1_CLIENTE = F2_CLIENTE "+LF

cQuery += " AND E3_LOJA = A1_LOJA  "+LF
cQuery += " AND F2_LOJA = A1_LOJA "+LF
cQuery += " AND E1_LOJA = A1_LOJA "+LF
cQuery += " AND E3_LOJA = E1_LOJA "+LF
cQuery += " AND E1_LOJA = F2_LOJA "+LF

cQuery += " AND E3_VEND = A3_COD  "+LF
//cQuery += " AND E1_VEND1 = A3_COD "+LF
//cQuery += " AND F2_VEND1 = A3_COD "+LF
//cQuery += " AND E3_VEND = F2_VEND1 "+LF
//cQuery += " AND E3_VEND = E1_VEND1 "+LF

//cQuery += " AND RTRIM(A3_ATIVO) <> 'N' " + LF 
//cQuery += " AND E3_ORIGEM <> 'R' " + LF    

///teste
//cQuery += " AND RTRIM(A3_COD) = '0151' " + LF

cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SE3.E3_FILIAL = '" + xFilial("SE3") + "' AND SE3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' AND SE1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " +LF

//cQuery += " GROUP BY " + LF 
//cQuery += " A1_SATIV1, A1_NREDUZ, A1_NOME  " + LF
//cQuery += " , E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_SERIE, F2_DOC, F2_SERIE, F2_EMISSAO,F2_VALMERC, F2_LOCALIZ, F2_EST, E3_BASE, E3_COMIS " + LF
//cQuery += " , E3_CODCLI,E3_LOJA, E3_PORC, E3_BAIEMI,E3_BONUS  " + LF
//cQuery += " ,A3_COD, A3_NREDUZ, A3_EMAIL  " + LF
//cQuery += " , E1_NUM, E1_PREFIXO, E1_PARCELA, E1_BAIXA, E1_PEDIDO " + LF

cQuery += " ORDER BY E3_VEND, A1_SATIV1, E3_NUM, E3_PARCELA, E3_BONUS   " + LF
//MemoWrite("C:\Temp\FINR001_MNU.sql", cQuery )

If Select("SE3X") > 0
	DbSelectArea("SE3X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE3X"

TCSetField( "SE3X", "E3_EMISSAO", "D")
TCSetField( "SE3X", "E3_DATA", "D")   
TCSetField( "SE3X", "E1_EMISSAO", "D")
TCSetField( "SE3X", "E1_BAIXA", "D") 
//TCSetField( "SE3X", "E1_VENCTO", "D")
TCSetField( "SE3X", "F2_EMISSAO", "D")



SE3X->( DbGoTop() )


//SetRegua(0)
/*
CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	     VALOR  	VALOR	TOTAL A
TÍTULO	CLIENTE		                	EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER

CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	                  VALOR  	        TOTAL A
TÍTULO	CLIENTE		                	EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	          COMISSÃO	        RECEBER
*/

While SE3X->( !EOF() )		

	cVendedor:= SE3X->E3_VEND
	cSegmento:= SE3X->A1_SATIV1
			
	cMailVend:= SE3X->A3_EMAIL
	cNomeVend:= SE3X->A3_NREDUZ
	
	cCliente:= SE3X->E3_CODCLI
	cLoja   := SE3X->E3_LOJA
	cNomeCli:= SE3X->A1_NREDUZ
	
	cTitulo := SE3X->E3_NUM
	cSerie  := SE3X->E3_SERIE

	If SE3X->E3_BONUS = "S" 		///SEPARA O REGISTRO DE BÔNUS
		cParcela:= SE3X->E3_PARCELA + "B"
	Else
		cParcela:= SE3X->E3_PARCELA
	Endif
		
	dEmissao:= SE3X->E1_EMISSAO 
	cLocaliz:= SE3X->F2_LOCALIZ
	dPagto	:= SE3X->E1_BAIXA
	dPagComis := SE3X->E3_DATA
	cBonus	:= ""
			
	nPrazoRec := 0
	nValbonus  := 0
	nPorcbonus := 0
	nPorcomis  := 0
	nValcomis  := 0
	nValTit	   := 0
	nValMerc   := 0
	nDias	   := 0		//irá armazenar a soma dos dias vencidos do título + prazo mínimo de entrega (transp.)
	cPedido := ""
	nVALBRUT   := SE3X->E1_VALOR
	
	nPrazoRec  := iif( !Empty(dPagto), (dPagto - dEmissao) , 0 )	//calcula o prazo de recebimento do título (da emissão até a baixa) 	

	cPedido := SE3X->E1_PEDIDO
	nPrazoEnt := U_fPrazoMin( SE3X->F2_EST )
	cModal    := U_GetModali(cPedido)
	
	//nPorcomis := SE3X->E3_PORC
	//nValcomis := SE3X->E3_COMIS
	

	nValTit := SE3X->E3_BASE
	nValMerc:= SE3X->F2_VALMERC
	
	If SE3X->E3_BONUS = "S" 		///SEPARA O REGISTRO DE BÔNUS
 		nValbonus := SE3X->E3_COMIS
 		nPorcbonus:= SE3X->E3_PORC
		nPorcomis := SE3X->E3_PORC
		nValcomis := SE3X->E3_COMIS
 		cBonus	  := SE3X->E3_BONUS			 	
	Else
		nPorcomis := SE3X->E3_PORC
		nValcomis := SE3X->E3_COMIS
	Endif
	
	nTotrec:= nValcomis//( nValcomis + nValbonus)		

	
			Aadd(acomis2, { cTitulo,;			//1
					 cCliente,;        	//2
					 cLoja,;           	//3
					 cNomeCli,;        	//4
					 dEmissao,;       	//5
					 dPagto,;          	//6
					 nPrazoRec,;       	//7	
					 nValTit,;         	//8
					 nPorcomis,;       	//9
					 nValcomis,;       	//10
					 nValbonus,;       	//11
					 nTotrec,;         	//12
					 cVendedor,;       	//13
					 cSegmento,; 		//14
					 cNomeVend,;  		//15		
					 nPorcBonus,;		//16
					 cMailVend,;		//17					 
					 nPrazoEnt,;		//18
					 cModal,;			//19
					 nValMerc,; 		//20
					 cParcela,; 		//21 
					 dPagComis,;		//22
					 cBonus,; 			//23
					 nVALBRUT	} ) //24
			SE3X->(Dbskip())
											 	

Enddo

acomis := Asort( acomis2,,, { |X,Y| X[13] + X[14] + X[1] + X[21]  <  Y[13] + Y[14] + Y[1] + Y[21]  } ) 

SE3X->( DbCloseArea() ) 

cWeb	 	:= ""
nTotrec		:= 0
nValcomis	:= 0
nValbonus	:= 0
nPorcomis	:= 0 
nCta := 1
cSegmento	:= ""



nPag := 1   
nLinhas := 80
cWeb	:= ""
cSegAnt := ""


///cabec : público
cCabec2 := "NÚMERO"     + Space(9) +"CÓDIGO DO"  +Space(5)+"NOME DO CLIENTE"+Space(7)+"DATA"+Space(8)+   "DATA"      +Space(6)+ "PRAZO" + Space(7)+ "VALOR" + Space(8) +  "VALOR" + Space(7) + "%"       + "  "               + "%"     + Space(10) + "VALOR"   +Space(13) +"VALOR" + Space(5)+ "DT.PAGTO." + Space(8) + "TOTAL A        MODALIDADE"
cCabec3 := "TÍTULO/PARC"+Space(3)+  "CLIENTE/LJ" + Space(27)+                         "EMISSÃO"+Space(2)+"PAGTO.TIT."  +Space(2)+"RECBTO."+ Space(7)+ "BASE"  +Space(3) + "BASE C/IPI" + Space(3) +"COMISSÃO" +Space(3)        +"BÔNUS" +Space(3)   +"COMISSÃO" +Space(10) +"BÔNUS" +Space(6)  +"COMISSÃO"  + Space(8) + "RECEBER"

////cabec: privado
cCabec4 := "NÚMERO"     + Space(9) +"CÓDIGO DO"  +Space(5)+"NOME DO CLIENTE"+Space(7)+"DATA"+Space(8)+   "DATA"      +Space(6)+ "PRAZO" + Space(7)+ "VALOR" + Space(8) +  "VALOR"        + Space(7) + "%"           + " "     + Space(10) + "VALOR"   +Space(14) +"    "  + Space(5)+ "DT.PAGTO." + Space(8) + "TOTAL A"
cCabec5 := "TÍTULO/PARC"+Space(3)+  "CLIENTE/LJ" + Space(27)+                         "EMISSÃO"+Space(2)+"PAGTO.TIT."  +Space(2)+"RECBTO."+ Space(7)+ "BASE"  +Space(3) + "BASE C/IPI"  + Space(3) + "COMISSÃO"      +"     "  +Space(3)   +"COMISSÃO" +Space(10) +"     " +Space(6)  +"COMISSÃO"  + Space(8) + "RECEBER"
                		
If Len(acomis) > 0 
	
	//For nCta := 1 to Len(acomis)
	Do while nCta <= Len(acomis)
	
		nTotSeg	  := 0
		//nTotRecGer:= 0
		nTotcomis := 0
		nTotRec	  := 0
		nTotbonus := 0
		nTotTit	  := 0
		nTotTitIPI	  := 0
		
		cVendedor := acomis[nCta,13]
		cMailVend := acomis[nCta,17]
		cNomeVend := acomis[nCta,15]
	
		cSegmento := acomis[nCta,14]
		cNomeSeg  := ""
		
		SX5->(Dbsetorder(1))
		If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
			If Alltrim(cSegmento) != '000009'
				cNomeSeg := "PRIVADO"
				cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO PARA CLIENTE PRIVADO"
			Else
				cNomeSeg := Alltrim(SX5->X5_DESCRI)
				cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO E BÔNUS PARA LICITAÇÃO"				
			Endif
		Endif
		cCabec1 := "CLIENTE: " + cNomeSeg + cDemonstrativo
	    
	  	If mv_par06 = 1
			nLin := 80
		Endif
		//msgbox(str(mv_par07) )
			
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8			
			
	    Endif ///novo
	   		@ nLin,000 PSay cCabec1
			nLin++	
			@nLin,000 PSAY Alltrim(cVendedor) + " - " + Alltrim(cNomeVend) 
			nLin++
			@nLin,000 PSAY "E-mail: " + Alltrim(cMailVend) 
			nLin++
				
			@ nLin,000 PSay Repli( '_', 200)		
			nLin++
			nLin++
			If cSegmento = '000009'
				@ nLin,000 PSay cCabec2
				nLin++
				@ nLin,000 PSay cCabec3
				nLin++
			Else
				@ nLin,000 PSay cCabec4
				nLin++
				@ nLin,000 PSay cCabec5
				nLin++
			Endif
			@ nLin,000 PSay Repli( '_', 200)					
			nLin++			
			
		//Endif				
				
		Do while nCta <= Len(acomis) .and. Alltrim(acomis[nCta,13]) = Alltrim(cVendedor) 
			
			cSegmento := acomis[nCta,14]
			cNomeSeg  := ""
			cNomeModal := ""
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8			
				@ nLin,000 PSay cCabec1
				nLin++
				@nLin,000 PSAY Alltrim(cVendedor) + " - " + Alltrim(cNomeVend) 
				nLin++
			Endif
			
			SX5->(Dbsetorder(1))
			If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
				If Alltrim(cSegmento) != '000009'
					cNomeSeg := "PRIVADO"
					cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO PARA CLIENTE PRIVADO"
				Else
					cNomeSeg := Alltrim(SX5->X5_DESCRI)
					cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO E BÔNUS PARA LICITAÇÃO"				
				Endif
			Endif
			cCabec1 := "CLIENTE: " + cNomeSeg + cDemonstrativo
			
			If nCta > 1
			  If Alltrim(acomis[nCta - 1,13]) = Alltrim(acomis[nCta,13])
			  	If Alltrim(acomis[nCta - 1,14]) != Alltrim(acomis[nCta,14])
				
					If SX5->(Dbseek(xFilial("SX5") + 'T3' + acomis[nCta - 1,14] ))
						If Alltrim(acomis[nCta - 1,14]) != '000009'
							cNomeSegAnt := "PRIVADO"
							cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO PARA CLIENTE PRIVADO"
						Else
							cNomeSegAnt := Alltrim(SX5->X5_DESCRI)
							cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO E BÔNUS PARA LICITAÇÃO"				
						Endif
					Endif
					
					nLin++
					@nLin,000 PSay Repli( '-', 200)
					nLin++
					@nLin,000 PSAY "Total Geral CLIENTE: " + cNomeSegAnt + " -> "
					@nLin,080 PSAY Transform(nTotTit, "@E 99,999,999.99")
					@nLin,096 PSAY Transform(nTotTitIPI, "@E 99,999,999.99")
					@nLin,114 PSAY Transform(nTotcomis, "@E 99,999,999.99")
					If nTotbonus > 0
						//@nLin,130 PSAY Transform(nTotbonus, "@E 99,999,999.99")
					Endif
					@nLin,156 PSAY Transform(nTotRec, "@E 99,999,999.99")
					//@nLin,076 PSAY Transform(nTotSeg, "@E 99,999,999.99")
					nLin++
					@nLin,000 PSay Repli( '=', 200)
					nLin++
					nLin++
					nLin++
				
					nTotSeg   := 0		///zera o total do segmento
					nTotRec		:= 0
					nTotTit		:= 0
					nTotTitIPI		:= 0 
					nTotcomis	:= 0
					nTotbonus	:= 0
					
					SX5->(Dbsetorder(1))
					If SX5->(Dbseek(xFilial("SX5") + 'T3' + acomis[nCta,14] ))
						If Alltrim(acomis[nCta,14]) = '000009'
							cNomeSeg := Alltrim(SX5->X5_DESCRI)
							cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO E BÔNUS PARA LICITAÇÃO"
						Else
							cNomeSeg := "PRIVADO"
							cDemonstrativo := "  - DEMONSTRATIVO DE COMISSÃO PARA CLIENTE PRIVADO"
						Endif
					Endif
					cCabec1 := "CLIENTE: " + cNomeSeg + cDemonstrativo	
							
					///faz cabeçalho do novo segmento...
					@ nLin,000 PSay cCabec1
					nLin++
					@ nLin,000 PSay Repli( '_', 200)		
					nLin++
					If cSegmento = '000009' 
						nLin++
						@ nLin,000 PSay cCabec2
						nLin++
						@ nLin,000 PSay cCabec3
						nLin++
					Else
						nLin++
						@ nLin,000 PSay cCabec4
						nLin++
						@ nLin,000 PSay cCabec5
						nLin++
					Endif
					@ nLin,000 PSay Repli( '_', 200)					
					nLin++
					
					
			  	Endif
			  Endif
			Endif
			
					
				
				////impressão dos dados....		
				//If cSegmento = '000009'		
				If Alltrim(acomis[nCta,14]) = '000009'
					@nLin,000 PSAY Alltrim(acomis[nCta,1]) + "/" + Alltrim(acomis[nCta,21])	PICTURE "@!"     	///titulo/parcela
					@nLin,015 PSAY acomis[nCta,2] + "/" + acomis[nCta,3]		//cod.cliente/loja
					@nLin,027 PSAY Alltrim(Substr(acomis[nCta,4],1,20))		PICTURE "@!"     //nome cliente
					@nLin,050 PSAY Dtoc(acomis[nCta,5]) 	PICTURE "@D 99/99/99"			//dt.emissão
					@nLin,062 PSAY Dtoc(acomis[nCta,6]) 	PICTURE "@D 99/99/99"			//dt.pagto título
					@nLin,073 PSAY acomis[nCta,7] 	PICTURE "@E 9999"						//prazo recbto.
					@nLin,080 PSAY acomis[nCta,8] 	PICTURE "@E 99,999,999.99"    			//val.título
					@nLin,094 PSAY acomis[nCta,24] 	PICTURE "@E 99,999,999.99"    			//val.título c/ IPI
					
					If Alltrim(acomis[nCta,23]) = "S" 
						
						@nLin,110 PSAY acomis[nCta,16] 	PICTURE "@E 99.99"    					//% bonus
						@nLin,130 PSAY acomis[nCta,11] 	PICTURE "@E 99,999,999.99"    			//val.bônus
					Else
						@nLin,096 PSAY acomis[nCta,9] 	PICTURE "@E 99.99"    					//% comissão										
						@nLin,114 PSAY acomis[nCta,10] 	PICTURE "@E 99,999,999.99"    			//val.comissão
					Endif
					
					@nLin,146 PSAY Dtoc(acomis[nCta,22]) 	PICTURE "@D 99/99/99"			//dt.pagto comissão
					@nLin,156 PSAY acomis[nCta,12] 	PICTURE "@E 99,999,999.99"  			//total receber
					
					cNomeModal := U_fNomeModal(acomis[nCta,19])
					
					@nLin,175 PSAY acomis[nCta,19] + '-' + cNomeModal Picture "@!" //modalidade
			
				Else
					@nLin,000 PSAY Alltrim(acomis[nCta,1]) + "/" + Alltrim(acomis[nCta,21])	PICTURE "@!"     	///titulo/parcela
					@nLin,015 PSAY acomis[nCta,2] + "/" + acomis[nCta,3]		//cod.cliente/loja
					@nLin,027 PSAY Alltrim(Substr(acomis[nCta,4],1,20))		PICTURE "@!"     //nome cliente
					@nLin,050 PSAY Dtoc(acomis[nCta,5]) 	PICTURE "@D 99/99/99"			//dt.emissão
					@nLin,062 PSAY Dtoc(acomis[nCta,6]) 	PICTURE "@D 99/99/99"			//dt.pagto título
					@nLin,073 PSAY acomis[nCta,7] 	PICTURE "@E 9999"						//prazo recbto.
					@nLin,080 PSAY acomis[nCta,8] 	PICTURE "@E 99,999,999.99"    			//val.título
					@nLin,094 PSAY acomis[nCta,24] 	PICTURE "@E 99,999,999.99"    			//val.título c/ IPI
					@nLin,110 PSAY acomis[nCta,9] 	PICTURE "@E 99.99"    					//% comissão
					//@nLin,105 PSAY acomis[nCta,16] 	PICTURE "@E 99.99"    					//% bonus
					@nLin,114 PSAY acomis[nCta,10] 	PICTURE "@E 99,999,999.99"    			//val.comissão
					//@nLin,130 PSAY acomis[nCta,11] 	PICTURE "@E 99,999,999.99"    			//val.bônus
					@nLin,146 PSAY Dtoc(acomis[nCta,22]) 	PICTURE "@D 99/99/99"			//dt.pagto comissão
					@nLin,156 PSAY acomis[nCta,12] 	PICTURE "@E 99,999,999.99"  			//total receber
					//@nLin,156 PSAY acomis[nCta,14] //segmento							
				Endif			
				nLin++
										
				///totais por vendedor
				nTotRec		+= acomis[nCta,12]
				nTotTit		+= acomis[nCta,8]
				nTotTitIPI		+= acomis[nCta,24]
				nTotcomis	+= acomis[nCta,10]
				nTotbonus	+= acomis[nCta,11]
				///total geral (fim do relatório)
				nTotRecGer  += acomis[nCta,12]				
				nTotSeg	+= acomis[nCta,12]		///total geral do segmento			   	
			
			  
				
			nCta++
					
									 
		Enddo
		
				
		
		///se mudou o representante, totaliza o último segmento...
		nLin++
		@nLin,000 PSay Repli( '-', 200)
		nLin++
		@nLin,000 PSAY "Total Geral CLIENTE: " + cNomeSeg + " -> " 
		@nLin,080 PSAY Transform(nTotTit, "@E 99,999,999.99")
		@nLin,094 PSAY Transform(nTotTitIPI, "@E 99,999,999.99")
		@nLin,114 PSAY Transform(nTotcomis, "@E 99,999,999.99")
		If nTotbonus > 0
			//@nLin,130 PSAY Transform(nTotbonus, "@E 99,999,999.99")
		Endif
		@nLin,156 PSAY Transform(nTotRec, "@E 99,999,999.99")
		nLin++
			
		nTotSeg := 0	
		cVendAnt := cVendedor
				
		/////SE MUDOU O REPRESENTANTE, TOTALIZA
		@nLin,00 PSAY Replicate("=",200)
		nLin++
		@nLin,000 PSAY "TOTAL GERAL A RECEBER DO VENDEDOR: " + Alltrim(cNomeVend) + ": "
		//@nLin,076 PSAY TRANSFORM( nTotTit,"@E 99,999,999.99")
		//@nLin,110 PSAY TRANSFORM( nTotcomis,"@E 99,999,999.99")
		If nTotbonus > 0 
			//@nLin,130 PSAY TRANSFORM( nTotbonus,"@E 99,999,999.99")
		Endif
		@nLin,156 PSAY TRANSFORM( nTotRecGer,"@E 99,999,999.99")
		nLin++
		@ nLin,000 PSay Repli( '=', 200)
		nLin++
		
			
		////zera totais
		nTotRec		:= 0
		nTotTit		:= 0
		nTotTitIPI		:= 0 
		nTotcomis	:= 0
		nTotbonus	:= 0
		nTotRecGer  := 0
		
				
	//Next
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
	

Else
	MsgInfo("arquivo vazio!!")
Endif


Return