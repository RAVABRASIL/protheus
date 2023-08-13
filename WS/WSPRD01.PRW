#include 'totvs.ch'
#include 'restful.ch'
#DEFINE LOG_DIRECTORY               "\log_integ"
#DEFINE TYPE_OF_NORMAL_REQUEST      "N"
/*
API para Consulta de Produtos
Autor: Gustavo Costa
OBS.: Para o release 17 é necessário possuir LIB / binário que suporte ID na declaração do método
*/
WSRESTFUL Produtos DESCRIPTION 'API para consultar os Produtos' SECURITY 'MATA010' FORMAT APPLICATION_JSON

	WSDATA RequestNumber As Character
	WSDATA UF As Character

WSMETHOD GET  RequestQuery          DESCRIPTION 'Consulta Produto'    WSSYNTAX '/Produtos{RequestNumber}'       PRODUCES APPLICATION_JSON
ENDWSRESTFUL


/*
RequestQuery método GET
Autor: Gustavo Costa
*/
WSMETHOD GET RequestQuery WSRECEIVE RequestNumber WSRESTFUL Produtos
Local lRet  := .T.
Local cViewSB1  := GetNextAlias()
Local aData := {}
Local oData := NIL
Local _cFil := FWxFilial("SB1")
/*
obrigatorio informar o numero do pedido
*/
Conout(Self:RequestNumber)
IF Empty(Self:RequestNumber)
	SetRestFault(500,EncodeUTF8('O parametro RequestNumber é obrigatório'))
	lRet    := .F.
	Return(lRet)
EndIF
/*
montagem da consulta
*/
BeginSQL Alias cViewSB1
	SELECT SB1.B1_COD
	,SB1.B1_DESC
	,Z36.Z36_MRG01
	FROM %Table:SB1% SB1
	INNER JOIN %Table:Z36% Z36
	ON B1_COD = Z36_PROD
	WHERE SB1.B1_FILIAL = %exp:_cFil%
	AND SB1.B1_COD = %Exp:AllTrim(Self:RequestNumber)%
	AND Z36.Z36_UF = %Exp:AllTrim(Self:UF)%
	AND SB1.%NotDel%
	AND Z36.%NotDel%
EndSQL    
//Verifica se tem dados na query
dbSelectArea(cViewSB1)
(cViewSB1)->(dbGoTop())
IF (cViewSB1)->(.NOT. Eof())
	//Enquanto houver dados na query
	While (cViewSB1)->(.NOT. Eof())
		//Cria um objeto JSON
		oData           := JsonObject():New()
		//Se o pedido tiver em aberto
		oData['codigo'] := (cViewSB1)->B1_COD
		oData['produto'] := (cViewSB1)->B1_DESC
		oData['valorTabela'] := (cViewSB1)->Z36_MRG01

		//Adiciona no array a informação e libera o objeto
		aAdd(aData,oData)
		FreeObj(oData)
		(cViewSB1)->(dbSkip())
	EndDo
	//Define o retorno do método
	Self:SetResponse(FwJsonSerialize(aData))
ELSE
	SetRestFault(500,EncodeUTF8('Não existem dados para serem apresentados'))
	lRet    := .F.
EndIF    
(cViewSB1)->(dbCloseArea())
Return(lRet)