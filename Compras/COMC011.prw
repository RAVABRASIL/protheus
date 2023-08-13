#INCLUDE "rwmake.ch"
#include "topconn.ch"
//#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COMC011  � Autor � Fl�via Rocha       � Data �  27/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para Atualiza��o do Frete e Prazo Pagto. Frete        ���
���          � a ser utilizada pela Log�stica.                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMC011


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFiltro	:= ""
Local aIndexSC8	:= {}

Local aCores	:= {	{  '!Empty(C8_VALFRE)',	'BR_VERMELHO'},;	// FRETE REGISTRADO
								{  'Empty(C8_VALFRE)',	'BR_VERDE'} }		// SEM REGISTRO FRETE
								
Private cCadastro  := "Atualiza��o do Frete Compras"
Private bFiltraBrw := {} 
//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VisuFre()",0,2} ,;
             {"Atualizar","U_AtuFre()",0,4},;
             {"Legenda"   ,	"U_FreLeg()"	,0,5} }	   

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SC8"

Private aCampos := { {"Num.Cotacao", "C8_NUM"},;
					{"Tipo Frete", "C8_TPFRETE"} }


dbSelectArea("SC8")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������
cFiltro	:= "C8_TPFRETE = 'F' "



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

**********************
User Function AtuFre()
**********************

Local nElevado := 0
Local nResult  := 0 
Local nPECUSTO := 0   //PESO DO CUSTO -> ( TOTAL ITEM / ITEM de MENOR TOTAL )-1 
Local nPACUSTO := 0   //PARCELA DO CUSTO -> (TOTAL ITEM / ITEM de MENOR TOTAL)
Local nPEPRAZO := 0   //PESO DO PRAZO -> 1 - PESO CUSTO
Local nPAPRAZO := 0   //PARCELA DO PRAZO -> (MAIOR DOS PRAZOS PONDERADOS / PRAZO PONDERADO )
Local nPrazoit := 0   //prazo pagto item
Local nPrazoFR := 0 //SC8->C8_PRZPFRE //prazo pagto frete do item 
Local nTOTALit := 0
Local nFatMult := 0   //fator multiplicador do CT
Local nCIVP    := 0 //custo do item a valor presente
Local nCFVP	   := 0 //custo do frete a valor presente
Local nCUSTOTVP:= 0 // soma do custo vp item + custo vp frete
Local nValFreit:= 0 //SC8->C8_VALFRE
Local nMenorCSTVP := 0
Local nMaiorPRZPON:= 0
Local nOpcao      := 0
Local nValFre     := 0
Local nPRZPgFre   := 0

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/
Local cForn    := SC8->C8_FORNECE
Local cLj      := SC8->C8_LOJA

Local cTPFRE   := SC8->C8_TPFRETE
Local cDescFRE := iif(Alltrim(cTPFRE) = "F", "FOB" , iif( Alltrim(cTPFRE) = "C" , "CIF" , "Outros" ) )
Local cProd    := SC8->C8_PRODUTO
Private cIT        := SC8->C8_ITEM
Private cNumCot    := SC8->C8_NUM




/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/
Private cIT        := SC8->C8_ITEM
Private cNomeFor   := Posicione('SA2',1,xFilial("SA2")+cForn + cLj,"A2_NOME") 
Private cNumCot    := SC8->C8_NUM
Private nPRZPgFre  := 0
Private nValFre    := 0 
Private PJ         := 0 // % de juros 
Private cTIPROD    := ""
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgFre","oGrp1","oSayValFre","oSayPrzPFre","oSayDias","oGetValFre","oGetPrzPFR","oSBtnOK","oSBtnCAN")
SetPrvt("oGetCot","oSayProd","oGetProd","oSayIT","oGetIT","oGetTPFRE","oSayTPFRE","oGetFORN","oSayFORN")

IF !Empty(SC8->C8_NUMPED) .and. !Empty(SC8->C8_ITEMPED)
	   Aviso( "FRETE", "Esta Cota��o J� Gerou Pedido de Compra, Atualiza��o N�o Permitida !", {"Ok"})   
	   Return .F.
Endif

If SB1->(Dbseek(xFilial("SB1") + cProd ))
	cTIPROD := SB1->B1_TIPO
