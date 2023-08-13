#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'rwmake.ch'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
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

User Function ESTCONV2()

Private cMarca := ''
Private aArray := {}
Private lClose := .F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 088,228,405,1007,"Conversão de Inacabados",,,,,,,,,.T.,,, )
oGrp1      := TGroup():New( 004,003,124,383,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 127,003,152,383,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 135,132,"Transformar",oGrp2,{||transformar()},037,012,,,,.T.,,"",,,,.F. )
//oBtn2      := TButton():New( 135,180,"Amostra",oGrp2,{||amostras()},037,012,,,,.T.,,"",,,,.F. )tpAmostra()
oBtn2      := TButton():New( 135,180,"Amostra",oGrp2,{||tpAmostra()},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 135,228,"Sair",oGrp2,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

cMarca     := getMark()
criaArq()
oBrw1      := MsSelect():New( "TEMP","MARCA","",;
{{ "MARCA", ,    ""                    },;
 {"B2_COD","","Codigo",""              },;
 {"B1_DESC","","Descricao",""          },;
 {"FINAL","","Quantidade em Estoque",""},;
 {"B5_QTDFIM","","Quanti Emb. Final",""}},;
.F.,cMarca,{011,007,119,379},,, oGrp1 ) 

oDlg1:Activate(,,,.T.)

Return TEMP->( dbCloseArea() )

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ criaArq() Função que preenche o msselect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function criaArq()

Local cQuery := ''
Local cARQ
aArray := {}//Importante para não duplicar a transformação
cQuery := "select B2_COD, B1_DESC, B2_QATU * B5_QE2 FINAL, B5_QTDFIM, B5_QE2, '  ' MARCA  "
cQuery += "from " + retSqlName('SB2') + " SB2 join " + retSqlName('SB1') + " SB1 "
cQuery += "on B1_COD + '02' = B2_COD + B2_LOCAL "
cQuery += "join " + retSqlName('SB5') + " SB5 on B5_COD = B1_COD  "
cQuery += "where  B2_QATU > 0 and B1_ATIVO = 'S' and B1_TIPO = 'PA' "//and B2_COD = 'AFA035' "
cQuery += "and SB2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SB5.D_E_L_E_T_ != '*'  "
cQuery += "order by B2_COD "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )

cARQ := CriaTrab( , .F. )
copy to (cARQ)
TMP->( dbCloseArea() )
DbUseArea( .T.,, cARQ, "TEMP", .F., .F. )
TEMP->( dbGoTop() )
do While ! TEMP->( EoF() )
  if TEMP->FINAL >= TEMP->B5_QTDFIM
    TEMP->MARCA := cMarca
    aAdd( aArray, {TEMP->B2_COD, int( TEMP->FINAL / TEMP->B5_QTDFIM ) * TEMP->B5_QTDFIM,;//totalmente redundante
                   TEMP->FINAL%TEMP->B5_QE2, TEMP->B5_QTDFIM  } )
    					 //Qtd Final
  endIf
  TEMP->( dbSkip() )
endDo
TEMP->( dbGoTop() )

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Producao( cCodP, cCodBar, nQuant, nOpt )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function Producao( cCodP, cCodBar, nQuant, nOpt )

Local aMATRIZ := {}
lMsErroAuto := .F.

aMATRIZ :={{ "D3_COD",     cCodP,             	                                                         NIL },;
	        { "D3_TM",	   iif(nOpt == 1,'105',iif( nOpt == 2,'105', iif( nOpt == 3,'505', '505') ) ),   NIL },;
	        { "D3_LOCAL",   iif(nOpt == 1, '01',iif( nOpt == 2, '02', iif( nOpt == 3, '02',  '01') ) ),   NIL },;
 	        { "D3_UM",      posicione("SB1",1,xFilial('SB1')+cCodP,"B1_UM"),                              NIL },;
	        { "D3_QUANT",   nQuant,                                                                       NIL },;
	        { "D3_OBS",     "PROD. TRANSFORMADO",                                                         NIL },;
	        { "D3_EMISSAO", dDataBase,			                                                            NIL },;
	        { "D3_CODBAR" , cCodBar,                                                                      NIL } }			 

	MSExecAuto( { | x,y | MATA240( x,y ) }, aMATRIZ, 3 )

