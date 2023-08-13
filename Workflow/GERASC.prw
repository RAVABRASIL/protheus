#include "rwmake.ch"
#include "TbiConn.ch"
#include "topconn.ch"
#include "fivewin.ch"

//REGISTRO DE ALTERAÇÕES:
//FR - alterado em 16/08/13 - campo C1_OBS:
// contém agora: 
//Qtde do Pto Pedido (B1_ESTSEGX),
//A Qtde em Estoque (B2_QATU) no momento da geração da SC
//Hora da geração
//Flávia Rocha

*************

User Function WFGERASC()

*************

Static cUser
local aTamSX3
local nTamUser
local aCab     := { }
local aItem    := { }
local nItem    :=  1
local lSc      := .F.
local nPrazo   :=  0
local nSaveSX8
local aOps     := { }
local aSCs     := { }
local aOpsAm   := { }
local cBody    := ""
local cOP      := ""
local nPos     := 0
Local LF	   := CHR(13)+CHR(10) 
Local cCodGestor	:= ""
Local cMailGestor	:= ""
Local cNomeGestor	:= ""
Local aGestores		:= {}
Local aGestores2	:= {}
Local aUsu			:= {}

Local cMailTo := ""
Local cCopia  := ""
Local cAssun  := ""
Local cAnexo  := ""
Local cCCAnt		:= ""
Local cTipoAnt		:= ""
Local cSC		    := "" 
Local cPreAprovados := ""
Local aSCPC			:= {}
Local nQtaSC        := 0
Local nQtoPC 		:= 0  
Local DataSC        := Ctod("  /  /    ")
Local DataPC        := Ctod("  /  /    ")
Local dPrazo		:= Ctod("  /  /    ")
Local nQTemSC := 0
Local nQTemPC := 0
Local lGera   := .F. 
Local cError

/*
Gestores responsáveis por TIPO de Produto:

000119-Nilton  AC/ME
000008-Jorge   CL/MH/MQ
000112-Michele ML/RM
000188-Regineide  GG/MC/MA
000003-Alexandre WFGERASC
*/

conOut( "Iniciando programa WFGERASC - Gera SC/OP Automatica - " + Dtoc( Date() ) + ' - ' + Time() )

//MsgInfo( "Iniciando programa WFGERASC - Gera SC/OP Automatica - " + Dtoc( Date() ) + ' - ' + Time() )
//FR - 30/04/13 - CHAMADO 00000402
//ALINE SOLICITOU QUE OS PRODUTOS ABAIXO, JÁ SEJAM GERADAS AS RESPECTIVAS SCs JÁ LIBERADAS
//POIS SÃO PRODUTOS DE NECESSIDADE BÁSICA:
/*

PAPEL OFICIO MA 0201
PAPEL HIGIENICO ML 0101
PAPEL TOALHA EM FARDO ML 0124
PAPEL TOALHA EM ROLO ML 0121
COPO DESCARTAVEL P/ AGUA GG 0280
COPO DESCARTAVEL P/ CAFÉ GG 0279
ACUCAR  GG 0282
CAFÉ  GG 0281 
AGUA MINERAL BS0004 
GG0298 – Elemento filtrante .
*/
                   
cPreAprovados := "MA0201/ML0101/ML0124/ML0121/GG0280/GG0279/GG0282/GG0281/BS0004/GG0298"
//caso estes produtos pré-aprovados, não forem geradas SCs, é porque existe SC ou PC ainda em aberto
//não atendido, e por este motivo, estou implementando o envio de email aos responsáveis
//caso a SC automática não for gerada por este motivo (SC ou PC em aberto).

if Select( 'SX2' ) == 0
   RPCSetType( 3 ) // Não consome licensa de uso
   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" //FUNNAME "WFGERASC" Tables "SB1", "SB2", "SC1", "SC2"
   Sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.
endif

DbSelectArea("SX3")

aTamSX3  := TamSX3("C1_SOLICIT")
nTamUser := IIF(aTamSX3[1]<=15,aTamSX3[1],15)
cUser    := IF(cUser == NIL,RetCodUsr(),cUser)
nSaveSX8 := GetSX8Len() 

aProdURG := {}

////////////////////////////////
//Produtos Comprados - Gera SC  
///////////////////////////////
cQuery := "SELECT B1_COD,B1_UM,B1_SEGUM,B1_CONTA,B1_CC,B1_DESC,B1_ESTSEG, B1_EMIN, B1_LE, B1_PE, B1_CURVABC, B1_NMAXSC, B1_TIPO," +LF
cQuery += "ISNULL(B2_QATU,0) AS B2_QATU, B1_UM, B1_LOCPAD " +LF
cQuery += "FROM " +retSqlName('SB1')+ " SB1 LEFT JOIN " +retSqlName('SB2')+ " SB2 " +LF
cQuery += "ON B1_COD = B2_COD AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = ' '  " +LF
cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM <> 'S' " +LF
cQuery += "AND B2_QATU <= SB1.B1_ESTSEG " +LF
cQuery += "AND B1_EMIN > 0 " +LF	//Inclui Eurivan 01/07/08
cQuery += "AND LEN(B1_COD) <= 7 " +LF
cQuery += "AND B2_FILIAL = '" + xFilial( "SB2" ) + "' " +LF 

//cQuery += " AND B1_COD IN ('MQ1578', 'MQ1579', 'MQ1580', 'CL0407','MQ2433' ) " + LF  //TESTE
//cQuery += " AND RTRIM(B1_COD) in ('MH1247' ) " + LF  //TESTE
//FR - 30/07 -> CORRIGIDO QTO A GERAÇÃO INDEVIDA DE SCs CLASSES A, B, C (gerava sem necessidade, pois já haviam SC/PC abertos)

cQuery += "AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_CC, B1_TIPO, B1_COD " +LF
Memowrite("C:\Temp\GERASC.SQL", cQuery)
TCQUERY cQuery NEW ALIAS "SB1X1" 

/////////////////////////////////
//Produtos Fabricados - Gera OP  
/////////////////////////////////
cQuery := "SELECT B1_COD,B1_UM,B1_SEGUM,B1_CONTA,B1_CC, B1_DESC, B1_ESTSEG, B1_EMIN, B1_LE " +LF
cQuery += "FROM "+RetSqlName("SB1")+" SB1 " +LF
cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM = 'S' " +LF
cQuery += "AND B1_EMIN > 0 " +LF
cQuery += "AND LEN(B1_COD) <= 7 " +LF  

//cQuery += "and RTRIM(B1_COD) LIKE  'LALA%'" + LF     	////TESTE

