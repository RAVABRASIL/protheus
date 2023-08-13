#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COMC014     � Autor � Fl�via Rocha    � Data �  29/10/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Alimenta legenda pr�-Aprova��o do browse de                ���
���          � Solicita��es de Compra                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Fun��o que alimenta o ini do browse campo C1_PREALEG       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************************
User Function COMC014()  
*************************

///////////////////////////////////////////////////////////////////////////////
//A FINALIDADE DESTE INI DE BROWSE, � ALIMENTAR O CAMPO AUXILIAR NA LEGENDA
//C1_PREALEG -> PR�-APROVADA?
//INDICA SE A SC J� FOI PR�-APROVADA (PELO GERENTE MANUTEN��O).
//SOMENTE AS SCs DE MATERIAIS TIPO: MQ, MH precisam de pr�-aprova��o
//ENT�O, PARA AUXILIAR NA VISUALIZA��O, CRIEI O CAMPO C1_PREALEG
//QUE MOSTRA: 
// - OK PARA: SCs APROVADAS, SCs PR�-APROVADAS
// - PTO PEDIDO: SCs geradas via Pto Pedido
// - AGUARDANDO: PARA SCs que ainda precisam de PR�-APROVA��O
///////////////////////////////////////////////////////////////////////////////

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
//INI BROWSE: U_COMC014()                                                                     
//ini browse anterior: IF(!EMPTY(SC1->C1_PREAPRO),IF(!EMPTY(SC1->C1_PREOK),"OK", "AGUARDANDO"), "OK")  

Local cLeg     := ""
Private cString := "SC1"

IF SC1->C1_APROV != "L"   //SE A SC AINDA N�O ESTIVER APROVADA
	IF !EMPTY(SC1->C1_PREAPRO) //SE FOR PASS�VEL DE PR�-APROVA��O
		IF !EMPTY(SC1->C1_PREOK)   //VERIFICA FOI PR�-APROVADO
			cLeg := "OK"
		ELSEIF SC1->C1_ORIGEM $ 'WFGERASC/GERASCX' //CASO N�O, VERIFICA SE � SC DE PTO PEDIDO
			cLeg := "PTO PEDIDO"
		ELSE                    //CASO CONTR�RIO, MOSTRA AGUARDANDO
			cLeg := "AGUARDANDO"
		ENDIF
	ELSE
		cLeg := "OK"
	ENDIF

ELSE     //SE ESTIVER APROVADA, MOSTRA OK
	cLeg := "OK"
ENDIF

Return(cLeg)
