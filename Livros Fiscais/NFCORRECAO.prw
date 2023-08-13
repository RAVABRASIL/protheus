#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
***********************
User Function CORREC1()
***********************

Local aCores := {{"Empty(F2_CORREG)" , "BR_VERDE"   },;
                 {"!Empty(F2_CORREG)", "BR_VERMELHO"}}

aRotina := {{"Pesquisar" , "AxPesqui"        , 0, 1},;
            {"Visualizar", "U_CORREC2('S',2)", 0, 2},;
            {"Incluir"   , "U_CORREC2('S',3)", 0, 3},;
            {"Alterar"   , "U_CORREC2('S',4)", 0, 4},;
            {"Excluir"   , "U_CORREC2('S',5)", 0, 5},;
            {"Legenda"   , "U_LegEdit"       , 0, 6}}

cCadastro := OemToAnsi("Notas de Correção")

DbSelectArea("SF2")
DbSetOrder(1)

Set Filter To SF2->F2_SERIE == "UNI"

mBrowse( 06, 01, 22, 75, "SF2",,,,,,aCores )

Return

***********************
User Function CORREC3()
***********************

Local aCores := {{"Empty(F1_CORREG)" , "BR_VERDE"   },;
                 {"!Empty(F1_CORREG)", "BR_VERMELHO"}}

aRotina := {{"Pesquisar" , "AxPesqui"        , 0, 1},;
            {"Visualizar", "U_CORREC2('E',2)", 0, 2},;
            {"Incluir"   , "U_CORREC2('E',3)", 0, 3},;
            {"Alterar"   , "U_CORREC2('E',4)", 0, 4},;
            {"Excluir"   , "U_CORREC2('E',5)", 0, 5},;
            {"Legenda"   , "U_LegEdit"       , 0, 6}}

cCadastro := OemToAnsi("Notas de Correção")

DbSelectArea("SF1")
DbSetOrder(1)

Set Filter To SF1->F1_SERIE == "UNI"

mBrowse( 06, 01, 22, 75, "SF1",,,,,,aCores )

Return


*****************************************
User Function CORREC2(cTipo,nOpc,aRotAut)
*****************************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cCorrr

Private cCNPJ      := Space(14)
Private cCorreg    := Space(6)
Private dEmisCor   := CTOD(" ")
Private dEmissao   := CTOD(" ")
Private cEnd       := Space(40)
Private cMun       := Space(40)
Private cForCli    := Space(40)
Private cIncrEst   := Space(20)
Private cNumNota   := Space(6)
Private cSerie     := Space(3)

Private cCodCF     

Private lCBox01    := .F.
Private lCBox02    := .F.
Private lCBox03    := .F.
Private lCBox04    := .F.
Private lCBox05    := .F.
Private lCBox06    := .F.
Private lCBox07    := .F.
Private lCBox08    := .F.
Private lCBox09    := .F.
Private lCBox10    := .F.
Private lCBox11    := .F.
Private lCBox12    := .F.
Private lCBox13    := .F.
Private lCBox14    := .F.
Private lCBox15    := .F.
Private lCBox16    := .F.
Private lCBox17    := .F.
Private lCBox18    := .F.
Private lCBox19    := .F.
Private lCBox20    := .F.
Private lCBox21    := .F.
Private lCBox22    := .F.
Private lCBox23    := .F.
Private lCBox24    := .F.
Private lCBox25    := .F.
Private lCBox26    := .F.
Private lCBox27    := .F.
Private lCBox28    := .F.
Private lCBox29    := .F.
Private lCBox30    := .F.
Private lCBox31    := .F.
Private lCBox32    := .F.
Private lCBox33    := .F.
Private lCBox34    := .F.
Private lCBox35    := .F.

Private aItens := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oDlg1","oGrp1","oSay2","oSay3","oSay4","oSay6","oSay7","oSay1","oSay8")
SetPrvt("oGet1","oGet3","oGet4","oGet6","oGet7","oGet2","oGet8","oGet11","oGrp2","oCBox01","oCBox02")
SetPrvt("oCBox04","oCBox08","oCBox07","oCBox06","oCBox05","oCBox09","oCBox10","oCBox11","oCBox12","oCBox13")
SetPrvt("oCBox19","oCBox18","oCBox16","oCBox17","oCBox15","oCBox21","oCBox20","oCBox24","oCBox23","oCBox22")
SetPrvt("oCBox26","oCBox27","oCBox35","oCBox34","oCBox33","oCBox31","oCBox30","oCBox29","oCBox28","oCBox32")
SetPrvt("oSay9","oSay10","oGet9","oGet10","oSBtn3","oSBtn2")


