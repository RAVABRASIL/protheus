#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

/*
�����������������������������������������������������������������������������
���Desc.     � Gerenciador da cobranca                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rava Embalagens - Cobranca                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COBC04()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,AROTINA,")


cCadastro := "Gerenciador da cobranca"

aRotina := { { "Pesquisar" ,'AxPesqui',0,1} ,;
{ "Consultar"       ,'U_COBC041()',0,6 },;
{ "Rel Fila"        ,'U_COBR06()' ,0,6 },;
{ "Pos Fila"        ,'U_COBR07()' ,0,6 },;
{ "Rel Atendim"     ,'U_COBR09()' ,0,6 },;
{ "Operadores"      ,'U_COBC042()',0,6 } }

mBrowse(6,1,22,75,"ZA2")

Return(nil)

/*
aItems := {"1 - Codigo Cliente","2 - Nome Cliente","3 - CGC / CPF","4 - Pedido","5 - T�tulo","6 - Valor","7 - Cidade",;
"8 - Cod Identificador","9 - Nosso N�mero","10 - Status Cob","11 - Telefone","12 - Grupo Empresarial",;
"13 - Representante","14 - Retorno Agendado","15 - D-(n Dias)","16 - Acordo Agendado","17 - Cheques"}
*/
