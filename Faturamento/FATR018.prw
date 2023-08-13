#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     � Autor � AP6 IDE            � Data �  31/07/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR018()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Nota Fiscal por Segmento"
Local cPict          := ""
Local titulo         := "Notas Fiscais Hosp. Particulares e Orgaos Publicos"
Local nLin           := 80

//11 19 41 51 66
                       //         10        20        30        40        50        60        70        80        90        100       110       120       130
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Nota      Codigo  Cliente               Emissao      Valor S/IPI    Valor C/IPI"
Local Cabec2         := "      Codigo           Descritivo                                            Quantidade"
Local imprime        := .T.
Local aOrd            := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATR018" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR018" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('FATR018',.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,'FATR018',@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo:= "Notas Fiscais Hosp. Particulares e Orgaos Publicos de "+DTOC(MV_PAR01) +' Ate '+DTOC(MV_PAR02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  31/07/10   ���
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
local cQry:=''

SetRegua(0)
IncRegua()

cQry:="SELECT A1_EST,D2_COD,D2_QUANT,A1_SATIV1,F2_DOC,A1_COD,A1_NREDUZ,F2_EMISSAO,sum(F2_VALMERC)F2_VALMERC ,sum(F2_VALBRUT )F2_VALBRUT "
cQry+="FROM " + RetSqlName("SF2") + " SF2," + RetSqlName("SD2") + " SD2," + RetSqlName("SA1") + " SA1  "
cQry+="WHERE "
cQry+="F2_CLIENTE+F2_LOJA=A1_COD+A1_LOJA  "
cQry+="AND F2_DOC+F2_SERIE=D2_DOC+D2_SERIE  "
cQry+="AND A1_SATIV1 IN ('000008','000009')  "
cQry+="AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQry+="AND A1_EST BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQry+="AND D2_COD BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'  "
cQry+="AND SF2.D_E_L_E_T_!='*' "
cQry+="AND SA1.D_E_L_E_T_!='*' " 
cQry+="AND SD2.D_E_L_E_T_!='*' " 
cQry+="GROUP BY  A1_EST,D2_COD,D2_QUANT,A1_SATIV1,F2_DOC,A1_COD,A1_NREDUZ,F2_EMISSAO  "
cQry+="ORDER BY A1_SATIV1,A1_EST,F2_DOC,F2_EMISSAO,A1_COD " 

TCQUERY cQry NEW ALIAS "AUUX"
TCSetField( 'AUUX', "F2_EMISSAO", "D" )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
/*
SetRegua(0)
IncRegua()
*/
//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

AUUX->(dbGoTop())
While AUUX->(!EOF())

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
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   cSeg:=AUUX->A1_SATIV1
   
   DbselectArea("SX5")
   Dbsetorder(1)
   SX5->(Dbseek(xFilial("SX5") + 'T3' + AUUX->A1_SATIV1 ))
   @nLin++,00 PSAY 'Segmento: '+Alltrim( Substr(SX5->X5_DESCRI,1,35) )
   @nLin++,00 PSAY replicate('-',len(Alltrim( Substr(SX5->X5_DESCRI,1,35)))+10)
    
   do While AUUX->(!EOF()) .AND. AUUX->A1_SATIV1==cSeg  
      
      If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin := 9
      Endif
      
      cUF:=AUUX->A1_EST  
      @nLin++,00 PSAY 'UF: '+Alltrim(AUUX->A1_EST )
      @nLin++,00 PSAY replicate('-',6)
   
      do While AUUX->(!EOF()) .AND. AUUX->A1_EST==cUF  
      
	      If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	         nLin := 9
	      Endif
	      
	      cNF:=AUUX->F2_DOC  
	      @nLin,00 PSAY AUUX->F2_DOC  // 9
		  @nLin,11 PSAY AUUX->A1_COD  // 6
		  @nLin,19 PSAY AUUX->A1_NREDUZ //20
		  @nLin,41 PSAY DTOC(AUUX->F2_EMISSAO) //  8   
		  @nLin,51 PSAY AUUX->F2_VALMERC Picture "@E 99,999,999.99"// 13         // S/IPI
		  @nLin++,66 PSAY AUUX->F2_VALBRUT Picture "@E 99,999,999.99"//13          //   C/IPI
	      
	      Do While AUUX->(!EOF()) .AND. AUUX->F2_DOC==cNF  
		     If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	            nLin := 9
	         Endif
		     @nLin,06 PSAY AUUX->D2_COD  
		     @nLin,23 PSAY posicione("SB1",1,xFilial('SB1') +AUUX->D2_COD,"B1_DESC")
		     @nLin,75 PSAY AUUX->D2_QUANT Picture "@E 99,999,999.99"  
		     nLin := nLin + 1 // Avanca a linha de impressao
		     IncRegua()
		     AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	      ENDDO
      
      ENDDO
    ENDDO
EndDo

AUUX->(DBCLOSEAREA())

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
