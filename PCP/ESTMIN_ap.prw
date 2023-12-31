#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTMIN()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt( "cFILTRO,cPERG" )

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇�  Autor  � Mauricio de Barros Silva                 � Data � 18/01/06 낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao� Alterar lote minimo do produto                             낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�   Uso   � Producao                                                   낢�
굇읕컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
*/
cPerg := "ESTMIN"

ValidPerg()
If Pergunte( cPerg, .T. )               // Pergunta no SX1
	 Processa( {|| Calcula() } )
EndIf
Return NIL


***************

Static Function Calcula()

***************

ProcRegua( SB1->( Lastrec() ) )
SB5->( Dbsetorder( 1 ) )
SB1->( DbGotop() )
While ! SB1->( Eof() )
   If SB5->( dbSeek( xFilial( "SB5" ) + SB1->B1_COD ) )
      If ( MV_PAR01 == 3 ) .or. ( SB5->B5_SANLAM == "S" .and. MV_PAR01 == 1 ) .or. ;
				( SB5->B5_SANLAM == "L" .and. MV_PAR01 == 2 )
				 If RecLock( "SB1", .F. )
            SB1->B1_LM := mv_par02 / SB1->B1_PESO
            SB1->( MsUnlock() )
            SB1->( DbCommit() )
				 EndIf
			EndIf
	 EndIf
	 IncProc()
	 SB1->( DbSkip() )
EndDo
Return NIL



***************

Static Function ValidPerg()

***************

PutSx1( cPERG, '01', 'Tipo da bobina     ?', '', '', 'mv_ch1', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par01', 'Sanfonado'       , '', '', '' , 'Laminado'             , '', '', 'Todos'               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPERG, '02', 'Producao minima(Kg)?', '', '', 'mv_ch2', 'N', 06, 0, 0, 'G', '', ''   , '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
Return NIL
