#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณ Eurivan Marques    บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa tela consulta pedido.                             บฑฑ
ฑฑบ          ณ _MV_TIPO(Cliente ou Pedido)                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Emabalagens - PFAT03()                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFAT031(_MV_TIPO)

Local aSizeAut,cC5_TABELA,cC5_DESCONTO,cC5_FRETE,aPos:={},aQdr:={},aBtn:={}
Local cC5_SEPARA,cC5_CONFERE,cC5_PESO,cC5_CONDPAG,cC5_CODBAR,lRetorno,aMyBtn:={}

aSizeAut		:= MsAdvSize(,.F.,400)

IF aSizeAut[5] > 800
	Private nRes := 1 //Resolucao 1024 1
Else
	Private nRes := 1.29 //Resolucao 800 1.29
Endif

DEFINE FONT oFnt_1 NAME "Arial"   SIZE (10/nRes),(20/nRes) BOLD
DEFINE FONT oFnt_2 NAME "Arial"   SIZE (06/nRes),(14/nRes) BOLD
DEFINE FONT oFnt_a NAME "Arial"  SIZE (10/nRes),(20/nRes) BOLD
DEFINE FONT oFnt_b NAME "Arial"  SIZE (07/nRes),(15/nRes) BOLD
DEFINE FONT oFnt_c NAME "Mono AS" SIZE (5/nRes),(-11/nRes)
DEFINE FONT oFnt_d NAME "Arial"  SIZE (10/nRes),(35/nRes) BOLD

Private nTot_Ped,nTotPedN,nTot_Qbr,nTot_Fat,nTot_Frt,nTotC6_Ite,nTotC6_Ref,nTotC9_Ite,nTotC9_Ref, nComis
Private cDigitador := Space(20)
Private dDtPedido := Ctod("")
Private dDtEntVen := Ctod("")
Private dDtSaida  := Ctod("")
Private nTotPedT := 0
Private nTotIpi  := 0
Private nTotIpiN := 0
private nFrtPed  := SC5->C5_FRETE
Private nTotQbr_Ite,nTotQbr_Ref,nTotFAT_Ite,nTotFAT_Ref
Private aHEADERC6,aCOLSC6,aHEADERC9,aCOLSC9,aCOLSQBR,aCOLSFAT
Private cConfere := Space(20)

PERGUNTE("PED_01",.F.)
IF _MV_TIPO == 1
	lRetorno := PFAT31_Psq()
	If !lRetorno
		Return
	Endif
ENDIF

If LEFT(SC5->C5_NUM,1) == "X" .Or. DTOS(SC5->C5_EMISSAO) < '20040101'
	Msgbox("Pedido Teste - Nao e possivel consultar","Tipo do Pedido","info")
	Return
Endif

//Adiciona os botoes da enchoicebar
Aadd(aMyBtn,{"PRODUTO"  , {||PFAT31RASTRO()}   ,OemToAnsi('Rastro Pedido')} )
Aadd(aMyBtn,{"SALARIOS" , {||PFAT31IDENT()} ,OemToAnsi('Numero para Deposito Identificado')} ) //PRODUTO
Aadd(aMyBtn,{"EDIT"     , {||U_LSTCODBAR()}    ,OemToAnsi('Lista Codigos de Barras')} ) //PRODUTO

If Empty(Select("TMPSE1"))
	Aadd(aMyBtn,{"PRECO"    , {||U_COBC011(,,,.F.,'CRD')} ,OemToAnsi('Cobranca')} ) // SALARIOS
eNDIF

Aadd(aMyBtn,{'GROUP'    , {||PFAT31ALT()  } ,OemToAnsi('Altera pedido')   } ) // NOVACELULA // ALTERACAO 22/08/2002
//Aadd(aMyBtn,{'GROUP'    , {||U_A_FATSEN()  } ,OemToAnsi('Altera pedido')   } ) // NOVACELULA // ALTERACAO 22/08/2002
Aadd(aMyBtn,{"CHAVE2"   , {||PFAT31ENDIV()   } ,OemToAnsi('Analise Credito')} ) //PRODUTO

cTABELA     := "Tabela "+SC5->C5_TABELA
cDescont    := ALLTRIM(STR(SC5->C5_DESC1))+' % +'+ALLTRIM(STR(SC5->C5_DESC2))+' % +'+ALLTRIM(STR(SC5->C5_DESC3))+' % +'+ALLTRIM(STR(SC5->C5_DESC4))+' %'
IIF(SC5->C5_TPFRETE = 'C' , cTipoFrt := 'CIF', cTipoFrt := 'FOB')
nComis      := SC5->C5_COMIS1
cPeso       := TRANSFORM(SC5->C5_PESOL,"@E 9,999.999")+'   -   '+ALLTRIM(SC5->C5_ESPECI1)
cNota       := SC5->C5_NOTA
cMensag1 := SC5->C5_MENNOTA
cMensag2 := SC5->C5_MENNOT2

IIF(SC5->C5_ESPECI3 = '1' , cCODBAR:= 'Sim', cCODBAR:= 'Nao')

