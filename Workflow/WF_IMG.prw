#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*
//Programa: WF_IMG
//Objetivo: Apagar as imagens do diretório PROTHEUS_DATA\IMAGENS
            Apagar os arqs. html do diretório PROTHEUS_DATA\TEMP
//Autoria : Flávia Rocha
//Data    : 13/02/2012
*/
********************************
User Function WF_IMGTMP()
********************************

  //SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  f_ApagaIMG()      

Return

*****************************
Static Function f_ApagaIMG()  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local cArqA     := ""
Local cArqD     := ""
Local nConta    := 0
Local nDele     := 0

//deleta fotos da pasta \temp que foram usadas para anexar em emails do 5S	
cQuery := " Select " + LF
cQuery += " Z80_FOTOA , Z80_FOTOD, *  " + LF
cQuery += " FROM " + RetSqlName("Z80") + " Z80 " + LF

cQuery += " WHERE " + LF 

//cQuery += " Z80_FILIAL = '" + Alltrim(xFilial("Z80") ) + "' " + LF
cQuery += " Z80.D_E_L_E_T_ = '' " + LF
cQuery += " AND  Z80_EMISSA BETWEEN '" + Dtos(dDatabase - 15) + "' AND '"+ Dtos(dDatabase) + "' " + LF //marco zero
//cQuery += " ORDER BY Z80_FOTOA " + LF
MemoWrite("C:\Temp\WF_IMG.SQL",cQuery)

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

//TCSetField( 'TMPX', "F1_EMISSAO", "D")


TMPX->( DbGotop() )
If !TMPX->(EOF()) 
	While !TMPX->(EOF())
		cArqA := Alltrim(TMPX->Z80_FOTOA)
		cArqD := Alltrim(TMPX->Z80_FOTOD)
		If FERASE("\IMAGENS\" + Alltrim(cArqA) ) == -1   
		   //MsgStop('Falha na deleção do Arquivo: ' + cArq)
		Else   
		   //MsgStop('Arquivo deletado com sucesso.')
		   //nDele++
		   
		Endif
		
		If FERASE("\IMAGENS\" + Alltrim(cArqD) ) == -1   
		   //MsgStop('Falha na deleção do Arquivo: ' + cArq)
		Else   
		   //MsgStop('Arquivo deletado com sucesso.')
		   //nDele++
		   
		Endif
		//nConta++
		TMPX->(DBSKIP())
	Enddo
Endif 

//deleta htm das notas expedidas da pasta \temp
nConta := 0
nDele  := 0
cQuery := " Select " + LF
cQuery += " F2_DOC F2DOC, F2_SERIE, *  " + LF
cQuery += " FROM " + RetSqlName("SF2") + " SF2 " + LF

cQuery += " WHERE " + LF 

cQuery += " F2_DTEXP  = '" + Dtos(dDatabase - 1) + "' " + LF
cQuery += " AND SF2.D_E_L_E_T_ = '' " + LF
cQuery += " ORDER BY F2_FILIAL, F2_DOC " + LF
MemoWrite("C:\Temp\WF_SF2.SQL",cQuery)

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

TMPX->( DbGotop() )
If !TMPX->(EOF()) 
	While !TMPX->(EOF())
		cArqA := Alltrim("nf" + Alltrim(TMPX->F2DOC) + ".htm")
	
		If FERASE("\Temp\" + Alltrim(cArqA) ) == -1   
		   //MsgStop('Falha na deleção do Arquivo: ' + cArqA)
		Else   
		   //MsgStop('Arquivo deletado com sucesso.' + cArqA)
		   nDele++
		   
		Endif	
		nConta++
		TMPX->(DBSKIP())
	Enddo
	//alert("processo finalizado total: " + str(nConta) + " - deletados: " + str(nDele) )
Endif



Reset Environment 
Return