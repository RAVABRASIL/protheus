//#INCLUDE "PONR050.CH"
#INCLUDE "PROTHEUS.CH"
//#INCLUDE "PONCALEN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PONR050  ³ Autor ³ R.H. - J. Ricardo     ³ Data ³ 10.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio para Abono                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PONR050(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mauricio MR ³17/10/01³------³ Correcao Impressao de Motivo de Abono so-³±±
±±³            ³        ³------³ mente para funcionarios que possuem.     ³±±
±±³Marinaldo   ³06/11/01³Melhor³ Consider o Turno do Calendario Para retor³±±
±±³            ³        ³------³ nar as Marcacoes						  ³±±
±±³Mauricio MR ³18/12/01³Melhor³A)Incluida Pergunta 'Listar Previsao' para³±±
±±³            ³        ³------³ listar, dia a dia, as previsoes de marca-³±±
±±³            ³        ³------³ coes. Serao impressas marcacoes/previsoes³±±
±±³            ³        ³------³ de 4 a 8 horas por linha ate o maximo de ³±±
±±³            ³        ³------³ 4 linhas. Existira alternancia do cabeca-³±±
±±³            ³        ³------³ lho dependendo das opcoes selecionadas.  ³±±
±±³            ³        ³------³B)Corrigida a impressao Sintetica com lis-³±±
±±³            ³        ³------³ tagem dos motivos de abono. Serao totali-³±± 
±±³            ³        ³------³ zadas as horas do evento no primeiro abo-³±±
±±³            ³        ³------³ no lido e totalizadas as horas abonadas  ³±±
±±³            ³        ³------³ por motivo de abono. Alterado o Sort do  ³±±
±±³            ³        ³------³ array aDet, dinstito para Sint. e Analit.³±±
±±³            ³        ³------³C)Corrigida a chamada da fabonos fornecen-³±±
±±³            ³        ³------³ do tipo de marcacao e centro de custo.   ³±± 
±±³            ³        ³------³Restaurar o n no Retorno da Funcao        ³±± 
±±³=======================================================================³±± 
±±³                         *** Versao 7.10 ***                           ³±± 
±±³=======================================================================³±± 
±±³Mauricio MR ³21/02/02³Melhor³A)Retirada de Perguntas pois foram trans- ³±± 
±±³            ³        ³      ³feridas para o SX1.                       ³±± 
±±³Mauricio MR ³27/02/02³Melhor³A)Inclusao da GetMarcacoes em substituicao³±± 
±±³            ³        ³      ³do algoritimo anterior para tratar a lei -³±±  
±±³            ³        ³      ³tura do SP8(marcacoes).                   ³±±  
±±³            ³        ³      ³B)Inclusao do PonCalen.ch e substituicao  ³±±  
±±³            ³        ³      ³dos indices dos arrays pelas Constantes   ³±±  
±±³            ³        ³      ³correspondentes.                          ³±±  
±±³Marinaldo   ³28/02/02³Melhor³Inclusao da Funcao fChkSX1() que ira inici³±±
±±³            ³        ³      ³alizar as Datas de Acordo com o Periodo de³±±  
±±³            ³        ³      ³Apontamento que sera montado a partir   da³±±  
±±³            ³        ³      ³Data Base do Sistema					  ³±±  
±±³ Priscila R.³10/06/02³------³Ajuste no relatorio para que seja impresso³±± 
±±³            ³--------³------³corretamente o C.C no tamanho 20.         ³±± 
±±³Mauricio MR ³25/09/02³016097³Complementacao da Lista de Identificadores³±± 
±±³            ³--------³------³do Ponto para Faltas/Atrasos/Saidas.      ³±±   
±±³Mauricio MR ³04/12/02³------³Retirada a restricao de existencia de cra-³±± 
±±³            ³--------³------³cha para a emissao do relatorio.	      ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PONR002() //PONR050()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1    := "Relatorio para Abono"
Local cDesc2    := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3    := "usuario."
Local cString   :="SRA"        // alias do arquivo principal (Base)
Local aOrd 		:= {"Matricula","Centro de Custo","Nome","Turno","C.Custo+Nome"}
Local wnRel
Local cCodAut 	:= "008,010,012,014,018,020,022,032,034" //-- Codigos Autorizados
Local cCodNAut 	:= "007,009,011,013,017,019,021,033,035" //-- Codigos Nao Autorizados
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := { "Zebrado" , 1,"Administracao" , 1, 2, 1, "",1 } // "Zebrado"###"Administracao"
PRIVATE nomeprog:="PONR050"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "PNR050"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo  :=OemToAnsi("Relatorio para Abono")
PRIVATE cCabec
PRIVATE AT_PRG  := "PONR002"  //"PONR050"
PRIVATE wCabec0 := 1
PRIVATE wCabec1 := "Chapa Matr.  Funcionario                         Data   Cod Descricao            Horas  Justificativa                Visto"
PRIVATE CONTFL  :=1
PRIVATE LI      :=0
PRIVATE nTamanho:="N"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nOrdem
PRIVATE aInfo   :={}
PRIVATE lPrevisao:= .F.          

