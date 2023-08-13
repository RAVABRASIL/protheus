#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
//#INCLUDE "shell.CH"

/*
------------------------------------------------------------------------
//Programa: TMKC014V2 - Tela de consulta de NFs x Previsão de Chegada
//Autoria : Flávia Rocha
//Data    : 11/09/2011
------------------------------------------------------------------------
*/  

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF


***************************
User Function TMKC014V2()
****************************

If ! Pergunte( "FATRNF", .T. )
   Return NIL
EndIf

nX := mv_par01
dX := mv_par02 


aESTRUT   := { { "A1_NREDUZ"	, "C", 020, 0 }, ;
               { "A1_TEL"		, "C", 020, 0 }, ;
               { "A1_MUN"		, "C", 025, 0 }, ;
               { "A1_EMAIL"		, "C", 030, 0 }, ;
               { "F2_DOC"		, "C", 015, 0 }, ;
               { "F2_EMISSAO"	, "D", 008, 0 }, ;
               { "F2_PREVCHG"	, "D", 008, 0 }, ;	
               { "F2_DTEXP"		, "D", 012, 0 }, ;
               { "F2_UFCHG"     , "D", 008, 0 }, ;
               { "F2_REALCHG"	, "D", 012, 0 }, ;
               { "F2_DTTRANS"	, "D", 012, 0 }, ;
               { "F2_DTAGCLI"	, "D", 012, 0 }, ;
               { "A4_NREDUZ"	, "C", 020, 0 }, ;     
               { "A4_CODCLIE"	, "C", 006, 0 }, ;
               { "A4_DIATRAB"	, "C", 001, 0 }, ;
               { "A4_TEL"		, "C", 020, 0 }, ;
               { "A1_CONTATO"	, "C", 020, 0 }, ;
               { "ZZ_PRZENT"	, "N", 003, 0 }, ;
               { "F2_VALBRUT"	, "N", 020, 6 }, ;
 			   { "F2_RETENC"	, "C", 001, 0 }, ;
 			   { "F2_OBS"		, "C", 140, 0 }, ;
 			   { "SZ_NATRASO"   , "N", 005, 0 }, ; 			   
               { "F2_SERIE"		, "C", 003, 0 }, ;
               { "F2_DTAGINT"	, "D", 008, 0 }, ;
               { "F2_EST"	    , "C", 002, 0 }, ;
               { "A1_SATIV1"    , "C", 030, 0 } }  		   

                     

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "SZZZ", .F., .F. )
//Index On A1_NREDUZ + A1_TEL + A1_MUN To &cARQTMP

DEFINE FONT oFont4 NAME "Courier New"     SIZE 0, 19 BOLD
DEFINE FONT oFont1 NAME "Arial"           SIZE 0, 13 BOLD
DEFINE FONT oFont2 NAME "Courier New"     SIZE 0, 14 BOLD
DEFINE FONT oFont3 NAME "Arial"           SIZE 0, 13 BOLD UNDERLINE

CriaGrid()

SZZZ->( DbCloseArea() )

Return NIL

***************

Static Function CriaGrid()

***************
local lInit := .T.
aBOTOES := {}
aAdd( aBOTOES, { 'S4WB001N', {|| MITA001() }, "DETALHES..."	} ) //NÃO PODERÁ INSERIR DADOS, SOMENTE CONSULTA
aAdd( aBOTOES, { 'S4WB004N', {|| Relato() }, "Gerar Relatorio..."		} )
aAdd( aBOTOES, { 'S4WB007N', {|| Relato2() }, "Gera Word"	} )
/// descomentado por antonio 
aAdd( aBOTOES, { 'NOTE'	   , {|| TK271CALL() }, "Chama Atendto...."	} ) //NÃO PODERÁ INSERIR DADOS, SOMENTE CONSULTA
aAdd( aBOTOES, { 'S4WB005N', {|| IMPRIME() }, "Imprimir..."			} )

/*
// mv_par01 -> Busca por:	1=Prev.Chega
							2=Data Emissao
							3=Notas Fiscais
							4=NF Em Aberto
// mv_par02 -> Da Data
// mv_par03 -> Até Data
// mv_par04 -> Da Nota
// mv_par05 -> Até Nota

*/

IF mv_par01 == 1
  VenceHJ()
  cModulo := "PREVISAO DE ENTREGA"
ELSEIF mv_par01 == 2
  LeBase()
  cModulo := "NOTA(S) EMITIDA(S)"
ELSEIF mv_par01 == 3
  BuscaNota()
  cModulo := "NOTA(S) ESPECIFICA(S)"
ELSEIF mv_par01 == 4
  EmAberto()
  cModulo := "NOTA(S) EM ABERTO"
ENDIF

@ 000,000 TO 460,795 Dialog oDLG2 Title "Consulta NFs x Entrega x Transportadora -  Dia: " + Dtoc( dDatabase ) + " - " + cModulo
DbSelectArea("SZZZ")

oBRW1 := MsSelect():New(   "SZZZ",,, ;
                        { { "A1_SATIV1" ,,  OemToAnsi( "Segmento") }, ;
                         { "A1_NREDUZ"  ,,  OemToAnsi( "Nome") }, ;
                         { "A1_TEL"     ,,  OemToAnsi( "Telefone") }, ;
                         { "A1_MUN"     ,,  OemToAnsi( "Municipio") }, ;
                         { "F2_DOC"     ,,  OemToAnsi( "Nota Fiscal") }, ;                         
                         { "F2_EMISSAO" ,,  OemToAnsi( "Emissao") }, ;
                         { "F2_DTEXP" 	,,  OemToAnsi( "Dat. Saida Real") }, ;
                         { "ZZ_PRZENT"  ,,  OemToAnsi( "Prazo de Entrega") },;
                         { "F2_PREVCHG" ,,  OemToAnsi( "Previsao Entreg.") }, ;		//{ "SZ_PREVISO" ,,  OemToAnsi( "Previsao Entreg.") }, ;
                         { "F2_UFCHG"   ,,  OemToAnsi( "Dt.Cheg.UF Destino") }, ;
                         { "F2_REALCHG" ,,  OemToAnsi( "Dt.Cheg.Real (Cliente)") }, ;
                         { "F2_DTTRANS" ,,  OemToAnsi( "Dt.Info.Transp") }, ;
                         { "F2_DTAGCLI" ,,  OemToAnsi( "Dat. Reagendamento") }, ;
                         { "A4_NREDUZ"  ,,  OemToAnsi( "Transp / *Redespacho  ") }, ;
                         { "A1_CONTATO" ,,  OemToAnsi( "Responsavel   ") }, ;
                         { "F2_RETENC"  ,,  OemToAnsi( "Merc.Retida?") }, ;		
                         { "SZ_NATRASO" ,,  OemToAnsi( "Dias Atraso" ) }, ;
                         { "F2_OBS"  	,,  OemToAnsi( "Observacoes") }, ;
                         { "F2_SERIE"  	,,  OemToAnsi( "Serie NF") } , ;  
                         { "F2_DTAGINT"	,,  OemToAnsi( "Agend.Interno") }, ;
                         { "F2_EST"	    ,,  OemToAnsi( "UF") } }, ;
						 .F.,, { 013, 000, 220, 397 } )  
                           
