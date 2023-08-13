#include 'topconn.ch'
#include 'fivewin.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPE01R   บAutor ณLuis Henrique Robustoบ Data ณ  23/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPRESSAO DE CARTAO PONTO.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE (Gestao Pessoal)                                   บฑฑ
ฑฑบ          ณ Exclusivo Grupo Rech.                                      บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GPE01R()
Private	aAreaSRJ	:= SRJ->(GetArea()),;
		cPerg		:= 'GPE01R',;
		oFont06 	:= TFont():New('Arial',9,06,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont10 	:= TFont():New('Arial',9,10,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont13 	:= TFont():New('Arial',9,13,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont14 	:= TFont():New('Arial',9,14,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont17 	:= TFont():New('Arial',9,17,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont20 	:= TFont():New('Arial',9,20,.T.,.T.,5,.T.,5,.T.,.F.),;
		nLin		:= 105,;
		nCol		:= 30,;
		nLinBar		:= 0,;
		nColBar		:= 0,;
		nPrint		:= 1,;
		nImpresso	:= 1,;
		aDados		:= {}

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjusta os parametros.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		AjustaSX1()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFaz as perguntas ao usuแrio.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Pergunte(cPerg,.t.)
		Private	cMatIni	:= mv_par01,;		// Matricula Inicial
				cMatFim	:= mv_par02			// Matrocula Final		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta a query com os registros. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cSELECT :=	'SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CIC, SRA.RA_RG, '+;
					'SRA.RA_ADMISSA, SRA.RA_CODFUNC, SRA.RA_APELIDO '

		cFROM   :=	RetSqlName('SRA') + ' SRA '
           
		cWHERE  :=	'SRA.D_E_L_E_T_ <>   '+Chr(39) + '*'             	+Chr(39) + ' AND '+;
					'SRA.RA_FILIAL  =    '+Chr(39) + xFilial('SRA')  	+Chr(39) + ' AND '+;
					'SRA.RA_MAT     >=   '+Chr(39) + cMatIni         	+Chr(39) + ' AND '+;
					'SRA.RA_MAT     <=   '+Chr(39) + cMatFim         	+Chr(39)

		cORDER  :=	'SRA.RA_FILIAL, SRA.RA_MAT '

		cQuery  :=	' SELECT '   + cSELECT + ; 
					' FROM '     + cFROM   + ;
					' WHERE '    + cWHERE  + ;
					' ORDER BY ' + cORDER

		TCQUERY cQuery NEW ALIAS 'TRA'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
		
		DbSelectArea('TRA')
		TRA->(DbGoTop())

		TcSetField('TRA','RA_ADMISSA','D')

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se existe registro para impressao.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	TRA->( Eof() )
			Help('',1,'GPE01R',,OemToAnsi('Nenhum funcionแrio encontrado.'),1)
			TRA->(DbCloseArea())
			Return
		Else
			While	TRA->( ! Eof() )
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณElementos da Array:ณ
					//ณ                   ณ
					//ณ1) Matricula       ณ
					//ณ2) Nome            ณ
					//ณ3) CFP             ณ
					//ณ4) RG              ณ
					//ณ5) Admissao        ณ
					//ณ6) Cod. da Funcao  ณ
					//ณ7) Nome do Func.   ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aAdd(aDados,{TRA->RA_MAT, Iif(Empty(TRA->RA_APELIDO),TRA->RA_NOME,TRA->RA_APELIDO), TRA->RA_CIC, TRA->RA_RG, TRA->RA_ADMISSA, TRA->RA_CODFUNC, TRA->RA_NOME})
				TRA->(DbSkip())
			End
			TRA->(DbCloseArea())
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicia a impressao do cartao ponto.!ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPr := TMSPrinter():New('Impressใo de Cart๕es Ponto')
		oPr:SetPortrait()

		While	( nImpresso <= Len(aDados) )

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณF R E N T  E     D O    C A R T A Oณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oPr:StartPage()

				nCol := 30
				nLin := 105

				For nx:=1 to 3

					For nf:=1 to 3

						If	( nImpresso <= Len(aDados) )

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณImprime os dados do Cartao Ponto.ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							oPr:SayBitmap(nLin,nCol,'RTLIBGPE.BMP',780,1060)
							oPr:Say(nLin+795,nCol+395,AllTrim(SubStr(aDados[nImpresso][2],1,15)),oFont20,nCol+395,,,2)
							DbSelectArea('SRJ')
							SRJ->(DbSetOrder(1))
							If	SRJ->(DbSeek(xFilial('SRJ')+aDados[nImpresso][6]))
								oPr:Say(nLin+930,nCol+395,Capital(SRJ->RJ_DESC),oFont14,nCol+395,,,2)
							EndIf

							nImpresso++
							nPrint++

							nCol += 782

						EndIf

					Next nf

					nCol := 30
					nLin += 1100

				Next nx

				oPr:EndPage()

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณV E R S O      D O      C A R T A Oณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oPr:StartPage()

				nCol 	:= 30
				nLin 	:= 105
				nLinBar	:= 4.30
				nColBar	:= 0.80
				nImpresso := nImpresso - (nPrint-1)
				nPrint	:= 1

				For nx:=1 to 3

					For nf:=1 to 3

						If	( nImpresso <= Len(aDados) )

							oPr:SayBitmap(nLin,nCol,'RTLICGPE.BMP',0780,1060)

							oPr:Box(nLin+075,nCol+040,nLin+175,nCol+710)
							oPr:Say(nLin+080,nCol+060,'Nome:',oFont06)
							oPr:Say(nLin+110,nCol+060,aDados[nImpresso][7],oFont10)

							oPr:Box(nLin+195,nCol+040,nLin+295,nCol+390)
							oPr:Say(nLin+200,nCol+060,'C.P.F:',oFont06)
							oPr:Say(nLin+240,nCol+060,TransForm(aDados[nImpresso][3],'@R 999.999.999-99'),oFont10)
							oPr:Box(nLin+195,nCol+410,nLin+295,nCol+710)
							oPr:Say(nLin+200,nCol+430,'R.G.:',oFont06)
							oPr:Say(nLin+240,nCol+430,aDados[nImpresso][4],oFont10)

							oPr:Box(nLin+315,nCol+040,nLin+415,nCol+460)
							oPr:Say(nLin+320,nCol+060,'Loja do Grupo:',oFont06)
							oPr:Say(nLin+360,nCol+060,AllTrim(Capital(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB),oFont10)
							oPr:Box(nLin+315,nCol+430,nLin+415,nCol+710)
							oPr:Say(nLin+320,nCol+450,'Admissใo:',oFont06)
							oPr:Say(nLin+360,nCol+450,Dtoc(aDados[nImpresso][5]),oFont10)

							oPr:Box(nLin+625,nCol+040,nLin+720,nCol+710)
							oPr:Say(nLin+625,nCol+060,OemToAnsi('Fone Emerg๊ncia:'),oFont06)
							oPr:Say(nLin+655,nCol+210,'(66) 511-8800',oFont17)
							oPr:Say(nLin+745,nCol+310,SubStr(aDados[nImpresso][1],2,Len(aDados[nImpresso][1])),oFont14)

							MsBar("CODE3_9",nLinBar,nColBar,SubStr(aDados[nImpresso][1],2,Len(aDados[nImpresso][1])),oPr,.f.,,,0.0254,0.91,,,'A',.f.)

							nImpresso++

							nCol += 782
							nColBar += 3.3

						EndIf

					Next nf

					nCol := 30
					nLin += 1100

					nColBar := 0.80
					nLinBar += 4.68

				Next nx

				oPr:EndPage()

		End

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFinaliza a Impressao. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPr:EndPage()
		oPr:Preview()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRestaura a area anterior ao processamento.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RestArea(aAreaSRJ)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPE01R   บAutor ณLuis Henrique Robustoบ Data ณ  23/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para atualizar o arquivo de perguntas do SX1        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCampos a serem grav. no SX1ณ
		//ณaRegs[nx][01] - X1_GRUPO   ณ
		//ณaRegs[nx][02] - X1_ORDEM   ณ
		//ณaRegs[nx][03] - X1_PERGUNTEณ
		//ณaRegs[nx][04] - X1_PERSPA  ณ
		//ณaRegs[nx][05] - X1_PERENG  ณ
		//ณaRegs[nx][06] - X1_VARIAVL ณ
		//ณaRegs[nx][07] - X1_TIPO    ณ
		//ณaRegs[nx][08] - X1_TAMANHO ณ
		//ณaRegs[nx][09] - X1_DECIMAL ณ
		//ณaRegs[nx][10] - X1_PRESEL  ณ
		//ณaRegs[nx][11] - X1_GSC     ณ
		//ณaRegs[nx][12] - X1_VALID   ณ
		//ณaRegs[nx][13] - X1_VAR01   ณ
		//ณaRegs[nx][14] - X1_DEF01   ณ
		//ณaRegs[nx][15] - X1_DEF02   ณ
		//ณaRegs[nx][16] - X1_DEF03   ณ
		//ณaRegs[nx][17] - X1_F3      ณ
		//ณaRegs[nx][18] - X1_CNT01   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria uma array, contendo todos os valores...ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAdd(aRegs,{cPerg,'01','Matricula Inicial  ?','Matricula Inicial  ?','Matricula Inicial  ?','mv_ch1','C', 6,0,1,'G','','mv_par01','','','','SRA',''})
		aAdd(aRegs,{cPerg,'02','Matricula Final    ?','Matricula Final    ?','Matricula Final    ?','mv_ch2','C', 6,0,0,'G','','mv_par02','','','','SRA',''})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))
		For nX:=1 to Len(aRegs)
			If	RecLock('SX1',Iif(!SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])),.t.,.f.))
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				If	( ! Found() )
					Replace SX1->X1_PRESEL		With aRegs[nx][10]
				EndIf	
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				MsUnlock('SX1')
			Else
				Help('',1,'REGNOIS')
			EndIf
		Next nX

Return