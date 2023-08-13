#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ         ณ Autor ณ                       ณ Data ณ           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
***************************************************
User Function FATC019(xAutoCab,xAutoItens,nOpcAuto)
***************************************************

Local aCores := {{"ZC5_STATUS == 'C'", "BR_VERDE"},;
				 {"ZC5_STATUS == 'X'", "BR_PRETO"},;
				 {"ZC5_STATUS == ' '", "BR_AMARELO"},;
				 {"ZC5_STATUS == 'V'", "BR_VERMELHO"}}

//Rotina Automatica
Private lCdaAuto := xAutoCab <> NIL .And. xAutoItens <> NIL

if ! lCdaAuto
   Private aRotina := {{"Pesquisar" , "AxPesqui"     , 0, 1},;
                       {"Visualizar", "U_FATC018"    , 0, 2},;
                       {"Incluir"   , "Alert('Nao Utilizada')", 0, 3},;
                       {"Conferir"  , "U_FATC018"    , 0, 4},;
                       {"Excluir"   , "U_FATC018"    , 0, 5},;                    
                       {"Validar"   , "MsAguarde( {|| U_GeraPVInter() }, OemToAnsi( 'Aguarde' ), OemToAnsi( 'Validando Pedido...' ) )", 0, 3},;
                       {"Legenda"   , "U_LegPedInt"  , 0, 6}}
else
   Private aRotina := {{"Pesquisar" , "AxPesqui" , 0, 1},;
                       {"Visualizar", "U_FATC018", 0, 2},;
                       {"Incluir"   , "U_FATC018", 0, 3},;
                       {"Alterar"   , "U_FATC018", 0, 4},;
                       {"Excluir"   , "U_FATC018", 0, 5}}
endif

Private cCadastro := OemToAnsi( "Cadastro de Pr้-Pedidos Internet" )
Private cAlias1	  := "ZC6"	    // Alias de detalhe
Private lSemItens := .F.		// Permite a nao existencia de itens
Private cChave	  := "ZC5_NUM"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	  := "ZC6_NUM"  // Chave que ligara a segunda tabela com a primeira
Private aChaves   := {{"ZC6_NUM", "M->ZC5_NUM"},{"ZC6_CLI","M->ZC5_CLIENT"},{"ZC6_LOJA","M->ZC5_LOJACL"}}
Private cLinhaOk  := "AllwaysTrue()" //Funcao LinhaOk para a GetDados
Private cTudoOk   := "AllwaysTrue()" //Funcao TudoOk para a GetDados


DbSelectArea("ZC5")
DbSetOrder(1)

if ( Type("lCdaAuto") <> "U" .And. lCdaAuto )
   aAutoCab   := xAutoCab
   aAutoItens := xAutoItens
   MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"ZC5")
   xAutoCab   := aAutoCab
   xAutoItens := aAutoItens
else
   mBrowse( 06, 01, 22, 75, "ZC5",,,,,,aCores )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegPedInt บAutor  ณEurivan Marques     บ Data ณ  18/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda da MBrowse do cadastro de Pedidos de Internet.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLegProj                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LegPedInt()

Local aLegenda	:= {{"BR_AMARELO", 	"Pedido NAO Conferido" },;
                    {"BR_VERDE",	"Pedido Conferido" },;		
                    {"BR_VERMELHO", "Pedido Validado" },;
                    {"BR_PRETO", 	"Pedido Cancelado" }}


BrwLegenda("Pedidos Internet","Legenda",aLegenda)		   		

Return .T.


***************************
User Function GeraPVInter()
***************************

local cCli := cLoja := cLoja := cTransp := ''
local nIt := 1
local _cNum := ''
local cPedido := ''
local cVend := cTipo := ''
Local nSaveSX8 := GetSX8Len()
local nREG := Z55->( RecNo() )
local lSufra := .F.
Local nSaldo90	:= 0
Local nSaldo		:= 0
Local nSaldoPed	:= 0
Local nSaldoLC	:= 0
Local lAntecip	:= .F.

if ZC5->ZC5_STATUS == ' '
   Aviso("Aviso","Pedido NAO Conferido. Confira antes de Validar",{"OK"})
   Return
