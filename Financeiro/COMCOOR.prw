#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

#DEFINE CAIXA 001
#DEFINE SACOS 002

#DEFINE DIRET 001
#DEFINE COORD 002
#DEFINE REPRE 003

#DEFINE NORTE    001
#DEFINE NORDESTE 002
#DEFINE COESTE   003
#DEFINE SUDESTE  004
#DEFINE SUL      005
#DEFINE TODAS    006

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :COMCOOR   ³ Autor :TEC1 - Designer       ³ Data :07/08/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :Recalcular % Comissão Coordenador                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
***********************
User Function COMCOOR()
***********************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSBtn1","oSBtn2","oSBtn3","oGrp1","oSay1","oSay3")

oPerg1()
Pergunte('COMCOO',.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 228,416,452,962,"Comissões",,,.F.,,,,,,.T.,,,.F. )
oSBtn1     := SButton():New( 084,200,1,,oDlg1,,"", )
oSBtn1:bAction := {||btnOk()}

oSBtn2     := SButton():New( 084,232,2,,oDlg1,,"", )
oSBtn2:bAction := {||btnCan()}

oSBtn3     := SButton():New( 084,167,5,,oDlg1,,"", )
oSBtn3:bAction := {||btnPar()}

oGrp1      := TGroup():New( 008,008,076,260,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 018,014,{||"Este programa tem o objetivo de verificar se os coordenadores atigiram as metas e refazer os"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,229,007)
oSay3      := TSay():New( 027,014,{||"percentuais de comissão de acordo com as metas atingidas."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,229,007)

oDlg1:Activate(,,,.T.)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ btnOk()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***********************
Static Function btnOk()
***********************
Local lEnd := .F.

Processa({ |lEnd| CalcCom(),OemToAnsi('Analisando comissões...')}, OemToAnsi('Aguarde...'))

oDlg1:End()

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ CalcCom()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function CalcCom()
Local aRel   := {}
Local aRet   := {}
Local aComis := {}
Local aMails := {}
Local nComis := 0
Local _XX, _XY     
Local nVolKG := 0
Local nFator := 0

DbSelectArea("SC5")
DbSetOrder(1)

DbSelectArea("SF2")
DbSetOrder(1)
DbSelectArea("SD2")
DbSetOrder(3)

DbSelectArea("SE1")
DbSetOrder(1)

DbSelectArea("Z35")
DbSetOrder(1)

ProcRegua(0)

aMails := U_RVMails( COORD )
for _XX := 1 to Len(aMails)
	if aMails[_XX,1] >= AllTrim(MV_PAR02) .AND. aMails[_XX,1] <= AllTrim(MV_PAR03)
		
		cEmail := aMails[_XX,2]
		//Verifica o Volume Faturado e o Fator do Vendido para o Mês
		aRet := U_VendRava(Val(Left(MV_PAR01,2)),Val(Right(MV_PAR01,4)),COORD,aMails[_XX,1],SACOS,"",TODAS,.F.)
		//Verifico o atingido nos Combos de Comissões		
		aComiss := U_CBRava( aMails[_XX,1], aRet[1], aRet[3] )
      nComis  :=  aComiss[4] + aComiss[1] //Comissao Padrao + Bonus
		
		nVolKG := aRet[1] //Vol Kg
      nFator := aRet[3] //Fator
		
      nBonus  := aComiss[1]
		nVolAci := aComiss[2]
		nFatAci := aComiss[3]
		nPComP  := aComiss[4]//Percentual de comissao padrao
	
		//Busco todas as vendas que comporam o Vendido para o Mês - (Venda detalhada pedido a pedido)
		aRet := U_VendRava(Val(Left(MV_PAR01,2)),Val(Right(MV_PAR01,4)),COORD,aMails[_XX,1],SACOS,"",TODAS,.T.)
		//Processo as vendas item a item para alterar o percentual de comissão no pedido e/ou nota e titulo a receber
		for _XY := 1 to Len(aRet)
			//Altero a comissao no pedido de vendas
			if SC5->(DbSeek(aRet[_XY,1]+aRet[_XY,2]))
				
				//Verifico se o campo coordenador esta vazio e caso esteja
				//atualizo com o coordenador do representante associado ao pedido
				if MV_PAR04 = 1 //Acao = Atualiza Comissão
					if Empty(SC5->C5_VEND2) .AND. Alltrim(SC5->C5_VEND1) <> AllTrim(aMails[_XX,1])
						LogCC("SC5",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,2],"C5_VEND2",SC5->C5_VEND2,aMails[_XX,1])
						RecLock("SC5",.F.)
						SC5->C5_VEND2 := aMails[_XX,1]
						SC5->(MsUnLock())
					endif
				endif
				
				//Somente altero se estiver diferente da calculada
				if MV_PAR04 = 1 //Acao = Atualiza Comissão
					if SC5->C5_COMIS2 <> nComis .AND. Alltrim(SC5->C5_VEND2) == AllTrim(aMails[_XX,1])
						LogCC("SC5",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,2],"C5_COMIS2",Alltrim(Str(SC5->C5_COMIS2)),Alltrim(Str(nComis)))
						RecLock("SC5",.F.)
						SC5->C5_COMIS2 := nComis
						SC5->(MsUnLock())
               //se o coordenador estiver como vendedor direto
					elseif Alltrim(SC5->C5_VEND1) == AllTrim(aMails[_XX,1])						
						LogCC("SC5",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,2],"C5_COMIS1",Alltrim(Str(SC5->C5_COMIS1)),Alltrim(Str(nComis)))
						RecLock("SC5",.F.)
						SC5->C5_COMIS1 := nComis
						SC5->(MsUnLock())					
					endif
				endif
				
				if MV_PAR04 = 2
				   Aadd( aRel,{aMails[_XX,1],SC5->C5_NUM,SC5->C5_EMISSAO,SC5->C5_ENTREG,aRet[_XY,6],;
				               if(Alltrim(SC5->C5_VEND1) == AllTrim(aMails[_XX,1]),SC5->C5_COMIS1,SC5->C5_COMIS2),;
				               nComis,nVolKG, nFator, aRet[_XY,5],nVolAci,nFatAci,nBonus,nPComP } )
				endif				
			endif
			//Caso ja tenha sido faturado altero na Nota e nos Titulos
			if !Empty(aRet[_XY,3])
				//Altero a comissao na nota fiscal
				nF := if(aRet[_XY,9]=="X",2,1) //Dois passos no laço, caso o pedido seja XDD
				for nI := 1 to nF
				if SD2->(DbSeek(aRet[_XY,1]+aRet[_XY,3]+if(nI=1,aRet[_XY,4],"   ")))
					if SF2->(DbSeek(aRet[_XY,1]+aRet[_XY,3]+if(nI=1,aRet[_XY,4],"   ")))
						//Verifico se o campo coordenador esta vazio e caso esteja
						//atualizo com o coordenador do representante associado ao pedido
						if MV_PAR04 = 1 //Acao = Atualiza Comissão
							if Empty(SF2->F2_VEND2) .AND. Alltrim(SF2->F2_VEND1) <> AllTrim(aMails[_XX,1])
								LogCC("SF2",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,3]+if(nI=1,aRet[_XY,4],"   "),"F2_VEND2",SF2->F2_VEND2,aMails[_XX,1])
								RecLock("SF2",.F.)
								SF2->F2_VEND2 := aMails[_XX,1]
								SF2->(MsUnLock())
							endif
						endif
					endif
					//Percorro por todos os itens da Nota e altero o percentual da comissao do coordenador
					while !SD2->(EOF()) .and. SD2->D2_FILIAL == aRet[_XY,1] .and. SD2->D2_DOC == aRet[_XY,3];
						.and. SD2->D2_SERIE == if(nI=1,aRet[_XY,4],"   ")
						//Somente altero se estiver diferente da calculada
						if MV_PAR04 = 1 //Acao = Atualiza Comissão
							if SD2->D2_COMIS2 <> nComis .AND. Alltrim(SF2->F2_VEND2) == AllTrim(aMails[_XX,1])
								LogCC("SD2",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,3]+if(nI=1,aRet[_XY,4],"   "),"D2_COMIS2",Alltrim(Str(SD2->D2_COMIS2)),Alltrim(Str(nComis)) )
								RecLock("SD2",.F.)
								SD2->D2_COMIS2 := nComis
								SD2->(MsUnLock())
							elseif Alltrim(SF2->F2_VEND1) == AllTrim(aMails[_XX,1])
								LogCC("SD2",aMails[_XX,1]+aRet[_XY,1]+aRet[_XY,3]+if(nI=1,aRet[_XY,4],"   "),"D2_COMIS1",Alltrim(Str(SD2->D2_COMIS1)),Alltrim(Str(nComis)) )
								RecLock("SD2",.F.)
								SD2->D2_COMIS1 := nComis
								SD2->(MsUnLock())							
							endif
						endif
						SD2->(DbSkip())
					end
					//Altero a comissao no contas a receber
					if SE1->(DbSeek(aRet[_XY,1]+if(nI=1,aRet[_XY,4],"   ")+aRet[_XY,3]))
						//Percorro todos os titulos, para o caso de possuir mais de uma parcela
						while !SE1->(EOF()).and. SE1->E1_FILIAL == aRet[_XY,1] .and. SE1->E1_PREFIXO == if(nI=1,aRet[_XY,4],"   ");
							.and. SE1->E1_NUM == aRet[_XY,3] .and. Alltrim(SE1->E1_TIPO) == "NF"
							//Verifico se o campo coordenador esta vazio e caso esteja
							//atualizo com o coordenador do representante associado ao pedido
							if MV_PAR04 = 1 //Acao = Atualiza Comissão
								if Empty(SE1->E1_VEND2) .AND. Alltrim(SE1->E1_VEND1) <> AllTrim(aMails[_XX,1])
									LogCC("SE1",aMails[_XX,1]+aRet[_XY,1]+if(nI=1,aRet[_XY,4],"   ")+aRet[_XY,3]+SE1->E1_PARCELA,"E1_VEND2",SE1->E1_VEND2,aMails[_XX,1] )
									RecLock("SE1",.F.)
									SE1->E1_VEND2 := aMails[_XX,1]
									SE1->(MsUnLock())
								endif
							endif
							//Somente altero se estiver diferente da calculada
							if MV_PAR04 = 1 //Acao = Atualiza Comissão
								if SE1->E1_COMIS2 <> nComis .AND. Alltrim(SE1->E1_VEND2) == AllTrim(aMails[_XX,1])
									LogCC("SE1",aMails[_XX,1]+aRet[_XY,1]+if(nI=1,aRet[_XY,4],"   ")+aRet[_XY,3]+SE1->E1_PARCELA,"E1_COMIS2",Alltrim(Str(SE1->E1_COMIS2)),Alltrim(Str(nComis)) )
									RecLock("SE1",.F.)
									SE1->E1_COMIS2 := nComis
									SE1->(MsUnLock())
								elseif Alltrim(SE1->E1_VEND1) == AllTrim(aMails[_XX,1])
									LogCC("SE1",aMails[_XX,1]+aRet[_XY,1]+if(nI=1,aRet[_XY,4],"   ")+aRet[_XY,3]+SE1->E1_PARCELA,"E1_COMIS1",Alltrim(Str(SE1->E1_COMIS1)),Alltrim(Str(nComis)) )
									RecLock("SE1",.F.)
									SE1->E1_COMIS1 := nComis
									SE1->(MsUnLock())
								endif
							endif
							SE1->(DbSkip())
							IncProc("Processando Comissões...")
						end
					endif
				endif
				next nI
			endif
			IncProc("Processando Comissões...")
		next _XY
		IncProc("Processando Comissões...")
	endif