//Posiciona no cadastro de clientes
SA1->( DBSETORDER(1) )
SA1->( DBSEEK(xFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )

//Posiciona na tabela generica - Prioridade do cliente
SX5->( DBSETORDER(1) )
SX5->( DBSEEK(SPACE(02)+"ZM"+PadR(SA1->A1_PRIOR,6)) )
cPRIOR := SX5->X5_DESCRI

//Posiciona na condicao de pagamento
SE4->( DBSETORDER(1) )
SE4->( DBSEEK(xFILIAL("SE4")+SC5->C5_CONDPAG) )
cCondPag := SC5->C5_CONDPAG +' - '+ SE4->E4_DESCRI

//Posiciona na transportadora
SA4->( DBSETORDER(1) )
SA4->( DBSEEK(xFILIAL("SA4")+SC5->C5_TRANSP)  )

//Posiciona no cadastro do vendedor
SA3->( DBSETORDER(1) )
SA3->( DBSEEK(xFILIAL("SA3")+SC5->C5_VEND1) )

//Posiciona na tabela generica - Status do Pedido
SX5->( DBSETORDER(1) )
SX5->( DBSEEK(SPACE(02)+"ZZ"+SC5->C5_STATUS) )
cDESCSTATUS := Trim(SX5->X5_DESCRI)

//Carregua array com dados da separacao
/*
ZZR->( DBSETORDER(2) )
ZZS->( DBSETORDER(1) )
ZZR->( DBSEEK(XFILIAL("ZZR")+SC5->C5_NUM) )
*/
aSepara    := {}
/*
While ZZR->(!EOF()) .And. SC5->C5_NUM == ZZR->ZZR_PEDIDO
	ZZS->( DBSEEK( xFILIAL("ZZS")+ZZR->ZZR_OPERAD ) )
	If ZZR->ZZR_TIPO == 'S'
		AAdd( aSepara, IIF(ZZR->ZZR_QUEBRA=="S","*"," ")+ ZZR->ZZR_RUA + " - "+AllTrim( ZZS->ZZS_NOME ) )
	ElseIf ZZR->ZZR_TIPO == 'C'
		cConfere := AllTrim( ZZS->ZZS_NOME )
	EndIf
	ZZR->(DBSKIP())
End
*/
cSepara := IIf( Len(aSepara) > 0, aSepara[1], Space(20) )
cLicit  := SC5->C5_COTACAO

Processa( { || PFAT31_Qry() } )

@ (000/nRes), (000/nRes) To (670/nRes),(1020/nRes) Dialog oDLGPedido Title "Consulta PEDIDO - "+SC5->C5_NUM

//Grupo do pedido

oGrpPed1 := TGROUP():Create(oDlgPedido)
oGrpPed1:cName := "oGrpPed1"
oGrpPed1:cCaption := ""
oGrpPed1:nLeft := 9/nRes
oGrpPed1:nTop   := 30/nRes
oGrpPed1:nWidth := 190/nRes
oGrpPed1:nHeight := 40/nRes
oGrpPed1:lShowHint := .F.
oGrpPed1:lReadOnly := .F.
oGrpPed1:Align := 0
oGrpPed1:lVisibleControl := .T.

oSayPed := TSAY():Create(oDlgPedido)
oSayPed:cName := "oSayPed"
oSayPed:cCaption := "Pedido:"
oSayPed:nLeft := 18/nRes
oSayPed:nTop := 40/nRes
oSayPed:nWidth := 70/nRes
oSayPed:nHeight := 15/nRes
oSayPed:lShowHint := .F.
oSayPed:lReadOnly := .F.
oSayPed:Align := 0
oSayPed:lVisibleControl := .T.
oSayPed:lWordWrap := .F.
oSayPed:lTransparent := .F.

oPedido := TSAY():Create(oDlgPedido)
oPedido:cName  := "oPedido"
oPedido:nLeft  := 100/nRes
oPedido:nTop   := 40/nRes
oPedido:nWidth := 70/nRes
oPedido:nHeight := 27/nRes
oPedido:lShowHint := .F.
oPedido:lReadOnly := .F.
oPedido:Align := 0
oPedido:lVisibleControl := .T.
oPedido:lWordWrap := .F.
oPedido:lTransparent := .F.

//Grupo do Status do Pedido

oGrpStatPed1 := TGROUP():Create(oDlgPedido)
oGrpStatPed1:cName := "oGrpStatPed1"
oGrpStatPed1:cCaption := ""
oGrpStatPed1:nLeft := 200/nRes
oGrpStatPed1:nTop   := 30/nRes
oGrpStatPed1:nWidth := 600/nRes
oGrpStatPed1:nHeight := 40/nRes
oGrpStatPed1:lShowHint := .F.
oGrpStatPed1:lReadOnly := .F.
oGrpStatPed1:Align := 0
oGrpStatPed1:lVisibleControl := .T.

oStatus := TSAY():Create(oDlgPedido)
oStatus:cName  := "oStatus"
oStatus:nLeft  := 220/nRes
oStatus:nTop   := 40/nRes
oStatus:nWidth := 500/nRes
oStatus:nHeight := 27/nRes
oStatus:lShowHint := .F.
oStatus:lReadOnly := .F.
oStatus:Align := 0
oStatus:lVisibleControl := .T.
oStatus:lWordWrap := .F.
oStatus:lTransparent := .F.

//Grupo Dados do Cliente
oGrpCliente := TGROUP():Create(oDlgPedido)
oGrpCliente:cName := "oGrpCliente"
oGrpCliente:cCaption := "Dados do Cliente"
oGrpCliente:nLeft := 9/nRes
oGrpCliente:nTop   := 80/nRes
oGrpCliente:nWidth := 791/nRes
oGrpCliente:nHeight := 270/nRes
oGrpCliente:lShowHint := .F.
oGrpCliente:lReadOnly := .F.
oGrpCliente:Align := 0
oGrpCliente:lVisibleControl := .T.

oSayCli := TSAY():Create(oDlgPedido)
oSayCli:cName := "oSayCli"
oSayCli:cCaption := "Cliente:"
oSayCli:nLeft := 18/nRes
oSayCli:nTop := 90/nRes
oSayCli:nWidth := 43/nRes
oSayCli:nHeight := 15/nRes
oSayCli:lShowHint := .F.
oSayCli:lReadOnly := .F.
oSayCli:Align := 0
oSayCli:lVisibleControl := .T.
oSayCli:lWordWrap := .F.
oSayCli:lTransparent := .F.

oCliente := TSAY():Create(oDlgPedido)
oCliente:cName  := "oCliente"
oCliente:nLeft  := 66/nRes
oCliente:nTop   := 90/nRes
oCliente:nWidth := 300/nRes
oCliente:nHeight := 27/nRes
oCliente:lShowHint := .F.
oCliente:lReadOnly := .F.
oCliente:Align := 0
oCliente:lVisibleControl := .T.
oCliente:lWordWrap := .F.
oCliente:lTransparent := .F.

oSayFantasia := TSAY():Create(oDlgPedido)
oSayFantasia:cName := "oSayFantasia"
oSayFantasia:cCaption := "Fantasia:"
oSayFantasia:nLeft := 460/nRes
oSayFantasia:nTop := 90/nRes
oSayFantasia:nWidth := 50/nRes
oSayFantasia:nHeight := 15/nRes
oSayFantasia:lShowHint := .F.
oSayFantasia:lReadOnly := .F.
oSayFantasia:Align := 0
oSayFantasia:lVisibleControl := .T.
oSayFantasia:lWordWrap := .F.
oSayFantasia:lTransparent := .F.

oFantasia := TSAY():Create(oDlgPedido)
oFantasia:cName  := "oFantasia"
oFantasia:nLeft  := 520/nRes
oFantasia:nTop   := 90/nRes
oFantasia:nWidth := 200/nRes
oFantasia:nHeight := 27/nRes
oFantasia:lShowHint := .F.
oFantasia:lReadOnly := .F.
oFantasia:Align := 0
oFantasia:lVisibleControl := .T.
oFantasia:lWordWrap := .F.
oFantasia:lTransparent := .F.

oSayFone := TSAY():Create(oDlgPedido)
oSayFone:cName := "oSayFone"
oSayFone:cCaption := "Fone:"
oSayFone:nLeft := 18/nRes
oSayFone:nTop := 110/nRes
oSayFone:nWidth := 43/nRes
oSayFone:nHeight := 15/nRes
oSayFone:lShowHint := .F.
oSayFone:lReadOnly := .F.
oSayFone:Align := 0
oSayFone:lVisibleControl := .T.
oSayFone:lWordWrap := .F.
oSayFone:lTransparent := .F.

oFone := TSAY():Create(oDlgPedido)
oFone:cName  := "oFone"
oFone:nLeft  := 50/nRes
oFone:nTop   := 110/nRes
oFone:nWidth := 200/nRes
oFone:nHeight := 27/nRes
oFone:lShowHint := .F.
oFone:lReadOnly := .F.
oFone:Align := 0
oFone:lVisibleControl := .T.
oFone:lWordWrap := .F.
oFone:lTransparent := .F.

oSayFax := TSAY():Create(oDlgPedido)
oSayFax:cName := "oSayFax"
oSayFax:cCaption := "Fax:"
oSayFax:nLeft := 130/nRes
oSayFax:nTop := 110 /nRes
oSayFax:nWidth := 43/nRes
oSayFax:nHeight := 15/nRes
oSayFax:lShowHint := .F.
oSayFax:lReadOnly := .F.
oSayFax:Align := 0
oSayFax:lVisibleControl := .T.
oSayFax:lWordWrap := .F.
oSayFax:lTransparent := .F.

oFax := TSAY():Create(oDlgPedido)
oFax:cName  := "oFax"
oFax:nLeft  := 160/nRes
oFax:nTop   := 110 /nRes
oFax:nWidth := 60/nRes
oFax:nHeight := 27/nRes
oFax:lShowHint := .F.
oFax:lReadOnly := .F.
oFax:Align := 0
oFax:lVisibleControl := .T.
oFax:lWordWrap := .F.
oFax:lTransparent := .F.

oSayContato := TSAY():Create(oDlgPedido)
oSayContato:cName := "oSayContato"
oSayContato:cCaption := "Contato:"
oSayContato:nLeft := 260/nRes
oSayContato:nTop := 110 /nRes
oSayContato:nWidth := 43/nRes
oSayContato:nHeight := 15/nRes
oSayContato:lShowHint := .F.
oSayContato:lReadOnly := .F.
oSayContato:Align := 0
oSayContato:lVisibleControl := .T.
oSayContato:lWordWrap := .F.
oSayContato:lTransparent := .F.

oContato := TSAY():Create(oDlgPedido)
oContato:cName  := "oContato"
oContato:nLeft  := 310/nRes
oContato:nTop   := 110 /nRes
oContato:nWidth := 100/nRes
oContato:nHeight := 27/nRes
oFax:lShowHint := .F.
oFax:lReadOnly := .F.
oFax:Align := 0
oFax:lVisibleControl := .T.
oFax:lWordWrap := .F.
oFax:lTransparent := .F.

oSayCNPJ := TSAY():Create(oDlgPedido)
oSayCNPJ:cName := "oSayCNPJ"
oSayCNPJ:cCaption := "CNPJ/CPF:"
oSayCNPJ:nLeft := 460/nRes
oSayCNPJ:nTop := 110 /nRes
oSayCNPJ:nWidth := 70/nRes
oSayCNPJ:nHeight := 15/nRes
oSayCNPJ:lShowHint := .F.
oSayCNPJ:lReadOnly := .F.
oSayCNPJ:Align := 0
oSayCNPJ:lVisibleControl := .T.
oSayCNPJ:lWordWrap := .F.
oSayCNPJ:lTransparent := .F.

oCNPJ := TSAY():Create(oDlgPedido)
oCNPJ:cName  := "oCNPJ"
oCNPJ:nLeft  := 530/nRes
oCNPJ:nTop   := 110 /nRes
oCNPJ:nWidth := 110/nRes
oCNPJ:nHeight := 27/nRes
oCNPJ:lShowHint := .F.
oCNPJ:lReadOnly := .F.
oCNPJ:Align := 0
oCNPJ:lVisibleControl := .T.
oCNPJ:lWordWrap := .F.
oCNPJ:lTransparent := .F.

oSayINSC := TSAY():Create(oDlgPedido)
oSayINSC:cName := "oSayINSC"
oSayINSC:cCaption := "Insc.Est: "
oSayINSC:nLeft := 640/nRes
oSayINSC:nTop := 110 /nRes
oSayINSC:nWidth := 50/nRes
oSayINSC:nHeight := 15/nRes
oSayINSC:lShowHint := .F.
oSayINSC:lReadOnly := .F.
oSayINSC:Align := 0
oSayINSC:lVisibleControl := .T.
oSayINSC:lWordWrap := .F.
oSayINSC:lTransparent := .F.

oINSC := TSAY():Create(oDlgPedido)
oINSC:cName  := "oINSC"
oINSC:nLeft  := 695/nRes
oINSC:nTop   := 110 /nRes
oINSC:nWidth := 100/nRes
oINSC:nHeight := 27/nRes
oINSC:lShowHint := .F.
oINSC:lReadOnly := .F.
oINSC:Align := 0
oINSC:lVisibleControl := .T.
oINSC:lWordWrap := .F.
oINSC:lTransparent := .F.

oSayEnd := TSAY():Create(oDlgPedido)
oSayEnd:cName := "oSayEnd"
oSayEnd:cCaption := "Endereco:"
oSayEnd:nLeft := 18/nRes
oSayEnd:nTop := 140 /nRes
oSayEnd:nWidth := 70/nRes //50
oSayEnd:nHeight := 15/nRes
oSayEnd:lShowHint := .F.
oSayEnd:lReadOnly := .F.
oSayEnd:Align := 0
oSayEnd:lVisibleControl := .T.
oSayEnd:lWordWrap := .F.
oSayEnd:lTransparent := .F.

oEndereco := TSAY():Create(oDlgPedido)
oEndereco:cName  := "oEndereco"
oEndereco:nLeft  := 90/nRes
oEndereco:nTop   := 140 /nRes
oEndereco:nWidth := 300/nRes
oEndereco:nHeight := 27/nRes
oEndereco:lShowHint := .F.
oEndereco:lReadOnly := .F.
oEndereco:Align := 0
oEndereco:lVisibleControl := .T.
oEndereco:lWordWrap := .F.
oEndereco:lTransparent := .F.

oSayBairro := TSAY():Create(oDlgPedido)
oSayBairro:cName := "oSayBairro"
oSayBairro:cCaption := "Bairro:"
oSayBairro:nLeft := 460/nRes
oSayBairro:nTop := 140 /nRes
oSayBairro:nWidth := 43/nRes
oSayBairro:nHeight := 15/nRes
oSayBairro:lShowHint := .F.
oSayBairro:lReadOnly := .F.
oSayBairro:Align := 0
oSayBairro:lVisibleControl := .T.
oSayBairro:lWordWrap := .F.
oSayBairro:lTransparent := .F.

oBairro := TSAY():Create(oDlgPedido)
oBairro:cName  := "oBairro"
oBairro:nLeft  := 510/nRes
oBairro:nTop   := 140 /nRes
oBairro:nWidth := 200/nRes
oBairro:nHeight := 27/nRes
oBairro:lShowHint := .F.
oBairro:lReadOnly := .F.
oBairro:Align := 0
oBairro:lVisibleControl := .T.
oBairro:lWordWrap := .F.
oBairro:lTransparent := .F.

oSayMun := TSAY():Create(oDlgPedido)
oSayMun:cName := "oSayMun"
oSayMun:cCaption := "Municipio:"
oSayMun:nLeft := 18/nRes
oSayMun:nTop := 160 /nRes
oSayMun:nWidth := 70/nRes
oSayMun:nHeight := 15/nRes
oSayMun:lShowHint := .F.
oSayMun:lReadOnly := .F.
oSayMun:Align := 0
oSayMun:lVisibleControl := .T.
oSayMun:lWordWrap := .F.
oSayMun:lTransparent := .F.

oMunicipio := TSAY():Create(oDlgPedido)
oMunicipio:cName  := "oMunicipio"
oMunicipio:nLeft  := 90/nRes
oMunicipio:nTop   := 160 /nRes
oMunicipio:nWidth := 200/nRes
oMunicipio:nHeight := 27/nRes
oMunicipio:lShowHint := .F.
oMunicipio:lReadOnly := .F.
oMunicipio:Align := 0
oMunicipio:lVisibleControl := .T.
oMunicipio:lWordWrap := .F.
oMunicipio:lTransparent := .F.

oSayEst := TSAY():Create(oDlgPedido)
oSayEst:cName := "oSayEst"
oSayEst:cCaption := "Estado: "
oSayEst:nLeft := 460/nRes
oSayEst:nTop := 160 /nRes
oSayEst:nWidth := 50/nRes
oSayEst:nHeight := 15/nRes
oSayEst:lShowHint := .F.
oSayEst:lReadOnly := .F.
oSayEst:Align := 0
oSayEst:lVisibleControl := .T.
oSayEst:lWordWrap := .F.
oSayEst:lTransparent := .F.

oEstado := TSAY():Create(oDlgPedido)
oEstado:cName  := "oEstado"
oEstado:nLeft  := 510/nRes
oEstado:nTop   := 160 /nRes
oEstado:nWidth := 100/nRes
oEstado:nHeight := 27/nRes
oEstado:lShowHint := .F.
oEstado:lReadOnly := .F.
oEstado:Align := 0
oEstado:lVisibleControl := .T.
oEstado:lWordWrap := .F.
oEstado:lTransparent := .F.

oSayCEP := TSAY():Create(oDlgPedido)
oSayCEP:cName := "oSayCEP"
oSayCEP:cCaption := "Cep:"
oSayCEP:nLeft := 18/nRes
oSayCEP:nTop := 180 /nRes
oSayCEP:nWidth := 43/nRes
oSayCEP:nHeight := 15/nRes
oSayCEP:lShowHint := .F.
oSayCEP:lReadOnly := .F.
oSayCEP:Align := 0
oSayCEP:lVisibleControl := .T.
oSayCEP:lWordWrap := .F.
oSayCEP:lTransparent := .F.

oCep := TSAY():Create(oDlgPedido)
oCep:cName  := "oCep"
oCep:nLeft  := 50/nRes
oCep:nTop   := 180 /nRes
oCep:nWidth := 200/nRes
oCep:nHeight := 27/nRes
oCep:lShowHint := .F.
oCep:lReadOnly := .F.
oCep:Align := 0
oCep:lVisibleControl := .T.
oCep:lWordWrap := .F.
oCep:lTransparent := .F.

oSayGrpEndC := TSAY():Create(oDlgPedido)
oSayGrpEndC:cName := "oSayGrpEndC"
oSayGrpEndC:cCaption := "Endereco de cobranca"
oSayGrpEndC:nLeft := 250/nRes
oSayGrpEndC:nTop := 190 /nRes
oSayGrpEndC:nWidth := 150/nRes
oSayGrpEndC:nHeight := 15/nRes
oSayGrpEndC:lShowHint := .F.
oSayGrpEndC:lReadOnly := .F.
oSayGrpEndC:Align := 0
oSayGrpEndC:lVisibleControl := .T.
oSayGrpEndC:lWordWrap := .F.
oSayGrpEndC:lTransparent := .F.

oSayEndC := TSAY():Create(oDlgPedido)
oSayEndC:cName := "oSayEndC"
oSayEndC:cCaption := "Endereco:"
oSayEndC:nLeft := 18/nRes
oSayEndC:nTop := 210 /nRes
oSayEndC:nWidth := 70/nRes
oSayEndC:nHeight := 15/nRes
oSayEndC:lShowHint := .F.
oSayEndC:lReadOnly := .F.
oSayEndC:Align := 0
oSayEndC:lVisibleControl := .T.
oSayEndC:lWordWrap := .F.
oSayEndC:lTransparent := .F.

oEndCob := TSAY():Create(oDlgPedido)
oEndCob:cName  := "oEndCob"
oEndCob:nLeft  := 90/nRes
oEndCob:nTop   := 210 /nRes
oEndCob:nWidth := 300/nRes
oEndCob:nHeight := 27/nRes
oEndCob:lShowHint := .F.
oEndCob:lReadOnly := .F.
oEndCob:Align := 0
oEndCob:lVisibleControl := .T.
oEndCob:lWordWrap := .F.
oEndCob:lTransparent := .F.

oSayBairroC := TSAY():Create(oDlgPedido)
oSayBairroC:cName := "oSayBairroC"
oSayBairroC:cCaption := "Bairro:"
oSayBairroC:nLeft := 460/nRes
oSayBairroC:nTop := 210 /nRes
oSayBairroC:nWidth := 43/nRes
oSayBairroC:nHeight := 15/nRes
oSayBairroC:lShowHint := .F.
oSayBairroC:lReadOnly := .F.
oSayBairroC:Align := 0
oSayBairroC:lVisibleControl := .T.
oSayBairroC:lWordWrap := .F.
oSayBairroC:lTransparent := .F.

oBairroC := TSAY():Create(oDlgPedido)
oBairroC:cName  := "oBairroC"
oBairroC:nLeft  := 510/nRes
oBairroC:nTop   := 210 /nRes
oBairroC:nWidth := 200/nRes
oBairroC:nHeight := 27/nRes
oBairroC:lShowHint := .F.
oBairroC:lReadOnly := .F.
oBairroC:Align := 0
oBairroC:lVisibleControl := .T.
oBairroC:lWordWrap := .F.
oBairroC:lTransparent := .F.

oSayMunC := TSAY():Create(oDlgPedido)
oSayMunC:cName := "oSayMunC"
oSayMunC:cCaption := "Municipio:"
oSayMunC:nLeft := 18/nRes
oSayMunC:nTop := 230 /nRes
oSayMunC:nWidth := 70/nRes
oSayMunC:nHeight := 15/nRes
oSayMunC:lShowHint := .F.
oSayMunC:lReadOnly := .F.
oSayMunC:Align := 0
oSayMunC:lVisibleControl := .T.
oSayMunC:lWordWrap := .F.
oSayMunC:lTransparent := .F.

oMunCob := TSAY():Create(oDlgPedido)
oMunCob:cName  := "oMunCob"
oMunCob:nLeft  := 90/nRes
oMunCob:nTop   := 230 /nRes
oMunCob:nWidth := 200/nRes
oMunCob:nHeight := 27/nRes
oMunCob:lShowHint := .F.
oMunCob:lReadOnly := .F.
oMunCob:Align := 0
oMunCob:lVisibleControl := .T.
oMunCob:lWordWrap := .F.
oMunCob:lTransparent := .F.

oSayEstC := TSAY():Create(oDlgPedido)
oSayEstC:cName := "oSayEstC"
oSayEstC:cCaption := "Estado: "
oSayEstC:nLeft := 460/nRes
oSayEstC:nTop := 230 /nRes
oSayEstC:nWidth := 50/nRes
oSayEstC:nHeight := 15/nRes
oSayEstC:lShowHint := .F.
oSayEstC:lReadOnly := .F.
oSayEstC:Align := 0
oSayEstC:lVisibleControl := .T.
oSayEstC:lWordWrap := .F.
oSayEstC:lTransparent := .F.

oEstadoC := TSAY():Create(oDlgPedido)
oEstadoC:cName  := "oEstadoC"
oEstadoC:nLeft  := 510/nRes
oEstadoC:nTop   := 230 /nRes
oEstadoC:nWidth := 100/nRes
oEstadoC:nHeight := 27/nRes
oEstadoC:lShowHint := .F.
oEstadoC:lReadOnly := .F.
oEstadoC:Align := 0
oEstadoC:lVisibleControl := .T.
oEstadoC:lWordWrap := .F.
oEstadoC:lTransparent := .F.

oSayCEPC := TSAY():Create(oDlgPedido)
oSayCEPC:cName := "oSayCEPC"
oSayCEPC:cCaption := "Cep:"
oSayCEPC:nLeft := 18/nRes
oSayCEPC:nTop := 250 /nRes
oSayCEPC:nWidth := 43/nRes
oSayCEPC:nHeight := 15/nRes
oSayCEPC:lShowHint := .F.
oSayCEPC:lReadOnly := .F.
oSayCEPC:Align := 0
oSayCEPC:lVisibleControl := .T.
oSayCEPC:lWordWrap := .F.
oSayCEPC:lTransparent := .F.

oCepC := TSAY():Create(oDlgPedido)
oCepC:cName  := "oCepC"
oCepC:nLeft  := 50/nRes
oCepC:nTop   := 250 /nRes
oCepC:nWidth := 200/nRes
oCepC:nHeight := 27/nRes
oCepC:lShowHint := .F.
oCepC:lReadOnly := .F.
oCepC:Align := 0
oCepC:lVisibleControl := .T.
oCepC:lWordWrap := .F.
oCepC:lTransparent := .F.

oSayGrpEndC := TSAY():Create(oDlgPedido)
oSayGrpEndC:cName := "oSayGrpEndC"
oSayGrpEndC:cCaption := "Endereco de entrega"
oSayGrpEndC:nLeft := 250/nRes
oSayGrpEndC:nTop := 260 /nRes
oSayGrpEndC:nWidth := 150/nRes
oSayGrpEndC:nHeight := 15/nRes
oSayGrpEndC:lShowHint := .F.
oSayGrpEndC:lReadOnly := .F.
oSayGrpEndC:Align := 0
oSayGrpEndC:lVisibleControl := .T.
oSayGrpEndC:lWordWrap := .F.
oSayGrpEndC:lTransparent := .F.

oSayEndE := TSAY():Create(oDlgPedido)
oSayEndE:cName := "oSayEndE"
oSayEndE:cCaption := "Endereco:"
oSayEndE:nLeft := 18/nRes
oSayEndE:nTop := 280 /nRes
oSayEndE:nWidth := 70/nRes
oSayEndE:nHeight := 15/nRes
oSayEndE:lShowHint := .F.
oSayEndE:lReadOnly := .F.
oSayEndE:Align := 0
oSayEndE:lVisibleControl := .T.
oSayEndE:lWordWrap := .F.
oSayEndE:lTransparent := .F.

oEndEnt := TSAY():Create(oDlgPedido)
oEndEnt:cName  := "oEndEnt"
oEndEnt:nLeft  := 90/nRes
oEndEnt:nTop   := 280 /nRes
oEndEnt:nWidth := 300/nRes
oEndEnt:nHeight := 27/nRes
oEndEnt:lShowHint := .F.
oEndEnt:lReadOnly := .F.
oEndEnt:Align := 0
oEndEnt:lVisibleControl := .T.
oEndEnt:lWordWrap := .F.
oEndEnt:lTransparent := .F.

oSayBairroE := TSAY():Create(oDlgPedido)
oSayBairroE:cName := "oSayBairroE"
oSayBairroE:cCaption := "Bairro:"
oSayBairroE:nLeft := 460/nRes
oSayBairroE:nTop := 280 /nRes
oSayBairroE:nWidth := 43/nRes
oSayBairroE:nHeight := 15/nRes
oSayBairroE:lShowHint := .F.
oSayBairroE:lReadOnly := .F.
oSayBairroE:Align := 0
oSayBairroE:lVisibleControl := .T.
oSayBairroE:lWordWrap := .F.
oSayBairroE:lTransparent := .F.

oBairroE := TSAY():Create(oDlgPedido)
oBairroE:cName  := "oBairroE"
oBairroE:nLeft  := 510/nRes
oBairroE:nTop   := 280 /nRes
oBairroE:nWidth := 200/nRes
oBairroE:nHeight := 27/nRes
oBairroE:lShowHint := .F.
oBairroE:lReadOnly := .F.
oBairroE:Align := 0
oBairroE:lVisibleControl := .T.
oBairroE:lWordWrap := .F.
oBairroE:lTransparent := .F.

oSayMunE := TSAY():Create(oDlgPedido)
oSayMunE:cName := "oSayMunE"
oSayMunE:cCaption := "Municipio:"
oSayMunE:nLeft := 18/nRes
oSayMunE:nTop := 300 /nRes
oSayMunE:nWidth := 70/nRes
oSayMunE:nHeight := 15/nRes
oSayMunE:lShowHint := .F.
oSayMunE:lReadOnly := .F.
oSayMunE:Align := 0
oSayMunE:lVisibleControl := .T.
oSayMunE:lWordWrap := .F.
oSayMunE:lTransparent := .F.

oMunEnt := TSAY():Create(oDlgPedido)
oMunEnt:cName  := "oMunEnt"
oMunEnt:nLeft  := 90/nRes
oMunEnt:nTop   := 300 /nRes
oMunEnt:nWidth := 200/nRes
oMunEnt:nHeight := 27/nRes
oMunEnt:lShowHint := .F.
oMunEnt:lReadOnly := .F.
oMunEnt:Align := 0
oMunEnt:lVisibleControl := .T.
oMunEnt:lWordWrap := .F.
oMunEnt:lTransparent := .F.

oSayEstE := TSAY():Create(oDlgPedido)
oSayEstE:cName := "oSayEstE"
oSayEstE:cCaption := "Estado: "
oSayEstE:nLeft := 460/nRes
oSayEstE:nTop := 300 /nRes
oSayEstE:nWidth := 50/nRes
oSayEstE:nHeight := 15/nRes
oSayEstE:lShowHint := .F.
oSayEstE:lReadOnly := .F.
oSayEstE:Align := 0
oSayEstE:lVisibleControl := .T.
oSayEstE:lWordWrap := .F.
oSayEstE:lTransparent := .F.

oEstadoE := TSAY():Create(oDlgPedido)
oEstadoE:cName  := "oEstadoE"
oEstadoE:nLeft  := 510/nRes
oEstadoE:nTop   := 300 /nRes
oEstadoE:nWidth := 100/nRes
oEstadoE:nHeight := 27/nRes
oEstadoE:lShowHint := .F.
oEstadoE:lReadOnly := .F.
oEstadoE:Align := 0
oEstadoE:lVisibleControl := .T.
oEstadoE:lWordWrap := .F.
oEstadoE:lTransparent := .F.

oSayCEPE := TSAY():Create(oDlgPedido)
oSayCEPE:cName := "oSayCEPE"
oSayCEPE:cCaption := "Cep:"
oSayCEPE:nLeft := 18/nRes
oSayCEPE:nTop := 320 /nRes
oSayCEPE:nWidth := 43/nRes
oSayCEPE:nHeight := 15/nRes
oSayCEPE:lShowHint := .F.
oSayCEPE:lReadOnly := .F.
oSayCEPE:Align := 0
oSayCEPE:lVisibleControl := .T.
oSayCEPE:lWordWrap := .F.
oSayCEPE:lTransparent := .F.

oCepE := TSAY():Create(oDlgPedido)
oCepE:cName  := "oCepE"
oCepE:nLeft  := 50/nRes
oCepE:nTop   := 320 /nRes
oCepE:nWidth := 200/nRes
oCepE:nHeight := 15/nRes
oCepE:lShowHint := .F.
oCepE:lReadOnly := .F.
oCepE:Align := 0
oCepE:lVisibleControl := .T.
oCepE:lWordWrap := .F.
oCepE:lTransparent := .F.

oSayRepres := TSAY():Create(oDlgPedido)
oSayRepres:cName := "oSayRepres"
oSayRepres:cCaption := "Representante:"
oSayRepres:nLeft := 460/nRes
oSayRepres:nTop := 320 /nRes
oSayRepres:nWidth := 120/nRes
oSayRepres:nHeight := 15/nRes
oSayRepres:lShowHint := .F.
oSayRepres:lReadOnly := .F.
oSayRepres:Align := 0
oSayRepres:lVisibleControl := .T.
oSayRepres:lWordWrap := .F.
oSayRepres:lTransparent := .F.

oRepresen := TSAY():Create(oDlgPedido)
oRepresen:cName  := "oRepresen"
oRepresen:nLeft  := 560/nRes
oRepresen:nTop   := 320 /nRes
oRepresen:nWidth := 100/nRes
oRepresen:nHeight := 15/nRes
oRepresen:lShowHint := .F.
oRepresen:lReadOnly := .F.
oRepresen:Align := 0
oRepresen:lVisibleControl := .T.
oRepresen:lWordWrap := .F.
oRepresen:lTransparent := .F.

oPriori := TSAY():Create(oDlgPedido)
oPriori:cName  := "oPriori"
oPriori:nLeft  := 250/nRes
oPriori:nTop   := 320 /nRes
oPriori:nWidth := 100/nRes
oPriori:nHeight := 15/nRes
oPriori:lShowHint := .F.
oPriori:lReadOnly := .F.
oPriori:Align := 0
oPriori:lVisibleControl := .T.
oPriori:lWordWrap := .F.
oPriori:lTransparent := .F.

//Grupo Dados do Pedido
oGrpPedido := TGROUP():Create(oDlgPedido)
oGrpPedido:cName := "oGrpPedido"
oGrpPedido:cCaption := "Dados do Pedido"
oGrpPedido:nLeft := 9/nRes
oGrpPedido:nTop   := 360/nRes
oGrpPedido:nWidth := 791/nRes
oGrpPedido:nHeight := 280/nRes
oGrpPedido:lShowHint := .F.
oGrpPedido:lReadOnly := .F.
oGrpPedido:Align := 0
oGrpPedido:lVisibleControl := .T.

oSayValPed := TSAY():Create(oDlgPedido)
oSayValPed:cName := "oSayValPed"
oSayValPed:cCaption := "Valor do Pedido:"
oSayValPed:nLeft := 18/nRes
oSayValPed:nTop := 370 /nRes
oSayValPed:nWidth := 130/nRes
oSayValPed:nHeight := 15/nRes
oSayValPed:lShowHint := .F.
oSayValPed:lReadOnly := .F.
oSayValPed:Align := 0
oSayValPed:lVisibleControl := .T.
oSayValPed:lWordWrap := .F.
oSayValPed:lTransparent := .F.

oVlrPedido := TGET():Create(oDlgPedido)
oVlrPedido:cName := "oVlrPedido"
oVlrPedido:nLeft := 150/nRes
oVlrPedido:nTop := 370/nRes
oVlrPedido:nWidth := 100/nRes
oVlrPedido:nHeight := 21/nRes
oVlrPedido:lShowHint := .F.
oVlrPedido:lReadOnly := .T.
oVlrPedido:Align := 0
oVlrPedido:cVariable := "nTot_Ped"
oVlrPedido:bSetGet := {|u| If(PCount()>0,nTot_Ped:=u,nTot_Ped) }
oVlrPedido:lVisibleControl := .T.
oVlrPedido:lPassword := .F.
oVlrPedido:lHasButton := .F.
oVlrPedido:Picture := "@E 999,999.99"

oSayDtPed := TSAY():Create(oDlgPedido)
oSayDtPed:cName := "oSayDtPed"
oSayDtPed:cCaption := "Data do Pedido:"
oSayDtPed:nLeft := 470/nRes
oSayDtPed:nTop := 370 /nRes
oSayDtPed:nWidth := 100/nRes
oSayDtPed:nHeight := 15/nRes
oSayDtPed:lShowHint := .F.
oSayDtPed:lReadOnly := .F.
oSayDtPed:Align := 0
oSayDtPed:lVisibleControl := .T.
oSayDtPed:lWordWrap := .F.
oSayDtPed:lTransparent := .F.

oDtPedido := TGET():Create(oDlgPedido)
oDtPedido:cName := "oDtPedido"
oDtPedido:nLeft := 600/nRes
oDtPedido:nTop := 370/nRes
oDtPedido:nWidth := 100/nRes
oDtPedido:nHeight := 21/nRes
oDtPedido:lShowHint := .F.
oDtPedido:lReadOnly := .T.
oDtPedido:Align := 0
oDtPedido:cVariable := "dDtPedido"
oDtPedido:bSetGet := {|u| If(PCount()>0,dDtPedido:=u,dDtPedido) }
oDtPedido:lVisibleControl := .T.
oDtPedido:lPassword := .F.
oDtPedido:lHasButton := .F.
oDtPedido:Picture := "@D"

oSayValQrb := TSAY():Create(oDlgPedido)
oSayValQrb:cName := "oSayValQrb"
oSayValQrb:cCaption := "Valor da Quebra:"
oSayValQrb:nLeft := 18/nRes
oSayValQrb:nTop := 390 /nRes
oSayValQrb:nWidth := 130/nRes
oSayValQrb:nHeight := 15/nRes
oSayValQrb:lShowHint := .F.
oSayValQrb:lReadOnly := .F.
oSayValQrb:Align := 0
oSayValQrb:lVisibleControl := .T.
oSayValQrb:lWordWrap := .F.
oSayValQrb:lTransparent := .F.

oVlrQuebra := TGET():Create(oDlgPedido)
oVlrQuebra:cName := "oVlrQuebra"
oVlrQuebra:nLeft := 150/nRes
oVlrQuebra:nTop := 390/nRes
oVlrQuebra:nWidth := 100/nRes
oVlrQuebra:nHeight := 21/nRes
oVlrQuebra:lShowHint := .F.
oVlrQuebra:lReadOnly := .T.
oVlrQuebra:Align := 0
oVlrQuebra:cVariable := "nTot_Qbr"
oVlrQuebra:bSetGet := {|u| If(PCount()>0,nTot_Qbr:=u,nTot_Qbr) }
oVlrQuebra:lVisibleControl := .T.
oVlrQuebra:lPassword := .F.
oVlrQuebra:lHasButton := .F.
oVlrQuebra:Picture := "@E 999,999.99"

oSayCodBar := TSAY():Create(oDlgPedido)
oSayCodBar:cName := "oSayCodBar"
oSayCodBar:cCaption := "Cod. de Barras:"
oSayCodBar:nLeft := 280/nRes
oSayCodBar:nTop := 390 /nRes
oSayCodBar:nWidth := 130/nRes
oSayCodBar:nHeight := 15/nRes
oSayCodBar:lShowHint := .F.
oSayCodBar:lReadOnly := .F.
oSayCodBar:Align := 0
oSayCodBar:lVisibleControl := .T.
oSayCodBar:lWordWrap := .F.
oSayCodBar:lTransparent := .F.

oCodBar := TGET():Create(oDlgPedido)
oCodBar:cName := "oCodBar"
oCodBar:nLeft := 370/nRes
oCodBar:nTop := 390/nRes
oCodBar:nWidth := 30/nRes
oCodBar:nHeight := 21/nRes
oCodBar:lShowHint := .F.
oCodBar:lReadOnly := .T.
oCodBar:Align := 0
oCodBar:cVariable := "cCodBar"
oCodBar:bSetGet := {|u| If(PCount()>0,cCodBar:=u,cCodBar) }
oCodBar:lVisibleControl := .T.
oCodBar:lPassword := .F.
oCodBar:lHasButton := .F.
oCodBar:Picture := "@!"

oSayEntVen := TSAY():Create(oDlgPedido)
oSayEntVen:cName := "oSayEntVen"
oSayEntVen:cCaption := "Entrada em Vendas:"
oSayEntVen:nLeft := 470/nRes
oSayEntVen:nTop := 390 /nRes
oSayEntVen:nWidth := 100/nRes
oSayEntVen:nHeight := 15/nRes
oSayEntVen:lShowHint := .F.
oSayEntVen:lReadOnly := .F.
oSayEntVen:Align := 0
oSayEntVen:lVisibleControl := .T.
oSayEntVen:lWordWrap := .F.
oSayEntVen:lTransparent := .F.

oDtEntVen := TGET():Create(oDlgPedido)
oDtEntVen:cName := "oDtEntVen"
oDtEntVen:nLeft := 600/nRes
oDtEntVen:nTop := 390/nRes
oDtEntVen:nWidth := 100/nRes
oDtEntVen:nHeight := 21/nRes
oDtEntVen:lShowHint := .F.
oDtEntVen:lReadOnly := .T.
oDtEntVen:Align := 0
oDtEntVen:cVariable := "dDtEntVen"
oDtEntVen:bSetGet := {|u| If(PCount()>0,dDtEntVen:=u,dDtEntVen) }
oDtEntVen:lVisibleControl := .T.
oDtEntVen:lPassword := .F.
oDtEntVen:lHasButton := .F.
oDtEntVen:Picture := "@D"

oSayValFrt := TSAY():Create(oDlgPedido)
oSayValFrt:cName := "oSayValFrt"
oSayValFrt:cCaption := "Valor do Frete:"
oSayValFrt:nLeft := 18/nRes
oSayValFrt:nTop := 410 /nRes
oSayValFrt:nWidth := 100/nRes
oSayValFrt:nHeight := 15/nRes
oSayValFrt:lShowHint := .F.
oSayValFrt:lReadOnly := .F.
oSayValFrt:Align := 0
oSayValFrt:lVisibleControl := .T.
oSayValFrt:lWordWrap := .F.
oSayValFrt:lTransparent := .F.

oVlrFrete := TGET():Create(oDlgPedido)
oVlrFrete:cName := "oVlrFrete"
oVlrFrete:nLeft := 150/nRes
oVlrFrete:nTop := 410/nRes
oVlrFrete:nWidth := 100/nRes
oVlrFrete:nHeight := 21/nRes
oVlrFrete:lShowHint := .F.
oVlrFrete:lReadOnly := .T.
oVlrFrete:Align := 0
oVlrFrete:cVariable := "nTot_Frt"
oVlrFrete:bSetGet := {|u| If(PCount()>0,nTot_Frt:=u,nTot_Frt) }
oVlrFrete:lVisibleControl := .T.
oVlrFrete:lPassword := .F.
oVlrFrete:lHasButton := .F.
oVlrFrete:Picture := "@E 999,999.99"

oSayNota := TSAY():Create(oDlgPedido)
oSayNota:cName := "oSayNota"
oSayNota:cCaption := "N.F.:"
oSayNota:nLeft := 300/nRes
oSayNota:nTop := 410 /nRes
oSayNota:nWidth := 130/nRes
oSayNota:nHeight := 15/nRes
oSayNota:lShowHint := .F.
oSayNota:lReadOnly := .F.
oSayNota:Align := 0
oSayNota:lVisibleControl := .T.
oSayNota:lWordWrap := .F.
oSayNota:lTransparent := .F.

oNota := TGET():Create(oDlgPedido)
oNota:cName := "oNota"
oNota:nLeft := 370/nRes
oNota:nTop := 410/nRes
oNota:nWidth := 50/nRes
oNota:nHeight := 21/nRes
oNota:lShowHint := .F.
oNota:lReadOnly := .T.
oNota:Align := 0
oNota:cVariable := "cNota"
oNota:bSetGet := {|u| If(PCount()>0,cNota:=u,cNota) }
oNota:lVisibleControl := .T.
oNota:lPassword := .F.
oNota:lHasButton := .F.
oNota:Picture := "@!"

oSayDtSaida := TSAY():Create(oDlgPedido)
oSayDtSaida:cName := "oSayDtSaida"
oSayDtSaida:cCaption := "Data de Saida:"
oSayDtSaida:nLeft := 470/nRes
oSayDtSaida:nTop := 410 /nRes
oSayDtSaida:nWidth := 100/nRes
oSayDtSaida:nHeight := 15/nRes
oSayDtSaida:lShowHint := .F.
oSayDtSaida:lReadOnly := .F.
oSayDtSaida:Align := 0
oSayDtSaida:lVisibleControl := .T.
oSayDtSaida:lWordWrap := .F.
oSayDtSaida:lTransparent := .F.

oDtSaida := TGET():Create(oDlgPedido)
oDtSaida:cName := "oDtSaida"
oDtSaida:nLeft := 600/nRes
oDtSaida:nTop := 410/nRes
oDtSaida:nWidth := 100/nRes
oDtSaida:nHeight := 21/nRes
oDtSaida:lShowHint := .F.
oDtSaida:lReadOnly := .T.
oDtSaida:Align := 0
oDtSaida:cVariable := "dDtSaida"
oDtSaida:bSetGet := {|u| If(PCount()>0,dDtSaida:=u,dDtSaida) }
oDtSaida:lVisibleControl := .T.
oDtSaida:lPassword := .F.
oDtSaida:lHasButton := .F.
oDtSaida:Picture := "@D"

oSayTotNf := TSAY():Create(oDlgPedido)
oSayTotNf:cName := "oSayTotNf"
oSayTotNf:cCaption := "Total da N.F.:"
oSayTotNf:nLeft := 18/nRes
oSayTotNf:nTop := 430 /nRes
oSayTotNf:nWidth := 100/nRes
oSayTotNf:nHeight := 15/nRes
oSayTotNf:lShowHint := .F.
oSayTotNf:lReadOnly := .F.
oSayTotNf:Align := 0
oSayTotNf:lVisibleControl := .T.
oSayTotNf:lWordWrap := .F.
oSayTotNf:lTransparent := .F.

oVlrTotNf := TGET():Create(oDlgPedido)
oVlrTotNf:cName := "oVlrTotNf"
oVlrTotNf:nLeft := 150/nRes
oVlrTotNf:nTop := 430/nRes
oVlrTotNf:nWidth := 100/nRes
oVlrTotNf:nHeight := 21/nRes
oVlrTotNf:lShowHint := .F.
oVlrTotNf:lReadOnly := .T.
oVlrTotNf:Align := 0
oVlrTotNf:cVariable := "nTot_Fat"
oVlrTotNf:bSetGet := {|u| If(PCount()>0,nTot_Fat:=u,nTot_Fat) }
oVlrTotNf:lVisibleControl := .T.
oVlrTotNf:lPassword := .F.
oVlrTotNf:lHasButton := .F.
oVlrTotNf:Picture := "@E 999,999.99"

oSayDigit := TSAY():Create(oDlgPedido)
oSayDigit:cName := "oSayDigit"
oSayDigit:cCaption := "Digitador:"
oSayDigit:nLeft := 470/nRes
oSayDigit:nTop := 430 /nRes
oSayDigit:nWidth := 100/nRes
oSayDigit:nHeight := 15/nRes
oSayDigit:lShowHint := .F.
oSayDigit:lReadOnly := .F.
oSayDigit:Align := 0
oSayDigit:lVisibleControl := .T.
oSayDigit:lWordWrap := .F.
oSayDigit:lTransparent := .F.

oDigitador := TGET():Create(oDlgPedido)
oDigitador:cName := "oDigitador"
oDigitador:nLeft := 600/nRes
oDigitador:nTop := 430/nRes
oDigitador:nWidth := 150/nRes
oDigitador:nHeight := 21/nRes
oDigitador:lShowHint := .F.
oDigitador:lReadOnly := .T.
oDigitador:Align := 0
oDigitador:cVariable := "cDigitador"
oDigitador:bSetGet := {|u| If(PCount()>0,cDigitador:=u,cDigitador) }
oDigitador:lVisibleControl := .T.
oDigitador:lPassword := .F.
oDigitador:lHasButton := .F.
oDigitador:Picture := "@!"

oSayTabela := TSAY():Create(oDlgPedido)
oSayTabela:cName := "oSayTabela"
oSayTabela:cCaption := "Tabela:"
oSayTabela:nLeft := 18/nRes
oSayTabela:nTop := 450 /nRes
oSayTabela:nWidth := 100/nRes
oSayTabela:nHeight := 15/nRes
oSayTabela:lShowHint := .F.
oSayTabela:lReadOnly := .F.
oSayTabela:Align := 0
oSayTabela:lVisibleControl := .T.
oSayTabela:lWordWrap := .F.
oSayTabela:lTransparent := .F.

oTabela := TGET():Create(oDlgPedido)
oTabela:cName := "oTabela"
oTabela:nLeft := 150/nRes
oTabela:nTop := 450/nRes
oTabela:nWidth := 120/nRes
oTabela:nHeight := 21/nRes
oTabela:lShowHint := .F.
oTabela:lReadOnly := .T.
oTabela:Align := 0
oTabela:cVariable := "cTABELA"
oTabela:bSetGet := {|u| If(PCount()>0,cTabela:=u,cTabela) }
oTabela:lVisibleControl := .T.
oTabela:lPassword := .F.
oTabela:lHasButton := .F.
oTabela:Picture := "@!"

oSayTpFrt := TSAY():Create(oDlgPedido)
oSayTpFrt:cName := "oSayTpFrt"
oSayTpFrt:cCaption := "Tipo de Frete:"
oSayTpFrt:nLeft := 470/nRes
oSayTpFrt:nTop := 450 /nRes
oSayTpFrt:nWidth := 100/nRes
oSayTpFrt:nHeight := 15/nRes
oSayTpFrt:lShowHint := .F.
oSayTpFrt:lReadOnly := .F.
oSayTpFrt:Align := 0
oSayTpFrt:lVisibleControl := .T.
oSayTpFrt:lWordWrap := .F.
oSayTpFrt:lTransparent := .F.

oTipoFrt := TGET():Create(oDlgPedido)
oTipoFrt:cName := "oTipoFrt"
oTipoFrt:nLeft := 600/nRes
oTipoFrt:nTop := 450/nRes
oTipoFrt:nWidth := 100/nRes
oTipoFrt:nHeight := 21/nRes
oTipoFrt:lShowHint := .F.
oTipoFrt:lReadOnly := .T.
oTipoFrt:Align := 0
oTipoFrt:cVariable := "cTipoFrt"
oTipoFrt:bSetGet := {|u| If(PCount()>0,cTipoFrt:=u,cTipoFrt) }
oTipoFrt:lVisibleControl := .T.
oTipoFrt:lPassword := .F.
oTipoFrt:lHasButton := .F.
oTipoFrt:Picture := "@!"

oSayCond := TSAY():Create(oDlgPedido)
oSayCond:cName := "oSayCond"
oSayCond:cCaption := "Condicao Pag.:"
oSayCond:nLeft := 18/nRes
oSayCond:nTop := 470 /nRes
oSayCond:nWidth := 50/nRes
oSayCond:nHeight := 15/nRes
oSayCond:lShowHint := .F.
oSayCond:lReadOnly := .F.
oSayCond:Align := 0
oSayCond:lVisibleControl := .T.
oSayCond:lWordWrap := .F.
oSayCond:lTransparent := .F.

oCondPag := TGET():Create(oDlgPedido)
oCondPag:cName := "oCondPag"
oCondPag:nLeft := 150/nRes
oCondPag:nTop := 470/nRes
oCondPag:nWidth := 150/nRes
oCondPag:nHeight := 21/nRes
oCondPag:lShowHint := .F.
oCondPag:lReadOnly := .T.
oCondPag:Align := 0
oCondPag:cVariable := "cCondPag"
oCondPag:bSetGet := {|u| If(PCount()>0,cCondPag:=u,cCondPag) }
oCondPag:lVisibleControl := .T.
oCondPag:lPassword := .F.
oCondPag:lHasButton := .F.
oCondPag:Picture := "@!"

oSayTransp := TSAY():Create(oDlgPedido)
oSayTransp:cName := "oSayTransp"
oSayTransp:cCaption := "Transportadora:"
oSayTransp:nLeft := 470/nRes
oSayTransp:nTop := 470 /nRes
oSayTransp:nWidth := 100/nRes
oSayTransp:nHeight := 15/nRes
oSayTransp:lShowHint := .F.
oSayTransp:lReadOnly := .F.
oSayTransp:Align := 0
oSayTransp:lVisibleControl := .T.
oSayTransp:lWordWrap := .F.
oSayTransp:lTransparent := .F.

oTransp := TGET():Create(oDlgPedido)
oTransp:cName := "oTransp"
oTransp:nLeft := 600/nRes
oTransp:nTop := 470/nRes
oTransp:nWidth := 150/nRes
oTransp:nHeight := 21/nRes
oTransp:lShowHint := .F.
oTransp:lReadOnly := .T.
oTransp:Align := 0
oTransp:cVariable := "cTransp"
oTransp:bSetGet := {|u| If(PCount()>0,cTransp:=u,cTransp) }
oTransp:lVisibleControl := .T.
oTransp:lPassword := .F.
oTransp:lHasButton := .F.
oTransp:Picture := "@!"

oSayDescont := TSAY():Create(oDlgPedido)
oSayDescont:cName := "oSayDescont"
oSayDescont:cCaption := "Desconto:"
oSayDescont:nLeft := 18/nRes
oSayDescont:nTop := 490 /nRes
oSayDescont:nWidth := 100/nRes
oSayDescont:nHeight := 15/nRes
oSayDescont:lShowHint := .F.
oSayDescont:lReadOnly := .F.
oSayDescont:Align := 0
oSayDescont:lVisibleControl := .T.
oSayDescont:lWordWrap := .F.
oSayDescont:lTransparent := .F.

oDescont := TGET():Create(oDlgPedido)
oDescont:cName := "oDescont"
oDescont:nLeft := 150/nRes
oDescont:nTop := 490/nRes
oDescont:nWidth := 150/nRes
oDescont:nHeight := 21/nRes
oDescont:lShowHint := .F.
oDescont:lReadOnly := .T.
oDescont:Align := 0
oDescont:cVariable := "cDescont"
oDescont:bSetGet := {|u| If(PCount()>0,cDescont:=u,cDescont) }
oDescont:lVisibleControl := .T.
oDescont:lPassword := .F.
oDescont:lHasButton := .F.
oDescont:Picture := "@!"

oSayComis := TSAY():Create(oDlgPedido)
oSayComis:cName := "oSayComis"
oSayComis:cCaption := "% Comissao:"
oSayComis:nLeft := 470/nRes
oSayComis:nTop := 490 /nRes
oSayComis:nWidth := 100/nRes
oSayComis:nHeight := 15/nRes
oSayComis:lShowHint := .F.
oSayComis:lReadOnly := .F.
oSayComis:Align := 0
oSayComis:lVisibleControl := .T.
oSayComis:lWordWrap := .F.
oSayComis:lTransparent := .F.

oComis := TGET():Create(oDlgPedido)
oComis:cName := "oComis"
oComis:nLeft := 600/nRes
oComis:nTop := 490/nRes
oComis:nWidth := 50/nRes
oComis:nHeight := 21/nRes
oComis:lShowHint := .F.
oComis:lReadOnly := .T.
oComis:Align := 0
oComis:cVariable := "nComis"
oComis:bSetGet := {|u| If(PCount()>0,nComis:=u,nComis) }
oComis:lVisibleControl := .T.
oComis:lPassword := .F.
oComis:lHasButton := .F.
oComis:Picture := "@E 99.99"

oSayLicit := TSAY():Create(oDlgPedido)
oSayLicit:cName := "oSayLicit"
oSayLicit:cCaption := "LC:"
oSayLicit:nLeft := 18/nRes
oSayLicit:nTop := 510 /nRes
oSayLicit:nWidth := 100/nRes
oSayLicit:nHeight := 15/nRes
oSayLicit:lShowHint := .F.
oSayLicit:lReadOnly := .F.
oSayLicit:Align := 0
oSayLicit:lVisibleControl := .T.
oSayLicit:lWordWrap := .F.
oSayLicit:lTransparent := .F.

oLicit := TGET():Create(oDlgPedido)
oLicit:cName := "oLicit"
oLicit:nLeft := 150/nRes
oLicit:nTop := 510/nRes
oLicit:nWidth := 50/nRes
oLicit:nHeight := 21/nRes
oLicit:lShowHint := .F.
oLicit:lReadOnly := .T.
oLicit:Align := 0
oLicit:cVariable := "cLicit"
oLicit:bSetGet := {|u| If(PCount()>0,cLicit:=u,cLicit) }
oLicit:lVisibleControl := .T.
oLicit:lPassword := .F.
oLicit:lHasButton := .F.
oLicit:Picture := "@!"

oSaySepara := TSAY():Create(oDlgPedido)
oSaySepara:cName := "oSaySepara"
oSaySepara:cCaption := "Separador:"
oSaySepara:nLeft := 470/nRes
oSaySepara:nTop := 510 /nRes
oSaySepara:nWidth := 100/nRes
oSaySepara:nHeight := 15/nRes
oSaySepara:lShowHint := .F.
oSaySepara:lReadOnly := .F.
oSaySepara:Align := 0
oSaySepara:lVisibleControl := .T.
oSaySepara:lWordWrap := .F.
oSaySepara:lTransparent := .F.

oSepara := TCOMBOBOX():Create(oDlgPedido)
oSepara:cName := "oSepara"
oSepara:nLeft := 600/nRes
oSepara:nTop := 510/nRes
oSepara:nWidth := 150/nRes
oSepara:nHeight := 21/nRes
oSepara:lShowHint := .F.
oSepara:lReadOnly := .F.
oSepara:Align := 0
oSepara:cVariable := "cSepara"
oSepara:bSetGet := {|u| If(PCount()>0,cSepara:=u,cSepara) }
oSepara:lVisibleControl := .T.
oSepara:aItems := aSepara
oSepara:nAt := 0

/*
oSepara := TGET():Create(oDlgPedido)
oSepara:cName := "oSepara"
oSepara:nLeft := 600/nRes
oSepara:nTop := 510/nRes
oSepara:nWidth := 150/nRes
oSepara:nHeight := 21/nRes
oSepara:lShowHint := .F.
oSepara:lReadOnly := .T.
oSepara:Align := 0
oSepara:cVariable := "cSepara"
oSepara:bSetGet := {|u| If(PCount()>0,cSepara:=u,cSepara) }
oSepara:lVisibleControl := .T.
oSepara:lPassword := .F.
oSepara:lHasButton := .F.
oSepara:Picture := "@!"
*/

oSayPeso := TSAY():Create(oDlgPedido)
oSayPeso:cName := "oSayPeso"
oSayPeso:cCaption := "Peso / Volume:"
oSayPeso:nLeft := 18/nRes
oSayPeso:nTop := 530 /nRes
oSayPeso:nWidth := 100/nRes
oSayPeso:nHeight := 15/nRes
oSayPeso:lShowHint := .F.
oSayPeso:lReadOnly := .F.
oSayPeso:Align := 0
oSayPeso:lVisibleControl := .T.
oSayPeso:lWordWrap := .F.
oSayPeso:lTransparent := .F.

oPeso := TGET():Create(oDlgPedido)
oPeso:cName := "oPeso"
oPeso:nLeft := 150/nRes
oPeso:nTop := 530/nRes
oPeso:nWidth := 150/nRes
oPeso:nHeight := 21/nRes
oPeso:lShowHint := .F.
oPeso:lReadOnly := .T.
oPeso:Align := 0
oPeso:cVariable := "cPeso"
oPeso:bSetGet := {|u| If(PCount()>0,cPeso:=u,cPeso) }
oPeso:lVisibleControl := .T.
oPeso:lPassword := .F.
oPeso:lHasButton := .F.
oPeso:Picture := "@!"

oSayConfere := TSAY():Create(oDlgPedido)
oSayConfere:cName := "oSayConfere"
oSayConfere:cCaption := "Conferente:"
oSayConfere:nLeft := 470/nRes
oSayConfere:nTop := 530 /nRes
oSayConfere:nWidth := 100/nRes
oSayConfere:nHeight := 15/nRes
oSayConfere:lShowHint := .F.
oSayConfere:lReadOnly := .F.
oSayConfere:Align := 0
oSayConfere:lVisibleControl := .T.
oSayConfere:lWordWrap := .F.
oSayConfere:lTransparent := .F.

oConfere := TGET():Create(oDlgPedido)
oConfere:cName := "oConfere"
oConfere:nLeft := 600/nRes
oConfere:nTop := 530/nRes
oConfere:nWidth := 150/nRes
oConfere:nHeight := 21/nRes
oConfere:lShowHint := .F.
oConfere:lReadOnly := .T.
oConfere:Align := 0
oConfere:cVariable := "cConfere"
oConfere:bSetGet := {|u| If(PCount()>0,cConfere:=u,cConfere) }
oConfere:lVisibleControl := .T.
oConfere:lPassword := .F.
oConfere:lHasButton := .F.
oConfere:Picture := "@!"

oSayMensag := TSAY():Create(oDlgPedido)
oSayMensag:cName := "oSayMensag"
oSayMensag:cCaption := "Mensagem:"
oSayMensag:nLeft := 18/nRes
oSayMensag:nTop := 550 /nRes
oSayMensag:nWidth := 100/nRes
oSayMensag:nHeight := 15/nRes
oSayMensag:lShowHint := .F.
oSayMensag:lReadOnly := .F.
oSayMensag:Align := 0
oSayMensag:lVisibleControl := .T.
oSayMensag:lWordWrap := .F.
oSayMensag:lTransparent := .F.

oMensag1 := TGET():Create(oDlgPedido)
oMensag1:cName := "oMensag1"
oMensag1:nLeft := 150/nRes
oMensag1:nTop := 550/nRes
oMensag1:nWidth := 500/nRes
oMensag1:nHeight := 21/nRes
oMensag1:lShowHint := .F.
oMensag1:lReadOnly := .T.
oMensag1:Align := 0
oMensag1:cVariable := "cMensag1"
oMensag1:bSetGet := {|u| If(PCount()>0,cMensag1:=u,cMensag1) }
oMensag1:lVisibleControl := .T.
oMensag1:lPassword := .F.
oMensag1:lHasButton := .F.
oMensag1:Picture := "@!"

oMensag2 := TGET():Create(oDlgPedido)
oMensag2:cName := "oMensag2"
oMensag2:nLeft := 150/nRes
oMensag2:nTop := 570/nRes
oMensag2:nWidth := 500/nRes
oMensag2:nHeight := 21/nRes
oMensag2:lShowHint := .F.
oMensag2:lReadOnly := .T.
oMensag2:Align := 0
oMensag2:cVariable := "cMensag2"
oMensag2:bSetGet := {|u| If(PCount()>0,cMensag2:=u,cMensag2) }
oMensag2:lVisibleControl := .T.
oMensag2:lPassword := .F.
oMensag2:lHasButton := .F.
oMensag2:Picture := "@!"

if SC5->C5_CONDPAG='300' .and. !EMPTY(SC5->C5_DTLIBFA)
	oSayPag := TSAY():Create(oDlgPedido)
	oSayPag:cName := "oSayMensag"
	oSayPag:cCaption := "Pedido Pago em : "+dtoc(SC5->C5_DTLIBFA)
	oSayPag:nLeft := 18/nRes
	oSayPag:nTop := 600 /nRes
	oSayPag:nWidth := 500/nRes
	oSayPag:nHeight := 21/nRes
	oSayPag:lShowHint := .F.
	oSayPag:lReadOnly := .F.
	oSayPag:Align := 0
	oSayPag:lVisibleControl := .T.
	oSayPag:lWordWrap := .F.
	oSayPag:lTransparent := .F.
	oSayPag:SetFont( oFnt_b )
endif

//Botoes
BtnPedOri := TBUTTON():Create(oDlgPedido)
BtnPedOri:cName := "BtnPedOri"
BtnPedOri:cCaption := "Pedido Original"
BtnPedOri:nLeft := 850/nRes
BtnPedOri:nTop := 100/nRes
BtnPedOri:nWidth := 150/nRes
BtnPedOri:nHeight := 35/nRes
BtnPedOri:lShowHint := .F.
BtnPedOri:lReadOnly := .F.
BtnPedOri:Align := 0
BtnPedOri:lVisibleControl := .T.
BtnPedOri:bAction := { || PFAT31_ORI() }

BtnItensLib := TBUTTON():Create(oDlgPedido)
BtnItensLib:cName := "BtnItensLib"
BtnItensLib:cCaption := "Itens Liberados"
BtnItensLib:nLeft := 850/nRes
BtnItensLib:nTop := 140/nRes
BtnItensLib:nWidth := 150/nRes
BtnItensLib:nHeight := 35/nRes
BtnItensLib:lShowHint := .F.
BtnItensLib:lReadOnly := .F.
BtnItensLib:Align := 0
BtnItensLib:lVisibleControl := .T.
BtnItensLib:bAction := { || PFAT31_LIB() }

BtnQuebra := TBUTTON():Create(oDlgPedido)
BtnQuebra:cName := "BtnQuebra"
BtnQuebra:cCaption := "Quebra"
BtnQuebra:nLeft := 850/nRes
BtnQuebra:nTop := 180/nRes
BtnQuebra:nWidth := 150/nRes
BtnQuebra:nHeight := 35/nRes
BtnQuebra:lShowHint := .F.
BtnQuebra:lReadOnly := .F.
BtnQuebra:Align := 0
BtnQuebra:lVisibleControl := .T.
BtnQuebra:bAction := { || PFAT31_QBR() }

BtnItensFat := TBUTTON():Create(oDlgPedido)
BtnItensFat:cName := "BtnItensFat"
BtnItensFat:cCaption := "Itens Faturados"
BtnItensFat:nLeft := 850/nRes
BtnItensFat:nTop := 220/nRes
BtnItensFat:nWidth := 150/nRes
BtnItensFat:nHeight := 35/nRes
BtnItensFat:lShowHint := .F.
BtnItensFat:lReadOnly := .F.
BtnItensFat:Align := 0
BtnItensFat:lVisibleControl := .T.
BtnItensFat:bAction := { || PFAT31_FAT() }

BtnHorarios := TBUTTON():Create(oDlgPedido)
BtnHorarios:cName := "BtnHorarios"
BtnHorarios:cCaption := "Horarios"
BtnHorarios:nLeft := 850/nRes
BtnHorarios:nTop := 260/nRes
BtnHorarios:nWidth := 150/nRes
BtnHorarios:nHeight := 35/nRes
BtnHorarios:lShowHint := .F.
BtnHorarios:lReadOnly := .F.
BtnHorarios:Align := 0
BtnHorarios:lVisibleControl := .T.
BtnHorarios:bAction := { || PFAT31_HOR() }

BtnPendencias := TBUTTON():Create(oDlgPedido)
BtnPendencias:cName := "BtnPendencias"
BtnPendencias:cCaption := "Pendencias"
BtnPendencias:nLeft := 850/nRes
BtnPendencias:nTop := 300/nRes
BtnPendencias:nWidth := 150/nRes
BtnPendencias:nHeight := 35/nRes
BtnPendencias:lShowHint := .F.
BtnPendencias:lReadOnly := .F.
BtnPendencias:Align := 0
BtnPendencias:lVisibleControl := .T.
BtnPendencias:bAction := { || PFAT31_PEN() }

BtnNegocia := TBUTTON():Create(oDlgPedido)
BtnNegocia:cName := "BtnNegocia"
BtnNegocia:cCaption := "Negocia็ใo"
BtnNegocia:nLeft := 850/nRes
BtnNegocia:nTop := 340/nRes
BtnNegocia:nWidth := 150/nRes
BtnNegocia:nHeight := 35/nRes
BtnNegocia:lShowHint := .F.
BtnNegocia:lReadOnly := .F.
BtnNegocia:Align := 0
BtnNegocia:lVisibleControl := .T.
BtnNegocia:bAction := { || PFAT31_NEG() }
/*
BtnPedDup := TBUTTON():Create(oDlgPedido)
BtnPedDup:cName := "BtnPedDup"
BtnPedDup:cCaption := "Ped. Duplicado"
BtnPedDup:nLeft := 850/nRes
BtnPedDup:nTop := 380/nRes
BtnPedDup:nWidth := 150/nRes
BtnPedDup:nHeight := 35/nRes
BtnPedDup:lShowHint := .F.
BtnPedDup:lReadOnly := .F.
BtnPedDup:Align := 0
BtnPedDup:lVisibleControl := .T.
BtnPedDup:bAction := { || PFAT31_PDUP() }   // Pedidos Duplicados

BtnObserv := TBUTTON():Create(oDlgPedido)
BtnObserv:cName := "BtnObserv"
BtnObserv:cCaption := "Observacao"
BtnObserv:nLeft := 850/nRes
BtnObserv:nTop := 420/nRes
BtnObserv:nWidth := 150/nRes
BtnObserv:nHeight := 35/nRes
BtnObserv:lShowHint := .F.
BtnObserv:lReadOnly := .F.
BtnObserv:Align := 0
BtnObserv:lVisibleControl := .T.
BtnObserv:bAction := { || PFAT31_OBS() }   // Pedidos Duplicados
*/

//Atribui valores aos objetos

//Cor
oPedido  :nClrText  := CLR_HBLUE
oPriori  :nClrText  := CLR_HRED

//Fonte
oPedido  :SetFont( oFNT_1 )
oStatus  :SetFont( oFNT_1 )
oSayPed  :SetFont( oFNT_1 )
oPriori  :SetFont( oFNT_1 )

//Texto
oPedido	  :SetText( SC5->C5_NUM )
oCliente  :SetText(SC5->C5_CLIENTE + " - " + SUBSTR(SA1->A1_NOME,1,40))
oFantasia :SetText(SUBSTR(SA1->A1_NREDUZ,1,20))
oFone     :SetText(SA1->A1_TEL)
oFax      :SetText(SA1->A1_FAX)
oContato  :SetText(SA1->A1_CONTATO)
oCNPJ     :SetText(SA1->A1_CGC)
oINSC     :SetText(SA1->A1_INSCR)
oEndereco :SetText(SA1->A1_END)
oBairro   :SetText(SA1->A1_BAIRRO)
oMunicipio:SetText(SA1->A1_MUN)
oEstado   :SetText(SA1->A1_EST)
oCep      :SetText(SA1->A1_CEP,"@R 99999-999 ")
oEndCob   :SetText(SA1->A1_ENDCOB)
oBairroC  :SetText(SA1->A1_BAIRROC)
oMunCob   :SetText(SA1->A1_MUNC)
oEstadoC  :SetText(SA1->A1_ESTC)
oCepC     :SetText(SA1->A1_CEPC,"@R 99999-999 ")
oEndEnt   :SetText(SA1->A1_ENDENT)
oBairroE  :SetText(SA1->A1_BAIRROE)
oMunEnt   :SetText(SA1->A1_MUNE)
oEstadoE  :SetText(SA1->A1_ESTE)
oCepE     :SetText(SA1->A1_CEPE,"@R 99999-999 ")
oRepresen :SetText(SA3->A3_NREDUZ)
oPriori   :SetText(cPRIOR)

dDtPedido := SC5->C5_EMISSAO
dDtentVen := SC5->C5_EMISSAO //SC5->C5_DT_DIG
dDtSaida  := SC5->C5_ENTREG//SC5->C5_DTSAIDA
cDigitador:= ""//IIf(Left(SC5->C5_NUM,1)$"ADGPHVIQ",SC5->C5_ESPECI4,U_UserLG(SC5->C5_USERLGI))
cTransp   := SA4->A4_NREDUZ

//Valor
ObjectMethod( oVlrPedido , "SetText( nTot_Ped )" )
ObjectMethod( oVlrTotNf  , "SetText( nTot_Fat )" )
ObjectMethod( oDigitador , "SetText( cDigitador )" )
ObjectMethod( oTipoFrt   , "SetText( cTipoFrt )" )
ObjectMethod( oTransp    , "SetText( cTransp )" )
ObjectMethod( oComis     , "SetText( nComis )" )

ObjectMethod( oDtPedido  , "Refresh()" )
ObjectMethod( oDtEntVen  , "Refresh()" )
ObjectMethod( oDtSaida   , "Refresh()" )

DO CASE
	CASE SUBSTR(SC5->C5_STATUS,1,1)='0' .And. Empty(SC5->C5_DTCANC)
		oStatus  :SetText("Vendas : " + ALLTRIM(cDescStatus))
		oStatus  :nClrText  := 	CLR_GRAY
	CASE SUBSTR(SC5->C5_STATUS,1,1)='0' .And. !Empty(SC5->C5_DTCANC)
		oStatus  :SetText("Vendas : CANCELADO" )
		oStatus  :nClrText  := 	CLR_MAGENTA
	CASE SUBSTR(SC5->C5_STATUS,1,1)='1'
		oStatus  :SetText("Credito: " + ALLTRIM(cDescStatus) )
		oStatus  :nClrText  := 	CLR_RED
	CASE SUBSTR(SC5->C5_STATUS,1,1)='2'
		oStatus  :SetText("Estoque: " + ALLTRIM(cDescStatus) )
		oStatus  :nClrText  := 	CLR_BLUE
	CASE SUBSTR(SC5->C5_STATUS,1,1)='3'
		oStatus  :SetText("Faturamento: " + ALLTRIM(cDescStatus) )
		oStatus  :nClrText  := 	CLR_BLACK
	CASE SUBSTR(SC5->C5_STATUS,1,1)='4' .AND. EMPTY(SC5->C5_DTSAIDA)
		oStatus  :SetText("Expedi็ao " )
		oStatus  :nClrText  := 	CLR_GREEN
	CASE SUBSTR(SC5->C5_STATUS,1,1)='4' .AND. !EMPTY(SC5->C5_DTSAIDA)
		oStatus  :SetText("Pedido Faturado" )
		oStatus  :nClrText  := 	CLR_GREEN
ENDCASE

DbSelectArea("SC5")
Activate Dialog oDLGPedido Centered ON INIT EnchoiceBar(oDlgPedido, {|| oDlgPedido:End()}, {|| oDlgPedido:End()} , ,aMyBtn ) //Valid SairCons()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT31_PsqบAutor  ณ Eurivan Marques    บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_Psq()

Private aHeaderC5 := {} , aColsSC5 :={}, nVAL_PED :=0 ,cCond
Private aCols,aHeader,lRet,nPED:=0
_cAlias := Alias()

SX3->( DBSETORDER(1) )
SX3->( DBSEEK('SC5'+'01') )
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC5'+'02') )
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SE4'+'05') )
AAdd( aHEADERC5, { Trim( 'Condicao de pagamento' ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'07') )
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC5'+'28') )
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SE4'+'05') )
AAdd( aHEADERC5, { Trim( 'Local' ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
25 , SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC5'+'29') )
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
25 , SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC5'+'65') ) //NOTA
AAdd( aHEADERC5, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO , SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )

cCond := "SELECT COUNT(C5_FILIAL) PEDIDOS FROM "+RETSQLNAME("SC5")+" SC5  "
cCond += "WHERE SC5.C5_CLIENTE ='"+SA1->A1_COD+"' AND SC5.D_E_L_E_T_ = '' "
TCQUERY cCond ALIAS SC5Z NEW
nPED := SC5Z->PEDIDOS
SC5Z->( DBCLOSEAREA() )

DbSelectArea(_cAlias)

Processa( {|| PFAT31_Cli()} )

IF EMPTY(aColsSC5)
	Alert("Nao existe pedidos para o cliente selecionado")
	Return(.F.)
ENDIF
aCOLS   := aCOLSSC5
aHEADER := aHEADERC5

Dbselectarea("SC5")
DEFINE MSDIALOG oDlg7 FROM -020,0 TO 300,680 TITLE 'Pedidos Encontrados' OF oMainWnd PIXEL
GetDados(001,001,148,335,2,"AllwaysTrue","AllwaysTRue",,.F.)
DEFINE SBUTTON FROM 149,200 TYPE 01 ACTION FAT020_Pos(oDlg7,1) ENABLE OF oDlg7
DEFINE SBUTTON FROM 149,240 TYPE 02 ACTION FAT020_Pos(oDlg7,2) ENABLE OF oDlg7

ACTIVATE DIALOG oDlg7 CENTERED

DbSelectArea(_cAlias)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_Cli()
// Verifica a Filial 01
SC5->( DBSETORDER(3) )
SC5->( DBSEEK('01'+SA1->A1_COD) )
Procregua(nPed)
WHILE SC5->C5_CLIENTE = SA1->A1_COD
	IF  LEFT(SC5->C5_NUM,1)<>'X'
		SE4->( DBSETORDER(1) )
		SE4->( DBSEEK(xFILIAL("SE4")+SC5->C5_CONDPAG) )
		
		SX5->( DBSETORDER(1) )
		SX5->( DBSEEK(SPACE(02)+"ZZ"+SC5->C5_STATUS) )
		
		SC6->( DBSETORDER(1) )
		SC6->( DBSEEK('01'+SC5->C5_NUM) )
		nVAL_PED := 0
		WHILE SC5->C5_NUM=SC6->C6_NUM
			nVAL_PED += SC6->C6_VALOR
			SC6->( DBSKIP() )
		ENDDO
		AADD(aColsSC5,{SC5->C5_FILIAL,SC5->C5_NUM,SE4->E4_DESCRI,nVAL_PED,;
		SC5->C5_EMISSAO,SX5->X5_DESCRI,SC5->C5_COTACAO,SC5->C5_NOTA})
	ENDIF
	SC5->( DBSKIP() ) ; INCPROC()
ENDDO

// Verifica a Filial 02
//Comentei Eurivan
/*
SC5->( DBSETORDER(3) )
SC5->( DBSEEK('02'+SA1->A1_COD) )

WHILE SC5->C5_CLIENTE = SA1->A1_COD
	IF  LEFT(SC5->C5_NUM,1)<>'X'
		SE4->( DBSETORDER(1) )
		SE4->( DBSEEK(xFILIAL("SE4")+SC5->C5_CONDPAG) )
		
		SX5->( DBSETORDER(1) )
		SX5->( DBSEEK(SPACE(02)+"ZZ"+SC5->C5_STATUS) )
		
		SC6->( DBSETORDER(1) )
		SC6->( DBSEEK('02'+SC5->C5_NUM) )
		nVAL_PED := 0
		WHILE SC5->C5_NUM=SC6->C6_NUM
			nVAL_PED += SC6->C6_VALOR
			SC6->( DBSKIP() )
		ENDDO
		AADD(aColsSC5,{SC5->C5_FILIAL,SC5->C5_NUM,SE4->E4_DESCRI,nVAL_PED,;
		SC5->C5_EMISSAO,SX5->X5_DESCRI,SC5->C5_COTACAO,SC5->C5_NOTA})
	ENDIF
	SC5->( DBSKIP() ) ; INCPROC()
ENDDO
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FAT020_Pos(oDlg,nTIPO)
SC5->( DBSETORDER(1) )
SC5->( DBSEEK(aCOLS[N,1]+aCOLS[N,2]) )
cFilant := aCOLS[N,1]
oDlg:End()
IF nTIPO == 1
	lRet := .T.
	Return(.T.)
ELSE
	lRet := .F.
	Return(.F.)
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_Qry()

Local cCond,nTot_Lib:=0
aCOLSC6   := {}
aHEADERC6 := {}

aCOLSC9   := {}
aHEADERC9 := {}

aCOLSQBR  := {}
aCOLSFAT  := {}

// Defini็ao do aHEADER para o SC6

SX3->( DBSETORDER(1) )
SX3->( DBSEEK('SC6'+'02') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'03') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_1()', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'04') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'05') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_2()', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'06') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'07') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'36') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'14') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'22') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_3(1)', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'24') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_3(2)', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'37') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'20') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_3(1)', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'21') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, 'U_FATSEN_3(2)', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'29') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'10') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'11') )
AAdd( aHEADERC6, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'74') )
AAdd( aHEADERC6, { Trim( "Ponta Est." ), SX3->X3_CAMPO, "@!", ;
3, 0, ".T.", SX3->X3_USADO, "C", SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )

// Defini็ao do aHEADER para o SC9

SX3->( DBSETORDER(1) )
SX3->( DBSEEK('SC9'+'04') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC9'+'07') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'04') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC9'+'08') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC9'+'14') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'07') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'36') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'14') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'22') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'24') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'37') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'20') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'21') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'29') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'10') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'11') )
AAdd( aHEADERC9, { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, ;
SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
SX3->( DBSEEK('SC6'+'74') )
AAdd( aHEADERC9, { Trim( "Ponta Est." ), SX3->X3_CAMPO, "@!", ;
3, 0, ".T.", SX3->X3_USADO, "C", SX3->X3_ARQUIVO, SX3->X3_CONTEXT  } )

Procregua(4)
nTot_Ped:=nTotPedN:=nTot_Qbr:=nTot_Fat:=nTot_Frt:=nTOTC6_ITE:=nTOTC6_REF:=nTOTC9_ITE:=nTOTC9_REF:=0
nTotQbr_ITE:=nTotQbr_REF:=nTotFAT_ITE:=nTotFAT_REF:=0
INCPROC()

SC6->( DBSETORDER(1) )
SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )

WHILE SC6->C6_NUM = SC5->C5_NUM
	
	Dbselectarea("SB1")
	Dbsetorder(1)
	Dbseek(xFilial()+SC6->C6_PRODUTO)
	
	Dbselectarea("SC6")
	
	nTot_Ped += SC6->C6_QTDVEN * (SC6->C6_PRCVEN/*+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/)
	
	nTotPedT += Round( ( SC6->C6_VALOR/* + SC6->C6_DESCIPI*/ ) / SC6->C6_QTDVEN * ( SC6->C6_QTDEMP + SC6->C6_QTDENT ), 4 )
//	nTotIpi  += Round( ( SC6->C6_DESCIPI ) / SC6->C6_QTDVEN * ( SC6->C6_QTDEMP + SC6->C6_QTDENT ), 4 )
	//Se for nacional, contribuinte e nao for tipo 09
	If SB1->B1_IMPORT <> 'S' //.And. SB1->B1_CONTRIB == 'S' //.And.  SB1->B1_TIPO <> "09"
		nTotPedN += Round( ( SC6->C6_VALOR/* + SC6->C6_DESCIPI*/ ) / SC6->C6_QTDVEN * ( SC6->C6_QTDEMP + SC6->C6_QTDENT ), 4 )
//		nTotIpiN += Round( SC6->C6_DESCIPI / SC6->C6_QTDVEN * ( SC6->C6_QTDEMP + SC6->C6_QTDENT ), 4 )
	Endif
	
	AADD(aCOLSC6,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_UM,SC6->C6_QTDVEN,/*(SC6->C6_PRCVEN+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4))*/0,;
	SC6->C6_VALOR/*+SC6->C6_DESCIPI*/,SC6->C6_DESCRI,SC6->C6_LOCAL,SC6->C6_DESCONT,;
	SC6->C6_VALDESC,SC6->C6_PRUNIT,/*SC6->C6_DESCCX*/"",/*SC6->C6_DESCOC*/"",SC6->C6_COMIS1,;
	SC6->C6_TES,SC6->C6_CF,"NAO"/*IF(SC6->C6_QTDVEN=SC6->C6_QRBREP,"SIM","NAO")*/,.F.})
	nTOTC6_ITE += SC6->C6_QTDVEN * (SC6->C6_PRCVEN/*+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/)
	nTOTC6_REF ++
	
	//	SC9->( DBSETORDER(1) )
	//	SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM) )
	
	// Quebra do Pedido
	IF SC6->C6_QTDVEN > (SC6->C6_QTDEMP+SC6->C6_QTDENT) //SC9->C9_QTDLIB
		AADD(aCOLSQBR,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_UM,SC6->C6_QTDVEN-(SC6->C6_QTDEMP+SC6->C6_QTDENT),(SC6->C6_PRCVEN/*+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/),;
		(SC6->C6_QTDVEN-(SC6->C6_QTDEMP+SC6->C6_QTDENT))*(SC6->C6_PRCVEN/*+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/),;
		SC6->C6_DESCRI,SC6->C6_LOCAL,SC6->C6_DESCONT,SC6->C6_VALDESC,SC6->C6_PRUNIT,;
		/*SC6->C6_DESCCX*/"",/*SC6->C6_DESCOC*/"",SC6->C6_COMIS1,SC6->C6_TES,SC6->C6_CF,"NAO"/*IF(SC6->C6_QTDVEN=SC6->C6_QRBREP,"SIM","NAO")*/})
		nTOTQBR_ITE += (SC6->C6_QTDVEN-(SC6->C6_QTDEMP+SC6->C6_QTDENT))*(SC6->C6_PRCVEN/*+Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/)
		nTOTQBR_REF ++
	ENDIF
	
	If ! Empty(SC6->C6_QTDEMP+SC6->C6_QTDENT)
		nTot_Lib   += (SC6->C6_QTDEMP+SC6->C6_QTDENT) * ( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/ )
		nTOTC9_ITE += (SC6->C6_QTDEMP+SC6->C6_QTDENT) * ( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/ )
		nTOTC9_REF ++
		
		// Pedido Liberados
		AADD(aCOLSC9,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_UM,(SC6->C6_QTDEMP+SC6->C6_QTDENT),( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/ ),;
		(SC6->C6_QTDEMP+SC6->C6_QTDENT) * ( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/ ),;
		SC6->C6_DESCRI,SC6->C6_LOCAL,SC6->C6_DESCONT,SC6->C6_VALDESC,SC6->C6_PRUNIT,;
		/*SC6->C6_DESCCX*/"",/*SC6->C6_DESCOC*/"",SC6->C6_COMIS1,SC6->C6_TES,SC6->C6_CF,"NAO"/*IF(SC6->C6_QTDVEN=SC6->C6_QRBREP,"SIM","NAO")*/})
	EndIf
	
	IF !EMPTY(SC6->C6_QTDENT)
		AADD(aCOLSFAT,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_UM,SC6->C6_QTDENT,( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4)*/ ),;
		SC6->C6_QTDENT * ( SC6->C6_PRCVEN/* + Round(SC6->C6_DESCIPI/SC6->C6_QTDVEN,4) */),;
		SC6->C6_DESCRI,SC6->C6_LOCAL,SC6->C6_DESCONT,SC6->C6_VALDESC,SC6->C6_PRUNIT,;
		/*SC6->C6_DESCCX*/"",/*SC6->C6_DESCOC*/"",SC6->C6_COMIS1,SC6->C6_TES,SC6->C6_CF,"NAO"/*IF(SC6->C6_QTDVEN=SC6->C6_QRBREP,"SIM","NAO")*/})
		nTOTFAT_ITE += SC6->C6_QTDENT
		nTOTFAT_REF ++
	ENDIF
	
	
	SC6->( DBSKIP() )
