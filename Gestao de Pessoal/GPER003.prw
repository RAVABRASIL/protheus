
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER020  � Autor � R.H. - Ze Maria         � Data � 03.03.95 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Liquidos                                          ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER020(void)                                                ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
��� Priscila R.� 08/05/02 �014139�Inclusao do numero do CPF do Funcionario  ��� 
���            � -------- �------�e Beneficiario.                           ��� 
��� Priscila R.� 17/05/02 �------�Ajuste no relatorio para que seja impresso��� 
���            � -------- �------�corretamente o C.C no tamanho 20.         ��� 
��� Priscila R.� 09/08/02 �------�Exclusao da Pergunta Taref. Mensalista que��� 
���            � -------- �------�nao estava sendo usada,ajustes nos mv_par.��� 
��� Emerson    � 21/08/02 �------�Ajuste p/ quebrar corretamente por Filial.���
��� Emerson    � 08/11/02 �------�Alterar pergunta "Data Ini.Ferias De/Ate" ���
���            � -------- �------�para "Data de Pagamento De/Ate".          ���
��� Emerson    � 31/03/03 �------�Passar a nao filtrar Bco/Age pelo SRA para���
���            � -------- �------�nao perder a impressao dos beneficiarios. ���
��� Priscila R.� 28/07/03 �------�Alt. p/listar Demitidos de acordo com o pa��� 	
���            � -------- �------�rametro Data De/Ate.Inclus.Perg."Totaliza ��� 
���            � -------- �------�por Agencia".                             ��� 
��� Natie      � 17/05/04 �------�Acerto total Agencia e quebra de Pagina   ��� 
��� Natie      � 18/08/04 �073420�Nao estava considerando Vlr do Benefic. no��� 
���            �          �      �total do Rel. no modo Sintetico           ��� 
��� Natie      � 28/10/04 �074506|Impr.somente de benefic Com/Sem Conta     ��� 
���            �          �074940|Retirada do DbSkip qdo testa func.Demitido��� 
���            �          �075738|Totaliza p/Agencia de acordo c/cTotAgen   ��� 
���            �          �074211|Totaliza p/Filial de acordo c/parametro   ��� 
���            �          �------|Validacao nos param. C.Corrente De/Ate    ��� 
��� Ricardo D. � 26/11/04 �074506|Tratamento para impressao de Ambos ( Func+��� 
���            �          �------|Benef) Com ou Sem Conta Corrente.         ��� 
��� Ricardo D. � 14/02/05 �077912|Ajuste no salto de pagina entre agencias  ��� 
���            �          �------|quando a pergunta Totaliza por Agencia es-��� 
���            �          �------|tava com "N".                             ��� 
��� Ricardo D. � 14/02/05 �077913|Ajuste na impressao do total da agencia p/��� 
���            �          �------|imprimir o total na sequencia dos funciona��� 
���            �          �------|rios sempre que tiver espaco.             ��� 
��� Natie      � 12/05/05 �081494|Reinicializa lRescisao.                   ��� 
��� Ricardo D. � 13/05/05 �081974|Incluida pergunta "Rescisao (S/N)" p/impri��� 
���            �          �------|mir imir o total na sequencia dos funciona��� 
���            �          �------|rios sempre que tiver espaco.             ��� 
��� Natie      � 31/05/05 �081245|Possibilitar  a impressao de mvto anterio-���
���            �          �------|res atraves da "data de Referencia"       ���
��� Natie      � 12/07/05 �083441|Ajuste impressao dos totais qdo total p/ag��� 
���            �          �      |e total.p/ag.="N".Estava quebrando p/ag.  ��� 
��� Emerson GR.� 19/07/05 �083911|Tratam. do parametro "Filail outra pagina"��� 
���            �          �      |pois estava imp.apenas total na outra pag.��� 
��� Natie      � 10/08/05 �      |Inclusao de Query p/melhoria de performanc��� 
��� Tania      �11/01/2006�089612|Acerto da montagem da Query quando utili- ��� 
���            �          �------|zado Filtro.                              ��� 
��� Tania      �17/02/2006�092357|Acerto para impressao dos liquidos do 13o.��� 
���            �          �------|salario depois de dezembro fechado.       ��� 
��� Tania      �05/05/2006�092416|Acerto no campo cPula, de controle de que-��� 
���            �          �------|bras de paginas.                          ��� 
��� Pedro Eloy �17/05/2006�094205|Criado um arquivo temporario para armazena��� 
���            �          �------|os registros validos para sanar problemas ��� 
���            �          �------|na somatorio dos lan�amentos do benefic.  ��� 
��� Tania      �02/06/2006�100734|Ajuste na rotina de salto de paginas por  ��� 
���            �          �------|Agencia.                                  ��� 
��� Ricardo D. �29/06/2006�102269|Ajuste na criacao do indice do temporario ��� 
���            �          �------|pois deixou de considerar a agencia.      ��� 
��� Andreia    �27/07/2006�103250|Acerto na quebra de pagina por Filial,    ��� 
���            �          �------|quando a pergunta "Filial em Outr.Pag" es-��� 
���            �          �------|tiver com "Sim".                          ��� 
��� Ricardo D. �23/08/2006�104929|Ajuste na validacao do controle de acessos��� 
���            �          �------|e restricoes de usuarios durante a impres-��� 
���            �          �------|sao do arquivo temporario.                ��� 
��� Andreia    �06/09/2006�104129|Quando o relatorio for de ferias e for se-��� 
���            �          �------|lecionado somente a situacao "F", tambem e��� 
���            �          �------|acresentada a situacao "A" para o caso das��� 
���            �          �------|ferias terem sido calculadas antes do afas��� 
���            �          �------|tamento.                                  ��� 
��� Tatiane    �07/09/2006�099621|Conversao para relatorio personalizavel   ��� 
��� Ricardo D. �29/09/2006�094205|Ajuste no filtro de banco e agencia para  ��� 
���            �          �------|os beneficiarios.                         ��� 
��� Ricardo D. �13/10/2006�099621|Ajuste no R4: tratamento de help de SX1,  ��� 
���            �          �------|Titulo do relatorio, titulos das quebras  ��� 
���            �          �------|por totais.                               ��� 
���            �          �------|                                          ��� 
���Mauro       �24/10/2006�099621|Inclusao do TRPosition() - tabela SRA.	��� 
��� Ricardo D. �18/01/2007�117482|Criacao do Ponto de Entrada GP020DES.     ���
���Luiz Gustavo|19/01/2007�      �Retiradas funcoes de ajuste de dicionario ��� 
��� Ricardo D. �04/05/2007�125515|Ajuste na pergunta Rescisao S/N atraves da��� 
���            �          �------|funcao AjustaSx1()                        ��� 
��� Pedro Eloy �07/05/2007�124827|Ajuste na filial da pesquisa do banco/ag. ��� 
��� Natie      �05/06/2007�120318|Cria indice do arquivo temporario- R4     ��� 
���            �          �------|Ajuste no cFiltro                         ��� 
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/