//-- Periodo de Apontamento
Private dPerIni := CTOD("")
Private dPerFim := CTOD("")
If !PerAponta(@dPerIni,@dPerFim)
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza as Datas no SX1                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fChkSX1( dPerIni , dPerFim , cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PNR050",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Turno De                                 ³
//³ mv_par06        //  Turno Ate                                ³
//³ mv_par07        //  Matricula De                             ³
//³ mv_par08        //  Matricula Ate                            ³
//³ mv_par09        //  Nome De                                  ³
//³ mv_par10        //  Nome Ate                                 ³
//³ mv_par11        //  Situacao                                 ³
//³ mv_par12        //  Categoria                                ³
//³ mv_par13        //  Imprime C.C em outra Pagina              ³
//³ mv_par14        //  Dia Inicial                              ³
//³ mv_par15        //  Dia Final                                ³
//³ mv_par16        //  Imprimir Abonados                        ³
//³ mv_par17        //  Imprimir Autorizados/Nao Autorizados/Ambo³
//³ mv_par18        //  Relatorio Sintetico/Analitico            ³
//³ mv_par19        //  Quebra Func.Pag. Sim/Nao                 ³
//³ mv_par20        //  Imprimir Motivo Abono                    ³
//³ mv_par21        //  Imprimir Marca‡äes                       ³
//³ mv_par22        //  Regra De                                 ³
//³ mv_par23        //  Regra Ate                                ³
//³ mv_par24        //  Listar Previsao                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="PONR050"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]
FilialDe := mv_par01
FilialAte:= mv_par02
CcDe     := mv_par03
CcAte    := mv_par04
TurDe    := mv_par05
TurAte   := mv_par06
MatDe    := mv_par07
MatAte   := mv_par08
NomDe    := mv_par09
NomAte   := mv_par10
cSit     := mv_par11
cCat     := mv_par12
lCC      := If(mv_par13 == 1,.T.,.F.)
nTipo    := mv_par17
nSinAna  := mv_par18
lImpFol	 := If(mv_par19 == 1,.T.,.F.)
lImpMot  := IF(mv_par20 == 1,.T.,.F.)
lImpMar  := IF(mv_par21 == 1,.T.,.F.)
RegDe    := mv_par22
RegAte   := mv_par23
lPrevisao:= IF(mv_par24 == 1,.T.,.F.)  //.T. - Lista Horario Previsto

If mv_par14 > mv_par15
   Help(" ",1,"PNR050DATA")
   Return Nil
Endif
lImpAbon := If(Mv_Par16 == 1,.T.,.F.)  
If	nLastKey = 27
    Return Nil
Endif       

//-- Para Relatorio Sintetico nao imprime Previsao e/ou Marcacao
If nSinAna==1
   lPrevisao:=.F.
   lImpMar	:=.F.
Endif

//-- Altera Relatorio se Previsao e/ou Marcacao forem ou nao impressas
wCabec1 :=If(lPrevisao  .AND.  lImpMar ,PADR('STR0024'+SPACE(17)+'STR0025',51)+'STR0011',;
          If(lPrevisao  .AND. !lImpMar ,PADR('STR0024',51)+'STR0011',;
          If(!lPrevisao .AND.  lImpMar ,PADR('STR0025',51)+'STR0011',;
              Padr('STR0012'+SPACE(1)+'STR0013'+SPACE(2)+'STR0014',51)+'STR0011')))

SetDefault(aReturn,cString)

If nLastKey = 27
    Return Nil
Endif

// Identificadores de Ponto
If nTipo = 1 
	cCodigos := cCodaut
Elseif nTipo = 2
	cCodigos := cCodNAut
ElseIf nTipo = 3
	cCodigos := cCodAut+','+cCodNAut
Endif	

dInicio := mv_par14
dFim    := mv_par15

cCabec  := "Relatorio para Abono"

Titulo  := OemToAnsi(cCabec)

RptStatus({|lEnd| PO050Imp(@lEnd,wnRel,cString)},Titulo)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PO050Imp ³ Autor ³ R.H. - J. Ricardo     ³ Data ³ 10.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio para abono                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ PO050Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PO050Imp(lEnd,WnRel,cString)
Local aAutorizado  := {}
Local aJustifica   := {}	//-- retorno Justificativa de abono
Local xQuant       := 0
Local nPos         := 0
Local cPD          := Space(03)
Local cAcessaSRA := &("{ || " + ChkRH("PONR050","SRA","2") + "}")
Local cAcessaSPC := &("{ || " + ChkRH("PONR050","SPC","2") + "}")
Local nTab	     :=0
Local nPosTab	 :=0
Local nLenCalend :=0
Local aPrevFun   :={}
Local cOrdem	 :=''
Local nLimite    := 0
Local nX		 := 0
Local cCol1      := ''
Local cCol2      := ''
Local nFor		 := 0

Private cDet	 := ''
Private cDet1  	 := ''
Private cDet2	 := ''
Private cDet3	 := ''
Private nVez	 := 0
Private cItem    := ''
Private lImpLinhas:= '' 


Private aDet       := {}
Private lCabec     := .F.
Private lCabecCC   := .F.
Private lCabecTT   := .F.
Private lPrimeira  := .T.
Private aMarcFun   := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aMarcacoes := {}
Private nPosMarc   := 0 
Private nLenMarc   := 0

dbSelectArea( "SRA" )
dbGoTop()
DbSetOrder(nOrdem)
If nOrdem == 1
	dbSeek(FilialDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := FilialAte + CcAte + MatAte
	lCabecCC := IF(!lImpFol,.T.,.F.)
ElseIf nOrdem == 3
	dbSeek(FilialDe + NomDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := FilialAte + NomAte + MatAte
ElseIf nOrdem == 4
	dbSeek(FilialDe + TurDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_TNOTRAB"
	cFim     := FilialAte + TurAte
	lCabecTT := IF(!lImpFol,.T.,.F.)
ElseIf nOrdem == 5
	dbSetOrder(8)
	dbSeek(FilialDe + CcDe + NomDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
Endif

SetRegua(SRA->(RecCount()))

cTnoAnt      := 'úúú'
cSeqAnt      := 'úú'
cTurnoant    := "@@@"
cFilAnterior := "@@"
cCcAnt       := Replicate('@',Len(SRA->RA_CC))
dbSelectArea( "SRA" )
While !EOF() .And. &cInicio <= cFim
	IncRegua()

	If lEnd
		IMPR(cCancela,"C")
		Exit
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		SRA->(dbSkip())
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_Nome < NomDe)    .Or. (SRA->RA_Nome > NomAte) .Or. ;
		(SRA->RA_Mat < MatDe)     .Or. (SRA->RA_Mat > MatAte)  .Or. ;
		(SRA->RA_CC < CcDe)       .Or. (SRA->RA_CC > CCAte) .OR. ;
		(Sra->RA_TNOTRAB < TurDe) .Or. (SRA->RA_TNOTRAB > TurAte) .Or. ;
		(Sra->RA_REGRA < RegDe)   .Or. (SRA->RA_REGRA > RegAte)
		Sra->(dbSkip())
		Loop
	Endif

	If  (SRA->RA_DEMISSA < dInicio .AND. ! Empty(SRA->RA_DEMISSA))
		SRA->(DbSkip())
		Loop
	Endif

	If !(Sra->Ra_SitFolh $ cSit) .Or. !(Sra->Ra_CatFunc $ cCat)
		DbSkip()
		Loop           // Testa Categoria e Situacao
	Endif

	If SRA->RA_FILIAL # cFilAnterior // quebra filial
		lCabec := .T.
		cFilAnterior := SRA->RA_Filial
		cTurnoAnt := "@@@"
		cCcAnt       := Replicate('@',Len(SRA->RA_CC))
		DbSelectArea("SP9")
		If !DbSeek(cFilAnterior)
			If !DbSeek("  ")
				Exit
			Endif
		Endif

		cFilCompara := SP9->P9_FILIAL
		aAutorizado := {}
		While ! Eof() .AND. SP9->P9_FILIAL = cFilCompara

			If Subs(P9_IDPON,1,3) $ cCodigos
				Aadd(aAutorizado,{Left(P9_CODIGO,3),P9_DESC})
			Endif
			DbSkip()
		EndDo
	Endif

	If nOrdem == 4 .And. cTurnoAnt # SRA->RA_TNOTRAB 
		If !lImpFol
			lCabecTT := .T.
		Endif
		cCcAnt    := Replicate('@',Len(SRA->RA_CC))
		cTurnoAnt := SRA->RA_TNOTRAB
	Endif

	If (nOrdem == 2 .Or. nOrdem == 5) .AND. SRA->RA_CC # cCcAnt
		If lCc
			lCabec := .T.
		Endif
		lCabecCC := .T.
	Endif
	cCcAnt := SRA->RA_CC
	cTurnoAnt := SRA->RA_TNOTRAB
	dDtMarc:=CtoD("  /  /  ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Calendario de Marca‡oes do Periodo                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTnoAnt + cSeqAnt # SRA->RA_TNOTRAB + SRA->RA_SEQTURN
		cTnoAnt    := SRA->RA_TNOTRAB
		cSeqAnt    := SRA->RA_SEQTURN	
	Endif

	//-- Cria Calendario com o periodo completo com Trocas de Turno
	aMarcacoes := {}
	//-- Carrega as Marcacoes do Periodo
	/*
	IF !GetMarcacoes( @aMarcacoes		,;	//01 -> Marcacoes dos Funcionarios
					  @aTabCalend		,;	//02 -> Calendario de Marcacoes
					  @aTabPadrao		,;	//03 -> Tabela Padrao
					  NIL				,;	//04 -> Turnos de Trabalho
					  dPerIni 			,;	//05 -> Periodo Inicial
					  dPerFim			,;	//06 -> Periodo Final
					  SRA->RA_FILIAL	,;	//07 -> Filial
					  SRA->RA_MAT		,;	//08 -> Matricula
					  SRA->RA_TNOTRAB	,;	//09 -> Turno
					  SRA->RA_SEQTURN	,;	//10 -> Sequencia de Turno
					  SRA->RA_CC		,;	//11 -> Centro de Custo
					  "SP8"				,;	//12 -> Alias para Carga das Marcacoes
					  .F.    			,;	//13 -> Se carrega Recno em aMarcacoes
					  .T.      			,;	//14 -> Se considera Apenas Ordenadas
					  .T.      			,;	//15 -> Se Verifica as Folgas Automaticas
					  .F.      			,;	//16 -> Se Grava Evento de Folga Automatica Periodo Anterior
					  NIL				,;	//17 -> Se Carrega as Marcacoes Automaticas
					  NIL				,;	//18 -> Registros de Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//19 -> Bloco para avaliar as Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//20 -> Se Considera o Periodo de Apontamento das Marcacoes
					  .F.				 ;	//21 -> Se Efetua o Sincronismo dos Horarios na Criacao do Calendario
					)
		Set Device to Screen
		Help(' ',1,'PONSCALEND')
		Set Device to Printer
		cTnoAnt := 'úúú'
		cSeqAnt := 'úú'
		Sra->(dbSkip())
		Loop
    EndIF
    */  //FR - para não exigir marcações no período
	
	//-- Obtem Qtde de Marcacoes
	nLenMarc:=Len(aMarcacoes)


	aDet := {}

	// 1 - Data
	// 2 - Codigo do Evento
	// 3 - Descricao do Evento
	// 4 - Descricao do Abono
	// 5 - Descricao do Abono
	// 6 - Quantidade de horas Abonadas
	// 7 - Marcacoes

	dbSelectArea( "SPC" )
	If DbSeek(SRA->RA_Filial + SRA->RA_Mat )
		While !Eof() .And. SPC->PC_Filial+SPC->PC_Mat == SRA->RA_filial+SRA->RA_Mat

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste controle de acessos e filiais validas               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Eval(cAcessaSPC)
				SPC->(dbSkip())
				Loop
			EndIf

			//-- Verifica o Periodo Solicitado
			If Empty(SPC->PC_DATA) .OR. SPC->PC_DATA < dInicio .OR. SPC->PC_DATA > dFim
				DbSkip()
				Loop
			Endif

			//-- Verifica se Deve Imprimir os Abonados
			If !lImpAbon .And. SPC->PC_QTABONO > 0
				dbSkip()
				Loop
			Endif

			//-- Utiliza o codigo informado qdo houver
			cPD := If(Empty(SPC->PC_PDI),SPC->PC_PD,SPC->PC_PDI)

			//-- Verifica se e um codigo contido na relacao de codigos 
			//-- definidas segundo avariavel cCodigos
			nPos := Ascan(aAutorizado,{ |x| x[1] = cPD })
            //-- Se o Codigo do Evento apontado  eh Valido
			If nPos > 0
				//-- Obtem a quantidade do evento apontando
				xQuant := If(SPC->PC_QUANTI>0,SPC->PC_QUANTI,SPC->PC_QUANTC)
                //-- Posiciona na TabCalend para a Data Lida
                nTab := aScan(aTabCalend, {|x| x[CALEND_POS_DATA] == SPC->PC_DATA .And. x[CALEND_POS_TIPO_MARC] == '1E' })
				//-- Se existir calendario para o apontamento
				//-- Obs.: Se um apontamento for digitado pode ocorrer de nao ter
				//--       uma data correspondente na TabCalend ???
				If nTab>0
			  	   //-- Obtem a Ordem para a Data Lida
			  	   cOrdem    := aTabCalend[nTab,CALEND_POS_ORDEM] //-- Ordem		
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem as Previsoes Cadastradas p/a Ordem Lida  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aPrevFun:={}
					If lPrevisao 
					    nLenCalend:=Len(aTabCalend)
					    nPosTab:=nTab
						//-- Corre as Previsoes de mesma Ordem
						While cOrdem == aTabCalend[nPosTab,CALEND_POS_ORDEM]
						    Aadd(aPrevFun,StrTran(StrZero(aTabCalend[nPosTab,CALEND_POS_HORA],5,2),'.',':'))
							//-- Obtem novo Horario	          			 
							nPosTab ++                  
							If	nPosTab > nLenCalend
							    Exit
							Endif    
						EndDo	
					Endif                                              
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem as Marcacoes Realizadas para a Ordem Lida³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aMarcFun:={}
					If lImpMar
						//-- A aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
						//-- de acordo com a ordem da tabela
						nPosMarc:=Ascan(aMarcacoes,{|x| x[3]==cOrdem})
						//-- Se Existir Marcacao para o Dia
						If !Empty(nPosMarc)
							//--  Corre Todas as marcacoes enquanto a mesma ordem
							While cOrdem == aMarcacoes[nPosMarc,3]
								  //-- Monta o array com as Marcacoes do funcionario para a ordem.
								  Aadd(aMarcFun,StrTran(StrZero(aMarcacoes[nPosMarc,2],5,2),'.',':'))
						 		  nPosMarc++
						 		  //-- Se o contador ultrapassar o total de Marcacoes abandona loop
						 		  If nPosMarc>nLenMarc
						 			 Exit
						 		  Endif   
							EndDo
					    Endif
				    Endif
				Endif

				aJustifica := {}
				If lImpMot
					//-- Verifica se existe abonos e posiciona registro de abono
					fAbonos(SPC->PC_DATA, aAutorizados[nPos,1],,@aJustifica,SPC->PC_TPMARCA,SPC->PC_CC)
        		Endif

				If nSinAna == 1	// Sintetica                  
				    //-- Sintetiza por Evento
					If (nPosDet:=Ascan(aDet,{ |x| x[2] = cPD })) > 0
						aDet[nPosDet,4]:=SomaHoras(aDet[nPosDet,4],xQuant)
						//-- Acumula Abonado somente se Nao for imprimir os motivos do mesmo
						aDet[nPosDet,6]		:=If(Empty(aDet[nPosDet,6]),SomaHoras(aDet[nPosDet,6],SPC->PC_QTABONO),aDet[nPosDet,6])
						aDet[nPosDet,12]	:='A' //Ordem para Obrigar que esse seja o primeiro elemento
												  //apos o Sort do aDet	
				    Endif
 					//-- Acrescenta os motivos de abono para o evento
					If Len(aJustifica) > 0 .And. lImpMot
						For nX := 1 To Len(aJustifica)
							//-- Totaliza cada motivo para o mesmo evento
							If (nPosDet:=Ascan(aDet,{ |x| x[2] = cPD .AND. x[11]==aJustifica[nX,1]})) > 0
								//-- Totaliza Abonos para mesmo motivo
								aDet[nPosDet,6]:=SomaHoras(aDet[nPosDet,6],aJustifica[nX,2])
							Else
								aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,xQuant,;
								PADR(DescAbono(aJustifica[nX,1],'C'),25),;
								aJustifica[nX,2],aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,	aJustifica[nX,1],'Z'})
							Endif
						Next nX
					Else
							If nPosDet==0
							   aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant,;
						       	SPACE(25),0,aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'Z'})
						    Endif   	
					Endif
				Else
					If Len(aJustifica) > 0 .And. lImpMot
						For nX := 1 To Len(aJustifica)
		    	    	    aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] , xQuant,;
							PADR(DescAbono(aJustifica[nX,1],'C'),25),aJustifica[nX,2],aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'A' })
						Next nX
					Else
						aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant,;
						SPACE(25),0,aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'A'  })
					Endif
				Endif
			Endif
			DbSkip()
		EndDo

 		If Len(aDet) > 0
			//-- O Sort para Analitico e por Data e ordem 
			If nSinAna==2
		  	   aSort(aDet,,,{|x,y| Dtos(x[1])+x[12] < Dtos(y[1])+y[12]}) //Data+ordem de leitura
			Else 
   				//-- O Sorte no Sintetico e por Evento 
   				aSort(aDet,,,{|x,y|x[2]+x[12] < y[2]+y[12]}) //Data+ordem de leitura			
			Endif                  
			
			dDtMarc:=CtoD("  /  /  ")
			//-- Corre Cada Apontamento
			For nFor := 1 To Len(aDet)
				cDet :=""
			
				//Verifica a Quebra de Data
				If  dDtMarc<>aDet[nFor,1] 
				    //-- Monta Inicio das linhas
				    //-- se previsoes e/ou marcacoes forem impressas  a Cada Data
				    dDtMarc:=aDet[nFor,1]
				    nVez:=0
				    If lImpMar .OR. lPrevisao
						cDet1:=""	// Impressao da Continuacao das Marcacoes/Previsoes
						cDet2:=""	// Impressao da Continuacao das Marcacoes/Previsoes
						cDet3:=""	// Impressao da Continuacao das Marcacoes/Previsoes		
						nVez :=0    // Contador auxiliar para apontar as cDet's
						aMarc  :=aDet[nFor,7] 
						aPrev  :=aDet[nFor,8] 
						nPrev  :=Len(aPrev)
						nMarc  :=Len(aMarc)
						nLimite:=Max(nPrev,nMarc)
						cCol1  := ''
						cCol2  := ''
						
						For nX:=1 to nLimite      
						   //-- Imprime Marcacao, mas nao imprime Previsao
						   If !lPrevisao .AND. lImpMar
							    If nX > 8
									cDet1+=aMarc[nX]+" "
								Else
									cDet+=aMarc[nX]+" "
								Endif                                     
							//-- Imprime Previsao, mas nao imprime Marcacao	
						   ElseIf lPrevisao .AND. !lImpMar
						        If nX > 8
									cDet1+=aPrev[nX]+" "
								Else
									cDet+=aPrev[nX]+" "
								Endif                                     
							//-- Imprime Previsao e Marcacao	
						   Else
						   		//-- Monta Cada Coluna ao Total de 4 marcacoes cada uma
						   		cCol1 +=If(nX<=nPrev,aPrev[nX],SPACE(5)) +" "
							   	cCol2 +=If(nX<=nMarc,aMarc[nX],SPACE(5)) +" "
						   		Do Case
							   		//-- A Cada Multiplo de 4 ou se Ultima Marcacao e Linha
							   		//-- Vazia Preenche-a
							   		
							   		Case nX =4 .OR. (nX == nLimite .AND. Empty(cDet))
							   		  cDet:=Padr(cCol1,24)+"| "+Padr(cCol2,24)
							   		  cCol1:=cCol2:=''
									Case nX =8 .OR. (nX == nLimite .AND. Empty(cDet1))
							   		  cDet1:=Padr(cCol1,24)+"| "+Padr(cCol2,24)
							   		  cCol1:=cCol2:=''						   		  
							   		Case nX =12 .OR. (nX == nLimite .AND. Empty(cDet2))
							   		  cDet2:=Padr(cCol1,24)+"| "+Padr(cCol2,24)
							   		  cCol1:=cCol2:=''
						   	   		Case nX =16 .OR. (nX == nLimite .AND. Empty(cDet3))
							   		  cDet3:=Padr(cCol1,24)+"| "+Padr(cCol2,24)
							   		  cCol1:=cCol2:=''
						   		EndCase
	  					   Endif
						Next
						cDet :=Padr(cDet,51)                    
						cDet1:=Padr(cDet1,51)
	                	cDet2:=Padr(cDet2,51)
	                	cDet3:=Padr(cDet3,51)
	                Else
						//--Reinicializa Variaveis se nao for imprimir previsoes/marcacoes
						cDet1:=""	// Impressao da Continuacao das Marcacoes/Previsoes
						cDet2:=""	// Impressao da Continuacao das Marcacoes/Previsoes
						cDet3:=""	// Impressao da Continuacao das Marcacoes/Previsoes
	                Endif	
            	Endif         
                      
               
                //-- Se nao for a 1a. vez, altera o inicio das linhas referentes as marcacoes/previsoes
                //-- Acrescenta as Marcacoes/Previsoes
                If nVez>0
               		                              
					If nVez<4 //- Imprime as Demais cDet                
					    cItem		:=Alltrim(STR(nVez,0))
					    cDet		:=Padr(cDet&cItem,90)
					    cDet&cItem	:=''
					Endif
				Else
				   nVez++
				Endif

			    //-- Acrescenta Data/CodEvento/DescEvento/Hora
                If nvez>3 //Apos imprimir Todas as possiveis marcacoes/previsoes
                	cDet := If(nSinAna == 1,Space(90),Space(51)+'|'+Space(39))
                Else
					xQuant := StrZero(aDet[nFor,4],6,2)
					xQuant := STRTRAN(xQuant,".",":")
					
					cDet :=Padr(cDet,51)   
	            	//-- Se o Tipo de Apontamento for mesmo que o anterior nao imprime
	            	//-- Data/CodEvento/DescEvento/Hora
	            	If nFor > 1 .And.;
							((nSinAna == 2 	.AND. aDet[nFor-1,1] == aDet[nFor,1] ;  	//Data
						            		.AND. aDet[nFor-1,2] == aDet[nFor,2];  	//Evento 
						            		.AND. aDet[nFor-1,9] == aDet[nFor,9];  	//Tp.Marcacao
						            		.AND. aDet[nFor-1,10] == aDet[nFor,10]);  //C.C.
						    .OR.  ;
						    (nSinAna == 1 	.AND. aDet[nFor-1,2] == aDet[nFor,2]))  //Evento    
						   cDet+=If(nSinAna == 1,'','|')+Space(39)
					Else
						cDet += If(nSinAna == 1,Space(5),'|'+SubStr(Dtos(aDet[nFor,1]),7,2)+"/"+SubStr(Dtos(aDet[nFor,1]),5,2)) + "  " + aDet[nFor,2] + " " + aDet[nFor,3] + " "+ xquant + " "
					Endif
				Endif
				
				//-- Acrescenta Motivo ou Traco para Justificativa
				If lImpMot  
					If !Empty(aDet[nFor,5]) //-- Evento Com Abonos a Imprimir na Data Lida
						//-- Motivo do Abono
						cDet +=aDet[nFor,5] + Space(2)
						If aDet[nFor,6] > 0
							cDet+= " "+ STRTRAN(StrZero(aDet[nFor,6],6,2),".",":")
						Endif
 					Else
						cDet+= Repl("_",24) + Space(2) + Repl("_",15)
					Endif
				Else
					cDet+= Repl("_",24) + Space(2) + Repl("_",15)
				Endif

				If Li <> 60 .And. nFor > 1
					Impr(" ","C")
				Endif

                //--Imprime Nome Somente na 1a. Linha Detalhe
				F050ImprL(cDet,if(nFor > 1 .And. aDet[nFor-1,1] == aDet[nFor,1],.F.,.T.), nFor)

                //--Forca a Impressao das Marcacoes/Previsoes se Nao houver abonos e for o ultimo apontamento
		        //--ou se o proximo apontamento for de outra Data
		        If nFor+1<len(aDet)  
		           lImpLinhas:=If(Empty(aDet[nFor,5]) .AND. aDet[nFor+1,1]<>dDtMarc,.T.,.F.)
		        Else
		           lImpLinhas:=If(Empty(aDet[nFor,5]),.T.,.F.)
		        Endif                                       
		         
		        //--Imprime as Marcacoes/Previsoes se Nao Deseja imprimir o motivo do abono 
		        //-- ou forca a impressao das linhas
		        If !lImpMot  .OR. lImpLinhas
		           If !Empty(cDet1)
		              F050ImprL(cDet1,.F., nFor)
		              cDet1:=''
		           Endif 
		           If !Empty(cDet2)
		              F050ImprL(cDet2,.F., nFor)
		              cDet2:=''
		           Endif
		           If !Empty(cDet3)
		              F050ImprL(cDet3,.F., nFor)
		              cDet3:=''
		           Endif  
		        Endif

			Next nFor

			If Li <> 60
				Impr(Repl("-",132),"C")
			Endif

			If lImpFol
				Impr("","P")
				lCabec:=.T.
			Endif
		Endif
	Endif
	DbSelectArea("SRA")
	DbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SP8" )