ENDDO

INCPROC()

IF EMPTY(aCOLSC9)
	AADD(aCOLSC9,{SPACE(02),SPACE(15),SPACE(02),0,0,0,SPACE(10),SPACE(02),0,0,0,0,0,0,SPACE(02),SPACE(02),0})
ENDIF

IF EMPTY(aCOLSQBR)
	AADD(aCOLSQBR,{SPACE(02),SPACE(15),SPACE(02),0,0,0,SPACE(10),SPACE(02),0,0,0,0,0,0,SPACE(02),SPACE(02),0})
ENDIF

IF EMPTY(aCOLSFAT)
	AADD(aCOLSFAT,{SPACE(02),SPACE(15),SPACE(02),0,0,0,SPACE(10),SPACE(02),0,0,0,0,0,0,SPACE(02),SPACE(02),0})
ENDIF

INCPROC()

IIF(nTot_Lib = 0,nTot_Qbr:=0, nTot_Qbr:=nTot_Ped-nTot_Lib)
INCPROC()
SF2->( DBSETORDER(1) )
SF2->( DBSEEK(xFILIAL("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )
INCPROC()
nTot_Fat := SF2->F2_VALBRUT
nTot_Frt := iif(SC5->C5_STATUS < '300' .and. SC5->C5_CONDPAG='300',SC5->C5_DESPESA,SC5->C5_FRETE)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_ORI()

dbselectarea("SA1")

Private aCOLS:={}
Private aHEADER:={}

aCOLS   := aCOLSC6
aHEADER := aHEADERC6

DEFINE MSDIALOG oDlg7 FROM -050,0 TO 300,600 TITLE 'Pedido Original' OF oMainWnd PIXEL

@ 155 , 010 SAY OEMTOANSI("Referencias : ")
@ 155 , 048 GET nTOTC6_REF  WHEN .F. SIZE 30,10
@ 155 , 100 SAY OEMTOANSI("Valor : ")
@ 155 , 120 GET nTOTC6_ITE  PICTURE "@E 999,999.99" WHEN .F. SIZE 60,10

DEFINE SBUTTON FROM 155,200 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

GetDados(001,001,150,300,2,"AllwaysTrue","AllwaysTRue",,.F.)

ACTIVATE DIALOG oDlg7 CENTERED

dbselectarea("SA1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_LIB()

Private aCOLS:={}
Private aHEADER:={}

aCOLS   := aCOLSC9
aHEADER := aHEADERC9

DEFINE MSDIALOG oDlg7 FROM -050,0 TO 300,600 TITLE 'Item Liberados' OF oMainWnd PIXEL

@ 155 , 010 SAY OEMTOANSI("Referencias : ")
@ 155 , 048 GET nTOTC9_REF  WHEN .F. SIZE 30,10
@ 155 , 100 SAY OEMTOANSI("Valor : ")
@ 155 , 120 GET nTOTC9_ITE  PICTURE "@E 999,999.99" WHEN .F. SIZE 60,10

DEFINE SBUTTON FROM 155,200 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

Dbselectarea("SC5")

GetDados(001,001,150,300,2,"AllwaysTrue","AllwaysTrue",,.F.)

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_QBR()

Private aCOLS:={}
Private aHEADER:={}

aCOLS   := aCOLSQBR
aHEADER := aHEADERC9

aHEADER[4,1] := "Qtd.Quebra"



DEFINE MSDIALOG oDlg7 FROM -050,0 TO 300,600 TITLE 'Item com quebra' OF oMainWnd PIXEL

@ 155 , 010 SAY OEMTOANSI("Referencias : ")
@ 155 , 048 GET nTOTQBR_REF  WHEN .F. SIZE 30,10
@ 155 , 100 SAY OEMTOANSI("Valor : ")
@ 155 , 120 GET nTOTQBR_ITE PICTURE "@E 9,999,999.99" WHEN .F. SIZE 60,10

DEFINE SBUTTON FROM 155,200 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

DBSELECTAREA("SC5")

GetDados(001,001,150,300,2,"AllwaysTrue","AllwaysTRue",,.F.)

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_FAT()

Private aCOLS:={}
Private aHEADER:={}

aCOLS   := aCOLSFAT
aHEADER := aHEADERC9

aHEADER[4,1] := "Qtd.Faturada"

DEFINE MSDIALOG oDlg7 FROM -050,0 TO 300,600 TITLE 'Item faturados' OF oMainWnd PIXEL

@ 155 , 010 SAY OEMTOANSI("Referencias : ")
@ 155 , 048 GET nTOTFAT_REF  WHEN .F. SIZE 30,10
@ 155 , 100 SAY OEMTOANSI("Itens : ")
@ 155 , 120 GET nTOTFAT_ITE  WHEN .F. SIZE 30,10

DEFINE SBUTTON FROM 155,200 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7
GetDados(001,001,150,300,2,"AllwaysTrue","AllwaysTRue",,.F.)

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_HOR()

Local cC5_ATEND := IIF(!EMPTY(SC5->C5_ENTREG/*SC5->C5_DTSAIDA*/),SC5->C5_ENTREG-SC5->C5_EMISSAO/*SC5->C5_DTSAIDA-SC5->C5_DT_DIG*/,DDATABASE - SC5->C5_EMISSAO/*SC5->C5_DT_DIG*/ )

nACUM  := 0//SC5->C5_TMPVEN - INT(SC5->C5_TMPVEN)
nHORAS1 := 0//ALLTRIM(STR(INT(SC5->C5_TMPVEN)))+' Hrs  ' + ALLTRIM(STR( nACUM*60 ))+' Minutos'

DEFINE MSDIALOG oDlg7 FROM -040,0 TO 300,650 TITLE 'Horarios' OF oMainWnd PIXEL

@ 010 , 010 SAY   OEMTOANSI("SETOR DE VENDAS")  COLOR CLR_GRAY
@ 020 , 010 SAY   OEMTOANSI("Entrada : ")
//@ 020 , 050 GET SC5->C5_DT_DIG      WHEN .F. SIZE 35,10
//@ 020 , 100 GET SC5->C5_HR_DIG      WHEN .F. SIZE 20,10
@ 030 , 010 SAY   OEMTOANSI("Saida : ")
//@ 030 , 050 GET SC5->C5_DTS_VEN     WHEN .F. SIZE 35,10
//@ 030 , 100 GET SC5->C5_HRS_VEN     WHEN .F. SIZE 20,10
@ 040 , 010 SAY   OEMTOANSI("Hrs uteis :")
@ 040 , 050 GET nHORAS1      WHEN .F.        SIZE 60,10

nACUM  := 0//SC5->C5_TMPCRE - INT(SC5->C5_TMPCRE)
nHORAS2 := 0//ALLTRIM(STR(INT(SC5->C5_TMPCRE)))+' Hrs  ' + ALLTRIM(STR( nACUM*60 ))+' Minutos'

@ 010 , 180 SAY OEMTOANSI("SETOR DE CREDITO")   COLOR CLR_RED
@ 020 , 180 SAY OEMTOANSI("Entrada : ")
//@ 020 , 220 GET SC5->C5_DTE_CRE     WHEN .F. SIZE 35,10
//@ 020 , 270 GET SC5->C5_HRE_CRE     WHEN .F. SIZE 20,10
@ 030 , 180 SAY OEMTOANSI("Saida : ")
//@ 030 , 220 GET SC5->C5_DTS_CRE     WHEN .F. SIZE 35,10
//@ 030 , 270 GET SC5->C5_HRS_CRE     WHEN .F. SIZE 20,10
@ 040 , 180 SAY OEMTOANSI("Hrs uteis :")
@ 040 , 220 GET nHORAS2      WHEN .F.         SIZE 60,10

nACUM  := 0//SC5->C5_TMPEST - INT(SC5->C5_TMPEST)
nHORAS3 := 0//ALLTRIM(STR(INT(SC5->C5_TMPEST)))+' Hrs  ' + ALLTRIM(STR( nACUM*60 ))+' Minutos'

@ 050 , 010 SAY OEMTOANSI("SETOR DE ESTOQUE")   COLOR CLR_BLUE
@ 060 , 010 SAY   OEMTOANSI("Entrada : ")
//@ 060 , 050 GET SC5->C5_DTE_EST     WHEN .F. SIZE 35,10
//@ 060 , 100 GET SC5->C5_HRE_EST     WHEN .F. SIZE 20,10
@ 070 , 010 SAY   OEMTOANSI("Saida : ")
//@ 070 , 050 GET SC5->C5_DTS_EST     WHEN .F. SIZE 35,10
//@ 070 , 100 GET SC5->C5_HRS_EST     WHEN .F. SIZE 20,10
@ 080 , 010 SAY   OEMTOANSI("Hrs uteis :")
@ 080 , 050 GET nHORAS3      WHEN .F.         SIZE 60,10

nACUM  := 0//SC5->C5_TMPFAT - INT(SC5->C5_TMPFAT)
nHORAS4 := 0//ALLTRIM(STR(INT(SC5->C5_TMPFAT)))+' Hrs  ' + ALLTRIM(STR( nACUM*60 ))+' Minutos'
@ 050 , 180 SAY OEMTOANSI("SETOR DE FATURAMENTO") COLOR CLR_BLACK
@ 060 , 180 SAY   OEMTOANSI("Entrada : ")
//@ 060 , 220 GET SC5->C5_DTE_FAT     WHEN .F. SIZE 35,10
//@ 060 , 270 Get SC5->C5_HRE_FAT     WHEN .F. SIZE 20,10
@ 070 , 180 SAY   OEMTOANSI("Saida : ")
//@ 070 , 220 Get SC5->C5_DTS_FAT     WHEN .F. SIZE 35,10
//@ 070 , 270 Get SC5->C5_HRS_FAT     WHEN .F. SIZE 20,10
@ 080 , 180 SAY   OEMTOANSI("Hrs uteis :")
@ 080 , 220 Get nHORAS4      WHEN .F.         SIZE 60,10

nACUM  := 0//SC5->C5_TMPEXP - INT(SC5->C5_TMPEXP)
nHORAS5 := 0//ALLTRIM(STR(INT(SC5->C5_TMPEXP)))+' Hrs  ' + ALLTRIM(STR( nACUM*60 ))+' Minutos'
@ 090 , 010 SAY OEMTOANSI("SETOR DE EXPEDICAO")  COLOR CLR_GREEN
@ 100 , 010 SAY   OEMTOANSI("Entrada : ")
//@ 100 , 050 Get SC5->C5_DTLIBEX     WHEN .F. SIZE 35,10
//@ 100 , 100 Get SC5->C5_HRLIBEX     WHEN .F. SIZE 20,10
@ 110 , 010 SAY   OEMTOANSI("Saida : ")
//@ 110 , 050 Get SC5->C5_DTSAIDA     WHEN .F. SIZE 35,10
//@ 110 , 100 Get SC5->C5_HRSAIDA     WHEN .F. SIZE 20,10
@ 120 , 010 SAY   OEMTOANSI("Hrs uteis :")
@ 120 , 050 Get nHORAS5      WHEN .F.         SIZE 60,10

@ 090 , 180 SAY   OEMTOANSI("Alteracao : ")
//@ 090 , 220 Get SC5->C5_NMALT       WHEN .F.
@ 100 , 180 SAY   OEMTOANSI("Data e Hora:")
//@ 100 , 220 Get SC5->C5_DTALT       WHEN .F. SIZE 35,10
//@ 100 , 270 Get SC5->C5_HRALT       WHEN .F. SIZE 20,10
@ 110 , 180 SAY   OEMTOANSI("Tempo de Atendimento: ")
@ 120 , 180 Get cC5_ATEND           WHEN .F. SIZE 30,10

DEFINE SBUTTON FROM 150,250 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_Pen()

/*
Dbselectarea("ZAL")
Dbsetorder(1)
Dbseek(xFilial("ZAL")+SC5->C5_NUM)

mCob := CriaVar("ZAL->ZAL_MTPENV")
mCob += "  Setor de Vendas "+Chr(13)+chr(10)
mCob += "  " +Chr(13)+chr(10)
mCob += "  Setor de Vendas "+Chr(13)+chr(10)
mCob += " ----------------- "+Chr(13)+chr(10)
mCob += " "+Chr(13)+chr(10)
mCob += " Data da Pendecia : " + DTOC(SC5->C5_DTPEN_V) + "  -  " + SC5->C5_HRPEN_V +Chr(13)+chr(10)
mCob += TRIM(ZAL->ZAL_MTPENV)+Chr(13)+chr(10)


mCob += " "+Chr(13)+chr(10)

mCob += "  Setor de Credito "+Chr(13)+chr(10)
mCob += " ------------------ "+Chr(13)+chr(10)
mCob += " "+Chr(13)+chr(10)
mCob += " Data da Pendecia : " + DTOC(SC5->C5_DTPEN_C) + "  -  " + SC5->C5_HRPEN_C+Chr(13)+chr(10)
mCob += TRIM(ZAL->ZAL_MTPENC)+Chr(13)+chr(10)

mCob += " "+Chr(13)+chr(10)

mCob += "  Setor de Estoque  "+Chr(13)+chr(10)
mCob += " ------------------ "+Chr(13)+chr(10)
mCob += " "+Chr(13)+chr(10)
mCob += " Data da Pendecia : " + DTOC(SC5->C5_DTPEN_E) + "  -  " + SC5->C5_HRPEN_E+Chr(13)+chr(10)
mCob += TRIM(ZAL->ZAL_MTPENE)+Chr(13)+chr(10)

mCob += " "+Chr(13)+chr(10)

mCob += "  Setor de Faturamento  "+Chr(13)+chr(10)
mCob += " ---------------------- "+Chr(13)+chr(10)
mCob += " "+Chr(13)+chr(10)
mCob += " Data da Pendecia : " + DTOC(SC5->C5_DTPEN_F) + "  -  " + SC5->C5_HRPEN_F+Chr(13)+chr(10)
mCob += TRIM(ZAL->ZAL_MTPENF)+Chr(13)+chr(10)

mCob += " "+Chr(13)+chr(10)

mCob += "  Setor de Expedicao  "+Chr(13)+chr(10)
mCob += " -------------------- "+Chr(13)+chr(10)
mCob += " "+Chr(13)+chr(10)
mCob += " Data da Pendecia : " + DTOC(SC5->C5_DTPEN_X) + "  -  " + SC5->C5_HRPEN_X+Chr(13)+chr(10)
mCob += TRIM(ZAL->ZAL_MTPENX)+Chr(13)+chr(10)

mCob += " "
nTOT_TIT := 0
*/
DEFINE MSDIALOG oDlg7 FROM -040,0 TO 300,650 TITLE 'Pendencias' OF oMainWnd PIXEL
@ 001,010 GET mCob Size 300,130 MEMO

DEFINE SBUTTON FROM 150,250 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_NEG()

vTexto:={}
Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
	mCob := ZZ6->ZZ6_NEGOCI
Else
	mCob := CriaVar("ZZ6->ZZ6_NEGOCI")
Endif


DEFINE MSDIALOG oDlg7 FROM -040,0 TO 300,630 TITLE 'Negociacao' OF oMainWnd PIXEL

@ 001,010 GET mCob Size 300,130 MEMO
@ 150,001 SAY OEMTOANSI("Observacao : ")
@ 150,050 GET SC5->C5_OBS WHEN .F. SIZE 200,10

DEFINE SBUTTON FROM 150,260 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_PDUP()

local oDlg1

cPerg := "CPCP02"

ValidPerg()

if !Pergunte(cPerg)
	return
endif

cPedido := Alltrim(Mv_par01)+"PLM"

/*
Criacao de 2 tabelas temporarias
*/
aCAMPOS  := {{ "PEDIDO",   "C", 15, 0 },;  // Campos do arquivo do MSSELECT
{ "ITEM",     "C", 02, 0 },;
{ "PRODUTO",  "C", 15, 0 },;
{ "DESCRICAO","C", 30, 0 },;
{ "VALOR",    "N", 12, 4 },;
{ "EMISSAO",  "D", 08, 0 }}

_ArqTemp := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, _ArqTemp, "Pedidos1", .F., .F. )
Index On ITEM TO &_ArqTemp

_ArqTemp2 := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, _ArqTemp2, "Pedidos2", .F., .F. )
Index On ITEM TO &_ArqTemp2

_Tmpqry := " SELECT SC6.C6_NUM,SC5.C5_FLNUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_DESCRI,SC6.C6_VALOR,SC6.C6_DESCIPI, "
_Tmpqry += " SC5.C5_CLIENTE,SC5.C5_LOJACLI "
_Tmpqry += " FROM "+RetSqlName("SC6")+" SC6,"+RetSqlName("SC5")+" SC5 "
_Tmpqry += " WHERE SC6.C6_FILIAL='"+XFilial("SC6")+"' AND SC6.C6_NUM=SC5.C5_NUM AND SC5.C5_FLNUM='"+cPedido+"' AND SC5.C5_VEND1='"+Alltrim(Sa3->a3_cod)+"' "
_Tmpqry += " AND SC6.D_E_L_E_T_='' AND SC5.D_E_L_E_T_='' "
_Tmpqry += " ORDER BY C5_FLNUM,C5_NUM "

TcQuery _Tmpqry Alias "QTMP" New

QTmp->(DbGoTop())
_cli1 := _cli2 := _ped1 := _ped2 := space(6)
_loj1 := _loj2 := space(2)
while !QTmp->(Eof())
	if alltrim(_cli1) = ''
		_cli1 := QTmp->c5_cliente
		_loj1 := QTmp->c5_lojacli
		_ped1 := QTmp->c6_num
	elseif Alltrim(_cli2) = '' .and. QTmp->c5_cliente <> Alltrim(_cli1)
		_cli2 := QTmp->c5_cliente
		_loj2 := QTmp->c5_lojacli
		_ped2 := QTmp->c6_num
	endif
	Qtmp->(DbSkip())
enddo

_nTotPed1 := _nTotPed2 := 0

QTmp->(DbGoTop())
while !QTmp->(eof())
	if QTmp->c5_cliente = _cli1
		Pedidos1->(Reclock("Pedidos1",.t.))
		Pedidos1->item      := QTmp->c6_item
		Pedidos1->produto   := QTmp->c6_produto
		Pedidos1->descricao := QTmp->c6_descri
		Pedidos1->valor     := QTmp->c6_valor
		Pedidos1->pedido    := QTmp->c6_num
		_nTotPed1 += QTmp->c6_valor+QTmp->c6_descipi
		Pedidos1->(MsUnlock())
	endif
	if QTmp->c5_cliente= _cli2
		Pedidos2->(Reclock("Pedidos2",.t.))
		Pedidos2->item      := QTmp->c6_item
		Pedidos2->produto   := QTmp->c6_produto
		Pedidos2->descricao := QTmp->c6_descri
		Pedidos2->valor     := QTmp->c6_valor
		Pedidos2->pedido    := QTmp->c6_num
		_nTotPed2 += QTmp->c6_valor+QTmp->c6_descipi
		Pedidos2->(MsUnlock())
	endif
	QTmp->(DbSkip())
enddo
QTmp->(DbCloseArea())

@ 000,000 To 500,800 Dialog oDLG1 Title OemToAnsi( "Pedido Duplicado" )

/*
Mostrando os Dados do cliente
*/

SA1->(DbSetOrder(1))
SA1->(DbSeek(XFilial("SA1")+_cli1+_loj1))

@ 205,010 say OemToAnsi("Total do Pedido ("+_ped1+")" )
@ 203,160 get _nTotPed1 Picture "@E 999,999.99" when .f. Size 35,10
@ 213,010 say OemToAnsi("Cliente : "+_Cli2+"-"+_Loj2+"  "+SA1->A1_NOME)

SA1->(DbSetOrder(1))
SA1->(DbSeek(XFilial("SA1")+_cli2+_loj2))

@ 205,210 say OemToAnsi("Total do Pedido ("+_ped2+")")
@ 203,360 get _nTotPed2 Picture "@E 999,999.99" when .f. Size 35,10
@ 213,210 say OemToAnsi("Cliente : "+_Cli2+"-"+_Loj2+"  "+SA1->A1_NOME)

DbSelectArea("Pedidos1")
DbGoTop()

oBRW := MsSelect():New( "Pedidos1",,, ;
{  {"item"       ,, OemToAnsi( "Item" ),"!!" }      ,;
{"produto"    ,, OemToAnsi( "Produto" ),"!!!!!!!"}   ,;
{"descricao"  ,, OemToAnsi( "Descri็ใo" ),"@!" } ,;
{"valor"      ,, OemToAnsi( "Valor" ),"@R 9,999,999.9999" }} , ;
.F.,, { 002, 002, 200, 200 } )

DbSelectArea("Pedidos2")
DbGoTop()

oBRW := MsSelect():New( "Pedidos2",,, ;
{  {"item"       ,, OemToAnsi( "Item" ),"!!" }      ,;
{"produto"    ,, OemToAnsi( "Produto" ),"!!!!!!!"}   ,;
{"descricao"  ,, OemToAnsi( "Descri็ใo" ),"@!" } ,;
{"valor"      ,, OemToAnsi( "Valor" ),"@R 9,999,999.9999" }} , ;
.F.,, { 002, 205, 200, 400 } )


@ 230,200 BUTTON "_Sair" SIZE 35,15  ACTION Close(Odlg1)

Activate Dialog oDLG1 Centered //Valid Sair()
Pedidos1->(DbCloseArea())
Pedidos2->(DbCloseArea())
DbSelectArea("SC5")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  07/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31_OBS()

vTexto:={}
Dbselectarea("ZAL")
Dbsetorder(1)
If Dbseek(xFilial("ZAL")+SC5->C5_NUM)
	mObs := ZAL->ZAL_OBSERV
Else
	Alert("ZAL nao encontrado")
	mObs := CriaVar("ZAL->ZAL_NEGOCI")
Endif


DEFINE MSDIALOG oDlg7 FROM -040,0 TO 300,630 TITLE 'Observacoes' OF oMainWnd PIXEL

@ 001,010 GET mObs Size 300,130 MEMO
@ 150,001 SAY OEMTOANSI("Observacao : ")
@ 150,050 GET SC5->C5_OBS WHEN .F. SIZE 200,10

DEFINE SBUTTON FROM 150,260 TYPE 01 ACTION (oDlg7:End()) ENABLE OF oDlg7

ACTIVATE DIALOG oDlg7 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Pedido Temporแrio  ","","","mv_ch1","C",6,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31ALT()

//Variaveis utilizadas na funcao PFAT31SEN()
Private cNome   := Space(15)
Private _cSenha := Space(06)

//Solicita a senha do usuario
lOkSenha := PFAT31SEN()

If !lOkSenha
	//Alert("Operacao Cancelada!!!")
	Return
Endif

/*
Private aOpera:= {"01 - Altera Cliente",;
"02 - Altera Cond.Pag. Vendas",;
"03 - Altera Frete",;
"04 - Altera Itens do Pedido",;
"05 - Altera Licitacao",;
"06 - Altera Mensagens",;
"07 - Altera Representante",;
"08 - Altera Comissao",;
"09 - Cliente fora da Area",;
"10 - Peso dos Pedidos",;
"11 - Altera Cond.Pag.",;
"12 - Altera Promocao",;
"13 - Altera Peso/Volume",;
"14 - Exige Cod. Barras",;
"15 - Altera Desconto",;
"16 - Altera Data Sintegra",;
"17 - Estorna Cancelamento",;
"18 - Altera Suframa",;
"19 - Informa Pedido Principal",;
"20 - Adiciona Desconto Promocional",;
"21 - Altera Data Programada",;
"22 - Altera e-mail",;
"23 - Altera Estado para Redespacho"}
*/
lOpc01 := .F.
lOpc02 := .F.
lOpc03 := .F.
lOpc04 := .F.
lOpc05 := .F.
lOpc06 := .F.
lOpc07 := .F.
lOpc08 := .F.
lOpc09 := .F.
lOpc10 := .F.
lOpc11 := .F.
lOpc12 := .F.
lOpc13 := .F.
lOpc14 := .F.
lOpc15 := .F.
lOpc16 := .F.
lOpc17 := .F.
lOpc18 := .F.
lOpc19 := .F.
lOpc20 := .F.
lOpc21 := .F.
lOpc22 := .F.
lOpc23 := .F.
lOpc24 := .F.
lOpc25 := .F.
lOpc26 := .F.
lOpc27 := .F.
lOpc28 := .F.

oDlgAlt := MSDIALOG():Create()
oDlgAlt:cName := "oDlgAlt"
oDlgAlt:cCaption := "Altera Pedido"
oDlgAlt:nLeft := 28
oDlgAlt:nTop := 15
oDlgAlt:nWidth := 500
oDlgAlt:nHeight := 520
oDlgAlt:lShowHint := .F.
oDlgAlt:lCentered := .T.

oOpc01 := TCHECKBOX():Create(oDlgAlt)
oOpc01:cName := "oOpc01"
oOpc01:cCaption := "01 - Cliente"
oOpc01:nLeft := 28
oOpc01:nTop := 15
oOpc01:nWidth := 200
oOpc01:nHeight := 17
oOpc01:lShowHint := .F.
oOpc01:lReadOnly := .F.
oOpc01:Align := 0
oOpc01:cVariable := "lOpc01"
oOpc01:bSetGet := {|u| If(PCount()>0,lOpc01:=u,lOpc01) }
oOpc01:lVisibleControl := .T.
oOpc01:bLClicked := {|| VldOpc("01") }

oOpc02 := TCHECKBOX():Create(oDlgAlt)
oOpc02:cName := "oOpc02"
oOpc02:cCaption := "02 - Cond. Pagamento Vendas"
oOpc02:nLeft := 28
oOpc02:nTop := 35
oOpc02:nWidth := 200
oOpc02:nHeight := 17
oOpc02:lShowHint := .F.
oOpc02:lReadOnly := .F.
oOpc02:Align := 0
oOpc02:cVariable := "lOpc02"
oOpc02:bSetGet := {|u| If(PCount()>0,lOpc02:=u,lOpc02) }
oOpc02:lVisibleControl := .T.
oOpc02:bLClicked := {|| VldOpc("02") }

oOpc03 := TCHECKBOX():Create(oDlgAlt)
oOpc03:cName := "oOpc03"
oOpc03:cCaption := "03 - Frete/Transportadora"
oOpc03:nLeft := 28
oOpc03:nTop := 55
oOpc03:nWidth := 200
oOpc03:nHeight := 17
oOpc03:lShowHint := .F.
oOpc03:lReadOnly := .F.
oOpc03:Align := 0
oOpc03:cVariable := "lOpc03"
oOpc03:bSetGet := {|u| If(PCount()>0,lOpc03:=u,lOpc03) }
oOpc03:lVisibleControl := .T.
oOpc03:bLClicked := {|| VldOpc("03") }

oOpc04 := TCHECKBOX():Create(oDlgAlt)
oOpc04:cName := "oOpc04"
oOpc04:cCaption := "04 - Itens do Pedido"
oOpc04:nLeft := 28
oOpc04:nTop := 75
oOpc04:nWidth := 200
oOpc04:nHeight := 17
oOpc04:lShowHint := .F.
oOpc04:lReadOnly := .F.
oOpc04:Align := 0
oOpc04:cVariable := "lOpc04"
oOpc04:bSetGet := {|u| If(PCount()>0,lOpc04:=u,lOpc04) }
oOpc04:lVisibleControl := .T.
oOpc04:bLClicked := {|| VldOpc("04") }
           
                  
/*
oOpc05 := TCHECKBOX():Create(oDlgAlt)
oOpc05:cName := "oOpc05"
oOpc05:cCaption := "05 - Licitacao"
oOpc05:nLeft := 28
oOpc05:nTop := 95
oOpc05:nWidth := 200
oOpc05:nHeight := 17
oOpc05:lShowHint := .F.
oOpc05:lReadOnly := .F.
oOpc05:Align := 0
oOpc05:cVariable := "lOpc05"
oOpc05:bSetGet := {|u| If(PCount()>0,lOpc05:=u,lOpc05) }
oOpc05:lVisibleControl := .T.
oOpc05:bLClicked := {|| VldOpc("05") }
*/

oOpc06 := TCHECKBOX():Create(oDlgAlt)
oOpc06:cName := "oOpc06"
oOpc06:cCaption := "06 - Mensagens"
oOpc06:nLeft := 28
oOpc06:nTop := 115
oOpc06:nWidth := 200
oOpc06:nHeight := 17
oOpc06:lShowHint := .F.
oOpc06:lReadOnly := .F.
oOpc06:Align := 0
oOpc06:cVariable := "lOpc06"
oOpc06:bSetGet := {|u| If(PCount()>0,lOpc06:=u,lOpc06) }
oOpc06:lVisibleControl := .T.
oOpc06:bLClicked := {|| VldOpc("06") }

oOpc07 := TCHECKBOX():Create(oDlgAlt)
oOpc07:cName := "oOpc07"
oOpc07:cCaption := "07 - Representante"
oOpc07:nLeft := 28
oOpc07:nTop := 135
oOpc07:nWidth := 200
oOpc07:nHeight := 17
oOpc07:lShowHint := .F.
oOpc07:lReadOnly := .F.
oOpc07:Align := 0
oOpc07:cVariable := "lOpc07"
oOpc07:bSetGet := {|u| If(PCount()>0,lOpc07:=u,lOpc07) }
oOpc07:lVisibleControl := .T.
oOpc07:bLClicked := {|| VldOpc("07") }

oOpc08 := TCHECKBOX():Create(oDlgAlt)
oOpc08:cName := "oOpc08"
oOpc08:cCaption := "08 - Comissao"
oOpc08:nLeft := 28
oOpc08:nTop := 155
oOpc08:nWidth := 200
oOpc08:nHeight := 17
oOpc08:lShowHint := .F.
oOpc08:lReadOnly := .F.
oOpc08:Align := 0
oOpc08:cVariable := "lOpc08"
oOpc08:bSetGet := {|u| If(PCount()>0,lOpc08:=u,lOpc08) }
oOpc08:lVisibleControl := .T.
oOpc08:bLClicked := {|| VldOpc("08") }

oOpc09 := TCHECKBOX():Create(oDlgAlt)
oOpc09:cName := "oOpc09"
oOpc09:cCaption := "09 - Cliente Fora da Area"
oOpc09:nLeft := 28
oOpc09:nTop := 175
oOpc09:nWidth := 200
oOpc09:nHeight := 17
oOpc09:lShowHint := .F.
oOpc09:lReadOnly := .F.
oOpc09:Align := 0
oOpc09:cVariable := "lOpc09"
oOpc09:bSetGet := {|u| If(PCount()>0,lOpc09:=u,lOpc09) }
oOpc09:lVisibleControl := .T.
oOpc09:bLClicked := {|| VldOpc("09") }

oOpc10 := TCHECKBOX():Create(oDlgAlt)
oOpc10:cName := "oOpc10"
oOpc10:cCaption := "10 - Peso dos Pedidos"
oOpc10:nLeft := 28
oOpc10:nTop := 195
oOpc10:nWidth := 200
oOpc10:nHeight := 17
oOpc10:lShowHint := .F.
oOpc10:lReadOnly := .F.
oOpc10:Align := 0
oOpc10:cVariable := "lOpc10"
oOpc10:bSetGet := {|u| If(PCount()>0,lOpc10:=u,lOpc10) }
oOpc10:lVisibleControl := .T.
oOpc10:bLClicked := {|| VldOpc("10") }

oOpc11 := TCHECKBOX():Create(oDlgAlt)
oOpc11:cName := "oOpc11"
oOpc11:cCaption := "11 - Cond. Pagamento"
oOpc11:nLeft := 28
oOpc11:nTop := 215
oOpc11:nWidth := 200
oOpc11:nHeight := 17
oOpc11:lShowHint := .F.
oOpc11:lReadOnly := .F.
oOpc11:Align := 0
oOpc11:cVariable := "lOpc11"
oOpc11:bSetGet := {|u| If(PCount()>0,lOpc11:=u,lOpc11) }
oOpc11:lVisibleControl := .T.
oOpc11:bLClicked := {|| VldOpc("11") }

oOpc12 := TCHECKBOX():Create(oDlgAlt)
oOpc12:cName := "oOpc12"
oOpc12:cCaption := "12 - Promocao"
oOpc12:nLeft := 28
oOpc12:nTop := 235
oOpc12:nWidth := 200
oOpc12:nHeight := 17
oOpc12:lShowHint := .F.
oOpc12:lReadOnly := .F.
oOpc12:Align := 0
oOpc12:cVariable := "lOpc12"
oOpc12:bSetGet := {|u| If(PCount()>0,lOpc12:=u,lOpc12) }
oOpc12:lVisibleControl := .T.
oOpc12:bLClicked := {|| VldOpc("12") }

oOpc13 := TCHECKBOX():Create(oDlgAlt)
oOpc13:cName := "oOpc13"
oOpc13:cCaption := "13 - Peso/Volume"
oOpc13:nLeft := 28
oOpc13:nTop := 255
oOpc13:nWidth := 200
oOpc13:nHeight := 17
oOpc13:lShowHint := .F.
oOpc13:lReadOnly := .F.
oOpc13:Align := 0
oOpc13:cVariable := "lOpc13"
oOpc13:bSetGet := {|u| If(PCount()>0,lOpc13:=u,lOpc13) }
oOpc13:lVisibleControl := .T.
oOpc13:bLClicked := {|| VldOpc("13") }

oOpc14 := TCHECKBOX():Create(oDlgAlt)
oOpc14:cName := "oOpc14"
oOpc14:cCaption := "14 - Exige Cod. Barras"
oOpc14:nLeft := 28
oOpc14:nTop := 275
oOpc14:nWidth := 200
oOpc14:nHeight := 17
oOpc14:lShowHint := .F.
oOpc14:lReadOnly := .F.
oOpc14:Align := 0
oOpc14:cVariable := "lOpc14"
oOpc14:bSetGet := {|u| If(PCount()>0,lOpc14:=u,lOpc14) }
oOpc14:lVisibleControl := .T.
oOpc14:bLClicked := {|| VldOpc("14") }

oOpc15 := TCHECKBOX():Create(oDlgAlt)
oOpc15:cName := "oOpc15"
oOpc15:cCaption := "15 - Desconto"
oOpc15:nLeft := 28
oOpc15:nTop := 295
oOpc15:nWidth := 200
oOpc15:nHeight := 17
oOpc15:lShowHint := .F.
oOpc15:lReadOnly := .F.
oOpc15:Align := 0
oOpc15:cVariable := "lOpc15"
oOpc15:bSetGet := {|u| If(PCount()>0,lOpc15:=u,lOpc15) }
oOpc15:lVisibleControl := .T.
oOpc15:bLClicked := {|| VldOpc("15") }

oOpc16 := TCHECKBOX():Create(oDlgAlt)
oOpc16:cName := "oOpc16"
oOpc16:cCaption := "16 - Data Sintegra"
oOpc16:nLeft := 28
oOpc16:nTop := 315
oOpc16:nWidth := 200
oOpc16:nHeight := 17
oOpc16:lShowHint := .F.
oOpc16:lReadOnly := .F.
oOpc16:Align := 0
oOpc16:cVariable := "lOpc16"
oOpc16:bSetGet := {|u| If(PCount()>0,lOpc16:=u,lOpc16) }
oOpc16:lVisibleControl := .T.
oOpc16:bLClicked := {|| VldOpc("16") }

oOpc17 := TCHECKBOX():Create(oDlgAlt)
oOpc17:cName := "oOpc17"
oOpc17:cCaption := "17 - Estorna Cancelamento"
oOpc17:nLeft := 28
oOpc17:nTop := 335
oOpc17:nWidth := 200
oOpc17:nHeight := 17
oOpc17:lShowHint := .F.
oOpc17:lReadOnly := .F.
oOpc17:Align := 0
oOpc17:cVariable := "lOpc17"
oOpc17:bSetGet := {|u| If(PCount()>0,lOpc17:=u,lOpc17) }
oOpc17:lVisibleControl := .T.
oOpc17:bLClicked := {|| VldOpc("17") }

oOpc18 := TCHECKBOX():Create(oDlgAlt)
oOpc18:cName := "oOpc18"
oOpc18:cCaption := "18 - Suframa"
oOpc18:nLeft := 28
oOpc18:nTop := 355
oOpc18:nWidth := 200
oOpc18:nHeight := 17
oOpc18:lShowHint := .F.
oOpc18:lReadOnly := .F.
oOpc18:Align := 0
oOpc18:cVariable := "lOpc18"
oOpc18:bSetGet := {|u| If(PCount()>0,lOpc18:=u,lOpc18) }
oOpc18:lVisibleControl := .T.
oOpc18:bLClicked := {|| VldOpc("18") }

oOpc19 := TCHECKBOX():Create(oDlgAlt)
oOpc19:cName := "oOpc19"
oOpc19:cCaption := "19 - Pedido Principal"
oOpc19:nLeft := 28
oOpc19:nTop := 375
oOpc19:nWidth := 200
oOpc19:nHeight := 17
oOpc19:lShowHint := .F.
oOpc19:lReadOnly := .F.
oOpc19:Align := 0
oOpc19:cVariable := "lOpc19"
oOpc19:bSetGet := {|u| If(PCount()>0,lOpc19:=u,lOpc19) }
oOpc19:lVisibleControl := .T.
oOpc19:bLClicked := {|| VldOpc("19") }

oOpc20 := TCHECKBOX():Create(oDlgAlt)
oOpc20:cName := "oOpc20"
oOpc20:cCaption := "20 - Adiciona Des. Promocional"
oOpc20:nLeft := 28
oOpc20:nTop := 395
oOpc20:nWidth := 200
oOpc20:nHeight := 17
oOpc20:lShowHint := .F.
oOpc20:lReadOnly := .F.
oOpc20:Align := 0
oOpc20:cVariable := "lOpc20"
oOpc20:bSetGet := {|u| If(PCount()>0,lOpc20:=u,lOpc20) }
oOpc20:lVisibleControl := .T.
oOpc20:bLClicked := {|| VldOpc("20") }

oOpc21 := TCHECKBOX():Create(oDlgAlt)
oOpc21:cName := "oOpc21"
oOpc21:cCaption := "21 - Data Programada"
oOpc21:nLeft := 28
oOpc21:nTop := 415
oOpc21:nWidth := 200
oOpc21:nHeight := 17
oOpc21:lShowHint := .F.
oOpc21:lReadOnly := .F.
oOpc21:Align := 0
oOpc21:cVariable := "lOpc21"
oOpc21:bSetGet := {|u| If(PCount()>0,lOpc21:=u,lOpc21) }
oOpc21:lVisibleControl := .T.
oOpc21:bLClicked := {|| VldOpc("21") }

oOpc22 := TCHECKBOX():Create(oDlgAlt)
oOpc22:cName := "oOpc22"
oOpc22:cCaption := "22 - e-mail"
oOpc22:nLeft := 28
oOpc22:nTop := 435
oOpc22:nWidth := 200
oOpc22:nHeight := 17
oOpc22:lShowHint := .F.
oOpc22:lReadOnly := .F.
oOpc22:Align := 0
oOpc22:cVariable := "lOpc22"
oOpc22:bSetGet := {|u| If(PCount()>0,lOpc22:=u,lOpc22) }
oOpc22:lVisibleControl := .T.
oOpc22:bLClicked := {|| VldOpc("22") }

oOpc23 := TCHECKBOX():Create(oDlgAlt)
oOpc23:cName := "oOpc23"
oOpc23:cCaption := "23 - Estado para Redespacho"
oOpc23:nLeft := 28
oOpc23:nTop := 455
oOpc23:nWidth := 200
oOpc23:nHeight := 17
oOpc23:lShowHint := .F.
oOpc23:lReadOnly := .F.
oOpc23:Align := 0
oOpc23:cVariable := "lOpc23"
oOpc23:bSetGet := {|u| If(PCount()>0,lOpc23:=u,lOpc23) }
oOpc23:lVisibleControl := .T.
oOpc23:bLClicked := {|| VldOpc("23") }

oOpc24 := TCHECKBOX():Create(oDlgAlt)
oOpc24:cName := "oOpc24"
oOpc24:cCaption := "24 - Observacao Cliente"
oOpc24:nLeft := 250
oOpc24:nTop := 15
oOpc24:nWidth := 200
oOpc24:nHeight := 17
oOpc24:lShowHint := .F.
oOpc24:lReadOnly := .F.
oOpc24:Align := 0
oOpc24:cVariable := "lOpc24"
oOpc24:bSetGet := {|u| If(PCount()>0,lOpc24:=u,lOpc24) }
oOpc24:lVisibleControl := .T.
oOpc24:bLClicked := {|| VldOpc("24") }

oOpc25 := TCHECKBOX():Create(oDlgAlt)
oOpc25:cName := "oOpc25"
oOpc25:cCaption := "25 - Agrega Itens do Pedido"
oOpc25:nLeft := 250
oOpc25:nTop := 35
oOpc25:nWidth := 200
oOpc25:nHeight := 17
oOpc25:lShowHint := .F.
oOpc25:lReadOnly := .F.
oOpc25:Align := 0
oOpc25:cVariable := "lOpc25"
oOpc25:bSetGet := {|u| If(PCount()>0,lOpc25:=u,lOpc25) }
oOpc25:lVisibleControl := .T.
oOpc25:bLClicked := {|| VldOpc("25") }

oOpc26 := TCHECKBOX():Create(oDlgAlt)
oOpc26:cName := "oOpc26"
oOpc26:cCaption := "26 - Excluir Referencia"
oOpc26:nLeft := 250
oOpc26:nTop := 55
oOpc26:nWidth := 200
oOpc26:nHeight := 17
oOpc26:lShowHint := .F.
oOpc26:lReadOnly := .F.
oOpc26:Align := 0
oOpc26:cVariable := "lOpc26"
oOpc26:bSetGet := {|u| If(PCount()>0,lOpc26:=u,lOpc26) }
oOpc26:lVisibleControl := .T.
oOpc26:bLClicked := {|| VldOpc("26") }

oOpc27 := TCHECKBOX():Create(oDlgAlt)
oOpc27:cName := "oOpc27"
oOpc27:cCaption := "27 - Data Valida Autonomo"
oOpc27:nLeft := 250
oOpc27:nTop := 75
oOpc27:nWidth := 200
oOpc27:nHeight := 17
oOpc27:lShowHint := .F.
oOpc27:lReadOnly := .F.
oOpc27:Align := 0
oOpc27:cVariable := "lOpc27"
oOpc27:bSetGet := {|u| If(PCount()>0,lOpc27:=u,lOpc27) }
oOpc27:lVisibleControl := .T.
oOpc27:bLClicked := {|| VldOpc("27") }

oOpc28 := TCHECKBOX():Create(oDlgAlt)
oOpc28:cName := "oOpc28"
oOpc28:cCaption := "28 - Promocao 5%"
oOpc28:nLeft := 250
oOpc28:nTop := 95
oOpc28:nWidth := 200
oOpc28:nHeight := 17
oOpc28:lShowHint := .F.
oOpc28:lReadOnly := .F.
oOpc28:Align := 0
oOpc28:cVariable := "lOpc28"
oOpc28:bSetGet := {|u| If(PCount()>0,lOpc28:=u,lOpc28) }
oOpc28:lVisibleControl := .T.
oOpc28:bLClicked := {|| VldOpc("28") }

DEFINE SBUTTON FROM 230, 120 TYPE 1 ACTION (oDlgAlt:End(),ProcOpc()) ENABLE OF oDlgAlt
DEFINE SBUTTON FROM 230, 165 TYPE 2 ACTION (oDlgAlt:End()) ENABLE OF oDlgAlt

Activate Dialog oDLGAlt Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcOpc()

//Carrega variaveis utilizadas pela funcao

Local aSX5,aSA1,aSC5
Local oDlga
Local aFRETE,cFRETE,cItens:=''
Local lSenha

Private cNomeUsu := cNome
Private cNomeSup := Space(10)
DBSELECTAREA("SX5")
aSX5:= GETAREA()
DBSELECTAREA("SA1")
aSA1:= GETAREA()
DBSELECTAREA("SC5")
aSC5:= GETAREA()
SX5->( DBSETORDER(1) )

For T := 1 To 24 //Testa os 24 pontos de alteracao
	_cOPC_ := StrZero(t,2)
	
	If &("lOpc"+STRZERO(T,2)) //Se estiver marcado verifica permissao do usuario
		_cOPC_ := IIf( STRZERO(T,2) = '12', '18', STRZERO(T,2) )
		_cOPC_ := IIf( STRZERO(T,2) = '13', '12', _cOPC_ )
		_cOPC_ := IIF( STRZERO(T,2) = '14', '38', _cOPC_ )
		_cOPC_ := IIF( STRZERO(T,2) = '15', '39', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '16', '35', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '17', '44', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '18', '45', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '19', '47', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '20', '47', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '21', '47', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '22', '48', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '23', '47', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '24', '50', _cOPC_ )
		_cOpc_ := IIF( STRZERO(T,2) = '25', '51', _cOPC_ )		
		_cOpc_ := IIF( STRZERO(T,2) = '27', '35', _cOPC_ )		 // Permiss๕es igual ao 16 - Data Sintegra
		_cOpc_ := IIF( STRZERO(T,2) = '28', '35', _cOPC_ )		 // Permiss๕es igual ao 16 - Data Sintegra
		
		DBSELECTAREA("SX5")
		DBSEEK(xFILIAL("SX5")+"ZU"+ _cOPC_ )
		
		//Se a senha do usuario e a do superior nao forem validas pede novo superior
		If !ALLTRIM(UPPER(cNomeUsu)) $ SX5->X5_DESCRI .And. !ALLTRIM(UPPER(cNomeSup)) $ SX5->X5_DESCRI
			Alert("Solicite senha do superior")
			Private cNome   := Space(15)
			Private _cSenha := Space(06)
			
			lSenhaSup := PFAT31SEN()
			
			If !lSenhaSup
				Alert("Senha do superior invalida")
				Alert("Opcao "+StrZero(t,2)+" nao sera processada")
				&("lOpc"+StrZero(t,2)) := .F.
			Else
				If !ALLTRIM(UPPER(cNomeSup)) $ SX5->X5_DESCRI
					Alert("Superior sem permissao para esta opcao "+StrZero(t,2))
					Alert("Opcao "+StrZero(t,2)+" nao sera processada")
					&("lOpc"+StrZero(t,2)) := .F.
				Endif
			Endif
		Endif
	Endif
Next

Private _C5_CONDPAG := SC5->C5_CONDPAG
Private _C5_DESC1   := SC5->C5_DESC1
Private _C5_DESC2   := SC5->C5_DESC2
Private _C5_DESC3   := SC5->C5_DESC3
Private _C5_DESC4   := SC5->C5_DESC4
Private lOk := .F.
Private aCOLS:={};aHEADER:={}
Private M->C5_TABELA  := SC5->C5_TABELA
Private M->C5_DESC1   := SC5->C5_DESC1
Private M->C5_DESC2   := SC5->C5_DESC2
Private M->C5_DESC3   := SC5->C5_DESC3
Private M->C5_DESC4   := SC5->C5_DESC4
Private M->C5_TIPO    := SC5->C5_TIPO
Private M->C5_CONDPAG := SC5->C5_CONDPAG
Private M->C5_COTACAO := SC5->C5_COTACAO
Private M->C5_NATUREZ := SC5->C5_NATUREZ
Private M->C5_VEND2   := SC5->C5_VEND2

_C5_CLIENTE := SA1->A1_COD
_C5_TRANSP  := SC5->C5_TRANSP
_C5_COTACAO := SC5->C5_COTACAO
_C5_MEN1    := SC5->C5_MENNOTA
_C5_MEN2    := SC5->C5_MENNOT2
_C5_COMIS1  := SC5->C5_COMIS1
_C5_VEND4   := SC5->C5_VEND4
Crep        := SC5->C5_VEND1
_A1_LOJA    := SA1->A1_LOJA
_C5_PESOL   := SC5->C5_PESOL
_C5_ESPECI1 := SC5->C5_ESPECI1
_C5_ESPCI3  := SC5->C5_ESPECI3
_C5_PBRUTO  := SC5->C5_PBRUTO
_C5_VEND2   := SC5->C5_VEND2

//Verifica se foram marcados e processa
If lOpc01
	lProc := .F.
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	//	@ 000, 000 BITMAP oBmp RESNAME 'LOGIN' oF oDlga SIZE 48,488 NOBORDER WHEN .F. PIXEL
	
	@ 010 , 0005 SAY "Dados do cliente :"
	@ 020 , 0005 SAY "Cliente : "  + SC5->C5_CLIENTE + " - " + SUBSTR(SA1->A1_NOME,1,40)
	@ 030 , 0005 SAY "Fantasia : " + SUBSTR(SA1->A1_NREDUZ,1,20)
	@ 040 , 0005 SAY "Fone : " + SA1->A1_TEL
	@ 050 , 0005 SAY "Fax : " + SA1->A1_FAX
	@ 060 , 0005 SAY "Contato : " + SA1->A1_CONTATO
	
	@ 080 , 0005 SAY "Cliente novo "
	
	@ 080, 0050 GET _C5_CLIENTE PICTURE "@!" F3 "SA1"  SIZE 40,10
	@ 080, 0100 GET _A1_LOJA     WHEN .F. SIZE 10,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cCod := _C5_CLIENTE
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF !EMPTY(SC5->C5_SERIE+SC5->C5_NOTA)
			ALERT("Pedido faturado, nao e' possivel alterar o cliente")
			oDL:End()
			Return(.F.)
		ENDIF
		
		SA1->( DbSeek( xFilial("SA1") + cCod, .T. ) )
		If SA1->A1_COD <> cCod
			ALERT("Cliente nใo cadastrado, verifique o c๓digo digitado")
			oDL:End()
			Return(.F.)
		Else
			cLoj := SA1->A1_LOJA
		EndIf
		
		CPEND := ZAL->ZAL_MTPENC
		
		cPEND += "AP5 - ALTERACAO DE CLIENTE " + SPACE(43)
		cPEND += "CLIENTE ANTIGO : "+ SC5->C5_CLIENTE+ " LOJA : "+ SC5->C5_LOJACLI +SPACE(37)
		cPEND += "CLIENTE NOVO   : "+ cCOD+ " LOJA : "+ cLOJ + SPACE(37)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
		cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
		RECLOCK("SC5",.F.)
		SC5->C5_CLIENTE := cCOD
		SC5->C5_LOJACLI := cLOJ
		SC5->C5_LOJAENT := cLOJ
		MSUNLOCK()
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENC := memotran(cPEND)
		MSUNLOCK()
		
		SC6->( DBSETORDER(1) )
		SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )
		WHILE SC6->C6_NUM = SC5->C5_NUM
			
			RECLOCK("SC6",.F.)
			SC6->C6_CLI  := cCOD
			SC6->C6_LOJA := cLOJ
			SC6->C6_CF   := IF( SA1->A1_EST == 'PE', '5', '6' ) + SUBSTR(SC6->C6_CF,2,3)
			MSUNLOCK()
			If SC5->C5_TIPO <> 'D'
				U_IPIItem(SC5->C5_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,.F.)
			EndIf
			SC6->( DBSKIP() )
		ENDDO
		
		SC9->( DBSETORDER(1) )
		SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM) )
		WHILE SC9->C9_PEDIDO = SC5->C5_NUM
			RECLOCK("SC9",.F.)
			SC9->C9_CLIENTE  := cCOD
			SC9->C9_LOJA     := cLOJ
			MSUNLOCK()
			SC9->( DBSKIP() )
		ENDDO
	Endif
