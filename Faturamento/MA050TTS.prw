#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

/*////////////////////////////////////////////////////////////////////////
//Programa: MA050TTS - Ponto de entrada após a gravação da Transportadora
//Objetivo: Ao inserir as informações no SA4, irá gravar no cadastro SZZ
//Autoria : Flávia Rocha
//Data    : 15/04/2010
/*////////////////////////////////////////////////////////////////////////

//DESATIVAR ESTE P.E. POR SOLICITAÇÃO DE EMANUEL EM 10/11/2011.
//POR FLAVIA ROCHA

********************************
User Function MA050TTS() 
********************************

Local cxArea	:= GetArea()
Local lRet  	:= .T.
Local cCodTransp:= SA4->A4_COD
Local cQuery	:= ""
Local LF 		:= CHR(13)+CHR(10)
Local nA4_GRIS	:= SA4->A4_GRIS
Local nA4_1A10KG := SA4->A4_1A10KG
Local nA4_11A20KG:= SA4->A4_11A20KG
Local nA4_21A30KG:= SA4->A4_21A30KG
Local nA4_31A40KG:= SA4->A4_31A40KG
Local nA4_41A50KG:= SA4->A4_41A50KG
Local nA4_51A60KG:= SA4->A4_51A60KG
Local nA4_61A70KG:= SA4->A4_61A70KG
Local nA4_71A80KG:= SA4->A4_71A80KG
Local nA4_81A90KG:= SA4->A4_81A90KG
Local nA4_91A100K:= SA4->A4_91A100K
Local nA4_COLETA := SA4->A4_COLETA
Local nA4_ENTREGA:= SA4->A4_ENTREGA
Local nA4_DESPACH:= SA4->A4_DESPACH
Local nA4_ITR_R  := SA4->A4_ITR_R
Local nA4_ITR_EXM:= SA4->A4_ITR_EXM
Local nA4_CATDESP:= SA4->A4_CATDESP
Local nA4_ICMS   := SA4->A4_ICMS
Local nZZReg	 := 0

If Altera

	Dbselectarea("SZZ")
	SZZ->(Dbsetorder(1))
	SZZ->(Dbseek(xFilial("SZZ") + cCodTransp)) 
	Do While SZZ->ZZ_FILIAL == xFilial("SZZ") .and. Alltrim(SZZ->ZZ_TRANSP) == Alltrim(cCodTransp)
		
		Reclock("SZZ", .F.)
		SZZ->ZZ_GRIS   := nA4_GRIS
		SZZ->ZZ_1A10KG := nA4_1A10KG
		SZZ->ZZ_11A20KG:= nA4_11A20KG
		SZZ->ZZ_21A30KG:= nA4_21A30KG
		SZZ->ZZ_31A40KG:= nA4_31A40KG
		SZZ->ZZ_41A50KG:= nA4_41A50KG
		SZZ->ZZ_51A60KG:= nA4_51A60KG
		SZZ->ZZ_61A70KG:= nA4_61A70KG
		SZZ->ZZ_71A80KG:= nA4_71A80KG
		SZZ->ZZ_81A90KG:= nA4_81A90KG
		SZZ->ZZ_91A100K:= nA4_91A100K
		SZZ->ZZ_COLETA := nA4_COLETA
		SZZ->ZZ_ENTREGA:= nA4_ENTREGA
		SZZ->ZZ_DESPACH:= nA4_DESPACH
		SZZ->ZZ_ITR    := nA4_ITR_R
		SZZ->ZZ_ITR2   := nA4_ITR_EXM
		SZZ->ZZ_CATDESP:= nA4_CATDESP
		SZZ->ZZ_ALIQICM:= nA4_ICMS
		SZZ->(MsUnlock())
		nZZReg++
	
		SZZ->(Dbskip())
	Enddo


//Msgbox("Registros Atualizados SZZ: " + Str(nZZReg) )
Endif

RestArea(cxArea)


Return lRet
