#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//--------------------------------
//Programa: MYCTBA102.PRW
//Data    : 17/06/10
//Autoria : Gustavo Costa
//Função  : Transfere lancamento contabil para outra empresa.
//--------------------------------

****************************************************
User function MYCTBA102()
****************************************************

Local _lOk := .T.
Local aItens := {}
Local aCab := {}
Local cPerg	:= "MYCTBA102"
local cQry		:= ''

PRIVATE lMsErroAuto

IF !Pergunte(cPerg, .T.)
	
   Return 
	
ENDIF

iF FWCodEmp() == "02"

	MsgAlert("Rotina não permitida nesta empresa!")
	Return

EndIf


cQry := " SELECT CT2_FILIAL, CT2_LINHA, CT2_MOEDLC, CT2_DC,CT2_DEBITO,CT2_CREDIT,"
cQry += " CT2_VALOR,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC FROM CT2020 " 
cQry += " WHERE D_E_L_E_T_ <> '*' AND CT2_FILIAL = '" + xFilial("CT2") + "'"
cQry += " AND CT2_DATA = '" + DtoS(mv_par01) + "'"
cQry += " AND CT2_LOTE = '" + mv_par02 + "'"
cQry += " AND CT2_SBLOTE = '" + mv_par03 + "'"
cQry += " AND CT2_DOC = '" + mv_par04 + "'"

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

aCab := { {'DDATALANC' ,mv_par01 ,NIL},;
                 {'CLOTE' ,mv_par02 ,NIL},;
                 {'CSUBLOTE' ,mv_par03 ,NIL},;
                 {'CDOC' , mv_par04 ,NIL},;
                 {'CPADRAO' ,'' ,NIL},;
                 {'NTOTINF' ,0 ,NIL},;
                 {'NTOTINFLOT' ,0 ,NIL} }
                 

	
	While !TMP5->(EOF()) 
	             
		aAdd(aItens,{  {'CT2_FILIAL'  	,TMP5->CT2_FILIAL   	, NIL},;
		               {'CT2_LINHA'  	,TMP5->CT2_LINHA   	, NIL},;
		               {'CT2_MOEDLC'  	,TMP5->CT2_MOEDLC   	, NIL},; 
		               {'CT2_DC'   		,TMP5->CT2_DC   		, NIL},;
		               {'CT2_DEBITO'  	,TMP5->CT2_DEBITO 	, NIL},;
		               {'CT2_CREDIT'  	,TMP5->CT2_CREDIT 	, NIL},;
		               {'CT2_VALOR'  	,TMP5->CT2_VALOR  	, NIL},;
		               {'CT2_ORIGEM' 	,'MYCTBA102'		, NIL},;
		               {'CT2_HP'   		,''   				, NIL},;
		               {'CT2_HIST'   	,TMP5->CT2_HIST		, NIL},;
		               {'CT2_CCD'  		,TMP5->CT2_CCD  		, NIL},;
		               {'CT2_CCC'  		,TMP5->CT2_CCC  		, NIL},;
		               {'CT2_ITEMD'  	,TMP5->CT2_ITEMD  	, NIL},;
		               {'CT2_ITEMC'  	,TMP5->CT2_ITEMC  	, NIL} } )
		
		               TMP5->(dbSkip())
	EndDo               
	               
		
		//msgAlert(aItens[1][1] + aItens[1][2] + aItens[1][3] + aItens[1][4] )
		
	MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)
	
	If lMsErroAuto <> Nil 
	 If !lMsErroAuto
	     _lOk := .T.
	     If !IsBlind()
	   MsgInfo('Inclusão com sucesso!')
	     EndIf
	 Else
	     _lOk := .F.
	      If !IsBlind()
	          MsgAlert('Erro na inclusao!')
	      Endif
	 EndIf
	EndIf      
		
Return