#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

*************

User Function WFFAT002()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT002" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFAT002 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT002 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT002 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

Return


***************

Static Function Exec()

***************

Local CQry:=''
Local nQTD:=0
Local nTotV:=nTotQ:=nTotP:=0

/*CQry:="SELECT SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SA1.A1_MUN, SF2.F2_EST, "
CQry+="SF2.F2_PBRUTO, SF2.F2_VALBRUT,Z04_DATSAI,F2_DTEXP,A4_DIATRAB,ZZ_PRZENT  "
CQry+="FROM " + RetSqlName('SF2') + " SF2, " + RetSqlName('SA4') + " SA4, " + RetSqlName('SA1') + " SA1," + RetSqlName('SZZ') + " SZZ, "
CQry+=" " + RetSqlName('Z04') + " Z04 "
CQry+="WHERE SF2.F2_TRANSP = SA4.A4_COD "
CQry+="AND SF2.F2_CLIENTE = SA1.A1_COD "
CQry+="AND SF2.F2_LOJA = SA1.A1_LOJA "
CQry+="AND SF2.F2_TRANSP = SZZ.ZZ_TRANSP  "
CQry+="AND SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
CQry+="AND Z04_DOC=F2_DOC "
CQry+="AND SF2.F2_EMISSAO='"+Dtos( DDATABASE )+"'  "
CQry+="AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "'  "
CQry+="AND SF2.D_E_L_E_T_ = ' '  "
CQry+="AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "'  "
CQry+="AND SA4.D_E_L_E_T_ = ' ' "
CQry+="AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' "
CQry+="AND SA1.D_E_L_E_T_ = ' ' "
CQry+="AND SZZ.ZZ_FILIAL = '" + xFilial( "SZZ" ) + "' "
CQry+="AND SZZ.D_E_L_E_T_ = ' ' "
CQry+="AND Z04.Z04_FILIAL = '" + xFilial( "Z04" ) + "' "
CQry+="AND Z04.D_E_L_E_T_ = ' ' "
CQry+="ORDER BY F2_TRANSP,F2_DOC  "*/

CQry:="SELECT SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE, "
CQry+="SA1.A1_MUN, SF2.F2_EST, SF2.F2_PBRUTO, SF2.F2_VALBRUT,F2_DTEXP,  "
CQry+="A4_DIATRAB,ZZ_PRZENT,Z04_DATSAI  "

CQry+="FROM " + RetSqlName('SF2') + " SF2 "
CQry+="JOIN " + RetSqlName('SA4') + " SA4 ON SF2.F2_TRANSP = SA4.A4_COD  "
CQry+="AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "'  "
CQry+="AND SA4.D_E_L_E_T_ = ' ' "

CQry+="JOIN " + RetSqlName('SA1') + " SA1 ON  SF2.F2_CLIENTE = SA1.A1_COD "
CQry+="AND SF2.F2_LOJA = SA1.A1_LOJA "
CQry+="AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "'  "
CQry+="AND SA1.D_E_L_E_T_ = ' ' "

CQry+="JOIN " + RetSqlName('SZZ') + " SZZ ON SF2.F2_TRANSP = SZZ.ZZ_TRANSP " 
CQry+="AND SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ   "
CQry+="AND SZZ.ZZ_FILIAL = '" + xFilial( "SZZ" ) + "'  "
CQry+="AND SZZ.D_E_L_E_T_ = ' ' "

CQry+="LEFT JOIN " + RetSqlName('Z04') + " Z04 ON Z04_DOC=F2_DOC  "
CQry+="AND Z04.Z04_FILIAL = '" + xFilial( "Z04" ) + "'  "
CQry+="AND Z04.D_E_L_E_T_ = ' '  "

CQry+="WHERE F2_SERIE!='' "
CQry+="AND SF2.F2_EMISSAO ='"+Dtos( DDATABASE )+"'  "
CQry+="AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' " 
CQry+="AND SF2.D_E_L_E_T_ = ' '  "
CQry+="ORDER BY F2_TRANSP,F2_DOC " 

TCQUERY CQry NEW ALIAS "TRAX"

TCSetField( "TRAX", "F2_EMISSAO", "D")
TCSetField( "TRAX", "Z04_DATSAI"  , "D")

TRAX->( DbGoTop() )


