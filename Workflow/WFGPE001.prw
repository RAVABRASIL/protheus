#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFGPE001                               บ Data ณ  10/11/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Marca็๕es do Ponto por Funcionแrio            บฑฑ
ฑฑบAutoria   ณ Flแvia Rocha                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Solicitado pelo chamado 002341 - Michele                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
                                                                                                          							

/*
Solicitado no chamado 002341:
Configurar sistema para no dia 28 de cada m๊s,
enviar email de alerta para o DP e Ger. RH, se tiver algum funcionแrio sem PIS.  
*/

***************************
User Function WFGPE001()
***************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFGPE001"
  sleep( 5000 )
  conOut( "Programa WFGPE001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  Reset Environment
  
Else
  Exec()
EndIf

Return

***********************
Static Function Exec()
***********************

Local cEMAILRH		:= Getmv("RV_RHEMAIL")
Local cEMAILGERH    := Getmv("RV_GERRH")
Local cQuery	:=' '
Local LF 		:= CHR(13) + CHR(10)
Local eEmail	:= ""
Local cEmpresa  := ""
Local cNomeFil  := ""   
Local cMat		:= ""
Local cTurno	:= ""
Local cNome		:= "" 
Local cHtm		:= "" 
Local cDirHTM   := ""    
Local cArqHTM   := ""   
Local nHandle   := 0
Local cCodFil   := "" 
Local cFuncao	:= ""

cQuery:=" SELECT  " + LF 

cQuery += " SRA.RA_SITFOLH, SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF
cQuery += " ,SRA.RA_CIC, SRA.RA_RG, SRA.RA_PIS, SRJ.RJ_FUNCAO, SRJ.RJ_DESC " + LF
cQuery += " From " + LF
cQuery += " " + RetSqlName("SR6") + " SR6, " + LF
cQuery += " " + RetSqlName("SRJ") + " SRJ, " + LF
cQuery += " " + RetSqlName("SRA") + " SRA " + LF

cQuery += " WHERE " + LF
cQuery += " SRA.RA_PIS = '' " + LF     //CAMPO PIS EM BRANCO
cQuery += " AND SRA.RA_SITFOLH <> 'D' " + LF      //NรO DEMITIDOS
cQuery += " AND SRA.RA_TNOTRAB = SR6.R6_TURNO  " + LF
cQuery += " AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO " + LF
 

cQuery += " AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SR6.D_E_L_E_T_ = '' " + LF

cQuery += " GROUP BY
cQuery += " SRA.RA_SITFOLH, SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF
cQuery += " ,SRA.RA_CIC, SRA.RA_RG, SRA.RA_PIS, SRJ.RJ_FUNCAO, SRJ.RJ_DESC " + LF
cQuery += " ORDER BY SRA.RA_FILIAL, SRA.RA_MAT " + LF

//MemoWrite("C:\Temp\WFGPE001.SQL",cQuery)

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUUX"

AUUX->(DbGoTop())

cCodFil	:= SM0->M0_CODFIL

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava - " + SM0->M0_FILIAL
Endif

cHtm := ""
If !AUUX->(EOF())
 

	////CRIA O HTM 
   	cDirHTM  := "\TEMP\"    
	cArqHTM  := "FUNC_SEM_PIS.HTM"   
			
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
	If nHandle = -1
	     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
    
	///cabe็alho
	cHtm += fCabeca(dDatabase, "Funcionแrios Cadastrados sem PIS")
	
	
	AUUX->(DbGoTop())
	Do while !AUUX->(EOF()) 
	
		cFilemp     := AUUX->RA_FILIAL
		SM0->(Dbsetorder(1))
		If SM0->(Dbseek(SM0->M0_CODIGO  + cFilemp ) )
			cNomeFil := SM0->M0_FILIAL
		Endif

		cMat 		:= AUUX->RA_MAT 
		cNome		:= AUUX->RA_NOME
		cTurno		:= AUUX->R6_TURNO + '-'+ AUUX->R6_DESC
		cCPF		:= AUUX->RA_CIC
		cRG			:= AUUX->RA_RG
		cPIS		:= AUUX->RA_PIS
		cFuncao		:= AUUX->RJ_DESC		
				   	
	   	cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	   	cHtm += '		<td width="200" align="left">'+ cFilemp + ' - ' + cNomeFil + '</td>' + LF
		cHtm += '		<td width="200" align="left">'+cMat+ ' - ' + cNome + '</td>' + LF
		//cHtm += '		<td width="40" align="left">'+ cTurno + '</td>' + LF
		cHtm += '		<td width="40" align="left">'+ cFuncao + '</td>' + LF
		cHtm += '		<td width="40" align="left">'+ cRG + '</td>' + LF
		cHtm += '		<td width="40" align="left">'+ cCPF + '</td>' + LF	
		cHtm += '		<td width="40" align="left">'+ cPIS + '</td>' + LF	
		cHtm += '		</tr>' + LF
		
	   	///GRAVA O HTML
		Fwrite( nHandle, cHtm, Len(cHtm) )
		cHtm := ""
		cJornada := ""                     
		   		        			   
		AUUX->( DBSKIP() )

	Enddo
	
	cHtm += '</table>' + LF
	
	
	cHtm += '	</div>' + LF
	cHtm += '	<div>' + LF
	cHtm += '	</div>' + LF
	cHtm += '<BR>' + LF
	cHtm += '<BR>' + LF
	cHtm += '<p><span style="FONT-SIZE: 8pt; COLOR: black; FONT-FAMILY: Verdana">' + LF
	cHtm += '<< "WFGPE001.htm" >></span></p>' + LF
	cHtm += '</body>' + LF
	cHtm += '</html>' + LF
	
	///GRAVA O HTML
	Fwrite( nHandle, cHtm, Len(cHtm) )
	FClose( nHandle )
	 
	 
	 eEmail += cEMAILRH
	 eEmail += ";" + cEMAILGERH
   	 //eEmail := "flavia.rocha@ravaembalagens.com.br"        
	 
	 cCopia := ""  //"flavia.rocha@ravaembalagens.com.br"         	         
	 subj	:= "Funcionแrios Cadastrados sem PIS - " + dtoc(dDatabase)
	 cCorpo  := subj  + "   - Este arquivo ้ melhor visualizado no navegador Mozilla Firefox."
	 cAnexo  := cDirHTM + cArqHTM
	 cAssun  := subj
			
	//U_SendFatr11(eEmail, cCorpo, cAssun, cHtm, cAnexo )  
 	U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )
 	
 	
	
	  
