#Include "Topconn.ch"
#Include "Rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include "Tbiconn.ch "

/*
////////////////////////////////////////////////////////////////////////////////////////////
//Programa: ESTR010 - RELATÓRIO DE NOTAS DEVOLVIDAS
//Data    : 25/04/2012
//Autoria : Flávia Rocha
//Chamado : 002435 - de 31/01/2012 - Daniela:
//          Criar relatório de devolução semanal, conforme layout enviado por e-mail.  
//          Nfs dos últimos 30 dias
////////////////////////////////////////////////////////////////////////////////////////////
*/

****************************
User Function ESTR010()
****************************
                                                                                  
Private lDentroSiga := .F. 
Private nLin        := 80 
Private nPag		:= 1
Private cNomeProg   := 'ESTR010'

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	NFDEVS()	//chama a função do relatório
  
Else
  lDentroSiga := .T.
  

	Pergunte("ESTR010",.T.) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório NFs Devolvidas ?")
		RptStatus({|| NFDEVS() },"NFs Devolução")
	Endif


EndIf


Return   

***************************
Static Function NFDEVS()  
***************************

Local aFluxo 	:= {}
Local cWeb		:= "" 
Local cMailTo   := ""
Local cCopia    := ""
Local cDirHTM   := ""
Local cArqHTM   := ""
Local nHandle   := 0 
Local cDir      := ""
Local cArq      := ""
Local nHand     := 0 
Local cCorpo    := ""
Local cAssun    := ""
Local cAnexo    := ""

Private LF		:= CHR(13) + CHR(10)
Private cTitulo	:= ""
cTitulo := "RELATORIO DE NOTAS DEVOLVIDAS - Periodo: " + Dtoc(dDatabase - 7) + " A " + Dtoc(dDatabase)
//cTitulo := "RELATORIO DE NOTAS DEVOLVIDAS - Periodo: 19/05/2014 A 26/05/2014." //retirar
////CRIA O ARQUIVO DO HTML
cDirHTM  := "\Temp\"    
cArqHTM  := "NF_Dev_" + Alltrim(Dtos(dDatabase)) + ".HTM"   
nHandle := fCreate( cDirHTM + cArqHTM, 0 )