User Function GPER003()   

Local oReport 

Private nPgQuant	:= 0
Private nPgValor	:= 0

	
GPER020R3()
	

Return

Static Function GPER020R3()

Local cSavCur1,cSavRow1,cSavCol1,cSavCor1,cSavScr1,cSavScr2,CbTxt // Ambiente
Local aRegs	   	:= {}
Local cString :="SRA"        // alias do arquivo principal (Base)
Local aOrd	  :=	{	"Filial+Bco/Ag.+Mat",;	//"Filial+Bco/Ag.+Mat"
			 			"Filial+Bco/Ag.+Cc+Mat",;	//"Filial+Bco/Ag.+Cc+Mat"
						"Filial+Bco/Ag.+Nome",;	//"Filial+Bco/Ag.+Nome"
						"Filial+Bco/Ag.+Cta",;	//"Filial+Bco/Ag.+Cta"
						"Filial+Bco/Ag.+Cc+Nome",;	//"Filial+Bco/Ag.+Cc+Nome"
						"Bco/Ag.+Mat",;	//"Bco/Ag.+Mat"
						"Bco/Ag.+Cc+Mat",;	//"Bco/Ag.+Cc+Mat"
						"Bco/Ag.+Nome",;	//"Bco/Ag.+Nome"
						"Bco/Ag.+Cta",;	//"Bco/Ag.+Cta"
						"Bco/Ag.+Cc+Nome",;//"Bco/Ag.+Cc+Nome"
						"Nome"}	


