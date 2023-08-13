#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'



*************

User Function POPHOSP()

*************

Local aIndex := {}

Local aCores := {{"EMPTY(Z83_STATUS)", "BR_VERDE"   },;		   			 
                 {"Z83_STATUS='C'", "BR_VERMELHO" }} 
                 
aRotina1 :={{"Area Privada","U_REPOPHPRI", 0, 6},;
            {"Area Publica","U_REPOPHPUB", 0, 6}}
            
aRotina := {{"Pesquisar"   , "AxPesqui"        , 0, 1},;
            {"Incluir"     , "U_TELAHOSP(3)"   , 0, 3},;
            {"Alterar"     , "U_TELAHOSP(4)"   , 0, 4},;    
            {"Relatorio"     , aRotina1          , 0, 6},;    
            {"Legenda"     , "U_LegPOP"        , 0, 6}} 


cCadastro := OemToAnsi("POP LINHA HOSPITALR " )

DbSelectArea("Z83" )
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z83",,,,,,aCores)



Return        



User Function TELAHOSP(nOpcX)

DbSelectArea("Z84" )
DbSetOrder(1)
Z84->(DbSeek( xFilial( "Z84" ) + Z83->Z83_CODIGO ) )


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
// VARIAVEIS AREA PRIVADA
Private lTaf11     := IIF(EMPTY(Z84->Z84_TAF11), .F.,.T.)
Private lTaf12     := IIF(EMPTY(Z84->Z84_TAF12), .F.,.T.)
Private lTaf13     := IIF(EMPTY(Z84->Z84_TAF13), .F.,.T.)
Private lTaf14     := IIF(EMPTY(Z84->Z84_TAF14), .F.,.T.)
Private lTaf15     := IIF(EMPTY(Z84->Z84_TAF15), .F.,.T.)
Private lTaf16     := IIF(EMPTY(Z84->Z84_TAF16), .F.,.T.)
Private lTaf17     := IIF(EMPTY(Z84->Z84_TAF17), .F.,.T.)
// VARIAVEIS AREA PUBLICA
Private lTaf21     := IIF(EMPTY(Z84->Z84_TAF21), .F.,.T.)
Private lTaf22     := IIF(EMPTY(Z84->Z84_TAF22), .F.,.T.)
Private lTaf23     := IIF(EMPTY(Z84->Z84_TAF23), .F.,.T.)
Private lTaf24     := IIF(EMPTY(Z84->Z84_TAF24), .F.,.T.)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlgPop","oGrp1","oSay1","oGetUF","oCBox1","oSay2","oGrp2","oSay3","oSay4","oSay5")
SetPrvt("oSay7","oSay8","oSay9","oTaf11","oTaf12","oTaf13","oTaf14","oTaf15","oTaf16","oTaf17","oGrp3")
SetPrvt("oSay11","oSay12","oTaf21","oTaf22","oTaf23","oTaf24","oSay13","oSBtn1","oSBtn2")
Private nOpc   := nOpcX

Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.
Private cAt:=''
cUF := Space(2)

Do Case
	Case nOpc = 2
		Visual 	:= .T.
	Case nOpc = 3
		Inclui 	:= .T.
		Altera 	:= .F.
	Case nOpc = 4
		Inclui 	:= .F.
		Altera 	:= .T.
	Case nOpc = 5
		Exclui	:= .T.
		Visual	:= .T.
    Case nOpc = 7
		Inclui 	:= .F.
		Altera 	:= .T.
	
