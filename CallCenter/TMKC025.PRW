#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//////TORNA U4_OPERAD = '000011' (ANDREIA), OS REGISTROS COM U4_OPERAD = '000006' (DANIELA)
////SOLUÇÃO DE CONTORNO
********************************
User Function TMKC025()
********************************

Local cQuery := ""
Local cLista := ""
Local cCodlig:= ""
Local nConta := 0  
Local LF	 := CHR(13) + CHR(10)
Local cOper		:= GetNewPar("MV_XOPERTM","000018")

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

cQuery := " SELECT U4_FILIAL, U4_LISTA, U4_CODLIG, U4_DATA, U4_OPERAD, U4_DESC, U4_STATUS "
cQuery += " FROM " + RetSqlName("SU4") + " SU4 "
cQuery += " WHERE D_E_L_E_T_ <>'*'  "
cQuery += " and U4_FILIAL = '" + xFilial("SU4") + "' "
cQuery += " and U4_STATUS = '1'  and U4_OPERAD = '" + cOper + "' "
cQuery += " ORDER BY U4_LISTA, U4_DATA "
MemoWrite("\Temp\OPERAD_U4.SQL", cQuery )

If Select("SU4X") > 0
	DbSelectArea("SU4X")
	DbCloseArea()	
EndIf 
  
TCQUERY cQuery NEW ALIAS 'SU4X'

SU4X->( dbGoTop() )
While SU4X->( !EoF() )
	
	cLista := SU4X->U4_LISTA
	cCodlig:= SU4X->U4_CODLIG

	DbSelectArea("SU4")
	DbSetOrder(1)          // U4_FILIAL + U4_LISTA
	If SU4->(DbSeek(xFilial("SU4") + cLista ))

		While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And.  SU4->U4_LISTA == cLista 				
			RecLock("SU4",.F.)
			SU4->U4_OPERAD := cOper //"000017"       
			nConta++
			SU4->(MsUnLock())
			
			SU4->(DbSkip())
		EndDo
	Endif
	DbselectArea("SU4X")
	SU4X->(Dbskip())
Enddo

//If nConta > 0
//	MsgInfo("Existiam -> " + Str(nConta,2) + " registros com operador = 000006 ")
//Else
//	MsgInfo("Não existe nenhum registro com status = 2 " )
//Endif 

DbselectArea("SU4")
SU4->(DbCloseArea())         

DbselectArea("SU4X")
SU4X->(DbCloseArea()) 

// Habilitar somente para Schedule
Reset environment

Return