#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTETIQ()³ Autor ³                       ³ Data ³20/09/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

*************

User Function ESTETIQ()

*************
Local nFunc
SetPrvt( "oDlg1,oGroup1,oGroup2,oBtn1,oBtn2,oBtn3,oGet1,oGet2,oGet3,oSBtn1,oSay1,oSay2,oSay3,oSay4,oSay5," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGet1 := Space(15)
Private nGet2 := 0
Private cGet3 := Space(12)

oDlg1      := MSDialog():New( 095,229,372,826,"Criação de Etiquetas",,,,,,,,,.T.,,, )
oGroup1    := TGroup():New( 003,100,131,293,"Info. Adicionais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGroup2    := TGroup():New( 003,004,131,096,oemToAnsi("Opções"),oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 031,012,"Reimprimir Etiqueta",oGroup2,{|| ativar(2),nFunc := 2 },076,012,,,,.T.,,,,,,.F. )
oBtn2      := TButton():New( 062,012,"Criar Etiqueta",oGroup2,{|| ativar(3),nFunc := 1 },076,012,,,,.T.,,,,,,.F. )
oBtn3      := TButton():New( 095,012,"Sair",oGroup2,{ || oDlg1:end() },076,012,,,,.T.,,,,,,.F. )
oGet1      := TGet():New( 098,121,{|u| If(PCount()>0,cGet1:=u,cGet1)},oGroup1,060,010,'',,CLR_BLACK,CLR_WHITE,;
						,,,.T.,,,,.F.,.F.,,.F.,.F.,"SB1","cGet1",,)
oGet2      := TGet():New( 098,210,{|u| If(PCount()>0,nGet2:=u,nGet2)},oGroup1,060,010,'@E 9,999.99',,CLR_BLACK,;
				        CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nGet2",,)
oGet3      := TGet():New( 098,121,{|u| If(PCount()>0,cGet3:=u,cGet3)},oGroup1,060,010,'',,CLR_BLACK,CLR_WHITE,;
                        ,,,.T.,,,,.F.,.F.,,.F.,.F.,"","cGet3",,)
oSBtn1     := SButton():New( 113,182,1,{ || iif(nFunc == 1 , CREATE( cGet1, nGet2 ),REPRINT( alltrim(cGet3) ) ) },;
                        oGroup1,,, )
oSay1      := TSay():New( 031,120,{||""},oGroup1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
oSay2      := TSay():New( 055,120,{||""},oGroup1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
oSay3      := TSay():New( 087,122,{||"Código do produto :"},oGroup1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay4      := TSay():New( 087,211,{||"Quantidade :"},oGroup1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,008)
oSay5      := TSay():New( 087,122,{||"Código de barras :"},oGroup1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,057,008)
ativar(1)

oDlg1:Activate()

Return

***************

Static Function Producao( cCodP, cCodBar, nQuant, nOpt )

***************

Local aMATRIZ := {}
lMsErroAuto := .F.

aMATRIZ := { { "D3_COD",     cCodP,             		   NIL },;
			 { "D3_TM",		 iif(nOpt == 1,'105',iif( nOpt == 2,'105', '505' ) ),   NIL },;
 			 { "D3_LOCAL",   iif(nOpt == 1, '01',iif( nOpt == 2, '02',  '02' ) ),   NIL },;
 			 { "D3_UM",      posicione("SB1",1,xFilial('SB1')+cCodP,"B1_UM"),       NIL },;
			 { "D3_QUANT",   nQuant,                       NIL },;
			 { "D3_OBS",     "PROD. TRANSFORMADO",         NIL },;
			 { "D3_EMISSAO", dDataBase,       			   NIL },;
			 { "D3_CODBAR" , cCodBar,   	               NIL } }
//{"D3_FILIAL",   xFilial('SD3'),               NIL },;
//Begin Transaction
	MSExecAuto( { | x,y | MATA240( x,y ) }, aMATRIZ, 3 )
	/*IF lMsErroAuto
//		DisarmTransaction()
		//Break
	Endif*/
//End Transaction
Return ! lMSErroAuto

***************

Static Function PROXSEQ()

***************

Local cSEQ
cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ

***************

Static Function ativar( nOpt )

***************

if nOpt == 1
  oSay3:lVisibleControl := .F.
  oSay4:lVisibleControl := .F.
  oSay5:lVisibleControl := .F.
  oGet1:lVisibleControl := .F.
  oGet2:lVisibleControl := .F.
  oGet3:lVisibleControl := .F.
elseIf nOpt == 2
  oSay3:lVisibleControl := .F.
  oSay4:lVisibleControl := .F.
  oGet1:lVisibleControl := .F.
  oGet2:lVisibleControl := .F.  
  
  oGet3:lVisibleControl := .T.
  oSay5:lVisibleControl := .T.
  objectMethod( oGet3,"SetFocus()") 
else  
  oSay5:lVisibleControl := .F.
  oGet3:lVisibleControl := .F.
  
  oGet1:lVisibleControl := .T.
  oSay3:lVisibleControl := .T.
  oGet2:lVisibleControl := .T.
  oSay4:lVisibleControl := .T.
  objectMethod( oGet1,"SetFocus()")
endIf

return

***************

Static Function REPRINT( cCodig )

***************
local aRet := {}
local cQuery := "select Z00_CODIGO, Z00_CODBAR, Z00_STATUS from Z00020 where Z00_CODBAR = '" + cCodig + "' and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
if TMP->( EoF() ) .OR. empty(cCodig)
	msgAlert("Código de barras inexistente!")
	objectMethod( oGet3,"SetFocus()")
	return TMP->( dbCloseArea() )
endIf
objectMethod( oSay1,"SetText(TMP->Z00_CODBAR)")
objectMethod( oSay1,"Refresh()")
objectMethod( oSay2,"SetText(TMP->Z00_CODIGO)")
objectMethod( oSay2,"Refresh()")

if ! msgYesNo("Deseja realmente reimprimir esta etiqueta?")
  return TMP->( dbCloseArea() )
endIf
aRET := u_senha2("10", 1, "Reimpressão de etiqueta")
if ! aRET[1]
  return
endIf
ETIQUE()
TMP->( dbCloseArea() )

return 

***************

Static Function CREATE( cCodig, nQuant )

*************** 
Local cBarraNv := ''
Local aRet := {}
local cQuery := ''
Private cCodigo := cCodig
Private cDescr := posicione("SB1", 1, xFilial('SB1') + cCodig, "B1_DESC" )
objectMethod( oSay1,"SetText(cCodigo)")
objectMethod( oSay1,"Refresh()")
objectMethod( oSay2,"SetText(cDescr)")
objectMethod( oSay2,"Refresh()")
SB5->( dbSeek( xFilial('SB5') + cCodig ) )
if nQuant > SB5->B5_QE2
  msgAlert("Entre com uma quantidade menor ou igual à quantidade final deste produto!")
  nGet2 := SB5->B5_QE2//objectMethod( oGet2,"SetText(1)")
  objectMethod( oGet2,"SetFocus()")
  return
endIf
if ! msgYesNo("Deseja realmente gerar este produto?")
  return
endIf
aRET := u_senha2("10", 1, "Reimpressão de etiqueta")
if ! aRET[1]
  return
endIf

cBarraNv := "777777" + ProxSeq()
/*
if ! Producao( cCodig, cBarraNv, nQuant/SB5->B5_QE2, iif(nQuant == SB5->B5_QE2, 1,  2 ) )
  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
  return
endIf*/
RecLock( "Z00", .T. )
Z00->Z00_SEQ    := ""//cSEQ - NÃO PRECISA
Z00->Z00_OP     := ""//cOP - NÃO PRECISA
Z00->Z00_PESO   := 0//nPESO - VER COM LINDENBERG A FÓRMULA PARA TRANSFORMAR O PESO A PARTIR DA QUANTIDADE
Z00->Z00_BAIXA  := "S"
Z00->Z00_MAQ    := ""//cMAQ - NÃO PRECISA
Z00->Z00_DATA   := dDataBase
Z00->Z00_HORA   := Left( Time(), 5 )
Z00->Z00_QUANT  := nQuant//nSACOS
Z00->Z00_PESDIF := 0//nDIFPESO * -1//nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
Z00->Z00_USULIM := "RECRIACAO"//cUSULIM - USUARIO LIBERADOR DE LIMITE DE OP, NÃO PRECISA
Z00->Z00_NOME   := aRET[2]  //cNOMUSUA - NOME DO USUÁRIO QUE PESOU, NESTE CASO SERÁ O DE QUEM TRANSFORMOU
Z00->Z00_CODBAR := cBarraNv
Z00->Z00_STATUS := "P"//criado e impresso
Z00->Z00_CDBRNV := ""
Z00->Z00_USUAR  := "TRANSFORMADOR"
Z00->Z00_CODIGO := cCodig
Z00->Z00_DATCON := dDataBase
Z00->( MsUnlock() )
ConfirmSX8()
Z00->( DbCommit() )
cQuery := "select Z00_CODIGO, Z00_CODBAR, Z00_STATUS from Z00020 where Z00_CODBAR = '" + cBarraNv + "' and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
ETIQUE()
return TMP->( dbCloseArea() ) 

***************

Static Function ETIQUE()

***************

aImp := {}

nHandle := nCont := 0

do while ! TMP->( EoF() )
  Aadd( aIMP, { "B" + iif( TMP->Z00_STATUS == 'F',"Produto: ", "Incompleto: ") +;
              AllTrim( TMP->Z00_CODIGO ), alltrim ( TMP->Z00_CODBAR ), TMP->Z00_STATUS } )
  nCont++
  TMP->( dbSkip() )
endDo
for x := 1 to nCont //len( aImp )
  If x > 1
    Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
  EndIf
If Abre_Impress()
  Inc_Linha( aIMP[ x, 1 ], .T. )
  Inc_Linha( aIMP[ x, 2 ], .F. )
  Fecha_Impress()
  // Pausa a cada etiqueta
EndIf
next

if msgYesNo("Reimprimir etiquetas ?")
  for x := 1 to nCont
    If x > 1
      Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
    EndIf
    If Abre_Impress()
      Inc_Linha( aIMP[ x, 1 ], .T. )
      Inc_Linha( aIMP[ x, 2 ], .F. )
      Fecha_Impress()
    // Pausa a cada etiqueta
    EndIf
  next
endIf

return

***************

Static Function Abre_Impress()

***************
cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, '3' )
Return .T.

***************

Static Function Inc_Linha( cIMP, lPRIMLINHA )

***************
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL

***************

Static Function Fecha_Impress()

***************
ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL

***************

Static Function Reimprime()

***************
aUSUARIO := u_senha2( "01", 2 )
If ! aUSUARIO[ 1 ]
	Return
EndIf
For nCONT := 1 To Len( aIMP )
		If Abre_Impress()
			 Inc_Linha( aIMP[ nCONT, 2 ], .T. )
			 Inc_Linha( aIMP[ nCONT, 4 ], .F. )
			 Fecha_Impress()
			 // Pausa a cada etiqueta
			 If Len( aIMP ) > 1 .and. nCONT <> Len( aIMP )
				  Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
			 EndIf
		EndIf
Next
Return NIL