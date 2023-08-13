#INCLUDE "PROTHEUS.CH"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"
#INCLUDE "Topconn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATA094  ºAutor  ³Gustavo Costa       º Data ³  05/03/20    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na liberação do documento de entrada.      º±±
±±º          ³ 							 								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adiciona botões ao Menu Principal através do array aRotina.º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATA094()

 Local aParam := PARAMIXB
 Local xRet := .T.
 Local oObj := ""
 Local cIdPonto := ""
 Local cIdModel := ""
 Local lIsGrid := .F.
 Local nLinha := 0
 Local nQtdLinhas := 0
 Local cMsg := ""
 Local nOp

/**********************************************************************
MODELPRE 		- Antes da alteração de qualquer campo do modelo.
MODELPOS 		- Na validação total do modelo.
FORMPRE 		- Antes da alteração de qualquer campo do formulário.
FORMPOS 		- Na validação total do formulário.
FORMLINEPRE 	- Antes da alteração da linha do formulário FWFORMGRID.
FORMLINEPOS 	- Na validação total da linha do formulário FWFORMGRID.
MODELCOMMITTTS 	- Após a gravação total do modelo e dentro da transação.
MODELCOMMITNTTS - Após a gravação total do modelo e fora da transação.
FORMCOMMITTTSPRE - Antes da gravação da tabela do formulário.
FORMCOMMITTTSPOS - Após a gravação da tabela do formulário.
MODELCANCEL 	- No cancelamento do botão.
BUTTONBAR 		- Para a inclusão de botões na ControlBar.
***********************************************************************/

If aParam <> NIL
      
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]
	lIsGrid    := ( Len( aParam ) > 3 )
	
	If lIsGrid
		//nQtdLinhas := oObj:GetQtdLine()
        //nLinha     := oObj:nLine
        //FWFORMFIELDSMODEL:GETQTDLINE
    EndIf
       
	nOpc := oObj:GetOperation() // PEGA A OPERAÇÃO
	
	If cIdPonto == 'MODELPRE'
           
		xRet := SetKEY( VK_F8, {|| U_fHistComp()} )
	
	EndIf       

EndIf

Return xRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fHistComp ³ Autor :Gustavo Costa         ³ Data :05/03/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra historico de compra do produto                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fHistComp()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQuery		:= ''
Local _oModel 		:= FWModelActive()
Local _oModelDET 	:= _oModel:GetModel("GridDoc")
Local cProduto		:= ""

//_oModelDET:GoLine(nI)
cProduto		:= _oModelDET:GetValue("C7_PRODUTO", _oModelDET:GetLine())

If Empty(cProduto)
	MsgAlert("Clique em um produto antes!")
	Return .T.
EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg7","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

cQuery := " SELECT TOP 5 D1_FILIAL, D1_DTDIGIT, D1_COD, D1_QUANT, D1_VUNIT, D1_FORNECE, D1_LOJA, A2_NOME FROM SD1020 D1 "
cQuery += " INNER JOIN SA2010 A2 "
cQuery += " ON D1_FORNECE + D1_LOJA = A2_COD + A2_LOJA "
cQuery += " WHERE D1_COD = '" + cProduto + "' "
cQuery += " AND D1.D_E_L_E_T_ = '' "
cQuery += " AND D1_TIPO = 'N' "
cQuery += " ORDER BY D1_DTDIGIT DESC "


If Select("TMP7") > 0
	DbSelectArea("TMP7")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP7"
TCSetField( "TMP7", "D1_DTDIGIT", "D")

TMP7->( DbGoTop() )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg7      := MSDialog():New( 200,150,380,1270,"HISTÓRICO DE COMPRA DO PRODUTO",,,.F.,,,,,,.T.,,,.F. )


oBrw7      := MsSelect():New( "TMP7","","",{{"D1_FILIAL"	,"","Filial"		,""},;
											{"D1_DTDIGIT"	,"","Data"			,""},;
											{"D1_COD"		,"","Produto"		,""},;
											{"D1_QUANT"		,"","Quant."		,"@E 9,999,999.99999"},;
											{"D1_VUNIT"		,"","Valor Unit."	,"@E 9,999,999.99"},;
											{"D1_FORNECE"	,"","Cod. For."		,""},;
											{"D1_LOJA"		,"","Loja"			,""},;
											{"A2_NOME"		,"","Fornecedor"	,""}},.F.,,{001,001,090,561},,, oDlg7 ) 
oBrw7:oBrowse:nClrPane := CLR_BLACK
oBrw7:oBrowse:nClrText := CLR_BLACK

oDlg7:Activate(,,,.T.)

TMP7->(DbCloseArea())

Return


