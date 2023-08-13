#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function INAPP06()

Local	_cValid		:= ""
Private _oDesc		:= Nil
Private _oDlg		:= Nil
Private _oDlg2 		:= Nil
Private _oDescEqp	:= Nil
Private _oEquip		:= Nil
Private _oOperac	:= Nil
Private _oTurno		:= Nil
Private _oQtdM2		:= Nil
Private _oOf		:= Nil
Private _oTurno2	:= Nil
Private _oCodigo2	:= Nil
Private _oDtIn3		:= Nil
Private _oHrIn3		:= Nil
Private _oDtFim3	:= Nil
Private _oHrFim3	:= Nil
Private _oLote		:= Nil
Private _cCodigo2	:= SPACE(2)
Private	_cOf		:= SPACE(11)
Private	_cDesc		:= SPACE(30)
Private _cDescEqp	:= SPACE(30)
Private _cOperac	:= SPACE(2)
Private _cEquip		:= SPACE(6)
Private _cTurno		:= SPACE(7)
Private _cTurno2	:= SPACE(7)
Private _cLote		:= SPACE(10)
Private _nTot		:= 0 //Variavel para armazenar o total de perda
Private _cPerda		:= 0
Private _cQtdM2		:= 0
Private _nVolPerd	:= 0
Private nOpc		:= 0
Private nposdesc	:= 0
Private _cDtIn3		:= CTOD("  /  /  ")
Private _cDtFim3	:= CTOD("  /  /  ")
Private _cDtIn		:= CTOD("  /  /  ")
Private _cDtFim		:= CTOD("  /  /  ")
Private _cHrFim3	:= "  :  "
Private _cHrIn3		:= "  :  "
Private _cHrIn		:= "  :  "
Private _cHrFim		:= "  :  "
Private _cProd		:= ""
Private aRotina		:= {{"Incluir", "AxInclui", 0, 1}}
Private _aTurno		:= {" ","Turno 1","Turno 2","Turno 3"}
Private _aVet		:= {}
Private _aDados		:= {}
Private _lPar		:= .F.
Private lMsErroAuto := .F.
Private _lLote		:= .F.
Private	_oDlgP		:= Nil
Private _nEtq		:= 0

DEFINE MSDIALOG _oDlgIn TITLE "HORAS IMPRODUTIVAS" FROM 000,000 TO 540,800	PIXEL OF _oDlg


MsgRun("Aguarde... Inicializando Ambiente...",,{ || WfPrepEnv("01","01",,{'SBC','SB1','CTT','SC2','SD3','SD4','SB1','SH6'},'PCP')})

DEFINE FONT _oFont		NAME "Arial" Size 20,30 BOLD
DEFINE FONT _oFont2  	NAME "Arial" Size 11,19 BOLD
DEFINE FONT _oFoList  	NAME "Arial" Size 07,15

DEFINE MSDIALOG _oDlg TITLE "HORAS IMPRODUTIVAS" FROM 000,000 TO 540,800	PIXEL OF _oDlg

@ 008,095 SAY "HORAS IMPRODUTIVAS" FONT _oFont COLOR CLR_BLUE SIZE 300,030 PIXEL OF _oDlg
@ 030,005 TO 250,800 PIXEL OF _oDlg

@ 255,005 Button "INCLUIR" 	    Size 55,15 PIXEL OF _oDlg ACTION Parada()		FONT _oFont2
@ 255,080 Button "VISUALIZAR"   Size 55,15 PIXEL OF _oDlg ACTION ShowApnt()		FONT _oFont2
@ 255,160 Button "SAIR"	     	Size 55,15 PIXEL OF _oDlg ACTION _oDlg:End()    FONT _oFont2

ACTIVATE MSDIALOG _oDlg CENTER

//RPCClearEnv()

Return


User Function VldPrd()

Local _lRet 	:= .T.
Local _cCorpo	:= ""
Local _cCodOri	:= ""
Local _cDescOri	:= ""


Return _lRet


User Function VldPerda()

