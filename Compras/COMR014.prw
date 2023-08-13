#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � Romildo Sousa      � Data �  16/07/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMR014()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Produ��o Por Linha"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produ��o Por Linha da data" +  mv_par01 + " at� " + mv_par02
Local nLin           := 80
                     //          10        20        30        40        50       60         70        80        90        100        110
                     //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       := "   N�mero  |  Produto  |                 Descri��o                        |   Quant    |  Emiss�o   |    Solicitante    | Status  |"
Local Cabec2       := "           |           |                                                  |            |            |                   |         |"
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "COMR014" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COMR014" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//dbSelectArea("")
//dbSetOrder(1)

Pergunte("COMR014",.F.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"COMR014",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Relatorio de " +  dtoc(mv_par01) + " at� " + dtoc(mv_par02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/07/13   ���
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
Local cQuery := ''
LOCAL nTOTAL := 0
//Local cCabe1 := "       Linha     |     C�digo      |   Peso   |        Percentual          |"
//Local cCabe2 := "                 |                 |          |                            |"
//Titulo := "Relat�rio Mensal"
/*
cQuery := "SELECT isnull(B1_GRUPO,'') AS GRUPO, "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') " 
cQuery += "THEN 'ROLO' ELSE 'NORMAL' END TIPO, "
cQuery += "ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK) " 
cQuery += "left join SB1010 SB1 WITH (NOLOCK) ON Z00_CODIGO=B1_COD AND SB1.D_E_L_E_T_='' "
cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par02+1 ) +"05:19' "
cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' GROUP BY isnull(B1_GRUPO,''), "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END "
*/

cQuery := "SELECT C1_NUM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_EMISSAO, C1_SOLICIT, C1_PEDIDO, C1_APROV " 
cQuery += "FROM SC1020 WHERE D_E_L_E_T_ = '' AND C1_EMISSAO >= '" + Dtos( mv_par01 )+ "' AND C1_EMISSAO <= '" + Dtos( mv_par02 )+ "' AND C1_RESIDUO <> 'S' "
cQuery += "AND C1_APROV <> 'R' AND C1_FILIAL = '"+ Alltrim(xFilial("SC1")) +"' AND C1_PEDIDO = '' ORDER BY C1_EMISSAO "
MemoWrite("C:\Temp\COMR014.sql", cQuery )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//SetRegua(RecCount())
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

//dbGoTop()
//While !EOF()

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "C1_EMISSAO", "D")

TMP->(DbGoTop()) 
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

 		
   
   @nLin,03 PSAY TMP->C1_NUM
   @nLin,14 PSAY TMP->C1_PRODUTO
   @nLin,25 PSAY TMP->C1_DESCRI
   @nLin,72 PSAY TRANSFORM((TMP->C1_QUANT), "@E 999,999,999.99")
   @nLin,90 PSAY DtoC(TMP->C1_EMISSAO)
   @nLin,105 PSAY TMP->C1_SOLICIT 
   @nLin,126 PSAY TMP->C1_APROV
   nLin := nLin + 1
   nTOTAL += TMP->C1_QUANT
   
incregua()

   TMP->(DbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//TOTAIS
//@nLin+1,48 PSAY "TOTAL ->"
//@nLin+1,58 PSAY transform((nTOTAL), "@E 999,999,999.99") 

TMP->(DbCloseArea())
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
