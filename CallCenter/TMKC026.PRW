#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'PROTHEUS.CH'

/*-------------------------------------------------------------------------------------*/
//Programa: TMKC026.prw
//Autoria : Flávia Rocha
//Data    : 18/07/2011
//Objetivo: Mostrar árvore para consulta das NFs e seus respectivos atendimentos gerados
//          pela rotina SAC, bem como as ocorrências (se existirem) associadas a estes
//          atendimentos.
/*-------------------------------------------------------------------------------------*/

**************************
User Function TMKC026()
***************************

If Pergunte("VIEWSAC",.T.)
   MsAguarde( { || ViewSAC() }, "Aguarde. . .", "Acompanhamento do SAC . . ." )
Endif

Return

***************************
Static Function ViewSAC()
***************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

 LOCAL oDlg1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//SetPrvt("oFont1","oDlg1","oSay1","oBtn1","oBtn2","oBtn3","oTree1","oBtn4","oBrw1")
SetPrvt("oFont1","oSay1","oBtn1","oBtn2","oBtn3","oTree1","oBtn4","oBrw1")
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )

//tela
oDlg1      := MSDialog():New( 126,255,691,984,"Acompanhamento do SAC",,,.F.,,,,,,.T.,,,.T. )
//oDlg1      := MSDialog():New( 126,255,691,1154,"Acompanhamento do SAC",,,.F.,,,,,,.T.,,,.T. )

//botao
oBtn3      := TButton():New( 005,308,"Visualizar",oDlg1,{||Visualiza()},050,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 021,308,"Imprimir",oDlg1,{|| U_TMKR001V2()},050,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 038,308,"Legenda",oDlg1,{|| U_SACLeg()},050,012,,,,.T.,,"",,,,.F. )
oBtn6      := TButton():New( 055,308,"Sair",oDlg1,{||oDlg1:End()},050,012,,,,.T.,,"",,,,.F. )

//arvore
oTree1     := DbTree():New( 005,004,280,304,oDlg1,{ || atualiza() },,.F.,.F. )

//If !Empty(MV_PAR01)
	if oTree1:Nivel() = 1
	   oBtn3:Disable()
	else
	   oBtn3:Enable()  
	endIf 
//Else
//	oBtn3:Enable()  
//Endif

NFFis(1)
If !Empty(MV_PAR05)
	Carteira(1)
Endif

oDlg1:Activate(,,,.T.)

Return

***************************
Static Function NFFis(nOpc)
***************************

Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local lTem  := .F.

cQuery += "SELECT A1_COD,A1_LOJA,A1_NOME,F2_DOC,F2_SERIE, F2_EMISSAO, *  " + LF
cQuery += "FROM "+RetSqlName("SF2")+" SF2, " + LF
cQuery += " "    +RetSqlName("SA1")+" SA1 " + LF

cQuery += " WHERE  SF2.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND (SF2.F2_CLIENTE + SF2.F2_LOJA) = (SA1.A1_COD + SA1.A1_LOJA) " + LF
If !Empty(MV_PAR01) //.AND. !Empty(MV_PAR02)
	//cQuery += " AND SF2.F2_DOC between '"+alltrim(mv_par01)+"' and '"+alltrim(mv_par02)+"' " + LF
	cQuery += " AND SF2.F2_DOC = '"+alltrim(mv_par01)+"' " + LF
	cQuery += " AND SF2.F2_SERIE = '0' " + LF
	
	If !Empty(MV_PAR02) .AND. !Empty(MV_PAR03)
		cQuery += " AND SF2.F2_EMISSAO between '"+dtos(mv_par02)+"' and '"+dtos(mv_par03)+"'  " + LF
	Endif

Endif
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' " + LF


If !Empty(MV_PAR04)
	cQuery += " AND SF2.F2_EST = '"+ Alltrim(mv_par04)+ "' " + LF
Endif

If !Empty(MV_PAR05) .AND. !Empty(MV_PAR06)  //.and. !Empty(MV_PAR08) .AND. !Empty(MV_PAR09)
	//cQuery += " AND (SF2.F2_CLIENTE + SF2.F2_LOJA)  between '" + Alltrim(mv_par06 + mv_par07) +"' and '"+ Alltrim(mv_par08+ mv_par09)+"'  " + LF
	cQuery += " AND (SF2.F2_CLIENTE + SF2.F2_LOJA) =  '" + Alltrim(mv_par05 + mv_par06) +"'  " + LF
Endif

cQuery += " ORDER BY SF2.F2_DOC  " + LF 
MemoWrite("C:\TEMP\TMKC026.SQL",cQuery )
If Select("AUXX") > 0
	DbSelectArea("AUXX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUXX"
TCSetField("AUXX", "F2_EMISSAO", "D")
DbSelectArea("AUXX")
AUXX->(DbGoTop())

if nOpc=1 // cria a arvore      
	If !Empty(MV_PAR01)
		oTree1:AddTree(Padr("Notas Fiscais",100), .T.)
	
		while AUXX->(!EOF())   
			If !Empty(MV_PAR01) //FR - 23/08/13 - PERMITIR CONSULTAR ATENDIMENTOS NÃO ASSOCIADOS A NF
			                    //SE FOI FORNECIDO O NÚMERO DA NF)
		 		lTem := PegAtend(AUXX->F2_DOC,AUXX->F2_SERIE,2, "NF" )     //opc = 2 , não cria árvore, só verifica
		 		If lTem	 
				 	//SE TIVER OCORRÊNCIA, muda a cor da pasta
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), .T.)
				 	//msgbox("tem ocorrência")	 	
				 	//AddTree ( [ cPrompt], [ lOpened], [ cRes1], [ cRes2], [ cFile1], [ cFile2], [ cCargo] )
				 	
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER10")  //PASTA VERDE                                
				 	oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER6")  //PASTA AMARELA ABERTA    //CRIA CABEÇA ÁRVORE COM A NF - NOME CLIENTE
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER7")  //PASTA VERMELHA
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER8")  //PASTA VERMELHA ABERTA
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER9")  //NÃO EXISTE
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER1")  //NÃO EXISTE                                
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER2")  //NÃO EXISTE                                
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER3")  //NÃO EXISTE                                
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER4")  //NÃO EXISTE                                
				 	
				 Else    //NÃO TEM OCORRÊNCIA, FICA SÓ A CABEÇA DA ÁRVORE:
				 	//oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), lTem, "FOLDER5") //PASTA AMARELA FECHADA - pasta amarela
				 	oTree1:AddTree(Padr(AUXX->F2_DOC+" - "+AUXX->A1_NOME,150), .T.) //CRIA CABEÇA ÁRVORE COM A NF - NOME CLIENTE
				 Endif
				 PegAtend(AUXX->F2_DOC,AUXX->F2_SERIE,1,"NF")     //PEGA ATENDIMENTO	 
		 	 
		 	Endif  //se tem nota
		 
		 //PegAtend(AUXX->F2_DOC,AUXX->F2_SERIE,1)     //PEGA ATENDIMENTO	 
		 oTree1:EndTree()
		 AUXX->(DbSkip())
		end
		oTree1:EndTree()
	Else
		oTree1:AddTree(Padr("Atendimentos",100), .T.)
	
		lTem := PegAtend(AUXX->A1_COD,AUXX->A1_LOJA,2, "")     //opc = 2 , não cria árvore, só verifica
		If lTem	 
		 	//SE TIVER OCORRÊNCIA, muda a cor da pasta			 
		 	oTree1:AddTree(Padr(AUXX->A1_COD + '/' + AUXX->A1_LOJA +" - "+AUXX->A1_NOME,150), lTem, "FOLDER6")  //PASTA AMARELA ABERTA
		Else
			oTree1:AddTree(Padr(AUXX->A1_COD + '/' + AUXX->A1_LOJA +" - "+AUXX->A1_NOME,150), .T.) //CRIA CABEÇA ÁRVORE COM A NF - NOME CLIENTE
		Endif
		
		PegAtend('','',1, '', AUXX->A1_COD, AUXX->A1_LOJA)     //PEGA ATENDIMENTO	
		oTree1:EndTree()
	Endif //se tem nota ou não
	
	
	////PEDIDOS EM CARTEIRA
	/*
	oTree1:AddTree(Padr("Pedidos Carteira",100), .T.)
	AUXX->(DbGoTop())
	while AUXX->(!EOF())   
	 	Carteira(AUXX->A1_COD,AUXX->A1_LOJA,1)     //PEGA PEDIDO CARTEIRA		 	 
	 	oTree1:EndTree()
	 AUXX->(DbSkip())
	end
	oTree1:EndTree()
	*/
	/////FIM. PED. CARTEIRA
	
    AUXX->(DbCloseArea())
