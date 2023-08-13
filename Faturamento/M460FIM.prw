#Include "Rwmake.ch"
#INCLUDE "Topconn.CH"
#include "protheus.ch"
#include "TbiConn.ch"

/*/
//------------------------------------------------------------------------------------
//Programa: M460FIM - Ponto de Entrada na geração da NF Saída (após a transação) 
//Objetivo: Após a geração da NF saída, acionar a função WFMP p/
//          Enviar e-mail avisando sobre saída de NF de Produto tipo MP
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 22/09/2010
//------------------------------------------------------------------------------------
/*/

**************************
User Function M460FIM  
**************************
Local aArea	:= getArea()
Local _aParametros := {SF2->F2_DOC, SF2->F2_SERIE}
Local _aCab1, _aItem, _aProds := {}
Local nXHndERP 	:= AdvConnection()

U_WFMP( SF2->F2_DOC, SF2->F2_SERIE, "S" )

//Grava informação da venda pra um cliente inativo e avisa ao representante.
//fVendaInat()

//**************************************************************
//Se vender da Rava para Nova, já lança os produtos no estoque da Nova
//**************************************************************
//conout("FILIAL" + FWCodFil() + "CLIENTE" + SF2->F2_CLIENTE)
If SF2->F2_CLIENTE == "006543" //NOVA

	conout("Entrou na transferencia para NOVA")
	_aCab1 := { {"D3_TM" ,"003" , NIL},;
				{"D3_DOC" ,SF2->F2_DOC ,NIL},;
				{"D3_EMISSAO" ,ddatabase, NIL}} 

	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial("SD2")+SD2->D2_TES)

	If SF4->F4_ESTOQUE = 'S'
	
		dbSelectArea("SD2")
	
		While SD2->(!Eof()) .And. xFilial("SD2") == SD2->D2_FILIAL .And.;
						SF2->F2_SERIE == SD2->D2_SERIE .And.;
						SF2->F2_DOC == SD2->D2_DOC
	
			_aItem :={ { "D3_TM", "003", ""},;
	                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
	                 { "D3_LOCAL", '01', NIL },;
	                 { "D3_DOC", SD2->D2_DOC, NIL},;
	                 { "D3_COD", SD2->D2_COD, NIL},;
	                 { "D3_UM", SD2->D2_UM, NIL },;
	                 { "D3_QUANT",SD2->D2_QUANT , NIL },;
	                 { "D3_OBS", SD2->D2_DOC, NIL},;
	                 { "D3_EMISSAO", ddatabase, NIL} }
	        AADD(_aProds,_aItem)
	
			SD2->(dbSkip())
	
		EndDo
		
		conout("antes do StartJob")
		
		_aParametros := {_aCab1, _aProds, nXHndERP, "06"}
		
		StartJob("U_fTransNova",getenvserver(),.T.,_aParametros)
		
		conout("depois do StartJob")
		
	EndIf

EndIf

//**************************************************************
//Se vender da Rava para Nova, já lança os produtos no estoque da TOTAL
//**************************************************************
//TRANSFERENCIA PARA TOTAL
If SF2->F2_CLIENTE == "007005" //TOTAL

	conout("Entrou na transferencia para TOTAL")
	_aCab1 := { {"D3_TM" ,"003" , NIL},;
				{"D3_DOC" ,SF2->F2_DOC ,NIL},;
				{"D3_EMISSAO" ,ddatabase, NIL}} 

	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial("SD2")+SD2->D2_TES)

	If SF4->F4_ESTOQUE = 'S'
	
		dbSelectArea("SD2")
	
		While SD2->(!Eof()) .And. xFilial("SD2") == SD2->D2_FILIAL .And.;
						SF2->F2_SERIE == SD2->D2_SERIE .And.;
						SF2->F2_DOC == SD2->D2_DOC
	
			_aItem :={ { "D3_TM", "003", ""},;
	                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
	                 { "D3_LOCAL", '01', NIL },;
	                 { "D3_DOC", SD2->D2_DOC, NIL},;
	                 { "D3_COD", SD2->D2_COD, NIL},;
	                 { "D3_UM", SD2->D2_UM, NIL },;
	                 { "D3_QUANT",SD2->D2_QUANT , NIL },;
	                 { "D3_OBS", SD2->D2_DOC, NIL},;
	                 { "D3_EMISSAO", ddatabase, NIL} }
	        AADD(_aProds,_aItem)
	
			SD2->(dbSkip())
	
		EndDo
		
		conout("antes do StartJob")
		
		_aParametros := {_aCab1, _aProds, nXHndERP, "07"}
		
		StartJob("U_fTransNova",getenvserver(),.T.,_aParametros)
		
		conout("depois do StartJob")
	EndIf
