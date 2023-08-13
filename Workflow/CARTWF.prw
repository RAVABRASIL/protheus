#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CARTWF    º Autor ³ AP6 IDE            º Data ³  11/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Informações de Controle de Faturamento e Vendas            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************

User Function CARTWF()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   conOut( " " )
   conOut( "***************************************************************************" )
   conOut( "Informações de Controle de Faturamento e Vendas - CARTWF()     	           " )
   conOut( "***************************************************************************" )
   conOut( " " )

   If Select( 'SX2' ) == 0
     PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "CARTWF" //Tables "Z09"
   	 Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam  
   	 grava()
   else//If Select( 'SX2' ) == 1
     Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam  
   	 grava()
   endif

Return 

*************

static Function grava()

************* 

Local nCartRs := nCartKg :=nOrdem := nEstoque := nAcs := 0
Local cCart := cQuery := cData1 := cData2 := cMes := ''
Local aArr := {}
Local aPrazo := {}                              
//dDataBase := stod('20090201')
cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cCart := ChangeQuery( cCart )
TCQUERY cCart NEW ALIAS "CARTX"

dbSelectArea('Z09')
Z09->( dbAppend()  )
RecLock("Z09", .F.)
Z09->Z09_FILIAL   := xFilial('Z09')
Z09->Z09_DATACT   := dDataBase - 1 //Gerado no dia 1, às 12:00 am. -1 para poder ficar no último dia, facilitando % frete
Z09->Z09_RSCAT    := nCartRs := CARTX->CARTEIRA_RS
Z09->Z09_KGCAT    := nCartKg := CARTX->CARTEIRA_KG
conOut( " CARTWF() - Fim do cálculo de carteira." )
CARTX->( dbCloseArea() )

cQuery += "SELECT '" + substr(dtos(dDataBase - 1),1,4) + "' ANO, '" + substr(dtos(dDataBase - 1),5,2) + "' MES, "
cQuery += "SUM(D2_TOTAL+D2_VALIPI) RS,SUM(D2_TOTAL) RS_SEM_IPI, "
cQuery += "sum(case "
cQuery += "when D2_SERIE = '' and F2_VEND1 not like '%VD%' "
cQuery += "then 0 "
cQuery += "else "
cQuery += "D2_QUANT * B1_PESOR "
cQuery += "end) KILOS "
cQuery += "FROM " + retSqlName('SD2') + " SD2, " + retSqlName('SB1') + " SB1, " + retSqlName('SF2') + " SF2 "
cQuery += "WHERE D2_EMISSAO BETWEEN '" + substr(dtos(dDataBase - 1),1,6)+'01' + "' and '" + dtos(dDataBase - 1) + "' "
cQuery += "AND D2_COD=B1_COD AND F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE=D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE "
cQuery += "AND D2_TIPO = 'N' AND F2_DUPL <> '' "
cQuery += "AND D2_CF IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "AND D2_CLIENTE NOT IN ('001588', '002655', '002311' ) "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' "
TCQUERY CQUERY NEW ALIAS 'AUX1'
AUX1->( dbGoTop() )

aPrazo			 := prazo( AUX1->ANO  +  AUX1->MES + '01')
Z09->Z09_VALRS 	 := (AUX1->RS - aPrazo[1][2])
Z09->Z09_VLSIPI  := (AUX1->RS_SEM_IPI - aPrazo[1][2])
Z09->Z09_KGFAT	 := AUX1->KILOS
Z09->Z09_PRZMED  := aPrazo[1][1]
conOut( " " )
conOut( "*******************************************************" )
conOut( " CARTWF() - Fim do cálculo de R$, S/IPI, KGFAT, PRZMED." )
conOut( "*******************************************************" )
conOut( " " )
nEstoq			 := estoque( dtos( dDataBase ), 1 )
				  //estoque(alltrim( str( AUX1->ANO ) ) + strzero( (val( AUX1->MES ) + 1 ), 2) + '01',1) //Já está no dia 1
