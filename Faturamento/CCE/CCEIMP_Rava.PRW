#INCLUDE "rwmake.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TOTVS.CH"

//Rodar antes para criar as procedure no banco   *RODAR SEPARADAS

/*

Create Procedure CCE
(  @IN_STR char(255),  @Versao varchar(4) Output,  @Id_lote varchar(1) Output,  @Id_Evento varchar(54) Output,
@Orgao varchar(2) Output,  @Ambiente varchar(1) Output,  @CNPJ varchar(14) Output,  @Chave_Acesso varchar(44) Output,
@Data_Evento varchar(10) Output,  @Hora_Evento varchar(8) Output,  @Cod_Evento varchar(6) Output,
@Seq_Evento varchar(1) Output,  @Versao_Evento varchar(3) Output,  @Det_Evento varchar(4) Output,
@Desc_Evento varchar(17) Output,  @Correcao varchar(8000) Output,  @Cond_Uso varchar(8000) Output  )
WITH RECOMPILE  AS BEGIN
select  	@Versao = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('versao=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 4),
@Id_lote = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),  	CHARINDEX('<idLote>',
CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 1),
@Id_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<infEvento Id=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+15, 54),
@Orgao = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),  	CHARINDEX('<cOrgao>',
CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 2),
@Ambiente = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<tpAmb>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+7, 1),
@CNPJ = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<CNPJ>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+6, 14),
@Chave_Acesso = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<chNFe>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+7, 44),
@Data_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<dhEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10, 10),
@Hora_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<dhEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+21, 8),
@Cod_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<tpEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10, 6),
@Seq_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<nSeqEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+12, 1),
@Versao_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<verEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+11, 3),
@Det_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<detEvento versao=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+19, 4),
@Desc_Evento = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<descEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+12, 17),
@Correcao = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+11,
CHARINDEX('</xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-
CHARINDEX('<xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-11 ),
@Cond_Uso = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('<xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10,
CHARINDEX('</xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-
CHARINDEX('<xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-10 )
--from P11.dbo.SPED050
from P11.dbo.SPED150 --Tchelo falou q tem q ser esta tabela
where NFE_CHV = @IN_STR  	and D_E_L_E_T_ <> '*'  end



Create Procedure NFeId (  @IN_STR char(255), @OUT_STR varchar(8000) OUTPUT  )
WITH RECOMPILE  AS BEGIN
select @OUT_STR = substring(  	CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),
CHARINDEX('infNFe Id=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+14, 44)
--from SPED_CTB.dbo.SPED050  	where NFE_ID = @IN_STR
from P11.dbo.SPED050  	where NFE_ID = @IN_STR  -- BANCO RAVA
and D_E_L_E_T_ <> '*'  END


/*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCEIMP    ºAutor  ³Fgarcia             º Data ³  09/18/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   CARTA DE CORREÇÃO PULVITEC                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VERSÃO 11                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function CCEIMP()

SetPrvt("TAMANHO,WNREL,ARETURN,NLASTKEY,NTIPO,NTIPOA,CSTRING")
SetPrvt("LEND,TITULO,TITULO2,CDESC1,CDESC2,CDESC3,CPERG")
SetPrvt("NOMEPROG,M_PAG,aResult,aLinhas,vQuery")
Tamanho  := "P"
wnRel    := 'CCEIMP'
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
nLastKey := 0
nTipo    := 18
cString  :="CCEIMP"
lEnd     :=.F.
cDesc1   := "CARTA DE CORREÇÃO ELETRONICA (CC-E)"
cDesc2   := ""
cDesc3   := ""
cPerg    := ""
nomeprog := "CCEIMP"
nLastKey := 0
cabec1   := ""
cabec2   := ""
m_pag    := 01
aResult  := {}
aLinhas  := {}
vQuery   := ""

cperg    := "CCEIMP"

aHelp := {}
AAdd( aHelp, 'Informe o número da Nota Fiscal que     ' )
AAdd( aHelp, 'deseja imprimir a Carta de Correção     ' )
PutSX1( cPerg,"01","Número da Nota Fiscal?","Número da Nota Fiscal?","Número da Nota Fiscal?","mv_ch1","C",TamSX3("F2_DOC")[1],0,1,"C","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

aHelp := {}
AAdd( aHelp, 'Informe a série da Nota Fiscal que      ' )
AAdd( aHelp, 'deseja imprimir a Carta de Correção     ' )
PutSX1( cPerg,"02","Série da Nota Fiscal?","Série da Nota Fiscal?","Série da Nota Fiscal?","mv_ch2","C",TamSX3("F2_SERIE")[1],0,1,"C","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

IF !Pergunte(cPerg,.T.)
	Return
Endif
titulo   := "CARTA DE CORREÇÃO ELETRONICA - CCE"

Processa({|| Geracce()},"Gerando Dados")
If !Empty(aResult[1])
	RptStatus({|| Impcce()},"Imprimindo")
Else
	MsgInfo("NF-e não possui Carta de Correção... FAVOR VERIFICAR!")
EndIf

Return

**************************
Static Function Geracce() 
**************************

Local cError   := ""
Local cWarning := ""
Local oXml := NIL
Private cCli := ""
Private cLJ  := ""
Private cCNPJ:= ""
Private vNfeId := ""

vNfeId := mv_par02+mv_par01    //série + número nota

SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + mv_par01 + mv_par02 ))
cCli := SF2->F2_CLIENTE
cLJ  := SF2->F2_LOJA

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCli + cLj ))
cCNPJ := SA1->A1_CGC

//aResult := TCSPEXEC("NFeId",vNfeId)
aResult := TCSPEXEC("NFeId",vNfeId) //chama a procedure
IF empty(aResult)
	MsgInfo("Erro na execução do relatorio : "+TcSqlError()+" " )
	Return
EndIf

vNfeChv := AllTrim(aResult[1])
aResult := {}
If !Empty(vNfeChv)
	aResult := TCSPEXEC("CCE",vNfeChv )    //chama a procedure
	IF empty(aResult)
		MsgInfo("Erro na execução do relatorio: "+TcSqlError()+" ")
		Return
	Endif
EndIf
Return(.T.)

*************************
Static Function ImpCCE() 
*************************

Private cCli := ""
Private cLJ  := ""
Private cCNPJ:= ""


nLin       := 10000
nCol	   := 800
nPage	   := 1
nHeight    := 08
lBold	   := .F.
lUnderLine := .F.
lPixel	   := .T.
lPrint	   := .F.

SF2->(Dbsetorder(1))
SF2->(Dbseek(xFilial("SF2") + mv_par01 + mv_par02 ))
cCli := SF2->F2_CLIENTE
cLJ  := SF2->F2_LOJA

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCli + cLj ))
cCNPJ := SA1->A1_CGC


*------------------------------*
* Define Fontes a serem usados *
*------------------------------*


oFonte07	:= TFont():New( "Arial"  ,,07     ,,.f.  ,,,,, .f.  )
oFonte07N	:= TFont():New( "Arial"  ,,07     ,,.t.  ,,,,, .f.  )
oFonte08	:= TFont():New( "Arial"  ,,08     ,,.f.  ,,,,, .f.  )
oFonte08N	:= TFont():New( "Arial"  ,,08     ,,.t.  ,,,,, .f.  )
oFonte09	:= TFont():New( "Arial"  ,,09     ,,.f.  ,,,,, .f.  )
oFonte09N	:= TFont():New( "Arial"  ,,09     ,,.t.  ,,,,, .f.  )
oFonte10	:= TFont():New( "Arial"  ,,10     ,,.f.  ,,,,, .f.  )
oFonte10N	:= TFont():New( "Arial"  ,,10     ,,.t.  ,,,,, .f.  )
oFonte12	:= TFont():New( "Arial"  ,,12     ,,.f.  ,,,,, .f.  )
oFonte12N	:= TFont():New( "Arial"  ,,12     ,,.t.  ,,,,, .f.  )
oFonte11	:= TFont():New( "Arial"  ,,11     ,,.f.  ,,,,, .f.  )
oFonte11N	:= TFont():New( "Arial"  ,,11     ,,.t.  ,,,,, .f.  )
oFonte14	:= TFont():New( "Arial"  ,,14     ,,.f.  ,,,,, .f.  )
oFonte14N	:= TFont():New( "Arial"  ,,14     ,,.t.  ,,,,, .f.  )

nLin := 3000

lAdjustToLegacy := .F.
lDisableSetup  := .T.

oPrint:= FWMSPrinter():New("CARTA DE CORRECAO ELETRONICA - CC-e", 6, lAdjustToLegacy, , lDisableSetup)
oPrint:LPDFASPNG := .F.
oPrint:SetResolution(72)
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := "c:\cce\"

If nLin>480
	Cab977()
Endif

SA1->(DBSETORDER(3))
//SA1->(DBSEEK(XFILIAL("SA1")+ALLTRIM(aResult[6])))
SA1->(DBSEEK(XFILIAL("SA1")+ ALLTRIM(cCNPJ) ))

//// Informações da Nota
oPrint:Say(nLin,0010,"INFORMAÇÕES DA NOTA FISCAL",oFonte12N, 100 )
nLin+=3
oPrint:Box(nLin,0010,nLin+0030,0050) // Serie	// Linha,Coluna,Altura,Largura
oPrint:Box(nLin,0050,nLin+0030,0170) // Numero	// Linha,Coluna,Altura,Largura
oPrint:Box(nLin,0170,nLin+0030,0550) // Chave	// Linha,Coluna,Altura,Largura
nLin+=10
oPrint:SAY(nLin,0015,"SÉRIE",oFonte10,100 )
oPrint:Say(nLin,0055,"NÚMERO DA NOTA FISCAL",oFonte10,100 )
oPrint:Say(nLin,0175,"CHAVE DE ACESSO",oFonte10,100 )
nLin+=15
oPrint:Say(nLin,0020,MV_PAR02, 	oFonte12,100)
oPrint:Say(nLin,0080,MV_PAR01, 	oFonte12,100)
oPrint:Say(nLin,0175,aResult[7],oFonte12,100)
nLin+=30

oPrint:Say(nLin,0010,"CARTA DE CORREÇÃO ELETRÔNICA",oFonte12N,100)
nLin+=3
oPrint:Box(nLin,0010,nLin+0035,0050)
oPrint:Box(nLin,0050,nLin+0035,0400)
oPrint:Box(nLin,0400,nLin+0035,0550)
nLin+=10
oPrint:Say(nLin,0015,"ORGÃO",		                oFonte10,100)
oPrint:Say(nLin,0055,"TIPO DE AMBIENTE",		    oFonte10,100)
oPrint:Say(nLin,0405,"DATA E HORÁRIO DO EVENTO",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,aResult[4],oFonte12,100)
oPrint:Say(nLin,0055,IIF(ALLTRIM(aResult[1]) = "1","1 - PRODUÇÃO","T E S T E ") ,oFonte12,100)
oPrint:Say(nLin,0415,aResult[8]+"-"+aResult[9],oFonte12,100)
nLin+=10

oPrint:Box(nLin,0010,nLin+0030,0050)
oPrint:Box(nLin,0050,nLin+0030,0300)
oPrint:Box(nLin,0300,nLin+0030,0400)
oPrint:Box(nLin,0400,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"EVENTO",	           oFonte10,100)
oPrint:Say(nLin,0055,"DESCRIÇÃO DO EVENTO",oFonte10,100)
oPrint:Say(nLin,0305,"SEQUÊNCIA DO EVENTO",oFonte10,100)
oPrint:Say(nLin,0405,"VERSÃO DO EVENTO"   ,oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,aResult[10],oFonte12,100)
oPrint:Say(nLin,0055,UPPER(aResult[14]),oFonte12,100)
oPrint:Say(nLin,0330,aResult[12],oFonte12,100)
oPrint:Say(nLin,0430,aResult[13],oFonte12,100)
nLin+=30

oPrint:Say(nLin ,0010 ,"EMITENTE",oFonte12N, 100 )
nLin+=3
oPrint:Box(nLin,0010,nLin+0030,0400)
oPrint:Box(nLin,0400,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"NOME / RAZÃO SOCIAL",oFonte10,100)
oPrint:Say(nLin,0415,"C.N.P.J. / C.P.F.",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,SM0->M0_NOMECOM,oFonte12,100)
oPrint:Say(nLin,0415,TRANS(SM0->M0_CGC,PesqPict("SM0","M0_CGC")),oFonte12,100)
nLin+=10
oPrint:Box(nLin,0010,nLin+0030,0400)
oPrint:Box(nLin,0300,nLin+0030,0450)
oPrint:Box(nLin,0450,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"ENDEREÇO",oFonte10,100)
oPrint:Say(nLin,0305,"BAIRRO",oFonte10,100)
oPrint:Say(nLin,0455,"CEP",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,SM0->M0_ENDENT,oFonte12,100)
oPrint:Say(nLin,0305,SM0->M0_BAIRENT,oFonte12,100)
oPrint:Say(nLin,0455,TRANSFORM(SM0->M0_CEPENT,"@R 99999-999"),oFonte12,100)
nLin+=10
oPrint:Box(nLin,0010,nLin+0030,0200)
oPrint:Box(nLin,0200,nLin+0030,0300)
oPrint:Box(nLin,0300,nLin+0030,0350)
oPrint:Box(nLin,0350,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"MUNICÍPIO",oFonte10,100)
oPrint:Say(nLin,0205,"FONE/FAX",oFonte10,100)
oPrint:Say(nLin,0305,"ESTADO",oFonte10,100)
oPrint:Say(nLin,0355,"INSCRIÇÃO ESTADUAL",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,SM0->M0_CIDENT,oFonte12,100)
oPrint:Say(nLin,0205,SM0->M0_TEL,oFonte12,100)
oPrint:Say(nLin,0305,SM0->M0_ESTENT,oFonte12,100)
oPrint:Say(nLin,0355,SM0->M0_INSC,oFonte12,100)
nLin+=30

oPrint:Say(nLin,0010,"REMETENTE / DESTINATÁRIO",oFonte12N,100)
nLin+=3
oPrint:Box(nLin,0010,nLin+0030,0400)
oPrint:Box(nLin,0400,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"NOME / RAZÃO SOCIAL",oFonte10,100)
oPrint:Say(nLin,0415,"C.N.P.J. / C.P.F.",oFonte10,100)
nLin+=10
oPrint:Say(nLin ,0015 ,SA1->A1_NOME,oFonte12,100)
oPrint:Say(nLin ,0415 ,TRANS(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oFonte12,100)
nLin+=10
oPrint:Box(nLin,0010,nLin+0030,0400)
oPrint:Box(nLin,0300,nLin+0030,0450)
oPrint:Box(nLin,0450,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"ENDEREÇO",oFonte10,100)
oPrint:Say(nLin,0305,"BAIRRO",oFonte10,100)
oPrint:Say(nLin,0455,"CEP",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,SA1->A1_END,oFonte12,100)
oPrint:Say(nLin,0305,SA1->A1_BAIRRO,oFonte12,100)
oPrint:Say(nLin,0455,TRANSFORM(SA1->A1_CEP,"@R 99999-999"),oFonte12,100)
nLin+=10
oPrint:Box(nLin,0010,nLin+0030,0200)
oPrint:Box(nLin,0200,nLin+0030,0300)
oPrint:Box(nLin,0300,nLin+0030,0350)
oPrint:Box(nLin,0350,nLin+0030,0550)
nLin+=10
oPrint:Say(nLin,0015,"MUNICÍPIO",oFonte10,100)
oPrint:Say(nLin,0205,"FONE/FAX",oFonte10,100)
oPrint:Say(nLin,0305,"ESTADO",oFonte10,100)
oPrint:Say(nLin,0355,"INSCRIÇÃO ESTADUAL",oFonte10,100)
nLin+=10
oPrint:Say(nLin,0015,SA1->A1_MUN,oFonte12,100)
oPrint:Say(nLin,0205,SA1->A1_TEL,oFonte12,100)
oPrint:Say(nLin,0305,SA1->A1_EST,oFonte12,100)
oPrint:Say(nLin,0355,SA1->A1_INSCR,oFonte12,100)
nLin+=30

oPrint:Say(nLin,0010,"CORREÇÃO",oFonte12N,100)
nLin+=3

vTexto := u_FormatText(decodeutf8(aResult[15]), 100, aLinhas)
oPrint:Box(nLin,0010,nLin+((LEN(aLinhas)*10)+10),0550)
nLin+=10

For vInd := 1 to len(aLinhas)
	oPrint:Say(nLin,0015,aLinhas[vInd,1],oFonte11,100 )
	nLin+=10
Next

aLinhas := {}
nLin +=30

oPrint:Say(nLin,0010,"CONDIÇÕES DE USO DA CARTA DE CORREÇÃO",oFonte12N,100 )
nLin+=3

vTexto := u_FormatText(aResult[16], 100, aLinhas)
oPrint:Box(nLin,0010,nLin+((LEN(aLinhas)*10)+10),0550)
nLin+=10
For vInd := 1 to len(aLinhas)
	oPrint:Say(nLin,0015,aLinhas[vInd, 1],oFonte11,100)
	nLin+=10
Next

SetPgEject(.F.) // Funcao pra n?o ejetar pagina em branco
oPrint:Setup()   // para configurar impressora - comentar se quiser gerar o PDF direto.
oPrint:Print() // Visualiza relatorio na tela
Ms_Flush()
Return .T.

/***********
Cabeçalho
***********/
STATIC FUNCTION Cab977()
LOCAL n1 := 100  /// Largura
LOCAL n2 := 45   /// Altura
PRIVATE cStartPath	:= GetSrvProfString("Startpath","")
//PRIVATE cLogo   := cStartPath + "logoprodec.BMP" 	// Empresa+Filial
PRIVATE cLogo   := cStartPath + "Logo_Rava2.JPG" 	// Empresa+Filial
PRIVATE oBrushC	:= TBrush():New(,224+(224*256)+(224*65536))
PRIVATE oBrushC	:= TBrush():New(,224+(224*256)+(224*65536))
If nLin < 10000
	oPrint:EndPage()
	oPrint:StartPage()
