#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "TbiConn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  15/06/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RAGEVIA()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Agenda de Viagem "
Local cPict          := ""
Local titulo         := "Agenda de Viagem "
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RAGEVIA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RAGEVIA" // Coloque aqui o nome do arquivo usado para impressao em disco

Private _aArra:={}
Private _aCabe:={'AGENDA','GESTOR','DESCRICAO AGENDA','DT.VISITA','VISITA','CODIGO','LOJA','NOME'}


Private cString := ""

ValidPerg('FRAGVIA')
PERGUNTE('FRAGVIA',.F.) 


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FRAGVIA",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  15/06/16   ���
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
local cQuery:=""
Local nOrdem

cQuery:="SELECT * FROM "+RetSqlName("ZZE")+" ZZE, "+RetSqlName("ZZF")+" ZZF "
cQuery+="WHERE "
cQuery+="ZZE_CODIGO=ZZF_CODIGO "
cQuery+="AND ZZE_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQuery+="AND ZZE_GESTOR BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "
cQuery+="AND ZZE.D_E_L_E_T_ = ' ' "
cQuery+="AND ZZF.D_E_L_E_T_ = ' ' "
cQuery+="ORDER BY ZZE_GESTOR,ZZE_CODIGO,ZZF_DTVISI "

If Select("AUXK") > 0
	DbSelectArea("AUXK")
	AUXK->(DbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "AUXK"

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

AUXK->(DbGoTop()) 
While AUXK->(!EOF())

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

  _XXGESTOR:=AUXK->ZZE_GESTOR

  Do While AUXK->(!EOF())   .AND. AUXK->ZZE_GESTOR==_XXGESTOR

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   _Codigo:=AUXK->ZZE_CODIGO
   _NoGestor:=POSICIONE("SA3",1,XFILIAL("SA3")+_XXGESTOR,"A3_NREDUZ")

	 If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
          @nLin++,00 PSAY "Continua Gestor: "+_NoGestor
          @nLin++
	 Endif


   @nLin++,00 PSAY 'Agenda: '+_Codigo +space(5)+'Gestor: '+_NoGestor
   @nLin++,00 PSAY 'Descricao: '+ AUXK->ZZE_DESCRI
   @nLin++,00 PSAY REPLICATE('-',220)   
   @nLin,00 PSAY "Dt.Visita";@nLin,10 PSAY "Visita";@nLin,24 PSAY "Codigo";@nLin,32 PSAY "Loja";@nLin,38 PSAY "Nome"
   @nLin++   
   @nLin++,00 PSAY REPLICATE('-',220)   
      
   Do While AUXK->(!EOF())   .AND. AUXK->ZZE_CODIGO==_Codigo

	   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
          @nLin++,00 PSAY "Continua Agenda "+_Codigo+" Gestor: "+_NoGestor
          @nLin++
	   Endif
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	   @nLin,00 PSAY dtoc(stod(AUXK->ZZF_DTVISI))
	   @nLin,10 PSAY X3COMBO("ZZF_TIPO",AUXK->ZZF_TIPO)
	   @nLin,24 PSAY AUXK->ZZF_CODCP
       @nLin,32 PSAY AUXK->ZZF_LOJA
       @nLin,38 PSAY AUXK->ZZF_NOMECP
       AADD(_aArra,{AUXK->ZZE_CODIGO,AUXK->ZZE_GESTOR,AUXK->ZZE_DESCRI,dtoc(stod(AUXK->ZZF_DTVISI)),X3COMBO("ZZF_TIPO",AUXK->ZZF_TIPO),AUXK->ZZF_CODCP,AUXK->ZZF_LOJA,AUXK->ZZF_NOMECP})
   	   nLin := nLin + 1 // Avanca a linha de impressao
	   IncRegua()
	   AUXK->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
       @nLin++
  EndDo
  
     If AUXK->(!EOF())
  	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	  nLin := 8
     endif
  
EndDo

AUXK->(DBCLOSEAREA())


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

IF MV_PAR03=1

	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

ELSE

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY",titulo, _aCabe, _aArra}})})
	If !ApOleClient("MSExcel")
	    MsgAlert("Microsoft Excel n�o instalado!")
		Return()
	EndIf


ENDIF


Return


***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cperg, '01', 'Agenda De         ?', '', '', 'mv_ch1', 'C', 06, 0, 0, 'G', '', 'ZZE' , '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '02', 'Agenda Ate        ?', '', '', 'mv_ch2', 'C', 06, 0, 0, 'G', '', 'ZZE' , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg,'03','Excel            ?','','','mv_ch3','N',01,0,1,'C','','','','','mv_par03','Nao', '', '', '' , 'Sim', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '04', 'Agenda De         ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SA3C' , '', '', 'mv_par04', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '05', 'Agenda Ate        ?', '', '', 'mv_ch5', 'C', 06, 0, 0, 'G', '', 'SA3C' , '', '', 'mv_par05', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )



RETURN  