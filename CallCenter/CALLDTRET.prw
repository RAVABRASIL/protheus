#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'

/*
// Programa : CALLDTRET.PRW
// Data     : 04/11/09
// Autoria  : Flávia Rocha
// Objetivo : Trazer para o campo UC_PENDENT uma possível data para retorno da ligação,
//            baseada na data de entrega da transportadora ( dia entrega + 1 )
// Funções  : CALLDTRET e CALLDTENT - estas funções constam dos inicializadores padrão dos campos:
//            UC_PENDENT e UC_PREVCHG
*/ 


//Traz a data de retorno baseada na data de entrega ( + um dia )
***************************************
User Function CALLDTRET()
***************************************


Local cQuery := ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= "" //Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= "" //Substr( SU6->U6_CODENT,7,2 )
Local cTransp	:= ""
Local cCodlig   := SU6->U6_CODLIG
Local cU6Codigo := SU6->U6_CODIGO
Local cLista	:= SU6->U6_LISTA
Local cEntidade := SU6->U6_ENTIDA
Local dDTPrazo  := Ctod("  /  /    ")
Local dDTRet	:= Ctod("  /  /    ")
Local dDataSU6	:= Ctod("  /  /    ")

dDataSU6 := SU6->U6_REALCHG
set date brit


If cNFiscal != ""

	cQuery := " SELECT F2_TRANSP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_TIPO, ZZ_PRZENT, A4_COD, A4_DIATRAB, F2_DTEXP, ZZ_LOCAL,F2_LOCALIZ "
	cQuery += " FROM SF2020 SF2, SA4010 SA4, SZZ010 SZZ "
	cQuery += " WHERE RTRIM(F2_DOC) = '" + Alltrim( cNFiscal ) +"' "
	cQuery += " AND RTRIM(F2_SERIE) = '" + Alltrim( cSrNF ) + "' "
	//If cEntidade = "SA1"
		cCli := Substr( SU6->U6_CODENT,1,6 )
		cLj  := Substr( SU6->U6_CODENT,7,2 )
		cQuery += " AND RTRIM(F2_CLIENTE) = '" + Alltrim( cCli ) +"' "
		cQuery += " AND RTRIM(F2_LOJA) = '" + Alltrim( cLj ) + "' "
	//Elseif cEntidade = "SA4"
	//	cTransp := SU6->U6_CODENT
	//	cQuery += " AND F2_TRANSP = '" + cTransp +"' "		
	//Endif		
	cQuery += " AND F2_TRANSP = A4_COD "
	cQuery += " AND F2_TRANSP = ZZ_TRANSP "
	cQuery += " AND F2_TIPO = 'N' "
	cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA4.D_E_L_E_T_  = ' ' "
	cQuery += " AND SZZ.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
	//cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "
	//cQuery += " AND ZZ_FILIAL = '" + xFilial("SZZ") + "' "
	cQuery += " GROUP BY F2_TRANSP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_TIPO, ZZ_PRZENT, A4_COD, A4_DIATRAB, F2_DTEXP, ZZ_LOCAL,F2_LOCALIZ "
	cQuery += " order by F2_DOC, F2_SERIE "
	MemoWrite("C:\CALLDTRET.SQL",cQuery)
	
	If Select("SF2A") > 0
		DbSelectArea("SF2A")
		DbCloseArea()	
	EndIf 
	
	TCQUERY cQuery NEW ALIAS "SF2A"
	
	TCSetField( "SF2A", "F2_DTEXP", "D")
	
	SF2A->(Dbgotop())
	While ! SF2A->(EOF())   
	   
	   //dDTPrazo := CalcPrazo( SF2A->F2_DTEXP, SF2A->A4_DIATRAB, SF2A->ZZ_PRZENT)  //PARA LIGAR DE NOVO, ESTE PRAZO + 1 DIA
	   dDTPrazo := U_CalPrv( SF2A->F2_DTEXP, SF2A->A4_DIATRAB, SF2A->ZZ_PRZENT)	   
	   SF2A->(DbSkip())
	
	Enddo
	
	If cEntidade = "SA1"
		dDTRet := dDTPrazo
	Else
		dDTRet := dDatabase		//Date()
	Endif
	
	SF2A->(DbCloseArea())

Endif

