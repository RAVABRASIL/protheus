#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "TbiConn.ch"

User Function REPLICA()

SetPrvt( "CARQ,CCONTEUDO,ODLG,oSBtn1,oSBtn2,oSAY1,oSay2,cSCRIPT," )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio Barros                          ³ Data ³ 02/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Replicador de arquivos p/ Rava 01                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

lWindow := .F.

If Select( 'SX2' ) == 0  //Testa se esta sendo executado pelo menu ou pelo Workflow
	RPCSetType( 3 )  //Nao consome licensa de uso
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MAILREP" Tables "SF2", "SA1", "SA3", "SA4", "SE1"  //Prepara a empresa caso uso pelo Workflow
	Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
	OkReplica()
Else
	conOut( "Programa REPLICA sendo executado pelo MENU ou com erro." )

	If cEMPANT <> "02"
	   MsgStop( "Rotina nao pode ser executada na empresa '01'", "Atenção" )
		 Return NIL
	EndIf

	@ 00,000 To 50,300 Dialog oDlg1 Title "Funcao no WORKFLOW - Replica de Dados"
	@ 10,040 BMPBUTTON Type 1 Action Processa( { |lEnd| OkReplica() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
	@ 10,080 BMPBUTTON Type 2 Action Close( oDlg1 )
	lWindow := .T.
	Activate Dialog oDlg1 Center
	Return


EndIf

/*
If cEMPANT <> "02"
   MsgStop( "Rotina nao pode ser executada na empresa '01'", "Atenção" )
	 Return NIL
EndIf

@ 00,000 To 50,300 Dialog oDlg1 Title "Replica de Dados"
@ 10,040 BMPBUTTON Type 1 Action Processa( { |lEnd| OkReplica() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,080 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return
*/

***************

Static Function OkReplica

***************

	conOut( " " )
	conOut( "---------------------------------------------------------------------------" )
	conOut( "---------------------------------------------------------------------------" )
	conOut( "---------------------------------------------------------------------------" )
	conOut( "Programa de REPLICACAO entre empresas iniciado as " + DtoC( Date() ) + " - " + Time() )
	conOut( "---------------------------------------------------------------------------" )
	conOut( "---------------------------------------------------------------------------" )
	conOut( "---------------------------------------------------------------------------" )
	conOut( " " )

cSCRIPT := ""
procregua( 8 )

//If ! ReplAppend( "SF1010", "F1_SERIE = 'UNI'" )
//If ! ReplAppend( "SF1010", "F1_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SF1010", "F1_SERIE <> '' " )
	 Return NIL
EndIF

//If ! ReplAppend( "SD1010", "D1_SERIE = 'UNI'" )
//If ! ReplAppend( "SD1010", "D1_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SD1010", "D1_SERIE <> '' " )
	 Return NIL
EndIF

//If ! ReplAppend( "SF2010", "F2_SERIE = 'UNI'" )
//If ! ReplAppend( "SF2010", "F2_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SF2010", "F2_SERIE <> '' " )
	 Return NIL
EndIF

//If ! ReplAppend( "SD2010", "D2_SERIE = 'UNI'" )
//If ! ReplAppend( "SD2010", "D2_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SD2010", "D2_SERIE <> '' " )
	 Return NIL
EndIF

//Incluido por Eurivan  em 08/02/2008
//If ! ReplAppend( "SF3010", "F3_SERIE = 'UNI'" )
//If ! ReplAppend( "SF3010", "F3_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SF3010", "F3_SERIE <> '' " )
	 Return NIL
EndIF


//Incluido por Eurivan em 29/03/12
//If ! ReplAppend( "CD2010", "CD2_SERIE IN ('UNI','0') " )
If ! ReplAppend( "CD2010", "CD2_SERIE <> '' " )
	Return NIL
EndIF


//Incluido por Eurivan em 28/02/11
//If ! ReplAppend( "SFT010", "FT_SERIE IN ('UNI','0') " )
If ! ReplAppend( "SFT010", "FT_SERIE <> '' " )
	Return NIL
EndIF

//FR - Incluído por Flávia Rocha em 13/11/13
If ! ReplAppend( "SF9010", "" )
	Return NIL
EndIF

//If ! ReplAppend( "SE1010", "(E1_PREFIXO = 'UNI' OR (E1_PORTADO = '001' AND E1_AGEDEP = '31658') OR (E1_PORTADO = '001' AND E1_AGEDEP = '43621') OR (E1_PORTADO = '004' AND E1_AGEDEP = '0185 ' AND E1_CONTA = '20050-8   ') OR (E1_PORTADO = '356' AND E1_AGEDEP = '1181 '))" )
//If ! ReplAppend( "SE1010", "(E1_PREFIXO IN ('UNI','0') OR (E1_PORTADO = '001' AND E1_AGEDEP = '31658') OR (E1_PORTADO = '001' AND E1_AGEDEP = '43621') OR (E1_PORTADO = '004' AND E1_AGEDEP = '0185 ' AND E1_CONTA = '20050-8   ') OR (E1_PORTADO = '356' AND E1_AGEDEP = '1181 '))" )
If ! ReplAppend( "SE1010", "(E1_PREFIXO <> '' OR (E1_PORTADO = '001' AND E1_AGEDEP = '31658') OR (E1_PORTADO = '001' AND E1_AGEDEP = '43621') OR (E1_PORTADO = '004' AND E1_AGEDEP = '0185 ' AND E1_CONTA = '20050-8   ') OR (E1_PORTADO = '356' AND E1_AGEDEP = '1181 '))" )
	 Return NIL
EndIF

//If ! ReplAppend( "SE2010", "E2_PREFIXO = 'UNI'" )
//If ! ReplAppend( "SE2010", "E2_PREFIXO IN ('UNI','0') " )
If ! ReplAppend( "SE2010", "E2_PREFIXO <> '' " )
	 Return NIL
EndIF

//If ! ReplAppend( "SE5010", "(E5_PREFIXO = 'UNI' OR (E5_BANCO = '001' AND E5_AGENCIA = '31658') OR (E5_BANCO = '001' AND E5_AGENCIA = '43621') OR (E5_BANCO = '004' AND E5_AGENCIA = '0185 ' AND E5_CONTA = '20050-8   ') OR (E5_BANCO = '356' AND E5_AGENCIA = '1181 '))" )
//If ! ReplAppend( "SE5010", "(E5_PREFIXO IN ('UNI','0') OR (E5_BANCO = '001' AND E5_AGENCIA = '31658') OR (E5_BANCO = '001' AND E5_AGENCIA = '43621') OR (E5_BANCO = '004' AND E5_AGENCIA = '0185 ' AND E5_CONTA = '20050-8   ') OR (E5_BANCO = '356' AND E5_AGENCIA = '1181 '))" )
If ! ReplAppend( "SE5010", "(E5_PREFIXO <> '' OR (E5_BANCO = '001' AND E5_AGENCIA = '31658') OR (E5_BANCO = '001' AND E5_AGENCIA = '43621') OR (E5_BANCO = '004' AND E5_AGENCIA = '0185 ' AND E5_CONTA = '20050-8   ') OR (E5_BANCO = '356' AND E5_AGENCIA = '1181 '))" )
	Return NIL
EndIF

If ! ReplAppend( "SE8010", "((E8_BANCO = '001' AND E8_AGENCIA = '31658') OR (E8_BANCO = '001' AND E8_AGENCIA = '43621') OR (E8_BANCO = '004' AND E8_AGENCIA = '0185 ' AND E8_CONTA = '20050-8   ') OR (E8_BANCO = '356' AND E8_AGENCIA = '1181 '))" )
	Return NIL
EndIF

//MemoWrit( "REPLICA.SQL", cSCRIPT )

If lWindow
	Close( oDlg1 )
EndIf

conOut( " " )
conOut( " ----------------------------------------------------------------------- " )
conOut( "| Programa de REPLICACAO entre empresas FINALIZADO as " + DtoC( Date() ) + " - " + Time() + " |" )
conOut( " ----------------------------------------------------------------------- " )
conOut( " " )

Return



*************

User Function ABREIND( cARQ )

*************

SIX->( DbSeek( Left( cARQ, 3 ) ) )
Do While SIX->INDICE == Left( cARQ, 3 )
//	 MsOpenIdx( cARQ + SIX->ORDEM , AllTrim( Upper( SIX->CHAVE ) ), cARQ,, "TOPCONN" )
   DbSetIndex( cARQ + SIX->ORDEM )
	 SIX->( DbSkip() )
EndDo
Return NIL



*****************************************
Static Function REPLAPPEND( cARQ, cCOND )
*****************************************

Local aSTRU, nMAX, cSTRU, nRECNO

lBACK  := .T.
cALIAS := "X" + SubStr( cARQ, 2, 2 )
nMax   := ( Left( cARQ, 3 ) )->( LastRec() ) + 200
If TCSqlExec( "TRUNCATE TABLE " + cArq ) < 0
   ConOut("Erro ao Apagar Tabela "+cArq)
   MsgStop( "Erro na abertura de " + cArq + " replicacao nao realizada!", "Atenção" )
   Return .F.
EndIf
If Select( cALIAS ) <> 0
   (cALIAS)->( DbCloseArea() )
EndIf
Use ( cArq ) Alias ( cALIAS ) Via "TOPCONN" New Exclusive
If NetErr()
   ConOut("Erro ao Abrir Tabela "+cArq+" em Modo Exclusivo." )
   MsgStop( "Erro na abertura de " + cArq + " replicacao nao realizada!", "Atenção" )
   Return .F.
EndIf
aStru := ( cALIAS )->( DbStruct() )
( cALIAS )->( DbCloseArea() )
cStru := ""
For i := 1 To Len( aStru )
   cStru += AStru[ i, 1 ] + ","
Next i
nRECNO  := 0
cStru   += "D_E_L_E_T_,R_E_C_N_O_"
cSelect := "SELECT " + cStru + " FROM " + Left( cARQ, 3 ) + cEMPANT + "0"
Do While nRecno < nMax
   nRecno    += 1024
   cSelWhere := cSELECT + " WHERE R_E_C_N_O_ > " + Str( nRecno - 1024 ) + " AND R_E_C_N_O_ <= " + Str( nRecno )
   If !Empty(cCOND)
   	cSelWhere += " and " + cCOND + " AND D_E_L_E_T_=' '"
   Else
   	cSelWhere += " and D_E_L_E_T_=' '"
   Endif
   cSCRIPT   := "INSERT INTO " + cARQ + " (" + cStru + ") (" + cSelWhere + ")"
   lBack     := ( TCSqlExec( cSCRIPT ) == 0 )
End
INCPROC()
Return lBACK
