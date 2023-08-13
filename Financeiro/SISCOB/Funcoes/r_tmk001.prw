#include "rwmake.ch"
#include "topconn.ch"

*************

User Function RTMK001

*************

SetPrvt( "nVALOR,nPAGO,nNPAGO,nRECL,nFALTA,nSOBRA,nACEITO,nNACEITO,nMPARECE,nVPARECE," )

Titulo     := "Atendimentos por produto"
cString    := "ZZO"
wnrel      := "RTMK001"
CbTxt      := ""
cDesc1     := "O objetivo deste relat¢rio ‚ emitir o relatorio de atendimentos"
cDesc2     := "por produtos"
Tamanho    := "M"
aReturn    := { "Zebrado", 1,"Estoque", 2, 2, 1, "",1 }
nLastKey   := 0
cPerg      := "RTMK01"
nomeprog   := "RTMK001"
aOrd       := {}
M_PAG      := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()
Pergunte( cPerg, .F. )

SetPrint( cString, wnrel, cPerg, titulo, cDesc1, cDesc2, "", .F., aOrd, .F., Tamanho )

If nLastKey == 27
  Return .T.
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
  Return .T.
Endif

RptStatus({|| Imp()}, Titulo )// Substituido pelo assistente de conversao do AP5 IDE em 24/07/01 ==>  RptStatus({|| Execute(R010Imp)},Titulo)
Return NIL



***************

Static Function Imp()

***************

Local cSOBRA  := "", ;
      cFALTA  := ""

SX5->( DbSeek( "  ZT", .T. ) )
Do While SX5->X5_TABELA == "ZT"  // Carrega strings c/ ocorrencias falta/sobra
   If AllTrim( SX5->X5_DESCENG ) == "+"
      cFALTA += "'" + AllTrim( SX5->X5_CHAVE ) + "',"
   ElseIf AllTrim( SX5->X5_DESCENG ) == "-"
      cSOBRA += "'" + AllTrim( SX5->X5_CHAVE ) + "',"
   EndIf
   SX5->( DbSkip() )
EndDo
If Right( cSOBRA, 1 ) == ","
   cSOBRA := Left( cSOBRA, Len( cSOBRA ) - 1 )
EndIf
If Right( cFALTA, 1 ) == ","
   cFALTA := Left( cFALTA, Len( cFALTA ) - 1 )
EndIf
cSQL := "SELECT ZZO.ZZO_TIPO,ZZP.ZZP_NUM,ZZP.ZZP_PROD,SB1.B1_DESC,"
cSQL += "SUM( CASE WHEN ZZO.ZZO_SOLUCA <> '' THEN 1 ELSE 0 END ) AS xVPARECE,"
cSQL += "SUM( CASE WHEN ZZP.ZZP_PARECE <> '' THEN 1 ELSE 0 END ) AS xMPARECE,"
cSQL += "SUM( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGP*-1) ELSE ZZP.ZZP_VLNEGP END ) AS XVALOR,"
cSQL += "SUM( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN 1 ELSE 0 END ) AS XSOBRA,"
cSQL += "SUM( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cFALTA + ") THEN 1 ELSE 0 END ) AS XFALTA,"
cSQL += "SUM( CASE WHEN Left( ZZO.ZZO_SOLUCA, 1 ) = '1' AND ZZP.ZZP_PARECE = '1' THEN ( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGA*-1) ELSE ZZP.ZZP_VLNEGA END ) ELSE 0 END ) AS XPAGO,"
cSQL += "SUM( CASE WHEN Left( ZZO.ZZO_SOLUCA, 1 ) <> ' ' AND ZZP.ZZP_PARECE <> '1' THEN ( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGP*-1) ELSE ZZP.ZZP_VLNEGP END ) ELSE 0 END ) AS XNPAGO,"
cSQL += "SUM( CASE WHEN ZZP.ZZP_PARECE = '1' THEN 1 ELSE 0 END ) AS XACEITO,"
cSQL += "SUM( CASE WHEN ZZP.ZZP_PARECE = '2' THEN 1 ELSE 0 END ) AS XNACEITO "
cSQL += "FROM " + RETSQLNAME( "ZZP" ) + " ZZP," + RETSQLNAME( "ZZO" ) + " ZZO," + RETSQLNAME( "SB1" ) + " SB1 "
cSQL += "WHERE ZZP.ZZP_PROD=SB1.B1_COD AND ZZP.ZZP_NUM=ZZO_NUM AND Left( ZZO.ZZO_TIPO, 1) >= '" + MV_PAR01 + "' AND "
cSQL += "Left( ZZO.ZZO_TIPO, 1 ) <= '" + MV_PAR02 + "' AND ZZO_EMISSA >= '" + Dtos( MV_PAR03 ) + "' AND ZZO_EMISSA <= '" + Dtos( MV_PAR04 ) + "' AND "
cSQL += "ZZO.ZZO_CLIENT >= '" + MV_PAR05 + "' AND ZZO_CLIENT <= '" + MV_PAR06 + "' AND "
cSQL += "ZZO.ZZO_VEND >= '" + MV_PAR07 + "' AND ZZO_VEND <= '" + MV_PAR08 + "' AND "
cSQL += "ZZO.ZZO_TRANSP >= '" + MV_PAR09 + "' AND ZZO_TRANSP <= '" + MV_PAR10 + "' AND "
cSQL += "ZZO_FILIAL = '" + xFILIAL( "ZZO" ) + "' AND ZZP_FILIAL = '" + xFILIAL( "ZZP" ) + "' AND "
cSQL += "ZZP.D_E_L_E_T_ = '' AND ZZO.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
cSQL += "GROUP BY ZZP.ZZP_PROD,ZZP.ZZP_NUM,SB1.B1_DESC,ZZO.ZZO_TIPO "
cSQL += "ORDER BY ZZP.ZZP_PROD"

