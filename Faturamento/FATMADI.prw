#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATMADI   � Autor � AP6 IDE            � Data �  30/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio para a emissao da carta de primeiro aniversario  ���
���          � de compra de um cliente.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************

User Function FATMADI( lAut, aPars )

*************

Private oFont01, oFont02, oFont03, oPrint, lAuto , aPar
lAuto := lAut                                          
aPar  := aPars
If lAuto = NIL
	lAuto := .F.
Endif

If !lAuto  // != NIL
	pergunte("FATANC",.T.)
//else
//	alert("autom�tico")
Endif
//��������������������������������������������Ŀ
//� Objeto que controla o tipo de Fonte        �
//����������������������������������������������

oFont01 	:= TFont():New('Verdana',10,10,.F.,.T.,5,.T.,5,.F.,.F.)
oFont02 	:= TFont():New('Verdana',08,08,.F.,.T.,5,.T.,5,.F.,.F.)
oFont03 	:= TFont():New('Verdana',10,10,.T.,.T.,5,.T.,5,.F.,.T.)

MsAguarde( { || runReport() }, "Aguarde. . .", "Os relat�rios est�o sendo gerados. . ." )

return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  30/10/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local nLinha  := 150
Local cQuery1 := ''
Local LF      := CHR(13) + CHR(10)

//��������������������������������������������Ŀ
//� Objeto que controla o tipo de impressao    �
//����������������������������������������������
//SetRegua( 0 )
cQuery1 := "select	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NMRESPO, SA1.A1_TEL, SA3.A3_COD, SA3.A3_NREDUZ, " + LF
cQuery1 += "SA1.A1_PRICOM, SA1.A1_NROCOM " + LF
cQuery1 += "from  " + retSqlName('SA1') + " SA1 left outer join " + retSqlName('SA3') + " SA3 on SA1.A1_VEND = SA3.A3_COD "  + LF
If !lAuto
	cQuery1 += "where SA1.A1_COD between '"+ mv_par02 +"' and '"+ mv_par03 +"' and (Year( getdate() )- Year( SA1.A1_PRICOM )) >= 1 " + LF
Else
	cQuery1 += "where SA1.A1_COD  IN ( " + LF
	For x := 1 to Len(aPar)
		If x < Len(aPar)
			cQuery1 += " '"+ aPar[x] + "' , "  + LF
		Endif
		If x = Len(aPar)
			cQuery1 += " '"+ aPar[x] + "'  "  + LF
		Endif
	Next
	cQuery1 += " ) " + LF
	cQuery1 += " and (Year( getdate() )- Year( SA1.A1_PRICOM )) >= 1 "  + LF
Endif

cQuery1 += "and month(SA1.A1_PRICOM) = '"+ MV_PAR01 +"' and SA1.A1_NROCOM > 0 " + LF
if ! empty( mv_par04 )
  cQuery1 += "and A1_ULTCOM >= '" + dtos(mv_par04) + "'  "   + LF
endIf
cQuery1 += "and SA1.A1_FILIAL = '" + xFilial("SA1") + "' and SA1.D_E_L_E_T_ != '*' " + LF
cQuery1 += "and SA3.A3_FILIAL = '" + xFilial("SA3") + "' and SA3.D_E_L_E_T_ != '*' " + LF
cQuery1 += "order by SA3.A3_COD, SA1.A1_PRICOM " + LF
//cQuery1 := changeQuery( cQuery1 )
MemoWrite("C:\TEMP\MALA.SQL" , cQuery1 )
TCQUERY cQuery1 NEW ALIAS 'SA1Y'
SA1Y->( dbGoTop() )
oPrint := TMSPrinter():New("Mala Direta")
oPrint:SetPortrait()

