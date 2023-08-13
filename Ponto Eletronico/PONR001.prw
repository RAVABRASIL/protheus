#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PONR001                               º Data ³  29/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de turnos por por Funcionário                    º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pelo chamado 002288 - Michele                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

/*
Solicitado no chamado 002288:
Gerar um relatório do sistema contendo Funcionários 
cadastrado por turno: Turno - MAtricula - Nome - Função      
*/

***************************
User Function PONR001()
***************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Funcionarios x Turno"
Local cPict          := ""
Local titulo         := "Funcionarios x Turno"
Local nLin           := 80

Local Cabec1         := "Matricula   Nome                           Funcao              Turno -   Descricao              Horarios"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "PONR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PONR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "PONR001"
Private cCodUser := __CUSERID 
Private cNomeUser:= ""
Private cMailUser:= ""
Private aUsua	 := {}

Private cString := "SRA" 

PswOrder(1)
If PswSeek( cCodUser, .T. )
   	aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   	//cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   	cNomeUser := Alltrim(aUsua[1][4])		// Nome do usuário
   	cMailUser := Alltrim(aUsua[1][14])     // e-mail do usuário
Endif

dbSelectArea("SRA")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)

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
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/09/11   º±±
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
Local cFuncao   := ""
Local aFunc     := {}

Local cTURNOTRAB := ""
Local cNomeSuperv:= ""
Local aRetorno   := {}
Local aTURNO     := {}

Private cCodFil	:= "" 
//Private dData		:= Ctod("25/09/2011")
Private dData	    := dDatabase
//Private dData	    := Stod(Substr(cPar,1,8))  
Private nToturno    := 0
Private cTurnoFim   := ""

nDia := Dow(dData)  
 


cQuery := "Select RA_FILIAL, RA_MAT, RA_NOME, RA_CODFUNC, RJ_DESC, RA_TNOTRAB, R6_TURNO, R6_DESC, RA_EMAIL " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SRA") + " SRA, " + LF
cQuery += " " + RetSqlName("SRJ") + " SRJ, " + LF
cQuery += " " + RetSqlName("SR6") + " SR6 " + LF
cQuery += "WHERE " + LF
cQuery += "RA_FILIAL = '" + Alltrim(xFilial("SRA")) + "' " + LF
cQuery += " AND RA_CODFUNC = RJ_FUNCAO " + LF
cQuery += " AND RA_SITFOLH <> 'D' "  + LF
cQuery += " AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SRJ.D_E_L_E_T_ = '' " + LF
cQuery += " AND SR6.D_E_L_E_T_ = '' " + LF

//cQuery += " AND SRA.RA_MAT >= '00135'  " + LF

cQuery += " AND SRA.RA_MAT >= '" + Alltrim(mv_par01) + "' AND SRA.RA_MAT <= '" + Alltrim(mv_par02) + "' " + LF

cQuery += " AND RA_TNOTRAB = R6_TURNO  " + LF
cQuery += " ORDER BY RA_FILIAL, RA_MAT " + LF
MemoWrite("C:\Temp\FUNC_CARGO.sql", cQuery )
		          