Local _lRet := .T.


Return _lRet


User Function VldQtd()

Local _lRet := .T.


Return _lRet


User Function VldLote()

Local _lRet  := .T.


Return _lRet


Static Function ValOp()

Local _lRet := .T.
Local _cQry := ""

Return _lRet

Static Function _ValLote()

Local _lRet := .T.

Return _lRet

Static Function ValOperac()

Local _lRet := .T.

Return _lRet


Static Function ValHr(_nY,_cHoraI,_cHoraF,_cDataI,_cDataF)

Local _lRet := .F.

If _nY == 1
	If VAL(Substr(_cHoraI,1,2)) > 23 .OR. VAL(SubStr(_cHoraI,4,2)) > 59 .OR. LEN(AllTrim(_cHoraI)) < 5
		MsgStop("Favor digitar uma hora Valida!")
	Else
		_lRet := .T.
	EndIf
Else
	If VAL(Substr(_cHoraF,1,2)) > 23 .OR. VAL(SubStr(_cHoraF,4,2)) > 59 .OR. LEN(AllTrim(_cHoraF)) < 5
		MsgStop("Favor digitar uma hora Valida!")
	Else
		If _cDataF == _cDataI .AND. _cHoraF <= _cHoraI
			MsgStop("Digite uma Hora maior que a Hora de Início!")
		Else
			_lRet := .T.
		EndIf
	EndIf
EndIf

Return _lRet


Static Function ValDat(_nX,_cDataIn,_cDataFim)

Local _lRet := .F.
Local _nDia	:= 0

IIF(DOW(dDataBase-1)==1,_nDia:=3,_nDia:=1)

If _nX == 1
	If _cDataIn > dDataBase
		MsgStop("Não pode ser digitado data maior que " + DTOC(dDataBase))
	Else
		_lRet := .T.
	EndIf
Else
	If _cDataFim < _cDataIn
		MsgStop("A data de Término não pode ser menor que a data de Início!")
	Else
		_lRet := .T.
	EndIf
EndIf

Return _lRet


Static Function Telas()

Return

Static Function GeraApont()

Local _aMata681 	:= {}
Local _aDados		:= {}
Local cQuery 		:= ""
Local _cDatT		:= SubStr(_cTurno,Len(_cTurno),1)
Local _dData		:= ""
Local _cLote		:= ""
Local _nZ			:= 0

_nVolPerd := _nVolPerd - _nTot

If _nVolPerd <= 0
	MsgStop("Quantidade de perda incorreto")
	Return
EndIf

If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	If SB1->B1_RASTRO == "L" .OR. SB1->B1_RASTRO == "S"
		If SB1->B1_TIPO == "PI"
			_cLote := SubStr(_cOf,1,6) + _nEtq
		Else
			_cLote := SubStr(_cOf,1,6)
		EndIf
		_dData := dDataBase + SB1->B1_PRVALID
	Else
		_dData := CTOD("  /  /  ")
		_cLote := " "
	EndIf
EndIf

If !u_INVALOP(_cOf,_nVolPerd,GetMV("IN_PERCMOL"),_cOperac)
	Return
EndIf

_aMata681 := {	{"H6_OP" 		,_cOf 				,NIL},; //01-Ordem de producao
				{"H6_PRODUTO"	,_cProd				,NIL},; //02-Produto
				{"H6_OPERAC" 	,_cOperac			,NIL},; //03-operacao
				{"H6_RECURSO"	,_cEquip			,NIL},; //04-Recurso utilizado
				{"H6_DTAPONT"	,dDatabase			,NIL},; //05-Data do apontamento
				{"H6_DATAINI"	,_cDtIn				,NIL},; //06-Data inicial da producao
 				{"H6_HORAINI"	,_cHrIn 			,NIL},; //07-Hora inicial da producao
				{"H6_DATAFIN"	,_cDtFim 			,NIL},; //08-Data final da producao
				{"H6_HORAFIN"	,_cHrFim 			,NIL},; //09-Hora final da producao
				{"H6_QTDPROD"	,_nVolPerd			,NIL},; //10-Quantidade produzida
				{"H6_TURNO"		,_cDatT				,NIL},; //11-Turno
				{"H6_LOCAL"		,SC2->C2_LOCAL		,NIL},; //12-Local para producao
				{"H6_DTPROD"	,dDataBase    		,NIL},; //13-Data da producao
				{"H6_LOTECTL"	,_cLote				,NIL},; //14-Lote da producao
				{"H6_DTVALID" 	,_dData 			,NIL},; //15-Data do lote
				{"H6_XETIQ"		,VAL(_nEtq)			,NIL} } //16-Sequencial da etiqueta

