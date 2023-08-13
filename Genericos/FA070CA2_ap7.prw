#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"


/*
//////////////////////////////////////////////////////////////////////////////
//Programa: FA070CA2 - Ponto de entrada no cancelamento da baixa a receber
//Objetivo: Ao cancelar uma baixa a receber, cancelar seu respectivo bônus
//          caso haja
//Autoria : Flávia Rocha - FR
//Data    : 08/06/2011
//////////////////////////////////////////////////////////////////////////////
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SE5FI70E  ³                               ³ Data ³ 11/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cancelamento baixa a receber                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

************************
User Function FA070CA2()
************************ 

Local nRecSE3 := 0
Local nBase   := 0
Local cBonus  := 0
Local nPerc   := 0
Local nValBonus:= 0

SetPrvt("CARQ,NE5ORD,NE5REG,")
     
//SE3->( dbSetOrder( 1 ) )
//SE3->( dbSeek( xFilial( "SE3" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA, .T.  ) )
///LOCALIZA SE3
cQuery := " select top 1  R_E_C_N_O_ AS REGISTRO,* from " + RetSqlName("SE3") + " SE3 " 
cQuery += " where E3_PREFIXO = '" + Alltrim(SE1->E1_PREFIXO) + "' " 
cQuery += " and E3_NUM = '" + Alltrim(SE1->E1_NUM) + "' " 
cQuery += " and E3_PARCELA = '" + Alltrim(SE1->E1_PARCELA) + "' "
cQuery += " and E3_BONUS = 'S' "				    
cQuery += " and E3_FILIAL = '" + xFilial("SE3") + "' " 
cQuery += " and SE3.D_E_L_E_T_ = '' " 
cQuery += " Order BY R_E_C_N_O_ " 
				        
MemoWrite("C:\Temp\LOCALSE3.sql", cQuery)
If Select("SE33") > 0
	DbSelectArea("SE33")
	DbCloseArea()
EndIf
					
TCQUERY cQuery NEW ALIAS "SE33"
TCSetField( 'SE33', "E3_EMISSAO", "D" )
TCSetField( 'SE33', "E3_VENCTO", "D" )
					
SE33->( DBGoTop() )
					
Do While !SE33->( Eof() )
	nRecSE3 := SE33->REGISTRO
	nBase   := SE33->E3_BASE
	cBonus  := SE33->E3_BONUS
	nPerc   := SE33->E3_PORC
	nValBonus:= SE33->E3_COMIS
   						
	DbselectArea("SE33")
	SE33->(Dbskip())
Enddo
DbselectArea("SE33")
DBCLOSEAREA()

DbselectArea("SE3")  
SE3->(Dbgotop())
If nRecSE3 > 0
	DbGoTo(nRecSE3)
	RecLock("SE3", .F.)
	SE3->(DbDelete())    
	SE3->(MsUnLock() )
	
	///envia e-mail avisando que cancelou o bônus
	/*			         	
   	cMailTo := "flavia.rocha@ravaembalagens.com.br"
   	cCopia  := ""
   	cCorpo	:= "Rotina: FA070CA2 - CANC.BAIXA" + CHR(13) + CHR(10)					
   	cCorpo	+= "Nesta data: " + Dtoc(dDatabase) + CHR(13) + CHR(10)					
	cCorpo  += " Baixa cancelada para o titulo: " + SE1->E1_NUM + CHR(13) + CHR(10)
	cCorpo  += " Prefixo: " + SE1->E1_PREFIXO + CHR(13) + CHR(10)
	cCorpo  += " Parcela: " + SE1->E1_PARCELA + CHR(13) + CHR(10)
	cCorpo  += " Tem Bonus: "   + cBonus     + CHR(13) + CHR(10)   
	cCorpo  += " Base Bonus: "  + str(nBase) + CHR(13) + CHR(10)
	cCorpo  += " % Bonus: "     + str(nPerc) + CHR(13) + CHR(10)
	cCorpo  += " Valor Bonus: " + str(nValBonus) + CHR(13) + CHR(10)
	cAnexo := ""
	cAssun  := "BX Cancelada TITULO/PREFIXO/PARCELA: " + SE1->E1_NUM + "/" + SE1->E1_PREFIXO + "/" + SE1->E1_PARCELA
	U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
	*/	
Endif


If SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO $ "UNI/0  "
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Cancelamento baixa titulo - Rava                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If Select( "XE1" ) == 0
      cArq := "SE1010"
      Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 XE1->( DbSetOrder( 1 ) )
   XE1->( dbSeek( xFilial( "SE1" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ) )
   If XE1->( !Eof() ) .and. XE1->E1_PREFIXO+XE1->E1_NUM+XE1->E1_PARCELA+XE1->E1_TIPO == ;
                            SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+XE1->E1_TIPO

      XE1->( MsUnlock() )
      XE1->( dbCommit() )
      dbSelectarea("XE1")
      RecLock( "XE1", .f. )
      XE1->E1_MOVIMEN := SE1->E1_MOVIMEN; XE1->E1_SALDO   := SE1->E1_SALDO
      XE1->E1_BAIXA   := SE1->E1_BAIXA  ; XE1->E1_OCORREN := SE1->E1_OCORREN
      XE1->E1_STATUS  := SE1->E1_STATUS ; XE1->E1_OK      := SE1->E1_OK
      XE1->E1_DESCONT := SE1->E1_DESCONT; XE1->E1_MULTA   := SE1->E1_MULTA
      XE1->E1_JUROS   := SE1->E1_JUROS  ; XE1->E1_VALLIQ  := SE1->E1_VALLIQ
      XE1->E1_CORREC  := SE1->E1_CORREC
      XE1->( MsUnlock() )
      XE1->( dbCommit() )
   endif
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ SE5 - Cancelamento baixa - Rava                              ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If Select( "XE5" ) == 0
      cArq := "SE5010"
      Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   nE5Ord := SE5->( dbSetOrder() )
   nE5Reg := SE5->( Recno() )

   XE5->( dbSetOrder( 2 ) )
   SE5->( dbSetOrder( 7 ) )
   SE5->( dbSeek( xFilial( "SE5" ) + SE1->E1_PREFIXO + SE1->E1_NUM ) )

   while SE5->E5_PREFIXO + SE5->E5_NUMERO == SE1->E1_PREFIXO + SE1->E1_NUM .and. SE5->( !Eof() )
      XE5->( dbSeek( xFilial( "SE5" ) +;
                     SE5->E5_TIPODOC +;
                     SE5->E5_PREFIXO +;
                     SE5->E5_NUMERO +;
                     SE5->E5_PARCELA +;
                     SE5->E5_TIPO +;
                     Dtos( SE5->E5_DATA ) +;
                     SE5->E5_CLIFOR +;
                     SE5->E5_LOJA +;
                     SE5->E5_SEQ ) )
      if XE5->( !Eof() )
         RecLock( "XE5", .f. )
         XE5->( dbDelete() )
         XE5->( MsUnlock() )
         XE5->( dbCommit() )
      endif
      SE5->( dbSkip() )
   end
   // dbCommitall()
   //SE5->( dbSetOrder( nE5Ord ) )
   SE5->( dbSetOrder( 1 ) )
   SE5->( dbGoto( nE5Reg ) )
endif

Return

      