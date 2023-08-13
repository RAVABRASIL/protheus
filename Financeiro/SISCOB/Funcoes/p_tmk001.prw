#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"

*************

User Function TMK001()   // Todos os atendimentos

*************

MontPrin( "", 1 )
Return NIL



*************
User Function TMK001A()   // Atendimentos no setor telemarketing
*************

MontPrin( "ZZO_LOCAL $ '999'", 2 )
Return NIL



*************
User Function TMK001B()    // Atendimentos no setor de materiais
*************

MontPrin( "ZZO_LOCAL == '003'", 3 )
Return NIL

*************
User Function TMK001C()    // Atendimentos do cliente
*************

MontPrin( "ZZO_CLIENT == '" + SA1->A1_COD + "' .and. ZZO_LOJCLI == '" + SA1->A1_LOJA + "'", 4 )
Return NIL



*************
User Function TMK001D()   // Atendimentos protocolados
*************

MontPrin( "ZZO_LOCAL $ '   '", 2 )
Return NIL



************************

Static Function MontPrin( cFILTRO, nPROGRAM )

************************

SetPrvt( "oDlg1,oCODCLI,oGrp2,oSay3,oNOMECLI,oSay5,oSay9,oPEDIDO,oSay11,oNOTA,oSay13,oNOMREP,oSay16," )
SetPrvt( "oSay18,oDTATEND,oSay21,oDTRECMERC,oSay27,oCONTATO,oSay29,oOPERADOR,oNOMOPER,oHISTOR,oSay34," )
SetPrvt( "oNOMTRANSP,oPOSCLI,oINCLUI,oGrp42,oSay43,oVLPED,oSay46,oSay48,oSay54,oRESP,oSay56,oDTSOLUC," )
SetPrvt( "oSay58,oSOLUCAO,oSay60,oCOMISSAO,oDTSAIMERC,oALTERA,oEXCLUI,oQUESTION,oITPARECER,oVALORES," )
SetPrvt( "oVLCALC,oVLNEG,oSay70,oPERC,oConfirmar,oSair,oTIPO,oLOJCLI,oSay68,oNUMERO,oATDPAREC,oCOMENT," )
SetPrvt( "oSay72,oLOCAL,oDESCLOC" )

SetPrvt( "oDlg2,oSay1,oGrp2,oPRODUTO,oDESCPDT,oSay5,oOCORRENCIA,oSay7,oQUANTP,oSay10,oQUANTA,oSay13," )
SetPrvt( "oVLPEDIT,oSay15,oSay17,oVLNEGIT,oSay19,oITRESP,cITRESP,oSay22,oPARECER,oSay25,oMOTIVO,oGrp27," )
SetPrvt( "oSay28,oOBS1,oOBS2,oOBS3,oOBS4,oOBS5,oPAR1,oPAR2,oPAR3,oPAR4,oPAR5,oITCONF,oITCANC,oPedido,oFRACAO,oVLCALCIT" )

SetPrvt( "oDlg3,oSay1,oSay4,oRESPT,oQUESTS,oQUESTN,oQUEST,oQUESTCONF,oQUESTCANC,nOPCAO,nOPCAOIT,nOPCAOQT," )

SetPrvt( "cCadastro,aRotina,aCampos,aESTRUT,oBRW1,oBRW2,oBRW3,lFLAG1,lFLAG2,lFLAG3,lFLAG5,lFLAG6,aTIPOITENS,aSOLUITENS," )
SetPrvt( "aOCORITENS,aPAREITENS,aMOTIITENS,nVLPEDIT,cMARCA,lINVERTE,oDLG4,cTIPO," )
SetPrvt( "cSOLUCAO,cRESP,cRESPT,dDTSAIMERC,dDTRECMERC,dDTSOLUC,dDTATEND,cLOCAL,cDESCLOC,oPARECER" )
SetPrvt( "nVLNEGIT,nVLPEDIT,nVLCALCIT,nVLPED,nVLCALC,nVLDEB,nVLNEG,nVLTRAN,lFRACAO,nQUANTP,cOPERADOR,cCODCLI,cLOJCLI" )
SetPrvt( "cNOMECLI,cCONTATO,cPEDIDO,cNOTA,cNOMREP,cNOMTRANSP,cCOMISSAO,cPERC,cNOMOPER,cNUMERO," )
SetPrvt( "cTRANSP,cREPRES,oTRANSP,oREPRES," )

SetPrvt( "oDlg5,oCOMENT1,oCOMENT2,oCOMENT3,oCOMENT4,oCOMENT5,oSBtn7,oSBtn8," )
SetPrvt( "cCOMENT1,cCOMENT2,cCOMENT3,cCOMENT4,cCOMENT5,cPARECE1,cPARECE2,cPARECE3,cPARECE4,cPARECE5," )

SetPrvt( "oDlg6,oPARECE1,oPARECE2,oPARECE3,oPARECE4,oPARECE5,oSBtn6,oSBtn7." )

SetPrvt( "oDlg7,oHist1,oSay2,oHist2,oSay4,oSBtn6,aHIST1,aHIST2,cOCORRENCIA,oOCORR," )

SetPrvt( "oGrp76,oGrp70,oCOM1,oCOM2,oCOM3,oCOM4,oCOM5," )

aTIPOITENS := { " " }
SX5->( DbSeek( "  ZS", .T. ) )
Do While SX5->X5_TABELA == "ZS"
	Aadd( aTIPOITENS, Alltrim( Left( SX5->X5_CHAVE, 1 ) ) + " - " + Left( SX5->X5_DESCRI, 25 ) )
	SX5->( DbSkip() )
EndDo

aSOLUITENS := { " " }
SX5->( DbSeek( "  ZJ", .T. ) )
Do While SX5->X5_TABELA == "ZJ"
	Aadd( aSOLUITENS, Alltrim( Left( SX5->X5_CHAVE, 1 ) ) + " - " + Left( SX5->X5_DESCRI, 25 ) )
	SX5->( DbSkip() )
EndDo

aPAREITENS := { " ", "1 - ACEITO", "2 - NEGADO" }
aOCORITENS := { " " }
aMOTIITENS := { " " }

DEFINE FONT oFnt_1 NAME "Arial" SIZE 10,20 BOLD
DEFINE FONT oFnt_2 NAME "Arial" SIZE 06,14 BOLD

SA1->( DbSetOrder( 1 ) )
SU7->( DbSetOrder( 1 ) )
SC5->( DbSetOrder( 1 ) )
SF2->( DbSetOrder( 1 ) )
SA3->( DbSetOrder( 1 ) )
SA4->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SQB->( DbSetOrder( 1 ) )
SD2->( DbSetOrder( 3 ) )
SC6->( DbSetOrder( 1 ) )

aESTRUT := { { "PRODUTO", "C", 010, 0 }, ;  // Campos do arquivo do MSSELECT dos produtos
{ "DESCR",   "C", 030, 0 }, ;
{ "OCORR",   "C", 030, 0 }, ;
{ "QUANTP",  "N", 006, 0 }, ;
{ "FRACIO",  "C", 001, 0 }, ;
{ "QUANTA",  "N", 006, 0 }, ;
{ "VALPED",  "N", 009, 2 }, ;
{ "VALCALC", "N", 009, 2 }, ;
{ "VALNEGA", "N", 009, 2 }, ;
{ "RESP",    "C", 020, 0 }, ;
{ "MOTIVO",  "C", 030, 0 }, ;
{ "PARECER", "C", 030, 0 }, ;
{ "OBSERV1", "C", 080, 0 }, ;
{ "OBSERV2", "C", 080, 0 }, ;
{ "OBSERV3", "C", 080, 0 }, ;
{ "OBSERV4", "C", 080, 0 }, ;
{ "OBSERV5", "C", 080, 0 }, ;
{ "PAREC1",  "C", 080, 0 }, ;
{ "PAREC2",  "C", 080, 0 }, ;
{ "PAREC3",  "C", 080, 0 }, ;
{ "PAREC4",  "C", 080, 0 }, ;
{ "PAREC5",  "C", 080, 0 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "PDT", .F., .F. )
Index On PRODUTO To &cARQTMP
Set Index To &cARQTMP

aESTRUT := { { "PERGUNTA", "C", 110, 0 }, ;
{ "RESPOSTA", "C", 040, 0 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "QST", .F., .F. )

aESTRUT := { { "TIPO",    "C", 001, 0 }, ;
{ "PRODUTO", "C", 015, 0 }, ;
{ "DESCR",   "C", 030, 0 }, ;
{ "PRECO",  "N", 009, 2 }, ;
{ "VALOR",  "N", 009, 2 }, ;
{ "QUANT",  "N", 006, 0 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "PED", .F., .F. )
Index On PRODUTO To &cARQTMP
Set Index To &cARQTMP

aCampos    := {}
cCadastro  := "Manutencao de Atendimentos(SAC receptivo)"
aROTANT    := Aclone( aROTINA )
Do Case
	Case nPROGRAM == 1 .or. nPROGRAM == 2
		aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
		{ "Visualizar",'U_TMK001_E', 0, 2 } ,;
		{ "Incluir"  ,'U_TMK001_I', 0, 3 } ,;
		{ "Alterar"  ,'U_TMK001_A', 0, 4 } ,;
		{ "Excluir"  ,'U_TMK001_E', 0, 5 } ,;
		{ "Parecer item", 'U_TMK001_R', 0, 6 } ,;
		{ "Parecer atend.", 'U_TMK001_R', 0, 7 } ,;
      { "Imprimir" , 'U_TMK001_P', 0, 8 }, ;
      { "Cancelar parecer", 'U_TMK001_C', 0, 9 } }
	Case nPROGRAM == 3
		aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
		{ "Visualizar",'U_TMK001_E', 0, 2 } ,;
		{ "Incluir"  ,'U_SEMPERM', 0, 3 } ,;
		{ "Alterar"  ,'U_SEMPERM', 0, 4 } ,;
		{ "Excluir"  ,'U_SEMPERM', 0, 5 } ,;
		{ "Parecer item", 'U_TMK001_R', 0, 6 } }
	Case nPROGRAM == 4
		aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
		{ "Visualizar",'U_TMK001_E', 0, 2 } }

EndCase

/*
MBrowse(nT,nL,nB,nR,cAlias,aFixe,cCpo,nPosI,cFun,nDefault,aColors,cTopFun,cBotFun)

Parâmetros:
nT       =    Linha Inicial;
nL       =    Coluna Inicial;
nB       =    Linha Final;
nR       =    Coluna Final;
cAlias   =    Alias do Arquivo;
aFixe    =    Array, contendo os Campos Fixos (A serem mostrados em primeiro lugar no Browse);
cCpo     =    Campo a ser tratado, quando Empty, para informações de Linhas com Cores;
Prioridade 2
nPosI    =    (Dummy);
cFun     =    Função para habilitar semáforo; Prioridade 3 na execução; Prioridade (falta alguma coisa?)
nDefault =    Número da opção do menu a ser executada quando o <Enter> for pressionado;
aColors  =    Array com os Objetos e Cores; Prioridade 1
cTopFun  =    Função para filtrar o TOP do Browse;
cBotFun  =    Função para filtrar o BOTTOM do Browse
*/

DbSelectArea( "ZZO" )
If ! Empty( cFILTRO )
	Set Filter To &( cFILTRO )
EndIf
mBrowse( 06, 01, 22, 75, "ZZO",, "( ZZO_SOLUCA <> Space( 30 ) )" )
PDT->( DbCloseArea() )
QST->( DbCloseArea() )
PED->( DbCloseArea() )
DbSelectArea( "ZZO" )
Set Filter To
aROTINA := AClone( aROTANT )
Return NIL



*************

User Function TMK001_I( cAlias, nReg, nOpc )

*************

******** VARIAVEIS USADAS **********

nOPCAO      := nOPC
nOPCAOIT    := 0
nOPCAOQT    := 0
cOPERADOR   := Space( 06 )
cNOMOPER    := Space( 30 )
cTIPO       := " "
cCODCLI     := Space( 06 )
cLOJCLI     := Space( 02 )
cNOMECLI    := Space( 40 )
cCONTATO    := Space( 30 )
cPEDIDO     := Space( 06 )
cNOTA       := Space( 06 )
cREPRES     := Space( 06 )
cTRANSP     := Space( 06 )
cNOMREP     := Space( 40 )
cNOMTRANSP  := Space( 30 )
cCOMISSAO   := Space( 20 )
dDTATEND    := dDATABASE
dDTSAIMERC  := Ctod( "  /  /  " )
dDTRECMERC  := Ctod( "  /  /  " )
nVLPED      := 0
nVLCALC     := 0
nVLNEG      := 0
cPERC       := Space( 10 )
cRESP       := Space( 20 )
dDTSOLUC    := Ctod( "  /  /  " )
cSOLUCAO    := " "
cNUMERO     := GetSx8Num( "ZZO", "ZZO_NUM" )
cLOCAL      := Space( 03 )
cDESCLOC    := Space( 30 )
cCOMENT1    := Space( 80 )
cCOMENT2    := Space( 80 )
cCOMENT3    := Space( 80 )
cCOMENT4    := Space( 80 )
cCOMENT5    := Space( 80 )
cPARECE1    := Space( 80 )
cPARECE2    := Space( 80 )
cPARECE3    := Space( 80 )
cPARECE4    := Space( 80 )
cPARECE5    := Space( 80 )
cPERGATV    := "1"

cMARCA      := GetMark()   // Usado no MSSELECT
lINVERTE    := .F.         // Usado no MSSELECT
lFLAG1      := .F.

******** JANELA DE DIALOGO PRINCIPAL **********

PDT->( __DbZap() )

QST->( __DbZap() )
SX5->( DbSeek( "  ZX" + cPERGATV + ".01  " ) ) //Left( SX5->X5_DESCSPA, 1 ) => cPERGATV
Do While SX5->X5_TABELA == "ZX" .and. Left( SX5->X5_CHAVE, 2 ) == cPERGATV + "." //Left( SX5->X5_DESCSPA, 1 ) => cPERGATV
	QST->( DbAppend() )
	QST->PERGUNTA := SX5->X5_DESCRI + SX5->X5_DESCENG
	SX5->( DbSkip() )
EndDo
QST->( DbGotop() )

U_TMK001_1()

Dbselectarea("PDT")

