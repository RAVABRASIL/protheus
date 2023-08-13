#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATRPCRE  º Autor ³ Eurivan Marques    º Data ³  21/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedidos aguardando liberacao de credito.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************************
User Function FATRPCRE() 
*************************

Private lDentroSiga := .F.

If Select( 'SX2' ) == 0  

  
  /////SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  fRPCRE()      
  Reset Environment   //deixei na saída da função do relatório
    
  ///CAIXAS
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )  
  fRPCRE()      
  Reset Environment
  
  
                         
Else
  lDentroSiga := .T.
  fRPCRE()
  
EndIf

  

Return

*************************
Static Function fRPCRE() 
*************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Pedidos aguardando liberação de Credito"
Local cPict         := ""
Local titulo        := "Pedidos Aguardando Liberação de Credito"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 140
Private tamanho     := "M"
Private nomeprog    := "FATPCRE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATRPCRE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC9"
Private cPerg       := "FATRPCRE"
Private Cab         := "Pedido  Dt.Program  Cliente                                  Dias             Valor         OBS"
                      //999999    99/99/99  000000 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  9999
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8			9



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga 
	Pergunte(cPerg,.T.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	
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
	
	RptStatus({|| RunReport(Titulo,nLin) },Titulo)
Else
	RunReport(Titulo,nLin)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Titulo,nLin)

Local cQuery := ''
Local aAntec := {}
Local total  := 0
Local totger := 0
Local cDirHTM:= ""
Local cArqHTM:= ""
Local nHandle:= 0
Local LF     := CHR(13) + CHR(10)

cQuery := "SELECT C9_FILIAL, C9_PEDIDO ,C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED, sum( C9_QTDLIB * C9_PRCVEN ) TOTAL, C9_OBSREJ " + CHR(13) + CHR(10)
cQuery += " , A3_SUPER, C5_VEND1, AVG(C5_DESC1) C5_DESC1 " + CHR(13) + CHR(10)
cQuery += "FROM "+RetSqlName("SC9")+" SC9 " + CHR(13) + CHR(10)
cQuery += " ,   "+RetSqlName("SA1")+" SA1 " + CHR(13) + CHR(10)
cQuery += " ,   "+RetSqlName("SC5")+" SC5 " + CHR(13) + CHR(10)
cQuery += " ,   "+RetSqlName("SA3")+" SA3 " + CHR(13) + CHR(10)

cQuery += "WHERE (C9_BLCRED = '01' OR C9_BLCRED = '04' OR C9_BLCRED = '09' ) " + CHR(13) + CHR(10)

//IMPORTANTE POIS SENÃO, IRÁ MOSTRAR PEDIDOS QUE JÁ TEM NOTA EMITIDA, MAS QUE FICOU GRAVADO NOS CAMPOS DE BLOQUEIO ALGUM CÓDIGO (01, 04, 09...)
cQuery += " AND C9_NFISCAL = '' "  + CHR(13) + CHR(10) 
cQuery += " AND C9_SEQUEN  = '01' "  + CHR(13) + CHR(10) //EVITA MOSTRAR PEDIDOS QUE FORAM LIBERADOS "NOVAMENTE", QDO CRIA A SEQUÊNCIA 02

//cQuery += " AND A3_SUPER = '0228' " + CHR(13) + CHR(10) //RETIRAR        

cQuery += " AND A1_COD+A1_LOJA = C9_CLIENTE+C9_LOJA " + CHR(13) + CHR(10)
cQuery += " AND C5_FILIAL = C9_FILIAL " + CHR(13) + CHR(10)
cQuery += " AND C5_NUM = C9_PEDIDO " + CHR(13) + CHR(10)
cQuery += " AND C5_VEND1 = A3_COD  " + CHR(13) + CHR(10) 
cQuery += " AND A3_ATIVO <> 'N'    " + CHR(13) + CHR(10)

cQuery += " AND SC9.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
cQuery += " AND SA1.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
cQuery += " AND SC5.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
cQuery += " AND SA3.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)

If lDentroSiga
	IF !EMPTY(MV_PAR01)
		cQuery += " AND A3_SUPER = '" + Alltrim(MV_PAR01) + "' " + CHR(13) + CHR(10)   //filtra coordenador qdo preenchido parâmetro
	ENDIF	      
