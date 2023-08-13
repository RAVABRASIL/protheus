#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

***********************
User Function FATC030  
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltro	:= ""
Local aIndexSC5	:= {}

Local aCores	:= {	{  'Alltrim(C5_STATUS)= " "' ,	'BR_BRANCO'},;	// SEM STATUS
						{  'Alltrim(C5_STATUS)= "01"' ,	'BR_VERDE'},;	// PEDIDO REALIZADO
						{  'Alltrim(C5_STATUS) = "02"',	'BR_AMARELO'},;    // PAGAMENTO APROVADO
						{  'Alltrim(C5_STATUS) = "03"',	'BR_AZUL'},;    // PRODUÇÃO / FATURAMENTO
						{  'Alltrim(C5_STATUS) = "04"',	'BR_PINK'},;    // PRODUTOS EM TRANSPORTE
						{  'Alltrim(C5_STATUS) = "05"',	'BR_VERMELHO'} }    // PRODUTOS ENTREGUES

								
Private cCadastro  := "Status dos Pedidos de Venda"
Private bFiltraBrw := {} 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Status","U_VerST()",0,4},;
             {"Relatorio","U_FATR040()",0,2},;
             {"Legenda"   ,	"U_LegST()"	,0,5} }	   

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SC5"

Private aCampos := { {"Num.Pedido", "C5_NUM"},; 
					{"Status", "C5_STATUS"},; 
					{"Cliente", "C5_CLIENTE"},; 
					{"Loja", "C5_LOJACLI"},;
					{"Emissao", "C5_EMISSAO"},;
					{"Cond.Pagto", "C5_CONDPAG"},;
					{"Representante", "C5_VEND1"},;
					{"Dt.P/Faturar", "C5_ENTREG"} }


dbSelectArea("SC5")
dbSetOrder(1)
SC5->(Dbgotop())
cFiltro	:= "C5_TIPO = 'N' .and. C5_STATUS != '' "  //"C8_TPFRETE = 'F' .and. C8_TIPROD $ 'AC/ME/MP/MS' "



If !Empty(cFiltro)
	bFiltraBrw	:= { || FilBrowse("SC5", @aIndexSC5, @cFiltro) }
	Eval(bFiltraBrw)
EndIf

dbSelectArea(cString)
mBrowse( 6, 1,22,75, "SC5", aCampos,,,,,aCores) 

If !Empty(cFiltro)
	EndFilBrw("SC5", aIndexSC5)
EndIf

Return 

*************************
User Function VerST()    
*************************


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCodCli    := (SC5->C5_CLIENTE + '/' + SC5->C5_LOJACLI)
Private dDTFAT     := SC5->C5_ENTREG
Private dEmiPV     := SC5->C5_EMISSAO
Private cNomCli    := Space(30)
Private cNomeRepre := Space(30)
Private cNumPV     := SC5->C5_NUM
Private cRepre     := SC5->C5_VEND1
Private nTotPV     := 0
Private nTotPI     := 0
Private cCondPag   := Space(30)
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oGetPV")
SetPrvt("oGetEmi","oGetNomCli","oGetDTFat","oGetCond","oGetRepre","oGetNomRep","oGetTOTPV","oGrp2","oGrp3")
SetPrvt("oSay12","oSay13","oSay14", "oSay15", "oGet1","oGet2","oGet3","oGet4","oGet5", "oGrp3","oBrw1","oBtn1","oBmp1","oBmp2")


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//oDlg1      := MSDialog():New( 120,250,703,1270,"Acompanhamento do Pedido de Venda",,,.F.,,,,,,.T.,,,.F. )
oDlg1      := MSDialog():New( 120,250,673,1270,"Acompanhamento do Pedido de Venda",,,.F.,,,,,,.T.,,,.F. )
oTbl1()

