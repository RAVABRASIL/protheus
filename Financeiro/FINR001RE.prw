#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FINR001RE - Agendamento para representantes
//Objetivo: RELATÓRIO (Mensal) DE COMISSÃO DE REPRESENTANTE - LINHA MÉDICO HOSPITALAR
// (Contra-cheque)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 02/12/2010
//--------------------------------------------------------------------------
/*/

********************************
User Function FINR01RE()
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
  
  	f_finr01re()	//chama a função do relatório
  
Else
  lDentroSiga := .T.
  f_finr01re()
  
EndIf


Return

****************************
Static Function F_FINR01RE()
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
Local aOrd := {}
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
Private cPerg		 := "FINR001"
Private cString := ""
Private nLin		 := 80
Private LF		:= CHR(13) + CHR(10) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Montagem do cabeçalho
titulo         := "RELATORIO DE COMISSAO DE REPRESENTANTE "

If lDentroSiga
	
	
		Pergunte("FINR001R",.T.) 
	
	    If MsgYesNo("Deseja gerar para ENVIO o relatório de comissões ? ")
			RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		Endif
	
Else

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
Local titulo  := ""


/*
MV_PAR01 : DO VENDEDOR
MV_PAR02 : ATÉ VENDEDOR
MV_PAR03 : MÊS (DOIS DÍGITOS)
MV_PAR04 : SALTA PÁGINA POR VENDEDOR (SIM / NÃO)
MV_PAR05 : COORDENADOR ? 
(SE NÃO ESTIVER PREENCHIDO, IMPRIME TODOS OS VENDEDORES ESPECIFICADOS NOS PARÂMETROS MV_PAR01 E MV_PAR02


*/

Local cQuery	:=''



Local PAR01 := 2		//PELA BAIXA
Local nMesIni := Val(mv_par03) //Month(dDatabase) - 1    //mês anterior
Local PAR02 := Ctod( '15/' + Strzero( (nMesIni - 1) ,2) + '/' + Right(StrZero(Year(dDATABASE),4),2)   ) 
Local PAR03 := Ctod( '14/' + Strzero(nMesIni,2) + '/' + Right(StrZero(Year(dDATABASE),4),2) )
Local PAR06 := 3 	//- Considera quais: A pagar / Pagas / Ambas
Local PAR07 := 1 	//MV_PAR09 - Comissões zeradas : Sim / Nao

//Montagem do cabeçalho
Titulo         := "RELATORIO DE COMISSAO DE REPRESENTANTE - Periodo de: " + Dtoc(PAR02) + " a " + Dtoc(PAR03)

//////////seleciona os dados
cQuery := " SELECT " + LF

cQuery += " CASE WHEN A1_SATIV1 <> '000009' THEN '000010' ELSE A1_SATIV1 END A1_SATIV1  " + LF
cQuery += "  ,A1_NREDUZ, A1_NOME  " + LF
cQuery += " , E3_VEND, E3_NUM, E3_SERIE, F2_DOC, F2_SERIE, F2_EMISSAO,F2_VALMERC, F2_LOCALIZ, F2_EST, E3_COMIS " + LF
cQuery += " , E3_CODCLI,E3_LOJA, E3_PORC, E3_BAIEMI,E3_BONUS  " + LF
cQuery += "  ,A3_COD, A3_NREDUZ, A3_EMAIL  " + LF

cQuery += " ,SUPER = ( SELECT A3_SUPER FROM SA3010 SA3 " + LF
cQuery += "            WHERE A3_COD = SE3.E3_VEND AND ( RTRIM(A3_SUPER) <> '' OR RTRIM(A3_GEREN) = '0249') AND D_E_L_E_T_ = '' ) " + LF

cQuery += " , E3_BASE, E3_PREFIXO, E3_PARCELA " + LF
cQuery += " , E1_NUM, E1_PREFIXO, E1_PARCELA, E1_BAIXA, E1_PEDIDO " + LF

cQuery += " FROM " + RetSqlName("SA1") + " SA1  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SE3") + " SE3 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SE1") + " SE1 WITH (NOLOCK), "+LF
cQuery += " " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "+LF
cQuery += " WHERE " + LF

cQuery += " E3_EMISSAO >= '" + DTOS(par02) + "'  AND E3_EMISSAO <=  '" + DTOS(par03) + "' "+LF 
	
If par01 == 1
	cQuery += " AND E3_BAIEMI <> 'B'"  + LF // Baseado pela emissao da NF