elseif ZC5->ZC5_STATUS == 'V'
   Aviso("Aviso","Pedido validado anteriormente. Escolha outro pedido.",{"OK"})
   Return   
elseif ZC5->ZC5_STATUS == 'X'   
   Aviso("Aviso","Pedido Cancelado. Escolha outro pedido.",{"OK"})
   Return   
endif   
   
aCab   := {}
aItens := {}  
       
cPedido := GetSxeNum("SC5","C5_NUM")
DbSelectArea("SC5" )
SC5->(DbSetOrder(1))
if SC5->( DbSeek( xFilial( "SC5" )+cPedido ) )
   ConfirmSX8()
   cPedido  := GetSxeNum("SC5","C5_NUM")
endif	    	       	   
              
DbSelectArea("SA1" )
SA1->(DbSetOrder(1))
SA1->( DbSeek( xFilial("SA1")+ZC5->(ZC5_CLIENT+ZC5_LOJACL) ) )
lSufra := !Empty(SA1->A1_SUFRAMA)

Aadd( aCab, {"C5_NUM"    , cPedido        , Nil } )
Aadd( aCab, {"C5_TIPO"   , ZC5->ZC5_TIPO  , Nil } )
Aadd( aCab, {"C5_CLIENTE", ZC5->ZC5_CLIENT, Nil } )
Aadd( aCab, {"C5_LOJACLI", ZC5->ZC5_LOJACL, Nil } )
Aadd( aCab, {"C5_LOCALIZ", ZC5->ZC5_LOCALI, ''  } )
Aadd( aCab, {"C5_TRANSP" , ZC5->ZC5_TRANSP, ''  } )
Aadd( aCab, {"C5_TIPOCLI", SA1->A1_TIPO   , Nil } )
Aadd( aCab, {"C5_CONDPAG", ZC5->ZC5_CONDPA, Nil } )
if !Empty(ZC5->ZC5_CONDP1)
   Aadd( aCab, {"C5_CONDPA1", ZC5->ZC5_CONDP1, Nil } )
endif   
Aadd( aCab, {"C5_VEND1"  , ZC5->ZC5_VEND1 , Nil } )
Aadd( aCab, {"C5_OBS"    , ZC5->ZC5_OBSPED, Nil } )
Aadd( aCab, {"C5_MENNOTA", if(lSufra,"SUFRAMA: "+Alltrim(SA1->A1_SUFRAMA)+" - "+ZC5->ZC5_OBS,ZC5->ZC5_OBS), Nil } )
Aadd( aCab, {"C5_OCCLI"  , if(Empty(ZC5->ZC5_OCCLI),"NAO INFORMADO",ZC5->ZC5_OCCLI), Nil} )
Aadd( aCab, {"C5_NUMEMP"  , " ", Nil} )
//Caso a validacao esteja acontecendo com data maior que a data de entrega o sistema atualiza a data de entrega.
//Para a DataBase.
if ZC5->ZC5_ENTREG < dDataBase
   dEntreg := dDataBase
else
   dEntreg := ZC5->ZC5_ENTREG
endif
Aadd( aCab, {"C5_ENTREG" , dEntreg, Nil } )

DbSelectArea("ZC6")
DbSetOrder(1)
DbSeek(xFilial("ZC6")+ZC5->ZC5_NUM )

while !ZC6->(Eof()) .And. xFilial("ZC5")+ZC5->ZC5_NUM == xFilial("ZC6")+ZC6->ZC6_NUM
   Aadd(aItens, {{"C6_ITEM"   ,StrZero(nIt,2)   ,NIL},;
                 {"C6_PRODUTO",ZC6->ZC6_PRODUT  ,NIL},;
                 {"C6_QTDVEN" ,ZC6->ZC6_QTDVEN  ,NIL},;
                 {"C6_QTDLIB" ,0  				,NIL},;
                 {"C6_TES"    ,ZC5->ZC5_TES     ,NIL},;
                 {"C6_PRUNIT" ,ZC6->ZC6_PRCVEN  ,NIL}})
   nIt++
   ZC6->(dbSkip())	     
end 