endif

Return(lTem)

***************************
//Static Function Carteira(cCliente, cLoja, nOpc)
Static Function Carteira(nOpc)
***************************

Local cQuery:=''
Local LF	:= CHR(13) + CHR(10) 
Local lTem  := .F.

//cQuery := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cQuery := "Select C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ENTREG " + LF
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + LF
cQuery += "     " + RetSqlName( "SC5" ) + " SC5, " + LF
cQuery += "     " + RetSqlName( "SC6" ) + " SC6, " + LF
cQuery += "     " + RetSqlName( "SC9" ) + " SC9, " + LF
cQuery += "     " + RetSqlName( "SA1" ) + " SA1  " + LF
cQuery += " WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 " + LF
cQuery += " AND SC6.C6_BLQ <> 'R' " + LF
cQuery += " AND SB1.B1_TIPO = 'PA' "  + LF
cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD " + LF
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM " + LF
cQuery += " AND SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " + LF
cQuery += " AND SC9.C9_PEDIDO = SC5.C5_NUM " + LF
//cQuery += " AND SC9.C9_BLCRED = '  ' " + LF
// NOVA LIBERACAO DE CRETIDO
cQuery += " AND SC9.C9_BLCRED IN( '  ','04') " + LF
cQuery += " AND SC9.C9_BLEST != '10' " + LF
cQuery += " AND SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA " + LF
cQuery += " AND SC6.C6_TES NOT IN( '540','516') "  + LF //Remessa MIXKIT, AMOSTRA 

If !Empty(MV_PAR05) .AND. !Empty(MV_PAR06)  //.and. !Empty(MV_PAR08) .AND. !Empty(MV_PAR09)
	//cQuery += " AND (SC5.C5_CLIENTE + SC5.C5_LOJACLI)  between '" + Alltrim(mv_par06 + mv_par07) +"' and '"+ Alltrim(mv_par08+ mv_par09)+"'  " + LF
	cQuery += " AND SC5.C5_CLIENTE  = '" + Alltrim(mv_par05) + "' " + LF
	cQuery += " AND SC5.C5_LOJACLI  = '" + Alltrim(mv_par06) + "' " + LF
Endif

//cQuery += " AND SC5.C5_CLIENTE = '"+ Alltrim(cCliente) + "' " + LF
//cQuery += " AND SC5.C5_LOJACLI = '"+ Alltrim(cLoja) + "' " + LF
cQuery += " AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "  + LF
cQuery += " AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' " + LF
//cQuery += "SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND SF4.D_E_L_E_T_ = ' ' 
cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ENTREG " + LF
cQuery += " ORDER BY C5_ENTREG, C5_NUM " + LF

