#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch" 
#include "fivewin.ch" 

User Function PCPC009   ()
 
PUBLIC nAparaP    := 0
PUBLIC nApCs      := 0
PUBLIC nApEXT     := 0
PUBLIC nApTeste   := 0
PUBLIC nApUTZ     := 0
PUBLIC nCo1       := 0
PUBLIC nCo2       := 0
PUBLIC nCo3       := 0
PUBLIC nCx1       := 0
PUBLIC nCx2       := 0
PUBLIC nCx3       := 0
PUBLIC nDiaExt    := 0
PUBLIC nDiaTrab   := 0
PUBLIC nDiaUt     := 0
PUBLIC nExt1      := 0
PUBLIC nExt2      := 0
PUBLIC nExt3      := 0
PUBLIC nExt4      := 0
PUBLIC nExt5      := 0
PUBLIC nMtCo1     := 0
PUBLIC nMtCo2     := 0
PUBLIC nMtCo3     := 0
PUBLIC nMtCx1     := 0
PUBLIC nMtCx2     := 0
PUBLIC nMtCx3     := 0
PUBLIC nMtExt1    := 0
PUBLIC nMtExt2    := 0
PUBLIC nMtExt3    := 0
PUBLIC nMtExt4    := 0
PUBLIC nMtExt5    := 0
PUBLIC nMTpl1     := 0
PUBLIC nMtpl2     := 0
PUBLIC nMtpl3     := 0
PUBLIC npl1       := 0
PUBLIC npl2       := 0
PUBLIC npl3       := 0
PUBLIC nProdExt   := 0
PUBLIC nRepCS     := 0
PUBLIC nRepCsA    := 0
PUBLIC nRepUTZ    := 0
PUBLIC nRepUTZA   := 0 
PUBLIC lGrava     :=.T.
PUBLIC lMeta      :=.F.
         

public dDTREC     := CtoD(" ")// dDatabase
public cHRREC     :=  left(time(),5)
 

 
 
//alltrim(str(U_ini_PERG( "PCPC009" ,1,"D",8,DDATABASE)))
if !Pergunte("PCPC009",.T.) 
return 
endif
 
 lGrava:=Consulta(MV_PAR01)
 if lGrava
 alert("Ja existem dados cadastrados para essa Data.<hr>Verifique o relatório RestProd.")
 return
 /* nOp:=Config()    // - Recebe numeric Tipo

   If     nOp == 1   
      nModo:=1
   elseif nOp == 2  
      return
   else              
      return
   Endif  
   */
 endif
      
   
 

 

dDTREC     :=  MV_PAR01
cQ:=" select max(Z73_COD) COD"                     + CHR(10)
cQ+=" FROM "+ RetSqlName( "Z73" ) +" Z73 " + CHR(10)
//cQ+=" where Z73_DTLIMT >= "+dtos(dDTREC) + CHR(10)
cQ+=" where "+ dtos(dDTREC) +" between Z73_DTREC AND Z73_DTLMT1 "+ CHR(10)
cQ+="  and  "+ dtos(dDTREC) +" between Z73_DTREC AND Z73_DTLMT2 "+ CHR(10)

TCQUERY cQ NEW ALIAS "AUX1"
if !empty(AUX1->COD) .and. AUX1->( !EOF() )
    lMeta:=.T.
	cCod:=AUX1->COD
	posicione("Z73",1,xFilial("Z73")+cCod ,"Z73->Z73_COD")
	
	
	nDiaUt    := Z73->Z73_DIAUT1
	nDiaExt    := Z73->Z73_DIAUT2
	
	
	nMTpl1     := Z73->Z73_MTPL1
	nMTpl2     := Z73->Z73_MTPL2
	nMTpl3     := Z73->Z73_MTPL3
	
	nMTcx1     := Z73->Z73_MTCX1
	nMTcx2     := Z73->Z73_MTCX2
	nMTcx3     := Z73->Z73_MTCX3
	
	nMTco1     := Z73->Z73_MTCS1
	nMTco2     := Z73->Z73_MTCS2
	nMTco3     := Z73->Z73_MTCS3
	
	nMText1     := Z73->Z73_MTEX1
	nMText2     := Z73->Z73_MTEX2
	nMText3     := Z73->Z73_MTEX3
	nMText4     := Z73->Z73_MTEX4
	nMText5     := Z73->Z73_MTEX5  
	
	