If Select("RAXX") > 0
	DbSelectArea("RAXX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "RAXX"
                                        
cCodFil	:= SM0->M0_CODFIL

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava-" + SM0->M0_FILIAL
Endif

cHtm := ""

RAXX->(DbGoTop())
SetRegua(RecCount())
If !RAXX->(EOF())
 
	If mv_par04 = 1
		////CRIA O HTM 
	   	cDirHTM  := "\Temp\"    
		cArqHTM  := "PONR001_"+ Alltrim(cEmpresa) + ".HTM"   
				
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
	    
		///cabeçalho
		cHtm += fCabeca(dDatabase, cEmpresa , '1', "Funcionários x Turnos") 
	Endif
		
	Do while !RAXX->(EOF()) 
	
		cMat 		:= RAXX->RA_MAT 
		cNome		:= RAXX->RA_NOME
		//dDTMarca	:= dDatabase
		cTurno		:= RAXX->R6_TURNO + '-'+ RAXX->R6_DESC
		cFuncao     := RAXX->RJ_DESC 
		
		cQuery := " Select TOP 1 " + LF
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
				
				ElseIf nPos >= 3 .and. nTam = 4
					cJornada	 += " / " + Substr(cSaida ,1,nPos - 1) + ":" + Substr( cSaida, nPos + 1, nTam - nPos)  + "0" +LF
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
        
		If Substr(cJornada,1,5)  >= "22:00"
			cTurno2 := "3"
			 
		Elseif Substr(cJornada,1,5) >= "13:30"  
			cTurno2 := "2"
			 
		Elseif Substr(cJornada,1,5) >= "13:00"  .and. Substr(cJornada,1,5) <= "13:30" 
			cTurno2 := "5"
			
		Elseif Substr(cJornada,1,5) >= "07:00"  .and. Substr(cJornada,1,5) <= "09:00" 
			cTurno2 := "5"
							
		Elseif Substr(cJornada,1,5) >= "05:35"  .and. Substr(cJornada,1,5) < "07:00" //>= "05:30" 
			cTurno2 := "1"					
		
		Endif
		//msgbox(Substr(cJornada,1,5) + ' / ' + cTurno2)
				
		If mv_par03 = 4 //todos os turnos
			Aadd( aFunc, { cMat, cNome, cFuncao, cTurno2, cTurno, cJornada } )
		Elseif Alltrim(cTurno2) = Alltrim(str(mv_par03))     //pergunta se o turno a ser impresso é = ao escolhido no parâmetro
			Aadd( aFunc, { cMat, cNome, cFuncao, cTurno2, cTurno, cJornada } )
		Endif
		
		cJornada := ""                    
		DbSelectArea("RAXX")
		RAXX->(DBSKIP())
	Enddo
	
	aFunc := Asort( aFunc,,, { |X,Y| X[4] + X[1]  <  Y[4] + Y[1]  } )
	
	If Len(aFunc) > 0
		For fr := 1 to Len(aFunc)
		
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
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			    nLin := 8
			Endif
			
			If fr > 1
				If Alltrim(aFunc[fr,4]) != Alltrim(aFunc[fr - 1,4])  //se o turno lido agora for diferente do anterior, totaliza
					nLin++
					@nLin,000 PSAY Replicate("=",132)
					nLin++
					@nLin,000 Psay " T O T A L   T U R N O : " + Alltrim(aFunc[fr - 1 ,4] ) + " ==> "
					@nLin,043 Psay Transform( nToturno , "@E 99,999" )  + " Funcionários "
					
					If mv_par04 = 1           //total por turno no html
						cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" colspan="4">' + LF
						cHtm += '		<td width="200" colspan="4" align="center"><strong>TOTAL TURNO ' + Alltrim(aFunc[fr - 1 ,4] ) + ' ==> '+ Transform( nToturno , "@E 99,999" ) + ' Funcionários</strong></td>' + LF 
						cHtm += '		</tr>' + LF  
					Endif
					
					nToturno := 0
					nLin++
					@nLin,000 PSAY Replicate("=",132)
					nLin++
					nLin++				
				
				Endif
			Endif
			
	   
			If mv_par04 = 1
				If mv_par03 = 4     //todos os turnos
					cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
					cHtm += '		<td width="200" align="left">'+ aFunc[fr,1] + ' - ' + aFunc[fr,2] + '</td>' + LF
					cHtm += '		<td width="40" align="left">'+ aFunc[fr,3] + '</td>' + LF
					If Alltrim(aFunc[fr,4]) != "5"
						cHtm += '		<td width="40" align="left">'+ aFunc[fr,4] + " - " + aFunc[fr,5] + '</td>' + LF
					Else 
						cHtm += '		<td width="40" align="left">OUTROS - ' + aFunc[fr,5] + '</td>' + LF
					Endif
					
					cHtm += '		<td width="180" align="center">'+ aFunc[fr,6]+'</td>' + LF
					cHtm += '		</tr>' + LF  
					
					///GRAVA O HTML
					Fwrite( nHandle, cHtm, Len(cHtm) )
					cHtm := ""
				Elseif Alltrim(aFunc[fr,4]) = Alltrim(str(mv_par03))     //pergunta se o turno a ser impresso é = ao escolhido no parâmetro
					cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
					cHtm += '		<td width="200" align="left">'+ aFunc[fr,1] + ' - ' + aFunc[fr,2] + '</td>' + LF
					cHtm += '		<td width="40" align="left">'+ aFunc[fr,3] + '</td>' + LF
					If Alltrim(aFunc[fr,4]) != "5"
						cHtm += '		<td width="40" align="left">'+ aFunc[fr,4] + " - " + aFunc[fr,5] + '</td>' + LF
					Else 
						cHtm += '		<td width="40" align="left">OUTROS - ' + aFunc[fr,5] + '</td>' + LF
					Endif
					cHtm += '		<td width="180" align="center">'+ aFunc[fr,6]+'</td>' + LF
					cHtm += '		</tr>' + LF  
					
					///GRAVA O HTML
					Fwrite( nHandle, cHtm, Len(cHtm) )
					cHtm := ""
			
				Endif
			
			Endif
			
			If mv_par03 = 4     //todos os turnos
					
				@nLin, 000 PSAY aFunc[fr,1] + ' - ' + Substr(aFunc[fr,2] ,1,25)
				@nLin, 039 PSAY aFunc[fr,3]				
				If Alltrim(aFunc[fr,4]) != "5"
					@nLin, 064 PSAY aFunc[fr,4] + " - " + Substr(aFunc[fr,5],1,26)
				Else
					@nLin, 064 PSAY "OUTROS" + " - " + Substr(aFunc[fr,5],1,26)
			    Endif
			    
			    @nLin, 100 PSAY aFunc[fr,6]
			    nLin++
			 Elseif Alltrim(aFunc[fr,4]) = Alltrim(str(mv_par03))     //pergunta se o turno a ser impresso é = ao escolhido no parâmetro
			 	@nLin, 000 PSAY aFunc[fr,1] + ' - ' + Substr(aFunc[fr,2] ,1,25)
				@nLin, 039 PSAY aFunc[fr,3]
				
				If Alltrim(aFunc[fr,4]) != "5"
					@nLin, 064 PSAY aFunc[fr,4] + " - " + Substr(aFunc[fr,5],1,26)
				Else
					@nLin, 064 PSAY "OUTROS" + " - " + Substr(aFunc[fr,5],1,26)
			    Endif
			    @nLin, 100 PSAY aFunc[fr,6]
			    nLin++
			 /*
			 Elseif Alltrim(Substr(aFunc[fr,4],1,1) ) = "O" //outros
			 	@nLin, 000 PSAY aFunc[fr,1] + ' - ' + Substr(aFunc[fr,2] ,1,25)
				@nLin, 039 PSAY aFunc[fr,3]
				@nLin, 064 PSAY aFunc[fr,4] + " - " + Substr(aFunc[fr,5],1,26)
			    @nLin, 095 PSAY aFunc[fr,6]
			    nLin++
			 */
			 Endif
			
			nToturno++
			cTurnoFim := aFunc[fr,4]
		Next
		
		nLin++
		@nLin,000 PSAY Replicate("=",132)
		nLin++
		If Alltrim(cTurnoFim) != "5"
			@nLin,000 Psay " T O T A L   T U R N O : " + Alltrim(cTurnoFim) + " ==> "
		Else
			@nLin,000 Psay " T O T A L   T U R N O : 'OUTROS'  ==> "
		Endif
		@nLin,043 Psay Transform( nToturno , "@E 99,999" ) + " Funcionários "
		
		nLin++
		@nLin,000 PSAY Replicate("=",132)
		nLin++			
					
		If mv_par04 = 1
		
			  //total por turno no html
			cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" colspan="4">' + LF
			If Alltrim(cTurnoFim) != "5"
				cHtm += '		<td width="200" colspan="4" align="center"><strong>TOTAL TURNO : ' + Alltrim(cTurnoFim) + ' ==> '+ Transform( nToturno, "@E 99,999" ) + ' Funcionários</strong></td>' + LF 
			Else
				cHtm += '		<td width="200" colspan="4" align="center"><strong>TOTAL TURNO : "OUTROS" ==> '+ Transform( nToturno, "@E 99,999" ) + ' Funcionários</strong></td>' + LF 
			Endif
			cHtm += '		</tr>' + LF  
		
			cHtm += '</table>' + LF
			    	
			cHtm += '	</div>' + LF
			cHtm += '	<div>' + LF
			cHtm += '	</div>' + LF
			cHtm += '<BR>' + LF
			cHtm += '<BR>' + LF
			cHtm += '<p><span style="FONT-SIZE: 8pt; COLOR: black; FONT-FAMILY: Verdana">' + LF
			cHtm += '<< "PONR001.htm" >></span></p>' + LF
			cHtm += '</body>' + LF
			cHtm += '</html>' + LF
			///GRAVA O HTML
			Fwrite( nHandle, cHtm, Len(cHtm) )
			FClose( nHandle )
			
			eEmail := cMailUser
	      	 
			cCopia := ""  //"flavia.rocha@ravaembalagens.com.br" 	         
			subj	:= 'Funcionários x Turno - ' + cEmpresa 
			cCorpo  := subj  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := subj
			U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )
			
			Roda( 0, "", Tamanho)
		
	 	
		Endif
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
		Msginfo("NÃO EXISTEM DADOS PARA OS PARÂMETROS DIGITADOS")
	Endif

	  
