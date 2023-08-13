#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR022-01
//Objetivo: Relatório 01.1 - Resumo da Movimentação de Clientes (por Coordenador)
//			
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 09/12/2010
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR022_11()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f22_01()	//chama a função do relatório
  
Else
  //conOut( "Programa WFFAT006 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  lDentroSiga := .T.
  f22_01()
  
EndIf
  

Return

**********************
Static Function f22_01()
**********************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. 1.1 - Resumo da Movimentação de Clientes por Coordenador"
Local cPict          := ""
Local titulo         := "" 

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local Texto			 := ""
Local imprime        := .T.
Local aOrd := {}

Local cCodUser		 := ""

Local dDTPar		 := Ctod("  /  /    ")
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR022_01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR022_01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "" //"FTR012"
Private cString := ""

Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 
Private nLinhas		:= 80


titulo := "Relatorio 1.1 - "
titulo += "RESUMO DA MOVIMENTACAO DE CLIENTES (POR COORDENADOR)"



If lDentroSiga


    If MsgYesNo("Deseja Gerar o Rel. 1.1 ? ")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLinhas) },Titulo)      
	Endif

Else
	//se for pelo Schedule
	RunReport(Cabec1,Cabec2,Titulo,nLinhas)

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


Local cQuery:=''
Local cSuper:= ""
Local cNomeSuper:= ""
Local cMailSuper:= ""
Local cMailGeren:= ""
Local aDados	:= {}
Local nCtaNovo  := 0
Local nCtaSubiu := 0
Local nCtaDesceu:= 0
Local nSaldo	:= 0
Local nRegTot	:= 0
Local aResult	:= {}
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local frX	  := 0
Local cCopia  := ""

///QUERY
cQuery := "Select A3_COD, A3_NREDUZ, A3_SUPER, A3_GEREN, A3_EMAIL " + LF
cQuery += " FROM " + RetSqlName("SA3") + " SA3 " + LF
cQuery += " WHERE A3_GEREN <> '' " + LF
cQuery +=  " AND A3_COD NOT IN ('0018', '0256') " + LF

//cQuery += " AND RTRIM(A3_COD) = '0255' " + LF	///RETIRAR DEPOIS

cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' " + LF
//MemoWrite("C:\Temp\fatr022_1.1.sql",cQuery)
If Select("RESU") > 0
	DbSelectArea("RESU")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "RESU"			
RESU->( DbGoTop() )			
If !RESU->(EOF())
	While RESU->( !EOF() )
		
		cSuper := RESU->A3_COD			
		cNomeSuper  := Alltrim(RESU->A3_NREDUZ)
		cMailSuper  := Alltrim(RESU->A3_EMAIL) 
		SA3->(Dbsetorder(1))
		SA3->(Dbseek(xFilial("SA3") + RESU->A3_GEREN ))
		//exemplo do calcEst
		//aSaldos:=CalcEst(SB1->B1_COD,SB1->B1_LOCPAD, dDataBase)
		//nQuant:=aSaldos[1]

		////Verifica QTOS CLIENTES NOVOS
		aResult := fNovo_Reat(cSuper)     ///faz o cálculo de qtos clientes novos e reativados
		
		nCtaNovo:= aResult[1]
			
		////verifica qtos clientes foram REATIVADOS
		nCtaSubiu := aResult[2]
				
		////verifica qtos clientes foram INATIVADOS
		nCtaDesceu := aResult[3] //fInativo( cSuper )
				
		nSaldo	:= ( (nCtaNovo + nCtaSubiu) - nCtaDesceu )  
		
		Aadd(aDados, { cSuper,;		//1
					cNomeSuper,;   	//2
					nCtaNovo,;     	//3
					nCtaSubiu,;    	//4
					nCtaDesceu,;   	//5
					nSaldo,;     	//6
					cMailSuper } )  //7
				 
		nRegTot++ 
		RESU->(DBSKIP())
	
	Enddo
Endif


If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif


nPag   := 1
cTexto := ""
			
//////////////////
/////CRIA O HTML
/////////////////
cDirHTM  := "\Temp\"    
cArqHTM  := "REL_1.1.HTM"    //relatório P/ Gerentes
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1    
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif		
		
nPag := 1
nLinhas := 80
cSuper := ""
			
