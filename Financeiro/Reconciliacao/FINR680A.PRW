#include "FINR680A.CH"
#Include "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR680A � Autor � Alessandro de Farias  � Data � 11.03.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Extrato Bancario - Via CNAB                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR680A                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Substitui o extrato padrao do sistema                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FINR680A()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cDesc1 := STR0001  //"Este relat�rio ir� emitir o extrato bancario via padr�o CNAB."
LOCAL cDesc2 := STR0002  //"Para que o mesmo seja emitido, dever� ser efetuado a configu-"
LOCAL cDesc3 := STR0003  //"ra��o conforme documenta��o do banco."
LOCAL cString:="SE5"
LOCAL Tamanho:="M"

PRIVATE titulo := OemToAnsi(STR0004)  //"Extrato Bancario - Via CNAB"
PRIVATE cabec1 := OemToAnsi(STR0005)  //"DATA      DOCUM     HISTORICO                             CREDITO              DEBITO               SALDO"
PRIVATE cabec2 := "" , wnrel
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog := "FINR680A"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "FIN680"

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������
pergunte("FIN680",.F.)

//������������������������������������������Ŀ
//� Variaveis utilizadas para parametros 		�
//� mv_par01       // Do Banco         	   �
//� mv_par02       // Da Agencia       	   �
//� mv_par03       // Da Conta       	      �
//� mv_par04       // Arquivo Config   	   �
//� mv_par05       // Arquivo Extrato  	   �
//� mv_par06       // Padrao Banco/Febraban  �
//��������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="FINR680A"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa680Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � FA680Imp � Autor � Lu�s C. Cunha         � Data � 05/11/93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Retorno do Extrato Banc�rio                                ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function FA680Imp(lEnd,wnRel,cString)

LOCAL CbTxt := space(10)
LOCAL CbCont := 0
LOCAL tamanho := "M"
LOCAL nHdlConf
LOCAL nHdlBco
LOCAL cData, dData , nValor , nTotCred , nTotDeb
LOCAL nLidos := 0
LOCAL aPosicoes:={ }
LOCAL nSaldoInicial := 0
Local lFebraban := .F.
Local cSitLanc := ""
Local cCtaArq := ""
Local cAgeArq := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//��������������������������������������������������������������Ŀ
//� Posiciona no cadastro de bancos.                             �
//����������������������������������������������������������������
If ! (SA6->(dbSeek( xFilial("SA6")+mv_par01+mv_par02+mv_par03 ) ) )
	Set Device To Screen
	Help(" ",1, "AFR680BCO" )
	Return
Endif
dbSelectArea("SEE")
If ! SEE->(dbSeek(xFilial("SEE")+mv_par01+mv_par02+mv_par03+"001"))
	Set Device To Screen
	Help(" ",1,"PAR150")
	Return .F.
Endif
//��������������������������������������������������������������Ŀ
//� Caso esteja usando configuracao 240 bytes/linha p/bancos	  �
//����������������������������������������������������������������
If mv_par06 == 1
	lFebraban := IIF(EE_BYTESXT > 200 , .t., .f.)
	lFebraban := .f.  // travar para 200 posicoes
Endif
//��������������������������������������������������������������Ŀ
//� Abertura do arquivo Configurador.                            �
//����������������������������������������������������������������
nHdlConf := Fopen(mv_par04 ,64)
If nHdlConf < 0
	Set Device To Screen
	Help(" ",1, "AFR680CFG" )
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Abertura do arquivo Configurador.                            �
//����������������������������������������������������������������
nHdlBco := Fopen( mv_par05 ,64)
If nHdlBco < 0
	Set Device To Screen
	Help(" ",1, "AFR680BCO" )
	Return
Endif

//����������������������������Ŀ
//� L� arquivo de configura��o �
//������������������������������
nLidos:=0
Fseek(nHdlConf,0,0)
nTamArq:=FSEEK(nHdlConf,0,2)
Fseek(nHdlConf,0,0)

