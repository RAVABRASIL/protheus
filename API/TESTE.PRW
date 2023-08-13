#Include "TOTVS.CH"
#Include "RESTFul.CH"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise

WSRESTFUL zWSTest DESCRIPTION "Exemplo de WS com REST"
    //Atributos usados
    //WSDATA {nome do atributo} AS {tipo do atributo como Integer, String, etc}
    WSDATA count AS INTEGER
 
    //Métodos usados
    //WSMETHOD {Tipo do método como PUT, GET, POST e DELETE} {ID do Método} DESCRIPTION {Descrição do Método}
    WSMETHOD GET DateTime DESCRIPTION "Exemplo que retorna a data e hora atual"
    WsMethod POST Description "Sincronização de dados via POST"    WsSyntax "/POST/{method}"

END WSRESTFUL
 
 
WSMETHOD GET DateTime WSRECEIVE count WSSERVICE zWSTest
    Local lRet := .T.
 
    ::SetContentType("application/json")

    ::SetResponse('{"date":' + dToS(Date()) + ', "time":"' + Time() + '"}')
 
 // ::SetResponse('{"date":' + dToS(Date()) + ', "time":"' + Time() + '", "count": ' + cValToChar(::count) + ' }')
Return lRet

//body: jsonencode('{"codigo":"AAC001"}')

WsMethod POST WsService zWSTest
    Local cJson := ::GetContent()
    //Local oParser
    //Local cUser, nUser
    Local cCod, cDesc
    Local oRetJson := JsonObject():New()
    Local Ret

    ::SetContentType( 'application/json' )

    @{Route}
        @{When '/nomeprod'}
        //conout("cJson " + cJson)
        ret := oRetJson:FromJson(cJson)
            //conout("codigo - " + oRetJson:GetJsonText("codigo"))
            If !ValType(ret) == "C" //Len(cJson) > 0 //FwJsonDeserialize(cJson,@oParser)
                cCod    := oRetJson:GetJsonText("codigo") //Parser:codigo
                
                If ValType(cCod) == "U" 
                    conout("codigo - " + oRetJson:GetJsonText("codigo"))
                     SetRestFault(400,'Variavel codigo invalida')
                     return
                Else
                dbSelectArea("SB1")
                dbSeek(xFilial("SB1") + cCod)
                cDesc := SB1->B1_DESC
                //aAdd(aUsers,{cValToChar(oParser:id),oParser:name,cValToChar(oParser:age)})
                //nUser := Len(aUsers)
                /*
                cUser := '{"id":'+ aTail(aUsers)[1]+;
                            ',"name":"'+aUsers[nUser][2]+;
                            '","age":'+aUsers[nUser][3]+'}'
                */
                ::SetResponse(cDesc)
                EndIf
            Else
                conout("Falha ao transformar texto em objeto json. Erro: " + ret)
                SetRestFault(400,'Ops')
                Return .F.
            EndIf
        @{Default}
            SetRestFault(400,"Ops")
            Return .F.
    @{EndRoute}
Return .T.
