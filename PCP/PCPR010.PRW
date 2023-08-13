#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"
 
                /*
                continuar  no Sy1  query   
                */

User Function PCPR011_()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela��o de Solicita��es e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Analise de Inspe��es"//+ PERIODO...
Local nLin           := 80
//                                                                                                                          1         1         1         1         1         1         1         1         1
                       //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
                       //         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
                       //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  Local Cabec1       :=   "     Produto       |     Item           |   Data   |Turno | Observa��o                                                                                                                                  |"
//Local Cabec1         := "         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |"
//Local Cabec2         := "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
  Local Cabec2       :=   "                   |                    |          |      |                                                                                                                                             |"         
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "G" //"G"
Private nomeprog     := "PCPR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "PCPR011"
Public extende:= 40
 
 Pergunte( cPerg ,.F. )
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  10/03/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
 */

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

local cQuery:=''  
Titulo:=ALLTRIM(Titulo) +"    De: "+dtoc(MV_PAR01)+"       Ate: "+dtoc(MV_PAR02) 

SetRegua(0)
cQuery := ""
cQuery += " select        "  +chr(10)
cQuery += "    Z60_EXTRUS EXT   ,  " +chr(10)
cQuery += "    Z60_PRODUT PROD  ,  "  +chr(10)
cQuery += "    Z60_ITEMD  DESCRI,  "  +chr(10)
cQuery += "    Z60_DATAI  DAT   ,  "  +chr(10)
cQuery += "    UPPER(RTRIM(LTRIM(Z60_OBS)))OBS ,"+chr(10)
cQuery += " case when CAST(SUBSTRING(Z60_HORAI,1,2) AS INT )<13 "+chr(10)
cQuery += " THEN 'A' ELSE 'B'  END TURNO                        "+chr(10)
cQuery += " from Z60020                                         "+chr(10)
cQuery += " WHERE D_E_L_E_T_=''                                 "+chr(10)
cQuery += "    AND Z60_OBS!=''                                     "+chr(10)
cQuery += "    AND Z60_DATAI BETWEEN "+valtosql(MV_PAR01)+ " AND " +valtosql(MV_PAR01) +chr(10)
cQuery += "    OR Z60_PENDEN='S'                                   "+chr(10)
cQuery += "    AND Z60_DATAI BETWEEN "+valtosql(MV_PAR02)+ " AND " +valtosql(MV_PAR01) +chr(10)
cQuery += " ORDER BY Z60_EXTRUS,TURNO                           "+chr(10)
TCQUERY cQuery NEW ALIAS "TMP1"
TMP1->( DbGoTop() )
aVetor:={}
While TMP1->( !EOF() ) 
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      nLin++
   Endif
   cExt:= TMP1->EXT
   @nLin++,000 psay cExt  
   While cExt== TMP1->EXT  
   incregua()
  If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      nLin++
   Endif 
   @nLin ,000    PSAY Cabec2
   @nLin ,000    PSAY replicate("_",160+extende)
   @nLin ,000+6  PSAY PROD
   @nLin ,015+6  PSAY DESCRI 
   @nLin ,037+6  PSAY dtoc(stod(DAT)) 
   @nLin ,048+6  PSAY TURNO 
   
   @nLin ,055+6  PSAY OBS 
        nLin++
  TMP1->(DbSkip())
  EndDo
EndDo
TMP1->(DbCloseArea()) 
 

	  
	 
	      
	           


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