Local	cDesc1	:=		"Rela��o de Liquidos."		//"Rela��o de Liquidos."
Local	cDesc2	:=		"Ser� impresso de acordo com os parametros solicitados pelo"		//"Ser� impresso de acordo com os parametros solicitados pelo"
Local	cDesc3	:=		"usu�rio."		//"usu�rio."

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local aCodigosAdt:={}
Local aHelpPor	:= {}
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn := {"Zebrado", 1,"Administra��o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private nomeprog:="GPER020"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="GPR020"
Private nExtra, AgeAnt

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
private Quebloc := Quebloc1 := .T.
Private cIndCond
Private cIndTRB	:= ""
Private cFor
Private nOrdem
Private aInfo:={}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG  := "GPER020"
Private cCabec
Private wCabec0 := 3
Private wCabec1:="                                                                                                                 "
Private wCabec2:="                                    -------  F U N C I O N A R I O / B E N E F I C I A R I O  -------                              "
//"                                     |-------  F U N C I O N A R I O  -------|                                   "
Private wCabec3:="FIL. BANCO      CCUSTO                 MATRIC.  NOME                             C.P.F.        C O N T A           V A L O R       "
//Stuff("FIL. BANCO      CCUSTO      MATRIC. NOME                            C.P.F.     C O N T A          V A L O R",At("C.P.F.","FIL. BANCO      CCUSTO      MATRIC. NOME                            C.P.F.     C O N T A          V A L O R"),6,PadR(RetTitle("RA_CIC"),6))		
Private CONTFL:=1
Private LI:=0
Private nTamanho:="M"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("GPR020",.F.)

cTit := "RELA��O DE LIQUIDOS"
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER020"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem		:= aReturn[8]
lAdianta	:= If(mv_par01 == 1,.T.,.F.)		// Adiantamento 
lFolha		:= If(mv_par02 == 1,.T.,.F.)		// Folha    
lPrimeira	:= If(mv_par03 == 1,.T.,.F.)		// 1�Parc. 13� Sal�rio
lSegunda	:= If(mv_par04 == 1,.T.,.F.)		// 2�Parc. 13� Sal�rio
lFerias		:= If(mv_par05 == 1,.T.,.F.)		// F�rias
lExtras		:= If(mv_par06 == 1,.T.,.F.)		// Extras
lRescisao   := If(mv_par32 == 1,.T.,.F.)		// Rescisao
Semana		:= mv_par07     				 	// Numero da Semana
ComConta	:= If(mv_par08 == 1,"C",(If(mv_par08 == 2,"S","A")))	//  Qto. a Conta Corrente 
FilialDe	:= mv_par09							// Filial  De  
FilialAte	:= mv_par10							// Filial  Ate
CcDe		:= mv_par11							// Centro de Custo De
CcAte		:= mv_par12							// Centro de Custo Ate
BcoDe		:= mv_par13							// Banco /Agencia De
BcoAte		:= mv_par14							// Banco /Agencia Ate
MatDe		:= mv_par15							// Matricula De 
MatAte		:= mv_par16							// Matricula Ate
NomDe		:= mv_par17							// Nome De
NomAte		:= mv_par18							// Nome Ate
CtaDe		:= mv_par19							// Conta Corrente De
CtaAte		:= mv_par20							// Conta Corrente Ate
cSituacao	:= mv_par21							// Situacao
Quebloc		:= If(mv_par22 == 1,.T.,.F.)		// Totalizar por Filial
cSalta		:= If(mv_par23 == 1,"S","N")		// Imprime Filial em Outra Pagina 
LstNome		:= If(mv_par24 == 1,"S","N")		// Mostrar Nomes dos Funcionarios
dDataDe		:= mv_par25							// Data Pagamento De
dDataAte	:= mv_par26							// Data Pagamento Ate
cSaltaAg	:= If(mv_par27 == 1,"S","N")		// Quebra Pagina p/Agencia   Sim,Nao 
cTotAgen	:= If(mv_par28 == 1,"S","N")		// Totaliza por Agencia 
cTipoRel	:= If(mv_par29 == 1, "A" , "S" )	// Tipo de Relacao:1-Analitica, 2-Sintetica 
nFunBenAmb  := mv_par30  						// Imprimir : 1-Funcionarios  2-Beneficiarias  3-Ambos
cCategoria	:= mv_par31 						// Categorias
dDtRef    	:= If(empty(mv_par33), dDataBase,mv_par33)	// Data de referencia 

//��������������������������������������������������������������Ŀ
//�  Pega descricao da semana                                    �
//����������������������������������������������������������������
cCabec := If(Semana # Space(2),fRetPer( Semana,dDtRef )," ")

//��������������������������������������������������������������Ŀ
//� Nao imprime Quando Relacao Sintetica.                        �
//����������������������������������������������������������������
IF cTipoRel == "S"
	wCabec2 := ""
EndIF	

If lAdianta
	Titulo := "RELACAO DE LIQUIDOS DO ADIANTAMENTO"
Elseif lFolha       
	Titulo := "RELACAO DE LIQUIDOS DA FOLHA"
Elseif lPrimeira     
	Titulo := "RELACAO DE LIQUIDOS DA 1a PARCELA DO 13o SALARIO  "
Elseif lSegunda      
	Titulo := "RELACAO DE LIQUIDOS DA 2a PARCELA DO 13o SALARIO  "
Elseif lFerias      
	Titulo := "RELACAO DE LIQUIDOS DAS FERIAS  "
Elseif lExtras      
	Titulo := "RELACAO DE LIQUIDOS DE VAL.EXTRAS "
Else 
   Titulo := ""
Endif

Titulo += " ("+StrZero( aReturn[8] , 2 )+")"+If(!Empty(cCabec)," - "+cCabec,"") + IF(cTipoRel="A","Analitica","Sintetica") +" / "+Mesextenso( Month( MV_PAR33 ) )+" de "+alltrim(Str( Year( MV_PAR33 ) ))

If LastKey() = 27 .Or. nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return
Endif

RptStatus({|lEnd| R020ImpR3(@lEnd,wnRel,cString)},cTit)  // Chamada do Relatorio

Return

*------------------------------------------*
Static Function R020ImpR3(lEnd,WnRel,cString)
*------------------------------------------*
Local nTotregs,nMult,nPosAnt,nPosAtu,nPosCnt,cSav20,cSav7 //Regua
Local tamanho:="P"
Local limite := 80
Local aOrdBag    := {}
Local aOrdBagRI	 := {}
Local aValBenef  := {}
Local aBenefCop  := {}
Local cArqMov := cAliasMov := ""
Local cArqMovRI	 :=	""
Local cAliasRI	 := ""
Local cMesArqRef := StrZero(Month(dDtRef),2) + StrZero(Year(dDtRef),4)
Local cFilter	:= aReturn[7]

//��������������������������������������������������������������Ŀ
//� Define Variaveis Query                                       �
//����������������������������������������������������������������

Local cSQL 			:= ""
Local cCatQuery 	:= ""
Local cSitQuery 	:= ""
Local nS			:= 0
Local aStruSRA		:= {} 
Local lQuery		:= .F. 

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local aCodigosAdt := {}
Local aCodFol     := {}
Local nCntP
Local aCampos	:= {}
Local aTam    	:= TAMSX3("RA_CC")


Private cPict1	:=	TM(99999999999,17,MsDecimais(1))// "@E  99,999,999,999.99"
Private cPict2	:=	TM(999999999999,18,MsDecimais(1))//"@E 999,999,999,999.99"

//��������������������������������������������������������������Ŀ
//� Variaveis de Acesso do Usuario                               �
//����������������������������������������������������������������
Private cAcessaSR1	:= &( " { || " + ChkRH( "GPER020" , "SR1" , "2" ) + " } " )
Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER020" , "SRA" , "2" ) + " } " )
Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER020" , "SRC" , "2" ) + " } " )
Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER020" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER020" , "SRH" , "2" ) + " } " )
Private cAcessaSRI	:= &( " { || " + ChkRH( "GPER020" , "SRI" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER020" , "SRR" , "2" ) + " } " )

//��������������������������������������������������������������Ŀ
//� Define se devera ser impresso Funcionarios ou Beneficiarios  �
//����������������������������������������������������������������
dbSelectArea( "SRQ" )
lImprFunci  := ( nFunBenAmb # 2 )
lImprBenef  := ( nFunBenAmb # 1 .And. FieldPos( "RQ_BCDEPBE" ) # 0 .And. FieldPos( "RQ_CTDEPBE" ) # 0 )

//��������������������������������������������������������������Ŀ
//� Informa a nao existencia dos campos de bco/age/conta corrente�
//����������������������������������������������������������������
If nFunBenAmb # 1 .And. !lImprBenef
	fAvisoBC()
	Return .F.
Endif

//��������������������������������������������������������������Ŀ
//� Muda cabecalho se impressao de beneficiarias                 �
//����������������������������������������������������������������
IF lImprBenef
	If nFunBenAmb == 2
		wCabec2 := "                                     -------  B E N E F I C I A R I O  -------                                   "
	Else
		wCabec2 := "                         -------  F U N C I O N A R I O / B E N E F I C I A R I O  -------                       "
	EndIf
EndIF	

//-- Abre o SRI
If lSegunda
	If !OpenSrc( "13"+Substr(cMesArqRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dDtRef,.F., .F. )
		Return .f.
	EndIf
EndIf

//-- Abre o SRC
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dDtRef )
	Return .f.
Endif

dbSelectArea("SRA")
If nOrdem == 1
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_MAT"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + MAT"
	cFor:= '(RA_FILIAL+RA_MAT >= "'+FilialDe+MatDe+'")'
	cFor+= '.And. (RA_FILIAL+RA_MAT <= "'+FilialAte+MatAte+'")'
ElseIf nOrdem == 2
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_MAT"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + MAT"
	cFor:='(RA_FILIAL+RA_CC+RA_MAT >= "'+FilialDe+CcDe+MatDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CC+RA_MAT <= "'+FilialAte+CcAte+MatAte+'")'
ElseIf nOrdem == 3
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_NOME"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + NOME"
	cFor:='(RA_FILIAL+RA_NOME >= "'+FilialDe+NomDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_NOME <= "'+FilialAte+NomAte+'")'
Elseif nOrdem == 4
	cIndCond:= "RA_FILIAl + RA_BCDEPSA + RA_CTDEPSA"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CONTA"
	cFor:='(RA_FILIAL+RA_CTDEPSA >= "'+FilialDe+CtaDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CTDEPSA <= "'+FilialAte+CtaAte+'")'