Z09->Z09_ESTKG	 := nEstoq
Z09->Z09_PCTEST  := ( nEstoq / AUX1->KILOS ) * 100
Z09->Z09_ESTMED  :=  media( AUX1->ANO + AUX1->MES + "01", dtos( dDataBase ) )
					/*media(alltrim( str( AUX1->ANO ) ) + strzero( (val( AUX1->MES )    ), 2) + '01',;
					alltrim( str( AUX1->ANO ) ) + strzero( (val( AUX1->MES ) + 1), 2) + '01')*/
conOut( " " )
conOut( "****************************************" )
conOut( " CARTWF() - Fim do cálculo de Estoque.  " )
conOut( "****************************************" )
conOut( " " )
/*
cMes := iif( len( alltrim( str( val(AUX1->MES) - 1 ) ) ) < 2,;
        strzero( (val( AUX1->MES) - 1 ), 2),;
        alltrim( str( val(AUX1->MES) - 1 ) ) )
*/                        

cData1 := substr(dtos(dDataBase - 90),1,6)+'15'   //AUX1->ANO + cMes + '01'
                                                 //alltrim( str( AUX1->ANO ) ) + cMes  + '15'

cData2 := substr(dtos(dDataBase - 60),1,6)+'14'  //AUX1->ANO + AUX1->MES + '14'
		                                        //alltrim( str( AUX1->ANO ) ) + alltrim( AUX1->MES ) + '14'
aArr :=  comissao( cData1, cData2 )
Z09->Z09_COMISS := aArr[1][1]
Z09->Z09_PCTCOM := aArr[1][2]
Z09->Z09_ESTBOB := estoque( dtos( dDataBase ), 2 )
                                                //estoque(alltrim( str( AUX1->ANO ) ) + strzero( (val( AUX1->MES ) + 1 ), 2) + '01',2)
Z09->Z09_NNOTAS := aPrazo[1][3]
conOut( " " )
conOut( "****************************************" )
conOut( " CARTWF() - Fim do cálculo de Comissões." )
conOut( "****************************************" )
conOut( " " )
AUX1->( dbCloseArea() )
Z09->( MsUnlock() )
Z09->( dbCloseArea() )

conOut( " " )
conOut( "***************************************************************************" )
conOut( "Fim de execução: Informações de Controle de Faturamento e Vendas - CARTWF()" )
conOut( "***************************************************************************" )
conOut( " " )

Return

***************

Static Function comissao( cDataI, cDataF )

***************
local cQuery
local nComiss := 0
Local aArret := {}

cQuery := "SELECT SUM(E3_COMIS) AS COMISSAO, SUM(E3_BASE) AS BASE, ( SUM(E3_COMIS)/SUM(E3_BASE) ) * 100 AS PCT "
cQuery += "FROM " + retSqlName('SE3') +" "
cQuery += "WHERE E3_EMISSAO BETWEEN '" + cDataI + "' AND '" + cDataF + "' AND "
//Sempre tirado no intervalo do dia 15 do mes x ao dia 14 do mes x + 1
cQuery += "E3_DATA <> '' "
cQuery += "AND D_E_L_E_T_ = '' "
TCQUERY CQUERY NEW ALIAS 'AUX2'
AUX2->( dbGoTop() )
aAdd( aArret, { AUX2->COMISSAO, AUX2->PCT } )
AUX2->( dbCloseArea() )

Return aArret

***************

Static Function estoque( cData, nOpt )

***************
Local cQuery := ''
Local nTotal := 0

cQuery := "select B1_DESC, B1_COD, B1_PESOR  from " + RetSqlName("SB1") + " where B1_ATIVO = 'S' "
cQuery += iif( nOpt == 1, cQuery += "and B1_TIPO = 'PA' ", cQuery += "and B1_TIPO = 'PI' ")
cQuery += "and B1_COD >= ' ' and B1_COD <= 'ZZZZZZZZZZZZZZZ' "
cQuery += "and B1_FILIAL  = '" + xFilial( "SB1" ) + "' and D_E_L_E_T_ = ' '  "
cQuery += "and len( B1_COD ) < = 7 "
cQuery += "order by B1_COD "
TCQUERY cQuery NEW ALIAS "SBBX"
SBBX->( dbGoTop() )

