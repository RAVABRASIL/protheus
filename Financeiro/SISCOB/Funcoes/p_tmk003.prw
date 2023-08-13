#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"

*************

User Function TMK003()   // Todos os atendimentos

*************

*Resource2File( "SOURCE.PRW", "C:\AJUSFI5.PRW", 3 )
MontPrin( "", 1 )
Return NIL



*************

User Function TMK003A()   // Atendimentos agendados

*************

MontPrin( "( Empty( ZY2->ZY2_SOLUCA ) )", 2 )
Return NIL



*************

User Function TMK003B()    // Atendimentos encerrados

*************

MontPrin( "( ! Empty( ZY2->ZY2_SOLUCA ) )", 3 )
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

SetPrvt( "oDlg2,oSay1,oGrp2,oSay5,oOCORRENCIA,oSay7,oQUANTP,oSay10,oQUANTA,oSay13," )
SetPrvt( "oVLPEDIT,oSay15,oSay17,oVLNEGIT,oSay19,oSay22,oPARECER,oSay25,oMOTIVO,oGrp27," )
SetPrvt( "oSay28,oOBS1,oOBS2,oOBS3,oOBS4,oOBS5,oPedido,oFRACAO,oVLCALCIT" )

SetPrvt( "oDlg3,oSay1,oSay4,oRESPT,oQUESTS,oQUESTN,oQUEST,oQUESTCONF,oQUESTCANC,nOPCAO,nOPCAOIT,nOPCAOQT," )

SetPrvt( "cCadastro,aRotina,aCampos,aESTRUT,lFLAG1,lFLAG2,lFLAG3,lFLAG5,lFLAG6," )
SetPrvt( "aOCORITENS,aPAREITENS,nVLPEDIT,cMARCA,lINVERTE,oDLG4,cTIPO," )
SetPrvt( "cSOLUCAO,cRESP,cRESPT,dDTSAIMERC,dDTRECMERC,dDTSOLUC,dDTATEND,cLOCAL,cDESCLOC,oPARECER" )
SetPrvt( "nVLNEGIT,nVLPEDIT,nVLCALCIT,nVLPED,nVLCALC,nVLNEG,lFRACAO,nQUANTP,cOPERADOR,cCODCLI,cLOJCLI" )
SetPrvt( "cNOMECLI,cCONTATO,cPEDIDO,cNOTA,cNOMREP,cNOMTRANSP,cCOMISSAO,cPERC,cNOMOPER,cNUMERO," )
SetPrvt( "cTRANSP,cREPRES,oTRANSP,oREPRES," )

SetPrvt( "oDlg5,oCOMENT1,oCOMENT2,oCOMENT3,oCOMENT4,oCOMENT5,oSBtn7,oSBtn8," )
SetPrvt( "cCOMENT1,cCOMENT2,cCOMENT3,cCOMENT4,cCOMENT5,cPARECE1,cPARECE2,cPARECE3,cPARECE4,cPARECE5," )

SetPrvt( "oDlg6,oPARECE1,oPARECE2,oPARECE3,oPARECE4,oPARECE5,oSBtn6,oSBtn7." )

SetPrvt( "oDlg7,oHist1,oSay2,oHist2,oSay4,oSBtn6,aHIST1,aHIST2,cOCORRENCIA,oOCORR," )

SetPrvt( "oGrp76,oGrp70,oCOM1,oCOM2,oCOM3,oCOM4,oCOM5,nTIMEINI," )

aTIPOITENS := { " " }
SX5->( DbSeek( "  ZP", .T. ) )
Do While SX5->X5_TABELA == "ZP"
   Aadd( aTIPOITENS, Alltrim( Left( SX5->X5_CHAVE, 1 ) ) + " - " + Left( SX5->X5_DESCRI, 25 ) )
   SX5->( DbSkip() )
EndDo
aOCORITENS := { " " }
aSOLUITENS := { " ", "1 - ENCERRADO", "2 - PENDENTE", "3 - RETORNO" }

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

aESTRUT := { { "PERGUNTA", "C", 110, 0 }, ;
             { "RESPOSTA", "C", 040, 0 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "QST", .F., .F. )

aCampos    := {}
cCadastro  := "Manutencao de Atendimentos(SAC ativo)"

Do Case
	 Case nPROGRAM == 1
	    aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
                    { "Visualizar",'U_TMK003_E', 0, 2 } ,;
                    { "Incluir"  ,'U_TMK003_I', 0, 3 } ,;
                    { "Atender"  ,'U_TMK003_A', 0, 4 } ,;
                    { "Excluir"  ,'U_TMK003_E', 0, 5 } ,;
                    { "Imprimir" , 'U_TMK003_P', 0, 7 } }
	 Case nPROGRAM == 2
	    aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
                    { "Visualizar",'U_TMK003_E', 0, 2 } ,;
                    { "Incluir"  ,'U_TMK003_I', 0, 3 } ,;
                    { "Atender"  ,'U_TMK003_A', 0, 4 } ,;
                    { "Excluir"  ,'U_TMK003_E', 0, 5 } ,;
                    { "Imprimir" , 'U_TMK003_P', 0, 7 } }
	 Case nPROGRAM == 3
	    aRotina := { { "Pesquisa" ,'Axpesqui'  , 0, 1 } ,;
                    { "Visualizar",'U_TMK003_E', 0, 2 } ,;
                    { "Incluir"  ,'AlwaysTrue', 0, 3 } ,;
                    { "Atender"  ,'AlwaysTrue', 0, 4 } ,;
                    { "Excluir"  ,'AlwaysTrue', 0, 5 } ,;
                    { "Imprimir" , 'U_TMK003_P', 0, 7 } }
