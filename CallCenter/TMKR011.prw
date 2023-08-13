#include "rwmake.ch"
#INCLUDE "Topconn.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO45    � Autor � AP6 IDE            � Data �  30/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TMKR011()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Quantidade Entrega X Transportadora"
Local cPict          := ""
Local titulo         := "Quantidade de Entregas X Transportadora"
Local nLin           := 80

                        //         10        20        30        40        50        60        70        80        90        100
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Codigo   Transportadora                                  %"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "TMKR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TMKR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('TMKR011',.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"TMKR011",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo := "Quant. de Entregas X Transportadora Data de: "+dtoc(MV_PAR03)+' Data Ate: '+dtoc(MV_PAR04)  

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  30/05/12   ���
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
local cQry:=''
local nTotal:=0

cQry:="SELECT F2_TRANSP, "
cQry+="COUNT(*) QTDE  "
cQry+=" FROM  SUD020 SUD,SUC020 SUC,SF2020 SF2  "
cQry+=" where "
cQry+="UC_CODIGO = UD_CODIGO "
cQry+="AND UC_FILIAL = UD_FILIAL "
cQry+="AND F2_DOC = UC_NFISCAL "
cQry+="AND F2_FILIAL = UC_FILIAL  "
cQry+="AND F2_SERIE = UC_SERINF  "
cQry+="AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQry+="AND  UD_DTINCLU BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
cQry+="AND UD_N2='0002' " // LOGISTICA 
cQry+="AND UD_N3='0004' " // ENTREGA
cQry+="AND RTRIM(UD_OPERADO) <> ''  "
cQry+="AND SUD.D_E_L_E_T_ = '' "  
cQry+="AND SUC.D_E_L_E_T_ = '' "
cQry+="GROUP BY F2_TRANSP "
cQry+="ORDER BY F2_TRANSP "

TCQUERY cQry NEW ALIAS 'TMPX'

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

TMPX->(dbGoTop())
nTotal:=TOTAL()
nLin := 8
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
@nLin++,00 PSAY " Quantidade de Entregas :" + alltrim(str(nTotal))
@nLin++

While TMPX->(!EOF())

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
   @nLin,00 PSAY TMPX->F2_TRANSP+' - '+ posicione("SA4",1,xFilial('SA4') +TMPX->F2_TRANSP ,"A4_NOME" )  
   @nLin,55 PSAY TRANSFORM((TMPX->QTDE/nTotal)*100,'@E 999.99')+' ( '+alltrim(str(TMPX->QTDE))+' ) '
   
   nLin := nLin + 1 // Avanca a linha de impressao
   INCREGUA()
   TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TMPX->(DBCLOSEAREA())

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

Static Function  TOTAL()

***************

local cQry:=''
Local nRet:=0

cQry:="SELECT "
cQry+="COUNT(*) QTDE  "
cQry+=" FROM  SUD020 SUD,SUC020 SUC,SF2020 SF2  "
cQry+=" where "
cQry+="UC_CODIGO = UD_CODIGO "
cQry+="AND UC_FILIAL = UD_FILIAL "
cQry+="AND F2_DOC = UC_NFISCAL "
cQry+="AND F2_FILIAL = UC_FILIAL  "
cQry+="AND F2_SERIE = UC_SERINF  "
cQry+="AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQry+="AND  UD_DTINCLU BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
cQry+="AND UD_N2='0002' " // LOGISTICA 
cQry+="AND UD_N3='0004' " // ENTREGA
cQry+="AND RTRIM(UD_OPERADO) <> ''  "
cQry+="AND SUD.D_E_L_E_T_ = '' "  
cQry+="AND SUC.D_E_L_E_T_ = '' "

TCQUERY cQry NEW ALIAS 'TMPY'

If TMPY->(!EOF())
   nRet:=TMPY->QTDE
Endif

TMPY->(dbclosearea())

Return nRet