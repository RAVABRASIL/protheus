#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO14    � Autor � AP6 IDE            � Data �  01/10/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************

User Function  FREBOBINA()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Contagem de Bobina"
Local cPict          := ""
Local titulo         := "Contagem de Bobina"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80 //132
Private tamanho      := "P" //"M"
Private nomeprog     := "FREBOBINA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FREBOBINA" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

ValidPerg('FREBOB')

Pergunte('FREBOB',.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FREBOB",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  01/10/15   ���
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
Local nToCont:=0


cQuery:="select  "

cQuery+="distinct ZB9_COD,ZB9_SEQ,C2_PRODUTO ZZ4_CODPI,ZZ4_BOBINA,ZZ4_PESO,ZZ4_MAQ,ZZ4_CODIGO,ZB9_SALDO "

cQuery+="from " + RetSqlName( "ZZ4" ) + " ZZ4, " + RetSqlName( "Z00" ) + " Z00," + RetSqlName( "SC2" ) + " SC2 , " + RetSqlName( "ZB9" ) + " ZB9 "
cQuery+="where "
cQuery+="ZZ4_FILIAL='"+xFilial('ZZ4')+"' "
cQuery+="AND ZZ4_CONTAG='"+MV_PAR01+"' "

cQuery+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery+="AND SUBSTRING(Z00_OP,1,6)+Z00_SEQ=ZZ4_BOBINA "

cQuery+="AND C2_PRODUTO=ZB9_COD "
cQuery+="AND Z00_SEQ=ZB9_SEQ "

cQuery+="AND ZZ4.D_E_L_E_T_='' "
cQuery+="AND Z00.D_E_L_E_T_='' "
cQuery+="AND SC2.D_E_L_E_T_='' "
cQuery+="AND ZB9.D_E_L_E_T_='' "
cQuery+="ORDER BY ZZ4_CODIGO   "

TCQUERY cQuery NEW ALIAS "TMPX"


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


nToCont:=fQtdProd('')

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
      nLin := 6

	  // TOTAL DA CONTAGEM
	  @nLin,33   PSAY "Contagem  "
	  @nLin,45   PSAY "Qtd "
      @nLin++,33 PSAY REPLICATE('_',16)
	  @nLin,33   PSAY MV_PAR01
	  @nLin,45   PSAY CVALTOCHAR(nToCont)
	  @nLin++

   Endif
   	
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:

   cProd:=TMPX->ZZ4_CODIGO          
   nQuant:=fQtdProd(cProd)
      
   @nLin,00   PSAY "Produto:"
   @nLin,17   PSAY "Qtd:"
   @nLin++,00 PSAY REPLICATE('_',21)
   @nLin,00   PSAY cProd
   @nLin,17   PSAY nQuant
   @nLin++
   
   // cabec dos itens 
   @nLin++,00 PSAY REPLICATE('_',39)
   @nLin,00 PSAY "Bobina"
   @nLin,14 PSAY "Saldo" // @E 999.999                                   
   @nLin,24 PSAY "Maquina"      
   @nLin,32 PSAY "PI"      
   @nLin++,00 PSAY REPLICATE('_',39)

   nCnt:=0
   
   Do While TMPX->(!EOF()) .AND. TMPX->ZZ4_CODIGO==cProd       

	   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 6
	
		  // TOTAL DA CONTAGEM
		  @nLin,33   PSAY "Contagem  "
		  @nLin,45   PSAY "Qtd "
	      @nLin++,33 PSAY REPLICATE('_',16)
		  @nLin,33   PSAY MV_PAR01
		  @nLin,45   PSAY CVALTOCHAR(nToCont)
		  @nLin++,00 PSAY 'Continua....'
		   // cabec dos itens 
		   @nLin++,00 PSAY REPLICATE('_',39)
		   @nLin,00 PSAY "Bobina"
		   @nLin,14 PSAY "Saldo" // @E 999.999                                   
		   @nLin,24 PSAY "Maquina"      
		   @nLin,32 PSAY "PI"      
		   @nLin++,00 PSAY REPLICATE('_',39)


	   Endif

      // itens
      @nLin,00 PSAY TMPX->ZZ4_BOBINA
      @nLin,14 PSAY TRANSFORM(TMPX->ZB9_SALDO ,"@E 999.999")                                   
      @nLin,24 PSAY TMPX->ZZ4_MAQ
      @nLin,32 PSAY TMPX->ZZ4_CODPI
      @nLin++	

      nCnt+=1
	  TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   
   EndDo
   
   
   @nLin++	
      
EndDo
    
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


***************

Static Function ValidPerg(cPerg)

***************

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

PutSx1( cPerg, '01', 'Contagem:' , '', '', 'mv_ch1', 'C', 06, 0, 0, 'G', '', '', '', ''   , 'mv_par01',    '', '', '', '',            '', '', '',           '', '', '', '', '', '', '', '', '', aHelpPor, aHelpEng, aHelpSpa )


Return NIL


***************

Static Function fPI(cCodBo)

***************

Local cQry:=''
local cRet:=" "

cQry:="SELECT C2_PRODUTO CODPI "
cQry+="FROM Z00020 Z00,SC2020 SC2 "
cQry+="WHERE SUBSTRING(Z00_OP,1,6)+Z00_SEQ='"+cCodBo+"' "
cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQry+="AND Z00.D_E_L_E_T_='' "
cQry+="AND SC2.D_E_L_E_T_='' "

If Select("AUX7") > 0
  DbSelectArea("AUX7")
  AUX7->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX7"

iF  ! AUX7->( EOF() )
    
    cRet:= AUX7->CODPI

ENDIF


return cRet


***************

Static Function fQtdProd(cProd)

***************

local cQry:=" "
LOCAL nRet:=0

cQry:="select COUNT(*) TOTAL  from ZZ4020 ZZ4 "
cQry+="where D_E_L_E_T_='' "
cQry+="AND ZZ4_CONTAG='"+MV_PAR01+"' "
IF !EMPTY(cProd)
   cQry+="and ZZ4_CODIGO='"+cProd+"' "
ENDIF

If Select("TABY") > 0
	DbSelectArea("TABY")
	TABY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TABY'                      

if TABY->(!Eof())

   nRet:=TABY->TOTAL 

ENDIF

TABY->(dbclosearea())

Return nRet
