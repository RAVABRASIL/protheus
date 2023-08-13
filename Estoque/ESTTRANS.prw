#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

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

User Function ESTTRANS( cAlias, nReg, nOpc )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Private e Public                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nSACOS     := 0
Private aSACOS     := {}
Private lEst		 := .F.
Private cSay8      := Space(1)
Private cSay6      := Space(1)
Private cSay15     := Space(1)
Private cSay5      := Space(1)
Private cSay4      := Space(1)
Private cSay20     := Space(1)
Private cMGet1    
Private cGet1      := Space(15)
Private cGet4      := Space(2)
Private cGet3      := Space(2)
Private cGet5      := Space(15)
Private nGet7      := 0
Private nQtDest    := 0
Private flag		 := .F.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay14","oSay13","oSay17","oSay16","oFont1","oSay7","oFont2","oSay8","oSay22","oSay12")
SetPrvt("oSay31","oSay30","oSay29","oSay32","oSay25","oSay23","oSay28","oSay27","oSay1","oSay6","oSay15")
SetPrvt("oSay11","oSay5","oSay2","oSay9","oSay4","oSay3","oSay19","oSay26","oSay24","oSay10","oSay21")
SetPrvt("oSay18","oSay20","oGrp1","oGrp2","oGrp3","oMGet1","oGrp5","oBtn1","oBtn2","oGrp4","oGrp6","oCBox1")
SetPrvt("oGet1","oGet4","oGet3","oGet5","oGet2","oGet6","oGet7")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 155,266,529,927,"Solicitacao de Transformacoes",,,,,,,,,.T.,,, )

