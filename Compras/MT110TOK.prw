#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110TOK  ºAutor  ³Gustavo Costa       º Data ³  18/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na gravacao da S.C.                        º±±
±±º          ³Utilizado para enviar email para os diretores               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  MT110TOK()

Local nPosPrd    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nPosNum    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_NUM'})
Local nPosUM    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_UM'})
Local nPosQtd    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QUANT'})
Local nPosOBS    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_OBS'})
Local nPosCC    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CC'})
Local nPosEmi    	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_EMISSAO'})
Local nPosDesc		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_DESCRI'})
Local nPosURG		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1__URGEN'}) //indica que a SC é urgente
Local lUrgente      := .F.
Local nTotal		:= 0

Local cCopia 		:= ""//GetNewPar('MV_XCOPBLQ',"marcelo@ravaembalagens.com.br")
Local cMailTo 		:= GetNewPar('MV_XMAILSC',"gustavo@ravaembalagens.com.br")
Local lEnviado		:= .F.
Local cTitulo		:= "Solicitação de Compra - " + cA110Num
Local cConteudo		:= ""
Local cAnexo		:= ""
LOCAL lOk			:=.F.
Local cCCAnt        := ""

For x := 1 TO len(aCols)

	If x > 1
		 If aCols[x][nPosCC] <> cCCAnt
		 	MsgAlert("Impossível solicitar para mais de um Centro de Custo na mesma solicitação!")
		 	Return .F.
		 EndIf
	EndIf	
	cCCAnt	:= aCols[x][nPosCC] 
	
	If Alltrim(aCols[x][nPosURG]) = "S"
		lUrgente := .T.
	Endif

Next

If lUrgente
	Aviso("M E N S A G E M", "Para Definir Solicitação de Compra URGENTE, " + CHR(13) + CHR(10);
				   + "Somente Com a Senha do Diretor.", {"OK"})
	lOk := U_senha2( "28", 5 )[ 1 ]  //MARCELO / ORLEY
	If !lOk
		Alert("Acesso Negado !!!") 
		Return lOk	             
	Endif
Endif

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml' >"
cConteudo +="<head>"
cConteudo +="	<title>Untitled Page</title>"
cConteudo +="</head>"
cConteudo +="<body>"
dbSelectArea("SM0")
cConteudo +=" Empresa - " + SM0->M0_FILIAL + "<br>"
cConteudo +="    <table width='800' height='79' border='1'>"
cConteudo +="        <tr>
cConteudo +="            <td align='center' colspan='7' bgcolor='#009933'>"
cConteudo +="               <strong> SOLICITAÇÃO DE COMPRA - " + cA110Num + " - " + DtoC(dDataBase) + "</strong> </td>"
cConteudo +="        </tr>"
cConteudo +="        <tr>"
cConteudo +="            <td align='center' width='80' height='23' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>CÓDIGO</strong></td>"
cConteudo +="            <td align='center' width='228' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>DESCIÇÃO</strong></td>"
cConteudo +="            <td align='center' width='40' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>UM</strong></td>"
cConteudo +="            <td align='center' width='90' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>QTD.</strong></td>"
cConteudo +="            <td align='center' width='100' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>ULT. COMP.</strong></td>"
cConteudo +="            <td align='center' width='100' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>DATA U.C.</strong></td>"
cConteudo +="            <td align='center' width='222' bgcolor='#CCFFCC'>"
cConteudo +="                <strong>OBS</strong></td>"
cConteudo +="        </tr>"

//Itens
For x := 1 TO len(aCols)

	cConteudo +="        <tr>"
	cConteudo +="            <td align='left' width='80' height='23'>"
	cConteudo += aCols[x][nPosPrd] + "</td>"
	cConteudo +="            <td align='left' width='228'>"
	cConteudo += aCols[x][nPosDesc] + "</td>"
	cConteudo +="            <td align='center' width='40'>"
	cConteudo += aCols[x][nPosUM] + "</td>"
	cConteudo +="            <td align='rigth' width='90'>"
	cConteudo += Transform(aCols[x][nPosQtd],"@E 99,999,999.99") + "</td>"
	cConteudo +="            <td align='rigth' width='100'>"
	aVal 	:= U_fUltPreco(aCols[x][nPosPrd])
	cConteudo += Transform(aVal[1],"@E 99,999,999.99") + "</td>"
	cConteudo +="            <td align='rigth' width='100'>"
	cConteudo += DtoC(StoD(aVal[2])) + "</td>"
	cConteudo +="            <td align='left' width='222'>"
	cConteudo += aCols[x][nPosOBS] + "</td>"
	cConteudo +="        </tr>"
	nTotal +=  aCols[x][nPosQtd] * aVal[1]