endif
AUUX->(DbCloseArea())


Return

***********************************
Static Function fCabeca(dData, cDesc)
***********************************

Local cHtm := ""
Local LF 		:= CHR(13) + CHR(10)

cHtm += '<html>' + LF
cHtm += '<head>' + LF
cHtm += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">' + LF
cHtm += '<title>Funcionแrios sem PIS</title>' + LF
cHtm += '<style>' + LF
cHtm += '</style>' + LF
cHtm += '</head>' + LF
cHtm += '<body>' + LF

cHtm += '	<br>' + LF
cHtm += '	<strong>' + LF
cHtm += '		<center>' + LF
cHtm += '		<span style="font-size:15pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
cHtm += '			'+ cDesc + " - " +  Dtoc(dData) +  LF
cHtm += '		</span>' + LF
cHtm += '		</center>' + LF
cHtm += '	</strong>' + LF
cHtm += '<span style="font-size:8pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
cHtm += ' 	</span>	<br>' + LF
cHtm += '	</p>' + LF
cHtm += '	<div>' + LF


cHtm += '	<table width="1000" align=center>' + LF
cHtm += '				<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
cHtm += '					<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">' + LF
cHtm += '						<p align="left">Prezado(s), <br><br><br>' + LF
cHtm += '					&nbsp;&nbsp;Informamos que os seguintes funcionarios possuem Cadastro Incompleto: campo PIS sem preenchimento:<BR><BR>' + LF
cHtm += '					</td>' + LF
cHtm += '			</tr>' + LF
cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF     
cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Filial</b></td>' + LF
cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Matrํcula / Funcionแrio</b></td>' + LF
//cHtm += '	<td width="220" align="center" bgcolor="#A2D7AA"><b>Jornada contratada</b></td>' + LF
cHtm += '	<td width="220" align="center" bgcolor="#A2D7AA"><b>Funcao</b></td>' + LF
cHtm += '	<td width="60"  align="center" bgcolor="#A2D7AA"><b>RG</b></td>' + LF
cHtm += '	<td width="220" align="center" bgcolor="#A2D7AA"><b>CPF</b></td>' + LF
cHtm += '	<td width="220" align="center" bgcolor="#A2D7AA"><b>PIS</b></td>' + LF
cHtm += '	</tr>' + LF

Return(cHtm)