cTexto := ""
cTexto += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
////div para quebrar página automaticamente
cTexto += '<style type="text/css">'+LF
cTexto += '.quebra_pagina {'+LF
cTexto += 'page-break-after:always;'+LF
cTexto += 'font-size:10px;'+LF
cTexto += 'font-style:italic;'+LF
cTexto += '	color:#F00;'+LF
cTexto += '	padding:5px 0;'+LF
cTexto += '	text-align:center;'+LF
cTexto += '}'+LF
cTexto += 'p {text-align:right;'+LF
cTexto += '}'+LF
cTexto += '</style>'+LF
//////////	
								

	///Cabeçalho PÁGINA
	cTexto += '<html><head>'+ LF
	cTexto += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
	cTexto += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
	cTexto += '<tr>    <td>'+ LF
	cTexto += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
	///linha fina
	cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
	cTexto += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				
	cTexto += '<tr>' + LF
	cTexto += '<td>SIGA /FATR022-01/v.P10</td>'+ LF
	cTexto += '<td align="LEFT">' + titulo + '</td>'+ LF
	cTexto += '<td align="right">DT.Ref.: ' + Dtoc(dDatabase) + '</td>'+ LF
	cTexto += '</tr>'+LF
					
	cTexto += '<tr>'+ LF
	cTexto += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
	cTexto += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+LF
					
	///linha fina
	cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
	cTexto += '</table></head>'+ LF 
						     
						
	///Cabeçalho RESUMO		      
	cTexto += '<table width="1000" border="1" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<td width="210" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>RESUMO DA MOVIMENTACAO</span></div></B></td>'+ LF
	cTexto += '</tr></table>' + LF
		
	cTexto += '<table width="1000" border="1" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<td width="210"><span class="style3"><b>COORDENADOR</b></span></td>'+LF   
	
	cTexto += '<td width="210"><span class="style3" align="center"><b>CLIENTES NOVOS</b></span></td>'+LF   
	cTexto += '<td width="210"><span class="style3" align="center"><b>REATIVADOS</b></span></td>'+LF   
	cTexto += '<td width="210"><span class="style3" align="center"><b>INATIVADOS</b></span></td>'+LF   
	cTexto += '<td width="210"><span class="style3" align="center"><b>SALDO</b></span></td>'+LF   
	
	cTexto += '</tr>' + LF
	For frX := 1 to Len(aDados)

			/////////////////
			cTexto += '<tr>' + LF
			cTexto += '<td width="200" align="left"><span class="style3">' + aDados[frX,2]  + '</span></td>'+LF 	//nome do coordenador
			cTexto += '<td width="100" align="left"><span class="style3">' + Transform( aDados[frX,3], "@E 9,999")  + '</span></td>'+LF 	//novos
			cTexto += '<td width="100" align="left"><span class="style3">' + Transform( aDados[frX,4], "@E 9,999")  + '</span></td>'+LF	//reativados
			cTexto += '<td width="100" align="left"><span class="style3">' + Transform( aDados[frX,5], "@E 9,999")  + '</span></td>'+LF    //inativados
			cTexto += '<td width="100" align="left"><span class="style3">' + Transform( aDados[frX,6], "@E 9,999")  + '</span></td>'+LF 	//saldo
			cTexto += '</tr>'+LF
			//frX++
		//Enddo
		
		If lDentroSiga
			IncRegua()	
		Endif 
	
	//Enddo
	Next
	
	cTexto += '</table>' + LF 
	
        
////linha em branco
cTexto += '<tr>'+LF
cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
cTexto += '</tr>'+LF
			
////linha em branco
cTexto += '<tr>'+LF
cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
cTexto += '</tr>'+LF
			
////linha em branco
cTexto += '<tr>'+LF
cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
cTexto += '</tr>'+LF
			
////linha em branco
cTexto += '<tr>'+LF
cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
cTexto += '</tr>'+LF
			
///faz o rodapé
cTexto += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
cTexto += '    <tr>'+LF
cTexto += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
cTexto += '    </tr>'+LF
cTexto += '    <tr>'+LF
cTexto += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
cTexto += '      <td id="colArial">&nbsp;</td>'+LF
cTexto += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
cTexto += '    </tr>'+LF
cTexto += '    <tr>'+LF
cTexto += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
cTexto += '    </tr>'+LF
cTexto += '  </table>'+LF  
			
			
/////FECHA O HTML PARA GRAVAÇÃO E ENVIO
cTexto += '</body> '
cTexto += '</html> '
/////GRAVA O HTML
Fwrite( nHandle, cTexto, Len(cTexto) )
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
				