endif
AUX1->(DBCLOSEAREA())  
   
   
   
   
   
   
   
    
 
avet:={} 
MsAguarde( {|| avet:=U_REST_OUT(MV_PAR01,MV_PAR01) }, OemToAnsi( "Aguarde" ), OemToAnsi( "Carregando Produção ..." ) )
  
 
if len(avet)==0
alert("Os dados  da Produção Diária nao foram encontrados.<hr>Verifique o relatório RestProd.")
     //return
else 
Ini:=1
 nPl1       := avet[Ini++]
 nPl2       := avet[Ini++]
 nPl3       := avet[Ini++]

 nCx1       := avet[Ini++]
 nCx2       := avet[Ini++]
 nCx3       := avet[Ini++]

 nExt1      := avet[Ini++]
 nExt2      := avet[Ini++]
 nExt3      := avet[Ini++]
 nExt4      := avet[Ini++]
 nExt5      := avet[Ini++]

 nCo1       := avet[Ini++]
 nCo2       := avet[Ini++]
 nCo3       := avet[Ini++]
 
 
endif
 
SetPrvt("oDlg1","oGrp2","oSay1","oSay2","oSay3","opl1","opl2","opl3","oGpl1","oGpl2","oGpl3","oGrp3")
SetPrvt("oSay5","oSay6","ocx1","ocx2","ocx3","oGcx1","oGcx2","oGcx3","oGrp5","oSay7","oSay8","oSay9")
SetPrvt("oco2","oco3","oGco1","oGco2","oGco3","oGrp4","oSay10","oSay11","oSay12","oSay15","oSay16","oSay17")
SetPrvt("oext2","oext3","oext4","oGet16","oGet17","oGext1","oGext3","oGext4","oGext2","oGrp1","oSay13")
SetPrvt("oGet13","oGet14","oGrp6","oBtn1","oBtn2","oGrp7","oSay18","oSay19","oSay20","oSay21","oSay22")
SetPrvt("oSay24","oSay25","oSay26","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9")
oDlg1      := MSDialog():New( 087,246,671,778,"Resumo da Produção",,,.F.,,,,,,.T.,,,.F. )