If lDentroSiga
	////cria o diretório local, caso não exista
	lDir := ExistDir('C:\TEMP') // Resultado: .F.
	cDir := "C:\TEMP\"
	If !lDir
		//msgbox("cria Dir")
		U_CriaDir( cDir ) 
	Endif
	////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE	  
	cArq  := "NF_Dev_" + Alltrim(Dtos(dDatabase)) + ".HTM"  	
	nHand := fCreate( cDir + cArq, 0 )			    
	If nHand = -1
	     MsgAlert('o arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
Endif


cWeb := ""

aFluxo	:= GeraDados()
cWeb	+= GeraHTM(aFluxo)

///FECHA O HTML PARA ENVIO
cWeb += '</body> '
cWeb += '</html> '
								
//////GRAVA O HTML 
Fwrite( nHandle, cWeb, Len(cWeb) )
FClose( nHandle ) 

If lDentroSiga
	//////GRAVA O HTML 
	Fwrite( nHand, cWeb, Len(cWeb) )
	FClose( nHand )
	
	//////////////////////////////////////
	// Exibe o arquivo HTML no Navegador 
	//////////////////////////////////////
	fAbreHTM(cDir, cArq)
	
	//////SELECIONA O EMAIL DESTINATÁRIO DO USUÁRIO LOGADO NO SIGA
	cCodUser := __CUSERID     
	//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo
			
	PswOrder(1)
	If PswSeek( cCoduser, .T. )
	   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
	   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
	   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
	   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
	Endif
	
	cCopia  := ""
			
	cCorpo  := cTitulo + LF + LF
	cCorpo  += " Este arquivo é melhor visualizado no navegador Mozilla Firefox." + LF + LF
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := cTitulo
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
	
	MsgInfo("Você acaba de Receber um E-mail.")
			
Else 
	cMailTo := "sac@ravaembalagens.com.br"			    
	cMailTo += ";marcelo@ravaembalagens.com.br"			    
	//cMailTo += ";humberto.filho@ravaembalagens.com.br"			    
	//cMailTo += ";orley@ravaembalagens.com.br"
	//cMailTo += ";jaciara@ravaembalagens.com.br"  //desligamento da empresa
	cMailTo += ";logistica@ravaembalagens.com.br"
	cMailTo += ";joao.emanuel@ravaembalagens.com.br"
	
	//cMailTo := ""  //retirar
	//cCopia  := ""  //retirar
	//cCopia  += ";flavia.rocha@ravaembalagens.com.br"  //retirar					
		
	cCorpo  := cTitulo  + LF + LF
	cCorpo  += " Este arquivo é melhor visualizado no navegador Mozilla Firefox." + LF + LF
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := cTitulo
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
	
Endif


***************************************************************
Static Function GeraHTM(aFluxo)
***************************************************************
Local x    := 0
Local cHtm := ""
Local nItem := 1

        
//cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
		////div para quebrar página automaticamente
		cHtm += '<style type="text/css">'+LF
		cHtm += '.quebra_pagina {'+LF
		cHtm += 'page-break-after:always;'+LF
		cHtm += 'font-size:11px;'+LF
		//cHtm += 'font-style:italic;'+LF
		cHtm += 'font-family:Arial;'+LF
		cHtm += '	color:#F00;'+LF
		cHtm += '	padding:5px 0;'+LF
		cHtm += '	text-align:center;'+LF
		cHtm += '}'+LF
		cHtm += 'p {text-align:right;'+LF
		cHtm += '}'+LF
		cHtm += '</style>'+LF 
		
	If nLin > 35
		///CABEÇALHO PÁGINA
		cHtm += f_Cabeca(nPag,dDatabase,cTitulo, "")  
		nLin := 5
		nPag++
		cHtm += '<table width="100%" border="1" style="font-size:11px;font-family:Arial"><strong> ' + LF															
	Endif	
		
	If Len(aFluxo) > 0
		For x:= 1 to Len(aFluxo)
			
			If nLin > 35
			
				cHtm += '</table>'+ LF
				cHtm += '<div class="quebra_pagina"></div>'+LF			   //comando da quebra de página
				
				///CABEÇALHO PÁGINA
				cHtm += f_Cabeca(nPag,dDatabase,cTitulo, "")  
				nLin := 5
				nPag++
				cHtm += '<table width="100%" border="1" style="font-size:11px;font-family:Arial"><strong> ' + LF																		
				//cHtm += fSeparaBloq( nLin, 30, '2' )
				If x <= Len(aFluxo)
					If Alltrim(aFluxo[x,1]) == Alltrim(aFluxo[x - 1,1])				
						///CABEÇALHO RELATÓRIO
						//cHtm += fCabNF( 2 )						
						//nLin++
						cHtm += '<tr>'+LF
						cHtm += '<td width="400" align="center" bgcolor="#C0FFC0"><span class="style3"><B>'+ aFluxo[x,1] + '</span></B></td> ' + LF		
						cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>NF</span></B></td> ' + LF
						cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Exp. NF</span></B></td> ' + LF		
						cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Ocorrencia</span></B></td> ' + LF						
						cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR DEVOLVIDO</span></B></td> ' + LF		
						cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR NF</span></B></td> ' + LF		
						cHtm += '<td width="200" align="center" bgcolor="#C0FFC0"><span class="style3"><B>CLIENTE</span></B></td> ' + LF
						cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>LOCALIDADE</span></B></td> ' + LF	
						cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>REPRESENTANTE</span></B></td> ' + LF					
						cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>RESPONSAVEL</span></B></td> ' + LF					
						cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>TRANSPORTADORA</span></B></td> ' + LF  
						cHtm += '<td width="10" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Item</span></B></td> ' + LF		
						cHtm += '</tr>' + LF
					Endif
				Endif	
								
			Endif
				
			If x = 1
				cHtm += '<tr>'+LF
				cHtm += '<td width="400" align="center" bgcolor="#C0FFC0"><span class="style3"><B>'+ aFluxo[x,1] + '</span></B></td> ' + LF		
				cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>NF</span></B></td> ' + LF
				cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Exp. NF</span></B></td> ' + LF		
				cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Ocorrencia</span></B></td> ' + LF				
				cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR DEVOLVIDO</span></B></td> ' + LF		
				cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR NF</span></B></td> ' + LF		
				cHtm += '<td width="200" align="center" bgcolor="#C0FFC0"><span class="style3"><B>CLIENTE</span></B></td> ' + LF
				cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>LOCALIDADE</span></B></td> ' + LF	
				cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>REPRESENTANTE</span></B></td> ' + LF					
				cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>RESPONSAVEL</span></B></td> ' + LF					
				cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>TRANSPORTADORA</span></B></td> ' + LF  
				cHtm += '<td width="10" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Item</span></B></td> ' + LF		
				cHtm += '</tr>' + LF	
			
			Endif
			If x > 1
				If Alltrim(aFluxo[x,1]) != Alltrim(aFluxo[x - 1,1])
					cHtm += fSeparaBloq( nLin, 20, '2' )   //separa entre os assuntos, com duas linhas em branco
					cHtm += '<tr>'+LF
					cHtm += '<td width="400" align="center" bgcolor="#C0FFC0"><span class="style3"><B>'+ aFluxo[x,1] + '</span></B></td> ' + LF  //obs da ocorrênciao		
					cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>NF</span></B></td> ' + LF
					cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Exp. NF</span></B></td> ' + LF		
					cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Ocorrencia</span></B></td> ' + LF					
					cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR DEVOLVIDO</span></B></td> ' + LF
					cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR NF</span></B></td> ' + LF				
					cHtm += '<td width="200" align="center" bgcolor="#C0FFC0"><span class="style3"><B>CLIENTE</span></B></td> ' + LF
					cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>LOCALIDADE</span></B></td> ' + LF	
					cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>REPRESENTANTE</span></B></td> ' + LF					
					cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>RESPONSAVEL</span></B></td> ' + LF					
					cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>TRANSPORTADORA</span></B></td> ' + LF
					cHtm += '<td width="10" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Item</span></B></td> ' + LF		
					cHtm += '</tr>' + LF	
				Endif
			Endif 
			/*
			Aadd( aFlux, {cMotivo,;        											//1
		              FLUX->F2_DOC,;                                                    //2
		              dTinclu,;                                                			//3
		              FLUX->F2_DTEXP,;                                                  //4
		              nValdev,;                                                //5
		              FLUX->F2_CLIENTE + '/' + FLUX->F2_LOJA + ' - ' + FLUX->A1_NOME,;  //6
		              FLUX->ZZ_DESC,;                                                   //7
		              FLUX->A3_NREDUZ,;                                                 //8
		              cResp,;                                                          	//9
		              FLUX->A4_NREDUZ,;                                                	//10
		              cObs,;															//13
		              FLUX->F2_VALBRUT } )												//14 
		    */
		               
			If x <= Len(aFluxo) //(aDiario)
				cHtm += '<tr>'+LF
				cHtm += '<td width="200"><div align="left"><span class="style3">' + aFluxo[x,11] + '</span></div></td> ' + LF //obs da ocorrência
				cHtm += '<td width="100"><div align="right"><span class="style3">' + aFluxo[x,2] + '</span></div></td> ' + LF //nf 
				cHtm += '<td width="40"><div align="center"><span class="style3">' + Dtoc(aFluxo[x,4]) + '</span></div></td> ' + LF //data expedição               
				//cHtm += '<td width="40"><div align="center"><span class="style3">' + Dtoc( aFluxo[x,11]) + '</span></div></td> ' + LF //data devolução
				//pinta de amarelo a célula da data da ocorrência
				cHtm += '<td width="40" bgcolor="#FFFFC0"><div align="center"><span class="style3">' + Dtoc( aFluxo[x,3]) + '</span></div></td> ' + LF //data ocorrência			
				//cHtm += '<td width="60"><div align="right"><span class="style3">' + Transform( aFluxo[x,5], "@E 999,999,999.99") + '</span></div></td> ' + LF //valor devolvido
				cHtm += '<td width="60"><div align="right"><span class="style3">' + aFluxo[x,5] + '</span></div></td> ' + LF //valor devolvido
				cHtm += '<td width="60"><div align="right"><span class="style3">' + Transform( aFluxo[x,12], "@E 999,999,999.99") + '</span></div></td> ' + LF //valor nf
				cHtm += '<td width="400"><div align="left"><span class="style3">' + aFluxo[x,6] + '</span></div></td> ' + LF //cliente
				cHtm += '<td width="160"><div align="left"><span class="style3">' + aFluxo[x,7] + '</span></div></td> ' + LF //localidade
				cHtm += '<td width="160"><div align="left"><span class="style3">' + aFluxo[x,8] + '</span></div></td> ' + LF //representante
				cHtm += '<td width="100"><div align="left"><span class="style3">' + aFluxo[x,9] + '</span></div></td> ' + LF //responsável
				cHtm += '<td width="100"><div align="left"><span class="style3">' + aFluxo[x,10] + '</span></div></td> ' + LF //transportadora
				cHtm += '<td width="10"><div align="left"><span class="style3">' + Str(nItem) + '</span></div></td> ' + LF //item

		  	Else			  	
				cHtm += '<tr>'+LF
				cHtm += '<td width="200"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="100"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="40"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="40"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="60"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="60"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="400"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="160"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="160"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="100"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="100"><div align="center"><span class="style3"></span></div></td> ' + LF
				cHtm += '<td width="10"><div align="center"><span class="style3"></span></div></td> ' + LF
		    Endif 
		
			///avança linha
			cHtm += '</tr> ' + LF
			//If Len(Alltrim(aFluxo[x,13]) ) <= 80 
			//	nLin++
			//Elseif Len(Alltrim(aFluxo[x,13]) ) <= 95
			//	nLin++                              
				nLin++
			//Else 	
				nLin++
				nLin++
				nLin++
			//Endif
			nItem++
		Next
								   
		cHtm += '</table> ' + LF
		
		cHtm += fRodape(SM0->M0_FILIAL)
	
	Else
		//caso não tenha ocorrências durante o período:
		cHtm += '<tr>'+LF
		cHtm += '<td width="400" align="center" bgcolor="#C0FFC0"><span class="style3"><B>MOTIVO</span></B></td> ' + LF		
		cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>NF</span></B></td> ' + LF
		cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Exp. NF</span></B></td> ' + LF		
		cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Devolucao</span></B></td> ' + LF				
		cHtm += '<td width="40" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Dt. Ocorrencia</span></B></td> ' + LF						
		cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR DEVOLVIDO</span></B></td> ' + LF		
		cHtm += '<td width="60" align="center" bgcolor="#C0FFC0"><span class="style3"><B>VALOR NF</span></B></td> ' + LF		
		cHtm += '<td width="200" align="center" bgcolor="#C0FFC0"><span class="style3"><B>CLIENTE</span></B></td> ' + LF
		cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>LOCALIDADE</span></B></td> ' + LF	
		cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>REPRESENTANTE</span></B></td> ' + LF					
		cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>RESPONSAVEL</span></B></td> ' + LF					
		cHtm += '<td width="100" align="center" bgcolor="#C0FFC0"><span class="style3"><B>TRANSPORTADORA</span></B></td> ' + LF  
		cHtm += '<td width="10" align="center" bgcolor="#C0FFC0"><span class="style3"><B>Item</span></B></td> ' + LF		
		cHtm += '</tr>' + LF
		
		cHtm += '<tr>'+LF
		cHtm += '<td width="100%" colspan="13" align="center" height="30"><span class="style3"><b> NAO EXISTE(M) OCORRENCIA(S) DEVOLUCAO, REGISTRADA(S) NO PERIODO De: ' + Dtoc(dDatabase - 7) + ' a ' + DToc(dDatabase) + '. </b></span></td>'+LF
		cHtm += '</tr>'+LF
		
		cHtm += '</table> ' + LF
		
		cHtm += fRodape(SM0->M0_FILIAL)
	
	Endif

Return(cHtm)

******************************
Static Function GeraDados(cFil, dData)
******************************

Local aFlux    := {}
Local cResp    := "xxx"
Local aOcor    := {}
Local cObs     := ""
Local dTinclu  := CtoD("  /  /    ") 
Local nValdev  := 0
Local cMotivo  := ""


cQuery := " Select " + LF
cQuery += " UC_NFISCAL " + LF
cQuery += " ,UD_N1 ,N1_TIPO = (SELECT ZZ1.Z46_DESCRI FROM Z46020 ZZ1 WHERE ZZ1.Z46_N1 = SUD.UD_N1 AND ZZ1.D_E_L_E_T_ = '' ) " + LF
cQuery += " ,UD_N2 ,N2SETOR = (SELECT ZZ3.Z46_DESCRI FROM Z46020 ZZ3 WHERE ZZ3.Z46_CODIGO = SUD.UD_N2 AND ZZ3.D_E_L_E_T_ = ''  )  " + LF
cQuery += " ,UD_N3 ,N3OCOR = (SELECT ZZ3.Z46_DESCRI FROM Z46020 ZZ3 WHERE ZZ3.Z46_CODIGO = SUD.UD_N3 AND ZZ3.D_E_L_E_T_ = ''  ) " + LF
cQuery += " ,UD_N4 ,N4MOTIVO = ISNULL((SELECT ZZ2.Z46_DESCRI FROM Z46020 ZZ2 WHERE ZZ2.Z46_CODIGO = SUD.UD_N4 AND ZZ2.D_E_L_E_T_ = ''  ), '---') " + LF
cQuery += " ,UD_N5 ,N5MOTIVO = ISNULL((SELECT ZZ2.Z46_DESCRI FROM Z46020 ZZ2 WHERE ZZ2.Z46_CODIGO = SUD.UD_N5 AND ZZ2.D_E_L_E_T_ = ''  ), '---') " + LF
cQuery += " ,UD_OBS ,UD_DTINCLU, UD_HRINCLU, UC_CODIGO, UC_DATA, F2_FILIAL, F2_DOC, F2_SERIE, F2_EMISSAO " + LF
cQuery += " ,F2_DTEXP, F2_VALBRUT, F2_LOCALIZ, F2_VEND1, F2_TRANSP, F2_CLIENTE, F2_LOJA, ZZ_DESC, A3_NREDUZ, A4_NREDUZ, A1_NOME, A3_NREDUZ " + LF
cQuery += " FROM " 
cQuery += " " + RetSqlName("SF2") + " SF2, " + LF
cQuery += " " + RetSqlName("SZZ") + " SZZ, " + LF
cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SUC") + " SUC, " + LF
cQuery += " " + RetSqlName("SUD") + " SUD " + LF

cQuery += " WHERE " + LF
cQuery += " SUD.UD_N1 = '0001' " + LF  //RECLAMAÇÃO
cQuery += " and SUD.UD_N2 = '0002' " + LF   //LOGÍSTICA
cQuery += " and SUD.UD_N3 IN ('0005' ) " + LF     //DEVOLUÇÃO
 
If lDentroSiga
	cQuery += " and UD_DTINCLU >= '" + DtoS(mv_par01) + "' " + LF
	cQuery += " AND UD_DTINCLU <= '" + DtoS(mv_par02) + "' " + LF
	//cQuery += " AND F1_FILIAL = '" + xFilial("SF1") + "' " + LF
	//cQuery += " AND F2_FILIAL = '" + xFilial("SF2") + "' " + LF
Else
	cQuery += " and UD_DTINCLU >=  '" + DtoS(dDatabase - 7) + "' " + LF	
	//cQuery += " and UD_DTINCLU between  '20140519' and '20140526' " + LF //retirar	
Endif
cQuery += " AND F2_SERIE = '0' " + LF
cQuery += " AND F2_TRANSP  = A4_COD " + LF
cQuery += " AND F2_LOCALIZ = ZZ_LOCAL " + LF
cQuery += " AND F2_TRANSP  = ZZ_TRANSP " + LF 
cQuery += " AND F2_CLIENTE = A1_COD " + LF
cQuery += " AND F2_LOJA    = A1_LOJA " + LF
cQuery += " AND F2_VEND1   = A3_COD " + LF
cQuery += " AND UC_FILIAL  = F2_FILIAL " + LF
cQuery += " AND UC_NFISCAL = F2_DOC " + LF
cQuery += " AND UC_SERINF  = F2_SERIE " + LF
cQuery += " AND UD_FILIAL = UC_FILIAL " + LF
cQuery += " AND UD_CODIGO = UC_CODIGO  " + LF

cQuery += " AND SF2.D_E_L_E_T_ = '' " + LF
cQuery += " AND SZZ.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA4.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA3.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SUC.D_E_L_E_T_ = '' " + LF 
cQuery += " AND SUD.D_E_L_E_T_ = '' " + LF
//
cQuery += " AND SZZ.ZZ_FILIAL='"+XFILIAL('SZZ')+"' " + LF
//
cQuery += " Group by " + LF
cQuery += "  UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_HRINCLU, UD_DTINCLU, UC_CODIGO, UC_DATA, UC_NFISCAL, " + LF
cQuery += " F2_FILIAL, F2_DOC, F2_SERIE, F2_EMISSAO, F2_DTEXP, F2_VALBRUT, F2_LOCALIZ, F2_VEND1, F2_TRANSP, " + LF
cQuery += " F2_CLIENTE, F2_LOJA, ZZ_DESC, A3_NREDUZ, A4_NREDUZ, A1_NOME, A3_NREDUZ " + LF

cQuery += " Order by N4MOTIVO, F2_FILIAL, F2_DOC, F2_SERIE , UD_DTINCLU " + LF
MemoWrite("C:\Temp\NFDEV.sql",cQuery)  

If Select("FLUX") > 0
	DbSelectArea("FLUX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "FLUX"
                                        
TcSetField("FLUX" , "F2_EMISSAO" , "D")
TcSetField("FLUX" , "F2_DTEXP" , "D")  
TcSetField("FLUX" , "UD_DTINCLU" , "D")

FLUX->(DbGoTop())
If lDentroSiga
	SetRegua(RecCount())
Endif
cSuper := ""
If !FLUX->(EOF())
	While !FLUX->(EOF()) 
	   	SA3->(DBSETORDER(1))
	   	SA3->(Dbseek(xFilial("SA3") + FLUX->F2_VEND1 ))
	   		cSuper := SA3->A3_SUPER
	   	SA3->(DBSETORDER(1))
	   	SA3->(Dbseek(xFilial("SA3") + cSuper ))
	   		cResp := SA3->A3_NOME
	   	/*	
	   	If Alltrim(SA3->A3_SUPER) =  '0245'	   		
	   		cResp := "Marcos Cunha"
	   	Elseif Alltrim(SA3->A3_SUPER) $  '0229/0244'
	   		cResp := "Isaac Oliveira"           
	   	//Elseif Alltrim(SA3->A3_SUPER) $  '0248'
	   	//	cResp := "Josenildo Araujo"
	   	Elseif Alltrim(SA3->A3_SUPER) =   '0315'
	   		cResp := "Jacqueline Melo"
	   	Elseif Alltrim(SA3->A3_SUPER) =   '0316'
	   		cResp := "Flavio Alves" 
	   	Elseif Alltrim(SA3->A3_SUPER) =   '0320'
	   		cResp := "Flavia Norat" 
	   	Endif
	   	*/
	   	cObs     := ""
		dTinclu  := CtoD("  /  /    ")
		dTinclu  := FLUX->UD_DTINCLU	   
        nValdev := 'Ver OBS'
        cObs    := FLUX->UD_OBS
        cMotivo := FLUX->N4MOTIVO       
        
			Aadd( aFlux, {cMotivo,;        											//1
		              FLUX->F2_DOC,;                                                    //2
		              dTinclu,;                                                			//3
		              FLUX->F2_DTEXP,;                                                  //4
		              nValdev,;                                                //5
		              FLUX->F2_CLIENTE + '/' + FLUX->F2_LOJA + ' - ' + FLUX->A1_NOME,;  //6
		              FLUX->ZZ_DESC,;                                                   //7
		              FLUX->A3_NREDUZ,;                                                 //8
		              cResp,;                                                          	//9
		              FLUX->A4_NREDUZ,;                                                	//10
		              cObs,;															//13
		              FLUX->F2_VALBRUT } )												//14 
		 
	
		FLUX->(DBSKIP())
	Enddo
	
Endif

DbSelectArea("FLUX")
DbcloseArea()
//aFlux := Asort( aFlux,,, { |X,Y| Dtoc(X[3]) + X[2] <  Dtoc(Y[3]) + Y[2] } )
Return(aFlux) 


**************************************
Static Function fAbreHTM(cDir, cArq)  
**************************************

//Tenta com o MOZILLA COMUM
If WinExec("C:\Arquivos de programas\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
	///Se não conseguir, tenta com Mozilla (para Dell)
	If WinExec("C:\Program Files (x86)\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
		//Se não conseguir, tenta com Internet Explorer	
		If WinExec("C:\arquiv~1\intern~1\iexplore.exe " + cDir + cArq) <> 0						
				
			MsgBox("Não foi possível Abrir o Relatório Automaticamente."+Chr(13)+;
			"Por Favor, Verifique seu e-mail, o relatório estará anexado."+Chr(13)+Chr(13)+;
			"", "Atenção")	
	        ///se não conseguir abrir nenhum, irá avisar que o arquivo chegou anexado por email
		EndIf
	Endif
EndIf

Return


************************************
Static Function f_Cabeca(nPag,dDTREF,ctitulo, cFiltro) 
************************************

Local cCabeca := "" 
Local cEmpresa:= ""



cEmpresa := "Rava Embalagens - " + SM0->M0_FILIAL

///Cabeçalho PÁGINA
cCabeca += '<html>'+LF
cCabeca += '<head>'+ LF
cCabeca += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
cCabeca += '<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="100%">'+ LF
cCabeca += '<tr>    <td>'+ LF
cCabeca += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
cCabeca += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
cCabeca += '<tr>        <td>SIGA /' + cNomeProg + '/v.P10</td>'+ LF
cCabeca += '<td align="center">' + ctitulo + '</td>'+ LF
cCabeca += '<td align="right">DT.Ref.: '+ Dtoc(dDTREF) + '</td></tr>'+ LF

cCabeca += '<tr>        <td></td>'+ LF
//cCabeca += '<td align="center">' + cFiltro + '</td></tr>'+ LF
//cCabeca += '<td align="right">DT.Ref.: '+ Dtoc(dDTREF) + '</td></tr>'+ LF

cCabeca += '<tr>          '+ LF
cCabeca += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
cCabeca += '<td align="right">Emissao: '+ Dtoc(Date()) + '</tr>'+ LF
cCabeca += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
cCabeca += '</table></head>'+ LF            

Return(cCabeca)

*****************************					
Static Function fRodape(cEmpresa) 
*****************************

Local cTexto := ""


cTexto := '<br> ' + LF
cTexto += '<br> ' + LF
cTexto += '<br> ' + LF
cTexto += '<br> ' + LF
cTexto += '<table bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0" width="100%"> ' + LF
cTexto += '<tbody><tr>    <td> ' + LF
cTexto += '<table style="font-size: 11px; font-family: Arial;" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0" width="90%"> ' + LF
cTexto += '<tbody><tr>    <td colspan="3"><hr color="#000000" noshade="noshade" size="2"></td>        </tr> ' + LF
cTexto += '<tr>          <td>' + cEmpresa + '</td>  <td></td> ' + LF
cTexto += '<td align="right">Fim da impressao ' + Time() + '</td> ' + LF
cTexto += '</tr> ' + LF
cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade="noshade" size="2"></td>        </tr><tr> ' + LF
cTexto += '</tr></tbody></table> ' + LF


Return(cTexto)


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
		conout("E-mail nao enviado")
		conout(Replicate("*",60))
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


*******************************
Static Function fCabNF( nTipo)
******************************
Local cHtm := ""

If nTipo = 2  //nova tabela (quando muda a página)
	cHtm += '<table width="100%" border="1" style="font-size:11px;font-family:Arial"><strong> ' + LF	
Endif

//MOTIVO	NF DATA	EMISSAO  DATA EXPEDIÇÃO   VALOR	CLIENTE	LOCALIDADE	REPRESENT.	RESPONS.	TRANSP.
cHtm += '<tr>' + LF
cHtm += '<td width="10" align="center"><span class="style3"><B>ITEM</span></B></td> ' + LF		
cHtm += '<td width="400" align="center"><span class="style3"><B>MOTIVO</span></B></td> ' + LF		
cHtm += '<td width="100" align="center"><span class="style3"><B>NF</span></B></td> ' + LF		
cHtm += '<td width="40" align="center"><span class="style3"><B>DATA ENTRADA/Devolucao</span></B></td> ' + LF		
cHtm += '<td width="40" align="center"><span class="style3"><B>DATA EMISSAO</span></B></td> ' + LF		
cHtm += '<td width="40" align="center"><span class="style3"><B>DATA EXPEDICAO</span></B></td> ' + LF		
cHtm += '<td width="40" align="center"><span class="style3"><B>VALOR</span></B></td> ' + LF		
cHtm += '<td width="200" align="center"><span class="style3"><B>CLIENTE</span></B></td> ' + LF
cHtm += '<td width="100" align="center"><span class="style3"><B>LOCALIDADE</span></B></td> ' + LF	
cHtm += '<td width="100" align="center"><span class="style3"><B>REPRESENTANTE</span></B></td> ' + LF					
cHtm += '<td width="100" align="center"><span class="style3"><B>RESPONSAVEL</span></B></td> ' + LF					
cHtm += '<td width="100" align="center"><span class="style3"><B>TRANSPORTADORA</span></B></td> ' + LF					
cHtm += '</tr>' + LF
Return(cHtm)


******************************
Static Function fSeparaBloq( nLin, numsep, cmodo ) 
******************************

Local cHtm := ""
Local nDivide := 10
Local nqtas   := numsep / nDivide
Local x		  := 0
//separa blocos

If cmodo = '1'		//início
	////linha em branco
	cHtm += '<tr>'+LF
	cHtm += '<td width="100%" colspan="13" height="' + Alltrim(str(numsep)) + '"><span class="style3"><b></span></td>'+LF
	cHtm += '</tr>'+LF
	For x := 1 to nqtas 
		nLin++
	Next
	
Elseif cmodo = '2'  //meio
	////linha em branco
	cHtm += '<tr>'+LF
	cHtm += '<td width="100%" colspan="12" height="' + Alltrim(str(numsep)) + '"><span class="style3"><b></span></td>'+LF
	cHtm += '</tr>'+LF
	For x := 1 to nqtas 
		nLin++
	Next
Endif

Return(cHtm)

****************************************
Static Function TrazOco(cFil, cNota) 
****************************************


Local aOc := {}
Local cQuery := ""

cQuery := " SELECT TOP 1 UD_CODIGO, UD_ITEM, UD_DTINCLU,UC_NFISCAL,UD_N3,Z46_DESCRI, UD_OBS " + LF
cQuery += " FROM "  + LF
cQuery += " " + RetSqlName("SUD") + " SUD, " + LF
cQuery += " " + RetSqlName("SUC") + " SUC, " + LF
cQuery += " " + RetSqlName("Z46") + " Z46  " + LF
cQuery += "WHERE UC_NFISCAL = '" + Alltrim(cNota) + "' " + LF 
cQuery += " AND UC_FILIAL = '" + Alltrim(cFil) + "' " + LF
cQuery += "AND UC_FILIAL = UD_FILIAL " + LF
cQuery += "AND UC_CODIGO = UD_CODIGO " + LF
cQuery += "AND SUC.D_E_L_E_T_ = '' " + LF
cQuery += "AND SUD.D_E_L_E_T_ = '' " + LF
cQuery += "AND Z46.D_E_L_E_T_ = '' " + LF
//cQuery += "and UD_N3 = '0005' " + LF  
cQuery += " AND Z46.Z46_DESCRI LIKE 'DEVOLUCAO' " + LF
cQuery += "AND UD_N3 = Z46_CODIGO " + LF 
cQuery += "ORDER BY UD_DTINCLU " + LF
MemoWrite("C:\Temp\ocorrenc.sql" , cQuery )
If Select("FLUX1") > 0
	DbSelectArea("FLUX1")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "FLUX1"
                                        
TcSetField("FLUX1" , "UD_DTINCLU" , "D")

FLUX1->(DbGoTop())

If !FLUX1->(EOF())
	While !FLUX1->(EOF()) 
	    Aadd( aOc , { FLUX1->UD_CODIGO, FLUX1->UD_ITEM, FLUX1->UD_DTINCLU, FLUX1->UC_NFISCAL, FLUX1->UD_N3, FLUX1->Z46_DESCRI, FLUX1->UD_OBS} )
		FLUX1->(DBSKIP())
	Enddo
Endif
DbSelectArea("FLUX1")
DbCloseArea()

Return(aOc)