#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FATVTB()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("NTAB,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑ATVTB    �                               � Data � 26/04/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿣alidacao Tabela De Preco                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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

