#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

**********************
User Function A415TDOK()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
**********************
/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A415TDOK    ³ Autor ³ Gustavo Costa         ³ Data ³ 30/10/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada na confirmacao do orcamento                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Local lRET       := .T.
Local lMinimo    := .F.
Local lTitAB    := .F.
Local nTotalPED  := 0
Local x          := 0
Local lfNewVLD	:= GetNewPar('RV_XNEWVLD',.T.)
Local lfVLDTIT	:= GetNewPar('RV_XVLDTIT',.T.)
local aAreaTMP1	:= getArea("TMP1")

////FR - 07/06/13
//ACUMULA O CK_VALOR P/ OBTER O TOTAL DO PEDIDO
dbSelectArea("TMP1")
dbGoTop()
While TMP1->(!EOF())

    If TMP1->CK_PRUNIT <= 0
       lRET := .F.
    EndIf

	nTotalPED  +=	TMP1->CK_VALOR
    TMP1->(dbSkip())
    
EndDo

If ! lRET
   MsgBox( "Preco de lista do(s) produto(s) nao foi(foram) informado(s)", "INFO", "STOP" )
Endif


lMinimo := minimo()//testa se pedido atingiu o valor mínimo para a sua REGIÃO

If lMinimo
	lRet := .F.
EndIf

/*
If lfVLDTIT

	lTitAB := fTitAbert()
	
	If lTitAB
		lRet := .F.
	EndIf
	
EndIf
*/

lRet	:= ProdUni()

/////
//Valida desconto padrao do cliente e venda abaixo do custo da linha
/////

if lRet .AND. lfNewVLD

	lRet := fNewVLD(lMinimo)

EndIf

RestArea(aAreaTMP1)

Return lRet


Static Function ProdUni()

Local aAreaTMP	:= GetArea("TMP1")
Local lRet      := .T.
Local aProds	:= {}

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF()) 

	If Len(aProds) > 0
		if aScan(aProds,  TMP1->CK_PRODUTO  ) > 0
			alert("Não é permitido ter produtos repetidos!")
			RestArea(aAreaTMP)
			return .F.
		endif
	EndIf
	AADD(aProds, TMP1->CK_PRODUTO)
	TMP1->(dbSkip())
EndDo

RestArea(aAreaTMP)

return lRet

************************
Static Function minimo()
************************

Local lOk := .F.

//////////////////////////////////////////////////////////////////////////////
//FR - 23/07/13 - Solicitado por Eurivan, implementar valor mínimo por Região 
//////////////////////////////////////////////////////////////////////////////

Local nPedMIN := 0 //VALOR MÍNIMO PARA PEDIDOS QUE IRÁ VARIAR DE ACORDO COM A REGIÃO
Local cRegiao  := ""
Local cNomeReg := ""
Local lSacola := .F.  
Local lLIBMIN := .F. //chama a função LIBMIN que é uma "2a. chance" de ver se mesmo abaixo do valor mínimo, o sistema liberará
Local nTotal	:= 0
Local nSufr1	:= 0
Local nSufr2	:= 0

// pedido para grande joao pessoa
 DbSelectArea("SA1")
 DbSetORder(1)
 if SA1->(DbSeek(xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,.F.))
                               // JP  /BAYEX/S.RITA/CABEDELO
    If alltrim(SA1->A1_COD_MUN)$'07507/01807/13703/03209'
       Return .F.
    Endif           
    If SA1->A1_EST $ "AC,/AM/AP/PA/RO/RR/TO"
    	cRegiao := 'NO'  //NORTE
    	nPedMIN := GETMV("RV_VALMINO") 
    	cNomeReg:= "NORTE"
    ElseIf SA1->A1_EST $ "/MA/PI/CE/RN/PB/PE/AL/BA/SE"
    	cRegiao := 'NE'         //NORDESTE
    	nPedMIN := GETMV("RV_VALMINE")
	   	cNomeReg:= "NORDESTE"
	ElseIf SA1->A1_EST $ "GO/MT/MS/DF"
		cRegiao := 'CO'                   //CENTRO-OESTE
		nPedMIN := GETMV("RV_VALMICO")
    	cNomeReg:= "CENTRO-OESTE"
	ElseIf SA1->A1_EST $ "MG/ES/RJ/SP"
		cRegiao := 'SD'               //SUDESTE
		nPedMIN := GETMV("RV_VALMISD")
    	cNomeReg:= "SUDESTE"
	ElseIf SA1->A1_EST $ "RS/PR/SC"
		cRegiao := "SU"	            //SUL
		nPedMIN := GETMV("RV_VALMISU")
    	cNomeReg:= "SUL"
	Endif
 endif

//VERIFICAR SE FOR SACOLA, O PEDIDO MÍNIMO MUDARÁ
dbSelectArea("TMP1")
dbGoTop()
While TMP1->(!EOF())
	if Alltrim(TMP1->CK_PRODUTO) $ "GUB"
		lSacola := .T.
	endIf
    TMP1->(dbSkip())
    
EndDo

dbSelectArea("TMP1")
dbGoTop()
While TMP1->(!EOF())


	nTotal += TMP1->CK_QTDVEN * TMP1->CK_PRCVEN   		


    TMP1->(dbSkip())
    
EndDo

dbSelectArea("TMP1")
dbGoTop()

    if ! empty( posicione('SA1', 1, xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJAENT, 'A1_SUFRAMA' ) )
        
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + TMP1->CK_TES , 'F4_ICM'))='S' // CALCULA ICM 
           if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJAENT, 'A1_CALCSUF' )) $ 'S/I' 
              nSufr1 := nTotal * 0.12                      
           Endif   
        endif 
                
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + TMP1->CK_TES , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
	        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJAENT, 'A1_CALCSUF' )) $ 'S'       
	           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + TMP1->CK_TES , 'F4_PISCOF')) $ '3' // AMBOS
	               nSufr2 := nTotal * 0.0925                    
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + TMP1->CK_TES , 'F4_PISCOF')) $ '1' // PIS	   
	               nSufr2 := nTotal * 0.0165                    	           
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + TMP1->CK_TES , 'F4_PISCOF')) $ '2' // COFINS
	               nSufr2 := nTotal * 0.076                    	           
	           ENDIF
	        ENDIF        
	    Endif
        
        nTotal -= (nSufr1+nSufr2)    
        
    endIf