Endif

If cTIPROD $ "MP/MS/AC/ME"


	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlgFre    := MSDialog():New( 126,254,408,807,"Informa��es Frete",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 004,007,114,267," Informe Aqui : ",oDlgFre,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSayValFre := TSay():New( 076,016,{||"Valor Frete R$:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,045,008)
	oSayPrzPFr := TSay():New( 097,016,{||"Prazo Pagto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSayDias   := TSay():New( 096,124,{||"     ( Dias )"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
	oGetValFre := TGet():New( 074,060,,oGrp1,064,010,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFre",,)
	oGetValFre:bSetGet := {|u| If(PCount()>0,nValFre:=u,nValFre)}
	
	oGetPrzPFR := TGet():New( 096,060,,oGrp1,064,010,'@E 999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPRZPgFre",,)
	oGetPrzPFR:bSetGet := {|u| If(PCount()>0,nPRZPgFre:=u,nPRZPgFre)}
	
	
	oSayCot    := TSay():New( 016,016,{||"Cota��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGetCot    := TGet():New( 013,065,,oGrp1,063,009,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNumCot",,)
	oGetCot:bSetGet := {|u| If(PCount()>0,cNumCot:=u,cNumCot)}
	
	oSayProd   := TSay():New( 032,144,{||"Produto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGetProd   := TGet():New( 032,184,,oGrp1,064,010,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cProd",,)
	oGetProd:bSetGet := {|u| If(PCount()>0,cProd:=u,cProd)}
	
	oSayIT     := TSay():New( 032,016,{||"Item"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oGetIT     := TGet():New( 030,065,,oGrp1,027,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cIT",,)
	oGetIT:bSetGet := {|u| If(PCount()>0,cIT:=u,cIT)}
	
	oGetTPFRE  := TGet():New( 013,184,,oGrp1,063,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescFRE",,)
	oGetTPFRE:bSetGet := {|u| If(PCount()>0,cDescFRE:=u,cDescFRE)}
	
	oSayTPFRE  := TSay():New( 013,144,{||"Tipo Frete"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGetFORN   := TGet():New( 052,064,,oGrp1,183,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeFor",,)
	oGetFORN:bSetGet := {|u| If(PCount()>0,cNomeFor:=u,cNomeFor)}
	
	oSayFORN   := TSay():New( 055,016,{||"Fornecedor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	
	oSBtnOK    := SButton():New( 120,147,1,,oDlgFre,,"", )
	oSBtnOK:bAction := {|| (nOpcao := 1, oDlgFre:End() )} 
	
	oSBtnCAN   := SButton():New( 120,203,2,,oDlgFre,,"", ) 
	oSBtnCAN:bAction := {|| (nOpcao:= 0,oDlgFre:End())} 
	
	oDlgFre:Activate(,,,.T.)
	
	If nOpcao = 1
		nPrazoFR := nPRZPgFre
		nValFreit:= nValFre
		
		If RecLock("SC8", .F.)
			////c�lculo do custo item a valor presente:
			SE4->(Dbsetorder(1))
			SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
			nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
			nElevado	:= nPrazoIT / 30 
			//nResult		:= ( 1 + (1.1 / 100) ) ^ nElevado
			SX5->(Dbsetorder(1))
			SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
			PJ := VAL(ALLTRIM(SX5->X5_DESCRI))
			nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
			
			nTOTALit    := 	SC8->C8_PRECO * SC8->C8_QUANT
			nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = pre�o unit�rio / ( ( 1 + taxa juros m�s) ^ ( prazo / 30 dias) )
			///fim do c�lculo CI
				
			///C�LCULO DO CUSTO FRETE A VALOR PRESENTE
			//nValFreit := SC8->C8_VALFRE		
			nElevado 	:= nPrazoFR / 30
			//nResult 	:= (  1 + (1.1 / 100) ) ^ nElevado
			nResult 	:= (  1 + (PJ / 100) ) ^ nElevado
			nCFVP		:= ( nValFreit / nResult )	// CUSTO FRETE VALOR PRESENTE = valor frete / ( ( 1 + taxa juros m�s) ^ ( prazo / 30 dias) )		
			//fim c�lculo do CUSTO FRETE VP
			
			///CUSTO TOTAL DO ITEM A VP:
			nCUSTOTVP 		:= nCIVP + nCFVP
			
			///C�LCULO DO PRAZO M�DIO PONDERADO DE ENTREGA: 
			nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
			//fim do c�lculo do prazo m�dio entrega ponderado
				
			///c�lculo do fator multiplicador do Custo Equivalente
			nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cota��o selecionada
			nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4 )
			nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
			nMaiorPRZPON:= 0
			nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
			If nMaiorPRZPON <= 0
				nMaiorPRZPON := nPrazoit
			Endif
			nPEPRAZO		:= 1 - nPECUSTO
			nPAPRAZO		:= nMaiorPRZPON / nPrzPONDit  //MAIOR PRAZO M�DIO PONDERADO / PRAZO M�DIO PONDERADO DO ITEM
			nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO) , 4 )
			///fim do c�lculo fator multiplicador do CT
				
			RecLock("SC8", .F.)
			SC8->C8_VALFRE  := nValFreit
			SC8->C8_PRZPFRE := nPrazoFR
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
			///
			SC8->(MsUnlock())
			
			//envia email retorno informando que o Frete foi atualizado
			fEnviaRetorno(cNumCOT, cForn, cLj, cIT )
			//fim do email retorno
		Endif //atualiza o item corrente
			SC8->(Dbsetorder(1))                    
			SC8->(Dbgotop())
			SC8->(Dbseek(xFilial("SC8") + cNumCot ))
			While !SC8->(EOF()) .and. SC8->C8_FILIAL == xFilial("SC8") .and. SC8->C8_NUM == cNumCot
			    nPrazoFR := SC8->C8_PRZPFRE
			    nValFreit := SC8->C8_VALFRE
				SE4->(Dbsetorder(1))
				SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
				
				////c�lculo do custo item a valor presente:
				nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
				nElevado	:= nPrazoIT / 30
				SX5->(Dbsetorder(1))
				SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
				PJ := VAL(ALLTRIM(SX5->X5_DESCRI)) 
				nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
				nTOTALit    := 	SC8->C8_PRECO * SC8->C8_QUANT
				nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = pre�o unit�rio / ( ( 1 + taxa juros m�s) ^ ( prazo / 30 dias) )
				///fim do c�lculo CI
				
				///C�LCULO DO CUSTO FRETE A VALOR PRESENTE		
				If nPrazoFR > 0
					nElevado 	:= nPrazoFR / 30
				Else
					nPrazoFR := 30
					nElevado := nPrazoFR / 30
				Endif
				
				nResult 	:= ( 1 + ( PJ / 100) ) ^ nElevado
				nCFVP		:= ( nValFreit / nResult )	// CUSTO FRETE VALOR PRESENTE = valor frete / ( ( 1 + taxa juros m�s) ^ ( prazo / 30 dias) )		
				//fim c�lculo do CUSTO FRETE VP
				
				///CUSTO TOTAL DO ITEM A VP:
				nCUSTOTVP 		:= nCIVP + nCFVP
				
				///C�LCULO DO PRAZO M�DIO PONDERADO DE ENTREGA: 
				nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
				//fim do c�lculo do prazo m�dio entrega ponderado
				
				///c�lculo do fator multiplicador do Custo Equivalente
				nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cota��o selecionada
				nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4)
				nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
				nMaiorPRZPON:= 0
				nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
				If nMaiorPRZPON <= 0
					nMaiorPRZPON := nPrazoit
				Endif
				nPEPRAZO		:= 1 - nPECUSTO
				nPAPRAZO		:= nMaiorPrzPON / nPrzPONDit  //MAIOR PRAZO M�DIO PONDERADO / PRAZO M�DIO PONDERADO DO ITEM
				nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO)  , 4 )
				///fim do c�lculo fator multiplicador do CT
				
				RecLock("SC8", .F.)    
				SC8->C8_VALFRE  := nValFreit
				SC8->C8_PRZPFRE := nPrazoFR
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
				///
				SC8->(MsUnlock())
			
				SC8->(DBSKIP())
			Enddo
	Endif           
	
Else
	Alert("O Tipo do Produto n�o Permite altera��es de Frete!")
Endif //tipo produto	

Return nil


//visualizar
**********************
User Function VisuFre()
**********************

Local nPrazoFR := SC8->C8_PRZPFRE //prazo pagto frete do item 
Local nTOTALit := 0
Local nValFre:= SC8->C8_VALFRE
Local nPRZPgFre:= SC8->C8_PRZPFRE

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/
Local cForn    := SC8->C8_FORNECE
Local cLj      := SC8->C8_LOJA

Local cTPFRE   := SC8->C8_TPFRETE
Local cDescFRE := iif(Alltrim(cTPFRE) = "F", "FOB" , iif( Alltrim(cTPFRE) = "C" , "CIF" , "Outros" ) )
Local cProd    := SC8->C8_PRODUTO
Private cIT        := SC8->C8_ITEM
Private cNumCot    := SC8->C8_NUM




/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis do Tipo Local, Private e Public                 ��
ٱ�������������������������������������������������������������������������*/
Private cIT        := SC8->C8_ITEM
Private cNomeFor   := Posicione('SA2',1,xFilial("SA2")+cForn + cLj,"A2_NOME") 
Private cNumCot    := SC8->C8_NUM

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgFre","oGrp1","oSayValFre","oSayPrzPFre","oSayDias","oGetValFre","oGetPrzPFR","oSBtnOK","oSBtnCAN")
SetPrvt("oGetCot","oSayProd","oGetProd","oSayIT","oGetIT","oGetTPFRE","oSayTPFRE","oGetFORN","oSayFORN")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgFre    := MSDialog():New( 126,254,408,807,"Informa��es Frete",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 004,007,114,267," Informe Aqui : ",oDlgFre,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayValFre := TSay():New( 076,016,{||"Valor Frete R$:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,045,008)
oSayPrzPFr := TSay():New( 097,016,{||"Prazo Pagto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSayDias   := TSay():New( 096,124,{||"     ( Dias )"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
oGetValFre := TGet():New( 074,060,,oGrp1,064,010,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nValFre",,)
oGetValFre:bSetGet := {|u| If(PCount()>0,nValFre:=u,nValFre)}

oGetPrzPFR := TGet():New( 096,060,,oGrp1,064,010,'@E 999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nPRZPgFre",,)
oGetPrzPFR:bSetGet := {|u| If(PCount()>0,nPRZPgFre:=u,nPRZPgFre)}


oSayCot    := TSay():New( 016,016,{||"Cota��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetCot    := TGet():New( 013,065,,oGrp1,063,009,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNumCot",,)
oGetCot:bSetGet := {|u| If(PCount()>0,cNumCot:=u,cNumCot)}

oSayProd   := TSay():New( 032,144,{||"Produto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetProd   := TGet():New( 032,184,,oGrp1,064,010,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cProd",,)
oGetProd:bSetGet := {|u| If(PCount()>0,cProd:=u,cProd)}

oSayIT     := TSay():New( 032,016,{||"Item"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
oGetIT     := TGet():New( 030,065,,oGrp1,027,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cIT",,)
oGetIT:bSetGet := {|u| If(PCount()>0,cIT:=u,cIT)}

oGetTPFRE  := TGet():New( 013,184,,oGrp1,063,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescFRE",,)
oGetTPFRE:bSetGet := {|u| If(PCount()>0,cDescFRE:=u,cDescFRE)}

oSayTPFRE  := TSay():New( 013,144,{||"Tipo Frete"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetFORN   := TGet():New( 052,064,,oGrp1,183,008,'',,CLR_BLACK,CLR_GRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeFor",,)
oGetFORN:bSetGet := {|u| If(PCount()>0,cNomeFor:=u,cNomeFor)}

oSayFORN   := TSay():New( 055,016,{||"Fornecedor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oSBtnOK    := SButton():New( 120,147,1,,oDlgFre,,"", )
oSBtnOK:bAction := {|| (nOpcao := 1, oDlgFre:End() )} 

oSBtnCAN   := SButton():New( 120,203,2,,oDlgFre,,"", ) 
oSBtnCAN:bAction := {|| (nOpcao:= 0,oDlgFre:End())} 

oDlgFre:Activate(,,,.T.)

	

Return nil                                
                                

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
User Function FreLeg()
******************************************************************************************************


BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Frete OK"} ,;
									{"BR_VERDE" ,	"Sem Registro Frete"} } )

Return .T.
                                    
**********************************************************
Static Function fEnviaRetorno(cNumCOT , cForn, cLj, cIT)
**********************************************************
                                            
Local nQuant	:= 0
Local nPreco	:= 0
Local cProd		:= ""
Local dPREVENT	:= Ctod("  /  /    ")
Local nValFRE	:= 0
Local nPRZPFRE	:= 0
Local cTipoFRE  := ""
Local cNomeFor := Posicione('SA2',1,xFilial("SA2")+cForn + cLJ,"A2_NREDUZ") 

SC8->(DbsetOrder(1))
If SC8->(Dbseek(xFilial("SC8") + cNumCOT + cForn + cLj + cIT ))
	nQuant := SC8->C8_QUANT
	nPreco := SC8->C8_PRECO
	dPREVENT := SC8->C8_DATPRF
	cProd    := SC8->C8_PRODUTO
	nValFRE  := SC8->C8_VALFRE
	nPRZPFRE := SC8->C8_PRZPFRE
	cTipoFRE := SC8->C8_TPFRETE

	oProcess:=TWFProcess():New("MT150GRV","MT150GRV")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\MT150GRV.htm")
	oHtml   := oProcess:oHtml
	
	cCabeca := "Aviso de Atualiza��o de Frete na Cota��o"
	cMsg    := "Informamos que a Seguinte Cota��o teve seu Valor e Prazo Pagto Frete Atualizados: "
			
	aadd( oHtml:ValByName("it.cCOT")     , cNumCOT )                                            
	aadd( oHtml:ValByName("it.cNomeFor")     , cNomeFor )                                            
	aadd( oHtml:ValByName("it.cProd") , cProd )    
	aadd( oHtml:ValByName("it.nQt")    , Transform(nQuant , "@E 9,999,999.99") )    
	aadd( oHtml:ValByName("it.nValUni" )   , Transform(nPreco, "@E 999,999,999.99") ) 
	aadd( oHtml:ValByName("it.nValTot")     , Transform( (nQuant * nPreco) , "@E 999,999,999.99") )       
	aadd( oHtml:ValByName("it.dPrev")     , DtoC(dPREVENT) )       
	aadd( oHtml:ValByName("it.cTPFRE")     , iif(cTipoFre = "F" , "FOB" , iif(cTipoFre = "C" , "CIF" , "OUTROS") ) )       
	aadd( oHtml:ValByName("it.nValFRE")     , Transform(nValFRE, "@E 999,999,999.99") )       
	aadd( oHtml:ValByName("it.nPRZPFRE")     , Transform(nPRZPFRE, "@E 9999") + " Dias " )       
			   	
	cNome  := ""		
	cMail  := ""     
	cDepto := ""
	PswOrder(1)
	If PswSeek( __CUSERID, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informa��es do usu�rio	   
	   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usu�rio logado
	   	cMail := Alltrim(aUsers[1][14])     // e-mail do usu�rio logado
		cDepto:= aUsers[1][12]  //Depto do usu�rio logado	
	Endif
	oHtml:ValByName("CABECA"  , cCabeca )	//t�tulo aviso
	oHtml:ValByName("cMSG"  , cMsg )	//texto do aviso	
	oHtml:ValByName("cUser"  , cNome )	//usu�rio logado que atualizou
	oHtml:ValByName("cDepto"    , cDepto )	//nome do Depto
	oHtml:ValByName("cMail"    , cMail )	//email
	
	 eEmail := ""
	 eEmail := cMailuser 
	 eEmail += ";logistica@ravaembalagens.com.br"
	 eEmail += ";flavia.rocha@ravaembalagens.com.br"
	 oProcess:cTo := eEmail 
	 subj	:= "COTA��O COMPRAS - Frete Registrado - " + Alltrim(cNumCOT) + "/" + cNomeFor
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
Endif 
//fim do envia email retorno

Return