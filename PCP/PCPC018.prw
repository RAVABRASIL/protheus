#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"


**************************************************************************
User Function PCPC018(dData1,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,lProjeta)
**************************************************************************

/*
MV_PAR01 - DATA
MV_PAR02 - MAQUINA
MV_PAR03 - PRODUTO DE 
MV_PAR04 - PRODUTO ATE
MV_PAR05 - LADO DA MAQUINA
lProjeta - PROJETA META 
*/

local aDados  := {}
local cQuery  := ""
local cMAQ    := ""
local cLADO	  := ""
local aMetas  := {} 
local aAparas := {}
local aTotais := {0,0,0,0, 0,0,0,0, 0,0,0,0}
local aTotP   := {}   
local dData1  := STOD(dData1)

//local lProjeta := MV_PAR06 == 1

RPCSetType( 3 ) // Não consome licensa de uso
RpcSetEnv('02','01',,,,GetEnvServer(),{"SF4"})  // atencao para esta linha.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cTURNO1 := GetMv("MV_TURNO1")
Private cTURNO2 := GetMv("MV_TURNO2")
Private cTURNO3 := GetMv("MV_TURNO3")

cTURNO1_A := Left(cTURNO1,5)+":00"
cTURNO2_A := Left(cTURNO2,5)+":00"
cTURNO3_A := Left(cTURNO3,5)+":00"

cQuery := "SELECT ZZ2.ZZ2_LADO,ZZ2.ZZ2_PROD,ZZ2.ZZ2_OP,ZZ2.ZZ2_MAQ,ZZ2.ZZ2_QUANT,"
cQuery += "ZZ2_DATHOR=ZZ2.ZZ2_DATA+ZZ2_HORA,ZZ2.ZZ2_QUANT "
cQuery += "FROM "+RetSqlName("ZZ2")+" ZZ2 "
cQuery += " WHERE "
cQuery += "ZZ2.ZZ2_DATA+ZZ2.ZZ2_HORA BETWEEN '"+DTOS(dData1)+Left(cTURNO1,5)+"' AND '"+DTOS(dData1+1)+Left(U_SubHora(Left(cTURNO1,5),"00:01:00"),5)+"' "
if !empty(mv_par02)
   cQuery += "AND ZZ2.ZZ2_MAQ = '"+MV_PAR02+"' "
endif   
cQuery += "AND ZZ2.ZZ2_PROD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
if !empty(mv_par05)
   cQuery += " AND ZZ2.ZZ2_LADO = '" + Alltrim(MV_PAR05) + "' "
endif
cQuery += "AND ZZ2.ZZ2_FILIAL = '"+xFilial("ZZ2")+"' "
cQuery += "AND ZZ2.D_E_L_E_T_ = '' "
cQuery += "AND ZZ2.ZZ2_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA') "
cQuery += "AND ZZ2.ZZ2_OP <> '' "
cQuery += "AND ZZ2.ZZ2_PROD <> '' "
cQuery += "ORDER BY ZZ2.ZZ2_MAQ, ZZ2_LADO, ZZ2.ZZ2_DATA, ZZ2_HORA, ZZ2.ZZ2_PROD "

if select("ZZ2X0") > 0
	DbSelectArea("ZZ2X0")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "ZZ2X0"

DbselectArea("ZZ2X0")
ZZ2X0->( DBGoTop() )

//Busco as metas atraves da funcao abaixo
aMetas := U_PCPC017(dData1,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,lProjeta)

//Busco aparas por maquina atraves da funcao abaixo
aAparas := GetAparas(dData1)
//aAparas 1=Maq, 2=Apara1, 3=Apara2, 4=Apara3