oBRW1 := MsSelect():New( "PDT",,, ;
{ { "PRODUTO",, OemToAnsi( "Produto" ) }, ;
{ "DESCR",,   OemToAnsi( "Descri‡ao" ) }, ;
{ "OCORR",,   OemToAnsi( "Ocorr." ) }, ;
{ "FRACIO",,  OemToAnsi( "Frac" ) }, ;
{ "QUANTA",,  OemToAnsi( "Qtd.ocorr." ), "@E 999,999" }, ;
{ "VALNEGA",, OemToAnsi( "Vl.neg.oc." ), "@E 999,999.99" }, ;
{ "VALCALC",, OemToAnsi( "Vl.calc.pdt." ), "@E 999,999.99" }, ;
{ "QUANTP",,  OemToAnsi( "Qtd.ped." ), "@E 999,999" }, ;
{ "VALPED",,  OemToAnsi( "Vl.ped." ) }, ;
{ "RESP",,    OemToAnsi( "Resp. p/ parecer" ) }, ;
{ "MOTIVO",,  OemToAnsi( "Motivo" ) }, ;
{ "PARECER",, OemToAnsi( "Parecer" ) }, ;
{ "OBSERV1",,  OemToAnsi( "Observacao" ) }, ;
{ "OBSERV2",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV3",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV4",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV5",,  OemToAnsi( "Observacao(cont.)" ) } }, ;
.F.,, { 095, 002, 207, 387 } )

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK001_A( cAlias, nReg, nOpc )

*************

******** VARIAVEIS USADAS **********

If ! Empty( ZZO->ZZO_SOLUCA )
	MsgBox( "Atendimento ja encerrado nao pode ser alterado.", "Atencao", "STOP" )
	Return .T.
EndIf

nOPCAO := nOPC
CarregaAtd()
U_TMK001_1()

Dbselectarea("PDT")

oBRW1 := MsSelect():New( "PDT",,, ;
{ { "PRODUTO",, OemToAnsi( "Produto" ) }, ;
{ "DESCR",,   OemToAnsi( "Descri‡ao" ) }, ;
{ "OCORR",,   OemToAnsi( "Ocorr." ) }, ;
{ "FRACIO",,  OemToAnsi( "Frac" ) }, ;
{ "QUANTA",,  OemToAnsi( "Qtd.ocorr." ), "@E 999,999" }, ;
{ "VALNEGA",, OemToAnsi( "Vl.neg.oc." ), "@E 999,999.99" }, ;
{ "VALCALC",, OemToAnsi( "Val.calc.pdt." ), "@E 999,999.99" }, ;
{ "QUANTP",,  OemToAnsi( "Qtd.ped." ), "@E 999,999" }, ;
{ "VALPED",,  OemToAnsi( "Val.ped." ) }, ;
{ "RESP",,    OemToAnsi( "Resp. p/ parecer" ) }, ;
{ "MOTIVO",,  OemToAnsi( "Motivo" ) }, ;
{ "PARECER",, OemToAnsi( "Parecer" ) }, ;
{ "OBSERV1",, OemToAnsi( "Observacao" ) }, ;
{ "OBSERV2",, OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV3",, OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV4",, OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV5",, OemToAnsi( "Observacao(cont.)" ) } }, ;
.F.,, { 095, 002, 207, 387 } )

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK001_E( cAlias, nReg, nOpc )

*************

If nOPC == 5 .and. ! Empty( ZZO->ZZO_SOLUCA )   // Opcao excluir
	MsgBox( "Atendimento ja encerrado nao pode ser excluido.", "Atencao", "STOP" )
	Return .T.
EndIf

******** VARIAVEIS USADAS **********

nOPCAO := nOPC
CarregaAtd()
U_TMK001_1()

Dbselectarea("PDT")

oBRW1 := MsSelect():New( "PDT",,, ;
{ { "PRODUTO",, OemToAnsi( "Produto" ) }, ;
{ "DESCR",,   OemToAnsi( "Descri‡ao" ) }, ;
{ "OCORR",,   OemToAnsi( "Ocorr." ) }, ;
{ "FRACIO",,  OemToAnsi( "Frac" ) }, ;
{ "QUANTA",,  OemToAnsi( "Qtd.ocorr." ), "@E 999,999" }, ;
{ "VALNEGA",, OemToAnsi( "Vl.neg.oc." ), "@E 999,999.99" }, ;
{ "VALCALC",, OemToAnsi( "Val.calc.pdt." ), "@E 999,999.99" }, ;
{ "QUANTP",,  OemToAnsi( "Qtd.ped." ), "@E 999,999" }, ;
{ "VALPED",,  OemToAnsi( "Val.ped." ) }, ;
{ "VALNEGA",, OemToAnsi( "Val.neg.ocorr." ), "@E 999,999.99" }, ;
{ "RESP",,    OemToAnsi( "Resp. p/ parecer" ) }, ;
{ "MOTIVO",,  OemToAnsi( "Motivo" ) }, ;
{ "PARECER",, OemToAnsi( "Parecer" ) }, ;
{ "OBSERV1",,  OemToAnsi( "Observacao" ) }, ;
{ "OBSERV2",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV3",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV4",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV5",,  OemToAnsi( "Observacao(cont.)" ) } }, ;
.F.,, { 095, 002, 207, 387 } )

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK001_P( cAlias, nReg, nOpc )

*************

Titulo     := "Formulario de atendimento"
cString    := "ZZO"
wnrel      := "TMK001"
CbTxt      := ""
cDesc1     := "O objetivo deste relat¢rio ‚ Emitir o formulario de atendimento"
cDesc2     := ""
Tamanho    := "M"
aReturn    := { "Zebrado", 1, "Estoque", 2, 2, 1, "", 1 }
nLastKey   := 0
cPerg      := "TMKX01"
nomeprog   := "TMK001"
aOrd       := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()
wnrel := "TMK001"
Pergunte( cPerg, .F. )

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,"",.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Return .T.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .T.
Endif

RptStatus({|| Imp()}, Titulo )// Substituido pelo assistente de conversao do AP5 IDE em 24/07/01 ==>  RptStatus({|| Execute(R010Imp)},Titulo)
Return NIL



***************

Static Function Imp()

***************

Local aMATX1   := {}, ;
aMATX2   := {}, ;
aMATRIZ1 := {}

*          1         2         3         4         5         6         7         8         9        10        11        12        13
*01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
*                                             F O R M U L A R I O   D E   A T E N D I M E N T O
*NUMERO: XXXXXX
*OPERADOR: XXXXXX XXXXXXXXXXXXXXXXXXXX   CLIENTE: XXXXXX-XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   DATA DO ATENDIMENTO: XX/XX/XXXX
*TIPO DO ATENDIMENTO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*PEDIDO: XXXXXX   NOTA FISCAL: XXXXXX   REPRESENTANTE: XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   SETOR: XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*SAIDA DA MERCADORIA: XX/XX/XXXX   RECEBIMENTO DA MERCADORIA: XX/XX/XXXX   TRANSPORTADORA: XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*HISTORICO DO CLIENTE: TIPOS DE ATENDIMENTO
*
*
*
*HISTORICO DO CLIENTE: OCORRENCIAS
*
*
*
*ITENS DO ATENDIMENTO:
*PRODUTO           DESCRICAO                                  OCORRENCIA                                  QUANTID   VALOR NEGOC.
*XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    999,999    999,999.99
*
*
*
*VALOR DO PEDIDO: 999,999.99   VALOR DO ATENDIMENTO: 999,999.99   COMISSAO: XX.X% 999,999.99
*
*QUESTIONARIO:
*PERGUNTA                                                                                                         RESPOSTA
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXX
*
*
*
*COMENTARIO DO CLIENTE:
*
*
*
*
*
*
*PARECER DO SETOR RESPONSAVEL:
*
*
*
*
*
*
*SOLUCAO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   RESPONSAVEL: XXXXXXXXXXXXXXXXXXXX   DATA DA SOLUCAO: XX/XX/XXXX
*
ZZO->( DbSeek( xFILIAL( "ZZO" ) + MV_PAR01, .T. ) )
Do While ! ZZO->( Eof() ) .and. ZZO->ZZO_NUM <= MV_PAR02
	aMATX1 := {}
	aMATX2 := {}
	cSQL := "SELECT ZZO_NUM,ZZO_TIPO "
	cSQL += "FROM " + RETSQLNAME( "ZZO" ) + " ZZO "
	cSQL += "WHERE ZZO_CLIENT = '" + ZZO->ZZO_CLIENT + "' AND ZZO_LOJCLI = '" + ZZO->ZZO_LOJCLI + "' AND ZZO.D_E_L_E_T_ = '' AND "
	cSQL += "ZZO_FILIAL = '" + xFILIAL( "ZZO" ) + "' "
	cSQL += "ORDER BY ZZO_TIPO"
	cQueryTXT := ChangeQuery( cSQL )
	TCQUERY cSQL ALIAS ZZOX New
	aHIST1 := {}
	aHIST2 := {}
	ZZOX->( DbGotop() )
	Do While ! ZZOX->( Eof() )
		If Empty( nPOS := Ascan( aHIST1, { |X| X[ 1 ] == ZZOX->ZZO_TIPO } ) )
			Aadd( aHIST1, { ZZOX->ZZO_TIPO, 1 } )
		Else
			aHIST1[ nPOS, 2 ] += 1
		EndIf
		ZZP->( DbSeek( xFILIAL( "ZZP" ) + ZZOX->ZZO_NUM ) )
		Do While ZZP->ZZP_NUM == ZZOX->ZZO_NUM
			If Empty( nPOS := Ascan( aHIST2, { |X| X[ 1 ] + X[ 2 ]== ZZOX->ZZO_TIPO + ZZP->ZZP_OCORR } ) )
				Aadd( aHIST2, { ZZOX->ZZO_TIPO, ZZP->ZZP_OCORR, 1 } )
			Else
				aHIST2[ nPOS, 3 ] += 1
			EndIf
			ZZP->( DbSkip() )
		EndDo
		ZZOX->( DbSkip() )
	EndDo
	ZZOX->( DbCloseArea() )
	Asort( aHIST2,,, {| X, Y | Y[ 1 ] + Y[ 2 ] > X[ 1 ] + X[ 2 ] } )
	For nPOS := 1 To Len( aHIST1 )
		aadd( aMATX1, aHIST1[ nPOS, 1 ] + "  >>>  " + Str( aHIST1[ nPOS, 2 ], 3 ) )
	Next
	For nPOS := 1 To Len( aHIST2 )
		SX5->( DbSeek( "  ZT" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
		Do While SX5->X5_TABELA == "ZT" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
			If SubStr( SX5->X5_CHAVE, 3, 1 ) == aHIST2[ nPOS, 2 ]
				aadd( aMATX2, Left( aHIST2[ nPOS, 1 ], 1 ) + "." + aHIST2[ nPOS, 2 ] + " - " + Left( SX5->X5_DESCRI, 35 ) + "  >>>  " + Str( aHIST2[ nPOS, 3 ], 3 ) )
			EndIf
			SX5->( DbSkip() )
		EndDo
	Next
	aMATRIZ1 := {}
	SX5->( DbSeek( "  ZT" + Left( ZZO->ZZO_TIPO, 1 ), .T. ) )
	Do While SX5->X5_TABELA == "ZT" .and. Left( SX5->X5_CHAVE, 1 ) == Left( ZZO->ZZO_TIPO, 1 )
		Aadd( aMATRIZ1, Alltrim( SubStr( SX5->X5_CHAVE, 3 ) ) + " - " + SX5->X5_DESCRI )
		SX5->( DbSkip() )
	EndDo
	SU7->( DbSeek( Xfilial( "SU7" ) + ZZO->ZZO_OPERAD ) )
	SA1->( DbSeek( Xfilial( "SA1" ) + ZZO->ZZO_CLIENT + ZZO->ZZO_LOJCLI ) )
	SC5->( DbSeek( Xfilial( "SC5" ) + ZZO->ZZO_PEDIDO ) )
	SC6->( DbSeek( Xfilial( "SC6" ) + ZZO->ZZO_PEDIDO ) )
	SA3->( DbSeek( Xfilial( "SA3" ) + ZZO->ZZO_VEND ) )
	SA4->( DbSeek( Xfilial( "SA4" ) + ZZO->ZZO_TRANSP ) )
	SQB->( DbSeek( Xfilial( "SQB" ) + ZZO->ZZO_LOCAL ) )
	SD2->( DbSeek( Xfilial( "SD2" ) + ZZO->ZZO_NOTA + SC5->C5_SERIE, .T. ) )
	nVLPED := 0
	If ! Empty( ZZO->ZZO_NOTA )
		Do While SD2->D2_DOC + SD2->D2_SERIE == ZZO->ZZO_NOTA + SC5->C5_SERIE
			nVLPED += ( SD2->D2_QUANT * SD2->D2_PRCVEN ) + SD2->D2_VALIPI
			SD2->( DbSkip() )
		EndDo
	Else
		Do While SC6->C6_NUM == ZZO->ZZO_PEDIDO
			nVLPED += ( SC6->C6_VALOR + SC6->C6_DESCIPI ) / SC6->C6_QTDVEN * SC6->C6_QTDENT
			SC6->( DbSkip() )
		EndDo
	EndIf
	@ PROW(), 045 PSAY "F O R M U L A R I O   D E   A T E N D I M E N T O"
	@ PROW() + 2, 000 PSAY "NUMERO: " + ZZO->ZZO_NUM
   @ PROW() + 1, 000 PSAY "OPERADOR: " + ZZO->ZZO_OPERAD + " " + Padr( SU7->U7_NREDUZ, 20 ) + "  CLIENTE: " + ZZO->ZZO_CLIENT + "-" + ZZO->ZZO_LOJCLI + " " + Padr( SA1->A1_NOME, 36 ) + "TEL: " + Transform( SA1->A1_TEL, PESQPICT( "SA1", "A1_TEL" ) ) + "  DATA: " + Dtoc( ZZO->ZZO_EMISSA )
	@ PROW() + 1, 000 PSAY "TIPO DO ATENDIMENTO: " + aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZZO->ZZO_TIPO, 1 ) } ) ]
	@ PROW() + 1, 000 PSAY "PEDIDO: " + ZZO->ZZO_PEDIDO + "   NOTA FISCAL: " + ZZO->ZZO_NOTA + "   REPRESENTANTE: " + ZZO->ZZO_VEND + " " + Padr( SA3->A3_NREDUZ, 30 ) + "   SETOR: " + ZZO->ZZO_LOCAL + " " + Padr( SQB->QB_DESCRIC, 30 )
	@ PROW() + 1, 000 PSAY "SAIDA DA MERCADORIA: " + Dtoc( ZZO->ZZO_SAIDA ) + "   RECEBIMENTO DA MERCADORIA: " + Dtoc( ZZO->ZZO_RECEB ) + "   TRANSPORTADORA: " + ZZO->ZZO_TRANSP + " " + Padr( SA4->A4_NREDUZ, 30 )
	@ PROW() + 2, 000 PSAY "HISTORICO DO CLIENTE: TIPOS DE ATENDIMENTO"
	For nPOS := 1 To Len( aMATX1 )
		@ PROW() + 1, 000 PSAY aMATX1[ nPOS ]
	Next
	@ PROW() + 2, 000 PSAY "HISTORICO DO CLIENTE: OCORRENCIAS"
	For nPOS := 1 To Len( aMATX2 )
		@ PROW() + 1, 000 PSAY aMATX2[ nPOS ]
	Next
	If RetTela( Left( ZZO->ZZO_TIPO, 1 ) ) $ "1"
		@ PROW() + 2, 000 PSAY "ITENS DO ATENDIMENTO:"
		@ PROW() + 1, 000 PSAY "PRODUTO           DESCRICAO                                  OCORRENCIA                                  QUANTID   VALOR NEGOC."
		nVLNEG := 0
		ZZP->( DbSeek( xFILIAL( "ZZP" ) + ZZO->ZZO_NUM ) )
		Do While ZZP->ZZP_NUM == ZZO->ZZO_NUM
			SB1->( DbSeek( Xfilial( "SB1" ) + ZZP->ZZP_PROD ) )
			@ PROW() + 1, 000 PSAY ZZP->ZZP_PROD
			@ PROW()    , 018 PSAY Left( SB1->B1_DESC, 40 )
			If Ascan( aMATRIZ1, { |X| Left( X, 1 ) == ZZP->ZZP_OCORR } ) > 0
				@ PROW()    , 061 PSAY Left( aMATRIZ1[ Ascan( aMATRIZ1, { |X| Left( X, 1 ) == ZZP->ZZP_OCORR } ) ], 40 )
			Endif
			@ PROW()    , 105 PSAY ZZP->ZZP_QUANTA Picture "@E 999,999"
			@ PROW()    , 116 PSAY ZZP->ZZP_VLNEGA Picture "@E 999,999.99"
			@ PROW()    , 127 PSAY RetSinal( Left( ZZO->ZZO_TIPO, 1 ) + "." + ZZP->ZZP_OCORR )
			nVLNEG += ( ZZP->ZZP_VLNEGA * If( RetSinal( Left( ZZO->ZZO_TIPO, 1 ) + "." + ZZP->ZZP_OCORR ) == "-", -1, 1 ) )
			ZZP->( DbSkip() )
		EndDo
		@ PROW() + 2, 000 PSAY If( ! Empty( ZZO->ZZO_NOTA ), "VALOR FATURADO: ", "VALOR DO PEDIDO: " ) + Trans( nVLPED, "@E 999,999.99" ) + "   VALOR DO ATENDIMENTO: " + ;
		Trans( nVLNEG, "@E 999,999.99" ) + "   COMISSAO: " + Trans( SC5->C5_COMIS1, "@E 99.99%" ) + " " + AllTrim( Trans( nVLNEG * SC5->C5_COMIS1 / 100, "@E 999,999.99" ) )
	EndIf
	@ PROW() + 2, 000 PSAY "QUESTIONARIO:"
	@ PROW() + 1, 000 PSAY "PERGUNTA                                                                                                         RESPOSTA"
	ZY0->( DbSeek( xFILIAL( "ZY0" ) + ZZO->ZZO_NUM ) )
	Do While ZY0->ZY0_NUM == ZZO->ZZO_NUM
		@ PROW() + 1, 000 PSAY ZY0->ZY0_PERG
		@ PROW()    , 113 PSAY ZY0->ZY0_RESP
		ZY0->( DbSkip() )
	EndDo
	@ PROW() + 2, 000 PSAY "COMENTARIO DO CLIENTE:"
	@ PROW() + 1, 000 PSAY ZZO->ZZO_OBS1
	@ PROW() + 1, 000 PSAY ZZO->ZZO_OBS2
	@ PROW() + 1, 000 PSAY ZZO->ZZO_OBS3
	@ PROW() + 1, 000 PSAY ZZO->ZZO_OBS4
	@ PROW() + 1, 000 PSAY ZZO->ZZO_OBS5
	@ PROW() + 2, 000 PSAY "PARECER DO SETOR RESPONSAVEL:"
	@ PROW() + 1, 000 PSAY ZZO->ZZO_PAREC1
	@ PROW() + 1, 000 PSAY ZZO->ZZO_PAREC2
	@ PROW() + 1, 000 PSAY ZZO->ZZO_PAREC3
	@ PROW() + 1, 000 PSAY ZZO->ZZO_PAREC4
	@ PROW() + 1, 000 PSAY ZZO->ZZO_PAREC5
	@ PROW() + 2, 000 PSAY "SOLUCAO: " + ZZO->ZZO_SOLUCA + "   RESPONSAVEL: " + ZZO->ZZO_RESP + "   DATA DA SOLUCAO: " + Dtoc( ZZO->ZZO_DTSOLU )
	ZZO->( DbSkip() )
	If ! ZZO->( Eof() ) .and. ZZO->ZZO_NUM <= MV_PAR02
		Eject
	EndIf
EndDo

Set Device to Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool( wnrel )
Endif
MS_FLUSH()
Return NIL



*************

User Function TMK001_R( cAlias, nReg, nOpc )

*************

nOPCAO := nOPC

If ! Empty( ZZO->ZZO_SOLUCA )
	MsgBox( "Atendimento ja encerrado.", "Atencao", "STOP" )
	Return .T.
EndIf

If nOPCAO == 6   // Parecer Item
	If RetTela( Left( ZZO->ZZO_TIPO, 1 ) ) $ "2"
		MsgBox( "Este tipo de atendimento nao contem itens", "Atencao", "STOP" )
		Return .T.
	EndIf
	aUSUARIO := U_senha2( "31" )
	If ! aUSUARIO[ 1 ]
		Return .T.
	EndIf
Endif
If nOPCAO == 7   // Parecer atendimento
	aUSUARIO := U_senha2( "35" )
	If ! aUSUARIO[ 1 ]
		Return .T.
	EndIf
EndIf

******** VARIAVEIS USADAS **********

CarregaAtd()
If nOPCAO == 7   // Parecer atendimento
	cRESP := aUSUARIO[ 2 ]
ElseIf nOPCAO == 6
	cITRESP := aUSUARIO[ 2 ]
EndIf
dDTSOLUC := dDATABASE
U_TMK001_1()

Dbselectarea("PDT")

oBRW1 := MsSelect():New( "PDT",,, ;
{ { "PRODUTO",, OemToAnsi( "Produto" ) }, ;
{ "DESCR",,   OemToAnsi( "Descri‡ao" ) }, ;
{ "OCORR",,   OemToAnsi( "Ocorr." ) }, ;
{ "FRACIO",,  OemToAnsi( "Frac" ) }, ;
{ "QUANTA",,  OemToAnsi( "Qtd.ocorr." ), "@E 999,999" }, ;
{ "VALNEGA",, OemToAnsi( "Vl.neg.oc." ), "@E 999,999.99" }, ;
{ "VALCALC",, OemToAnsi( "Val.calc.pdt." ), "@E 999,999.99" }, ;
{ "QUANTP",,  OemToAnsi( "Qtd.ped." ), "@E 999,999" }, ;
{ "VALPED",,  OemToAnsi( "Val.ped." ) }, ;
{ "RESP",,    OemToAnsi( "Resp. p/ parecer" ) }, ;
{ "MOTIVO",,  OemToAnsi( "Motivo" ) }, ;
{ "PARECER",, OemToAnsi( "Parecer" ) }, ;
{ "OBSERV1",,  OemToAnsi( "Observacao" ) }, ;
{ "OBSERV2",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV3",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV4",,  OemToAnsi( "Observacao(cont.)" ) }, ;
{ "OBSERV5",,  OemToAnsi( "Observacao(cont.)" ) } }, ;
.F.,, { 095, 002, 207, 387 } )

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL

***************
Static Function oDLG1_Inic
***************

oNUMERO:SetText( cNUMERO )
If nOPCAO <> 3  // Opcao diferente de incluir
	cTIPO    := aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZZO->ZZO_TIPO, 1 ) } ) ]
	ObjectMethod( oTIPO, "Refresh()" )
	cSOLUCAO := aSOLUITENS[ Ascan( aSOLUITENS, { |X| Left( X, 1 ) == Left( ZZO->ZZO_SOLUCA, 1 ) } ) ]
	ObjectMethod( oSOLUCAO, "Refresh()" )
	oNOMOPER:SetText( cNOMOPER )
	oNOMECLI:SetText( cNOMECLI )
	oDESCLOC:SetText( cDESCLOC )
	oDTSAIMERC:SetText( ZZO->ZZO_SAIDA )
	oNOMREP:SetText( cNOMREP )
	oNOMTRANSP:SetText( cNOMTRANSP )
	oCOMISSAO:SetText( cCOMISSAO )
	oPERC:SetText( cPERC )
	oVLPED:SetText( RetDescr( Transform( nVLPED, "@E 999,999.99" ), 20 ) )
	oVLCALC:SetText( RetDescr( Transform( nVLCALC, "@E 999,999.99" ), 20 ) )
	oVLNEG:SetText( RetDescr( Transform( nVLNEG, "@E 999,999.99" ), 20 ) )
	oTIPO:lReadOnly      := .T.
	oOPERADOR:lReadOnly  := .T.
	oCODCLI:lReadOnly    := .T.
	oLOJCLI:lReadOnly    := .T.
	oCONTATO:lReadOnly   := .T.
	oPEDIDO:lReadOnly    := .T.
	oNOTA:lReadOnly      := .T.
	oDTATEND:lReadOnly   := .T.
	oDTRECMERC:lReadOnly := .T.
	If RetTela( Left( cTIPO, 1 ) ) $ "2"
		MontCombIt()
		oOCORR:aItems          := aOCORITENS
		cOCORRENCIA            := aOCORITENS[ Ascan( aOCORITENS, { |X| Left( X, 1 ) == Left( PDT->OCORR, 1 ) } ) ]
		oBRW1:oBrowse:lVisibleControl := .F.
		oGrp76:lVisibleControl := .T.
		oOCORR:lVisibleControl := .T.
		oGrp70:lVisibleControl := .T.
		oCOM1:lVisibleControl  := .T.
		oCOM2:lVisibleControl  := .T.
		oCOM3:lVisibleControl  := .T.
		oCOM4:lVisibleControl  := .T.
		oCOM5:lVisibleControl  := .T.
		oINCLUI:lReadOnly      := .T.
		oALTERA:lReadOnly      := .T.
		oEXCLUI:lReadOnly      := .T.
		oCOMENT:lReadOnly      := .T.
		ObjectMethod( oOCORR, "Refresh()" )
		nOPCAOIT := 1
	EndIf
