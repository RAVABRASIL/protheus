#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCONH   º Autor ³ AP6 IDE            º Data ³  06/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELCONH()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Divergencia de Conhecimento de Frete"
	Local cPict          := ""
	Local titulo         := "Divergencia de Conhecimento de Frete"
	Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       300
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local Cabec1         := " " //Conhec.    Valor             Frete     Frete Peso  Taxa Fixa Ad-Valoren    GRIS        ADM         Pedagio     Suframa     TDE       Frete Sistema   Tx Fluvial  Valor ICMS    Status Conhec."
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RELCONH" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RELCONH" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private aDiverge     :={'A Maior','A Menor','Todas'}
	Private cString := ""

	Pergunte('RELCONH',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,"RELCONH",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	titulo         := "Divergencia de Conhecimento de Frete De: "+DTOC(MV_PAR07)+" Ate: "+DTOC(MV_PAR08)+" - "+aDiverge[MV_PAR09]+' - '+ iif(MV_PAR11=1,'Conhecimento', 'Nota Faturada')

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local cQry:=''
	local aNotas:={}
	Local cStatus := ""
	Local LF := CHR(13) + CHR(10)
	Local cFornAnt	:= ""
	Local lPagina	:= .F.
	Local nPerc		:= 0

	If Select("TMPX") > 0
		DbSelectArea("TMPX")
		DbCloseArea()
	EndIf

IF MV_PAR11=1


	cQry:="SELECT " + LF


	cQry += " F1_STATUS , * " + LF

	cQry+="FROM  " + lf
	cQry+= " " +  RetSqlName("Z86") + " Z86 " + LF
	cQry+= " ,"+ RetSqlName("SF1") + " SF1 " + LF

	If MV_PAR09=1 // A MAIOR
		cQry+="WHERE Z86_FRETE>Z86_FRESIS "  + LF
	ELSEIF MV_PAR09=2  // AMENOR
		cQry+="WHERE Z86_FRETE<Z86_FRESIS "  + LF
	ELSE
		cQry+="WHERE Z86_FRETE!=Z86_FRESIS "   + LF// TODAS DIVERGENCIAS
	ENDIF

	cQry+=" AND Z86_FILIAL='"+XFILIAL('Z86')+"'    " + LF
	cQry+=" AND Z86_CONHEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "  + LF
	cQry+=" AND Z86_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "  + LF
	cQry+=" AND Z86_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "  + LF


     cQry+=" AND Z86_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' " + LF
	
	cQry+=" AND Z86.D_E_L_E_T_ = ''  " + LF

	cQry += " AND Z86.Z86_FILIAL = '" + Alltrim(xFilial("Z86")) + "' " + LF
	cQry += " AND Z86.Z86_FILIAL = SF1.F1_FILIAL " + LF
	cQry += " AND Z86.Z86_CONHEC = SF1.F1_DOC " + LF
	cQry += " AND Z86.Z86_SERIE  = SF1.F1_SERIE " + LF
	cQry += " AND Z86.Z86_FORNEC = SF1.F1_FORNECE " + LF
	cQry += " AND Z86.Z86_LOJA   = SF1.F1_LOJA " + LF
	cQry += " AND Z86.Z86_CONHEC = Z86.Z86_CONHEC " + LF
	cQry += " AND Z86.Z86_SERIE  = Z86.Z86_SERIE " + LF
	cQry += " AND SF1.D_E_L_E_T_='' " + LF
//MV_PAR10 = 1 //TODOS
	If MV_PAR10 = 2 //liberados
		cQry += " AND SF1.F1_STATUS = 'A' " + LF
	Elseif MV_PAR10 = 3 //BLOQUEADOS
		cQry += " AND SF1.F1_STATUS <> 'A' " + LF
	Endif

    cQry += " order by  Z86_FORNEC, Z86_LOJA " + LF


ELSE

	cQry := "SELECT " + LF	
	cQry += "DISTINCT F1_STATUS ,Z86_CONHEC,Z86_SERIE,Z86_FORNEC,Z86_LOJA , " + LF
	cQry += "Z86_OBS,Z86_FRETE,Z86_FREPES,Z86_TXFIXA,Z86_ADVALO,Z86_GRIS,Z86_ADM,Z86_PEDAGI,Z86_SUFRAM,Z86_TDE,Z86_FRESIS,Z86_FLUVIA,Z86_VALICM,Z86_PEDAGI,Z86_TRT,Z86_TDS,Z86_AGENDA,Z86_REDESP,Z86_PALETI " + LF
	cQry += "FROM " + LF
	cQry += " " +  RetSqlName("Z86") + " Z86 ," +  RetSqlName("SF1") + " SF1 ," +  RetSqlName("Z87") + " Z87," +  RetSqlName("SD2") + " SD2 " + LF
	
	If MV_PAR09=1 // A MAIOR
		cQry+="WHERE Z86_FRETE>Z86_FRESIS "  + LF
	ELSEIF MV_PAR09=2  // AMENOR
		cQry+="WHERE Z86_FRETE<Z86_FRESIS "  + LF
	ELSE
		cQry+="WHERE Z86_FRETE!=Z86_FRESIS "   + LF// TODAS DIVERGENCIAS
	ENDIF
	
	cQry += "AND Z86_FILIAL='"+XFILIAL('Z86')+"'    " + LF

	cQry+=" AND Z86_CONHEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "  + LF
	cQry+=" AND Z86_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "  + LF
	cQry+=" AND Z86_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "  + LF

	cQry += "AND Z86.D_E_L_E_T_ = ''  " + LF
	cQry += "AND Z86.Z86_FILIAL = SF1.F1_FILIAL  " + LF
	cQry += "AND Z86.Z86_CONHEC = SF1.F1_DOC " + LF
	cQry += "AND Z86.Z86_SERIE  = SF1.F1_SERIE " + LF
	cQry += "AND Z86.Z86_FORNEC = SF1.F1_FORNECE " + LF
	cQry += "AND Z86.Z86_LOJA   = SF1.F1_LOJA  " + LF
	cQry += "AND Z86.Z86_CONHEC = Z86.Z86_CONHEC " + LF
	cQry += "AND Z86.Z86_SERIE  = Z86.Z86_SERIE " + LF
	cQry += "AND Z86.Z86_FILIAL = Z87.Z87_FILIAL  " + LF
	cQry += "AND Z86.Z86_CONHEC = Z87.Z87_CODCON  " + LF
	cQry += "AND Z86.Z86_SERIE  = Z87.Z87_SERIE " + LF
	cQry += "AND Z86.Z86_FORNEC = Z87.Z87_FORNEC " + LF
	cQry += "AND Z86.Z86_LOJA   = Z87.Z87_LOJA " + LF
	cQry += "AND Z87_FILIAL=D2_FILIAL " + LF
	cQry += "AND Z87_NOTA = D2_DOC " + LF
	cQry += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' " + LF
	cQry += "AND D2_CLIENTE NOT IN ('031732','031733')  " + LF
	cQry += "AND SD2.D_E_L_E_T_=''  " + LF
	cQry += "AND Z87.D_E_L_E_T_='' " + LF
	cQry += "AND SF1.D_E_L_E_T_='' " + LF

    //MV_PAR10 = 1 //TODOS
	If MV_PAR10 = 2 //liberados
		cQry += " AND SF1.F1_STATUS = 'A' " + LF
	Elseif MV_PAR10 = 3 //BLOQUEADOS
		cQry += " AND SF1.F1_STATUS <> 'A' " + LF
	Endif


	cQry += "order by  Z86_FORNEC, Z86_LOJA  " + LF


ENDIF

	MemoWrite("C:\TEMP\RELCONH.SQL",cQry)
	TCQUERY cQry NEW ALIAS 'TMPX'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                                       

	SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nRava :=0
nTRava:=0
nLib :=0
nTlib:=0
nBlo :=0
nTBlo:=0
nfrete:=0
nTfrete:=0


TMPX->(dbGoTop())
While TMPX->(!EOF())


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	
	Endif
	
	nRava :=0
	nLib :=0
	nBlo :=0
	nfrete:=0
	   
    cFornec:= TMPX->Z86_FORNEC 
    cLoja  := TMPX->Z86_LOJA
   	nLin++
	@nLin++,00 PSAY 'Fornecedor: ' + TMPX->Z86_FORNEC  + ' LOJA:'+TMPX->Z86_LOJA  + ' - ' + UPPER(posicione('SA2',1,xFilial('SA2')+TMPX->Z86_FORNEC+TMPX->Z86_LOJA,'A2_NREDUZ'))
	@nLin,00 PSAY replicate('_',70)
	nLin++
	
      
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
	Do While TMPX->(!EOF()) .AND. TMPX->Z86_FORNEC=cFornec .AND. TMPX->Z86_LOJA=cLoja
  
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...

			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6

			nLin++
			@nLin++,00 PSAY 'Continua .... '
			@nLin++,00 PSAY 'Fornecedor: ' + TMPX->Z86_FORNEC  + ' LOJA:'+TMPX->Z86_LOJA  + ' - ' + UPPER(posicione('SA2',1,xFilial('SA2')+TMPX->Z86_FORNEC+TMPX->Z86_LOJA,'A2_NREDUZ'))
			@nLin,00 PSAY replicate('_',70)
			nLin++
			
		Endif
		
      	@nLin,00 PSAY replicate('_',220)
		nLin++
		ncol:=0
		@nLin,ncol PSAY "TIPO"
		ncol+=10
		@nLin,ncol PSAY "N. Nota"
		ncol+=10
		@nLin,ncol PSAY 'Vl. Frete'
		ncol+=10
		@nLin,ncol PSAY 'Fret Peso '
		ncol+=10
		@nLin,ncol PSAY 'Tx Fixa'
		ncol+=10
		@nLin,ncol PSAY 'Ad-Valor.'
		ncol+=10
		@nLin,ncol PSAY 'GRIS'
		ncol+=10
		@nLin,ncol PSAY 'ADM Taxa'
		ncol+=10
		@nLin,ncol PSAY 'Pedagio'
		ncol+=10
		@nLin,ncol PSAY 'Suframa'
		ncol+=10
		@nLin,ncol PSAY 'TDE'
		ncol+=10
		@nLin,ncol PSAY 'ICMS(R$)'
		ncol+=10
		@nLin,ncol PSAY 'Sem/ICMS '
		ncol+=10
		@nLin,ncol PSAY 'TX Fluv. '
		ncol+=10
		@nLin,ncol PSAY 'Paletizac'
		ncol+=10
		@nLin,ncol PSAY 'TRT'
		ncol+=10
		@nLin,ncol PSAY 'TDS'
		ncol+=10
		@nLin,ncol PSAY 'Agendame.'
		ncol+=10
		@nLin,ncol PSAY 'Redespac.'				
        ncol+=10
		@nLin,ncol PSAY 'Status'						
		@nLin,00 PSAY replicate('_',220)
		nLin++
        
		
		ncol:=0
		@nLin,ncol PSAY "N. FISCAL"
		ncol+=10
		@nLin,ncol PSAY TMPX->Z86_CONHEC
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_FRETE,'@E 99,999.99')
		
		if Alltrim(TMPX->F1_STATUS) = "" 

		   nRava +=TMPX->Z86_FRETE
		   nTRava+=TMPX->Z86_FRETE 
		
		elseif Alltrim(TMPX->F1_STATUS)= "A"

		   nLib +=TMPX->Z86_FRETE
		   nTlib+=TMPX->Z86_FRETE 
        
        else

		   nBlo +=TMPX->Z86_FRETE
		   nTBlo+=TMPX->Z86_FRETE 

		
		endif
		
		nfrete+= TMPX->Z86_FRETE
		nTfrete+= TMPX->Z86_FRETE
		
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_FREPES ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_TXFIXA ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_ADVALO ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_GRIS   ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_ADM    ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_PEDAGI ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_SUFRAM ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_TDE    ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_FRESIS ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_FLUVIA ,'@E 99,999.99')
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_VALICM ,'@E 99,999.99')	      		
		ncol+=10
		@nLin,ncol PSAY transform(TMPX->Z86_PALETI ,'@E 99,999.99')
		ncol+=10	      		
		@nLin,ncol PSAY transform(TMPX->Z86_TRT    ,'@E 99,999.99')
		ncol+=10	      		
		@nLin,ncol PSAY transform(TMPX->Z86_TDS    ,'@E 99,999.99')
		ncol+=10	      		
		@nLin,ncol PSAY transform(TMPX->Z86_AGENDA ,'@E 99,999.99')
		ncol+=10	      		
		@nLin,ncol PSAY transform(TMPX->Z86_REDESP ,'@E 99,999.99')

        cStatus := iif(Alltrim(TMPX->F1_STATUS) = "" , "..." , iif( Alltrim(TMPX->F1_STATUS)= "A", "Liberado" , "Bloqueado" )  )
        
		ncol+=10	      		
		@nLin,ncol PSAY cStatus
        
        @nLin++
		
		aNotas:=Notas(TMPX->Z86_CONHEC,TMPX->Z86_SERIE,TMPX->Z86_FORNEC,TMPX->Z86_LOJA)      
		
		For _x:=1 to len(aNotas)
			ncol:=0
			@nLin,ncol PSAY "CALCULADO"
			ncol+=10
			@nLin,ncol PSAY aNotas[_x][1]
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][3],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][4],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][5],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][6],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][7],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][8],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][9],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][10],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][11],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(aNotas[_x][13],'@E 99,999.99')
			ncol+=10
			@nLin,ncol PSAY transform(0 /*aNotas[_x][12]*/,'@E 99,999.99')
			ncol+=10
			@nLin++,ncol PSAY transform(aNotas[_x][14],'@E 99,999.99')
		
		Next
	    
	    nPerc 	:= ( TMPX->Z86_FRETE / aNotas[1][2] ) * 100
	    cUFMUN	:= fUFcity(aNotas[1][1])
	     
		@nLin++,00 PSAY 'Val. NF = R$' + transform(aNotas[1][2],'@E 999,999.99') + '  % Frete = ' + transform(nPerc,'@E 999,999.99') + '%   UF/CIDADE => ' + cUFMUN + '   - OBS: ' + TMPX->Z86_OBS

		INCREGUA()
		
		
		TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
      	

	Enddo


	   	nLin++

        @nLin,00 PSAY 'Periodo' // de :xx/xx/xx ate : xx/xx/xx
		@nLin,28 PSAY 'Bloqueados'
		@nLin,40 PSAY 'Liberados'
		@nLin,52 PSAY '...'
        @nLin,64 PSAY 'Total' 	
		@nLin,76 PSAY '% Bloqueados' 	
		@nLin,90 PSAY '% Liberados' 	
		@nLin,104 PSAY '% .....' 			

		@nLin++,00 PSAY replicate('_',118)
		@nLin,00 PSAY "De: "+Dtoc(MV_PAR07)+" Ate: "+Dtoc(MV_PAR08)  // de :xx/xx/xx ate : xx/xx/xx
		@nLin,28 PSAY transform( nBlo,'@E 999,999.99') // bloqueados
		@nLin,40 PSAY transform( nLib,'@E 999,999.99') // liberados
		@nLin,52 PSAY transform( nRava,'@E 999,999.99') // Favor da Rava
        @nLin,64 PSAY transform( nFrete,'@E 999,999.99')	// total 	
		@nLin,76 PSAY transform(( nBlo/nfrete)*100 ,'@E 999,999.99')	// % bloqueados 	
		@nLin,90 PSAY transform(( nLib/nfrete)*100 ,'@E 999,999.99')	// % liberados 	
		@nLin,104 PSAY transform((nRava/nfrete)*100 ,'@E 999,999.99')	// % ..... 			
		@nLin++,00 PSAY replicate('_',118)
		nLin++
			
		
