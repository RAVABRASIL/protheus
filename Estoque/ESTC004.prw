#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*-------------------------------------------------------------------------------------*/
//Programa: ESTC004 - Cadastro de Metas de Consumo por Grupo de Produto
//Autoria : Flávia Rocha
//Data    : 08/04/10
//
/*-------------------------------------------------------------------------------------*/

*************************
User Function ESTC004()
*************************


Private cCadastro	:= "Cadastro de Metas de Consumo"


Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar"   ,	"U_VisMeta()"  	,0,2},;  	// Visualizar
							{"Incluir"     ,	"U_IncMeta()"	,0,3},;	    // Incluir
							{"Alterar"	   ,    "U_AltMeta()"   ,0,4},;
							{"Excluir"	   ,    "U_ExcMeta()"   ,0,4}}


mBrowse( 6, 1,22,75, "ZB2",,,,,,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZB2")
dbSetOrder(1)
	
Return(Nil)




******************************************************************************************************
User Function IncMeta()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZB2	:= ZB2->(GetArea())
//Local cGrupo  	:= CriaVar("ZB2_GRUPO",.F.,.F.)
Local cTipo  	:= CriaVar("ZB2_TIPO",.F.,.F.)
//Local cDescGru	:= CriaVar("ZB2_DESCGR",.F.,.F.)
Local cDescTip	:= CriaVar("ZB2_DESCTP",.F.,.F.)
Local nMeta		:= CriaVar("ZB2_META",.F.,.F.)
Local nMetaEst	:= CriaVar("ZB2_METAES",.F.,.F.)
Local cMes		:= CriaVar("ZB2_MES",.F.,.F.)
Local cAno		:= CriaVar("ZB2_ANO",.F.,.F.)
Local cAnoMes	:= ""
Local oDlg5




DEFINE MSDIALOG oDlg5 FROM 000,000 TO 300,590 TITLE "Cadastre a Meta de Consumo" PIXEL
//                                    o 300 é a altura, o 590 é a largura

@ 005,007 SAY "Tipo Produto:" 					OF oDlg5 PIXEL	COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET cTipo					WHEN .T.	PICTURE PesqPict("SB1","B1_TIPO")	F3 "02"	OF oDlg5 SIZE 040,006 PIXEL


@ 005,075 SAY "Descrição" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 017,075 MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "02" + cTipo,1,0)	WHEN .F.	PICTURE PesqPict("SX5","X5_DESCRI")		OF oDlg5 SIZE 213,006 PIXEL 

@ 035,007 SAY "Meta Consumo:" 					OF oDlg5 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,007 MSGET nMeta					WHEN .T.	PICTURE PesqPict("ZB2","ZB2_META")		OF oDlg5 SIZE 046,006 PIXEL

@ 035,075 SAY "Meta Estoque:" 					OF oDlg5 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
@ 045,075 MSGET nMetaEst				WHEN .T.	PICTURE PesqPict("ZB2","ZB2_METAES")		OF oDlg5 SIZE 046,006 PIXEL

@ 065,007 SAY "Mês" 							OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
//@ 075,007 MSGET cMes WHEN .T.	PICTURE PesqPict("ZB2","ZB2_MES") OF oDlg5 SIZE 055,006 PIXEL
@ 075,007 COMBOBOX oCbx VAR cMes ITEMS { " ", "01=Janeiro" ,"02=Fevereiro","03=Março","04=Abril","05=Maio","06=Junho","07=Julho",;
										"08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro" }  WHEN .T. SIZE 46, 27 OF oDlg5 PIXEL		

