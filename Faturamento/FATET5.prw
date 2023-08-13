#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  21/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATET5()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Media de Preco - Etapa 5"
Local cPict          := ""
Local titulo       	 := "Media de Preco - Etapa 5"
Local nLin         	 := 80
					   //01234567890123456789012345678901234567890123456789012345678901234567890123456789
					   //          10        20        30        40        50        60        70
					   //XXXXXXXXXXXXXXX  999.999.999,99   999,99
Local Cabec1       	 := "     Produto              Media   Margem"
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "FATET5" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "FATET5" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Pergunte( "FATET1", .T. )
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FATET1",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/10/08   ���
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
Local cQuery  := ""
Local nMedia  := nFator := 0
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
cQuery := "select distinct Z30_PRODUT "
cQuery += "from "+retSqlName('Z30')+" "
cQuery += "where Z30_CODPES = '"+mv_par02+"' "
cQuery += "and Z30_FILIAL = '"+xFilial('Z30')+"' and D_E_L_E_T_ != '*' "
cQuery += "order by Z30_PRODUT"
TCQUERY cQuery NEW ALIAS "_TMPR"
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

_TMPR->( dbGoTop() )
While _TMPR->( !EoF() )

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
 //01234567890123456789012345678901234567890123456789012345678901234567890123456789
 //          10        20        30        40        50        60        70
 //XXXXXXXXXXXXXXX  999.999.999,99   999,99
//"    Produto               Media   Margem"

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   nMedia := Media( _TMPR->Z30_PRODUT )
   nFator := nMedia / ( ( 1000 / posicione("SB5",1,xFilial("SB5")+_TMPR->Z30_PRODUT, "B5_QE2") );
 		            / posicione("SB1",1,xFilial("SB1")+_TMPR->Z30_PRODUT, "B1_CONV") )
   @nLin,00 PSAY _TMPR->Z30_PRODUT
   @nLin,17 PSAY transform( nMedia, "@E 999,999,999.99" )
   @nLin,34 PSAY transform( ( (nFator/mv_par01 ) * 100 ) - 100, "@E 999.99" )	              
   nLin := nLin + 1 // Avanca a linha de impressao
   incRegua()
   _TMPR->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo
_TMPR->( dbCloseArea() )
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

***************

Static Function Media( cProduto )

***************
Local nUltimo:= nCount := nMedia := 0
Local cQuery := ""
cQuery := "select Z30_VALOR / ( 1 + ( Z30_IPI/100 ) ) VALOR "
cQuery += "from "+retSqlName('Z30')+" "
cQuery += "where Z30_PRODUT = '"+cProduto+"' and Z30_CODPES = '"+mv_par02+"' "
cQuery += "and Z30_FILIAL = '"+xFilial('Z30')+"' and D_E_L_E_T_ != '*' "
cQuery += "order by VALOR desc "
TCQUERY cQuery NEW ALIAS "_TMPF"

_TMPF->( dbGoTop() )
do while _TMPF->( !EoF() )
	_TMPF->( dbSkip() )
	nCount++
endDo
_TMPF->( dbGoTop() )
if nCount > 4
	_TMPF->( dbSkip() )
endIf
do While _TMPF->( !EoF() )
	nMedia  += _TMPF->VALOR
	nUltimo := _TMPF->VALOR
	_TMPF->( dbSkip() )
endDo
if nCount > 4
	nMedia -= nUltimo
	nMedia := nMedia/(nCount - 2)
else
	nMedia := nMedia/nCount
endIf
_TMPF->( dbCloseArea() )

Return nMedia