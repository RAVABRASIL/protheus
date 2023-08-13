#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPR015V2 ºAutor  ³Eurivan Marques     º Data ³  11/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Metas versus Realizado na produção por máquina.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Produção                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*************************
User Function PCPR15V3()
*************************

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

tamanho   := "G"
titulo    := "% de utilizacao de maquina C/S"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de producao em relacao a meta, "
cDesc3    := "por maquina e turno."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "PCPR015V3"
cPerg     := "PCPR15V3 "
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "PCPR015V3"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .T. )               // Pergunta no SX1
	
cString := "Z00"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RptDetail()}) 

Return


***************************
Static Function RptDetail()     
***************************
local aDados  := {}
local cQuery  := ""
local cMAQ    := ""
local cLADO	  := ""
local aMetas  := {} 
local aAparas := {}
local aTotais := {0,0,0,0, 0,0,0,0, 0,0,0,0}
local aTotP   := {}
local lProjeta := MV_PAR07 == 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Foi criada funcao fTurno para os dias de seg. a sexta,sabado,domingo 
Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")

cTURNO1_A := Left(cTURNO1,5)+":00"
cTURNO2_A := Left(cTURNO2,5)+":00"
cTURNO3_A := Left(cTURNO3,5)+":00"

Cabec1 := "       /-------------------T U R N O 1 --------------------\/-------------------T U R N O 2 ---------------------\/-------------------T U R N O 3 ---------------------\/-------------------T O T A L ---------------------\"
Cabec2 := "MAQ  L    META          REAL    EFIC(MR)  EFIC(%) APARA(%)       META        REAL    EFIC(MR)  EFIC(%) APARA(%)       META        REAL     EFIC(MR) EFIC(%) APARA(%)        META        REAL     EFIC(MR) EFIC(%) APARA(%) 
Cabec3 := ""      
//         XXXXXX X  999,999.99  999,999.99  999,999.99   999.99   999.99  999,999.99  999,999.99  999,999.99   999.99   999.99  999,999.99  999,999.99  999,999.99  999.99   999.99
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        

mPag := 1

TITULO := AllTrim( TITULO ) + " - De:" + Dtoc( MV_PAR01 ) + " Ate:" + Dtoc( MV_PAR02 )

if !empty(MV_PAR06)
   titulo += " - LADO: " + mv_par06
endif

titulo += " - "+if(lProjeta,"COM","SEM")+" Projeção de Meta"

dDataDe:=MV_PAR01
dDataATe:=MV_PAR02
ndia:=(MV_PAR02-MV_PAR01)+1
Do While  dDataDe <=dDataATe
// RETIRADO APOS MUDANCA NO HORARIO  A PEDIDO DE ROBINSON 
//    fTurno(dDataDe) // funcao que deternina o turno

	cQuery := "SELECT Z00.Z00_LADO,Z00.Z00_CODIGO,Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,"
	cQuery += "Z00_APARA,Z00.Z00_DATHOR,Z00.Z00_QUANT, "
	cQuery += "Z00.Z00_PESCAP,Z00.Z00_PESDIF "
	cQuery += "FROM "+RetSqlName("Z00")+" Z00 "
	cQuery += " WHERE "
	cQuery += "Z00.Z00_DATHOR BETWEEN '"+DtoS(dDataDe)+Left(cTURNO1,5)+"' AND '"+DtoS(dDataDe+1)+Left(U_SubHora(Left(cTURNO1,5),"00:01:00"),5)+"' "
	if !empty(mv_par03)
	   cQuery += "AND Z00.Z00_MAQ = '"+MV_PAR03+"' "
	endif   
	cQuery += "AND Z00.Z00_CODIGO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	if !empty(mv_par06)
	   cQuery += " AND Z00.Z00_LADO = '" + Alltrim(MV_PAR06) + "' "
	endif
	cQuery += "AND Z00.Z00_FILIAL = '"+xFilial("Z00")+"' "
	cQuery += "AND Z00.D_E_L_E_T_ = '' "
