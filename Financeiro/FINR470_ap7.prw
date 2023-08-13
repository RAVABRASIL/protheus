#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FINR470()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,TAMANHO")
SetPrvt("TITULO,CABEC1,CABEC2,ARETURN,NOMEPROG,ALINHA")
SetPrvt("NLASTKEY,CPERG,LIMITE,NSALDOATU,NENTRADAS,NSAIDAS")
SetPrvt("NSALDOINI,CFIL,NORDSE5,ARECON,NTXMOEDA,NVALOR")
SetPrvt("ASTRU,RECNCONC,RECCONC,PAGNCONC,PAGCONC,LALLFIL")
SetPrvt("CBTXT,CBCONT,LI,M_PAG,CBANCO,CNOMEBANCO")
SetPrvt("CAGENCIA,CCONTA,NLIMCRED,NTIPO,CCHAVE,CINDEX")
SetPrvt("NINDEX,CCONDWHILE,CORDER,CQUERY,NI,LABORTPRINT")
SetPrvt("LCONTINUA,CDOC,LRET,")

/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Prograd.�ALTERACAO                                      ���
��������������������������������������������������������������������������Ĵ��
���28.06.98�      �Mauricio�Nro de titulos com 12 posicoes                 ���
���08.10.98�XXXXXX�Andreia �Alteracao no lay-out para ativar set century   ���
���15.12.98�XXXXXX�Andreia �Verificacao se motivo da baixa movimenta Banco ���
���30.03.99�META  �Julio   �Verificacao dos Parametros de Tamanho  do Rel. ���
���07.06.99�      �Pilar   �Nao pode ser impresso registro com E5_NUMCHEQ=*���
���11.06.99�      �Mauricio�Tratamento de Arredondamento  valores de moeda ���
���        �      �        �diferente de 1. (Round(NoRound(xMoeda(...))))  ���
���28.09.99�23924A�Julio W �Tratamento de Taxa Contratada.                 ���
���13.10.99�24576A�Mauricio�Acrescentar Parcela ao nro do titulo           ���
���19.10.99�xxxxxx�Pilar   �Melhoria de Performance                        ���
���20.10.99�xxxxxx�Pilar   �Acerto da Query -> E5_NUMCHEQ e C1,C2,C3,C4,C5 ���
���25.10.99�      �Pequim  �Corrigir conversao de valores p/ moeda > 1     ���
���28.10.99�      �Pequim  �Corrigir extrato qdo SA6 e SE5 exclusivos      ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

