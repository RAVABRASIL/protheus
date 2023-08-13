#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "fivewin.ch"



User Function PCPC015()
public nDiaUt1    := 0
public nDiaUt2    := 0


public dDtLimite1 := CtoD(" ")
public dDtLimite2 := CtoD(" ")

public nMTcs1     := 0
public nMTcs2     := 0
public nMTcs3     := 0
public nMTcx1     := 0
public nMTcx2     := 0
public nMTcx3     := 0
public nMText1    := 0
public nMText2    := 0
public nMText3    := 0
public nMText4    := 0
public nMText5    := 0
public nMTpl1     := 0
public nMTpl2     := 0
public nMTpl3     := 0

public dDTREC     := CtoD(" ")// dDatabase
public cHRREC     :=  left(time(),5)
public lGrava     :=.T.  

if !Pergunte("PCPC015",.T.) 
return 
endif

dDTREC     :=  MV_PAR01
cQ:=" select max(Z73_COD) COD"                     + CHR(10)
cQ+=" FROM "+ RetSqlName( "Z73" ) +" Z73 " + CHR(10)
//cQ+=" where Z73_DTLIMT >= "+dtos(dDTREC) + CHR(10)
cQ+=" where "+ dtos(dDTREC) +" between Z73_DTREC AND Z73_DTLMT1 "+ CHR(10)
cQ+="  and  "+ dtos(dDTREC) +" between Z73_DTREC AND Z73_DTLMT2 "+ CHR(10)

TCQUERY cQ NEW ALIAS "AUX1"
if !empty(AUX1->COD) .and. AUX1->( !EOF() )
	cCod:=AUX1->COD
	alert("Não é permitido incluir antes da data Limite !<hr> Só é possivel Alterar")
	lGrava:= .F.
	posicione("Z73",1,xFilial("Z73")+cCod ,"Z73->Z73_COD")
	
	cCod       := Z73->Z73_COD  
	
	nDiaUt1    := Z73->Z73_DIAUT1
	nDiaUt2    := Z73->Z73_DIAUT2
	
	dDtLimite1 := Z73->Z73_DTLMT1
	dDtLimite2 := Z73->Z73_DTLMT2
	
	nMTpl1     := Z73->Z73_MTPL1
	nMTpl2     := Z73->Z73_MTPL2
	nMTpl3     := Z73->Z73_MTPL3
	
	nMTcx1     := Z73->Z73_MTCX1
	nMTcx2     := Z73->Z73_MTCX2
	nMTcx3     := Z73->Z73_MTCX3
	
	nMTcs1     := Z73->Z73_MTCS1
	nMTcs2     := Z73->Z73_MTCS2
	nMTcs3     := Z73->Z73_MTCS3
	
	nMText1     := Z73->Z73_MTEX1
	nMText2     := Z73->Z73_MTEX2
	nMText3     := Z73->Z73_MTEX3
	nMText4     := Z73->Z73_MTEX4
	nMText5     := Z73->Z73_MTEX5  
	
 
 
	
	
	
endif
AUX1->(DBCLOSEAREA())




