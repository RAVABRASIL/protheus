#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "



*************

User Function WFMETA()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select( 'SX2' ) == 0
     
     conOut( " " )
     conOut( "***************************************************************************" )
     conOut( "Informações de Meta TURNO     	           " )
     conOut( "***************************************************************************" )
     conOut( " " )
     
     PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFPCP018" Tables "SX5"
   	 
   	 Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam  
   	 grava()
else
   	 grava()
endif

Return 


**************

Static Function grava()

***************

nEfiMrD1:=nEfiMrD2:=nEfiMrD3:=0
nEfiMetaD1:=nEfiMetaD2:=nEfiMetaD3:=0
nEfiDia1:=nEfiDia2:=nEfiDia3:=0
aInfoOn:={}

dData:=ddatabase

if Left( Time(), 5 )>='06:00' .AND. Left( Time(), 5 )<='08:00'
   dData:=ddatabase-1
Endif


aInfoOn := U_PCPC018(Dtos(dData),'','','ZZZZZZZZZZ','',.F.)

for x := 1 to len(aInfoOn)

	// somatario produzido
	if aInfoOn[x][9]>0    // so soma o realizado se tiver meta	
		nEfiMrD1:= nEfiMrD1+aInfoOn[x][3]
	endif
	if aInfoOn[x][10]>0 
		nEfiMrD2:= nEfiMrD2+aInfoOn[x][4]
	endif
	
	if aInfoOn[x][11]>0 
		nEfiMrD3:= nEfiMrD3+aInfoOn[x][5]
	endif
	
	// somatorio por turno
	nEfiMetaD1:= nEfiMetaD1+aInfoOn[x][9] 
	nEfiMetaD2:= nEfiMetaD2+aInfoOn[x][10] 
	nEfiMetaD3:= nEfiMetaD3+aInfoOn[x][11] 

next	
	
if nEfiMetaD1>0 
	nEfiDia1:= (nEfiMrD1/nEfiMetaD1)*100   
endif

if nEfiMetaD2>0 
	nEfiDia2:= (nEfiMrD2/nEfiMetaD2)*100   
endif

if nEfiMetaD3>0 
	nEfiDia3:= (nEfiMrD3/nEfiMetaD3)*100   
endif

// envia email 		
EMAIL(dData)

return                   

/*
***************

Static Function EMAIL(dData)

***************

oProcess:=TWFProcess():New("WFMETA","WFMETA")
oProcess:NewTask('Inicio',"\workflow\http\emp01\WFMETA.html")
oHtml   := oProcess:oHtml
 
oHtml:ValByName("cData", dtoc(dData))

FOR _Y:=1 TO 3
  aadd( oHtml:ValByName("it.turno") ,STRZERO(_Y,2) )
  aadd( oHtml:ValByName("it.Prod" ) , str( round(fProd(_Y,dData),0)  )  )
  aadd( oHtml:ValByName("it.Meta" ) , TRANSFORM(&("nEfiDia"+alltrim(str(_Y))) ,"@E 999.99"))
NEXT
_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
oProcess:cTo := "marcelo@ravaembalagens.com.br;orley@ravaembalagens.com.br;robinson@ravaembalagens.com.br;renato.maia@ravaembalagens.com.br;antonio@ravaembalagens.com.br"
subj	:= "Informativo Meta "
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()
oProcess:Finish()

Return 
*/
**************

Static Function fProd(nOpc,dData)

***************

LOCAL nTurno1:=nTurno2:=nTurno3:=0


Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")

cTURNO1_A := Left(cTURNO1,5)+":00"
cTURNO2_A := Left(cTURNO2,5)+":00"
cTURNO3_A := Left(cTURNO3,5)+":00"

// RETIRADO APOS MUDANCA NO HORARIO  A PEDIDO DE ROBINSON 
//fTurno(dData)  // funcao para alimentar as variaves do turno conforme sabado,domingo, seg a sexta 

cQuery := "SELECT "
cQuery += "( SELECT ISNULL( SUM(Z01.Z00_PESO+Z01.Z00_PESCAP),0) "
cQuery += "  FROM Z00020 Z01 WITH (NOLOCK) "
cQuery += "  WHERE Z01.Z00_FILIAL = ' ' AND "
cQuery += "  Z01.Z00_DATHOR >= '"+DTOS(dData)+Left(cTURNO1,5)+"' AND Z01.Z00_DATHOR < '"+DTOS(dData)+Left(cTURNO2,5)+"' "
cQuery += "  AND SUBSTRING(Z01.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "  AND Z01.Z00_APARA = ' ' AND Z01.D_E_L_E_T_ = ' ' "
cQuery += ") AS TURNO1, "
cQuery += "( SELECT ISNULL( SUM(Z02.Z00_PESO+Z02.Z00_PESCAP),0) "
cQuery += "  FROM Z00020 Z02 WITH (NOLOCK) "
cQuery += "  WHERE Z02.Z00_FILIAL = ' ' AND "
cQuery += "  Z02.Z00_DATHOR >= '"+DTOS(dData)+Left(cTURNO2,5)+"' AND Z02.Z00_DATHOR < '"+DTOS(dData)+Left(cTURNO3,5)+"' "
cQuery += "  AND SUBSTRING(Z02.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "  AND Z02.Z00_APARA = ' ' AND Z02.D_E_L_E_T_ = ' ' "
cQuery += ") AS TURNO2, "
cQuery += "( SELECT ISNULL( SUM(Z03.Z00_PESO+Z03.Z00_PESCAP),0) "
cQuery += "  FROM Z00020 Z03 WITH (NOLOCK) "
cQuery += "  WHERE Z03.Z00_FILIAL = ' ' AND "
cQuery += "  Z03.Z00_DATHOR >= '"+DTOS(dData)+Left(cTURNO3,5)+"' AND Z03.Z00_DATHOR < '"+DTOS(dData+1)+Left(cTURNO1,5)+"' "
cQuery += "  AND SUBSTRING(Z03.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQuery += "  AND Z03.Z00_APARA = ' ' AND Z03.D_E_L_E_T_ = ' ' "
cQuery += ") AS TURNO3 "