dbSetOrder(1)

dbSelectArea("SRA")
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Imp_Cabec ³ Autor ³ J.Ricardo             ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do Relatorio de Presentes/Ausentes     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR030IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
====================================================================================================
Chapa Matr.  Funcionario                    Data   Cod Descricao            Horas Justificativa                 Visto"
====================================================================================================
Filial: 01-123456789012345  Turno: 001-12345678901234567890    C.C: 123456789-1234567890123456789012
====================================================================================================
12345 123456 123456789012345678901234567890
99:99 99:99 99:99 99:99 99:99 99:99 99:99   99/99  999 1234567890123456789 999.99 12345678901234567890123456789 12345678901234567890
/*/
Static Function Imp_Cabec
Local cDet
cDet := "Filial: " + SRA->RA_FILIAL + "-" + Left(SM0->M0_Nome+Space(15),15) //"Filial: "

Li   :=0

If lImpFol
	cDet+= " Turno: "+SRA->RA_TNOTRAB // " Turno: "
	cDet+= "    C.C: " + SUBSTR(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "    C.C: "
    Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
Endif

IMPR(cDet,"C")
IMPR(Repl("=",132),"")
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³f050ImprL ³ Autor ³ Aldo Marini Junior    ³ Data ³ 30/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime detalhe verificando a necessidade de pulo de pagina³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³f050ImprL(cString)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function f050ImprL(cString,lImpNome, nFor)
Local cNome:=SRA->RA_CHAPA + " " + SRA->RA_MAT + " " + Left(SRA->RA_NOME,30) + " "
Local lCab:=.F.
Local cDet1:=" "
//-- Altera o SubCabec se analitico com impressao de previsao ou de marcacoes
If nSinAna == 2  .AND. (lPrevisao .OR. lImpMar)
   cNome:='Chapa: '+SRA->RA_CHAPA + " " + 'Matricula: '+SRA->RA_MAT + " " + 'Nome: '+Left(SRA->RA_NOME,30) + SPACE(5)
Endif 
//-- Deve imprimir o nome ? 
lImpNome := If(lImpNome == Nil, .T., lImpNome)

// Caso seja primeira linha do Detalhe , imprime o Nome do Func.
If nFor == 1 .Or. Li == 60 .Or. Li == 8
	If Li == 60
		lCabec:=.T.

		If !lImpFol
			If nOrdem == 2 .Or. nOrdem == 5
				lCabecCC:=.T.
			Endif
			If nOrdem = 4 
				lCabecTT := .T.
			Endif
		Endif	
	Endif	

	If (lImpMar .OR. lPrevisao) .And. nSinAna == 2
		lCab:=.T.
	Else

		cString := SubStr(cString,50,Len(cString)-49)
		cString := cNome+Space(05)+cString
	Endif	
Endif

If lCabec
	Imp_Cabec()
	lCabec := .F.
Endif

If lCabecCC
		cDet1 := "C.C: " + SUBSTR(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "C.C: "
		Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
	IMPR(cDet1,"C")
	If Li <> 60
		IMPR(REPLICATE("-",132),"C")
	Endif
	lCabecCC := .F.
Endif

If lCabecTT
	cDet1 := " Turno: "+SRA->RA_TNOTRAB +"-"+ fDescTno(SRA->RA_FILIAL,SRA->RA_TNOTRAB) // " Turno: "
	IMPR(cDet1,"C")
	If Li <> 60
		IMPR(REPLICATE("-",132),"C")
	Endif
	lCabecTT := .F.
Endif

If Li < 60
	If lCab .And. lImpNome
		IMPR(cNome,"C")
		lCab:=.F.
	Endif

Endif	

If Li == 60
	Imp_Cabec()
	If (nOrdem == 2 .Or. nOrdem == 5).And. !lImpFol
		cDet1 := "C.C: " + SUBSTR(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "C.C: "
		Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
		IMPR(cDet1,"C")
		IMPR(REPLICATE("-",132),"C")
	Endif

	If nOrdem == 4 .And. !lImpFol
		cDet1 := " Turno: "+SRA->RA_TNOTRAB +"-"+ fDescTno(SRA->RA_FILIAL,SRA->RA_TNOTRAB) // " Turno: "
		IMPR(cDet1,"C")
		If Li <> 60
			IMPR(REPLICATE("-",132),"C")
		Endif
	Endif

	If (lImpMar .OR. lPrevisao) .And. nSinAna == 2
		IMPR(cNome,"C")
	Else
		cString := SubStr(cString,50,Len(cString)-49)
		cString := cNome+Space(05)+cString
	Endif	
Endif

IMPR(cString,"C")

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fChkSX1  ³ Autor ³ Marinaldo de Jesus    ³ Data ³13/02/2002³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Verifica se os Parametros de Periodo estao corretos        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ PONM040                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fChkSX1( dPerIni , dPerFim , cPerg )

Local aAreaSX1	:= SX1->( GetArea() )
Local dVar      := Ctod("//")

SX1->(dbSetOrder(1))

IF SX1->(dbSeek(cPerg+"14",.F.))
	dVar := Ctod(SX1->X1_CNT01,'ddmmyy')
	IF dVar < dPerIni .or. dVar > dPerFim
		RecLock("SX1")
		SX1->X1_CNT01 := Dtoc(dPerIni)
		SX1->( MsUnlock() )
	EndIF
	SX1->( dbSkip() )
	IF SX1->( X1_GRUPO + X1_ORDEM ) == cPerg+"15"
		dVar := Ctod(SX1->X1_CNT01,'ddmmyy')
		IF dVar < dPerIni .Or. dVar > dPerFim
			RecLock("SX1")
			SX1->X1_CNT01 := Dtoc(dPerFim)
			SX1->( MsUnlock() )
		EndIF
	EndIF
EndIF

RestArea( aAreaSX1 )

Return( NIL )
