#INCLUDE "rwmake.ch"

/*/
////////////////////////////////////////////////////////////////
//Programa: TMKC020 
//Objetivo: Browse do hist�rico de ocorr�ncias do Call Center
//Autoria : Fl�via Rocha
//Data    : 19/04/2010.
////////////////////////////////////////////////////////////////
/*/

User Function TMKC020C()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZUD"

dbSelectArea("ZUD")
dbSetOrder(1)

AxCadastro(cString,"Historico Ocorr�ncias Call Center",cVldExc,cVldAlt)

Return
