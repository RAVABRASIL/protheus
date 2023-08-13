#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENE001   � Autor � Fl�via Rocha       � Data �  22/08/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o Gen�rica 001 - Calcula a diferen�a em horas         ���
���          � de um intervalo fornecido: hora fim - hora inicio = xhoras ���
�������������������������������������������������������������������������͹��
���Uso       � Gen�rico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
***********************************
User Function GNR001(cHr1,cHr2) 
***********************************
//CALCULA DIFEREN�A EM HORAS, DENTRO DE UM INTERVALO

Local cH1,cM1,cS1
Local cHoras:="00:00:00"

//cHr1 := "07:30"
//cHr2 := "12:00"

cH1:=Subs(cHr1,1,2) ; cM1:=Subs(cHr1,4,2) ; cS1:=Subs(cHr1,7,2)
If !Empty(cHr2)
     cHoras := DecTime(cHr2,Val(cH1),Val(cM1),Val(cS1))
Endif

Return(cHoras)


//SomaHoras (nHr1,nHr2) --> Soma as Horas
//nHr1 - Primeiro Hor�rio
//nHr2 - Segundo Hor�rio

//IncTime<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> cTimeInc
//Local cTime    := Time() //"02:03:05"
//Local cTimeInc

//cTimeInc := IncTime( cTime , 10 , 10 , 10 )
//? cTimeInc := "12:13:15"...
/*
E, j� adiantando o expediente, para cada fun��o de incremento de horas existe a correspondente inversa. Ex.:

para: SomaHoras(<nHr1>,<nHr2>)-> nHrsSum
Existe: SubHoras(<nHr1>,<nHr2>)-> nHrsSub

para:
IncTime<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> cTimeInc

Existe:
DecTime<cTime>],<nDecHours>,<nDecMinuts>,<nDecSeconds> ) -> cDecTime
*/