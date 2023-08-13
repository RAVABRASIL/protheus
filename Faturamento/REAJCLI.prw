#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

/*�����������������������������������������������������������������������ͻ��
���Programa  �REAJCLI   �Autor  �Eurivan Marques     � Data �  01/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se o preco praticado � menor que o ultimo pre�o e  ���
���          �se o est� abaixo da tabela em vigor.                        ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������ͼ*/

*******************************************
User function ReajCli(cCli,cLoj,cProd,nPrc)
*******************************************
Local aArea	:= GetArea()
Local lRet  := .T.
Local nMg
Local nDif, nUPrc, dUFat, cQuery
Local cTESEXCEC := GETMV("RV_TESC6") 

//Caso o cliente esteja em branco o sistema
//n�o permitira que o pre�o seja digitado.
if Empty(cCli)
   Alert("Favor informar o codigo de cliente antes do pre�o.")
   Return .F.
endif
   
DbSelectArea("SB1")
DbSetOrder(1)
SB1->(DbSeek(xFilial("SB1")+cProd))

DbSelectArea("SA1")
DbSetOrder(1)
SA1->(DbSeek(xFilial("SA1")+cCli+cLoj))

If ( M->C5_TIPO != "N" ) .or.; 
	( SA1->A1_TES $ cTESEXCEC ) .or.;
	( alltrim(upper(FunName())) == "ESTC005" )
	Return .T.
Endif

nPrc1 := RavaMrg( cProd, SA1->A1_EST, 1 ) //1 traz o campo tabela
if Abs( nPrc1 - nPrc ) > Abs(nPrc1*0.001) //Desconsidero diferen�a de arredondamento na geracao das tabelas
   if nPrc1 > 0
      if nPrc1 > nPrc
         lRet := .F.
         Alert("Pre�o atual n�o poder� ser menor que o da tabela.")   
      endif
   else
      lRet := .F.
      Alert("Produto sem pre�o atualizado no sistema.")
   endif
endif
RestArea(aArea)

Return lRet

//��������������������������������������Ŀ
//�Converte c�digo do produto em gen�rico�
//����������������������������������������
****************************
Static Function codgen(cCod)
****************************

If Len( AllTrim( cCod ) ) <= 7
	If Subs( cCod, 4, 1 ) == "R"
		cCod := Subs( AllTrim( cCod ), 1, 1 ) + "D" + Subs( AllTrim( cCod ), 2, 4 ) + "6" +Subs( AllTrim( cCod ), 6, 2 )
	Else
		cCod := Subs( AllTrim( cCod ), 1, 1 ) + "D" + Subs( AllTrim( cCod ), 2, 3 ) + "6" +Subs( AllTrim( cCod ), 5, 2 )
	EndIf
EndIf

Return cCod


//Verifica margem do produto para o 
//preco e UF passadas nos parametros
/*
Tabelas Z32 - Custo Variavel por Produto
        Z33 - Frete por UF - Valor em na UM do produto
*/
*****************************************
static Function RavaMrg(cProduto,cUF,nMg)
*****************************************
Local nRet

if ! Empty(cProduto)
   DbSelectArea("SB1")
   SB1->(DbSetOrder(1))
   SB1->(DbSeek(xFilial("SB1")+cProduto) )

   DbSelectArea("Z36")
   DbSetOrder(1)
   if Z36->( DbSeek(xFilial("Z36")+cProduto+cUF))
      if nMG = 0
         nRet := Z36->(FieldGet(FieldPos("Z36_CUSTO")))
      else
         nRet := Z36->(FieldGet(FieldPos("Z36_MRG"+StrZero(nMg,2))))         
      endif
   endif
endif
   
Return nRet