MemoWrite("C:\Temp\Cart_TMKC026.SQL", cQuery) 
If Select("F2XX") > 0
	DbSelectArea("F2XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "F2XX"
TCSetField("F2XX", "C5_ENTREG", "D")
DbSelectArea("F2XX")
F2XX->(DbGoTop())

if nOpc=1 // cria a arvore
	If !F2XX->(EOF())
	      
		//oTree1:AddTree(Padr("Pedidos Carteira",100), .T.)  //
		//oTree1:EndTree() //
		  oTree1:AddTree(Padr("Ped. Carteira Imediata",100), .T.)
		while F2XX->(!EOF())
			If F2XX->C5_ENTREG <= dDatabase //'"+ dtos( lastday( dDataUso ) )
		 		oTree1:AddTree(Padr(F2XX->C5_NUM,150), .T.)
		 		oTree1:EndTree()
		 	Endif
		 	//PegAtend(F2XX->F2_DOC,F2XX->F2_SERIE,1)     //PEGA ATENDIMENTO
		 
		 
		 F2XX->(DbSkip())
		end
		oTree1:EndTree()
		
		F2XX->(DbGoTop()) 
		oTree1:AddTree(Padr("Ped. Carteira Programada",100), .T.)
		while F2XX->(!EOF())
			If F2XX->C5_ENTREG > (dDatabase + 1)
		 		oTree1:AddTree(Padr(F2XX->C5_NUM,150), .T.)
		 		oTree1:EndTree()
		 	Endif
		 	//PegAtend(F2XX->F2_DOC,F2XX->F2_SERIE,1)     //PEGA ATENDIMENTO		 
		 F2XX->(DbSkip())
		end
		//oTree1:EndTree()
		DbSelectArea("F2XX")
	    F2XX->(DbCloseArea())
	    oTree1:EndTree() //do "pedidos Carteira"
	Endif
endif

Return



*********************************************
Static Function PegAtend(cNF, cSerie, nOpc, cComNF, cCli, cLJ ) 
*********************************************

Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local lTem  := .F.


cQuery += "SELECT * "+ LF
cQuery += "FROM "+ LF
cQuery += " "    +RetSqlName("SUC")+" SUC " + LF
cQuery += "WHERE  "+ LF
cQuery += " SUC.D_E_L_E_T_ = ''  "+ LF

If Alltrim(cComNF) = "NF"
	cQuery += " AND SUC.UC_NFISCAL = '" + Alltrim(cNF) + "'  "+ LF
	cQuery += " AND SUC.UC_SERINF = '" + Alltrim(cSerie) + "'  "+ LF 
Else                                                                 
	cQuery += " AND SUC.UC_CHAVE = '" + Alltrim(cCli) + Alltrim(cLJ) + "'  "+ LF
Endif
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' " + LF
MemoWrite("C:\TEMP\PEGATEND.SQL" , cQuery )
If Select("SUCXX") > 0
	DbSelectArea("SUCXX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUCXX"
TcSetField("SUCXX", "UC_PREVCHG", "D")
TcSetField("SUCXX", "UC_REALCHG", "D")

DbSelectArea("SUCXX")
SUCXX->(DbGoTop())

if nOpc=1 // cria a arvore      
	If Alltrim(cComNF) = "NF"
		oTree1:AddTree(Padr("Atendimento",100), .T.)
	Endif
	while SUCXX->(!EOF() )
		If Alltrim(cComNF) = "NF"
			 dPrev:= SUCXX->UC_PREVCHG
			 dReal:= SUCXX->UC_REALCHG 
			 If !Empty(dReal) 
			 	oTree1:AddTree(Padr(SUCXX->UC_CODIGO + " - Prev.Cheg: " + Dtoc(dPrev) + " - Chegada: " + Dtoc(dReal),150), .T.)
		
			 Else
			 	oTree1:AddTree(Padr(SUCXX->UC_CODIGO + " - Prev.Cheg: " + Dtoc(dPrev),150), .T.)
			 Endif
		Else                                                                                    
			oTree1:AddTree(Padr(SUCXX->UC_CODIGO ,150), .T.)
		Endif //se tem NF
	 lTem := Ocorr(SUCXX->UC_CODIGO,1)      //pega OCORRÊNCIA
	 oTree1:EndTree()
	 SUCXX->(DbSkip())
	end
	oTree1:EndTree()
	SUCXX->(DbCloseArea())
	Return


else
	If SUCXX->(!EOF() )	 
	 lTem := Ocorr(SUCXX->UC_CODIGO,2)      //pega OCORRÊNCIA	
	endif
	SUCXX->(DbCloseArea()) 
	Return(lTem)

endif




***********************************
Static Function Ocorr(cAtend,nOpc)   
***********************************
Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local cResp	:= ""
Local aUsu	:= {}
Local cProblema := ""
Local lTem  := .F.

cQuery:="SELECT * " + LF
cQuery+="FROM " + LF
cQuery+=" " + RetSqlName("SUD") + " SUD " + LF
cQuery+="WHERE UD_CODIGO = '" + Alltrim(cAtend) + "' " + LF
cQuery+=" AND SUD.UD_OPERADO <> '' " + LF
cQuery+=" AND SUD.D_E_L_E_T_!='*' " + LF
cQuery+=" AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' " + LF
cQuery+="ORDER BY UD_ITEM  " + LF
If Select("SUDXX") > 0
	DbSelectArea("SUDXX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUDXX"

DbSelectArea("SUDXX")
SUDXX->(DbGoTop()) 
if nOpc=1 // cria a arvore

 If !SUDXX->(EOF())
 	oTree1:AddTree(Padr("Ocorrências",100), .T.)      

	while SUDXX->(!EOF() )
		lTem := .T.
		
	 PswOrder(1)
     If PswSeek( SUDXX->UD_OPERADO, .T. )    //UD_OPERADO
     	aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   		cResp   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)	 
     Endif
	 cProblema := iif(!Empty(SUDXX->UD_N1),Alltrim(Posicione("Z46",1,xFilial("Z46")+ SUDXX->UD_N1,"Z46_DESCRI")),"")+;
				                   iif(!Empty(SUDXX->UD_N2),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+ SUDXX->UD_N2,"Z46_DESCRI")),"")+;
				                   iif(!Empty(SUDXX->UD_N3),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+ SUDXX->UD_N3,"Z46_DESCRI")),"")+;
				                   iif(!Empty(SUDXX->UD_N4),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+ SUDXX->UD_N4,"Z46_DESCRI")),"")+;
				                   iif(!Empty(SUDXX->UD_N5),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+ SUDXX->UD_N5,"Z46_DESCRI")),"") 
	 
	 oTree1:AddTree(Padr("Item: " + SUDXX->UD_ITEM + " - Resp: " + Alltrim(cResp) + " ==> " + Alltrim(cProblema),150), .T.)
	 Histor(SUDXX->UD_CODIGO,SUDXX->UD_ITEM, cResp,1) ///PEGA HISTÓRICO DE RESPOSTAS
	 oTree1:EndTree()
	 SUDXX->(DbSkip())
	end
	oTree1:EndTree()
	DbSelectArea("SUDXX")
	SUDXX->(DbCloseArea())
	Return
 Endif
 
else
	If SUDXX->(!EOF() )
		lTem := .T.	 
	endif
	DbSelectArea("SUDXX")
	SUDXX->(DbCloseArea()) 
	Return(lTem)

endif



******************************************************
Static Function Histor(cOcorr,cItem, cCliente,nOpc)  //pega histórico de respostas
******************************************************
Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local cLegenda := ""
Local nMax  := 0

cQuery:="SELECT UD_STATUS, UD_OBS, ZUD_OBSATE, UD_JUSTIFI, ZUD_OBSRES, UD_DATA,  * " + LF
cQuery+="FROM " + LF 
cQuery+=" " + RetSqlName("ZUD") + " ZUD, " + LF
cQuery+=" " + RetSqlName("SUD") + " SUD " + LF
cQuery+=" WHERE  ZUD_CODIGO ='" + Alltrim(cOcorr)+"'  " + LF
cQuery+=" AND ZUD_ITEM = '" + Alltrim(cItem) + "' " + LF
cQuery+=" AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' " + LF
cQuery+=" AND ZUD.D_E_L_E_T_ = '' " + LF
cQuery+=" AND SUD.D_E_L_E_T_ = '' " + LF
cQuery+=" AND ZUD.ZUD_FILIAL = SUD.UD_FILIAL " + LF
cQuery+=" AND ZUD.ZUD_CODIGO = SUD.UD_CODIGO " + LF
cQuery+=" AND ZUD.ZUD_ITEM   = SUD.UD_ITEM " + LF

cQuery+=" ORDER BY ZUD.R_E_C_N_O_ , (ZUD_DTENV + ZUD_HRENV) " + LF //AQUI PRECISA EXIBIR POR ORDEM DE INCLUSÃO DOS ENVIOS
                                                                    //EVITA QUE ENVIOS '0' (QDO O USUÁRIO RESPONDE SEM ENVIO), FIQUE 1o. QUE OS ENVIOS REGULARES
MemoWrite("C:\Temp\histor.sql", cQuery )
IF SELECT("ZUDXX") > 0
	DBSELECTAREA("ZUDXX")
	DBCLOSEAREA()
ENDIF

TCQUERY cQuery NEW ALIAS "ZUDXX"
TcSetField("ZUDXX", "ZUD_DTRESP", "D")
TcSetField("ZUDXX", "ZUD_DTSOL", "D")
TcSetField("ZUDXX", "ZUD_DTENV", "D")
TcSetField("ZUDXX", "ZUD_DTRESO", "D")
TcSetField("ZUDXX", "UD_DATA", "D")
TcSetField("ZUDXX", "UD_DTRESP", "D")
TcSetField("ZUDXX", "UD_DTRESOL", "D")


