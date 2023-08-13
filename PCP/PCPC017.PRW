#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Calcula Metas por maquina              º Data ³  04/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Relatorio de Producao versus Meta
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Eurivan MArques Candido                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
****************************************************************************
User Function PCPC017(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,lProjeta)
****************************************************************************

Local nOrdem
Local aDados := {}
Local nTurno
Local aProd
local nSub1
local nSub2
local nSub3
local cDtHrFim := ""
default lProjeta := .T.


cTURNO1   := GetMv("MV_TURNO1")
cTURNO2   := GetMv("MV_TURNO2")
cTURNO3   := GetMv("MV_TURNO3")
cTURNO1_A := Left(cTURNO1,5)+":00"
cTURNO2_A := Left(cTURNO2,5)+":00"
cTURNO3_A := Left(cTURNO3,5)+":00"

//fTurno(MV_PAR01) // Determina o turno pelo dia( seg. a sexta, sabado, domingo)

//if dow(MV_PAR01)=7 // SABADO
//    cDtHr3t  := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TS"), 1, 5 ) + ":00" ), 5 )+':00'
//elseif dow(MV_PAR01)=1 //domingo
//   cDtHr3t  := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TD"), 1, 5 ) + ":00" ), 5 )+':00'
//else
   cDtHr3t  := DtoS(MV_PAR01+1)+U_SubHora(cTURNO1_A,"00:00:01")
//endif


cQuery := "SELECT Z00.Z00_CODIGO, Z00.Z00_MAQ,Z00.Z00_LADO, "
cQuery += "MIN(Z00.Z00_DATHOR) AS Z00_DATHOR "
cQuery += "FROM "+RetSqlName("Z00")+" Z00 "
cQuery += "WHERE "
//cQuery += "Z00.Z00_DATHOR BETWEEN '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND '"+DtoS(MV_PAR01+1)+Left(cTURNO1,5)+"' "
//if dow(MV_PAR01)=7 // SABADO 
//   cQuery += "Z00.Z00_DATHOR BETWEEN '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND '"+DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TS"), 1, 5 ) + ":00" ), 5 )+"' "
//ELSEif dow(MV_PAR01)=1 // DOMINGO  
//   cQuery += "Z00.Z00_DATHOR BETWEEN '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND '"+DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TD"), 1, 5 ) + ":00" ), 5 )+"' "
//ELSE //SEG. A SEXTA
   cQuery += "Z00.Z00_DATHOR BETWEEN '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND '"+DtoS(MV_PAR01+1)+Left(U_SubHora(Left(cTURNO1,5),"00:01:00"),5)+"' "
//ENDIF
if !empty(mv_par02)
   cQuery += "AND Z00.Z00_MAQ = '"+MV_PAR02+"' "
endif   
cQuery += "AND Z00.Z00_CODIGO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
if !empty(mv_par05)
   cQuery += " AND Z00.Z00_LADO = '" + Alltrim(MV_PAR05) + "' "
endif
cQuery += "AND Z00.Z00_FILIAL = '"+xFilial("Z00")+"' "
cQuery += "AND Z00.D_E_L_E_T_ !='*' "
//cQuery += "AND Z00.Z00_MAQ <> 'XXX' "
cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA') "
cQuery += "AND Z00.Z00_OP <> '' "
cQuery += "AND Z00.Z00_CODIGO <> '' "                          
cQuery += "GROUP BY Z00.Z00_CODIGO, Z00.Z00_MAQ,Z00.Z00_LADO "
cQuery += "ORDER BY Z00_MAQ,Z00_LADO,Z00_DATHOR "

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "Z00X"

