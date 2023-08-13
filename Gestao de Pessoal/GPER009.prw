#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER009   º Autor ³ Flávia Rocha       º Data ³  03/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                             //
//Documentos do RH: (impressos qdo da inclusão do funcionário ou pelo      //
//                   P.E. : GPE10MENU:                                     //
//             Contrato de Experiência                                    º±±
//             Aditivo ao Contrato                                         //
//             PIS                                                         //
//             Declaração do VT                                            //
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Depto. Pessoal - RH                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*******************************
User Function GPER009(aDados , nOpc)  
*******************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "CONTRATO DE EXPERIÊNCIA"
Local cPict          := ""
Local titulo       := "" //"CONTRATO DE EXPERIÊNCIA"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Local cPerg       := "GPR009"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "GPER009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
//Private cPerg       := "GPR009"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GPR009" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)


//pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc = 1
	titulo       := "CONTRATO DE EXPERIÊNCIA"
ElseIf nOpc = 2
	titulo       := "ADITIVO AO CONTRATO DE TRABALHO"
ElseIf nOpc = 3
	titulo       := "DOCTO. PIS"
ElseIf nOpc = 4
	titulo       := "DECLARAÇÃO DO VT"
ElseIf nOpc = 5
	titulo       := "TERMO DE RESPONSABILIDADE"
Endif

MsAguarde( { || RunReport(Cabec1, Cabec2, Titulo, nLin, aDados, nOpc) }, "Aguarde. . .", "Gerando Documento . . ." )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  03/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, aDados, nOpc)