DbSelectArea("ZUDXX")
ZUDXX->(DbGoTop()) 
If ZUDXX->(!EOF())
	while ZUDXX->(!EOF() )  
	    nMax := ZUDXX->ZUD_NRENV
		ZUDXX->(DBSKIP())
	enddo
Endif


DbSelectArea("ZUDXX")
ZUDXX->(DbGoTop()) 
If nOpc=1 // cria a arvore      
	If ZUDXX->(!EOF())	
		oTree1:AddTree(Padr("Histórico: Envios / Respostas",100), .T.)
		while ZUDXX->(!EOF() )  
			 oTree1:AddTree(Padr("Envio Nr.: " + Alltrim(Str(ZUDXX->ZUD_NRENV)) + " - Dt.: " + Dtoc(ZUDXX->ZUD_DTENV) + " - Hr.: " + ZUDXX->ZUD_HRENV,100), .T.)
		
			 //If ZUDXX->ZUD_RESOLV = 'S'
			 If ZUDXX->ZUD_NRENV = nMax     //evita que deixe a legenda preta em todos os envios
				 If ZUDXX->UD_STATUS = '2'
				 	cLegenda := "BR_PRETO"
				 Else
				 	cLegenda := "BR_VERDE"
				 Endif
			 Else
			 	cLegenda := "BR_VERDE"			 
			 Endif
			 
			 If !Empty(ZUDXX->ZUD_OBSRES) .and. !Empty(ZUDXX->UD_JUSTIFI) 
			 //COMPARO SE OS DOIS ESTÃO PREENCHIDOS, POIS EM CASO DE SOMENTE O UD_JUSTIFI ESTAR PREENCHIDO, NO PRÓXIMO ELSE, USAREI ELE				
				 oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(ZUDXX->ZUD_OBSATE) ,150), cLegenda)
				 oTree1:AddTreeItem(PadR( "Resposta: " + Alltrim(ZUDXX->ZUD_OBSRES) ,150), cLegenda )
				 oTree1:AddTreeItem(PadR( "Data p/ Solução: " + DtoC(ZUDXX->ZUD_DTSOL)+' - Dt.Respondeu: ' + Dtoc(ZUDXX->ZUD_DTRESP) +' - Hr.Respondeu: ' + ZUDXX->ZUD_HRRESP ,150),cLegenda )
				 //If ZUDXX->ZUD_RESOLV = 'S'
				 If ZUDXX->ZUD_NRENV = nMax	//evita que deixe a legenda preta em todos os envios
					 If ZUDXX->UD_STATUS = '2'
					 	oTree1:AddTreeItem(PadR( "Encerrado pelo SAC: " + Dtoc(ZUDXX->ZUD_DTRESO) + " - Hora: " + ZUDXX->ZUD_HRRESO,100), "BR_PRETO" )
					 	oTree1:AddTreeItem(PadR( "Obs Encerrto: " + ZUDXX->ZUD_OBSENC,150), "BR_PRETO" )
					 Endif
				 Endif
			 //
			 Elseif !Empty(ZUDXX->UD_JUSTIFI) //FR - 21/05/14
			 	oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(ZUDXX->ZUD_OBSATE) ,150), cLegenda)
				 oTree1:AddTreeItem(PadR( "Resposta: " + Alltrim(ZUDXX->UD_JUSTIFI) ,150), cLegenda )
				 oTree1:AddTreeItem(PadR( "Data p/ Solução: " + DtoC(ZUDXX->UD_DATA)+' - Dt.Respondeu: ' + Dtoc(ZUDXX->UD_DTRESP) +' - Hr.Respondeu: ' + ZUDXX->UD_HRRESP ,150),cLegenda )
				
				 If ZUDXX->ZUD_NRENV = nMax	//evita que deixe a legenda preta em todos os envios
					 If ZUDXX->UD_STATUS = '2'
					 	oTree1:AddTreeItem(PadR( "Encerrado pelo SAC: " + Dtoc(ZUDXX->UD_DTRESOL) + " - Hora: " + ZUDXX->UD_HRRESOL,100), "BR_PRETO" )
					 	oTree1:AddTreeItem(PadR( "Obs Encerrto: " + ZUDXX->UD_OBSENC,150), "BR_PRETO" )
					 Endif
				 Endif
				 
			 Else
			    				 
				 If ZUDXX->ZUD_NRENV = nMax	//evita que deixe a legenda preta em todos os envios
					 If ZUDXX->UD_STATUS = '2'
					 	cLegenda := "BR_PRETO"
					 Else
					 	cLegenda := "BR_BRANCO"
					 Endif
				 Else
				 	cLegenda := "BR_BRANCO"			 
				 Endif
			 	oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(ZUDXX->ZUD_OBSATE) ,150), cLegenda )		//BRANCO É A BOLINHA DO SAC
			 	oTree1:AddTreeItem(PadR( "Resposta: Sem resposta" ,100), cLegenda )
			 	If ZUDXX->ZUD_RESOLV = 'S'
				 	oTree1:AddTreeItem(PadR( "Encerrado pelo SAC: " + Dtoc(ZUDXX->ZUD_DTRESO) + " - Hora: " + ZUDXX->ZUD_HRRESO,100), cLegenda )
				 	oTree1:AddTreeItem(PadR( "Obs Encerrto: " + ZUDXX->ZUD_OBSENC,150), cLegenda )
				 Endif
			 	 
			 Endif
			 
			 oTree1:EndTree()
			 ZUDXX->(DbSkip())
		enddo
		oTree1:EndTree()
	
	
		ZUDXX->(DbCloseArea())
	Else  //se não trouxe nada, faz esta outra query só no SUD 
	
		///SÓ SUD
		cQuery:="SELECT UD_STATUS, * " + LF
		cQuery+="FROM " + LF 	
		cQuery+=" " + RetSqlName("SUD") + " SUD " + LF
		cQuery+=" WHERE  UD_CODIGO ='" + Alltrim(cOcorr)+"'  " + LF
		cQuery+=" AND UD_ITEM = '" + Alltrim(cItem) + "' " + LF
		cQuery+=" AND UD_FILIAL = '" + xFilial("SUD") + "' " + LF
		cQuery+=" AND SUD.D_E_L_E_T_ = '' " + LF		
		cQuery+=" ORDER BY UD_ITEM , (UD_DTENVIO + UD_HRENVIO) " + LF //AQUI PRECISA EXIBIR POR ORDEM DE INCLUSÃO DOS ENVIOS
		                                                                    //EVITA QUE ENVIOS '0' (QDO O USUÁRIO RESPONDE SEM ENVIO), FIQUE 1o. QUE OS ENVIOS REGULARES
		MemoWrite("C:\Temp\historSUD.sql", cQuery )
		IF SELECT("TEMPX") > 0
			DBSELECTAREA("TEMPX")
			DBCLOSEAREA()
		ENDIF
		
		TCQUERY cQuery NEW ALIAS "TEMPX"
		TcSetField("TEMPX", "UD_DTRESP", "D")
		TcSetField("TEMPX", "UD_DATA", "D")
		TcSetField("TEMPX", "UD_DTENVIO", "D")
		TcSetField("TEMPX", "UD_DTRESOL", "D")
		TcSetField("TEMPX", "UD_DTINCLU", "D")
		
		DbSelectArea("TEMPX")
		TEMPX->(DbGoTop()) 
		If TEMPX->(!EOF())
			while TEMPX->(!EOF() ) 
				
				//oTree1:AddTree(Padr("Envio Nr.: " + Alltrim(Str(TEMPX->UD_NRENVIO)) + " - Dt.: " + Dtoc(TEMPX->UD_DTENVIO) + " - Hr.: " + TEMPX->UD_HRENVIO,100), .T.)
				//oTree1:AddTree(Padr("Envio Nr.: " + Alltrim(Str(TEMPX->UD_NRENVIO)) + " - Dt.: " + Dtoc(TEMPX->UD_DTINCLU) + " - Hr.: " + TEMPX->UD_HRINCLU,100), .T.)
				oTree1:AddTree(Padr("Envio Nr.: 1" + " - Dt.: " + Dtoc(TEMPX->UD_DTINCLU) + " - Hr.: " + TEMPX->UD_HRINCLU,100), .T.)
		
				 //If TEMPX->ZUD_RESOLV = 'S'
				 If TEMPX->UD_NRENVIO = nMax     //evita que deixe a legenda preta em todos os envios
					 If TEMPX->UD_STATUS = '2'
					 	cLegenda := "BR_PRETO"
					 Else
					 	cLegenda := "BR_VERDE"
					 Endif
				 Else
				 	cLegenda := "BR_VERDE"			 
				 Endif
			 
				 If !Empty(TEMPX->UD_JUSTIFI) 
				 //COMPARO SE OS DOIS ESTÃO PREENCHIDOS, POIS EM CASO DE SOMENTE O UD_JUSTIFI ESTAR PREENCHIDO, NO PRÓXIMO ELSE, USAREI ELE				
					 oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(TEMPX->UD_OBS) ,150), cLegenda)
					 oTree1:AddTreeItem(PadR( "Resposta: " + Alltrim(TEMPX->UD_JUSTIFI) ,150), cLegenda )
					 oTree1:AddTreeItem(PadR( "Data p/ Solução: " + DtoC(TEMPX->UD_DATA)+' - Dt.Respondeu: ' + Dtoc(TEMPX->UD_DTRESP) +' - Hr.Respondeu: ' + TEMPX->UD_HRRESP ,150),cLegenda )
					 //If TEMPX->ZUD_RESOLV = 'S'
					 If TEMPX->UD_NRENVIO = nMax	//evita que deixe a legenda preta em todos os envios
						 If TEMPX->UD_STATUS = '2'
						 	oTree1:AddTreeItem(PadR( "Encerrado pelo SAC: " + Dtoc(TEMPX->UD_DTRESOL) + " - Hora: " + TEMPX->UD_HRRESOL,100), "BR_PRETO" )
						 	oTree1:AddTreeItem(PadR( "Obs Encerrto: " + TEMPX->UD_OBSENC,150), "BR_PRETO" )
						 Endif
					 Endif			 
					 
				 Else
			    				 
					 If TEMPX->UD_NRENVIO = nMax	//evita que deixe a legenda preta em todos os envios
						 If TEMPX->UD_STATUS = '2'
						 	cLegenda := "BR_PRETO"
						 Else
						 	cLegenda := "BR_BRANCO"
						 Endif
					 Else
					 	cLegenda := "BR_BRANCO"			 
					 Endif
				 	oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(TEMPX->UD_OBS) ,150), cLegenda )		//BRANCO É A BOLINHA DO SAC
				 	oTree1:AddTreeItem(PadR( "Resposta: Sem resposta" ,100), cLegenda )
				 	If TEMPX->UD_RESOLVI = 'S'
					 	oTree1:AddTreeItem(PadR( "Encerrado pelo SAC: " + Dtoc(TEMPX->UD_DTRESOL) + " - Hora: " + TEMPX->UD_HRRESOL,100), cLegenda )
					 	oTree1:AddTreeItem(PadR( "Obs Encerrto: " + TEMPX->UD_OBSENC,150), cLegenda )
					Endif
			 	 
			 	Endif
			 
				 oTree1:EndTree()
				 TEMPX->(DbSkip())
			 
			enddo
		
		Endif
		///SÓ SUD
	
	Endif  //se não é fim de arquivo
	
