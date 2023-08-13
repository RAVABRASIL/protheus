#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

User Function ESTR012()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Produ��o Por Linha"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produ��o Por Linha da data" +  mv_par01 + " at� " + mv_par02
Local nLin           := 80


Local Cabec2       := "|  C�digo |      Descri��o do Produto                                 |Media Consumo | Melhor Pre�o |  Custo A  |  Data Melhor Compra |  Ultimo Pre�o   |  Custo B  |Data Ultimo Pre�o| M�dia Ponderada | % de Varia��o|"
Local Cabec1       := "|                                                                                                                              
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "ESTR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ESTR012" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("ESTR012",.F.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������



wnrel := SetPrint(cString,NomeProg,"ESTR012",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//Local dDadad := dtos(MV_PAR01 - 365)

titulo := "Relat�rio Anal�tico de Compra de MP's " +  DTOC(MV_PAR01-365) + " � " + DTOC(MV_PAR01)

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

cQuery := "SELECT Z69_FILIAL, Z69_CODIGO, Z69_DESC, Z69_QUANT FROM Z69020 "
cQuery += "WHERE D_E_L_E_T_ = '' AND Z69_FILIAL = '" + xFilial("Z69") + "' "


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
   
   @nLin,02 PSAY TMP->Z69_CODIGO 
   @nLin,18 PSAY TMP->Z69_DESC
   @nLin,70 PSAY  transform(TMP->Z69_QUANT, "@E 999,999,999.99")   //Consumo
    
   aMelhorPre := MelhorPrc(TMP->Z69_CODIGO)
   if len(aMelhorPre) <> 0
   	@nLin,82  PSAY transform(aMelhorPre[1], '@E 999,999,999.99')		//Melhor pre�o de Compra
   	@nLin,99  PSAY transform((aMelhorPre[1]*TMP->Z69_QUANT), '@E 999,999,999.99')  //Custo
   	@nLin,120 PSAY DTOC(STOD(aMelhorPre[2])) 						//Data Melhor Compra
   else
   	@nLin,82  PSAY transform(0, '@E 999,999,999.99')		//Melhor pre�o de Compra
  	@nLin,99  PSAY transform((0*TMP->Z69_QUANT), '@E 999,999,999.99')  //Custo
   	@nLin,120 PSAY DTOC(STOD("")) 						//Data Melhor Compra
   endif
   
   
   aUltimoPre := UltimoPrc(TMP->Z69_CODIGO)
   
   if len(aUltimoPre) <> 0
  	 @nLin,133  PSAY transform(aUltimoPre[1], '@E 999,999,999.99')
     @nLin,150  PSAY transform((aUltimoPre[1]*TMP->Z69_QUANT), '@E 999,999,999.99')
   	 @nLin,172 PSAY DTOC(STOD(aUltimoPre[2]))
   	 @nLin,181  PSAY transform(MediaPonde(TMP->Z69_CODIGO), '@E 999,999,999.99') 
  	 @nLin,203 PSAY TRANSFORM((100-((aMelhorPre[1]*100)/MediaPonde(TMP->Z69_CODIGO))),'@E 999.99') + " %"
   else
   	@nLin,133  PSAY transform(0, '@E 999,999,999.99')
     @nLin,150  PSAY transform((0*TMP->Z69_QUANT), '@E 999,999,999.99')
   	 @nLin,172 PSAY DTOC(STOD(""))
   	 @nLin,181  PSAY transform(MediaPonde(TMP->Z69_CODIGO), '@E 999,999,999.99')
   endif
   
   
   
   nLin++
   
incregua()  

   TMP->(DbSkip())

EndDo

	nLin++
    nLin++
    @nLin,18  PSAY "Legenda das Colunas do Relat�rio:"
    nLin++
    nLin++
    @nLin,18  PSAY "M�dia de Consumo -> M�dia dos �ltimos 12 Meses de Consumo do Produto ao Almoxarifado."
    nLin++
    nLin++
    @nLin,18  PSAY "Melhor Pre�o     -> Melhor Pre�o de Compra dos �ltimos 12 Meses de Entrada do Produto na Empresa."
    nLin++
    nLin++
    @nLin,18  PSAY "Custo A          -> Igual a M�dia de Consumo vezes Melhor Pre�o."
    nLin++
    nLin++
    @nLin,18  PSAY "Dt Melhor Compra -> Data que foi Feita a entrada dessa Melhor Compra."
    nLin++
    nLin++
    @nLin,18  PSAY "�ltimo Pre�o     -> �ltimo Pre�o de Compra desse Produto na Empresa."
    nLin++
    nLin++
    @nLin,18  PSAY "Custo B          -> Igual a M�dia de Consumo vezes �ltimo Pre�o."
	nLin++
    nLin++
	@nLin,18  PSAY "Dt �ltimo Pre�o  -> Data que foi Feita a entrada desse �ltima Compra."
	nLin++
    nLin++
	@nLin,18  PSAY "M�dia Ponderada  -> M�dia Ponderada das �ltimas 3 entradas do Produto em quest�o."
	nLin++
    nLin++
	@nLin,18  PSAY "% de Varia��o    -> Varia��o em Percentual do Melhor Pre�o pelo M�dia Ponderada."

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

Static Function MelhorPrc(cProduto)

Local cQueryA := ''
Local aRet := {}
//Local dDadade := dtos(dDataBase - 365)
//Local dDadaAte := dtos(dDatabase)
Local dDadade := dtos(MV_PAR01 - 365)
Local dDadaAte := dtos(MV_PAR01)

cQueryA := " SELECT TOP 1 D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI "
cQueryA += "FROM SD1020 WHERE D1_DTDIGIT BETWEEN '" + dDadade + "' AND '" + dDadaAte + "' "
cQueryA += "AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQueryA += "ORDER BY D1_VUNIT, D1_DTDIGIT DESC "

TCQUERY cQueryA NEW ALIAS "TMX"

if TMX->(!EOF())

    //aRet :=TMX->VALOR
	AADD(aRet, TMX->VALOR)
	AADD(aRet, TMX->DIGI)

ENDIF

TMX->(DbCloseArea())

Return aRet
	
STATIC Function UltimoPrc(cProduto)

Local cQ := ''
Local aRet := {}
Local dDadade := dtos(MV_PAR01 - 365)
Local dDadaAte := dtos(MV_PAR01)

cQueryA := " SELECT TOP 1 D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI "
cQueryA += "FROM SD1020 WHERE D1_DTDIGIT BETWEEN '" + dDadade + "' AND '" + dDadaAte + "' "
cQueryA += "AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQueryA += "ORDER BY D1_DTDIGIT DESC "

TCQUERY cQueryA NEW ALIAS "TMX"

if TMX->(!EOF())

    //aRet :=TMX->VALOR
	AADD(aRet, TMX->VALOR)
	AADD(aRet, TMX->DIGI)

ENDIF

TMX->(DbCloseArea())

Return aRet

STATIC Function MediaPonde(cProduto)

Local cQ := ''
Local nRet := 0
//Local dDadade := dtos(MV_PAR01 - 365)
Local cDadaAte := SubStr(dtos(MV_PAR01),1,6)

cQueryA := "SELECT MEDIA=SUM(MULTI)/SUM(QUANT) FROM " 
cQueryA += "(SELECT D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_QUANT QUANT, D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI, "
cQueryA += "D1_QUANT * D1_VUNIT 'MULTI' "
cQueryA += "FROM SD1020 WHERE SUBSTRING(D1_DTDIGIT,1,6) = '" + cDadaAte + "' " 
cQueryA += " AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
//cQueryA += "ORDER BY D1_DTDIGIT DESC "
cQueryA += ") AS TABX " 

TCQUERY cQueryA NEW ALIAS "TMX"


IF TMX->(!EOF())
	nRet :=TMX->MEDIA
ENDIF
	
TMX->(DbCloseArea())

Return nRet