//NOVA SISTEMÁTICA DE PEDIDO MÍNIMO POR REGIÃO
if nTotal < nPedMIN


   		msgAlert( " O Pedido Totaliza R$:" + Transform( nTotal , "@E 999,999,999.99" ) + CHR(13) + CHR(10) ;
   		+ " Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMIN , "@E 999,999,999.99") + " Para a Região: " + cNomeReg ) //+ CHR(13) + CHR(10);
   		//+ " , Somente com a Senha Diretor Poderá Ser Liberado..." )
   		lOk := .T.

endif   

return lOk
 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fNewVLD ³ Autor :Gustavo Costa           ³ Data :15/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Valida desconto padrao cliente x produto
±±³            Valida preço medio da linha do pedido com o custo.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fNewVLD(lMinimo)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nDescPad		:= 0
Local lContinua		:= .T.
Local cSetor		:= ""
Local cNomeSetor	:= ""
Local lDesc			:= .F.
Local lQtdMin		:= .F.
Local lCusto		:= .F.
Local lPM			:= .F.
Local lLimXDD		:= .F.
Local lLibera		:= .F.
Local nPM			:= 0
Local nFrtEx		:= 0
Local cTexto		:= ""
Local nUltPrc		:= 0
Local nAumento		:= SuperGetMV("MV_XAUMENT",,1.06)
Local lUltPco		:= .F.
Local nQtdMin		:= 0
Local cTexQtdM		:= ""

Private lChk1   		:= .F.
Private coTbl1
Private coTbl2

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oBrw1","oPanel1","oPanel2","oCBox1","oBrw2","oPanel3","oSay1","oSay2","oBtn1","oMGet1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )

//Cria as tabelas
//oTbl2()
oTbl1()

dbSelectArea("TMP1")
dbGoTop()
While TMP1->(!EOF())

	cSetor	:= POSICIONE("SB1",1, xFilial("SB1") + TMP1->CK_PRODUTO, "B1_SETOR")
	cUF		:= POSICIONE("SA1",1, xFilial("SA1") + M->CJ_CLIENT + M->CJ_LOJA, "A1_EST")
	nQtdMin	:= POSICIONE("SB1",1, xFilial("SB1") + TMP1->CK_PRODUTO, "B1_LE")
	nCusto	:= fValCusto(cSetor, cUF)
	nDescPad:= fDecPad(M->CJ_CLIENTE, M->CJ_LOJA, Alltrim(TMP1->CK_PRODUTO))
	nUltPrc := fUltPco(M->CJ_CLIENTE, M->CJ_LOJA, Alltrim(TMP1->CK_PRODUTO), .F.)		//ultimo preco
	nUltPrcAum := fUltPco(M->CJ_CLIENTE, M->CJ_LOJA, Alltrim(TMP1->CK_PRODUTO), .T.) 	//ultimo preco antes do aumento
	//If aCols[_i][nPOSDESC] > nDescPad
		
		RecLock("XVL", .T.)
		XVL->COD		:= Alltrim(TMP1->CK_PRODUTO)
		XVL->PROD		:= Alltrim(TMP1->CK_DESCRI)
		XVL->DESC		:= TMP1->CK_PDESC
		XVL->ULTIMO		:= nDescPad
		XVL->DIF		:= TMP1->CK_PDESC - nDescPad
		XVL->QTDKG		:= TMP1->CK_QTDVEN
		XVL->VALKG		:= TMP1->CK_PRUNIT
		XVL->CUSTO		:= nCusto
		XVL->PESO		:= TMP1->CK_QTDVEN * POSICIONE("SB1",1, xFilial("SB1") + TMP1->CK_PRODUTO, "B1_PESO")
		XVL->ULTPC		:= nUltPrc
		XVL->IDEAL		:= IIF((nUltPrcAum * nAumento) > TMP1->CK_PRUNIT,(nUltPrcAum * nAumento),TMP1->CK_PRUNIT)
		XVL->(MsUnLock())
		
		If (TMP1->CK_PDESC - nDescPad) > 0 .and. !lDesc
			lDesc	:= .T.
		EndIf
		
		If Mod(TMP1->CK_QTDVEN, nQtdMin) <> 0 .and. nQtdMin > 1
			lQtdMin	:= .T.
			cTexQtdM	:= cTexQtdM + " COD: " + Alltrim(TMP1->CK_PRODUTO) + " - LE = " + Transform(nQtdMin,"@E 999" ) 
		EndIf
		
		If (nUltPrcAum * nAumento) > TMP1->CK_PRUNIT .and. !lUltPco
			lUltPco	:= .T.
		EndIf
		
		
	//EndIf

    TMP1->(dbSkip())
    
EndDo