EndCase

DbSelectArea( "ZY2" )
If ! Empty( cFILTRO )
	Set Filter To &( cFILTRO )
EndIf
mBrowse( 06, 01, 22, 75, "ZY2",, "( ZY2_SOLUCA <> Space( 30 ) )" )
QST->( DbCloseArea() )
DbSelectArea( "ZY2" )
Set Filter To
Return NIL



*************

User Function TMK003_I( cAlias, nReg, nOpc )

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
cNUMERO     := GetSx8Num( "ZY2", "ZY2_NUM" )
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

cMARCA      := GetMark()   // Usado no MSSELECT
lINVERTE    := .F.         // Usado no MSSELECT
lFLAG1      := .F.

******** JANELA DE DIALOGO PRINCIPAL **********

If Empty( cPERG := PegaPerg() )
	Return NIL
EndIf
QST->( __DbZap() )
SX5->( DbSeek( "  ZX" + cPERG + ".001  " ) )
Do While SX5->X5_TABELA == "ZX" .and. Left( SX5->X5_CHAVE, 3 ) == cPERG + "."
	QST->( DbAppend() )
   QST->PERGUNTA := SX5->X5_DESCRI + SX5->X5_DESCENG
	SX5->( DbSkip() )
EndDo
QST->( DbGotop() )

U_TMK001_1()
nTIMEINI := Seconds()
Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK003_A( cAlias, nReg, nOpc )

*************

If nOPC == 4 .and. ! Empty( ZY2->ZY2_DTRETO )   // Opcao excluir
   MsgBox( "Atendimento ja encerrado nao pode ser alterado.", "Atencao", "STOP" )
   Return .T.
EndIf

nOPCAO := nOPC
CarregaAtd()
U_TMK001_1()
nTIMEINI := Seconds()
Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK003_E( cAlias, nReg, nOpc )

*************

If nOPC == 5 .and. ! Empty( ZY2->ZY2_DTRETO )   // Opcao excluir
   MsgBox( "Atendimento ja encerrado nao pode ser excluido.", "Atencao", "STOP" )
   Return .T.
EndIf

******** VARIAVEIS USADAS **********

nOPCAO := nOPC
CarregaAtd()
U_TMK001_1()

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



*************

User Function TMK003_P( cAlias, nReg, nOpc )

*************

