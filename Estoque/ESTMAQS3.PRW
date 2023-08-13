#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :9/2/2009   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

*************

User Function ESTMAQS3()

*************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1" ,"oBmp1" ,"oBmp2"  ,"oBmp3","oBmp4" ,"oSay1" ,"oSay2" ,"oSay3" ,"oSay4" ,"oSay5","oSay6")
SetPrvt("oSay8" ,"oSay9" ,"oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay17","oSay18")
SetPrvt("oSay20","oSay21","oSay22","oSay23","oSay24","oSay25","oSay26","oSay27","oSay28","oSay29","oSay30")
SetPrvt("oSay32","oSay33","oSay34","oSay35","oSay36","oSay37","oSay38","oSay39","oSay40","oSay41","oSay42")
SetPrvt("oSay44","oSay45","oSay46","oBmp5" ,"oBmp6" ,"oSay47","oSay48","oSay49","oSay50","oSay51","oSay52")
SetPrvt("oSay54","oSay55","oSay56","oSay57","oSay58","oSay59","oSay60","oSay61","oSay62","oSay63","oSay64")
SetPrvt("oSay66","oSay67","oSay68","oSay69","oSay70","oSay71","oSay72","oSay73","oSay74","oSay75","oSay76")
SetPrvt("oSay78","oSay79","oSay80","oSay81","oSay82","oSay83","oSay84","oSay85","oSay86","oSay87","oSay88")
SetPrvt("oSay90","oSay91","oSay92","oSay93","oSay94","oTimer1","oTimer2","oBmp7","oBmp8")
SetPrvt("cBuffer","nHandle","cMaqn1","cMaqn2","cTurno1","cTurno2","cTurno3","cJust1","cJust2")
SetPrvt("oPanel1","oSay96","oSay18","oCBox1","oMGet1","oPanel2","oSay97","oSay95","oCBox2","oMGet2","cStop1","cStop2")
Private oTimer1
Private oTimer2 
Private oTimer3
Private oTimer4
Private cMaqZero	//FR
Private cMaqUm      //FR
Private oMGet1
Private oMGet2
Private oCbox1
Private oCbox2
Private cStop1 := cStop2 := "1"
Private cJust1 := cJust2 := ""
Private nTela  := 0
Private nPrdHA := nPrdHB := 0
cTURNO1   := GetMv( "MV_TURNO1" ) 
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )

//Perguntas:
//mv_par01 - OP Máquina 1
//mv_par02 - OP Máquina 2

If !pergunte( "ESTMAQS3", .T. )
	return
EndIf

cBuffer := ""
nHandle := FOpen("c:\maquina.txt")		
//lê o arquivo txt do computador da própria máquina para saber qual o código da mesma (armazenado em cBuffer)
FREAD( nHandle , @cBuffer , 8 )
If nHandle < 0
	//FClose( nHandle )
	//msgAlert("Não foi possível encontrar o arquivo de definição das máquinas!")
	//return
EndIf
FClose( nHandle )

if substr(cBuffer,1,2) $'C0/C1/C2/C3/C4/C5/C6/C7/C8/C9'
	cMaqn1 := "Corte e Solda "+ substr(cBuffer,2,2) +" A"

elseIf substr(cBuffer,1,2) $'P0/P1/P2/P3/P4/P5/P6/P7/P8/P9'
	cMaqn1 := "Picotadeira "+ substr(cBuffer,2,2) +" A"

elseIf substr(cBuffer,1,2) $'S0/S1/S2/S3/S4/S5/S6/S7/S8/S9'
	cMaqn1 := "Sacoleira "+ substr(cBuffer,2,2) +" A"

endIf
if substr(cBuffer,4,2) $'C0/C1/C2/C3/C4/C5/C6/C7/C8/C9'

	cMaqn2 := "Corte e Solda "+ substr(cBuffer,5,2)+" B"
elseIf substr(cBuffer,4,2) $'P0/P1/P2/P3/P4/P5/P6/P7/P8/P9'

	cMaqn2 := "Picotadeira "+ substr(cBuffer,5,2) +" B"
elseIf substr(cBuffer,4,2) $'S0/S1/S2/S3/S4/S5/S6/S7/S8/S9'

	cMaqn2 := "Sacoleira "+ substr(cBuffer,5,2) +" B"
endIf 


/*
if substr(cBuffer,1,2) == "C0"
	cMaqn1 := "Corte e Solda "+ substr(cBuffer,3,1) +" A"

elseIf substr(cBuffer,1,2) == "P0"
	cMaqn1 := "Picotadeira "+ substr(cBuffer,3,1) +" A"

elseIf substr(cBuffer,1,2) == "S0"
	cMaqn1 := "Sacoleira "+ substr(cBuffer,3,1) +" A"

endIf
if substr(cBuffer,4,2) == "C0"

	cMaqn2 := "Corte e Solda "+ substr(cBuffer,6,1) +" B"
elseIf substr(cBuffer,4,2) == "P0"

	cMaqn2 := "Picotadeira "+ substr(cBuffer,6,1) +" B"
elseIf substr(cBuffer,4,2) == "S0"

	cMaqn2 := "Sacoleira "+ substr(cBuffer,6,1) +" B"
endIf 
*/



//FR 
cMaqZero := Substr(cBuffer,1,3)    //Aqui é armazenada na variável cMaqzero o código da máquina que fica do lado esquerdo (zero)
cMaqUm   := Substr(cBuffer,4,3)	   //Aqui é armazenada na variável cMaqzero o código da máquina que fica do lado direito (um)

//FR: Aqui chama a função que irá gravar a data e hora de entrada na tela de produção
//servirá como um apontamento de tempo trabalhado pela máquina.
fGrvInicio(mv_par01,mv_par02,cMaqzero,cMaqUm)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial",0,-24,,.F.,0,,400,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial",0,-90,,.F.,0,,400,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Arial",0,-35,,.F.,0,,400,.F.,.F.,,,,,, )
oFont4     := TFont():New( "Arial",0,-22,,.F.,0,,400,.F.,.F.,,,,,, )
oFont5     := TFont():New( "Arial",0,-16,,.T.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 126,254,701,1049,"Corte e Solda",,,.F.,,,,,,.T.,,,.T. )
oBmp1      := TBitmap():New( 004,004,191,201,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )     //FR -primeiro quadrado branco - lado esquerdo
oBmp2      := TBitmap():New( 004,200,191,201,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )    //FR - segundo quadrado branco - lado direito

oSay69     := TSay():New( 279,008,{||"F3 >> Próxima Tela"},oDlg1,,oFont5,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) //FR - frase após último quadrado branco
/*
oSay1      := TSay():New( 007,057,{||cMaqn1},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,095,014)
oSay2      := TSay():New( 007,253,{||cMaqn2},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,095,014)
*/
oSay1      := TSay():New( 007,057,{||cMaqn1},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,014)
oSay2      := TSay():New( 007,253,{||cMaqn2},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,014)