Else
	cMailTo := "marcos@ravaembalagens.com.br"
	//cMailTo := "flavia.rocha@ravaembalagens.com.br"  
	cCopia  := "flavia.rocha@ravaembalagens.com.br"  
Endif
			
cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
			
//////ENVIA O HTML COMO ANEXO			
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo )
						
If lDentroSiga
	MsgInfo("Rel 1.1 - Você recebeu um e-mail deste Relatório.")
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lDentroSiga
	// Habilitar somente para Schedule
	Reset environment
Endif


Return
        


////VER SE O CLIENTE É NOVO e se foi REATIVADO ( 2 VERIFICAÇÕES EM 1)
**********************************************
Static Function fNovo_Reat(cSuper)  
***********************************************

Local cCli := ""
Local cLj  := ""
Local nQtas:= 0
Local cCliAnt := ""
Local cLjAnt  := ""
Local cQuery  := ""
Local dUltima := Ctod("  /  /    ")
Local dPenultima := Ctod("  /  /    ") 
Local nNovo	:= 0
Local nReat := 0 
Local nInat := 0
Local aResultado := {}
Local nMes
Local dData1	:= Ctod("  /  /    ")
Local dData2	:= Ctod("  /  /    ")
/*
nMes	:= Month(dDatabase)
If !lDentroSiga
	If nMes = 01
		dData1 := Ctod("01/" + Strzero(nMes + 11) + "/" + Strzero(Year(dDatabase) - 1,4) )
	Else
		dData1 := Ctod("01/" + Strzero(nMes - 1) + "/" + Strzero(Year(dDatabase),4) ) 
	Endif
	dData2 := LastDay(dData1)
Else
	dData1 := FirstDay(dDatabase)
	dData2 := LastDay(dDatabase)

Endif
*/
cQuery  := "Select A1_COD, A1_LOJA, A1_ULTCOM, A1_VEND " + LF //, B1_SETOR, F2_DOC, F2_SERIE, F2_EMISSAO,A3_COD,A3_SUPER " + LF 
cQuery += " ,A3_SUPER,A3_COD " + LF

cQuery += " FROM " 
cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
			
cQuery += " WHERE " + LF
		
cQuery += " RTRIM( A1_VEND ) = RTRIM(A3_COD) " + LF
//cQuery += " AND ( RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' OR RTRIM(A3_COD) = '" + Alltrim(cSuper) + "' ) "+LF
cQuery += " AND  RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' "+LF

cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 121) + "' " + LF // and A1_ULTCOM <= '" + DtoS(dData2) + "' "+ LF			
////VER A ÚLTIMA COMPRA SE FOI NO MÊS ATUAL, SE SIM, AVALIAR SE FOI A PRIMEIRA, SE SIM, É NOVO

cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
				
cQuery += " GROUP BY A1_COD, A1_LOJA, A3_COD, A3_SUPER, A1_ULTCOM,A1_VEND " + LF 
//cQuery += " HAVING COUNT(F2_CLIENTE+F2_LOJA) = 1 " + LF
cQuery += " ORDER BY A1_ULTCOM, A1_COD, A1_LOJA " + LF 

//Memowrite("C:\Temp\novo_reat.sql",cQuery)
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "SF2A"
TcSetField("SF2A", "A1_ULTCOM", "D")