Endif
nLin := 50
oPrint:Box(nLin,0010,nLin+50,0550) 	// Linha,Coluna,Altura,Largura
oPrint:FillRect({nLin+2,0011,nLin+48,0548},oBrushC)
oPrint:SayBitmap(nLin+2,0011,cLogo,n1,n2)// oPrint:SayBitmap(Linha, Coluna, Local ,Largura ,Altura )
///oPrint:FillRect({156,371,319,2254},oBrushC)
nLin+=15 
oPrint:SAY(nLin,0150 ,"RELATÓRIO DE CARTA DE CORREÇÃO ELETRÔNICA",oFonte14N,100 )
nLin+=15 
oPrint:SAY(nLin,0120 ,"Este relatório não tem valor fiscal e é uma simples representação da CCe indicada abaixo.",oFonte11,100 )
nLin+=15 
oPrint:SAY(nLin,0120 ,"CONSULTE A AUTENTICIDADE DA CARTA DE CORREÇÃO NO SITE DA SEFAZ AUTORIZADORA.",oFonte11,100 )
nLin+=30

npage++

RETURN()

User FUNCTION FormatText(cMemo, nLen)

LOCAL nLin, cLin, lInic, lFim, aWords:={}, cNovo:="", cWord, lContinua, nTotLin

lInic:=.T.
lFim:=.F.
nTotLin:=MLCOUNT(cMemo, nLen)
FOR nLin:=1 TO nTotLin
	
	cLin:=RTRIM(MEMOLINE(cMemo, nLen, nLin)) //recuperar
	
	IF EMPTY(cLin) //Uma linha em branco ->Considerar um par?grafo vazio
		IF lInic  //Inicio de paragrafo
			aWords:={}  //Limpar o vetor de palavras
			lInic:=.F.
		ELSE
			AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
		ENDIF
		AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
		lFim:=.T.
	ELSE
		IF lInic  //Inicio de paragrafo
			aWords:={} //Limpar o vetor de palavras
			//Incluir a primeira palavra com os espacos que a antecedem
			cWord:=""
			WHILE SUBSTR(cLin, 1, 1)==" "
				cWord+=" "
				cLin:=SUBSTR(cLin, 2)
			END
			IF(nNext:=AT(SPACE(1), cLin))<>0
				cWord+=SUBSTR(cLin, 1, nNext-1)
			ENDIF
			AADD(aWords, cWord)
			cLin:=SUBSTR(cLin, nNext+1)
			lInic:=.F.
		ENDIF
		//Retirar as demais palavras da linha
		WHILE(nNext:=AT(SPACE(1), cLin))<>0
			IF !EMPTY(cWord:=SUBSTR(cLin, 1, nNext-1))
				IF cWord=="," .AND. !EMPTY(aWords)
					aWords[LEN(aWords)]+=cWord
				ELSE
					AADD(aWords, cWord)
				ENDIF
			ENDIF
			cLin:=SUBSTR(cLin, nNext+1)
		END
		IF !EMPTY(cLin) //Incluir a ultima palavra
			IF cLin=="," .AND. !EMPTY(aWords)
				aWords[LEN(aWords)]+=cLin
			ELSE
				AADD(aWords, cLin)
			ENDIF
		ENDIF
		IF nLin==nTotLin  //Foi a ultima linha -> Finalizar o paragrafo
			lFim:=.T.
		ELSEIF RIGHT(cLin, 1)=="." //Considerar que o 'ponto' finaliza paragrafo
			AADD(aWords, CHR(13)+CHR(10))
			lFim:=.T.
		ENDIF
	ENDIF
	
	IF lFim
		IF LEN(aWords)>0
			nNext:=1
			nAuxLin:=1
			WHILE nAuxLin<=LEN(aWords)
				//Montar uma linha formatada
				lContinua:=.T.
				nTot:=0
				WHILE lContinua
					nTot+=(IF(nTot=0, 0, 1)+LEN(aWords[nNext]))
					IF nNext==LEN(aWords)
						lContinua:=.F.
					ELSEIF (nTot+1+LEN(aWords[nNext+1]))>=nLen
						lContinua:=.F.
					ELSE
						nNext++
					ENDIF
				END
				IF nNext==LEN(aWords)  //Ultima linha ->Nao formata
					FOR nAux:=nAuxLin TO nNext
						cNovo+=(IF(nAux==nAuxLin, "", " ")+aWords[nAux])
					NEXT
				ELSE //Formatar
					FOR nAux:=nAuxLin TO nNext
						cNovo+=(CalcSpaces(nNext-nAuxLin, nLen-nTot-1, nAux-nAuxLin)+aWords[nAux])
					NEXT
					cNovo+=" "
				ENDIF
				nNext++
				nAuxLin:=nNext
			END
		ENDIF
		
		lFim:=.F.  //Indicar que o fim do paragrafo foi processado
		lInic:=.T. //Forcar inicio de paragrafo
		
	ENDIF
	