EndDo

// total geral 	

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...	

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 6
		
Endif

nLin++
@nLin,00 PSAY 'T O T A L ' 
nLin++
@nLin,00 PSAY 'Periodo' // de :xx/xx/xx ate : xx/xx/xx
@nLin,28 PSAY 'Bloqueados'
@nLin,40 PSAY 'Liberados'
@nLin,52 PSAY '...'
@nLin,64 PSAY 'Total'
@nLin,76 PSAY '% Bloqueados'
@nLin,90 PSAY '% Liberados'
@nLin,104 PSAY '% .....'

@nLin++,00 PSAY replicate('_',118)
@nLin,00 PSAY "De: "+Dtoc(MV_PAR07)+" Ate: "+Dtoc(MV_PAR08)  // de :xx/xx/xx ate : xx/xx/xx
@nLin,28 PSAY transform( nTBlo,'@E 999,999.99') // bloqueados
@nLin,40 PSAY transform( nTLib,'@E 999,999.99') // liberados
@nLin,52 PSAY transform( nTRava,'@E 999,999.99') // Favor da Rava
@nLin,64 PSAY transform( nTFrete,'@E 999,999.99')	// total
@nLin,76 PSAY transform(( nTBlo/nTfrete)*100 ,'@E 999,999.99')	// % bloqueados
@nLin,90 PSAY transform(( nTLib/nTfrete)*100 ,'@E 999,999.99')	// % liberados
@nLin,104 PSAY transform((nTRava/nTfrete)*100 ,'@E 999,999.99')	// % .....
@nLin++,00 PSAY replicate('_',118)
nLin++