cQuery += "AND B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_COD " +LF
MemoWrite("C:\Temp\GeraOp.sql", cQuery)
TCQUERY cQuery NEW ALIAS "SB1X2"

                                              //ESTSEGA              PTPRODA
//Produtos Fabricados - Gera OP para amostras  Estoque de Segurança e ponto de produção das amostras
cQuery := "SELECT B1_COD, B1_ESTSEGA, B1_PTPRODA " +LF
cQuery += "FROM "+RetSqlName("SB1")+" SB1 " +LF
cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM = 'S' " +LF
cQuery += "AND B1_ESTSEGA > 0 "//Estoque de segurança de amostras
cQuery += "AND LEN(B1_COD) <= 7 " +LF

//cQuery += " and RTRIM(B1_COD) LIKE 'LELE%' " + LF    ////TESTE

cQuery += "AND B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_COD " +LF   
MemoWrite("C:\Temp\GeraOpAM.sql", cQuery)

TCQUERY cQuery NEW ALIAS "SB1X3"


SB1X1->( DbGoTop() )
SB1X2->( DbGoTop() )
SB1X3->( DbGoTop() )


	DbSelectArea("SB2")
	DbSetOrder(1)

	while ! SB1X1->( EOF() )

	   if !SB2->( DbSeek(xFilial("SB2") + SB1X1->B1_COD + "01", .F. ) )
		  CriaSB2(SB1X3->B1_COD,"01")
	   	  
	   endIf
	 
	   	aSCPC	:= fVerSCPC(SB1X1->B1_COD , "Q")  //verifica qtas SCs / PCs este produto já possui em aberto
	   	//Aadd(aRetorno , { TMP1->QTASSC, TMP1->QTOSPC, TMP1->QTNASC, TMP1->QTNOPC } )  
       	nQTComprar := SB1X1->B1_LE
       	nQtaSC  := aSCPC[1,1]
		nQtoPC  := aSCPC[1,2]
		nQTemSC := aSCPC[1,3]
		nQTemPC := aSCPC[1,4]
        lGera   := .F. //indica se irá gerar a SC automática ou não
        
       //Elseif !TemSC( SB1X1->B1_COD ) .and. !TemPC( SB1X1->B1_COD )  //DESABILITADO, PELA NOVA SISTEMÁTICA DE REPOSIÇÃO
       //FR - 29/06/13 - SOLICITADO POR ORLEY
	   	            
		If Alltrim(SB1X1->B1_CURVABC) != "A"  //só pode ter UM, (SC ou PC)
						
			If (nQtaSC + nQtoPC) <= 0  //só pode ter no máximo um, os produtos com curva ABC = B ou C
				lGera := .T.
				
			ElseIf (nQtaSC + nQtoPC) >  0  //só pode ter no máximo um, os produtos com curva ABC = B ou C
				If nQTComprar > (nQTemSC + nQTemPC)
					lGera := .T. //irá gerar se a qtde a comprar do SB1 (B1_EMIN) for maior do que o que está em aberto em SC / PC
				Endif
			Endif
			
			If (nQtaSC + nQtoPC) <= 0  //só pode ter no máximo um, os produtos com curva ABC = B ou C
			//If lGera
					
				//If cCCAnt <> SB1X1->B1_CC .Or. cTipoAnt <> SB1X1->B1_TIPO 
					cSC  := GetSxENum("SC1","C1_NUM")
					while SC1->( DbSeek( xFilial( "SC1" ) + cSC ) )
				   		ConfirmSX8()
				   		cSC := GetSxeNum("SC1","C1_NUM")
					enddo
					ConfirmSX8()
				//EndIf
			
				RecLock("SC1",.T.)
				SC1->C1_FILIAL  := xFilial("SC1")
			    SC1->C1_FILENT  := xFilEnt(C1_FILIAL)
			   	SC1->C1_NUM     := cSC
			    SC1->C1_ITEM    := StrZero( nItem, 4 )
			  	SC1->C1_EMISSAO := dDataBase
			    SC1->C1_PRODUTO := SB1X1->B1_COD
			    SC1->C1_LOCAL   := RetFldProd( SB1X1->B1_COD, "B1_LOCPAD", "SB1X1" )
			    SC1->C1_UM      := SB1X1->B1_UM
			    SC1->C1_SEGUM   := SB1X1->B1_SEGUM
			    SC1->C1_DESCRI  := SB1X1->B1_DESC
			    SC1->C1_QUANT   := SB1X1->B1_LE
			    SC1->C1_CONTA   := SB1X1->B1_CONTA
			    SC1->C1_CC      := SB1X1->B1_CC
			    SC1->C1_QTSEGUM := ConvUm(SB1X1->B1_COD,SB1X1->B1_LE,0,2)
			    SC1->C1_USER    := "000000"
			    SC1->C1_SOLICIT := "Administra"
			    SC1->C1_ORIGEM  := "WFGERASC"
			    SC1->C1_DATPRF  := dDataBase + SB1X1->B1_PE  //Soma DATABASE + Prazo Entrega do Cadastro do produto
			    SC1->C1_OBS     := "SC.Pto Pedido: " + Alltrim(Str(SB1X1->B1_ESTSEG)) + " - ESTQ: " + Alltrim(Str(SB1X1->B2_QATU)) + " Hr: " + Substr(Time(),1,5)
			    If !Alltrim(SB1X1->B1_COD) $ Alltrim(cPreAprovados)          //se o produto não estiver na lista dos pré-aprovados, já entra bloqueada a SC
