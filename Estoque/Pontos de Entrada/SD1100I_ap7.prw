#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "Topconn.ch"

User Function SD1100I()     // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//PONTO DE ENTRADA - GRAVAÇÃO POR ITEM
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cNF := SD1->D1_DOC
Local cSerie := SD1->D1_SERIE
Local nSD7_1 := 0  //para o recno do SD7	
 
Local cQuery := ""
Local cD1NUMCQ := "" 
Local cD1NumSeq := ""

Local LF := CHR(13) + CHR(10)

Local cTexto := ""

SetPrvt("LFLAG,CALIAS,NREGD1,CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SD1100I                                          ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de itens notas fiscais de entrada - RAVA            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
cD1NUMCQ := SD1->D1_NUMCQ
cD1NumSeq:= SD1->D1_NUMSEQ
nQuant   := SD1->D1_QUANT

lFlag  := .T.
cAlias := dbSelectArea("SM0")
nRegD1 := SD1->( Recno() )

//tratamento especial para cópia entre filiais....
if SM0->M0_CODIGO == "02" .and. SD1->D1_SERIE $ "UNI/0  "

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Grava itens de nota fiscal na Rava                           ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XD1" ) == 0
      cArq := "SD1010"
      Use (cArq) ALIAS XD1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
   
   XD1->(DbSetOrder(1))
   
   if XD1->(DbSeek(xFilial("SD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM)))
      RecLock( "XD1", .F. )//Classificacao de Pre-Nota entao Altera
   else     
      RecLock( "XD1", .T. )//Inclusão de Nota ou Pre-nota
   endif      

   XD1->D1_FILIAL  := XFILIAL( "SD1" ); XD1->D1_COD     := SD1->D1_COD
   XD1->D1_UM      := SD1->D1_UM   ;    XD1->D1_SEGUM   := SD1->D1_SEGUM
   XD1->D1_QUANT   := SD1->D1_QUANT  ;  XD1->D1_VUNIT   := SD1->D1_VUNIT
   XD1->D1_TOTAL   := SD1->D1_TOTAL ;   XD1->D1_VALIPI  := SD1->D1_VALIPI
   XD1->D1_VALICM  := SD1->D1_VALICM ;  XD1->D1_TES     := SD1->D1_TES
   XD1->D1_CF      := SD1->D1_CF     ;  XD1->D1_DESC    := SD1->D1_DESC
   XD1->D1_IPI     := SD1->D1_IPI    ;  XD1->D1_PICM    := SD1->D1_PICM
   XD1->D1_PESO    := SD1->D1_PESO   ;  XD1->D1_CONTA   := SD1->D1_CONTA
   XD1->D1_CC      := SD1->D1_CC     ;  XD1->D1_PEDIDO  := SD1->D1_PEDIDO
   XD1->D1_ITEMPV  := SD1->D1_ITEMPV ;  XD1->D1_FORNECE := SD1->D1_FORNECE
   XD1->D1_LOJA    := SD1->D1_LOJA   ;  XD1->D1_LOCAL   := SD1->D1_LOCAL
   XD1->D1_DOC     := SD1->D1_DOC    ;  XD1->D1_EMISSAO := SD1->D1_EMISSAO
   XD1->D1_OP      := SD1->D1_OP     ;  XD1->D1_DTDIGIT := SD1->D1_DTDIGIT
   XD1->D1_GRUPO   := SD1->D1_GRUPO  ;  XD1->D1_TIPO    := SD1->D1_TIPO
   XD1->D1_SERIE   := SD1->D1_SERIE  ;  XD1->D1_CUSTO   := SD1->D1_CUSTO
   XD1->D1_CUSTO2  := SD1->D1_CUSTO2 ;  XD1->D1_CUSTO3  := SD1->D1_CUSTO3
   XD1->D1_CUSTO4  := SD1->D1_CUSTO4 ;  XD1->D1_CUSTO5  := SD1->D1_CUSTO5
   XD1->D1_TP      := SD1->D1_TP     ;  XD1->D1_QTSEGUM := SD1->D1_QTSEGUM
   XD1->D1_NUMSEQ  := SD1->D1_NUMSEQ ;  XD1->D1_DATACUS := SD1->D1_DATACUS
   XD1->D1_NFORI   := SD1->D1_NFORI  ;  XD1->D1_SERIORI := SD1->D1_SERIORI
   XD1->D1_ITEMORI := SD1->D1_ITEMORI;  XD1->D1_QTDEDEV := SD1->D1_QTDEDEV
   XD1->D1_VALDEV  := SD1->D1_VALDEV ;  XD1->D1_ORIGLAN := SD1->D1_ORIGLAN
   XD1->D1_ICMSRET := SD1->D1_ICMSRET;  XD1->D1_BRICMS  := SD1->D1_BRICMS
   XD1->D1_NUMCQ   := SD1->D1_NUMCQ  ;  XD1->D1_ITEM    := SD1->D1_ITEM
   XD1->D1_BASEICM := SD1->D1_BASEICM;  XD1->D1_VALDESC := SD1->D1_VALDESC
   XD1->D1_IDENTB6 := SD1->D1_IDENTB6;  XD1->D1_LOTEFOR := SD1->D1_LOTEFOR
   XD1->D1_SKIPLOT := SD1->D1_SKIPLOT;  XD1->D1_BASEIPI := SD1->D1_BASEIPI
   XD1->D1_SEQCALC := SD1->D1_SEQCALC;  XD1->D1_LOTECTL := SD1->D1_LOTECTL
   XD1->D1_NUMLOTE := SD1->D1_NUMLOTE;  XD1->D1_DTVALID := SD1->D1_DTVALID
   XD1->D1_PLACA   := SD1->D1_PLACA  ;  XD1->D1_CHASSI  := SD1->D1_CHASSI
   XD1->D1_ANOFAB  := SD1->D1_ANOFAB ;  XD1->D1_MODFAB  := SD1->D1_MODFAB
   XD1->D1_MODELO  := SD1->D1_MODELO ;  XD1->D1_COMBUST := SD1->D1_COMBUST
   XD1->D1_COR     := SD1->D1_COR    ;  XD1->D1_EQUIPS  := SD1->D1_EQUIPS
   XD1->D1_FORMUL  := SD1->D1_FORMUL ;  XD1->D1_II      := SD1->D1_II
   XD1->D1_TEC     := SD1->D1_TEC    ;  XD1->D1_CONHEC  := SD1->D1_CONHEC
   XD1->D1_NUMPV   := SD1->D1_NUMPV  ;  XD1->D1_ITEMPV  := SD1->D1_ITEMPV
   XD1->D1_CLASFIS := SD1->D1_CLASFIS;  XD1->D1_CUSFF1  := SD1->D1_CUSFF1
   XD1->D1_CUSFF2  := SD1->D1_CUSFF2 ;  XD1->D1_CUSFF3  := SD1->D1_CUSFF3
   XD1->D1_CUSFF4  := SD1->D1_CUSFF4 ;  XD1->D1_CUSFF5  := SD1->D1_CUSFF5
   XD1->( MSUNLOCK() )
   XD1->( DBCOMMIT() )
endif
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)

//ATUALIZAÇÕES A RESPEITO DA INSPEÇÃO DE ENTRADAS

SB1->(Dbsetorder(1))
If SB1->(Dbseek(xFilial("SB1") + SD1->D1_COD ))
	If Alltrim(SB1->B1_RAVACQ) = 'Q'
		///LOCALIZA SD7 1 
		cQuery := " select R_E_C_N_O_ AS REG,* from " + RetSqlName("SD7") + " SD7 " + LF
		cQuery += " where D7_DOC = '" + Alltrim(cNF) + "' " + LF
		cQuery += " and D7_SERIE = '" + Alltrim(cSerie) + "' " + LF
		cQuery += " and D7_NUMSEQ = '' " + LF
		cQuery += " and SD7.D7_FILIAL = '" + xFilial("SD7") + "' " + LF
		cQuery += " and SD7.D_E_L_E_T_ = '' " + LF
				
		If Select("SD7X") > 0
			DbSelectArea("SD7X")
			DbCloseArea()
		EndIf
			
		TCQUERY cQuery NEW ALIAS "SD7X"
				
		SD7X->( DBGoTop() )
			
		Do While !SD7X->( Eof() )
			nSD7_1 := SD7X->REG
			SD7X->(DBSKIP())
		Enddo 
		
		
		If nSD7_1 > 0    //só irá posicionar no recno se o mesmo existir....
			Dbselectarea("SD7")
			SD7->( dbGoto( nSD7_1 ) )             
			If RecLock("SD7",.F.)
				SD7->D7_NUMSEQ := cD1NumSeq
				SD7->(MsUnlock())
			Endif
		Endif
		
		
		////FIM DA ATUALIZAÇÃO REF. INSP. ENTRADA
    Endif		//do SB1->B1_RAVACQ
Endif

//--------------------------------------------------------------------------------------------------------------
/////////////////////////////////////////////
///COMEÇO DO TRATAMENTO PARA AUTOMATIZAR REQUISIÇÃO DE ARMAZEM
/////////////////////////////////////////////
cPedido := SD1->D1_PEDIDO
cItemPed:= SD1->D1_ITEMPC
cNumSC  := ""  //número da solicitação de compra
cItemSC := ""  //item da SC 
cSolici := ""  //solicitante da SC
cProdSC := ""

//AQUI CAPTURA O NÚMERO DA SC, QUE FICOU GRAVADA NO PEDIDO DE COMPRA
SC7->(DBSETORDER(1))                                     //DEFINE QUE O INDICE 1 SERÁ UTILIZADO NA AREA DE TRABALHO ATIVA
If SC7->(DBSEEK(xFilial("SC7") + cPedido + cItemPed ))   //PROCURA NO PEDIDO DE COMPRA O NUMERO E O ITEM DA SC
	cNumSC := SC7->C7_NUMSC                              //GRAVA O NUMERO DA SC NA VARIÁVEL cNumSC
	cItemSC:= SC7->C7_ITEMSC                             //GRAVA O ITEM DA SC NA VARIÁVEL cItemSC
Endif

//AQUI CAPTURA DETALHES DA SC...
SC1->(DBSETORDER(1))                                     //DEFINE QUE O INDICE 1 SERÁ UTILIZADO NA AREA DE TRABALHO ATIVA
If SC1->(DBSEEK(xFilial("SC1") + cNumSC + cItemSC ))     //PROCURA NO PEDIDO DE COMPRA O NUMERO E O ITEM DA SC
	cSolici := SC1->C1_SOLICIT							 //GRAVA O NOME DO SOLICITANTE NA VARIÁVEL cSolici
	cProdSC := SC1->C1_PRODUTO
							                             //GRAVA O NOME PRODUTO NA VARIÁVEL cProdSC
    
														 //SÓ FARÁ O QUE ESTÁ ABAIXO, CASO ENCONTRE A S.C
														 //COMEÇO DA GRAVAÇÃO DAS INFORMAÇÕES.
														 //SCP->(DbSetOrder(1))                                           
	//AQUI não tem como buscar por número de solicitação de compra, pois este campo não é chave de índice
	//	IF SCP->(DBSEEK(XfILIAL("SCP" + SCP->C1_NUM + SCP->CP_ITEM))
	
	//Então...fiz:
	//A QUERY ABAIXO É SÓ PRA SABER SE JÁ EXISTE ALGUM REGISTRO COM ESTA SOLICITAÇÃO DE COMPRA E ITEM E PRODUTO na SCP
	
	cQuery := " SELECT R_E_C_N_O_ AS REGSCP, * FROM  "
	cQuery += " " + RetSqlName("SCP") + " SCP "
	cQuery += " Where CP_NUMSC = '" + Alltrim(cNumSC) + "' "
	cQuery += " and CP_ITSC    = '" + Alltrim(cItemSC)+ "' "
	cQuery += " and CP_PRODUTO = '" + Alltrim(cProdSC)+ "' "
	cQuery += " AND CP_FILIAL = '" + xFilial("SCP") + "' "
	cQuery += " AND D_E_L_E_T_ = '' " 
	If Select("SCPX") > 0
		DbSelectArea("SCPX")
		DbCloseArea()
	EndIf
	TCQUERY cQuery NEW ALIAS "SCPX"
	SCPX->( DBGoTop() )
	If !SCPX->(EOF())    							    //SE ENCONTROU DADOS, NÃO IRÁ GRAVAR NOVOS DADOS
						 								//NÃO FAZ NENHUMA AÇÃO
	Else
	
	  													
	cNumREQ    := GetSXENum("SCP","CP_NUM")             //BUSCAR NÚMERO PARA A REQUISIÇÃO
	SCP->(DBSETORDER(1))                                //USA O PRIMEIRO INDICE
	SCP->(DBGOTOP())                                    //POSICIONA NO COMEÇO
	while SCP->( DbSeek( xFilial( "SCP" ) + cNumREQ ) ) //PROCURA NA SCP, SE JÁ EXISTE O NÚMERO GERADO 
	   ConfirmSX8()                						//CASO ENCONTRE, ELE ENTRA AQUI, E AÍ, ELE GRAVA ...
	   cNumREQ := GetSXENum("SCP","CP_NUM")   			//E BUSCA UM PRÓXIMO NÚMERO, ATÉ QUE ESTE NÃO EXISTA NA BASE
	ENDDO
		
			//FIM DA BUSCA NUM. SOLIC
			//NÃO ENCONTROU NENHUM DADO, ENTÃO PODE GRAVAR NA SCP
			DbselectArea("SCP")
			RecLock( "SCP", .T. )
			
			SCP->CP_FILIAL  := XFILIAL( "SC1" ) 
			SCP->CP_NUM     := cNumREQ  //número gerado da requisição
			SCP->CP_ITEM    := SUBSTR(SC1->C1_ITEM,3,2)
			SCP->CP_SOLICIT := cSolici
			SCP->CP_PRODUTO := cProdSC //SC1->C1_PRODUTO    //coloca o conteúdo da SC1 e SC7 em variáveis, pois garante q o registro não se desposicionará  
			SCP->CP_DESCRI  := SC1->C1_DESCRI               //faça o mesmo nos outros e do SC7 tb, plis
			SCP->CP_UM      := SC1->C1_UM
			SCP->CP_QUANT   := SC7->C7_QUANT
			SCP->CP_LOCAL   := SC1->C1_LOCAL
			SCP->CP_QTSEGUM := SC7->C7_QUANT
			SCP->CP_DATPRF  := Date()
			SCP->CP_CC      := SC7->C7_CC
			SCP->CP_CONTA   := SC7->C7_CONTA
			SCP->CP_NUMSC   := SC1->C1_NUM
			SCP->CP_ITSC    := SC1->C1_ITEM 
	   		SCP->CP_USER    := SC1->C1_USER
			SCP->CP_EMISSAO := Date()
			SCP->CP_STATUS  := ""
		    
		  	SX5->(Dbsetorder(1))
		 		If SX5->(Dbseek(xFilial("SX5") + "ST" + SC1->C1_USER))
			  		SCP->CP_GRUPO := SX5->X5_DESCRI
			  	ENDIF   
			SCP->(MsUnlock())       
		    
		
	ENDIF
	
Endif //do dbseek na SC1
//TERMINO AQUI
//"FIM" DO TRATAMENTO PARA REQUISIÇÃO AO ARMAZÉM
//--------------------------------------------------------------------------------------------------------------

Return(lFlag)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