Return ! lMSErroAuto


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ proxseq()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function PROXSEQ()

Local cSEQ
cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ transformar()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function transformar()

Local x := y   := 0
Local cBarraNv := cTransf := ""
Local aRET     := {}
Local aMATRIZ  := {}
lMsErroAuto    := .F.

if len( aArray ) <= 0
  msgalert('Não há produtos a serem transformados.')
  return
endIf

aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf
dbSelectArea('SB5')
for x := 1 to len( aArray )
  SB5->( dbSeek( xFilial('SB5') + aArray[x][1] ), .F. )
  cTransf := ProxSeq();ConfirmSX8()
  if ! Producao( aArray[x][1], '', aArray[x][2]/SB5->B5_QE2, 3 )
    msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
    msgAlert("Transformação nº " + cTransf )
    return
  endIf
  for z := 1 to aArray[x][2]/aArray[x][4]
    cBarraNv := "999999" + ProxSeq()
    if ! Producao( aArray[x][1], cBarraNv, aArray[x][4]/SB5->B5_QE2, 1 )
      msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
      msgAlert("Transformação: " + cTransf )
      return
    endIf
    RecLock( "Z00", .T. )
    Z00->Z00_SEQ    := "999999"
    Z00->Z00_OP     := ""
    Z00->Z00_PESO   := ( SB5->B5_LARG * SB5->B5_COMPR * SB5->B5_ESPESS * SB5->B5_DENSIDA * aArray[x][4] ) / 1000
    Z00->Z00_BAIXA  := "S"
    Z00->Z00_MAQ    := ""
    Z00->Z00_DATA   := dDataBase
    Z00->Z00_HORA   := Left( Time(), 5 )
    Z00->Z00_QUANT  := aArray[x][4]
    Z00->Z00_PESDIF := 0
    Z00->Z00_USULIM := "TRANSFORMADOR"
    Z00->Z00_NOME   := aRET[2]
    Z00->Z00_CODBAR := cBarraNv
    Z00->Z00_STATUS := "F"
    Z00->Z00_CDBRNV := cTransf
    Z00->Z00_USUAR  := "TRANSFORMADOR"
    Z00->Z00_CODIGO := aArray[x][1]
    Z00->Z00_DATCON := dDataBase
    Z00->( MsUnlock() )
    ConfirmSX8()
    Z00->( DbCommit() )
  next  