//			    	SC1->C1_APROV   := "B"
				Else
			    	SC1->C1_APROV   := "L"     //FR - 30/04/13 - chamado 00000402
			      	SC1->C1_NOMAPRO := "Administra"
			      	SC1->C1_DTAPROV := dDatabase
			    Endif                        //se o produto estiver na lista dos pré-aprovados, a SC já entra liberada
			    SC1->C1_TPPROD  := SB1X1->B1_TIPO
			    lSC := .T.
			    //nItem ++
			    nItem := 1
			    SC1->(MsUnlock()) 
			    
			    ///////////////////////////////////////////////////////////////
			    ////Procura no SX5 o responsável pelo tipo do Produto... 
			    ///////////////////////////////////////////////////////////////
			    /*
					Gestores responsáveis por TIPO de Produto:
					
					000119-Nilton  AC/ME
					000008-Jorge   CL/MH/MQ
					000112-Michele ML/RM
					000188-Regineide  GG/MC/MA
					000003-Alexandre WFGERASC
				*/
			      	DbselectArea("SX5")
					SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
					While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
						If Alltrim(SC1->C1_TPPROD) $ Alltrim(SX5->X5_DESCRI)
							cCodGestor := SX5->X5_CHAVE
						Elseif ( Alltrim(SC1->C1_TPPROD) != "AC" .and. Alltrim(SC1->C1_TPPROD) != "ME" .and. Alltrim(SC1->C1_TPPROD) != "CL" ;
						.and. Alltrim(SC1->C1_TPPROD) != "MH" .and. Alltrim(SC1->C1_TPPROD) != "MQ" .and. Alltrim(SC1->C1_TPPROD) != "ML";
						.and. Alltrim(SC1->C1_TPPROD) != "RM" .and. Alltrim(SC1->C1_TPPROD) != "GG" .and. Alltrim(SC1->C1_TPPROD) != "MC";
						.and. Alltrim(SC1->C1_TPPROD) != "MA" )  //se for diferente de qq um destes, o gestor é Alexandre										
							cCodGestor := "000003"
						Endif
						SX5->(Dbskip())
					Enddo
			
						
					PswOrder(1)
					If PswSeek( cCodGestor, .T. )
					   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
					   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
					   cNomeGestor := Alltrim(aUsu[1][2])		// Nome do usuário
					   cMailGestor := Alltrim( aUsu[1][14] )     
					Endif
						
					//aGestores -> array utilizado no momento do envio do email aviso das SCs geradas
						
					aAdd( aGestores, { SC1->C1_NUM,;		//1
									 SC1->C1_ITEM,;	   		//2
					      			 SC1->C1_PRODUTO,;		//3
					      			 SC1->C1_TPPROD,;		//4
					       			 SC1->C1_DESCRI,;   	//5
					   			     SC1->C1_QUANT,;	  	//6
					   			     SC1->C1_OBS,;    		//7
					   			     SC1->C1_DATPRF,;		//8
					   			     cMailGestor ,;			//9
					   			     cNomeGestor,;			//10
					   			     SC1->C1_SOLICIT,;		//11
					   			     cCodGestor,;			//12
					   			     SC1->C1_EMISSAO })		//13
	      
	      		      Aadd( aSCs, { SC1->C1_FILIAL,;      	//1
							      SC1->C1_FILENT,;      //2
							   	  SC1->C1_NUM,;         //3
							      SC1->C1_ITEM,;        //4
							  	  SC1->C1_EMISSAO,;     //5
							      SC1->C1_PRODUTO,;     //6
							      SC1->C1_LOCAL,;       //7
							      SC1->C1_UM,;          //8
							      SC1->C1_SEGUM,;       //9
							      SC1->C1_DESCRI,;      //10
							      SC1->C1_QUANT,;       //11
							      SC1->C1_CONTA,;       //12
							      SC1->C1_CC,;
							      SC1->C1_QTSEGUM,;
							      SC1->C1_USER,;
							      SC1->C1_SOLICIT,;
							      SC1->C1_ORIGEM,;
							      SC1->C1_DATPRF,;
							      SC1->C1_OBS,;
							      SC1->C1_APROV } )     
					      
				   		cCCAnt 		:= SB1X1->B1_CC
				   		cTipoAnt 	:= SB1X1->B1_TIPO
			    
	        Else  //lGera
	        	//	MSGINFO("ja tem pc ou sc -> " + SB1X1->B1_COD )
	        	///enviará email sobre produtos urgentes, que não foram geradas SCs, devido já terem SC e PC em aberto
	        	lUrgente := .F.
	        	lUrgente := iif( Alltrim(SB1X1->B1_COD) $ Alltrim(cPreAprovados) , .T., .F. )
	        	If lUrgente
	        		Aadd( aProdURG , SB1X1->B1_COD )
	        	Endif
	        	
	        Endif //nQtas SC ou PC
	        
	    Else  //se curva ABC = A
	    	dPrazo := dDataBase
	    	de	   := 0
	    	ate    := 0	    
	        QTOS   := 2 - (nQtaSC + nQtoPC)
	        //QTOS := 2
	        //nQTComprar := SB1X1->B1_EMIN
       		//nQtaSC  := aSCPC[1,1]
			//nQtoPC  := aSCPC[1,2]
			//nQTemSC := aSCPC[1,3]
			//nQTemPC := aSCPC[1,4]
        	lGera   := .F. //indica se irá gerar a SC automática ou não
        
	    	//If (nQtaSC + nQtoPC) <= 1
	    	If (nQtaSC + nQtoPC) <= 1//só pode ter no máximo um, os produtos com curva ABC = B ou C
				lGera := .T.
				
			Else  //If (nQtaSC + nQtoPC) >= 1
				If nQTComprar > (nQTemSC + nQTemPC)
					lGera := .T. //irá gerar se a qtde a comprar do SB1 (B1_EMIN) for maior do que o que está em aberto em SC / PC
				Endif
			Endif
			
			//If lGera
			If (nQtaSC + nQtoPC) <= 1
	    		//se já tem um pedido ou SC, calcular a data da necessidade com base na última data da SC ou último PC já colocado
	    		aSCPC	:= fVerSCPC(SB1X1->B1_COD , "D")  //verifica a última Data necessidade de SCs / PCs este produto possui em aberto
		    	DATASC  := aSCPC[1,1]
				DATAPC  := aSCPC[1,2]
				If (!Empty(DATAPC) .or. !Empty(DATASC) )	    				
					If DATAPC > DATASC 
						dPrazo := DATAPC
					Else
						dPrazo := DATASC
					Endif
				Endif
				
	    		If dPrazo <= dDatabase
	    			//alert("menor")
	    			dPrazo := dDatabase 	    		
	    		Endif
	    		
	    		For fr := 1 to QTOS  // <= 1  //só pode ter no máximo 2, os produtos com curva ABC = A
	    				    				
					//If cCCAnt <> SB1X1->B1_CC .Or. cTipoAnt <> SB1X1->B1_TIPO 
						cSC  := GetSxENum("SC1","C1_NUM")
						while SC1->( DbSeek( xFilial( "SC1" ) + cSC ) )
					   		ConfirmSX8()
					   		cSC := GetSxeNum("SC1","C1_NUM")
						enddo
						ConfirmSX8()
					//EndIf
				
					RecLock("SC1",.T.)
					SC1->C1_FILIAL  := xFilial("SC1")
				    SC1->C1_FILENT  := xFilEnt(C1_FILIAL)
				   	SC1->C1_NUM     := cSC
				    SC1->C1_ITEM    := StrZero( nItem, 4 )
				  	SC1->C1_EMISSAO := dDataBase
				    SC1->C1_PRODUTO := SB1X1->B1_COD
				    SC1->C1_LOCAL   := RetFldProd( SB1X1->B1_COD, "B1_LOCPAD", "SB1X1" )
				    SC1->C1_UM      := SB1X1->B1_UM
				    SC1->C1_SEGUM   := SB1X1->B1_SEGUM
				    SC1->C1_DESCRI  := SB1X1->B1_DESC
				    SC1->C1_QUANT   := SB1X1->B1_LE
				    SC1->C1_CONTA   := SB1X1->B1_CONTA
				    SC1->C1_CC      := SB1X1->B1_CC
				    SC1->C1_QTSEGUM := ConvUm(SB1X1->B1_COD,SB1X1->B1_LE,0,2)
				    SC1->C1_USER    := "000000"
				    SC1->C1_SOLICIT := "Administra"
				    SC1->C1_ORIGEM  := "WFGERASC"
				    SC1->C1_DATPRF  := dPrazo + SB1X1->B1_PE  //Soma DATABASE + Prazo Entrega do Cadastro do produto
				    SC1->C1_OBS     := "SC.Pto Pedido: " + Alltrim(Str(SB1X1->B1_ESTSEG)) + " - ESTQ: " + Alltrim(Str(SB1X1->B2_QATU)) + " Hr: " + Substr(Time(),1,5)
				    If !Alltrim(SB1X1->B1_COD) $ Alltrim(cPreAprovados)          //se o produto não estiver na lista dos pré-aprovados, já entra bloqueada a SC
				    	SC1->C1_APROV   := "B"
					Else
				    	SC1->C1_APROV   := "L"     //FR - 30/04/13 - chamado 00000402
				      	SC1->C1_NOMAPRO := "Administra"
				      	SC1->C1_DTAPROV := dDatabase
				    Endif                        //se o produto estiver na lista dos pré-aprovados, a SC já entra liberada
				    SC1->C1_TPPROD  := SB1X1->B1_TIPO
				    lSC := .T.
				    //nItem ++
				    nItem := 1
				    SC1->(MsUnlock())
		    		dPrazo := SC1->C1_DATPRF
		    		
		    		
		    		///////////////////////////////////////////////////////////////
				    ////Procura no SX5 o responsável pelo tipo do Produto... 
				    ///////////////////////////////////////////////////////////////
				    /*
						Gestores responsáveis por TIPO de Produto:
						
						000119-Nilton  AC/ME
						000008-Jorge   CL/MH/MQ
						000112-Michele ML/RM
						000188-Regineide  GG/MC/MA
						000003-Alexandre WFGERASC
					*/
				      DbselectArea("SX5")
						SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
						While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
							If Alltrim(SC1->C1_TPPROD) $ Alltrim(SX5->X5_DESCRI)
								cCodGestor := SX5->X5_CHAVE
							Elseif ( Alltrim(SC1->C1_TPPROD) != "AC" .and. Alltrim(SC1->C1_TPPROD) != "ME" .and. Alltrim(SC1->C1_TPPROD) != "CL" ;
							.and. Alltrim(SC1->C1_TPPROD) != "MH" .and. Alltrim(SC1->C1_TPPROD) != "MQ" .and. Alltrim(SC1->C1_TPPROD) != "ML";
							.and. Alltrim(SC1->C1_TPPROD) != "RM" .and. Alltrim(SC1->C1_TPPROD) != "GG" .and. Alltrim(SC1->C1_TPPROD) != "MC";
							.and. Alltrim(SC1->C1_TPPROD) != "MA" )  //se for diferente de qq um destes, o gestor é Alexandre										
								cCodGestor := "000003"
							Endif
							SX5->(Dbskip())
						Enddo
			
						
						PswOrder(1)
						If PswSeek( cCodGestor, .T. )
						   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
						   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
						   cNomeGestor := Alltrim(aUsu[1][2])		// Nome do usuário
						   cMailGestor := Alltrim( aUsu[1][14] )     
						Endif
						
						//aGestores -> array utilizado no momento do envio do email aviso das SCs geradas
						
						aAdd( aGestores, { SC1->C1_NUM,;		//1
										 SC1->C1_ITEM,;	   		//2
						      			 SC1->C1_PRODUTO,;		//3
						      			 SC1->C1_TPPROD,;		//4
						       			 SC1->C1_DESCRI,;   	//5
						   			     SC1->C1_QUANT,;	  	//6
						   			     SC1->C1_OBS,;    		//7
						   			     SC1->C1_DATPRF,;		//8
						   			     cMailGestor ,;			//9
						   			     cNomeGestor,;			//10
						   			     SC1->C1_SOLICIT,;		//11
						   			     cCodGestor,;			//12
						   			     SC1->C1_EMISSAO })		//13
	      
					      Aadd( aSCs, { SC1->C1_FILIAL,;      	//1
									      SC1->C1_FILENT,;      //2
									   	  SC1->C1_NUM,;         //3
									      SC1->C1_ITEM,;        //4
									  	  SC1->C1_EMISSAO,;     //5
									      SC1->C1_PRODUTO,;     //6
									      SC1->C1_LOCAL,;       //7
									      SC1->C1_UM,;          //8
									      SC1->C1_SEGUM,;       //9
									      SC1->C1_DESCRI,;      //10
									      SC1->C1_QUANT,;       //11
									      SC1->C1_CONTA,;       //12
									      SC1->C1_CC,;
									      SC1->C1_QTSEGUM,;
									      SC1->C1_USER,;
									      SC1->C1_SOLICIT,;
									      SC1->C1_ORIGEM,;
									      SC1->C1_DATPRF,;
									      SC1->C1_OBS,;
									      SC1->C1_APROV } )     
					      
					   		cCCAnt 		:= SB1X1->B1_CC
					   		cTipoAnt 	:= SB1X1->B1_TIPO
		    		
		   		Next
		    Else  //lGera
		    	///enviará email sobre produtos urgentes, que não foram geradas SCs, devido já terem SC e PC em aberto
		    	lUrgente := .F.
	        	lUrgente := iif( Alltrim(SB1X1->B1_COD) $ Alltrim(cPreAprovados) , .T., .F. )
	        	If lUrgente
	        		Aadd( aProdURG , SB1X1->B1_COD )
	        	Endif
	        	
		    Endif  //qtos pc sc
	    Endif  //curva ABC
	    
	      
	  
	   SB1X1->( DbSkip() )
	Enddo
	
	////Ordena o array por ordem de Gestor + SC + item
	aGestores := Asort( aGestores,,, { |X,Y| X[12] + X[3] + X[4] <  Y[12] + Y[3] + Y[4] } ) 

	DbSelectArea("SB2")
	DbSetOrder(1)
	
	aOps   := {}
	aOpsAm := {}
	nQtd  := 0
	nMult := 1
	
	while ! SB1X2->( EOF() )   
	   aCart := Carteira( SB1X2->B1_COD )  
	   SB2->(DbSeek(xFilial("SB2")+SB1X2->B1_COD+"01"  ) )
	   nQtd := ( aCart[1] - SB2->B2_QTSEGUM )
	   if nQtd > SB1X2->B1_LE
	      nResto := Mod( nQtd, SB1X2->B1_LE )
	      if nResto != 0  
	         nMult := Int( nQtd/SB1X2->B1_LE ) + 1
	         nQtd  := nMult*SB1X2->B1_LE
	      endif   
	   else
	      nQtd  := SB1X2->B1_LE     
	   endif
	   
	   if !TemOPBB( SB1X2->B1_COD ) //Testo se nao tem Saldo OP ou Bobina
	      DbSelectArea("SC2")
	      aMATRIZ     := {}
		  lMsErroAuto := .F.
		  aMATRIZ     := { { "C2_PRODUTO", SB1X2->B1_COD                 , NIL },;
	                  	   { "C2_QTSEGUM", nQtd                          , NIL },;
	                  	   { "C2_PRIOR"  , "500"                         , NIL },;
	                   	   { "C2_DESTINA", "E"                           , NIL },;
	                   	   { "C2_TPOP"   , "F"                           , NIL },;
	                   	   { "C2_OPVIP"  , "S"                           , NIL },;
	                   	   { "C2_OBS"    , "Gerada por Ponto de Producao", NIL },;                   	                     		
	                   	   { "AUTEXPLODE", "S"                           , NIL } }
			
		  MSExecAuto( { |x,y| MATA650(x,y) }, aMATRIZ, 3 ) 
		  if lMsErroAuto         	  
	      	If (!IsBlind()) // COM INTERFACE GRÁFICA
	      		MostraErro()
	      	Else // EM ESTADO DE JOB
	      		cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

	      		ConOut(PadC("Automatic routine ended with error", 80))
	      		ConOut("Error: "+ cError)
	      	EndIf
		  Endif
	      Aadd( aOps, { SC2->C2_NUM, SB1X2->B1_COD, SB1X2->B1_LE } )     
	   endif 
	   SB1X2->( DbSkip() )
	enddo
	
	while ! SB1X3->( EOF() )
	   if ! SB2->( DbSeek(xFilial("SB2") + SB1X3->B1_COD + "03", .F. ) )
		  CriaSB2(SB1X3->B1_COD,"03")
	   	  
	   endIf
	   if SB1X3->B1_ESTSEGA < SB2->B2_QATU       //SB1X3->B1_ESTSEGA < SB2->B2_QTSEGUM    //SB1X3->B1_ESTSEGA >= SB2->B2_QTSEGUM
	        SB1X3->( DbSkip() )
			Loop
	   endif   
	   if TemOPLIC(SB1X3->B1_COD) >= SB1X3->B1_ESTSEGA
	        SB1X3->( DbSkip() )
	   		Loop
	   endIf
	   DbSelectArea("SC2")
	   aMATRIZ     := {}
	   lMsErroAuto := .F.
	   aMATRIZ     := { { "C2_PRODUTO", SB1X3->B1_COD                , NIL },;
	                	{ "C2_QUANT"  , SB1X3->B1_PTPRODA            , NIL },;
	               	    { "C2_PRIOR"  , "500"                        , NIL },;
	                   	{ "C2_DESTINA", "E"                          , NIL },;
	                   	{ "C2_TPOP"   , "F"                          , NIL },;
	                   	{ "C2_OPVIP"  , "S"                          , NIL },;
	                   	{ "C2_OBS"    , "Gerada por Pto.Prod.Amostra", NIL },;
	                   	{ "C2_OPLIC"  , "S"                          , NIL },;
	                   	{ "AUTEXPLODE", "S"                          , NIL } }	
	   MSExecAuto( { |x,y| MATA650(x,y) }, aMATRIZ, 3 )  
	   cOP := SC2->C2_NUM
	   if lMsErroAuto         	  
	      	If (!IsBlind()) // COM INTERFACE GRÁFICA
	      		MostraErro()
	      	Else // EM ESTADO DE JOB
	      		cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

	      		ConOut(PadC("Automatic routine ended with error", 80))
	      		ConOut("Error: "+ cError)
	      	EndIf
       endIf
	   nPos := SC2->( Recno() )
	   do While cOP == SC2->C2_NUM .and. SC2->( !EoF() )
	   	  Reclock("SC2",.F.)
	      SC2->C2_OPLIC = "S"
	      SC2->( msUnlock() )
	      SC2->( dbSkip() )
	   endDo
	   SC2->( dbGoTo(nPos) )
	   Aadd( aOpsAm, { cOp, SB1X3->B1_COD, SB1X3->B1_PTPRODA } )     
	   SB1X3->( DbSkip() )
	enddo
	
	//End Transaction
	
	if lSC
		conOut( "Foi gerada a SC: "+cSC )      
	else
		conOut( "Não existem solicitações de compras para serem geradas" )      
	endIf
	
	if len(aSCs) > 0
	   conOut( "Gerada(s) Solicitação(ões) de Compra" )
	   fEnviaSC(aGestores)
	Else
	   conOut( "Nao existe(m) produto(s) em estoque minimo para gerar SC." )      
	   //msginfo( "Nao existe(m) produto(s) em estoque minimo para gerar SC." )      //teste
	endif 

	if len(aOps) > 0
	   conOut( "Foi(ram) gerada(s) Ordem(s) de Producao" )
	   cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	   cBody += '<html xmlns="http://www.w3.org/1999/xhtml"> '
	   cBody += '<head> '
	   cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	   cBody += '<title>Untitled Document</title> '
	   cBody += '</head> '
	   cBody += '<body> '
	   cBody += '<p>Caro respons&aacute;vel pelo setor de Produ&ccedil;&atilde;o,</p> '
	   cBody += '<p>A seguir veja todas as Ordens de Produ&ccedil;&atilde;o que foram criadas automaticamente, na Filial: ' + SM0->M0_FILIAL + '.</p> '
	   cBody += '<table width="471" border="1"> '
	   cBody += '  <tr> '
	   cBody += '    <th bgcolor="#33CC33" width="145" scope="col">N&uacute;mero da OP </th> '
	   cBody += '    <th bgcolor="#33CC33" width="147" scope="col">C&oacute;digo do Produto </th> '
	   cBody += '    <th bgcolor="#33CC33" width="157" scope="col">Quantidade</th> '
	   cBody += '  </tr> '
	   
	   for _nX := 1 to Len(aOps)        
	   
			cBody += "<tr>"
			cBody += "  <td>"+alltrim(aOps[_nx,1])+"</td> "
			cBody += "  <td>"+alltrim(aOps[_nx,2])+"</td> "
			cBody += "  <td align='right'>"+transform(aOps[_nx,3],"@E 999,999,999.99")+"</td> "
	   		cBody += "</tr>"
	   next _nX     
	   cBody += '</table> '
	   cBody += '<p>&nbsp;</p> '
	   cBody += '</body> '
	   cBody += '</html> '
	   
	   cMailTo := "renato.maia@ravaembalagens.com.br"
	   //cMailTo := "" //teste
	   cCopia  := "flavia.rocha@ravaembalagens.com.br"
	   cAssun  := "OP por Ponto de Produção"
	   cAnexo  := ""
	   SendMailSC(cMailTo, cCopia, cAssun, cBody, cAnexo )
	   
	else
	   conOut( "Nao existe(m) produto(s) em estoque minimo para gerar SC/OP." )      
	endif
	
	
	if len(aOpsAm) > 0
	   conOut( "Foi(ram) gerada(s) Ordem(s) de Producao de Amostra" )
	   cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	   cBody += '<html xmlns="http://www.w3.org/1999/xhtml"> '
	   cBody += '<head> '
	   cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	   cBody += '<title>Untitled Document</title> '
	   cBody += '</head> '
	   cBody += '<body> '
	   cBody += '<p>Caro respons&aacute;vel pelo setor de Produ&ccedil;&atilde;o,</p> '
	   cBody += '<p>A seguir veja todas as Ordens de Produ&ccedil;&atilde;o de Amostra que foram criadas automaticamente, na filial: Rava/Emb.</p> '
	   cBody += '<table width="471" border="1"> '
	   cBody += '  <tr> '
	   cBody += '    <th bgcolor="#33CC33" width="145" scope="col">N&uacute;mero da OP </th> '
	   cBody += '    <th bgcolor="#33CC33" width="147" scope="col">C&oacute;digo do Produto </th> '
	   cBody += '    <th bgcolor="#33CC33" width="157" scope="col">Quantidade</th> '
	   cBody += '  </tr> '
	  
	   for _nX := 1 to Len(aOpsAm)        
	      //cBody += aOps[_nx,1]+' - '+aOps[_nx,2]+"<br> <br>"  
			cBody += "<tr>"
			cBody += "  <td>"+alltrim(aOpsAm[_nx,1])+"</td> "
			cBody += "  <td>"+alltrim(aOpsAm[_nx,2])+"</td> "
			cBody += "  <td align='right'>"+transform(aOpsAm[_nx,3],"@E 999,999,999.99")+"</td> "
	   		cBody += "</tr>"
	   next _nX     
	   cBody += '</table> '
	   cBody += '<p>&nbsp;</p> '
	   cBody += '</body> '
	   cBody += '</html> '
	   //U_EnviaMail('rodrigo.pereira@ravaembalagens.com.br;alexandre@ravaembalagens.com.br', 'OP de Amostra por Ponto de Produção', cBody)     
	   
	   cMailTo := "renato.maia@ravaembalagens.com.br"
	   //cMailTo := "" //teste
	   cCopia  := "flavia.rocha@ravaembalagens.com.br"
	   cAssun  := "OP de Amostra por Ponto de Produção"
	   cAnexo  := ""
	   SendMailSC(cMailTo, cCopia, cAssun, cBody, cAnexo )
	   
	endif
	
	//produtos urgentes que não geraram SC
	If Len(aProdURG) > 0
		//alert("vai enviar")
		t := 0
		cMsg   := "GERA SCs Automatica -  Filial: " + xFilial("SB1") + CHR(13) + CHR(10)
		cMsg   += "Data: " + Dtoc(Date()) + CHR(13) + CHR(10)
		cMsg   += "Hora: " + Time() + CHR(13) + CHR(10)
		cMsg   += " Os Seguintes Produtos NAO Foram Geradas SCs Automaticas, por Possuirem SC/PC em ABERTO:" + CHR(13) + CHR(10) + CHR(13) + CHR(10)
		For t := 1 to Len(aProdURG)
			cMsg += " -> " + aProdURG[t] + ";" + CHR(13) + CHR(10)
		Next
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		eEmail := ";romildo@ravaembalagens.com.br"
		
		subj   := "PRODUTOS URGENTES cuja SC Automatica NAO GEROU - Filial: "+ xFilial() + LF
		U_SendFatr11(eEmail, "", subj, cMsg, "" )
	
	Endif
	
	SB1X1->( DbCloseArea() )
	SB1X2->( DbCloseArea() )
	SB1X3->( DbCloseArea() )
	
	conOut( "Finalizando programa WFGERASC - Gera SC/OP Automatica - " + Dtoc( DATE() ) + ' - ' + Time() )
	//MsgInfo( "Finalizando programa WFGERASC - Gera SC/OP Automatica - " + Dtoc( DATE() ) + ' - ' + Time() )
	
	cMsg  := ""
	eEmail:= ""
	subj  := ""
	
	cMsg   := "WORKFLOW - GERASC ->"+ Time() + chr(13) + chr(10)
	cMsg   += "Data: " + Dtoc(Date()) + chr(13) + chr(10)
	cMsg   += "Hora: " + Time() + chr(13) + chr(10)
	eEmail := "flavia.rocha@ravaembalagens.com.br"
	subj   := "WORKFLOW - GERASC->" + Time()
	U_SendFatr11(eEmail, "", subj, cMsg, "" ) 	


	