Local nOrdem
Local chtm := "" 
Local cDir := ""
Local cArq := ""
Local nHandle := 0
Local nHand   := 0
Private cMailTo := ""

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Aadd( aDados, { cNomeFun, cNacional,;  1,2
//                 cFuncao, dDataNasc,;  3,4
//                 cEndereco, cBairro,;  5,6
//                 cCidade, cUF,;        7,8
//                 cCarteira, cSerie,;   9,10
//                 nSalario, cDataExtenso,;  11,12
//                 cMat, cCPF,;              13,14
//                 cGenero, cRG,;            15,16
//                 cMae, cMunNat, cUFNat,;     17,18,19
//                 cCodNAC, cUFCTPS, cUFRG     20, 21, 22
//                 cTitElei, cComplem , dDTRG  23, 24 , 25
//} ) 

////cria o diretório local, caso não exista 
  
//////////////////////////////////////////////
/////////OPÇÃO LOCAL QUE ABRE AUTOMATICAMENTE
//////////////////////////////////////////////
If nOpc = 1 .or. nOpc = 2 .or. nOpc = 3 .or. nOpc = 4 .or. nOpc = 5
	////ARQUIVO LOCAL
	lDir := ExistDir('C:\TEMP') // Resultado: .F.
	cDir := "C:\TEMP\"
	If !lDir
		//msgbox("cria Dir")
		U_CriaDir( cDir ) 
	Endif
	
	If nOpc = 1
		cArq  := "Contrato_EXP_" + Alltrim(aDados[1,13]) + ".html" 
	Elseif nOpc = 2
		cArq  := "Aditivo_Contr_" + Alltrim(aDados[1,13]) + ".html"   
	Elseif nOpc = 3
		cArq  := "PIS_" + Alltrim(aDados[1,13]) + ".html" 
	Elseif nOpc = 4
		cArq  := "Decl_VT_" + Alltrim(aDados[1,13]) + ".html"
	Elseif nOpc = 5
		cArq  := "Termo_Resp_" + Alltrim(aDados[1,13]) + ".html"
	Endif
	nHand := fCreate( cDir + cArq, 0 )
	If nHand = -1
	     MsgAlert('O arquivo '+ AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif

/*
	opções:
	1 - contrato experiência
	2 - aditivo ao contrato de trabalho
	3 - PIS
	4 - Declaração do VT
	5 - Termo responsabilidade
*/
/////////////////////////////////////////////////
///p/ envio do email
/////////////////////////////////////////////////
	cDirHTM  := "\Temp\"
	If nOpc = 1    
		cArqHTM  := "Contrato_EXP_" + Alltrim(aDados[1,13]) + ".html"   
	Elseif nOpc = 2
		cArqHTM  := "Aditivo_Contr_" + Alltrim(aDados[1,13]) + ".html"   
	Elseif nOpc = 3
		cArqHTM  := "PIS_" + Alltrim(aDados[1,13]) + ".html" 
	Elseif nOpc = 4
		cArqHTM  := "Decl_VT_" + Alltrim(aDados[1,13]) + ".html"
	Elseif nOpc = 5
		cArqHTM  := "Termo_Resp_" + Alltrim(aDados[1,13]) + ".html"
	Endif
	nHandle := fCreate( cDirHTM + cArqHTM, 0 )
	
	If nHandle = -1
	     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
	///grava o HTML com seu conteúdo
	chtm := U_RH_HTM( aDados , nOpc )
Endif


///CAPTURA O EMAIL DO USUÁRIO LOGADO NO SISTEMA
cMailTo := ""
cCorpo  := ""
cAnexo  := ""
cCopia  := ""
cAssun  := ""
	
PswOrder(1)
If PswSeek( __CUSERID , .T. )  
   aUsu   := PSWRET() 				
   cUsu   := Alltrim( aUsu[1][2] )  
   cNomeUsr:= Alltrim( aUsu[1][4] )  
   cEmailUsr:= Alltrim( aUsu[1][14] )
   cDeptoUsr:= Alltrim( aUsu[1][12] )
Endif
cMailTo := cEmailUsr
	
//////GRAVA O HTML 
If nOpc = 1 .or. nOpc = 2 .or. nOpc = 3 .or. nOpc = 4 .or. nOpc = 5
	Fwrite( nHand, chtm, Len(chtm) )
	FClose( nHand )
	
	fAbreHTM(cDir, cArq)

	//////GRAVA O HTML 
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle )
	
	cCopia  := ""
	cAssun  := Titulo + " - Func.: " + Alltrim(aDados[1,13]) + '-'+	Alltrim(aDados[1,1])
	cCorpo  := cAssun  + CHR(13) + CHR(10)
	cCorpo  += " Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
	If FERASE("\Temp\" + Alltrim(cArqHTM) ) == -1   
	   //MsgStop('Falha na deleção do Arquivo')
	//Else   
	   //MsgStop('Arquivo deletado com sucesso.')
	Endif
    MsgInfo("Documento Gerado com Sucesso...Favor Verificar o seu E-mail.")
//Elseif nOpc = 3
	//gera htm PIS

Endif

Return


//gera html
************************************
User Function RH_HTM( aDados, nOpc )   
************************************

Local chtm := ""
Local LF   := CHR(13) + CHR(10) 
Private oHtml
Private oProcess

If nOpc = 1 ///CONTRATO EXPERIÊNCIA

	chtm := '<html xmlns:o="urn:schemas-microsoft-com:office:office" '+LF
	chtm += 'xmlns:w="urn:schemas-microsoft-com:office:word" '+LF
	chtm += 'xmlns:st1="urn:schemas-microsoft-com:office:smarttags" '+LF
	chtm += 'xmlns="http://www.w3.org/TR/REC-html40"> '+LF
	
	chtm += '<head> '+LF
	chtm += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"> '+LF
	chtm += '<meta name=ProgId content=Word.Document> '+LF
	chtm += '<meta name=Generator content="Microsoft Word 11"> '+LF
	chtm += '<meta name=Originator content="Microsoft Word 11"> '+LF
	chtm += '<link rel=File-Linst '+LF
	chtm += 'href="Cont.%20de%20Experiência%20PLÁSTICO%20-%20MICHELE%20MORGAN_files/filelist.xml"> '+LF
	chtm += '<title>Contrato de Experiência</title> '+LF
	chtm += '<o:SmartTagType namespaceuri="urn:schemas-microsoft-com:office:smarttags" '+LF
	chtm += ' name="date"/> '+LF
	
	chtm += '<style> '+LF
	chtm += '<!-- '+LF
	chtm += ' /* Style Definitions */ '+LF
	chtm += ' p.MsoNormal, li.MsoNormal, div.MsoNormal '+LF
	chtm += '	{mso-style-parent:""; '+LF
	chtm += '	margin:0cm; '+LF
	chtm += '	margin-bottom:.0001pt; '+LF
	chtm += '	mso-pagination:widow-orphan; '+LF
	chtm += '	font-size:12.0pt; '+LF
	chtm += '	font-family:"Times New Roman"; '+LF
	chtm += '	mso-fareast-font-family:"Times New Roman";} '+LF
	chtm += 'p.MsoHeading8, li.MsoHeading8, div.MsoHeading8 '+LF
	chtm += '	{mso-style-next:Normal; '+LF
	chtm += '	margin:0cm; '+LF
	chtm += '	margin-bottom:.0001pt; '+LF
	chtm += '	text-align:center; '+LF
	chtm += '	mso-pagination:widow-orphan; '+LF
	chtm += '	page-break-after:avoid; '+LF
	chtm += '	mso-outline-level:8; '+LF
	chtm += '	font-size:12.0pt; '+LF
	chtm += '	mso-bidi-font-size:12.0pt; '+LF
	chtm += '	font-family:"Times New Roman"; '+LF
	chtm += '	mso-fareast-font-family:"Times New Roman";} '+LF
	chtm += 'p.MsoHeading9, li.MsoHeading9, div.MsoHeading9 '+LF
	chtm += '	{mso-style-next:Normal; '+LF
	chtm += '	margin:0cm; '+LF
	chtm += '	margin-bottom:.0001pt; '+LF
	chtm += '	mso-pagination:widow-orphan; '+LF
	chtm += '	page-break-after:avoid; '+LF
	chtm += '	mso-outline-level:9; '+LF
	chtm += '	font-size:12.0pt;         '+LF
	chtm += '	mso-bidi-font-size:12.0pt; '+LF
	chtm += '	font-family:"Times New Roman"; '+LF
	chtm += '	mso-fareast-font-family:"Times New Roman";} '+LF
	chtm += '@page Section1 '+LF
	chtm += '	{size:595.3pt 841.9pt; '+LF
	chtm += '	margin:70.9pt 3.0cm 2.0cm 3.0cm; '+LF
	chtm += '	mso-header-margin:35.45pt; '+LF
	chtm += '	mso-footer-margin:35.45pt; '+LF
	chtm += '	mso-paper-source:0;} '+LF
	chtm += 'div.Section1 '+LF
	chtm += '	{page:Section1;} '+LF
	chtm += '--> '+LF
	chtm += '</style> '+LF
	chtm += '<!--[if gte mso 10]> '+LF
	chtm += '<style> '+LF
	chtm += ' /* Style Definitions */ '+LF
	chtm += ' table.MsoNormalTable '+LF
	chtm += '	{mso-style-name:"Table Normal"; '+LF
	chtm += '	mso-tstyle-rowband-size:0; '+LF
	chtm += '	mso-tstyle-colband-size:0; '+LF
	chtm += '	mso-style-noshow:yes; '+LF
	chtm += '	mso-style-parent:""; '+LF
	chtm += '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; '+LF
	chtm += '	mso-para-margin:0cm; '+LF
	chtm += '	mso-para-margin-bottom:.0001pt; '+LF
	chtm += '	mso-pagination:widow-orphan; '+LF
	chtm += '	font-size:12.0pt; '+LF
	chtm += '	font-family:"Times New Roman"; '+LF
	chtm += '	mso-ansi-language:#0400; '+LF
	chtm += '	mso-fareast-language:#0400; '+LF
	chtm += '	mso-bidi-language:#0400;} '+LF
	chtm += 'table.MsoTableGrid '+LF
	chtm += '	{mso-style-name:"Table Grid"; '+LF
	chtm += '	mso-tstyle-rowband-size:0; '+LF
	chtm += '	mso-tstyle-colband-size:0; '+LF
	chtm += '	border:solid windowtext 1.0pt; '+LF
	chtm += '	mso-border-alt:solid windowtext .5pt; '+LF
	chtm += '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; '+LF
	chtm += '	mso-border-insideh:.5pt solid windowtext; '+LF
	chtm += '	mso-border-insidev:.5pt solid windowtext; '+LF
	chtm += '	mso-para-margin:0cm; '+LF
	chtm += '	mso-para-margin-bottom:.0001pt; '+LF
	chtm += '	mso-pagination:widow-orphan; '+LF
	chtm += '	font-size:12.0pt; '+LF
	chtm += '	font-family:"Times New Roman"; '+LF
	chtm += '	mso-ansi-language:#0400; '+LF
	chtm += '	mso-fareast-language:#0400; '+LF
	chtm += '	mso-bidi-language:#0400;} '+LF
	chtm += '</style> '+LF
	chtm += '<![endif]--> '+LF
	chtm += '</head> '+LF
	
	//Aadd(aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso, cMat, cCPF,;
	///                  1         2         3         4           5       6        7      8       9        10        11          12       13     14  
	// cGenero, cRG } )
    //   15      16
	
	chtm += '<body lang=PT-BR style="tab-interval:35.4pt"> '+LF
	chtm += '<div class=Section1> '+LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center"><b style="mso-bidi-font-weight:normal"> '+LF
	chtm += '<span style="font-size:14.0pt;mso-bidi-font-size:12.0pt">***<span style="mso-tab-count:1"></span>CONTRATO<span style="mso-tab-count:1"> '+LF
	chtm += '</span>DE <span style="mso-tab-count:1"></span>EXPERIÊNCIA<span style="mso-tab-count:1"></span>***</span></b> '+LF
	chtm += '<span style="font-size:14.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p> '+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><o:p>&nbsp;</o:p></span></p> '+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> '+LF
	chtm += 'Por este instrumento particular firmado entre as partes de um lado o (a) Sr.(a).<b style="mso-bidi-font-weight:normal"> '+LF
	chtm += '<span style="color:blue">'+ aDados[1,1] + '</span>,</b> nascido (a) em <span style="mso-spacerun:yes"></span><b style="mso-bidi-font-weight:normal"> '+LF
	chtm += '<span style="color:blue;font-size:12.0pt">'+ Dtoc(aDados[1,4]) + '</span>,</b> ' + aDados[1,2] + ' (a), residente no Endereço: '+LF
	chtm += '<b style="mso-bidi-font-weight:normal"><span style="color:blue">'+ aDados[1,5] + ',</span> – </b>Bairro:<span style="color:blue"> '+LF
	chtm += '<b> ' + aDados[1,6] + ' </span><span style="mso-spacerun:yes"></b>, Cidade:</span> <span style="color:blue;font-size:12.0pt"><b> ' + aDados[1,7] + ',</b></span> '+LF
	chtm += ' Estado: <span style="color:blue;font-size:12.0pt"><b> ' + aDados[1,8] + ' </span></b><span style="color:blue">,</span> </span><!--[if supportFields]> '+LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><span style="mso-element:field-begin"> '+LF
	chtm += '</span><span style="mso-spacerun:yes"> </span>DOCVARIABLE<span style="mso-spacerun:yes"></span>GPE_ENDERECO<span style="mso-spacerun:yes">  '+LF
	chtm += '</span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">' + LF
	chtm += '<span style="mso-element:field-end"></span></span><![endif]--><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">' + LF
	chtm += '<span style="mso-element:field-begin"></span><span style="mso-spacerun:yes"> </span>DOCVARIABLE'+LF
	chtm += '<span= style="mso-spacerun:yes"></span>GPE_BAIRRO<span style="mso-spacerun:yes">'+LF 
	chtm += '</span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-end"></span></span><![endif]--><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-begin"></span><span style="mso-spacerun:yes"></span>DOCVARIABLE<span style="mso-spacerun:yes">'+LF
	chtm += '</span>GPE_MUNICIPIO<span style="mso-spacerun:yes"></span>\* MERGEFORMAT</span><![endif]--><!--[if supportFields]>'+LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><span style="mso-element:field-end"></span></span><![endif]-->'+LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">portador da carteira profissional nº:'+LF
	chtm += '<b style="mso-bidi-font-weight:normal"><span style="color:blue">' + aDados[1,9] + ' , </b></span>Serie: <span style="color:blue">'+LF
	chtm += '<b> ' + aDados[1,10] + '  </b></span>de agora em diante designado *<b style="mso-bidi-font-weight:normal">EMPREGADO*,'+LF
	chtm += '</b>e de outro a firma RAVA EMBALAGENS INDÚSTRIA E COMÉRCIO LTDA<b style="mso-bidi-font-weight:normal">,'+LF
	chtm += '</b>com sede a Rua José Gerônimo da Silva Filho, 66 – Renascer – Cabedelo/Pb, inscrita no CNPJ sob o nº 41.150.160/0001-02, de agora em diante'+LF
	chtm += ' designada <b style="mso-bidi-font-weight:normal">EMPREGADORA, </b>fica justo e combinado o seguinte:</span> </p>'+LF
	chtm += '<p class=MsoNormal style="text-align:justify"><o:p>&nbsp;</o:p></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '1º-A <b style="mso-bidi-font-weight:normal">EMPREGADORA '+LF
	chtm += '</b>admite o empregado para exercer a função ' + aDados[1,3] + ' .</span><!--[if supportFields]>'+LF
	chtm += '<b> style="mso-bidi-font-weight:normal"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-begin"></span> DOCVARIABLE<span style="mso-spacerun:yes">'+LF
	chtm += '</span>GPE_DESC_FUNCAO<span style="mso-spacerun:yes">'+LF
	chtm += '</span>\* MERGEFORMAT </span></b><![endif]--><!--[if supportFields]>'+LF
	chtm += '<b style="mso-bidi-font-weight:normal"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-end"></span></span></b><![endif]--><b style="mso-bidi-font-weight:normal">'+LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">,</span></b><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += 'percebendo o salário de <b style="mso-bidi-font-weight:normal">R$</b></span><!--[if supportFields]>'+LF
	chtm += '<b style="mso-bidi-font-weight:normal"><span style="font-size:12.0pt;mso-bidi-font-size:10.0pt"><span style="mso-element:field-begin">'+LF
	chtm += '</span> DOCVARIABLE<span style="mso-spacerun:yes"></span>GPE_SALARIO<span style="mso-spacerun:yes"> '+LF
	chtm += '</span>\* MERGEFORMAT </span></b><![endif]--><!--[if supportFields]>'+LF
	chtm += '<b style="mso-bidi-font-weight:normal"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-end"></span></span></b><![endif]--><b style="mso-bidi-font-weight:normal">'+LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><span style="mso-spacerun:yes">'+LF
	chtm += '</span>' + Transform( aDados[1,11] , "@E 99,999,999.99" ) + ' </span></b><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-begin">'+LF
	chtm += '</span> DOCVARIABLE<span style="mso-spacerun:yes"> '+LF
	chtm += '</span>GPE_EXTENSO_SAL<span style="mso-spacerun:yes">'+LF
	chtm += '</span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-element:field-end"></span></span><![endif]--><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<span style="mso-spacerun:yes"></span>pagos por mês.<o:p></o:p></span></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '<o:p>&nbsp;</o:p></span></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += '2º-O prazo do presente contrato é de <b style="mso-bidi-font-weight:normal">45 dias</b>, podendo ser prorrogado por '+LF
	chtm += 'mais <b style="mso-bidi-font-weight:normal">45 dias</b>, obedecido o disposto '+LF
	chtm += 'no Parágrafo Único do Artigo 445 da C.L.T., findo o qual, passará a vigorar por '+LF
	chtm += 'prazo indeterminado:<o:p></o:p></span></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><o:p>&nbsp;</o:p></span></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">'+LF
	chtm += ' 3º-Opera-se a rescisão do contrato pela decorrência do prazo; rescindindo-se por vontade do empregado ou pela empregadora com justa '+LF
	chtm += 'causa, nenhuma indenização é devida; rescindindo-se, antes do prazo, pela empregadora, fica esta obrigada a pagar 50% dos salários devidos até o final – '+LF
	chtm += '(metade do tempo combinado restante), nos termos do artigo 479 da C.L.T., com alteração introduzida pelo Decreto Lei nº 229, de <st1:date ls="trans" Month="2"'+LF
	chtm += 'Day="28" Year="19" w:st="on">28 de fevereiro de 19</st1:date>67, sem prejuízo do disposto no regulamento do Fundo de Garantia do Tempo de Serviço.<o:p></o:p></span></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><o:p>&nbsp;</o:p></p>'+LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += 'Rescindindo-se antes do prazo pelo Empregado, fica este obrigado a indenizar o Empregador em 50% dos salários devidos até o final ' + LF
	chtm += '- (metade do tempo combinado restante) por prejuízos que desse fato lhe resultarem, nos termos do artigo 480 da C.L.T.<o:p></o:p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><o:p>&nbsp;</o:p></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += 'Nenhum aviso prévio é devido pela rescisão do presente contrato.<o:p></o:p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><o:p>&nbsp;</o:p></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += 'E, por assim estarem de acordo, firmam o presente em duas vias, uma das quais é entregue ao empregado. ' + LF
	chtm += ' <span style="mso-tab-count:1">       </span><o:p></o:p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><o:p>&nbsp;</o:p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align="left" style="text-align:center"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += 'Cabedelo/ PB,<span style="mso-tab-count:1"> </span> ' + aDados[1,12] + ' </span><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += '<span style="mso-tab-count:1"> </span><p><p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += '<o:p>&nbsp;</o:p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += 'RAVA Embalagens Indústria Com. Ltda.</span></p><BR> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"><BR><BR> ' + LF
	chtm += '______________________________<span style="mso-spacerun:yes">         </span> ' + LF
	chtm += '_____________________________________<span style="mso-spacerun:yes">           </span> <span style="mso-spacerun:yes"></span> ' + LF
	
	chtm += '<p class=MsoHeading8 align=left style="text-align:left"><span style="font-size:12.0pt;text-transform:uppercase"> ' + LF
	chtm += 'GERENTE DE RH</span><span style="mso-spacerun:yes">                       </span><span style="mso-spacerun:yes">     </span> ' + LF
	chtm += '<span style="mso-spacerun:yes">                   </span>Empregado</p><BR><BR> ' + LF
	
	
	chtm += '<div align=center> ' + LF
	
	chtm += '<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 style="border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt; ' + LF
	chtm += ' mso-yfti-tbllook:480;mso-padding-alt:0cm 5.4pt 0cm 5.4pt;mso-border-insideh:.5pt solid windowtext;mso-border-insidev:.5pt solid windowtext"> ' + LF
	chtm += ' <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes;height:99.25pt"> ' + LF
	chtm += '  <td width=581 valign=top style="width:436.0pt;border:solid windowtext 1.0pt;mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:99.25pt"> ' + LF
	chtm += '  <p class=MsoHeading9 align=center style="text-align:center"><b style="mso-bidi-font-weight:normal">TERMO DE PRORROGAÇÃO<o:p></o:p></b></p> ' + LF
	chtm += '  <p class=MsoNormal><span style="font-family:Arial;mso-bidi-font-family:"Times New Roman"><o:p>&nbsp;</o:p></span></p> ' + LF
	chtm += '  <p class=MsoNormal style="text-align:justify"><span style="font-family:Arial;mso-bidi-font-family:"Times New Roman"> ' + LF
	chtm += ' Por mutuo acordo entre as partes, fica o presente Contrato de Experiência, que deveria vencer nesta data prorrogado até o dia: ' + LF
	chtm += ' <span style="mso-spacerun:yes">       </span>/<span style="mso-spacerun:yes">      </span>/ </span></p> ' + LF
	chtm += '  <p class=MsoNormal style="margin-left:35.4pt;text-align:justify;text-indent: 35.4pt"><span style="font-size:12.0pt;mso-bidi-font-size:12.0pt"> ' + LF
	chtm += '<o:p>&nbsp;</o:p></span></p> ' + LF
	chtm += '  <p class=MsoNormal style="margin-left:35.4pt;text-align:justify;text-indent:35.4pt"><BR> ' + LF
	chtm += '<span style="font-size:12.0pt;mso-bidi-font-size:12.0pt">Empregadora<span style="mso-tab-count:5">                                                 </span>Empregado<o:p></o:p></span></p> ' + LF
	chtm += '  <p class=MsoNormal style="text-align:justify;tab-stops:0cm"><o:p>&nbsp;</o:p></p> ' + LF
	chtm += '  </td> ' + LF
	chtm += ' </tr> ' + LF
	chtm += '</table> ' + LF
	
	chtm += '</div> ' + LF
	
	chtm += '<p class=MsoNormal><o:p>&nbsp;</o:p></p> ' + LF
	
	chtm += '</div> ' + LF
	
	chtm += '</body> ' + LF
	
	chtm += '</html> ' + LF
	
Elseif nOpc = 2   ///ADITIVO AO CONTRATO DE TRABALHO
    
	chtm += '<html xmlns:o="urn:schemas-microsoft-com:office:office" ' + LF
	chtm += 'xmlns:w="urn:schemas-microsoft-com:office:word" ' + LF
	chtm += 'xmlns="http://www.w3.org/TR/REC-html40"> ' + LF
	
	chtm += '<head> ' + LF
	chtm += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"> ' + LF
	chtm += '<meta name=ProgId content=Word.Document> ' + LF
	chtm += '<meta name=Generator content="Microsoft Word 11"> ' + LF
	chtm += '<meta name=Originator content="Microsoft Word 11"> ' + LF
	chtm += '<link rel=File-List ' + LF
	chtm += 'href="Termo%20Aditivo%20ao%20Contrato%20de%20Trabalho_files/filelist.xml"> ' + LF
	chtm += '<title>*** TERMO ADITIVO AO CONTRATO DE TRABALHO ***</title> ' + LF
	chtm += '<!--[if gte mso 9]><xml> ' + LF
	chtm += ' <o:DocumentProperties> ' + LF
	chtm += '  <o:Author>karla.barreto</o:Author> ' + LF
	chtm += '  <o:LastAuthor>Flavia Rocha</o:LastAuthor> ' + LF
	chtm += '  <o:Revision>2</o:Revision> ' + LF
	chtm += '  <o:TotalTime>4</o:TotalTime> ' + LF
	chtm += '  <o:LastPrinted>2012-01-11T17:43:00Z</o:LastPrinted> ' + LF
	chtm += '  <o:Created>2012-02-22T16:06:00Z</o:Created> ' + LF
	chtm += '  <o:LastSaved>2012-02-22T16:06:00Z</o:LastSaved> ' + LF
	chtm += '  <o:Pages>1</o:Pages> ' + LF
	chtm += '  <o:Words>495</o:Words> ' + LF
	chtm += '  <o:Characters>2677</o:Characters> ' + LF
	chtm += '  <o:Company>Rava</o:Company> ' + LF
	chtm += '  <o:Lines>22</o:Lines> ' + LF
	chtm += '  <o:Paragraphs>6</o:Paragraphs> ' + LF
	chtm += '  <o:CharactersWithSpaces>3166</o:CharactersWithSpaces> ' + LF
	chtm += '  <o:Version>11.5606</o:Version> ' + LF
	chtm += ' </o:DocumentProperties> ' + LF
	chtm += '</xml><![endif]--><!--[if gte mso 9]><xml> ' + LF
	chtm += ' <w:WordDocument> ' + LF
	chtm += '  <w:SpellingState>Clean</w:SpellingState> ' + LF
	chtm += '  <w:GrammarState>Clean</w:GrammarState> ' + LF
	chtm += '  <w:HyphenationZone>21</w:HyphenationZone> ' + LF
	chtm += '  <w:PunctuationKerning/> ' + LF
	chtm += '  <w:ValidateAgainstSchemas/> ' + LF
	chtm += '  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid> ' + LF
	chtm += '  <w:IgnoreMixedContent>false</w:IgnoreMixedContent> ' + LF
	chtm += '  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText> ' + LF
	chtm += '  <w:Compatibility> ' + LF
	chtm += '   <w:BreakWrappedTables/> ' + LF
	chtm += '   <w:SnapToGridInCell/> ' + LF
	chtm += '   <w:WrapTextWithPunct/> ' + LF
	chtm += '   <w:UseAsianBreakRules/> ' + LF
	chtm += '   <w:DontGrowAutofit/> ' + LF
	chtm += '  </w:Compatibility> ' + LF
	chtm += '  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> ' + LF
	chtm += ' </w:WordDocument> ' + LF
	chtm += '</xml><![endif]--><!--[if gte mso 9]><xml> ' + LF
	chtm += ' <w:LatentStyles DefLockedState="false" LatentStyleCount="156"> ' + LF
	chtm += ' </w:LatentStyles> ' + LF
	chtm += '</xml><![endif]--> ' + LF
	chtm += '<style> ' + LF
	chtm += '<!-- ' + LF
	chtm += ' /* Font Definitions */ ' + LF
	chtm += ' @font-face ' + LF
	chtm += '	{font-family:PMingLiU; ' + LF
	chtm += '	panose-1:2 2 5 0 0 0 0 0 0 0; ' + LF
	chtm += '	mso-font-alt:\65B0\7D30\660E\9AD4; ' + LF
	chtm += '	mso-font-charset:136; ' + LF
	chtm += '	mso-generic-font-family:roman; ' + LF
	chtm += '	mso-font-pitch:variable; ' + LF
	chtm += '	mso-font-signature:-1610611969 684719354 22 0 1048577 0;} ' + LF
	chtm += '@font-face ' + LF
	chtm += '	{font-family:"\@PMingLiU"; ' + LF
	chtm += '	panose-1:2 2 5 0 0 0 0 0 0 0; ' + LF
	chtm += '	mso-font-charset:136; ' + LF
	chtm += '	mso-generic-font-family:roman; ' + LF
	chtm += '	mso-font-pitch:variable; ' + LF
	chtm += '	mso-font-signature:-1610611969 684719354 22 0 1048577 0;} ' + LF
	chtm += ' /* Style Definitions */ ' + LF
	chtm += ' p.MsoNormal, li.MsoNormal, div.MsoNormal ' + LF
	chtm += '	{mso-style-parent:""; ' + LF
	chtm += '	margin:0cm; ' + LF
	chtm += '	margin-bottom:.0001pt; ' + LF
	chtm += '	mso-pagination:widow-orphan; ' + LF
	chtm += '	font-size:12.0pt; ' + LF
	chtm += '	font-family:"Times New Roman"; ' + LF
	chtm += '	mso-fareast-font-family:"Times New Roman";} ' + LF
	chtm += '@page Section1 ' + LF
	chtm += '	{size:595.3pt 841.9pt; ' + LF
	chtm += '	margin:53.95pt 46.3pt 70.85pt 63.0pt; ' + LF
	chtm += '	mso-header-margin:35.4pt; ' + LF
	chtm += '	mso-footer-margin:35.4pt; ' + LF
	chtm += '	mso-paper-source:0;} ' + LF
	chtm += 'div.Section1 ' + LF
	chtm += '	{page:Section1;} ' + LF
	chtm += '--> ' + LF
	chtm += '</style> ' + LF
	chtm += '<!--[if gte mso 10]> ' + LF
	chtm += '<style> ' + LF
	chtm += ' /* Style Definitions */ ' + LF
	chtm += ' table.MsoNormalTable ' + LF
	chtm += '	{mso-style-name:"Table Normal"; ' + LF
	chtm += '	mso-tstyle-rowband-size:0; ' + LF
	chtm += '	mso-tstyle-colband-size:0; ' + LF
	chtm += '	mso-style-noshow:yes; ' + LF
	chtm += '	mso-style-parent:""; ' + LF
	chtm += '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; ' + LF
	chtm += '	mso-para-margin:0cm; ' + LF
	chtm += '	mso-para-margin-bottom:.0001pt; ' + LF
	chtm += '	mso-pagination:widow-orphan; ' + LF
	chtm += '	font-size:10.0pt; ' + LF
	chtm += '	font-family:"Times New Roman"; ' + LF
	chtm += '	mso-ansi-language:#0400; ' + LF
	chtm += '	mso-fareast-language:#0400; ' + LF
	chtm += '	mso-bidi-language:#0400;} ' + LF
	chtm += '</style> ' + LF
	chtm += '<![endif]--> ' + LF
	chtm += '</head> ' + LF
	
	chtm += '<body lang=PT-BR style="tab-interval:35.4pt"> ' + LF
	
	chtm += '<div class=Section1> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="margin-right:2.2pt;text-align:center;line-height:150%">' + LF
	chtm += '<b style="mso-bidi-font-weight:normal">*** TERMO ADITIVO AO ' + LF
	chtm += 'CONTRATO DE TRABALHO ***<o:p></p></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="margin-right:-28.4pt;text-align:center;line-height:150%"><p>&nbsp;</p></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-right:4.95pt;text-align:justify;line-height=150%">' + LF
	chtm += '<span style="font-size:11.0pt;line-height:150%">De um lado, a empresa </span><b ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU">'+LF
	chtm += 'RAVA EMBALAGENS INDÚSTRIA E COMERCIO ' + LF
	chtm += 'LTDA</span></b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU">, empresa situada na Rua Santa Clara, 336, Lote 128 Quadra 4<span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span>Loteamento Nª Srª da Conceição – Renascer – ' + LF
	chtm += 'Cabedelo/PB – CEP 58310-000, inscrita no CNPJ sob o nº 41.150.160/0005-28, ' + LF
	chtm += 'representado nos termos de seu contrato social<b>,</b> doravante denominado ' + LF
	chtm += 'simplesmente <b>CONTRATANTE, </b><span style="mso-bidi-font-weight:bold">e de ' + LF
	chtm += 'outro o funcionário: <BR> ' + LF
	//Aadd( aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco, cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso, cMat, cCPF } )	
	chtm += '<span style="color:blue">' + aDados[1,1] + '</span>, portador(a) da Carteira de Trabalho e Previdência Social de nº: <span style="color:blue">' + aDados[1,9] + '</span>'+ LF
	chtm += ' , série: <span style="color:blue">' + aDados[1,10] + '</span>, inscrito no CPF sob o nº: <span style="color:blue">' + TRANSFORM( aDados[1,14] , "@R 999.999.999-99") + '</span> , ' + LF
	chtm += 'pactuam de mútuo acordo as seguintes disposições que passam a integrar o ' + LF
	chtm += 'contrato de trabalho celebrado em ' + Dtoc(dDatabase) + '<b>.</b></span></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><b><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b>' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><b><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU">Cláusula ' + LF
	chtm += 'Primeira:</span></b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"> Fica o funcionário, ciente de todos os ' + LF
	chtm += 'procedimentos, processos e informações a que teve acesso por força do ' + LF
	chtm += 'desenvolvimento de suas atividades são confidenciais e consideradas pela ' + LF
	chtm += 'CONTRATANTE como estratégicas ao desenvolvimento de sua atividade industrial e ' + LF
	chtm += 'comercial.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-left:1.0cm;text-align:justify;line-height:150%"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"><p>&nbsp;</p></span>' + LF
	
	chtm += '<p class=MsoNormal style="margin-left:1.0cm;text-align:justify;line-height: ' + LF
	chtm += '150%"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold">Parágrafo Único. Em decorrência desta ' + LF
	chtm += 'confidencialidade, o funcionário, compromete-se a se abster de realizar ' + LF
	chtm += 'comentários ou divulgar informações industriais, comerciais ou técnicas à ' + LF
	chtm += 'terceiros, ou a concorrentes da CONTRATANTE, sem o seu prévio consentimento, ' + LF
	chtm += 'sob pena da caracterização de falta grave a ser punida com a rescisão do ' + LF
	chtm += 'contrato de trabalho por justa causa.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-right:-28.4pt;text-align:justify;line-height: ' + LF
	chtm += '150%"><b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-right:4.95pt;text-align:justify;line-height: ' + LF
	chtm += '150%"><b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU">Cláusula Segunda</span></b><span style="font-size:11.0pt;line-height: ' + LF
	chtm += '150%;mso-fareast-font-family:PMingLiU;mso-bidi-font-weight:bold">: Caso o ' + LF
	chtm += 'funcionário descumpra a confidencialidade acima pactuada arcará, quando de sua ' + LF
	chtm += 'demissão por justa causa com o pagamento de multa contratual correspondente ao ' + LF
	chtm += 'valor de três salários seus, baseados no valor do último salário pago, sem ' + LF
	chtm += 'prejuízo das ações indenizatórias caso o prejuízo da CONTRATANTE ultrapasse ' + LF
	chtm += 'esta monta. <p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-right:-28.4pt;text-align:justify;line-height: ' + LF
	chtm += '150%"><b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><b><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU">Cláusula ' + LF
	chtm += 'Terceira:</span></b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"> A CONTRATANTE informa ao funcionário, e ' + LF
	chtm += 'este toma ciência, de que, caso o funcionário se utilize de recursos de ' + LF
	chtm += 'internet ou comunicação eletrônica de qualquer espécie (emails, chats, blogs, ' + LF
	chtm += 'sites de relacionamento social, mensagens instantâneas ou outros equivalentes ' + LF
	chtm += 'ou similares) no exercício de suas funções laborais, a CONTRATANTE poderá ' + LF
	chtm += 'monitorar o conteúdo de tais comunicações sem prévia comunicação, dando o ' + LF
	chtm += 'funcionário neste ato, permissão para tal monitoramento irrestrito.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-top:0cm;margin-right:4.95pt;margin-bottom: ' + LF
	chtm += '0cm;margin-left:1.0cm;margin-bottom:.0001pt;text-align:justify;line-height: ' + LF
	chtm += '150%"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"><p>&nbsp;</p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-left:1.0cm;text-align:justify;line-height: ' + LF
	chtm += '150%"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold">Parágrafo Únic A CONTRATANTE só poderá ' + LF
	chtm += 'usar o conteúdo do monitoramento acima noticiado para fins judiciais e em ' + LF
	chtm += 'defesa de seus interesses industriais, comerciais ou estratégicos.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="margin-right:-28.4pt;text-align:justify;line-height: ' + LF
	chtm += '150%"><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"><p>&nbsp;</p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><b><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU">Cláusula ' + LF
	chtm += 'quarta:</span></b><span style="font-size:11.0pt;line-height:150%;mso-fareast-font-family: ' + LF
	chtm += 'PMingLiU;mso-bidi-font-weight:bold"> As disposições acima pactuadas continuarão ' + LF
	chtm += 'válidas mesmo após o encerramento do contrato de trabalho havido entre as ' + LF
	chtm += 'partes estando o funcionário, quanto à confidencialidade prevista nas cláusulas ' + LF
	chtm += 'primeira e segunda deste aditivo, obrigado a manter o sigilo absoluto sobre ' + LF
	chtm += 'tais dados pelo período de quatro anos contados da data da rescisão do contrato ' + LF
	chtm += 'de trabalho.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU; ' + LF
	chtm += 'mso-bidi-font-weight:bold"><p>&nbsp;</p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU; ' + LF
	chtm += 'mso-bidi-font-weight:bold">E por assim entenderem ser a presente expressão da ' + LF
	chtm += 'verdade e do consenso mutuo, assinam as partes o presente termo em duas vias.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%;mso-fareast-font-family:PMingLiU; ' + LF
	chtm += 'mso-bidi-font-weight:bold"><p>&nbsp;</p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-fareast-font-family:PMingLiU;mso-bidi-font-weight:bold">Cabedelo/ ' + LF
	chtm += 'PB, ' + aDados[1,12] + '.<p></p></span></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"<span style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="margin-right:4.95pt;text-align:center; ' + LF
	chtm += 'line-height:150%"><b style="mso-bidi-font-weight:normal"><span ' + LF
	chtm += 'style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU">RAVA ' + LF
	chtm += 'EMBALAGENS INDÚSTRIA E COMERCIO LTDA<p></p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal"><span style="mso-fareast-font-family:PMingLiU"><p>&nbsp;</p></span></b></p> ' + LF
	
	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="mso-bidi-font-weight:normal">-------------------------------------------------------------------</b></p> ' + LF
	
	chtm += '</div> ' + LF
	
	chtm += '</body> ' + LF
	
	chtm += '</html> ' + LF 

Elseif nOpc = 3         //PIS
//	MsgInfo("Desculpe, opção ainda não disponível !") 

	chtm := ' <html xmlns:v="urn:schemas-microsoft-com:vml'+ LF
	chtm += ' xmlns:o="urn:schemas-microsoft-com:office:office'+ LF
	chtm += ' xmlns:w="urn:schemas-microsoft-com:office:word'+ LF
	chtm += ' xmlns:m="http://schemas.microsoft.com/office/2004/12/omml'+ LF
	chtm += ' xmlns="http://www.w3.org/TR/REC-html40">'+ LF

	chtm += ' <head>'+ LF
	chtm += ' <meta http-equiv=Content-Type content="text/html; charset=windows-1252">'+ LF
	chtm += ' <meta name=ProgId content=Word.Document>'+ LF
	chtm += ' <meta name=Generator content="Microsoft Word 12">'+ LF
	chtm += ' <meta name=Originator content="Microsoft Word 12">'+ LF
	chtm += ' <link rel=File-List href="PIShtm_arquivos/filelist.xml">'+ LF
	chtm += ' <link rel=Edit-Time-Data href="PIShtm_arquivos/editdata.mso">'+ LF
	chtm += ' <!--[if !mso]>'+ LF
	chtm += ' <style>'+ LF
	chtm += ' v\:* {behavior:url(#default#VML);}'+ LF
	chtm += ' o\:* {behavior:url(#default#VML);}'+ LF
	chtm += ' w\:* {behavior:url(#default#VML);}'+ LF
	chtm += ' .shape {behavior:url(#default#VML);}'+ LF
	chtm += ' </style>'+ LF
	chtm += ' <![endif]-->'+ LF
	chtm += ' <title>CAIXA ECONÔMICA FEDERAL</title>'+ LF
	chtm += ' <!--[if gte mso 9]><xml>'+ LF
	chtm += '  <o:DocumentProperties>'+ LF
	chtm += '   <o:Author>João Batista Gonçalves</o:Author>'+ LF
	chtm += '   <o:LastAuthor>Flavia Rocha</o:LastAuthor>'+ LF
	chtm += '   <o:Revision>2</o:Revision>'+ LF
	chtm += '   <o:TotalTime>370</o:TotalTime>'+ LF
	chtm += '   <o:LastPrinted>2012-01-24T18:03:00Z</o:LastPrinted>'+ LF
	chtm += '   <o:Created>2012-05-18T13:28:00Z</o:Created>'+ LF
	chtm += '   <o:LastSaved>2012-05-18T13:28:00Z</o:LastSaved>'+ LF
	chtm += '   <o:Pages>1</o:Pages>'+ LF
	chtm += '   <o:Words>585</o:Words>'+ LF
	chtm += '   <o:Characters>3163</o:Characters>'+ LF
	chtm += '   <o:Company>Escritorio de Contabilidade</o:Company>'+ LF
	chtm += '   <o:Lines>26</o:Lines>'+ LF
	chtm += '   <o:Paragraphs>7</o:Paragraphs>'+ LF
	chtm += '   <o:CharactersWithSpaces>3741</o:CharactersWithSpaces>'+ LF
	chtm += '   <o:Version>12.00</o:Version>'+ LF
	chtm += '  </o:DocumentProperties>'+ LF
	chtm += ' </xml><![endif]-->'+ LF
	//chtm += ' <link rel=themeData href="PIShtm_arquivos/themedata.thmx">'+ LF
	//chtm += ' <link rel=colorSchemeMapping href="PIShtm_arquivos/colorschememapping.xml">'+ LF
	//chtm += ' 	<link rel=themeData href="LOGO_CAIXA_arquivos/themedata.thmx">'+ LF
	//chtm += ' <link rel=colorSchemeMapping href="LOGO_CAIXA_arquivos/colorschememapping.xml">'+ LF
	//chtm += ' 	<p class=MsoNormal style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:'+ LF
	//chtm += ' normal"><span style="mso-fareast-language:PT-BR;mso-no-proof:yes">'+ LF
	//chtm += ' <![if !vml]><img width=203 height=69'+ LF
	//chtm += ' src="LOGO_CAIXA_arquivos/image002.jpg" v:shapes="Imagem_x0020_1"><![endif]></span></p>'+ LF
	//chtm += ' <p class=MsoNormal style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:'+ LF
	//chtm += ' normal"><span style="font-size:10.0pt;font-family:"Verdana","sans-serif"><span'+ LF
	//chtm += ' style="mso-spacerun:yes"></span>CAIXA ECONÔMICA FEDERAL<o:p></o:p></span></p>'+ LF
	//chtm += ' </div>'+ LF


	chtm += ' <!--[if gte mso 9]><xml>'+ LF
	chtm += '  <w:WordDocument>'+ LF
	chtm += '   <w:GrammarState>Clean</w:GrammarState>'+ LF
	chtm += '   <w:DocumentProtection>Forms</w:DocumentProtection>'+ LF
	chtm += '   <w:UnprotectPassword>93E9C5A6</w:UnprotectPassword>'+ LF
	chtm += '   <w:TrackMoves>false</w:TrackMoves>'+ LF
	chtm += '   <w:TrackFormatting/>'+ LF
	chtm += '   <w:HyphenationZone>21</w:HyphenationZone>'+ LF
	chtm += '   <w:DisplayHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawingGridEvery>'+ LF
	chtm += '   <w:DisplayVerticalDrawingGridEvery>0</w:DisplayVerticalDrawingGridEvery>'+ LF
	chtm += '   <w:UseMarginsForDrawingGridOrigin/>'+ LF
	chtm += '   <w:ValidateAgainstSchemas/>'+ LF
	chtm += '   <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>'+ LF
	chtm += '   <w:IgnoreMixedContent>false</w:IgnoreMixedContent>'+ LF
	chtm += '   <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>'+ LF
	chtm += '   <w:DoNotPromoteQF/>'+ LF
	chtm += '   <w:LidThemeOther>PT-BR</w:LidThemeOther>'+ LF
	chtm += '   <w:LidThemeAsian>X-NONE</w:LidThemeAsian>'+ LF
	chtm += '   <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>'+ LF
	chtm += '   <w:Compatibility>'+ LF
	chtm += '    <w:FootnoteLayoutLikeWW8/>'+ LF
	chtm += '    <w:ShapeLayoutLikeWW8/>'+ LF
	chtm += '    <w:AlignTablesRowByRow/>'+ LF
	chtm += '    <w:ForgetLastTabAlignment/>'+ LF
	chtm += '    <w:LayoutRawTableWidth/>'+ LF
	chtm += '    <w:LayoutTableRowsApart/>'+ LF
	chtm += '    <w:UseWord97LineBreakingRules/>'+ LF
	chtm += '    <w:SelectEntireFieldWithStartOrEnd/>'+ LF
	chtm += '    <w:UseWord2002TableStyleRules/>'+ LF
	chtm += '    <w:DontUseIndentAsNumberingTabStop/>'+ LF
	chtm += '    <w:FELineBreak11/>'+ LF
	chtm += '    <w:WW11IndentRules/>'+ LF
	chtm += '    <w:DontAutofitConstrainedTables/>'+ LF
	chtm += '    <w:AutofitLikeWW11/>'+ LF
	chtm += '    <w:HangulWidthLikeWW11/>'+ LF
	chtm += '    <w:UseNormalStyleForList/>'+ LF
	chtm += '   </w:Compatibility>'+ LF
	chtm += '   <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>'+ LF
	chtm += '   <m:mathPr>'+ LF
	chtm += '    <m:mathFont m:val="Cambria Math"/>'+ LF
	chtm += '    <m:brkBin m:val="before"/>'+ LF
	chtm += '    <m:brkBinSub m:val="--"/>'+ LF
	chtm += '    <m:smallFrac m:val="off"/>'+ LF
	chtm += '    <m:dispDef/>'+ LF
	chtm += '    <m:lMargin m:val="0"/>'+ LF
	chtm += '    <m:rMargin m:val="0"/>'+ LF
	chtm += '    <m:defJc m:val="centerGroup"/>'+ LF
	chtm += '    <m:wrapIndent m:val="1440"/>'+ LF
	chtm += '    <m:intLim m:val="subSup"/>'+ LF
	chtm += '    <m:naryLim m:val="undOvr"/>'+ LF
	chtm += '   </m:mathPr></w:WordDocument>'+ LF
	chtm += ' </xml><![endif]--><!--[if gte mso 9]><xml>'+ LF
	chtm += '  <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="false"'+ LF
	chtm += '   DefSemiHidden="false" DefQFormat="false" LatentStyleCount="267">'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="Normal"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="heading 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="heading 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="heading 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="heading 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="heading 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="heading 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="heading 7"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="heading 8"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="heading 9"/>'+ LF
	chtm += '   <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"'+ LF
	chtm += '    QFormat="true" Name="caption"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="Title"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="Subtitle"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="Strong"/>'+ LF
	chtm += '   <w:LsdException Locked="false" QFormat="true" Name="Emphasis"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="99" SemiHidden="true"'+ LF
	chtm += '    Name="Placeholder Text"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="1" QFormat="true" Name="No Spacing"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="99" SemiHidden="true" Name="Revision"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="34" QFormat="true"'+ LF
	chtm += '    Name="List Paragraph"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="29" QFormat="true" Name="Quote"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="30" QFormat="true"'+ LF
	chtm += '    Name="Intense Quote"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 1"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 2"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 3"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 4"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 5"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="61" Name="Light List Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 6"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="19" QFormat="true"'+ LF
	chtm += '    Name="Subtle Emphasis"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="21" QFormat="true"'+ LF
	chtm += '    Name="Intense Emphasis"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="31" QFormat="true"'+ LF
	chtm += '    Name="Subtle Reference"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="32" QFormat="true"'+ LF
	chtm += '    Name="Intense Reference"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="33" QFormat="true" Name="Book Title"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="37" SemiHidden="true"'+ LF
	chtm += '    UnhideWhenUsed="true" Name="Bibliography"/>'+ LF
	chtm += '   <w:LsdException Locked="false" Priority="39" SemiHidden="true"'+ LF
	chtm += '    UnhideWhenUsed="true" QFormat="true" Name="TOC Heading"/>'+ LF
	chtm += '  </w:LatentStyles>'+ LF
	chtm += ' </xml><![endif]-->'+ LF
	chtm += ' <style>'+ LF
	chtm += ' <!--'+ LF
	chtm += '  /* Font Definitions */'+ LF
	chtm += '  @font-face'+ LF
	chtm += ' 	{font-family:"Cambria Math";'+ LF
	chtm += ' 	panose-1:2 4 5 3 5 4 6 3 2 4;'+ LF
	chtm += ' 	mso-font-charset:1;'+ LF
	chtm += ' 	mso-generic-font-family:roman;'+ LF
	chtm += ' 	mso-font-format:other;'+ LF
	chtm += ' 	mso-font-pitch:variable;'+ LF
	chtm += ' 	mso-font-signature:0 0 0 0 0 0;}'+ LF
	chtm += ' @font-face'+ LF
	chtm += ' 	{font-family:"Arial Black";'+ LF
	chtm += ' 	panose-1:2 11 10 4 2 1 2 2 2 4;'+ LF
	chtm += ' 	mso-font-charset:0;'+ LF
	chtm += ' 	mso-generic-font-family:swiss;'+ LF
	chtm += ' 	mso-font-pitch:variable;'+ LF
	chtm += ' 	mso-font-signature:647 0 0 0 159 0;}'+ LF
	chtm += '  /* Style Definitions */'+ LF
	chtm += '  p.MsoNormal, li.MsoNormal, div.MsoNormal'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-qformat:yes;'+ LF
	chtm += ' 	mso-style-parent:"";'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Times New Roman","serif";'+ LF
	chtm += ' 	mso-fareast-font-family:"Times New Roman";}'+ LF
	chtm += ' h1'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-qformat:yes;'+ LF
	chtm += ' 	mso-style-next:Normal;'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	page-break-after:avoid;'+ LF
	chtm += ' 	mso-outline-level:1;'+ LF
	chtm += ' 	font-size:11.0pt;'+ LF
	chtm += ' 	mso-bidi-font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Arial","sans-serif";'+ LF
	chtm += ' 	mso-bidi-font-family:"Times New Roman";'+ LF
	chtm += ' 	mso-font-kerning:0pt;'+ LF
	chtm += ' 	mso-bidi-font-weight:normal;}'+ LF
	chtm += ' h2'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-qformat:yes;'+ LF
	chtm += ' 	mso-style-next:Normal;'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	page-break-after:avoid;'+ LF
	chtm += ' 	mso-outline-level:2;'+ LF
	chtm += ' 	font-size:8.0pt;'+ LF
	chtm += ' 	mso-bidi-font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Arial","sans-serif";'+ LF
	chtm += ' 	mso-bidi-font-family:"Times New Roman";'+ LF
	chtm += ' 	mso-bidi-font-weight:normal;}'+ LF
	chtm += ' h3'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-qformat:yes;'+ LF
	chtm += ' 	mso-style-next:Normal;'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	text-align:center;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	page-break-after:avoid;'+ LF
	chtm += ' 	mso-outline-level:3;'+ LF
	chtm += ' 	font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Arial","sans-serif";'+ LF
	chtm += ' 	mso-bidi-font-family:"Times New Roman";'+ LF
	chtm += ' 	mso-bidi-font-weight:normal;}'+ LF
	chtm += ' h4'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-qformat:yes;'+ LF
	chtm += ' 	mso-style-next:Normal;'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	page-break-after:avoid;'+ LF
	chtm += ' 	mso-outline-level:4;'+ LF
	chtm += ' 	font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Arial","sans-serif";'+ LF
	chtm += ' 	mso-bidi-font-family:"Times New Roman";'+ LF
	chtm += ' 	mso-bidi-font-weight:normal;}'+ LF
	chtm += ' p.MsoBodyText, li.MsoBodyText, div.MsoBodyText'+ LF
	chtm += ' 	{mso-style-unhide:no;'+ LF
	chtm += ' 	margin:0cm;'+ LF
	chtm += ' 	margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	font-size:7.0pt;'+ LF
	chtm += ' 	mso-bidi-font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Arial","sans-serif";'+ LF
	chtm += ' 	mso-fareast-font-family:"Times New Roman";'+ LF
	chtm += ' 	mso-bidi-font-family:"Times New Roman";}'+ LF
	chtm += ' span.GramE'+ LF
	chtm += ' 	{mso-style-name:"";'+ LF
	chtm += ' 	mso-gram-e:yes;}'+ LF
	chtm += ' @page Section1'+ LF
	chtm += ' 	{size:21.0cm 842.0pt;'+ LF
	chtm += ' 	margin:19.85pt 42.55pt 19.85pt 70.9pt;'+ LF
	chtm += ' 	mso-header-margin:36.0pt;'+ LF
	chtm += ' 	mso-footer-margin:36.0pt;'+ LF
	chtm += ' 	mso-paper-source:0;}'+ LF
	chtm += ' div.Section1'+ LF
	chtm += ' 	{page:Section1;}'+ LF
	chtm += ' -->'+ LF
	chtm += ' </style>'+ LF
	chtm += ' <!--[if gte mso 10]>'+ LF
	chtm += ' <style>'+ LF
	chtm += '  /* Style Definitions */'+ LF
	chtm += '  table.MsoNormalTable'+ LF
	chtm += ' 	{mso-style-name:"Tabela normal";'+ LF
	chtm += ' 	mso-tstyle-rowband-size:0;'+ LF
	chtm += ' 	mso-tstyle-colband-size:0;'+ LF
	chtm += ' 	mso-style-noshow:yes;'+ LF
	chtm += ' 	mso-style-unhide:no;'+ LF
	chtm += ' 	mso-style-parent:"";'+ LF
	chtm += ' 	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;'+ LF
	chtm += ' 	mso-para-margin:0cm;'+ LF
	chtm += ' 	mso-para-margin-bottom:.0001pt;'+ LF
	chtm += ' 	mso-pagination:widow-orphan;'+ LF
	chtm += ' 	font-size:10.0pt;'+ LF
	chtm += ' 	font-family:"Times New Roman","serif";}'+ LF
	chtm += ' </style>'+ LF
	chtm += ' <![endif]--><!--[if gte mso 9]><xml>'+ LF
	chtm += '  <o:shapedefaults v:ext="edit" spidmax="2050"/>'+ LF
	chtm += ' </xml><![endif]--><!--[if gte mso 9]><xml>'+ LF
	chtm += '  <o:shapelayout v:ext="edit">'+ LF
	chtm += '   <o:idmap v:ext="edit" data="1"/>'+ LF
	chtm += '  </o:shapelayout></xml><![endif]-->'+ LF
	chtm += ' </head>'+ LF

	chtm += ' <body lang=PT-BR style="tab-interval:35.4pt">'+ LF

	chtm += ' <div class=Section1>'+ LF

	chtm += ' <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0'+ LF
	chtm += '  style="border-collapse:collapse;mso-padding-alt:0cm 3.5pt 0cm 3.5pt">'+ LF
	chtm += '  <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid">'+ LF
	chtm += '   <td width=241 rowspan=3 valign=top style="width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt">'+ LF
	chtm += '   <h1><!--[if gte vml 1]><v:shapetype id="_x0000_t75" coordsize="21600,21600"'+ LF
	chtm += '    o:spt="75" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f"'+ LF
	chtm += '    stroked="f">'+ LF
	chtm += '    <v:stroke joinstyle="miter"/>'+ LF
	chtm += '    <v:formulas>'+ LF
	chtm += '     <v:f eqn="if lineDrawn pixelLineWidth 0"/>'+ LF
	chtm += '     <v:f eqn="sum @0 1 0"/>'+ LF
	chtm += '     <v:f eqn="sum 0 0 @1"/>'+ LF
	chtm += '     <v:f eqn="prod @2 1 2"/>'+ LF
	chtm += '     <v:f eqn="prod @3 21600 pixelWidth"/>'+ LF
	chtm += '     <v:f eqn="prod @3 21600 pixelHeight"/>'+ LF
	chtm += '     <v:f eqn="sum @0 0 1"/>'+ LF
	chtm += '     <v:f eqn="prod @6 1 2"/>'+ LF
	chtm += '     <v:f eqn="prod @7 21600 pixelWidth"/>'+ LF
	chtm += '     <v:f eqn="sum @8 21600 0"/>'+ LF
	chtm += '     <v:f eqn="prod @7 21600 pixelHeight"/>'+ LF
	chtm += '     <v:f eqn="sum @10 21600 0"/>'+ LF
	chtm += '    </v:formulas>'+ LF
	chtm += '    <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>'+ LF
	chtm += '    <o:lock v:ext="edit" aspectratio="t"/>'+ LF
	chtm += '   </v:shapetype><v:shape id="_x0000_i1025" type="#_x0000_t75" style="width:121.5pt;'+ LF
	chtm += '    height:39.75pt" fillcolor="window">'+ LF
	chtm += '    <v:imagedata src="PIShtm_arquivos/image001.wmz" o:title=""/>'+ LF
	chtm += '   </v:shape><![endif]--><![if !vml]><img width=162 height=53'+ LF
	chtm += '   src="PIShtm_arquivos/image002.gif" v:shapes="_x0000_i1025"><![endif]><span'+ LF
	chtm += "  style='font-size:10.0pt;font-family:'Arial Black',sans-serif'><o:p></o:p></span></h1>"+ LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>01 –" + LF
	chtm += "   Carimbo padronizado do CNPJ ou <o:p></o:p></span></p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><span" + LF
	chtm += "   style='mso-spacerun:yes'>       </span>Matrícula no Cadastro Específico do" + LF
	chtm += "   INSS-CEI</span><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoBodyText>Para uso exclusivo da CEF Carimbo da Agência receptora</p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Norma" + LF
	chtm += "   CSA/CIEF nº 047<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>                                                              " + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;    " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:2;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:3'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2><o:p>&nbsp;</o:p></h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DOCUMENTO DE CADASTRAMENTO</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DO TRABALHADOR NO PIS – DCT</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;       " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += " </table>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " <table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0" + LF
	chtm += "  style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;" + LF
	chtm += "  mso-padding-alt:0cm 3.5pt 0cm 3.5pt;mso-border-insideh:.5pt solid windowtext;" + LF
	chtm += "  mso-border-insidev:.5pt solid windowtext'>" + LF
	chtm += "  <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>02 – IDENTIFICAÇÃO</span></b></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-size:8.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   DO EMPREGADOR/SINDICATO<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "    <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:2'>" + LF
	chtm += "    <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "    border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CNPJ/CEI<o:p></o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "    <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "    border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Nome:<o:p></o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:3'>" + LF
	chtm += "    <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "    border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "    style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "    mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "    style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "    style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "    name=CNPJCEI></a><![endif]>" + SM0->M0_CGC + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    name=CNPJCEI></a><![endif]>41.150.160/0005-28<!--[if gte mso 9]><xml>" + LF
	chtm += "     <w:data>FFFFFFFF000000000000070043004E0050004A004300450049000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "    </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "    style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "    </td>" + LF
	chtm += "    <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "    border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "    normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "    'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Empregador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Empregador></a><![endif]><span style='mso-no-proof:yes'>RAVA EMBALAGENS" + LF
	chtm += "   INDUSTRIA E COMERCIO LTDA </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000000000000A0045006D007000720065006700610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Empregador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregador'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=156 colspan=5 valign=top style='width:116.9pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Endereço:<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=EndereçoEmpresa></a><![endif]><span style='mso-no-proof:yes'>" + SM0->M0_ENDCOB + " - " + SM0->M0_BAIRCOB + " - " + SM0->M0_CIDCOB + "</span><!--[if gte mso 9]><xml>" + LF
	chtm += "   name=EndereçoEmpresa></a><![endif]><span style='mso-no-proof:yes'>RUA SANTA CLARA, 336 Nª SRª DA CONCEIÇÃO - RENASCER - CABEDELO </span><!--[if gte mso 9]><xml>" + LF
	//RUA SANTA CLARA, 336 Nª SRª DA CONCEIÇÃO - RENASCER - CABEDELO 
	chtm += "    <w:data>FFFFFFFF0000000000000F0045006E006400650072006500E7006F0045006D00700072006500730061000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Telefone<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Fax<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>                                                      " + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;         " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Telefone'><span style='mso-spacerun:yes'> </span>FORMTEXT" + LF
	chtm += "   <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefone'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=Telefone></a><![endif]>" + SM0->M0_TEL + "<!--[if gte mso 9]><xml>" + LF
	chtm += "   name=Telefone></a><![endif]>83 3048 1301<!--[if gte mso 9]><xml>" + LF
	//83 3048 1301
	chtm += "    <w:data>FFFFFFFF0000000000000800540065006C00650066006F006E0065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Telefone'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefone'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Telefax'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefax'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Telefax></a><![endif]><span style='mso-no-proof:yes'>83 3048 1302</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000000000000700540065006C0065006600610078000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Telefax'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefax'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:10'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:11;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>IDENTIFICAÇÃO DO TRABALHADOR<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:12;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:13;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>03" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:14;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Empregado'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregado'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Empregado></a><![endif]>"+ aDados[1,1] + "<!--[if gte mso 9]><xml>" + LF        //NOME FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF000000000000090045006D007000720065006700610064006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Empregado'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregado'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:15'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:16;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>04 –" + LF
	chtm += "   <span class=GramE>Data</span> de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 valign=top style='width:42.55pt;border:none;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>05 -" + LF
	chtm += "   Sexo<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 valign=top style='width:350.7pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>06" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> da" + LF
	chtm += "   Mãe<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:17;page-break-inside:avoid'>" + LF
	chtm += "   <td width=32 valign=top style='width:23.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Dia'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Dia'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Dia></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 7,2)  + " <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000200000003004400690061000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Dia'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Dia'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=32 valign=top style='width:23.9pt;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Mes'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mes'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Mes></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 5,2)  + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000200000003004D00650073000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Mes'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mes'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=64 colspan=2 valign=top style='width:47.85pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Ano'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Ano'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Ano></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 1,4)  + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF000004000000030041006E006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Ano'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Ano'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 valign=top style='width:42.55pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Sexo'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Sexo'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Sexo></a><![endif]><span style='mso-no-proof:yes'>" + aDados[1,15] + " </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000100000004005300650078006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Sexo'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Sexo'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 valign=top style='width:350.7pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Mãe'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mãe'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Mãe></a><![endif]>" + aDados[1,17] + "<!--[if gte mso 9]><xml>" + LF     //NOME DA MÃE
	chtm += "    <w:data>FFFFFFFF00000000000003004D00E30065000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Mãe'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mãe'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:18'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:19;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 valign=top style='width:272.85pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;           " + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>07" + LF
	chtm += "   – Município</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 valign=top style='width:55.8pt;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>08 –" + LF
	chtm += "   Cód. Nac.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Para" + LF
	chtm += "   Uso Exclusivo da CEF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:20;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 valign=top style='width:272.85pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=MunicípioNascimento></a><![endif]>" + aDados[1,18] + " <!--[if gte mso 9]><xml>" + LF  //município NASCIMENTO DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000013004D0075006E0069006300ED00700069006F004E0061007300630069006D0065006E0074006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'></span><span style='mso-element:" + LF
	chtm += "   field-end'></span><![endif]--><span style='mso-bookmark:MunicípioNascimento'></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=UFNascimento></a><![endif]>" + aDados[1,19] + "<!--[if gte mso 9]><xml>" + LF //UF DE NASCIMENTO DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF0000020000000C00550046004E0061007300630069006D0065006E0074006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 valign=top style='width:55.8pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Nacionalidade></a><![endif]><span style='mso-no-proof:yes'>" + aDados[1,20] + "</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000020000000D004E006100630069006F006E0061006C00690064006100640065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Solicitação" + LF
	chtm += "   atendida<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:21'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:22;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>09" + LF
	chtm += "   – CTPS - Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 valign=top style='width:63.75pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Série<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>10" + LF
	chtm += "   – CPF – Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Cont.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:23;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CTPSNúmero></a><![endif]>" + aDados[1,9] + " <!--[if gte mso 9]><xml>" + LF   //CTPS CARTEIRA PROFISSIONAL
	chtm += "    <w:data>FFFFFFFF0000000000000A0043005400500053004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 valign=top style='width:63.75pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CTPSSérie></a><![endif]>" + aDados[1,10] + "<!--[if gte mso 9]><xml>" + LF  //SÉRIE CTPS
	chtm += "    <w:data>FFFFFFFF000000000000090043005400500053005300E9007200690065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=UFEmissão></a><![endif]>" + aDados[1,21] + "<!--[if gte mso 9]><xml>" + LF  //UF CTPS
	chtm += "    <w:data>FFFFFFFF00000200000009005500460045006D00690073007300E3006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CPF'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CPF'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CPF></a><![endif]>" + Substr(aDados[1,14],1,9) + "<!--[if gte mso 9]><xml>" + LF      //CPF DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000003004300500046000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CPF'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CPF'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=DígitoCPF></a><![endif]>" + Substr(aDados[1,14],10,2) + "<!--[if gte mso 9]><xml>" + LF  //DIGITO DO CPF
	chtm += "    <w:data>FFFFFFFF00000200000009004400ED006700690074006F004300500046000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Preenchimento" + LF
	chtm += "   Incorreto<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:24'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:25;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 valign=top style='width:124.0pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>11" + LF
	chtm += "   – Carteira</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> de" + LF
	chtm += "   Identidade Nº<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 valign=top style='width:49.6pt;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Emissão<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'><p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	//" + Dtoc(aDados[1,25])+ "
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>12" + LF
	chtm += "   – Título de Eleitor – Número</span></span><span style='font-size:7.0pt;" + LF
	chtm += "   mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>DV<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Inscrição<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:26;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 valign=top style='width:124.0pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=IdentidadeNúmero></a><![endif]>" + aDados[1,16] + "<!--[if gte mso 9]><xml>" + LF    //RG DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000010004900640065006E007400690064006100640065004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 valign=top style='width:49.6pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=EstadoEmissor></a><![endif]>" + Dtoc(aDados[1,25]) + "<!--[if gte mso 9]><xml>" + LF   //dt EMISSÃO DO RG
	chtm += "    <w:data>FFFFFFFF0000000000000D00450073007400610064006F0045006D006900730073006F0072000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=TiítuloNúmero></a><![endif]>" + Substr(aDados[1,23],1,10) + "<!--[if gte mso 9]><xml>" + LF        //TITULO ELEITOR
	chtm += "    <w:data>FFFFFFFF0000000000000D0054006900ED00740075006C006F004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=DígitoTítulo></a><![endif]>" + Substr(aDados[1,23],11,2) + "<!--[if gte mso 9]><xml>" + LF   //ULTIMOS 2 DIGITOS DO TITULO ELEITOR
	chtm += "    <w:data>FFFFFFFF0000020000000C004400ED006700690074006F005400ED00740075006C006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 style='width:123.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:27'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:28;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>13" + LF
	chtm += "   – Endereço</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:29;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h4><!--[if supportFields]><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=EndereçoTrabalhador></a><![endif]><span class=GramE>" + aDados[1,5] + " - " + aDados[1,24] + "</span>" + LF  //ENDEREÇO DO FUNCIONÁRIO
	chtm += "   <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF000000000000130045006E006400650072006500E7006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span><!--[if supportFields]><span style='mso-bookmark:" + LF
	chtm += "   EndereçoTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'></span></h4>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:30'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:31;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Bairro<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 valign=top style='width:212.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Município<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 valign=top style='width:1.0cm;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CEP<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:32;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=BairroTrabalhador></a><![endif]>" + SM0->M0_BAIRCOB + " <!--[if gte mso 9]><xml>" + LF  //BAIRRO EMPRESA
	chtm += "   name=BairroTrabalhador></a><![endif]>RENASCER<!--[if gte mso 9]><xml>" + LF  //BAIRRO EMPRESA
	chtm += "    <w:data>FFFFFFFF0000000000001100420061006900720072006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 valign=top style='width:212.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	//chtm += "   'Times New Roman'><![if !supportNestedAnchors]><a name=MunicípioTrabalhador></a><![endif]>" + SM0->M0_CIDCOB + "<!--[if gte mso 9]><xml>" + LF  //MUNICÍPIO DA EMPRESA
	chtm += "   'Times New Roman'><![if !supportNestedAnchors]><a name=MunicípioTrabalhador></a><![endif]>CABEDELO<!--[if gte mso 9]><xml>" + LF  //MUNICÍPIO DA EMPRESA
	chtm += "    <w:data>FFFFFFFF00000000000014004D0075006E0069006300ED00700069006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'></span><span style='mso-element:" + LF
	chtm += "   field-end'></span><![endif]--><span style='mso-bookmark:MunicípioTrabalhador'></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 valign=top style='width:1.0cm;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=UFEndTrabalhador></a><![endif]><span style='mso-no-proof:yes'>" + SM0->M0_ESTCOB + "</span><!--[if gte mso 9]><xml>" + LF  //UF DA EMPRESA
	chtm += "   name=UFEndTrabalhador></a><![endif]><span style='mso-no-proof:yes'>PB</span><!--[if gte mso 9]><xml>" + LF  //UF DA EMPRESA
	chtm += "    <w:data>FFFFFFFF00000200000010005500460045006E006400540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP1'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP1'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP1></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),1,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP1></a><![endif]><span class=GramE>5</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500031000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP1'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP1'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP2'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP2'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP2></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),2,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP2></a><![endif]><span style='mso-no-proof:yes'>8</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500032000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP2'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP2'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP3'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP3'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP3></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),3,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP3></a><![endif]><span style='mso-no-proof:yes'>3</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500033000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP3'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP3'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP4'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP4'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP4></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),4,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP4></a><![endif]><span class=GramE>1</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500034000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP4'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP4'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP5'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP5'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP5></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),5,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP5></a><![endif]><span class=GramE>0</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500035000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP5'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP5'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP6'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP6'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP6></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),6,1) + "</span><!--[if gte mso 9]><xml>" + LF //CEP DA EMPRESA
	chtm += "   name=CEP6></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500036000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP6'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP6'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP7'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP7'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP7></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),7,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP7></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500037000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP7'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP7'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP8'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP8'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP8></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),8,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP8></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500038000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP8'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP8'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:33;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>1ª" + LF
	chtm += "   via Agência – 2ª via Empregador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=458 colspan=18 valign=top style='width:343.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	/////TERMINA AQUI O 1o. FORM 
	
	////COMEÇA AQUI O 2o. FORM
	chtm += "<tr height = 30>" + LF
	chtm += "</tr>" + LF
	chtm += "  <![if !supportMisalignedColumns]>" + LF
	chtm += "  <tr height=0>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=45 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=11 style='border:none'></td>" + LF
	chtm += "   <td width=18 style='border:none'></td>" + LF
	chtm += "   <td width=104 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=37 style='border:none'></td>" + LF
	chtm += "   <td width=1 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <![endif]>" + LF
	chtm += " </table>" + LF

	chtm += ' <body lang=PT-BR style="tab-interval:35.4pt">'+ LF

	chtm += ' <div class=Section1>'+ LF

	chtm += ' <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0'+ LF
	chtm += '  style="border-collapse:collapse;mso-padding-alt:0cm 3.5pt 0cm 3.5pt">'+ LF
	chtm += '  <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid">'+ LF
	chtm += '   <td width=241 rowspan=3 valign=top style="width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt">'+ LF
	chtm += '   <h1><!--[if gte vml 1]><v:shapetype id="_x0000_t75" coordsize="21600,21600"'+ LF
	chtm += '    o:spt="75" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f"'+ LF
	chtm += '    stroked="f">'+ LF
	chtm += '    <v:stroke joinstyle="miter"/>'+ LF
	chtm += '    <v:formulas>'+ LF
	chtm += '     <v:f eqn="if lineDrawn pixelLineWidth 0"/>'+ LF
	chtm += '     <v:f eqn="sum @0 1 0"/>'+ LF
	chtm += '     <v:f eqn="sum 0 0 @1"/>'+ LF
	chtm += '     <v:f eqn="prod @2 1 2"/>'+ LF
	chtm += '     <v:f eqn="prod @3 21600 pixelWidth"/>'+ LF
	chtm += '     <v:f eqn="prod @3 21600 pixelHeight"/>'+ LF
	chtm += '     <v:f eqn="sum @0 0 1"/>'+ LF
	chtm += '     <v:f eqn="prod @6 1 2"/>'+ LF
	chtm += '     <v:f eqn="prod @7 21600 pixelWidth"/>'+ LF
	chtm += '     <v:f eqn="sum @8 21600 0"/>'+ LF
	chtm += '     <v:f eqn="prod @7 21600 pixelHeight"/>'+ LF
	chtm += '     <v:f eqn="sum @10 21600 0"/>'+ LF
	chtm += '    </v:formulas>'+ LF
	chtm += '    <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>'+ LF
	chtm += '    <o:lock v:ext="edit" aspectratio="t"/>'+ LF
	chtm += '   </v:shapetype><v:shape id="_x0000_i1025" type="#_x0000_t75" style="width:121.5pt;'+ LF
	chtm += '    height:39.75pt" fillcolor="window">'+ LF
	chtm += '    <v:imagedata src="PIShtm_arquivos/image001.wmz" o:title=""/>'+ LF
	chtm += '   </v:shape><![endif]--><![if !vml]><img width=162 height=53'+ LF
	chtm += '   src="PIShtm_arquivos/image002.gif" v:shapes="_x0000_i1025"><![endif]><span'+ LF
	chtm += "  style='font-size:10.0pt;font-family:'Arial Black',sans-serif'><o:p></o:p></span></h1>"+ LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>01 –" + LF
	chtm += "   Carimbo padronizado do CNPJ ou <o:p></o:p></span></p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><span" + LF
	chtm += "   style='mso-spacerun:yes'>       </span>Matrícula no Cadastro Específico do" + LF
	chtm += "   INSS-CEI</span><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoBodyText>Para uso exclusivo da CEF Carimbo da Agência receptora</p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Norma" + LF
	chtm += "   CSA/CIEF nº 047<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>                                                              " + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;    " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:2;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:3'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2><o:p>&nbsp;</o:p></h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DOCUMENTO DE CADASTRAMENTO</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DO TRABALHADOR NO PIS – DCT</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;       " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += " </table>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " <table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0" + LF
	chtm += "  style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;" + LF
	chtm += "  mso-padding-alt:0cm 3.5pt 0cm 3.5pt;mso-border-insideh:.5pt solid windowtext;" + LF
	chtm += "  mso-border-insidev:.5pt solid windowtext'>" + LF
	chtm += "  <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>02 – IDENTIFICAÇÃO</span></b></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-size:8.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   DO EMPREGADOR/SINDICATO<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "    <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:2'>" + LF
	chtm += "    <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "    border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CNPJ/CEI<o:p></o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "    <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "    border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "    font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Nome:<o:p></o:p></span></p>" + LF
	chtm += "    </td>" + LF
	chtm += "   </tr>" + LF
	chtm += "   <tr style='mso-yfti-irow:3'>" + LF
	chtm += "    <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "    border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "    style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "    mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "    style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "    style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "    name=CNPJCEI></a><![endif]>" + SM0->M0_CGC + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    name=CNPJCEI></a><![endif]>41.150.160/0005-28<!--[if gte mso 9]><xml>" + LF
	chtm += "     <w:data>FFFFFFFF000000000000070043004E0050004A004300450049000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "    </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "    style='mso-bookmark:CNPJCEI'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "    style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "    </td>" + LF
	chtm += "    <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "    border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "    mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "    padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "    <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "    normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "    'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Empregador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Empregador></a><![endif]><span style='mso-no-proof:yes'>RAVA EMBALAGENS" + LF
	chtm += "   INDUSTRIA E COMERCIO LTDA </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000000000000A0045006D007000720065006700610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Empregador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregador'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=156 colspan=5 valign=top style='width:116.9pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Endereço:<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=EndereçoEmpresa></a><![endif]><span style='mso-no-proof:yes'>" + SM0->M0_ENDCOB + " - " + SM0->M0_BAIRCOB + " - " + SM0->M0_CIDCOB + "</span><!--[if gte mso 9]><xml>" + LF
	chtm += "   name=EndereçoEmpresa></a><![endif]><span style='mso-no-proof:yes'>RUA SANTA CLARA, 336 Nª SRª DA CONCEIÇÃO - RENASCER - CABEDELO </span><!--[if gte mso 9]><xml>" + LF
	//RUA SANTA CLARA, 336 Nª SRª DA CONCEIÇÃO - RENASCER - CABEDELO 
	chtm += "    <w:data>FFFFFFFF0000000000000F0045006E006400650072006500E7006F0045006D00700072006500730061000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoEmpresa'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Telefone<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Fax<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>                                                      " + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;         " + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Telefone'><span style='mso-spacerun:yes'> </span>FORMTEXT" + LF
	chtm += "   <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefone'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=Telefone></a><![endif]>" + SM0->M0_TEL + "<!--[if gte mso 9]><xml>" + LF
	chtm += "   name=Telefone></a><![endif]>83 3048 1301<!--[if gte mso 9]><xml>" + LF
	//83 3048 1301
	chtm += "    <w:data>FFFFFFFF0000000000000800540065006C00650066006F006E0065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Telefone'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefone'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Telefax'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefax'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Telefax></a><![endif]><span style='mso-no-proof:yes'>83 3048 1302</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000000000000700540065006C0065006600610078000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Telefax'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Telefax'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:10'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:11;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>IDENTIFICAÇÃO DO TRABALHADOR<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:12;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:13;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>03" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:14;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Empregado'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregado'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Empregado></a><![endif]>"+ aDados[1,1] + "<!--[if gte mso 9]><xml>" + LF        //NOME FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF000000000000090045006D007000720065006700610064006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Empregado'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Empregado'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:15'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:16;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>04 –" + LF
	chtm += "   <span class=GramE>Data</span> de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 valign=top style='width:42.55pt;border:none;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>05 -" + LF
	chtm += "   Sexo<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 valign=top style='width:350.7pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>06" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> da" + LF
	chtm += "   Mãe<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:17;page-break-inside:avoid'>" + LF
	chtm += "   <td width=32 valign=top style='width:23.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Dia'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Dia'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Dia></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 7,2)  + " <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000200000003004400690061000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Dia'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Dia'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=32 valign=top style='width:23.9pt;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Mes'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mes'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Mes></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 5,2)  + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000200000003004D00650073000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Mes'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mes'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=64 colspan=2 valign=top style='width:47.85pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Ano'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Ano'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Ano></a><![endif]>" + Substr(Dtos(aDados[1,4]) , 1,4)  + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF000004000000030041006E006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Ano'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Ano'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 valign=top style='width:42.55pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Sexo'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Sexo'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Sexo></a><![endif]><span style='mso-no-proof:yes'>" + aDados[1,15] + " </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF00000100000004005300650078006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Sexo'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Sexo'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 valign=top style='width:350.7pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Mãe'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mãe'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Mãe></a><![endif]>" + aDados[1,17] + "<!--[if gte mso 9]><xml>" + LF     //NOME DA MÃE
	chtm += "    <w:data>FFFFFFFF00000000000003004D00E30065000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Mãe'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Mãe'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:18'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:19;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 valign=top style='width:272.85pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;           " + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>07" + LF
	chtm += "   – Município</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 valign=top style='width:55.8pt;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>08 –" + LF
	chtm += "   Cód. Nac.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Para" + LF
	chtm += "   Uso Exclusivo da CEF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:20;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 valign=top style='width:272.85pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=MunicípioNascimento></a><![endif]>" + aDados[1,18] + " <!--[if gte mso 9]><xml>" + LF  //município NASCIMENTO DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000013004D0075006E0069006300ED00700069006F004E0061007300630069006D0065006E0074006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:MunicípioNascimento'></span><span style='mso-element:" + LF
	chtm += "   field-end'></span><![endif]--><span style='mso-bookmark:MunicípioNascimento'></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=UFNascimento></a><![endif]>" + aDados[1,19] + "<!--[if gte mso 9]><xml>" + LF //UF DE NASCIMENTO DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF0000020000000C00550046004E0061007300630069006D0065006E0074006F000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFNascimento'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 valign=top style='width:55.8pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=Nacionalidade></a><![endif]><span style='mso-no-proof:yes'>" + aDados[1,20] + "</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF0000020000000D004E006100630069006F006E0061006C00690064006100640065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:Nacionalidade'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Solicitação" + LF
	chtm += "   atendida<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:21'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:22;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>09" + LF
	chtm += "   – CTPS - Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 valign=top style='width:63.75pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Série<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>10" + LF
	chtm += "   – CPF – Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Cont.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:23;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CTPSNúmero></a><![endif]>" + aDados[1,9] + " <!--[if gte mso 9]><xml>" + LF   //CTPS CARTEIRA PROFISSIONAL
	chtm += "    <w:data>FFFFFFFF0000000000000A0043005400500053004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSNúmero'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 valign=top style='width:63.75pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CTPSSérie></a><![endif]>" + aDados[1,10] + "<!--[if gte mso 9]><xml>" + LF  //SÉRIE CTPS
	chtm += "    <w:data>FFFFFFFF000000000000090043005400500053005300E9007200690065000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CTPSSérie'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=UFEmissão></a><![endif]>" + aDados[1,21] + "<!--[if gte mso 9]><xml>" + LF  //UF CTPS
	chtm += "    <w:data>FFFFFFFF00000200000009005500460045006D00690073007300E3006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEmissão'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CPF'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CPF'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=CPF></a><![endif]>" + Substr(aDados[1,14],1,9) + "<!--[if gte mso 9]><xml>" + LF      //CPF DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000003004300500046000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CPF'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CPF'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=DígitoCPF></a><![endif]>" + Substr(aDados[1,14],10,2) + "<!--[if gte mso 9]><xml>" + LF  //DIGITO DO CPF
	chtm += "    <w:data>FFFFFFFF00000200000009004400ED006700690074006F004300500046000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoCPF'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Preenchimento" + LF
	chtm += "   Incorreto<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:24'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:25;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 valign=top style='width:124.0pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>11" + LF
	chtm += "   – Carteira</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> de" + LF
	chtm += "   Identidade Nº<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 valign=top style='width:49.6pt;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Emissão<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'><p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	//" + Dtoc(aDados[1,25])+ "
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>12" + LF
	chtm += "   – Título de Eleitor – Número</span></span><span style='font-size:7.0pt;" + LF
	chtm += "   mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>DV<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Inscrição<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:26;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 valign=top style='width:124.0pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=IdentidadeNúmero></a><![endif]>" + aDados[1,16] + "<!--[if gte mso 9]><xml>" + LF    //RG DO FUNCIONÁRIO
	chtm += "    <w:data>FFFFFFFF00000000000010004900640065006E007400690064006100640065004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:IdentidadeNúmero'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 valign=top style='width:49.6pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=EstadoEmissor></a><![endif]>" + Dtoc(aDados[1,25]) + "<!--[if gte mso 9]><xml>" + LF   //dt EMISSÃO DO RG
	chtm += "    <w:data>FFFFFFFF0000000000000D00450073007400610064006F0045006D006900730073006F0072000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EstadoEmissor'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=TiítuloNúmero></a><![endif]>" + Substr(aDados[1,23],1,10) + "<!--[if gte mso 9]><xml>" + LF        //TITULO ELEITOR
	chtm += "    <w:data>FFFFFFFF0000000000000D0054006900ED00740075006C006F004E00FA006D00650072006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:TiítuloNúmero'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=DígitoTítulo></a><![endif]>" + Substr(aDados[1,23],11,2) + "<!--[if gte mso 9]><xml>" + LF   //ULTIMOS 2 DIGITOS DO TITULO ELEITOR
	chtm += "    <w:data>FFFFFFFF0000020000000C004400ED006700690074006F005400ED00740075006C006F000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:DígitoTítulo'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 style='width:123.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:27'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:28;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>13" + LF
	chtm += "   – Endereço</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:29;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h4><!--[if supportFields]><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'><![if !supportNestedAnchors]><a" + LF
	chtm += "   name=EndereçoTrabalhador></a><![endif]><span class=GramE>" + aDados[1,5] + " - " + aDados[1,24] + "</span>" + LF  //ENDEREÇO DO FUNCIONÁRIO
	chtm += "   <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>FFFFFFFF000000000000130045006E006400650072006500E7006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span><!--[if supportFields]><span style='mso-bookmark:" + LF
	chtm += "   EndereçoTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:EndereçoTrabalhador'></span></h4>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:30'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:31;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Bairro<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 valign=top style='width:212.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Município<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 valign=top style='width:1.0cm;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CEP<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:32;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=BairroTrabalhador></a><![endif]>" + SM0->M0_BAIRCOB + " <!--[if gte mso 9]><xml>" + LF  //BAIRRO EMPRESA
	chtm += "   name=BairroTrabalhador></a><![endif]>RENASCER<!--[if gte mso 9]><xml>" + LF  //BAIRRO EMPRESA
	chtm += "    <w:data>FFFFFFFF0000000000001100420061006900720072006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:BairroTrabalhador'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 valign=top style='width:212.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	//chtm += "   'Times New Roman'><![if !supportNestedAnchors]><a name=MunicípioTrabalhador></a><![endif]>" + SM0->M0_CIDCOB + "<!--[if gte mso 9]><xml>" + LF  //MUNICÍPIO DA EMPRESA
	chtm += "   'Times New Roman'><![if !supportNestedAnchors]><a name=MunicípioTrabalhador></a><![endif]>CABEDELO<!--[if gte mso 9]><xml>" + LF  //MUNICÍPIO DA EMPRESA
	chtm += "    <w:data>FFFFFFFF00000000000014004D0075006E0069006300ED00700069006F00540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:MunicípioTrabalhador'></span><span style='mso-element:" + LF
	chtm += "   field-end'></span><![endif]--><span style='mso-bookmark:MunicípioTrabalhador'></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 valign=top style='width:1.0cm;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>FORMTEXT <span style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=UFEndTrabalhador></a><![endif]><span style='mso-no-proof:yes'>" + SM0->M0_ESTCOB + "</span><!--[if gte mso 9]><xml>" + LF  //UF DA EMPRESA
	chtm += "   name=UFEndTrabalhador></a><![endif]><span style='mso-no-proof:yes'>PB</span><!--[if gte mso 9]><xml>" + LF  //UF DA EMPRESA
	chtm += "    <w:data>FFFFFFFF00000200000010005500460045006E006400540072006100620061006C006800610064006F0072000000000000000A004D0041004900DA005300430055004C0041005300000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:UFEndTrabalhador'></span><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP1'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP1'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP1></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),1,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP1></a><![endif]><span class=GramE>5</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500031000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP1'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP1'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP2'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP2'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP2></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),2,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP2></a><![endif]><span style='mso-no-proof:yes'>8</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500032000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP2'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP2'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP3'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP3'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP3></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),3,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP3></a><![endif]><span style='mso-no-proof:yes'>3</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500033000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP3'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP3'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP4'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP4'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP4></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),4,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP4></a><![endif]><span class=GramE>1</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500034000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP4'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP4'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP5'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP5'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP5></a><![endif]><span class=GramE>" + Substr(Alltrim(SM0->M0_CEPCOB),5,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP5></a><![endif]><span class=GramE>0</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500035000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP5'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP5'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP6'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP6'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP6></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),6,1) + "</span><!--[if gte mso 9]><xml>" + LF //CEP DA EMPRESA
	chtm += "   name=CEP6></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500036000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP6'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP6'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP7'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP7'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP7></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),7,1) + "</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "   name=CEP7></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF   //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500037000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP7'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP7'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-bookmark:CEP8'><span style='mso-spacerun:yes'> </span>FORMTEXT <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></span></b><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP8'><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><![if !supportNestedAnchors]><a" + LF
	//chtm += "   name=CEP8></a><![endif]><span style='mso-no-proof:yes'>" + Substr(Alltrim(SM0->M0_CEPCOB),8,1) + "</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "   name=CEP8></a><![endif]><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF  //CEP DA EMPRESA
	chtm += "    <w:data>FFFFFFFF000001000000040043004500500038000000000000000000000000000000000000000000000000000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b></span><!--[if supportFields]><span" + LF
	chtm += "   style='mso-bookmark:CEP8'></span><span style='mso-element:field-end'></span><![endif]--><span" + LF
	chtm += "   style='mso-bookmark:CEP8'></span><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:33;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>1ª" + LF
	chtm += "   via Agência – 2ª via Empregador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=458 colspan=18 valign=top style='width:343.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	
	////TERMINA AQUI O 2o. FORM
	/*
	chtm += "  <![if !supportMisalignedColumns]>" + LF
	chtm += "  <tr height=0>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=45 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=11 style='border:none'></td>" + LF
	chtm += "   <td width=18 style='border:none'></td>" + LF
	chtm += "   <td width=104 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=37 style='border:none'></td>" + LF
	chtm += "   <td width=1 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <![endif]>" + LF
	chtm += " </table>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += " <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt'><span style='mso-tab-count:13'>"+LF
	chtm += " </span>_<o:p></o:p></span></p>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0" + LF
	chtm += "  style='border-collapse:collapse;mso-padding-alt:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "  <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid'>" + LF
	chtm += "   <td width=241 rowspan=3 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h1><!--[if gte vml 1]><v:shape id=_x0000_i1026' type='#_x0000_t75' style='width:121.5pt;" + LF
	chtm += "    height:39.75pt' fillcolor='window>" + LF
	chtm += "    <v:imagedata src='PIShtm_arquivos/image001.wmz' o:title=''/>"+ LF
	chtm += "   </v:shape><![endif]--><![if !vml]><img width=162 height=53" + LF
	chtm += "   src='PIShtm_arquivos/image002.gif' v:shapes='_x0000_i1026'><![endif]><span" + LF
	chtm += "   style='font-size:10.0pt;font-family:'Arial Black','sans-serif''><o:p></o:p></span></h1>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>01 –" + LF
	chtm += "   Carimbo padronizado do CNPJ ou <o:p></o:p></span></p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><span" + LF
	chtm += "   style='mso-spacerun:yes'>        </span>Matrícula no Cadastro Específico do" + LF
	chtm += "   INSS-CEI</span><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoBodyText>Para uso exclusivo da CEF Carimbo da Agência receptora</p>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Norma" + LF
	chtm += "   CSA/CIEF nº 047<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:2;page-break-inside:avoid'>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:3'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2><o:p>&nbsp;</o:p></h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DOCUMENTO DE CADASTRAMENTO</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h2>DO TRABALHADOR NO PIS – DCT</h2>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=241 valign=top style='width:180.7pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=246 valign=top style='width:184.3pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=154 valign=top style='width:115.8pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += " </table>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " <table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0" + LF
	chtm += "  style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;" + LF
	chtm += "  mso-padding-alt:0cm 3.5pt 0cm 3.5pt;mso-border-insideh:.5pt solid windowtext;" + LF
	chtm += "  mso-border-insidev:.5pt solid windowtext'>" + LF
	chtm += "  <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>02 – IDENTIFICAÇÃO</span></b></span><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-size:8.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   DO EMPREGADOR/SINDICATO<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:1;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:2'>" + LF
	chtm += "   <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CNPJ/CEI<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Nome:<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:3'>" + LF
	chtm += "   <td width=156 colspan=5 valign=top style='width:116.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CNPJCEI \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>" + SM0->M0_CGC + "<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000800000043004E0050004A004300450049000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Empregador \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-no-proof:yes'>RAVA EMBALAGENS INDUSTRIA E" + LF
	chtm += "   COMERCIO LTDA </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000B00000045006D007000720065006700610064006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:4'>" + LF
	chtm += "   <td width=156 colspan=5 valign=top style='width:116.9pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=496 colspan=21 valign=top style='width:372.0pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:5;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Endereço:<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:6;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF EndereçoEmpresa \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>RUA" + LF
	chtm += "   SANTA CLARA, 336 Nª SRª DA CONCEIÇÃO - RENASCER - CABEDELO </span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000001000000045006E006400650072006500E7006F0045006D00700072006500730061000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:7'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:8;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Telefone<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Fax<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:8.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:9;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Telefone \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>83 3048 1301<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B020000000800000009000000540065006C00650066006F006E0065000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=132 colspan=7 valign=top style='width:99.25pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Telefax \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-no-proof:yes'>83 3048 1302</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B020000000800000008000000540065006C0065006600610078000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=392 colspan=15 valign=top style='width:294.0pt;border:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:10'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:11;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>IDENTIFICAÇÃO DO TRABALHADOR<o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:12;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:13;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 style='width:488.9pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>03" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:14;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Empregado \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>TALITA PRISCILA FELIX DA SILVA <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000A00000045006D007000720065006700610064006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:15'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>                                                                                                     " + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:16;page-break-inside:avoid'>" + LF
	chtm += "   <td width=128 colspan=4 style='width:95.65pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>04 –" + LF
	chtm += "   <span class=GramE>Data</span> de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 style='width:42.55pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>05 -" + LF
	chtm += "   Sexo<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 style='width:350.7pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>06" + LF
	chtm += "   – Nome</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> da" + LF
	chtm += "   Mãe<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:17;page-break-inside:avoid'>" + LF
	chtm += "   <td width=32 valign=top style='width:23.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Dia \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>28<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000040000004400690061000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>
	chtm += "   <td width=32 valign=top style='width:23.9pt;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Mes \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>02<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000040000004D00650073000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=64 colspan=2 valign=top style='width:47.85pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Ano \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>1992<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000400000041006E006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=57 colspan=3 valign=top style='width:42.55pt;border:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <h3><!--[if supportFields]><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Sexo \h <span style='mso-element:field-separator'></span><![endif]--><span" + LF
	chtm += "   style='font-weight:normal;mso-no-proof:yes'>F</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000050000005300650078006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--><!--[if supportFields]><span style='mso-element:field-end'></span><![endif]--></h3>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=468 colspan=19 valign=top style='width:350.7pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Mãe \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>MARINALVA DA SILVA <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000040000004D00E30065000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:18'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:19;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 style='width:272.85pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>07" + LF
	chtm += "   – Município</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>" + LF
	chtm += "   de Nascimento<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 style='width:55.8pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>08 –" + LF
	chtm += "   Cód. Nac.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 style='width:123.9pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Para" + LF
	chtm += "   Uso Exclusivo da CEF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:20;page-break-inside:avoid'>" + LF
	chtm += "   <td width=364 colspan=12 valign=top style='width:272.85pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF MunicípioNascimento \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>JOAO PESSOA <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000140000004D0075006E0069006300ED00700069006F004E0061007300630069006D0065006E0074006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF UFNascimento \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>PB<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000D000000550046004E0061007300630069006D0065006E0074006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=74 colspan=2 valign=top style='width:55.8pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF Nacionalidade \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-no-proof:yes'>10</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E0000004E006100630069006F006E0061006C00690064006100640065000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Solicitação" + LF
	chtm += "   atendida<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:21'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:22;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 style='width:81.5pt;border-top:none;border-left:solid windowtext 1.0pt;" + LF
	chtm += "   border-bottom:none;border-right:solid windowtext 1.0pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>09" + LF
	chtm += "   – CTPS - Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 style='width:63.75pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Série<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 style='width:147.95pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>10" + LF
	chtm += "   – CPF – Número</span></span><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Cont.<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 style='width:123.9pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:23;page-break-inside:avoid'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CTPSNúmero \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>5649669<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000B00000043005400500053004E00FA006D00650072006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=85 colspan=5 valign=top style='width:63.75pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CTPSSérie \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>0030<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000A00000043005400500053005300E9007200690065000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 valign=top style='width:1.0cm;border-top:none;border-left:none;" + LF
	chtm += "   border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF UFEmissão \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>PB<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000A0000005500460045006D00690073007300E3006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CPF \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>087358934<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000040000004300500046000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF DígitoCPF \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>35<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000A0000004400ED006700690074006F004300500046000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=28 valign=top style='width:21.25pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 valign=top style='width:102.65pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Preenchimento" + LF
	chtm += "   Incorreto<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:24'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:25;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 style='width:124.0pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>11" + LF
	chtm += "   – Carteira</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> de" + LF
	chtm += "   Identidade Nº<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 style='width:49.6pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Emissão<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 style='width:147.95pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>12" + LF
	chtm += "   – Título de Eleitor – Número</span></span><span style='font-size:7.0pt;" + LF
	chtm += "   mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 style='width:27.45pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>DV<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 style='width:123.9pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Inscrição<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:26;page-break-inside:avoid'>" + LF
	chtm += "   <td width=165 colspan=6 valign=top style='width:124.0pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF IdentidadeNúmero \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>3522643<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000110000004900640065006E007400690064006100640065004E00FA006D00650072006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=66 colspan=3 valign=top style='width:49.6pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF EstadoEmissor \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>SSP<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E000000450073007400610064006F0045006D006900730073006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 valign=top style='width:8.0pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=197 colspan=4 valign=top style='width:147.95pt;border-top:none;" + LF
	chtm += "   border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF TiítuloNúmero \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>0402957712<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E00000054006900ED00740075006C006F004E00FA006D00650072006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=37 valign=top style='width:27.45pt;border-top:none;border-left:" + LF
	chtm += "   none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF DígitoTítulo \h <span style='mso-element:" + LF
	chtm += "   field-separator'></span></span></b><![endif]--><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'>01<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000D0000004400ED006700690074006F005400ED00740075006C006F000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=11 colspan=2 valign=top style='width:8.0pt;border:none;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=165 colspan=9 valign=top style='width:123.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span" + LF
	chtm += "   style='font-size:7.0pt;mso-bidi-font-size:10.0pt;font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:27'>" + LF
	chtm += "   <td width=109 colspan=3 valign=top style='width:81.5pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=543 colspan=23 valign=top style='width:407.4pt;border:none;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:28;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span class=GramE><span style='font-size:7.0pt;mso-bidi-font-size:" + LF
	chtm += "   10.0pt;font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>13" + LF
	chtm += "   – Endereço</span></span><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'> do" + LF
	chtm += "   Trabalhador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:29;page-break-inside:avoid'>" + LF
	chtm += "   <td width=652 colspan=26 valign=top style='width:488.9pt;border:solid windowtext 1.0pt;" + LF
	chtm += "   border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF EndereçoTrabalhador \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]-->RUA SANTO <span" + LF
	chtm += "   class=GramE>EXPEDITO ,</span> 426 QD 21 LT 06<b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000001400000045006E006400650072006500E7006F00540072006100620061006C006800610064006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:30'>" + LF
	chtm += "   <td width=128 colspan=4 valign=top style='width:95.65pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=524 colspan=22 valign=top style='width:393.25pt;border:none;" + LF
	chtm += "   mso-border-top-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:2.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:31;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 style='width:145.25pt;border-top:none;border-left:" + LF
	chtm += "   solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Bairro<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 style='width:212.65pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>Município<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 style='width:1.0cm;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>UF<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=137 colspan=8 style='width:102.65pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:7.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>CEP<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:32;page-break-inside:avoid'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border-top:none;" + LF
	chtm += "   border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF BairroTrabalhador \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>RENASCER <!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B020000000800000012000000420061006900720072006F00540072006100620061006C006800610064006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:              " + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=284 colspan=8 valign=top style='width:212.65pt;border:none;" + LF
	chtm += "   border-right:solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;" + LF
	chtm += "   mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF MunicípioTrabalhador \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'>CABEDELO<!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000150000004D0075006E0069006300ED00700069006F00540072006100620061006C006800610064006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=38 colspan=2 valign=top style='width:1.0cm;border:none;border-right:" + LF
	chtm += "   solid windowtext 1.0pt;mso-border-left-alt:solid windowtext .5pt;mso-border-left-alt:" + LF
	chtm += "   solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:" + LF
	chtm += "   0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF UFEndTrabalhador \h <span" + LF
	chtm += "   style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>PB</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B0200000008000000110000005500460045006E006400540072006100620061006C006800610064006F0072000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP1 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span class=GramE>5</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500031000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP2 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>8</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500032000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP3 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>3</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500033000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP4 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span class=GramE>1</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500034000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP5 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span class=GramE>0</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500035000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.8pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP6 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500036000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';       " + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP7 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500037000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=17 valign=top style='width:12.85pt;border:none;border-right:solid windowtext 1.0pt;" + LF
	chtm += "   mso-border-right-alt:solid windowtext .5pt;padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal align=center style='text-align:center'><!--[if supportFields]><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-element:field-begin'></span><span" + LF
	chtm += "   style='mso-spacerun:yes'> </span>REF CEP8 \h <span style='mso-element:field-separator'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><span style='mso-no-proof:yes'>0</span><!--[if gte mso 9]><xml>" + LF
	chtm += "    <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000500000043004500500038000000</w:data>" + LF
	chtm += "   </xml><![endif]--></span></b><!--[if supportFields]><b style='mso-bidi-font-weight:" + LF
	chtm += "   normal'><span style='font-family:'Arial','sans-serif';mso-bidi-font-family:" + LF
	chtm += "   'Times New Roman'><span style='mso-element:field-end'></span></span></b><![endif]--><b" + LF
	chtm += "   style='mso-bidi-font-weight:normal'><span style='font-family:'Arial','sans-serif';" + LF
	chtm += "   mso-bidi-font-family:'Times New Roman'><o:p></o:p></span></b></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <tr style='mso-yfti-irow:33;mso-yfti-lastrow:yes'>" + LF
	chtm += "   <td width=194 colspan=8 valign=top style='width:145.25pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'>1ª" + LF
	chtm += "   via Agência – 2ª via Empregador<o:p></o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "   <td width=458 colspan=18 valign=top style='width:343.65pt;border:none;" + LF
	chtm += "   border-top:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .5pt;" + LF
	chtm += "   padding:0cm 3.5pt 0cm 3.5pt'>" + LF
	chtm += "   <p class=MsoNormal><span style='font-size:4.0pt;mso-bidi-font-size:10.0pt;" + LF
	chtm += "   font-family:'Arial','sans-serif';mso-bidi-font-family:'Times New Roman'><o:p>&nbsp;</o:p></span></p>" + LF
	chtm += "   </td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <![if !supportMisalignedColumns]>" + LF
	chtm += "  <tr height=0>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=32 style='border:none'></td>" + LF
	chtm += "   <td width=45 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=19 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=11 style='border:none'></td>" + LF
	chtm += "   <td width=18 style='border:none'></td>" + LF
	chtm += "   <td width=104 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=38 style='border:none'></td>" + LF
	chtm += "   <td width=37 style='border:none'></td>" + LF
	chtm += "   <td width=1 style='border:none'></td>" + LF
	chtm += "   <td width=9 style='border:none'></td>" + LF
	chtm += "   <td width=28 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "   <td width=17 style='border:none'></td>" + LF
	chtm += "  </tr>" + LF
	chtm += "  <![endif]>" + LF
	chtm += " </table>" + LF

	chtm += " <p class=MsoNormal><span style='font-size:6.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>" + LF

	chtm += " </div>" + LF
    */
	chtm += " </body>" + LF

	chtm += " </html>" + LF

Elseif nOpc = 4    //DECLARAÇÃO DO VALE-TRANSPORTE
	
	chtm := "	<html xmlns:o='urn:schemas-microsoft-com:office:office' " + LF
	chtm += "xmlns:w='urn:schemas-microsoft-com:office:word' " + LF
	chtm += "xmlns='http://www.w3.org/TR/REC-html40'> " + LF

	chtm += "<head> " + LF
	chtm += "<meta http-equiv=Content-Type content='text/html; charset=windows-1252'> " + LF
	chtm += "<meta name=ProgId content=Word.Document> " + LF
	chtm += "<meta name=Generator content='Microsoft Word 11'> " + LF
	chtm += "<meta name=Originator content='Microsoft Word 11'> " + LF
	chtm += "<link rel=File-List href='VT_files/filelist.xml'> " + LF
	chtm += "<title>DECLARAÇÃO DE BENEFICIÁRIO</title> " + LF
	chtm += "<!--[if gte mso 9]><xml> " + LF
	chtm += " <o:DocumentProperties> " + LF
	chtm += "  <o:Author>karla.barreto</o:Author> " + LF
	chtm += "  <o:LastAuthor>Flavia Rocha</o:LastAuthor> " + LF
	chtm += "  <o:Revision>2</o:Revision> " + LF
	chtm += "  <o:LastPrinted>2012-01-25T14:48:00Z</o:LastPrinted> " + LF
	chtm += "  <o:Created>2012-03-28T20:40:00Z</o:Created> " + LF
	chtm += "  <o:LastSaved>2012-03-28T20:40:00Z</o:LastSaved> " + LF
	chtm += "  <o:Pages>1</o:Pages> " + LF
	chtm += "  <o:Words>208</o:Words> " + LF
	chtm += "  <o:Characters>1128</o:Characters> " + LF
	chtm += "  <o:Company>Rava</o:Company> " + LF
	chtm += "  <o:Lines>9</o:Lines> " + LF
	chtm += "  <o:Paragraphs>2</o:Paragraphs> " + LF
	chtm += "  <o:CharactersWithSpaces>1334</o:CharactersWithSpaces> " + LF
	chtm += "  <o:Version>11.5606</o:Version> " + LF
	chtm += " </o:DocumentProperties> " + LF
	chtm += "</xml><![endif]--><!--[if gte mso 9]><xml> " + LF
	chtm += " <w:WordDocument> " + LF
	chtm += "  <w:SpellingState>Clean</w:SpellingState> " + LF
	chtm += "  <w:GrammarState>Clean</w:GrammarState> " + LF
	chtm += "  <w:HyphenationZone>21</w:HyphenationZone> " + LF
	chtm += "  <w:PunctuationKerning/> " + LF
	chtm += "  <w:ValidateAgainstSchemas/> " + LF
	chtm += "  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid> " + LF
	chtm += "  <w:IgnoreMixedContent>false</w:IgnoreMixedContent> " + LF
	chtm += "  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText> " + LF
	chtm += "  <w:Compatibility> " + LF
	chtm += "   <w:BreakWrappedTables/> " + LF
	chtm += "   <w:SnapToGridInCell/> " + LF
	chtm += "   <w:WrapTextWithPunct/> " + LF
	chtm += "   <w:UseAsianBreakRules/> " + LF
	chtm += "   <w:DontGrowAutofit/> " + LF
	chtm += "  </w:Compatibility> " + LF
	chtm += "  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> " + LF
	chtm += " </w:WordDocument> " + LF
	chtm += "</xml><![endif]--><!--[if gte mso 9]><xml> " + LF
	chtm += " <w:LatentStyles DefLockedState='false' LatentStyleCount='156'> " + LF
	chtm += " </w:LatentStyles> " + LF
	chtm += "</xml><![endif]--> " + LF
	chtm += "<style> " + LF
	chtm += "<!-- " + LF
	chtm += "  Font Definitions  " + LF
	chtm += " @font-face " + LF
	chtm += "	{font-family:Wingdings; " + LF
	chtm += "	panose-1:5 0 0 0 0 0 0 0 0 0; " + LF
	chtm += "	mso-font-charset:2; " + LF
	chtm += "	mso-generic-font-family:auto; " + LF
	chtm += "	mso-font-pitch:variable; " + LF
	chtm += "	mso-font-signature:0 268435456 0 0 -2147483648 0;} " + LF
	chtm += "  Style Definitions  " + LF
	chtm += " p.MsoNormal, li.MsoNormal, div.MsoNormal " + LF
	chtm += "	{mso-style-parent:''; " + LF
	chtm += "	margin:0cm; " + LF
	chtm += "	margin-bottom:.0001pt; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	font-size:10.0pt; " + LF
	chtm += "	font-family:'Times New Roman'; " + LF
	chtm += "	mso-fareast-font-family:'Times New Roman';} " + LF
	chtm += "h3 " + LF
	chtm += "	{mso-style-next:Normal; " + LF
	chtm += "	margin:0cm; " + LF
	chtm += "	margin-bottom:.0001pt; " + LF
	chtm += "	text-align:justify; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	page-break-after:avoid; " + LF
	chtm += "	mso-outline-level:3; " + LF
	chtm += "	font-size:12.0pt; " + LF
	chtm += "	mso-bidi-font-size:10.0pt; " + LF
	chtm += "	font-family:'Times New Roman'; " + LF
	chtm += "	mso-bidi-font-weight:normal;} " + LF
	chtm += "h4 " + LF
	chtm += "	{mso-style-next:Normal; " + LF
	chtm += "	margin-top:12.0pt; " + LF
	chtm += "	margin-right:0cm; " + LF
	chtm += "	margin-bottom:3.0pt; " + LF
	chtm += "	margin-left:0cm; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	page-break-after:avoid; " + LF
	chtm += "	mso-outline-level:4; " + LF
	chtm += "	font-size:14.0pt; " + LF
	chtm += "	font-family:'Times New Roman';} " + LF
	chtm += "h5 " + LF
	chtm += "	{mso-style-next:Normal; " + LF
	chtm += "	margin-top:12.0pt; " + LF
	chtm += "	margin-right:0cm; " + LF
	chtm += "	margin-bottom:3.0pt; " + LF
	chtm += "	margin-left:0cm; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	mso-outline-level:5; " + LF
	chtm += "	font-size:13.0pt; " + LF
	chtm += "	font-family:'Times New Roman'; " + LF
	chtm += "	font-style:italic;} " + LF
	chtm += "p.MsoHeading8, li.MsoHeading8, div.MsoHeading8 " + LF
	chtm += "	{mso-style-next:Normal; " + LF
	chtm += "	margin-top:12.0pt; " + LF
	chtm += "	margin-right:0cm; " + LF
	chtm += "	margin-bottom:3.0pt; " + LF
	chtm += "	margin-left:0cm; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	mso-outline-level:8; " + LF
	chtm += "	font-size:12.0pt; " + LF
	chtm += "	font-family:'Times New Roman'; " + LF
	chtm += "	mso-fareast-font-family:'Times New Roman'; " + LF
	chtm += "	font-style:italic;} " + LF
	chtm += "@page Section1 " + LF
	chtm += "	{size:595.3pt 841.9pt; " + LF
	chtm += "	margin:2.0cm 2.0cm 42.55pt 3.0cm; " + LF
	chtm += "	mso-header-margin:35.45pt; " + LF
	chtm += "	mso-footer-margin:35.45pt; " + LF
	chtm += "	mso-paper-source:0;} " + LF
	chtm += "div.Section1 " + LF
	chtm += "	{page:Section1;} " + LF
	chtm += "  List Definitions  " + LF
	chtm += " @list l0 " + LF
	chtm += "	{mso-list-id:385185132; " + LF
	chtm += "	mso-list-type:hybrid; " + LF
	chtm += "	mso-list-template-ids:86278064 68550657 68550659 68550661 68550657 68550659 68550661 68550657 68550659 68550661;} " + LF
	chtm += "@list l0:level1 " + LF
	chtm += "	{mso-level-number-format:bullet; " + LF
	chtm += "	mso-level-text:\F0B7; " + LF
	chtm += "	mso-level-tab-stop:88.8pt; " + LF
	chtm += "	mso-level-number-position:left; " + LF
	chtm += "	margin-left:88.8pt; " + LF
	chtm += "	text-indent:-18.0pt; " + LF
	chtm += "	font-family:Symbol;} " + LF
	chtm += "@list l1 " + LF
	chtm += "	{mso-list-id:1570768852; " + LF
	chtm += "	mso-list-type:hybrid; " + LF
	chtm += "	mso-list-template-ids:-1368590494 68550671 68550657 68550683 68550671 68550681 68550683 68550671 68550681 68550683;} " + LF
	chtm += "@list l1:level1 " + LF
	chtm += "	{mso-level-tab-stop:36.0pt; " + LF
	chtm += "	mso-level-number-position:left; " + LF
	chtm += "	text-indent:-18.0pt;} " + LF
	chtm += "@list l1:level2 " + LF
	chtm += "	{mso-level-number-format:bullet; " + LF
	chtm += "	mso-level-text:\F0B7; " + LF
	chtm += "	mso-level-tab-stop:72.0pt; " + LF
	chtm += "	mso-level-number-position:left; " + LF
	chtm += "	text-indent:-18.0pt; " + LF
	chtm += "	font-family:Symbol;} " + LF
	chtm += "ol " + LF
	chtm += "	{margin-bottom:0cm;} " + LF
	chtm += "ul " + LF
	chtm += "	{margin-bottom:0cm;} " + LF
	chtm += "--> " + LF
	chtm += "</style> " + LF
	chtm += "<!--[if gte mso 10]> " + LF
	chtm += "<style> " + LF
	chtm += "  Style Definitions  " + LF
	chtm += " table.MsoNormalTable " + LF
	chtm += "	{mso-style-name:'Table Normal'; " + LF
	chtm += "	mso-tstyle-rowband-size:0; " + LF
	chtm += "	mso-tstyle-colband-size:0; " + LF
	chtm += "	mso-style-noshow:yes; " + LF
	chtm += "	mso-style-parent:''; " + LF
	chtm += "	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; " + LF
	chtm += "	mso-para-margin:0cm; " + LF
	chtm += "	mso-para-margin-bottom:.0001pt; " + LF
	chtm += "	mso-pagination:widow-orphan; " + LF
	chtm += "	font-size:10.0pt; " + LF
	chtm += "	font-family:'Times New Roman'; " + LF
	chtm += "	mso-ansi-language:#0400; " + LF
	chtm += "	mso-fareast-language:#0400; " + LF
	chtm += "	mso-bidi-language:#0400;} " + LF
	chtm += "</style> " + LF
	chtm += "<![endif]--> " + LF
	chtm += "</head> " + LF

	chtm += "<body lang=PT-BR style='tab-interval:35.4pt'> " + LF
	chtm += "<div class=Section1> " + LF
	chtm += "<h3><u><o:p><span style='text-decoration:none'>&nbsp;</span></o:p></u></h3> " + LF
	chtm += "<h3 align=center style='text-align:center'><u><o:p><span style='text-decoration: " + LF
	chtm += " none'>&nbsp;</span></o:p></u></h3> " + LF
	chtm += "<h3 align=center style='text-align:center'><span style='font-size:14.0pt'>*** DECLARAÇÃO " + LF
	chtm += "DE BENEFICIÁRIO ***<o:p></o:p></span></h3> " + LF
	chtm += "<h3 align=center style='text-align:center'><span style='font-size:14.0pt'>VALE " + LF
	chtm += "– TRANSPORTE<o:p></o:p></span></h3> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><b style='mso-bidi-font-weight: " + LF
	chtm += "normal'><span style='font-size:14.0pt'><o:p>&nbsp;</o:p></span></b></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><b style='mso-bidi-font-weight: " + LF
	chtm += "normal'><span style='font-size:12.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></b></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><b style='mso-bidi-font-weight: " + LF
	chtm += "normal'><span style='font-size:12.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></b></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>(<span style='mso-tab-count:1'>           </span>) " + LF
	chtm += "Opto pela Utilização do Vale Transporte<o:p></o:p></span></p>                        " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>(<span style='mso-tab-count:1'>           </span>) " + LF
	chtm += "Não opto pela utilização do Vale – Transporte<o:p></o:p></span></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	//Aadd(aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso, cMat, cCPF } )
	///                  1         2         3         4           5       6        7      8       9        10        11          12       13     14
	chtm += "mso-bidi-font-size:10.0pt'>Eu, " + aDados[1,1] + " </span><!--[if supportFields]><span " + LF
	chtm += "style='font-size:12.0pt;mso-bidi-font-size:10.0pt'><span style='mso-element: " + LF
	chtm += "field-begin'></span><span style='mso-spacerun:yes'> </span>DOCVARIABLE<span " + LF
	chtm += "style='mso-spacerun:yes'>  </span>GPE_NOME<span style='mso-spacerun:yes'>  " + LF
	chtm += "</span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span " + LF
	chtm += "style='font-size:12.0pt;mso-bidi-font-size:10.0pt'><span style='mso-element: " + LF
	chtm += "field-end'></span></span><![endif]--><span style='font-size:12.0pt;mso-bidi-font-size: " + LF
	chtm += "10.0pt'>, declaro para efeitos do beneficio do vale – transporte que:<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<ol style='margin-top:0cm' start=1 type=1> " + LF
	chtm += " <li class=MsoNormal style='text-align:justify;mso-list:l1 level1 lfo1; " + LF
	chtm += "     tab-stops:list 36.0pt'><span style='font-size:12.0pt;mso-bidi-font-size: " + LF
	chtm += "     10.0pt'>Meu endereço residencial é: <b style='mso-bidi-font-weight:normal'>" + aDados[1,5] + " "+ LF
	chtm += "     – Bairro: " + aDados[1,6] + " <span style='mso-spacerun:yes'>  </span>– <span " + LF
	chtm += "     style='mso-spacerun:yes'> </span>Cidade: " + aDados[1,7] + "<o:p></o:p></b></span></li> " + LF
	chtm += "</ol> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><b style='mso-bidi-font-weight: " + LF
	chtm += "normal'><span style='font-size:12.0pt;mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></b></p> " + LF
                                                                                                                     
	chtm += "<ol style='margin-top:0cm' start=2 type=1> " + LF
	chtm += " <li class=MsoNormal style='text-align:justify;mso-list:l1 level1 lfo1; " + LF
	chtm += "     tab-stops:list 36.0pt'><span style='font-size:12.0pt;mso-bidi-font-size: " + LF
	chtm += "     10.0pt'>Os meios de transporte coletivo, público e regular que a meu ver, " + LF
	chtm += "     são os mais adequados para os meus deslocamentos:<o:p></o:p></span></li> " + LF
	chtm += "</ol> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<ol style='margin-top:0cm' start=2 type=1> " + LF
	chtm += " <ul style='margin-top:0cm' type=disc> " + LF
	chtm += "  <li class=MsoNormal style='text-align:justify;mso-list:l1 level2 lfo1; " + LF
	chtm += "      tab-stops:list 72.0pt'><span style='font-size:12.0pt;mso-bidi-font-size: " + LF
	chtm += "      10.0pt'>De minha residência para o local de trabalho:<o:p></o:p></span></li> " + LF
	chtm += " </ul> " + LF
	chtm += "</ol> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>______________________________________________________________________<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<ol style='margin-top:0cm' start=2 type=1> " + LF
	chtm += " <ul style='margin-top:0cm' type=disc> " + LF
	chtm += "  <li class=MsoNormal style='text-align:justify;mso-list:l1 level2 lfo1; " + LF
	chtm += "      tab-stops:list 72.0pt'><span style='font-size:12.0pt;mso-bidi-font-size: " + LF
	chtm += "      10.0pt'>Do local de trabalho para minha residência:<o:p></o:p></span></li> " + LF
	chtm += " </ul> " + LF
	chtm += "</ol> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>______________________________________________________________________<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>Comprometo-me a atualizar as informações acima " + LF
	chtm += "sempre que ocorrerem alterações, e a utilizar os vales - transportes que me " + LF
	chtm += "forem concedidos exclusivamente no percurso indicado.<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>Estou ciente de que a declaração inexata que induza " + LF
	chtm += "o empregado em erro ou uso indevido dos vales transportes, configura justa " + LF
	chtm += "causa para rescisão do contrato de trabalho.<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><span style='mso-tab-count:2'>                        </span><o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt;                                          " + LF
	chtm += "mso-bidi-font-size:10.0pt'><span style='mso-tab-count:2'>                        </span><o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'>Declaração Recebida,<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt; " + LF
	chtm += "mso-bidi-font-size:10.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF
	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'>RAVA " + LF
	chtm += "Embalagens Ind. Comércio Ltda.<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'>________________________________ " + LF
	chtm += "<span style='mso-tab-count:1'>      </span>_____________________________________<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoHeading8 style='margin:0cm;margin-bottom:.0001pt;text-align:justify'><span " + LF
	chtm += "style='font-size:11.0pt;font-style:normal;mso-bidi-font-style:italic'><span " + LF
	chtm += "style='mso-spacerun:yes'> </span>LUIZA HELENA FREIRE MARTINS <span " + LF
	chtm += "style='mso-spacerun:yes'>       </span><span style='mso-spacerun:yes'> </span><span " + LF
	chtm += "style='mso-spacerun:yes'>   </span><span style='mso-spacerun:yes'> </span>EMPREGADO<o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoHeading8 style='margin:0cm;margin-bottom:.0001pt'><span " + LF
	chtm += "style='font-style:normal;mso-bidi-font-style:italic'>GERENTE DE RH</span><span " + LF
	chtm += "style='mso-spacerun:yes'>               </span><span " + LF
	chtm += "style='mso-spacerun:yes'>                        </span><span " + LF
	chtm += "style='mso-spacerun:yes'> </span><span style='font-size:11.0pt;font-style:normal; " + LF
	chtm += "mso-bidi-font-style:italic'><o:p></o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<p class=MsoNormal style='text-align:justify'><span style='font-size:12.0pt'><o:p>&nbsp;</o:p></span></p> " + LF

	chtm += "<h4 align=center style='text-align:center'><span style='font-size:12.0pt; " + LF
	chtm += "font-weight:normal;mso-bidi-font-weight:bold'>Cabedelo/ PB, " + aDados[1,12] + "</span><span " + LF
	chtm += "style='font-size:12.0pt'><o:p></o:p></span></h4> " + LF

	chtm += "</div> " + LF

	chtm += "</body> " + LF

	chtm += "</html> " + LF
	
Elseif nOpc = 5

	chtm := '<html xmlns:o="urn:schemas-microsoft-com:office:office" ' + LF
	chtm += 'xmlns:w="urn:schemas-microsoft-com:office:word" ' + LF
	chtm += 'xmlns="http://www.w3.org/TR/REC-html40"> ' + LF

	chtm += '<head> ' + LF
	chtm += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"> ' + LF
	chtm += '<meta name=ProgId content=Word.Document> ' + LF
	chtm += '<meta name=Generator content="Microsoft Word 11"> ' + LF
	chtm += '<meta name=Originator content="Microsoft Word 11"> ' + LF
	chtm += '<link rel=File-List href="TERMO%20DE%20RESPONSABILIDADE_files/filelist.xml"> ' + LF
	chtm += '<title>*** TERMO DE RESPONSABILIDADE ***</title> ' + LF
	chtm += '<!--[if gte mso 9]><xml> ' + LF
	chtm += ' <o:DocumentProperties> ' + LF
	chtm += '  <o:Author>karla.barreto</o:Author> ' + LF
	chtm += '  <o:LastAuthor>Flavia Rocha</o:LastAuthor> ' + LF
	chtm += '  <o:Revision>2</o:Revision> ' + LF
	chtm += '  <o:TotalTime>249</o:TotalTime> ' + LF
	chtm += '  <o:LastPrinted>2012-01-11T18:45:00Z</o:LastPrinted> ' + LF
	chtm += '  <o:Created>2012-04-30T19:07:00Z</o:Created> ' + LF
	chtm += '  <o:LastSaved>2012-04-30T19:07:00Z</o:LastSaved> ' + LF
	chtm += '  <o:Pages>1</o:Pages> ' + LF
	chtm += '  <o:Words>287</o:Words> ' + LF
	chtm += '  <o:Characters>1554</o:Characters> ' + LF
	chtm += '  <o:Company>Rava</o:Company> ' + LF
	chtm += '  <o:Lines>12</o:Lines> ' + LF
	chtm += '  <o:Paragraphs>3</o:Paragraphs> ' + LF
	chtm += '  <o:CharactersWithSpaces>1838</o:CharactersWithSpaces> ' + LF
	chtm += '  <o:Version>11.5606</o:Version> ' + LF
	chtm += ' </o:DocumentProperties> ' + LF
	chtm += '</xml><![endif]--><!--[if gte mso 9]><xml> ' + LF
	chtm += ' <w:WordDocument> ' + LF
	chtm += '  <w:HyphenationZone>21</w:HyphenationZone> ' + LF
	chtm += '  <w:PunctuationKerning/> ' + LF
	chtm += '  <w:ValidateAgainstSchemas/> ' + LF
	chtm += '  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid> ' + LF
	chtm += '  <w:IgnoreMixedContent>false</w:IgnoreMixedContent> ' + LF
	chtm += '  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText> ' + LF
	chtm += '  <w:Compatibility>                                                       ' + LF
	chtm += '   <w:BreakWrappedTables/> ' + LF
	chtm += '   <w:SnapToGridInCell/> ' + LF
	chtm += '   <w:WrapTextWithPunct/> ' + LF
	chtm += '   <w:UseAsianBreakRules/> ' + LF
	chtm += '   <w:DontGrowAutofit/> ' + LF
	chtm += '  </w:Compatibility> ' + LF
	chtm += '  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> ' + LF
	chtm += ' </w:WordDocument> ' + LF
	chtm += '</xml><![endif]--><!--[if gte mso 9]><xml> ' + LF
	chtm += ' <w:LatentStyles DefLockedState="false" LatentStyleCount="156"> ' + LF
	chtm += ' </w:LatentStyles> ' + LF
	chtm += '</xml><![endif]--> ' + LF
	chtm += '<style> ' + LF
	chtm += '<!-- ' + LF
	chtm += ' /* Style Definitions */ ' + LF
	chtm += ' p.MsoNormal, li.MsoNormal, div.MsoNormal ' + LF
	chtm += '	{mso-style-parent:""; ' + LF
	chtm += '	margin:0cm; ' + LF
	chtm += '	margin-bottom:.0001pt; ' + LF
	chtm += '	mso-pagination:widow-orphan; ' + LF
	chtm += '	font-size:10.0pt; ' + LF
	chtm += '	font-family:"Times New Roman"; ' + LF
	chtm += '	mso-fareast-font-family:"Times New Roman";} ' + LF
	chtm += 'h1 ' + LF
	chtm += '	{mso-style-next:Normal; ' + LF
	chtm += '	margin:0cm; ' + LF
	chtm += '	margin-bottom:.0001pt; ' + LF
	chtm += '	text-align:justify; ' + LF
	chtm += '	mso-pagination:widow-orphan; ' + LF
	chtm += '	page-break-after:avoid; ' + LF
	chtm += '	mso-outline-level:1; ' + LF
	chtm += '	font-size:18.0pt; ' + LF
	chtm += '	mso-bidi-font-size:10.0pt; ' + LF
	chtm += '	font-family:"Times New Roman"; ' + LF
	chtm += '	mso-font-kerning:0pt; ' + LF
	chtm += '	mso-bidi-font-weight:normal;} ' + LF
	chtm += '@page Section1 ' + LF
	chtm += '	{size:595.3pt 841.9pt; ' + LF
	chtm += '	margin:70.85pt 64.3pt 70.85pt 3.0cm; ' + LF
	chtm += '	mso-header-margin:35.4pt; ' + LF
	chtm += '	mso-footer-margin:35.4pt; ' + LF
	chtm += '	mso-paper-source:0;} ' + LF
	chtm += 'div.Section1 ' + LF
	chtm += '	{page:Section1;} ' + LF
	chtm += '--> ' + LF
	chtm += '</style> ' + LF
	chtm += '<!--[if gte mso 10]> ' + LF
	chtm += '<style> ' + LF
	chtm += ' /* Style Definitions */ ' + LF
	chtm += ' table.MsoNormalTable ' + LF
	chtm += '	{mso-style-name:"Table Normal"; ' + LF
	chtm += '	mso-tstyle-rowband-size:0; ' + LF
	chtm += '	mso-tstyle-colband-size:0; ' + LF
	chtm += '	mso-style-noshow:yes; ' + LF
	chtm += '	mso-style-parent:""; ' + LF
	chtm += '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; ' + LF
	chtm += '	mso-para-margin:0cm; ' + LF
	chtm += '	mso-para-margin-bottom:.0001pt; ' + LF
	chtm += '	mso-pagination:widow-orphan; ' + LF
	chtm += '	font-size:10.0pt; ' + LF
	chtm += '	font-family:"Times New Roman"; ' + LF
	chtm += '	mso-ansi-language:#0400; ' + LF
	chtm += '	mso-fareast-language:#0400; ' + LF
	chtm += '	mso-bidi-language:#0400;} ' + LF
	chtm += '</style> ' + LF
	chtm += '<![endif]--> ' + LF
	chtm += '</head> ' + LF

	chtm += '<body lang=PT-BR style="tab-interval:35.4pt"> ' + LF
	chtm += '<div class=Section1> ' + LF
	chtm += '<h1 align=center style="text-align:center"><span style="font-size:14.0pt; ' + LF
	chtm += 'mso-bidi-font-size:10.0pt">*** TERMO DE RESPONSABILIDADE ***<o:p></o:p></span></h1> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><b style="mso-bidi-font-weight: ' + LF
	chtm += 'normal"><u><o:p><span style="text-decoration:none">&nbsp;</span></o:p></u></b></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><b style="mso-bidi-font-weight: ' + LF
	chtm += 'normal"><u><o:p><span style="text-decoration:none">&nbsp;</span></o:p></u></b></p> ' + LF
   ////Aadd( aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco, cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso, cMat, cCPF,;
   // cGenero, cRG } )
   // 	 15     16
	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">Eu, '+ aDados[1,1] +  LF
	chtm += '</span><!--[if supportFields]><span style="font-size:11.0pt;line-height:150%"><span ' + LF
	chtm += 'style="mso-element:field-begin"></span><span ' + LF
	chtm += 'style="mso-spacerun:yes"> </span>DOCVARIABLE<span style="mso-spacerun:yes">  ' + LF
	chtm += '</span>GPE_NOME<span style="mso-spacerun:yes">  </span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-end"></span></span><![endif]--><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span ' + LF
	chtm += 'style="mso-spacerun:yes"> </span>brasileiro (a), função ' + aDados[1,3] + ' </span><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-begin"></span> ' + LF
	chtm += 'DOCVARIABLE<span style="mso-spacerun:yes">  </span>GPE_DESC_FUNCAO<span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-end"></span></span><![endif]--><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">, portador (a) do RG / SSP n.º ' + aDados[1,16] +  LF
	chtm += '</span><!--[if supportFields]><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%"><span style="mso-element:field-begin"></span> ' + LF
	chtm += 'DOCVARIABLE<span style="mso-spacerun:yes">  </span>GPE_RG<span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-end"></span></span><![endif]--><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">, inscrito(a) no CPF/MF sob o n.º '+ aDados[1,14] + ' </span><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-begin"></span> ' + LF
	chtm += 'DOCVARIABLE<span style="mso-spacerun:yes">  </span>GPE_CPF<span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-end"></span></span><![endif]--><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">, funcionário(a) da empresa RAVA ' + LF
	chtm += 'EMBALAGENS INDÚSTRIA E COMÉRCIO LTDA, tenho plena e expressa ciência de que <b><i>os ' + LF
	chtm += 'e-mails corporativos da empresa não poderão ser utilizados para fins ilícitos ' + LF
	chtm += 'ou imorais na forma da Lei, ou a qualquer outro fim que não seja exclusivamente ' + LF
	chtm += 'para termos profissionais</i></b>, sob pena de demissão por justa causa, nos ' + LF
	chtm += 'termos do art. 482 da CLT.<o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">Outrosim, autorizo expressamente ao ' + LF
	chtm += 'meu superior hierárquico ou a quem competir, a fiscalização da minha caixa de ' + LF
	chtm += 'correio eletrônico quando houver suspeitas de utilização indevida, sem que isso ' + LF
	chtm += 'se configure em invasão de privacidade, ou gere direito à indenização.<o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%">Assumo a inteira e irrevogável ' + LF
	chtm += 'responsabilidade pela infração do presente Termo, inclusive pelos danos ' + LF
	chtm += 'eventualmente decorrentes do seu descumprimento, isentando assim a empresa e ' + LF
	chtm += 'seus representantes legais, em hipótese de ação de reparação de danos. <o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="text-align:justify;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><o:p>&nbsp;</o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal align=right style="text-align:right;line-height:150%; ' + LF
	chtm += 'tab-stops:0cm"><span style="font-size:11.0pt;line-height:150%">Cabedelo/ PB,</span><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-begin"></span> ' + LF
	chtm += 'DOCVARIABLE<span style="mso-spacerun:yes">  </span>GPE_DATA_ADMISSAO<span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span>\* MERGEFORMAT </span><![endif]--><!--[if supportFields]><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span style="mso-element:field-end"></span></span><![endif]--><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><span ' + LF
	chtm += 'style="mso-spacerun:yes"> </span> ' + aDados[1,12] + '. <o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal align=center style="text-align:center;line-height:150%"><span ' + LF
	chtm += 'style="font-size:11.0pt;line-height:150%"><o:p>&nbsp;</o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">RAVA Embalagens Indústria Comércio Ltda.<o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%"><p>&nbsp;</p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">_______________________________<span ' + LF
	chtm += 'style="mso-spacerun:yes">       </span>______________________________________<p></p></span></p> ' + LF

	chtm += '<p class=MsoNormal><span style="font-size:11.0pt">LUIZA HELENA FREIRE ' + LF
	chtm += 'MARTINS<span style="mso-spacerun:yes">      </span> Empregado <o:p></o:p></span></p> ' + LF

	chtm += '<p class=MsoNormal><span style="font-size:11.0pt">GERENTE DE RH<span ' + LF
	chtm += 'style="mso-spacerun:yes">                               </span><span ' + LF
	chtm += 'style="mso-tab-count:1">          </span><p></p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="tab-stops:5.0cm"><span style="font-size:11.0pt"><p>&nbsp;</p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="tab-stops:5.0cm"><span style="font-size:11.0pt"><p>&nbsp;</p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="tab-stops:5.0cm"><span style="font-size:11.0pt"><o:p>&nbsp;</o:p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="tab-stops:5.0cm"><span style="font-size:11.0pt"><o:p>&nbsp;</o:p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="tab-stops:5.0cm"><span style="font-size:11.0pt"><span ' + LF
	chtm += 'style="mso-tab-count:2">                                                           </span><span ' + LF
	chtm += 'style="mso-spacerun:yes">  </span><p></p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%"><p>&nbsp;</p></span></p> ' + LF
	chtm += '<p class=MsoNormal style="line-height:150%"><i><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%"><p>&nbsp;</p></span></i></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><i><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">Testemunhas:<p></p></span></i></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">___________________________________________ <p></p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">CPF n.º_________________<p></p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">___________________________________________ <p></p></span></p> ' + LF

	chtm += '<p class=MsoNormal style="line-height:150%"><span style="font-size:11.0pt; ' + LF
	chtm += 'line-height:150%">CPF n.º_________________<p></p></span></p> ' + LF

	chtm += '</div> ' + LF

	chtm += '</body> ' + LF

	chtm += '</html> ' + LF
Endif
Memowrite("C:\Temp\cHtm.txt" , chtm)


Return(chtm)
**************************************
Static Function fAbreHTM(cDir, cArq)  
**************************************

//Tenta com o MOZILLA COMUM
If WinExec("C:\Arquivos de programas\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
	///Se não conseguir, tenta com Mozilla (para Dell)
	If WinExec("C:\Program Files (x86)\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
		//Se não conseguir, tenta com Internet Explorer	
		If WinExec("C:\arquiv~1\intern~1\iexplore.exe " + cDir + cArq) <> 0						
				
			MsgBox("Não foi possível Abrir o Relatório Automaticamente."+Chr(13)+;
			"Por Favor, Verifique seu e-mail, o relatório estará anexado."+Chr(13)+Chr(13)+;
			"", "Atenção")	
	        ///se não conseguir abrir nenhum, irá avisar que o arquivo chegou anexado por email
		EndIf
	Endif
EndIf

Return