while !Z00X->(EOF())  
   cMaq  := Z00X->Z00_MAQ
   cLad  := Z00X->Z00_LADO
   cDtHr := DtoS(MV_PAR01)+cTURNO1_A //Inicio do dia
   cProd := Z00X->Z00_CODIGO
   while !Z00X->(EOF()) .AND. cMaq == Z00X->Z00_MAQ .AND. cLad == Z00X->Z00_LADO 
      //Pego a ultima pesagem anterior a primeira do dia selecionado
      cProA := pAnterior(cMaq,cLad,cDtHr)
      //Pego a meta de cProd2, a funcao converte a meta para unidade por segundo
      nM1 := mProduto(cProA, cMaq, cLad)      
      //Vetor com maquinas, lados e turnos
      nRegx := ASCAN(aDados, {|x| x[1]+x[2] == cMaq+cLad})     
      if nRegx = 0      
         Aadd(aDados,{cMaq,cLad,0,0,0})
         nRegx := Len(aDados)
      endif
      //Calculo o tempo decorrido em cada turno          
      aTurnos := tTurnos(cDtHr, Z00X->Z00_DATHOR+":00",MV_PAR01)          
      //Multiplico a meta em segundos, pelo tempo decorrido em segundos
      for _i := 1 to len(aTurnos)                
         nMT := aTurnos[_i] * nM1
         //divido por mil para converter em MR
         nMT := nMT/1000
         aDados[nRegx, 2+_i] += nMT
      next _i
      cDtHr := Z00X->Z00_DATHOR+":00"                  
      Z00X->(DbSkip())                
      cProd := Z00X->Z00_CODIGO           
   end


   //Testo se o sistema ira projetar a meta para 
   //os turnos ainda não concluidos
/*
   if ( cDtHr < DtoS(MV_PAR01+1)+cTURNO1_A )                      
      cDtHrFim := DtoS(MV_PAR01+1)+U_SubHora(cTURNO1_A,"00:00:01")    
      if !lProjeta .and. (DtoS(dDataBase)+Time()) < (DtoS(MV_PAR01+1)+cTURNO1_A)
         cDtHrFim := DtoS(dDataBase)+Time()
      endif
   endif
*/   

   if ( cDtHr <= cDtHr3t )                      
      cDtHrFim := cDtHr3t
      if !lProjeta .and. (DtoS(dDataBase)+Time()) <= cDtHr3t 
         cDtHrFim := DtoS(dDataBase)+Time()
      endif
   endif


   if !Empty(cDtHrFim)
	   //Calculo o tempo decorrido em cada turno
	   aTurnos := tTurnos( cDtHr, cDtHrFim,MV_PAR01 )
	   //Multiplico a meta em segundos, pelo tempo decorrido em segundos
	   for _i := 1 to len(aTurnos)
	      //Pego a ultima pesagem anterior a primeira do dia selecionado
	      cProA := pAnterior(cMaq,cLad,cDtHr)
	      //Pego a meta de cProd2, a funcao converte a meta para unidade por segundo
	      nM1 := mProduto(cProA, cMaq, cLad)
	      nMT := aTurnos[_i] * nM1
	      //divido por mil para converter em MR
	      nMT := nMT/1000
	      aDados[nRegx, 2+_i] += nMT
	   next _i
   endif
end

//Retorna vetor contendo metas por maquina, lado e turnos
Return aDados 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busco o produto, e o tempo decorrido da pesagem anterior até a atual   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
    static function pAnterior(cMaq, cLado, cDtHrIni)
************************************************ 
local cQuery
local cRet

cQuery := "SELECT TOP 1 Z00.Z00_CODIGO, MAX(Z00.Z00_DATHOR) AS Z00_DATHOR "
cQuery += "FROM "+RetSqlName("Z00")+" Z00 "
cQuery += "WHERE Z00.Z00_DATHOR < '"+cDtHrIni+"' "
cQuery += "AND Z00.Z00_MAQ = '"+cMaq+"' "
cQuery += "AND Z00.Z00_LADO = '"+cLado+"' "
cQuery += "AND Z00.Z00_FILIAL = '  ' "
cQuery += "AND Z00.D_E_L_E_T_ !='*' "
cQuery += "AND Z00.Z00_MAQ <> 'XXX' "
cQuery += "AND Z00.Z00_OP <> '' "
cQuery += "AND Z00.Z00_CODIGO <> '' "
cQuery += "GROUP BY Z00.Z00_CODIGO "
cQuery += "ORDER BY Z00_DATHOR DESC "

TCQUERY cQuery NEW ALIAS "Z00W"
//Retorno o Produto
cRet := Z00W->Z00_CODIGO

Z00W->(DbCloseArea())

return cRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busco a meta do produto, de acordo com a maquina e lado                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
static function mProduto(cProd, cMaq, cLado)
************************************************ 
local cQuery
local nMeta
cQuery := "SELECT ZB1_META "
cQuery += "FROM "+RetSqlName("ZB1")+" "
cQuery += "WHERE ZB1_FILIAL = '' AND ZB1_PROD = '"+cProd+"' "
cQuery += "AND ZB1_MAQ = '"+cMAQ+"' AND ZB1_LADO = '"+cLADO+"' "
cQuery += "AND D_E_L_E_T_ = '' "

TCQUERY cQuery NEW ALIAS "ZB1Y"

nMeta := (ZB1Y->ZB1_META*1000)/3600
ZB1Y->(DbCloseArea())

return nMeta


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico em turno a data passada nos parametros se encontra            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
//static function qTurno(cDataHora)
static function qTurno(cDataHora,MV_PAR01)
************************************************ 
Local nTurno:=0
Local cT1  := DtoS(MV_PAR01)+cTURNO1_A
Local cT2  := DtoS(MV_PAR01)+cTURNO2_A
Local cT31 := DtoS(MV_PAR01)+cTURNO3_A
LOCAL cT32 :=''
//If dow(MV_PAR01)=7// SABADO
//   cT32 := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TS"), 1, 5 ) + ":00" ), 5 )+":00"
//ELSEIf dow(MV_PAR01)=1 // DOMINGO 
//   cT32 := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TD"), 1, 5 ) + ":00" ), 5 )+":00"
//ELSE  // SEG. A DOMINGO 
   cT32 := DtoS(MV_PAR01+1)+cTURNO1_A
//END

if cDataHora >= cT1 .and. cDataHora < cT2
   nTurno := 1
elseif cDataHora >= cT2 .and. cDataHora < cT31
   nTurno := 2
elseif cDataHora >= cT31 .and. cDataHora < cT32
//elseif (cDataHora >= cT31) .and.  (iif( dow(MV_PAR01)=7 .OR. dow(MV_PAR01)=1 ,cDataHora <= cT32,cDataHora < cT32 ) ) 
   nTurno := 3
endif   

return nTurno


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo o tempo de "intervalo" no intervalo de horas.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
//static function tIntervalo(cDtHrIni,cDtHrFim)
static function tIntervalo(cDtHrIni,cDtHrFim,MV_PAR01)
************************************************ 

local cT1i1 := DtoS(MV_PAR01)+Left(GetMV("MV_TUR1INT"),5)+":00" //Inicio do Intervalo 1
local cT1i2 := DtoS(MV_PAR01)+Right(GetMV("MV_TUR1INT"),5)+":00" //Fim do Intervalo 1

local cT2i1 := DtoS(MV_PAR01)+Left(GetMV("MV_TUR2INT"),5)+":00" //Inicio do Intervalo 2
local cT2i2 := DtoS(MV_PAR01)+Right(GetMV("MV_TUR2INT"),5)+":00" //Fim do Intervalo 2

local cT3i1 :=DtoS(MV_PAR01+1)+Left(GetMV("MV_TUR3INT"),5)+":00" //Inicio do Intervalo 2
local cT3i2 :=DtoS(MV_PAR01+1)+Right(GetMV("MV_TUR3INT"),5)+":00" //Fim do Intervalo 2
local nTurno
local cT1
local cT2
local cInter := "00:00:00" 
/*
if dow(MV_PAR01)=7 // SABADO 
   return 0
elseif dow(MV_PAR01)=1 // domingo 
   return 0
endif
*/
nTurno := qTurno(cDtHrIni,MV_PAR01)
if nTurno = 1
   cT1 := cT1i1
   cT2 := cT1i2
