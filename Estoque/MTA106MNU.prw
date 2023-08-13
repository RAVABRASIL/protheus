#INCLUDE 'PROTHEUS.CH'


User Function MTA106MNU()

Local aRotUsr := {}
      aAdd(aRotina,{'INCLUIR', 'MATA105()' , 0 , 6, 0, nil})             
Return


/*User Function TesteMTA106()

Local aAreaAtu	:= GetArea()

SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oSay2","oGet2","oSay3","oGet3","oBrw1")

oDlg1      := MSDialog():New( 121,244,540,872,"Requisicao Almoxarifado",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 004,004,037,302,"Solicitação Almoxarifado",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,008,{||"Numero"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 016,032,,oGrp1,045,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oSay2      := TSay():New( 016,088,{||"Solicitante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 016,116,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oSay3      := TSay():New( 016,184,{||"Data Emissao"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 016,224,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	cNumREQ    := GetSXENum("SCP","CP_NUM")             //BUSCAR NÚMERO PARA A REQUISIÇÃO
	SCP->(DBSETORDER(1))                                //USA O PRIMEIRO INDICE
	SCP->(DBGOTOP())                                    //POSICIONA NO COMEÇO
	while SCP->( DbSeek( xFilial( "SCP" ) + cNumREQ ) ) //PROCURA NA SCP, SE JÁ EXISTE O NÚMERO GERADO 
	   ConfirmSX8()                						//CASO ENCONTRE, ELE ENTRA AQUI, E AÍ, ELE GRAVA ...
	   cNumREQ := GetSXENum("SCP","CP_NUM")   			//E BUSCA UM PRÓXIMO NÚMERO, ATÉ QUE ESTE NÃO EXISTA NA BASE
	ENDDO
DbSelectArea("SCP")

oBrw1      := MsSelect():New( "SCP","","",{{"CP_NUM","","Numero da SA",""},;
{"CP_ITEM","","Item da SA",""},;
{"CP_PRODUTO","","Produto",""},;
{"CP_UM","","Unid Medida",""},;
{"CP_QUANT","","Quantidade",""},;
{"CP_SEGUM","","Segunda UM",""},;
{"CP_QTSEGUM","","Qtd. 2a UM",""},;
{"CP_DATPRF","","Necessidade",""},;
{"CP_LOCAL","","Almoxarifado",""},;
{"CP_OBS","","Observacao",""},;
{"CP_CC","","Centro Custo",""},;
{"CP_CONTA","","Cta Contabil",""},;
{"CP_DESCRI","","Descricao",""},;
{"CP_NUMOS","","Nr.OS",""},;
{"CP_SEQRC","","Sq.Rp.Center",""},;
{"CP_ITEMCTA","","Item Contab",""},;
{"CP_CLVL","","Classe Valor",""},;
{"CP_PROJETO","","Ger.Projetos",""},;
{"CP_OP","","Ord Producao",""},;
{"CP_SALBLQ","","Saldo Bloq.",""}},.F.,,{044,004,193,302},,, oDlg1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK

oSBtn1     := SButton():New( 196,244,2,,oDlg1,,"", )
oSBtn1:bAction := {|| oDlg1:end()  }
oSBtn2     := SButton():New( 196,276,1,,oDlg1,,"", )
oSBtn2:bAction := {|| oDlg1:end()  }


oDlg1:Activate(,,,.T.)	
RestArea(aAreaAtu)
Return           */