next
TEMP->( __dbZap()     )	
TEMP->( dbCloseArea() )
criaArq()
msgAlert("Produto(s) transformado(s) com sucesso.")	
return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ amostras()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function amostras()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGet10      := Space(15)
Private nGet20      := 0
Private cGet30      := Space(12)
Private lAmostra    := .F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt( "oFont10","oFont20","oSay20","oSay50","oSay60","oSay40","oSay30","oSay10","oGet10","oGrp10","oGet20","oBtn10")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg10  := MSDialog():New( 212,414,402,740,"Gerar Amostra",,,,,,,,,.T.,,, )
oGrp10  := TGroup():New( 002,004,089,158,"",oDlg10,CLR_BLACK,CLR_WHITE,.T.,.F. )
oFont10 := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oFont20 := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oSay20  := TSay():New( 014,072,{||""},oGrp10,,oFont20,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
oSay50  := TSay():New( 042,016,{||"Cd. de Barras :"},oGrp10,,oFont10,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,044,008)
oSay60  := TSay():New( 042,072,{||""},oGrp10,,oFont20,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
oSay40  := TSay():New( 026,072,{||""},oGrp10,,oFont20,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
oSay30  := TSay():New( 027,016,{||"Quantidade :"},oGrp10,,oFont10,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,044,008)
oSay10  := TSay():New( 014,016,{||"Produto :"},oGrp10,,oFont10,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,044,008)
oGet10  := TGet():New( 059,010,{|u| If(PCount()>0,cGet10:=u,cGet10)},oGrp10,060,010,'',{|| valProd( cGet10 ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGet10",,)
oGet20  := TGet():New( 059,090,{|u| If(PCount()>0,nGet20:=u,nGet20)},oGrp10,060,010,'999,999.99',{ || busca(cGet10, nGet20) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGet20",,)
//oBtn10  := TButton():New( 074,015,"Buscar",oGrp10, {||busca(cGet10, nGet20)},037,012,,,,.T.,,"",,,,.F. )
//063 107
oBtn20  := TButton():New( 074,040,"Transformar",oGrp10,{||quebra( cGet10, cGet30, nGet20, iif( lAmostra, oSay40:cCaption , '0' ) ) },037,012,,,,.T.,,"",,,,.F. )
oBtn30  := TButton():New( 074,084,"Sair",oGrp10,{|| oDlg10:End() },037,012,,,,.T.,,"",,,,.F. )
//oBtn30  := SButton():New( 074, 084, 1, { || oDlg10:End() }, oGrp10, , "", )
//@ 243,330 BMPButton Type 2 Action oDlg1:End() 
oGet30  := TGet():New( 059,052,{|u| If(PCount()>0,cGet30:=u,cGet30)},oGrp10,060,010,'',{|| busca2(cGet30,cGet10)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet30",,)
oBtn40  := TButton():New( 074,061,"Selecionar",oGrp10,{||busca3(cGet30,cGet10)},037,012,,,,.T.,,"",,,,.F. )
oSay60:lVisible := .F.;oGet30:lVisible := .F.;oBtn40:lVisible := .F.;oSay50:lVisible := .F.;oBtn20:lActive := .F.
//oBtn40:lActive := .F.
oDlg10:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ busca()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function busca( cCodigo, nQtd )
dbSelectArea('SB2');dbSelectArea('SB1')
if empty(cCodigo) //.or. !SB2->( DBSeek( xFilial('SB2') + padr(cCodigo,15) + '02', .F.) )
  msgAlert("Insira um produto válido!")
  objectMethod( oGet10,"SetFocus()")
  return
elseIf !SB2->( DBSeek( xFilial('SB2') + padr(cCodigo,15) + '02', .F.) )
  if SB2->( DBSeek( xFilial('SB2') + padr(cCodigo,15) + '01', .F.) )
     RecLock("SB2",.T.)
     SB2->B2_FILIAL := xFilial("SB2")
     SB2->B2_COD    := padr(cCodigo,15)
     SB2->B2_LOCAL  := "02"
	  SB2->(MsUnLock())
	else
     msgAlert("Insira um produto válido!")
     objectMethod( oGet10,"SetFocus()")
     return	
	endIf  
endIf
if nQtd >= posicione("SB5",1,xFilial('SB1')+padr(cCodigo,15),"B5_QTDFIM")//VER ISSO AQUI!!!
  msgAlert("Insira apenas a parte quebrada da amostra!")
  objectMethod( oGet20,"SetFocus()")
  return
elseIf nQtd <= 0
  msgAlert("Insira uma quantidade válida!")
  objectMethod( oGet20,"SetFocus()")
  return
endIf

if SB2->B2_QATU * SB5->B5_QE2 >= nQtd
  oSay20:lVisible := .T.
  ObjectMethod(oSay20, "setText( posicione('SB1',1,xFilial('SB1')+SB2->B2_COD,'B1_DESC') )")
  ObjectMethod(oSay20, "Refresh()"  )
  oSay40:lVisible := .T.
  ObjectMethod(oSay40,"setText(transform(SB2->B2_QATU * SB5->B5_QE2, '@E 999,999.999'))" )
  ObjectMethod(oSay40, "Refresh()"  )
  oBtn20:lActive := .T.
  objectMethod( oBtn20,"SetFocus()")
  lAmostra := .F.
else
  if msgYesNo("Deseja abrir um fardo fechado ?")
    /*oBtn10:lVisible :=.F.;*/oBtn20:lVisible := .F.;oBtn30:lVisible := .F.;oGet10:lVisible := .F.;oGet20:lVisible :=.F.
    oGet30:lVisible :=.T.;oBtn40:lVisible := .T.;oSay50:lVisible := .T.;oSay60:lVisible := .T.
    objectMethod( oGet30,"SetFocus()")
    lAmostra := .T. 
  else
    Return
  endIf
endIf

return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ busca2()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function busca2( cCodigo, cPrd )
  dbSelectArea('Z00')
  Z00->( dbSetOrder(7) )
  if !Z00->( dbSeek(xFilial('Z00') + padr(cCodigo,15), .F. ) )
     msgAlert("O código de barras inválido!")
    objectMethod( oGet30,"SetFocus()")
    Return
  endIf
  if alltrim(Z00->Z00_CODIGO) == alltrim(cPrd)
    ObjectMethod(oSay20, "setText(alltrim(Z00->Z00_CODIGO))")
    ObjectMethod(oSay20, "Refresh()"  )
    ObjectMethod(oSay40, "setText(transform(Z00->Z00_QUANT,'@E 999,999.99'))" )
    ObjectMethod(oSay40, "Refresh()"  )
    ObjectMethod(oSay60, "setText(Z00->Z00_CODBAR)" )
    ObjectMethod(oSay60, "Refresh()"  )
    oBtn40:lActive := .T.
  else
    msgAlert("O código de barras não de um produto igual ao pesquisado!")
    objectMethod( oGet30,"SetFocus()")
  endIf
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ busca3()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function busca3( cCodigo, cPrd )
  /*oBtn10:lVisible :=.T.;*/oBtn20:lVisible := .T.;oBtn30:lVisible := .T.;oGet10:lVisible := .T.;oGet20:lVisible :=.T.
  oGet30:lVisible :=.F.;oBtn40:lVisible := .F.;oBtn20:lActive := .T.//oBtn10:lActive := .F.;
  objectMethod( oBtn20,"SetFocus()");oGet10:lActive := .T.;oGet20:lActive :=.T.
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ quebra()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function quebra( cCodigo, cCodbar, nAmostra, cSobra )
Local cTransf := cBarraNv := ""
Local nCount := 1
Local aRet := {}
Local nSobra := 0
/**/
nSobra := val(strtran(strtran (cSobra,".",""),",","."))
/**/
/**/
dbSelectArea('SB5')
SB5->( dbSeek( xFilial('SB5') + padr(cCodigo,15), .F. ) )
iif(nSobra > 0,nSobra := (nSobra /** SB5->B5_QE2*/) - nAmostra,)
if nSobra > 0
  if SB5->B5_QTDFIM/SB5->B5_QE2 > posicione("SB2",1,xFilial('SB2')+cCodigo+'01',"B2_QATU")  
    oDlg10:end()
    msgAlert("Não há saldo suficiente para esta transformação!")	
    return
  endIf
endIf
/**/
aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf
/*dbSelectArea('SB5')
SB5->( dbSeek( xFilial('SB5') + padr(cCodigo,15), .F. ) )
iif(nSobra > 0,nSobra := (nSobra * SB5->B5_QE2) - nAmostra,) //Redundância, corrigir! (mult, depois divide)*/
cTransf := ProxSeq();ConfirmSX8()                //Tira no 02 ou tira no 01
if !Producao( cCodigo, cCodbar, (nAmostra + nSobra)/SB5->B5_QE2, iif( nSobra <= 0, 3, 4 ) )
  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
  msgAlert("Transformação	: " + cTransf )
  return
endIf
do while nCount <= 2 //incluir a amostra em seguida incluir a sobra da eliminação
	cBarraNv := "888888" + ProxSeq()
   if ! Producao( cCodigo, cBarraNv, iif(nCount == 1, nAmostra, nSobra)/SB5->B5_QE2, iif(nCount == 1, 1, 2) )
	  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
	  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
	  return
	endIf
	RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := "888888"
	Z00->Z00_OP     := ""
	Z00->Z00_PESO   := (SB5->B5_LARG*SB5->B5_COMPR*SB5->B5_ESPESS*SB5->B5_DENSIDA*iif(nCount == 1, nAmostra, nSobra))/1000
	Z00->Z00_BAIXA  := "S"
	Z00->Z00_MAQ    := ""
	Z00->Z00_DATA   := dDataBase
	Z00->Z00_HORA   := Left( Time(), 5 )
	Z00->Z00_QUANT  := iif(nCount == 1, nAmostra, nSobra)
	Z00->Z00_PESDIF := 0
	Z00->Z00_USULIM := "AMOSTRAS"
	Z00->Z00_NOME   := aRET[2]
	Z00->Z00_CODBAR := cBarraNv
	Z00->Z00_STATUS := iif(nCount == 1, "S", "")
	Z00->Z00_CDBRNV := cTransf
	Z00->Z00_USUAR  := "TRANSFORMADOR"
	Z00->Z00_CODIGO := cCodigo
	Z00->Z00_DATCON := dDataBase
	Z00->( MsUnlock() )
	ConfirmSX8()
	Z00->( DbCommit() )
	if nSobra > 0
	  nCount++
	else
	  nCount += 10000
	endIf
endDo
TEMP->( __dbZap()     )	
TEMP->( dbCloseArea() )
criaArq()
oDlg10:end()
msgAlert("Amostras criadas com sucesso.")	
return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ valProd()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function valProd( cCod )
dbSelectArea('SB1')
if ! SB1->( DBSeek( xFilial('SB1') + cCod, .F. ) )
  msgAlert('Favor escolher um produto válido!')
  objectMethod( oGet10,"SetFocus()")
  return
endIf
return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ tpAmostra() - seleciona tipo de amostra
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function tpAmostra()

if msgYesNo("Esta amostra é para uma licitação ?")
	amoLicit()
else
	amostras()
endIf

Return

static Function amoLicit()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGet10      := Space(15)
Private nGet20      := 0
Private cGet30      := Space(12)
Private lAmostra    := .F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont10","oFont20","oSay20","oSay50","oSay60","oSay40","oSay30","oSay10","oGet10","oGrp10","oGet20","oBtn10")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg10  := MSDialog():New( 212,414,402,740,"Gerar Amostra",,,,,,,,,.T.,,, )
oGrp10  := TGroup():New( 002,004,089,158,"",oDlg10,CLR_BLACK,CLR_WHITE,.T.,.F. )
oFont10 := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oFont20 := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oSay20  := TSay():New( 014,072,{||""},oGrp10,,oFont20,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
oSay40  := TSay():New( 026,072,{||""},oGrp10,,oFont20,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
oSay30  := TSay():New( 027,016,{||"Quantidade :"},oGrp10,,oFont10,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,044,008)
oSay10  := TSay():New( 014,016,{||"Produto :"},oGrp10,,oFont10,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,044,008)
oGet10  := TGet():New( 059,010,{|u| If(PCount()>0,cGet10:=u,cGet10)},oGrp10,060,010,'',{|| valProd( cGet10 ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGet10",,)
oGet20  := TGet():New( 059,090,{|u| If(PCount()>0,nGet20:=u,nGet20)},oGrp10,060,010,'999,999.99',{ || busca_2(cGet10, nGet20) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGet20",,)
oBtn20  := TButton():New( 074,040,"Transformar",oGrp10,{||quebra2( cGet10, cGet30, nGet20, iif( lAmostra, oSay40:cCaption , '0' ) ) },037,012,,,,.T.,,"",,,,.F. )
oBtn30  := TButton():New( 074,084,"Sair",oGrp10,{|| oDlg10:End() },037,012,,,,.T.,,"",,,,.F. )
oBtn20:lActive := .F.
oDlg10:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ quebra2()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function quebra2( cCodigo, cCodbar, nAmostra, cSobra )
Local cTransf := cBarraNv := ""
Local nCount  :=  1
Local aRet    := { }
Local nSobra  :=  0
Local aMatriz := { }
lMsErroAuto   := .F.

aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf
//msgAlert(SB5->B5_COD)
aMATRIZ :={{  "D3_COD",     cCodigo ,  NIL },;
	        { "D3_TM",	    '505'   ,  NIL },;
	        { "D3_LOCAL",   '03'    ,  NIL },;
 	        { "D3_UM",      posicione("SB1", 1, xFilial('SB1') + cCodigo, "B1_UM"), NIL },;
	        { "D3_QUANT",   nAmostra/SB5->B5_QE2,  NIL },;
	        { "D3_OBS",     "AMOST. LICITACAO", NIL },;
	        { "D3_EMISSAO", dDataBase, NIL }}
MSExecAuto( { | x,y | MATA240( x,y ) }, aMATRIZ, 3 )
if lMSErroAuto
	msgAlert("Houve um erro na transformação, favor contactar o setor de Informática(retirando do 03).")
	return
endIf

aMATRIZ :={{  "D3_COD",     cCodigo ,  NIL },;
	        { "D3_TM",	    '105'   ,  NIL },;
	        { "D3_LOCAL",   '01'    ,  NIL },;
 	        { "D3_UM",      posicione("SB1", 1, xFilial('SB1') + cCodigo, "B1_UM"), NIL },;
	        { "D3_QUANT",   nAmostra/SB5->B5_QE2,  NIL },;
	        { "D3_OBS",     "AMOST. LICITACAO", NIL },;
	        { "D3_EMISSAO", dDataBase, NIL }}
MSExecAuto( { | x,y | MATA240( x,y ) }, aMATRIZ, 3 )
if lMSErroAuto
	msgAlert("Houve um erro na transformação, favor contactar o setor de Informática(inserindo no 01).")
 	return
endIf

oDlg10:end()
msgAlert("Amostra(s) criada(s) com sucesso.")
return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ busca_2()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static Function busca_2( cCodigo, nQtd )
dbSelectArea('SB2');dbSelectArea('SB1')
if empty( cCodigo )
	msgAlert("Insira um produto válido!")
	objectMethod( oGet10,"SetFocus()")
	return
elseIf !SB2->( DBSeek( xFilial('SB2') + padr(cCodigo,15) + '03', .F.) )
    if SB2->( DBSeek( xFilial('SB2') + padr(cCodigo,15) + '01', .F.) )
     	RecLock("SB2",.T.)
     	SB2->B2_FILIAL := xFilial("SB2")
     	SB2->B2_COD    := padr(cCodigo,15)
     	SB2->B2_LOCAL  := "03"
		SB2->(MsUnLock())
	else
     	msgAlert("Insira um produto válido!")
     	objectMethod( oGet10,"SetFocus()")
		return
	endIf
endIf
if !SB5->( dbSeek( xFilial('SB5') + padr(cCodigo,15), .F.) )
	msgAlert("Não há complemento de produto!")
	return
endIf
/*if nQtd >= posicione("SB5",1,xFilial('SB5')+padr(cCodigo,15),"B5_QTDFIM")
  msgAlert("Insira apenas a parte quebrada da amostra!")
  objectMethod( oGet20,"SetFocus()")
  return*/
If nQtd <= 0
	msgAlert("Insira uma quantidade válida!")
	objectMethod( oGet20,"SetFocus()")
	return
endIf
if SB2->B2_QATU * SB5->B5_QE2 >= nQtd
	oSay20:lVisible := .T.
	ObjectMethod(oSay20, "setText( posicione('SB1',1,xFilial('SB1')+SB2->B2_COD,'B1_DESC') )")
	ObjectMethod(oSay20, "Refresh()")
	oSay40:lVisible := .T.
	ObjectMethod(oSay40,"setText(transform(SB2->B2_QATU * SB5->B5_QE2, '@E 999,999.999'))" )
	ObjectMethod(oSay40, "Refresh()"  )
	oBtn20:lActive := .T.
	objectMethod( oBtn20,"SetFocus()")
	lAmostra := .F.
else
	msgAlert("Não há saldo suficiente para atender essa amostra. Favor entrar em contato com o setor de produção!")
	return
endIf

return