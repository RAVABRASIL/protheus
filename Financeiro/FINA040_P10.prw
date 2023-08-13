#Include "Rwmake.ch"
#include 'Ap5Mail.ch'
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦ Programa ¦ Fina040  ¦ Autor ¦ Flávia Rocha          ¦ Data ¦ 21/12/2010¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦Descrição ¦ Gravar Data Valida no cpo E1_VENCREA qdo alterado          ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦ Uso      ¦ Prorrogação de título                                      ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

//atendendo ao chamado 001910 - onde na alteração de título a receber por prorrogação,
//o sistema grave a data somente de dia útil, mesmo se digitado uma data que caia no sábado ou domingo
//obs: no campo E1_VENCTO o sistema já processa isto por padrão, mas como na alteração por 
//prorrogação o campo alterado é o E1_VENCREA, isto não ocorre, sendo necessária esta intervenção. 

//esta função será acionada quando clicado o botão "OK" e for alteração do título a receber (rotina FINA040).

******************************
User Function FINA040()
******************************

Local dAux := Ctod("  /  /    ")   //esta variável será uma auxiliar para receber primeiro o que foi digitado (memória)
                                   //e depois, a própria M->E1_VENCREA irá receber DataValida(dAux)
                                   //para que no momento da gravação, o programa grave a variável de memória já com a Data Valida.
                                   

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

          