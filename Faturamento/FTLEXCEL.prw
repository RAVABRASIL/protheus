#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠ЁPrograma  :NEWSOURCE Ё Autor :TEC1 - Designer       Ё Data :19/02/2016 Ё╠╠
╠╠цддддддддддеддддддддддадддддддеддддддддбддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametros:                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       :                                                            Ё╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/

User Function FTLEXCEL()

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis Private dos Objetos                             ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
SetPrvt("oFont1","oDlg1","oSBox1","oSay1")

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ Definicao do Dialog e todos os seus componentes.                        ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
oFont1     := TFont():New( "MS Sans Serif",0,-32,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 152,409,515,990,"",,,.F.,,,,,,.T.,,,.F. )
oSBox1     := TScrollBox():New( oDlg1,000,000,177,288,.T.,.T.,.T. )
oSay1      := TSay():New( 010,111,{||"Excel "},oSBox1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,147,030)
//nome do botao / funcao do botao 
//falta adicionar o botЦo de listas - FXLSLIST()
aCap:={'Cliente/u_FXLSCLI2()',;
       'Produto/U_FXLSPRO2()',;
       'Fat/U_FXLSFAT2()',;
       'FTExcel/U_FXLSFA()',;//teste
       "Pedido/U_FXLSPED3()",;
       "Realizado/U_FXLSREAL()",;
       "Prev.Vend/U_FXLSPVEN2()",;
       "Vend.Segm./U_FXLSSGM2()",;
       "Cobertura/U_FXLSCOB2()",;
       "Ligacao/U_FXLSTEL2()",;
       "Curva/U_fXlsFP()"}

       
nLinB := 47
aColB := {019,103,190}
ncolB:=1

FOR _Y:=1 TO len(aCap) // QUANTIDADE DE BOTAO POR LINHA (3)

	_Cap               := alltrim(substr(aCap[_Y],1,at("/",aCap[_Y])-1))
	cNomObj            := "oBTN"+cValToChar(_Y)
   cbAction            := "{||fOk("+alltrim(substr(aCap[_Y],at("/",aCap[_Y])+1,len(aCap[_Y])))+")}"
	bAction            := &(cbAction)
    &cNomObj           := TButton():New( nLinB,acolB[ncolB],_Cap,oSBox1,bAction,068,033,,oFont1,,.T.,,"",,,,.F. )

    if _Y%3 = 0
				
		nLinB+=48
		ncolB:=1
	else
	
	    ncolB+=1			
	    
	endif

NEXT

oDlg1:Activate(,,,.T.)

Return


Static Function fOk(cFuncao)

if !empty(cFuncao)
   
   &(cFuncao)

endif


Return
