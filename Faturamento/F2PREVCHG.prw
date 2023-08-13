#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


**************************
User Function F2PREVCHG()
************************** 

Local cQuery	:= ""
Local dPrev		:= CtoD("  /  /    ")
Local cDoc		:= ""
Local cSerie	:= "" 
Local nConta	:= 0

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

cQuery := " select SF2.F2_PREVCHG, SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_PREVCHG, "
cQuery += " SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_LOCALIZ "
cQuery += " from " + RetSqlName("SF2") +" SF2 "
cQuery += " where "
cQuery += " SF2.F2_DTEXP <> '' "
cQuery += " and SF2.F2_PREVCHG = '' "
cQuery += " and SF2.F2_EMISSAO >= '20091201' "
cQuery += " and SF2.F2_TIPO = 'N' "
cQuery += " and SF2.F2_SERIE ='0' "
cQuery += " and SF2.D_E_L_E_T_ = ''  "
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"
MemoWrite("C:\Temp\F2PREVCHG.SQL", cQuery )
cQuery := ChangeQuery( cQuery )

If Select("SF2XX") > 0
	DbSelectArea("SF2XX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2XX"
TCSetField( 'SF2XX', "F2_EMISSAO", "D")
TCSetField( 'SF2XX', "F2_DTEXP", "D")
TCSetField( 'SF2XX', "F2_PREVCHG", "D")

SF2XX->( DbGotop() )
Do While !SF2XX->( Eof() )
    
	dPrev	:= U_FATC005( SF2XX->F2_DOC, SF2XX->F2_SERIE, SF2XX->F2_TRANSP, SF2XX->F2_REDESP, SF2XX->F2_LOCALIZ ) 
	//fGetPrazo( cNF, cSerie, cTransp, cRedesp, cLocaliz )
	//DbselectArea("SF2A")
	cDoc	:= SF2XX->F2_DOC
	cSerie	:= SF2XX->F2_SERIE
	
	DbselectArea("SF2")
	SF2->(Dbsetorder(1))
	If SF2->(Dbseek(xFilial("SF2") + cDoc + cSerie ))
		While !SF2->(EOF()) .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC == cDoc .and. SF2->F2_SERIE == cSerie
			
			If !Empty( dPrev )
				Reclock("SF2", .F.)
				SF2->F2_PREVCHG := dPrev
				SF2->(MsUnlock())
			//Else 
				//msgbox("dprev vazio " + cDoc)
				nConta++
			Endif
			SF2->(Dbskip())
		Enddo
	Else
		Msgbox("NF não encontrada-->" + cDoc )
	Endif
	
	DbselectArea("SF2XX")
	SF2XX->(DBSKIP())
Enddo

MsgINFO("FIM DO PROCESSO --> registros: " + str(nConta) )

DbselectArea("SF2XX")
DbcloseArea() 

// Habilitar somente para Schedule
Reset environment


Return


