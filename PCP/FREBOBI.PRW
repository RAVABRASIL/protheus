#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "                        

*************

User Function  FREBOBI()

*************

local oReport


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= ReportDef()
oReport:PrintDialog()

Return

***************

Static Function ReportDef()

***************

Local oSection1
Local oSection2
local oSection3
local oReport

ValidPerg('FREBOB')

Pergunte('FREBOB',.T.)


oReport:= TReport():New("FREBOB","Contagem de Bobina ",, {|oReport| ReportPrint(oReport)},"Contagem de Bobina ")

oReport:SetPortrait()


oSection3 := TRSection():New(oReport,"CONTAGEM",{'TABX'},,,)

TRCell():New(oSection3,'CONTAGEM'      ,'','Contagem', ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'QTD'           ,'','Qtd'    , ,5,/*lPixel*/,/*{|| code-block de impressao }*/)


oSection1 := TRSection():New(oSection3,"PRODUTO",{'TABX'},,,)

TRCell():New(oSection1,'ZZ4_CODIGO'    ,'','Produto', ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTD'           ,'','Qtd'    , ,5,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,"ITEM",{'TABX'},,,)

TRCell():New(oSection2,'ZZ4_BOBINA'    ,'','Bobina', ,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ZZ4_PESO'      ,'','Peso', ,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ZZ4_MAQ'       ,'','Maquina', ,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ZZ4_CODPI'     ,'','PI', ,14,/*lPixel*/,/*{|| code-block de impressao }*/)



Return(oReport)


***************

Static Function ReportPrint(oReport)

***************

Local oSection3   := oReport:Section(1)
Local oSection1   := oSection3:Section(1)
Local oSection2   := oSection1:Section(1)
Local cQuery      := ""     


oReport:SetTitle(Alltrim("Contagem de Bobina " ))

cQuery:= "select "
cQuery+= "C2_PRODUTO ZZ4_CODPI,ZZ4_BOBINA,ZZ4_PESO,ZZ4_MAQ,ZZ4_CODIGO,ZZ4_CONTAG "
cQuery+= "from ZZ4020 ZZ4, Z00020 Z00,SC2020 SC2 "
cQuery+= "where ZZ4.D_E_L_E_T_='' "
cQuery+= "AND ZZ4_CONTAG='"+MV_PAR01+"' "
cQuery+= "AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery+= "AND SUBSTRING(Z00_OP,1,6)+Z00_SEQ=ZZ4_BOBINA "
cQuery+= "AND Z00.D_E_L_E_T_='' "
cQuery+= "AND SC2.D_E_L_E_T_='' "
cQuery+= "ORDER BY ZZ4_CODIGO "


If Select("TABX") > 0
	DbSelectArea("TABX")
	TABX->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS 'TABX'                      

TABX->( DbGoTop() )
oReport:SetMeter(TABX->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oSection3:Init()

oSection3:Cell("CONTAGEM"):SetValue( MV_PAR01 )
oSection3:Cell("CONTAGEM"):SetAlign("LEFT")

nQtd:= fQtdProd('')

oSection3:Cell("QTD"):SetValue( nQtd )
oSection3:Cell("QTD"):SetAlign("LEFT")

oSection3:PrintLine()
oSection3:Finish()

oSection2:Init()

Do While !oReport:Cancel() .And. TABX->(!Eof())

	oSection2:Finish()	
    oSection1:Init()

    cProd:=TABX->ZZ4_CODIGO 

    //Section1
    oSection1:Cell("ZZ4_CODIGO"):SetValue( cProd )
	oSection1:Cell("ZZ4_CODIGO"):SetAlign("LEFT")
    
    nQtd:= fQtdProd(cProd)
    
    oSection1:Cell("QTD"):SetValue( nQtd )
	oSection1:Cell("QTD"):SetAlign("LEFT")

    oSection1:PrintLine()		
    oSection1:Finish()
    
    oSection2:Init()
    
    
    Do While !oReport:Cancel() .And. TABX->(!Eof()) .and.  TABX->ZZ4_CODIGO ==cProd

	    oReport:IncMeter()    
	    //Section2
		
	    oSection2:Cell("ZZ4_BOBINA"):SetValue( TABX->ZZ4_BOBINA )
		oSection2:Cell("ZZ4_BOBINA"):SetAlign("LEFT")
				
	    oSection2:Cell("ZZ4_PESO"):SetValue( TABX->ZZ4_PESO )
		oSection2:Cell("ZZ4_PESO"):SetAlign("RIGHT")
				
	    oSection2:Cell("ZZ4_MAQ"):SetValue( TABX->ZZ4_MAQ )
		oSection2:Cell("ZZ4_MAQ"):SetAlign("LEFT")
	
	    oSection2:Cell("ZZ4_CODPI"):SetValue( TABX->ZZ4_CODPI )
		oSection2:Cell("ZZ4_CODPI"):SetAlign("LEFT")

	    oSection2:PrintLine()         
						
	    TABX->(DBSKIP())		

    EndDo
                
    
EndDo

TABX->(dbCloseArea())
oSection3:Finish()
oSection1:Finish()
oSection2:Finish()


Return




***************

Static Function ValidPerg(cPerg)

***************

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

PutSx1( cPerg, '01', 'Contagem:' , '', '', 'mv_ch1', 'C', 06, 0, 0, 'G', '', '', '', ''   , 'mv_par01',    '', '', '', '',            '', '', '',           '', '', '', '', '', '', '', '', '', aHelpPor, aHelpEng, aHelpSpa )


Return NIL


***************

Static Function fQtdProd(cProd)

***************

local cQry:=" "
LOCAL nRet:=0

cQry:="select COUNT(*) TOTAL  from ZZ4020 ZZ4 "
cQry+="where D_E_L_E_T_='' "
cQry+="AND ZZ4_CONTAG='"+MV_PAR01+"' "
IF !EMPTY(cProd)
   cQry+="and ZZ4_CODIGO='"+cProd+"' "
ENDIF

If Select("TABY") > 0
	DbSelectArea("TABY")
	TABY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TABY'                      

if TABY->(!Eof())

   nRet:=TABY->TOTAL 

ENDIF

TABY->(dbclosearea())

Return nRet
