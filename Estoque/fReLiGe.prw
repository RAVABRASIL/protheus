#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"


*************

User Function fReLiGe()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Lista Inventario "
Local cPict          := ""
Local titulo         := "Lista Inventario Gerencial"
Local nLin           := 80
                        //          10        20        30        40        50        60        70        80
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "fReLiGe" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fReLiGe" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

pergunte("FRELIGE",.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FRELIGE",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo         := "Lista Inventario Gerencial "
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/08/13   ���
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
local cQry:=''
Local nOrdem


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

cQry:="SELECT * FROM "+RetSqlName("Z89")+"  Z89 WHERE D_E_L_E_T_='' "
cQry+="AND  Z89_DTINIC BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQry+="and Z89_FILIAL='"+XFILIAL('Z89')+"' "

If Select("Z89R") > 0
	DbSelectArea("Z89R")
	Z89R->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "Z89R"

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

Z89R->(dbGoTop())
While Z89R->(!EOF())
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
   dDtInic:=Z89R->Z89_DTINIC
   @nLin++,00 PSAY "Lista: "+dtoc(stod(Z89R->Z89_DTINIC))+' - '+ Z89R->Z89_HRINIC+' - '+Z89R->Z89_USUINI+" Gerado em: "+dtoc(stod(Z89R->Z89_DTGERA))+' - '+ IIF(Z89R->Z89_DTINIC<>Z89R->Z89_DTGERA,'Fora do Prazo','No Prazo')
   @nLin++,00 PSAY "Finalizada: "+IIF(Z89R->Z89_FINALI=='F',dtoc(stod(Z89R->Z89_DTFINA))+' - '+ Z89R->Z89_HRFINA+' - '+Z89R->Z89_USUFIN,'Nao')
   @nLin++,00 PSAY "Justificativa : "+Z89R->Z89_JUSTIF
   CabecItens(@nLin)
   @nLin++,00 PSAY REPLICATE('_',140)
   While Z89R->(!EOF()) .AND.    Z89R->Z89_DTINIC=dDtInic
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
      @nLin,00 PSAY Z89R->Z89_CODIGO
      @nLin,17 PSAY Z89R->Z89_DESCRI
      @nLin,69 PSAY Z89R->Z89_UM
      @nLin,73 PSAY TRANSFORM(Z89R->Z89_QATU,PesqPict("Z89","Z89_QATU" ))
      @nLin,96 PSAY TRANSFORM(Z89R->Z89_QDIGIT,PesqPict("Z89","Z89_QDIGIT" ))      
      @nLin++,119 PSAY TRANSFORM(Z89R->Z89_QATU-Z89R->Z89_QDIGIT,PesqPict("Z89","Z89_QDIGIT" ))      
      Z89R->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
   @nLin++,00 PSAY REPLICATE('_',140)
EndDo


Z89R->(DBCLOSEAREA())

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

Static Function CabecItens(nLin)

***************

@nLin,00 PSAY    "Codigo"
@nLin,17 PSAY    "Descricao"
@nLin,69 PSAY    "UM"
@nLin,73 PSAY    "Qtd Estoque"
@nLin,96 PSAY    "Qtd Contagem"
@nLin,119 PSAY "Diferenca"

	  
Return 