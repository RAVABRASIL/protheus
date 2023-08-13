#INCLUDE "rwmake.CH"
#INCLUDE "topconn.CH"

********************

User Function IMPALM1(aArray)

********************

aArray  :={{'GUB290',1,'20071016'},;
           {'ADC145',1,'20071016'},;
           {'ADC145',1,'20071016'},;
           {'ADC145',1,'20071016'},;
           {'ADC145',1,'20071016'},;
           {'ADC145',1,'20071016'},;
           {'GUB290',2,'20071016'},;
           {'CDB114',1,'20071016'}}

aArray  := aSort(aArray,,, { | x, y | x[ 1 ] < y[ 1 ] } )
aTot   := {}
cProd   := aArray[1][1]
nX      := 1
nQuant  := 0
cDoc    := soma1( ultimo() )
lTeste  := .T.

DO While nX <= len(aArray) + 1

  IF nX <= len(aArray) .AND. cProd == aArray[nX][1]
    nQuant += aArray[nX][2]
    cData  := aArray[nX][3]
  Else
    aAdd( aTot, { cProd, nQuant, cData } )
    IF nX <= len(aArray)
      cProd  := aArray[nX][1]
      nQuant := aArray[nX][2]
      cData  := aArray[nX][3]
    EndIf
  ENDIF

  nX++
EndDO

Begin Transaction
FOR nY := 1 TO len( aTot )
  if !gravaB7( aTot[nY], cDoc )
    DisarmTransaction()
    Return .F.
  endif
NEXT
End Transaction

Return .T.

***************

Static Function ultimo()

***************

local cQuery := "select max(B7_DOC) DOC from SB7020 where B7_FILIAL = '01' and D_E_L_E_T_ != '*' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
cDoc := TMP->DOC
TMP->( dbCloseArea() )

Return cDoc

***************

Static Function gravaB7( aArray, cDoc )

***************

  lMsHelpAuto := .T.
  lMsErroAuto := .F.
  dbSelectArea('SB1')
  SB1->( dbSetOrder(1) )
  SB1->( dbSeek( xFilial('SB1')+aArray[1], .T. ) )

  aVetor:={ {"B7_COD",aArray[1],NIL},;
            {"B7_LOCAL",SB1->B1_LOCPAD,NIL},;
            {"B7_TIPO",SB1->B1_TIPO,NIL},;
            {"B7_DOC",cDoc,NIL},;
            {"B7_QUANT",aArray[2],NIL},;
            {"B7_QTSEGUM",IIF( SB1->B1_TIPCONV == 'M', aArray[2] * SB1->B1_CONV, aArray[2]/SB1->B1_CONV ),NIL},;
            {"B7_DATA",stod(aArray[3]),NIL} }
  //MSExecAuto({|x,y| mata270(x,y)},aVetor,3) //Inclusao
  MSExecAuto({|x| mata270(x)},aVetor)
  SB1->( dbCloseArea() )

Return lMsErroAuto
