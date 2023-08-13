#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FATC031   ³ Autor :Eurivan Marques       ³ Data :24/08/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Controle de Ligações para Clientes Inativos e Inativando   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       : Comercial Rava Embalagens                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
***********************
User Function FATC031()
***********************
local lInit := .T.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1
Private aExPla:={}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgII","oBrw1","oBtnDet","oBtnS1")

oPerg1()
if !Pergunte('FATC31',.T.)
   Return
endif   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgII     := MSDialog():New( 169,252,769,1327,"Clientes",,,.F.,,,,,,.T.,,,.F. )
oTbl1()
DbSelectArea("CII")
oBrw1      := MsSelect():New( "CII","","",{{"CLIENTE","","Cliente"       ,""},;
                                           {"LOJA"   ,"","Loja"          ,""},;
                                           {"NOME"   ,"","Nome"          ,""},;
                                           {"UF"     ,"","UF"            ,""},;
                                           {"COORD"  ,"","Coordenador"   ,""},;
                                           {"REPRES" ,"","Representante" ,""},;
                                           {"DIAS"   ,"","Dias s/comprar",""},;
                                           {"DTULIG" ,"","Dt.Últ.Lig."   ,""},;
                                           {"HRULIG" ,"","Hr.Ult.Lig."   ,""}},.F.,,{012,008,280,468},,, oDlgII ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK

/**/
oBrw1:oBrowse:bHeaderClick := {|oBrw,nCol| MbrIdxCol(nCol,oBrw)}

if lInit
	MbrIdxCol(1,oBrw1:oBrowse)
	lInit := .F.
endIf
/**/

oBtnDet   := TButton():New( 012,474,"Detalhes...",oDlgII,,049,013,,,,.T.,,"",,,,.F. )
oBtnDet:bAction := {||xFatc31()}
/*
oBtnS1    := TButton():New( 036,474,"Sair",oDlgII,,049,013,,,,.T.,,"",,,,.F. )
oBtnS1:bAction := {||oDlgII:End()}
*/
oBtnS1    := TButton():New( 036,474,"Excel",oDlgII,,049,013,,,,.T.,,"",,,,.F. )
oBtnS1:bAction := {||fExcel()}



oDlgII:Activate(,,,.T.)

CII->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: CII
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds   := {}
Local cQuery
Local aULig  := {}

Aadd( aFds, {"CLIENTE" ,"C",006,000} )
Aadd( aFds, {"LOJA"    ,"C",002,000} )
Aadd( aFds, {"NOME"    ,"C",040,000} )
Aadd( aFds, {"UF"      ,"C",002,000} )
Aadd( aFds, {"COORD"   ,"C",006,000} )
Aadd( aFds, {"REPRES"  ,"C",006,000} )
Aadd( aFds, {"DIAS"    ,"N",005,000} )
Aadd( aFds, {"DTULIG"  ,"D",008,000} )
Aadd( aFds, {"HRULIG"  ,"C",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias CII New Exclusive

cQuery := "SELECT "
cQuery += "   CLIENTE, LOJA, NOME, TEL, UF, COORD, REPRES, DIAS=AVG(DIAS) "
cQuery += "FROM "
cQuery += "   CLIENTES_STATUS "
cQuery += "WHERE "

if !Empty(MV_PAR01)
   cQuery += "CLIENTE = '"+MV_PAR01+"' AND "
endif
if !Empty(MV_PAR02)
   cQuery += "LOJA = '"+MV_PAR02+"' AND "   
endif
if !Empty(MV_PAR03)
   cQuery += "UF = '"+MV_PAR03+"' AND "   
endif
if !Empty(MV_PAR04)
   cQuery += "COORD = '"+MV_PAR04+"' AND "   
endif

if !Empty(MV_PAR05)
   cQuery += "REPRES = '"+MV_PAR05+"' AND "   
endif
   
if MV_PAR06 == 1 //Ativo
   cQuery += "STATUS = 'ATIVO' AND "   
elseif MV_PAR06 == 2 //InAtivo
   cQuery += "STATUS = 'INATIVO' AND "   
elseif MV_PAR06 == 3 //Inativando
   cQuery += "STATUS = 'INATIVANDO' AND "   
endif

cQuery += "   ATIVO = 'S' "
cQuery += "GROUP BY "
cQuery += "   CLIENTE, LOJA, NOME, TEL, UF, COORD, REPRES "
cQuery += "ORDER BY COORD, UF, DIAS DESC"

TCQUERY cQuery NEW ALIAS "CLS"

while !CLS->(EOF())
   aULig := fUltLig(CLS->CLIENTE, CLS->LOJA)
   RecLock("CII",.T.)
   CII->CLIENTE := CLS->CLIENTE
   CII->LOJA    := CLS->LOJA
   CII->NOME    := CLS->NOME
   CII->UF      := CLS->UF
   CII->COORD   := CLS->COORD
   CII->REPRES  := CLS->REPRES  
   CII->DIAS    := CLS->DIAS  
   CII->DTULIG  := STOD(aULig[1])
   CII->HRULIG  := aULig[2]
   // EXCEL 
   AADD(aExPla,{CII->CLIENTE,CII->LOJA,CII->NOME,CII->UF,CII->COORD,CII->REPRES,CII->DIAS,CII->DTULIG,CII->HRULIG })
   
   CII->(MsUnLock())
   CLS->(DbSkip())
end

if Select("CLS") > 0
	DbSelectArea("CLS")
	DbCloseArea()
endif

CII->(DbGoTop())

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oPerg1()

Local aHelpPor := {}

PutSx1( 'FATC31','01','Cliente ?','','','mv_ch1','C',6,0,0,'G','','SA1','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'FATC31','02','Loja ?','','','mv_ch2','C',2,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'FATC31','03','UF ?','','','mv_ch3','C',2,0,0,'G','','12','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'FATC31','04','Coordenador ?','','','mv_ch4','C',6,0,0,'G','','SA3','','','mv_par04','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'FATC31','05','Representante ?','','','mv_ch5','C',6,0,0,'G','','SA3','','','mv_par05','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'FATC31','06','Tipo ?','','','mv_ch6','N',1,0,2,'C','','','','','mv_par06','Ativo','','','','Inativos','','','Inativando','','','Todos','','','','','',aHelpPor,{},{} )

Return


*************************
Static Function xFatc31()
*************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cMemAtu   
Private cMemHis   
Private coTbl2

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlgLC","oGrp1","oSay1","oMGet1","oSay2","oMGet2","oFld1","oBrw2","oSay3","osCliente")
SetPrvt("oSay6","osUF","osTel","oSay9","osRep","oSay11","osCoo","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

fMemoLig()

oFont1 := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgLC := MSDialog():New( 162,332,715,892,"Ligação Cliente",,,.F.,,,,,,.T.,,,.F. )
oGrp1  := TGroup():New( 072,003,246,268,"",oDlgLC,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1  := TSay():New( 080,008,{||"Historico de ligações:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,071,008)
oMGet1 := TMultiGet():New( 088,008,,oGrp1,251,083,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cMemHis:=u,cMemHis)}
oSay2  := TSay():New( 175,008,{||"Ligação Atual"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,071,008)
oMGet2 := TMultiGet():New( 184,008,,oGrp1,251,057,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet2:bSetGet := {|u| If(PCount()>0,cMemAtu:=u,cMemAtu)}
oFld1  := TFolder():New( 003,003,{"Cliente","Situação"},{},oDlgLC,,,,.T.,.F.,265,067,) 
oTbl2()
DbSelectArea("LIG")
oBrw2  := MsSelect():New( "LIG","","",{{"LINHA"  ,"","Linha"        ,""},;
                                       {"MEDIAKG","","Média KG"     ,"@E 999,999.99"},;
                                       {"MEDIARS","","Média R$"     ,"@E 999,999.99"},;
                                       {"DTUPED" ,"","Dt.Últ.Ped."  ,""},;
                                       {"DIAS"   ,"","Dias Últ.Ped.",""},;
                                       {"STATUS" ,"","Status"       ,""}},.F.,,{003,003,050,258},,, oFld1:aDialogs[2] )
oBrw2:oBrowse:nClrPane := CLR_BLACK
oBrw2:oBrowse:nClrText := CLR_BLACK

oSay3      := TSay():New( 004,006,{||"Cliente:"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008 )
osCliente  := TSay():New( 004,035,{||CII->CLIENTE+"/"+CII->LOJA+" - "+Alltrim(CII->NOME)},oFld1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,214,008 )
oSay5      := TSay():New( 017,006,{||"Tel.:"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008 )
osTel      := TSay():New( 016,035,{||Transform( LIG->TEL,"@R(99) 9999-9999")},oFld1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,053,008 )
oSay6      := TSay():New( 017,100,{||"UF:"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,006 )
osUF       := TSay():New( 016,124,{||CII->UF},oFld1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,028,008 )
oSay9      := TSay():New( 029,006,{||"Repres.:"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008 )
osRep      := TSay():New( 028,035,{||Alltrim(CII->REPRES)+" - "+Alltrim( Posicione("SA3",1,xFilial("SA3")+CII->REPRES, "A3_NOME" ))},oFld1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,214,008 )
oSay11     := TSay():New( 041,006,{||"Coord.:"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008 )
osCoo      := TSay():New( 041,035,{||Alltrim(CII->COORD)+" - "+Alltrim( Posicione("SA3",1,xFilial("SA3")+CII->COORD, "A3_NOME" ))},oFld1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,214,008 )
oSBtn1     := SButton():New( 251,207,1,,oDlgLC,,"", )
oSBtn1:bAction := {||fGravaLig(),oDlgLC:End()}

oSBtn2     := SButton():New( 251,241,2,,oDlgLC,,"", )
oSBtn2:bAction := {||oDlgLC:End()}

oDlgLC:Activate(,,,.T.)
LIG->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: LIG
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***********************
Static Function oTbl2()
***********************

Local aFds := {}

Aadd( aFds, {"LINHA"   ,"C",004,000} )
Aadd( aFds, {"MEDIAKG" ,"N",012,002} )
Aadd( aFds, {"MEDIARS" ,"N",012,002} )
Aadd( aFds, {"DTUPED"  ,"D",008,000} )
Aadd( aFds, {"DIAS"    ,"N",005,000} )
Aadd( aFds, {"STATUS"  ,"C",010,000} )
Aadd( aFds, {"TEL"     ,"C",015,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias LIG New Exclusive

cQuery := "SELECT "
cQuery += "   * "
cQuery += "FROM "
cQuery += "   CLIENTES_STATUS "
cQuery += "WHERE "

cQuery += "CLIENTE = '"+CII->CLIENTE+"' AND "
cQuery += "LOJA    = '"+CII->LOJA+"' AND "   
cQuery += "UF      = '"+CII->UF+"' AND "   
cQuery += "COORD   = '"+CII->COORD+"' AND "   
cQuery += "REPRES  = '"+CII->REPRES+"' AND "    

cQuery += "   ATIVO = 'S' "
cQuery += "ORDER BY COORD, DIAS "

TCQUERY cQuery NEW ALIAS "CLD"

while !CLD->(EOF())
   RecLock("LIG",.T.)
   LIG->LINHA   := CLD->LINHA
   LIG->MEDIAKG := CLD->MEDIAKG
   LIG->MEDIARS := CLD->MEDIARS
   LIG->DTUPED  := STOD(CLD->DTUPED)
   LIG->DIAS    := CLD->DIAS
   LIG->STATUS  := CLD->STATUS
   LIG->TEL     := CLD->TEL
   LIG->(MsUnLock())
   CLD->(DbSkip())
end

if Select("CLD") > 0
	DbSelectArea("CLD")
	DbCloseArea()
endif

LIG->(DbGoTop())

Return 



***************************
static function fGravaLig()
***************************

if !Empty( cMemAtu )
   DBselectArea("Z95")
   RecLock("Z95",.T.)
   Z95->Z95_FILIAL := xFilial("Z95")
   Z95->Z95_CLIENT := CII->CLIENTE
   Z95->Z95_LOJA   := CII->LOJA
   Z95->Z95_DATA   := Date()
   Z95->Z95_HORA   := Time()
   Z95->Z95_USUARI := __CUSERID
   Z95->(MsUnlock())
   MSMM(,,,cMemAtu,1,,,'Z95','Z95_MEMO')   //para gravar

   RecLock("CII",.F.)
   CII->DTULIG  := Z95->Z95_DATA
   CII->HRULIG  := Z95->Z95_HORA
   CII->(MSUnLock())     
else
  	MsgAlert("O sistema não gravará a ocorrência, pois não foi informado uma mensagem para a ligação atual.")
endif   

return


**************************
static function fMemoLig()
**************************
                  
Local cQuery
Local LF := CHR(13)+CHR(10)

cQuery := "SELECT "
cQuery += "   Z95_DATA, Z95_HORA, Z95_USUARI, Z95_MEMO "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z95")+" "
cQuery += "WHERE "
cQuery += "   Z95_CLIENT = '"+CII->CLIENTE+"' AND "
cQuery += "   Z95_LOJA   = '"+CII->LOJA+"' AND "   
cQuery += "   D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += "   Z95_DATA+Z95_HORA DESC"

TCQUERY cQuery NEW ALIAS "HIST"

cMemHis := ""

while !HIST->(EOF())
   cMemHis += "Ocorrida em: "+DTOC( STOD( HIST->Z95_DATA ) )+" - "+HIST->Z95_HORA+LF
   cMemHis += "Adicionado por: "+Alltrim(UsrRetName(HIST->Z95_USUARI))+LF
   cMemHis += "Mensagem: "+LF+MSMM(HIST->Z95_MEMO,80)+LF
   cMemHis += Replicate("-",80)+LF+LF

   HIST->(DbSkip())
end

if Select("HIST") > 0
	DbSelectArea("HIST")
	DbCloseArea()
endif

return

**************************
static function fUltLig(cCliente, cLoja)
**************************
                  
Local cQuery
Local aRet := {"",""}

cQuery := "SELECT TOP 1"
cQuery += "   Z95_DATA, Z95_HORA "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z95")+" "
cQuery += "WHERE "
cQuery += "   Z95_CLIENT = '"+cCLIENTE+"' AND "
cQuery += "   Z95_LOJA   = '"+cLOJA+"' AND "   
cQuery += "   D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += "   Z95_DATA+Z95_HORA DESC"

TCQUERY cQuery NEW ALIAS "HIST"

if !HIST->(EOF())
   aRet[1] := HIST->Z95_DATA
   aRet[2] := HIST->Z95_HORA
endif

if Select("HIST") > 0
	DbSelectArea("HIST")
	DbCloseArea()
endif

return aRet



***************

Static Function MbrIdxCol(nCol,oBrowse)

***************
// 7- DIAS S/COMPRAR 
// 8- DT. ULT. LIG.
if nCol == 7 .OR. nCol == 8 
	for nX := 1 to Len(oBrowse:aColumns)
	   if nX == 7 .OR. nX == 8 
		   oBrowse:SetHeaderImage(nX,"COLRIGHT")
  	   endif   
	next nX   
   DbSelectArea("CII")
   If nCol == 7
      nOrdG := 1
      Index On DIAS  To &coTbl1    
      
   elseif nCol == 8
      nOrdG := 2
      Index On DTULIG  To &coTbl1
   
   endif   
   CII->(DbSetOrder(1))
   oBrowse:SetHeaderImage(nCol,"COLDOWN")
	oBrowse:Refresh()
endif

if nCol == 1
   oBrowse:SetHeaderImage(7,"COLRIGHT")
   oBrowse:SetHeaderImage(8,"COLRIGHT")
   oBrowse:Refresh()

endif

Return



***************

Static Function fExcel()

***************


Private aCabec:={"CLIENTE","LOJA","NOME","UF","COORDENADOR","REPRESENTANTE","DIAS S/COMPRAR","DT.ULT.LIG.","HR.ULT.LIG."}

if MsgBox( OemToAnsi( "Deseja Exportar para o Excel??" ), "Escolha", "YESNO" )       
	
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Controle de Ligações para Clientes Inativos e Inativando", aCabec, aExPla}})})
	If !ApOleClient("MSExcel")
	    MsgAlert("Microsoft Excel não instalado!")
		Return()
	EndIf
	                                
Endif


Return 