Endif    //se nopc = 1
	
Return



****************************
Static Function Atualiza()
****************************

If !Empty(MV_PAR01)  //se tem nota fiscal, a ordem dos níveis é diferente qdo não tem nf
	if 	oTree1:Nivel() = 1  .OR. oTree1:Nivel() = 3;
	    .OR. oTree1:Nivel() = 5  .OR. oTree1:Nivel() = 7;
	    .OR. oTree1:Nivel() = 9
	    
	    oBtn3:Disable()
	else
	   oBtn3:Enable()  
	endIf
ELSE //NÃO TEM NF
	if 	oTree1:Nivel() <> 3	    
	    oBtn3:Disable()
	else
	   oBtn3:Enable()  
	endIf
	
Endif

Return 


****************************
Static Function Visualiza()
****************************

Local nRecnoNF:=0
Local nRecnoAT:=0
Local cDoc
Local cSerie
Local cTipo
Local cCliente
Local cLoja
Local cCodCont := ""
Local cEntidade:= ""
Local cAtend   :="" 
Local nRecno   := 0
Local cNivel   := ""
Local nOpca    := 0 

Private aRotina := {	{	OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
							{ OemToAnsi("Visual"),"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
							{ OemToAnsi("Incluir"),"A410Inclui"	,0,3,0 ,NIL},;		//"Incluir"
							{ OemToAnsi("Alterar"),"A410Altera"	,0,4,20,NIL},;		//"Alterar"
							{ OemToAnsi("Excluir"),"A410Deleta",,0,5,0,NIL} } // Excluir
						

DbSelectArea("SC5")
DbSetOrder(1) 

/*
Nível 1 = NFs
Nível 1 = Pedidos Carteira Imediata
Nível 1 = Pedidos Carteira Programada
Nível 2 = Número da NF
Nível 2 = Número do Pedido
Nível 3 = Atendimento
Nível 4 = Código Atendimento
*/
cNivel := Str(oTree1:Nivel())
If !Empty(MV_PAR01)   
	if oTree1:Nivel()=2 // NF 
	   DbSelectArea("SF2")
	   DbSetOrder(1)
	   If SF2->(DbSeek(xFilial("SF2")+substr(oTree1:GetPrompt(),1,9),.F.))
	      
	      cDoc    := SF2->F2_DOC
	      cSerie  := SF2->F2_SERIE
	      cCliente:= SF2->F2_CLIENTE
	      cLoja   := SF2->F2_LOJA
	      cTipo   := SF2->F2_TIPO 
	      //msginfo("Visualiza NF: " + cDoc + "/" + cSerie )
	      U_VisualNF(cDoc,cSerie,cCliente,cLoja,cTipo)
	   
	   Elseif SC5->(DbSeek(xFilial("SC5")+substr(oTree1:GetPrompt(),1,6) ,.F.))
	   	  cPed := SC5->C5_NUM
	   	  cCliente:= SC5->C5_CLIENTE
	      cLoja   := SC5->C5_LOJACLI
	      cTipo   := SC5->C5_TIPO
	      nRecno  := SC5->(RECNO())
	      //msginfo("Visualiza Pedido: " + cPed + '-> Nivel: ' + cNivel)
	      //msginfo("Visualiza Pedido: " + cPed )
	      //MSGINFO("Visualizar Pedido: Opção EM DESENVOLVIMENTO..." )
	   	  //nOpca := A410Visual("SC5",nRecno,2)		//A410Visual(cAlias,nReg,nOpc)
	   	  nOpca := U_A410Visual("SC5", nRecno, 2, aRotina )
	   Else
	   		alert("Este(a) não é um(a) Pedido / NF : " + substr(oTree1:GetPrompt(),1,9)+ " Válida"  ) //+ '-> Nivel: ' + cNivel)
	   EndIf
	
	elseif oTree1:Nivel()=4 // Atendimento 
	   DbSelectArea("SUC")
	   DbSetOrder(1) 
	   If SUC->(DbSeek(xFilial("SUC")+substr(oTree1:GetPrompt(),1,6),.F.))
	      
	      nRecnoAT := SUC->(RECNO())
	      cCliente:= Substr(SUC->UC_CHAVE,1,6)
	      cLoja   := Substr(SUC->UC_CHAVE,7,2)
	      cCodCont:= SUC->UC_CODCONT
	      cEntidade:= SUC->UC_ENTIDAD
	      cDoc := SUC->UC_NFISCAL
	      cSerie:= SUC->UC_SERINF
	      cAtend:= SUC->UC_CODIGO
	      //msginfo("Visualiza Atendto: " + SUC->UC_CODIGO )
	      U_TMKC018( cEntidade, cAtend, cDoc, cSerie, .F. )  //.F. é do lAltera --> não pode alterar
	      
	   Else
	      alert("Esse não é um Atendimento "+substr(oTree1:GetPrompt(),1,6)+" Válido")
	   EndIf
	
	endif

Else //SEM NF    oTree1:Nivel()=2 //nome cli,  oTree1:Nivel()=3 //cod. atendimento
	//alert("nivel: " + oTree1:Nivel() )
	If oTree1:Nivel()= 3 // Atendimento 

		DbSelectArea("SUC")
	   	DbSetOrder(1) 
		If SUC->(DbSeek(xFilial("SUC")+substr(oTree1:GetPrompt(),1,6),.F.))
		      
		      nRecnoAT := SUC->(RECNO())
		      cCliente:= Substr(SUC->UC_CHAVE,1,6)
		      cLoja   := Substr(SUC->UC_CHAVE,7,2)
		      cCodCont:= SUC->UC_CODCONT
		      cEntidade:= SUC->UC_ENTIDAD
		      cDoc := SUC->UC_NFISCAL
		      cSerie:= SUC->UC_SERINF
		      cAtend:= SUC->UC_CODIGO
		      //msginfo("Visualiza Atendto: " + SUC->UC_CODIGO )
		      U_TMKC018( cEntidade, cAtend, cDoc, cSerie, .F. )  //.F. é do lAltera --> não pode alterar
		Endif
	Endif

Endif
Return

******************************************************************************************************
User Function SACLeg()
******************************************************************************************************

//BrwLegenda("Legenda" , "Acompamento SAC",{ {"BR_VERDE" ,	"Ocorrência em Aberto"},;
//									     { "BR_PRETO",  "Ocorrência Encerrada" } } )

BrwLegenda("Legenda" , "Acompamento SAC",{ {"FOLDER6" ,	"    NF c/ Ocorrência"} } )


Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³a410Visual³ Rev.  ³Eduardo Riera          ³ Data ³26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Visualizacao do Pedido de Venda                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do pedido de venda                ³±±
±±³          ³ExpN2: Recno do cabecalho do pedido de venda                ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a interface com o usua³±±
±±³          ³rio e o pedido de vendas                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A410Visual(cAlias,nReg,nOpc, aRotina)

Local aArea    := GetArea()
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}
//Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

Local cArqQry  := "SC6"
Local cCadastro:= OemToAnsi("Atualização de Pedidos de Venda") //"Atualiza‡„o de Pedidos de Venda"
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oDlg
Local lMt410Ace:= Existblock("MT410ACE")

Local bCond     := {|| .T. }
Local bAction1  := {|| U_Mta410VisU(cArqQry,@nTotPed,@nTotDes,lGrade) }	
Local bAction2  := {|| .T. }
Local cSeek     := ""
Local aNoFields := {"C6_NUM","C6_QTDEMP","C6_QTDENT","C6_QTDEMP2","C6_QTDENT2"}		// Campos que nao devem entrar no aHeader e aCols
Local bWhile    := {|| }
Local cQuery    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis Privates.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
PRIVATE aGEMCVnd  := {"",{},{}} //Template GEM - Condicao de Venda

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validar acesso do usuario na funcao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMt410Ace
	lContinua := Execblock("MT410ACE",.F.,.F.,{nOpc})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Ambiente/Objeto para tratamento de grade        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ        
If FindFunction("MsMatGrade") .And. IsAtNewGrd()
	//MsMatGrade():New(cObj,cProdRef,cCpo,cTudoOk,cVldCpoGrd,aSetKey,aCposCtrlGrd,lShowGrd)  	
	PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"C6_QTDVEN",,"a410GValid()",;
	  						{ 	{VK_F4,{|| A440Saldo(.T.,oGrade:aColsAux[oGrade:nPosLinO][aScan(oGrade:aHeadAux,{|x| AllTrim(x[2])=="C6_LOCAL"})])}} },;
	  						{ 	{"C6_QTDVEN",NIL,NIL},;
	  							{"C6_QTDLIB",NIL,NIL},;
	  							{"C6_QTDENT",NIL,NIL},;
	  							{"C6_ITEM"	,NIL,NIL},;
	  							{"C6_UNSVEN",NIL,NIL},;
	  							{"C6_BLQ",NIL,NIL}})
