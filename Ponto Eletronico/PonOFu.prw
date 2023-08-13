#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  04/09/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PONOFU()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ocorrencia(s) de Funcionario"
Local cPict          := ""
Local titulo         := "Ocorrencias de Funcionario de: "
Local nLin           := 80

Local Cabec1         := "Matric | Funcionario | "
Local Cabec2         := "Data     | Tipo      | Descricao  "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "OCOFUN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "OCOFUN" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//dbSelectArea("")
//dbSetOrder(1)
Pergunte("OCOFUN",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"OCOFUN",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo:="Ocorrencias de Funcionario de: "+alltrim(dtoc(mv_par01))+" Ate: "+dtoc(mv_par02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/09/08   ���
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
Local cQuery:=" " 


//dbSelectArea(cString)
//dbSetOrder(1)

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


cQuery :="SELECT RA_MAT,RA_NOME,Z05_TIPO,Z05_DATA,Z05_OBS  "
cQuery +="FROM SRA020 SRA JOIN Z05020 Z05 ON SRA.RA_MAT=Z05.Z05_MATRIC AND SRA.D_E_L_E_T_=Z05.D_E_L_E_T_ "
cQuery +="WHERE  SRA.D_E_L_E_T_!='*'AND Z05_DATA between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
cQuery +="ORDER BY  RA_NOME,Z05_DATA "  //"ORDER BY  RA_MAT,Z05_DATA " CHAMADO 001025

TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z05_DATA",  "D", 8, 0 )


//dbGoTop()

While AUUX->(!EOF())

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
   // @nLin,00 PSAY SA1->A1_COD

   cMatri:=AUUX->RA_MAT
   @nLin,00 PSAY AUUX->RA_MAT      // MATRICULA 
   @nLin++,09 PSAY AUUX->RA_NOME  // FUNCIONARIO 
   @nLin++
   
   lOk:=.F. 
   WHILE AUUX->(!EOF()).AND. AUUX->RA_MAT=cMatri
   lOk:=.T.
   aDesc :={}
   
   iif(len( alltrim(AUUX->Z05_OBS))>=110,aDesc := wordWrap( ALLTRIM(AUUX->Z05_OBS),110 ),aDesc := wordWrap( ALLTRIM(AUUX->Z05_OBS), LEN(ALLTRIM(AUUX->Z05_OBS)) ) )
   
   @nLin,00 PSAY Dtoc(AUUX->Z05_DATA)  // DATA DA INFRACAO 
   @nLin,11 PSAY AUUX->Z05_TIPO        // TIPO DA INFRACAO 
    
   for x := 1 to len( aDesc )
   @nLin++,23 PSAY aDesc[x][1]      //  DESCRICAO DA INFRACAO 
   next
   
   IF empty(aDesc)
   @nLin++
   ENDIF
   
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 09
   Endif
   
   AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   incRegua()
   ENDDO
   
   @nLin++,00 PSAY REPLICATE("-",132)
   
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 09
   Endif 
   
   IF !lOk
   AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndIf
   
   //nLin := nLin + 1 // Avanca a linha de impressao
   incRegua()

EndDo
AUUX->(DBCloseArea("AUUX"))

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

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet




