#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  22/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
***********************
User Function IMPCONF()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt
Private cPerg := "IMPCONF" 
Private coTbl1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaPerg(cPerg)

Pergunte(cPerg,.F.)

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Importar e Comparar arquivo com Notas")
@ 005,005 TO 085,185
@ 010,018 Say " Este programa ira ler e comparar o conteudo do arquivo de "
@ 018,018 Say " Notas faturadas contra a Rava, com as notas existentes no "
@ 026,018 Say " Sistema.                                                  "

@ 070,088 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 070,118 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 070,148 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  22/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*************************
Static Function OkLeTxt()
*************************

Processa({|| Importar( MV_PAR01 ) },"Processando...")

Return


***********************************
Static Function Importar(cArqImpor)
***********************************

Local   cLinha    := ""
Local   nLinha    := nTotLin := 0
Local   nTamLinha := 0
Local   nTamArq   := 0
local   oReport
Private aDados    := {}

//Valida arquivo
if !file(cArqImpor)
	Aviso("Arquivo","Arquivo não selecionado ou invalido.",{"Sair"},1)
	return
else
	//+---------------------------------------------------------------------+
	//| Abertura do arquivo texto                                           |
	//+---------------------------------------------------------------------+
	nHdl := fOpen(cArqImpor)
	
	if nHdl == -1
		if FERROR() == 516
			ALERT("Feche a planilha que gerou o arquivo.")
		endif
	endif
	
	//+---------------------------------------------------------------------+
	//| Verifica se foi possível abrir o arquivo                            |
	//+---------------------------------------------------------------------+
	if nHdl == -1
		cMsg := "O arquivo de nome "+cArqImpor+" nao pode ser aberto! Verifique os parametros."
		MsgAlert(cMsg,"Atencao!")
		return
	endif
	fClose(nHdl)

	FT_FUse(cArqImpor)  //abre o arquivo
	nTotLin := FT_FLastRec()
	procregua(nTotLin)
	FT_FGOTOP()         //posiciona na primeira linha do arquivo	

	aDados := {}
	nLinha := 1
	if Select("TMP") > 0 
	   DbSelectArea("TMP")
   	DbCloseArea()
   endif
   oTbl1()   	

	DbSelectArea("SF1")
	DbSetOrder(8)
	//F1_FILIAL+F1_CHVNFE
	while !FT_FEOF() //Ler todo o arquivo enquanto não for o final dele		
		incproc('Lendo registro: ' + Alltrim(Str(nLinha))+'/'+Alltrim(Str(nTotLin)) )
 		clinha := FT_FREADLN()		
	   if nLinha > 1
	      aDados := Separa(cLinha,"|",.T.)
         if !SF1->(DbSeek(xFilial("SF1")+aDados[1], .T. ))
	         RecLock("TMP",.T.)
            //Chave_de_acesso|Numero|Serie|Data_de_emissao|Situacao|Tipo_Operacao|Valor_total_da _nota|Nome_razao_social_emit|CPF_CNPJ_emit|Inscricao_estadual_emit|UF_emit|Nome_razao_social_dest|CPF_CNPJ_dest|Inscricao_estadual_dest|UF_dest|Placa_do_veiculo_reboque|UF_placa|Nome_da_transportadora|Inscricao_Estadual_da_Transportadora|CPF_CNPJ_Transportadora|Base_de_Calculo_do_ICMS|Valor_do_ICMS|Base_de_calculo_do_ICMS_substituicao|Valor_do_ICMS_substituicao|Valor_total_dos_produtos|Valor_do_frete|Valor_do_seguro|Valor_desconto|Valor_outras_despesas_acessorias|Valor_do_IPI
	         //29151003927907000270550010005080591111009104|508059|1|09/10/2015|A|1-Saída|6.291,08|ATACADAO CENTRO SUL LTDA|03.927.907/0002-70|088896542|BA|RAVA EMBALAGENS INDUSTRIA E COMERCIO LTD|41.150.160/0001-02| |PB| | | | | |5.470,50|656,46|0,00|0,00|5.470,50|0,00|0,00|0,00|0,00|0,00
	         TMP->IE      := aDados[10]
	         TMP->CNPJ    := aDados[09]
	         TMP->UF      := aDados[11]
	         TMP->NOME    := aDados[08]
	         TMP->EMISSAO := aDados[04]
	         TMP->SERIE   := PadR(aDados[3],3)
	         TMP->NOTA    := StrZero(Val(aDados[2]),9)
	         TMP->(MsUnLock())
  	      endif		         
	   endif
		FT_FSKIP()
		nLinha++
	end
	TMP->(DbGoTop())
	FT_FUse()
	fClose(nHdl)