elseif nTurno = 2
   cT1 := cT2i1
   cT2 := cT2i2
elseif nTurno = 3
   cT1 := cT3i1
   cT2 := cT3i2
endif   
 
if cDtHrIni >= cT2 .or. cDtHrFim <= cT1 //testo se o intervalo de horas, tá fora do intervalo do turno
   nInter := "00:00:00"
else
   cInter := ElapTime(Right(if(cDtHrIni<cT1,cT1,cDtHrIni),8),Right(if(cDtHrFim<cT2,cDtHrFim,cT2),8))
endif   

cInter := Val(Substr(cInter,1,2))*3600 + Val(Substr(cInter,4,2))*60 + Val(Substr(cInter,7,2))

return cInter


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Separa intervalo de horas em turnos. Retorna valores em segundos.      ³
//³Utilizado entre os avanços entre os turnos.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
//static function tTurnos(cDtHrIni, cDtHrFim)
static function tTurnos(cDtHrIni, cDtHrFim,MV_PAR01)
************************************************ 

local aTurnos := {0,0,0}                                
local cDtIniX

local cT11  := DtoS(MV_PAR01)+cTURNO1_A
local cT12  := DtoS(MV_PAR01)+U_SubHora(cTURNO2_A,"00:00:01")

local cT21  := DtoS(MV_PAR01)+cTURNO2_A
local cT22  := DtoS(MV_PAR01)+U_SubHora(cTURNO3_A,"00:00:01")

local cT31  := DtoS(MV_PAR01)+cTURNO3_A
//local cT32  := DtoS(MV_PAR01+1)+U_SubHora(cTURNO1_A,"00:14:59")
local cT32  :=''

//if dow(MV_PAR01)=7 // SABADO
//    cT32  := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TS"), 1, 5 ) + ":00" ), 5 )+':00'
//elseif dow(MV_PAR01)=1 //domingo
//   cT32  := DtoS(MV_PAR01)+Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( GetMv("MV_DURC3TD"), 1, 5 ) + ":00" ), 5 )+':00'
//else
   cT32  := DtoS(MV_PAR01+1)+U_SubHora(cTURNO1_A,"00:00:01")
//endif



