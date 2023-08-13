#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MSD2460   ³                               ³ Data ³ 10/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Criacao/Atualizacao SC9 -Rava                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Ponto de Entrada criado na gravação dos Itens da NF, para executar um execblock 
criado pelo usuário após a gravação da tabela SD2.
*/

User Function MSD2460()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

Local nORD := SB1->( IndexOrd() ), ;
      nREG := SB1->( Recno() ), ;
      aMATRIZ
Local aAreaSF2	:= GetArea("SF2")
Local aAreaSD2	:= GetArea("SD2")
Local aAreaSD3	:= GetArea("SD3")
Local aAreaSA1	:= GetArea("SA1")
Local _cDoc		:= ""
Local cCODSECU	:= ""
Local lConfirm	:= .F.

lMsErroAuto	:= .F.

If SM0->M0_CODIGO == "02" .and. "VD" $ SF2->F2_VEND1 .AND. SF2->F2_TIPO <> "C"
  
   dbSelectArea("SB1")
   SB1->( DbSetOrder( 1 ) )
   SB1->( DbSeek( xFilial("SB1") + SD2->D2_COD ) )
   nPESO := SB1->B1_PESOR

	DbSelectArea("SD3")
	SD3->(dbSetOrder(2))
	
	//se não achar o numero da Movimentação com o numero da NF, inclui. CC usa o proximo numero.
	If !SD3->(dbSeek(xFilial("SD3") + SD2->D2_DOC + SD2->D2_COD))
		_cDoc		:= SD2->D2_DOC
	Else    
		_cDoc		:= GetSxeNum("SD3","D3_DOC")
		lConfirm	:= .T.
	EndIf
	aMATRIZ     := { 		{ "D3_TM"		, "504"				, NIL },;
    	               	{ "D3_DOC"		, _cDoc				, NIL },;
       	            	{ "D3_FILIAL"	, xFilial( "SD3" )	, NIL },;
                       	{ "D3_LOCAL"	, "01"					, NIL },;
                       	{ "D3_COD"		, SD2->D2_COD			, NIL },;
                       	{ "D3_QUANT"	, SD2->D2_QUANT		, NIL },;
                       	{ "D3_EMISSAO", dDATABASE			, NIL },; 
							{ "D3_OBS"    ,"SAÍDA VD*"			, Nil }}

	MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
	If lMsErroAuto
 		MostraErro()
 		If lConfirm
	 		RollBackSX8()
 			lConfirm	:= .F.
 		EndIf
 		Break
 	Else
 		If lConfirm
 			ConfirmSX8()
 			lConfirm	:= .F.
 		EndIf
 	EndIf
   
   //////////////////////////////////////////////////
   ////NA GRAVAÇÃO DA NF SAÍDA,
   ////EXECUTA UMA MOVIMENTAÇÃO INTERNA
   ////RELATIVA À ENTRADA DE APARA NO LOCAL 03: 
   //////////////////////////////////////////////////
   
   dbSelectArea("SB1")
   SB1->( DbSeek( xFilial("SB1") + If( SubStr( SD2->D2_COD, 3, 1 ) == "B", "188            ", "189            " ) ) )
	
	cCODSECU	:= If( SubStr( SD2->D2_COD, 3, 1 ) == "B", "188            ", "189            " )
	
	DbSelectArea("SD3")
	If !SD3->(dbSeek(xFilial("SD3") + SD2->D2_DOC + cCODSECU))
		_cDoc		:= SD2->D2_DOC
	Else    
		_cDoc		:= GetSxeNum("SD3","D3_DOC")
		lConfirm	:= .T.
	EndIf

	aMATRIZ     := { { "D3_TM"		, "104"					, NIL },;
                    	{ "D3_DOC"		, _cDoc					, NIL },;
                     { "D3_FILIAL"	, xFilial( "SD3" )		, Nil },;
                     { "D3_LOCAL"	, "03"						, NIL },;
                     { "D3_COD"		, cCODSECU					, NIL },; //PRODUTO APARA, CHUMBADO
                     { "D3_QUANT"	, SD2->D2_QUANT * nPESO	, NIL },;
                     { "D3_EMISSAO", dDATABASE				, NIL },;
						{ "D3_OBS"    ,"ENTRADA VD*"			, Nil }}

	MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )

 	If lMsErroAuto
 		MostraErro()
 		If lConfirm
	 		RollBackSX8()
 			lConfirm	:= .F.
 		EndIf
 		Break
 	Else
 		If lConfirm
 			ConfirmSX8()
 			lConfirm	:= .F.
 		EndIf
 	EndIf

EndIf
   
//Restaura as areas
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSD3)
RestArea(aAreaSA1)

Return NIL
