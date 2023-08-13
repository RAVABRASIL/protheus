#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  31/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATPFNF()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relatorio de todos os pedidos, faturados ou nao."
Local nLin         := 80
                     //          10        20        30        40        50        60        70        80        90        100       110       120       130
					 //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
					 // XXXXXXXXXXXXXXXXXXXXXXXX      999.999.999,99         999.999.999,99
Local Cabec1       := "         FAMILIA          |      KILOGRAMAS       |      REAIS R$      |"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "FATPFNF" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATPFNF" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FATPFN",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  31/07/08   ���
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
Local cQuery := ""
Local nTotRS := 0
Local nTotKG := 0
cQuery += "select sum(C6_QTDVEN/B1_CONV) VALKG,sum(C6_VALOR) VALRS,B1_GRUPO "
cQuery += "from   " + retSqlName("SC6") + " SC6 join " + retSqlName("SB1") + " SB1 on C6_PRODUTO = B1_COD join " + retSqlName("SC5") + " SC5 on SC5.C5_NUM = SC6.C6_NUM "
cQuery += "where  B1_TIPO = 'PA' and len(B1_COD) <= 7 and "
cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' and SC6.C6_FILIAL = '"+xFilial("SC6")+"' and SB1.B1_FILIAL = '"+xFilial("SB1")+"' and "
cQuery += "SC5.C5_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' and "
cQuery += "SC5.D_E_L_E_T_ != '*' and SC6.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "group by B1_GRUPO order by B1_GRUPO "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(7)

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

Do While _TMPK->( !EOF() )

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
   if alltrim(_TMPK->B1_GRUPO ) $ "DE"
      nTotRS += _TMPK->VALRS
      nTotKG += _TMPK->VALKG
   else
	   @nLin,000 PSAY iif( alltrim(_TMPK->B1_GRUPO ) $ "A", "INSTITUCIONAL",;
	   		   		  iif( alltrim(_TMPK->B1_GRUPO ) $ "B", "ABNT",;
	   				  iif( alltrim(_TMPK->B1_GRUPO ) $ "C", "HOSPITALAR",;
	   				  iif( alltrim(_TMPK->B1_GRUPO ) $ "G", "SACOLA",;
	   				  iif( alltrim(_TMPK->B1_GRUPO ) $ "F", "LANCHE", ) ) ) ) )
	   @nLin,031 PSAY transform( _TMPK->VALKG, "@E 999,999,999.99" )
	   @nLin,054 PSAY transform( _TMPK->VALRS, "@E 999,999,999.99" )
	   nLin := nLin + 1 // Avanca a linha de impressao
	   incRegua()
   endIf      
   _TMPK->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo
if nTotKG > 0 .or. nTotRS > 0 
    incRegua()
	@nLin,000 PSAY "DOMESTICA"
	@nLin,031 PSAY transform( nTotKG, "@E 999,999,999.99" )
	@nLin,054 PSAY transform( nTotRS, "@E 999,999,999.99" )
endIf
_TMPK->( dbCloseArea() )
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