EndIf

//**************************************************************
//Se movimenta na empresa 99, ajusta estoque da empresa 01
//**************************************************************
If FWCodEmp() == "99" .and. GetEnvServer() == "P1216"

	_aCab1 := { {"D3_TM" ,"503" , NIL},;
				{"D3_DOC" ,SF2->F2_DOC ,NIL},;
				{"D3_EMISSAO" ,ddatabase, NIL}} 

	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	
	While SD2->(!Eof()) .And. xFilial("SD2") == SD2->D2_FILIAL .And.;
					SF2->F2_SERIE == SD2->D2_SERIE .And.;
					SF2->F2_DOC == SD2->D2_DOC
					/*
		_aItem:={ 	{"D3_COD" ,SD2->D2_COD ,NIL},;
					{"D3_UM" ,SD2->D2_UM ,NIL},; 
					{"D3_QUANT" ,SD2->D2_QUANT ,NIL},;
					{"D3_LOCAL" ,"01" ,NIL},;
					{"D3_LOTECTL" ,"" ,NIL}}
					*/
		/*AADD(_aItem, { { "D3_TM", "003", NIL},;
					{ "D3_DOC", SD2->D2_DOC, NIL},;
					{ "D3_FILIAL", xFilial( "SD3" ), NIL},;
					{ "D3_LOCAL", "01", NIL },;
					{ "D3_COD", SD2->D2_COD, NIL},;
					{ "D3_QUANT", SD2->D2_QUANT, NIL },;
					{ "D3_EMISSAO", dDATABASE, NIL} } )
					*/
_aItem :={ { "D3_TM", "003", ""},;
                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                 { "D3_LOCAL", '01', NIL },;
                 { "D3_COD", SD2->D2_COD, NIL},;
                 { "D3_UM", SD2->D2_UM, NIL },;
                 { "D3_QUANT",SD2->D2_QUANT , NIL },;
                 { "D3_OBS", SD2->D2_DOC, NIL},;
                 { "D3_EMISSAO", ddatabase, NIL} }
					
		SD2->(dbSkip())

 //               { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
 	EndDo
	
	_aParametros := {_aCab1, _aItem}
	StartJob("U_fBxEstAdm",getenvserver(),.T.,_aParametros)
	
EndIf

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fVendaInat º Autor ³ Gustavo Costa     º Data ³  22/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para enviar um email com a nota      º±±
±±º          ³ faturada pra um cliente inativo                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fVendaInat()

Local cTitulo  	:= ""//"ORCAMENTO - " + SCJ->CJ_NUM
Local cCopia 	:= ""//GetNewPar('RV_XCOPBLQ',"gustavo@ravaembalagens.com.br")
Local cMailTo 	:= ""//"gustavo@ravaembalagens.com.br"
Local cConteudo	:= ""
Local aArea 	:= GetArea()
lOCAL nTotal	:= 0
lOCAL nTotalIPI	:= 0
Local nVendasI	:= 1

//dbSelectArea("SCJ")
//dbSeek(xFilial("SCJ") + M->CJ_NUM)

cTitulo  	:= "NOTA FISCAL - " + SF2->F2_DOC + "-" + SF2->F2_SERIE

cMailTo := "comercial@ravaembalagens.com.br"             

dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3") + SF2->F2_VEND1)
	cMailTo := cMailTo + ";" + AllTrim(SA3->A3_EMAIL)
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)

