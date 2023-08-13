//GP010FIMPE - Gravação de Todos os Dados ( )  

#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: GP010FIMPE - Ponto de entrada após a gravação do funcionário
//Objetivo: Imprimir automaticamente os documentos associados à inclusão de novo funcionário
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 02/02/12
//Chamado : 002234 - Michele
//------------------------------------------------------------------------------------
/*/


********************************
User Function GP010FIMPE()
********************************


Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local cMat      := SRA->RA_MAT
Local cNomeFun  := SRA->RA_NOME
Local dDataNasc := SRA->RA_NASC
Local cEndereco := SRA->RA_ENDEREC 
Local cComplem  := SRA->RA_COMPLEM               
Local cBairro   := SRA->RA_BAIRRO
Local cCidade   := SRA->RA_MUNICIP
Local cUF       := SRA->RA_ESTADO
Local cCarteira := SRA->RA_NUMCP
Local cSerie    := SRA->RA_SERCP
Local nSalario  := SRA->RA_SALARIO
Local cCPF      := SRA->RA_CIC
Local cNaciona  := SRA->RA_NACIONA
Local cGenero   := SRA->RA_SEXO 
Local cRG       := SRA->RA_RG
Local cMae      := SRA->RA_MAE
Local cMunNat   := SRA->RA_MUNNAT  //MUNICÍPIO NASCIMENTO
Local cUFNat    := SRA->RA_NATURAL   // UF NASCIMENTO
Local cCodNAC   := SRA->RA_NACIONA // CÓDIGO DA NACIONALIDADE
Local cUFCTPS   := SRA->RA_UFCP    //UF da CTPS
Local cUFRG     := SRA->RA_RGUF      //UF DO RG 
Local cTitElei  := SRA->RA_TITULOE   //TITULO DE ELEITOR
Local dDTRG     := SRA->RA_DTRGEXP   //DT EMISSÃO RG
Local cNacional := ""
Local cFuncao   := ""
Local cDataExtenso := ""
Local aUsu      := {}
Local cUsu      := ""
Local cNomeUsr  := ""
Local cEmailUsr := ""
Local cDeptoUsr := ""
Local aDados    := {}
Local chtm      := ""
Local cweblocal := ""
Local cCopia    := ""
Local cCorpo    := ""
Local cAssun    := ""
Local cMailTo   := "" 
Local cDir      := ""
Local cArq1      := ""
Local cArq2      := ""
Local cArq3      := ""
Local cArq4      := ""
Local nHand		:= 0  
Local cDirHTM   := ""
Local cArqHTM   := ""
Local nHandle	:= 0


Local cCodFunc  := SRA->RA_CODFUNC

//mv_par01 = 1 - Contrato Experiência
//mv_par01 = 2 - Aditivo ao Contrato Trabalho
//mv_par01 = 3 - PIS (pendente)
//mv_par01 = 4 - Declaração do VT
//mv_par01 = 5 - Termo de Responsabilidade

If Inclui
//If Altera
	///CAPTURA O EMAIL DO OPERADOR DO SISTEMA
	PswOrder(1)
	If PswSeek( __CUSERID , .T. )  
	   aUsu   := PSWRET() 				
	   cUsu   := Alltrim( aUsu[1][2] )  
	   cNomeUsr:= Alltrim( aUsu[1][4] )  
	   cEmailUsr:= Alltrim( aUsu[1][14] )
	   cDeptoUsr:= Alltrim( aUsu[1][12] )
	Endif
	cNacional:= Posicione( "SX5", 1, xFilial("SX5") + "34" + cNaciona, "X5_DESCRI" )  
	cFuncao  := Posicione( "SRJ", 1, xFilial("SRJ") + cCodFunc       , "RJ_DESC" ) 
	cDataExtenso := alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) )
	Aadd( aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco, cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso, cMat, cCPF, cGenero,;
	cRG , cMae, cMunNat, cUFNat, cCodNAC, cUFCTPS, cUFRG, cTitElei, cComplem , dDTRG } )	
 	
	/*
	opções:
	1 - contrato experiência
	2 - aditivo ao contrato de trabalho
	3 - PIS
	4 - declaração do vale transporte
	5 - Termo de responsabilidade	
	*/
	
	///CONTRATO DE EXPERIÊNCIA	p/ envio do email
	cDirHTM  := "\Temp\"    
	cArqHTM  := "Contrato_EXP_" + cMat + ".html"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
	If nHandle = -1     //testa a criação do html
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
		
	cAssun  := "Contrato Experiencia - Func.: " + cNomeFun 	
	chtm     := U_RH_HTM( aDados , 1 ) //GeraHTM( aDados , 1 )
		
	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle ) 
	
	cMailTo := cEmailUsr		
	cCopia  := ""					
	cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
	//////////////////////////////////////////////////////////////////////////	
	///ADITIVO AO CONTRATO DE TRABALHO
	//////////////////////////////////////////////////////////////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "Aditivo_Contr_" + cMat + ".html"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
	If nHandle = -1
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
		
	cAssun  := "Aditivo ao Contrato de Trabalho - Func.: " + cNomeFun 
	chtm    := ""
	chtm    := U_RH_HTM( aDados , 2 ) //GeraHTM( aDados , 2 )
	
	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle )
		
	cMailTo := cEmailUsr		
	cCopia  := ""					
	cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
	
	////////////////////////////////////////////////////////////////////////////////////////////	
	/// DOCTO PIS	p/ envio do email 
	///////////////////////////////////////////////////////////////////////////////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "PIS_" + cMat + ".html"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
	If nHandle = -1     //testa a criação do html
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
		
	cAssun  := "PIS - Func.: " + cNomeFun 	
	chtm     := U_RH_HTM( aDados , 3 ) 
		
	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle ) 
	
	cMailTo := cEmailUsr		
	cCopia  := ""					
	cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
	
	////////////////////////////////////////////////////////////////////////////////////////////	
	///DECLARAÇÃO DO VALE-TRANSPORTE	p/ envio do email 
	////////////////////////////////////////////////////////////////////////////////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "Decl-VT_" + cMat + ".html"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
	If nHandle = -1     //testa a criação do html
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
		
	cAssun  := "Declaração do Vale-Transporte - Func.: " + cNomeFun 	
	chtm     := U_RH_HTM( aDados , 4 ) 
		
	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle ) 
	
	cMailTo := cEmailUsr		
	cCopia  := ""					
	cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
	
	////////////////////////////////////////////////////////////////////////////////////////////	
	///TERMO DE RESPONSABILIDADE	p/ envio do email        
	////////////////////////////////////////////////////////////////////////////////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "Termo_Resp_" + cMat + ".html"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
	If nHandle = -1     //testa a criação do html
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
		
	cAssun  := "Termo de Responsabilidade - Func.: " + cNomeFun 	
	chtm     := U_RH_HTM( aDados , 5 ) 
		
	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle ) 
	
	cMailTo := cEmailUsr		
	cCopia  := ""					
	cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
	
	
	
Endif

Return




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