#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function COMR01()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,M_PAG,NTAMNF,CSTRING,LABORTPRINT")
SetPrvt("CABEC1,CABEC2,MPAG,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  COMR01  � Autor �   Silvano Araujo      � Data �15/03/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Solicitacoes de compras                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Rava Embalagens                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis Ambientais                                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De Solicitacao                       �
//� mv_par02             // Ate Solicitacao                      �
//� mv_par03             // Listar Quais                         �
//� mv_par04             // De Data                              �
//� mv_par05             // Ate Data                             �
//� mv_par06             // Mostra pedido de compras?            �
//����������������������������������������������������������������
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=254
titulo :=PADC("RELACAO DE SOLICITACOES DE COMPRAS (Incluindo Pedidos de Compras)",74)
cDesc1 :=PADC("Este programa ira emitir Relacao de Solicitacoes",74)
cDesc2 :=PADC("de compras.",74)
cDesc3 :=""
cNatureza:=""
aReturn := { "Compras", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="COMR01"
cPerg:="MTR100"
nLastKey:= 0
lContinua := .T.
nLin:=9
wnrel    := "COMR01"
M_PAG    := 1
//�����������������������������������������������������������Ŀ
//� Tamanho do Formulario de Nota Fiscal (em Linhas)          �
//�������������������������������������������������������������

nTamNf:=72     // Apenas Informativo

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//���������������������������������������������������������������������������

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SC1"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
   Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

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
//�����������������������������������������������������������Ŀ
//� Inicializa  de variaveis                                  �
//�������������������������������������������������������������

lAbortPrint := .f.
Cabec1 := "NUMERO IT PRODUTO DESCRICAO DO PRODUTO                                                                                  TP QUANTIDADE UM CENTRO DE  EMISSAO  ENTREGA SOLICITANTE N.PED/ CODIGO LJ NOME FORNECEDOR      SALDO"
Cabec2 := "                                                                                                                           SOLICITADA        CUSTO           DA S.C.             N.COT. FORNEC                       DA S.C."
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//         0         1         2         3         4         5         6         7         8         9         1         1         2         3         4         5         6         
//�����������������������������������������������������������Ŀ
//� Inicializa  regua de impressao                            �
//�������������������������������������������������������������

SC1->( dbGoTop() )
SetRegua( Lastrec() )
mPag    := 1
nLin    := 66
SC1->( dbSeek( xFilial( "SC1" ) + mv_par01, .t. ) )

while SC1->( ! eof() ) .and. SC1->C1_NUM <= mv_par02

   #IFNDEF WINDOWS
      IF LastKey()==286
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      Endif
   #ELSE
      IF lAbortPrint
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      Endif
   #ENDIF

   if nLin > 60
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15) + 2 //Impressao do cabecalho
   endif

   if SC1->C1_EMISSAO < mv_par04 .and. SC1->C1_EMISSAO > mv_par05
      SC1->( dbSkip() )
      IncRegua()
      Loop
   endif

   if SC1->C1_QUANT == SC1->C1_QUJE
      SC1->( dbSkip() )
      IncRegua()
      Loop
   endif

   SB1->( dbSeek( xFilial( "SB1" ) + SC1->C1_PRODUTO, .T. ) )
   SA2->( dbSeek( xFilial( "SA2" ) + SC1->C1_FORNECE+SC1->C1_LOJA ) )

   @ nLin,000 pSay SC1->C1_NUM
   @ nLin,007 pSay SC1->C1_ITEM
   @ nLin,010 pSay SC1->C1_PRODUTO
   @ nLin,018 pSay SB1->B1_DESC
   @ nLin,120 pSay SB1->B1_TIPO
   @ nLin,123 pSay SC1->C1_QUANT Picture "@E 999,999.99"
   @ nLin,135 pSay SC1->C1_UM
   @ nLin,138 pSay SC1->C1_CC
   @ nLin,148 pSay SC1->C1_EMISSAO
   @ nLin,157 pSay SC1->C1_DATPRF
   @ nLin,166 pSay SC1->C1_SOLICIT
   @ nLin,177 pSay iif( Empty(SC1->C1_PEDIDO),SC1->C1_COTACAO,SC1->C1_PEDIDO)
   @ nLin,182 pSay SA2->A2_NREDUZ
   @ nLin,211 pSay SC1->C1_QUANT - SC1->C1_QUJE Picture "@E 999,999.99"

   nLin := nLin + 1
   SC1->( dbSkip() )
   IncRegua()

end

Roda(0,"","M")
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif

Return