lMsErroAuto := .F.
MsExecAuto({|x,Y| Mata681(x,Y)},_aMata681,3)

If lMsErroAuto
	MOSTRAERRO()
Else
	If SB1->B1_TIPO == 'PI' .AND. SB1->B1_LOCALIZ == 'S'
		MsgRun("Aguarde...   Endereçando Produto...",,{ || u_INENDEREC(_cProd,SC2->C2_LOCAL,_cLote,_nVolPerd)	})
		
		AADD(_aDados,{	SM0->M0_CODFIL	,; //01-FILIAL
						_cProd			,; //02-PRODUTO
						_nVolPerd		,; //03-QUANTIDADE
						0	 			,; //04-COMPRIMENTO
						0				,; //05-LARGURA
						0				,; //06-PESO
						0				,; //07-GRAMATURA
						_cOf			,; //08-OF
						_cLote			,; //09-LOTE
						' '				,; //10-NOTA FISCAL
						' '				,; //11-SERIE
						' '				,; //12-FORNECEDOR
						' '				,; //13-LOJA
						.F.				}) //14 REIMPRESSAO
		
		MsgRun("Aguarde...   Gerando Etiqueta..."   ,,{ || u_INRETQ(_aDados,,'1',,'4') })
	EndIf
	MsgInfo("Apontamento gerado com Sucesso!")
	LimpaTela()
EndIf

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDesc.     ³ - Tela para Apontamento de Paradas                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Parada()

Local 	_cQry	   := ""
Local 	_cNomCampo := ""
Local 	_nY		   := 0
Local 	_aCampos4  := {"H6_MOTIVO","H6_DATAINI","H6_HORAINI","H6_DATAFIN","H6_HORAFIN","H6_RECURSO","H6_CBFLAG","H6_OPERADO","H6_DESCRI","H1_DESCRI"}
Local 	_oGetDad4  := Nil
Local 	_aListBox  := {}
Local 	_aHeader2  := {}
Local 	_aCols2	   := {}
Private _aAux4	   := {}
Private aGets

dbSelectArea("SX3")
SX3->(dbSetOrder(2))
For _nY:=1 To Len(_aCampos4)
	If SX3->(dbSeek(_aCampos4[_nY]))
		If _aCampos4[_nY] == 'H6_RECURSO'
			_cNomCampo := "Maquina"
		ElseIf _aCampos4[_nY] == 'H6_DATAINI'
			_cNomCampo := "Data Inicial"
		ElseIf _aCampos4[_nY] == 'H6_DATAFIN'
			_cNomCampo := "Data Final"
		Else
			_cNomCampo := TRIM(X3Titulo())
		EndIf
		
		AADD(_aHeader2,{ _cNomCampo		,;
						SX3->X3_CAMPO	,;
						SX3->X3_PICTURE	,;
						SX3->X3_TAMANHO	,;
						SX3->X3_DECIMAL	,;
					 	IIF(_aCampos4[_nY] == 'H6_RECURSO' .OR. _aCampos4[_nY] == 'H6_MOTIVO',SX3->X3_VALID,' '),;
						SX3->X3_USADO	,;
						SX3->X3_TIPO	,;
						SX3->X3_F3 		})
	EndIf
Next _nY

