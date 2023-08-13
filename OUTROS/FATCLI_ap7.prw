#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATCLI()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CPERG,CTITULO,NLASTKEY,CINDSA1")
SetPrvt("CCHAVE,CFILTRO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���  Autor  � Luciane Santos da Silva                  � Data � 04/07/02 ���
������������������������������������������������������������������������Ĵ��
���Descricao� Relat�rio de Aniversariantes (Clientes)                    ���
������������������������������������������������������������������������Ĵ��
���   Uso   � Marketing                                                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
��������������������������������������������������������������Ŀ
� Salva a Integridade dos dados de Entrada.                    �
����������������������������������������������������������������
*/
cALIASANT := alias()
/*��������������������������������������������������������������Ŀ
  � Variaveis de parametrizacao da impressao.                    �
  ����������������������������������������������������������������
*/
cDESC1   := "Este programa emite a listagem dos Clientes que Aniversariam"
cDESC2   := "no mes selecionado nos parametros"
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "FATCLI", 2, 2, 1, "", 1 }
cARQUIVO := "SA1"
aORD     := { "Por Data","Por Nome","Por Codigo"}
cNOMREL  := "FATCLI"
cPERG    := "FATCLI"
cTITULO  := "Relacao de Aniversariantes - "
nLASTKEY := 0
/*��������������������������������������������������������������Ŀ
  � Inicio do processamento                                      �
  ����������������������������������������������������������������
*/
Pergunte(cPerg,.F.)               // Pergunta no SX1

cNOMREL := Setprint(cARQUIVO, cNOMREL, "FATCLI",@cTITULO, cDESC1, cDESC2, ;
cDESC3, .f., aORD )
If nLastKey == 27
   Return
Endif

//VERIFICA POSICAO DA IMPRESSORA

setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

//��������������������������������������������������������������Ŀ
//� Inicio do Processamento do Relatorio                         �
//����������������������������������������������������������������

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
IndRegua( "SA1", cIndSA1, cChave, ,cFiltro, "Selecionando Registros..." )
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