oGrp1      := TGroup():New( 004,004,036,324,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 036,004,052,324,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp3      := TGroup():New( 055,004,100,228,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp4      := TGroup():New( 101,004,145,228,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp5      := TGroup():New( 166,004,182,240,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp6      := TGroup():New( 146,004,166,324,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oSay14     := TSay():New( 121,011,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,010)
oSay13     := TSay():New( 109,011,{||"No Produto:"},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay17     := TSay():New( 133,077,{||"Estoque:"},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 133,011,{||"Unidade:"},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 171,008,{||"Solicitado por:"},oGrp5,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay8      := TSay():New( 171,052,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,116,008)
oSay22     := TSay():New( 133,145,{||"Quantidade:"},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay30     := TSay():New( 154,276,{||""},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 154,170,{||"Quantidade de sacos capa destino:"},oGrp6,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
oSay32     := TSay():New( 154,040,{||"Quantidade:"},oGrp6,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay25     := TSay():New( 133,108,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 133,040,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 109,153,{||"Local:"},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 133,184,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay1      := TSay():New( 016,092,{||"Solicitação de Transformações"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,148,012)
oSay6      := TSay():New( 041,296,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay15     := TSay():New( 075,011,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,010)
oSay11     := TSay():New( 063,011,{||"Transformar o Produto:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay5      := TSay():New( 041,262,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 041,008,{||"Solicitação N°:"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay4      := TSay():New( 041,052,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay3      := TSay():New( 041,219,{||"Solicitado em:"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oSay19     := TSay():New( 087,011,{||"Unidade:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 087,185,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 063,153,{||"Local:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay10     := TSay():New( 087,145,{||"Quantidade:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
oSay21     := TSay():New( 087,106,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 087,077,{||"Estoque:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay20     := TSay():New( 087,040,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 062,080,{|u| If(PCount()>0,cGet1:=u,cGet1)},oGrp3,060,010,'',{||tPrd( cGet1 )},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGet1",,)
oGet4      := TGet():New( 062,173,{|u| If(PCount()>0,cGet4:=u,cGet4)},oGrp3,024,010,'01',{||loc( 1 )},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet4",,)
oGet5      := TGet():New( 108,080,{|u| If(PCount()>0,cGet5:=u,cGet5)},oGrp4,060,010,'',{||nPrd( cGet5 )},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGet5",,)
oGet3      := TGet():New( 108,173,{|u| If(PCount()>0,cGet3:=u,cGet3)},oGrp4,024,010,'02',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet3",,)
oGet7      := TGet():New( 152,076,{|u| If(PCount()>0,nGet7:=u,nGet7)},oGrp6,060,010,'999,999.99',{||calcular()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGet7",,)
oSay9      := TSay():New( 057,232,{||"Obs.:"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oMGet1     := TMultiGet():New( 068,231,{|u| If(PCount()>0,cMGet1:=u,cMGet1)},oDlg1,093,064,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oCBox1     := TCheckBox():New( 136,256,"Estorno",{|u| If(PCount()>0,lEst:=u,lEst)},oDlg1,048,008,,,oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox1:bChange := {|| calcular()}
oBtn2      := TButton():New( 168,245,"Transformar",oDlg1,{||gravar()},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 168,286,"Enviar",oDlg1,{||relt()},037,012,,,,.T.,,"",,,,.F. )
                           
atualizar()
oGet1:setFocus()
oGet4:Disable() ; oGet3:Disable() ; cGet4 := "01"; cGet3 := "02"

if ( nOpc == 3, complt(), oBtn2:Disable() )

oDlg1:Activate(,,,.T.)

if ( flag )
	ConfirmSX8() //Sequencia do codigo 
	flag := .F.
else
	RollBackSX8()
endIf

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ tPrd( cGet )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function tPrd( cGet )
   //dbSelectArea('SB1')//Cadastro de produtos
   dbSelectArea('SB1')//Estoque atual
   //SB2->dbSetOrder(1)//seleciona indice de busca
   if !SB1->( dbSeek( xFilial() + padr(cGet,15) + '01', .F. ) )  //nao encontrou o produto
     //msgAlert('Este produto nao existe ou nao tem uma quantidade em estoque!')
     oSay15:cCaption := 'Este produto nao existe.'
     oGet1:setFocus()
   else //se tiver encontrado o produto
     oSay15:cCaption := SB1->B1_DESC  //Pega a descricao do produto
     oSay20:cCaption := SB1->B1_UM    //Pega a unidade do produto
     oGet4:setFocus()
     loc( 1 )
   endIf
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ nPrd( cGet )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function nPrd( cGet )
   if (cGet == cGet1)
     MsgAlert( "Produto destino tem que ser diferente do origem" )
     oGet5:setFocus()
     return
   endif
   //dbSelectArea('SB1')//Cadastro de produtos
   dbSelectArea('SB1')//Estoque atual
   //SB2->dbSetOrder(1)//seleciona indice de busca
   if !SB1->( dbSeek( xFilial() + padr(cGet,15) + '01', .F. ) )  //nao encontrou o produto
     //msgAlert('Este produto nao existe ou nao tem uma quantidade em estoque!')
     oSay14:cCaption := 'Este produto nao existe.'
     oGet5:setFocus()
   else //se tiver encontrado o produto
     oSay14:cCaption := SB1->B1_DESC  //Pega a descricao do produto
     oSay23:cCaption := SB1->B1_UM    //Pega a unidade do produto
     oGet3:setFocus()
     loc( 2 )
   endIf
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ atualizar()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function atualizar()
   dbSelectArea('Z10')
   oSay4:cCaption := GetSx8Num( "Z10", "Z10_COD" )
   oSay8:cCaption := allTrim(Substr(cUsuario,7,15))
   oSay5:cCaption := dtoc(dDataBase)
   oSay6:cCaption := Time()   
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ loc( nPos )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function loc( nPos )
	DbSelectArea("SB2")

   if !SB2->( DbSeek( xFilial( "SB2" ) + if( nPos == 1, cGet1 + cGet4, cGet5 + cGet3 )))
      MsgAlert( "Local nao cadastrado para esse produto" )
      return .F.
   endif
   if ( nPos == 1, oSay21:cCaption := Trans( SB2->B2_QATU, '@E 999,999.99' ), oSay25:cCaption := Trans( SB2->B2_QATU, '@E 999,999.99' ) )         
Return .T.

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ complt( cod )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function complt( )                               
	Local prdini := Z10->Z10_PRDINI; prdfin := Z10->Z10_PRDFIN

	oBtn1:Disable()
	oSay4:cCaption  := Z10->Z10_COD  	 //Codigo da Solicitacao
	oSay5:cCaption  := dtoc(Z10->Z10_DATA)  //Data da Solicitacao
	oSay6:cCaption  := Z10->Z10_HORA  		 //Hora da Solicitacao
	cGet1 			 := Z10->Z10_PRDINI ; oGet1:Disable()  //Codigo Produto Inicial
	oSay20:cCaption := Z10->Z10_UMINI  		 //Unidade Produto Inicial
	oSay26:cCaption := trans( Z10->Z10_QTINI, '@E 999,999.99' )       //Quantidade Produto Inicial
	cGet5				 := Z10->Z10_PRDFIN ; oGet5:Disable() //Codigo Produto Final
	oSay23:cCaption := Z10->Z10_UMFIN  		 //Unidade Produto Final
	oSay27:cCaption := trans( Z10->Z10_QTFIN, '@E 999,999.99' )  		 //Quantidade Produto Final
	nGet7  			 := Z10->Z10_QTINI ; oGet7:Disable()  //Quantidade
   cMGet1		    := Z10->Z10_OBS ; oMGet1:Disable()  //Observacao
   oSay7				 := Z10->Z10_USUARI
   oCBox1:Disable()
   
   DbSelectArea("SB2")      
   SB2->( dbSeek( xFilial() + padr(prdini,15) + '01', .F. ) )   //Estoque Produto Inicial
   oSay21:cCaption := trans( SB2->B2_QATU, '@E 999,999.99' )
   SB2->( dbSeek( xFilial() + padr(prdfin,15) + '02', .F. ) )  //Estoque Produto Final
   oSay25:cCaption := trans( SB2->B2_QATU, '@E 999,999.99' )

	DbSelectArea("SB1")       
	SB1->( dbSeek( xFilial() + padr(prdini,15) + '01', .F. ) )	
   oSay15:cCaption := SB1->B1_DESC		 //Descricao Produto Inicial
	SB1->( dbSeek( xFilial() + padr(prdfin,15) + '01', .F. ) )	   
   oSay14:cCaption := SB1->B1_DESC		 //Descricao Produto Final                
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ calcular()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function calcular()
	if !empty(nGet7)
      oSay26:cCaption := Trans( nGet7, '@E 999,999.99' )  //Label Quantidade a ser transformada produto origem
      dbselectarea( "SB5" )
      SB5->( DbSeek( xFilial( "SB5" ) + cGet1 ))
      nQtDest := nGet7 * ( SB5->B5_QE2 )
      SB5->( DbSeek( xFilial( "SB5" ) + cGet5 ))
      nQtDest := nQtDest / ( SB5->B5_QE2 )
      oSay27:cCaption := Trans( nQtDest, '@E 999,999.99' )  //Label Quantidade a ser transformada produto destino

      DbSelectArea( "SG1" )
		SG1->( DbSeek( xFilial( "SG1" ) + If( lEst, cGet1, cGet5 ), .T. ) )
		aSACOS := {}
		nSACOS := 0
		Do While ! SG1->( Eof() ) .and. SG1->G1_COD == If( lEst, cGet1, cGet5 )
		   If Subs( SG1->G1_COMP, 1, 2 ) == 'ME'
		      SB5->( Dbseek( xFilial( "SB5" ) + SG1->G1_COMP ) )
      		Aadd( aSACOS, { SG1->G1_COMP, nQtDest * SG1->G1_QUANT } )
		      nSACOS += SB5->B5_QE2 * ( nQtDest * SG1->G1_QUANT )
		   Endif
		   SG1->( DbSkip() )
		EndDo
		oSay30:cCaption := Trans( nSACOS, '@E 999,999' )  //Quantidade Sacos
   endif  
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ gravar()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function gravar()

Local nCONT, ;
      cTESORIG := "505", ;//Tirando do estoque, pois todo TM >= 500 é de retirada.
      cTESDEST := "105"//Incluíndo no estoque, pois todo TM < 500 é de inclusão

DbSelectArea('Z10')
If ( Z10->Z10_STATUS == '2' )
	MsgAlert( "Produto ja transformado" )
	oDlg1:end()
	Return .F.
endIf
If ( nGet7 > val( oSay21:cCaption ))
	MsgAlert( "Quantidade no estoque inferior a quantidade a ser transformada")
	oDlg1:end()
	Return .F.
endIf
If Empty( cGet1 ) .or. Empty( cGet5 )  //Produto Origem e Destino
   MsgAlert( "Informe produto de origem e destino" )
   Return .F.
ElseIf Empty( nGet7 )  //Quantidade
   MsgAlert( "Informe a quantidade a ser transferida" )
   Return .F.
EndIf
If ! SF5->( dbSeek( xFilial() + cTESORIG ) ) .or. ! SF5->( dbSeek( xFilial() + cTESDEST ) )
   MsgAlert( "Cadastre os tipos de movimentacao " + cTESORIG + " e " + cTESDEST )
   Return .F.
EndIf   

//incluir teste da existência do produto no almoxarifado 02
lMsErroAuto := .F.
    aMATRIZ     := { { "D3_TM", cTESORIG, NIL},;
                     { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                     { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                     { "D3_LOCAL", cGet4, NIL },;  //Local Origem
                     { "D3_COD", cGet1, NIL},;  //Produto Origem
                     { "D3_QUANT", nGet7, NIL },;  //Quantidade Origem
                     { "D3_EMISSAO", dDATABASE, NIL} }

Begin Transaction
   MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
	IF lMsErroAuto
   	DisarmTransaction()
	Endif
End Transaction
IF lMsErroAuto
	MsgAlert( "ERRO NA OPERAÇÃO" )
EndIf

//Se Estorno
If lEst
   cTESORIG := cTESDEST
Endif

For nCONT := 1 to Len( aSACOS )
    lMsErroAuto := .F.
      aMATRIZ     := { { "D3_TM", cTESORIG, NIL},;
                       { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                       { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                       { "D3_LOCAL", "01", NIL },;
                       { "D3_COD", aSACOS[ nCONT, 1 ], NIL},;
                       { "D3_QUANT", aSACOS[ nCONT, 2 ], NIL },;
                       { "D3_EMISSAO", dDATABASE, NIL} }

      Begin Transaction
         MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
         IF lMsErroAuto
           DisarmTransaction()
         Endif
      End Transaction
		IF lMsErroAuto
			MsgAlert( "ERRO NA OPERAÇÃO" )
		EndIf
Next

lMsErroAuto := .F.
aMATRIZ     := { { "D3_TM", cTESDEST, NIL},;
                 { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                 { "D3_LOCAL", cGet3, NIL },;  //Local Destino
                 { "D3_COD", cGet5, NIL},;  //Produto Destino
                 { "D3_QUANT", nQtDest, NIL },;  //Quantidade Destino
                 { "D3_EMISSAO", dDATABASE, NIL} }

Begin Transaction
	MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
   IF lMsErroAuto
   	DisarmTransaction()
   Endif
End Transaction
IF lMsErroAuto
	MsgAlert( "ERRO NA OPERAÇÃO" )
EndIf

//DbSelectArea('Z10')
Reclock('Z10',.F.)
Z10->Z10_STATUS := '2'
Z10->( msUnlock() )

oDlg1:end()
Return .T.

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ relt()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function relt()
   dbSelectArea('Z10')
   Reclock('Z10',.T.)
   Z10->Z10_FILIAL := xFilial('Z10')
   Z10->Z10_COD := oSay4:cCaption
   Z10->Z10_USUARI := oSay8:cCaption
   Z10->Z10_DATA   := dDataBase
   Z10->Z10_HORA   := Left( Time(), 5 )
   Z10->Z10_PRDINI := cGet1
   Z10->Z10_PRDFIN := cGet5
   Z10->Z10_QTINI  := nGet7
   Z10->Z10_QTFIN  := val(oSay27:cCaption)
   Z10->Z10_OBS    := cmGet1
   Z10->Z10_UMINI  := oSay20:cCaption
   Z10->Z10_UMFIN  := oSay23:cCaption   
   Z10->Z10_STATUS := '1'
   Z10->( msUnlock() )
   flag				 := .F.  
   oDlg1:end()
   U_ESTTRAR( oSay4:cCaption )
return