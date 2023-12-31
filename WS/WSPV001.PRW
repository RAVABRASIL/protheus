#include 'totvs.ch'
#include 'restful.ch'
#DEFINE LOG_DIRECTORY               "\log_integ"
#DEFINE TYPE_OF_NORMAL_REQUEST      "N"
#DEFINE OPEN_REQUEST                "pedido em aberto"
#DEFINE APPLICATION_CLOSED          "pedido encerrado"
#DEFINE REQUEST_RELEASED            "pedido liberado"
#DEFINE REQUEST_BLOCKED_BY_RULE     "pedido bloqueado por regra"
#DEFINE REQUEST_BLOCKED_BY_FUNDS    "pedido bloqueado por verba"
/*
API para inclus�o e consulta de pedidos de venda
Autor: Rodrigo dos Santos ( www.blacktdn.com.br )
OBS.: Para o release 17 � necess�rio possuir LIB / bin�rio que suporte ID na declara��o do m�todo
*/
WSRESTFUL SalesOrder DESCRIPTION 'API para manuten��o de pedidos de venda' SECURITY 'MATA410' FORMAT APPLICATION_JSON
WSDATA RequestNumber As Character
WSMETHOD POST SalesOrderInclusion   DESCRIPTION 'Inclus�o de pedidos de venda'          WSSYNTAX '/SalesOrder/SalesOrderInclusion'  PRODUCES APPLICATION_JSON
WSMETHOD POST OrderInclusion        DESCRIPTION 'Inclus�o de pedidos de venda'          WSSYNTAX '/SalesOrder/OrderInclusion'       PRODUCES APPLICATION_JSON
WSMETHOD GET  RequestQuery          DESCRIPTION 'Consulta status do pedido de venda'    WSSYNTAX '/SalesOrder{RequestNumber}'       PRODUCES APPLICATION_JSON
ENDWSRESTFUL
/*
SalesOrderInclusion m�todo POST utilizando jSonObject
Autor: Rodrigo dos Santos ( www.blacktdn.com.br )
*/
WSMETHOD POST SalesOrderInclusion WSRECEIVE WSRESTFUL SalesOrder
Local lRet  := .T.
Local aArea := GetArea()
Local aCabec
Local aItens
Local aLinha
Local oJson
Local oItems
Local cJson     := Self:GetContent()
Local cError    
Local nX
Local nY
Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.
Private lAutoErrNoFile  := .T.
//Se n�o existir o diret�rio de logs dentro da Protheus Data, ser� criado
IF .NOT. ExistDir(LOG_DIRECTORY)
	MakeDir(LOG_DIRETCTORY)
EndIF    
//Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
Self:SetContentType("application/json")
oJson   := JsonObject():New()
cError  := oJson:FromJson(cJson)
//Se tiver algum erro no Parse, encerra a execu��o
IF .NOT. Empty(cError)
	SetRestFault(500,'Parser Json Error')
	lRet    := .F.
Else
	//Se encontrar o cliente existente conforme dados do JSON
	DbSelectArea('SA1')
	SA1->(dbSetOrder(1))
	IF (SA1->(dbSeek(FWxFilial("SA1")+PadR(oJson:GetJsonObject('Client'),TamSX3("A1_COD")[1])+PadR(oJson:GetJsonObject('Store'),TamSX3("A1_LOJA")[1]))))
		aCabec  := {}
		aItens  := {}
		/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
		cPedido := GetSXENum("SC5","C5_NUM")
		aAdd(aCabec,{"C5_NUM",  cPedido,    NIL})
		*/
		aAdd(aCabec,{"C5_TIPO",     TYPE_OF_NORMAL_REQUEST,                         NIL})
		aAdd(aCabec,{"C5_CLIENTE",  AllTrim(oJson:GetJsonObject('Client')),         NIL})
		aAdd(aCabec,{"C5_LOJACLI",  AllTrim(oJson:GetJsonObject('Store')),          NIL})
		aAdd(aCabec,{"C5_LOJAENT",  AllTrim(oJson:GetJsonObject('DeliveryStore')),  NIL})
		aAdd(aCabec,{"C5_CONDPAG",  AllTrim(oJson:GetJsonObject('PaymentTerms')),   NIL})
		aAdd(aCabec,{"C5_MENNOTA",  AllTrim(oJson:GetJsonObject('MessageForNote')), NIL})
		aAdd(aCabec,{"C5_NATUREZ",  AllTrim(oJson:GetJsonObject('Nature')),         NIL})
		//Busca os itens no JSON, percorre eles e adiciona no array da SC6
		oItems  := oJson:GetJsonObject('Items')
		For nX  := 1 To Len (oItems)
			aLinha  := {}
			aAdd(aLinha,{"C6_ITEM",     StrZero(nX,2),                                          NIL})
			aAdd(aLinha,{"C6_PRODUTO",  AllTrim(oItems[nX]:GetJsonObject('Product')),           NIL})
			aAdd(aLinha,{"C6_QTDVEN",   oItems[nX]:GetJsonObject('SalesQuantity'),              NIL})
			aAdd(aLinha,{"C6_PRCVEN",   oItems[nX]:GetJsonObject('SalesPrice'),                 NIL})
			aAdd(aLinha,{"C6_VALOR",    oItems[nX]:GetJsonObject('Value'),                      NIL})
			aAdd(aLinha,{"C6_TES",      AllTrim(oItems[nX]:GetJsonObject('InputTypeOutPut')),   NIL})
			aAdd(aItens,aLinha)
		Next nX      
		//Chama a inclus�o autom�tica de pedido de venda
		MsExecAuto({|x, y, z| MATA410(x, y, z)},aCabec,aItens,3)
		//Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
		IF lMsErroAuto
			/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
			RollBackSX8()
			*/
			cArqLog := oJson:GetJsonObject('CLient')+oJson:GetJsonObject('Store')+"-"+ StrTran(Time(), ':', '-')+".log"
			aLogAuto    := {}
			aLogAuto    := GetAutoGrLog()
			For nY := 1 To Len(aLogAuto)
				cErro += aLogAuto[nY] + CRLF
			Next nY
			MemoWrite(LOG_DIRECTORY + cArqLog,cErro)
			SetRestFault(500, cErro)
			lRet    := .F.
		ELSE
			/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
			ConfirmSX8()
			*/
			cJsonRet    := '{"Pedido gerado com sucesso":"'+SC5->C5_NUM+'"}'
			Self:SetResponse(cJsonRet)
		EndIF
	ELSE
		SetRestFault(500,EncodeUTF8("Cliente n�o encontrado"))
		lRet := .F.
	EndIF
