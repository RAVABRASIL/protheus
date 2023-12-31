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
���Programa  � FATC024  �                            � Data �  12/06/2012 ���
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
User Function FATC024
***********************



//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCodUser  := __CUSERID
Private cCadastro := "Localidade do Transportador"


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
             {"Alterar","U_SZAltera()",0,4} ,;
             {"Excluir","AxDeleta",0,5} }
*/

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_SZAltera(2)",0,2} ,;  
             {"Alterar","U_SZAltera(3)",0,4} }  

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SX5" 
Private cAlias  := "SX5"
Private cParUSER:= GETMV("RV_USERSZZ") 

Private cFiltraSZZ := ""    //express�o do filtro
Private aIndexSZZ := {}
Private bFiltraBrw	:= {|| Nil}
Private coTbl1      := ""		  


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

cFiltraSZZ	:= "X5_TABELA = 'ZZ' "  //mostra apenas AS LOCALIDADES ATIVAS


If !Empty(cFiltraSZZ)
	bFiltraBrw	:= { || FilBrowse("SX5", @aIndexSZZ, @cFiltraSZZ) }
	Eval(bFiltraBrw)
EndIf
  
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return  


*****************************
User Function SZAltera( nOpt )    
*****************************

Local aArea    := GetArea(cAlias)
Local nOpcA    := 0
Private nReg    := (cAlias)->(RecNO())

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg1","oGrp1","oGetLOC","oSayLOC","oSayDesc","oGetDesc","oSayPRZ","oGetPRZ","oSayTIPO","oGetTIPO")
SetPrvt("oSayPRZ2","oGetPRZ2","oBrw1","oSBtnOK","oSBtnCAN","oBrw1", "oSayTRs")
SetPrvt("cLoc","cDesc","cPRZa","cTipo","cPRZ2")

SX5->(DBGOTO(nReg))
cLoc := SX5->X5_CHAVE //Space(6)
cDesc:= SX5->X5_DESCRI //Space(30)
cPRZa:= 0
cTipo:= Space(1) 
cPRZ2:= Space(3)
/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/

oDlg1      := MSDialog():New( 052,301,519,1008,"Altera��o Geral : Transportadora x Localidade",,,.F.,,,,,,.T.,,,.F. ) 
oTbl1()


