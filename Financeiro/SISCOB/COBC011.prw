#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Tela principal da cobranca                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC011(cCodCli,cLojaCli,cMovimenta,lTipo,cTPPesq)


DEFINE FONT oFnt_1 NAME "Arial" SIZE 8,24 BOLD


//Esta funcao exige que o cliente ja esteja posicionado e nao esteja sendo consultado
cFlag := Space(15)

//Verifica se o cliente esta sendo consulta
dbselectarea("ZZ6")
If Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA)
	cFlag := Trim(Upper(Substr(cUsuario,7,15)))
	If !Empty(ZZ6_FLAG) .AND. cFlag <> Trim(ZZ6_FLAG)
		Dbselectarea("SX5")
		Dbseek(xFilial()+"ZU30")
		If cFlag $ SX5->X5_DESCRI //So se o usuario tiver autorizacao de liberar ZU-30
			lFec := IW_MsgBox("Cliente esta sendo consultado por "+Trim(ZZ6->ZZ6_FLAG)+", Deseja Liberar?","","YESNO" )
			If lFec
				If ! U_SENHA('07')
					Alert( 'Usuario sem permissao!' )
					Return
				Else
					dbselectarea("ZZ6")
					Reclock("ZZ6",.F.)
					Replace ZZ6_FLAG With ""
					msunlock()
					Return
				Endif
			Else
				Return
			Endif
		Else           // Demais usuarios deve so informar que esta em consulta
			Alert("Cliente esta sendo consultado por "+Trim(ZZ6->ZZ6_FLAG))
			Return
		Endif
	Else
		dbselectarea("ZZ6")
		Reclock("ZZ6",.F.)
		Replace ZZ6_FLAG With cFlag
		msunlock()
	Endif
Endif

//Atualiza historico de atendimento
cCodAtend := RetCodUsr()
cNomAtend := Subst(cUsuario,7,15)

//Verifica se o atendente nao estiver cadastrado e cria se necessario
Dbselectarea("ZA1")
Dbsetorder(1)
If !Dbseek(xFilial()+cCodAtend)
	RecLock("ZA1",.T.)
	Replace ZA1_FILIAL With xFilial()
	Replace ZA1_COD    With cCodAtend
	Replace ZA1_NOME   With cNomAtend
	Replace ZA1_ATIVO  With 'S'
	msunlock()
Endif

//Atualiza historico de atendimento
Dbselectarea("ZA2")
Reclock("ZA2",.T.)
Replace ZA2_FILIAL   With xFilial() //Filial
Replace ZA2_DTATEN   With dDatabase //Data atendimento
Replace ZA2_HRINI    With Time()   //Hora inicial
//Replace ZA2_HRFIM    With xFilial() //Hora final
Replace ZA2_CODATE   With cCodAtend //Codigo do atendente
Replace ZA2_NOMATE   With cNomAtend //Nome do atendente
Replace ZA2_CODCLI   With SA1->A1_COD  //Codigo do cliente
Replace ZA2_LJCLI    With SA1->A1_LOJA //loja do cliente
Replace ZA2_NOMCLI   With SA1->A1_NOME //Nome do cliente
If Empty(cTPPesq) .Or. cTPPesq == Nil
	Replace ZA2_PRIOR    With ZZ6->ZZ6_PRIORI //Prioridade
	Replace ZA2_SEQUEN   With ZZ6->ZZ6_SEQUEN //Sequencia
Else
	Replace ZA2_PRIOR    With cTPPesq //Prioridade
Endif
Replace ZA2_QUALI    With 'N' //Positivo ou negativo
If !lTipo .Or. lTipo == Nil
	Replace ZA2_TIPO     With 'C' //Ativo ou receptivo
Else
	Replace ZA2_TIPO     With 'A' //Ativo ou receptivo
Endif
msunlock()

Private oDlgConsulta,oResultPesq,oGrpDadosCli,oSay5,oSay8,oCliente,oNome,oPrior,oSay11,oEnd,oSay13,oCGC,oSay15
PRIVATE oGrupo,oGrpStatusCob,oStatusCob,oGrpRepres,oGrpFone,oNomeRepres,oFoneRepres,oSay23,oSay24,oSay25,oSayCel
PRIVATE oSay26,oFones,oCelular, oContato,oFax,oEmail,oGrp33,BtnTlAgendar,BtnAVencer,BtnCalc,BtnPedidos,BtnPedPend
PRIVATE BtnEnderecos,BtnInformSCI,BtnProtestados,BtnChsDevol,BtnLiquidados,BtnPagos,BtnSair,BtnInstrucoes
PRIVATE BtnImpressao,BtnHelpCob,BtnPreAcd,oGrpResultPesq,BtnCarta,BtnPosicao,sMovimentacao,sMovimenta,oSBtn54,sChNao
PRIVATE oSBtn55,sVencidos,oPrincipal,sPrincipal,oTitulos,sTitulos,oVencidos,oJuros,sJuros,oMemo,oMovimenta,oChNao
Private oREGISTRO
Private lSair := .T., nDISCHINI, nDISCHFIM, nDISCREG := 0

If cMovimenta = NIL
	aArea := GetArea()
	DbSelectArea("ZZ7")
	DbSetOrder(2)
	DbSeek(xFilial("ZZ7")+ZZ6->ZZ6_PRIORI)
	cMovimenta := "Prioridade " + ZZ6->ZZ6_PRIORI + "-" + ZZ6->ZZ6_SEQUEN + "  " + ;
	Trim(ZZ7->ZZ7_DESNAT) + "/" + Trim(ZZ7->ZZ7_DESSTA) + "   " + Str( ZZ7->ZZ7_DIAS, 3, 0 ) + " dias"
	DbSetOrder(1)
	RestArea(aArea)
EndIf

aCAMPOS := { { "STATUS"  , "C", 15, 0 }, ;
{ "TITULO"     , "C", 19, 0 }, ;
{ "CLIENTE"    , "C", 06, 0 }, ;
{ "LOJA"       , "C", 02, 0 }, ;
{ "NATUREZA"   , "C", 05, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "EMISSAO"    , "D", 08, 0 }, ;
{ "VENCTO"     , "D", 08, 0 }, ;
{ "VLRPRIN"    , "N", 12, 2 }, ;
{ "JUROS"      , "N", 12, 2 }, ;
{ "PAGTO"      , "N", 12, 2 }, ;
{ "SALDO"      , "N", 12, 2 }, ;
{ "NUMDEP"     , "C", 09, 0 }, ;
{ "PORTADOR"   , "C", 03, 0 }, ;
{ "CARTEIRA"   , "C", 10, 0 }, ;
{ "PEDIDO"     , "C", 06, 0 }, ;
{ "VENCORI"    , "D", 08, 0 } }

cARQTIT1 := CriaTrab( aCAMPOS, .T. )

// Testa se o arquivo jแ estแ aberto
If Select("TIT") > 0
	DbSelectArea("TIT")
	DbCloseArea()
Endif

DbUseArea( .T.,, cARQTIT1, "TIT", .F., .F. )

cCliente:=Space(6)
cNome   :=Space(30)
cCgc    :=Space(15)
cStatus :=Space(10)
cNome_Vend :=Space(20)
cFone_vend :=Space(15)
cmemo      :=Space(700)
cFone   := Space(15)
cEmail  := Space(10)

@ 000,000 To 570,790 Dialog oDLGConsulta Title "Consulta COBRANCA"

oTipo := TSAY():Create(oDlgConsulta)
oTipo:cName := "oTipo"
oTipo:nLeft := 350
oTipo:nTop := 23
oTipo:nWidth := 254
oTipo:nHeight := 21
oTipo:lShowHint := .F.
oTipo:lReadOnly := .T.
oTipo:Align := 0
oTipo:lVisibleControl := .T.
oTipo:lWordWrap := .F.
oTipo:lTransparent := .F.

oGrpDadosCli := TGROUP():Create(oDlgConsulta)
oGrpDadosCli:cName := "oGrpDadosCli"
oGrpDadosCli:cCaption := "Dados do Cliente"
oGrpDadosCli:nLeft := 9
oGrpDadosCli:nTop := 5//57
oGrpDadosCli:nWidth := 536 //765
oGrpDadosCli:nHeight := 150//183
oGrpDadosCli:lShowHint := .F.
oGrpDadosCli:lReadOnly := .F.
oGrpDadosCli:Align := 0
oGrpDadosCli:lVisibleControl := .T.

oSay5 := TSAY():Create(oDlgConsulta)
oSay5:cName := "oSay5"
oSay5:cCaption := "Codigo:"
oSay5:nLeft := 18
oSay5:nTop := 20//80
oSay5:nWidth := 43
oSay5:nHeight := 15
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oSay8 := TSAY():Create(oDlgConsulta)
oSay8:cName := "oSay8"
oSay8:cCaption := "Nome:"
oSay8:nLeft := 156
oSay8:nTop := 20//80
oSay8:nWidth := 47
oSay8:nHeight := 15
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oCliente := TSAY():Create(oDlgConsulta)
oCliente:cName := "oCliente"
oCliente:nLeft := 66
oCliente:nTop := 20//80
oCliente:nWidth := 65
oCliente:nHeight := 17
oCliente:lShowHint := .F.
oCliente:lReadOnly := .F.
oCliente:Align := 0
oCliente:lVisibleControl := .T.
oCliente:lWordWrap := .F.
oCliente:lTransparent := .F.

oNome := TSAY():Create(oDlgConsulta)
oNome:cName := "oNome"
oNome:nLeft := 190
oNome:nTop := 20//80
oNome:nWidth := 301
oNome:nHeight := 15
oNome:lShowHint := .F.
oNome:lReadOnly := .F.
oNome:Align := 0
oNome:lVisibleControl := .T.
oNome:lWordWrap := .F.
oNome:lTransparent := .F.

oPrior := TSAY():Create(oDlgConsulta)
oPrior:cName := "oPrior"
oPrior:nLeft := 380
oPrior:nTop := 10//80
oPrior:nWidth := 150
oPrior:nHeight := 25
oPrior:lShowHint := .F.
oPrior:lReadOnly := .F.
oPrior:Align := 0
oPrior:lVisibleControl := .T.
oPrior:lWordWrap := .F.
oPrior:lTransparent := .F.

oSay11 := TSAY():Create(oDlgConsulta)
oSay11:cName := "oSay11"
oSay11:cCaption := "End.:"
oSay11:nLeft := 18
oSay11:nTop := 40//105
oSay11:nWidth := 35
oSay11:nHeight := 15
oSay11:lShowHint := .F.
oSay11:lReadOnly := .F.
oSay11:Align := 0
oSay11:lVisibleControl := .T.
oSay11:lWordWrap := .F.
oSay11:lTransparent := .F.

oEnd := TSAY():Create(oDlgConsulta)
oEnd:cName := "oEnd"
oEnd:nLeft := 66
oEnd:nTop := 40//105
oEnd:nWidth := 450
oEnd:nHeight := 15
oEnd:lShowHint := .F.
oEnd:lReadOnly := .F.
oEnd:Align := 0
oEnd:lVisibleControl := .T.
oEnd:lWordWrap := .F.
oEnd:lTransparent := .F.

oSay13 := TSAY():Create(oDlgConsulta)
oSay13:cName := "oSay13"
oSay13:cCaption := "CNPJ/CPF:"
oSay13:nLeft := 18
oSay13:nTop := 60//130
oSay13:nWidth := 57
oSay13:nHeight := 15
oSay13:lShowHint := .F.
oSay13:lReadOnly := .F.
oSay13:Align := 0
oSay13:lVisibleControl := .T.
oSay13:lWordWrap := .F.
oSay13:lTransparent := .F.

oCGC := TSAY():Create(oDlgConsulta)
oCGC:cName := "oCGC"
oCGC:nLeft := 85
oCGC:nTop := 60//130
oCGC:nWidth := 173
oCGC:nHeight := 15
oCGC:lShowHint := .F.
oCGC:lReadOnly := .F.
oCGC:Align := 0
oCGC:lVisibleControl := .T.
oCGC:lWordWrap := .F.
oCGC:lTransparent := .F.

oSay15 := TSAY():Create(oDlgConsulta)
oSay15:cName := "oSay15"
oSay15:cCaption := "Grupo:"
oSay15:nLeft := 293
oSay15:nTop := 60//130
oSay15:nWidth := 39
oSay15:nHeight := 15
oSay15:lShowHint := .F.
oSay15:lReadOnly := .F.
oSay15:Align := 0
oSay15:lVisibleControl := .T.
oSay15:lWordWrap := .F.
oSay15:lTransparent := .F.

oGrupo := TSAY():Create(oDlgConsulta)
oGrupo:cName := "oGrupo"
oGrupo:nLeft := 348
oGrupo:nTop := 60//130
oGrupo:nWidth := 52
oGrupo:nHeight := 15
oGrupo:lShowHint := .F.
oGrupo:lReadOnly := .F.
oGrupo:Align := 0
oGrupo:lVisibleControl := .T.
oGrupo:lWordWrap := .F.
oGrupo:lTransparent := .F.

oGrpFone := TGROUP():Create(oDlgConsulta)
oGrpFone:cName := "oGrpFone"
oGrpFone:cCaption := "Fones"
oGrpFone:nLeft := 18
oGrpFone:nTop := 80//100//163
oGrpFone:nWidth := 370//400
oGrpFone:nHeight := 67
oGrpFone:lShowHint := .F.
oGrpFone:lReadOnly := .F.
oGrpFone:Align := 0
oGrpFone:lVisibleControl := .T.

oSay23 := TSAY():Create(oDlgConsulta)
oSay23:cName := "oSay23"
oSay23:cCaption := "Fones:"
oSay23:nLeft := 28
oSay23:nTop := 95//115//175
oSay23:nWidth := 36
oSay23:nHeight := 15
oSay23:lShowHint := .F.
oSay23:lReadOnly := .F.
oSay23:Align := 0
oSay23:lVisibleControl := .T.
oSay23:lWordWrap := .F.
oSay23:lTransparent := .F.

oFones := TSAY():Create(oDlgConsulta)
oFones:cName := "oFones"
oFones:nLeft := 85
oFones:nTop := 95//115//175
oFones:nWidth := 206
oFones:nHeight := 15
oFones:lShowHint := .F.
oFones:lReadOnly := .F.
oFones:Align := 0
oFones:cVariable := "cFone"
oFones:bSetGet := {|u| If(PCount()>0,cFone:=u,cFone) }
oFones:lVisibleControl := .T.
oFones:lWordWrap := .F.
oFones:lTransparent := .F.

oSaycel:= TSAY():Create(oDlgConsulta)
oSaycel:cName := "oSaycel"
oSaycel:cCaption := "Celular:"
oSaycel:nLeft := 28
oSaycel:nTop := 111//115//175
oSaycel:nWidth := 36
oSaycel:nHeight := 15
oSaycel:lShowHint := .F.
oSaycel:lReadOnly := .F.
oSaycel:Align := 0
oSaycel:lVisibleControl := .T.
oSaycel:lWordWrap := .F.
oSaycel:lTransparent := .F.

oCelular := TSAY():Create(oDlgConsulta)
oCelular:cName := "oCelular"
oCelular:nLeft := 85
oCelular:nTop := 111//115//175
oCelular:nWidth := 206
oCelular:nHeight := 15
oCelular:lShowHint := .F.
oCelular:lReadOnly := .F.
oCelular:Align := 0
oCelular:cVariable := "cCelular"
oCelular:lVisibleControl := .T.
oCelular:lWordWrap := .F.
oCelular:lTransparent := .F.

oSay25 := TSAY():Create(oDlgConsulta)
oSay25:cName := "oSay25"
oSay25:cCaption := "Fax:"
oSay25:nLeft := 200//299
oSay25:nTop := 95//115//175
oSay25:nWidth := 26
oSay25:nHeight := 15
oSay25:lShowHint := .F.
oSay25:lReadOnly := .F.
oSay25:Align := 0
oSay25:lVisibleControl := .T.
oSay25:lWordWrap := .F.
oSay25:lTransparent := .F.

oFax := TSAY():Create(oDlgConsulta)
oFax:cName := "oFax"
oFax:nLeft := 245//335
oFax:nTop := 95//115//175
oFax:nWidth := 130
oFax:nHeight := 15
oFax:lShowHint := .F.
oFax:lReadOnly := .F.
oFax:Align := 0
oFax:lVisibleControl := .T.
oFax:lWordWrap := .F.
oFax:lTransparent := .F.

oSay24 := TSAY():Create(oDlgConsulta)
oSay24:cName := "oSay24"
oSay24:cCaption := "Contato:"
oSay24:nLeft := 28
oSay24:nTop := 127//140//200
oSay24:nWidth := 46
oSay24:nHeight := 15
oSay24:lShowHint := .F.
oSay24:lReadOnly := .F.
oSay24:Align := 0
oSay24:lVisibleControl := .T.
oSay24:lWordWrap := .F.
oSay24:lTransparent := .F.

oContato := TSAY():Create(oDlgConsulta)
oContato:cName := "oContato"
oContato:nLeft := 85
oContato:nTop := 127//140//200
oContato:nWidth := 205
oContato:nHeight := 15
oContato:lShowHint := .F.
oContato:lReadOnly := .F.
oContato:Align := 0
oContato:lVisibleControl := .T.
oContato:lWordWrap := .F.
oContato:lTransparent := .F.

oSay26 := TSAY():Create(oDlgConsulta)
oSay26:cName := "oSay26"
oSay26:cCaption := "E-mail:"
oSay26:nLeft := 200//299
oSay26:nTop := 127//140//200
oSay26:nWidth := 34
oSay26:nHeight := 15
oSay26:lShowHint := .F.
oSay26:lReadOnly := .F.
oSay26:Align := 0
oSay26:lVisibleControl := .T.
oSay26:lWordWrap := .F.
oSay26:lTransparent := .F.

oEmail := TSAY():Create(oDlgConsulta)
oEmail:cName := "oEmail"
oEmail:nLeft := 245//200//335
oEmail:nTop := 127//140//200
oEmail:nWidth := 130
oEmail:nHeight := 15
oEmail:lShowHint := .F.
oEmail:lReadOnly := .F.
oEmail:Align := 0
oEmail:cVariable := "cEmail"
oEmail:bSetGet := {|u| If(PCount()>0,cEmail:=u,cEmail) }
oEmail:lVisibleControl := .T.
oEmail:lWordWrap := .F.
oEmail:lTransparent := .F.

oGrpRepres := TGROUP():Create(oDlgConsulta)
oGrpRepres:cName := "oGrpRepres"
oGrpRepres:cCaption := "Representante"
oGrpRepres:nLeft := 390//571
oGrpRepres:nTop := 80//100//163
oGrpRepres:nWidth := 150
oGrpRepres:nHeight := 67
oGrpRepres:lShowHint := .T.
oGrpRepres:lReadOnly := .T.
oGrpRepres:Align := 0
oGrpRepres:lVisibleControl := .T.

oNome_Vend := TSAY():Create(oDlgConsulta)
oNome_Vend:cName := "oNome_Vend"
oNome_Vend:nLeft := 400 //582
oNome_Vend:nTop := 95 //115//175
oNome_Vend:nWidth := 100 //179
oNome_Vend:nHeight := 15
oNome_Vend:lShowHint := .F.
oNome_Vend:lReadOnly := .F.
oNome_Vend:Align := 0
oNome_Vend:lVisibleControl := .T.
oNome_Vend:lWordWrap := .F.
oNome_Vend:lTransparent := .F.

oFone_Vend := TSAY():Create(oDlgConsulta)
oFone_Vend:cName := "oFone_Vend"
oFone_Vend:nLeft := 400//584
oFone_Vend:nTop := 120//140//200
oFone_Vend:nWidth := 130//179
oFone_Vend:nHeight := 15
oFone_Vend:lShowHint := .F.
oFone_Vend:lReadOnly := .F.
oFone_Vend:Align := 0
oFone_Vend:lVisibleControl := .T.
oFone_Vend:lWordWrap := .F.
oFone_Vend:lTransparent := .F.

oCod_Vend := TSAY():Create(oDlgConsulta)
oCod_Vend:cName := "oCod_Vend"
oCod_Vend:nLeft := 490
oCod_Vend:nTop := 120//140//200
oCod_Vend:nWidth := 50//179
oCod_Vend:nHeight := 15
oCod_Vend:lShowHint := .F.
oCod_Vend:lReadOnly := .F.
oCod_Vend:Align := 0
oCod_Vend:lVisibleControl := .T.
oCod_Vend:lWordWrap := .F.
oCod_Vend:lTransparent := .F.

BtnTlAgendar := TBUTTON():Create(oDlgConsulta)
BtnTlAgendar:cName := "BtnTlAgendar"
BtnTlAgendar:cCaption := "Agendar"
BtnTlAgendar:nLeft := 550//810
BtnTlAgendar:nTop := 10//30
BtnTlAgendar:nWidth := 100
BtnTlAgendar:nHeight := 22
BtnTlAgendar:lShowHint := .F.
BtnTlAgendar:lReadOnly := .F.
BtnTlAgendar:Align := 0
BtnTlAgendar:lVisibleControl := .T.
BtnTlAgendar:bAction := {|| TlAgendar() }

BtnTitulos := TBUTTON():Create(oDlgConsulta)
BtnTitulos:cName := "BtnTitulos"
BtnTitulos:cCaption := "Titulos"
BtnTitulos:nLeft := 550//810
BtnTitulos:nTop := 40//65
BtnTitulos:nWidth := 100
BtnTitulos:nHeight := 22
BtnTitulos:lShowHint := .F.
BtnTitulos:lReadOnly := .F.
BtnTitulos:Align := 0
BtnTitulos:lVisibleControl := .T.
BtnTitulos:bAction := {|| Titulos() }

BtnPedidos := TBUTTON():Create(oDlgConsulta)
BtnPedidos:cName := "BtnPedidos"
BtnPedidos:cCaption := "Pedidos"
BtnPedidos:nLeft := 670//810
BtnPedidos:nTop := 40//70//345
BtnPedidos:nWidth := 100
BtnPedidos:nHeight := 22
BtnPedidos:lShowHint := .F.
BtnPedidos:lReadOnly := .F.
BtnPedidos:Align := 0
BtnPedidos:lVisibleControl := .T.
BtnPedidos:bAction := {|| Pedidos() }
btnPedidos:Disable()
/*
BtnAVencer := TBUTTON():Create(oDlgConsulta)
BtnAVencer:cName := "BtnAVencer"
BtnAVencer:cCaption := "A Vencer"
BtnAVencer:nLeft := 550//810
BtnAVencer:nTop := 40//65
BtnAVencer:nWidth := 100
BtnAVencer:nHeight := 22
BtnAVencer:lShowHint := .F.
BtnAVencer:lReadOnly := .F.
BtnAVencer:Align := 0
BtnAVencer:lVisibleControl := .T.
BtnAVencer:bAction := {|| AVencer() }

BtnPagos := TBUTTON():Create(oDlgConsulta)
BtnPagos:cName := "BtnPagos"
BtnPagos:cCaption := "Pagos"
BtnPagos:nLeft := 550//810
BtnPagos:nTop := 70//100
BtnPagos:nWidth := 100
BtnPagos:nHeight := 22
BtnPagos:lShowHint := .F.
BtnPagos:lReadOnly := .F.
BtnPagos:Align := 0
BtnPagos:lVisibleControl := .T.
BtnPagos:bAction := {|| Pagos() }

BtnLiquidados := TBUTTON():Create(oDlgConsulta)
BtnLiquidados:cName := "BtnLiquidados"
BtnLiquidados:cCaption := "Liquidados"
BtnLiquidados:nLeft := 550//810
BtnLiquidados:nTop := 100//135
BtnLiquidados:nWidth := 100
BtnLiquidados:nHeight := 22
BtnLiquidados:lShowHint := .F.
BtnLiquidados:lReadOnly := .F.
BtnLiquidados:Align := 0
BtnLiquidados:lVisibleControl := .T.
BtnLiquidados:bAction := {|| Liquidados() }

BtnChsDevol := TBUTTON():Create(oDlgConsulta)
BtnChsDevol:cName := "BtnChsDevol"
BtnChsDevol:cCaption := "Chs Devol"
BtnChsDevol:nLeft := 550//810
BtnChsDevol:nTop := 130//170
BtnChsDevol:nWidth := 100
BtnChsDevol:nHeight := 22
BtnChsDevol:lShowHint := .F.
BtnChsDevol:lReadOnly := .F.
BtnChsDevol:Align := 0
BtnChsDevol:lVisibleControl := .T.
BtnChsDevol:bAction := {|| ChsDevol() }

BtnProtestados := TBUTTON():Create(oDlgConsulta)
BtnProtestados:cName := "BtnProtestados"
BtnProtestados:cCaption := "Protestados"
BtnProtestados:nLeft := 550//810
BtnProtestados:nTop := 160//205
BtnProtestados:nWidth := 100
BtnProtestados:nHeight := 22
BtnProtestados:lShowHint := .F.
BtnProtestados:lReadOnly := .F.
BtnProtestados:Align := 0
BtnProtestados:lVisibleControl := .T.
BtnProtestados:bAction := {|| Protestados() }

BtnFaturado := TBUTTON():Create(oDlgConsulta)
BtnFaturado:cName := "BtnFaturado"
BtnFaturado:cCaption := "Fat. a Rec."
BtnFaturado:nLeft := 550
BtnFaturado:nTop := 190//273
BtnFaturado:nWidth := 100
BtnFaturado:nHeight := 22
BtnFaturado:lShowHint := .F.
BtnFaturado:lReadOnly := .F.
BtnFaturado:Align := 0
BtnFaturado:lVisibleControl := .T.
BtnFaturado:bAction := {|| Faturados() }
*/

BtnPosicao := TBUTTON():Create(oDlgConsulta)
BtnPosicao:cName := "BtnPosicao"
BtnPosicao:cCaption := "Posi็ใo"
BtnPosicao:nLeft := 550//430//10//670
BtnPosicao:nTop := 130//170//245
BtnPosicao:nWidth := 100
BtnPosicao:nHeight := 22
BtnPosicao:lShowHint := .F.
BtnPosicao:lReadOnly := .F.
BtnPosicao:Align := 0
BtnPosicao:lVisibleControl := .T.
BtnPosicao:bAction := { || U_XPosicao() }

BtnEnderecos := TBUTTON():Create(oDlgConsulta)
BtnEnderecos:cName := "BtnEnderecos"
BtnEnderecos:cCaption := "Endere็os"
BtnEnderecos:nLeft := 670
BtnEnderecos:nTop := 10
BtnEnderecos:nWidth := 100
BtnEnderecos:nHeight := 22
BtnEnderecos:lShowHint := .F.
BtnEnderecos:lReadOnly := .F.
BtnEnderecos:Align := 0
BtnEnderecos:lVisibleControl := .T.
BtnEnderecos:bAction := {|| Enderecos() }

/*
BtnPedPend := TBUTTON():Create(oDlgConsulta)
BtnPedPend:cName := "BtnPedPend"
BtnPedPend:cCaption := "Ped Pend"
BtnPedPend:nLeft := 670//810
BtnPedPend:nTop := 40
BtnPedPend:nWidth := 100
BtnPedPend:nHeight := 22
BtnPedPend:lShowHint := .F.
BtnPedPend:lReadOnly := .F.
BtnPedPend:Align := 0
BtnPedPend:lVisibleControl := .T.
BtnPedPend:bAction := {|| PedPend() }
*/

BtnInformSCI := TBUTTON():Create(oDlgConsulta)
BtnInformSCI:cName := "BtnInformSCI"
BtnInformSCI:cCaption := "Inform. SCI"
BtnInformSCI:nLeft := 670//550
BtnInformSCI:nTop := 70//100//190
BtnInformSCI:nWidth := 100
BtnInformSCI:nHeight := 22
BtnInformSCI:lShowHint := .F.
BtnInformSCI:lReadOnly := .F.
BtnInformSCI:Align := 0
BtnInformSCI:lVisibleControl := .T.
BtnInformSCI:bAction := {|| InformSCI() }
BtnInformSCI:Disable()

BtnPreAcd := TBUTTON():Create(oDlgConsulta)
BtnPreAcd:cName := "BtnPreAcd"
BtnPreAcd:cCaption := "Pr้ - Acd"
BtnPreAcd:nLeft := 550//810
BtnPreAcd:nTop := 70//130//415
BtnPreAcd:nWidth := 100
BtnPreAcd:nHeight := 22
BtnPreAcd:lShowHint := .F.
BtnPreAcd:lReadOnly := .F.
BtnPreAcd:Align := 0
BtnPreAcd:lVisibleControl := .T.
BtnPreAcd:bAction := {|| PreAcordo() }

BtnImpressao := TBUTTON():Create(oDlgConsulta)
BtnImpressao:cName := "BtnImpressao"
BtnImpressao:cCaption := "Impressใo"
BtnImpressao:nLeft := 670//810
BtnImpressao:nTop := 100//160//485
BtnImpressao:nWidth := 100
BtnImpressao:nHeight := 22
BtnImpressao:lShowHint := .F.
BtnImpressao:lReadOnly := .F.
BtnImpressao:Align := 0
BtnImpressao:lVisibleControl := .T.
BtnImpressao:bAction := {|| Impressao() }


