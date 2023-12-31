#include "rwmake.ch"

*Private nHandle := -1
*Private cHndCTI := "-1"
*nRet := U_XDiskNumber( 24, "0,21255972", "" )
*Return NIL

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �SGDiskNumber � Autor �Fabio Rogerio Pereira  � Data �06/07/01  ���
����������������������������������������������������������������������������Ĵ��
���Descri��o �Executa a comunicacao com CTI/MODEM para a discagem            ���
����������������������������������������������������������������������������Ĵ��
���Uso       �SIGA                                               ���
����������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 -> Numero da Solicitacao do Recurso                     ���
���          � ExpC1 -> Numero do Telefone a ser discado                     ���
���          � ExpC2 -> Modelo da CTI                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function XDiskNumber(nTipSol,cTel,cCTI)
Local nRet    := 0
Local aBuffer := {}

//����������������������������������������������������Ŀ
//�Envia os dados para a CTI/MODEM executar a discagem.�
//������������������������������������������������������
cTel:= AllTrim(cTel)
nRet:= XSendCti( nTipSol, {cTel}, @aBuffer)

//��������������������������������Ŀ
//�Fecha a comunicacao com o MODEM.�
//����������������������������������
*If nRet == 0 .And. Empty(cCTI)
*  Aviso("",OemToAnsi("Discando para " + cTel + " ..." ),{OemToAnsi("Desligar")} ) //"Discando para " "Desligar"
*  XSendCti( 25, {}, @aBuffer)
*EndIf

Return(nRet)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o  �SGSendCti()  � Autor�Fabio Rogerio Pereira�Data  � 28/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envia os dados da solicitacao para a CTI atraves da SIGACTI���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := SGSendCti( ExpN1 )                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso    � SIGA                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function XSendCti( nTipSol, aParam, aBuffer)
Local i      := 0
Local cParam := ""
Local cDirTX := GetMv("MV_TMKCTTX")
Local cDirRX := GetMv("MV_TMKCTRX")
Local cBuffer:= Space(500)
Local nRet   := 0

//�����������������������������Ŀ
//�Abre a comunicacao com a DLL.�
//�������������������������������
If XCheckDLL()

  //����������������������Ŀ
  //�Envia dados para a CTI�
  //������������������������
  If (nHandle >= 0)
    cParam := cHndCTI + "|" + __cUserID + "|" + cDirTX + "|" + cDirRX + "|"

    If (Len(aParam) > 0)

      For i:= 1 To Len(aParam)
        cParam += aParam[i] + "|"
      Next
    EndIf

    cBuffer:= cParam+Space(500-Len(cParam))
    nRet:= ExeDllRun2( nHandle, nTipSol, cBuffer)
  EndIf

  XCheckRet(nRet,nTipSol,cBuffer,@aBuffer)
Endif

Return(nRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o  �SGCheckRet() � Autor�Fabio Rogerio Pereira�Data  � 30/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Avalia o retorno da solicitacao enviada para a CTI.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := SGSendCti( ExpN1, ExpN2, ExpC1 )            ���
�������������������������������������������������������������������������Ĵ��
��� Uso    � SIGA                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function XCheckRet(nRet, nTipSol, cBuffer, aBuffer)

//�������������������������Ŀ
//�Exibe a mensagem de erro.�
//���������������������������
aBuffer:= XReadBuf("|",cBuffer)
If (nRet > 0)
  if ( Len(aBuffer) >= 4 ) // Verifica se a mensagem esta completa
    Help(" ",1,"ERROCTI",,aBuffer[3] + " - " + aBuffer[4],3,5)
  else
    MsgStop("Erro no buffer")
  Endif

ElseIf (nRet < 0)
  Help(" ",1,"ERROCTI",,OemToAnsi("Erro na execucao da solicitacao!") + AllTrim(Str(nRet)) ,3,5) //"Erro na execucao da solicitacao!" "Retorno"
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o  �SGReadBuf    � Autor�Fabio Rogerio Pereira�Data  � 30/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Separa o retorno da solicitacao enviada para a CTI.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := SGReadBuf( ExpC1, ExpC2 )               ���
�������������������������������������������������������������������������Ĵ��
��� Uso    � SIGA                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function XReadBuf(cSep, cBuffer)
Local aBuffer:= {}
Local nPos   := 0
Local cString:= ""

//����������������������������������������������Ŀ
//�Separa as informacoes recebidas da SIGACTI.DLL�
//������������������������������������������������
For nPos:= 1 To Len(cBuffer)
  If (SubStr(cBuffer,nPos,1) == cSep)
    If !Empty(cString)
      Aadd(aBuffer,cString)
      cString:= ""
    EndIf
  Else
    cString+= SubStr(cBuffer,nPos,1)
  EndIf
Next

Return(aBuffer)



/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �SGCheckDLL�Autor  �Fabio Rogerio Pereira� Data �  19/10/00   ���
��������������������������������������������������������������������������͹��
���Desc.     �Verifica se a SIGACTI.DLL esta ativa                         ���
���          �                                                             ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function XCheckDLL()
Local lRet := .T.

If nHandle == -1
  nHandle := ExecInDLLOpen("SIGACTI.DLL")
EndIf

If nHandle == -1
  Help(" ",1,"ERROCTI",,OemToAnsi("A SIGACTI.DLL n�o encontrada ou com problemas, verifique se a mesma esta no diret�rio do Protheus Remote. Ex: c:\ap6\bin\remote"),3,5)
  lRet:=.F.
Endif

Return(lRet)