do while ! SBBX->( EoF() )

  nTotal += CalcEst(SBBX->B1_COD, '01', stod(cData) )[1] * SBBX->B1_PESOR
  nTotal += CalcEst(SBBX->B1_COD, '02', stod(cData) )[1] * SBBX->B1_PESOR
  SBBX->( dbSkip() )
  
endDo
SBBX->( dbCloseArea() )

Return nTotal

***************

Static Function media( cDataI, cDataF )

***************

Local cQuery := ''
Local nTotal := 0
Local aEstoque := {}

cQuery := "select B1_DESC, B1_COD, B1_PESOR  from " + RetSqlName("SB1") + " where B1_ATIVO = 'S' and B1_TIPO = 'PA' "
cQuery += "and B1_COD >= ' ' and B1_COD <= 'ZZZZZZZZZZZZZZZ' "
cQuery += "and B1_FILIAL  = '" + xFilial( "SB1" ) + "' and D_E_L_E_T_ = ' '  "
cQuery += "and len( B1_COD ) < = 7 "
cQuery += "order by B1_COD "
TCQUERY cQuery NEW ALIAS "SBBY"
SBBY->( dbGoTop() )

dDataI := stod( cDataI )
dDataF := stod( cDataF ) - 1
nDif   := ( dDataF - dDataI ) + 1

do while ! SBBY->( EoF() )
 
 dDataI := stod( cDataI )
 
 do while dDataI <= dDataF
   nTotal += CalcEst(SBBY->B1_COD, '01', dDataI + 1 )[1] * SBBY->B1_PESOR
   nTotal += CalcEst(SBBY->B1_COD, '02', dDataI + 1 )[1] * SBBY->B1_PESOR
   dDataI++
 endDo
 SBBY->( dbSkip() )  
endDo

SBBY->( dbCloseArea() )

Return nTotal/nDif

***************

Static Function prazo( cData, nOpt )

***************
Local nPRZMD  := nTOTACE := nVALOR  := nPESO    := nDIAS    := nDIAXVL   := nNOTAS  := 0
Local nPRZMDT := nVALORT := nPESOT  := nDIAST   := nDIAXVLT := nNOTAST   := nAC     := 0
Local _nTOTA  := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0
Local nTotace2 := 0
Local cMes    := substr(cData, 5, 2)
Local aArrt := {}

/*Fazer código para guardar ordem e recno das tabelas abaixo*/
dbSelectarea( 'SD2' )
SD2->( dbSetOrder( 3 ) )

dbSelectarea( 'SB1' )
SB1->( dbSetOrder( 1 ) )

dbSelectarea( 'SE4' )
SE4->( dbSetOrder( 1 ) )

dbSelectarea( 'SF2' )
SF2->( dbSetOrder( 9 ) )
										  //'01'+'Mes'+'ANO'
//SF2->( dbSeeK( xFILIAL('SF2') + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ), .T. ) )
SF2->( dbSeeK( xFILIAL('SF2') + cData, .T. ) )
Do While ! SF2->( EoF() ) .And. StrZero( Month( F2_EMISSAO ), 2 ) == cMes .AND. SF2->F2_EMISSAO <= dDataBase
	dDATA  := SF2->F2_EMISSAO
	nPRZMD := nTOTACE := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS := 0
	Do While ! SF2->( EoF() ) .And. SF2->F2_EMISSAO == dDATA .And. StrZero( Month( F2_EMISSAO ), 2 ) == cMes
		If ( ! Empty( SF2->F2_DUPL ) )
			nTTSD2 := 0 //incluido em 13/10/06 total por nota pelo SD2
			//nQtdKg := 0
			_nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0
			SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
			If (SD2->D2_CF $ "511  /5101 /5107 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 ")
				Do While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !EoF() )
					If !(alltrim(SD2->D2_COD) $ "187  /188  /189  /190 ") .AND. substr(SD2->D2_COD,1,1) != 'M'
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )						
						If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D'))
							nTOTACE += limpBras( SD2->D2_COD ) * SD2->D2_QUANT
							nAC := limpBras( SD2->D2_COD ) * SD2->D2_QUANT
							nTTSD2 += SD2->D2_TOTAL - nAC
						ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
							nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
							nTOTACE += nAC
							nTTSD2 += SD2->D2_TOTAL - nAC
						Else
							nTTSD2 += SD2->D2_TOTAL
						EndIf
						SD2->( dbSkip() )
					Else
						SD2->( dbSkip() )
					EndIf
				Enddo
			Endif
			//nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)
			nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE $ "UNI/0  ".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)
			nPRZMD  += nTTSD2
			nDIAXVL += (IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * nTTSD2)
		EndIf
		SF2->( DbSkip() )		
	EndDo
	If ! Empty( nVALOR )
  	  nNOTAST  := nNOTAST  + nNOTAS
  	  nDIAXVLT += nDIAXVL
	  nPRZMDT  += nPRZMD
	  nTotace2 += nTotace
	EndIf