TMPX->(DBCLOSEAREA())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

***************

Static Function Notas(cConhe,cSerie,cFornec,cLoja)

***************

	Local cQry:=''
	LOCAL aRet:={}

	If Select("TMPY") > 0
		DbSelectArea("TMPY")
		DbCloseArea()
	EndIf


	cQry:="SELECT *  "
	cQry+="FROM  " + RetSqlName("Z87") + " Z87 "
	cQry+="WHERE  Z87_CODCON='"+cConhe+"'"
	cQry+="AND Z87_FILIAL= '"+XFILIAL('Z87')+"'  "
	cQry+="AND Z87_SERIE='"+cSerie+"'  "
	cQry+="AND Z87_FORNEC='"+cFornec+"'  "
	cQry+="AND Z87_LOJA='"+cLoja+"'  "

	cQry+="AND Z87.D_E_L_E_T_ = ''  "

	TCQUERY cQry NEW ALIAS 'TMPY'

	if TMPY->(!EOF())
		Do While  TMPY->(!EOF())
			Aadd( aRet, { TMPY->Z87_NOTA,TMPY->Z87_VALOR,TMPY->Z87_FRETE,TMPY->Z87_FREPES,TMPY->Z87_TXFIXA,TMPY->Z87_ADVALO,TMPY->Z87_GRIS,TMPY->Z87_ADM,TMPY->Z87_PEDAGI,TMPY->Z87_SUFRAM,TMPY->Z87_TDE,TMPY->Z87_ICMS,TMPY->Z87_FSICMS,TMPY->Z87_FLUVIA} )
			TMPY->(DBSKIP())
		EndDo
	ELSE
		Aadd( aRet, { "",0,0,0,0,0,0,0,0,0,0,0,0} )
	ENDIF
	TMPY->(DBCLOSEAREA())

