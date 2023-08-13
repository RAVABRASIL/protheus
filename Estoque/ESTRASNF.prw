#INCLUDE 'PROTHEUS.CH'

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

User Function ESTRANSF()


SetPrvt( "oDlg1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSolicitacao,oDataSolic,oProdOrig,oQuantOrig," )
SetPrvt( "oUnOrig,oProdDest,oQuantDest,oUnDest,oSBtn1_Confirma,oSBtn2_Cancela," )

//Variaveis Locais da Funcao
Private cSolicitacao := Space(6)
Private dDataSolic := dDATABASE
Private cProdOrig := Space(6)
Private nQuantOrig := 0
Private cUnOrig := Space(10)
Private cProdDest := Space(6)
Private nQuantDest := 0
Private cUnDest := Space(10)

oDlg1 := MSDialog():Create()
oDlg1:cCaption := 'Solicitação de Transformações'
oDlg1:cName := 'oDlg1'
oDlg1:lActive := .T.
oDlg1:lCentered := .T.
oDlg1:lShowHint := .T.
oDlg1:nHeight := 232
oDlg1:nLeft := 311
oDlg1:nTop := 178
oDlg1:nWidth := 394

oSay1 := TSay():Create(oDlg1)
oSay1:cCaption := 'Solicitação'
oSay1:cName := 'oSay1'
oSay1:lActive := .T.
oSay1:lShowHint := .F.
oSay1:nClrText := CLR_RED
oSay1:nHeight := 17
oSay1:nLeft := 24
oSay1:nTop := 16
oSay1:nWidth := 65

oSay2 := TSay():Create(oDlg1)
oSay2:cCaption := 'Data da Solicitação'
oSay2:cName := 'oSay2'
oSay2:lActive := .T.
oSay2:lShowHint := .F.
oSay2:nHeight := 17
oSay2:nLeft := 160
oSay2:nTop := 16
oSay2:nWidth := 105

oSay3 := TSay():Create(oDlg1)
oSay3:cCaption := 'Produto Origem:'
oSay3:cName := 'oSay3'
oSay3:lActive := .T.
oSay3:lShowHint := .F.
oSay3:nHeight := 17
oSay3:nLeft := 24
oSay3:nTop := 56
oSay3:nWidth := 113

oSay4 := TSay():Create(oDlg1)
oSay4:cCaption := 'Quantidade'
oSay4:cName := 'oSay4'
oSay4:lActive := .T.
oSay4:lShowHint := .F.
oSay4:nHeight := 17
oSay4:nLeft := 152
oSay4:nTop := 56
oSay4:nWidth := 65

oSay5 := TSay():Create(oDlg1)
oSay5:cCaption := 'Unidade'
oSay5:cName := 'oSay5'
oSay5:lActive := .T.
oSay5:lShowHint := .F.
oSay5:nHeight := 17
oSay5:nLeft := 272
oSay5:nTop := 56
oSay5:nWidth := 49

oSay6 := TSay():Create(oDlg1)
oSay6:cCaption := 'Produto Destino:'
oSay6:cName := 'oSay6'
oSay6:lActive := .T.
oSay6:lShowHint := .F.
oSay6:nHeight := 17
oSay6:nLeft := 24
oSay6:nTop := 104
oSay6:nWidth := 81

oSay7 := TSay():Create(oDlg1)
oSay7:cCaption := 'Quantidade'
oSay7:cName := 'oSay7'
oSay7:lActive := .T.
oSay7:lShowHint := .F.
oSay7:nHeight := 17
oSay7:nLeft := 152
oSay7:nTop := 104
oSay7:nWidth := 65

oSay8 := TSay():Create(oDlg1)
oSay8:cCaption := 'Unidade'
oSay8:cName := 'oSay8'
oSay8:lActive := .T.
oSay8:lShowHint := .F.
oSay8:nHeight := 17
oSay8:nLeft := 272
oSay8:nTop := 106
oSay8:nWidth := 49

oSolicitacao := TGet():Create(oDlg1)
oSolicitacao:cName := 'oSolicitacao'
oSolicitacao:cVariable := 'cSolicitacao'
oSolicitacao:lActive := .T.
oSolicitacao:lHasButton := .F.
oSolicitacao:lPassWord := .F.
oSolicitacao:lShowHint := .F.
oSolicitacao:nHeight := 21
oSolicitacao:nLeft := 80
oSolicitacao:nTop := 16
oSolicitacao:nWidth := 65
oSolicitacao:bSetGet := {|u| If(PCount()>0,cSolicitacao:=u,cSolicitacao) } 

oDataSolic := TGet():Create(oDlg1)
oDataSolic:cName := 'oDataSolic'
oDataSolic:cVariable := 'dDataSolic'
oDataSolic:lActive := .T.
oDataSolic:lHasButton := .F.
oDataSolic:lPassWord := .F.
oDataSolic:lShowHint := .F.
oDataSolic:nHeight := 21
oDataSolic:nLeft := 264
oDataSolic:nTop := 16
oDataSolic:nWidth := 89
oDataSolic:bSetGet := {|u| If(PCount()>0,dDataSolic:=u,dDataSolic) } 

oProdOrig := TGet():Create(oDlg1)
oProdOrig:cName := 'oProdOrig'
oProdOrig:cVariable := 'cProdOrig'
oProdOrig:cF3 := 'SB1'
oProdOrig:lActive := .T.
oProdOrig:lHasButton := .F.
oProdOrig:lPassWord := .F.
oProdOrig:lShowHint := .F.
oProdOrig:nHeight := 21
oProdOrig:nLeft := 24
oProdOrig:nTop := 72
oProdOrig:nWidth := 89
oProdOrig:bSetGet := {|u| If(PCount()>0,cProdOrig:=u,cProdOrig) }
oProdOrig:bValid  := {|| ValidaProd(1) } 