do While SA1Y->( !EoF() )
  oPrint:StartPage()//037 - 1080
  oPrint:Say(600 , 300, alltrim("Cabedelo/PB, " + alltrim( str( day(stod(SA1Y->A1_PRICOM)) ) ) + " " + mesExtenso(stod(SA1Y->A1_PRICOM)) + " de " + alltrim( str( year( dDataBase ) ) ) + "."), oFont01, 300, , , 0)
  //oPrint:Say(880 , 300, "De: RAVA Embalagens Ind. E Com. Ltda. ", oFont01, 300, , , 0) Altera��o 11/03/08
  //oPrint:Say(1020, 300, "Para: " + alltrim(SA1Y->A1_NOME) + " ", oFont01, 300, , , 0)  Altera��o 11/03/08
  oPrint:Say(1020, 300, alltrim(SA1Y->A1_NOME) + " ", oFont01, 300, , , 0)//Altera��o 11/03/08
  oPrint:Say(1230, 300, "Prezado(a) Senhor(a), ", oFont01, 300, , , 0)
  oPrint:Say(1440, 300, "Acolhemos  calorosamente  nossos novos amigos, sem esquecer os velhos amigos nos  neg�cios.", oFont01, 300, , , 0)
  oPrint:Say(1650, 300, "Portanto, viemos aqui lembra-lo(a) e parabeniz�-lo(a)  pelo seu "+alltrim(Str( Year( Date() ) - Year( STOD( SA1Y->A1_PRICOM ) ),4 ))+"� anivers�rio de 1� compra", oFont01, 300, , , 0)
  oPrint:Say(1720, 300, "a nossa empresa. "                      , oFont01, 300, , , 0)
  oPrint:Say(1860, 300, "Queremos que saiba que a RAVA estar� sempre pronta para servi-lo(a). "                      , oFont01, 300, , , 0)
  oPrint:Say(2000, 300, "Aproveitamos para anexar a  presente a rela��o  completa de nossos novos  produtos da linha", oFont01, 300, , , 0) 
  oPrint:Say(2070, 300, "hospitalar  e  dom�stica, para  facilitar  futuros  pedidos,  e  desde  j�  informamos  que", oFont01, 300, , , 0)
  oPrint:Say(2140, 300, "disponibilizaremos amostras de  qualquer outro produto que ainda n�o seja conhecido por sua", oFont01, 300, , , 0)
  oPrint:Say(2210, 300, "empresa. "  , oFont01, 300, , , 0)
  oPrint:Say(2350, 300, ">Fa�a sua solicita��o atrav�s do nosso Representante ou no e-mail sac@ravaembalagens.com.br", oFont03, 300, , , 0)
  oPrint:Say(2490, 300, "Colocamo-nos a disposi��o, procurando estar sempre � altura de suas exig�ncias. "           , oFont01, 300, , , 0)
  //oPrint:Say(2790,1090, "Cordiais Sauda��es,", oFont01, 300, , , 2)
  oPrint:Say(2790,1090, "Atenciosamente,", oFont01, 300, , , 2)
  oPrint:Say(2930,1090, "Raimundo Viana "    , oFont01, 300, , , 2)
  oPrint:Say(3000,1090, "Diretor Presidente ", oFont01, 300, , , 2)
  /*oPrint:Say(0300, 300, alltrim("Cabedelo/PB, " + alltrim( str( day(stod(SA1Y->A1_PRICOM)) ) ) + " " + mesExtenso(stod(SA1Y->A1_PRICOM)) + " de " + alltrim( str( year( dDataBase ) ) ) + "."), oFont01, 300, , , 0)
  oPrint:Say(0500, 300, alltrim("De: RAVA Embalagens Ind. E Com. Ltda. "), oFont01, 300, , , 0)
  oPrint:Say(0600, 300, alltrim("Para: " + alltrim(SA1Y->A1_NOME) + " "), oFont01, 300, , , 0)
  oPrint:Say(0800, 300, alltrim("Prezado(a) Senhor(a), "), oFont01, 300, , , 0)
  oPrint:Say(1000, 300, alltrim("Acolhemos calorosamente nossos novos amigos, sem esquecer os velhos amigos nos neg�cios. ")     , oFont01, 300, , , 0)
  oPrint:Say(1200, 300, alltrim("Portanto, viemos aqui lembra-lo(a) e parabeniz�-lo(a) pelo seu 1� anivers�rio de 1� compra")    , oFont01, 300, , , 0)
  oPrint:Say(1250, 300, alltrim("a nossa empresa. ")                                                                             , oFont01, 300, , , 0)
  oPrint:Say(1350, 300, alltrim("Queremos que saiba que a RAVA estar� sempre pronta para servi-lo(a). ")                         , oFont01, 300, , , 0)
  oPrint:Say(1450, 300, alltrim("Aproveitamos para anexar a presente a rela��o completa de nossos novos produtos da linha ")     , oFont01, 300, , , 0) 
  oPrint:Say(1500, 300, alltrim("hospitalar e dom�stica,para facilitar futuros pedidos, e desde j� informamos que ")             , oFont01, 300, , , 0)
  oPrint:Say(1550, 300, alltrim("disponibilizaremos amostras de qualquer outro produto que ainda n�o seja conhecido ")           , oFont01, 300, , , 0)
  oPrint:Say(1600, 300, alltrim("por sua empresa. ")                                                                             , oFont01, 300, , , 0)
  oPrint:Say(1700, 300, alltrim(">Fa�a sua solicita��o atrav�s do nosso Representante ou no e-mail sac@ravaembalagens.com.br")   , oFont03, 300, , , 0)
  oPrint:Say(1800, 300, alltrim("Colocamo-nos a disposi��o, procurando estar sempre � altura de suas exig�ncias. ")              , oFont01, 300, , , 0)
  oPrint:Say(2050,1090, alltrim("Cordiais Sauda��es,")                                                                           , oFont01, 300, , , 2)
  oPrint:Say(2150,1090, alltrim("Raimundo Viana ")                                                                               , oFont01, 300, , , 2)
  oPrint:Say(2200,1090, alltrim("Diretor Presidente ")                                                                           , oFont01, 300, , , 2)*/

  oPrint:EndPage()
  SA1Y->( dbSkip() )
  
endDo

oPrint:Preview()
SA1Y->( dbCloseArea() )
Return