@ 065,075 SAY "Ano" 							OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 075,075 MSGET cAno WHEN .T.	PICTURE PesqPict("ZB2","ZB2_ANO")	OF oDlg5 SIZE 055,006 PIXEL
/*
@ 065,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL    //LINHA FINA EM VOLTA
@ 075,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
@ 075,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
@ 075,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
					                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL

@ 095,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 102,003 TO 121,292 OF oDlg5 PIXEL
@ 105,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUC","UC_DATA")		OF oDlg5 SIZE 040,006 PIXEL

@ 095,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 105,157 MSGET cHoraIni						WHEN .F.	PICTURE PesqPict("SUC","UC_INICIO")	    OF oDlg5 SIZE 040,006 PIXEL


@ 125,007 SAY "Responsável pelo Atendimento" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 132,003 TO 200,292 OF oDlg5 PIXEL
@ 135,007 MSGET cNomeUser						WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL

@ 150,007 SAY "Data para solução:" 				OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 160,007 MSGET dDataResp						WHEN .T.;
 VALID(!Empty( dDataResp ).And.dDataResp >= dDatabase .and. FdtValida(dDataResp)  ) PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 180,007 SAY "Observações: " 					OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 187,007 MSGET cObsSUD							VALID(!Empty( cObsSUD )) WHEN .T.	PICTURE "@S60"    				OF oDlg5 SIZE 273,006 PIXEL
*/
DEFINE SBUTTON FROM 125,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
DEFINE SBUTTON FROM 125,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpcA == 1
	
	dbSelectArea("ZB2")
	dbSetOrder(5)
	//Procura o atendimento (itens) e grava a data de resposta		
	If !ZB2->(DbSeek(xFilial("ZB2")+ cTipo + cAno + cMes ))
			cDescTip := Posicione("SX5",1,xFilial("SX5") + "02" + cTipo,"X5_DESCRI")	
			RecLock("ZB2",.T.)
			//ZB2->ZB2_GRUPO	:= cGrupo
			ZB2->ZB2_TIPO	:= cTipo
			//ZB2->ZB2_DESCGR	:= cDescGru
			ZB2->ZB2_DESCTP	:= cDescTip
			ZB2->ZB2_META	:= nMeta
			ZB2->ZB2_METAES	:= nMetaEst
			ZB2->ZB2_MES	:= cMes
			ZB2->ZB2_ANO	:= cAno
			ZB2->ZB2_ANOMES	:= Alltrim(cAno) + Alltrim(cMes)
					
			ZB2->(MsUnLock())	
		
	Else
		Msgbox("Já existe esta informação para este Grupo!!")
	Endif


EndIf

RestArea(aAreaZB2)
RestArea(aAreaAtu)

Return(Nil)   


******************************************************************************************************
User Function AltMeta()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZB2	:= ZB2->(GetArea())
//Local cGrupo  	:= ZB2->ZB2_GRUPO
Local cTipo  	:= ZB2->ZB2_TIPO
//Local cDescGru	:= ZB2->ZB2_DESCGR
Local cDescTip	:= ZB2->ZB2_DESCTP
Local nMeta		:= ZB2->ZB2_META
Local nMetaEst	:= ZB2->ZB2_METAES
Local cMes		:= ZB2->ZB2_MES
Local cAno		:= ZB2->ZB2_ANO
Local cAnoMes	:= ZB2->ZB2_ANOMES
Local oDlg6



DEFINE MSDIALOG oDlg6 FROM 000,000 TO 300,590 TITLE "Cadastre a Meta de Consumo" PIXEL
//                                    o 300 é a altura, o 590 é a largura

@ 005,007 SAY "Tipo Produto:" 					OF oDlg6 PIXEL	COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg6 PIXEL
@ 017,007 MSGET cTipo					WHEN .F.	PICTURE PesqPict("SB1","B1_TIPO")	F3 "02"	OF oDlg6 SIZE 040,006 PIXEL


@ 005,075 SAY "Descrição" 							OF oDlg6 PIXEL //COLOR CLR_HBLUE
@ 017,075 MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "02" + cTipo,1,0)	WHEN .F.	PICTURE PesqPict("SX5","X5_DESCRI")		OF oDlg6 SIZE 213,006 PIXEL 

@ 035,007 SAY "Meta Consumo:" 					OF oDlg6 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg6 PIXEL
@ 045,007 MSGET nMeta					WHEN .T.	PICTURE PesqPict("ZB2","ZB2_META")		OF oDlg6 SIZE 046,006 PIXEL

@ 035,075 SAY "Meta Estoque:" 					OF oDlg6 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg6 PIXEL
@ 045,075 MSGET nMetaEst				WHEN .T.	PICTURE PesqPict("ZB2","ZB2_METAES")		OF oDlg6 SIZE 046,006 PIXEL

@ 065,007 SAY "Mês" 							OF oDlg6 PIXEL COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg6 PIXEL    //LINHA FINA EM VOLTA
//@ 075,007 MSGET cMes WHEN .T.	PICTURE PesqPict("ZB2","ZB2_MES") OF oDlg5 SIZE 055,006 PIXEL
@ 075,007 COMBOBOX oCbx VAR cMes ITEMS { " ", "01=Janeiro" ,"02=Fevereiro","03=Março","04=Abril","05=Maio","06=Junho","07=Julho",;
										"08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro" }  WHEN .F. SIZE 46, 27 OF oDlg6 PIXEL		

@ 065,075 SAY "Ano" 							OF oDlg6 PIXEL COLOR CLR_HBLUE
@ 075,075 MSGET cAno WHEN .F.	PICTURE PesqPict("ZB2","ZB2_ANO")	OF oDlg6 SIZE 055,006 PIXEL