_aAux4 := {}
For i := 1 To Len(_aCampos4)
	If SX3->(DbSeek(_aCampos4[i]))
		AADD(_aAux4,CriaVar(SX3->X3_CAMPO))
	EndIf
Next

AADD(_aAux4,.F.)
AADD(_aCols2,_aAux4)

DEFINE MSDIALOG _oDlg2 TITLE "Paradas" FROM 000,000 TO 540,800 PIXEL OF _oDlg2 //FONT _oFont2

@ 008,120 SAY "Paradas" FONT _oFont COLOR CLR_BLUE SIZE 300,030 PIXEL OF _oDlg2

_oGetDad4 := MsNewGetDados():New(030,012,250,400,GD_UPDATE+GD_INSERT+GD_DELETE,,,,_aCampos4,,,,,,_oDlg2,_aHeader2,_aCols2)

@ 255,012 Button "GRAVAR" 	Size 50,15 PIXEL OF _oDlg2 ACTION MsgRun("Aguarde...   Gerando Apontamento...",,{|| GeraParada(_oGetDad4) }) FONT _oFont2
@ 255,241 Button "SAIR" 	Size 50,15 PIXEL OF _oDlg2 ACTION _oDlg2:End() FONT _oFont2

ACTIVATE MSDIALOG _oDlg2 CENTER

_oGetDad4 	:= Nil
_aAux4 		:= {}

Return

Static Function GeraParada(_oGetDad4)

Local _aVetor	:= {}
Local _nX		:= 0
Local _aArea	:= SC2->(GetArea())

For _nX := 1 To Len(_oGetDad4:aCols)
	
		_aVetor	:= {	{"H6_MOTIVO"	,_oGetDad4:aCols[_nX,1]	,NIL},; //01-Motivo da parada
						{"H6_DTAPONT" 	,dDataBase				,NIL},; //02-Data do apontamento
						{"H6_DATAINI"	,_oGetDad4:aCols[_nX,2]	,NIL},; //03-Data inicial da parada
						{"H6_HORAINI" 	,_oGetDad4:aCols[_nX,3]	,NIL},; //04-Hora inicial da parada
						{"H6_DATAFIN" 	,_oGetDad4:aCols[_nX,4]	,NIL},; //05-Data final da parada
						{"H6_HORAFIN"	,_oGetDad4:aCols[_nX,5]	,NIL},; //06-Hora final da parada
						{"H6_RECURSO"	,_oGetDad4:aCols[_nX,6]	,NIL},; //07-Recurso
						{"H6_TURNO"		,_oGetDad4:aCols[_nX,7]	,NIL} } //08-Turno da parada
		
		lMsErroAuto := .F.
		MsExecAuto({|x,y| MATA682(x,y)},_aVetor,3)
		
		If lMsErroAuto
			MOSTRAERRO()
		Endif
Next _nX

RestArea(_aArea)

_oDlg2:End()

Return


Static Function GeraPerda()

Local aCabRef 		:= {}
Local aItensRef		:= {}
Local aAux	 		:= {}
Local _aGera		:= {}
Local _aTest		:= {}
Local _aAreaB1		:= SB1->(GetArea())
Local _cLocaliz		:= ""
Local _cLocal		:= ""
Local _cCod			:= ""
Local _nZ			:= 0
Local _nTotAux		:= 0
Local _lGera		:= .F.                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Concistencia nas linhas de itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _nZ:=1 To Len(_oGetDad:aCols)
	If !_oGetDad:aCols[_nZ,6]
		If !Empty(_oGetDad:aCols[_nZ,5])
			AADD(_aGera,_nZ)
			_oDLgP:end()
		ElseIf !Empty(_oGetDad:aCols[_nZ,2]) .AND. Empty(_oGetDad:aCols[_nZ,5])
			_lGera := .T.
			Exit
		EndIf
	EndIf
Next _nZ