ElseIf nOrdem == 5
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_NOME"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + NOME"
	cFor:='(RA_FILIAL+RA_CC+RA_NOME >= "'+FilialDe+CcDe+NomDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CC+RA_NOME <= "'+FilialAte+CcAte+NomAte+'")'
ElseIf nOrdem == 6
	cIndCond:= "RA_BCDEPSA + RA_MAT"
	cIndTRB	:= "BANCO + AGENCIA + MAT"
	cFor:='(RA_MAT >= "'+MatDe+'")'
	cFor+=' .And. (RA_MAT <= "'+MatAte+'")'
ElseIf nOrdem == 7
	cIndCond:= "RA_BCDEPSA + RA_CC + RA_Mat"
	cIndTRB	:= "BANCO + AGENCIA + CCUSTO + MAT"
	cFor:='(RA_CC+RA_Mat >= "'+CcDe+MatDe+'")'
	cFor+=' .And. (RA_CC+RA_Mat <= "'+CcAte+MatAte+'")'
Elseif nOrdem == 8
	cIndCond:= "RA_BCDEPSA + RA_NOME"
	cIndTRB	:= "BANCO + AGENCIA + NOME"
	cFor:='(RA_NOME >= "'+NomDe+'")'
	cFor+=' .And. (RA_NOME <= "'+NomAte+'")'
ElseIf nOrdem == 9
	cIndCond:= "RA_BCDEPSA + RA_CTDEPSA"
	cIndTRB	:= "BANCO + AGENCIA + CONTA"
	cFor := ''
ElseIf nOrdem == 10
	cIndCond:= "RA_BCDEPSA + RA_CC + RA_NOME"
	cIndTRB	:= "BANCO + AGENCIA + CCUSTO + NOME"
	cFor:='(RA_CC+RA_NOME >= "'+CcDe+NomDe+'")'
	cFor+=' .And. (RA_CC+RA_NOME <= "'+CcAte+NomAte+'")'
ElseIf nOrdem == 11
	cIndCond:= "RA_NOME"
	cIndTRB	:= "NOME"
	cFor:='(RA_NOME >= "'+NomDe+'")'
	cFor+=' .And. (RA_NOME <= "'+NomAte+'")'
Endif
//��������������������������������������������������������������������������Ŀ
//� Faz filtro no arquivo...                                                 �
//����������������������������������������������������������������������������
If lFerias .and. ("F" $ cSituacao .and. !("A"$cSituacao) )
	cSituacao += "A"
EndIf    

