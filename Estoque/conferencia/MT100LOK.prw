#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  � Gustavo Costa      � Data �  05/29/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o de Valida��o ( linha OK da Getdados) para Inclus�o/ ���
���          � Altera��o do item da NFE.								  ���
���				Valida se o Item o Pedido de Compra do Item, j� tenha uma ���
���				Guia de Confer�ncia para ele. Caso n�o tenha. Bloqueia.   ���
�������������������������������������������������������������������������͹��
���				Valida o Item do tipo Servi�o, se tem um aciete POSITIVO  ���
���				para o Pedido de Compra (ZB4). Caso n�o tenha. Bloqueia.  ���
�������������������������������������������������������������������������͹��
���Uso       � Em que Ponto: No final das valida��es ap�s a confirma��o da���
���            inclus�o ou altera��o da linha, antes da grava��o da NFE.  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100LOK()

Local lExecuta 	:= .T. //ParamIxb[1]
Local cQuery		:= ""
Local cQuery2		:= ""
Local cString		:= "LOK"
Local cPedC		:= aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})]

Local cTES 	  	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})				        	// Posicao do TES
Local cProd 	  	:= aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'})]				        	// Posicao do Produto
Local cPOSIPI	  	:= aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TEC'})]				        	// Posicao do Produto

Local nPosNCM       := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TEC'})   //POSI��O NUM�RICA NO ARRAY
Local nPosTES       := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})   //POSI��O NUM�RICA NO ARRAY

Local aCombo		:= {}
Local cGuia		:= "" 
Local cExcecoes :=  GetMv("RV_EXCNCM" )
//"020/021/022/102/105/106/107/114/164"
Local cEXCGUIA  :=  GetMv("RV_EXCGUIA" ) //par�metro exce��es para n�o pedir guia confer�ncia
//164
Local cTipoProd	:= POSICIONE("SB1",1,xFilial() + cProd, "B1_TIPO")

local lFretComp:=.F.

/*
TES EXCE��ES para n�o pedir NCM:
energia=107
�gua=114
servi�o=102
cart�rio=164
FRETE: 105,106,020,021,022
*/
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg1","oGrp1","oCBox1","oSay1","oSBtn1","oSBtn2")

If Alltrim(FUNNAME()) = 'MATA116'  //se for rotina de nf conhecimento frete, n�o pede para digitar a NCM
	Return .T.
Endif         

if l103Class // classifica 
  SF8->(dbSetOrder(2))
  If SF8->(Dbseek(xFilial("SF8") + CNFISCAL + CSERIE +CA100FOR+CLOJA ))
     IF EMPTY(SF1->F1_APROV) // verifico se ja foi liberado, se foi nao precisa divergir mas. 
        lFretComp:=.T.
     ENDIF   
  Endif
Endif                                                            admin	

If ! lFretComp
	//Soh faz validacao para pedios Normais e que o TES est� contido no par�metro
	If cTipoProd <> 'ST' .and.( !INCLUI .OR. cTipo <> "N" .OR. ((aCols[1][cTes]) $ Trim(GetNewPar("MV_XTESPCN",""))) )
		Return .T.
	EndIf
Endif
//Atualiza NCM do produto

cQuery2 := " UPDATE " + RetSqlName("SB1")
cQuery2 += " SET B1_POSIPI = '" + cPOSIPI + "' "
cQuery2 += " WHERE B1_COD = '" + cProd + "' "
cQuery2 += " AND B1_TIPO NOT IN ('PA','PI') "

TCSqlExec(cQuery2)


cQuery := " SELECT DISTINCT ZAB_DOC FROM " + RetSqlName("ZAB") + " AB "
cQuery += " INNER JOIN " + RetSqlName("ZAA") + " AA "
cQuery += " ON ZAB_FILIAL = ZAA_FILIAL "
cQuery += " AND ZAB_DOC = ZAA_DOC "
cQuery += " AND ZAB_SEQ = ZAA_SEQ "
cQuery += " WHERE ZAB_FILIAL = '" + xFilial("ZAB") + "' "
cQuery += " AND ZAB_PEDIDO = '" + cPedC + "' "
cQuery += " AND AB.D_E_L_E_T_ <> '*' "
cQuery += " AND ZAA_STATUS = '' "

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

(cString)->(DBGOTOP())

If !Alltrim( aCols[n][nPosTES] ) $ cEXCGUIA .and. cTipoProd <> 'ST'
	IF Empty((cString)->ZAB_DOC)
		MsgAlert("N�o existe Guia de Confer�ncia para este pedido " + AllTrim(cPedC) + ". Imposs�vel de Continuar!")
		lExecuta	:= .F.
	Else
		While (cString)->(!EOF())
			AADD(aCombo, (cString)->ZAB_DOC)
			(cString)->(dbSkip())
		EndDo
	EndIf
Endif

(cString)->(DBGOTOP())

If len(aCombo) > 1
	
	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 273,579,376,761,"Sele��o",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 000,000,037,088,"Guia de Confer�ncia",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oCBox1     := TComboBox():New( 020,008,,aCombo,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oCBox1:bSetGet := {|u| If(PCount()>0,cGuia:=u,cGuia)}
	oSay1      := TSay():New( 008,008,{||"Selecione a contagem:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
	oSBtn1     := SButton():New( 037,062,1,{||oDlg1:End()},oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)
	
	aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="D1_XCONTAG"})] := cGuia
	
Else
	
	aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="D1_XCONTAG"})] := (cString)->ZAB_DOC
	
EndIf

If Alltrim(FUNNAME()) = 'MATA103' .and. cTipoProd <> 'ST'
	If !(aCols[n,Len(aHeader)+1])    //se a linha n�o estiver deletada
		If !Alltrim( aCols[n][nPosTES] ) $ cExcecoes   //se n�o estiver dentro da exce��es, vai criticar NCM
			If Empty( aCols[n][nPosNCM] )			
				Aviso(	"NF Entrada",;
						"Falta informar a NCM para o item "+BuscAcols("D1_ITEM")+".",;
						{"&Ok"},,;
						"Classifica��o Fiscal") 
				lExecuta := .F.
					
			Endif	
		Else
			lExecuta := .T.  //SE FIZER PARTE DAS EXCE��ES, N�O CRITICA E RETORNA .T.
		Endif
	Endif
Endif


If cTipoProd == 'ST'

	lExecuta := fTemAuto(cPedC)
	
	If !lExecuta
		MsgAlert("N�o existe uma autoriza��o positiva para este servi�o. Imposs�vel de Continuar!")
	EndIf	

EndIf


(cString)->(dbCloseArea())

Return (lExecuta)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fTemAuto  �Autor  �Gustavo Costa       � Data �  18/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na gravacao da S.C.                        ���
���          �Utilizado para enviar email para os diretores               ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fTemAuto(cPed)

LOCAL cQry		:=''
local lRet		:= .F.

cQry	:= " SELECT * FROM " + RETSQLNAME("ZB4")  
cQry	+= " WHERE ZB4_DOC = '" + cPed + "' "
cQry	+= " AND ZB4_FILIAL = '" + xFilial("ZB4") + "' "
cQry	+= " AND D_E_L_E_T_ <> '*' "

TCQUERY cQry NEW ALIAS "XZB4"

XZB4->(dbgotop())

If XZB4->ZB4_STATUS = '1'
	lRet	:= .T.   
EndIf

XZB4->(DBCLOSEAREA())

Return  lRet 