//��������������������������������������������������������������Ŀ
//� Define Variaveis 														  �
//����������������������������������������������������������������
wnrel   := "FINR470"
cDesc1  := "Este programa ir� emitir o relat�rio de movimenta��es"
cDesc2  := "banc�rias em ordem de data. Poder� ser utilizado para"
cDesc3  := "conferencia de extrato."
cString := "SE5"
Tamanho := "M"
titulo  := "Extrato Bancario"
cabec1  := ""
cabec2  := ""
aReturn := { "Zebrado", 1, "Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
nomeprog:= "FINR470"
aLinha  := { }
nLastKey:= 0
cPerg   := "FIN470"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("FIN470",.F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01                            // Banco                �
//� mv_par02                            // Agencia              �
//� mv_par03                            // Conta                �
//� mv_par04                            // a partir de          �
//� mv_par05                            // ate                  �
//� mv_par06                            // Qual Moeda           �
//���������������������������������������������������������������
//�������������������������������������������������������������Ŀ
//� Envia controle para a fun��o SETPRINT                       �
//���������������������������������������������������������������
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"",.F.)

//����������������������������������������������������������������Ŀ
//� Envia controle para a funcao REPORTINI substituir as variaveis.�
//������������������������������������������������������������������
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif
#IFDEF WINDOWS
   RptStatus({|| Fa470Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(Fa470Imp)})
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function FA470imp
Static Function FA470imp()
   Return
#ENDIF

//RptStatus({|lEnd| Fa470Imp(@lEnd,wnRel,cString)},titulo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA470IMP � Autor � Wagner Xavier         � Data � 20.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Extrato Banc�rio.                                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Function FA470Imp
//(lEnd,wnRel,cString)

//CbCont,CbTxt,nTipo,cDOC,cChave,cIndex,ni,cCondWhile, 
//cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred

limite   := 132
nSaldoAtu:= 0
nEntradas:= 0
nSaidas  := 0
nSaldoIni:= 0
cFil     := ""
nOrdSE5  := SE5->(IndexOrd())
aRecon   := {0,0,0,0}
nTxMoeda := 1
nValor   := 0
aStru    := SE5->(dbStruct())

RECNCONC := 1   //Recebido nao Conciliado
RECCONC  := 2   //Recebido Conciliado
PAGNCONC := 3   //Pago nao Conciliado
PAGCONC  := 4   //Pago Conciliado


//AAdd( aRecon, {0,0,0,0} )

//��������������������������������������������������������������Ŀ
//� Variaveis privadas exclusivas deste programa                 �
//����������������������������������������������������������������
lAllFil  := .F.

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt 	:= SPACE(10)
cbcont	:= 0
li      := 80
m_pag 	:= 1

dbSelectArea("SA6")
If !(dbSeek( xFilial() + mv_par01+mv_par02+mv_par03 ))
   #IFNDEF WINDOWS
       Set Device To Screen
   #ENDIF
   Help(" ",1,"BCONAOEXIST")
   Return
EndIf

cBanco     := A6_COD
cNomeBanco := A6_NREDUZ
cAgencia   := A6_AGENCIA
cConta     := A6_NUMCON
nLimCred   := A6_LIMCRED

//��������������������������������������������������������������Ŀ
//� Defini��o dos cabe�alhos                                     �
//����������������������������������������������������������������
titulo := "EXTRATO BANCARIO ENTRE " + DTOC( mv_par04 ) + " e " + DTOC( mv_par05 )  //"EXTRATO BANCARIO ENTRE "
cabec1 := "BANCO "+ cBanco +" - "+ ALLTRIM( cNomeBanco ) + ;
          "   AGENCIA "+ cAgencia + "   CONTA "+ cConta  //"BANCO "###"   AGENCIA "###"   CONTA "
cabec2 := "DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"
nTipo  := IIF( aReturn[4] == 1, 15, 18 )

//��������������������������������������������������������������Ŀ
//� Saldo de Partida                                             �
//����������������������������������������������������������������

dbSelectArea("SE8")
dbSeek( xFilial()+cBanco+cAgencia+cConta+Dtos(mv_par04),.T.)
dbSkip(-1)

If E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta .or. BOF() .or. EOF()
   nSaldoAtu:=0
   nSaldoIni:=0
Else
   nSaldoAtu:=Round(NoRound(xMoeda(E8_SALATUA,1,mv_par06,SE8->E8_DTSALAT,3),3),2)
   nSaldoIni:=Round(NoRound(xMoeda(E8_SALATUA,1,mv_par06,SE8->E8_DTSALAT,3),3),2)
End

//��������������������������������������������������������������Ŀ
//� Filtra o arquivo por tipo e vencimento                       �
//����������������������������������������������������������������
If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
   cChave  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
   lAllFil := .T.
Else
   cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

#IFNDEF TOP	
   dbSelectArea("SE5")
   cIndex  := CriaTrab(nil,.f.)
   dbSelectArea("SE5")
   IndRegua("SE5",cIndex,cChave,,Nil,"Selecionando Registros...")
   nIndex  := RetIndex("SE5")
   dbSetIndex(cIndex+OrdBagExt())
   dbSetOrder(nIndex+1)
   cFil    := Iif(lAllFil,"",xFilial("SE5"))
   dbSeek(cFil+DtoS(mv_par04),.T.)
#ELSE
   If TcSrvType() == "AS/400"
      dbSelectArea("SE5")
      cIndex  := CriaTrab(nil,.f.)
      dbSelectArea("SE5")
      IndRegua("SE5",cIndex,cChave,,Nil,"Selecionando Registros...")
      nIndex  := RetIndex("SE5")
      dbSetOrder(nIndex+1)
      cFil    := Iif(lAllFil,"",xFilial("SE5"))
      dbSeek(cFil+DtoS(mv_par04),.T.)
   EndIf 
#ENDIF

SetRegua(RecCount())

#IFNDEF TOP
   If lAllFil
      cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
   Else
      cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
   EndIf
#ELSE
   If TcSrvType() != "AS/400"
      cCondWhile := " !Eof() "
      If lAllFil
         cChave  := "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
      Else
         cChave  := "E5_FILIAL+E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
      EndIf
      cOrder := SqlOrder(cChave)
      cQuery := "SELECT * "
      cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
      If !lAllFil
         cQuery += "     E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
      EndIf 
      cQuery := cQuery +  " D_E_L_E_T_ <> '*' "
      cQuery := cQuery +  " AND E5_DTDISPO >=  '"     + DTOS(mv_par04) + "'"
      cQuery := cQuery +  " AND E5_DTDISPO <=  '"     + DTOS(mv_par05) + "'"
      cQuery := cQuery +  " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
      cQuery := cQuery +  " AND E5_BANCO = '"   + cBanco   + "'"
      cQuery := cQuery +  " AND E5_AGENCIA = '" + cAgencia + "'"
      cQuery := cQuery +  " AND E5_CONTA = '"   + cConta   + "'"
      cQuery := cQuery +  " AND E5_SITUACA <> 'C' "
      cQuery := cQuery +  " AND E5_VALOR <> 0 "
      cQuery := cQuery +  " AND E5_NUMCHEQ NOT LIKE '%*' "
      cQuery := cQuery +  " AND E5_VENCTO <= '" + DTOS(mv_par05)  + "'" 
      cQuery := cQuery +  " AND E5_VENCTO <= '" + DTOS(dDataBase)  + "'" 
      cQuery := cQuery +  " AND E5_VENCTO <= E5_DATA " 
      If mv_par07 == 2
         cQuery := cQuery +  " AND E5_RECONC <> ' ' "
      ElseIf mv_par07 == 3
         cQuery := cQuery +  " AND E5_RECONC = ' ' " 
      EndIf
      cQuery := cQuery +  " ORDER BY " + cOrder
      cQuery := ChangeQuery(cQuery)

      dbSelectAre("SE5")
      dbCloseArea()

      dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
      For ni := 1 to Len(aStru)
          If aStru[ni,2] != 'C'
             TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
          Endif
      Next
   EndIf
#ENDIF

While &(cCondWhile)

   #IFNDEF WINDOWS
      Inkey()
      If LastKey() = K_ALT_A
         lAbortPrint := .T.
      Endif
   #ENDIF
	
   IF lAbortPrint
      @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
      lContinua := .F.
      Exit
   Endif
	
   IncRegua()
	
   #IFNDEF TOP
      Fr470Skip()
      If !lRet  //(cBanco,cAgencia,cConta)
         dbSkip()
         Loop
      EndIf 
   #ELSE
      If TcSrvType() == "AS/400"       
         Fr470Skip()
         If !lRet  //(cBanco,cAgencia,cConta)
            dbSkip()
            Loop
         EndIf 
      EndIf
   #ENDIF   

   If SE5->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. Empty(SE5->E5_NUMCHEQ)
      dbSkip()
      Loop
   Endif

   If !Empty( E5_MOTBX )
      If !MovBcoBx( E5_MOTBX )
         dbSkip( )
         Loop
      EndIf
   EndIf

   If li>55
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      li := li - 1
      @li, 113 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16)
   EndIF
	
   dbSelectArea("SE5")
   li := li + 1
   @li, 0 PSAY E5_DTDISPO
   @li,12 PSAY SUBSTR(SE5->E5_HISTOR,1,30)
	
   cDoc := E5_NUMCHEQ
	
   If Empty( cDoc )
      cDoc := E5_DOCUMEN
   Endif
	
   If Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 19
      cDoc := Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-","") + Alltrim(E5_NUMCHEQ )
   Endif
	
   If Substr( cDoc ,1, 1 ) == "*"
      dbSkip( )
      Loop
   Endif
	
   @li,043 PSAY cDoc
   @li,061 PSAY ALLTRIM(E5_PREFIXO+IIF(EMPTY(E5_PREFIXO),"","-")+E5_NUMERO)+"-"+E5_PARCELA
	
   //������������������������������������������������������������������Ŀ
   //�VerIfica se foi utilizada taxa contratada para moeda > 1          �
   //��������������������������������������������������������������������
   If (mv_par06 > 1) .And. !Empty(SE5->E5_VLMOED2)
      If Round(NoRound(xMoeda(SE5->E5_VALOR,1,mv_par06,SE5->E5_DTDISPO,3),3),2) != SE5->E5_VLMOED2
         nTxMoeda := SE5->E5_VALOR / SE5->E5_VLMOED2 
      Else
         nTxMoeda := RecMoeda(SE5->E5_DTDISPO,mv_par06)
      EndIf
      nTxMoeda := IIf(nTxMoeda=0,1,nTxMoeda)
      nValor   := Round(NoRound(SE5->E5_VALOR/nTxMoeda,3),2)
   Else
      nValor := Round(NoRound(xMoeda(SE5->E5_VALOR,1,mv_par06,SE5->E5_DTDISPO,3),3),2) 
   Endif

   If SE5->E5_RECPAG == "R"
      @ li,78 PSAY  nValor     Picture tm(nValor,15)
      nSaldoAtu := nSaldoAtu + nValor
      If Empty( SE5->E5_RECONC )
         aRecon[RECNCONC] := aRecon[RECNCONC] + nValor
      Else
         aRecon[RECCONC]  := aRecon[RECCONC] + nValor
      EndIf
   Else
      @ li,94 PSAY nValor  Picture tm(nValor,15)
      nSaldoAtu := nSaldoAtu - nValor
      If Empty( SE5->E5_RECONC )
         aRecon[PAGNCONC] := aRecon[PAGNCONC] + nValor
      Else
         aRecon[PAGCONC]     := aRecon[PAGCONC] + nValor
      EndIf
   Endif
   @ li,113 PSAY nSaldoAtu Picture tm( nSaldoAtu, 16 )
   @ li,pCol() + 1 PSAY Iif( Empty( SE5->E5_RECONC ), " ", "x" )
	
   dbSelectArea("SE5")
   dbSkip()