While nTamArq >= 0
	
	//�������������������������������������������Ŀ
	//� Verifica o tipo de qual registro foi lido �
	//���������������������������������������������
	xBuffer:=Space(85)
	FREAD(nHdlConf,@xBuffer,85)
	If mv_par06 == 1   // Padrao bancos
		IF SubStr(xBuffer,1,1) == CHR(1)
			nTamArq-=85
			Loop
		EndIF
	Endif
	Aadd( aPosicoes, { Substr(xBuffer,2,15),Val(Substr(xBuffer,17,3)),;
	1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3))) })
	nTamArq -=85
Enddo

nTamArq := Fseek( nHdlBco,0, 2 )
Fseek( nHdlBco, 0, 0 )
nBytes := 0
li := 80  // Inicia com quebra de cabecalho
nTamLin := IIF(SEE->EE_BYTESXT > 0, 202, 202 ) // SEE->EE_BYTESXT + 2
xBuffer := Space(nTamLin)				// Registro Header
Fread( nHdlBco, @xBuffer, nTamLin )

SetRegua(nTamArq/Len(xBuffer))

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )

While .T.
	
	xBuffer := Space( nTamLin )			// Lancamentos
	Fread( nHdlBco, @xBuffer, nTamLin )
	
	If	Empty(xBuffer)
		Exit
	Endif
	
	If (lFebraban .And.(SubStr(xBuffer,8,1 ) == "1")) .Or. (!lFebraban .And. SubStr(xBuffer,1,1) == "1" .And. SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "0")
		If li + 5 > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
		Endif
		
		//li++
		@ li,00 PSAY repl("*",16)
		@ li,35 PSAY repl("*",45)
		li++
		
		cAgeArq := SubStr(xBuffer,aPosicoes[2,2],aPosicoes[2,3] )
		cCtaArq := SubStr(xBuffer,aPosicoes[3,2],aPosicoes[3,3] )
		
		@ li, 00 PSAY cAgeArq + "/"+ cCtaArq
		
		@ li, 35 PSAY OemToAnsi(STR0008)  //"SALDO INICIAL EM "
		If mv_par06 == 1  //Bancos
			cData := SubStr(xBuffer,aPosicoes[6,2],aPosicoes[6,3] )
		ElseIf mv_par06 == 2 // Febraban
			cData := SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3] )
		Endif
		cData :=ChangDate(cData,SEE->EE_TIPODAT)
		dData := CtoD(Substr( cData,1,2)+"/"+;
		SubStr( cData,3,2)+"/"+;
		SubStr( cData,5,2)/*,"ddmmyy"*/ )
		
		@ li, 52 PSAY dData
		
		cSitLanc := IIF ( mv_par06 == 1 ,;
		SubStr(xBuffer,aPosicoes[7,2],aPosicoes[7,3] ),;
		SubStr(xBuffer,aPosicoes[5,2],aPosicoes[5,3] ) )
		
		nSaldoInicial := IIF ( mv_par06 == 1 ,;
		Val(SubStr(xBuffer,aPosicoes[5,2],aPosicoes[5,3] ))/100 ,;
		Val(SubStr(xBuffer,aPosicoes[3,2],aPosicoes[3,3] ))/100 )
		
		@ li,    Iif( cSitLanc == "C", 85,105 ) PSAY nSaldoInicial Picture "@E 9999,999,999.99"
		li++
		@ li,00 PSAY repl("*",16)
		@ li,35 PSAY repl("*",45)
		IncRegua()
		li++
		nSaldoInicial *= Iif( cSitLanc == "C", 1,-1) // Inverte o sinal, caso o saldo inicial seja negativo.
		
	ElseIf (lFebraban .And.(SubStr(xBuffer,8,1 ) == "3")) .Or. (!lFebraban .And. SubStr(xBuffer,1,1) == "1" .And. SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "1")
		
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
		Endif
		
		cCodMov	:=Substr(xBuffer,aPosicoes[11,2],aPosicoes[11,3])
		dbSelectArea("SEJ")
		If dbSeek(xFilial("SEJ")+mv_par01+cCodMov)
			cSitLanc := SEJ->EJ_DEBCRE
		Else
			Help(" ",1,"FA470OCOR",, "C�digo da ocorr�ncia: " + cCodMov + " Codigo do banco: " + mv_par01, 4, 0)
			lSaida := .T.
			Exit
		Endif
		
		cData := SubStr(xBuffer,aPosicoes[9,2],aPosicoes[9,3] )
		cData := ChangDate(cData,SEE->EE_TIPODAT)
		dData := CtoD(Substr( cData,1,2)+"/"+;
		SubStr( cData,3,2)+"/"+;
		SubStr( cData,5,2)/*,"ddmmyy"*/ )
		cNum  := SubStr(xBuffer,aPosicoes[8,2],aPosicoes[8,3] )
		cDesc := SubStr(xBuffer,aPosicoes[12,2],aPosicoes[12,3] )
		nValor := Val(SubStr(xBuffer,aPosicoes[10,2],aPosicoes[10,3] ))/100
		If cSitLanc == "C"
			nSaldoInicial += nValor
		Else
			nSaldoInicial -= nValor
		Endif
		
		@ li,00 PSAY dData
		@ li,10 PSAY cNum
		@ li,20 PSAY Substr(cDesc,1,30) //+SubStr(xBuffer,106, 25 )
		@ li, Iif( cSitLanc == "C"  ,85,105) PSAY nValor Picture "@E 9999,999,999.99"
