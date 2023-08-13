#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO25    � Autor � AP6 IDE            � Data �  20/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function REPOPHPUB()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "POP Linha Hospitalar"
Local cPict          := ""
Local titulo         := "POP Linha Hospitalar Area Publica"
//Local nLin           := 80
Local nLin           := 8
//                                 {028,039,050,061,072,083,094}
//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1         := "Estado                      | Montar Equipe de Venda | Mapeamento | Criacao e Envio do PLano de Acao | Finalizacao do Plano de Acao |    %                                        																							  "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "REPOPHPUB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "REPOPHPUB" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  20/01/12   ���
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
LOCAL cQry:=''
Local nOrdem
local aTafPub:={}
local cnt:=0
local aCol:={031,056,069,104,133,169,181}
local aCol2:={054,067,102,133,167,179,210}

cQry:="SELECT X5_CHAVE,X5_DESCRI "
cQry+="FROM SX5020 SX5 "
cQry+="WHERE X5_TABELA='12' "  
cQry+="AND SX5.D_E_L_E_T_!= '*' "
cQry+="ORDER BY X5_CHAVE "
TCQUERY cQry NEW ALIAS "TMPB"


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
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
TMPB->(dbGoTop())
While TMPB->(!EOF() )

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
   /*
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   */
   
   cUF:=alltrim(TMPB->X5_CHAVE)
   aTafPub:={} 
   cnt:=0
   Do While TMPB->(!EOF() ) .AND. alltrim(TMPB->X5_CHAVE)==cUF
	   
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	   
	   aTafPub:=TafPub(cUF)
	   
	   @nLin,00 PSAY TMPB->X5_CHAVE // UF 
	   @nLin,04 PSAY SUBSTR(TMPB->X5_DESCRI,1,22)  // NOME DA UF 
	   @nLin,29 PSAY  "|"
	   For _X:=1 to 4
		   @nLin,aCol2[_X] PSAY '|'
		   if alltrim(aTafPub[1][_X])='C'
			     @nLin,aCol[_X] PSAY 'Concluido'
			  cnt+=1
	       Endif
	   Next 
	   	   	   
	   @nLin,135 PSAY transform((cnt/4)*100 ,'@E 999.99' )
	   
	   
	   nLin := nLin + 2 // Avanca a linha de impressao
	
	   TMPB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
EndDo
TMPB->(DBCLOSEAREA())


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

Static Function TafPub(cUF)

***************
local cQry:=''
local aRet:={}

cQry:="SELECT Z83_UF ,Z84_TAF21 ,Z84_TAF22,Z84_TAF23,Z84_TAF24 "
cQry+="FROM Z83020 Z83,Z84020 Z84 "
cQry+="WHERE "
cQry+="Z83_CODIGO=Z84_IDPOP "
cQry+="AND Z83_AREA='2' "  // AREA Publica 
cQry+="AND Z83_UF='"+alltrim(cUF)+"' "
cQry+="AND Z83.D_E_L_E_T_!= '*' "
cQry+="AND Z84.D_E_L_E_T_!= '*' "

TCQUERY cQry NEW ALIAS "TMPC"
If  TMPC->(!EOF() )
    aAdd( aRet,{ TMPC->Z84_TAF21 ,TMPC->Z84_TAF22,TMPC->Z84_TAF23,TMPC->Z84_TAF24    } )  
          
else
    aAdd( aRet,{ '' ,'','','' } )      
Endif	

TMPC->(DBCLOSEAREA())

Return  aRet