EndIf
If nOPCAO == 5 .or. nOPCAO == 2 .or. nOPCAO == 6 .or. nOPCAO == 7   //  Opcao Excluir/Visualizar/Parecer
	oINCLUI:lReadOnly    := .T.
	oALTERA:lReadOnly    := .T.
	oEXCLUI:lReadOnly    := .T.
	oOCORR:lReadOnly     := .T.
	oCOM1:lReadOnly      := .T.
	oCOM2:lReadOnly      := .T.
	oCOM3:lReadOnly      := .T.
	oCOM4:lReadOnly      := .T.
	oCOM5:lReadOnly      := .T.
EndIf
If nOPCAO <> 6 .and. nOPCAO <> 7 // Opcao diferente de parecer
	If nOPCAO <> 2
		oITPARECER:lReadOnly := .T.
		If RetTela( Left( cTIPO, 1 ) ) $ "1"
			oATDPAREC:lReadOnly  := .T.
		EndIf
	EndIf
	oRESP:lReadOnly      := .T.
	If RetTela( Left( cTIPO, 1 ) ) $ "1"
		OSOLUCAO:lReadOnly   := .T.
		oDTSOLUC:lReadOnly   := .T.
	EndIf
EndIf
If nOPCAO == 6 .or. nOPCAO == 7 .or. nOPCAO == 2
	oCODCLI:lReadOnly    := .T.
	oLOJCLI:lReadOnly    := .T.
	oCONTATO:lReadOnly   := .T.
	oPEDIDO:lReadOnly    := .T.
	oNOTA:lReadOnly      := .T.
	oDTATEND:lReadOnly   := .T.
	oDTRECMERC:lReadOnly := .T.
	oLOCAL:lReadOnly     := .T.
	oRESP:lReadOnly      := .T.
	oREPRES:lReadOnly    := .T.
	oTRANSP:lReadOnly    := .T.
	If nOPCAO == 6
		oATDPAREC:lReadOnly  := .T.
		OSOLUCAO:lReadOnly   := .T.
		oRESP:lReadOnly      := .T.
		oDTSOLUC:lReadOnly   := .T.
	Endif
	If RetTela( Left( ZZO->ZZO_TIPO, 1 ) ) $ "2"
		oITPARECER:lReadOnly := .T.
	EndIf
EndIf
Return .T.

***************

Static Function oDLG2_Inic

***************

MontCombIt()
oOCORRENCIA:aItems := aOCORITENS
oMOTIVO:aItems     := aMOTIITENS
oPARECER:aItems    := aPAREITENS
If nOPCAOIT == 2 .or. nOPCAOIT == 4 // Se for alteracao
	cOCORRENCIA := aOCORITENS[ Ascan( aOCORITENS, { |X| Left( X, 1 ) == Left( PDT->OCORR, 1 ) } ) ]
	ObjectMethod( oOCORRENCIA, "Refresh()" )
	cMOTIVO     := aMOTIITENS[ Ascan( aMOTIITENS, { |X| Left( X, 1 ) == Left( PDT->MOTIVO, 1 ) } ) ]
	ObjectMethod( oMOTIVO, "Refresh()" )
	cPARECER    := aPAREITENS[ Ascan( aPAREITENS, { |X| Left( X, 1 ) == Left( PDT->PARECER, 1 ) } ) ]
	ObjectMethod( oPARECER, "Refresh()" )
	oDESCPDT:SetText( cDESCPDT )
	*   nQUANTP := PDT->QUANTP
	oQUANTP:SetText( RetDescr( Transform( nQUANTP, "@E 999,999" ), 20 ) )
	oVLPEDIT:SetText( RetDescr( Transform( nVLPEDIT, "@E 999,999.99" ), 20 ) )
	oVLCALCIT:SetText( RetDescr( Transform( nVLCALCIT, "@E 999,999.99" ), 20 ) )
EndIf
If nOPCAOIT == 1 .or. nOPCAOIT == 2   // Se for alteracao/inclusao
	oITRESP:lReadOnly  := .T.
	oMOTIVO:lReadOnly  := .T.
	oPARECER:lReadOnly := .T.
   oPAR1:lReadOnly    := .T.
   oPAR2:lReadOnly    := .T.
   oPAR3:lReadOnly    := .T.
   oPAR4:lReadOnly    := .T.
   oPAR5:lReadOnly    := .T.
Else
	oPRODUTO:lReadOnly    := .T.
	oFRACAO:lReadOnly     := .T.
	oOCORRENCIA:lReadOnly := .T.
	oQUANTA:lReadOnly     := .T.
	oVLNEGIT:lReadOnly    := .T.
	// ANA MARIA LIBERAR A OBSERVACAO
	oOBS1:lReadOnly       := .T.
	oOBS2:lReadOnly       := .T.
	oOBS3:lReadOnly       := .T.
	oOBS4:lReadOnly       := .T.
	oOBS5:lReadOnly       := .T.
	oITRESP:lReadOnly     := .T.
	If nOPCAO == 7   // Parecer atendimento
		oMOTIVO:lReadOnly  := .T.
		oPARECER:lReadOnly := .T.
		oVLNEGIT:lReadOnly := .F.
      oPAR1:lReadOnly    := .T.
      oPAR2:lReadOnly    := .T.
      oPAR3:lReadOnly    := .T.
      oPAR4:lReadOnly    := .T.
      oPAR5:lReadOnly    := .T.
	EndIf
	ObjectMethod( oMOTIVO, "SetFocus()" )
EndIf
Return .T.



***************

Static Function oDLG7_Inic

***************

Local aMATX1 := {}, ;
aMATX2 := {}

cSQL := "SELECT ZZO_NUM,ZZO_TIPO "
cSQL += "FROM " + RETSQLNAME( "ZZO" ) + " ZZO "
cSQL += "WHERE ZZO_CLIENT = '" + cCODCLI + "' AND ZZO_LOJCLI = '" + cLOJCLI + "' AND ZZO.D_E_L_E_T_ = '' AND "
cSQL += "ZZO_FILIAL = '" + xFILIAL( "ZZO" ) + "' "
cSQL += "ORDER BY ZZO_TIPO"
cQueryTXT := ChangeQuery( cSQL )
TCQUERY cSQL ALIAS ZZOX New

aHIST1 := {}
aHIST2 := {}
ZZOX->( DbGotop() )
Do While ! ZZOX->( Eof() )
	If Empty( nPOS := Ascan( aHIST1, { |X| X[ 1 ] == ZZOX->ZZO_TIPO } ) )
		Aadd( aHIST1, { ZZOX->ZZO_TIPO, 1 } )
	Else
		aHIST1[ nPOS, 2 ] += 1
	EndIf
	ZZP->( DbSeek( xFILIAL( "ZZP" ) + ZZOX->ZZO_NUM ) )
	Do While ZZP->ZZP_NUM == ZZOX->ZZO_NUM
		If Empty( nPOS := Ascan( aHIST2, { |X| X[ 1 ] + X[ 2 ]== ZZOX->ZZO_TIPO + ZZP->ZZP_OCORR } ) )
			Aadd( aHIST2, { ZZOX->ZZO_TIPO, ZZP->ZZP_OCORR, 1 } )
		Else
			aHIST2[ nPOS, 3 ] += 1
		EndIf
		ZZP->( DbSkip() )
	EndDo
	ZZOX->( DbSkip() )