If _lGera
	MsgStop("Erro na linha de perda!")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Quantidade apontada para descontar da quantidade total³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aGera) > 0
	_aTest := _oGetDad:aCols
	aSort(_aTest,,,{|x,y| x[2] == y[2]})
	
	_cCod := _aTest[1,2]
	For _nZ:=1 To Len(_aTest)
		If !_aTest[_nZ,6]
			If _aTest[_nZ,2] == _cCod
				_nTot += _aTest[_nZ,4]
			Else
				_cCod := _aTest[_nZ,2]
				If _nTot > _nTotAux
					_nTotAux := _nTot
				EndIf
				_nTot := _aTest[_nZ,4]
			EndIf
		EndIf
	Next _nZ
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ExecAuto da Geração de apontamento de perda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
SB1->(dbSetOrder(1))

aCabRef := {	{'BC_OP'		,_cOf		,NIL},; //01-Numero da op+item+sequencia
				{'BC_OPERAC'	,_cOperac	,NIL},; //02-Codigo da operacao
				{'BC_RECURSO'	,_cEquip	,NIL} } //03-Recurso

For _nZ:=1 To Len(_aGera)
	
	_cLocaliz := ' '
	SB1->(dbSeek(xFilial("SB1")+_oGetDad:aCols[_aGera[_nZ],2]))
	If SB1->B1_LOCALIZ == 'S'
		_cLocaliz := "PROCESSO"
	EndIf
	
	dbSelectArea("SD4")	
	SD4->(dbsetOrder(2))
	If SD4->(dbSeek(xFilial("SD4")+PADR(_cOf,13)+_oGetDad:aCols[_aGera[_nZ],2]))
		_cLocal := SD4->D4_LOCAL
	Else
		_cLocal := '99'
	EndIf
	
	aAux	:= {	{'BC_PRODUTO',_oGetDad:aCols[_aGera[_nZ],2]				,NIL},; //01-Produto origem
					{'BC_LOCORIG',_cLocal									,NIL},; //02-Local origem
					{'BC_TIPO'   ,_oGetDad:aCols[_aGera[_nZ],1]				,NIL},; //03-Tipo da perda R-Refugo ou S-Scrap
					{'BC_MOTIVO' ,_oGetDad:aCols[_aGera[_nZ],3]				,NIL},; //04-Motivo da perda
					{'BC_QUANT'  ,_oGetDad:aCols[_aGera[_nZ],4]				,NIL},; //05-Quantidade perdida
					{'BC_CODDEST',_oGetDad:aCols[_aGera[_nZ],2]				,NIL},; //06-Codigo do produto destino
					{'BC_LOCAL'	 ,GetMv("IN_OFMOLD2")						,NIL},; //07-Local destino
					{'BC_QTDDEST',_oGetDad:aCols[_aGera[_nZ],4]				,NIL},; //08-Quantidade destino
					{'BC_DATA'   ,dDataBase									,NIL},; //09-Data da perda
					{'BC_LOTECTL',_oGetDad:aCols[_aGera[_nZ],5]				,NIL},; //10-Lote a ser refugado
					{'BC_LOCALIZ',_cLocaliz									,NIL},; //11-Endereco origem
					{'BC_LOCDEST',_cLocaliz									,NIL} } //12-Endereco destino

	AADD(aItensRef,aAux)
Next

lMsErroAuto := .F.
MsExecAuto( {|x,y,z| MATA685(x,y,z) }, aCabRef, aItensRef, 3)

If lMsErroAuto
	MostraErro()
EndIf

RestArea(_aAreaB1)

Return


Static Function LimpaTela()

_cDesc		:= SPACE(30)
_cOperac    := SPACE(2)
_cEquip		:= SPACE(6)
_cOf		:= SPACE(11)
_cLote		:= SPACE(9)
_cTurno		:= " "
_nVolPerd	:= 0
_cQtdM2		:= 0
_cPerda		:= 0
_cDtIn		:= CTOD("  /  /  ")
_cHrIn		:= "  :  "
_cDtFim		:= CTOD("  /  /  ")
_cHrFim		:= "  :  "
_nTot		:= 0