oQuantOrig := TGet():Create(oDlg1)
oQuantOrig:Picture := '@E 99,999.99'
oQuantOrig:cName := 'oQuantOrig'
oQuantOrig:cVariable := 'nQuantOrig'
oQuantOrig:lActive := .T.
oQuantOrig:lHasButton := .F.
oQuantOrig:lPassWord := .F.
oQuantOrig:lShowHint := .F.
oQuantOrig:nHeight := 21
oQuantOrig:nLeft := 152
oQuantOrig:nTop := 72
oQuantOrig:nWidth := 81
oQuantOrig:bSetGet := {|u| If(PCount()>0,nQuantOrig:=u,nQuantOrig) } 

oUnOrig := TGet():Create(oDlg1)
oUnOrig:cName := 'oUnOrig'
oUnOrig:cVariable := 'cUnOrig'
oUnOrig:lActive := .T.
oUnOrig:lHasButton := .F.
oUnOrig:lPassWord := .F.
oUnOrig:lShowHint := .F.
oUnOrig:nHeight := 21
oUnOrig:nLeft := 272
oUnOrig:nTop := 72
oUnOrig:nWidth := 81
oUnOrig:bSetGet := {|u| If(PCount()>0,cUnOrig:=u,cUnOrig) }
oUnOrig:bValid  := {|| ValidaProd(1) }
oUnOrig:disable() 

oProdDest := TGet():Create(oDlg1)
oProdDest:cName := 'oProdDest'
oProdDest:cVariable := 'cProdDest'
oProdDest:cF3 := 'SB1'
oProdDest:lActive := .T.
oProdDest:lHasButton := .F.
oProdDest:lPassWord := .F.
oProdDest:lShowHint := .F.
oProdDest:nHeight := 21
oProdDest:nLeft := 24
oProdDest:nTop := 122
oProdDest:nWidth := 89
oProdDest:bSetGet := {|u| If(PCount()>0,cProdDest:=u,cProdDest) }
oProdDest:bValid  := {|| ValidaProd(2) } 

oQuantDest := TGet():Create(oDlg1)
oQuantDest:Picture := '@E 99,999.99'
oQuantDest:cName := 'oQuantDest'
oQuantDest:cVariable := 'nQuantDest'
oQuantDest:lActive := .T.
oQuantDest:lHasButton := .F.
oQuantDest:lPassWord := .F.
oQuantDest:lShowHint := .F.
oQuantDest:nHeight := 21
oQuantDest:nLeft := 152
oQuantDest:nTop := 120
oQuantDest:nWidth := 83
oQuantDest:bSetGet := {|u| If(PCount()>0,nQuantDest:=u,nQuantDest) } 

oUnDest := TGet():Create(oDlg1)
oUnDest:cName := 'oUnDest'
oUnDest:cVariable := 'cUnDest'
oUnDest:lActive := .T.
oUnDest:lHasButton := .F.
oUnDest:lPassWord := .F.
oUnDest:lShowHint := .F.
oUnDest:nHeight := 21
oUnDest:nLeft := 272
oUnDest:nTop := 122
oUnDest:nWidth := 81
oUnDest:bSetGet := {|u| If(PCount()>0,cUnDest:=u,cUnDest) } 
oUnDest:bValid  := {|| ValidaProd(2) }
oUnOrig:disable()

oSBtn1_Confirma := SButton():Create(oDlg1)
oSBtn1_Confirma:cName := 'oSBtn1_Confirma'
oSBtn1_Confirma:lActive := .T.
oSBtn1_Confirma:lShowHint := .F.
oSBtn1_Confirma:nHeight := 22
oSBtn1_Confirma:nLeft := 24
oSBtn1_Confirma:nTop := 160
oSBtn1_Confirma:nType := 1
oSBtn1_Confirma:nWidth := 52
//oSBtn1:bLDBLClick := {|| Botoes(1) }

oSBtn2_Cancela := SButton():Create(oDlg1)
oSBtn2_Cancela:cName := 'oSBtn2_Cancela'
oSBtn2_Cancela:lActive := .T.
oSBtn2_Cancela:lShowHint := .F.
oSBtn2_Cancela:nHeight := 22
oSBtn2_Cancela:nLeft := 96
oSBtn2_Cancela:nTop := 160
oSBtn2_Cancela:nType := 2
oSBtn2_Cancela:nWidth := 52
oSBtn2:bLClicked := {|| oDlg1:end() }  

oDlg1:Activate()   




Return


***************
                                       
Static Function Validaprod( nPOS )

***************

If ! SB1->( Dbseek( xFilial( "SB1" ) + If( nPOS == 1, cProdOrig, cProdDest ) ) )
   MsgAlert( "Produto nao cadastrado" )
   Return .F.
EndIf
If SB1->B1_ATIVO == "N"
   MsgAlert( "Produto Inativo" )
   Return .F.
   
Else
   If cPRODORIG == cPRODDEST
      MsgAlert( "Produto destino tem que ser diferente do Produto origem" )
      Return .F.
   endif  
Endif

If nPOS = 1 
	cUnOrig := SB1->B1_UM
 Else 
 	if nPOS = 2
	cUnDest := SB1->B1_UM
	endif 
endif

Return .T. 