Return aRet


***************

Static Function cabecNotas(nLin)

***************
	@nLin,00 PSAY "TIPO"
	@nLin,12 PSAY "N. Nota"
	@nLin,26 PSAY 'Val. NF'
	@nLin,40 PSAY 'Val. Frete'
	@nLin,54 PSAY 'Peso Frete'
	@nLin,68 PSAY 'Taxa Fixa'
	@nLin,82 PSAY 'Ad-Valoren'
	@nLin,100 PSAY 'GRIS'
	@nLin,114 PSAY 'ADM Taxa'
	@nLin,128 PSAY 'Pedagio'
	@nLin,142 PSAY 'Suframa'
	@nLin,156 PSAY 'TDE'
	@nLin,170 PSAY 'ICMS(%)'
	@nLin,184 PSAY 'Frete s/ICMS'
	@nLin,198 PSAY 'TX Fluvial'
	@nLin++,00 PSAY replicate('_',220)

Return

***************************
User Function _fStatusBRW(cConc,cSerie)
***************************

	Local cQuery := ""
	Local LF     := CHR(13) + CHR(10)
	Local cStatus:= ""

	cQuery := " SELECT F1_STATUS " + LF
//cQuery += " SUBSTRING(Z86_DATA,7,2)+'/'+SUBSTRING(Z86_DATA,5,2)+'/'+SUBSTRING(Z86_DATA,1,4) DATA , " + LF
	cQuery += " ,FILIAL = CASE WHEN Z86_FILIAL='01' THEN 'Saco' else 'Caixa'end  " + LF
	cQuery += " ,Z86_CONHEC CONHECIMENTO,Z86_SERIE SERIE ,Z86_FORNEC FORNECEDOR ,Z86_LOJA LOJA  " + LF
	cQuery += " ,NOME=(SELECT A2_NOME FROM SA2010 SA2 WHERE A2_COD=Z86_FORNEC AND A2_LOJA=Z86_LOJA AND SA2.D_E_L_E_T_='') " + LF
	cQuery += " ,Z86_FRETE FRETE ,Z86_FRESIS FRETE_SISTEMA ,F1_STATUS " + LF

	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("Z86") + " Z86 " + LF
	cQuery += " ,"+ RetSqlName("SF1") + " SF1 " + LF
	cQuery += " WHERE " + LF
