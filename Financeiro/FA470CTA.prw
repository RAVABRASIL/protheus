/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FA470CTA � Autor �Eurivan Marques        � Data �28/11/2007 ���
�������������������������������������������������������������������������Ĵ��
���          �Ponto de Entrada para modifica��o da Agencia Conta na       i��
�� Descricao �Concilia��o Autom�tica                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Financeiro                                                  ���
���������������������������������������������������������������������������*/

User Function FA470CTA()
Local aCta := {}

Aadd( aCta, PARAMIXB[1] )
Aadd( aCta, PARAMIXB[2]+"1" )//Adiciono o digito da Agencia
Aadd( aCta, Left(Alltrim(Str(Val(PARAMIXB[3]))),4)+"-"+Right(PARAMIXB[3],1) ) //Retiro os Zeros e coloco hifen entre a conta e o digito

Return aCta