if ValType(aRotAut) != "A"
	
	if cTipo == "E"
		if !Empty(SF1->F1_CORREG)
			if nOpc = 3
				Alert("Nota Fiscal ja possui corregenda.")
				Return
			else
				cCorr := SF1->F1_CORREG
			endif
		endif
	elseif cTipo == "S"
		if !Empty(SF2->F2_CORREG)
			if nOpc = 3
				Alert("Nota Fiscal ja possui corregenda.")
				Return
			else
				cCorr := SF2->F2_CORREG
			endif
		endif
	endif

	if ( cTipo == "E" .AND. SF1->F1_TIPO == "N" ) .OR.;
		( cTipo == "S" .AND. SF2->F2_TIPO == "D" )
		DbSelectArea("SA2")
		DbSetOrder(1)
		if cTipo == "E"
			SA2->(DbSeek(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA)))
			dEmissao   := SF1->F1_EMISSAO
			cNumNota   := SF1->F1_DOC
			cSerie     := SF1->F1_SERIE
		else
			SA2->(DbSeek(xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA)))
			dEmissao   := SF2->F2_EMISSAO
			cNumNota   := SF2->F2_DOC
			cSerie     := SF2->F2_SERIE
		endif
		cCNPJ      := SA2->A2_CGC
		cEnd       := Alltrim(SA2->A2_END)+" - "+SA2->A2_BAIRRO
		cCodCF     := SA2->A2_COD
		cLoja      := SA2->A2_LOJA
		cForCli    := cCodCF+" - "+SA2->A2_NOME
		cMun       := SA2->A2_MUN
		cIncrEst   := SA2->A2_INSCR
	elseif ( cTipo == "S" .AND. SF2->F2_TIPO == "N" ) .OR.;
		( cTipo == "E" .AND. SF1->F1_TIPO == "D" )
		DbSelectArea("SA1")
		DbSetOrder(1)
		if cTipo == "S"
			SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
			dEmissao   := SF2->F2_EMISSAO
			cNumNota   := SF2->F2_DOC
			cSerie     := SF2->F2_SERIE
		else
			SA1->(DbSeek(xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA)))
			dEmissao   := SF1->F1_EMISSAO
			cNumNota   := SF1->F1_DOC
			cSerie     := SF1->F1_SERIE
		endif
		cCNPJ      := SA1->A1_CGC
		cEnd       := Alltrim(SA1->A1_END)+" - "+SA1->A1_BAIRRO
        cCodCF     := SA1->A1_COD
		cLoja      := SA1->A1_LOJA
		cForCli    := cCodCF+" - "+SA1->A1_NOME
		cMun       := SA1->A1_MUN
		cIncrEst   := SA1->A1_INSCR
	endif
	
	DbSelectArea("SZ1")
	DbSetORder(1)
