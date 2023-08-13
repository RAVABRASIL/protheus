#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function CONIPC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,NREGTOT,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 03/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Implantacao de Saldo de contas p/ clientes/fornecedores    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
@ 00,000 To 50,200 Dialog oDlg1 Title "Implantacao de Saldo de Contas"
@ 10,020 BMPBUTTON Type 1 Action OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,020 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,060 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
cALIASANT := Alias()
Close( oDlg1 )

If SM0->M0_CODIGO=="02"
   Processa( {|| Con_Sal() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Con_Sal) } )
Else
   Aviso("M E N S A G E M", "Entre na Empresa 02 - RAVA", {"OK"})
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Con_Sal
Static Function Con_Sal()

SA1->( Dbsetorder( 1 ) )           // Cadastro de Clientes
SA2->( Dbsetorder( 1 ) )           // Cadastro de Fornecedores
SI1->( Dbsetorder( 1 ) )           // Plano de Contas


//PROCESSANDO CADASTRO DE CLIENTES
nREGTOT := SA1->( LastRec() )

SA1->( DbGotop() )

ProcRegua(nREGTOT)
@ 12,115 Say "-> Implantando Sld Conta de Clientes" Size 200

Do While ! SA1->( Eof() ) .And. SA1->A1_FILIAL==xFilial("SA1")
   If SA1->A1_CONTA #Space(20)
      If SI1->( DbSeek( xfilial("SI1") + SA1->A1_CONTA ) )
         If RecLock( "SI1", .F. )
            SI1->I1_SALANT := 0
            SI1->I1_DEBM01 := 0
            SI1->I1_CRDM01 := 0
            SI1->I1_DEBM02 := 0
            SI1->I1_CRDM02 := 0
            SI1->I1_DEBM03 := 0
            SI1->I1_CRDM03 := 0
            SI1->I1_DEBM04 := 0
            SI1->I1_CRDM04 := 0
            SI1->I1_DEBM05 := 0
            SI1->I1_CRDM05 := 0
            SI1->I1_DEBM06 := 0
            SI1->I1_CRDM06 := 0
            SI1->I1_DEBM07 := 0
            SI1->I1_CRDM07 := 0
            SI1->I1_DEBM08 := 0
            SI1->I1_CRDM08 := 0
            SI1->I1_DEBM09 := 0
            SI1->I1_CRDM09 := 0
            SI1->I1_DEBM10 := 0
            SI1->I1_CRDM10 := 0
            SI1->I1_DEBM11 := 0
            SI1->I1_CRDM11 := 0
            If SA1->A1_SALDUP == 0
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := 0
            Else
               If SA1->A1_SALDUP > 0
                  SI1->I1_DEBM12 := SA1->A1_SALDUP
                  SI1->I1_CRDM12 := 0
               Else
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := SA1->A1_SALDUP * (-1)
               Endif
            Endif
            SI1->( Dbunlock() )
         EndIf
      Endif
   EndIf
   SA1->( DbSkip() )
   IncProc()
EndDo

//PROCESSANDO CADASTRO DE FORNECEDORES
nREGTOT := SA2->( LastRec() )

SA2->( DbGotop() )

ProcRegua(nREGTOT)
@ 12,115 Say "-> Implant. Sld Conta de Fornecedores" Size 200

Do While ! SA2->( Eof() ) .And. SA2->A2_FILIAL==xFilial("SA2")
   If SA2->A2_CONTA #Space(20)
      If SI1->( DbSeek( xfilial("SI1") + SA2->A2_CONTA ) )
         If RecLock( "SI1", .F. )
            SI1->I1_SALANT := 0
            SI1->I1_DEBM01 := 0
            SI1->I1_CRDM01 := 0
            SI1->I1_DEBM02 := 0
            SI1->I1_CRDM02 := 0
            SI1->I1_DEBM03 := 0
            SI1->I1_CRDM03 := 0
            SI1->I1_DEBM04 := 0
            SI1->I1_CRDM04 := 0
            SI1->I1_DEBM05 := 0
            SI1->I1_CRDM05 := 0
            SI1->I1_DEBM06 := 0
            SI1->I1_CRDM06 := 0
            SI1->I1_DEBM07 := 0
            SI1->I1_CRDM07 := 0
            SI1->I1_DEBM08 := 0
            SI1->I1_CRDM08 := 0
            SI1->I1_DEBM09 := 0
            SI1->I1_CRDM09 := 0
            SI1->I1_DEBM10 := 0
            SI1->I1_CRDM10 := 0
            SI1->I1_DEBM11 := 0
            SI1->I1_CRDM11 := 0
            If SA2->A2_SALDUP == 0
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := 0
            Else
               If SA2->A2_SALDUP > 0
                  SI1->I1_DEBM12 := 0
                  SI1->I1_CRDM12 := SA2->A2_SALDUP
               Else
                SI1->I1_DEBM12 := SA2->A2_SALDUP * (-1)
                SI1->I1_CRDM12 := 0
               Endif
            Endif
            SI1->( Dbunlock() )
         EndIf
      Endif
   EndIf
   SA2->( DbSkip() )
   IncProc()
EndDo


Commit
RetIndex( 'SA1' )
RetIndex( 'SA2' )
RetIndex( 'SI1' )
DbSelectArea( cALIASANT )
Return
