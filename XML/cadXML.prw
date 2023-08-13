// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : cadXML
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 30/10/12 | Gustavo Costa     | Rotina para Importar o XML das notas fiscais de entrada.
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "Topconn.ch"
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manuten็ใo de dados armazenados em ZF1.

@author    TOTVS Developer Studio - Gerado pelo Assistente de C๓digo
@version   1.xx
@since     30/10/2012
/*/
//------------------------------------------------------------------------------------------
User function cadXML()
//--< variแveis >---------------------------------------------------------------------------

//Indica a permissใo ou nใo para a opera็ใo (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Opera็ใo: ALTERAวรO
local cVldExc := ".T." // Opera็ใo: EXCLUSรO

//trabalho/apoio
local cAlias

//--< procedimentos >-----------------------------------------------------------------------
cAlias := "ZF1"
chkFile(cAlias)
dbSelectArea(cAlias)
//indices
dbSetOrder(1)
//------------------------------------------------------------------------------------------
// Array (tambem deve ser aRotina sempre) com as definicoes das opcoes
//que apareceram disponiveis para o usuario. Segue o padrao:
//aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
//              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
//              . . .
//              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }
// Onde: <DESCRICAO> - Descricao da opcao do menu
//       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas
//                     duplas e pode ser uma das funcoes pre-definidas
//                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA
//                     e AXDELETA) ou a chamada de um EXECBLOCK.
//                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-
//                     clarar uma variavel chamada CDELFUNC contendo
//                     uma expressao logica que define se o usuario po-
//                     dera ou nao excluir o registro, por exemplo:
//                     cDelFunc := 'ExecBlock("TESTE")'  ou
//                     cDelFunc := ".T."
//                     Note que ao se utilizar chamada de EXECBLOCKs,
//                     as aspas simples devem estar SEMPRE por fora da
//                     sintaxe.
//       <TIPO>      - Identifica o tipo de rotina que sera executada.
//                     Por exemplo, 1 identifica que sera uma rotina de
//                     pesquisa, portando alteracoes nao podem ser efe-
//                     tuadas. 3 indica que a rotina e de inclusao, por
//                     tanto, a rotina sera chamada continuamente ao
//                     final do processamento, ate o pressionamento de
//                     <ESC>. Geralmente ao se usar uma chamada de
//                     EXECBLOCK, usa-se o tipo 4, de alteracao.
//------------------------------------------------------------------------------------------
// aRotina padrao. Utilizando a declaracao a seguir, a execucao da
// MBROWSE sera identica a da AXCADASTRO:
//
// cDelFunc  := ".T."
// aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
//                { "Visualizar"   ,"AxVisual" , 0, 2},;
//                { "Incluir"      ,"AxInclui" , 0, 3},;
//                { "Alterar"      ,"AxAltera" , 0, 4},;
//                { "Excluir"      ,"AxDeleta" , 0, 5} }
//
//------------------------------------------------------------------------------------------

aCores    	:= {{ "ZF1->ZF1_STATUS==' '", 'BR_VERDE' },; 	// Falta Relacionamento
				{ "ZF1->ZF1_STATUS=='1'", 'BR_AZUL'},; 	// Falta Pedido de Compra
				{ "ZF1->ZF1_STATUS=='2'", 'BR_AMARELO'},; // Aguardando Pre Nota
				{ "ZF1->ZF1_STATUS=='3'", 'BR_VERMELHO'}}  	// Finalizado			

//--<  monta 'arotina' proprio >------------------------------------------------------------

	aRotina := {;
		{ "Pesquisar"		, "AxPesqui", 0, 1},;
		{ "Importar"		, "Processa({|| U_COMP01()})"	, 0, 3},;
		{ "Visualizar"	, "U_fIncluiXML('VISUALIZAR')"	, 0, 2},;
		{ "Alterar"		, "U_fIncluiXML('ALTERAR')"		, 0, 4},;
		{ "Exlcuir"		, "U_fIncluiXML('EXCLUIR')"		, 0, 5},;
		{ "Legenda"		, "U_fLegXML()"					, 0, 2},;
		{ "Gera PreNota"	, "U_fPreNota()"					, 0, 4},;
		{ "Exportar"		, "MsgAlert('OPS')"				, 0, 2},;
		{ "Finaliza"		, "U_fAltStatus()"				, 0, 4};
		}

//------------------------------------------------------------------------------------------
// Executa a funcao MBROWSE. Sintaxe:
//
// mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)
// Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera
//                        exibido. Para seguir o padrao da AXCADASTRO
//                        use sempre 6,1,22,75 (o que nao impede de
//                        criar o browse no lugar desejado da tela).
//                        Obs.: Na versao Windows, o browse sera exibi-
//                        do sempre na janela ativa. Caso nenhuma este-
//                        ja ativa no momento, o browse sera exibido na
//                        janela do proprio SIGAADV.
// Alias                - Alias do arquivo a ser "Browseado".
// aCampos              - Array multidimensional com os campos a serem
//                        exibidos no browse. Se nao informado, os cam-
//                        pos serao obtidos do dicionario de dados.
//                        E util para o uso com arquivos de trabalho.
//                        Segue o padrao:
//                        aCampos := { {<CAMPO>,<DESCRICAO>},;
//                                     {<CAMPO>,<DESCRICAO>},;
//                                     . . .
//                                     {<CAMPO>,<DESCRICAO>} }
//                        Como por exemplo:
//                        aCampos := { {"TRB_DATA","Data  "},;
//                                     {"TRB_COD" ,"Codigo"} }
// cCampo               - Nome de um campo (entre aspas) que sera usado
//                        como "flag". Se o campo estiver vazio, o re-
//                        gistro ficara de uma cor no browse, senao fi-
//                        cara de outra cor.
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
mBrowse( 6, 1, 22, 75, cAlias,,,,,,aCores)


Return
//--< fim de arquivo >----------------------------------------------------------------------

***********************
User Function fLegXML()
***********************

Local aLegenda := {	{"BR_VERDE" 		,"Falta Relacionar"   },;
	   	   			   {"BR_AZUL" 		,"Falta Pedido de Compra"},; 
   		   			   {"BR_AMARELO"    	,"Aguardando Pre Nota"},; 
   	   				   {"BR_VERMELHO"    ,"Finalizado"   } }


BrwLegenda("Importa XML","Legenda",aLegenda)		   		

Return .T.

 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIncluiXML บ Autor ณ Gustavo Costa     บ Data ณ  12/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inclusao altera็ใo e exclusใo do XML.  						 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fIncluiXML(cOP)      

Local aZF1			:= {}
Local nUsadoZF1	:= 0
Local cConteudo	:= ''
Local cCampo		:= ''
Local aButtons	:= {}
Local aSizeAut  	:= MsAdvSize()
Local aObjects  	:= {}
Local aPosObj   	:= {}
Local _lRet		:= .F.

Private oDlg
Private aCols
Private aHeader

//+--------------------------------------------------------------+
//| Opcoes de acesso para a Modelo 3                             |
//+--------------------------------------------------------------+

cOpcao := cOP

Do Case	
	Case cOpcao=="INCLUIR" 
			nOpcE:=3  
			nOpcG:=3	
			nOpc:=3
	Case cOpcao=="ALTERAR" 
			nOpcE:=4  
			nOpcG:=4	
			nOpc:=4
	Case cOpcao=="VISUALIZAR" 
			nOpcE:=2  
			nOpcG:=2
			nOpc:=2
	Case cOpcao=="EXCLUIR" 
			nOpcE:=5  
			nOpcG:=5
			nOpc:=5

EndCase

DbSelectArea("ZF1")
DbSetOrder(1)
//DbGotop()

If ZF1->ZF1_STATUS == '3' .and. (nOpcE = 4 .OR. nOpcE = 3)
	MsgAlert("Nใo ้ possํvel excluir XML finalizado!")
	Return
EndIf

//+--------------------------------------------------------------+
//| Cria variaveis M->????? da Enchoice                          |
//+--------------------------------------------------------------+

RegToMemory("ZF1",(cOpcao=="INCLUIR"))

//+--------------------------------------------------------------+
//| Cria aHeader e aCols da GetDados                             |
//+--------------------------------------------------------------+

nUsado:=0

dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZD1")

aHeader:={}

While !Eof().And.(x3_arquivo=="ZD1")	
	
	If X3USO(x3_usado).And.cNivel>=x3_nivel    	
		nUsado:=nUsado+1        
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;	         
			x3_tamanho, x3_decimal,"AllwaysTrue()",;    	     
			x3_usado, x3_tipo, x3_arquivo, x3_context } )	
	Endif    
	
	dbSkip()
End

If cOpcao=="INCLUIR"	

	aCols:={Array(nUsado+1)}	
	aCols[1,nUsado+1]:=.F.	
	
	For _ni:=1 to nUsado		
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])	
	Next
	
Else	
	aCols:={}	
	dbSelectArea("ZD1")	
	dbSetOrder(1)	
	dbSeek(xFilial()+M->ZF1_DOC+M->ZF1_SERIE+M->ZF1_FORNEC+M->ZF1_LOJA)	
	
	While !eof().and. ZD1->ZD1_DOC+ZD1->ZD1_SERIE+ZD1->ZD1_FORNEC+ZD1->ZD1_LOJA == M->ZF1_DOC+M->ZF1_SERIE+M->ZF1_FORNEC+M->ZF1_LOJA		
		AADD(aCols,Array(nUsado+1))		
		
		For _ni:=1 to nUsado			
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))		
		Next 		
		
		aCols[Len(aCols),nUsado+1]:=.F.		
		
		dbSkip()	
	
	End
Endif

aadd(aButtons,{"PEDIDO",{|| U_fMarkPC()},"Ped. Compra","Pedido Compra"})

If Len(aCols)>0	

	//+--------------------------------------------------------------+	
	//| Executa a Modelo 3                                           |	
	//+--------------------------------------------------------------+	
	
	cTitulo:="MXL Nf-e / CT-e"	
	cAliasEnchoice:="ZF1"	
	cAliasGetD:="ZD1"	
	cLinOk:="AllwaysTrue()"	
	cTudOk:="AllwaysTrue()"	
	cFieldOk:="AllwaysTrue()"
	//	aCpoEnchoice:={} 
	//Modelo3 ( cTituloc Alias cAlias2 [ aMyEncho ] [ cLinhaOk ] [ cTudoOk ] [ nOpcE ] [ nOpcG ] [ cFieldOk ] [ lVirtual ] [ nLinhas ] [ aAltEnchoice ] [ nFreeze ] [ aButtons ] [ aCordW ] [ nSizeHeader ] )
	//_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,,,,aButtons,,250)	
	
	aObjects := {}
	AAdd( aObjects, { 315,  50, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	DEFINE MSDIALOG oDlg TITLE cTitulo From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
	
	EnChoice( cAliasEnchoice ,0, nOpc, , , , , aPosObj[1],      , 3 )
	
	oGetDad := MSGetDados():New (aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpc, cLinOk ,cTudOk,"",.F.)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_lRet:=.T.,oDlg:End()},{||oDlg:End()},,aButtons)
	
	//+--------------------------------------------------------------+	
	//| Executar processamento                                       |	
	//+--------------------------------------------------------------+	
	
	If _lRet .AND. nOpcE <> 2		
		
		BEGIN TRANSACTION
		
		If nOpcE = 4 // ALTERAR

			dbSelectArea("SX3")
			DbSetOrder(1)
			DbSeek("ZF1")
			While !Eof().And.(x3_arquivo=="ZF1")	
				
				If Alltrim(x3_campo)=="ZF1_FILIAL"		
					dbSkip()		
					Loop	
				Endif	
				
				If X3USO(x3_usado).And.cNivel>=x3_nivel    	
					nUsadoZF1:=nUsadoZF1+1        
					Aadd(aZF1, x3_campo )	
				Endif    
				
				dbSkip()
			End
			
			RecLock("ZF1",.F.)
			
			For i := 1 to Len(aZF1)
				
				cCampo		:= Alltrim("ZF1->" + aZF1[i])
				cConteudo	:= Alltrim("M->" + aZF1[i])
				
				Replace &cCampo With &cConteudo
				
			Next i
			
			ZF1->(MsUnlock())
			dbSelectArea("ZD1")
			dbSetOrder(1)	

			For j := 1 to Len(aCols)
				
				cItem	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_ITEM"})]
				
				If ZD1->( dbSeek(xFilial("ZD1") + M->ZF1_DOC + M->ZF1_SERIE + M->ZF1_FORNEC + M->ZF1_LOJA + cItem) )
			
					RecLock("ZD1",.F.)
					For k := 1 to Len(aHeader)
				
						If ( aHeader[k][10] != "V" )
	
							//FieldPut(FieldPos(aHeader[k][2]),aCols[j][k])
							cCampo		:= Alltrim("ZD1->" + aHeader[k][2])
							Replace &cCampo With aCols[j][k]
	
						EndIf
				
					Next k
					ZD1->(MsUnlock())
					
				EndIf
				
				dbSelectArea("SA5")
				dbsetorder(1)
				IF SA5->(dbSeek(xFilial("SA5") + M->ZF1_FORNEC + M->ZF1_LOJA + aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_COD"})] ))
					If Empty(SA5->A5_CODPRF)
						RecLock("SA5",.F.)
						
						SA5->A5_CODPRF	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_CODPRO"})]
						SA5->A5_XFATOR	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_FATOR"})]
						
						SA5->(MsUnlock())
					EndIf
				Else
					RecLock("SA5",.T.)
					
					SA5->A5_FORNECE	:= M->ZF1_FORNEC
					SA5->A5_LOJA		:= M->ZF1_LOJA
					SA5->A5_NOMEFOR	:= POSICIONE("SA2",1,xFilial("SA2") + M->ZF1_FORNEC + M->ZF1_LOJA, "A2_NOME")
					SA5->A5_PRODUTO	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_COD"})]
					SA5->A5_CODPRF	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_CODPRO"})]
					SA5->A5_XFATOR	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_FATOR"})]
					
					SA5->(MsUnlock())
				EndIf
			Next j
		
		Else
		
			RecLock("ZF1",.F.)
			
			dbDelete()
						
			ZF1->(MsUnlock())
			
			For j := 1 to Len(aCols)
				
				cItem	:= aCols[j][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_ITEM"})]
				
				If ZD1->( dbSeek(xFilial("ZD1") + M->ZF1_DOC + M->ZF1_SERIE + M->ZF1_FORNEC + M->ZF1_LOJA + cItem) )
			
					RecLock("ZD1",.F.)
					dbDelete()
					ZD1->(MsUnlock())
	
				EndIf
	
			Next j
			//EXCLUIR
		
		EndIf
		
		END TRANSACTION
		
		//Atualiza o status	
		U_fVerStatus()
		//oDlg:End()
	Endif
Endif                 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkPC  บAutor  ณ  Gustavo Costa       บ Data ณ 12/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para marcar o Pedido de Compra para os produtos do XML.บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMarkPC()

Local cMarca  	:= GetMark()				//Flag para marcacao
Local aCampos 	:= {}								//Array para criacao de arq. temporario
Local aCmp 		:= {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     	:= .F.							//Retorno da janela de dialogo
Local nElem   	:= 0								//Localizador de arrays
Local lInvert 	:= .F.
Local lSemPC		:= .T.
Local cQuery 		:= ""

Local cQuant		:= ""
Local cPreco		:= ""
Local cNum			:= ""
Local cTotal		:= ""
Local cItem		:= ""
Local cArquivo	:= "TMP"
Local aRetorno	:= {}
Local cCod
Local cPed
Local nQtdNota	:= 0
Local nSaldoPC	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine estrutura do arquivo de trabalho sobre o qual atuaraณ
//ณo MarkBrowse.                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aADD(aCmp,{"OK"  			,"C",02,0})
aADD(aCmp,{"DT"	 		,"D",08,0})
aADD(aCmp,{"NUM" 			,"C",09,0})
aADD(aCmp,{"VTOTAL"		,"N",14,2})
aADD(aCmp,{"VALFRET"		,"N",14,2})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria arquivo de trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

cIndex := CriaTrab(aCmp,.T.)
dbUseArea( .T.,, cIndex, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )

cQuery := " SELECT C7_NUM, C7_EMISSAO, SUM(C7_TOTAL) VTOTAL, SUM(C7_VALFRET) VALFRET FROM " + RETSQLNAME("SC7") + " SC7 "
cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
cQuery += " AND SC7.D_E_L_E_T_ <> '*' " 
cQuery += " AND C7_RESIDUO = '' "
cQuery += " AND C7_CONAPRO <> 'B' "
cQuery += " AND C7_ENCER = '' "
cQuery += " AND C7_FORNECE = '" + M->ZF1_FORNEC + "' "
//cQuery += " AND C7_LOJA = '" + cLoja + "' "
cQuery += " GROUP BY C7_NUM, C7_EMISSAO "
cQuery += " ORDER BY C7_NUM, C7_EMISSAO "

cQuery := ChangeQuery(cQuery)

If Select("XPC") > 1
	XPC->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XPC",.T.,.T.)
TCSetField( "XPC", "C7_EMISSAO",  "D", 8, 0 )

dbSelectArea("XPC")
dbGoTop()

While XPC->(!EOF())
	
	RecLock("TMP", .T.)
	TMP->DT		:= XPC->C7_EMISSAO
	TMP->NUM		:= XPC->C7_NUM
	TMP->VTOTAL	:= XPC->VTOTAL
	TMP->VALFRET	:= XPC->VALFRET
	TMP->(MsUnLock())
	lSemPC			:= .F.
	XPC->(dbSkip())
End

If lSemPC
	MsgAlert("Sem Pedido de Compra para este fornecedor!")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRedefine o array aCampos com a estrutura do MarkBrowseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aCampos,{"OK"  			,"",""       	,""  	})					//Flag marcacao
AADD(aCampos,{"DT" 			,"","Data"  	,""  	})					//Data PDCessa
AADD(aCampos,{"NUM" 			,"","Num"		,""  	})					//Documento
AADD(aCampos,{"VTOTAL"		,"","Total" 	,"@E 999,999,999.99"		})					//Total
AADD(aCampos,{"VALFRET"		,"","Frete" 	,"@E 999,999,999.99"		})					//Frete

DEFINE MSDIALOG oDlg TITLE 'Pedido de Compra' FROM 9,0 To 28,80 OF oMainWnd

oMark:=MsSelect():New(cArquivo,"OK",,aCampos,@lInvert,@cMarca,{02,1,123,316},)
oMark:oBrowse:lCanAllmark := .F.

TMP->(dbGoTop())

DEFINE SBUTTON FROM 126,246.3 TYPE 1 ACTION (lOk := .T.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 126,274.4 TYPE 2 ACTION oDlg:End()              ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa MarkBrowse colocando verificando qual a PDCessa selecio-	ณ
//ณnada e preenchendo a nota fiscal original, serie e item no pedido	ณ
//ณde vendas.		                                                    	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lOk
	TMP->(dbGoTop())
	While TMP->(!Eof()) .And. lOk
		
		If TMP->OK == cMarca
			cNum	:= TMP->NUM
			
			cQuery := " SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_QUJE, C7_COND, C7_CC, C7_CONTA FROM " + RETSQLNAME("SC7") + " SC7 "
			cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
			cQuery += " AND SC7.D_E_L_E_T_ <> '*' " 
			cQuery += " AND C7_RESIDUO = '' "
			cQuery += " AND C7_CONAPRO <> 'B' "
			cQuery += " AND C7_ENCER = '' "
			cQuery += " AND C7_NUM = '" + cNum + "' "
			cQuery += " ORDER BY C7_ITEM "
			
			cQuery := ChangeQuery(cQuery)
			
			If Select("TMP2") > 1
				TMP2->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP2",.T.,.T.)

			TMP2->(dbGoTop())
			
			M->ZF1_COND 	:= TMP2->C7_COND
			While TMP2->(!EOF()) 
				//Varre o aCols preenchendo os campos dos pedidos
				For i := 1 To Len(aCols)
					
					cCod		:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_COD"})]
					cPed		:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_PEDIDO"})]
					nQtdNota	:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_QUANT"})]
					nSaldoPC	:= TMP2->C7_QUANT - TMP2->C7_QUJE
					
					If TMP2->C7_PRODUTO = cCod .and. Empty(cPed) .and. nQtdNota <= nSaldoPC
						aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_PEDIDO"})]	:= TMP2->C7_NUM
						aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_ITEMPC"})]	:= TMP2->C7_ITEM
						aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_CC"})]		:= TMP2->C7_CC
						aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_CONTA"})]	:= TMP2->C7_CONTA
					EndIf
					
				Next i
				TMP2->(dbSkip())
			EndDo
			TMP2->(dbCloseArea())
			lOk := .F.
		EndIf
		
		TMP->(dbSkip())
	EndDo
EndIf

XPC->(dbCloseArea())
TMP->(dbCloseArea())
//AADD(aRetorno,{cQuant, cNum, cItem})
//AADD(aRetorno,{cQuant,cPreco, cTotal, cNum, cItem})
Return //cNum//aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkIT  บAutor  ณ  Gustavo Costa       บ Data ณ 12/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para marcar o item do Pedido de Compra para os         บฑฑ
ฑฑบ          ณprodutos do XML.										           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMarkIT()

Local cMarca  := GetMark()				//Flag para marcacao
Local aCampos := {}								//Array para criacao de arq. temporario
Local aCmp 	:= {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     := .F.							//Retorno da janela de dialogo
Local nElem   := 0								//Localizador de arrays
Local lInvert := .F.
Local cQuery 	:= ""

Local cQuant	:= ""
Local cPreco	:= ""
Local cNum		:= ""
Local cTotal	:= ""
Local cItem		:= ""
Local cArquivo	:= "TMP"
Local aRetorno:= {}

cQuery += " SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_TES, C7_COND FROM " + RETSQLNAME("SC7") + " SC7 "
cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
cQuery += " AND SC7.D_E_L_E_T_ <> '*' " 
cQuery += " AND C7_QUANT - C7_QUJE >= " + Str(nQuant) 
cQuery += " AND C7_RESIDUO = '' "
cQuery += " AND C7_CONAPRO <> 'B' "
cQuery += " AND C7_ENCER = '' "
cQuery += " AND C7_FORNECE = '" + M->ZF1_FORNEC + "' "
//cQuery += " AND C7_LOJA = '" + cLoja + "' "
cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "

cQuery := ChangeQuery(cQuery)

If Select("XPC") > 1
	XPC->(dbCloseArea())
EndIf
	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XPC",.T.,.T.)

dbSelectArea("XPC")
dbGoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine estrutura do arquivo de trabalho sobre o qual atuaraณ
//ณo MarkBrowse.                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aADD(aCmp,{"OK"  			,"C",02,0})
aADD(aCmp,{"DT"	 		,"D",08,0})
aADD(aCmp,{"NUM" 			,"C",09,0})
aADD(aCmp,{"ITEM"			,"C",04,0})
aADD(aCmp,{"PRODUTO"		,"C",08,0})
aADD(aCmp,{"DESCRICAO"	,"C",50,0})
aADD(aCmp,{"QUANT"		,"C",07,0})
//aADD(aCampos,{"PRECO"			,"C",10,0})
//aADD(aCampos,{"TOTAL"			,"C",13,0})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria arquivo de trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

cIndex := CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cIndex, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRedefine o array aCampos com a estrutura do MarkBrowseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aCampos,{"OK"  			,"",""         	,""  	})					//Flag marcacao
AADD(aCampos,{"DT" 			,"","Data"  	,""  	})					//Data PDCessa
AADD(aCampos,{"NUM" 			,"","Num"		,""  	})					//Documento
AADD(aCampos,{"ITEM"			,"","Item" 		,""		})					//Item
AADD(aCampos,{"PRODUTO"		,"","Produto" 	,""		})					//C๓digo do Produto
AADD(aCampos,{"DESCRICAO"	,"","Descricao"	,"@!"	})					//Descricao do Produto
AADD(aCampos,{"QUANT"		,"","Saldo" 	,""		})					//Quantidade
//AADD(aCampos,{"PRECO"			,"","Pre็o" 	,""		})					//Pre็o de Venda
//AADD(aCampos,{"TOTAL"			,"","Total" 	,""		})					//Total

DEFINE MSDIALOG oDlg TITLE 'Pedido de Compra' FROM 9,0 To 28,80 OF oMainWnd

oMark:=MsSelect():New(cArquivo,"OK",,aCampos,@lInvert,@cMarca,{02,1,123,316},)
oMark:oBrowse:lCanAllmark := .F.

TMP->(dbGoTop())

DEFINE SBUTTON FROM 126,246.3 TYPE 1 ACTION (lOk := .T.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 126,274.4 TYPE 2 ACTION oDlg:End()              ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa MarkBrowse colocando verificando qual a PDCessa selecio-	ณ
//ณnada e preenchendo a nota fiscal original, serie e item no pedido	ณ
//ณde vendas.		                                                     	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lOk
	TMP->(dbGoTop())
	While TMP->(!Eof()) .And. lOk
		
		If TMP->OK == cMarca
			cQuant 	:= TMP->QUANT
//			cPreco 	:= TMP->PRECO
//			cTotal 	:= TMP->TOTAL
			cNum	:= TMP->NUM
			cItem	:= TMP->ITEM
			lOk := .F.
		EndIf
		
		TMP->(dbSkip())
	EndDo
EndIf

AADD(aRetorno,{cQuant, cNum, cItem})
//AADD(aRetorno,{cQuant,cPreco, cTotal, cNum, cItem})
Return aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPreNota บAutor  ณ  Gustavo Costa       บ Data ณ 12/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gerar a Pre Nota a partir do XML importado.     บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fPreNota()

Local aArea		:= getArea()
Local _aCabec		:= {}
Local aLinha		:= {}
Local _aItens		:= {}
Local nUsadoZF1	:= 0

If ZF1->ZF1_STATUS == '2' //.OR. Alltrim(ZF1->ZF1_ESPECI) == 'CTE'
	
	//Monta o cabe็alho
	
	dbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZF1")
	While !Eof().And.(x3_arquivo=="ZF1")	
				
		If Alltrim(x3_campo)=="ZF1_FILIAL"		
			dbSkip()		
			Loop	
		Endif	
		
		If X3USO(x3_usado).And.cNivel>=x3_nivel    	
			nUsadoZF1:=nUsadoZF1+1        

			AADD(aLinha, {x3_campo, &("ZF1->"+x3_campo) , NIL} )

		Endif    
		
		dbSkip()
	End
	
	For i := 1 To Len(aLinha)
	
		AADD (_aCabec, aLinha[i])
	
	Next i
	nUsadoZF1	:= 0
	dbSelectArea("ZD1")
	dbSetOrder(1)
	If ZD1->( dbSeek(xFilial("ZD1") + ZF1->ZF1_DOC + ZF1->ZF1_SERIE + ZF1->ZF1_FORNEC + ZF1->ZF1_LOJA ) )
	
		While ZD1->(!EOF()) .AND. ZF1->ZF1_DOC == ZD1->ZD1_DOC .AND. ZF1->ZF1_SERIE == ZD1->ZD1_SERIE .AND. ;
			 						ZF1->ZF1_FORNEC == ZD1->ZD1_FORNEC .AND. ZF1->ZF1_LOJA == ZD1->ZD1_LOJA
			//zerar alinha
			aLinha		:= {}
			dbSelectArea("SX3")
			DbSeek("ZD1")
			While !Eof().And.(x3_arquivo=="ZD1")	
						
				If Alltrim(x3_campo)=="ZD1_FILIAL"		
					dbSkip()		
					Loop	
				Endif	
				
				If X3USO(x3_usado).And.cNivel>=x3_nivel    	
					nUsadoZF1:=nUsadoZF1+1        
		
					AADD(aLinha, {x3_campo, &("ZD1->"+x3_campo) , NIL} )
		
				Endif    
				
				dbSkip()
			End	
		
			AAdd(_aItens, aLinha)
			
			ZD1->(dbskip())
		EndDo  
	Else
		MsgAlert("Impossํvel gerar! Erro Item.")
		Return
	EndIf
	
Else
	MsgAlert("Impossํvel gerar! Verifique Status.")
	RestArea(aArea)
	Return
EndIf

U_fGeraPN(_aCabec, _aItens)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAltStatus บAutor  ณ  Gustavo Costa     บ Data ณ 18/12/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para mudar o status do XML importado que jแ gerou    บฑฑ
ฑฑบ          ณa nota fiscal.										           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function fAltStatus()


If ZF1->ZF1_STATUS == '3'
	MsgAlert("Nใo ้ possํvel mudar o status do XML finalizado!")
Else
	If MsgYesNo("Deseja realmente mudar o status deste XML?")
		RecLock("ZF1", .F.)
			ZF1->ZF1_STATUS := '3'
		MsUnLock()
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerStatus บAutor  ณ  Gustavo Costa     บ Data ณ 20/12/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para verificar o status do XML importado na altera็ใoบฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function fVerStatus()

Local cStatus	:= ""
Local lCod		
Local lPed

For i := 1 To Len(aCols)
	
	cCod		:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_COD"})]
	cPed		:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_PEDIDO"})]
	cItem		:= aCols[i][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_ITEMPC"})]
	
	If !Empty(cCod)
		
		If lCod <> .F.
			lCod	:= .T.
		EndIf
		
		If !Empty(cCod) .and. !Empty(cPed) .and. !Empty(cItem) .and. lCod
			
			If lPed <> .F.
				lPed	:= .T.
			EndIf
		
		Else
			lPed	:= .F.
		EndIf
	Else
		lCod	:= .F.
	EndIf
	
Next i

If lCod
	cStatus	:= '1'
	If lPed
		cStatus	:= '2'
	EndIf
Endif

RecLock("ZF1", .F.)
	ZF1->ZF1_STATUS := cStatus
MsUnLock()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGat01     บAutor  ณ  Gustavo Costa     บ Data ณ 18/12/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho para atualizar o campo ZD1_VUNI na altera็ใo do     บฑฑ
ฑฑบ          ณfator.  												           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function fGat01()

Local nRet := aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_TOTAL"})] / aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZD1_QUANT"})]

Return nRet
