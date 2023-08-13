#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MATR110()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LEND,WNREL,CDESC1,CDESC2,CDESC3,NBASEIPI")
SetPrvt("CSTRING,TAMANHO,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("NBEGIN,ALINHA,CPERG,ASENHAS,AUSUARIOS,NHDLALCA")
SetPrvt("NTAMALCA,NLIDOS,CREGISTRO,NREEM,NORDER,CCONDBUS")
SetPrvt("NSAVREC,ASAVREC,LIMITE,LI,NTOTNOTA,NTOTIPI")
SetPrvt("NDESCPROD,NTOTAL,NUMPED,NTIPO,NORDEM,COBS01")
SetPrvt("COBS02,COBS03,COBS04,LLIBERADOR,NCW,CVAR")
SetPrvt("I,CDESC,NLINREF,CDESCRI,NLINHA,MV_PAR06")
SetPrvt("BBLOCO,BBLOCO1,BBLOCO2,_CBLOCO,_CBLOCO1,_CBLOCO2")
SetPrvt("NK,LIMPLEG,NTOTDESC,NQUEBRA,LNEWALC,CCOMPRADOR")
SetPrvt("CALTER,CAPROV,LLIBER,CMENSAGEM,CALIAS,NREGISTRO")
SetPrvt("COBS,NX,NTOTGERAL,CLIBERADOR,NPOSICAO,CSENHAA")
SetPrvt("NAUXLIN,CCGCPICT,CCEPPICT,EXPC1,EXPC2,C110CENTER")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     #DEFINE PSAY SAY
#ENDIF

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ��
//���Fun��o    � MATR110  � Autor � Wagner Xavier         � Data � 05.09.91 ���
//�������������������������������������������������������������������������Ĵ��
//���Descri��o � Emissao do Pedido de Compras                               ���
//�������������������������������������������������������������������������Ĵ��
//��� Uso      � Generico                                                   ���
//�������������������������������������������������������������������������Ĵ��
//��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
//�������������������������������������������������������������������������Ĵ��
//��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
//�������������������������������������������������������������������������Ĵ��
//���Edson  M.     �18/06/98�16597A�Acerto dos parametros de impressao.     ���
//���Marcos Simidu �07/06/98�XXXXXX�Acerto de bound error aSavRec.          ���
//���Edson  M.     �13/08/98�16980A�Correcao no calculo do IPI.             ���
//���Bruno         �09/12/98�melhor�Modificacao para a impressao da AE (ARG)���
//���Edson   M.    �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ���
//���Fernando Joly �20/04/99�XXXXXX�Consistir SC's Firmes e Previstas.      ���
//�������������������������������������������������������������������������Ĵ��
//���Rdmake 2/4.07 �  Autor � Walter C. Silva   � Data �     03/12/99       ���
//��������������������������������������������������������������������������ٱ�
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

lEnd     := .F.
wnrel    := "MATR110"
cDesc1   := "Emissao dos pedidos de compras ou autorizacoes de entrega"
cDesc2   := "cadastradados e que ainda nao foram impressos"
cDesc3   :=  " "
nBaseIPI := 0
cString  := "SC7"

tamanho  :="M"
titulo   :="Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="MATR110"
nLastKey := 0
nBegin   :=0
aLinha   :={ }
cPerg    :="MTR110"
aSenhas  :={}
aUsuarios:={}

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01               Do Pedido                             �
//� mv_par02               Ate o Pedido                          �
//� mv_par03               A partir da data de emissao           �
//� mv_par04               Ate a data de emissao                 �
//� mv_par05               Somente os Novos                      �
//� mv_par06               Campo Descricao do Produto    	     �
//� mv_par07               Unidade de Medida:Primaria ou Secund. �
//� mv_par08               Imprime ? Pedido Compra ou Aut. Entreg�
//� mv_par09               Numero de vias                        �
//� mv_par10               Pedidos ? Liberados Bloqueados Ambos  �
//� mv_par11               Impr. SC's Firmes, Previstas ou Ambas �
//����������������������������������������������������������������

Pergunte("MTR110",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

If mv_par08 == 1

	//��������������������������������������������������������������Ŀ
	//� Le o Arquivo de Alcadas.                                     �
	//����������������������������������������������������������������
/*
	If File(cArqAlca) .And. GetMV("MV_ALCADA") == "S"
		aUsuarios := {}
		aSenhas := {}
		nHdlAlca := FOPEN(cArqAlca,2)
		nTamAlca := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		nLidos := 0
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			AADD(aUsuarios,{ cRegistro } )
			AADD(aSenhas,{ SubStr(cRegistro,2,6) } )
         nLidos := nLidos + 82
		EndDo
		FCLOSE(nHdlAlca)
	EndIf
*/
        #IFDEF WINDOWS
               RptStatus({|| C110PC()},titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>                RptStatus({|| Execute(C110PC)},titulo)
        #ELSE
               C110PC()
        #ENDIF

Else

        #IFDEF WINDOWS
               RptStatus({|| C110AE()},titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>                RptStatus({|| Execute(C110AE)},titulo)
        #ELSE
               C110AE()
        #ENDIF

EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C110PC   � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function C110PC()
nReem    :=0
nOrder   :=0
cCondBus :=""
nSavRec  :=0
aSavRec  := {}

limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)

If ( cPaisLoc=="ARG" )
	cCondBus	:=	"1"+strzero(val(mv_par01),6)
	nOrder	:=	10
	nTipo		:= 1
Else
	cCondBus	:=mv_par01
	nOrder	:=	1
EndIf
dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)

//�������������������������������������������������������������������Ŀ
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������

@ 0,0 PSAY AvalImp(Limite+2)

While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02

	//��������������������������������������������������������������Ŀ
	//� Cria as variaveis para armazenar os valores do pedido        �
	//����������������������������������������������������������������

	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "

	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If C7_TIPO == 2
		dbSkip()
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Filtra Tipo de SCs Firmes ou Previstas                       �
	//����������������������������������������������������������������

	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf

	//����������������������������������������������������������Ŀ
	//� Verifica se Usuario definiu usar o Controle de Alcadas.  �
	//������������������������������������������������������������

	lLiberador := .F.
	If GetMV("MV_ALCADA") == "S"
		If !File(cArqAlca)
			lLiberador := .F.
		Else
			lLiberador := .T.
			If Empty(C7_CODLIB)
				dbSkip()
				Loop
			EndIf
		EndIf
	EndIf

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

		ImpCabec()

		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
      nTotNota := nTotNota + SC7->C7_VALFRE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM

      While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM == NumPed

			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			#IFNDEF WINDOWS
            If LastKey() == 286    //ALT_A
					lEnd := .t.
				EndIf
			#ENDIF
			If lEnd
            @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif

			IncRegua()

			//��������������������������������������������������������������Ŀ
			//� Verifica se havera salto de formulario                       �
			//����������������������������������������������������������������

			If li > 56
            nOrdem:=nOrdem+1
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif

         li:=li+1

			@ li,001 PSAY "|"
      @ li,002 PSAY Right( C7_ITEM,3)      Picture PesqPict("SC7","c7_item")
			@ li,005 PSAY "|"
			@ li,006 PSAY Left( C7_PRODUTO, 10 ) Picture PesqPict("SC7","c7_produto")

   		//��������������������������������������������������������������Ŀ
			//� Pesquisa Descricao do Produto                                �
			//����������������������������������������������������������������

			ImpProd()

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
            nDescProd:=nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
            nDescProd:=nDescProd+SC7->C7_VLDESC
      	Endif
			nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi:=nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2)

			//��������������������������������������������������������������Ŀ
			//� Inicializacao da Observacao do Pedido.                       �
			//����������������������������������������������������������������

      If SC7->C7_ITEM < "0005"
        cVar:="cObs"+Right( C7_ITEM,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif

			dbSkip()
		EndDo

		dbGoto(nSavRec)

		If li>38
			nOrdem:=nOrdem+1
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif
      FinalPed()             // Imprime os dados complementares do PC
	Next

	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif
	aSavRec := {}
	dbSkip()
EndDo

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C110AE   � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function C110AE()
nReem    :=0
nSavRec  :=0
aSavRec  := {}
limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)

dbSelectArea("SC7")
dbSetOrder(10)
dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)