//Verifico em que turno estão os intervalos de tempo
nTIni := 0
nTFim := qTurno(cDtHrFim,MV_PAR01)
//testo se os intervalos invadem turnos seguintes
while nTIni <= nTFim
   nTIni := qTurno(cDtHrIni,MV_PAR01)
   if nTFim = 3      
      cDtIniX := if(cDtHrIni>cT31,cDtHrIni,cT31)
      //calculo o tempo decorrido da primeira pesagem para o inicio do turno        
      //Testo se a data e hora inicial é maior que o inicio do turno
      nTAx := ElapTime( Right(cDtIniX,8),Right(cDtHrFim,8) )          
      //Converto tudo para segundos
      nTAx := Val(Substr(nTAx,1,2))*3600 + Val(Substr(nTAx,4,2))*60 + Val(Substr(nTAX,7,2))
      //Calculo o intervalo
      nInter := tIntervalo(cDtIniX,cDtHrFim,MV_PAR01)
      //Subtraio o intervalo
      nTax -= nInter
      
      aTurnos[3] := nTAx
      cDtHrFim := cT22 //Final do turno anterior
      nTFim := qTurno(cDtHrFim,MV_PAR01)
   elseif nTFim = 2
      cDtIniX := if(cDtHrIni>cT21,cDtHrIni,cT21)
      //calculo o tempo decorrido da primeira pesagem para o inicio do turno
      //Testo se a data e hora inicial é maior que o inicio do turno
      nTAx := ElapTime( Right(cDtIniX,8),Right(cDtHrFim,8) )
      //Converto tudo para segundos
      nTAx := Val(Substr(nTAx,1,2))*3600 + Val(Substr(nTAx,4,2))*60 + Val(Substr(nTAx,7,2))     
      //Calculo o intervalo
      nInter := tIntervalo(cDtIniX,cDtHrFim,MV_PAR01)
      //Subtraio o intervalo
      nTax -= nInter

      aTurnos[2] := nTAx
      cDtHrFim := cT12  //Final do turno anterior
      nTFim := qTurno(cDtHrFim,MV_PAR01)
   elseif nTFim = 1
      cDtIniX := if(cDtHrIni>cT11,cDtHrIni,cT11)
      //calculo o tempo decorrido da primeira pesagem para o inicio do turno
      //Testo se a data e hora inicial é maior que o inicio do turno
      nTAx := ElapTime( Right(cDtIniX,8),Right(cDtHrFim,8) )
      //Converto tudo para segundos
      nTAx := Val(Substr(nTAx,1,2))*3600 + Val(Substr(nTAx,4,2))*60 + Val(Substr(nTAx,7,2))
      //Calculo o intervalo
      nInter := tIntervalo(cDtIniX,cDtHrFim,MV_PAR01)
      //Subtraio o intervalo
      nTax -= nInter

      aTurnos[1] := nTAx
      cDtHrFim := cT32  //Final do turno anterior
      nTFim := -1 //qTurno(cDtHrFim)
   endif      
end

return aTurnos

*******************************************
user function SubHora( _cHora1, _cHora2 )
*******************************************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_nRs3,_cRes

_nHr1 := Val(Subst(_cHora1,1,2))
_nMi1 := Val(Subst(_cHora1,4,2))
_nSg1 := Val(Subst(_cHora1,7,2))

_nHr2 := Val(Subst(_cHora2,1,2))
_nMi2 := Val(Subst(_cHora2,4,2))
_nSg2 := Val(Subst(_cHora2,7,2))

_nRs3 := _nSg1 - _nSg2
if _nRs3 < 0
	_nRs3 := _nRs3 + 60
	_nMi1--
endif

_nRs2 := _nMi1 - _nMi2
if _nRs2 < 0
	_nRs2 := _nRs2 + 60
	_nHr1--
endif

_nRs1 := _nHr1 - _nHr2
if _nRs1 < 0
	_nRs1 := _nRs1 + 24
endif
_cRes := StrZero(_nRs1,2)+":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)

Return(_cRes)


***************

Static Function fTurno(dData)

***************

if dow(dData)=7 // sabado
	cTURNO1   := GetMv("MV_TURNO1S")
	cTURNO2   := GetMv("MV_TURNO2S")
	cTURNO3   := GetMv("MV_TURNO3S")
	cTURNO1_A := Left(cTURNO1,5)+":00"
	cTURNO2_A := Left(cTURNO2,5)+":00"
	cTURNO3_A := Left(cTURNO3,5)+":00"
elseif dow(dData)=1 // domingo
	cTURNO1   := GetMv("MV_TURNO1D")
	cTURNO2   := GetMv("MV_TURNO2D")
	cTURNO3   := GetMv("MV_TURNO3D")
	cTURNO1_A := Left(cTURNO1,5)+":00"
	cTURNO2_A := Left(cTURNO2,5)+":00"
	cTURNO3_A := Left(cTURNO3,5)+":00"
else // seg. a sexta
	cTURNO1   := GetMv("MV_TURNO1")
	cTURNO2   := GetMv("MV_TURNO2")
	cTURNO3   := GetMv("MV_TURNO3")
	cTURNO1_A := Left(cTURNO1,5)+":00"
	cTURNO2_A := Left(cTURNO2,5)+":00"
	cTURNO3_A := Left(cTURNO3,5)+":00"
endif


Return 