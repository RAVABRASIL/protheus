#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO27    � Autor � AP6 IDE            � Data �  04/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GPER002()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Funcionario"
Local cPict          := ""
Local titulo         := "Funcionario"
Local nLin           := 80
                         //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150
                        //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1         := " Mat     Nome                                     Admissao  Funcao             Sexo  Escolaridade                           N Filhos"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "GPER002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GPER002" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

PERGUNTE("GPER002",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"GPER002",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/11/10   ���
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
LOCAL cQry:=''

cQry:="SELECT RA_MAT MAT,RA_NOME NOME,RA_ADMISSA ADMISSAO,RJ_DESC FUNCAO,RA_SEXO SEXO,X5_DESCRI ESCOLAR,  "
cQry+="(SELECT  COUNT(*)  FROM SRB020 SRB  "
cQry+="WHERE  RB_GRAUPAR='F'  "
cQry+="AND RA_MAT=RB_MAT  "
cQry+="AND SRB.D_E_L_E_T_!='*') NFILHOS  "
cQry+="FROM SRA020 SRA,SRJ020 SRJ,SX5020 SX5  "
cQry+="WHERE  "
cQry+="RA_CODFUNC=RJ_FUNCAO  "
cQry+="AND RA_SITFOLH!='D' "
cQry+="AND RA_GRINRAI=X5_CHAVE  "
cQry+="AND X5_TABELA='26' "
cQry+="AND SRA.D_E_L_E_T_!='*' "
cQry+="AND SRJ.D_E_L_E_T_!='*' "
cQry+="AND SX5.D_E_L_E_T_!='*' "

IF MV_PAR01=1
	cQry+="AND (SELECT  COUNT(*)  FROM SRB020 SRB  "
	cQry+="WHERE  RB_GRAUPAR='F'  "
	cQry+="AND RA_MAT=RB_MAT  "
	cQry+="AND SRB.D_E_L_E_T_!='*')>0  "
ELSEIF MV_PAR01=2	
    cQry+="AND (SELECT  COUNT(*)  FROM SRB020 SRB  "
	cQry+="WHERE  RB_GRAUPAR='F'  "
	cQry+="AND RA_MAT=RB_MAT  "
	cQry+="AND SRB.D_E_L_E_T_!='*')=0  "
ENDIF

cQry+="ORDER BY RA_NOME  "
TCQUERY cQry NEW ALIAS "TMP"


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

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

TMP->(dbGoTop())
While TMP->(!EOF())

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
    @nLin,00  PSAY TMP->MAT
    @nLin,08  PSAY TMP->NOME
    @nLin,50  PSAY DTOC(STOD(TMP->ADMISSAO))
    @nLin,60  PSAY TMP->FUNCAO
    @nLin,82  PSAY TMP->SEXO
    @nLin,85  PSAY substr(TMP->ESCOLAR,1,40)
    @nLin,127 PSAY TRANSFORM(TMP->NFILHOS,'@E 99')
    nLin := nLin + 1 // Avanca a linha de impressao

   TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
TMP->(DBCLOSEAREA())
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
