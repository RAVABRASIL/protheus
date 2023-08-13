#include 'totvs.ch'
#include 'restful.ch'
#DEFINE LOG_DIRECTORY               "\log_integ"

/*
API para Consulta de Clientes por vendedor
Autor: Gustavo Costa
OBS.: Para o release 17 é necessário possuir LIB / binário que suporte ID na declaração do método
*/

WSRESTFUL ListaClientes DESCRIPTION 'API para consultar os Clientes' SECURITY 'MATA030' FORMAT APPLICATION_JSON

	WSDATA codVend As Character
	WSDATA searchKey AS Character 
	
	WSMETHOD GET  RequestQuery          DESCRIPTION 'Lista Clientes'    WSSYNTAX '/ListaClientes'       PRODUCES APPLICATION_JSON

ENDWSRESTFUL


/*
RequestQuery método GET
Autor: Gustavo Costa
*/
WSMETHOD GET RequestQuery WSRECEIVE codVend WSRESTFUL ListaClientes
Local lRet  := .T.
Local cViewSA1  := GetNextAlias()
Local aData := {}
Local oData := NIL
Local _cFil := FWxFilial("SA1")
Local _cNome	:= '% %'
Local cWhere	:= ""
/*
obrigatorio informar o numero do pedido
*/
Conout(Self:codVend)
IF Empty(Self:codVend)
	SetRestFault(500,EncodeUTF8('O parametro codVend é obrigatório'))
	lRet    := .F.
	Return(lRet)
EndIF

Conout(Self:searchKey)
cSearch := AllTrim( Upper( Self:SearchKey ) )

IF !Empty(Self:searchKey)
	cWhere := " AND SA1.A1_NOME LIKE '%" + FwNoAccent( cSearch ) + "%' "
Else
	cWhere := " AND SA1.A1_NOME LIKE '% %' "
EndIF
cWhere := '%'+cWhere+'%'

Conout("cWhere " + cWhere)

/*
montagem da consulta
*/

BeginSQL Alias cViewSA1
	SELECT SA1.A1_COD
	,SA1.A1_LOJA
	,SA1.A1_NOME
	,SA1.A1_NREDUZ
	FROM %Table:SA1% SA1
//	INNER JOIN %Table:Z36% Z36
//	ON B1_COD = Z36_PROD
	WHERE SA1.A1_FILIAL = %exp:_cFil%
	AND SA1.A1_VEND = %Exp:AllTrim(Self:codVend)%
	AND SA1.%NotDel%
	%Exp:cWhere%
	//AND Z36.%NotDel%
EndSQL    
//Verifica se tem dados na query
dbSelectArea(cViewSA1)
(cViewSA1)->(dbGoTop())
IF (cViewSA1)->(.NOT. Eof())
	//Enquanto houver dados na query
	While (cViewSA1)->(.NOT. Eof())
		//Cria um objeto JSON
		oData           := JsonObject():New()
		//Se o pedido tiver em aberto
		oData['codigo'] := (cViewSA1)->A1_COD
		oData['loja'] := (cViewSA1)->A1_LOJA
		oData['nome'] := (cViewSA1)->A1_NOME
		oData['fantasia'] := (cViewSA1)->A1_NREDUZ

		//Adiciona no array a informação e libera o objeto
		aAdd(aData,oData)
		FreeObj(oData)
		(cViewSA1)->(dbSkip())
	EndDo
	//Define o retorno do método
	Self:SetResponse(FwJsonSerialize(aData))
ELSE
	SetRestFault(500,EncodeUTF8('Não existem dados para serem apresentados'))
	lRet    := .F.
EndIF    
(cViewSA1)->(dbCloseArea())
Return(lRet)