If !Empty( dDataSU6 )
	If dDTRet < dDataSU6
    	dDTRet := DataValida( dDataSU6 + 1 )
    Endif			
Else
	dDTRet := DataValida( dDTRet + 1 )
Endif

If Empty(dDTRet)
	dDTRet := CtoD("  /  /    ") 
Endif
	
	
Return(dDTRet) 


//Traz a data de entrega prevista
***************************************
User Function CALLDTENT()
***************************************


Local cQuery := ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= "" //Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= "" //Substr( SU6->U6_CODENT,7,2 )
Local cTransp	:= ""
Local cEntidade := SU6->U6_ENTIDA
Local dDTEntreg := Ctod("  /  /    ")
set date brit


If cNFiscal != ""

	cQuery := " SELECT F2_TRANSP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_TIPO, ZZ_PRZENT, A4_COD, A4_DIATRAB, F2_DTEXP, ZZ_LOCAL,F2_LOCALIZ "
	cQuery += " FROM SF2020 SF2, SA4010 SA4, SZZ010 SZZ "
	cQuery += " WHERE RTRIM(F2_DOC) = '" + Alltrim( cNFiscal ) +"' "
	cQuery += " AND RTRIM(F2_SERIE) = '" + Alltrim( cSrNF ) + "' "
	//If cEntidade = "SA1"
		cCli := Substr( SU6->U6_CODENT,1,6 )
		cLj  := Substr( SU6->U6_CODENT,7,2 )
		cQuery += " AND RTRIM(F2_CLIENTE) = '" + Alltrim( cCli ) +"' "
		cQuery += " AND RTRIM(F2_LOJA) = '" + Alltrim( cLj ) + "' "
	//Elseif cEntidade = "SA4"
	//	cTransp := SU6->U6_CODENT
	//	cQuery += " AND F2_TRANSP = '" + cTransp +"' "		
	//Endif		
	cQuery += " AND F2_TRANSP = A4_COD "
	cQuery += " AND F2_TRANSP = ZZ_TRANSP "
	cQuery += " AND F2_TIPO = 'N' "
	cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA4.D_E_L_E_T_  = ' ' "
	cQuery += " AND SZZ.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
	//cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "
	//cQuery += " AND ZZ_FILIAL = '" + xFilial("SZZ") + "' "
	cQuery += " GROUP BY F2_TRANSP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_TIPO, ZZ_PRZENT, A4_COD, A4_DIATRAB, F2_DTEXP, ZZ_LOCAL,F2_LOCALIZ "
	cQuery += " order by F2_DOC, F2_SERIE "
	MemoWrite("C:\CALLDENTRG.SQL",cQuery)
	
	If Select("SF2B") > 0
		DbSelectArea("SF2B")
		DbCloseArea()	
	EndIf 
	
	TCQUERY cQuery NEW ALIAS "SF2B"
	
	TCSetField( "SF2B", "F2_DTEXP", "D")
	
	SF2B->(Dbgotop())
	While ! SF2B->(EOF())   
	  	     	   
	   dDTEntreg := U_CalPrv( SF2B->F2_DTEXP, SF2B->A4_DIATRAB, SF2B->ZZ_PRZENT)
	   SF2B->(DbSkip())
	
	Enddo	
		
	SF2B->(DbCloseArea())

Endif

If Empty(dDTEntreg)
	dDTEntreg := CtoD("  /  /    ") 
Endif
	
	
Return(dDTEntreg)



***************************************************
Static Function CalcPrazo(dDatsai, cDiatrab, nPrzent)
***************************************************

Local x := 1
Local dData := dDatsai

IF cDiatrab == alltrim(str(3))
   dData += nPrzent	// + 1
Else
   while( x <= nPrzent )           
         dData++
         x++      
   EndDo
Endif

dData := DataValida(dData)         


Return dData

*********************************
Static function FValidata( dData )   
*********************************

//Local lValeDT 		:= .F.
Local nDiaSemana 	:= 0

nDiaSemana := DOW( dData )

If nDiaSemana = 1
	dData := dData + 1 //MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
	//lValeDT := .F.
Elseif nDiaSemana = 7
	dData := dData + 2 //MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
	//lValeDT := .F.
Else
	dData := dData //lValeDT := .T.
Endif


return(dData)