SF2A->( DBGoTop() )
While SF2A->( !EOF() )

	cCli := SF2A->A1_COD
	cLj	 := SF2A->A1_LOJA 
	dUltima := Ctod("  /  /    ")
	dPenultima := Ctod("  /  /    ")
	nQtas:= 0
	    
	If !Empty(SF2A->A1_ULTCOM)
	    
	   	cQuery  := "Select TOP 2 F2_CLIENTE, F2_LOJA, F2_EMISSAO " + LF //, B1_SETOR, F2_DOC, F2_SERIE, F2_EMISSAO,A3_COD,A3_SUPER " + LF 
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " "+ RetSqlName("SD2") + " SD2, " + LF
		cQuery += " "+ RetSqlName("SF4") + " SF4 " + LF		
		cQuery += " WHERE " + LF
		cQuery += " RTRIM(D2_DOC+D2_SERIE) = RTRIM(F2_DOC+F2_SERIE) "+ LF
		cQuery += " AND RTRIM(D2_TES) = RTRIM(F4_CODIGO) "+ LF
		cQuery += " AND RTRIM(F4_DUPLIC) = 'S' " + LF
		cQuery += " AND RTRIM(F2_CLIENTE)  = '" + Alltrim(cCli) + "' " +LF  
		cQuery += " AND RTRIM(F2_LOJA) = '" + Alltrim(cLj) + "' "+LF
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
		cQuery += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"+ LF
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
		cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,F2_EMISSAO " + LF
		cQuery += " ORDER BY F2_EMISSAO DESC " + LF
		//MemoWrite("C:\Temp\novo_reat2.sql",cQuery) 
		If Select("TSF2") > 0
			DbSelectArea("TSF2")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "TSF2"
		TcSetField("TSF2", "F2_EMISSAO", "D")
		TSF2->( DBGoTop() )
	
	    If TSF2->( !EOF() )						    	    	     	    	
	    	dUltima := TSF2->F2_EMISSAO	  //dUComp2 -> última compra					                 
		Endif 
	
		TSF2->( DBGoTop() )
		While TSF2->( !EOF() )
						    
		    dPenultima := TSF2->F2_EMISSAO	  //dUComp  -> penúltima compra
			DbSelectArea("TSF2")
			nQtas++
			TSF2->(DBSKIP())
			
		Enddo
		
		If nQtas = 1
			If !Empty(dUltima)
				If (dDatabase - dUltima) <= 30
					nNovo++
				Endif
			Endif
			dPenultima := Ctod("  /  /    ")
		Endif
		
		////verifica se foi reativado	
		If !Empty(dUltima) .and. !Empty(dPenultima)		
			If (dUltima - dPenultima) >= 91         //se sim, verifica a diferença entre a última compra e a penúltima é maior q 3 meses?					
			    nReat++		
			Endif
		Endif
		
		If !Empty(dUltima)
			If ( (dDatabase - dUltima) >= 91 .and. (dDatabase - dUltima) <= 121 )
				nInat++
			Endif
		Endif
				
		
	Endif  //if do a1_ultcom vazio			
			
		DbSelectArea("SF2A")
		SF2A->(DBSKIP())
Enddo

	//Aadd(aResultado, { nNovo, nReat } )     	

Return( { nNovo, nReat, nInat } )

**********************************************
Static Function fInativo(cSuper)  
***********************************************

Local cCli := ""
Local cLj  := ""
Local nQtas:= 0
Local cCliAnt := ""
Local cLjAnt  := ""
Local cQuery  := ""
Local dUltima := Ctod("  /  /    ")
Local dPenultima := Ctod("  /  /    ") 
Local nNovo	:= 0
Local nReat := 0 
Local nInat := 0
Local aResultado := {}
Local dData1	:= Ctod("  /  /    ")
Local dData2	:= Ctod("  /  /    ")
Local nMes


cQuery  := "Select count(A1_COD+A1_LOJA) AS QTINAT " + LF 

cQuery += " FROM " 
cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
			
cQuery += " WHERE " + LF
		
cQuery += " RTRIM( A1_VEND ) = RTRIM(A3_COD) " + LF
cQuery += " AND RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' "+LF
//cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 120) + "' and A1_ULTCOM <= '" + DtoS(dDatabase - 91) + "' "+ LF			
cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 121) + "' and A1_ULTCOM <= '" + DtoS(dDatabase - 92) + "' "+ LF			
////VER A ÚLTIMA COMPRA SE FOI NO MÊS ATUAL, SE SIM, AVALIAR SE FOI A PRIMEIRA, SE SIM, É NOVO

cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
				
cQuery += " GROUP BY (A1_COD+A1_LOJA) " + LF //, A3_COD , A3_SUPER, A1_ULTCOM " + LF 
//Memowrite("C:\Temp\INATsuper.sql",cQuery)
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "SF2A"
//TcSetField("SF2A", "A1_ULTCOM", "D")

SF2A->( DBGoTop() )
While SF2A->( !EOF() )
	///verifica se foi inativado		
	nInat += SF2A->QTINAT		
	DbSelectArea("SF2A")
	SF2A->(DBSKIP())
Enddo


Return( nInat )          





/////////////////////////////////////////////////////////////