SetPrvt("oDlg1","oGrp2","oSay02","oSay03","oSay04","oGet18","oGet19","oGet20","oGrp3","oSay05","oSay06")
SetPrvt("oGet21","oGet22","oGet23","oGrp4","oSay08","oSay09","oSay9","oGet24","oGet25","oGet26","oGrp6")
SetPrvt("oSay13","oSay14","oSay15","oSay16","oGet27","oGet28","oGet29","oGet30","oGet31","oGrp1","oSay00")
SetPrvt("oDiaut1","oGet14","oGrp7","oBtn1","oBtn2","oGrp5","oSay11","oSay10","oGet17","oDiaUt2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 124,249,661,714,"Cadastro de Metas de produção",,,.F.,,,,,,.T.,,,.F. ) 


oGrp1      := TGroup():New( 004,004,025,229,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay00     := TSay():New( 011,008,{||"Dias Úteis"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oSay01     := TSay():New( 011,100,{||"Data Limite"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oDiaut1    := TGet():New( 009,036,,oGrp1,058,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaUt1",,)
oDiaut1:bSetGet := {|u| If(PCount()>0,nDiaUt1:=u,nDiaUt1)}

oGet14     := TGet():New( 009,144,,oGrp1,070,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtLimite1",,)
oGet14:bSetGet := {|u| If(PCount()>0,dDtLimite1:=u,dDtLimite1)}


//if !lGrava
//oDiaut1:disable()
//oGet14:disable()
//endif


oGrp2      := TGroup():New( 028,004,084,078,"Plástico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay02     := TSay():New( 038,008,{|| "1ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay03     := TSay():New( 053,008,{|| "2ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay04     := TSay():New( 068,008,{|| "3ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet18     := TGet():New( 036,040,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTpl1",,)
oGet18:bSetGet := {|u| If(PCount()>0,nMTpl1:=u,nMTpl1)}

oGet19     := TGet():New( 051,040,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTpl2",,)
oGet19:bSetGet := {|u| If(PCount()>0,nMTpl2:=u,nMTpl2)}

oGet20     := TGet():New( 066,040,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTpl3",,)
oGet20:bSetGet := {|u| If(PCount()>0,nMTpl3:=u,nMTpl3)}
                                                         



oGrp3      := TGroup():New( 028,080,084,152,"Caixa",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay05     := TSay():New( 038,084,{||"1ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay06     := TSay():New( 053,084,{||"2ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay07     := TSay():New( 068,084,{||"3ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet21     := TGet():New( 036,116,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcx1",,)
oGet21:bSetGet := {|u| If(PCount()>0,nMTcx1:=u,nMTcx1)}

oGet22     := TGet():New( 051,116,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcx2",,)
oGet22:bSetGet := {|u| If(PCount()>0,nMTcx2:=u,nMTcx2)}

oGet23     := TGet():New( 066,116,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcx3",,)
oGet23:bSetGet := {|u| If(PCount()>0,nMTcx3:=u,nMTcx3)}
                                                         



oGrp4      := TGroup():New( 028,156,084,228,"Costura",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )		
oSay08     := TSay():New( 038,160,{||"1ª turno"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay09     := TSay():New( 053,160,{||"2ª turno"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 068,160,{||"Turno Extra"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet24     := TGet():New( 036,192,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcs1",,)
oGet24:bSetGet := {|u| If(PCount()>0,nMTcs1:=u,nMTcs1)}

oGet25     := TGet():New( 051,192,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcs2",,)
oGet25:bSetGet := {|u| If(PCount()>0,nMTcs2:=u,nMTcs2)}

oGet26     := TGet():New( 066,192,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTcs3",,)
oGet26:bSetGet := {|u| If(PCount()>0,nMTcs3:=u,nMTcs3)}
   
                                            


oGrp5      := TGroup():New( 096,004,121,229,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay11     := TSay():New( 104,100,{||"Data Limite"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oSay10     := TSay():New( 105,008,{||"Dias Úteis"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)

oDiaUt2    := TGet():New( 104,036,,oGrp5,058,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaUt2",,)
oDiaUt2:bSetGet := {|u| If(PCount()>0,nDiaUt2:=u,nDiaUt2)}

oGet17     := TGet():New( 102,144,,oGrp5,070,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtLimite2",,)
oGet17:bSetGet := {|u| If(PCount()>0,dDtLimite2:=u,dDtLimite2)}
          

//if !lGrava
//oDiaUt2:disable()
//oGet17:disable()
//endif




oGrp6      := TGroup():New( 124,004,232,117,"Extrusora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay12     := TSay():New( 135,008,{||"Extrusora 1"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 154,008,{||"Extrusora 2"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,007)
oSay14     := TSay():New( 175,008,{||"Extrusora 3"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 195,008,{||"Extrusora 4"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oSay16     := TSay():New( 216,008,{||"Extrusora 5"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet27     := TGet():New( 133,051,,oGrp6,035,009,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMText1",,)
oGet27:bSetGet := {|u| If(PCount()>0,nMText1:=u,nMText1)}
                                    
oGet30     := TGet():New( 152,051,,oGrp6,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMText2",,)
oGet30:bSetGet := {|u| If(PCount()>0,nMText2:=u,nMText2)}

oGet28     := TGet():New( 173,051,,oGrp6,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMText3",,)
oGet28:bSetGet := {|u| If(PCount()>0,nMText3:=u,nMText3)}

oGet29     := TGet():New( 194,051,,oGrp6,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMText4",,)
oGet29:bSetGet := {|u| If(PCount()>0,nMText4:=u,nMText4)}

oGet31     := TGet():New( 214,051,,oGrp6,035,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMText5",,)
oGet31:bSetGet := {|u| If(PCount()>0,nMText5:=u,nMText5)}


oGrp7      := TGroup():New( 124,121,154,229,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 132,133,"Confirmar",oGrp7,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||  Salvar(), odlg1:end()}

oBtn2      := TButton():New( 132,181,"Cancelar",oGrp7,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||  oDlg1:end()}



oDlg1:Activate(,,,.T.)


Return










static function Salvar()
if lGrava
	cCod   :=  GETSX8NUM("Z73","Z73_COD")
endif
cUsu   :=  Usu( substr(cUsuario,7,15) )
 
if !lGrava
 

aEmail:={;
{"Dias Uteis             " , Z73->Z73_DIAUT1, nDiaUt1    ,1}    ,;
{"Data Limite            " , Z73->Z73_DTLMT1, dDtLimite1 ,3}    ,;
{"Dias Uteis Extrusora   " , Z73->Z73_DIAUT2, nDiaUt2    ,1}    ,;
{"Data Limite Extrusora  " , Z73->Z73_DTLMT2, dDtLimite2 ,3}    ,;
;
{"Meta Plastico 1ª turno " , Z73->Z73_MTPL1 , nMtpl1     ,2}    ,;
{"Meta Plastico 2ª turno " , Z73->Z73_MTPL2 , nMtpl2     ,2}    ,;
{"Meta Plastico 3ª turno " , Z73->Z73_MTPL3 , nMtpl3     ,2}    ,;
;
{"Meta Caixa ª turno     " , Z73->Z73_MTCX1 , nMtcx1     ,2}    ,;
{"Meta Caixa ª turno     " , Z73->Z73_MTCX2 , nMtcx2     ,2}    ,;
{"Meta Caixa ª turno     " , Z73->Z73_MTCX3 , nMtcx3     ,2}    ,;
;
{"Meta Costura ª turno   " , Z73->Z73_MTCS1 , nMtcs1     ,2}    ,;
{"Meta Costura ª turno   " , Z73->Z73_MTCS2 , nMtcs2     ,2}    ,;
{"Meta Costura ª turno   " , Z73->Z73_MTCS3 , nMtcs3     ,2}    ,;
;
{"Meta Extrusora 1       " , Z73->Z73_MTEX1 , nMtext1    ,2}    ,;
{"Meta Extrusora 2       " , Z73->Z73_MTEX2 , nMtext2    ,2}    ,;
{"Meta Extrusora 3       " , Z73->Z73_MTEX3 , nMtext3    ,2}    ,;
{"Meta Extrusora 4       " , Z73->Z73_MTEX4 , nMtext4    ,2}    ,;
{"Meta Extrusora 5       " , Z73->Z73_MTEX5 , nMtext5    ,2}     ;
}  
MsAguarde( {|| email(aEmail,cCod,U_cod2nome(cUsu))  }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gravando..." ) )
  

endif
RecLock("Z73",lGrava)
Z73->Z73_FILIAL := xFilial("Z73")
Z73->Z73_COD    := cCod  

Z73->Z73_DIAUT1 := nDiaUt1
Z73->Z73_DTLMT1 := dDtLimite1
Z73->Z73_DIAUT2 := nDiaUt2
Z73->Z73_DTLMT2 := dDtLimite2

Z73->Z73_MTPL1 := nMtpl1
Z73->Z73_MTPL2 := nMtpl2
Z73->Z73_MTPL3 := nMtpl3

Z73->Z73_MTCX1 := nMtcx1
Z73->Z73_MTCX2 := nMtcx2
Z73->Z73_MTCX3 := nMtcx3

Z73->Z73_MTCS1 := nMtcs1
Z73->Z73_MTCS2 := nMtcs2
Z73->Z73_MTCS3 := nMtcs3

Z73->Z73_MTEX1 := nMtext1
Z73->Z73_MTEX2 := nMtext2
Z73->Z73_MTEX3 := nMtext3
Z73->Z73_MTEX4 := nMtext4
Z73->Z73_MTEX5 := nMtext5


Z73->Z73_USUREC := cUsu
Z73->Z73_DTREC  := dDTREC
Z73->Z73_HRREC  := cHRREC
Z73->(MsUnlock())

if lGrava
	confirmSX8()
endif

return         



Static Function Usu( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
	aUsuarios  := PSWRET()
	ccod       := Alltrim(aUsuarios[1][1])     	// usuário
Endif

return ccod
                        


Static Function email( aEmail ,cCod,cUsu)                                                                  
aMask:={"@E 99","@E 999,999.99"} 
	cInicio:=U_CabecEmail() 
	cInicio +="<center>"                            
    cInicio +="<h3>Meta "+cCod+" foi alterada por "+cUsu+"</h3><br>"
    cInicio +="Segue os detalhes"
	cInicio +='<table width="100%" border="1"    align="center"  >' 
	cInicio +="<tr> "
	cInicio +=" <td bgcolor='green'><font color='white'><b> Descrição </b></font></td> "
	cInicio +=" <td bgcolor='green'><font color='white'><b> Original  </b></font></td> "
	cInicio +=" <td bgcolor='green'><font color='white'><b> Atual     </b></font></td> "
	cInicio +="</tr>"                                  
	for i:=1 to len(aEmail)
	   if aEmail[i][2]!=aEmail[i][3]
       	cInicio+="<tr> "
      	cInicio+=" <td >"+aEmail[i][1]+" </td> "
    	cInicio+=" <td >"+iif( aEmail[i][4] == 3 , dtoc(aEmail[i][2]) , transform(aEmail[i][2],aMask[aEmail[i][4]]))+" </td> "
    	cInicio+=" <td >"+iif( aEmail[i][4] == 3 , dtoc(aEmail[i][3]) , transform(aEmail[i][3],aMask[aEmail[i][4]]))+" </td> "
     	cInicio+="</tr>"  
       
       endif 
    next
    cInicio +='</table>'  
    cInicio +='</center>' 
    cInicio +='</body>'   
    cInicio+='</html>'       
    

    //cEmail   :="rubem@ravaembalagens.com.br" 

    cEmail:="rubem@ravaembalagens.com.br;"    
    
    cAssunto := oemtoansi('Alteracao de metas de Producao ')
    ACSendMail(,,,,cEmail,cAssunto,cInicio,)
    
    return