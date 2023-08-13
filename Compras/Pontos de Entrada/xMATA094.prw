#INCLUDE "PROTHEUS.CH"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"
#INCLUDE "Topconn.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATA094  �Autor  �Gustavo Costa       � Data �  05/03/20    ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na libera��o do documento de entrada.      ���
���          � 							 								  ���
�������������������������������������������������������������������������͹��
���Uso       � Adiciona bot�es ao Menu Principal atrav�s do array aRotina.���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
MODELPRE 		- Antes da altera��o de qualquer campo do modelo.
MODELPOS 		- Na valida��o total do modelo.
FORMPRE 		- Antes da altera��o de qualquer campo do formul�rio.
FORMPOS 		- Na valida��o total do formul�rio.
FORMLINEPRE 	- Antes da altera��o da linha do formul�rio FWFORMGRID.
FORMLINEPOS 	- Na valida��o total da linha do formul�rio FWFORMGRID.
MODELCOMMITTTS 	- Ap�s a grava��o total do modelo e dentro da transa��o.
MODELCOMMITNTTS - Ap�s a grava��o total do modelo e fora da transa��o.
FORMCOMMITTTSPRE - Antes da grava��o da tabela do formul�rio.
FORMCOMMITTTSPOS - Ap�s a grava��o da tabela do formul�rio.
MODELCANCEL 	- No cancelamento do bot�o.
BUTTONBAR 		- Para a inclus�o de bot�es na ControlBar.
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
       
	nOpc := oObj:GetOperation() // PEGA A OPERA��O
	
	If cIdPonto == 'MODELPRE'
           
		xRet := SetKEY( VK_F8, {|| U_fHistComp()} )
	
	EndIf       

EndIf

Return xRet


/*���������������������������������������������������������������������������
���Programa  :fHistComp � Autor :Gustavo Costa         � Data :05/03/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descricao :  Mostra historico de compra do produto                     ���
�������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������*/

User Function fHistComp()

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/

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

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
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

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg7      := MSDialog():New( 200,150,380,1270,"HIST�RICO DE COMPRA DO PRODUTO",,,.F.,,,,,,.T.,,,.F. )


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


