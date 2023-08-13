#IFDEF WINDOWS
    #include "fivewin.ch"
#ENDIF

User Function MT100GE2()


/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±± Nome     : Eurivan Marques Candido                    Data  : 03/12/02  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±± Descricao: Incluir Obs no Titulo na inclusao da nota de entrada         ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

Private cGetDesc

cGetDesc := Space( 25 )
cTitulo :=  "Titulo " + SE2->E2_PARCELA
cSayDesc := "Obs.:"

if RecLock( "SE2", .F. )

   //Inclusao da Descricao Produto secundario
   #IFDEF WINDOWS
      DEFINE MSDIALOG oDlg TITLE OemtoAnsi( cTitulo ) FROM  00,00 TO 80,400 PIXEL OF oMainWnd
      @ 010, 005 SAY cSayDesc SIZE 040, 0 OF oDlg PIXEL
      @ 019, 005 GET cGetDesc SIZE 160, 0 OF oDlg PIXEL
      DEFINE SBUTTON FROM 018, 170 TYPE 1 ACTION ( SE2->E2_HIST := cGetDesc, oDlg:End() ) ENABLE OF oDlg
      ACTIVATE MSDIALOG oDlg CENTER
   #ENDIF

   SE2->( MsUnlock() )
   SE2->( dbCommit() )
endif

Return