SetRegua(Reccount())

//�������������������������������������������������������������������Ŀ
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������

@ 0,0 PSAY AvalImp(Limite+2)

While !Eof().And.C7_FILIAL == xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02

	//��������������������������������������������������������������Ŀ
	//� Cria as variaveis para armazenar os valores do pedido        �
	//����������������������������������������������������������������

	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "

	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If SC7->C7_TIPO != 2
		dbSkip()
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Filtra Tipo de SCs Firmes ou Previstas                       �
	//����������������������������������������������������������������

	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

		ImpCabec()
		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
      nTotNota := nTotNota +SC7->C7_VALFRE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM

      While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM == NumPed

			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif

			#IFNDEF WINDOWS
            If LastKey() == 286    //ALT_A
					lEnd := .t.
				EndIf
			#ENDIF

			If lEnd
            @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			IncRegua()

			//��������������������������������������������������������������Ŀ
			//� Verifica se havera salto de formulario                       �
			//����������������������������������������������������������������

			If li > 56
            nOrdem:=nOrdem+1
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif

         li:=li+1
			@ li,001 PSAY "|"
      @ li,002 PSAY Right( C7_ITEM, 3 )    Picture PesqPict("SC7","C7_ITEM")
			@ li,005 PSAY "|"
			@ li,006 PSAY Left( SC7->C7_PRODUTO, 10 )	Picture PesqPict("SC7","C7_PRODUTO")

			//��������������������������������������������������������������Ŀ
			//� Pesquisa Descricao do Produto                                �
			//����������������������������������������������������������������

			ImpProd()		// Imprime dados do Produto

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
            nDescProd:= nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
            nDescProd:=nDescProd+SC7->C7_VLDESC
			Endif
			nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi:=nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2)

			//��������������������������������������������������������������Ŀ
			//� Inicializacao da Observacao do Pedido.                       �
			//����������������������������������������������������������������

      If SC7->C7_ITEM < "0005"
        cVar:="cObs"+Right( C7_ITEM, 2 )
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			dbSkip()
		EndDo

		dbGoto(nSavRec)
		If li>38
         nOrdem:=nOrdem+1
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif
         FinalAE()              // dados complementares da Autorizacao de Entrega
	Next

	If Len(aSavRec)>0
		dbGoto(aSavRec[Len(aSavRec)])
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_EMITIDO With "S"
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			MsUnLock()
		Next
	Endif
	aSavRec := {}
	dbSkip()