Endif
cQuery += "GROUP BY C9_FILIAL, C9_PEDIDO, C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED, C9_OBSREJ , A3_SUPER, C5_VEND1 " + CHR(13) + CHR(10)

If !lDentroSiga  //fora do siga, ordena por coordenador, para envio individual (por coordenador)
	cQuery += "ORDER BY C9_FILIAL, A3_SUPER, C9_PEDIDO "
Else //dentro do Siga
	cQuery += "ORDER BY C9_FILIAL, C9_PEDIDO "
Endif
MemoWrite("C:\TEMP\FATRPCRE.SQL", cQuery )
TCQUERY cQUery NEW ALIAS "PEDX"
TCSetField( 'PEDX', 'C5_ENTREG', 'D' )
PEDX->( dbGoTop() )

If !PEDX->(EOF())
	If !lDentroSiga
		   

		While !PEDX->(EOF())
		   cSuper := PEDX->A3_SUPER 
		   
		   If !Empty(cSuper)
			   ////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
				cDirHTM  := "\Temp\"    
				cArqHTM  := "AGD_LibCrd_" + Alltrim(cSuper) + "_.HTM"
				nHandle := fCreate( cDirHTM + cArqHTM, 0 )
					    
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
				
			   	cWeb := '<html>'+LF
				cWeb += '<head>'+LF
				cWeb += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+LF
				cWeb += '<title>PEDIDOS AGUARDANDO LIBERAÇÃO CREDITO - ' + SM0->M0_FILIAL + '</title>'+LF
				cWeb += '<style>'+LF
				cWeb += '<!--'+LF
				cWeb += 'div.Section1'+LF
				cWeb += '	{page:Section1;}'+LF
				cWeb += '-->'+LF
				cWeb += '</style>'+LF
				cWeb += '</head>'+LF
				cWeb += '<body>'+LF
				cWeb += '	<div align="center">'+LF
				cWeb += '	</div>'+LF
				cWeb += '	<br>'+LF
				cWeb += '	<strong>'+LF
				cWeb += '		<center>'+LF
				cWeb += "		<span style='font-size:15pt;font-family:Verdana;color:black; text-decoration:underline'>"+LF
				cWeb += '			Pedidos Aguardando Liberação Crédito - ' + SM0->M0_FILIAL +LF
				cWeb += '		</span>'+LF
				cWeb += '		</center>'+LF
				cWeb += '	</strong>'+LF
				cWeb += "<span style='font-size:8pt;font-family:Verdana;color:black; text-decoration:underline'>"+LF
				cWeb += ' 	</span>	<br>'+LF
				cWeb += '	</p>'+LF
				cWeb += '	<div>'+LF 
					
			
			   	cWeb += '		<table width="780" align=center>'+LF
				cWeb += "			<tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
				cWeb += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="11">'+LF
				cWeb += '       <p align="left"><BR><font face = "Verdana"><BR>'+LF
				cWeb += '        Coordenador(a): '+ cSuper + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + cSuper, 'A3_NOME') + '</font><br><BR><BR></td></tr>'+LF
				cWeb += "        <tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
				cWeb += '        <td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="12">'+LF
				cWeb += '    	<p align="left"><BR><font face = "Verdana">Prezado(s), Abaixo, Seguem os Pedidos que estão Aguardando'+LF
				cWeb += '        Liberação no CREDITO.</font><br><BR><BR></td>'+LF
				cWeb += '        </tr>'+LF
				
				cWeb += '   			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
				cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Pedido</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Para a Data</b></td>'+LF
				cWeb += '                <td width="292" align="center" bgcolor="#A2D7AA"><b>Cliente</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Dias</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Valor</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>OBS</b></td>'+LF
				cWeb += '			</tr>'+LF
				nLin := 6			   
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Impressao do cabecalho do relatorio. . .                            ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   	Do While !PEDX->(EOF()) .and. PEDX->A3_SUPER == cSuper
			   	
			   		If nLin > 55
			   			cWeb += '		<table width="780" align=center>'+LF
						cWeb += "			<tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
						cWeb += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="11">'+LF
						cWeb += '       <p align="left"><BR><font face = "Verdana"><BR>'+LF
						cWeb += '        Coordenador(a): '+ cSuper + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + cSuper, 'A3_NOME') + '</font><br><BR><BR></td></tr>'+LF
						cWeb += "        <tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
						cWeb += '        <td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="12">'+LF
						cWeb += '    	<p align="left"><BR><font face = "Verdana">Prezado(s), abaixo, segue(m) o(s) Pedido(s) que está(ão) Aguardando'+LF
						cWeb += '        Liberação no CREDITO.</font><br><BR><BR></td>'+LF
						cWeb += '        </tr>'+LF
						
						cWeb += '   			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
						cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Pedido</b></td>'+LF
						cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Para a Data</b></td>'+LF
						cWeb += '                <td width="292" align="left" bgcolor="#A2D7AA"><b>Cliente</b></td>'+LF
						cWeb += '                <td width="142" align="right" bgcolor="#A2D7AA"><b>Dias</b></td>'+LF
						cWeb += '                <td width="142" align="right" bgcolor="#A2D7AA"><b>Valor</b></td>'+LF
						cWeb += '                <td width="142" align="left" bgcolor="#A2D7AA"><b>OBS</b></td>'+LF
						cWeb += '			</tr>'+LF
			   		
			   		Endif
			   
				   if PEDX->C5_CONDPAG = '001'
				      Aadd( aAntec, {PEDX->C9_PEDIDO,PEDX->C5_ENTREG,PEDX->C5_CONDPAG,PEDX->A1_COD,PEDX->A1_NOME,PEDX->C9_BLCRED} )
				   endif   
				   
					//"Pedido  Dt.Program  Cliente                                  Dias             Valor         OBS"
					cWeb += '			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
					cWeb += '				<td width="142" align="left">'+PEDX->C9_PEDIDO+'</td>'+LF
					cWeb += '				<td width="142" align="left">'+DTOC(PEDX->C5_ENTREG)+'</td>'+LF
					cWeb += '          		<td width="142" align="center">'+ PEDX->A1_COD+" - "+SUBS(PEDX->A1_NOME,1,30)+'</td>'+LF
					cWeb += '          		<td width="292" align="left"><b>'+iif( PEDX->C9_BLCRED = '09', 'REJEIT. CREDITO', Transform( dDataBase - PEDX->C5_ENTREG, "@E 9999" ) )+'</b></td>'+LF
					cWeb += '            	<td width="142" align="center"><b>'+Transform(PEDX->TOTAL, "@E 999,999.99")+'</b></td>'+LF
					cWeb += '            	<td width="142" align="right"><b>'+PEDX->C9_OBSREJ+'</b></td>'+LF
					cWeb += '           	</tr>'+LF
						
					total  += PEDX->TOTAL
				    totger += PEDX->TOTAL
					nLin++
					
					PEDX->(dbSkip())
				Enddo
				cWeb += "           	<tr style='font-size:10.0pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>"+LF
				cWeb += '           	<td align="right" colspan="4"><B>TOTAL ==></B></td>'+LF
				cWeb += '           	<td width="142" align="right"><B>'+ Transform( total, "@E 999,999.99") + '</B></td>'+LF
				cWeb += '           	<td width="142" align="right"><B></B></td>'+LF			//ESPAÇO
				cWeb += '           	</tr>'+LF
				cWeb += "            <tr style='font-size:8.5pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>"+LF
				cWeb += "				<td style='font-size:9.0pt;font-family:Verdana;color:black' bgcolor='#E2E9E6' width='660' colspan='11'>"+LF
				//cWeb += '					<table width="185" height="27" border="1">'+LF
				
				///pedidos antecipados
				cWeb += '<br>' + LF
				cWeb += '<br>' + LF
				cWeb += '<br>' + LF
				cWeb += '			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
				cWeb += '           	<td align="center" colspan="6"><B>PEDIDOS ANTECIPADOS</B></td>'+LF
				cWeb += '        </tr>'+LF
							
				cWeb += '   			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
				cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Pedido</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Para a Data</b></td>'+LF
				cWeb += '                <td width="292" align="center" bgcolor="#A2D7AA"><b>Cliente</b></td>'+LF
				cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA" colspan="3"><b>Dias</b></td>'+LF
				//cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Valor</b></td>'+LF
				//cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>OBS</b></td>'+LF
				cWeb += '			</tr>'+LF
				
				for nX := 1 to len( aAntec )
				   If nLin > 55
				      	cWeb += '   			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
						cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Pedido</b></td>'+LF
						cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Para a Data</b></td>'+LF
						cWeb += '                <td width="292" align="center" bgcolor="#A2D7AA"><b>Cliente</b></td>'+LF
						cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA" colspan="3"><b>Dias</b></td>'+LF
						//cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Valor</b></td>'+LF
						//cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>OBS</b></td>'+LF
						cWeb += '			</tr>'+LF
				   Endif
			       /*
				   @nLin, 00 PSAY aAntec[nX,1]
				   @nLin, 08 PSAY DTOC( aAntec[nX,2] )
				   @nLin, 20 PSAY aAntec[nX,4]+" - "+SUBS(aAntec[nX,5],1,30)
				   @nLin, 61 PSAY iif( aAntec[nX,6] = '09', 'REJEIT. CREDITO', Transform( dDataBase - aAntec[nX,2], "@E 9999" ) )
				   */
				   
				   	cWeb += '			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
					cWeb += '				<td width="142" align="left">'+ aAntec[nX,1]+'</td>'+LF
					cWeb += '				<td width="142" align="left">'+DTOC(aAntec[nX,2])+'</td>'+LF
					cWeb += '          		<td width="142" align="center">'+ aAntec[nX,4] + " - " + SUBS(aAntec[nX,5],1,30)+'</td>'+LF
					cWeb += '          		<td width="292" align="left" colspan="3"><b>'+iif( aAntec[nX,6] = '09', 'REJEIT. CREDITO', Transform( dDataBase - aAntec[nX,2], "@E 9999" ) )+'</b></td>'+LF
					//cWeb += '                <td width="142" align="center" <b></b></td>'+LF
					//cWeb += '                <td width="142" align="center" <b></b></td>'+LF
					cWeb += '           	</tr>'+LF
				
				   nLin++
				next nX
						
				
				cWeb += '             </table>'+LF
				cWeb += '             <br>'+LF
				cWeb += '             </p></td>'+LF
				cWeb += '			</tr>'+LF
					
				total := 0
				nLin++
				
				cWeb += "            <tr style='font-size:8.5pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>"+LF
				cWeb += "				<td style='font-size:9.0pt;font-family:Verdana;color:black' bgcolor='#E2E9E6' width='660' colspan='11'>"+LF
				cWeb += '					<table width="185" height="27" border="1">'+LF
				cWeb += '             </table>'+LF
				cWeb += '             <br>'+LF
				cWeb += '             </p></td>'+LF
				cWeb += '			</tr>'+LF
				cWeb += '		</table>'+LF
				cWeb += '	</div>'+LF
				cWeb += '	<div>'+LF
				cWeb += '	</div>'+LF
				cWeb += '<BR>'+LF
				cWeb += '<BR>'+LF
				cWeb += '<p><span style="FONT-SIZE: 7pt; COLOR: black; FONT-FAMILY: Verdana">'+LF
				cWeb += '<< "FATRPCRE.htm" >></span></p>'+LF
				cWeb += '</body>'+LF
				cWeb += '</html>'+LF
				
				///GRAVA O HTML
				Fwrite( nHandle, cWeb, Len(cWeb) )
				FClose( nHandle )
				
				cAssun  := ""
				cAnexo  := ""
				cMailTo := POSICIONE("SA3",1,XFILIAL("SA3") + cSuper, 'A3_EMAIL')
				cCopia  := "comercial@ravaembalagens.com.br "   //"flavia.rocha@ravaembalagens.com.br"
				//cMailTo := "flavia.rocha@ravaembalagens.com.br"
												
				cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := "Pedidos Aguardando Lib. Credito - " + cSuper + ' - ' + SM0->M0_FILIAL //titulo
									
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			    cWeb := ""
		   Endif //empty cSuper
		EndDo
			
		//MsgInfo("FATRPCRE - Você recebeu um e-mail deste Relatório.")
		
		

	Else //no Siga
	
		While !PEDX->(EOF())
	   
	      	If nLin > 55
		      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
		      If !Empty(MV_PAR01)
		      	@nLin,000 PSAY "FILTRADO POR COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
		      	nLin++                                                                                                     
		      	nLin++
		      Endif      
		      @nLin, 00 PSay Cab
		      nLin++
				      
		      @nLin, 00 PSay Replicate("-",Limite)
		      nLin++      
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
	   		if PEDX->C5_CONDPAG = '001'
		      Aadd( aAntec, {PEDX->C9_PEDIDO,PEDX->C5_ENTREG,PEDX->C5_CONDPAG,PEDX->A1_COD,PEDX->A1_NOME,PEDX->C9_BLCRED} )
		   	endif   
		   
			If nLin > 55
			     nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
			     If !Empty(MV_PAR01)
			    	@nLin,000 PSAY "FILTRADO POR COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
			    	nLin++                                                                                                     
			      	nLin++
			     //Else
					//@nLin,000 PSAY "COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
					//nLin++				
			     Endif      
			     @nLin, 00 PSay Cab
			     nLin++
			      
			     @nLin, 00 PSay Replicate("-",Limite)
			     nLin++      
			Endif
			
			If PEDX->C5_DESC1 > 0
				@nLin, 00 PSAY PEDX->C9_PEDIDO + '-'
			Else
				@nLin, 00 PSAY PEDX->C9_PEDIDO
			EndIf
			@nLin, 08 PSAY DTOC( PEDX->C5_ENTREG )
			@nLin, 20 PSAY PEDX->A1_COD+" - "+SUBS(PEDX->A1_NOME,1,30)
			@nLin, 61 PSAY iif( PEDX->C9_BLCRED = '09', 'REJEIT. CREDITO', Transform( dDataBase - PEDX->C5_ENTREG, "@E 9999" ) )
			@nLin, 77 PSAY Transform(PEDX->TOTAL, "@E 999,999.99")
			
			If Len(Alltrim(PEDX->C9_OBSREJ)) > 40
				@nLin, 90 PSAY SubStr(PEDX->C9_OBSREJ,1,40)
				nLin ++
				@nLin, 90 PSAY SubStr(PEDX->C9_OBSREJ,41,40)
			Else
				@nLin, 90 PSAY PEDX->C9_OBSREJ
			EndIf
			
			total  += PEDX->TOTAL
		    nLin ++
			
			PEDX->(dbSkip())
		Enddo
				
		nLin++
		@nLin, 70 PSAY "Total: " + Transform( total, "@E 999,999.99")
		nLin++
		@nLin, 00 PSAY Replicate("-",Limite)
		nLin++
			
		If nLin > 55
		      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
		      If !Empty(MV_PAR01)
		      	@nLin,000 PSAY "FILTRADO POR COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
		      	nLin++                                                                                                     
		      	nLin++
		      //Else
				//@nLin,000 PSAY "COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
				//nLin++				
		      Endif      
		      @nLin, 00 PSay Cab
		      nLin++
			      
		      @nLin, 00 PSay Replicate("-",Limite)
		      nLin++      
		Endif
		   	
		@nLin, 00 PSAY PadC("Pedidos Antecipados", limite)
		nLin++
		@nLin, 00 PSAY Replicate("-",Limite)
		nLin++
		@nLin, 00 PSAY Cab
		nLin++
		@nLin, 00 PSAY Replicate("-",Limite)
		nLin++
		nLin++
		
		for nX := 1 to len( aAntec )
		   If nLin > 55
		      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
		      If !Empty(MV_PAR01)
		      	@nLin,000 PSAY "FILTRADO POR COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
		      	nLin++                                                                                                     
		      	nLin++
		      Else
				@nLin,000 PSAY "COORDENADOR: " + PEDX->A3_SUPER + '-' + POSICIONE("SA3",1,XFILIAL("SA3") + PEDX->A3_SUPER, 'A3_NOME')
				nLin++				
		      Endif      
		      @nLin, 00 PSay Cab
		      nLin++
		      
		      @nLin, 00 PSay Replicate("-",Limite)
		      nLin++      
		   Endif
	
		   @nLin, 00 PSAY aAntec[nX,1]
		   @nLin, 08 PSAY DTOC( aAntec[nX,2] )
		   @nLin, 20 PSAY aAntec[nX,4]+" - "+SUBS(aAntec[nX,5],1,30)
		   @nLin, 61 PSAY iif( aAntec[nX,6] = '09', 'REJEIT. CREDITO', Transform( dDataBase - aAntec[nX,2], "@E 9999" ) )
		
		   nLin++
		next nX
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza a execucao do relatorio...                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lDentroSiga
			Roda(0,"",tamanho)
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
		Endif       
		
	Endif //dentrosiga

	PEDX->(DbCloseArea())