BtnCarta := TBUTTON():Create(oDlgConsulta)
BtnCarta:cName := "BtnCarta"
BtnCarta:cCaption := "Carta Cobranca"
BtnCarta:nLeft := 550
BtnCarta:nTop := 100//190//273
BtnCarta:nWidth := 100
BtnCarta:nHeight := 22
BtnCarta:lShowHint := .F.
BtnCarta:lReadOnly := .F.
BtnCarta:Align := 0
BtnCarta:lVisibleControl := .T.
BtnCarta:bAction := {|| Carta_Cobranca() }

BtnDiscagem := TBUTTON():Create(oDlgConsulta)
BtnDiscagem:cName := "BtnDiscagem"
BtnDiscagem:cCaption := "Discar"
BtnDiscagem:nLeft := 550
BtnDiscagem:nTop := 160
BtnDiscagem:nWidth := 100
BtnDiscagem:nHeight := 22
BtnDiscagem:lShowHint := .F.
BtnDiscagem:lReadOnly := .F.
BtnDiscagem:Align := 0
BtnDiscagem:lVisibleControl := .T.
BtnDiscagem:bAction := {|| U_Discagem( cTPPESQ ) }

BtnDiscagem := TBUTTON():Create(oDlgConsulta)
BtnDiscagem:cName := "BtnHist"
BtnDiscagem:cCaption := "Historico"
BtnDiscagem:nLeft := 670
BtnDiscagem:nTop := 160
BtnDiscagem:nWidth := 100
BtnDiscagem:nHeight := 22
BtnDiscagem:lShowHint := .F.
BtnDiscagem:lReadOnly := .F.
BtnDiscagem:Align := 0
BtnDiscagem:lVisibleControl := .T.
BtnDiscagem:bAction := {|| U_Discagem( cTPPESQ ) }

ZZO->( DbSetorder( 2 ) )
ZZO->( DbSeek( xFILIAL( "ZZO" ) + SA1->A1_COD, .T. ) )
If ZZO->ZZO_CLIENT == SA1->A1_COD
	BtnDiscagem := TBUTTON():Create(oDlgConsulta)
	BtnDiscagem:cName := "BtnReclam"
	BtnDiscagem:cCaption := "Reclama็oes"
	BtnDiscagem:nLeft := 670
	BtnDiscagem:nTop := 130
	BtnDiscagem:nWidth := 100
	BtnDiscagem:nHeight := 22
	BtnDiscagem:lShowHint := .F.
	BtnDiscagem:lReadOnly := .F.
	BtnDiscagem:Align := 0
	BtnDiscagem:lVisibleControl := .T.
	BtnDiscagem:bAction := {|| U_TMK001C() }
	
	BtnSair := TBUTTON():Create(oDlgConsulta)
	BtnSair:cName := "BtnSair"
	BtnSair:cCaption := "Sair"
	BtnSair:nLeft := 670//810
	BtnSair:nTop := 160//569
	BtnSair:nWidth := 100
	BtnSair:nHeight := 22
	BtnSair:lShowHint := .F.
	BtnSair:lReadOnly := .F.
	BtnSair:Align := 0
	BtnSair:lVisibleControl := .T.
	BtnSair:bAction := {|| Sair() }
Else
	BtnSair := TBUTTON():Create(oDlgConsulta)
	BtnSair:cName := "BtnSair"
	BtnSair:cCaption := "Sair"
	BtnSair:nLeft := 670//810
	BtnSair:nTop := 130//569
	BtnSair:nWidth := 100
	BtnSair:nHeight := 22
	BtnSair:lShowHint := .F.
	BtnSair:lReadOnly := .F.
	BtnSair:Align := 0
	BtnSair:lVisibleControl := .T.
	BtnSair:bAction := {|| Sair() }
EndIf

sMovimentacao := TSAY():Create(oDlgConsulta)
sMovimentacao:cName := "sMovimentacao"
sMovimentacao:cCaption := "Movimenta็ใo"
sMovimentacao:nLeft := 250
sMovimentacao:nTop := 180//170//273
sMovimentacao:nWidth := 75
sMovimentacao:nHeight := 15
sMovimentacao:lShowHint := .F.
sMovimentacao:lReadOnly := .F.
sMovimentacao:Align := 0
sMovimentacao:lVisibleControl := .T.
sMovimentacao:lWordWrap := .F.
sMovimentacao:lTransparent := .F.

oMovimenta := TSAY():Create(oDlgConsulta)
oMovimenta:cName := "oMovimenta"
//sMovimenta:cCaption := cMovimenta//"Movimenta็ใo"
oMovimenta:nLeft := 9 //30 //289
oMovimenta:nTop := 160 //170//273
oMovimenta:nWidth := 375 //175
oMovimenta:nHeight := 15
oMovimenta:lShowHint := .F.
oMovimenta:lReadOnly := .F.
oMovimenta:Align := 0
oMovimenta:lVisibleControl := .T.
oMovimenta:lWordWrap := .F.
oMovimenta:lTransparent := .F.

BtnRegistrar := TBUTTON():Create(oDlgConsulta)
BtnRegistrar:cName := "BtnRegistrar"
BtnRegistrar:cCaption := "Registrar"
BtnRegistrar:nLeft := 290
BtnRegistrar:nTop := 520//620
BtnRegistrar:nWidth := 100
BtnRegistrar:nHeight := 22
BtnRegistrar:lShowHint := .F.
BtnRegistrar:lReadOnly := .F.
BtnRegistrar:Align := 0
BtnRegistrar:lVisibleControl := .T.
BtnRegistrar:bAction := {|| Registrar() }

sVencidos := TSAY():Create(oDlgConsulta)
sVencidos:cName := "sVencidos"
sVencidos:cCaption := "Vencidos:"
sVencidos:nLeft := 9
sVencidos:nTop := 200//303
sVencidos:nWidth := 51
sVencidos:nHeight := 15
sVencidos:lShowHint := .F.
sVencidos:lReadOnly := .F.
sVencidos:Align := 0
sVencidos:lVisibleControl := .T.
sVencidos:lWordWrap := .F.
sVencidos:lTransparent := .F.

oPrincipal := TSAY():Create(oDlgConsulta)
oPrincipal:cName := "oPrincipal"
oPrincipal:nLeft := 315
oPrincipal:nTop := 200//303
oPrincipal:nWidth := 96
oPrincipal:nHeight := 15
oPrincipal:lShowHint := .F.
oPrincipal:lReadOnly := .F.
oPrincipal:Align := 0
oPrincipal:lVisibleControl := .T.
oPrincipal:lWordWrap := .F.
oPrincipal:lTransparent := .F.

sPrincipal := TSAY():Create(oDlgConsulta)
sPrincipal:cName := "sPrincipal"
sPrincipal:cCaption := "Principal:"
sPrincipal:nLeft := 260
sPrincipal:nTop := 200//303
sPrincipal:nWidth := 49
sPrincipal:nHeight := 15
sPrincipal:lShowHint := .F.
sPrincipal:lReadOnly := .F.
sPrincipal:Align := 0
sPrincipal:lVisibleControl := .T.
sPrincipal:lWordWrap := .F.
sPrincipal:lTransparent := .F.

oTitulos := TSAY():Create(oDlgConsulta)
oTitulos:cName := "oTitulos"
oTitulos:nLeft := 214
oTitulos:nTop := 200//303
oTitulos:nWidth := 36
oTitulos:nHeight := 15
oTitulos:lShowHint := .F.
oTitulos:lReadOnly := .F.
oTitulos:Align := 0
oTitulos:lVisibleControl := .T.
oTitulos:lWordWrap := .F.
oTitulos:lTransparent := .F.

sTitulos := TSAY():Create(oDlgConsulta)
sTitulos:cName := "sTitulos"
sTitulos:cCaption := "Tํtulos:"
sTitulos:nLeft := 167
sTitulos:nTop := 200//303
sTitulos:nWidth := 41
sTitulos:nHeight := 15
sTitulos:lShowHint := .F.
sTitulos:lReadOnly := .F.
sTitulos:Align := 0
sTitulos:lVisibleControl := .T.
sTitulos:lWordWrap := .F.
sTitulos:lTransparent := .F.

oVencidos := TSAY():Create(oDlgConsulta)
oVencidos:cName := "oVencidos"
oVencidos:nLeft := 66
oVencidos:nTop := 200//303
oVencidos:nWidth := 91
oVencidos:nHeight := 15
oVencidos:lShowHint := .F.
oVencidos:lReadOnly := .F.
oVencidos:Align := 0
oVencidos:lVisibleControl := .T.
oVencidos:lWordWrap := .F.
oVencidos:lTransparent := .F.

oJuros := TSAY():Create(oDlgConsulta)
oJuros:cName := "oJuros"
oJuros:nLeft := 463
oJuros:nTop := 200//303
oJuros:nWidth := 65
oJuros:nHeight := 15
oJuros:lShowHint := .F.
oJuros:lReadOnly := .F.
oJuros:Align := 0
oJuros:lVisibleControl := .T.
oJuros:lWordWrap := .F.
oJuros:lTransparent := .F.

sJuros := TSAY():Create(oDlgConsulta)
sJuros:cName := "sJuros"
sJuros:cCaption := "Juros:"
sJuros:nLeft := 423
sJuros:nTop := 200//303
sJuros:nWidth := 34
sJuros:nHeight := 15
sJuros:lShowHint := .F.
sJuros:lReadOnly := .F.
sJuros:Align := 0
sJuros:lVisibleControl := .T.
sJuros:lWordWrap := .F.
sJuros:lTransparent := .F.

oChNao := TSAY():Create(oDlgConsulta)
oChNao:cName := "oChNao"
oChNao:nLeft := 620
oChNao:nTop := 200//303
oChNao:nWidth := 96
oChNao:nHeight := 15
oChNao:lShowHint := .F.
oChNao:lReadOnly := .F.
oChNao:Align := 0
oChNao:lVisibleControl := .T.
oChNao:lWordWrap := .F.
oChNao:lTransparent := .F.

sChNao := TSAY():Create(oDlgConsulta)
sChNao:cName := "sChNao"
sChNao:cCaption := "Ch.Nao:"
sChNao:nLeft := 556
sChNao:nTop := 200//303
sChNao:nWidth := 50
sChNao:nHeight := 15
sChNao:lShowHint := .F.
sChNao:lReadOnly := .F.
sChNao:Align := 0
sChNao:lVisibleControl := .T.
sChNao:lWordWrap := .F.
sChNao:lTransparent := .F.

Dbselectarea("SA1")
//Dbgotop()

Dbselectarea("SA3")
dbsetorder(1)
Dbseek(xFilial()+SA1->A1_VEND)

//Carrega a memoria da cobranca, se nao houver registro, cria.
Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xfilial()+SA1->A1_COD+SA1->A1_LOJA)
	mCob := ZZ6->ZZ6_MEMO
Else
	cMem := CriaVar("ZZ6->ZZ6_MEMO") //Para criar registro
	Reclock("ZZ6",.T.)
	Replace ZZ6_FILIAL With xFilial()
	Replace ZZ6_CLIENT With SA1->A1_COD
	Replace ZZ6_LOJA   With SA1->A1_LOJA
	Replace ZZ6_MEMO   With cMem
	Replace ZZ6_RETORN With dDatabase
	Replace ZZ6_TIPRET With '2'
	Replace ZZ6_ULCONT With CTOD("")
	Replace ZZ6_PRIORI With '   '
	Replace ZZ6_SEQUEN With '    '
	msunlock()
	mCob := ZZ6->ZZ6_MEMO
Endif

Dbselectarea("Sx5")
dbseek( "  ZM"+PADR(SA1->A1_PRIOR,6) )
cPrior := SX5->X5_DESCRI

Dbselectarea("SA1")
@ 210,010 GET mCob Size 330,45 MEMO Object oREGISTRO
oRegistro:lReadOnly := .T.
//@ 265,015 GET mCob Size 330,45 MEMO

oGrupo	   :SetText( SA1->A1_GPEMP )
oCliente   :SetText( SA1->A1_COD+"/"+SA1->A1_LOJA)
oNome	   :SetText( Subst(SA1->A1_NOME,1,35) )
oPrior     :SetFont( oFNT_1 )
oPrior     :SetText( Trim(cPrior) )
oCgc	   :SetText( Transform(Trim(SA1->A1_CGC),If(" "$SA1->A1_CGC,"@R 999.999.999-99","@R 99.999.999/9999-99")) )
oEnd	   :SetText( TRIM(SA1->A1_END)+" -  "+TRIM(SA1->A1_MUN)+" -  "+TRIM(SA1->A1_EST)+" -  "+TRIM(SA1->A1_BAIRRO)+" CEP: "+TRIM(SA1->A1_CEP)  )
oNome_Vend :SetText( TRIM(SA3->A3_NOME) )
oFone_vend :SetText( TRIM(SA3->A3_TEL) )
oCod_vend  :SetText( TRIM(SA3->A3_COD) )
oFones	   :SetText( TRIM(SA1->A1_TEL) )
oCelular   :SetText( TRIM(SA1->A1_TELEX) )
oFax       :SetText( TRIM(SA1->A1_FAX) )
oContato   :SetText( TRIM(SA1->A1_CONTATO) )
oEmail     :SetText( TRIM(SA1->A1_EMAIL) )
oMovimenta :SetText( cMovimenta )

oCliente   :nClrText       := CLR_HBLUE
oNome      :nClrText       := CLR_HBLUE
oPrior     :nClrText       := CLR_HRED
oCgc       :nClrText       := CLR_HBLUE
oEnd       :nClrText       := CLR_HBLUE
oNome_Vend :nClrText       := CLR_HBLUE
oFone_vend :nClrText       := CLR_HBLUE
oCod_Vend  :nClrText       := CLR_HBLUE
oFones     :nClrText       := CLR_HBLUE
oCelular   :nClrText       := CLR_HBLUE
oFax       :nClrText       := CLR_HBLUE
oContato   :nClrText       := CLR_HBLUE
oEmail     :nClrText       := CLR_HBLUE
oNome_Vend :nClrText       := CLR_HBLUE
oFone_Vend :nClrText       := CLR_HBLUE
oCod_Vend  :nClrText       := CLR_HBLUE
oVencidos  :nClrText       := CLR_HRED
oTitulos   :nClrText       := CLR_HRED
oPrincipal :nClrText       := CLR_HRED
oJuros     :nClrText       := CLR_HRED
oChNao     :nClrText       := CLR_HRED
oTipo      :nClrText       := CLR_HRED
oMovimenta :nClrText       := CLR_RED

//Soma valor de cheque NรO
cQUERY := " Select VALCHN=SUM(E1_SALDO) "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_SALDO > 0 "
cQUERY += " AND LEFT(SE1.E1_NATUREZ,5) IN ( '10403','10103' ) " //Mudar naturezas para nat.usadas na Rava
cQUERY += " AND SE1.E1_ORIGEM <> 'FINA460' "
cQUERY += " AND SE1.E1_TIPO IN ( 'NF','CH' ) "
cQUERY += " AND SE1.D_E_L_E_T_ = '' "

cQUERY := ChangeQuery( cQUERY )
TCQUERY cQUERY Alias TMPSE1 New
TcSetField( "TMPSE1", "VALCHN"  , "N", 12, 2 )
nValCHN := TMPSE1->VALCHN
TMPSE1->(DbCloseArea())

//Monta a consulta para a selecao dos titulos
cQUERY := " Select SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
cQUERY += " SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_VENCREA, SE1.E1_VENCTO, SE1.E1_PORTADO, SE1.E1_PEDIDO, "
cQUERY += " SE1.E1_NATUREZ, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_EMISSAO, SE1.E1_NUMDPID, SE1.E1_STATCOB "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_TIPO <> 'AB-' " //NOT IN ('NCC','AB-','RA') "
cQUERY += " AND SE1.E1_VENCREA < '" + DTOS(dDataBase) + "'" //So vencidos vencimento < que a data base do sistema
cQUERY += " AND SE1.E1_SALDO > 0 "
cQUERY += " AND SE1.D_E_L_E_T_ <> '*' "
cQUERY += " Order By SE1.E1_VENCREA"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPSE1")
dbgotop()
nTitulos   := 0
nJuros     := 0
nVencidos  := 0
nPrincipal := 0
nJurosTit  := 0
nJurBase   := Getmv("MV_COBJUR3")
While !Eof()
	
	nJurosTit  := ((E1_SALDO*nJurBase)/100)/30 //Juros por dia de atraso
	nDias      := dDatabase-TMPSE1->E1_VENCTO//VENCREA//Mudado para calcular o juros em cima do vencimento original
	If TMPSE1->E1_TIPO $ "RA , NCC"
		//		nJuros     -= (nJurosTit*nDias)
		nVencidos  -= E1_SALDO
		nPrincipal -= E1_SALDO
	Else
		nJuros     += (nJurosTit*nDias)
		nVencidos  += E1_SALDO+(nJurosTit*nDias)
		nPrincipal += E1_SALDO
	Endif
	Dbselectarea("ZZ7")
	Dbsetorder(1)
	Dbseek(xFilial()+TMPSE1->E1_NATUREZ+TMPSE1->E1_STATCOB)
	nTitulos ++
	Dbselectarea("TIT")
	Reclock("TIT",.T.)
	Replace STATUS   With ZZ7->ZZ7_DESSTA
	Replace TITULO   With TMPSE1->E1_PREFIXO+"-"+TMPSE1->E1_NUM+"/"+TMPSE1->E1_PARCELA+"-"+TMPSE1->E1_TIPO
	Replace CLIENTE  With TMPSE1->E1_CLIENTE
	Replace LOJA     With TMPSE1->E1_LOJA
	Replace NATUREZA With TMPSE1->E1_NATUREZ
	Replace EMISSAO  With TMPSE1->E1_EMISSAO
	Replace VENCTO   With TMPSE1->E1_VENCREA//TO
	Replace VLRPRIN  With TMPSE1->E1_VALOR
	Replace JUROS    With (nJurosTit*nDias)
	Replace PAGTO    With TMPSE1->E1_VALOR-TMPSE1->E1_SALDO
	Replace SALDO    With TMPSE1->E1_SALDO
	Replace NUMDEP   With TMPSE1->E1_NUMDPID
	Replace PORTADOR With TMPSE1->E1_PORTADO
	Replace PEDIDO   With TMPSE1->E1_PEDIDO
	Replace VENCORI  With TMPSE1->E1_VENCTO
	msunlock()
	Dbselectarea("TMPSE1")
	dbskip()
End

oVencidos :SetText( Trans( nVencidos , ( "@E 9,999,999.99" ) ) )
oTitulos  :SetText( Trans( nTitulos  , ( "@E 999,999" ) ) )
oPrincipal:SetText( Trans( nPrincipal, ( "@E 999,999,999.99" ) ) )
oJuros    :SetText( Trans( nJuros    , ( "@E 99,999.99" ) ) )
oChNao    :SetText( Trans( nValCHN   , ( "@E 9,999,999.99" ) ) )

Dbselectarea("TMPSE1")
Dbclosearea("TMPSE1") //Fecha arquivo temporario

dbselectarea("TIT")

oBRW1    := MsSelect():New( "TIT",,, ;
{ { "STATUS"    ,, OemToAnsi( "Status" ) }, ;
{ "TITULO"      ,, OemToAnsi( "Titulo" ) }, ;
{ "NATUREZA"    ,, OemToAnsi( "Natureza" ) }, ;
{ "EMISSAO"     ,, OemToAnsi( "Emissao" ) }, ;
{ "VENCTO"      ,, OemToAnsi( "Vencto" ) }, ;
{ "PORTADOR"    ,, OemToAnsi( "Portador" ) }, ;
{ "VLRPRIN"     ,, OemToAnsi( "Principal"), "@E 9,999,999.99" }, ;
{ "SALDO"       ,, OemToAnsi( "Saldo" ), "@E 9,999,999.99" }, ;
{ "JUROS"       ,, OemToAnsi( "Juros" ), "@E 9,999,999.99" }, ;
{ "PAGTO"       ,, OemToAnsi( "Pago" ) , "@E 9,999,999.99" }, ;
{ "NUMDEP"      ,, OemToAnsi( "Num Depoosito"), "@R 99999999-!" }, ;
{ "CARTEIRA"    ,, OemToAnsi( "Carteira" ) }, ;
{ "PEDIDO"      ,, OemToAnsi( "Pedido" ) }, ;
{ "VENCORI"      ,, OemToAnsi( "Venc Ori" ) }}, ;
.F.,, { 115, 005, 200, 387 } )
/*
{ "PREFIXO"     ,, OemToAnsi( "Prf" ) }, ;
{ "TITULO"      ,, OemToAnsi( "Titulo" ) }, ;
{ "PARCELA"     ,, OemToAnsi( "P" ) }, ;
{ "TIPO"        ,, OemToAnsi( "Tipo" ) }, ;
*/
oBRW1:oBROWSE:bChange     := { || ExibeBrw1() }
oBRW1:oBROWSE:bGotFocus   := { || ExibeBrw1() }

dbselectarea("TIT")
DBGOTOP()

Activate Dialog oDLGConsulta Centered Valid SairCons()

Reclock("ZA2",.F.)
Replace ZA2_HRFIM With Time()
Msunlock()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ExibeBrw1( lFLAG )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sair

Local lRet	:= .F.
Local cCombo		
Local aItens	:= {"1=Consulta","2=Liga็ใo Negativa","3=Liga็ใo Positiva","4=e-mail"}

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg11","oSBtn1","oSBtn2","oRMenu1","oRMenu2","oCBox1")

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg11      := MSDialog():New( 126,254,238,449,"Sair do sistema?",,,.F.,,,,,,.T.,,,.F. )
GoRMenu1   := TGroup():New( 000,004,052,091,"Opera็ใo Realizada",oDlg11,CLR_BLACK,CLR_WHITE,.T.,.F. )