endif

if !TMP->(Eof()) 
   oReport:= ReportDef()
   oReport:PrintDialog()
endif 

TMP->(dbCloseArea())
FErase(coTbl1+GetDbExtension())  // Deletando o arquivo
FErase(coTbl1+OrdBagExt())       // Deletando índice

Return

**********************
User Function ArqNFS()
**********************

MV_PAR01 := cGetFile( 'Arquivos textos|*.txt' , 'Arquivos Texto (TXT)', 1, 'C:\', .F., GETF_LOCALHARD,.F., .T. )

return .T.    


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function CriaPerg(cPerg)

Local aHelpPor := {}

PutSx1( cPerg,'01','Arquivo txt','','','mv_ch1','C',75,0,0,'G','U_ARQNFS()','','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return


***************************
Static Function ReportDef()
***************************

Local oSection1
Local oSection2
local oReport

oReport:= TReport():New("IMPCONF","Notas não recebidas ",, {|oReport| ReportPrint(oReport)},"Notas não recebidas ")
oReport:SetPortrait()

oSection1 := TRSection():New(oReport,"DATA",{'TMP'},,,)

TRCell():New(oSection1,'EMISSAO','','Emitida em:'    ,,10,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,"NOTAS",{'TMP'},,,)

TRCell():New(oSection2,'NOTA'  ,'','Nota'            ,,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'SERIE' ,'','Serie'           ,,03,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'EST'   ,'','UF'              ,,02,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'NOME'  ,'','Emitente da Nota',,50,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)


************************************
Static Function ReportPrint(oReport)
************************************

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)

oReport:SetTitle(Alltrim("Relação de Notas não Recebidas" ))

TMP->( DbGoTop() )
oReport:SetMeter(TMP->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()

oReport:Say(oReport:Row(),oReport:Col(),"Arquivo Selecionado: "+MV_PAR01)

oReport:SkipLine()

//oReport:Say(oReport:Row(),oReport:Col(),"T O T A L : "+CVALTOCHAR(nToCont) )
oReport:SkipLine()
oReport:SkipLine()

oSection2:Init()

while !oReport:Cancel() .And. TMP->(!Eof())

   oSection2:Finish()	
   oSection1:Init()

   cData := TMP->EMISSAO

    //Section1
   oSection1:Cell("EMISSAO"):SetValue( cData )
	oSection1:Cell("EMISSAO"):SetAlign("LEFT")
    
   oSection1:PrintLine()		
   oSection1:Finish()
    
   oSection2:Init()
        
   while !oReport:Cancel() .And. TMP->(!Eof()) .and. TMP->EMISSAO == cData

	   oReport:IncMeter()    
	   //Section2
		
	   oSection2:Cell("NOTA"):SetValue( TMP->NOTA )
		oSection2:Cell("NOTA"):SetAlign("LEFT")
				
	   oSection2:Cell("SERIE"):SetValue( TMP->SERIE )
		oSection2:Cell("SERIE"):SetAlign("LEFT")
				
      oSection2:Cell("EST"):SetValue( TMP->UF )
		oSection2:Cell("EST"):SetAlign("LEFT")

	   oSection2:Cell("NOME"):SetValue( TMP->NOME )
		oSection2:Cell("NOME"):SetAlign("LEFT")

	   oSection2:PrintLine()         
						
	   TMP->(DbSkip())		

    enddo               
    
enddo

oSection1:Finish()
oSection2:Finish()

return


***********************
Static Function oTbl1()
***********************

Local aFds := {}
Local cArquivo
Local cChave

Aadd( aFds , {"IE"     ,"C",010,000} )
Aadd( aFds , {"CNPJ"   ,"C",014,000} )
Aadd( aFds , {"UF"     ,"C",002,000} )
Aadd( aFds , {"NOME"   ,"C",050,000} )
Aadd( aFds , {"EMISSAO","C",010,000} )
Aadd( aFds , {"SERIE"  ,"C",003,000} )
Aadd( aFds , {"NOTA"   ,"C",009,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

DbSelectArea("TMP")
cArquivo := CriaTrab(,.F.)
cChave := "EMISSAO+NOTA+SERIE"

IndRegua("TMP",cArquivo,cChave)
DbSetOrder(1)

Return 


**********************************
Static Function NewCGCCPF(cCGCCPF)
**********************************
Local aInvChar := {"/",".","-"}
Local nI

for nI := 1 to Len(aInvChar)
   cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
next

return cCGCCPF