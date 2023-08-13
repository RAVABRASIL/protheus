#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


********************************
User Function TMKC017()
********************************

Local cQuery := ""
Local cLista := ""
Local cCodlig:= "" 

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
	fStatusU6()
	
Reset Environment

U_TMKC017CX()

Return

//PARA A FILIAL CAIXAS - 03
********************************
User Function TMKC017CX()
********************************

Local cQuery := ""
Local cLista := ""
Local cCodlig:= "" 


// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" 
	fStatusU6()
	
Reset Environment

Return



*****************************
Static Function fStatusU6()
*****************************

Local cQuery := ""
Local cLista := ""
Local cCodlig:= "" 
Local LF	 := CHR(13) + CHR(10)

cQuery := " SELECT U6_FILIAL,U6_LISTA, U6_CODLIG, U6_DATA, U6_CODIGO, U6_DTBASE, U6_STATUS " + LF
cQuery += " FROM " + RetSqlName("SU6") + " SU6, " + LF
cQuery += " " + RetSqlName("SU4") + " SU4 " + LF

cQuery += " WHERE " + LF
cQuery += " U4_FILIAL = U6_FILIAL AND " + LF
cQuery += " U4_LISTA = U6_LISTA AND   " + LF
cQuery += " U6_FILIAL = '" + xFilial("SU6") + "' AND SU6.D_E_L_E_T_ <>'*' AND " + LF
cQuery += " U4_FILIAL = '" + xFilial("SU4") + "' AND SU4.D_E_L_E_T_ <>'*' AND " + LF
cQuery += " U4_STATUS = '2' AND " + LF
cQuery += " U6_STATUS  <> '3' " + LF

cQuery += " ORDER BY U6_LISTA, U6_CODLIG " + LF
MemoWrite("C:\Temp\STATUS2SU6.SQL", cQuery )

If Select("SU6X") > 0
	DbSelectArea("SU6X")
	DbCloseArea()	
EndIf 
  
TCQUERY cQuery NEW ALIAS 'SU6X'

SU6X->( dbGoTop() )
While SU6X->( !EoF() )
	
	cLista := SU6X->U6_LISTA
	cCodlig:= SU6X->U6_CODLIG

	DbSelectArea("SU6")
	DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO		
	If SU6->(DbSeek(xFilial("SU6") + cLista ))	
		While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == cCodLig;
		.And. SU6->U6_LISTA == cLista 				
			If SU6->U6_STATUS = "2"		
				RecLock("SU6",.F.)
				SU6->U6_STATUS := "3"       // 3=Enviado, 2= Em Uso -> Desta forma, ficará com a legenda verde na lista, aparecendo ainda na tela calendário
				SU6->(MsUnLock())
			Endif
			SU6->(DbSkip())
		EndDo
	Endif
	DbselectArea("SU6X")
	SU6X->(Dbskip())
Enddo 

DbselectArea("SU6")
SU6->(DbCloseArea())         

DbselectArea("SU6X")
SU6X->(DbCloseArea()) 

// Habilitar somente para Schedule
//Reset environment

Return