Do While ! TRAX->( EoF() )
  
  cNum:=TRAX->F2_TRANSP
  cNome:=Alltrim( TRAX->A4_NOME )
  nTotV:=nTotQ:=nTotP:=0
  
  oProcess:=TWFProcess():New("WFFAT002","WFFAT002")
  oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT002.html")
  oHtml   := oProcess:oHtml

  oHtml:ValByName( "cTransp",cNome  )

  Do While ! TRAX->( EoF() ) .AND. TRAX->F2_TRANSP==cNum
    
    nQTD:=QTDVOL(TRAX->F2_DOC,TRAX->F2_SERIE)
    aadd( oHtml:ValByName("it.Doc") ,TRAX->F2_DOC )
	aadd( oHtml:ValByName("it.Valor" ),TRANSFORM(TRAX->F2_VALBRUT,"@E 999,999,999.9999"))
    aadd( oHtml:ValByName("it.QTD" ), TRANSFORM(nQTD,"@E 999,999,999.9999") )
    aadd( oHtml:ValByName("it.Peso" ),TRANSFORM(TRAX->F2_PBRUTO,"@E 999,999,999.9999"))
    aadd( oHtml:ValByName("it.Loca" ),TRAX->A1_MUN+" - "+ALLTRIM(TRAX->F2_EST)  )
    aadd( oHtml:ValByName("it.Emissao" ),DtoC(TRAX->F2_EMISSAO) )
    aadd( oHtml:ValByName("it.Previsao" ), IIF( !EMPTY(TRAX->Z04_DATSAI),DtoC(CalcPrv(TRAX->Z04_DATSAI, TRAX->A4_DIATRAB, TRAX->ZZ_PRZENT) ),'**/**/**') )

                                           

   nTotV+=TRAX->F2_VALBRUT
   nTotQ+=nQTD
   nTotP+=TRAX->F2_PBRUTO
   
    TRAX->( DbSkip() )
  
  EndDo

  oHtml:ValByName( "cTotV", TRANSFORM( nTotV,"@E 999,999,999.9999") )
  oHtml:ValByName( "cTotQ", TRANSFORM( nTotQ,"@E 999,999,999.9999") )
  oHtml:ValByName( "cTotP", TRANSFORM( nTotP,"@E 999,999,999.9999") )
  
  _user := Subs(cUsuario,7,15)
  oProcess:ClientName(_user)
//  oProcess:cTo := "antonio@ravaembalagens.com.br"
  oProcess:cTo := iif(!EMPTY(TRAX->A4_EMAIL),Alltrim(TRAX->A4_EMAIL)+ "; joao.emanuel@ravaembalagens.com.br","joao.emanuel@ravaembalagens.com.br")
  subj	:= "Previsao de Entrega Transportadora - "+cNome
  oProcess:cSubject  := subj
  oProcess:Start()
  WfSendMail()

EndDo

TRAX->( DbCloseArea() )

Return

***************

Static Function CalcPrv(dDatsai, cDiatrab, nPrzent)

**************

  Local x := 1
  Local dData := dDatsai

  IF cDiatrab == alltrim(str(3))
    dData += nPrzent + 1  // a pedido de alexandre 001370 em 16/10/2009
  Else
    while( x <= nPrzent )

      IF (dData == DataValida(dData) )
        dData++
        x++
      ElseIF DataValida(dData) - dData >= 2
        DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
            dData := DataValida(dData)
            IF x == 1 //dayanne colocando saídas aos sábados de empresas que trabalham em 1
              x++
            ENDIF
          CASE cDiatrab == alltrim(str(2)) //seg ate sabado
            dData++
            x++
            /*Modificado*/
            IF (x > nPrzent) .AND. (dow(dData) == 1)
              dData++
            ENDIF
            /*Aqui*/
        ENDCASE
      Else
        dData := DataValida(dData)
      ENDIF
    EndDo
  Endif

  //dData++ 
  //o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
  //o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790
  x := 1

  while (x <= 2) .AND. (dData != DataValida(dData))

  //IF dData != DataValida(dData)
    DO CASE
      CASE cDiatrab == alltrim(str(1))
        IF dow(dData) == 1
          dData := DataValida(dData) + 1
        else
          dData := DataValida(dData)
        EndIf
      CASE cDiatrab == alltrim(str(2))
        IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
        /*Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          dData++*/
        ENDIF
    EndCase

  //ENDIF
  x++
  EndDo

Return dData


***************

Static Function QTDVOL(cDoc,cSerie)

***************

Local cQry:=''
Local nTotQt := 0
Local cProd:=''

CQry+="SELECT D2_DOC,D2_SERIE,D2_COD,D2_QUANT FROM  " + RetSqlName('SD2') + " SD2 "
CQry+="WHERE D2_DOC='" +cDoc+ "' "
CQry+="AND D2_SERIE='" +cSerie+ "' "
CQry+="AND D2_FILIAL ='" + xFilial( "SD2" ) + "' "
CQry+="AND SD2.D_E_L_E_T_!='*' "
TCQUERY CQry NEW ALIAS "AUUX"

AUUX->( DbGoTop() )       

Do While ! AUUX->( EoF() )

	If Len( Alltrim( AUUX->D2_COD ) ) <= 7
		cProd := AUUX->D2_COD
	Else
		If Subs( AUUX->D2_COD, 5, 1 ) == "R"
			cProd := Padr( Subs( AUUX->D2_COD, 1, 1 ) + Subs( AUUX->D2_COD, 3, 4 ) + Subs( AUUX->D2_COD, 8, 2 ), 15 )
		Else
			cProd := Padr( Subs( AUUX->D2_COD, 1, 1 ) + Subs( AUUX->D2_COD, 3, 3 ) + Subs( AUUX->D2_COD, 7, 2 ), 15 )
		EndIf
	EndIf
	
	dbselectarea( 'SB5' )
	SB5->( dbsetorder( 1 ) )
	SB5->( DbSeek( xFilial('SB5') + cProd ) )
	
	nTotQt += AUUX->D2_QUANT/(SB5->B5_QTDFIM/SB5->B5_QE2)
	
	AUUX->( DbSkip() )

EndDo
AUUX->( DbCloseArea() ) 

return nTotQt