oGrp1      := TGroup():New( 008,008,050,332," Informa��es da Localidade  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayLOC    := TSay():New( 028,016,{||"Localiza��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oGetLOC    := TGet():New( 028,060,,oGrp1,041,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ","cLoc",,)
oGetLOC:bSetGet := {|u| If(PCount()>0,cLoc:=u,cLoc)} 
oGetLOC:lReadOnly   := .T.

oSayDesc   := TSay():New( 028,116,{||"Descri��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetDesc   := TGet():New( 028,174,,oGrp1,136,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,)
oGetDesc:bSetGet := {|u| If(PCount()>0,cDesc:=u,cDesc)} 
oGetDesc:lReadOnly   := .T. 

oSayTrs   := TSay():New( 060,016,{||"TRANSPORTADORAS QUE ATENDEM ESTA LOCALIDADE:" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

fGetTRs(cLoc)
DbSelectArea("TMPTR")
TMPTR->(DbGoTop())      

oBrw1 := MsSelect():New( "TMPTR","","",{{"CODTRANSP","","Transp",""},;
                         {"NOMTRANSP","","Nome Transp",""},;
                         {"TIPOLOC","","Tipo Localid.",""},;
                         {"DIATRAB","","Trabalha de:",""},;
                         {"PRZE","","Prazo de Entrega",""},;
                         {"LOCALID","","Localidade",""}},.F.,,;
                         {080,012,160,332},,, oDlg1 )   //228,269 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
//oBrw1:= lVisibleControl := Empty(cLoc) 

If nOpt = 3
	oGrp2      := TGroup():New( 168,008,198,333," ALTERA��O PRAZO ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSayPRZ2   := TSay():New( 178,016,{||"Prazo Entrega Novo:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,057,008)
	oGetPRZ2   := TGet():New( 176,082,,oGrp2,060,008,'999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPRZ2",,) 
	oGetPRZ2:bSetGet := {|u| If(PCount()>0,cPRZ2:=u,cPRZ2)}
	oBtnOK    := TButton():New( 178,212,"Altera",oGrp2,,037,012,,,,.T.,,"",,,,.F. )
	oBtnOK:bAction := {|| (nOpcA := 1, Grava(cPRZ2) ) }  
	//
Endif

oBtnSai    := TButton():New( 206,152,"Sair",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtnSai:bAction := {||oDlg1:End()}

oDlg1:Activate(,,,.T.)


TMPTR->(DbCloseArea())
Ferase(coTbl1+".DBF")
Ferase(coTbl1+OrdBagExt())


Return 

********************************
Static Function Grava(cPrazo2)
********************************

Local lPode := .F.
Local LF    := CHR(13) + CHR(10)
//If nOpcA = 1
    
	If MsgYesNo("Deseja Realmente Alterar para: " + cPrazo2 + " Dia(s) " + LF ;
	            + "O Prazo de Todas as Transportadoras para Esta Localidade ? " + LF;
	            + cDesc, "Aten��o" )	
		lPode := U_SENHA4("21", 0 , "Altera��o de Prazo Generalizada") //SENHA4( cTipo, nOpcao, cTITULO )
		If lPode
			DbselectArea("TMPTR")
			TMPTR->(DBGOTOP()) 
			While !TMPTR->(EOF())
				RecLock("TMPTR",.F.)	   		
				TMPTR->PRZE	:= Val(cPrazo2)
				TMPTR->(MsUnLock())
				TMPTR->(DBSKIP())
			Enddo
			
			DbselectArea("SZZ")
			Dbsetorder(2)
			SZZ->(DBGOTOP())
			If SZZ->(Dbseek(xFilial("SZZ") + cLoc )) 
				While !SZZ->(EOF()) .And. SZZ->ZZ_FILIAL == xFilial("SZZ") .And. Alltrim(SZZ->ZZ_LOCAL) = Alltrim(cLoc)
					RecLock("SZZ",.F.)	   		
					SZZ->ZZ_PRZENT	:= Val(cPrazo2)
					SZZ->(MsUnLock())
					SZZ->(DBSKIP())
				Enddo 
			Endif
			DbselectArea("SZZ")
			MsgInfo("Altera��o Efetuada com Sucesso!")
			TMPTR->(DBGOTOP())	  
		Endif
	Endif
	//oDlg1:End()
//Endif
Return


********************************
Static Function fGetInfo(cLoc, nOpc) 
********************************

Local cTipo := ""
Local cQuery:= ""

cQuery := "Select top 1 ZZ_TIPO, ZZ_PRZENT, * from " + RetSqlName("SZZ") + " SZZ " 
cQuery += " WHERE ZZ_LOCAL = '" + Alltrim(cLoc) + "' " 
cQuery += " AND D_E_L_E_T_ = '' "
If Select("SZZX") > 0
	DbSelectArea("SZZX")
	DbCloseArea()
EndIf
			
TCQUERY cQuery NEW ALIAS "SZZX"

dbGoTop()
If !SZZX->(EOF())
	While !SZZX->(EOF())
		If nOpc = 1
			cTipo := Alltrim(Str(SZZX->ZZ_PRZENT)) 
		Elseif nOpc = 2
			If Alltrim(SZZX->ZZ_TIPO) = "I"
				cTipo := "Interior"
			Elseif Alltrim(SZZX->ZZ_TIPO) = "C"
				cTipo := "Capital"
			Endif		
		Endif
	    SZZX->(DBSKIP())
	Enddo
Endif
              
DbSelectArea("SZZX")
DbCloseArea()

Return(cTipo)

Return

*****************************
Static Function fGetDesc(cLoc)
*****************************

Local cDescri := ""

SX5->(DBSetorder(1))
cDescri := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + 'ZZ' + cLoc,1,0)

Return(cDescri)


/*����������������������������������������������������������������������������
Function  � oTbl1() - Cria temporario para o Alias: TMP
����������������������������������������������������������������������������*/
Static Function oTbl1()

Local aBrw := {}


Aadd( aBrw, {"CODTRANSP" ,"C",006,000} )
Aadd( aBrw, {"NOMTRANSP" ,"C",030,000} )
Aadd( aBrw, {"PRZE"      ,"N",003,000} )
Aadd( aBrw, {"TIPOLOC"   ,"C",010,000} )
Aadd( aBrw, {"LOCALID"   ,"C",004,000} )
Aadd( aBrw, {"DIATRAB"   ,"C",010,000} )




coTbl1 := CriaTrab( aBrw, .T. )
Use (coTbl1) Alias TMPTR New Exclusive
Index On NOMTRANSP To ( coTbl1 )

Return 


************************************************************************************************
Static Function fGetTRs( cLoc )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "TRANX"
Local nZZPrazo  := 0
Local cA4Cod    := ""
Local LF        := CHR(13) + CHR(10)
Local cTipo     := ""
Local cdiatrab  := ""

If !Empty(cLoc)
	cQuery := " SELECT A4_COD, ZZ_TRANSP, A4_NREDUZ, ZZ_LOCAL, ZZ_PRZENT, ZZ_TIPO, A4_DIATRAB " + LF
	cQuery += " FROM " + RetSqlName("SA4") + " SA4, " + LF
	cQuery += "      " + RetSqlName("SZZ") + " SZZ " + LF
	cQuery += " WHERE " + LF
	cQuery += " ZZ_TRANSP = A4_COD " + LF
	cQuery += " AND ZZ_LOCAL = '" + Alltrim(cLoc) + "' " + LF
	cQuery += " and SA4.D_E_L_E_T_  = ' ' " + LF
	cQuery += " and SZZ.D_E_L_E_T_ = ' ' " + LF
	cQuery += " order by A4_NREDUZ " + LF
	MemoWrite("C:\Temp\TRANS.SQL",cQuery)
	
	If Select("TRANX") > 0
		DbSelectArea("TRANX")
		DbCloseArea()	
	EndIf 
	
	// Cria tabela temporaria
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")
	
	//TCSetField( cAlias, "F2_EMISSAO", "D")
	//TCSetField( cAlias, "F2_DTEXP", "D")
	//TCSetField( cAlias, "F2_REALCHG", "D")
	//TCSetField( cAlias, "F2_UFCHG", "D")
	
	TRANX->(Dbgotop())
	While ! TRANX->(EOF())
	    DbselectArea("TMPTR")
		RecLock("TMPTR",.T.)	   		
		TMPTR->CODTRANSP:= TRANX->A4_COD
		TMPTR->NOMTRANSP:= TRANX->A4_NREDUZ
		TMPTR->PRZE     := TRANX->ZZ_PRZENT
		If Alltrim(TRANX->ZZ_TIPO) = "I"
			cTipo := "Interior"
		Elseif Alltrim(TRANX->ZZ_TIPO) = "C"
			cTipo := "Capital"
		Endif	
		TMPTR->TIPOLOC  := cTipo
		
		If Alltrim(TRANX->A4_DIATRAB) = "1"
			cdiatrab := "Seg-Sex"
		Elseif Alltrim(TRANX->A4_DIATRAB) = "2"
			cdiatrab := "Seg-Sab"
		Elseif Alltrim(TRANX->A4_DIATRAB) = "3" 
			cdiatrab := "Dom-Dom"
		Endif
		TMPTR->DIATRAB  := cdiatrab
		TMPTR->LOCALID  := TRANX->ZZ_LOCAL
		TMPTR->(MsUnLock())
	
	   TRANX->(DbSkip())
	Enddo
	
	//TMPTR->(DbGoTop())
	TRANX->(DbCloseArea()) 
Else
	RecLock("TMPTR",.T.)	   		
		TMPTR->CODTRANSP:= Space(6)
		TMPTR->NOMTRANSP:= Space(30)
		TMPTR->PRAZOE   := Str(0)
		TMPTR->(MsUnLock())
Endif

Return
