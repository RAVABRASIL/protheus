#include "rwmake.ch"
#include "topconn.ch"

*************

User Function RTMK003

*************

SetPrvt( "nVALOR,nPAGO,nNPAGO,nRECL,nVPARECE" )

Titulo     := "Atendimentos por transportadora"
cString    := "ZZO"
wnrel      := "RTMK003"
CbTxt      := ""
cDesc1     := "O objetivo deste relat¢rio ‚ emitir o relatorio de atendimentos"
cDesc2     := "por transportadora"
Tamanho    := "P"
aReturn    := { "Zebrado", 1,"Estoque", 2, 2, 1, "", 1 }
nLastKey   := 0
cPerg      := "RTMK01"
nomeprog   := "RTMK003"
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

cSQL := "SELECT ZZO.ZZO_TIPO,ZZP.ZZP_NUM,ZZO.ZZO_TRANSP,SA4.A4_NOME,"
cSQL += "SUM( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGP*-1) ELSE ZZP.ZZP_VLNEGP END ) AS xVALOR,"
cSQL += "SUM( CASE WHEN Left( ZZO.ZZO_SOLUCA, 1 ) = '1' AND ZZP.ZZP_PARECE = '1' THEN ( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGA*-1) ELSE ZZP.ZZP_VLNEGA END ) ELSE 0 END ) AS XPAGO,"
cSQL += "SUM( CASE WHEN Left( ZZO.ZZO_SOLUCA, 1 ) <> ' ' AND ZZP.ZZP_PARECE <> '1' THEN ( CASE WHEN LEFT(ZZO.ZZO_TIPO,1)+'.'+ZZP.ZZP_OCORR in (" + cSOBRA + ") THEN (ZZP.ZZP_VLNEGP*-1) ELSE ZZP.ZZP_VLNEGP END ) ELSE 0 END ) AS XNPAGO "
cSQL += "FROM " + RETSQLNAME( "ZZP" ) + " ZZP," + RETSQLNAME( "ZZO" ) + " ZZO," + RETSQLNAME( "SA4" ) + " SA4 "
cSQL += "WHERE ZZP.ZZP_NUM=ZZO.ZZO_NUM AND ZZO.ZZO_TRANSP=SA4.A4_COD AND Left( ZZO.ZZO_TIPO, 1) >= '" + MV_PAR01 + "' AND "
cSQL += "Left( ZZO.ZZO_TIPO, 1 ) <= '" + MV_PAR02 + "' AND ZZO_EMISSA >= '" + Dtos( MV_PAR03 ) + "' AND ZZO_EMISSA <= '" + Dtos( MV_PAR04 ) + "' AND "
cSQL += "ZZO.ZZO_CLIENT >= '" + MV_PAR05 + "' AND ZZO_CLIENT <= '" + MV_PAR06 + "' AND "
cSQL += "ZZO.ZZO_VEND >= '" + MV_PAR07 + "' AND ZZO_VEND <= '" + MV_PAR08 + "' AND "
cSQL += "ZZO.ZZO_TRANSP >= '" + MV_PAR09 + "' AND ZZO_TRANSP <= '" + MV_PAR10 + "' AND "
cSQL += "ZZO_FILIAL = '" + xFILIAL( "ZZO" ) + "' AND ZZP_FILIAL = '" + xFILIAL( "ZZP" ) + "' AND "
cSQL += "ZZP.D_E_L_E_T_ = '' AND ZZO.D_E_L_E_T_ = '' AND SA4.D_E_L_E_T_ = '' "
cSQL += "GROUP BY ZZO.ZZO_TRANSP,ZZP.ZZP_NUM,SA4.A4_NOME,ZZO.ZZO_TIPO "
cSQL += "ORDER BY ZZO.ZZO_TRANSP"

cSQL := ChangeQuery( cSQL )
Memowrit( "RTMK003.SQL", cSQL )
TCQUERY cSQL ALIAS ZZPX New
TcSetField( "ZZPX", "XVALOR",   "N", 10, 2 )
TcSetField( "ZZPX", "XPAGO",    "N", 10, 2 )
TcSetField( "ZZPX", "XNPAGO",   "N", 10, 2 )

aPRINT := {}
ZZPX->( DbGotop() )
Do While ! ZZPX->( Eof() )
   cTRANSP := ZZPX->ZZO_TRANSP
   aMAT    := {}
   cDESC   := ZZPX->A4_NOME
   nVALOR := nPAGO := nNPAGO := nRECL := 0
   Do While ZZPX->ZZO_TRANSP == cTRANSP
      nVALOR   += ZZPX->XVALOR
      nPAGO    += ZZPX->XPAGO
      nNPAGO   += ZZPX->XNPAGO
      nRECL++
      SX5->( DbSeek( "  ZS" + Padr( Left( ZZPX->ZZO_TIPO, 1 ), 6 ) ) )
      If Empty( nPOS := Ascan( aMAT, { |X| X[ 1 ] == Left( ZZPX->ZZO_TIPO, 1 ) } ) )
         Aadd( aMAT, { Left( ZZPX->ZZO_TIPO, 1 ), Left( SX5->X5_DESCRI, 30 ), 1 } )
      Else
         aMAT[ nPOS, 3 ]++
      EndIf
      ZZPX->( DbSkip() )
   EndDo
   Asort( aMAT,,, {| X, Y | Y[ 1 ] > X[ 1 ] } )
	Aadd( aPRINT, { cTRANSP, Left( cDESC, 30 ), nVALOR, nPAGO, nNPAGO, nRECL, aMAT } )
EndDo

          *          1         2         3         4         5         6         7         8         9        10        11        12        13
          *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
CABEC1 := "CODIGO  NOME                            VAL.TOTAL    VAL.PAGO  VAL.NEGADO  ATEND"
CABEC2 := ""
          *XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99  999,999.99  999,999.99   9999
          *XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX >>> 9999

nCONT := 1
Asort( aPRINT,,, {| X, Y | Y[ 3 ] < X[ 3 ] } )
Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 18 )
Do While nCONT <= Len( aPRINT )
   If Prow() > 60
      Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 18 )
   EndIf
   @ PROW() + 1, 000 PSAY aPRINT[ nCONT, 01 ]
   @ PROW()    , 008 PSAY aPRINT[ nCONT, 02 ]
   @ PROW()    , 039 PSAY aPRINT[ nCONT, 03 ] Picture "@E 999,999.99"
*   If nVALOR < 0
*      @ PROW() , 050 PSAY "-'
*   EndIf
   If aPRINT[ nCONT, 04 ] > 0
      @ PROW() , 051 PSAY aPRINT[ nCONT, 04 ] Picture "@E 999,999.99"
   EndIf
   If aPRINT[ nCONT, 05 ] > 0
      @ PROW() , 063 PSAY aPRINT[ nCONT, 05 ] Picture "@E 999,999.99"
   EndIf

   @ PROW()    , 076 PSAY aPRINT[ nCONT, 06 ] Picture "@E 9999"
   For nPOS := 1 To Len( aPRINT[ nCONT, 07 ] )
       @ PROW() + 1, 000 PSAY aPRINT[ nCONT, 07, nPOS, 1 ] + " - " + aPRINT[ nCONT, 07, nPOS, 2 ] + " >>> " + AllTrim( Trans( aPRINT[ nCONT, 07, nPOS, 3 ], "@E 9999" ) )
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