cSQL := ChangeQuery( cSQL )
Memowrit( "RTMK001.SQL", cSQL )
TCQUERY cSQL ALIAS ZZPX New
TcSetField( "ZZPX", "XVALOR",   "N", 10, 2 )
TcSetField( "ZZPX", "xVPARECE",  "N", 04, 0 )
TcSetField( "ZZPX", "xMPARECE",  "N", 04, 0 )
TcSetField( "ZZPX", "XSOBRA",   "N", 04, 0 )
TcSetField( "ZZPX", "XFALTA",   "N", 04, 0 )
TcSetField( "ZZPX", "XACEITO",  "N", 04, 0 )
TcSetField( "ZZPX", "XNACEITO", "N", 04, 0 )
TcSetField( "ZZPX", "xPAGO",     "N", 10, 2 )
TcSetField( "ZZPX", "xNPAGO",    "N", 10, 2 )

*cARQTMP := CriaTrab( , .F. )
*Copy To ( cARQTMP )
*ZZPX->( DbCloseArea() )
*DbUseArea( .T.,, cARQTMP, "ZZPX", .F., .F. )
*Index on Str( 9999999 - XVALOR, 10, 2 ) to cARQTMP
aPRINT := {}
ZZPX->( DbGotop() )
Do While ! ZZPX->( Eof() )
   cPROD  := ZZPX->ZZP_PROD
   aMAT   := {}
   cDESC  := ZZPX->B1_DESC
   nVALOR := nPAGO := nNPAGO := nRECL := nFALTA := nSOBRA := nACEITO := nNACEITO := nMPARECE := nVPARECE := 0
   Do While ZZPX->ZZP_PROD == cPROD
      nVALOR   += ZZPX->XVALOR
      nPAGO    += ZZPX->xPAGO
      nNPAGO   += ZZPX->xNPAGO
      nRECL++
      nFALTA   += ZZPX->XFALTA
      nSOBRA   += ZZPX->XSOBRA
      nACEITO  += ZZPX->XACEITO
      nNACEITO += ZZPX->XNACEITO
      nMPARECE += ZZPX->xMPARECE
      nVPARECE += ZZPX->xVPARECE
      SX5->( DbSeek( "  ZS" + Padr( Left( ZZPX->ZZO_TIPO, 1 ), 6 ) ) )
      If Empty( nPOS := Ascan( aMAT, { |X| X[ 1 ] == Left( ZZPX->ZZO_TIPO, 1 ) } ) )
         Aadd( aMAT, { Left( ZZPX->ZZO_TIPO, 1 ), Left( SX5->X5_DESCRI, 30 ), 1 } )
      Else
         aMAT[ nPOS, 3 ]++
      EndIf
      ZZPX->( DbSkip() )
   EndDo
   Asort( aMAT,,, {| X, Y | Y[ 1 ] > X[ 1 ] } )
	Aadd( aPRINT, { Left( cPROD, 10 ), Left( cDESC, 30 ), nVALOR, nPAGO, nNPAGO, nRECL, nFALTA, nSOBRA, nACEITO, nNACEITO, nVPARECE, nMPARECE, aMAT } )
EndDo
          *          1         2         3         4         5         6         7         8         9        10        11        12        13
          *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
CABEC1 := "CODIGO      DESCRICAO                       VAL. TOTAL    VAL.PAGO  VAL.NEGADO  ATEND.  FALTA  SOBRA  ACEITO  NEGADO  PAR.VD. PAR.MT"
CABEC2 := ""
          *XXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999.99  999,999.99  999,999.99   9999    9999   9999    9999    9999    9999    9999
          *XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX >>> 9999