Endif
RAXX->(DbCloseArea())

   
Return





***********************************
Static Function fCabeca(dEmissao, cEmpresa, cTipo, cDesc)
***********************************

Local cHtm := ""
Local LF 		:= CHR(13) + CHR(10)

cHtm += '<html>' + LF
cHtm += '<head>' + LF
cHtm += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">' + LF
cHtm += '<title>Func.xTurno</title>' + LF
cHtm += '<style>' + LF
cHtm += '</style>' + LF
cHtm += '</head>' + LF
cHtm += '<body>' + LF

cHtm += '	<br>' + LF
cHtm += '	<strong>' + LF
cHtm += '		<center>' + LF
cHtm += '		<span style="font-size:15pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
cHtm += '			'+ cDesc + ' - ' + Alltrim(cEmpresa) + LF
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
	cHtm += '					&nbsp;&nbsp;Abaixo seguem os funcionários e seus respectivos turnos cadastrados:<BR><BR>' + LF
	cHtm += '					</td>' + LF
	cHtm += '			</tr>' + LF
	cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '	<td width="200" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Matrícula / Funcionário</b></td>' + LF
	cHtm += '	<td width="100" rowspan="2" align="center" bgcolor="#A2D7AA"><b>Função</b></td>' + LF
	cHtm += '	<td width="220" colspan="2" align="center" bgcolor="#A2D7AA"><b>Jornada contratada</b></td>' + LF
	cHtm += '	</tr>' + LF
	cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>Turno</b></td>' + LF
	cHtm += '	<td width="180" align="center" bgcolor="#A2D7AA"><b>Horários</b></td>' + LF
//	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada</b></td>' + LF
//	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída Intervalo</b></td>' + LF
//	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Entrada Intervalo</b></td>' + LF
//	cHtm += '	<td width="20" align="center" bgcolor="#A2D7AA"><b>Saída</b></td>' + LF
	cHtm += '	</tr>' + LF

Endif

Return(cHtm)