if len(aCab)>0 .AND. len(aItens)>0	      	  
	if Type("cPrePed") == "U" 
		cPrePed:=space(6)
	endif

	if Type("nComisN") == "U" 
		nComisN := 0
	endif

		  
   lMsErroAuto := .F.
   Begin Transaction

   MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 3)
			
   if lMsErroAuto
      DisarmTransaction()
      RollBackSX8()  	
      MostraErro()
   else
      while ( GetSX8Len() > nSaveSX8 )
         ConfirmSX8()
      end
	
	  //Atualizo o Pre-Pedido Internet com status, usuario, data e hora da Validacao
      RecLock("ZC5",.F.)
      ZC5->ZC5_STATUS := "V"
      ZC5->ZC5_PV     := cPedido
      ZC5->ZC5_USUVAL := __cUserId
      ZC5->ZC5_DTVAL  := Date()
      ZC5->ZC5_HRVAL  := Substr(Time(),1,5)
      ZC5->(MsUnlock())
		
		//*******************************************
      	//Inicio da valida็ใo do credito do cliente.
		//*******************************************
		If SC5->C5_CONDPAG = '001'
			lAntecip	:= .T.
		EndIf
		
      
		nSaldo	 := fSaldoTit(ZC5->ZC5_CLIENT, ZC5->ZC5_LOJACL)
		nSaldo90  := fSaldo90(ZC5->ZC5_CLIENT, ZC5->ZC5_LOJACL)
		nSaldoPed := fSaldoPed(cPedido)
		nSaldoLC	 := Posicione("SA1",1,xFilial("SA1")+ZC5->ZC5_CLIENT + ZC5->ZC5_LOJACL, "A1_LC") - nSaldo
      	
      	If nSaldo90 > 0 .OR. nSaldoPed > nSaldoLC .OR. lAntecip
			
			dbSelectArea("SC9")
			
			if SC9->( DbSeek( xFilial("SC9")+cPedido ))//+"0101"+aCols[1,nPOSPRO] ) )
				//Bloqueio o credito na alteracao ou inclusao do Pedido
		
				while !SC9->(EOF()) .and. SC9->C9_PEDIDO = cPedido
		
					RecLock("SC9",.F.)
		
					//Se cliente for Nova ou Total libera
					If SC9->C9_CLIENTE $ ('006543/007005')
						SC9->C9_BLCRED 	:= ""
						SC9->C9_BLEST 	:= ""
						SC9->C9_USRLBCR 	:= "FATC019"
					Else
						SC9->C9_BLCRED 	:= "01"
						SC9->C9_BLEST 	:= "02"
						SC9->C9_USRLBCR 	:= "FATC019"
					EndIf		
					MsUnLock()
		
					SC9->(DbSkip())
				end
			endif
		EndIf

		//*******************************************
	   	//FIM - da valida็ใo do credito do cliente.
		//*******************************************      
   endIf   
   End Transaction   
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldo90  บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos     บฑฑ
ฑฑบ          ณ em aberto com mais de 90 dias.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldo90(cCli, cLoja)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "
cQuery += " AND E1_VENCREA <= '" + DtoS(dDataBase - 90) + "' "

If Select("XSAL") > 0
	DbSelectArea("XSAL")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XSAL"

XSAL->( DbGoTop() )

nRet := XSAL->SALDO

Return nRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldoTit บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos     บฑฑ
ฑฑบ          ณ em aberto.                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldoTit(cCli, cLoja)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "

If Select("XSAL") > 0
	DbSelectArea("XSAL")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XSAL"

XSAL->( DbGoTop() )

nRet := XSAL->SALDO

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldoPed บ Autor ณ Gustavo Costa     บ Data ณ  27/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de pedido      บฑฑ
ฑฑบ          ณ a ser liberado.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldoPed(cPed)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM((C9_QTDLIB*C9_PRCVEN) + (C9_QTDLIB*C9_PRCVEN*B1_IPI)/100) VTOTAL "
cQuery += " FROM " + RetSqlName("SC9") + " C9 "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
cQuery += " ON C9_PRODUTO = B1_COD "
cQuery += " WHERE C9.D_E_L_E_T_ <> '*' " 
cQuery += " AND C9_PEDIDO = '" + cPed + "' "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

nRet := TMP->VTOTAL

Return nRet