return

***********************************
Static Function fEnviaSC(aGestores)
***********************************

Local _nX := 1
Local LF  := CHR(13)+CHR(10)
Local cCodGestor := ""
Local cNomeGestor:= ""
Local cMailGestor:= "" 

	   			     

If Len(aGestores) > 0
	
	While _nX  <= Len(aGestores)
	
		////CRIA O PROCESSO WORKFLOW
		oProcess:=TWFProcess():New("MAIL SC","NOVA SC")
		oProcess:NewTask('Inclusao SC',"\workflow\http\oficial\GERASC_Aviso.htm")
		oHtml := oProcess:oHtml
		
		oHtml:ValByName("cNumSC", aGestores[_nX,1] )
		oHtml:ValByName("dEmissao"  , Dtoc(aGestores[_nX,13])  ) 		
			
		oProcess:cSubject:= "SC Automática"		
		
		cCodGestor := aGestores[_nX,12]
		
		Do while _nX <= Len(aGestores) .and. Alltrim(aGestores[_nX,12]) == Alltrim(cCodGestor)	
				      
			aadd( oHtml:ValByName("it.cItem")  , aGestores[_nX,2] )  					//ITEM
			aadd( oHtml:ValByName("it.cProd")  , aGestores[_nX,3] )  					//COD. PRODUTO
			aadd( oHtml:ValByName("it.cTipoProd")  , aGestores[_nX,4]) 					//TIPO PRODUTO
			aadd( oHtml:ValByName("it.cDesc")  , aGestores[_nX,5] )       				//DESCRIÇÃO PRODUTO
			aadd( oHtml:ValByName("it.nQtde") , aGestores[_nX,6] )     					//QTDE
			aadd( oHtml:ValByName("it.cObs"), aGestores[_nX,7] )         				//OBSERVAÇÃO
			//aadd( oHtml:ValByName("it.dDatprf"), Dtoc( aGestores[_nX,8]) )	       		//NECESSIDADE
			cMailGestor		:= aGestores[_nX,9]	      
			cNomeGestor 	:= aGestores[_nX,10]
				      
			_nX++
				      
		Enddo
		oHtml:ValByName("cNomeGestor", cNomeGestor )      //Nome do Gestor
		oHtml:ValByName("cMailGestor", cMailGestor )      //Nome do Gestor


		oProcess:cTo:= cMailGestor 
		oProcess:cCC:= "" 
		oProcess:cBCC:= "flavia.rocha@ravaembalagens.com.br"
		oProcess:Start()
		WfSendMail()
		//MsgInfo( "Gerada(s) Solicitação(ões) de Compra" ) //teste			
	Enddo		
