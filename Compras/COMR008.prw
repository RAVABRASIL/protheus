#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  25/01/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMR008()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Solicitacao de Compra para Projetos"
Local cPict          := ""
Local titulo         := "Solicitacao de Compra para Projetos"
Local nLin           := 80
//17,69,74,90                      10        20        30        40        50        60        70        80        90         100
                       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1         := "Codigo           Descricao                                           UM   QTD             Dt.Nec    OBS"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "COMR008" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR008" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("COMR008",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"COMR008",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  25/01/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

cQry:="SELECT C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_PRODUTO,C1_DESCRI,C1_UM,C1_QUANT,C1_DATPRF,C1_OBS,C1_PROSIGA,C1_USER "
cQry+="FROM SC1020 SC1 " 
cQry+="WHERE 
cQry+="C1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQry+="AND C1_DATPRF BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQry+="AND C1_NUM BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'"
cQry+="AND C1_USER BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"'"

IF MV_PAR09=1
   cQry+="AND C1_PROSIGA='S' "
ELSEIF MV_PAR09=2
   cQry+="AND C1_PROSIGA!='S' "
ENDIF
cQry+="AND SC1.D_E_L_E_T_!='*' "
cQry+="ORDER BY C1_NUM  "
TCQUERY cQry NEW ALIAS "TMP1"
TCSetField( "TMP1", "C1_EMISSAO", "D")
TCSetField( "TMP1", "C1_DATPRF", "D")

SetRegua(0)

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

TMP1->(dbGoTop())
While TMP1->(!EOF())

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   cNum:=TMP1->C1_NUM 
   @nLin++,00 PSAY "Numero: "+TMP1->C1_NUM+SPACE(2)+"Data Emissao: "+DTOC(TMP1->C1_EMISSAO)+space(2)+"Para Projeto: "+IIF(TMP1->C1_PROSIGA!='S','Nao','Sim')
   @nLin++,00 PSAY "Solicitante: "+alltrim(U_NomeSoli(TMP1->C1_USER))
   Do While TMP1->(!EOF()) .AND. TMP1->C1_NUM=cNum
      @nLin,00 PSAY TMP1->C1_PRODUTO
      @nLin,17 PSAY TMP1->C1_DESCRI
      @nLin,69 PSAY TMP1->C1_UM
      @nLin,74 PSAY TRANSFORM(TMP1->C1_QUANT,"@E 999,999,999.99" )
      @nLin,90 PSAY DTOC(TMP1->C1_DATPRF)
      @nLin++,100 PSAY TMP1->C1_OBS
      TMP1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
      @nLin++,00 PSAY   replicate("-",220)
EndDo

TMP1->(DBCLOSEAREA())


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
