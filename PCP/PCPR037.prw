#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCPR037   � Autor � Gustavo Costa      � Data �  08/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Diverg�ncia na velocidade de maquina.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR037()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Diverg�ncia na Velocidade de m�quina "
	Local cPict          := ""
	Local titulo         := "Diverg�ncia na Velocidade de m�quina "
	Local nLin           := 80
                       //          10        20        30        40        50        60        70                   80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678900123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Local Cabec1         := " M�q.   Dt.Fat       Hora      Lado    Produto  Desc.                                                       B/M ou Kg/h      Vel. Pad.   OBS "
	Local Cabec2         := "                                                                                                                                                                (Kg)             (kg)               (KG)                    "
	Local imprime        := .T.
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "PCPR037" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "PCPR037" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := ""

	Pergunte('PCP037',.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

	wnrel := SetPrint(cString,NomeProg,"PCP037",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	titulo         := "Diverg�ncia(s) de: "+DTOC(MV_PAR01)+' ate: '+DTOC(MV_PAR02)

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
	Local cQry:=''
	local cNum:=''
	local nCnt:=1
	local nSaldoAtu:=0
	local nQtdCart:=0
	Local lImp		:= .F.
	Local cResult	:= ""

	cQry:=" SELECT B1_GRUPO, B1_SETOR, B1_DESC, B1_TIPO, B5_LARGFIL, Z.* FROM Z92020 Z WITH (NOLOCK) "
	cQry+=" INNER JOIN SB1010 B WITH (NOLOCK) "
	cQry+=" ON Z92_PRODUT = B1_COD "
	cQry+=" INNER JOIN SB5010 B5 WITH (NOLOCK) " 
	cQry+=" ON Z92_PRODUT = B5_COD "
	cQry+=" WHERE B.D_E_L_E_T_ <> '*' "
	cQry+=" AND Z.D_E_L_E_T_ <> '*' "
	cQry+=" AND B5.D_E_L_E_T_ <> '*' " 
	cQry+=" AND Z92_DATA BETWEEN '" + DTOS(MV_PAR01)+"' AND '" + DTOS(MV_PAR02) + "' "
	cQry+=" AND Z92_RECURS BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQry+=" ORDER BY Z92_RECURS, Z92_DATA "

	If Select("TMPX") > 0
		DbSelectArea("TMPX")
		DbCloseArea()
	EndIf

	TCQUERY cQry NEW ALIAS "TMPX"


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

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	TMPX->(dbGoTop())
	While TMPX->(!EOF())
	   
   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
       
		Do case
	   
		Case Alltrim(TMPX->B1_GRUPO) $ 'E/D' // Domestica
	   			
			If TMPX->Z92_BATMIN > 65
				cResult	:= "Maior"
				lImp		:= .T.
				nBatPad	:= 65
			EndIf
			If TMPX->Z92_BATMIN < 65
				cResult	:= "Menor"
				lImp		:= .T.
				nBatPad	:= 65
			EndIf
	   		
		Case Alltrim(TMPX->B1_GRUPO) $ 'A/B/G' // Institucional
	   		
			If TMPX->Z92_BATMIN > 70
				cResult	:= "Maior"
				lImp		:= .T.
				nBatPad	:= 70
			EndIf
			If TMPX->Z92_BATMIN < 70
				cResult	:= "Menor"	
				lImp		:= .T.
				nBatPad	:= 70
			EndIf
	   		
		Case Alltrim(TMPX->B1_GRUPO) $ 'C' .And. Alltrim(TMPX->B1_SETOR) $ '08/09/10/11/12/13/14/30/34/35/36/41/55' // Infectante
	   			
			If TMPX->Z92_BATMIN > 65
				cResult	:= "Maior"
				lImp		:= .T.
				nBatPad	:= 65
			EndIf
			If TMPX->Z92_BATMIN < 65
				cResult	:= "Menor"
				lImp		:= .T.
				nBatPad	:= 65
			EndIf

		Case Alltrim(TMPX->B1_TIPO) $ 'PI' // Extrusoras
	   		
			Do case
			
			Case AllTrim(TMPX->Z92_RECURS) == "E01"
			
				If TMPX->B5_LARGFIL >= 173

					If TMPX->Z92_BATMIN > 173
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 173
					EndIf
					If TMPX->Z92_BATMIN < 173
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 173
					EndIf

				Else

					If TMPX->Z92_BATMIN > 145
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 145
					EndIf
					If TMPX->Z92_BATMIN < 145
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 145
					EndIf
				
				EndIf

			Case AllTrim(TMPX->Z92_RECURS) == "E02"
			
				If TMPX->B5_LARGFIL >= 153

					If TMPX->Z92_BATMIN > 153
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 153
					EndIf
					If TMPX->Z92_BATMIN < 153
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 153
					EndIf

				Else

					If TMPX->Z92_BATMIN > 129
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 129
					EndIf
					If TMPX->Z92_BATMIN < 129
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 129
					EndIf
				
				EndIf

			Case AllTrim(TMPX->Z92_RECURS) == "E03"
			
				If TMPX->B5_LARGFIL >= 135

					If TMPX->Z92_BATMIN > 135
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 135
					EndIf
					If TMPX->Z92_BATMIN < 135
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 135
					EndIf

				Else

					If TMPX->Z92_BATMIN > 113
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 113
					EndIf
					If TMPX->Z92_BATMIN < 113
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 113
					EndIf
				
				EndIf

			Case AllTrim(TMPX->Z92_RECURS) $ "E04"
			
				If TMPX->B5_LARGFIL >= 115

					If TMPX->Z92_BATMIN > 115
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 115
					EndIf
					If TMPX->Z92_BATMIN < 115
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 115
					EndIf

				Else

					If TMPX->Z92_BATMIN > 97
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 97
					EndIf
					If TMPX->Z92_BATMIN < 97
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 97
					EndIf
				
				EndIf
			
			Case AllTrim(TMPX->Z92_RECURS) $ "E05"
			
				If TMPX->B5_LARGFIL >= 96

					If TMPX->Z92_BATMIN > 96
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 96
					EndIf
					If TMPX->Z92_BATMIN < 96
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 96
					EndIf

				Else

					If TMPX->Z92_BATMIN > 81
						cResult	:= "Maior"
						lImp		:= .T.
						nBatPad	:= 81
					EndIf
					If TMPX->Z92_BATMIN < 81
						cResult	:= "Menor"	
						lImp		:= .T.
						nBatPad	:= 81
					EndIf
				
				EndIf
			
			EndCase

		EndCase
	   	//" M�q.   Dt.Fat    Hora    Lado    Velocidade    Produto   B/M ou Kg/h   OBS "
		If lImp
		   // Coloque aqui a logica da impressao do seu programa...
		   // Utilize PSAY para saida na impressora. Por exemplo:	    
			@nLin,00 PSAY TMPX->Z92_RECURS
			@nLin,08 PSAY DTOC(STOD(TMPX->Z92_DATA))
			@nLin,21 PSAY TMPX->Z92_HORA
			@nLin,30 PSAY TMPX->Z92_LADO
			@nLin,35 PSAY TMPX->Z92_PRODUT + ' - ' + TMPX->B1_DESC
			@nLin,107 PSAY Transform(TMPX->Z92_BATMIN, "@E 999")
			@nLin,117 PSAY cResult
			@nLin,127 PSAY Transform(nBatPad, "@E 999")
			@nLin,137 PSAY TMPX->Z92_OBS
			nLin := nLin + 1 // Avanca a linha de impressao
		 
			lImp		:= .F.
		 
		EndIf
		TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   
	EndDo

	TMPX->(DBCLOSEAREA())

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