TCQUERY cQuery NEW ALIAS "TMXY"


If TMXY->(!EOF())

    nTurno1:=TMXY->TURNO1
    nTurno2:=TMXY->TURNO2
    nTurno3:=TMXY->TURNO3
    
eNDIF

TMXY->(dbclosearea())

Return IIF(nOpc=1,nTurno1,IIF(nOpc=2,nTurno2,nTurno3))


***************

Static Function fTurno(dData)

***************

If dow(dData)=7 // sabado
   cTURNO1   := GetMv("MV_TURNO1S")
   cTURNO2   := GetMv("MV_TURNO2S")
   cTURNO3   := GetMv("MV_TURNO3S")

   cTURNO1_A := Left(cTURNO1,5)+":00"
   cTURNO2_A := Left(cTURNO2,5)+":00"
   cTURNO3_A := Left(cTURNO3,5)+":00"
ElseIf dow(dData)=1 // Domingo
   cTURNO1   := GetMv("MV_TURNO1D")
   cTURNO2   := GetMv("MV_TURNO2D")
   cTURNO3   := GetMv("MV_TURNO3D")

   cTURNO1_A := Left(cTURNO1,5)+":00"
   cTURNO2_A := Left(cTURNO2,5)+":00"
   cTURNO3_A := Left(cTURNO3,5)+":00"
Else // seg. a sexta 
   cTURNO1   := GetMv("MV_TURNO1")
   cTURNO2   := GetMv("MV_TURNO2")
   cTURNO3   := GetMv("MV_TURNO3")

   cTURNO1_A := Left(cTURNO1,5)+":00"
   cTURNO2_A := Left(cTURNO2,5)+":00"
   cTURNO3_A := Left(cTURNO3,5)+":00"

Endif

Return 


***************

Static Function EMAIL(dData)

***************

cMensagem:=' '
cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cMensagem+='<head> '
cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cMensagem+='<title>Untitled Document</title> '
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style9 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='color: #FFFFFF; '
cMensagem+='font-size: 14px; '
cMensagem+='} '
cMensagem+='.style7 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='	font-size: 14px; '
cMensagem+='} '
cMensagem+='--> '
cMensagem+='</style> '
cMensagem+='</head> '

cMensagem+='<body> '
cMensagem+='<p>Data: '+dtoc(dData)+'</p> '
cMensagem+='<table width="522" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="97" bgcolor="#00CC66" scope="col"><span class="style9">Turno</span><span class="style9"></span></td> '
cMensagem+='    <td width="194" bgcolor="#00CC66" scope="col"><span class="style9">Prou&ccedil;&atilde;o Kg </span><span class="style9"></span></td> '
cMensagem+='    <td width="209" bgcolor="#00CC66" scope="col"><div align="center"><span class="style9">% Meta </span></div></td> '
cMensagem+='  </tr> '
cMensagem+='  <tr> '
for _Y:=1 TO 3
   cMensagem+='    <td width="97" bgcolor="#FFFFFF"><span class="style7">'+STRZERO(_Y,2)+'</span></td> '
   cMensagem+='    <td width="194" bgcolor="#FFFFFF"><div align="left"><span class="style7">'+str( round(fProd(_Y,dData),0) )+'</span></div></td> '
   cMensagem+='    <td><div align="center"><span class="style7">'+TRANSFORM(&("nEfiDia"+alltrim(str(_Y))) ,"@E 999.99")+'</span></div></td> '
   cMensagem+='  </tr> '
next
cMensagem+='</table> '
cMensagem+='</body> '
cMensagem+='</html> '


// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
cEmail   :="marcelo@ravaembalagens.com.br;orley@ravaembalagens.com.br;robinson@ravaembalagens.com.br;renato.maia@ravaembalagens.com.br;antonio@ravaembalagens.com.br"

cAssunto :="Informativo Meta "

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)    
U_EnviaMail(cEmail,cAssunto,cMensagem)
Return 