//	cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT') "
    cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA','COST') "
	//cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA') "
	cQuery += "AND Z00.Z00_OP <> '' "
	cQuery += "AND Z00.Z00_CODIGO <> '' "
	cQuery += "ORDER BY Z00.Z00_MAQ, Z00_LADO, Z00.Z00_DATHOR, Z00.Z00_CODIGO "
	
	if select("Z00X0") > 0
		DbSelectArea("Z00X0")
		DbCloseArea()
	endif
	
	TCQUERY cQuery NEW ALIAS "Z00X0"
	
	DbselectArea("Z00X0")
	Z00X0->( DBGoTop() )
	
	//SetRegua( Lastrec() )
	SetRegua( 0 )
	
	//1-Data,2-Maq,3-Prod. de,4-Prod. ate,5-Lado,6-Projeta
	//Busco as metas atraves da funcao abaixo
	aMetas := U_PCPC017(dDataDe,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,lProjeta)
	//aMetas 1=Maq, 2=Lado, 3=Meta1, 4=Meta2, 5=Meta3
	
	//Busco aparas por maquina atraves da funcao abaixo
	aAparas := GetAparas(dDataDe)
	//aAparas 1=Maq, 2=Apara1, 3=Apara2, 4=Apara3
	
	while !Z00X0->( Eof() )  
	   cMAQ  := Z00X0->Z00_MAQ
	   aTotP := {0,0,0}
	   while !Z00X0->( Eof() ) .and. Z00X0->Z00_MAQ == cMAQ
	      cLado := Z00X0->Z00_LADO   
	      nMeta := aScan( aMetas, {|x| x[1]+x[2] == cMaq + cLado } )
	      nDados:= aScan( aDados, {|x| x[1]+x[2] == cMaq + cLado } )
	      If nDados=0
	                        //Maq, Lado  ProdMR  %Apara  Metas  ProdKG  AparaKG
	         Aadd( aDados, { cMaq,clado, 0,0,0,  0,0,0, 0,0,0, 0,0,0,  0,0,0 } )
	         nDados :=aScan( aDados, {|x| x[1]+x[2] == cMaq + cLado } )
	      EndIf
	      
	      if nMeta > 0
	         aDados[nDados,09] += aMetas[nMeta,3]//Meta Turno1
	         aDados[nDados,10] += aMetas[nMeta,4]//Meta Turno2
	         aDados[nDados,11] += aMetas[nMeta,5]//Meta Turno3
	      endif
	
	      while !Z00X0->( Eof() ) .and. Z00X0->Z00_MAQ == cMAQ .and. Z00X0->Z00_LADO == cLado
	         nTurno := qTurno(Z00X0->Z00_DATHOR+":00",dDataDe)
	         //Acumulo a quantidade produzida em MR
	         aDados[nDados,02+nTurno] += Z00X0->Z00_QUANT/1000
	         //Acumulo a quantidade produzida em Kg         
	         aDados[nDados,11+nTurno] += Z00X0->Z00_PESO+Z00X0->Z00_PESCAP                 
	         aTotP[nTurno] += Z00X0->Z00_PESO + Z00X0->Z00_PESCAP
	         Dbselectarea("Z00X0")
	   	     Z00X0->( DbSkip() )
	         IncRegua()
	      end
	   end
	   
	   nApara := aScan( aAparas, {|x| x[1] == cMaq } )
	   if nApara > 0                 //Peso Apara     /  Peso Apara      +  Peso Producao
	      aDados[nDados,06] += (aAparas[nApara,2]/(aAparas[nApara,2]+aTotP[1]))*100 //% Apara Turno1
	      aDados[nDados,07] += (aAparas[nApara,3]/(aAparas[nApara,3]+aTotP[2]))*100 //% Apara Turno2
	      aDados[nDados,08] += (aAparas[nApara,4]/(aAparas[nApara,4]+aTotP[3]))*100 //% Apara Turno3
	      //Peso da Apara, sera utilizado no calculo dos totais
	      aDados[nDados,15] += aAparas[nApara,2]
	      aDados[nDados,16] += aAparas[nApara,3]
	      aDados[nDados,17] += aAparas[nApara,4]
	   endif
	   
	   aTotP := {}
	EndDo
    dDataDe+=1
