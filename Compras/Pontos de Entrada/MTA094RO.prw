#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA094RO �Autor  �Gustavo Costa       � Data �  05/03/20    ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na libera��o do documento de entrada.      ���
���          � 							 								  ���
�������������������������������������������������������������������������͹��
���Uso       � Adiciona bot�es ao Menu Principal atrav�s do array aRotina.���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA094RO

Local aRotina:= PARAMIXB[1]

//..Customiza��o do cliente 	
aAdd(aRotina,{ "Historico", "U_fTransfPrd(SC7->C7_PRODUTO)", 0 , 2, 0, .F.})	

Return aRotina


/*���������������������������������������������������������������������������
���Programa  :fHistComp � Autor :Gustavo Costa         � Data :05/03/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descricao :  Mostra historico de compra do produto                     ���
�������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������*/

User Function fTransfPrd(_Prod)

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/

local cQuery		:= ''
Local cProduto		:= _Prod


/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oFont2","oDlg7","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

cQuery := " SELECT TOP 5 D1_FILIAL, D1_DTDIGIT, D1_COD, D1_QUANT, D1_VUNIT, D1_FORNECE, D1_LOJA, A2_NOME FROM SD1020 D1 "
cQuery += " INNER JOIN SA2010 A2 "
cQuery += " ON D1_FORNECE + D1_LOJA = A2_COD + A2_LOJA "
cQuery += " WHERE D1_COD = '" + cProduto + "' "
cQuery += " AND D1.D_E_L_E_T_ = '' "
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
oDlg7      := MSDialog():New( 241,176,551,1203,"HIST�RICO DE COMPRA DO PRODUTO",,,.F.,,,,,,.T.,,,.F. )


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


