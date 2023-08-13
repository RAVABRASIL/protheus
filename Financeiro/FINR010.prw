#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR010 ³ Autor :TEC1 - Designer       ³ Data :16/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Função para mostrar os titulos que devem ir para o SERASA  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINR010()

	Processa({|| fProc() })

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  : WFINR010 ³ Autor :TEC1 - Designer       ³ Data :16/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Função para mostrar os titulos que devem ir para o SERASA  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WFINR010()

RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFINR010" Tables "SE2"
sleep( 5000 )
conOut( "Inicio do Programa WFINR010 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
U_wfListaTit()
conOut( "Fim do Programa WFINR010 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
Reset environment

Return


Static Function fProc()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local nOpc 		:= GD_INSERT+GD_DELETE+GD_UPDATE

LOCAL cQry			:= ''
Local nTotalPC	:= 0
Local nVlFret   := 0
local nPercFrt	:= 0
Local cFornece	:= ""
Local dPrevisao
local aCampos		:= {}
Local aUltimoP
Local cCondica := ""
Local cUsuario := ""
Local aUsu     := ""
Local cUsu     := ""
Local cC       := ""
Local cCC      := ""
Local cTPFrete := ""
//fUltPreco()
Local nVerba	:= 0
Local nGasto	:= 0
Local nSaldoV	:= 0
Local nResult	:= 0
Local nEmPCAbe:= 0
Local cContaAdm	:= ""
Local cContaPro	:= ""
Local cCodProd	:= ""

Private cMark   := GetMark()
Private aCoBrw3 := {}
Private aHoBrw3 := {}
Private noBrw3  := 0
Private cSolic := ""

lInverte := .F.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGet1","oGet2","oGet3","oGet4","oGet5")
SetPrvt("oGrp2","oBrw1","oBrw2","oGrp3","oBrw3","oSBtn1")
Private LF := CHR(13) + CHR(10)

cQry	:= " SELECT E1_CLIENTE, E1_LOJA, A1_NOME, A1_CLASSE, A1_LC FROM " + RETSQLNAME("SE1") + " E1 " + LF
cQry    += " INNER JOIN " + RETSQLNAME("SA1") + " A1 " + LF
cQry    += " ON E1_CLIENTE = A1_COD "
cQry    += " AND E1_LOJA = A1_LOJA "
cQry    += " WHERE E1_SALDO > 0 "
cQry    += " AND E1.D_E_L_E_T_ <> '*' "
cQry    += " AND E1_TIPO NOT IN ('NCC','RA') "
cQry    += " AND E1_STATUS = 'A' "
cQry    += " AND E1_VENCTO <= '" + DTOS(DDATABASE - 31) + "' "
cQry    += " AND E1_PREFIXO <> '' "
cQry    += " AND E1_XSERASA <> 'S' "
cQry    += " AND A1_SATIV1 <> '000009' "
cQry    += " GROUP BY E1_CLIENTE, E1_LOJA, A1_NOME, A1_CLASSE, A1_LC "
cQry    += " ORDER BY A1_NOME "

MemoWrite("C:\TEMP\COMC009.SQL", cQry )
If Select("XIT") > 0
	XIT->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "XIT"

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 006,195,493,1060,"Clientes - TÍTULOS P/ SERASA",,,.F.,,,,,,.T.,,,.F. )

oGrp2      := TGroup():New( 000,002,129,428,"Clientes com débitos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

//AADD(aCampos,{"OK" 			,"","Mark"  		,""  	})					
AADD(aCampos,{"E1_CLIENTE" 	,"","Cliente"		,""  	})					
AADD(aCampos,{"E1_LOJA"		,"","Loja" 		,""		})					
AADD(aCampos,{"A1_NOME"		,"","Nome" 		,""		})					
AADD(aCampos,{"A1_CLASSE"	,"","Classe"		,""		})					
AADD(aCampos,{"A1_LC"		,"","Lim. Cred."	,PesqPict('SA1','A1_LC')		})
AADD(aCampos,{"QUANT"		,"","Num. Tit."	,"@E 999,999"		})
AADD(aCampos,{"TOTAL"		,"","Débito"		,PesqPict('SA1','A1_LC')		})

oTbl1()
Dbselectarea("TMP1")

XIT->(dbgotop())

While XIT->(!EOF())

	reclock("TMP1", .T.)
	TMP1->E1_CLIENTE    	:= XIT->E1_CLIENTE
	TMP1->E1_LOJA 		:= XIT->E1_LOJA
	TMP1->A1_NOME  		:= XIT->A1_NOME
	TMP1->A1_CLASSE   	:= XIT->A1_CLASSE
	TMP1->A1_LC   		:= XIT->A1_LC
	TMP1->QUANT   		:= fTotTit(XIT->E1_CLIENTE, XIT->E1_LOJA)[1]
	TMP1->TOTAL   		:= fTotTit(XIT->E1_CLIENTE, XIT->E1_LOJA)[2]
	msunlock()
	XIT->(dbSkip())
EndDo

TMP1->(dbgotop())

oBrw1      := MsSelect():New( "TMP1","","",aCampos,@lInverte,@cMark,{010,004,124,425},,, oGrp2 ) 
			   	//MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,aCores)
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
//oBrw1:oBrowse:bChange := {||fListaTit(TMP1->E1_CLIENTE, TMP1->E1_LOJA) }
oBrw1:oBrowse:bLDblClick := {|| Processa({ || U_fListaTit(TMP1->E1_CLIENTE, TMP1->E1_LOJA) }) }

oGrp3      := TGroup():New( 130,002,231,428,"Títulos a serem enviados - SERASA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oTbl2()
DbSelectArea("TMP2")

oBrw2      := MsSelect():New( "TMP2","MARCA","",{{"E1_FILIAL "	,"","Filial"		,""},;
												 		{"E1_PREFIXO ","","Prefixo"		,""},;
												 		{"E1_NUM "		,"","Número"		,""},;
												 		{"E1_PARCELA"	,"","Parcela"		,""},;
												 		{"E1_TIPO"		,"","Tipo"			,""},;
												 		{"E1_EMISSAO"	,"","Emissão"		,""},;
												 		{"E1_VENCTO"	,"","Vencimento"	,""},;
												 		{"E1_SALDO"	,"","Saldo"		,PesqPict('SE1','E1_SALDO')},;
												 		{"A1_NOME"		,"","Cliente"		,""};
												 		},.F.,,{140,004,224,425},,, oDlg1 ) 

oSBtn1     := SButton():New( 232,345,1,{|| Processa({|| fEnvTit(.F.) }) },oDlg1,,"", )
oSBtn2     := SButton():New( 232,405,2,{|| oDlg1:end()},oDlg1,,"", )


oDlg1:Activate(,,,.T.)
TMP1->(DBCloseArea())
TMP2->(DBCloseArea())
//Ferase(coTbl2)

Return

**************************
Static Function oTbl2()
**************************

Local aFds := {}
Local cQryx := ""

Aadd( aFds , {"E1_FILIAL" 	,"C",002,000} )
Aadd( aFds , {"E1_CLIENTE"	,"C",006,000} )
Aadd( aFds , {"E1_LOJA" 		,"C",002,000} )
Aadd( aFds , {"E1_PREFIXO"	,"C",003,000} )
Aadd( aFds , {"E1_NUM" 		,"C",009,000} )
Aadd( aFds , {"E1_PARCELA" 	,"C",002,000} )
Aadd( aFds , {"E1_TIPO"		,"C",003,000} )
Aadd( aFds , {"E1_EMISSAO" 	,"D",008,000} )
Aadd( aFds , {"E1_VENCTO" 	,"D",008,000} )
Aadd( aFds , {"E1_VALOR" 	,"N",014,004} )
Aadd( aFds , {"E1_SALDO" 	,"N",014,004} )
Aadd( aFds , {"A1_NOME"		,"C",040,000} )
Aadd( aFds , {"A1_END"		,"C",050,000} )
Aadd( aFds , {"A1_BAIRRO"	,"C",020,000} )
Aadd( aFds , {"A1_MUN"		,"C",020,000} )
Aadd( aFds , {"A1_EST"		,"C",002,000} )
Aadd( aFds , {"A1_CEP"		,"C",008,000} )
Aadd( aFds , {"A1_TEL"		,"C",011,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
dbCreateIndex(coTbl2,'E1_CLIENTE+E1_LOJA', {|| E1_CLIENTE+E1_LOJA })

Return 

**************************
Static Function oTbl3()
**************************

Local aFds := {}
Local cQryx := ""

AADD( aFds , {"OK" 			,"C",002,000} )		
Aadd( aFds , {"E1_FILIAL " 	,"C",002,000} )
Aadd( aFds , {"E1_CLIENTE "	,"C",006,000} )
Aadd( aFds , {"E1_LOJA " 	,"C",002,000} )
Aadd( aFds , {"E1_PREFIXO "	,"C",003,000} )
Aadd( aFds , {"E1_NUM" 		,"C",009,000} )
Aadd( aFds , {"E1_PARCELA" 	,"C",002,000} )
Aadd( aFds , {"E1_TIPO"		,"C",003,000} )
Aadd( aFds , {"E1_EMISSAO" 	,"D",008,000} )
Aadd( aFds , {"E1_VENCTO" 	,"D",008,000} )
Aadd( aFds , {"E1_VALOR" 	,"N",014,004} )
Aadd( aFds , {"E1_SALDO" 	,"N",014,004} )
Aadd( aFds , {"A1_NOME"		,"C",040,000} )
Aadd( aFds , {"A1_END"		,"C",050,000} )
Aadd( aFds , {"A1_BAIRRO"	,"C",020,000} )
Aadd( aFds , {"A1_MUN"		,"C",020,000} )
Aadd( aFds , {"A1_EST"		,"C",002,000} )
Aadd( aFds , {"A1_CEP"		,"C",008,000} )
Aadd( aFds , {"A1_TEL"		,"C",011,000} )


coTbl3 := CriaTrab( aFds, .T. )
Use (coTbl3) Alias TMP3 New Exclusive

Return 

**************************
Static Function oTbl1()
**************************

Local aCampos := {}

AADD(aCampos,{"OK" 			,"C",002,000})		
AADD(aCampos,{"E1_CLIENTE" 	,"C",008,000})					
AADD(aCampos,{"E1_LOJA"		,"C",002,000})					
AADD(aCampos,{"A1_NOME"		,"C",050,000})					
AADD(aCampos,{"A1_CLASSE"	,"C",002,000})					
AADD(aCampos,{"A1_LC"		,"N",014,002})
Aadd(aCampos,{"QUANT" 		,"N",003,000})
Aadd(aCampos,{"TOTAL" 		,"N",014,004})

coTbl1 := CriaTrab( aCampos, .T. )
Use (coTbl1) Alias TMP1 New Exclusive

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fListaTit ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para marcar os titulos que irao para o SERASA.         º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fListaTit(cCli, cLoja)

Local cMarca  	:= GetMark()				//Flag para marcacao
Local aCampos 	:= {}								//Array para criacao de arq. temporario
Local aCmp 		:= {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     	:= .F.							//Retorno da janela de dialogo
Local cQryx 		:= ""

Local cArquivo	:= "TMP3"
lInvert 			:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do arquivo de trabalho sobre o qual atuara³
//³o MarkBrowse.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TMP3") > 0
	TMP3->( __DbZap() )
Else
	oTbl3()
EndIf

cQryx	:= " SELECT E1_CLIENTE, E1_LOJA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO, "
cQryx	+= " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_TEL FROM " + RETSQLNAME("SE1") + " E1 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQryx	+= " ON E1_CLIENTE = A1_COD "
cQryx	+= " AND E1_LOJA = A1_LOJA "
cQryx	+= " WHERE E1_SALDO > 0 "
cQryx	+= " AND E1.D_E_L_E_T_ <> '*' "
cQryx	+= " AND E1_TIPO NOT IN ('NCC','RA') "
cQryx	+= " AND E1_STATUS = 'A' "
cQryx	+= " AND E1_VENCTO <= '" + DTOS(DDATABASE - 31) + "' "
cQryx	+= " AND E1_PREFIXO <> '' "
cQryx  += " AND E1_XSERASA <> 'S' "
cQryx	+= " AND E1_CLIENTE = '" + cCli + "' "
cQryx	+= " AND E1_LOJA = '" + cLoja + "' "
cQryx	+= " ORDER BY E1_VENCTO "

If Select("TMPX") > 0
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQryx NEW ALIAS "TMPX"
TcSetField("TMPX", "E1_EMISSAO", "D")
TcSetField("TMPX", "E1_VENCTO", "D")

TMPX->(dbGoTop())

WHILE !TMPX->(EOF())
	
	RECLOCK("TMP3",.T.)
		TMP3->E1_FILIAL  	:= TMPX->E1_FILIAL
		TMP3->E1_PREFIXO 	:= TMPX->E1_PREFIXO
		TMP3->E1_CLIENTE 	:= TMPX->E1_CLIENTE
		TMP3->E1_LOJA 	:= TMPX->E1_LOJA
		TMP3->E1_NUM 		:= TMPX->E1_NUM
		TMP3->E1_PARCELA 	:= TMPX->E1_PARCELA
		TMP3->E1_TIPO 	:= TMPX->E1_TIPO
		TMP3->E1_EMISSAO   	:= TMPX->E1_EMISSAO
		TMP3->E1_VENCTO 	:= TMPX->E1_VENCTO
		TMP3->E1_VALOR   	:= TMPX->E1_VALOR
		TMP3->E1_SALDO   	:= TMPX->E1_SALDO
		TMP3->A1_NOME  	:= TMPX->A1_NOME
		TMP3->A1_END		:= TMPX->A1_END
		TMP3->A1_BAIRRO	:= TMPX->A1_BAIRRO
		TMP3->A1_MUN		:= TMPX->A1_MUN
		TMP3->A1_EST		:= TMPX->A1_EST
		TMP3->A1_CEP		:= TMPX->A1_CEP
		TMP3->A1_TEL		:= TMPX->A1_TEL
	MsUnLock()
	TMPX->(DbSKIP())

EndDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Redefine o array aCampos com a estrutura do MarkBrowse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aCampos,{"OK"  			,"",""       		,""	})					
AADD(aCampos,{"E1_FILIAL "	,"","Filial"		,""})					
AADD(aCampos,{"E1_PREFIXO "	,"","Prefixo"		,""})					
AADD(aCampos,{"E1_NUM "		,"","Número"		,""})					
AADD(aCampos,{"E1_PARCELA"	,"","Parcela"		,""})					
AADD(aCampos,{"E1_TIPO"		,"","Tipo"			,""})					
AADD(aCampos,{"E1_EMISSAO"		,"","Emissão"		,""})					
AADD(aCampos,{"E1_VENCTO"	,"","Vencimento"	,""})					
AADD(aCampos,{"E1_SALDO"		,"","Saldo"		,PesqPict('SE1','E1_VALOR')})					
AADD(aCampos,{"A1_NOME"		,"","Cliente"		,""})					

DEFINE MSDIALOG oDlg TITLE 'Títulos em aberto com mais de 19 dias de vencido' FROM 9,0 To 28,110 OF oMainWnd

oMark:=MsSelect():New(cArquivo,"OK",,aCampos,@lInvert,@cMarca,{02,1,123,436},)
oMark:oBrowse:lCanAllmark := .F.

TMP3->(dbGoTop())

DEFINE SBUTTON FROM 126,366.3 TYPE 1 ACTION (lOk := .T.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 126,404.4 TYPE 2 ACTION oDlg:End()              ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa MarkBrowse colocando verificando qual a PDCessa selecio-	³
//³nada e preenchendo a nota fiscal original, serie e item no pedido	³
//³de vendas.		                                                    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	TMP3->(dbGoTop())
	While TMP3->(!Eof()) .And. lOk
		
		If TMP3->OK == cMarca
			RECLOCK("TMP2",.T.)
				TMP2->E1_FILIAL  	:= TMP3->E1_FILIAL
				TMP2->E1_CLIENTE 	:= TMP3->E1_CLIENTE
				TMP2->E1_LOJA 	:= TMP3->E1_LOJA
				TMP2->E1_PREFIXO 	:= TMP3->E1_PREFIXO
				TMP2->E1_NUM 		:= TMP3->E1_NUM
				TMP2->E1_PARCELA 	:= TMP3->E1_PARCELA
				TMP2->E1_TIPO 	:= TMP3->E1_TIPO
				TMP2->E1_EMISSAO 	:= TMP3->E1_EMISSAO
				TMP2->E1_VENCTO 	:= TMP3->E1_VENCTO
				TMP2->E1_VALOR   	:= TMP3->E1_VALOR
				TMP2->E1_SALDO   	:= TMP3->E1_SALDO
				TMP2->A1_NOME  	:= TMP3->A1_NOME
				TMP2->A1_END		:= TMP3->A1_END
				TMP2->A1_BAIRRO	:= TMP3->A1_BAIRRO
				TMP2->A1_MUN		:= TMP3->A1_MUN
				TMP2->A1_EST		:= TMP3->A1_EST
				TMP2->A1_CEP		:= TMP3->A1_CEP
				TMP2->A1_TEL		:= TMP3->A1_TEL
			MsUnLock()
			
		EndIf

		TMP3->(DbSKIP())

	EndDo
EndIf

TMPX->(DbcloseArea())
TMP2->(dbgotop())
oBrw2:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTotTit  ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Total de titulos com mais de 31 dias devencidos.            º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTotTit(cCli, cLoja)

Local cQuery 	:= ""
Local aArea	:= getArea()
Local aRet		:= {}
Local nTotal	:= 0
Local nQuant 	:= 0

cQuery	:= " SELECT E1_CLIENTE, E1_LOJA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO, "
cQuery	+= " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_TEL FROM " + RETSQLNAME("SE1") + " E1 "
cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQuery	+= " ON E1_CLIENTE = A1_COD "
cQuery	+= " AND E1_LOJA = A1_LOJA "
cQuery	+= " WHERE E1_SALDO > 0 "
cQuery	+= " AND E1.D_E_L_E_T_ <> '*' "
cQuery	+= " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery	+= " AND E1_STATUS = 'A' "
cQuery	+= " AND E1_VENCTO <= '" + DTOS(DDATABASE - 31) + "' "
cQuery	+= " AND E1_PREFIXO <> '' "
cQuery += " AND E1_XSERASA <> 'S' "
cQuery += " AND A1_SATIV1 <> '000009' "
cQuery	+= " AND E1_CLIENTE = '" + cCli + "' "
cQuery	+= " AND E1_LOJA = '" + cLoja + "' "
cQuery	+= " ORDER BY E1_VENCTO "

cQuery := ChangeQuery(cQuery)

If Select("XPC") > 1
	XPC->(dbCloseArea())
EndIf
	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XPC",.T.,.T.)

dbSelectArea("XPC")
dbGoTop()

While XPC->(!Eof())
	
	nTotal		:= nTotal + XPC->E1_SALDO
	nQuant 	:= nQuant + 1
	
	XPC->(dbSkip())

EndDo

AADD(aRet, nQuant)
AADD(aRet, nTotal)

RestArea(aArea)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEnvTit  ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia os titulos por email para serem cadastrados no SERASA.º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*************

Static Function fEnvTit(lEnvSup)

*************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMensagem 	:= ""
Local lCabec		:= .T.
Local lRodape		:= .F.
Local nCont		:= 1
Local cCliAnt		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corpo do Programa                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title>Untitled Document</title>'
cMensagem += '<style type="text/css">'
cMensagem += '<!--'
cMensagem += '.style1 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #FFFFFF;'
cMensagem += '}'
cMensagem += '.style2 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #000000;'
cMensagem += '}'
cMensagem += '.style7 {color: #FFFFFF; font-weight: bold; font-family: Arial, Helvetica, sans-serif; }'
cMensagem += '.style8 {font-weight: bold; font-family: Arial, Helvetica, sans-serif}'
cMensagem += '.style9 {font-family: Arial, Helvetica, sans-serif}'
cMensagem += '-->'
cMensagem += '</style>'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<table border="0" cellpadding="0" width="98%">'

cMensagem += '<tr>'
cMensagem += '    <td bgcolor="#006A00" colspan="12"><p align="center"><span class="style7">LISTA DOS TÍTULOS COM 31 DIAS DE VENCIDO</span></p></td>'
cMensagem += '</tr>'

TMP2->( dbGoTop() )

While TMP2->( !EoF() )

	If cCliAnt <> TMP2->E1_CLIENTE + TMP2->E1_LOJA
	
		cCNPJ	:= Posicione("SA1",1,xFilial("SA1") + TMP2->E1_CLIENTE + TMP2->E1_LOJA, "A1_CGC")
	
		If nCont > 1
			cMensagem += '<tr>'
			cMensagem += '    <td bgcolor="#006A00" colspan="12"><p align="center"><span class="style7"></span></p></td>'
			cMensagem += '</tr>'
		EndIf
		
		cMensagem += '	<tr>'
		cMensagem += '    	<td bgcolor="#CCCCCC" colspan="12"><p align="left"><span class="style8">CNPJ: ' + cCNPJ + ' - CLIENTE: ' + TMP2->A1_NOME + '</span></p></td>'
		cMensagem += '	</tr>'
		cMensagem += '	<tr>'
		cMensagem += '  <tr>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">END.</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_END + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">BAIRRO</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_BAIRRO + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">MUNICÍPIO</span></p></td>'
		cMensagem += '    <td ><p align="left"><span class="style9">' + TMP2->A1_MUN + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">UF</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_EST + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">CEP</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_CEP + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">TEL.</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_TEL + '</span></p></td>'
		cMensagem += '  </tr>'
		cMensagem += '  </tr>'
		
		cMensagem += '	<tr>'
		cMensagem += '  <tr>'
		//cMensagem += '    <td bgcolor="#006A00" width="287"><p align="center"><span class="style7">CLIENTE</span></p></td>'
		//cMensagem += '    <td bgcolor="#006A00" width="121"><p align="center"><span class="style7">CNPJ</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">PRE.</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">TÍTULO</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">PARC.</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">TIPO</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">EMISSÃO</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="1"><p align="center"><span class="style8">VENCIMENTO</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC" colspan="2"><p align="center"><span class="style8">VALOR</span></p></td>'
		cMensagem += '  </tr>'
		
		nCont	:= nCont + 1
		
	EndIf
			

		cMensagem += '  <tr>'
		//cMensagem += '    <td width="287"><p><span class="style8">' + TMP2->A1_NOME + '</span></p></td>'
		//cMensagem += '    <td width="121"><p align="center"><span class="style8">' + cCNPJ + '</span></p></td>'
		cMensagem += '    <td width="42"><p align="center"><span class="style9">' + TMP2->E1_PREFIXO + '</span></p></td>'
		cMensagem += '    <td width="73"><p align="center"><span class="style9">' + TMP2->E1_NUM + '</span></p></td>'
		cMensagem += '    <td width="50"><p align="center"><span class="style9">' + TMP2->E1_PARCELA + '</span></p></td>'
		cMensagem += '    <td width="61"><p align="center"><span class="style9">' + TMP2->E1_TIPO + '</span></p></td>'
		cMensagem += '    <td width="106"><p align="center"><span class="style9">' + DtoC(TMP2->E1_EMISSAO) + '</span></p></td>'
		cMensagem += '    <td width="110"><p align="center"><span class="style9">' + DtoC(TMP2->E1_VENCREA) + '</span></p></td>'
		cMensagem += '    <td colspan="2"><p align="right"><span class="style9">' + Transform(TMP2->E1_SALDO,"@E 99,999,999.99") + '</span></p></td>'
		cMensagem += '  </tr>'
	//EndIf
	
	cCliAnt := TMP2->E1_CLIENTE + TMP2->E1_LOJA
	TMP2->( dbSkip() )
	
	If cCliAnt <> TMP2->E1_CLIENTE + TMP2->E1_LOJA
		cMensagem += '  </tr>'
	EndIf

endDo

cMensagem += '</table>'
cMensagem += '</body>'
cMensagem += '</html>'

If lEnvSup
	cEmail   	:= GetNewPar("MV_XFINR1S","regina@ravaembalagens.com.br") 
Else
	cEmail   	:= GetNewPar("MV_XFINR10","silvana@ravaembalagens.com.br") 
EndIf
cCopia   	:= GetNewPar("MV_XFINR10","silvana@ravaembalagens.com.br") 
cAssunto 	:= "Lista dos Títulos a serem cadastrados no SERASA"
cAnexo		:= ""

//U_fNewSendMail(cEmail, cAssunto, cMensagem, '', cCopia)

lRet	:= U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )
			
If lRet
	msgAlert("Email enviado com sucesso!")
Else
	msgAlert("Falha no envio do email, por favor, tente novamente.")
EndIf

TMP2->( dbGoTop() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³wfListaTit ºAutor  ³  Gustavo Costa      º Data ³ 26/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia os titulos que irao para o SERASA por email.          º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function wfListaTit()

Local cMarca  	:= GetMark()				//Flag para marcacao
Local aCampos 	:= {}								//Array para criacao de arq. temporario
Local aCmp 		:= {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     	:= .F.							//Retorno da janela de dialogo
Local cQryx 		:= ""

Local cArquivo	:= "TMP3"
lInvert 			:= .F.

cQryx	:= " SELECT E1_CLIENTE, E1_LOJA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO, "
cQryx	+= " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_TEL, E1_VENCREA FROM " + RETSQLNAME("SE1") + " E1 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQryx	+= " ON E1_CLIENTE = A1_COD "
cQryx	+= " AND E1_LOJA = A1_LOJA "
cQryx	+= " WHERE E1_SALDO > 0 "
cQryx	+= " AND E1.D_E_L_E_T_ <> '*' "
cQryx	+= " AND E1_TIPO NOT IN ('NCC','RA') "
cQryx	+= " AND E1_STATUS = 'A' "
cQryx	+= " AND E1_VENCREA = '" + DTOS(DDATABASE - 31) + "' "
cQryx	+= " AND E1_PREFIXO <> '' "
cQryx  += " AND E1_XSERASA <> 'S' "
cQryx  += " AND E1_EMIS1 > '2013'"
cQryx  += " AND A1_SATIV1 <> '000009' "
cQryx	+= " ORDER BY E1_VENCREA "

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf

TCQUERY cQryx NEW ALIAS "TMP2"
TcSetField("TMP2", "E1_EMISSAO", "D")
TcSetField("TMP2", "E1_VENCTO", "D")
TcSetField("TMP2", "E1_VENCREA", "D")

TMP2->(dbGoTop())

fEnvTit(.T.)

TMP2->(DbcloseArea())

Return
