#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMC014     º Autor ³ Flávia Rocha    º Data ³  29/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Alimenta legenda pré-Aprovação do browse de                º±±
±±º          ³ Solicitações de Compra                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função que alimenta o ini do browse campo C1_PREALEG       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************************
User Function COMC014()  
*************************

///////////////////////////////////////////////////////////////////////////////
//A FINALIDADE DESTE INI DE BROWSE, É ALIMENTAR O CAMPO AUXILIAR NA LEGENDA
//C1_PREALEG -> PRÉ-APROVADA?
//INDICA SE A SC JÁ FOI PRÉ-APROVADA (PELO GERENTE MANUTENÇÃO).
//SOMENTE AS SCs DE MATERIAIS TIPO: MQ, MH precisam de pré-aprovação
//ENTÃO, PARA AUXILIAR NA VISUALIZAÇÃO, CRIEI O CAMPO C1_PREALEG
//QUE MOSTRA: 
// - OK PARA: SCs APROVADAS, SCs PRÉ-APROVADAS
// - PTO PEDIDO: SCs geradas via Pto Pedido
// - AGUARDANDO: PARA SCs que ainda precisam de PRÉ-APROVAÇÃO
///////////////////////////////////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//INI BROWSE: U_COMC014()                                                                     
//ini browse anterior: IF(!EMPTY(SC1->C1_PREAPRO),IF(!EMPTY(SC1->C1_PREOK),"OK", "AGUARDANDO"), "OK")  

Local cLeg     := ""
Private cString := "SC1"

IF SC1->C1_APROV != "L"   //SE A SC AINDA NÃO ESTIVER APROVADA
	IF !EMPTY(SC1->C1_PREAPRO) //SE FOR PASSÍVEL DE PRÉ-APROVAÇÃO
		IF !EMPTY(SC1->C1_PREOK)   //VERIFICA FOI PRÉ-APROVADO
			cLeg := "OK"
		ELSEIF SC1->C1_ORIGEM $ 'WFGERASC/GERASCX' //CASO NÃO, VERIFICA SE É SC DE PTO PEDIDO
			cLeg := "PTO PEDIDO"
		ELSE                    //CASO CONTRÁRIO, MOSTRA AGUARDANDO
			cLeg := "AGUARDANDO"
		ENDIF
	ELSE
		cLeg := "OK"
	ENDIF

ELSE     //SE ESTIVER APROVADA, MOSTRA OK
	cLeg := "OK"
ENDIF

Return(cLeg)
