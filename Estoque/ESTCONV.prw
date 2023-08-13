#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Estoque          ³Contato ³                                ³±±
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
±±³Analista Resp.³  Data  ³ Bops ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

*************

User Function ESTCONV()

*************

SetPrvt( "oDlg1,oGroup1,oBrw1,oGroup2,oSay1,oSay2,oSay3,oSay4,oGroup3,oBtn1,oBtn2,oBtn3,oSay5,oSay6," )
SetPrvt( "oSay7,oSay8,oSay9,oSay10,cMARCA,aArray," )
aArray := {}
lMsErroAuto := .F.
oDlg1 := MSDialog():Create()
oDlg1:cCaption := ' Conversão de produtos incompletos '
oDlg1:cName := 'oDlg1'
oDlg1:lActive := .T.
oDlg1:lCentered := .T.
oDlg1:lShowHint := .T.
oDlg1:nHeight := 572
oDlg1:nLeft := 215
oDlg1:nTop := 81
oDlg1:nWidth := 800

oGroup1 := TGroup():Create(oDlg1)
oGroup1:cCaption := ' Produtos incompletos '
oGroup1:cName := 'oGroup1'
oGroup1:lActive := .T.
oGroup1:lShowHint := .F.
oGroup1:nHeight := 273
oGroup1:nLeft := 6
oGroup1:nTop := 8
oGroup1:nWidth := 781

cMarca := getMark()
CriaArq()

oBrw1 := MsSelect():New( "TEMP","MARCA","", ;
{{ "MARCA", ,    ""                 },;
{"B1_COD"    ,, "Cód. do Produto"  },;
{"Z00_CODBAR",, "Cód. de Barras"   },;
{"Z00_QUANT" ,, "Quantidade Pesada"},;
{"B5_QTDFIM" ,, "Quantidade Final" },;
{"Z00_DATA"  ,, "Data de Pesagem"} },;
.F.,cMarca, { 11,7, 125, 390 },,, oGroup1 )
//.F.,cMarca, { 11,7, 112, 380 },,, oGroup1 )
//oBRW1:oBROWSE:lhasMark    := .F.
//oBRW1:oBROWSE:lCanAllmark := .F.
oBRW1:oBROWSE:bCHANGE 	  := { || iif( TEMP->MARCA == cMarca, atualiza(1),atualiza(2)) }

oGroup2 := TGroup():Create(oDlg1)
oGroup2:cCaption := ' Produtos transformados '
oGroup2:cName := 'oGroup2'
oGroup2:lActive := .T.
oGroup2:lShowHint := .F.
oGroup2:nHeight := 203
oGroup2:nLeft := 6
oGroup2:nTop := 288
oGroup2:nWidth := 781
oGroup2:bLClicked := { || oGroup2bLClicked }

oSay1 := TSay():Create(oGroup2)
oSay1:cCaption := 'Produto:'
oSay1:cName := 'oSay1'
oSay1:lActive := .T.
oSay1:lShowHint := .F.
oSay1:nHeight := 17
oSay1:nLeft := 17
oSay1:nTop := 328
oSay1:nWidth := 46

oSay2 := TSay():Create(oGroup2)
oSay2:cCaption := '1234567890123456789'
oSay2:cName := 'oSay2'
oSay2:lActive := .T.
oSay2:lShowHint := .F.
oSay2:nHeight := 17
oSay2:nLeft := 70
oSay2:nTop := 328
oSay2:nWidth := 121

oSay3 := TSay():Create(oGroup2)
oSay3:cCaption := 'Descrição:'
oSay3:cName := 'oSay3'
oSay3:lActive := .T.
oSay3:lShowHint := .F.
oSay3:nHeight := 17
oSay3:nLeft := 270
oSay3:nTop := 328
oSay3:nWidth := 57

oSay4 := TSay():Create(oGroup2)
oSay4:cCaption := '12345678901234567890123456789012345678901234567890'
oSay4:cName := 'oSay4'
oSay4:lActive := .T.
oSay4:lShowHint := .F.
oSay4:nHeight := 17
oSay4:nLeft := 342
oSay4:nTop := 328
oSay4:nWidth := 305

oGroup3 := TGroup():Create(oDlg1)
oGroup3:cCaption := ' Ações '
oGroup3:cName := 'oGroup3'
oGroup3:lActive := .T.
oGroup3:lShowHint := .F.
oGroup3:nHeight := 49
oGroup3:nLeft := 6
oGroup3:nTop := 493
oGroup3:nWidth := 782

