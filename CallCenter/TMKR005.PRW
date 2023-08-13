#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
*************
User Function TMKR005()
*************

Local aIndex    := {}
public cCOD     :=""
public cCODUTI  := Space(6)
public cBILHETe := Space(15)
public cCOMP    := Space(6)
public cFATURA  := Space(7)
public cMATRIC  := Space(6)
public cTRECHO  := Space(50)
public dDTVIAG  := CtoD(" ")
public nNewML   := 0
public nValor   := 0
public nMilhas  := 0

Public cMarca   := GetMark()
Public coTbl1
Public coTbl2
Public cEdi     :=space(6)
Public cMatric  := space(6)
Public cEmpresa := space(6)
Public aFds     := {}
Public nRecno

aRotina :={;
{"&Pesquisar"        ,"AxPesqui"      ,0 , 1},;
{"&Visualizar"       ,"AxVisual"      ,0 , 2},;
{"&Incluir"          ,"AXInclui"      ,0 , 3},;
{"&Editar"           ,"AXAltera"      ,0 , 4},;
{"&Excluir"          ,"U_Del()"   ,0 , 5},;
{"&Cancelar/Liberar" ,"U_Canc()"  ,0 , 5},;
{"&Remarcar"         ,"U_Remarc()"  ,0 , 5},;
{"&Usar Milhas"      ,"U_Mil()"    ,0 , 5};
}
cAlias:="Z62"
cCadastro := OemToAnsi("Cadastro na TABELA "+cAlias)
DbSelectArea(cAlias )
DbSetOrder(1)
mBrowse( 06, 01, 22, 75,cAlias,,,,,,)
Return



 
**********************
user function Mil()
**********************





SetPrvt("oDlg1","oSay1","oGet1","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 207,348,320,561,"Matricula",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 06,004,{||"Matricula"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 06,036,{|u| If(PCount()>0,cMatric:=u,cMatric)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatric",,)
oGet1:cF3:="USR"