//		@ li,105 PSAY nSaldoInicial Picture "@E 9999,999,999.99"
		li++
		IncRegua()
		
	ElseIf (lFebraban .And.(SubStr(xBuffer,8,1 ) == "5")) .Or. (SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "2" .And. !lFebraban)
		
		@ li,35 PSAY repl("*",45)
		IncRegua()
		li++
		cSitLanc := SubStr(xBuffer,aPosicoes[16,2],aPosicoes[16,3] )
		nValor := Val(SubStr(xBuffer,aPosicoes[15,2],aPosicoes[15,3] ))/100
		cData := SubStr(xBuffer,aPosicoes[14,2],aPosicoes[14,3] )
		cData := ChangDate(cData,SEE->EE_TIPODAT)
		dData := CtoD(Substr( cData,1,2)+"/"+;
		SubStr( cData,3,2)+"/"+;
		SubStr( cData,5,2)/*,"ddmmyy"*/ )
		
		@ li, 35 PSAY "SALDO FINAL EM "
		@ li, 52 PSAY dData
		@ li,    Iif( cSitLanc == "C", 85, 105)  PSAY nValor Picture "@E 9999,999,999.99"
		li++
		
		If lFebraban
			nTotCred := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
			nTotDeb  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
			@ li,35 PSAY OemToAnsi(STR0009)  //"TOTAL CREDITOS"
			@ li,65 PSAY nTotCred Picture "@E 9999,999,999.99"
			IncRegua()
			li++
			@ li,35 PSAY OemToAnsi(STR0010)  //"TOTAL DEBITOS "
			@ li,65 PSAY nTotDeb Picture "@E 9999,999,999.99"
			li++
			@ li,35 PSAY repl("*",45)
			li++
		Endif
	ElseIf (SubStr(xBuffer,1,1) == "9" .And. !lFebraban)
		nTotCred := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
		nTotDeb  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
		@ li,35 PSAY OemToAnsi(STR0009)  //"TOTAL CREDITOS"
		@ li,65 PSAY nTotCred Picture "@E 9999,999,999.99"
		IncRegua()
		li++
		@ li,35 PSAY OemToAnsi(STR0010)  //"TOTAL DEBITOS "
		@ li,65 PSAY nTotDeb Picture "@E 9999,999,999.99"
		li++
		@ li,35 PSAY repl("*",45)
		li++
	Endif
Enddo

Roda(cbcont,cbtxt,"M")
Set( 20, "SCREEN" )
Fclose( nHdlBco )  // Fecha sequencial enviado pelo banco
Fclose( nHdlConf ) // Fecha sequencial do configurador
If aReturn[5] = 1
	Set( 24, "" )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()