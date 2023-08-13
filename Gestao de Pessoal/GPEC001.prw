#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :NEWSOURCE ³ Autor :TEC1 - Designer       ³ Data :14/06/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPEC001()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oGrp1","oTree1","oGrp2","oTree2","oGrp3","oTree3","oGrp5","oSay7","oSay8","oSay9")
SetPrvt("oSay11","oSay12","oGrp4","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGrp6","oSay13","oSay14")
SetPrvt("oSay16","oSay17","oSay18")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 135,234,735,1337,"Balanceamento de Funcionario",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 005,004,241,181," Turno 1 ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oTree1     := DbTree():New( 015,009,237,175,oGrp1,,,.F.,.F. ) 
oTree1:blDblClick := {||GPEC001A(oTree1)}
   oTree1:AddTree(PadR('C01',80), .T. )
                      //Titulo          Imagem do Item
   oTree1:AddTreeItem('00520 - Cyntia' ,"BR_AMARELO")
   oTree1:AddTreeItem('00535 - Katiane',"BR_AMARELO")
   oTree1:EndTree()

   oTree1:AddTree(PadR('C02',80), .T.)
   oTree1:AddTreeItem('00520 - Cyntia' ,"BR_VERMELHO")
   oTree1:AddTreeItem('00535 - Katiane',"BR_AMARELO")
   oTree1:EndTree()

