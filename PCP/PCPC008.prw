#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "fivewin.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPC008   ºAutor  ³Microsiga           º Data ³  04/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

***************************************************************************
User Function PCPC008(cMaqui,cLadoA,cLadoB,cSta0,cSta1,dDataI,dDataF,lAuto)
***************************************************************************

//Local nOrdem
local cQry := ''
local aRet := {}
local cTURNO1 := cTURNO2 := cTURNO3 := ''

default lAuto := .F.

if lAuto
   RPCSetType( 3 ) // Não consome licensa de uso
   RpcSetEnv('02','01',,,,GetEnvServer(),{"SF4"})  // atencao para esta linha.
endif   

nDias:= dDataI - dDataF
nDias+=1

cTURNO1   := GetMv( "MV_TURMAQ1" )
cTURNO2   := GetMv( "MV_TURMAQ2" )
cTURNO3   := GetMv( "MV_TURMAQ3" )

cDURACAO1:= valor(nDias,SubStr( cTURNO1, 7, 5)+":00",.F.,.T.)
cDURACAO2:= valor(nDias,SubStr( cTURNO2, 7, 5)+":00",.F.,.F.) 
nDURACAO3:= valor(nDias,SubStr( cTURNO3, 7, 5)+":00",.T.,.F.) 

nHORA1:=Left( cTURNO1, 5 )+ ":00"
nHORA2:=Left( cTURNO2, 5 )+ ":00"
nHORA3:=Left( cTURNO3, 5 )+ ":00"

cQry:="SELECT CAST(CAST(Z58_HORA AS DATETIME) AS FLOAT) Z58_DECIMAL,* "
cQry+="FROM "+RetSqlName("Z58")+" Z58 "
cQry+="WHERE  Z58.D_E_L_E_T_!='*' "
cQry+="AND Z58_DATA >= '" + Dtos( dDataI ) + "' AND Z58_DATA <= '" + Dtos( dDataF + 1 ) + "' "

if ! empty(cMaqui)
   cQry+="AND Z58_MAQ='" +cMaqui+ "'  "               	
endif

cQry+="AND Z58_CANAL between '" +cLadoA+ "' and '" +cLadoB+ "' "
cQry+="AND Z58_STATUS between '" +cSta0+ "' and '" +cSta1+ "' "

cQry+="ORDER BY Z58_MAQ,Z58_CANAL,Z58_DATA,Z58_HORA "		
TCQUERY cQry NEW ALIAS "Z58X"

TCSetField( 'Z58X', "Z58_DATA", "D" )

Z58X->( dbGoTop() )

