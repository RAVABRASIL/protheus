#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � Romildo Sousa      � Data �  23/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMR017()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Relatorio de Prazo M�dio de Entrada"
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local titulo         :=" "
Local nLin           := 80

                     //          10        20        30        40        50       60         70        80        90        100        110
                     //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       := "  N�mero S.C | Emiss�o S.C | Pedido Compra | Emiss�o P.C | Libera�ao P.C | N.F Entrada | Emiss�o N.F | Entrada NF Rava| Cod Prod| Descri��o Produto                         |  Tipo  |  Lib PC  | Forne | Frete | Lib | Total "
Local Cabec2       := "          "
Local Cabec3       := "  N�mero S.C | Emiss�o S.C | Pedido Compra | Emiss�o P.C | Libera�ao P.C | N.F Entrada | Emiss�o N.F | Entrada NF Rava| Cod Forn| Descri��o Fornece                         |  Tipo  |  Lib PC  | Forne | Frete | Lib | Total "
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 260
Private tamanho    := "G"
Private nomeprog   := "COMR017" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COMR017" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//dbSelectArea("")
//dbSetOrder(1)

Pergunte("COMR017",.F.) //vamo botar true, pra pergunta sair primeiro
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"COMR017",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Relatorio de " +  dtoc(mv_par02) + " at� " + dtoc(mv_par03)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin) },Titulo)
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

Static Function RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin)
 
Local cFornece := ""
Local cProduto := ""
Local nAuxi := 0
Local nSoma := 0
//Local nLibe := 0

IF MV_PAR01 = 1
  
cQuery := "SELECT D1_FORNECE, A2_NOME, C1_NUM, C1_EMISSAO, C7_NUM, C7_EMISSAO, CR_DATALIB, "
cQuery += "	   D1_DOC, D1_EMISSAO, D1_DTDIGIT,  D1_COD, B1_DESC, B1_TIPO, C1_PEDPROG, "
cQuery += "	   SC_PC_AP = CAST(CONVERT(DATETIME,CR_DATALIB) - CONVERT(DATETIME, C1_EMISSAO) AS INTEGER ), "
cQuery += "    FORNE = CAST(CONVERT(DATETIME,D1_EMISSAO) - CONVERT(DATETIME, CR_DATALIB) AS INTEGER ), "
cQuery += "    PROGR = CAST(CONVERT(DATETIME,D1_EMISSAO) - CONVERT(DATETIME, C1_DATPRF) AS INTEGER ), "
cQuery += "	   FRET_CHEG = CAST(CONVERT(DATETIME,F1_RECBMTO) - CONVERT(DATETIME, D1_EMISSAO) AS INTEGER ), "
cQuery += "    nLibe = CAST(CONVERT(DATETIME,D1_DTDIGIT) - CONVERT(DATETIME, F1_RECBMTO) AS INTEGER ), "
cQuery += "	PRAZO_TOTAL = CAST(CONVERT(DATETIME,D1_DTDIGIT) - CONVERT(DATETIME, C1_EMISSAO) AS INTEGER ) "
cQuery += "FROM SC7020 C7 "
cQuery += "inner join SD1020 D1 "
cQuery += "ON D1_PEDIDO = C7_NUM AND D1_FILIAL = C7_FILIAL AND C7_PRODUTO = D1_COD "
cQuery += "inner join SC1020 C1 "
cQuery += "ON C7_NUMSC = C1_NUM AND C7_FILIAL = C1_FILIAL AND C7_PRODUTO = C1_PRODUTO "
cQuery += "inner join SA2010 A2 "
cQuery += "ON C7_FORNECE = A2_COD AND C7_LOJA =  A2_LOJA "
cQuery += "INNER JOIN SB1010 B1 "
cQuery += "ON C7_PRODUTO = B1_COD "
cQuery += "INNER JOIN " 
cQuery += "SCR020 CR "
cQuery += "ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
cQuery += "INNER JOIN SF1020 F1 "
cQuery += "ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_LOJA = D1_LOJA "
cQuery += "AND F1_FORNECE = D1_FORNECE AND F1_TIPO = D1_TIPO "
cQuery += "WHERE "
cQuery += "D1_EMISSAO >= '"+ Dtos( mv_par02 ) +"' AND D1_EMISSAO <= '"+ Dtos( mv_par03 ) +"' AND B1_TIPO IN ('MP','MS','ME','AC') "
cQuery += "AND CR.D_E_L_E_T_ = '' "
cQuery += "AND C7_FILIAL = '"+xFilial("SC7")+"' "
	if !Empty(MV_PAR04)
			cQuery += "AND D1_FORNECE = '"+alltrim(MV_PAR04)+"' "
	endif
	if !Empty(MV_PAR05)
			cQuery += "AND D1_COD = '"+alltrim(MV_PAR05)+"' "	
	endif
cQuery += "AND D1.D_E_L_E_T_ = '' AND C7.D_E_L_E_T_ = '' AND C1.D_E_L_E_T_ = '' AND CR.D_E_L_E_T_ = '' AND CR_LIBAPRO <> '' "
cQuery += "ORDER BY D1_FORNECE, C1_NUM, C1_EMISSAO "