Endif


Return

//Verifica se tem sol.compras
//para o produto informado
*******************************
static function TemSC( cProd )
*******************************

local cQuery
local lTem

cQuery := "SELECT TOP 1 C1_QUANT  "
cQuery += "FROM "+RetSqlname("SC1")+" SC1 " 
cQuery += "WHERE SC1.C1_PRODUTO = '"+cProd+"' "
cQuery += "               AND SC1.C1_PEDIDO = '' AND SC1.C1_ITEMPED = '' " + CHR(13) + CHR(10)         //SEM PEDIDOS GERADOS
cQuery += "               AND SC1.C1_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
cQuery += "               AND SC1.C1_APROV <> 'R' "+ CHR(13) + CHR(10)    //SEM Q A SC ESTEJA REJEITADA
cQuery += "               AND SC1.C1_FILIAL = '" + xFilial("SC1") + "'  "
cQuery += " AND SC1.C1_EMISSAO >= '20080401' "
cQuery += "AND SC1.D_E_L_E_T_ = ''  "

TCQUERY cQuery NEW ALIAS "TMP1"
lTem := !TMP1->(EOF())
TMP1->(DbCloseArea())

return lTem

//Verifica se tem Pedido de Compra
//Para o produto informado
****************************
Static Function TemPC(cProd)
****************************

