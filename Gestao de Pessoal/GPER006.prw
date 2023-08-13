#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPER006   � Autor � Eurivan Marques    � Data �  07/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Demissoes por periodo                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GPER006()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Demissoes por mes"
Local cPict          := ""
Local titulo         := "Demissoes por Mes - "
Local nLin           := 80
Local Cabec1         := "Filial  Dt.Demiss. Matri. Nome                                      Tipo Rescisao"
                     // "XXXXXX  99/99/99   999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                     //  12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
                     //           10        20        30        40        50        60        70        80        90       
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 120
Private tamanho      := "M"
Private nomeprog     := "GPER006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "GPER006"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GPER006" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SRA"

ValidPerg()
pergunte(cPerg,.F.)

titulo += Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

if nLastKey == 27
	Return
endif

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  09/06/11   ���
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

local cQuery

cQuery := "SELECT RA_FILIAL, RG_DATADEM, RA_MAT, RA_NOME, LEFT(RX_TXT,30) AS DESCR "
cQuery += "FROM "+RetSqlName("SRA")+" SRA, "+RetSqlName("SRG")+" SRG, "+RetSqlName("SRX")+" SRX "
cQuery += "WHERE RA_FILIAL = RG_FILIAL AND RA_MAT = RG_MAT AND "
cQuery += "RA_RESCRAI NOT IN('30', '31' ) AND "
cQuery += "RG_DATADEM BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery += "RX_FILIAL = '"+xFilial("SRX")+"' AND RX_TIP = '32' AND RG_TIPORES = RX_COD AND "
cQuery += "SRA.D_E_L_E_T_ = '' AND SRG.D_E_L_E_T_ = '' AND SRX.D_E_L_E_T_ = '' "
cQuery += "ORDER BY RG_FILIAL, RG_DATADEM "

TCQUERY cQuery NEW ALIAS "SRAX"
TCSetField( 'SRAX', "RG_DATADEM", "D")

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(0)

DbSelectArea("SRAX")

while !SRAX->(EOF())

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   if lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   if nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   endif

   if SRAX->RA_FILIAL == "01"
      @nLin,000 PSAY "Saco"
   elseif SRAX->RA_FILIAL == "03"
      @nLin,000 PSAY "Caixa"      
   endif

   @nLin,009 PSAY Dtoc(SRAX->RG_DATADEM)
   @nLin,020 PSAY SRAX->RA_MAT 
   @nLin,027 PSAY SRAX->RA_NOME
   @nLin,069 PSAY DESCR

   nLin := nLin + 1 // Avanca a linha de impressao
   SRAX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   IncRegua()   
   
EndDo

SRAX->(DbCloseArea())

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

***************************
Static Function ValidPerg()
***************************

PutSx1(cPerg,'01','Da Data  ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'02','Ate Data ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{})

Return