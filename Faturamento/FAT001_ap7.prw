#INCLUDE "rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FAT001   �                            � Data �  14/11/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���Autoria   � Fl�via Rocha                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Localidade (SZZ)                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***********************
User Function FAT001
***********************



//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCodUser  := __CUSERID
Private cCadastro := "Localidade do Transportador"
Private cParUSER:= GETMV("RV_USERSZZ") 

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

/*
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir",Iif (Alltrim(cCodUser) $ Alltrim(cParUSER),"AxInclui" ,"MsgInfo('Acesso n�o Permitido !!')"  ),0,3} ,;
             {"Alterar","U_SZZAltera()",0,4} ,;
             {"Alt.GERAL",Iif (Alltrim(cCodUser) $ Alltrim(cParUSER),"U_FATC024()" ,"MsgInfo('Acesso n�o Permitido !!')"  ),0,4} ,;
             {"Excluir",Iif (Alltrim(cCodUser) $ Alltrim(cParUSER),"AxDeleta" ,"MsgInfo('Acesso n�o Permitido !!')"  ),0,5} }

*/  

if ! U_Senha2("21",1)[1]
   return 
endif

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui" ,0,3} ,;
             {"Alterar","U_SZZAltera()",0,4} ,;
             {"Alt.GERAL","U_FATC024()" ,0,4} ,;
             {"Excluir","AxDeleta" ,0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZZ"
//Private cParUSER:= GETMV("RV_USERSZZ") 
/*
Private cFiltraSZZ := ""    //express�o do filtro
Private aIndexSZZ := {}
Private bFiltraBrw	:= {|| Nil}		  
*/

dbSelectArea("SZZ")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

//cFiltraSZZ	:= "ZZ_ATIVO != 'N' "  //mostra apenas os clientes ATIVOS

/*
If !Empty(cFiltraSZZ)
	bFiltraBrw	:= { || FilBrowse("SZZ", @aIndexSZZ, @cFiltraSZZ) }
	Eval(bFiltraBrw)
EndIf
*/  
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return  


*****************************
User Function SZZAltera()    
*****************************
local cXXAnt:=SZZ->ZZ_ATIVO
Local aButtons := {}
Local aRotauto := {}
Local cAlias   := cString
Local nReg	   := SZZ->(RECNO())
Local nOpc	   := 4
Local lPode    := .T.
Local aNfs     := {}
Local cMsg     := "" 
Local x        := 0


//cParUSER = 000007 (MARCELO VIANA)
/*
If !Empty(cParUSER)      //se estiver preenchido, permite apenas os usu�rios que constam no par�metro
	If Alltrim(cCodUser) $ Alltrim(cParUSER)
		nOpcA := fAxAltera(cAlias,nReg,nOpc, , , , , , , , , aButtons, , aRotAuto, )
	Else
		MsgInfo("Acesso n�o Permitido !!")
	Endif
Else    //se estiver vazio, permite qualquer usu�rio
	nOpcA := fAxAltera(cAlias,nReg,nOpc, , , , , , , , , aButtons, , aRotAuto, )
Endif
*/	

aNfs := ValidAlter(SZZ->ZZ_TRANSP, SZZ->ZZ_LOCAL)
If Len(aNfs) > 0
	For x := 1 to Len(aNfs)
		If x = 1
			cMsg += aNfs[x,1]
		Else
			cMsg += ', ' + aNfs[x,1]
		Endif
		lPode := aNfs[x,2]
	Next
Endif
//aguardar parecer de Marcelo - FR 24/04/14

If .T. //lPode
	nOpcA := fAxAltera(cAlias,nReg,nOpc, , , , , , , , , aButtons, , aRotAuto, )
Else
	MsgAlert("A Localidade/Transportadora Selecionada Est� Associada a NFs que Ainda Est�o em Transporte: " + CHR(13) + CHR(10);
	+ cMsg + CHR(13) + CHR(10) + " *** Altera��o n�o Permitida !! ***")
Endif

IF SZZ->ZZ_ATIVO<>cXXAnt 
   IF SZZ->ZZ_ATIVO='S' // ATIVO 	  
	  // INATIVO AS DEMAIS TRANSPORTADORA PARA AQUELA LOCALIDADE 
	  cQuery:="BEGIN TRANSACTION  UPDATE "+RetSqlName("SZZ")+" SET ZZ_ATIVO='N' WHERE ZZ_LOCAL='"+SZZ->ZZ_LOCAL+"' AND ZZ_ATIVO<>'N' AND ZZ_TRANSP <>'"+SZZ->ZZ_TRANSP+"' AND ZZ_FILIAL='"+XFILIAL('SZZ')+"' AND D_E_L_E_T_='' COMMIT"
	  TcSqlExec(cQuery)	

   ENDIF
ENDIF


Return       

*************************************************************************************************************************************
STATIC FUNCTION fAxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons,aParam,aAuto,lVirtual,lMaximized) 
*************************************************************************************************************************************

