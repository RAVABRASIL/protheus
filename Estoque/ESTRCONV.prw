#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � AP6 IDE            � Data �  11/09/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************

User Function ESTRCONV()

*************


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de transforma��es"
Local cPict          := ""
Local titulo         := "Relat�rio de transforma��es"
Local nLin           := 80
Local Cabec1         := " Cod. Barra  |Cod. Transf.|  Produto  | Quantidade | Tipo Trnsf. |   Data   |"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "ESTRCONV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTRCONV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Private cPerg		 := "ESTRCV"

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

Pergunte(cPerg,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  11/09/07   ���
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

Local nOrdem := 0
Local cQuery := ""
Local nLin := 8

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua( RecCount() )

cQuery += "select * "
cQuery += "from	" + retSqlName("Z00") + " "
cQuery += "where Z00_CDBRNV != '' and Z00_DATCON between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
cQuery += "and Z00_STATUS in ('F','S') "
cQuery += "and Z00_CODIGO between '"+alltrim(mv_par03)+"' and '"+alltrim(mv_par04)+"' and D_E_L_E_T_ != '*' "
cQuery += "order by Z00_CDBRNV "
TCQUERY cQuery NEW ALIAS "ALX"
TCSetField( 'ALX', "Z00_DATCON", "D")
ALX->( dbGoTop() )

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
//" Cod. Barra  |Cod. Transf.|  Produto  | Quantidade | Tipo Trnsf. |   Data   |"
//        10        20        30        40        50        60        70        80
//123457890123456789012345678901234567890123456789012345678901234567890123456789012
cCod := ALX->Z00_CDBRNV
do While ! ALX->( EOF() )

  If lAbortPrint
     @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
     Exit
  Endif

  If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 8
  Endif

  @nLin,001 PSAY alltrim( ALX->Z00_CODBAR )
  @nLin,017 PSAY alltrim( ALX->Z00_CDBRNV )
  @nLin,029 PSAY alltrim( ALX->Z00_CODIGO )
  @nLin,042 PSAY transform( ALX->Z00_QUANT, "@E 9,999.99" )
  @nLin,055 PSAY iif( substr(ALX->Z00_CODBAR,1,6) == "999999", "Criado", "Amostra" )
  @nLin,068 PSAY ALX->Z00_DATCON
  nLin := nLin + 1 // Avanca a linha de impressao
  ALX->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
  if cCod != ALX->Z00_CDBRNV
    nLin++
  endIf
  cCod := ALX->Z00_CDBRNV
  incRegua()                                                                      
  
EndDo
ALX->( dbCloseArea() )
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