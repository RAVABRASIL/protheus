#include "protheus.ch"
#include "topconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO45    � Autor � AP6 IDE            � Data �  31/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*  Rela��o de Paramentros (FINR007) 
MV_PAR01 --> titulo de:
MV_PAR02 --> titulo ate:
MV_PAR03 --> cliente de:
MV_PAR04 --> cliente ate:
MV_PAR05 --> loja de:
MV_PAR06 --> loja ate:
MV_PAR07 --> Data de Emissao de:
MV_PAR08 --> Data de Emissao ate:
MV_PAR09 --> Data de Vencimento de:
MV_PAR10 --> Data de Vencimento ate:
MV_PAR11 --> Data da Baixa de:
MV_PAR12 --> Data da Baixa Ate:
*/


User Function FINR007()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Titulos"
Local cPict          := ""
Local titulo         := "Analise de Titulos XDD"
Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
                       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Numero     P  Cliente Nome                 Loja OBS                        Emissao   Venc Real           Dt.Baixa            Valor              Valor Pago             Saldo"
Local Cabec2         := ""
Local imprime        := .T.
//Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FINR007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
//Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private aRETURN  := {"Zebrado",1,"Administracao",1,2,1,"",1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR007" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE1"


PERGUNTE('FINR007',.F.)

aOrd :={ OemToAnsi("Por Numero" ),;	
	     OemToAnsi("Por Vencimento" )} 


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel:=SetPrint(cString,wnrel,'FINR007',@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)


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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  31/05/12   ���
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
LOCAL cSITUACAO:=''
Private nOrdem := 0

nOrdem:=aReturn[8]
Dtos(dDatabase)
cQry:="SELECT  "
//cQry+="CASE WHEN E1_SALDO=0 THEN '2' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO<CONVERT(VARCHAR,GETDATE(),112) THEN '1.1' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO>=CONVERT(VARCHAR,GETDATE(),112)  THEN '1.2' ELSE 'XXX' END END END SITUACAO, "
cQry+="CASE WHEN E1_SALDO=0 THEN '2' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO<'"+Dtos(dDatabase)+"' THEN '1.1' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO>='"+Dtos(dDatabase)+"'  THEN '1.2' ELSE 'XXX' END END END SITUACAO, "
cQry+="E1_FILIAL,E1_TIPO,E1_NUM ,E1_PREFIXO,E1_PARCELA ,E1_CLIENTE,E1_NOMCLI,E1_LOJA,E1_VALOR,E1_VENCTO,E1_EMISSAO,E1_BAIXA,E1_SALDO,E1_HIST,E1_VENCREA "
cQry+="FROM " + RetSqlName("SE1") + " SE1 "
cQry+="WHERE E1_PREFIXO='' " // 6DD 
cQry+="AND E1_FILIAL='"+XFILIAL('SE1')+"'  "
cQry+="AND E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 
cQry+="AND E1_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
cQry+="AND E1_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " 
cQry+="AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' " 
cQry+="AND E1_VENCTO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' " 
cQry+="AND E1_BAIXA BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' " 
cQry+="AND E1_TIPO='NF ' "
cQry+="AND SE1.D_E_L_E_T_ = ''  "
cQry+="ORDER BY "
//cQry+="CASE WHEN E1_SALDO=0 THEN '2' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO<CONVERT(VARCHAR,GETDATE(),112) THEN '1.1' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO>=CONVERT(VARCHAR,GETDATE(),112)  THEN '1.2' ELSE 'XXX' END END END  "
cQry+="CASE WHEN E1_SALDO=0 THEN '2' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO<'"+Dtos(dDatabase)+"' THEN '1.1' ELSE CASE WHEN E1_SALDO>0 AND E1_VENCTO>='"+Dtos(dDatabase)+"'  THEN '1.2' ELSE 'XXX' END END END "
if nOrdem == 1 // numero
   cQry+=",E1_NUM,E1_PARCELA "
elseif nOrdem == 2 // Vencimento
   cQry+=",E1_VENCTO "
endif

TCQUERY cQry NEW ALIAS 'TMPX'

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
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   cSITUACAO:=TMPX->SITUACAO
   nQtd:=0
   nValor:=0
   nValPago:=0
   nSaldo:=0
   @nLin++,00 PSAY iif(cSITUACAO='1.1','Em Aberto - Atrasado',iif(cSITUACAO='1.2','Em Aberto - A Vencer',iif(cSITUACAO='2','Recebido','')))
   Do While TMPX->(!EOF()) .AND. TMPX->SITUACAO=cSITUACAO  
      
      If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin := 8
      Endif

      @nLin,00 PSAY TMPX->E1_NUM
      @nLin,11 PSAY TMPX->E1_PARCELA
      @nLin,14 PSAY TMPX->E1_CLIENTE
      @nLin,22 PSAY TMPX->E1_NOMCLI
      @nLin,44 PSAY TMPX->E1_LOJA
      @nLin,48 PSAY TMPX->E1_HIST
      //@nLin,75 PSAY DTOC(STOD(TMPX->E1_VENCTO))  //retirado por FR - Flavia Rocha, solicitado no chamado 002572 - Regina
      @nLin,75 PSAY DTOC(STOD(TMPX->E1_EMISSAO)) 
      @nLin,85 PSAY DTOC(STOD(TMPX->E1_VENCREA))
      //@nLin,95 PSAY DTOC(STOD(TMPX->E1_EMISSAO))  //trocar a coluna de lugar - por FR - Flavia Rocha, solicitado no chamado 002572 - Regina
      @nLin,105 PSAY DTOC(STOD(TMPX->E1_BAIXA))
      @nLin,115 PSAY TRANSFORM(TMPX->E1_VALOR,'@E 999,999,999,999.99')
      @nLin,136 PSAY TRANSFORM(TMPX->E1_VALOR - TMPX->E1_SALDO,'@E 999,999,999,999.99') // PAGOU 
      IF TMPX->E1_SALDO>0
         @nLin,157 PSAY TRANSFORM(TMPX->E1_SALDO,'@E 999,999,999,999.99')
         nSaldo+=TMPX->E1_SALDO
      ENDIF
      nQtd+=1
      nValor+=TMPX->E1_VALOR
      nValPago+=TMPX->E1_VALOR-TMPX->E1_SALDO 
      nLin := nLin + 1 // Avanca a linha de impressao
      INCREGUA()
      TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
      @nLin++
      @nLin,000 PSAY 'Qunt. de Titulos: '+alltrim(str(nQtd))
      @nLin,105 PSAY 'Total-->'
      @nLin,115 PSAY TRANSFORM(nValor,'@E 999,999,999,999.99')
      @nLin,136 PSAY TRANSFORM(nValPago,'@E 999,999,999,999.99') // PAGOU 
      If nSaldo>0
         @nLin,157 PSAY TRANSFORM(nSaldo,'@E 999,999,999,999.99')
      Endif
      @nLin++
      @nLin++,000 PSAY  replicate("_",220) 
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