Endif  //EOF



Return

/*
*************************
Static Function EnvHTM() 
*************************

Local LF     := CHR(13) + CHR(10)

cWeb := '<html>'+LF
cWeb += '<head>'+LF
cWeb += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+LF
cWeb += '<title>PEDIDOS LIBERADOS CREDITO</title>'+LF
cWeb += '<style>'+LF
cWeb += '<!--'+LF
cWeb += 'div.Section1'+LF
cWeb += '	{page:Section1;}'+LF
cWeb += '-->'+LF
cWeb += '</style>'+LF
cWeb += '</head>'+LF
cWeb += '<body>'+LF
cWeb += '	<div align="center">'+LF
cWeb += '	</div>'+LF
cWeb += '	<br>'+LF
cWeb += '	<strong>'+LF
cWeb += '		<center>'+LF
cWeb += "		<span style='font-size:15pt;font-family:Verdana;color:black; text-decoration:underline'>"+LF
cWeb += '			Pedidos Aguardando Liberacao Credito'+LF
cWeb += '		</span>'+LF
cWeb += '		</center>'+LF
cWeb += '	</strong>'+LF
cWeb += "<span style='font-size:8pt;font-family:Verdana;color:black; text-decoration:underline'>"+LF
cWeb += ' 	</span>	<br>'+LF
cWeb += '	</p>'+LF
cWeb += '	<div>'+LF
cWeb += '		<table width="780" align=center>'+LF
cWeb += "			<tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
cWeb += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="11">'+LF
cWeb += '       <p align="left"><BR><font face = "Verdana"><BR>'+LF
cWeb += '        Coordenador(a): %cSuper%</font><br><BR><BR></td></tr>'+LF
cWeb += "        <tr style='font-size:9.0pt;font-family:Verdana;color:black'>"+LF
cWeb += '        <td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="12">'+LF
cWeb += '    	<p align="left"><BR><font face = "Verdana">Prezado(s), abaixo, segue(m) o(s) Pedido(s) que está(ão) Aguardando'+LF
cWeb += '        Liberação no CREDITO.</font><br><BR><BR></td>'+LF
cWeb += '        </tr>'+LF
cWeb += '   			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Pedido</b></td>'+LF
cWeb += '    			<td width="142" align="center" bgcolor="#A2D7AA"><b>Tipo</b></td>'+LF
cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Para a Data</b></td>'+LF
cWeb += '                <td width="292" align="center" bgcolor="#A2D7AA"><b>Cliente</b></td>'+LF
cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Liberado em</b></td>'+LF
cWeb += '                <td width="142" align="center" bgcolor="#A2D7AA"><b>Valor</b></td>'+LF
cWeb += '			</tr>'+LF
cWeb += '			<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+LF
cWeb += '				<td width="142" align="left">'+%it.cPed1%+'</td>'+LF
cWeb += '				<td width="142" align="left">'%it.cTipo1%+'</td>'+LF
cWeb += '          		<td width="142" align="center">'%it.dDTPrg1%+'</td>'+LF
cWeb += '          		<td width="292" align="left"><b>'%it.cCli1%+'</b></td>'+LF
cWeb += '            	<td width="142" align="center"><b>'%it.dLib1%+'</b></td>'+LF
cWeb += '            	<td width="142" align="right"><b>'%it.nVal1%+'</b></td>'+LF
cWeb += '           	</tr>'+LF
cWeb += "           	<tr style='font-size:10.0pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>"+LF
cWeb += '           	<td align="right" colspan="5"><B>TOTAL ==></B></td>'+LF
cWeb += '           	<td width="142" align="right"><B>%nTot1%</B></td>'+LF
cWeb += '           	</tr>'+LF
cWeb += "            <tr style='font-size:8.5pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>"+LF
cWeb += "				<td style='font-size:9.0pt;font-family:Verdana;color:black' bgcolor='#E2E9E6' width='660' colspan='11'>"+LF
cWeb += '					<table width="185" height="27" border="1">'+LF
cWeb += '             </table>'+LF
cWeb += '             <br>'+LF
cWeb += '             </p></td>'+LF
cWeb += '			</tr>'+LF
cWeb += '		</table>'+LF
cWeb += '	</div>'+LF
cWeb += '	<div>'+LF
cWeb += '	</div>'+LF
cWeb += '<BR>'+LF
cWeb += '<BR>'+LF
cWeb += '<p><span style="FONT-SIZE: 7pt; COLOR: black; FONT-FAMILY: Verdana">'+LF
cWeb += '<< "FATR034xa.htm" >></span></p>'+LF
cWeb += '</body>'+LF
cWeb += '</html>'+LF

Return(cWeb)
*/