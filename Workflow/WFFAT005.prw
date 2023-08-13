#INCLUDE "rwmake.ch"
#INCLUDE 'TOPCONN.CH'       
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO20    � Autor � AP6 IDE            � Data �  11/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function WFFAT005()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Realcao de Distribuidores"
Local cPict          := ""
Local titulo         := "Relacao de Distribuidores"
Local nLin           := 80
                       
Local Cabec1         := "Nome	                                                        Telefone	     Email	                               Area de Atuacao      Cnpj	                Cidade           Dt Ult Compra  Comprou"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "WFFAT005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "WFFAT005" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

dbUseArea(.t.,,"Dados.dbf","TMP",.f.,.f.)

dbSelectArea("SA1" )
dbSetOrder(3)


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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  11/03/10   ���
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

TMP->(dbGoTop())
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
    
    If !Empty(TMP->CNPJ)
       If SA1->(dbSeek(xFilial("SA1")+ALLTRIM(TMP->CNPJ),.F.))         
          
          @nLin,00 PSAY OemToAnsi(TMP->NOME)
          @nLin,68 PSAY TMP->TELEFONE
          @nLin,84 PSAY TMP->EMAIL
          @nLin,122 PSAY OemToAnsi(TMP->AREA_DE_AT)
          @nLin,143 PSAY transform(TMP->CNPJ,"@R ##.###.###/####-##" )
          @nLin,165 PSAY OemToAnsi(TMP->CIDADE)
          @nLin,182 PSAY UltCompra(SA1->A1_COD)
          
          If Comprou(SA1->A1_COD) 
             @nLin++,197 PSAY "Nao"
          Else
             @nLin++,197 PSAY "Sim"
          EndIf
       Else
          
          @nLin,00 PSAY OemToAnsi(TMP->NOME)
          @nLin,68 PSAY TMP->TELEFONE
          @nLin,84 PSAY TMP->EMAIL
          @nLin,122 PSAY OemToAnsi(TMP->AREA_DE_AT)
          @nLin,143 PSAY transform(TMP->CNPJ,"@R ##.###.###/####-##" )
          @nLin,165 PSAY OemToAnsi(TMP->CIDADE)
          @nLin,182 PSAY UltCompra(SA1->A1_COD)
          @nLin++,197 PSAY "Nao"
          
       EndIf  
    Endif
    
    TMP->(Incregua())
    TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

TMP->(dbCloseArea())
SA1->(dbCloseArea())
SD2->(dbCloseArea())
SB1->(dbCloseArea())

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

Static Function Comprou(cCliente)

***************        

dbSelectArea("SD2" )
dbSetOrder(9)
If SD2->(dbSeek(xFilial("SD2")+cCliente,.F.))   
   dbSelectArea("SB1" )
   dbSetOrder(1)
   While SD2->(!EOF()) .AND. SD2->D2_CLIENTE=cCliente
     If SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD,.F.))   
       If SB1->B1_SETOR='39' 
          Return .F.
       EndIf
     Endif
   SD2->(dbSkip())
   EndDo
Endif

Return .T.          

***************                   

Static Function UltCompra(cCliente)

***************        
local cQry:=''
local cDtUlt:=''

cQry:="SELECT TOP 1 D2_EMISSAO  "
cQry+="FROM "+RetSqlName("SD2")+" SD2  "
cQry+="WHERE D2_CLIENTE ='"+cCliente+"' "
cQry+="AND SD2.D_E_L_E_T_!='*'  "
cQry+="ORDER BY D2_EMISSAO DESC "

TCQUERY cQry NEW ALIAS "_TMPX"

if _TMPX->(!EOF())
   cDtUlt:=_TMPX->D2_EMISSAO
Endif

_TMPX->(DbCloseArea())

Return DtoC(StoD(cDtUlt))