#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"

*************

User Function MANBAL()

*************

SetPrvt( "" )

cCadastro  := "Manutencao de pesagem dos fardos"

aRotina := { { "Pesquisar" ,'Axpesqui', 0, 1 } ,;
             { "Visualizar",'AxVisual', 0, 2 } ,;
             { "Excluir"  ,'U_MANBAL_E', 0, 5 } ,;
             { "Alterar Maquina" , 'U_MANBAL_M', 0, 6 } }

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

DbSelectArea( "Z00" )
mBrowse( 06, 01, 22, 75, "Z00",, "( Z00_BAIXA <> 'N' )" )
Return NIL



*****************

User Function MANBAL_E( cAlias, nReg, nOpc, cTransact, aCpos, aButtons )

*****************

If Z00->Z00_BAIXA == "S"
	 MsgAlert( "Codigo de barra deste fardo ja foi lido no estoque" )
	 Return .F.
EndIf
AxDeleta( cAlias, nReg, nOpc, cTransact, aCpos, aButtons )
Return NIL



*****************

User Function MANBAL_M()

*****************

cOP       := Space( 11 )
cMAQ      := Space( 06 )
dDATAI    := Ctod( "" )
dDATAF    := Ctod( "" )
cHORAI    := Space( 05 )
cHORAF    := Space( 05 )

@ 000,000 TO 220,330 Dialog oDLG1 Title OemToAnsi( "Altera‡ao de maquina" )
@ 011,005 Say "OP:"
@ 010,025 Get cOP Object oOP Size 60,40 F3 "SC2" Valid PesqOp( cOP )
@ 031,005 Say "Data inicial:"
@ 031,040 Get dDATAI Object oDATAI Size 40,40
@ 031,090 Say "Hora inicial:"
@ 031,125 Get cHORAI Object oHORAI Size 20,40 Picture "99:99"
@ 051,005 Say "Data final:"
@ 051,040 Get dDATAF Object oDATAF Size 40,40
@ 051,090 Say "Hora final:"
@ 051,125 Get cHORAF Object oHORAF Size 20,40 Picture "99:99"
@ 071,005 Say "Maquina:"
@ 070,035 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq( cMAQ )

@ 095,090 BMPButton Type 2 Action Close( oDLG1 )
@ 095,050 BMPButton Type 1 Action If( MudaMaq(), Close( oDLG1 ), NIL )
Activate Dialog oDLG1 Centered

Return NIL



***************

Static Function PesqOp()

***************

lRET := .T.

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 lRET := .F.
EndIf
Return lRET



***************

Static Function PesqMaq()

***************

lRET := .T.
If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
EndIf
Return lRET



***************

Static Function MudaMaq()

***************

lRET := .T.
If Empty( cOP ) .or. Empty( dDATAI ) .or. Empty( dDATAF ) .or. Empty( cHORAI ) .or. Empty( cHORAF ) .or. Empty( cMAQ )
	 MsgAlert( OemToAnsi( "Dados obrigatorios nao foram informados" ) )
	 lRET := .F.
EndIf
nORD := Z00->( Indexord() )
Z00->( DbSetOrder( 3 ) )
Z00->( DbSeek( xFilial( "Z00" ) + cOP, .T. ) )
nREG := 0
Do While Z00->Z00_OP == cOP
	 If ( Z00->Z00_DATA == dDATAI .and. Z00->Z00_HORA >= cHORAI .and. If( dDATAI == dDATAF, Z00->Z00_HORA <= cHORAF, .T. ) ) .or. ;
	 	( Z00->Z00_DATA == dDATAF .and. Z00->Z00_HORA <= cHORAI .and. If( dDATAI == dDATAF, Z00->Z00_HORA >= cHORAI, .T. ) ) .or. ;
	 	( Z00->Z00_DATA >= dDATAI + 1 .and. Z00->Z00_DATA <= dDATAF - 1 )
 			RecLock( "Z00", .F. )
 			Z00->Z00_MAQ := cMAQ
 			Z00->( MsUnlock() )
 			Z00->( DbCommit() )
			nREG++
	 EndIf
	 Z00->( DbSkip() )
EndDo
If SC2->C2_RECURSO <> cMAQ
	 RecLock( "SC2", .F. )
   SC2->C2_RECURSO := cMAQ
	 SC2->( MsUnlock() )
	 SC2->( DbCommit() )
EndIf
If nREG > 0
   Msginfo( OemToAnsi( AllTrim( Str( nREG ) ) + " fardos alterados" ), "Concluido" )
EndIf
Z00->( DbSetOrder( nORD ) )
Return lRET
