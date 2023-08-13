#include "protheus.ch"
#include "topconn.ch"

*************

User Function FATAR01( cTipo )

*************

Private oFont01, oFont02, oFont03, oPrint
Private mvPar1, mvPar2, mvPar3
//��������������������������������������������Ŀ
//� Objeto que controla o tipo de Fonte        �
//����������������������������������������������

oFont01 	:= TFont():New('Verdana',20,20,.F.,.T.,5,.T.,5,.F.,.F.)
oFont02 	:= TFont():New('Verdana',08,08,.F.,.T.,5,.T.,5,.F.,.F.)
oFont03 	:= TFont():New('Verdana',12,12,.F.,.T.,5,.T.,5,.F.,.F.)
oFont04 	:= TFont():New('Verdana',15,15,.F.,.T.,5,.T.,5,.F.,.F.)
oFont05 	:= TFont():New('Verdana',10,10,.F.,.T.,5,.T.,5,.F.,.F.)
oFont06 	:= TFont():New('Courier New',09,09,.F.,.T.,5,.T.,5,.F.,.F.)
oFont07 	:= TFont():New('Arial',14,14,.F.,.T.,5,.T.,5,.F.,.F.)
oFont08 	:= TFont():New('Arial',12,12,.F.,.T.,5,.T.,5,.F.,.F.)
oFont09 	:= TFont():New('Arial',08,08,.F.,.T.,5,.T.,5,.F.,.F.)
oFont10 	:= TFont():New('Arial',10,10,.F.,.T.,5,.T.,5,.F.,.F.)
oFont11 	:= TFont():New('Arial',12,12,.F.,.F.,5,.T.,5,.F.,.F.)
if cTipo != Nil
	if cTipo == 'E'
		mvPar1 := mvPar2 := SF1->F1_DOC
		mvPar3 := 1
	elseIf cTipo == 'S'
		mvPar1 := mvPar2 := SF2->F2_DOC
		mvPar3 := 2		
	else
		msgAlert("Tipo de nota inv�lido!")
		return
	endIf
elseIf !Pergunte( "FATAR0", .T. )
	return 
else
	mvPar1 := mv_par01
	mvPar2 := mv_par02
	mvPar3 := mv_par03
endIf
MsAguarde( { || runReport() }, "Aguarde. . .", "Gerando nota de corre��o. . ." )

return

***************

Static Function runReport()

***************
Local aRetf  := {}
Local aItens := {}
Local nPos   := nX := nY := nZ := nK := 0
Local aEspec := {"Nome da Firma","Endere�o","Insc no CNPJ","Insc Estadual","Nat Opera��o e/ou Cod Fiscal", "Via de Transporte",;
				 "Data de Emiss�o da Nota","Data de Sa�da dos Produtos","S�rie e Sub-S�rie",;
				 "IPI Valor do Imposto","Valor Tot Nota","Unidade","Quantidade","Especifica��o(Esp�c.,Mod.,Tipo)",;
				 "Classifica��o Fiscal(TIPI)","Pre�o Unit�rio","ICMS: Vlr.Total e/ou Bs.de Calc.","ICMS: Al�quota",;
				 "ICMS: Valor Imposto","IPI: Valor Total(base de c�lculo)","IPI: Al�quota","Frete","Seguro","Total",;
				 "Nome do Transportador","Endere�o","Placa do Ve�culo","Marca","N�mero","Quantidade","Esp�cie","Peso",;
				 "ICMS: Isen��o","ICMS: Diferimento","ICMS: Suspens�o","ICMS: N�o-incid�ncia","ICMS: Redu��o da base de c�lc",;
				 "IPI: Isen��o","IPI: Suspens�o","Venc Duplicatas","Outros",""}
Local cAnt := cQuery := ''