DEFINE SBUTTON FROM 125,220 TYPE 1  ENABLE OF oDlg6 ACTION (nOpcA := 1,oDlg6:End())	//botão OK
DEFINE SBUTTON FROM 125,260 TYPE 2  ENABLE OF oDlg6 ACTION (nOpcA := 0,oDlg6:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg6 CENTERED

If nOpcA == 1
	
	dbSelectArea("ZB2")
	dbSetOrder(5)
	//Procura o atendimento (itens) e grava a data de resposta		
	If ZB2->(DbSeek(xFilial("ZB2")+ cTipo + cAno + cMes ))
			//cDescGru := Posicione("SBM",1,xFilial("SBM") + cGrupo,"BM_DESC")	
		While ZB2->(!EOF()) .AND. ZB2->ZB2_FILIAL == xFilial("ZB2") .and.;
			  ZB2->ZB2_TIPO == cTipo .and. ZB2->ZB2_ANO == cAno .and.;
			  ZB2->ZB2_MES == cMes		
			
			RecLock("ZB2",.F.)
			//ZB2->ZB2_GRUPO	:= cGrupo
			ZB2->ZB2_TIPO	:= cTipo
			//ZB2->ZB2_DESCGR	:= cDescGru
			ZB2->ZB2_DESCTP	:= cDescTip
			ZB2->ZB2_META	:= nMeta
			ZB2->ZB2_METAES	:= nMetaEst
			//ZB2->ZB2_MES	:= cMes
			//ZB2->ZB2_ANO	:= cAno
			//ZB2->ZB2_ANOMES	:= Alltrim(cAno) + Alltrim(cMes)
					
			ZB2->(MsUnLock())
			ZB2->(DBSKIP())
		Enddo	
		
	//Else
		//Msgbox("Já existe esta informação para este Grupo!!")
	Endif


EndIf

RestArea(aAreaZB2)
RestArea(aAreaAtu)

Return(Nil)   



******************************************************************************************************
User Function ExcMeta()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZB2	:= ZB2->(GetArea())
//Local cGrupo  	:= ZB2->ZB2_GRUPO
Local cTipo  	:= ZB2->ZB2_TIPO
//Local cDescGru	:= ZB2->ZB2_DESCGR
Local cDescTip	:= ZB2->ZB2_DESCTP
Local nMeta		:= ZB2->ZB2_META
Local nMetaEst	:= ZB2->ZB2_METAES
Local cMes		:= ZB2->ZB2_MES
Local cAno		:= ZB2->ZB2_ANO
Local cAnoMes	:= ZB2->ZB2_ANOMES
Local oDlg7



DEFINE MSDIALOG oDlg7 FROM 000,000 TO 300,590 TITLE "Cadastre a Meta de Consumo" PIXEL
//                                    o 300 é a altura, o 590 é a largura

@ 005,007 SAY "Tipo Produto:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg7 PIXEL
@ 017,007 MSGET cTipo					WHEN .F.	PICTURE PesqPict("SB1","B1_TIPO")	F3 "02"	OF oDlg7 SIZE 040,006 PIXEL


@ 005,075 SAY "Descrição" 							OF oDlg7 PIXEL //COLOR CLR_HBLUE
@ 017,075 MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "02" + cTipo,1,0)	WHEN .F.	PICTURE PesqPict("SX5","X5_DESCRI")		OF oDlg7 SIZE 213,006 PIXEL 

@ 035,007 SAY "Meta Consumo:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg7 PIXEL
@ 045,007 MSGET nMeta					WHEN .F.	PICTURE PesqPict("ZB2","ZB2_META")		OF oDlg7 SIZE 046,006 PIXEL

@ 035,075 SAY "Meta Estoque:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg7 PIXEL
@ 045,075 MSGET nMetaEst				WHEN .F.	PICTURE PesqPict("ZB2","ZB2_METAES")		OF oDlg7 SIZE 046,006 PIXEL

@ 065,007 SAY "Mês" 							OF oDlg7 PIXEL COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg7 PIXEL    //LINHA FINA EM VOLTA
//@ 075,007 MSGET cMes WHEN .T.	PICTURE PesqPict("ZB2","ZB2_MES") OF oDlg5 SIZE 055,006 PIXEL
@ 075,007 COMBOBOX oCbx VAR cMes ITEMS { " ", "01=Janeiro" ,"02=Fevereiro","03=Março","04=Abril","05=Maio","06=Junho","07=Julho",;
										"08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro" }  WHEN .F. SIZE 46, 27 OF oDlg7 PIXEL		

@ 065,075 SAY "Ano" 							OF oDlg7 PIXEL COLOR CLR_HBLUE
@ 075,075 MSGET cAno WHEN .F.	PICTURE PesqPict("ZB2","ZB2_ANO")	OF oDlg7 SIZE 055,006 PIXEL