//cQuery += " Z86_DATA>='20131227' " + LF
//cQuery += " AND F1_STATUS  IN('B') -- bloqueado " + LF
	cQuery += " Z86_FILIAL = '" + Alltrim(xFilial("Z86")) + "' " + LF
	cQuery += " AND Z86_CONHEC = F1_DOC " + LF
	cQuery += " AND Z86_SERIE  = F1_SERIE " + LF
	cQuery += " AND Z86_FORNEC = F1_FORNECE " + LF
	cQuery += " AND Z86_LOJA   = F1_LOJA " + LF

	cQuery += " AND Z86_CONHEC = '" + Alltrim(cConc)    + "' " + LF
	cQuery += " AND Z86_SERIE  = '" + Alltrim(cSerie)   + "' " + LF
//cQuery += " AND Z86_FORNEC = '" + Alltrim(cFornece) + "' " + LF
//cQuery += " AND Z86_LOJA   = '" + Alltrim(cLoja)    + "' " + LF

	cQuery += " AND Z86.D_E_L_E_T_='' " + LF
	cQuery += " AND SF1.D_E_L_E_T_='' " + LF
//cQuery += " ORDER BY Z86_DATA,Z86_CONHEC " + LF
	MemoWrite("C:\TEMP\ST_FATCONC.SQL",cQuery )

	If Select("TMPS") > 0
		DbSelectArea("TMPS")
		DBCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS 'TMPS'

	If !TMPS->(EOF())
		TMPS->(Dbgotop())
		cStatus := iif(Alltrim(TMPS->F1_STATUS) = "" , "..." , iif( Alltrim(TMPS->F1_STATUS)= "A", "Liberado" , "Bloqueado" )  )
	Endif

	DbSelectArea("TMPS")
	DBCloseArea()

Return(cStatus)


***************

Static Function fUFcity(cNota)

***************

	Local cQry:=''
	LOCAL cRet:=""

	If Select("TMPZ") > 0
		DbSelectArea("TMPZ")
		DbCloseArea()
	EndIf


	cQry:="SELECT F2_EST, A1_MUN FROM " + RetSqlName("SF2") + " F2 "
	cQry+="INNER JOIN " + RetSqlName("SA1") + " A1 "
	cQry+="ON F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA "
	cQry+="WHERE F2_DOC = '"+cNota+"'"
	cQry+="AND F2.D_E_L_E_T_ <> '*' "
	cQry+="AND F2_FILIAL= '"+XFILIAL('SF2')+"'  "
	

	TCQUERY cQry NEW ALIAS 'TMPZ'

	if TMPZ->(!EOF())

		cRet := TMPZ->F2_EST + " / " + TMPZ->A1_MUN 

	ENDIF
	TMPZ->(DBCLOSEAREA())

Return cRet