Next

//Totalizador
cConteudo +="<tr>"
cConteudo +="    <td height='23' colspan='5' bgcolor='#CCFFCC'><strong> TOTAL </strong></td>"
cConteudo +="    <td align='rigth' width='90' bgcolor='#CCFFCC'><strong>"
cConteudo += Transform(nTotal,"@E 99,999,999.99") + "</strong></td>"
cConteudo +="  </tr>"

cConteudo +="    </table>"
cConteudo +="</body>"
cConteudo +="</html>"

cCopia 	:= GetNewPar('MV_XCOPSC',"")

cAnexo	:= ""

If SubStr(aCols[1][nPosCC],1,1) $ "7" //Produção
	cMailTo 	:= GetNewPar('MV_XMAILSC1',"giancarlo.sousa@ravaembalagens.com.br")
Else
	cMailTo 	:= GetNewPar('MV_XMAILSC2',"giancarlo.sousa@ravaembalagens.com.br")
EndIf

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )
//lEnviado := U_fEnvMail(cMailTo, cTitulo, cConteudo, {}, .T., .F.)

If lEnviado
	MsgAlert("Solicitação enviada por E-mail para seu diretor !! ")
Else
	MsgStop("E-mail não enviado !! Por favor, informar ao seu diretor sobre sua solicitação.")
EndIf


/*
If INCLUI
	For _X:=1 to len(aCols)
	    IF ALLTRIM(Posicione("SB1",1,xFilial("SB1") + aCols[_X][nPosPrd], "B1_GRUPO") ) $ '0012'
	       lOk:=.T.
	       Exit
	    ENDIF
	Next 
	If lOk
	   Destino()
	EndIf
Endif
*/

Return .T. 


***************

Static Function Destino()

***************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgServ","oGrp1","oCBox1","oSay1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgServ   := MSDialog():New( 234,625,351,803,"Destino do Serviço",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,000,037,083,"",oDlgServ,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBox1     := TComboBox():New( 017,004,,{"Saco","Caixa"},073,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1:nAt :=1   
oSay1      := TSay():New( 007,004,{||"Fabrica de :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSBtn1     := SButton():New( 040,021,1,,oDlgServ,,"", )
oSBtn1:bAction := {||Ok()}
oSBtn2     := SButton():New( 040,057,2,,oDlgServ,,"", )
oSBtn1:bAction := {||oDlgServ:End()}
  
oDlgServ:Activate(,,,.T.)

Return  

***************

Static Function Ok()

***************

RecLock( "SC1", .F. )

if oCBox1:nAt :=1   
   SC1->C1_SERVDES:='S'
elseif oCBox1:nAt :=2   
   SC1->C1_SERVDES:='C'
endif

SC1->( msUnlock() )
SC1->( dbCommit() )

oDlgServ:End()

return


***************

User Function fUltPreco(cCod)

***************
LOCAL cQry		:=''
local aRet		:= {}

cQry	:= "SELECT TOP 1 D1_VUNIT + D1_VALIPI VALOR, D1_DTDIGIT FROM " + RETSQLNAME("SD1") + " D1 "
cQry	+= " INNER JOIN " + RETSQLNAME("SF4") + " F4 "
cQry	+= " ON D1_TES = F4_CODIGO "
cQry	+= " WHERE D1_COD = '" + cCod + "' "
cQry	+= " AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQry	+= " AND D1.D_E_L_E_T_ <> '*' "
cQry	+= " AND F4.D_E_L_E_T_ <> '*' "
cQry	+= " AND F4_DUPLIC = 'S' "
cQry	+= " ORDER BY D1_DTDIGIT DESC "

TCQUERY cQry NEW ALIAS "TMP"

TMP->(dbgotop())

If TMP->(!EOF())
   
	aRet	:= {TMP->VALOR , TMP->D1_DTDIGIT}

else

	aRet := {0 , ""}
 
Endif

TMP->(DBCLOSEAREA())

Return  aRet 
