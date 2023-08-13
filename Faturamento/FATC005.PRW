#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


//Calcula o prazo de entrega de uma mercadoria com base na transportadora / transp. redespacho

***************************************************

User Function FATC005( cFil, cNF, cSerie, cTransp, cRedesp, cLocaliz )

***************************************************

Local dPrev 	:= CtoD("  /  /    ")
Local lTemSZZ 	:= .F.                               
Local cLocaHum 	:= ""
Local cTransphum:= ""
Local cDiatrab	:= ""
Local nZZprazo	:= 0
Local cQuery	:= ""  
Local LF := CHR(13) + CHR(10)



If Empty( cRedesp )
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB " + LF
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ " + LF
	cQuery += " where " + LF
	cQuery += " SF2.F2_TRANSP = SA4.A4_COD " + LF
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF
	cQuery += " and SF2.F2_TIPO = 'N' " + LF
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
	cQuery += " and SF2.F2_FILIAL = '" + Alltrim(cFil) + "' " + LF
	cQuery += " and SF2.F2_DOC = '" + Alltrim(cNF) + "' " + LF
	cQuery += " and SF2.F2_SERIE = '" + Alltrim(cSerie) + "' " + LF
	cQuery += " and SF2.F2_TRANSP = '" + Alltrim(cTransp) + "' " + LF
	//cQuery += " and SF2.F2_SERIE != ' '   " + LF
	cQuery += " and SF2.D_E_L_E_T_ = ' '  " + LF
	cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  " + LF
	//cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
	//cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' " + LF
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  " + LF
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB " + LF
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE" + LF
Else
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB " + LF
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ " + LF
	cQuery += " where " + LF
	cQuery += " SF2.F2_REDESP = SA4.A4_COD " + LF
	cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP " + LF
	cQuery += " and SF2.F2_TIPO = 'N' " + LF
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
	cQuery += " and SF2.F2_FILIAL = '" + Alltrim(cFil) + "' " + LF
	cQuery += " and SF2.F2_DOC = '" + Alltrim(cNF) + "' " + LF
	cQuery += " and SF2.F2_SERIE = '" + Alltrim(cSerie) + "' " + LF
	cQuery += " and SF2.F2_REDESP = '" + Alltrim(cRedesp) + "' " + LF
	//cQuery += " and SF2.F2_SERIE != ' '   " + LF
	cQuery += " and SF2.D_E_L_E_T_ = ' '  " + LF
	cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  " + LF
	//cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
	//cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' " + LF
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  " + LF
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB " + LF
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE" + LF

Endif
MemoWrite("C:\Temp\fGetPrazo.SQL",cQuery)
cQuery := ChangeQuery( cQuery )
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2A"
TCSetField( 'SF2A', "F2_EMISSAO", "D")
TCSetField( 'SF2A', "F2_DTEXP", "D")

SF2A->( DbGotop() )

dPrev := CtoD("  /  /    ")
cA4Diatrab := ""

Do While ! SF2A->( Eof() )

	If !Empty( SF2A->F2_DTEXP )    
		If !Empty( cRedesp )
		
			cLocahum		:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
	     	cTransphum		:= "47    "		//Irá pegar o prazo da ALD para o redespacho para Recife
	     	DbselectArea("SA4")
	     	Dbsetorder(1)
	     	SA4->(Dbseek(xFilial("SA4") + cTransphum ))
	     	cDiatrab := SA4->A4_DIATRAB
	     	
	     	DbselectArea("SZZ")
	     	SZZ->(Dbsetorder(1))
	       	SZZ->(Dbseek(xFilial("SZZ") + cTransphum + cLocahum ))       		
	       		nZZprazo := SZZ->ZZ_PRZENT + SF2A->ZZ_PRZENT         		//soma o prazo da primeira transportadora mais o da segunda.
	       		dPrev := U_CalPrv( SF2A->F2_DTEXP , cDiatrab, nZZprazo )       	
		
		Else
			dPrev := U_CalPrv( SF2A->F2_DTEXP , SF2A->A4_DIATRAB, SF2A->ZZ_PRZENT )  //caso não encontre o cadastro da 2a. transp. no SZZ, irá assumir
																					//o prazo da primeira.
			//MSGBOX("PRAZO: " + Dtoc(dPrev) )
		Endif
	
	Else	
		dPrev := CtoD("  /  /    ")		
	Endif    

	SF2A->(DBSKIP())
Enddo

DbselectArea("SF2A")
DbcloseArea()

Return( dPrev )