ELSE

cQuery := "SELECT D1_COD, B1_DESC, C1_NUM, C1_EMISSAO, C7_NUM, C7_EMISSAO, CR_DATALIB, "
cQuery += "	   D1_DOC, D1_EMISSAO, D1_DTDIGIT,  D1_FORNECE, A2_NOME, B1_TIPO, C1_PEDPROG, "
cQuery += "	   SC_PC_AP = CAST(CONVERT(DATETIME,CR_DATALIB) - CONVERT(DATETIME, C1_EMISSAO) AS INTEGER ), "
cQuery += "    FORNE = CAST(CONVERT(DATETIME,D1_EMISSAO) - CONVERT(DATETIME, CR_DATALIB) AS INTEGER ), "
cQuery += "    PROGR = CAST(CONVERT(DATETIME,D1_EMISSAO) - CONVERT(DATETIME, C1_DATPRF) AS INTEGER ), "
cQuery += "	   FRET_CHEG = CAST(CONVERT(DATETIME,F1_RECBMTO) - CONVERT(DATETIME, D1_EMISSAO) AS INTEGER ), "
cQuery += "    nLibe = CAST(CONVERT(DATETIME,D1_DTDIGIT) - CONVERT(DATETIME, F1_RECBMTO) AS INTEGER ), "
cQuery += "	PRAZO_TOTAL = CAST(CONVERT(DATETIME,D1_DTDIGIT) - CONVERT(DATETIME, C1_EMISSAO) AS INTEGER ) "
cQuery += "FROM SC7020 C7 "
cQuery += "inner join SD1020 D1 "
cQuery += "ON D1_PEDIDO = C7_NUM AND D1_FILIAL = C7_FILIAL AND C7_PRODUTO = D1_COD "
cQuery += "inner join SC1020 C1 "
cQuery += "ON C7_NUMSC = C1_NUM AND C7_FILIAL = C1_FILIAL AND C7_PRODUTO = C1_PRODUTO "
cQuery += "inner join SA2010 A2 "
cQuery += "ON C7_FORNECE = A2_COD AND C7_LOJA =  A2_LOJA "
cQuery += "INNER JOIN SB1010 B1 "
cQuery += "ON C7_PRODUTO = B1_COD "
cQuery += "INNER JOIN " 
cQuery += "SCR020 CR "
cQuery += "ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
cQuery += "INNER JOIN SF1020 F1 "
cQuery += "ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_LOJA = D1_LOJA "
cQuery += "AND F1_FORNECE = D1_FORNECE AND F1_TIPO = D1_TIPO "
cQuery += "WHERE "
cQuery += "D1_EMISSAO >= '"+ Dtos( mv_par02 ) +"' AND D1_EMISSAO <= '"+ Dtos( mv_par03 ) +"' AND B1_TIPO IN ('MP','MS','ME','AC') "
cQuery += "AND CR.D_E_L_E_T_ = '' "
cQuery += "AND C7_FILIAL = '"+xFilial("SC7")+"' " 
	if !Empty(MV_PAR04)
			cQuery += "AND D1_FORNECE = '"+alltrim(MV_PAR04)+"' "
	endif
	if !Empty(MV_PAR05)
			cQuery += "AND D1_COD = '"+alltrim(MV_PAR05)+"' "	
	endif
cQuery += "AND D1.D_E_L_E_T_ = '' AND C7.D_E_L_E_T_ = '' AND C1.D_E_L_E_T_ = '' AND CR.D_E_L_E_T_ = '' AND CR_LIBAPRO <> '' "
cQuery += "ORDER BY D1_COD, C1_NUM, C1_EMISSAO "


ENDIF
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

