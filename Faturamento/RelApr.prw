#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  28/12/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelApr


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio - Aprovacao dos Projetos"
Local cPict          := ""
Local titulo       	:= "Relatorio - Aprovacao dos Projetos"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 				:= {}
Local cFiltro
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RelApr" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RelApr" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= ""
Private cQuery			:= ""

//dbSelectArea("")
//dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
pergunte( "RelApr", .T. )
wnrel := SetPrint(cString,NomeProg,"RelApr",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
//                   10        20        30        40        50        60        70        80        90        100       110       120       130       140
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1 := padc("Data de: " + dtoc(MV_PAR01) + "                    Data ate: " + dtoc(MV_PAR02), 132)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/12/07   ���
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

dbGoTop()
While !EOF()

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
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressao
                        
   //-------------------------------------------------------------------------------------------------------------------------------------
	//   Codigo: 012345            |  Descricao:
	//   Lider:  012345678901234   |     0123456789012345678901234567890123456789
	//   Integrantes:
	//      Adriano        /Alexandre      /Bruno          /Info           /Dayanne        /                                                                                                                                                                                
	//-------------------------------------------------------------------------------------------------------------------------------------
   
	//Aprovados
	if (( alltrim(dtos(MV_PAR01)) == "" ) .and. ( alltrim(dtos(MV_PAR02)) == "" ))
		MV_PAR01 := ""
		MV_PAR02 := "ZZZZZZZZ"
	else
		MV_PAR01 := dtos(MV_PAR01)
		MV_PAR02 := dtos(MV_PAR02)
	endIf
	if (( MV_PAR03 == 2 ) .or. ( MV_PAR03 == 1 ))
		@nLin,00 PSAY   padc( "Aprovados", 132 )
		nLin := nLin + 1	
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1		
		cQuery := "select Z11.Z11_PROJET, Z11.Z11_DAPROV, Z11.Z11_SUPERV, Z11.Z11_DESCR "
		cQuery += "from " + RetSqlName( "Z11" ) + " Z11 "
		cQuery += "where Z11_FILIAL = '" + xFilial('Z11') + "' and Z11_DAPROV >= '" + MV_PAR01 + "' and Z11_DAPROV <= '" + MV_PAR02 + "' and Z11_BLOQ = '00'"
   	TCQUERY cQuery NEW ALIAS "Z11X"
   	While (Z11X->( !eof() ))
   		@nLin,00 PSAY   "   Projeto do Projeto: " + Z11X->Z11_PROJET + "      Lider: " + Z11X->Z11_SUPERV
			nLin := nLin + 1	
			@nLin,00 PSAY   "   Descricao: " + Z11X->Z11_DESCR
			nLin := nLin + 2	
			Z11X->( DBSkip() )
		endDo              
		nLin := nLin - 1
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 2
		dbCloseArea( "Z11X" )
  	endIf
  	//Rejeitados
  	if (( MV_PAR03 == 3 ) .or. ( MV_PAR03 == 1 ))
		@nLin,00 PSAY   padc( "Rejeitados", 132 )
		nLin := nLin + 1
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1
		cQuery := "select Z11.Z11_PROJET, Z11.Z11_DAPROV, Z11.Z11_SUPERV, Z11.Z11_DESCR "
		cQuery += "from " + RetSqlName( "Z11" ) + " Z11 "
		cQuery += "where Z11_FILIAL = '" + xFilial('Z11') + "' and Z11_DAPROV >= '" + MV_PAR01 + "' and Z11_DAPROV <= '" + MV_PAR02 + "' and Z11_BLOQ = '02'"
   	TCQUERY cQuery NEW ALIAS "Z11X"
   	While (Z11X->( !eof() ))
   		@nLin,00 PSAY   "   Projeto do Projeto: " + Z11X->Z11_PROJET + "      Lider: " + Z11X->Z11_SUPERV
			nLin := nLin + 1	
			@nLin,00 PSAY   "   Descricao: " + Z11X->Z11_DESCR
			nLin := nLin + 2	
			Z11X->( DBSkip() )
		endDo
		nLin := nLin - 1
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 2
		dbCloseArea( "Z11X" )
  	endIf
  	//Pendentes
  	if (( MV_PAR03 == 4 ) .or. ( MV_PAR03 == 1 ))
		@nLin,00 PSAY   padc( "Pendentes", 132 )
		nLin := nLin + 1
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1
		cQuery := "select Z11.Z11_PROJET, Z11.Z11_DAPROV, Z11.Z11_SUPERV, Z11.Z11_DESCR "
		cQuery += "from " + RetSqlName( "Z11" ) + " Z11 "
		cQuery += "where Z11_FILIAL = '" + xFilial('Z11') + "' and Z11_DAPROV >= '" + MV_PAR01 + "' and Z11_DAPROV <= '" + MV_PAR02 + "' and Z11_BLOQ = '99'"
   	TCQUERY cQuery NEW ALIAS "Z11X"
		While (Z11X->( !eof() ))
      	@nLin,00 PSAY   "   Projeto do Projeto: " + Z11X->Z11_PROJET + "      Lider: " + Z11X->Z11_SUPERV
			nLin := nLin + 1	
			@nLin,00 PSAY   "   Descricao: " + Z11X->Z11_DESCR
			nLin := nLin + 2
			Z11X->( DBSkip() )
		endDo              		
		nLin := nLin - 1
		@nLin,00 PSAY   "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1
		dbCloseArea( "Z11X" )
  	endIf
   
  // dbSkip() // Avanca o ponteiro do registro no arquivo
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
