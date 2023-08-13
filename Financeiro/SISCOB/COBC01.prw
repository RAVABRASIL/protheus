#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Tela para a cobranca e a pre-cobranca                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ºAlterações: chamado 002260 - Solicitado por Ruben, incluir a rotina de º±±
±±º            impressão do Danfe                                         º±±
±±º            Por: Flávia Rocha                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



************************
User Function COBC01()  
************************

LOCAL cFiltro := ""
LOCAL aCores  := {{ 'ZZ8->ZZ8_STATUS=="1"' , 'BR_BRANCO'  },;    	// Consulta
                  { 'ZZ8->ZZ8_STATUS=="2"' , 'BR_PRETO' },;  		// Ligação Negativa
                  { 'ZZ8->ZZ8_STATUS=="3"' , 'BR_VERDE' },;   		// Ligação Positiva
                  { 'ZZ8->ZZ8_STATUS=="4"' , 'BR_AZUL' },;   		// Email
                  { 'ZZ8->ZZ8_STATUS==" "' , 'BR_VERMELHO' }}    	// Sem Interação
                                
Private cCadastro := ""
Private aRotina   := {} 

cCadastro := "Cobranca"

             
aRotina := { { "Imp.Danfe"     	,'SPEDNFE'		,0,2 },;
             { "Cart.Cobranca" 	,'U_COBC015()',0,6 },;
             { "Legenda"  		,'U_fLegCob()',0,6 },;
             { "Transf. Fila"	,'U_fTransFila()',0,6 },;
             { "Atendimento"   	,'U_COBC111()',0,4 } }

//             { "Fila/Contato"  	,'U_COBC013()',0,3 },;

dbSelectArea("ZZ8")
dbSetOrder(1)


If __cUserId <> '000000'
	
	cFiltro := "ZZ8_COBRAD='" + __cUserId + "' "

	If Time() > '12:00'
	
		cFiltro += " AND ZZ8_DATAF='" + DtoS(dDataBase) + "' "
	
	Else
	
		cFiltro += " AND ZZ8_DATAF='" + DtoS(dDataBase-1) + "' "
	
	EndIf 

EndIf

mBrowse( ,,,,"ZZ8",,,,,,aCores,,,,,,,,cFiltro)

//mBrowse(6,1,22,75,"SA1")

Return(nil)

******************************************************************************************************
User function COBC111()
******************************************************************************************************

//ZZ8->(dbskip(-1))

Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(xFilial("SA1") + ZZ8->ZZ8_CLIENT + ZZ8->ZZ8_LOJA)

U_COBC011(,,,.t.)   //Chama a tela de cobranca, apos posicionamento no cadastro de clientes

Return

******************************************************************************************************
User Function fLegCob()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_BRANCO" ,	"Consulta"},;
										{"BR_PRETO",	"Ligação Negativa"},;
										{"BR_VERDE",	"Ligação Positiva"},;
										{"BR_AZUL",	"Email"},;
										{"BR_VERMELHO",	"Sem Interação"} 	 } )

Return .T.


******************************************************************************************************
User function fTransFila()
******************************************************************************************************

Local lContinua	:= .F.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oPanel1","oSay1","oGet1","oSay2","oGet2","oSay3","oGet3","oBtn1","oBtn2","_cDe","_cPara","_dDia")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
_cDe		:= Space(6)
_cPara		:= Space(6)
_dDia		:= dDataBase

oFont1     := TFont():New( "Arial Black",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 126,254,261,596,"Transferencia de Fila",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,169,066,.T.,.F. )

oSay1      := TSay():New( 008,004,{||"Fila do dia:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet1      := TGet():New( 006,048,,oPanel1,053,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_dDia",,)
oGet1:bSetGet := {|u| If(PCount()>0,_dDia:=u,_dDia)}
oGet1:bValid := {|| NaoVazio() .and. _dDia >= dDataBase-1 }

oSay2      := TSay():New( 032,004,{||"De:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 044,004,,oPanel1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"USR","_cDe",,)
oGet2:bSetGet := {|u| If(PCount()>0,_cDe:=u,_cDe)}
oGet2:bValid := {|| NaoVazio() }

oSay3      := TSay():New( 032,068,{||"Para:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 044,068,,oPanel1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"USR","_cPara",,)
oGet3:bSetGet := {|u| If(PCount()>0,_cPara:=u,_cPara)}
oGet3:bValid := {|| NaoVazio() }

oBtn1      := TButton():New( 022,131,"Transfere",oPanel1,,037,020,,,,.T.,,"",,,,.F. )
oBtn1:bLClicked := {|| lContinua := .T. , oDlg1:End()}
oBtn1:bValid := {|| If(Empty(_cDe),.F.,.T.) .and. If(Empty(_cPara),.F.,.T.) }

oBtn2      := TButton():New( 044,131,"Cancela",oPanel1,,037,020,,,,.T.,,"",,,,.F. )
oBtn2:bLClicked := {|| lContinua := .F. , oDlg1:End() }

oDlg1:Activate(,,,.T.)


If lContinua

	If ! U_SENHA('31')
		Alert( 'Usuario sem permissao!' )
		Return
	Else
		ZZ8->(dbGoTop())
		ZZ8->(dbsetOrder(2))
		ZZ8->(dbSeek(xFilial("ZZ8") + DtoS(_dDia) ))
		
		While ZZ8->(!EOF()) .And. _dDia == ZZ8->ZZ8_DATAF
		
			If ZZ8->ZZ8_COBRAD == _cDe
				Reclock("ZZ8",.F.)
				Replace ZZ8_COBRAD With _cPara
				msunlock()
			EndIf
			
			ZZ8->(dbSkip())
		EndDo
		MsgAlert("Transferência concluída!")
	Endif
	
EndIf

Return