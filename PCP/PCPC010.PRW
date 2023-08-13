#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"


User Function PCPC010 (cCod_,nTipo_,clinha_,nDiaUt_,nDiaTab_,nMetDia_,nProDia_,dtrec_)

public   cSupervisor:=alltrim(substr(cUsuario,7,15))
public   cCodSup :=usu(cSupervisor)
public nTipo    := nTipo_
public cCod     := cCod_
public nDiaUt   := nDiaUt_
public nDiaTab  := nDiaTab_
public nMetDia  := nMetDia_
public nProDia  := nProDia_
public cLinha   := clinha_
public cUsu     := space(6)
public lTrava   :=.T.
public nAPARAP  := 0
public nRPCS    := 0
public nRPUTZ   := 0
public nAPCS    := 0
public nAPEXT   := 0
public nAPUTZ   := 0
public nAPTST   := 0
public nRPCSA   := 0
public nRPUTZA  := 0
public cUsu     := ''
public dDTREC   := dtrec_
public cHRREC   := ''



cQry:=" "
cQry+=" select                                                                " + chr(10)
cQry+=" Z71_COD   COD  ,Z71_APARAP APARAP ,Z71_RPCS  RPCS,                    " + chr(10)
cQry+=" Z71_RPUTZ RPUTZ,Z71_APCS   APCS   ,Z71_APEXT APEXT,                   " + chr(10)
cQry+=" Z71_APUTZ APUTZ,Z71_APTST  APTST  ,Z71_RPCSA PRCSA ,Z71_RPUTZA RPUTZA " + chr(10)
cQry+=" FROM " + RetSqlName( "Z71" ) +" Z71 "                                   + chr(10)
cQry+=" where                                                                 " + chr(10)
cQry+=" Z71_COD=(                                                             " + chr(10)
cQry+="          SELECT Z70_COD FROM "+ RetSqlName( "Z70" ) +" Z70 "            + chr(10)
cQry+="          WHERE Z70_DTREC='"+ dDTREC +"'"                                + chr(10)
cQry+="          and Z70_TIPO='3'                                             " + chr(10)
cQry+="          AND Z70_LINHA='"+cLinha+"'                                   " + chr(10)
cQRY+="          and D_E_L_E_T_=' '"                                            + CHR(10)
cQry+="         )                                                             " + chr(10)
TCQUERY cQry NEW ALIAS "AUX2"


While AUX2->( !EOF() )
	nAPARAP  := AUX2->APARAP
	nRPCS    := AUX2->RPCS
	nRPUTZ   := AUX2->RPUTZ
	nAPCS    := AUX2->APCS
	nAPEXT   := AUX2->APEXT
	nAPUTZ   := AUX2->APUTZ
	nAPTST   := AUX2->APTST
	nRPCSA   := AUX2->PRCSA
	nRPUTZA  := AUX2->RPUTZA
	AUX2->(dbskip())
EndDo
AUX2->(DBCLOSEAREA())


SetPrvt("oDlg2","oGrp1","oDiasUteis","oDiasTrab","oMetaDia","oProdDia","oGDiasUT","oGDiaTrab","oGMetaDia")
SetPrvt("oGrp2","oApara","oRepCS","oRepUTZ","oAparaCS","oAparaEXT","oAparaUTZ","oAparaTXT","oRepCsAT")
SetPrvt("oAparaAT","oGApara","oGRepCS","oGRepUtz","oGAparaCs","oGAparaEXT","oGAparaUtz","oGAparaTxt")
SetPrvt("oGRepUtzAt","oGAparaAT","oOk","oCancela","oGrp3","oGet1")


IF nTipo==1 .and. cLinha == 'C'
	oDlg2      := MSDialog():New( 108,250,401,816,"oDlg2",,,.F.,,,,,,.T.,,,.F. )
else
	oDlg2      := MSDialog():New( 108,250,240,816,"oDlg2",,,.F.,,,,,,.T.,,,.F. )
