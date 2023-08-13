#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FATVTB()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAB,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATVTB    ³                               ³ Data ³ 26/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Validacao Tabela De Preco                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


If M->C5_TABELA == '1'
   nTAB := SB1->B1_PRV1
Else
   SB5->( DbSeek( xFILIAL('SB5') + M->C6_PRODUTO ) )
   If M->C5_TABELA == '2'
      nTAB := SB5->B5_PRV2
   ElseIf M->C5_TABELA == '3'
      nTAB := SB5->B5_PRV3
   ElseIf M->C5_TABELA == '4'
      nTAB := SB5->B5_PRV4
   ElseIf M->C5_TABELA == '5'
      nTAB := SB5->B5_PRV5
   ElseIf M->C5_TABELA == '6'
      nTAB := SB5->B5_PRV6
   ElseIf M->C5_TABELA == '7'
      nTAB := SB5->B5_PRV7
   ElseIf M->C5_TABELA == 'L'
      nTAB := SB5->B5_PRV8
   ElseIf M->C5_TABELA == 'M'
      nTAB := SB5->B5_PRV9
   ElseIf M->C5_TABELA == 'A'
      nTAB := SB5->B5_PRVA
   ElseIf M->C5_TABELA == 'B'
      nTAB := SB5->B5_PRVB
   ElseIf M->C5_TABELA == 'C'
      nTAB := SB5->B5_PRVC
   ElseIf M->C5_TABELA == 'D'
      nTAB := SB5->B5_PRVD
   ElseIf M->C5_TABELA == 'E'
      nTAB := SB5->B5_PRVE
   ElseIf M->C5_TABELA == 'F'
      nTAB := SB5->B5_PRVF
   ElseIf M->C5_TABELA == 'G'
      nTAB := SB5->B5_PRVG
   ElseIf M->C5_TABELA == 'H'
      nTAB := SB5->B5_PRVH
   ElseIf M->C5_TABELA == 'I'
      nTAB := SB5->B5_PRVI
   ElseIf M->C5_TABELA == 'J'
      nTAB := SB5->B5_PRVJ
   ElseIf M->C5_TABELA == 'L'
      nTAB := SB5->B5_PRVL
   ElseIf M->C5_TABELA == 'K'
      nTAB := SB5->B5_PRVK
   Else
      SA7->( DbSeek( xFILIAL('SA7') + M->C5_CLIENTE + M->C5_LOJACLI + M->C6_PRODUTO ) )
      nTAB := SA7->A7_PRECO01
   EndIf
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return( nTAB )
Return( nTAB )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

