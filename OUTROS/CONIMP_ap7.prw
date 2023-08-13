#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function CONIMP()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NRES,CNAT,CDC,CNIVEL,CCODIGO,X")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FIN001    ³ Autor ³ Silvano Araujo        ³ Data ³11/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao de plano de contas                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Importacao Plano de contas     "
@ 10,030 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,030 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,080 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| Import() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(Import) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Import
Static Function Import()

SI1->( dbSetOrder( 3 ) )
SI1->( dbGobottom() )
nRes := Val( SI1->I1_RES )
SI1->( dbSetOrder( 1 ) )

use pla_2801 alias IMP new exclusive
ProcRegua( IMP->( lastrec() ) )
while IMP->( !Eof() )

   if Substr( IMP->CT_CODIGO, 1, 1 ) == "1"
      if Substr( IMP->CT_TITULO, 2, 1 ) == "-"
         cNat := "C"
      else
         cNat := "D"
      endif
   elseif Substr( IMP->CT_CODIGO, 1, 1 ) == "2"
      if Substr( IMP->CT_TITULO, 2, 1 ) == "-"
         cNat := "D"
      else
         cNat := "C"
      endif
   elseif Substr( IMP->CT_CODIGO, 1, 5 ) $ "3.1.1 3.1.2"
      if Substr( IMP->CT_TITULO, 2, 1 ) == "-"
         cNat := "D"
      else
         cNat := "C"
      endif
   elseif Substr( IMP->CT_CODIGO, 1, 5 ) >= "3.1.3" .and. Substr( IMP->CT_CODIGO, 1, 5 ) <= "3.9.9"
      if Substr( IMP->CT_TITULO, 2, 1 ) == "-"
         cNat := "C"
      else
         cNat := "D"
      endif
   else
      cNat := " "
   endif


   if Len( Alltrim( IMP->CT_CODIGO ) ) == 13
      cDC := "A"
   else
      cDC := "S"
   endif

   if Len( Alltrim( IMP->CT_CODIGO ) ) == 13
      cNivel := "5"
   elseif Len( Alltrim( IMP->CT_CODIGO ) ) == 8
      cNivel := "4"
   elseif Len( Alltrim( IMP->CT_CODIGO ) ) == 5
      cNivel := "3"
   elseif len( Alltrim( IMP->CT_CODIGO ) ) == 3
      cNivel := "2"
   elseif Len( Alltrim( IMP->CT_CODIGO ) ) == 1
      cNivel := "1"
   else
      cNivel := "0"
   endif

   cCodigo := Substr( IMP->CT_CODIGO,1,1 )+Substr( IMP->CT_CODIGO,3,1)+Substr( IMP->CT_CODIGO,5,1)+Substr( IMP->CT_CODIGO,7,2)+Substr(IMP->CT_CODIGO,10,4)
   nRes    := nRes + 1

   SI1->( dbSeek( xFilial( "SI1" ) + Alltrim( cCodigo ), .t. ) )

   if Alltrim( SI1->I1_CODIGO ) == Alltrim( cCodigo )
      RecLock( "SI1", .f. )
   else
      For x := 2 to 5
          RecLock( "SI7", .t. )
          SI7->I7_FILIAL  := xFilial("SI7") ;  SI7->I7_CODIGO  := cCodigo
          SI7->I7_MOEDA   := Str(x,1)
          SI7->( dbcommit() )
          SI7->( MsUnlock() )
      Next

      RecLock( "SI1", .T. )
      SI1->I1_FILIAL := xFilial( "SI1" ); SI1->I1_CODIGO := cCodigo
      SI1->I1_DESC   := IMP->CT_TITULO;   SI1->I1_CLASSE := cDC
      SI1->I1_NIVEL  := cNivel;           SI1->I1_RES    := StrZero( nRes, 5 )
      SI1->I1_NORMAL := cNat;             SI1->I1_CV2    := "D"
      SI1->I1_CV3    := "D";              SI1->I1_CV4    := "D"
      SI1->I1_CV5    := "D";              SI1->I1_ESTADO := 0
   endif
   SI1->I1_SALANT := IMP->CT_SALDO00 * -1
   SI1->( dbCommit() )
   SI1->( MsUnlock() )

   IMP->( dbSkip() )
   IncProc()

end

IMP->( dbCloseArea() )
Close( oDlg1 )
Return

