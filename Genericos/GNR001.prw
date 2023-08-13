#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENE001   º Autor ³ Flávia Rocha       º Data ³  22/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função Genérica 001 - Calcula a diferença em horas         º±±
±±º          ³ de um intervalo fornecido: hora fim - hora inicio = xhoras º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Genérico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
***********************************
User Function GNR001(cHr1,cHr2) 
***********************************
//CALCULA DIFERENÇA EM HORAS, DENTRO DE UM INTERVALO

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
//nHr1 - Primeiro Horário
//nHr2 - Segundo Horário

//IncTime<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> cTimeInc
//Local cTime    := Time() //"02:03:05"
//Local cTimeInc

//cTimeInc := IncTime( cTime , 10 , 10 , 10 )
//? cTimeInc := "12:13:15"...
/*
E, já adiantando o expediente, para cada função de incremento de horas existe a correspondente inversa. Ex.:

para: SomaHoras(<nHr1>,<nHr2>)-> nHrsSum
Existe: SubHoras(<nHr1>,<nHr2>)-> nHrsSub

para:
IncTime<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> cTimeInc

Existe:
DecTime<cTime>],<nDecHours>,<nDecMinuts>,<nDecSeconds> ) -> cDecTime
*/