oSay3      := TSay():New( 022,008,{||"OP C.S. Nº:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)     && <==== LARG./ALTURA
oSay4      := TSay():New( 036,008,{||"Produto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay5      := TSay():New( 048,008,{||"Quantidade(KG):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay6      := TSay():New( 061,008,{||"Quantidade(MR/FD):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay48     := TSay():New( 073,008,{||"Qtd. Produzida:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)

oSay7      := TSay():New( 085,035,{||"       DADOS TÉCNICOS / FORMULAÇÃO"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,183,008)

oSay8      := TSay():New( 096,008,{||"Comprimento:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay9      := TSay():New( 109,008,{||"Largura:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay10     := TSay():New( 122,008,{||"Espessura:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay11     := TSay():New( 135,008,{||"Qde. Por Pacote:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay12     := TSay():New( 147,008,{||"Altura do triângulo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay13     := TSay():New( 160,008,{||"Velocidade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,097,008)
oSay14     := TSay():New( 022,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //OP
oSay15     := TSay():New( 036,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //PRODUTO
oSay16     := TSay():New( 048,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //QTDE KG
oSay17     := TSay():New( 061,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //QTDE MR
oSay49     := TSay():New( 073,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //QTDE PRODUZIDA (PESADA)

oSay19     := TSay():New( 096,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //COMPRIMENTO
oSay20     := TSay():New( 109,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //LARGURA
oSay21     := TSay():New( 122,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //ESPESSURA
oSay22     := TSay():New( 135,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //QDE POR PACOTE
oSay23     := TSay():New( 147,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //ALTURA DO TRIÂNGULO
oSay24     := TSay():New( 160,080,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)   //VELOCIDADE

oSay25     := TSay():New( 022,206,{||"OP C.S. Nº:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay26     := TSay():New( 036,206,{||"Produto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay27     := TSay():New( 048,206,{||"Quantidade(KG):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay28     := TSay():New( 061,206,{||"Quantidade(MR/FD):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay50     := TSay():New( 073,206,{||"Qtd. Produzida:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)

oSay29     := TSay():New( 085,233,{||"       DADOS TÉCNICOS / FORMULAÇÃO"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,183,008)

oSay30     := TSay():New( 096,206,{||"Comprimento:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay31     := TSay():New( 109,206,{||"Largura:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay32     := TSay():New( 122,206,{||"Espessura:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay33     := TSay():New( 135,206,{||"Qde. Por Pacote:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay34     := TSay():New( 147,206,{||"Altura do Triângulo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay35     := TSay():New( 160,206,{||"Velocidade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oSay46     := TSay():New( 022,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //OP
oSay45     := TSay():New( 036,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //PRODUTO
oSay44     := TSay():New( 048,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //QTDE KG
oSay43     := TSay():New( 061,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //QTDE MR
oSay51     := TSay():New( 073,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //QTDE PRODUZIDA (PESADA)

oSay41     := TSay():New( 096,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //COMPRIMENTO
oSay40     := TSay():New( 109,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //LARGURA
oSay39     := TSay():New( 122,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //ESPESSURA
oSay38     := TSay():New( 135,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //QDE. POR PACOTE
oSay37     := TSay():New( 147,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //ALTURA DO TRIÂNGULO
oSay36     := TSay():New( 160,278,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)    //VELOCIDADE

//FR - aumentar:
oBmp5      := TBitmap():New( 169,004,191,110,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )   //quadrado do meio branco - tela esquerda
oBmp6      := TBitmap():New( 169,200,191,110,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )   //quadrado do meio branco - tela direita

/**/
//FR - modificações solicitadas por Lindenberg em 19/08/09
//TELA LADO A
oSay47     := TSay():New( 171,071,{||"Próximas Programações"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008) //Frase no quadrado do meio - tela esquerda

oSay52	     := TSay():New( 184,008,{||"OPs ==>"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)    //1a. linha
oSay53       := TSay():New( 184,035,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay54       := TSay():New( 184,063,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)     //OP 1a. linha
oSay55       := TSay():New( 184,091,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay56       := TSay():New( 184,129,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay57       := TSay():New( 184,165,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)     //OP 1a. linha

oSay58       := TSay():New( 199,008,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)	    //OP 2a. linha
oSay59       := TSay():New( 199,035,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay60       := TSay():New( 199,063,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay61       := TSay():New( 199,091,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay62       := TSay():New( 199,129,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay63       := TSay():New( 199,165,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)     //OP 2a. linha

oSay64       := TSay():New( 214,008,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay65       := TSay():New( 214,035,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay66       := TSay():New( 214,063,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay67       := TSay():New( 214,091,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay68       := TSay():New( 214,129,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay69       := TSay():New( 214,165,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha 

oSay70       := TSay():New( 230,008,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay71       := TSay():New( 230,035,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay72       := TSay():New( 230,063,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay73       := TSay():New( 230,091,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay74       := TSay():New( 230,129,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay75       := TSay():New( 230,165,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha

//TELA LADO B
oSay910     := TSay():New( 171,267,{||"Próximas Programações"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008) //Frase no Quadrado do meio - tela direita

oSay199     := TSay():New( 184,204,{||"OPs ==>"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)	//1a. linha
oSay200     := TSay():New( 184,231,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay201     := TSay():New( 184,259,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay202     := TSay():New( 184,287,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay203     := TSay():New( 184,322,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha
oSay204     := TSay():New( 184,358,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 1a. linha


oSay205     := TSay():New( 199,204,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay206     := TSay():New( 199,231,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay207     := TSay():New( 199,259,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay208     := TSay():New( 199,287,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay209     := TSay():New( 199,322,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha
oSay210     := TSay():New( 199,358,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 2a. linha

oSay211     := TSay():New( 214,204,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay212     := TSay():New( 214,231,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay213     := TSay():New( 214,259,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay214     := TSay():New( 214,287,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay215     := TSay():New( 214,322,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha
oSay216     := TSay():New( 214,358,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 3a. linha

oSay217     := TSay():New( 230,204,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay218     := TSay():New( 230,231,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay219     := TSay():New( 230,259,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay220     := TSay():New( 230,287,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay221     := TSay():New( 230,322,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha
oSay222     := TSay():New( 230,358,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)		//OP 4a. linha

oSay90     := TSay():New( 259,008,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)      
oSay91     := TSay():New( 271,008,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)      
oSay92     := TSay():New( 259,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)      
oSay93     := TSay():New( 271,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)      


oPanel1    := TPanel():New( 003,004,"",oDlg1,,.F.,.F.,,,192,279,.T.,.F. )
oBmp7      := TBitmap():New( 000,000,192,279,,"",.F.,oPanel1,,,.F.,.T.,,"",.T.,,.T.,,.F. )      
oPanel1:lVisibleControl  := .F.
oSay96     := TSay():New( 016,010,{||"MÁQUINA PARADA !"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay18     := TSay():New( 070,007,{||"00:00:00"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,054)

oSay101    := TSay():New( 160,010,{||"F5  - Troca de Bobina"},    oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay102    := TSay():New( 178,010,{||"F6  - Setup"},              oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay103    := TSay():New( 196,010,{||"F7  - Troca Faca/Teflon"},  oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay104    := TSay():New( 214,010,{||"F8  - Manutenção Elétrica"},oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay105    := TSay():New( 232,010,{||"F9  - Manutenção Mecânica"},oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay106    := TSay():New( 250,010,{||"F10 - Outros problemas"},   oPanel1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)

oPanel2    := TPanel():New( 004,200,"",oDlg1,,.F.,.F.,,,192,279,.T.,.F. )
oBmp8      := TBitmap():New( 000,000,192,279,,"",.F.,oPanel2,,,.F.,.T.,,"",.T.,,.T.,,.F. )     
oPanel2:lVisibleControl  := .F.
oSay97     := TSay():New( 016,010,{||"MÁQUINA PARADA !"},oPanel2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay95     := TSay():New( 070,007,{||"00:00:00"},oPanel2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,179,054)

oSay107    := TSay():New( 160,010,{||"F5  - Troca de Bobina"},    oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay108    := TSay():New( 178,010,{||"F6  - Setup"},              oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay109    := TSay():New( 196,010,{||"F7  - Troca Faca/Teflon"},  oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay110    := TSay():New( 214,010,{||"F8  - Manutenção Elétrica"},oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay111    := TSay():New( 232,010,{||"F9  - Manutenção Mecânica"},oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)
oSay112    := TSay():New( 250,010,{||"F10 - Outros problemas"},   oPanel2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,033)

//PRIMEIRA tela - com as informações das OPs (lado esq/lado direito)
//oTimer30 := TTimer():New( 50000,{ || Mostra( cBuffer, mv_par01, mv_par02 ) }, oDlg1)       
//oTimer30:Activate()

Mostra( cBuffer, mv_par01, mv_par02 )       //FR para mostrar direto sem o timer, conforme solicitado por Lindenberg - 01/09/09

//SEGUNDA tela -  totaliza por intervalo

//SetKey(  VK_ESCAPE,  { || totaliz()   } )      //Escape ou ESC faz sair do programa, não poderei utilizar
SetKey(  VK_F3,  { || totaliz()   } ) 

LeOP(mv_par01,mv_par02)

//Timer para verificar se a máquina parou
oTimer3 := TTimer():New( 500, { || fTimer3() }, oDlg1 )
oTimer3:Activate() 

oTimer4 := TTimer():New( 500, { || fTimer4() }, oDlg1 )
oTimer4:Activate()


SetKey(  VK_F4,  { || trocaTela() } )
SetKey(  VK_F5,  { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(1),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(1), msgAlert("Função indefinida") ) ) } )
SetKey(  VK_F6,  { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(2),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(2), msgAlert("Função indefinida") ) ) } )
SetKey(  VK_F7,  { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(3),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(3), msgAlert("Função indefinida") ) ) } )
SetKey(  VK_F8,  { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(4),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(4), msgAlert("Função indefinida") ) ) } )
SetKey(  VK_F9,  { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(5),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(5), msgAlert("Função indefinida") ) ) } )
SetKey(  VK_F10, { || iif( oPanel1:lVisibleControl .and. nTela == 1, Parada1(6),;
					  iif( oPanel2:lVisibleControl .and. nTela == 2, Parada2(6), msgAlert("Função indefinida") ) ) } )
//FR
//A parada pelas teclas F11 e F12 deverá ser desativada depois que o timer de verificação de parada de máquinas 
//estiver em operação e OK.

//SetKey(  VK_F11, { || Parada1(0), nTela := 1,oBmp7:cBmpFile := "ESTMAQS_VERDE.bmp", oBmp8:cBmpFile := "ESTMAQS_BRANCO.bmp" } )
//SetKey(  VK_F12, { || Parada2(0), nTela := 2,oBmp8:cBmpFile := "ESTMAQS_VERDE.bmp", oBmp7:cBmpFile := "ESTMAQS_BRANCO.bmp" } )


oSBtn2     := SButton():New( 950,950,2,,oDlg1,,"", )
oDlg1:Activate(,,,.T.)  




DbcloseArea("PRD")

//Ao sair da tela de controle das máquinas, o sistema irá gravar a data e hora de saída
//servirá como um apontamento de tempo trabalhado pela máquina.
fGrvFim(mv_par01,mv_par02,cMaqzero,cMaqUm)

Return


*******************
static function fTimer3()   
*******************
if fVerLiga(0) = 0
   Parada1(0,.T.)
/*
   if nTela != 1
      nTela := 1
      oBmp7:cBmpFile := "ESTMAQS_VERDE.bmp"
      oBmp8:cBmpFile := "ESTMAQS_BRANCO.bmp"
   endif   
*/   
endif

return



*******************
static function fTimer4()   
*******************
if fVerLiga(1) = 0
   Parada2(0,.T.)
/*
   if nTela != 2
      nTela := 2
      oBmp8:cBmpFile := "ESTMAQS_VERDE.bmp"
      oBmp7:cBmpFile := "ESTMAQS_BRANCO.bmp"
   endif
*/   
endif   
   
return


*******************************
Static Function LeOP(cOP,cOP2)
*******************************

Local cTurnoAtu := ""
Local nTotsKGa  := 0	 // total KG
Local nTotPesa  := 0     // total pesado

Local nTotsKGb  := 0     // total KG
Local nTotPesb  := 0     // total pesado

Local cQuery := cQuery2 := cQrya := cQryb := cQryc := cQryd := ""
Local dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", dDataBase - 1, dDataBase )

cTurnoAtu := GetTurno()          //FR: Obtém o turno atual que será usado para mostrar os apontamentos


//Estas queries fazem a leitura da OP digitada no parâmetro e informam os dados da OP
//apresentados na Tela 1 (lado A / lado B)
//Lado A                                                                                                                                                               
cQuery += "select SC2.C2_NUM, SB1.B1_COD, SC2.C2_QUANT, SC2.C2_QUJE, SB5.B5_COMPR, SB5.B5_LARG, SB5.B5_ESPESS, SB5.B5_QTDEMB "
cQuery += " ,SB5.B5_BATPM "
cQuery += " ,SB1.B1_TRIANGU, SB5.B5_PRDHORA "       
cQuery += " from "+retSqlName('SB1')+" SB1, "+retSqlName('SC2')+" SC2, "+retSqlName('SB5')+" SB5 "
cQuery += " where C2_NUM = '"+cOP+"' "
cQuery += " and SB1.B1_TIPO = 'PA'  and SB1.B1_COD = SC2.C2_PRODUTO and SC2.C2_PRODUTO = SB5.B5_COD "
cQuery += " and SB1.D_E_L_E_T_ != '*'  and SC2.D_E_L_E_T_ != '*'  and SB5.D_E_L_E_T_ != '*' "
cQuery += " and SB1.B1_FILIAL = '"+xFilial('SB1')+"' and SC2.C2_FILIAL = '"+xFilial('SC2')+"' and SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery += " order by SB1.B1_DESC desc " 
//Memowrite("LEOP1.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "_TMPZ"
_TMPZ->( dbGoTop() )

//Lado B                                                                                                                                                                
cQuery2 += "select SC2.C2_NUM, SB1.B1_COD, SC2.C2_QUANT, SC2.C2_QUJE, SB5.B5_COMPR, SB5.B5_LARG, SB5.B5_ESPESS, SB5.B5_QTDEMB "
cQuery2 += " ,SB5.B5_BATPM "
cQuery2 += " ,SB1.B1_TRIANGU, SB5.B5_PRDHORA "  
cQuery2 += " from "+retSqlName('SB1')+" SB1, "+retSqlName('SC2')+" SC2, "+retSqlName('SB5')+" SB5 "
cQuery2 += " where C2_NUM = '"+cOP2+"' "
cQuery2 += " and SB1.B1_TIPO = 'PA'  and SB1.B1_COD = SC2.C2_PRODUTO and SC2.C2_PRODUTO = SB5.B5_COD "
cQuery2 += " and SB1.D_E_L_E_T_ != '*'  and SC2.D_E_L_E_T_ != '*'  and SB5.D_E_L_E_T_ != '*' "
cQuery2 += " and SB1.B1_FILIAL = '"+xFilial('SB1')+"' and SC2.C2_FILIAL = '"+xFilial('SC2')+"' and SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery2 += " order by SB1.B1_DESC desc "
TCQUERY cQuery2 NEW ALIAS "_TMPY"
_TMPY->( dbGoTop() )
nPrdHA := ( _TMPZ->B5_PRDHORA * 2 )
nPrdHB := ( _TMPY->B5_PRDHORA * 2 )

//FR - TOTX1
//Na primeira tela, é o total por OP
//Query para capturar o total pesado para colocar na primeira tela conforme solicitação de Lindenberg em 25/08/09
cQrya := " SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT "
cQrya += " ,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF " 
cQrya += " FROM " + RetSqlName( "Z00" ) + " Z00 " + CHR(13)
cQrya += " WHERE "
If cTurnoAtu = "1"
	cQrya += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "05:35'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND "
Elseif cTurnoAtu = "2" 
	cQrya += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "13:56'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND "
Elseif cTurnoAtu = "3"
	cQrya += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "22:01'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND "
Endif
cQrya += " Z00.Z00_MAQ IN  ('" + substr(cBuffer,1,3) + "')   " + CHR(13) + CHR(10)
//cQrya += " AND ( LEFT(Z00.Z00_OP,6) = '" + mv_par01 + "' " + " OR LEFT(Z00.Z00_OP,6) = '" + mv_par02 + "' ) " 
cQrya += " AND LEFT(Z00.Z00_OP,6) = '" + mv_par01 + "' " 
cQrya += " AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQrya += " ORDER BY Z00.Z00_MAQ,Z00.Z00_HORA "
cQrya := ChangeQuery( cQrya ) 
//MemoWrite("TOTX1.sql", cQrya)

If Select("TOTX1") > 0
	DbSelectArea("TOTX1")
	DbCloseArea()
EndIf

TCQUERY cQrya NEW ALIAS "TOTX1"

TCSetField( 'TOTX1', "Z00_DATA", "D" )

nTotsKGa := 0
nTotPesa := 0     // total pesado

TOTX1->( DbGoTop() )
While !TOTX1->(EOF())

	SC2->( DbSeek( xFilial( "SC2" ) + TOTX1->Z00_OP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )

	
	nTotsKGa     += TOTX1->Z00_PESO + TOTX1->Z00_PESCAP
	nTotPesa     += TOTX1->Z00_QUANT / SB5->B5_QE2

	TOTX1->(DBSkip())
Enddo	


TOTX1->( DbCloseArea() )


//FR - TOTX2
//Na primeira tela, é o total por OP
//Query para capturar o total pesado para colocar na primeira tela conforme solicitação de Lindenberg em 25/08/09
cQryb := " SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF " + CHR(13) + CHR(10)
cQryb += " FROM " + RetSqlName( "Z00" ) + " Z00 " + CHR(13)
cQryb += " WHERE "
If cTurnoAtu = "1"
	cQryb += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "05:35'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND " + CHR(13) + CHR(10)
Elseif cTurnoAtu = "2" 
	cQryb += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "13:56'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND " + CHR(13) + CHR(10)
Elseif cTurnoAtu = "3"
	cQryb += " Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "22:01'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' AND " + CHR(13) + CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTMAQS3  ºAutor  ³Microsiga           º Data ³  07/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Endif
cQryb += " Z00.Z00_MAQ IN  ('" + substr(cBuffer,1,3) + "')   " + CHR(13) + CHR(10)
//cQryb += " AND ( LEFT(Z00.Z00_OP,6) = '" + mv_par01 + "' " + " OR LEFT(Z00.Z00_OP,6) = '" + mv_par02 + "' ) " 
cQryb += " AND LEFT(Z00.Z00_OP,6) = '" + mv_par02 + "' " 
cQryb += " AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQryb += " ORDER BY Z00.Z00_MAQ,Z00.Z00_HORA "
cQryb := ChangeQuery( cQryb ) 
//MemoWrite("TOTX2.sql", cQryb)

If Select("TOTX2") > 0
	DbSelectArea("TOTX2")
	DbCloseArea()
EndIf

TCQUERY cQryb NEW ALIAS "TOTX2"
TCSetField( 'TOTX2', "Z00_DATA", "D" )


nTotsKGb := 0
nTotPesb:= 0     // total pesado

TOTX2->( DbGoTop() )

While !TOTX2->(EOF())

	SC2->( DbSeek( xFilial( "SC2" ) + TOTX2->Z00_OP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )

	
	nTotsKGb     += TOTX2->Z00_PESO + TOTX2->Z00_PESCAP
	nTotPesb     += TOTX2->Z00_QUANT / SB5->B5_QE2

	TOTX2->(DBSkip())
Enddo	

TOTX2->( DbCloseArea() )


//FR
oSay14:cCaption := transform(_TMPZ->C2_NUM, "@E 999999")
oSay15:cCaption := alltrim(_TMPZ->B1_COD)
oSay16:cCaption := transform(_TMPZ->C2_QUANT, "@E 999,999.99")
oSay17:cCaption := transform(_TMPZ->C2_QUJE,  "@E 999,999.99")
oSay19:cCaption := transform(_TMPZ->B5_COMPR, "@E 999.99"    )
oSay20:cCaption := transform(_TMPZ->B5_LARG,  "@E 999.99"    )
oSay21:cCaption := transform(_TMPZ->B5_ESPESS,"@E 999.9999"  )//espessura
oSay22:cCaption := transform(_TMPZ->B5_QTDEMB,"@E 999"       )//qtd pacote
oSay23:cCaption := transform(_TMPZ->B1_TRIANGU,"@E 999,999.9999")
oSay24:cCaption := transform(_TMPZ->B5_BATPM,"@E 999"        ) + " BPM"

oSay49:cCaption := transform( nTotPesa, "@E 999,999.99") 	//QTDE PRODUZIDA

oSay46:cCaption := transform(_TMPY->C2_NUM, "@E 999999")
oSay45:cCaption := alltrim(_TMPY->B1_COD)
oSay44:cCaption := transform(_TMPY->C2_QUANT, "@E 999,999.99")
oSay43:cCaption := transform(_TMPY->C2_QUJE,  "@E 999,999.99")
oSay41:cCaption := transform(_TMPY->B5_COMPR, "@E 999.99"    )
oSay40:cCaption := transform(_TMPY->B5_LARG,  "@E 999.99"    )
oSay39:cCaption := transform(_TMPY->B5_ESPESS,"@E 999.9999"  )
oSay38:cCaption := transform(_TMPY->B5_QTDEMB,"@E 999"       )
oSay37:cCaption := transform(_TMPY->B1_TRIANGU,"@E 999,999.9999")
oSay36:cCaption := transform(_TMPY->B5_BATPM,"@E 999"        )+ " BPM" 

oSay51:cCaption := transform( nTotPesb, "@E 999,999.99") 	//QTDE PRODUZIDA

_TMPY->( dbCloseArea() );_TMPZ->( dbCloseArea() )


//FR - Query para capturar as próximas OPs programadas para a máquina em operação, 
//exceto a OP que já está na tela - lado esq.
cQryc := " SELECT TOP 23 Z00_OP,C2_NUM,C2_ITEM,C2_SEQUEN "
cQryc += " FROM " + RetSqlName( "Z00" ) + " Z00 " + ", " + RetSqlName( "SC2" )  + " SC2 "
cQryc += " WHERE  "
cQryc += " Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "'        "
cQryc += " AND Z00.Z00_MAQ = '" + substr(cBuffer,1,3) + "'    " 
cQryc += " AND Z00.Z00_OP = (C2_NUM + C2_ITEM + C2_SEQUEN)    " 
cQryc += " AND  ( C2_NUM > '" + mv_par01 + "' AND C2_NUM <> '" + mv_par02 + "' ) "
cQryc += " AND C2_DATRF = ' ' "
cQryc += " AND C2_QUJE < C2_QUANT "
cQryc += " AND Z00.D_E_L_E_T_ <>'*' AND SC2.D_E_L_E_T_<>'*'   "
cQryc += " GROUP BY Z00_OP,C2_NUM,C2_ITEM,C2_SEQUEN           "
cQryc += " ORDER BY Z00.Z00_OP                                "
//cQryc += " ORDER BY Z00.Z00_FILIAL, Z00.Z00_OP, Z00.Z00_DATA, Z00.Z00_HORA "
cQryc := ChangeQuery( cQryc ) 
//MemoWrite("PROGOP1.sql", cQryc)

If Select("PROGOP1") > 0
	DbSelectArea("PROGOP1")
	DbCloseArea()
EndIf

TCQUERY cQryc NEW ALIAS "PROGOP1"
TCSetField( 'PROGOP1', "Z00_DATA", "D" ) 

PROGOP1->( DbGoTop() )
	

f := 53
coSay1 := ""
coSay2 := ""
coSay3 := ""
PROGOP1->( DbGoTop() )
While !PROGOP1->(EOF()) //.or. nRegs > 0
	
	coSay1 := "oSay"
	coSay2 := Transform( f, "@X")
	coSay3 := coSay1 + coSay2
	
	&(coSay3):cCaption := Substr(PROGOP1->Z00_OP,1,6)
	f++

	PROGOP1->( DbSkip() )
Enddo  


//FR - Query para capturar as próximas OPs programadas para a máquina em operação,
// exceto a OP que já está na tela - lado direito
cQryd := " SELECT TOP 23 Z00_OP,C2_NUM,C2_ITEM,C2_SEQUEN "
cQryd += " FROM " + RetSqlName( "Z00" ) + " Z00 " + ", " + RetSqlName( "SC2" )  + " SC2 "
cQryd += " WHERE  "
cQryd += " Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "'        "
cQryd += " AND Z00.Z00_MAQ = '" + substr(cBuffer,1,3) + "'    " 
cQryd += " AND Z00.Z00_OP = (C2_NUM + C2_ITEM + C2_SEQUEN)    " 
cQryd += " AND  ( C2_NUM > '" + mv_par02 + "' AND C2_NUM <> '" + mv_par01 + "' ) "
cQryd += " AND C2_DATRF = ' ' "
cQryd += " AND C2_QUJE < C2_QUANT "
cQryd += " AND Z00.D_E_L_E_T_ <>'*' AND SC2.D_E_L_E_T_<>'*'   "
cQryd += " GROUP BY Z00_OP,C2_NUM,C2_ITEM,C2_SEQUEN           "
cQryd += " ORDER BY Z00.Z00_OP                                "
cQryd := ChangeQuery( cQryd ) 
//MemoWrite("PROGOP2.sql", cQryd)

If Select("PROGOP2") > 0
	DbSelectArea("PROGOP2")
	DbCloseArea()
EndIf

TCQUERY cQryd NEW ALIAS "PROGOP2"
TCSetField( 'PROGOP2', "Z00_DATA", "D" ) 


fx := 200
coSay1x := ""
coSay2x := ""
coSay3x := ""

PROGOP2->( DbGoTop() )
While !PROGOP2->(EOF()) 
	
	coSay1x := "oSay"
	coSay2x := Transform( fx, "@X")
	coSay3x := coSay1x + coSay2x
	
	&(coSay3x):cCaption := Substr(PROGOP2->Z00_OP,1,6)
	fx++
	
	PROGOP2->(DBSKIP())

Enddo
//Fim das Queries para capturar próximas programações


Return 

*********************************
Static Function LeOP2(cOP,cOP2)
*********************************

Local cQuery := cQuery2 := ""
Local nOrd   := 1
Local dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", dDataBase - 1, dDataBase )
cQuery := "SELECT top 3 Z00_PESO AS PESO, Z00_HORA, Z00_DATA, Z00_NOME, Z00_OP "
cQuery += "FROM "+retSqlName('Z00')+" Z00 "
//cQuery += "WHERE Z00_APARA = '' AND Z00_MAQ in ('C01','C02','C03','C04','C05','C06','C07','P01','P02','P03','P04','P05','S01') "
cQuery += "WHERE Z00_APARA = '' AND  Z00_MAQ  like '[CPS][0123456789]%' "
cQuery += "AND substring(Z00_OP,1,6) = '"+cOP+"' AND "
cQuery += "Z00.Z00_FILIAL  = '"+xFilial('Z00')+"' AND Z00.D_E_L_E_T_ != '*' "
cQuery += "order by Z00_DATA desc, Z00_HORA desc "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
TCSetField( '_TMPK', "Z00_DATA", "D")

cQuery2:= "SELECT top 3 Z00_PESO AS PESO, Z00_HORA, Z00_DATA, Z00_NOME, Z00_OP "
cQuery2+= "FROM "+retSqlName('Z00')+" Z00 "
//cQuery2+= "WHERE Z00_APARA = '' AND Z00_MAQ in ('C01','C02','C03','C04','C05','C06','C07','P01','P02','P03','P04','P05','S01') "
cQuery2 += "WHERE Z00_APARA = '' AND  Z00_MAQ  like '[CPS][0123456789]%' "
cQuery2+= "AND substring(Z00_OP,1,6) = '"+cOP2+"' AND "
cQuery2+= "Z00.Z00_FILIAL  = '"+xFilial('Z00')+"' AND Z00.D_E_L_E_T_ != '*'  "
cQuery2+= "order by Z00_DATA desc, Z00_HORA desc "
TCQUERY cQuery2 NEW ALIAS "_TMPF"
_TMPF->( dbGoTop() )
TCSetField( '_TMPF', "Z00_DATA", "D")

do While !_TMPK->( EoF() )
	if nOrd == 1	
		oSay53:cCaption := dtoc( _TMPK->Z00_DATA )
		If _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )			
			oSay54:cCaption := "1º Turno"
	 	ElseIf _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay54:cCaption := "2º Turno"
	 	ElseIf ( _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPK->Z00_DATA == dDIA + 1 .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay54:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoA := substr(oSay54:cCaption,1,1)
		oSay55:cCaption := "9999"//apara
		oSay56:cCaption := transform(_TMPK->PESO,"999,999.99")
		oSay57:cCaption := alltrim(_TMPK->Z00_NOME)
	elseIf nOrd == 2
		oSay58:cCaption := dtoc( _TMPK->Z00_DATA )
		If _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			oSay59:cCaption := "1º Turno"
	 	ElseIf _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay59:cCaption := "2º Turno"
	 	ElseIf ( _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPK->Z00_DATA == dDIA + 1 .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay59:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoA := substr(oSay59:cCaption,1,1)
		oSay60:cCaption := "9999"//apara
		oSay61:cCaption := transform(_TMPK->PESO,"999,999.99")
		oSay62:cCaption := alltrim(_TMPK->Z00_NOME)
	else 
		oSay63:cCaption := dtoc( _TMPK->Z00_DATA )
		If _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			oSay64:cCaption := "1º Turno"
	 	ElseIf _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay64:cCaption := "2º Turno"
	 	ElseIf ( _TMPK->Z00_DATA == dDIA .and. _TMPK->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPK->Z00_DATA == dDIA + 1 .and. _TMPK->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay64:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoA := substr(oSay64:cCaption,1,1)
		oSay65:cCaption := "9999"//apara
		oSay66:cCaption := transform(_TMPK->PESO,"999,999.99")
		oSay67:cCaption := alltrim(_TMPK->Z00_NOME)		
	endIf
	_TMPK->( dbSkip() )
	nOrd++
endDo
nOrd := 1
do While !_TMPF->( EoF() )
	if nOrd == 1	
		oSay70:cCaption := dtoc( _TMPF->Z00_DATA )
		If _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			oSay75:cCaption := "1º Turno"
	 	ElseIf _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay75:cCaption := "2º Turno"
	 	ElseIf ( _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPF->Z00_DATA == dDIA + 1 .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay75:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoB := substr(oSay75:cCaption,1,1)
		oSay78:cCaption := "9999"//apara
		oSay83:cCaption := transform(_TMPF->PESO,"999,999.99")
		oSay86:cCaption := alltrim(_TMPF->Z00_NOME)
	elseIf nOrd == 2
		oSay71:cCaption := dtoc( _TMPF->Z00_DATA )
		If _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			oSay74:cCaption := "1º Turno"
	 	ElseIf _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay74:cCaption := "2º Turno"
	 	ElseIf ( _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPF->Z00_DATA == dDIA + 1 .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay74:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoB := substr(oSay74:cCaption,1,1)
		oSay79:cCaption := "9999"//apara
		oSay82:cCaption := transform(_TMPF->PESO,"999,999.99")
		oSay87:cCaption := alltrim(_TMPF->Z00_NOME)
	else 
		oSay72:cCaption := dtoc( _TMPF->Z00_DATA )
		If _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO1, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			oSay73:cCaption := "1º Turno"
	 	ElseIf _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO2, 5 ) .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			oSay73:cCaption := "2º Turno"
	 	ElseIf ( _TMPF->Z00_DATA == dDIA .and. _TMPF->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( _TMPF->Z00_DATA == dDIA + 1 .and. _TMPF->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			oSay73:cCaption := "3º Turno"
	 	EndIf		
	 	cTurnoB := substr(oSay73:cCaption,1,1)
		oSay80:cCaption := "9999"//apara
		oSay81:cCaption := transform(_TMPF->PESO,"999,999.99")
		oSay88:cCaption := alltrim(_TMPF->Z00_NOME)
	endIf
	_TMPF->( dbSkip() )
	nOrd++
endDo

_TMPK->( dbCloseArea() );_TMPF->( dbCloseArea() )

return

*****************************************
Static Function Parada1( nParada, lAuto )
*****************************************
Local dData1 := dDataBase
Local cHora1 := time()

if !oPanel1:lVisibleControl
	oPanel1:lVisibleControl  := .T.
	if !salvaStop( dData1, cHora1, substr(cBuffer,1,3), "A ", lAuto )
		dData1 := Z39->Z39_DATA
		cHora1 := Z39->Z39_HORA
	endIf	
	oTimer1 := TTimer():New( 1000,{ || oSay18:cCaption := Tempo( dData1, cHora1, dDataBase, time() ) }, oDlg1)
	oTimer1:Activate()
else
	if !fechaStop( substr(cBuffer,1,3), oTimer1, nParada, "A ", lAuto )
		return
	endIf
	if oTimer1 != nil
	   oTimer1:Deactivate()
	   oTimer1 := oCbox1 := oMget1  := Nil
	   cStop1 := cJust1 := ""
	   oSay18:cCaption  := "00:00:00"
	   oPanel1:lVisibleControl  := .F.
	endif   
endIf

Return

*****************************************
Static Function Parada2( nParada, lAuto )
*****************************************

Local dData2 := dDataBase
Local cHora2 := time()

if !oPanel2:lVisibleControl
	oPanel2:lVisibleControl  := .T.
	if !salvaStop( dData2, time(), substr(cBuffer,4,3), "B ", lAuto )
		dData2 := Z39->Z39_DATA
		cHora2 := Z39->Z39_HORA
	endIf
	oTimer2 := TTimer():New( 1000,{ || oSay95:cCaption := Tempo( dData2, cHora2, dDataBase, time() ) }, oDlg1)
	oTimer2:Activate()
else
	if !fechaStop( substr(cBuffer,4,3), oTimer2, nParada, "B ", lAuto )
		return
	endIf
	if oTimer2 != nil
	   oTimer2:Deactivate()
   	   oTimer2 := oCbox2 := oMget2  := Nil
	   cStop2  := cJust2 := ""        
	   oSay95:cCaption  := "00:00:00"
	   oPanel2:lVisibleControl  := .F.
	endif   
endIf

Return

*******************************************************
Static Function salvaStop( dData, cHora, cMaq, cLado, lAuto )
*******************************************************
Default lAuto := .F.

	Z39->( dbSetOrder(5) )
	if Z39->( dbSeek( xFilial("Z39") + cMaq + cLado + substr(cUsuario, 7, 14 ) + space(8),.F. ) )
  	    if ! lAuto
		   msgAlert("Parada não fechada!")
		endif   
		return .F.
	endIf
	RecLock( "Z39", .T. )
	Z39->Z39_FILIAL := xFilial("Z39")
	Z39->Z39_CODMAQ := cMaq
	Z39->Z39_MAQ    := cLado
	Z39->Z39_USUARI := substr(cUsuario, 7, 14 )
	Z39->Z39_DATA   := dData
	Z39->Z39_HORA   := cHora
	Z39->( msUnlock() )
return .T.

**********************************************************
Static Function fechaStop( cMaq, oTimer, nParada, cLado, lAuto )
**********************************************************
Default lAuto := .F.

	Private cTexto := ""	
	if nParada <= 0
		if ! lAuto
		   msgAlert("Por favor, escolha um motivo para essa parada de máquina!")
		endif
		return .F.
	endIf
	if nParada == 6 .and. !justifica()
		return .F.
	endIf                                       //MÁQUINA  + LADO (A/B)
	Z39->( dbSetOrder(5) )       //Z39_FILIAL + Z39_CODMAQ + Z39_MAQ  + Z39_USUARI
	if !Z39->( dbSeek( xFilial("Z39") + cMaq + cLado + substr(cUsuario, 7, 14 ) + space(8),.F. ) )
		if ! lAuto
   		   msgAlert("Erro no fechamento! Esta parada já foi encerrada anteriormente.")
   		endif   
		return .F.
	endIf
	RecLock( "Z39", .F. )
	Z39->Z39_HORAF := time()
	Z39->Z39_DATAF := dDataBase
	Z39->Z39_TIPO  := alltrim(str(nParada))
	MSMM(,,,cTexto,1,,,'Z39','Z39_MEMO1')
	Z39->( msUnlock() )
	if nTela == 1
		if oPanel2:lVisibleControl
			nTela := 2
			oBmp8:cBmpFile := "ESTMAQS_VERDE.bmp"
			oBmp7:cBmpFile := "ESTMAQS_BRANCO.bmp"
		else
			nTela := 0
		endIf
	elseIf nTela == 2
		if oPanel1:lVisibleControl
			nTela := 1
			oBmp7:cBmpFile := "ESTMAQS_VERDE.bmp"
			oBmp8:cBmpFile := "ESTMAQS_BRANCO.bmp"
		else
			nTela := 0
		endIf
	endIf
Return .T.

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Tempo( dFecha1, cHora1, dFecha2, cHora2 )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static function Tempo( dFecha1, cHora1, dFecha2, cHora2 )

Local nDias, nHorasp, nMinutp, nSegunp, nHorasa, nMinuta, nSeguna, nHoras, nMinuto, nSegundo

// Controle de parametros opcionais
if cHora1 = nil .OR. empty( cHora1 )
	//cHora1 := "00:00"
	cHora1 := "00:00:00"
endif

if dFecha2 = NIL .OR. EMPTY( dFecha2 )
	dFecha2 := DATE()
endif

if cHora2 = NIL .OR. EMPTY( cHora2 )
	//cHora2 := SUBSTR( TIME(),1,5 )
	cHora2 := TIME()
endif

//Controle de tipo de parametros
if VALTYPE( dFecha1 ) != 'D' .OR. VALTYPE( dFecha2 ) != 'D' .OR.;
   VALTYPE( cHora1 )  != 'C' .OR. VALTYPE( cHora2 )  != 'C' .OR.;
	EMPTY( dFecha1 )
	RETURN 0
endif

//Diferenca de dias
nDias := dFecha2 - dFecha1

//separo horas e minutos
nHorasp := VAL( SUBSTR( cHora2,1,2 ) )
nMinutp := VAL( SUBSTR( cHora2,4,2 ) )
nSegunp := VAL( SUBSTR( cHora2,7,2 ) )

nHorasa := VAL( SUBSTR( cHora1,1,2 ) )
nMinuta := VAL( SUBSTR( cHora1,4,2 ) )
nSeguna := VAL( SUBSTR( cHora1,7,2 ) )

//Diferenca de Horas
nHoras := nHorasp - nHorasa

//Horas menor que 0
if nHoras < 0
	--nDias
	nHoras += 24
endif

//Diferenca de Minutos
nMinuto := nMinutp - nMinuta

//Minutos menor que 0
if nMinuto < 0
	--nHoras
	nMinuto += 60
endif

//Diferenca de Segundos
nSegundo := nSegunp - nSeguna

//Segundos menor que 0
if nSegundo < 0
	--nMinuto
	nSegundo += 60
endif

Return StrZero(nHoras+(nDias * 24), 2)+":"+StrZero(nMinuto, 2)+":"+StrZero(nSegundo, 2)



*****************************************
Static Function Mostra( cMAQ, cOP, cOP2 )
*****************************************

Local cQuery    := ""
Local nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
Local nTURNO1MR := nTURNO2MR := nTURNO3MR := 0
Local nTURNO1   := nTURNO2   := nTURNO3   := 0
Local nPRODDKG  := nPRODDMR  := nPRODDKG2 := nPRODDMR2 := 0
Local dData1    := dData2    := dData3    := stod(space(8))
Local dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", dDataBase - 1, dDataBase )
Local nOrd := 1
Local aAparas := {}
Local nTurno := 0
DbSelectArea("SB1")
DbSelectArea("SC2")
DbSelectArea("SB5")
SB1->( DbSetOrder( 1 ) )
SC2->( DbSetOrder( 1 ) )

cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
CQUERY += " ,Z00.Z00_NOME "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( dDataBase ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + substr(cMAQ,1,3) + "' AND Z00.Z00_APARA = ' ' AND "
cQUERY += "substring(Z00_OP,1,6) = '"+ cOP +"' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQUERY NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )

Z00X->( DbGotop() )
aAparas := apara( cOP, substr(cMAQ,1,3) )
Do While ! Z00X->( Eof() )
	SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	If Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		nTURNO1KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nTURNO1MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
		dData1 := Z00X->Z00_DATA
		nTurno := 1
	ElseIf Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		nTURNO2KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nTURNO2MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
		dData2 := Z00X->Z00_DATA
		nTurno := 2
	ElseIf ( Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		   ( Z00X->Z00_DATA == dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		nTURNO3KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nTURNO3MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
		dData3 := Z00X->Z00_DATA
		nTurno := 3		
	EndIf
	Z00X->( DbSkip() )
EndDo
Z00X->( DbCloseArea() )			
Do While nOrd <= 3
	if nOrd == 1
		//oSay53:cCaption := dtoc( dData1 )
		//oSay54:cCaption := "1º Turno"
		//oSay55:cCaption := transform(aAparas[1],"@E 999,999.99")
		//oSay55:cCaption := transform( if( nTURNO1KG > 0, (aAparas[1]/nTURNO1KG) * 100, 0 ),"@E 999.99")
		//oSay56:cCaption := transform(nTURNO1MR,"@E 999,999.99")
		//oSay57:cCaption := transform(nPrdHA,"@E 999.99")
		//oSay570:cCaption:= transform(nTURNO1KG / if(nTurno == 1,prdAtual("1"), 7.20),"@E 999,999.99")
	elseIf nOrd == 2
		//oSay58:cCaption := dtoc( dData2 )
		//oSay59:cCaption := "2º Turno"
		//oSay60:cCaption := transform(aAparas[2],"@E 999,999.99")
		//oSay60:cCaption := transform( if( nTURNO2KG > 0, (aAparas[2]/nTURNO2KG) * 100, 0 ),"@E 999.99")
		//oSay61:cCaption := transform(nTURNO2MR,"@E 999,999.99")
		//oSay62:cCaption := transform(nPrdHA,"@E 999.99")
		//oSay620:cCaption:= transform(nTURNO2KG / if(nTurno == 2,prdAtual("2"), 7.20),"@E 999,999.99")
	else
		//oSay63:cCaption := dtoc( dData3 )
		//oSay64:cCaption := "3º Turno"
		//oSay65:cCaption := transform(aAparas[3],"@E 999,999.99")
		//oSay65:cCaption := transform( if( nTURNO3KG > 0, (aAparas[3]/nTURNO3KG) * 100, 0 ),"@E 999.99")
		//oSay66:cCaption := transform(nTURNO3MR,"@E 999,999.99")
		//oSay67:cCaption := transform(nPrdHA,"@E 999.99")
    	//oSay670:cCaption:= transform(nTURNO3KG / if(nTurno == 3,prdAtual("3"), 6.30),"@E 999,999.99")
	endIf
	nOrd++
endDo
nOrd := 1
nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
nTURNO1MR := nTURNO2MR := nTURNO3MR := 0
dData1    := dData2    := dData3    := stod(space(8))

cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP "
CQUERY += " ,Z00.Z00_PESDIF,Z00.Z00_NOME "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( dDataBase ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + substr(cMAQ,4,3) + "' AND Z00.Z00_APARA = ' ' AND "
cQUERY += "substring(Z00_OP,1,6) = '"+cOP2+"' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQUERY NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )

Z00X->( DbGotop() )
aAparas := apara( cOP2, substr(cMAQ,4,3) )
Do While ! Z00X->( Eof() )
	SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	If Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		nTURNO1KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     	nTURNO1MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nPRODDMR2 += Z00X->Z00_QUANT / SB5->B5_QE2
		dData1 := Z00X->Z00_DATA
	ElseIf Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		nTURNO2KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     	nTURNO2MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
		nPRODDMR2 += Z00X->Z00_QUANT / SB5->B5_QE2
		dData2 := Z00X->Z00_DATA		
	ElseIf ( Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		   ( Z00X->Z00_DATA == dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		nTURNO3KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     	nTURNO3MR += Z00X->Z00_QUANT / SB5->B5_QE2
		nPRODDKG2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     	nPRODDMR2 += Z00X->Z00_QUANT / SB5->B5_QE2
		dData3 := Z00X->Z00_DATA
	EndIf
	Z00X->( DbSkip() )
EndDo
Z00X->( DbCloseArea() )

do While nOrd <= 3
	if nOrd == 1	
		//oSay70:cCaption := dtoc( dData1 )
		//oSay75:cCaption := "1º Turno"
		//oSay78:cCaption := transform(aAparas[1],"@E 999,999.99")
		//oSay78:cCaption := transform( if(nTURNO1KG > 0,  (aAparas[1]/nTURNO1KG) * 100, 0 ),"@E 999.99")
		//oSay83:cCaption := transform(nTURNO1MR,"@E 999,999.99")
		//oSay86:cCaption := transform(nPrdHB,"@E 999.99")
    	//oSay860:cCaption:= transform(nTURNO1KG / if(nTurno == 1,prdAtual("1"), 7.20),"@E 999,999.99")
	elseIf nOrd == 2
		//oSay71:cCaption := dtoc( dData2 )
		//oSay74:cCaption := "2º Turno"
		//oSay79:cCaption := transform(aAparas[2],"@E 999,999.99")
		//oSay79:cCaption := transform( if( nTURNO2KG > 0, (aAparas[2]/nTURNO2KG) * 100, 0 ),"@E 999.99")
		//oSay82:cCaption := transform(nTURNO2MR,"@E 999,999.99")
		//oSay87:cCaption := transform(nPrdHB,"@E 999.99")
    	//oSay870:cCaption:= transform(nTURNO2KG / if(nTurno == 2,prdAtual("2"), 7.20),"@E 999,999.99")
	else
		//oSay72:cCaption := dtoc( dData3 )
		//oSay73:cCaption := "3º Turno"
		//oSay80:cCaption := transform(aAparas[3],"@E 999,999.99")
		//oSay80:cCaption := transform( if( nTURNO3KG > 0, (aAparas[3]/nTURNO3KG) * 100, 0 ),"@E 999.99")
		//oSay81:cCaption := transform(nTURNO3MR,"@E 999,999.99")
		//oSay88:cCaption := transform(nPrdHB,"@E 999.99")
    	//oSay880:cCaption:= transform(nTURNO3KG / if(nTurno == 3,prdAtual("3"), 6.30),"@E 999,999.99")
	endIf
	nOrd++
endDo

Return NIL



****************************************
Static Function apara( cOP, cMAQ, nOpt )
****************************************

Local cQuery :=""
Local nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
Local dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", dDataBase - 1, dDataBase )

cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF, Z00.Z00_NOME "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( dDataBase ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + cMAQ + "' AND Z00.Z00_APARA != ' ' AND "
cQUERY += "substring(Z00_OP,1,6) = '"+cOP+"' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )

If Select("Z00Z") > 0
	DbSelectArea("Z00Z")
	DbCloseArea()
EndIf

TCQUERY cQUERY NEW ALIAS "Z00Z"
TCSetField( 'Z00Z', "Z00_DATA", "D" )
Z00Z->( DbGotop() )

Do While ! Z00Z->( Eof() )
	SC2->( DbSeek( xFilial( "SC2" ) + Z00Z->Z00_OP, .T. ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	If Z00Z->Z00_DATA == dDIA .and. Z00Z->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00Z->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		nTURNO1KG += Z00Z->Z00_PESO + Z00Z->Z00_PESCAP
	ElseIf Z00Z->Z00_DATA == dDIA .and. Z00Z->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00Z->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		nTURNO2KG += Z00Z->Z00_PESO + Z00Z->Z00_PESCAP
	ElseIf ( Z00Z->Z00_DATA == dDIA .and. Z00Z->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		   ( Z00Z->Z00_DATA == dDIA + 1 .and. Z00Z->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		nTURNO3KG += Z00Z->Z00_PESO + Z00Z->Z00_PESCAP
	EndIf
	Z00Z->( DbSkip() )
EndDo

Z00Z->( DbCloseArea() )

Return { nTURNO1KG, nTURNO2KG, nTURNO3KG }



***************************
Static Function justifica()
***************************

Local lRet := .F.
Private cText     
SetPrvt("oDlg_11","oGrp_11","oGrp_12","oBtn_11","oBtn_12","oMGet_11")

oDlg_11 := MSDialog():New( 234,495,544,873,"Justificativa",,,.F.,,,,,,.T.,,,.F. )
oGrp_11 := TGroup():New( 000,004,131,184,"",oDlg_11,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp_12 := TGroup():New( 131,004,150,184,"",oDlg_11,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn_11 := TButton():New( 138,053,"&OK",oGrp_12,,037,008,,,,.T.,,"",,,,.F. )
oBtn_11:bAction := { || oDlg_11:End(), cTexto := cText, lRet := .T. }
oBtn_12 := TButton():New( 138,097,"&Cancelar",oGrp_12,,037,008,,,,.T.,,"",,,,.F. )
oBtn_12:bAction := { || oDlg_11:End(), lRet := .F. }
oMGet_11 := TMultiGet():New( 007,007,,oGrp_11,172,120,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet_11:bSetGet := {|u| If(PCount()>0,cText:=u,cText)}
oMget_11:SetFocus()
oDlg_11:Activate(,,,.T.)

Return lRet

 
***************************
Static Function trocaTela()              
***************************
if nTela == 1
   nTela := 2
   oBmp7:cBmpFile := "ESTMAQS_BRANCO.bmp"
   oBmp8:cBmpFile := "ESTMAQS_VERDE.bmp"
else
   nTela := 1
   oBmp7:cBmpFile := "ESTMAQS_VERDE.bmp"
   oBmp8:cBmpFile := "ESTMAQS_BRANCO.bmp"
endIf

oBmp7:refresh()
oBmp8:refresh()	

Return


*************************
Static Function totaliz()
*************************

Local oFont1,oFont2,oFont3,oFont4,oDlg1,oGrp1,oBrw1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oTimer55
Local cARQTMP := ''
Local aESTRUT := {}
Local cAlias  := ""

Private nTAPARA := nTQTDMR := nTQTDKG := nTotAP := nPerApa := nPercTAP := 0

if oPanel1:lVisibleControl .or. oPanel1:lVisibleControl
   Return	
endIf
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//oFont1  := TFont():New( "Courier New",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )      //FR: aumentar esta fonte  (TOTAIS) - o número com sinal (-) é o tam. da fonte
//oFont2  := TFont():New( "Franklin Gothic Medium",0,-37,,.F.,0,,400,.F.,.F.,,,,,, )  //FR: Cfe. solicitação de Lindenberg, diminuir esta fonte  (HORA)
oFont1  := TFont():New( "Courier New"           ,0,-19,,.T.,0,,700,.F.,.F.,,,,,, )     		//FONTE DO TOTAIS
oFont2  := TFont():New( "Franklin Gothic Medium",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )          //FONTE DA HORA
oFont3  := TFont():New( "Arial",0,-24,,.T.,0,,700,.F.,.F.,,,,,, ) 
oFont4  := TFont():New( "Arial",0,-15,,.T.,0,,700,.F.,.F.,,,,,, ) 					//FONTE DO AVISO DA TECLA
//oDlg1   := MSDialog():New( 126,254,701,1049,"Produção acumulada",,,.F.,,,,,,.T.,,,.F. )   //PAINEL EM VOLTA
oDlg1   := MSDialog():New( 126,254,701,1049,"Produção acumulada",,,.F.,,,,,,.T.,,oFont3,.F. )   //PAINEL EM VOLTA - Grid com fonte maior
oGrp1   := TGroup():New( 003,003,283,392,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )         //LINHA FINA EM VOLTA DO GRID
 
aESTRUT := {{ "MAQ"        ,   "C", 006, 0 },;    //MAQ
		    { "INTERV"     ,   "C", 014, 0 },;		   	
			{ "TURNO"      ,   "C", 001, 0 },;
           	{ "QUANTMR"    ,   "N", 009, 2 },;
           	{ "HORA"       ,   "C", 005, 0 },;
            { "META"       ,   "N", 009, 2 },;
            { "EFICI"      ,   "N", 006, 2 },;
            { "APARA"      ,   "N", 005, 2 }}
            
cARQTMP := CriaTrab( aESTRUT, .T. )

cAlias := Alias()
DbcloseArea(cAlias)

DbUseArea( .T.,, cARQTMP, "PRD", .F., .F. )
Index On MAQ + TURNO + INTERV To &cARQTMP

oBrw1   := MsSelect():New( "PRD",,,;
{{ "MAQ"     ,   "", "Máquina  ",			         "" },;
 { "INTERV"  ,   "", "Produção",		             "" },;                  
 { "TURNO"   ,   "", "Turno ",	  			         "" },;
 { "( Trans( QUANTMR, '@E 999,999.99' ) )", "", "Produção (MR) ", "" },; 
 { "( Trans( META,    '@E 999,999.99' ) )", "", "Meta", "" },;
 { "( Trans( EFICI,   '@E 999.99' ) )",     "", "Efic%", "" },;
 { "( Trans( APARA,   '@E 999.99' ) )",     "", "Apara (KG)  ",    "" }},.F.,,{010,007,171,387},,, oGrp1 )   //Grid 
															                //{010,007,241,387} o penúltimo número é a altura,o último é a largura 
oBrw1:oBrowse:nLinhas := 2	//FR: Define a altura da linha do grid

//FR
oSay1      := TSay():New( 175,020,{||"Totais:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,066,011)                          //só título

oSay2      := TSay():New( 190,032,{||"Peso"}      ,oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,066,011)                     //só título
oSay3      := TSay():New( 190,098,{||"Prod. (MR)"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,066,011)                     //só título
oSay4      := TSay():New( 190,180,{||"Aparas(%)"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,146,011)       //só título - larg/altura

oSay5      := TSay():New( 218,017,{||""},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,014)                 //Total PESO
oSay6      := TSay():New( 218,086,{||""},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,014)					//Produção (MR) - o que foi pesado	
oSay7      := TSay():New( 218,170,{||""},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,066,014)                 //Total Aparas (%)

oSay8     := TSay():New( 256,020,{||"Hora:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,022)
oSay9     := TSay():New( 256,066,{||substr(time(),1,5) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,022)
oSay10    := TSay():New( 268,160,{||"F2 << Volta Tela Anterior"},oGrp1,,oFont4,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,011)
//oTimer55 := TTimer():New( 30000, { || oTimer55:End(), oDLG1:End(), PRD->( __DbZap() ), PRD->( DbCloseArea() ) }, oDLG1 )
//oTimer55:Activate() 

MsAguarde( {|| Mostra2() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo produção..." ) )

//Conteúdos:
oSay5:cCaption := transform(nTQTDKG  , "@E 999,999.99")          //Total PESO
oSay6:cCaption := transform(nTQTDMR  , "@E 999,999.99")          //Produção (MR) - o que foi pesado
oSay7:cCaption := transform(nPercTAP , "@E 999,999.99")          //Total Aparas (%)

SetKey(  VK_F2,  { || oDLG1:End(), PRD->( __DbZap() ), PRD->( DbCloseArea()), Mostra( cBuffer, mv_par01, mv_par02 )   } )

oDlg1:Activate(,,,.T.)
DbcloseArea("PRD")

Return


*************************
Static Function Mostra2()
*************************

Local cTurnoAtual := ""
Local cInterval   := ""
Local dDIA


cTurnoAtual := GetTurno()          //FR: Obtém o turno atual que será usado para mostrar os apontamentos

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )

dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )

DbSelectArea("SB1")
DbSelectArea("SC2")
DbSelectArea("SB5")
DbSelectArea("ZB1")
DbSetOrder(1)


cQuery := " SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT "
cQuery += " ,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF, SB5.B5_PRDHORA " 
cQuery += " FROM " + RetSqlName( "Z00" ) + " Z00 , " + RetSqlName( "SB5" ) + " SB5 "
If cTurnoAtual = "1"
	cQuery += " WHERE Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "05:35'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' "
Elseif cTurnoAtual = "2" 
	cQuery += " WHERE Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "13:56'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' "
Elseif cTurnoAtual = "3"
	cQuery += " WHERE Z00.Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "22:01'"  +  " AND '"  + DtoS(Date()) + Substr(Time(),1,5) + "' " 
Endif
cQuery += " AND Z00.Z00_MAQ IN  ('" + substr(cBuffer,1,3) + "')   " 
//cQUERY += " AND ( LEFT(Z00.Z00_OP,6) = '" + mv_par01 + "' " + " OR LEFT(Z00.Z00_OP,6) = '" + mv_par02 + "' ) " 
cQuery += " AND Z00.Z00_CODIGO = SB5.B5_COD "
cQuery += " AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY Z00.Z00_MAQ,Z00.Z00_HORA "
cQuery := ChangeQuery( cQuery ) 
//MemoWrite("cQryZ00X.sql", cQuery)

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )


cQuery9 := "SELECT SUM(Z00_PESO + Z00_PESCAP) AS QTD_KG, SUM(Z00_QUANT) / 1000 AS QTD_ML, SUM(Z00_QUANT) AS QTD_TOT"
cQuery9 += " FROM " + RetSqlName("Z00") + " Z00 "
cQuery9 += " WHERE Z00_DATA = CONVERT(varchar(8), CONVERT(smalldatetime, GETDATE()), 112) "

//Vai selecionar somente os lançamentos do turno corrente, conforme solicitado por Lindenberg em 19/08/09  
If cTurnoAtual = "1"
	cQuery9 += " AND Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "05:35'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "
Elseif cTurnoAtual = "2" 
	cQuery9 += " AND Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "13:56'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "
Elseif cTurnoAtual = "3"
	cQuery9 += " AND Z00_DATHOR BETWEEN '" + Dtos(dDIA) + "22:01'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "
Endif
//cQuery9 += " AND ( LEFT(Z00_OP,6) = '" + mv_par01 + "' " + " OR LEFT(Z00_OP,6) = '" + mv_par02 + "' ) " 
cQuery9 += " AND Z00_APARA = ' ' " 
//cQuery9 += " AND Z00_MAQ IN ('C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'P01', 'P02', 'P03', 'P04', 'P05', 'S01') "
cQuery9 += "AND Z00_MAQ  like '[CPS][0123456789]%' "
cQuery9 += " AND Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND D_E_L_E_T_ = ' ' "
cQuery9 := ChangeQuery( cQuery9 )

//MemoWrite("cQryTOTX.sql",cQuery9)

If Select("TOTX") > 0
	DbSelectArea("TOTX")
	DbCloseArea()
EndIf

TCQUERY cQuery9 NEW ALIAS "TOTX"

nTotsKG := 0
nTotsML := 0
nTotLanc:= 0     // total pesado

TOTX->( DbGoTop() )

If ! TOTX->( EoF() )
	nTotsKG := TOTX->QTD_KG
	nTotsML := TOTX->QTD_ML
	nTotLanc:= TOTX->QTD_TOT
EndIF

TOTX->( DbCloseArea() )


//Query para apuração do tempo de operação da máquina
//a fim de medir o produzido x meta
//REGISTRO INÍCIO
cQueryf := " SELECT TOP 1 ZB0_FILIAL,ZB0_MAQ,ZB0_OP,ZB0_DATA,ZB0_HORA,ZB0_TIPO "    //Vai capturar o primeiro registro
cQueryf += " FROM " + RetSqlname("ZB0") + " ZB0 "
cQueryf += " WHERE ZB0.ZB0_MAQ IN  ('" + substr(cBuffer,1,3) + "')   " 

If cTurnoAtual = "1"
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "05:35'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "

Elseif cTurnoAtual = "2" 
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "13:56'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "

Elseif cTurnoAtual = "3"
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "22:01'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "
Endif
cQueryf += " AND ZB0_FILIAL = '" + xFilial( "ZB0" ) + "' AND D_E_L_E_T_ = ' ' "
cQueryf += " AND ZB0_TIPO = '0' "		//ZB0_TIPO = 0 Significa que é o registro de entrada, início da operação
cQueryf += " ORDER BY ZB0_DATA,ZB0_HORA "		
cQueryf := ChangeQuery( cQueryf )

//MemoWrite("ZB0-A.sql",cQueryf)

cDataI := ""
cHoraI := ""

If Select("METAA") > 0
	DbSelectArea("METAA")
	DbCloseArea()
EndIf

TCQUERY cQueryf NEW ALIAS "METAA" 

METAA->( DbGoTop() )

Do While !METAA->( Eof() )

	cDataI := (METAA->ZB0_DATA)
	cHoraI := (METAA->ZB0_HORA)
	
	METAA->(DBSKIP())
Enddo

DbSelectArea("METAA")
DbCloseArea()

//REGISTRO FINAL
cQueryg := " SELECT TOP 1 ZB0_FILIAL,ZB0_MAQ,ZB0_OP,ZB0_DATA,ZB0_HORA,ZB0_TIPO "    //Vai capturar o primeiro registro
cQueryg += " FROM " + RetSqlname("ZB0") + " ZB0 "
cQueryg += " WHERE ZB0.ZB0_MAQ IN  ('" + substr(cBuffer,1,3) + "')   " 

If cTurnoAtual = "1"
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "05:35'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "

Elseif cTurnoAtual = "2" 
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "13:56'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "

Elseif cTurnoAtual = "3"
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(dDIA) + "22:01'" + " AND '" + DtoS(Date()) + Substr(Time(),1,5) + "' "
Endif
cQueryg += " AND ZB0_FILIAL = '" + xFilial( "ZB0" ) + "' AND D_E_L_E_T_ = ' ' "
cQueryg += " AND ZB0_TIPO = '1' "		//ZB0_TIPO = 0 Significa que é o registro de entrada, início da operação
cQueryg += " ORDER BY ZB0_DATA,ZB0_HORA DESC "		
cQueryg := ChangeQuery( cQueryg )

//MemoWrite("ZB0-B.sql",cQueryg)

cDataF := ""
cHoraF := ""

If Select("METAB") > 0
	DbSelectArea("METAB")
	DbCloseArea()
EndIf

TCQUERY cQueryg NEW ALIAS "METAB" 

METAB->( DbGoTop() )

Do While !METAB->( Eof() )

	cDataF := (METAB->ZB0_DATA)
	cHoraF := (METAB->ZB0_HORA)
	
	METAB->(DBSKIP())
	
Enddo

If Empty(cDataF)
	cDataF := Dtos(Date())
Endif


If Empty(cHoraF)
	cHoraF := Time()
Endif

cDuracao := ""

cDuracao := fDifData(cDataI,cDataF,cHoraI,cHoraF)

nHorasOper := 0
nHorasOper:= cDuracao
//nHorasOper := Val(nHorasOper)

DbSelectArea("METAB")
DbCloseArea()


nTQTDKG := 0
nTQTDMR := 0
nTAPARA := 0
nPerApa := 0
nTotAP  := 0  
nPercTAP:= 0  //percentual total de aparas pelo total lançado


PRD->( __DbZap() )
Z00X->( DbGoTop() )
PRD->( DbGoTop() )
nMeta := 0
Do While ! Z00X->( Eof() )
	SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
    ZB1->( DbSeek( xFilial( "ZB1" ) + Alltrim(Z00X->Z00_MAQ) + SC2->C2_PRODUTO ) )
	//
	cInterval := GetInterv(dDIA,cTurnoAtual,Z00X->Z00_HORA)
	Dbselectarea("PRD")
	If !PRD->( DbSeek( Z00X->Z00_MAQ + cTurnoAtual + cInterval  ) )			//MÁQUINA + TURNO + NUMERO DO INTERVALO
		PRD->( DbAppend() )
		PRD->MAQ     := Z00X->Z00_MAQ
		PRD->TURNO   := cTurnoAtual
		PRD->INTERV  := cInterval				
	Endif
	
	If Z00X->Z00_APARA != " "
		If Z00X->Z00_APARA $ "12"					         			
			PRD->APARA  += Z00X->Z00_PESO    //FR 25/08/09 - : Era por lançamento/hora, 
											 //Lindenberg pediu que acumulasse por intervalo
		Else      		        		         			
			PRD->APARA  += Z00X->Z00_PESO    //FR: Era por lançamento/hora, 
											 //Lindenberg pediu que acumulasse por intervalo         	
		EndIf
		nTAPARA     += Z00X->Z00_PESO
		nTotAP      += Z00X->Z00_PESO					
		
	Else									
		PRD->QUANTMR += Z00X->Z00_QUANT /1000	//	/ SB5->B5_QE2	//FR: Multiplica por 1000 direto	
		//Alterei para buscar do cadastro de metas. ZB1
		PRD->META	:=  ZB1->( ZB1_META * ZB1_LADOS )   //(SB5->B5_PRDHORA * 2 )
		PRD->EFICI  :=  Round( ( PRD->QUANTMR / PRD->META ) * 100, 2 )		//PRODUZIDO / META = %Eficiência
	Endif		
	
	nTQTDKG      += Z00X->Z00_PESO + Z00X->Z00_PESCAP
	nTQTDMR      += Z00X->Z00_QUANT / 1000			//	/ SB5->B5_QE2
	DbselectArea("Z00X")
	Z00X->( DbSkip() )
Enddo

nPercTAP := ( nTotAP / (nTQTDKG + nTotAP) ) * 100

//Fórmula: [ Total Aparas / (Peso Total + Total Aparas)] * 100 
//Por Lindenberg em 25/08/09.

Z00X->( DbCLoseArea() )
PRD->( DbGoTop() )
//DbcloseArea("PRD")

Return NIL



**********************************
Static Function prdAtual(cTurnoA)
**********************************  

Local nProd := 0
/*
if cTurnoA == "1"//5,35 10,30 11,30 13,55
	if time() <= "10:30:00"
		cTempo := Tempo( date(), "05:35:00", date(), time() )
	elseIf time() > "10:30:00" .and. time() < "11:30:00"
		cTempo := "04:55:00"
	else
		cTempo := U_SomaHora( "04:55:00", Tempo( date(), "11:30:00", date(), time() ) )
	endIf
elseIf cTurnoA == "2"//13,40 18,00 19,00 22,00
	if time() <= "18:00:00"
		cTempo := Tempo( date(), "13:40:00", date(), time() )
	elseIf time() > "18:00:00" .and. time() < "19:00:00"
		cTempo := "04:20:00"
	else
		cTempo := U_SomaHora( "04:20:00", Tempo( date(), "19:00:00", date(), time() ) )
	endIf
elseIf cTurnoA == "3"//22,00 02,00 03,00 5,30
	if time() <= "22:00:00"
		cTempo := Tempo( dDataBase, "22:00:00", date(), time() )
	elseIf time() > "22:00:00" .and. time() < "02:00:00"
		cTempo := "04:00:00"
	else
		cTempo := U_SomaHora( "04:00:00", Tempo( date(), "03:00:00", date(), time() ) )
	endIf	
else
	//Impossível determinar
endIf
*/


if cTurnoA == "1"//5,35 10,30 11,30 13,55
	if time() <= "10:00:00"
		cTempo := Tempo( date(), "06:00:00", date(), time() )
	elseIf time() > "10:00:00" .and. time() < "11:00:00"
		cTempo := "04:00:00"
	else
		cTempo := U_SomaHora( "04:00:00", Tempo( date(), "11:00:00", date(), time() ) )
	endIf
elseIf cTurnoA == "2"//13,40 18,00 19,00 22,00
	if time() <= "18:00:00"
		cTempo := Tempo( date(), "13:40:00", date(), time() )
	elseIf time() > "18:00:00" .and. time() < "19:00:00"
		cTempo := "04:20:00"
	else
		cTempo := U_SomaHora( "04:20:00", Tempo( date(), "19:00:00", date(), time() ) )
	endIf
elseIf cTurnoA == "3"//22,00 02,00 03,00 5,30
	if time() <= "22:00:00"
		cTempo := Tempo( dDataBase, "22:00:00", date(), time() )
	elseIf time() > "22:00:00" .and. time() < "02:00:00"
		cTempo := "04:00:00"
	else
		cTempo := U_SomaHora( "04:00:00", Tempo( date(), "03:00:00", date(), time() ) )
	endIf	
else
	//Impossível determinar
endIf

nProd := val(strTran(substr(cTempo,1,5),":","."))

Return nProd



**************************************************
Static Function GetTurno()
**************************************************

Local cTurno := ""
Local dDIAA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )
//Ex.: hoje é 20/08/09, 
//se dDIA for = 19/08/09 o turno é o 3
//se dDIA for = 20/08/09, ver a hora
//se a hora for <= 13:55 ==> turno 1
//se a hora for >= 13:56 ==> turno 2
//se a hora for >= 22:00 ==> turno 3 

/*
If dDIAA < dDatabase
	cTurno := "3"	
Elseif Time() >= "05:35:00" .and. Time() <= "13:55:00"
	cTurno := "1"		
Elseif Time() >= "13:56:00" .and. Time() <= "22:00:00"
	cTurno := "2"
Endif
*/


If dDIAA < dDatabase
	cTurno := "3"		
Elseif Time() >= "06:00:00" .and. Time() <= "14:00:00"
	cTurno := "1"		
Elseif Time() >= "14:01:00" .and. Time() <= "22:00:00"
	cTurno := "2"
Endif

Return(cTurno)



*************************************************
Static Function GetInterv(dDIA,cTurnoAtual,cHora)
*************************************************

Local aInterv    := {}
Local cIntervalo := ""

//aAdd(aLiberad,{	CONFLIB->C9_PRODUTO,CONFLIB->C9_QTDLIB,CONFLIB->C9_LOCAL,CONFLIB->C9_NUMCX } )     
//aLiberad[j][1]
//aListBox[i][3]

//dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )
//Ex.: hoje é 20/08/09, 
//se dDIA for = 19/08/09 o turno é o 3
//se dDIA for = 20/08/09, ver a hora
//se a hora for <= 13:55 ==> turno 1
//se a hora for >= 13:56 ==> turno 2
//se a hora for >= 22:00 ==> turno 3 

If 	cTurnoAtual = "1"
/*
	aAdd(aInterv, "05:50 - 06:50")    //1
    aAdd(aInterv, "06:50 - 07:50")    //2
    aAdd(aInterv, "07:50 - 08:50")    //3
	aAdd(aInterv, "08:50 - 09:50")    //4
 	aAdd(aInterv, "09:50 - 10:30")    //5
    aAdd(aInterv, "10:30 - 11:30")    //6 Almoço
 	aAdd(aInterv, "11:30 - 11:50")    //7
 	aAdd(aInterv, "11:50 - 12:50")    //8
 	aAdd(aInterv, "12:50 - 13:55")    //9
*/
	aAdd(aInterv, "06:00 - 07:00")    //1
    aAdd(aInterv, "07:00 - 08:00")    //2
    aAdd(aInterv, "08:00 - 09:00")    //3
	aAdd(aInterv, "09:00 - 10:00")    //4
 	aAdd(aInterv, "10:00 - 11:00")    //5 Almoco
    aAdd(aInterv, "11:00 - 12:00")    //6 
 	aAdd(aInterv, "12:00 - 13:00")    //7
 	aAdd(aInterv, "13:00 - 14:00")    //8

Elseif cTurnoAtual = "2"
    //aAdd( aPrdOK, { aLiberad[j][1], nTotLib,aListBox[i][6] })
/*    
	aAdd(aInterv, "13:56 - 15:00")    //1
    aAdd(aInterv, "15:00 - 16:00")    //2
	aAdd(aInterv, "16:00 - 17:00")    //3
	aAdd(aInterv, "17:00 - 18:00")    //4
 	aAdd(aInterv, "18:00 - 19:00")    //5 Jantar
    aAdd(aInterv, "19:00 - 20:00")    //6
 	aAdd(aInterv, "20:00 - 21:00")    //7
 	aAdd(aInterv, "21:00 - 22:00")    //8
*/

	aAdd(aInterv, "14:00 - 15:00")    //1
    aAdd(aInterv, "15:00 - 16:00")    //2
	aAdd(aInterv, "16:00 - 17:00")    //3
	aAdd(aInterv, "17:00 - 18:00")    //4
 	aAdd(aInterv, "18:00 - 19:00")    //5 Jantar
    aAdd(aInterv, "19:00 - 20:00")    //6
 	aAdd(aInterv, "20:00 - 21:00")    //7
 	aAdd(aInterv, "21:00 - 22:00")    //8

Elseif cTurnoAtual = "3"
/*
	aAdd(aInterv, "22:01 - 23:00")     //1
	aAdd(aInterv, "00:00 - 01:00")     //2
	aAdd(aInterv, "01:00 - 02:00")     //3
	aAdd(aInterv, "02:00 - 03:00")     //4 Refeição
	aAdd(aInterv, "03:00 - 04:00")     //5
	aAdd(aInterv, "04:00 - 05:00")     //6
	aAdd(aInterv, "05:00 - 05:30")     //7
*/	
	aAdd(aInterv, "22:00 - 23:00")     //1
	aAdd(aInterv, "23:00 - 24:00")     //2
	aAdd(aInterv, "00:00 - 01:00")     //3
	aAdd(aInterv, "01:00 - 02:00")     //4
	aAdd(aInterv, "02:00 - 03:00")     //5 Refeição
	aAdd(aInterv, "03:00 - 04:00")     //6
	aAdd(aInterv, "04:00 - 05:00")     //7
	aAdd(aInterv, "05:00 - 06:00")     //8
	
Endif

For fr := 1 to Len(aInterv)		
   If cHora >= Substr(aInterv[fr],1,5) .and. cHora <= Substr(aInterv[fr],9,5)
      cIntervalo := aInterv[fr]
   Endif
Next


Return(cIntervalo)  


********************************
Static Function fVerLiga(iCanal)
********************************

Local nStatus 
  
if File( 'c:\semaforo'+Alltrim(Str(iCanal)) )
   nStatus := 0
else
   nStatus := 1
endif   


Return (nStatus)


*************************************************
Static Function fGrvInicio(cOP1,cOP2,cMaq0,cMaq1)
*************************************************

//mv_par01 - OP 1
//mv_par02 - OP 2 
dDataHoje := DATE()
cHoraAgora:= Time()
cProdSC2  := ""

//Procura a OP 1
DbselectArea("ZB0")
DbsetOrder(1)		//ZB0_FILIAL + ZB0_MAQ + ZB0_OP + DTOS(ZB0_DATA) + ZB0_HORA

If !ZB0->(Dbseek(xFilial("ZB0") + cMaq0 + cOP1 + Dtos(dDataHoje) + cHoraAgora ))
	Reclock("ZB0",.T.)
	ZB0_FILIAL 	:= xFilial("ZB0")
	ZB0_MAQ		:= cMaq0
	ZB0_OP		:= cOP1
	ZB0_DATA	:= dDataHoje
	ZB0_HORA	:= Time()
	ZB0_TIPO	:= "0"		// Zero = Início
	
	SC2->(Dbsetorder(1))	//C2_FILIAL + C2_NUM
	SC2->(Dbseek(xFilial("SC2") + cOP1 ))
	cProdSC2 	:= SC2->C2_PRODUTO
	
	DbselectArea("ZB0")
	ZB0_PROD	:= cProdSC2
	
	ZB0->(MsUnlock())
Endif			 

//Procura a OP 2
DbselectArea("ZB0")
DbsetOrder(1)		//ZB0_FILIAL + ZB0_MAQ + ZB0_OP + DTOS(ZB0_DATA) + ZB0_HORA
If !ZB0->(Dbseek(xFilial("ZB0") + cMaq1 + cOP2 + Dtos(dDataHoje) + cHoraAgora ))
	Reclock("ZB0",.T.)
	ZB0_FILIAL 	:= xFilial("ZB0")
	ZB0_MAQ		:= cMaq1
	ZB0_OP		:= cOP2
	ZB0_DATA	:= dDataHoje
	ZB0_HORA	:= Time()
	ZB0_TIPO	:= "0"		// Zero = Início
	
	SC2->(Dbsetorder(1))	//C2_FILIAL + C2_NUM
	SC2->(Dbseek(xFilial("SC2") + cOP2 ))
	cProdSC2 	:= SC2->C2_PRODUTO
	
	DbselectArea("ZB0")
	ZB0_PROD	:= cProdSC2
	
	ZB0->(MsUnlock())
Endif

Return								



**********************************************
Static Function fGrvFim(cOP1,cOP2,cMaq0,cMaq1)
**********************************************

//mv_par01 - OP 1
//mv_par02 - OP 2 
dDataHoje := DATE()
cHoraAgora:= Time()
cProdSC2  := ""

//Procura a OP 1
DbselectArea("ZB0")
DbsetOrder(1)		//ZB0_FILIAL + ZB0_MAQ + ZB0_OP + DTOS(ZB0_DATA) + ZB0_HORA

If !ZB0->(Dbseek(xFilial("ZB0") + cMaq0 + cOP1 + Dtos(dDataHoje) + cHoraAgora ))
	Reclock("ZB0",.T.)
	ZB0_FILIAL 	:= xFilial("ZB0")
	ZB0_MAQ		:= cMaq0
	ZB0_OP		:= cOP1
	ZB0_DATA	:= dDataHoje
	ZB0_HORA	:= Time()
	ZB0_TIPO	:= "1"		//1 = Fim
	
	SC2->(Dbsetorder(1))	//C2_FILIAL + C2_NUM
	SC2->(Dbseek(xFilial("SC2") + cOP1 ))
	cProdSC2 	:= SC2->C2_PRODUTO
	
	DbselectArea("ZB0")
	ZB0_PROD	:= cProdSC2
	
	ZB0->(MsUnlock())
Endif			 

//Procura a OP 2
DbselectArea("ZB0")
DbsetOrder(1)		//ZB0_FILIAL + ZB0_MAQ + ZB0_OP + DTOS(ZB0_DATA) + ZB0_HORA
If !ZB0->(Dbseek(xFilial("ZB0") + cMaq1 + cOP2 + Dtos(dDataHoje) + cHoraAgora ))
   Reclock("ZB0",.T.)
   ZB0_FILIAL 	:= xFilial("ZB0")
	ZB0_MAQ		:= cMaq1
	ZB0_OP		:= cOP2
	ZB0_DATA	:= dDataHoje
	ZB0_HORA	:= Time()
	ZB0_TIPO	:= "1"		//1 = Fim
	
	SC2->(Dbsetorder(1))	//C2_FILIAL + C2_NUM
	SC2->(Dbseek(xFilial("SC2") + cOP2 ))
	cProdSC2 	:= SC2->C2_PRODUTO
	
	DbselectArea("ZB0")
	ZB0_PROD	:= cProdSC2
	
	ZB0->(MsUnlock())
Endif

Return								


*************************************************************
Static Function fDifData(cDataIni,cDataFim,cHoraIni,cHorafim)
*************************************************************

Local dDataI
Local dDataF
Local cHoraI
Local cHoraF 
Local nDifdia := 0
Local nDifhora:= 0
Local cElap1
Local cElap2
Local cHoraspassou
Local cMeiaNoite

set date brit

dDataI := Stod(cDataIni)
dDataF := Stod(cDataFim)
cHoraI := cHoraIni
cHoraF := cHoraFim
cMeiaNoite := "24:00:00"

nDifdia := (dDataF - dDataI)

If nDifdia = 0
	cElap1 := ElapTime( cHoraI, cHoraF ) //Resultado: "01:15:15"
	cElap2 := "0"
Elseif nDifdia >= 1
	cElap1 := ElapTime(cHoraI, cMeiaNoite)
	cElap2 := ElapTime(cMeiaNoite,cHoraF)
Endif

cHoraspassou := Val(cElap1) + Val(cElap2)

Return(cHoraspassou)