cQuery += "select Z1_CORREG,Z1_EMISSAO, Z1_TIPO, Z1_NF, Z1_EMISSNF, Z1_CODCORR, Z1_CTDCORR, Z1_DESCORR, Z1_CLIENTE, R_E_C_N_O_ "
cQuery += "from   "+retSqlName('SZ1')+" "
cQuery += "where  Z1_FILIAL = '"+xFilial('SZ1')+"' and Z1_NF between '"+mvPar1+"' and '"+mvPar2+"' and D_E_L_E_T_ != '*' "
if mvPar3 == 1
	cQuery += "and Z1_TIPO = 'E' "
elseIf  mvPar3 == 2
	cQuery += "and Z1_TIPO = 'S' "
endIf
//NAO CONSIDERA FATURAMENTO PARA NOVA INDUSTRIAL
if mv_par04 == 2
	cQuery += "and Z1_CLIENTE NOT IN ('006543','007005') "
endIf

TCQUERY cQuery NEW ALIAS "_TMPX"
_TMPX->( dbGoTop() )
//cAnt := _TMPX->Z1_CORREG
do While ! _TMPX->( EoF() )
	cAnt := _TMPX->Z1_CORREG
	aAdd( aItens, { _TMPX->Z1_EMISSAO, _TMPX->Z1_TIPO, _TMPX->Z1_NF, _TMPX->Z1_EMISSNF, {}, _TMPX->Z1_CLIENTE, _TMPX->R_E_C_N_O_ } )
	do while ! _TMPX->( EoF() ) .and. cAnt == _TMPX->Z1_CORREG
		aAdd( aItens[ len( aItens ) ][5], { _TMPX->Z1_CODCORR, alltrim(upper(_TMPX->Z1_DESCORR))+": "+alltrim(_TMPX->Z1_CTDCORR) } )
		_TMPX->( dbSkip() )
	endDo
endDo
_TMPX->( dbCloseArea() )

