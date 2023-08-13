#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGeraPN  ºAutor  ³  Gustavo Costa       º Data ³ 12/11/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para gerar a Pre Nota a partir do XML importado.     º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fGeraPN(aCabec, aPedIte)

Local nOpc 			:= 0 
Local aCab				:= aCabec
Local aIT				:= aPedIte
Local aLinha			:= {}
Local aArea			:= getArea()	
Local cCampo			:= ""
Local cCampoF1		:= "F1_STATUS#F1_TPCTE"
Local cCampoD1		:= "D1_TEC#D1_VUNITF#D1_SEGUM"
Local cChaveNFE		:= ""
Local lRet				:= .F.
Local cPathLog 		:= "\XML\LOG\"
Local cArqTxt 		:= DtoS(dDataBase) + "X" + ".log"

Private _aCabec			:= {}
Private _aItens			:= {}
Private lMsErroAuto  	:= .F.
//Private lMsHelpAuto 		:= .F.
//Private lAutoErrNoFile 	:= .F.

dbSelectArea("SX3")
dbSetOrder(2)

For i := 1 To Len(aCab)

	If SX3->(dbSeek( SubStr(aCab[i][1],2,10) )) .AND. !(AllTrim(SubStr(aCab[i][1],2,10)) $ cCampoF1)
		cCampo		:= SX3->X3_CAMPO
	Else
		loop
	EndIf
	
	AADD(aLinha, {cCampo, aCab[i][2], NIL} )
	
	If AllTrim(cCampo) == 'F1_CHVNFE'
		cChaveNFE	:= aCab[i][2]
	EndIf
	
Next i

_aCabec :=	{	{'F1_FORMUL'	,'N'			,NIL}}
			
For i := 1 To Len(aLinha)

	AADD (_aCabec, aLinha[i])

Next i

aCabec2 :=	{	{'F1_TIPO'	,'N'		,NIL},;		
			{'F1_FORMUL','S'		,NIL},;
			{'F1_DOC'	,"999999"    	,NIL},;
			{'F1_SERIE','   '		,NIL},;
			{'F1_EMISSAO',dDataBase	,NIL},;		
			{'F1_FORNECE','000002'	,NIL},;		
			{'F1_LOJA'	,'01'		,NIL},;		
			{'F1_COND','001'		,NIL} }				


aLinha	:= {}

For j := 1 To len(aIT)

	For k := 1 To Len(aIT[j])
		
		If SX3->(dbSeek( SubStr(aIT[j][k][1],2,10) )) .AND. !(AllTrim(SubStr(aIT[j][k][1],2,10)) $ cCampoD1)
		
			cCampo		:= SX3->X3_CAMPO
	
			AADD(aLinha, {cCampo, aIT[j][k][2] , NIL} )
		
		EndIf
	
	Next k
	
	AAdd(_aItens, aLinha)
	
Next j

aItens2 :=	{	{'D1_COD'	,"PA02"			,NIL},;		
				{'D1_UM'	,'UN'			,NIL},;				
				{'D1_QUANT',1			,NIL},;		
				{'D1_VUNIT',10000			,NIL},;		
				{'D1_TOTAL',10000			,NIL},;		
				{'D1_PEDIDO','000009'			,NIL},;		
				{'D1_ITEMPC','0001'			,NIL},;		
				{'D1_LOCAL','01'			,NIL}	}


nOpc := 3

BEGIN TRANSACTION

lOk	:= MSExecAuto({|x,y,z| MATA140(x,y,z)}, _aCabec, _aItens, nOpc)     

If lMsErroAuto      

	//MostraErro(cPathLog, cArqTxt)
	MostraErro()
	DisarmTransaction()
	
Else   
	
	lRet	:= .T.

	dbSelectArea("ZF1")
	dbSetOrder(2)
	If ZF1->(dbSeek(cChaveNFE))
	
		RecLock("ZF1",.F.)
		
		//Finaliza o XML
		ZF1->ZF1_STATUS	:= '3'
		
		ZF1->(MsUnlock())
		
	EndIf
	
	//Alert("Ponto de entrada MATA140 executado com sucesso!")		

EndIf
END TRANSACTION

RestArea(aArea)

Return lRet