EndDo
ZZOX->( DbCloseArea() )

Asort( aHIST2,,, {| X, Y | Y[ 1 ] + Y[ 2 ] > X[ 1 ] + X[ 2 ] } )
For nPOS := 1 To Len( aHIST1 )
	aadd( aMATX1, aHIST1[ nPOS, 1 ] + "  >>>  " + Str( aHIST1[ nPOS, 2 ], 3 ) )
Next
oHIST1:aItems := aMATX1
For nPOS := 1 To Len( aHIST2 )
	If aHIST2[ nPOS, 1 ] == aHIST1[ 1, 1 ]
		SX5->( DbSeek( "  ZT" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
		Do While SX5->X5_TABELA == "ZT" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
			If SubStr( SX5->X5_CHAVE, 3, 1 ) == aHIST2[ nPOS, 2 ]
				aadd( aMATX2, aHIST2[ nPOS, 2 ] + " - " + Left( SX5->X5_DESCRI, 35 ) + "  >>>  " + Str( aHIST2[ nPOS, 3 ], 3 ) )
			EndIf
			SX5->( DbSkip() )
		EndDo
	Endif
Next
oHIST2:aItems := aMATX2
ObjectMethod( oHIST1, "Refresh()" )
ObjectMethod( oHIST2, "Refresh()" )
Return .T.



***************

Static Function CarregaAtd

***************

nOPCAOIT    := 0
nOPCAOQT    := 0
cOPERADOR   := ZZO->ZZO_OPERAD
SU7->( DbSeek( Xfilial( "SU7" ) + ZZO->ZZO_OPERAD ) )
cNOMOPER    := RetDescr( SU7->U7_NREDUZ, 50 )
cTIPO       := aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZZO->ZZO_TIPO, 1 ) } ) ]
cCODCLI     := ZZO->ZZO_CLIENT
cLOJCLI     := ZZO->ZZO_LOJCLI
SA1->( DbSeek( Xfilial( "SA1" ) + cCODCLI + cLOJCLI ) )
cNOMECLI    := RetDescr( SA1->A1_NOME, 60 )
cCONTATO    := ZZO->ZZO_CONTAT
cPEDIDO     := ZZO->ZZO_PEDIDO
cNOTA       := ZZO->ZZO_NOTA
SC5->( DbSeek( Xfilial( "SC5" ) + cPEDIDO ) )
cNOTA  := SC5->C5_NOTA
nVLPED := 0
SC6->( DbSeek( Xfilial( "SC6" ) + cPEDIDO ) )
Do While SC6->C6_NUM == cPEDIDO
	nVLPED += ( SC6->C6_VALOR + SC6->C6_DESCIPI ) / SC6->C6_QTDVEN * SC6->C6_QTDENT
	SC6->( DbSkip() )
EndDo
cREPRES := ZZO->ZZO_VEND
SA3->( DbSeek( Xfilial( "SA3" ) + cREPRES ) )
cNOMREP := RetDescr( SA3->A3_NREDUZ, 30 )
cTRANSP := ZZO->ZZO_TRANSP
SA4->( DbSeek( Xfilial( "SA4" ) + cTRANSP ) )
cNOMTRANSP  := RetDescr( SA4->A4_NREDUZ, 30 )
cCOMISSAO   := RetDescr( Trans( SC5->C5_COMIS1, "@E 99.99" ) + "%", 30 )
dDTSAIMERC  := ZZO->ZZO_SAIDA
dDTRECMERC  := ZZO->ZZO_RECEB
dDTATEND    := ZZO->ZZO_EMISSA
cRESP       := ZZO->ZZO_RESP
dDTSOLUC    := ZZO->ZZO_DTSOLU
cSOLUCAO    := aSOLUITENS[ Ascan( aSOLUITENS, { |X| Left( X, 1 ) == Left( ZZO->ZZO_SOLUCA, 1 ) } ) ]
cNUMERO     := ZZO->ZZO_NUM
cLOCAL      := ZZO->ZZO_LOCAL
SQB->( DbSeek( Xfilial( "SQB" ) + cLOCAL ) )
cDESCLOC    := RetDescr( AllTrim( SQB->QB_DESCRIC ) + If( ! Empty( ZZO->ZZO_DTSAID ), If ( ZZO->ZZO_LOCAL <> "999", "  " + Dtoc( ZZO->ZZO_DTSAID ), "  " + Dtoc( ZZO->ZZO_DTRETO ) ), "" ), 30 )
cCOMENT1    := ZZO->ZZO_OBS1
cCOMENT2    := ZZO->ZZO_OBS2
cCOMENT3    := ZZO->ZZO_OBS3
cCOMENT4    := ZZO->ZZO_OBS4
cCOMENT5    := ZZO->ZZO_OBS5
cPARECE1    := ZZO->ZZO_PAREC1
cPARECE2    := ZZO->ZZO_PAREC2
cPARECE3    := ZZO->ZZO_PAREC3
cPARECE4    := ZZO->ZZO_PAREC4
cPARECE5    := ZZO->ZZO_PAREC5

lFLAG1  := .F.
nVLCALC := 0
nVLNEG  := 0
MontCombIt()

PDT->( __DbZap() )
ZZP->( DbSeek( xFILIAL( "ZZP" ) + cNUMERO ) )
Do While ZZP->ZZP_NUM == cNUMERO
	PDT->( DbAppend() )
	PDT->PRODUTO := ZZP->ZZP_PROD
	SB1->( DbSeek( Xfilial( "SB1" ) + ZZP->ZZP_PROD ) )
	PDT->DESCR   := SB1->B1_DESC
	PDT->OCORR   := aOCORITENS[ Ascan( aOCORITENS, { |X| Left( X, 1 ) == ZZP->ZZP_OCORR } ) ]
	PDT->PARECER := aPAREITENS[ Ascan( aPAREITENS, { |X| Left( X, 1 ) == ZZP->ZZP_PARECE } ) ]
	PDT->MOTIVO  := aMOTIITENS[ Ascan( aMOTIITENS, { |X| Left( X, 1 ) == ZZP->ZZP_MOTIVO } ) ]
	PDT->QUANTP  := ZZP->ZZP_QUANTP
	PDT->FRACIO  := ZZP->ZZP_FRACIO
	PDT->QUANTA  := ZZP->ZZP_QUANTA
	PDT->VALPED  := ZZP->ZZP_VLPEDN
	PDT->VALCALC := ZZP->ZZP_VLNEGP
	PDT->VALNEGA := ZZP->ZZP_VLNEGA
	PDT->RESP    := ZZP->ZZP_RESP
	PDT->OBSERV1 := ZZP->ZZP_OBS1
	PDT->OBSERV2 := ZZP->ZZP_OBS2
	PDT->OBSERV3 := ZZP->ZZP_OBS3
	PDT->OBSERV4 := ZZP->ZZP_OBS4
	PDT->OBSERV5 := ZZP->ZZP_OBS5
   PDT->PAREC1  := ZZP->ZZP_PAREC1
   PDT->PAREC2  := ZZP->ZZP_PAREC2
   PDT->PAREC3  := ZZP->ZZP_PAREC3
   PDT->PAREC4  := ZZP->ZZP_PAREC4
   PDT->PAREC5  := ZZP->ZZP_PAREC5
	nVLCALC      += ( ZZP->ZZP_VLNEGP * If( RetSinal( Left( cTIPO, 1 ) + "." + ZZP->ZZP_OCORR ) == "-", -1, 1 ) )
	nVLNEG       += ( ZZP->ZZP_VLNEGA * If( RetSinal( Left( cTIPO, 1 ) + "." + ZZP->ZZP_OCORR ) == "-", -1, 1 ) )
	ZZP->( DbSkip() )
EndDo
PDT->( DbGotop() )
cPERC := RetDescr( Transform( nVLNEG / nVLPED * 100, "@E 999.99%" ), 15 )

QST->( __DbZap() )
ZY0->( DbSeek( xFILIAL( "ZY0" ) + cNUMERO ) )
Do While ZY0->ZY0_NUM == cNUMERO
	QST->( DbAppend() )
	QST->PERGUNTA := ZY0->ZY0_PERG
	QST->RESPOSTA := ZY0->ZY0_RESP
	ZY0->( DbSkip() )
EndDo
QST->( DbGotop() )
Return Nil



***************

Static Function MontCombIt

***************

Local aMATRIZ1 := { " " }, ;
aMATRIZ2 := { " " }

SX5->( DbSeek( "  ZT" + Left( cTIPO, 1 ), .T. ) )
Do While SX5->X5_TABELA == "ZT" .and. Left( SX5->X5_CHAVE, 1 ) == Left( cTIPO, 1 )
	Aadd( aMATRIZ1, Alltrim( SubStr( SX5->X5_CHAVE, 3 ) ) + " - " + SX5->X5_DESCRI )
	SX5->( DbSkip() )
EndDo
aOCORITENS := aMATRIZ1
SX5->( DbSeek( "  ZV" + Left( cTIPO, 1 ), .T. ) )
Do While SX5->X5_TABELA == "ZV" .and. Left( SX5->X5_CHAVE, 1 ) == Left( cTIPO, 1 )
	Aadd( aMATRIZ2, Alltrim( SubStr( SX5->X5_CHAVE, 3 ) ) + " - " + SX5->X5_DESCRI )
	SX5->( DbSkip() )
EndDo
aMOTIITENS := aMATRIZ2
Return NIL



***************

Static Function Question()

***************

nOPCAOQT := 1
lFLAG3   := .F.

QST->( DbGotop() )
U_TMK001_3()

Dbselectarea("QST")

oBRW2 := MsSelect():New( "QST",,, ;
{ { "RESPOSTA",, OemToAnsi( "Resposta" ) }, ;
{ "PERGUNTA",, OemToAnsi( "Pergunta" ) } }, ;
.F.,, { 003, 002, 080, 347 } )

oBRW2:oBROWSE:bChange     := { || ExibeBrw2() }
oBRW2:oBROWSE:bGotFocus   := { || ExibeBrw2() }

Activate Dialog oDLG3 Centered Valid Sair3()
Return NIL



***************

Static Function ExibeBrw2()

***************

oQUEST:SetText( QST->PERGUNTA )
cRESPT := QST->RESPOSTA
ObjectMethod( oRESPT, "Refresh()" )
Return NIL



***************

Static Function VldOperador

***************

If SU7->( DbSeek( Xfilial( "SU7" ) + cOPERADOR ) )
	If SU7->U7_TIPOATE <> "4" .and. SU7->U7_TIPOATE <> "1" .and. SU7->U7_TIPOATE <> "3"
		MsgBox( "Operador sem autorizacao.", "Atencao", "STOP" )
		Return .F.
	EndIf
	cNOMOPER := RetDescr( SU7->U7_NREDUZ, 50 )
	oNOMOPER:SetText( cNOMOPER )
Else
	oNOMOPER:SetText( Repl( "_", 50 ) )
EndIf
Return .T.



***************

Static Function Vldvend

***************

If SA3->( DbSeek( Xfilial( "SA3" ) + cREPRES ) )
	cNOMREP := RetDescr( SA3->A3_NREDUZ, 30 )
	oNOMREP:SetText( cNOMREP )
Else
	oNOMREP:SetText( Repl( "_", 30 ) )
EndIf
Return .T.



***************

Static Function VldTransp

***************

If SA4->( DbSeek( Xfilial( "SA4" ) + cTRANSP ) )
	cNOMTRANSP := RetDescr( SA4->A4_NREDUZ, 30 )
	oNOMTRANSP:SetText( cNOMTRANSP )
Else
	oNOMTRANSP:SetText( Repl( "_", 30 ) )
EndIf
Return .T.



***************

Static Function VldCliente

***************

If SA1->( DbSeek( Xfilial( "SA1" ) + cCODCLI + cLOJCLI ) )
	cNOMECLI := RetDescr( SA1->A1_NOME, 60 )
	oNOMECLI:SetText( cNOMECLI )
	cCONTATO := SA1->A1_CONTATO
	oCONTATO:SetText( cCONTATO )
Else
	oNOMECLI:SetText( Repl( "_", 60 ) )
	cCONTATO := Space( 30 )
	oCONTATO:SetText( cCONTATO )
EndIf
cNOTA := Space( 06 )
oNOTA:SetText( cNOTA )
*ObjectMethod( oNOTA, "Refresh()" )
cPEDIDO := Space( 06 )
oPEDIDO:SetText( cPEDIDO )
*ObjectMethod( oPEDIDO, "Refresh()" )
oNOMREP:SetText( Repl( "_", 50 ) )
oNOMTRANSP:SetText( Repl( "_", 40 ) )
oCOMISSAO:SetText( Repl( "_", 30 ) )
oDTSAIMERC:SetText( Repl( "_", 20 ) )
dDTATEND := dDATABASE
*oDTSAIMERC:SetText( dDTSAIMERC )
ObjectMethod( oDTATEND, "Refresh()" )
dDTRECMERC := Ctod( "  /  /  " )
*oDTRECMERC:SetText( dDTRECMERC )
ObjectMethod( oDTRECMERC, "Refresh()" )
Return .T.



***************

Static Function VldLocal

***************

If SQB->( DbSeek( Xfilial( "SQB" ) + cLOCAL ) )
	cDESCLOC := RetDescr( SQB->QB_DESCRIC, 30 )
	oDESCLOC:SetText( cDESCLOC )
Else
	oDESCLOC:SetText( Repl( "_", 40 ) )
EndIf
Return .T.



***************

Static Function CliHist

***************

If Empty( cCODCLI ) .or. Empty( cLOJCLI )
	MsgBox( "Cliente/Loja nao informado.", "Atencao", "STOP" )
	Return NIL
EndIf

U_TMK001_7()

Activate Dialog oDLG7 Centered On Init oDLG7_Inic() Valid Sair7()
Return NIL



***************

Static Function HistMov

***************

Local aMATX2 := {}

