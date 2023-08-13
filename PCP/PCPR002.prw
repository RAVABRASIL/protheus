#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  21/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR002()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Acompanhamento Grama metro-"+TRANSFORM(Z44->Z44_MESANO,"@R ##/####")
Local nLin           := 80

Local Cabec1         := "Maq  Extrusor                           Metros      Peso   Dia  OP      Produto             Dendidade      Largura    Espess.   Medida     Erro(Cm)      %         Prog       Calc        Real      % de Erro "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR002" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/05/09   ���
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
Local cQry :=''
lOCAL nCalc:=nReal:=0
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

cQry :="SELECT Z44_MESANO,Z44_MAQ,Z44_EXTRUS,Z44_METROS,Z44_PESO,Z44_DIA,Z44_OP,Z44_PROD,Z44_DENSID,Z44_LARGUR,Z44_ESPESS, "
cQry +="Z44_MEDIDA,round((Z44_LARGUR-Z44_MEDIDA)*-1,1) AS Z44_ERRO,round(((-(Z44_LARGUR-Z44_MEDIDA)*-1)/Z44_LARGUR)*100,2) AS Z44_PER, "
cQry +="Z44_PROG,round(Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100,2) AS Z44_CALC,round(Z44_PESO/Z44_METROS,2) AS Z44_REAL, "
cQry +="round(((Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)-(Z44_PESO/Z44_METROS))/(Z44_LARGUR*Z44_ESPESS/10000*Z44_DENSID*100)*100,2 )AS Z44_PERERR "
cQry +="FROM "+RetSqlName("Z44")+" Z44 "
cQry +="WHERE Z44_FILIAL='"+xFilial('Z44')+"' AND Z44.D_E_L_E_T_!='*'  "
cQry +="AND Z44_MESANO='"+Z44->Z44_MESANO+"' " 

TCQUERY cQry NEW ALIAS "TMPZ"

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


While TMPZ->(!EOF())

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
   
    @nLin,00 PSAY TMPZ->Z44_MAQ+SPACE(2)+substr(Posicione('SRA',1,xFilial("SRA")+TMPZ->Z44_EXTRUS,"RA_NOME"),1,30)+space(2)+TRANSFORM(TMPZ->Z44_METROS,"@E 999,999.99")+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_PESO,"@E 999,999.99")+SPACE(2)+TMPZ->Z44_DIA+SPACE(2)+TMPZ->Z44_OP+SPACE(2)+TMPZ->Z44_PROD+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_DENSID,"@E 999,999.9999")+SPACE(2)+TRANSFORM(TMPZ->Z44_LARGUR,"@E 999,999.99")+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_ESPESS,"@E 999,999")+SPACE(2)+TRANSFORM(TMPZ->Z44_MEDIDA,"@E 999,999.9")+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_ERRO,"@E 999,999.9")+SPACE(2)+TRANSFORM(TMPZ->Z44_PER,"@E 999,999.99")+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_PROG,"@E 999,999.9")+SPACE(2)+TRANSFORM(TMPZ->Z44_CALC,"@E 999,999.99")+;
                  SPACE(2)+TRANSFORM(TMPZ->Z44_REAL,"@E 999,999.99")+SPACE(2)+TRANSFORM(TMPZ->Z44_PERERR,"@E 999,999.99")

   nCalc+=TMPZ->Z44_CALC
   nReal+=TMPZ->Z44_REAL
   nLin := nLin + 1 // Avanca a linha de impressao
   TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
@nLin++,00 PSAY  replicate("-",220)
@nLin++,00 PSAY "Total Calc: "+TRANSFORM(nCalc,"@E 999,999.99")
@nLin++,00 PSAY "Total Real: "+TRANSFORM(nReal,"@E 999,999.99")
TMPZ->( dbCloseArea() )

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