Titulo     := "Formulario de atendimento"
cString    := "ZY2"
wnrel      := "TMK003"
CbTxt      := ""
cDesc1     := "O objetivo deste relat¢rio ‚ Emitir o formulario de atendimento"
cDesc2     := ""
Tamanho    := "M"
aReturn    := { "Zebrado", 1,"Estoque", 2, 2, 1, "",1 }
nLastKey   := 0
cPerg      := "UMKX03"
nomeprog   := "TMK003"
aOrd       := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()
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
*
*HISTORICO DO CLIENTE: TIPOS DE ATENDIMENTO
*
*
*
*HISTORICO DO CLIENTE: OCORRENCIAS
*
*
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
*STATUS: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
ZY2->( DbSeek( xFILIAL( "ZY2" ) + MV_PAR01, .T. ) )
Do While ! ZY2->( Eof() ) .and. ZY2->ZY2_NUM <= MV_PAR02
   aMATX1 := {}
   aMATX2 := {}
   cSQL := "SELECT ZY2_NUM,ZY2_TIPO,ZY2_OCORR "
   cSQL += "FROM " + RETSQLNAME( "ZY2" ) + " ZY2 "
   cSQL += "WHERE ZY2_CLIENT = '" + ZY2->ZY2_CLIENT + "' AND ZY2_LOJCLI = '" + ZY2->ZY2_LOJCLI + "' AND ZY2.D_E_L_E_T_ = '' AND "
   cSQL += "ZY2_FILIAL = '" + xFILIAL( "ZY2" ) + "' "
   cSQL += "ORDER BY ZY2_TIPO"
   cQueryTXT := ChangeQuery( cSQL )
   TCQUERY cSQL ALIAS ZY2X New
   aHIST1 := {}
   aHIST2 := {}
   ZY2X->( DbGotop() )
   Do While ! ZY2X->( Eof() )
      If Empty( nPOS := Ascan( aHIST1, { |X| X[ 1 ] == ZY2X->ZY2_TIPO } ) )
         Aadd( aHIST1, { ZY2X->ZY2_TIPO, 1 } )
      Else
         aHIST1[ nPOS, 2 ] += 1
      EndIf
      If Empty( nPOS := Ascan( aHIST2, { |X| X[ 1 ] + X[ 2 ]== ZY2X->ZY2_TIPO + ZY2X->ZY2_OCORR } ) )
         Aadd( aHIST2, { ZY2X->ZY2_TIPO, ZY2X->ZY2_OCORR, 1 } )
      Else
         aHIST2[ nPOS, 3 ] += 1
      EndIf
      ZY2X->( DbSkip() )
   EndDo
   ZY2X->( DbCloseArea() )
   Asort( aHIST2,,, {| X, Y | Y[ 1 ] + Y[ 2 ] > X[ 1 ] + X[ 2 ] } )
   For nPOS := 1 To Len( aHIST1 )
       aadd( aMATX1, aHIST1[ nPOS, 1 ] + "  >>>  " + Str( aHIST1[ nPOS, 2 ], 3 ) )
   Next
   For nPOS := 1 To Len( aHIST2 )
       SX5->( DbSeek( "  ZR" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
       Do While SX5->X5_TABELA == "ZR" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
          If SubStr( SX5->X5_CHAVE, 3, 1 ) == Left( aHIST2[ nPOS, 2 ], 1 )
             aadd( aMATX2, Left( aHIST2[ nPOS, 1 ], 1 ) + "." + aHIST2[ nPOS, 2 ] + "  >>>  " + Str( aHIST2[ nPOS, 3 ], 3 ) )
          EndIf
          SX5->( DbSkip() )
       EndDo
   Next
   aMATRIZ1 := {}
   SX5->( DbSeek( "  ZR" + Left( ZY2->ZY2_TIPO, 1 ), .T. ) )
   Do While SX5->X5_TABELA == "ZR" .and. Left( SX5->X5_CHAVE, 1 ) == Left( ZY2->ZY2_TIPO, 1 )
      Aadd( aMATRIZ1, Alltrim( SubStr( SX5->X5_CHAVE, 3 ) ) + " - " + SX5->X5_DESCRI )
      SX5->( DbSkip() )
   EndDo
   SU7->( DbSeek( Xfilial( "SU7" ) + ZY2->ZY2_OPERAD ) )
   SA1->( DbSeek( Xfilial( "SA1" ) + ZY2->ZY2_CLIENT + ZY2->ZY2_LOJCLI ) )
   SC5->( DbSeek( Xfilial( "SC5" ) + ZY2->ZY2_PEDIDO ) )
   SC6->( DbSeek( Xfilial( "SC6" ) + ZY2->ZY2_PEDIDO ) )
   SA3->( DbSeek( Xfilial( "SA3" ) + ZY2->ZY2_VEND ) )
   SA4->( DbSeek( Xfilial( "SA4" ) + ZY2->ZY2_TRANSP ) )
   SQB->( DbSeek( Xfilial( "SQB" ) + ZY2->ZY2_LOCAL ) )
   SD2->( DbSeek( Xfilial( "SD2" ) + ZY2->ZY2_NOTA + SC5->C5_SERIE, .T. ) )
   @ PROW(), 045 PSAY "F O R M U L A R I O   D E   A T E N D I M E N T O"
   @ PROW() + 2, 000 PSAY "NUMERO: " + ZY2->ZY2_NUM
   @ PROW() + 1, 000 PSAY "OPERADOR: " + ZY2->ZY2_OPERAD + " " + Padr( SU7->U7_NREDUZ, 30 ) + "  CLIENTE: " + ZY2->ZY2_CLIENT + "-" + ZY2->ZY2_LOJCLI + " " + Padr( SA1->A1_NOME, 36 ) + "  DATA DO ATENDIMENTO: " + Dtoc( ZY2->ZY2_EMISSA )
   @ PROW() + 1, 000 PSAY "TIPO DO ATENDIMENTO: " + aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_TIPO, 1 ) } ) ]
   @ PROW() + 2, 000 PSAY "HISTORICO DO CLIENTE: TIPOS DE ATENDIMENTO"
   For nPOS := 1 To Len( aMATX1 )
       @ PROW() + 1, 000 PSAY aMATX1[ nPOS ]
   Next
   @ PROW() + 2, 000 PSAY "HISTORICO DO CLIENTE: OCORRENCIAS"
   For nPOS := 1 To Len( aMATX2 )
       @ PROW() + 1, 000 PSAY aMATX2[ nPOS ]
   Next
   @ PROW() + 2, 000 PSAY "QUESTIONARIO:"
   @ PROW() + 1, 000 PSAY "PERGUNTA                                                                                                         RESPOSTA"
   ZY3->( DbSeek( xFILIAL( "ZY3" ) + ZY2->ZY2_NUM ) )
   Do While ZY3->ZY3_NUM == ZY2->ZY2_NUM
      @ PROW() + 1, 000 PSAY ZY3->ZY3_PERG
      @ PROW()    , 113 PSAY ZY3->ZY3_RESP
      ZY3->( DbSkip() )
   EndDo
   @ PROW() + 2, 000 PSAY "COMENTARIO DO CLIENTE:"
   @ PROW() + 1, 000 PSAY ZY2->ZY2_OBS1
   @ PROW() + 1, 000 PSAY ZY2->ZY2_OBS2
   @ PROW() + 1, 000 PSAY ZY2->ZY2_OBS3
   @ PROW() + 1, 000 PSAY ZY2->ZY2_OBS4
   @ PROW() + 1, 000 PSAY ZY2->ZY2_OBS5
   @ PROW() + 2, 000 PSAY "PARECER DO SETOR RESPONSAVEL:
   @ PROW() + 1, 000 PSAY ZY2->ZY2_PAREC1
   @ PROW() + 1, 000 PSAY ZY2->ZY2_PAREC2
   @ PROW() + 1, 000 PSAY ZY2->ZY2_PAREC3
   @ PROW() + 1, 000 PSAY ZY2->ZY2_PAREC4
   @ PROW() + 1, 000 PSAY ZY2->ZY2_PAREC5
   @ PROW() + 2, 000 PSAY "STATUS: " + ZY2->ZY2_SOLUCA
   ZY2->( DbSkip() )
   If ! ZY2->( Eof() ) .and. ZY2->ZY2_NUM <= MV_PAR02
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