Else
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
EndIf	                   

If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf  
//Pergunte("MTA410",.F.)
//If ( lGrade )
//	aRotina[nOpc][4] := 6
//EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SC5", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtros para montagem do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)
#IFDEF TOP
	lQuery  := .T.
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
	cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
	cQuery += "SC6.D_E_L_E_T_<>'*' "
	cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

	dbSelectArea("SC6")
	dbCloseArea()
#ENDIF
cSeek  := xFilial("SC6")+SC5->C5_NUM
bWhile := {|| C6_FILIAL+C6_NUM }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader e aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,       ³
//³				  cQuery, bMountFile, lInclui )                                                                ³
//³nOpcx			- Opcao (inclusao, exclusao, etc).                                                         ³
//³cAlias		- Alias da tabela referente aos itens                                                          ³
//³nOrder		- Ordem do SINDEX                                                                              ³
//³cSeekKey		- Chave de pesquisa                                                                            ³
//³bSeekWhile	- Loop na tabela cAlias                                                                        ³
//³uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar ³
//³				  o registro)                                                                                  ³
//³aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader                         ³
//³aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader                         ³
//³lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario   ³
//³cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera     ³
//³	           parametros cSeekKey e bSeekWhiele)                                                              ³
//³bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)                     ³
//³lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco                 ³
//³aHeaderAux	-                                                                                              ³
//³aColsAux		-                                                                                              ³
//³bAfterCols	- Bloco executado apos inclusao de cada linha no aCols                                         ³
//³bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols                                     ³
//³bAfterHeader -                                                                                              ³
//³cAliasQry	- Alias para a Query                                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FillGetDados(nOPc,"SC6",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,{|| U_AfterCols(cArqQry) },/*bBeforeCols*/,/*bAfterHeader*/,"SC6")