/*
//Se o cliente não estiver marcado como inativo sai 
If SA1->A1_ORIGEM <> 'X' .OR. SF2->F2_TIPO <> 'N'
	restArea(aArea)
	Return .T.
EndIf
*/
nVendasI := fNotasMes() + 3

dbSelectArea("SF2")

cConteudo +="<!DOCTYPE html>"
cConteudo +="<html lang='pt-br'>"
cConteudo +="<head>"
cConteudo +="    <meta charset='UTF-8'>"
cConteudo +="    <title>FATURAMENTO CLIENTE INATIVO</title>"
cConteudo +="    <style>"
cConteudo +="        div#interface {"
cConteudo +="            width: 800px;"
cConteudo +="            font-family: Arial;"
cConteudo +="            font-size: 14px;"
cConteudo +="        }"
cConteudo +="        div#interface h1 {"
cConteudo +="            display: block;"
cConteudo +="            overflow: hidden;"
cConteudo +="            height: 32px;"
cConteudo +="            width: 600px;"
cConteudo +="            padding-bottom: 50px;"
cConteudo +="            background-position: 0 -43px;"
cConteudo +="            background-image: url('http://ravabrasil.com.br/assets/img/sprite/standard-sc18fe437b4.png');"
cConteudo +="            background-repeat: no-repeat;"
cConteudo +="            background-size: 40%;"
cConteudo +="        }"
cConteudo +="        div#interface h1 p {"
cConteudo +="            text-align: right;"
cConteudo +="            font-size: 20px;"
cConteudo +="        }"
cConteudo +="        div#corpo h3 {"
cConteudo +="            text-align: center;"
cConteudo +="            font-size: 18px;"
cConteudo +="        }"
cConteudo +="        div#corpo h2 {"
cConteudo +="            text-align: center;"
cConteudo +="            font-size: 16px;"
cConteudo +="        }"
cConteudo +="        table#status {"
cConteudo +="            font-size: 20px;"
cConteudo +="        }"
cConteudo +="        table#status td.a1 {"
cConteudo +="            background-color: red;"
cConteudo +="        }"
cConteudo +="        table#status td.a2 {"
cConteudo +="            background-color: orange;"
If nVendasI < 2
	cConteudo +="            visibility: hidden;"
EndIf
cConteudo +="        }"
cConteudo +="        table#status td.a3 {"
cConteudo +="            background-color: gold;"
If nVendasI < 3
	cConteudo +="            visibility: hidden;"
EndIf
cConteudo +="        }"
cConteudo +="        table#status td.a4 {"
cConteudo +="            background-color: greenyellow;"
If nVendasI < 4
	cConteudo +="            visibility: hidden;"
EndIf
cConteudo +="        }"
cConteudo +="        table#status td.a5 {"
cConteudo +="            background-color: limegreen;"
If nVendasI < 5
	cConteudo +="            visibility: hidden;"
EndIf
cConteudo +="        }"
cConteudo +="        table#geral {"
cConteudo +="            border-spacing: 0px;"
cConteudo +="        }"
cConteudo +="        table#geral td {"
cConteudo +="            border: 1px solid black;"
cConteudo +="            padding: 2px;"
cConteudo +="        }"
cConteudo +="        table#geral td.tit {"
cConteudo +="            font-weight: bold;"
cConteudo +="            background-color: rgba(180,255,166,0.65);"
cConteudo +="        }"
cConteudo +="    </style>"
cConteudo +="</head>"
cConteudo +="<body>"
cConteudo +="<div id='interface'>"
cConteudo +="    <h1>"
cConteudo +="      <p> NOTA FISCAL - " + SF2->F2_DOC + "-" + SF2->F2_SERIE + "</p>"
cConteudo +="    </h1>"
cConteudo +="    <div id='corpo'>"
cConteudo +="        <h3>PARABÉNS VOCÊ VENDEU PARA UM CLIENTE INATIVO</h3>"
cConteudo +="        <h2>NESTE MÊS VOCÊ ATIVOU</h2>"
cConteudo +="        <table align='center' id='status'>"
cConteudo +="            <tr><td class='a1'>1 CLIENTE</td><td class='a2'>2 CLIENTES</td><td class='a3'>3 CLIENTES</td><td class='a4'>4 CLIENTES</td><td class='a5'>5 CLIENTES</td></tr>"
cConteudo +="        </table>"
cConteudo +="        <br>"
cConteudo +="        <table id='geral'>"
cConteudo +="            <tr bgcolor=#98fb98> <td colspan='8' class='tit'>CABEÇALHO</td></tr>"