EndCase



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgPop    := MSDialog():New( 127,254,311,1194,"POP Linha Hospitalar",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,004,024,159,"",oDlgPop,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 008,007,{||"UF: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
//oGetUF     := TGet():New( 007,019,,oGrp1,016,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cCUF",,)
oGetUF     := TGet():New( 007,019,,oGrp1,024,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUF",,)
oGetUF:bSetGet := {|u| If(PCount()>0,cUF:=u,cUF)}
oGetUF:bValid := {||PesqUF(cUF)}

oCBox1     := TComboBox():New( 007,080,{|u| if(Pcount()>0,cAt:=u,cAt)},{"Privada","Publica"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cAt ) 
IF INCLUI
   oCBox1:nAt:=1      
ENDIF
IF ALTERA
   oCBox1:nAt:=VAL(Z83->Z83_AREA)      
ENDIF


oCBox1:bVALID := {||PesqArea(oCBox1:nAt)}
oSay2      := TSay():New( 008,064,{||"Area:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrp2      := TGroup():New( 024,004,064,462,"Area Privada",oDlgPop,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 036,007,{||"Mapeamento |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay4      := TSay():New( 036,053,{||"Analise do Mapeamento |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,008)
oSay5      := TSay():New( 036,131,{||"Plano de Ação |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,008)
oSay6      := TSay():New( 036,180,{||"Def. do Distr. Parceiro |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,008)
oSay7      := TSay():New( 036,251,{||"Prop. Especial p/ Distr. |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,008)
oSay8      := TSay():New( 036,324,{||"Denúncias |"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,008)
oSay9      := TSay():New( 036,367,{||"Finalização Palno de Ação"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,081,008)
oTaf11     := TCheckBox():New( 046,007,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )     
oTaf11:bSetGet := {|u| If(PCount()>0,lTaf11:=u,lTaf11)}
oTaf12     := TCheckBox():New( 046,053,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf12:bSetGet := {|u| If(PCount()>0,lTaf12:=u,lTaf12)}
oTaf13     := TCheckBox():New( 046,131,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf13:bSetGet := {|u| If(PCount()>0,lTaf13:=u,lTaf13)}
oTaf14     := TCheckBox():New( 046,180,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf14:bSetGet := {|u| If(PCount()>0,lTaf14:=u,lTaf14)}
oTaf15     := TCheckBox():New( 046,251,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf15:bSetGet := {|u| If(PCount()>0,lTaf15:=u,lTaf15)}
oTaf16     := TCheckBox():New( 046,324,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf16:bSetGet := {|u| If(PCount()>0,lTaf16:=u,lTaf16)}
oTaf17     := TCheckBox():New( 046,367,"Concluido",,oGrp2,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf17:bSetGet := {|u| If(PCount()>0,lTaf17:=u,lTaf17)}
oGrp3      := TGroup():New( 024,004,064,265,"Area Publica",oDlgPop,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay10     := TSay():New( 036,007,{||"Montar Equipe de Venda |"},oGrp3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,083,008)
oSay11     := TSay():New( 036,084,{||"Mapeamento |"},oGrp3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,008)
oSay12     := TSay():New( 036,128,{||"Plano de Ação |"},oGrp3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,008)
oTaf21     := TCheckBox():New( 046,007,"Concluido",,oGrp3,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf21:bSetGet := {|u| If(PCount()>0,lTaf21:=u,lTaf21)}
oTaf22     := TCheckBox():New( 046,084,"Concluido",,oGrp3,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf22:bSetGet := {|u| If(PCount()>0,lTaf22:=u,lTaf22)}
oTaf23     := TCheckBox():New( 046,128,"Concluido",,oGrp3,036,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf23:bSetGet := {|u| If(PCount()>0,lTaf23:=u,lTaf23)}
oTaf24     := TCheckBox():New( 046,175,"Concluido",,oGrp3,036,006,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oTaf24:bSetGet := {|u| If(PCount()>0,lTaf24:=u,lTaf24)}
oSay13     := TSay():New( 036,175,{||"Finalização Palno de Ação"},oGrp3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,081,008)
oSBtn1     := SButton():New( 072,155,1,,oDlgPop,,"", )
oSBtn1:bAction := {||OK(cUF,oCBox1:nAt),oDlgPop:end() }

oSBtn2     := SButton():New( 072,215,2,,oDlgPop,,"", )
oSBtn2:bAction := {||oDlgPop:end()}


IF Inclui
   oCBox1:lReadOnly := .F.
   oGetUF:lReadOnly := .F.
	   
   // AREA PRIVADA
   oGrp2:lVisibleControl:=.F. 
   oGrp2:lVisibleControl:=.T. // VISIVEL  
   oSay3:lVisibleControl:=.T. // VISIVEL  
   oSay4:lVisibleControl:=.T. // VISIVEL  
   oSay5:lVisibleControl:=.T. // VISIVEL  
   oSay6:lVisibleControl:=.T. // VISIVEL  
   oSay7:lVisibleControl:=.T. // VISIVEL  
   oSay8:lVisibleControl:=.T. // VISIVEL  
   oSay9:lVisibleControl:=.T. // VISIVEL  
   oTaf11:lVisibleControl:=.F.
   oTaf12:lVisibleControl:=.F.
   oTaf13:lVisibleControl:=.F. 
   oTaf14:lVisibleControl:=.F. 
   oTaf15:lVisibleControl:=.F. 
   oTaf16:lVisibleControl:=.F. 
   oTaf17:lVisibleControl:=.F. 		
   // AREA PUBLICA 
   oGrp3:lVisibleControl:=.F.  
   oSay10:lVisibleControl:=.F.  
   oSay11:lVisibleControl:=.F.  
   oSay12:lVisibleControl:=.F.  
   oTaf21:lVisibleControl:=.F.  
   oTaf22:lVisibleControl:=.F.  
   oTaf23:lVisibleControl:=.F.  
   oTaf24:lVisibleControl:=.F.  
   oSay13:lVisibleControl:=.F.  

ENDIF 

IF altera
   
   cUF:=Z83->Z83_UF
   
   if ALLTRIM(Z83->Z83_AREA)='1'
	   
	   if LTaf11
	      oTaf11:Disable() 
	   endif
	   
	   if LTaf12
	      oTaf12:Disable() 
	   endif
	   
	   if LTaf13
	      oTaf13:Disable() 
	   endif
	   
	   if LTaf14
	      oTaf14:Disable() 
	   endif
	   
	   if LTaf15
	      oTaf15:Disable() 
	   endif
	   
	   if LTaf16
	      oTaf16:Disable() 
	   endif
	   
	   if LTaf17
	      oTaf17:Disable() 
	   endif
	   
	   
	   // GET DA UF E COMBO DA AREA 
	   oCBox1:nAt:=1  
	   oCBox1:lReadOnly := .T.  
	   oCBox1:Disable() 
	   oGetUF:lReadOnly := .T.
	   oGetUF:Disable() 
	   // AREA PRIVADA
	   oGrp2:lVisibleControl:=.T. // VISIVEL   
	   oGrp2:lVisibleControl:=.T. // VISIVEL  
	   oSay3:lVisibleControl:=.T. // VISIVEL  
	   oSay4:lVisibleControl:=.T. // VISIVEL  
	   oSay5:lVisibleControl:=.T. // VISIVEL  
	   oSay6:lVisibleControl:=.T. // VISIVEL  
	   oSay7:lVisibleControl:=.T. // VISIVEL  
	   oSay8:lVisibleControl:=.T. // VISIVEL  
	   oSay9:lVisibleControl:=.T. // VISIVEL  
	   oTaf11:lVisibleControl:=.T. // VISIVEL  
	   oTaf12:lVisibleControl:=.T. // VISIVEL  
	   oTaf13:lVisibleControl:=.T. // VISIVEL   
	   oTaf14:lVisibleControl:=.T. // VISIVEL   
	   oTaf15:lVisibleControl:=.T. // VISIVEL   
	   oTaf16:lVisibleControl:=.T. // VISIVEL   
	   oTaf17:lVisibleControl:=.T. // VISIVEL   		
	   // AREA PUBLICA 
	   oGrp3:lVisibleControl:=.F.  
	   oSay10:lVisibleControl:=.F.  
	   oSay11:lVisibleControl:=.F.  
	   oSay12:lVisibleControl:=.F.  
	   oTaf21:lVisibleControl:=.F.  
	   oTaf22:lVisibleControl:=.F.  
	   oTaf23:lVisibleControl:=.F.  
	   oTaf24:lVisibleControl:=.F.  
	   oSay13:lVisibleControl:=.F.  
   ELSEif ALLTRIM(Z83->Z83_AREA)='2' // PUBLICA 
	  
	   if LTaf21
	      oTaf21:Disable() 
	   endif
	   
	   if LTaf22
	      oTaf22:Disable() 
	   endif
	   
	   if LTaf23
	      oTaf23:Disable() 
	   endif
	   
	   if LTaf24
	      oTaf24:Disable() 
	   endif
	   
	   // GET DA UF E COMBO DA AREA 
	   oCBox1:nAt:=2
	   oCBox1:lReadOnly := .T.  
	   oCBox1:Disable() 
	   oGetUF:lReadOnly := .T.
	   oGetUF:Disable() 
	   // area privada 
	   oGrp2:lVisibleControl:=.F. // VISIVEL   
	   oGrp2:lVisibleControl:=.F. // VISIVEL  
	   oSay3:lVisibleControl:=.F. // VISIVEL  
	   oSay4:lVisibleControl:=.F. // VISIVEL  
	   oSay5:lVisibleControl:=.F. // VISIVEL  
	   oSay6:lVisibleControl:=.F. // VISIVEL  
	   oSay7:lVisibleControl:=.F. // VISIVEL  
	   oSay8:lVisibleControl:=.F. // VISIVEL  
	   oSay9:lVisibleControl:=.F. // VISIVEL  
	   oTaf11:lVisibleControl:=.F. // VISIVEL  
	   oTaf12:lVisibleControl:=.F. // VISIVEL  
	   oTaf13:lVisibleControl:=.F. // VISIVEL   
	   oTaf14:lVisibleControl:=.F. // VISIVEL   
	   oTaf15:lVisibleControl:=.F. // VISIVEL   
	   oTaf16:lVisibleControl:=.F. // VISIVEL   
	   oTaf17:lVisibleControl:=.F. // VISIVEL   		
	   // AREA PUBLICA 
	   oGrp3:lVisibleControl:=.T.  
	   oSay10:lVisibleControl:=.T.  
	   oSay11:lVisibleControl:=.T.  
	   oSay12:lVisibleControl:=.T.  
	   oTaf21:lVisibleControl:=.T.  
	   oTaf22:lVisibleControl:=.T.  
	   oTaf23:lVisibleControl:=.T.  
	   oTaf24:lVisibleControl:=.T.  
	   oSay13:lVisibleControl:=.T.  
	   
   ENDIF
   
ENDIF       

oDlgPop:Activate(,,,.T.)

Return         


***************

Static Function Ok(cUF,nAt)

***************


if INCLUI
	
	if Z83->(DbSeek( xFilial( "Z83" ) +upper(cUF)+transform( nAt,  "@E 9")) )
	   ALERT('Ja existe Registro para esse estado '+upper(alltrim(cuf)) )
	   RETURN 
	ENDIF
	
	
	cNum := GetSx8Num( "Z83", "Z83_CODIGO" )
	// cabeçlho do pop
	RecLock( "Z83", .T. )
	Z83->Z83_FILIAL:=XFILIAL('Z83')
	Z83->Z83_CODIGO:= cNum
	Z83->Z83_UF:=upper(cUF)
	Z83->Z83_AREA:=transform( nAt,  "@E 9") // 1-privada;2-publica 
	Z83->( MsUnlock() )
	ConfirmSX8()
	Z83->( DbCommit() )
	
	// tarefas do pop 
	RecLock( "Z84", .T. )
	Z84->Z84_FILIAL:=XFILIAL('Z84')
	Z84->Z84_IDPOP:= cNum
	Z84->( MsUnlock() )
	ConfirmSX8()
	Z84->( DbCommit() )
//	Alert('Cadastro Realizado com Sucesso!!!')
	
ENDIF

IF ALTERA
	DbSelectArea("Z84" )
	DbSetOrder(1)
	if Z84->(DbSeek( xFilial( "Z84" ) + Z83->Z83_CODIGO ) )
	   IF Z83->Z83_AREA='1' // PRIVADO
	      RecLock( "Z84", .F. )
	      Z84->Z84_TAF11:= iif(lTaf11,'C','')
	      Z84->Z84_TAF12:= iif(lTaf12,'C','')
	      Z84->Z84_TAF13:= iif(lTaf13,'C','')
	      Z84->Z84_TAF14:= iif(lTaf14,'C','')
	      Z84->Z84_TAF15:= iif(lTaf15,'C','')
	      Z84->Z84_TAF16:= iif(lTaf16,'C','')
	      Z84->Z84_TAF17:= iif(lTaf17,'C','')	   
	      Z84->( MsUnlock() )
	      if lTaf11 .and. lTaf12 .and. lTaf13 .and. lTaf14 .and. lTaf15 .and. lTaf16 .and. lTaf17
	         RecLock( "Z83", .F. )
	         Z83->Z83_STATUS:='C'
	         Z83->( MsUnlock() )
	      endif
	   ELSEIF Z83->Z83_AREA='2' // PUBLICO
	      RecLock( "Z84", .F. )
	      Z84->Z84_TAF21:= iif(lTaf21,'C','')
	      Z84->Z84_TAF22:= iif(lTaf22,'C','')
	      Z84->Z84_TAF23:= iif(lTaf23,'C','')
	      Z84->Z84_TAF24:= iif(lTaf24,'C','')
	      Z84->( MsUnlock() )  
	      if lTaf21 .and. lTaf22 .and. lTaf23 .and. lTaf24 
	         RecLock( "Z83", .F. )
	         Z83->Z83_STATUS:='C'
	         Z83->( MsUnlock() )
	      endif
	   ENDIF
	   
    ENDIF
//    ALERT('ALTERACAO REALIZADA COM SUCESSO!!!')
ENDIF



Return              


***************

Static Function PesqUF(cUF)

***************

if empty(cUF)
   alert('O Estado e obrigatorio!!')
   Return .F.  
endif

cUF:=UPPER(cUF)


Return .T.  



***************

Static Function PesqArea(nAt)

***************

IF nAt=1
   // AREA PRIVADA 
   oGrp2:lVisibleControl:=.T. // VISIVEL  
   oSay3:lVisibleControl:=.T. // VISIVEL  
   oSay4:lVisibleControl:=.T. // VISIVEL  
   oSay5:lVisibleControl:=.T. // VISIVEL  
   oSay6:lVisibleControl:=.T. // VISIVEL  
   oSay7:lVisibleControl:=.T. // VISIVEL  
   oSay8:lVisibleControl:=.T. // VISIVEL  
   oSay9:lVisibleControl:=.T. // VISIVEL  

   // AREA PUBLICA 
   oGrp3:lVisibleControl:=.F.  
   oSay10:lVisibleControl:=.F.  
   oSay11:lVisibleControl:=.F.  
   oSay12:lVisibleControl:=.F.  
   oSay13:lVisibleControl:=.F.  


ELSEIF nAt=2
   // AREA PRIVADA
   oGrp2:lVisibleControl:=.F. 
   oSay3:lVisibleControl:=.F. 
   oSay4:lVisibleControl:=.F. 
   oSay5:lVisibleControl:=.F. 
   oSay6:lVisibleControl:=.F.
   oSay7:lVisibleControl:=.F. 
   oSay8:lVisibleControl:=.F. 
   oSay9:lVisibleControl:=.F. 
   // AREA PUBLICA 
   oGrp3:lVisibleControl:=.T.
   oSay10:lVisibleControl:=.T.
   oSay11:lVisibleControl:=.T.
   oSay12:lVisibleControl:=.T.
   oSay13:lVisibleControl:=.T.

ENDIF

Return .T. 



*************

User Function LegPOP()

*************

Local aLegenda := {{"BR_VERDE"     ,"Em Aberto" },;
   	   			   {"BR_VERMELHO" ,"Concluido" }}


BrwLegenda("POP Linha Hospitalar","Legenda",aLegenda)		   		

Return .T.