oGrp2      := TGroup():New( 005,185,241,360," Turno 2 ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oTree2     := DbTree():New( 015,189,237,355,oGrp2,,,.F.,.F. )
oTree2:blDblClick := {||GPEC001A(oTree2)}
   oTree2:AddTree(PadR('C01',78), .T.)
   oTree2:AddTreeItem('000425 - Julia'       ,"BR_VERMELHO")
   oTree2:AddTreeItem('000358 - Ana Kristina',"BR_AMARELO")
   oTree2:EndTree()

   oTree2:AddTree(PadR('C02',80 ), .T.)
   oTree2:AddTreeItem('000425 - Julia'       ,"BR_VERMELHO")
   oTree2:AddTreeItem('000358 - Ana Kristina',"BR_AMARELO")
   oTree2:EndTree()

oGrp3      := TGroup():New( 005,365,241,542," Turno 3 ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oTree3     := DbTree():New( 015,370,237,535,oGrp3,,,.F.,.F. )
oTree3:blDblClick := {||GPEC001A(oTree3)}
   oTree3:AddTree(PadR('C01',78 ), .T.)
   oTree3:AddTreeItem('000258 - Riselma',"BR_VERMELHO")
   oTree3:AddTreeItem('000356 - Silvana',"BR_VERDE")
   oTree3:EndTree()

   oTree3:AddTree(PadR('C02',80 ), .F.)
   oTree3:AddTreeItem('000258 - Riselma',"BR_VERMELHO")
   oTree3:AddTreeItem('000356 - Silvana',"BR_AMARELO")
   oTree3:EndTree()

oGrp5      := TGroup():New( 244,004,289,181," Resumo ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay7      := TSay():New( 255,021,{||"Presentes:"},oGrp5,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,031,008)
oSay8      := TSay():New( 265,023,{||"Ausentes:"},oGrp5,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,029,008)
oSay9      := TSay():New( 275,011,{||"Em hora extra:"},oGrp5,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,041,008)
oSay10     := TSay():New( 254,056,{||"0"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 265,056,{||"0"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 276,056,{||"0"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrp4      := TGroup():New( 244,184,289,361," Resumo ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 255,201,{||"Presentes:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,031,008)
oSay2      := TSay():New( 265,203,{||"Ausentes:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,029,008)
oSay3      := TSay():New( 275,191,{||"Em hora extra:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,041,008)
oSay4      := TSay():New( 254,236,{||"0"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 265,236,{||"0"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 276,236,{||"0"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrp6      := TGroup():New( 244,365,289,542," Resumo ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay13     := TSay():New( 255,382,{||"Presentes:"},oGrp6,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,031,008)
oSay14     := TSay():New( 265,385,{||"Ausentes:"},oGrp6,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,029,008)
oSay15     := TSay():New( 275,372,{||"Em hora extra:"},oGrp6,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,041,008)
oSay16     := TSay():New( 254,418,{||"0"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay17     := TSay():New( 265,418,{||"0"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 276,418,{||"0"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oDlg1:Activate(,,,.T.)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :NEWSOURCE ³ Autor :TEC1 - Designer       ³ Data :14/06/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GPEC001A(oTree)

local nNivel

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cFunc      := Space(30)
Private cMat       := Space(6)
Private cTurno     := Space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oBtn1","oBtn2","oBtn3","oGrp1","oGet2","oSay2","oSay3","oGet3","oFld1","oBrw1","oBrw2")
SetPrvt("oBrw4","oSay1","oGet1")

nNivel := oTree:Nivel()
//Nivel da arvore referente ao funcionário
if nNivel > 1
   cMat := Subs(oTree:GetPrompt(),1,6)

   /*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
   ±± Definicao do Dialog e todos os seus componentes.                        ±±
   Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
   oDlg2      := MSDialog():New( 247,440,667,1010,"Opções",,,.F.,,,,,,.T.,,,.F. )
   oBtn1      := TButton():New( 026,006,"Hora Extra",oDlg2,,060,012,,,,.T.,,"",,,,.F. )
   oBtn2      := TButton():New( 008,006,"Alocar",oDlg2,,060,012,,,,.T.,,"",,,,.F. )
   oBtn3      := TButton():New( 044,006,"Fechar",oDlg2,,060,012,,,,.T.,,"",,,,.F. )
   oBtn3      :bAction := {|| oDlg2:End()}
   oGrp1      := TGroup():New( 006,072,196,273," Detalhes ",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
   oGet2      := TGet():New( 017,110,,oGrp1,046,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMat",,)
   oGet2:Disable()
   oGet2:bSetGet := {|u| If(PCount()>0,cMat:=u,cMat)}

   oSay2      := TSay():New( 018,082,{||"Matrícula:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,026,008)
   oSay3      := TSay():New( 034,077,{||"Funcionário:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,031,008)
      
   oGet3      := TGet():New( 033,110,,oGrp1,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFunc",,)
   oGet3:Disable()
   oGet3:bSetGet := {|u| If(PCount()>0,cFunc:=u,cFunc)}
   
   oSay1      := TSay():New( 019,185,{||"Turno Atual:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,006)
   oGet1      := TGet():New( 017,217,,oGrp1,046,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTurno",,)
   oGet1:Disable()
   oGet1:bSetGet := {|u| If(PCount()>0,cTurno:=u,cTurno)}
   

   oFld1      := TFolder():New( 053,077,{"Alocação","Horas Extras","Atrasos","Faltas"},{},oGrp1,,,,.T.,.F.,190,138,) 
//   DbSelectArea("<Inform Alias>")
//   oBrw1      := MsSelect():New( "<Inform Alias>","","",{{"","","Title",""}},.F.,,{004,004,119,181},,, oFld1:aDialogs[1] ) 
//   oBrw1:oBrowse:nClrPane := CLR_BLACK
//   oBrw1:oBrowse:nClrText := CLR_BLACK
//   DbSelectArea("<INFORM ALIAS>")
//   oBrw2      := MsSelect():New( "<INFORM ALIAS>","","",{{"","","Title",""}},.F.,,{004,004,119,181},,, oFld1:aDialogs[2] ) 
//   oBrw2:oBrowse:nClrPane := CLR_BLACK
//   oBrw2:oBrowse:nClrText := CLR_BLACK
//   DbSelectArea("<INFORM ALIAS>")
//   oBrw3      := MsSelect():New( "<INFORM ALIAS>","","",{{"","","Title",""}},.F.,,{004,004,119,181},,, oFld1:aDialogs[3] ) 
//   oBrw3:oBrowse:nClrPane := CLR_BLACK
//   oBrw3:oBrowse:nClrText := CLR_BLACK
//   DbSelectArea("<INFORM ALIAS>")
//   oBrw4      := MsSelect():New( "<INFORM ALIAS>","","",{{"","","Title",""}},.F.,,{004,004,119,181},,, oFld1:aDialogs[4] ) 
//   oBrw4:oBrowse:nClrPane := CLR_BLACK
//   oBrw4:oBrowse:nClrText := CLR_BLACK

   oDlg2:Activate(,,,.T.)

endif

Return