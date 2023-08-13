#Include "Rwmake.ch"
#Include "Protheus.ch"

//**********************************************************************************************
// Programa : TMKLINOK.PRW
// Descricao: Esse ponto de entrada é executado após a função de validação
//            da linha da GetDados de Telemarketing. 
//            Tem o objetivo de validar o item da linha atual, caso não exista um responsável,
//            (UD_OPERADO = vazio ) definido, irá sinalizar ao usuário para que seja preenchido.
// Autoria  : Flávia Rocha - 24/11/09
//*****************************************************************************************

User Function TMKLINOK() 

Local aArea 		:= GetArea()
Local lRet 			:= .T.                                                                   
//Local _nPosAtend 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_CODIGO") })
Local _nPosProduto 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_PRODUTO") })
Local _nPosResp 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_OPERADO") })
Local _nPosN1   	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_N1") })
Local _nPosN2   	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_N2") })
Local _nPosN3   	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_N3") })
Local _nPosN4   	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_N4") })
Local _nPosN5   	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_N5") })
Local _nPosFlag		:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_FLAGAT") })
Local _nPosudata	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_DATA") })
Local _nPosresol	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_RESOLVI") })
Local _nPosDtResp	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_DTRESP") })
//Local _nPosAssun	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_ASSUNTO") })
Local _nPosMailCC	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UD_MAILCC") })

Local _nPosDel		:= Len(aHeader)+1
Local _n			:= 1                        

//No fonte original, este campo não pode estar vazio: UD_ASSUNTO
//Local nPAssunto  := aPosicoes[1][2]	//Posicao do campo UD_ASSUNTO no ACOLS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a linha nao esta apagada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If !aCols[n][Len(aHeader)+1]
//	If Empty(aCols[n][nPAssunto])



//Local cCodAtend := aCols[n,_nPosAtend]
Local cProduto  := aCols[n,_nPosProduto]
Local cResp     := aCols[n,_nPosResp]
Local cN1		:= aCols[n,_nPosN1]
Local cN2		:= aCols[n,_nPosN2]
Local cN3		:= aCols[n,_nPosN3]
Local cN4   	:= aCols[n,_nPosN4]
Local cN5		:= aCols[n,_nPosN5] 
Local cFlag		:= aCols[n,_nPosFlag] //este flag indica se o item está sendo incluído neste momento (EM BRANCO), ou se já existia ("S")
//Local dData		:= aCols[n,_nPosudata]
Local cResolvi	:= aCols[n,_nPosresol]
//Local dDtresp	:= aCols[n,_nPosDtResp]
Local cMailCC	:= aCols[n,_nPosMailCC]

//MSGBOX("FUNNAME: " + FUNNAME())

If UPPER(FUNNAME()) != "TMKC026"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se a linha nao esta apagada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[n][Len(aHeader)+1]
		If !Empty( cN1 + cN2 + cN3 + cN4 + cN5 )
	
			If Empty(cResp)
				Aviso("Responsável não Definido","Por favor, defina um responsável para o item.",{"OK"})			
				lRet := .F.
			Endif
			
			//If Empty(cFlag)   //bloco comentado por Flávia Rocha - 06/05/14
					
				//aCols[n,_nPosudata] := Ctod("  /  /    ")
				//aCols[n,_nPosresol] := ""	
				//aCols[n,_nPosDtResp]:= Ctod("  /  /    ")
				
			//Endif
			
			//If Empty(cMailCC)
			If Empty(aCols[n,_nPosMailCC])
				If MsgYesNo("DESEJA DEFINIR o E-MAIL Para CÓPIA Desta OCORRÊNCIA ? ")
				
					//Inclusao do email com cópia da ocorrência
					#IFDEF WINDOWS
						DEFINE MSDIALOG oDlg TITLE OemtoAnsi( "E-mail cópia" ) FROM  00,00 TO 80,400 PIXEL OF oMainWnd
					    @ 010, 005 SAY "E-Mail:" SIZE 040, 0 OF oDlg PIXEL
					    @ 019, 005 GET cMailCC SIZE 160, 0 OF oDlg PIXEL
					    DEFINE SBUTTON FROM 018, 170 TYPE 1 ACTION ( aCols[n,_nPosMailCC] := cMailCC, oDlg:End() ) ENABLE OF oDlg
					    ACTIVATE MSDIALOG oDlg CENTER
					 #ENDIF
					
				Endif
			Endif
			
		Endif
	Endif

Endif	//funname

Return lRet            