Elseif par01 == 2
	cQuery += " AND E3_BAIEMI = 'B'"  + LF // Baseado pela baixa do titulo
Endif


If par06 == 1 		// Comissoes a pagar
	cQuery += " AND E3_DATA = '' " + LF
ElseIf par06 == 2 // Comissoes pagas
	cQuery += " AND E3_DATA <> '' " + LF
Endif


If par07 == 2 		// Nao Inclui Comissoes Zeradas
   cQuery += " And E3_COMIS <> 0 " + LF
EndIf

If lDentroSiga
	cQuery += " AND RTRIM(E3_VEND) >= '" + Alltrim(mv_par01) + "' AND RTRIM(E3_VEND) <= '" + Alltrim(mv_par02) + "' "+LF
	If !Empty(MV_PAR05)
		cQuery += " AND RTRIM(A3_SUPER) = '" + Alltrim(mv_par05) + "' " + LF
	Endif
Endif

cQuery += " AND E3_NUM = F2_DOC "+LF 
cQuery += " AND RTRIM(E1_NUM) = RTRIM(F2_DOC) "+LF
cQuery += " AND RTRIM(E3_NUM) = RTRIM(E1_NUM ) "+LF

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
cQuery += " AND E1_VEND1 = A3_COD "+LF
cQuery += " AND F2_VEND1 = A3_COD "+LF
cQuery += " AND E3_VEND = F2_VEND1 "+LF
cQuery += " AND E3_VEND = E1_VEND1 "+LF

cQuery += " AND RTRIM(A3_ATIVO) <> 'N' " + LF

cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SE3.E3_FILIAL = '" + xFilial("SE3") + "' AND SE3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' AND SE1.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' " +LF

