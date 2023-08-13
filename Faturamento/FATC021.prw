#INCLUDE "rwmake.ch"
#INCLUDE 'COLORS.CH'
//#INCLUDE "MATA030.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATC021 - Confer๊ncia de Clientes     บ Data ณ  09/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบAutoria   ณ Flแvia Rocha                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSolicitado por ณ Chamado: 002282 - Marcelo em 16/08/2011               บฑฑ
ฑฑบ                 Criar bloqueio no lancamento de Pedido de Vendas,     บฑฑ 
ฑฑบ                 para que o sistema nao permita a indica็ใo de Clientesบฑฑ 
ฑฑบ                 e Produtos sem conferencia.                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

**************************
User Function FATC021()   
**************************

Local aIndexSA1 := {}
Local cFiltraSA1:= ""									// Expressใo do filtro

Private aRotina		:= {}									// Array com as op็๕es da rotina
Private bFiltraBrw	:= {|| Nil}		  


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "Confer๊ncia de Clientes"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Conferir","U_fConfere()",0,3},;
 			 {"&Legenda","U_FATC021Leg()", 0, 5} }

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SA1" 
Private aCampos := {}

dbSelectArea("SA1")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a funcao MBROWSE. Sintaxe:                                  ณ
//ณ                                                                     ณ
//ณ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ณ
//ณ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ณ
//ณ                        exibido. Para seguir o padrao da AXCADASTRO  ณ
//ณ                        use sempre 6,1,22,75 (o que nao impede de    ณ
//ณ                        criar o browse no lugar desejado da tela).   ณ
//ณ                        Obs.: Na versao Windows, o browse sera exibi-ณ
//ณ                        do sempre na janela ativa. Caso nenhuma este-ณ
//ณ                        ja ativa no momento, o browse sera exibido naณ
//ณ                        janela do proprio SIGAADV.                   ณ
//ณ Alias                - Alias do arquivo a ser "Browseado".          ณ
//ณ aCampos              - Array multidimensional com os campos a serem ณ
//ณ                        exibidos no browse. Se nao informado, os cam-ณ
//ณ                        pos serao obtidos do dicionario de dados.    ณ
//ณ                        E util para o uso com arquivos de trabalho.  ณ
//ณ                        Segue o padrao:                              ณ
//ณ                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     . . .                           ณ
//ณ                                     {<CAMPO>,<DESCRICAO>} }         ณ
//ณ                        Como por exemplo:                            ณ
//ณ                        aCampos := { {"TRB_DATA","Data  "},;         ณ
//ณ                                     {"TRB_COD" ,"Codigo"} }         ณ 
//                         essa ordem acima tแ inversa - FR - 09/11/11
//ณ cCampo               - Nome de um campo (entre aspas) que sera usadoณ
//ณ                        como "flag". Se o campo estiver vazio, o re- ณ
//ณ                        gistro ficara de uma cor no browse, senao fi-ณ
//ณ                        cara de outra cor.                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

			
aCampos := { {"Dt.Conferido", "A1_DTCONFE"},; 
			{"Conferido Por", "A1_USRCONF"},; 
			{"Codigo", "A1_COD"},;        
           	{"Loja"  ,"A1_LOJA"},;  
            {"Nome"  ,"A1_NOME"} }
            

cFiltraSA1	:= "A1_ATIVO != 'N' "  //mostra apenas os clientes ATIVOS


If !Empty(cFiltraSA1)
	bFiltraBrw	:= { || FilBrowse("SA1", @aIndexSA1, @cFiltraSA1) }
	Eval(bFiltraBrw)
EndIf  

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos ,"A1_CONFERI")

EndFilBrw( "SA1" , aIndexSA1 ) //Inclua esta linha para que o filtro seja liberado....

Return

****************************
User Function fConfere() 
****************************

Local nOpcA := 0
Local nReg  := SA1->(RECNO())
Local nOpc  := 3
Local aButtons := {}
Local cAlias   := "SA1"
LOCAL lACAtivo  := GetNewPar("MV_ACATIVO", .F.) 
Private aRotAuto := Nil

//aadd(aButtons,{"WEB",{|| fGeoWizard("SA1",M->A1_COD+M->A1_LOJA,{"M->A1_END","M->A1_MUN","M->A1_EST","M->A1_CEP","M->A1_BAIRRO"},{|lContinua| CodGeoRev(aCoor,NIL,@lContinua)[6] <> M->A1_CEP })},"teste1", "teste2" })	
//aadd(aButtons,{"BMPVISUAL",{|| fConsWizard({M->A1_NOME, M->A1_PESSOA, M->A1_NREDUZ, M->A1_END, M->A1_CEP, M->A1_DDD, M->A1_TEL, M->A1_CGC, M->A1_RG, M->A1_DTNASC})},"teste3", "teste4" })

If SA1->A1_CONFERI != "S"

	nOpcA := AxAltera(cAlias,nReg,nOpc,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	/*iif(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()")*/,/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
	If nOpcA = 1
	   //If MsgYesNo("Deseja Confirmar a Confer๊ncia deste Cadastro ?","CONFERสNCIA OK")
	   		RecLock("SA1",.F.)
	   		SA1->A1_CONFERI := "S"
	   		SA1->A1_USRCONF := Substr(cUsuario,7,15)
	   		SA1->A1_DTCONFE := Date()
	   		SA1->(MsUnlock() )
	   		Msginfo("Cadastro Conferido com SUCESSO !!")
	   //Else
	   //		Return
	   //Endif
	Endif
//Else
	//MsgInfo("Cadastro Jม FOI CONFERIDO !")
Endif

Return 




******************************************************************************************************
User Function FATC021Leg()
******************************************************************************************************


BrwLegenda( "Legenda", cCadastro, { {"BR_VERMELHO", "Conferido"},{"BR_VERDE", "SEM Conferir"} })

Return(Nil)