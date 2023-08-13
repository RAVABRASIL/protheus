#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CondCli(cCliente, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local lValido	   := .T.
Local lRetorno	   := .T.
Private cDUCPag    := Space(30)
Private cNome      := Space(40)
Private cUCPag     := Space(3)
Private dUACPag    := CtoD(" ")
Private dUCom      := CtoD(" ")
Private cPrzM      := Space(5)
Private lCBox      := .F.



//Default cCliente := '000030'

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oSay3","lblNome","lblUCom","oSay2","lblUCPag","lblDUCPag","oSay5","lblUACPag")
SetPrvt("lblPrzM","oSay6","oSBtn1","oCBox","oGrp1")

if alltrim(upper(FunName())) $ "ESTC005/FATC019" .OR. M->C5_TIPO <> 'N'
   return .T.
Endif

If Empty(cLoja)
   cLoja:= posicione("SA1",1, xFilial("SA1")+ cCliente, "A1_LOJA" )
   cXDD:= IIF (posicione("SA1",1, xFilial("SA1")+ cCliente, "A1_BLQXDD" ) = 'S', "NAO","SIM")
    //cLoja:='01'    
Else
   cXDD:= IIF (posicione("SA1",1, xFilial("SA1")+ cCliente + cLoja, "A1_BLQXDD" ) = 'S', "NAO","SIM")
Endif

//chamado 002203 - Flavia Rocha
//lValido := U_RegraPAGO(cCliente)       //VERFICA SE EXISTE NFS NÃO PAGAS HÁ MAIS DE 120 DIAS 
//desabilitado por solicitação de Eurivan em 11/08/11 - (suspender temporariamente a validação)
if !lValido
      SA1->(DBSETORDER(1))
      SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
      MsgInfo("O Cliente: " + SA1->A1_COD +  ' - ' + SA1->A1_NREDUZ + " Possui Pendências Financeiras.", "Inclusão NÃO PERMITIDA" )
	  lRetorno := .F.      

else

	DbSelectArea("SA1")
	DbSetORder(1)
	SA1->(DbSeek(xFilial("SA1")+cCliente + cLoja )) 
	
	
	
	if SA1->A1_DTCOND + 90 >= dDatabase .or. Empty(SA1->A1_DTCOND) .AND. ( GetPrzMed(GetCondUC(cCliente)) > 30 )
		
		cNome    := Alltrim(SA1->A1_NOME)
		dUACPag  := SA1->A1_DTCOND
		dUCom    := SA1->A1_ULTCOM
		cUCPag   := GetCondUC(cCliente)
		
		DbSelectArea("SE4")
		DbSetORder(1)
		SE4->(DbSeek(xFilial("SE4")+cUCPag))
		cDUCPag  := Alltrim(SE4->E4_COND)
		
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Definicao do Dialog e todos os seus componentes.                        ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		oDlg1      := MSDialog():New( 218,229,354,884,"Voce deverá diminuir um Dia da cond. pagamento",,,.F.,,,,,,.T.,,,.T. )
		
		oSay3      := TSay():New( 008,007,{||"Cliente:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,023,008)
		lblNome    := TSay():New( 008,048,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,275,008)
		lblNome:cCaption := cNome
		
		oSay1      := TSay():New( 020,007,{||"Última Compra:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,039,008)
		lblUCom    := TSay():New( 020,050,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,037,008)
		lblUCom:cCaption := DtoC(dUCom)
		
		oSay2      := TSay():New( 020,091,{||"Última Cond.Pagto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,047,008)
		lblUCPag   := TSay():New( 020,142,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,016,008)
		lblUCPag:cCaption := cUCPag
		
		oSay5      := TSay():New( 020,163,{||"Dias da Cond.Pagto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,052,008)
		lblDUCPag  := TSay():New( 020,217,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,038,008)
		lblDUCPag:cCaption := cDUCPag
		
		oSay7      := TSay():New( 033,007,{||"Última Alteração Cond. Pagto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,075,008)
		lblUACPag  := TSay():New( 033,089,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,053,008)
		lblUACPag:cCaption := DtoC(dUACPag)
		
		oSay8      := TSay():New( 033,163,{||"COMPRA XDD?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,075,008)
		lblXDD     := TSay():New( 033,210,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,053,008)
		lblXDD:cCaption := cXDD

		oSay6      := TSay():New( 020,257,{||"Prz.Medio:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,027,008)
		lblPrzM    := TSay():New( 020,287,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,033,008)
		lblPrzM:cCaption := Transform(GetPrzMed(cUCPag),"@E 999")
		
		oCBox      := TCheckBox():New( 051,007,"Atualizar Data de alteração da Condição de Pagamento ?",{|u| If(PCount()>0,lCBox:=u,lCBox)},oDlg1,152,008,,,,,CLR_HRED,CLR_WHITE,,.T.,"",, )
		oGrp1      := TGroup():New( 043,003,046,323,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBtn1     := SButton():New( 050,294,1,{||oDlg1:End()},oDlg1,,"", )
		
		oDlg1:Activate(,,,.T.)
		
	endif
Endif

Return(lRetorno)

//Retorna Condicao de Pagamento da Ultima compra do Cliente.
***********************************
static function GetCondUC(cCliente)
***********************************
local cQuery
local cRet

cQuery := "SELECT TOP 1 F2_COND FROM "+RetSqlName("SF2")+" "
cQuery += "WHERE F2_CLIENTE = '"+cCliente+"' "
cQuery += "AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY F2_EMISSAO DESC "

TCQUERY cQuery NEW ALIAS "F2X"

cRet := F2X->F2_COND

F2X->(DbCloseArea())

return cRet


//Retorna Prazo Medio da Condicao de Pagamento Informada
********************************
static function GetPrzMed(cCond)
********************************

local aI := {}
local nX
local nRet := 0

DbSelectArea("SE4")
DbSetORder(1)
SE4->(DbSeek(xFilial("SE4")+cCond))

aI := Str2Arr(Alltrim(SE4->E4_COND),",")
for nX := 1 to len(aI)
	nRet += Val(aI[nX])
next nX

nRet := nRet / Len(aI)

aI := {}

return nRet