cConteudo +="            <tr> <td class='tit'>NOME</td> <td class='co' colspan='3'>" + SA1->A1_NOME + "</td> <td class='tit'>CNPJ</td> <td class='co'>" + SA1->A1_CGC + "</td> <td class='tit'>EMISSÃO</td> <td class='co'>13/03/2018</td></tr>"
cConteudo +="            <tr> <td class='tit'>ENDEREÇO</td> <td colspan='3'>" + SA1->A1_END + "</td> <td class='tit'>BAIRRO</td> <td class='co'>" + SA1->A1_BAIRRO + "</td><td class='tit'>CIDADE</td> <td class='co'>" + SA1->A1_MUN + "</td> </tr>"
cConteudo +="            <tr> <td class='tit'>UF</td> <td>" + SA1->A1_EST + "</td><td class='tit'>CEP</td> <td class='co'>" + SA1->A1_CEP + "</td><td class='tit'>FONE</td> <td class='co'>" + SA1->A1_TEL + "</td><td class='tit'>IE</td> <td class='co'>" + SA1->A1_INSCR + "</td> </tr>"
cConteudo +="            <tr bgcolor='#98fb98'> <td colspan='8' class='tit'>PRODUTOS</td></tr>"
cConteudo +="            <tr> <td class='tit'>CODIGO</td><td colspan='2' class='tit'>DESCRIÇÃO</td><td class='tit'>QUANT.</td><td class='tit'>V. UNIT.</td><td class='tit'>TOTAL</td><td class='tit'>IPI</td><td class='tit'>TOTAL C/ IPI</td></tr>"


dbSelectArea("SD2")
dbsetOrder(1)
SD2->(dbSeek(xFilial("SD2") + SCJ->CJ_NUM))

While SD2->(!EOF()) .and. SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE

cDescPro	:= Posicione("SB1", 1, xFilial("SB1") + SD2->D2_COD, "B1_DESC" )
cConteudo +="<tr> <td>" + SD2->D2_COD + "</td><td colspan='2'>" + cDescPro + "</td><td>" 
cConteudo += Transform(SD2->D2_QUANT,"@E 999,999,999.99999") + "</td><td>" 
cConteudo += Transform(SD2->D2_PRCVEN,"@E 999,999,999.99999") + "</td><td>" 
cConteudo += Transform(SD2->D2_QUANT * SD2->D2_PRCVEN,"@E 999,999,999.99999") + "</td><td>" 
cConteudo += Transform(SD2->D2_VALIPI,"@E 999,999,999.99999") + "</td><td>" 
cConteudo += Transform((SD2->D2_QUANT * SD2->D2_PRCVEN) + SD2->D2_VALIPI,"@E 999,999,999.99999") + "</td></tr>"

  nTotal	:= nTotal + SD2->D2_QUANT * SD2->D2_PRCVEN
  nTotalIPI	:= nTotalIPI + SD2->D2_VALIPI
  
  SD2->(dbSkip())

EndDo

cConteudo +="            <tr><td colspan='5' class='tit'>VALOR TOTAL</td><td class='tit'>" + Transform(nTotal,"@E 999,999,999.99999") + "</td><td colspan='2' class='tit'>" + Transform(nTotal + nTotalIPI,"@E 999,999,999.99999") + "</td></tr>"

cConteudo +="        </table>"

cConteudo +="    </div>"
cConteudo +="</div>"
cConteudo +="</body>"
cConteudo +="</html>"



cAnexo	:= ""
Memowrite("D:\Temp\nfinativo.html", cConteudo)
ConOut("**** CONTEUDO ****")
ConOut(cConteudo)

cMailTo := "gustavo@ravaembalagens.com.br" 

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

If lEnviado
	MsgAlert("Email enviado com sucesso! " + cMailTo)
Else
	MsgAlert("Problema no envio do email!")
