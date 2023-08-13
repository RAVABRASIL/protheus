#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function cpad()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CABEC1")
SetPrvt("CABEC2,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  CPad    � Autor �   Luciane Santos      � Data � 08/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Lan�amentos Padronizados                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Rava                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis Ambientais                                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // De Emissao                            �
//� mv_par02            // Ate Emissao                           �
//� mv_par03            // De Pedido                             �
//� mv_par04            // Ate Pedido                            �
//� mv_par05            // De Produto                            �
//� mv_par06            // Ate Produto                           �
//� mv_par07            // De Cliente                            �
//� mv_par08            // Ate a Cliente                         �
//����������������������������������������������������������������
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=254

cDesc1 :=PADC("Este programa ira Emitir a Listagem dos Lancamentos Padronizados da Rava Embalagens", 74)

cDesc2 :=""

cDesc3 :=""

cNatureza:=""

aReturn := { "Contabilidade", 1,"Administracao", 1, 2, 1,"",1 }

nomeprog:="CPAD"

cPerg:="CPAD"

nLastKey:= 0

lContinua := .T.

nLin:=9
wnrel    := "CPAD"
M_PAG    := 1

nTamNf:=72     // Apenas Informativo

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//���������������������������������������������������������������������������

//Pergunte(cPerg,.F.)               // Pergunta no SX1

//cString:="SC5"
titulo :=PADC("Relatorio de Lancamentos Padronizados da Rava Embalagens",74)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
Cabec1:="Codigo   Seq     Descricao do Lancamento    Tipo  Debito       Credito          Historico     Validacao"

Cabec2:= ""
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//pergunte("FATR03",.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="CPAD"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

dbSelectArea("SI5")


@ nLin,00  pSay I5_CODIGO
@ nLin,18  pSay I5_DESCRIC
@ nLin,65  pSay I5_DC
@ nLin,76  pSay I5_DEBITO
@ nLin,84  pSay I5_CREDITO
@ nLin,97  pSay I5_HISTORI
@ nLin,120 pSay I5_PCPOVAL1

IncRegua()


IF nLin > 60
   nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
EndIF
nLin := nLin + 1


//roda(cbcont,cbtxt,tamanho)

//Retindex( "SC5" )

If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

Return(.T.)



