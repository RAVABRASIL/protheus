#INCLUDE "rwmake.ch"
#INCLUDE 'COLORS.CH'
//#INCLUDE "MATA030.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATC022 - Conferência de Produtos     º Data ³  11/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSolicitado por ³ Chamado: 002282 - Marcelo em 16/08/2011               º±±
±±º                 Criar bloqueio no lancamento de Pedido de Vendas,     º±± 
±±º                 para que o sistema nao permita a indicação de Clientesº±± 
±±º                 e Produtos sem conferencia.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**************************
User Function FATC022()  
**************************

Local aIndexSB1 := {}
Local cFiltraSB1:= ""									// Expressão do filtro 
Local nTamanho  := 0
Local nPos		:= 0
Local cPos		:= "" 

Private aRotina		:= {}									// Array com as opções da rotina
Private bFiltraBrw	:= {|| Nil}	  
PRIVATE ALTERA 	  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Conferência de Produtos"
       

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Conferir","U_fConfP()",0,4},;
             {"&Legenda","U_FATC022Leg()", 0, 5} }
             
             

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SB1" 
Private aCampos := {}

cFiltro1 := ""
nTamanho := Len(Alltrim(SB1->B1_COD))
nPos     := nTamanho - 3  // 4
cPos	 := str(nPos)
cFiltraSB1 := " LEN(ALLTRIM(B1_COD)) <= 7 "    //mostra produtos não-genéricos


If !Empty(cFiltraSB1)
	bFiltraBrw	:= { || FilBrowse("SB1", @aIndexSB1, @cFiltraSB1) }
	Eval(bFiltraBrw)
EndIf  


dbSelectArea("SB1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³ 
//                         essa ordem acima tá inversa - FR - 09/11/11
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

aCampos := { {"Dt.Conferido", "B1_DTCONFE"},; 
			{"Conferido Por", "B1_USRCONF"},; 
			{"Codigo", "B1_COD"},;           
            {"Descricao"  ,"B1_DESC"} }  

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos ,"B1_CONFERI")

Return

****************************
User Function fConfP( ) 
****************************

Local nOpcA := 0
Local nReg  := SB1->(RECNO())
Local nOpc  := 4
Local aButtons := {}
Local cAlias := "SB1"
Private aRotAuto := Nil
Private lCopia := .F.


If SB1->B1_CONFERI != "S"

	nOpcA:= AxAltera( cAlias, nReg, nOpc,,,,,"A010TUDOOK()" ,,,aButtons)

	If nOpcA = 1
	   //If MsgYesNo("Deseja Confirmar a Conferência deste Cadastro ?","CONFERÊNCIA OK")
	   		RecLock("SB1",.F.)
	   		SB1->B1_CONFERI := "S"
	   		SB1->B1_USRCONF := Substr(cUsuario,7,15)
	   		SB1->B1_DTCONFE := Date()
	   		SB1->(MsUnlock() )
	   		Msginfo("Cadastro Conferido com SUCESSO !!")
	   //Endif
	Endif
Endif

Return


******************************************************************************************************
User Function FATC022Leg()
******************************************************************************************************


BrwLegenda( "Legenda", cCadastro, { {"BR_VERMELHO", "Conferido"},{"BR_VERDE", "SEM Conferir"} })

Return(Nil)