If lQuery
	dbSelectArea("SC6")
	dbCloseArea()
	ChkFile("SC6",.F.)
EndIf


For nCntFor := 1 To Len(aHeader)
	If aHeader[nCntFor][8] == "M"
		aadd(aCpos1,aHeader[nCntFor][2])
	EndIf
Next nCntFor

nTotPed  -= M->C5_DESCONT
nTotDes  += M->C5_DESCONT
nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
If ( lQuery )
	dbSelectArea(cArqQry)
	dbCloseArea()
	ChkFile("SC6",.F.)
	dbSelectArea("SC6")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array com as formas de pagamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ma410MtFor(@aHeadFor,@aColsFor)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aCols) == 0 )
	Help(" ",1,"A410SEMREG")
	lContinua := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para visualizao do pedido de vendas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If ExistBlock("M410VIS")
//	ExecBlock("M410VIS",.F.,.F.)
//EndIf

If ( lContinua )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
		{{003,033,160,200,240,263}} )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( M->C5_TIPO $ "DB" )
		aTrocaF3 := {{"C5_CLIENTE","SA2"}}
	Else
		aTrocaF3 := {}
	EndIf
	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
	nGetLin := aPosObj[3,1]
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB","Fornec.:","Cliente: ")) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec))		SIZE 050,09 OF oDlg	PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 030,09 OF oDlg PIXEL	//"Desc. :"
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec))		SIZE 050,09 OF oDlg	PIXEL RIGHT
	@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec)) OF oDlg PIXEL RIGHT
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
		oSay2:SetText(n2),;
		oSay3:SetText(n3),;
		oSay4:SetText(n4) }
	oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,"A410FldOk",,,,,,lFreeze)	
	Ma410Rodap(oGetd,nTotPed,nTotDes)
	ACTIVATE MSDIALOG oDlg ON INIT (A410Limpa(.F.,M->C5_TIPO),U_Ma410Bar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc,oGetD))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada apos visualizao do pedido de vendas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If ExistBlock("MTA410V")
//	ExecBlock("MTA410V",.F.,.F.)
//EndIf

//aRotina := aClone(aBackRot)
RestArea(aArea)
Return( nOpcA )

*************************
User Function Mta410VisU(cArqQry,nTotPed,nTotDes,lGrade)
*************************
Local lRet      := .T.
Local nTamaCols := Len(aCols)
Local nPosItem  := GDFieldPos("C6_ITEM")
Local nPosQtd   := GDFieldPos("C6_QTDVEN")
Local nPosQtd2  := GDFieldPos("C6_UNSVEN")
Local nPosVlr   := GDFieldPos("C6_VALOR")
Local nPosSld   := GDFieldPos("C6_SLDALIB")
Local nPosDesc  := GDFieldPos("C6_VALDESC")
Local lCriaCols := .F.		// Nao permitir que a funcao A410Grade crie o aCols
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se este item foi digitada atraves de uma    ³
//³ grade, se for junta todos os itens da grade em uma   ³
//³ referencia , abrindo os itens so quando teclar enter ³
//³ na quantidade                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
	a410Grade(.F.,,cArqQry,.T.,lCriaCols)   
	If ( nTamAcols==0 .Or. aCols[nTamAcols][nPosItem] <> (cArqQry)->C6_ITEM )
		lRet := .T.	
	Else
		lRet := .F.	
		aCols[nTamAcols][nPosQtd]  += (cArqQry)->C6_QTDVEN
		aCols[nTamAcols][nPosQtd2] += (cArqQry)->C6_UNSVEN
		If ( nPosDesc > 0 )
			aCols[nTamAcols][nPosDesc] += (cArqQry)->C6_VALDESC
		Endif
		If ( nPosSld > 0 )
			aCols[nTamAcols][nPosSld] += Ma440SaLib()
		EndIf
		aCols[nTamAcols][nPosVlr] += (cArqQry)->C6_VALOR
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Somatoria do Rodape                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotPed	+= (cArqQry)->C6_VALOR
If ( (cArqQry)->C6_PRUNIT = 0 )
	nTotDes	+= (cArqQry)->C6_VALDESC
Else
	nTotDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
EndIf


Return(lRet)

**********************
User Function AfterCols(cArqQry,cTipoDat,dCopia,dOrig,lCopia)
**********************           
Local nPosProd  := GDFieldPos("C6_PRODUTO")
Local nPosGrade := GDFieldPos("C6_GRADE")
Local cMascara  := SuperGetMv("MV_MASCGRD")
Local nTamRef   := Val(Substr(cMascara,1,2))
Local nPIdentB6 := GDFieldPos("C6_IDENTB6")
Local nPEntreg  := GDFieldPos("C6_ENTREG")
Local nPPedCli  := GDFieldPos("C6_PEDCLI")
Local nAux      := 0
Local aLiberado := {}
Local cCampo    := ""

DEFAULT lCopia  := .F.
                                 
If aCols[Len(aCols)][nPosGrade] == "S"
	aCols[Len(aCols)][nPosProd] := SubStr((cArqQry)->C6_PRODUTO,1,nTamRef)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mesmo nao sendo um item digitado atraves de grade e' necessa-³
	//³ rio criar o Array referente a este item para controle da     ³
	//³ grade                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("MsMatGrade") .And. IsAtNewGrd()
		oGrade:MontaGrade(Len(aCols))
	Else
		MatGrdMont(Len(aCols))
	EndIf 
EndIf	

If Altera
	If ( SC5->C5_TIPO <> "D" )
		nAux := aScan(aLiberado,{|x| x[2] == aCols[Len(aCols)][nPIdentB6]})
		If ( nAux == 0 )
			aadd(aLiberado,{ (cArqQry)->C6_ITEM , aCols[Len(aCols)][nPIdentB6] , (cArqQry)->C6_QTDEMP, (cArqQry)->C6_QTDENT })
		Else
			aLiberado[nAux][3] += (cArqQry)->C6_QTDEMP
			aLiberado[nAux][4] += (cArqQry)->C6_QTDENT
		EndIf
	Else
		nAux := aScan(aLiberado,{|x| x[1] == (cArqQry)->C6_SERIORI .And.;
		x[2] == (cArqQry)->C6_NFORI   .And.;
		x[3] == (cArqQry)->C6_ITEMORI })
		If ( nAux == 0 )
			aadd(aLiberado,{ (cArqQry)->C6_SERIORI , (cArqQry)->C6_NFORI , (cArqQry)->C6_ITEMORI , (cArqQry)->C6_QTDEMP })
		Else
			aLiberado[nAux][4] += (cArqQry)->C6_QTDEMP
		EndIf
	EndIf
