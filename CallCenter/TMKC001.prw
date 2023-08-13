#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE "Topconn.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  : TMKC001  ³ Autor :Eurivan Marques       ³ Data :25/07/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Consulta Assuntos CallCenter                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros: Nivel do assunto                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   : Codigo do Assunto                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       : CallCenter                                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

static cRet1, cRet2

***********************
User Function TMKC001()
***********************
Local cCod 
Local nNivel 
Private cFind      := Space(50)
Private cARQTMP

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgTMK1","oBrw1","oSay1","oGet1","oSBtn1","oSBtn2")

if ReadVar() == "M->UD_N1"
   cCod := ""
   nNivel := 1
elseif ReadVar() == "M->UD_N2"
   cCod := aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "UD_N1" } )]
   nNivel := 2
elseif ReadVar() == "M->UD_N3"
   cCod := aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "UD_N2" } )]
   nNivel := 3
elseif ReadVar() == "M->UD_N4"
   cCod := aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "UD_N3" } )]
   nNivel := 4
elseif ReadVar() == "M->UD_N5"
   cCod := aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "UD_N4" } )]
   nNivel := 5
endif   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgTMK1 := MSDialog():New( 129,407,446,959,"Lista de Assuntos",,,.F.,,,,,,.T.,,,.F. )
oSay1    := TSay():New( 139,004,{||"Localizar:"},oDlgTMK1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Assuntos(cCod,nNivel)
DbSelectArea("Z46X")
oBrw1    := MsSelect():New( "Z46X","","",{{"Z46_CODIGO","","Codigo",""},;
                                            {"Z46_DESCRI","","Descricao",""}},.F.,,{004,004,134,242},,,oDlgTMK1 )
oGet1  := TGet():New( 140,044,,oDlgTMK1,156,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFind",,)
oGet1:bSetGet := {|u| If(PCount()>0,cFind:=u,cFind)}

oBtn1  := TButton():New( 139,204,"Pesquisar",oDlgTMK1,,038,010,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||Z46X->(DbSeek(cFind),.T.)}

oSBtn1 := SButton():New( 004,245,1,,oDlgTMK1,,"", )
oSBtn1:bAction := {||oDlgTMK1:End()}

oSBtn2 := SButton():New( 020,245,2,,oDlgTMK1,,"", )
oSBtn2:bAction := {||oDlgTMK1:End()}
oDlgTMK1:Activate(,,,.T.)

cRet1 := Z46X->Z46_CODIGO
cRet2 := Z46X->Z46_DESCRI

Z46X->(DbCloseArea())

Ferase(cARQTMP+GetDBExtension())
Ferase(cARQTMP+OrdBagExt())

DbSelectArea("Z46")

Return .T.

*************************
user function RetAss()
*************************

return cRet1+cRet2


*************************************
static function Assuntos(cCod,nNivel)
*************************************

Local cQuery := ""

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
if nNivel = 1
   cQuery += "WHERE Z46_N1 != '' "
elseif nNivel = 2
   cQuery += "WHERE Z46_N2 = '"+cCod+"' "
elseif nNivel = 3
   cQuery += "WHERE Z46_N3 = '"+cCod+"' "
elseif nNivel = 4
   cQuery += "WHERE Z46_N4 = '"+cCod+"' "
elseif nNivel = 5
   cQuery += "WHERE Z46_N5 = '"+cCod+"' "
endif       
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "Z46X"
cARQTMP := CriaTrab( , .F. )
COPY TO ( cARQTMP )
Z46X->( DbCloseArea() )
DbUseArea( .T., , cARQTMP, "Z46X", .F., .F. )
Index On Z46_DESCRI to &cARQTMP

Return

*******************************
User Function GetCNivel(nNivel)
*******************************
local nPos := aScan( aHeader, { |x| AllTrim( x[2] ) == "UD_N"+Alltrim(Str(nNivel)) } )

return aCols[n, nPos]