While Z58X->( !EOF() ) 
    cMaq:=Z58X->Z58_MAQ
    cStaAnt:='0'    
    // VARIAVEIS PARA O LADO A 
    nTempLig1A:=nTempLig2A:=nTempLig3A:='00:00:00'//0 
    nTempDes1A:=nTempDes2A:=nTempDes3A:='00:00:00'//0
    // VARIAVEIS PARA O LADO B  
    nTempLig1B:=nTempLig2B:=nTempLig3B:='00:00:00'//0
    nTempDes1B:=nTempDes2B:=nTempDes3B:='00:00:00'//0
    // VARIAVEIS INICIAL DE CADA TURNO
     // Lado A                                               	
     cSI1A:=cSI2A:=cSI3A:=''
     nHI1A:=nHI2A:=nHI3A:='00:00:00'//0
    // Lado B
     cSI1B:=cSI2B:=cSI3B:=''
     nHI1B:=nHI2B:=nHI3B:='00:00:00' //0
     
    // VARIAVEIS FINAL DE CADA TURNO
     // Lado A
     cSF1A:=cSF2A:=cSF3A:=''
     nHF1A:=nHF2A:=nHF3A:='00:00:00' //0
     // Lado B
     cSF1B:=cSF2B:=cSF3B:=''
     nHF1B:=nHF2B:=nHF3B:='00:00:00' //0
     
     // TEMPO TOTAL LIGADO
     cTotTL1A:=cTotTL2A:=cTotTL3A:='00:00:00' //0 
     cTotTL1B:=cTotTL2B:=cTotTL3B:='00:00:00' //0 
     // % 
     nPer1A:=nPer2A:=nPer3A:=0
     nPer1B:=nPerB:=nPer3B:=0
     //variaveis logicas
     lOk1A:=lOk2A:=lOk3A:=.T.
     lOk1B:=lOk2B:=lOk3B:=.T.

    Do While Z58X->( !EOF() ) .AND. Z58X->Z58_MAQ=cMaq
		// 1ª Turno
		If Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO1, 5 )+ ":00" .and.;
		    Z58X->Z58_HORA <= U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" )	     
		    If Z58X->Z58_CANAL='0'  // LADO A 
		       If lOk1A
		          If Z58X->Z58_STATUS='0' 	             
		             cTotTL1A:=AddHora(cTotTL1A,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
		          else                                          
		             cStaAnt:='0'    
		          endif              
		          lOk1A:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1'  .and.  cStaAnt!=Z58X->Z58_STATUS   // MAQUINA LIGADA
		          nTempLig1A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif                           		
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .and.  cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1A:=nHORA2
		             cTotTL2A:=AddHora(cTotTL2A,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif		       
		       cTotTL1A:= AddHora(cTotTL1A,TempoLig(nTempDes1A,nTempLig1A))                     		    
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       If lOk1B
		          If Z58X->Z58_STATUS='0' 
		             cTotTL1B:= AddHora(cTotTL1B,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
		          Else
		             cStaAnt:='0'
		          endif
		          lOk1B:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig1B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1B:=nHORA2
		             cTotTL2B:=AddHora(cTotTL2B,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       cTotTL1B:= AddHora(cTotTL1B,TempoLig(nTempDes1B,nTempLig1B))                     	       
		    Endif		    		
		// 2ª truno		
		elseIf Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO2, 5 )+ ":00"  .and.;
   		       Z58X->Z58_HORA <= U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" )           
		    If Z58X->Z58_CANAL='0' // LADO A 	    
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig2A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2A:=nHORA3
		             cTotTL3A:=AddHora(cTotTL3A,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       cTotTL2A:= AddHora(cTotTL2A,TempoLig(nTempDes2A,nTempLig2A))                     
		       
		    elseif Z58X->Z58_CANAL='1' // LADO B		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          nTempLig2B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2B:=nHORA3
		             cTotTL3B:=AddHora(cTotTL3B,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       cTotTL2B:= AddHora(cTotTL2B,TempoLig(nTempDes2B,nTempLig2B))                         		    		    
		    Endif	    		    
		// 3ª turno	
		elseIf ( Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO3, 5 ) + ":00" ) .or. ;
		 			 ( Z58X->Z58_DATA >= dDataI + 1 .and. Z58X->Z58_HORA <=U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ) )           		    
		    If Z58X->Z58_CANAL='0' // LADO A 		       	       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          cDtLig3A:=Z58X->Z58_DATA
		          nTempLig3A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3A:=Z58X->Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3A!=cDtDesl3A
		             nTempDes3A:=nHORA1      
		          Else
		             nTempDes3A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
			   
			   If cDtLig3A!=cDtDesl3A
			      if cDtLig3A<cDtDesl3A
				     cRes24:=AddHora(TempoLig('23:59:59',nTempLig3A),TempoLig(nTempDes3A,'00:00:00'))
			         cTotTL3A:=AddHora(cTotTL3A,AddHora(cRes24,'00:00:01'))
	              Else	
	 			     cRes24:=AddHora(TempoLig('23:59:59',nTempDes3A),TempoLig(nTempLig3A,'00:00:00'))
			         cTotTL3A:= AddHora(cTotTL3A,AddHora(cRes24,'00:00:01'))
				  EndIf		       
				Else
			         cTotTL3A:= AddHora(cTotTL3A,TempoLig(nTempDes3A,nTempLig3A))
	            Endif                  		       		       
		    elseif Z58X->Z58_CANAL='1' // LADO B		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          cDtLig3B:=Z58_DATA
		          nTempLig3B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If cStaAnt=Z58X->Z58_STATUS 
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())    
		          loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3B:=Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3B!=cDtDesl3B
		             nTempDes3B:=nHORA1     
		          Else
		             nTempDes3B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       If cDtLig3B!=cDtDesl3B
			      if cDtLig3B<cDtDesl3B
				     cRes24:=AddHora(TempoLig('23:59:59',nTempLig3B),TempoLig(nTempDes3B,'00:00:00'))
			         cTotTL3B:= AddHora(cTotTL3B,AddHora(cRes24,'00:00:01'))                     
	               Else	
	 			     cRes24:=AddHora(TempoLig('23:59:59',nTempDes3B),TempoLig(nTempLig3B,'00:00:00'))
			         cTotTL3B:= AddHora(cTotTL3B,AddHora(cRes24,'00:00:01'))                     
				  EndIf		       
			   Else
			         cTotTL3B:= AddHora(cTotTL3B,TempoLig(nTempDes3B,nTempLig3B))                     		       		             		    
		       Endif
		    endif   	    
		else
	        Z58X->(dbSkip()) // Avanca o ponteiro do registro no arquivo
        endif    
    EndDo
    
   //Lado A                               
   //1º turno
   nPer1A:= Percent(cTotTL1A,cDURACAO1)
   //2º turno 
   nPer2A:=Percent(cTotTL2A,cDURACAO2)
   //3º turno  
   nPer3A:=Percent(cTotTL3A,cDURACAO3)
   
   //Lado B                                                              
   //1º turno 
   nPer1B:= Percent(cTotTL1B,cDURACAO1)
   //2º turno 
   nPer2B:=Percent(cTotTL2B,cDURACAO2)
   //3º turno   
   nPer3B:=Percent(cTotTL3B,cDURACAO3)
   
//--------------------------------------------------------  
// total 1 TURNO
   
   // DURACAO
   cTotHD1:=AddHora(cDURACAO1,iif(SUBSTR(cMaq,1,2)!='P0',cDURACAO1,"00:00:00"))  
   // TEMPO LIGADO
   cTotHL1:=AddHora(cTotTL1A,cTotTL1B)  
   // % ligado
   cTotHP1:=Percent(cTotHL1,cTotHD1)
   // desligada
   cDes1:=TempoLig(cTotHD1,cTotHL1)
   // % desligado
   cPdes1:=Percent(cDes1,cTotHD1)

// total 2 TURNO
   // DURACAO
   cTotHD2:=AddHora(cDURACAO2,iif(SUBSTR(cMaq,1,2)!='P0',cDURACAO2,"00:00:00"))  
   // LIGADA
   cTotHL2:=AddHora(cTotTL2A,cTotTL2B)  
   // % ligado
   cTotHP2:=Percent(cTotHL2,cTotHD2)
   // desligada
   cDes2:=TempoLig(cTotHD2,cTotHL2)
   // % desligado
   cPdes2:=Percent(cDes2,cTotHD2)

// total 3 TURNO
   // DURACAO
   cTotHD3:=AddHora(cDURACAO3,iif(SUBSTR(cMaq,1,2)!='P0',cDURACAO3,"00:00:00"))  
   // LIGADA
   cTotHL3:=AddHora(cTotTL3A,cTotTL3B)  
   // %
   cTotHP3:=Percent(cTotHL3,cTotHD3) 
   // desligada
   cDes3:=TempoLig(cTotHD3,cTotHL3)
   // % desligado
   cPdes3:=Percent(cDes3,cTotHD3)

   AADD(aRet,{cDURACAO1,cDURACAO2,cDURACAO3,cTotTL1A,nPer1A,cTotTL2A,nPer2A,cTotTL3A,nPer3A, ;
              cTotTL1B,nPer1B,cTotTL2B,nPer2B,cTotTL3B,nPer3B,cDes1,cPDes1,cDes2,cPDes2,cDes3,cPDes3,cTotHD1,cTotHD2,cTotHD3} )

EndDo

Z58X->(DBCLOSEAREA())

if lAuto
   RpcClearEnv() // Libera o Environment
   DbCLoseAll()
endif   

Return aRet


******************************************************
Static Function valor( nValor,_cHora,lTurno3,lTurno1 )
******************************************************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(Subst(_cHora,1,AT(":",_cHora)-1 )  )*3600  - 3600   
_nMi1 := Val(Subst(_cHora,AT(":",_cHora)+1,2)  )*60 - IIF(lTurno3,10*60,0) -IIF(lTurno1,20*60,0)
cRs4:=Subst(_cHora,AT(":",_cHora)+1,len(_cHora))
_nSg1 := Val(Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nRs1:=_nHr1+_nMi1+_nSg1

_nRs3:=_nRs1*nValor 

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
   cHr:=alltrim(str(Hr))
else
   cHr:=StrZero(Hr,2)
EndIf

_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(_cRes)


********************************************
Static Function TempoLig( _cHora1, _cHora2 )
********************************************

local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1 := _nRs2 := _nRs3 := 0
local _cRes := ''
local Hr,ResHr,Mi,Seg
local cHr  := ''
local cRs4 := '' 

_nHr1 := Val(Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1 - _nRs2

if _nRs3<0
   Return "########" 
endif

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

if Hr >99
   cHr:=alltrim(str(Hr)	)
else
   cHr:=StrZero(Hr,2)
endIf

_cRes := cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(_cRes)    


*******************************************
Static Function AddHora( _cHora1, _cHora2 )
*******************************************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1 :=_nRs2 :=_nRs3 := 0
local _cRes := ''
local Hr,ResHr,Mi,Seg
local cHr := ''
local cRs4 := '' 

_nHr1 := Val( Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val( Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val( Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val( Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val( Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val( Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1+_nRs2

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
   cHr:=alltrim(str(Hr))
else
   cHr:=StrZero(Hr,2)
EndIf

_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(_cRes)


*******************************************
Static Function Percent( _cHora1, _cHora2 )
*******************************************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_cRes

local cRs4:='' 

_nHr1 := Val( Subst(_cHora1,1,AT(":",_cHora1)-1 ) ) * 3600     
_nMi1 := Val( Subst(_cHora1,AT(":",_cHora1)+1,2) ) * 60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val( Subst(cRs4,AT(":",cRs4)+1,2 ) ) 

_nHr2 := Val( Subst(_cHora2,1,AT(":",_cHora2)-1) ) * 3600
_nMi2 := Val( Subst(_cHora2,AT(":",_cHora2)+1,2) ) * 60
cRs4  := Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val( Subst(cRs4,AT(":",cRs4)+1,2 ) )

_nRs1 := _nHr1+_nMi1+_nSg1
_nRs2 := _nHr2+_nMi2+_nSg2

_cRes:=(_nRs1/_nRs2)*100

Return(_cRes)