/*
dbSelectArea("TMP1")
dbGoTop()
While TMP1->(!EOF())

	cSetor	:= POSICIONE("SB1",1, xFilial("SB1") + TMP1->CK_PRODUTO, "B1_SETOR")
	cUF		:= POSICIONE("SA1",1, xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA, "A1_EST")
	nCusto	:= fValCusto(cSetor, cUF)
	
    DO CASE
    	CASE cSetor $ GetNewPar('RV_SETINST','48/01/18/02/99/03')
    		cNomeSetor := "INSTITUCIONAL"
    	CASE cSetor $ GetNewPar('RV_SETINSR','57')
    		cNomeSetor := "INS. RECICLADO"
    	CASE cSetor $ GetNewPar('RV_SETINSC','29')
    		cNomeSetor := "INS. SACOLA"
    	CASE cSetor $ GetNewPar('RV_SETINSC','58')
    		cNomeSetor := "INS. TRANSPARENTE"
    	CASE cSetor $ GetNewPar('RV_SETDOMR','24/25/33')
    		cNomeSetor := "DOMESTICA RL"
        CASE cSetor $ GetNewPar('RV_SETDOMP','23/26/27/28/31/32')
        	cNomeSetor := "DOMESTICA PC"
        CASE cSetor $ GetNewPar('RV_SETHOSH','05/37/40/56')
        	cNomeSetor := "HOSP. HAMPER"
        CASE cSetor $ GetNewPar('RV_SETHOSI','08/09/10/11/12/13/14/30/34/35/36/41/55')
        	cNomeSetor := "HOSP. INFEC."
        CASE cSetor $ GetNewPar('RV_SETHOSO','06/54/98')
        	cNomeSetor := "HOSP. OBITO"
        CASE cSetor $ GetNewPar('RV_SETHOCO','59')
        	cNomeSetor := "HOSP. CORTINA"
        OtherWise
        	cNomeSetor := "OUTROS"
    EndCase
 	

	If XLL->(dbSeek( cNomeSetor )) 
		
		RecLock("XLL", .F.)
		XLL->TKG		:= XLL->TKG + TMP1->CK_QTDVEN
		XLL->TVALOR		:= XLL->TVALOR + (TMP1->CK_QTDVEN * TMP1->CK_PRUNIT)
		XLL->CLINHA		:= Alltrim(XLL->CLINHA) + '/' + AllTrim(cSetor)
		XLL->(MsUnLock())
	
	Else
	
		RecLock("XLL", .T.)
		XLL->LINHA		:= cNomeSetor
		XLL->TKG		:= TMP1->CK_QTDVEN
		XLL->TVALOR		:= (TMP1->CK_QTDVEN * TMP1->CK_PRUNIT)
		XLL->VALKG		:= 0
		XLL->CUSTO		:= nCusto
		XLL->DIF		:= 0
		XLL->CLINHA		:= AllTrim(cSetor)
		XLL->(MsUnLock())
		
	EndIf
	
    TMP1->(dbSkip())
    
EndDo


DbSelectArea("XLL")
XLL->(dbGoTop())

While XLL->(!EOF())

	RecLock("XLL", .F.)
	XLL->VALKG		:= XLL->TVALOR / XLL->TKG
	XLL->DIF		:= XLL->VALKG - XLL->CUSTO
	XLL->(MsUnLock())

	If XLL->DIF < 0 .and. !lCusto
		lCusto	:= .T.
	EndIf

	XLL->(dbSkip())

EndDo
*/

//Prazo médio
nPM := POSICIONE("SE4",1, xFilial("SE4") + M->CJ_CONDPAG, "E4_PRZMED")

If nPM > GetNewPar("MV_LIMPMV",45)
	lPM	:= .T.
	cTexto	:= cTexto + "***BLQ. Prazo Médio" + ENTER
	lContinua	:= .F.
eNDiF

//Limite do percentual do XDD
If M->CJ_DESC1 > GetNewPar("MV_LIMPXDD",40)
	lLimXDD	:= .T.
	lContinua	:= .F.
eNDiF

nFrtEx	:= fTotalFE(M->CJ_CLIENT, M->CJ_LOJA)

If nFrtEx > 0 
	cTexto	:= cTexto + "***BLQ. Vlr. Extra em Frete" + ENTER
	lContinua	:= .F.
EndIf

/*
If lCusto 
	cTexto	:= cTexto + "***BLQ. Vlr. Abaixo do Limite" + ENTER
EndIf
*/
If lDesc 
	cTexto	:= cTexto + "***BLQ. Vlr. Desconto Difenrente do Anterior" + ENTER
	lContinua	:= .F.
EndIf

If lQtdMin
	cTexto	:= cTexto + "***BLQ. QTD. Multiplo do Lote Economico - Segregados" + ENTER
	cTexto	:= cTexto + cTexQtdM
	lContinua	:= .F.
EndIf

If lUltPco 
	cTexto	:= cTexto + "***BLQ. Vlr. Item Sem Reajuste " + Alltrim(STR(nAumento)) + "%" + ENTER
	lContinua	:= .F.
EndIf
//**********************************************************************
//se ambos tiverem falso nao aparece a tela e esta liberado.
//**********************************************************************

