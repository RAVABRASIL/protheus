#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  06/11/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATPVD1()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio  "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := ""
Local nLin           := 80
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                       //          10        20        30        40        50        60        70        80        90
                       //XXXXXXXXXXX      99/99/99            99/99/99            99/99/99      TRANSPORTADORA COMETA   
Local Cabec1         := "NOTA FISCAL | DATA DO PEDIDO | DATA DE FATURAMENTO |      PREVISAO      |   DATA DE CHEGADA  |  ATRASO  | TRANSPORTADORA    "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATPVD1" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATPVD1" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""
Pergunte("FATPVD",.T.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FATPVD",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  06/11/08   ���
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
Local cQuery := ""
Local cAnt := ""
Local lOk:=.F.
Local nDif:=0
cQuery := "select distinct C5_NOTA, C5_ENTREG, F2_EMISSAO, Z04_PRAZO,Z04_DATCHE,F2_TRANSP,F2_CLIENTE  "
cQuery += "from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4, "+retSqlName("SC5")+" SC5, "+retSqlName("Z04")+" Z04 "
cQuery += "where F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '"+xFilial('SD1')+"' and F4_FILIAL = '"+xFilial('SF4')+"' and C5_FILIAL = '"+xFilial('SC5')+"' and Z04_FILIAL = '"+xFilial('Z04')+"' "
//cQuery += "and F2_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
cQuery += "and F2_CLIENTE between'"+mv_par01+"'and '"+mv_par02+"'
cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and C5_NOTA = F2_DOC and Z04_DOC = F2_DOC "
cQuery += "and F4_DUPLIC = 'S' and F2_TIPO = 'N' AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and Z04.D_E_L_E_T_ != '*' "
cQuery += "order by F2_CLIENTE,C5_NOTA "
TCQUERY cQuery NEW ALIAS "_TMPZ"
TCSetField( "_TMPZ", "Z04_PRAZO",  "D", 8, 0 )
TCSetField( "_TMPZ", "Z04_DATCHE",  "D", 8, 0 )	



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

_TMPZ->( dbGoTop() )
While _TMPZ->( !EoF() )

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
 //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 //          10        20        30        40        50        60        70        80        90
 //XXXXXXXXXXX      99/99/99            99/99/99            99/99/99      TRANSPORTADORA COMETA   
 //NOTA FISCAL | DATA DO PEDIDO | DATA DE FATURAMENTO | DATA DE CHEGADA |    TRANSPORTADORA    |"
 //cQuery := "select distinct C5_NOTA, C5_ENTREG, F2_EMISSAO, Z04_DATCHE  "
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   cAnt :=_TMPZ->F2_CLIENTE
   While _TMPZ->( !EoF() ).AND.cAnt =_TMPZ->F2_CLIENTE
     If lOk=.F.
      @nLin++,00 PSAY "Cliente: " +POSICIONE("SA1", 1, xFilial("SA1") +_TMPZ->F2_CLIENTE , "A1_NOME" )
      @nLin++
      lOk:=.T.
     EndIF
     @nLin,00 PSAY alltrim(_TMPZ->C5_NOTA)
     @nLin,18 PSAY stod(_TMPZ->C5_ENTREG )
     @nLin,37 PSAY stod(_TMPZ->F2_EMISSAO)
     @nLin,57 PSAY DTOC(_TMPZ->Z04_PRAZO)
     @nLin,77 PSAY DTOC(_TMPZ->Z04_DATCHE)
     nDif:=_TMPZ->Z04_DATCHE - _TMPZ->Z04_PRAZO  
     @nLin,97 PSAY alltrim(str(nDif))
     @nLin,107 PSAY POSICIONE("SA4", 1, xFilial("SA4") +_TMPZ->F2_TRANSP , "A4_NOME" )
   
     incRegua()
     nLin := nLin + 1 // Avanca a linha de impressao
     _TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
   EndDo
   nLin++
   @nLin++,00 PSAY REPLICATE("-",132)
   nLin++
   lOk:=.F.
EndDo
_TMPZ->( dbCloseArea() )
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