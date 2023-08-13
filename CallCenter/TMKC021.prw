#INCLUDE "rwmake.ch"

/*/
/////////////////////////////////////////////////////////////////////////////
//Programa: TMKC021 - Hist�rico de cumprimento de liga��es (AxCadastro)
//Autoria : Fl�via Rocha
//Data    : 03/05/2010
//Objetivo: Mensurar as liga��es di�rias e sua % de n�o cumprimento
////////////////////////////////////////////////////////////////////////////
/*/

User Function TMKC021


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZU8"

dbSelectArea("ZU8")
dbSetOrder(1)

AxCadastro(cString,"Historico de cumprimento de Liga��es",cVldExc,cVldAlt)

Return
