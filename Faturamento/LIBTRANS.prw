#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

static cRtTransp

*************
User Function LIBTRANS(cLocali,cTransp)
*************
//Private lRet:=.F. 
Local cLocaliz := ""

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oBtn1")
	
cLocaliz := cLocali 
//msgbox("clocaliz : " + cLocaliz)
if alltrim(upper(FunName())) == "ESTC005"
   return .T.
Endif

	//posiciona na tab. de LOCALIDADExTRANSportadora
DbSelectArea("SZZ")
DbSetOrder(2) 

// COLOQUEI PQ TAVA DANDO PROBLEMA COM O ALIAS 
If Select("TMP") > 0  
  DbSelectArea("TMP")
  TMP->(DbCloseArea())
EndIf


if SZZ->(DbSeek(xFilial("SZZ")+cLocaliz))     
	//local cLocal:=M->C5_LOCALIZ
	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 148,385,347,853,"Transportadora",,,.F.,,,,,,.T.,,,.F. )
	oTbl1()
	DbSelectArea("TMP")
	oBrw1      := MsSelect():New( "TMP","","",{{"TRANSP","","Codigo",""},;
	{"NOME","","Nome",""}},.F.,,{004,003,064,227},,, oDlg1 )
	oBtn1      := TButton():New( 072,190,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {||conftrans()}
	
	TMP->( __DbZap() ) 	// LIMPAR O CONTEUDO DA TABELA TEMPORARIA
	
	DbSelectArea("SA4" )
	DbSetOrder(1)
	
	while SZZ->(!EOF()) .AND. SZZ->ZZ_LOCAL = cLocaliz
		If SA4->(DbSeek(xFilial("SA4")+SZZ->ZZ_TRANSP,.F.))
			If A4_ATIVO!='N'
				If SZZ->ZZ_ATIVO != 'N'
					RecLock("TMP",.T.)
					TMP->TRANSP	:= SZZ->ZZ_TRANSP
					TMP->NOME	:= SA4->A4_NOME //POSICIONE("SA4", 1, xFilial("SA4") +SZZ->ZZ_TRANSP , "A4_NOME" )
					TMP->(MsUnLock())
				EndIf
			EndIf
		Endif
		SZZ->(dbskip())
		
	EndDo
	
	IF !EMPTY(cLocaliz)
		RecLock("TMP",.T.)
		TMP->TRANSP:='024' // O Mesmo
		TMP->NOME:=POSICIONE("SA4", 1, xFilial("SA4") +'024' , "A4_NOME" )
		TMP->(MsUnLock())
	ENDIF
	
	TMP->( DbGotop() )
	
	oBrw1:oBrowse:Refresh()
	
	oDlg1:Activate(,,,.T.)
	
	TMP->(DBCloseArea())
	Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO
	

Else
		
	alert('Localidade não Encontrada ou Escolha outra Localidade para a transportadora!!!!')
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 148,385,347,853,"Transportadora",,,.F.,,,,,,.T.,,,.F. )
	oTbl1()
	DbSelectArea("TMP")
	oBrw1      := MsSelect():New( "TMP","","",{{"TRANSP","","Codigo",""},;
	{"NOME","","Nome",""}},.F.,,{004,003,064,227},,, oDlg1 )
	oBtn1      := TButton():New( 072,190,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {||conftrans()}
	
	TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
	  	
  	IF !EMPTY(cLocaliz)
		RecLock("TMP",.T.)
		TMP->TRANSP:='024' // O Mesmo
		TMP->NOME:=POSICIONE("SA4", 1, xFilial("SA4") +'024' , "A4_NOME" )
		TMP->(MsUnLock())
	ENDIF
	
	TMP->( DbGotop() )
	
	oBrw1:oBrowse:Refresh()
	
	oDlg1:Activate(,,,.T.)
	
	TMP->(DBCloseArea())
	Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO
  // lRet:=.T.
EndIF

Return  .T. //lRet


***************

Static Function conftrans()

***************

//Local lVerdbt := .T.

//lVerdbt := U_VerDBtrans( TMP->TRANSP )
//24/03 -  Flávia Rocha : Por solicitação de Eurivan, comentei esta passagem
/*
If !lVerdbt
	MsgAlert(" A transportadora escolhida possui débitos por atrasos, portanto não poderá ser associada a este pedido. ")
	Return lVerdbt
Else
*/
    if alltrim(upper(FunName())) == "FATC019"
	   M->ZC5_TRANSP:=TMP->TRANSP            
    elseif alltrim(upper(FunName())) == "PREVEN"
	   M->Z5_TRANSP:=TMP->TRANSP            
    else
	   M->C5_TRANSP:=TMP->TRANSP            
    Endif
   
	
	cRtTransp:=TMP->TRANSP 
	//lRet:=.T.
	dbselectarea('SC5') 
	oDlg1:End()
//Endif


Return 

*************

user function RtTransp()

*************			

return cRtTransp 


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"TRANSP"  ,"C",006,000} )
Aadd( aFds , {"NOME"    ,"C",040,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 



*************

User Function ATITRANS(cLocaliz,cTransp)

*************

Local lVerDbt := .T.


If !empty(cLocaliz) .and. !empty(cTransp)
   DbSelectArea("SZZ")
   DbSetOrder(1) 
   If SZZ->( dbSeek( xFilial("SZZ") + cTransp + cLocaliz ) )
      
      If SZZ->ZZ_ATIVO = 'S'
        
        //posiciona na tab. de TRANSPORTADORA
        DbSelectArea("SA4")
        DbSetOrder(1) 
        If DbSeek(xFilial("SA4")+SZZ->ZZ_TRANSP)

           If SA4->A4_ATIVO = 'S'
              //Comentei Eurivan - 19/03/10
              /*
              lVerdbt := U_VerDBtrans( M->C5_TRANSP )
				If !lVerdbt
					msgAlert("A transportadora escolhida possui débitos por atrasos, portanto não poderá ser associada a este pedido. ")
					Return lVerdbt
				Else
					Return .T.
				Endif
              */
              Return .T.
           Else
              alert("A Transportadora "+alltrim(SA4->A4_NOME)+" não esta ATIVA!!")
              Return .F.
           EndIf
        
        EndIF
      Else
         alert("A Transportadora não esta ATIVA para esta Localidade: "+SZZ->ZZ_DESC )
         Return .F.
      EndIf                    
   Else
         If alltrim(cTransp) $ "024"
		    return .T.
	     Else
	     	alert("A Transportadora não esta ATIVA para esta Localidade: "+SZZ->ZZ_DESC )
	     	Return .F.
	     endIf
	     
        // U_FZ40()  // FUNCAO QUE LEVA O PEDIDO PARA TABELA DE LIBERACAO DE PEDIDO 
   EndIf
EndIf

Return .T.             

/*
***********************************
User Function VerDbtrans( cTransp )
***********************************

local cQuery := "" 
Local lRet	 := .T.
Local cCodCliE := ""

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp ))
cCodCliE := SA4->A4_CODCLIE

cQuery := "select E1_VALOR,E1_NOMCLI,E1_CLIENTE,E1_LOJA,E1_SALDO,E1_BAIXA from " + retSqlName('SE1') + " SE1 "
cQuery += " where RTRIM(E1_CLIENTE) = '" + Alltrim(cCodCliE) + "' "
cQuery += " and E1_FILIAL = '"+xFilial('SE1')+"' "
cQuery += " and E1_PREFIXO IN( 'UNI','0' ) and E1_TIPO = 'NF' and E1_NATUREZ = '21005' "
cQuery += " and E1_CODORCA = 'POSVENDA' and D_E_L_E_T_ <> '*' "
cQuery += " AND E1_SALDO > 0 AND E1_BAIXA = '' "
//MemoWrite("\Temp\VerDBTrans.SQL" , cQuery )
  
  If Select("TMPYP") > 0
	DbSelectArea("TMPYP")
	DbCloseArea()	
  EndIf 
  
  TCQUERY cQuery NEW ALIAS 'TMPYP'
  TMPYP->( dbGoTop() )  

  if !TMPYP->( EoF() )
     TMPYP->( dbCloseArea() )
     lRet := .F.
     Return lRet
  endIf
  TMPYP->( dbCloseArea() )  

Return lRet
*/                      

*************

User Function  VLDTRANSP(cLocaliz,cTransp) 

*************             

If alltrim(cTransp) $ "024"   
   return .T.
endIf

DbSelectArea("SA4" )
DbSetOrder(1)
If SA4->(DbSeek(xFilial("SA4")+cTransp,.F.))
   If A4_ATIVO='N'
      ALERT('Transportadora nao esta Ativa!!!' )
      return .F.            
   ENDIF
ENDIF


//If !empty(M->C5_LOCALIZ) .and. !empty(M->C5_TRANSP)
   DbSelectArea("SZZ")
   DbSetOrder(1) 
   If ! SZZ->( dbSeek( xFilial("SZZ") + cTransp + cLocaliz,.F.) )
       //alert('A transportadora '+ALLTRIM(POSICIONE("SA4", 1, xFilial("SA4") +cTransp , "A4_NOME" ) )+' nao entrega nessa localidade '+ALLTRIM(POSICIONE("SX5", 1, xFilial("SX5") +'ZZ'+cLocaliz , "X5_DESCRI" ) ) )
       alert('A transportadora '+ALLTRIM(POSICIONE("SA4", 1, xFilial("SA4") +cTransp , "A4_NOME" ) )+' nao entrega nessa localidade '+ALLTRIM(POSICIONE("CC2", 3, xFilial("CC2") +cLocaliz , "CC2_MUN" ) ) )
       return .F.
   Else
       If SZZ->ZZ_ATIVO='N'  // inativa
          ALERT('Transportadora X Localidade nao esta Ativa!!!' )
          return .F.
       Endif
   endif
//endif   
   

Return .T. 