User Function TMK003_R( cAlias, nReg, nOpc )

*************

nOPCAO := nOPC

If ! Empty( ZY2->ZY2_DTRETO ) .and. nOPCAO <> 7
   MsgBox( "Atendimento ja encerrado.", "Atencao", "STOP" )
   Return .T.
EndIf

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

Activate Dialog oDLG1 Centered On Init oDLG1_Inic() Valid Sair1()
Return NIL



***************

Static Function oDLG1_Inic

***************

oNUMERO:SetText( cNUMERO )
oOCORR:aItems          := aOCORITENS
cOCORRENCIA            := " "
oGrp76:lVisibleControl := .T.
oOCORR:lVisibleControl := .T.
oGrp70:lVisibleControl := .T.
oCOM1:lVisibleControl  := .T.
oCOM2:lVisibleControl  := .T.
oCOM3:lVisibleControl  := .T.
oCOM4:lVisibleControl  := .T.
oCOM5:lVisibleControl  := .T.
oCOMENT:lReadOnly      := .T.
oATDPAREC:lReadOnly    := .F.
OSOLUCAO:lReadOnly     := .F.
oRESP:lReadOnly        := .T.
oDTSOLUC:lReadOnly     := .F.
oPEDIDO:lReadOnly      := .T.
oNOTA:lReadOnly        := .T.
oTRANSP:lReadOnly      := .T.
oDTRECMERC:lReadOnly   := .T.
oLOCAL:lReadOnly       := .T.
oINCLUI:lReadOnly      := .T.
oALTERA:lReadOnly      := .T.
oEXCLUI:lReadOnly      := .T.
oITPARECER:lReadOnly   := .T.
If nOPCAO <> 3  // Opcao diferente de incluir
   cTIPO    := aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_TIPO, 1 ) } ) ]
   ObjectMethod( oTIPO, "Refresh()" )
   cSOLUCAO := aSOLUITENS[ Ascan( aSOLUITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_SOLUCA, 1 ) } ) ]
   ObjectMethod( oSOLUCAO, "Refresh()" )
   oNOMOPER:SetText( cNOMOPER )
   oNOMECLI:SetText( cNOMECLI )
   oDESCLOC:SetText( cDESCLOC )
*   oDTSAIMERC:SetText( ZY2->ZY2_SAIDA )
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
   oDTATEND:lReadOnly   := .T.
	MontCombIt()
	oOCORR:aItems        := aOCORITENS
	cOCORRENCIA          := aOCORITENS[ Ascan( aOCORITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_OCORR, 1 ) } ) ]
	ObjectMethod( oOCORR, "Refresh()" )
EndIf
If nOPCAO == 5 .or. nOPCAO == 2 .or. nOPCAO == 6 .or. nOPCAO == 7   //  Opcao Excluir/Visualizar/Parecer
   oOCORR:lReadOnly     := .T.
	oCOM1:lReadOnly      := .T.
	oCOM2:lReadOnly      := .T.
	oCOM3:lReadOnly      := .T.
	oCOM4:lReadOnly      := .T.
	oCOM5:lReadOnly      := .T.
EndIf
If nOPCAO <> 6 .and. nOPCAO <> 7 // Opcao diferente de parecer
   oRESP:lReadOnly      := .T.
EndIf
If nOPCAO == 6 .or. nOPCAO == 7 .or. nOPCAO == 2
   oCODCLI:lReadOnly    := .T.
   oLOJCLI:lReadOnly    := .T.
   oCONTATO:lReadOnly   := .T.
   oDTATEND:lReadOnly   := .T.
   oRESP:lReadOnly      := .T.
   oREPRES:lReadOnly    := .T.
   If nOPCAO == 6
      oATDPAREC:lReadOnly  := .T.
 		OSOLUCAO:lReadOnly   := .T.
      oRESP:lReadOnly      := .T.
      oDTSOLUC:lReadOnly   := .T.
	 Endif
EndIf
If nOPCAO == 4  // Opcao atendimento
   ObjectMethod( oCOM1, "SetFocus()" )
EndIf
Return .T.



***************

Static Function oDLG7_Inic

***************

Local aMATX1 := {}, ;
      aMATX2 := {}