oBtn1 := TButton():Create(oGroup3)
oBtn1:cCaption := 'Transformar'
oBtn1:cName := 'oBtn1'
oBtn1:lActive := .T.
oBtn1:lShowHint := .F.
oBtn1:nHeight := 25
oBtn1:nLeft := 248
oBtn1:nTop := 507
oBtn1:nWidth := 75
oBtn1:bAction := { || transformar() }
//aRET := u_senha2( "10", 1 )[ 1 ]
oBtn2 := TButton():Create(oGroup3)
oBtn2:cCaption := 'Sair'
oBtn2:cName := 'oBtn2'
oBtn2:lActive := .T.
oBtn2:lShowHint := .F.
oBtn2:nHeight := 25
oBtn2:nLeft := 345
oBtn2:nTop := 507
oBtn2:nWidth := 75
oBtn2:bAction := { || oDlg1:end() }

oBtn3 := TButton():Create(oGroup3)
oBtn3:cCaption := 'Amostras'
oBtn3:cName := 'oBtn3'
oBtn3:lActive := .T.
oBtn3:lShowHint := .F.
oBtn3:nHeight := 25
oBtn3:nLeft := 441
oBtn3:nTop := 506
oBtn3:nWidth := 75
oBtn3:bAction := { || amostras() }

oSay5 := TSay():Create(oGroup2)
oSay5:cCaption := 'Quantidade a ser gerada:'
oSay5:cName := 'oSay5'
oSay5:lActive := .T.
oSay5:lShowHint := .F.
oSay5:nHeight := 17
oSay5:nLeft := 17
oSay5:nTop := 374
oSay5:nWidth := 126

oSay6 := TSay():Create(oGroup2)
oSay6:cCaption := '99999'
oSay6:cName := 'oSay6'
oSay6:lActive := .T.
oSay6:lShowHint := .F.
//oSay6:nHeight := 17
oSay6:nHeight := 25
oSay6:nLeft := 142
oSay6:nTop := 374
//oSay6:nWidth := 41
oSay6:nWidth := 70

oSay7 := TSay():Create(oGroup2)
oSay7:cCaption := 'Resto da transformação:'
oSay7:cName := 'oSay7'
oSay7:lActive := .T.
oSay7:lShowHint := .F.
oSay7:nHeight := 17
oSay7:nLeft := 270
oSay7:nTop := 374                              
oSay7:nWidth := 121

oSay8 := TSay():Create(oGroup2)
oSay8:cCaption := '99999'
oSay8:cName := 'oSay8'
oSay8:lActive := .T.
oSay8:lShowHint := .F.
//oSay8:nHeight := 17
oSay8:nHeight := 25
oSay8:nLeft := 398
oSay8:nTop := 374
//oSay8:nWidth := 41
oSay8:nWidth := 70

oSay9 := TSay():Create(oGroup2)
oSay9:cCaption := 'Quantidade de produtos eliminados:'
oSay9:cName := 'oSay9'
oSay9:lActive := .T.
oSay9:lShowHint := .F.
oSay9:nHeight := 17
oSay9:nLeft := 494
oSay9:nTop := 374
oSay9:nWidth := 177

oSay10 := TSay():Create(oGroup2)
oSay10:cCaption := '99999'
oSay10:cName := 'oSay10'
oSay10:lActive := .T.
oSay10:lShowHint := .F.
oSay10:nHeight := 17
oSay10:nLeft := 678
oSay10:nTop := 374
oSay10:nWidth := 41


oDlg1:Activate(,,,.T.)

Return TEMP->( dbCloseArea() )


***************

Static Function CriaArq()

***************

