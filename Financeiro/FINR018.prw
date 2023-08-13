#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR018 ³ Autor :Gustavo Costa         ³ Data :22/07/2014   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Função para mostrar os titulos que serão cobrados pelos    ³±±
±±³ 			 Advogados.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINR018()

	Processa({|| U_fTitADV() })

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR018 ³ Autor :Gustavo Costa         ³ Data :22/07/2014   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Função para mostrar os titulos que serão cobrados pelos    ³±±
±±³ 			 Advogados.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function WFINR018()

RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFINR018" Tables "SE2"
sleep( 5000 )
conOut( "Inicio do Programa WFINR018 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
U_wfListaTit()
conOut( "Fim do Programa WFINR018 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
Reset environment

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
Aadd( aFds , {"E1_PARCELA" 	,"C",001,000} )
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
Aadd( aFds , {"A1_CONTATO"	,"C",008,000} )
Aadd( aFds , {"A1_SATIV1"	,"C",011,000} )

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
Aadd( aFds , {"E1_PARCELA" 	,"C",001,000} )
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
Aadd( aFds , {"A1_CONTATO"	,"C",015,000} )
Aadd( aFds , {"A1_SATIV1"	,"C",006,000} )


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

**************************
Static Function oTbl4()
**************************

Local aFds := {}
Local cQryx := ""

Aadd( aFds , {"E1_FILIAL" 	,"C",002,000} )
Aadd( aFds , {"E1_CLIENTE"	,"C",006,000} )
Aadd( aFds , {"E1_LOJA" 		,"C",002,000} )
Aadd( aFds , {"E1_PREFIXO"	,"C",003,000} )
Aadd( aFds , {"E1_NUM" 		,"C",009,000} )
Aadd( aFds , {"E1_PARCELA" 	,"C",001,000} )
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
Aadd( aFds , {"A1_CONTATO"	,"C",015,000} )
Aadd( aFds , {"A1_SATIV1"	,"C",006,000} )

coTbl4 := CriaTrab( aFds, .T. )
Use (coTbl4) Alias TMP4 New Exclusive
dbCreateIndex(coTbl4,'E1_CLIENTE+E1_LOJA', {|| E1_CLIENTE+E1_LOJA })

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fListaTit ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para marcar os titulos que irao para cobrança por      º±±
±±º          ³Advogados												           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fTitADV(cCli, cLoja)

Local cMarca  	:= GetMark()				//Flag para marcacao
Local aCampos 	:= {}								//Array para criacao de arq. temporario
Local aCmp 		:= {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     	:= .F.							//Retorno da janela de dialogo
Local cQryx 		:= ""
Local nValor		:= 40
Local cArquivo	:= "TMP3"
lInvert 			:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do arquivo de trabalho sobre o qual atuara³
//³o MarkBrowse.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oTbl2()
oTbl4()

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Qtd dias de Vencido?",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Digite o Valor:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nValor:=u,nValor)},oDlg99,060,010,'@R 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nValor",,)
oSBtn1     := SButton():New( 008,080,1,{|| oDlg99:End() },oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

If Select("TMP3") > 0
	TMP3->( __DbZap() )
Else
	oTbl3()
EndIf

cQryx	:= " SELECT E1_CLIENTE, E1_LOJA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO, "
cQryx	+= " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_CONTATO, A1_SATIV1, E1_VENCREA FROM " + RETSQLNAME("SE1") + " E1 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQryx	+= " ON E1_CLIENTE = A1_COD "
cQryx	+= " AND E1_LOJA = A1_LOJA "
cQryx	+= " WHERE E1_SALDO > 0 "
cQryx	+= " AND E1.D_E_L_E_T_ <> '*' "
cQryx	+= " AND E1_TIPO NOT IN ('NCC','RA') "
cQryx	+= " AND E1_STATUS = 'A' "
cQryx	+= " AND E1_VENCREA = '" + DTOS(DDATABASE - nValor) + "' "
cQryx	+= " AND E1_PREFIXO <> '' "
cQryx  += " AND E1_XSERASA <> 'S' "
cQryx	+= " AND E1_PORTADO <> 'ADV' "
//cQryx	+= " AND E1_LOJA = '" + cLoja + "' "
cQryx	+= " ORDER BY E1_CLIENTE, E1_LOJA "

If Select("TMPX") > 0
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQryx NEW ALIAS "TMPX"
TcSetField("TMPX", "E1_EMISSAO", "D")
TcSetField("TMPX", "E1_VENCTO", "D")
TcSetField("TMPX", "E1_VENCREA", "D")

TMPX->(dbGoTop())

If TMPX->(EOF())
	MsgAlert("Hoje não há títulos!")
	return
EndIf

WHILE !TMPX->(EOF())
	
	RECLOCK("TMP3",.T.)
		TMP3->E1_FILIAL  	:= TMPX->E1_FILIAL
		TMP3->E1_PREFIXO 	:= TMPX->E1_PREFIXO
		TMP3->E1_CLIENTE 	:= TMPX->E1_CLIENTE
		TMP3->E1_LOJA 	:= TMPX->E1_LOJA
		TMP3->E1_NUM 		:= TMPX->E1_NUM
		TMP3->E1_PARCELA 	:= TMPX->E1_PARCELA
		TMP3->E1_TIPO 	:= TMPX->E1_TIPO
		TMP3->E1_EMISSAO 	:= TMPX->E1_EMISSAO
		TMP3->E1_VENCTO 	:= TMPX->E1_VENCREA
		TMP3->E1_VALOR   	:= TMPX->E1_VALOR
		TMP3->E1_SALDO   	:= TMPX->E1_SALDO
		TMP3->A1_NOME  	:= TMPX->A1_NOME
		TMP3->A1_END		:= TMPX->A1_END
		TMP3->A1_BAIRRO	:= TMPX->A1_BAIRRO
		TMP3->A1_MUN		:= TMPX->A1_MUN
		TMP3->A1_EST		:= TMPX->A1_EST
		TMP3->A1_CEP		:= TMPX->A1_CEP
		TMP3->A1_TEL		:= TMPX->A1_TEL
		TMP3->A1_CONTATO    := TMPX->A1_CONTATO
		TMP3->A1_SATIV1		:= TMPX->A1_SATIV1
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
AADD(aCampos,{"E1_EMISSAO"	,"","Emissão"		,""})					
AADD(aCampos,{"E1_VENCTO"	,"","Vencimento"	,""})					
AADD(aCampos,{"E1_VALOR"	,"","Valor"		,PesqPict('SE1','E1_VALOR')})					
AADD(aCampos,{"E1_SALDO"	,"","Saldo"		,PesqPict('SE1','E1_VALOR')})					
AADD(aCampos,{"A1_NOME"		,"","Cliente"		,""})					
AADD(aCampos,{"A1_CONTATO"	,"","Contato"		,""})					
AADD(aCampos,{"A1_SATIV1"	,"","Tipo Cliente"		,""})					

DEFINE MSDIALOG oDlg TITLE 'Títulos em aberto com 40 dias de vencido' FROM 9,0 To 28,110 OF oMainWnd

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
		
		If TMP3->OK <> cMarca
			RECLOCK("TMP2",.T.)
				TMP2->E1_FILIAL  	:= TMP3->E1_FILIAL
				TMP2->E1_CLIENTE 	:= TMP3->E1_CLIENTE
				TMP2->E1_LOJA 	:= TMP3->E1_LOJA
				TMP2->E1_PREFIXO 	:= TMP3->E1_PREFIXO
				TMP2->E1_NUM 		:= TMP3->E1_NUM
				TMP2->E1_PARCELA 	:= TMP3->E1_PARCELA
				TMP2->E1_TIPO 	:= TMP3->E1_TIPO
				TMP2->E1_EMISSAO 	:= TMP3->E1_EMISSAO
				TMP2->E1_VENCTO 	:= TMP3->E1_VENCREA
				TMP2->E1_VALOR   	:= TMP3->E1_VALOR
				TMP2->E1_SALDO   	:= TMP3->E1_SALDO
				TMP2->A1_NOME  	:= TMP3->A1_NOME
				TMP2->A1_END		:= TMP3->A1_END
				TMP2->A1_BAIRRO	:= TMP3->A1_BAIRRO
				TMP2->A1_MUN		:= TMP3->A1_MUN
				TMP2->A1_EST		:= TMP3->A1_EST
				TMP2->A1_CEP		:= TMP3->A1_CEP
				TMP2->A1_TEL		:= TMP3->A1_TEL
				TMP2->A1_CONTATO    := TMP3->A1_CONTATO
				TMP2->A1_SATIV1		:= TMP3->A1_SATIV1
			MsUnLock()
			
		EndIf

		TMP3->(DbSKIP())

	EndDo

	TMP3->(dbGoTop())
	While TMP3->(!Eof()) .And. lOk
		
		//Troca o banco.
		If TMP3->OK == cMarca

			RECLOCK("TMP4",.T.)
				TMP4->E1_FILIAL  	:= TMP3->E1_FILIAL
				TMP4->E1_CLIENTE 	:= TMP3->E1_CLIENTE
				TMP4->E1_LOJA 	:= TMP3->E1_LOJA
				TMP4->E1_PREFIXO 	:= TMP3->E1_PREFIXO
				TMP4->E1_NUM 		:= TMP3->E1_NUM
				TMP4->E1_PARCELA 	:= TMP3->E1_PARCELA
				TMP4->E1_TIPO 	:= TMP3->E1_TIPO
				TMP4->E1_EMISSAO 	:= TMP3->E1_EMISSAO
				TMP4->E1_VENCTO 	:= TMP3->E1_VENCREA
				TMP4->E1_VALOR   	:= TMP3->E1_VALOR
				TMP4->E1_SALDO   	:= TMP3->E1_SALDO
				TMP4->A1_NOME  	:= TMP3->A1_NOME
				TMP4->A1_END		:= TMP3->A1_END
				TMP4->A1_BAIRRO	:= TMP3->A1_BAIRRO
				TMP4->A1_MUN		:= TMP3->A1_MUN
				TMP4->A1_EST		:= TMP3->A1_EST
				TMP4->A1_CEP		:= TMP3->A1_CEP
				TMP4->A1_TEL		:= TMP3->A1_TEL
				TMP4->A1_CONTATO    := TMP3->A1_CONTATO
				TMP4->A1_SATIV1		:= TMP3->A1_SATIV1
			MsUnLock()

			dbSelectArea("SE1")
			dbSetOrder(1)
			
			If SE1->(dbSeek(xFilial("SE1") + TMP3->E1_PREFIXO + TMP3->E1_NUM + TMP3->E1_PARCELA + TMP3->E1_TIPO ))
			
				RECLOCK("SE1",.F.)
					SE1->E1_PORTADO		:= "ADV"
					SE1->E1_AGEDEP		:= "00000"
					SE1->E1_MOVIMEN		:= DDATABASE
					SE1->E1_CONTA			:= "0000000001"
					SE1->E1_SITUACA		:= "5"
				MsUnLock()
				
			EndIf

			dbSelectArea("SEA")
			dbSetOrder(1)
			
			If SEA->(dbSeek(xFilial("SEA") + Space(6) + TMP3->E1_PREFIXO + TMP3->E1_NUM + TMP3->E1_PARCELA + TMP3->E1_TIPO ))
	
				RECLOCK("SEA",.F.)
					SEA->EA_PORTADO		:= "ADV"
					SEA->EA_AGEDEP		:= "00000"
					SEA->EA_NUMCON		:= "0000000001"
					SEA->EA_SITUANT		:= SEA->EA_SITUACA
					SEA->EA_SITUACA		:= "5"
					SEA->EA_DATABOR		:= DDATABASE
				MsUnLock()
			
			Else			
			
				RECLOCK("SEA",.T.)
					SEA->EA_FILIAL		:= xFilial("SEA")
					SEA->EA_PREFIXO		:= TMP3->E1_PREFIXO
					SEA->EA_NUM			:= TMP3->E1_NUM
					SEA->EA_PARCELA		:= TMP3->E1_PARCELA
					SEA->EA_PORTADO		:= "ADV"
					SEA->EA_AGEDEP		:= "00000"
					SEA->EA_DATABOR		:= DDATABASE
					SEA->EA_TIPO			:= TMP3->E1_TIPO
					SEA->EA_CART			:= "R"
					SEA->EA_NUMCON		:= "0000000001"
					SEA->EA_SITUACA		:= "5"
					SEA->EA_SITUANT		:= "0"
					SEA->EA_FILORIG		:= xFilial("SEA")
				MsUnLock()

			EndIf
				
		EndIf
		
		dbSelectArea("TMP3")
		TMP3->(DbSKIP())

	EndDo

	TMP2->(dbgotop())
	fEnvTit(.F.)
	fEnvTitADV(.F.)
	
EndIf

TMPX->(DbcloseArea())
TMP2->(DbcloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTotTit  ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Total de titulos com 20 dias de vencidos.                   º±±
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
cQuery	+= " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_CONTATO, A1_SATIV1, E1_VENCREA FROM " + RETSQLNAME("SE1") + " E1 "
cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQuery	+= " ON E1_CLIENTE = A1_COD "
cQuery	+= " AND E1_LOJA = A1_LOJA "
cQuery	+= " WHERE E1_SALDO > 0 "
cQuery	+= " AND E1.D_E_L_E_T_ <> '*' "
cQuery	+= " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery	+= " AND E1_STATUS = 'A' "
cQuery	+= " AND E1_VENCREA = '" + DTOS(DDATABASE - 40) + "' "
cQuery	+= " AND E1_PREFIXO <> '' "
cQuery += " AND E1_XSERASA <> 'S' "
cQuery += " AND A1_SATIV1 <> '000009' "
cQuery	+= " AND E1_CLIENTE = '" + cCli + "' "
cQuery	+= " AND E1_LOJA = '" + cLoja + "' "
cQuery	+= " ORDER BY E1_VENCREA "

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
±±ºDesc.     ³Envia os titulos não selecionados por email para Marcelo.   º±±
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
Local cTipoCli		:= ""

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
cMensagem += '    <td bgcolor="#006A00" colspan="12"><p align="center"><span class="style7">LISTA DOS TÍTULOS QUE NÃO FORAM ENVIADOS PARA COBRANÇA POR ADVOGADOS</span></p></td>'
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
		If TMP2->A1_SATIV1 == '000009'
			cTipoCli	:= "Público"		
		Else
			cTipoCli	:= "Privado"		
   		EndIf
		cMensagem += '	<tr>'
		cMensagem += '    	<td bgcolor="#CCCCCC" colspan="12"><p align="left"><span class="style8">CNPJ: ' + cCNPJ + ' - CLIENTE: ' + TMP2->A1_NOME + ' - ' + cTipoCli + '</span></p></td>'
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
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">Contato.</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP2->A1_CONTATO + '</span></p></td>'
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
	cEmail   	:= GetNewPar("MV_XSERSUP","regina@ravaembalagens.com.br") 
Else
	cEmail   	:= "marcelo@ravaembalagens.com.br" 
EndIf
cCopia   	:= ""//GetNewPar("MV_XCPSERA","gustavo@ravaembalagens.com.br") 
cAssunto 	:= "Lista dos Títulos que não foram para cobrança com Advogados"
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
±±ºPrograma  ³fEnvTit  ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia os titulos não selecionados por email para Marcelo.   º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*************

Static Function fEnvTitAdv(lEnvSup)

*************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMensagem 	:= ""
Local lCabec		:= .T.
Local lRodape		:= .F.
Local nCont		:= 1
Local cCliAnt		:= ""
Local cTipoCli		:= ""

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
cMensagem += '    <td bgcolor="#006A00" colspan="12"><p align="center"><span class="style7">LISTA DOS TÍTULOS PARA COBRANÇA POR ADVOGADO</span></p></td>'
cMensagem += '</tr>'

TMP4->( dbGoTop() )

While TMP4->( !EoF() )

	If cCliAnt <> TMP4->E1_CLIENTE + TMP4->E1_LOJA
	
		cCNPJ	:= Posicione("SA1",1,xFilial("SA1") + TMP4->E1_CLIENTE + TMP4->E1_LOJA, "A1_CGC")
	
		If nCont > 1
			cMensagem += '<tr>'
			cMensagem += '    <td bgcolor="#006A00" colspan="12"><p align="center"><span class="style7"></span></p></td>'
			cMensagem += '</tr>'
		EndIf

		If TMP4->A1_SATIV1 == '000009'
			cTipoCli	:= "Público"		
		Else
			cTipoCli	:= "Privado"		
   		EndIf
		
		cMensagem += '	<tr>'
		cMensagem += '    	<td bgcolor="#CCCCCC" colspan="12"><p align="left"><span class="style8">CNPJ: ' + cCNPJ + ' - CLIENTE: ' + TMP4->A1_NOME + ' - ' + cTipoCli + '</span></p></td>'
		cMensagem += '	</tr>'
		cMensagem += '	<tr>'
		cMensagem += '  <tr>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">END.</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_END + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">BAIRRO</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_BAIRRO + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">MUNICÍPIO</span></p></td>'
		cMensagem += '    <td ><p align="left"><span class="style9">' + TMP4->A1_MUN + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">UF</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_EST + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">CEP</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_CEP + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">TEL.</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_TEL + '</span></p></td>'
		cMensagem += '    <td bgcolor="#CCCCCC"><p align="center"><span class="style8">Contato</span></p></td>'
		cMensagem += '    <td><p align="left"><span class="style9">' + TMP4->A1_CONTATO + '</span></p></td>'
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
		cMensagem += '    <td width="42"><p align="center"><span class="style9">' + TMP4->E1_PREFIXO + '</span></p></td>'
		cMensagem += '    <td width="73"><p align="center"><span class="style9">' + TMP4->E1_NUM + '</span></p></td>'
		cMensagem += '    <td width="50"><p align="center"><span class="style9">' + TMP4->E1_PARCELA + '</span></p></td>'
		cMensagem += '    <td width="61"><p align="center"><span class="style9">' + TMP4->E1_TIPO + '</span></p></td>'
		cMensagem += '    <td width="106"><p align="center"><span class="style9">' + DtoC(TMP4->E1_EMISSAO) + '</span></p></td>'
		cMensagem += '    <td width="110"><p align="center"><span class="style9">' + DtoC(TMP4->E1_VENCREA) + '</span></p></td>'
		cMensagem += '    <td colspan="2"><p align="right"><span class="style9">' + Transform(TMP4->E1_SALDO,"@E 99,999,999.99") + '</span></p></td>'
		cMensagem += '  </tr>'
	//EndIf
	
	cCliAnt := TMP4->E1_CLIENTE + TMP4->E1_LOJA
	TMP4->( dbSkip() )
	
	If cCliAnt <> TMP4->E1_CLIENTE + TMP4->E1_LOJA
		cMensagem += '  </tr>'
	EndIf

endDo

cMensagem += '</table>'
cMensagem += '</body>'
cMensagem += '</html>'

If lEnvSup
	cEmail   	:= GetNewPar("MV_XSERSUP","regina@ravaembalagens.com.br") 
Else
	cEmail   	:= GetNewPar("MV_XADVCOB","gustavo@ravaembalagens.com.br") 
EndIf
cCopia   	:= GetNewPar("MV_XCPADV","regina@ravaembalagens.com.br") 
cAssunto 	:= "RAVA Embalagens - Títulos para cobrança - " + DtoC(dDataBase)
cAnexo		:= ""

//U_fNewSendMail(cEmail, cAssunto, cMensagem, '', cCopia)

lRet	:= U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )
			
If lRet
	msgAlert("Email enviado com sucesso!")
Else
	msgAlert("Falha no envio do email para os advogados, por favor, tente novamente.")
EndIf

dbCloseArea("TMP4")

Return