cSQL := "SELECT ZY2_NUM,ZY2_TIPO,ZY2_OCORR "
cSQL += "FROM " + RETSQLNAME( "ZY2" ) + " ZY2 "
cSQL += "WHERE ZY2_CLIENT = '" + cCODCLI + "' AND ZY2_LOJCLI = '" + cLOJCLI + "' AND ZY2.D_E_L_E_T_ = '' AND "
cSQL += "ZY2_FILIAL = '" + xFILIAL( "ZY2" ) + "' "
cSQL += "ORDER BY ZY2_TIPO"
cQueryTXT := ChangeQuery( cSQL )
TCQUERY cSQL ALIAS ZY2X New

aHIST1 := {}
aHIST2 := {}
ZY2X->( DbGotop() )
Do While ! ZY2X->( Eof() )
   If Empty( nPOS := Ascan( aHIST1, { |X| X[ 1 ] == ZY2X->ZY2_TIPO } ) )
      Aadd( aHIST1, { ZY2X->ZY2_TIPO, 1 } )
   Else
      aHIST1[ nPOS, 2 ] += 1
   EndIf
   If Empty( nPOS := Ascan( aHIST2, { |X| X[ 1 ] + X[ 2 ]== ZY2X->ZY2_TIPO + ZY2X->ZY2_OCORR } ) )
      Aadd( aHIST2, { ZY2X->ZY2_TIPO, ZY2X->ZY2_OCORR, 1 } )
   Else
      aHIST2[ nPOS, 3 ] += 1
   EndIf
   ZY2X->( DbSkip() )
EndDo
ZY2X->( DbCloseArea() )

Asort( aHIST2,,, {| X, Y | Y[ 1 ] + Y[ 2 ] > X[ 1 ] + X[ 2 ] } )
For nPOS := 1 To Len( aHIST1 )
    aadd( aMATX1, aHIST1[ nPOS, 1 ] + "  >>>  " + Str( aHIST1[ nPOS, 2 ], 3 ) )
Next
oHIST1:aItems := aMATX1
For nPOS := 1 To Len( aHIST2 )
    If aHIST2[ nPOS, 1 ] == aHIST1[ 1, 1 ]
       SX5->( DbSeek( "  ZR" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
       Do While SX5->X5_TABELA == "ZR" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
          If SubStr( SX5->X5_CHAVE, 3, 1 ) == Left( aHIST2[ nPOS, 2 ], 1 )
             aadd( aMATX2, aHIST2[ nPOS, 2 ] + "  >>>  " + Str( aHIST2[ nPOS, 3 ], 3 ) )
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
cOPERADOR   := ZY2->ZY2_OPERAD
SU7->( DbSeek( Xfilial( "SU7" ) + ZY2->ZY2_OPERAD ) )
cNOMOPER    := RetDescr( SU7->U7_NREDUZ, 50 )
cTIPO       := aTIPOITENS[ Ascan( aTIPOITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_TIPO, 1 ) } ) ]
cCODCLI     := ZY2->ZY2_CLIENT
cLOJCLI     := ZY2->ZY2_LOJCLI
SA1->( DbSeek( Xfilial( "SA1" ) + cCODCLI + cLOJCLI ) )
cNOMECLI    := RetDescr( SA1->A1_NOME, 60 )
cCONTATO    := ZY2->ZY2_CONTAT
cPEDIDO     := ZY2->ZY2_PEDIDO
cNOTA       := ZY2->ZY2_NOTA
SC5->( DbSeek( Xfilial( "SC5" ) + cPEDIDO ) )
cNOTA  := SC5->C5_NOTA
nVLPED := 0
SC6->( DbSeek( Xfilial( "SC6" ) + cPEDIDO ) )
Do While SC6->C6_NUM == cPEDIDO
   nVLPED += ( SC6->C6_QTDVEN * SC6->C6_PRCVEN ) + SC6->C6_DESCIPI
   SC6->( DbSkip() )
EndDo
cREPRES := ZY2->ZY2_VEND
SA3->( DbSeek( Xfilial( "SA3" ) + cREPRES ) )
cNOMREP := RetDescr( SA3->A3_NREDUZ, 30 )
cTRANSP := ZY2->ZY2_TRANSP
SA4->( DbSeek( Xfilial( "SA4" ) + cTRANSP ) )
cNOMTRANSP  := RetDescr( SA4->A4_NREDUZ, 30 )
cCOMISSAO   := RetDescr( Trans( SC5->C5_COMIS1, "@E 99.99" ) + "%", 30 )
dDTSAIMERC  := ZY2->ZY2_SAIDA
dDTRECMERC  := ZY2->ZY2_RECEB
dDTATEND    := ZY2->ZY2_EMISSA
cRESP       := ZY2->ZY2_RESP
dDTSOLUC    := ZY2->ZY2_DTSOLU
cSOLUCAO    := aSOLUITENS[ Ascan( aSOLUITENS, { |X| Left( X, 1 ) == Left( ZY2->ZY2_SOLUCA, 1 ) } ) ]
cNUMERO     := ZY2->ZY2_NUM
cLOCAL      := ZY2->ZY2_LOCAL
SQB->( DbSeek( Xfilial( "SQB" ) + cLOCAL ) )
cDESCLOC    := RetDescr( Space( 30 ), 30 )
cCOMENT1    := ZY2->ZY2_OBS1
cCOMENT2    := ZY2->ZY2_OBS2
cCOMENT3    := ZY2->ZY2_OBS3
cCOMENT4    := ZY2->ZY2_OBS4
cCOMENT5    := ZY2->ZY2_OBS5
cPARECE1    := ZY2->ZY2_PAREC1
cPARECE2    := ZY2->ZY2_PAREC2
cPARECE3    := ZY2->ZY2_PAREC3
cPARECE4    := ZY2->ZY2_PAREC4
cPARECE5    := ZY2->ZY2_PAREC5