oGrp1      := TGroup():New( 004,004,025,260,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay13     := TSay():New( 011,008,{||"Dias Úteis"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oSay14     := TSay():New( 011,120,{||"Dias trabalhados"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)

oGet13     := TGet():New( 009,036,,oGrp1,058,008,'@E 99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaUt",,)
oGet13:bSetGet := {|u| If(PCount()>0,nDiaUt:=u,nDiaUt)}
if lMeta
oGet13:disable()
endif
oGet14     := TGet():New( 009,171,,oGrp1,070,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaTrab",,)
oGet14:bSetGet := {|u| If(PCount()>0,nDiaTrab:=u,nDiaTrab)}







oGrp2      := TGroup():New( 028,004,084,122,"Plástico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 038,008,{||"1ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 053,008,{||"2ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 068,008,{||"3ª turno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
opl1       := TGet():New( 036,086,,oGrp2,032,007,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","npl1",,)
opl1:bSetGet := {|u| If(PCount()>0,npl1:=u,npl1)}

opl2       := TGet():New( 051,086,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","npl2",,)
opl2:bSetGet := {|u| If(PCount()>0,npl2:=u,npl2)}

opl3       := TGet():New( 066,086,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","npl3",,)
opl3:bSetGet := {|u| If(PCount()>0,npl3:=u,npl3)} 
trava(opl1)
trava(opl2)
trava(opl3)

oGpl1      := TGet():New( 036,050,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMTpl1",,)
oGpl1:bSetGet := {|u| If(PCount()>0,nMTpl1:=u,nMTpl1)}

oGpl2      := TGet():New( 051,050,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtpl2",,)
oGpl2:bSetGet := {|u| If(PCount()>0,nMtpl2:=u,nMtpl2)}

oGpl3      := TGet():New( 066,050,,oGrp2,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtpl3",,)
oGpl3:bSetGet := {|u| If(PCount()>0,nMtpl3:=u,nMtpl3)}
if lMeta
oGpl1:disable()
oGpl2:disable()
oGpl3:disable()
endif













oGrp3      := TGroup():New( 083,004,139,122,"Caixa",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay4      := TSay():New( 093,008,{||"1ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 108,008,{||"2ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 123,008,{||"3ª turno"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
ocx1       := TGet():New( 091,086,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCx1",,)
ocx1:bSetGet := {|u| If(PCount()>0,nCx1:=u,nCx1)}

ocx2       := TGet():New( 106,086,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCx2",,)
ocx2:bSetGet := {|u| If(PCount()>0,nCx2:=u,nCx2)}

ocx3       := TGet():New( 121,086,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCx3",,)
ocx3:bSetGet := {|u| If(PCount()>0,nCx3:=u,nCx3)}
trava(ocx1)
trava(ocx2)
trava(ocx3)

oGcx1      := TGet():New( 091,050,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCx1",,)
oGcx1:bSetGet := {|u| If(PCount()>0,nMtCx1:=u,nMtCx1)}

oGcx2      := TGet():New( 106,050,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCx2",,)
oGcx2:bSetGet := {|u| If(PCount()>0,nMtCx2:=u,nMtCx2)}

oGcx3      := TGet():New( 121,050,,oGrp3,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCx3",,)
oGcx3:bSetGet := {|u| If(PCount()>0,nMtCx3:=u,nMtCx3)}
if lMeta
oGcx1:disable()
oGcx2:disable()
oGcx3:disable()
endif




 




oGrp4      := TGroup():New( 140,004,277,122,"Extrusora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay10     := TSay():New( 183,008,{||"Extrusora 1"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 203,008,{||"Extrusora 2"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,007)
oSay12     := TSay():New( 223,008,{||"Extrusora 3"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 243,008,{||"Extrusora 4"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oSay27     := TSay():New( 263,008,{||"Extrusora 5"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)

oSay16     := TSay():New( 152,008,{||"Dias Úteis"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oSay17     := TSay():New( 164,008,{||"Dias trabalhados"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oext1      := TGet():New( 182,086,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nEx1t",,)
oext1:bSetGet := {|u| If(PCount()>0,nExt1:=u,nExt1)}

oext2      := TGet():New( 201,086,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nExt2",,)
oext2:bSetGet := {|u| If(PCount()>0,nExt2:=u,nExt2)}

oext3      := TGet():New( 222,086,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nExt3",,)
oext3:bSetGet := {|u| If(PCount()>0,nExt3:=u,nExt3)}

oext4      := TGet():New( 243,086,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nExt4",,)
oext4:bSetGet := {|u| If(PCount()>0,nExt4:=u,nExt4)} 

oext5     := TGet():New( 263,086,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nExt5",,)
oext5:bSetGet := {|u| If(PCount()>0,nExt5:=u,nExt5)}
trava(oext1)
trava(oext2)
trava(oext3)
trava(oext4)
trava(oext5)

oGet16     := TGet():New( 150,050,,oGrp4,069,007,'@E 99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDiaExt",,)
oGet16:bSetGet := {|u| If(PCount()>0,nDiaExt:=u,nDiaExt)}

oGet17     := TGet():New( 163,050,,oGrp4,069,008,'@E 99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nProdExt",,)
oGet17:bSetGet := {|u| If(PCount()>0,nProdExt:=u,nProdExt)}

oGext1     := TGet():New( 182,050,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtExt1",,)
oGext1:bSetGet := {|u| If(PCount()>0,nMtExt1:=u,nMtExt1)}

oGext2     := TGet():New( 201,050,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtExt2",,)
oGext2:bSetGet := {|u| If(PCount()>0,nMtExt2:=u,nMtExt2)}

oGext3     := TGet():New( 222,050,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtExt3",,)
oGext3:bSetGet := {|u| If(PCount()>0,nMtExt3:=u,nMtExt3)}

oGext4     := TGet():New( 243,050,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtExt4",,)
oGext4:bSetGet := {|u| If(PCount()>0,nMtExt4:=u,nMtExt4)}

oGext5     := TGet():New( 263,050,,oGrp4,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtExt5",,)
oGext5:bSetGet := {|u| If(PCount()>0,nMtExt5:=u,nMtExt5)}

if lMeta
oGet16:disable()
oGext1:disable()
oGext2:disable()
oGext3:disable()
oGext4:disable()
oGext5:disable()
endif




















oGrp5      := TGroup():New( 028,128,170,260,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay18     := TSay():New( 038,132,{||"Apara%"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 053,132,{||"Reprovação CS"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oSay20     := TSay():New( 068,132,{||"Reprovação UTZ"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oSay21     := TSay():New( 081,132,{||"Apara Cs"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 096,132,{||"Apara Ext"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 109,132,{||"Apara UTZ"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 123,132,{||"Apara Teste"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 137,132,{||"Reprovação Cs Atual"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,053,008)
oSay26     := TSay():New( 152,132,{||"Reprovação UTZ Atual"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,008)
oGet1      := TGet():New( 036,190,,oGrp5,060,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAparaP",,)
oGet1:bSetGet := {|u| If(PCount()>0,nAparaP:=u,nAparaP)}

oGet2      := TGet():New( 051,190,,oGrp5,060,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRepCS",,)
oGet2:bSetGet := {|u| If(PCount()>0,nRepCS:=u,nRepCS)}

oGet3      := TGet():New( 066,190,,oGrp5,060,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRepUTZ",,)
oGet3:bSetGet := {|u| If(PCount()>0,nRepUTZ:=u,nRepUTZ)}

oGet4      := TGet():New( 079,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nApCs",,)
oGet4:bSetGet := {|u| If(PCount()>0,nApCs:=u,nApCs)}

oGet5      := TGet():New( 094,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nApEXT",,)
oGet5:bSetGet := {|u| If(PCount()>0,nApEXT:=u,nApEXT)}

oGet6      := TGet():New( 107,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nApUTZ",,)
oGet6:bSetGet := {|u| If(PCount()>0,nApUTZ:=u,nApUTZ)}

oGet7      := TGet():New( 121,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nApTeste",,)
oGet7:bSetGet := {|u| If(PCount()>0,nApTeste:=u,nApTeste)}

oGet8      := TGet():New( 135,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRepCsA",,)
oGet8:bSetGet := {|u| If(PCount()>0,nRepCsA:=u,nRepCsA)}

oGet9      := TGet():New( 149,190,,oGrp5,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRepUTZA",,)
oGet9:bSetGet := {|u| If(PCount()>0,nRepUTZA:=u,nRepUTZA)}

  



oGrp6      := TGroup():New( 174,128,235,260,"Costura",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay7      := TSay():New( 184,132,{||"1ª turno"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 199,132,{||"2ª turno"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 214,132,{||"Turno Extra"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oco1       := TGet():New( 181,217,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCo1",,)
oco1:bSetGet := {|u| If(PCount()>0,nCo1:=u,nCo1)}

oco2       := TGet():New( 196,217,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCo2",,)
oco2:bSetGet := {|u| If(PCount()>0,nCo2:=u,nCo2)}

oco3       := TGet():New( 212,217,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nCo3",,)
oco3:bSetGet := {|u| If(PCount()>0,nCo3:=u,nCo3)} 
trava(oco1)
trava(oco2)
trava(oco3)

oGco1      := TGet():New( 181,181,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCo1",,)
oGco1:bSetGet := {|u| If(PCount()>0,nMtCo1:=u,nMtCo1)}

oGco2      := TGet():New( 196,181,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCo2",,)
oGco2:bSetGet := {|u| If(PCount()>0,nMtCo2:=u,nMtCo2)}

oGco3      := TGet():New( 212,181,,oGrp6,032,008,'@E 999,999.99',,CLR_BLACK,iif(!lMeta,CLR_WHITE,CLR_HGRAY),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtCo3",,)
oGco3:bSetGet := {|u| If(PCount()>0,nMtCo3:=u,nMtCo3)}

if lMeta
oGco1:disable()
oGco2:disable()
oGco3:disable()
endif


oGrp7      := TGroup():New(  237,128,261,260,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 243,135,"Confirmar",oGrp7,,051,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||  Gravar (),oDlg1:end()}

oBtn2      := TButton():New( 243,196,"Cancelar ",oGrp7,,054,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||  oDlg1:end()}



oDlg1:Activate(,,,.T.)

Return

     
static function Trava(oObj)

oObj:disable()
return





static function Gravar( )
cCod   :=  GETSX8NUM("Z70","Z70_COD")

cUsu   :=  Usu( substr(cUsuario,7,15) )
dDTREC :=  MV_PAR01 // dDatabase
cHRREC :=  left(time(),5)
 
gravaMAq(1,'A'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMTpl1  ,nPL1  )
gravaMAq(1,'B'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMTpl2  ,nPL2  )
gravaMAq(1,'C'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMTpl3  ,nPL3  )
                                                         
gravaMAq(2,'A'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCx1  ,nCx1  )
gravaMAq(2,'B'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCx2  ,nCx2  )
gravaMAq(2,'C'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCx3  ,nCx3  )

gravaEXT(3,'E01',cCod,cUsu,dDTREC,cHRREC,nDiaExt,nProdExt,nMtExt1 ,nExt1 )
gravaEXT(3,'E02',cCod,cUsu,dDTREC,cHRREC,nDiaExt,nProdExt,nMtExt2 ,nExt2 )
gravaEXT(3,'E03',cCod,cUsu,dDTREC,cHRREC,nDiaExt,nProdExt,nMtExt3 ,nExt3 )
gravaEXT(3,'E04',cCod,cUsu,dDTREC,cHRREC,nDiaExt,nProdExt,nMtExt4 ,nExt4 )
gravaEXT(3,'E05',cCod,cUsu,dDTREC,cHRREC,nDiaExt,nProdExt,nMtExt5 ,nExt5 )

gravaMAq(4,'A'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCo1  ,nCo1  )
gravaMAq(4,'B'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCo2  ,nCo2  )
gravaMAq(4,'C'  ,cCod,cUsu,dDTREC,cHRREC,nDiaUt ,nDiaTrab ,nMtCo3  ,nCo3  )
                                                                 
          

 
CONFIRMSX8()
 

	RecLock("Z71",.T.)
	Z71->Z71_FILIAL := xFilial("Z71")
	Z71->Z71_COD    := cCod
	Z71->Z71_APARAP := nAparaP
	Z71->Z71_RPUTZ  := nRepUTZ
	Z71->Z71_APCS   := nApCs
	Z71->Z71_APEXT  := nApEXT
	Z71->Z71_APUTZ  := nApUTZ
	Z71->Z71_APTST  := nApTeste
	Z71->Z71_RPCSA  := nRepCsA
	Z71->Z71_RPUTZA := nRepUTZA
	Z71->Z71_RPCS   := nRepCS
	Z71->(MsUnlock())

return


static Function GravaMaq(_nTipo,_cTurno,_cCod,_cUsu,_dDTREC,_cHRREC,_nDiaUt,_nDiaTrab,_nMeta  ,_nProd)

RecLock("Z70",.T.)
Z70->Z70_FILIAL := xFilial("Z70")
Z70->Z70_COD    := _cCod
Z70->Z70_DIAUT  := _nDiaUt
Z70->Z70_DIATAB := _nDiaTrab
Z70->Z70_METDIA := _nMeta
Z70->Z70_PRODIA := _nProd
Z70->Z70_LINHA  := _cTurno

Z70->Z70_USUREC := _cUsu
Z70->Z70_DTREC  := _dDTREC
Z70->Z70_HRREC  := _cHRREC
Z70->Z70_TIPO   := _nTipo
Z70->(MsUnlock())

  

return  


static Function GravaEXT(_nTipo,_cEXT,_cCod,_cUsu,_dDTREC,_cHRREC,_nDiaUt,_nDiaTrab,_nMeta  ,_nProd)

RecLock("Z70",.T.)
Z70->Z70_FILIAL := xFilial("Z70")
Z70->Z70_COD    := _cCod
Z70->Z70_DIAUT  := _nDiaUt
Z70->Z70_DIATAB := _nDiaTrab
Z70->Z70_METDIA := _nMeta
Z70->Z70_PRODIA := _nProD
Z70->Z70_LINHA  := _cEXT

Z70->Z70_USUREC := _cUsu
Z70->Z70_DTREC  := _dDTREC
Z70->Z70_HRREC  := _cHRREC
Z70->Z70_TIPO   := _nTipo
Z70->(MsUnlock())  
 
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

                



Static Function Consulta(dData )
cQ:=" select top 1 Z70_COD COD "                             + CHR(10)
cQ+=" FROM "+ RetSqlName( "Z70" ) +" Z70 " + CHR(10)
cQ+=" where Z70_DTREC = "+dTos(dData)    + CHR(10)


TCQUERY cQ NEW ALIAS "AUX1"

if AUX1->( !EOF() )
lRet:=.T.         //   tem
else
lRet:=.F.         // n Tem
endif
AUX1->(DBCLOSEAREA())
Return lRet    


***************
static  function Config()
***************

  local aOp    := {'SIM', 'Não' }
  local cTit   := 'Aviso'
  local cMsg   := 'Ja existem dados cadastrados para essa Data, Deseja alterar esses dados?'

return Aviso( cTit, cMsg, aOp )//<---- Numeric    
     


 
