#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKBARLA  ºAutor  ³Eurivan Marques     º Data ³  13/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere botões na barra lateral na tela de atendimento.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CallCenter                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
***************************************
User Function TMKBARLA(aBtnLat,aTitles)
***************************************

local aBtns := {}

Aadd( aBtnLat, {"PRODUTO",{||NFS()},"Notas Fiscais","Notas Fiscais"  })
//Aadd( aBtnLat, {"VENDEDOR",{||fINFORECBTO()},"Informações Cliente","Info Cliente"  })
Aadd( aBtnLat, {"VENDEDOR",{|| KBARLASAC()},"Informações SAC","SAC"  })

return aBtnLat


*****************************
static Function NFS()         
*****************************


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local oVerd
Local oVerm
Local oAzul
Local oPreto
Local oBranco

Private coTbl1
Private cPesquisa  := Space(15)
Private dNovaCheg:= CtoD("  /  /    ") 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oSay1","oGet1","oCBox1","oBtn1","oBtn2","oBtn3")



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1 := MSDialog():New( 126,254,601,950,"Consulta Nota Fiscal",,,.F.,,,,,,.T.,,,.F. )
oTbl1()


fGetNFs( Alltrim(SU6->U6_ENTIDA), Alltrim(SU6->U6_CODENT) , (SU6->U6_DATA-1) , (SU6->U6_DATA-1), (SU6->U6_NFISCAL), (SU6->U6_SERINF),;
 (SU6->U6_TRANSP), (SU6->U6_REDESP)  )

cNF := SU6->U6_NFISCAL

DbSelectArea("TMPFR")


/* //MsSelect ORIGINAL
oBrw1 := MsSelect():New( "TMPFR","","",{{"DOC","","Nota Fiscal",""},;
                                      {"SERIE","","Serie",""},;
                                      {"EMISSAO","","Emissao",""},;
                                      {"TRANSP","","Transportadora",""},;
                                      {"REDESP","","Redesp?",""},;
                                      {"PENTREG","","Prazo de Entrega",""}},.F.,,;
                                      {036,004,228,289},,, oDlg1 )   //228,269 
*/

/*
oBrw1 := MsSelect():New( "TMPFR","","DOC",{{"DOC","","Nota Fiscal",""},;
                                      {"SERIE","","Serie",""},;
                                      {"EMISSAO","","Emissao",""},;
                                      {"TRANSP","","Transportadora",""},;
                                      {"REDESP","","Redesp?",""},;
                                      {"PENTREG","","Prazo de Entrega",""}},.F.,,;
                                      {036,004,228,289},,, oDlg1 )   //228,269
*/ // neste msselect, traz uma bolinha vermelha em todas as linhas                                       


oVerd       := LoadBitmap( GetResources(), "BR_VERDE" )
oVerm       := LoadBitmap( GetResources(), "BR_VERMELHO" )
oAzul       := LoadBitmap( GetResources(), "BR_AZUL" )
oPreto      := LoadBitmap( GetResources(), "BR_PRETO" )
oBranco     := LoadBitmap( GetResources(), "BR_BRANCO" )



oBrw1 := MsSelect():New( "TMPFR","AT","DOC",{{"DOC","","Nota Fiscal",""},;
                                      {"SERIE","","Serie",""},;
                                      {"EMISSAO","","Emissao",""},;
                                      {"TRANSP","","Transportadora",""},;
                                      {"REDESP","","Redesp?",""},;
                                      {"PENTREG","","Prazo de Entrega",""}},.F.,,;
                                      {036,004,228,289},,, oDlg1 )   //228,269 
                                      