Enddo

If (li > 55)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li := li + 2
@ li,048 PSAY "SALDO INICIAL...........: "
@ li,113 PSAY nSaldoIni  Picture tm( nSaldoIni, 16 )

li := li + 2
If (li > 55)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

@ li,078 PSAY "NAO CONCILIADOS"
@ li,098 PSAY "    CONCILIADOS"
@ li,124 PSAY "          TOTAL"

li := li + 1
@ li,048 PSAY "ENTRADAS NO PERIODO.....: "
@ li,078 PSAY aRecon[RECNCONC] PicTure tm(aRecon[1],15)
@ li,094 PSAY aRecon[RECCONC]  PicTure tm(aRecon[2],15)
@ li,113 PSAY aRecon[RECCONC] + aRecon[RECNCONC] PicTure tm((aRecon[1]+aRecon[2]),16)

li := li + 1
If (li > 55)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

@ li,048 PSAY "SAIDAS NO PERIODO ......: "
@ li,078 PSAY aRecon[PAGNCONC] PicTure tm(aRecon[3],15)
@ li,094 PSAY aRecon[PAGCONC]  PicTure tm(aRecon[4],15)
@ li,113 PSAY aRecon[PAGCONC] + aRecon[PAGNCONC] PicTure tm((aRecon[3]+aRecon[4]),16)