Endif

If lOpc02 .Or. lOpc11 //Alteraco da cond de pagamento(em Vendas e Fora de Vendas)
	lProc  := .F.
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus"  PIXEL OF oMainWnd
	
	@ 010 , 0008 SAY "Alteracao da condicao de pagamento :"
	@ 020 , 0008 SAY "Condicao : "
	
	@ 030 , 0008 SAY "Desconto 1 : "
	@ 030 , 0100 SAY "Desconto 2 : "
	@ 040 , 0008 SAY "Desconto 3 : "
	@ 040 , 0100 SAY "Desconto 4 : "
	
	@ 020 , 0050 GET _C5_CONDPAG   PICTURE '!!!' F3 "CPV" SIZE 10,10
	@ 030 , 0050 GET _C5_DESC1     PICTURE '@R 99.99' SIZE 10,10
	@ 030 , 0142 GET _C5_DESC2     PICTURE '@R 99.99' SIZE 10,10
	@ 040 , 0050 GET _C5_DESC3     PICTURE '@R 99.99' SIZE 10,10
	@ 040 , 0142 GET _C5_DESC4     PICTURE '@R 99.99' SIZE 10,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cCond := _C5_CONDPAG
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		SE4->( DBSETORDER(1) )
		SE4->( DBSEEK(xFILIAL("SE4")+cCOND) )
		
		IF AllTrim(SC5->C5_COTACAO) $ '12' .AND. SE4->E4_NATUREZ = '10104'
			ALERT("A nova condicao de pagamento nao permite que o pedido tenha licitacao, mude a licitacao do pedido.")
			RETURN
		ENDIF
		
		cPEND := ZAL->ZAL_MTPENC
		cPEND += "AP5 - ALTERACAO DE COND. PAGTO " + SPACE(39)
		cPEND += "TIPO DE CONDICAO ANTIGA : "+ SC5->C5_CONDPAG +SPACE(41)
		cPEND += "TIPO DE CONDICAO NOVA   : "+ cCOND + SPACE(41)
		IF (SC5->C5_DESC1<>_C5_DESC1) .OR. (SC5->C5_DESC2<>_C5_DESC2) .OR. (SC5->C5_DESC3<>_C5_DESC3) .OR. (SC5->C5_DESC4<>_C5_DESC4)
			cPEND += "DESCONTO ANTIGO  : "+ ALLTRIM(STR(SC5->C5_DESC1))+"+"+ALLTRIM(STR(SC5->C5_DESC2))+"+"+ALLTRIM(STR(SC5->C5_DESC3))+"+"+ALLTRIM(STR(SC5->C5_DESC4))+SPACE(35)
			cPEND += "DESCONTO NOVO    : "+ ALLTRIM(STR(_C5_DESC1))+"+"+ALLTRIM(STR(_C5_DESC2))+"+"+ALLTRIM(STR(_C5_DESC3))+"+"+ALLTRIM(STR(_C5_DESC4))+SPACE(35)
		ENDIF
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
		cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
		
		
		IF (SC5->C5_DESC1<>_C5_DESC1) .OR. (SC5->C5_DESC2<>_C5_DESC2) .OR. (SC5->C5_DESC3<>_C5_DESC3) .OR. (SC5->C5_DESC4<>_C5_DESC4)
			SC6->( DBSETORDER(1) )
			SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )
			WHILE SC6->C6_NUM = SC5->C5_NUM
				_nVALOR  := SC6->C6_PRUNIT
				IF ( _C5_DESC1+_C5_DESC2+_C5_DESC3+_C5_DESC4 ) > 0
					IIF(_C5_DESC1 > 0 , _nVALOR -= (_nVALOR*_C5_DESC1)/100,0)
					IIF(_C5_DESC2 > 0 , _nVALOR -= (_nVALOR*_C5_DESC2)/100,0)
					IIF(_C5_DESC3 > 0 , _nVALOR -= (_nVALOR*_C5_DESC3)/100,0)
					IIF(_C5_DESC4 > 0 , _nVALOR -= (_nVALOR*_C5_DESC4)/100,0)
				ENDIF
				
				IIF(SC6->C6_DESCONT > 0 , _nDESC :=  (_nVALOR*SC6->C6_DESCONT)/100,_nDESC:=0)
				
				IIF(SC6->C6_DESCONT > 0 , _nVALOR -= (_nVALOR*SC6->C6_DESCONT)/100,0)
				
				_nDESCIPI := IIf(!Empty(SC6->C6_PIPI),( _nVALOR - Round( _nVALOR / ( 1 + SC6->C6_PIPI/100 ), 4 ) ) * SC6->C6_QTDVEN,0)
				_nVALOR   -= Round(_nDESCIPI / SC6->C6_QTDVEN, 4)
				
				RECLOCK("SC6", .F.)
				SC6->C6_PRCVEN  := _nVALOR
				SC6->C6_VALOR   := (_nVALOR*SC6->C6_QTDVEN)
				SC6->C6_VALDESC := _nDESC
				SC6->C6_DESCIPI := _nDESCIPI
				MSUNLOCK()
				
				SC9->( DBSETORDER(9) )            // MUDOU A ORDEM DE 5 PARA 9 .... ALTER_FATSEN_G2 1
				IF SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO) )
					RECLOCK("SC9",.F.)
					SC9->C9_PRCVEN := _nVALOR
					MSUNLOCK()
				ENDIF
				
				SC6->( DBSKIP() )
			ENDDO
		ENDIF
		SE4->( DBSETORDER(1) )
		SE4->( DBSEEK(xFILIAL("SE4")+cCOND) )
		// Armazenar vencimentos fixos de acordo com a condicao de pagamento, alterado por Adilson em 30/08/2004
		If SE4->E4_TIPO == '9' //Verifica se Condicao de Pagto tem vencimento fixo
			dDATA1 := U_CONDPROM(cCOND)[1][1] //GetMv("MV_DTPARC1") //Parametro data da primeira parcela
			dDATA2 := U_CONDPROM(cCOND)[2][1] //GetMv("MV_DTPARC2") //Parametro data da segunda parcela
			dDATA3 := U_CONDPROM(cCOND)[3][1] //GetMv("MV_DTPARC3") //Parametro data da terceira parcela
			dDATA4 := U_CONDPROM(cCOND)[4][1] //GetMv("MV_DTPARC4") //Parametro data da terceira parcela
			nParc1 := U_CONDPROM(cCOND)[1][2] //GetMv("MV_PEPARC1") //Parametro percentual da parcela 1
			nParc2 := U_CONDPROM(cCOND)[2][2] //GetMv("MV_PEPARC2") //Parametro percentual da parcela 2
			nParc3 := U_CONDPROM(cCOND)[3][2] //GetMv("MV_PEPARC3") //Parametro percentual da parcela 3
			nParc4 := U_CONDPROM(cCOND)[4][2] //GetMv("MV_PEPARC4") //Parametro percentual da parcela 4
		Else
			dData1 := CTOD("")
			dData2 := CTOD("")
			dData3 := CTOD("")
			dData4 := CTOD("")
			nParc1 := 0
			nParc2 := 0
			nParc3 := 0
			nParc4 := 0
		EndIf
		//Informa a Natureza correta nos LIC
		cNatureza := IIF(Alltrim(SC5->C5_NATUREZ) <> '10108',U_NATNF(cCOND),'10108')
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENC := memotran(cPEND)
		msunlock()
		
		RECLOCK("SC5",.F.)
		SC5->C5_CONDPAG := cCOND
		SC5->C5_NATUREZ := cNatureza
		IF (SC5->C5_DESC1<>_C5_DESC1) .OR. (SC5->C5_DESC2<>_C5_DESC2) .OR. (SC5->C5_DESC3<>_C5_DESC3) .OR. (SC5->C5_DESC4<>_C5_DESC4)
			SC5->C5_DESC1 := _C5_DESC1
			SC5->C5_DESC2 := _C5_DESC2
			SC5->C5_DESC3 := _C5_DESC3
			SC5->C5_DESC4 := _C5_DESC4
		ENDIF
		// Gravar vencimentos fixos de acordo com a condicao de pagamento, alterado por Adilson em 30/08/2004
		SC5->C5_DATA1    := dData1
		SC5->C5_DATA2    := dData2
		SC5->C5_DATA3    := dData3
		SC5->C5_DATA4    := dData4
		SC5->C5_PARC1    := nParc1
		SC5->C5_PARC2    := nParc2
		SC5->C5_PARC3    := nParc3
		SC5->C5_PARC4    := nParc4
		MSUNLOCK()
		// Alterado por Ana em 18/02/2004
		_aRet     := U_AVALPVN( SC5->C5_NUM )
		nValAbat  := _aRet[3]
		If nValAbat > 0 .And. ! Left( SC5->C5_NUM, 1 ) $ 'LRM'
			If IW_MSGBOX("Abate "+Alltrim(str(round(nValAbat,2)))+"% da comissao do Vendedor ?","Escolha","YESNO")
				Dbselectarea("ZZC")
				Reclock("ZZC",.T.)
				Replace ZZC_FILIAL With xFilial()
				Replace ZZC_PEDIDO With SC5->C5_NUM
				Replace ZZC_DEBOK  With "N"
				Replace ZZC_DTAPRO With dDatabase
				Replace ZZC_APROVA With cUsuario
				Replace ZZC_HORA   With Time()
				Replace ZZC_VALIDO With "S"
				Replace ZZC_OCOR   With MemoTran('Prazo medio maior que o permitido, altera็ใo de cond.pagamento.')
				Replace ZZC_DEBCOM With nValAbat
				Replace ZZC_DEBOK1 With "S"
				msunlock()
			EndIf
		EndIf
		Processa( { || PFAT31_Qry() } )
	Endif
