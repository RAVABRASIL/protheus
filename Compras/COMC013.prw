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
±±ºPrograma  ³COMC013  ºAutoria  ³ Flávia Rocha      º Data ³  11/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela Lançamento Frete pela Logística.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Logística                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
***************************************
User Function COMC013()
***************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltro	:= ""
Local aIndexSC8	:= {}

Local aCores	:= {	{  '!Empty(C8_VALFRE) .AND. Empty(C8_NUMPED)',	'BR_VERMELHO'},;	// FRETE REGISTRADO
								{  'Empty(C8_VALFRE) .AND. Empty(C8_NUMPED)',	'BR_VERDE'},;
								{ '!Empty(C8_NUMPED)' , 'BR_PRETO'} }		// PEDIDO GERADO
								
Private cCadastro  := "Atualização do Frete Compras"
Private bFiltraBrw := {} 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_AtuLOG(2)",0,2} ,;
             {"Atualizar","U_AtuLOG(3)",0,4},;
             {"Legenda"   ,	"U_LegFR()"	,0,5} }	   

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SC8"

Private aCampos := { {"Num.Cotacao", "C8_NUM"},; 
					{"Fornecedor", "C8_FORNECE"},; 
					{"Tipo Produto", "C8_TIPROD"},;
					{"Tipo Frete", "C8_TPFRETE"} }


Private lSoKG := .T. //indica que todos os itens da cotação estão em KG

dbSelectArea("SC8")
dbSetOrder(1)

//cFiltro	:= "C8_TPFRETE = 'F' .and. C8_TIPROD $ 'AC/ME/MP/MS' "
//FR - 17/04/14 - ALTERADO PARA COMPOR TODOS OS TIPOS, ATENDENTO AO CHAMADO #39.
cFiltro	:= "C8_TPFRETE = 'F' .and. C8_TIPROD != 'PA' "



If !Empty(cFiltro)
	bFiltraBrw	:= { || FilBrowse("SC8", @aIndexSC8, @cFiltro) }
	Eval(bFiltraBrw)
EndIf

dbSelectArea(cString)
mBrowse( 6, 1,22,75, "SC8", aCampos,,,,,aCores) 

If !Empty(cFiltro)
	EndFilBrw("SC8", aIndexSC8)
EndIf

Return 



*****************************
User Function AtuLOG(nOpc)         
*****************************


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local oVerd
Local oVerm
Local oAzul
Local oPreto
Local oBranco
Local dEmissao  := SC8->C8_EMISSAO
Local cNomeForn	:= "" 
Local cForneLj  := ""
Local cLocal    := "" //localidade do fornecedor

Private coTbl1

Private cForn	:= SC8->C8_FORNECE
Private cLJ     := SC8->C8_LOJA 

Private cNumCOT	:= SC8->C8_NUM
Private nTOTFORN:= 0
Private nValFre   := SC8->C8_VALFRE
Private cPrzPFre  := Space(6)  //SE4
Private cDescPrz  := Space(30)  
Private cTransp   := SC8->C8_TRANSP  //Space(6)
Private cNomTransp:= Space(30)
Private nTOTKG    := SC8->C8_KGTOTAL
Private nTOTKG2   := 0
Private cPallet   := SC8->C8_PALLET //Space(1)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oSay1","oGet1","oCBox1","oBtn1","oBtn2","oBtn3")


IF !Empty(SC8->C8_NUMPED) .and. !Empty(SC8->C8_ITEMPED)
	   Aviso( "FRETE", "Esta Cotação Já Gerou Pedido de Compra, Atualização Não Permitida !", {"Ok"})   
	   Return .F.
Endif


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1 := MSDialog():New( 116,154,601,1050,"Atualiza Info Frete",,,.F.,,,,,,.T.,,,.F. )
oTbl1()

cForneLj  := cForn + "/" + cLJ
cNomeForn := Posicione('SA2',1,xFilial("SA2")+cForn + cLj,"A2_NOME")
cLocal    :=  Alltrim(Posicione('SA2',1,xFilial("SA2")+cForn + cLj,"A2_MUN")+ " - " + Posicione('SA2',1,xFilial("SA2")+cForn + cLj,"A2_EST"))

//If nOpc = 2
	cPrzPFre := SC8->C8_CNDPFRE
//Endif
//fGetNFs( Alltrim(SU6->U6_ENTIDA), Alltrim(SU6->U6_CODENT) , (SU6->U6_DATA-1) , (SU6->U6_DATA-1), (SU6->U6_NFISCAL), (SU6->U6_SERINF),;
// (SU6->U6_TRANSP), (SU6->U6_REDESP)  )
nTOTFORN := fGetTOT(SC8->C8_NUM, SC8->C8_FORNECE, SC8->C8_LOJA )
nTOTKG := fGetKG(SC8->C8_NUM, SC8->C8_FORNECE, SC8->C8_LOJA,SC8->C8_PRODUTO )
fGetCOT( SC8->C8_NUM, SC8->C8_FORNECE, SC8->C8_LOJA  )
//If lSoKG 
//	nTOTKG2 := nTOTKG
//Else
	nTOTKG2 := SC8->C8_KGTOTAL
