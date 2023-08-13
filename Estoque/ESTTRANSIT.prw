#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

*************

User Function ESTTRST()

*************

Local aIndex := {}
Local aCores := {{"F2_TRANSIT == 'S'", "BR_VERMELHO" },;
                 {"F2_TRANSIT == 'N'", "BR_VERDE"    }}
lMserroAuto := .F.                 
aRotina := {{"Pesquisar" , "AxPesqui"  , 0, 1},;
            {"Confirmar" , "U_TRANSF"  , 0, 6},;
            {"Legenda"   , "U_LegTrans", 0, 6}}
            
            
cCadastro := OemToAnsi("Liberação de Pedido ")

DbSelectArea("SF2")
DbSetOrder(1)
Set Filter to SF2->F2_TRANSIT != ""

mBrowse( 06, 01, 22, 75, "SF2",,,,,,aCores )

Return

*************

User Function TRANSF()

*************

if SF2->F2_TRANSIT == 'N'
	msgAlert("Essa nota já chegou! Favor escolher uma outra.")
	Return
elseIf SF2->F2_TRANSIT == 'S'
	SD2->( dbSetOrder(3) )
	SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )//Parar no primeiro
	Begin Transaction
	Do While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !Eof() )
		if SD2->D2_TES == '540'
				/*Movimentando retirando do almoxarifado 09*/
			    aMatriz :=  {{"D3_FILIAL" ,xFilial("SD3"),										 	Nil},;
			                 {"D3_COD"    ,SD2->D2_COD,											 	Nil},;
		   	    			 {"D3_DOC"    ,SD2->D2_DOC,											 	Nil},;
			    			 {"D3_TM"     ,"503",												 	Nil},;
			    			 {"D3_LOCAL"  ,"09",												 	Nil},;
			    			 {"D3_UM"     ,posicione("SB1",1,xFilial('SB1') + SD2->D2_COD,"B1_UM"), Nil},;
			    			 {"D3_QUANT"  ,SD2->D2_QUANT, 											Nil},;
			    			 {"D3_EMISSAO",dDataBase,												Nil},;
		 	    			 {"D3_OBS"    ,"NFE:"+SD2->D2_DOC,									 	Nil}}
		    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
			 	if lMsErroAuto
			 		msgAlert("ERRO NA TRANSFERÊNCIA! CONTACTE O SETOR DE T.I. !!!")
		 		    DisarmTransaction()
			 		Return
			 	endIf
			 	/*Movimentando inserindo no almoxarifado 10*/
			    aMatriz :=  {{"D3_FILIAL" ,xFilial("SD3"),										 	Nil},;
			                 {"D3_COD"    ,SD2->D2_COD,											 	Nil},;
		   	    			 {"D3_DOC"    ,SD2->D2_DOC,											 	Nil},;
			    			 {"D3_TM"     ,"003",												 	Nil},;
			    			 {"D3_LOCAL"  ,"10",												 	Nil},;
			    			 {"D3_UM"     ,posicione("SB1",1,xFilial('SB1') + SD2->D2_COD,"B1_UM"), Nil},;
			    			 {"D3_QUANT"  ,SD2->D2_QUANT, 											Nil},;
			    			 {"D3_EMISSAO",dDataBase,												Nil},;
		 	    			 {"D3_OBS"    ,"NFE:"+SD2->D2_DOC,									 	Nil}}
		    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
			 	if lMsErroAuto
			 		msgAlert("ERRO NA TRANSFERÊNCIA! CONTACTE O SETOR DE T.I. !!!")
	 	 		    DisarmTransaction()
			 		Return
			 	endIf
		endIf	
		SD2->( dbSkip() )
	endDo	
	RecLock("SF2",.F.)
	SF2->F2_TRANSIT := 'N'
	SF2->( MsUnLock() )
    End Transaction
else
	msgAlert("Nota sem infromações de trânsito! Favor escolher uma outra.")
	Return	
endIf
	
Return 

*************

User Function LegTrans()

*************

Local aLegenda := {{"BR_VERMELHO" ,"Em trânsito..."},;
   	   			   {"BR_VERDE"    ,"Em estoque..." }}

BrwLegenda("NFEs em trânsitos","Legenda",aLegenda)

Return .T.