Local cCod := cQuery := ""
Local nFardos := nTotal := nQtdFim := nCount := 0
Local aCodBr := {}
cQuery += "select SB1.B1_COD, Z00.Z00_CODBAR, Z00.Z00_PESO, Z00.Z00_QUANT, SB5.B5_QTDFIM, Z00.Z00_DATA, '  ' MARCA, 0 FARDOS "
cQuery += "from   " + retSqlName("Z00") + " Z00, " + retSqlName("SB1") + " SB1, " + retSqlName("SB5") + " SB5 "
cQuery += "WHERE  Z00.Z00_FILIAL = '"+xFilial('Z00')+"' AND SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery += "AND Z00.Z00_CODIGO = SB1.B1_COD AND SB1.B1_COD = B5_COD AND SB1.B1_TIPO = 'PA' "
cQuery += "AND Z00.Z00_QUANT < SB5.B5_QTDFIM AND Z00.Z00_BAIXA = 'S' AND Z00.Z00_APARA = '' "
cQuery += "AND (Z00.Z00_CDBRNV  = '' or Z00.Z00_STATUS in ('C','P') ) "
cQuery += "AND Z00.Z00_DATA >= '20070928' "
cQuery += "AND SB1.D_E_L_E_T_ != '*' AND Z00.D_E_L_E_T_ != '*' AND SB5.D_E_L_E_T_ != '*' "
cQuery += "order by SB1.B1_COD asc, Z00.Z00_QUANT desc "
/*cQuery += "union "
cQuery += "select SB1.B1_COD, Z00.Z00_CODBAR, Z00.Z00_PESO, Z00.Z00_QUANT, SB5.B5_QTDFIM, Z00.Z00_DATA, '  ' MARCA, 0 FARDOS "
cQuery += "from   " + retSqlName("Z00") + " Z00, Z07020 Z07, " + retSqlName("SB1") + " SB1, "
cQuery += "" + retSqlName("SB5") + " SB5 "
cQuery += "WHERE  Z00.Z00_FILIAL = '" + xFilial("Z00") + "' AND Z07.Z07_FILIAL = '01' "
cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' "
cQuery += "AND Z00.Z00_CODBAR = Z07.Z07_CODBAR AND Z00.Z00_CODIGO = 'ADC108' "
cQuery += "AND Z00.Z00_CODIGO = SB1.B1_COD AND SB1.B1_COD = B5_COD AND SB1.B1_TIPO = 'PA' "
cQuery += "AND Z00.Z00_QUANT < SB5.B5_QTDFIM AND Z00.Z00_BAIXA = 'S' AND Z00.Z00_APARA = '' "
cQuery += "AND (Z00.Z00_CDBRNV  = '' or Z00.Z00_STATUS in ('C','P') ) "
cQuery += "AND SB1.D_E_L_E_T_ != '*' AND Z00.D_E_L_E_T_ != '*' AND SB5.D_E_L_E_T_ != '*' "
cQuery += "order by SB1.B1_COD asc, Z00.Z00_QUANT desc " */
TCQUERY cQuery NEW ALIAS 'TMP'
TCSetField( 'TMP', "Z00_DATA", "D")
TMP->( dbGoTop() )

cARQTMP := CriaTrab( , .F. )
copy to(cARQTMP)
TMP->( dbCloseArea() )
DbUseArea( .T.,, cARQTMP, "TEMP", .F., .F. )

do while ! TEMP->( EoF() )
  nFardos := fardos( TEMP->B1_COD )
  cCod := TEMP->B1_COD
  do while TEMP->B1_COD == cCod
    TEMP->FARDOS := nFardos
    TEMP->( dbSkip() )
  endDo
endDo
TEMP->( dbGoTop() )

do while ! TEMP->( EoF() )
if (TEMP->FARDOS * TEMP->B5_QTDFIM) >= TEMP->B5_QTDFIM
  cCod   := TEMP->B1_COD
  nTotal := TEMP->Z00_QUANT
  TEMP->MARCA := cMarca
  nCount := 1
  aCodBr := {}; aAdd(aCodBr, TEMP->Z00_CODBAR )
  TEMP->( dbSkip() )
  do while ! TEMP->( EoF() ) .and. cCod == TEMP->B1_COD
  	if ( nTotal/TEMP->B5_QTDFIM ) < TEMP->FARDOS  	
  	  TEMP->MARCA := cMarca
  	  nTotal += TEMP->Z00_QUANT
  	  nCount++
      aAdd(aCodBr, TEMP->Z00_CODBAR )
  	endIf
    nQtdFim := TEMP->B5_QTDFIM
  	TEMP->( dbSkip() )
  endDo
  aAdd( aArray, { cCod, nTotal - nTotal%nQtdFim, nTotal%nQtdFim, nCount, nQtdFim, aCodBr  } )
else
  TEMP->(dbSkip())
EndIF
endDo
TEMP->( dbGoTop() )

Return Nil

***************

Static Function atualiza( nOpt ) 