EndDo
Z00X0->( DbCloseArea() )

nLin := 80; cMAq := " "
aDados := Asort( aDados,,, { |X,Y| X[1]+X[2]<Y[1]+Y[2] } )
for _i := 1 to len(aDados)
   cMaq := aDados[_i,1]   
   if nLin > 55
      nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 1
   endif
   @ nLin, 000 PSAY aDados[_i,1] //Maquina
   @ nLin, 006 PSAY aDados[_i,2] //Lado
//   nColMeta := 10; nColReal := 22; nColDif := 34; nColDifP := 47; nColApar := 56; nColBar := 63
     nColMeta := 7; nColReal := 19; nColDif := 31; nColDifP := 43; nColApar := 51; nColBar := 59
   _z := 1
   nTotM:=0 ; nTotR:=0 ; nTotDIF:=0 ; nTotDIFP:=0 ; nTotAPA:=0
   for _j := 1 to 3 //para os 3 turnos
      if aDados[_i,2+_j]=0 // realizado zerado meta zerado
         aDados[_i,8+_j]:=0
      Endif
      @ nLin, nColMeta PSAY aDados[_i,8+_j]                       Picture "@E 999,999.99" //Meta
      @ nLin, nColReal PSAY aDados[_i,2+_j]                       Picture "@E 999,999.99" //Realizado
      @ nLin, nColDif  PSAY aDados[_i,2+_j]-aDados[_i,8+_j]       Picture "@E 999,999.99" //Diferença	   	
      @ nLin, nColDifP PSAY (aDados[_i,2+_j]/aDados[_i,8+_j])*100 Picture "@E 999.99"     //Dif %
      @ nLin, nColApar PSAY aDados[_i,5+_j]                       Picture "@E 999.99"	  //Apara %
      @ nLin, nColBar  PSAY "|"	  //Barra Vertical
      // TOTAL SOMATORIO 3 TURNOS 
         nTotM+=aDados[_i,8+_j] //Meta
         nTotR+=aDados[_i,2+_j] //Realizado
         nTotDIF+=aDados[_i,2+_j]-aDados[_i,8+_j] //Diferença	   	
         nTotDIFP+=(aDados[_i,2+_j]/aDados[_i,8+_j])*100 //Dif %
         nTotAPA+=aDados[_i,5+_j] //% Apara
       //
      //Incremento as colunas
        nColMeta += 54; nColReal += 54; nColDif += 54; nColDifP += 54; nColApar += 54; nColBar += 54
      //Atualizo o array de totais (somente se a Meta for maior que zero. SOLICITADO POR MARCELO)
      if aDados[_i,8+_j] > 0
         aTotais[_z] += aDados[_i,8+_j] //Total Meta
         aTotais[_z+1] += aDados[_i,2+_j] //Total Realizado
         aTotais[_z+2] += aDados[_i,11+_j] //Total Peso Produzido
         aTotais[_z+3] += aDados[_i,14+_j] //Total Peso Apara
      endif   
      _z+=4
   next _j
   // totais somatorios 3 turnos      
      @ nLin, nColMeta PSAY  nTotM     Picture "@E 999,999.99" //Meta
      @ nLin, nColReal PSAY  nTotR     Picture "@E 999,999.99" //Realizado
      @ nLin, nColDif  PSAY  nTotDIF   Picture "@E 999,999.99" //Diferença	   	
      @ nLin, nColDifP PSAY  (nTotR/nTotM)*100  Picture "@E 999.99"     //Dif %
      @ nLin, nColApar PSAY  nTotAPA   Picture "@E 999.99"	  //Apara %
   //
   nLin ++ 
   if (_i+1) <= Len(aDados) 
      if cMaq != aDados[_i+1,1]
         //@ nLin, 063 PSAY "|"; @ nLin, 063+54 PSAY "|";  @ nLin, 063+54+54 PSAY "|"; nLin++
           @ nLin, 059 PSAY "|"; @ nLin, 059+54 PSAY "|";  @ nLin, 059+54+54 PSAY "|"; nLin++
      endif   
   endif
next _i		 