DEFINE SBUTTON FROM 125,220 TYPE 1  ENABLE OF oDlg7 ACTION (nOpcA := 1,oDlg7:End())	//botão OK
DEFINE SBUTTON FROM 125,260 TYPE 2  ENABLE OF oDlg7 ACTION (nOpcA := 0,oDlg7:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg7 CENTERED

If nOpcA == 1
	
	dbSelectArea("ZB2")
	dbSetOrder(5)
	//Procura o atendimento (itens) e grava a data de resposta		
	If ZB2->(DbSeek(xFilial("ZB2")+ cTipo + cAno + cMes ))
			//cDescGru := Posicione("SBM",1,xFilial("SBM") + cGrupo,"BM_DESC")	
		While ZB2->(!EOF()) .AND. ZB2->ZB2_FILIAL == xFilial("ZB2") .and.;
			  ZB2->ZB2_TIPO == cTipo .and. ZB2->ZB2_ANO == cAno .and.;
			  ZB2->ZB2_MES == cMes		
			
			RecLock("ZB2",.F.)
			ZB2->(Dbdelete())					
			ZB2->(MsUnLock())
			ZB2->(DBSKIP())
		Enddo	
		
	Endif


EndIf

RestArea(aAreaZB2)
RestArea(aAreaAtu)

Return(Nil)    


******************************************************************************************************
User Function VisMeta()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaZB2	:= ZB2->(GetArea())
//Local cGrupo  	:= ZB2->ZB2_GRUPO
Local cTipo  	:= ZB2->ZB2_TIPO
//Local cDescGru	:= ZB2->ZB2_DESCGR
Local cDescTip	:= ZB2->ZB2_DESCGR
Local nMeta		:= ZB2->ZB2_META
Local nMetaEst	:= ZB2->ZB2_METAES
Local cMes		:= ZB2->ZB2_MES
Local cAno		:= ZB2->ZB2_ANO
Local cAnoMes	:= ZB2->ZB2_ANOMES
Local oDlg7



DEFINE MSDIALOG oDlg7 FROM 000,000 TO 300,590 TITLE "Cadastre a Meta de Consumo" PIXEL
//                                    o 300 é a altura, o 590 é a largura

@ 005,007 SAY "Tipo Produto:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg7 PIXEL
@ 017,007 MSGET cTipo					WHEN .F.	PICTURE PesqPict("SB1","B1_TIPO")	F3 "02"	OF oDlg7 SIZE 040,006 PIXEL


@ 005,075 SAY "Descrição" 							OF oDlg7 PIXEL //COLOR CLR_HBLUE
@ 017,075 MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "02" + cTipo,1,0)	WHEN .F.	PICTURE PesqPict("SX5","X5_DESCRI")		OF oDlg7 SIZE 213,006 PIXEL 

@ 035,007 SAY "Meta Consumo:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg7 PIXEL
@ 045,007 MSGET nMeta					WHEN .F.	PICTURE PesqPict("ZB2","ZB2_META")		OF oDlg7 SIZE 046,006 PIXEL

@ 035,075 SAY "Meta Estoque:" 					OF oDlg7 PIXEL	COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg7 PIXEL
@ 045,075 MSGET nMetaEst				WHEN .F.	PICTURE PesqPict("ZB2","ZB2_METAES")		OF oDlg7 SIZE 046,006 PIXEL

@ 065,007 SAY "Mês" 							OF oDlg7 PIXEL COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg7 PIXEL    //LINHA FINA EM VOLTA
//@ 075,007 MSGET cMes WHEN .T.	PICTURE PesqPict("ZB2","ZB2_MES") OF oDlg5 SIZE 055,006 PIXEL
@ 075,007 COMBOBOX oCbx VAR cMes ITEMS { " ", "01=Janeiro" ,"02=Fevereiro","03=Março","04=Abril","05=Maio","06=Junho","07=Julho",;
										"08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro" }  WHEN .F. SIZE 46, 27 OF oDlg7 PIXEL		

@ 065,075 SAY "Ano" 							OF oDlg7 PIXEL COLOR CLR_HBLUE
@ 075,075 MSGET cAno WHEN .F.	PICTURE PesqPict("ZB2","ZB2_ANO")	OF oDlg7 SIZE 055,006 PIXEL

DEFINE SBUTTON FROM 125,220 TYPE 1  ENABLE OF oDlg7 ACTION (nOpcA := 1,oDlg7:End())	//botão OK
DEFINE SBUTTON FROM 125,260 TYPE 2  ENABLE OF oDlg7 ACTION (nOpcA := 0,oDlg7:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg7 CENTERED


RestArea(aAreaZB2)
RestArea(aAreaAtu)

Return(Nil)   



