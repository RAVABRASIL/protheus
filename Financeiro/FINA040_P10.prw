#Include "Rwmake.ch"
#include 'Ap5Mail.ch'
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+----------+----------+-------+-----------------------+------+----------+��
��� Programa � Fina040  � Autor � Fl�via Rocha          � Data � 21/12/2010���
��+----------+----------+-------+-----------------------+------+----------+��
���Descri��o � Gravar Data Valida no cpo E1_VENCREA qdo alterado          ���
��+----------+------------------------------------------------------------+��
��� Uso      � Prorroga��o de t�tulo                                      ���
��+----------+------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//atendendo ao chamado 001910 - onde na altera��o de t�tulo a receber por prorroga��o,
//o sistema grave a data somente de dia �til, mesmo se digitado uma data que caia no s�bado ou domingo
//obs: no campo E1_VENCTO o sistema j� processa isto por padr�o, mas como na altera��o por 
//prorroga��o o campo alterado � o E1_VENCREA, isto n�o ocorre, sendo necess�ria esta interven��o. 

//esta fun��o ser� acionada quando clicado o bot�o "OK" e for altera��o do t�tulo a receber (rotina FINA040).

******************************
User Function FINA040()
******************************

Local dAux := Ctod("  /  /    ")   //esta vari�vel ser� uma auxiliar para receber primeiro o que foi digitado (mem�ria)
                                   //e depois, a pr�pria M->E1_VENCREA ir� receber DataValida(dAux)
                                   //para que no momento da grava��o, o programa grave a vari�vel de mem�ria j� com a Data Valida.
                                   

If Altera
	
	SE1->(Dbsetorder(1))
	If SE1->(Dbseek(xFilial("SE1") + SE1->E1_PREFIXO+ SE1->E1_NUM+ SE1->E1_PARCELA + SE1->E1_TIPO ))
		dAux := M->E1_VENCREA
		M->E1_VENCREA := DataValida(dAux)
				 		
		RecLock("SE1",.F.)
		SE1->E1_VENCREA := M->E1_VENCREA 
		
		SE1->(MsUnlock())
	
	Endif

Endif


Return

          