//Endif
cPallet := iif(Alltrim(SC8->C8_PALLET) = "S" , "Sim" , "Nao" )

DbSelectArea("TMPFR")


oVerd       := LoadBitmap( GetResources(), "BR_VERDE" )
oVerm       := LoadBitmap( GetResources(), "BR_VERMELHO" )
oAzul       := LoadBitmap( GetResources(), "BR_AZUL" )
oPreto      := LoadBitmap( GetResources(), "BR_PRETO" )
oBranco     := LoadBitmap( GetResources(), "BR_BRANCO" )



oBrw1 := MsSelect():New( "TMPFR","","",{{"C8IT","","Item",""},;
									  {"C8PROD","","Produto",""},;
									  {"C8TIPO","","Tipo Prod.",""},;
  									  {"B1DESC","","Descrição",""},;
                                      {"C8QT","","Quantidade",""},;
                                      {"C8UM","","Und.Medida",""},;
                                      {"C8PRC","","Preço Unit.",""},;
                                      {"C8TOT","","Total",""},;
                                      {"C8ENTR","","Entrega",""} },.F.,,;
                                      {065,004,138,398},,, oDlg1 )   //
                                       //alt1,col,alt2,larg  //alt1 = posicionamento na dialog , alt2 = altura do msselect
                       
oGrp1 := TGroup():New( 003,004,048,425," Dados da Cotação ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCOT := TSay():New( 014,010,{||"Cotação"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetCOT := TGet():New( 013,040,,oGrp1,60,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNumCOT",,)
oGetCOT:bSetGet := {|u| If(PCount()>0,cCOT:=u,cNumCOT)}