lFLAG1  := .F.
nVLCALC := 0
nVLNEG  := 0
MontCombIt()

QST->( __DbZap() )
ZY3->( DbSeek( xFILIAL( "ZY3" ) + cNUMERO ) )
Do While ZY3->ZY3_NUM == cNUMERO
   QST->( DbAppend() )
   QST->PERGUNTA := ZY3->ZY3_PERG
   QST->RESPOSTA := ZY3->ZY3_RESP
   ZY3->( DbSkip() )
EndDo
QST->( DbGotop() )
Return Nil



***************

Static Function MontCombIt

***************

Local aMATRIZ1 := { " " }, ;
      aMATRIZ2 := { " " }

SX5->( DbSeek( "  ZR" + Left( cTIPO, 1 ), .T. ) )
Do While SX5->X5_TABELA == "ZR" .and. Left( SX5->X5_CHAVE, 1 ) == Left( cTIPO, 1 )
   Aadd( aMATRIZ1, Alltrim( SubStr( SX5->X5_CHAVE, 3 ) ) + " - " + SX5->X5_DESCRI )
   SX5->( DbSkip() )
EndDo
aOCORITENS := aMATRIZ1
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
   If SU7->U7_TIPOATE <> "4" .and. SU7->U7_TIPOATE <> "2" .and. SU7->U7_TIPOATE <> "3"
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
	 ObjectMethod( oCONTATO, "Refresh()" )
	 cREPRES := SA1->A1_VEND
	 ObjectMethod( oREPRES, "Refresh()" )
	 VldVend()
Else
	 oNOMECLI:SetText( Repl( "_", 60 ) )
	 cCONTATO := Space( 30 )
	 ObjectMethod( oCONTATO, "Refresh()" )
	 cREPRES := Space( 06 )
	 ObjectMethod( oREPRES, "Refresh()" )
	 VldVend()
EndIf
cNOTA := Space( 06 )
oNOTA:SetText( cNOTA )
*ObjectMethod( oNOTA, "Refresh()" )
cPEDIDO := Space( 06 )
oPEDIDO:SetText( cPEDIDO )
*ObjectMethod( oPEDIDO, "Refresh()" )
oNOMTRANSP:SetText( Repl( "_", 40 ) )
oCOMISSAO:SetText( Repl( "_", 30 ) )
oDTSAIMERC:SetText( Repl( "_", 20 ) )
dDTATEND := dDATABASE
*oDTSAIMERC:SetText( dDTSAIMERC )
ObjectMethod( oDTATEND, "Refresh()" )
dDTRECMERC := Ctod( "  /  /  " )
*oDTRECMERC:SetText( dDTRECMERC )
Return .T.



***************

Static Function VldLocal

***************

*If SQB->( DbSeek( Xfilial( "SQB" ) + cLOCAL ) )
*   cDESCLOC := RetDescr( SQB->QB_DESCRIC, 30 )
*   oDESCLOC:SetText( cDESCLOC )
*Else
*   oDESCLOC:SetText( Repl( "_", 40 ) )
*EndIf
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
       SX5->( DbSeek( "  ZR" + Left( aHIST2[ nPOS, 1 ], 1 ), .T. ) )
       Do While SX5->X5_TABELA == "ZR" .and. Left( SX5->X5_CHAVE, 1 ) == Left( aHIST2[ nPOS, 1 ], 1 )
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
U_xPosicao()
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
      nVLPED += ( SC6->C6_QTDVEN * SC6->C6_PRCVEN ) + SC6->C6_DESCIPI
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
         nVLPED += ( SC6->C6_QTDVEN * SC6->C6_PRCVEN ) + SC6->C6_DESCIPI
         SC6->( DbSkip() )
      EndDo
      oVLPED:SetText( RetDescr( Transform( nVLPED, "@E 999,999.99" ), 20 ) )
	 EndIf
EndIf
Return .T.



***************

Static Function VldTipo

***************

MontCombIt()
oOCORR:aItems := aOCORITENS
ObjectMethod( oOCORR, "Refresh()" )
If oTIPO:lReadOnly   // Bug do ADVPL: executa validacao de um campo READONLY
	Return .T.
EndIf
Return .T.



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
			lFLAG

If ! VerifObrig()
   Return NIL
EndIf