EndIf

restArea(aArea)

Return .T.



Static Function fNotasMes()

local cQry		:= ''
Local nRet		:= 0

cQry := " SELECT COUNT(*) QUANTIDADE FROM " + RetSqlName("SF2") + " F2 "
cQry += " INNER JOIN SA1010 A1 "
cQry += " ON F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA "
cQry += " WHERE F2.D_E_L_E_T_ <> '*' "
cQry += " AND A1.D_E_L_E_T_ <> '*' "
cQry += " AND F2_VEND1 = '" + SF2->F2_VEND1 + "' "
cQry += " AND F2_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "' "
cQry += " AND A1_ORIGEM = 'X' "

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

If TMP5->(!EOF())

	nRet := TMP5->QUANTIDADE

EndIF

TMP5->(dbclosearea())

Return nRet


User Function fBxEstAdm(paramixb)

  Local lRet		:= .T.
  local cDB16  		:= "MSSQL/P12"
  Local cSrv16 		:= "10.0.0.19"
  Local nHnd16 		:= -1
  Local aCab1		:= paramixb[1]
  Local aItemX		:= paramixb[2]
  Local nXHnd 		:= paramixb[3] //AdvConnection()
  Private lMsErroAuto := .F.
 
  PREPARE ENVIRONMENT EMPRESA '02' FILIAL '01' //TABLES "SA1"
  // Cria uma conexão com um outro banco, outro DBAcces
  nHnd16 := TcLink( cDB16, cSrv16, 7890 )

  If !TCSETCONN(nHnd16) //nHnd16 < 0
	conout("Erro ao realizar troca de conexão ativa")
    UserException( "Falha ao conectar com " + cDB16 + " em " + cSrv16 )
    lRet	:= .F.
  Else
  	conout( "Banco conectado - Handler = " + str( nHnd16, 4 ) )
  Endif
   
If lRet
	
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab1,aItemX,3)
	
	If lMsErroAuto 
		Mostraerro() 
		DisarmTransaction() 
		break
	EndIf
	
	tcSetConn( nXHnd )

	TcUnlink( nHnd16 )
	conout( "Banco 16 desconectado" )

EndIf	
   
  RESET ENVIRONMENT
  // Volta para conexão ERP
  
Return lRet



User Function fTransNova(paramixb)

  Local lRet		:= .T.
  Local aCab1		:= paramixb[1]
  Local aItemX		:= paramixb[2]
  Local nXHndERP 	:= paramixb[3]
  Local _Filial		:= paramixb[4]
  //local cDB  	:= "MSSQL/P12"
  //Local cSrv 	:= "10.0.0.19"
  //Local nHnd 	:= -1
  Local i
  Private lMsErroAuto := .F.
 
  PREPARE ENVIRONMENT EMPRESA '02' FILIAL _Filial //'06' //TABLES "SA1"

/*  nHnd := TcLink( cDB, cSrv, 7890 )

  If !TCSETCONN(nHnd16) //nHnd16 < 0
	conout("Erro ao conectar no banco")
    lRet	:= .F.
  Else
*/
//	MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab1,aItemX,3)
	For i := 1 to Len(aItemX)
	
/*
		ConOut("**** CONTEUDO ****")
		ConOut(aItemX[1][2])
		ConOut(aItemX[2][2])
		ConOut(aItemX[3][2])
		ConOut(aItemX[4][2])
		//ConOut(Str(aItemX[5][2]))
		//ConOut(aItemX[6][2])
		//ConOut(DtoC(aItemX[7][2]))
		ConOut("**** CONTEUDO ****")
*/		
		MSExecAuto( { | x, y | MATA240( x, y ) }, aItemX[i], 3 )
		
		If lMsErroAuto 
			Mostraerro() 
			DisarmTransaction() 
			break
			ConOut("**** ERRO EXECAUTO ****")
		Else
			ConOut("**** LANCAMENTO EFETUADO ****")
		EndIf
		
	Next
/*
  Endif
	
  tcSetConn( nXHndERP )

  TcUnlink( nHnd )
*/  
  RESET ENVIRONMENT
  
Return lRet