oGrp1      := TGroup():New( 006,012,115,504,"   DADOS DO PEDIDO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 020,024,{||"Numero"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSay2      := TSay():New( 038,024,{||"Cod.Cliente / Loja"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay3      := TSay():New( 020,168,{||"Emissao"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 040,168,{||"Nome CLi"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 080,024,{||"Data P/ Faturar"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSay6      := TSay():New( 079,168,{||"Cond.Pagto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 060,024,{||"Cod.Vendedor"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oSay8      := TSay():New( 060,168,{||"Nome Vend."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 100,024,{||"Total Pedido"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oSay14      := TSay():New( 100,168,{||"Total Pedido c/ IPI"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
oGetPV     := TGet():New( 018,080,,oGrp1,060,008,'@X',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNumPV",,)
oGetPV:bSetGet := {|u| If(PCount()>0,cNumPV:=u,cNumPV)}

oGetCliLJ  := TGet():New( 038,080,,oGrp1,060,008,'@X',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCodCli",,)
oGetCliLJ:bSetGet := {|u| If(PCount()>0,cCodCli:=u,cCodCli)}

oGetEmi    := TGet():New( 020,212,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dEmiPV",,)
oGetEmi:bSetGet := {|u| If(PCount()>0,dEmiPV:=u,dEmiPV)}

oGetNomCli := TGet():New( 038,212,,oGrp1,163,008,'@!',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomCli",,)
oGetNomCli:bSetGet := {|u| If(PCount()>0,cNomCli:=u,cNomCli)}

oGetDTFat  := TGet():New( 078,080,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDTFAT",,)
oGetDTFat:bSetGet := {|u| If(PCount()>0,dDTFAT:=u,dDTFAT)}

oGetCond   := TGet():New( 077,212,,oGrp1,162,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCondPag",,)
oGetCond:bSetGet := {|u| If(PCount()>0,cCondPag:=u,cCondPag)}

oGetRepre  := TGet():New( 060,080,,oGrp1,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cRepre",,)
oGetRepre:bSetGet := {|u| If(PCount()>0,cRepre:=u,cRepre)}

oGetNomRep := TGet():New( 060,212,,oGrp1,162,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeRepre",,)
oGetNomRep:bSetGet := {|u| If(PCount()>0,cNomeRepre:=u,cNomeRepre)}

oGetTOTPV  := TGet():New( 098,080,,oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nTotPV",,)
oGetTOTPV:bSetGet := {|u| If(PCount()>0,nTotPV:=u,nTotPV)}

oGetTOTPI  := TGet():New( 098,212,,oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nTotPI",,)
oGetTOTPI:bSetGet := {|u| If(PCount()>0,nTotPI:=u,nTotPI)}

//oGrp2      := TGroup():New( 120,012,165,503,"   STATUS  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 120,012,172,503,"   STATUS  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

//A CHAMADA DA FUNÇÃO ABAIXO TRARÁ OS DADOS DO BLOCO "STATUS"
aStatus := TrazST(SC5->C5_NUM) //traz a data do status 01-pedido realizado
//	Aadd(aRetorno , { DI , DAP, DE, DCh, HI, HAP, HE, HCh } )
c01:= "OK - " + DTOC(SC5->C5_EMISSAO)
If !Empty(aStatus[1,5])
	c01 += " - Hr: " + aStatus[1,5]
Endif

c02:= iif(Alltrim(aStatus[1,2])!= '' , "OK - " + aStatus[1,2]+ " - Hr: " + aStatus[1,6] , "Aguardando...")
c03:= iif(Alltrim(aStatus[1,3])!= '' , "OK - " + aStatus[1,3]+ " - Hr: " + aStatus[1,7] , "Aguardando...")
c04:= iif(Alltrim(aStatus[1,4])!= '' , "OK - " + aStatus[1,4]+ " - Hr: " + aStatus[1,8] , "Aguardando...")
c05:= iif(Alltrim(aStatus[1,9])!= '' , "OK - " + aStatus[1,9]+ " - Hr: " + aStatus[1,10] , "Aguardando...")

oSay10     := TSay():New( 133,019,{||"PEDIDO REALIZADO"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,061,008)
oSay11     := TSay():New( 133,114,{||"CRÉDITO LIBERADO"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay15     := TSay():New( 133,209,{||"PRODUÇÃO/FATURAMENTO"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay12     := TSay():New( 133,306,{||"PRODUTO(S) EM TRANSPORTE"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,085,008)
oSay13     := TSay():New( 133,406,{||"PRODUTO(S) ENTREGUE(S)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,078,008)

oGet1      := TGet():New( 148,019,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c01",,)  //pedido realizado
oGet1:bSetGet := {|u| If(PCount()>0,c01:=u,c01)}

If !Empty(aStatus[1,2])  //CRÉDITO LIBERADO
	oGet2      := TGet():New( 148,114,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c02",,)
Else
	oGet2      := TGet():New( 148,114,,oGrp2,070,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c02",,)
Endif
oGet2:bSetGet := {|u| If(PCount()>0,c02:=u,c02)}

If Empty(aStatus[1,9]) 
	If !Empty(SC5->C5_NOTA)
		aNF := fBuscaNF(SC5->C5_NOTA)
		c05 := Dtoc(aNF[1,1]) + " - Hr: " + aNF[1,2]
	Endif
	
	oGet5      := TGet():New( 148,209,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c05",,)
Else
	oGet5      := TGet():New( 148,209,,oGrp2,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c05",,)

Endif
oGet5:bSetGet := {|u| If(PCount()>0,c05:=u,c05)}
	
If !Empty(aStatus[1,3])   //PRODUTOS EM TRANSPORTE
	//c05 := "OK - "             //DOU OK NO STATUS PRODUÇÃO/FATURAMENTO
	//aNF := fBuscaNF(SC5->C5_NOTA)
	//c05 += Dtoc(aNF[1,1]) + " - Hr: " + aNF[1,2]
	
	//oGet5      := TGet():New( 148,209,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c05",,)
	//oGet5:bSetGet := {|u| If(PCount()>0,c05:=u,c05)}
	
	oGet3      := TGet():New( 148,306,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c03",,)
Else
	oGet3      := TGet():New( 148,306,,oGrp2,070,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c03",,)
Endif
oGet3:bSetGet := {|u| If(PCount()>0,c03:=u,c03)}

If !Empty(aStatus[1,4]) //PRODUTOS ENTREGUES
	oGet4      := TGet():New( 148,406,,oGrp2,070,008,'',,CLR_GREEN,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c04",,)
Else                                                                                                                 
	oGet4      := TGet():New( 148,406,,oGrp2,070,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c04",,)
Endif
oGet4:bSetGet := {|u| If(PCount()>0,c04:=u,c04)}


//oGrp3      := TGroup():New( 172,012,245,504,"   DETALHES  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp3      := TGroup():New( 176,012,249,504,"   DETALHES  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

cNomCli:= fGetPV(SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "C")
nTotPV := fGetPV(SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "T")
nTotPI := fGetPV(SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "I")
cNomeRepre := fGetPV(SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "V")
cCondPag := fGetPV(SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "P")

fGetPV( SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI , ""  )


DbSelectArea("TMPFR")



oVerd       := LoadBitmap( GetResources(), "BR_VERDE" )
oVerm       := LoadBitmap( GetResources(), "BR_VERMELHO" )
oAzul       := LoadBitmap( GetResources(), "BR_AZUL" )
oPreto      := LoadBitmap( GetResources(), "BR_PRETO" )
oBranco     := LoadBitmap( GetResources(), "BR_BRANCO" )

//oBrw1      := MsSelect():New( "<INFORM ALIAS>","","",{{"","","Title",""}},.F.,,{184,020,244,496},,, oGrp3 )
oBrw1 := MsSelect():New( "TMPFR","","",{{"C6IT","","Item",""},;
									  {"C6PROD","","Produto",""},;
									  {"C6DESC","","Descricao",""},;
									  {"C6TIPO","","Tipo Prod.",""},;
  									  {"C6UM","","Und.Medida",""},;
  									  {"C6QT","","Quantidade",""},;                                      
                                      {"C6PRCLIS","","Preço Lista",""},;
                                      {"C6PRCUNI","","Preço Unit.",""},;
                                      {"C6TOTAL","","Total",""},;
                                      {"C6ENTREG","","Entrega",""},;
                                      {"C6IPI","","Aliq.IPI",""},;
                                      {"C6TES","","TES",""},;
                                      {"C6CF","","CFOP",""} },.F.,,;
                                      {184,020,244,496},,, oGrp3 )   //
                                       //alt1,col,alt2,larg  //alt1 = posicionamento na dialog , alt2 = altura do msselect

//oBtn1      := TButton():New( 264,236,"Fechar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 256,235,"Fechar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||oDlg1:End()}                                       


oBmp1      := TBitmap():New( 143,091,021,020,,"\IMAGENS\SETA1.JPG",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )//pedido realizado

oBmp2      := TBitmap():New( 143,185,021,020,,"\IMAGENS\SETA1.JPG",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )//crédito liberado
oBmp2:lVisibleControl := IIF(!Empty(aStatus[1,2]),.T. , .F.) //Sim, aprovou o pagto? mostra seta

oBmp5      := TBitmap():New( 143,281,021,020,,"\IMAGENS\SETA1.JPG",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. ) //produção faturamento
oBmp5:lVisibleControl := IIF(!Empty(aStatus[1,9]),.T. , .F.) 

oBmp3      := TBitmap():New( 143,380,021,020,,"\IMAGENS\SETA1.JPG",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. ) //produtos em transporte
oBmp3:lVisibleControl := IIF(!Empty(aStatus[1,3]),.T. , .F.) //Sim, expediu a mercadoria? mostra seta

oBmp4      := TBitmap():New( 143,477,021,020,,"\IMAGENS\OK1.PNG",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp4:lVisibleControl := IIF(!Empty(aStatus[1,4]),.T. , .F.) //Sim, entregou a mercadoria? mostra OK

oDlg1:Activate(,,,.T.)

TMPFR->(DbCloseArea())
Ferase(coTbl1+".DBF")
Ferase(coTbl1+OrdBagExt())

Return

******************************************************************************************************
User Function LegST()
******************************************************************************************************


BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE",	"Pedido Realizado"} ,;
									{"BR_AMARELO",	"Crédito Liberado"} ,;
									{"BR_AZUL"   ,	"Produção / Faturamento"} ,;
									{"BR_PINK"   ,	"Produto(s) em Transporte"} ,;
									{"BR_VERMELHO",	"Produto(s) Entregue(s)"} } ) 
									

Return .T.


************************************************************************************************
Static Function fGetPV( cNum, cCli, cLJ , cTipo )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SC5X"
Local aCols		:= {}        
Local LF 		:= CHR(13) + CHR(10)
Local nTotPV    := 0
Local nValIPI   := 0  



		cQuery := " SELECT  A1_NOME, A3_NOME,C6_ITEM C6ITEM, E4_CODIGO, E4_DESCRI, * " + LF
	    cQuery += " From " + RetSqlname("SC5") + " SC5 " + LF
	    cQuery += " ," + RetSqlname("SC6") + " SC6 " + LF
	    cQuery += " ," + RetSqlname("SB1") + " SB1 " + LF
	    cQuery += " ," + RetSqlname("SA1") + " SA1 " + LF
	    cQuery += " ," + RetSqlname("SA3") + " SA3 " + LF
	    cQuery += " ," + RetSqlname("SE4") + " SE4 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C5_FILIAL  = '" + xFilial("SC5") + "' " + LF    
		
		cQuery += " AND C5_CLIENTE = A1_COD " + LF
		cQuery += " AND C5_LOJACLI = A1_LOJA " + LF
		
		cQuery += " AND C5_VEND1 = A3_COD " + LF
		
		cQuery += " AND C5_CONDPAG = E4_CODIGO " + LF
		
		cQuery += " AND C5_NUM = '"  + Alltrim(cNum)  + "' " + LF
		cQuery += " AND C5_CLIENTE = '"  + Alltrim(cCli)  + "' " + LF
		cQuery += " AND C5_LOJACLI = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND C5_FILIAL = C6_FILIAL " + LF
		cQuery += " AND C5_NUM = C6_NUM " + LF
		cQuery += " AND C5_CLIENTE = C6_CLI " + LF
		cQuery += " AND C5_LOJACLI = C6_LOJA " + LF
		cQuery += " AND C6_PRODUTO = B1_COD " + LF
		
		cQuery += " AND SC5.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SC6.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SB1.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SA1.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SA3.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SE4.D_E_L_E_T_ = ' '  " + LF
		
		cQuery += " ORDER BY C5_NUM, C6_ITEM " + LF
		MemoWrite("C:\Temp\FGETPV.SQL",cQuery)

If Select("SC5X") > 0
	DbSelectArea("SC5X")
	DbCloseArea()	
EndIf 

// Cria tabela temporaria
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")

TCSetField( cAlias, "C5_EMISSAO", "D")
TCSetField( cAlias, "C5_ENTREG", "D")
TCSetField( cAlias, "C6_ENTREG", "D")


SC5X->(Dbgotop())
While ! SC5X->(EOF())
    //DbSelectArea("TMPFR") 
    If Alltrim(cTipo) = ""
	 	RecLock("TMPFR",.T.)	   		 
	 	TMPFR->C6IT   := SC5X->C6ITEM
		TMPFR->C6PROD := SC5X->C6_PRODUTO
		TMPFR->C6DESC := SC5X->B1_DESC
		TMPFR->C6TIPO := SC5X->B1_TIPO
		TMPFR->C6UM   := SC5X->C6_UM
		TMPFR->C6QT   := Transform(SC5X->C6_QTDVEN,"@E 999,999,999.999" )
		TMPFR->C6PRCLIS := Transform(SC5X->C6_PRUNIT,"@E 999,999,999.999999")
		TMPFR->C6PRCUNI  := Transform(SC5X->C6_PRCVEN, "@E 999,999,999.999999")
		TMPFR->C6TOTAL  := Transform(SC5X->C6_VALOR,"@E 999,999,999.99")
		TMPFR->C6ENTREG := SC5X->C6_ENTREG
		TMPFR->C6TES := SC5X->C6_TES
		TMPFR->C6CF  := SC5X->C6_CF	
		TMPFR->C6IPI := Transform(SC5X->B1_IPI,"@E 999.99")
		TMPFR->(MsUnLock())  
	Endif
    
  
    nTotPV += Round(SC5X->C6_VALOR, 2)
    If Alltrim(cTipo) = "I" //TOTAL COM IPI
    	nValIPI += Round(SC5X->C6_VALOR * (SC5X->B1_IPI / 100),2)
    Endif
    cNomCli:= SC5X->A1_NOME 
    cNomeRepre := SC5X->A3_NOME
    cCondPag   := SC5X->E4_DESCRI //(SC5X->E4_CODIGO + '-' + SC5X->E4_DESCRI)
    DbselectArea("SC5X")
	SC5X->(DbSkip())
Enddo

TMPFR->(DbGoTop())
SC5X->(DbCloseArea())

If Alltrim(cTipo) = ""
	Return
ElseIF Alltrim(cTipo) = "T" //retorna total pedido
	Return(nTotPV)
ElseIF Alltrim(cTipo) = "I" //retorna total pedido C/ IPI
	Return(nTotPV + nValIPI)
ElseIF Alltrim(cTipo) = "C" //retorna nome cliente
	Return(cNomCli)
ElseIF Alltrim(cTipo) = "V" //retorna nome vendedor
	Return(cNomeRepre)
ElseIF Alltrim(cTipo) = "P" //retorna condição pagto
	Return(cCondPag)

Endif


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

	
Local aFds := {}

//Aadd( aFds, {"AT"      ,"C",001,000} )
Aadd( aFds, {"C6IT"       ,"C",004,000} )
Aadd( aFds, {"C6PROD"     ,"C",009,000} )
Aadd( aFds, {"C6DESC"     ,"C",030,000} )
Aadd( aFds, {"C6TIPO"     ,"C",002,000} )
Aadd( aFds, {"C6UM"       ,"C",002,000} )
Aadd( aFds, {"C6QT"       ,"C",016,000} )
Aadd( aFds, {"C6PRCLIS"   ,"C",016,000} )
Aadd( aFds, {"C6PRCUNI"   ,"C",016,000} )
Aadd( aFds, {"C6TOTAL"    ,"C",016,000} )
Aadd( aFds, {"C6ENTREG"   ,"D",008,000} )
Aadd( aFds, {"C6TES"      ,"C",003,000} )
Aadd( aFds, {"C6CF"       ,"C",004,000} )
Aadd( aFds, {"C6IPI"      ,"C",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMPFR New Exclusive
//Index On DOC + SERIE To ( coTbl1 )

Return 

*************************
Static Function TrazST(cPed)
*************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local cAux   := ""
Local aRetorno := {}
Local DI     := CTOD("  /  /    ") //inclusão
Local DAP     := CTOD("  /  /    ") //pagamento aprovado
Local DE     := CTOD("  /  /    ")  //data expedição
Local DCh     := CTOD("  /  /    ") //data chegada

cQuery := " Select " + LF
cQuery += " ZAC_FILIAL, ZAC_PEDIDO " + LF
cQuery += " -- status inclusão " + LF
cQuery += " ,DT_INCLUSAO = (SELECT TOP 1 ZAC_DTSTAT FROM ZAC020 Z1 WHERE Z1.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z1.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z1.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z1.ZAC_STATUS = '01') " + LF
cQuery += "                 --ORDER BY (Z2.ZAC_DTSTAT + Z2.ZAC_HRSTAT) DESC ) " + LF + LF

cQuery += " ,HR_INCLUSAO = (SELECT TOP 1 ZAC_HRSTAT FROM ZAC020 Z2 WHERE Z2.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z2.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z2.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z2.ZAC_STATUS = '01' " + LF
cQuery += "                 ORDER BY (Z2.ZAC_DTSTAT + Z2.ZAC_HRSTAT) DESC )               " + LF + LF

cQuery += " ,USER_INCLUSAO = (SELECT ZAC_USER FROM ZAC020 Z3 WHERE Z3.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                   AND Z3.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z3.D_E_L_E_T_ = '' " + LF
cQuery += " 				  AND Z3.ZAC_STATUS = '01' ) " + LF + LF

cQuery += " --status aprovação pagamento " + LF
cQuery += " ,DT_APROVPAG = (SELECT TOP 1 ZAC_DTSTAT FROM ZAC020 Z4 WHERE Z4.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z4.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z4.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z4.ZAC_STATUS = '02' " + LF
cQuery += "                 ORDER BY (Z4.ZAC_DTSTAT + Z4.ZAC_HRSTAT) DESC )               " + LF + LF

cQuery += " ,H_APROV_PAG = (SELECT TOP 1 ZAC_HRSTAT FROM ZAC020 Z5 WHERE Z5.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z5.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z5.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z5.ZAC_STATUS = '02' " + LF
cQuery += "                 ORDER BY (Z5.ZAC_DTSTAT + Z5.ZAC_HRSTAT) DESC )               " + LF + LF

cQuery += " ,USER_PAG = (SELECT TOP 1 ZAC_USER FROM ZAC020 Z6 WHERE Z6.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z6.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z6.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z6.ZAC_STATUS = '02' " + LF
cQuery += "                 ORDER BY (Z6.ZAC_DTSTAT + Z6.ZAC_HRSTAT) DESC )               " + LF + LF


cQuery += " --status produção/faturamento " + LF
cQuery += " ,DT_FAT = (SELECT TOP 1 ZAC_DTSTAT FROM ZAC020 Z4 WHERE Z4.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z4.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z4.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z4.ZAC_STATUS = '03' " + LF
cQuery += "                 ORDER BY (Z4.ZAC_DTSTAT + Z4.ZAC_HRSTAT) DESC )               " + LF + LF

cQuery += " ,HR_FAT = (SELECT TOP 1 ZAC_HRSTAT FROM ZAC020 Z5 WHERE Z5.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z5.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z5.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z5.ZAC_STATUS = '03' " + LF
cQuery += "                 ORDER BY (Z5.ZAC_DTSTAT + Z5.ZAC_HRSTAT) DESC )               " + LF + LF

cQuery += " ,USER_FAT = (SELECT TOP 1 ZAC_USER FROM ZAC020 Z6 WHERE Z6.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z6.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z6.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z6.ZAC_STATUS = '03' " + LF
cQuery += "                 ORDER BY (Z6.ZAC_DTSTAT + Z6.ZAC_HRSTAT) DESC )               " + LF + LF


cQuery += " --status da expedição " + LF
cQuery += " ,DT_EXP = (SELECT TOP 1 ZAC_DTSTAT FROM ZAC020 Z7 WHERE Z7.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z7.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z7.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z7.ZAC_STATUS = '04' " + LF
cQuery += "                 ORDER BY (Z7.ZAC_DTSTAT + Z7.ZAC_HRSTAT) DESC )               " + LF + LF
                
cQuery += " ,HR_EXP = (SELECT TOP 1 ZAC_HRSTAT FROM ZAC020 Z8 WHERE Z8.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z8.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z8.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z8.ZAC_STATUS = '04' " + LF
cQuery += "                 ORDER BY (Z8.ZAC_DTSTAT + Z8.ZAC_HRSTAT) DESC )               " + LF + LF
                

cQuery += " ,USER_EXP = (SELECT TOP 1 ZAC_USER FROM ZAC020 Z9 WHERE Z9.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND Z9.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND Z9.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND Z9.ZAC_STATUS = '04' " + LF
cQuery += "                 ORDER BY (Z9.ZAC_DTSTAT + Z9.ZAC_HRSTAT) DESC )               " + LF + LF
                
cQuery += " --status da entrega " + LF
cQuery += " ,DT_ENTRG = (SELECT TOP 1 ZAC_DTSTAT FROM ZAC020 ZA WHERE ZA.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND ZA.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND ZA.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND ZA.ZAC_STATUS = '05' " + LF
cQuery += "                 ORDER BY (ZA.ZAC_DTSTAT + ZA.ZAC_HRSTAT) DESC )               " + LF + LF
                
cQuery += " ,HR_ENTRG = (SELECT TOP 1 ZAC_HRSTAT FROM ZAC020 ZB WHERE ZB.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND ZB.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND ZB.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND ZB.ZAC_STATUS = '05' " + LF
cQuery += "                 ORDER BY (ZB.ZAC_DTSTAT + ZB.ZAC_HRSTAT) DESC )               " + LF + LF
                

cQuery += " ,USER_ENTRG = (SELECT TOP 1 ZAC_USER FROM ZAC020 ZC WHERE ZC.ZAC_FILIAL = ZAC.ZAC_FILIAL " + LF
cQuery += "                 AND ZC.ZAC_PEDIDO = ZAC.ZAC_PEDIDO AND ZC.D_E_L_E_T_ = '' " + LF
cQuery += " 				AND ZC.ZAC_STATUS = '05' " + LF
cQuery += "                 ORDER BY (ZC.ZAC_DTSTAT + ZC.ZAC_HRSTAT) DESC )               " + LF + LF
                
               
                
cQuery += " FROM " + LF
cQuery += " " + RetSqlname("ZAC") + " ZAC " + LF

cQuery += " WHERE  " + LF
cQuery += " ZAC.D_E_L_E_T_ = '' " + LF
cQuery += " AND ZAC_PEDIDO = '" + Alltrim(cPed) + "' " + LF
cQuery += " AND ZAC_FILIAL = '" + xFilial("ZAC") + "' " + LF
cQuery += " GROUP BY ZAC.ZAC_FILIAL, ZAC.ZAC_PEDIDO " + LF
cQuery += " ORDER BY ZAC.ZAC_FILIAL, ZAC.ZAC_PEDIDO " + LF
MemoWrite("C:\Temp\FGEST.SQL",cQuery)

If Select("ZZX") > 0
	DbSelectArea("ZZX")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "ZZX" 
TCSetField( "ZZX", "DT_INCLUSAO", "D")
TCSetField( "ZZX", "DT_APROVPAG", "D")
TCSetField( "ZZX", "DT_FAT", "D")
TCSetField( "ZZX", "DT_EXP", "D")
TCSetField( "ZZX", "DT_ENTRG", "D")

ZZX->(Dbgotop())
While ! ZZX->(EOF())   
	//nAux := SC8XX->TOTCOT
    DI     := DTOC(ZZX->DT_INCLUSAO)
    HI     := ZZX->HR_INCLUSAO
    
	DAP    := iif(!Empty(ZZX->DT_APROVPAG), DTOC(ZZX->DT_APROVPAG), '') //pagamento aprovado
	HAP    := ZZX->H_APROV_PAG
	
	DPF    := iif(!Empty(ZZX->DT_FAT), DTOC(ZZX->DT_FAT), '') //PRODUÇÃO FATURAMENTO
	HPF    := ZZX->HR_FAT //HORA FATURAMENTO
	
	DE     := iif(!Empty(ZZX->DT_EXP), DTOC(ZZX->DT_EXP), '')  //data expedição
	HE     := ZZX->HR_EXP
	
	DCh    := iif(!Empty(ZZX->DT_ENTRG), DTOC(ZZX->DT_ENTRG), '') //data chegada
	HCh    := ZZX->HR_ENTRG
	
	Aadd(aRetorno , { DI , DAP, DE, DCh, HI, HAP, HE, HCh, DPF, HPF } )
	//                 1    2    3   4   5    6    7   8    9    10
    ZZX->(DbSkip())
Enddo

ZZX->(DbCloseArea())

Return(aRetorno)

*********************************
Static Function fBuscaNF(cNOTA ) 
*********************************

Local aDADOS := {}

DbSelectArea("SF2")
SF2->(DbsetOrder(1))
SF2->(Dbseek(xFilial("SF2") + cNOTA ))
Aadd(aDADOS, {SF2->F2_EMISSAO, SF2->F2_HORA} )

Return(aDADOS)