if  !ZZ2X0->( Eof() )  
	while !ZZ2X0->( Eof() )  
	   cMAQ  := ZZ2X0->ZZ2_MAQ
	   aTotP := {0,0,0}
	   while !ZZ2X0->( Eof() ) .and. ZZ2X0->ZZ2_MAQ == cMAQ
	      cLado := ZZ2X0->ZZ2_LADO   
	      nMeta := aScan( aMetas, {|x| x[1]+x[2] == cMaq + cLado } )
	                    //Maq, Lado  ProdMR  %Apara  Metas  ProdKG  AparaKG  %t1,%t2,%t3
	      Aadd( aDados, { cMaq,clado, 0,0,0,  0,0,0, 0,0,0, 0,0,0,  0,0,0   ,0,0,0      } )
	      if nMeta > 0
	         aDados[Len(aDados),09] := aMetas[nMeta,3]//Meta Turno1
	         aDados[Len(aDados),10] := aMetas[nMeta,4]//Meta Turno2
	         aDados[Len(aDados),11] := aMetas[nMeta,5]//Meta Turno3
	      endif
	
	      while !ZZ2X0->( Eof() ) .and. ZZ2X0->ZZ2_MAQ == cMAQ .and. ZZ2X0->ZZ2_LADO == cLado
	         nTurno := qTurno(ZZ2X0->ZZ2_DATHOR+":00",dData1)
	         //ConOut("5-que turno"+str(nTurno) )
	         
	         //Acumulo a quantidade produzida em MR
	         aDados[Len(aDados),02+nTurno] += 0 //ZZ2X0->ZZ2_QUANT/1000
	         //Acumulo a quantidade produzida em Kg         
	         aDados[Len(aDados),11+nTurno] += ZZ2X0->ZZ2_QUANT
	         aTotP[nTurno] += ZZ2X0->ZZ2_QUANT
	         Dbselectarea("ZZ2X0")
	   	     ZZ2X0->( DbSkip() )
	      end
	      // % 
	        iif(aDados[Len(aDados),09]!=0,aDados[Len(aDados),18]:=Round((aDados[Len(aDados),3]/aDados[Len(aDados),09])*100, 2 ),0)     // % t1
	        iif(aDados[Len(aDados),10]!=0,aDados[Len(aDados),19]:=Round((aDados[Len(aDados),4]/aDados[Len(aDados),10])*100, 2 ),0)     // % t2
	        iif(aDados[Len(aDados),11]!=0,aDados[Len(aDados),20]:=Round((aDados[Len(aDados),5]/aDados[Len(aDados),11])*100, 2 ),0)     // % t3
	      //
	   end
	   
	   nApara := aScan( aAparas, {|x| x[1] == cMaq } )
	   if nApara > 0                 //Peso Apara     /  Peso Apara      +  Peso Producao
	      aDados[Len(aDados),06] := (aAparas[nApara,2]/(aAparas[nApara,2]+aTotP[1]))*100 //% Apara Turno1
	      aDados[Len(aDados),07] := (aAparas[nApara,3]/(aAparas[nApara,3]+aTotP[2]))*100 //% Apara Turno2
	      aDados[Len(aDados),08] := (aAparas[nApara,4]/(aAparas[nApara,4]+aTotP[3]))*100 //% Apara Turno3
	      //Peso da Apara, sera utilizado no calculo dos totais
	      aDados[Len(aDados),15] := aAparas[nApara,2]
	      aDados[Len(aDados),16] := aAparas[nApara,3]
	      aDados[Len(aDados),17] := aAparas[nApara,4]
	   endif
	   aTotP := {}
	enddo
else
                   //Maq, Lado  ProdMR  %Apara  Metas  ProdKG  AparaKG  %t1,%t2,%t3
    Aadd( aDados, {'' ,'', 0,0,0,  0,0,0, 0,0,0, 0,0,0,  0,0,0   ,0,0,0      } )

endif

ZZ2X0->( DbCloseArea() )

return aDados    // VETOR COM TODAS AS INFORMACOES DA MAQUINA 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico em turno a data passada nos parametros se encontra            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

************************************************
static function qTurno(cDataHora,dData1)
************************************************ 
local nTurno
local cT1  := DTOS(dData1)+cTURNO1_A
local cT2  := DTOS(dData1)+cTURNO2_A
local cT31 := DTOS(dData1)+cTURNO3_A
local cT32 := DTOS(dData1+1)+cTURNO1_A

if cDataHora >= cT1 .and. cDataHora < cT2
   nTurno := 1
elseif cDataHora >= cT2 .and. cDataHora < cT31
   nTurno := 2
elseif cDataHora >= cT31 .and. cDataHora < cT32
   nTurno := 3
endif   

return nTurno


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apara por Maquina x Turno                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
static function GetAparas(dData1)
************************************************ 
local cQuery
local aAparas := {}
local nTurno
local cMaq

cQuery := "SELECT Z00.Z00_MAQ,Z00.Z00_LADO,SUM(Z00.Z00_PESO) AS Z00_PESO,Z00.Z00_DATHOR "
cQuery += "FROM "+RetSqlName("Z00")+" Z00 "
cQuery += "WHERE Z00.Z00_DATHOR BETWEEN '"+DTOS(dData1)+Left(cTURNO1,5)+"' AND '"+DTOS(dData1+1)+Left(U_SubHora(Left(cTURNO1,5),"00:01:00"),5)+"' "      
//cQuery += "WHERE Z00.Z00_DATHOR between '2011110705:50' AND '2011110705:49' "

cQuery += "AND Z00.Z00_FILIAL = '"+xFilial("Z00")+"' AND Z00.D_E_L_E_T_ = '' AND Z00.Z00_APARA NOT IN (' ','W') "
cQuery += "GROUP BY Z00.Z00_MAQ,Z00.Z00_LADO,Z00.Z00_DATHOR "
cQuery += "ORDER BY Z00.Z00_MAQ, Z00_LADO, Z00.Z00_DATHOR "

if select("Z010") > 0
   DbSelectArea("Z010")
   DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "Z010"
DbselectArea("Z010")

while !Z010->( Eof() )  
   cMAQ  := Z010->Z00_MAQ
   Aadd( aAparas, {cMaq,0,0,0} )
   while !Z010->( Eof() ) .and. Z010->Z00_MAQ == cMAQ
      nTurno := qTurno(Z010->Z00_DATHOR+":00",dData1)
      aAparas[len(aAparas),1+nTurno] += Z010->Z00_PESO
      Dbselectarea("Z010")
 	  Z010->( DbSkip() )
   end
end
Z010->( DbCloseArea() )

return aAparas