next _XX

if MV_PAR04 = 2
   RELCOM(aRel)   
endif


Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ btnCan()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function btnCan()

oDlg1:End()

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ btnPar()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function btnPar()

Pergunte("COMCOO",.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oPerg1()

Local aHelpPor := {}

AADD(aHelpPor,"Informe o Mês e Ano para apuração" )
PutSx1( 'COMCOO','01','Mês/Ano (mm/aaaa)','','','mv_ch1','C',6,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
aHelpPor := {}

PutSx1( 'COMCOO','02','Coord. De?','','','mv_ch2','C',6,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
aHelpPor := {}

PutSx1( 'COMCOO','03','Coord. Ate?','','','mv_ch3','C',6,0,0,'G','','','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
aHelpPor := {}

PutSx1( 'COMCOO','04','Ação ?','','','mv_ch4','N',1,0,2,'C','','','','','mv_par04','Atualiza Comissoes','','','','Gera Relatorio','','','','','','','','','','','',aHelpPor,{},{} )
aHelpPor := {}

Return


//Funcao que grava Log com as atualizações de Comissões
***************************************************
Static Function LogCC(cAlias,cDoc,cCpo,cValA,cValD)
***************************************************

RecLock("Z35",.T.)
Z35->Z35_FILIAL := xFilial("Z35")
Z35->Z35_DATA   := Date()
Z35->Z35_HORA   := Time()
Z35->Z35_ALIAS  := cAlias
Z35->Z35_DOC    := cDoc
Z35->Z35_CAMPO  := cCpo
Z35->Z35_VALANT := cValA
Z35->Z35_VALDEP := cValD
Z35->(MsUnLock())

return

****************************
Static Function RELCOM(aRel)
****************************

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Conferência de Comissão x Meta"
Local cPict         := ""
Local titulo        := "Conf.Vend.X Comis.Combo - "+mesExtenso( Val(Left(MV_PAR01,2)))+"/"+Right(MV_PAR01,4)     
Local nLin          := 80

Local Cabec1        := "Pedido  Emissão   Data p/Fat.        Vol.KG   Vlr. Pedido  % Atu.  % Calc."
                     // 999999  99/99/99  99/99/99     9.999.999,99  9.999.999,99  99,999  99,999
                     // 0123456789012345678901234567890123456789012345678901234567890123456789012
                     //           1         2         3         4         5         6         7
Local Cabec2        := ""

Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "COMCOOR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "COMCOOR" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SA3"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aRel) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*********************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aRel)
*********************************************************

Local nOrdem
Local cCoor := ""

SetRegua(RecCount())

if Len(aRel) > 0
   cCoor := aRel[1,1]
endif

for _xz := 1 to Len(aRel)
   
   //Nova pagina quando mudar o coordenador
   if cCoor <> aRel[_xz,1]
      cCoor := aRel[_xz,1]   
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
      @nLin,00 PSAY "Coordenador: "+aRel[_xz,1]+" - "+Left(Posicione( "SA3", 1, xFilial("SA3") + aRel[_xz,1], "A3_NOME" ),30) + " - COMISSÃO PADRÃO: "+Transform(aRel[_xz,14],"@E 99.99");nLin++
      @nLin,00 PSAY "Total VENDIDO : "+Transform(aRel[_xz,8],"@E 9,999,999.99")+"Kg - VOL.ACIMA: "+if(aRel[_xz,11]=0,"   N/A        ",Transform(aRel[_xz,11],"@E 9,999,999.99")+"Kg")+" - BONUS: "+Transform(aRel[_xz,13]/2,"@E 99.99")+"%"; nLin++
      @nLin,00 PSAY "Fator MEDIO R$: "+Transform(aRel[_xz,9],"@E 999.99")+"         - PRC.ACIMA: "+if(aRel[_xz,12]=0,"   N/A",Transform(aRel[_xz,12],"@E 999.99"))+"         - BONUS: "+Transform(aRel[_xz,13]/2,"@E 99.99")+"%"; nLin++
      @nLin,00 PSAY Replicate("-",limite); nLin++
   endif
        
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
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
      @nLin,00 PSAY "Coordenador: "+aRel[_xz,1]+" - "+Left(Posicione( "SA3", 1, xFilial("SA3") + aRel[_xz,1], "A3_NOME" ),30) + " - COMISSÃO PADRÃO: "+Transform(aRel[_xz,14],"@E 99.99");nLin++
      @nLin,00 PSAY "Total VENDIDO : "+Transform(aRel[_xz,8],"@E 9,999,999.99")+"Kg - VOL.ACIMA: "+if(aRel[_xz,11]=0,"   N/A        ",Transform(aRel[_xz,11],"@E 9,999,999.99")+"Kg")+" - BONUS: "+Transform(aRel[_xz,13]/2,"@E 99.99")+"%"; nLin++
      @nLin,00 PSAY "Fator MEDIO R$: "+Transform(aRel[_xz,9],"@E 999.99")+"         - PRC.ACIMA: "+if(aRel[_xz,12]=0,"   N/A",Transform(aRel[_xz,12],"@E 999.99"))+"         - BONUS: "+Transform(aRel[_xz,13]/2,"@E 99.99")+"%"; nLin++
      @nLin,00 PSAY Replicate("-",limite); nLin++
   Endif

   @nLin,00 PSAY aRel[_xz,2] //Numero do Pedido
   @nLin,08 PSAY aRel[_xz,3] //Data Emissao
   @nLin,18 PSAY aRel[_xz,4] //Previsão Faturamento
   @nLin,31 PSAY Transform( aRel[_xz,10], "@E 9,999,999.99" ) //Valor em KG do pedido
   @nLin,45 PSAY Transform( aRel[_xz,5], "@E 9,999,999.99" ) //Valor em R$ do pedido sem IPI
   @nLin,59 PSAY Transform( aRel[_xz,6], "@E 99.999" ) //% Comissão atual
   @nLin,67 PSAY Transform( aRel[_xz,7], "@E 99.999" ) //% Comissão Calculada conforme "COMBO"
   nLin := nLin + 1 

next _xz

Roda(,,tamanho)

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return