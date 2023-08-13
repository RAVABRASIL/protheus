#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO51    � Autor � AP6 IDE            � Data �  20/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMR012()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "% FRETE "
Local cPict          := ""
Local titulo         := "% FRETE "
Local nLin           := 80

Local Cabec1         := "Nf Origem  Valor       Nf Frete    Valor Frete   %    Fornecedor "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "COMR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR012" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

PERGUNTE('COMR012',.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"COMR012",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo:=alltrim(titulo)+SPACE(2)+"DE: "+DTOC(MV_PAR01)+" ATE: "+DTOC(MV_PAR02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  20/06/13   ���
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
Local cQry:=''
local nValor:=nVFrete:=nPerc:=0

cQry:="SELECT  "
cQry+="F1_DOC,F1_VALMERC,F8_FORNECE,F8_LOJA, "
cQry+="F8_NFDIFRE,F8_SEDIFRE,F8_TRANSP,F8_LOJTRAN, "
cQry+="VALOR_FRETE=(SELECT  "
cQry+="SUM(D1_TOTAL) "
cQry+="FROM SD1020 XX   "
cQry+="WHERE  "
cQry+="XX.D1_DTDIGIT =F8_DTDIGIT  "
cQry+="AND  XX.D1_TIPO='C'  "
cQry+="AND XX.D1_DOC=F8_NFDIFRE  "
cQry+="AND XX.D1_SERIE=F8_SEDIFRE "
cQry+="AND XX.D1_FORNECE=F8_TRANSP "
cQry+="AND XX.D1_LOJA=F8_LOJTRAN "
cQry+="AND  XX.D_E_L_E_T_=''  "
cQry+=") "
cQry+="FROM SF1020 SF1,SF8020 SF8 "
cQry+="WHERE  "
cQry+="F1_FILIAL='"+XFILIAL('SF1')+"' "
cQry+="AND F1_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "

IF !EMPTY(MV_PAR03)
   cQry+="AND F1_FORNECE = '"+(MV_PAR03)+"' "
ENDIF

IF !EMPTY(MV_PAR04)
   cQry+="AND F1_LOJA= '"+(MV_PAR04)+"'  "
ENDIF

cQry+="AND F1_TIPO='N'  "
cQry+="AND F1_DOC=F8_NFORIG  "
cQry+="AND F1_SERIE=F8_SERORIG  "
cQry+="AND F1_FORNECE=F8_FORNECE "
cQry+="AND F1_LOJA=F8_LOJA  "
cQry+="AND SF1.D_E_L_E_T_='' "
cQry+="AND SF8.D_E_L_E_T_='' "


If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf
	
TCQUERY cQry NEW ALIAS "TMPX"


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

If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif


IF !EMPTY(MV_PAR03)
   @nLin++,00 PSAY "Fornecedor: "+ALLTRIM(MV_PAR03)+' '+POSICIONE("SA2", 1, xFilial("SA2") + MV_PAR03, "A2_NOME" ) 
   @nLin++,00 PSAY IIF(!EMPTY(MV_PAR04),'Lola: '+MV_PAR04,'')
ENDIF

TMPX->(dbGoTop())
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
    IF MV_PAR05=1 // DETALHADO - SIM 
       nPerc:= (TMPX->VALOR_FRETE /TMPX->F1_VALMERC )* 100
       @nLin++,00 PSAY TMPX->F1_DOC+SPACE(2)+transform(TMPX->F1_VALMERC,"@E 999,999.99")+SPACE(2)+TMPX->F8_NFDIFRE+SPACE(2)+transform(TMPX->VALOR_FRETE,"@E 999,999.99")+space(2)+transform(nPerc,"@E 999.99")+SPACE(2)+IIF(EMPTY(MV_PAR03),POSICIONE("SA2", 1, xFilial("SA2") +F8_FORNECE+F8_LOJA, "A2_NREDUZ" ),"")
    ENDIF
    nValor+=TMPX->F1_VALMERC
    nVFrete+=TMPX->VALOR_FRETE
    
    TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
nPerc:=(nVFrete / nValor) * 100
@nLin++,00 PSAY  "TOTAL--> "+SPACE(2)+transform(nValor,"@E 999,999.99")+SPACE(13)+transform(nVFrete,"@E 999,999.99")+space(2)+transform(nPerc,"@E 999.99")
TMPX->(dbclosearea())

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
