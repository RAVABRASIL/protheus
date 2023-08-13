#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'PROTHEUS.CH'

/*-------------------------------------------------------------------------------------*/
//Programa: TMKC028.prw
//Autoria : Flávia Rocha
//Data    : 18/07/2011
//Objetivo: Mostrar árvore para consulta dos clientes, suas respectivas NFs 
//          e seus respectivos atendimentos gerados pela rotina SAC, 
//          bem como as ocorrências (se existirem) associadas a estes atendimentos.
/*-------------------------------------------------------------------------------------*/

**************************
User Function TMKC028(cCliente, cLoja)
***************************

Private cCadastro:= "Cadastro de Clientes" 
Private nOpc	 := 1

//If Pergunte("VIEWSAC2",.T.)
   MsAguarde( { || ViewSAC(cCliente,cLoja) }, "Aguarde. . .", "Acompanhamento do SAC . . ." )
//Endif

Return

***************************
Static Function ViewSAC(cCliente,cLoja)
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
oBtn5      := TButton():New( 038,308,"Legenda",oDlg1,{|| U_SACLeg1()},050,012,,,,.T.,,"",,,,.F. )
oBtn6      := TButton():New( 055,308,"Sair",oDlg1,{||oDlg1:End()},050,012,,,,.T.,,"",,,,.F. )
//oBtn6      := TButton():New( 055,308,"Pedidos",oDlg1,{|| Carteira(cCliente,cLoja) },050,012,,,,.T.,,"",,,,.F. )
//oBtn7      := TButton():New( 071,308,"Sair",oDlg1,{||oDlg1:End()},050,012,,,,.T.,,"",,,,.F. )  


//arvore
oTree1     := DbTree():New( 005,004,280,304,oDlg1,{ || atualiza() },,.F.,.F. )

if oTree1:Nivel() = 1
   oBtn3:Disable()
else
   oBtn3:Enable()  
endIf

TodosCli(cCliente,cLoja)

oDlg1:Activate(,,,.T.)

Return


***************************
Static Function TodosCli(cCliente,cLoja)  //(nOpc)
***************************

Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)


cQuery += "SELECT A1_COD, A1_LOJA, A1_NOME, *  " + LF
cQuery += "FROM " + RetSqlName("SA1") + " SA1 " + LF

cQuery += " WHERE  " + LF
cQuery += " SA1.D_E_L_E_T_ = '' " + LF
//cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' " + LF

cQuery += " AND SA1.A1_COD = '" + Alltrim(cCliente) +"' " + LF
cQuery += " AND SA1.A1_LOJA = '" + Alltrim(cLoja) +"' " + LF

//cQuery += " AND SA1.A1_COD >= '" + Alltrim(mv_par01) +"' " + LF
//cQuery += " AND SA1.A1_LOJA >= '" + Alltrim(mv_par02) +"' " + LF
//cQuery += " AND SA1.A1_COD <= '" + Alltrim(mv_par03)+"'  " + LF
//cQuery += " AND SA1.A1_LOJA <= '" + Alltrim(mv_par04)+"'  " + LF


//If !Empty(MV_PAR05)
//	cQuery += " AND SA1.A1_EST = '"+ Alltrim(mv_par05)+ "' " + LF
//Endif