TCSetField( 'TMP', 'C1_EMISSAO', 'D' )
TCSetField( 'TMP', 'C7_EMISSAO', 'D' ) 
TCSetField( 'TMP', 'CR_DATALIB', 'D' )
TCSetField( 'TMP', 'D1_EMISSAO', 'D' ) 
TCSetField( 'TMP', 'D1_DTDIGIT', 'D' )


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
      IF MV_PAR01 = 1
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
      ELSE
      	Cabec(Titulo,Cabec3,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
      ENDIF
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:

   
   IF MV_PAR01 = 1
   
	   cfornece := TMP->D1_FORNECE
	   
	   @nLin,010 PSAY "Fornecedor: "
	   nLin++
	   @nLin,010 PSAY D1_FORNECE 
	   @nLin,020 PSAY A2_NOME
	   nLin++
	   nLin++
	    
	   while !tmp->(eof()) .and. TMP->D1_FORNECE == cfornece
	   
	   IF TMP->C1_PEDPROG = 'S' 
	   		@nLin,009 PSAY "P"	
	   ENDIF
	   @nLin,003 PSAY C1_NUM     			//Codigo do bem
	   @nLin,016 PSAY Dtoc(C1_EMISSAO)       //Ordem de Servi�o
	   @nLin,031 PSAY C7_NUM     
	   @nLin,047 PSAY Dtoc(C7_EMISSAO)          
	   @nLin,063 PSAY Dtoc(CR_DATALIB) 
	   @nLin,075 PSAY D1_DOC
	   @nLin,089 PSAY Dtoc(D1_EMISSAO)         
	   @nLin,105 PSAY Dtoc(D1_DTDIGIT)    
	   @nLin,120 PSAY D1_COD
	   @nLin,130 PSAY SUBSTR(B1_DESC, 1, 45)         
	   @nLin,177 PSAY B1_TIPO    
	   @nLin,187 PSAY SC_PC_AP
	   IF TMP->C1_PEDPROG = 'S'  
	   		@nLin,196 PSAY PROGR
	   ELSE
	    	@nLin,196 PSAY FORNE   
	   ENDIF
	   @nLin,204 PSAY FRET_CHEG
	   @nLin,212 PSAY nLibe
	   @nLin,217 PSAY PRAZO_TOTAL
	   
	   nAuxi := nAuxi + 1
	   nSoma := nSoma + PRAZO_TOTAL
	   nLin++
	   
	   Incregua()
	   TMP->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EnddO
		nLin++
		@nLin,186 PSAY "M�dia de Dias -> "  	
		@nLin,212 PSAY  TRANSFORM((nSoma/nAuxi), "@E 999,99")
		nAuxi := 0
	    nSoma := 0
   
   ELSE
   
	   cProduto := TMP->D1_COD
	   
	   @nLin,010 PSAY "Produto: "
	   nLin++
	   @nLin,010 PSAY D1_COD 
	   @nLin,020 PSAY B1_DESC
	   nLin++
	   nLin++
	    
	   while !tmp->(eof()) .and. TMP->D1_COD == cProduto
	   
	   IF TMP->C1_PEDPROG = 'S' 
	   		@nLin,009 PSAY "P"	
	   ENDIF
	   @nLin,003 PSAY C1_NUM     //Codigo do bem
	   @nLin,016 PSAY Dtoc(C1_EMISSAO)       //Ordem de Servi�o
	   @nLin,031 PSAY C7_NUM     
	   @nLin,047 PSAY Dtoc(C7_EMISSAO)          
	   @nLin,063 PSAY Dtoc(CR_DATALIB) 
	   @nLin,075 PSAY D1_DOC
	   @nLin,089 PSAY Dtoc(D1_EMISSAO)         
	   @nLin,105 PSAY Dtoc(D1_DTDIGIT)    
	   @nLin,120 PSAY D1_FORNECE
	   @nLin,130 PSAY SUBSTR(A2_NOME, 1, 45)         
	   @nLin,177 PSAY B1_TIPO    
	   @nLin,187 PSAY SC_PC_AP
	   IF TMP->C1_PEDPROG = 'S'  
	   		@nLin,196 PSAY PROGR
	   ELSE
	    	@nLin,196 PSAY FORNE   
	   ENDIF   
	   @nLin,204 PSAY FRET_CHEG
	   @nLin,212 PSAY nLibe
	   @nLin,217 PSAY PRAZO_TOTAL
	   
	   nAuxi := nAuxi + 1
	   nSoma := nSoma + PRAZO_TOTAL
	   nLin++
   
       Incregua()
	   TMP->(DbSkip()) // Avanca o ponteiro do registro no arquivo
       EnddO
		nLin++
		@nLin,186 PSAY "M�dia de Dias -> "  	
		@nLin,212 PSAY  TRANSFORM((nSoma/nAuxi), "@E 999,99")
		nAuxi := 0
	    nSoma := 0
   
   ENDIF

EndDo

		@nLin,003 PSAY "Legenda Referente aos 5 �ltimos campos do Relat�rio..."
		nLin++  	   
		nLin++
		@nLin,003 PSAY "Lib PC ->"
		@nLin,015 PSAY "Intervalo entre a abertura Solicita��o de Compra at� a Libera��o do Pedido de Compra pela Diretoria."
		nLin++  	   
		@nLin,003 PSAY "Forne   ->"
		@nLin,015 PSAY "Intervalo entre a libera��o do pedido de compra pela diret�ria, at� a emiss�o da NF do fornecedor. "
		@nLin,003 PSAY "Obs.: Caso apare�a um P na frente da SC, significa que o PC � Programado, assim o intervalo � pela Dt de Programa��o, at� a Emiss�o da NF"		
		nLin++
		@nLin,003 PSAY "Frete   ->"
		@nLin,015 PSAY "Intervalo entre a Emiss�o de NF pelo Fornecedor, at� O recebimento da mercadoria aqui na Rava "
		nLin++
		@nLin,003 PSAY "Lib    ->"
		@nLin,015 PSAY "Intervalo entre a Entrada da NF na Rava at� sua Libera��o(quando necess�rio), pela diretoria "
		nLin++
		@nLin,003 PSAY "Total   ->"
		@nLin,015 PSAY "Intervalo entra a Emiss�o da Solicita��o de Compra at� a entrada do Produto no Estoque"


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
