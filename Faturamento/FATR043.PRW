#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function FATR043

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR043   � Autoria� Fl�via Rocha      � Data �  10/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio das Coletas Realizadas (SF2->F2_DTEXP)           ���
���Solicitado por: 00000629 - Emanuel                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Log�stica                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "COLETA DE NOTAS FISCAIS"
Local cPict          := ""
Local titulo       := "COLETA DE NOTAS FISCAIS"
Local nLin         := 80

Local Cabec1       := "NF/Serie       DT.EMISSAO DT.EXPED.       COLETA FEITA:                CLIENTE                    TRANSPORTADORA                       PREV.CHEGADA"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "FATR043" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATR043" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FATR043"
Private cString := "SF2"

//dbSelectArea("SF2")
//dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
Pergunte(cPerg, .T.)

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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  10/03/14   ���
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
Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local cColeta := ""     

cQuery := "Select " + LF
cQuery += " * " + LF
cQuery += " From " + LF
cQuery += "   " + RetSqlName("SF2") + " SF2 " + LF
cQuery += " , " + RetSqlName("SA1") + " SA1 " + LF
cQuery += " , " + RetSqlName("SA4") + " SA4 " + LF
cQuery += " , " + RetSqlName("SZZ") + " SZZ " + LF

cQuery += " Where " + LF
cQuery += " SF2.F2_CLIENTE = SA1.A1_COD " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF
cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " + LF
cQuery += " and SF2.F2_LOCALIZ = SZZ.ZZ_LOCAL " + LF
cQuery += " and SF2.F2_FILIAL = SZZ.ZZ_FILIAL " + LF
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF

///par�metros:
If !Empty(MV_PAR02)  //NOTA FISCAL DE/AT�
	cQuery += " and SF2.F2_DOC >= '" + Alltrim(MV_PAR01) + "' " + LF 
	cQuery += " and SF2.F2_DOC <= '" + Alltrim(MV_PAR02) + "' " + LF 
Endif
cQuery += " and SF2.F2_DTEXP <> '' " + LF //data expedi��o n�o pode estar em branco

If !Empty(MV_PAR04) //DATA COLETA DE/AT�
	cQuery += " and SF2.F2_DTEXP >= '" + Dtos(MV_PAR03) + "' " + LF 
	cQuery += " and SF2.F2_DTEXP <= '" + Dtos(MV_PAR04) + "' " + LF 
Endif

If MV_PAR05 = 2 //NO PRAZO
	cQuery += " and (SF2.F2_DTEXP - SF2.F2_EMISSAO) <= 1 " + LF
Elseif MV_PAR05 = 3 //FORA PRAZO
	cQuery += " and (SF2.F2_DTEXP - SF2.F2_EMISSAO) > 1 " + LF
Endif

cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' " + LF

cQuery += " and SF2.D_E_L_E_T_ = '' " + LF
cQuery += " and SA1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA4.D_E_L_E_T_ = '' " + LF
cQuery += " and SZZ.D_E_L_E_T_ = '' " + LF
MEMOWrite("C:\TEMP\FATR043.SQL", cQuery )
If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TEMP1"
TCSetField( "TEMP1", "F2_EMISSAO", "D")
TCSetField( "TEMP1", "F2_DTEXP", "D")
TCSetField( "TEMP1", "F2_PREVCHG", "D")
TCSetField( "TEMP1", "F2_REALCHG", "D")



//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//SetRegua(RecCount())

If !TEMP1->(EOF())

	TEMP1->(dbGoTop())
	While !EOF()

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
	   
	   If(TEMP1->F2_DTEXP - TEMP1->F2_EMISSAO) > 1 
	   		cColeta := "Fora do Prazo  " 
	   Else
	   		cColeta := "Dentro do Prazo"
	   Endif
	   //"NF/Serie       DT.EMISSAO      DT.EXPED.        CLIENTE                                  TRANSPORTADORA         PREV.CHEGADA"
	   @nLin,000 PSAY TEMP1->F2_DOC + '/' + TEMP1->F2_SERIE
	   @nLin,016 PSAY DTOC(TEMP1->F2_EMISSAO)
	   @nLin,027 PSAY DTOC(TEMP1->F2_DTEXP) 
	   @nlin,038 PSAY cColeta
	   @nLin,059 PSAY TEMP1->A1_COD + '/' + TEMP1->A1_LOJA + '-' + SUBSTR(TEMP1->A1_NOME,1,25)
	   @nLin,097 PSAY SUBSTR(TEMP1->A4_NREDUZ,1,20)
	   @nLin,121 PSAY DTOC(TEMP1->F2_PREVCHG)
	   @nLin,132 PSAY DTOC(TEMP1->F2_REALCHG)
	   
	  	
	   nLin++
	
	   TEMP1->(dbSkip())
	EndDo        
	DbSelectArea("TEMP1")
	DbCloseArea()
Endif
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
