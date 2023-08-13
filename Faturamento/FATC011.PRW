#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"



         
User function FATC011() // cargowiz
   	if  !PERGUNTE ('FATC011',.T.)
    		return
 	endif 
MsAguarde( {||	salvar() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gerando arquivo txt..." ) )	

 
	
return



 
Static Function salvar ()
Local ARQUIVO 
 
cStartPath := GetSrvProfString("Startpath","")
cOrigem :=/* cStartPath+*/'C:\Fat\arquivo.txt'  
if ! lIsDir( "C:\Fat\")
	nMDir := MakeDir( "C:\Fat\" )
	if nMDir <> 0
		alert("nao foi possivel criar Dir "+Alltrim(Str(nMDir)))
	endif
endif 

   
if FERASE(cOrigem)==1
 ARQUIVO:=fopen(cOrigem,2)
else
 ARQUIVO:=Fcreate(cOrigem,0)
fClose(ARQUIVO) 
ARQUIVO:=fopen(cOrigem,2)
endif 
     if !empty(MV_PAR03)
    cReg:=getReg(MV_PAR03)
    endif
    
    cQry :=""
	cQry+="SELECT                     "  + chr(10)
	//D2_QUANT QUANT  ,   "  + chr(10)   
	cQry+="CASE WHEN B1_SETOR='39'    "  + chr(10)
	cQry+="THEN D2_QUANT/B5_QE1       "  + chr(10)
    cQry+="ELSE D2_QUANT*B5_QE1       "  + chr(10)
    cQry+="END QUANT,                 "  + chr(10)
	cQry+=" B5_COMPRLC     COMPR  ,   "  + chr(10)
	cQry+=" B5_LARGLC      LARG   ,   "  + chr(10)
	cQry+=" B5_ALTURLC     ALTURA ,   "  + chr(10)
	cQry+=" B1_COD         COD    ,   "  + chr(10)
	cQry+=" B1_DESC        DESCRI     "  + chr(10)
	cQry+=" FROM                      "  + chr(10)
    cQry+=RetSqlName( "SD2" ) +" SD2 ,"  + chr(10)
    cQry+=RetSqlName( "SB5" ) +" SB5 ,"  + chr(10)
    cQry+=RetSqlName( "SB1" ) +" SB1  "  + chr(10)
	cQry+="WHERE D2_DOC BETWEEN       "  + chr(10)
	cQry+=valtosql(MV_PAR01)+" AND    "  + chr(10)                                     
	cQry+=valtosql(MV_PAR02)+"        "  + chr(10)
	cQry+="AND D2_COD=B5_COD          "  + chr(10)
	cQry+="AND D2_COD=B1_COD          "  + chr(10)
	if !empty(cReg)
	cQry+="AND D2_EST IN ("+cReg+")   "  + chr(10)
	endif
	cQry+="AND SD2.D_E_L_E_T_=''    "  + chr(10)
	cQry+="AND SB1.D_E_L_E_T_=''    "  + chr(10)
	cQry+="AND SB5.D_E_L_E_T_=''    "  + chr(10)
 
                     
    TCQUERY cQry   NEW ALIAS 'AUX1'    
       
cCabec:=;
"Line"       +chr(9)+;
"Qty"        +chr(9)+;
"Length"     +chr(9)+;
"Width"      +chr(9)+;
"Height"     +chr(9)+;
"Orients"    +chr(9)+;
"Stack"      +chr(9)+;
"Bottom"     +chr(9)+;
"Group"      +chr(9)+;
"Weight"     +chr(9)+;
"Units"      +chr(9)+;
"ShortID"    +chr(9)+;
"Description"+chr(10) +chr(13)

FWRITE(ARQUIVO,cCabec,len(cCabec))
 aVet:={}
nLin:=1  
nPadrao:=0
while !AUX1->(EOF())
if AUX1->COMPR==0 .or. AUX1->LARG==0 .or.  AUX1->ALTURA==0 
aadd(aVet,AUX1->COD)
AUX1->(dbskip()) 
else    
nPadrao:=1
cLinha:=;
     alltrim(str(nLin++))                       +chr(9)+;
     alltrim(transform(QUANT ,"@e  999999.99")) +chr(9)+;
     alltrim(transform(COMPR ,"@e  999999.99")) +chr(9)+;
     alltrim(transform(LARG  ,"@e  999999.99")) +chr(9)+;
     alltrim(transform(ALTURA,"@e  999999.99")) +chr(9)+;
     "1"                  +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     alltrim(COD)         +chr(9)+;
     alltrim(DESCRI)      //chr(10)//+chr(13)
     AUX1->(dbskip())
     cLinha+=iif(!AUX1->(EOF()),chr(10)+chr(13),"")
     FWRITE(ARQUIVO,strtran(cLinha,',','.'),len(cLinha))
  endif		
enddo


if nPadrao==0
cLinha:=;
     alltrim(str(nLin++))                       +chr(9)+;
     "1.00" +chr(9)+;
     "1.00" +chr(9)+;
     "1.00" +chr(9)+;
     "1.00" +chr(9)+;
     "1"                  +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     ""                   +chr(9)+;
     "AAAAAA"             +chr(9)+;
     "NENHUM DADO NO ARQUIVO"      //chr(10)//+chr(13)
     FWRITE(ARQUIVO,strtran(cLinha,',','.'),len(cLinha))
endif



fClose(ARQUIVO) 
if len(aVet)!=0 
cMsg:='<b>Largura,comprimento e altura</b> estão zerados<br>Cadastre esses valores para os produtos abaixo:'
  for x:=1 to len(aVet)
   
   cMsg+='<br> '+aVet[x]
  next
  alert(cMsg)    
endif
Return Nil   






***************

Static Function getReg(nREG) 

***************

 
if     nREG == 1
	return "'AC','AM','AP','PA','RO','RR','TO'"  
	
elseIf nREG == 2 
	return "'MA','PI','CE','RN','PB','PE','AL','BA','SE'" 
	
elseIf nREG == 3
	return "'RS','PR','SC'"  
	
elseIf nREG == 4
	return "'MG','ES','RJ','SP'" 
		
elseIf nREG == 5
	return "'GO','MT','MS','DF'"		
			
endIf	

RETURN ''    
 