cCombo		:= aItens[1]
oCBox1     := TComboBox():New( 012,008,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItens,072,010,oDlg11,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

oSBtn1     := SButton():New( 036,022,1,{|| lRet := fRet(cCombo)},GoRMenu1,,"", )
oSBtn2     := SButton():New( 036,054,2,{|| oDlg11:End() },GoRMenu1,,"", )

oDlg11:Activate(,,,.T.)


Return lRet

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Fun็ใo de retorno da confirma็ใo da saida do sistema.                   ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

Static Function fRet(cCombo)


Reclock("ZA2",.F.)
Do Case
	Case cCombo == "1"
		Replace ZA2_RESULT With "1"
		//MsgAlert("Consulta")
	Case cCombo == "2"
		Replace ZA2_RESULT With "2"
		//MsgAlert("Liga็ใo Negativa")
	Case cCombo == "3"
		Replace ZA2_RESULT With "3"
		//MsgAlert("Liga็ใo Positiva")
	Case cCombo == "4"
		Replace ZA2_RESULT With "4"
		//MsgAlert("Email")
EndCase	 
Msunlock()

oDlg11:End()

Reclock("ZZ6",.F.)
Replace ZZ6_FLAG With ""
msunlock()


Close( oDLGConsulta )

/* Forma Antiga
If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	
	Reclock("ZZ6",.F.)
	Replace ZZ6_FLAG With ""
	msunlock()
	
	Close( oDLGConsulta )
	Return .T.
EndIf
*/

Reclock("ZZ8",.F.)
Do Case
	Case cCombo == "1"
		Replace ZZ8_STATUS With "1"
		//MsgAlert("Consulta")
	Case cCombo == "2"
		Replace ZZ8_STATUS With "2"
		//MsgAlert("Liga็ใo Negativa")
	Case cCombo == "3"
		Replace ZZ8_STATUS With "3"
		//MsgAlert("Liga็ใo Positiva")
	Case cCombo == "4"
		Replace ZZ8_STATUS With "4"
		//MsgAlert("Email")
EndCase	 
msunlock()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SairCons()

Reclock("ZZ6",.F.)
Replace ZZ6_FLAG With ""
msunlock()

TIT->( DbCloseArea() )

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTlAgendar    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TlAgendar()

@ 96,030 TO 180,370 DIALOG oDlg7 TITLE "Marcar Retorno"
dDtRet  := dDataBase //CTOD( "" )
cHrRet  := Subs( Time(),1,5 ) //"08:00"

@ 05,05 SAY "Dt Retorno :"
@ 05,40 GET dDtRet SIZE 50,50 Valid {||dDtRet >= dDataBase}
@ 20,05 SAY "Hr Retorno :"
@ 20,40 GET cHrRet SIZE 30,30 Picture "99:99" Valid U_VldHora( cHrRet )

@ 18,100 BUTTON "_Ok" SIZE 35,15  ACTION _Grv()

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVencer      บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AVencer()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Titulos A Vencer"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

AADD(aHeader,{"Prefixo"       ,"E1_PREFIXO","@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Numero"        ,"E1_NUM"    ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Parcela"       ,"E1_PARCELA","@!"         ,01,0,,,"C","SE1","V"})
AADD(aHeader,{"Tipo"          ,"E1_TIPO"   ,"@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Natureza"      ,"E1_NATUREZ","@!"         ,10,0,,,"C","SE1","V"})
AADD(aHeader,{"Descricao"     ,"ED_DESCRIC","@!"         ,15,0,,,"C","SED","V"})
AADD(aHeader,{"Liquidacao"    ,"E1_NUMLIQ" ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Emissao"       ,"E1_EMISSAO","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Vencto"        ,"E1_VENCTO" ,"  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Valor"         ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Saldo"         ,"E1_SALDO"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Portador"      ,"E1_PORTADO","@!"         ,03,0,,,"C","SE1","V"})
//AADD(aHeader,{"Num Deposito"  ,"E1_NUMDPID","@!"         ,07,0,,,"C","SE1","V"})
AADD(aHeader,{"Num Deposito"  ,"E1_NUMDPID","@!"         ,09,0,,,"C","SE1","V"})

nUsado := 13

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE1")
cQUERY := "Select SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO, "
cQUERY += " SE1.E1_NATUREZ,SE1.E1_NUMLIQ,SE1.E1_EMISSAO,SE1.E1_VENCTO, SE1.E1_VENCREA, "
cQUERY += " SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_PORTADO,SE1.E1_NUMDPID "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_VENCREA >= '" + DTOS(dDataBase) + "'" //So os titulos a vencer
cQUERY += " AND SE1.E1_SALDO > 0"
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " Order By SE1.E1_VENCREA"
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSE1")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End
nTotTit  := nTam //Total de titulos
If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSE1")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SED")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSE1->E1_NATUREZ)
		
		aCOLS[nCnt][1] := TMPSE1->E1_PREFIXO
		aCOLS[nCnt][2] := TMPSE1->E1_NUM
		aCOLS[nCnt][3] := TMPSE1->E1_PARCELA
		aCOLS[nCnt][4] := TMPSE1->E1_TIPO
		aCOLS[nCnt][5] := TMPSE1->E1_NATUREZ
		aCOLS[nCnt][6] := SED->ED_DESCRIC
		aCOLS[nCnt][7] := TMPSE1->E1_NUMLIQ
		aCOLS[nCnt][8] := TMPSE1->E1_EMISSAO
		aCOLS[nCnt][9] := TMPSE1->E1_VENCREA//TO
		aCOLS[nCnt][10] := TMPSE1->E1_VALOR
		aCOLS[nCnt][11] := TMPSE1->E1_SALDO
		aCOLS[nCnt][12] := TMPSE1->E1_PORTADO
		aCOLS[nCnt][13] := TMPSE1->E1_NUMDPID
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSE1")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := " "
	aCOLS[1][2] := " "
	aCOLS[1][3] := " "
	aCOLS[1][4] := " "
	aCOLS[1][5] := " "
	aCOLS[1][6] := " "
	aCOLS[1][7] := " "
	aCOLS[1][8] := cTod(" ")
	aCOLS[1][9] := cTod(" ")
	aCOLS[1][10] := 0
	aCOLS[1][11] := 0
	aCOLS[1][12] := " "
	aCOLS[1][13] := " "
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


nTotValor  :=0
nTotSaldo  :=0

For i:= 1 To len(acols)
	nTotValor  += acols[i][10]
	nTotSaldo  += acols[i][11]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})
AADD(aR,{"nTotSaldo" ,{158,200},"Saldo:"     ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

Dbselectarea("TMPSE1")
DbClosearea("TMPSE1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPagos        บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pagos()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Pagos"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

AADD(aHeader,{"Prefixo"       ,"E1_PREFIXO","@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Numero"        ,"E1_NUM"    ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Parcela"       ,"E1_PARCELA","@!"         ,01,0,,,"C","SE1","V"})
AADD(aHeader,{"Tipo"          ,"E1_TIPO"   ,"@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Natureza"      ,"E1_NATUREZ","@!"         ,10,0,,,"C","SE1","V"})
AADD(aHeader,{"Descricao"     ,"ED_DESCRIC","@!"         ,15,0,,,"C","SED","V"})
AADD(aHeader,{"Mot.Baixa"     ,"E5_MOTBX"  ,"@!"         ,03,0,,,"C","SE5","V"})
AADD(aHeader,{"Liquidacao"    ,"E1_NUMLIQ" ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Vencto"        ,"E1_VENCREA","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Pagamento"     ,"E5_DATA"   ,"  "         ,08,0,,,"D","SE5","V"})
AADD(aHeader,{"Valor"         ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Pago"          ,"E5_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Portador"      ,"E5_BANCO"  ,"@!"         ,03,0,,,"C","SE5","V"})
AADD(aHeader,{"Num Documento" ,"E5_DOCUMEN","@!"         ,10,0,,,"C","SE5","V"})

nUsado:=nUsado + 14

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE1")
/*
cQUERY := "Select SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO, "
cQUERY += " SE1.E1_NATUREZ,SE1.E1_NUMLIQ,SE1.E1_EMISSAO,SE1.E1_VENCTO, SE1.E1_VENCREA,"
cQUERY += " SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_PORTADO,SE1.E1_NUMDPID "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_TIPO NOT IN ('NCC','AB-','RA') "
cQUERY += " AND (SE1.E1_NUMLIQ = '' OR (SE1.E1_NUMLIQ <> '' AND SE1.E1_TIPO = 'CH') )"
cQUERY += " AND SE1.E1_SALDO < SE1.E1_VALOR"
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " Order By SE1.E1_VENCREA"
cQUERY := ChangeQuery( cQUERY )
//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )
*/
//Carrega arquivo de trabalho criado com os dados da consulta
//nTam := 0
//Dbselectarea("TMPSE1")
//dbgotop()
//While !Eof()
//	nTam ++
//	dbskip()
//End
//nTam += IIf( Empty(nTam), 1, 0 )
//Cria um array para carregar os dados dos titulos
aCols:={} //Array(nTam,nUsado+1)

//Dbselectarea("TMPSE1")
//dbgotop()

//ncnt := 0
/*
If !Eof()
While  !EOF()
ncnt ++
//Posiciona no cadastro de natureza para carregar a descricao da mesma
Dbselectarea("SED")
Dbsetorder(1)
Dbseek(xFilial()+TMPSE1->E1_NATUREZ)

aCOLS[nCnt][1] := TMPSE1->E1_PREFIXO
aCOLS[nCnt][2] := TMPSE1->E1_NUM
aCOLS[nCnt][3] := TMPSE1->E1_PARCELA
aCOLS[nCnt][4] := TMPSE1->E1_TIPO
aCOLS[nCnt][5] := TMPSE1->E1_NATUREZ
aCOLS[nCnt][6] := SED->ED_DESCRIC
aCOLS[nCnt][7] := TMPSE1->E1_NUMLIQ
aCOLS[nCnt][8] := TMPSE1->E1_EMISSAO
aCOLS[nCnt][9] := TMPSE1->E1_VENCREA//TO
aCOLS[nCnt][10] := TMPSE1->E1_VALOR-TMPSE1->E1_SALDO
aCOLS[nCnt][11] := TMPSE1->E1_SALDO
aCOLS[nCnt][12] := TMPSE1->E1_PORTADO
aCOLS[nCnt][13] := TMPSE1->E1_NUMDPID
aCOLS[ncnt][nUsado+1] := .F.
Dbselectarea("TMPSE1")
dbSkip()
EndDo
Else
aCOLS[1][1] := " "
aCOLS[1][2] := " "
aCOLS[1][3] := " "
aCOLS[1][4] := " "
aCOLS[1][5] := " "
aCOLS[1][6] := " "
aCOLS[1][7] := " "
aCOLS[1][8] := cTod(" ")
aCOLS[1][9] := cTod(" ")
aCOLS[1][10] := 0
aCOLS[1][11] := 0
aCOLS[1][12] := " "
aCOLS[1][13] := " "
aCOLS[1][nUsado+1] := .F.
Endif
*/
nTotTit :=0
nTotValor :=0
nTotSaldo :=0
DBSELECTAREA("SE1")
DBSETORDER(2)
DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
WHILE SA1->A1_COD == SE1->E1_CLIENTE .AND. !EOF()
	IF !EMPTY(SE1->E1_BAIXA) .AND. SE1->E1_TIPO <> 'NCC' .AND. SE1->E1_TIPO <> 'AB-' .AND. SE1->E1_TIPO <> 'RA '
		DBSELECTAREA("SE5")
		DBSETORDER(7)
		DBSEEK(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE,.T.)
		lSoma := .T.
		DO WHILE SE5->E5_FILIAL = xFilial("SE5") .AND. SE5->E5_PREFIXO = SE1->E1_PREFIXO .AND. SE5->E5_NUMERO = SE1->E1_NUM .AND. ;
			SE5->E5_PARCELA = SE1->E1_PARCELA .AND. SE5->E5_TIPO = SE1->E1_TIPO .AND. SE5->E5_CLIFOR = SE1->E1_CLIENTE
			IF SE5->E5_TIPODOC $ "VL V2 BA LJ CP" .AND. SE5->E5_SITUACA <> "C" .AND. SE5->E5_MOTBX <> "LIQ" .And. SE5->E5_MOTBX <> "FAT"
				DBSELECTAREA("SED")
				DBSETORDER(1)
				DBSEEK(xFILIAL("SED")+SE1->E1_NATUREZ)
				
				AAdd( aCols, { SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_NATUREZ,LEFT(SED->ED_DESCRIC,20),;
				SE5->E5_MOTBX,SE1->E1_NUMLIQ, SE1->E1_VENCREA,SE5->E5_DATA,SE1->E1_VALOR,SE5->E5_VALOR,SE5->E5_BANCO,SE5->E5_DOCUMEN,.F. } )
				If lSoma
					nTotTit ++
					nTotValor += SE1->E1_VALOR
					lSoma := .F.
				EndIf
				nTotSaldo += SE5->E5_VALOR
			Elseif SE5->E5_TIPODOC == "ES" .AND. SE5->E5_SITUACA <> "C" .AND. SE5->E5_MOTBX <> "LIQ" .And. SE5->E5_MOTBX <> "FAT"
				DBSELECTAREA("SED")
				DBSETORDER(1)
				DBSEEK(xFILIAL("SED")+SE1->E1_NATUREZ)
				AAdd( aCols, { SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_NATUREZ,LEFT(SED->ED_DESCRIC,20),;
				SE5->E5_MOTBX,SE1->E1_NUMLIQ, SE1->E1_VENCREA,SE5->E5_DATA,SE1->E1_VALOR,SE5->E5_VALOR*-1,SE5->E5_BANCO,SE5->E5_DOCUMEN,.F. } )
				nTotSaldo -= SE5->E5_VALOR
			ENDIF
			DBSELECTAREA("SE5")
			DBSKIP()
		ENDDO
	ENDIF
	DBSELECTAREA("SE1")
	DBSKIP()
ENDDO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(aCols)
	AAdd( aCols, { "","","","","","","","",CtoD(""),CtoD(""),0.0,0.0,"","",.F. } )
EndIf
aSort(aCols,,,{|X,Y| X[10] > Y[10] } )
nTam := len(acols)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.F.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.F.})
AADD(aR,{"nTotSaldo" ,{158,200},"Pago:"     ,"@E 9,999,999.99",,,.F.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
//Dbselectarea("TMPSE1")
//DbClosearea("TMPSE1")

lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLiquidados   บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Liquidados()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Titulos Liquidados"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

//PRF  NUMERO P  TIPO  NATUREZA                              NUMLIQ    EMISSAO   VENCTO    VALOR          SALDO       PORTADOR
AADD(aHeader,{"Prefixo"       ,"E1_PREFIXO","@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Numero"        ,"E1_NUM"    ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Parc"          ,"E1_PARCELA","@!"         ,01,0,,,"C","SE1","V"})
AADD(aHeader,{"Tipo"          ,"E1_TIPO"   ,"@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Natureza"      ,"E1_NATUREZ","@!"         ,10,0,,,"C","SE1","V"})
AADD(aHeader,{"Descricao"     ,"ED_DESCRIC","@!"         ,15,0,,,"C","SED","V"})
AADD(aHeader,{"Liquidacao"    ,"E1_NUMLIQ" ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Emissao"       ,"E1_EMISSAO","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Vencto"        ,"E1_VENCTO" ,"  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Valor"         ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Saldo"         ,"E1_SALDO"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Portador"      ,"E1_PORTADO","@!"         ,03,0,,,"C","SE1","V"})

nUsado:=nUsado + 12

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE1")
cQUERY := "Select SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO, "
cQUERY += " SE1.E1_NATUREZ,SE1.E1_NUMLIQ,SE1.E1_EMISSAO,SE1.E1_VENCTO, SE1.E1_VENCREA, "
cQUERY += " SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_PORTADO,SE1.E1_NUMDPID "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
//cQUERY += " AND SE1.E1_VENCREA > '" + DTOS(dDataBase) + "'" //So os titulos a vencer
//cQUERY += " AND SE1.E1_SALDO > 0"
cQUERY += " AND SE1.E1_NUMLIQ <> '' "
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' "
cQUERY += " ORDER BY E1_NUMLIQ DESC, E1_EMISSAO DESC, E1_TIPO"
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSE1")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End
nTotTit    := nTam //Total de titulos
If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSE1")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SED")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSE1->E1_NATUREZ)
		
		aCOLS[nCnt][1] := TMPSE1->E1_PREFIXO
		aCOLS[nCnt][2] := TMPSE1->E1_NUM
		aCOLS[nCnt][3] := TMPSE1->E1_PARCELA
		aCOLS[nCnt][4] := TMPSE1->E1_TIPO
		aCOLS[nCnt][5] := TMPSE1->E1_NATUREZ
		aCOLS[nCnt][6] := SED->ED_DESCRIC
		aCOLS[nCnt][7] := TMPSE1->E1_NUMLIQ
		aCOLS[nCnt][8] := TMPSE1->E1_EMISSAO
		aCOLS[nCnt][9] := TMPSE1->E1_VENCREA//TO
		aCOLS[nCnt][10] := TMPSE1->E1_VALOR
		aCOLS[nCnt][11] := TMPSE1->E1_SALDO
		aCOLS[nCnt][12] := TMPSE1->E1_PORTADO
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSE1")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := " "
	aCOLS[1][2] := " "
	aCOLS[1][3] := " "
	aCOLS[1][4] := " "
	aCOLS[1][5] := " "
	aCOLS[1][6] := " "
	aCOLS[1][7] := " "
	aCOLS[1][8] := cTod(" ")
	aCOLS[1][9] := cTod(" ")
	aCOLS[1][10] := 0
	aCOLS[1][11] := 0
	aCOLS[1][12] := " "
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


nTotValor  :=0
nTotSaldo  :=0

For i:= 1 To len(acols)
	nTotValor  += acols[i][10]
	nTotSaldo  += acols[i][11]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})
AADD(aR,{"nTotSaldo" ,{158,200},"Saldo:"     ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

Dbselectarea("TMPSE1")
DbClosearea("TMPSE1")

Return


Static Function Faturados()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Faturas a Receber"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

//PRF  NUMERO P  TIPO  NATUREZA                              NUMLIQ    EMISSAO   VENCTO    VALOR          SALDO       PORTADOR
AADD(aHeader,{"Prefixo"       ,"E1_PREFIXO","@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Numero"        ,"E1_NUM"    ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Parc"          ,"E1_PARCELA","@!"         ,01,0,,,"C","SE1","V"})
AADD(aHeader,{"Tipo"          ,"E1_TIPO"   ,"@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Natureza"      ,"E1_NATUREZ","@!"         ,10,0,,,"C","SE1","V"})
AADD(aHeader,{"Descricao"     ,"ED_DESCRIC","@!"         ,15,0,,,"C","SED","V"})
AADD(aHeader,{"Fatura"        ,"E1_FATURA" ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Emissao"       ,"E1_EMISSAO","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Vencto"        ,"E1_VENCTO" ,"  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Valor"         ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Saldo"         ,"E1_SALDO"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Portador"      ,"E1_PORTADO","@!"         ,03,0,,,"C","SE1","V"})

nUsado += 12

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE1")
cQUERY := "Select SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO, "
cQUERY += " SE1.E1_NATUREZ,SE1.E1_FATURA,SE1.E1_EMISSAO,SE1.E1_VENCTO, SE1.E1_VENCREA, "
cQUERY += " SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_PORTADO,SE1.E1_NUMDPID "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
//cQUERY += " AND SE1.E1_VENCREA > '" + DTOS(dDataBase) + "'" //So os titulos a vencer
//cQUERY += " AND SE1.E1_SALDO > 0"
cQUERY += " AND SE1.E1_FATURA <> '' "
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' "
cQUERY += " ORDER BY E1_NUMLIQ DESC, E1_EMISSAO DESC, E1_TIPO"
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSE1")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End
nTotTit    := nTam //Total de titulos
If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSE1")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SED")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSE1->E1_NATUREZ)
		
		aCOLS[nCnt][1] := TMPSE1->E1_PREFIXO
		aCOLS[nCnt][2] := TMPSE1->E1_NUM
		aCOLS[nCnt][3] := TMPSE1->E1_PARCELA
		aCOLS[nCnt][4] := TMPSE1->E1_TIPO
		aCOLS[nCnt][5] := TMPSE1->E1_NATUREZ
		aCOLS[nCnt][6] := SED->ED_DESCRIC
		aCOLS[nCnt][7] := TMPSE1->E1_FATURA
		aCOLS[nCnt][8] := TMPSE1->E1_EMISSAO
		aCOLS[nCnt][9] := TMPSE1->E1_VENCREA//TO
		aCOLS[nCnt][10] := TMPSE1->E1_VALOR
		aCOLS[nCnt][11] := TMPSE1->E1_SALDO
		aCOLS[nCnt][12] := TMPSE1->E1_PORTADO
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSE1")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := " "
	aCOLS[1][2] := " "
	aCOLS[1][3] := " "
	aCOLS[1][4] := " "
	aCOLS[1][5] := " "
	aCOLS[1][6] := " "
	aCOLS[1][7] := " "
	aCOLS[1][8] := cTod(" ")
	aCOLS[1][9] := cTod(" ")
	aCOLS[1][10] := 0
	aCOLS[1][11] := 0
	aCOLS[1][12] := " "
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


nTotValor  :=0
nTotSaldo  :=0

For i:= 1 To len(acols)
	nTotValor  += acols[i][10]
	nTotSaldo  += acols[i][11]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})
AADD(aR,{"nTotSaldo" ,{158,200},"Saldo:"     ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk := ".T."
cTudoOk  := ".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

Dbselectarea("TMPSE1")
DbClosearea("TMPSE1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChsDevol     บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChsDevol()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Cheques Devolvidos"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

//PRF  NUMERO-P  TIPO  NATUREZA                                                      EMISSAO  VENCTO       VALOR          SALDO   PORTADOR
AADD(aHeader,{"Prefixo"       ,"E1_PREFIXO","@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Numero"        ,"E1_NUM"    ,"@!"         ,06,0,,,"C","SE1","V"})
AADD(aHeader,{"Parc"          ,"E1_PARCELA","@!"         ,01,0,,,"C","SE1","V"})
AADD(aHeader,{"Tipo"          ,"E1_TIPO"   ,"@!"         ,03,0,,,"C","SE1","V"})
AADD(aHeader,{"Natureza"      ,"E1_NATUREZ","@!"         ,10,0,,,"C","SE1","V"})
AADD(aHeader,{"Descricao"     ,"ED_DESCRIC","@!"         ,15,0,,,"C","SED","V"})
AADD(aHeader,{"Emissao"       ,"E1_EMISSAO","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Vencto"        ,"E1_VENCTO" ,"  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Valor"         ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Saldo"         ,"E1_SALDO"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Portador"      ,"E1_PORTADO","@!"         ,03,0,,,"C","SE1","V"})

nUsado:=nUsado + 11

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE1")
cQUERY := "Select SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO, "
cQUERY += " SE1.E1_NATUREZ,SE1.E1_NUMLIQ,SE1.E1_EMISSAO,SE1.E1_VENCTO, SE1.E1_VENCREA,"
cQUERY += " SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_PORTADO,SE1.E1_NUMDPID "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
//cQUERY += " AND SE1.E1_VENCREA > '" + DTOS(dDataBase) + "'" //So os titulos a vencer
//cQUERY += " AND SE1.E1_SALDO > 0"
cQUERY += " AND SE1.E1_NATUREZ IN ('10107','10407') " //Mudar naturezas para nat.usadas na Rava
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' "
cQUERY += " ORDER BY E1_EMISSAO"
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSE1
TCQUERY cQUERY Alias TMPSE1 New

TcSetField( "TMPSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TMPSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TMPSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TMPSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSE1")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End
nTotTit    := nTam //Total de titulos
If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSE1")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SED")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSE1->E1_NATUREZ)
		
		aCOLS[nCnt][1] := TMPSE1->E1_PREFIXO
		aCOLS[nCnt][2] := TMPSE1->E1_NUM
		aCOLS[nCnt][3] := TMPSE1->E1_PARCELA
		aCOLS[nCnt][4] := TMPSE1->E1_TIPO
		aCOLS[nCnt][5] := TMPSE1->E1_NATUREZ
		aCOLS[nCnt][6] := SED->ED_DESCRIC
		aCOLS[nCnt][7] := TMPSE1->E1_EMISSAO
		aCOLS[nCnt][8] := TMPSE1->E1_VENCREA//TO
		aCOLS[nCnt][9] := TMPSE1->E1_VALOR
		aCOLS[nCnt][10] := TMPSE1->E1_SALDO
		aCOLS[nCnt][11] := TMPSE1->E1_PORTADO
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSE1")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := " "
	aCOLS[1][2] := " "
	aCOLS[1][3] := " "
	aCOLS[1][4] := " "
	aCOLS[1][5] := " "
	aCOLS[1][6] := " "
	aCOLS[1][7] := cTod(" ")
	aCOLS[1][8] := cTod(" ")
	aCOLS[1][9] := 0
	aCOLS[1][10] := 0
	aCOLS[1][11] := " "
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


nTotValor  :=0
nTotSaldo  :=0

For i:= 1 To len(acols)
	nTotValor  += acols[i][9]
	nTotSaldo  += acols[i][10]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})
AADD(aR,{"nTotSaldo" ,{158,200},"Saldo:"     ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

Dbselectarea("TMPSE1")
DbClosearea("TMPSE1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProtestados  บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Protestados()

Local   _oDlg
Private aCOLS    := {}
Private aHEADER  := {}
Private aCols := {}
Private aTITVENC := {}

cTitulo:="Titulos Protestados"

nOpcx    := 7 //SO VISUALIZA

RegToMemory("SA1",.T.,.F.)

cLOJA    := SA1->A1_LOJA
cCLIENTE := SA1->A1_COD

DBSELECTAREA("SX3")
SX3->( DBSETORDER(2) )

aTam := TamSX3('E1_PREFIXO' ); Aadd(aHeader, {'Pref'     , 'E1_PREFIXO', PesqPict('SE1', 'E1_PREFIXO' , aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
aTam := TamSX3('E1_NUM' )    ; Aadd(aHeader, {'Numero'   , 'E1_NUM'    , PesqPict('SE1', 'E1_NUM'     , aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
aTam := TamSX3('E1_PARCELA' ); Aadd(aHeader, {'Parc'     , 'E1_PARCELA', PesqPict('SE1', 'E1_PARCELA' , aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
aTam := TamSX3('E1_TIPO' )   ; Aadd(aHeader, {'Tipo'     , 'E1_TIPO'   , PesqPict('SE1', 'E1_TIPO'    , aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
aTam := TamSX3('E1_EMISSAO') ; Aadd(aHeader, {'Emissao'  , 'E1_EMISSAO', PesqPict('SE1', 'E1_EMISSAO' , aTam[1]), aTam[1], aTam[2], '', USADO, 'D', 'SE1', ''})
aTam := TamSX3('E1_VENCTO')  ; Aadd(aHeader, {'Venciment', 'E1_VENCTO' , PesqPict('SE1', 'E1_VENCTO'  , aTam[1]), aTam[1], aTam[2], '', USADO, 'D', 'SE1', ''})
aTam := TamSX3('E1_VALOR')   ; Aadd(aHeader, {'Vlr Bruto', 'E1_VALOR'  , PesqPict('SE1', 'E1_VALOR'   , aTam[1]), aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
aTam := TamSX3('E1_VALLIQ')  ; Aadd(aHeader, {'Valor Liq', 'E1_VALLIQ' , PesqPict('SE1', 'E1_VALLIQ'  , aTam[1]), aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
aTam := TamSX3('E1_SALDO')   ; Aadd(aHeader, {'Saldo'    , 'E1_SALDO'  , PesqPict('SE1', 'E1_SALDO'   , aTam[1]), aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
aTam := TamSX3('ED_DESCRIC') ; Aadd(aHeader, {'Natureza' , 'ED_DESCRIC', PesqPict('SED', 'ED_DESCRIC' , aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SED', ''})

aAreaSA1 := GetArea()
cQuery := "SELECT COUNT(E1_FILIAL) AS REG "
cQuery += "FROM "  + RetSqlName("SE1") + " SE1, " + RetSqlName("SED") + " SED "
cQuery += "WHERE SE1.E1_CLIENTE+SE1.E1_LOJA = '" + cCLIENTE + cLOJA + "' AND SE1.E1_NATUREZ = SED.ED_CODIGO "
cQuery += "AND SE1.E1_TIPO='NDC' AND SE1.D_E_L_E_T_ <> '*' AND SED.D_E_L_E_T_ <> '*' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TEMP', .T., .T.)
nREGSE1N := TEMP->REG
TEMP->( DBCLOSEAREA() )

cQuery := "SELECT E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_VALLIQ, E1_SALDO, ED_DESCRIC, E1_VENCREA "
cQuery += "FROM "  + RetSqlName("SE1") + " SE1, " + RetSqlName("SED") + " SED "
cQuery += "WHERE SE1.E1_CLIENTE+SE1.E1_LOJA = '" + cCLIENTE + cLOJA + "' AND SE1.E1_NATUREZ = SED.ED_CODIGO "
cQuery += "AND SE1.E1_TIPO='NDC' AND SE1.D_E_L_E_T_ <> '*' AND SED.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA "

cQuery1 := ChangeQuery(cQuery)

Memowrit("PROTESTO.SQL",cQuery1)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'SE1N', .T., .T.)

TCSetField("SE1N", "E1_VALOR"  ,"N",14,2)
TCSetField("SE1N", "E1_VALLIQ" ,"N",14,2)
TCSetField("SE1N", "E1_SALDO"  ,"N",14,2)
TCSetField("SE1N", "E1_EMISSAO","D",08,2)
TCSetField("SE1N", "E1_VENCREA","D",08,2)
TCSetField("SE1N", "E1_VENCTO" ,"D",08,2)

DBSELECTAREA("SE1")
DBSETORDER(2)
DBSELECTAREA("SED")
DBSETORDER(1)
DBSELECTAREA("SE1N")
nUsado := 10 // Qtd de Campos
aCols := Array(nRegSE1N,nUsado+1)
DBGOTOP()
nTeste := 1
If !Eof()
	While !EOF()
		SE1->( DBSEEK( SE1N->E1_FILIAL+SE1N->E1_CLIENTE+SE1N->E1_LOJA+SE1N->E1_PREFIXO+SE1N->E1_NUM+SE1N->E1_PARCELA+'NF ' ) )
		aCols[ nteste, 1 ]  := SE1->E1_PREFIXO
		aCols[ nteste, 2 ]  := SE1->E1_NUM
		aCols[ nteste, 3 ]  := SE1->E1_PARCELA
		aCols[ nteste, 4 ]  := 'NF '
		aCols[ nteste, 5 ]  := SE1->E1_EMISSAO
		aCols[ nteste, 6 ]  := SE1->E1_VENCREA
		aCols[ nteste, 7 ]  := SE1->E1_VALOR
		aCols[ nteste, 8 ]  := SE1->E1_VALLIQ
		aCols[ nteste, 9 ]  := SE1->E1_SALDO
		aCols[ nteste, 10 ] := SE1N->ED_DESCRIC
		aCols[ nteste, 11 ] := .F.
		nTeste ++
		SE1N->( DBSKIP() )
	End
Else
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Cabecalho do Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotTit :=0
nTotValor  :=0
nTotSaldo  :=0

For i:= 1 To len(acols)
	nTotTit    ++
	nTotValor  += acols[i][7]
	nTotSaldo  += acols[i][9]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotTit"   ,{158,002},"Titulos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})
AADD(aR,{"nTotSaldo" ,{158,200},"Saldo:"     ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

SE1N->( DBCLOSEAREA() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInformSCI    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InformSCI()

Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
	mSCI := ZZ6_SPC
Else
	mSCI := CriaVar("ZZ6->ZZ6_SPC")
Endif

//mSCI := SA1->A1_SPC

@ 96,030 TO 300,650 DIALOG oDlgSCI TITLE "SCI"
@ 05,010 GET mSCI Size 280,50 MEMO

@ 070,080 BUTTON "Voltar"      SIZE 35,15 ACTION Close(oDlgSCI)
@ 070,120 BUTTON "Registrar"   SIZE 35,15 ACTION RegistrarSCI()
@ 070,160 BUTTON "Dt.Fundacao" SIZE 35,15 ACTION DtFundac()
@ 070,200 BUTTON "Credito"     SIZE 45,15 ACTION Credito()

ACTIVATE DIALOG oDlgSCI CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInfEquifax    บAutor  ณMicrosiga          บ Data ณ 20/01/06 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InfEquifax()

Local OFNT1

Private cTIPOEQF := "S", ;
oTIPOEQF, ;
oULTATUAL, ;
oEQUIFAX, ;
mEQUIFAX

DEFINE FONT oFnt1 NAME "Courier New" SIZE 08,14

@ 000,000 TO 400,690 DIALOG oDlgEquifax TITLE "Consulta Equifax"
@ 005,005 SAY "EQUIFAX EMPRESARIAL" COLOR CLR_GREEN Object oTIPOEQF
@ 015,005 SAY "Ultima atualizacao: " + Dtoc( Date() ) COLOR CLR_BLUE Object oULTATUAL
@ 025,005 GET mEQUIFAX Size 335,150 MEMO Object oEQUIFAX
@ 180,085 BUTTON "Imprimir"  SIZE 45,15 ACTION ImpEquifax()
@ 180,150 BUTTON "Alternar"  SIZE 45,15 ACTION AltEquifax( .T. )
@ 180,215 BUTTON "Atualizar" SIZE 45,15 ACTION AtuEquifax()
oEQUIFAX:SetFont( oFNT1 )
ACTIVATE DIALOG oDlgEquifax ON INIT AltEquifax( .F. ) CENTERED
Return NIL



***************

Static Function AltEquifax( lALTERNA )

***************

If ( cTIPOEQF == "S" .and. lALTERNA ) .or. ( cTIPOEQF == "P" .and. ! lALTERNA )
	mEQUIFAX := ""
	If ZAI->( Dbseek( xFilial() + SA1->A1_COD + SA1->A1_LOJA + "P" ) )
		mEQUIFAX := U_LeEqfPes()
	EndIf
	ObjectMethod( oTIPOEQF, "SetText( 'EQUIFAX PESSOAL' )" )
	cTIPOEQF := "P"
Else
	mEQUIFAX := ""
	If ZAI->( Dbseek( xFilial() + SA1->A1_COD + SA1->A1_LOJA + "E" ) )
		mEQUIFAX := U_LeEqfEmp()
	EndIf
	ObjectMethod( oTIPOEQF, "SetText( 'EQUIFAX EMPRESARIAL' )" )
	cTIPOEQF := "S"
EndIf
ObjectMethod( oULTATUAL, If( Empty( mEQUIFAX ), "SetText( 'Ultima atualizacao: NAO HOUVE' )", "SetText( 'Ultima atualizacao: ' + Dtoc( ZAI->ZAI_DATA ) )" ) )
oEQUIFAX:Refresh()
Return NIL



*************

Static Function AtuEquifax()

***************

SetPrvt( "oDLGEQF, oEQFEMPR, oEQFPESS, oATUEQF, oEQFOK, oEQFCANC, nEQFOPC, oSAY1, " )

If ! U_SENHA( '07' )
	Return NIL
EndIf

If SA1->A1_PESSOA == "F"
	cEQFEMPR := Space( 14 )
	cEQFPESS := SA1->A1_CGC
	nEQFOPC  := 2
Else
	cEQFEMPR := SA1->A1_CGC
	cEQFPESS := Space( 11 )
	nEQFOPC  := 1
EndIf

oDLGEQF := MSDIALOG():Create()
oDLGEQF:cName := "oDLGEQF"
oDLGEQF:cCaption := "Atualizar Equifax"
oDLGEQF:nLeft := 0
oDLGEQF:nTop := 0
oDLGEQF:nWidth := 211
oDLGEQF:nHeight := 175
oDLGEQF:lShowHint := .F.
oDLGEQF:lCentered := .T.

oEQFEMPR := TGET():Create(oDLGEQF)
oEQFEMPR:cName := "oEQFEMPR"
oEQFEMPR:nLeft := 90
oEQFEMPR:nTop := 22
oEQFEMPR:nWidth := 110
oEQFEMPR:nHeight := 21
oEQFEMPR:lShowHint := .F.
oEQFEMPR:lReadOnly := .F.
oEQFEMPR:Align := 0
oEQFEMPR:cVariable := "cEQFEMPR"
oEQFEMPR:bSetGet := {|u| If(PCount()>0,cEQFEMPR:=u,cEQFEMPR) }
oEQFEMPR:lVisibleControl := .T.
oEQFEMPR:lPassword := .F.
oEQFEMPR:lHasButton := .F.
oEQFEMPR:Picture := PesqPict( "SA1", "A1_CGC" )

oEQFPESS := TGET():Create(oDLGEQF)
oEQFPESS:cName := "oEQFPESS"
oEQFPESS:nLeft := 90
oEQFPESS:nTop := 67
oEQFPESS:nWidth := 110
oEQFPESS:nHeight := 21
oEQFPESS:lShowHint := .F.
oEQFPESS:lReadOnly := .F.
oEQFPESS:Align := 0
oEQFPESS:cVariable := "cEQFPESS"
oEQFPESS:bSetGet := {|u| If(PCount()>0,cEQFPESS:=u,cEQFPESS) }
oEQFPESS:lVisibleControl := .T.
oEQFPESS:lPassword := .F.
oEQFPESS:lHasButton := .F.
oEQFPESS:Picture := "@R 999.999.999-99"

oATUEQF := TRADMENU():Create(oDLGEQF)
oATUEQF:cName := "oATUEQF"
oATUEQF:nLeft := 9
oATUEQF:nTop := 11
oATUEQF:nWidth := 82
oATUEQF:nHeight := 93
oATUEQF:lShowHint := .F.
oATUEQF:lReadOnly := .F.
oATUEQF:Align := 0
oATUEQF:lVisibleControl := .T.
oATUEQF:nOption := 0
oATUEQF:bSetGet := {|u| If(PCount()>0,nEQFOPC:=u,nEQFOPC) }
oATUEQF:aItems := { "Empresarial:", "Pessoal:"}

oEQFOK := SBUTTON():Create(oDLGEQF)
oEQFOK:cName := "oEQFOK"
oEQFOK:nLeft := 116
oEQFOK:nTop := 103
oEQFOK:nWidth := 60
oEQFOK:nHeight := 25
oEQFOK:lShowHint := .F.
oEQFOK:lReadOnly := .F.
oEQFOK:Align := 0
oEQFOK:lVisibleControl := .T.
oEQFOK:nType := 1
oEQFOK:bAction := {|| ExeConsEqf() }

oEQFCANC := SBUTTON():Create(oDLGEQF)
oEQFCANC:cName := "oEQFCANC"
oEQFCANC:nLeft := 28
oEQFCANC:nTop := 103
oEQFCANC:nWidth := 60
oEQFCANC:nHeight := 25
oEQFCANC:lShowHint := .F.
oEQFCANC:lReadOnly := .F.
oEQFCANC:Align := 0
oEQFCANC:lVisibleControl := .T.
oEQFCANC:nType := 2
oEQFCANC:bAction := {|| oDLGEQF:End() }

If SA1->A1_PESSOA == "F"
	oEQFPESS:SetFocus()
Else
	oEQFEMPR:SetFocus()
EndIf

oDLGEQF:Activate()

Return NIL



***************

Static Function ExeConsEqf()

***************

If nEQFOPC == 1 .and. ! MsgBox( "Gera consulta com Score?", "Escolha", "YESNO" )
	nEQFOPC := 3
EndIf
If U_FIN037( If( nEQFOPC == 1, "S", If( nEQFOPC == 3, "E", "P" ) ), If( nEQFOPC == 1 .or. nEQFOPC == 3, cEQFEMPR, cEQFPESS ) )
	AltEquifax( .F. )
EndIf
oDLGEQF:End()
Return NIL



***************

Static Function ImpEquifax( lALTERNA )

***************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "da consulta ao Equifax"

Private limite       := 132
Private nomeprog     := "IMPEQUIFAX" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "EQUIFAX" // Coloque aqui o nome do arquivo usado para impressao em disco

SetPrint( "", wnrel, "", "", cDesc1, cDesc2, "", .F.,, .F., "P" )

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, "" )

If nLastKey == 27
	Return
Endif

RptStatus({|| RunImpEq() }, "Imprimindo consulta Equifax..." )
Return



***************

Static Function RunImpEq()

***************

Local cLINHA, cLINHA1

cLINHA1 := MemoLine( mEQUIFAX, 80, 1 )
cabec( "", cLINHA1, "", Nomeprog, "P", 18, {} )

nLINES := MlCount( mEQUIFAX, 80 )
For _I := 2 To nLINES
	cLINHA := MemoLine( mEQUIFAX, 80, _I )
	@ Prow() + 1,00 PSay cLINHA
	If Prow() > 60
		cabec( "", cLINHA1, "", Nomeprog, "P", 18, {} )
	EndIf
Next
Set Device to Screen
If aReturn[ 5 ] == 1
	Set Printer To
	dbCommitAll()
	OurSpool( wnrel )
Endif
MS_FLUSH()
Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnderecos    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Enderecos()
/*
ฑฑณSintaxe	 ณ AxVisual(ExpC1,ExpN1,ExpN2,ExpA1,ExpN3,ExpC1)			     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Alias do arquivo									        ณฑฑ
ฑฑณ			 ณ ExpN1 = Numero do registro 								        ณฑฑ
ฑฑณ			 ณ ExpN2 = Numero da opcao selecionada 						     ณฑฑ
ฑฑณ			 ณ ExpA1 = Array com os campos a serem mostrados			     ณฑฑ
ฑฑณ			 ณ ExpN3 = Coluna a ser impressa uma determinada mensagem	  ณฑฑ
ฑฑณ			 ณ ExpC2 = Mensagem a ser impressa							        ณฑฑ
ฑฑณ			 ณ ExpC3 = Funcao a ser executada antes de entrar na tela	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Generico 												              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

nReg := 120
nOpc := 1
Dbselectarea("SA1")
AxVisual("SA1",nReg,nOpc,,,SA1->A1_NOME,)
Dbselectarea("SA1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPedPend      บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PedPend()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

cTitulo:= "Pedido(s) Pendente(s)"
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

AADD(aHeader,{"Pedido"       ,"C5_NUM"    ,"@!"         ,06,0,,,"C","SC5","V"})
AADD(aHeader,{"Emissao"      ,"C5_EMISSAO","  "         ,08,0,,,"D","SC5","V"})
AADD(aHeader,{"Limite"       ,"E1_EMISSAO","  "         ,08,0,,,"D","SE1","V"})
AADD(aHeader,{"Valor"        ,"E1_VALOR"  ,"@E 9,999,999.99",12,2,,,"N","SE1","V"})
AADD(aHeader,{"Forma Pagto"  ,"ED_DESCRIC","@!"         ,40,0,,,"C","SED","V"})
AADD(aHeader,{"Condicao"     ,"E4_DESCRI" ,"@!"         ,25,0,,,"C","SE4","V"})
AADD(aHeader,{"Parcelas"     ,"E1_VALOR"  ,"@E 999"       ,03,0,,,"N","SE1","V"})
AADD(aHeader,{""             ,"C5_OK"     ,"@!"         ,01,0,,,"C","SC5","V"})

nUsado := 8

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SC5")
//cQUERY := "Select C5_NUM, C5_EMISSAO, C5_NATUREZ, C5_CONDPAG, C5_STATUS, C5_COTACAO"
cQUERY := "Select C5_NUM, C5_EMISSAO, C5_CONDPAG, C5_STATUS, C5_COTACAO"
cQUERY += " From " + RetSqlName( "SC5" ) + " SC5 "
cQUERY += " Where SC5.C5_CLIENTE+SC5.C5_LOJACLI = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SC5.C5_STATUS < '401' AND SC5.C5_DTCANC = '' "
//cQUERY += " AND ( SC5.C5_STATUS = '302' OR  SC5.C5_STATUS = '303' OR SC5.C5_STATUS = '304' "
//cQUERY += " OR  SC5.C5_STATUS = '305' OR  SC5.C5_STATUS = '104' OR SC5.C5_STATUS = '105' "
//cQUERY += " OR  SC5.C5_STATUS = '103' OR  SC5.C5_STATUS = '102' ) "
cQUERY += " AND D_E_L_E_T_ = ''"
cQUERY += " Order By SC5.C5_NUM"
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSC5
TCQUERY cQUERY Alias TMPSC5 New

TcSetField( "TMPSC5", "C5_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSC5")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End
nTotPed  := nTam //Total de titulos
If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSC5")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		cPed :=  TMPSC5->C5_NUM
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SC6")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSC5->C5_NUM)
		nValTot := 0
		While !Eof() .And. SC6->C6_NUM == cPed
			nValTot += (C6_VALOR)//+C6_DESCIPI)
			dbskip()
		End
		
		Dbselectarea("TMPSC5")
		
		aCond     := Condicao(nValTot,TMPSC5->C5_CONDPAG,dDataBase) //Verifica o numero de parcelas
		nParcelas := Len(aCond)
		
		Dbselectarea("SE4")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSC5->C5_CONDPAG)
		
		Dbselectarea("SED")
		Dbsetorder(1)
		//		Dbseek(xFilial()+TMPSC5->C5_NATUREZ)
		Dbseek(xFilial()+SE4->E4_NATUREZ)
		
		nFator := Iif(Substr(TMPSC5->C5_COTACAO,1,1)='1',0.10,Iif(Substr(TMPSC5->C5_COTACAO,1,1)='2',0.20,;
		Iif(Substr(TMPSC5->C5_COTACAO,1,1)='5', 0.50,Iif(Substr(TMPSC5->C5_COTACAO,1,1)='3',0.30,;
		Iif(Substr(TMPSC5->C5_COTACAO,1,1)='4',0.25,Iif(Substr(TMPSC5->C5_COTACAO,1,1)='7',0.70,1))))))
		
		cNatureza1 := Alltrim(SED->ED_DESCRIC)
		cNatureza2 := ''
		lAvista := iif( TMPSC5->C5_CONDPAG $ AllTrim(GetMv('MV_CONDLIB')), .T. , .F. )
		If lAvista //Se for a vista
			If !Empty(SA1->A1_NATAVNF)
				Dbseek(xfilial()+SA1->A1_NATAVNF)
				cNatureza1 := Alltrim(SED->ED_DESCRIC)
			Endif
			If nFator > 0.20 .And. nFator <= 0.70 .and. !Empty(SA1->A1_NATAVLI)
				Dbseek(xfilial()+SA1->A1_NATAVLI)
				cNatureza2 := Alltrim(SED->ED_DESCRIC)
			Elseif nFator > 0.20 .And. nFator <= 0.70 .and. Empty(SA1->A1_NATAVLI)
				If !Empty(SE4->E4_NATUR2)
					Dbseek(xfilial()+SE4->E4_NATUR2)
					cNatureza2 := Alltrim(SED->ED_DESCRIC)
				Endif
			Endif
		Else
			If !Empty(SA1->A1_NATAPNF)
				Dbseek(xfilial()+SA1->A1_NATAPNF)
				cNatureza1 := Alltrim(SED->ED_DESCRIC)
			Endif
			If nFator > 0.20 .And. nFator <= 0.70 .and. !Empty(SA1->A1_NATAPLI)
				Dbseek(xfilial()+SA1->A1_NATAPLI)
				cNatureza2 := Alltrim(SED->ED_DESCRIC)
			Elseif 	nFator > 0.20 .And. nFator <= 0.70 .and. Empty(SA1->A1_NATAPLI)
				If !Empty(SE4->E4_NATUR2)
					Dbseek(xfilial()+SE4->E4_NATUR2)
					cNatureza2 := Alltrim(SED->ED_DESCRIC)
				Endif
			Endif
		Endif
		
		aCOLS[nCnt][1] := TMPSC5->C5_NUM
		aCOLS[nCnt][2] := TMPSC5->C5_EMISSAO
		aCOLS[nCnt][3] := TMPSC5->C5_EMISSAO
		aCOLS[nCnt][4] := nValTot
		aCOLS[nCnt][5] := Substr(cNatureza1 + If(!empty(cNatureza2),' / ' +cNatureza2,''),1,25)//TMPSC5->C5_NATUREZ
		aCOLS[nCnt][6] := SE4->E4_DESCRI
		aCOLS[nCnt][7] := nParcelas
		aCOLS[nCnt][8] := ""
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSC5")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := " "
	aCOLS[1][2] := cTod(" ")
	aCOLS[1][3] := cTod(" ")
	aCOLS[1][4] := 0
	aCOLS[1][5] := " "
	aCOLS[1][6] := " "
	aCOLS[1][7] := 0
	aCOLS[1][8] := ""
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


nTotValor  :=0

For i:= 1 To len(acols)
	nTotValor  += acols[i][4]
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aR,{"nTotPed"   ,{158,002},"Pedidos:"   ,"@E 99999",,,.f.})
AADD(aR,{"nTotValor" ,{158,060},"Principal:" ,"@E 9,999,999.99",,,.f.})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,155,390}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,790}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)

DbClosearea("TMPSC5")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPedidos    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConsuPedidos()

//U_A_FAT020(.t.)
U_PFAT03(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalc    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Calc()

Alert("Funcao nao disponivel !!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPreAcordo    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcordo()

******** VARIAVEIS USADAS **********

cOPERAC   := "Aguardando confirmacao para inicio do processo..."
cMARCA    := GetMark()
lInvert  := .F.
aCPOBRW2  := {}
lCRIAIND  := .T.
lREFRECNO := .T.
dDATALIM  := Ctod( "  /  /  " )
lFLAG     := .F.
nVlPrinc   := 0
nTitSel    := 0
nJurosSel  := 0
nVltotal   := 0
nJurBase   := Getmv("MV_COBJUR3")

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := LeTitulos() }, OemToAnsi("Aguarde"), OemToAnsi("Atualizando Titulos do Cliente..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG1 Title OemToAnsi( "Titulos em Aberto - Selecione Titulos" )

@ 006,005 Say OemToAnsi("Valor Principal :") COLOR CLR_HBLUE
@ 006,050 Say nVlPrinc Picture "@E 999,999.99" COLOR CLR_RED object oVlPrinc

@ 006,085 Say OemToAnsi("Juros :") COLOR CLR_HBLUE
@ 006,120 Say nJurosSel Picture "@E 999,999.99" COLOR CLR_RED object oJurosSel

@ 006,150 Say OemToAnsi("Valor Total :") COLOR CLR_HBLUE
@ 006,200 Say nVlTotal Picture "@E 999,999.99" COLOR CLR_RED object oVlTotal

@ 006,250 Say OemToAnsi("Juros a.m :") COLOR CLR_HBLUE
@ 006,300 Get nJurBase SIZE 35,30 Picture "@E 999.99" Valid REFAZJUR() Object oJurbase

@ 014,005 Say OemToAnsi("Titulos :") COLOR CLR_HBLUE
@ 014,050 Say nTitSel Picture "@E 999" COLOR CLR_RED object oTitSel

Dbselectarea("MAR")

oBRW2  	   	:= MsSelect():New( "MAR", "MARCA", "", aCPOBRW2, @lInvert, @cMarca, { 030, 002, 240, 393 } )
oBRW2:oBrowse:lhasMark    := .T.
oBRW2:oBrowse:lCanAllmark := .T.
oBRW2:oBrowse:bAllMark    := { || MarcaTudo() }
oBRW2:bMark               := { || Marca()}

@ 255,150 Button OemToAnsi("_Confirma") Size 40,12 Action ProcPreAc() Object oCONFIRMA //ProcPreAc()
@ 255,210 Button OemToAnsi("_Sair") Size 40,12 Action oDLG1:End() Object oSAIRAc

Activate Dialog oDLG1 Centered //Valid SairAc()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcPreAc()

aHeader := {}
aCols   := {}

//a funcao VALIDPARC() esta neste programa
AADD(aHeader,{"Parcela"       ,"PARCELA","@!"             ,01,0,".F.",USADO,"C","","V"})
AADD(aHeader,{"Vencto"        ,"VENCTO" ,"  "             ,08,0,"U_XVALIDPARC('1')",USADO,"D","","V"})
AADD(aHeader,{"Principal"     ,"VALOR"  ,"@E 9,999,999.99",12,2,"U_XVALIDPARC('2')",USADO,"N","","V"})
AADD(aHeader,{"Taxa"          ,"TAXA"   ,"@E 999.99"      ,05,2,"U_XVALIDPARC('3')",USADO,"N","","V"})
AADD(aHeader,{"Juros"         ,"JUROS"  ,"@E 999,999.99"  ,09,2,"U_XVALIDPARC('4')",USADO,"N","","V"})
AADD(aHeader,{"Total"         ,"TOTAL"  ,"@E 9,999,999.99",12,2,".F.",USADO,"N","","V"})
AADD(aHeader,{""              ,"TESTE"  ,"@!"             ,01,0,"",USADO,"C","","V"})

nUsado2 := Len( aHeader )
aCols   := Array( 1 , ( nUsado2 + 1 ) )

aCOLS[1][1] := " "
aCOLS[1][2] := cTod(" ")
aCOLS[1][3] := 0
aCOLS[1][4] := 0
aCOLS[1][5] := 0
aCOLS[1][6] := 0
aCOLS[1][7] := ''
aCOLS[1][nUsado2+1] := .F.

nOpca  := 0
nValor := 0
nTotValor  :=0
nTaxasSim := GETMV("MV_COBTAXA")
nJurosSim := GETMV("MV_COBJUR1")
nJurosMin := GETMV("MV_COBJUR2")
dPriVenc  := dDatabase
nQtdParc  := 1
nInterParc:= 0
mObsPreAc := CriaVar("ZZ6->ZZ6_MEMO") //Para criar registro

nTam := 0
Dbselectarea("MAR")
Dbgotop()
While !Eof()
	//Se o titulo nao estiver marcado pula o registro
	If MAR->MARCA <> cMarca
		DbSkip()
		Loop
	EndIF
	nTotValor += MAR->SALDO + MAR->JUROS
	dbskip()
End

nValorFinal := nTotValor
nJurTotP    := 0.00
//Atualiza acols
aCOLS[1][1] := '01'
aCOLS[1][2] := dPriVenc
aCOLS[1][3] := nTotValor
aCOLS[1][4] := nTaxasSim
aCOLS[1][5] := 0
aCOLS[1][6] := nTotValor + nTaxasSim
cHrRet      := "08:00"

@ 080,000 To 550,600 DIALOG oDlg2 TITLE OemToAnsi("Pre Acordo Cliente - "+SA1->A1_NOME)

@ 20 , 008 SAY OemToAnsi("Principal :")
@ 20 , 050 Get nTotValor Picture "@E 9,999,999.99"  SIZE 50,80 Valid U_XSimparc()

@ 20 , 100 SAY OemToAnsi("Taxas R$ :")
@ 20 , 150 Get nTaxasSim Picture "@E 9,999.99"  SIZE 50,80 Valid U_XSimparc()

@ 20 , 200 SAY OemToAnsi("Juros % :")
@ 20 , 250 Get nJurosSim Picture "@E 999.99" SIZE 50,80 Valid U_XSimparc() Object oJurosSim

@ 35 , 008 SAY OemToAnsi("Venc 1 :")
@ 35 , 050 Get dPriVenc  SIZE 50,80 Valid U_XSimparc()

@ 35 , 100 SAY "Hr Retorno :"
@ 35 , 140 GET cHrRet SIZE 30,30 Picture "99:99" Valid U_VldHora( cHrRet )

@ 35 , 190 SAY OemToAnsi("Parcelas :")
@ 35 , 220 Get nQtdParc  Picture "@E 999" SIZE 20,40 Valid U_XSimparc()

@ 35 , 250 SAY OemToAnsi("Intervalo :")
@ 35 , 280 Get nInterParc Picture "@E 999" SIZE 20,40 Valid IIF(nQtdParc > 1, IIF(nInterParc > 0, .T.,.F.),.T.) .And. U_XSimparc()

@ 205, 008 SAY OemToAnsi("Obs :")
@ 205 ,025 GET mObsPreAc Size 160,30 MEMO

@ 210 , 200 SAY OemToAnsi("Valor Final :")
@ 210 , 250 Say nValorFinal Object oValorFinal COLOR CLR_HBLUE //Picture "@E 9,999,999.99"

@ 220 , 200 SAY OemToAnsi("Juros Total:")
@ 220 , 250 Say nJurTotP Object oJurTotP COLOR CLR_HBLUE //Picture "@E 9,999,999.99"

oValorFinal:SetText( AllTrim( Transform( nValorFinal, "@E 999,999.99" ) ) )
oJurTotP:SetText( AllTrim( Transform( nJurTotP, "@E 999,999.99" ) ) )

@ 15, 003	To 52, 300

nOpcx      := 2
oGet := MsGetDados():New( 060, 002, 200, 300, nOpcx,,,"",.T.,,,,200)

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1,if(oGet:TudoOk(),oDlg2:End(),nOpca:=0)},{||oDlg2:End()})

If ( nOpcA == 1 .And. !Empty(aCols)) //se confirmar
	// comentado por ana dia 04/06/06 - sera adicionado no final
	//mCob := Trim(ZZ6->ZZ6_MEMO)+IIF(!Empty(mCob),Chr(13)+chr(10),'') //Aplica um enter se ja tiver informacao
	mCob := IIF(!Empty(mCob),Chr(13)+chr(10),'') // a linha acima foi substituida por esta
	mCob := Trim(mCob)+Chr(13)+chr(10)
	mCob := Trim(mCob)+"PRE ACORDO - Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))
	mCob := Trim(mCob)+Chr(13)+chr(10)+Chr(13)+chr(10)
	mCob := Trim(mCob)+"Titulos originais: "+Transform( nVlTotal, "@E 999,999.99" )+Chr(13)+chr(10)
	Dbselectarea("MAR")
	dbgotop()
	nJurosOri := 0
	nValOri   := 0
	nDiasOri  := 0
	While !Eof()
		IF MAR->MARCA == cMARCA
			mCob := Trim(mCob)+MAR->TITULO+" "+Transform( MAR->SALDO, "@E 999,999.99" )+" "+;
			Transform( MAR->JUROS, "@E 999,999.99" )+" "+Transform( MAR->SALDO+MAR->JUROS, "@E 999,999.99" )+" "+;
			DTOC(MAR->EMISSAO)+" "+DTOC(MAR->VENCTO)+" "+MAR->NUMDEP+CHR(13)+chr(10)
			
			nJurosOri += Round((MAR->JUROS/MAR->SALDO)*100,2) //% juros por parcela
			
			If MAR->VENCTO < dDatabase
				nDiasOri  += (dDatabase-MAR->VENCORI)//Mudado para calcular com base no venc original
			Endif
		Endif
		dbskip()
	End
	
	nJurori := Round((nJurosOri/nDiasOri)*30,2) //Utilizado no envio do e-mail mais abaixo
	
	mCob := Trim(mCob)+cHR(13)+CHR(10)	 //Pula mais uma linha
	mCob := Trim(mCob)+"Acordo: "+Transform( nValorFinal, "@E 999,999.99" )+Chr(13)+CHR(10)
	For p := 1 To len(aCols)
		If p == 1 //Carrega o primeiro vencimento com retorno
			dDtRet := Acols[p,2]
		Endif
		mCob := Trim(mCob)+Acols[p,1]+" "+DtoC(Acols[p,2])+" "+Transform( Acols[p,3], "@E 999,999.99" )+" "+;
		Transform( Acols[p,4], "@E 9,999.99" )+" "+Transform( Acols[p,5], "@E 9,999.99" )+" "+;
		Transform( Acols[p,6], "@E 999,999.99" )+Chr(13)+CHR(10)
	Next
	If !Empty(mObsPreAc)
		mCob := Trim(mCob)+cHR(13)+CHR(10)	 //Pula mais uma linha
		mCob := Trim(mCob)+"Observacao :"+cHR(13)+CHR(10)
		mCob := Trim(mCob)+mObsPreAc
	Endif
	//	mCob   := ZZ6->ZZ6_MEMO
	mCob   := Trim(mCob)+Chr(13)+CHR(10)+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> Retorno agendado para "+dToC(dDtRet)+" "+cHrRet //Atualiza variavel da tela principal
	Dbselectarea("ZZ6")
	Reclock("ZZ6",.F.)
	Replace ZZ6_RETORN With dDtRet
	Replace ZZ6_HORRET With cHrRet
	Replace ZZ6_TIPRET With "3"
	Replace ZZ6_ULCONT With dDatabase
	Replace ZZ6_MEMO   With Trim(ZZ6->ZZ6_MEMO)+mCob //alterado por ana 04/06/06
	MSUNLOCK()
	//Atualiza historico da cobranca
	Reclock("ZA2",.F.)
	Replace ZA2_QUALI With 'P'
	Replace ZA2_TIPO  With IF(ZA2->ZA2_TIPO == 'C','R',ZA2->ZA2_TIPO)
	Replace ZA2_MEMO  With mCob
	msunlock()
	mCob := Trim(ZZ6->ZZ6_MEMO)
	If nDISCREG <> 0
		ZA8->( DbGoto( nDISCREG ) )
		Reclock("ZA8",.F.)
		Replace ZA8_QUALI With 'P'
		msunlock()
	EndIf
	
	//Se houve alguma parcela com juros menor que 4, envia o e-mail
	If nJuRosSim < GETMV("MV_COBJUR2") .Or. nJurori < GETMV("MV_COBJUR2")
		cParc := ''
		For p := 1 To Len(aCols)
			cParc += Acols[p,1]+" "+DtoC(Acols[p,2])+" "+Transform( Acols[p,3], "@E 999,999.99" )+" "+;
			Transform( Acols[p,4], "@E 9,999.99" )+" "+Transform( Acols[p,5], "@E 9,999.99" )+" "+;
			Transform( Acols[p,6], "@E 999,999.99" )+" <P>"
		Next
		
		cTit := ''
		Dbselectarea("MAR")
		dbgotop()
		While !Eof()
			IF MAR->MARCA == cMARCA
				cTit += MAR->TITULO+" "+Transform( MAR->SALDO, "@E 999,999.99" )+" "+;
				Transform( MAR->JUROS, "@E 999,999.99" )+" "+Transform( MAR->SALDO+MAR->JUROS, "@E 999,999.99" )+" "+;
				DTOC(MAR->EMISSAO)+" "+DTOC(MAR->VENCTO)+" "+MAR->NUMDEP+" <P>"
			Endif
			dbskip()
		End
		cJurOri := IIf(nJurori < GETMV("MV_COBJUR2"),"Juros aplicado no(s) titulo(s) originais, menor que o permitido: "+Transform( nVlTotal, "@E 999.99" )+"%",'')
		
		CONNECT SMTP SERVER AllTRIM(GETMV("MV_RELSERV")) ACCOUNT AllTRIM(GETMV("MV_RELACNT")) PASSWORD AllTRIM(GETMV("MV_RELPSW"))
		
		SEND MAIL FROM "Setor de Cobranca <financeiro@ravaembalagens.com.br>" to "Destinatario <email@dominio>" ;
		SUBJECT "Pre-Acordo - SISCOB (Juros)" ;
		BODY "Juros Aplicado abaixo do parametro :"+Transform( nJurosSim, "@E 999.99" )+"% <P>"+;
		"Cliente :"+SA1->A1_NOME+" <P>"+;
		"PRE ACORDO - Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))+" <P>"+" <P>"+;
		"Titulos originais: "+Transform( nVlTotal, "@E 999,999.99" )+" <P>"+;
		cJurori+" <P>"+;
		"Prf Numero P Tipo Valor  Juros  Total  Emissao  Vencto  Num deposito"+" <P>"+;
		cTit+" <P>"+;
		"Acordo: "+Transform( nValorFinal, "@E 999,999.99" )+" <P>"+;
		"Parc Vento   Valor  Taxa  Juros  Total"+" <P>"+;
		cParc+" <P>"+;
		"Observa็ใo: "+mObsPreAc
		
		DISCONNECT SMTP SERVER
	Endif
	Dbselectarea("MAR")
	DbCloseArea("MAR")
	Close( oDLG1 )
	Return .T.
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XVALIDPARC(cTipo)

nJurDia     := nJurosSim/30
nValorFinal := 0

If cTipo == '1' //ALTEROU O VENCIMENTO
	aCOLS[n][2] := M->VENCTO
	nDias    := M->VENCTO - dDatabase
	nValParc := aCOLS[n][3]
	nValTaxa := aCOLS[n][4]
	nValJur  := Round((nValParc*(nJurDia*nDias))/100,2)
ElseIf cTipo == '2' //ALTEROU O VALOR PRINCIPAL
	aCOLS[n][3] := M->VALOR
	nDias    := aCOLS[n][2] - dDatabase
	nValParc := M->VALOR
	nValTaxa := aCOLS[n][4]
	nValJur  := Round((nValParc*(nJurDia*nDias))/100,2)
ElseIf cTipo == '3'  //ALTEROU A TAXA
	aCOLS[n][4] := M->TAXA
	nDias    := aCOLS[n][2] - dDatabase
	nValParc := aCOLS[n][3]
	nValTaxa := M->TAXA
	nValJur  := Round((nValParc*(nJurDia*nDias))/100,2)
ElseIf cTipo == '4'  //ALTEROU O JUROS
	nDias    := aCOLS[n][2] - dDatabase
	nValParc := aCOLS[n][3]
	nValTaxa := aCOLS[n][4]
	nValJur  := M->JUROS
Endif

aCOLS[n][5] := nValJur
aCOLS[n][6] := nValParc + nValTaxa + nValJur

nValTotP := 0
nJurTotP := 0
nJTotP   := 0
ndias    := 0
For nCond := 1 to Len(aCols)
	nValorFinal += aCOLS[nCond][6]
	nJurTotP    += aCOLS[nCond][5]
	nJTotP      += Round((aCOLS[nCond][5]/aCOLS[nCond][3])*100,2) //% juros por parcela
	If aCOLS[nCond][2] > dDatabase
		nDias       += aCOLS[nCond][2]-dDatabase
	Endif
Next nCond

nJurosSim := Round((nJTotP/nDias)*30,2)

oGet:ForceRefresh()
oValorFinal:SetText( AllTrim( Transform( nValorFinal, "@E 999,999.99" ) ) )
oJurTotP:SetText( AllTrim( Transform( nJurTotP, "@E 9,999.99" ) ) )
oJurosSim:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Refaz o acols com base nos parametros principais.          บฑฑ
ฑฑบ          ณ Simula o resultado final das parcelas.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XSIMPARC()

If nJurosSim < nJurosMin
	Alert("Juros da Simulacao abaixo do permitido.")
	Return(.f.)
Endif
//Valor Principal     = nTotValor
//Taxa                = nTaxasSim
//Juros Mes           = nJurosSim
//primeiro vencimento = dPriVenc
//Numero de parcelas  = nQtdParc
//Intervalo de dias   = nInterParc

aCols:=Array(nQtdParc,nUsado2+1)

dVenc       := dPriVenc
nJurDia     := nJurosSim/30
nValorFinal := 0
nTot1  := 0 //auxilia no calculo do valor da parcela
nTot2  := 0 //auxilia no calculo do valor da taxa
For nCond := 1 to nQtdParc
	If nCond <> nQtdParc
		nDias    := dVenc - dDatabase
		nValParc := Round((nTotValor/nQtdParc),2)
		nValTaxa := Round((nTaxasSim/nQtdParc),2)
		nValJur  := Round((nValParc*(nJurDia*nDias))/100,2)
	Else
		nDias    := dVenc - dDatabase
		nValParc := nTotValor-nTot1
		nValTaxa := nTaxasSim-nTot2
		nValJur  := Round((nValParc*(nJurDia*nDias))/100,2)
	Endif
	
	aCOLS[nCond][1] := StrZero(nCond,2)
	aCOLS[nCond][2] := dVenc
	aCOLS[nCond][3] := nValParc
	aCOLS[nCond][4] := nValTaxa
	aCOLS[nCond][5] := nValjur
	aCOLS[nCond][6] := nValParc + nValTaxa + nValJur
	aCols[nCond,nUsado2+1] := .F.										// controle de delecao
	dVenc := dVenc + nInterParc
	nValorFinal += aCOLS[nCond][6]
	nTot1 += aCOLS[nCond][3]
	nTot2 += aCOLS[nCond][4]
Next nCond

oGet:ForceRefresh()
oValorFinal:SetText( AllTrim( Transform( nValorFinal, "@E 999,999.99" ) ) )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SairAc()

//If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
DbCloseArea("MAR")

dbselectarea("SA1")

//Close( oDLG1 )

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarcaTudo()

Local nREG := MAR->( Recno() )

MAR->( DbGotop() )
While ! Eof()
	IF MAR->MARCA == cMARCA
		MAR->MARCA := "  "
		nTitSel    --
		nVlPrinc   -= MAR->SALDO
		nJurosSel  -= MAR->JUROS
		nVltotal   -= (MAR->SALDO+MAR->JUROS)
	Else
		MAR->MARCA := cMARCA
		nTitSel    ++
		nVlPrinc   += MAR->SALDO
		nJurosSel  += MAR->JUROS
		nVltotal   += (MAR->SALDO+MAR->JUROS)
	Endif
	MAR->( DbSkip() )
Enddo
MAR->( dbGoto( nREG ) )

oBRW2:oBrowse:Refresh()
ObjectMethod( oVlPrinc, "SetText( nVlPrinc )" )
ObjectMethod( oTitSel , "SetText( nTitSel  )" )
ObjectMethod( oJurosSel, "SetText( nJurosSel )" )
ObjectMethod( oVlTotal, "SetText( nVlTotal )" )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Marca()

If MAR->MARCA == cMARCA
	//	MARC->( DbEval( { || MARC->MARCA := cMARCA } ) )
	MAR->MARCA := cMARCA
	nTitSel    ++
	nVlPrinc   += MAR->SALDO
	nJurosSel  += MAR->JUROS
	nVltotal   += (MAR->SALDO+MAR->JUROS)
Else
	//	MARC->( DbEval( { || MARC->MARCA := "  " } ) )
	MAR->MARCA := "  "
	nTitSel    --
	nVlPrinc   -= MAR->SALDO
	nJurosSel  -= MAR->JUROS
	nVltotal   -= (MAR->SALDO+MAR->JUROS)
End

//MARC->( DbGotop() )
oBrw2:oBrowse:Refresh()
ObjectMethod( oVlPrinc , "SetText( nVlPrinc )" )
ObjectMethod( oTitSel  , "SetText( nTitSel  )" )
ObjectMethod( oJurosSel, "SetText( nJurosSel )" )
ObjectMethod( oVlTotal , "SetText( nVlTotal )" )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function REFAZJUR()

MAR->( DbGotop() )

nJurosSel := 0
nVlTotal  := 0

While !Eof()
	
	If MAR->VENCTO < dDatabase
		nJurosTit  := ((MAR->SALDO*nJurBase)/100)/30 //Juros por dia de atraso
		nDias      := dDatabase-MAR->VENCORI
	Else
		nJurosTit  := 0
		nDias      := 0
	Endif
	If MAR->MARCA == cMarca
		nJurosSel  += (nJurosTit*nDias)
		nVltotal   += MAR->SALDO + (nJurosTit*nDias)
	Endif
	Reclock("MAR",.F.)
	Replace JUROS   With (nJurosTit*nDias)
	msunlock()
	Dbselectarea("MAR")
	dbskip()
End

MAR->( DbGotop() )

oBrw2:oBrowse:Refresh()
oJurBase:SetText( AllTrim( Transform( nJurBase, "@E 999,999.99" ) ) )
ObjectMethod( oJurosSel, "SetText( nJurosSel )" )
ObjectMethod( oVlTotal, "SetText( nVlTotal )" )

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Letitulos()

aCAMPOS := { { "MARCA"  , "C", 02, 0 }, ;
{ "TITULO"     , "C", 19, 0 }, ;
{ "CLIENTE"    , "C", 06, 0 }, ;
{ "LOJA"       , "C", 02, 0 }, ;
{ "NATUREZA"   , "C", 05, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "EMISSAO"    , "D", 08, 0 }, ;
{ "VENCTO"     , "D", 08, 0 }, ;
{ "VLRPRIN"    , "N", 09, 2 }, ;
{ "JUROS"      , "N", 09, 2 }, ;
{ "PAGTO"      , "N", 09, 2 }, ;
{ "SALDO"      , "N", 09, 2 }, ;
{ "NUMDEP"     , "C", 09, 0 }, ;
{ "PORTADOR"   , "C", 03, 0 }, ;
{ "CARTEIRA"   , "C", 10, 0 }, ;
{ "PEDIDO"     , "C", 06, 0 }, ;
{ "VENCORI"    , "D", 08, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "MAR", .F., .F. )
Index On VENCTO TO &cARQEMP

dbselectarea("SE1")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
cQUERY += " SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_VENCREA, SE1.E1_VENCTO, SE1.E1_PORTADO, SE1.E1_PEDIDO, "
cQUERY += " SE1.E1_NATUREZ, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_EMISSAO, SE1.E1_NUMDPID, SE1.E1_STATCOB "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_SALDO > 0 "
cQUERY += " AND SE1.D_E_L_E_T_ = '' "
cQUERY += " Order By SE1.E1_VENCREA"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TITSE1 New

TcSetField( "TITSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TITSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TITSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TITSE1")
dbgotop()

nVlPrinc   := 0
nJuros     := 0
nVencidos  := 0
nTitSel    := 0
nJurBase   := Getmv("MV_COBJUR3")
//Solcitar confirmar juros base

While !Eof()
	If TITSE1->E1_TIPO $ 'RA NCC AB-'
		dbskip()
		Loop
	Endif
	
	If TITSE1->E1_VENCREA < dDatabase
		nJurosTit  := ((TITSE1->E1_SALDO*nJurBase)/100)/30 //Juros por dia de atraso
		nDias      := dDatabase-TITSE1->E1_VENCTO//VENCREA//Mudado para calcular o juros em cima do venc original
	Else
		nJurosTit  := 0
		nDias      := 0
	Endif
	
	Dbselectarea("TITSE1")
	Reclock("MAR",.T.)
	If TITSE1->E1_VENCREA < dDatabase
		Replace MARCA   With cMarca
		nTitSel    ++
		nVlPrinc   += TITSE1->E1_SALDO
		nJurosSel  += (nJurosTit*nDias)
		nVltotal   += TITSE1->E1_SALDO + (nJurosTit*nDias)
	Else
		Replace MARCA   With ''
	Endif
	
	Replace TITULO  With TITSE1->E1_PREFIXO+"-"+TITSE1->E1_NUM+"/"+TITSE1->E1_PARCELA+" - "+TITSE1->E1_TIPO
	Replace CLIENTE With TITSE1->E1_CLIENTE
	Replace LOJA    With TITSE1->E1_LOJA
	Replace NATUREZA With TITSE1->E1_NATUREZ
	Replace EMISSAO With TITSE1->E1_EMISSAO
	Replace VENCTO  With TITSE1->E1_VENCREA
	Replace VLRPRIN With TITSE1->E1_VALOR
	Replace JUROS   With (nJurosTit*nDias)
	Replace PAGTO   With TITSE1->E1_VALOR-TITSE1->E1_SALDO
	Replace SALDO   With TITSE1->E1_SALDO
	Replace NUMDEP  With TITSE1->E1_NUMDPID
	Replace PORTADOR With TITSE1->E1_PORTADO
	Replace PEDIDO  With TITSE1->E1_PEDIDO
	Replace VENCORI With TITSE1->E1_VENCTO
	msunlock()
	Dbselectarea("TITSE1")
	dbskip()
End

Dbclosearea("TITSE1")

MAR->( DbGotop() )

aCPOBRW2  :=  { { "MARCA"    ,, OemToAnsi( "" ) }, ;
{ "TITULO"      ,, OemToAnsi( "Titulo" ) }, ;
{ "NATUREZA"    ,, OemToAnsi( "Natureza" ) }, ;
{ "EMISSAO"     ,, OemToAnsi( "Emissao" ) }, ;
{ "VENCTO"      ,, OemToAnsi( "Vencto" ) }, ;
{ "PORTADOR"    ,, OemToAnsi( "Portador" ) }, ;
{ "VLRPRIN"     ,, OemToAnsi( "Principal"), "@E 99,999.99" }, ;
{ "SALDO"       ,, OemToAnsi( "Saldo" ), "@E 99,999.99" }, ;
{ "JUROS"       ,, OemToAnsi( "Juros" ), "@E 999,999.99" }, ;
{ "PAGTO"       ,, OemToAnsi( "Pago" ) , "@E 99,999.99" }, ;
{ "NUMDEP"      ,, OemToAnsi( "Num Depoosito"), "@R 99999999-9" }, ;
{ "CARTEIRA"    ,, OemToAnsi( "Carteira" ) }, ;
{ "PEDIDO"      ,, OemToAnsi( "Pedido" ) }}

Return .T.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHelpCob    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function HelpCob()

Alert("Funcao nao disponivel !!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpressao    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Impressao()

xCREDITOS  := 0
xACUMULADO := 0
xQTDCOMPRA := 0
xAVENCER   := 0
xVENCIDOS  := 0
xPAGOS     := 0
xMAIOR     := 0
xLIQUID    := 0
xFATURA    := 0
aTITVENC   := {}
xAVENCNEG  := 0
xVENCNEG   := 0

aSource := {}
aTarget := {}
AADD(aSource,"1 - Titulos Pagos")
AADD(aSource,"2 - Titulos Vencidos")
AADD(aSource,"3 - Titulos a Vencer")
AADD(aSource,"4 - Titulos Liquidados")
AADD(aSource,"5 - Titulos Protestados")
AADD(aSource,"6 - Titulos Devolvidos")
AADD(aSource,"7 - SCI")
AADD(aSource,"8 - Cobranca Externa")
AADD(aSource,"9 - Memo Cobranca")
AADD(aSource,"A - Titulos Faturados")

nSource := 0
nTarget := 0
@ 096,030 TO 400,580 DIALOG oDlg9 TITLE "Configuracao da Impressao"

@ 020,004 Say OemToAnsi("Opcoes disponiveis:")
@ 020,150 Say OemToAnsi("Opcoes Selecionadas:")

@ 030,004 ListBox nSource Items aSource Size 100,65 Object oSource
@ 030,150 ListBox nTarget Items aTarget Size 100,65 Object oTarget


@ 030,110 Button OemToAnsi("_Adicionar >>") Size 36,16 Action AddDemo()    Object oBtnAdd
@ 055,110 Button OemToAnsi("<< _Remover")   Size 36,16 Action RemoveDemo() Object oBtnRem


@ 115,190 BUTTON OemToAnsi("Confirma Impressao") SIZE 75,15 ACTION Imp()
@ 135,190 BUTTON OemToAnsi("Sair" ) SIZE 75,15 ACTION Close(oDlg9)
ACTIVATE DIALOG oDlg9 CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/19/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imp()

Processa( { || CalcFor() } )

//FOR I:=1 TO LEN(aTARGET)
// MSGSTOP(aTARGET[I])
//NEXT

Private Titulo     := "Impressao da Consulta - T E S T E"
cString    := "SA1"
wnrel      := "P_FIN009"
CbTxt      := ""
cDesc1     := "O objetivo deste relatขrio  EMITIR uma tabela de precos"
cDesc2     := ""
Tamanho    := "M"
aReturn    := { "Zebrado", 1,"Estoque", 2, 2, 1, "",1 }
nLastKey   := 0
cPerg      := ""
_abec1     := ""
_abec2     := ""
cRodaTxt   := ""
nCntImpr   := 0
nTipo      := 0
nomeprog   := "P_FIN009"
cCondicao  := ""
I          := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// pergunte(cPerg,.F.)
wnrel:="P_FIN009"
SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,"",.T.,"",.T.,Tamanho,,.T.)

If nLastKey == 27
	Return .T.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .T.
Endif

RptStatus({|| R010Imp()},Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/18/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function R010Imp()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis para controle do cursor de progressao do relatorio ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotRegs := 0
nMult    := 1
nPosAnt  := 4
nPosAtu  := 4
nPosCnt  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis locais exclusivas deste programa                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lContinua   := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Contadores de linha e pagina                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Li    := 06
m_pag := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis locais exclusivas deste programa                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aFinal   := {}
_I       := 0
m_qtd    := 0
m_qtd_cx := 0
m_qtd_un := 0
ntot_it  := 0
ntot_iped:= 0
n_reg    := 0
Time     := Time()
nValBaix := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se deve comprimir ou nao                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTipo := 15
nPAGINA := 1
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os Cabecalhos                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Posiciona no acumulado do cliente
Dbselectarea("ZZ9")
Dbseek(xFiliaL()+SA1->A1_COD+SA1->A1_LOJA)

DBSELECTAREA("SE5")
SET FILTER TO E5_SITUACA<>"C" .AND. E5_TIPODOC<>"ES"

@ 01,00 PSAY CHR(018)
IF LefT(SA1->A1_SATIV8,1) == "S"
	@ 01,01 PSAY "RAVA EMB. LTDA   ** CLIENTE ESPECIAL **   T E S T E     DATA:"+DTOC( DDATABASE ) + SPACE(02)+TIME()
ELSE
	@ 01,01 PSAY "RAVA EMB. LTDA   POSICAO DE CLIENTE   -   T E S T E      DATA:"+DTOC( DDATABASE ) + SPACE(02)+TIME()
ENDIF
@ 02,03 PSAY "CODIGO-NOME"
@ 02,50 PSAY "CGC"
@ 02,70 PSAY "DT SCI"

@ 03,03 PSAY SA1->A1_COD+SA1->A1_NOME
@ 03,50 PSAY SA1->A1_CGC
@ 03,70 PSAY SA1->A1_dtsci
@ 04,03 PSAY "REPRESENTATE   "+SA3->A3_NOME

IF nPagina == 1
	@ 05,03 PSAY "PRIMEIRA COMPRA "+IIF((ZZ9->ZZ9_DTPRIC < SA1->A1_PRICOM .AND. !Empty(ZZ9->ZZ9_DTPRIC)).OR.Empty(SA1->A1_PRICOM),;
	DTOC(ZZ9->ZZ9_DTPRIC),DTOC(SA1->A1_PRICOM))
	
	@ 05,40 PSAY "DATA DA FUNDACAO "+DTOC(SA1->A1_FUNDAC)
	@ 06,03 PSAY "MAIOR    COMPRA "+TRANSFORM(xMAIOR, "@E 999,999,999.99")
	@ 06,40 PSAY "MAIOR    ATRASO "+STR(SA1->A1_MATR)+"  MEDIA "+STR(SA1->A1_METR)
	@ 07,03 PSAY "ACUM  DE VENDAS "+ TRANSFORM((xACUMULADO+ZZ9->ZZ9_VALNOT), "@E 999,999,999.99")
	@ 07,40 PSAY "PAGO            "+ TRANSFORM((xPagos+ZZ9->ZZ9_VALPAG), "@E 999,999,999.99")
	@ 08,03 PSAY "QTD COMPRAS     "+ STR((xQTDCOMPRA+ZZ9->ZZ9_NUMNOT),5)
	@ 08,40 PSAY "LIMITE  DE CRED "+ TRANSFORM(SA1->A1_LC , "@E 999,999,999.99")
	
	@ 10,40 PSAY "VENCIDOS     R$ "+TRANSFORM(xVencidos , "@E 999,999,999.99")
	
	@ 11,03 PSAY "MED VL COMPRADO "+ TRANSFORM((xACUMULADO+ZZ9->ZZ9_VALNOT) / (xQTDCOMPRA+ZZ9->ZZ9_NUMNOT) , "@E 999,999,999.99")
	@ 11,40 PSAY "A VENCER     R$ "+TRANSFORM(xAVencer , "@E 999,999,999.99")
	@ 12,03 PSAY "LIQUIDADOS      "+TRANSFORM(xLIQUID,"@E 999,999,999.99")
	@ 13,03 PSAY "FATURADOS       "+TRANSFORM(xLIQUID,"@E 999,999,999.99")
	
ELSE
	@ prow()+1,01 PSAY SPACE(01)
ENDIF
nPagina := nPAgina + 1
I:=1

FOR I:=1 TO LEN(aTARGET)   // MARCOS
	IF SUBSTR(aTARGET[I],1,1) == "1"
		@ PROW()+ 2 , 000 PSAY "PAGOS"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP  EMISSAO    VENCIMENTO   DT.BAIXA     VALOR      PAGO NATUREZ"
		xTOT     := 0
		
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE .AND. !EOF()
			IF !EMPTY(SE1->E1_BAIXA) .AND. SE1->E1_TIPO <> 'NCC' .AND. SE1->E1_TIPO <> 'AB-' .AND. SE1->E1_TIPO <> 'RA '
				DbSelectArea("SE5")
				dBSetOrder(2)
				Dbseek(SE1->E1_FILIAL+"VL"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
				IF !SE5->(FOUND())
					Dbseek(SE1->E1_FILIAL+"V2"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					IF !SE5->(FOUND())
						Dbseek(SE1->E1_FILIAL+"BA"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					ENDIF
					IF !SE5->(FOUND())
						Dbseek(SE1->E1_FILIAL+"LJ"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					ENDIF
					IF !SE5->(FOUND())
						Dbseek(SE1->E1_FILIAL+"CP"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					ENDIF
				ENDIF
				DbSelectArea("SE1")
				IF SE1->E1_CLIENTE == SE5->E5_CLIFOR .AND. SE5->(FOUND()) .AND. SE5->E5_MOTBX<>'LIQ' .And. SE5->E5_MOTBX<>'FAT'
					nValBaix :=	(SE1->E1_VALOR - SE1->E1_SALDO)
					//16  20         31         42        52        62         73
					@ PROW() +1 , 000 PSAY SE5->E5_PREFIXO+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA
					@ PROW()    , 016 PSAY SE5->E5_TIPO
					@ PROW()    , 020 PSAY SE1->E1_EMISSAO
					@ PROW()    , 031 PSAY SE1->E1_VENCREA//TO
					@ PROW()    , 042 PSAY SE5->E5_DATA
					@ PROW()    , 052 PSAY TRANSFORM(SE1->E1_VALOR,"@E 999,999.99")
					@ PROW()    , 062 PSAY TRANSFORM(nValBaix,"@E 999,999.99")
					@ PROW()    , 073 PSAY ALLTRIM(SE1->E1_NATUREZ)
					
					xTOT     += nValBaix
					nValBaix := 0
				ENDIF
			ENDIF
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "PAGOS"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP  EMISSAO    VENCIMENTO   DT.BAIXA     VALOR      PAGO NATUREZ"
			ENDIF
		ENDDO
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 060 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
	ENDIF
	
	IF SUBSTR(aTARGET[I],1,1) == "2"
		@ PROW()+2 , 000 PSAY "VENCIDOS"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO         NATUREZA"
		
		xTOT     := 0
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE
			IF SE1->E1_SALDO <> 0 .AND. SE1->E1_VENCREA < DDATABASE
				@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				@ PROW()    , 016 PSAY SE1->E1_TIPO
				@ PROW()    , 022 PSAY SE1->E1_EMISSAO
				@ PROW()    , 034 PSAY SE1->E1_VENCREA//TO
				@ PROW()    , 044 PSAY TRANSFORM(SE1->E1_VALOR,"@E 9,999,999.99")
				@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_SALDO,"@E 9,999,999.99")
				@ PROW()    , 074 PSAY ALLTRIM(SE1->E1_NATUREZ)
				IF SE1->E1_TIPO <> 'NCC' .AND. SE1->E1_TIPO <> 'AB-' .AND. SE1->E1_TIPO <> 'RA '
					xTOT := xTOT + SE1->E1_SALDO
				ELSEIF EMPTY(SE1->E1_BAIXA)
					IF SE1->E1_TIPO = "AB-"
						xTOT := xTOT - SE1->E1_VALOR
					ELSE
						xTOT := xTOT - SE1->E1_SALDO
					ENDIF
				ENDIF
			ENDIF
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "VENCIDOS"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO         NATUREZA"
			ENDIF
		ENDDO
		
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 060 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
	ENDIF
	IF SUBSTR(aTARGET[I],1,1) == "3"
		@ PROW()+2 , 000 PSAY "A VENCER"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO        NATUREZA"
		xTOT     := 0
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE
			IF SE1->E1_SALDO <> 0 .AND. SE1->E1_VENCREA >= DDATABASE
				@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				@ PROW()    , 016 PSAY SE1->E1_TIPO
				@ PROW()    , 022 PSAY SE1->E1_EMISSAO
				@ PROW()    , 034 PSAY SE1->E1_VENCREA
				@ PROW()    , 044 PSAY TRANSFORM(SE1->E1_VALOR,"@E 9,999,999.99")
				@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_SALDO,"@E 9,999,999.99")
				@ PROW()    , 074 PSAY ALLTRIM(SE1->E1_NATUREZ)
				IF SE1->E1_TIPO <> 'NCC' .AND. SE1->E1_TIPO <> 'AB-' .AND. SE1->E1_TIPO <> 'RA '
					xTOT := xTOT + SE1->E1_SALDO
				ELSEIF EMPTY(SE1->E1_BAIXA)
					IF SE1->E1_TIPO = "AB-"
						xTOT := xTOT - SE1->E1_VALOR
					ELSE
						xTOT := xTOT - SE1->E1_SALDO
					ENDIF
				ENDIF
			ENDIF
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "A VENCER"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO        NATUREZA"
			ENDIF
		ENDDO
		
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 060 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
	ENDIF
	IF SUBSTR(aTARGET[I],1,1) == "4"
		@ PROW()+ 2 , 000 PSAY "LIQUIDADOS"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO VENCIMENTO LIQUIDACAO N. LIQ      VALOR NATUREZ"
		
		xTOT     := 0
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE .AND. !EOF()
			IF !empty(SE1->E1_NUMLIQ)
				@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				@ PROW()    , 016 PSAY SE1->E1_TIPO
				@ PROW()    , 020 PSAY SE1->E1_EMISSAO
				@ PROW()    , 031 PSAY SE1->E1_VENCREA
				@ PROW()    , 042 PSAY SE1->E1_BAIXA
				@ PROW()    , 053 PSAY SE1->E1_NUMLIQ
				DBSELECTAREA("SE5")
				DBSETORDER(7)
				DBSEEK(xFILIAL("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
				WHILE SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA = SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
					IF SE5->E5_MOTBX='LIQ'
						EXIT
					ENDIF
					DBSELECTAREA("SE5")
					DBSKIP()
				ENDDO
				IF SE1->E1_ORIGEM <> 'FINA460'
					@ PROW()    , 060 PSAY TRANSFORM(SE5->E5_VALOR,"@E 999,999.99")
					@ PROW()    , 071 PSAY ALLTRIM(SE1->E1_NATUREZ)
					xTOT := xTOT + (SE1->E1_VALOR-SE1->E1_SALDO)
				ELSE
					@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_VALOR,"@E 999,999.99")
					@ PROW()    , 071 PSAY ALLTRIM(SE1->E1_NATUREZ)
				ENDIF
			ENDIF
			DBSELECTAREA("SE1")
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "LIQUIDADOS"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO VENCIMENTO LIQUIDACAO N. LIQ      VALOR NATUREZ"
			ENDIF
		ENDDO
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 058 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
	ENDIF
	cLOJA    := SA1->A1_LOJA
	cCLIENTE := SA1->A1_COD
	IF SUBSTR(aTARGET[I],1,1) == "5"
		cQuery := "SELECT E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VENCREA,E1_VALOR, E1_VALLIQ, E1_SALDO, ED_DESCRIC "
		cQuery += "FROM "  + RetSqlName("SE1") + " SE1, " + RetSqlName("SED") + " SED "
		cQuery += "WHERE SE1.E1_CLIENTE+SE1.E1_LOJA = '" + cCLIENTE + cLOJA + "' AND SE1.E1_NATUREZ = SED.ED_CODIGO "
		cQuery += "AND SE1.E1_TIPO='NDC' AND SE1.D_E_L_E_T_ <> '*' AND SED.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA "
		
		cQuery1 := ChangeQuery(cQuery)
		
		Memowrit("PROTESTO.SQL",cQuery1)
		
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'SE1N', .T., .T.)
		
		TCSetField("SE1N", "E1_VALOR"  ,"N",14,2)
		TCSetField("SE1N", "E1_VALLIQ" ,"N",14,2)
		TCSetField("SE1N", "E1_SALDO"  ,"N",14,2)
		TCSetField("SE1N", "E1_EMISSAO","D",08,2)
		TCSetField("SE1N", "E1_VENCREA" ,"D",08,2)
		TCSetField("SE1N", "E1_VENCTO" ,"D",08,2)
		
		@ PROW()+2 , 001 PSAY "PROTESTADOS"
		@ PROW()+1 , 001 PSAY "FL-PRE-NUMERO-PAR  TP     EMISSAO    VENCIMEN          VALOR          SALDO   NATUREZA            "
		//		               00-000-000000-1....NF ....99/99/99...99/99/99...9,999,999.99...9,999,999.99...!!!!!!!!!!!!!!!!!!!!"
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSELECTAREA("SE1N")
		DBGOTOP()
		xTOT     := 0
		DO WHILE ! SE1N->( EOF() )
			SE1->( DBSEEK( SE1N->E1_FILIAL+SE1N->E1_CLIENTE+SE1N->E1_LOJA+SE1N->E1_PREFIXO+SE1N->E1_NUM+SE1N->E1_PARCELA+'NF ' ) )
			@ PROW() +1 , 000000001 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA
			@ PROW()    , PCOL()+04 PSAY 'NF '
			@ PROW()    , PCOL()+04 PSAY SE1->E1_EMISSAO
			@ PROW()    , PCOL()+03 PSAY SE1->E1_VENCREA
			@ PROW()    , PCOL()+03 PSAY TRANSFORM(SE1->E1_VALOR,"@E 9,999,999.99")
			@ PROW()    , PCOL()+03 PSAY TRANSFORM(SE1->E1_SALDO,"@E 9,999,999.99")
			@ PROW()    , PCOL()+03 PSAY LEFT(SE1N->ED_DESCRIC,20)
			xTOT := xTOT + SE1->E1_SALDO
			SE1N->( DBSKIP() )
			IF PROW() > 62
				@ 00000002, 001 PSAY "PROTESTADOS"
				@ PROW()+1, 001 PSAY "FL-PRE-NUMERO-PAR  TP     EMISSAO    VENCIMEN          VALOR          SALDO   NATUREZA            "
			ENDIF
		ENDDO
		@ PROW() + 1 , 045 PSAY "TOTAL : "
		@ PROW()     , 064 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
		SE1N->( DBCLOSEAREA() )
	ENDIF
	IF SUBSTR(aTARGET[I],1,1) == "6"
		@ PROW()+2 , 000 PSAY "DEVOLVIDOS"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO       NATUREZA"
		xTOT     := xTT2 := 0
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE
			IF SE1->E1_NATUREZ="10107"
				@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				@ PROW()    , 016 PSAY SE1->E1_TIPO
				@ PROW()    , 022 PSAY SE1->E1_EMISSAO
				@ PROW()    , 034 PSAY SE1->E1_VENCREA
				@ PROW()    , 044 PSAY TRANSFORM(SE1->E1_VALOR,"@E 9,999,999.99")
				@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_SALDO,"@E 9,999,999.99")
				@ PROW()    , 074 PSAY ALLTRIM(SE1->E1_NATUREZ)
				xTOT := xTOT + SE1->E1_SALDO
				xTT2 := xTT2 + SE1->E1_VALOR
			ENDIF
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "DEVOLVIDOS"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO       NATUREZA"
			ENDIF
		ENDDO
		
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 044 PSAY TRANSFORM(xTT2,"@E 9,999,999.99")
		@ PROW()     , 060 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
		@ PROW()     , 074 PSAY TRANSFORM(Round((xTT2/xPagos)*100,0),"@E 999")+ "%"
		
	ENDIF
	IF SUBSTR(aTARGET[I],1,1) == "7"
		@ PROW()+2 , 000 PSAY "SPC"
		@ PROW()+1 , 000 PSAY "---"
		vTexto:={}
		Dbselectarea("ZZ6")
		Dbsetorder(1)
		If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
			CNEG := ZZ6_SPC
		Else
			CNEG := CriaVar("ZZ6->ZZ6_SPC")
		Endif
		
		//cNEG := SA1->A1_SPC
		nTamanho:=mlcount(cNEG,100,15,.T.)
		
		IF SUBSTR(aTARGET[I],1,1) == "8"
			@ PROW()+2 , 000 PSAY "COBRANCA EXTERNA"
			@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO         NATUREZA"
			xTOT     := 0
			DBSELECTAREA("SE1")
			DBSETORDER(2)
			DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
			WHILE SA1->A1_COD == SE1->E1_CLIENTE
				IF SE1->E1_SITUACA="5"
					@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
					@ PROW()    , 016 PSAY SE1->E1_TIPO
					@ PROW()    , 022 PSAY SE1->E1_EMISSAO
					@ PROW()    , 034 PSAY SE1->E1_VENCREA
					@ PROW()    , 044 PSAY TRANSFORM(SE1->E1_VALOR,"@E 9,999,999.99")
					@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_SALDO,"@E 9,999,999.99")
					@ PROW()    , 074 PSAY ALLTRIM(SE1->E1_NATUREZ)
					xTOT := xTOT + SE1->E1_SALDO
				ENDIF
				DBSKIP()
				IF PROW() > 62
					@ 00000002, 000 PSAY "COBRANCA EXTERNA"
					@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO     VENCIMENTO       VALOR         SALDO         NATUREZA"
				ENDIF
			ENDDO
			
			@ PROW() + 1 , 000 PSAY "TOTAL : "
			@ PROW()     , 060 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
			
		ENDIF
		@ PROW()+1,000 PSAY cNEG
	ENDIF
	IF SUBSTR(aTARGET[I],1,1) == "9"
		nTamanho := 0
		_ymemo := ""
		_ymemo := mCob
		nTamanho:=mlcount(_ymemo,254)
		
		_linha := prow()+2
		@ _linha,01 PSAY "Negociacao:"
		_linha++
		
		For _conta:=1 to nTamanho
			
			C_Linha := memotran(MEMOLINE(Alltrim(_ymemo),254,_conta),chr(13),chr(13)+chr(10))
			
			mx := 1
			N_tamanho := 120
			For iu:=1 to 3
				T_linha := substr(C_linha,mx,N_tamanho)
				if !Empty(T_linha)
					@ _Linha,001 Psay T_linha
					_linha++
				endif
				mx += N_tamanho
			Next
			
			if _linha > 60
				@ 1,1 Psay "Negociacao:"
				_linha := 2
			endif
		Next
		/*
		@ PROW()+2,00 PSAY "Negociacao:"
		vTexto:={}
		nTamanho:=mlcount(mCob,100,15,.T.)
		FOR N := 1 To nTamanho
		AADD(vTexto, MEMOLINE(ALLTRIM(mCob),100,N,15,.T.))
		If EMPTY(vTexto[N])
		Exit
		Endif
		If n == 1
		@ PROW()+1,00 PSAY vTexto[N]
		Else
		@ PROW()+1,00 PSAY vTexto[N]
		Endif
		NEXT
		*/
	Endif
	IF SUBSTR(aTARGET[I],1,1) == "A"
		@ PROW()+ 2 , 000 PSAY "FATURADOS"
		@ PROW()+ 1 , 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO VENCIMENTO DT FATURA  N. FAT      VALOR NATUREZ"
		
		xTOT     := 0
		DBSELECTAREA("SE1")
		DBSETORDER(2)
		DBSEEK(xFILIAL("SE1")+SA1->A1_COD)
		WHILE SA1->A1_COD == SE1->E1_CLIENTE .AND. !EOF()
			IF !empty(SE1->E1_FATURA)
				@ PROW() +1 , 000 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				@ PROW()    , 016 PSAY SE1->E1_TIPO
				@ PROW()    , 020 PSAY SE1->E1_EMISSAO
				@ PROW()    , 031 PSAY SE1->E1_VENCREA
				@ PROW()    , 042 PSAY SE1->E1_BAIXA
				@ PROW()    , 053 PSAY SE1->E1_FATURA
				DBSELECTAREA("SE5")
				DBSETORDER(7)
				DBSEEK(xFILIAL("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
				WHILE SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA = SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
					IF SE5->E5_MOTBX='FAT'
						EXIT
					ENDIF
					DBSELECTAREA("SE5")
					DBSKIP()
				ENDDO
				IF SE1->E1_ORIGEM <> 'FINA280'
					@ PROW()    , 060 PSAY TRANSFORM(SE5->E5_VALOR,"@E 999,999.99")
					@ PROW()    , 071 PSAY ALLTRIM(SE1->E1_NATUREZ)
					xTOT := xTOT + (SE1->E1_VALOR-SE1->E1_SALDO)
				ELSE
					@ PROW()    , 060 PSAY TRANSFORM(SE1->E1_VALOR,"@E 999,999.99")
					@ PROW()    , 071 PSAY ALLTRIM(SE1->E1_NATUREZ)
				ENDIF
			ENDIF
			DBSELECTAREA("SE1")
			DBSKIP()
			IF PROW() > 62
				@ 00000002, 000 PSAY "FATURADOS"
				@ PROW()+1, 000 PSAY "FL-PRE-NUM-PAR  TP    EMISSAO VENCIMENTO DT FATURA  N. FAT      VALOR NATUREZ"
			ENDIF
		ENDDO
		@ PROW() + 1 , 000 PSAY "TOTAL : "
		@ PROW()     , 058 PSAY TRANSFORM(xTOT,"@E 9,999,999.99")
	ENDIF
NEXT
DBSELECTAREA("SE5")
SET FILTER TO
Roda(0,"","P")
Set Device to Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/18/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AddDemo()
If nSource != 0
	aAdd(aTarget,aSource[nSource])
	ObjectMethod(oTarget,"SetItems(aTarget)")
	nNewTam := Len(aSource) - 1
	aSource := aSize(aDel(aSource,nSource),nNewTam)
	ObjectMethod(oSource,"SetItems(aSource)")
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/18/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function RemoveDemo()
If nTarget != 0
	aAdd(aSource,aTarget[nTarget])
	ObjectMethod(oSource,"SetItems(aSource)")
	nNewTam := Len(aTarget) - 1
	aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
	ObjectMethod(oTarget,"SetItems(aTarget)")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInstrucao    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Instrucao()

Alert("Funcao nao disponivel !!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPosicao    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function xPosicao()

Processa({ || XPos() })

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPosicao    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function xPos()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt("XCLI,LIGA,NPAGINA,XACUMULADO,XQTDCOMPRA,XAVENCER")
SetPrvt("XVENCIDOS,XPAGOS,XMAIOR,XI,XFIL,ATITVENC")
SetPrvt("NTOT_TIT,TIPO,NVLRPED,VTEXTO,DDT_AUX")
SetPrvt("ASOURCE,ATARGET,NSOURCE,NTARGET,I,TITULO")
SetPrvt("CSTRING,WNREL,CBTXT,CDESC1,CDESC2,TAMANHO")
SetPrvt("ARETURN,NLASTKEY,CPERG,_ABEC1,_ABEC2,CRODATXT")
SetPrvt("NCNTIMPR,NTIPO,NOMEPROG,CCONDICAO,NTOTREGS,NMULT")
SetPrvt("NPOSANT,NPOSATU,NPOSCNT,LCONTINUA,LI,M_PAG")
SetPrvt("AFINAL,_I,M_QTD,M_QTD_CX,M_QTD_UN,NTOT_IT")
SetPrvt("NTOT_IPED,N_REG,TIME,XTOT,CNEG,NTAMANHO")
SetPrvt("N,NNEWTAM,xLIQUID,xCREDITOS,OTIPO,")

/*
PROGRAMA    : P_FIN009.PRW                                 DATA : 28/12/2000
MODULO      : SIGAFAT                                      TIPO : PROCESSAMENTO
PROGRAMADOR : IVO FABIO
OBJETIVO    : INFORMA OS DADOS DA POSICAO DO CLIENTE.
*/
//DEFINE FONT oFnt_a NAME "Arial"  SIZE 10,20 BOLD

DEFINE FONT oFnt_2 NAME "Arial" SIZE 8,24 BOLD

xLIQUID    := 0
xFATURA    := 0
gpLimite   := 0
gpVencido  := 0
gpVencer   := 0
gpPedLib   := 0
gpPedVen	  := 0
gpSaldo    := 0
gpPedCred  := 0
gpTotPag   := 0

Private oGprEmp

If TRIM(SA1->A1_GPEMP) <> ''
	
	aAreaGP := getArea()
	
	for i := 1 to 2
		if i == 1
			cQuery := "Select Count(A1_COD) COUNT "
		Else
			cQuery := "Select A1_COD,A1_LOJA,A1_LC "
		EndIf
		cQuery += "from "+RetSqlName("SA1")+" SA1 "
		cQuery += "where A1_GPEMP = '"+SA1->A1_GPEMP+"' "
		TCQUERY cQuery ALIAS SA1N NEW
		If i == 1
			nCountGRP := SA1N->COUNT
			SA1N->(DbCloseArea())
		EndIf
	Next
	
	PROCREGUA(nCountGRP)
	dbSelectArea("SA1N")
	dbGoTop()
	While !EOF()
		gpLimite += SA1N->A1_LC
		
		cQuery := "select LEFT(C5_STATUS,1) C5_STAT, case when LEFT(C5_STATUS,1) = '0' THEN SUM((C6_VALOR+C6_DESCIPI)/1) "
		cQuery += "else SUM((C6_VALOR+C6_DESCIPI)/C6_QTDVEN*C6_QTDEMP) END TOTAL "
		cQuery += "from "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6 "
		cQuery += "where SC5.C5_CLIENTE = '"+SA1N->A1_COD+"' "
		cQuery += "and SC5.C5_LOJACLI = '"+SA1N->A1_LOJA+"' "
		cQuery += "and SC5.C5_DTCANC = '' "
		cQuery += "and SC5.C5_DTS_FAT = '' "
		cQuery += "and SC6.C6_NUM = SC5.C5_NUM "
		cQuery += "and SC5.D_E_L_E_T_ = '' "
		cQuery += "and SC6.D_E_L_E_T_ = '' "
		cQuery += "group by SC5.C5_CLIENTE, LEFT(C5_STATUS,1) "
		TCQUERY cQuery ALIAS SE5N NEW
		
		dbSelectArea("SE5N")
		dbGoTop()
		While !EOF()
			if SE5N->C5_STAT > '1'
				gpPedLib  += SE5N->TOTAL
			ElseIf SE5N->C5_STAT == '1'
				gpPedCred += SE5N->TOTAL
			Else
				gpPedVen  += SE5N->TOTAL
			EndIf
			dbSkip()
		EndDo
		SE5N->(dbCloseArea())
		
		dbSelectArea("SA1")
		aAreaA1 := getArea()
		dbSetOrder(1)
		dbSeek(xFilial()+SA1N->A1_COD+SA1N->A1_LOJA)
		CalcFor()
		gpVencido += XVENCIDOS
		gpVencer  += XAVENCER
		Dbselectarea("ZZ9")
		Dbseek(xFiliaL()+SA1N->A1_COD+SA1N->A1_LOJA)
		gpTotPag  += XPAGOS+ZZ9->ZZ9_VALPAG
		RestArea(aAreaA1)
		
		dbSelectArea("SA1N")
		DBSkip()
		INCPROC("Calculando totalizadores do grupo empresarial")
	EndDo
	
	gpSaldo := gpLimite - gpVencido - gpVencer - gpPedLib
	
	SA1N->(dbCloseArea())
	RestArea(aAreaGP)
EndIf

Processa( { || CalcFor() } )
xCLI := SA1->A1_COD

cCond := "SELECT SUM(SE1.E1_SALDO) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_SALDO > 0 "
cCond += "AND SE1.E1_TIPO = 'NCC' AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xCREDITOS := SE1N->MAIOR

SE1N->(DBCLOSEAREA())

//xPAGOS -= xLIQUID

DBSELECTAREA("SA3")
DBSETORDER(1)
DBSEEK(XFILIAL("SA3")+SA1->A1_VEND)
LIGA:=0

@ 096,030 TO 630,700 DIALOG oDlg6 TITLE "Posicao do cliente: " + SA1->A1_COD + " " + SA1->A1_LOJA + " - " + SA1->A1_NOME
//@ 007,300 TO 260,380
@ 002,150 TO 200,330
nPagina   := 1

//Posiciona no acumulado do cliente
cTipo := ''
If SA1->A1_NEGATIV == 'S'
	cTipo := '   **  N E G A T I V A D O  **  '
endif

if ALLTRIM(SA1->A1_SATIV4) == '1'
	cTipo := '   ** N E G A T I V A D O   SCI  **'
else
	cTIPO := IIF( LEFT(SA1->A1_SATIV8,1) == 'S', "   **   E S P E C I A L   **", "" )
EndIf

iF !empty(sa1->a1_prior) .And. ( empty(cTipo) .Or. SA1->A1_PRIOR $ '12' )
	Dbselectarea("SX5")
	Dbseek("  ZM"+PADR(SA1->A1_PRIOR,6))
	cTipo := "   ** "+tRIM(SX5->X5_DESCRI)+" **"
EndIf

Dbselectarea("ZZ9")
Dbseek(xFiliaL()+SA1->A1_COD+SA1->A1_LOJA)

@ 005,065  SAY cTipo Color CLR_HRED

@ 015,005  SAY "Representante:"
@ 015,050  SAY SA3->A3_COD + " - " + Subst(SA3->A3_NOME,1,25) Color CLR_BLUE

@ 025,005  SAY "Grupo:"
@ 025,050  SAY SA1->A1_GPEMP Color CLR_BLUE

@ 035,005  SAY "Primeira Compra:"
@ 035,050  SAY IIF((ZZ9->ZZ9_DTPRIC < SA1->A1_PRICOM .AND. !Empty(ZZ9->ZZ9_DTPRIC)).OR.Empty(SA1->A1_PRICOM),;
DTOC(ZZ9->ZZ9_DTPRIC),DTOC(SA1->A1_PRICOM)) Color CLR_BLUE

@ 035,090  SAY "Fundacao:"
@ 035,125  SAY dtoc(SA1->a1_fundac) Color CLR_BLUE

@ 045,005  SAY "Ultima Compra:"
@ 045,050  SAY IIF(ZZ9->ZZ9_DTULTC > SA1->A1_ULTCOM,;
IIF(!Empty(DTOC(ZZ9->ZZ9_DTULTC)),DTOC(ZZ9->ZZ9_DTULTC),DTOC(SA1->A1_ULTCOM)),IIF(!Empty(DTOC(SA1->A1_ULTCOM)),DTOC(SA1->A1_ULTCOM),DTOC(ZZ9->ZZ9_DTULTC)) ) Color CLR_BLUE

@ 045,090  SAY "Carta Coligada:"
@ 045,130  SAY SA1->a1_cartcol Color CLR_BLUE

@ 055,005  SAY "Acumulado Vendas:"
@ 055,050  SAY TRANSFORM((xACUMULADO+ZZ9->ZZ9_VALNOT),"@E 9,999,999.99") Color CLR_BLUE

@ 055,090  SAY "Negativado:"
@ 055,130  SAY SA1->a1_negativ Color CLR_BLUE

@ 065,005  SAY "Qtd Compras:"
@ 065,050  SAY TRANSFORM((xQTDCOMPRA+ZZ9->ZZ9_NUMNOT),"9999999") Color CLR_BLUE

@ 075,005  SAY "Media Vlr Comprado:"
@ 075,050  SAY TRANSFORM(((xACUMULADO+ZZ9->ZZ9_VALNOT) / (xQTDCOMPRA+ZZ9->ZZ9_NUMNOT) ),"@E 9,999,999.99") Color CLR_BLUE

@ 085,005  SAY "Pagos: "
@ 085,050  SAY TRANSFORM((xPAGOS+ZZ9->ZZ9_VALPAG),"@E 9,999,999.99") Color CLR_BLUE

@ 095,005  SAY "Creditos:"
@ 095,050  SAY TRANSFORM(xCREDITOS,"@E 9,999,999.99") Color CLR_BLUE

@ 105,005  SAY "Risco:"
@ 105,030  SAY Alltrim(SA1->A1_RISCO) Color CLR_BLUE
@ 105,050  say "ND: "
@ 105,055  say Transform(Ret_ND(),"@E 9,999,999.99") Color CLR_BLUE
@ 105,100  say "N: "
@ 105,105  say Transform(Ret_N(),"@E 9,999,999.99")  Color CLR_BLUE

@ 115,005  SAY "Venc. do Limite:"
@ 115,050  SAY DTOC(SA1->A1_VENCLC) Color CLR_BLUE

@ 125,005  SAY "Maior Compra:"
@ 125,050  SAY TRANSFORM(xMAIOR, "@E 999,999,999.99") Color CLR_BLUE

@ 135,005  SAY "Maior/Media Atraso:"
@ 135,050  SAY STR(SA1->A1_MATR)+" / "+STR(SA1->A1_METR) Color CLR_BLUE

@ 145,005  SAY "Limite de Credito:"
@ 145,050  SAY TRANSFORM(SA1->A1_LC,"@E 9,999,999.99") Color CLR_BLUE

@ 155,005  SAY "Status:"
@ 155,050  SAY if(SA1->A1_ATIVO='N','* INATIVO *',IF(SA1->A1_ATIVO='S','ATIVO','CRED.REPROV')) Color CLR_BLUE

@ 165,005  SAY "Rating/Inclusao:"
@ 165,050  SAY SA1->A1_CLASSE + " / " Color CLR_BLUE
@ 165,060  SAY DTOC(SA1->A1_DTULCHQ) Color CLR_BLUE

If Trim(SA1->A1_GPEMP) <> ''
	oGrpEmp := TSAY():Create(oDlg6)
	oGrpEmp:cName := "oGrpEmp"
	oGrpEmp:nLeft := 055
	oGrpEmp:nTop := 355
	oGrpEmp:nWidth := 200
	oGrpEmp:nHeight := 15
	oGrpEmp:lShowHint := .F.
	oGrpEmp:lReadOnly := .F.
	oGrpEmp:Align := 0
	oGrpEmp:lVisibleControl := .T.
	oGrpEmp:SetText( "GRUPO EMPRESARIAL" )
	oGrpEmp :nClrText       := CLR_RED
	
	@ 185,005  SAY "Pedidos em Vendas"
	@ 185,060  SAY TRANSFORM(gpPedVen,"@E 9,999,999.99") Color CLR_GREEN
	
	@ 195,005  SAY "Pedidos em Credito"
	@ 195,060  SAY TRANSFORM(gpPedCred,"@E 9,999,999.99") Color CLR_GREEN
	
	@ 205,005  SAY "Limite de Credito"
	@ 205,060  SAY TRANSFORM(gpLimite,"@E 9,999,999.99") Color CLR_GREEN
	@ 205,100  SAY "(+)"
	
	@ 215,005  SAY "Vencidos"
	@ 215,060  SAY TRANSFORM(gpVencido,"@E 9,999,999.99") Color CLR_GREEN
	@ 215,100  SAY "(-)"
	
	@ 225,005  SAY "A Vencer"
	@ 225,060  SAY TRANSFORM(gpVencer,"@E 9,999,999.99") Color CLR_GREEN
	@ 225,100  SAY "(-)"
	
	@ 235,005  SAY "Pedidos liberados"
	@ 235,060  SAY TRANSFORM(gpPedLib,"@E 9,999,999.99") Color CLR_GREEN
	@ 235,100  SAY "(-)"
	
	@ 245,005  SAY "Saldo"
	@ 245,060  SAY TRANSFORM(gpSaldo,"@E 9,999,999.99") Color CLR_GREEN
	@ 245,100  SAY "(=)"
	
	@ 255,005 SAY "Pagos Totais Grupo"
	@ 255,060 SAY TRANSFORM(gpTotPag,"@E 9,999,999.99") Color CLR_GREEN
	
Endif

@ 015,155  SAY "Vencidos:"
@ 015,195  SAY TRANSFORM(xVENCIDOS,"@E 9,999,999.99") Color CLR_BLUE

@ 025,155  SAY "A Vencer:"
@ 025,195  SAY TRANSFORM(xAVENCER,"@E 9,999,999.99") Color CLR_BLUE

@ 035,155  SAY "Liquidados:"
@ 035,195  SAY TRANSFORM(xLIQUID,"@E 9,999,999.99") Color CLR_BLUE

@ 045,155  SAY "Faturados:"
@ 045,195  SAY TRANSFORM(xFATURA,"@E 9,999,999.99") Color CLR_BLUE

@ 055,155  SAY "RA:"
@ 055,195  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 065,155  SAY "NCC:"
@ 065,195  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 075,155  SAY "NDC:"
@ 075,195  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 085,155  SAY "JP:"
@ 085,195  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 005,295 SAY "DEBITOS"

@ 015,245  SAY "Saldo Principal:"
@ 015,290  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 025,245  SAY "Juros:"
@ 025,290 SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 035,245  SAY "Total Debito:"
@ 035,290  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 045,245  SAY "Percentual:"
@ 045,290  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 055,245  SAY "Qtd Titulos:"
@ 055,290  SAY TRANSFORM(0,"@E 999,999") Color CLR_BLUE

@ 100,200  SAY "POR CARTEIRA"

@ 110,200  SAY "Qtd Titulo"
@ 110,245  SAY "Saldo"

@ 120,155  SAY "Cob Ativa:"
@ 120,200  SAY TRANSFORM(0,"@E 999,999") Color CLR_BLUE
@ 120,235  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 130,155  SAY "Acor Interno:"
@ 130,200  SAY TRANSFORM(0,"@E 999,999") Color CLR_BLUE
@ 130,235  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 140,155  SAY "Age Externa:"
@ 140,200  SAY TRANSFORM(0,"@E 999,999") Color CLR_BLUE
@ 140,235  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

@ 150,155  SAY "Juridico:"
@ 150,200  SAY TRANSFORM(0,"@E 999,999") Color CLR_BLUE
@ 150,235  SAY TRANSFORM(0,"@E 9,999,999.99") Color CLR_BLUE

//APRESENTA NATUREZA

Dbselectarea("SED")
Dbsetorder(1)
If !Empty(SA1->A1_NATAVLI)
	Dbseek(xfilial()+SA1->A1_NATAVLI)
	@ 160,155  SAY "Nat LIC AV"
	@ 160,190  SAY SA1->A1_NATAVLI+ " - "+Subst(SED->ED_DESCRIC,1,15) Color CLR_BLUE
Endif

If !Empty(SA1->A1_NATAPLI)
	Dbseek(xfilial()+SA1->A1_NATAPLI)
	@ 170,155  SAY "Nat LIC AP"
	@ 170,190  SAY SA1->A1_NATAPLI+ " - "+Subst(SED->ED_DESCRIC,1,15) Color CLR_BLUE
Endif

If !Empty(SA1->A1_NATAVNF)
	Dbseek(xfilial()+SA1->A1_NATAVNF)
	@ 180,155  SAY "Nat NF AV"
	@ 180,190  SAY SA1->A1_NATAVNF+ " - "+Subst(SED->ED_DESCRIC,1,15) Color CLR_BLUE
Endif

If !Empty(SA1->A1_NATAPNF)
	Dbseek(xfilial()+SA1->A1_NATAPNF)
	@ 190,155  SAY "Nat NF AP"
	@ 190,190  SAY SA1->A1_NATAPNF+ " - "+Subst(SED->ED_DESCRIC,1,15) Color CLR_BLUE
Endif

//Comentei Eurivan
//nREG := SA3->( Recno() )
//SA3->( Dbseek( xFilial() + "9999  " ) )
//If SA3->A3_COD <> "9999  "
//   MsgStop( "	Representante 9999 nao encontrado. % de inadimplencia total nao sera exibido" )
nINADIMF := 0
nINADIMJ := 0
nINADIF2 := 0
nINADIJ2 := 0
//Else
//	 nINADIMF := SA3->A3_INADIMF
//	 nINADIMJ := SA3->A3_INADIMJ
//	 nINADIF2 := SA3->A3_INADIF2
//	 nINADIJ2 := SA3->A3_INADIJ2
//EndIf
//SA3->( DbGoto( nREG ) )

@ 205,150  SAY "Inad. repr.(total):"
@ 205,210  SAY "P.Fis:"
@ 205,273  SAY "P.Jur:"
@ 205,225  SAY TRANSFORM( SA3->A3_INADIMF, "@E 999.99%" ) + " - " + TRANSFORM( nINADIMF, "@E 999.99%" ) Color CLR_BLUE
@ 205,290  SAY TRANSFORM( SA3->A3_INADIMJ, "@E 999.99%" ) + " - " + TRANSFORM( nINADIMJ, "@E 999.99%" ) Color CLR_BLUE
@ 215,215  SAY TRANSFORM( SA3->A3_VLINADF, "@E 999,999.99" ) Color CLR_BLUE
@ 215,280  SAY TRANSFORM( SA3->A3_VLINADJ, "@E 999,999.99" ) Color CLR_BLUE

@ 225,150  SAY "Inad. repr.(ate 180 dias):"
@ 225,210  SAY "P.Fis:"
@ 225,273  SAY "P.Jur:"
@ 225,225  SAY TRANSFORM( SA3->A3_INADIF2, "@E 999.99%" ) + " - " + TRANSFORM( nINADIF2, "@E 999.99%" ) Color CLR_BLUE
@ 225,290  SAY TRANSFORM( SA3->A3_INADIJ2, "@E 999.99%" ) + " - " + TRANSFORM( nINADIJ2, "@E 999.99%" ) Color CLR_BLUE
@ 235,215  SAY TRANSFORM( SA3->A3_VLINAF2, "@E 999,999.99" ) Color CLR_BLUE
@ 235,280  SAY TRANSFORM( SA3->A3_VLINAJ2, "@E 999,999.99" ) Color CLR_BLUE

Dbselectarea("SA1")

@ 252,160 BUTTON OemToAnsi( "Imprimir posicao" ) SIZE 75,12 ACTION Impressao()
@ 252,245 BUTTON OemToAnsi( "Consulta equifax" ) SIZE 75,12 ACTION InfEquifax()
ACTIVATE DIALOG oDlg6 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC003   บAutor  ณMicrosiga           บ Data ณ  10/18/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcFor()
PROCREGUA(4)
xCREDITOS  := 0
xACUMULADO := 0
xQTDCOMPRA := 0
xAVENCER   := 0
xVENCIDOS  := 0
xPAGOS     := 0
xMAIOR     := 0
xLIQUID    := 0
xFATURA    := 0
aTITVENC   := {}
xAVENCNEG  := 0
xVENCNEG   := 0

DBSELECTAREA("SE5")

cCond := "SELECT MAX(SF2.F2_VALFAT) MAIOR FROM "+RETSQLNAME("SF2")+" SF2 "
cCond += "WHERE SF2.F2_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SF2.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SF2N NEW

xMAIOR := SF2N->MAIOR

SF2N->(DBCLOSEAREA())

cCond := "SELECT SUM(SF2.F2_VALFAT) MAIOR FROM "+RETSQLNAME("SF2")+" SF2 "
cCond += "WHERE SF2.F2_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SF2.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SF2N NEW

xACUMULADO := SF2N->MAIOR

SF2N->(DBCLOSEAREA())

cCond := "SELECT COUNT(SF2.F2_VALFAT) MAIOR FROM "+RETSQLNAME("SF2")+" SF2 "
cCond += "WHERE SF2.F2_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SF2.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SF2N NEW

xQTDCOMPRA := SF2N->MAIOR

SF2N->(DBCLOSEAREA())

INCPROC()

//SE1N->(DBCLOSEAREA())
cCond := "SELECT SUM(SE1.E1_VALOR) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_VENCREA < '"+DTOS(DDATABASE)+"' AND SE1.E1_BAIXA = '        ' "
cCond += "AND SE1.E1_TIPO = 'AB-' AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xVENCNEG := SE1N->MAIOR

SE1N->(DBCLOSEAREA())
cCond := "SELECT SUM(SE1.E1_SALDO) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_VENCREA < '"+DTOS(DDATABASE)+"' AND SE1.E1_BAIXA = '        ' "
cCond += "AND (SE1.E1_TIPO = 'NCC' OR SE1.E1_TIPO = 'RA ') AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xVENCNEG := xVENCNEG + SE1N->MAIOR

SE1N->(DBCLOSEAREA())

cCond := "SELECT SUM(SE1.E1_SALDO) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_SALDO <> 0 AND SE1.E1_VENCREA < '"+DTOS(DDATABASE)+"' "
cCond += "AND SE1.E1_TIPO <> 'NCC' AND SE1.E1_TIPO <> 'AB-' AND SE1.E1_TIPO <> 'RA '"
cCond += "AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xVENCIDOS := SE1N->MAIOR - xVENCNEG

SE1N->(DBCLOSEAREA())

INCPROC()
cCond := "SELECT SUM(SE1.E1_VALOR) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_BAIXA = '        ' AND SE1.E1_VENCREA >= '"+DTOS(DDATABASE)+"' "
cCond += "AND SE1.E1_TIPO = 'AB-' AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xAVENCNEG := SE1N->MAIOR

SE1N->(DBCLOSEAREA())

cCond := "SELECT SUM(SE1.E1_SALDO) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_BAIXA = '        ' AND SE1.E1_VENCREA >= '"+DTOS(DDATABASE)+"' "
cCond += "AND (SE1.E1_TIPO = 'NCC' OR SE1.E1_TIPO = 'RA ') AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xAVENCNEG := xAVENCNEG + SE1N->MAIOR

SE1N->(DBCLOSEAREA())

cCond := "SELECT SUM(SE1.E1_SALDO) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_SALDO <> 0 AND SE1.E1_VENCREA >= '"+DTOS(DDATABASE)+"' "
cCond += "AND SE1.E1_TIPO <> 'NCC' AND SE1.E1_TIPO <> 'AB-' AND SE1.E1_TIPO <> 'RA '"
cCond += "AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xAVENCER := SE1N->MAIOR //- xVENCNEG

SE1N->(DBCLOSEAREA())

INCPROC()

xFIL     := SPACE(02)

cCond := "SELECT SUM((SE1.E1_VALOR-SE1.E1_SALDO)) MAIOR FROM "+RETSQLNAME("SE1")+" SE1 "
cCond += "WHERE SE1.E1_CLIENTE = '"+SA1->A1_COD+"' "
cCond += "AND SE1.E1_TIPO <> 'NCC' AND SE1.E1_TIPO <> 'AB-'  AND SE1.E1_TIPO <> 'RA '"
cCond += "AND SE1.E1_SALDO <> SE1.E1_VALOR AND SE1.E1_BAIXA<> '        ' "
cCond += "AND SE1.D_E_L_E_T_<>'*' "
TCQUERY cCond ALIAS SE1N NEW

xPAGOS := SE1N->MAIOR

SE1N->(DBCLOSEAREA())

INCPROC()

xFIL     := SPACE(02)
aTITVENC := {}

cCond := "SELECT SUM(SE5.E5_VALOR) FATURA FROM "+RETSQLNAME("SE5")+" SE5 "
cCond += "WHERE SE5.E5_CLIFOR = '"+SA1->A1_COD+"' "
cCond += "AND SE5.E5_MOTBX = 'FAT' AND SE5.E5_RECPAG = 'R' "
cCond += "AND SE5.D_E_L_E_T_<>'*' AND SE5.E5_SITUACA <> 'C' "
TCQUERY cCond ALIAS SE1N NEW

xFATURA := SE1N->FATURA

SE1N->(DBCLOSEAREA())

xPAGOS -= xFATURA

cCond := "SELECT SUM(SE5.E5_VALOR) LIQUID FROM "+RETSQLNAME("SE5")+" SE5 "
cCond += "WHERE SE5.E5_CLIFOR = '"+SA1->A1_COD+"' "
cCond += "AND SE5.E5_MOTBX = 'LIQ' AND SE5.E5_RECPAG = 'R' "
cCond += "AND SE5.D_E_L_E_T_<>'*' AND SE5.E5_SITUACA <> 'C' "
TCQUERY cCond ALIAS SE1N NEW

xLIQUID := SE1N->LIQUID

SE1N->(DBCLOSEAREA())

xPAGOS -= xLIQUID

xPAGOS -= xFATURA

Incproc()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltro    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Filtro()

Alert("Funcao nao disponivel !!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRegistrar    บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Registrar()

cObs := CriaVar("ZZ6->ZZ6_MEMO")
@ 96,030 TO 300,650 DIALOG oDlg7 TITLE "Registrar Memoria da Cobranca"
@ 010,015 GET cObs Size 280,50 MEMO
@ 070,120 BUTTON "_Ok" SIZE 35,15  ACTION _Grava()
ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Grava       บAutor  ณMicrosiga           บ Data ณ 10/15/04 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Grava()

if Empty(cObs)
	Alert("Memoria da cobranca vazia. Impossivel efetuar o registro.")
	return
endif

If !Empty(cObs)
	//	mCob := ZZ6->ZZ6_MEMO  //comentado dia 04/06/06 ana
	mCob := IIF(!Empty(mCob),Chr(13)+CHR(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> "+Trim(cObs) //Atualiza variavel da tela principal

	Reclock("ZA2",.F.)
	Replace ZA2_MEMO   With Trim(mCob)  //alterado 04/07/13 Gustavo
	msunlock()

	Dbselectarea("ZZ6")
	Reclock("ZZ6",.F.)
	Replace ZZ6_MEMO   With Trim(ZZ6->ZZ6_MEMO)+Trim(mCob)  //alterado 04/06/06 ana
	Replace ZZ6_ULCONT With dDatabase
	msunlock()
else
	mCob := Trim(cObs)
Endif

If ZZ6->ZZ6_TIPRET <> '2' .And. !Empty(ZZ6->ZZ6_TIPRET) //se agendado
	If MsgBox( "Cliente Agendado", "Desmarcar Agendamento ?", "YESNO" )
		Dbselectarea("ZZ6")
		Reclock("ZZ6",.F.)
		Replace ZZ6_TIPRET With '2' //Automatico
		msunlock()
	Endif
Endif

//Verifica se existe a necessidade de confirmar o contato como Positivo
dbselectarea("TIT")
TIT->( dbgotop() )
lPergPosi := .F.
While !Eof()
	Dbselectarea("SE1")
	Dbsetorder(2)
	Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+Subst(TIT->TITULO,1,3)+Subst(TIT->TITULO,5,6)+Subst(TIT->TITULO,12,3)+Subst(TIT->TITULO,16,3) )
	
	Dbselectarea("ZZ7")
	Dbsetorder(1)
	Dbseek(xFilial()+SE1->E1_NATUREZ+SE1->E1_STATCOB)
	If ZZ7->ZZ7_TPSTAT $ 'S' //Se for controlar contato positivo
		lPergPosi := .T.
	Endif
	dbselectarea("TIT")
	dbskip()
End

xQuery := "SELECT CHAVE = SE1.E1_FILIAL+SE1.E1_CLIENTE+SE1.E1_LOJA+SE1.E1_PREFIXO+SE1.E1_NUM+SE1.E1_PARCELA+SE1.E1_TIPO "
xQuery += "FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("ZZ7")+" ZZ7 "
xQuery += "WHERE E1_CLIENTE = '"+SA1->A1_COD+"' AND SUBSTRING(E1_STATCOB,3,1) = '1' "
xQuery += "AND E1_NATUREZ = ZZ7_NATUR AND E1_STATCOB = ZZ7_STATUS AND ZZ7_TPSTAT = 'S' "
xQuery += "AND ZZ7_DIAS < 0 AND SE1.D_E_L_E_T_ = '' AND ZZ7.D_E_L_E_T_ = '' "
TCQUERY xQuery ALIAS ZZ7X NEW
DbSelectArea("ZZ7X")
DbGoTop()
If !Eof()
	lPergPosi := .T.
EndIf
ZZ7X->(DBCLOSEAREA())

Dbselectarea("TIT")

If lPergPosi .And. MsgBox( "Qualidade do Contato", "Contato Positivo ?", "YESNO" )
	dbselectarea("TIT")
	TIT->( dbgotop() )
	While !Eof()
		Dbselectarea("SE1")
		Dbsetorder(2)
		//TMPSE1->E1_PREFIXO+"-"+TMPSE1->E1_NUM+"/"+TMPSE1->E1_PARCELA+" - "+TMPSE1->E1_TIPO
		If Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+Subst(TIT->TITULO,1,3)+Subst(TIT->TITULO,5,6)+Subst(TIT->TITULO,12,3)+Subst(TIT->TITULO,16,3))
			//Se o status ainda estiver como contato negativo
			Dbselectarea("ZZ7")
			Dbsetorder(1)
			Dbseek(xFilial()+SE1->E1_NATUREZ+SE1->E1_STATCOB)
			If ZZ7->ZZ7_TPSTAT $ 'S' //Se for controlar contato positivo
				If Subst(SE1->E1_STATCOB,3,1) == '1'
					Reclock("SE1",.F.)
					Replace E1_STATCOB With Subst(SE1->E1_STATCOB,1,2)+'2' //Contato Positivo
					msunlock()
				Endif
			Endif
		Endif
		dbselectarea("TIT")
		dbskip()
	End
	xQuery := "SELECT CHAVE = SE1.E1_FILIAL+SE1.E1_CLIENTE+SE1.E1_LOJA+SE1.E1_PREFIXO+SE1.E1_NUM+SE1.E1_PARCELA+SE1.E1_TIPO "
	xQuery += "FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("ZZ7")+" ZZ7 "
	xQuery += "WHERE E1_CLIENTE = '"+SA1->A1_COD+"' AND SUBSTRING(E1_STATCOB,3,1) = '1' "
	xQuery += "AND E1_NATUREZ = ZZ7_NATUR AND E1_STATCOB = ZZ7_STATUS AND ZZ7_TPSTAT = 'S' "
	xQuery += "AND ZZ7_DIAS < 0 AND SE1.D_E_L_E_T_ = '' AND ZZ7.D_E_L_E_T_ = '' "
	TCQUERY xQuery ALIAS ZZ7X NEW
	DbSelectArea("ZZ7X")
	DbGoTop()
	While !Eof()
		Dbselectarea("SE1")
		Dbsetorder(2)
		If Dbseek( ZZ7X->CHAVE )
			Reclock("SE1",.F.)
			Replace E1_STATCOB With Subst(SE1->E1_STATCOB,1,2)+'2' //Contato Positivo
			msunlock()
		Endif
		dbselectarea("ZZ7X")
		dbskip()
	End
	ZZ7X->(DBCLOSEAREA())
	
	Reclock("ZA2",.F.)
	Replace ZA2_QUALI With 'P'
	If !Empty(mCob)
		Replace ZA2_TIPO  With IF(ZA2->ZA2_TIPO == 'C','R',ZA2->ZA2_TIPO)
		Replace ZA2_MEMO  With Trim(mCob)
	EndIf
	Msunlock()
	mCob := Trim(ZZ6->ZZ6_MEMO)
	If nDISCREG <> 0
		ZA8->( DbGoto( nDISCREG ) )
		Reclock("ZA8",.F.)
		Replace ZA8_QUALI With 'P'
		msunlock()
	EndIf
ElseIf !lPergPosi .And. MsgBox( "Qualidade do Contato", "Contato Positivo ?", "YESNO" )
	Reclock("ZA2",.F.)
	Replace ZA2_QUALI With 'P'
	If !Empty(mCob)
		Replace ZA2_TIPO  With IF(ZA2->ZA2_TIPO == 'C','R',ZA2->ZA2_TIPO)
		Replace ZA2_MEMO  With Trim(mCob)
	EndIf
	Msunlock()
	mCob := Trim(ZZ6->ZZ6_MEMO)
	If nDISCREG <> 0
		ZA8->( DbGoto( nDISCREG ) )
		Reclock("ZA8",.F.)
		Replace ZA8_QUALI With 'P'
		msunlock()
	EndIf
Endif

//Perguntar se muda status de cobranca

TIT->( dbgotop() )

Close(oDlg7)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  11/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Grv()

Local aAreaSE1	:= getArea("SE1")

Dbselectarea("SE1")
Dbsetorder(2)
If Dbseek(xFilial("SE1") + TIT->CLIENTE + TIT->LOJA + Subst(TIT->TITULO,1,3) + Subst(TIT->TITULO,5,9) + Subst(TIT->TITULO,15,1) )

	Reclock("SE1",.F.)
	Replace E1_DTVARIA With dDtRet
	//Replace E1_HORRET With cHrRet
	MSUNLOCK()
	
Else
	MsgAlert("Titulo nใo encontrado!")
EndIf

Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xFilial()+ZZ6_CLIENT+ZZ6_LOJA) .And. !Empty(dDtRet)
	
	//comentado por ana 04/06/06
	//mCob := ZZ6->ZZ6_MEMO
	//mCob := Trim(mCob)+Chr(13)+CHR(10)+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> Retorno agendado para "+dToC(dDtRet)+ " " + cHrRet //Atualiza variavel da tela principal
	mCob := Chr(13)+CHR(10)+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> Retorno agendado para "+dToC(dDtRet)+ " " + cHrRet //Atualiza variavel da tela principal
	Dbselectarea("ZZ6")
	Reclock("ZZ6",.F.)
	Replace ZZ6_RETORN With dDtRet
	Replace ZZ6_HORRET With cHrRet
	Replace ZZ6_TIPRET With "1"
	Replace ZZ6_ULCONT With dDatabase
	Replace ZZ6_MEMO   With Trim(ZZ6->ZZ6_MEMO)+mCob // mCob - alterado por ana 04/06/06
	MSUNLOCK()
	
	//Atualiza historico da cobranca
	Reclock("ZA2",.F.)
	Replace ZA2_QUALI With If( dDtRet == dDATABASE, 'N', 'P' )
	if !Empty(mCob)
		Replace ZA2_TIPO  With IF(ZA2->ZA2_TIPO == 'C','R',ZA2->ZA2_TIPO)
		Replace ZA2_MEMO  With Trim(mCob)
	Endif
	msunlock()
	mCob := Trim(ZZ6->ZZ6_MEMO)
	If nDISCREG <> 0
		ZA8->( DbGoto( nDISCREG ) )
		Reclock("ZA8",.F.)
		Replace ZA8_QUALI With If( dDtRet == dDATABASE, 'N', 'P' )
		msunlock()
	EndIf
ENDIF

If Empty(dDtRet)
	Alert("Data invalida!!!")
Endif

RestArea(aAreaSE1)

Close(oDlg7)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  03/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carta_Cobranca()

SetPrvt( "oCBox1,oSay1," )

******** VARIAVEIS USADAS **********

cMARCA    := GetMark()
lInvert  := .F.
aCPOBRW2  := {}
lFLAG     := .F.
nTitSel    := 0

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := LeCarta() }, OemToAnsi("Aguarde"), OemToAnsi("Atualizando Titulos do Cliente..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG1 Title OemToAnsi( "Carta de Cobranca - Selecione Titulos" )

@ 006,005 Say OemToAnsi("Titulos :") COLOR CLR_HBLUE
@ 006,050 Say nTitSel Picture "@E 999" COLOR CLR_RED object oTitSel
oCBox1     := TComboBox():New( 015,045,,{"Tom Suave","Tom Mediano","Tom Mais Forte"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,, )
oCBox1:nAt := 1
oSay1      := TSay():New( 016,005,{||"Nivel da Carta:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,038,008)



Dbselectarea("MARC")

oBRW2  	   	:= MsSelect():New( "MARC", "MARCA", "", aCPOBRW2, @lInvert, @cMarca, { 030, 002, 240, 393 } )
oBRW2:oBrowse:lhasMark    := .T.
oBRW2:oBrowse:lCanAllmark := .T.
oBRW2:oBrowse:bAllMark    := { || MarcaTudoCarta() }
oBRW2:bMark               := { || MarcaCarta()}

@ 255,150 Button OemToAnsi("_Confirma") Size 40,12 Action ImpCarta() Object oCONFIRMA //ProcPreAc()
@ 255,210 Button OemToAnsi("_Sair") Size 40,12 Action oDLG1:End() Object oSAIRAc

Activate Dialog oDLG1 Centered Valid SairAc()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCarta()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Carta de Cobranca"
Local cPict          := ""
Local titulo       := "Carta de Cobranca"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "CARTA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CARTA" // Coloque aqui o nome do arquivo usado para impressao em disco

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cString := "SE1"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport()

Local cTels := "(83)3048-1305, (83)3048-1322 e (83)3048-1342"
Local cNomeCli	:= Posicione("SA1",1,xFilial("SA1") + MARC->CLIENTE + MARC->LOJA,"A1_NOME")
nlin	:= 4

dDia := Subst(dToc(dDatabase),1,2)
dMes := Subst(dToc(dDatabase),4,2) //mes

If dMes == '01'
	cMes := 'Janeiro'
ElseIf dMes == '02'
	cMes := 'Fevereiro'
ElseIf dMes == '03'
	cMes := 'Marco'
ElseIf dMes == '04'
	cMes := 'Abril'
ElseIf dMes == '05'
	cMes := 'Maio'
ElseIf dMes == '06'
	cMes := 'Junho'
ElseIf dMes == '07'
	cMes := 'Julho'
ElseIf dMes == '08'
	cMes := 'Agosto'
ElseIf dMes == '09'
	cMes := 'Setembro'
ElseIf dMes == '10'
	cMes := 'Outubro'
ElseIf dMes == '11'
	cMes := 'Novembro'
ElseIf dMes == '12'
	cMes := 'Dezembro'
Endif

dAno := Trim(Str(Year(dDatabase)))

@ nlin, 030 pSay AllTrim(SM0->M0_CIDCOB)+", "+dDia+" de "+cMes +" de "+AllTrim(dAno)
nlin := nlin + 3
//               12345678901234567890123456789012345678901234567890123456789012345678901234567890

//1-Tom Suave
if oCBox1:nAt = 1 
	@ nlin, 000 pSay cNomeCli
	nLin ++
	@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
	nLin ++
	@ nlin, 000 pSay "Prezado(s) Senhor(es),"
	nlin := nlin +2
	@ nlin,000 pSay "Nใo constatamos o(s) pagamento(s) do(s) tํtulo(s) abaixo relacionado(s). "
	nlin ++
	@ nlin,000 pSay "Pedimos que Vossa Senhoria entre em contato conosco atrav้s do telefone(s): "
	nlin ++
	@ nlin,000 pSay cTels+" e, por gentileza tome as provid๊ncias necessแrias para evitar "
	nlin ++
	@ nlin,000 pSay "que o fato cause problemas entre as partes."
	nlin ++
	@ nlin,000 pSay "Caso o pagamento tenha sido efetuado, favor nos enviar via Fax, pelos mesmos "
	nlin ++
	@ nlin,000 pSay "telefones acima, o comprovante de quita็ใo, agilizando assim, nossa identifica็ใo"
	nlin ++
	@ nlin,000 pSay "e baixa."
elseif oCBox1:nAt = 2
	//2- Tom mediano
	@ nlin, 000 pSay cNomeCli
	nLin ++
	@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
	nLin ++
	@ nlin, 000 pSay "Prezado(s) Senhor(es),"
	nlin := nlin +2
	@ nlin,000 pSay "Como nใo recebemos resposta a nosso primeiro comunicado, emitido em   /  /  ,"
	nlin ++
	@ nlin,000 pSay "pedimos novamente que seja regularizado o pagamento, que se encontra em atraso,"
	nlin ++
	@ nlin,000 pSay "referente ao(s) titulo(s) abaixo relacionado(s)."
	nlin ++
	@ nlin,000 pSay "Contamos com suas provid๊ncias a respeito desse d้bito, para que medidas mais "
	nlin ++
	@ nlin,000 pSay "extremas nใo sejam tomadas."
elseif oCBox1:nAt = 3
	//3-Tom mais forte
	@ nlin, 000 pSay cNomeCli
	nLin ++
	@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
	nLin ++
	@ nlin, 000 pSay "Prezado(s) Senhor(es),"
	nlin := nlin +2
	@ nlin,000 pSay "Apesar das solicita็๕es que fizemos, at้ o momento nใo recebemos nenhuma "
	nlin ++
	@ nlin,000 pSay "resposta de Vossa Senhoria a respeito do nใo pagamento do(s) tํtulo(s) abaixo "
	nlin ++
	@ nlin,000 pSay "relacionado(s).Por esse motivo, enviaremos o(s) tํtulos em questใo para a Serasa,"
	nlin ++
	@ nlin,000 pSay "no prazo de 48 horas."
	nlin ++
	@ nlin,000 pSay "Para saldarem esse debito procurem-nos antes de findarem as 48 horas, atrav้s "
	nlin ++
	@ nlin,000 pSay "do telefone "+cTels
endif

nlin := nlin + 2
@ nlin,000 pSay "     Tํtulo                       Emissao    Vencto           Valor"
nlin ++
//                           99/99/9999 99/99/9999  999,999.99
//               012345678901234567890123456789012345678901234567890123456789


Dbselectarea("MARC")
dbgotop()
While !Eof()
	IF MARC->MARCA == cMARCA
		@ nlin, 004 pSay MARC->TITULO
		@ nlin, 012 pSay DTOC(MARC->EMISSAO)
		@ nlin, 023 pSay DTOC(MARC->VENCTO)
		@ nlin, 035 pSay MARC->SALDO picture "@E 999,999.99"
		nLin ++ // Avanca a linha de impressao
		Dbselectarea("SA1")
		Dbsetorder(1)
		Dbseek(xFilial()+MARC->CLIENTE+MARC->LOJA)
		Dbselectarea("SE1")
		Dbsetorder(2)
		//TITSE1->E1_PREFIXO+"-"+TITSE1->E1_NUM+"/"+TITSE1->E1_PARCELA+" - "+TITSE1->E1_TIPO
		If Dbseek(xFilial()+MARC->CLIENTE+MARC->LOJA+Subst(MARC->TITULO,1,3)+Subst(MARC->TITULO,5,6)+Subst(MARC->TITULO,12,3)+Subst(MARC->TITULO,16,3))
			Reclock("SE1",.F.)
			Replace E1_STATCOB With Subst(E1_STATCOB,1,2)+'2' //marca que o titulo ja foi impresso
		Endif
	Endif
	Dbselectarea("MARC")
	dbskip()
End
//nlin := nlin + 3
//@ nlin, 000 pSay "Registramos que, nใo havendo nenhum contato, o(s) d้bito(s) acima serแ(ใo)"
//                12345678901234567890123456789012345678901234567890123456789012345678901234567890
//nlin ++
//@ nlin, 000 pSay "enviado(s) a Cobran็a Externa."
nlin := nlin + 2
@ nlin, 000 pSay "Obs.: Caso tenha Quitado o(s) referido(s) d้bito(s), favor enviar comprovante"
nlin ++
@ nlin, 000 pSay "de quita็ใo."
nlin := nlin + 2
@ nlin, 005 pSay "Atenciosamente,"
nlin := nlin + 2
//@ nlin, 005 pSay "____________________"
//nlin ++
@ nlin, 005 pSay "Rava Embalagens"
nlin ++
@ nlin, 005 pSay "SETOR DE COBRANวA"

@ 058, 017 pSay "FONE "+transform(SA1->A1_TEL,"@R (99)9999-999") + "  FAX "+transform(SA1->A1_FAX,"@R (99)9999-999")
nlin ++
@ 062, 017 pSay MARC->CLIENTE+" "+SA1->A1_NOME
nlin ++
@ 063, 017 pSay "Endereco "+SA1->A1_END
nlin ++
@ 064, 017 pSay SA1->A1_MUN+SA1->A1_BAIRRO+SA1->A1_EST
nlin ++
@ 065, 017 pSay "CEP :"+SA1->A1_CEP
nlin := nlin + 3

Roda(0,"","P")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

DbCloseArea("MARC")
Close( oDLG1 )

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SairCarta

DbCloseArea("MARC")
Close( oDLG1 )
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeCarta()

aCAMPOS := { { "MARCA"  , "C", 02, 0 }, ;
{ "TITULO"     , "C", 19, 0 }, ;
{ "CLIENTE"    , "C", 06, 0 }, ;
{ "LOJA"       , "C", 02, 0 }, ;
{ "NATUREZA"   , "C", 05, 0 }, ; //O campo padrao tem 10 posicoes, diminuimos para diminuir na tela.
{ "EMISSAO"    , "D", 08, 0 }, ;
{ "VENCTO"     , "D", 08, 0 }, ;
{ "VLRPRIN"    , "N", 09, 2 }, ;
{ "JUROS"      , "N", 09, 2 }, ;
{ "PAGTO"      , "N", 09, 2 }, ;
{ "SALDO"      , "N", 09, 2 }, ;
{ "NUMDEP"     , "C", 09, 0 }, ;
{ "PORTADOR"   , "C", 03, 0 }, ;
{ "CARTEIRA"   , "C", 10, 0 }, ;
{ "PEDIDO"     , "C", 06, 0 }, ;
{ "STCOB"      , "C", 03, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "MARC", .F., .F. )
Index On VENCTO TO &cARQEMP

dbselectarea("SE1")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
cQUERY += " SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_VENCREA, SE1.E1_VENCTO, SE1.E1_PORTADO, SE1.E1_PEDIDO, "
cQUERY += " SE1.E1_NATUREZ, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_EMISSAO, SE1.E1_NUMDPID, SE1.E1_STATCOB "
cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + SA1->A1_COD+SA1->A1_LOJA + "' "
cQUERY += " AND SE1.E1_SALDO > 0 "
cQUERY += " AND SE1.D_E_L_E_T_ = '' "
cQUERY += " Order By SE1.E1_VENCREA"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TITSE1 New

TcSetField( "TITSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TITSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TITSE1", "E1_EMISSAO", "D", 08, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TITSE1")
dbgotop()

nTitSel    := 0

While !Eof()
	
	If TITSE1->E1_TIPO $ 'RA NCC AB-'
		dbskip()
		Loop
	Endif
	
	nDias      := dDatabase-TITSE1->E1_VENCTO//VENCREA//Mudado para calcular o juros em cima do vencimento original
	
	Dbselectarea("TITSE1")
	Reclock("MARC",.T.)
	Replace MARCA   With ''
	Replace TITULO  With TITSE1->E1_PREFIXO+"-"+TITSE1->E1_NUM+"/"+TITSE1->E1_PARCELA+"-"+TITSE1->E1_TIPO
	Replace CLIENTE With TITSE1->E1_CLIENTE
	Replace LOJA    With TITSE1->E1_LOJA
	Replace NATUREZA With TITSE1->E1_NATUREZ
	Replace EMISSAO With TITSE1->E1_EMISSAO
	Replace VENCTO  With TITSE1->E1_VENCREA//TO
	Replace VLRPRIN With TITSE1->E1_VALOR
	Replace JUROS   With (nJurosTit*nDias)
	Replace PAGTO   With TITSE1->E1_VALOR-TITSE1->E1_SALDO
	Replace SALDO   With TITSE1->E1_SALDO
	Replace NUMDEP  With TITSE1->E1_NUMDPID
	Replace PORTADOR With TITSE1->E1_PORTADO
	Replace PEDIDO  With TITSE1->E1_PEDIDO
	Replace STCOB   With TITSE1->E1_STATCOB
	msunlock()
	Dbselectarea("TITSE1")
	dbskip()
End

Dbclosearea("TITSE1")

MARC->( DbGotop() )

aCPOBRW2  :=  { { "MARCA"    ,, OemToAnsi( "" ) }, ;
{ "TITULO"      ,, OemToAnsi( "Titulo" ) }, ;
{ "NATUREZA"    ,, OemToAnsi( "Natureza" ) }, ;
{ "EMISSAO"     ,, OemToAnsi( "Emissao" ) }, ;
{ "VENCTO"      ,, OemToAnsi( "Vencto" ) }, ;
{ "PORTADOR"    ,, OemToAnsi( "Portador" ) }, ;
{ "VLRPRIN"     ,, OemToAnsi( "Principal"), "@E 99,999.99" }, ;
{ "SALDO"       ,, OemToAnsi( "Saldo" ), "@E 99,999.99" }, ;
{ "JUROS"       ,, OemToAnsi( "Juros" ), "@E 999,999.99" }, ;
{ "PAGTO"       ,, OemToAnsi( "Pago" ) , "@E 99,999.99" }, ;
{ "NUMDEP"      ,, OemToAnsi( "Num Depoosito"), "@R 99999999-9" }, ;
{ "CARTEIRA"    ,, OemToAnsi( "Carteira" ) }, ;
{ "PEDIDO"      ,, OemToAnsi( "Pedido" ) }}

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarcaTudoCarta()

Local nREG := MARC->( Recno() )

MARC->( DbGotop() )
While ! Eof()
	IF MARC->MARCA == cMARCA
		MARC->MARCA := "  "
		nTitSel    --
	Else
		MARC->MARCA := cMARCA
		nTitSel    ++
	Endif
	MARC->( DbSkip() )
Enddo
MARC->( dbGoto( nREG ) )

oBRW2:oBrowse:Refresh()
ObjectMethod( oTitSel , "SetText( nTitSel  )" )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarcaCarta()

If MARC->MARCA == cMARCA
	MARC->MARCA := cMARCA
	nTitSel    ++
Else
	MARC->MARCA := "  "
	nTitSel    --
End

//MARC->( DbGotop() )
oBrw2:oBrowse:Refresh()
ObjectMethod( oTitSel , "SetText( nTitSel  )" )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RegistrarSCI()

cObsSCI := CriaVar("ZZ6->ZZ6_SPC")

@ 96,030 TO 300,650 DIALOG oDlg7 TITLE "Registrar SCI"
@ 010,015 GET cObsSCI Size 280,50 MEMO
@ 070,120 BUTTON "_Ok" SIZE 35,15  ACTION _GravaSCI()
ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _GravaSCI()

If !Empty(cObsSCI)
	mSCI := Trim(mSCI)+IIF(!Empty(mSCI),Chr(13)+CHR(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> "+Trim(cObsSCI) //Atualiza variavel da tela principal
	Dbselectarea("ZZ6")
	Dbsetorder(1)
	If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
		Reclock("ZZ6",.F.)
		Replace ZZ6_SPC With mSCI
		msunlock()
	Endif
Endif

Close(oDlg7)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Titulos()

@ 96,030 TO 230,600 DIALOG oDlgTit TITLE "Consulta Titulos"

@ 005,005 to 031,270 Title "Consulta"
@ 012,010 BUTTON "A Vencer"       SIZE 35,15  ACTION AVencer()
@ 012,050 BUTTON "Pagos"          SIZE 35,15  ACTION Pagos()
@ 012,090 BUTTON "Liquidados"     SIZE 35,15  ACTION Liquidados()
@ 012,130 BUTTON "Chs Devolvidos" SIZE 45,15  ACTION ChsDevol()
@ 012,180 BUTTON "Protestados"    SIZE 40,15  ACTION Protestados()
@ 012,225 BUTTON "Fat a Receber"  SIZE 40,15  ACTION Faturados()

@ 034,005 to 060,112 Title "Manutencao"
@ 040,010 BUTTON "Prorrogar Venc" SIZE 45,15  ACTION Prorrogar()
@ 040,060 BUTTON "Alt Natureza"   SIZE 45,15  ACTION AltNatureza()
@ 040,225 BUTTON "Voltar"         SIZE 35,15  ACTION Close(oDlgTit)

ACTIVATE DIALOG oDlgTit CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pedidos()

@ 96,030 TO 200,250 DIALOG oDlgPed TITLE "Pedidos"
@ 010,005 BUTTON "Pedidos"        SIZE 40,15  ACTION ConsuPedidos()
@ 010,050 BUTTON "Ped Pendentes"  SIZE 55,15  ACTION PedPend()
@ 030,040 BUTTON "Voltar"         SIZE 35,15  ACTION Close(oDlgPed)
ACTIVATE DIALOG oDlgPed CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Prorrogar()

MsgBox("Informe Nome e Senha para Prorrogar um Vencimento","Prorrogar vencimento","INFO")

//Pedir senha antes de processar

lOk := U_SENHA('07')
If !lOk
	Alert("Usuario sem permissao para prorrogar vencimento !!!")
	Return
Endif

cPrf     := Space(3)
cTit     := Space(6)
cPar     := Space(1)
cTp      := Space(3)
dProrrog := ctod("")
mObsPro  := Criavar("ZZ6->ZZ6_MEMO")

@ 96,030 TO 350,400 DIALOG oDlgProrrogar TITLE "Prorrogar Vencimento - Informe Dados do titulo"
@ 005,005 Say "Prefixo : "
@ 005,040 get cPrf SIZE 30,15
@ 015,005 Say "Numero  : "
@ 015,040 get cTit SIZE 30,30
@ 025,005 Say "Parcela : "
@ 025,040 get cPar SIZE 30,10
@ 035,005 Say "Tipo    : "
@ 035,040 get cTp  SIZE 30,15 F3 '05'

@ 050,005 Say "Prorrogar Para : "
@ 050,050 get dProrrog SIZE 40,30 Valid !Empty(dProrrog)

@ 065, 005 SAY OemToAnsi("Obs :")
@ 065 ,025 GET mObsPro Size 160,30 MEMO

@ 100,020 BUTTON "Confirma"   SIZE 40,15  ACTION ProrrogarOk()
@ 100,060 BUTTON "Cancela"    SIZE 40,15  ACTION Close(oDlgProrrogar)

ACTIVATE DIALOG oDlgProrrogar CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProrrogarOk()

Dbselectarea("SE1")
Dbsetorder(2)
If Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+cPrf+cTit+cPar+cTp)
	
	If dProrrog < SE1->E1_VENCREA
		//Atualiza Titulo
		Reclock("SE1",.F.)
		Replace E1_VENCTO  With dProrrog
		Replace E1_VENCREA With Datavalida(dProrrog)
		msunlock()
		
		Close(oDlgProrrogar)
		
		Alert("Vencimento Alterado com Sucesso")
	Else
		//Enviar e-mail
		CONNECT SMTP SERVER AllTRIM(GETMV("MV_RELSERV")) ACCOUNT AllTRIM(GETMV("MV_RELACNT")) PASSWORD AllTRIM(GETMV("MV_RELPSW"))
		SEND MAIL FROM "Setor de Cobranca <financeiro@ravaembalagens.com.br>" to "Destinatario <email@dominio>" ;
		SUBJECT "Prorroga็ใo de Titulo" ;
		BODY "Cliente :"+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+ " <P>"+;
		"Titulo :"+cPrf+" "+cTit+" "+cPar+" "+cTp+" <P>"+;
		"Vencimento Original :"+DTOC(SE1->E1_VENCORI)+" <P>"+;
		"Vencimento Atual    :"+DTOC(SE1->E1_VENCREA)+" <P>"+;
		"Vencimento Novo     :"+DTOC(Datavalida(dProrrog))+" <P>"+;
		"Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))+" <P>"+;
		"Observa็ใo: "+mObsPro
		
		DISCONNECT SMTP SERVER
		
		//Atualiza memoria da cobranca
		mCob := Trim(ZZ6->ZZ6_MEMO)+Chr(13)+CHR(10) //Aplica um enter se ja tiver informacao
		mCob := Trim(mCob)+"VENCIMENTO PRORROGADO - Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))
		mCob := Trim(mCob)+Chr(13)+CHR(10)
		mCob := Trim(mCob)+"Titulo :"+cPrf+" "+cTit+" "+cPar+" "+cTp+" Venc. Atual :"+DTOC(SE1->E1_VENCREA)+" Venc Novo :"+DTOC(Datavalida(dProrrog))
		mCob := Trim(mCob)+mObsPro
		
		Reclock("ZZ6",.F.)
		Replace ZZ6_MEMO With mCob
		msunlock()
		
		//Atualiza Titulo
		Reclock("SE1",.F.)
		Replace E1_VENCTO  With dProrrog
		Replace E1_VENCREA With Datavalida(dProrrog)
		msunlock()
		
		Close(oDlgProrrogar)
	Endif
Else
	MsgBox("Verifique dados informados","Titulo NAO encontrado","INFO")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltNatureza()

MsgBox("Informe Nome e Senha para Alterar Natureza","Alterar Natureza","INFO")

//Pedir senha antes de processar

lOk := U_SENHA('07')
If !lOk
	Alert("Usuario sem permissao para Alterar Natureza !!!")
	Return
Endif

cPrf      := Space(3)
cTit      := Space(6)
cPar      := Space(1)
cTp       := Space(3)
cNatureza := Space(10)
mObsNat   := Criavar("ZZ6->ZZ6_MEMO")

@ 96,030 TO 350,400 DIALOG oDlgNatureza TITLE "Alterar Natureza - Informe Dados do titulo"
@ 005,005 Say "Prefixo : "
@ 005,040 get cPrf SIZE 30,15
@ 015,005 Say "Numero  : "
@ 015,040 get cTit SIZE 30,30
@ 025,005 Say "Parcela : "
@ 025,040 get cPar SIZE 30,10
@ 035,005 Say "Tipo    : "
@ 035,040 get cTp  SIZE 30,15 F3 '05'

@ 050,005 Say "Natureza Para : "
@ 050,050 get cNatureza SIZE 40,30  F3 'SED' Valid !Empty(cNatureza)

@ 065, 005 SAY OemToAnsi("Obs :")
@ 065 ,025 GET mObsNat Size 160,30 MEMO


@ 100,020 BUTTON "Confirma"   SIZE 40,15  ACTION AltNaturOk()
@ 100,060 BUTTON "Cancela"    SIZE 40,15  ACTION Close(oDlgNatureza)

ACTIVATE DIALOG oDlgNatureza CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  06/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltNaturOk()

Dbselectarea("SE1")
Dbsetorder(2)
If Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+cPrf+cTit+cPar+cTp)
	
	//Comentei para aceitar alteracao para qualquer natureza
	//	If Left(cNatureza,3) <> Left(SE1->E1_NATUREZ,3)
	//	   Alert("Natureza invalida !!!")
	//	   Return
	//	Endif
	
	If !Empty(SE1->E1_NUMBOR)
		Alert("Titulo em cobranca bancaria. Alteracao nao pode ser feita !!!")
		Return
	Endif
	
	Dbselectarea("SE5")
	Dbsetorder(7)
	If Dbseek(xFilial()+cPrf+cTit+cPar+cTp+SA1->A1_COD+SA1->A1_LOJA)
		Alert("Titulo com movimento. Alteracao nao pode ser feita !!!")
	Else
		//Enviar e-mail
		CONNECT SMTP SERVER AllTRIM(GETMV("MV_RELSERV")) ACCOUNT AllTRIM(GETMV("MV_RELACNT")) PASSWORD AllTRIM(GETMV("MV_RELPSW"))
		SEND MAIL FROM "Setor de Cobranca <financeiro@ravaembalagens.com.br>" to "Destinatario <email@dominio>" ;
		SUBJECT "Alteracao de Natureza" ;
		BODY "Cliente :"+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+ " <P>"+;
		"Titulo :"+cPrf+" "+cTit+" "+cPar+" "+cTp+" <P>"+;
		"Natureza Atual :"+SE1->E1_NATUREZ+" <P>"+;
		"Natureza Nova  :"+cNatureza+" <P>"+;
		"Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))+" <P>"+;
		"Observa็ใo: "+mObsNat
		
		DISCONNECT SMTP SERVER
		
		//Atualiza memoria da cobranca
		mCob := Trim(ZZ6->ZZ6_MEMO)+Chr(13)+CHR(10) //Aplica um enter se ja tiver informacao
		mCob := Trim(mCob)+"NATUREZA ALTERADA - Efetuado dia "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))
		mCob := Trim(mCob)+Chr(13)+CHR(10)
		mCob := Trim(mCob)+"Titulo :"+cPrf+" "+cTit+" "+cPar+" "+cTp+" Natureza Atual :"+SE1->E1_NATUREZ+" Natureza Nova :"+cNatureza
		mCob := Trim(mCob)+mObsNat
		
		Reclock("ZZ6",.F.)
		Replace ZZ6_MEMO With mCob
		msunlock()
		
		//Atualiza Titulo
		Reclock("SE1",.F.)
		Replace E1_NATUREZ With cNatureza
		msunlock()
		
		Close(oDlgNatureza)
	Endif
Else
	MsgBox("Verifique dados informados","Titulo NAO encontrado","INFO")
Endif

Return



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DISCAGEM( cTPPESQ )

***************

SetPrvt( "oDLGDISC, oDISCFIXO, oDISCCEL, oDISCFAX, oDISCAGEM, oDISCOK, oDISCCANC, nDISCOPC, oSAY1, " )

cDISCFIXO := SA1->A1_TEL
cDISCCEL  := SA1->A1_TELEX
cDISCFAX  := SA1->A1_FAX
cDISCCON  := SA1->A1_CONTATO
nDISCOPC  := 1

oDLGDISC := MSDIALOG():Create()
oDLGDISC:cName := "oDLGDISC"
oDLGDISC:cCaption := "Discagem"
oDLGDISC:nLeft := 0
oDLGDISC:nTop := 0
oDLGDISC:nWidth := 211
oDLGDISC:nHeight := 205
oDLGDISC:lShowHint := .F.
oDLGDISC:lCentered := .T.

oDISCFIXO := TGET():Create(oDLGDISC)
oDISCFIXO:cName := "oDISCFIXO"
oDISCFIXO:nLeft := 75
oDISCFIXO:nTop := 12
oDISCFIXO:nWidth := 120
oDISCFIXO:nHeight := 21
oDISCFIXO:lShowHint := .F.
oDISCFIXO:lReadOnly := .F.
oDISCFIXO:Align := 0
oDISCFIXO:cVariable := "cDISCFIXO"
oDISCFIXO:bSetGet := {|u| If(PCount()>0,cDISCFIXO:=u,cDISCFIXO) }
oDISCFIXO:lVisibleControl := .T.
oDISCFIXO:lPassword := .F.
oDISCFIXO:lHasButton := .F.
oDISCFIXO:Picture := PesqPict( "SA1", "A1_TEL" )

oDISCCEL := TGET():Create(oDLGDISC)
oDISCCEL:cName     := "oDISCCEL"
oDISCCEL:nLeft     := 75
oDISCCEL:nTop      := 42
oDISCCEL:nWidth    := 120
oDISCCEL:nHeight   := 21
oDISCCEL:lShowHint := .F.
oDISCCEL:lReadOnly := .F.
oDISCCEL:Align := 0
oDISCCEL:cVariable := "cDISCCEL"
oDISCCEL:bSetGet := {|u| If(PCount()>0,cDISCCEL:=u,cDISCCEL) }
oDISCCEL:lVisibleControl := .T.
oDISCCEL:lPassword := .F.
oDISCCEL:lHasButton := .F.
oDISCCEL:Picture := PesqPict( "SA1","A1_TEL" )

oDISCFAX := TGET():Create(oDLGDISC)
oDISCFAX:cName := "oDISCFAX"
oDISCFAX:nLeft := 75
oDISCFAX:nTop := 72
oDISCFAX:nWidth := 120
oDISCFAX:nHeight := 21
oDISCFAX:lShowHint := .F.
oDISCFAX:lReadOnly := .F.
oDISCFAX:Align := 0
oDISCFAX:cVariable := "cDISCFAX"
oDISCFAX:bSetGet := {|u| If(PCount()>0,cDISCFAX:=u,cDISCFAX) }
oDISCFAX:lVisibleControl := .T.
oDISCFAX:lPassword := .F.
oDISCFAX:lHasButton := .F.
oDISCFAX:Picture := PesqPict( "SA1","A1_TEL" )

oSay1 := TSAY():Create(oDLGDISC)
oSay1:cName := "oSay1"
oSay1:cCaption := "Contato:"
oSay1:nLeft := 20
oSay1:nTop := 105
oSay1:nWidth := 43
oSay1:nHeight := 15
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oDISCCON:= TGET():Create(oDLGDISC)
oDISCCON:cName := "oDISCCON"
oDISCCON:nLeft := 75
oDISCCON:nTop := 102
oDISCCON:nWidth := 120
oDISCCON:nHeight := 21
oDISCCON:lShowHint := .F.
oDISCCON:lReadOnly := .F.
oDISCCON:Align := 0
oDISCCON:cVariable := "cDISCCON"
oDISCCON:bSetGet := {|u| If(PCount()>0,cDISCCON:=u,cDISCCON) }
oDISCCON:lVisibleControl := .T.
oDISCCON:lPassword := .F.
oDISCCON:lHasButton := .F.
oDISCCON:Picture := PesqPict( "SA1","A1_CONTATO" )

oDISCAGEM := TRADMENU():Create(oDLGDISC)
oDISCAGEM:cName := "oDISCAGEM"
oDISCAGEM:nLeft := 9
oDISCAGEM:nTop := 11
oDISCAGEM:nWidth := 60
oDISCAGEM:nHeight := 93
oDISCAGEM:lShowHint := .F.
oDISCAGEM:lReadOnly := .F.
oDISCAGEM:Align := 0
oDISCAGEM:lVisibleControl := .T.
oDISCAGEM:nOption := 0
oDISCAGEM:bSetGet := {|u| If(PCount()>0,nDISCOPC:=u,nDISCOPC) }
oDISCAGEM:aItems := { "Fixo:","Celular:","Fax:"}

oDISCOK := SBUTTON():Create(oDLGDISC)
oDISCOK:cName := "oDISCOK"
oDISCOK:nLeft := 116
oDISCOK:nTop := 143
oDISCOK:nWidth := 60
oDISCOK:nHeight := 25
oDISCOK:lShowHint := .F.
oDISCOK:lReadOnly := .F.
oDISCOK:Align := 0
oDISCOK:lVisibleControl := .T.
oDISCOK:nType := 1
oDISCOK:bAction := {|| DISCOK( cTPPESQ ) }

oDISCCANC := SBUTTON():Create(oDLGDISC)
oDISCCANC:cName := "oDISCCANC"
oDISCCANC:nLeft := 28
oDISCCANC:nTop := 143
oDISCCANC:nWidth := 60
oDISCCANC:nHeight := 25
oDISCCANC:lShowHint := .F.
oDISCCANC:lReadOnly := .F.
oDISCCANC:Align := 0
oDISCCANC:lVisibleControl := .T.
oDISCCANC:nType := 2
oDISCCANC:bAction := {|| oDLGDISC:End() }

oDLGDISC:Activate()

Return



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DISCOK( cTPPESQ )

***************

Private nHandle := -1
Private cHndCTI := "-1"

If cDISCFIXO <> SA1->A1_TEL .or. cDISCCEL <> SA1->A1_TELEX .or. cDISCFAX <> SA1->A1_FAX .or. cDISCCON <> SA1->A1_CONTATO
	Reclock( "SA1", .F. )
	If cDISCFIXO <> SA1->A1_TEL
		SA1->A1_TEL := cDISCFIXO
		oFONES:SetText( Trim( cDISCFIXO ) )
	EndIf
	If cDISCCEL <> SA1->A1_TELEX
		SA1->A1_TELEX := cDISCCEL
	EndIf
	If cDISCFAX <> SA1->A1_FAX
		SA1->A1_FAX := cDISCFAX
		oFAX:SetText( Trim( cDISCFAX ) )
	EndIf
	If cDISCCON <> SA1->A1_CONTATO
		SA1->A1_CONTATO := cDISCCON
		oCONTATO:SetText( Trim( cDISCCON ) )
	EndIf
	Msunlock()
EndIf

nDISCHINI := Seconds()
nRET      := U_DiscaNumero( 24, "0,"+If( nDISCOPC == 1, cDISCFIXO, If( nDISCOPC == 2, cDISCCEL, cDISCFAX ) ) )
nDISCHFIM := Seconds()

If nDISCHFIM - nDISCHINI > 20
	Dbselectarea("ZA8")
	Reclock("ZA8",.T.)
	Replace ZA8_FILIAL   With xFilial() //Filial
	Replace ZA8_DTATEN   With dDatabase //Data atendimento
	Replace ZA8_HRINI    With U_DifHoras( nDISCHINI, 0 ) //Hora inicial
	Replace ZA8_HRFIM    With U_Difhoras( nDISCHFIM, 0 ) //Hora final
	Replace ZA8_CODATE   With cCodAtend //Codigo do atendente
	Replace ZA8_NOMATE   With cNomAtend //Nome do atendente
	Replace ZA8_CODCLI   With SA1->A1_COD  //Codigo do cliente
	Replace ZA8_LJCLI    With SA1->A1_LOJA //loja do cliente
	Replace ZA8_NOMCLI   With SA1->A1_NOME //Nome do cliente
	If Empty( cTPPesq ) .Or. cTPPesq == Nil
		Replace ZA8_PRIOR    With ZZ6->ZZ6_PRIORI //Prioridade
		Replace ZA8_SEQUEN   With ZZ6->ZZ6_SEQUEN //Sequencia
	Else
		Replace ZA8_PRIOR    With cTPPesq //Prioridade
	Endif
	Replace ZA8_QUALI    With 'N' //Positivo ou negativo
	msunlock()
	nDISCREG := ZA8->( Recno() )
EndIf
Return .T.

***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DiscaNumero( nTipSol, cTel )

***************

Local nRet    := 0
Local aBuffer := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEnvia os dados para a CTI/MODEM executar a discagem.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTel:= AllTrim( cTel )
nRet:= EnviaCti( nTipSol, {cTel}, @aBuffer )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha a comunicacao com o MODEM.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*If nRet == 0 .And. Empty(cCTI)
*  Aviso("",OemToAnsi("Discando para " + cTel + " ..." ),{OemToAnsi("Desligar")} ) //"Discando para " "Desligar"
*  XSendCti( 25, {}, @aBuffer)
*EndIf

Return(nRet)



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaCti( nTipSol, aParam, aBuffer )

***************

Local i      := 0
Local cParam := ""
Local cDirTX := GetMv("MV_TMKCTTX")
Local cDirRX := GetMv("MV_TMKCTRX")
Local cBuffer:= Space(500)
Local nRet   := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre a comunicacao com a DLL.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ChecaDLL()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvia dados para a CTIณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (nHandle >= 0)
		cParam := cHndCTI + "|" + __cUserID + "|" + cDirTX + "|" + cDirRX + "|"
		
		If (Len(aParam) > 0)
			
			For i:= 1 To Len(aParam)
				cParam += aParam[i] + "|"
			Next
		EndIf
		
		cBuffer:= cParam+Space(500-Len(cParam))
		nRet:= ExeDllRun2( nHandle, nTipSol, cBuffer)
	EndIf
	
	ChecaRet( nRet, nTipSol, cBuffer, @aBuffer )
Endif

Return(nRet)



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChecaRet( nRet, nTipSol, cBuffer, aBuffer )

***************

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExibe a mensagem de erro.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aBuffer:= LeBuf( "|",cBuffer )
If (nRet > 0)
	if ( Len(aBuffer) >= 4 ) // Verifica se a mensagem esta completa
		Help(" ",1,"ERROCTI",,aBuffer[3] + " - " + aBuffer[4],3,5)
	else
		MsgStop("Erro no buffer")
	Endif
	
ElseIf (nRet < 0)
	Help(" ",1,"ERROCTI",,OemToAnsi("Erro na execucao da solicitacao!") + AllTrim(Str(nRet)) ,3,5) //"Erro na execucao da solicitacao!" "Retorno"
EndIf

Return



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeBuf( cSep, cBuffer )

***************

Local aBuffer:= {}
Local nPos   := 0
Local cString:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSepara as informacoes recebidas da SIGACTI.DLLณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nPos:= 1 To Len(cBuffer)
	If (SubStr(cBuffer,nPos,1) == cSep)
		If !Empty(cString)
			Aadd(aBuffer,cString)
			cString:= ""
		EndIf
	Else
		cString+= SubStr(cBuffer,nPos,1)
	EndIf
Next

Return(aBuffer)



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChecaDLL()

***************

Local lRet := .T.

If nHandle == -1
	nHandle := ExecInDLLOpen( "SIGACTI.DLL" )
EndIf

If nHandle == -1
	Help(" ",1,"ERROCTI",,OemToAnsi("A SIGACTI.DLL nใo encontrada ou com problemas, verifique se a mesma esta no diret๓rio do Protheus Remote. Ex: c:\ap6\bin\remote"),3,5)
	lRet:=.F.
Endif

Return(lRet)



***************

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldHora( cHORA )

***************

If Left( cHORA, 2 ) < "00" .or. Left( cHORA, 2 ) >= "24" .or. Right( cHORA, 2 ) < "00" .or. Right( cHORA, 2 ) >= "60" .or. ;
	Val( Left( cHORA, 2 ) ) < 0 .or. Val( Left( cHORA, 2 ) ) >= 24 .or. Val( Right( cHORA, 2 ) ) < 0 .or. Val( Right( cHORA, 2 ) ) >= 60
	Alert( "Hora invalida !" )
	Return .F.
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//
// Tela para digita็ใo da data da funda็ใo, Carta de Coligacao e Negativacao de Cliente do cliente
// Sandro - 19/12/2005
//
Static Function Credito()


if !U_Senha("07")
	return
endif

@ 116,030 TO 250,370 DIALOG oDlg_credit TITLE "Credito"

dDtfund   := SA1->a1_fundac
C_cart    := SA1->a1_cartcol
C_negativ := SA1->a1_negativ

@ 10,05 SAY "Carta de Coliga็ใo (S/N) :"
@ 10,70 GET C_cart SIZE 10,20 Picture "@!" valid C_cart$"SN"
@ 25,05 SAY "Negativar  (S/N) :"
@ 25,70 GET C_negativ SIZE 10,20 Picture "@!" valid C_negativ$"SN"

@ 45,020 BUTTON "_Gravar" SIZE 35,15  ACTION _GrvCredit()
@ 45,120 BUTTON "_Sair"   SIZE 35,15  ACTION Close(ODlg_Credit)

ACTIVATE DIALOG oDlg_Credit CENTERED

Return

Static Function _GrvCredit()

Reclock("SA1",.f.)
SA1->a1_cartcol := C_Cart
SA1->a1_negativ := C_negativ
Msunlock()
Close(Odlg_credit)
return



Static Function DtFundac()


@ 106,030 TO 200,370 DIALOG oDlg_fundac TITLE "Data da Fundacao"

dDtfund   := SA1->a1_fundac

@ 05,05 SAY "Dt Fundacao:"
@ 05,70 GET dDtfund SIZE 50,50

@ 25,020 BUTTON "_Gravar" SIZE 35,15  ACTION _GrvDtFundac()
@ 25,120 BUTTON "_Sair"   SIZE 35,15  ACTION Close(ODlg_fundac)

ACTIVATE DIALOG oDlg_fundac CENTERED

Return




Static Function _GrvDtFundac()

Reclock("SA1",.f.)
SA1->a1_fundac  := dDtFund
Msunlock()
Close(Odlg_fundac)
return

/*
*/
Static Function Ret_ND()

cQuery := " SELECT SUM(F2_VALBRUT) AS TOTAL FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " WHERE F2_CLIENTE='"+SA1->A1_COD+"' AND F2_EMISSAO >= '20060701' --AND (F2_COND='050' OR F2_COND='051') " //Mudar condicoes para cond.usadas na Rava
cQuery += " AND D_E_L_E_T_='' "

TcQuery cQuery Alias QSF2 New

_ndvaltot := Qsf2->total

Qsf2->(DbCloseArea())

return(_ndvaltot)

/*
*/

Static Function Ret_N()

cQuery := " SELECT SUM(D2_TOTAL+D2_VALIPI+D2_VALFRE) AS TOTAL FROM "+RetSqlName("SD2")+" "
cQuery += " WHERE D2_CLIENTE='"+Sa1->a1_cod+"' AND D2_EMISSAO >= '20060701' --AND D2_GRUPO='5000' " //Mudar grupos para grup.usados na Rava
cQuery += " AND D_E_L_E_T_='' "

TcQuery cQuery Alias QSD2 New

_nvaltot := QSD2->total
QSD2->(DbCloseArea())

return(_nvaltot)