nCONT := 1
Asort( aPRINT,,, {| X, Y | Y[ 3 ] < X[ 3 ] } )
Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )
Do While nCONT <= Len( aPRINT )
   If Prow() > 60
      Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )
   EndIf
   @ PROW() + 1, 000 PSAY aPRINT[ nCONT, 01 ]
   @ PROW()    , 012 PSAY aPRINT[ nCONT, 02 ]
   @ PROW()    , 044 PSAY aPRINT[ nCONT, 03 ] Picture "@E 999,999.99"
*   If nVALOR < 0
*      @ PROW() , 054 PSAY "-"
*   EndIf
   If aPRINT[ nCONT, 04 ] > 0
      @ PROW()    , 056 PSAY aPRINT[ nCONT, 04 ] Picture "@E 999,999.99"
   EndIf
   If aPRINT[ nCONT, 05 ] > 0
      @ PROW()    , 068 PSAY aPRINT[ nCONT, 05 ] Picture "@E 999,999.99"
   EndIf
   @ PROW()    , 081 PSAY aPRINT[ nCONT, 06 ] Picture "@E 9999"
   @ PROW()    , 089 PSAY aPRINT[ nCONT, 07 ] Picture "@E 9999"
   @ PROW()    , 096 PSAY aPRINT[ nCONT, 08 ] Picture "@E 9999"
   @ PROW()    , 104 PSAY aPRINT[ nCONT, 09 ] Picture "@E 9999"
   @ PROW()    , 112 PSAY aPRINT[ nCONT, 10 ] Picture "@E 9999"
   @ PROW()    , 120 PSAY aPRINT[ nCONT, 11 ] Picture "@E 9999"
   @ PROW()    , 128 PSAY aPRINT[ nCONT, 12 ] Picture "@E 9999"
   For nPOS := 1 To Len( aPRINT[ nCONT, 13 ] )
       @ PROW() + 1, 000 PSAY aPRINT[ nCONT, 13, nPOS, 1 ] + " - " + aPRINT[ nCONT, 13, nPOS, 2 ] + " >>> " + AllTrim( Trans( aPRINT[ nCONT, 13, nPOS, 3 ], "@E 9999" ) )
   Next
   @ PROW() + 1, 000 PSAY ""
	nCONT++
EndDo
Roda( 0, "", Tamanho )
ZZPX->( DbCloseArea() )
Set Device to Screen
If aReturn[5] == 1
  Set Printer To
  dbCommitAll()
  OurSpool( wnrel )
Endif
MS_FLUSH()
Return NIL



***************

Static Function ValidPerg()

***************

Local _sAlias  := Alias()
Local cPerg    := "RTMK01"
Local aRegs    := {}
Local i,j

dbSelectArea( "SX1" )
dbSetOrder( 1 )
AADD(aRegs,{cPerg,"01","Tipo de            :","De Emissao         :","De Emissao         :","mv_ch1","C",01,0,0,"G","","mv_par01",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZS",""})
AADD(aRegs,{cPerg,"02","Tipo ate           :","Transfere          :","Transfere          :","mv_ch2","C",01,0,0,"G","","mv_par02",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","ZS",""})
AADD(aRegs,{cPerg,"03","Emissao de         :","De Emissao         :","De Emissao         :","mv_ch3","D",08,0,0,"G","","mv_par03",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Emissao ate        :","Transfere          :","Transfere          :","mv_ch4","D",08,0,0,"G","","mv_par04",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Cliente de         :","De Emissao         :","De Emissao         :","mv_ch5","C",06,0,0,"G","","mv_par05",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA1",""})
AADD(aRegs,{cPerg,"06","Cliente ate        :","Transfere          :","Transfere          :","mv_ch6","C",06,0,0,"G","","mv_par06",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA1",""})
AADD(aRegs,{cPerg,"07","Representante de   :","De Emissao         :","De Emissao         :","mv_ch7","C",06,0,0,"G","","mv_par07",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"08","Representante ate  :","Transfere          :","Transfere          :","mv_ch8","C",06,0,0,"G","","mv_par08",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA3",""})
AADD(aRegs,{cPerg,"09","Transportadora de  :","De Emissao         :","De Emissao         :","mv_ch9","C",06,0,0,"G","","mv_par09",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA4",""})
AADD(aRegs,{cPerg,"10","Transportadora ate :","Transfere          :","Transfere          :","mv_cha","C",06,0,0,"G","","mv_par10",""          ,"","","","",""        ,"","","","",""        ,"","","","","","","","","","","","","","SA4",""})
For i := 1 to Len(aRegs)
  If ! DbSeek(cPerg+aRegs[i,2])
    RecLock("SX1",.T.)
    For j := 1 to FCount()
      If j <= Len(aRegs[i])
        FieldPut(j,aRegs[i,j])
      Endif
    Next
    MsUnlock()
  Endif
Next
DbSelectArea( _sAlias )
Return NIL
