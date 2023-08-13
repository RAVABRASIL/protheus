#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*-------------------------------------------------------------------------------------*/
//Programa: TMKC032.prw
//Autoria : Flávia Rocha
//Data    : 21/11/2012
//Objetivo: Permitir o cancelamento de baixas NF (cancela o registro de data real chegada
//          da NF no cliente.
//USO     : SAC
/*-------------------------------------------------------------------------------------*/

*************************
User Function TMKC032()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cNomeUser     := ""
Local aUsua			:= {}
Local cUsua			:= ""
Local aSup			:= {}
Local cSup			:= ""
Local aCampos		:= {}
Local LF      	:= CHR(13)+CHR(10)



Local aCores		:= {	{ '!Empty(F2_REALCHG)' , 'BR_VERMELHO'  },;	// NF baixada
							{ 'Empty(F2_REALCHG)'  , 'BR_VERDE' }}     //NF em aberto

						

Private cCadastro	:= "Cancela Baixa NF"
//Private bFiltraBrw	:= {|| Nil}	
							

Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar"   ,	"U_BXVisu"  	,0,2},;  	// Visualizar
							{"CancelaBX"     ,	"U_CancBX()"	,0,4},;	    // Responde com uma previsão de Dt. para Ação
							{"Legenda"   ,	"U_BXLeg()"	,0,5}}	    // Legenda							
						
//U_VisualNF(TMPFR->DOC,TMPFR->SERIE,TMPFR->CLIENTE,TMPFR->LOJA,TMPFR->TIPO)}
Private cCodResp	:= ""
Private cMailResp	:= ""
Private cMailSup	:= ""		//email do superior do responsável pela ocorrência 
Private cNomeSup	:= ""

cCodResp := __CUSERID

PswOrder(1)
If PswSeek( cCodResp, .T. )
   	aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   	//cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   	cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   	cMailResp := Alltrim(aUsua[1][14])     // e-mail do usuário
	cSup   := aUsua[1][11]
	///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   	PswOrder(1)
   	If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif

Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro, utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSetOrder(1)

mBrowse( 6, 1,22,75, "SF2",,,,,,aCores)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSetOrder(1)
	
Return(Nil)




******************************************************************************************************
User Function CancBX()
******************************************************************************************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
Local cNFISCAL     := SF2->F2_DOC
Local cSERINF      := SF2->F2_SERIE


Private cCodcli    := SF2->F2_CLIENTE
Private cLojcli    := SF2->F2_LOJA
Private cCliente   := Space(30)
Private cEmiss     := Dtoc(SF2->F2_EMISSAO)
Private cPrevChg   := Dtoc(SF2->F2_PREVCHG)
Private cRealChg   := Dtoc(SF2->F2_REALCHG)
Private cNF        := SF2->F2_DOC + '/' + SF2->F2_SERIE
Private nOpc       := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oGet1","oSay2","oGet2","oSay3","oGet3","oSay4","oGet4","oSay5","oGet5","oSBtn1")
SetPrvt("oSay6", "oGrp1")

If Empty(SF2->F2_REALCHG)
	MsgAlert("Esta NF não foi Baixada, por isto, NÃO será Possível Cancelar Baixa!")
	Return(Nil)
