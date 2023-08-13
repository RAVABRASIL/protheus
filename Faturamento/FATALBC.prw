#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATALBC   � Autor � AP6 IDE            � Data �  23/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de analise de libera��o ou bloqueio de cr�dito.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*************

User Function FATALBC()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio p/ an�lise de libera��o/bloqueio de cr�dito."
Local cPict          := ""
Local titulo       	 := "Relat�rio p/ an�lise de libera��o/bloqueio de cr�dito."
Local nLin         	 := 80
Local Cabec1       	 := "| Numero do |        Nome do        | Data de Entrada | Data de Liberacao |   Intervalo Entre    |     Situacao do    |"
Local Cabec2       	 := "|  Pedido   |        Cliente        |    do Pedido    |    ou Bloqueio    | a Liberacao/Bloqueio |       Pedido       |"
                       //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
                       //          10        20        30        40        50        60        70        80        90        100       110
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATALBC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "FATALBC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FATALB",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
pergunte("FATALB",.F.)
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  23/10/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local nOrdem
Local cQuery := ''
cQuery += "select DISTINCT C5_NUM, A1_NREDUZ, C5_EMISSAO, C9_DATALIB, C9_BLCRED, C9_BLEST, "
cQuery += "( case "
cQuery += "  when   ( (SC9.C9_BLCRED = '10' and SC9.C9_BLEST = '10') OR (SC9.C9_BLCRED = 'ZZ' and SC9.C9_BLEST = 'ZZ') ) "
cQuery += "  then   'LIBERADO' "
cQuery += "  when   SC9.C9_BLCRED  != '  ' and SC9.C9_BLEST != '09'  AND SC9.C9_BLCRED != '10' and SC9.C9_BLEST != 'ZZ' "
cQuery += "  then   'BLOQUEADO CREDITO' "
cQuery += "  when   SC9.C9_BLCRED = '09' "
cQuery += "  then   'REJEITADO' "
cQuery += "  when   SC9.C9_BLCRED IN( '  ','04') "
cQuery += "  then   'LIBERADO' "
cQuery += "  else   'NAO DEFINIDO' "
cQuery += "  end) as   SITUACAO "
cQuery += "from   "+retSqlName('SC9')+" SC9, "+retSqlName('SC5')+" SC5, "+retSqlName('SA1')+" SA1 "
cQuery += "where  SC9.C9_FILIAL   = '"+xFilial('SC9')+"' AND SC5.C5_FILIAL   = '"+xFilial('SC5')+"' AND SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND "
cQuery += "       SC5.C5_NUM = SC9.C9_PEDIDO AND SC5.C5_CLIENTE = SA1.A1_COD AND "
cQuery += "       SA1.A1_COD between '" + mv_par01 + "' and '" + mv_par02 + "' AND "
cQuery += "       SC5.C5_EMISSAO between '" + dtos(mv_par03) + "' and '" + dtos(mv_par04) + "' AND "
cQuery += "       SC5.D_E_L_E_T_ !=  '*' AND SC9.D_E_L_E_T_ !=  '*' AND SA1.D_E_L_E_T_ != '*' "
cQuery += "order by C5_EMISSAO, C5_NUM asc "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
TCSetField('TMP',"C5_EMISSAO",'D')
TCSetField('TMP',"C9_DATALIB",'D')

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
While ! TMP->( EOF() )

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
//| Numero do |        Nome do        | Data de Entrada | Data de Liberacao |   Intervalo Entre    |     Situacao do    |"
//|  Pedido   |        Cliente        |    do Pedido    |    ou Bloqueio    | a Liberacao/Bloqueio |       Pedido       |"
//  XXXXXXXXX   XXXXXXXXXXXXXXXXXXXXX      XX/XX/XX           XX/XX/XX              X  Dia(s)         BLOQUEADO CREDITO
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          10        20        30        40        50        60        70        80        90        100       110

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   //cQuery += "select DISTINCT C5_NUM, A1_NREDUZ, C5_EMISSAO, C9_DATALIB, C9_BLCRED, C9_BLEST, SITUACAO "
   @nLin,002 PSAY TMP->C5_NUM
   @nLin,015 PSAY TMP->A1_NREDUZ
   @nLin,041 PSAY TMP->C5_EMISSAO
   @nLin,060 PSAY TMP->C9_DATALIB
   @nLin,082 PSAY alltrim(str(TMP->C9_DATALIB - TMP->C5_EMISSAO)) + " dia(s)"
   @nLin,iif(len(alltrim(TMP->SITUACAO)) > 9,100,105) PSAY TMP->SITUACAO
   nLin := nLin + 1 // Avanca a linha de impressao

   TMP->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

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