#IFDEF TOP 
	lQuery	:= .T. 
	//-- Modifica variaveis para a Query
	For nS:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
		If ( nS+1) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nS     
	
	cCatQuery := ""
	For nS:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
		If ( nS+1) <= Len(cCategoria)
			cCatQuery += "," 
		Endif
	Next nS

	cSQL := "SELECT * "	
	cSQL += " FROM " +	RetSqlName("SRA")
	cSQL += " WHERE "  
	cSQL += " RA_FILIAL  between  '" + FilialDe +"' AND '" +FilialAte  +"' AND "
	cSQL += " RA_MAT     between  '" + MatDe    +"' AND '" +MatAte     +"' AND "
	cSQL += " RA_NOME    between  '" + NomDe    +"' AND '" +NomAte     +"' AND "	
	cSQL += " RA_CC      between  '" + CcDe     +"' AND '" +CcAte      +"' AND "
	cSQL += " RA_SITFOLH IN ("   + Upper(cSitQuery)    + ") AND " 
	cSQL += " RA_CATFUNC IN ("   + Upper(cCatQuery)    + ") AND " 
	If TcSrvType() != "AS/400"
		cSQL += "  D_E_L_E_T_ <> '*' "
	Else
		cSQL += "  @DELETED@  <> '*' "	
	Endif 

	//��������������������������������������������������������������������������Ŀ
	//� Se houver filtro executa parse para converter expressoes adv para SQL    �
	//����������������������������������������������������������������������������
	If ! Empty(cFilter)
		cSQL += " and " + GPEParSQL(cFilter)
	Endif   

	//��������������������������������������������������������������������������Ŀ
	//� Define order by de acordo com a ordem...                                 �
	//����������������������������������������������������������������������������

	If nOrdem == 1
		cSQL += " ORDER BY RA_FILIAL, RA_BCDEPSA,RA_MAT "
	ElseIf nOrdem == 2
		cSQL += " ORDER BY RA_FILIAL, RA_BCDEPSA, RA_CC, RA_MAT "
	ElseIf nOrdem == 3
		cSQL += " ORDER BY RA_FILIAL, RA_BCDEPSA, RA_NOME "
	Elseif nOrdem == 4
		cSQL += " ORDER BY RA_FILIAl, RA_BCDEPSA, RA_CTDEPSA "
	ElseIf nOrdem == 5
		cSQL += " ORDER BY RA_FILIAL, RA_BCDEPSA, RA_CC, RA_NOME "
	ElseIf nOrdem == 6
		cSQL += " ORDER BY RA_BCDEPSA, RA_MAT "
	ElseIf nOrdem == 7
		cSQL += " ORDER BY RA_BCDEPSA, RA_CC, RA_Mat "
	Elseif nOrdem == 8
		cSQL += " ORDER BY RA_BCDEPSA, RA_NOME "
	ElseIf nOrdem == 9
		cSQL += " ORDER BY RA_BCDEPSA, RA_CTDEPSA "
	ElseIf nOrdem == 10
		cSQL += " ORDER BY RA_BCDEPSA, RA_CC, RA_NOME "
	ElseIf nOrdem == 11
		cSQL += " ORDER BY RA_NOME "
	Endif
	cSQL     	:= ChangeQuery(cSQL)
	aStruSRA 	:= SRA->(dbStruct())
	SRA->( dbCloseArea() ) //Fecha o SRA para uso da Query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"SRA",.F.,.T.)
	For nS := 1 To Len(aStruSRA)
		If ( aStruSRA[nS][2] <> "C" )
			TcSetField("SRA",aStruSRA[nS][1],aStruSRA[nS][2],aStruSRA[nS][3],aStruSRA[nS][4])
		EndIf
	Next nS
#Else	

	cArqNtx  := CriaTrab(NIL,.F.) 
	IndRegua("SRA",cArqNtx,cIndCond,,cFor,STR0039)				//"Selecionando Registros..."
	DbGoTop()
#ENDIF

// Temporario para armazenar os dados para a impressao
aCampos := {{  "FILIAL" 	,"C"	,002	,0 	} ,;	// FILIAL DA EMPRESA DO FUNCIONARIO
             { "BANCO"  	,"C"	,003	,0 	} ,;	// codigo do Banco
             { "AGENCIA"	,"C"	,005	,0 	} ,;	// codigo da agencia
             { "CCUSTO" 	,"C"	,aTam[1],0 	} ,;	// codigo do centro de custo
             { "MAT"    	,"C"	,006	,0  } ,;   	// codigo da matricula
             { "NOME"  		,"C"	,040	,0 	} ,;	// nome
             { "CPF"		,"C"	,011	,0 	} ,;  	// cpf 
             { "CONTA" 		,"C"	,012	,0 	} ,;	// conta do funcionario/benef.
             { "VALOR"		,"N"	,012	,2 	} ,;	// valor 
             { "BENEF" 		,"C"	,001	,0 	} } 	// Beneficiario

cArqTemp := CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,"TRB",.T.,.F.)	
IndRegua("TRB",cArqTemp,cIndTRB,,,"Selecionando Registros..." )						//"Selecionando Registros..."

FilAnt := "!!"
AgeAnt := Space(08)
BcoAnt := Space(03)
CcAnt  := Space(09)
CtaAnt := Space(12)
NomAnt := Space(30)

tEmpresa := tPAGINA  := tFilial := tBanco  := tAgencia := tCc := 0
tFunEmp  := tFunPag  := tFunFil := TFunAge := tFunBan  := tFunTcc := 0
nTransval:= nTransFun:= nFlag := 0
cPula :=" "

dbSelectArea( "SRA" )
SetRegua(RecCount())   // Total de elementos da regua