For nPOS := 1 To Len( aHIST2 )
	If aHIST2[ nPOS, 1 ] == aHIST1[ oHIST1:nAT, 1 ]
		SX5->( DbSeek( "  ZT" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
		Do While SX5->X5_TABELA == "ZT" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
			If SubStr( SX5->X5_CHAVE, 3, 1 ) == aHIST2[ nPOS, 2 ]
				aadd( aMATX2, aHIST2[ nPOS, 2 ] + " - " + Left( SX5->X5_DESCRI, 35 ) + "  >>>  " + Str( aHIST2[ nPOS, 3 ], 3 ) )
			EndIf
			SX5->( DbSkip() )
		EndDo
	Endif
Next
oHIST2:aItems := aMATX2
ObjectMethod( oHIST2, "Refresh()" )
Return .T.



***************

Static Function CliPos

***************

Local xTIPO := cTIPO

If Empty( cCODCLI ) .or. Empty( cLOJCLI )
	MsgBox( "Cliente/Loja nao informado.", "Atencao", "STOP" )
	Return NIL
EndIf

SA1->( DbSeek( Xfilial( "SA1" ) + cCODCLI + cLOJCLI ) )
U_XPosicao()
cTIPO := xTIPO
Return .T.



***************

Static Function VldPed

***************

SC5->( DbSetOrder( 1 ) )
If SC5->( DbSeek( Xfilial( "SC5" ) + cPEDIDO ) )
	If SC5->C5_CLIENTE + SC5->C5_LOJACLI <> cCODCLI + cLOJCLI
		MsgBox( "Pedido nao e desse cliente.", "Atencao", "STOP" )
		Return .T.
	EndIf
	cNOTA := SC5->C5_NOTA
	*   oNOTA:SetText( cNOTA )
	ObjectMethod( oNOTA, "Refresh()" )
	SA3->( DbSeek( Xfilial( "SA3" ) + SC5->C5_VEND1 ) )
	cREPRES := SC5->C5_VEND1
	cNOMREP := RetDescr( SA3->A3_NREDUZ, 30 )
	oNOMREP:SetText( cNOMREP )
	SA4->( DbSeek( Xfilial( "SA4" ) + SC5->C5_TRANSP ) )
	cTRANSP    := SC5->C5_TRANSP
	cNOMTRANSP := RetDescr( SA4->A4_NREDUZ, 30 )
	oNOMTRANSP:SetText( cNOMTRANSP )
	cCOMISSAO := RetDescr( Trans( SC5->C5_COMIS1, "@E 99.99" ) + "%", 30 )
	oCOMISSAO:SetText( cCOMISSAO )
	dDTSAIMERC := SC5->C5_DTSAIDA
	oDTSAIMERC:SetText( Dtoc( dDTSAIMERC ) )
	nVLPED     := 0
	SC6->( DbSeek( Xfilial( "SC6" ) + cPEDIDO ) )
	Do While SC6->C6_NUM == cPEDIDO
		nVLPED += ( SC6->C6_VALOR + SC6->C6_DESCIPI ) / SC6->C6_QTDVEN * SC6->C6_QTDENT
		SC6->( DbSkip() )
	EndDo
	oVLPED:SetText( RetDescr( Transform( nVLPED, "@E 999,999.99" ), 20 ) )
ElseIf ! Empty( cPEDIDO )
	MsgBox( "Pedido nao cadastrado.", "Atencao", "STOP" )
EndIf
Return .T.



***************

Static Function VldNota

***************

If Empty( cPEDIDO ) .and. SF2->( DbSeek( Xfilial( "SF2" ) + cNOTA, .T. ) )
	If SF2->F2_CLIENTE + SF2->F2_LOJA <> cCODCLI + cLOJCLI
		MsgBox( "Nota nao e desse cliente.", "Atencao", "STOP" )
		Return .T.
	EndIf
	SC5->( DbSetOrder( 5 ) )
	SC5->( DbSeek( Xfilial( "SC5" ) + cNOTA + SF2->F2_SERIE ) )
	If SC5->C5_NOTA + SC5->C5_SERIE == SF2->F2_DOC + SF2->F2_SERIE
		cPEDIDO := SC5->C5_NUM
		*      oPEDIDO:SetText( cPEDIDO )
		ObjectMethod( oPEDIDO, "Refresh()" )
		SA3->( DbSeek( Xfilial( "SA3" ) + SC5->C5_VEND1 ) )
		cREPRES := SC5->C5_VEND1
		cNOMREP := RetDescr( SA3->A3_NREDUZ, 30 )
		oNOMREP:SetText( cNOMREP )
		SA4->( DbSeek( Xfilial( "SA4" ) + SC5->C5_TRANSP ) )
		cTRANSP    := SC5->C5_TRANSP
		cNOMTRANSP := RetDescr( SA4->A4_NREDUZ, 40 )
		oNOMTRANSP:SetText( cNOMTRANSP )
		cCOMISSAO := RetDescr( Trans( SC5->C5_COMIS1, "@E 99.99" ) + "%", 30 )
		oCOMISSAO:SetText( cCOMISSAO )
		dDTSAIMERC := SC5->C5_DTSAIDA
		oDTSAIMERC:SetText( Dtoc( dDTSAIMERC ) )
		nVLPED := 0
		SC6->( DbSeek( Xfilial( "SC6" ) + cPEDIDO ) )
		Do While SC6->C6_NUM == cPEDIDO
			nVLPED += ( SC6->C6_VALOR + SC6->C6_DESCIPI ) / SC6->C6_QTDVEN * SC6->C6_QTDENT
			SC6->( DbSkip() )
		EndDo
		oVLPED:SetText( RetDescr( Transform( nVLPED, "@E 999,999.99" ), 20 ) )
	EndIf
EndIf
Return .T.



***************

Static Function ItInclui

***************

If ! VerifObrig()
	Return NIL
EndIf

CarregaPdt()

******** VARIAVEIS USADAS **********

cPRODUTO    := Space( 15 )
cDESCPDT    := Space( 40 )
cOCORRENCIA := " "
nQUANTP     := 0
nQUANTA     := 0
nVLPEDIT    := 0
nVLCALCIT   := 0
nVLNEGIT    := 0
cITRESP     := Space( 20 )
cOBS1       := Space( 80 )
cOBS2       := Space( 80 )
cOBS3       := Space( 80 )
cOBS4       := Space( 80 )
cOBS5       := Space( 80 )
cPar1       := Space( 80 )
cPar2       := Space( 80 )
cPar3       := Space( 80 )
cPar4       := Space( 80 )
cPar5       := Space( 80 )

cMOTIVO     := " "
cPARECER    := " "
lFRACAO     := .F.
lFLAG2      := .F.
nOPCAOIT    := 1

U_TMK001_2()

Activate Dialog oDLG2 Centered On Init oDLG2_Inic() Valid Sair2()
Return NIL



***************

Static Function CarregaPdt()

***************

SC5->( DbSeek( Xfilial( "SC5" ) + cPEDIDO ) )
SC6->( DbSeek( Xfilial( "SC6" ) + cPEDIDO ) )
SD2->( DbSeek( Xfilial( "SD2" ) + cNOTA + SC5->C5_SERIE, .T. ) )
PED->( __DbZap() )

Do While SD2->D2_DOC + SD2->D2_SERIE == cNOTA + SC5->C5_SERIE
	PED->( DbAppend() )
	PED->TIPO  := "N"
	PED->PRODUTO := SD2->D2_COD
	SB1->( DbSeek( Xfilial( "SB1" ) + SD2->D2_COD ) )
	PED->DESCR := SB1->B1_DESC
	PED->QUANT := SD2->D2_QUANT
	PED->PRECO := SD2->D2_PRCVEN + ( SD2->D2_VALIPI / SD2->D2_QUANT )
	PED->VALOR := ( SD2->D2_QUANT * SD2->D2_PRCVEN ) + SD2->D2_VALIPI
	SD2->( DbSkip() )
EndDo

Do While SC6->C6_NUM == cPEDIDO
	If ! PED->( DbSeek( SC6->C6_PRODUTO ) )
		PED->( DbAppend() )
		PED->TIPO  := "P"
		PED->PRODUTO := SC6->C6_PRODUTO
		SB1->( DbSeek( Xfilial( "SB1" ) + SC6->C6_PRODUTO ) )
		PED->DESCR := SB1->B1_DESC
		PED->QUANT := SC6->C6_QTDVEN
		PED->PRECO := ( SC6->C6_VALOR + SC6->C6_DESCIPI ) / SC6->C6_QTDVEN
		PED->VALOR := ( SC6->C6_VALOR + SC6->C6_DESCIPI )
	EndIf
	SC6->( DbSkip() )
EndDo
PED->( DbGotop() )
Return NIL



***************

Static Function VldProduto

***************

If SB1->( DbSeek( Xfilial( "SB1" ) + cPRODUTO ) )
	cDESCPDT := RetDescr( SB1->B1_DESC, 60 )
	oDESCPDT:SetText( cDESCPDT )
	If SB1->B1_UM == "UN"
		lFRACAO := .F.
		ObjectMethod( oFRACAO, "Refresh()" )
		oFRACAO:lReadOnly := .T.
	Else
		oFRACAO:lReadOnly := .F.
	EndIf
Else
	oDESCPDT:SetText( Repl( "_", 60 ) )
EndIf
If PED->( DbSeek( cPRODUTO ) )
	nQUANTP := PED->QUANT
	oQUANTP:SetText( RetDescr( Transform( nQUANTP, "@E 999,999" ), 20 ) )
	nVLPEDIT := PED->VALOR
	oVLPEDIT:SetText( RetDescr( Transform( PED->VALOR, "@E 999,999.99" ), 20 ) )
ElseIf ! Empty( cPRODUTO )
	MsgBox( "Produto nao pertence ao pedido/nota", "Atencao", "STOP" )
EndIf
Return .T.



***************

Static Function VldTipo

***************

If oTIPO:lReadOnly   // Bug do ADVPL: executa validacao de um campo READONLY
	Return .T.
EndIf

If RetTela( Left( cTIPO, 1 ) ) $ "1"
	oGrp76:lVisibleControl := .F.
	oOCORR:lVisibleControl := .F.
	oGrp70:lVisibleControl := .F.
	oCOM1:lVisibleControl  := .F.
	oCOM2:lVisibleControl  := .F.
	oCOM3:lVisibleControl  := .F.
	oCOM4:lVisibleControl  := .F.
	oCOM5:lVisibleControl  := .F.
	oINCLUI:lReadOnly      := .T.
	oALTERA:lReadOnly      := .T.
	oEXCLUI:lReadOnly      := .T.
	If nOPCAO <> 5 .or. nOPCAO <> 2 .or. nOPCAO == 6  //  Opcao Excluir/Visualizar/Parecer
		oINCLUI:lReadOnly   := .F.
		oALTERA:lReadOnly   := .F.
		oEXCLUI:lReadOnly   := .F.
	EndIf
	oCOMENT:lReadOnly      := .F.
	oBRW1:oBrowse:lVisibleControl := .T.
	nOPCAOIT := 0   // Controle de entrada na tela de itens
ElseIf RetTela( Left( cTIPO, 1 ) ) $ "2"
	MontCombIt()
	oOCORR:aItems          := aOCORITENS
	cOCORRENCIA            := " "
	oBRW1:oBrowse:lVisibleControl := .F.
	oGrp76:lVisibleControl := .T.
	oOCORR:lVisibleControl := .T.
	oGrp70:lVisibleControl := .T.
	oCOM1:lVisibleControl  := .T.
	oCOM2:lVisibleControl  := .T.
	oCOM3:lVisibleControl  := .T.
	oCOM4:lVisibleControl  := .T.
	oCOM5:lVisibleControl  := .T.
	oINCLUI:lReadOnly      := .T.
	oALTERA:lReadOnly      := .T.
	oEXCLUI:lReadOnly      := .T.
	oCOMENT:lReadOnly      := .T.
	oATDPAREC:lReadOnly    := .F.
	OSOLUCAO:lReadOnly     := .F.
	oRESP:lReadOnly        := .T.
	oDTSOLUC:lReadOnly     := .F.
	ObjectMethod( oOCORR, "Refresh()" )
	nOPCAOIT := 1  // Simular entrada na tela de itens
EndIf
Return .T.



***************

Static Function ItExclui

***************

If PDT->( Eof() )
	MsgBox( "Nao existem itens cadastrados no atendimento", "Atencao", "STOP" )
	Return NIL
EndIf

If MsgBox( "Confirma exclusao dos dados do item?", "Escolha", "YESNO" )
	PDT->( DbDelete() )
	oBRW1:oBrowse:Refresh()
EndIf
Return NIL



***************

Static Function ItAltera

***************

If ! VerifObrig()
	Return NIL
EndIf

If PDT->( Eof() )
	MsgBox( "Nao existem itens cadastrados no atendimento", "Atencao", "STOP" )
	Return NIL
EndIf

CarregaPdt()

******** VARIAVEIS USADAS **********

nOPCAOIT    := 2
cPRODUTO    := PDT->PRODUTO
SB1->( DbSeek( Xfilial( "SB1" ) + cPRODUTO ) )
cDESCPDT    := RetDescr( SB1->B1_DESC, 60 )
cOCORRENCIA := " "
nQUANTP     := PDT->QUANTP
nVLPEDIT    := PDT->VALPED
nQUANTA     := PDT->QUANTA
nVLCALCIT   := PDT->VALCALC
nVLNEGIT    := PDT->VALNEGA
cITRESP     := PDT->RESP
cOBS1       := PDT->OBSERV1
cOBS2       := PDT->OBSERV2
cOBS3       := PDT->OBSERV3
cOBS4       := PDT->OBSERV4
cOBS5       := PDT->OBSERV5
cPAR1       := PDT->PAREC1
cPAR2       := PDT->PAREC2
cPAR3       := PDT->PAREC3
cPAR4       := PDT->PAREC4
cPAR5       := PDT->PAREC5
lFRACAO     := ( PDT->FRACIO == "S" )
cMOTIVO     := " "
cPARECER    := " "
lFLAG2      := .F.

U_TMK001_2()

Activate Dialog oDLG2 Centered On Init oDLG2_Inic() Valid Sair2()
Return NIL

***************
Static Function ItParecer
***************

If ! VerifObrig()
	Return NIL
EndIf

******** VARIAVEIS USADAS **********

If PDT->( Eof() )
	MsgBox( "Nao existem itens cadastrados no atendimento", "Atencao", "STOP" )
	Return NIL
EndIf
nOPCAOIT    := 4
cPRODUTO    := PDT->PRODUTO
SB1->( DbSeek( Xfilial( "SB1" ) + cPRODUTO ) )
cDESCPDT    := RetDescr( SB1->B1_DESC, 60 )
cOCORRENCIA := " "
nQUANTP     := PDT->QUANTP
nVLPEDIT    := PDT->VALPED
nQUANTA     := PDT->QUANTA
nVLCALCIT   := PDT->VALCALC
nVLNEGIT    := PDT->VALNEGA
If nOPCAO == 2 .or. nOPCAO == 7  // Opcao visualizar ou parecer atend.
	cITRESP  := PDT->RESP
EndIf
cOBS1       := PDT->OBSERV1
cOBS2       := PDT->OBSERV2
cOBS3       := PDT->OBSERV3
cOBS4       := PDT->OBSERV4
cOBS5       := PDT->OBSERV5
cPAR1       := PDT->PAREC1
cPAR2       := PDT->PAREC2
cPAR3       := PDT->PAREC3
cPAR4       := PDT->PAREC4
cPAR5       := PDT->PAREC5
lFRACAO     := ( PDT->FRACIO == "S" )
cMOTIVO     := " "
cPARECER    := " "
lFLAG2      := .F.

U_TMK001_2()

Activate Dialog oDLG2 Centered On Init oDLG2_Inic() Valid Sair2()
Return NIL



***************

Static Function AtdParec

***************

Private xPARECE1 := cPARECE1, ;
xPARECE2 := cPARECE2, ;
xPARECE3 := cPARECE3, ;
xPARECE4 := cPARECE4, ;
xPARECE5 := cPARECE5

lFLAG6 := .F.

If nOPCAO <> 6 .and. nOPCAO <> 7 .and. nOPCAO <> 2 // Opcao diferente de parecer/visualizar
	aUSUARIO := U_senha2( "35" )
	If ! aUSUARIO[ 1 ]
		Return .T.
	EndIf
	cRESP := aUSUARIO[ 2 ]
EndIf

U_TMK001_6()

Activate Dialog oDLG6 Centered Valid Sair6()
Return NIL



***************

Static Function PareceCnf()

***************

lFLAG6 := .T.
Sair6()
Return .T.



***************

Static Function Coment

***************

Private xCOMENT1 := cCOMENT1, ;
xCOMENT2 := cCOMENT2, ;
xCOMENT3 := cCOMENT3, ;
xCOMENT4 := cCOMENT4, ;
xCOMENT5 := cCOMENT5

lFLAG5 := .F.

U_TMK001_5()

Activate Dialog oDLG5 Centered Valid Sair5()
Return NIL



***************

Static Function ComentCnf()

***************

lFLAG5 := .T.
Sair5()
Return .T.



***************

Static Function AtdConfirma

***************

Local cTEXTO := If( nOPCAO == 5, "exclusao", "gravacao" ), ;
lFLAG, lNCC := .F.

If ! VerifObrig()
	Return NIL
EndIf

If nOPCAO <> 2 .and. MsgBox( "Confirma " + cTEXTO + " dos dados do atendimento?", "Escolha", "YESNO" )
	If nOPCAO == 3        // Opcao incluir
		Reclock( "ZZO", .T. )
		ZZO->ZZO_FILIAL := xFILIAL( "ZZO" )    ;  ZZO->ZZO_NUM    := cNUMERO
		ZZO->ZZO_OPERAD := cOPERADOR           ;  ZZO->ZZO_TIPO   := cTIPO
		ZZO->ZZO_CLIENT := cCODCLI             ;  ZZO->ZZO_LOJCLI := cLOJCLI
		ZZO->ZZO_CONTAT := cCONTATO            ;  ZZO->ZZO_PEDIDO := cPEDIDO
		ZZO->ZZO_NOTA   := cNOTA               ;  ZZO->ZZO_EMISSA := dDTATEND
		ZZO->ZZO_SAIDA  := dDTSAIMERC          ;  ZZO->ZZO_RECEB  := dDTRECMERC
		ZZO->ZZO_RESP   := cRESP               ;  ZZO->ZZO_LOCAL  := cLOCAL
		ZZO->ZZO_DTSOLU := dDTSOLUC            ;  ZZO->ZZO_SOLUCA := cSOLUCAO
		ZZO->ZZO_VEND   := cREPRES             ;  ZZO->ZZO_TRANSP := cTRANSP
		ZZO->ZZO_OBS1   := cCOMENT1            ;  ZZO->ZZO_OBS2   := cCOMENT2
		ZZO->ZZO_OBS3   := cCOMENT3            ;  ZZO->ZZO_OBS4   := cCOMENT4
		ZZO->ZZO_OBS5   := cCOMENT5            ;  ZZO->ZZO_PAREC1 := cPARECE1
		ZZO->ZZO_PAREC2 := cPARECE2            ;  ZZO->ZZO_PAREC3 := cPARECE3
		ZZO->ZZO_PAREC4 := cPARECE4            ;  ZZO->ZZO_PAREC5 := cPARECE5
		If ! Empty( cLOCAL )
			ZZO->ZZO_DTSAID := dDATABASE        ;  ZZO->ZZO_HRSAID := Time()
		EndIf
		MsUnLock()
		If RetTela( Left( cTIPO, 1 ) ) $ "1"
			PDT->( DbGotop() )
			Do While ! PDT->( Eof() )
				Reclock( "ZZP", .T. )
				ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
				ZZP->ZZP_PROD   := PDT->PRODUTO       ;  ZZP->ZZP_OCORR  := PDT->OCORR
				ZZP->ZZP_QUANTA := PDT->QUANTA        ;  ZZP->ZZP_VLNEGP := PDT->VALCALC
				ZZP->ZZP_VLNEGA := PDT->VALNEGA       ;  ZZP->ZZP_RESP   := PDT->RESP
				ZZP->ZZP_PARECE := PDT->PARECER       ;  ZZP->ZZP_QUANTP := PDT->QUANTP
				ZZP->ZZP_OBS1   := PDT->OBSERV1       ;  ZZP->ZZP_FRACIO := PDT->FRACIO
				ZZP->ZZP_OBS2   := PDT->OBSERV2       ;  ZZP->ZZP_OBS3   := PDT->OBSERV3
				ZZP->ZZP_OBS4   := PDT->OBSERV4       ;  ZZP->ZZP_OBS5   := PDT->OBSERV5
				ZZP->ZZP_MOTIVO := PDT->MOTIVO        ;  ZZP->ZZP_VLPEDN := PDT->VALPED
            ZZP->ZZP_PAREC1 := PDT->PAREC1
            ZZP->ZZP_PAREC2 := PDT->PAREC2        ;  ZZP->ZZP_PAREC3 := PDT->PAREC3
            ZZP->ZZP_PAREC4 := PDT->PAREC4        ;  ZZP->ZZP_PAREC5 := PDT->PAREC5
				MsUnLock()
				PDT->( DbSkip() )
			EndDo
		Elseif RetTela( Left( cTIPO, 1 ) ) $ "2"
			Reclock( "ZZP", .T. )
			ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
			ZZP->ZZP_OCORR  := cOCORRENCIA
			MsUnLock()
		EndIf
		QST->( DbGotop() )
		Do While ! QST->( Eof() )
			Reclock( "ZY0", .T. )
			ZY0->ZY0_FILIAL := xFILIAL( "ZY0" )   ;  ZY0->ZY0_NUM   := cNUMERO
			ZY0->ZY0_PERG   := QST->PERGUNTA      ;  ZY0->ZY0_RESP  := QST->RESPOSTA
			MsUnLock()
			QST->( DbSkip() )
		EndDo
		ConfirmSX8()
	Elseif nOPCAO == 4     // Opcao alterar
		Reclock( "ZZO", .F. )
		If cLOCAL <> ZZO->ZZO_LOCAL
			ZZO->ZZO_DTSAID := dDATABASE        ;  ZZO->ZZO_HRSAID := Time()
		EndIf
		ZZO->ZZO_OPERAD := cOPERADOR           ;  ZZO->ZZO_TIPO   := cTIPO
		ZZO->ZZO_CLIENT := cCODCLI             ;  ZZO->ZZO_LOJCLI := cLOJCLI
		ZZO->ZZO_CONTAT := cCONTATO            ;  ZZO->ZZO_PEDIDO := cPEDIDO
		ZZO->ZZO_NOTA   := cNOTA               ;  ZZO->ZZO_EMISSA := dDTATEND
		ZZO->ZZO_SAIDA  := dDTSAIMERC          ;  ZZO->ZZO_RECEB  := dDTRECMERC
		ZZO->ZZO_RESP   := cRESP               ;  ZZO->ZZO_LOCAL  := cLOCAL
		ZZO->ZZO_DTSOLU := dDTSOLUC            ;  ZZO->ZZO_SOLUCA := cSOLUCAO
		ZZO->ZZO_VEND   := cREPRES             ;  ZZO->ZZO_TRANSP := cTRANSP
		ZZO->ZZO_OBS1   := cCOMENT1            ;  ZZO->ZZO_OBS2   := cCOMENT2
		ZZO->ZZO_OBS3   := cCOMENT3            ;  ZZO->ZZO_OBS4   := cCOMENT4
		ZZO->ZZO_OBS5   := cCOMENT5            ;  ZZO->ZZO_PAREC1 := cPARECE1
		ZZO->ZZO_PAREC2 := cPARECE2            ;  ZZO->ZZO_PAREC3 := cPARECE3
		ZZO->ZZO_PAREC4 := cPARECE4            ;  ZZO->ZZO_PAREC5 := cPARECE5
		MsUnLock()
		If nOPCAOIT > 0   // Entrou na tela de edicao de itens(alterou/incluiu)
			ZZP->( DbSeek( xFILIAL( "ZZP" ) + cNUMERO ) )
			Do While ZZP->ZZP_NUM == cNUMERO
				Reclock( "ZZP", .F. )
				ZZP->( DbDelete() )
				MsUnLock()
				ZZP->( DbSkip() )
			EndDo
			If RetTela( Left( cTIPO, 1 ) ) $ "1"
				PDT->( DbGotop() )
				Do While ! PDT->( Eof() )
					Reclock( "ZZP", .T. )
					ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
					ZZP->ZZP_PROD   := PDT->PRODUTO       ;  ZZP->ZZP_OCORR  := PDT->OCORR
					ZZP->ZZP_QUANTA := PDT->QUANTA        ;  ZZP->ZZP_VLNEGP := PDT->VALCALC
					ZZP->ZZP_VLNEGA := PDT->VALNEGA       ;  ZZP->ZZP_RESP   := PDT->RESP
					ZZP->ZZP_PARECE := PDT->PARECER       ;  ZZP->ZZP_QUANTP := PDT->QUANTP
					ZZP->ZZP_OBS1   := PDT->OBSERV1       ;  ZZP->ZZP_FRACIO := PDT->FRACIO
					ZZP->ZZP_OBS2   := PDT->OBSERV2       ;  ZZP->ZZP_OBS3   := PDT->OBSERV3
					ZZP->ZZP_OBS4   := PDT->OBSERV4       ;  ZZP->ZZP_OBS5   := PDT->OBSERV5
					ZZP->ZZP_MOTIVO := PDT->MOTIVO        ;  ZZP->ZZP_VLPEDN := PDT->VALPED
               ZZP->ZZP_PAREC1 := PDT->PAREC1
               ZZP->ZZP_PAREC2 := PDT->PAREC2        ;  ZZP->ZZP_PAREC3 := PDT->PAREC3
               ZZP->ZZP_PAREC4 := PDT->PAREC4        ;  ZZP->ZZP_PAREC5 := PDT->PAREC5
					MsUnLock()
					PDT->( DbSkip() )
				EndDo
			Elseif RetTela( Left( cTIPO, 1 ) ) $ "2"
				Reclock( "ZZP", .T. )
				ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
				ZZP->ZZP_OCORR  := cOCORRENCIA
				MsUnLock()
			EndIf
		EndIf
		If nOPCAOQT > 0   // Entrou na tela de edicao de itens(alterou/incluiu)
			ZY0->( DbSeek( xFILIAL( "ZY0" ) + cNUMERO ) )
			Do While ZY0->ZY0_NUM == cNUMERO
				Reclock( "ZY0", .F. )
				ZY0->( DbDelete() )
				MsUnLock()
				ZY0->( DbSkip() )
			EndDo
			QST->( DbGotop() )
			Do While ! QST->( Eof() )
				Reclock( "ZY0", .T. )
				ZY0->ZY0_FILIAL := xFILIAL( "ZY0" )   ;  ZY0->ZY0_NUM   := cNUMERO
				ZY0->ZY0_PERG   := QST->PERGUNTA      ;  ZY0->ZY0_RESP  := QST->RESPOSTA
				MsUnLock()
				QST->( DbSkip() )
			EndDo
		EndIf
	Elseif nOPCAO == 5     // Opcao excluir
		Reclock( "ZZO", .F. )
		ZZO->( DbDelete() )
		MsUnLock()
		ZZP->( DbSeek( xFILIAL( "ZZP" ) + cNUMERO ) )
		Do While ZZP->ZZP_NUM == cNUMERO
			Reclock( "ZZP", .F. )
			ZZP->( DbDelete() )
			MsUnLock()
			ZZP->( DbSkip() )
		EndDo
		ZY0->( DbSeek( xFILIAL( "ZY0" ) + cNUMERO ) )
		Do While ZY0->ZY0_NUM == cNUMERO
			Reclock( "ZY0", .F. )
			ZY0->( DbDelete() )
			MsUnLock()
			ZY0->( DbSkip() )
		EndDo
	Elseif nOPCAO == 6     // Opcao parecer item
		If nOPCAOIT > 0   // Entrou na tela de edicao de itens(alterou/incluiu)
			ZZP->( DbSeek( xFILIAL( "ZZP" ) + cNUMERO ) )
			Do While ZZP->ZZP_NUM == cNUMERO
				Reclock( "ZZP", .F. )
				ZZP->( DbDelete() )
				MsUnLock()
				ZZP->( DbSkip() )
			EndDo
			PDT->( DbGotop() )
			lFLAG := .T.
			Do While ! PDT->( Eof() )
				Reclock( "ZZP", .T. )
				ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
				ZZP->ZZP_PROD   := PDT->PRODUTO       ;  ZZP->ZZP_OCORR  := PDT->OCORR
				ZZP->ZZP_QUANTA := PDT->QUANTA        ;  ZZP->ZZP_VLNEGP := PDT->VALCALC
				ZZP->ZZP_VLNEGA := PDT->VALNEGA       ;  ZZP->ZZP_RESP   := PDT->RESP
				ZZP->ZZP_PARECE := PDT->PARECER       ;  ZZP->ZZP_QUANTP := PDT->QUANTP
				ZZP->ZZP_OBS1   := PDT->OBSERV1       ;  ZZP->ZZP_FRACIO := PDT->FRACIO
				ZZP->ZZP_OBS2   := PDT->OBSERV2       ;  ZZP->ZZP_OBS3   := PDT->OBSERV3
				ZZP->ZZP_OBS4   := PDT->OBSERV4       ;  ZZP->ZZP_OBS5   := PDT->OBSERV5
				ZZP->ZZP_MOTIVO := PDT->MOTIVO        ;  ZZP->ZZP_VLPEDN := PDT->VALPED
            ZZP->ZZP_PAREC1 := PDT->PAREC1
            ZZP->ZZP_PAREC2 := PDT->PAREC2        ;  ZZP->ZZP_PAREC3 := PDT->PAREC3
            ZZP->ZZP_PAREC4 := PDT->PAREC4        ;  ZZP->ZZP_PAREC5 := PDT->PAREC5
				MsUnLock()
				If Empty( PDT->PARECER )
					lFLAG := .F.
				EndIf
				PDT->( DbSkip() )
			EndDo
			If lFLAG  // Se informou parecer em todos os itens retorna p/ telemarketing
				Reclock( "ZZO", .F. )
				ZZO->ZZO_LOCSAI := ZZO->ZZO_LOCAL     ;  ZZO->ZZO_LOCAL  := "999"
				ZZO->ZZO_DTRETO := dDATABASE          ;  ZZO->ZZO_HRRETO := Time()
				MsUnLock()
			EndIf
		EndIf
	Elseif nOPCAO == 7     // Opcao parecer atendimento
		lFLAG := .T.
		If nOPCAOIT > 0   // Entrou na tela de edicao de itens(alterou/incluiu)
			ZZP->( DbSeek( xFILIAL( "ZZP" ) + cNUMERO ) )
			Do While ZZP->ZZP_NUM == cNUMERO
				Reclock( "ZZP", .F. )
				ZZP->( DbDelete() )
				MsUnLock()
				ZZP->( DbSkip() )
			EndDo
			PDT->( DbGotop() )
			Do While ! PDT->( Eof() )
				Reclock( "ZZP", .T. )
				ZZP->ZZP_FILIAL := xFILIAL( "ZZP" )   ;  ZZP->ZZP_NUM    := cNUMERO
				ZZP->ZZP_PROD   := PDT->PRODUTO       ;  ZZP->ZZP_OCORR  := PDT->OCORR
				ZZP->ZZP_QUANTA := PDT->QUANTA        ;  ZZP->ZZP_VLNEGP := PDT->VALCALC
				ZZP->ZZP_VLNEGA := PDT->VALNEGA       ;  ZZP->ZZP_RESP   := PDT->RESP
				ZZP->ZZP_PARECE := PDT->PARECER       ;  ZZP->ZZP_QUANTP := PDT->QUANTP
				ZZP->ZZP_OBS1   := PDT->OBSERV1       ;  ZZP->ZZP_FRACIO := PDT->FRACIO
				ZZP->ZZP_OBS2   := PDT->OBSERV2       ;  ZZP->ZZP_OBS3   := PDT->OBSERV3
				ZZP->ZZP_OBS4   := PDT->OBSERV4       ;  ZZP->ZZP_OBS5   := PDT->OBSERV5
				ZZP->ZZP_MOTIVO := PDT->MOTIVO        ;  ZZP->ZZP_VLPEDN := PDT->VALPED
            ZZP->ZZP_PAREC1 := PDT->PAREC1
            ZZP->ZZP_PAREC2 := PDT->PAREC2        ;  ZZP->ZZP_PAREC3 := PDT->PAREC3
            ZZP->ZZP_PAREC4 := PDT->PAREC4        ;  ZZP->ZZP_PAREC5 := PDT->PAREC5
				MsUnLock()
				If Empty( PDT->PARECER )
					lFLAG := .F.
				EndIf
				PDT->( DbSkip() )
			EndDo
		Endif
		If RetTela( Left( cTIPO, 1 ) ) $ "2" .or. lFLAG  // Se ja existe parecer em todos os itens grava parecer do atendimento
			Reclock( "ZZO", .F. )
			ZZO->ZZO_RESP   := cRESP     ;  ZZO->ZZO_SOLUCA := cSOLUCAO
			ZZO->ZZO_DTSOLU := dDTSOLUC  ;  ZZO->ZZO_PAREC1 := cPARECE1
			ZZO->ZZO_PAREC2 := cPARECE2  ;  ZZO->ZZO_PAREC3 := cPARECE3
			ZZO->ZZO_PAREC4 := cPARECE4  ;  ZZO->ZZO_PAREC5 := cPARECE5
			ZZO->ZZO_LOCAL  := "999"
			MsUnLock()
		   //
		   // Grava Mensagem para ser enviado ao Laptop com validade de dois dias.
		   _Cparecer := Alltrim(cParece1)+" "+Alltrim(cParece2)+" "+Alltrim(cParece3)+" "+Alltrim(cParece4)+" "+Alltrim(cParece5)
		   Grv_Mens_Lap(cNumero,cNota,_Cparecer)
		   //
			nVLTRAN := 0
         nVLDEB  := 0
         nVLNEG  := 0
         If Left( cSOLUCAO, 1 ) $ "14"
            @ 100,030 TO 250,390 DIALOG oDlg0 TITLE "Gravacao de titulos"
				@ 11,008 SAY "Valor do credito do cliente:"
            @ 11,108 GET nVLNEG SIZE 55,15 PICTURE "@E 999,999.99"
            @ 31,008 SAY "Valor do reembolso da transportadora:"
            @ 31,108 GET nVLTRAN SIZE 55,15 PICTURE "@E 999,999.99"
            DEFINE SBUTTON FROM 055, 055 TYPE 1 ACTION ( lNCC := .T., oDlg0:End() ) ENABLE
            DEFINE SBUTTON FROM 055, 095 TYPE 2 ACTION oDlg0:End() ENABLE
				ACTIVATE DIALOG oDlg0 CENTERED
            If lNCC .and. ( nVLNEG > 0 .or. nVLTRAN > 0 )
               If nVLNEG > 0
						aUSUARIO := U_senha2( "41" )
						If aUSUARIO[ 1 ]
							GravaNCC( nVLNEG, aUSUARIO[ 2 ] )
						EndIf
					Else
						GravaNCC( 0, "" )
					EndIf
				EndIf
         ElseIf Left( cSOLUCAO, 1 ) $ "25"
            @ 100,030 TO 250,390 DIALOG oDlg0 TITLE "Gravacao de titulos"
            @ 11,008 SAY "Valor do debito do cliente:"
            @ 11,108 GET nVLDEB SIZE 55,15 PICTURE "@E 999,999.99"
            DEFINE SBUTTON FROM 055, 055 TYPE 1 ACTION ( lNCC := .T., oDlg0:End() ) ENABLE
            DEFINE SBUTTON FROM 055, 095 TYPE 2 ACTION oDlg0:End() ENABLE
            ACTIVATE DIALOG oDlg0 CENTERED
            If lNCC .and. nVLDEB > 0
               aUSUARIO := U_senha2( "41" )
               If aUSUARIO[ 1 ]
                  GravaNCC( 0, aUSUARIO[ 2 ] )
               EndIf
            EndIf
			EndIf
		Else
			MsgBox( "Ainda existem itens sem parecer", "Atencao", "STOP" )
		EndIf
	EndIf
	lFLAG1 := .T.
	Close( oDLG1 )
Else
	*  If nOPCAO == 3   // Opcao incluir
	*     RollBackSX8()
	*  EndIf
	If nOPCAO == 2   // Opcao Visualizar
		lFLAG1 := .T.
		Close( oDLG1 )
	EndIf
EndIf
Return .T.

***************
Static Function ItConfirma
***************

If MsgBox( "Confirma gravacao dos dados do item?", "Escolha", "YESNO" )
	If nOPCAOIT == 1
		PDT->( DbAppend() )
		PDT->PRODUTO := cPRODUTO
		PDT->DESCR   := cDESCPDT
		PDT->OCORR   := cOCORRENCIA
		PDT->QUANTP  := nQUANTP
		PDT->FRACIO  := If( lFRACAO, "S", "N" )
		PDT->QUANTA  := nQUANTA
		PDT->VALPED  := nVLPEDIT
		PDT->VALCALC := nVLCALCIT
		PDT->VALNEGA := nVLNEGIT
		PDT->RESP    := cITRESP
		PDT->PARECER := cPARECER
		PDT->MOTIVO  := cMOTIVO
		PDT->OBSERV1 := cOBS1
		PDT->OBSERV2 := cOBS2
		PDT->OBSERV3 := cOBS3
		PDT->OBSERV4 := cOBS4
		PDT->OBSERV5 := cOBS5
      PDT->PAREC1  := cPAR1
      PDT->PAREC2  := cPAR2
      PDT->PAREC3  := cPAR3
      PDT->PAREC4  := cPAR4
      PDT->PAREC5  := cPAR5
		oTIPO:lReadOnly := .T.
	ElseIf nOPCAOIT == 2 .or. nOPCAOIT == 4
		PDT->PRODUTO := cPRODUTO
		PDT->DESCR   := cDESCPDT
		PDT->OCORR   := cOCORRENCIA
		PDT->QUANTP  := nQUANTP
		PDT->FRACIO  := If( lFRACAO, "S", "N" )
		PDT->QUANTA  := nQUANTA
		PDT->VALPED  := nVLPEDIT
		PDT->VALCALC := nVLCALCIT
		PDT->VALNEGA := nVLNEGIT
		PDT->RESP    := cITRESP
		PDT->PARECER := cPARECER
		PDT->MOTIVO  := cMOTIVO
		PDT->OBSERV1 := cOBS1
		PDT->OBSERV2 := cOBS2
		PDT->OBSERV3 := cOBS3
		PDT->OBSERV4 := cOBS4
		PDT->OBSERV5 := cOBS5
      PDT->PAREC1  := cPAR1
      PDT->PAREC2  := cPAR2
      PDT->PAREC3  := cPAR3
      PDT->PAREC4  := cPAR4
      PDT->PAREC5  := cPAR5
	EndIf
	lFLAG2 := .T.
	Close( oDLG2 )
EndIf
Return .T.



***************

Static Function VerifObrig()

***************

Local lRET := .T.

If Empty( cOPERADOR )
	MsgBox( "Informe o codigo do operador", "Atencao", "STOP" )
	lRET := .F.
Endif
If Empty( cTIPO )
	MsgBox( "Informe o tipo do atendimento", "Atencao", "STOP" )
	lRET := .F.
Endif
If Empty( cCODCLI ) .or. Empty( cLOJCLI )
	If RetTela( Left( cTIPO, 1 ) ) $ "2"
		lRET := MsgBox( "Cliente/Loja nao informado. Confirma?", "Escolha", "YESNO" )
	Else
		MsgBox( "Informe o cliente/loja do atendimento", "Atencao", "STOP" )
		lRET := .F.
	EndIf
Endif
If Empty( cCONTATO )
	If RetTela( Left( cTIPO, 1 ) ) $ "2"
		lRET := MsgBox( "Contato nao informado. Confirma?", "Escolha", "YESNO" )
	Else
		MsgBox( "Informe o contato do atendimento", "Atencao", "STOP" )
		lRET := .F.
	EndIf
Endif
If Empty( cPEDIDO ) .and. RetTela( Left( cTIPO, 1 ) ) $ "1"
	MsgBox( "Informe o numero do pedido do atendimento", "Atencao", "STOP" )
	lRET := .F.
Endif
If Empty( cNOTA ) .and. RetTela( Left( cTIPO, 1 ) ) $ "1"
	MsgBox( "Informe o numero da nota do atendimento", "Atencao", "STOP" )
	lRET := .F.
Endif
If RetTela( Left( cTIPO, 1 ) ) $ "2"
	If Empty( cOCORRENCIA )
		MsgBox( "Informe a ocorrencia do atendimento", "Atencao", "STOP" )
		lRET := .F.
	EndIf
Endif
Return lRET


***************

Static Function RetDescr( cTEXTO, nTAM )

***************

Return Alltrim( cTEXTO ) + Repl( "_", nTAM - Len( Alltrim( cTEXTO ) ) )



***************

Static Function MostraPdt()

***************

cRESPT := Space( 40 )
lFLAG4 := .F.
If ! PED->( DbSeek( cPRODUTO ) )
	PED->( DbGotop() )
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

U_TMK001_4()

Dbselectarea("PED")

oBRW3 := MsSelect():New( "PED",,, ;
{ { "TIPO",,    OemToAnsi( "Tp" ) }, ;
{ "PRODUTO",, OemToAnsi( "Produto" ) }, ;
{ "DESCR",,   OemToAnsi( "Descri‡ao" ) }, ;
{ "QUANT",, OemToAnsi( "Quant." ), "@E 999,999" }, ;
{ "PRECO",, OemToAnsi( "Prc.Unit." ), "@E 999,999.99" }, ;
{ "VALOR",, OemToAnsi( "Valor Total" ), "@E 999,999.99" } }, ;
.F.,, { 005, 002, 085, 322 } )

oBRW3:oBROWSE:bLDblClick  := { || PedConf() }
oBrw3:oBrowse:SetFocus()

Activate Dialog oDLG4 Centered
Return NIL



***************

Static Function BotQuest( cTIPO )

***************

cRESPT := If( cTIPO == "S", Padr( "SIM", 40 ), Padr( "NAO", 40 ) )
ObjectMethod( oRESPT, "Refresh()" )
QST->RESPOSTA := cRESPT
QST->( DbSkip() )
If QST->( Eof() )
	QST->( DbGobottom() )
EndIf
Return .T.



***************

Static Function QuestConf()

***************

QST->RESPOSTA := cRESPT
Return .T.



***************

Static Function PedConf()

***************

cPRODUTO := PED->PRODUTO
Sair4()
Return .T.



***************

Static Function PedTodos()

***************

If Empty( cOCORRENCIA )
	MsgBox( "Informe a ocorrencia dos itens", "Atencao", "STOP" )
	Return .T.
EndIf
If MsgBox( "Confirma inclusao de todos os produtos?", "Escolha", "YESNO" )
	PED->( DbGotop() )
	Do While ! PED->( Eof() )
		SB1->( DbSeek( Xfilial( "SB1" ) + PED->PRODUTO ) )
		PDT->( DbAppend() )
		PDT->PRODUTO := PED->PRODUTO
		PDT->DESCR   := SB1->B1_DESC
		PDT->OCORR   := cOCORRENCIA
		PDT->QUANTP  := PED->QUANT
		PDT->FRACIO  := "N"
		PDT->QUANTA  := PED->QUANT
		PDT->VALPED  := PED->VALOR
		PDT->VALCALC := PED->VALOR
		PDT->VALNEGA := PED->VALOR
		PED->( DbSkip() )
	EndDo
	PDT->( DbGotop() )
	Sair4()
	lFLAG2 := .T.
	Sair2()
Endif
Return .T.



***************

Static Function CalcItem()

***************

SB1->( DbSeek( Xfilial( "SB1" ) + cPRODUTO ) )
If PED->( DbSeek( cPRODUTO ) )
	If lFRACAO
		nVLCALCIT := nQUANTA * ( PED->PRECO / SB1->B1_UNICX )
	Else
		nVLCALCIT := nQUANTA * ( PED->VALOR / PED->QUANT )
	EndIf
	oVLCALCIT:SetText( RetDescr( Transform( nVLCALCIT, "@E 999,999.99" ), 15 ) )
	nVLNEGIT := nVLCALCIT
EndIf

Return .T.

***************

Static Function ValidPerg()

***************

Local _sAlias  := Alias()
Local cPerg    := "TMKX01"
Local aRegs    := {}
Local i,j

dbSelectArea( "SX1" )
dbSetOrder( 1 )
AADD(aRegs,{cPerg,"01","Do atendimento     :","De Emissao         :","De Emissao         :","mv_ch1","C",06,0,0,"G","","mv_par01",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZZO",""})
AADD(aRegs,{cPerg,"02","Ate o atendimento  :","Transfere          :","Transfere          :","mv_ch2","C",06,0,0,"G","","mv_par02",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZZO",""})
For i := 1 to Len(aRegs)
	If ! DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea( _sAlias )
Return NIL



***************

Static Function RetTela( cTIPO )

***************

If SX5->( DbSeek( "  ZS" + Padr( cTIPO, 6 ) ) )
	Return AllTrim( SX5->X5_DESCENG )
EndIf
Return "1"



***************
Static Function GravaNCC( nVALOR, cUSUARIO )
***************

Local nREG := SA1->( Recno() )

If nVALOR > 0
	cPARCELA := "   "
	DbSelectArea("SE1")
	DbSetOrder(1)
	Do While SE1->( Dbseek( xFilial() + "NF " + cNOTA + cPARCELA + "NCC" ) )
		cPARCELA := StrZero( Val( cPARCELA ) + 1, 3 )
	EndDo
	RecLock( "SE1", .T. )
	Replace E1_FILIAL	With xFilial("SE1")
	Replace E1_PREFIXO  With "NF "
	Replace E1_NUM		With cNOTA
	Replace E1_PARCELA  With cPARCELA
	Replace E1_TIPO	    With "NCC"
	Replace E1_NATUREZ  With "10104" //Mudar Natureza
	Replace E1_EMISSAO  With dDataBase
	Replace E1_VENCTO	With dDataBase
	Replace E1_VENCREA  With DataValida(dDataBase)
	Replace E1_SALDO	With nVALOR
	Replace E1_VALOR	With nVALOR
	Replace E1_VLCRUZ	With nVALOR
	Replace E1_MOEDA	With 1
	Replace E1_CLIENTE  With cCODCLI
	Replace E1_LOJA	    With cLOJCLI
	Replace E1_STATUS	With "A"
	Replace E1_SITUACA  With "0"
	Replace E1_VENCORI  With dDataBase
	Replace E1_EMIS1    With dDataBase
	Replace E1_NOMCLI   With cNOMECLI
	Replace E1_ORIGEM   With "UTMK001"
	Replace E1_LA       With "N"
	Replace E1_HIST     With AllTrim( Substr( cTIPO, 5 ) ) + ", PERCENTUAL " + Alltrim( cPERC )
	SE1->( MsUnLock() )
   Reclock( "ZZO", .F. )
   ZZO->ZZO_TITCRD := "NF " + cNOTA + cPARCELA + "NCC"
   MsUnLock()
EndIf
If nVLDEB > 0
   cPARCELA := "   "
   DbSelectArea("SE1")
   DbSetOrder(1)
   Do While SE1->( Dbseek( xFilial() + "NF " + cNOTA + cPARCELA + "NDC" ) )
      cPARCELA := StrZero( Val( cPARCELA ) + 1, 3 )
   EndDo
   RecLock( "SE1", .T. )
   Replace E1_FILIAL   With xFilial("SE1")
   Replace E1_PREFIXO  With "NF "
   Replace E1_NUM      With cNOTA
   Replace E1_PARCELA  With cPARCELA
   Replace E1_TIPO     With "NDC"
   Replace E1_NATUREZ  With "10104" //Mudar natureza
   Replace E1_EMISSAO  With dDataBase
   Replace E1_VENCTO   With dDataBase
   Replace E1_VENCREA  With DataValida(dDataBase)
   Replace E1_SALDO    With nVLDEB
   Replace E1_VALOR    With nVLDEB
   Replace E1_VLCRUZ   With nVLDEB
   Replace E1_MOEDA    With 1
   Replace E1_CLIENTE  With cCODCLI
   Replace E1_LOJA     With cLOJCLI
   Replace E1_STATUS   With "A"
   Replace E1_SITUACA  With "0"
   Replace E1_VENCORI  With dDataBase
   Replace E1_EMIS1    With dDataBase
   Replace E1_NOMCLI   With cNOMECLI
   Replace E1_ORIGEM   With "UTMK001"
   Replace E1_LA       With "N"
   Replace E1_HIST     With "REF. RECLAMACAO SAC " + Alltrim( cNUMERO )
   SE1->( MsUnLock() )
   Reclock( "ZZO", .F. )
   ZZO->ZZO_TITDEB := "NF " + cNOTA + cPARCELA + "NDC"
   MsUnLock()
EndIf
If nVLTRAN > 0
	cPARCELA := "   "
	DbSelectArea("SE1")
	DbSetOrder(1)
	Do While SE1->( Dbseek( xFilial() + "NF " + cNOTA + cPARCELA + "NF " ) )
		cPARCELA := StrZero( Val( cPARCELA ) + 1, 3 )
	EndDo
	SA4->( DbSeek( Xfilial() + ZZO->ZZO_TRANSP ) )
	If SA1->( DbSeek( Xfilial() + SA4->A4_CODCLI + '01' ) )
		RecLock( "SE1", .T. )
		Replace E1_FILIAL	With xFilial("SE1")
		Replace E1_PREFIXO  With "NF "
		Replace E1_NUM		With cNOTA
		Replace E1_PARCELA  With cPARCELA
		Replace E1_TIPO	    With "NF "
		Replace E1_NATUREZ  With "10108" //Mudar Natureza
		Replace E1_EMISSAO  With dDataBase
		Replace E1_VENCTO	With dDataBase
		Replace E1_VENCREA  With DataValida(dDataBase)
		Replace E1_SALDO	With nVLTRAN
		Replace E1_VALOR	With nVLTRAN
		Replace E1_VLCRUZ	With nVLTRAN
		Replace E1_MOEDA	With 1
		Replace E1_CLIENTE  With SA4->A4_CODCLI
		Replace E1_LOJA	    With "01"
		Replace E1_STATUS	With "A"
		Replace E1_SITUACA  With "0"
		Replace E1_VENCORI  With dDataBase
		Replace E1_EMIS1    With dDataBase
		Replace E1_NOMCLI   With SA1->A1_NOME
		Replace E1_ORIGEM   With "UTMK001"
		Replace E1_LA       With "N"
		Replace E1_HIST     With AllTrim( Substr( cTIPO, 5 ) )
		SE1->( MsUnLock() )
      Reclock( "ZZO", .F. )
      ZZO->ZZO_TITTRA := "NF " + cNOTA + cPARCELA + "NF "
      MsUnLock()
	Else
		MsgBox( "Reembolso nao foi gerado, porque nao existe essa transportadora como cliente", "Atencao", "STOP" )
		nVLTRAN := 0
	EndIf
	SA1->( DbGoto( nREG ) )
EndIf

* -------------------------------------------------------------------------------------------*
* Grava o NCC Automático no Memo de Cobrança
* -------------------------------------------------------------------------------------------*
Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xfilial()+SA1->A1_COD+SA1->A1_LOJA)
	T_memo := Trim(ZZ6->ZZ6_MEMO)
	If nVALOR > 0
		T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> (NCC) "+;
		AllTrim( Substr( cTIPO, 5 ) ) + ", PERCENTUAL " + Alltrim( cPERC ) + " Valor : "+Transform(NValor,"@E 999,999.99")
   EndIf
   If nVLDEB > 0
      T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> (NDC) "+;
      AllTrim( Substr( cTIPO, 5 ) ) + ", Valor : "+Transform( nVLDEB, "@E 999,999.99" )
   EndIf
	If nVLTRAN > 0
		T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) -> (REEMBOLSO) "+;
		AllTrim( Substr( cTIPO, 5 ) ) + ", Valor : "+Transform(NVlTRAN,"@E 999,999.99")
   EndIf
	Reclock("ZZ6",.F.)
	Replace ZZ6_MEMO With T_memo
	msunlock()
Else
	T_memo := ""
	If nVALOR > 0
		T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> (NCC) "+;
		AllTrim( Substr( cTIPO, 5 ) ) + ", PERCENTUAL " + Alltrim( cPERC ) + " Valor : "+Transform(Nvalor,"@E 999,999.99")
   EndIf
   If nVLDEB > 0
      T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) - "+ Trim(Subst(cUsuario,7,15))+" -> (NDC) "+;
      AllTrim( Substr( cTIPO, 5 ) ) + ", Valor : "+Transform( nVLDEB, "@E 999,999.99" )
   EndIf
	If nVLTRAN > 0
		T_memo := Trim(T_memo)+IIF(!Empty(T_memo),Chr(13)+chr(10),'')+DtoC(dDatabase)+" (  "+Time()+ " ) -> (REEMBOLSO) "+;
		AllTrim( Substr( cTIPO, 5 ) ) + ", Valor : "+Transform(NVlTRAN,"@E 999,999.99")
	EndIf
	Reclock("ZZ6",.T.)
	Replace ZZ6_FILIAL With xFilial()
	Replace ZZ6_CLIENT With SA1->A1_COD
	Replace ZZ6_LOJA   With SA1->A1_LOJA
	Replace ZZ6_MEMO   With T_memo
	Replace ZZ6_RETORN With dDatabase
	Replace ZZ6_TIPRET With '2'
	Replace ZZ6_ULCONT With CTOD("")
	Replace ZZ6_PRIORI With '   '
	Replace ZZ6_SEQUEN With '    '
	msunlock()
Endif

DbSelectArea("SE1")
* -------------------------------------------------------------------------------------------*
//Mudar

CONNECT SMTP SERVER AllTRIM(GETMV("MV_RELSERV")) ACCOUNT "ap7@florarte.net" PASSWORD "ap7"

If nVALOR > 0
	SEND MAIL FROM "Setor de Adm/Financeiro <adm@florarte.net>" to "Diretoria <marcio@florarte.net>"  ;
	CC  "Firmino <luizfirmino@florarte.net>;Dalva <dalva@florarte.net>;Alba <alba@florarte.net> " ;
	SUBJECT "Foi incluido NCC " + cNOTA + " para o cliente " + cNOMECLI ;
	BODY "Motivo : " + AllTrim( AllTrim( Substr( cTIPO, 5 ) ) + ", PERCENTUAL " + Alltrim( cPERC ) ) + ". <P> Valor : " + Transform( nVALOR, "@E 999,999,999.99" ) + " <P> <P> "
EndIf
If nVLDEB > 0
   SEND MAIL FROM "Setor de Adm/Financeiro <adm@florarte.net>" to "Diretoria <marcio@florarte.net>"  ;
   CC  "Firmino <luizfirmino@florarte.net>;Dalva <dalva@florarte.net>;Alba <alba@florarte.net> " ;
   SUBJECT "Foi incluido NDC " + cNOTA + " para o cliente " + cNOMECLI ;
   BODY "Motivo : " + AllTrim( AllTrim( Substr( cTIPO, 5 ) ) + ", Valor : " + Transform( nVLDEB, "@E 999,999,999.99" ) ) + " <P> <P> "
EndIf
If nVLTRAN > 0
	SEND MAIL FROM "Setor de Adm/Financeiro <adm@florarte.net>" to "Diretoria <marcio@florarte.net>"  ;
	CC  "Firmino <luizfirmino@florarte.net>;Dalva <dalva@florarte.net>;Eliton <eliton@florarte.net> " ;
	SUBJECT "Foi incluido reembolso " + cNOTA + " da " + AllTrim( SA4->A4_NOME ) ;
	BODY 	"Valor : " + Transform( nVLTRAN, "@E 999,999,999.99" ) + " <P> <P> "
EndIf

DISCONNECT SMTP SERVER

Return NIL



***************
Static Function RetSinal( cCHAVE )
***************

If SX5->( DbSeek( "  ZT" + Padr( cCHAVE, 6 ) ) )
	Return AllTrim( SX5->X5_DESCENG )
EndIf
Return "+"



***************

User Function TMK001_C( cAlias, nReg, nOpc )

***************

aUSUARIO := U_senha2( "35" )
If aUSUARIO[ 1 ]
   If MsgBox( "Confirma cancelamento do parecer?", "Escolha", "YESNO" )
      If ! Empty( ZZO->ZZO_TITCRD )
         SE1->( DbSetOrder( 1 ) )
         If SE1->( Dbseek( xFilial() + ZZO->ZZO_TITCRD ) )
            If ! Empty( SE1->E1_BAIXA )
               MsgBox( "Titulo ja baixado nao pode ser excluido: " + ZZO->ZZO_TITCRD, "Atencao", "STOP" )
            Else
               Reclock( "SE1", .F. )
               SE1->( DbDelete() )
               MsUnLock()
            Endif
         EndIf
      Endif
      If ! Empty( ZZO->ZZO_TITDEB )
         SE1->( DbSetOrder( 1 ) )
         If SE1->( Dbseek( xFilial() + ZZO->ZZO_TITDEB ) )
            If ! Empty( SE1->E1_BAIXA )
               MsgBox( "Titulo ja baixado nao pode ser excluido: " + ZZO->ZZO_TITDEB, "Atencao", "STOP" )
            Else
               Reclock( "SE1", .F. )
               SE1->( DbDelete() )
               MsUnLock()
            Endif
         EndIf
      Endif
      If ! Empty( ZZO->ZZO_TITTRA )
         SE1->( DbSetOrder( 1 ) )
         If SE1->( Dbseek( xFilial() + ZZO->ZZO_TITTRA ) )
            If ! Empty( SE1->E1_BAIXA )
               MsgBox( "Titulo ja baixado nao pode ser excluido: " + ZZO->ZZO_TITTRA, "Atencao", "STOP" )
            Else
               Reclock( "SE1", .F. )
               SE1->( DbDelete() )
               MsUnLock()
            Endif
         EndIf
      Endif
      Reclock( "ZZO", .F. )
      ZZO->ZZO_RESP   := ""         ;  ZZO->ZZO_SOLUCA := ""
      ZZO->ZZO_DTSOLU := Ctod( "" ) ;  ZZO->ZZO_PAREC1 := ""
      ZZO->ZZO_PAREC2 := ""         ;  ZZO->ZZO_PAREC3 := ""
      ZZO->ZZO_PAREC4 := ""         ;  ZZO->ZZO_PAREC5 := ""
      ZZO->ZZO_LOCAL  := "999"      ;  ZZO->ZZO_TITCRD := ""
      ZZO->ZZO_TITDEB := ""         ;  ZZO->ZZO_TITTRA := ""
      MsUnLock()
   EndIf
EndIf
Return NIL



***************

Static Function Sair1

***************

If lFLAG1 .or. MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	If ! lFLAG1 .and. nOPCAO == 3  // Opcao incluir
		RollBackSX8()
	EndIf
//	Close( oDLG1 )
	Return .T.
EndIf
Return .F.



***************

Static Function Sair2

***************

Local nREG := PDT->( Recno() )

nVLCALC := 0
nVLNEG  := 0
Dbselectarea("PDT")
If lFLAG2 .or. MsgBox( "Confirma saida da tela de itens?", "Escolha", "YESNO" )
	PDT->( DbGotop() )
	Do While ! PDT->( Eof() )
		nVLCALC += ( PDT->VALCALC * If( RetSinal( Left( cTIPO, 1 ) + "." + Left( PDT->OCORR, 1 ) ) == "-", -1, 1 ) )
		nVLNEG  += ( PDT->VALNEGA * If( RetSinal( Left( cTIPO, 1 ) + "." + Left( PDT->OCORR, 1 ) ) == "-", -1, 1 ) )
		PDT->( DbSkip() )
	EndDo
	oVLPED:SetText( RetDescr( Transform( nVLPED, "@E 999,999.99" ), 20 ) )
	oVLCALC:SetText( RetDescr( Transform( nVLCALC, "@E 999,999.99" ), 20 ) )
	oVLNEG:SetText( RetDescr( Transform( nVLNEG, "@E 999,999.99" ), 20 ) )
	cPERC       := RetDescr( Transform( nVLNEG / nVLPED * 100, "@E 999.99%" ), 15 )
	oPERC:SetText( cPERC )
	PDT->( DbGoto( nREG ) )
	oBRW1:oBrowse:Refresh()
	oBrw1:oBrowse:SetFocus()
//	Close( oDLG2 )
	Return .T.
EndIf

Return .F.



***************

Static Function Sair3

***************

If lFLAG3 .or. MsgBox( "Confirma saida da tela de questionario?", "Escolha", "YESNO" )
	Close( oDLG3 )
	Return .T.
EndIf
Return .F.



***************

Static Function Sair4

***************

ObjectMethod( oPRODUTO, "SetFocus()" )
Close( oDLG4 )
Return .T.



***************

Static Function Sair5

***************

If lFLAG5 .or. MsgBox( "Confirma saida da tela de comentario?", "Escolha", "YESNO" )
	If ! lFLAG5  // Clicou em cancelar
		cCOMENT1 := xCOMENT1
		cCOMENT2 := xCOMENT2
		cCOMENT3 := xCOMENT3
		cCOMENT4 := xCOMENT4
		cCOMENT5 := xCOMENT5
	EndIf
//	Close( oDLG5 )
	Return .T.
EndIf
Return .F.



***************

Static Function Sair6

***************

If lFLAG6 .or. MsgBox( "Confirma saida da tela de parecer?", "Escolha", "YESNO" )
	If ! lFLAG6  // Clicou em cancelar
		cPARECE1 := xPARECE1
		cPARECE2 := xPARECE2
		cPARECE3 := xPARECE3
		cPARECE4 := xPARECE4
		cPARECE5 := xPARECE5
	EndIf
//	Close( oDLG6 )
	Return .T.
EndIf
Return .F.



***************

Static Function Sair7

***************

Close( oDLG7 )
Return .T.



***************

User Function SemPerm

***************

MsgBox( "Usuario sem permissao", "Atencao", "STOP" )
Return .T.

* --------------------------------------------------------------------------*
* Gravar Mensagens par ao Laptop
* --------------------------------------------------------------------------*
static function Grv_Mens_Lap(_atend,_nf,_mensagem)
/*
 Grava da resposta da reclamação
*/

_cab := "Nº Atend : "+cNumero+" N.F.: "+cNota+" "
_div := 255-len(_cab)
_Tam := round((len(_mensagem)/_div)+0.4999,0)
_mx  := 1
_continua := ""
for i := 1 to _Tam
 	 Reclock( "ZZQ", .T. )
 	 ZZQ->zzq_filial := XFilial("ZZQ")
	 ZZQ->zzq_codmsg := GetSx8Num("ZZQ","ZZQ_CODMSG")
	 ZZQ->zzq_mensag := _cab + _continua + substr(_mensagem,_mx,_div-len(_continua))
	 ZZQ->zzq_orimsg := "1"
	 ZZQ->zzq_codven := cREPRES
	 ZZQ->zzq_dtmsg  := DDatabase
	 ZZQ->zzq_dtvig  := DDatabase+2
	 ZZQ->zzq_codset := '001'
	 ZZQ->zzq_pedido := cPEDIDO
	 ZZQ->zzq_cli    := cCODCLI
	 MsUnLock()
	 _mx += 255-len(_continua)
	 _continua := "Continuacao : "
next

return