cQuery += " ORDER BY E3_VEND, A1_SATIV1, E3_NUM, E3_PARCELA   " + LF
//MemoWrite("C:\Temp\FINR001RE.sql", cQuery )

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
	cSegmento := SE3X->A1_SATIV1
		
	cMailVend:= SE3X->A3_EMAIL
	cNomeVend:= SE3X->A3_NREDUZ
	
	cCliente:= SE3X->E3_CODCLI
	cLoja   := SE3X->E3_LOJA
	cNomeCli:= SE3X->A1_NREDUZ
	
	cTitulo := SE3X->E3_NUM
	cSerie  := SE3X->E3_SERIE
	cParcela:= SE3X->E3_PARCELA
		
	dEmissao:= SE3X->F2_EMISSAO //SE3X->E1_EMISSAO 
	cLocaliz:= SE3X->F2_LOCALIZ
	dPagto	:= SE3X->E1_BAIXA 
			
	nPrazoRec := 0
	nValbonus  := 0
	nPorcbonus := 0
	nPorcomis  := 0
	nValcomis  := 0
	nValTit	   := 0
	nValMerc   := 0
	nDias	   := 0		//irá armazenar a soma dos dias vencidos do título + prazo mínimo de entrega (transp.)
	cPedido := ""
	
	nPrazoRec  := iif( !Empty(dPagto), (dPagto - dEmissao) , 0 )	//calcula o prazo de recebimento do título (da emissão até a baixa) 	

	cPedido := SE3X->E1_PEDIDO
	nPrazoEnt := U_fPrazoMin( SE3X->F2_EST )
	cModal    := U_GetModali(cPedido)
	

	nValTit := SE3X->F2_VALMERC
	nValMerc:= SE3X->F2_VALMERC
	
	If SE3X->E3_BONUS = "S" 		///SEPARA O REGISTRO DE BÔNUS
	 	nValbonus := SE3X->E3_COMIS
	 	nPorcbonus:= SE3X->E3_PORC			 	
	Else
	 	nPorcomis := SE3X->E3_PORC
	 	nValcomis := SE3X->E3_COMIS
	Endif
	
	nDias := nPrazoRec + nPrazoEnt
	
	If nPorcbonus = 0		//Se no SE3 não tiver bônus, faz uma busca calculada para ter certeza se existe ou não bônus para o repre.			
		
		nPorcbonus:= U_FINC002(cPedido, nDias ) 
		nValbonus := nValTit * (nPorcbonus / 100)
	Endif
	
	nTotrec:= ( nValcomis + nValbonus)		

	
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
					 cParcela })		//21 
					 
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

	If Len(acomis) > 0
                		
		Do while nCta <= Len(acomis)
		
				
				cVendedor := acomis[nCta,13]
				cNomeVend := Alltrim(acomis[nCta,15]) 
				cMailVend := Alltrim(acomis[nCta,17])
							
				////CRIA O ARQUIVO DO HTML
				cDirHTM  := "\Temp\"    
				cArqHTM  := "FINR-" + Alltrim(cVendedor) + ".HTM"   
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
		      	cWeb += '<html>'+LF
				cWeb += '<head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FINR001/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(par02) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
					
				cWeb += '</table></head>'+ LF            
						
			  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
							
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(acomis[nCta,13]) + " - " + Alltrim(acomis[nCta,15]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(acomis[nCta,17]) + '</span></div></td>'+LF
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
					cWeb += '<table width="1000" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA PAGTO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TITULO / Parcela (sem IPI) </span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
				Else
					//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
					//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
					///Cabeçalho relatório		      
					cWeb += '<table width="1000" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA PAGTO</span></div></b></td>'+LF
					cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TITULO / Parcela (sem IPI)</span></div></b></td>'+LF
					cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
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
								cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE : '+ cNomeSegAnt + '</span></b></td>' +LF
								cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //MODALIDADE
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
								cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
								cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto + prazo entrega
								//cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //VALOR MERCADORIA
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF  //val.título
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
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
								cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
								//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
								cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
								//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
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
							
							cWeb += '<table width="1000" border="0" style="font-size:11px;font-family:Arial">'+LF				
							cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>CLIENTE: '+cNomeSeg+ cDemonstrativo +'</strong></span></div></td>'+LF
							cWeb += '</tr>'+LF
							nLinhas++
									
							////linha em branco
							cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
							nLinhas++
																	
							cWeb += '</table>' + LF
							nLinhas++
							
							If Alltrim(cSegmento) = '000009'			
							    //NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	         %	    VALOR	   VALOR	TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	BÔNUS	COMISSÃO	BÔNUS	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1000" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="350"><div align="center"><span class="style3"><B>MODALIDADE</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA PAGTO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								//cWeb += '<td width="200"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TITULO / Parcela (sem IPI)</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>TOTAL A RECEBER</span></div></b></td>'+LF
							Else
														
								//NÚMERO	CÓDIGO DO	LJ	NOME DO CLIENTE	DATA	DATA	PRAZO	VALOR	  %	        VALOR		TOTAL A
								//TÍTULO	CLIENTE			               EMISSÃO	PAGTO.	RECTO.	TÍTULO	COMISSÃO	COMISSÃO	RECEBER						
								///Cabeçalho relatório		      
								cWeb += '<table width="1000" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
								cWeb += '<td width="600"><div align="center"><span class="style3"><B>NUMERO TITULO / Parcela</span></div></B></td>'+ LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>CODIGO CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="800"><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA EMISSAO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>DATA PAGTO</span></div></b></td>'+LF
								cWeb += '<td width="200"><div align="center"><span class="style3"><b>PRAZO RECBTO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR MERCADORIA</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR TITULO / Parcela (sem IPI)</span></div></b></td>'+LF
								cWeb += '<td width="150"><div align="center"><span class="style3"><b>% COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>% BONUS</span></div></b></td>'+LF
								cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR COMISSAO</span></div></b></td>'+LF
								//cWeb += '<td width="300"><div align="center"><span class="style3"><b>VALOR BONUS</span></div></b></td>'+LF
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
						cNomeModal := Alltrim(U_fNomeModal(acomis[nCta,19]))
						
						cWeb += '<td width="600" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) + " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título/parcela
						cWeb += '<td width="350" align="left"><span class="style3">' + acomis[nCta,19] + " - " + Alltrim(cNomeModal) +  '</span></td>'+LF  	//MODALIDADE
						cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
						cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
						//cWeb += '<td width="250" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + "+" + Transform(acomis[nCta,18], "@E 9999")+ '</span></td>'+LF  	//prazo recebto+prazo entrega.
						cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto
						//cWeb += '<td width="200" align="right"><span class="style3">'+ Transform(acomis[nCta,20],"@E 99,999,999.99")+' </span></td>'+LF        	//val.MERCADORIA
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF        	//val.título
						cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
						cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF        	//Val.comissão
						cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
					Else 
						cWeb += '<td width="600" align="left"><span class="style3">'+ Alltrim(acomis[nCta,1]) +  " / " + Alltrim(acomis[nCta,21]) + '</span></td>'+LF      				//título
						cWeb += '<td width="150" align="left"><span class="style3">' + acomis[nCta,2] + "/" + acomis[nCta,3]+ /* '-seg:'+ acomis[nCta,14]+ */ '</span></td>'+LF  	//cod.cliente/loja
						cWeb += '<td width="800" align="left"><span class="style3">' + Alltrim(Substr(acomis[nCta,4],1,20))+ ' </span></td>'+LF     //nome cliente
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,5]) + ' </span></td>'+LF        			//dt.emissão
						cWeb += '<td width="200" align="center"><span class="style3">' + Dtoc(acomis[nCta,6]) + ' </span></td>'+LF        			//dt.pagto
						cWeb += '<td width="200" align="right"><span class="style3">' + Transform(acomis[nCta,7], "@E 9999")  + '</span></td>'+LF  	//prazo recebto.
						//cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,20],"@E 99,999,999.99")+' </span></td>'+LF			//val.MERCADORIA
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,8],"@E 99,999,999.99")+' </span></td>'+LF			//val.título
						cWeb += '<td width="150" align="right"><span class="style3">' + Transform(acomis[nCta,9], "@E 99.99")  + '</span></td>'+LF  			//% comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,16], "@E 99.99")  + '</span></td>'+LF  			//% bonus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,10],"@E 99,999,999.99")+' </span></td>'+LF    		//Val.comissão
						//cWeb += '<td width="300" align="right"><span class="style3">' + Transform(acomis[nCta,11], "@E 99,999,999.99")  + '</span></td>'+LF  	//val.bônus
						cWeb += '<td width="300" align="right"><span class="style3">'+ Transform(acomis[nCta,12],"@E 99,999,999.99")+' </span></td>'+LF        	//total a receber
					Endif					
					cWeb += '</tr>'+LF
					
					cSegAnt := acomis[nCta,14]
							
					///totais por vendedor
					nTotRec		+= acomis[nCta,12]  ///comissão + bônus (caso haja)
					nTotTit		+= acomis[nCta,8]
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
					cWeb += '<td width="600"><span class="style3"><b>TOTAL GERAL CLIENTE : '+ cNomeSeg + '</span></b></td>' +LF
					cWeb += '<td width="350" align="right"><span class="style3"></span></td>'+LF  //modalidade
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //cod.cliente/loja
					cWeb += '<td width="800" align="right"><span class="style3"></span></td>'+LF        //nome cliente
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.emissão
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF        //dt.pagto
					cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //prazo recebto.
					//cWeb += '<td width="200" align="right"><span class="style3"></span></td>'+LF  //VALOR MERCADORIA
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotTit,"@E 99,999,999.99")+'</b></span></td>'+LF        //val.título
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
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
					cWeb += '<td width="150" align="right"><span class="style3"></span></td>'+LF  //% comissão
					//cWeb += '<td width="300" align="right"><span class="style3"></span></td>'+LF  //% bonus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotcomis,"@E 99,999,999.99")+'</b></span></td>'+LF        //Val.comissão
					//cWeb += '<td width="300" align="right"><span class="style3"><b>' + Transform(nTotbonus, "@E 99,999,999.99")  + '</b></span></td>'+LF  //val.bônus
					cWeb += '<td width="300" align="right"><span class="style3"><b>'+ Transform(nTotRec,"@E 999,999,999.99")+'</b></span></td>'+LF        //total a receber
				Endif		
				cWeb += '</strong></tr>'+LF
				nLinhas++
				 					  			
				////zera totais
				nTotRec		:= 0
				nTotTit		:= 0 
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
							
				///FECHA O HTML PARA ENVIO
				cWeb += '</body> '
				cWeb += '</html> '
								
				//////GRAVA O HTML 
				Fwrite( nHandle, cWeb, Len(cWeb) )
				FClose( nHandle )
				
				cCodUser := ""
				aUsua	 := {}
				cNomeuser:= ""
				
				///////////ENVIA PARA O USUÁRIO QUE ESTÁ LOGADO NO SISTEMA
				cCodUser := __CUSERID     
								
				PswOrder(1)
				If PswSeek( cCoduser, .T. )
				   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
				   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
				   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
				   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
				Endif
								
				cCopia  := "" //cMailRepre					
				cCorpo  := cTit  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := cVendedor + " - " + Substr(cNomeVend,1,10) + " - REL. COMISS. DE: " + Dtoc(PAR02) + " A " + Dtoc(PAR03)
						
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
				   		
				cWeb := ""
							
			
		Enddo
				
	Endif		///////SE O ARRAY > 0
	




Return