li := li + 1
If (li > 55)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

@ li, 48 PSAY "LIMITE DE CREDITO ......: "
@ li,113 PSAY nLimCred Picture tm(nLimCred,16)

li := li + 2
nSaldoAtu := nSaldoAtu +nLimCred

If (li > 55)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY "SALDO ATUAL ............: "
@li,113 PSAY nSaldoAtu	Picture tm( nSaldoAtu, 16 )

If li != 80
   roda(cbcont,cbtxt,Tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
   dbSelectArea("SE5")
   RetIndex( "SE5" )
   If !Empty(cIndex)
      FErase (cIndex+OrdBagExt())
   Endif
   dbSetOrder(1)
#ELSE
   If TcSrvType() != "AS/400"
      dbSelectArea("SE5")
      dbCloseArea()
      ChKFile("SE5")
      dbSelectArea("SE5")
      dbSetOrder(1)
   Else
      dbSelectArea("SE5")
      RetIndex( "SE5" )
      If !Empty(cIndex)
         FErase (cIndex+OrdBagExt())
      Endif
      dbSetOrder(1)
   Endif
#ENDIF

If aReturn[5] == 1
   Set Printer To
   dbCommit()
   ourspool(wnrel)
Endif

MS_FLUSH()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Fr470Skip � Autor � Pilar S. Albaladejo   � Data � 13.10.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR470.PRX                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Fr470Skip
Static Function Fr470Skip()
//(cBanco,cAgencia,cConta)
lRet := .T.

IF E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
   lRet := .F.
ElseIF E5_BANCO+E5_AGENCIA+E5_CONTA!=cBanco+cAgencia+cConta
   lRet := .F.
ElseIF E5_SITUACA == "C"    //Cancelado
   lRet := .F.
ElseIF SE5->E5_VALOR == 0
   lRet := .F.
ElseIF E5_VENCTO > mv_par05 .or. E5_VENCTO > dDataBase .or. E5_VENCTO > E5_DATA
   lRet := .F.
ElseIf SubStr(E5_NUMCHEQ,1,1) == "*" 
   lRet := .F.
ElseIf (mv_par07 == 2 .and. Empty(SE5->E5_RECONC)) .or. (mv_par07 == 3 .and. !Empty(SE5->E5_RECONC))
   lRet := .F.
ElseIF E5_TIPODOC == "BA"      //Baixa Automatica
   lRet := .F.
Endif

Return