If lDesc .OR. lCusto .OR. lPM .OR. lMinimo .OR. nFrtEx > 0 .OR. lLimXDD .OR. lUltPco .OR. lQtdMin

	oDlg1      := MSDialog():New( 300,300,750,1210,"VALIDAÇÃO ---  DESCONTO E LIMITE DE PREÇO POR LINHA",,,.F.,,,,,,.T.,,,.F. )

	DbSelectArea("XVL")
	XVL->(dbGoTop())
	
	oBrw1      := MsSelect():New( "XVL","","",{	{"COD",		"","Cod.",""},;
												{"PROD",	"","Produto",""},;
												{"DESC",	"","Desconto ped.","@E 9,999,999.99"},;
												{"ULTIMO",	"","Desconto cad.","@E 9,999,999.99"},;
												{"DIF",		"","Diferenca","@E 9,999,999.99"},;
												{"ULTPC",	"","Ultimo Prc.","@E 9,999,999.99"},;
												{"IDEAL",	"","Prc. Mínimo","@E 9,999,999.99"}},.F.,,{020,000,103,455},,, oDlg1 ) 
	
	oBrw1:oBrowse:nClrPane := CLR_BLACK
	oBrw1:oBrowse:nClrText := CLR_BLACK
	oBrw1:oBrowse:bLDBLClick := {|| fDetDesc(M->CJ_CLIENT, M->CJ_LOJA, XVL->COD) }
	
	oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,455,020,.T.,.F. )
	//oPanel2    := TPanel():New( 100,000,"",oDlg1,,.F.,.F.,,,455,022,.T.,.F. )
	
	//oCBox1     := TCheckBox():New( 004,301,"Atualizar Desconto Padrão",{|u| If(PCount()>0,lChk1:=u,lChk1)},oPanel2,107,011,,,oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	
	/*
	DbSelectArea("XLL")
	XLL->(dbGoTop())
	oBrw2      := MsSelect():New( "XLL","","",{	{"LINHA",	"","Linha",""},;
												{"TKG",		"","Total KG","@E 9,999,999.99"},;
												{"TVALOR",	"","Total R$","@E 9,999,999.99"},;
												{"VALKG",	"","Valor KG","@E 9,999,999.99"},;
												{"CUSTO",	"","Minimo","@E 9,999,999.99"},;
												{"DIF",		"","Diferenca","@E 9,999,999.99"}},.F.,,{120,000,172,455},,, oDlg1 ) 
	
	
	oBrw2:oBrowse:nClrPane := CLR_BLACK
	oBrw2:oBrowse:nClrText := CLR_BLACK
	oBrw2:oBrowse:bLDBLClick := {|| fDetGrupo() }
	*/
	oPanel3    := TPanel():New( 105,000,"",oDlg1,,.F.,.F.,,,455,090,.T.,.F. )
	oSay1      := TSay():New( 007,004,{||"Desconto padrão"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
	
	oSay3      := TSay():New( 007,104,{||"Prazo Médio"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
	oGet1      := TGet():New( 007,150,{|u| If(PCount()>0,nPM:=u,nPM)},oDlg1,030,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nPM",,)
	
	//nFrtEx	:= fTotalFE(M->CJ_CLIENT, M->CJ_LOJA)
	oSay4      := TSay():New( 007,204,{||"Frete Extra"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
	oGet2      := TGet():New( 007,250,{|u| If(PCount()>0,nFrtEx:=u,nFrtEx)},oDlg1,070,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nFrtEx",,)
	//oGet2:cPlaceHold := "N"
	//oBtn4      := TButton():New( 007,345,"Detalhe",oDlg1,,050,012,,,,.T.,,"",,,,.F. )
	//oBtn4:bAction := {|| fFrtEx(M->CJ_CLIENT, M->CJ_LOJA)}

	//oSay2      := TSay():New( 007,004,{||"Linha abaixo do mínimo"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
	If lMinimo
		//oSay2      := TSay():New( 007,104,{||"***BLQ. Vlr. Mínimo"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
		cTexto	:= cTexto + "***BLQ. Vlr. Mínimo" + ENTER
		
	EndIf
	If lLimXDD
		//oSay2      := TSay():New( 007,144,{||"***BLQ. % XDD"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
		cTexto	:= cTexto + "***BLQ. % XDD" + ENTER
	EndIf
	
	//oBtn1      := TButton():New( 001,329,"Liberar",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
	//oBtn1:bAction := {|| lLibera := .T., oDlg1:end() }
	
	oBtn2      := TButton():New( 001,045,"Confirmar",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
	oBtn2:bAction := {|| lLibera := .T., lContinua	:= .T., oDlg1:end()}

	//oBtn3      := TButton():New( 001,260,"Enviar Pedido",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
	//oBtn3:bAction := {|| MsAguarde({|| fEnviaPed()},"Aguarde...","Enviando Email...") }
	
	oSay2      := TSay():New( 005,005,{||"RESUMO"},oPanel3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
	oMGet1     := TMultiGet():New( 013,001,,oPanel3,450,080,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	oMGet1:bSetGet := {|u| If(PCount()>0,cTexto:=u,cTexto)}

	oDlg1:Activate(,,,.T.)

Else

	lContinua	:= .T.
	
EndIf

If lLibera
	If Empty(M->CJ_OBSERVA)
		MsgAlert("INSIRA UMA JUSTIFICATIVA NO CAMPO DE OBSERVAÇÃO!")
		lContinua	:= .F.
	EndIf
EndIf

/*	
If  lContinua
	
	If !INCLUI
		If MsgBox( "Orçamento Alterado!", "Deseja enviar por e-mail?", "YESNO" )
			Processa({ || fEnviaOrc()},"Enviando Pedido...")
		EndIf
	Else
		Processa({ || fEnviaOrc()},"Enviando Pedido...")
	EndIf
	
EndIf
*/
XVL->(dbCloseArea())
//XLL->(dbCloseArea())

Return lContinua

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: XVL
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"COD"     ,"C",015,000} )
Aadd( aFds , {"PROD"    ,"C",030,000} )
Aadd( aFds , {"DESC"    ,"N",014,002} )
Aadd( aFds , {"ULTIMO"  ,"N",014,002} )
Aadd( aFds , {"DIF"     ,"N",014,002} )
Aadd( aFds , {"QTDKG"    ,"N",014,002} )
Aadd( aFds , {"VALKG"    ,"N",014,002} )
Aadd( aFds , {"CUSTO"    ,"N",014,002} )
Aadd( aFds , {"PESO"    ,"N",014,002} )
Aadd( aFds , {"ULTPC"    ,"N",014,002} )
Aadd( aFds , {"IDEAL"    ,"N",014,002} )

If Select("XVL") > 0
	DbSelectArea("XVL")
	XVL->(DbCloseArea())	
EndIf

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias XVL New Exclusive
Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: XLL
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl2()

Local aFds := {}

Aadd( aFds , {"PREF"	,"C",003,000} )
Aadd( aFds , {"NUM"		,"C",009,000} )
Aadd( aFds , {"PARC"	,"C",002,000} )
Aadd( aFds , {"EMISS"   ,"D",008,002} )
Aadd( aFds , {"VENC"   	,"D",008,002} )
Aadd( aFds , {"VALOR"   ,"N",014,002} )
Aadd( aFds , {"SALDO"   ,"N",014,002} )

If Select("XE1") > 0
	DbSelectArea("XE1")
	XE1->(DbCloseArea())	
EndIf

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias XE1 New Exclusive
//Index On PREF+NUM+PARC To ( coTbl2 )

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fDecPad  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o desconto padrao do cliente por produto.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fDecPad(cCli, cLoja, cProd)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT * FROM  " + RetSqlName("ZBB") 
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND ZBB_CLIENT = '" + cCli + "'"
cQry+=" AND ZBB_LOJA >= '" + cLoja + "'" 
cQry+=" AND ZBB_PROD = '" + cProd + "'"

If Select("TMP5") > 0
	DbSelectArea("TMP5")
	TMP1->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

If Select("TMP5") > 0

	nRet := TMP5->ZBB_PERC

EndIf

TMP5->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fUltPco  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o ultimo preco do cliente por produto.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fUltPco(cCli, cLoja, cProd, lAntesAum)

local cQry		:= ''
Local nRet		:= 0
Local cData		:= SuperGetMV("MV_XAUMEND",,"201803")

cQry:=" SELECT TOP 1 C6_PRUNIT FROM " + RetSqlName("SC6") + " C6 "
cQry+=" INNER JOIN " + RetSqlName("SC5") + " C5 "
cQry+=" ON C6_FILIAL = C5_FILIAL "
cQry+=" AND C6_NUM = C5_NUM "
cQry+=" WHERE C6.D_E_L_E_T_ <> '*' "
cQry+=" AND C6_NOTA <> '' "
If lAntesAum
	cQry+=" AND C6_DATFAT < '" + cData + "' "
EndIf
cQry+=" AND C6_SERIE <> 'UNI' "
cQry+=" AND C6_FILIAL = '" + xFilial("SC6") + "'"
cQry+=" AND C5_CLIENTE = '" + cCli + "'"
cQry+=" AND C5_LOJACLI = '" + cLoja + "'" 
cQry+=" AND C6_PRODUTO = '" + cProd + "'"
cQry+=" ORDER BY C6_DATFAT DESC"

If Select("TMP3") > 0
	DbSelectArea("TMP3")
	TMP3->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP3"

dbSelectArea("TMP3")
TMP3->(dbGoTop())

If Select("TMP3") > 0

	nRet := TMP3->C6_PRUNIT

EndIf

TMP3->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValCusto  º Autor ³ Gustavo Costa     º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o desconto padrao do cliente por produto.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValCusto(cSetor, cUF)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT TOP 1 * FROM " + RetSqlName("ZBC") 
cQry+=" WHERE ZBC_SETOR LIKE '%" + cSetor + "%' "
cQry+=" AND ZBC_UF = '" + cUF + "' "
cQry+=" AND D_E_L_E_T_ <> '*'"
cQry+=" ORDER BY ZBC_DATA DESC "

TCQUERY cQry NEW ALIAS  "TMP4"

dbSelectArea("TMP4")
TMP2->(dbGoTop())

If Select("TMP4") > 0

	nRet := TMP4->ZBC_CUSTO

EndIf

TMP4->(dbclosearea())

Return nRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fDetGrupo ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Detalha o sub grupo do pedido de venda                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fTitAbert()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local cNGrupo	 := ""//XLL->LINHA
Local cQtdGRP	 := ""//Transform(XLL->TKG,"@E 9,999,999.99")
Local cTOTGRP	 := ""//Transform(XLL->TVALOR,"@E 9,999,999.99")
Local nTOTGRP	:= 0
Local nQtdGRP	:= 0
Local lVldTA		:= .T.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFontTA","oDlgTA","oBrw3","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3","oBut3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFontTA     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
//oTbl2()

cQry:=" SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO FROM " + RetSqlName("SE1") + " E1 "
cQry+=" WHERE E1_SALDO > 0 "
cQry+=" AND E1_VENCREA <= '" + DtoS(dDatabase - 10) + "'"
cQry+=" AND E1_EMISSAO > '2016'"
cQry+=" AND E1_PREFIXO <> ''"
cQry+=" AND E1_CLIENTE = '" + M->CJ_CLIENTE + "' "
cQry+=" AND E1_TIPO NOT IN ('NCC','RA') "
cQry+=" AND D_E_L_E_T_ <> '*' "

TCQUERY cQry NEW ALIAS  "TMP4"
TCSetField( 'TMP4', "E1_EMISSAO", "D" )
TCSetField( 'TMP4', "E1_VENCREA", "D" )

dbSelectArea("TMP4")
TMP4->(dbGoTop())

While TMP4->(!EOF())

/*	RecLock("XE1", .T.)
	
	XE1->PREF		:= TMP4->E1_PREFIXO
	XE1->NUM		:= TMP4->E1_NUM
	XE1->PARC		:= TMP4->E1_PARCELA
	XE1->EMISS		:= StoD(TMP4->E1_EMISSAO) 
	XE1->VENC		:= StoD(TMP4->E1_VENCREA)
	XE1->VALOR		:= TMP4->E1_VALOR
	XE1->SALDO		:= TMP4->E1_SALDO
	
	XE1->(MsUnLock())
*/		
	nTOTGRP			:= nTOTGRP + TMP4->E1_SALDO
	nQtdGRP			:= nQtdGRP + TMP4->E1_VALOR
	TMP4->(dbSkip())
	
	lVldTA		:= .F.
	
EndDo

cTOTGRP	:= Transform(nTOTGRP,"@E 9,999,999.99")
cQtdGRP := Transform(nQtdGRP,"@E 9,999,999.99")

//TMP4->(dbclosearea())

If !lVldTA

	oDlgTA      := MSDialog():New( 241,176,451,1103,"CLIENTE BLOQUEADO POR TÍTULOS EM ABERTO",,,.F.,,,,,,.T.,,,.F. )
	TMP4->(dbGoTop())
	DbSelectArea("TMP4")
	oBrw3      := MsSelect():New( "TMP4","","",{{"E1_PREFIXO"		,"","Pref.",""},;
												{"E1_NUM"		,"","Numero",""},;
												{"E1_PARCELA"		,"","Parc.",""},;
												{"E1_EMISSAO"	,"","Emissão",""},;
												{"E1_VENCREA"		,"","Vencimento",""},;
												{"E1_VALOR"	,"","Valor Tit.","@E 9,999,999.99"},;
												{"E1_SALDO"	,"","Saldo Tit.","@E 9,999,999.99"}},.F.,,{000,000,080,461},,, oDlgTA ) 
	oBrw3:oBrowse:nClrPane := CLR_BLACK
	oBrw3:oBrowse:nClrText := CLR_BLACK
	
	//oGrp1      := TGroup():New( 080,000,103,171,"SUB GRUPO",oDlgTA,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oSay1      := TSay():New( 087,008,{|| If(PCount()>0,cNGrupo:=u,cNGrupo) },oGrp1,,oFontTA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,013)
	oGrp2      := TGroup():New( 080,172,103,319,"VALOR TOTAL",oDlgTA,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 088,179,{|| If(PCount()>0,cQtdGRP:=u,cQtdGRP) },oGrp2,,oFontTA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,107,013)
	oGrp3      := TGroup():New( 080,321,103,461,"SALDO TOTAL",oDlgTA,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay3      := TSay():New( 088,328,{|| If(PCount()>0,cTOTGRP:=u,cTOTGRP) },oGrp3,,oFontTA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,013)
	
	oBut3      := TButton():New( 080,005,"*** SAIR ***",oDlgTA,,082,024,,,,.T.,,"",,,,.F. )
	oBut3:bAction := {|| oDlgTA:end()}

	oDlgTA:Activate(,,,.T.)

EndIf

TMP4->(DbCloseArea())

Return lVldTA

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl3() - Cria temporario para o Alias: XDET
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl3()

Local aFds := {}

Aadd( aFds , {"COD"     ,"C",015,000} )
Aadd( aFds , {"PRODUTO" ,"C",040,000} )
Aadd( aFds , {"QTDKG"   ,"N",014,002} )
Aadd( aFds , {"VALKG"   ,"N",014,002} )
Aadd( aFds , {"TOTAL"   ,"N",014,002} )
Aadd( aFds , {"VALMIN"  ,"N",014,002} )
Aadd( aFds , {"DIF"     ,"N",014,002} )

If Select("XDET") > 0
	DbSelectArea("XDET")
	XDET->(DbCloseArea())	
EndIf

coTbl3 := CriaTrab( aFds, .T. )
Use (coTbl3) Alias XDET New Exclusive
Return 



/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl4() - Cria temporario para o Alias: XDES
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl4()

Local aFds := {}

Aadd( aFds , {"SERIE" 	,"C",003,000} )
Aadd( aFds , {"NOTA" 	,"C",009,000} )
Aadd( aFds , {"PEDIDO" 	,"C",006,000} )
Aadd( aFds , {"EMISSAO" ,"D",008,000} )
Aadd( aFds , {"QTD"   	,"N",014,002} )
Aadd( aFds , {"VALOR"  	,"N",014,002} )
Aadd( aFds , {"TOTAL"   ,"N",014,002} )
Aadd( aFds , {"DESCONTO","N",014,002} )
Aadd( aFds , {"PRAZO"	,"N",006,000} )

If Select("XDES") > 0
	DbSelectArea("XDES")
	XDES->(DbCloseArea())	
EndIf

coTbl4 := CriaTrab( aFds, .T. )
Use (coTbl4) Alias XDES New Exclusive

Return 


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl5() - Cria temporario para o Alias: XFRT
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl5()

Local aFds := {}

Aadd( aFds , {"NFORI" 	,"C",009,000} )
Aadd( aFds , {"NREDUZ" 	,"C",020,000} )
Aadd( aFds , {"PRODUTO"	,"C",020,000} )
Aadd( aFds , {"EMISSAO" ,"D",008,000} )
Aadd( aFds , {"VALOR"  	,"N",014,002} )

If Select("XFRT") > 0
	DbSelectArea("XFRT")
	XFRT->(DbCloseArea())	
EndIf

coTbl5 := CriaTrab( aFds, .T. )
Use (coTbl5) Alias XFRT New Exclusive

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fDetDesc ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra as 5 ultimas compras deste produto para o cliente  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fDetDesc(cCli, cLoja, cProd)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

Private coTbl4

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg2","oBrw3","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl4()

cQry:=" SELECT TOP 10 D2_COD, D2_DOC, D2_SERIE, D2_EMISSAO, C6_NUM, C6_PDESC, C6_QTDVEN, C6_PRUNIT, "
cQry+=" C6_QTDVEN * C6_PRUNIT TOTAL, E4_PRZMED  FROM " + RetSqlName("SD2") + " D "
cQry+=" INNER JOIN " + RetSqlName("SC6") + " C "
cQry+=" ON C6_NUM = D2_PEDIDO "
cQry+=" AND C6_PRODUTO = D2_COD "
cQry+=" INNER JOIN SF2020 "
cQry+=" ON F2_FILIAL = D2_FILIAL "
cQry+=" AND F2_DOC = D2_DOC "
cQry+=" AND F2_SERIE = D2_SERIE "
cQry+=" INNER JOIN SE4010 "
cQry+=" ON F2_COND = E4_CODIGO "
cQry+=" WHERE D2_CLIENTE = '" + cCli + "' "
cQry+=" AND D2_LOJA = '" + cLoja + "' "
cQry+=" AND D2_COD = '" + cProd + "' "
cQry+=" AND D.D_E_L_E_T_ <> '*' "
cQry+=" AND C.D_E_L_E_T_ <> '*' "
cQry+=" ORDER BY D2_EMISSAO DESC "

TCQUERY cQry NEW ALIAS  "TMP4"

dbSelectArea("TMP4")
TMP4->(dbGoTop())

While TMP4->(!EOF())

	RecLock("XDES", .T.)
	
	XDES->SERIE		:= TMP4->D2_SERIE
	XDES->NOTA		:= TMP4->D2_DOC
	XDES->PEDIDO	:= TMP4->C6_NUM
	XDES->EMISSAO	:= StoD(TMP4->D2_EMISSAO) 
	XDES->QTD		:= TMP4->C6_QTDVEN
	XDES->VALOR		:= TMP4->C6_PRUNIT
	XDES->TOTAL		:= TMP4->TOTAL
	XDES->DESCONTO	:= TMP4->C6_PDESC
	XDES->PRAZO		:= TMP4->E4_PRZMED
	
	XDES->(MsUnLock())
		
	TMP4->(dbSkip())
	
EndDo

TMP4->(dbclosearea())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( 241,176,451,1103,"DETALHE DESCONTOS",,,.F.,,,,,,.T.,,,.F. )


XDES->(dbGoTop())
DbSelectArea("XDES")
oBrw3      := MsSelect():New( "XDES","","",{{"SERIE"	,"","Serie",""},;
											{"NOTA"		,"","Nota",""},;
											{"EMISSAO"	,"","Emissao",""},;
											{"PEDIDO"	,"","Pedido",""},;
											{"QTD"		,"","Quant.","@E 9,999,999.99"},;
											{"VALOR"	,"","Valor","@E 9,999,999.99"},;
											{"TOTAL"	,"","Total","@E 9,999,999.99"},;
											{"DESCONTO"	,"","Desconto","@E 9,999,999.99"},;
											{"PRAZO"	,"","Prazo Med.","@E 999,999"}},.F.,,{001,001,090,461},,, oDlg2 ) 
oBrw3:oBrowse:nClrPane := CLR_BLACK
oBrw3:oBrowse:nClrText := CLR_BLACK
/*
oGrp1      := TGroup():New( 080,000,103,171,"SUB GRUPO",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 087,008,{|| If(PCount()>0,cNGrupo:=u,cNGrupo) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,013)
oGrp2      := TGroup():New( 080,172,103,319,"QUANT. TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 088,179,{|| If(PCount()>0,cQtdGRP:=u,cQtdGRP) },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,107,013)
oGrp3      := TGroup():New( 080,321,103,461,"VALOR TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 088,328,{|| If(PCount()>0,cTOTGRP:=u,cTOTGRP) },oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,013)
*/
oDlg2:Activate(,,,.T.)

XDES->(DbCloseArea())

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fFrtEx ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra as 10 ultimas compras deste cliente tem Extra de frete³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fFrtEx(cCli, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

Private coTbl5

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg5","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl5()

cQry:=" SELECT D1_NFORI, A2_NREDUZ, B1_DESC, D1_TOTAL, D1_EMISSAO  FROM " + RetSqlName("SD1") + " D1 "
cQry+=" INNER JOIN " + RetSqlName("SA2") + " A2 "
cQry+=" ON A2_COD = D1_FORNECE "
cQry+=" AND A2_LOJA = D1_LOJA "
cQry+=" INNER JOIN " + RetSqlName("SB1") + " B1 "
cQry+=" ON B1_COD = D1_COD "
cQry+=" WHERE D1.D_E_L_E_T_ <> '*' "
cQry+=" AND D1_NFORI + D1_SERIORI IN ( "
cQry+=" SELECT TOP 10 F2_DOC + F2_SERIE FROM " + RetSqlName("SF2") + " F2 " 
cQry+=" WHERE F2.D_E_L_E_T_ <> '*' "
cQry+=" AND F2_CLIENTE = '" + cCli + "' "
cQry+=" AND F2_LOJA = '" + cLoja + "' "
cQry+=" ORDER BY F2_EMISSAO DESC ) "
cQry+=" AND D1_TP = 'FR' "

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	RecLock("XFRT", .T.)
	
	XFRT->NFORI		:= TMP5->D1_NFORI
	XFRT->NREDUZ	:= TMP5->A2_NREDUZ
	XFRT->PRODUTO	:= TMP5->B1_DESC
	XFRT->EMISSAO	:= StoD(TMP5->D1_EMISSAO) 
	XFRT->VALOR		:= TMP5->D1_TOTAL
	
	XFRT->(MsUnLock())
		
	TMP5->(dbSkip())
	
EndDo

TMP5->(dbclosearea())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg5      := MSDialog():New( 241,176,451,1103,"DETALHE FRETE EXTRA",,,.F.,,,,,,.T.,,,.F. )


XFRT->(dbGoTop())
DbSelectArea("XFRT")
oBrw5      := MsSelect():New( "XFRT","","",{{"NFORI"	,"","Nota Original",""},;
											{"NREDUZ"	,"","Transportadora",""},;
											{"PRODUTO"	,"","Motivo",""},;
											{"EMISSAO"	,"","Data CTE",""},;
											{"VALOR"	,"","Valor","@E 9,999,999.99"}},.F.,,{001,001,090,461},,, oDlg5 ) 
oBrw5:oBrowse:nClrPane := CLR_BLACK
oBrw5:oBrowse:nClrText := CLR_BLACK

oDlg5:Activate(,,,.T.)

XFRT->(DbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fTotalFE ³ Autor :Gustavo Costa         ³ Data :14/06/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Retorna o total de Extra de frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fTotalFE(cCli, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT D1_NFORI, A2_NREDUZ, B1_DESC, D1_TOTAL, D1_EMISSAO  FROM " + RetSqlName("SD1") + " D1 "
cQry+=" INNER JOIN " + RetSqlName("SA2") + " A2 "
cQry+=" ON A2_COD = D1_FORNECE "
cQry+=" AND A2_LOJA = D1_LOJA "
cQry+=" INNER JOIN " + RetSqlName("SB1") + " B1 "
cQry+=" ON B1_COD = D1_COD "
cQry+=" WHERE D1.D_E_L_E_T_ <> '*' "
cQry+=" AND D1_NFORI + D1_SERIORI IN ( "
cQry+=" SELECT TOP 10 F2_DOC + F2_SERIE FROM " + RetSqlName("SF2") + " F2 " 
cQry+=" WHERE F2.D_E_L_E_T_ <> '*' "
cQry+=" AND F2_CLIENTE = '" + cCli + "' "
cQry+=" AND F2_LOJA = '" + cLoja + "' "
cQry+=" ORDER BY F2_EMISSAO DESC ) "
cQry+=" AND D1_TP = 'FR' "
cQry+=" AND D1_COD <> 'FR0001' "

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	nRet	:= nRet + TMP5->D1_TOTAL
	
	TMP5->(dbSkip())

EndDo

TMP5->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fEnviaOrc º Autor ³ Gustavo Costa     º Data ³  22/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para enviar um email com as          º±±
±±º          ³ pendencias do pedido bloqueado.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fEnviaOrc()

Local cTitulo  	:= "ORCAMENTO - " + M->CJ_NUM
Local cCopia 	:= ""//GetNewPar('RV_XCOPBLQ',"gustavo@ravaembalagens.com.br")
Local cMailTo 	:= ""//"gustavo@ravaembalagens.com.br"
Local cConteudo	:= ""
Local cCodUser 	:= __CUSERID
local cMotivo	:= ""
lOCAL nTotal	:= 0
Local aAnexos	:= {}

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailTo := Alltrim(aUsua[1][14])  	     // e-mail 
Endif

cMailTo := cMailTo + "; comercial@ravaembalagens.com.br"             

dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3") + M->CJ_VEND1)
	cMailTo := cMailTo + ";" + AllTrim(SA3->A3_EMAIL)
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA)

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml'>"
cConteudo +="<head>"
cConteudo +="<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
cConteudo +="<title>Untitled Document</title>"
cConteudo +="</head>"

cConteudo +="<body>"
cConteudo +="<table width='1014' height='63' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#66FF99'><div align='center'><strong>ORCAMENTO - " + M->CJ_NUM + "</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td ><strong>ORCAMENTO</strong></td>"
    cConteudo +="<td colspan='1'>" + M->CJ_NUM + "</td>"
    cConteudo +="<td ><strong>DATA</strong></td>"
    cConteudo +="<td >" + DtoC(M->CJ_EMISSAO) + "</td>"
    cConteudo +="<td ><strong>COND. PG.</strong></td>"
    cConteudo +="<td colspan='3'>" + M->CJ_CONDPAG + " - " + AllTrim(Posicione('SE4',1,xFilial('SE4')+M->CJ_CONDPAG,'E4_DESCRI')) + "</td>"
  cConteudo +="</tr>"

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA)
  
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>CLIENTE</strong></td>"
    cConteudo +="<td colspan='5'>" + M->CJ_CLIENTE + '/' + M->CJ_LOJA + ' - ' + AllTrim(Posicione('SA1',1,xFilial('SA1')+M->CJ_CLIENTE + M->CJ_LOJA,'A1_NOME')) + " </td>"
    cConteudo +="<td ><strong>FONE</strong></td>"
    cConteudo +="<td colspan='2'>" + SA1->A1_TEL + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>END.</strong></td>"
    cConteudo +="<td colspan='4'>" + SA1->A1_END + "</td>"
    cConteudo +="<td ><strong>CEP</strong></td>"
    cConteudo +="<td colspan='3'>" + Transform(SA1->A1_CEP,"@R 99.999-99") + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td ><strong>CIDADE</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_MUN + "</td>"
    cConteudo +="<td ><strong>UF</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_EST + "</td>"
    cConteudo +="<td ><strong>CNPJ</strong></td>"
    cConteudo +="<td colspan='1'>" + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") + "</td>"
    cConteudo +="<td ><strong>I.E.</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_INSCR + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>VENDEDOR</strong></td>"
    cConteudo +="<td colspan='8'>" + M->CJ_VEND1 + ' - ' + AllTrim(Posicione('SA3',1,xFilial('SA3')+M->CJ_VEND1,'A3_NOME')) + " </td>"
  cConteudo +="</tr>"
cConteudo +="</table>"
cConteudo +="<p>&nbsp;</p>"
cConteudo +="<table width='1014' height='93' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#999999'><div align='center'><strong>ITENS</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='91' height='23' bgcolor='#999999'><div align='center'><strong>COD.</strong></div></td>"
    cConteudo +="<td width='275' bgcolor='#999999'><div align='center'><strong>PRODUTO</strong></div></td>"
    //cConteudo +="<td width='51' bgcolor='#999999'><div align='center'><strong>PESO</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>QTD</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>PRECO</strong></div></td>"
    cConteudo +="<td width='91' bgcolor='#999999'><div align='center'><strong>DESC.</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>VALOR</strong></div></td>"
    cConteudo +="<td width='110' bgcolor='#999999'><div align='center'><strong>TOTAL</strong></div></td>"
    //cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>ULT. DESC.</strong></div></td>"
    //cConteudo +="<td width='69' bgcolor='#999999'><div align='center'><strong>MOTIVO</strong></div></td>"
  cConteudo +="</tr>"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())
  

  cConteudo +="<tr>"
    cConteudo +="<td height='23'>" + TMP1->CK_PRODUTO + "</td>"
    cConteudo +="<td>" + TMP1->CK_DESCRI + "</td>"
    //cConteudo +="<td><div align='right'>" + Transform(XVL->PESO,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(TMP1->CK_QTDVEN,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(TMP1->CK_PRUNIT,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(TMP1->CK_PDESC,"@E 999,999,999.99") + "%</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(TMP1->CK_PRCVEN,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(TMP1->CK_VALOR,"@E 999,999,999.99") + "</div></td>"
    //cConteudo +="<td><div align='right'>" + Transform(0,"@E 999,999,999.99") + "</div></td>"
    /*
    If Empty(cMotivo)
    	cConteudo +="<td><div align='center'>OK</div></td>"
    Else
    	cConteudo +="<td><div align='center'>" + "MOTIVO" + "</div></td>"
    EndIf
    */
  cConteudo +="</tr>"
  
  nTotal	:= nTotal + TMP1->CK_VALOR
  
  TMP1->(dbSkip())

EndDo

cConteudo +="<tr>"
cConteudo +="<td colspan='6' width='96' height='23'><strong>TOTAL</strong></td>"
cConteudo +="<td ><div align='right'> R$ " + Transform(nTotal,"@E 999,999,999.99") + "</div></td>"
cConteudo +="</tr>"
cConteudo +="<tr>"
cConteudo +="<td colspan='6' width='96' height='23'><strong>TOTAL COM IPI</strong></td>"
cConteudo +="<td ><div align='right'> R$ " + Transform(nTotal * 1.15,"@E 999,999,999.99") + "</div></td>"
cConteudo +="</tr>"

cConteudo +="<tr>"
cConteudo +="<td width='96' height='23'><strong>JUSTIF.</strong></td>"
cConteudo +="<td colspan='8' >" + AllTrim(M->CJ_OBSERVA) + " </td>"
cConteudo +="</tr>"

cConteudo +="</table>"
cConteudo +="Orcamento Transmitido em: " + DtoC(dDataBase) + " " + Time()

cConteudo +="</body>"
cConteudo +="</html>"

cAnexo	:= ""
Memowrite("D:\Temp\pedido.html", cConteudo)
ConOut("**** CONTEUDO ****")
ConOut(cConteudo)

//lEnviado := U_fEnvMail(cMailTo, cTitulo, cConteudo, aAnexos, .T., .F.)
lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

If lEnviado
	MsgAlert("Email enviado com sucesso! " + cMailTo)
Else
	MsgAlert("Problema no envio do email!")
EndIf

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fVldCli  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida cliente do vendedor no orcamento.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fVldCli()

local cVendCli		:= ""
Local cVenUSR		:= "" //AllTrim(Posicione("SA3",7,RetCodUsr(),"A3_COD"))
Local cUserLib		:= AllTrim(GetNewPar("MV_XVENLIB","000000/000000"))
Local lVldCli			:= .F.
Local aArea			:= GetArea()

dbSelectArea("SA1")
DbSeek(xFilial("SA1") + M->CJ_CLIENTE)
cVendCli		:= AllTrim(SA1->A1_VEND)

dbSelectArea("SA3")
dbSetOrder(7)
DbSeek(xFilial("SA3") + RetCodUsr())
cVenUSR		:= AllTrim(SA3->A3_COD)

//MSGALERT(SA1->A1_COD +' - '+ SA1->A1_VEND + ' cVendCli ' + cVendCli + ' cVenUSR ' + cVenUSR)

If (RetCodUsr() $ cUserLib)

	lVldCli	:= .T.

Else
	
	If cVendCli == cVenUSR

		lVldCli	:= .T.
	
	Else
		
		MsgAlert("SELECIONE UM CLIENTE ASSOCIADO AO SEU CÓDIGO DE VENDEDOR!")
	
	EndIf 

EndIf

RestArea(aArea)

Return lVldCli