End

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpProd  � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisar e imprimir  dados Cadastrais do Produto.         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ImpProd()
cDesc   := ""
nLinRef := 1
nBegin  := 0
cDescri := ""
nLinha  := 0

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao generica do Produto.                  �
//����������������������������������������������������������������

If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao cientifica do Produto.                �
//����������������������������������������������������������������

If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO) .and. ! Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " (" + Alltrim(A5_CODPRF) + ")"
EndIf
dbSelectArea("SC7")

//��������������������������������������������������������������Ŀ
//� Imprime da descricao selecionada                             �
//����������������������������������������������������������������

nLinha:= MLCount(cDescri,28)

@ li,016 PSAY "|"
@ li,017 PSAY MemoLine(cDescri,28,1)

ImpCampos()
For nBegin := 2 To nLinha
   li := li + 1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,016 PSAY "|"
	@ li,017 PSAY Memoline(cDescri,28,nBegin)
	@ li,046 PSAY "|"
	@ li,049 PSAY "|"
	@ li,063 PSAY "|"
   @ li,077 PSAY "|"
	If mv_par08 == 1
      @ li,084 PSAY "|"
      @ li,091 PSAY "|"
      @ li,105 PSAY "|"
      @ li,116 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
	Else
      @ li,086 PSAY "|"
      @ li,100 PSAY "|"
		@ li,111 PSAY "|"
		@ li,132 PSAY "|"
	EndIf