EndIf

If lCopia
	cCampo := Alltrim(aHeader[nPEntreg,2])           
	Do Case
		Case cTipoDat == "1"
			aCols[Len(aCols)][nPEntreg] := FieldGet(FieldPos(cCampo))
		Case cTipoDat == "2"
			aCols[Len(aCols)][nPEntreg] := If(FieldGet(FieldPos(cCampo)) < dCopia,dCopia,FieldGet(FieldPos(cCampo)) )
		Case cTipoDat == "3"
			aCols[Len(aCols)][nPEntreg] := dCopia + (FieldGet(FieldPos(cCampo)) - dOrig )
	EndCase

	If SubStr(aCols[Len(aCols)][nPPedCli],1,3)=="TMK"
		aCols[Len(aCols)][nPPedCli] := CriaVar(cCampo)
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estes campos nao podem ser copiados                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GDFieldPut("C6_QTDLIB"  ,CriaVar("C6_QTDLIB"  ))
	GDFieldPut("C6_RESERVA" ,CriaVar("C6_RESERVA" ))
	GDFieldPut("C6_CONTRAT" ,CriaVar("C6_CONTRAT" ))
	GDFieldPut("C6_ITEMCON" ,CriaVar("C6_ITEMCON" ))
	GDFieldPut("C6_PROJPMS" ,CriaVar("C6_PROJPMS" ))
	GDFieldPut("C6_EDTPMS"  ,CriaVar("C6_EDTPMS"  ))
	GDFieldPut("C6_TASKPMS" ,CriaVar("C6_TASKPMS" ))
	GDFieldPut("C6_LICITA"  ,CriaVar("C6_LICITA"  ))
	GDFieldPut("C6_PROJET"  ,CriaVar("C6_PROJET"  ))
	GDFieldPut("C6_ITPROJ"  ,CriaVar("C6_ITPROJ"  ))
	GDFieldPut("C6_CONTRT"  ,CriaVar("C6_CONTRT"  ))
	GDFieldPut("C6_TPCONTR" ,CriaVar("C6_TPCONTR" ))
	GDFieldPut("C6_ITCONTR" ,CriaVar("C6_ITCONTR" ))
	GDFieldPut("C6_NUMOS"   ,CriaVar("C6_NUMOS"   ))
	GDFieldPut("C6_NUMOSFAT",CriaVar("C6_NUMOSFAT"))
	GDFieldPut("C6_OP"      ,CriaVar("C6_OP"      ))
	GDFieldPut("C6_NUMOP"   ,CriaVar("C6_NUMOP"   ))
	GDFieldPut("C6_ITEMOP"  ,CriaVar("C6_ITEMOP"  ))
	GDFieldPut("C6_NUMORC"  ,CriaVar("C6_NUMORC"  ))
	GDFieldPut("C6_BLQ"     ,CriaVar("C6_BLQ"     ))
	GDFieldPut("C6_NOTA"    ,CriaVar("C6_NOTA"    ))
	GDFieldPut("C6_SERIE"   ,CriaVar("C6_SERIE"   ))
	GDFieldPut("C6_PEDCLI"  ,CriaVar("C6_PEDCLI"  ))
	
EndIf

Return(.T.) 

***************************
User Function Ma410Bar(oDlg,bOk,bCancel,nOpc,oGetD)
***************************
Local aButtons  := {}
Local aButtonUsr:= {}
Local nI        := 0
LOCAL lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"
Local nPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPOpcional:= If(lOpcPadrao,aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPC"}),aScan(aHeader,{|x| AllTrim(x[2])=="C6_MOPC"}))

If ( nOpc == 3 .Or. nOpc == 4 .Or. (nOpc == 2 .And. !AtIsRotina("A450F4CON")) )
	aadd(aButtons,{"POSCLI",{|| If(M->C5_TIPO=="N".And.!Empty(M->C5_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi‡„o de Cliente","Posi‡„o de Cliente" }) 	//"Posi‡„o de Cliente"
EndIf
aadd(aButtons,{"BUDGET",{|| Ma410ForPg(nOpc)},"Formas de Pagamento", "Formas de Pagamento" }) //"Formas de Pagamento"
aadd(aButtons,{"RELATORIO",{||Ma410Impos(aRotina[ nOpc, 4 ])},"Planilha Financeira", "Planilha Financeira" })	//"Planilha Financeira"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para verificar se o usuario pode acessar a formacao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If VerSenha(107) //Permite consulta a Formacao de Precos
	If ExistBlock("A410BPRC")
		If ExecBlock("A410BPRC",.F.,.F.)
			aadd(aButtons,{"AUTOM",{||Ma410Forma()},"Formacao de Precos","Formacao de Precos" })	//"Formacao de Precos"
		Endif
	Else
		aadd(aButtons,{"AUTOM",{||Ma410Forma()},"Formacao de Precos","Formacao de Precos" })	//"Formacao de Precos"
	Endif
EndIf

If ( aRotina[ nOpc, 4 ] == 2 .Or. aRotina[ nOpc, 4 ] == 6 ) .And. !AtIsRotina("A410TRACK")
	AAdd(aButtons,{ "BMPVISUAL", {|| A410Track() }, "System Tracker", "System Tracker" } )  // "System Tracker"
EndIf
If !( nOpc == 2 .Or. nOpc == 5 )
	Aadd(aButtons,{"PRODUTO", {|| Ma410BOM(aHeader,aCols,N) } ,"Estrutura de Produto","Estr.Prod."}) //"Estrutura de Produto"###"Estr.Prod."
EndIf
Aadd(aButtons,{"PESQUISA",{|| GdSeek(oGetD,"Pesquisar",,,.F.)},"Pesquisar","Pesquisar"}) //"Pesquisar"
If ( nOpc == 1 .Or. nOpc == 2 .Or. nOpc == 5 ) .And. nPOpcional > 0
	Aadd(aButtons,{"SDUCOUNT", {|| SeleOpc(2,,aCols[n][nPProduto],,,Ma410Opc(lOpcPadrao,nPOpcional),"M->C6_PRODUTO",.T.) } ,"Opcionais Selecionados","Opcionais"}) //"Opcionais Selecionados"###"Opcionais"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pontos de Entrada 													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("A410CONS",,.T.)
	aButtonUsr := ExecTemplate("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
If ExistBlock("A410CONS",,.T.)
	aButtonUsr := ExecBlock("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf

//
// Template GEM - Gestao de Empreendimentos Imobiliarios
//
// Adiciona botoes na enchoice
//
If ExistTemplate("GMMA410BUT",,.T.)
	aButtonUsr := ExecTemplate("GMMA410BUT",.F.,.F.,{nOpc ,M->C5_NUM ,M->C5_CLIENTE ,M->C5_LOJACLI})
	If ValType(aButtonUsr) == "A"
		For nI := 1 To Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))