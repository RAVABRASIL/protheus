#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function ESTENOP()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cMarca := GetMark()
Private coTbl1
Private LPERDINF := .F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oGrp2","oBtn1","oBtn2","oBtn1","oBtn2","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 143,260,632,1014,"Encerramento de OPs marcadas no acabamento.",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 003,003,199,371,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 200,003,240,371,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 214,140,"Encerrar",oGrp2,{ || endOP() }, 037,012,,,,.T.,,"Encerrar todas as OP's selecionadas",,,,.F. )
oBtn2      := TButton():New( 214,208,"Cancelar",oGrp2,{ || oDlg1:end() },037,012,,,,.T.,,"Cancelar o encerramento",,,,.F. )
oTbl1()
DbSelectArea("TMP")
oBrw1      := MsSelect():New( "TMP","MARCA","",{{"MARCA","","",""},{"C2_OP","","Ordem de Produção",""},;
							{"C2_PRODUTO","","Código",""},{"B1_DESC","","Descrição",""}},.F.,cMarca,{007,009,194,366},,, oGrp1 ) 
oBrw1:bAval := { || TMPMark() }

//oBrw1:bMark := {||TMPMark()}
oBrw1:oBrowse:bAllMark := {||TMPMkAll()}

oBrw1:oBrowse:lHasMark := .T.
oBrw1:oBrowse:lCanAllmark := .T.

oDlg1:Activate(,,,.T.)

Return TMP->( dbCloseArea() )

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()
Local cQuery := ''
Local aFds   := {}

cQuery += "select '  ' MARCA, C2_NUM + C2_ITEM + C2_SEQUEN C2_OP, C2_PRODUTO, B1_DESC "
cQuery += "from  "+retSqlName("SC2")+" SC2 join "+retSqlName("SB1")+" SB1 on C2_PRODUTO = B1_COD "
cQuery += "where  C2_DATRF = '' and C2_FINALIZ != '' and C2_FILIAL = '"+xFilial("SC1")+"' and SC2.D_E_L_E_T_ != '*' and "
cQuery += "SB1.D_E_L_E_T_ != '*' and SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
/*cQuery += "(select count(*) "
cQuery += " from "+retSqlName("Z00")+" Z00 "
cQuery += " where Z00_OP = C2_NUM + C2_ITEM + C2_SEQUEN and Z00_FILIAL = '"+xFilial("Z00")+"' and Z00.D_E_L_E_T_ != '*') > 0 "*/
cQuery += "order by C2_NUM "
TCQUERY cQuery NEW ALIAS "_SC2X"
_SC2X->( dbGoTop() )
/*Aadd( aFds , {"cMark"   ,"C",001,000} )
Aadd( aFds , {"C2_OP"   ,"C",001,000} )
Aadd( aFds , {"B1_COD"  ,"C",001,000} )
Aadd( aFds , {"B1_DESC" ,"C",001,000} )*/

coTbl1 := CriaTrab( , .F. )
COPY TO ( coTbl1 )
Use (coTbl1) Alias TMP New Exclusive
_SC2X->( dbCloseArea() )

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMPMark() - Funcao para marcar o MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMPMark()

Local lDesMarca := TMP->(IsMark("MARCA", cMarca))

RecLock("TMP", .F.)
if lDesmarca
   TMP->MARCA := "  "
else
   TMP->MARCA := cMarca
endif


TMP->(MsUnlock())

return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Encerra() - Funcao para encerrar todas as OPs que foram marcadas
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function Encerra()

Local lMsErroAuto := .F.
Local aMata250 	  := {}
Local aUsuario 	  := {}
Private l250Auto  := .T.
Private lIntQual  := .F.
Private mv_par03  := 2
Private dDataFec  := getMV('MV_ULMES')
Private LDELOPSC  := getMV('MV_DELOPSC') == 'S'
Private LPRODAUT  := getMV('MV_PRODAUT')	
/*aUSUARIO := U_senha2( "03" )
If ! aUSUARIO[ 1 ]	*/
dbSelectArea('SD3')
SD3->( dbSetOrder(1) )
TMP->( dbGoTop() )
do While ! TMP->( EoF() )
	if !empty(TMP->MARCA)
		if ! SD3->( dbSeek( xFilial('SD3') + padr(alltrim(TMP->C2_OP),13) + TMP->C2_PRODUTO, .T. ) )
			msgbox( "Impossível encontrar a OP "+ alltrim(TMP->C2_OP) +"!" )
			msgbox( "ENCERRAMENTO ABORTADO ! ! !" )
			msgbox( "Favor contactar o setor de Informatica! " + alltrim(TMP->C2_OP) )
			Return
		endIf
		A250Encer('SD3', SD3->( recno() ), 5 )
	endIf
	TMP->( dbSkip() )
endDo
TMP->( dbGoTop() )
return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Encerra() - Funcao para encerrar todas as OPs que foram marcadas
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function endOP()
	
	MsAguarde( {|| Encerra(), TMP->( __DBZap() ), TMP->( dbCloseArea() ), oTbl1() },;
			    OemToAnsi( "Aguarde" ), OemToAnsi( "As ordens de produção estão sendo encerradas..." ) )

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ <INFORM ALIAS>MkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMPMkAll()

local nRecno := TMP->(Recno())
TMP->( dbGoTop() )
while ! TMP->(EOF())
   RecLock("TMP",.F.)
   if Empty(TMP->MARCA)
      TMP->MARCA := cMarca
   else
      TMP->MARCA := "  "
   endif
   TMP->(MsUnlock())
   TMP->(DbSkip())
end
TMP->(DbGoto(nRecno))

return .T.