oPrt := TMSPrinter():new("Nota de Corre��o")
oPrt:SetPortrait()
for a := 1 to len( aItens )
	oPrt:StartPage()
	
	oPrt:Box(  65,   90, 130, 1500, )
	oPrt:Say(  75,  100, "LOCAL E DATA", oFont05, 300, , , 0 )
	oPrt:Say(  75,  420, "Cabedelo, "+strzero( day( stod( aItens[a][1] ) ), 2 )+" de "+mesextenso( month( stod( aItens[a][1] ) ) )+" de "+alltrim(str( year( stod( aItens[a][1] ) ) ) )+" ", oFont02, 300, , , 0 )
	
	oPrt:Box(  65, 1500, 400, 2250, )
	oPrt:Say(  75, 1600, "CNPJ 41.150.160/0001-02", oFont05, 300, , , 0 )
	oPrt:Say( 125, 1670, "RAVA EMBALAGENS", oFont05, 300, , , 0 )
	oPrt:Say( 175, 1550, "IND�STRIA E COM�RCIO LTDA", oFont05, 300, , , 0 )
	oPrt:Say( 225, 1595, "Rua Jos� Ger�nimo da S. Filho, n� 66", oFont02, 300, , , 0 )
	oPrt:Say( 270, 1525, "Lot. Ns� Sr� da Concei��o - CEP:58310-000", oFont02, 300, , , 0 )
	oPrt:Say( 310, 1750, "Cabedelo - PB", oFont02, 300, , , 0 )
	
	/**/
	
	oPrt:Say( 215,  100, "�", oFont02, 300, , , 0 )
	oPrt:Line(248,   90, 248, 1500, )
	oPrt:Line(298,   90, 298, 1500, )
	oPrt:Line(348,   90, 348, 1500, )
	oPrt:Line(398,   90, 398, 1500, )
	if aItens[a][2] == 'E'
		SA2->( dbSeek( xFilial('SA2') + aItens[a][6], .T. ) )
		oPrt:Say( 265,  100, alltrim(SA2->A2_NREDUZ), oFont02, 300, , , 0 )
		oPrt:Say( 315,  100, alltrim(SA2->A2_END), oFont02, 300, , , 0 )
		oPrt:Say( 365,  100, alltrim(SA2->A2_MUN)+" - "+alltrim(SA2->A2_EST), oFont02, 300, , , 0 )
	else
		SA1->( dbSeek( xFilial('SA1') + aItens[a][6], .T. ) )
		oPrt:Say( 265,  100, alltrim(SA1->A1_NREDUZ), oFont02, 300, , , 0 )
		oPrt:Say( 315,  100, alltrim(SA1->A1_END), oFont02, 300, , , 0 )
		oPrt:Say( 365,  100, alltrim(SA1->A1_MUN)+" - "+alltrim(SA1->A1_EST), oFont02, 300, , , 0 )
	endIf
	/**/
	oPrt:Say( 450,  130, "REF.: CONFER�NCIA DE DOCUMENTO FISCAL E COMUNICA��O DE INCORRE��ES", oFont07, 300, , , 0 )
	
	oPrt:Box( 600,  130, 550, 200, )
	oPrt:Say( 550,  210, "S/ NOTA FISCAL N�", oFont08, 300, , , 0 )
	oPrt:Line(600,  640, 600, 860, )
	oPrt:Say( 550,   900, "S�RIE", oFont08, 300, , , 0 )
	oPrt:Line(600,  1060, 600, 1420, )
	oPrt:Say( 550,  1460, "DE", oFont08, 300, , , 0 )
	oPrt:Line(600,  1540, 600, 2190, )
	
	oPrt:Box( 690,  130, 640, 200, )
	oPrt:Say( 640,  210, "N/ NOTA FISCAL N�", oFont08, 300, , , 0 )
	oPrt:Line(690,  640, 690, 860, )
	oPrt:Say( 640,   900, "S�RIE", oFont08, 300, , , 0 )
	oPrt:Line(690,  1060, 690, 1420, )
	oPrt:Say( 640,  1460, "DE", oFont08, 300, , , 0 )
	oPrt:Line(690,  1540, 690, 2190, )
	
	if aItens[a][2] == 'E'
		oPrt:Line(600,  130, 550, 200, )
		oPrt:Line(600,  200, 550, 130, )
		oPrt:Say( 550,  650, alltrim(aItens[a][3]), oFont08, 300, , , 0 )		                                                            
		oPrt:Say( 550,  1070, "�NICA", oFont08, 300, , , 0 )
		oPrt:Say( 550,  1550, dtoc( stod( aItens[a][4] ) ), oFont08, 300, , , 0 )
	else
		oPrt:Line(690,  130, 640, 200, )
		oPrt:Line(690,  200, 640, 130, )
		oPrt:Say( 640,  650, alltrim(aItens[a][3]), oFont08, 300, , , 0 )
		oPrt:Say( 640,  1070, "�NICA", oFont08, 300, , , 0 )	
		oPrt:Say( 640,  1550, dtoc( stod( aItens[a][4] ) ), oFont08, 300, , , 0 )
	endIf
		
	oPrt:Say( 750,  130, "Em face do que determina a legisla��o fiscal vigente, vimos pela presente comunicar-lhe(s) que a Nota ", oFont11, 300, , , 0 )
	oPrt:Say( 800,   90, "Fiscal em refer�ncia cont�m  a(s)  irregularidades que abaixo apontamos,  cuja corre��o solicitamos que ", oFont11, 300, , , 0 )
	oPrt:Say( 850,   90, "seja providenciada imediatamente.  ", oFont11, 300, , , 0 )
	        
	for z := 1 to 3
		nX := 995;nY := 950
		if z == 1
			nZ := 130; nK := 218
		else
			nZ += 735; nK += 735
		endIf
		oPrt:Box( nX, nZ,  nY, nK + 503, )
		oPrt:Say( nX - 45, nZ + 90,  "C�DIGO E ESPECIFICA��O", oFont09, 300, , , 0 )
		nX := 995 + 45 ;nY := 950 + 45
		for i := 1 to 14
			nPos++
			oPrt:Box( nX,  nZ, nY, nK, )
			if aScan( aItens[a][5], { |x| x[1] == strzero( nPos , 2) } ) > 0
				oPrt:Line( nX,  nZ, nY, nK, )
				oPrt:Line( nX,  nK, nY, nZ, )		
			endIf
			oPrt:Box(  nX, nZ := nK, nY, nK += 503, )
			iif(nPos<42,oPrt:Say(  nX - 45,  nZ + 15, alltrim( str( nPos ) )+"-"+aEspec[nPos], oFont09, 300, , , 0 ),)
			nX += 45; nY += 45	
			if z == 1
				nZ := 130;   nK := 218
			elseIf z == 2
				nZ := 865;  nK := 953
			else
				nZ := 1600; nK := 1688
			endIf
		next
	next
	for p := 1 to len( aItens[a][5] )
		if p == 1 .or. nX >= 3115
			if nX >= 3115
				oPrt:EndPage()
				oPrt:StartPage()
				nX := 65; nY := 130
			endIf
			oPrt:Box( nX := nX + 10, 130, nY := nY + 165,  500, )
			oPrt:Say( nY - 95, 190,  "C�digo com", oFont10, 300, , , 0 )
			oPrt:Say( nY - 65, 175,  "Irregularidades", oFont10, 300, , , 0 )
			oPrt:Box(      nX, 500,  nY, 2195, )
			oPrt:Say( nY - 75, 870,  "RETIFICA��ES A SEREM CONSIDERADAS", oFont07, 300, , , 0 )
		endIf
		oPrt:Box( nX := nY, 130, nY += 105,  500, )
		oPrt:Say(  nY - 70, 290,  aItens[a][5][p][1], oFont10, 300, , , 0 )
		oPrt:Box(       nX, 500,       nY, 2195, )
		aRetf := wordWrap( alltrim( aItens[a][5][p][2] ), 90 )
		nX := nY - 110
		for l := 1 to len( aRetf )	
			oPrt:Say(  nX, 510,  aRetf[l][1], oFont10, 300, , , 0 )
			nX+=35
		next
	next
	if nX >= 2800
		oPrt:EndPage()
		oPrt:StartPage()
		nX := 65; nY := 130
	else
		nX += 125
		nY := 130
	endIf

	oPrt:Say(      nX,  nY+40,  "Para evitar-se qualquer san��o fiscal, solicitamos acusarem o recibimento desta, na c�pia que a",   oFont11,  300, , , 0 )
	oPrt:Say(  nX+=50,     nY,  "acompanha, devendo a via de V.Sa.(s) ficar arquivada juntamente com a Nota Fiscal em quest�o.",   oFont11,  300, , , 0 )
	oPrt:Say(  nX+=50,  nY+40,  "Sem outro motivo para o momento, subescrevemo-nos.",   oFont11,  300, , , 0 )
	oPrt:Say(  nX+=80,  nY+40,  "Acusamos o recebimento da 1� VIA                                                        Atenciosamente,",   oFont11,  300, , , 0 )
	oPrt:Line(nX+=120,     nY, nX, 1000,  )
	oPrt:Say(  nX+=15, nY+340,  "(local e data)",   oFont11,  300, , , 0 )
	oPrt:Line(nX+=100, nY, nX, 1000,  )
	oPrt:Line(     nX,   1300, nX, 2170,  )
	oPrt:Say(  nX+=15, nY+260,  "(carimbo e assinatura)",   oFont11,  300, , , 0 )
	oPrt:Say(      nX, nY+1220,  "RAVA EMBALAGENS IND. E COM. LTDA",   oFont11,  300, , , 0 )
	
	oPrt:EndPage()
  	SZ1->( dbGoTo( aItens[a][7] ) )
  	SZ1->( RecLock( "SZ1" , .F.) )
  	SZ1->Z1_IMPRESS := 'S'
  	SZ1->( msUnlock() )
next
oPrt:Preview()

Return

***************

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i	    := 1

cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( alltrim( cTemp ) ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet