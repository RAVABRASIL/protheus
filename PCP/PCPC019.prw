#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

User Function PCPC019()

Private CodBarras := SPACE(12)
Private cObserva   := SPACE(20)
PRIVATE Option    := ""

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oCBox1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oSay3","oMGet1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 143,280,498,626,"oDlg1",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 004,004,172,168,"Estornar Movimentação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 022,012,{||"Motivo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oCBox1     := TComboBox():New( 020,040,,{"Produto Trocado","Etiqueta Errada","Devolucao Qualidade"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,"option" )
oCBox1:bSetGet := {|u| If(PCount()>0,option:=u,option)}
oCBox1:nAt := 1

oSay2      := TSay():New( 044,012,{||"Cod Bar"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)

oGet1         := TGet():New( 044,040,,oGrp1,073,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","CodBarras",,)
oGet1:bSetGet := {|u| If(PCount()>0,Codbarras:=u,Codbarras)}

oBtn1         := TButton():New( 156,088,"OK",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||U_Estornar(Codbarras),oGrp1:End()}

oBtn2         := TButton():New( 156,128,"Sair",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || oDlg1:end() }

oSay3      := TSay():New( 068,012,{||"Observa:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oMGet1     := TMultiGet():New( 068,040,,oGrp1,120,072,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cObserva:=u,cObserva)}

oDlg1:Activate(,,,.T.)

Return

User function Estornar(Codibar)
  
Local lMsErroAuto := .T.
local cQueryx :=''
LOCAL nCnt := 0

cQueryx := "SELECT D3_COD CODIGO, D3_UM UNIDADE, D3_QUANT QUANT, D3_LOCAL ARMAZEM,D3_EMISSAO FROM SD3020 WHERE D3_CODBAR = '" + Codibar + "' AND D_E_L_E_T_ = ''"

IF oCBox1:nAt == 1

	/*COMEÇO DA ROTINA DE ESTORNO, QUE IRÁ OCORRER CASO O MOTIVO FOR:*/
    /*PRODUTO TROCADO*/
	Alert("Será Necessário Digitar a senha do Gerente de Estoque")

	If ! U_Senha2("25",1)[1] 
	     Return 
	endif

	Alert("Será Necessário Digitar a senha do Gerente de Producao")

	If ! U_Senha2("26",1)[1] 
	     Return 
	endif

	TCQUERY cQueryx NEW ALIAS "TMPX"
	TMPX->(DbGoTop())

	DO WHILE lMsErroAuto
		    
		lMsErroAuto := .F.
			aMATRIZ := { { "D3_TM", "503", ""},;
		                 { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
		                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
		                 { "D3_LOCAL", ARMAZEM, NIL },;
		                 { "D3_COD", CODIGO, NIL},;
		                 { "D3_UM", UNIDADE, NIL },;
		                 { "D3_QUANT", QUANT, NIL },;
		                 { "D3_CBESTOR", Codibar, NIL },;
		                 { "D3_OBS", cObserva, NIL },;
		                 { "D3_EMISSAO", dDatabase, NIL} } 
		                 		                	    
		    Begin Transaction
		    	MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )        
		    	IF lMsErroAuto
					DisarmTransaction()
				Endif
			End Transaction
		    
		    IF lMsErroAuto
		       MostraErro()
	        ENDIF                        
	ENDDO 

	TMPX->(DbCloseArea())

      dbSelectArea("Z00")
  	  dbSetOrder(7)	
   	  If Z00->(DbSeek(xFilial("Z00")+ Codibar))
		RECLOCK( "Z00", .F.)
			DBDelete()	
		Z00->(MsUnlock())
		
      Endif
	Alert("Pesagem e Movimentação do Produto Trocado no Fardo Estornado")
Else

	/*COMEÇO DA ROTINA DE ESTORNO, QUE IRÁ OCORRER CASO O MOTIVO FOR:*/
    /*ETIQUETA ERRADA*/
	Alert("Será Necessário Digitar a senha do Gerente de Estoque")

	If ! U_Senha2("25",1)[1] 
	     Return 
	endif

	Alert("Será Necessário Digitar a senha do Gerente de Producao")

	If ! U_Senha2("26",1)[1] 
	     Return 
	endif

	TCQUERY cQueryx NEW ALIAS "TMPX"
	TMPX->(DbGoTop())

	DO WHILE lMsErroAuto
		    
		lMsErroAuto := .F.
			aMATRIZ := { { "D3_TM", "503", ""},;
		                 { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
		                 { "D3_FILIAL", xFilial( "SD3" ), NIL},;
		                 { "D3_LOCAL", ARMAZEM, NIL },;
		                 { "D3_COD", CODIGO, NIL},;
		                 { "D3_UM", UNIDADE, NIL },;
		                 { "D3_QUANT", QUANT, NIL },;
		                 { "D3_CBESTOR", Codibar, NIL },; 
		                 { "D3_OBS", cObserva, NIL },;
		                 { "D3_EMISSAO", dDatabase, NIL} } 
		                	    
		    Begin Transaction
		    	MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )        
		    	IF lMsErroAuto
					DisarmTransaction()
				Endif
			End Transaction
		    
		    IF lMsErroAuto
		       MostraErro()
	        ENDIF                        
	ENDDO 

	TMPX->(DbCloseArea())

	dbSelectArea("Z00")
    dbSetOrder(7)	
    If Z00->(DbSeek(xFilial("Z00")+ Codibar))
		RECLOCK( "Z00", .F.)
			DBDelete()	
		Z00->(MsUnlock())
    	
    Endif	
	Alert("Pesagem e Movimentação da Etiqueta Errada Estornado")
endif

Return