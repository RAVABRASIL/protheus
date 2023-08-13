#INCLUDE "rwmake.ch"
#INCLUDE "topconn.CH"
#INCLUDE "PROTHEUS.CH"
#include "PRTOPDEF.CH"

/*
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Emmanuel Lacerda                         ³ Data ³ 01/12/06 ³±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descricao³ Ponto de entrada para produtos comprados pela rava que     ³±±
±±³         ³ atualiza o campo B1_UPRC(ultimo preco de comrpa) do mesmo  ³±±
±±³         ³ com a media das ultimas quatro compras juntamente com o    ³±±
±±³         ³ valor do frete.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Documentos de Entrada - Compras                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

//***************************************************************************
// Ponto de Entrada 
// Alterado por: Flávia Rocha  / Data 02/03/2010  
// Descricao -> Ponto de entrada executado no final da inclusão e exclusão
//				de Docs de entrada, quando todas as informações	ja foram gravadas 
//              (MATA103) 
// Objetivo: Acrescentar ao PE, forma para classificar as notas de devolução
//			 de acordo com motivo especificado pelo usuário.
//***************************************************************************
*/



*************

User Function MT100AGR()

*************


Local cCodMoti := ""
Local cMotivo  := ""
Local nOpcao   := 0 
Private oDlg1  

/*
Local nORDSD1 := SD1->( IndexOrd() ) //guardar o indice da SD1
Local nORDSB1 := SB1->( IndexOrd() ) //guardar o indice da SB1
Local cAlias  := Alias() //guardar o alias sendo utilizado antes do P.E.
Local cDOCUM  := SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

SB1->( DbSetorder( 1 ) )
SD1->( DbSetorder( 1 ) )
SD1->( DbSeek( xFilial( "SD1" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, .T. ) )
Do While SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cDOCUM
	//If SD1->D1_TES IN ('001', '010', '012', '015', '024', '132', '137') AND SD1->D1_TIPO = 'N'//substr(SD1->D1_COD,1,2) $ "AC /MH /ST /ME"
  If SB1->( dbSeek( xFilial( "SB1" ) + SD1->D1_COD, .T. ) )
  	If RecLock( "SB1", .F. )
   		SB1->B1_UPRC := U_CALPREAC( SD1->D1_COD, 1 )
   		SB1->( MsUnlock() )
   		SB1->( DBCommit() )
  	Else
  	  MsgAlert( "Nao foi possivel travar o registro do produto: " + alltrim( SD1->D1_COD ) + "Preco nao atualizado!!!" )
  	EndIf
	Else
	  MsgAlert( "Nao foi possivel encontrar o registro do produto: " + alltrim( SD1->D1_COD ) + "Preco nao atualizado!!!" )
	EndIf
  SD1->( DbSkip() )
EndDo

SB1->( DbSetorder( nORDSB1 ) ) //retornando os indices
SD1->( DbSetorder( nORDSD1 ) ) //retornando os indices
DbSelectArea( cAlias ) //retornando o alias
*/

//     SX5->(DbSeek(xFilial("SX5")+'MO'+ SF1->F1_CODMOTI  ) )


If Inclui

	If SF1->F1_TIPO = "D"
	 	
		DEFINE MSDIALOG oDlg1 FROM 050,050 TO 245,590 TITLE "NOTA DE DEVOLUÇÃO - Escolha o motivo da Devolução" PIXEL
		@ 005,007 SAY "Código Motivo:"	 OF oDlg1 PIXEL 
		@ 012,003 TO 031,252 OF oDlg1 PIXEL
		@ 017,007 MSGET cCodMoti			 WHEN .T. /*PICTURE PesqPict("SUD","UD_DTEFETI")*/  F3 "MO"	OF oDlg1 SIZE 040,006 PIXEL		
		
		//SX5->(DbSeek(xFilial("SX5")+'MO'+ cCodMoti  ) )			
		//cMotivo := SX5->X5_DESCRI
		@ 005,157 SAY "Descrição Motivo:"  OF oDlg1 PIXEL 
		@ 017,157 MSGET GetAdvFVal("SX5","X5_TABELA",xFilial("SX5") + 'MO' + cCodMoti,1,0) WHEN .F. SIZE 46, 27 OF oDlg1 PIXEL		
			
			
		DEFINE SBUTTON FROM 055,177 TYPE 1  ENABLE OF oDlg1 ACTION (nOpcao := 1,oDlg1:End())	//botão OK
		//DEFINE SBUTTON FROM 208,260 TYPE 2  ENABLE OF oDlg6 ACTION (nOK2 := 0,oDlg6:End())	//botão Cancela
			
		ACTIVATE MSDIALOG oDlg1 CENTERED
		
		If nOpcao == 1			
				
				RecLock("SF1",.F.)
				SF1->F1_MOTIVOD	:= cCodMoti
				SF1->(MsUnLock())
		        MSGBOX("Motivo gravado com Sucesso!")			
		
		EndIf	
    Endif
Endif



Return 