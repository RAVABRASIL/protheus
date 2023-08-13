#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA110BUT  � Autor � Fl�via Rocha       � Data �  26/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao �  Descri��o: Este ponto de entrada tem o objetivo           ���
���                de permitir ao usu�rio manipular a barra de bot�es     ��� 
���                nas rotinas de visualiza��o, inclus�o, Altera��o e     ���
���                exclus�o de solcita��o de compras.                     ���
���                Exemplo: Possibilita retirar um bot�o que determinado  ��� 
���                usu�rio n�o tenha permiss�o conforme regra de neg�cio  ���
���                   praticada.                                          ���
���                Localiza��o: Rotina de Solicita��o de Compras MATA110()���
���                                                                       ���
���                   Eventos                                             ���
���                   Antes de montar a tela de Solicita��o de Compras    ���  
���                   para cada opera��o selecionada                      ���
���                   (Visualiza��o, Inclus�o, Altera��o e Exclus�o).     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �  Compras                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
PARAMIXB[1]			Num�rico			Par�metro num�rico contendo a op��o de opera��o da rotina selecionada nOpc:
2 - Visualiza��o
3 - Inclus�o
4 - Altera��o
5 - Exclus�o
										
PARAMIXB[2]			Array of Record			Vetor contendo os bot�es carregados pela rotina.	
*/

*************************
User Function MA110BUT   
*************************


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local nOpc:= PARAMIXB[1]
Local aBut:= PARAMIXB[2]

//Customiza��o Desejada
If nOpc = 3 .or. nOpc = 4
	aadd(aBut,{'DBG06' ,{|| fURG()}       ,'Define URG�NCIA','URGENTE?'}) 
Endif

Return aBut





****************************
Static Function fURG()
****************************


Local nOpcA   := 0
Local nPOSURG := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C1__URGEN" } )
Local x       := 0

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private nUrgente   := 0
Private cUrgente   := ""
Private cSayURG    := Space(1)

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg1","oGrp1","oSayURG","oSBtn1","oSBtn2", "oCboxU")

If Inclui .or. Altera
	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	//oDlg1      := MSDialog():New( 088,232,292,692,"INFORMA��ES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	//oGrp1      := TGroup():New( 016,004,068,212,"  Favor Informar o Valor do Frete:   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oDlg1      := MSDialog():New( 088,232,292,670,"INFORMA��ES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 008,004,076,212," Favor Definir a Urg�ncia da Compra ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	
	oSayURG      := TSay():New( 032,012,{||"Compra � Urgente ? "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	//oValFrete  := TGet():New( 032,076,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)
	oCBoxU     := TComboBox():New( 032,076,,{"S=Sim","N=Nao"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cUrgente )
	oCBoxU:bSetGet := {|u| If(PCount()>0,cUrgente:=u,cUrgente)}

	oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )
	oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
	  
	oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
	oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
	
	oDlg1:Activate(,,,.T.)
	x:= 0
	If nOpcA = 1 
		For x:= 1 To Len(aCols)	
			If !(aCols[x,Len(aHeader)+1]) //se a linha do acols n�o estiver deletada						
				aCols[x,nPOSURG]:= cUrgente
			Endif
		Next                                              
		
	Endif 
Else
	MsgInfo("SEM PERMISS�O para Alterar No modo Visualizar !")
Endif

Return 

