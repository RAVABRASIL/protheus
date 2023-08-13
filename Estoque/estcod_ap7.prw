#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function estcod()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CCODATU,CCODNOV,NCONT,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio de Barros Silva                 ³ Data ³ 31/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Rotina de substituicao do codigo dos produtos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
@ 00,000 To 50,300 Dialog oDlg1 Title "Substituicao de codigo do produto"
@ 10,060 BMPBUTTON Type 1 Action OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,100 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
cALIASANT := Alias()
Close( oDlg1 )
Processa( {|| Est_Cod() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(Est_Cod) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Est_Cod
Static Function Est_Cod()
* SAB,SAC,SB0,SB4,SB5,SB6,SB8,SBA,SBC,SBD,SBF,SBG,SBH,SBI,SC0,SC3,SC4,SCA,SCK,SCL,SCP,SCQ,SD5,SD6,SD7,SD8

cCODATU := "BBC190         "
cCODNOV := "ABC190         "

SA5->( Dbsetorder( 2 ) )           // Produto X Fornecedor
SA7->( Dbsetorder( 2 ) )           // Produto X Cliente
SB1->( Dbsetorder( 2 ) )           // Produtos
SB2->( Dbsetorder( 1 ) )           // Saldo atual
SB3->( Dbsetorder( 1 ) )           // Demandas
SB5->( Dbsetorder( 1 ) )           // Complementos de produto
SB7->( Dbsetorder( 1 ) )           // Lancamentos do inventario
SB9->( Dbsetorder( 1 ) )           // Saldos Iniciais
SC1->( Dbsetorder( 2 ) )           // Solicitacoes de compra
SC2->( Dbsetorder( 2 ) )           // Ordens de producao
SC6->( Dbsetorder( 2 ) )           // Itens do pedido de venda
SC7->( Dbsetorder( 2 ) )           // Pedidos de compra
SC8->( Dbsetorder( 0 ) )           // Cotacoes de compra
SC9->( Dbsetorder( 0 ) )           // Pedidos liberados
SCE->( Dbsetorder( 0 ) )           // Encerramento de cotacoes
SD1->( Dbsetorder( 2 ) )           // Itens das NF de entrada
SD2->( Dbsetorder( 1 ) )           // Itens das NF de saida
SD3->( Dbsetorder( 3 ) )           // Movimentacoes internas
SD4->( Dbsetorder( 1 ) )           // Requisicoes empenhadas
SG1->( Dbsetorder( 1 ) )           // Estruturas de produto

SB1->( DbSetOrder( 1 ) )
SC8->( DbGotop() )
Do While ! SC8->( Eof() )
   If SC8->C8_PRODUTO == cCODATU
      If RecLock( "SC8", .F. )
         SC8->C8_PRODUTO := cCODNOV
         SC8->( Dbunlock() )
      EndIf
   EndIf
   SC8->( DbSkip() )
EndDo
SC9->( DbGotop() )
Do While ! SC9->( Eof() )
   If SC9->C9_PRODUTO == cCODATU
      If RecLock( "SC9", .F. )
         SC9->C9_PRODUTO := cCODNOV
         SC9->( Dbunlock() )
      EndIf
   EndIf
   SC9->( DbSkip() )
EndDo
SCE->( DbGotop() )
Do While ! SCE->( Eof() )
   If SCE->CE_PRODUTO == cCODATU
      If RecLock( "SCE", .F. )
         SCE->CE_PRODUTO := cCODNOV
         SCE->( Dbunlock() )
      EndIf
   EndIf
   SCE->( DbSkip() )
EndDo
SB1->( DbSeek( xFILIAL( 'SB1' ) + cCODATU, .T. ) )
*nCONT := 1
*SetRegua( nREGTOT )
*Do While SB1->( ! Eof() )
*      @ 22,00 Say "SB1"
      *-----------------------------------------------------------------
      If SB1->B1_COD == cCODATU .and. RecLock( "SB1", .F. )
         SB1->B1_COD := cCODNOV
         SB1->( Dbunlock() )
      EndIf
      *----------------------------------------------------------------
*      @ 22,00 Say "SA5"
      SA5->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SA5->( Eof() ) .and. SA5->A5_PRODUTO == cCODATU
         If RecLock( "SA5", .F. )
            SA5->A5_PRODUTO := cCODNOV
            SA5->( Dbunlock() )
            SA5->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SA7"
      SA7->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SA7->( Eof() ) .and. SA7->A7_PRODUTO == cCODATU
         If RecLock( "SA7", .F. )
            SA7->A7_PRODUTO := cCODNOV
            SA7->( Dbunlock() )
            SA7->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SB2"
      SB2->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SB2->( Eof() ) .and. SB2->B2_COD == cCODATU
         If RecLock( "SB2", .F. )
            SB2->B2_COD := cCODNOV
            SB2->( Dbunlock() )
            SB2->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SB3"
      SB3->( DbSeek( xfilial() + cCODATU ) )
      Do While ! SB3->( Eof() ) .and. SB3->B3_COD == cCODATU
         If RecLock( "SB3", .F. )
            SB3->B3_COD := cCODNOV
            SB3->( Dbunlock() )
            SB3->( DbSeek( xfilial() + cCODATU ) )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SB5"
      SB5->( DbSeek( xfilial() + cCODATU ) )
      Do While ! SB5->( Eof() ) .and. SB5->B5_COD == cCODATU
         If RecLock( "SB5", .F. )
            SB5->B5_COD := cCODNOV
            SB5->( Dbunlock() )
            SB5->( DbSeek( xfilial() + cCODATU ) )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SB7"
      SB7->( DbSeek( xfilial() + cCODATU ) )
      Do While ! SB7->( Eof() ) .and. SB7->B7_COD == cCODATU
         If RecLock( "SB7", .F. )
            SB7->B7_COD := cCODNOV
            SB7->( Dbunlock() )
            SB7->( DbSeek( xfilial() + cCODATU ) )
         EndIf
      Enddo
      *----------------------------------------------------------------
*      @ 22,00 Say "SB9"
      SB9->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SB9->( Eof() ) .and. SB9->B9_COD == cCODATU
         If RecLock( "SB9", .F. )
            SB9->B9_COD := cCODNOV
            SB9->( Dbunlock() )
            SB9->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      Enddo
      *----------------------------------------------------------------
*      @ 22,00 Say "SC1"
      SC1->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SC1->( Eof() ) .and. SC1->C1_PRODUTO == cCODATU
         If RecLock( "SC1", .F. )
            SC1->C1_PRODUTO := cCODNOV
            SC1->( Dbunlock() )
            SC1->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SC2"
      SC2->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SC2->( Eof() ) .and. SC1->C1_PRODUTO == cCODATU
         If RecLock( "SC2", .F. )
            SC2->C2_PRODUTO := cCODNOV
            SC2->( Dbunlock() )
            SC2->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SC6"
      SC6->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SC6->( Eof() ) .and. SC6->C6_PRODUTO == cCODATU
         If RecLock( "SC6", .F. )
            SC6->C6_PRODUTO := cCODNOV
            SC6->( Dbunlock() )
            SC6->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      Enddo
      *----------------------------------------------------------------
*      @ 22,00 Say "SC7"
      SC7->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SC7->( Eof() ) .and. SC7->C7_PRODUTO == cCODATU
         If RecLock( "SC7", .F. )
            SC7->C7_PRODUTO := cCODNOV
            SC7->( Dbunlock() )
            SC7->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SD1"
      SD1->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SD1->( Eof() ) .and. SD1->D1_COD == cCODATU
         If RecLock( "SD1", .F. )
            SD1->D1_COD := cCODNOV
            SD1->( Dbunlock() )
            SD1->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SD2"
      SD2->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SD2->( Eof() ) .and. SD2->D2_COD == cCODATU
         If RecLock( "SD2", .F. )
            SD2->D2_COD := cCODNOV
            SD2->( Dbunlock() )
            SD2->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SD3"
      SD3->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SD3->( Eof() ) .and. SD3->D3_COD == cCODATU
         If RecLock( "SD3", .F. )
            SD3->D3_COD := cCODNOV
            SD3->( Dbunlock() )
            SD3->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SD4"
      SD4->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SD4->( Eof() ) .and. SD4->D4_COD == cCODATU
         If RecLock( "SD4", .F. )
            SD4->D4_COD := cCODNOV
            SD4->( Dbunlock() )
            SD4->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 22,00 Say "SG1"
      SG1->( Dbsetorder( 1 ) )           // Produto principal
      SG1->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cCODATU
         If RecLock( "SG1", .F. )
            SG1->G1_COD := cCODNOV
            SG1->( Dbunlock() )
            SG1->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      SG1->( Dbsetorder( 2 ) )           // Componentes
      SG1->( DbSeek( xfilial() + cCODATU ), .T. )
      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cCODATU
         If RecLock( "SG1", .F. )
            SG1->G1_COMP := cCODNOV
            SG1->( Dbunlock() )
            SG1->( DbSeek( xfilial() + cCODATU ), .T. )
         EndIf
      EndDo
      *----------------------------------------------------------------
*      @ 23,00 Say nCONT Pict "9999"
*      nCONT := nCONT + 1
*      SB1->( DbSkip() )
*EndDo

Commit
RetIndex( 'SA5' )
RetIndex( 'SA7' )
RetIndex( 'SB1' )
RetIndex( 'SB2' )
RetIndex( 'SB3' )
RetIndex( 'SB7' )
RetIndex( 'SB9' )
RetIndex( 'SC1' )
RetIndex( 'SC2' )
RetIndex( 'SC6' )
RetIndex( 'SC7' )
RetIndex( 'SC8' )
RetIndex( 'SC9' )
RetIndex( 'SCE' )
RetIndex( 'SD1' )
RetIndex( 'SD2' )
RetIndex( 'SD3' )
RetIndex( 'SD4' )
RetIndex( 'SG1' )
RetIndex( 'SG2' )
DbSelectArea( cALIASANT )
Return


*----------------------------------------------------------------------------
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> FUNCTION BARRA
Static FUNCTION BARRA()
*----------------------------------------------------------------------------
*IncRegua()
*----------------------------------------------------------------------------
Return