NEXT

//Retirar linhas em branco no final
WHILE LEN(cNovo)>2 .AND. (RIGHT(cNovo, 2)==CHR(13)+CHR(10))
	cNovo:=LEFT(cNovo, LEN(cNovo)-2)
END

For vInd := 0 to (len(cNovo)/nLen)
	AADD(aLinhas, {Substr(cNovo, (vInd*nLen)+1, nLen) } )
Next

RETURN(cNovo)

Static FUNCTION CalcSpaces(nQt, nTot, nPos)
LOCAL cSpaces,; //Retorno de espacos
nDist,;   //Total de espacos excedentes a distribuir em cada separacao
nLim      //Ate que posicao devera conter o resto da divisao

IF nPos==0
	cSpaces:=""
ELSE
	nDist:=INT(nTot/nQt)
	nLim:=nTot-(nQt*nDist)
	cSpaces:=REPL(SPACE(1), 1+nDist+IF(nPos<=nLim, 1, 0))
ENDIF

RETURN cSpaces

STATIC FUNCTION Position(nMode, nRow, nCol, lEdicao)
STATIC nPictRow, nPictCol

LOCAL cRow, cCol

IF lEdicao
	IF nMode==1
		nPictRow:=nRow
		nPictCol:=nCol
		FillString(nPictRow, nPictCol-5, " Lin    ")
		FillString(nPictRow, nPictCol+3, " Col    ")
		nRow:=0
		nCol:=0
	ENDIF
	FillString(nPictRow, nPictCol, PADR(ALLTRIM(STR(nRow)),3))
	FillString(nPictRow, nPictCol+8, PADR(ALLTRIM(STR(nCol)),3))
ENDIF

RETURN NIL
STATIC FUNCTION FillString(nRow, nCol, cString)
LOCAL cArea, cNewArea, nK, nLen

nLen     := LEN(cString)
cArea    := SAVESCREEN(nRow, nCol, nRow, nCol+nLen-1)
cNewArea := ""
FOR nK := 1 TO nLen
	cNewArea += SUBSTR(cString, nK, 1)+SUBSTR(cArea, 2*nK, 1)
NEXT
RESTSCREEN(nRow, nCol, nRow, nCol+nLen-1, cNewArea)

RETURN NIL
