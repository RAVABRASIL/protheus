#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
/*
Criar tela de amarração de produção, onde será definido qual máquina irá cortar o PA de uma programação previamente criada.
Além da definição da máquina, também será definida a ordem de corte de cada um dos produtos para a máquina que foi alocado.
Esta ordenação de corte por máquina pode ter a sua ordem alterada, sem problemas. Haveria uma pausa no produto sendo cortado, havendo uma
troca de ordem dentre os outros produtos programados.
Caso haja uma inserção de um produto que não faça parte da programação, a mesma será destruída, dando vez a uma nova programação que irá
aproveitar o saldo de bobina da programação anterior.
*/
*************

User Function PCPC002()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oBtn1","oBtn2")
programa()
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 152,399,727,1194,"",,,.F.,,,,,,.T.,,,.F. )
//DbSelectArea("<Inform Alias>")
oBrw1      := MsSelect():New( "_TMPZ","","",;
			{{"Z02_NUM","","Número",""},{"Z02_DATA","","Data",""},{"Z02_HORA","","Hora",""},{"Z02_DTINI","","Dt. Inicial",""},{"Z02_DTFIM","","Dt. Final",""}},;
			.F.,,{004,004,259,393},,, oDlg1 )
oGrp1      := TGroup():New( 260,004,283,393,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 265,142,"&Alterar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || alterar(_TMPZ->Z02_NUM) }
oBtn2      := TButton():New( 265,206,"&Sair",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || oDlg1:End() }
//oBrw1:oBROWSE:blDblClick := { || oDlg1:End(), alterar(_TMPZ->Z02_NUM) }
oDlg1:Activate(,,,.T.)

Return _TMPZ->( dbCloseArea() )

***************

Static Function programa()

***************
Local cQuery := ""
Private cARQTMP
cQuery += "select	distinct Z02_NUM, Z02_DATA, Z02_HORA, Z02_DTINI, Z02_DTFIM "
cQuery += "from	"+retSqlName('Z02')+" Z02, "+retSqlName('Z03')+" Z03, "+retSqlName('SC2')+" SC2 "
cQuery += "where	Z02.Z02_NUM = Z03.Z03_NUM and Z03.Z03_NUMOP != '' and Z03.Z03_NUMOP = SC2.C2_NUM and year(Z02.Z02_DATA) >= '2008' and "
cQuery += "SC2.C2_QUANT - SC2.C2_QUJE >= 0 and substring(SC2.C2_PRODUTO,1,2) = 'PI' and "
cQuery += "Z02.D_E_L_E_T_ != '*' and Z03.D_E_L_E_T_ != '*' and SC2.D_E_L_E_T_ != '*' and "
cQuery += "Z02.Z02_FILIAL = '"+xFilial('Z02')+"' and Z03.Z03_FILIAL = '"+xFilial('Z03')+"' and SC2.C2_FILIAL = '"+xFilial('SC2')+"' "
cQuery += "order by Z02_NUM "
TCQUERY cQuery NEW ALIAS "_TMPZ"
cARQTMP := CriaTrab( , .F. )
COPY TO ( cARQTMP )
_TMPZ->( DbCloseArea() )
DbUseArea( .T., , cARQTMP, "_TMPZ", .F., .F. )
Index On Z02_NUM + Z02_DATA to &cARQTMP
/* Ferase(cARQTMP+GetDBExtension()) 
   Ferase(cARQTMP+OrdBagExt())	   */
Return

***************

Static Function alterar(cProgr)

*************** 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("_oDlg1","_oBrw1","oGrp1","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
_oDlg1      := MSDialog():New( 144,370,719,1165,"Definição de máquina e ordem para corte",,,.F.,,,,,,.T.,,,.F. )
MHoBrw1()
MCoBrw1(cProgr)
_oBrw1     := MsNewGetDados():New(002,003,257,392,nOpc,'AllwaysTrue()','AllwaysTrue()','',{"Z03_SEQCTE","Z03_MAQ","Z03_KGCORT"},0,99,'U_validQuant()','','AllwaysTrue()',;
			  _oDlg1,aHoBrw1,aCoBrw1 )
oGrp1      := TGroup():New( 260,003,283,392,"",_oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 265,141,"&Gerar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || MsAguarde( { || gerarOp() }, "Aguarde", "Gerando OPs dos produtos secundários e Corte e Solda..." ) }
oBtn2      := TButton():New( 265,265,"&Cancelar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || _oDlg1:End() }
oBtn3      := TButton():New( 265,203,"&Alterar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn3:bAction := { || alteraPrg() }

/*public iCOD    := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_COD"    } )
public iQTESTK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTESTK" } )
public iQTDEST := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDEST" } )
public iQTCARK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTCARK" } )
public iQTDCAR := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDCAR" } )
public iQTDSUG := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDSUG" } )
public iQTSUGM := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTSUGM" } )
public iQTDOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDOP"  } )
public iQTDOPM := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDOPM" } )
public iSOBRA  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_SOBRA"  } )
public iDIAS   := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_DIAS"   } )
public iPESPED := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESPED" } )
public iQTDPED := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDPED" } )
public iQTPRIK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTPRIK" } )
public iQTDPRI := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDPRI" } )
public iPESBOB := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESBOB" } )
public iPESOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESOP"  } )
public iMILHOP := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_MILHOP" } )
public iPESOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESOP"  } )
public iNUMOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_NUMOP"  } )
public iDIAS2  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_DIAS2"  } )
public iVALOR2 := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_VALOR2" } )
public iQTCAR2 := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTCAR2" } )*/

_oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: <INFORM ALIAS>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

/*Local cFCols := "Z03_COD/Z03_QTESTK/Z03_QTDEST/Z03_QTCARK/Z03_QTDCAR/Z03_QTDSUG/Z03_QTSUGM/Z03_QTDOP/Z03_QTDOPM/"+;
"Z03_DIAS/Z03_PESPED/Z03_QTDPED/Z03_VALOR/Z03_QTPRIK/Z03_QTDPRI/Z03_PESBOB/Z03_MILHOP/Z03_PESOP/Z03_SEQCTE/Z03_MAQ/Z03_OPCTE/"*/
Local cFCols := "Z03_COD/Z03_NUMOP/Z03_QTDOP/Z03_SEQCTE/Z03_MAQ/Z03_OPCTE/Z03_KGCORT/"
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z03")
While !Eof() .and. SX3->X3_ARQUIVO == "Z03"
   If cNivel >= SX3->X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ cFCols 
      noBrw1++
      Aadd(aHoBrw1,;
   	  {	TRIM(x3titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO,;
	        X3_DECIMAL      , X3_VALID, X3_USADO  , X3_TIPO	,;
    		X3_F3           , X3_CONTEXT          , X3_CBOX	,;
    		X3_RELACAO      , Trim(X3_INIBRW)} )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: <INFORM ALIAS>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1(cCod)
//ESTPRCT()
Local cQuery := ""
Local aAux := {}
cQuery += "select Z03_COD, Z03_NUM, Z03_QTESTK, Z03_QTDEST, Z03_QTCARK, Z03_QTDCAR, Z03_QTDSUG, Z03_QTSUGM, Z03_QTDOP, Z03_QTDOPM, Z03_KGCORT, Z03_DIAS, Z03_PESPED, Z03_QTDPED, "
cQuery += "Z03_QTPRIK, Z03_QTDPRI, Z03_PESBOB, Z03_PESOP, Z03_MILHOP, Z03_PESOP, Z03_NUMOP, Z03_DIAS2, Z03_VALOR2, Z03_QTCAR2, Z03_SEQCTE, Z03_MAQ, Z03_OPCTE, Z03_VALOR, Z03_QTDOP "
cQuery += "from	"+retSqlName('Z02')+" Z02, "+retSqlName('Z03')+" Z03, "+retSqlName('SC2')+" SC2 "
cQuery += "where Z02.Z02_NUM = Z03.Z03_NUM and Z03.Z03_NUMOP != '' and Z03.Z03_NUMOP = SC2.C2_NUM and year(Z02.Z02_DATA) >= '2009' and "
cQuery += "SC2.C2_QUANT - SC2.C2_QUJE >= 0 and substring(SC2.C2_PRODUTO,1,2) = 'PI' and Z03_NUM = '"+cCod+"' and "
cQuery += "Z02.D_E_L_E_T_ != '*' and Z03.D_E_L_E_T_ != '*' and SC2.D_E_L_E_T_ != '*' and "
cQuery += "Z02.Z02_FILIAL = '"+xFilial("Z02")+"' and Z03.Z03_FILIAL = '"+xFilial("Z03")+"' and SC2.C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += "order by Z02_NUM "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
do While ! _TMPK->( EoF() )
	Aadd(aCoBrw1,Array(noBrw1+1))
	For nI := 1 To noBrw1
		aCoBrw1[len(aCoBrw1)][nI] := CriaVar(aHoBrw1[nI][2])
   		aCoBrw1[len(aCoBrw1)][nI] := &("_TMPK->"+alltrim(aHoBrw1[nI][2]))
	Next
	aCoBrw1[len(aCoBrw1)][noBrw1+1] := .F.
	_TMPK->( dbSkip() )
endDo
_TMPK->(dbCloseArea())
Return

***************

User Function validQuant()

***************

Local nTotal :=  0
SC2->( dbSetOrder(9) )
SC2->( dbSeek( xFilial('SC2') + _oBrw1:aCols[n,4] ) )
if SC2->( EoF() )
	msgAlert("Não há uma OP de PI associada à esse produto, nessa programação.")
	Return .F.
endIf
for _p := 1 to len(_oBrw1:aCols)
	if _oBrw1:aCols[n,4]  == _oBrw1:aCols[_p][4] .and. n != _p//Checa todas linhas da mesma op, menos a atual
		if if( ReadVar() == "M->Z03_SEQCTE",M->Z03_SEQCTE,_oBrw1:aCols[n,5])  == _oBrw1:aCols[_p][5] .and. !empty(_oBrw1:aCols[_p][5])
			if if( ReadVar() == "M->Z03_MAQ",M->Z03_MAQ,_oBrw1:aCols[n,6]) == _oBrw1:aCols[_p][6] .and. !empty(_oBrw1:aCols[_p][6])
				msgAlert("Sequência já atribuída para essa máquina.")
				Return .F.
			endIf
		endIf
	endIf
	nTotal := if( ReadVar() == "M->Z03_KGCORT", M->Z03_KGCORT, 0 )
	aEval(_oBrw1:aCols, { |x| nTotal += if( x[4] == _oBrw1:aCols[n,4], x[8], 0 ) } )
	nTotal -= _oBrw1:aCols[n,8]
	if nTotal > _oBrw1:aCols[n,3]
		msgAlert("A quantidade digitada excede o peso da bobina.")
		msgAlert(transform(nTotal,"@E 999,999.99") + "   " + transform(_oBrw1:aCols[n,3],"@E 999,999.99") )
		Return .F.
	endIf
	nTotal := 0
Next

Return .T.

***************

Static Function gerarOp()

***************
dbSelectArea('Z03')
for _x := 1 to len(_oBrw1:aCols)
	if empty(_oBrw1:aCols[_x][5]) .or. empty(_oBrw1:aCols[_x][6])//ordem e maquina respectivamente
		msgAlert("Por favor, defina todas as ordens e máquinas para corte!")
		return
	endIf
	if !empty(_oBrw1:aCols[_x][7])//ordem de cs
		msgAlert("OPs de corte e solda já definidas!")
		return
	endIf
Next
Begin Transaction
	for _t := 1 to len(_oBrw1:aCols)
		if !Z03->( dbSeek( xFilial('Z03') + _oBrw1:aCols[_t][1] + _oBrw1:aCols[_t][2] ,.F. ) )
			msgAlert("Impossível encontrar a programação "+ _oBrw1:aCols[_t][1] +" do produto"+ _oBrw1:aCols[_t][2] +".")
			return
		endIf
		RecLock("Z03",.F.)
		Z03->Z03_SEQCTE := _oBrw1:aCols[_t][5]
		Z03->Z03_MAQ    := _oBrw1:aCols[_t][6]
		Z03->Z03_KGCORT := _oBrw1:aCols[_t][8]
		aMATRIZ     := {}
		lMsErroAuto := .F.
		aMATRIZ     := {{ "C2_PRODUTO", _oBrw1:aCols[_t][2],	NIL },;
	               	    { "C2_QUANT",   _oBrw1:aCols[_t][8],	NIL },;
	               	    { "C2_PRIOR",   "500",          		NIL },;//Prioridade da OP
	               	    { "C2_DESTINA", "E",            		NIL },;//Destinação: P=Pedido;E=Estoque;C=Consumo
	               	    { "C2_TPOP",    "F",            		NIL },;//Tipo da op: F=Firme;P=Prevista
	               	    { "AUTEXPLODE", "S",            		NIL }}

		MSExecAuto( { |x| MATA650(x) }, aMATRIZ )
		IF lMsErroAuto
			DisarmTransaction()
			MsgBox ( "Erro na geracao da OP do produto " + _oBrw1:aCols[_t][2], "Erro", "STOP" )
			Break
		Endif
		Z03->Z03_OPCTE  := _oBrw1:aCols[_t][7] := SC2->C2_NUM
		Z03->(MsUnlock())
	Next
End Transaction
if !lMsErroAuto
	for _t := 1 to len(_oBrw1:aCols)
		nPos := retRecno()//Retonar o RECNO do PI principal da recém criada ordem de produção de corte e solda e produtos secundários.
		if nPos <= 0
			DisarmTransaction()
			MsgBox ( "Impossível encontrar PI principal, OP: " + SC2->C2_NUM, "Erro", "STOP" )
			Break			
		endIf
		SC2->( dbGoTo( nPos ) )
		RecLock('SC2',.F.)
		SC2->( dbDelete() )
		SC2->( MsUnlock() )
	Next
endIf	
Return

***************

Static Function retRecno()

***************
Local cQuery := cQuery2 := ""
Local nRecno := 0
cQuery += "select C2_PRODUTO from "+retSqlName('SC2')+" where C2_NUM = '"+_oBrw1:aCols[_t][4]+"' and C2_FILIAL = '"+xFilial('SC2')+"' and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS '_TMPE'
_TMPE->( dbGoTop() )
if ! _TMPE->( EoF() )
	cQuery2 += "select R_E_C_N_O_ from "+retSqlName('SC2')+" where C2_PRODUTO = '"+_TMPE->C2_PRODUTO+"' and C2_NUM = '"+_oBrw1:aCols[_t][7]+"' and "
	cQuery2 += "C2_FILIAL = '"+xFilial('SC2')+"' and D_E_L_E_T_ != '*' "
	TCQUERY cQuery2 NEW ALIAS '_TMPF'
	_TMPF->( dbGoTop() )
	if !_TMPF->( EoF() )
		nRecno := _TMPF->R_E_C_N_O_
	endIf
	_TMPF->( dbCloseArea() )
endIf
_TMPE->( dbCloseArea() )

Return nRecno

***************

Static Function alteraPrg()

***************
/*Testar aqui se a OP já produziu alguma coisa*/
Begin Transaction
	if msgYesNo("Deseja realmente apagar a programação de produtos da OP: " + _oBrw1:aCols[oBrw1:oBrowse:nAt][4] )
		for _k := 1 to len(_oBrw1:aCols)
			if _oBrw1:aCols[oBrw1:oBrowse:nAt][4] == _oBrw1:aCols[_k][4]
				if !Z03->( dbSeek(xFilial('Z03') + _oBrw1:aCols[_k][1] + _oBrw1:aCols[_k][2], .F. ) )
					msgAlert("Impossível encontrar ítem "+ _oBrw1:aCols[_k][2] +" da programção selecionada.")
					DisarmTransaction()
					Break
				endIf
				SC2->( dbSetOrder(9) )
				if !SC2->( dbSeek( xFilial('SC2') + _oBrw1:aCols[_k,7] + "01" + _oBrw1:aCols[_k,2], .F. ) ) .and. !empty(_oBrw1:aCols[_k,7])
					msgAlert("Impossível encontrar ordem de produção selecionada!")
					DisarmTransaction()
					Break
				endIf
				if SC2->C2_QUJE > 0 .and. !empty(_oBrw1:aCols[_k,7])
					msgAlert("Impossível reprogramar, pois a OP de corte já foi iniciada.")
					DisarmTransaction()
					Break
				endIf
				if !empty(_oBrw1:aCols[_k,7])
					RecLock("SC2",.F.)
					SC2->( dbDelete() )
					SC2->( msUnlock() )
				endIf
				RecLock("Z03",.F.)
				Z03->( dbDelete() )
				Z03->( msUnlock() )
			endIf
		Next
		Z02->( dbSeek(xFilial('Z02') + _TMPZ->Z02_NUM,.F. ) )
		U_GROP_M( , , 4 )
	endIf
End Transaction
Return