EndIf
RestArea(aArea)
FreeObj(oJson)
Return(lRet)
/*
OrderInclusion m�todo POST utilizando FWJsonDeserialize
Autor: Rodrigo dos Santos ( www.blacktdn.com.br )
*/
WSMETHOD POST OrderInclusion WSRECEIVE WSRESTFUL SalesOrder
Local cJson     := Self:GetContent()
Local cJsonRet  := ""
Local cArqLog   := ""
Local cErro     := ""
Local nX
Local nY
Local lRet  := .T.
Local oParseJson    := NIL
Local aArea     := GetArea()
Local aCabec    := {}
Local aItens    := {}
Local aLinha    := {}
Local aLogAuto  := {}
Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.
Private lAutoErrNoFile  := .T.
//Se n�o existir o diret�rio de logs dentro da Protheus Data, ser� criado
IF .NOT. ExistDir(LOG_DIRECTORY)
	MakeDir(LOG_DIRECTORY)
EndIF
//Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
Self:SetContentType("application/json")
If FWJsonDeserialize(cJson,@oParseJson)
	//Se encontrar o cliente existente conforme dados do JSON
	DbSelectArea('SA1')
	SA1->(dbSetOrder(1))
	IF (SA1->(dbSeek(FWxFilial("SA1")+oParseJson:Client+oParseJson:Store)))
		aCabec  := {}
		aItens  := {}
		/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
		cPedido := GetSXENum("SC5","C5_NUM")
		aAdd(aCabec,{"C5_NUM",  cPedido,    NIL})
		*/
		aAdd(aCabec,{"C5_TIPO",     TYPE_OF_NORMAL_REQUEST,             NIL})
		aAdd(aCabec,{"C5_CLIENTE",  AllTrim(oParseJson:Client),         NIL})
		aAdd(aCabec,{"C5_LOJACLI",  AllTrim(oParseJson:Store),          NIL})
		aAdd(aCabec,{"C5_LOJAENT",  AllTrim(oParseJson:DeliveryStore),  NIL})
		aAdd(aCabec,{"C5_CONDPAG",  AllTrim(oParseJson:PaymentTerms),   NIL})
		aAdd(aCabec,{"C5_MENNOTA",  AllTrim(oParseJson:MessageForNote), NIL})
		aAdd(aCabec,{"C5_NATUREZ",  AllTrim(oParseJson:Nature),         NIL})
		//Busca os itens no JSON, percorre eles e adiciona no array da SC6
		For nX  := 1 To Len (oParseJson:Items)
			alinha  := {}
			aAdd(aLinha,{"C6_ITEM",     StrZero(nX,2),                                  NIL})
			aAdd(aLinha,{"C6_PRODUTO",  AllTrim(oParseJson:Items[nX]:Product),          NIL})
			aAdd(aLinha,{"C6_QTDVEN",   oParseJson:Items[nX]:SalesQuantity,             NIL})
			aAdd(aLinha,{"C6_PRCVEN",   oParseJson:Items[nX]:SalesPrice,                NIL})
			aAdd(aLinha,{"C6_VALOR",    oParseJson:Items[nX]:Value,                     NIL})
			aAdd(aLinha,{"C6_TES",      AllTrim(oParseJson:Items[nX]:InputTypeOutPut),  NIL})
			aAdd(aItens,aLinha)
		Next nX      
		//Chama a inclus�o autom�tica de pedido de venda
		MsExecAuto({|x, y, z| MATA410(x, y, z)},aCabec,aItens,3)
		//Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
		IF lMsErroAuto
			/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
			RollBackSX8()
			*/
			cArqLog := oJson:GetJsonObject('CLient')+oJson:GetJsonObject('Store')+"-"+ StrTran(Time(), ':', '-')+".log"
			aLogAuto    := {}
			aLogAuto    := GetAutoGrLog()
			For nY := 1 To Len(aLogAuto)
				cErro += aLogAuto[nY] + CRLF
			Next nY
			MemoWrite(LOG_DIRECTORY + cArqLog,cErro)
			SetRestFault(500,cErro)
			lRet    := .F.
		ELSE
			/* removido trecho abaixo pois o cliente afirma que existe gera��o de numera��o automatica
			ConfirmSX8()
			*/
			cJsonRet    := '{"Pedido gerado com sucesso":"'+SC5->C5_NUM+'"}'
			Self:SetResponse(cJsonRet)
		EndIF
	ELSE
		SetRestFault(500,EncodeUTF8("Cliente n�o encontrado"))
		lRet := .F.
	EndIF