If nOPCAO <> 2 .and. MsgBox( "Confirma " + cTEXTO + " dos dados do atendimento?", "Escolha", "YESNO" )
   If nOPCAO == 3        // Opcao incluir
	 	Reclock( "ZY2", .T. )
	 	ZY2->ZY2_FILIAL := xFILIAL( "ZY2" )    ;  ZY2->ZY2_NUM    := cNUMERO
      ZY2->ZY2_OPERAD := cOPERADOR           ;  ZY2->ZY2_TIPO   := cTIPO
	 	ZY2->ZY2_CLIENT := cCODCLI             ;  ZY2->ZY2_LOJCLI := cLOJCLI
	 	ZY2->ZY2_CONTAT := cCONTATO            ;  ZY2->ZY2_PEDIDO := cPEDIDO
      ZY2->ZY2_NOTA   := cNOTA               ;  ZY2->ZY2_EMISSA := dDTATEND
      ZY2->ZY2_SAIDA  := dDTSAIMERC          ;  ZY2->ZY2_RECEB  := dDTRECMERC
      ZY2->ZY2_RESP   := cRESP               ;  ZY2->ZY2_LOCAL  := cLOCAL
      ZY2->ZY2_DTSOLU := dDTSOLUC            ;  ZY2->ZY2_SOLUCA := cSOLUCAO
      ZY2->ZY2_VEND   := cREPRES             ;  ZY2->ZY2_TRANSP := cTRANSP
      ZY2->ZY2_OBS1   := cCOMENT1            ;  ZY2->ZY2_OBS2   := cCOMENT2
      ZY2->ZY2_OBS3   := cCOMENT3            ;  ZY2->ZY2_OBS4   := cCOMENT4
      ZY2->ZY2_OBS5   := cCOMENT5            ;  ZY2->ZY2_PAREC1 := cPARECE1
      ZY2->ZY2_PAREC2 := cPARECE2            ;  ZY2->ZY2_PAREC3 := cPARECE3
      ZY2->ZY2_PAREC4 := cPARECE4            ;  ZY2->ZY2_PAREC5 := cPARECE5
		ZY2->ZY2_OCORR  := cOCORRENCIA
      ZY2->ZY2_DTSAID := dDATABASE           ;  ZY2->ZY2_HRSAID := Time()
      If ! Empty( cSOLUCAO )
         ZY2->ZY2_DTRETO := dDATABASE        ;  ZY2->ZY2_HRRETO := Time()
 		   ZY2->ZY2_DURAC  := Right( U_DifHoras( Seconds(), nTIMEINI ), 5 )
      EndIf
 		MsUnLock()
 		QST->( DbGotop() )
 		Do While ! QST->( Eof() )
 			  Reclock( "ZY3", .T. )
 			  ZY3->ZY3_FILIAL := xFILIAL( "ZY3" )   ;  ZY3->ZY3_NUM   := cNUMERO
           ZY3->ZY3_PERG   := QST->PERGUNTA      ;  ZY3->ZY3_RESP  := QST->RESPOSTA
  	 		  MsUnLock()
	 		  QST->( DbSkip() )
	 	EndDo
	 	ConfirmSX8()
   Elseif nOPCAO == 4     // Opcao alterar
 		Reclock( "ZY2", .F. )
      If ! Empty( cSOLUCAO )
         ZY2->ZY2_DTRETO := dDATABASE        ;  ZY2->ZY2_HRRETO := Time()
 		   ZY2->ZY2_DURAC  := Right( U_DifHoras( Seconds(), nTIMEINI ), 5 )
      EndIf
      ZY2->ZY2_OPERAD := cOPERADOR           ;  ZY2->ZY2_TIPO   := cTIPO
	 		ZY2->ZY2_CLIENT := cCODCLI             ;  ZY2->ZY2_LOJCLI := cLOJCLI
	 		ZY2->ZY2_CONTAT := cCONTATO            ;  ZY2->ZY2_PEDIDO := cPEDIDO
      ZY2->ZY2_NOTA   := cNOTA               ;  ZY2->ZY2_EMISSA := dDTATEND
	 		ZY2->ZY2_SAIDA  := dDTSAIMERC          ;  ZY2->ZY2_RECEB  := dDTRECMERC
      ZY2->ZY2_RESP   := cRESP               ;  ZY2->ZY2_LOCAL  := cLOCAL
      ZY2->ZY2_DTSOLU := dDTSOLUC            ;  ZY2->ZY2_SOLUCA := cSOLUCAO
      ZY2->ZY2_VEND   := cREPRES             ;  ZY2->ZY2_TRANSP := cTRANSP
      ZY2->ZY2_OBS1   := cCOMENT1            ;  ZY2->ZY2_OBS2   := cCOMENT2
      ZY2->ZY2_OBS3   := cCOMENT3            ;  ZY2->ZY2_OBS4   := cCOMENT4
      ZY2->ZY2_OBS5   := cCOMENT5            ;  ZY2->ZY2_PAREC1 := cPARECE1
      ZY2->ZY2_PAREC2 := cPARECE2            ;  ZY2->ZY2_PAREC3 := cPARECE3
      ZY2->ZY2_PAREC4 := cPARECE4            ;  ZY2->ZY2_PAREC5 := cPARECE5
			ZY2->ZY2_OCORR  := cOCORRENCIA
	 		MsUnLock()
			If nOPCAOQT > 0   // Entrou na tela de edicao de itens(alterou/incluiu)
          ZY3->( DbSeek( xFILIAL( "ZY3" ) + cNUMERO ) )
					Do While ZY3->ZY3_NUM == cNUMERO
						 Reclock( "ZY3", .F. )
						 ZY3->( DbDelete() )
						 MsUnLock()
						 ZY3->( DbSkip() )
					EndDo
	 				QST->( DbGotop() )
	 				Do While ! QST->( Eof() )
	 					  Reclock( "ZY3", .T. )
	 					  ZY3->ZY3_FILIAL := xFILIAL( "ZY3" )   ;  ZY3->ZY3_NUM   := cNUMERO
              ZY3->ZY3_PERG   := QST->PERGUNTA      ;  ZY3->ZY3_RESP  := QST->RESPOSTA
							MsUnLock()
	 						QST->( DbSkip() )
	 				EndDo
	 	  EndIf
   Elseif nOPCAO == 5     // Opcao excluir
      Reclock( "ZY2", .F. )
      ZY2->( DbDelete() )
      MsUnLock()
      ZY3->( DbSeek( xFILIAL( "ZY3" ) + cNUMERO ) )
      Do While ZY3->ZY3_NUM == cNUMERO
         Reclock( "ZY3", .F. )
         ZY3->( DbDelete() )
         MsUnLock()
         ZY3->( DbSkip() )
      EndDo
   Elseif nOPCAO == 7     // Opcao parecer atendimento
      Reclock( "ZY2", .F. )
    	ZY2->ZY2_RESP   := cRESP               ;  ZY2->ZY2_SOLUCA := cSOLUCAO
     	ZY2->ZY2_DTSOLU := dDTSOLUC            ;  ZY2->ZY2_PAREC1 := cPARECE1
     	ZY2->ZY2_PAREC2 := cPARECE2            ;  ZY2->ZY2_PAREC3 := cPARECE3
     	ZY2->ZY2_PAREC4 := cPARECE4            ;  ZY2->ZY2_PAREC5 := cPARECE5
     	MsUnLock()
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
			lRET := MsgBox( "Cliente/Loja nao informado. Confirma?", "Escolha", "YESNO" )