//  Z1_FILIAL+Z1_TIPO+Z1_NF+Z1_SERIE+Z1_CLIENTE+Z1_LOJA+Z1_EMISSNF                                                                                                  
	SZ1->(DbSeek(xFilial("SZ1")+cTipo+cNumNota+cSerie+cCodCF+cLoja+DtoS(dEmissao)))
	cCorreg
	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont1     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "MS Sans Serif",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 088,232,701,927,"Nota Fiscal de Correçao",,,.F.,,,,,,.T.,,oFont1,.T. )
	
	oGrp3      := TGroup():New( 001,004,040,344," Nota de Correção ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay9      := TSay():New( 011,009,{||"Número:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay10     := TSay():New( 024,009,{||"Emissão:"},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet9      := TGet():New( 010,044,{|u| If(PCount()>0,cCorreg:=u,cCorreg)},oGrp3,060,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCorreg",,)
	oGet9:lReadOnly := .T.
	oGet10     := TGet():New( 023,044,{|u| If(PCount()>0,dEmisCor:=u,dEmisCor)},oGrp3,060,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dEmisCor",,)
	oGet10:lReadOnly := .T.
	oSBtn3     := SButton():New( 023,312,2,{||GRAVA(nOpc)},oGrp3,,"", )
	oSBtn2     := SButton():New( 009,312,1,{||oDlg1:End()},oGrp3,,"", )
	
	oGrp1      := TGroup():New( 042,004,110,344,"Nota de Origem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 055,154,{||"Emissao"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,006)
	oSay3      := TSay():New( 055,006,{||"Número:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,006)
	oSay4      := TSay():New( 068,006,{||"Nome:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,007)
	oSay6      := TSay():New( 096,006,{||"CNPJ:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,019,006)
	oSay7      := TSay():New( 097,176,{||"Inscr.Est.:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,006)
	oSay1      := TSay():New( 054,087,{||"Serie"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
	oSay8      := TSay():New( 081,213,{||"Cidade:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,022,007)
	oSay11     := TSay():New( 081,006,{||"Ender.:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,019,008)
	
	oGet1      := TGet():New( 053,184,{|u| If(PCount()>0,dEmissao:=u,dEmissao)},oGrp1,058,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dEmissao",,)
	oGet1:Disable()
	oGet3      := TGet():New( 053,030,{|u| If(PCount()>0,cNumNota:=u,cNumNota)},oGrp1,049,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNumNota",,)
	oGet3:Disable()
	oGet4      := TGet():New( 066,030,{|u| If(PCount()>0,cForCli:=u,cForCli)},oGrp1,310,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cForCli",,)
	oGet4:Disable()
	oGet6      := TGet():New( 093,030,{|u| If(PCount()>0,cCNPJ:=u,cCNPJ)},oGrp1,138,010,'@R 99.999.999/9999-99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCNPJ",,)
	oGet6:Disable()
	oGet7      := TGet():New( 094,202,{|u| If(PCount()>0,cIncrEst:=u,cIncrEst)},oGrp1,138,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cIncrEst",,)
	oGet7:Disable()
	oGet2      := TGet():New( 053,108,{|u| If(PCount()>0,cSerie:=u,cSerie)},oGrp1,036,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie",,)
	oGet2:Disable()
	oGet8      := TGet():New( 080,237,{|u| If(PCount()>0,cMun:=u,cMun)},oGrp1,102,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMun",,)
	oGet8:Disable()
	oGet11     := TGet():New( 079,030,{|u| If(PCount()>0,cEnd:=u,cEnd)},oGrp1,179,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEnd",,)
	oGet11:Disable()
	
	oGrp2      := TGroup():New( 113,003,305,344," Ocorrências ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//Coluna 01
	nTop       := 123
	nInc       := 10
	oCBox01    := TCheckBox():New( nTop,007,"01 - Razão Social",{|u| If(PCount()>0,lCBox01:=u,lCBox01)},oGrp2,147,008,,{||FATA20V(oCBox01:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox02    := TCheckBox():New( nTop,007,"02 - Endereço",{|u| If(PCount()>0,lCBox02:=u,lCBox02)},oGrp2,147,008,,{||FATA20V(oCBox02:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox03    := TCheckBox():New( nTop,007,"03 - Município",{|u| If(PCount()>0,lCBox03:=u,lCBox03)},oGrp2,147,008,,{||FATA20V(oCBox03:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox04    := TCheckBox():New( nTop,007,"04 - Estado",{|u| If(PCount()>0,lCBox04:=u,lCBox04)},oGrp2,147,008,,{||FATA20V(oCBox04:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox05    := TCheckBox():New( nTop,007,"05 - No. Inscrição no CNPJ/MF",{|u| If(PCount()>0,lCBox05:=u,lCBox05)},oGrp2,147,008,,{||FATA20V(oCBox05:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox06    := TCheckBox():New( nTop,007,"06 - No. Inscrição Estadual",{|u| If(PCount()>0,lCBox06:=u,lCBox06)},oGrp2,147,008,,{||FATA20V(oCBox06:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox07    := TCheckBox():New( nTop,007,"07 - Natureza da Operação",{|u| If(PCount()>0,lCBox07:=u,lCBox07)},oGrp2,147,008,,{||FATA20V(oCBox07:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox08    := TCheckBox():New( nTop,007,"08 - Código Fiscal da Operação",{|u| If(PCount()>0,lCBox08:=u,lCBox08)},oGrp2,147,008,,{||FATA20V(oCBox08:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox09    := TCheckBox():New( nTop,007,"09 - Via de Transporte",{|u| If(PCount()>0,lCBox09:=u,lCBox09)},oGrp2,147,008,,{||FATA20V(oCBox09:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox10    := TCheckBox():New( nTop,007,"10 - Data de Emissão",{|u| If(PCount()>0,lCBox10:=u,lCBox10)},oGrp2,147,008,,{||FATA20V(oCBox10:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox11    := TCheckBox():New( nTop,007,"11 - Data de Saída",{|u| If(PCount()>0,lCBox11:=u,lCBox11)},oGrp2,147,008,,{||FATA20V(oCBox11:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox12    := TCheckBox():New( nTop,007,"12 - Unidade (Produto)",{|u| If(PCount()>0,lCBox12:=u,lCBox12)},oGrp2,147,008,,{||FATA20V(oCBox12:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox13    := TCheckBox():New( nTop,007,"13 - Quantidade (produto)",{|u| If(PCount()>0,lCBox13:=u,lCBox13)},oGrp2,147,008,,{||FATA20V(oCBox13:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox14    := TCheckBox():New( nTop,007,"14 - Descrição dos Produtos",{|u| If(PCount()>0,lCBox14:=u,lCBox14)},oGrp2,147,008,,{||FATA20V(oCBox14:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox15    := TCheckBox():New( nTop,007,"15 -Preço Unitário",{|u| If(PCount()>0,lCBox15:=u,lCBox15)},oGrp2,147,008,,{||FATA20V(oCBox15:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox16    := TCheckBox():New( nTop,007,"16 - Valor do Produto",{|u| If(PCount()>0,lCBox16:=u,lCBox16)},oGrp2,147,008,,{||FATA20V(oCBox16:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox17    := TCheckBox():New( nTop,007,"17 - Classificação Fiscal",{|u| If(PCount()>0,lCBox17:=u,lCBox17)},oGrp2,147,008,,{||FATA20V(oCBox17:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox18    := TCheckBox():New( nTop,007,"18 - Alíquota do IPI",{|u| If(PCount()>0,lCBox18:=u,lCBox18)},oGrp2,147,008,,{||FATA20V(oCBox18:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	
	//Coluna 02
	nTop       := 123
	oCBox19    := TCheckBox():New( nTop,176,"19 - Valor do IPI",{|u| If(PCount()>0,lCBox19:=u,lCBox19)},oGrp2,147,008,,{||FATA20V(oCBox19:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox20    := TCheckBox():New( nTop,176,"20 - Base de Cálculo do IPI",{|u| If(PCount()>0,lCBox20:=u,lCBox20)},oGrp2,147,008,,{||FATA20V(oCBox20:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox21    := TCheckBox():New( nTop,176,"21 - VAlor Tota da Nota",{|u| If(PCount()>0,lCBox21:=u,lCBox21)},oGrp2,147,008,,{||FATA20V(oCBox21:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox22    := TCheckBox():New( nTop,176,"22 -  Alíquota do ICMS",{|u| If(PCount()>0,lCBox22:=u,lCBox22)},oGrp2,147,008,,{||FATA20V(oCBox22:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox23    := TCheckBox():New( nTop,176,"23 -Valor do ICMS",{|u| If(PCount()>0,lCBox23:=u,lCBox23)},oGrp2,147,008,,{||FATA20V(oCBox23:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox24    := TCheckBox():New( nTop,176,"24 - Base de Cálculo do ICMS",{|u| If(PCount()>0,lCBox24:=u,lCBox24)},oGrp2,147,008,,{||FATA20V(oCBox24:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox25    := TCheckBox():New( nTop,176,"25 - Nome do Transportador",{|u| If(PCount()>0,lCBox25:=u,lCBox25)},oGrp2,147,008,,{||FATA20V(oCBox25:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox26    := TCheckBox():New( nTop,176,"26 - Endereço do Transportador",{|u| If(PCount()>0,lCBox26:=u,lCBox26)},oGrp2,147,008,,{||FATA20V(oCBox026cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox27    := TCheckBox():New( nTop,176,"27 - Termo de Isenção do IPI",{|u| If(PCount()>0,lCBox27:=u,lCBox27)},oGrp2,147,008,,{||FATA20V(oCBox27:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox28    := TCheckBox():New( nTop,176,"28 - Termo de Isenção do ICMS",{|u| If(PCount()>0,lCBox28:=u,lCBox28)},oGrp2,147,008,,{||FATA20V(oCBox28:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox29    := TCheckBox():New( nTop,176,"29 - Peso - Bruto/Líquido",{|u| If(PCount()>0,lCBox29:=u,lCBox29)},oGrp2,147,008,,{||FATA20V(oCBox29:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox30    := TCheckBox():New( nTop,176,"30 - Volume - Marca/Num/Quant",{|u| If(PCount()>0,lCBox30:=u,lCBox30)},oGrp2,147,008,,{||FATA20V(oCBox30:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox31    := TCheckBox():New( nTop,176,"31 - No. do Pedido",{|u| If(PCount()>0,lCBox31:=u,lCBox31)},oGrp2,147,008,,{||FATA20V(oCBox31:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox32    := TCheckBox():New( nTop,176,"32 - Vencimento Duplicatas",{|u| If(PCount()>0,lCBox32:=u,lCBox32)},oGrp2,147,008,,{||FATA20V(oCBox32:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox33    := TCheckBox():New( nTop,176,"33 - Endereço de Entrega",{|u| If(PCount()>0,lCBox33:=u,lCBox33)},oGrp2,147,008,,{||FATA20V(oCBox33:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox34    := TCheckBox():New( nTop,176,"34 - Dados do Corpo da Nota Fiscal",{|u| If(PCount()>0,lCBox34:=u,lCBox34)},oGrp2,147,008,,{||FATA20V(oCBox34:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	nTop       += nInc
	oCBox35    := TCheckBox():New( nTop,176,"35 - Outros",{|u| If(PCount()>0,lCBox35:=u,lCBox35)},oGrp2,147,008,,{||FATA20V(oCBox35:cCaption)},oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	
	
	oDlg1:Activate(,,,.T.)
else
	
	
endif


Return

***************************
static function Grava(nOpc)
***************************

local nX

if nOpc == 3
   for nX := 1 to 35
      if &("lCBox"+StrZero(nX,2))
      
      endif
   next nX
endif

return


*****************************
Static Function Clica(cTitoDlg)
*****************************

local xPicture
local cItem  := Subs(cTitoDlg,1,2)
local cDescr := Subs(cTitoDlg,6,Len(cTitoDlg)-5)
local lClick := &("lCBox"+cItem)

Private oDlg3
Private oGetCtd
Private oSBtn3
Private xGetCtd

if lClick
	if cItem$"01/02/03/04/05/06/07/08/09/11/12/14/17/25/26/27/28/29/30/31/32/33/34/35/36"
		xGetCtd  := Space(40)
		xPicture := ""
	else
		xGetCtd  := 0
		if cItem$"15/16/19/20/21/22/23/24"
			xPicture := "@E 99,999,999.99"
		else
			xPicture := "@E 99,999,999"
		endif
	endif
	
	oDlg3   := MSDialog():New( 284,232,344,927,cTitoDlg,,,.F.,,,,,,.T.,,,.T. )
	oGetCtd := TGet():New( 007,004,{|u| If(PCount()>0,xGetCtd:=u,xGetCtd)},oDlg3,274,008,xPicture,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","xGetCtd",,)
	oGetCtd:bValid := {||NaoVazio()}
	oSBtn31 := SButton():New( 005,312,1,{||FATA20VC()},oDlg3,,"", )
	oDlg3:Activate(,,,.T.)
	
	if Empty(xGetCtd)
		Alert("Campo obrigatorio! Informe-o.")
		FATA20V(cTitoDlg)
	else
		if Empty(aCoBrw1[1,1])
			aCoBrw1 := {}
		endif
		if cItem$"01/02/03/04/05/06/07/08/09/12/14/15/25/26/27/28/29/31/41"
			Aadd(aCoBrw1,Array(5))
			aCoBrw1[Len(AcoBrw1),1] := cItem
			aCoBrw1[Len(AcoBrw1),2] := cDescr
			aCoBrw1[Len(AcoBrw1),3] := 0
			aCoBrw1[Len(AcoBrw1),4] := xGetCtd
			aCoBrw1[Len(AcoBrw1),5] := .F.
		else
			Aadd(aCoBrw1,Array(5))
			aCoBrw1[Len(AcoBrw1),1] := cItem
			aCoBrw1[Len(AcoBrw1),2] := cDescr
			aCoBrw1[Len(AcoBrw1),3] := xGetCtd
			aCoBrw1[Len(AcoBrw1),4] := Space(40)
			aCoBrw1[Len(AcoBrw1),5] := .F.
		endif
	endif
else
	aCoBrw1 := ADel( aCoBrw1, aScan( aCoBrw1, { |x| x[1] == cItem } ) )
	aCoBrw1 := aSize( aCoBrw1,Len( aCoBrw1 )-1)
	If Empty( Len( aCoBrw1 ) )
		MCoBrw1()
	EndIf
endif


return