oSayFORN := TSay():New( 014,110,{||"Fornecedor: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetFORN := TGet():New( 013,150,,oGrp1,60,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cForneLj",,)
oGetFORN:bSetGet := {|u| If(PCount()>0,cForneLj:=u,cForneLj)}   

//oSayNFORN := TSay():New( 014,110,{||"Fornecedor: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetNFORN := TGet():New( 013,215,,oGrp1,150,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeForn",,)
oGetNFORN:bSetGet := {|u| If(PCount()>0,cNomeForn:=u,cNomeForn)}

oSayLOCA := TSay():New( 036,010,{||"Localidade"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetLOCA := TGet():New( 035,040,,oGrp1,60,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLocal",,)
oGetLOCA:bSetGet := {|u| If(PCount()>0,cLocal:=u,cLocal)}   

oSayVALT := TSay():New( 036,110,{||"Emissão: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetVALT := TGet():New( 035,150,,oGrp1,60,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dEmissao",,)
oGetVALT :bSetGet := {|u| If(PCount()>0,dEmissao:=u,dEmissao)} 

oSayVALT := TSay():New( 036,215,{||"Valor Total: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetVALT := TGet():New( 035,255,,oGrp1,60,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTOTFORN",,)
oGetVALT :bSetGet := {|u| If(PCount()>0,nTOTFORN:=u,nTOTFORN)}

oSayKG := TSay():New( 036,320,{||"Peso Liquido "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetKG := TGet():New( 035,355,,oGrp1,60,008,'@E 999,999.99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTOTKG",,)
oGetKG :bSetGet := {|u| If(PCount()>0,nTOTKG:=u,nTOTKG)}     
     

oSayIT := TSay():New( 054,007,{||"Itens:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGrp2 := TGroup():New( 145,004,208,425," Informe Frete ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//056,004,104,360
//160,004,208,360

oSayVALF := TSay():New( 155,010,{||"Valor Frete: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
If nOpc = 3  //atualiza
	oGetVALF := TGet():New( 154,058,,oGrp2,60,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFre",,)
Elseif nOpc = 2    //visualiza
	oGetVALF := TGet():New( 154,058,,oGrp2,60,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nValFre",,)
Endif
oGetVALF :bSetGet := {|u| If(PCount()>0,nValFre:=u,nValFre)}     

oSayPRZF := TSay():New( 157,128,{||"Prazo Pagto Frete: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,062,008)
If nOpc = 3
	oGetPRZF := TGet():New( 156,178,,oGrp2,40,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cPrzPFre",,)
Elseif nOpc = 2
	oGetPRZF := TGet():New( 156,178,,oGrp2,40,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"SE4","cPrzPFre",,)
Endif
oGetPRZF :bSetGet := {|u| If(PCount()>0,cPrzPFre:=u,cPrzPFre)}

oGetPRZP := TGet():New( 156,228,,oGrp2,90,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescPrz",,)
oGetPRZP :bSetGet := {|u| cDescPrz := Posicione('SE4',1,xFilial("SE4")+ cPrzPFre,"E4_DESCRI")} 

oSayTR := TSay():New( 172,010,{||"Transportadora: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
If nOpc = 3
	oGetTR := TGet():New( 171,058,,oGrp2,35,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4","cTransp",,)
Elseif nOpc = 2
	oGetTR := TGet():New( 171,058,,oGrp2,35,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"SA4","cTransp",,)
Endif
oGetTR :bSetGet := {|u| If(PCount()>0,cTransp:=u,cTransp)}     

//oGetNTR := TGet():New( 171,103,,oGrp2,90,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomTransp",,)
//oGetNTR :bSetGet := {|u| cNomTransp:=Posicione('SA4',1,xFilial("SA4")+ cTransp,"A4_NOME") } 

oGetNTR := TGet():New( 189,010,,oGrp2,130,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomTransp",,)
oGetNTR :bSetGet := {|u| cNomTransp:=Posicione('SA4',1,xFilial("SA4")+ cTransp,"A4_NOME") } 

oSayBox := TSay():New( 172,128,{||"Palletizado?"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)    
//oCBox1     := TComboBox():New( 171,178,,{"S=Sim","N=Nao"},040,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cPallet )
oGetBox := TGet():New( 171,178,,oGrp2,040,010,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPallet",,)     
//oCBox1:bSetGet := {|u| If(PCount()>0,cPallet:=u,cPallet)}
oGetBox:bSetGet := {|u| If(PCount()>0,cPallet:=u,cPallet)}


//If nOpc = 2
//	oCBox1:lReadOnly   := .T. 
//Endif

oSayKG2 := TSay():New( 172,228,{||"Peso Bruto "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetKG2 := TGet():New( 171,259,,oGrp2,60,008,'@E 999,999.99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTOTKG2",,)
oGetKG2 :bSetGet := {|u| If(PCount()>0,nTOTKG2:=u,nTOTKG2)}     



oBtn3 := TButton():New( 218,205," OK ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
oBtn3:bAction := {|| (nOK := 1 , VerCampos(nOpc) ) }
//oSBtn1:bAction := {|| (nOpcA := 1, VerCampos(nOpc))} 


oBtn4 := TButton():New( 218,275," Cancelar ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
oBtn4:bAction := {|| (nOK := 0 , oDlg1:End() )}


oDlg1:Activate(,,,.T.)

//If nOK = 1
//	fGrava(cCOT, cForn, cLJ , nValFre, cPrzPFre, cTransp, cPallet, nTOTKG2 )
//Endif

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
Aadd( aFds, {"C8IT"       ,"C",004,000} )
Aadd( aFds, {"C8PROD"     ,"C",009,000} )
Aadd( aFds, {"C8TIPO"     ,"C",002,000} )
Aadd( aFds, {"C8UM"       ,"C",002,000} )
Aadd( aFds, {"B1DESC"     ,"C",030,000} )
Aadd( aFds, {"C8QT"       ,"N",014,002} )
Aadd( aFds, {"C8PRC"      ,"N",014,004} )
Aadd( aFds, {"C8TOT"      ,"N",014,004} )
Aadd( aFds, {"C8ENTR"     ,"D",008,000} )
//Aadd( aFds, {"C8EMISS"    ,"D",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMPFR New Exclusive
//Index On DOC + SERIE To ( coTbl1 )

Return 


************************************************************************************************
Static Function fGetCOT( cCOT, cForn, cLJ )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SC8X"
Local aCols		:= {}        
Local LF 		:= CHR(13) + CHR(10)


		cQuery := " SELECT  * " + LF
	    cQuery += " From " + RetSqlname("SC8") + " SC8 " + LF
	    cQuery += " ," + RetSqlname("SB1") + " SB1 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C8_FILIAL  = '" + xFilial("SC8") + "' " + LF
		cQuery += " AND C8_NUM = '"  + Alltrim(cCOT)  + "' " + LF
		cQuery += " AND C8_FORNECE = '"  + Alltrim(cForn)  + "' " + LF
		cQuery += " AND C8_LOJA = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND C8_PRODUTO = B1_COD " + LF
		cQuery += " AND SC8.D_E_L_E_T_ = ' '  "
		cQuery += " AND SB1.D_E_L_E_T_ = ' '  "
		cQuery += " ORDER BY C8_NUM, C8_ITEM, C8_NUMPRO " + LF
MemoWrite("C:\Temp\FGETCOT.SQL",cQuery)

If Select("SC8X") > 0
	DbSelectArea("SC8X")
	DbCloseArea()	
EndIf 

// Cria tabela temporaria
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")

TCSetField( cAlias, "C8_EMISSAO", "D")
TCSetField( cAlias, "C8_DATPRF", "D")


SC8X->(Dbgotop())
While ! SC8X->(EOF())
   
 	RecLock("TMPFR",.T.)	   		 
 	TMPFR->C8IT   := SC8X->C8_ITEM
	TMPFR->C8PROD := SC8X->C8_PRODUTO
	TMPFR->C8TIPO := SC8X->B1_TIPO
	TMPFR->C8UM   := SC8X->C8_UM
	TMPFR->C8QT   := Round(SC8X->C8_QUANT,4)
	TMPFR->C8PRC  := Round(SC8X->C8_PRECO,4)
	TMPFR->C8TOT  := Round(SC8X->C8_TOTAL,2)
	//TMPFR->C8EMISS:= SC8X->C8_EMISSAO
	TMPFR->C8ENTR := SC8X->C8_DATPRF
	TMPFR->B1DESC := SC8X->B1_DESC
	TMPFR->(MsUnLock())
  

   SC8X->(DbSkip())
Enddo

TMPFR->(DbGoTop())
SC8X->(DbCloseArea())

Return
      
**********************************************
Static Function fGetTOT( cCOT, cForn, cLJ )
**********************************************

Local cQuery    := ""
Local cAlias    := "SC8XX"
Local LF 		:= CHR(13) + CHR(10)
Local nAux 		:= 0


		cQuery := " SELECT SUM((C8_QUANT * C8_PRECO) + C8_VALIPI) TOTCOT " + LF
	    cQuery += " From " + RetSqlname("SC8") + " SC8 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C8_FILIAL  = '" + xFilial("SC8") + "' " + LF
		cQuery += " AND C8_NUM = '"  + Alltrim(cCOT)  + "' " + LF
		cQuery += " AND C8_FORNECE = '"  + Alltrim(cForn)  + "' " + LF
		cQuery += " AND C8_LOJA = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND SC8.D_E_L_E_T_ = ' '  "
MemoWrite("C:\Temp\FGETTOT.SQL",cQuery)

If Select("SC8XX") > 0
	DbSelectArea("SC8XX")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "SC8XX" 
SC8XX->(Dbgotop())
While ! SC8XX->(EOF())   
	nAux := SC8XX->TOTCOT
   SC8XX->(DbSkip())
Enddo

SC8XX->(DbCloseArea())

Return(nAux)
                        

**********************************************
Static Function fGetKG( cCOT, cForn, cLJ, cProd )
**********************************************

Local cQuery    := ""
Local cAlias    := "SC8XX"
Local LF 		:= CHR(13) + CHR(10)
Local nAux 		:= 0
Local nFator    := 0
Local cTipoFAT  := ""


		cQuery := " SELECT C8_UM, B1_CONV FATOR, B1_TIPCONV TIPOFAT , B1_SEGUM, C8_QUANT, C8_UM, C8_QTSEGUM " + LF
	    cQuery += " From " + RetSqlname("SC8") + " C8 " + LF
	    cQuery += " , " + RetSqlname("SB1") + " B1 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C8_FILIAL  = '" + xFilial("SC8") + "' " + LF
		cQuery += " AND C8_NUM = '"  + Alltrim(cCOT)  + "' " + LF
		cQuery += " AND C8_FORNECE = '"  + Alltrim(cForn)  + "' " + LF
		cQuery += " AND C8_LOJA = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND C8_PRODUTO = B1_COD " + LF
		cQuery += " AND C8.D_E_L_E_T_ = ' '  "
		cQuery += " AND B1.D_E_L_E_T_ = ' '  "
MemoWrite("C:\Temp\FGETKG.SQL",cQuery)

If Select("SC8XX") > 0
	DbSelectArea("SC8XX")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "SC8XX" 
SC8XX->(Dbgotop())
While ! SC8XX->(EOF())   
	If Alltrim(SC8XX->C8_UM) $ 'KG'
		nAux += SC8XX->C8_QUANT
	ElseIF Alltrim(SC8XX->B1_SEGUM) = 'KG'
	
		nFator := SC8XX->FATOR
		cTipoFAT := SC8XX->TIPOFAT
		If Alltrim(cTipoFAT) = "M" //multiplica
			nAux += Round(SC8XX->C8_QUANT * nFator,2)   
		ElseIf Alltrim(cTipoFAT) = "D" //divide
			nAux += Round(SC8XX->C8_QUANT / nFator   ,2)
		Endif
	Elseif Alltrim(SC8XX->C8_UM) != 'KG'  //se houver algum item que não está em KG
		lSoKG := .F.
	Endif

   SC8XX->(DbSkip())
Enddo

SC8XX->(DbCloseArea())

Return(nAux)





*************************
Static Function fGrava( cNumCot, cForn, cLJ, nValFre, cPrzPFre, cTransp, cPallet, nTOTKG2 ) 
*************************

Local nResult 		:= 0
Local nElevado		:= 0
Local PJ      		:= 0
Local nTOTALit		:= 0  
Local nPrazoit 		:= "" //prazo pagto da cotação
Local nCIVP    		:= 0
Local nCFVP    		:= 0
Local nCUSTOTVP 	:= 0  
Local nPrzPONDit	:= 0 
Local nMenorCSTVP 	:= 0 
Local nPECUSTO		:= 0
Local nPACUSTO		:= 0 
Local nPEPRAZO		:= 0
Local nPAPRAZO		:= 0
Local nFatMult		:= 0
Local nPrazoFR      := 0 //PRAZO PAGTO FRETE
Local nValFreit     := 0 //VALOR FRETE ITEM 
Local cIT			:= ""
SE4->(DbSetorder(1))
If SE4->(Dbseek(xFilial("SE4") + cPrzPFre ))
	nPrazoFR := SE4->E4_PRZMED
Endif

nValFreit:= nValFre

SC8->(Dbsetorder(1))
IF SC8->(Dbseek(xFilial("SC8") + cNumCOT ))
	While SC8->(!EOF()) .and. SC8->C8_NUM == cNumCOT //.and. SC8->C8_FORNECE == cForn .and. SC8->C8_LOJA == cLJ		
			nTOTALit := 0
			nCIVP    := 0
			nCFVP    := 0
			nCUSTOTVP:= 0
			nICMFRE  := 0 //alíquota ICM Frete
			nValICMFRE  := 0  //Valor ICM Frete
			
	
			If Alltrim(SC8->C8_FORNECE) = Alltrim(cForn) .and. Alltrim(SC8->C8_LOJA) = Alltrim(cLJ)
			
			    nICMFRE := SC8->C8_ICMFRE
			    
				////cálculo do custo item a valor presente:
				SE4->(Dbsetorder(1))
				SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
				nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
				nElevado	:= nPrazoIT / 30 
				//nResult		:= ( 1 + (1.1 / 100) ) ^ nElevado
				SX5->(Dbsetorder(1))
				SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
				PJ := VAL(ALLTRIM(SX5->X5_DESCRI))
				nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
				
				nTOTALit    := 	(SC8->C8_PRECO * SC8->C8_QUANT)  + SC8->C8_VALICM // + SC8->C8_VALIPI //FR - 31/07/13 solicitado por Orley retirar o IPI
				nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = preço unitário / ( ( 1 + taxa juros mês) ^ ( prazo / 30 dias) )
				///fim do cálculo CI
					
				///CÁLCULO DO CUSTO FRETE A VALOR PRESENTE	
				nValICMFRE  := 0
	   			nValICMFRE  := Round(nValFreit * (nICMFRE / 100),2)  //calcula o valor do ICM do Frete
	   			
				nElevado 	:= nPrazoFR / 30
				nResult 	:= (  1 + (PJ / 100) ) ^ nElevado
				nCFVP		:= ( nValFreit / nResult ) + nValICMFRE	// CUSTO FRETE VALOR PRESENTE = valor frete / ( ( 1 + taxa juros mês) ^ ( prazo / 30 dias) )		
				//fim cálculo do CUSTO FRETE VP
				
				///CUSTO TOTAL DO ITEM A VP:
				nCUSTOTVP 		:= nCIVP + nCFVP
			
				///CÁLCULO DO PRAZO MÉDIO PONDERADO DE ENTREGA: 
				nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
				//fim do cálculo do prazo médio entrega ponderado
					
				///cálculo do fator multiplicador do Custo Equivalente
				nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cotação selecionada
				nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4 )
				nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
				nMaiorPRZPON:= 0
				nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
				If nMaiorPRZPON <= 0
					nMaiorPRZPON := nPrazoit
				Endif
				nPEPRAZO		:= 1 - nPECUSTO
				nPAPRAZO		:= nMaiorPRZPON / nPrzPONDit  //MAIOR PRAZO MÉDIO PONDERADO / PRAZO MÉDIO PONDERADO DO ITEM
				nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO) , 4 )
				///fim do cálculo fator multiplicador do CT
				
				RecLock("SC8", .F.) 
				//If Alltrim(SC8->C8_FORNECE) = Alltrim(cForn) .and. Alltrim(SC8->C8_LOJA) = Alltrim(cLJ)
					SC8->C8_VALFRE  := nValFreit      //atualiza o frete só do fornecedor corrente
					SC8->C8_CNDPFRE := cPrzPFre       // código da condição pagto frete
					SC8->C8_PRZPFRE := nPrazoFR
					SC8->C8_TRANSP  := cTransp
					SC8->C8_PALLET  := cPallet
				//Endif
				SC8->C8_CUSTIVP := nCIVP	
				SC8->C8_CUSTFVP := nCFVP
				SC8->C8_PRZPOND := nPrzPONDit
				SC8->C8_CTEQUIV := nCUSTOTVP * nFatMult
				///
				SC8->C8_PECUSTO := nPECUSTO
				SC8->C8_PACUSTO := nPACUSTO
				SC8->C8_PEPRAZO := nPEPRAZO
				SC8->C8_PAPRAZO := nPAPRAZO
				SC8->C8_FTEQUIV := nFatMult
				SC8->C8_KGTOTAL := nTOTKG2
				///
				SC8->(MsUnlock())
			Endif
				
		SC8->(Dbskip())
	Enddo 
	fEnviaRetorno(cNumCOT , cForn, cLJ )             
	
			SC8->(Dbsetorder(1))                    
			SC8->(Dbgotop())
			SC8->(Dbseek(xFilial("SC8") + cNumCot ))
			While !SC8->(EOF()) .and. SC8->C8_FILIAL == xFilial("SC8") .and. SC8->C8_NUM == cNumCot
			    //If Alltrim(SC8->C8_FORNECE) != Alltrim(cForn) //.and. Alltrim(SC8->C8_LOJA) != Alltrim( cLJ )
			    //	alert(SC8->C8_FORNECE) 
			    	nTOTALit := 0
					nCIVP    := 0
					nCFVP    := 0
					nCUSTOTVP:= 0
					nICMFRE := SC8->C8_ICMFRE
			    	nValICMFRE  := 0
				    	
				    nPrazoFR := SC8->C8_PRZPFRE
				    nValFreit := SC8->C8_VALFRE
					nValICMFRE  := Round(nValFreit * (nICMFRE / 100),2)  //calcula o valor do ICM do Frete
					
					SE4->(Dbsetorder(1))
					SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
					
					////////////////////////////////////////////
					////cálculo do custo item a valor presente: 
					////////////////////////////////////////////
					nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
					nElevado	:= nPrazoIT / 30
					SX5->(Dbsetorder(1))
					SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
					PJ := VAL(ALLTRIM(SX5->X5_DESCRI)) 
					nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
					nTOTALit    := 	(SC8->C8_PRECO * SC8->C8_QUANT)  + SC8->C8_VALICM // + SC8->C8_VALIPI //FR - 31/07/13 solicitado por Orley retirar o IPI
					nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = preço unitário / ( ( 1 + taxa juros mês) ^ ( prazo / 30 dias) )
					///fim do cálculo CI
					
					///////////////////////////////////////////
					///CÁLCULO DO CUSTO FRETE A VALOR PRESENTE	
					///////////////////////////////////////////	
					If nPrazoFR > 0
						nElevado 	:= nPrazoFR / 30
					Else
						nPrazoFR := 30
						nElevado := nPrazoFR / 30
					Endif
					
					nResult 	:= ( 1 + ( PJ / 100) ) ^ nElevado
					nCFVP		:= ( nValFreit / nResult ) + nValICMFRE	
					// CUSTO FRETE VALOR PRESENTE = valor frete / ( ( 1 + taxa juros mês) ^ ( prazo / 30 dias) ) + valor icm do frete
					//fim cálculo do CUSTO FRETE VP
					
					/////////////////////////////
					///CUSTO TOTAL DO ITEM A VP: 
					/////////////////////////////
					nCUSTOTVP 		:= nCIVP + nCFVP
					
					//////////////////////////////////////////////////
					///CÁLCULO DO PRAZO MÉDIO PONDERADO DE ENTREGA:   
					//////////////////////////////////////////////////
					nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
					//fim do cálculo do prazo médio entrega ponderado
					
					///////////////////////////////////////////////////////
					///cálculo do fator multiplicador do Custo Equivalente 
					///////////////////////////////////////////////////////
					nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cotação selecionada
					nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4)
					nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
					nMaiorPRZPON:= 0
					nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
					If nMaiorPRZPON <= 0
						nMaiorPRZPON := nPrazoit
					Endif
					nPEPRAZO		:= 1 - nPECUSTO
					nPAPRAZO		:= nMaiorPrzPON / nPrzPONDit  //MAIOR PRAZO MÉDIO PONDERADO / PRAZO MÉDIO PONDERADO DO ITEM
					nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO)  , 4 )
					///fim do cálculo fator multiplicador do CT
					
					RecLock("SC8", .F.)    
					//SC8->C8_VALFRE  := nValFreit  //já atualizou lá em cima
					//SC8->C8_PRZPFRE := nPrazoFR   //já atualizou lá em cima
					SC8->C8_CUSTIVP := nCIVP	
					SC8->C8_CUSTFVP := nCFVP
					SC8->C8_PRZPOND := nPrzPONDit
					SC8->C8_CTEQUIV := nCUSTOTVP * nFatMult
					///
					SC8->C8_PECUSTO := nPECUSTO
					SC8->C8_PACUSTO := nPACUSTO
					SC8->C8_PEPRAZO := nPEPRAZO
					SC8->C8_PAPRAZO := nPAPRAZO
					SC8->C8_FTEQUIV := nFatMult
					SC8->C8_KGTOTAL := nTOTKG2
					///
					SC8->(MsUnlock())
			    //Endif
				SC8->(DBSKIP())
			Enddo
			
Endif           

Return

****************************
Static Function fMenor(cCot)
****************************

Local cQuery := ""
Local nAux   := 0

cQuery := "Select MIN(C8_CUSTIVP + C8_CUSTFVP) MENORCT from " + RetSqlname("SC8") + " SC8 " + CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(cCot) + "' "  + CHR(13) + CHR(10)
cQuery += " and (C8_CUSTIVP + C8_CUSTFVP) > 0 " + CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + xFilial("SC8") + "' AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)

Memowrite("C:\TEMP\FMENOR.SQL",cQuery) 
	
If Select("MENOR") > 0
	DbSelectArea("MENOR")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "MENOR" 
MENOR->(DbGoTop())
If !MENOR->(EOF())
	While MENOR->(!EOF())		
		//If nAux <= 0
		//	nAux := ( MENOR->C8_PRECO * MENOR->C8_QUANT )
		//Elseif nAux > ( MENOR->C8_PRECO * MENOR->C8_QUANT )
		//	nAux := ( MENOR->C8_PRECO * MENOR->C8_QUANT )
		//Endif
		nAux := MENOR->MENORCT
		MENOR->(Dbskip())
	Enddo
Endif
//ALERT("MENOR: " + str(nAux) )
Return(nAux)


****************************
Static Function fMaior(cCot)
****************************

Local cQuery := ""
Local nAux   := 0

cQuery := "Select Max(C8_PRZPOND) MAIORPRZ from " + RetSqlname("SC8") + " SC8 " + CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(cCot) + "' "  + CHR(13) + CHR(10)
cQuery += " and (C8_PRZPOND) > 0 " + CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + xFilial("SC8") + "' AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
Memowrite("C:\TEMP\FMAIOR.SQL",cQuery) 
	
If Select("MAIOR") > 0
	DbSelectArea("MAIOR")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "MAIOR" 
MAIOR->(DbGoTop())
If !MAIOR->(EOF())
	While MAIOR->(!EOF())		
		//If nAux <= 0
		//	nAux := MAIOR->C8_PRZPOND
		//Elseif nAux < MAIOR->C8_PRZPOND
		//	nAux := MAIOR->C8_PRZPOND
		//Endif
		nAux := MAIOR->MAIORPRZ
		MAIOR->(Dbskip())
	Enddo
Endif
//Alert("MAIOR : " + str(nAux))
Return(nAux)

******************************************************************************************************
User Function LegFR()
******************************************************************************************************


BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Frete OK"} ,;
									{"BR_PRETO",	"Pedido Gerado"} ,;
									{"BR_VERDE" ,	"Sem Registro Frete"} } )

Return .T.
                                    
**********************************************************
Static Function fEnviaRetorno(cNumCOT , cForn, cLj)
**********************************************************
                                            
Local nQuant	:= 0
Local cUM		:= ""
Local nPreco	:= 0
Local cProd		:= ""
Local dPREVENT	:= Ctod("  /  /    ")
Local nValFRE	:= 0
Local nPRZPFRE	:= 0
Local cTipoFRE  := ""
Local cNomeFor := Posicione('SA2',1,xFilial("SA2")+cForn + cLJ,"A2_NREDUZ")
Local cTiProd   := ""
Local cITCOT    := ""
Local cParMail  := GETMV("RV_COMC013") 



	oProcess:=TWFProcess():New("MT150GRV","MT150GRV")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\MT150GRV.htm")
	oHtml   := oProcess:oHtml
	
	cCabeca := "Aviso de Atualização de Frete na Cotação"
	cMsg    := "Informamos que a Seguinte Cotação teve seu Valor e Prazo Pagto Frete Atualizados: "

SC8->(DbsetOrder(1))
If SC8->(Dbseek(xFilial("SC8") + cNumCOT + cForn + cLj ))
	While SC8->(!EOF()) .and. SC8->C8_NUM == cNumCOT .and. SC8->C8_FORNECE == cForn .and. SC8->C8_LOJA == cLJ		
		nQuant 		:= SC8->C8_QUANT
		cUM	   		:= SC8->C8_UM
		nPreco 		:= SC8->C8_PRECO
		dPREVENT 	:= SC8->C8_DATPRF
		cProd    	:= SC8->C8_PRODUTO
		nValFRE  	:= SC8->C8_VALFRE
		nPRZPFRE 	:= SC8->C8_PRZPFRE
		cTipoFRE 	:= SC8->C8_TPFRETE
		cTiProd  	:= SC8->C8_TIPROD
		cITCOT   	:= SC8->C8_ITEM
				
		aadd( oHtml:ValByName("it.cCOT")     , cNumCOT )                                            
		aadd( oHtml:ValByName("it.cNomeFor")     , cNomeFor )                                            
		aadd( oHtml:ValByName("it.cItem") , cITCOT )    
		aadd( oHtml:ValByName("it.cProd") , cProd )    
		aadd( oHtml:ValByName("it.cTiProd") , cTiProd )    
		aadd( oHtml:ValByName("it.nQt")    , Transform(nQuant , "@E 9,999,999.99") )    
		aadd( oHtml:ValByName("it.cUM") , cUM )    
		aadd( oHtml:ValByName("it.nValUni" )   , Transform(nPreco, "@E 999,999,999.99") ) 
		aadd( oHtml:ValByName("it.nValTot")     , Transform( (nQuant * nPreco) , "@E 999,999,999.99") )       
		aadd( oHtml:ValByName("it.dPrev")     , DtoC(dPREVENT) )       
		aadd( oHtml:ValByName("it.cTPFRE")     , iif(cTipoFre = "F" , "FOB" , iif(cTipoFre = "C" , "CIF" , "OUTROS") ) )       
		aadd( oHtml:ValByName("it.nValFRE")     , Transform(nValFRE, "@E 999,999,999.99") )       
		aadd( oHtml:ValByName("it.nPRZPFRE")     , Transform(nPRZPFRE, "@E 9999") + " Dias " ) 
		
		SC8->(Dbskip())
	Enddo      
			   	
	cNome  := ""		
	cMail  := ""     
	cDepto := ""
	PswOrder(1)
	If PswSeek( __CUSERID, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
	   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
	   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
		cDepto:= aUsers[1][12]  //Depto do usuário logado	
	Endif
	oHtml:ValByName("CABECA"  , cCabeca )	//título aviso
	oHtml:ValByName("cMSG"  , cMsg )	//texto do aviso	
	oHtml:ValByName("cUser"  , cNome )	//usuário logado que atualizou
	oHtml:ValByName("cDepto"    , cDepto )	//nome do Depto
	oHtml:ValByName("cMail"    , cMail )	//email
	
	 eEmail := ""
	 eEmail := cMail 
	 eEmail +=  ";" + cParMail
	 //eEmail := "" //retirar
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br"
	 oProcess:cTo := eEmail 
	 subj	:= "COTAÇÃO COMPRAS - Frete Registrado - " + Alltrim(cNumCOT) + "/" + cNomeFor
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
Endif 
//fim do envia email retorno

Return

********************************
Static Function VerCampos(nOpc)
********************************
//msgbox("nopc: " + str(nOpc) )
//If nOpcA = 1

	///SÓ PERMITIR GRAVAR DEPOIS QUE TODOS OS CAMPOS ESTIVEREM PREENCHIDOS:
	///VALOR FRETE
	///PRAZO PAGTO FRETE
	///TRANSPORTADORA
	If nOpc = 2
		oDlg1:End()	
	ElseIf nOpc = 3  
		If Empty(nValFre)
			Aviso(	cCadastro,;			
				'Por favor, Preencha o Valor Frete...' ,;
				{"&Continua"},,;           
				"Cotação: " + cNumCot )
					
		ElseIf Empty(cPrzPFre)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Prazo Pagto Frete" ...' ,;
					{"&Continua"},,;
					"Cotação: " + cNumCot )
		//ElseIf Empty(nTOTKG2)
		//	Aviso(	cCadastro,;			
		//			'Por favor, Preencha o Peso Bruto" ...' ,;
		//			{"&Continua"},,;
		//			"Cotação: " + cNumCot )
		ElseIf Empty(cTransp)
			Aviso(	cCadastro,;			
					'Por favor, Preencha a Transportadora" ...' ,;
					{"&Continua"},,;
					"Cotação: " + cNumCot )
		//ElseIf Empty(cPallet)
		//	Aviso(	cCadastro,;			
		//			'Por favor, Preencha Palletizado Sim / Não" ...' ,;
		//			{"&Continua"},,;
		//			"Cotação: " + cNumCot )
					
		Else		//se estiver tudo preenchido....GRava		
	    	oDlg1:End()
	    	fGrava(cNumCOT, cForn, cLJ , nValFre, cPrzPFre, cTransp, cPallet, nTOTKG2 )
	  	Endif
	  	
  	Endif //nOpc (atualiza ou visualiza)
		
//EndIf
	 

Return .T.