endif



oGrp1      := TGroup():New( 004,007,042,274,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp3      := TGroup():New( 09,011,038,060,cType,oGrp1,CLR_HBLUE,CLR_WHITE,.T.,.F. )

oLinha      := TGet():New( 018,015,,oGrp3,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLinha",,)
oLinha:bSetGet  := {|u| If(PCount()>0,cLinha:=u,cLinha  )}
oLinha:disable()

oDiasUteis := TSay():New( 012,062,{||"Dias Úteis"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,026,008)
oDiasTrab  := TSay():New( 012,163,{||"Dias Trabalhados"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oMetaDia   := TSay():New( 028,062,{||"Meta Dia"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oProdDia   := TSay():New( 028,163,{||"Produçao Dia"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)

oGDiasUT   := TGet():New( 011,091,,oGrp1,060,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaUT",,)
oGDiasUT:bSetGet  := {|u| If(PCount()>0,nDiaUT:=u,nDiaUT   )}

oGDiaTrab  := TGet():New( 011,207,,oGrp1,060,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaTab",,)
oGDiaTrab:bSetGet := {|u| If(PCount()>0,nDiaTab:=u,nDiaTab )}

oGMetaDia  := TGet():New( 027,091,,oGrp1,060,008,'@E 99,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMetDia",,)
oGMetaDia:bSetGet := {|u| If(PCount()>0,nMetDia:=u,nMetDia )}

oGProdDia  := TGet():New( 027,207,,oGrp1,060,008,'@E 99,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nProDia",,)
oGProdDia:bSetGet := {|u| If(PCount()>0,nProDia:=u,nProDia )}

IF nTipo==1 .and.  cLinha == 'C'
	
	oGrp2      := TGroup():New( 046,007,124,274,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oApara     := TSay():New( 058,011,{||"Apara ( % ) "        },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oRepCS     := TSay():New( 074,011,{||"Reprovação CS"       },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,006)
	oRepUTZ    := TSay():New( 090,011,{||"Reprovação UTZ"      },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oAparaCS   := TSay():New( 058,099,{||"Apara CS"            },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oAparaEXT  := TSay():New( 074,099,{||"Apara Ext"           },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,007)
	oAparaUTZ  := TSay():New( 090,099,{||"Apara UTZ"           },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oAparaTXT  := TSay():New( 108,099,{||"Apara teste"         },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oRepCsAT   := TSay():New( 058,177,{||"Reprovação Cs Atual" },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,008)
	oRepUtzAT  := TSay():New( 074,177,{||"Reprovação UTZ Atual"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,008)
	
	oGApara    := TGet():New( 056,059,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAPARAP",,)
	oGApara:bSetGet := {|u| If(PCount()>0,nAPARAP:=u,nAPARAP)}
	
	oGRepCS    := TGet():New( 074,059,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRPCS",,)
	oGRepCS:bSetGet := {|u| If(PCount()>0,nRPCS:=u,nRPCS)}
	
	oGRepUtz   := TGet():New( 089,059,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRPUTZ",,)
	oGRepUtz:bSetGet := {|u| If(PCount()>0,nRPUTZ:=u,nRPUTZ)}
	
	oGAparaCs  := TGet():New( 056,135,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAPCS",,)
	oGAparaCs:bSetGet := {|u| If(PCount()>0,nAPCS:=u,nAPCS)}
	
	oGAparaEXT := TGet():New( 074,135,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAPEXT",,)
	oGAparaEXT:bSetGet := {|u| If(PCount()>0,nAPEXT:=u,nAPEXT)}
	
	oGAparaUtz := TGet():New( 089,135,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAPUTZ",,)
	oGAparaUtz:bSetGet := {|u| If(PCount()>0,nAPUTZ:=u,nAPUTZ)}
	
	oGAparaTst := TGet():New( 106,135,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAPTST",,)
	oGAparaTst:bSetGet := {|u| If(PCount()>0,nAPTST:=u,nAPTST)}
	
	oGRepCsAT  := TGet():New( 056,235,,oGrp2,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRPCSA",,)
	oGRepCsAT:bSetGet := {|u| If(PCount()>0,nRPCSA:=u,nRPCSA)}
	
	oGRepUtzAt := TGet():New( 074,235,,oGrp2,035,007,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRPUTZA",,)
	oGRepUtzAt:bSetGet := {|u| If(PCount()>0,nRPUTZA:=u,nRPUTZA)}
	
	oOk        := TButton():New( 128,190,"OK",oDlg2,{ ||   Gravar( ),oDlg2:End() },037,012,,,,.T.,,"",,,,.F. )
	oCancela   := TButton():New( 128,236,"Cancela",oDlg2,{|| oDlg2:End()},037,012,,,,.T.,,"",,,,.F. )
ELSE
	oOk        := TButton():New( 46,190,"OK",oDlg2,{ ||   Gravar( ),oDlg2:End() },037,012,,,,.T.,,"",,,,.F. )
	oCancela   := TButton():New( 46,236,"Cancela",oDlg2,{|| oDlg2:End()},037,012,,,,.T.,,"",,,,.F. )
ENDIF
oDlg2:Activate(,,,.T.)

Return


static function Gravar( )
  
dbselectarea("Z70")
dbsetorder(1)
if ! Z70->( dbSeek( xFilial( "Z70" ) + cCOD, .F. ) ) 
   return
endif
cHRREC :=  left(time(),5)
RecLock("Z70",.F.)
Z70->Z70_FILIAL := xFilial("Z70")
Z70->Z70_DIAUT  := nDiaUt
Z70->Z70_DIATAB := nDiaTab
Z70->Z70_METDIA := nMetDia
Z70->Z70_PRODIA := nProDia

Z70->Z70_USUREC := cCodSup
Z70->Z70_HRREC  := cHRREC
Z70->(MsUnlock())

CONFIRMSX8()

IF  nTipo==1 .and.  cLinha == 'C'
dbselectarea("Z71")
dbsetorder(1)
if ! Z70->( dbSeek( xFilial( "Z71" ) + cCOD, .F. ) ) 
   return
endif
	
	RecLock("Z71",.F.)
	Z71->Z71_APARAP := nAPARAP
	Z71->Z71_RPUTZ  := nRPUTZ
	Z71->Z71_APCS   := nAPCS
	Z71->Z71_APEXT  := nAPEXT
	Z71->Z71_APUTZ  := nAPUTZ
	Z71->Z71_APTST  := nAPTST
	Z71->Z71_RPCSA  := nRPCSA
	Z71->Z71_RPUTZA := nRPUTZA
	Z71->(MsUnlock())
	
ENDIF

return




Static Function Usu( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
	aUsuarios  := PSWRET()
	ccod       := Alltrim(aUsuarios[1][1])     	// usuário
Endif

return ccod




Static Function trava(oObj)
if lTrava
	oObj:disable()
else
	oObj:enable()
endif

return




Static Function Ja_existe(nTipo,cLinha)
cQry:=""
cQry+=" select sum(Z70_PRODIA) ACM                                     " + CHR(10)
cQry+=" FROM "+ RetSqlName( "Z70" ) +" Z70                             " + CHR(10)
cQry+=" where Z70_DTREC = '"+dtos(dDatabase)+"')" +CHR(10)
cQry+=" and Z70_TIPO    = '"+alltrim(str(nTipo) ) + "'"                  + CHR(10)
cQry+=" AND Z70_LINHA   =  "+valtoSql(cLinha)                            + CHR(10)
cQRY+=" and D_E_L_E_T_  =  ' '"                                          + CHR(10)
TCQUERY cQry NEW ALIAS "AUX1"

if !AUX1->(EOF())
	lRet:=.T.
else
	lRet:=.F.
endif

AUX1->(DBCLOSEAREA())
return lRet

