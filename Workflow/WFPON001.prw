#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFPON001                               º Data ³  22/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Marcações do Ponto por Funcionário            º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pelo chamado 002213 - Michele                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

/*
Solicitado no chamado 002213:
Desenvolver rotina para leitura e apontamento diário de ponto 
eletrônico e o sistema enviar diariamente aos supervisores e gerentes 
da produção um e mail com as inconsistências 
(batidas irregulares ou faltando), das últimas 24 horas. 
*/

***************************
User Function WFPON001()
***************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFPON001"
  sleep( 5000 )
  conOut( "Programa WFPON001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFPON001"
  sleep( 5000 )
  conOut( "Programa WFPON001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
 
  
Else
  conOut( "Programa WFPON001 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFPON001 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***********************
Static Function Exec()
***********************

Local cPar		:= Getmv("MV_PONMES")
Local cQuery	:=' '
Local LF 		:= CHR(13) + CHR(10)
Local eEmail	:= ""
Local cEmpresa  := ""   
Local cNomeSetor:= ""
Local dDTMarca  := Ctod("  /  /    ") 
Local nDia      := 0 //Dow(dData)
Local cJornada  := ""    
Local nPos		:= 0
Local nTam		:= 0 
Local cMarcas   := ""
Local cEntrada  := ""
Local cSaida	:= ""
Local cHoraP8	:= "" 
Local cTPMarca  := ""
Local cMat		:= ""
Local cTurno	:= ""
Local cNome		:= "" 
Local cHtm		:= "" 
Local cDirHTM   := ""    
Local cArqHTM   := ""   
Local nHandle   := 0 
Local cVar		:= "" 
Local cMarca1	:= ""
Local cMarca2	:= ""
Local cMarca3	:= ""
Local cMarca4	:= ""
Local aIncon	:= {}
Local cTurno2	:= ""
Local fr		:= 0

Private cCodFil	:= "" 
//Private dData		:= Ctod("25/09/2011")
Private dData	    := ( dDatabase - 1)
//Private dData	    := Stod(Substr(cPar,1,8))
nDia := Dow(dData)  
 
//USAR RA_CC para especificar o depto.

//msgbox(dtoc(ddata))

cQuery:=" SELECT  " + LF 

cQuery += " SP8.P8_FILIAL,SP8.P8_MAT, SP8.P8_DATA, SP8.P8_HORA,SP8.P8_TPMARCA,SP8.P8_MOTIVRG, " + LF 
cQuery += " SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF

cQuery += " From " + RetSqlName("SP8") + " SP8, " + LF
cQuery += " " + RetSqlName("SR6") + " SR6, " + LF
cQuery += " " + RetSqlName("SRA") + " SRA " + LF

cQuery += " WHERE " + LF

cQuery += " SP8.P8_MOTIVRG = '' " + LF 
cQuery += " AND SP8.P8_TPMARCA <> '' " + LF

cQuery += " AND SP8.P8_DATA = '" + Dtos(dData) + "' " + LF  
cQuery += " AND SP8.P8_MAT = SRA.RA_MAT " + LF
cQuery += " AND SRA.RA_TNOTRAB = SR6.R6_TURNO  " + LF 

//cQuery += " AND SP8.P8_MAT = '00006' " + LF 	//TESTE
//cQuery += " AND SP8.P8_MAT <= '00168' " + LF 	//TESTE
cQuery += " AND SP8.P8_MAT >= '' AND SP8.P8_MAT <= 'ZZZZZZ' " + LF


cQuery += " AND SP8.P8_FILIAL = '" + xFilial("SP8") + "' AND SP8.D_E_L_E_T_ = '' " + LF
cQuery += " AND SRA.RA_FILIAL = '" + xFilial("SRA") + "' AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SR6.R6_FILIAL = '" + xFilial("SR6") + "' AND SR6.D_E_L_E_T_ = '' " + LF

cQuery += " GROUP BY
cQuery += " SP8.P8_FILIAL,SP8.P8_MAT, SP8.P8_DATA, SP8.P8_HORA,SP8.P8_TPMARCA,SP8.P8_MOTIVRG, " + LF 
cQuery += " SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF

cQuery += " ORDER BY P8_FILIAL,P8_MAT,P8_DATA,P8_TPMARCA  " + LF
MemoWrite("C:\Temp\WFPON001_" + Alltrim(SM0->M0_CODFIL) +".SQL",cQuery)

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUUX"

TcSetField("AUUX", "P8_DATA" , "D" )                                                       
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
   	cDirHTM  := "\HTMPONTO\"    
	cArqHTM  := "PONTO_" + Alltrim(cEmpresa) + '_' + Alltrim( Dtos(dData) ) +".HTM"   
			
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			    
	If nHandle = -1
	     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
    
	///cabeçalho
	cHtm += fCabeca(dData, cEmpresa , '1', "Espelho do Ponto")
	
	
	AUUX->(DbGoTop())
	Do while !AUUX->(EOF()) 
	
		cMat 		:= AUUX->P8_MAT 
		cNome		:= AUUX->RA_NOME
		dDTMarca	:= AUUX->P8_DATA
		cTurno		:= AUUX->R6_TURNO + '-'+ AUUX->R6_DESC
		X			:= 1
		cMarca1		:= ""
		cMarca2		:= ""
		cMarca3		:= ""
		cMarca4		:= ""
		
		cQuery := " Select TOP 3 " + LF
		cQuery += " PJ_SEMANA, PJ_ENTRA1,PJ_SAIDA1,PJ_ENTRA2,PJ_SAIDA2 "  + LF
		cQuery += " from " + RetSqlName("SPJ") + " SPJ " + LF
		cQuery += " WHERE PJ_TURNO = '" + Alltrim(Substr(cTurno,1,3)) + "' " + LF
		cQuery += " AND SPJ.PJ_FILIAL = '" + xFilial("SPJ") + "' AND SPJ.D_E_L_E_T_ = '' " + LF
		cQuery += " AND SPJ.PJ_DIA = '" + Alltrim(STR(nDia)) + "' " + LF
		cQuery += " AND PJ_TPDIA = 'S' " + LF
		cQuery += " ORDER BY PJ_SEMANA " + LF
		MemoWrite("C:\Temp\spj.sql",cQuery)
		If Select("SSPJ") > 0
			DbSelectArea("SSPJ")
			DbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS "SSPJ"
		
		SSPJ->(DbGoTop())

		While !SSPJ->(EOF()) 
			cEntrada	 := Alltrim(Str(SSPJ->PJ_ENTRA1))  
		
			nPos		 := At(".", cEntrada )  
			nTam		 := Len( Alltrim(cEntrada) )
			If nPos > 0
											
				If nTam = 3 .and. nPos = 2								
					cJornada	 += "0" + Substr(cEntrada ,1,nPos - 1) + ":" + Substr( cEntrada, nPos + 1, nTam - nPos)  + "0" 
				Elseif nTam = 4 .and. nPos = 2
					cJornada	 += "0" + Substr(cEntrada ,1,nPos - 1) + ":" + Substr( cEntrada, nPos + 1, nTam - nPos)  
				Elseif nTam = 4 .and. nPos = 3
					cJornada	 += Substr(cEntrada ,1,nPos - 1) + ":" + Substr( cEntrada, nPos + 1, nTam - nPos)  + "0" 
				Endif
				
			Else
				If nTam <= 1
					cJornada += "0" + Alltrim(cEntrada) + ":00"
				Else
					cJornada += Alltrim(cEntrada) + ":00 "
				Endif
				 
			Endif
				
			cSaida		 := Alltrim(Str(SSPJ->PJ_SAIDA1))
			nPos		 := At(".", cSaida)  
			nTam		 := Len( Alltrim(cSaida) )
			If nPos > 0
				cJornada	 += " / " + Substr( cSaida,1,nPos - 1) + ":" + Substr( cSaida, nPos + 1, nTam - nPos) 
				
				If nPos >= 3 .and. nTam = 4
					cJornada += "0"
				ElseIf nPos = 2 .and. nTam = 3
					cJornada := Alltrim(cJornada) + "0"
				Endif 
			Else
				If nTam <= 1
					cJornada += " / " + "0" + Alltrim(cSaida) + ":00"
				Else
					cJornada += " / " + Alltrim(cSaida) + ":00 "
				Endif
			
			Endif
				
			cEntrada	 := Alltrim(Str(SSPJ->PJ_ENTRA2))
			nPos		 := At(".", cEntrada )  
			nTam		 := Len( Alltrim(cEntrada) )
			If nPos > 0
				cJornada	 += " / " + Substr(cEntrada ,1, nPos - 1) + ":" + Substr(cEntrada, nPos + 1, nTam - nPos) 
				
				If nPos >= 3  .and. nTam = 4
					cJornada += "0"
				ElseIf nPos = 2 .and. nTam = 3
					cJornada := Alltrim(cJornada) + "0"
				Endif 
			Else
				If nTam <= 1
					cJornada += " / " + "0" + Alltrim(cEntrada) + ":00"
				Else
					cJornada += " / " + Alltrim(cEntrada) + ":00 "
				Endif				
				
			Endif
			
			cSaida		 := Alltrim(Str(SSPJ->PJ_SAIDA2)	)
			nPos		 := At(".", cSaida)  
			nTam		 := Len( Alltrim(cSaida) )
			If nPos > 0
				If nTam = 3 .and. nPos = 2								
					cJornada	 += " / " + "0" + Substr(cSaida ,1,nPos - 1) + ":" + Substr( cSaida, nPos + 1, nTam - nPos)  + "0" + LF
				Else
					cJornada	 += " / " + Substr(cSaida ,1,nPos - 1) + ":" + Substr( cSaida, nPos + 1, nTam - nPos)  + LF
				Endif
			
			Else
				
				If nTam <= 1
					cJornada += " / " + "0" + Alltrim(cSaida) + ":00" + LF
				Else
					cJornada += " / " + Alltrim(cSaida) + ":00 " + LF
				Endif				
			Endif
				
			SSPJ->(DBSKIP())
		Enddo

				
		Do While Alltrim(AUUX->P8_MAT) == Alltrim(cMat)
		  
		    cHoraP8		 := Alltrim(Str(AUUX->P8_HORA))
			nPos		 := At(".", cHoraP8) 
			nTam		 := Len(cHoraP8)
			cTPMarca	 := AUUX->P8_TPMARCA
				
			If Alltrim(cTPMarca) = "1E"				
				cMarca1 := fMudHora(cHoraP8, nPos, nTam)							
			Elseif Alltrim(cTPMarca) = "1S"
				cMarca2 := fMudHora(cHoraP8, nPos, nTam)		
			ElseIf Alltrim(cTPMarca) = "2E"
				cMarca3 := fMudHora(cHoraP8, nPos, nTam)		
			ElseIf Alltrim(cTPMarca) = "2S" 
				cMarca4 := fMudHora(cHoraP8, nPos, nTam)		
			Endif
		    		        			   
			AUUX->( DBSKIP() )
		Enddo
		
		If Substr(cJornada,1,5)  >= "22:00"
			cTurno2 := "3"		
		Elseif Substr(cJornada,1,5) >= "13:40" 
			cTurno2 := "2"
		Elseif Substr(cJornada,1,5) >= "05:30" 
			cTurno2 := "1"		
		Endif
		
		If Empty(cMarca1) .or. Empty(cMarca2) .or. Empty(cMarca3) .or. Empty(cMarca4)
		   	Aadd(aIncon, { cMat, cNome, cMarca1, cMarca2, cMarca3, cMarca4, cTurno2 } )
	    Endif
	    aIncon := Asort( aIncon,,, { |X,Y| X[7] + X[1]  <  Y[7] + Y[1] } ) 
	    		   	
	   	cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '		<td width="200" align="left">'+cMat+ ' - ' + cNome + '</td>' + LF
		cHtm += '		<td width="40" align="left">'+ cTurno + '</td>' + LF
		cHtm += '		<td width="180" align="center">'+cJornada+'</td>' + LF
		cHtm += '		<td width="12"  align="center">'+Dtoc(dDTMarca) + '</td>' + LF
		cHtm += '		<td width="12" align="right">'+ iif(!Empty(cMarca1),cMarca1,'/')+'</td>' + LF
		cHtm += '		<td width="12" align="right">'+ iif(!Empty(cMarca2),cMarca2,'/')+'</td>' + LF
		cHtm += '		<td width="12" align="right">'+ iif(!Empty(cMarca3),cMarca3,'/')+'</td>' + LF
		cHtm += '		<td width="12" align="right">'+ iif(!Empty(cMarca4),cMarca4,'/')+'</td>' + LF
		cHtm += '		</tr>' + LF
		
	   	///GRAVA O HTML
		Fwrite( nHandle, cHtm, Len(cHtm) )
		cHtm := ""
		cJornada := ""                     
		
	Enddo
	
	cHtm += '</table>' + LF
	
     /*
	//inconsistências
	If len(aIncon) > 0
		cHtm += '<table width="1000" align=center>' + LF
		cHtm += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
		cHtm += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">' + LF
		cHtm += '					<p align="left">' + LF
		cHtm += '				<BR><BR>&nbsp;&nbsp;Abaixo, as inconsistências encontradas na leitura:<BR><BR>' + LF
		cHtm += '				</td>' + LF
		cHtm += '		</tr>' + LF
		cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '			<td width="200" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Matrícula / Funcionário</b></td>' + LF
		cHtm += '			<td width="200" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Turno</b></td>' + LF
	 	cHtm += '			<td width="220" align="center" bgcolor="#A2D7AA" colspan="4"><b>Inconsistências</b></td>' + LF
		cHtm += '		</tr>' + LF
	 	cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada</b></td>' + LF
		cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída Intervalo</b></td>' + LF
		cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada Intervalo</b></td>' + LF
		cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída</b></td>' + LF
		cHtm += '		</tr>' + LF
	
		For fr := 1 to Len(aIncon)
			cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
			cHtm += '		<td width="200" align="left">' + aIncon[fr,1] + ' - ' + aIncon[fr,2] + '</td>' + LF
			cHtm += '		<td width="12"  align="center">' + aIncon[fr,7] + '</td>' + LF
		 	
		 	cHtm += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,3]),aIncon[fr,3],"S/Marcação") + '</td>' + LF
		 	cHtm += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,4]),aIncon[fr,4],"S/Marcação") + '</td>' + LF
		 	cHtm += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,5]),aIncon[fr,5],"S/Marcação") + '</td>' + LF
		 	cHtm += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,6]),aIncon[fr,6],"S/Marcação") + '</td>' + LF
			cHtm += '		</tr>' + LF
		Next
		cHtm += '	</table>' + LF
	Else
		cHtm += '<table width="1000" align=center>' + LF
		cHtm += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
		cHtm += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">' + LF
		cHtm += '					<p align="left">' + LF
		cHtm += '				<BR><BR>&nbsp;&nbsp;Não foram encontradas inconsistências na leitura do ponto.<BR><BR>' + LF
		cHtm += '				</td>' + LF
		cHtm += '		</tr>' + LF
		
		cHtm += '	</table>' + LF
	Endif
	*/
	
	cHtm += '	</div>' + LF
	cHtm += '	<div>' + LF
	cHtm += '	</div>' + LF
	cHtm += '<BR>' + LF
	cHtm += '<BR>' + LF
	cHtm += '<p><span style="FONT-SIZE: 8pt; COLOR: black; FONT-FAMILY: Verdana">' + LF
	cHtm += '<< "WFPON001.htm" >></span></p>' + LF
	cHtm += '</body>' + LF
	cHtm += '</html>' + LF
	///GRAVA O HTML
	Fwrite( nHandle, cHtm, Len(cHtm) )
	FClose( nHandle )
	 
	 
	 eEmail := ''
        
	 eEmail += ';maurilio@ravaembalagens.com.br' 	         
	 
	 cCopia := "flavia.rocha@ravaembalagens.com.br" 	         
	 subj	:= 'Leitura do Ponto - ' + cEmpresa + "-" + dtoc(dData)
	 cCorpo  := subj  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	 cAnexo  := cDirHTM + cArqHTM
	 cAssun  := subj
			
	//U_SendFatr11(eEmail, cCorpo, cAssun, cHtm, cAnexo )  
 	U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )
 	
 	Env_Incons(dData, aIncon, cEmpresa) 
 	
	
	  
endif
AUUX->(DbCloseArea())

Reset Environment

Return

***********************************
Static Function fCabeca(dEmissao, cEmpresa, cTipo, cDesc)
***********************************

Local cHtm := ""
Local LF 		:= CHR(13) + CHR(10)

cHtm += '<html>' + LF
cHtm += '<head>' + LF
cHtm += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">' + LF
cHtm += '<title>Espelho Ponto</title>' + LF
cHtm += '<style>' + LF
cHtm += '</style>' + LF
cHtm += '</head>' + LF
cHtm += '<body>' + LF

cHtm += '	<br>' + LF
cHtm += '	<strong>' + LF
cHtm += '		<center>' + LF
cHtm += '		<span style="font-size:15pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
cHtm += '			'+ cDesc + ' - ' + Alltrim(cEmpresa) + " - " + Dtoc(dData) +  LF
cHtm += '		</span>' + LF
cHtm += '		</center>' + LF
cHtm += '	</strong>' + LF
cHtm += '<span style="font-size:8pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
cHtm += ' 	</span>	<br>' + LF
cHtm += '	</p>' + LF
cHtm += '	<div>' + LF

If cTipo = '1'
	cHtm += '	<table width="1000" align=center>' + LF
	cHtm += '				<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
	cHtm += '					<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">' + LF
	cHtm += '						<p align="left">Prezado(s), <br><br><br>' + LF
	cHtm += '					&nbsp;&nbsp;Informamos a leitura do ponto realizada em: '+  DtoC(dEmissao) + '<BR><BR>' + LF
	cHtm += '					</td>' + LF
	cHtm += '			</tr>' + LF
	cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '	<td width="200" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Matrícula / Funcionário</b></td>' + LF
	cHtm += '	<td width="220" colspan="2" align="center" bgcolor="#A2D7AA"><b>Jornada contratada</b></td>' + LF
	cHtm += '	<td width="60"  rowspan="2" align="center" bgcolor="#A2D7AA"><b>Data</b></td>' + LF
	cHtm += '	<td width="220" align="center" bgcolor="#A2D7AA" colspan="5"><b>Marcações</b></td>' + LF
	cHtm += '	</tr>' + LF
	cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>Turno</b></td>' + LF
	cHtm += '	<td width="180" align="center" bgcolor="#A2D7AA"><b>Horários</b></td>' + LF
	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada</b></td>' + LF
	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída Intervalo</b></td>' + LF
	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada Intervalo</b></td>' + LF
	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída</b></td>' + LF
	cHtm += '	</tr>' + LF

Elseif cTipo = '2'
	cHtm += '<table width="1000" align=center>' + LF
	cHtm += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
	cHtm += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">' + LF
	cHtm += '					<p align="left">' + LF
	cHtm += '				<BR><BR>&nbsp;&nbsp;Abaixo, as inconsistências encontradas na leitura:<BR><BR>' + LF
	cHtm += '				</td>' + LF
	cHtm += '		</tr>' + LF
	cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '			<td width="200" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Matrícula / Funcionário</b></td>' + LF
 	cHtm += '			<td width="220" align="center" bgcolor="#A2D7AA" colspan="4"><b>Inconsistências</b></td>' + LF
	cHtm += '		</tr>' + LF
 	cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada</b></td>' + LF
	cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída Intervalo</b></td>' + LF
	cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada Intervalo</b></td>' + LF
	cHtm += '			<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída</b></td>' + LF
	cHtm += '		</tr>' + LF
Endif

Return(cHtm)

***********************************
Static Function Env_Incons(dData, aIncon, cEmpresa) 
***********************************

Local cHtm := "" 
Local eEmail := "" 
Local fr	 := 0
Local x		 := 0
Local cDirHTM := ""
Local cArqHTM := ""
Local LF	  := CHR(13) + CHR(10)

Local cMsgTurno  := ""


For x:= 1 to 3
   	
   	If len(aIncon) > 0
	   	cDirHTM  := "\HTMPONTO\"    
		cArqHTM  := "INC_TURNO_" + Alltrim(Str(x))+ "_" + Alltrim( Dtos(dData) ) +".HTM"   
					
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		cHtm := ""
		cHtm += fCabeca(dData, cEmpresa , '2', "Inconsistências no Espelho do Ponto") 
		cMsgTurno := ""		
			
		For fr := 1 to Len(aIncon)
			If Alltrim(aIncon[fr,7]) = Alltrim(str(x) )
				cMsgTurno += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
				cMsgTurno += '		<td width="200" align="left">' + aIncon[fr,1] + ' - ' + aIncon[fr,2] + '</td>' + LF
				 	
			 	cMsgTurno += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,3]),aIncon[fr,3],"Marcação fora de Horário") + '</td>' + LF
			 	cMsgTurno += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,4]),aIncon[fr,4],"Marcação fora de Horário") + '</td>' + LF
			 	cMsgTurno += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,5]),aIncon[fr,5],"Marcação fora de Horário") + '</td>' + LF
			 	cMsgTurno += '		<td width="12" align="right">' + iif(!Empty(aIncon[fr,6]),aIncon[fr,6],"Marcação fora de Horário") + '</td>' + LF
				cMsgTurno += '		</tr>' + LF
			Endif

		Next
		cHtm += cMsgTurno
		cHtm += '	</table>' + LF
		
		If !Empty(cMsgTurno)
			///GRAVA O HTML
			Fwrite( nHandle, cHtm, Len(cHtm) )
			FClose( nHandle )
				 
		 
			 eEmail := ''
			 eEmail += GetMV("RV_GERRH") 
			
			 If Alltrim(cCodFil) = '01' // SM0->M0_CODFIL = '01'			
				//cGerente := GetMv("RV_SC6851G")      //PARAMETRO COM O NOME DO GERENTE DE PRODUÇÃO FAB. SACOS
				eEmail += ";" + GetMv("RV_SC6851E")      //PARAMETRO COM O EMAIL DO GERENTE DE PRODUÇÃO FAB. SACOS 
			Elseif Alltrim(cCodFil) = '03' //SM0->M0_CODFIL = '03'
				//cGerente := GetMv("RV_CX6851G")      //PARAMETRO COM O NOME DO GERENTE DE PRODUÇÃO FAB. CAIXAS
				eEmail += ";" + GetMv("RV_CX6851E")      //PARAMETRO COM O EMAIL DO GERENTE DE PRODUÇÃO FAB. CAIXAS 			
			Endif
			 eEmail += ';maurilio@ravaembalagens.com.br' 	         
				 
			 cCopia := "flavia.rocha@ravaembalagens.com.br" 	         
			 subj	:= 'Inconsist. do Ponto - ' + cEmpresa + "-" + Dtoc(dData) + "-Turno: " + Alltrim(str(x))
			 cCorpo  := subj  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			 cAnexo  := cDirHTM + cArqHTM
			 cAssun  := subj
		 	 U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )
		Endif
				
	Endif
Next

Return

**********************************************
Static Function fMudHora(cHoraP8, nPos, nTam) 
**********************************************

Local cMarca := ""


If nPos > 0
	If nTam = 5 .and. nPos = 3
		cMarca	 := Substr(cHoraP8 ,1,nPos - 1) + ":" + Substr( cHoraP8, nPos + 1, nTam - nPos) 
	ElseIf nTam = 3 .and. nPos = 2								
		cMarca	 := "0" + Substr(cHoraP8 ,1,nPos - 1) + ":" + Substr( cHoraP8, nPos + 1, nTam - nPos)  + "0" 
	Elseif nTam = 4 .and. nPos = 2
		cMarca	 := "0" + Substr(cHoraP8 ,1,nPos - 1) + ":" + Substr( cHoraP8, nPos + 1, nTam - nPos)  
	Elseif nTam = 4 .and. nPos = 3
		cMarca	 := Substr(cHoraP8 ,1,nPos - 1) + ":" + Substr( cHoraP8, nPos + 1, nTam - nPos)  + "0" 
	Endif
Else
	cMarca	 := cHoraP8 + ":00" 
Endif

Return(cMarca)