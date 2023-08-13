#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

static cRetCB

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CODBARR   �Autor  �Eurivan Marques     � Data �  20/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calcula digito verificador para codigo EAN 13               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RAVA EMBALAGENS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
********************************
static function GetCB()
********************************

local lErro := .F.
//Pesos para cada posi��o de acordo com o manual da Ean do Brasil para C�digo de 13 nros. 12 + 1 DV
local aPeso    := {1,3,1,3,1,3,1,3,1,3,1,3,}
local nPosicao, nNumero, nSoma, nFinal
local cResult
local cPais    := '789'//Codigo do pais
local cEmpresa := '80102'//Codigo da Empresa
local cCod     :=  GetMV('MV_SEQCB')//Sequencia do Cod Produto
local cCodEAN  := cPais+cEmpresa+cCod

lErro := .F.
cResult := '0'

if Len( cCodEAN ) <> 12 
   Alert('Erro: Informe os 12 D�gitos do C�digo!')
   lErro := .T.
endif

if !lErro
   nSoma := 0
   for nPosicao := 1 to 12
      nNumero := Val( Substr ( cCodEAN , nPosicao , 1 ))
      nSoma += ( nNumero * aPeso[ nPosicao ] )
   next nPosicao

   nFinal:= Val( Substr( Alltrim(Str(nSoma)), Len( Alltrim(Str( nSoma ) ) ), 1 ) )
   if nFinal = 0
      cResult := '0'
   else
      cResult := Alltrim(Str( 10 - nFinal ))
   endif   
   cResult := cCodEAN + cResult

   //testo se o codigo de barra ja est� cadastrado no sistema
   if TemCB(cResult)
      cResult := GetCB()
   endif   
     
endif

return cResult


*********************
user function RetCB()
*********************
return cRetCB


**************************
static function TemCB(cCB)
**************************
local lTem := .F.
local cQuery

cQuery := "SELECT B1_COD, B1_CODFARD, B1_CODPACO "
cQuery += "FROM "+RetSqlName("SB1")+ " 
cQuery += "WHERE ( B1_CODFARD = '"+cCB+"' OR B1_CODPACO = '"+cCB+"' ) AND D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "TMP_X"
lTem := !TMP_X->(Eof())
TMP_X->(DbCloseArea())

return lTem


***********************
User Function CodBarr()
***********************
local lOk := .T.

if Inclui .or. Altera
   if Empty( &(ReadVar()) )

      /*������������������������������������������������������������������������ٱ�
      �� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
      ٱ�������������������������������������������������������������������������*/
      Private cCodBarr   := Space(13)

      /*������������������������������������������������������������������������ٱ�
      �� Declara��o de Variaveis Private dos Objetos                             ��
      ٱ�������������������������������������������������������������������������*/
      SetPrvt("oDlg1","oGet1","oSay1","oBtn1","oBtn2")
 
      /*������������������������������������������������������������������������ٱ�
      �� Definicao do Dialog e todos os seus componentes.                        ��
      ٱ�������������������������������������������������������������������������*/
      oDlg1      := MSDialog():New( 248,396,342,813,"Codigo de Barras",,,.F.,,,,,,.T.,,,.F. )
      oGet1      := TGet():New( 024,008,,oDlg1,140,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCodBarr",,)
      oGet1:bSetGet := {|u| If(PCount()>0,cCodBarr:=u,cCodBarr)}

      oSay1      := TSay():New( 012,008,{||"C�digo Gerado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,049,008)
      oBtn1      := TButton():New( 008,160,"Confirmar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
      oBtn1:bAction := {||PutMV('MV_SEQCB', Soma1(GetMV('MV_SEQCB'))),cRetCB := cCodBarr,oDlg1:End()}
      oBtn2      := TButton():New( 024,160,"Cancelar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
      oBtn2:bAction := {||oDlg1:End()}
      cCodBarr := GetCB()
      oDlg1:Activate(,,,.T.)
   else
       Alert('Para o sistema gerar o Codigo de Barras, o campo deve estar vazio.')
       lOk := .F.
   endif
else
   lOk := .F.
endif

Return lOk