Endif

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCodcli + cLojcli ))
cCliente := SA1->A1_NOME

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,391,831,"CANCELA BAIXA NF",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 004,006,100,274,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 008,020,{||"NOTA FISCAL"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
oGet1      := TGet():New( 008,072,,oDlg1,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNF",,)
oGet1:bSetGet := {|u| If(PCount()>0,cNF:=u,cNF)}

oSay2      := TSay():New( 010,148,{||"Emissao:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 010,197,,oDlg1,060,008,'@D',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cEmiss",,)
oGet2:bSetGet := {|u| If(PCount()>0,cEmiss:=u,cEmiss)}

oSay3      := TSay():New( 028,020,{||"CLIENTE:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 026,072,,oDlg1,185,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCliente",,)
oGet3:bSetGet := {|u| If(PCount()>0,cCliente:=u,cCliente)}

oSay4      := TSay():New( 056,020,{||"Prev. Chegada:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
oGet4      := TGet():New( 055,072,,oDlg1,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPrevChg",,)
oGet4:bSetGet := {|u| If(PCount()>0,cPrevChg:=u,cPrevChg)}

oSay5      := TSay():New( 056,148,{||"Chegada Real:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oGet5      := TGet():New( 054,197,,oDlg1,060,008,'@D',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cRealChg",,)
oGet5:bSetGet := {|u| If(PCount()>0,cRealChg:=u,cRealChg)}

oSBtn1     := SButton():New( 112,148,1,,oDlg1,,"", ) //ok
oSBtn1:bAction := {||(nOpc := 1 , oDlg1:End() )}

oSBtn2     := SButton():New( 112,208,2,,oDlg1,,"", ) //cancela
oSBtn2:bAction := {||( nOpc := 0 , oDlg1:End() ) }

oSay6      := TSay():New( 084,020,{||"AO CLICAR NO BOTÃO 'OK'  a Data da Chegada Real será apagada e a Ligação Retornará p/ em Aberto."},oDlg1,,,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,248,013)

oDlg1:Activate(,,,.T.)

If nOpc = 1
     If MsgYesNo("Deseja Realmente Cancelar a Baixa da NF: " + cNFISCAL + ' / ' + cSERINF + " ? ")
     	MsAguarde( { || fCancela(cNFISCAL, cSERINF) }, "Aguarde. . .", "Cancelando a Baixa da NF ..." )  
     Endif
Endif

Return

//////visualiza
******************************************************************************************************
User Function BXVisu()
******************************************************************************************************

Local cNota    := SF2->F2_DOC
Local cSerie := SF2->F2_SERIE
Local cTipoNF:= SF2->F2_TIPO
Local cCli   := SF2->F2_CLIENTE
Local cLoj   := SF2->F2_LOJA

U_VisualNF(cNota , cSerie , cCli , cLoj , cTipoNF )

Return(Nil)   




******************************************************************************************************
User Function BXLeg()
******************************************************************************************************


BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"NF Baixada"} ,;
									{"BR_VERDE" ,	"NF em Aberto"} } )

Return .T.

                                 
*************************************************
Static Function fCancela( cNFISCAL, cSERINF ) 
*************************************************

Local cQuery := ""
Local cLista := ""
Local cU6codigo:= ""
Local cUCcodigo := ""
Local cMsg      := "" 
Local eEmail    := ""
Local subj		:= ""


//retira Dt Real Chegada da NF
SF2->(DbSetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNFISCAL + cSERINF ))
	RecLock("SF2", .F. )
	SF2->F2_REALCHG := CTOD("  /  /    ")
	SF2->F2_OBS     := ""
	SF2->(MsUnlock())
	
	///altera SU6
	cLista := ""
	cU6codigo:= ""
	cQuery := " SELECT TOP 1 U6_FILIAL,U6_LISTA,U6_DATA,U6_CODIGO,U6_NFISCAL,U6_CODLIG,U6_REALCHG,U6_STATUS " + CHR(13) + CHR(10)
	cQuery += "  FROM " + RetSqlName("SU6") + " SU6 "  + CHR(13) + CHR(10)
	cQuery += " WHERE "  + CHR(13) + CHR(10)
	cQuery += " U6_FILIAL = '" + Alltrim(xFilial("SF2")) + "'  "  + CHR(13) + CHR(10)
	cQuery += " AND U6_NFISCAL = '" + Alltrim(cNFISCAL) + "' AND U6_SERINF = '" + Alltrim(cSERINF) + "' "  + CHR(13) + CHR(10)
	cQuery += " AND U6_TIPO = '5' AND U6_LIGPROB <> 'S' "  + CHR(13) + CHR(10)   //NÃO PODE SER LIGAÇÃO-PROBLEMA
	cQuery += " AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
	cQuery += " Order by U6_DATA DESC "  + CHR(13) + CHR(10)
	If Select("TEMP1") > 0		
		DbSelectArea("TEMP1")
		DbCloseArea()			
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP1"
	TEMP1->(DbGoTop())
	If !TEMP1->(EOF())
		While !TEMP1->(Eof())
			cLista := TEMP1->U6_LISTA 
			cU6codigo:= TEMP1->U6_CODIGO
			TEMP1->(DBSKIP())
		Enddo
	Endif
	SU6->(Dbsetorder(1))
	If SU6->(Dbseek(xFilial("SU6") + cLista + cU6codigo ))
		RecLock("SU6", .F. )
		SU6->U6_STATUS := '1'   //volta a ligação para status = '1' -> em aberto
		SU6->U6_REALCHG:= CTOD("  /  /    ")     //retira a data real chegada do SU6
		SU6->(MsUnlock())
	Endif
	
	//cabeçalho da ligação - retorna SU4 para em aberto
	SU4->(Dbsetorder(1))
	If SU4->(Dbseek(xFilial("SU4") + cLista ))
		RecLock("SU4", .F. )
		SU4->U4_STATUS := '1'   //volta a ligação para status = '1' -> em aberto	
		SU4->(MsUnlock())
	Endif
	
	//altera SUC - cabeçalho do atendimento  
	cUCcodigo := ""	
	cQuery := " SELECT UC_CODIGO,UC_STATUS,UC_PENDENT,UC_NFISCAL,UC_REALCHG,* " + CHR(13) + CHR(10)
	cQuery += " FROM " + RetSqlName("SUC") + " SUC "  + CHR(13) + CHR(10)
	cQuery += " WHERE "
	cQuery += " UC_FILIAL = '" + Alltrim(xFilial("SF2")) + "' "  + CHR(13) + CHR(10)
	cQuery += " AND UC_NFISCAL = '" + Alltrim(cNFISCAL) + "' "  + CHR(13) + CHR(10)
	cQuery += " AND UC_OBSPRB <> 'S' "  + CHR(13) + CHR(10)  //NÃO PODE SER LIGAÇÃO-PROBLEMA
	cQuery += " AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
	If Select("TEMP1") > 0		
		DbSelectArea("TEMP1")
		DbCloseArea()			
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP1"
	TEMP1->(DbGoTop())
	If !TEMP1->(EOF())
		While !TEMP1->(Eof())
			cUCcodigo := TEMP1->UC_CODIGO 		
			TEMP1->(DBSKIP())
		Enddo
	Endif
	
	//cabeçalho do atendimento - retorna SUC para em aberto
	SUC->(Dbsetorder(1))
	If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))
		RecLock("SUC", .F. )
		SUC->UC_STATUS := '2'   //volta o atendimento para status = '2' -> em aberto	
		SUC->UC_REALCHG:= CtoD("  /  /    ")
		SUC->(MsUnlock())
		
		SUD->(DbsetOrder(1))
		If SUD->(Dbseek(xFilial("SUD") + cUCcodigo ))
			RecLock("SUD", .F.)
			SUD->UD_STATUS = ''
			SUD->(MsUnlock())
		Endif
	Endif
	MsgInfo("Processo Finalizado com Sucesso...BAIXA NF CANCELADA, OK")
	
	cMsg   := "SAC - Baixa Cancelada - NF: " + cNFISCAL + "/" + cSERINF + " - Filial: " + xFilial("SF2") + CHR(13) + CHR(10)
	cMsg   += "NF: " + cNFISCAL + " / " + cSERINF + CHR(13) + CHR(10)
	cMsg   += "Data: " + Dtoc(Date()) + CHR(13) + CHR(10)
	cMsg   += "Hora: " + Time() + CHR(13) + CHR(10)
	cMsg   += "User: " + Substr(cUsuario,7,15) + CHR(13) + CHR(10)
	eEmail := "flavia.rocha@ravaembalagens.com.br"
	subj   := cMsg
	//U_SendFatr11(eEmail, "", subj, cMsg, "" )
	MemoWrite("\TEMP\BX_CANCEL_NF_"+Alltrim(cNFISCAL)+ ".TXT" , cMsg)
	
	
Endif

Return