cQuery += " ORDER BY SA1.A1_COD, SA1.A1_LOJA  " + LF 
MemoWrite("C:\Temp\CLI_TMKC028.SQL", cQuery)
If Select("AUXX") > 0
	DbSelectArea("AUXX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUXX"
DbSelectArea("AUXX")
AUXX->(DbGoTop())

if nOpc=1 // cria a arvore      
	oTree1:AddTree(Padr("Clientes",100), .T.)
	while AUXX->(!EOF())   
		 oTree1:AddTree(Padr(AUXX->A1_COD + '/'+ AUXX->A1_LOJA + " - "+AUXX->A1_NOME,150), .T.)
		 NFFis(AUXX->A1_COD,AUXX->A1_LOJA,1)     //PEGA NFs
		 
		 //oTree1:AddTree(Padr("Pedidos Carteira",100), .T.)    //se deixar, bagunça (na hora de liberar o botão visual) os níveis da árvore
		 Carteira(AUXX->A1_COD,AUXX->A1_LOJA,1)     //PEGA PEDIDO CARTEIRA		 
		 oTree1:EndTree()
		 DbSelectArea("AUXX")
	 	 AUXX->(DbSkip())
	enddo
	oTree1:EndTree()
    //AUXX->(DbCloseArea())
endif

Return

***************************
Static Function Carteira(cCliente, cLoja)
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

//cQuery += "SB1.B1_SETOR!= '39' AND "//Diferente Caixa
//cQuery += " C6_TES = F4_CODIGO "
//cQuery += " F4_DUPLIC = 'S'   AND "
/*
If !empty(par11)  	//Representante
    cQuery += "SC5.C5_VEND1 in ('"+par11+"','"+alltrim(par11) +"VD'"+") AND "

elseif !empty(par12)	//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+par12+"' OR SC5.C5_VEND1 = '"+par12+"' ) AND D_E_L_E_T_ = '' ) AND "

elseif !empty(par13)	//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+par13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
*/
cQuery += " AND SC5.C5_CLIENTE = '"+ Alltrim(cCliente) + "' " + LF
cQuery += " AND SC5.C5_LOJACLI = '"+ Alltrim(cLoja) + "' " + LF
/*
if par07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif par07 = 2 //Linha Dom
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif par07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif par07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "   
endif
if !empty(par08) .and. empty(par09)
	cQuery += "SA1.A1_EST = '"+par08+"' AND "
elseIf empty(par08) .and. !empty(par09)
	cQuery += "SA1.A1_EST != '"+par09+"' AND "
elseIf !empty(par08) .and. !empty(par09)
	cQuery += "SA1.A1_EST = '"+par08+"' AND SA1.A1_EST != '"+par09+"' AND "
endIf
*/
//if nTipo = 1
//  cQuery += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataUso ) + 1 ) + "' and "
//elseif nTipo = 2     
//  cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataUso ) ) + "' and "
//endif
//if lDia
//  cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataUso)+"' and "
//endIf


cQuery += " AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "  + LF
cQuery += " AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' " + LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' " + LF
//cQuery += "SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND SF4.D_E_L_E_T_ = ' ' 
cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ENTREG " + LF
cQuery += " ORDER BY C5_ENTREG, C5_NUM " + LF

MemoWrite("C:\Temp\Cart_TMKC028.SQL", cQuery) 
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
		oTree1:EndTree()
		
	    F2XX->(DbCloseArea())
	    //oTree1:EndTree() //do "pedidos Carteira"
	Endif
endif

Return



***************************
Static Function NFFis(cCliente, cLoja, nOpc)
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
cQuery += " AND SF2.F2_SERIE = '0' " + LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' " + LF

cQuery += " AND SF2.F2_CLIENTE = '" + Alltrim(cCliente) +"' " + LF
cQuery += " AND SF2.F2_LOJA  = '" + Alltrim(cLoja) +"' " + LF

cQuery += " ORDER BY SF2.F2_DOC  " + LF
MemoWrite("C:\Temp\NF_TMKC028.SQL", cQuery) 
If Select("F2XX") > 0
	DbSelectArea("F2XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "F2XX"
TCSetField("F2XX", "F2_EMISSAO", "D")
DbSelectArea("F2XX")
F2XX->(DbGoTop())

if nOpc=1 // cria a arvore
	If !F2XX->(EOF())
	      
		oTree1:AddTree(Padr("Notas Fiscais",100), .T.)
		while F2XX->(!EOF())
			lTem := PegAtend(F2XX->F2_DOC,F2XX->F2_SERIE, 2)     
		    If lTem
		 		oTree1:AddTree(Padr(F2XX->F2_DOC+"/" + F2XX->F2_SERIE,150), lTem, "FOLDER6")  //PASTA AMARELA ABERTA
		 	Else
		 		oTree1:AddTree(Padr(F2XX->F2_DOC + '/' + F2XX->F2_SERIE,150), .T.)
		 	Endif
		 	PegAtend(F2XX->F2_DOC,F2XX->F2_SERIE,1)     //PEGA ATENDIMENTO
		 
		 oTree1:EndTree()
		 F2XX->(DbSkip())
		end
		oTree1:EndTree()
	    F2XX->(DbCloseArea())
	Endif
endif

Return

*********************************************
Static Function PegAtend(cNF, cSerie, nOpc) 
*********************************************

Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local lTem  := .F.

cQuery += "SELECT * "+ LF
cQuery += "FROM "+ LF
cQuery += " "    +RetSqlName("SUC")+" SUC " + LF
cQuery += "WHERE  "+ LF
cQuery += " SUC.UC_NFISCAL = '" + Alltrim(cNF) + "'  "+ LF
cQuery += " AND SUC.UC_SERINF = '" + Alltrim(cSerie) + "'  "+ LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' " + LF
cQuery += "AND SUC.D_E_L_E_T_ = ''  "+ LF
MemoWrite("C:\Temp\ATED_TMKC028.SQL", cQuery)
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

	oTree1:AddTree(Padr("Atendimento",100), .T.)
	while SUCXX->(!EOF() )
	 dPrev:= SUCXX->UC_PREVCHG
	 dReal:= SUCXX->UC_REALCHG 
	 If !Empty(dReal) 
	 	oTree1:AddTree(Padr(SUCXX->UC_CODIGO + " - Prev.Cheg: " + Dtoc(dPrev) + " - Chegada: " + Dtoc(dReal),150), .T.)

	 Else
	 	oTree1:AddTree(Padr(SUCXX->UC_CODIGO + " - Prev.Cheg: " + Dtoc(dPrev),150), .T.)
	 Endif
	 Ocorr(SUCXX->UC_CODIGO,1)      //pega OCORRÊNCIA
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
cQuery+=" WHERE UD_CODIGO = '" + Alltrim(cAtend) + "' " + LF
cQuery+=" AND SUD.UD_OPERADO <> '' " + LF
cQuery+=" AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' " + LF
cQuery+=" AND SUD.D_E_L_E_T_!= '*' " + LF
cQuery+=" ORDER BY UD_ITEM  " + LF
MemoWrite("C:\Temp\OCOR_TMKC028.SQL", cQuery)
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
	SUDXX->(DbCloseArea())
 Endif
	Return
else

	If SUDXX->(!EOF() )
		lTem := .T.
	endif
	SUDXX->(DbCloseArea())
	Return(lTem)	
endif


******************************************************
Static Function Histor(cOcorr,cItem, cCliente,nOpc)  //pega histórico de respostas
******************************************************
Local cQuery:=''
Local LF	:= CHR(13) + CHR(10)
Local cLegenda := ""
Local nMax     := 0

cQuery:="SELECT UD_STATUS, * " + LF
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

cQuery+="ORDER BY ZUD.R_E_C_N_O_ , (ZUD_DTENV + ZUD_HRENV) " + LF   //AQUI PRECISA EXIBIR POR ORDEM DE INCLUSÃO DOS ENVIOS
                                                                    //EVITA QUE ENVIOS '0' (QDO O USUÁRIO RESPONDE SEM ENVIO), FIQUE 1o. QUE OS ENVIOS REGULARES
MemoWrite("C:\Temp\ZUD_TMKC028.sql", cQuery )

TCQUERY cQuery NEW ALIAS "ZUDXX"
TcSetField("ZUDXX", "ZUD_DTRESP", "D")
TcSetField("ZUDXX", "ZUD_DTSOL", "D")
TcSetField("ZUDXX", "ZUD_DTENV", "D")
TcSetField("ZUDXX", "ZUD_DTRESO", "D")

DbSelectArea("ZUDXX")
ZUDXX->(DbGoTop()) 
If ZUDXX->(!EOF() )
	while ZUDXX->(!EOF() )
		nMax := ZUDXX->ZUD_NRENV
		ZUDXX->(DBSKIP())
	enddo
Endif
  

DbSelectArea("ZUDXX")
ZUDXX->(DbGoTop()) 
if nOpc=1 // cria a arvore      
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
	 
	 If !Empty(ZUDXX->ZUD_OBSRES)
		 
		 //If ZUDXX->ZUD_RESOLV != 'S'
		 //	oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(ZUDXX->ZUD_OBSATE) ,150), "BR_BRANCO")
		 //Endif
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
	 	oTree1:AddTreeItem(PadR( "SAC: " + Alltrim(ZUDXX->ZUD_OBSATE) ,150), cLegenda)		//BRANCO É A BOLINHA DO SAC
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
endif

Return



****************************
Static Function Atualiza()
****************************

/*
Nível 1 = Clientes
Nível 2 = Cod. Cliente    ->visualiza
Nível 3 = NFs
Nível 4 = Número da Nota Fiscal -> visualiza 

Nível 3 = Pedidos em carteira
Nível 4 = Números dos Pedidos -> visualiza

Nível 5 = Atendimento
Nível 6 = Código Atendimento   ->visualiza
Nìvel 7 = Ocorrência
Nível 8 = Históricos
*/

/*
if 	oTree1:Nivel() = 1  .OR. oTree1:Nivel() = 3;
    .OR. oTree1:Nivel() = 5  .OR. oTree1:Nivel() = 7;
    .OR. oTree1:Nivel() = 9
    
    oBtn3:Disable()
else
   oBtn3:Enable()  
endIf
*/   

if 	oTree1:Nivel() = 1  .OR. oTree1:Nivel() = 3;
    .OR. oTree1:Nivel() = 5  .OR. oTree1:Nivel() = 7;
    .OR. oTree1:Nivel() = 9
    
    oBtn3:Disable()
else
   oBtn3:Enable()  
endIf

Return 


****************************
Static Function Visualiza()
****************************

Local nRecnoNF:=0
Local nRecnoAT:=0 
Local nRecnoCli:= 0
Local cDoc
Local cSerie
Local cTipo
Local cCliente
Local cLoja
Local cCodCont := ""
Local cEntidade:= ""
Local cAtend   :=""
Local cNivel   := ""
Local nRecno   := 0

/*
Nível 1 = Clientes
Nível 2 = Cod. Cliente
Nível 3 = NFs
Nível 4 = Número da Nota Fiscal
Nível 4 = Número do Pedido de Venda
Nível 5 = Atendimento
Nível 6 = Código Atendimento
Nìvel 7 = Ocorrência
Nível 8 = Históricos
*/
cNivel := Str(oTree1:Nivel())

if oTree1:Nivel()= 2 //cod. cliente 
   
   DbSelectArea("SA1")
   DbSetOrder(1)
   If SA1->(DbSeek(xFilial("SA1")+substr(oTree1:GetPrompt(),1,6) + substr(oTree1:GetPrompt(),8,2) ,.F.))
      
      cCliente:= SA1->A1_COD
      cLoja   := SA1->A1_LOJA
      nRecnoCli:= SA1->(RECNO())

      //U_VisualNF(cDoc,cSerie,cCliente,cLoja,cTipo)
      msginfo("Visualiza cliente: " + cCliente + "/" + cLoja  )
      //msginfo("Visualiza cliente: " + cCliente + "/" + cLoja + '-> Nivel: ' + cNivel )
      A030Visual("SA1",nRecnoCli,2)
   Else
     alert("Esse não é um Cliente "+substr(oTree1:GetPrompt(),1,9)+" Válido")
   EndIf

elseif oTree1:Nivel()= 4 // NF 
   DbSelectArea("SF2")
   DbSetOrder(1)
   If SF2->(DbSeek(xFilial("SF2")+substr(oTree1:GetPrompt(),1,9) + substr(oTree1:GetPrompt(),11,3) ,.F.))
      
      cDoc := SF2->F2_DOC
      cSerie:= SF2->F2_SERIE
      cCliente:= SF2->F2_CLIENTE
      cLoja   := SF2->F2_LOJA
      cTipo   := SF2->F2_TIPO
      //msginfo("Visualiza NF: " + cDoc + "/" + cSerie + '-> Nivel: ' + cNivel)
      msginfo("Visualiza NF: " + cDoc + "/" + cSerie )
      U_VisualNF(cDoc,cSerie,cCliente,cLoja,cTipo)
   
   Elseif SC5->(DbSeek(xFilial("SC5")+substr(oTree1:GetPrompt(),1,6) ,.F.))
   	  cPed := SC5->C5_NUM
   	  cCliente:= SC5->C5_CLIENTE
      cLoja   := SC5->C5_LOJACLI
      cTipo   := SC5->C5_TIPO
      nRecno  := SC5->(RECNO())
      //msginfo("Visualiza Pedido: " + cPed + '-> Nivel: ' + cNivel)
      msginfo("Visualiza Pedido: " + cPed )
   	  A410Visual("SC5",nRecno,2)		//A410Visual(cAlias,nReg,nOpc)
   Else
   		alert("Este(a) não é um(a) Pedido / NF : " + substr(oTree1:GetPrompt(),1,9)+ " Válida"  + '-> Nivel: ' + cNivel)
   EndIf

elseif oTree1:Nivel()= 6 //4 // Atendimento 
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
      //msginfo("Visualiza Atendto: " + SUC->UC_CODIGO + '-> Nivel: ' + cNivel)
      msginfo("Visualiza Atendto: " + SUC->UC_CODIGO )
      U_TMKC018( cEntidade, cAtend, cDoc, cSerie, .F. )  //.F. é do lAltera --> não pode alterar
      
   Else
      alert("Esse não é um Atendimento "+substr(oTree1:GetPrompt(),1,6)+" Válido")
   EndIf

//elseif oTree1:Nivel()= 7 
//	msginfo("Visual -> Nivel: " + cNivel)
//elseif oTree1:Nivel()= 8 
//	msginfo("Visual -> Nivel: " + cNivel)
endif

Return

******************************************************************************************************
User Function SACLeg1()
******************************************************************************************************

BrwLegenda("Legenda" , "Acompamento SAC",{ {"BR_VERDE" ,	"Ocorrência em Aberto"},;
									     { "BR_PRETO",  "Ocorrência Encerrada" } } )

Return .T.


***************************************
Static Function _Carteira1( lDia, nTipo )
***************************************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar
Local aArret := {}
Default nTipo := 0

//cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
//cCart += "" + RetSqlName( "SA1" ) + " SA1 "
cCart += "" + RetSqlName( "SA1" ) + " SA1 " //+ RetSqlName( "SF4" ) + " SF4 " "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
//cCart += "SC9.C9_NFISCAL = '' AND "
cCart += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cCart += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT, AMOSTRA
cCart += "SB1.B1_SETOR!= '39' AND "//Diferente Caixa
//cCart += " C6_TES = F4_CODIGO "
//cCart += " F4_DUPLIC = 'S'   AND "
If !empty(par11)  	//Representante
    cCart += "SC5.C5_VEND1 in ('"+par11+"','"+alltrim(par11) +"VD'"+") AND "

elseif !empty(par12)	//Coordenador
   cCart += " EXISTS( SELECT A3_SUPER "
   cCart += "          FROM "+RetSqlName("SA3")+" "
   cCart += "          WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+par12+"' OR SC5.C5_VEND1 = '"+par12+"' ) AND D_E_L_E_T_ = '' ) AND "

elseif !empty(par13)	//Gerente
   cCart += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cCart += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+par13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cCart += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif

if par07 = 1 //Linha Hospitalar
   cCart += "SB1.B1_GRUPO IN ('C') AND "
elseif par07 = 2 //Linha Dom
   cCart += "SB1.B1_GRUPO IN ('D','E') AND "
elseif par07 = 3
   cCart += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif par07 = 5
   cCart += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "   
endif
if !empty(par08) .and. empty(par09)
	cCart += "SA1.A1_EST = '"+par08+"' AND "
elseIf empty(par08) .and. !empty(par09)
	cCart += "SA1.A1_EST != '"+par09+"' AND "
elseIf !empty(par08) .and. !empty(par09)
	cCart += "SA1.A1_EST = '"+par08+"' AND SA1.A1_EST != '"+par09+"' AND "
endIf
if nTipo = 1
  cCart += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataUso ) + 1 ) + "' and "
elseif nTipo = 2     
  cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataUso ) ) + "' and "
endif
if lDia
  cCart += "SC5.C5_EMISSAO = '"+dtos(dDataUso)+"' and "
endIf
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cCart += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
//cCart += "SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND SF4.D_E_L_E_T_ = ' ' 
cCart := ChangeQuery( cCart ) 
//MemoWrite("C:\Temp\carteira.sql",cCart)
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")



CARX->( DbGoTop() )
While CARX->(!EOF())
	if lDia
	  aAdd( aArret, { CARX->CARTEIRA_KG, CARX->CARTEIRA_RS } )
	else
	  //So pego a Data do pedido mais antigo se for para carteira imediata
	  if nTipo = 2
	     dDatMax := CARX->DAT
	  endif   
	  nCartKG := CARX->CARTEIRA_KG
	  nCartRS := CARX->CARTEIRA_RS
	endIf
	CARX->(Dbskip())
Enddo

DbSelectArea("CARX")
DbCloseArea()


Return iif(lDia,aArret,)
