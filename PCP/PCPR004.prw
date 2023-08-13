#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO8     � Autor � AP6 IDE            � Data �  29/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
      
User Function PCPR004()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "MAQUINA-Acompanhamento Grama metro "
Local nLin           := 80
Local Cabec1         := "                   Menor Variacao           Maior Variacao   "
Local Cabec2         := "Periodo  Maq      Gr/m       Largura      Gr/m      Largura     Media Gr/m"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PCPR004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR004" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""

Pergunte("PCPR004",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"PCPR004",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/05/09   ���
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

cQry:="SELECT Z44_MESANO,Z44_MAQ, "
cQry+="MIN(round(((Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)-(Z44_PESO/Z44_METROS))/(Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)*100,2)) AS MINGRA, "
cQry+="MIN(Round((Z44_LARGUR-Z44_MEDIDA)*-1,1))AS MINLARG, "
cQry+="MAX(round(((Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)-(Z44_PESO/Z44_METROS))/(Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)*100,2)) AS MAXGRA, "
cQry+="MAX(Round((Z44_LARGUR-Z44_MEDIDA)*-1,1))AS MAXLARG "
cQry+="FROM "+RetSqlName("Z44")+" Z44  "
cQry+="WHERE Z44_FILIAL='"+xFilial('Z44')+"'  "
cQry+="AND Z44_MESANO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQry+="AND Z44_MAQ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQry+="AND Z44.D_E_L_E_T_!='*' "
cQry+="GROUP BY Z44_MESANO,Z44_MAQ "
cQry+="ORDER BY Z44_MESANO,Z44_MAQ " 

TCQUERY cQry NEW ALIAS "TMPZ"

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

TMPZ->( dbGoTop() )
count to nREGTOT while ! TMPZ->( EoF() )
SetRegua( nREGTOT )
TMPZ->( DBGoTop() )

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������


While TMPZ->( !EOF() )

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
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
        
     @nLin++,00 PSAY  TRANSFORM(TMPZ->Z44_MESANO,"@R ##/####")+SPACE(2)+TMPZ->Z44_MAQ+;
                      SPACE(2)+TRANSFORM(TMPZ->MINGRA,"@E 999,999.99" )+SPACE(2)+;
                      TRANSFORM(TMPZ->MINLARG,"@E 999,999.99" )+SPACE(2)+;
                      TRANSFORM(TMPZ->MAXGRA,"@E 999,999.99" )+SPACE(2)+;
                      TRANSFORM(TMPZ->MAXLARG,"@E 999,999.99" )+SPACE(2)+;
                      TRANSFORM(((TMPZ->MINGRA+TMPZ->MAXGRA)/2),"@E 999,999.99") 
   
     //nLin := nLin + 1 // Avanca a linha de impressao

     TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
     @nLin++,00 PSAY REPL("-",80)
   Enddo
   
TMPZ->( DbCloseArea() )

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