EndDo
aAdd(aArrt,{nDIAXVLT/nPRZMDT, nTotace2, nNOTAST})

Return aArrt

***************

Static Function calcAcs(cCod)

***************

Local cQuery := ''          //M.O.D.
Local aProd	 := { { 'CTG011', 1.240 },;
				  { 'CTG006', 0.401 },;
				  { 'CTG007', 0.519 },;
				  { 'CTG008', 0.619 },;
				  { 'CTG010', 0.840 } }
Local nExtra := 0
nTotal := 0

If substring(cCod,1,1) == 'C'

	If Len( AllTrim( cCod ) ) >= 8
		cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
	cQuery += "(select	top 1 SD1.D1_VUNIT "
	cQuery += " from	" + RetSqlName('SD1') + " SD1 "
	cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
	cQuery += "	order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
	cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
	cQuery += "where SG1.G1_COD = '" + alltrim(cCod) + "' and "      //fita hamper ME0807,  CAAA003, CAE003,  CAF003,  CAD003
	cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
	cQuery += "and SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
	cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )
	
	Do while ! TMP->( EoF() )
	  if TMP->G1_COD == 'CTG011' .and. TMP->G1_COMP == 'AC0003'
	    TMP->( dbSkip() )
	  else
	    nTotal += TMP->G1_QUANT * TMP->D1_VUNIT 
	    TMP->( DbSkip() )
	  endIf
	EndDo

Else

	Alert("Produto nao e hospitalar.")
	return Nil

EndIf

TMP->( DbCloseArea() )

Return nTotal

***************

Static Function  limpBras( cCod )

***************
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local nTotal := 0
Local cAlias
Local aArea := {}
cAlias := iif( substr( alias(), 1, 4 ) == 'TMPX', soma1(alias()), 'TMPX1')
aArea := getArea()

If Len( AllTrim( cCod ) ) >= 8
	cCod := U_transgen(cCod)
EndIf
cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
cQuery += " (select	top 1 SD1.D1_VUNIT "
cQuery += " from	" + RetSqlName('SD1') + " SD1 "
cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
cQuery += " order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
if substr(cCod,1,1) $ 'E /D'
  cQuery += "and substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
endIf
cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
cQuery := ChangeQUery(cQuery)
TCQUERY cQUery NEW ALIAS &cAlias
&(cAlias+"->( DbGoTop() )")

Do while ! &(cAlias+"->( EoF() )")
  if &(cAlias+"->G1_COMP") >= 'ME0700' .and. &(cAlias+"->G1_COMP") <= 'ME0799' //ME comprado, não é fabricado internamente
    nTotal += &(cAlias+"->G1_QUANT") * &(cAlias+"->D1_VUNIT")
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'MP'
    nTotal += &(cAlias+"->G1_QUANT") * &(cAlias+"->D1_VUNIT")
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'PI'
  	nTotal += &(cAlias+"->G1_QUANT") * limpBras( &(cAlias+"->G1_COMP") ) / 100
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'ME'
  	nTotal += &(cAlias+"->G1_QUANT") * limpBras( &(cAlias+"->G1_COMP") )
  endIf
  &(cAlias+"->( DbSkip() )" )
EndDo

&(cAlias+"->( DbCloseArea() )" )
restArea( aArea )

Return nTotal