#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

static cRetCB

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCODBARR   บAutor  ณEurivan Marques     บ Data ณ  20/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula digito verificador para codigo EAN 13               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RAVA EMBALAGENS                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
********************************
static function GetCB()
********************************

local lErro := .F.
//Pesos para cada posi็ใo de acordo com o manual da Ean do Brasil para C๓digo de 13 nros. 12 + 1 DV
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
   Alert('Erro: Informe os 12 Dํgitos do C๓digo!')
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

   //testo se o codigo de barra ja estแ cadastrado no sistema
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

      /*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
      ฑฑ Declara็ใo de Variaveis do Tipo Local, Private e Public                 ฑฑ
      ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
      Private cCodBarr   := Space(13)

      /*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
      ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
      ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
      SetPrvt("oDlg1","oGet1","oSay1","oBtn1","oBtn2")
 
      /*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
      ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
      ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
      oDlg1      := MSDialog():New( 248,396,342,813,"Codigo de Barras",,,.F.,,,,,,.T.,,,.F. )
      oGet1      := TGet():New( 024,008,,oDlg1,140,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCodBarr",,)
      oGet1:bSetGet := {|u| If(PCount()>0,cCodBarr:=u,cCodBarr)}

      oSay1      := TSay():New( 012,008,{||"C๓digo Gerado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,049,008)
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