@ nLin,000 PSAY REPLICATE("_",220); nLin++
@ nLin,000 PSAY "TOTAL"
//_z := 1; nColMeta := 10; nColReal := 22; nColDif := 34; nColDifP := 47; nColApar := 56
_z := 1;nColMeta := 7; nColReal := 19; nColDif := 31; nColDifP := 43; nColApar := 51; nColBar := 59
nTotM:=0 ; nTotR:=0 ; nTotDIF:=0 ; nTotDIFP:=0 ; nTotAPA:=0
for _j := 1 to 3 //para os 3 turnos
   @ nLin, nColMeta PSAY aTotais[_z]                                        Picture "@E 999,999.99" //Meta
   @ nLin, nColReal PSAY aTotais[_z+1]                                      Picture "@E 999,999.99" //Realizado
   @ nLin, nColDif  PSAY aTotais[_z+1]-aTotais[_z]                          Picture "@E 999,999.99"	//Diferença	   	
   @ nLin, nColDifP PSAY (aTotais[_z+1]/aTotais[_z])*100                    Picture "@E 999.99" //Dif %
   @ nLin, nColApar PSAY (aTotais[_z+3]/(aTotais[_z+3]+aTotais[_z+2]))*100  Picture "@E 999.99" //% Apara
   // TOTAL SOMATORIO 3 TURNOS 
      nTotM+=aTotais[_z] //Meta
      nTotR+=aTotais[_z+1] //Realizado
      nTotDIF+=aTotais[_z+1]-aTotais[_z] //Diferença	   	
      nTotDIFP+=(aTotais[_z+1]/aTotais[_z])*100 //Dif %
      nTotAPA+=(aTotais[_z+3]/(aTotais[_z+3]+aTotais[_z+2]))*100 //% Apara
   //
   nColMeta += 54; nColReal += 54; nColDif += 54; nColDifP += 54; nColApar += 54
   _z+=4
next _j

// TOTAL  somatorio dos 3 turnos		
@ nLin, nColMeta PSAY nTotM    Picture "@E 999,999.99" //Meta
@ nLin, nColReal PSAY nTotR    Picture "@E 999,999.99" //Realizado
@ nLin, nColDif  PSAY nTotDIF  Picture "@E 999,999.99"	//Diferença
@ nLin, nColDifP PSAY (nTotR/nTotM)*100 Picture "@E 999.99" //Dif %
@ nLin, nColApar PSAY  nTotAPA Picture "@E 999.99" //% Apara
//
Roda(0,"",TAMANHO)

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
endif

return nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico em turno a data passada nos parametros se encontra            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
************************************************
static function qTurno(cDataHora,dDataDe)
************************************************ 
local nTurno
local cT1  := DtoS(dDataDe)+cTURNO1_A
local cT2  := DtoS(dDataDe)+cTURNO2_A
local cT31 := DtoS(dDataDe)+cTURNO3_A
local cT32 := DtoS(dDataDe+1)+cTURNO1_A

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
static function GetAparas(dDataDe)
************************************************ 
local cQuery
local aAparas := {}
local nTurno
local cMaq

cQuery := "SELECT Z00.Z00_MAQ,Z00.Z00_LADO,SUM(Z00.Z00_PESO) AS Z00_PESO,Z00.Z00_DATHOR "
cQuery += "FROM "+RetSqlName("Z00")+" Z00 "
cQuery += "WHERE Z00.Z00_DATHOR BETWEEN '"+DtoS(dDataDe)+Left(cTURNO1,5)+"' AND '"+DtoS(dDataDe+1)+Left(U_SubHora(Left(cTURNO1,5),"00:01:00"),5)+"' "
cQuery += "AND Z00.Z00_FILIAL = '"+xFilial("Z00")+"' AND Z00.D_E_L_E_T_ = '' AND Z00.Z00_APARA NOT IN (' ','W') "  
cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA') "
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
      nTurno := qTurno(Z010->Z00_DATHOR+":00",dDataDe)
      aAparas[len(aAparas),1+nTurno] += Z010->Z00_PESO
      Dbselectarea("Z010")
 	  Z010->( DbSkip() )
   end
end
Z010->( DbCloseArea() )

return aAparas

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