Endif

If lOpc03
	lProc := .F.
	IIF(SC5->C5_TPFRETE = 'C' , aFrete:={"Frete CIF","Frete FOB"}, aFrete:={"Frete FOB","Frete CIF"})
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 010 , 0008 SAY "Alteracao de frete :"
	@ 020 , 0008 SAY "Tipo de frete : "
	@ 020 , 0050 COMBOBOX cFrete ITEMS aFrete SIZE 080, 43
	
	@ 040 , 0008 SAY "Transportadora : "
	@ 040 , 0050 GET _C5_TRANSP WHEN .T. SIZE 40,10 F3 'SA4'
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		lTransp := .F.
		lFrete := .F.
		cTRANS := _C5_TRANSP
		cFRT   := cFRETE
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF cTRANS <> SC5->C5_TRANSP
			lTransp  := .T.
		ENDIF
		
		IF IIF(cFRT = 'Frete CIF' , 'C' , 'F') <> SC5->C5_TPFRETE
			lFrete   := .T.
		ENDIF
		
		IF lTRANSP .OR. lFRETE
			CPEND := ZAL->ZAL_MTPENF
			cPEND += "AP5 - ALTERACAO DE FRETE " + SPACE(43)
			RECLOCK("SC5",.F.)
			IF lFRETE
				cPEND += "TIPO DE FRETE ANTIGO : "+ IIF(SC5->C5_TPFRETE = 'C' , 'FRETE CIF' , 'FRETE FOB') +SPACE(38)
				cPEND += "TIPO DE FRETE NOVO   : "+ cFRT + SPACE(38)
				SC5->C5_TPFRETE := IIF(cFRT = 'Frete CIF' , 'C' , 'F')
			ENDIF
			IF lTRANSP
				cPEND += "TRANSPORTADORA ANTIGA : "+ SC5->C5_TRANSP +SPACE(41)
				cPEND += "TRANSPORTADORA NOVA   : "+ cTRANS +SPACE(41)
				SC5->C5_TRANSP := cTRANS
			ENDIF
			
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENF := memotran(cPEND)
			MSUNLOCK()
		ENDIF
	Endif
Endif

