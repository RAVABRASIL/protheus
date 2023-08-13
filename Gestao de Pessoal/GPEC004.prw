#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦ Programa ¦ GPEC004  ¦ Autor ¦ Flávia Rocha          ¦ Data ¦ 19/09/2011¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦Descrição ¦ Obter o turno e horário de trabalho de determinado         ¦¦¦
¦¦¦          ¦ funcionário (parâmetro cMat - matrícula)                   ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦ Uso      ¦ Gestão de Pessoal                                          ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


******************************
User Function fGetTURNO(cMat , dData)
******************************


Local cQuery := ""
Local cDescTurno := ""
Local LF	 := CHR(13) + CHR(10) 
Local nDia   := dow(dData)
Local cEntrada := ""
Local cSaida   := ""
Local cJornada := ""  
Local nPos   := 0
Local nTam   := 0
Local cTurno := ""
Local aTurno := {}


cQuery:=" SELECT  " + LF 
cQuery += " SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF

cQuery += " From " 
cQuery += " " + RetSqlName("SR6") + " SR6, " + LF
cQuery += " " + RetSqlName("SRA") + " SRA " + LF

cQuery += " WHERE " + LF

cQuery += " SRA.RA_TNOTRAB = SR6.R6_TURNO  " + LF 
cQuery += " AND SRA.RA_MAT = '" + Alltrim(cMat) + "' " + LF
cQuery += " AND SRA.RA_FILIAL = '" + xFilial("SRA") + "' AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SR6.R6_FILIAL = '" + xFilial("SR6") + "' AND SR6.D_E_L_E_T_ = '' " + LF

cQuery += " GROUP BY
cQuery += " SRA.RA_NOME, SRA.RA_TNOTRAB, SR6.R6_TURNO, SR6.R6_DESC " + LF

//cQuery += " ORDER BY P8_FILIAL,P8_MAT,P8_DATA,P8_TPMARCA  " + LF
MemoWrite("C:\Temp\VERTURNO.SQL",cQuery)

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUUX"

//TcSetField("AUUX", "P8_DATA" , "D" )                                                       
AUUX->(DbGoTop())

If !AUUX->(EOF()) 

	AUUX->(DbGoTop())
	Do while !AUUX->(EOF()) 

		cDescTurno		:= AUUX->R6_TURNO + '-'+ AUUX->R6_DESC
		X			:= 1
				
		cQuery := " Select TOP 1 " + LF
		cQuery += " PJ_SEMANA, PJ_ENTRA1,PJ_SAIDA1,PJ_ENTRA2,PJ_SAIDA2 "  + LF
		cQuery += " from " + RetSqlName("SPJ") + " SPJ " + LF
		cQuery += " WHERE PJ_TURNO = '" + Alltrim(Substr(cDescTurno,1,3)) + "' " + LF
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
		
		If Substr(cJornada,1,5)  >= "22:00"
			cTurno := "3"		
		Elseif Substr(cJornada,1,5) >= "13:40" 
			cTurno := "2"
		Elseif Substr(cJornada,1,5) >= "05:30" 
			cTurno := "1"		
		Endif
    	
    	AUUX->(DBSKIP())
	Enddo
	
	Aadd( aTurno , { cTurno, cDescTurno } )
Endif

Return(aTurno)