ELSE
	SetRestFault(500,'Parser Json Error')
	lRet    := .F.
EndIf
RestArea(aArea)
Return(lRet)
/*
RequestQuery m�todo GET
Autor: Rodrigo dos Santos ( www.blacktdn.com.br )
*/
WSMETHOD GET RequestQuery WSRECEIVE RequestNumber WSRESTFUL SalesOrder
Local lRet  := .T.
Local cViewSC5  := GetNextAlias()
Local aData := {}
Local oData := NIL
Local _cFil := FWxFilial("SC5")
/*
obrigatorio informar o numero do pedido
*/
Conout(Self:RequestNumber)
IF Empty(Self:RequestNumber)
	SetRestFault(500,EncodeUTF8('O parametro RequestNumber � obrigat�rio'))
	lRet    := .F.
	Return(lRet)
EndIF
/*
montagem da consulta
*/
BeginSQL Alias cViewSC5
	SELECT SC5.C5_FILIAL
	,SC5.C5_NUM
	,SC5.C5_LIBEROK
	,SC5.C5_NOTA
	,SC5.C5_BLQ
	FROM %Table:SC5% SC5
	//WHERE SC5.C5_FILIAL = %FWxFilial:SC5%
	WHERE SC5.C5_FILIAL = %exp:_cFil%
	AND SC5.C5_NUM = %Exp:AllTrim(Self:RequestNumber)%
	AND SC5.%NotDel%
EndSQL    
//Verifica se tem dados na query
dbSelectArea(cViewSC5)
(cViewSC5)->(dbGoTop())
IF (cViewSC5)->(.NOT. Eof())
	//Enquanto houver dados na query
	While (cViewSC5)->(.NOT. Eof())
		//Cria um objeto JSON
		oData           := JsonObject():New()
		//Se o pedido tiver em aberto
		IF Empty((cViewSC5)->C5_LIBEROK) .AND. Empty((cViewSC5)->C5_NOTA) .AND. Empty((cViewSC5)->C5_BLQ)
			oData['status'] := OPEN_REQUEST
			//Se o pedido estiver encerrado
		ELSEIF !Empty((cViewSC5)->C5_NOTA) .OR. (cViewSC5)->C5_LIBEROK=='E' .AND. Empty((cViewSC5)->C5_BLQ)
			oData['status'] := APPLICATION_CLOSED
			//Se o pedido estiver liberado
		ELSEIF !Empty((cViewSC5)->C5_LIBEROK) .AND. Empty((cViewSC5)->C5_NOTA) .AND. Empty((cViewSC5)->C5_BLQ)
			oData['status'] := REQUEST_RELEASED  
			//Se o pedido tiver bloqueio por regra
		ELSEIF (cViewSC5)->C5_BLQ=='1'
			oData['status'] := REQUEST_BLOCKED_BY_RULE
			//Se o pedido tiver bloqueio por verba
		ELSEIF (cViewSc5)->C5_BLQ=='2'
			oData['status'] := REQUEST_BLOCKED_BY_FUNDS
		EndIF
		//Adiciona no array a informa��o e libera o objeto
		aAdd(aData,oData)
		FreeObj(oData)
		(cViewSC5)->(dbSkip())
	EndDo
	//Define o retorno do m�todo
	Self:SetResponse(FwJsonSerialize(aData))
ELSE
	SetRestFault(500,EncodeUTF8('N�o existem dados para serem apresentados'))
	lRet    := .F.
EndIF    
(cViewSC5)->(dbCloseArea())
Return(lRet)