Local aArea    := GetArea(cAlias)
Local aPosEnch := {}
Local bCampo   := {|nCPO| Field(nCPO) }
Local bOk      := Nil
Local bOk2     := {|| .T.}
Local cCpoFil  := PrefixoCpo(cAlias)+"_FILIAL"
Local cMemo    := ""
Local nOpcA    := 0
Local nX       := 0
Local oDlg
Local nTop
Local nLeft
Local nBottom
Local nRight
Local cAliasMemo
Local bEndDlg := {|lOk| lOk:=oDlg:End(), nOpcA:=1, lOk}
Local oEnc01
Private aTELA[0][0]
Private aGETS[0]

Private lVirtual:= .F.
Private cTudoOk := ".T."
Private nReg    := (cAlias)->(RecNO())
Private bOk := &("{|| "+cTudoOk+"}")
//�������������������������������������������������������������������Ŀ
//� Processamento de codeblock de validacao de confirmacao            �
//���������������������������������������������������������������������
If !Empty(aParam)
	bOk2 := aParam[2]
EndIf	
//����������������������������������������������������������������������Ŀ
//�VerIfica se esta' alterando um registro da mesma filial               �
//������������������������������������������������������������������������
DbSelectArea(cAlias)
If (cAlias)->(FieldPos(cCpoFil))==0 .Or. (cAlias)->(FieldGet(FieldPos(cCpoFil))) == xFilial(cAlias)
	//��������������������������������������������������������������Ŀ
	//� Monta a entrada de dados do arquivo						     �
	//����������������������������������������������������������������	
	If SoftLock(cAlias)
		RegToMemory(cAlias,.F.,lVirtual)
		//�������������������������������������������������������������������Ŀ
		//� Inicializa variaveis para campos Memos Virtuais		 			  �
		//���������������������������������������������������������������������
		If Type("aMemos")=="A"
			For nX:=1 to Len(aMemos)
				cMemo := aMemos[nX][2]
				If ExistIni(cMemo)
					&cMemo := InitPad(SX3->X3_RELACAO)
				Else
					&cMemo := ""
				EndIf
			Next nX
		EndIf
		//�������������������������������������������������������������������Ŀ
		//� Inicializa variaveis para campos Memos Virtuais		 			  �
		//���������������������������������������������������������������������
		If ( ValType( cFunc ) == 'C' )
		    If ( !("(" $ cFunc) )
			   cFunc+= "()"
			EndIf
			&cFunc
		EndIf
		//�������������������������������������������������������������������Ŀ
		//� Processamento de codeblock de antes da interface                  �
		//���������������������������������������������������������������������
		If !Empty(aParam)
			Eval(aParam[1],nOpc)
		EndIf		
		//������������������������������������������������������Ŀ
		//� Envia para processamento dos Gets				   	 �
		//��������������������������������������������������������
		If aAuto == Nil

			If SetMDIChild()
				oMainWnd:ReadClientCoors()
				nTop := 40
				nLeft := 30 
				nBottom := oMainWnd:nBottom-80
				nRight := oMainWnd:nRight-70		
			Else
				nTop := 135
				nLeft := 0
				nBottom := TranslateBottom(.T.,28)
				nRight := 632
			EndIf
			If FindFunction("ISPDA").and. IsPDA()
				nTop := 0
				nLeft := 0
				nBottom := PDABOTTOM
				nRight  := PDARIGHT
			EndIf
			// Build com corre��o no tratamento dos controles pendentes na dialog ao executar o m�todo End()
			If GetBuild() >= "7.00.060302P" 
				bEndDlg := {|lOk| If(lOk:=oDlg:End(),nOpcA:=1,nOpcA:=3), lOk}
			EndIf

			DEFINE MSDIALOG oDlg TITLE cCadastro FROM nTop,nLeft TO nBottom,nRight PIXEL OF oMainWnd	

			If lMaximized <> NIL
				oDlg:lMaximized := lMaximized
			EndIf

			If FindFunction("ISPDA").and. IsPDA()
				oEnc01:= MsMGet():New( cAlias, nReg, nOpc,     ,"CRA",oemtoansi("alt1"),aAcho,  aPosEnch,aCpos, ,nColMens,If(nColMens != Nil,cMensagem,NIL),cTudoOk,,lVirtual,.t. ) //"Quanto �s altera��es?"
				oEnc01:oBox:align := CONTROL_ALIGN_ALLCLIENT
			Else
				aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}
				If nColMens != Nil
					nOpcA := EnChoice( cAlias, nReg, nOpc, ,"CRA",oemtoansi("alt2"),aAcho,aPosEnch,aCpos,,nColMens,cMensagem,cTudoOk,,lVirtual ) //"Quanto �s altera��es?"
				Else
					nOpcA:=EnChoice( cAlias, nReg, nOpc, ,"CRA",oemtoansi("alt3"),aAcho,aPosEnch,aCpos,,,,cTudoOk,,lVirtual) //"Quanto �s altera��es?"
				EndIf
			EndIf
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIf(Obrigatorio(aGets,aTela).And.Eval(bOk).And.Eval(bOk2,nOpc),Eval(bEndDlg),(nOpcA:=3,.F.))},{|| nOpcA := 3,oDlg:End()},,aButtons,nReg,cAlias)
		Else
			If EnchAuto(cAlias,aAuto,{|| Obrigatorio(aGets,aTela) .And. Eval(bOk).And.Eval(bOk2,nOpc)},nOpc,aCpos)
				nOpcA := 1
			EndIf
		EndIf
		(cAlias)->(MsGoTo(nReg))
		If nOpcA == 1
			Begin Transaction
				RecLock(cAlias,.F.)
				For nX := 1 TO FCount()
					FieldPut(nX,M->&(EVAL(bCampo,nX)))
				Next nX
				//�������������������������������������������������������������������Ŀ
				//�Grava os campos Memos Virtuais					  				  �
				//���������������������������������������������������������������������
				If Type("aMemos") == "A"
					For nX := 1 to Len(aMemos)
						cVar := aMemos[nX][2]
						cVar1:= aMemos[nX][1]
