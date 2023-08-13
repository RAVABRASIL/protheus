#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO6     � Autor � AP6 IDE            � Data �  04/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GPER001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Demissoes no Periodo"
Local cPict          := ""
Local titulo         := "Demissoes no Periodo"
Local nLin           := 80

Local Cabec1         := "Numero de demitidos  Demitidos com menos de 1 ano  Percentual com menos de 1 ano "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "GPER001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GPER001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("GPER001",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������


wnrel := SetPrint(cString,NomeProg,"GPER001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo:="Demissoes no Periodo "+DTOC(MV_PAR01)+' Ate '+DTOc(MV_PAR02) 

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/06/10   ���
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

cQry:="SELECT COUNT(RA_DEMISSA)QTD_DEMITIDO, "
cQry+="(SELECT COUNT(CAST(CONVERT(smalldatetime,RA_DEMISSA,112)-CONVERT(smalldatetime,RA_ADMISSA,112)AS INT) ) "
cQry+="FROM SRA020 SRA "
cQry+="WHERE RA_FILIAL='"+xFilial('SRA')+"' "
cQry+="AND RA_DEMISSA!='' "
cQry+="AND RA_DEMISSA BETWEEN  '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 	
cQry+="AND CAST(CONVERT(smalldatetime,RA_DEMISSA,112)-CONVERT(smalldatetime,RA_ADMISSA,112)AS INT)<365 "
cQry+="AND SRA.D_E_L_E_T_!='*' "
cQry+=")QTD_MENOSDE1 "
cQry+="FROM SRA020 SRA  "
cQry+="WHERE RA_FILIAL='"+xFilial('SRA')+"' "
cQry+="AND RA_DEMISSA!='' "
cQry+="AND RA_DEMISSA BETWEEN  '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQry+="AND SRA.D_E_L_E_T_!='*' "
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
   
    nPerc:=(TMP->QTD_MENOSDE1/TMP->QTD_DEMITIDO)*100
    @nLin,00 PSAY transform(TMP->QTD_DEMITIDO,"@E 9999" )
    @nLin,21 PSAY transform(TMP->QTD_MENOSDE1,"@E 9999" )
    @nLin,51 PSAY transform(nPerc,"@E 9999.99" )
    
    nLin := nLin + 1 // Avanca a linha de impressao
   IncRegua()
   TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TMP->(dbclosearea())

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