Next nBegin
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpCampos� Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir dados Complementares do Produto no Pedido.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpCampos(Void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ImpCampos()

bBloco :={|ny| iif(ny==1,"SC7->C7_UM",iif(!Empty(SC7->C7_SEGUM),"SC7->C7_SEGUM","SC7->C7_UM"))}
bBloco1:={|ny| iif(ny==1,"SC7->C7_QUANT",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_QTSEGUM","SC7->C7_QUANT"))}
bBloco2:={|ny| iif(ny==1,"SC7->C7_PRECO/(1+SC7->C7_ENCARGO/100)",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_TOTAL/SC7->C7_QTSEGUM/((1+SC7->C7_ENCARGO/100))","SC7->C7_PRECO/(1+SC7->C7_ENCARGO/100)"))}

@ li,046 PSAY "|"
_cBloco:=(Eval(bBloco,mv_par07))
@ li,047 PSAY &_cBloco  Picture PesqPict("SC7","C7_UM")
@ li,049 PSAY "|"
dbSelectArea("SC7")
_cBloco1:=(Eval(bBloco1,mv_par07))
@ li,050 PSAY &_cBloco1    Picture PesqPictQt("C7_QUANT",13)
@ li,063 PSAY "|"
_cBloco2:=(Eval(bBloco2,mv_par07))
@ li,065 PSAY &_cBloco2    Picture PesqPict("SC7","C7_PRECO",11)
@ li,077 PSAY "|"

If mv_par08 == 1
   @ li,078 PSAY SC7->C7_IPI                  Picture "@E 99.99"
   @ li,083 PSAY "%"
   @ li,084 PSAY "|"
   @ li,086 PSAY SC7->C7_ENCARGO              Picture "@E 99.9"
   @ li,090 PSAY "%"
   @ li,091 PSAY "|"
   @ li,092 PSAY SC7->C7_TOTAL                Picture PesqPict("SC7","C7_TOTAL",12)
   @ li,105 PSAY "|"
   @ li,106 PSAY SC7->C7_DATPRF               Picture PesqPict("SC7","C7_DATPRF")
   @ li,116 PSAY "|"
   @ li,117 PSAY Left( SC7->C7_CC, 6 )        Picture PesqPict("SC7","C7_CC")
	@ li,125 PSAY "|"
	@ li,126 PSAY SC7->C7_NUMSC
	@ li,132 PSAY "|"
Else
   @ li,081 PSAY SC7->C7_ENCARGO              Picture "@E 99.9"
   @ li,085 PSAY "%"
   @ li,086 PSAY "|"
   @ li,087 PSAY SC7->C7_TOTAL                Picture PesqPict("SC7","C7_TOTAL",11)
	@ li,100 PSAY "|"
	@ li,101 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
EndIf

nTotNota:=nTotNota+SC7->C7_TOTAL
nTotal  :=nTotal+SC7->C7_TOTAL

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FinalPed � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os dados complementares do Pedido de Compra        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FinalPed(Void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FinalPed()
nk         := 1
lImpLeg    := .T.
nTotDesc   := nDescProd
nQuebra    := 0
lNewAlc    := .F.
cComprador :=""
cAlter     :=""
cAprov     :=""
lLiber     := .F.

cMensagem  := Formula(C7_MSG)
nTotIPI    := NoRound(nTotIPI,2)
If !Empty(cMensagem)
        li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
* @ 41,051 PSAY "Obs. Favor dividir as duplicatas em parcelas de igual valor"
SB1->( Dbseek( xFilial( "SB1" ) + SC7->C7_PRODUTO ) )
If Alltrim( SB1->B1_TIPO ) $ 'MP /ME /MS /MI'
	While li<36 //While li<39
		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,016 PSAY "|"
		@ li,016 + nk PSAY "*"
		nk := IIf( nk == 32 , 1 , nk + 1 )
		@ li,046 PSAY "|"
		@ li,049 PSAY "|"
	  @ li,063 PSAY "|"
		@ li,077 PSAY "|"
		@ li,084 PSAY "|"
		@ li,091 PSAY "|"
		@ li,105 PSAY "|"
		@ li,116 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
		li:=li+1
	EndDo
	@ li,001 PSAY "|"
	@ li,005 PSAY "|**************************************************************************"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|* FAVOR COLOCAR NA OBS. DA NOTA: 'MATERIAL DESTINADO A INDUSTRIALIZACAO' *"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|**************************************************************************"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
ElseIf Alltrim( SB1->B1_TIPO ) $ 'AC /CR /EP /MC /MH /MQ /MR /MV /PR'
	While li<36 //While li<39
		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,016 PSAY "|"
		@ li,016 + nk PSAY "*"
		nk := IIf( nk == 32 , 1 , nk + 1 )
		@ li,046 PSAY "|"
		@ li,049 PSAY "|"
	  @ li,063 PSAY "|"
		@ li,077 PSAY "|"
		@ li,084 PSAY "|"
		@ li,091 PSAY "|"
		@ li,105 PSAY "|"
		@ li,116 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
		li:=li+1
	EndDo
	@ li,001 PSAY "|"
	@ li,005 PSAY "|************************************************************************"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|* FAVOR COLOCAR NA OBS. DA NOTA: 'MATERIAL DESTINADO AO CONSUMO FINAL' *"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|************************************************************************"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"

Else

	While li<39
		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,016 PSAY "|"
		@ li,016 + nk PSAY "*"
		nk := IIf( nk == 32 , 1 , nk + 1 )
		@ li,046 PSAY "|"
		@ li,049 PSAY "|"
		@ li,063 PSAY "|"
		@ li,077 PSAY "|"
		@ li,084 PSAY "|"
		@ li,091 PSAY "|"
		@ li,105 PSAY "|"
		@ li,116 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
		li:=li+1
	EndDo

	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,016 PSAY "|"
	@ li,016 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,046 PSAY "|"
	@ li,049 PSAY "|"
	@ li,063 PSAY "|"
	@ li,077 PSAY "|"
	@ li,084 PSAY "|"
	@ li,091 PSAY "|"
	@ li,105 PSAY "|"
	@ li,116 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"

EndIf

li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|                                      Obs. Favor dividir as duplicatas em parcelas de igual valor                                 |"

li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,015 PSAY "D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"

@ li,068 PSAY nTotDesc Picture tm(nTotDesc,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//��������������������������������������������������������������Ŀ
//� Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   �
//����������������������������������������������������������������

cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
dbGoto(nRegistro)

dbSelectArea( cAlias )
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li:=li+1
@ li,001 PSAY "|"
//@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,20)
//@ li,038 PSAY "|Data de Emissao|"
@ li,044 PSAY "| Emissao |"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
//@ li,038 PSAY "|"
@ li,044 PSAY "|"
//@ li,043 PSAY SC7->C7_EMISSAO
@ li,045 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| IPI   :"
@ li,094 PSAY nTotIpi         Picture tm(nTotIpi,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "| Frete :"
@ li,094 PSAY SC7->C7_VALFRE   Picture tm(SC7->C7_VALFRE,14)
@ li,132 PSAY "|"

//��������������������������������������������������������������Ŀ
//� Inicializar campos de Observacoes.                           �
//����������������������������������������������������������������

If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

dbSelectArea("SC7")
If !Empty(C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO == "L"
	lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+SCR->CR_NUM==xFilial("SCR")+SC7->C7_NUM
          cAprov :=cAprov + AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
	  			IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
	  dbSelectArea("SCR")
	  dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
            cAlter := cAlter +AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf

li:=li+1
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Grupo :"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "| Total Geral : "

nTotGeral:=nTotNota+nTotIpi-nTotDesc
If !lNewAlc
	@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
Else
	If lLiber
		@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
	Else
      @ li,080 PSAY ("     P E D I D O   B L O Q U E A D O ")
	EndIf
EndIf

@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1

If !lNewAlc
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
        @ li,061 PSAY "|           Liberacao do Pedido"
        @ li,102 PSAY "| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"+Replicate("-",59)
	@ li,061 PSAY "|"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"

        li:=li+1
	cLiberador := ""
	nPosicao := 0
	If lLiberador
		If SubStr(SC7->C7_CODLIB,1,6) == EnCript(cMestra,0)
			cLiberador := "Administrador"
		Else
			cSenhaA  := SubStr(SC7->C7_CODLIB,1,6)
			For nx := 1 To Len(aSenhas)
				If aSenhas[nx][1] == cSenhaA
					nPosicao := nx
					Exit
				EndIf
			Next
			If nPosicao > 0
				cLiberador := EnCript(SubStr(aUsuarios[nPosicao][1],8,30),1)
			EndIf
		EndIf
	EndIf
	@ li,001 PSAY "|"
        @ li,007 PSAY "Comprador"
	@ li,021 PSAY "|"
        @ li,026 PSAY "Solicitante"
	@ li,041 PSAY "|"
        @ li,046 PSAY "Diretoria"
	@ li,061 PSAY "|     ------------------------------"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"
	@ li,021 PSAY "|"
	@ li,041 PSAY "|"
        R110Center() // 30 posicoes
        @ li,061 PSAY "|     " + c110Center
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
        li:=li+1
        @ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
Else
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
        @ li,059 PSAY IF(lLiber,"     P E D I D O   L I B E R A D O","|     P E D I D O   B L O Q U E A D O !!!")
        @ li,102 PSAY "| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"+Replicate("-",99)
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"
        @ li,003 PSAY "Comprador Responsavel :"
	@ li,027 PSAY Substr(cComprador,1,60)
	@ li,088 PSAY "|"
	@ li,089 PSAY "BLQ:Bloqueado"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
        li:=li+1
	nAuxLin := Len(cAlter)
	@ li,001 PSAY "|"
        @ li,003 PSAY "Compradores Alternativos :"
	While nAuxLin > 0 .oR. lImpLeg
		@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY "Ok:Liberado"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
                nAuxLin := nAuxLin - 60
                li:=li+1
        EndDo
	nAuxLin := Len(cAprov)
	lImpLeg := .T.
	@ li,001 PSAY "|"
        @ li,003 PSAY "Aprovador(es) :"
	While nAuxLin > 0	.Or. lImpLeg
		@ li,019 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY "??:Aguar.Lib"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
                nAUxLin := nAUxLin -70
                li:=li+1
	EndDo
	If nAuxLin == 0
           li:=li+1
	EndIf
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
        li:=li+1
        @ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,132 PSAY "|"
        li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FinalAE  � Autor � Cristina Ogura        � Data � 05.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os dados complementares da Autorizacao de Entrega  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FinalAE(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FinalAE()
nk := 1
nTotDesc:= nDescProd
cMensagem:= Formula(C7_MSG)
nTotIPI := NoRound(nTotIPI,2)
If !Empty(cMensagem)
        li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,051 PSAY "|"
	@ li,054 PSAY "|"
	@ li,068 PSAY "|"
	@ li,083 PSAY "|"
	@ li,100 PSAY "|"
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
        li:=li+1
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//��������������������������������������������������������������Ŀ
//� Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   �
//����������������������������������������������������������������

cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
dbGoto(nRegistro)

dbSelectArea(cAlias)
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
dbSelectArea("SM4")
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| Total Geral : "

nTotGeral:=nTotNota+nTotIpi-nTotDesc

@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//��������������������������������������������������������������Ŀ
//� Inicializar campos de Observacoes.                           �
//����������������������������������������������������������������

If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li:=li+1
@ li,001 PSAY "| Observacoes: "
@ li,054 PSAY "| Comprador    "
@ li,070 PSAY "| Gerencia     "
@ li,085 PSAY "| Diretoria    "
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpRodape� Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o rodape do formulario e salta para a proxima folha���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpRodape(Void)   			           					        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 					                     						     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ImpRodape()
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,070 PSAY "Continua ..."
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=0
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpCabec � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o Cabecalho do Pedido de Compra                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpCabec(Void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ImpCabec()
cCGCPict:=""
cCEPPict:=""
@ 01,001 PSAY "|"
@ 01,002 PSAY Replicate("-",limite)
@ 01,132 PSAY "|"
@ 02,001 PSAY "|"
If mv_par08 == 1
        @ 02,045 PSAY "| P E D I D O  D E  C O M P R A S"
Else
        @ 02,045 PSAY "| A U T. D E  E N T R E G A     "
EndIf

//��������������������������������������������������������������Ŀ
//�Definir los pictures.                                         �
//����������������������������������������������������������������

If ( cPaisLoc=="ARG" )
	cCepPict:="@R 9999"
	cCGCPict:="@R 99-99.999.999-9"
Else
	cCepPict:="@R 99999-999"
	cCGCPict:="@R 99.999.999/9999-99"
EndIf
@ 02,079 PSAY IIf(nOrdem>1," - continuacao"," ")
If ( Mv_PAR08==2 )
	@ 02,090 PSAY "|"
	@ 02,093 PSAY SC7->C7_NUMSC + "/" + SC7->C7_NUM  //    Picture PesqPict("SC7","c7_num")
Else
@ 02,096 PSAY "|"
@ 02,101 PSAY SC7->C7_NUM      Picture PesqPict("SC7","c7_num")
EndIf

@ 02,107 PSAY "/"+Str(nOrdem,1)
@ 02,112 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissao "+Str(ncw,2)+"a.VIA","")
@ 02,132 PSAY "|"
@ 03,001 PSAY "|"
@ 03,003 PSAY SM0->M0_NOMECOM
@ 03,045 PSAY "|"+Replicate("-",86)
@ 03,132 PSAY "|"
@ 04,001 PSAY "|"
@ 04,003 PSAY SM0->M0_ENDENT + SM0->M0_COMPENT
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
@ 04,045 PSAY "|"
If ( cPaisLoc=="ARG" )
	@ 04,047 PSAY Substr(SA2->A2_NOME,1,40)+"  -  "+SA2->A2_COD
Else
   @ 04,047 PSAY Substr(SA2->A2_NOME,1,40)+"  -  "+SA2->A2_COD+" I.E.: "+SA2->A2_INSCR
EndIf
@ 04,132 PSAY "|"
@ 05,001 PSAY "|"
@ 05,003 PSAY "CEP :"+Trans(SM0->M0_CEPENT,cCepPict)+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ 05,045 PSAY "|"
@ 05,047 PSAY Left( SA2->A2_END, 40 )    		Picture PesqPict("SA2","A2_END")
@ 05,089 PSAY "-  "+Trim(SA2->A2_BAIRRO)	Picture "@!"
@ 05,132 PSAY "|"
@ 06,001 PSAY "|"
@ 06,003 PSAY "TEL: "+SM0->M0_TEL
@ 06,023 PSAY "FAX: "+SM0->M0_FAX
@ 06,045 PSAY "|"
@ 06,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
@ 06,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
@ 06,074 PSAY "CEP :"
@ 06,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")
@ 06,093 PSAY "CGC: "
@ 06,100 PSAY SA2->A2_CGC    		Picture PesqPict("SA2","A2_CGC")
@ 06,132 PSAY "|"
@ 07,001 PSAY "|"
@ 07,003 PSAY "CGC: "+ Transform(SM0->M0_CGC,cCgcPict)
@ 07,027 PSAY "IE:"+ InscrEst()
@ 07,045 PSAY "|"
@ 07,047 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ 07,069 PSAY "FONE: "
@ 07,075 PSAY Substr(SA2->A2_TEL,1,15)
@ 07,095 PSAY "FAX: "
@ 07,101 PSAY SA2->A2_FAX     Picture PesqPict("SA2","A2_FAX")
@ 07,132 PSAY "|"
@ 08,001 PSAY "|"
@ 08,002 PSAY Replicate("-",limite)
@ 08,132 PSAY "|"

If mv_par08 == 1
	@ 09,001 PSAY "|"
        @ 09,002 PSAY "Itm|"
        @ 09,006 PSAY "Codigo    "
        @ 09,016 PSAY "|Descricao do Material"
        @ 09,046 PSAY "|UM|  Quant."
*       @ 09,063 PSAY "|Valor Unitario|IPI|  Valor Total   |Data Fat. |  C.C.   | S.C. |"
        @ 09,063 PSAY "|  Valor Unit |  IPI | Enc. | Valor Total |Data Fat. |  C.C.  | S.C. |"
*                       9,999.999.99  99,99%  99.9% 9,999.999.99
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
Else
	@ 09,001 PSAY "|"
        @ 09,002 PSAY "Itm|"
        @ 09,006 PSAY "Codigo    "
        @ 09,016 PSAY "|Descricao do Material"
        @ 09,046 PSAY "|UM|  Quant."
*       @ 09,063 PSAY "|Valor Unitario|  Valor Total   |Data Fat| Numero da OP  "
        @ 09,063 PSAY "|  Valor Unit | Enc. | Valor Total |Data Fat| Numero da OP  "
*                       9,999.999.99  99.99% 9,999.999.99
	@ 09,132 PSAY "|"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
EndIf
dbSelectArea("SC7")
li := 10
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R110Center� Autor � Jose Lucas            � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Centralizar o Nome do Liberador do Pedido.                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := R110CenteR(ExpC2)                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Nome do Liberador                                 ���
���Parametros� ExpC2 := Nome do Liberador Centralizado                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function R110Center()
c110Center:= Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador)
Return

