#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTASL()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CFILTRO,CCHAVE,CINDSB9,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 07/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Altualizar SB2 pelo SB9                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Informatica                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Pergunte("FINATA",.F.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Atualizacao SB2 pelo SB9 de (30/04/2001)"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("ESTASL")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


dbselectarea( "SB9" )
SB9->( dbsetorder( 1 ) )
dbselectarea( "SB2" )
SB2->( dbsetorder( 1 ) )


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

Close(oDlg1)
Processa( {|| Ata_sld() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(Ata_sld) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Ata_sld
Static Function Ata_sld()

DBSelectArea("SB9")

cFILTRO  := "B9_DATA == CToD('30/04/01')"       
cCHAVE   := "xFilial('SB9')+B9_COD"
cIndSB9 := CriaTrab(NIL, .F.)
IndRegua("SB9", cIndSB9, cCHAVE,, cFILTRO, "Selecionando Registros...")

//Processando Saldos Iniciais
ProcRegua( SB9->( LastRec() ) )
SB9->(DBGoTop())
While ! SB9->( EOF() )
   If SB2->( dbSeek( xFilial( "SB2" ) + SB9->B9_COD + SB9->B9_LOCAL ) )
      //Aviso("M E N S A G E M","Codigo -> "+SB5->B5_COD, {"OK"})
      
      If RecLock( "SB2", .F. )
         SB2->B2_QFIM := SB9->B9_QINI
         SB2->B2_VFIM := SB9->B9_VINI1
         SB2->( DbUnlock() )
         SB2->( DbCommit() )
      Else
         Inkey(1)
         Aviso("M E N S A G E M","Codigo -> "+SB2->B2_COD+" - Registro Bloqueado", {"OK"})
         Loop
      Endif

   EndIf

   SB9->( DBSkip() )
   IncProc()
Enddo

SAI_PROG()

Return NIL


*****************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function SAI_PROG
Static Function SAI_PROG()
*****************
RetIndex('SB9')
RetIndex('SB2')
Return NIL