***************
if nOpt == 1 .and. len( aArray ) > 0
  SB1->( dbSeek( xFilial( 'SB1' ) + TEMP->B1_COD ) )
  oSay2:cCaption  := TEMP->B1_COD
  oSay4:cCaption  := SB1->B1_DESC  
  oSay6:cCaption  := transform( aArray[ aScan( aArray,{ |X| X[1] == TEMP->B1_COD }) ][2],'@E 999,999.99')
  oSay8:cCaption  := transform( aArray[ aScan( aArray,{ |X| X[1] == TEMP->B1_COD }) ][3],'@E 999,999.99')
  oSay10:cCaption := transform( aArray[ aScan( aArray,{ |X| X[1] == TEMP->B1_COD }) ][4],'@E 9999')
  oBRW1:oBROWSE:Refresh()
else
  oSay2:cCaption  := ""
  oSay4:cCaption  := ""
  oSay6:cCaption  := ""
  oSay8:cCaption  := ""
  oSay10:cCaption := ""
  oBRW1:oBROWSE:Refresh()
endIf

return

***************

Static Function transformar()

***************
Local x := y := 0
Local cBarraNv := cTransf := ""
Local aRET := {}
Local aMATRIZ := {}
lMsErroAuto := .F.

if len( aArray ) <= 0
  msgalert('Não há produtos a serem transformados.')
  return
endIf

aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf

dbSelectArea('Z00')
dbSelectArea('SB5')
for x := 1 to len( aArray )
  cTransf := ProxSeq();ConfirmSX8()
  for y := 1 to len( aArray[x][6] )//Adiciona o código da transformação para os produtos que serão "destruídos"
    Z00->( dbSetOrder( 7 ) )
    Z00->( dbSeek( xFilial('Z00') + aArray[x][6][y] ), .T. )
    SB5->( dbSeek( xFilial('SB5') + aArray[x][1] ) )
    if ! Producao( aArray[x][1], Z00->Z00_CODBAR, Z00->Z00_QUANT/SB5->B5_QE2, 3 )
      msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
  	  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
  	  return
    endIf
    RecLock( "Z00", .F. )
    Z00->Z00_CDBRNV := cTransf//Código da transformação
    Z00->Z00_DATCON := dDataBase//data da transformação
    Z00->Z00_STATUS := ''
    Z00->( msUnlock() )
    //ConfirmSX8()
    Z00->( DbCommit() )
  next
  for z := 1 to aArray[x][2]/aArray[x][5]
    cBarraNv := "999999" + ProxSeq()
    SB5->( dbSeek( xFilial('SB5') + aArray[x][1] ) )
    if ! Producao( aArray[x][1], cBarraNv, aArray[x][5]/SB5->B5_QE2, 1 )
  	  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
  	  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
  	  return
    endIf
    //Z00->( dbAppend() )
    RecLock( "Z00", .T. )
    Z00->Z00_SEQ    := ""//cSEQ - NÃO PRECISA
    Z00->Z00_OP     := ""//cOP - NÃO PRECISA
    Z00->Z00_PESO   := (SB5->B5_LARG*SB5->B5_COMPR*SB5->B5_ESPESS*SB5->B5_DENSIDA*aArray[x][5])/1000//nPESO - VER COM LINDENBERG A FÓRMULA PARA TRANSFORMAR O PESO A PARTIR DA QUANTIDADE
    Z00->Z00_BAIXA  := "S"
    Z00->Z00_MAQ    := ""//cMAQ - NÃO PRECISA
    Z00->Z00_DATA   := dDataBase
    Z00->Z00_HORA   := Left( Time(), 5 )
    Z00->Z00_QUANT  := aArray[x][5]//nSACOS
    Z00->Z00_PESDIF := 0//nDIFPESO * -1//nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
    Z00->Z00_USULIM := "TRANSFORMADOR"//cUSULIM - USUARIO LIBERADOR DE LIMITE DE OP, NÃO PRECISA
    Z00->Z00_NOME   := aRET[2]  //cNOMUSUA - NOME DO USUÁRIO QUE PESOU, NESTE CASO SERÁ O DE QUEM TRANSFORMOU
    Z00->Z00_CODBAR := cBarraNv
    Z00->Z00_STATUS := "F"
    Z00->Z00_CDBRNV := cTransf
    Z00->Z00_USUAR  := "TRANSFORMADOR"//Iif ( Len( aUSUARI2 ) > 0, Alltrim( aUSUARIO[ 2 ] )+ " " + Alltrim( aUSUARI2[ 2 ] ), aUSUARIO[ 2 ] ) //aUSUARIO[ 2 ]
    Z00->Z00_CODIGO := aArray[x][1]
    Z00->Z00_DATCON := dDataBase
    Z00->( MsUnlock() )
    ConfirmSX8()
    Z00->( DbCommit() )
  next
  if aArray[x][3] > 0 //Criando o novo produto incompleto
    cBarraNv := "999999" + ProxSeq()
    SB5->( dbSeek( xFilial('SB5') + aArray[x][1] ) )
    if ! Producao( aArray[x][1], cBarraNv, aArray[x][3]/SB5->B5_QE2, 2 )
      msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
  	  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
  	  return
    endIf
    //Z00->( dbAppend() )
    RecLock( "Z00", .T. )
    Z00->Z00_SEQ    := ""//cSEQ - NÃO PRECISA
    Z00->Z00_OP     := ""//cOP - NÃO PRECISA
    Z00->Z00_PESO   :=  (SB5->B5_LARG*SB5->B5_COMPR*SB5->B5_ESPESS*SB5->B5_DENSIDA*aArray[x][3])/1000//nPESO - VER COM LINDENBERG A FÓRMULA PARA TRANSFORMAR O PESO A PARTIR DA QUANTIDADE
    Z00->Z00_BAIXA  := "S"
    Z00->Z00_MAQ    := ""//cMAQ - NÃO PRECISA
    Z00->Z00_DATA   := dDataBase
    Z00->Z00_HORA   := Left( Time(), 5 )
    Z00->Z00_QUANT  := aArray[x][3]//nSACOS
    Z00->Z00_PESDIF := 0//nDIFPESO * -1//nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
    Z00->Z00_USULIM := "TRANSFORMADOR"//cUSULIM - USUARIO LIBERADOR DE LIMITE DE OP, NÃO PRECISA
    Z00->Z00_NOME   := aRET[2]  //cNOMUSUA - NOME DO USUÁRIO QUE PESOU, NESTE CASO SERÁ O DE QUEM TRANSFORMOU
    Z00->Z00_CODBAR := cBarraNv
    Z00->Z00_STATUS := "C"
    Z00->Z00_CDBRNV := cTransf
    Z00->Z00_USUAR  := "TRANSFORMADOR"//Iif ( Len( aUSUARI2 ) > 0, Alltrim( aUSUARIO[ 2 ] )+ " " + Alltrim( aUSUARI2[ 2 ] ), aUSUARIO[ 2 ] ) //aUSUARIO[ 2 ]
    Z00->Z00_CODIGO := aArray[x][1]
    Z00->Z00_DATCON := dDataBase
    Z00->( MsUnlock() )
    ConfirmSX8()
    Z00->( DbCommit() )
  endIf
