#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FINR001_SCH - Agendamento para representantes
//Objetivo: RELATÓRIO (Mensal) DE COMISSÃO DE REPRESENTANTE - LINHA MÉDICO HOSPITALAR
// (Contra-cheque)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 18/08/2010
//--------------------------------------------------------------------------
/*/
///GERA EM FORMATO HTML
********************************
User Function FINR001_SCH()
********************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )  
  	f_finr001()	//chama a função do relatório
  	
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )  
  	f_finr001()	//chama a função do relatório
  

  
Else
  lDentroSiga := .T.
  f_finr001()
  
EndIf


Return   

/*
********************************
User Function COMISS_CX()
********************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	f_finr001()	//chama a função do relatório
  
Else
  lDentroSiga := .T.
  f_finr001()
  
EndIf


Return
*/

****************************
Static Function F_FINR001()
****************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Comissao de Representante " //- Linha Médico Hosp."
Local cPict          := "" 
Local titulo		 := ""

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd 			 := {}
Local nOpc 			 := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FINR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FINR001S"
Private cString := ""
Private nLin		 := 80
Private LF		:= CHR(13) + CHR(10) 
Private lEnviou := .F.
Private cEmp	:= "" 
Private lEnvio  := .F.
Private cNaoEnv := ""  //irá gravar os vendedores que não conseguiram ter seu email enviado
SetPrvt("oDlg1","oGrp1","oSay1","oBtnConf","oBtnEnv")


If SM0->M0_CODFIL = '01'
	cEmp := "Sacos"
Elseif SM0->M0_CODFIL = '03' 
	cEmp := "Caixas" 
Else	
	cEmp := SM0->M0_FILIAL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Montagem do cabeçalho
titulo         := "RELATORIO DE COMISSAO DE REPRESENTANTE - " + cEmp

