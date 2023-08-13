#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � Romildo Sousa      � Data �  16/07/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR022()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Produ��o Por Linha"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produ��o Por Linha da data" +  mv_par01 + " at� " + mv_par02
Local nLin           := 80


Local Cabec1       := "       C�digo    |      Linha           |   Tipo   |    Qtd em Peso        |"
Local Cabec2       := "                 |                      |          |                       |"
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "PCPR022" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PCPR022" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")

hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("PCPR022",.F.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"PCPR022",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Relatorio de " +  dtoc(mv_par01) + " at� " + dtoc(mv_par02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/07/13   ���
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
Local cQuery := ''
LOCAL nTOTAL := 0
//Local cCabe1 := "       Linha     |     C�digo      |   Peso   |        Percentual          |"
//Local cCabe2 := "                 |                 |          |                            |"
//Titulo := "Relat�rio Mensal"

cQuery := "SELECT isnull(B1_GRUPO,'') AS GRUPO,  "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') "
cQuery += "THEN 'ROLO' ELSE 'NORMAL' END TIPO, "
cQuery += "ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK) "
cQuery += ",SC2020 SC2 WITH (NOLOCK)  "
cQuery += ",SB1010 SB1 WITH (NOLOCK) "

//cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par02+1 ) +"05:19' "
cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR >='"+Dtos( mv_par01 )+hora1+"'  AND Z00.Z00_DATHOR <'"+Dtos( mv_par02+1 )+hora1+"' "

cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' '  "
cQuery += "AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "AND C2_PRODUTO=B1_COD "
//cQuery += "AND SC2.D_E_L_E_T_ = ' '  "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY isnull(B1_GRUPO,'')  "
cQuery += ",CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END "

/*
cQuery := "SELECT isnull(B1_GRUPO,'') AS GRUPO, "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') " 
cQuery += "THEN 'ROLO' ELSE 'NORMAL' END TIPO, "
cQuery += "ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK) " 
cQuery += "left join SB1010 SB1 WITH (NOLOCK) ON Z00_CODIGO=B1_COD AND SB1.D_E_L_E_T_='' "
cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par02+1 ) +"05:19' "
cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' GROUP BY isnull(B1_GRUPO,''), "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END "
MemoWrite("C:\Temp\PCPR022.sql", cQuery )
*/

//dbSelectArea(cString)
//dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//SetRegua(RecCount())
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

//dbGoTop()
//While !EOF()

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGoTop()) 
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
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:

// Grupo
   
/* 0004	Eletronicos                   		
   0005	Pneumaticos                   		
   0007	Produto de Venda              		
   0008	OUTROS                        		
   0010	DESPESAS GERAIS               		
   0011	MATERIA PRIMA                 		
   0012	SERVICOS E MANUTENCAO         		
   0013	LOGISTICA                     		
   A	INSTITUCIONAL A GRANEL        		
   B	ABNT A GRANEL                 		
   C	HOSPITALAR                    		
   D	DONA LIMPEZA                  		
   E	BRASILEIRINHO                 		
   F	ALIMENTICIO                   		
   G	SACOLA LISA                   		
   H	SACOLA IMPRESSA               		
   I	SACO IMPRESSO                 		
   J	PIA                           		
   K	BOBINA                        		
   L	REVENDA                       		
   ME  	MATERIAL PARA EMBALAGEM  */     		
   
   @nLin,08 PSAY TMP->GRUPO
   @nLin,17 PSAY Posicione("SBM",1,xFilial('SBM')+TMP->GRUPO,"BM_DESC" )
   @nLin,45 PSAY TMP->TIPO
   @nLin,60 PSAY transform((TMP->PESO), "@E 999,999,999.99")   
   nLin := nLin + 1 //Avanca a linha de impressao
   nTOTAL += TMP->PESO
   
incregua()

   TMP->(DbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo


@nLin+1,48 PSAY "TOTAL ->"
@nLin+1,58 PSAY transform((nTOTAL), "@E 999,999,999.99") 

TMP->(DbCloseArea())
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