local cQuery
local lTem
cQuery := " SELECT TOP 1 C7_NUM "
cQuery += " FROM "+ RetSqlName("SC7") + " "
cQuery += " WHERE  C7_PRODUTO = '" + alltrim(cProd) + "' "
cQuery += " AND (C7_QUANT - C7_QUJE > 0 AND C7_RESIDUO <> 'S' ) "
cQuery += " AND SC7.C7_CONAPRO <> 'B' "+ CHR(13) + CHR(10)    //SEM Q O PC ESTEJA BLOQUEADO
cQuery += "AND C7_FILIAL = '" + xFilial("SC7") + "' AND D_E_L_E_T_ != '*' " 
MemoWrite("C:\TEMP\TEMPC.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMP1"
lTem := !TMP1->(EOF())
TMP1->(DbCloseArea())

return lTem

//Verifica QTAS SCs existem
//para o produto informado
*******************************
static function fVerSCPC( cProd, cTipo )
*******************************

local cQuery
local lTem 
local aRetorno := {}
local dDATAS    := CTOD("  /  /    ")
local dDATAP    := CTOD("  /  /    ")

If Alltrim(cTipo) = "Q" //só verifica qtde
	cQuery := "SELECT QTASSC=( SELECT  COUNT (*)  " + CHR(13) + CHR(10)
	cQuery += "               FROM " + RetSqlName("SC1") + " SC1 WHERE SC1.D_E_L_E_T_ = '' AND SC1.C1_PRODUTO = SB1.B1_COD "+ CHR(13) + CHR(10)
	cQuery += "               AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "               AND C1_PEDIDO = '' AND C1_ITEMPED = '' " + CHR(13) + CHR(10)         //SEM PEDIDOS GERADOS
	cQuery += "               AND SC1.C1_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	cQuery += "               AND SC1.C1_APROV <> 'R' "+ CHR(13) + CHR(10)    //SEM Q A SC ESTEJA REJEITADA
	cQuery += "               AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' ) " + CHR(13) + CHR(10)
	
	cQuery += " ,QTNASC =( SELECT  SUM(C1_QUANT)  " + CHR(13) + CHR(10)        //QTDE NA SC
	cQuery += "               FROM " + RetSqlName("SC1") + " SC1 WHERE SC1.D_E_L_E_T_ = '' AND SC1.C1_PRODUTO = SB1.B1_COD "+ CHR(13) + CHR(10)
	cQuery += "               AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "               AND C1_PEDIDO = '' AND C1_ITEMPED = '' " + CHR(13) + CHR(10)         //SEM PEDIDOS GERADOS
	cQuery += "               AND SC1.C1_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	cQuery += "               AND SC1.C1_APROV <> 'R' "+ CHR(13) + CHR(10)    //SEM Q A SC ESTEJA REJEITADA
	cQuery += "               AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' ) " + CHR(13) + CHR(10)
	
	cQuery += " , QTOSPC=( SELECT  COUNT (*)  " + CHR(13) + CHR(10)
	cQuery += "           FROM " + RetSqlName("SC7") + " SC7 WHERE SC7.D_E_L_E_T_ = '' AND SC7.C7_PRODUTO = SB1.B1_COD " + CHR(13) + CHR(10)
	cQuery += "           AND (SC7.C7_QUANT - SC7.C7_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "           AND SC7.C7_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	//cQuery += "           AND SC7.C7_CONAPRO <> 'B' "+ CHR(13) + CHR(10)    //SEM Q O PC ESTEJA BLOQUEADO
	cQuery += "           AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' ) "+ CHR(13) + CHR(10)
	
	cQuery += " , QTNOPC=( SELECT  SUM(C7_QUANT)  " + CHR(13) + CHR(10)
	cQuery += "           FROM " + RetSqlName("SC7") + " SC7 WHERE SC7.D_E_L_E_T_ = '' AND SC7.C7_PRODUTO = SB1.B1_COD " + CHR(13) + CHR(10)
	cQuery += "           AND (SC7.C7_QUANT - SC7.C7_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "           AND SC7.C7_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	//cQuery += "           AND SC7.C7_CONAPRO <> 'B' "+ CHR(13) + CHR(10)    //SEM Q O PC ESTEJA BLOQUEADO
	cQuery += "           AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' ) "+ CHR(13) + CHR(10)
	
	cQuery += " , SB1.B1_COD PRODUTO FROM "+RetSqlname("SB1")+" SB1 "+ CHR(13) + CHR(10) 
	cQuery += " WHERE SB1.B1_COD = '"+cProd+"' " + CHR(13) + CHR(10) 
	cQuery += " AND SB1.D_E_L_E_T_ = ''  " + CHR(13) + CHR(10)
	cQuery += "  GROUP BY SB1.B1_COD  "
	MemoWrite("C:\TEMP\QVERSCPC.SQL", cQuery )
	
Elseif Alltrim(cTipo) = "D" //ver data
	cQuery := "SELECT DTSC=( SELECT  TOP 1 SC1.C1_DATPRF  " + CHR(13) + CHR(10)
	cQuery += "               FROM " + RetSqlName("SC1") + " SC1 WHERE SC1.D_E_L_E_T_ = '' AND SC1.C1_PRODUTO = SB1.B1_COD "+ CHR(13) + CHR(10)
	cQuery += "               AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "               AND C1_PEDIDO = '' AND C1_ITEMPED = '' " + CHR(13) + CHR(10)         //SEM PEDIDOS GERADOS
	cQuery += "               AND SC1.C1_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	cQuery += "               AND SC1.C1_APROV <> 'R' "+ CHR(13) + CHR(10)    //SEM Q A SC ESTEJA REJEITADA
	cQuery += "               AND SC1.C1_FILIAL = '" + xFilial("SC1") + "'  " + CHR(13) + CHR(10)
	cQuery += "               ORDER BY SC1.C1_DATPRF DESC ) " + CHR(13) + CHR(10)
	
	cQuery += " , DTPC=( SELECT  TOP 1 SC7.C7_DATPRF  " + CHR(13) + CHR(10)
	cQuery += "           FROM " + RetSqlName("SC7") + " SC7 WHERE SC7.D_E_L_E_T_ = '' AND SC7.C7_PRODUTO = SB1.B1_COD " + CHR(13) + CHR(10)
	cQuery += "           AND (SC7.C7_QUANT - SC7.C7_QUJE) > 0 " + CHR(13) + CHR(10)
	cQuery += "           AND SC7.C7_RESIDUO <> 'S' " + CHR(13) + CHR(10)  //SEM RESÍDUOS
	//cQuery += "           AND SC7.C7_CONAPRO <> 'B' "+ CHR(13) + CHR(10)    //SEM Q O PC ESTEJA BLOQUEADO
	cQuery += "           AND SC7.C7_FILIAL = '" + xFilial("SC7") + "'  "+ CHR(13) + CHR(10)
	cQuery += "           ORDER BY SC7.C7_DATPRF DESC ) " + CHR(13) + CHR(10)
	
	cQuery += " , SB1.B1_COD PRODUTO FROM "+RetSqlname("SB1")+" SB1 " + CHR(13) + CHR(10)
	cQuery += " WHERE SB1.B1_COD = '"+cProd+"' "+ CHR(13) + CHR(10)
	cQuery += " AND SB1.D_E_L_E_T_ = ''  " 
	cQuery += "  GROUP BY SB1.B1_COD  "
	MemoWrite("C:\TEMP\DVERSCPC.SQL", cQuery )
Endif

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMP1"
If Alltrim(cTipo) = "D"
	TCSetField('TMP1',"DTSC","D")
	TCSetField('TMP1',"DTPC","D")
Endif

//lTem := !TMP1->(EOF())
If !TMP1->(EOF())
	If Alltrim(cTipo) = "Q"
		Aadd(aRetorno , { TMP1->QTASSC, TMP1->QTOSPC, TMP1->QTNASC, TMP1->QTNOPC } )  
					    //    QTAS SCs, QTOS PCs , Qtde Total em SC , Qtde Total em PC
	Elseif Alltrim(cTipo) = "D"
		dDATAS := TMP1->DTSC
		dDATAP := TMP1->DTPC                         
		Aadd(aRetorno , { dDATAS , dDATAP } )  
	Endif		
Endif

TMP1->(DbCloseArea())

//return lTem
Return(aRetorno)

//Verifica o Saldo de OP em aberto e
//de Bobinas 
******************************
static function TemOPBB(cProd)
******************************

local cQuery
local nPESBOB := nPESOP := 0

cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, ( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
cQuery += "WHERE SC2.C2_PRODUTO = '" + cProd + "' AND SC2.C2_DATRF = '        ' AND "
cQuery += "SB1.B1_CONV > 0 AND "
cQuery += "SC2.C2_PRODUTO = SB1.B1_COD AND "
cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SC2X"
	
While ! SC2X->( Eof() )
	nPESOP += SC2X->PESO
	SC2X->( DbSkip() )
End
SC2X->( DbCloseArea() )

return ( nPESOP + nPESBOB ) > 0



****************************************
Static Function Carteira( cProd, nTipo )
****************************************

//nTipo = 1: Carteira Programada
//nTipo = 2: Carteira Pronta para Faturar (Imediata)

Local aArret := {}

Default nTipo := 0

cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = '"+cProd+"' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "

// NOVA LIBERACAO DE CREDITO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
if nTipo = 1
  cCart += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif

cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cCart := ChangeQuery( cCart )
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")

Aadd( aArret, CARX->CARTEIRA_KG )
Aadd( aArret, CARX->CARTEIRA_RS )

CARX->( DbCloseArea() )

Return aArret

***************

static function TemOPLIC(cProd)

***************

local cQuery
local nPESOP := 0

cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, "
cQuery += "( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
cQuery += "WHERE SC2.C2_PRODUTO = '" + cProd + "' AND SC2.C2_DATRF = '        ' AND "
cQuery += "SC2.C2_PRODUTO = SB1.B1_COD AND SC2.C2_OPLIC = 'S' AND "
cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SC2X"
	
While ! SC2X->( Eof() )
	nPESOP += SC2X->PESO
	SC2X->( DbSkip() )
End
SC2X->( DbCloseArea() )

return nPESOP

******************************************************************
Static Function SendMailSC(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= "" //GetMV( "MV_RELACNT" )
cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//alert("E-mail não enviado...")
		
		conout("E-mail nao enviado")
		
		//conout(Replicate("*",60))
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


