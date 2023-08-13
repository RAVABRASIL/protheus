#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :NEWSOURCE ³ Autor :TEC1 - Designer       ³ Data :28/09/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FTLBOBINA()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCodBo     := Space(12)
Private cNumCont   := '000001'
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oGCont","oBtn1","oBtn2","oGrp2","oSay2","oGet1","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Verdana",0,-27,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 137,254,635,1143,"Controle de Contagem de Bobina",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 003,004,079,435,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 011,139,{||"Numero da Contagem: "},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,279,016)
/*
oBtn1      := TButton():New( 030,032,"Iniciar",oGrp1,,080,026,,oFont1,,.T.,,"",,,,.F. )
oBtn1:bAction := {||cNumCont:=fIniciar()}
*/

oBtn2      := TButton():New( 030,309,"Finalizar",oGrp1,,079,027,,oFont1,,.T.,,"",,,,.F. )
oBtn2:bAction := {|| fFinal()}

oGrp2      := TGroup():New( 080,003,239,435,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 085,179,{||"BOBINA:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,067,016)
oGet1      := TGet():New( 103,139,,oGrp2,155,024,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodBo",,)
//oGet1:bChange := {||FATUALIZA()}
oGet1:bSetGet := {|u| If(PCount()>0,cCodBo:=u,cCodBo)}
oGet1:bValid  := {||FATUALIZA()}


oTbl1()
DbSelectArea("TMP")
//{"PESO","","Peso",""},;
oBrw1      := MsSelect():New( "TMP","","",{{"BOBINA","","Bobina",""},;
{"PRODUTO","","Produto",""},;
{"DESCRICAO","","Descricao",""},;
{"SALDO","","Saldo",""},;
{"MAQUINA","","Maquina",""}},.F.,,{136,004,233,431},,, oDlg1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK


cNumCont   := fComeca()
oGCont     := TGet():New( 031,139,,oGrp1,152,024,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNumCont",,)
oGCont:Disable()
oGCont:bSetGet := {|u| If(PCount()>0,cNumCont:=u,cNumCont)}



ObjectMethod( oGet1, "SetFocus()" )

oDlg1:Activate(,,,.T.)


TMP->(DBCloseArea())  
Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO


Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"BOBINA"   ,"C",012,000} )
Aadd( aFds , {"PRODUTO"  ,"C",006,000} )
Aadd( aFds , {"DESCRICAO","C",050,000} )
Aadd( aFds , {"SALDO"    ,"N",010,003} )
Aadd( aFds , {"PESO"     ,"N",010,003} )
Aadd( aFds , {"MAQUINA"  ,"C",003,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive
Return 



***************

Static Function FCONTAGEM()

***************

Local cQry:=" "
local cRet:="000001"

cQry:="select MAX(ZZ4_CONTAG) CONTAGEM  "
cQry+="from ZZ4020 ZZ4 "
cQry+="WHERE ZZ4.D_E_L_E_T_='' "


If Select("AUX1") > 0
  DbSelectArea("AUX1")
  AUX1->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX1"


If  ! AUX1->( EOF() )
   
cRet:=STRZERO(VAL(AUX1->CONTAGEM)+1,6)

endif


AUX1->(DbCloseArea())


Return cRet


***************

Static Function FIniciar()

***************

Local cQry:=" "
local cRet:=" "
LOCAL lLimpa:=.F.

cQry:="select DISTINCT ZZ4_CONTAG CONTAGEM  "
cQry+="from ZZ4020 ZZ4 "
cQry+="WHERE ZZ4.D_E_L_E_T_='' "
cQry+="AND ZZ4_CONTAG='"+cNumCont+"' AND ZZ4_STATUS<>'' "

If Select("AUX2") > 0
  DbSelectArea("AUX2")
  AUX2->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX2"


If  ! AUX2->( EOF() )
   
      cRet:=FCONTAGEM()
      lLimpa:=.T.
ELSE

    alert(" Favor Finalizar a Contagem "+ alltrim(cNumCont) +" Para Iniciar uma Nova.")
    cRet:=cNumCont
    lLimpa:=.F.
    
endif

AUX2->(DbCloseArea())


ObjectMethod( oGet1, "SetFocus()" )

IF lLimpa
   TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
ENDIF 

Return cRet


***************

Static Function FFinal()

***************

Local cQry:=" "
local cRet:=" "

if MsgBox( OemToAnsi( "Deseja FINALIZAR essa contagem "+alltrim(cNumCont)+" ??" ), "Escolha", "YESNO" )       

	if empty(cNumCont)
	   
	   alert('Favor Iniciar uma nova Contagem')
	   return 
	endif
	
	
	cQry:="select distinct ZZ4_STATUS,ZZ4_CONTAG CONTAGEM   "
	cQry+="from ZZ4020 ZZ4 "
	cQry+="WHERE ZZ4.D_E_L_E_T_='' "
	cQry+="AND ZZ4_CONTAG='"+cNumCont+"' "
	
	If Select("AUX3") > 0
	  DbSelectArea("AUX3")
	  AUX3->(DbCloseArea())
	EndIf
	
	TCQUERY cQry NEW ALIAS "AUX3"
	
	
	If  AUX3->( EOF() )
	
	    alert(" Essa Contagem ainda nao tem Bobina associada!!! ")
	    
	Else
	
	   if AUX3->ZZ4_STATUS='F'
	   
	     ALERT('Essa Contagem Já foi Finalizada. Favor abrir uma Nova Contagem') 
	     return
	     
	   ENDIF
	  
	  DbSelectArea("ZZ4")
	  ZZ4->( Dbsetorder( 2 ) )           
	  IF ZZ4->(DBSEEK(XFILIAL('ZZ4')+cNumCont))
	     
	    While ! ZZ4->(EOF()) .AND. ZZ4->ZZ4_FILIAL=XFILIAL('ZZ4') .AND. ZZ4->ZZ4_CONTAG=cNumCont
	  	   
	  	   RecLock("ZZ4",.F.)
		   ZZ4->ZZ4_STATUS:='F'
		   ZZ4->(MsUnLock())
	    
	       ZZ4->( DbSkip() )
	    
	    ENDDO
	    
	    ALERT('Contagem '+alltrim(cNumCont)+' Finalizada com Sucesso')
	    cNumCont:=fIniciar()
	  
	  ENDIF
	
	endif
	
	AUX3->(DbCloseArea())
	
	
	ObjectMethod( oGet1, "SetFocus()" )
	

endif



Return 


***************
Static Function Fatualiza()
***************

Local cQry:=''

/*  ANTES ERA SO PELA BOINA
DbSelectArea("ZZ4")
ZZ4->( Dbsetorder( 1 ) ) // BOBINA 
IF ZZ4->(DBSEEK(XFILIAL('ZZ4')+cCodBo))
   alert('Essa Bobina '+alltrim(cCodBo)+' Já foi Registrada.' )
   ObjectMethod( oGet1, "SetFocus()" )
   return 
endif
*/
if empty(cCodBo)
   
   return .t.

endif


// AGORA E POR BOBINA E CONTAGEM 

   if fValBoCon(cNumCont,cCodBo)
      
      ObjectMethod( oGet1, "SetFocus()" )
      return 

   endif
//


if empty(cNumCont)
   
   alert('Favor Iniciar uma nova Contagem')
   return 

endif

aInfBo:=fInfBo()

// GRAVA NA TABELA ZZ4
IF EMPTY(aInfBo[4])	

   alert('Essa Não e uma Bobina '+alltrim(cCodBo)+' Valida')
   
ELSE

	RecLock("ZZ4",.T.)
	ZZ4->ZZ4_FILIAL:=XFILIAL('ZZ4')
	ZZ4->ZZ4_BOBINA:=cCodBo
	ZZ4->ZZ4_PESO:=aInfBo[1]
	ZZ4->ZZ4_MAQ:=aInfBo[2]
	ZZ4->ZZ4_CODIGO:= Posicione( "SC2", 1, xFilial("SC2") +SUBSTR(cCodBo,1,6)+'01001' , "C2_PRODUTO" ) //aInfBo[3]
	ZZ4->ZZ4_DATHOR:=DTOS(DATE())+Left( Time(),5)
	ZZ4->ZZ4_CONTAG:=cNumCont
	ZZ4->(MsUnLock())
     
    ALERT('Bobina '+alltrim(cCodBo)+'Lida com Sucesso')

ENDIF	
		
cQry:="select *  "
cQry+="from ZZ4020 ZZ4 "
cQry+="WHERE ZZ4.D_E_L_E_T_='' "
cQry+="AND ZZ4_CONTAG='"+cNumCont+"' "
cQry+="AND ZZ4_STATUS='' "

If Select("AUX4") > 0
  DbSelectArea("AUX4")
  AUX4->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX4"


TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
AUX4->( DBGoTop() )

While  ! AUX4->( EOF() )

  RecLock("TMP",.T.)

  TMP->BOBINA:=AUX4->ZZ4_BOBINA
  TMP->SALDO:=fSaldoBO(cNumCont,AUX4->ZZ4_BOBINA)
  TMP->PESO:=AUX4->ZZ4_PESO
  TMP->MAQUINA:=AUX4->ZZ4_MAQ
  TMP->PRODUTO:=AUX4->ZZ4_CODIGO
  TMP->DESCRICAO:=Posicione( "SB1", 1, xFilial("SB1") + AUX4->ZZ4_CODIGO, "B1_DESC" )
  
  AUX4->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

ObjectMethod( oGet1, "SetFocus()" )
TMP->( DbGotop() )
AUX4->(DBCloseArea())
oBrw1:oBrowse:Refresh()

Return 
 

***************
Static Function Fcomeca()
***************

Local cQry:=''
local cRet :="000001" 


cQry:="select ZZ4_STATUS,ISNULL(MAX(ZZ4_CONTAG),'000001') CONTAGEM   "
cQry+="from ZZ4020 ZZ4 "
cQry+="WHERE ZZ4.D_E_L_E_T_='' "
cQry+="GROUP BY ZZ4_STATUS "

If Select("AUX5") > 0
  DbSelectArea("AUX5")
  AUX5->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX5"

iF  ! AUX5->( EOF() )
    if EMPTY(AUX5->ZZ4_STATUS) // EM ABERTO 
    
       cRet:=AUX5->CONTAGEM
    
    ELSE // FIANLIZADO 
    
        cRet:=STRZERO(VAL(AUX5->CONTAGEM)+1,6)
    
    ENDIF
    
ENDIF


cQry:="select *  "
cQry+="from ZZ4020 ZZ4 "
cQry+="WHERE ZZ4.D_E_L_E_T_='' "
cQry+="AND ZZ4_CONTAG='"+cRet+"' "

If Select("AUX6") > 0
  DbSelectArea("AUX6")
  AUX6->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX6"


TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
AUX6->( DBGoTop() )

While  ! AUX6->( EOF() )

  RecLock("TMP",.T.)


  TMP->BOBINA:=AUX6->ZZ4_BOBINA
  TMP->SALDO:=fSaldoBO(cNumCont,AUX6->ZZ4_BOBINA)
  TMP->PESO:=AUX6->ZZ4_PESO
  TMP->MAQUINA:=AUX6->ZZ4_MAQ
  TMP->PRODUTO:=AUX6->ZZ4_CODIGO
  TMP->DESCRICAO:=Posicione( "SB1", 1, xFilial("SB1") + AUX6->ZZ4_CODIGO, "B1_DESC" )
  
  AUX6->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

TMP->( DbGotop() )
AUX5->(DBCloseArea())
AUX6->(DBCloseArea())
oBrw1:oBrowse:Refresh()


Return cRet


***************
Static Function fInfBo()
***************

Local cQry:=''
local aRet:={}

cQry:="SELECT SUBSTRING(Z00_OP,1,6)+Z00_SEQ BOBINA,Z00_PESO,Z00_MAQ,C2_PRODUTO "
cQry+="FROM Z00020 Z00,SC2020 SC2 "
cQry+="WHERE SUBSTRING(Z00_OP,1,6)+Z00_SEQ='"+cCodBo+"' "
cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQry+="AND Z00.D_E_L_E_T_='' "
cQry+="AND SC2.D_E_L_E_T_='' "

If Select("AUX7") > 0
  DbSelectArea("AUX7")
  AUX7->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX7"

iF  ! AUX7->( EOF() )
    
    Aadd( aRet, AUX7->Z00_PESO )
    Aadd( aRet, AUX7->Z00_MAQ )
    Aadd( aRet, AUX7->C2_PRODUTO )    
    Aadd( aRet, AUX7->BOBINA )    

else

    Aadd( aRet, 0 )
    Aadd( aRet, " " )
    Aadd( aRet, " " )    
    Aadd( aRet, " " )    
    
ENDIF


return aRet


***************
Static Function fValBoCon(_cCont,_cBobi)
***************

Local cQry:=''
local lRet:=.F.

cQry:="SELECT * FROM ZZ4020 ZZ4 "
cQry+="WHERE ZZ4_CONTAG='"+_cCont+"' "
cQry+="AND ZZ4_BOBINA='"+_cBobi+"' "
cQry+="AND ZZ4.D_E_L_E_T_='' "

If Select("AUXB") > 0
  DbSelectArea("AUXB")
  AUXB->(DbCloseAreaB())
EndIf

TCQUERY cQry NEW ALIAS "AUXB"

iF  ! AUXB->( EOF() )
    
    lRet:=.T.
    alert("Essa Bobina "+alltrim(_cBobi)+" ja foi Registrada nessa contagem "+alltrim(_cCont) )

ENDIF


return lRet


***************
Static Function fSaldoBO(_cCont,_cBobi)
***************

Local cQry:=''
local nRet:=0


cQry:="select DISTINCT ZZ4_BOBINA,ZB9_SALDO "
cQry+="from ZZ4020 ZZ4, Z00020 Z00,SC2020 SC2 , ZB9020 ZB9 "
cQry+="where "
cQry+="ZZ4_FILIAL='"+xfilial('ZZ4')+"'  "
cQry+="AND ZZ4_BOBINA='"+_cBobi+"' "
cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN  "
cQry+="AND SUBSTRING(Z00_OP,1,6)+Z00_SEQ=ZZ4_BOBINA "

cQry+="AND C2_PRODUTO=ZB9_COD "
cQry+="AND Z00_SEQ=ZB9_SEQ "

cQry+="AND ZZ4.D_E_L_E_T_='' "
cQry+="AND Z00.D_E_L_E_T_='' "
cQry+="AND SC2.D_E_L_E_T_='' "
cQry+="AND ZB9.D_E_L_E_T_='' "

If Select("AUXS") > 0
  DbSelectArea("AUXS")
  AUXS->(DbCloseAreaB())
EndIf

TCQUERY cQry NEW ALIAS "AUXS"

iF  ! AUXS->( EOF() )
    
    nRet:=AUXS->ZB9_SALDO

ENDIF


return nRet




