#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

/*
//////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: FATC016.PRW
//Autoria : Flávia Rocha
//Objetivo: Solução de contorno para as notas que, por algum erro na máquina do usuário, 
//          não foi gravado o campo F2_PREVCHG qdo da saída da NF.
///////////////////////////////////////////////////////////////////////////////////////////////////
*/

**************************
User Function FATC016()
************************** 

// Habilitar somente para Schedule
 PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
    F2PREVCHG()
    U4DATA00()
	
 Reset Environment
 
 Return  
 
**************************
User Function FATC016X()
************************** 

// Habilitar somente para Schedule
 PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06"
    F2PREVCHG()
	
 Reset Environment
 
 Return 
 

*****************************
Static Function F2PREVCHG()
*****************************  


Local cQuery	:= ""
Local dPrev		:= CtoD("  /  /    ")
Local cDoc		:= ""
Local cSerie	:= "" 
Local nConta	:= 0
Local nTotReg	:= 0
Local cFil		:= ""


cQuery := " select SF2.F2_FILIAL, SF2.F2_PREVCHG, SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_PREVCHG, " + CHR(13) + CHR(10)
cQuery += " SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_LOCALIZ " + CHR(13) + CHR(10)
cQuery += " from " + RetSqlName("SF2") +" SF2 " + CHR(13) + CHR(10)
cQuery += " where " + CHR(13) + CHR(10)
cQuery += " SF2.F2_DTEXP <> '' " + CHR(13) + CHR(10)
cQuery += " and SF2.F2_PREVCHG = '' " + CHR(13) + CHR(10)
cQuery += " and SF2.F2_EMISSAO >= '20091201' " + CHR(13) + CHR(10)
cQuery += " and SF2.F2_TIPO = 'N' " + CHR(13) + CHR(10)
cQuery += " and SF2.F2_SERIE ='0' " + CHR(13) + CHR(10)
cQuery += " and SF2.D_E_L_E_T_ = ''  " + CHR(13) + CHR(10)
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + CHR(13) + CHR(10)
//cQuery += " and SF2.F2_FILIAL = '03' "

//cQuery += " and SF2.F2_DOC = '000004792' "  + CHR(13) + CHR(10) 

cQuery += "order by SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE" + CHR(13) + CHR(10)
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
    
	dPrev	:= U_FATC005( SF2XX->F2_FILIAL,SF2XX->F2_DOC, SF2XX->F2_SERIE, SF2XX->F2_TRANSP, SF2XX->F2_REDESP, SF2XX->F2_LOCALIZ ) 
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
				nConta++
			//Else 
				//msgbox("dprev vazio " + cDoc)
				
			Endif
			
			If Alltrim(SF2XX->F2_TRANSP) = '024' //cliente retira
				Reclock("SF2", .F.)
				SF2->F2_PREVCHG := SF2XX->F2_DTEXP
				SF2->(MsUnlock())
				nConta++
			Endif
			
			SF2->(Dbskip())
		Enddo
	//Else
	//	Msgbox("NF não encontrada-->" + cDoc )
	Endif
	nTotReg++
	DbselectArea("SF2XX")
	SF2XX->(DBSKIP())
Enddo

//MsgINFO("FIM DO PROCESSO --> registros totais: " + str(nTotReg) + ", atualizados: " + str(nConta) )


DbselectArea("SF2XX")
DbcloseArea() 

*****************************
Static Function U4DATA00()
***************************** 

//atualiza U4_DATA
nTotReg := 0
nConta  := 0
cQuery := " Select U4_FILIAL, U4_LISTA, U4_DATA U4DATA, UC_PREVCHG,U4_DESC, U4_DATA, U4_STATUS, U4_OPERAD, U4_TIPO
cQuery += " FROM " + RetSqlName("SU4") + " U4, "
cQuery += " "      + RetSqlName("SUC") + " UC  "
cQuery += " WHERE UC_CODIGO = U4_CODLIG  "
cQuery += " AND UC_FILIAL = U4_FILIAL  "
cQuery += " AND U4_TIPO = '1'  "
cQuery += " AND U4_STATUS = '1'  "
cQuery += " AND U4_DATA  <= '20000101'   "
cQuery += " AND UC.D_E_L_E_T_ = ''  "
cQuery += " AND U4.D_E_L_E_T_ = ''  "
cQuery += " order by U4_FILIAL, U4_LISTA   " 
//MemoWrite("C:\Temp\U4DATA00.SQL", cQuery )
If Select("U4X") > 0
	DbSelectArea("U4X")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "U4X"
U4X->( DbGotop() )
Do While !U4X->( Eof() ) 
	DbSelectArea("SU4")
	DbSetOrder(1)          // U4_FILIAL + U4_LISTA
	If SU4->(DbSeek( U4X->U4_FILIAL + U4X->U4_LISTA ))
		RecLock("SU4",.F.)						
		SU4->U4_DATA	:= DataValida(U4X->UC_PREVCHG + 1) 
		SU4->(MsUnLock())
		nConta++
	Endif       
	nTotReg++
	DbselectArea("U4X")
	U4X->(DBSKIP())

Enddo
//MsgINFO("FIM DO PROCESSO --> registros totais: " + str(nTotReg) + ", atualizados: " + str(nConta) )

// Habilitar somente para Schedule
//Reset environment


Return


