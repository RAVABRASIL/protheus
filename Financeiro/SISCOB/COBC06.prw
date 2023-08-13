#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Sele็ใo de Tํtulos em atraso para prorroga็ใo e altera็ใo  บฑฑ
ฑฑบ          ณ da natureza                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC06(cMv_par01,cMv_par02)

SetPrvt("aStru,ni,cMARCA,mCob")

aStru := SE1->(dbStruct())

******** VARIAVEIS USADAS **********

cMARCA    := GetMark()
lINVERTE  := .F.
aCPOBRW   := {}
lFLAG     := .F.
lNew      := .F.
nVlPrinc  := 0
nTottitulo:= 0
nJurosSel := 0
nVltotal  := 0
nTotMarc  := 0
cPeriodo  := cMv_par01
cTipo     := cMv_par02
Private   cMemo := Space(80)
Private   Cont := 1

cPerg     := "COBC06"

ValidPerg()

Pergunte(cPerg,.t.)

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := LeTit() }, OemToAnsi("Aguarde"), OemToAnsi("Lendo Tํtulos..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLGProrrogar Title OemToAnsi( "Tํtulos - Selecionando Titulos" )

Dbselectarea("SEL")

oBRW                     := MsSelect():New( "SEL", "MARCA", "", aCPOBRW, @lInverte, @cMarca, { 000, 002, 185, 393 } )// era (030,002,240,393)
oBRW:oBrowse:lhasMark    := .T.
oBRW:oBrowse:lCanAllmark := .T.
oBRW:oBROWSE:bChange     := { || ExibeMemo() }
oBRW:oBrowse:bAllMark    := { || MarcaTudo() }
oBRW:bMark               := { || Marca() }
@ 195,010 Say "Observa็ใo: " //  Nome para memo
@ 205,010 GET cMemo Size 330,45 MEMO ObJect oMemo
@ 255,150 Button OemToAnsi("_Confirma") Size 40,12 Action Prorroga() Object oCONFIRMA //  a linha era 255
@ 255,210 Button OemToAnsi("_Sair")     Size 40,12 Action oDlgProrrogar:End() Object oSAIRAc // a linha era 255

SetKey(123,{|| InfoCli(SEL->CODCLI,SEL->LOJA) } ) // Seta a tecla F12 para acionamento dos parametros

Activate Dialog oDLGProrrogar Centered Valid SairAc()

Return

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ LeTit    บAutor  ณMicrosiga           บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que cria arquivo de trabalho                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeTit()

cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, "
cQuery += "E1_NATUREZ, E1_VENCREA, E1_VALOR, E1_SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" "
cQuery += "WHERE E1_VENCTO BETWEEN '"+dTos(mv_par01)+"' And '"+dTos(mv_par02)+"' "
//cQuery += "AND E1_VENCTO > '"+DTOS(dDatabase - 40)+"' "
cQuery += "AND E1_SALDO > 0 "
cQuery += "AND E1_NATUREZ IN ('10102','10103') " //mudar para naturezas usadas pela Rava
cQuery += "AND E1_SALDO = E1_VALOR "
cQuery += "AND E1_PORTADO = ''"
cQuery += "AND E1_TIPO IN ('NF','CH') "
//cQuery += "AND E1_CLIENTE <> '999999' " //Mudar regra (comentei)
//cQuery += "AND E1_CLIENTE <> '000001' " //Mudar regra (comentei)
cQuery += "AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY E1_VENCTO, E1_CLIENTE"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias SE1A
TCQUERY cQUERY Alias SE1A New
TCSetField("SE1A", "E1_VENCREA","D",8,0)
TCSetField("SE1A", "E1_VALOR","N",14,2)
TCSetField("SE1A", "E1_SALDO","N",14,2)

aCAMPOS := { { "MARCA"  , "C", 02, 0 }, ;
{ "PREFIXO"    , "C", 03, 0 }, ;
{ "TITULO"     , "C", 6 , 0 }, ;
{ "PARCELA"    , "C", 01, 0 }, ;
{ "TIPO"       , "C", 03, 0 }, ;
{ "CODCLI"     , "C", 06, 0 }, ;
{ "LOJA"       , "C", 02, 0 }, ;
{ "CLIENTE"    , "C", 40, 0 }, ;
{ "NATUREZA"   , "C", 05, 0 }, ;
{ "VENCTO"     , "D",  8, 0 }, ;
{ "VLRPRIN"    , "N", 14, 2 }, ;
{ "SALDO"      , "N", 14, 2 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "SEL", .F., .F. )

dbselectarea("SE1A")
dbgotop()

nTotTitulo := 0
While !Eof()
	Dbselectarea("SE1A")
	Reclock("SEL",.T.)
	nTotTitulo ++
	
	Replace PREFIXO     With SE1A->E1_PREFIXO
	Replace TITULO      With SE1A->E1_NUM
	Replace PARCELA     With SE1A->E1_PARCELA
	Replace TIPO        With SE1A->E1_TIPO
	Replace CODCLI      With SE1A->E1_CLIENTE
	Replace LOJA        With SE1A->E1_LOJA
	Replace CLIENTE     With SE1A->E1_NOMCLI
	Replace NATUREZA    With SE1A->E1_NATUREZ
	Replace VENCTO      With SE1A->E1_VENCREA
	Replace VLRPRIN     With SE1A->E1_VALOR
	Replace SALDO       With SE1A->E1_SALDO
	
	msunlock()
	Dbselectarea("SE1A")
	dbskip()
	
End

SEL->( DbGotop() )

aCPOBRW  :=  { { "MARCA"    ,, OemToAnsi( ""  ) }, ;
{ "PREFIXO"     ,,   OemToAnsi( "Prefixo"     ) }, ;
{ "TITULO"      ,,   OemToAnsi( "Tํtulo"      ) }, ;
{ "PARCELA"     ,,   OemToAnsi( "Parcela"     ) }, ;
{ "CODCLI"      ,,   OemToAnsi( "C๓d. Cliente") }, ;
{ "CLIENTE"     ,,   OemToAnsi( "Cliente"     ) }, ;
{ "VLRPRIN"     ,,   OemToAnsi( "Principal"   ), "@E 99,999.99" }, ;
{ "SALDO"       ,,   OemToAnsi( "Saldo"       ), "@E 99,999.99" }, ;
{ "VENCTO"      ,,   OemToAnsi( "Vencimento"  ) }, ;
{ "LOJA"        ,,   OemToAnsi( "Loja"        ) }, ;
{ "NATUREZA"    ,,   OemToAnsi( "Natureza"    ) }, ;
{ "TIPO"        ,,   OemToAnsi( "Tipo"        ) } }

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณExibeMemo    บAutor  ณMicrosiga        บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para exibir o campo ZZ6->ZZ6_MEMO no campo memo da  บฑฑ
ฑฑบ          ณ janela                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExibeMemo()

Dbselectarea("ZZ6")
Dbsetorder(1)

If Dbseek(xfilial()+SEL->CODCLI+SEL->LOJA)
	
	cMemo    := ZZ6->ZZ6_MEMO //CriaVar("ZZ6->ZZ6_MEMO")
	
	ObjectMethod(oMemo,"Refresh()")
Endif

Dbselectarea("SA1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ MarcaTudo  บAutor ณMicrosiga         บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para alterar todos os itens do grid, mudando        บฑฑ
ฑฑบ          ณ de marcado para desmarcado e vice-versa                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarcaTudo()

Local nREG := SEL->( Recno() )

DBSELECTAREA("SEL")
SEL->( DbGotop() )
While ! Eof()
	IF SEL->MARCA == cMARCA
		SEL->MARCA := "  "
	Else
		SEL->MARCA := cMARCA
	Endif
	SEL->( DbSkip() )
Enddo

SEL->( dbGoto( nREG ) )

oBRW:oBrowse:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ Marca    บAutor  ณMicrosiga           บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para marcar e desmarcara itens individuais no grid  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Marca()
If SEL->MARCA == cMARCA
	SEL->MARCA := cMARCA
Else
	SEL->MARCA := "  "
End

oBrw:oBrowse:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ SairAc   บAutor  ณMicrosiga           บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para fechar a janela do COBC06(oDLGProrrogar)       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SairAc

if Select("SE1A") <> 0
   SE1A->(dbCloseArea())
endif

SEL->(dbCloseArea())

//oDLGProrrogar:End()

//Close( oDLGProrrogar )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ Prorroga   บAutor  ณMicrosiga         บ Data ณ  07/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que confirma a altera็ใo dos tํtulos, prorrogando o บฑฑ
ฑฑบ          ณ vencimento e mudando a natureza                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Prorroga()

dbSelectArea("SEL")
dbGoTop()

cEmail := "PRORROGAวรO E ALTERAวรO DE NATUREZA DE TอTULOS <P>"
cEmail += "Natureza alterada para 10101 <P>"
cEmail += "Vencimento alterado para "+DTOC(dDataBase + 15)+" <P>"
cEmail += "Efetuado dia "+DTOC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))+" <P>"
cEmail += "TอTULOS: <P>"

While !EOF()
	IF SEL->MARCA == cMARCA

		//Posiciona no SE1 para altera็ใo dos tํtulos marcados
		DbSelectArea("SE1")
		Dbsetorder(2)
		If DbSeek(xFilial()+SEL->CODCLI+SEL->LOJA+SEL->PREFIXO+SEL->TITULO+SEL->PARCELA+SEL->TIPO)
			
			//Posicionar no ZZ6
			DbSelectArea("ZZ6")
			DbSetOrder(1)
			DbSeek(xFilial()+SEL->CODCLI+SEL->LOJA)
			
			//Atualiza memoria da cobranca
			mCob := Trim(ZZ6->ZZ6_MEMO)+Chr(13)+chr(10) //Aplica um enter se ja tiver informacao
			mCob := Trim(mCob)+DTOC(dDatabase)+" (  "+Time()+ " ) - "+Trim(Subst(cUsuario,7,15))+" -> Prorroga็ใo Automแtica"
			mCob := Trim(mCob)+Chr(13)+CHR(10)
			mCob := Trim(mCob)+"Titulo: "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO+" Valor: "+Alltrim(Str(SE1->E1_VALOR))
			mCob := Trim(mCob)+Chr(13)+CHR(10)
			mCob := Trim(mCob)+" - Vencimento prorrogado do dia "+DTOC(SE1->E1_VENCREA)+" para o dia "+DTOC(Datavalida(dDataBase + 15))
			mCob := Trim(mCob)+Chr(13)+CHR(10)
			mCob := Trim(mCob)+" - Natureza alterada de "+Trim(SE1->E1_NATUREZ)+" para 10101"

			Reclock("ZZ6",.F.)
			Replace ZZ6_MEMO With mCob
			msunlock()

			//adiciona a string para o email
			cEmail += SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO+"  -  "
			cEmail += "Cliente: "+SE1->E1_CLIENTE+ "  -  "
			cEmail += "Vencimento Original: "+DTOC(SE1->E1_VENCTO)+"  -  "
			cEmail += "Natureza Original: "+SE1->E1_NATUREZ+"  -  "
			cEmail += "Valor: "+Alltrim(Str(SE1->E1_VALOR))+" <P>"
			
			dbSelectArea("SE1")
			
			//Atualiza Titulo
			Reclock("SE1",.F.)
			Replace E1_VENCTO  With dDataBase + 15
			Replace E1_VENCREA With Datavalida(dDataBase + 15)
			Replace E1_NATUREZ With '10101' //Mudar natureza
			msunlock()
			
		Else
			MsgBox("Verifique dados informados","Titulo NAO encontrado - "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO,"INFO")
		Endif 

		DbSelectArea("SEL")
	EndIf 

	DbSkip() // passa para o pr๓ximo item no "SEL"
EndDo 

//ENVIAR E-MAIL
CONNECT SMTP SERVER AllTRIM(GETMV("MV_RELSERV")) ACCOUNT AllTRIM(GETMV("MV_RELACNT")) PASSWORD AllTRIM(GETMV("MV_RELPSW"))

SEND MAIL FROM "Setor de Cobranca <financeiro@ravaembalagens.com.br>" TO 	"Destinatario <email@dominio>" ;
SUBJECT "PRORROGA็ใO E ALTERA็ใO DE NATUREZA DE TอTULOS" ;
BODY cEmail

DISCONNECT SMTP SERVER

MsgBox("Tํtulos Prorrogados com Sucesso","Prorroga็ใo","INFO")

SairAc()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  13/11/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial" ,"","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final"   ,"","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
