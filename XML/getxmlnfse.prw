#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE STR0012 "Consultando NFE"
#DEFINE STR0013 "Aguarde..."

/*���������������������������������������������������������������������������
���Programa  :NEWSOURCE � Autor :TEC1 - Designer       � Data :10/04/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao :                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros:                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   :                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       :                                                            ���
���������������������������������������������������������������������������*/

User Function getxmlnfse()

PRIVATE cCNPJ		:= space(15)
PRIVATE cNota		:= space(9)
PRIVATE cRet		:= space(15)

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg1","oGet1","oMGet1","oSay1","oBtn1","oGet2","oSay2")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlg1      := MSDialog():New( 126,254,616,822,"oDlg1",,,.F.,,,,,,.T.,,,.F. )
oGet1      := TGet():New( 024,012,{|u| If(PCount()>0,cCNPJ:=u,cCNPJ)},oDlg1,065,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCNPJ",,)

oMGet1     := TMultiGet():New( 048,012,,oDlg1,257,178,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cRet:=u,cRet)}

oSay1      := TSay():New( 016,012,{||"CNPJ"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBtn1      := TButton():New( 024,216,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || fLeXML() }

oGet2      := TGet():New( 024,088,{|u| If(PCount()>0,cNota:=u,cNota)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNota",,)
oSay2      := TSay():New( 016,088,{||"Nota"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oDlg1:Activate(,,,.T.)

Return

Static Function fLeXML()

Local bARDSearch

Local cXML

Local cError		:= ""
Local cWarning		:= ""

Local cOcorrD
Local cOcorr
Local cMaq
Local cLado
Local cTipo
Local cData
Local cHora

Local oNFE
Local oXML

WSDLDbgLevel(2)

bARDSearch := { ||											; 
					oNFE 				:= WSU_WSGETXMLNFSE():New(),	;
					oNFE:cCODEMP		:= "02",				;
					oNFE:cCODFIL		:= "01",				;
					oNFE:cCNPJ			:= AllTrim(cCNPJ),				;
					oNFE:cNUMERODANFS	:= cNota,				;
					oNFE:GETXMLNFSE()						;
			   }	

MsgRun( STR0013 , STR0012 , bARDSearch ) //"Aguarde"###"Consultando NFE"

If Type(oNFE:cGETXMLNFSERESULT) == "O"
	
	cRet		:= oNFE:cGETXMLNFSERESULT
	oDlg1:Refresh()
	oXML		:= XmlParser( cRet , "_" , @cError , @cWarning )

EndIf

Return .T.
