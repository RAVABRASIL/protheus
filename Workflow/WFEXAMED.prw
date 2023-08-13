#include "rwmake.ch"
#include "TbiConn.ch"
//#include "TbiCode.ch"
#include "topconn.ch"

*************

User Function WFEXAMED()

*************
dDataBase := stod('20080214')
conOut( "Iniciando programa WFEXAMED - " + Dtoc( Date() ) + ' - ' + Time() )

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFEXAMED" Tables "SRA", "TM4", "RC8"
  sleep( 5000 )
  conOut( "Programa WFEXAMED na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Envia()
Else
  conOut( "Programa WFEXAMED sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Envia()
EndIf
conOut( "Finalizando programa WFEXAMED em " + Dtoc( DATE() ) + ' - ' + Time() )

RETURN//main

***************

Static Function Envia()

***************

Local cQuery 	 := ''
Local aExames 	 := {}
cQuery += "select	SRA.RA_MAT, SRA.RA_NOME, RC8.RC8_DATA, RC8.RC8_TIPOEX, RC8.RC8_NOMEEX, TM4.TM4_DIAS "
cQuery += "from    "+retSqlName('SRA')+" SRA, "+retSqlName('TM4')+" TM4, "+retSqlName('RC8')+" RC8 "
cQuery += "where   SRA.RA_FILIAL = '"+xFilial('SRA')+"' and TM4.TM4_FILIAL = '"+xFilial('TM4')+"' and "
cQuery += "RC8.RC8_FILIAL = '"+xFilial('RC8')+"' and SRA.RA_DEMISSA = '' and len(SRA.RA_MAT) < 6 and "
cQuery += "SRA.RA_MAT = RC8.RC8_MAT and TM4.TM4_EXAME = RC8.RC8_TIPOEX and "
/**///Apenas para Teste
//cQuery += "SRA.RA_MAT = '00298' and "
/**///Apenas para Teste
cQuery += "SRA.D_E_L_E_T_ != '*' and TM4.D_E_L_E_T_ != '*' and RC8.D_E_L_E_T_ != '*' "
cQuery += "order by SRA.RA_NOME, RC8.RC8_DATA "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

do While ! TMPX->( EoF() )
	if !empty( TMPX->RC8_DATA )
		if ( ( StoD( TMPX->RC8_DATA ) + TMPX->TM4_DIAS ) - dDataBase == 15 ) .OR.;
	  	   ( ( StoD( TMPX->RC8_DATA ) + TMPX->TM4_DIAS ) - dDataBase == 30 )
	  	   if testa()  
				aAdd( aExames, { TMPX->RA_MAT, TMPX->RA_NOME, TMPX->RC8_DATA, TMPX->TM4_DIAS, TMPX->RC8_NOMEEX } )
			endIf
		endIf
	endIf
	TMPX->( dbSkip() )
endDo
if len(aExames) == 0
	conOut( "WFEXAMED sem e-mails para enviar em " + Dtoc( DATE() ) + ' - ' + Time() )	
	return TMPX->( dbCloseArea() )
endIf
oProcess:=TWFProcess():New("WFEXAM","Vencimento de exames")
oProcess:NewTask('Inicio',"\workflow\http\emp01\WFEX2.htm")
oHtml   := oProcess:oHtml //workflow\http\emp01

for z := 1 to len(aEXAMES)
	aadd( oHtml:ValByName("it.matric"),  alltrim( aEXAMES[z][1] ))
	aadd( oHtml:ValByName("it.num"), 	 alltrim( aEXAMES[z][2] ))
	aadd( oHtml:ValByName("it.dtexame"), StoD(aEXAMES[z][3]) 	 )
	aadd( oHtml:ValByName("it.exame"),   alltrim(aEXAMES[z][5])  )
	aadd( oHtml:ValByName("it.dtdias"),  alltrim( str( ( StoD(aEXAMES[z][3]) + aEXAMES[z][4] ) - dDataBase ) ) + " dia(s)"  )
next

_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
//oProcess:cTo	:= "emmanuel@ravaembalagens.com.br"
oProcess:cTo	:= "karla.barreto@ravaembalagens.com.br"
//oProcess:cCC	:= "flavia.rocha@ravaembalagens.com.br"
subj	:= "ATENÇÃO: Exames perto do vencimento!"
oProcess:cSubject  := subj
conOut( "Vencimento de exames (WFEXAMED) gerado em: " + Dtoc( DATE() ) + ' - ' + Time() )
oProcess:Start()
WfSendMail()
Sleep( 5000 )
oProcess:Finish()
TMPX->( dbCloseArea() )
return

***************

Static Function testa()

***************

Local cQry2 := ''

cQry2 += "select * from " + retSqlName('RC8') + " "
cQry2 += "where RC8_FILIAL = '" + xFilial('RC8') + "' and RC8_MAT = '" + TMPX->RA_MAT + "' and "
if TMPX->RC8_TIPOEX $ '000001 000002'
	cQry2 += "RC8_TIPOEX = '"+ iif(TMPX->RC8_TIPOEX == '000001', '000005', '000006') +"' and "
else
	cQry2 += "RC8_TIPOEX = '" + TMPX->RC8_TIPOEX + "' and "
endIf
cQry2 += "RC8_DATA > '" + TMPX->RC8_DATA + "' and D_E_L_E_T_ != '*' "
TCQUERY cQry2 NEW ALIAS 'XYZ'
XYZ->( dbGoTop() )

if ! XYZ->( EoF() )
	XYZ->( dbCloseArea() )
	Return .F.
endIf

XYZ->( dbCloseArea() )

Return .T.