#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function fatcl2()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CPERG,CTITULO,NLASTKEY,CINDSA1")
SetPrvt("CCHAVE,CFILTRO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇�  Autor  � Luciane Santos da Silva                  � Data � 04/07/02 낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao� Relat줿io de Aniversariantes (Clientes)                    낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�   Uso   � Marketing                                                  낢�
굇읕컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Salva a Integridade dos dados de Entrada.                    �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
cALIASANT := alias()
/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  � Variaveis de parametrizacao da impressao.                    �
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SA1"
aORD     := { "Por Data","Por Nome"}
cNOMREL  := "FATCLI"
cPERG    := "FATCLI"
cTITULO  := "Rela눯o de Aniversariantes - "
nLASTKEY := 0
/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  � Inicio do processamento                                      �
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
Pergunte(cPerg,.F.)               // Pergunta no SX1

cNOMREL := setprint( cARQUIVO, cNOMREL, "FATCLI", @cTITULO, cDESC1, cDESC2, ;
 cDESC3, .f., aORD )
If nLastKey == 27
   Return
Endif

//VERIFICA POSICAO DA IMPRESSORA

setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Inicio do Processamento do Relatorio                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

dbselectarea( 'SA1' )
cIndSA1 := CriaTrab(nil,.f.) 
cChave  := "A1_FILIAL + A1_NOME"
cFiltro := Month(A1_DTNASC)== 04
IndRegua( "SA1", cIndSA1, cChave, ,cFiltro,"Selecionando Registros..." )
DbSetOrder(1)
dbSeek( xFilial( "SA1" ),.t. )
SetRegua(LastRec())
//DO While ! SA1->( eof() ) //.and. StrZero( Month( A1_DTNASC), 2 )== MV_PAR01
  @ 10,05  pSay SA1->A1_NOME
  @ 10,15  pSay SA1->A1_DTNASC
  @ 10,20  pSay SA1->A1_COD   
  DbSkip()
  IncRegua()
//ENDDO
RetIndex("SA1")
IF aReturn[5] == 1
  dbCommitAll()
  ourspool(cNOMREL)
ENDIF


