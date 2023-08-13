#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :17/01/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTC010()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//Private cMAQ       := Space(06)
//Private cOP        := Space(11)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oSay2","oSay3","oGet2","oBtn1","oSBtn1",'lCxPesa')
SetPrvt( "oBtnLer, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nHandle, cNOMEO, oNOMEO, oTIPO, cTIPO, aTIPO, oOPERAD, cOPERAD, aOPERAD, aCODOPE, cNMEXT, " )

cOP	  := Space( 11 )
cMAQ  := Space( 06 )
cCodApa := " "
cTipoPrd:=" "

lCxPesa:=.F.

DbSelectArea("SC2")
DbSelectArea("SB1")
DbSelectArea("SB5")
DbSelectArea("SH1")
//DbSelectArea("SRA")

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
//SRA->( DbSetOrder( 1 ) )

nHANDLE   := -1
cPORTABAL := "4"
cPORTAIMP := "3"


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 127,254,263,782,"Apara PI-Coletor",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,003,038,259,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 009,010,{||"OP :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,026,007)
//oGet1      := TGet():New( 008,037,,oGrp1,042,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","cOP",,)
oGet1      := TGet():New( 008,037,{|u| If(PCount()>0,cOP:=u,cOP)},oGrp1,057,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","cOP",,)
oGet1:bValid := {||PesqOP(cOP) }
//oGet1:bSetGet := {|u| If(PCount()>0,cOP:=u,cOP)}


//oSay2      := TSay():New( 008,065,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)
oSay2      := TSay():New( 008,097,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,154,008)
oSay3      := TSay():New( 024,010,{||"Maquina :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,007)
//oGet2      := TGet():New( 022,037,,oGrp1,041,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SH1","cMAQ",,)
oGet2      := TGet():New( 022,037,,oGrp1,057,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SH1CX","cMAQ",,)
oGet2:bValid := {||PesqMaq(cMAQ) }
oGet2:bSetGet := {|u| If(PCount()>0,cMAQ:=u,cMAQ)}


oBtn1      := TButton():New( 046,037,"&Pesar",oDlg1,,027,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||Pegar() }

oSBtn1     := SButton():New( 046,086,2,,oDlg1,,"", )
oSBtn1:bAction := {||oDlg1:END()}

oDlg1:Activate(,,,.T.)

Return 


***************

Static Function PesqOp(cOP)

***************
Local lPedido := .F.
cPrdt   := ""
lRET := .T.

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"  
     ObjectMethod( oGet1, "Refresh()" )
EndIf

SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )

If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
    MsgAlert( OemToAnsi( "OP nao cadastrada!" ) )
    lRET := .F.

Else
	 If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	        
	        cTipoPrd:=alltrim(SB1->B1_TIPO)
	        
	        //If  PRIMEIROCX(Left( cOP, 6 )) 
	            If alltrim(SB1->B1_TIPO)="PI"   
			       IF ALLTRIM (SC2->C2_SEQPAI)!='002' 
		              If !ALLTRIM(SC2->C2_PRODUTO) $ PI_LA01() 
		                 lCxPesa:= .T.
		              Else
		                 If alltrim(SC2->C2_SEQUEN)='001'
		                    lCxPesa:= .T.
		                 else
		                    alert("PI da laminadora nao Pesa agora!!!")
		                    lCxPesa:= .F.
		                    lRET := .F.
		                 Endif
		              Endif
		           Else
		              lCxPesa:= .T.
		              lRET := .T.
		           /*
		              alert("Esse PI nao faz parte do processo do coletor!!!")
		              lCxPesa:= .F.
		              lRET := .F.
		           */
		           EndIf
		        Else
		           If alltrim(SB1->B1_TIPO)="PA"
		              cCodApa:=CodPa()
		              lCxPesa:= .T.
		           ELSE   		              
		              alert("Nao e permitido pesar Esse Produto aqui!!!")
		              lCxPesa:= .F.
		              lRET := .F.
		              
		           ENDIF
		        EndIf		        		
			//Else
		      //  lRET := .F.
			//EndIf
						
			If ! SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
				 MsgAlert( OemToAnsi( "Complemento do produto nao cadastrado" ) )
				 lRET := .F.
			EndIf
					
	 Else
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
			lRET := .F.
	 EndIf
 	 If lRET .and. ! Empty( SC2->C2_DATRF )
			MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
 			lRET := .F.
	 EndIf
EndIf

If lRET
	 
	 If ! Empty( SC2->C2_RECURSO ) 
			cMAQ :=  (SC2->C2_RECURSO)
	 EndIf
     
   IF alltrim(SB1->B1_TIPO)="PI"  
     If !empty(SB5->B5_CODAPAR)
        oSay2:cCaption:=ALLTRIM(SB5->B5_CODAPAR)+' - '+ Posicione('SB1',1,xFilial("SB1")+SB5->B5_CODAPAR,"B1_DESC" )      
     else
        alert('O Codigo da Apara esta em Branco no complemento do Produto '+ ALLTRIM(SB1->B1_COD))
        lCxPesa:= .F.
		lRET := .F.
     endif
   ENDIF

EndIf


Return lRET

***************

Static Function PesqMaq(cMAQ)

***************
local cPrdPi:=" "
local cMaqXPi:=" "
lRET := .T.
If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
Else

   if !empty(cMaq)
	   If ! MAqOk(cMAQ)
	      MsgAlert( OemToAnsi( "Maquina nao pertence ao processo de pesagem de PI do coletor!!!" ) )
		  lRET := .F.
	   Else
	      
	      cPrdPi:=PrdPi()
          cMaqXPi:=MaqXPi(cMaq)
       
	      if ! alltrim(cPrdPi) $ cMaqXPi
	         MsgAlert( OemToAnsi( "Essa Maquina "+alltrim(cMAQ)+" nao pesa esse produto "+alltrim(cPrdPi) ) )
		     lRET := .F.   
	      endif
	            
       Endif
   Endif

EndIf


/*
If lRET
	 If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
		  lRET := U_senha3( "02", 1 )[ 1 ]
	 EndIf
EndIf
*/

Return lRET  




***************

Static Function MAqOK(cMaq)

***************
local cQry:=''
local lRet:=.F.

cQry:="SELECT X5_CHAVE,* FROM " + RetSqlName( "SX5" ) + " SX5 " 
cQry+="WHERE X5_TABELA='ZE' "
cQry+="AND X5_CHAVE='"+cMaq+"' "
cQry+="AND X5_FILIAL='"+XFILIAL("SX5")+"' "
cQry+="AND D_E_L_E_T_!='*' "
If Select("TMPB") > 0
  DbSelectArea("TMPB")
  TMPB->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPB"

If ! TMPB->( Eof() )  
   lRet:=.T.
Endif

TMPB->(dbclosearea())


Return lRet 


***************

Static Function PrdPi()

***************
local cQry:=''
local cRet:=" "

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"  
EndIf


cQry:="SELECT C2_PRODUTO,* FROM " + RetSqlName( "SC2" ) + " SC2 " 
cQry+="WHERE "
cQry+="C2_NUM+C2_ITEM+C2_SEQUEN='"+cOP+"' "
cQry+="AND C2_FILIAL='"+xfilial("SC2")+"' "
cQry+="AND SC2.D_E_L_E_T_!='*' "
If Select("TMPC") > 0
  DbSelectArea("TMPC")
  TMPC->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPC"

If ! TMPC->( Eof() )  
   cRet:=TMPC->C2_PRODUTO
Endif

TMPC->(dbclosearea())



Return cRet


***************

Static Function MAqXPi(cMaq)

***************
local cQry:=''
local cRet:=" "

cQry:="SELECT X5_DESCRI+X5_DESCSPA+X5_DESCENG CONTEUDO,* FROM " + RetSqlName( "SX5" ) + " SX5 " 
cQry+="WHERE X5_TABELA='ZE' "
cQry+="AND X5_CHAVE='"+cMaq+"' "
cQry+="AND X5_FILIAL='"+XFILIAL("SX5")+"' "
cQry+="AND D_E_L_E_T_!='*' "
If Select("TMPD") > 0
  DbSelectArea("TMPD")
  TMPD->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPD"

If ! TMPD->( Eof() )  
   cRet:=TMPD->CONTEUDO
Endif

TMPD->(dbclosearea())


Return cRet 


***************

Static Function PRIMEIROCX(cNumOp)

***************
local cQry:=''

cQry:="SELECT B1_SETOR,*  "
cQry+="FROM " + RetSqlName( "SC2" ) + " SC2 , " + RetSqlName( "SB1" ) + " SB1 "
cQry+="WHERE "
cQry+="C2_PRODUTO=B1_COD "
cQry+="AND C2_NUM='"+cNumOp+"'  "
cQry+="AND C2_FILIAL='"+XFILIAL("SC2")+"' "
cQry+="AND B1_FILIAL='"+XFILIAL("SB1")+"' "
cQry+="AND C2_SEQUEN='001' " // PRODUTO ACABADO 
cQry+="AND SC2.D_E_L_E_T_!='*' "
cQry+="AND SB1.D_E_L_E_T_!='*'  "

If Select("TMPA") > 0
  DbSelectArea("TMPA")
  TMPA->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPA"

//If ! TMPA->( Eof() )  
   IF ALLTRIM(TMPA->B1_SETOR)='39' // COLETOR
      TMPA->(DbCloseArea())
      return .T.
   ELSE
      Alert("O Produto Acabado( "+alltrim(TMPA->C2_PRODUTO)+" ) dessa OP "+alltrim(cNumOp)+" Nao e um Coletor!!!" )
      TMPA->(DbCloseArea())
      return .F.
   ENDIF
//EndIf


Return .F.

***************
Static Function Pegar()
***************

LOCAL nPESOT :=nTara:=0

nTara := taraTub()
Do Case
	Case nTara == 2    // gaiola 1
		nTara	:= 30.8
	Case nTara == 3// gaiola 2
		nTara	:= 30.9
	Case nTara == 4// gaiola 3
		nTara	:= 33.9
	Case nTara == 5// gaiola 4
		nTara	:= 31.6
	Case nTara == 6// gaiola 5
		nTara	:= 34.8
	Case nTara == 7// gaiola 6
		nTara	:= 30.8
	otherwise
	    msgAlert("Escolha a tara da Gaiola! ! !")
	    return Pegar()
endCase	

cDLL    := "toledo9091.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf

//Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
nPESO   := Val( Strtran( cPESO, ",", "." ) ) - nTara
nPESOT := Val( Strtran( cPESO, ",", "." ) )  
ExecInDLLClose( nHandle )

/*
nPESOT := 100
nPESO:=100 - nTara 
*/

IF nPESOT <=nTara
   alert('O peso esta abixo da tara da Gaiola')
   Return NIL
Endif



if( lCxPesa, grava(), Alert("Nao e Permitido Pesar Esse Produto Aqui!!!") )


Return NIL


***************
Static Function Grava()
***************

Private aArret := {}     

nQUANT:=1
aIMP := {}
If nPESO <= 0
	 MsgAlert( "Erro na leitura do peso" )
	 Return NIL
EndIf



If  Empty( cOP ) .or.  Empty( cMAQ ) 
	 MsgAlert( "Dados obrigatorios nao informados" )
	 Return NIL
EndIf


aArret := U_senha3( "05", 1, "Validação de usuário pesador de apara de corte." )
if !aArret[1]
	msgAlert("Você não tem autorização para pesar aparas !")
	Return NIL
endIf

  
For nCONT := 1 To nQUANT
    cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
    RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := cSEQ
	Z00->Z00_OP     := cOP
	Z00->Z00_PESO   := nPESO
	Z00->Z00_BAIXA  := "S"
	Z00->Z00_MAQ    := cMAQ
	Z00->Z00_DATA   := Date()
	Z00->Z00_HORA   := Left( Time(), 5 )
	Z00->Z00_APARA  := 'X' // SO PARA MARCAR PARA O SISTEMA SABER QUE E APARA 
    Z00->Z00_NOME   :=  aArret[2] 
    // sem motivo por enquanto 
    Z00->Z00_MAPAR  := "PICX"	
    Z00->( MsUnlock() )
	ConfirmSX8()
	Z00->( DbCommit() )

/*	
	If SC2->C2_RECURSO <> cMAQ
	   RecLock( "SC2", .F. )
	   SC2->C2_RECURSO := cMAQ
	   SC2->( MsUnlock() )
	   SC2->( DbCommit() )
	EndIf
*/	
            // CODIGO DE BARRAS (substr(cOP,1,6) + cSEQ)
//    Aparas( substr(cOP,1,6) + cSEQ )
    Aparas( cOP)
        
    Msgbox( "APARA inserida com sucesso! ", "Mensagem", "info" )    
    
    	
Next

nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
cOPERAD   := Space( 06 )
oSay2:cCaption:=Space( 15	 )
//cNOMEO    := Space( 30 )
//cTIPO     := " "
ObjectMethod( oGet1, "SetFocus()" )
Return NIL


***************
Static Function Aparas( cCODX )
***************

local cProd
Local nUSADO := 0

Private aPERDA   := {}
		aHDPERDA := {}

PRIVATE cCusMed := GetMv( "MV_CUSMED" )

Pergunte( "MTA685", .F. )
PRIVATE lParam  := IIf( mv_par01 == 1, .T. , .F. )

If cCusMed == "O"
	PRIVATE nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst  			// Numero do lote para lancamentos do estoque
	dbSelectArea( "SX5" )
	dbSeek( xFilial() + "09EST" )
	cLoteEst := IIF( Found(), Trim( X5Descri() ), "EST " )
	PRIVATE nTotal := 0			// Total dos lancamentos contabeis
	PRIVATE cArquivo			// Nome do arquivo contra prova
EndIf

SX3->( dbSetOrder( 1 ) )
SX3->( dbSeek( "SBC" ) )
While ! SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SBC"
   IF SX3->( X3USO( SX3->X3_USADO ) ) .And. cNivel >= SX3->X3_NIVEL .And. !(AllTrim(SX3->x3_campo)$"BC_OP") .And. ;
	 	 !(AllTrim(SX3->x3_campo)$"BC_OPERAC") .And. !(AllTrim(SX3->x3_campo)$"BC_RECURSO/BC_QTSEGUM/BC_QTDES2/BC_QTDDES2")  .And. ;
		 !(AllTrim(SX3->x3_campo)$"BC_NUMSEQ") .And. !(AllTrim(SX3->x3_campo) == "BC_SEQSD3")
  	  nUsado++
	    AADD( aHDPERDA,{ Trim( SX3->( X3Titulo() ) ), ;
		  							SX3->X3_CAMPO,;
			  						SX3->X3_PICTURE, ;
				  					SX3->X3_TAMANHO, ;
					  				SX3->X3_DECIMAL, ;
						  			"AllwaysTrue()" , ;
							  		SX3->X3_USADO,;
								    SX3->X3_TIPO, ;
								    SX3->X3_ARQUIVO,;
								    SX3->X3_CONTEXT } )
   EndIF
   SX3->( DbSkip() )
Enddo

cPROD := IIF(alltrim(cTipoPrd)="PI",ALLTRIM(SB5->B5_CODAPAR),ALLTRIM(cCodApa))


aPERDA := { { SC2->C2_PRODUTO, ;
	        "01", ;
		    "S", ;
		    "IP", ;
			"INERENTE AO PROCESSO", ;
		    Z00->Z00_PESO, ;
		    cProd, ;
		    "01", ;
		    Z00->Z00_PESO, ;
		    Date(), ;
		    Z00->Z00_OPERAD, ;
			Space( 10 ), ;
			Space( 06 ), ;
			Ctod( "  /  /  " ), ;
			Space( 15 ), ;
			Space( 20 ), ;
			Space( 15 ), ;
			Space( 20 ), ;
  	        .F. } }

GravaSBC( Left( cCODX, 11 ), "", Z00->Z00_MAQ, "MATA685" )


Return 


***************

Static Function taraTub()

***************

local oDlg1,oCBox1,oGrp1,oSBtn1,oSBtn2
local nAt := 0
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 139,330,352,682,"Tara da Gaiola ",,,,,,,,,.T.,,, )
//oCBox1     := TComboBox():New( 028,049,,{"","Gaiola 1 - 28,3 Kg","Gaiola 2 - 28,3 Kg","Gaiola 3 - 31,2 Kg","Gaiola 4 - 28,9 Kg","Gaiola 5 - 32,3 Kg","Gaiola 6 - 28,0 Kg"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1     := TComboBox():New( 028,049,,{"","Gaiola 1 - 30,8 Kg","Gaiola 2 - 30,9 Kg","Gaiola 3 - 33,9 Kg","Gaiola 4 - 31,6 Kg","Gaiola 5 - 34,8 Kg","Gaiola 6 - 30,8 Kg"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oGrp1      := TGroup():New( 004,004,092,168,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBtn1     := SButton():New( 064,040,1,{ || nAt := oCBox1:nAt, oDlg1:End() },oGrp1,,"", )
oSBtn2     := SButton():New( 064,108,2,{ || nAt := 0         , oDlg1:End() },oGrp1,,"", )

oDlg1:Activate(,,,.T.)

Return nAt


*************

STATIC Function CodPa()

*************
local cCod:=CodApa(substr(SC2->C2_PRODUTO,2,1))
private cCodApa:=SPACE(3)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlgX","oSay10","oGet10","oSBtn10","oSayC","oSay30")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgX      := MSDialog():New( 215,525,305,757,"Codigo da Apara para o Coletor",,,.F.,,,,,,.T.,,,.F. )
oSay10      := TSay():New( 004,004,{||"Digite o codigo :"},oDlgX,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGet10      := TGet():New( 003,044,{|u| If(PCount()>0,cCodApa:=u,cCodApa)},oDlgX,019,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodApa",,)
oGet10:bValid := {|| PesqCod(cCodApa,cCod) } 

oSBtn10     := SButton():New( 003,084,1,{||oSay2:cCaption:=ALLTRIM(cCodApa)+' - '+ Posicione('SB1',1,xFilial("SB1")+cCodApa,"B1_DESC" ),oDlgX:end()},oDlgX,,"", )
oSayC      := TSay():New( 018,004,{||"Codigo para o Coletor:"},oDlgX,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
oSay30      := TSay():New( 031,004,{||"oSay3"},oDlgX,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,106,008)

oSay30:cCaption:=ALLTRIM(cCod)

oDlgX:Activate(,,,.T.)

Return cCodApa

***************

STATIC FUNCTION CodApa(Clitro)

***************
LOCAL Cret:=''
LOCAL cQry:=''
cQry:="SELECT LTRIM(RTRIM(X5_DESCRI))+CASE WHEN LEN(X5_DESCSPA)>1 THEN LTRIM(RTRIM(X5_DESCSPA))ELSE '' END +CASE WHEN LEN(X5_DESCENG)>1 THEN LTRIM(RTRIM(X5_DESCENG)) ELSE '' END CONTEUDO FROM SX5020 SX5 "
cQry+="WHERE X5_TABELA='ZF' "
cQry+="AND X5_CHAVE='"+Clitro+"' "
cQry+="AND SX5.D_E_L_E_T_!='*' "
If Select("TMPF") > 0
  DbSelectArea("TMPF")
  TMPF->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPF"

IF TMPF->(!EOF())
   Cret:=TMPF->CONTEUDO 
ENDIF

Return Cret

***************

Static Function PesqCod(cCodApa,cCod)

***************

if EMPTY(cCodApa) 
   alert('O codigo nao pode ser vazio!!!')
   return .F.
Endif

if LEN(alltrim(cCodApa))<3 
   alert('Esse codigo nao e Valido!!!')
   return .F.
Endif


if ALLTRIM(cCodApa)='/' 
   alert('Esse codigo nao e Valido!!!')
   return .F.
Endif


if ! alltrim(cCodApa) $ ALLTRIM(cCod) 
   alert('Esse codigo nao e Valido!!!')
   return .F.
Endif

Return .T.

***************

Static Function PI_LA01()

***************

local cQry:=''
local cRet:=''

cQry:="SELECT LTRIM(RTRIM(X5_DESCRI))+CASE WHEN LEN(X5_DESCSPA)>1 THEN LTRIM(RTRIM(X5_DESCSPA))ELSE '' END +CASE WHEN LEN(X5_DESCENG)>1 THEN LTRIM(RTRIM(X5_DESCENG)) ELSE '' END CONTEUDO  "
cQry+="FROM SX5020 SX5 "
cQry+="WHERE X5_TABELA='ZE' "
cQry+="AND X5_CHAVE IN ('LA01') " // LAMINADORA 
cQry+="AND SX5.D_E_L_E_T_!='*' "

If Select("TMPL") > 0
  DbSelectArea("TMPL")
  TMPL->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPL"

If ! TMPL->( Eof() )  
   cRet:=CONTEUDO
EndIf

Return cRet