oSay2      := TSay():New( 018,004,{||"Empresa"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 018,036,{|u| If(PCount()>0,cEmpresa:=u,cEmpresa)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpresa",,)
oGet2:cF3:="Z7"

oSBtn1     := SButton():New( 036,036,1,{|| oDlg1:end(),milhas()},oDlg1,,"Confirmar", )
oSBtn2     := SButton():New( 036,070,2,{|| oDlg1:end()         },oDlg1,,"Cancelar", )

oDlg1:Activate(,,,.T.)


return




static Function Milhas()



SetPrvt("oDlg1","oGrp2","oSay3","oGrp1","oSay1","oEdita","oBtn1","oBrw1","oBrw2","oSay2")
oDlg1      := MSDialog():New( 132,209,600,1013,"Controle de Viagens",,,.F.,,,,,,.T.,,,.F. )


oGrp2      := TGroup():New( 012,005,230,396,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 020,011,{||"Viagens"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)

oBtn2 := SButton():New( 210.5 ,310,1,,oGrp2,,"&Confirmar", )
oBtn2:bAction := {||Baixa()}
oBtn3 := SButton():New( 210   ,338,2,,oGrp2,,"&Sair", )
oBtn3:bAction := {|| oDlg1:end()}

nRecno   := Z62->(RecNo())
oTbl2()
DbSelectArea("TMP2")
oBrw2 := MsSelect():New( "TMP2","MARCA","",;
{;
{"MARCA"  , "" , "MARCA"     ,"" },;
;// {"CODIGO" , "" , "CODIGO"    ,"" },;
{"NOME"   , "" , "NOME"      ,"" },;
;//{"MATRIC" , "" , "Matricula" ,"" },;
{"MILHAS" , "" , "MILHAS"    ,"" } ;
},.F.,cMarca,{40,10,200,390},, ,oDlg1)

oBrw2:bAval := {||TMP2Mark()}
oBrw2:oBrowse:bAllMark := {||TMP2MkAll()}
oBrw2:oBrowse:lHasMark := .T.
oBrw2:oBrowse:lCanAllmark := .T.
atualiza()
oBrw2:oBrowse:Refresh()

oDlg1:Activate(,,,.T.)

TMP2->(DBCloseArea())
Ferase(coTbl2)
Z62->(dbGoto(nRecno))
Return



/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: TMP2
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl2()

aFds := {}
Aadd( aFds , {"MARCA"  ,"C",002,000} )
Aadd( aFds , {"CODIGO" ,"C",006,000} )
Aadd( aFds , {"NOME"   ,"C",015,000} )
Aadd( aFds , {"MATRIC" ,"C",006,000} )
Aadd( aFds , {"MILHAS" ,"N",010,002} )


coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ EdiPre()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


***************
Static Function atualiza()
***************
Local cQry:=''
dbSelectArea("Z62")
dbSetOrder(1)
TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
Z62->( DBGoTop() )
While  ! Z62->( EOF() )
	if !Empty(Z62->Z62_CODUTI)        .or. ;// ja foi utilizado
		Z62->Z62_MATRIC != cMatric    .or. ;// filtro por usuario
		Z62->Z62_MILHAS == 0          .or. ;// nao ha milhas disponiveis
		Alltrim(Z62->Z62_CANCEL)!= "" .or. ;// viagem cancelada
		Alltrim(Z62->Z62_REMARC)!= "" .or. ;// viagem remarcada
		Z62->Z62_COMP   != cEmpresa      // filtro por companhia aerea
		// nao entram na lista de marcação
		Z62->(dbSkip())
		loop	
	endif
	RecLock("TMP2",.T.)                      
	TMP2->CODIGO:=Z62->Z62_CODIGO
	TMP2->MATRIC:=Z62->Z62_MATRIC 

	TMP2->NOME:=U_Usu_Cod2Nome(Z62->Z62_MATRIC) 
	
	TMP2->MILHAS:= Z62->Z62_MILHAS
	TMP2->(MsUnLock())
	Z62->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TMP2->( DbGotop() )
oBrw2:oBrowse:Refresh()


Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2Mark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2Mark()

Local lDesMarca := TMP2->(IsMark("MARCA", cMarca))

RecLock("TMP2", .F.)
if lDesmarca
	TMP2->MARCA := "  "
else
	TMP2->MARCA := cMarca
endif


TMP2->(MsUnlock())

return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2MkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2MkAll()

local nRecno := TMP2->(Recno())

TMP2->(DbGotop())
while ! TMP2->(EOF())
	RecLock("TMP2",.F.)
	if Empty(TMP2->MARCA)
		TMP2->MARCA := cMarca
	else
		TMP2->MARCA := "  "
	endif
	TMP2->(MsUnlock())
	TMP2->(DbSkip())
end
TMP2->(DbGoto(nRecno))

return .T.

***************
Static Function Baixa()

***************

local nRecno := TMP2->(Recno())

nMilhas:=0

cCod:= GetSx8Num( "Z62", "Z62_CODIGO" )
TMP2->(DbGotop())

while ! TMP2->(EOF())
	
	if !Empty(TMP2->MARCA)
		
		dbSelectArea("Z62")
		dbSetOrder(1)
		dbSeek(xFilial("Z62")+TMP2->CODIGO)
		// RecLock("Z62",.F.)
		// Z62->CODUTI:= cCod
		nMilhas+=   TMP2->MILHAS  //- TMP2->MLUTI
		// Z62->(MsUnlock())
	endif
	TMP2->(DbSkip())
endDo
Cadastrar(cCod,nMilhas,.F.)

TMP2->(DbGoto(nRecno))

Return






static Function Cadastrar(cCod,nMilhas,lLibMilha)


cCODUTI   := Space(6)
cBilhete  := Space(15)
cComp     := cEmpresa // Space(6)
cFatura   := Space(7)
cMatric   := Space(6) // cMatric
cTrecho   := Space(50)
dDtViag   := CtoD(" ")
dDtViag2  := CtoD(" ")
nNewML    := 0
nValor    := 0 
cObs      := Space(100)

/*
ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                           ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
SetPrvt("oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 186,275,727,909,"oDlg2",,,.F.,,,,,,.T.,,,.F. )
oDlg2:bInit := {||EnchoiceBar(oDlg2,{||OkEnch(lLibMilha)},{||Fecha()},.F.,{})}

oSay1      := TSay():New( 029,003,{ || "Bilhete"      } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 041,003,{ || "Matricula"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 052,003,{ || "Trecho"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay4      := TSay():New( 062,003,{ || "Dt.Viagem"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay5      := TSay():New( 017,003,{ || "Codigo"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 073,003,{ || "Milhas"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 083,003,{ || "Cod.Utilizou" } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 017,141,{ || "Nº.Fatura"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay9      := TSay():New( 032,141,{ || "Companhia"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 063,141,{ || "Valor"        } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay11     := TSay():New( 074,141,{ || "ML.Utilizada" } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 094,003,{ || "Dt.Volta"     } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay13     := TSay():New( 105,003,{ || "Observação"   } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)

oGet1      := TGet():New( 016,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCod:=u,cCod)}
oGet1:Disable()

oGet2      := TGet():New( 017,178,,oDlg2,093,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFatura",,)
oGet2:bSetGet := {|u| If(PCount()>0,cFatura:=u,cFatura)}
iif(lLibMilha,cFatura:=Z62->Z62_FATURA, )



oGet3      := TGet():New( 028,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBilhete",,)
oGet3:bSetGet := {|u| If(PCount()>0,cBilhete:=u,cBilhete)}
iif(lLibMilha,cBilhete:=Z62->Z62_BILHET, )


oGet4      := TGet():New( 035,178,,oDlg2,093,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cComp",,)
oGet4:bSetGet := {|u| If(PCount()>0,cComp:=u,cComp)}
iif(lLibMilha,cComp:=Z62->Z62_COMP, )
oGet4:Disable()

oGet5      := TGet():New( 040,035,,oDlg2,040,008,'',,CLR_BLACK,iif(lLibMilha,CLR_HGRAY,CLR_WHITE),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatric",,)
oGet5:bSetGet := {|u| If(PCount()>0,cMatric:=u,cMatric)}
oGet5:bValid:={|| U_invalid(cMatric) }
iif(lLibMilha,cMatric:=Z62->Z62_MATRIC, )
iif(lLibMilha,oGet5:Disable(),)

oGet6      := TGet():New( 051,035,,oDlg2,236,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTrecho",,)
oGet6:bSetGet := {|u| If(PCount()>0,cTrecho:=u,cTrecho)}
iif(lLibMilha,cTrecho:=Z62->Z62_TRECHO, )

oGet7      := TGet():New( 061,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtViag",,)
oGet7:bSetGet := {|u| If(PCount()>0,dDtViag:=u,dDtViag)}
iif(lLibMilha,dDtViag:=Z62->Z62_DTVIAG, )

oGet8      := TGet():New( 062,178,{|u| If(PCount()>0,nValor:=u,nValor)},oDlg2,093,008,'999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValor",,)
iif(lLibMilha,nValor:=Z62->Z62_VALOR, )

oGet9      := TGet():New( 072,035,{|u| If(PCount()>0,nNewML:=u,nNewML)},oDlg2,040,008,'999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nNewML",,)
iif(lLibMilha,nNewML:=Z62->Z62_MILHAS, )


oGet10     := TGet():New( 074,178,,oDlg2,093,008,'999,999.99',,CLR_BLACK, CLR_HGRAY ,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMILHAS",,)
oGet10:bSetGet := {|u| If(PCount()>0,nMILHAS:=u,nMILHAS)}

oGet10:Disable()



oGet11:= TGet():New( 082,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCODUTI" ,,)
oGet11:bSetGet := {|u| If(PCount()>0,cCODUTI:=u,cCODUTI)}
iif(lLibMilha,cCODUTI:=Z62->Z62_CODUTI, )
oGet11:Disable()

oGet12:= TGet():New( 092,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtViag2",,)
oGet12:bSetGet := {|u| If(PCount()>0,dDtViag2:=u,dDtViag2)}
iif(lLibMilha,dDtViag2:=Z62->Z62_DTVOLT, )


oGet13:= TGet():New( 102,035,,oDlg2,236,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObs"    ,,)
oGet13:bSetGet := {|u| If(PCount()>0,cObs:=u,cObs)}
iif(lLibMilha,cObs:=Z62->Z62_OBS, )  

oDlg2:Activate(,,,.T.)


Return


Static Function Fecha()

RollBackSX8()
oDlg2:end()
return

Static Function OkEnch(lLibMilha)
if empty( cCOD     ) .or.;
	empty(cBilhete ) .or.;
	empty(cCOMP    ) .or.;
	empty(cFATURA  ) .or.;
	empty(cMATRIC  ) .or.;
	empty(cTRECHO  ) .or.;
	empty(dDTVIAG  ) .or.;
	empty(dDTVIAG2 )
	
	alert(" Preencha todos o Campos")
	return .F.
endif



if lLibMilha
	RecLock('Z62',.F.)
	Z62->Z62_REMARC := cCod
	Z62->(MsUnlock())
else
	
	
	TMP2->(DbGotop())
	
	while ! TMP2->(EOF())
		
		if !Empty(TMP2->MARCA)
			
			dbSelectArea("Z62")
			dbSetOrder(1)
			dbSeek(xFilial("Z62")+TMP2->CODIGO)
			RecLock("Z62",.F.)
			Z62->Z62_CODUTI:= cCod
			Z62->(MsUnlock())
		endif
		TMP2->(DbSkip())
	endDo
endif

RecLock("Z62",.T.)
Z62->Z62_FILIAL:= xFilial("Z62")
Z62->Z62_CODIGO:= cCod
Z62->Z62_FATURA:= cFatura
Z62->Z62_BILHET:= cBilhete
Z62->Z62_COMP  := cComp
Z62->Z62_MATRIC:= cMatric
Z62->Z62_TRECHO:= cTrecho
Z62->Z62_DTVIAG:= dDtViag
Z62->Z62_DTVOLT:= dDtViag2
Z62->Z62_VALOR := nValor
Z62->Z62_MILHAS:= nNewML
Z62->Z62_MLUTI := nMilhas
Z62->Z62_CODUTI:= ""
Z62->(MsUnlock())
ConfirmSX8()
oDlg2:end()
if !lLibMilha
	oDlg1:end()
endif
return

 

 


user function Canc()
if alltrim(Z62->Z62_REMARC)!=''
	alert('So é possivel Cancelar essa Viagem pelo codigo ( '+alltrim(Z62->Z62_REMARC)+' )')
	return
endif

if alltrim(Z62->Z62_CODUTI)!=''
	alert('Não é mais possivel Cancelar essa viagem ')
	return
endif

RecLock('Z62',.F.)
if alltrim(Z62->Z62_CANCEL) == ''
	Z62->Z62_CANCEL :='*'
	Z62->(MsUnlock())
	alert("Viagem Cancelada")
else
	Z62->Z62_CANCEL :=''
	Z62->(MsUnlock())
	alert("Viagem Liberada")
endif
return



user function Remarc()
nRecno := Z62->(Recno())
if alltrim(Z62->Z62_CANCEL)!=''
	alert('Essa viagem esta cancelada ,nao é possivel remarcar')
	return
endif

if alltrim(Z62->Z62_REMARC)==''
	cCod:= GetSx8Num( "Z62", "Z62_CODIGO" )
	Cadastrar(cCod,Z62->Z62_MLUTI,.T.)
else
	alert('So é possivel remarcar essa Viagem pelo codigo ( '+alltrim(Z62->Z62_REMARC)+' )')
endif

Z62->(DbGoto(nRecno))

return




user function Del ()
//nRecno  := Z62->(Recno())
cDelete := Z62->Z62_REMARC
cCodigoD:= Z62->Z62_CODIGO
if alltrim(Z62->Z62_CANCEL)!='*' 
	alert('Não é possivel deletar essa Viagem pois nao foi Cancelada')
	return
endif  
if alltrim(cDelete)!='' 
	alert('Não é possivel deletar essa Viagem pois esta associada ao codigo ( '+alltrim(Z62->Z62_REMARC)+' )')
	return
endif

RecLock('Z62',.F.)
Z62->(DbDelete())
Z62->(MsUnlock())


dbselectarea("Z62")
DBSETORDER(2)
if DBSEEK(xFilial("Z62")+cCodigoD)
  RecLock('Z62',.F.)
  Z62->Z62_REMARC:=''
  Z62->(MsUnlock())
  dbselectarea("Z62")
  DBSETORDER(1)
 // Z62->(DbGoto(nRecno)) 
endif
return
                    
/*User function USU_cod2Nome(cCod)
PswOrder(1)
	If PswSeek( cCod, .T. )
		aUsuarios  := PSWRET()
		cCod := Alltrim(aUsuarios[1][2])// usuário
	Endif
return cCod
             
 */