Endif
If Empty( cCONTATO )
			lRET := MsgBox( "Contato nao informado. Confirma?", "Escolha", "YESNO" )
Endif
   If Empty( cOCORRENCIA )
   	  MsgBox( "Informe a ocorrencia do atendimento", "Atencao", "STOP" )
	    lRET := .F.
	 EndIf
Return lRET



***************

Static Function RetDescr( cTEXTO, nTAM )

***************

Return Alltrim( cTEXTO ) + Repl( "_", nTAM - Len( Alltrim( cTEXTO ) ) )



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



*******************

User FUNCTION DifHoras( nSEGUND1, nSEGUND2 )

*******************

nHORA := Int( ( nSEGUND1 - nSEGUND2 ) / 3600 )
nMIN  := Int( ( ( nSEGUND1 - nSEGUND2 ) % 3600 ) / 60 )
nSEC  := ( ( nSEGUND1 - nSEGUND2 ) % 3600 ) % 60
Return( StrZero( nHORA, 2 ) + ":" + StrZero( nMIN, 2 ) + ":" + StrZero( nSEC, 2 ) )



*******************

Static FUNCTION PegaPerg()

*******************

Local cPERG := Space( 02 )
Local oDLG

@ 000,000 To 120,203 Dialog oDLG Title "Tabela de perguntas"

@ 00, 02 To 42, 102
@ 17, 60 Get cPERG F3 "ZX" Picture "@!" Valid ! Empty( cPERG ) Size 30, 10 Object oPERG
@ 18, 09 Say "Codigo da pergunta:" Size 54, 07

@ 45,020 BmpButton Type 1 Action ODLG:End()
@ 45,057 BmpButton Type 2 Action ODLG:End()

Activate Dialog oDLG Centered
Return cPERG





***************

Static Function ValidPerg()

***************

Local _sAlias  := Alias()
Local cPerg    := "UMKX03"
Local aRegs    := {}
Local i,j

dbSelectArea( "SX1" )
dbSetOrder( 1 )
AADD(aRegs,{cPerg,"01","Do atendimento     :","De Emissao         :","De Emissao         :","mv_ch1","C",06,0,0,"G","","mv_par01",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZY2",""})
AADD(aRegs,{cPerg,"02","Ate o atendimento  :","Transfere          :","Transfere          :","mv_ch2","C",06,0,0,"G","","mv_par02",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZY2",""})
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

Static Function Sair1

***************

If lFLAG1 .or. MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
   If ! lFLAG1 .and. nOPCAO == 3  // Opcao incluir
			RollBackSX8()
	 EndIf
   Close( oDLG1 )
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
   Close( oDLG5 )
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
   Close( oDLG6 )
   Return .T.
EndIf
Return .F.



***************

Static Function Sair7

***************

Close( oDLG7 )
Return .T.