//oBrw1:oBrowse:acolumns[1]:lbitmap 	:= .T.                         
//oBrw1:oBrowse:acolumns[1]:lnolite 	:= .T.
//oBrw1:oBrowse:acolumns[1]:ledit 	:= .F.     
//oBrw1:oBrowse:acolumns[1]:bdata 	:= { |n| iif( Empty( cNF ) , oBranco, Iif( TMPFR->DOC == cNF , oVerm, oVerd ))}

                       
oGrp1 := TGroup():New( 003,004,031,328,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1 := TSay():New( 014,010,{||"Pesquisar"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1 := TGet():New( 013,110,,oGrp1,159,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesquisa",,)
oGet1:bSetGet := {|u| If(PCount()>0,cPesquisa:=u,cPesquisa)}

oCBox1 := TComboBox():New( 013,050,,{"Nota Fiscal+Serie","Emissão"},056,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1:bChange := {||CBChange()}

oBtn1 := TButton():New( 012,274,"Buscar",oGrp1,,045,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||Pesq()}

oBtn2 := TButton():New( 036,295,"Visualizar",oDlg1,,044,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||U_VisualNF(TMPFR->DOC,TMPFR->SERIE,TMPFR->CLIENTE,TMPFR->LOJA,TMPFR->TIPO)}

//oBtn99 := TButton():New( 108,295,"Danfe",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
oBtn99 := TButton():New( 084,295,"Danfe",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
//oBtn99:bAction := {|| SPEDDANFE() }   //dá erro no afilbrw        //não deu certo
//oBtn99:bAction := {|| fSPEDDANFE() }   //fiz esta nova, mas não tenho o objeto   //não deu certo
oBtn99:bAction := {|| SPEDNFE() }     //função padrão, DEU CERTO
  

//oBtn3 := TButton():New( 084,295,"Fechar",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
oBtn3 := TButton():New( 108,295,"Fechar",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
oBtn3:bAction := {||oDlg1:End()}


If SU6->U6_ENTIDA = "SA4"
	oBtn4 := TButton():New( 052,295,"Atendimento",oDlg1,,044,012,,,,.T.,,"",,,,.F. )
	oBtn4:bAction := {||U_VerAtend( TMPFR->DOC,TMPFR->SERIE, TMPFR->CLIENTE )}
Endif

oBtn5 := TButton():New( 068,295,"Espelho NF",oDlg1,,044,012,,,,.T.,,"",,,,.F. )
oBtn5:bAction := {||U_ImprimeNF(TMPFR->DOC,TMPFR->SERIE,TMPFR->CLIENTE,TMPFR->LOJA )}


oDlg1:Activate(,,,.T.)

TMPFR->(DbCloseArea())
Ferase(coTbl1+".DBF")
Ferase(coTbl1+OrdBagExt())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

//Aadd( aFds, {"AT"      ,"C",001,000} )
Aadd( aFds, {"DOC"     ,"C",009,000} )
Aadd( aFds, {"SERIE"   ,"C",003,000} )
Aadd( aFds, {"EMISSAO" ,"D",008,000} )
Aadd( aFds, {"CLIENTE" ,"C",006,000} )
Aadd( aFds, {"LOJA"    ,"C",002,000} )
Aadd( aFds, {"TIPO"    ,"C",001,000} )
Aadd( aFds, {"TRANSP"  ,"C",030,000} )
Aadd( aFds, {"REDESP"  ,"C",001,000} )
Aadd( aFds, {"PENTREG" ,"D",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMPFR New Exclusive
Index On DOC + SERIE To ( coTbl1 )

Return 


************************************************************************************************
Static Function fGetNFs( cNomEntidad, cCodent, _dDe_ , _dAte_ , cNF, cSERINF, cTransp, cRedesp )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SF2X"
Local dDataCheg := CtoD("  /  /    ")
Local nZZPrazo  := 0
Local cA4Cod    := ""
Local cA4DiaTrab:= ""
Local cA4Nreduz := ""
Local aCols		:= {}

Private dRealChg 	:= CtoD("  /  /    ")

If Empty( _dDe_ )
	_dDe_ := _dAte_
Endif

If cNomEntidad = "SA4"
		cQuery := " SELECT F2_REDESP, F2_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO, F2_LOCALIZ, F2_UFCHG,"
		cQuery += " F2_VALBRUT, F2_DTEXP, F2_REALCHG, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE "
		cQuery += " FROM SF2020 SF2, SA4010 SA4, SZZ010 SZZ "
		cQuery += " WHERE "
	If Empty( cRedesp )
		cQuery += " RTRIM(F2_TRANSP) = '" + Alltrim( cCodent )  +"' "
		cQuery += " AND RTRIM( F2_TRANSP ) = RTRIM( A4_COD ) " 
		cQuery += " AND RTRIM( F2_TRANSP ) = RTRIM( ZZ_TRANSP ) "
		//cQuery += " and  F2_EMISSAO >= '" + DtoS( _dDe_ ) + "' AND SF2.F2_EMISSAO <= '" + Dtos(_dAte_) + "' "
		cQuery += " AND F2_DTEXP >= '20091117' "
		//cQuery += " AND F2_REALCHG = '' "
		cQuery += " AND F2_TIPO = 'N' "
		cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "
		cQuery += " AND SF2.F2_SERIE != ' ' "
		cQuery += " and SF2.D_E_L_E_T_ = ' '  "
		cQuery += " and SA4.D_E_L_E_T_  = ' ' "
		cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
		cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
		cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "
		cQuery += " and ZZ_FILIAL = '" + xFilial("SZZ") + "' "
		cQuery += " GROUP BY F2_REDESP, F2_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO, F2_LOCALIZ, F2_UFCHG, "
		cQuery += " F2_VALBRUT, F2_DTEXP, F2_REALCHG, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE "
		cQuery += " order by F2_EMISSAO, F2_DOC "
	Else
		cQuery += " RTRIM(F2_REDESP) = '" + Alltrim( cCodent )  +"' "
		cQuery += " AND RTRIM( F2_REDESP ) = RTRIM( A4_COD ) " 
		cQuery += " AND RTRIM( F2_REDESP ) = RTRIM( ZZ_TRANSP ) "
		//cQuery += " and  F2_EMISSAO >= '" + DtoS( _dDe_ ) + "' AND SF2.F2_EMISSAO <= '" + Dtos(_dAte_) + "' "
		cQuery += " AND F2_DTEXP >= '20091117' "
		//cQuery += " AND F2_REALCHG = '' "
		cQuery += " AND F2_TIPO = 'N' "
		cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "
		cQuery += " AND SF2.F2_SERIE != ' ' "
		cQuery += " and SF2.D_E_L_E_T_ = ' '  "
		cQuery += " and SA4.D_E_L_E_T_  = ' ' "
		cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
		cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
		cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "
		cQuery += " and ZZ_FILIAL = '" + xFilial("SZZ") + "' "
		cQuery += " GROUP BY F2_REDESP, F2_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO, F2_LOCALIZ, F2_UFCHG, "
		cQuery += " F2_VALBRUT, F2_DTEXP, F2_REALCHG, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE "
		cQuery += " order by F2_EMISSAO, F2_DOC "
	Endif

Elseif cNomEntidad = "SA1"  

	cQuery := " SELECT F2_REDESP, F2_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO,F2_LOCALIZ, F2_UFCHG, "
	cQuery += " F2_VALBRUT, F2_DTEXP, F2_REALCHG, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE "
	cQuery += " FROM SF2020 SF2, SA4010 SA4, SZZ010 SZZ "
	cQuery += " WHERE RTRIM(F2_CLIENTE) = '" + Alltrim(Substr( cCodent,1,6 ) )  +"' "
	cQuery += " AND F2_DTEXP >= '20091117' "
	cQuery += " AND F2_DOC  = '" + cNF + "' "
	cQuery += " AND F2_SERIE  = '" + cSERINF + "' "
	//cQuery += " AND F2_REALCHG = '' "
	cQuery += " AND RTRIM( F2_TRANSP ) = RTRIM( A4_COD ) " 
	cQuery += " AND RTRIM( F2_TRANSP ) = RTRIM( ZZ_TRANSP ) "
	cQuery += " AND F2_TIPO = 'N' "
	cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "
	cQuery += " AND SF2.F2_SERIE != ' ' "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "
	cQuery += " and ZZ_FILIAL = '" + xFilial("SZZ") + "' "
	cQuery += " GROUP BY F2_REDESP, F2_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO,F2_LOCALIZ, F2_UFCHG, "
	cQuery += " F2_VALBRUT, F2_DTEXP, F2_REALCHG, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE "
	cQuery += " ORDER by F2_EMISSAO, F2_DOC "
Endif
MemoWrite("C:\Temp\NFTRANS.SQL",cQuery)

If Select("SF2X") > 0
	DbSelectArea("SF2X")
	DbCloseArea()	
EndIf 

// Cria tabela temporaria
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")

TCSetField( cAlias, "F2_EMISSAO", "D")
TCSetField( cAlias, "F2_DTEXP", "D")
TCSetField( cAlias, "F2_REALCHG", "D")
TCSetField( cAlias, "F2_UFCHG", "D")

dDataCheg 	:= CtoD("  /  /    ")

dDtExp    	:= CtoD("  /  /    ")
cA4Cod    	:= ""
cA4Diatrab	:= ""
cA4Nreduz 	:= ""
nZZPrazo  	:= 0
cLocal    	:= ""
cTransp1	:= ""
nLin		:= 0



SF2X->(Dbgotop())
While ! SF2X->(EOF())
   
   //cRedesp := Alltrim( SF2X->F2_REDESP )
   dDtExp  		:= SF2X->F2_DTEXP
   nZZPrazo		:= SF2X->ZZ_PRZENT
   dRealChg		:= SF2X->F2_REALCHG
   cA4Diatrab	:= SF2X->A4_DIATRAB
   cA4Nreduz	:= SF2X->A4_NREDUZ
               
     
   If !Empty( cRedesp )  		
	    
	    cLocal		:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
     	cTransp1	:= "47    "		//Irá pegar o prazo da ALD para o redespacho para Recife
     	SZZ->(Dbsetorder(1))
       	If SZZ->(Dbseek(xFilial("SZZ") + cTransp1 + cLocal ))
       		nZZPrazo += SZZ->ZZ_PRZENT
       		dDataCheg := U_Calprv( dDtExp , cA4DiaTrab, nZZPrazo )
       	Endif	       	
   Else   
   		dDataCheg	  := U_CalPrv( dDtExp, cA4Diatrab, nZZPrazo )  //PARA LIGAR DE NOVO, ESTE PRAZO + 1 DIA
                
   Endif   
   
   If cNomEntidad = "SA4"
	   If Empty(dRealChg) .or. dRealChg >= dDatabase
	   		RecLock("TMPFR",.T.)	   		
	   		TMPFR->DOC     := SF2X->F2_DOC
	   		TMPFR->SERIE   := SF2X->F2_SERIE
	   		TMPFR->EMISSAO := SF2X->F2_EMISSAO      
	   		TMPFR->CLIENTE := SF2X->F2_CLIENTE
	   		TMPFR->LOJA    := SF2X->F2_LOJA
	   		TMPFR->TIPO    := SF2X->F2_TIPO
	   		TMPFR->TRANSP := cA4Nreduz
	   		If !Empty( cRedesp )	   		  	
	   		  	TMPFR->REDESP := "S"
	   		Endif
			TMPFR->PENTREG := dDataCheg
	  		TMPFR->(MsUnLock())
	   Endif
   
   Else   	     		
 
   		RecLock("TMPFR",.T.)   		
   		TMPFR->DOC     := SF2X->F2_DOC
   		TMPFR->SERIE   := SF2X->F2_SERIE
   		TMPFR->EMISSAO := SF2X->F2_EMISSAO      
   		TMPFR->CLIENTE := SF2X->F2_CLIENTE
   		TMPFR->LOJA    := SF2X->F2_LOJA
   		TMPFR->TIPO    := SF2X->F2_TIPO
   		If !Empty(cRedesp)   		  	
   		  	TMPFR->REDESP := "S"   	
		Endif
		TMPFR->TRANSP := cA4Nreduz
		TMPFR->PENTREG := dDataCheg
  		TMPFR->(MsUnLock())
  Endif    
   

   SF2X->(DbSkip())
Enddo

TMPFR->(DbGoTop())
SF2X->(DbCloseArea())

Return


****************************
Static Function CBChange()
****************************

   if oCBox1:nAt = 1
      Index On DOC + SERIE To ( coTbl1 )
   else
      Index On DTOS(EMISSAO) To ( coTbl1 )
   endif          
Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Pesq()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function Pesq()

if oCBox1:nAt = 1
   TMPFR->(DbSeek(cPesquisa,.T.))
else
   TMPFR->(DbSeek(Dtos(Ctod(cPesquisa)),.T.))
endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Mc090Visual³ Autor ³ Edson Maricate       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para visualizacao de NF de Saida.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void Mc090Visual(ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Opcao da Mbrowse                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VisualNF(cDoc,cSerie,cCliente,cLoja,cTipo)

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local aAreaSD2 := SD2->(GetArea())

Local lQuery    := .F.
Local cAliasSD2 := "SD2"
Local cQuery    := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a pilha da funcao fiscal                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()

dbSelectArea("SF2")
dbSetOrder(2)
DbSeek(xFilial("SF2")+cCliente+cLoja+cDoc+cSerie)

dbSelectArea("SD2")
dbSetOrder(3)
	

cAliasSD2 := CriaTrab(,.F.)
cQuery := "SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_TIPO,R_E_C_N_O_ SD2RECNO "
cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
cQuery += "SD2.D2_DOC='"+cDoc+"' AND "
cQuery += "SD2.D2_SERIE='"+cSerie+"' AND "
cQuery += "SD2.D2_CLIENTE='"+cCliente+"' AND "
cQuery += "SD2.D2_LOJA='"+cLoja+"' AND "
cQuery += "SD2.D2_TIPO='"+cTipo+"' AND "
cQuery += "SD2.D_E_L_E_T_=' ' "
cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
	SF2->F2_DOC == (cAliasSD2)->D2_DOC .And.;
	SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
	SF2->F2_CLIENTE == (cAliasSD2)->D2_CLIENTE .And.;
	SF2->F2_LOJA == (cAliasSD2)->D2_LOJA
	If SF2->F2_TIPO == (cAliasSD2)->D2_TIPO
		SD2->(MsGoto((cAliasSD2)->SD2RECNO))
		A920NFSAI("SD2",SD2->(RecNo()),0)
		Exit
	EndIf
	dbSelectArea(cAliasSD2)
	dbSkip()
EndDo

dbSelectArea(cAliasSD2)
dbCloseArea()
dbSelectArea("SD2")	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a pilha da funcao fiscal                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisRestore()
RestArea(aAreaSD2)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aArea)

Return (.T.)

*********************************************************
User Function ImprimeNF(cDoc,cSerie,cCliente,cLoja ) 
*********************************************************

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local aAreaSF2 := SF2->(GetArea())

Local lQuery    := .F.
Local cAliasSF2 := "SF2"
Local cQuery    := ""
Local nRecno	:= 0
Local lAchou	:= .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a pilha da funcao fiscal                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()

dbSelectArea("SF2")
dbSetOrder(1)
If DbSeek(xFilial("SF2")+ cDoc + cSerie + cCliente + cLoja)
	nRecno := RECNO()
	lAchou := .T.

Else
	MsgAlert("Nota Fiscal não localizada! ==> " + cDoc + "/" + cSerie )

Endif

If lAchou
	U_FATR002('SF2', nRecno )
Endif

	



dbSelectArea(cAliasSF2)
dbCloseArea()
dbSelectArea("SF2")	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a pilha da funcao fiscal                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisRestore()
RestArea(aAreaSF2)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aArea)

Return (.T.)







************************************************************
User Function VerAtend( cDocto ,cSeriNF, cCliNF )
************************************************************

Local nOpcA		:= 0
Local aAreaAtu	:= GetArea()
Local aAreaSUC	:= SUC->(GetArea())
Local dDtEntreg	:= CriaVar("UC_PREVCHG",.F.,.F.)
Local dDtReag2	:= CriaVar("UC_DATRASO",.F.,.F.)
Local dDtAgCli	:= CriaVar("UC_DTAGCLI",.F.,.F.)
Local dDtUFCHG	:= CriaVar("F2_UFCHG"  ,.F.,.F.)
Local dDtAgCliAn:= Ctod("  /  /    " )
Local cObsSUC	:= Space(130) //CriaVar("UC_OBS",.F.,.F.)  //MSMM(SUC->UC_CODOBS)
Local cAtend    := ""
Local cItemSUD  := ""
Local cEntidade := ""		//vai armazenar se é SA1 ou SA2
Local cSUCChave := ""		//vai armazenar o codigo+loja
Local cCliente  := ""
Local cLojaCli  := ""
Local cCodContat:= ""
Local dDtInclu
Local cHoraIni  := ""
Local cSUCResp  := "" 
Local cNomeUser := ""
Local cTransp	:= "" 
Local cArqHTM   := ""
Local cDirHTM	:= ""
Local cBody		:= ""
Local nItens    := 0
Local lItemSUD  := .F.
Local cRetencao
Local aRetencao := {}
Local dEmiNF	:= CtoD("  /  /    ")
Local cUCFilial := ""
Local cNomTransp:= ""
Local cTelTransp:= ""
Local lMailRetencao := .F.
Local oCbx 
Local lAchou	:= .F.
Local lMailReagen := .F. 
Local lEnvMail	:= .F.   
Local cCodLig	:= ""  
Local cLista	:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local lReagenda := .F. 

cQuery := " Select UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, UC_STATUS, UC_CODCONT, UC_ENTIDAD, R_E_C_N_O_ AS NRECNO "
cQuery += " From " + Retsqlname("SUC") + " SUC "
cQuery += " Where RTRIM( SUC.UC_NFISCAL ) = '" + Alltrim( cDocto ) + "' "
cQuery += " and RTRIM( SUC.UC_SERINF ) = '" + Alltrim( cSeriNF ) + "' "
cQuery += " and SUC.UC_FILIAL = '" + xFilial("SUC") + "' "
cQuery += " and SUC.UC_STATUS <> '3' "
cQuery += " and SUC.UC_OBSPRB <> 'S' "
cQuery += " and SUC.D_E_L_E_T_ = ''"
//MemoWrite("\Temp\VerAtend.sql",cQuery)
cQuery := ChangeQuery( cQuery )
  
If Select("SUC1") > 0
	DbSelectArea("SUC1")
	DbCloseArea()	
EndIf 
	
TCQUERY cQuery NEW ALIAS "SUC1"
SUC1->(Dbgotop())
If !SUC1->( EoF() )	
	lAchou 		:= .T.
Else
	lAchou	:= .F.
	MsgBox("Não existe atendimento ref. a NF--> " + cDocto + "  !!!" )		
Endif



If lAchou

	cQuery := " SELECT UC_FILIAL, UC_CODIGO, UC_ENTIDAD, UC_CHAVE, UC_NFISCAL,UC_SERINF,UC_PENDENT, UC_PREVCHG, UC_DATA, UC_INICIO, "
	cQuery += " UC_ENVMAIL ,UC_STATUS, UC_OPERADO, UC_CODOBS, UC_CODCONT, UC_DTAGCLI, UC_AGANTES, UC_RETENC, UC_DATRASO "
	cQuery += " FROM " + RetSqlName("SUC") + " SUC "
	cQuery += " WHERE UC_FILIAL ='" + xFilial("SUC") + "' "
	cQuery += " AND UC_NFISCAL  ='" + cDocto + "' "
	cQuery += " AND UC_SERINF   ='" + cSeriNF + "' "
	cQuery += " AND LEFT(UC_CHAVE,6) ='" + cCliNF + "'"
	cQuery += " AND RTRIM(UC_STATUS) = '2' "        
	cQuery += " AND RTRIM(UC_CODIGO) = '" + Alltrim(SUC1->UC_CODIGO) + "' "
	cQuery += " AND RTRIM(UC_OBSPRB) <> 'S' " 
	cQuery += " AND SUC.D_E_L_E_T_ = ' ' "  
	cQuery += " ORDER BY UC_FILIAL, UC_CODIGO "
	//MemoWrite("C:\SUCX1.SQL",cQuery)
	
	If Select("SUCX1") > 0
		DbSelectArea("SUCX1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "SUCX1" 
	
	TCSetField( "SUCX1", "UC_PENDENT", "D")
	TCSetField( "SUCX1", "UC_PREVCHG", "D")
	TCSetField( "SUCX1", "UC_DATA", "D")
	TCSetField( "SUCX1", "UC_DTAGCLI", "D")
	TCSetField( "SUCX1", "UC_AGANTES", "D")
	TCSetField( "SUCX1", "UC_DATRASO", "D")
	
	SUCX1->(Dbgotop()) 
	While SUCX1->(!EOF())
	
		cSUCResp  := SUCX1->UC_OPERADO
		cEntidade := SUCX1->UC_ENTIDAD
		cSUCChave := SUCX1->UC_CHAVE
		cAtend    := SUCX1->UC_CODIGO
		cObsSUC	  := MSMM(SUCX1->UC_CODOBS)
		dDtInclu  := SUCX1->UC_DATA
		cHoraIni  := SUCX1->UC_INICIO
		cCodContat:= SUCX1->UC_CODCONT
		dDtEntreg := SUCX1->UC_PREVCHG
		cUCFilial := SUCX1->UC_FILIAL
		dDtAgCli  := SUCX1->UC_DTAGCLI
		dDtAgCliAn:= SUCX1->UC_AGANTES
		dDtReag2  := SUCX1->UC_DATRASO
		cRetencao := SUCX1->UC_RETENC
		lMailRetencao := SUCX1->UC_ENVMAIL = "S"
		
		SUCX1->(DbSkip() )
	
	Enddo
	
	DbSelectArea("SUCX1")
	DbCloseArea()
	

	DbselectArea("SF2")
	SF2->(Dbsetorder(1))
	If SF2->(Dbseek(xFilial("SF2") + cDocto + cSeriNF  ))
		cTransp  := SF2->F2_TRANSP
		dEmiNF	 := SF2->F2_EMISSAO
		dDtUFCHG := SF2->F2_UFCHG	
	Endif
	
	DbSelectArea("SA4")
	SA4->(DbsetOrder(1))
	If SA4->(Dbseek(xFilial("SA4") + cTransp ))
		cNomTransp := SA4->A4_NREDUZ
		cTelTransp := SA4->A4_TEL	
	Endif
	
	DEFINE MSDIALOG oDlg5 FROM 000,000 TO 540,590 TITLE "Atendimento" PIXEL
	
	@ 005,007 SAY "Atendimento" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
	@ 012,003 TO 031,292 OF oDlg5 PIXEL
	@ 017,007 MSGET cAtend					WHEN .F.	PICTURE PesqPict("SUC","UC_CODIGO")		OF oDlg5 SIZE 040,006 PIXEL
	
	@ 005,157 SAY "Transportadora" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 017,157 MSGET cTransp					WHEN .F.	PICTURE PesqPict("SA4","A4_COD")		OF oDlg5 SIZE 040,006 PIXEL
	
	@ 035,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 042,003 TO 061,292 OF oDlg5 PIXEL
	
	
	cCliente := Substr(cSUCChave,1,6)
	cLojaCli := Substr(cSUCChave,7,2)	
	
	@ 045,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
	@ 045,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
	@ 045,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
						                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
						                  WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL
	
	@ 065,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 072,003 TO 091,292 OF oDlg5 PIXEL
	@ 075,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUC","UC_DATA")		OF oDlg5 SIZE 040,006 PIXEL
	
	@ 065,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 075,157 MSGET cHoraIni						WHEN .F.	PICTURE PesqPict("SUC","UC_INICIO")	    OF oDlg5 SIZE 040,006 PIXEL
	
	PswOrder(1)
	If PswSeek( cSUCResp, .T. )
		aUser  := PSWRET() 					 // Retorna vetor com informações do usuário
		cNomeUser  := Alltrim(aUser[1][2])   // Nome do usuário	
	Endif
	
	@ 095,007 SAY "Operador" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 102,003 TO 231,292 OF oDlg5 PIXEL
	@ 105,007 MSGET cNomeUser					WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL
	
	@ 120,007 SAY "Previsão de Chegada:" 		OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 128,007 MSGET dDtEntreg					WHEN .F. PICTURE PesqPict("SUC","UC_PENDENT")	OF oDlg5 SIZE 040,006 PIXEL
		 
	@ 120,075 SAY "Nova Previsão de Chegada:" 				OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 128,075 MSGET dDtReag2					WHEN .T.;
	 VALID( Empty(dDtReag2) .or. (dDtReag2 >= dDatabase .and. FdtValida(dDtReag2) )  ) PICTURE PesqPict("SUC","UC_PENDENT")	OF oDlg5 SIZE 040,006 PIXEL
	 
	If Empty( cRetencao )
		cRetencao := "N"	
	Endif
	@ 120,157 SAY "Retenção?" 				OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 128,157 COMBOBOX oCbx VAR cRetencao ITEMS { "N=Não", "S=Sim" } SIZE 46, 27 OF oDlg5 PIXEL
	
	@ 120,220 SAY "Dt.Reagendamento:" 				OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 128,220 MSGET dDtAgCli					WHEN .T.;
	 VALID( Empty(dDtAgCli) .or. (dDtAgCli >= dDatabase .and. FdtValida(dDtAgCli) )  ) PICTURE PesqPict("SUC","UC_DTAGCLI")	OF oDlg5 SIZE 040,006 PIXEL
	
	@ 145,007 SAY "Dt.Chegada na UF Destino:"	OF oDlg5 PIXEL //COLOR CLR_HBLUE
	@ 153,007 MSGET dDtUFCHG					WHEN .T. PICTURE PesqPict("SF2","F2_UFCHG")	OF oDlg5 SIZE 040,006 PIXEL
	 
	@ 168,007 SAY "Observações: " 				OF oDlg5 PIXEL COLOR CLR_HBLUE
	@ 175,007 GET oMemo1 Var cObsSUC			MEMO  SIZE 273,50 PIXEL OF oDlg5 //SIZE 273,006 PIXEL
	
	
	DEFINE SBUTTON FROM 245,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
	DEFINE SBUTTON FROM 245,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela
	
	ACTIVATE MSDIALOG oDlg5 CENTERED
	
	cLista := ""
	cCodLig:= ""
	If nOpcA = 1
		
		//Atualiza SF2
		DbselectArea("SF2")
		Dbsetorder(1)
		If SF2->(Dbseek(xFilial("SF2") + cDocto + cSeriNF )) 
			If SF2->F2_PREVCHG < dDtAgCli
				lReagenda := .T.
			Endif
			
			If SF2->F2_PREVCHG < dDtReag2
				lReagenda := .T.
			Endif
			
			If SF2->F2_PREVCHG < dDtUFCHG
				lReagenda := .T.
			Endif
			
			While  SF2->(!EOF()) .And. SF2->F2_DOC = cDocto .And. SF2->F2_SERIE = cSeriNF
				
				RecLock("SF2",.F.)
				SF2->F2_RETENC 	:= cRetencao
			
				If !Empty( dDtAgCli )
					SF2->F2_DTAGCLI	:= dDtAgCli
				Endif
				
				If !Empty(dDtReag2)
					SF2->F2_DATRASO := dDtReag2     //novo campo F2_DATRASO
				Endif
				
				If !Empty(dDtUFCHG)
					SF2->F2_UFCHG := dDtUFCHG     //novo campo F2_UFCHG
				Endif
				
				If !Empty( cObsSUC )
					SF2->F2_OBS	:= cObsSUC
				Endif
				SF2->(MsUnlock())
				SF2->(Dbskip())
			Enddo
		Else
			msgbox("TmkBarla - NF não encontrada: " + cDocto )
		Endif
		
		nItens := 0
		aItens := {}
		lItemSUD := .F.
		DbselectArea("SUD")
		SUD->(DbsetOrder(1))
		SUD->(Dbseek(xFilial("SUD") + cAtend ))
		While SUD->(!EOF()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == cAtend
		    //If !Empty(SUD->UD_PRODUTO) .or. !Empty(SUD->UD_N1) .or. !Empty(SUD->UD_N2) .or. !Empty(SUD->UD_N3) .or. !Empty(SUD->UD_N4)  .or. !Empty(SUD->UD_N5);
		      //	.or. !Empty(SUD->UD_OPERADO) 
		    If !Empty( SUD->(UD_PRODUTO + UD_N1 + UD_N2 + UD_N3 + UD_N4 + UD_N5 + UD_OPERADO ) )
			
				Aadd( aItens, {SUD->UD_FILIAL,;
							   SUD->UD_CODIGO,;
							   SUD->UD_ITEM,;
							   SUD->UD_N1,;
						  	   SUD->UD_N2,;
						       SUD->UD_N3,;
						       SUD->UD_N4,;
						       SUD->UD_N5,;
						       SUD->UD_OPERADO } )
			
			Endif
			SUD->(Dbskip())
		Enddo
		
		nItens := Len(aItens)
		If nItens > 0
			lItemSUD := .T.
		Endif
		
		dNovaCheg:= CtoD("  /  /    ")		
		
		//verifica qual a maior data para fazer o reagendamento da ligação
		If Empty( dDtAgCli ) .And. Empty( dDtReag2 )         //Se vazios: Dt. Agendamento Cliente e Dt. Atraso, não reagenda atendimento		
			If !Empty(dDtUFCHG)
				dNovaCheg := dDtUFCHG   //dNovaCheg := dDtEntreg
			Endif
			//lReagenda := .F.
		Endif
		
		If  dNovaCheg <  dDtAgCli // (dDtAgCli  > dDtReag2 ) 															
			dNovaCheg := dDtAgCli		
		Endif
		
		If dNovaCheg < dDtReag2  //( dDtReag2 > dDtAgCli )															
			dNovaCheg := dDtReag2			
		Endif
		
		If dNovaCheg < dDtUFCHG
			dNovaCheg := dDtUFCHG
		Endif
		
		If Empty(dNovaCheg) .or. dNovaCheg < dDatabase
			dNovaCheg := dDatabase
		Endif
		//msgbox("DT UF : " + dtoc(dDtUFCHG) + " - dNovaCheg: " + dtoc(dNovaCheg) )						
		
		If !lItemSUD	
			 
			//Altera o atendimento para a data digitada
			DbSelectArea("SUC")
			DbSetOrder(1)
			SUC->(DbSeek(xFilial("SUC") + cAtend ))			
			While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And. SUC->UC_CODIGO == cAtend 			
						
				RecLock("SUC",.F.)
				If lReagenda			
					SUC->UC_PENDENT	:= DataValida( dNovaCheg + 1 )
					SUC->UC_STATUS  := "2"
				Endif
				If !Empty( dDtReag2 )
					SUC->UC_DATRASO := dDtReag2
				Endif				
				SUC->UC_RETENC  := cRetencao
				
				If !Empty( dDtAgCli )
					SUC->UC_DTAGCLI := dDtAgCli
					SUC->UC_AGANTES := dDtAgCli
				Endif
				SUC->(MsUnLock())
				If !Empty( cObsSUC )
					MSMM(,,,cObsSUC,1,,,'SUC','UC_CODOBS')
				Endif
				SUC->(DbSkip())
			EndDo
					
			//--------------------SU6
			cLista := ""
			cCodLig:= cAtend
								      
			cQuery := " Select TOP 1 U6_DATA, U6_LISTA, U6_CODLIG, U6_NFISCAL, U6_SERINF, U6_CODENT "
			cQuery += " From " + Retsqlname("SU6") + " SU6 "
			cQuery += " Where RTRIM( SU6.U6_NFISCAL ) = '" + Alltrim( cDocto ) + "' "
			cQuery += " and RTRIM( SU6.U6_SERINF ) = '" + Alltrim( cSeriNF ) + "' "
			cQuery += " and SU6.U6_FILIAL = '" + xFilial("SU6") + "' "
			cQuery += " and SU6.U6_TIPO = '5' "
			cQuery += " and SU6.U6_STATUS = '1' "
			cQuery += " and RTRIM(SU6.U6_LIGPROB) <> 'S' "
			cQuery += " and RTRIM(SU6.U6_CODLIG) = '" + Alltrim(cAtend) + "' " 
			cQuery += " and SU6.D_E_L_E_T_ = ' ' "
			cQuery += " Order by U6_DATA DESC "
			//MemoWrite("\Temp\VerSU6.sql",cQuery)
			cQuery := ChangeQuery( cQuery )
	  
			If Select("SU6X") > 0
				DbSelectArea("SU6X")
				DbCloseArea()	
			EndIf 
	
			TCQUERY cQuery NEW ALIAS "SU6X"
			SU6X->(Dbgotop())
			While SU6X->(!EOF())
			  	cLista    := SU6X->U6_LISTA
				//cCodLig   := SU6X->U6_CODLIG
							
				DbselectArea("SU6X")
				SU6X->(Dbskip())
			Enddo							  
			DbselectArea("SU6X")
			SU6X->(DbcloseArea())
		
			//////////////////// ATUALIZA SU6
		
			DbselectArea("SU6")
		  	SU6->(DbsetOrder(1))
		  	If SU6->(Dbseek(xFilial("SU6") + cLista ))
		  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(cLista)
		  			If Alltrim(SU6->U6_CODLIG) = Alltrim(cCodLig) .AND. Alltrim(SU6->U6_NFISCAL) = Alltrim(cDocto);
					.and. Alltrim(SU6->U6_SERINF) = Alltrim(cSeriNF) .and. Alltrim(U6_TIPO) = '5'
					    
						RecLock("SU6", .F.)
						If lReagenda
					    	SU6->U6_DATA 	:= DataValida(dNovaCheg + 1)
					 	Endif
					  	SU6->U6_NFISCAL := cDocto
					  	SU6->U6_SERINF  := cSeriNF
					  	
					  	If !Empty(dDtReag2)
					  		SU6->U6_DATRASO := dDtReag2
					  	Endif
					  	
					  	If !Empty(dDtAgCli)
					  		SU6->U6_DTAGCLI := dDtAgCli
					  	Endif		  			  	
										  	
					  	If !Empty(cObsSUC)
					  		SU6->U6_OBSLIG  := Alltrim(cObsSUC)
						Endif
							
		   				SU6->U6_RETENC := Alltrim(cRetencao)
			  						  					  							  											  			
			  			SU6->(MsUnlock())
			  		Endif
									  			
					SU6->(Dbskip())
				Enddo
									  	
			Endif
				
			///////////////////// ATUALIZA SU4 
		    If lReagenda
		        ///reagenda atendimento
		        DbSelectArea("SU4")
				DbSetOrder(1)          // U4_FILIAL + U4_LISTA
				If SU4->(DbSeek(xFilial("SU4") + cLista ))
					While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_LISTA == cLista
						If Alltrim(SU4->U4_CODLIG) = Alltrim(cCodLig)
							RecLock("SU4",.F.)						
							SU4->U4_DATA	:= DataValida(dNovaCheg + 1)						
							SU4->(MsUnLock())
							SU4->(DbSkip()) 
						Endif
					EndDo
				
				Endif
				//msgbox("reagendou SU4")
			Endif		
	        
	        
		Else
		    //Se existem itens, ver se o retorno é menor que a nova data de chegada
			DbSelectArea("SUC")
			DbSetOrder(1)	
			SUC->(DbSeek(xFilial("SUC") + cAtend ))
			If dNovaCheg < SUC->UC_PENDENT		
				While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.  SUC->UC_CODIGO == cAtend 			
					
					RecLock("SUC",.F.)				
					SUC->UC_PENDENT	:= Datavalida( dNovaCheg + 1 )					
					
					If !Empty( dDtReag2 )
						SUC->UC_DATRASO := dDtReag2
					Endif
					
					SUC->UC_RETENC  := cRetencao
					
					If !Empty( dDtAgCli )
						SUC->UC_DTAGCLI := dDtAgCli
						SUC->UC_AGANTES := dDtAgCli
					Endif
					
					MsUnLock()
					If !Empty(cObsSUC)
						MSMM(,,,cObsSUC,1,,,'SUC','UC_CODOBS')
					Endif
					SUC->(DbSkip())
				EndDo
				
				//--------------------SU6
				cLista := ""
				cCodLig:= cAtend
									      
				cQuery := " Select TOP 1 U6_DATA, U6_LISTA, U6_CODLIG, U6_NFISCAL, U6_SERINF, U6_CODENT "
				cQuery += " From " + Retsqlname("SU6") + " SU6 "
				cQuery += " Where RTRIM( SU6.U6_NFISCAL ) = '" + Alltrim( cDocto ) + "' "
				cQuery += " and RTRIM( SU6.U6_SERINF ) = '" + Alltrim( cSeriNF ) + "' "
				cQuery += " and SU6.U6_FILIAL = '" + xFilial("SU6") + "' "
				cQuery += " and RTRIM(SU6.U6_CODLIG) = '" + Alltrim(cAtend) + "' "
				cQuery += " and RTRIM(SU6.U6_STATUS) = '1' "
				cQuery += " and RTRIM(SU6.U6_LIGPROB) <> 'S' "
				cQuery += " and SU6.U6_TIPO = '5' "
				cQuery += " and SU6.D_E_L_E_T_ = ' ' "
				cQuery += " Order by U6_DATA DESC "
				//MemoWrite("\Temp\VerSU6.sql",cQuery)
				cQuery := ChangeQuery( cQuery )
		  
				If Select("SU6X") > 0
					DbSelectArea("SU6X")
					DbCloseArea()	
				EndIf 
		
				TCQUERY cQuery NEW ALIAS "SU6X"
				SU6X->(Dbgotop())
				While SU6X->(!EOF())
				  	cLista    := SU6X->U6_LISTA
					//cCodLig   := SU6X->U6_CODLIG
								
					DbselectArea("SU6X")
					SU6X->(Dbskip())
				Enddo							  
				DbselectArea("SU6X")
				SU6X->(DbcloseArea())
							
			    
			    //////////////////// ATUALIZA SU6
			   				
				DbselectArea("SU6")
			  	SU6->(DbsetOrder(1))
			  	If SU6->(Dbseek(xFilial("SU6") + cLista ))
			  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(cLista)
			  			If Alltrim(SU6->U6_CODLIG) = Alltrim(cCodLig) .AND. Alltrim(SU6->U6_NFISCAL) = Alltrim(cDocto);
						.and. Alltrim(SU6->U6_SERINF) = Alltrim(cSeriNF) .and. Alltrim(U6_TIPO) = '5' .AND. Alltrim(SU6->U6_LIGPROB) != 'S'
						    
							RecLock("SU6", .F.)
						    SU6->U6_DATA 	:= DataValida(dNovaCheg + 1)
						  	SU6->U6_NFISCAL := cDocto
						  	SU6->U6_SERINF  := cSeriNF
						  	SU6->U6_STATUS	:= '1'
						  	
						  	If !Empty(dDtReag2)
						  		SU6->U6_DATRASO := dDtReag2
						  	Endif
						  	
						  	If !Empty(dDtAgCli)
						  		SU6->U6_DTAGCLI := dDtAgCli
						  	Endif		  			  	
											  	
						  	If !Empty(cObsSUC)
						  		SU6->U6_OBSLIG  := Alltrim(cObsSUC)
							Endif
								
			   				SU6->U6_RETENC := Alltrim(cRetencao)
				  						  					  							  											  			
				  			SU6->(MsUnlock())
				  		Endif
										  			
						SU6->(Dbskip())
					Enddo
										  	
				Endif
					
				///////////////////// ATUALIZA SU4
						    
			    DbSelectArea("SU4")
				DbSetOrder(1)          // U4_FILIAL + U4_LISTA
				If SU4->(DbSeek(xFilial("SU4") + cLista ))
					While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_LISTA == cLista
						If Alltrim(SU4->U4_CODLIG) = Alltrim(cCodLig)
							RecLock("SU4",.F.)							
							SU4->U4_DATA	:= DataValida(dNovaCheg + 1)
							SU4->U4_STATUS	:= '1'
							SU4->(MsUnLock())
							SU4->(DbSkip()) 
						Endif
					EndDo
				
				Endif	
			    
			    
		    Else    	//se a data agendada para retorno que já está gravada (UC_PENDENT)
		    			//for menor que a nova dt. chegada digitada, só registra nova data chegada e não reagenda:
		    	    
		    	While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.  SUC->UC_CODIGO == cAtend				
					RecLock("SUC",.F.)				
					
					If !Empty ( dDtReag2 )
						SUC->UC_DATRASO := dDtReag2
					Endif
					
					SUC->UC_RETENC  := cRetencao
					
					If !Empty( dDtAgCli )
						SUC->UC_DTAGCLI := dDtAgCli
						SUC->UC_AGANTES := dDtAgCli
					Endif
					
					SUC->(MsUnLock())
					If !Empty(cObsSUC)
						MSMM(,,,cObsSUC,1,,,'SUC','UC_CODOBS')
					Endif
					SUC->(DbSkip())
				EndDo
				
				//--------------------SU6
				cLista := ""
				cCodLig:= cAtend
									      
				cQuery := " Select TOP 1 U6_DATA, U6_LISTA, U6_CODLIG, U6_NFISCAL, U6_SERINF, U6_CODENT "
				cQuery += " From " + Retsqlname("SU6") + " SU6 "
				cQuery += " Where RTRIM( SU6.U6_NFISCAL ) = '" + Alltrim( cDocto ) + "' "
				cQuery += " and RTRIM( SU6.U6_SERINF ) = '" + Alltrim( cSeriNF ) + "' "
				cQuery += " and SU6.U6_FILIAL = '" + xFilial("SU6") + "' "
				cQuery += " and SU6.U6_TIPO = '5' "
				cQuery += " and RTRIM(SU6.U6_LIGPROB) <> 'S' "
				cQuery += " and RTRIM(SU6.U6_CODLIG) = '" + cAtend + "' " 
				cQuery += " and SU6.D_E_L_E_T_ = ' ' "
				cQuery += " Order by U6_DATA DESC "
				//MemoWrite("\Temp\VerSU6.sql",cQuery)
				cQuery := ChangeQuery( cQuery )
		  
				If Select("SU6X") > 0
					DbSelectArea("SU6X")
					DbCloseArea()	
				EndIf 
		
				TCQUERY cQuery NEW ALIAS "SU6X"
				SU6X->(Dbgotop())
				While SU6X->(!EOF())
				  	cLista    := SU6X->U6_LISTA
					//cCodLig   := SU6X->U6_CODLIG
								
					DbselectArea("SU6X")
					SU6X->(Dbskip())
				Enddo							  
				DbselectArea("SU6X")
				SU6X->(DbcloseArea())
				
				
				//////////////////// ATUALIZA SU6
			
			  	DbselectArea("SU6")
			  	SU6->(DbsetOrder(1))
			  	If SU6->(Dbseek(xFilial("SU6") + cLista ))
			  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(cLista)
			  			If Alltrim(SU6->U6_CODLIG) = Alltrim(cCodLig) .AND. Alltrim(SU6->U6_NFISCAL) = Alltrim(cDocto);
						.and. Alltrim(SU6->U6_SERINF) = Alltrim(cSeriNF) .and. Alltrim(U6_TIPO) = '5' .AND. Alltrim(SU6->U6_LIGPROB) != 'S'
						    
							RecLock("SU6", .F.)
						    SU6->U6_NFISCAL := cDocto
						  	SU6->U6_SERINF  := cSeriNF
						  							  	
						  	If !Empty(dDtReag2)
						  		SU6->U6_DATRASO := dDtReag2
						  	Endif
						  	
						  	If !Empty(dDtAgCli)
						  		SU6->U6_DTAGCLI := dDtAgCli
						  	Endif		  			  	
											  	
						  	If !Empty(cObsSUC)
						  		SU6->U6_OBSLIG  := Alltrim(cObsSUC)
							Endif
								
			   				SU6->U6_RETENC := Alltrim(cRetencao)
				  						  					  							  											  			
				  			SU6->(MsUnlock())
				  		Endif
										  			
						SU6->(Dbskip())
					Enddo
										  	
				Endif
			  	
		    Endif
		    DbselectArea("SUC")
			SUC->(DbcloseArea()) 
		Endif
	
		
		//Se a data digitada da nova previsão de entrega for diferente da anterior, irá criar
		//uma nova ligação para o cliente, para que o operador possa avisá-lo.		
		If !Empty(dDtReag2)
			If dDtEntreg != dDtReag2
				U_CriaLig( cEntidade, cSUCChave, cCodContat, cDocto , cSeriNF, dDtReag2, cObsSUC )
				MsgInfo("Uma nova ligação foi criada.","Informação")	
			Endif
		Endif
		
		
		//Aqui verifica se a data de reagendamento digitada é diferente da que já está gravada
		//se sim, envia o email para o cliente.		
		If dDtAgCliAn <> dDtAgCli
			If Empty(dRealChg)
				lEnvMail := FREnvMail( dDtEntreg , cDocto, cSeriNF, dEmiNF, cEntidade, cSUCChave, cUCFilial, cAtend, cNomTransp, cTelTransp, 2 )
			Else
				lEnvMail := .T.
			Endif
			If lEnvMail
				DbSelectArea("SUC")
				DbSetOrder(1)	
				If SUC->(DbSeek(xFilial("SUC") + cAtend ))			
					While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.  SUC->UC_CODIGO == cAtend 			
						
						RecLock("SUC",.F.)									
											
						If !Empty( dDtAgCli )
							SUC->UC_DTAGCLI := dDtAgCli
							SUC->UC_AGANTES := dDtAgCli
						Endif
						
						SUC->(MsUnLock())				
						SUC->(DbSkip())
					EndDo		
				Endif
			Endif
		Endif
		
		//Define o diretório para gravação do arquivo HTML
	    cBody 	:= U_GeraHtmATD( cAtend , cDocto , cSeriNF , cSUCChave, cObsSUC )    
	    
	    /*
	    A função MsDocView é uma função do siga para vizualisar arquivos que são
		gravados no diretorio que ele considera como base de conhecimento..... voce
		pode descobrir qual é esse diretorio usando a função MsDocPath() que
		normalmente retorna o diretorio dirdoc\co99\shared então voce tem que gravar
		os arquivos neste diretorio para poder usar a função MsDocView.
	
		sintaxe da função MsDocView
		aVetor:= {} //não sei para que mas a função exige
		nome_arq := arquivo.txt // apenas o nome pois a propria função se encarrega
		de verificar no diretorio msdocpath() se o arquivo existe
	
		MsDocView (nome_arq, @aVetor, " ") //abre qualquer tipo de arquivo com
		extensão conhecida.
	    
	    */
	    //\dirdoc\co02\shared
	    //cDirHTM := MsDocPath()
	    //MsgAlert(cDirHTM)
	    
	    cDirHTM  := "\Temp\"    
	    cArqHTM  := "RV" + ALLTRIM( cAtend )+".HTM"   
	    nHandle := fCreate( cDirHTM + cArqHTM )
	    Fwrite( nHandle, cBody, Len(cBody) )
	    FClose( nHandle )
	    aVetor := {}
	    nRet := 0
		
		// pergunta se quer mandar o arquivo ou visualiza-lo
	    If  aviso("Confirmação de Atendimento","Qual o destino do relatório gerado",;
		     {"Visualizar","E-mail"}) == 2
	
	    	If SA1->(Dbseek(xFilial("SA1") + cCliente + cLojaCli ))
				_cDest := padr( SA1->A1_EMAIL, 80 )
				//_cDest := padr("flavia.rocha@ravaembalagens.com.br",80 ) 
			Endif
	
			_cRemet := "rava@siga.ravaembalagens.com.br"		//Este é o remetente padrão para todos os envios de e-mail no Siga da RAVA.
			
	   
			_cAssunto := padr("Rava Embalagens - Prazo para solução atendimento " + cAtend,80)
			_cCC := "sac@ravaembalagens.com.br " //"posvendas@ravaembalagens.com.br" //space(80)
			//_cCC := ""
				
		  		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Criacao da Interface para envio de email ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ 167,013 To 378,372 Dialog _oDlg Title OemToAnsi("Envio de email")
			@ 002,002 To 079,172
			@ 015,005 Say OemToAnsi("De:") Size 24,8
			@ 015,029 Get _cRemet Size 139,10   When .F.
			@ 030,005 Say OemToAnsi("Para:") Size 24,8
			@ 030,029 Get _cDest Size 139,10 
			@ 045,006 Say OemToAnsi("Cc:") Size 24,8
			@ 045,029 Get _cCC Size 139,10
			@ 060,006 Say OemToAnsi("Assunto:") Size 24,8
			@ 060,029 Get _cAssunto Size 139,10 
			@ 086,115 BmpButton Type 1 Action lEnv := U_EnvEMail(_cRemet, _cDest, _cCC, _cAssunto, cBody)	
			@ 086,145 BmpButton Type 2 Action Close(_oDlg)
			Activate Dialog _oDlg centered
	    	
				
		else
		    // faz a vinculacao do arquivo HTML com o Cliente ( Banco de Conhecimento )
		    //MsDocView( cArqHTM ) //não funcionou
		    
		    nRet := ShellExecute("open",cDirHTM + cArqHTM, "", "", 1) //esta funcionou, OK
	
	
		Endif 
	
		If cRetencao = "S"
			If !lMailRetencao
				
				//Envia o email informando sobre a retenção da mercadoria, ao cliente.
				If Empty(dRealChg)
					FREnvMail( dDtEntreg , cDocto, cSeriNF, dEmiNF, cEntidade, cSUCChave, cUCFilial, cAtend, cNomTransp, cTelTransp, 1 )
				Endif
				
				DbselectArea("SF2")
				Dbsetorder(1)
				SF2->(Dbseek(xFilial("SF2") + cDocto + cSeriNF ))
				While  SF2->(!EOF()) .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC == cDocto .And. SF2->F2_SERIE == cSeriNF
			
					RecLock("SF2",.F.)
					
					SF2->F2_ENVMAIL := "S"
					
					SF2->(MsUnlock())
					SF2->(Dbskip())
			
				Enddo
			//Else
				//msgbox("não enviou email retenção")
			Endif
		Endif
		
	EndIf
Endif

RestArea(aAreaSUC)
RestArea(aAreaAtu)

Return(Nil)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a pilha da funcao fiscal                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisRestore()
RestArea(aAreaSD2)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aArea)

Return (.T.)


***************************************************
User Function CalPrv( dDatsai, cDiatrab, nPrzent)
***************************************************

Local x := 1
Local dData := dDatsai

//msgbox("Data saída: " + dtoc(dDatsai) )
//msgbox("Prazo: " + str(nPrzent) )
/*
If cDiatrab = '1'
	msgbox("dias trab: Seg-Sex" )
Elseif cDiatrab = '2'
	msgbox("dias trab: Seg-Sab" )
Else
	msgbox("dias trab: Dom-Dom" )
Endif
*/

IF cDiatrab == alltrim(str(3))
   dData += nPrzent	// + 1
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
          	
          	//dData++
          	IF dow(dData) = 1    //SE NA CONTAGEM, CAIR NUM DOMINGO, SOMA MAIS UM DIA (QDO A TRANSP TRABALHAR DE SEG - SÁBADO)
	        	dData := DataValida(dData) + 1
	       	else
	        	dData := DataValida(dData)
	       	EndIf
             
             x++
      
             /*Modificado*/
             IF (x > nPrzent) .AND. (dow(dData) == 1)
                dData++
             ENDIF
          OTHERWISE
      
          	 Exit
          	 //Break  
             /*Aqui*/
          ENDCASE
      Else         
         dData := DataValida(dData)
         x++
      ENDIF
      
   EndDo
Endif

//msgbox("antes do while: " + dtoc(dData) )
//dData++ 
//o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
//o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790

x := 1
//FAZ ESTE NOVO LOOP PARA O CASO DA ENTREGA TER CAÍDO NO SÁBADO/DOMINGO E SE 
//A TRANSP TRABALHA DE SEG-SEX ou SEG-SAB, usa x <= 2 (2 dias: sábado e domingo)

while (x <= 2) .AND. (dData != DataValida(dData))
   //msgbox("entrou no 2 while")
   DO CASE
    CASE cDiatrab == alltrim(str(1))
       
       IF dow(dData) == 1
          dData := DataValida(dData) + 1
       else
          dData := DataValida(dData)
       EndIf
       
    CASE cDiatrab = alltrim(str(2))
       /*
       IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
       //Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          //dData++
       ENDIF
       */
       //FR - 26/05/2011
       IF dow(dData) = 1    //SE NA CONTAGEM, CAIR NUM DOMINGO, SOMA MAIS UM DIA (QDO A TRANSP TRABALHAR DE SEG - SÁBADO)
          dData := DataValida(dData) + 1
       Elseif dow(dData) = 7	//se for sábado e o tipo é 2, mantém a data, pois pode ser feita no sábado
          dData := dData
       else
          dData := DataValida(dData)
       EndIf   
       
   EndCase

   //ENDIF
   //Msgalert("calc x7" + Str(x) )
   x++
EndDo 
//msgbox("depois do while: " + dtoc(dData) )


Return dData


*********************************
Static function FdtValida( dData )   
*********************************

Local lValeDT 		:= .F.
Local nDiaSemana 	:= 0

nDiaSemana := DOW( dData )

If nDiaSemana = 1
	MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
	lValeDT := .F.
Elseif nDiaSemana = 7
	MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
	lValeDT := .F.
Else
	lValeDT := .T.
Endif


return(lValeDT)





***************************************************************************
User Function GeraHtmATD( cATD , cNF , cSerNF , cSUCChave, cObs )
***************************************************************************
//U_GeraHtmATD( cAtend , cDocto , cSeriNF , cCliente, cLojaCli )    

LOCAL LF := CHR(13)+CHR(10) , cText := '', cAlias := ALIAS(), aAlias := {}, aAmb := {}
Local cTranspo 	:= "" 
Local aUsu		:= {}
Local cResp		:= ""

// salva o ambiente atual das tabelas do array abaixo
aAlias := {"SUC", "SUD", "SA1", "SA4" } 

//aAmb := U_GETAMB( aAlias )


// inicia geracao do texto HTML

SUC->(DBSETORDER(1))
IF SUC->(DBSEEK(XFILIAL("SUC") + cATD ) )

	
	SA1->(DBSETORDER(1))
	SA1->(DBSEEK(XFilial("SA1") + cSUCChave  ) )
	
	SF2->(Dbsetorder(1))
	SF2->(Dbseek(xFilial("SF2") + cNF + cSerNF  ))
	cTranspo := SF2->F2_TRANSP

	SA4->(DBSETORDER(1))
	SA4->(DBSEEK( XFILIAL("SA4") + cTranspo ) )
	
	cText := '<html>'+LF
	cText += '<head>'+LF
	cText += '  <title>RAVA - Confirmação do atendimento </title> '+LF
	cText += '  <meta name="description" content="">'+LF
	cText += '  <meta name="keywords" content=""> '+LF
	cText += '</head> '+LF	
	cText += '<body> '+LF	
	//imagem do cabeçalho - Logotipo RAVA
	cText += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
	cText += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
	cText += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF
	//começa o texto
	cText += '<p align="Left"><b><font-family:"Trebuchet MS" size="4">CONFIRMAÇÃO DE ATENDIMENTO Ref. a sua NF/Série:  ' + cNF +' / '+ cSerNF + '</font></b></p><p></p> '+LF
	cText += '<p></p> '+LF
	cText += '<p></p> '+LF
	cText += '<p align="Left"> Confirmamos que a nota fiscal em referência gerou em nossa base o atendimento: ' + cATD + '.<br>'+LF
	cText += 'Agradecemos pela confiança e credibilidade a nós depositada.<br>'+LF
	cText += 'Estamos trabalhando para atingir e exceder suas expectativas.</p>'+LF
	//cText += '<BR> '+LF
	cText += '<p align="Left">Segue abaixo um relato do atendimento gerado, qualquer dúvida, favor nos comunicar.<br>'+LF
	//cText += '</p> '+LF
	//cText += '<p></p> '+LF
	cText += '<b><font-family:"Trebuchet MS">Nota Fiscal / Série: ' +  cNF + ' / ' + cSerNF + LF
	cText += '              Emissão: ' + DTOC(SF2->F2_EMISSAO)+ '</font></b></p> ' + LF
	//cText += '<p></p> '+LF
	cText += '<BR> '+LF
	cText += ' '+LF
	cText += '<table border="0"  width="100%"> '+LF
	cText += '  <tr><!-- Row 1 --> '+LF
	cText += '     <td width="7%"><b>Cliente</b></td><!-- Col 1 --> '+LF
	cText += '     <td width="15%" colspan="3">'+SA1->A1_NOME+' </td><!-- Col 2 --> '+LF
	cText += '  </tr> '+LF
	
	cText += '  <tr><!-- Row 2 --> '+LF
	cText += '     <td width="7%"><b>C.G.C.</b></td><!-- Col 3 --> '+LF
	cText += '     <td nowrap>' + IF(LEN(ALLTRIM(SA1->A1_CGC))<=11, TRANSFORM( SA1->A1_CGC , "@R 999.999.999-99") , TRANSFORM( SA1->A1_CGC , "@R 99.999.999/9999-99") )+'</td><!-- Col 4 -->  '+LF	
	cText += '  </tr> '+LF
	
	cText += '  <tr><!-- Row 3 --> '+LF
	cText += '     <td width="7%"><b>Inscr.</b></td><!-- Col 3 --> '+LF
	cText += '     <td nowrap>'+ Transform( SA1->A1_INSCR, "@R 999.999.999" ) +'</td><!-- Col 4 --> '+LF	
	cText += '  </tr> '+LF
	
	cText += '  <tr><!-- Row 4 --> '+LF	
	cText += '     <td width="7%"><b>Endereço</b></td><!-- Col 1 --> '+LF
	cText += '     <td width="15%" colspan="3" >'+SA1->A1_END+'</td><!-- Col 2 --> '+LF
	cText += '     <td width="10%"><b>Bairro</b></td><!-- Col 3 --> '+LF
	cText += '     <td nowrap colspan="2">'+SA1->A1_BAIRRO+'</td><!-- Col 4 --> '+LF
	cText += '  </tr> '+LF
	
	cText += '  <tr><!-- Row 5 --> '+LF
	cText += '     <td width="7%"><b>Cidade</b></td><!-- Col 1 --> '+LF
	cText += '     <td width="15%">'+SA1->A1_MUN+'</td><!-- Col 2 --> '+LF
	cText += '     <td width="5%"><b>UF</b></td><!-- Col 3 --> '+LF
	cText += '     <td width="5%" nowrap>'+SA1->A1_EST+'</td><!-- Col 4 --> '+LF
	cText += '     <td nowrap><b>Cep</b></td><!-- Col 4 --> '+LF
	cText += '     <td nowrap>'+ Transform( SA1->A1_CEP, "@R 99999-999" )+'</td><!-- Col 4 --> '+LF
	cText += '  </tr> '+LF
	cText += ' '+LF

	cText += '  <tr><!-- Row 6 --> '+LF
	cText += '     <td width="13%"><b>Contato</b></td><!-- Col 1 --> '+LF
	cText += '     <td width="15%" colspan="3">' + SA1->A1_CONTATO+'</td><!-- Col 2 --> '+LF
	cText += '     <td width="10%"><b>E-Mail</b></td><!-- Col 3 --> '+LF
	cText += '     <td nowrap>' + SA1->A1_EMAIL + '</td><!-- Col 4 --> '+LF
	cText += '  </tr> '+LF
	cText += '  </tr> '+LF	
	cText += '   '+LF
	cText += '</table> '+LF
	
	/*
	cText += ' '+LF
	cText += '<BR> '+LF
	cText += '<table border="1"  width="60%"> '+LF
	cText += '   '+LF
	cText += '  <tr bgcolor="#00CC66"><!-- Row 1 --> '+LF
	cText += '     <td width="8%"><b><font size="2" face="Arial">Problema</font></b></b></td><!-- Col 1 --> '+LF
	cText += '     <td width="5%"><b><font size="2" face="Arial">Responsável</font></b></b></td><!-- Col 1 --> '+LF
	cText += '  </tr> '+LF
	*/
	
	cText += ' '+LF
	cText += '<BR> '+LF
	cText += '<table border="1"  width="60%"> '+LF
	cText += '   '+LF
	cText += '  <tr bgcolor="#00CC66"><!-- Row 1 --> '+LF
	cText += '     <td width="8%"><b><font size="2" face="Arial">Observações</font></b></b></td><!-- Col 1 --> '+LF
	//cText += '     <td width="5%"><b><font size="2" face="Arial">Responsável</font></b></b></td><!-- Col 1 --> '+LF
	cText += '  </tr> '+LF	
		
	cText += '  <tr><!-- Row 1 --> '+LF
	cText += '    <td width="8%"><font size="2" face="Arial">' + cObs +'</td>'+ LF		
	cText += '</table> ' //+LF

	cText += '<p></p> '+LF 
	cText += '<p></p> '+LF 
	cText += ' '+LF
	cText += ' '+LF                                //fr
	cText += '<p align="Left"> Ficamos a disposição para quaisquer esclarecimentos que se façam '+LF
	cText += '                  necessários através do e_mail: <a href="mailto: daniela@ravaembalagens.com.br">daniela@ravaembalagens.com.br</a>   '+LF
	cText += '</p> '+LF
	cText += '<br> '+LF
	cText += '<p></p> '+LF
	cText += '<p></p> '+LF
	cText += '<p Align="Left"> Atenciosamente,<br> '+LF
	cText += 'RAVA Embalagens<br>  '+LF 
	//CHAMADO 1960 - ALTERAR DE: DEPTO. PÓS-VENDAS PARA: SAC
	//cText += 'Departamento Pós-Vendas<br> '+LF
	cText += 'Departamento SAC<br> '+LF
	cText += 'Fone: 83 3048 1334 <br> '+LF
	cText += 'E-Mail   <a href="mailto:daniela@ravaembalagens.com.br">daniela@ravaembalagens.com.br</a><br> '+LF
	cText += 'Rua: José Gerônimo da Silva Filho (Dedé),66 - Bairro Renascer - Cabedelo-PB</p> '+LF
	cText += '<br>' + LF
	cText += '<br>' + LF
	cText += ' *** E-MAIL AUTOMÁTICO DO SISTEMA. FAVOR NÃO RESPONDER *** ' + LF
	cText += '</body> '+LF
	cText += '</html> '+LF
	
Endif

//U_RESTAMB( aAmb )
//dbselectarea( cAlias )
	
Return( cText )    		

*************************************************************************************
User Function CriaLig( cEnti, cSUCChave, cContato, cNota, cSeriNota, datacheg, cObs )
************************************************************************************* 
//U_CriaLig( cEntidade, cSUCChave, cCodContat, cDocto , cSeriNF )

Local aAlias  := {"SU4", "SU6", "SUC", "SUD" }
Local aAmb    := U_GETAMB( aAlias )
Local  cAlias := ALIAS()

Local cLista 	:= ""
Local cU6Codigo := ""
Local cU4Codlig := ""
Local cEntida	:= cEnti        //Nome da Entidade (ex.: SA1)
Local cU6Codent := cSUCChave	//código da entidade (cliente + loja)  
Local cCodContat:= cContato
Local cNFCli	:= cNota
Local cSeriNF	:= cSeriNota
Local aCab		:= {}
Local aItens	:= {}

//cLista    := U_MaxU4Lis()
cLista    := GetSxENum("SU4","U4_LISTA")
while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end

cU4Codlig := SU4->(Lastrec())   //PASSA FORMATO NÚMERO
cU4Codlig := cU4Codlig + 1
cU4Codlig := Transform(cU4Codlig,"@X")
cU4Codlig := Strzero(Val(cU4Codlig), 6 )



Aadd(aCab,	{xFilial("SU4"),; 				//1->U4_FILIAL
			cLista,;                		//2->U4_LISTA
			cU4Codlig,;                		//3->U4_CODLIG
			"Problema-Entreg: " + cNota,; //4->U4_DESC
			Date() ,;                       //5->U4_DATA
			"3",;       					//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
			"1",;       					//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
			"1",;        					//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
			"4",;                           //9->U4_TIPOTEL
			"1",;     						//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
			Time()     })                   //11->U4_HORA1

cU6Codigo := cU4Codlig //U_MaxU6Cod()

Aadd(aItens,{	xFilial("SU6") 	,;  	//1->U6_FILIAL
	                	 	cLista		   	,;  	//2->U6_LISTA
		   					cU6Codigo	  	,;  	//3->U6_CODIGO
	                		"SA1"          	,;  	//4->U6_ENTIDA
	                		cU6Codent      	,;  	//5->U6_CODENT
	                 		"1"            	,;  	//6->U6_ORIGEM
	                	 	cCodContat     	,; 		//7->U6_CONTATO
	                	 	cU6Codigo  		,;  	//8->U6_CODLIG
	                 		Date()			,; 		//9->U6_DATA
	                		Time() 			,; 		//10->U6_HRINI
	                		"23:59"			,;  	//11->U6_HRFIM
	                		"1"         	,;  	//12->U6_STATUS
	                	    cNFCli			,;  	//13->U6_NFISCAL
	                	    cSeriNF			,;      //14->U6_SERINF
	                	    datacheg		,;      //15->U6_DATRASO
	                	    cObs			,;      //16->U6_OBSLIG
	                	    "S"				,;		//17->U6_LIGPROB		//É uma ligação problema-Entrega? S=Sim
	                	    "P"				})	 	//18->U6_TIPO   		//Define o tipo da ligação 1=Marketing, 3=Vendas, 5=Feedback, P=Problema
	                
		  
//cU6Codigo := Strzero(Val(cU6Codigo) + 1,6)   
  
For u4 := 1 to Len(aCab)
	DbselectArea("SU4")
	Reclock("SU4",.T.)
		
	SU4->U4_FILIAL 		:= aCab[u4][1]
	SU4->U4_LISTA  		:= aCab[u4][2]
	SU4->U4_CODLIG  	:= aCab[u4][3]
	SU4->U4_DESC		:= aCab[u4][4]
	SU4->U4_DATA		:= aCab[u4][5]
	SU4->U4_TIPO		:= aCab[u4][6]
	SU4->U4_FORMA		:= aCab[u4][7]
	SU4->U4_TELE		:= aCab[u4][8]
	SU4->U4_TIPOTEL		:= aCab[u4][9]           
	SU4->U4_STATUS		:= aCab[u4][10]
	SU4->U4_HORA1		:= aCab[u4][11]
	   	
   	SU4->(MsUnlock())
   	CONFIRMSX8()
Next
    
For u6 := 1 to Len(aItens)
   	DbselectArea("SU6")
   	Reclock("SU6",.T.)
	
	SU6->U6_FILENT	:= aItens[u6][1]
   	SU6->U6_LISTA	:= aItens[u6][2]
   	SU6->U6_CODIGO  := aItens[u6][3]
   	SU6->U6_ENTIDA	:= aItens[u6][4]
   	SU6->U6_CODENT	:= aItens[u6][5]  
   	SU6->U6_ORIGEM	:= aItens[u6][6]            	//1=Lista 2=Manual 3=Atendimento
   	SU6->U6_CONTATO	:= aItens[u6][7]
   	SU6->U6_CODLIG	:= aItens[u6][8]         
   	SU6->U6_DATA	:= aItens[u6][9]
   	SU6->U6_HRINI	:= aItens[u6][10] 
   	SU6->U6_HRFIM	:= aItens[u6][11]   
   	SU6->U6_STATUS	:= aItens[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado	   
   	SU6->U6_NFISCAL := aItens[u6][13]
   	SU6->U6_SERINF	:= aItens[u6][14]
   	SU6->U6_DATRASO	:= aItens[u6][15]
   	SU6->U6_OBSLIG	:= aItens[u6][16]
   	SU6->U6_LIGPROB := aItens[u6][17]
   	SU6->U6_TIPO    := aItens[u6][18]
	   	
   	SU6->(MsUnlock())	   	
Next 

U_RESTAMB( aAmb )
DBSELECTAREA(cAlias)

Return .T. 


Return


*****************************************************************************************************************************

Static Function FREnvMail( dPrevCheg, cDocto, cSeriNF, dEmiNF, cEntidade, cSUCChave, cUCFilial, cAtend, cNomTransp, cTelTransp, nOpt )
*****************************************************************************************************************************

Local cEmailTo	:= "sac@ravaembalagens.com.br;posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"
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
Local cAssunto		:= iif(nOpt == 1, "Aviso de retenção em posto fiscal", "Aviso de reagendamento")
Local cFrom			:= GetMV( "MV_RELACNT" )
Local cContato		:= ""
Local cA1Nreduz		:= ""
Local cA1NOME		:= ""
Local cA1Mail		:= ""
Local cVendedor		:= "" 
Local cMailVend		:= ""
Local cSuper		:= ""
Local cMailSuper	:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cEmailCc := ""                                  
//cEmailCc	:= "flavia.rocha@ravaembalagens.com.br"
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
DbselectArea("SA1")
Dbsetorder(1)
SA1->(Dbseek(xFilial("SA1") + cSUCChave ))
cA1Mail		:= SA1->A1_EMAIL
cA1Nreduz	:= SA1->A1_NREDUZ
cA1NOME		:= SA1->A1_NOME
cContato	:= SA1->A1_CONTATO
//cVendedor	:= SA1->A1_VEND

//FR - 27/06/2011 - CHAMADO 002179 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF 
//NO ENVIO DOS EMAILS DE RETENÇÃO E AGENDAMENTO
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cDocto + cSeriNF ))
	cVendedor	:= SF2->F2_VEND1
	cUF			:= SF2->F2_EST
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper 		:= SA3->A3_SUPER
	cMailVend	:= SA3->A3_EMAIL
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
	//por solicitação de Daniela em 17/08/11 - incluir os supervisores de venda na cópia
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



if empty(SA1->A1_EMAIL)
   cMsg := "<b>O EMAIL DO CLIENTE ESTÁ EM BRANCO! ELE NÃO RECEBERÁ ESTE INFORMATIVO. </b><br> <br> "
Else
	cEmailTo	+= ";" + cA1Mail
endif 

//DbselectArea("SA3")
//DbsetOrder(1)
//If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
//	cEMailTo += ";" + SA3->A3_EMAIL           //Chamado 001272 - Daniela - Solicitou incluir o email do representante/vendedor para também receber este e-mail
//Endif

If !Empty(cMailVend)
	cEmailTo += ";" + cMailVend
	//Chamado 001272 - Daniela - Solicitou incluir o email do representante/vendedor para também receber este e-mail
Endif

If !Empty(cMailSuper)
	cEmailTo += ";" + cMailSuper
Endif


cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
cMsg += "De: Rava Embalagens - Pós-Vendas <br> <br>"
//cMsg += "Para: "+alltrim( cA1Nreduz )+" <br> <br>"
cMsg += "Para: "+alltrim( cA1NOME )+" <br> <br>"    //FR - 04/04/13 - SOLICITADO POR DANIELA
cMsg += "A/c: " + alltrim( cContato ) + " <br> <br>"
cMsg += "INFORMATIVO <br> <br>"

if nOpt == 1            //Retenção
	cMsg += "Informamos que o material referente a nota fiscal " + cDocto + ", emitida em " + dtoc( dEmiNF ) + ", encontra-se no depósito <br>"
	cMsg += "da transportadora "+alltrim( cNomTransp )+", em razão da NF está retida no Posto fiscal do seu Estado. <br> <br>"
	//cMsg += "Pedimos que entre em contato com a transportadora através dos telefones " + alltrim( cTelTransp ) + ", <br>"
	cMsg += "Pedimos que entre em contato com a SECRETARIA DA FAZENDA para maiores esclarecimentos e soluções. <br> <br>" //FR - 04/04/13 - SOLICITADO POR DANIELA
	cMsg += "<b>Lembrando também que o material possui um prazo de até 07 dias corridos para permanecer em depósito sem <br>"
	cMsg += "cobrança de taxa para armazenamento.</b> <br> <br>"
else                   //Reagendamento
	cMsg += "Informamos que, com relação à mercadoria de N.F. " + alltrim( cDocto ) + ", emitida em " + dtoc( dEmiNF ) + ", com previsão de entrega <br> "
	cMsg += "para " + dtoc( dPrevCheg ) + ", conforme solicitação de V.Sa. será reagendada, no entanto suas duplicatas  não serão <br> "
	cMsg += "prorrogadas. <br> <br>"
endIf

cMsg += "Estarei à inteira disposição para esclarecer qualquer dúvida.<br> <br> <br> <br>"
cMsg += "Atenciosamente, <br>"
//cMsg += "Daniela Barros<br>"
//CHAMADO 1960 - ALTERAR DE: DEPTO. PÓS-VENDAS PARA: SAC
//cMsg += "Pós-Vendas<br>"
cMsg += "SAC<br>"
cMsg += "sac@ravaembalagens.com.br <br><br>" //"posvendas@ravaembalagens.com.br <br><br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += " *** E-MAIL AUTOMÁTICO DO SISTEMA. FAVOR NÃO RESPONDER *** "
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += '<font size = "2" face="Arial"><< prg: TMKBARLA.PRW >></font></p>'

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	else
		MsgInfo("E-mail -> " + cAssunto + ", Enviado com Sucesso!")
		
		conout(Replicate("*",60))
		conout("Call Center - TMKBARLA")
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


********************************
Static Function KBARLASAC()
******************************** 

Local cCliente := Substr(SU6->U6_CODENT,1,6)
Local cLoja    := Substr(SU6->U6_CODENT,7,2) 
Local cAgenda  := ""
Local cDiaRec  := ""
Local cHoraREC := "" 
Local cNomeCli := ""

U_TMKC028(cCliente, cLoja)

Return