If lOpc04
	lProc := .F.
	aCOLS   := aCOLSC6
	aHEADER := aHEADERC6
	Dbselectarea("SC5")
	DEFINE MSDIALOG oDlga FROM -050,0 TO 300,600 TITLE 'Pedido Original' OF oMainWnd PIXEL
	
	oGetDados:=IW_MultiLine(001,001,150,300,.t.,.t.,{|| VDLOPC04GET() },)
	DEFINE SBUTTON FROM 155,150 TYPE 01 ACTION {|| oDlga:End(), lProc := .T. }  ENABLE //OF oDlga
	DEFINE SBUTTON FROM 155,200 TYPE 02 ACTION (oDlga:End())                 ENABLE //OF oDlga
	
	ACTIVATE DIALOG oDlga CENTERED
	
	If lProc
		aITEM     := aCols
		nXI       :=0
		_nDescPed := 100
		_PrcVen   := 0
		_nDescPed := IIf( !Empty( SC5->C5_DESC1 ), _nDescPed - SC5->C5_DESC1, _nDescPed )
		_nDescPed := IIf( !Empty( SC5->C5_DESC2 ), _nDescPed - (_nDescPed*(SC5->C5_DESC2/100)), _nDescPed )
		_nDescPed := IIf( !Empty( SC5->C5_DESC3 ), _nDescPed - (_nDescPed*(SC5->C5_DESC3/100)), _nDescPed )
		_nDescPed := IIf( !Empty( SC5->C5_DESC4 ), _nDescPed - (_nDescPed*(SC5->C5_DESC4/100)), _nDescPed )
		_nDescPed := 100 - _nDescPed
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		FOR nXI:=1 TO LEN(aITEM)
			
			nSB2:=0
			SC6->( DBSETORDER(1) )
			
			IF SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM+aITEM[nXI,1]+aITEM[nXI,2]) ) .AND. !aITEM[nXI,14]
				
				_PrcVen := Round(SC6->C6_PRUNIT*((100-_nDescPed)/100)*((100-aITEM[nXI,11])/100),4)
				
				IF ( SC6->C6_QTDVEN  <> aITEM[nXI,04] ) .OR. ( SC6->C6_LOCAL   <> aITEM[nXI,08] ) // Testa a quantidade
					
					SB2->( DBSETORDER(1) )
					SB2->( DBSEEK(xFILIAL("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL) )
					RECLOCK("SB2",.F.)
					SB2->B2_RESERVA -= SC6->C6_QTDEMP
					MSUNLOCK()
					
					SB2->( DBSETORDER(1) )
					SB2->( DBSEEK(xFILIAL("SB2")+SC6->C6_PRODUTO+aITEM[nXI,08]) )
					IF aITEM[nXI,04] <= ( SB2->B2_QATU - SB2->B2_RESERVA )
						RECLOCK("SB2",.F.)
						SB2->B2_RESERVA += aITEM[nXI,04]
						MSUNLOCK()
						
						RECLOCK("SC6",.F.)
						SC6->C6_QTDEMP := aITEM[nXI,04]
						SC6->C6_QTDVEN := aITEM[nXI,04]
						SC6->C6_LOCAL  := aITEM[nXI,08]
						MSUNLOCK()
					ELSE
						nSB2 := ( SB2->B2_QATU - SB2->B2_RESERVA )
						RECLOCK("SB2",.F.)
						SB2->B2_RESERVA += nSB2
						MSUNLOCK()
						
						RECLOCK("SC6",.F.)
						SC6->C6_QTDEMP := nSB2
						SC6->C6_QTDVEN := aITEM[nXI,04]
						SC6->C6_LOCAL  := aITEM[nXI,08]
						MSUNLOCK()
						
						SC9->( DBSETORDER(9) ) //MUDOU A ORDEM DE 5 PARA 9
						IF SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO) )
							RECLOCK("SC9",.F.)
							SC9->C9_QTDLIB := nSB2
							SC9->C9_LOCAL  := aITEM[nXI,08]
							MSUNLOCK()
						ENDIF
					ENDIF
				ENDIF
				
				IF ( SC6->C6_PRCVEN + Round( SC6->C6_DESCIPI / SC6->C6_QTDVEN, 4 ) <> aITEM[nXI,05] ) .OR. ( SC6->C6_VALOR + SC6->C6_DESCIPI <> aITEM[nXI,06] ) .OR. ;
					( SC6->C6_DESCONT <> aITEM[nXI,11] ) .OR. ( SC6->C6_VALDESC <> aITEM[nXI,12] ) .OR. ;
					( SC6->C6_TES     <> aITEM[nXI,09] )
					
					RECLOCK("SC6",.F.)
					SC6->C6_PRCVEN  := _PrcVen  // aITEM[nXI,05] AlTERADO POR ANA - IPI
					SC6->C6_VALOR   := aITEM[nXI,04]*_PrcVen
					SC6->C6_DESCONT := aITEM[nXI,11]
					SC6->C6_VALDESC := Round((aITEM[nXI,04]*_PrcVen)*aITEM[nXI,11]/100,4)
					SC6->C6_TES     := aITEM[nXI,09]
					MSUNLOCK()
					SC9->( DBSETORDER(9) )  //MUDOU A ORDEM DE 5 PARA 9
					IF SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO) )
						RECLOCK("SC9",.F.)
						SC9->C9_PRCVEN := _PrcVen
						MSUNLOCK()
					ENDIF
				ENDIF
				
				SC9->( DBSETORDER(9) )  //MUDOU A ORDEM DE 5 PARA 9
				IF !SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO) )
					SB2->( DBSETORDER(1) )
					SB2->( DBSEEK(xFILIAL("SB2")+SC6->C6_PRODUTO+aITEM[nXI,08]) )
					nSB2 := ( SB2->B2_QATU - SB2->B2_RESERVA )
					
					SB1->( DBSETORDER(1) )
					SB1->( DBSEEK(xFILIAL("SB1")+SC6->C6_PRODUTO) )
					IF nSB2 > 0
						RECLOCK("SC9",.T.)
						SC9->C9_FILIAL  := xFILIAL("SC9")
						SC9->C9_PEDIDO  := SC5->C5_NUM
						SC9->C9_ITEM    := aITEM[nXI,01]
						SC9->C9_CLIENTE := SC5->C5_CLIENTE
						SC9->C9_LOJA    := SC5->C5_LOJACLI
						SC9->C9_PRODUTO := SC6->C6_PRODUTO
						IF aITEM[nXI,04] <= nSB2
							SC9->C9_QTDLIB  := aITEM[nXI,04]
						ELSE
							SC9->C9_QTDLIB  := nSB2
						ENDIF
						SC9->C9_DATALIB := DDATABASE
						SC9->C9_SEQUEN  := '01'
						SC9->C9_GRUPO   := SB1->B1_GRUPO
						SC9->C9_PRCVEN  := _PrcVen
						SC9->C9_LOCAL   := aITEM[nXI,08]
						MSUNLOCK()
						RECLOCK("SB2",.F.)
						IF aITEM[nXI,04] <= nSB2
							SB2->B2_RESERVA  += aITEM[nXI,04]
						ELSE
							SB2->B2_RESERVA  += nSB2
						ENDIF
						MSUNLOCK()
					ENDIF
					
				ENDIF
			ELSE
				SC6->( DBSETORDER(1) )
				_PrcVen := Round(aITEM[nXI,13]*((100-_nDescPed)/100)*((100-aITEM[nXI,11])/100),4)
				IF SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM+aITEM[nXI,1]) )
					
					SC9->( DBSETORDER(9) )  //MUDOU A ORDEM DE 5 PARA 9
					IF SC9->( DBSEEK(xFILIAL("SC9")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO) )
						RECLOCK("SC9",.F.)
						DELETE
						MSUNLOCK()
					ENDIF
					
					SB2->( DBSETORDER(1) )
					SB2->( DBSEEK(xFILIAL("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL) )
					
					RECLOCK("SB2",.F.)
					SB2->B2_RESERVA -= SC6->C6_QTDEMP
					MSUNLOCK()
					
					RECLOCK("SC6",.F.)
					DELETE
					MSUNLOCK()
				ENDIF
				
				IF !aITEM[nXI,14]
					SB2->( DBSETORDER(1) )
					SB2->( DBSEEK(xFILIAL("SB2")+aITEM[nXI,02]+aITEM[nXI,08]) )
					nSB2 := ( SB2->B2_QATU - SB2->B2_RESERVA )
					
					RECLOCK("SC6",.T.)
					SC6->C6_FILIAL   := xFILIAL("SC6")
					SC6->C6_ITEM     := aITEM[nXI,01]
					SC6->C6_PRODUTO  := aITEM[nXI,02]
					SC6->C6_UM       := aITEM[nXI,03]
					SC6->C6_QTDVEN   := aITEM[nXI,04]
					SC6->C6_PRCVEN   := _PrcVen // aITEM[nXI,05]
					SC6->C6_VALOR    := aITEM[nXI,04]*_PrcVen // aITEM[nXI,06]
					SC6->C6_TES      := aITEM[nXI,09]
					SC6->C6_CF       := aITEM[nXI,10]
					SC6->C6_LOCAL    := aITEM[nXI,08]
					IF aITEM[nXI,04] > nSB2
						SC6->C6_QTDEMP   := nSB2
					ELSE
						SC6->C6_QTDEMP   := aITEM[nXI,04]
					ENDIF
					SC6->C6_CLI      := SC5->C5_CLIENTE
					SC6->C6_DESCONT  := aITEM[nXI,11]
					SC6->C6_VALDESC  := Round((aITEM[nXI,04]*_PrcVen)*aITEM[nXI,11]/100,4)
					SC6->C6_ENTREG   := DDATABASE
					SC6->C6_LOJA     := SC5->C5_LOJACLI
					SC6->C6_NUM      := SC5->C5_NUM
					SC6->C6_DESCRI   := aITEM[nXI,07]
					SC6->C6_PRUNIT   := aITEM[nXI,13]
					MSUNLOCK()
				ENDIF
				SB1->( DBSETORDER(1) )
				SB1->( DBSEEK(xFILIAL("SB1")+aITEM[nXI,02]) )
				IF nSB2 > 0
					RECLOCK("SC9",.T.)
					SC9->C9_FILIAL  := xFILIAL("SC9")
					SC9->C9_PEDIDO  := SC5->C5_NUM
					SC9->C9_ITEM    := aITEM[nXI,01]
					SC9->C9_CLIENTE := SC5->C5_CLIENTE
					SC9->C9_LOJA    := SC5->C5_LOJACLI
					SC9->C9_PRODUTO := aITEM[nXI,02]
					IF aITEM[nXI,04] > nSB2
						SC9->C9_QTDLIB  := nSB2
					ELSE
						SC9->C9_QTDLIB  := aITEM[nXI,04]
					ENDIF
					SC9->C9_DATALIB := DDATABASE
					SC9->C9_SEQUEN  := '01'
					SC9->C9_GRUPO   := SB1->B1_GRUPO
					SC9->C9_PRCVEN  := aITEM[nXI,05]
					SC9->C9_LOCAL   := aITEM[nXI,08]
					MSUNLOCK()
					RECLOCK("SB2",.F.)
					IF aITEM[nXI,04] > nSB2
						SB2->B2_RESERVA += nSB2
					ELSE
						SB2->B2_RESERVA += aITEM[nXI,04]
					ENDIF
					
					MSUNLOCK()
				ENDIF
				
			ENDIF
		NEXT
		
		U_CalcIPI(SC5->C5_NUM)
		
		IF LEN(aITEM) > 0
			CPEND := ZAL->ZAL_MTPENV
			cPEND += "AP5 - ALTERACAO DE ITENS " + SPACE(43)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENV := memotran(cPEND)
			MSUNLOCK()
		ENDIF
	Endif
	Processa( { || PFAT31_Qry() } )
Endif
         
/*
If lOpc05
	lProc := .F.
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 030, 0008 SAY "Alteracao da Licitacao :"
	
	@ 040, 0008 SAY "Licitacao : "
	@ 040, 0050 GET _C5_COTACAO   PICTURE '!'  SIZE 10,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cCOTA := _C5_COTACAO
		lCOTACAO:=.F.
		IF ! (Left(cCOTA,1)$' 7')
			Alert("Licitacao invalida")
			Return(.F.)
		ENDIF
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF cCOTA <> SC5->C5_COTACAO
			lCOTACAO  := .T.
		ENDIF
		
		IF  lCOTACAO
			CPEND := ZAL->ZAL_MTPENF
			cPEND += "AP5 - ALTERACAO DE LICITACAO " + SPACE(43)
			cPEND += "LICITACAO ANTIGA  : "+ ALLTRIM(SC5->C5_COTACAO) + SPACE(48)
			cPEND += "LICITACAO NOVA    : "+ ALLTRIM(cCOTA) + SPACE(48)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("SC5",.F.)
			SC5->C5_COTACAO := cCOTA
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENF := MEMOTRAN(cPEND)
			MSUNLOCK()
		ENDIF
	Endif
	
Endif
*/

If lOpc06
	lProc := .F.
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,700 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 030 , 0008 SAY "Alteracao de mensagens :"
	
	@ 040 , 0008 SAY "Mensagem 1 : "
	@ 050 , 0008 SAY "Mensagem 2 : "
	@ 040 , 0050 GET _C5_MEN1   PICTURE '@!'  SIZE 140,10
	@ 050 , 0050 GET _C5_MEN2   PICTURE '@!'  SIZE 140,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		CPEND := ZAL->ZAL_MTPENX
		cPEND += "AP5 - ALTERACAO DE MENSAGEM  " + SPACE(43)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
		cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
		
		RECLOCK("SC5",.F.)
		SC5->C5_MENNOTA := _C5_MEN1
		SC5->C5_MENNOT2 := _C5_MEN2
		MSUNLOCK()
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
	Endif
	
Endif
//aqui
If lOpc07
	lProc := .F.
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Alteracao de representante :"
	@ 060 , 0008 SAY "Representante : "
	@ 060 , 0050 GET cREP    PICTURE "@!" F3 "SA3"  SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		lADM:=.F.
		lrep:=.F.
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF ALLTRIM(cNomeUsu)="Administrador"
			lADM := .T.
		ENDIF
		
		IF cREP <> SC5->C5_VEND1
			lREP  := .T.
		ENDIF
		
		IF  lREP
			CPEND := ZAL->ZAL_MTPENV
			cPEND += "AP5 - ALTERACAO DE REPRESENTANTE " + SPACE(37)
			cPEND += "REPRESENTANTE ANTIGO  : "+ SC5->C5_VEND1 + SPACE(48)
			cPEND += "REPRESENTANTE NOVO    : "+ cREP          + SPACE(48)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("SC5",.F.)
			SC5->C5_VEND1   := cREP
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENV := MEMOTRAN(cPEND)
			MSUNLOCK()
			
			IF lADM
				
				SF2->( DBSETORDER(1) )
				IF SF2->( DBSEEK(xFILIAL("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )
					RECLOCK("SF2",.F.)
					SF2->F2_VEND1 := cREP
					MSUNLOCK()
				ENDIF
				
				SE1->( DBSETORDER(2) )
				IF SE1->( DBSEEK(xFILIAL("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_SERIE+SC5->C5_NOTA) )
					WHILE SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM = SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_SERIE+SC5->C5_NOTA
						RECLOCK("SE1",.F.)
						SE1->E1_VEND1 := cREP
						MSUNLOCK()
						SE1->( DBSKIP() )
					END
				ENDIF
			ENDIF
		ENDIF
	Endif
Endif

If lOpc08
	lProc := .F.
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Alteracao de comissao "
	@ 060 , 0008 SAY "Comissao : "
	@ 060 , 0050 GET _C5_COMIS1   PICTURE PESQPICT("SC5","C5_COMIS1")   SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		
		nComis := _C5_COMIS1
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF nCOMIS <> SC5->C5_COMIS1
			CPEND := ZAL->ZAL_MTPENV
			cPEND += "AP5 - ALTERACAO DE COMISSAO      " + SPACE(37)
			cPEND += "COMISSAO  ANTIGA  : "+ TRANSFORM(SC5->C5_COMIS1,"@R 999.99") + SPACE(44)
			cPEND += "COMISSAO  NOVA    : "+ TRANSFORM(nCOMIS,"@R 999.99") + SPACE(44)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("SC5",.F.)
			SC5->C5_COMIS1  := nCOMIS
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENV := MEMOTRAN(cPEND)
			MSUNLOCK()
			
			if !Empty(SC5->C5_NOTA)
				dbselectarea("ZZK")
				dbsetorder(1)
				dbselectarea("SE1")
				dbsetorder(21)
				dbseek( xFilial("SE1") + SC5->C5_SERIE + SC5->C5_NOTA )
				While SE1->(!Eof()) .And. SC5->C5_SERIE + SC5->C5_NOTA = SE1->E1_SERIE + SE1->E1_NUM
					RecLock("SE1")
					SE1->E1_VALCOM1 := Round( SE1->E1_BASCOM1 * nCOMIS / 100, 2 )
					SE1->E1_COMIS1  := nComis
					MsUnLock()
					ZZK->( dbseek( xFilial("SZK") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA ) )
					While ZZK->(!Eof()) .And. SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA = ZZK->ZZK_PREFIX + ZZK->ZZK_NUM + ZZK->ZZK_PARCEL
						if Empty(ZZK->ZZK_DATA)
							RecLock("ZZK")
							ZZK->ZZK_COMIS  := Round( ZZK->ZZK_BASE * nCOMIS / 100, 2 )
							ZZK->ZZK_PORC   := nComis
							MsUnLock()
						EndIf
						ZZK->(DBSKIP())
					end
					SE1->(dbskip())
				End
			endif
		ENDIF
		
	Endif
	
Endif

If lOpc09
	lProc := .F.
	cFora := SA1->A1_FORA
	IIF(SA1->A1_FORA = 'S' , aFora:={"Sim","Nao"}, aFora:={"Nao","Sim"})
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Cliente Fora da Area ?"
	@ 060 , 0008 SAY "Fora da Area : "
	@ 060 , 0050 COMBOBOX cFora ITEMS aFora SIZE 080, 43
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cNomFora := cFora
		cFora    := Substr(cFora,1,1)
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF cFora <> SA1->A1_FORA
			CPEND := ZAL->ZAL_MTPENE
			cPEND += "CLIENTE FORA A AREA        "+cNomFora+" "+ SPACE(37)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "FIM DA ALTERACAO     " + SPACE(43)

			RECLOCK("SA1",.F.)			
			SA1->A1_FORA   := cFora
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENE := MEMOTRAN(cPEND)
			MSUNLOCK()
			
		ENDIF
	Endif
Endif

If lOpc10
	lProc := .F.
	//So apresenta, nao tem nenhum processamento
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 030 , 0008 SAY "Visualiza peso de pedidos :"
	
	@ 040 , 0008 SAY "Peso calculado : "
	@ 050 , 0008 SAY "Peso informado : "
	
	@ 040 , 0050 GET _C5_PBRUTO   PICTURE '@E 9,999.99'  WHEN .F. SIZE 40,10
	@ 050 , 0050 GET _C5_PESOL    PICTURE '@E 9,999.999'  WHEN .F. SIZE 40,11
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
Endif

//O 11บ Processo esta junto ao 03บ

If lOpc12
	lProc := .F.
	_C5_DESC1 := 0.0
	_C5_VEND2 := IIF( AllTrim(_C5_VEND2) <> "S", "S     ", "N     " )
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,700 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 010 , 0005 SAY "Dados do cliente :"
	@ 020 , 0005 SAY "Cliente : "  + SC5->C5_CLIENTE + " - " + SUBSTR(SA1->A1_NOME,1,40)
	@ 030 , 0005 SAY "Fantasia : " + SUBSTR(SA1->A1_NREDUZ,1,20)
	@ 040 , 0005 SAY "Fone : " + SA1->A1_TEL
	@ 040 , 0060 SAY "Fax : " + SA1->A1_FAX
	@ 050 , 0005 SAY "Contato : " + SA1->A1_CONTATO
	
	@ 070 , 0005 SAY "Promocao :"
	
	@ 070, 0050 GET _C5_VEND2 PICTURE "@!" VALID Alltrim(_C5_VEND2) $ 'SN'
	@ 080, 0050 GET _C5_DESC1 PICTURE '@R 99.99' VALID _C5_DESC1 <= 20.0  SIZE 10,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		If ( AllTrim(_C5_VEND2) == "S"  .And. AllTrim(SC5->C5_VEND2) <> 'S' ) .Or. ( AllTrim(_C5_VEND2) == "N"  .And. AllTrim(SC5->C5_VEND2) == 'S' )
			SC6->( DBSETORDER(1) )
			SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )
			WHILE SC6->C6_NUM = SC5->C5_NUM
				  SB1->( DBSEEK("  "+SC6->C6_PRODUTO) )
				  If SB1->B1_PROMOC == 'S'
				     RECLOCK("SC6",.F.)
				     If AllTrim(_C5_VEND2) == "S"  .And. AllTrim(SC5->C5_VEND2) <> 'S'
				        SC6->C6_DESCOC += ( ( 100 - SC6->C6_DESCOC ) * ( _C5_DESC1 / 100 ) )
				     ElseIf AllTrim(_C5_VEND2) == "N"  .And. AllTrim(SC5->C5_VEND2) == 'S'
				   	    SC6->C6_DESCOC := Round( ( SC6->C6_DESCOC - _C5_DESC1 ) / ( 1 - ( _C5_DESC1 / 100 ) ), 2)
				     EndIf
				     MSUNLOCK()
				     If SC5->C5_TIPO <> 'D'
				        U_IPIItem(SC5->C5_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,.T.)
				     EndIf
				  EndIf
				  SC6->( DBSKIP() )
			ENDDO
			cPEND := ZAL->ZAL_MTPENV
			cPEND += "AP5 - ALTERACAO DE PROMOCAO  " + SPACE(43)
			cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPend += "Desconto : "+TRANSFORM(_C5_DESC1,"@E 99.99") + "   Promo็ใo: "+ _C5_VEND2 + space(17)
			cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("SC5",.F.)
			SC5->C5_VEND2   := _C5_VEND2
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENV := cPEND
			MSUNLOCK()
		EndIf
	Endif
Endif

If lOpc13
	lProc := .F.
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Altera Peso/Volume :"
	@ 060 , 0008 SAY "Peso    : "
	@ 060 , 0050 GET _C5_PESOL   PICTURE "@E 99,999.999" SIZE 40,10
	@ 070 , 0008 SAY "Volume  : "
	@ 070 , 0050 GET _C5_ESPECI1 PICTURE "@!"            SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cPeso   := _C5_PESOL
		cVolume := _C5_ESPECI1
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		IF cPeso <> SC5->C5_PESOL .OR. cVolume <> SC5->C5_ESPECI1
			CPEND := ZAL->ZAL_MTPENE
			cPEND += "AP7 - ALTERACAO DE PESO/VOLUME   " + SPACE(37)
			cPEND += "PESO/VOLUME ANTIGO : " + TRANSFORM(SC5->C5_PESOL,"@E 99,999.999")+'  -  '+ALLTRIM(SC5->C5_ESPECI1) + SPACE(28)
			cPEND += "PESO/VOLUME NOVO   : " + TRANSFORM(cPeso,"@E 99,999.999")+'  -  '+ALLTRIM(cVolume) + SPACE(28)
			cPEND += "USUARIO : "+ cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
			cPEND += "AP7 - FIM DA ALTERACAO     " + SPACE(43)
			
			RECLOCK("SC5",.F.)
			SC5->C5_PESOL   := cPeso
			SC5->C5_ESPECI1 := cVolume
			MSUNLOCK()
			
			RECLOCK("ZAL",.F.)
			ZAL->ZAL_MTPENE := cPEND //MEMOTRAN(cPEND)
			MSUNLOCK()
		ENDIF
	Endif
Endif

If lOpc14
	lProc := .F.
	
	If Trim(SC5->C5_ESPECI3) == '1'
		aItens:={"1 - Sim","2 - Nใo"}
	Else
		aItens:={"2 - Nใo","1 - Sim"}
	EndIf
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "C๓digo de Barras :"
	@ 060 , 0008 SAY "Exige C๓digo de Barras : "
	@ 060 , 0050 COMBOBOX _C5_ESPCI3 ITEMS aItens SIZE 080, 43
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		cCOD := Substr(_C5_ESPCI3,1,1)
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		cCodAnt := SC5->C5_ESPECI3
		lAtuCli := MsgBox("ATUALIZA CLIENTE ?", "ATUALIZA CLIENTE","YESNO" )
		
		IF cCOD <> SC5->C5_ESPECI3
			IF Empty(SC5->C5_NOTA)
				CPEND := ZAL->ZAL_MTPENE
				cPEND += "AP5 - ALTERACAO DA EXIGENCIA DE CODIGO DE BARRAS  " + SPACE(37)
				cPEND += "EXIGENCIA  ANTIGA  : "+ IIF(Trim(SC5->C5_ESPECI3) = '1','SIM','NAO ') + SPACE(36)
				cPEND += "EXIGENCIA  NOVA    : "+ IIF(cCOD	          = '1','SIM','NAO ') + SPACE(36)
				cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
				cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
				
				RECLOCK("SC5",.F.)
				SC5->C5_ESPECI3 := cCOD
				MSUNLOCK()
				
				RECLOCK("ZAL",.F.)
				ZAL->ZAL_MTPENE := MEMOTRAN(cPEND)
				MSUNLOCK()
				// passar e-mail para dantas<dantas@florate.net> se for alterado para sim
				If cCod == '1'
					dbSelectArea("SA1")
					Private aAreaSA1 := getArea()
					dbSetOrder(1)
					dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
					_C5_NomCli := SA1->A1_NOME
					
					if lAtuCli
						if Reclock("SA1",.f.)
							Replace SA1->A1_BCO3 With cCOD
						endif
						Msunlock()
					endif
					
					RestArea(aAreaSA1)
					dbSelectArea("SC5")
					
					cTexto := "Pedido : "+SC5->C5_NUM+" <P>"
					cTexto += "Cliente : "+SC5->C5_CLIENTE+" - "+_C5_NomCli+" <P>"
					cTexto += "Usuแrio: "+cNomeUsu+" <P>"
					cTexto += "DATA: "+DTOC(DDATABASE)+"  HORA: "+SUBSTR(TIME(),1,5)+" <P>"
					
					CONNECT SMTP SERVER ALLTRIM(GETMV("MV_RELSERV")) ACCOUNT "ap7@florarte.net" PASSWORD "ap7"
					
					SEND MAIL FROM "Setor de Vendas <vendas@florarte.net>" TO 	"Dantas <dantas@florarte.net>" ;
					SUBJECT "IMPRIMIR ETIQUETA DE CODIGO DE BARRAS" ;
					BODY cTexto
					
					DISCONNECT SMTP SERVER
				EndIf
			Else
				Alert("Pedido jแ faturado - Nใo ้ possivel alterar")
			EndIf
		ENDIF
	Endif
Endif


If lOpc15
	lAcessa := .T.
	if SUBSTR(SC5->C5_STATUS,1,1)<>'0' .or. !Empty(SC5->C5_DTCANC)
		ALERT("Pedido nใo estแ em vendas ou foi cancelado")
		Lacessa := .f.
		if SX5->(DBSEEK(xFILIAL("SX5")+"ZU40") )
			if !ALLTRIM(UPPER(cNomeUsu)) $ SX5->X5_DESCRI
				Lacessa := .f.
			else
				Lacessa := .t.
			endif
		else
			Lacessa := .f.
		endif
	endif
	
	if Lacessa
		Processa( { || Mostra_Desconto() } )
	endif
	
Endif

If lOpc16
	lProc := .F.
	
	_A1_DtSINTe := Sa1->a1_dtsinte
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Alteracao da data do Sintegra :"
	@ 060 , 0008 SAY "Data  : "
	@ 060 , 0050 GET _A1_Dtsinte  SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		CPEND := ZAL->ZAL_MTPENX
		cPEND += "AP7 - ALTERACAO DA DATA DO SINTEGRA  "+chr(13)+chr(10)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPEND += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Sa1->(RECLOCK("SA1",.F.))
		SA1->A1_DtSinte := _A1_Dtsintw
		Sa1->(MSUNLOCK())
	Endif
Endif

If lOpc17
	
	_Titulo := "Aviso: "
	_Mensagem := "Estornar Cancelamento do Pedido?"
	_Opcoes := {"Sim","Nao"}
	_nOp := Aviso(_Titulo,_Mensagem,_Opcoes)
	
	If _nOp == 1
		SC5->(RECLOCK("SC5",.F.))
		SC5->C5_MOTCANC := ""
		SC5->C5_DTCANC  := ctod("")
		SC5->C5_HRCANC  := ""
		SC5->(MSUNLOCK())
	endif
	
Endif

If lOpc18
	lProc := .F.
	
	_A1_Dtsufra := Sa1->a1_dtsufra
	_A1_FlSufra := Sa1->a1_flsufra
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Alteracao do Suframa :"
	
	@ 060 , 0008 SAY "Venc. Suframa : "
	@ 060 , 0050 GET _A1_Dtsufra  SIZE 40,10
	
	@ 080 , 0008 say "Suframa FL    : "
	@ 080 , 0050 get _A1_flsufra
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		CPEND := ZAL->ZAL_MTPENX
		cPEND += "AP7 - ALTERACAO DO SUFRAMA  "+chr(13)+chr(10)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPEND += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Sa1->(RECLOCK("SA1",.F.))
		SA1->A1_Dtsufra := _A1_Dtsufra
		Sa1->a1_flsufra := _A1_flsufra
		Sa1->(MSUNLOCK())
	Endif
Endif

If lOpc19                  

	lProc := .F.
	_C5_plmnum := SC5->C5_PLMNUM

	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Informa Pedido Principal :"
	@ 060 , 0008 SAY "Pedido Principal  : "
	@ 060 , 0050 GET _C5_plmnum  SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED

	If lProc
		Private Valida := .t.
		
		Private _cliente := SC5->c5_cliente
		Private _loja    := sc5->c5_LOJACLI
		Private _vend    := sc5->C5_VEND1
		
		if left(SC5->C5_status,1)<>'0'
			MsgBox("O Pedido Consultado Nใo estแ em vendas")
			Valida := .f.
		elseif !empty(SC5->c5_dtcanc)
			MsgBox("O Pedido Consultado estแ Cancelado")
			Valida := .f.
		endif
		
		N_recno := SC5->(recno())
		N_ordem := SC5->(IndexOrd())
		
		SC5->(DbSetOrder(1))
		
		if !SC5->(DbSeek(XFilial("SC5")+_C5_plmnum))
			MsgBox("O pedido informado nใo foi encontrado")
			Valida := .f.
		elseif !empty(SC5->c5_nota)
			MSgBox("Pedido Jแ Faturado.")
			Valida := .f.
		elseif !empty(SC5->c5_dtcanc)
			MsgBox("O Pedido Consultado estแ Cancelado")
			Valida := .f.
		elseif  _vend # SC5->c5_vend1
			MsgBox("O Representante do pedido informado diverge do pedido consultado")
			Valida := .f.
		else
			if _cliente+_loja # SC5->c5_cliente+SC5->c5_lojacli
				cGpEmp1 := Posicione("SA1",1,"  "+SC5->c5_cliente+SC5->c5_lojacli,"A1_GPEMP")
				cGpEmp2 := Posicione("SA1",1,"  "+_cliente+_loja,"A1_GPEMP")
				If cGpEmp1 <> cGpEmp2
					MsgBox("O cliente do pedido informado diverge do pedido consultado")
					Valida := .f.
				EndIf
			endif
		endif
		
		SC5->(DbSetOrder(N_ordem))
		SC5->(DbGoTo(N_recno))
		
		if !valida
			MsgBox("Pedido principal nใo pode ser informado")
//			Odl:End()
			return(.t.)
		Endif
		
		SC5->(RECLOCK("SC5",.F.))
		SC5->c5_plmnum := _C5_plmnum
		SC5->(MSUNLOCK())

		lPrinPed := MsgBox("Informar em outros Pedidos ?","Pedido Principal","YESNO")

		If lPrinPed
			SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
			SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
			SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Opcao de acesso para o Modelo 2                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			// 3,4 Permitem alterar getdados e incluir linhas
			// 6 So permite alterar getdados e nao incluir linhas
			// Qualquer outro numero so visualiza
			
			cTitulo:= "Pedido Principal "+SC5->C5_PLMNUM
			nOpcx := 3 //Pode alterar e incluir linhas
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Montando aHeader                                             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			nUsado:=0
			aHeader:={}
			
			AADD(aHeader,{"Pedido","C5NUM" ,"@!",6,0, 'U_VLDPEDPRIN()',,"C","XC5","A"})
			
			nUsado := 1
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Montando aCols                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			//Carrega arquivo de trabalho criado com os dados da consulta
			nTam := 1
			
			//Cria um array para carregar os dados dos titulos
			aCols:=Array(nTam,nUsado+1)
			aCOLS[1][1]        := Space(6)
			aCOLS[1][nUsado+1] := .F.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Variaveis do Rodape do Modelo 2                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Array com coordenadas da GetDados no modelo2                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			aCGD := {20,02,170,400}
			
			nAcordW := {70,05,450,800}
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Validacoes na GetDados da Modelo 2                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			cLinhaOk := ".T."
			cTudoOk  := ".T."
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Chamada da Modelo2                                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			// lRetMod2 = .t. se confirmou
			// lRetMod2 = .f. se cancelou
			
			lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)
			
			If lRetMod2
			
			   For i := 1 To len(aCols)
			   
			      If !aCols[i,Len(aHeader)+1] //Se nao estiver deletado
			         Alert(aCols[i,1])
					   Dbselectarea("SC5")
					   dbsetorder(1)
					   If Dbseek(xFilial()+aCols[i,1])
							SC5->(RECLOCK("SC5",.F.))
							SC5->c5_plmnum := _C5_plmnum
							SC5->(MSUNLOCK())
						Else
							Alert("Pedido "+aCols[i,1]+" nao encontrado")
						Endif
					Endif
				Next
			Endif
		Endif
	Endif
Endif

If lOpc20
	lProc := .F.
	_nDescP := 5.0
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	@ 040 , 0008 SAY "Informa desconto promocional :"
	@ 060 , 0008 SAY "% Desconto(<=5%)  : "
	@ 060 , 0050 GET _nDescP  VALID _nDescP > 0 .And. _nDescP <= 5 SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		
		Valida := .t.
		
		_cliente := SC5->c5_cliente
		_loja    := sc5->c5_LOJACLI
		_vend    := sc5->C5_VEND1
		_nValMin := GetMv("MV_VALMIND")
		_Num     := SC5->C5_NUM
		_GpEmp   := Posicione("SA1",1,"  "+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_GPEMP")
		
		if left(SC5->C5_status,1)<>'0'
			MsgBox("O Pedido Consultado Nใo estแ em vendas")
			Valida := .f.
		elseif !empty(SC5->c5_dtcanc)
			MsgBox("O Pedido Consultado estแ Cancelado")
			Valida := .f.
		endif
		
		N_recno := SC5->(recno())
		N_ordem := SC5->(IndexOrd())
		
		dbSelectArea("SC6")
		cQUERY := "SELECT sum(C6_VALOR+C6_DESCIPI) AS ValorPed "
		cQUERY += " FROM " + RetSqlName( "SC6" ) + " SC6 "
		cQUERY += " WHERE C6_FILIAL+C6_NUM = '" + SC5->C5_FILIAL+SC5->C5_NUM + "' "
		cQUERY += " AND D_E_L_E_T_ = ''"
		cQUERY := ChangeQuery( cQUERY )
		//Cria arquivo temporario
		TCQUERY cQUERY Alias TSC6 New
		_nValorPed := TSC6->VALORPED
		DbCloseArea("TSC6")
		
		If _nValorPed < _nValMin .And. !Empty(SC5->C5_PLMNUM) //.And. Trim(SC5->C5_NUM) <> Trim(SC5->C5_PLMNUM)
			_C5_PLMNUM := SC5->C5_PLMNUM
			dbSelectArea("SC6")
			If Empty(_GpEmp)
				cQUERY := "SELECT sum(C6_VALOR+C6_DESCIPI) AS ValorPed "
				cQUERY += " FROM " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" ) + " SC6 "
				cQUERY += " WHERE C5_FILIAL+C5_PLMNUM = '" + SC5->C5_FILIAL+_C5_PLMNUM + "' "
				cQUERY += " AND C5_FILIAL+C5_NUM <> '" + SC5->C5_FILIAL+_NUM + "' AND C5_VEND1 = '" + _Vend + "' "
				cQUERY += " AND C5_CLIENTE = '" + _Cliente + "' AND C5_DTS_FAT = '' AND C5_DTCANC = '' "
				cQUERY += " AND C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM "
				cQUERY += " AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "
			Else
				cQUERY := "SELECT sum(C6_VALOR+C6_DESCIPI) AS ValorPed "
				cQUERY += " FROM " + RetSqlName( "SC5" ) + " SC5, "  + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SC6" ) + " SC6 "
				cQUERY += " WHERE C5_FILIAL+C5_PLMNUM = '" + SC5->C5_FILIAL+_C5_PLMNUM + "' "
				cQUERY += " AND C5_FILIAL+C5_NUM <> '" + SC5->C5_FILIAL+_NUM + "' " //AND C5_VEND1 = '" + _Vend + "' "
				cQUERY += " AND C5_DTS_FAT = '' AND C5_DTCANC = '' "
				cQUERY += " AND C5_CLIENTE = A1_COD AND A1_GPEMP = '" + _GpEmp + "' "
				cQUERY += " AND C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM "
				cQUERY += " AND SC5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "
			EndIf
			cQUERY := ChangeQuery( cQUERY )
			//Cria arquivo temporario
			TCQUERY cQUERY Alias TSC6 New
			_nValorPed += TSC6->VALORPED
			DbCloseArea("TSC6")
		EndIf
		If _nValorPed < _nValMin
			MsgBox("Valor do Pedio menor que o mํnimo Indicado para este desconto.")
			Valida := .f.
		EndIf
		SC5->(DbSetOrder(N_ordem))
		SC5->(DbGoTo(N_recno))
		
		if !valida
			MsgBox("Desconto NAO sera GRAVADO para este pedido.")
		else
			SC5->(RECLOCK("SC5",.F.))
			SC5->C5_COMIS2 := _nDescP
			SC5->C5_DESC2  += ( ( 100 - SC5->C5_DESC2 ) * ( _nDescP / 100 ) )
			SC5->(MSUNLOCK())
			SC6->( DBSETORDER(1) )
			SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )
			WHILE SC6->C6_NUM = SC5->C5_NUM
				U_IPIItem(SC5->C5_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,.T.)
				SC6->( DBSKIP() )
			ENDDO
			MsgBox("Desconto G R A V A D O com sucesso para este pedido.")
		endif
		
	Endif
	
Endif

If lOpc21
	lProc := .F.
	_C5_DtProg := SC5->C5_DtLibCr
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	@ 040 , 0008 SAY "Alteracao Data Programa็ใo :"
	
	@ 060 , 0008 SAY "Dt. Programa็ใo : "
	@ 060 , 0050 GET _C5_DtProg SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		CPEND := ZAL->ZAL_MTPENX
		cPEND += "AP7 - ALTERACAO DA DATA DE PROGRAMAวรO  "+chr(13)+chr(10)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPEND += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Reclock("SC5",.F.)
		SC5->c5_Dtlibcr := _c5_DtProg
		MSUNLOCK()
	Endif
Endif

If lOpc22
	lProc := .F.
	_A1_email := Sa1->a1_email
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	@ 040 , 0008 SAY "Altera็ใo de e-mail :"
	
	@ 060 , 0008 SAY "e-mail : "
	@ 060 , 0050 GET _A1_email  SIZE 60,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		cPend := ZAL->ZAL_MTPENX
		cPend += "AP7 - ALTERACAO DO E-MAIL  "+chr(13)+chr(10)
		RECLOCK("ZAL",.F.)
		cPend += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPend += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Sa1->(RECLOCK("SA1",.F.))
		SA1->A1_email := _A1_email
		Sa1->(MSUNLOCK())
	Endif
	
Endif

If lOpc23
	lProc := .F.
	_A1_redespacho := Sa1->a1_bco5
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	@ 040 , 0008 SAY "Alterar UF para Redespacho :"
	
	@ 060 , 0008 SAY "UF para Redespacho : "
	@ 060 , 0050 GET _A1_redespacho  SIZE 60,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		cPend := ZAL->ZAL_MTPENX
		cPend += "AP7 - ALTERACAO DA UF PARA REDESPACHO  "+chr(13)+chr(10)
		cPend += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPend += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Sa1->(RECLOCK("SA1",.F.))
		Sa1->A1_bco5 := _A1_redespacho
		Sa1->(MSUNLOCK())
	Endif
	
Endif

If lOpc24
	lProc := .F.
	Dbselectarea("ZZ6")
	Dbsetorder(1)
	If Dbseek(xfilial()+SA1->A1_COD+SA1->A1_LOJA)
		mObs := ZZ6->ZZ6_NEGOCI
	Else
		cMem := CriaVar("ZZ6->ZZ6_NEGOCI") //Para criar registro
		Reclock("ZZ6",.T.)
		Replace ZZ6_FILIAL With xFilial()
		Replace ZZ6_CLIENT With SA1->A1_COD
		Replace ZZ6_LOJA   With SA1->A1_LOJA
		Replace ZZ6_NEGOCI With cMem
		Replace ZZ6_RETORN With dDatabase
		Replace ZZ6_TIPRET With '2'
		Replace ZZ6_ULCONT With CTOD("")
		Replace ZZ6_PRIORI With '   '
		Replace ZZ6_SEQUEN With '    '
		msunlock()
		mObs := ZZ6->ZZ6_NEGOCI
	Endif
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,700 TITLE "Observa็ใo no Cliente" PIXEL OF oMainWnd
	@ 001 , 0001 GET mObs  SIZE 280,100 MEMO
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		
		cMemo := mObs
		Dbselectarea("ZZ6")
		Dbsetorder(1)
		If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
			Reclock("ZZ6",.F.)
			Replace ZZ6_NEGOCI With cMemo
			msunlock()
		Endif
		
	Endif
	
Endif

If lOpc25

	lProc   := .F.
	cPedAgr := Space(6)

	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Informa Numero do Pedido :"
	@ 060 , 0008 SAY "Pedido : "
	@ 060 , 0050 GET cPedAgr  SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED

	If lProc
		
		Valida := .T.
		
		Private _cliente := SC5->c5_cliente
		Private _loja    := sc5->c5_LOJACLI
		Private _vend    := sc5->C5_VEND1
		Private _Status  := sc5->C5_status
		
		if left(SC5->C5_status,1)<>'0'
			MsgBox("O Pedido Consultado Nใo estแ em vendas")
			Valida := .f.
		elseif !empty(SC5->c5_dtcanc)
			MsgBox("O Pedido Consultado estแ Cancelado")
			Valida := .f.
		endif
		
		N_recno := SC5->(recno())
		N_ordem := SC5->(IndexOrd())
		
		SC5->(DbSetOrder(1))
		
		if !SC5->(DbSeek(XFilial("SC5")+cPedAgr))
			MsgBox("O pedido Informado nใo foi encontrado")
			Valida := .f.
		Elseif left(SC5->C5_status,1)<>'0'
			MsgBox("O Pedido Informado Nใo estแ em vendas")
			Valida := .f.
		elseif SC5->C5_STATUS <> _Status
			MSgBox("Pedidos com STATUS divergentes")
			Valida := .f.
		elseif !empty(SC5->c5_nota)
			MSgBox("Pedido Informado Jแ Faturado.")
			Valida := .f.
		elseif !empty(SC5->c5_dtcanc)
			MsgBox("O Pedido Informado estแ Cancelado")
			Valida := .f.
		elseif  _vend # SC5->c5_vend1
			MsgBox("O Representante do pedido informado diverge do pedido consultado")
			Valida := .f.
		else
			if _cliente+_loja # SC5->c5_cliente+SC5->c5_lojacli
				cGpEmp1 := Posicione("SA1",1,"  "+SC5->c5_cliente+SC5->c5_lojacli,"A1_GPEMP")
				cGpEmp2 := Posicione("SA1",1,"  "+_cliente+_loja,"A1_GPEMP")
				If cGpEmp1 <> cGpEmp2
					MsgBox("O cliente do pedido informado diverge do pedido consultado")
					Valida := .f.
				EndIf
			endif
		endif
		
		SC5->(DbSetOrder(N_ordem))
		SC5->(DbGoTo(N_recno))
		
		if !valida
			MsgBox("Pedido nใo pode ser informado")
			return(.t.)
		Endif
		
		lAgregaPed := MsgBox("Transportar os itens do Pedido "+cPedAgr+" para o Pedido "+SC5->C5_NUM+" ?","Agregar itens do Pedido "+cPedAgr,"YESNO")
		
		If lAgregaPed
         
			//Verifica o maior numero do campo item
			Dbselectarea("SC6")
		   Dbsetorder(1)
		   Dbseek(xFilial("SC6")+SC5->C5_NUM)
		   
		   cItem := Space(2)
		   
		   While !Eof("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
             If SC6->C6_ITEM > cItem
                cItem := SC6->C6_ITEM
             Endif
             dbskip()
			End
			
			cItem := Soma1( Padr(cItem,2), 2 )
			
		   BEGIN TRANSACTION
		   
		   //Atualiza itens do pedido
		   Dbselectarea("SC6")
		   Dbsetorder(1)
		   lVldC6 := .F.
		   While Dbseek(xFilial("SC6")+cPedAgr) .And. !Eof("SC6")
		      
		      //Altera o Codigo do item no SC9
			   Dbselectarea("SC9")
			   Dbsetorder(9)
			   If Dbseek(xFilial("SC9")+cPedAgr+SC6->C6_ITEM+SC6->C6_PRODUTO)
			      Reclock("SC9",.F.)
			      Replace C9_PEDIDO With SC5->C5_NUM
			      Replace C9_ITEM   With cItem
			      msunlock()
		      Endif
		      
		      Dbselectarea("SC6")
		      Reclock("SC6",.F.)
		      Replace C6_ITEM   With cItem
		      Replace C6_NUM    With SC5->C5_NUM
		      msunlock()
     			cItem := Soma1( Padr(cItem,2), 2 )
		      lVldC6 := .T.
		   End
/*
		   //Atualiza itens liberados do pedido
		   Dbselectarea("SC9")
		   Dbsetorder(1)
		   //lVldC9 := .F. //Nao valida a delecao do SC9 porque o pedido pode nao ter itens liberados
		   While Dbseek(xFilial("SC9")+cPedAgr) .And. !Eof("SC9")
		      Reclock("SC9",.F.)
		      Replace C9_PEDIDO With SC5->C5_NUM
		      msunlock()
		      //lVldC9 := .T.
		   End
*/		   
			lVldC5 := .F.
			Dbselectarea("SC5")
         Dbsetorder(1)
			If DbSeek(xFilial("SC5")+cPedAgr)
			   Reclock("SC5",.F.)
			   dbdelete()
			   msunlock()
			   lVldC5 := .T.
			Endif
			
			lVldZAL := .F.
			Dbselectarea("ZAL")
         Dbsetorder(1)
			If DbSeek(xFilial("ZAL")+cPedAgr)
			   Reclock("ZAL",.F.)
			   dbdelete()
			   msunlock()
			   lVldZAL := .T.
			Endif

			//Se houve algum problema, rollback
//			If !lVldC6 .Or. !lVldC9 .or. !lVldC5 .or. !lVldZAL			
			If !lVldC6 .Or. !lVldC5
			   //ROLLBACK
			Endif
			
			//Apresenta as mensagens
			If !lVldC6
			   Alert("Problema ao deletar Itens SC6")
			Endif
//			If !lVldC9                               
//			   Alert("Problema ao deletar Itens Liberados SC9")
//			Endif
			If !lVldC5                     
			   Alert("Problema ao deletar Cabe็alho do Pedido SC5")
			Endif
			If !lVldZAL                                      
			   Alert("Problema ao deletar Memo do Pedido ZAL")
			Endif
			
		   END TRANSACTION
	
			SC5->(DbSetOrder(N_ordem))
			SC5->(DbGoTo(N_recno))
         
         //Atualiza Arrayดs
		   Processa( { || PFAT31_Qry() } )
		Endif
		
	Endif
Endif

If lOpc26

	lProc   := .F.
	cItemEx := Space(2)
	cProdEx := Space(15)

	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 040 , 0008 SAY "Excluir Referencia :"
	@ 060 , 0008 SAY "Item : "
	@ 060 , 0025 GET cItemEx  SIZE 10,10
	@ 060 , 0060 SAY "Produto : "
	@ 060 , 0090 GET cProdEx  SIZE 50,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED

	If lProc
	
	   Dbselectarea("SC6")
	   Dbsetorder(1)
	   If !Dbseek(xFilial()+SC5->C5_NUM+cItemEx+cProdEx)
	      Alert("Item nao encontrado. Verifique dados informados")
      Else
			lExcluiIt := MsgBox("Excluir o Item : "+cItemEx+" Ref.: "+cProdEx+" ?","Excluir Item do Pedido: "+SC5->C5_NUM,"YESNO")
			
			If lExcluiIt
			   BEGIN TRANSACTION
			   If SC6->C6_QTDEMP > 0 //Item com reserva
				   Dbselectarea("SC9")
				   Dbsetorder(9)
				   If Dbseek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
				      //deleta registro de liberacao
				      Reclock("SC9",.F.)
				      dbdelete()
//				      msunlock()
				   Else
				      Alert("Item com liberacao. Mas nao achou SC9. Entre em contato com informatica")
				      //ROLLBACK
				      Return
			      Endif
			   Endif
			   Dbselectarea("SB2")
			   Dbsetorder(1)
			   If Dbseek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL)
			      //Atualiza saldo em estoque
			      Reclock("SB2",.F.)
			      Replace B2_RESERVA With B2_RESERVA - SC6->C6_QTDEMP //Abate quantidade reservada
			      Replace B2_QPEDVEN With B2_QPEDVEN - SC6->C6_QTDVEN //Abate quantidade do pedido
			      msunlock()
			   else
			      Alert("Item nao encontrado no SB2. Entre em contato com informatica")
			      //ROLLBACK
			      Return
			   Endif
			   
			   //Deleta registro do pedido
			   Dbselectarea("SC6")
			   Reclock("SC6",.F.)
			   dbdelete()
//			   msunlock()
			   
				END TRANSACTION
		      msunlockall()
	         //Atualiza Arrayดs
			   Processa( { || PFAT31_Qry() } )
			Endif
		Endif
		
   Endif
Endif 

If lOpc27
   lProc := .F.
	
   _A1_Dtauton := Sa1->a1_dtauton
   DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,400 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
   @ 040 , 0008 SAY "Alteracao da data Limite para Autonomo :"
   @ 060 , 0008 SAY "Data  : "
   @ 060 , 0050 GET _A1_Dtauton  SIZE 40,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
		Dbselectarea("ZAL")
		Dbsetorder(1)
		dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
		CPEND := ZAL->ZAL_MTPENX
		cPEND += "AP7 - ALTERACAO DA DATA LIMITE PARA AUTONOMO  "+chr(13)+chr(10)
		cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)+chr(13)+chr(10)
		cPEND += "AP7 - FIM DA ALTERACAO     "+chr(13)+chr(10)
		
		RECLOCK("ZAL",.F.)
		ZAL->ZAL_MTPENX := MEMOTRAN(cPEND)
		MSUNLOCK()
		
		Sa1->(RECLOCK("SA1",.F.))
		SA1->A1_Dtauton := _A1_Dtauton
		Sa1->(MSUNLOCK())
	Endif
Endif

If lOpc28
	lProc := .F.
	_C5_DESC1 := 0.0
	_C5_VEND3 := IIF( AllTrim(_C5_VEND3) <> "S", "S     ", "N     " )
	
	DEFINE MSDIALOG oDlga FROM 40, 20 TO 335,700 TITLE "Advanced Protheus" PIXEL OF oMainWnd
	
	@ 010 , 0005 SAY "Dados do cliente :"
	@ 020 , 0005 SAY "Cliente : "  + SC5->C5_CLIENTE + " - " + SUBSTR(SA1->A1_NOME,1,40)
	@ 030 , 0005 SAY "Fantasia : " + SUBSTR(SA1->A1_NREDUZ,1,20)
	@ 040 , 0005 SAY "Fone : " + SA1->A1_TEL
	@ 040 , 0060 SAY "Fax : " + SA1->A1_FAX
	@ 050 , 0005 SAY "Contato : " + SA1->A1_CONTATO
	
	@ 070 , 0005 SAY "Promocao :"
	
	@ 070, 0050 GET _C5_VEND3 PICTURE "@!" VALID Alltrim(_C5_VEND3) $ 'SN'
	@ 080, 0050 GET _C5_DESC1 PICTURE '@R 99.99' VALID _C5_DESC1 = 5.0  SIZE 10,10
	
	DEFINE SBUTTON FROM 126, 100 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End(), lProc := .T. }
	DEFINE SBUTTON FROM 126, 132 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If lProc
	   Dbselectarea("ZAL")
	   Dbsetorder(1)
	   dbseek(xFilial("ZAL")+SC5->C5_NUM)
		
	   If ( AllTrim(_C5_VEND3) == "S"  .And. AllTrim(SC5->C5_VEND3) <> 'S' ) .Or. ( AllTrim(_C5_VEND3) == "N"  .And. AllTrim(SC5->C5_VEND3) == 'S' )
		  SC6->( DBSETORDER(1) )
		  SC6->( DBSEEK(xFILIAL("SC6")+SC5->C5_NUM) )
		  WHILE SC6->C6_NUM = SC5->C5_NUM
				SB1->( DBSEEK("  "+SC6->C6_PRODUTO) )
				If SB1->B1_PROMOC <> 'S'
				   RECLOCK("SC6",.F.)
				   If AllTrim(_C5_VEND3) == "S"  .And. AllTrim(SC5->C5_VEND3) <> 'S'
				      SC6->C6_DESCOC += ( ( 100 - SC6->C6_DESCOC ) * ( _C5_DESC1 / 100 ) )
				   ElseIf AllTrim(_C5_VEND3) == "N"  .And. AllTrim(SC5->C5_VEND3) == 'S'
				      SC6->C6_DESCOC := Round( ( SC6->C6_DESCOC - _C5_DESC1 ) / ( 1 - ( _C5_DESC1 / 100 ) ), 2)
				   EndIf
				   MSUNLOCK()
				   If SC5->C5_TIPO <> 'D'
				      U_IPIItem(SC5->C5_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,.T.)
				   EndIf
				EndIf
				SC6->( DBSKIP() )
		  ENDDO 
		  
		  cPEND := ZAL->ZAL_MTPENV
		  cPEND += "AP5 - ALTERACAO DE PROMOCAO  " + SPACE(43)
		  cPEND += "USUARIO : "+cNomeUsu + " DATA  " + DTOC(DDATABASE) + "  HORA "+SUBSTR(TIME(),1,5)  + SPACE(17)
		  cPend += "Desconto : "+TRANSFORM(_C5_DESC1,"@E 99.99") + "   Promo็ใo 5% : "+ _C5_VEND3 + space(17)
		  cPEND += "AP5 - FIM DA ALTERACAO     " + SPACE(43)
			
		  RECLOCK("SC5",.F.)
		  SC5->C5_VEND3   := _C5_VEND3
		  MSUNLOCK()
			
		  RECLOCK("ZAL",.F.)
		  ZAL->ZAL_MTPENV := cPEND
		  MSUNLOCK() 
		  
	   EndIf
	Endif
Endif


RESTAREA(aSC5)
RESTAREA(aSA1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  11/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VLDPEDPRIN()

Valida := .T.
	
SC5->(DbSetOrder(1))

If !SC5->(DbSeek(XFilial("SC5")+M->C5NUM)	)
	MsgBox("O pedido informado nใo foi encontrado")
	Valida := .f.
elseif left(SC5->C5_status,1)<>'0' .and. SC5->c5_condpag='300'
   MsgBox("O Pedido Consultado ้ antecipado e nใo estแ em vendas")
   Valida := .f.
elseif !empty(SC5->c5_nota)
	MSgBox("Pedido Jแ Faturado.")
	Valida := .f.
elseif !empty(SC5->c5_dtcanc)
	MsgBox("O Pedido Consultado estแ Cancelado")
	Valida := .f.
elseif  _vend # SC5->c5_vend1
	MsgBox("O Representante do pedido informado diverge do pedido consultado")
	Valida := .f.
else
	if _cliente+_loja # SC5->c5_cliente+SC5->c5_lojacli
		cGpEmp1 := Posicione("SA1",1,"  "+SC5->c5_cliente+SC5->c5_lojacli,"A1_GPEMP")
		cGpEmp2 := Posicione("SA1",1,"  "+_cliente+_loja,"A1_GPEMP")
		If cGpEmp1 <> cGpEmp2
			MsgBox("O cliente do pedido informado diverge do pedido consultado")
			Valida := .f.
		EndIf
	endif
endif

Return(Valida)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FunctIon VDLOPC04GET()

IF EMPTY(aCOLS[n,02]) .AND. !aCOLS[n,14]
	ALERT("Informe o codigo do produto")
	RETURN(.F.)
ENDIF

IF EMPTY(aCOLS[n,06]) .AND. !aCOLS[n,14]
	ALERT("Registro invalido")
	RETURN(.F.)
ENDIF

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldOpc(cTipo)

If cTipo $ "01"
	If !Empty(SC5->C5_SERIE+SC5->C5_NOTA)
		Alert("Pedido faturado, nao e' possivel alterar o cliente")
		lOpc01 := .F.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc01 := .f.
	Endif
	
ElseIf cTipo $ "02"
	IF !EMPTY(SC5->C5_DTS_VEN)
		ALERT("Pedido jแ saiu do setor de vendas, nao e' possivel alterar a condicao de pagamento")
		lOpc02 := .F.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc02 := .f.
	Endif
ElseIf cTipo $ "03"
	IF !EMPTY(SC5->C5_NOTA+SC5->C5_SERIE)
		ALERT("Pedido faturado, nao e' possivel alterar o Frete !")
		lOpc03 := .F.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc03 := .f.
	elseif !empty(SC5->c5_FRETE)
		MsgBox("O Pedido com Frete Calculado")
		lOpc03 := .f.
	endif
ElseIf cTipo $ "04"
   alert("Funcao indisponivel")
   lopc04 := .F.
/*
	IF !EMPTY(SC5->C5_DTS_VEN)
		Alert("Alteracao permitida para pedidos no setor de vendas")
		lOpc04 := .F.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc04 := .f.
	Endif
*/	
ElseIf cTipo $ "05"
	IF ( SE4->E4_NATUREZ = '10104' .And. AllTrim(SC5->C5_COTACAO) $ '12' ) .OR. !EMPTY(SC5->C5_DTSAIDA)
		If SE4->E4_NATUREZ = '10104' .And. AllTrim(SC5->C5_COTACAO) $ '12'
			ALERT("Para alterar a licitacao desse pedido, mude a condicao de pagamento.")
			lOpc05 := .F.
		ElseIf !EMPTY(SC5->C5_DTSAIDA)
			ALERT("A licitacao nao pode ser alterado, o pedido ja' saiu da empresa.")
			lOpc05 := .F.
		Endif
	Endif
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc05 := .f.
	Endif
ElseIf cTipo $ "06"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc06 := .f.
	Endif
ElseIf cTipo $ "07"
	IF !EMPTY(SC5->C5_SERIE+SC5->C5_NOTA) .AND. ALLTRIM(cNome) <> "Administrador"
		ALERT("Pedido faturado, nao e' possivel alterar o representante")
		lOpc07 := .F.
	ElseIf !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc07 := .f.
	Endif
ElseIf cTipo $ "08"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc08 := .f.
	Endif
ElseIf cTipo $ "09"
ElseIf cTipo $ "10"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc10 := .f.
	Endif
ElseIf cTipo $ "11"
	IF !EMPTY(SC5->C5_NOTA+SC5->C5_SERIE)
		ALERT("Pedido faturado, nao e' possivel alterar a condicao de pagamento")
		lOpc11 := .F.
	ElseIf !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc11 := .f.
	Endif
ElseIf cTipo $ "12"
	IF !EMPTY(SC5->C5_SERIE+SC5->C5_NOTA)
		ALERT("Pedido faturado, nao e' possivel alterar a Promo็ใo")
		lOpc12 := .F.
	ELSEIF ( SC5->C5_CONDPAG $ GETMV("MV_CONDNAT") .And. AllTrim(_C5_VEND2) <> "S" )
		ALERT("Pedido com condi็ใo promocional nao pode ter desconto")
		lOpc12 := .F.
	ElseIf !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc12 := .f.
	Endif
ElseIf cTipo $ "13"
	If SC5->C5_FRETE <> 0
		ALERT("Frete Calculado, cancele frete do pedido para alterar Peso/Volume")
		lOpc13 := .F.
	ElseIf !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc13 := .f.
	Endif
ElseIf cTipo $ "14"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc14 := .f.
	Endif	
ElseIf cTipo $ "15"
	IF !empty(SC5->C5_SERIE+SC5->C5_NOTA)
		ALERT("Pedido faturado, nao e' possivel alterar")
		lOpc15 := .F.
	ElseIf !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc15 := .f.
	Endif
ElseIf cTipo $ "16"
ElseIf cTipo $ "17"
ElseIf cTipo $ "18"
ElseIf cTipo $ "19-20"
	If left(SC5->C5_status,1)<>'0'
		MsgBox("O Pedido Consultado Nใo estแ em vendas")
		lOpc19 := .f.
		lOpc20 := .f.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc19 := .f.
		lOpc20 := .f.
	endif
ElseIf cTipo $ "21"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc21 := .f.
   Endif
ElseIf cTipo $ "22"
ElseIf cTipo $ "23"
	If !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc23 := .f.
   Endif
ElseIf cTipo $ "24"
ElseIf cTipo $ "25"
	If left(SC5->C5_status,1)<>'0'
		MsgBox("O Pedido Consultado Nใo estแ em vendas")
		lOpc25 := .f.
	elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc25 := .f.
	endif
ElseIf cTipo $ "26"
	If left(SC5->C5_status,1)<>'0'
		MsgBox("O Pedido Consultado Nใo estแ em vendas")
		lOpc26 := .f.
	Elseif !empty(SC5->c5_dtcanc)
		MsgBox("O Pedido Consultado estแ Cancelado")
		lOpc26 := .f.
	Endif
ElseIf cTipo $ "27"
Else
	Alert("USUARIO NAO AUTORIZADO")
ENDIF

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA_FAT020_AP5บAutor  ณMicrosiga           บ Data ณ  03/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31RASTRO()

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

cTitulo:= "Rastro do Pedido : "+SC5->C5_NUM
nOpcx:=7 //So visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

AADD(aHeader,{"Status"         ,"ZZT_STATUS" ,"@!"         ,25,0,,,"C","ZZT","V"})
AADD(aHeader,{"Dt Inicio"      ,"ZZT_DT_INI" ,""           ,08,0,,,"D","ZZT","V"})
AADD(aHeader,{"Hr Inicio"      ,"ZZT_HR_INI" ,"@!"         ,08,0,,,"C","ZZT","V"})
AADD(aHeader,{"Dt Fim"         ,"ZZT_DT_FIM" ,""           ,08,0,,,"D","ZZT","V"})
AADD(aHeader,{"Hr Fim"         ,"ZZT_HR_FIM" ,"@!"         ,08,0,,,"C","ZZT","V"})
AADD(aHeader,{"Usuario Inicial","ZZT_USERINI","@!"         ,15,0,,,"C","ZZT","V"})
AADD(aHeader,{"Usuario Final"  ,"ZZT_USERFIM","@!"         ,15,0,,,"C","ZZT","V"})
AADD(aHeader,{"Tempo"          ,"ZZT_TEMPO"  ,"@E 9,999.99"         ,03,0,,,"N","ZZT","V"})
AADD(aHeader,{""               ,"ZZT_NUM"    ,"@!"         ,01,0,,,"C","ZZT","V"})

nUsado := 09

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("ZZT")
cQUERY := "Select * "
cQUERY += " From " + RetSqlName( "ZZT" ) + " ZZT "
cQUERY += " Where ZZT.ZZT_NUM = '" + SC5->C5_NUM + "' "
cQUERY += " AND ZZT.D_E_L_E_T_ = ''"
cQUERY += " Order By ZZT.ZZT_DT_INI,ZZT.ZZT_HR_INI "

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPZZT
TCQUERY cQUERY Alias TMPZZT New

TcSetField( "TMPZZT", "ZZT_DT_INI"  , "D", 08, 0 )
TcSetField( "TMPZZT", "ZZT_DT_FIM"  , "D", 08, 0 )
TcSetField( "TMPZZT", "ZZT_TEMPO"   , "N", 07, 2 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPZZT")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End

If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPZZT")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		Dbselectarea("SX5")
		Dbsetorder(1)
		Dbseek(xFilial()+'ZZ'+TMPZZT->ZZT_STATUS)
		
		aCOLS[nCnt][1] := SX5->X5_DESCRI
		aCOLS[nCnt][2] := TMPZZT->ZZT_DT_INI
		aCOLS[nCnt][3] := TMPZZT->ZZT_HR_INI
		aCOLS[nCnt][4] := TMPZZT->ZZT_DT_FIM
		aCOLS[nCnt][5] := TMPZZT->ZZT_HR_FIM
		aCOLS[nCnt][6] := TMPZZT->ZZT_USERINI
		aCOLS[nCnt][7] := TMPZZT->ZZT_USERFIM
		aCOLS[nCnt][8] := TMPZZT->ZZT_TEMPO
		aCOLS[nCnt][9] := ''
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPZZT")
		dbSkip()
	EndDo
Else
	aCOLS[1][1] := "NENHUM RASTRO"
	aCOLS[1][2] := CTOD("")
	aCOLS[1][3] := "00:00:00"
	aCOLS[1][4] := CTOD("")
	aCOLS[1][5] := "00:00:00"
	aCOLS[1][6] := " "
	aCOLS[1][7] := " "
	aCOLS[1][8] := 0
	aCOLS[nCnt][9] := ''
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,170,400}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,800}

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

Dbselectarea("TMPZZT")
DbClosearea("TMPZZT")

If lRetMod2
	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDEPIDENT_TIT ณ Autor ณ HUGO SOARES     บ Data ณ  27/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CONCULTA NUMERO DO DEPOSITO IDENTIFICADO DOS TITULOS       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FLOR ARTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static function PFAT31IDENT()

If !Empty(SC5->C5_NUMDPID)
	
	SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
	SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
	SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Opcao de acesso para o Modelo 2                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	
	nOpcx:=7 //SO VISUALIZA
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montando aHeader                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	nUsado:=0
	aHeader:={}
	
	//Deposito e licitacao diferente de 1
	nFator := Iif(Substr(SC5->C5_COTACAO,1,1)='1',0.10,;
	Iif(Substr(SC5->C5_COTACAO,1,1)='2',0.20,;
	Iif(Substr(SC5->C5_COTACAO,1,1)='5',0.50,;
	Iif(Substr(SC5->C5_COTACAO,1,1)='3',0.30,;
	Iif(Substr(SC5->C5_COTACAO,1,1)='7',0.70,;	
	Iif(Substr(SC5->C5_COTACAO,1,1)='4',0.25,1))))))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montando aHeader                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aHeader := {}
	aTam := TamSX3('E1_VENCTO' ); Aadd(aHeader, {'Vencimento'  , 'E1_VENCTO' , PesqPict('SE1', 'E1_VENCTO' , aTam[1]         ), aTam[1], aTam[2], '', USADO, 'D', 'SE1', ''})
	aTam := TamSX3('E1_VALOR'  ); Aadd(aHeader, {'Valor 1'     , 'E1_VALOR'  , "@E 999,999.99", aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
	aTam := TamSX3('E1_VALOR'  ); Aadd(aHeader, {'Valor 2'     , 'E1_VALOR'  , "@E 999,999.99", aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
	aTam := TamSX3('E1_VALOR'  ); Aadd(aHeader, {'Total'       , 'E1_VALOR'  , "@E 999,999.99", aTam[1], aTam[2], '', USADO, 'N', 'SE1', ''})
	aTam := TamSX3('E1_NUMDPID'); Aadd(aHeader, {'Num Depos. 1', 'E1_NUMDPID', PesqPict('SE1', 'E1_NUMDPID', aTam[1]         ), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
	aTam := TamSX3('E1_NUMDPID'); Aadd(aHeader, {'Num Depos. 2', 'E1_NUMDPID', PesqPict('SE1', 'E1_NUMDPID', aTam[1]         ), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
	aTam := TamSX3('E1_NOMCLI' ); Aadd(aHeader, {'Form Pagto'  , 'E1_NOMCLI' , PesqPict('SE1', 'E1_NOMCLI' , aTam[1]         ), aTam[1], aTam[2], '', USADO, 'C', 'SE1', ''})
	nUsado := 7
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis do Cabecalho do Modelo 2                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//P = Prod Prop; A = Adq Terc e T = Total
	nValMerP := Round((nTOTPEDT-nTotIpi-nTotPedN)*nFator,4)
	nValMerA := (nTotPedN-nTotIpiN)
	nValMerT := nValMerP+nValMerA
	
	nValIPIP := Round((nTotIpi-nTotIpiN)*nFator,4)
	nValIPIA := nTotIpiN
	nValIPIT := nValIPIP+nValIPIA
	
	nValFRTP := Round(nFrtPed*nFator,2)
	nValFRTA := 0
	nValFRTT := nValFRTP+nValFRTA
	
	nValNFP  := nValMerP+nValIPIP+nValFRTP
	nValNFA  := nValMerA+nValIPIA+nValFRTA
	nValNFT  := nValNFP + nValNFA
	
	nValLicP := (nTOTPEDT-nTotPedN)-nValNFP+NFRTPED
	nValLicA := 0
	nValLicT := nVallicP+nValLicA
	
	nValTotP := nValNFP+nValLicP
	nValTotA := nValNFA+nValLicA
	nValTotT := nValTotP+nValTotA
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis do Rodape do Modelo 2                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nValor1 := 0
	nValor2 := 0
	nVlrTotal := 0
	_cAlias := alias()
	If Empty(SC5->C5_NOTA)
		// Se Ainda Nao Foi Faturado pega Emissao do Pedido
		cTipCond := SC5->C5_CONDPAG
		aRetCond := Condicao(nTOTPEDT+nFrtPed,cTipCond,dDataBase)
		aRetConN := Condicao(nTotPedN,cTipCond,dDataBase) 
		
		nRetconN := 0
		if len(aRetConN) > 0
		   nRetConN := aRetConN[1][2]
		endif
		
		nParc   := 0
		nRegSE1 := Len(aRetCond)
		
		nParc1  := Round(((aRetCond[1][2]-nRetConN)*nFator)+nRetConN,2)
		nVNF    := Round((((nTOTPEDT+nFrtPed)-nTotPedN)*nFator)+nTotPedN,2)
		nDifNF  := Round(nVNF-Round(Len(aRetCond)*nParc1,2),2)
		
		nParc2  := aRetCond[1][2]-nParc1
		nDifLic := 0
		If nParc2 > 0
			nVLIC    := Round((nTOTPEDT+nFrtPed)-nVNF,2)
			nDifLic  := Round(nVLic-Round(Len(aRetCond)*nParc2,2),2)
		Endif
		//Cria Acols
		aCols   :=Array(nRegSE1,nUsado+1)
		
		For nImpCond := 1 To Len(aRetCond)
			cNumIdent  := ""
			cNumIdent2 := ""
			If !Empty(SC5->C5_NUMDPID)
				nParc ++
				If Len(aRetCond) > 1
					cNumIdent  := Alltrim(SC5->C5_NUMDPID)+Alltrim(Str(nParc))
				Else
					cNumIdent  := Alltrim(SC5->C5_NUMDPID)+"0"
					cNumIdent2 := Alltrim(SC5->C5_NUMDPID)+"1"
				Endif
				DV_NN := U_DIGMOD11(cNumIdent)
				cNumIdent  := cNumIdent+DV_NN
				If !Empty(cNumIdent2)
					DV_NN := U_DIGMOD11(cNumIdent2)
					cNumIdent2  := cNumIdent2+DV_NN
				EndIf
			Endif
			Dbselectarea("SED")
			Dbsetorder(1)
			Dbseek(xfilial()+SC5->C5_NATUREZ)
			cNatureza1 := Alltrim(SED->ED_DESCRIC)
			cNatureza2 := ''
			lAvista := iif( SC5->C5_CONDPAG $ AllTrim(GetMv('MV_CONDLIB')), .T. , .F. )
			If lAvista //Se for a vista
				If !Empty(SA1->A1_NATAVNF)
					Dbseek(xfilial()+SA1->A1_NATAVNF)
					cNatureza1 := Alltrim(SED->ED_DESCRIC)
				Endif
				If nParc2 > 0 .and. !Empty(SA1->A1_NATAVLI)
					Dbseek(xfilial()+SA1->A1_NATAVLI)
					cNatureza2 := Alltrim(SED->ED_DESCRIC)
				Elseif nParc2 > 0 .and. Empty(SA1->A1_NATAVLI)
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
				If nParc2 > 0 .and. !Empty(SA1->A1_NATAPLI)
					Dbseek(xfilial()+SA1->A1_NATAPLI)
					cNatureza2 := Alltrim(SED->ED_DESCRIC)
				Elseif nParc2 > 0 .and. Empty(SA1->A1_NATAVLI)
					If !Empty(SE4->E4_NATUR2)
						Dbseek(xfilial()+SE4->E4_NATUR2)
						cNatureza2 := Alltrim(SED->ED_DESCRIC)
					Endif
				Endif
			Endif
			
			aCOLS[ nImpCond,1 ] := DTOC(aRetCond[nImpCond][1])
			aCOLS[ nImpCond,2 ] := nParc1+IIF(nImpCond==Len(aRetCond),nDifNf,0)
			aCOLS[ nImpCond,3 ] := nParc2+IIF(nImpCond==Len(aRetCond),nDifLic,0)
			aCOLS[ nImpCond,4 ] := nParc1+nParc2
			aCOLS[ nImpCond,5 ] := cNumIdent
			aCOLS[ nImpCond,6 ] := cNumIdent2
			aCOLS[ nImpCond,7 ] := cNatureza1 + If(!empty(cNatureza2),' / ' +cNatureza2,'')
			aCOLS[ nImpCond,8 ] := .F.
			//Atualiza totalizadores
			nValor1   += aCOLS[ nImpCond,2 ]
			nValor2   += aCOLS[ nImpCond,3 ]
			nVlrTotal += aCOLS[ nImpCond,2 ]+aCOLS[ nImpCond,3 ]
			
		Next nImpCond
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza Variaveis do Cabecalho do Modelo 2                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		Dbselectarea("SF2")
		Dbsetorder(1)
		If Dbseek(xFilial()+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE)
			//P = Prod Prop; A = Adq Terc e T = Total
			nValMerP := Round((SF2->F2_VALMERC-SF2->F2_MERCNAC)*nFator,4)
			nValMerA := SF2->F2_MERCNAC
			nValMerT := nValMerP+nValMerA
			
			nValIPIP := Round((SF2->F2_VALIPI-SF2->F2_VIPINAC)*nFator,4)
			nValIPIA := SF2->F2_VIPINAC
			nValIPIT := nValIPIP+nValIPIA
			
			nValFRTP := Round(SF2->F2_FRETE*nFator,2)
			nValFRTA := 0
			nValFRTT := nValFRTP+nValFRTA
			
			nValNFP  := nValMerP+nValIPIP+nValFRTP
			nValNFA  := nValMerA+nValIPIA+nValFRTA
			nValNFT  := nValNFP + nValNFA
			
			nValLicP := ((SF2->F2_VALMERC + SF2->F2_FRETE + SF2->F2_VALIPI + SF2->F2_SEGURO)-(SF2->F2_MERCNAC + SF2->F2_FRETNAC + SF2->F2_VIPINAC))-nValNFP
			nValLicA := 0
			nValLicT := nVallicP+nValLicA
			
			nValTotP := nValNFP+nValLicP
			nValTotA := nValNFA+nValLicA
			nValTotT := nValTotP+nValTotA
		Endif
		//Seleciona tํtulos gerados pelo faturamento
		dbselectarea("SE1")
		cQryTit := " Select E1_VENCTO
		cQryTit += " , VALOR1 = SUM(CASE WHEN E1_PREFIXO = 'NF' THEN E1_VALOR ELSE 0 END) "
		cQryTit += " , VALOR2 = SUM(CASE WHEN E1_PREFIXO = 'LIC' THEN E1_VALOR ELSE 0 END) "
		cQryTit += " , NUM1 = MAX(CASE WHEN E1_PREFIXO = 'NF' THEN E1_NUMDPID ELSE '' END)  "
		cQryTit += " , NUM2 = MAX(CASE WHEN E1_PREFIXO = 'LIC' THEN E1_NUMDPID ELSE '' END)  "
		cQryTit += " , NAT1 = MAX(CASE WHEN E1_PREFIXO = 'NF' THEN E1_NATUREZ ELSE '' END)  "
		cQryTit += " , NAT2 = MAX(CASE WHEN E1_PREFIXO = 'LIC' THEN E1_NATUREZ ELSE '' END)  "
		cQryTit += " From SE1010"
		cQryTit += " Where E1_SERIE+E1_NUM = '"+SC5->C5_SERIE+SC5->C5_NOTA+"' "
		cQryTit += " And E1_ORIGEM = 'MATA460'"
		cQryTit += " And D_E_L_E_T_ = ''"
		cQryTit += " GROUP BY E1_VENCTO"
		cQryTit += " Order by E1_VENCTO"
		
		TCQUERY cQryTit ALIAS SE1TIT NEW
		
		TcSetField( "SE1TIT", "E1_VENCTO" , "D", 08, 0 )
		TcSetField( "SE1TIT", "VALOR1"    , "N", 10, 2 )
		TcSetField( "SE1TIT", "VALOR2"    , "N", 10, 2 )
		
		Dbselectarea("SE1TIT")
		Dbgotop()
		nRegSE1 := 0
		//Conta numero de registros
		While !Eof()
			nRegSE1 ++
			dbskip()
		End
		aCols:=Array(nRegSE1,nUsado+1)
		dbgotop()
		nImpCond := 0
		
		While !Eof()
			Dbselectarea("SED")
			dbsetorder(1)
			dbseek(xFilial()+SE1TIT->NAT1)
			cForm1 := ED_DESCRIC
			
			dbseek(xFilial()+SE1TIT->NAT2)
			cForm2 := ED_DESCRIC
			
			nImpCond ++
			aCOLS[ nImpCond,1 ] := SE1TIT->E1_VENCTO
			aCOLS[ nImpCond,2 ] := SE1TIT->VALOR1
			aCOLS[ nImpCond,3 ] := SE1TIT->VALOR2
			aCOLS[ nImpCond,4 ] := SE1TIT->VALOR1+SE1TIT->VALOR2
			aCOLS[ nImpCond,5 ] := SE1TIT->NUM1
			aCOLS[ nImpCond,6 ] := SE1TIT->NUM2
			aCOLS[ nImpCond,7 ] := Alltrim(cForm1)+" / "+Alltrim(cForm2)
			aCOLS[ nImpCond,8 ] := .F.
			
			//Atualiza totalizadores
			nValor1   += SE1TIT->VALOR1
			nValor2   += SE1TIT->VALOR2
			nVlrTotal += SE1TIT->VALOR1+SE1TIT->VALOR2
			
			Dbselectarea("SE1TIT")
			dbskip()
		End
		Dbclosearea()
	EndIf
	
	DbSelectArea(_cAlias)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Titulo da Janela                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cTitulo:="Numero para Deposito Identificado"
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
	x := ''
	AADD(aC,{"x"	,{25,10} ,"Prod Prop","@!",,,})
	AADD(aC,{"x"	,{40,10} ,"Adq Terc"	,"@!",,,})
	AADD(aC,{"x"	,{55,10} ,"TOTAL"	   ,"@!",,,})
	
	AADD(aC,{"x"	      ,{15,50} ,"Vlr. Merc"	,"@!",,,})
	AADD(aC,{"nValMerP"	,{25,50} ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValMerA"	,{40,50} ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValMerT"	,{55,50} ,""	,"@E 999,999.99",,,})
	
	AADD(aC,{"x"      	,{15,100}  ,"Vlr. Frete"	,"@!",,,})
	AADD(aC,{"nValFRTP"	,{25,100}  ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValFRTA"	,{40,100}  ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValFRTT"	,{55,100}   ,""	,"@E 999,999.99",,,})
	
	AADD(aC,{"x"      	,{15,150}  ,"Vlr. IPI"	,"@!",,,})
	AADD(aC,{"nValIPIP"	,{25,150}  ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValIPIA"	,{40,150}  ,""	,"@E 999,999.9999",,,})
	AADD(aC,{"nValIpiT"	,{55,150}   ,""	,"@E 999,999.99",,,})
	
	AADD(aC,{"x"	      ,{15,200}  ,"Vlr. Nota"	,"@!",,,})
	AADD(aC,{"nValNFP"	,{25,200}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValNFA"	,{40,200}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValNFT"	,{55,200}   ,""	,"@E 999,999.99",,,})
	
	AADD(aC,{"x"	      ,{15,250}  ,"Vlr. Licit"	,"@!",,,})
	AADD(aC,{"nValLicP"	,{25,250}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValLicA"	,{40,250}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValLicT"	,{55,250}   ,""	,"@E 999,999.99",,,})
	
	AADD(aC,{"x"	      ,{15,300}  ,"Vlr. Total"	,"@!",,,})
	AADD(aC,{"nValTotP"	,{25,300}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValTotA"	,{40,300}  ,""	,"@E 999,999.99",,,})
	AADD(aC,{"nValTotT"	,{55,300}   ,""	,"@E 999,999.99",,,})
	
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
	AADD(aR,{"nValor1"	,{100,010},"Valor 1"	,"@E 999,999.99",,,.F.})
	AADD(aR,{"nValor2"	,{100,100},"Valor 2"	,"@E 999,999.99",,,.F.})
	AADD(aR,{"nVlrTotal",{100,200},"Valor TOTAL"	,"@E 999,999.99",,,.F.})
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Array com coordenadas da GetDados no modelo2                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCGD := {115,02,100,345}
	
	nAcordW := {70,05,500,780}
	
	//aCGD:={30,5,118,315}
	//aCGD:={44,5,118,315}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Validacoes na GetDados da Modelo 2                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cLinhaOk:=".T."
	cTudoOk :=".T."
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Chamada da Modelo2                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	//	lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
	lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,nAcordW)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente
	If lRetMod2
		//NAO FAZ NADA
	Endif
Else
	Alert("Este Pedido Nao Possui Numero para Deposito Identificado.")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA_FAT020_AP5บAutor  ณMicrosiga           บ Data ณ  12/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31ENDIV()

Local   _oDlg
Private aCOLS    := {}
Private aHEADER  := {}
Private aCOLUNAS := {}
Private aTITVENC := {}
nOpcx    := 7 //SO VISUALIZA

cLOJA    := SC5->C5_LOJACLI
cCLIENTE := SC5->C5_CLIENTE

DBSELECTAREA("SX3")
SX3->( DBSETORDER(2) )
SX3->( DBSEEK('A1_NREDUZ') )

Aadd(aHeader, {'Posi็ใo', SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Media'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes01'  ,  SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes02'  ,  SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes03'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes04'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes05'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes06'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Status'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
/*
Aadd(aHeader, {'Mes08'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes09'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes10'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes11'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
Aadd(aHeader, {'Mes12'  , SX3->X3_CAMPO, SX3->X3_PICTURE, 10, SX3->X3_DECIMAL, '.T.', ;
SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
*/
//SX3->( DBSEEK('E1_NATUREZ') )
//AAdd( aHEADER , { Trim( SX3->X3_TITULO ), SX3->X3_CAMPO, SX3->X3_PICTURE, "10", SX3->X3_DECIMAL, '.T.' , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )


nDiaAtu  := Day(dDataBase)
nMesAtu  := Month(dDataBase)
nAnoAtu  := Year(dDataBase)
aMeses   := {'JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SET','OUT','NOV','DEZ'}
nMesPagI := nMesAtu
nAnoPagI := nAnoAtu - 1
nMesVenI := IIf( nMesAtu == 12, 1, nMesAtu + 1 )
nAnoVenI := IIF( nMesAtu == 12, nAnoAtu + 1, nAnoAtu )
nMesVenF := IIf( nMesAtu == 12, 1, nMesAtu + 1 )
nAnoVenF := IIf( nMesAtu == 12, nAnoAtu + 2, nAnoAtu + 1 )
dPagI    := Ctod( '01/'+StrZero(nMesPagI,2)+'/'+Right(StrZero(nAnoPagI,4),2) )
dVenI    := Ctod( '01/'+StrZero(nMesVenI,2)+'/'+Right(StrZero(nAnoVenI,4),2) )
dPagF    := Ctod( '01/'+StrZero(nMesAtu,2)+'/'+Right(StrZero(nAnoAtu,4),2) ) - 1
dVenF    := Ctod( '01/'+StrZero(nMesVenF,2)+'/'+Right(StrZero(nAnoVenF,4),2) ) - 1
nMesPagF := Month(dPagF)
nAnoPagF := Year(dPagF)
nMesVenF := Month(dVenF)
nAnoVenF := Year(dVenF)

nContMes := 0
nMes     := nMesPagI
nAno     := nAnoPagI
aPagos   := { 0,0,0,0,0,0,0,0,0,0,0,0,0 }
aPerPag  := {}
aPer     := {}
AAdd( aPerPag, aMeses[nMesPagI]+'/'+Right(StrZero(nAnoPagI,4),2) )
AAdd( aPer, StrZero(nAnoPagI,4)+StrZero(nMesPagI,2) )
For nI := 2 To 11
	If nMes = 12
		nMes := 1
		nAno += 1
	Else
		nMes += 1
	EndIf
	AAdd( aPerPag, aMeses[nMes]+'/'+Right(StrZero(nAno,4),2) )
	AAdd( aPer, StrZero(nAno,4)+StrZero(nMes,2) )
Next nI
AAdd( aPerPag, aMeses[nMesPagF]+'/'+Right(StrZero(nAnoPagF,4),2) )
AAdd( aPer, StrZero(nAnoPagF,4)+StrZero(nMesPagF,2) )
cHRI := Time()
cQuery := "SELECT PERIODO = LEFT(E5_DATA,6), MES = SUM(E5_VALOR) "
cQuery += "FROM "  + RetSqlName("SE5") + " SE5 "
cQuery += "WHERE SE5.E5_DATA BETWEEN '"+aPer[7]+"01' AND '"+dtos(dPagF)+"' AND SE5.E5_NUMERO <> '' " //dtos(dPagI)
cQuery += "AND SE5.E5_CLIFOR = '" + cCLIENTE + "' " //AND SE5.E5_LOJA = '" + cLOJA + "' "
cQuery += "AND SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC IN ( 'VL','V2','BA','LJ','CP' ) "
cQuery += "AND SE5.E5_SITUACA <> 'C' AND SE5.E5_MOTBX <> 'LIQ' AND SE5.E5_MOTBX <> 'FAT' AND SE5.D_E_L_E_T_ = '' "
cQuery += "GROUP BY LEFT(E5_DATA,6) ORDER BY PERIODO "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP1', .T., .T.)

_nTotal := 0
_nQuant := 0
While TMP1->(!Eof())
	nPos := Ascan(aPer,{|x| X == TMP1->PERIODO })
	aPagos[nPos+1] += TMP1->MES
	//nPOS > 9 significa m้dia dos 3 ultimos meses, se nPos > 8, m้dia dos 4 ultimos meses e assim sucessivamente
	_nTotal        += IIf( nPos > 6, TMP1->MES, 0 )
	_nQuant        += IIf( nPos > 6, 1, 0 )
	TMP1->(DbSkip())
End
aPagos[1] := IIf( Empty(_nQuant), 0, Round( _nTotal/_nQuant, 2 ) )
TMP1->( DBCLOSEAREA() )

cQuery := "SELECT PERIODO = LEFT(E5_DATA,6), MES = SUM(E5_VALOR) "
cQuery += "FROM "  + RetSqlName("SE5") + " SE5 "
cQuery += "WHERE SE5.E5_DATA BETWEEN '"+aPer[7]+"01' AND '"+dtos(dPagF)+"' AND SE5.E5_NUMERO <> '' " //dtos(dPagI)
cQuery += "AND SE5.E5_CLIFOR = '" + cCLIENTE + "' " //AND SE5.E5_LOJA = '" + cLOJA + "' "
cQuery += "AND SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'ES' "
cQuery += "AND SE5.E5_SITUACA <> 'C' AND SE5.E5_MOTBX <> 'LIQ' AND SE5.E5_MOTBX <> 'FAT' AND SE5.D_E_L_E_T_ = '' "
cQuery += "GROUP BY LEFT(E5_DATA,6) ORDER BY PERIODO "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP2', .T., .T.)

cHRF := Time()
cTempo1 := ElapTime(cHRI,cHRF)

While TMP2->(!Eof())
	nPos := Ascan(aPer,{|x| X == TMP2->PERIODO })
	aPagos[nPos+1] -= TMP2->MES
	TMP2->(DbSkip())
End
TMP2->( DBCLOSEAREA() )


nMes     := nMesVenI
nAno     := nAnoVenI
aVenc    := { 0,0,0,0,0,0,0,0,0,0,0,0,0 }
aPerVen  := {}
aPer     := {}
AAdd( aPerVen, aMeses[nMesVenI]+'/'+Right(StrZero(nAnoVenI,4),2) )
AAdd( aPer, StrZero(nAnoVenI,4)+StrZero(nMesVenI,2) )
For nI := 2 To 11
	If nMes = 12
		nMes := 1
		nAno += 1
	Else
		nMes += 1
	EndIf
	AAdd( aPerVen, aMeses[nMes]+'/'+Right(StrZero(nAno,4),2) )
	AAdd( aPer, StrZero(nAno,4)+StrZero(nMes,2) )
Next nI
AAdd( aPerVen, aMeses[nMesVenF]+'/'+Right(StrZero(nAnoVenF,4),2) )
AAdd( aPer, StrZero(nAnoVenF,4)+StrZero(nMesVenF,2) )

cHRI := Time()
cQuery := "SELECT PERIODO = LEFT(E1_VENCREA,6), MES = SUM(E1_SALDO) "
cQuery += "FROM "  + RetSqlName("SE1") + " SE1 "
cQuery += "WHERE SE1.E1_CLIENTE = '" + cCLIENTE + "' AND SE1.E1_SALDO > 0 " //"' AND SE1.E1_LOJA = '" + cLOJA +
cQuery += "AND SE1.E1_VENCREA BETWEEN '"+dtos(dVenI)+"' AND '"+aPer[6]+"31"+"' " //dtos(dVenF)
cQuery += "AND SE1.E1_TIPO IN ( 'NF','JP','CH','CHD','DP','DEP' ) AND SE1.D_E_L_E_T_ = '' "
cQuery += "GROUP BY LEFT(E1_VENCREA,6) ORDER BY PERIODO "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP3', .T., .T.)
cHRF := Time()
cTempo2 := ElapTime(cHRI,cHRF)

_nTotal := 0
_nQuant := 0
While TMP3->(!Eof())
	nPos := Ascan(aPer,{|x| X == TMP3->PERIODO })
	aVenc[nPos+1] += TMP3->MES
	//nPOS < 4 significa m้dia dos 3 primeiros meses, se nPos < 5, m้dia dos 4 primeiros meses e assim sucessivamente
	_nTotal       += IIf( nPos < 7, TMP3->MES, 0 )
	_nQuant       += IIf( nPos < 7, 1, 0 )
	TMP3->(DbSkip())
End
aVenc[1] := IIf( Empty(_nQuant), 0, Round( _nTotal/_nQuant, 2 ) )
TMP3->( DBCLOSEAREA() )

cQuery := "SELECT MES = SUM(E5_VALOR) "
cQuery += "FROM "  + RetSqlName("SE5") + " SE5 "
cQuery += "WHERE LEFT(SE5.E5_DATA,6) = '"+Left(dtos(dPagF+1),6)+"' AND SE5.E5_NUMERO <> '' "
cQuery += "AND SE5.E5_CLIFOR = '" + cCLIENTE + "' " //AND SE5.E5_LOJA = '" + cLOJA + "' "
cQuery += "AND SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC IN ( 'VL','V2','BA','LJ','CP' ) "
cQuery += "AND SE5.E5_SITUACA <> 'C' AND SE5.E5_MOTBX <> 'LIQ' AND SE5.E5_MOTBX <> 'FAT' AND SE5.D_E_L_E_T_ = '' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP1', .T., .T.)

cQuery := "SELECT MES = SUM(E5_VALOR) "
cQuery += "FROM "  + RetSqlName("SE5") + " SE5 "
cQuery += "WHERE LEFT(SE5.E5_DATA,6) = '"+Left(dtos(dPagF+1),6)+"' AND SE5.E5_NUMERO <> '' "
cQuery += "AND SE5.E5_CLIFOR = '" + cCLIENTE + "' " //AND SE5.E5_LOJA = '" + cLOJA + "' "
cQuery += "AND SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'ES' "
cQuery += "AND SE5.E5_SITUACA <> 'C' AND SE5.E5_MOTBX <> 'LIQ' AND SE5.E5_MOTBX <> 'FAT' AND SE5.D_E_L_E_T_ = '' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP2', .T., .T.)
cHRF := Time()
cTempo3 := ElapTime(cHRI,cHRF)


cQuery := "SELECT MES = SUM(E1_SALDO) "
cQuery += "FROM "  + RetSqlName("SE1") + " SE1 "
cQuery += "WHERE SE1.E1_CLIENTE = '" + cCLIENTE + "' AND SE1.E1_SALDO > 0 " // AND SE1.E1_LOJA = '" + cLOJA + "'
cQuery += "AND LEFT(SE1.E1_VENCREA,6) = '"+Left(dtos(dPagF+1),6)+"' "
cQuery += "AND SE1.E1_TIPO IN ( 'JP','NF','CH','CHD','DP','DEP' ) AND SE1.D_E_L_E_T_ = '' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP3', .T., .T.)

cHRI := Time()
cQuery := "SELECT NJ = COUNT( SC5.C5_NUM ) "
cQuery += "FROM "  + RetSqlName("SC5") + " SC5 "
cQuery += "WHERE SC5.C5_CLIENTE = '" + cCLIENTE + "' AND SC5.C5_STATUS < '400' AND SC5.C5_DTCANC = '' AND SC5.D_E_L_E_T_ = '' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP4', .T., .T.)
cHRF    := Time()
cTempo3 := ElapTime(cHRI,cHRF)

nUsado   := 9 // Qtd de Campos
//aColunas := Array(7,nUsado+1)
aColunas := Array(6+TMP4->NJ,nUsado+1)
TMP4->( DBCLOSEAREA() )

cHRI := Time()
cQuery := "SELECT SC5.C5_NUM, MES = SUM(((SC6.C6_VALOR+SC6.C6_DESCIPI)/SC6.C6_QTDVEN)*SC6.C6_QTDEMP) "
cQuery += "FROM "  + RetSqlName("SC5") + " SC5, "+ RetSqlName("SC6") + " SC6 "
cQuery += "WHERE SC5.C5_CLIENTE = '" + cCLIENTE + "' AND SC5.C5_STATUS < '400' AND SC5.C5_DTCANC = '' "
cQuery += "AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_QTDVEN > 0 AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "
cQuery += "GROUP BY SC5.C5_NUM ORDER BY SC5.C5_NUM "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP4', .T., .T.)
cHRF := Time()
cTempo4 := ElapTime(cHRI,cHRF)

// Incluida por pedro 11/02/2005
cHRI := Time()
cQuery := "SELECT MES = SUM(E1_SALDO) "
cQuery += "FROM "  + RetSqlName("SE1") + " SE1 "
cQuery += "WHERE SE1.E1_CLIENTE = '" + cCLIENTE + "' AND SE1.E1_SALDO > 0 " //"' AND SE1.E1_LOJA = '" + cLOJA +
cQuery += "AND SE1.E1_VENCREA < '"+Dtos(dDataBase)+"' " //dtos(dVenF)
cQuery += "AND SE1.E1_TIPO IN ( 'NF','JP','CH','CHD','DP','DEP' ) AND SE1.D_E_L_E_T_ = '' "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP5', .T., .T.)
cHRF := Time()
cTempo2 := ElapTime(cHRI,cHRF)


aCOLUNAS[ 1, 1 ]  := " "
aCOLUNAS[ 1, 2 ]  := PadL("Media",10)
For nI := 3 To 8
	aColunas[ 1, nI ] := PadL(aPerPag[14-(nI-1)],10)
next nI
aCOLUNAS[ 1, 10 ] := .F.
aCOLUNAS[ 2, 1  ] := "Pagos"
aCOLUNAS[ 2, 2  ] := Transform(aPagos[1],"@E 999,999.99")
For nI := 3 To 8
	aColunas[ 2, nI ] := Transform(aPagos[14-(nI-2)],"@E 999,999.99")
next nI
aCOLUNAS[ 2, 10 ] := .F.
aCOLUNAS[ 3, 1  ]  := " "
aCOLUNAS[ 3, 2  ]  := PadL("Media",10)
For nI := 3 To 8
	aColunas[ 3, nI ] := PadL(aPerVen[nI-2],10)
next nI
aCOLUNAS[ 3, 10 ] := .F.
aCOLUNAS[ 4, 1  ]  := "A Vencer"
For nI := 2 To 8
	aColunas[ 4, nI ] := Transform(aVenc[nI-1],"@E 999,999.99")
next nI
aCOLUNAS[ 4, 10 ] := .F.
//

nJ := 5
aVenc[1] := 0
While TMP4->(!EOF())
	
	aCOLUNAS[ nJ, 1 ]  := TMP4->C5_NUM
	aCOLUNAS[ nJ, 2 ]  := Transform(TMP4->MES,"@E 999,999.99")
	aVenc[1]           += TMP4->MES
	
	aAPagar  := Promocao( TMP4->C5_NUM,TMP4->MES )
	aValPar  := {0,0,0,0,0,0}
	For nI := 1 To Len(aAPagar)
		nPos := Ascan(aPer,{|x| X == Left(Dtos(aAPagar[nI,1]),6) })
		If nPos > 0
			aValPar[ nPos ]        += aAPagar[nI,2]
			aColunaS[ nJ, nPos+2 ] := Transform(aValPar[ nPos ],"@E 999,999.99")
			aVenc[ nPos+1 ]        += aAPagar[nI,2]
			aCOLUNAS[ nJ, 9  ]     := aAPagar[nI,3]
		EndIf
	Next nI
	
	For nI := 3 To 8
		If Empty( aColunaS[ nJ, nI ] )
			aColunas[ nJ, nI ] := Transform(0,"@ 999,999.99")
		EndIf
	next nI
	aCOLUNAS[ nJ, 10 ] := .F.
	
	nJ ++
	TMP4->(DbSkip())
	
End
//If nJ > 6
aCOLUNAS[ nJ, 1  ] := "Total"
For nI := 2 To 8
	aColunas[ nJ, nI ] := Transform(aVenc[nI-1],"@E 999,999.99")
next nI
//EndIf
aCOLUNAS[ nJ, 10 ] := .F. //.T.
nJ ++
aCOLUNAS[ nJ,  1 ] := "Pagos Mes"
aCOLUNAS[ nJ,  2 ] := Transform(TMP1->MES-TMP2->MES,"@E 999,999.99")
aCOLUNAS[ nJ,  3 ] := "Saldo Mes"
aCOLUNAS[ nJ,  4 ] := Transform(TMP3->MES,"@E 999,999.99")
aCOLUNAS[ nJ,  5 ] := "Vencidos"                           // alterei aqui inclui estas duas linhas (Pedro)  11/02/2005
aCOLUNAS[ nJ,  6 ] := Transform(TMP5->MES,"@E 999,999.99") // Solicitado por Ana Maria
aCOLUNAS[ nJ, 10 ] := .F.

TMP1->( DBCLOSEAREA() )
TMP2->( DBCLOSEAREA() )
TMP3->( DBCLOSEAREA() )
TMP4->( DBCLOSEAREA() )
TMP5->( DBCLOSEAREA() )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Cabecalho do Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cTitulo := "Endividamento"


aCols := aCOLUNAS

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Cabecalho do Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCliente:=Space(6)
cLoja	:=Space(2)
dData	:= MsDate()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinGetD:=0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Titulo da Janela                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTitulo:="Analise de Cr้dito"
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
//AADD(aC,{"cCliente"	,{15,10} ,"Cod. do Cliente"	,"@!"			,"ExecBlock('Md2VlCli',.f.,.f.)","SA1",})
//AADD(aC,{"cLoja"	,{15,200},"Loja"			,"@!"			,,,})
//AADD(aC,{"dData"	,{27,10} ,"Data de Emissao"	,				,,,})
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
//AADD(aR,{"nLinGetD"	,{120,10},"Linha na GetDados"	,"@E 999",,,.F.})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCGD:={30,5,118,315}
//aCGD:={44,5,118,315}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLinhaOk:=".T."
cTudoOk :=".T."
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
Dbselectarea("SC5")
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente
If lRetMod2
	Alert( ctempo1 + ' - ' + ctempo2 + ' - ' + ctempo3 + ' - ' + ctempo4 )
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA_FAT020_AP5บAutor  ณMicrosiga           บ Data ณ  12/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Promocao(_cPed,nVAL_PED)

DbSelectArea("SC5")
_aAreaSC5 := GetArea()
DbSetOrder(1)
DbSeek( xFilial("SC5") + _cPed )
_cSt := IIF(Left(SC5->C5_STATUS,1)=="0", "Vendas", IIF(Left(SC5->C5_STATUS,1)=="1", "Credito", IIF(Left(SC5->C5_STATUS,1)=="2", "Estoque", "Faturamento" ) ) )

DbSelectArea("SE4")
_aAreaSE4 := GetArea()
DbSetOrder(1)
DbSeek( xFilial("SE4") + SC5->C5_CONDPAG )

aPag := {}
aCond := Condicao(nVAL_PED,SC5->C5_CONDPAG,dDataBase)


If	SC5->C5_DT_DIG >= CtoD( '01/12/04' ) .And. SC5->C5_DT_DIG <= CtoD( '31/12/04' ) .And. AllTrim(SC5->C5_VEND2) == 'S'
	
	lAvista := iif( SC5->C5_CONDPAG $ AllTrim(GetMv('MV_CONDLIB')), .T. , .F. )
	If lAvista
		lAC10D  := iif( Val(AllTrim(SE4->E4_COND)) > 10, .T. , .F. )
	EndIf
	dDataV  := iif( lAvista, IIf( lAC10D, CtoD( '03/02/05' ), CtoD( '03/02/05' ) ), CtoD( '14/02/05' ) )
	nDias   := IIf( dDataV > aCond[1,1], dDataV - aCond[1,1], 0 )
	For nI  := 1 To Len(aCond)
		dVenc  := aCond[nI,1] + nDias
		dVencR := dVenc + IIf( Dow( dVenc ) == 7, 1, IIf( Dow( dVenc ) == 6, 2, 0 ) )
		AAdd( aPAG, { IIf( dVenc > aCond[nI,1], dVenc, aCond[nI,1] ), aCond[nI,2], _cSt } )
	Next nI
Else
	
	For nI  := 1 To Len(aCond)
		AAdd( aPAG, { aCond[nI,1], aCond[nI,2], _cSt } )
	Next nI
	
EndIf

RestArea( _aAreaSC5 )
RestArea( _aAreaSE4 )

Return(aPag)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFAT31SEN()
Private oDlg0,lSenha := .f.


DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 135,395 TITLE "Advanced Protheus" OF oMainWnd PIXEL

@ 010, 025 SAY OemToAnsi("Usuario") SIZE 060, 007
@ 019, 025 GET cNome    SIZE 060, 010 VALID lNome := FATSEN_1(_cSenha,cNome)

@ 010, 092 SAY OemToAnsi("Senha") SIZE 053, 007
@ 019, 092 GET _cSenha  SIZE 060, 010 PASSWORD VALID (lSenha := FATSEN_1(_cSenha,cNome) .And. !Empty(_cSenha))

DEFINE SBUTTON FROM 036, 082 TYPE 1 ACTION (oDlg0:End()) ENABLE OF oDlg0
DEFINE SBUTTON FROM 036, 122 TYPE 2 ACTION (oDlg0:End(),lSenha := .F. ) ENABLE OF oDlg0

ACTIVATE DIALOG oDlg0 CENTERED

Return(IIF(lSenha,.t.,.f.))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FATSEN_1(cSen,cNom)

Local aArea

aArea:= GETAREA()
PswOrder(2)
IF !PswSeek(cNom)
	Alert("Nome invalido")
	RETURN(.F.)
ENDIF

if !EMPTY(cSEN)
	If !PswName(cSen) //senha
		Alert("Senha ou nome invalidos ")
		RETURN(.F.)
	EndIf
ENDIF

RESTAREA(aArea)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT031   บAutor  ณMicrosiga           บ Data ณ  10/27/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mostra_desconto()

Local GetEdt

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

cTitulo:= "Desconto no Pedido : "+SC5->C5_NUM
nOpcx:=6 //Alterar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado:=0
aHeader:={}

aadd(aHeader,{"Item"        ,"C6_ITEM"   ,"@!"                 ,02,0,'',USADO,"C","SC6","V"})
aadd(aHeader,{"Produto"     ,"C6_PRODUTO","@!"                 ,15,0,'',USADO,"C","SC6","V"})
aadd(aHeader,{"Descricao"   ,"C6_DESCRI" ,"@!"                 ,30,0,'',USADO,"C","SC6","V"})
aadd(aHeader,{"Desc.Cx.Fech","C6_DESCCX" ,"@E 99.99"           ,05,2,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Desc.Ocasion","C6_DESCOC" ,"@E 99.99"           ,05,2,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Prc.Unitario","C6_PRCVEN" ,"@E 99,999,999.9999" ,11,4,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Vlr.Total"   ,"C6_VALOR"  ,"@E 999,999,999.9999",12,2,'',USADO,"N","SC6","R"})
aadd(aHeader,{"% Desconto"  ,"C6_DESCONT","@E 99.99"           ,05,2,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Quantidade"  ,"C6_QTDVEN" ,"@E 999999.99"       ,09,2,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Prc Lista"   ,"C6_PRUNIT" ,"@E 999,999.9999"    ,11,4,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Vlr Desconto","C6_VALDESC","@E 999,999,999.9999",14,4,'',USADO,"N","SC6","R"})
aadd(aHeader,{"Qrb. Repres.","C6_QRBREP" ,"@E 99,999,999"      ,10,0,'',USADO,"N","SC6","R"})

nUsado := len(AHeader)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aCols                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SC6")
cQUERY := "SELECT C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_DESCCX,C6_DESCOC,C6_DESCONT,C6_QTDVEN, "
cQuery += "C6_QRBREP,C6_PRUNIT,C6_PRCVEN,C6_VALDESC,C6_VALOR "
cQUERY += " FROM " + RetSqlName( "SC6" ) + " SC6 "
cQUERY += " WHERE SC6.C6_NUM = '" + SC5->C5_NUM + "' "
cQUERY += " AND SC6.D_E_L_E_T_ = ''"
cQUERY += " ORDER BY SC6.C6_ITEM "

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPZZT
TCQUERY cQUERY Alias TMPSC6 New

TcSetField( "TMPSC6", "C6_DESCOC" , "N", 05, 2 )
TcSetField( "TMPSC6", "C6_DESCCX" , "N", 05, 2 )
TcSetField( "TMPSC6", "C6_VALDESC", "N", 14, 4 )
TcSetField( "TMPSC6", "C6_QRBREP" , "N", 10, 0 )
TcSetField( "TMPSC6", "C6_DESCONT", "N", 05, 2 )
TcSetField( "TMPSC6", "C6_QTDVEN" , "N", 09, 2 )
TcSetField( "TMPSC6", "C6_PRUNIT" , "N", 11, 2 )
TcSetField( "TMPSC6", "C6_PRCVEN" , "N", 11, 4 )
TcSetField( "TMPSC6", "C6_VALOR"  , "N", 12, 2 )

//Carrega arquivo de trabalho criado com os dados da consulta
nTam := 0
Dbselectarea("TMPSC6")
dbgotop()
While !Eof()
	nTam ++
	dbskip()
End

If nTam == 0
	nTam := 1
Endif

//Cria um array para carregar os dados dos titulos
aCols:=Array(nTam,nUsado+1)

Dbselectarea("TMPSC6")
dbgotop()

ncnt := 0
If !Eof()
	While  !EOF()
		ncnt ++
		//Posiciona no cadastro de natureza para carregar a descricao da mesma
		aCOLS[nCnt][01] := TMPSC6->C6_ITEM
		aCOLS[nCnt][02] := TMPSC6->C6_PRODUTO
		aCOLS[nCnt][03] := TMPSC6->C6_DESCRI
		aCOLS[nCnt][04] := ""//TMPSC6->C6_DESCCX
		aCOLS[nCnt][05] := ""//TMPSC6->C6_DESCOC
		aCOLS[nCnt][06] := TMPSC6->C6_PRCVEN
		aCOLS[nCnt][07] := TMPSC6->C6_VALOR
		aCOLS[nCnt][08] := TMPSC6->C6_DESCONT
		aCOLS[nCnt][09] := TMPSC6->C6_QTDVEN
		aCOLS[nCnt][10] := TMPSC6->C6_PRUNIT
		aCOLS[nCnt][11] := TMPSC6->C6_VALDESC
		aCOLS[nCnt][12] := 0//TMPSC6->C6_QRBREP
		aCOLS[ncnt][nUsado+1] := .F.
		Dbselectarea("TMPSC6")
		dbSkip()
	EndDo
Else
	aCOLS[1][01] := "NENHUM RASTRO"
	aCOLS[1][02] := ""
	aCOLS[1][03] := ""
	aCOLS[1][04] := 0
	aCOLS[1][05] := 0
	aCOLS[1][06] := 0
	aCOLS[1][07] := 0
	aCOLS[1][08] := 0
	aCOLS[1][09] := 0
	aCOLS[1][10] := 0
	aCOLS[1][11] := 0
	aCOLS[1][12] := 0
	aCOLS[1][nUsado+1] := .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis do Rodape do Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCGD := {20,02,170,400}
//aCGD := {50,02,155,375}

//nAcordW := {40,0,400,760}
nAcordW := {70,05,450,800}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacoes na GetDados da Modelo 2                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cLinhaOk:=".T."
cTudoOk:=".T."
GetEdt := {}              // Array para Atribuir os campos editแveis
Aadd(GetEdt,"C6_DESCCX")
Aadd(GetEdt,"C6_DESCOC")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

//lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:= Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,GetEdt,,,,nAcordW)

Dbselectarea("TMPSC6")
If lRetMod2
	N_ordold := SC6->(IndexOrd())
	SC6->(DbSetOrder(1))
	For i := 1 to len(ACols)
		if SC6->(DbSeek(XFilial("SC6")+SC5->C5_NUM+ACols[i,1]+ACols[i,2]))
			if RecLock("SC6",.f.)
				replace SC6->C6_DESCCX with ACols[i,4]
				replace SC6->C6_DESCOC with ACols[i,5]
				SC6->(MSunlock())
				//
				_nDescPed := 100
				_nDescPed := IIf( !Empty( SC5->C5_DESC1 ), _nDescPed - SC5->C5_DESC1, _nDescPed )
				_nDescPed := IIf( !Empty( SC5->C5_DESC2 ), _nDescPed - (_nDescPed*(SC5->C5_DESC2/100)), _nDescPed )
				_nDescPed := IIf( !Empty( SC5->C5_DESC3 ), _nDescPed - (_nDescPed*(SC5->C5_DESC3/100)), _nDescPed )
				_nDescPed := IIf( !Empty( SC5->C5_DESC4 ), _nDescPed - (_nDescPed*(SC5->C5_DESC4/100)), _nDescPed )
				_nDescPed := 100 - _nDescPed
				//
				aRetDesc := U_CalDesPv()
				nDescont := aRetDesc[1]
				nPrcUnit := aRetDesc[2]
				_ValDes  := Round(nPrcUnit *((100-_nDescPed)/100),4)* SC6->C6_QTDVEN
				_ValDes  := Round(_ValDes * ( nDescont / 100 ), 4 )
				If RecLock("SC6",.f.)
					replace SC6->C6_DESCONT with nDescont
					replace SC6->C6_VALDESC with ACols[i,11]
					replace SC6->C6_PRCVEN  with ACols[i,06]
					replace SC6->C6_VALOR   with ACols[i,07]
					SC6->(MSUnlock())
				endif
			endif
		endif
	Next
	SC6->(DbSetOrder(N_ordold))
Endif
TMPSC6->(DbCloseArea())

Return