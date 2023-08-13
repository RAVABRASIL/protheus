#INCLUDE "rwmake.ch"
//#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  27/11/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTTRAR( )


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Solicitacao de Transformacoes"
Local cPict          := ""
Local titulo         := "Solicitacao de Transformacoes"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "ESTTRANS" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTTRANS" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "Z10"

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
//                        10        20        30        40        50        60        70        80        90        100       110       120       130       140
//              012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//					  Solicitacao | Transformar o Produto: 012345678912345  Quantidade: 01234567891234567 UM               |  Solicitado em:
//					    000005    | No Produto:            012345678912345  Quantidade: 01234567891234567 UM               | 99/99/999 99:99
Cabec1 := "   Solicitacao   |   Transformar o Produto: " + Z10->Z10_PRDINI + "    Quantidade: " + transform( "@E 999,999.99" , str( Z10->Z10_QTINI ) ) + " " + Z10_UMINI + "               |   Solicitado em:"
Cabec2 := "     " + Z10->Z10_CODIGO + "      |   No Produto:            " + Z10->Z10_PRDFIN + "    Quantidade: " + transform( "@E 999,999.99", str( Z10->Z10_QTFIN ) ) + " " + Z10_UMFIN + "               |   " + dtoc(Z10->Z10_DATA) + " " + Z10->Z10_HORA
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  27/11/07   ���
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
Local x

//dbSelectArea(cString)
//dbSetOrder(1)

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

//dbGoTop()
//for x:=1 to 10//While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

//   If lAbortPrint
//      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
//      Exit
//   Endif 

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
//           10        20        30        40        50        60        70        80        90        100       110       120       130  
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
// |     Data  Inicio     |     Hora  Inicio     |     Total  Transformado     |     Hora  Termino     |     Executado  Para     |"
// -------------------------------------------------------------------------------------------------------------------------------
	nLin := nLin + 1                                                                                  
	@nLin,00 PSAY replicate("-", 132)
	nLin := nLin + 1	
	@nLin,00 PSAY padc("      Data  Inicio     |     Hora  Inicio     |     Total  Transformado     |     Hora  Termino     |     Executado  Para     |", 132)
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin,00 PSAY replicate("-", 132)
	nLin := nLin + 1

   for x := 1 to 10
	   @nLin,00 PSAY padc("                       |                      |                             |                       |                         |", 132)
   	nLin := nLin + 1
		@nLin,00 PSAY replicate("-", 132)
   	nLin := nLin + 1 // Avanca a linha de impressao
   next

   @nLin++,00 PSAY "    Obs.: " 
   cTemp := Z10->Z10_OBS
   aRet := quebra ( cTemp )
   for t := 1 to len(aRet)
		@nLin++,00 PSAY aRet[t][1]//quebra ( cTemp )
	next
//   @nLin++,00 PSAY quebra( cTemp )
	@nLin,00 PSAY replicate("-", 132)
  	nLin := nLin + 1
  	//                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234                                                                                                                                          
   @nLin,00 PSAY "    Solicitado por: " + Z10->Z10_USUARI
  	nLin := nLin + 1
	@nLin,00 PSAY replicate("-", 132)

   //dbSkip() // Avanca o ponteiro do registro no arquivo
//END//EndDo

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

Static Function quebra( cMem )

***************

Local aRet 	 := {}
Local x 		 := 1
Local nIni	 := 1
Local nFim := 132
//cMem := strtran( cMem, chr(13), ' ')
//cMem := strtran( cMem, chr(10), ' ')
if len(cMem) > 132
	for x := 1 to len(cMem)
		aAdd( aRet, { substr(cMem, x, nFim) } )
		if nFim + 132 < len(cMem)
			x	  += 131
		else
			nFim := len(cMem) - 132
			x	  += 131
		endIf
	next
else
	aAdd( aRet, { substr( cMem, nIni, nFim ) } )
endIf

return aRet