_oDesc:cCaption 	:= _cDesc
_oDesc:Refresh()
_oOperac:cCaption 	:= _cOperac
_oOperac:Refresh()
_oEquip:cCaption	:= _cEquip
_oEquip:Refresh()
_oOf:cCaption 		:= _cOf
_oOf:Refresh()
_oTurno:cCaption	:= _cTurno
_oTurno:Refresh()
_oDlg:Refresh()
_oOf:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ Visualizar os lançamentos de hrs improdutiva.               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ShowApnt()

DbSelectArea("SH6" )
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "SH6",,,,,,,)   


Return()                  


Static Function UpdOp()

Local _cQry 	:= ""

_aLista := {}

// Query
_cQry := " SELECT														" + CRLF				
_cQry += " 		SH6.H6_OP		,	          				            " + CRLF
_cQry += " 		SH6.H6_PRODUTO	,                   				   	" + CRLF
_cQry += " 		SH6.H6_OPERAC	,           			            	" + CRLF
_cQry += " 		SG2.G2_DESCRI	,                   			      	" + CRLF
_cQry += " 		SH6.H6_RECURSO	,                			        	" + CRLF
_cQry += " 		SUM(SH6.H6_QTDPROD) AS H6_QTDPROD			        	" + CRLF
_cQry += " FROM                                 			           	" + CRLF
_cQry += +		RetSqlName("SH6") +	" AS SH6	,			      		" + CRLF
_cQry += +		RetSqlName("SG2") +	" AS SG2	,			          	" + CRLF
_cQry += +		RetSqlName("SC2") +	" AS SC2							" + CRLF
_cQry += " WHERE                                			          	" + CRLF
_cQry += " 		SH6.H6_OP 		= '"+_cOf+"'			              	" + CRLF
_cQry += " AND	SH6.H6_FILIAL	= '"+xFilial("SH6")+"'    				" + CRLF
_cQry += " AND	SH6.D_E_L_E_T_ 	= ' '               			     	" + CRLF
_cQry += " AND	SH6.H6_PRODUTO 	= SG2.G2_PRODUTO			          	" + CRLF
_cQry += " AND	SH6.H6_OPERAC 	= SG2.G2_OPERAC				          	" + CRLF
_cQry += " AND	SH6.H6_FILIAL 	= SG2.G2_FILIAL				           	" + CRLF
_cQry += " AND	SG2.D_E_L_E_T_ 	= ' '                  					" + CRLF
_cQry += " AND	SC2.D_E_L_E_T_ 	= ' '                                 	" + CRLF
_cQry += " AND	SH6.H6_OP		= SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN	" + CRLF
_cQry += " AND	SG2.G2_CODIGO	= SC2.C2_ROTEIRO						" + CRLF
_cQry += " GROUP BY             			                          	" + CRLF
_cQry += " 		H6_OP			,           			               	" + CRLF
_cQry += " 		H6_PRODUTO		, 				                      	" + CRLF
_cQry += " 		H6_OPERAC		,               			        	" + CRLF
_cQry += " 		SG2.G2_DESCRI	,         			                	" + CRLF
_cQry += " 		H6_RECURSO                      			         	" + CRLF
_cQry += " ORDER BY                                     			 	" + CRLF
_cQry += " 		H6_OP		,	   			                        	" + CRLF
_cQry += " 		H6_PRODUTO	,               			               	" + CRLF
_cQry += " 		H6_OPERAC                               			   	" + CRLF

// Fecha arquivo temp. caso esteja aberto
If Select("TMP1") > 0
	dbSelectArea("TMP1")
	TMP1->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TMP1",.F.,.T.)
dbSelectArea("TMP1")	
TMP1->(dbGoTop())

// Adiciona dados no array para posterior visualizacao em listbox
While TMP1->(!EoF())
	AADD(_aLista, {		TMP1->H6_OP			,;
						TMP1->H6_PRODUTO	,;
						TMP1->H6_OPERAC		,;
						TMP1->G2_DESCRI		,;	
						TMP1->H6_RECURSO	,;
						Transform(TMP1->H6_QTDPROD, "@E 999,999.99")	;
					})

	TMP1->(dbSkip())

