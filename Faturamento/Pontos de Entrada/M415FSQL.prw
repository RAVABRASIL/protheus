#Include "Rwmake.ch"


//*****************************************************************************************
// Descricao -> Ponto de Entrada que permite filtrar os orçamentos exibidos na mBrowse, 
// em que deve ser informada uma expressão SQL dentro do orcamento
//*****************************************************************************************

USER FUNCTION M415FSQL() 

Local cFiltro := "" 
Local cVend	:= ""
//Local aArea	:= GetArea()
Local cUserLib	:= AllTrim(GetNewPar("MV_XVENLIB","000000/000000"))

dbSelectArea("SA3")
dbSetOrder(7)

If dbSeek(xFilial("SA3") + RetCodUsr()) .AND. !(RetCodUsr() $ cUserLib)

	cFiltro := "CJ_VEND1 = '" + SA3->A3_COD + "'"

EndIf

//MSGAlert(cFiltro)
//RestArea(aArea)

Return(cFiltro)