//return //Tirar isso aqui. Apenas para teste.  
next
	
return

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

Static Function Producao( cCodP, cCodBar, nQuant, nOpt )

***************

Local aMATRIZ := {}
lMsErroAuto := .F.

/*aMATRIZ := { { "D3_COD",     cCodP,             		   NIL },;
			 { "D3_TM",		 iif(nOpt == 1,'105',iif( nOpt == 2,'105', '505' ) ),   NIL },;
 			 { "D3_LOCAL",   iif(nOpt == 1, '01',iif( nOpt == 2, '02',  '02' ) ),   NIL },;
 			 { "D3_UM",      posicione("SB1",1,xFilial('SB1')+cCodP,"B1_UM"),       NIL },;
			 { "D3_QUANT",   nQuant,                       NIL },;
			 { "D3_OBS",     "PROD. TRANSFORMADO",         NIL },;
			 { "D3_EMISSAO", dDataBase,       			   NIL },;
			 { "D3_CODBAR" , cCodBar,   	               NIL } }*/
aMATRIZ := { { "D3_COD",     cCodP,             		   NIL },;
			 { "D3_TM",		 iif(nOpt == 1,'105',iif( nOpt == 2,'105', iif( nOpt == 3,'505', '505') ) ),   NIL },;
 			 { "D3_LOCAL",   iif(nOpt == 1, '01',iif( nOpt == 2, '02', iif( nOpt == 3, '02',  '01') ) ),   NIL },;
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


*************

static Function amostras()

*************
Local aESTRT := {}
SetPrvt( "oDlg2,oGroup10,oBrw2,oGroup20,oGet10,oGet20,oBtn10,oBtn20," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGet10 := Space(15)
Private nDifr := nGet20 := 0

oDlg2      := MSDialog():New( 106,246,513,1025,"Controlador de amostras",,,,,,,,,.T.,,, )
oGroup10   := TGroup():New( 003,003,152,383,"Produtos a serem utilizados",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

aESTRT   := {{ "B1_COD",      "C", 015, 0 }, ;
             { "Z00_CODBAR",  "C", 020, 0 }, ;
             { "Z00_QUANT",   "N", 020, 0 }, ;
             { "Z00_DATA",    "D", 008, 0 }}
cARQTMP := CriaTrab( aESTRT, .T. )
DbUseArea( .T.,, cARQTMP, "TMPY", .F., .F. )               
DbSelectArea("TMPY")
oBrw2      := MsSelect():New( "TMPY",,"",{{"B1_COD","","Cod. do Produto",""},{"Z00_CODBAR","","Cod. de Barras",""},;
			  {"Z00_QUANT","","Quant. Pesada","@E 9,999.99"},{"Z00_DATA","","Data de Pesgem/Transformacao",""}},;
			  .F.,,{011,011,143,375},,, oGroup10 ) 
oGroup20   := TGroup():New( 156,004,196,384,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet10     := TGet():New( 164,116,{|u| If(PCount()>0,cGet10:=u,cGet10)},oGroup20,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"SB1","cGet10",,)
oGet20     := TGet():New( 164,200,{|u| If(PCount()>0,nGet20:=u,nGet20)},oGroup20,060,010,'@E 9,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nGet20",,)
oBtn10     := TButton():New( 180,116,"Pesquisar",oGroup20,{ || TMPY->( __dbZap()   ),encheArq(cGet10,nGet20) },037,012,,,,.T.,,,,,,.F. )
oBtn20     := TButton():New( 180,224,"Cancelar",oGroup20,{ || oDlg2:end() },037,012,,,,.T.,,,,,,.F. )
oBtn30     := TButton():New( 180,169,"Transformar",oGroup20,{ ||trans_2( nGet20, soma() - nGet20 , cGet10)},037,012,,,,.T.,,,,,,.F. )
//msgAlert( alltrim( str(nGet20) ) + alltrim( str(nGet20 - soma()) ) )
oBtn30:lActive := .F.
oDlg2:Activate(,,,.T.)
//objectMethod( oGet20,"SetFocus()")
Return TMPY->( dbCloseArea() )

***************

static Function encheArq( cCod, nQtd )

***************
Local cCodBar := cQuery := ""
Local nAcumu := nTot := 0

if nQtd >= posicione("SB5",1,xFilial('SB5')+cCod,"B5_QTDFIM")
  msgAlert("Insira apenas a parte quebrada da amostra!")
  objectMethod( oGet20,"SetFocus()")
  return
endIf

cQuery += "select SB1.B1_COD, Z00.Z00_CODBAR, Z00.Z00_PESO, Z00.Z00_QUANT, Z00.Z00_DATA "
cQuery += "from   "+retSqlName('Z00')+" Z00, "+retSqlName('SB1')+" SB1, "+retSqlName('SB5')+" SB5 "
cQuery += "WHERE  Z00.Z00_FILIAL = '"+xFilial('Z00')+"' AND SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery += "AND Z00.Z00_CODIGO = '" + alltrim(cCod) + "' and Z00.Z00_CODIGO = SB1.B1_COD AND SB1.B1_COD = B5_COD AND SB1.B1_TIPO = 'PA' "
cQuery += "AND Z00.Z00_QUANT < SB5.B5_QTDFIM AND Z00.Z00_DATA >= '20070928' AND Z00.Z00_BAIXA = 'S' AND Z00.Z00_APARA = '' "
cQuery += "AND (Z00.Z00_CDBRNV  = '' or Z00.Z00_STATUS in ('C','P') ) "
cQuery += "AND SB1.D_E_L_E_T_ != '*' AND Z00.D_E_L_E_T_ != '*' AND SB5.D_E_L_E_T_ != '*' "
cQuery += "order BY Z00.Z00_QUANT desc "
TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( dbGoTop() )
TMPX->( dbEval( { || nTot += TMPX->Z00_QUANT } ) )
if nTot >= nQtd
TMPX->( dbGoTop() )
oBtn30:lActive := .T.
//TMPY->( __dbZap()   )
do while ! TMPX->( EoF() ) .and. nAcumu < nQtd
  nAcumu += TMPX->Z00_QUANT
  TMPY->( dbAppend() )
  TMPY->B1_COD 	   := TMPX->B1_COD
  TMPY->Z00_CODBAR := TMPX->Z00_CODBAR
  TMPY->Z00_QUANT  := TMPX->Z00_QUANT
  TMPY->Z00_DATA   := stod(TMPX->Z00_DATA)
  TMPY->( DBCommit() )
  TMPX->( DBSkip() )

endDo
else
  //Situação na qual será melhor destruir um produto completo
  //O que resultará numa transformação
  msgalert("Não há saldo suficiente de incompletos para esta amostra.")
  if msgYesNo("Deseja transformar um produto completo ?")
    oBtn30:lActive := .T.
    dbSelectArea('Z00')
    Z00->( dbSetOrder(7) )
    if Z00->( dbSeek( xFilial('Z00') + pegaCbar(), .F. ) ) .AND. nQtd <= Z00->Z00_QUANT
      TMPY->( dbAppend() )
	  TMPY->B1_COD 	   := Z00->Z00_CODIGO
	  TMPY->Z00_CODBAR := Z00->Z00_CODBAR
	  TMPY->Z00_QUANT  := Z00->Z00_QUANT
	  TMPY->Z00_DATA   := Z00->Z00_DATA
	  TMPY->( DBCommit() )
	else
	  msgAlert("Produto não existente ou quantidade insuficiente!")
      oBtn30:lActive := .F.
	endIf
	Z00->( dbCloseArea() )
  endIf
endIf
TMPX->( dbCloseArea() )
TMPY->( dbGoTop() )
Return

***************

Static Function pegaCbar()

***************

local oDlg1,oGroup1,oGet1,oBtn1,oBtn2
local cRet := cGet := space(12)
oDlg1      := MSDialog():New( 254,480,381,686,"",,,,,,,,,.T.,,, )
oGroup1    := TGroup():New( 004,004,056,096," Código de barras: ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1      := TGet():New( 020,020,{|u| If(PCount()>0,cGet:=u,cGet)},oGroup1,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nGet",,)
oBtn1      := TButton():New( 040,012,"Buscar",oGroup1,{ || cRet := cGet, oDlg1:end() },037,012,,,,.T.,,,,,,.F. )
oBtn2      := TButton():New( 040,052,"Cancelar",oGroup1,{ || oDlg1:end() },037,012,,,,.T.,,,,,,.F. )

oDlg1:Activate(,,,.T.)

Return cRet

***************

Static Function trans_2( nAmostra, nSobra, cCod )

***************

Local cTransf := cBarraNv := ""
Local nCount := 1
Local nTotal := 0
Local aRet := {}
aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf
TMPY->( dbGotop() )
TMPY->( dbEval( { || nTotal += TMPY->Z00_QUANT } ) )
TMPY->( dbGotop() )
if alltrim(TMPY->B1_COD) != alltrim(cCod)
  msgAlert("O produto que você deseja transformar não é o mesmo pesquisado!")
  objectMethod( oGet10,"SetFocus()")
  return
elseIf nTotal < nAmostra
  msgAlert("A quantidade digitada não bate com a pesquisa!")
  objectMethod( oGet20,"SetFocus()")
  return
endIf

Z00->( dbSetOrder( 7 ) )
cTransf := ProxSeq();ConfirmSX8()
SB5->( dbSeek( xFilial('SB5') + TMPY->B1_COD ) )
do while nCount <= 2 //incluir a amostra em seguida incluir a sobra da eliminação
	cBarraNv := "888888" + ProxSeq()
	//if ! Producao( TMPY->B1_COD, cBarraNv, iif(nCount == 1, nAmostra, nSobra)/SB5->B5_QE2, 2 )
    if ! Producao( TMPY->B1_COD, cBarraNv, iif(nCount == 1, nAmostra, nSobra)/SB5->B5_QE2, iif(nCount == 1, 1, 2) )
	  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
	  msgAlert("Código de barras : " + cBarraNv + "Transformação: " + cTransf )
	  return
	endIf
	RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := ""//cSEQ - NÃO PRECISA
	Z00->Z00_OP     := ""//cOP - NÃO PRECISA
	Z00->Z00_PESO   := (SB5->B5_LARG*SB5->B5_COMPR*SB5->B5_ESPESS*SB5->B5_DENSIDA*iif(nCount == 1, nAmostra, nSobra))/1000//nPESO - VER COM LINDENBERG A FÓRMULA PARA TRANSFORMAR O PESO A PARTIR DA QUANTIDADE
	Z00->Z00_BAIXA  := "S"
	Z00->Z00_MAQ    := ""//cMAQ - NÃO PRECISA
	Z00->Z00_DATA   := dDataBase
	Z00->Z00_HORA   := Left( Time(), 5 )
	Z00->Z00_QUANT  := iif(nCount == 1, nAmostra, nSobra)//nSACOS
	Z00->Z00_PESDIF := 0//nDIFPESO * -1//nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
	Z00->Z00_USULIM := "AMOSTRAS"//cUSULIM - USUARIO LIBERADOR DE LIMITE DE OP, NÃO PRECISA
	Z00->Z00_NOME   := aRET[2]  //cNOMUSUA - NOME DO USUÁRIO QUE PESOU, NESTE CASO SERÁ O DE QUEM TRANSFORMOU
	Z00->Z00_CODBAR := cBarraNv
	Z00->Z00_STATUS := iif(nCount == 1, "S", "C")
	Z00->Z00_CDBRNV := cTransf
	Z00->Z00_USUAR  := "TRANSFORMADOR"//Iif ( Len( aUSUARI2 ) > 0, Alltrim( aUSUARIO[ 2 ] )+ " " + Alltrim( aUSUARI2[ 2 ] ), aUSUARIO[ 2 ] ) //aUSUARIO[ 2 ]
	Z00->Z00_CODIGO := TMPY->B1_COD
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

TMPY->( dbGoTop() )	
do While ! TMPY->( EoF() )//Adiciona o código da transformação para os produtos que serão "destruídos"
	Z00->( dbSeek( xFilial('Z00') + alltrim(TMPY->Z00_CODBAR) ), .T. )
	if !Producao( TMPY->B1_COD, Z00->Z00_CODBAR, Z00->Z00_QUANT/SB5->B5_QE2, iif(Z00->Z00_QUANT < SB5->B5_QTDFIM,3,4))
	  msgAlert("Houve um erro na transformação, favor contactar o setor de Informática.")
	  msgAlert("Código de barras : " + cBarraNv + "Transformação	: " + cTransf )
	return
	endIf
	RecLock( "Z00", .F. )
	Z00->Z00_CDBRNV := cTransf//Código da transformação
	Z00->Z00_DATCON := dDataBase//data da transformação
	Z00->Z00_STATUS := ''
	Z00->( msUnlock() )
	Z00->( DbCommit() )
	TMPY->( dbSkip() )
endDo

Return

***************

Static Function soma()
               
***************
local nSoma := 0
TMPY->( dbEval( { || nSoma += TMPY->Z00_QUANT } ) )
TMPY->( dbGoTop() )  
Return nSoma

***************

Static Function fardos( cCodigo )

***************

Local nFim := nTot := 0
Local cQuery := ""
cQuery += "select SB1.B1_COD, sum(Z00.Z00_QUANT) QUANT , SB5.B5_QTDFIM "
cQuery += "from   "+retSqlName('Z00')+" Z00, "+retSqlName('SB1')+" SB1, "+retSqlName('SB5')+" SB5 "
cQuery += "WHERE  Z00.Z00_FILIAL = '"+xFilial('Z00')+"' AND SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery += "AND Z00.Z00_CODIGO = SB1.B1_COD AND SB1.B1_COD = B5_COD AND SB1.B1_TIPO = 'PA' "
cQuery += "AND Z00.Z00_QUANT < SB5.B5_QTDFIM AND Z00.Z00_BAIXA = 'S' AND Z00.Z00_APARA = '' "
cQuery += "AND (Z00.Z00_CDBRNV  = '' or Z00.Z00_STATUS in ('C','P') ) "
cQuery += "AND Z00.Z00_DATA >= '20070928' and Z00.Z00_CODIGO = '"+cCodigo+"' "
cQuery += "AND SB1.D_E_L_E_T_ != '*' AND Z00.D_E_L_E_T_ != '*' AND SB5.D_E_L_E_T_ != '*' "
cQuery += "group by SB1.B1_COD, SB5.B5_QTDFIM "
TCQUERY cQuery NEW ALIAS "TMPW"
TMPW->( dbGoTop() )
nFim := TMPW->B5_QTDFIM
TMPW->( dbEval( { || nTot += TMPW->QUANT } ) )
TMPW->( dbCloseArea() )

return int(nTot/nFim)