EndDo

// Mostra dados
If Len(_aLista) > 0
	_oLbx:SetArray(_aLista)
	_oLbx:bLine := {|| {	_aLista[_oLbx:nAt,1]			,;	// Op
							_aLista[_oLbx:nAt,2]			,;	// PA
							_aLista[_oLbx:nAt,3]			,;	// Nro. Operacao
							_aLista[_oLbx:nAt,4]			,;	// Descricao da Operacao
							_aLista[_oLbx:nAt,5]			,;	// Maquina ou Recurso
							_aLista[_oLbx:nAt,6]			}}	// Qtdade Produzida
	_oLbx:Refresh()
	_oDlgOf:Refresh()
Else
	MsgAlert("Não Existem apontamentos para a OF informada!")	
EndIf            

Return()

Static Function Perda()

Local 	_aCampos	:= {"BC_TIPO","BC_PRODUTO","BC_MOTIVO","BC_QUANT","BC_LOTECTL"}
Local 	_aHeaderP	:= {}
Local 	_aColsP		:= {}
Local 	_aAuxPer	:= {}
Local 	_cValid		:= ""
Local 	_nY			:= 0
Private _oGetDad	:= Nil

If Empty(_cOf)
	MsgAlert("Ordem de Fabricação não informada!")	
	Return
EndIf

dbSelectArea("SX3")
SX3->(dbSetOrder(2))

For _nY:=1 To Len(_aCampos)
	If SX3->(dbSeek(_aCampos[_nY]))
		
		If _aCampos[_nY] $ "BC_TIPO"
			_cValid := SX3->X3_VALID
		ElseIf _aCampos[_nY] == "BC_PRODUTO"
			_cValid := 'u_VldPrd()'
		ElseIf _aCampos[_nY] == "BC_QUANT"
			_cValid	:= 'u_VldQtd()'
		ElseIf _aCampos[_nY] == "BC_LOTECTL"
			_cValid := 'u_VldLote()'
		ElseIf _aCampos[_nY] == "BC_MOTIVO"
			_cValid := 'u_VldPerda()'
		Else
			_cValid := ' '
		EndIf
		
		AADD(_aHeaderP,{ 	TRIM(X3Titulo())	,;
							SX3->X3_CAMPO		,;
							SX3->X3_PICTURE		,;
							SX3->X3_TAMANHO		,;
							SX3->X3_DECIMAL		,;
					 		_cValid				,;
							SX3->X3_USADO		,;
							SX3->X3_TIPO		,;
							SX3->X3_F3 			})
	EndIf
Next _nY

_aAuxPer := {}
For _nY := 1 To Len(_aCampos)
	If SX3->(DbSeek(_aCampos[_nY]))
		AADD(_aAuxPer,CriaVar(SX3->X3_CAMPO))
	EndIf
Next

AADD(_aAuxPer,.F.)
Aadd(_aColsP,_aAuxPer)

DEFINE MSDIALOG _oDlgP TITLE "Perdas" FROM 000,000 TO 540,600 PIXEL OF _oDlgP

@ 008,120 SAY "Perdas" FONT _oFont COLOR CLR_BLUE SIZE 300,030 PIXEL OF _oDlgP

_oGetDad := MsNewGetDados():New(030,012,250,290,GD_INSERT+GD_DELETE+GD_UPDATE,,,,_aCampos,,,,,,_oDlgP,_aHeaderP,_aColsP)

@ 255,012 Button "GRAVAR" 	Size 50,15 PIXEL OF _oDlgP ACTION MsgRun("Aguarde...   Gerando Apontamento...",,{|| GeraPerda()}) FONT _oFont2
@ 255,241 Button "SAIR" 	Size 50,15 PIXEL OF _oDlgP ACTION _oDlgP:End() FONT _oFont2

ACTIVATE MSDIALOG _oDlgP CENTER

Return 

