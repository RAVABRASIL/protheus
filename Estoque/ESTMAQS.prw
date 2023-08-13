#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :16/9/2008  ³±±
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

User Function ESTMAQS()

*************
TELA1()
/*
oBmp1:cBmpFile := "ESTMAQS_AZUL.bmp"
oBmp2:cBmpFile := "ESTMAQS_LARANJA.bmp"
oBmp3:cBmpFile := "ESTMAQS_AMARELO.bmp"
oBmp4:cBmpFile := "ESTMAQS_VERDE.bmp"
*/

return

***************

Static Function TELA1()

***************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oTimer1","oDlg1","oBmp2","oBmp1","oSay4","oSay5","oSay6","oSay7")
SetPrvt("oSay9","oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay41","oSay40","oSay39")
SetPrvt("oSay37","oSay36","oSay35","oSay34","oSay33","oSay32","oSay31","oSay30","oBmp4","oSay68","oSay69")
SetPrvt("oBmp3","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay43","oSay42","oSay44")
SetPrvt("oSay46","oSay47","oSay51","oSay50","oSay49","oSay48","oSay25","oSay26","oSay52","oSay53","oSay54")
SetPrvt("oSay59","oSay58","oSay57","oSay56","oSay27","oSay28","oSay60","oSay61","oSay62","oSay63","oSay67")
SetPrvt("oSay65","oSay64","oSay29","oSay24","oSay71","oSay72","oSay73","oSay74","oSay75","oGrp1","oSay1")
SetPrvt("oSay3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial Black",0,-27,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial Black",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 126,254,701,1049,"oDlg1",,,.F.,,,,,,.T.,,,.F. )
oTimer1    := TTimer():New( 1000,{||teste()}, oDlg1 )
oTimer1:Activate()
oBmp2      := TBitmap():New( 043,199,191,105,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp1      := TBitmap():New( 043,007,188,198,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay4      := TSay():New( 047,010,{||"ORDEM DE PRODUÇÃO CORTE E SOLDA"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,176,009)
oSay5      := TSay():New( 061,010,{||"OP C.S.  Nº"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 076,010,{||"PRODUTO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 091,010,{||"Quant.(KG):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 106,010,{||"Quant.(MR):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 121,010,{||"DADOS TÉCNICOS:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
oSay10     := TSay():New( 136,010,{||"FORMULAÇÃO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay11     := TSay():New( 151,010,{||"COMPRIMENTO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay12     := TSay():New( 166,010,{||"LARGURA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 181,010,{||"ESPESSURA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oSay14     := TSay():New( 197,010,{||"QDE. POR PACOTE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay15     := TSay():New( 212,010,{||"ALTURA DO TRIÂNGULO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
oSay16     := TSay():New( 227,010,{||"VELOCIDADE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,007)
oSay41     := TSay():New( 227,047,{||"oSay41"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay40     := TSay():New( 212,082,{||"oSay40"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay39     := TSay():New( 197,070,{||"oSay39"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 181,049,{||"oSay38"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay37     := TSay():New( 166,049,{||"oSay37"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay36     := TSay():New( 151,056,{||"oSay36"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay35     := TSay():New( 136,056,{||"oSay35"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay34     := TSay():New( 121,067,{||"oSay34"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay33     := TSay():New( 106,047,{||"oSay33"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay32     := TSay():New( 091,047,{||"oSay32"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay31     := TSay():New( 076,047,{||"oSay31"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay30     := TSay():New( 061,047,{||"oSay30"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBmp4      := TBitmap():New( 243,007,384,041,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
/*oSay68     := TSay():New( 252,010,{||"oSay68"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay69     := TSay():New( 260,010,{||"oSay69"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay70     := TSay():New( 266,010,{||"oSay70"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)*/
oSay68     := TSay():New( 252,010,{||"oSay68"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay69     := TSay():New( 259,010,{||"oSay69"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay70     := TSay():New( 266,010,{||"oSay70"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oBmp3      := TBitmap():New( 153,199,191,088,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay17     := TSay():New( 171,202,{||"F5  - Troca de Bobina"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay18     := TSay():New( 180,202,{||"F6  - Setup (usa leitor de cod. Barras)"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay19     := TSay():New( 188,202,{||"F7  - Troca Faca/Teflon"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay20     := TSay():New( 197,202,{||"F8  - Manutenção Eletrica"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay21     := TSay():New( 205,202,{||"F9  - Manutenção Mecânica"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay22     := TSay():New( 214,202,{||"F10 - Outros (pode digitar informações)"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay23     := TSay():New( 222,202,{||"F11 - Resumo de Produção Mensal"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay43     := TSay():New( 139,202,{||"Apara"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
oSay42     := TSay():New( 127,202,{||"Falta produzir"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
oSay44     := TSay():New( 115,201,{||"Produzido nesta OP"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
oSay45     := TSay():New( 115,276,{||"oSay45"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay46     := TSay():New( 127,276,{||"oSay46"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay47     := TSay():New( 139,276,{||"oSay47"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay51     := TSay():New( 102,202,{||"oSay51"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay50     := TSay():New( 093,202,{||"oSay50"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay49     := TSay():New( 082,202,{||"oSay49"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay48     := TSay():New( 070,202,{||"oSay48"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 058,202,{||"Data"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 058,239,{||"Turno"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay52     := TSay():New( 070,239,{||"oSay52"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay53     := TSay():New( 081,239,{||"oSay53"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay54     := TSay():New( 092,239,{||"oSay54"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay55     := TSay():New( 102,239,{||"oSay55"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay59     := TSay():New( 102,277,{||"oSay59"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay58     := TSay():New( 092,277,{||"oSay58"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay57     := TSay():New( 081,277,{||"oSay57"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay56     := TSay():New( 070,277,{||"oSay56"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 058,277,{||"Qde Prod. Mr"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 058,314,{||"Apara"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay60     := TSay():New( 070,314,{||"oSay60"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay61     := TSay():New( 081,314,{||"oSay61"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay62     := TSay():New( 092,314,{||"oSay62"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay63     := TSay():New( 102,314,{||"oSay63"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay67     := TSay():New( 102,352,{||"oSay67"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay66     := TSay():New( 092,352,{||"oSay66"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay65     := TSay():New( 081,352,{||"oSay65"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay64     := TSay():New( 070,352,{||"oSay64"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 058,352,{||"Operador"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 047,203,{||"                 DADOS DE PRODUÇÃO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,178,011)
oSay71     := TSay():New( 154,202,{||"Funções:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
oSay72     := TSay():New( 245,010,{||"Próximas programações:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,006)
oSay73     := TSay():New( 163,202,{||"F4  - Sair do programa"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay74     := TSay():New( 231,202,{||"F12 - Ler outra bobina"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oSay75     := TSay():New( 273,010,{||"oSay75"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oGrp1      := TGroup():New( 004,007,040,391,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 013,012,{||"CORTE E SOLDA 1"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,018)
oSay2      := TSay():New( 014,202,{||"17/12/2008"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,018)
oSay3      := TSay():New( 014,301,{||"15:58"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,018)
oBmp1:cBmpFile := "ESTMAQS_AZUL.bmp"
oBmp2:cBmpFile := "ESTMAQS_LARANJA.bmp"
oBmp3:cBmpFile := "ESTMAQS_AMARELO.bmp"
oBmp4:cBmpFile := "ESTMAQS_VERDE.bmp"
oDlg1:Activate(,,,.T.)

Return