While !EOF()
	IncRegua()  // Anda a regua

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	nValor    := 0
	aValBenef := {}

	If SRA->RA_FILIAL # FilAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) .Or. !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
		FilAnt := SRA->RA_FILIAL
	Endif
	
	If !lQuery 
		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (SRA->RA_NOME    < NomDe) .Or. (SRA->RA_NOME    > NomAte) .Or. ;
	 	   (SRA->RA_MAT     < MatDe) .Or. (SRA->RA_MAT     > MatAte) .Or. ;
		   (SRA->RA_FILIAL  < FilialDe) .Or. (SRA->RA_FILIAL> FilialAte) .Or. ;
		   (SRA->RA_CC      < CcDe ) .Or. (SRA->RA_CC      > CcAte )
       		dbSelectArea("SRA")
			dbSkip()
		   	Loop
		EndIf
	
		//��������������������������������������������������������������Ŀ
		//� Consiste Filtro da setprint						             �
		//����������������������������������������������������������������
		If ! Empty(cFilter) .And. ! &(cFilter)
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf
    Endif
	
	//��������������������������������������������������������������Ŀ
	//� Consiste controle de acessos e filiais validas               �
	//����������������������������������������������������������������
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSelectArea("SRA")
		dbSkip()
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Busca os valores de Liquido e beneficios                     �
	//����������������������������������������������������������������
	fBuscaLiq(@nValor,@aValBenef,aCodFol)

	//��������������������������������������������������������������Ŀ
	//� Ponto de Entrada para despresar funcionario caso retorne .F. �
	//� Identico ao ponto de entrada GP450DES de geracao dos liquidos�
	//����������������������������������������������������������������
	If ExistBlock("GP020DES")
		If !(ExecBlock("GP020DES",.F.,.F.))
			dbSelectArea( "SRA" )
			SRA->(dbSkip())
			Loop
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Consiste parametros de banco e conta do funcionario			 �
	//� Se nFunBenAmb=2, apenas sera testado a Bco e conta do Benefic�
	//����������������������������������������������������������������
	If nFunBenAmb # 2 	.and.  ;										//-- Se nao for Beneficiario, testa Bco e Conta do Funcionario 
	   ((SRA->RA_BCDEPSA < BcoDe) .Or. (SRA->RA_BCDEPSA > BcoAte) .Or. ;
	    ( ComConta ="C" .and. ( SRA->RA_CTDEPSA < CtaDe) .Or. (SRA->RA_CTDEPSA > CtaAte)  ) .Or.;
		( COMCONTA = "C" .And. SRA->RA_CTDEPSA == SPACE(LEN(SRA->RA_CTDEPSA)) .and. nFunBenAmb # 2) .Or.;
		( COMCONTA = "S" .And. SRA->RA_CTDEPSA #  SPACE(LEN(SRA->RA_CTDEPSA)) .and. nFunBenAmb # 2) )
		nValor := 0
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Consiste parametros de banco e conta do beneficiario 		 �
	//� aValBenef: 1-Nome  2-Banco  3-Conta  4-Verba  5-Valor  6-CPF �
	//����������������������������������������������������������������
	If Len(aValBenef) > 0 
		aBenefCop  := ACLONE(aValBenef) 
		aValBenef  := {} 
				
		If ( nFunBenAmb == 2 .or. nFunBenAmb == 3) 
			If ComConta="C" 					//-- Beneficiario e  com Conta, testo a Conta 
				Aeval(aBenefCop, { |X| If( ( X[2] >= BcoDe .And. X[2] <= BcoAte ) .And. ;
							           ( X[3] >= CtaDe .And. X[3] <= CtaAte .and.;
							            !Empty(X[3]) ) ,  ;        
						                AADD(aValBenef,X ), "" ) })                   
        
			ElseIf ComConta="S"				//-- Se for beneficiario,  sem  Conta 
				Aeval(aBenefCop, { |X| If(( X[2] >= BcoDe .And. X[2] <= BcoAte    ) .And.  ;
							           ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ,;
										 AADD(aValBenef,X ), ""  )  })		
			ElseIf ComConta = "A" 
				Aeval(aBenefCop, { |X| If( ( ( X[2] >= BcoDe .And. X[2] <= BcoAte ) .And. ;
							             ( X[3] >= CtaDe .And. X[3] <= CtaAte  ) ) .or. ;
				                       ( ( X[2] >= BcoDe .And. X[2] <= BcoAte  ) .And.  ;
							              ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), ;
										 AADD(aValBenef,X ), ""  )  })
			EndIf 
		Endif	
	EndIf

	//��������������������������������������������������������������Ŀ
	//� 1- Testa Situacao do Funcionario na Folha					 �
    //� 1- Testa Categoria do Funcionario na Folha					 �
	//� 2- Testa Com Conta											 �
	//� 3- Testa Sem Conta											 �
	//� 4- Testa se Valor == 0										 �
	//� 5- Testa se beneficiario e               					 �	
	//����������������������������������������������������������������
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !(SRA->RA_CATFUNC $ cCategoria) .Or.;
		( nValor == 0 .And. Len(aValBenef) == 0 ) .or. ;
		( nFunBenAmb == 2 .And. Len(aValBenef) == 0) 
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	
    // gravar no arquivo temporario
	If nValor > 0
		RecLock("TRB",.T.)    
    	TRB->FILIAL		:= SRA->RA_FILIAL				// FILIAL DA EMPRESA DO FUNCIONARIO
	    TRB->BANCO		:= Substr(SRA->RA_BCDEPSA,1,3)	// codigo do Banco
	    TRB->AGENCIA	:= Substr(SRA->RA_BCDEPSA,4,5)	// codigo da agencia
	    TRB->CONTA		:= SRA->RA_CTDEPSA				// conta do funcionario/benef.
	    TRB->CCUSTO		:= SRA->RA_CC					// codigo do centro de custo
	    TRB->MAT		:= SRA->RA_MAT					// codigo da matricula
	    TRB->NOME		:= SRA->RA_NOME					// nome
	    TRB->CPF		:= SRA->RA_CIC					// cpf 
	    TRB->VALOR		:= nValor						// valor 
		MsUnLock()
	Endif

	//��������������������������������������������������������������Ŀ
	//� Impressao dos Beneficiarios                          		 �
	//����������������������������������������������������������������
	For nCntP := 1 To Len(aValBenef) 
		If !Empty(aValBenef[nCntP,1]) .And. aValBenef[nCntP,5] > 0 
				RecLock("TRB",.T.)    
			    	TRB->FILIAL		:= SRA->RA_FILIAL					// FILIAL DA EMPRESA DO FUNCIONARIO
				    TRB->BANCO		:= Substr(aValBenef[nCntP,2],1,3)	// codigo do Banco
				    TRB->AGENCIA	:= Substr(aValBenef[nCntP,2],4,5)	// codigo da agencia
				    TRB->CONTA		:= aValBenef[nCntP,3]				// conta do funcionario/benef.
				    TRB->CCUSTO		:= SRA->RA_CC						// codigo do centro de custo
				    TRB->MAT		:= SRA->RA_MAT						// codigo da matricula
				    TRB->NOME		:= SUBS(aValBenef[nCntP,1],1,30)	// nome
				    TRB->CPF		:= aValBenef[nCntP,6]				// cpf 
				    TRB->VALOR		:= aValBenef[nCntP,5]				// valor 
				    TRB->BENEF		:= "S"								// benef.
				MsUnLock()
		Endif	
	Next nCntP

	dbSelectArea("SRA")
	SRA->(dbSkip())
EndDo


// Montagem do Loop a grava��o do arquivo Temporario.
dbSelectArea("TRB")
dbGotop()
SetRegua(RecCount())   // Total de elementos da regua

While !Eof() 

	IncRegua()  // Anda a regua 
	
	If cPula == "S"				// Imprime quebra de Pagina quando
		Impr(" ","P")			// existe mais um funcionario a ser
		cPula := " "			// impresso.
	ElseIf cPula == "N"			// Imprime uma linha em branco apos
		If cSaltaAg =="S"		// os totais.
			IMPR("","C")    
		Endif
		cPula := " " 
	Endif               

	nContador := If(nValor > 0, 1, 0)
	nValBenef := 0
	IF cTipoRel == "A"	// So Imprime Dados dos Funcionarios quando Relacao For Analitica.
		
		If (Li + 3) >= 58
			Impr("","P")
		Endif

		Det := TRB->FILIAL+"   "+TRB->BANCO+TRB->AGENCIA+"   "+SUBS(TRB->CCUSTO+SPACE(20),1,20)+"   "+TRB->MAT+"   "
		Det += Iif(lstnome="S",SUBS(TRB->NOME,1,30),"***  N o m e   Oculto   ***   ") +"   "+TRB->CPF+"   "		//"***  N o m e   Oculto   ***   "## "CPF"
		Det += TRB->CONTA+" "+Transform(TRB->VALOR,cPict1) + If(TRB->BENEF == "S", "-" + "Funcionario", "") //##BENEF  "Funcionario"
		IMPR(DET,"C")
	Endif	

	TfunPag   += 1              // Adicionando Funcionarios
	TfunFil   += 1        		// Aos Contadores
	TfunAge   += 1
	TfunBan   += 1
	TfunTcc   += 1
	TfunEmp   += 1
	
	Tpagina   += TRB->VALOR 	 // Adicionando Valor aos
	Tfilial   += TRB->VALOR		 // Acumuladores
	TAgencia  += TRB->VALOR
	Tbanco    += TRB->VALOR
	Tcc       += TRB->VALOR
	Tempresa  += TRB->VALOR
	
	If Li >= 53
		TotalPag()     // Quebra Pagina quando excede numero de linhas
		nFlag:=1
	Endif	
	TestaTotal()	
Enddo

If tFunEmp > 0
	TotalEmp()
	IMPR(" ","F")
Endif

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf
If !Empty( cAliasRI )
	fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI )
EndIf

//�������������������������������������Ŀ
//� Eliminando o arquivo temporario.    �
//���������������������������������������
dbSelectArea("TRB")
TRB->( dbCloseArea() )
fErase( cArqTemp + OrdBagExt() )


//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������
dbSelectArea( "SRI" )
dbSetOrder(1)
#IFnDEF TOP 
	Set Filter to
	RetIndex("SRA")
	dbSetOrder(1)	
	fErase( cArqNtx + OrdBagExt() )
#Else
	SRA->( dbCloseArea() ) 		//Fecha o SRA de uso da Query

	dbSelectArea("SRA")
	RetIndex("SRA")	
#Endif	
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

*-------------------------*
Static Function TestaTotal  // Teste para totalizacao
*-------------------------*
dbSelectArea ( "TRB" )
FilAnt := TRB->FILIAL    // Iguala Variaveis
AgeAnt := TRB->AGENCIA
BcoAnt := TRB->BANCO
CcAnt  := TRB->CCUSTO
NomAnt := TRB->NOME

TRB->( dbSkip() ) 
	
If (TRB->FILIAL # FilAnt .Or. Eof()) .And. (nOrdem <= 5) 
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()
	EndIf		
	TotalBan()	
	If Quebloc	
		TotalFil()
	Endif        

	IF cSALTA == "S" .And. !( TRB->(Eof()) )
		cPula :=  "S"
	ENDIF
	
Elseif (TRB->CCUSTO # CcAnt .Or. Eof()) .And. (nOrdem == 2 .Or. nOrdem == 5 .Or. nOrdem == 7 .Or. nOrdem == 10 )
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()		
    EndIf		
	If TRB->BANCO # BcoAnt
		TotalBan()	
	Endif		
	cPula :=  "S"
ElseIf (TRB->BANCO # BcoAnt .Or. Eof())
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()
    EndIf 
	TotalBan()
	cPula	:=	Iif(cPula=="S",cPula,cSaltaAg)  // -- "S" OU "N" 
ElseIf (TRB->AGENCIA # AgeAnt  ) .Or. Eof() 
	
	If cSaltaAg == "S"
		TotalPag() 
		TotalCc()      
		If cTotAgen == "S" 
			TotalAge() 	
		Endif
	Else
		If cTotAgen == "S" 
			TotalPag() 
			TotalCc()      
			TotalAge() 	
		Endif
	Endif 
	cPula	:=	Iif(cPula=="S",cPula,cSaltaAg)  // -- "S" OU "N" 
Endif 

If nFlag == 0
	nTransFun:=nTransVal:=0      	// Zera total a transportar
Endif                           	// apenas quando houver uma quebra
Return 
	
*-----------------------*
Static Function TotalPag		// Totalizador por Pagina
*-----------------------*
If tFunPag == 0
	Return Nil
Endif

IF cTipoRel == "S"				//Nao Imprime Total da Pagina Quando a Relacao for Sintetica.
	Return NIL
EndIF
	
DET = REPLICATE("-",132)
IMPR(DET,"C") 
DET := SPACE(5)+"TOTAL DA PAGINA"+SPACE(68)+"QTDE. FUNC.:"+TRANSFORM(TFUNPAG,"99999")		//"TOTAL DA PAGINA"###"QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(TPAGINA,cPict2)
IMPR(DET,"C")
If nFlag == 1
	IF nTRANSVAL # 0
		DET = REPLICATE("-",132)
		IMPR(DET,"C")
		DET := SPACE(5)+"TRANSPORTADO PAGINA ANTERIOR"+SPACE(53)+"QTDE. FUNC.:"+TRANSFORM(nTRANSFUN,"99999")	//"TRANSPORTADO PAGINA ANTERIOR"###"QTDE. FUNC.:"
		DET += SPACE(02)+TRANSFORM(nTRANSVAL,cPict2)
		IMPR(DET,"C")
		nFlag	:= 0
	ENDIF
Endif
IMPR("","C")
nTransfun 	+= tFunPag
nTransVal 	+= tPagina
tFunPag 	:= tPagina := 0
	
Return
*----------------------*
Static Function TotalCc  // Totalizador Por Centro de Custo
*----------------------*
Local Desc_Cc:=Space(40)

If (nOrdem # 2 .And. nOrdem # 5 .And. nOrdem # 7 .And. nOrdem # 10) .Or. tFunTcc == 0
	Return Nil                                     // Consistencia de Opcoes
Endif
		
If (li + 2) >= 58 
	Impr("","P")
Endif
		
Desc_Cc :=fDesc("SI3",CcAnt, "SI3->I3_DESC")  + Space(15)   // Procura Descricao do Centro de Custo
		
DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DO C.CUSTO  "+substr(DESC_CC+space(64),1,64)+" QTDE. FUNC.:"+TRANSFORM(TFUNTCC,"99999")	//"TOTAL DO C.CUSTO  "###" QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(TCC,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunTCC := Tcc := 0
Return

*-----------------------*
Static Function TotalAge  // Totalizador por Banco
*-----------------------*
Local DESC_AGE := Space(40)

If tFunAge == 0 
	Return Nil
Endif

IF (li + 2) >= 58
	IMPR("","P")
ENDIF
//��������������������������������������������������������������Ŀ
//� Funcao Para Buscar Nome do Banco ( SA6 )                     �
//����������������������������������������������������������������
Desc_Age :=AgeAnt + " " + DescBco(BcoAnt+AgeAnt,FilAnt,40,.T.) 

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL  AGENCIA  "+DESC_AGE+SPACE(18)+"   QTDE. FUNC.:"+TRANSFORM(TFUNAGE,"99999")	//"TOTAL  AGENCIA  "###"   QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(TAGENCIA,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunAge 	:= tAgencia 	:= 0
tFunPag 	:= tPagina 		:= 0
nTransval	:= nTransFun	:= 0  

If (li + 3) >= 58
	Impr("","P")
Endif
	
Return
		
*-----------------------*
Static Function TotalBan  // Totalizador por Banco
*-----------------------*
Local DESC_BCO := Space(40)

If tFunBan == 0
	Return Nil
Endif

If (li + 2) >= 58
	Impr("","P")
Endif
//��������������������������������������������������������������Ŀ
//� Funcao Para Buscar Nome do Banco ( SA6 )                     �
//����������������������������������������������������������������
Desc_Bco := BcoAnt + " " + DescBco(BcoAnt,FilAnt)

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DO BANCO  "+DESC_BCO+SPACE(20)+"   QTDE. FUNC.:"+TRANSFORM(TFUNBAN,"99999")	//"TOTAL DO BANCO  "###"   QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(TBANCO,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunBan := tBanco := 0

Return 
*-----------------------*
Static Function TotalFil  // Totalizador por Empresa
*-----------------------*
Local cDesc_Fil := FilAnt+ "*** Nao Encontrada *** "
                        
If fInfo(@aInfo,FilAnt)
	cDesc_Fil := FilAnt+ " "+ aInfo[1] + Space(22)
EndIf	

If tFunFil == 0 .Or. (nOrdem >= 6)
	Return Nil 
Endif

IF (li + 2) >= 58
	IMPR("","P")
ENDIF
	
DET = REPLICATE("-",132)
IMPR(DET,"C")

DET := SPACE(5)+"TOTAL DA FILIAL "+cDesc_Fil+SPACE(24)+"   QTDE. FUNC.:"+TRANSFORM(tFunFil,"99999")	//"TOTAL DA FILIAL "###"   QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(TFilial ,cPict2)
IMPR(DET,"C")
DET = REPLICATE("-",132)
IMPR(DET,"C")
IMPR("","C")
		
//-- Reinicializa valores para a proxima Filial 
tFunFil	:= TFilial 	:= 0
tFunPag	:= Tpagina 	:= 0 
TFunAge := TAgencia	:= 0 
tFunBan := Tbanco  	:= 0 
tFunTcc := Tcc		:= 0

Return 
*-----------------------*
Static Function TotalEmp  // Totalizador Geral
*-----------------------*
Local cDesc_Emp 	:= aInfo[3]

If tEmpresa == 0 
	Return Nil 
Endif 
    
If (li + 2) >= 58
	IMPR("","P")
ENDIF 

DET := REPLICATE("-",132) 
IMPR(DET,"C") 
DET := SPACE(5)+"TOTAL DA EMPRESA "+cDesc_Emp+SPACE(24)+"  QTDE. FUNC.:"+TRANSFORM(tFunEmp,"99999")	//"TOTAL DA EMPRESA "###"  QTDE. FUNC.:"
DET += SPACE(02)+TRANSFORM(tEmpresa ,cPict2)
IMPR(DET,"C")
DET := REPLICATE("-",132)
IMPR(DET,"C")
tFunEmp := tEmpresa:= 0

Return 