//Inclu�do parametro com o nome da tabela de memos => para m�dulo APT
						cAliasMemo := If(len(aMemos[nX]) == 3,aMemos[nX][3],Nil)
						MSMM(&cVar1,TamSx3(aMemos[nX][2])[1],,&cVar,1,,,cAlias,aMemos[nX][1],cAliasMemo)
					Next nX
				EndIf
				If cTransact != Nil
					If !("("$cTransact)
						cTransact+="()"
					EndIf
					&cTransact
				EndIf
				//�������������������������������������������������������������������Ŀ
				//� Processamento de codeblock dentro da transacao                    �
				//���������������������������������������������������������������������
				If !Empty(aParam)
					Eval(aParam[3],nOpc)
				EndIf				
			End Transaction
			//�������������������������������������������������������������������Ŀ
			//� Processamento de codeblock fora da transacao                      �
			//���������������������������������������������������������������������
			If !Empty(aParam)
				Eval(aParam[4],nOpc)
			EndIf					
		EndIf		
	Else
		nOpcA := 3
	EndIf
Else
	Help(" ",1,"A000FI")
	nOpcA := 3
EndIf
//�������������������������������������������������������������������Ŀ
//� Restaura a integridade dos dados                                  �
//���������������������������������������������������������������������
MsUnLockAll()
RestArea(aArea)


Return(nOpcA)

********************************************
Static Function ValidAlter(cTransp, cLocal)
********************************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local lPode  := .T.
Local aNotas := {}

cQuery := "Select "
cQuery += " F2_REALCHG,F2_PREVCHG,F2_TRANSP, F2_LOCALIZ, * " + LF
cQuery += " from " + RetSqlName("SF2") + " SF2 " + LF
cQuery += " Where "  + LF
cQuery += " F2_REALCHG = '' " + LF
cQuery += " and F2_DTEXP <> '' and F2_DTEXP >= '20140401' " + LF //marco zero para come�ar esta valida��o
cQuery += " and F2_TRANSP = '" + cTransp + "' " + LF
cQuery += " and F2_LOCALIZ= '" + cLocal  + "' " + LF
cQuery += " and F2_FILIAL = '" + xFilial("SF2") + "' " + LF
cQuery += " and F2_TRANSP <> '024' " + LF
cQuery += " and SF2.D_E_L_E_T_ = '' " + LF
cQuery += " ORDER BY F2_DOC " 

MemoWrite("C:\TEMP\alterSZZ.SQL", cQuery )
If Select("TEMP1") > 0
	DbselectArea("TEMP1")
	DbcloseArea()
Endif
TCQUERY cQUery NEW ALIAS "TEMP1"
TCSetField( 'TEMP1', 'F2_PREVCHG', 'D' )
TCSetField( 'TEMP1', 'F2_REALCHG', 'D' )


If !TEMP1->(EOF())
	
	TEMP1->(Dbgotop())
	While !TEMP1->(EOF())
		If Empty(TEMP1->F2_REALCHG) //se a NF ainda n�o chegou no cliente, n�o pode alterar a localidade
			lPode := .F.
			Aadd(aNotas , {TEMP1->F2_DOC , lPode } )
		Endif
		TEMP1->(Dbskip())
	Enddo
Endif

Return(aNotas)