//COLUNAS ÍNDICE: 1 (SEGMENTO), 2 (CLIENTE) , 9 (PREV. CHEGADA), 14 (TRANSPORTADORA) , 
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick := { || MITA001() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE
/**/
oBrw1:oBrowse:bHeaderClick := {|oBrw,nCol| MbrIdxCol(nCol,oBrw)}
/**/
if lInit
	MbrIdxCol(1,oBrw1:oBrowse)
	lInit := .F.
endIf
Activate Dialog oDLG2 Centered On Init EnchoiceBar( oDlg2, { || If( oDlg2:End(), oDlg2:End(), NIL ), .F. }, { || oDlg2:End() },, aBOTOES)

Return NIL


***************

STATIC Function MITA001()

***************

// Variaveis Locais da Funcao
Local dEdit1   := ctod(Space(8))	//campo Dt. Saída (Expedição)
Local dEdit2   := ctod(Space(8))	//campo Prev. Chegada
Local cEdit3   := Space(90)			//campo Observações
Local cEdit4   := Space(25)         //String q informa o número da Nota Fiscal
Local dEdit5   := ctod(Space(8))  //campo Dt. Real Chegada
Local dEdit6   := ctod(Space(8))  //campo Reagendamento
Local dEdit7   := ctod(Space(8))  //campo Dt. Chegada na UF Destino
Local dEdit8   := ctod(Space(8))  //campo Dt. Informada pela Transp (Chegada)
Local dEdit9   := ctod(Space(8))  //campo Dt. Agendamento INTERNO

Local oSay1
Local oCBox1
Local oSay2
Local oCBox2

Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4
Local oEdit5
Local oEdit6
Local oEdit7
Local oEdit8
Local oEdit9


Local nVar
Local nVar2

Local oMemo1
// Variaveis Private da Funcao
//Private _oDlg       // Dialog Principal
//Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.



@ C(243), C(285) TO C(580),C(620) Dialog _oDlg Title "Informacoes Extras"
  // Cria Componentes Padroes do Sistema

  cEdit4 := "Nota Fiscal: " + alltrim(SZZZ->F2_DOC)
  @ C(005),C(003) Say    alltrim(cEdit4) object oEdit4     Size 125,125
  
  @ C(018),C(045) Get    dEdit1 object oEdit1 PICTURE "@D" When .F. Size 040,007  
  @ C(019),C(003) Say    "Data de Saida:" Size 040,007
  
  @ C(018),C(123) Get    dEdit2 object oEdit2 PICTURE "@!" When .F. Size 040,007  
  @ C(019),C(087) Say    "Previsao de Chegada:"   Size 045,015
  
  @ C(035),C(045) Get    dEdit7 object oEdit7 PICTURE "@!" When .F. Size 040,100
  @ C(036),C(003) Say    "Dt Chegada na UF Destino:"  Size 055,015 
  
  @ C(035),C(123) Get    dEdit5 object oEdit5 PICTURE "@!" When .F. Size 040,100 //cEdit5 e 0Edit5  para prazo  
  @ C(036),C(087) Say    "Dt Real Chegada (Cliente):"  Size 055,015   
  
  oSay1      := TSay():New( 075,003,{||"Mercadoria Retida ?"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
  oCBox1     := TComboBox():New( 074,057,{|u| If(PCount()>0,nVAR:=u,nVAR)},{ "N=Não", "S=Sim" },040,010,_oDlg,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
  oCBox1:lReadOnly := .T.  	
  
  @ C(056),C(123) Get    dEdit8 object oEdit8 PICTURE "@!" When .F. Size 040,100
  @ C(056),C(087) Say    "Info. Transp:"  Size 055,015   
  
  @ C(082),C(045) Get    dEdit6 object oEdit6 PICTURE "@D" When .F. Size 040,100 //Reagendamento é a data que o cliente escolhe para recebimento 
  @ C(083),C(003) Say    "Reagendamento Cliente:"  Size 045,015
  
  @ C(082),C(123) Get    dEdit9 object oEdit9 PICTURE "@!" When .F. Size 040,100 //cEdit5 e 0Edit5  para prazo  
  @ C(083),C(087) Say    "Agendamento Interno:"  Size 045,015  
  
  @ C(117),C(003) GET cEdit3 object oEdit3 MEMO  When .F. SIZE 170,50 
  @ C(110),C(003) Say    "Observações:"  Size 060,007 

  //@ C(160),C(040) BmpButton type 1 action ChecaEdits( cEdit3, dEdit2, dEdit5, dEdit6, oCBox1:nAT, dEdit7, dEdit8, dEdit9 ) 
										 // ( Obs   ,Dt.Prev. Cheg, Dt. Real Cheg, Dt.Reagendamento,  combo,     dt.real, dt.transp, agend. interno     )
  //@ C(160),C(040) BmpButton type 1 action close(_oDlg)
  //@ C(160),C(075) BmpButton type 2 action close(_oDlg)
  @ C(160),C(075) BmpButton type 1 action close(_oDlg)

  oEdit4:SetFont( oFont4 )

 
  
  dEdit1 := SZZZ->F2_DTEXP
  dEdit2 := SZZZ->F2_PREVCHG	
  cEdit3 := SZZZ->F2_OBS
  dEdit5 := SZZZ->F2_REALCHG
  dEdit6 := SZZZ->F2_DTAGCLI
  dEdit7 := SZZZ->F2_UFCHG
  dEdit8 := SZZZ->F2_DTTRANS
  dEdit9 := SZZZ->F2_DTAGINT
 
  nVar := iif( empty(SZZZ->F2_RETENC), 1, iif( SZZZ->F2_RETENC == "N" , 1 , 2 ) )		//1 = Não / 2 = Sim
  //nVar2:= iif( empty(SZZZ->F2_POSFIS), 1, iif( SZZZ->F2_POSFIS == "N" , 1 , 2 ) )		//1 = Não / 2 = Sim
  
  ObjectMethod( oEdit1, "Refresh()" )
  ObjectMethod( oEdit2, "Refresh()" )
  ObjectMethod( oEdit3, "Refresh()" )
  ObjectMethod( oEdit5, "Refresh()" )
  ObjectMethod( oEdit6, "Refresh()" )
  ObjectMethod( oEdit7, "Refresh()" )
  ObjectMethod( oEdit8, "Refresh()" )
  ObjectMethod( oEdit9, "Refresh()" )
  
ACTIVATE MsDIALOG _oDlg CENTERED

Return(.T.)




***************

Static Function C(nTam)

***************

Local nHRes :=  oMainWnd:nClientWidth // Resolucao horizontal do monitor
  If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
    nTam *= 0.8
  ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600
    nTam *= 1
  Else  // Resolucao 1024x768 e acima
    nTam *= 1.28
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Tratamento para tema "Flat"³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If "MP8" $ oApp:cVersion
    If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
      nTam *= 0.90
    EndIf
  EndIf

Return Int(nTam)



*****************************

Static Function LeBase()

****************************
//MV_PAR01 = 2

Local dPrevChg 		:= Ctod("  /  /    ")
Local nDiatraso		:= 0
Local cTransp		:= ""
Local cRedesp  		:= ""
Local cNomeRed 		:= ""
Local cA4Diatrab	:= ""
Local cTelTransp	:= "" 
Local nPrazo		:= 0 
Local LF := CHR(13) + CHR(10)

cQuery := " select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1," + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_VALBRUT, SF2.F2_DTEXP, SF2.F2_DTAGCLI, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG, " + LF
cQuery += " SF2.F2_RETENC,SF2.F2_OBS, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS, SF2.F2_DTTRANS, SF2.F2_DTAGINT, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL,  SA4.A4_DIATRAB, SA4.A4_CODCLIE, " + LF
cQuery += " SZZ.ZZ_PRZENT " + LF
cQuery += " from "+ RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SF2") +" SF2, "  + LF
cQuery += " " + RetSqlName("SD2") +" SD2, "  + LF
cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
cQuery += " " + RetSqlName("SZZ") + " SZZ " + LF

cQuery += " where SF2.F2_CLIENTE = SA1.A1_COD " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF                  

cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE ) " + LF 
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
cQuery += " AND D2_TES NOT IN ( '502' ) " + LF  //FR - 19/07/2011 - POR SOLICITAÇÃO DE DANIELA, VOLTAR AS NFS CONTA E ORDEM

cQuery += " and SA1.A1_CGC NOT LIKE ('28924778%') " + LF
cQuery += " and SF2.F2_EMISSAO >= '" + Dtos(mv_par02) + "' and SF2.F2_EMISSAO <= '" + Dtos(mv_par03) + "' " + LF 

cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " + LF
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF 
If mv_par06 <> 1
	cQuery += " and SF2.F2_TRANSP <> '024' " + LF //SOLICITADO POR ANDREIA SABINO EM 25/04/2011
EndIf
cQuery += " and SF2.F2_TIPO = 'N' " + LF
cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
cQuery += " and SF2.F2_SERIE != ' '   " + LF

cQuery += " and SA1.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SF2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SD2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
cQuery += " and SZZ.D_E_L_E_T_ = ' '  " + LF

cQuery += " and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + LF
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
cQuery += " and SD2.D2_FILIAL  = '" + xFilial("SD2") + "' " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4")  + "' " + LF
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'  " + LF

cQuery += " Group by SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1," + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_VALBRUT, SF2.F2_DTEXP, SF2.F2_DTAGCLI, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG , " + LF
cQuery += " SF2.F2_RETENC,SF2.F2_OBS, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG, SF2.F2_EVMAIL2, SF2.F2_POSFIS, SF2.F2_DTTRANS, SF2.F2_DTAGINT, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL,  SA4.A4_DIATRAB, SA4.A4_CODCLIE, " + LF
cQuery += " SZZ.ZZ_PRZENT " + LF
cQuery += " order by SF2.F2_EMISSAO, SF2.F2_DOC " + LF
//MemoWrite("\TempQry\LEBASE.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SFFA") > 0
	DbSelectArea("SFFA")
	DbCloseArea()	
EndIf 


TCQUERY cQuery NEW ALIAS "SFFA"

TCSetField( 'SFFA', "F2_EMISSAO", "D")
TCSetField( 'SFFA', "F2_DTEXP", "D")
TCSetField( 'SFFA', "F2_DTAGCLI", "D")
TCSetField( 'SFFA', "F2_REALCHG", "D")
TCSetField( 'SFFA', "F2_PREVCHG", "D")
TCSetField( 'SFFA', "F2_UFCHG", "D")
TCSetField( 'SFFA', "F2_DTTRANS", "D")
TCSetField( 'SFFA', "F2_DTAGINT", "D")

SZZZ->( __DbZap() )
SFFA->( DbGotop() )

dPrevchg := CtoD("  /  /    ")
Do While ! SFFA->( Eof() )  

	dPrevChg	:= Ctod("  /  /    ")
	nDiatraso	:= 0
	cTransp		:= ""
	cRedesp  	:= ""
	nPrazo		:= 0

  If !Empty( SFFA->F2_REDESP )
  	cTransp  := SFFA->F2_TRANSP
  	cRedesp  := SFFA->F2_REDESP
  	If SA4->(Dbseek(xFilial("SA4") + cRedesp ))
  		cNomeRed   := "*" + Alltrim( SA4->A4_NREDUZ )
  		cTelTransp := Alltrim( SA4->A4_TEL )
  		cA4Diatrab := Alltrim( SA4->A4_DIATRAB )
  	Endif
  
  Else
  		cTransp    := SFFA->F2_TRANSP
  		cNomeRed   := SFFA->A4_NREDUZ
  		cTelTransp := SFFA->A4_TEL
  		cA4Diatrab := SFFA->A4_DIATRAB
  Endif
    
  
  //dPrevChg := DadosAdc2( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
  nPrazo	:= fprazo( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
  //nDiatraso := iif( !Empty(SFFA->F2_REALCHG) , (SFFA->F2_REALCHG - dPrevChg) , 0 )
  If !Empty( SFFA->F2_REALCHG ) .AND. !Empty( SFFA->F2_PREVCHG )
  	nDiatraso := SFFA->F2_REALCHG - SFFA->F2_PREVCHG
  Else
  	nDiatraso := 0
  Endif

  DbSelectArea("SZZZ")
  SZZZ->( DbAppend() ) 
    
  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL  
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_SERIE   := SFFA->F2_SERIE
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->F2_PREVCHG := SFFA->F2_PREVCHG 		//dPrevChg
  SZZZ->F2_DTEXP   := SFFA->F2_DTEXP		//DadosAdc(SFFA->F2_DOC, 1)
  SZZZ->SZ_NATRASO := nDiatraso				//MUDOU PARA QTDE DE DIAS DE ATRASO AO INVÉS DA DATA DE ATRASO SZZZ->UC_DATRASO := SFFA->UC_DATRASO
  SZZZ->F2_UFCHG   := SFFA->F2_UFCHG		//Dt. chegada na UF Destino
  SZZZ->F2_REALCHG := SFFA->F2_REALCHG		//DadosAdc(SFFA->F2_DOC, 2)
  SZZZ->F2_DTAGCLI := SFFA->F2_DTAGCLI
  SZZZ->F2_RETENC  := SFFA->F2_RETENC		//DadosAdc(SFFA->F2_DOC, 6)  
  SZZZ->A4_NREDUZ  := cNomeRed 				//SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := cA4Diatrab			//SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := cTelTransp			//SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := nPrazo //SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALBRUT
  SZZZ->F2_OBS     := SFFA->F2_OBS		//MSMM(SFFA->UC_CODOBS)		//DadosAdc(SFFA->F2_DOC, 4)
  //SZZZ->F2_POSFIS  := SFFA->F2_POSFIS
  SZZZ->F2_DTTRANS := SFFA->F2_DTTRANS
  SZZZ->F2_DTAGINT := SFFA->F2_DTAGINT
  SZZZ->F2_EST	   := SFFA->F2_EST
  
  SX5->(Dbsetorder(1))
  SX5->(Dbseek(xFilial("SX5") + "T3"+ SFFA->A1_SATIV1))                                                                                               
  SZZZ->A1_SATIV1  := SX5->X5_DESCRI
  
  SFFA->( DBSkip() )
EndDo


SFFA->( DBCloseArea() )

Return NIL


***************

Static Function VenceHj()

***************
//MV_PAR01 = 1

Local dPrevChg := Ctod("  /  /    ")
Local nDiatraso:= 0 
Local cTransp		:= ""
Local cRedesp  		:= ""
Local cNomeRed 		:= ""
Local cA4Diatrab	:= ""
Local cTelTransp	:= ""
Local nPrazo		:= 0  
Local LF			:= CHR(13) + CHR(10)

cQuery := " Select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG, SF2.F2_DTAGCLI, SF2.F2_RETENC, " + LF
cQuery += " SF2.F2_REDESP, SF2.F2_OBS,SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS, SF2.F2_DTTRANS, SF2.F2_DTAGINT, " + LF
cQuery += " SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_CLIENTE,SE1.E1_LOJA, SE1.E1_BAIXA, SE1.E1_SALDO, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE " + LF
cQuery += " from "+ RetSqlName("SA1") + " SA1, "  + LF

cQuery += " "+ RetSqlName("SF2") +" SF2, "  + LF
cQuery += " "+ RetSqlName("SD2") +" SD2, "  + LF
cQuery += " "+ RetSqlName("SA4") + " SA4, " + LF
cQuery += " "+ RetSqlName("SZZ") + " SZZ, " + LF
cQuery += " "+ RetSqlName("SE1") + " SE1 " + LF

cQuery += " where SF2.F2_CLIENTE = SA1.A1_COD " + LF
cQuery += " and SA1.A1_CGC NOT LIKE ('28924778%') " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF

cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE ) " + LF
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
cQuery += " AND D2_TES NOT IN ( '502' ) " + LF  //FR - 19/07/2011 - POR SOLICITAÇÃO DE DANIELA, VOLTAR AS NFS CONTA E ORDEM

cQuery += " and SF2.F2_CLIENTE = SE1.E1_CLIENTE " + LF
cQuery += " and SF2.F2_LOJA = SE1.E1_LOJA " + LF
cQuery += " and SF2.F2_SERIE = SE1.E1_PREFIXO " + LF
cQuery += " and SF2.F2_DOC = SE1.E1_NUM " + LF
cQuery += " and SE1.E1_VENCREA >= '" + Dtos( dDatabase ) + "' and SE1.E1_VENCREA <= '" + Dtos( dDatabase ) + "' " + LF
cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " + LF
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF
If mv_par06 <> 1
	cQuery += " and SF2.F2_TRANSP <> '024' " + LF //SOLICITADO POR ANDREIA SABINO EM 25/04/2011
EndIf
cQuery += " and SF2.F2_TIPO = 'N' " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF
cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
cQuery += " and SF2.F2_SERIE != ' '   " + LF

cQuery += " and SA1.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SF2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SD2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
cQuery += " and SZZ.D_E_L_E_T_ = ' '  " + LF

cQuery += " and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + LF
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
cQuery += " and SD2.D2_FILIAL  = '" + xFilial("SD2") + "' " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4")  + "' " + LF
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'  " + LF
cQuery += " Group by SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG, SF2.F2_DTAGCLI, SF2.F2_RETENC, " + LF
cQuery += " SF2.F2_REDESP, SF2.F2_OBS, SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG,SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS, SF2.F2_DTTRANS, SF2.F2_DTAGINT, " + LF
cQuery += " SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_CLIENTE,SE1.E1_LOJA, SE1.E1_BAIXA, SE1.E1_SALDO, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE " + LF
cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC " + LF
//MemoWrite("\TempQry\VENCEHJ.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SFFA") > 0
	DbSelectArea("SFFA")
	DbCloseArea()	
EndIf 


TCQUERY cQuery NEW ALIAS "SFFA"

TCSetField( 'SFFA', "F2_EMISSAO", "D")
TCSetField( 'SFFA', "F2_DTEXP", "D")
TCSetField( 'SFFA', "F2_REALCHG", "D")
TCSetField( 'SFFA', "F2_DTAGCLI", "D")
TCSetField( 'SFFA', "F2_PREVCHG", "D")
TCSetField( 'SFFA', "F2_UFCHG", "D")
TCSetField( 'SFFA', "F2_DTTRANS", "D")
TCSetField( 'SFFA', "F2_DTAGINT", "D")


  SZZZ->( __DbZap() )
  SFFA->( DbGotop() )

Do While ! SFFA->( Eof() )

	dPrevChg	:= Ctod("  /  /    ")
	nDiatraso	:= 0
	cTransp		:= ""
	cRedesp  	:= ""
	nPrazo		:= 0  
    If !Empty( SFFA->F2_REDESP )
    	cTransp  := SFFA->F2_TRANSP
	  	cRedesp  := SFFA->F2_REDESP
	  	If SA4->(Dbseek(xFilial("SA4") + cRedesp ))
	  		cNomeRed   := "*" + Alltrim( SA4->A4_NREDUZ )
	  		cTelTransp := Alltrim( SA4->A4_TEL )
	  		cA4Diatrab := Alltrim( SA4->A4_DIATRAB )
	  	Endif
  
  	Else
  		cTransp    := SFFA->F2_TRANSP
  		cNomeRed   := SFFA->A4_NREDUZ
  		cTelTransp := SFFA->A4_TEL
  		cA4Diatrab := SFFA->A4_DIATRAB
  	Endif
    
  
  //dPrevChg := DadosAdc2( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
  nPrazo   := fprazo( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
    
  DbSelectArea("SZZZ")
  SZZZ->( DbAppend() ) 
  
  //nDiatraso := iif( !Empty(SFFA->F2_REALCHG) , (SFFA->F2_REALCHG - dPrevChg) , 0 )
  If !Empty( SFFA->F2_REALCHG ) .AND. !Empty( SFFA->F2_PREVCHG )
  	nDiatraso := SFFA->F2_REALCHG - SFFA->F2_PREVCHG
  Else
  	nDiatraso := 0
  Endif
  
  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL  
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_SERIE   := SFFA->F2_SERIE
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->F2_PREVCHG := SFFA->F2_PREVCHG		//dPrevChg				//DadosAdc(SFFA->F2_DOC, 3)//30/10/06 dTemp
  SZZZ->F2_DTEXP   := SFFA->F2_DTEXP		//DadosAdc(SFFA->F2_DOC, 1)
  SZZZ->SZ_NATRASO:= nDiatraso				//MUDOU PARA QTDE DE DIAS DE ATRASO AO INVÉS DA DATA DE ATRASO SZZZ->UC_DATRASO := SFFA->UC_DATRASO
  SZZZ->F2_UFCHG   := SFFA->F2_UFCHG		//Dt. chegada na UF Destino
  SZZZ->F2_REALCHG := SFFA->F2_REALCHG		//DadosAdc(SFFA->F2_DOC, 2)
  SZZZ->F2_DTAGCLI := SFFA->F2_DTAGCLI
  SZZZ->F2_RETENC  := SFFA->F2_RETENC		//DadosAdc(SFFA->F2_DOC, 6)  
  SZZZ->A4_NREDUZ  := cNomeRed				//SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := cA4Diatrab			//SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := cTelTransp			//SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := nPrazo //SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALBRUT
  SZZZ->F2_OBS     := SFFA->F2_OBS //MSMM(SFFA->UC_CODOBS)		//DadosAdc(SFFA->F2_DOC, 4) 
  //SZZZ->F2_POSFIS := SFFA->F2_POSFIS
  SZZZ->F2_DTTRANS := SFFA->F2_DTTRANS
  SZZZ->F2_DTAGINT := SFFA->F2_DTAGINT
  SZZZ->F2_EST	   := SFFA->F2_EST
  
  SX5->(Dbsetorder(1))
  SX5->(Dbseek(xFilial("SX5") + "T3"+ SFFA->A1_SATIV1))                                                                                               
  SZZZ->A1_SATIV1  := SX5->X5_DESCRI
  

    SFFA->( DBSkip() )

EndDo

  SFFA->( DBCloseArea() )

Return NIL



*******************************

Static Function BuscaNota()

*******************************
//MV_PAR01 = 3
Local dPrevChg 	:= Ctod("  /  /    ")
Local nDiatraso := 0 
Local cTransp		:= ""
Local cRedesp  		:= ""
Local cNomeRed 		:= ""
Local cA4Diatrab	:= ""
Local cTelTransp	:= ""
Local nPrazo		:= 0
Local LF			:= CHR(13) + CHR(10)

Local cNota1 	:= mv_par04

IF mv_par05 == "      "
  cNota2 := mv_par04
ELSE
  cNota2 := mv_par05
ENDIF


cQuery := " SELECT SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG , SF2.F2_DTAGCLI, SF2.F2_DTAGINT, " + LF
cQuery += " SF2.F2_REDESP, SF2.F2_RETENC, SF2.F2_OBS, SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS, SF2.F2_DTTRANS," + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL,  SA4.A4_DIATRAB, SA4.A4_CODCLIE, SZZ.ZZ_PRZENT " + LF
cQuery += " from "+ RetSqlName("SA1") + " SA1, "  + LF
cQuery += " "+ RetSqlName("SF2") +" SF2, "  + LF
cQuery += " "+ RetSqlName("SD2") +" SD2, "  + LF
cQuery += " "+ RetSqlName("SA4") + " SA4, " + LF
cQuery += " "+ RetSqlName("SZZ") + " SZZ "   + LF

cQuery += " where SF2.F2_CLIENTE = SA1.A1_COD " + LF
//cQuery += " and SA1.A1_CGC NOT LIKE ('41150160%') " + LF

cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE ) " + LF
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
//cQuery += " AND D2_TES NOT IN ( '502' ) " + LF  //FR - 19/07/2011 - POR SOLICITAÇÃO DE DANIELA, VOLTAR AS NFS CONTA E ORDEM

cQuery += " and SF2.F2_DOC >= '" + cNota1 + "' and SF2.F2_DOC <= '" + cNota2 + "' " + LF
cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " + LF
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF
If mv_par06 <> 1
	cQuery += " and SF2.F2_TRANSP <> '024' " + LF //SOLICITADO POR ANDREIA SABINO EM 25/04/2011
EndIf
//cQuery += " and SF2.F2_TIPO = 'N' " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF
cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
cQuery += " and SF2.F2_SERIE != ' '   " + LF
cQuery += " and SA1.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SF2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SD2.D_E_L_E_T_ = ' '  " + LF
cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
cQuery += " and SZZ.D_E_L_E_T_ = ' '  " + LF 

cQuery += " and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + LF
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
cQuery += " and SD2.D2_FILIAL  = '" + xFilial("SD2") + "' " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4")  + "' " + LF
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'  " + LF

cQuery += " Group by SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_REALCHG , SF2.F2_DTAGCLI, SF2.F2_DTAGINT, " + LF
cQuery += " SF2.F2_REDESP, SF2.F2_RETENC, SF2.F2_OBS, SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG,SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS,SF2.F2_DTTRANS, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL,  SA4.A4_DIATRAB, SA4.A4_CODCLIE, SZZ.ZZ_PRZENT " + LF

cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC " + LF
MemoWrite("c:\Temp\buscanf.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SFFA") > 0
	DbSelectArea("SFFA")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SFFA"

TCSetField( 'SFFA', "F2_EMISSAO", "D")
TCSetField( 'SFFA', "F2_DTEXP", "D")
TCSetField( 'SFFA', "F2_REALCHG", "D")
TCSetField( 'SFFA', "F2_DTAGCLI", "D")
TCSetField( 'SFFA', "F2_PREVCHG", "D")
TCSetField( 'SFFA', "F2_UFCHG", "D")
TCSetField( 'SFFA', "F2_DTTRANS", "D")
TCSetField( 'SFFA', "F2_DTAGINT", "D")

SZZZ->( __DbZap() )
SFFA->( DbGotop() )

Do While ! SFFA->( Eof() )

	dPrevChg	:= Ctod("  /  /    ")
	nDiatraso	:= 0
	cTransp		:= ""
	cRedesp  	:= ""
	nPrazo		:= 0

	If !Empty( SFFA->F2_REDESP )
    	cTransp  := SFFA->F2_TRANSP
	  	cRedesp  := SFFA->F2_REDESP
	  	If SA4->(Dbseek(xFilial("SA4") + cRedesp ))
	  		cNomeRed   := "*" + Alltrim( SA4->A4_NREDUZ )
	  		cTelTransp := Alltrim( SA4->A4_TEL )
	  		cA4Diatrab := Alltrim( SA4->A4_DIATRAB )
	  	Endif
  
  	Else
  		cTransp    := SFFA->F2_TRANSP
  		cNomeRed   := SFFA->A4_NREDUZ
  		cTelTransp := SFFA->A4_TEL
  		cA4Diatrab := SFFA->A4_DIATRAB
  	Endif
    
  
  	//dPrevChg := DadosAdc2( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
    nPrazo	 := fprazo( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  
  
  DbSelectArea("SZZZ")
  SZZZ->( DbAppend() ) 
  
  //nDiatraso := iif( !Empty(SFFA->F2_REALCHG) , (SFFA->F2_REALCHG - dPrevChg) , 0 )
  If !Empty( SFFA->F2_REALCHG ) .AND. !Empty( SFFA->F2_PREVCHG )
  	nDiatraso := SFFA->F2_REALCHG - SFFA->F2_PREVCHG
  Else
  	nDiatraso := 0
  Endif
  
  If nDiatraso < 0
  	nDiatraso := 0  
  Endif
  
  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL  
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_SERIE   := SFFA->F2_SERIE
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->F2_PREVCHG := SFFA->F2_PREVCHG		//dPrevChg			
  SZZZ->F2_DTEXP   := SFFA->F2_DTEXP	
  SZZZ->SZ_NATRASO:= nDiatraso				//MUDOU PARA QTDE DE DIAS DE ATRASO AO INVÉS DA DATA DE ATRASO SZZZ->UC_DATRASO := SFFA->UC_DATRASO
  SZZZ->F2_UFCHG   := SFFA->F2_UFCHG		//Dt. chegada na UF Destino
  SZZZ->F2_REALCHG := SFFA->F2_REALCHG	
  SZZZ->F2_DTAGCLI := SFFA->F2_DTAGCLI
  SZZZ->F2_RETENC  := SFFA->F2_RETENC	
  SZZZ->A4_NREDUZ  := cNomeRed				//SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := cA4Diatrab			//SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := cTelTransp			//SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := nPrazo //SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALBRUT
  SZZZ->F2_OBS     := SFFA->F2_OBS 	//MSMM(SFFA->UC_CODOBS)
  //SZZZ->F2_POSFIS  := SFFA->F2_POSFIS
  SZZZ->F2_DTTRANS := SFFA->F2_DTTRANS
  SZZZ->F2_DTAGINT := SFFA->F2_DTAGINT
  SZZZ->F2_EST	   := SFFA->F2_EST
  
  SX5->(Dbsetorder(1))
  SX5->(Dbseek(xFilial("SX5") + "T3"+ SFFA->A1_SATIV1))                                                                                               
  SZZZ->A1_SATIV1  := SX5->X5_DESCRI

  SFFA->( DBSkip() )

EndDo

SFFA->( DBCloseArea() )

Return NIL

  

*******************************

Static Function  EmAberto( )

*******************************
//MV_PAR01 = 4
Local dPrevChg 	:= Ctod("  /  /    ")
Local nDiatraso := 0
Local cTransp		:= ""
Local cRedesp  		:= ""
Local cNomeRed 		:= ""
Local cA4Diatrab	:= ""
Local cTelTransp	:= ""
Local nPrazo		:= 0  
Local LF			:= CHR(13) + CHR(10)

cQuery := " Select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_DTAGINT, " + LF
cQuery += " SF2.F2_REALCHG, SF2.F2_DTAGCLI, SF2.F2_RETENC, SF2.F2_OBS, SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG, SF2.F2_EVMAIL2,SF2.F2_POSFIS,SF2.F2_DTTRANS, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL, SA4.A4_DIATRAB, SA4.A4_CODCLIE, SZZ.ZZ_PRZENT " + LF
cQuery += " from "+ RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SF2") +" SF2, "  + LF
cQuery += " " + RetSqlName("SD2") +" SD2, "  + LF
cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
cQuery += " " + RetSqlName("SZZ") + " SZZ " + LF
cQuery += " where SF2.F2_CLIENTE = SA1.A1_COD " + LF

//DANIELA solicitou este filtro para aparecer somente as nfs com emissão após a dt. que começou a usar este programa
cQuery += " and SF2.F2_EMISSAO >= '20091208' " + LF
cQuery += " and SA1.A1_CGC NOT LIKE ('28924778%') " + LF  

cQuery += " AND (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE ) " + LF
//cQuery += " AND D2_TES NOT IN ('535', '502' ) " + LF  //FR - 18/04/2011 - POR SOLICITAÇÃO DO CHAMADO 002085 - DANIELA
cQuery += " AND D2_TES NOT IN ( '502' ) " + LF  //FR - 19/07/2011 - POR SOLICITAÇÃO DE DANIELA, VOLTAR AS NFS CONTA E ORDEM

cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " + LF
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " + LF
If mv_par06 <> 1
	cQuery += " and SF2.F2_TRANSP <> '024' " + LF //SOLICITADO POR ANDREIA SABINO EM 25/04/2011
EndIf
cQuery += " and SF2.F2_TIPO = 'N' " + LF
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " + LF
cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " + LF
cQuery += " and SF2.F2_SERIE != ' '  " + LF
cQuery += " and SF2.F2_REALCHG = ''  "	 + LF	//é o F2_REALCHG Q traz na tela

cQuery += " and SA1.D_E_L_E_T_ = ''  " + LF
cQuery += " and SF2.D_E_L_E_T_ = ''  " + LF
cQuery += " and SD2.D_E_L_E_T_ = ''  " + LF
cQuery += " and SA4.D_E_L_E_T_ = ''  " + LF
cQuery += " and SZZ.D_E_L_E_T_ = ''  " + LF

cQuery += " and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + LF
cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + LF
cQuery += " and SD2.D2_FILIAL  = '" + xFilial("SD2") + "' " + LF
cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4")  + "' " + LF
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'  " + LF
cQuery += " Group by SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SA1.A1_EMAIL, SA1.A1_CONTATO, SF2.F2_EST, SA1.A1_SATIV1, " + LF
cQuery += " SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SF2.F2_REDESP, SF2.F2_DTAGINT, " + LF
cQuery += " SF2.F2_REALCHG, SF2.F2_DTAGCLI, SF2.F2_RETENC, SF2.F2_OBS, SF2.F2_VALBRUT, SF2.F2_LOCALIZ, SF2.F2_PREVCHG, SF2.F2_UFCHG,SF2.F2_EVMAIL2,SF2.F2_POSFIS,SF2.F2_DTTRANS, " + LF
cQuery += " SA4.A4_NREDUZ, SA4.A4_TEL, SA4.A4_DIATRAB, SA4.A4_CODCLIE, SZZ.ZZ_PRZENT " + LF

cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC " + LF
//MemoWrite("\TempQry\EmAberto.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SFFA") > 0
	DbSelectArea("SFFA")
	DbCloseArea()	
EndIf 



TCQUERY cQuery NEW ALIAS "SFFA"
TCSetField( 'SFFA', "F2_EMISSAO", "D")
TCSetField( 'SFFA', "F2_DTEXP", "D")
TCSetField( 'SFFA', "F2_DTAGCLI", "D")
TCSetField( 'SFFA', "F2_REALCHG", "D")
TCSetField( 'SFFA', "F2_PREVCHG", "D")
TCSetField( 'SFFA', "F2_UFCHG", "D")
TCSetField( 'SFFA', "F2_DTTRANS", "D")
TCSetField( 'SFFA', "F2_DTAGINT", "D")

  SZZZ->( __DbZap() )
  SFFA->( DbGotop() )

Do While ! SFFA->( Eof() )
	
	dPrevChg	:= Ctod("  /  /    ")
	nDiatraso	:= 0
	cTransp		:= ""
	cRedesp  	:= ""
	nPrazo		:= 0

	If !Empty( SFFA->F2_REDESP )
    	cTransp  := SFFA->F2_TRANSP
	  	cRedesp  := SFFA->F2_REDESP
	  	If SA4->(Dbseek(xFilial("SA4") + cRedesp ))
	  		cNomeRed   := "*" + Alltrim( SA4->A4_NREDUZ )
	  		cTelTransp := Alltrim( SA4->A4_TEL )
	  		cA4Diatrab := Alltrim( SA4->A4_DIATRAB )
	  	Endif
  
  	Else
  		cTransp    := SFFA->F2_TRANSP
  		cNomeRed   := SFFA->A4_NREDUZ
  		cTelTransp := SFFA->A4_TEL
  		cA4Diatrab := SFFA->A4_DIATRAB
  	Endif
    
    //If !Empty( SFFA->F2_DTEXP )
	//    dPrevChg := DadosAdc2( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )
  	//Endif
  	
  	nPrazo := fprazo( SFFA->F2_DOC, SFFA->F2_SERIE, cTransp, cRedesp, SFFA->F2_LOCALIZ )  

 DbSelectArea("SZZZ")  	
 SZZZ->( DbAppend() )
 
  //nDiatraso := iif( !Empty(SFFA->F2_REALCHG) , (SFFA->F2_REALCHG - dPrevChg) , 0 )
  
  If !Empty( SFFA->F2_REALCHG ) .AND. !Empty( SFFA->F2_PREVCHG )
  	nDiatraso := SFFA->F2_REALCHG - SFFA->F2_PREVCHG
  Else
  	nDiatraso := 0
  Endif
  	
  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL  
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_SERIE   := SFFA->F2_SERIE
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->F2_PREVCHG := SFFA->F2_PREVCHG		//dPrevChg			
  SZZZ->F2_DTEXP   := SFFA->F2_DTEXP	
  SZZZ->SZ_NATRASO:= nDiatraso				//MUDOU PARA QTDE DE DIAS DE ATRASO AO INVÉS DA DATA DE ATRASO SZZZ->UC_DATRASO := SFFA->UC_DATRASO
  SZZZ->F2_UFCHG   := SFFA->F2_UFCHG		//Dt. chegada na UF Destino
  SZZZ->F2_REALCHG := SFFA->F2_REALCHG	
  SZZZ->F2_DTAGCLI := SFFA->F2_DTAGCLI
  SZZZ->F2_RETENC  := SFFA->F2_RETENC	
  SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := nPrazo //SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALBRUT
  SZZZ->F2_OBS     := SFFA->F2_OBS //MSMM(SFFA->UC_CODOBS)
  //SZZZ->F2_POSFIS  := SFFA->F2_POSFIS
  SZZZ->F2_DTTRANS := SFFA->F2_DTTRANS
  SZZZ->F2_DTAGINT := SFFA->F2_DTAGINT
  SZZZ->F2_EST	   := SFFA->F2_EST
  
  SX5->(Dbsetorder(1))
  SX5->(Dbseek(xFilial("SX5") + "T3"+ SFFA->A1_SATIV1))                                                                                               
  SZZZ->A1_SATIV1  := SX5->X5_DESCRI

 
  SFFA->( DBSkip() )

EndDo

SFFA->( DBCloseArea() )

Return NIL
 



***************************************************

Static Function DadosAdc2( cNF, cSerie, cTransp, cRedesp, cLocaliz )

***************************************************

Local dPrev 	:= CtoD("  /  /    ")
Local lTemSZZ 	:= .F. 
Local cDiatrab	:= ""
Local nZZprazo  := 0

If !Empty( cRedesp)
   	DbselectArea("SZZ")
   	Dbsetorder(1)
   	If SZZ->(Dbseek(xFilial("SZZ") + cRedesp + cLocaliz ))
   		lTemSZZ := .T.	
   	Endif
Endif

If Empty( cRedesp )
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_TRANSP = SA4.A4_COD "
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_TRANSP = '" + cTransp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"
Else
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_REDESP = SA4.A4_COD "
	cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_REDESP = '" + cRedesp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"

Endif
//MemoWrite("\TempQry\Dadosadc2.SQL",cQuery)
cQuery := ChangeQuery( cQuery )
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2A"
TCSetField( 'SF2A', "F2_EMISSAO", "D")
TCSetField( 'SF2A', "F2_DTEXP", "D")

SF2A->( DbGotop() )

dPrev := CtoD("  /  /    ")
cA4Diatrab := ""

Do While ! SF2A->( Eof() )

	If !Empty( SF2A->F2_DTEXP )    
		If !Empty( cRedesp )
		
			cLocahum		:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
	     	cTransphum		:= "47    "		//Irá pegar o prazo da ALD para o redespacho para Recife
	     	DbselectArea("SA4")
	     	Dbsetorder(1)
	     	SA4->(Dbseek(xFilial("SA4") + cTransphum ))
	     	cDiatrab := SA4->A4_DIATRAB
	     	
	     	DbselectArea("SZZ")
	     	SZZ->(Dbsetorder(1))
	       	SZZ->(Dbseek(xFilial("SZZ") + cTransphum + cLocahum ))       		
	       		nZZprazo := SZZ->ZZ_PRZENT + SF2A->ZZ_PRZENT
	       		dPrev := U_CalPrv( SF2A->F2_DTEXP, cDiatrab, nZZprazo )       	
		
		Else
				dPrev := U_CalPrv( SF2A->F2_DTEXP, SF2A->A4_DIATRAB, SF2A->ZZ_PRZENT )
		Endif
	
	Else	
		dPrev := CtoD("  /  /    ")		
	Endif
	SF2A->(DBSKIP())
Enddo

DbselectArea("SF2A")
DbcloseArea()

Return( dPrev ) 


***************************************************

Static Function fprazo( cNF, cSerie, cTransp, cRedesp, cLocaliz )

***************************************************

Local nDias 	:= 0
Local lTemSZZ 	:= .F. 
Local cLocahum	:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
Local cTransphum:= "47    "     //e transp. ALD

If !Empty( cRedesp)
   	DbselectArea("SZZ")
   	Dbsetorder(1)
   	If SZZ->(Dbseek(xFilial("SZZ") + cRedesp + cLocaliz ))
   		lTemSZZ := .T.	
   	Endif
Endif

If !lTemSZZ
//If Empty( cRedesp )
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_TRANSP = SA4.A4_COD "
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_TRANSP = '" + cTransp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"
Else
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_REDESP = SA4.A4_COD "
	cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_REDESP = '" + cRedesp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SF2.F2_TRANSP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " order by SF2.F2_DOC, SF2.F2_SERIE"

Endif
//MemoWrite("\TempQry\fprazo.SQL",cQuery)
cQuery := ChangeQuery( cQuery )
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2A"
TCSetField( 'SF2A', "F2_EMISSAO", "D")
TCSetField( 'SF2A', "F2_DTEXP", "D")

SF2A->( DbGotop() )

Do While ! SF2A->( Eof() )
	If lTemSZZ
	
		cLocahum		:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
     	cTransphum		:= "47    "		//Irá pegar o prazo da ALD para o redespacho para Recife
     	DbselectArea("SZZ")
     	SZZ->(Dbsetorder(1))
       	If SZZ->(Dbseek(xFilial("SZZ") + cTransphum + cLocahum ))
       		nDias := SZZ->ZZ_PRZENT       	
       	Endif
	
	Endif
    
	nDias := nDias + SF2A->ZZ_PRZENT
	SF2A->(DBSKIP())
Enddo

DbselectArea("SF2A")
DbcloseArea()

Return( nDias )





/*
***************

Static Function  ApagReg(cNotaf, lFecha)

***************

  
  local cQuery := "select * from "+retSqlName('SE2')+" where E2_FILIAL = '"+xFilial('SE2')+"' and  "
  		  //cQuery += "E2_NUM = '"+alltrim(cNotaf)+"' and E2_PREFIXO = 'UNI' and E2_TIPO = 'NDF' and E2_NATUREZ = '21005' "
  		  cQuery += "E2_NUM = '"+alltrim(cNotaf)+"' and E2_PREFIXO IN( 'UNI','0' ) and E2_TIPO = 'NDF' and E2_NATUREZ = '21005' " 
  		  cQuery += "and E2_CODORCA = 'POSVENDA' and D_E_L_E_T_ != '*' "
  TCQUERY cQuery NEW ALIAS 'TMPYP'
  TMPYP->( dbGoTop() )
  if !TMPYP->( EoF() )
     msgAlert("Esse registro não pode ser alterado, pois há um débito para o mesmo. " + alltrim(cNotaf) )     
     If(lFecha == .T.)
    	 close(_oDlg)
     EndIf
     TMPYP->( dbCloseArea() )
     Return
  endIf
  
  cChar := "        "
  DBSelectArea("Z04")
  Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
  Z04->( RecLock("Z04", .F.) )
  Z04->( DbDelete() )
  /*Z04->Z04_DATSAI := stod(cChar)
  Z04->Z04_DATCHE := stod(cChar)
  Z04->Z04_PRAZO  := stod(cChar)
  Z04->Z04_OBS := "  "          */
  /*
  Z04->( MsUnlock() )

  SZZZ->Z04_DATSAI := stod(cChar)
  SZZZ->Z04_DATCHE := stod(cChar)
  SZZZ->SZ_PREVISO := stod(cChar)
  SZZZ->Z04_PROROG := stod(cChar)
  SZZZ->Z04_OBSVR  := "  "
  SZZZ->Z04_RETENC := ""
  
  If(lFecha == .T.)
    close(_oDlg)
  EndIf

  TMPYP->( dbCloseArea() )
Return Nil
*/
  

***************

Static Function Relato2()

***************


   aSTRUT  := {}
   aadd( aSTRUT, { "CHAVE"  , "C",  01 , 0 } )
   aadd( aSTRUT, { "CLIENTE", "C",  25 , 0 } )
   aadd( aSTRUT, { "NUM"    , "C",  13 , 0 } )
   aadd( aSTRUT, { "DATAE"  , "C",  23 , 0 } )
   aadd( aSTRUT, { "DATAENT", "C",  23 , 0 } )
   aadd( aSTRUT, { "DATAHJ" , "C",  23 , 0 } )
   aadd( aSTRUT, { "DATSAI" , "C",  23 , 0 } )
   aadd( aSTRUT, { "VALOR"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "TRANS"  , "C",  35 , 0 } )
   aadd( aSTRUT, { "CONTATO", "C",  20 , 0 } )

   cARQ  := criatrab( aSTRUT, .T. ) //cria arquivo de trabalho
   use ( cARQ ) alias TIT new
   Index on CHAVE + CLIENTE + NUM to ( cARQ )

   TIT->( DBAppend() )

    TIT->CHAVE   := " "
    TIT->CLIENTE := "NOME"
    TIT->TRANS   := ";TRANS"
    TIT->NUM     := ";NUM"
    TIT->DATAE   := ";DATA"
    TIT->DATAENT := ";DATAENT"
    TIT->DATAHJ  := ";DATAHJ"
    TIT->DATSAI  := ";DATSAI"
    TIT->VALOR   := ";VALOR"
    TIT->CONTATO := ";CONTATO"

   TIT->( DBCommit() )

   TIT->( DBAppend() )

   cDATA  := Right( DToS(SZZZ->F2_EMISSAO),2 ) + " de " + mes(month(SZZZ->F2_EMISSAO)) + " de " + ;
             Left(  DToS(SZZZ->F2_EMISSAO),4 )


    IF dtos(SZZZ->F2_PREVCHG) != '        '
    cDATA2 := Right( DToS(SZZZ->F2_PREVCHG),2 ) + " de " + mes(month(SZZZ->F2_PREVCHG)) + " de " + ;
              Left(  DToS(SZZZ->F2_PREVCHG),4 )
    ELSE
      cDATA2 := '        '
    ENDIF

    IF dtos(SZZZ->F2_DTEXP) != '        '
    cDATA3 := Right( DToS(SZZZ->F2_DTEXP),2 ) + " de " + mes(month(SZZZ->F2_DTEXP)) + " de " + ;
              Left(  DToS(SZZZ->F2_DTEXP),4 )
    ELSE
      cDATA3 := '        '
    ENDIF


    cDATA4 := alltrim(str(day(date())))+" de " + alltrim(mes(month(date()))) + " de " + alltrim(str(year(date())))

     TIT->CHAVE   := "*"
     TIT->CLIENTE := SZZZ->A1_NREDUZ
     TIT->CONTATO := ";" + SZZZ->A1_CONTATO
     TIT->TRANS   := ";" + SZZZ->A4_NREDUZ
     TIT->NUM     := ";n§ " + SZZZ->F2_DOC
     TIT->DATAE   := ";" + cDATA       //Data emissão
     TIT->DATAENT := ";" + cDATA2      //Prev. entrega
     TIT->DATSAI  := ";" + cDATA3      //Data saída
     TIT->DATAHJ  := ";" + cDATA4      //Data de hoje ( Date())
     TIT->VALOR   := ";R$ " + alltrim(transform(SZZZ->F2_VALBRUT, "@E 999,999.99"))
     TIT->( DBCommit() )

     DBSelectArea("TIT")
     cARQ := "Malafat.txt"
     aFields := { "CLIENTE", "NUM" }
     cPATH := "\Temp\" 
     
     Copy Fields CLIENTE,TRANS,NUM,DATAE,DATAENT,DATAHJ,DATSAI,VALOR,CONTATO To ( cPATH + cARQ ) SDF
     TIT ->( DBCloseArea() )

     
     If Empty( Directory( "\Temp\" + cARQ, "D" ) )
       Alert("Caminho ou arquivo '" + cARQ + "' nao encontrado. Impossivel abrir o Word. Usuario sem acesso.")
     Else
       //ShellExecute( 'open', cPATH + cARQ,'','', 1 ) //shownormal
       	nRet := 0
      	nRet := ShellExecute("open",cPATH + cARQ, "", "", 1)
     EndIf


Return Nil




***************

Static Function Relato()

***************



  tamanho   := "M"
  titulo    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc1    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc2    := PADC("", 74)
  cDesc3    := PADC("", 74)
  cNatureza := ""
  aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
  nomeprog  := "FATGNF"
  cPerg     := " "
  nLastKey  := 0
  lContinua := .T.
  nLin      := 9
  wnrel     := "FATGNF"
  M_PAG     := 1

  cString := "SB1"

  wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

  If nLastKey == 27
     Return
  Endif

  SetDefault( aReturn, cString )

  If nLastKey == 27
     Return
  Endif

  #IFDEF WINDOWS
     RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
     Return
    // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
    Static Function RptDetail()
  #ENDIF

  cCabec_01 := "                                        RAVA EMBALAGENS INDUSTRIA E COMERCIO LTDA."
  cCabec_02 := "Cabedelo/PB, "+alltrim(str(day(date())))+" de " + alltrim(mes(month(date()))) + " de " + alltrim(str(year(date()))) + " "
  cCabec_03 := "**********************************************************************************************************************************"
  cCabec_04 := "*                                                                                                                                *"
  cCabec_05 := "*                                                   POS-VENDAS / RAVA                                                            *"
  cCabec_06 := "*                                     Informativo de Faturamento de pedido de compra                                             *"
  cCabec_07 := "*                  Programacao de entrega de acordo com o prazo da transportadora para sua localidade                            *"
  cCabec_04 := "*                                                                                                                                *"
  cCabec_03 := "**********************************************************************************************************************************"
  //           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  //           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

  cCabec_08 := "*  Procuramos atender a todas as exigencias. Solicitamos que nos comuniquem as ocorrencias de eventuais problemas, tais como:    *"
  cCabec_09 := "*  Atraso na entrega; Devolucao de mercadorias; O nao recebimento do boleto bancario; O nao recebimento do aviso de vencimento.  *"
  cCabec_10 := "*  Caso haja a solicitacao de prorrogacao, fazer a gentileza de nos comunicar com 15 dias de antecedencia ao vencimento.         *"

  cCabec_11 := "*   Em caso de devolucao, nao aceitamos sem a previa autorizacao do servico de Pos-Vendas ao cliente.                            *"

  cCabec_12 := "     > Solicitacoes de total acompanhamento de entrega atraves do n. 0800 014 2345 ou pelo e-mail sac@ravaembalgens.com.br . "
//  cCabec_12 := "     > Solicitacoes de total acompanhamento de entrega atraves do n. 0800 727 1915 ou pelo e-mail sac@ravaembalgens.com.br . "

  cCabec_13 := "----------------------------------------------------------------------------------------------------------------------------------"
  cCabec_14 := "Obrigado por confiar em nossos servicos. Esperamos que as mercadorias cheguem de acordo com os seus desejos e nos declaramos    "
  cCabec_15 := "prontos para atender a qualquer reclamacao."
  cCabec_16 := "----------------------------------------------------------------------------------------------------------------------------------"

  cCabec_17 := "Rua Jose Geronimo da Silva Filho (Dede), 66 Renascer - Cabedelo-PB CEP:58310-000 Contato: (83)3048-1315 sac@ravaembalagens.com.br "
  cCabec_18 := "Atendimento a clientes 0800 014 2345 CNPJ:41.150.160/0001-02 - Inscricao Estadual:16.100.765-1"
//  cCabec_18 := "Atendimento a clientes 0800 727 1915 CNPJ:41.150.160/0001-02 - Inscricao Estadual:16.100.765-1"  

                 *********************************************************************************************************************************************
    //           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  //             0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

  Cabec( titulo, "", "", nomeprog, tamanho, 15 )
  @ Prow() + 2, 000 PSay cCabec_01
  @ Prow() + 1, 046 PSay cCabec_02
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_05
  @ Prow() + 1, 000 PSay cCabec_06
  @ Prow() + 1, 000 PSay cCabec_07
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 3, 000 PSay "Empresa / Cliente: " + SZZZ->A1_NREDUZ
  @ Prow() + 1, 000 PSay "At.: Dep. de Compras/Sr.(a) " + SZZZ->A1_CONTATO
  @ Prow() + 2, 000 PSay "Passamos os dados abaixo em relação ao envio de sua mercadoria: "
  @ Prow() + 1, 000 PSay "Data do faturamento: "
  @ Prow()    , 021 PSay  SZZZ->F2_EMISSAO
  @ Prow()    , 031 PSay  "Data de saida:"
  @ Prow()    , 046 PSay  SZZZ->F2_DTEXP
  @ Prow() + 1, 000 PSay "Transportadora: " + SZZZ->A4_NREDUZ
  @ Prow() + 1, 000 PSay "Nota(s) Fiscal(is): n. " + SZZZ->F2_DOC
  @ Prow() + 1, 000 PSay "Faturamento parcial( ) Total( ) Saldo( ) "
  @ Prow() + 1, 000 PSay "Valor(es) total(is): R$" + alltrim(transform(SZZZ->F2_VALBRUT, "@E 999,999.99"))
  @ Prow() + 1, 000 PSay "Previsao de entrega: "
  @ Prow()    , 021 PSay  SZZZ->F2_PREVCHG
  @ Prow() + 1, 000 PSay "Previsao alterada:     /  /   "
  @ Prow() + 1, 000 PSay "Motivo:__________________________________________________________________________________________________________ "

  @ Prow() + 3, 000 PSay cCabec_03
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_08
  @ Prow() + 1, 000 PSay cCabec_09
  @ Prow() + 1, 000 PSay cCabec_10
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_11
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 2, 000 PSay cCabec_12

  @ Prow() + 2, 000 PSay cCabec_13
  @ Prow() + 1, 000 PSay cCabec_14
  @ Prow() + 1, 000 PSay cCabec_15
  @ Prow() + 1, 000 PSay cCabec_16

  @ 054       , 000 PSay "Pos-Vendas/RAVA"

  @ 056       , 000 PSay cCabec_17
  @ 057       , 000 PSay cCabec_18


  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool( wnrel ) //Chamada do Spool de Impressao
  Endif

   MS_FLUSH()

Return (.T.)



***************

Static Function mes(ndata)

***************

  DO Case

    CASE nData == 1
      cMes := "Janeiro"

    CASE nData == 2
      cMes := "Fevereiro"

    CASE nData == 3
      cMes := "Marco"

    CASE nData == 4
      cMes := "Abril"

    CASE nData == 5
      cMes := "Maio"

    CASE nData == 6
      cMes := "Junho"

    CASE nData == 7
      cMes := "Julho"

    CASE nData == 8
      cMes := "Agosto"

    CASE nData == 9
      cMes := "Setembro"

    CASE nData == 10
      cMes := "Outubro"

    CASE nData == 11
      cMes := "Novembro"

    CASE nData == 12
      cMes := "Dezembro"

  EndCase

Return cMes

**********

Static Function CalcPrz(dDatsai, cDiatrab, nPrzent)

**********

  Local x := 1
  Local dData := dDatsai

  IF cDiatrab == alltrim(str(3))
    dData += nPrzent + 1  // a pedido de alexandre 001370 em 16/10/2009
  Else
    while( x <= nPrzent )

      IF (dData == DataValida(dData) )
        dData++
        x++
      ElseIF DataValida(dData) - dData >= 2
        DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
            dData := DataValida(dData)
            IF x == 1 //dayanne colocando saídas aos sábados de empresas que trabalham em 1
              x++
            ENDIF
          CASE cDiatrab == alltrim(str(2)) //seg ate sabado
            dData++
            x++
            /*Modificado*/
            IF (x > nPrzent) .AND. (dow(dData) == 1)
              dData++
            ENDIF
            /*Aqui*/
        ENDCASE
      Else
        dData := DataValida(dData)
      ENDIF
    EndDo
  Endif

  //dData++ 
  //o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
  //o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790
  x := 1

  while (x <= 2) .AND. (dData != DataValida(dData))

  //IF dData != DataValida(dData)
    DO CASE
      CASE cDiatrab == alltrim(str(1))
        IF dow(dData) == 1
          dData := DataValida(dData) + 1
        else
          dData := DataValida(dData)
        EndIf
      CASE cDiatrab == alltrim(str(2))
        IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
        /*Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          dData++*/
        ENDIF
    EndCase

  //ENDIF
  x++
  EndDo

Return dData

***************

Static Function MbrIdxCol(nCol,oBrowse)

***************

//COLUNAS ÍNDICE: 1 (SEGMENTO), 2 (CLIENTE) , 9 (PREV. CHEGADA), 14 (TRANSPORTADORA) , 
//if nCol == 1 .OR. nCol == 8 .OR. nCol == 13 .OR. nCol == 14
if nCol == 1 .OR. nCol == 2 .OR. nCol == 9 .OR. nCol == 14
	for nX := 1 to Len(oBrowse:aColumns)
	   if nX == 1 .OR. nX == 2 .OR. nX == 9 .OR. nX == 14
		   oBrowse:SetHeaderImage(nX,"COLRIGHT")
  	   endif   
	next nX   
   DbSelectArea("SZZZ")
   If nCol == 1
      nOrdG := 1
      Index On A1_SATIV1  To &cARQTMP    
      
   elseif nCol == 2
      nOrdG := 2
      Index On A1_NREDUZ  To &cARQTMP
   
   elseIf nCol == 9
      nOrdG := 3
      Index On F2_PREVCHG To &cARQTMP  
   
   elseIf nCol == 14
      nOrdG := 4
      Index On A4_NREDUZ  To &cARQTMP     
   endif   
   SZZZ->(DbSetOrder(1))
   oBrowse:SetHeaderImage(nCol,"COLDOWN")
	oBrowse:Refresh()
endif
Return


*********************************
Static Function geraDBT( nDias, cNotaf, nF2Valbrut )
*********************************

Local aVetor := {}
Local cAlias := "" 
Local nTotal := nQuant := 0
Local cQuery := ""

cQuery := "select count(*) as quant "
cQuery += "from   " + retSqlName('SE1') + " "
cQuery += "where  E1_FILIAL = '" + xFilial("SE1") + "' AND E1_NUM = '" + alltrim( cNotaf ) + "' AND E1_PREFIXO != '' "
cQuery += "and    D_E_L_E_T_ <> '*' "
//MemoWrite("\TempQry\GERADBT.SQL", cQuery )

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()	
EndIf 
  
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
While TMP->( !EoF() )
	nQuant := nQuant + TMP->quant
	TMP->(Dbskip())
Enddo
TMP->( dbCloseArea() )


                //Valor total do título * 7%       //Dias em atrasados
//nTotal := ( ( ( SZZZ->F2_VALBRUT * 0.07 ) / 30 ) * nDias ) + nQuant * 2

                //Valor total do título * 4%       //Dias em atrasados
//nTotal := ( ( ( SZZZ->F2_VALBRUT * 0.04 ) / 30 ) * nDias ) + nQuant * 2		//O 2 aqui significa R$2,00 de tarifa de prorrogação
nTotal := ( ( ( nF2Valbrut * 0.04 ) / 30 ) * nDias ) + nQuant * 2		//O 2 aqui significa R$2,00 de tarifa de prorrogação
//Chamado 001388 - alterar para 4%
//Número de títulos x Taxa bancária


cAlias := Alias()
lMsErroAuto := .F.

aVetor  := {{"E1_PREFIXO" ,"UNI"           ,Nil},;
			{"E1_NUM"	  ,SZZZ->F2_DOC    ,Nil},;
			{"E1_PARCELA" ,"9"             ,Nil},;
			{"E1_TIPO"	  ,"NF"            ,Nil},;
          	{"E1_CLIENTE" ,SZZZ->A4_CODCLIE,Nil},;
			{"E1_NATUREZ" ,"21005"         ,Nil},;
            {"E1_LOJA"	  ,"01"            ,Nil},;
          	{"E1_EMISSAO" ,dDataBase       ,Nil},;
	       	{"E1_VENCTO"  ,dDataBase       ,Nil},;
	       	{"E1_VALOR"	  ,nTotal          ,Nil},;
 		    {"E1_HIST"	  ,"ATRASO NF: "+alltrim(SZZZ->F2_DOC),  Nil},;
 		    {"E1_NATRASO" , nDias		   ,Nil},;
 		    {"E1_CODORCA" ,"POSVENDA"      ,Nil}}
//	       	{"E1_VENCREA" ,dDataBase       ,Nil},;			  
//dbSelectArea( "SE2" )


MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) 


If lMsErroAuto
	Alert("Erro: Contactar setor de T.I.")
Else
	MsgInfo("Débito gerado para Transp. - OK !!!")
Endif

iif(!empty(cAlias),dbSelectArea( cAlias ),)


return


***********************************
Static Function testaDbt( cNotaf )
***********************************

local cQuery := ""

cQuery := "select * from " + retSqlName('SE1') + " where E1_FILIAL = '"+xFilial('SE1')+"' and "
cQuery += "E1_NUM = '"+alltrim(cNotaf)+"' and E1_PREFIXO IN( 'UNI','0' ) and E1_TIPO = 'NF' and E1_NATUREZ = '21005' "
cQuery += "and E1_CODORCA = 'POSVENDA' and D_E_L_E_T_ != '*' "
//MemoWrite("\TempQry\TESTADBT.SQL" , cQuery )
  
  If Select("TMPYP") > 0
	DbSelectArea("TMPYP")
	DbCloseArea()	
  EndIf 
  
  TCQUERY cQuery NEW ALIAS 'TMPYP'
  TMPYP->( dbGoTop() )  

  if !TMPYP->( EoF() )
     msgAlert("Esse registro não pode ser alterado, pois já há um débito para o mesmo. ")
     TMPYP->( dbCloseArea() )
     Return .F.
  //else
  	//Msgbox("Será gerado o débito")
  endIf
  TMPYP->( dbCloseArea() )  

Return .T.

***************

Static Function testaCod( cCodClie )

***************
if empty(cCodClie)
   msgAlert("Essa transportadora está com seu código de cliente VAZIO! Favor corrigir.")	
   return .F.
endIF
Return .T.

***********************************
Static Function EnviaMail( nOpt )
***********************************

Local cEmailTo  	:=  "" //"posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"+iif( !empty(SZZZ->A1_EMAIL),";"+SZZZ->A1_EMAIL,'') //voltar
//Local cEmailTo		:= "flavia.rocha@ravaembalagens.com.br"
Local cEmailCc  	:= ""
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt      
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= "" //iif(nOpt == 1, "Aviso de retenção em posto fiscal", "Aviso de reagendamento")
Local cFrom			:= GetMV( "MV_RELACNT" )
Local cVendedor		:= ""
Local cMailVend     := ""
Local cSuper		:= ""
Local cMailSuper	:= ""

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO 
//FR - 27/06/2011 - CHAMADO 002179 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF 
//NO ENVIO DOS EMAILS DE RETENÇÃO E AGENDAMENTO
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + SZZZ->F2_DOC + SZZZ->F2_SERIE ))
	cVendedor := SF2->F2_VEND1
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper 		:= SA3->A3_SUPER
	cMailVend	:= SA3->A3_EMAIL
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
	cMailSuper += ";steves.scanoni@ravaembalagens.com.br"
	/*
	If Alltrim(cSuper) = '0229'
		cMailSuper += ";janaina@ravaembalagens.com.br"
	Elseif Alltrim(cSuper) = '0245'
		cMailSuper += ";marcos@ravaembalagens.com.br"
	Elseif Alltrim(cSuper) = '0248'
		cMailSuper += ";josenildo@ravaembalagens.com.br"
	Endif
	*/
Endif
//FR - até aqui


cEmailTo := "comercial@ravabrasil.com.br;posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br" + ;
iif( !empty(SZZZ->A1_EMAIL),";"+SZZZ->A1_EMAIL,'')



If nOpt = 1 
    cAssunto :=	"Aviso de Retenção em Posto Fiscal"
    If !Empty(cMailSuper)
		cEmailTo += ";" + cMailSuper
	Endif
	
	If !Empty(cMailVend)
		cEmailTo += ";" + cMailVend
	Endif 

ElseIF nOpt = 2
	cAssunto :=  "Aviso de Reagendamento"
//aviso posto fiscal
//Else		//desabilitado por solicitação de Daniela - 25/07/11
//	cEmailTo := "posvendas@ravaembalagens.com.br;alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br" 
//	cAssunto := "Posto Fiscal - Aviso p/ LOGÍSTICA"

	If !Empty(cMailSuper)
		cEmailTo += ";" + cMailSuper
	Endif
	
	If !Empty(cMailVend)
		cEmailTo += ";" + cMailVend
	Endif 
//aviso Dt. Chegada na UF destino
Else	  //Flávia Rocha - 03/08/2011 - solicitado por Daniela - chamado 002197
	cEmailTo := "sac@ravaembalagens.com.br;posvendas@ravaembalagens.com.br;comercial@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br" 
	 
	cAssunto := "Chegada na UF Destino - Aviso p/ LOGÍSTICA"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmailCc := ""                                  
//cEmailCc := "flavia.rocha@ravaembalagens.com.br"                                  
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

If nOpt = 1 .or. nOpt = 2 
	if empty(SZZZ->A1_EMAIL)
		cMsg := "<b>O EMAIL DO CLIENTE ESTÁ EM BRANCO! ELE NÃO RECEBERÁ ESTE INFORMATIVO. </b><br> <br> "
	Endif
	
	cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
	//CHAMADO 1960 - ALTERAR DE: DEPTO. PÓS-VENDAS PARA: SAC
	//cMsg += "De: Rava Embalagens - Pós-Vendas <br> <br>"
	cMsg += "De: Rava Embalagens - SAC <br> <br>"
	cMsg += "Para: "+alltrim(SZZZ->A1_NREDUZ)+" <br> <br>"
	cMsg += "" + alltrim(SZZZ->A1_CONTATO) + " <br> <br>"
	cMsg += "INFORMATIVO <br> <br>" 
Else
	cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
	cMsg += "De: Rava Embalagens - SAC <br> <br>"
	cMsg += "Para: DEPTO. LOGÍSTICA <br> <br>"
	cMsg += "INFORMATIVO <br> <br>" 

Endif
	
if nOpt == 1     //retenção
	cMsg += "Informamos que o material referente a nota fiscal " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", encontra-se no depósito <br>"
	cMsg += "da transportadora "+alltrim(SZZZ->A4_NREDUZ)+", em razão da NF está retida no Posto fiscal do seu Estado. <br> <br>"
	cMsg += "Pedimos que entre em contato com a transportadora através dos telefones " + alltrim(SZZZ->A4_TEL) + ", <br>"
	cMsg += "para maiores esclarecimentos e soluções. <br> <br>"
	cMsg += "<b>Lembrando também que o material possui um prazo de até 07 dias corridos para permanecer em depósito sem <br>"
	cMsg += "cobrança de taxa para armazenamento.</b> <br> <br>"
elseif nOpt == 2     //reagendamento
	cMsg += "Informamos que, com relação à mercadoria de N.F. " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", com previsão de entrega <br> "
	cMsg += "para " + dtoc(SZZZ->F2_PREVCHG) + ", conforme solicitação de V.Sa.<br> <br>"
//else 		// opt=3 Posto Fiscal
//	cMsg += "Informamos que o material referente a nota fiscal " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", encontra-se<br>"
//	cMsg += "no Posto Fiscal do Estado. <br> <br>"

else 		// opt=3 Dt. Chegada UF Destino
	cMsg += "Informamos que o material referente a nota fiscal " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", chegou "
	cMsg += "na UF Destino: "+ SZZZ->F2_EST + ", em " + Dtoc(SZZZ->F2_UFCHG) + ". <br>"
	cMsg += "Transportadora: " + alltrim( SZZZ->A4_NREDUZ )+". <br>"
	cMsg += "Cliente: "+alltrim(SZZZ->A1_NREDUZ)+" <br><br>"
endIf

cMsg += "Estarei à inteira disposição para esclarecer qualquer dúvida.<br> <br> <br> <br>"
cMsg += "Atenciosamente, <br>"
//cMsg += "Daniela Barros<br>"
//CHAMADO 1960 - ALTERAR DE: DEPTO. PÓS-VENDAS PARA: SAC
//cMsg += "Pós-Vendas<br>"
cMsg += "SAC<br>"
cMsg += "sac@ravaembalagens.com.br <br><br></p>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += '<font size = "2" face="Arial"><< prg: TMKC014.PRW >></font></p>'

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	else
		conout(Replicate("*",60))
		conout("Call Center - TMKC014")
		conout( "Email: " + cAssunto + "-" + Dtoc( Date() ) + ' - ' + Time() )
		conout( "Para: " + cEmailTo + " / " + cEmailCc )
		conout("E-mail enviado com sucesso.")
		conout(Replicate("*",60))
	
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif
Return(lResult)

***************

Static Function IMPRIME()

***************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relatorio de Pos-Venda"
Local nLin           := 132
//Local Cabec1         := "Nome                 Municipio                 Fone                 Nota Fiscal     Prev. Entrega   Transportadora"
//Local Cabec1		 := "DOCUMENTO          CLIENTE                TEL.CLIENTE                MUNICIPIO                   TRANSPORTADORA        PREV.CHEGADA     DT. PEDIDO"                 
Local Cabec1		 := "DOCUMENTO          CLIENTE                MUNICIPIO                   TRANSPORTADORA        PREV.CHEGADA          REAL CHEGADA          DT. PEDIDO"                 
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "FATC014" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATC014" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := SZZZ->( recno() )
SZZZ->( dbGoTop() )
Do While SZZZ->( !EOF() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   

   // Coloque aqui a logica da impressao do seu programa...
   dDataPed	:= fDataPed(SZZZ->F2_DOC, SZZZ->F2_SERIE, SZZZ->F2_EMISSAO)    
  //DOCUMENTO     CLIENTE                 TEL.CLIENTE             MUNICIPIO                   TRANSPORTADORA      PREV.CHEGADA"                 
  //XXXXXXXXX     XXXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXX      99/99/99                    
  //Em 26/01/10 - Daniela solicitou que retirasse o tel da Transportadora deste relatório
	//@nLin,00 PSAY SZZZ->F2_DOC + "    " + SZZZ->A1_NREDUZ +"    " + SZZZ->A1_TEL + "    " + SZZZ->A1_MUN + "    " +	Substr( SZZZ->A4_NREDUZ,1,20 ) 	+ "    " +;
	If !Empty(SZZZ->F2_REALCHG)
		nDif	:= SZZZ->F2_REALCHG - dDataPed
	Else
		nDif	:= 0
	EndIf
	@nLin,00 PSAY SZZZ->F2_DOC + "    " + SZZZ->A1_NREDUZ +"    " + SZZZ->A1_MUN + "    " +	Substr( SZZZ->A4_NREDUZ,1,20 ) 	+ "    " +;
	DTOC(SZZZ->F2_PREVCHG )  + "   " + DTOC(SZZZ->F2_REALCHG )  + "   " + DTOC(dDataPed) + "   " + transform(nDif, "@E 999,999") 
	//DTOC(SZZZ->SZ_PREVISO)
   
   
   
   
   nLin := nLin + 1 // Avanca a linha de impressao
   incRegua()
   SZZZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

SZZZ->( dbGoTo(nOrdem) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
Return


Return		//Fim da funcao que chama o relatorio



*****************************
Static Function TK271CALL() 
*****************************

Local lRet 		:= .F. 
Local nReg 		:= 0
Local cQuery 	:= ""
Local cUCcodigo	:= ""
Local cChave	:= ""
Local cFilialUC	:= ""
Local cCli		:= ""
Local cLoja		:= ""
Local cCodCont	:= ""
Local cEntidad	:= ""
Local cUCNF		:= ""
Local cUCserie	:= ""
Local cEntidade := "" 
Local LF      	:= CHR(13)+CHR(10) 

cQuery := " Select UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, UC_STATUS, UC_CODCONT, UC_ENTIDAD, R_E_C_N_O_ AS NRECNO "+LF
cQuery += " From " + Retsqlname("SUC") + " SUC "+LF
cQuery += " Where RTRIM( SUC.UC_NFISCAL ) = '" + Alltrim( SZZZ->F2_DOC ) + "' "+LF
cQuery += " and RTRIM( SUC.UC_SERINF ) = '" + Alltrim( SZZZ->F2_SERIE ) + "' "+LF
cQuery += " and SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
cQuery += " and RTRIM(SUC.UC_OBSPRB) <> 'S' "+LF
cQuery += " and SUC.D_E_L_E_T_ = ''"+LF
//MemoWrite("\TempQry\VerSUC0.sql",cQuery)
cQuery := ChangeQuery( cQuery )
  
If Select("SUC1") > 0
	DbSelectArea("SUC1")
	DbCloseArea()	
EndIf 
	
TCQUERY cQuery NEW ALIAS "SUC1"
SUC1->(Dbgotop())
If !SUC1->( EoF() )
	If SUC1->UC_STATUS = '3'
		If MsgYesNo("O atendimento já foi encerrado, deseja REATIVÁ-LO ?")
			//Msgbox("Reativar")
			U_ReativaSUC(SUC1->UC_CODIGO,SUC1->UC_NFISCAL, SUC1->UC_SERINF, SUC1->UC_ENTIDAD, SUC1->UC_CHAVE, SUC1->UC_CODCONT )
			
			cCli 		:= Substr( SUC1->UC_CHAVE, 1, 6 )
			cLoja		:= Substr( SUC1->UC_CHAVE, 7, 2 ) 
			cCodCont 	:= SUC1->UC_CODCONT
			cUCcodigo 	:= SUC1->UC_CODIGO
			cUCNF		:= SUC1->UC_NFISCAL
			cUCserie	:= SUC1->UC_SERINF
			cEntidade	:= SUC1->UC_ENTIDAD
			nReg 		:= SUC1->NRECNO
		Else
			Return( lRet )
		Endif
	Endif	
		cCli 		:= Substr( SUC1->UC_CHAVE, 1, 6 )
		cLoja		:= Substr( SUC1->UC_CHAVE, 7, 2 ) 
		cCodCont 	:= SUC1->UC_CODCONT
		cUCcodigo 	:= SUC1->UC_CODIGO
		cUCNF		:= SUC1->UC_NFISCAL
		cUCserie	:= SUC1->UC_SERINF
		cEntidade	:= SUC1->UC_ENTIDAD
		nReg 		:= SUC1->NRECNO
		lRet 		:= .T. 	
Else
	MsgBox("Não existe atendimento ref. a NF--> " + SZZZ->F2_DOC + "  !!!" )
	Return( lRet )	
Endif



If lRet     
	MsAguarde( {|| U_TMKC018( cEntidade, cUCcodigo, cUCNF, cUCserie, .T. ) }, OemToAnsi( "Aguarde" ), OemToAnsi( "Localizando Atendimento..." ) )
Endif

Return( lRet )

*****************************
Static Function fDataPed(cDoc,cSerie,dEmissao) 
*****************************

Local dRet 	 
Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10) 

cQuery := " SELECT DISTINCT C5_EMISSAO FROM " + Retsqlname("SC5") + " C5 "+LF
cQuery += " INNER JOIN " + Retsqlname("SD2") + " D2 "+LF
cQuery += " ON C5_FILIAL + C5_NUM = D2_FILIAL + D2_PEDIDO
cQuery += " WHERE D2.D_E_L_E_T_ <> '*' 
cQuery += " AND D2_DOC = '" + cDoc + "' "+LF
cQuery += " AND D2_SERIE = '" + cSerie + "' "+LF
cQuery += " AND D2_EMISSAO = '" + DtoS(dEmissao) + "' "+LF


cQuery := ChangeQuery( cQuery )
  
If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()	
EndIf 
	
TCQUERY cQuery NEW ALIAS "TMP1"
TCSetField( 'TMP1', "C5_EMISSAO", "D")

TMP1->(Dbgotop())

dRet := TMP1->C5_EMISSAO

DbSelectArea("TMP1")

Return( dRet )