If lDentroSiga

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 243,470,456,955,"Relatório de Comissões",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 008,012,093,228,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 028,050,{||"Por Favor, Escolha o Destino do Relatório a ser Gerado:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
	oBtnConf   := TButton():New( 057,036,"Conferencia",oGrp1,,067,012,,,,.T.,,"",,,,.F. )
	oBtnConf:bAction := {||(nOpc := 1,oDlg1:End()) }
	
	oBtnEnv      := TButton():New( 057,136,"Envio p/ Representante",oGrp1,,067,012,,,,.T.,,"",,,,.F. )
	oBtnEnv:bAction := {||(nOpc := 2,oDlg1:End()) }
	
	
	oDlg1:Activate(,,,.T.)
		
	If nOpc = 1       // só gera para conferir e não envia para o Repre.
		lEnvio := .F.
		Pergunte("FINR001S",.T.) 	
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
	Else
		Pergunte("FINR001S",.T.) 
		lEnvio := .T.	
		MsAguarde( {|| RunReport(Cabec1,Cabec2,Titulo,nLin) }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gerando e Enviando Relatório..." ) )
	Endif
Else
    lEnvio := .T.
	RunReport(Cabec1,Cabec2,Titulo,nLin)
Endif

Return


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
Local cTit := ""
Local cCliente:= ""
Local cLoja   := ""
Local cNomeCli:= ""
Local nPrazoRec := 0
Local nValTit := 0
Local nValMerc:= 0
Local nPorcomis:= 0
Local nValcomis:= 0
Local nValbonus:= 0

Local nTotRec  := 0
Local nTotTit  := 0
Local nTotTiPI := 0
Local nTotcomis:= 0
Local nTotbonus:= 0
Local nTotRecGer:= 0
Local cPedido   := ""

Local acomis   := {}
Local acomis2  := {}
Local nPorcbonus:= 0

Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local dEmissao 	:= Ctod("  /  /    ")
Local dBaixa 	:= Ctod("  /  /    ")
Local dPagto   	:= Ctod("  /  /    ")
Local cParcela	:= ""
Local cModal	:= "" 
Local cNomeModal:= ""
 
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

Local cCabec1 := ""
Local cCabec2 := ""

Local cCabec3 := "" 
Local nConta  := 0

/*
MV_PAR01 : DO VENDEDOR
MV_PAR02 : ATÉ VENDEDOR
MV_PAR03 : DATA DE
MV_PAR04 : DATA ATE
MV_PAR05 : COORDENADOR ? 
(SE NÃO ESTIVER PREENCHIDO, IMPRIME TODOS OS VENDEDORES ESPECIFICADOS NOS PARÂMETROS MV_PAR01 E MV_PAR02
MV_PAR06 : 1-A PAGAR / 2-PAGAS / 3-AMBAS

*/

Local cQuery	:=''



Local PAR01 := 2		//PELA BAIXA  
Local cBonus:= ""
Local nTam:= 0
Local nConta := 1 
Local nPos   := 0 
Local nVALBRUT := 0
Local aAnexos	:= {}

Private nMesIni
Private PAR02 := Ctod("  /  /    ")
Private PAR03 := Ctod("  /  /    ") 
Private PAR06 
Private PAR07
Private cMailSuper := "" 
Private cSuper     := ""    
Private env		   := 0 
Private cExcecoes1  := MV_PAR08
Private cExcecoes2  := MV_PAR09
Private cExcecoes3  := MV_PAR10
Private cExcTot     := ""
Private cExc        := ""


If lDentroSiga
	//nMesIni := Val(mv_par03) //Month(dDatabase) - 1    //mês anterior
	PAR02 := MV_PAR03
	PAR03 := MV_PAR04
Else
	nMesIni := Month(dDatabase)
	//DIA 15 DO MÊS ANTERIOR ATÉ O DIA 14 DO MÊS ATUAL
	If nMesIni = 1
		PAR02 := Ctod( '15/' + Strzero( (nMesIni + 11) ,2) + '/' + Right(StrZero(Year(dDATABASE) - 1,4),2)   ) 
		PAR03 := Ctod( '14/' + Strzero(nMesIni,2) + '/' + Right(StrZero(Year(dDATABASE) ,4),2) )
	
	Else 
		PAR02 := Ctod( '15/' + Strzero( (nMesIni - 1) ,2) + '/' + Right(StrZero(Year(dDATABASE),4),2)   ) 
		PAR03 := Ctod( '14/' + Strzero(nMesIni,2) + '/' + Right(StrZero(Year(dDATABASE),4),2) )
	
	Endif
	
Endif

//EXTRAI AS EXCEÇÕES
If !Empty(cExcecoes1)
	cExcTot += Alltrim(cExcecoes1)
Endif

If !Empty(cExcecoes2)
	cExcTot += Alltrim(cExcecoes2)
Endif

If !Empty(cExcecoes3)
	cExcTot += Alltrim(cExcecoes3)
Endif

nTam := Len(cExcTot)
While nConta <= Len( cExcTot )

	 If AT( "," , Substr( cExcTot, nConta, 6 ) ) > 0
	 	nPos := Len( Substr( cExcTot, nConta, AT(",",cExcTot) ))	 
	 	If Empty( cExc )
	 		cExc := "'" + Substr( cExcTot , nConta, nPos - 1) + "'"
	 	Else
	 		cExc += "," + "'" + Substr( cExcTot , nConta, nPos - 1) + "'"
	 	Endif
     	
	 Else
	 	nPos :=Len( Substr( cExcTot, nConta, AT(",",cExcTot) ))
	 	cExc += "," + "'" + Substr( cExcTot , nConta, nPos ) + "'"
	 Endif
	 nConta += nPos
Enddo

//para testes
//FR - QDO FOR CHAMAR PELO REMOTE DIRETO, HABILITA ESTAS LINHAS PARA DEFINIR O PERÍODO
//PAR02 := Ctod( '15/10/2012'  )  //para CHAMAR DE FORA DO SIGA
//PAR03 := Ctod( '14/11/2012'  )  //para CHAMAR DE FORA DO SIGA
//FR


PAR06 := 1 	//- Considera quais: A pagar / Pagas / Ambas
PAR07 := 1 	//MV_PAR09 - Comissões zeradas : Sim / Nao

//Montagem do cabeçalho
cTit         := "RELATORIO DE COMISSAO DE REPRESENTANTE - " + cEmp + " - Periodo de: " + Dtoc(PAR02) + " a " + Dtoc(PAR03)

//////////seleciona os dados
cQuery := " SELECT " + LF

cQuery += " E3_BONUS,E3_NUM, E3_SERIE, E3_COMIS , E3_PORC, E3_BASE " + LF
cQuery += " ,CASE WHEN A1_SATIV1 <> '000009' THEN '000010' ELSE A1_SATIV1 END A1_SATIV1  " + LF
cQuery += " ,A1_NREDUZ, A1_NOME  " + LF
cQuery += " ,E3_VEND, F2_DOC, F2_SERIE, F2_EMISSAO,F2_VALMERC,F2_VALBRUT, F2_LOCALIZ, F2_EST, E3_COMIS " + LF
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

If lDentroSiga
	/*
	If mv_par06 = 1 				// Comissoes a pagar
		cQuery += " AND E3_DATA = '' " + LF
	
	ElseIF mv_par06 = 2 			// Comissoes pagas
		cQuery += " AND E3_DATA <> '' " + LF
	Endif
	*/
	// Nao Inclui Comissoes Zeradas
	If mv_par07 = 1 //mv_par08 = 1
	   cQuery += " And E3_COMIS <> 0 " + LF
	Endif

Endif

If lDentroSiga
	//cQuery += " AND RTRIM(E3_VEND) >= '" + Alltrim(mv_par01) + "' AND RTRIM(E3_VEND) <= '" + Alltrim(mv_par02) + "' "+LF 
	If Empty(cExc)       //se exceções estiver vazio, captura do de/até
		cQuery += " AND E3_VEND >= '" + Alltrim(MV_PAR01) +"' " + " and E3_VEND <= '" + alltrim(MV_PAR02) + "' " + LF
	Else
		///diferentes de:
		cQuery += " AND A3_COD NOT IN ( " + Alltrim(cExc) + " ) " + LF     //PARA TESTES
	Endif
	If !lEnvio
		If !Empty(MV_PAR05)
			cQuery += " AND A3_SUPER = '" + Alltrim(mv_par05) + "' " + LF
		Endif 
	Endif
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
////não ativar este bloco
//cQuery += " AND E1_VEND1 = A3_COD "+LF
//cQuery += " AND F2_VEND1 = A3_COD "+LF
//cQuery += " AND E3_VEND = F2_VEND1 "+LF
//cQuery += " AND E3_VEND = E1_VEND1 "+LF

//cQuery += " AND RTRIM(A3_ATIVO) <> 'N' " + LF     
//cQuery += " AND E3_ORIGEM <> 'R' " + LF
///////////fim do bloco

///FR:
///QDO DEISE INFORMAR QUE NÃO FOI ENVIADO PARA UM OU MAIS CÓDIGOS ESPECÍFICOS
//cQuery += " AND A3_COD = '2329' " + LF     //UM ESPECÍFICO
//cQuery += " AND A3_COD >= '0195' " + LF     //UM INTERVALO

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
MemoWrite("C:\Temp\FINR001_SCH.sql", cQuery )

If Select("SE3X") > 0
	DbSelectArea("SE3X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE3X"

TCSetField( "SE3X", "E3_EMISSAO", "D")
TCSetField( "SE3X", "E1_BAIXA", "D")
TCSetField( "SE3X", "E3_DATA", "D")   
TCSetField( "SE3X", "F2_EMISSAO", "D")
TCSetField( "SE3X", "E1_EMISSAO", "D")

SE3X->( DbGoTop() )

/*
CLIENTE: ORGÃO PÚBLICO												
NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	     VALOR  	VALOR	TOTAL A
TÍTULO	CLIENTE		                	EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER
*/

While SE3X->( !EOF() )		

	cVendedor:= SE3X->E3_VEND
	cSegmento:= SE3X->A1_SATIV1
			
	cMailVend:= SE3X->A3_EMAIL
	cNomeVend:= SE3X->A3_NREDUZ 
	
	cSuper := SE3X->SUPER
	cMailSuper := ""
	
	cCliente:= SE3X->E3_CODCLI
	cLoja   := SE3X->E3_LOJA
	cNomeCli:= SE3X->A1_NREDUZ
	
	cTitulo := SE3X->E3_NUM
	cSerie  := SE3X->E3_SERIE
	cParcela:= SE3X->E3_PARCELA
	
	If SE3X->E3_BONUS = "S" 
		cParcela:= SE3X->E3_PARCELA + " B*"
	EndIf
	
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
 		cBonus	  := SE3X->E3_BONUS			 	
		nPorcomis := SE3X->E3_PORC
		nValcomis := SE3X->E3_COMIS
	Else
		nPorcomis := SE3X->E3_PORC
		nValcomis := SE3X->E3_COMIS
	Endif
	
	nTotrec:= nValcomis//( nValcomis + nValbonus)		
    
	SA3->(Dbsetorder(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cMailSuper := SA3->A3_EMAIL
	Endif
	
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
					 cBonus,;	 		//23
					 cMailSuper,;       //24
					 cSuper,;  			//25
					 nVALBRUT, ;		//26
					 cSerie ;			//27
					 } )
					 
			SE3X->(Dbskip())
											 	

Enddo

acomis := Asort( acomis2,,, { |X,Y| X[13] + X[14] + X[1] + X[21]  <  Y[13] + Y[14] + Y[1] + Y[21]  } ) 

DbSelectArea("SE3X")
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
cNomeVend	:= ""
cSegmento	:= ""
cDirHTM		:= ""
cArqHTM		:= "" 
nPag		:= 1
If !lEnvio // lDentroSiga

	If Len(acomis) > 0
		
		////CRIA O ARQUIVO DO HTML
		cDirHTM  := "\Temp\"    //"D:\temp\"
		cArqHTM  := "comissoes.HTM"   
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
	    cWeb := ""            		
		Do while nCta <= Len(acomis)
		
				
				cVendedor := acomis[nCta,13]
				cNomeVend := Alltrim(acomis[nCta,15]) 
				cMailVend := Alltrim(acomis[nCta,17])
				cMailSuper:= Alltrim(acomis[nCta,24])
				cSuper	  := Alltrim(acomis[nCta,25])
				
				cSegmento := acomis[nCta,14]
				cNomeSeg  := ""
				DbselectArea("SX5")
				SX5->(Dbsetorder(1))
				If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
					If Alltrim(cSegmento) = '000009'
						cNomeSeg := Alltrim(SX5->X5_DESCRI)
						cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS P/ RECBTO. DE TITULOS PUBLICOS " //PARA LICITACAO"
					Else
						cNomeSeg := "PRIVADO"
						cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
					Endif
				Endif
				
				If lDentroSiga
					If mv_par07 = 1			
						nLinhas := 80
					Endif
				Endif
				
				//nPag	:= 1
				
				//cWeb := ""
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
			//Endif	
			
				
			If nLinhas >= 35        ////qdo novo representante sempre irá fazer um cabeçalho
			
					cWeb += f_Cabeca(nPag,par02,cTit) 
					nPag++						
					nLinhas := 5
			
			Endif			    
			
						
			  	cWeb += '<table width="1000" border="0" style="font-size:11px;font-family:Arial">'+LF				
							
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,13]) + " - " + Alltrim(acomis[nCta,15]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,17]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++
				
				////linha em branco
				//cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				//nLinhas++			
				////linha em branco
				//cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				//nLinhas++
				////linha em branco
				//cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				//nLinhas++ 
				
				////linha em branco
				cWeb += '<tr>'+LF
				cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
				cWeb += '</tr>'+LF  
				nLinhas++
						
				cWeb += '<td width="700"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg+ cDemonstrativo +'</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++			
				
				////linha em branco
				cWeb += '<tr>'+LF
				cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
				cWeb += '</tr>'+LF  
				nLinhas++		
									
				cWeb += '</table>' + LF
				nLinhas++
							
			    If cSegmento = '000009'
				    //NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	    VALOR	   VALOR	TOTAL A
					//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER						
					///Cabeçalho relatório		      
					cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="700"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
					cWeb += '<td width="350"><div align="center"><span class="style3"><B>TIPO</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>PRZ.ENTREG</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE </span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI </span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
				Else
					//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
					//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
					///Cabeçalho relatório		      
					cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="700"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI </span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF			
				Endif
				cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
					
				nLinhas++
				nLinhas++		   
				//nPag++
				
			//Endif
	
				Do while nCta <= Len(acomis) .and. Alltrim(acomis[nCta,13]) = Alltrim(cVendedor) 						
												
					If nCta > 1
					  If Alltrim(acomis[nCta - 1,13]) = Alltrim(acomis[nCta,13])	 ///mudou o vendedor
					 	If Alltrim(acomis[nCta -1 ,14]) != Alltrim(acomis[nCta,14])  ///mudou o segmento
					
							cNomeSegAnt  := ""
							SX5->(Dbsetorder(1))
							If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegAnt ))						
								If Alltrim(cSegAnt) = '000009'
									cNomeSegAnt := Alltrim(SX5->X5_DESCRI)
								Else
									cNomeSegAnt := "PRIVADO"
								Endif
							Endif
											
							If Alltrim(cSegmento) = '000009'
							
															
								/////TOTALIZA REPRESENTANTE
								cWeb += '<td width="700"><span class="style3"><b>TOTAL GERAL CLIENTE -> '+ cNomeSegAnt + '</span></b></td>' +LF
								cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //MODALIDADE
								cWeb += '<td width="350"><div align="center"><span class="style3"></span></div></B></td>'+ LF //TIPO COMISSÃO/BÔNUS
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
								cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto 
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo ENTREGA
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF  //val.título
								//valor título c/ IPI
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF  
								
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
								cWeb += '<td width="200"><div align="center"><span class="style3"><b></span></div></b></td>'+LF
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
							Else
								/////TOTALIZA REPRESENTANTE
								cWeb += '<td width="700"><span class="style3"><b>TOTAL GERAL CLIENTE -> ' + cNomeSegAnt + '</span></b></td>' +LF
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
								cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
								//valor título c/ IPI
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF  
								
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
								cWeb += '<td width="200"><div align="center"><span class="style3"><b></span></div></b></td>'+LF
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
							
							Endif		
							cWeb += '</strong></tr>'+LF
							cWeb += '</table>' + LF
							nLinhas++
							cWeb += '<br>'+LF
							cWeb += '<br>'+LF
							//cWeb += '<br>'+LF
							nLinhas++
							nLinhas++
							nLinhas++
					 					  			
							////zera totais
							nTotRec		:= 0
							nTotTit		:= 0 
							nTotcomis	:= 0
							nTotbonus	:= 0
						    
							If nLinhas >= 35
								If nCta > 1
									cWeb += '<div class="quebra_pagina"></div>'+LF
									//nLinhas := 1
									
									cWeb += f_Cabeca(nPag,par02,cTit) 
									nPag++						
									nLinhas := 5
									
									If mv_par07 = 2
										cWeb += '<table width="1000" border="0" style="font-size:11px;font-family:Arial">'+LF
										cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Continuacao >></strong></span></div></td>'+LF
										cWeb += '</tr>'+LF							
										cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,13]) + " - " + Alltrim(acomis[nCta,15]) + '</strong></span></div></td>'+LF
										cWeb += '</tr>'+LF
										cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,17]) + '</span></div></td>'+LF
										cWeb += '</tr>'+LF
										nLinhas++
										nLinhas++
									Endif
							   
								Endif
							Endif
							
							
							cSegmento := acomis[nCta,14]
							cNomeSeg  := ""
							SX5->(Dbsetorder(1))
							If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
								If Alltrim(cSegmento) = '000009'
									cNomeSeg := Alltrim(SX5->X5_DESCRI)
									cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS P/ RECBTO. DE TITULOS PUBLICOS" // LICITAÇAO"
								Else
									cNomeSeg := "PRIVADO"
									cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
								Endif
							Endif
							
							cWeb += '<table width="1000" border="0" style="font-size:11px;font-family:Arial">'+LF				
							cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg+ cDemonstrativo +'</strong></span></div></td>'+LF
							cWeb += '</tr>'+LF
							nLinhas++
									
							////linha em branco
							cWeb += '<tr>'+LF
							cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
							cWeb += '</tr>'+LF  
							nLinhas++
																	
							cWeb += '</table>' + LF
							nLinhas++
							
							If Alltrim(cSegmento) = '000009'			
							    //NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	    VALOR	   VALOR	TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="700"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
								cWeb += '<td width="350"><div align="center"><span class="style3"><B>TIPO</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>PRZ.ENTREG</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI </span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
							Else
														
								//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="700"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF        
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI </span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF			
							Endif
							cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
							
							nLinhas++
							nLinhas++
												
									   
					 	Endif			///mudou o segmento
					  Endif				///é o mesmo repre
					Endif 				///nCta > 1
					 
					 ////
					////IMPRESSÃO DOS DADOS...	 
					If Alltrim(acomis[nCta,14]) = '000009'
						cNomeModal := Alltrim(fNomeModal(acomis[nCta,19]))
						
						
						
						If Alltrim(acomis[nCta,23]) = "S"      //PINTA A LINHA DE AMARELO
							cWeb += '<td width="700" bgcolor="#FFFFC0" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1])+'-'+Alltrim(acomis[nCta,27])+ " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título/parcela
							cWeb += '<td width="350" bgcolor="#FFFFC0" align="left"><span class="style3">' + acomis[nCta,19] + " - " + Alltrim(cNomeModal) +  '</span></td>'+LF  	//MODALIDADE
						
							cWeb += '<td width="350" bgcolor="#FFFFC0"><div align="center"><span class="style3"><b>BONUS</b></span></div></B></td>'+ LF
							cWeb += '<td width="150"  bgcolor="#FFFFC0" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
							cWeb += '<td width="800"  bgcolor="#FFFFC0" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
							cWeb += '<td width="200"  bgcolor="#FFFFC0"  align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
							cWeb += '<td width="200"  bgcolor="#FFFFC0"  align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
							cWeb += '<td width="200"  bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto
							cWeb += '<td width="200"  bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,18], "@E 9999")  + '</span></td>'+LF  	//prazo entrega
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
							//valor título com IPI
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
						Else
							cWeb += '<td width="700" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1])+'-'+Alltrim(acomis[nCta,27]) + " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título/parcela
							cWeb += '<td width="350" align="left"><span class="style3">' + acomis[nCta,19] + " - " + Alltrim(cNomeModal) +  '</span></td>'+LF  	//MODALIDADE
							
							cWeb += '<td width="350"><div align="center"><span class="style3"><b>COMISSAO</b></span></div></B></td>'+ LF
							cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
							cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
							cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
							cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
							cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto
							cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,18], "@E 9999")  + '</span></td>'+LF  	//prazo entrega
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
							//valor título c/ IPI
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
						Endif
							
						
						
						
						If Alltrim(acomis[nCta,23]) = "S" 
							cWeb += '<td width="150"   bgcolor="#FFFFC0" align="right"><span class="style3"></span></td>'+LF  															//% comissão		//qdo tem bônus, a comissão "não aparece"
							cWeb += '<td width="150"   bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
							cWeb += '<td width="300"   bgcolor="#FFFFC0" align="right"><span class="style3"></span></td>'+LF  															//val.comissão
							cWeb += '<td width="300"   bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
							
							cWeb += '<td width="200"  bgcolor="#FFFFC0" ><div align="center"><span class="style3">'+ Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
						
						Else
							cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
							cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  															//% bonus
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF        	//Val.comissão
							cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  	//val.bônus
							
							cWeb += '<td width="200"><div align="center"><span class="style3">'+ Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
						
						Endif						
						
						
					Else 
						cWeb += '<td width="700" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1])+'-'+Alltrim(acomis[nCta,27])+  " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título
						cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
						cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
						cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto.
						//cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,20],"@E 99,999,999.99")+' </span></td>'+LF			//val.MERCADORIA
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF			//val.título
						//valor título com ipi
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF			//val.título
						
						cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF    		//Val.comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
						cWeb += '<td width="200"><div align="center"><span class="style3">' + Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
					Endif					
					cWeb += '</tr>'+LF
					nLinhas++ 				
							
					
					cSegAnt := acomis[nCta,14]
							
					///totais por vendedor
					nTotRec		+= acomis[nCta,12]  ///comissão + bônus (caso haja)
					nTotTit		+= acomis[nCta,8]
					nTotTiPI	+= acomis[nCta,26]
					nTotcomis	+= acomis[nCta,10]
					nTotbonus	+= acomis[nCta,11]
					///total geral (fim do relatório)
					nTotRecGer  += acomis[nCta,12]
							
					nLinhas++		 
								 
					nCta++
					//////GRAVA O HTML 
					Fwrite( nHandle, cWeb, Len(cWeb) )
					cWeb := ""			 		
				
				Enddo
				
								
				//mudou o representante
				If Alltrim(cSegmento) = '000009'
					/////TOTALIZA REPRESENTANTE
					cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> '+ cNomeSeg + '</span></b></td>' +LF
					cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //modalidade
					cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //tipo
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
					cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //PRAZO ENTREGA
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					//valor título com IPI
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
					cWeb += '<td width="200"><div align="center"><span class="style3"></span></div></b></td>'+LF   //dt. pagto comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				Else
					/////TOTALIZA REPRESENTANTE
					cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> ' + cNomeSeg + '</span></b></td>' +LF
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
					cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.  
					//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //VALOR MERCADORIA
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					//valor título c/ IPI
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
					cWeb += '<td width="200"><div align="center"><span class="style3"></span></div></b></td>'+LF     //dt. pagto comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				Endif		
				cWeb += '</strong></tr>'+LF
				nLinhas++
				
							 					  			
				////zera totais
				nTotRec		:= 0
				nTotTit		:= 0 
				nTotTiPI    := 0
				nTotcomis	:= 0
				nTotbonus	:= 0
				
				
				cWeb += '</table>'+LF
				cWeb += '<br>'+LF
				cWeb += '<br>'+LF
				cWeb += '<table width="900" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF								   
				cWeb += '<tr>'+LF
				cWeb += '<td width="200"><span class="style3"><b>TOTAL GERAL DE COMISSAO A RECEBER:</span></b></td>' +LF
				cWeb += '<td width="200" align="right"><span class="style3"><b>'+ Transform(nTotRecGer,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				cWeb += '</tr>'+LF
				nLinhas++
				cWeb += '</b></strong></tr></table>'+LF
				
				///LINHA PRETA DIVISÓRIA
				If lDentroSiga
					If mv_par07 = 2  
						cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
						cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
						cWeb += '</table>' + LF
					
					Endif
				Endif
							
				
							        
				///ZERA O TOTAL GERAL DO REPRESENTANTE
				nTotRecGer := 0
				
				If lDentroSiga				
					If mv_par07 = 1
						////QUEBRA PÁGINA POR REPRESENTANTE
						cWeb += '<div class="quebra_pagina"></div>'+LF
						//nLinhas := 5
						//nPag++			
				
					Elseif nLinhas >= 35
						cWeb += '<div class="quebra_pagina"></div>'+LF
						
					Endif
				Endif							
										
								
			
		Enddo
		
		///FECHA O HTML PARA ENVIO
		cWeb += '</body> '
		cWeb += '</html> ' 
		
		//////GRAVA O HTML 
		Fwrite( nHandle, cWeb, Len(cWeb) )
		FClose( nHandle )
		
		cCodUser := ""
		aUsua	 := {}
		cNomeuser:= ""
		cMailTo	 := ""
				
		///////////ENVIA PARA O USUÁRIO QUE ESTÁ LOGADO NO SISTEMA
		cCodUser := __CUSERID     
						
		PswOrder(1)
		If PswSeek( cCoduser, .T. )
		   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
		   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
		   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
		Endif
		If cSuper == '2348'
			cMailTo += ";" + cMailSuper
		EndIf
							
		cCopia  := ""					
		cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := "REL. COMISS. DE: " + Dtoc(PAR02) + " A " + Dtoc(PAR03)
		aAnexos	:= {}
		AADD(aAnexos,cAnexo)				
		U_fEnvMail(cMailTo, cAssun, cCorpo, aAnexos, .T., .F.)
		Ferase(cAnexo)
		//SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
			   		
		cWeb := ""
		If lDentroSiga
			MsgInfo("Você Recebeu o E-mail deste Relatório.")
			nRet := 0
			nRet := ShellExecute("open",cDirHTM+cArqHTM, "", "", 1) //abre o html no browse
		Endif
	
		
	Else
		MsgInfo("Não existem dados para gerar o Relatório.")
		
	Endif	
	

//////////////////////////////
Else        // lEnvio = .T.
////////////FORA do SIGA GERA UM HTML POR REPRESENTANTE
/////////////////////////////	
	If Len(acomis) > 0 
		TitRel         := "RELATORIO DE COMISSAO DE REPRESENTANTE - Periodo de: " + Dtoc(PAR02) + " a " + Dtoc(PAR03)
                		
		Do while nCta <= Len(acomis)
		
				
				cVendedor := acomis[nCta,13]
				cNomeVend := Alltrim(acomis[nCta,15]) 
				cMailVend := Alltrim(acomis[nCta,17])
				cMailSuper:= Alltrim(acomis[nCta,24])
				cSuper	  := Alltrim(acomis[nCta,25])
				//msgbox(cMailSuper)
							
				////CRIA O ARQUIVO DO HTML
				cDirHTM  := "\Temp\"    
				cArqHTM  := "COMISSOES_" + Alltrim(cVendedor) + ".HTM"   
				nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
				
				cSegmento := acomis[nCta,14]
				cNomeSeg  := ""
				DbselectArea("SX5")
				SX5->(Dbsetorder(1))
				If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
					If Alltrim(cSegmento) = '000009'
						cNomeSeg := Alltrim(SX5->X5_DESCRI)
						cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS P/ RECBTO. DE TITULOS PUBLICOS " //PARA LICITACAO"
					Else
						cNomeSeg := "PRIVADO"
						cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
					Endif
				Endif
				
							
				nLinhas := 80
				nPag	:= 1
				
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
			//Endif	
			
			   				
			If nLinhas >= 45
					
				nLinhas := 5			
			    ///Cabeçalho PÁGINA
			    cWeb += f_Cabeca(nPag,par02,cTit) 
			    
			  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
							
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,13]) + " - " + Alltrim(acomis[nCta,15]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,17]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++
				
				////linha em branco
				cWeb += '<tr>'+LF
				cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
				cWeb += '</tr>'+LF  
				nLinhas++			
						
				cWeb += '<td width="700"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg+ cDemonstrativo +'</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++			
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++		
									
				cWeb += '</table>' + LF
				nLinhas++
							
			    If cSegmento = '000009'
				    //NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	    VALOR	   VALOR	TOTAL A
					//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER						
					///Cabeçalho relatório		      
					cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF 
					cWeb += '<td width="350"><div align="center"><span class="style3"><B>TIPO</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>PRZ.ENTREGA</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF 
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
				Else
					//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
					//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
					///Cabeçalho relatório		      
					cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF 
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF    
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF			
				Endif
				cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
					
				nLinhas++
				nLinhas++		   
				nPag++
				
			Endif
	
				Do while nCta <= Len(acomis) .and. Alltrim(acomis[nCta,13]) = Alltrim(cVendedor) 
					If nCta > 1
					  If Alltrim(acomis[nCta - 1,13]) = Alltrim(acomis[nCta,13])	 
					 	If Alltrim(acomis[nCta -1 ,14]) != Alltrim(acomis[nCta,14])  ///mudou o segmento
					
							cNomeSegAnt  := ""
							SX5->(Dbsetorder(1))
							If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegAnt ))						
								If Alltrim(cSegAnt) = '000009'
									cNomeSegAnt := Alltrim(SX5->X5_DESCRI)
								Else
									cNomeSegAnt := "PRIVADO"
								Endif
							Endif
											
							If Alltrim(cSegmento) = '000009'
							
															
								/////TOTALIZA REPRESENTANTE
								cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> '+ cNomeSegAnt + '</span></b></td>' +LF
								cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //MODALIDADE
								cWeb += '<td width="350"><div align="center"><span class="style3"></span></div></td>'+ LF //tipo
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
								cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto 
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //PRAZO ENTREGA
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF  //val.título
								//valor título c/ IPI
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF  //val.título
								
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
								cWeb += '<td width="200"><div align="center"><span class="style3"><b></span></div></b></td>'+LF		//dt. pagto comissao
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
							Else
								/////TOTALIZA REPRESENTANTE
								cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> ' + cNomeSegAnt + '</span></b></td>' +LF
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
								cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.
								//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //VALOR MERCADORIA
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
								//valor título c/ IPI
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
								
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
								cWeb += '<td width="200"><div align="center"><span class="style3"><b></span></div></b></td>'+LF
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
							
							Endif		
							cWeb += '</strong></tr>'+LF
							cWeb += '</table>' + LF
							cWeb += '<br>'+LF
							cWeb += '<br>'+LF
							//cWeb += '<br>'+LF
							nLinhas++
					 					  			
							////zera totais
							nTotRec		:= 0
							nTotTit		:= 0 
							nTotTiPI	:= 0 
							nTotcomis	:= 0
							nTotbonus	:= 0
						    
							cSegmento := acomis[nCta,14]
							cNomeSeg  := ""
							SX5->(Dbsetorder(1))
							If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
								If Alltrim(cSegmento) = '000009'
									cNomeSeg := Alltrim(SX5->X5_DESCRI)
									cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO E BONUS P/ RECBTO. DE TITULOS PUBLICOS" // LICITAÇAO"
								Else
									cNomeSeg := "PRIVADO"
									cDemonstrativo := "  - DEMONSTRATIVO DE COMISSAO PARA CLIENTE PRIVADO"
								Endif
							Endif
							
							cWeb += '<table width="1100" border="0" style="font-size:11px;font-family:Arial">'+LF				
							cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg+ cDemonstrativo +'</strong></span></div></td>'+LF
							cWeb += '</tr>'+LF
							nLinhas++
									
							////linha em branco
							cWeb += '<tr>'+LF
							cWeb += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
							cWeb += '</tr>'+LF  
							nLinhas++
																	
							cWeb += '</table>' + LF
							nLinhas++
							
							If Alltrim(cSegmento) = '000009'			
							    //NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	    VALOR	   VALOR	TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
								cWeb += '<td width="350"><div align="center"><span class="style3"><B>TIPO</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRZ.ENTREG</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
							Else
														
								//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1100" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>COD. CLIENTE /LOJA</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. EMISSAO TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT. PGTO. TITULO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BASE</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TIT. c/ IPI</span></div></b></td>'+LF								
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF 
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DT.PGTO. COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF			
							Endif
							cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
							
							nLinhas++
							nLinhas++
												
									   
					 	Endif			///mudou o segmento
					  Endif				///é o mesmo repre
					Endif 				///nCta > 1
					 
					 ////
					////IMPRESSÃO DOS DADOS...	 
					If Alltrim(acomis[nCta,14]) = '000009'
						cNomeModal := Alltrim(fNomeModal(acomis[nCta,19]))						
						
						
						If Alltrim(acomis[nCta,23]) = "S"      //PINTA A LINHA DE AMARELO
							cWeb += '<td width="700" bgcolor="#FFFFC0" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) +'-'+Alltrim(acomis[nCta,27])+ " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título/parcela
							cWeb += '<td width="350" bgcolor="#FFFFC0" align="left"><span class="style3">' + acomis[nCta,19] + " - " + Alltrim(cNomeModal) +  '</span></td>'+LF  	//MODALIDADE
						
							cWeb += '<td width="350" bgcolor="#FFFFC0"><div align="center"><span class="style3"><b>BONUS</b></span></div></B></td>'+ LF
							cWeb += '<td width="150"  bgcolor="#FFFFC0" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
							cWeb += '<td width="800"  bgcolor="#FFFFC0" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
							cWeb += '<td width="200"  bgcolor="#FFFFC0"  align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
							cWeb += '<td width="200"  bgcolor="#FFFFC0"  align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
							cWeb += '<td width="200"  bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto
							cWeb += '<td width="200"  bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,18], "@E 9999")  + '</span></td>'+LF  	//prazo entrega
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
							//VALOR TÍTULO C/ IPI
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
						Else
							cWeb += '<td width="700" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) +'-'+Alltrim(acomis[nCta,27])+ " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título/parcela
							cWeb += '<td width="350" align="left"><span class="style3">' + acomis[nCta,19] + " - " + Alltrim(cNomeModal) +  '</span></td>'+LF  	//MODALIDADE
							
							cWeb += '<td width="350"><div align="center"><span class="style3"><b>COMISSAO</b></span></div></B></td>'+ LF
							cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
							cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
							cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
							cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
							cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto
							cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,18], "@E 9999")  + '</span></td>'+LF  	//prazo entrega
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
							//VALOR TÍTULO C/ IPI
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
						Endif
							
						
						
						
						If Alltrim(acomis[nCta,23]) = "S" 
							cWeb += '<td width="150"   bgcolor="#FFFFC0" align="right"><span class="style3"></span></td>'+LF  															//% comissão		//qdo tem bônus, a comissão "não aparece"
							cWeb += '<td width="150"   bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
							cWeb += '<td width="300"   bgcolor="#FFFFC0" align="right"><span class="style3"></span></td>'+LF  															//val.comissão
							cWeb += '<td width="300"   bgcolor="#FFFFC0" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
							
							cWeb += '<td width="200"  bgcolor="#FFFFC0" ><div align="center"><span class="style3">'+ Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
							cWeb += '<td width="300"  bgcolor="#FFFFC0" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
						
						Else
							cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
							cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  															//% bonus
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF        	//Val.comissão
							cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  	//val.bônus
							
							cWeb += '<td width="200"><div align="center"><span class="style3">'+ Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
							cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
						
						Endif						
						
					Else  //SEGMENTO PRIVADO
						cWeb += '<td width="600" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) +'-'+Alltrim(acomis[nCta,27])+  " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título
						cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
						cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
						cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto.
						//cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,20],"@E 99,999,999.99")+' </span></td>'+LF			//val.MERCADORIA
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF			//val.título
						//VALOR TÍTULO C/ IPI
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,26],"@E 99,999,999.99")+' </span></td>'+LF			//val.título
						
						cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF    		//Val.comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
						cWeb += '<td width="200"><div align="center"><span class="style3">' + Dtoc(acomis[nCta,22]) + '</span></div></b></td>'+LF
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
					Endif					
					cWeb += '</tr>'+LF
					
					cSegAnt := acomis[nCta,14]
							
					///totais por vendedor
					nTotRec		+= acomis[nCta,12]  ///comissão + bônus (caso haja)
					nTotTit		+= acomis[nCta,8]
					nTotTiPI	+= acomis[nCta,26]
					nTotcomis	+= acomis[nCta,10]
					nTotbonus	+= acomis[nCta,11]
					///total geral (fim do relatório)
					nTotRecGer  += acomis[nCta,12]
							
					nLinhas++		 
								 
					nCta++			 		
				
				Enddo 		
				
				//mudou o representante
				If Alltrim(cSegmento) = '000009'
					/////TOTALIZA REPRESENTANTE
					cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> '+ cNomeSeg + '</span></b></td>' +LF
					cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //modalidade
					cWeb += '<td width="350"><div align="center"><span class="style3"></span></div></B></td>'+ LF //tipo
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
					cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //PRAZO ENTREGA
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					//VALOR TÍTULO C/ IPI
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
					cWeb += '<td width="200"><div align="center"><span class="style3"></span></div></b></td>'+LF    //dt. pagto. comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				Else
					/////TOTALIZA REPRESENTANTE
					cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE -> ' + cNomeSeg + '</span></b></td>' +LF
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
					cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.  
					//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //VALOR MERCADORIA
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					//VALOR TÍTULO C/ IPI
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTiPI,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
					cWeb += '<td width="200"><div align="center"><span class="style3"><b></span></div></b></td>'+LF    //dt. pagto. comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				Endif		
				cWeb += '</strong></tr>'+LF
				nLinhas++
				 					  			
				////zera totais
				nTotRec		:= 0
				nTotTit		:= 0 
				nTotTiPI	:= 0 
				nTotcomis	:= 0
				nTotbonus	:= 0
				
				
				cWeb += '</table>'+LF
				cWeb += '<br>'+LF
				cWeb += '<br>'+LF
				
				cWeb += '<table width="900" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF								   
				cWeb += '<tr>'+LF
				cWeb += '<td width="200"><span class="style3"><b>TOTAL GERAL DE COMISSAO A RECEBER:</span></b></td>' +LF
				cWeb += '<td width="200" align="right"><span class="style3"><b>'+ Transform(nTotRecGer,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				cWeb += '</tr>'+LF
				nLinhas++
				cWeb += '</b></strong></tr></table>'+LF
				        
				///ZERA O TOTAL GERAL DO REPRESENTANTE
				nTotRecGer := 0
				
				///incluir dados para emissão da NF
				If SM0->M0_CODFIL = '01'
					cWeb += '<BR>'+LF 
					cWeb += '<BR>'+LF
					cWeb += '<BR>'+LF
					cWeb += '<table width="650" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="650"><div align="left"><span class="style3">'+ LF 
					cWeb += 'FABRICA DE SACOS: <br>'+LF
				    cWeb += 'EMITIR NOTA FISCAL PARA:<br>'+LF
				
				    cWeb += 'Rava Embalagens Industria e Comercio Ltda<br>'+LF
				    cWeb += 'Rua Jose Geronimo da Silva Filho, 66-Renascer. Cabedelo-PB.<br>'+LF
				    cWeb += 'CEP 58.310-000<br>'+LF
				    cWeb += 'Inscricao Municipal: 0673<br>'+LF
				    cWeb += 'Inscricao Estadual: 16.100.765-1<br>'+LF
				    cWeb += 'CNPJ 41.150.160/0001-02<br>'+LF
				    cWeb += 'ENVIAR NOTA FISCAL PARA E-MAIL: contabilidade@ravaembalagens.com.br e financeiro@ravaembalagens.com.br</span></div></td>'+ LF
			    
			    Elseif SM0->M0_CODFIL = '03'
			    	cWeb += '<BR>'+LF 
					cWeb += '<BR>'+LF
					cWeb += '<BR>'+LF
					cWeb += '<table width="650" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="650"><div align="left"><span class="style3">'+ LF 
					cWeb += 'FABRICA DE CAIXAS:<br>'+LF
				    cWeb += 'EMITIR NOTA FISCAL PARA:<br>'+LF		
				    cWeb += 'Rava Embalagens Industria e Comercio Ltda		<br>'+LF
				    cWeb += 'Rua Santa Clara, 336-Renascer. Cabedelo-PB.		<br>'+LF
				    cWeb += 'CEP 58.310-000		<br>'+LF
				    cWeb += 'Inscricao Municipal: 003.624-2		<br>'+LF
				    cWeb += 'Inscricao Estadual: 161.780.156		<br>'+LF
				    cWeb += 'CNPJ 41.150.160/0005-28		<br>'+LF
				    cWeb += 'ENVIAR NOTA FISCAL PARA E-MAIL: contabilidade@ravaembalagens.com.br e financeiro@ravaembalagens.com.br</span></div></td>'+ LF
				 Endif
							
				///FECHA O HTML PARA ENVIO
				cWeb += '</body> '
				cWeb += '</html> '
								
				//////GRAVA O HTML 
				Fwrite( nHandle, cWeb, Len(cWeb) )
				FClose( nHandle )
				
				cCodUser := ""
				aUsua	 := {}
				cNomeuser:= ""
				
				///ENVIA PARA REPRESENTANTE E DEISE
					cNaoEnv := "Infelizmente para o(s) Seguinte(s) Vendedor(es) nao foi possivel enviar o email : " + LF
			    	cMailTo := LOWER(cMailVend)
			    	If cSuper == '2348'
			    		cMailTo += ";" + cMailSuper
					EndIf
					//cMailTo += ";alcineide@ravaembalagens.com.br"
					//cMailTo += ";regina@ravaembalagens.com.br" 
					//cMailTo += ";vendas.sp@ravaembalagens.com.br" 
					cMailTo += ";financeiro@ravaembalagens.com.br" //FR - 05/12/12 - RETIRADO POIS ESTAVA TRAVANDO O SERVIDOR DE EMAILS (MTAS MSGS PARA O MESMO DESTINATÁRIO)
					
					//cMailTo := ""	//FR - RETIRAR, HABILITAR SÓ QDO FOR TESTAR
					cCopia  := ""
					//cCopia  += ";flavia.rocha@ravaembalagens.com.br"					
									
					cCorpo  := TitRel  + LF + LF
					cCorpo  += " Este arquivo é melhor visualizado no navegador Mozilla Firefox." + LF + LF
					cCorpo  += " Por gentileza, enviar a Nota Fiscal para: contabilidade@ravaembalagens.com.br e financeiro@ravaembalagens.com.br"
					
					cAnexo  := cDirHTM + cArqHTM
					//cAssun  := cVendedor + " - " + Substr(cNomeVend,1,10) + " - COMISSOES DE: " + Dtoc(PAR02) + " A " + Dtoc(PAR03)
					//cAssun  := "FAVOR CONSIDERAR ESTE: " + Substr(cNomeVend,1,10) + " - COMISSOES DE: " + Dtoc(PAR02) + " A " + Dtoc(PAR03)
					cAssun  := cVendedor + " - Comissoes de: " + Dtoc(PAR02) + " A " + Dtoc(PAR03) + " - " + cEmp		
					
					//lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	 //TENTATIVA 1
					aAnexos := {}
					AADD(aAnexos, cAnexo)
					lEnviou := U_fEnvMail(cMailTo, cAssun, cCorpo, aAnexos, .T., .F.)
					Ferase(cAnexo)
					if lEnviou
					   ////alert('email enviado com sucesso: '+cMailTo)
					else
					   alert('email falhou: '+cMailTo)
					endif
					/*
					If !lEnviou
						lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	 //TENTATIVA 2						
						 If !lEnviou
							lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo ) //TENTATIVA 3
							If !lEnviou
								lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	//TENTATIVA 4
								If !lEnviou
									lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	//TENTATIVA 5
									If !lEnviou
										lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )	//TENTATIVA 6
										cNaoEnv += cVendedor + LF					
									Endif
								Endif
							Endif
						Endif
					Endif							 
					*/		     		
				cWeb := ""
		Enddo
		MemoWrite("C:\Temp1\NAOENVIADO.TXT", cNaoEnv )		
		MemoWrite("S:\Financeiro\RELCOM\NAOENVIADO.TXT", cNaoEnv )		
	//Else
		//msgbox("array vazio")
	Endif		///////SE O ARRAY > 0
	
	//msgbox("Processo Finalizado")
	If !lDentroSiga
		Reset Environment
	Endif
	

Endif
	
////////////////


Return


************************************
Static Function fCabeca(nPag,dDTREF,ctitulo) 
************************************

Local cCabeca := ""


///Cabeçalho PÁGINA
cCabeca += '<html>'+LF
cCabeca += '<head>'+ LF
cCabeca += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cCabeca += '<table width="1100" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cCabeca += '<tr>    <td>'+ LF
cCabeca += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
cCabeca += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cCabeca += '<tr>        <td>SIGA /FINR001/v.P10</td>'+ LF
cCabeca += '<td align="center">' + ctitulo + '</td>'+ LF
cCabeca += '<td align="right">DT.Ref.: '+ Dtoc(dDTREF) + '</td>        </tr>        <tr>          '+ LF
cCabeca += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cCabeca += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cCabeca += '</table></head>'+ LF            

Return(cCabeca)


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


************************************
Static Function f_Cabeca(nPag,dDTREF,ctitulo) 
************************************

Local cCabeca := "" 
Local cEmpresa:= ""

If SM0->M0_CODFIL = '01'
	cEmpresa := "RAVA Embalagens Sacos"
Elseif SM0->M0_CODFIL = '03' 
	cEmpresa := "RAVA Embalagens Caixas" 
Else	
	cEmpresa := SM0->M0_FILIAL
Endif


///Cabeçalho PÁGINA
cCabeca += '<html>'+LF
cCabeca += '<head>'+ LF
cCabeca += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cCabeca += '<table width="1100" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
cCabeca += '<tr>    <td>'+ LF
cCabeca += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
cCabeca += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cCabeca += '<tr>        <td>SIGA /FINR001/v.P10</td>'+ LF
cCabeca += '<td align="center">' + ctitulo + '</td>'+ LF
cCabeca += '<td align="right">DT.Ref.: '+ Dtoc(dDTREF) + '</td>        </tr>        <tr>          '+ LF
cCabeca += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cCabeca += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cCabeca += '</table></head>'+ LF            

Return(cCabeca)

******************************************************************
Static Function SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" ) //"ravasiga@ravaembalagens.com.br" //
Local cPassword	:= GetMV( "MV_RELPSW"  ) //"1311sigaemail" //
Local cServer		:= GetMV( "MV_RELSERV" ) //"smtp.gmail.com:587" //
Local cAttach 	:= cAnexo
Local cFrom		:= GetMV( "MV_RELACNT" ) //"ravasiga@ravaembalagens.com.br" //
//cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
//	MsgAlert("CONECTOU")
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
//	lAutent := MailAuth( "ravasiga@ravaembalagens.com.br", "1311sigaemail" ) //realiza a autenticacao no servidor de e-mail.
/*	
	If lAutent
		MsgAlert("AUTENTICOU")
	Else
		MsgAlert("NÃO AUTENTICOU")
	EndIf
*/	
	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		MsgAlert("ERRO NO ENVIO")
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")
		//conout(Replicate("*",60))
		//conout("FATR011")
	   //	conout("Relatorio Acomp. Cliente " + Dtoc( Date() ) + ' - ' + Time() )
		conout("E-mail nao enviado")
		conout(Replicate("*",60))
	else
		//MsgAlert("ENVIOU")
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	
	DISCONNECT SMTP SERVER
	
else
	//MsgAlert("NÃO CONECTOU")
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

//Tempo para processamento do email
Sleep(9000)

Return(lResult .And. lEnviado )


