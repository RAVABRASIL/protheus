#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

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

User Function ESTMAQS2()

SetPrvt("oFont1" ,"oFont2" ,"oFont3" ,"oTimer1","oDlg1"  ,"oBmp2" ,"oBmp1" ,"oSay4"   ,"oSay5"  ,"oSay6" ,"oSay7")
SetPrvt("oSay9"  ,"oSay10" ,"oSay11" ,"oSay12" ,"oSay13" ,"oSay14","oSay15","oSay16"  ,"oSay41" ,"oSay40","oSay39")
SetPrvt("oSay37" ,"oSay36" ,"oSay35" ,"oSay32" ,"oSay31" ,"oSay30","oBmp4" ,"oSay68"  ,"oSay69" ,"oSay70","oSay43")
SetPrvt("oSay44" ,"oSay45" ,"oSay46" ,"oSay47" ,"oSay51" ,"oSay50","oSay49","oSay48"  ,"oSay25" ,"oSay26","oSay52")
SetPrvt("oSay54" ,"oSay55" ,"oSay59" ,"oSay58" ,"oSay57" ,"oSay56","oSay27","oSay28"  ,"oSay60" ,"oSay61","oSay62")
SetPrvt("oSay67" ,"oSay66" ,"oSay65" ,"oSay64" ,"oSay29" ,"oSay24","oSay72","oSay75"  ,"oSay33" ,"oSay34","oSay76")
SetPrvt("oSay78" ,"oSay79" ,"oSay80" ,"oSay81" ,"oSay82" ,"oSay84","oSay85","oSay86"  ,"oSay87" ,"oSay88","oSay89")
SetPrvt("oSay91" ,"oSay92" ,"oSay93" ,"oSay94" ,"oSay95" ,"oSay96","oSay97","oSay98"  ,"oBmp5"  ,"oSay73","oSay99")
SetPrvt("oSay101","oSay102","oSay103","oSay17" ,"oSay18" ,"oSay19","oSay20","oSay21"  ,"oSay22" ,"oSay23")
SetPrvt("oSay74" ,"oSay83" ,"oGrp1"  ,"oSay1"  ,"oSay2"  ,"oSay3" ,"cTexto","lBalanca","nHANDLE","cPORTABAL","cPORTAIMP")
SetPrvt("nTOLERA","nLIMITE","nPVAROP","nHandle","cBuffer","cNome")
if !pergunte( "ESTMAQS2", .T. )
	return
else
	mv_par01 := PesqOp(mv_par01)
	if empty(mv_par01)
		Return
	endIf
endIf
lBalanca  := GetMV("MV_BALEXTR")
nHANDLE   := -1
/*cPORTABAL := "1"
cPORTAIMP := "2"*/
//cPORTABAL := "1"
cPORTAIMP := "1"
nTOLERA := Getmv( "MV_PESOTOL" )
nLIMITE := GetMv( "MV_LIMAXOP" )
nPVAROP := GetMv( "MV_PVAROP" )
cBuffer := ""//Código da máquina
nHandle := FOpen("C:\maquina.txt")		
FREAD( nHandle , @cBuffer , 8 )
FClose( nHandle )
cNome := iif( cBuffer == "E01", "EXTRUSORA 1", iif( cBuffer == "E02", "EXTRUSORA 2", "EXTRUSORA 3" ) )
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial Black",0,-27,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial Black",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 126,254,701,1049,"Extrusão",,,.F.,,,,,,.T.,,,.F. )
oTimer1    := TTimer():New( 1000,{||leOp(substr(mv_par01,1,6))}, oDlg1 )
oTimer1:Activate()
oBmp2      := TBitmap():New( 043,199,191,159,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp1      := TBitmap():New( 043,007,188,198,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay4      := TSay():New( 047,010,{||"ORDEM DE PRODUÇÃO DE EXTRUSÃO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,176,009)
oSay5      := TSay():New( 061,010,{||"OP DE EXTRUSÃO  Nº:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,061,008)
oSay6      := TSay():New( 071,010,{||"PRODUTO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 082,010,{||"Quant.(KG):"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 092,010,{||"DADOS TÉCNICOS"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,069,008)
oSay9      := TSay():New( 102,010,{||"FORMULAÇÃO"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay10     := TSay():New( 114,010,{||"oSay10"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,006)
oSay11     := TSay():New( 123,010,{||"oSay11"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay12     := TSay():New( 134,010,{||"oSay12"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 146,010,{||"Densidade"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
oSay14     := TSay():New( 159,010,{||"Tratado"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,033,008)
oSay15     := TSay():New( 171,010,{||"Slit"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 192,010,{||"LARGURA DO FILME"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,007)
oSay41     := TSay():New( 191,076,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,033,008)
oSay40     := TSay():New( 171,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay39     := TSay():New( 159,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 146,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay37     := TSay():New( 134,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay36     := TSay():New( 123,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay35     := TSay():New( 113,056,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay32     := TSay():New( 082,047,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay31     := TSay():New( 071,047,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay30     := TSay():New( 061,076,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBmp4      := TBitmap():New( 243,007,384,041,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay68     := TSay():New( 252,010,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay69     := TSay():New( 259,010,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay70     := TSay():New( 266,010,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay43     := TSay():New( 174,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay42     := TSay():New( 159,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay44     := TSay():New( 145,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay45     := TSay():New( 145,245,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay46     := TSay():New( 159,245,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay47     := TSay():New( 174,245,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay51     := TSay():New( 130,204,{||"Apara nº"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay50     := TSay():New( 100,206,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay49     := TSay():New( 087,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay48     := TSay():New( 073,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 058,205,{||"Bobina nº"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,033,008)
oSay26     := TSay():New( 058,246,{||"Peso Kg"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay52     := TSay():New( 073,246,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay53     := TSay():New( 087,246,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay54     := TSay():New( 100,246,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay55     := TSay():New( 130,245,{||"Peso Kg"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay59     := TSay():New( 130,284,{||"Hr Saída"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay58     := TSay():New( 100,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay57     := TSay():New( 087,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay56     := TSay():New( 073,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 058,284,{||"Hr Saída"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 058,322,{||"Data"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,022,008)
oSay60     := TSay():New( 073,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay61     := TSay():New( 087,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay62     := TSay():New( 100,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay63     := TSay():New( 130,321,{||"Data"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,022,008)
oSay67     := TSay():New( 130,352,{||"Extrusor"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay66     := TSay():New( 100,355,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay65     := TSay():New( 087,355,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay64     := TSay():New( 073,355,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 058,352,{||"Extrusor"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 047,203,{||"                 DADOS DE PRODUÇÃO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,178,011)
oSay72     := TSay():New( 245,010,{||"Próximas programações:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,006)
oSay75     := TSay():New( 273,010,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,375,008)
oSay33     := TSay():New( 202,010,{||"LARGURA DA BOBINA"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
oSay34     := TSay():New( 202,076,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,033,008)
oSay76     := TSay():New( 212,010,{||"ESPESSURA"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay77     := TSay():New( 212,076,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,033,008)
oSay78     := TSay():New( 222,010,{||"ALTURA DO PESCOÇO"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
oSay79     := TSay():New( 222,076,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,116,008)
oSay80     := TSay():New( 231,010,{||"PRODUÇÃO Kg/h"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay81     := TSay():New( 231,076,{||"oSay81"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,110,008)
oSay82     := TSay():New( 181,010,{||"DIMENSÕES"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,007)
oSay84     := TSay():New( 145,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay85     := TSay():New( 159,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay86     := TSay():New( 174,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay87     := TSay():New( 145,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay88     := TSay():New( 159,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay89     := TSay():New( 174,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay90     := TSay():New( 145,353,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay91     := TSay():New( 159,353,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay92     := TSay():New( 174,352,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay93     := TSay():New( 113,100,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay94     := TSay():New( 123,100,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay95     := TSay():New( 134,100,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay96     := TSay():New( 113,148,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay97     := TSay():New( 123,148,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay98     := TSay():New( 134,148,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBmp5      := TBitmap():New( 205,199,098,034,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay73     := TSay():New( 208,205,{||"Produzido nesta OP :"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,053,008)
oSay99     := TSay():New( 218,205,{||"Falta Produzir :"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,053,008)
oSay100    := TSay():New( 229,205,{||"Apara :"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,053,008)
oSay101    := TSay():New( 208,262,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay102    := TSay():New( 218,262,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay103    := TSay():New( 229,262,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay17     := TSay():New( 114,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 114,245,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 114,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 114,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 114,355,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 189,205,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 189,245,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay71     := TSay():New( 189,284,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay74     := TSay():New( 189,321,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay83     := TSay():New( 189,352,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBmp3   := TBitmap():New( 205,300,090,034,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay104 := TSay():New( 208,304,{||"Pesar OP     - F7"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,007)
oSay105 := TSay():New( 218,304,{||"Pesar Apara  - F8"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
oSay106 := TSay():New( 229,304,{||"Finalizar OP - F2"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
oGrp1      := TGroup():New( 004,007,040,391,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 013,012,{||cNome},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,018)
oSay2      := TSay():New( 014,202,{||dtoc(dDataBase)},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,018)
oSay3      := TSay():New( 014,301,{||substr(time(),1,5)},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,018)
SetKey(  VK_F12, { || salvaStop( dDataBase, time(), cBuffer), parada( "3", cBuffer) } )
//SetKey(  VK_F4,  { || oDlg1:End()                } )
/*SetKey(  VK_F7,  { || Pegar( cBuffer, mv_par01 ) } )Essas funções estão desativadas por não haver balanças para cada extrusora
SetKey(  VK_F8,  { || U_PESAPARA( mv_par01 )     } )*/
SetKey(  VK_F2,  { || cancOP( mv_par01 )         } )
leOP2(substr(mv_par01,1,6))
oDlg1:Activate(,,,.T.)

Return

***************

Static Function leOP( cOP )

***************
Local cQuery := cQuery1 := cQuery2 := ""
Local aProds := {}
Local nOrd   := 1
oSay2:cCaption := dtoc(dDataBase)
oSay3:cCaption := substr(time(),1,5)
cQuery := "SELECT top 4 Z00_PESO AS PESO, Z00_HORA, Z00_DATA, Z00_NOME, Z00_OP "
cQuery += "FROM "+retSqlName('Z00')+" Z00 "
cQuery += "WHERE Z00_APARA = '' AND "
cQuery += "Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ != '*' AND "
cQuery += "substring(Z00_MAQ,1,2) = 'E0' AND substring(Z00_OP,1,6) = '"+cOP+"' "
cQuery += "order by Z00_DATA desc, Z00_HORA desc "
TCQUERY cQuery NEW ALIAS "_TMPZ"
_TMPZ->( DbGoTop() )
do While ! _TMPZ->( EoF() )
	if nOrd == 1
		oSay48:cCaption := substr( _TMPZ->Z00_OP, 1, 6 )
		oSay52:cCaption := transform(_TMPZ->PESO, "@E 999,999.99")
		oSay56:cCaption := alltrim( _TMPZ->Z00_HORA )
		oSay60:cCaption := dtoc(stod(_TMPZ->Z00_DATA))
		oSay64:cCaption := alltrim(_TMPZ->Z00_NOME)
	elseIf nOrd == 2
		oSay49:cCaption := substr( _TMPZ->Z00_OP, 1, 6 )
		oSay53:cCaption := transform(_TMPZ->PESO, "@E 999,999.99")
		oSay57:cCaption := alltrim( _TMPZ->Z00_HORA )
		oSay61:cCaption := dtoc(stod(_TMPZ->Z00_DATA))
		oSay65:cCaption := alltrim(_TMPZ->Z00_NOME)		
	elseIf nOrd == 3
		oSay50:cCaption := substr( _TMPZ->Z00_OP, 1, 6 )
		oSay54:cCaption := transform(_TMPZ->PESO, "@E 999,999.99")
		oSay58:cCaption := alltrim( _TMPZ->Z00_HORA )
		oSay62:cCaption := dtoc(stod(_TMPZ->Z00_DATA))
		oSay66:cCaption := alltrim(_TMPZ->Z00_NOME)
	else
		oSay17:cCaption := substr( _TMPZ->Z00_OP, 1, 6 )
		oSay18:cCaption := transform(_TMPZ->PESO, "@E 999,999.99")
		oSay19:cCaption := alltrim( _TMPZ->Z00_HORA )
		oSay20:cCaption := dtoc(stod(_TMPZ->Z00_DATA))
		oSay21:cCaption := alltrim(_TMPZ->Z00_NOME)		
	endIf
	nOrd++
	_TMPZ->(dbSkip())
endDo
_TMPZ->(dbCloseArea())
nOrd := 1
cQuery1 := "SELECT top 4 Z00_PESO AS PESO, Z00_HORA, Z00_DATA, Z00_NOME, Z00_OP "
cQuery1 += "FROM "+retSqlName('Z00')+" Z00 "
cQuery1 += "WHERE Z00_APARA != '' AND "
cQuery1 += "Z00.Z00_FILIAL = '"+xFilial('Z00')+"' AND Z00.D_E_L_E_T_ != '*' AND "
cQuery1 += "substring(Z00_MAQ,1,2) = 'E0' AND substring(Z00_OP,1,6) = '"+cOP+"' "
cQuery1 += "order by Z00_DATA desc, Z00_HORA desc "
TCQUERY cQuery1 NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
do While ! _TMPK->( EoF() )
	if nOrd == 1
		oSay44:cCaption := substr( _TMPK->Z00_OP, 1, 6 )
		oSay45:cCaption := transform(_TMPK->PESO, "@E 999,999.99")
		oSay84:cCaption := alltrim( _TMPK->Z00_HORA )
		oSay87:cCaption := dtoc(stod(_TMPK->Z00_DATA))
		oSay90:cCaption := alltrim(_TMPK->Z00_NOME)
	elseIf nOrd == 2
		oSay42:cCaption := substr( _TMPK->Z00_OP, 1, 6 )
		oSay46:cCaption := transform(_TMPK->PESO, "@E 999,999.99")
		oSay85:cCaption := alltrim( _TMPK->Z00_HORA )
		oSay88:cCaption := dtoc(stod(_TMPK->Z00_DATA))
		oSay91:cCaption := alltrim(_TMPK->Z00_NOME)		
	elseIf nOrd == 3
		oSay43:cCaption := substr( _TMPK->Z00_OP, 1, 6 )
		oSay47:cCaption := transform(_TMPK->PESO, "@E 999,999.99")
		oSay86:cCaption := alltrim( _TMPK->Z00_HORA )
		oSay89:cCaption := dtoc(stod(_TMPK->Z00_DATA))
		oSay92:cCaption := alltrim(_TMPK->Z00_NOME)		
	else
		oSay22:cCaption := substr( _TMPK->Z00_OP, 1, 6 )
		oSay23:cCaption := transform(_TMPK->PESO, "@E 999,999.99")
		oSay71:cCaption := alltrim( _TMPK->Z00_HORA )
		oSay74:cCaption := dtoc(stod(_TMPK->Z00_DATA))
		oSay83:cCaption := alltrim(_TMPK->Z00_NOME)				
	endIf
	nOrd++
	_TMPK->(dbSkip())
endDo
_TMPK->(dbCloseArea())
//nOrd := 1

Return

***************

Static Function leOP2( cOP )

***************
Local cQuery := cQuery1 := cQuery2 := ""
Local aProds := {}
Local nOrd   := 1
/*Daqui para baixo deverá ser colocado em outro lugar para ser executado uma única vez*/
cQuery2 := "select SC2.C2_NUM,SC2.C2_PRODUTO,SB1.B1_COD, SB1.B1_DESC, SUBSTRING(B1_TITORIG,1,13) AS B1_TITORIG, SG1.G1_QUANT, "
cQuery2 += "SB1.B1_DENSMAT, SC2.C2_QUANT, SC2.C2_QUJE,SB5.B5_TIPO, SB5.B5_LARGFIL, SB5.B5_BOBLARG, SB5.B5_ESPESS, "
cQuery2 += "SB5.B5_TRATAM, SB5.B5_SLITEXT, SB5.B5_SANLAM2, SB5.B5_PTONEVE, SB5.B5_PTONEV2, SB5.B5_EXT3, "
cQuery2 += "SB5.B5_EXT2, SB5.B5_EXT1, SB5.B5_DENSIDA "
cQuery2 += "from "+retSqlName('SB1')+" SB1, "+retSqlName('SG1')+" SG1, "+retSqlName('SC2')+" SC2, "+retSqlName('SB5')+" SB5 "
cQuery2 += "where C2_NUM = '"+cOP+"' and substring(C2_PRODUTO,1,2) = 'PI' and SG1.G1_COD = SC2.C2_PRODUTO "
cQuery2 += "and SG1.G1_COMP = SB1.B1_COD and SB5.B5_COD = SG1.G1_COD "
cQuery2 += "and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SC2.D_E_L_E_T_ != '*' and SB5.D_E_L_E_T_ != '*' "
cQuery2 += "and SG1.G1_FILIAL   = '"+xFilial('SG1')+"'  and SB1.B1_FILIAL = '"+xFilial('SB1')+"'  and SC2.C2_FILIAL = '"+xFilial('SC2')+"' and SB5.B5_FILIAL = '"+xFilial('SB5')+"' "
cQuery2 += "order by SB1.B1_DESC desc "
TCQUERY cQuery2 NEW ALIAS "_TMPY"
_TMPY->( DbGoTop() )
oSay30:cCaption := transform(_TMPY->C2_NUM,"@E999999") //Nº da ordem de produção
oSay31:cCaption := _TMPY->C2_PRODUTO //Código do produto
oSay38:cCaption := transform(_TMPY->B5_DENSIDA,"@E 999,999,999.99")//Densidade
oSay39:cCaption := iif(_TMPY->B5_TRATAM  == 'S', 'SIM', 'NAO')//Tratado
oSay40:cCaption := iif(_TMPY->B5_SLITEXT == 'S', 'SIM', 'NAO')//Slit
oSay32:cCaption := transform(_TMPY->G1_QUANT,  "@E 999,999,999.99") //Quantidade para produzir
oSay41:cCaption := transform(_TMPY->B5_LARGFIL,"@E 999,999,999.99") //Largura do filme
oSay34:cCaption := transform(_TMPY->B5_BOBLARG,"@E 999,999,999.99") //Largura da bobina
oSay77:cCaption := transform(_TMPY->B5_ESPESS ,"@E 999,999,999.99") //Espessura
oSay79:cCaption := alltrim(_TMPY->B5_PTONEVE) + " / " + alltrim(_TMPY->B5_PTONEV2)    //Altura do pescoço
oSay81:cCaption := transform(_TMPY->B5_EXT1,"@E 999,999.99") + " / " + transform(_TMPY->B5_EXT2,"@E 999,999.99") +;
                   " / " + transform(_TMPY->B5_EXT3,"@E 999,999.99")//Produção por hora
oSay101:cCaption := transform(_TMPY->C2_QUJE,  "@E 999,999,999.99")
oSay102:cCaption := transform(_TMPY->C2_QUANT - _TMPY->C2_QUJE,  "@E 999,999,999.99")
oSay103:cCaption := transform( apara(_TMPY->C2_NUM), "@E 999,999,999.99" )
do While !_TMPY->( EoF() )
	if nOrd == 1
		oSay10:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay35:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	elseIf nOrd == 2
		oSay11:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay36:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	elseIf nOrd == 3
		oSay12:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay37:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	elseIf nOrd == 4
		oSay93:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay96:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	elseIf nOrd == 5
		oSay94:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay97:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	else
		oSay95:cCaption := alltrim(_TMPY->B1_TITORIG)
		oSay98:cCaption := transform(_TMPY->G1_QUANT,"@E 999,999.99")
	endIf
	nOrd++
	_TMPY->( dbSkip() )
endDo                   
_TMPY->( DbCloseArea() )

Return

***************

Static Function apara(cOP)

***************
Local cQuery := ""
Local nRet   := 0
cQuery := "SELECT sum( Z00_PESO ) AS PESO "
cQuery += "FROM "+retSqlName('Z00')+" Z00 "
cQuery += "WHERE substring(Z00_MAQ,1,2) = 'E0' AND substring(Z00_OP,1,6) = '"+alltrim(cOP)+"' AND Z00_APARA <> '' AND "
cQuery += "Z00.Z00_FILIAL = '"+xFilial('Z00')+"' AND Z00.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPP"
_TMPP->( dbGoTop() )

do While ! _TMPP->( EoF() )
	nRet := _TMPP->PESO
	_TMPP->( dbSkip() )
endDo
_TMPP->( dbCloseArea() )

return nRet

***************

Static Function parada(cParada,cMaq)

***************
Local lCor := .T.
Local cMaquina := iif(cMaq == 'C01', "Corte e Solda 1", iif(cMaq == 'C02', "Corte e Solda 2",;
                  iif(cMaq == 'C03', "Corte e Solda 3", iif(cMaq == 'C04', "Corte e Solda 4",;
                  iif(cMaq == 'C05', "Corte e Solda 5", iif(cMaq == 'C06', "Corte e Solda 6",;
                  iif(cMaq == 'P01', "Picotadeira 1"  , iif(cMaq == 'P02', "Picotadeira 2"  ,;
                  iif(cMaq == 'P03', "Picotadeira 3"  , iif(cMaq == 'P04', "Picotadeira 4"  ,;
                  iif(cMaq == 'P05', "Picotadeira 5"  , iif(cMaq == 'S01', "Solda 1", "Máquina indefinida" ) ) ) ) ) ) ) ) ) ) ) )
Private nParada := '0'
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont_1","oFont_2","oFont_3","oFont_4","oTimer_1","oTimer_2","oFont_5","oDlg_1","oBmp_1","oBmp_2","oBmp_3")
SetPrvt("oSay_1","oSay_2","oSay_3","oMGet_1","oBmp_4","oSay_4","oSay_5","oSay_6","GoRMenu_1","oRMenu_1")
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
cTexto   := ""//msmm(Z39->Z39_MEMO1)
oFont_1  := TFont():New("Arial Black",0,-40,,.T.,0,,700,.F.,.F.,,,,,,)
oFont_2  := TFont():New("Arial Black",0,-40,,.T.,0,,700,.F.,.F.,,,,,,)
oFont_3  := TFont():New("Arial Black",0,-15,,.T.,0,,700,.F.,.F.,,,,,,)
oFont_4  := TFont():New("Arial Black",0,-75,,.T.,0,,700,.F.,.F.,,,,,,)
oFont_5  := TFont():New("Arial",0,-13,,.T.,0,,700,.F.,.F.,,,,,,)
oFont_6  := TFont():New("Arial",0,-22,,.T.,0,,700,.F.,.F.,,,,,,)
oDlg_1   := MSDialog():New( 126,254,701,1049,"Máquina Parada ! ! !",,,.F.,,,,,,.T.,,,.F.)
oTimer_1 := TTimer():New( 60000,{|| iif(lCor, {|| oSay_1:nClrText := CLR_HBLUE, lCor := .F.},;
{|| oSay_1:nClrText := CLR_HRED,  lCor := .T.})},oDlg_1)
oTimer_1:Activate()
oTimer_2 := TTimer():New( 1000,{ || oSay_3:cCaption := Tempo( Z39->Z39_DATA,Z39->Z39_HORA,;
                                                              dDataBase,time() ) }, oDlg_1)
oTimer_2:Activate()
oBmp_1   := TBitmap():New( 005,004,388,043,,"",.F.,oDlg_1,,,.F.,.T.,,"",.T.,,.T.,,.F.)
oBmp_2   := TBitmap():New( 052,201,191,231,,"",.F.,oDlg_1,,,.F.,.T.,,"",.T.,,.T.,,.F.)
oBmp_3   := TBitmap():New( 052,004,191,231,,"",.F.,oDlg_1,,,.F.,.T.,,"",.T.,,.T.,,.F.)
oSay_1   := TSay():New( 007,089,{||"Máquina Parada ! ! !"},oDlg_1,,oFont_1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,218,024)
oSay_2   := TSay():New( 033,140,{||cMaquina},oDlg_1,,oFont_3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,115,011)
oSay_3   := TSay():New( 131,208,{||"00:00:00"},oDlg_1,,oFont_4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,177,072)
/*oMGet_1  := TMultiGet():New( 068,008,{|u| If(PCount()>0,cTexto:=u,cTexto)},;
                             oDlg_1,182,171,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,)
oMGet_1:bSetGet := {|u| If(PCount()>0,cTexto:=u,cTexto)}*/
//oBmp_4   := TBitmap():New( 248,004,191,034,,"",.F.,oDlg_1,,,.F.,.T.,,"",.T.,,.T.,,.F.)
oSay_4   := TSay():New( 060,015,{||"Funções :"},oDlg_1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay_5   := TSay():New( 080,015,{||"F5  - Troca de Tela"},      oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_6   := TSay():New( 100,015,{||"F6  - Queda de Energia"},   oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_7   := TSay():New( 120,015,{||"F7  - Furo de Balão" },     oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_8   := TSay():New( 140,015,{||"F8  - Limpeza Mensal"},     oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_9   := TSay():New( 160,015,{||"F9  - Manutenção Elétrica"},oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_10  := TSay():New( 180,015,{||"F10 - Pesar Bobina"},       oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)
oSay_11  := TSay():New( 200,015,{||"F11 - Pesar Apara" },       oDlg_1,,oFont_6,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,015)

/*oCBox_1  := TComboBox():New( 056,008,,{"Troca de Tela","Queda de Energia","Furo de Balão","Limpeza Mensal","Manutenção Elétrica",;
                                       "Pesar Bobina","Pesar Apara"},182,010,oDlg_1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",;
                                       ,,,,,,"nParada" )
oCBox_1:bSetGet := {|u| If(PCount()>0,nParada:=u,nParada)}*/

SetKey( VK_F5,  { || fechaStop( cMaq, "1" ), oDlg_1:end() } )
SetKey( VK_F6,  { || fechaStop( cMaq, "2" ), oDlg_1:end() } )
SetKey( VK_F7,  { || fechaStop( cMaq, "3" ), oDlg_1:end() } )
SetKey( VK_F8,  { || fechaStop( cMaq, "4" ), oDlg_1:end() } )
SetKey( VK_F9,  { || fechaStop( cMaq, "5" ), oDlg_1:end() } )
SetKey( VK_F10, { || fechaStop( cMaq, "6" ), oDlg_1:end() } )
SetKey( VK_F11, { || fechaStop( cMaq, "7" ), oDlg_1:end() } )
SetKey( VK_F12, { ||  } )

oDlg_1:Activate(,,,.T.)

Return setaFunc()

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Tempo( dFecha1, cHora1, dFecha2, cHora2 )
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static function Tempo( dFecha1,cHora1,dFecha2,cHora2 )

Local nDias, nHorasp, nMinutp, nSegunp, nHorasa, nMinuta, nSeguna, nHoras, nMinuto, nSegundo

// Controle de parametros opcionais
if cHora1 = nil .OR. empty( cHora1 )
	cHora1 := "00:00:00"
endif

if dFecha2 = NIL .OR. EMPTY( dFecha2 )
	dFecha2 := DATE()
endif

if cHora2 = NIL .OR. EMPTY( cHora2 )
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

***************

Static Function setaFunc()

***************	
	SetKey(  VK_F5,  { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F6,  { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F7,  { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F8,  { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F9,  { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F10, { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F11, { || msgAlert("Função Indefinida!") } )
	SetKey(  VK_F12, { || salvaStop( dDataBase, time(), cBuffer), parada( "3", cBuffer) } )		
return

***************

Static Function salvaStop( dData, cHora, cMaq )

***************
	Z39->( dbSetOrder(6) )
	if Z39->( dbSeek( xFilial("Z39") + cMaq + substr(cUsuario, 7, 14 ) + space(8),.F. ) )
		msgAlert("Parada não fechada!")
		return
	endIf
	RecLock( "Z39", .T. )
	Z39->Z39_FILIAL := xFilial("Z39")
	Z39->Z39_CODMAQ := cMaq
	Z39->Z39_USUARI := substr(cUsuario, 7, 14 )
	Z39->Z39_DATA   := dData
	Z39->Z39_HORA   := cHora
	Z39->( msUnlock() )
return

***************

Static Function fechaStop( cMaq, cTipo )

***************
	/*if empty(cTexto)
		msgAlert("A justificativa por escrito está em branco, favor preencher!")
		return .F.
	endIf*/
	Z39->( dbSetOrder(6) )
	if !Z39->( dbSeek( xFilial("Z39") + cMaq + substr(cUsuario, 7, 14 ) + space(8),.F. ) )
		msgAlert("Erro no fechamento! Esta parada já foi encerrada anteriormente.")
		return .F.
	endIf
	RecLock( "Z39", .F. )
	Z39->Z39_DATAF := dDataBase
	Z39->Z39_HORAF := time()
	Z39->Z39_TIPO  := cTipo
	MSMM(,,,cTexto,1,,,'Z39','Z39_MEMO1')
	Z39->( msUnlock() )
Return .T.

/********************************************
* Início do trecho para a manipulação da OP *
*********************************************/
***************

Static Function Pegar( cMaq, cOP )

***************

Local nVal1    := nVal2 := nTara := nPeso := 0
Local cUsulim  := cEmbalad := ""
lEncerra       := .T.
aUSUARIO := u_senha2( "04", 1, "Operador da maquina" )
If ! aUSUARIO[ 1 ]
	Return NIL
EndIf

cEMBALAD := aUSUARIO[ 2 ]

if lBalanca
	/**/
	nTara := taraTub()
	Do Case
		Case nTara == 2
			nTara	:= 2.05
		Case nTara == 3
			nTara	:= 2.70
		Case nTara == 4
			nTara	:= 2.55
		Case nTara == 5
			nTara	:= 3.30
		Case nTara == 6
			nTara	:= 4.45
		Case nTara == 7
			nTara	:= 4.40
		Case nTara == 8
			nTara	:= 5.40
		Case nTara == 9
			nTara	:= 5.50
		Case nTara == 10
			nTara	:= 6.40
		Case nTara == 11
			nTara	:= 7.90
		Case nTara == 12
			nTara	:= 10.50
		OtherWise
	    	msgAlert("Escolha a tara do tubete! ! !")
	    	return Pegar()
	endCase	
	/**/
	cDLL     := "toledo9091.dll"
	nHandle  := ExecInDllOpen( cDLL )
	if nHandle = -1
		MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
		Return NIL
	EndIf
	// Parametro 1 = Porta serial do indicador
	cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
	//cRETDLL := '60'
	nPESO := Val( Strtran( cRETDLL, ",", "." ) ) - nTara
	ExecInDLLClose( nHandle )
else
	nPeso := PesaMan()
endif

If nPESO <= 0 .or. Empty( cOP )
	MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
	Return NIL
EndIf
if !mostraKG(nPeso,cOP)
	msgAlert("Pesagem de bobina cancelada!")
	return
endIf
cUSULIM := ""

cQuery := "SELECT Sum( Z00_PESO ) AS PESO "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"
If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) < Z00X->PESO + nPESO
   If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT ) ) + " - " + ;
    AllTrim( Str( SC2->C2_QUJE + Z00X->PESO + nPESO ) ) + "). Confirma?" ), "Escolha", "YESNO" )
      Z00X->( DbCloseArea() )                                                                        
      Return NIL
   EndIf
   aUSUARIO := u_senha2( "03",, "Liberar quantidade da OP" )
   If ! aUSUARIO[1]
      Z00X->( DbCloseArea() )
      Return NIL
   EndIf
   /**/
   lEncerra := .T.
   nVal1 := (SC2->C2_QUANT - SC2->C2_QUJE)  + ( nLIMITE * SC2->C2_QUANT / 100 )
   nVal2 := Z00X->PESO + nPESO
   /**/
   cUSULIM  := aUSUARIO[2]
   aUSUARIO := {}
EndIf
Z00X->( DbCloseArea() )
If Producao( cOP, nPeso, cUsulim )//Producao()
   Grava( cOP, nPeso, cMaq, cUsulim, cEmbalad )//Grava()
   //Atualiza()
   if lBalanca
      Msgbox( "Bobina inserida com sucesso!  Tecle <SAIDA> na balanca para imprimir etiqueta.", "Mensagem", "info" )
   endif
   /**/
   //if lEncerra
	 if nVal1 < nVal2
   	lEncerra := .F.
   endIf
   /**/
Else
   MsgAlert( "Erro na inclusao desta bobina no estoque (" + AllTrim( SC2->C2_PRODUTO ) + ")" )
EndIf
nPESO := 0

Return NIL

***************

Static Function Grava(cOP,nPeso,cMaq,cUsulim,cEmbalad)

***************
Local cSEQ := ""
cSEQ := ProxSeq()
RecLock( "Z00", .T. )
Z00->Z00_SEQ    := cSEQ
Z00->Z00_OP     := cOP
Z00->Z00_PESO   := nPESO
Z00->Z00_MAQ    := cMAQ
Z00->Z00_DATA   := Date()
Z00->Z00_HORA   := Left( Time(), 5 )
Z00->Z00_USULIM := cUSULIM
Z00->Z00_BAIXA  := "S"                                                                                                  
Z00->Z00_NOME   := cEMBALAD //Voltou a ser gravado em 19/11/07 a pedido de lindenberg, não se sabe pq não gravava mais (desde mês 08 de 2006)
nORD := SD3->( Indexord() )
SD3->( DbSetOrder( 4 ) )
SD3->( DbGobottom() )
SD3->( DbSetOrder( nORD ) )
Z00->Z00_DOC := SD3->D3_DOC
Z00->( MsUnlock() )
ConfirmSX8()
Z00->( DbCommit() )
If SC2->C2_RECURSO <> cMAQ
	RecLock( "SC2", .F. )
	SC2->C2_RECURSO := cMAQ
	SC2->( MsUnlock() )
	SC2->( DbCommit() )
EndIf

Return NIL

***************

Static Function Producao(cOP,nPeso,cUSULIM)

***************

Local aMATRIZ := {}

lMsErroAuto := .F.

aMATRIZ := { { "D3_OP",      cOP,                NIL },;
			 { "D3_COD",     SC2->C2_PRODUTO,    NIL },;
			 { "D3_EMISSAO", Date(),             NIL },;
			 { "D3_QUANT",   nPESO,              NIL },;
			 { "D3_USULIM",  cUSULIM,            NIL },;
			 { "D3_PARCTOT", "P",                NIL } }

Begin Transaction
	MSExecAuto( { | x | MATA250( x ) }, aMATRIZ )
	IF lMsErroAuto
		DisarmTransaction()
		Break
	Endif
End Transaction
Return ! lMSErroAuto

***************

Static Function PesqOp(cOP)

***************

lRET := .T.

If Len( AllTrim( cOP ) ) < 6
  MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
  return ''
Endif
If Len( AllTrim( cOP ) ) < 11
   SC2->( DbSeek( xFilial( "SC2" ) + Left( cOP, 6 ), .T. ) )
   Do While SC2->C2_NUM == Left( cOP, 6 )
      If Left( SC2->C2_PRODUTO, 2 ) == 'PI' .and. SC2->C2_SEQPAI $ '   *001'
         cOP := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
         Exit
      EndIf
      SC2->( DbSkip() )
   EndDo
   If SC2->C2_NUM <> Left( cOP, 6 )
      MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
      return ''
   Endif
Endif
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	return ''
Else
	If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
		If ! SB1->B1_TIPO $ "PI"
			MsgAlert( OemToAnsi( "Esta OP nao‚ de bobina" ) )
			return ''
		EndIf
	Else
		MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
		return ''
	EndIf
	If lRET .and. ! Empty( SC2->C2_DATRF )
		MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
		return ''
	EndIf
EndIf
If lRET
	If ! Empty( SC2->C2_RECURSO )
		cMAQ := SC2->C2_RECURSO
	EndIf
EndIf
Return cOP

***************

Static Function PesqMaq()

***************

lRET := .T.

If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	lRET := .F.
EndIf
If lRET
	If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
     lRET := u_senha2( "02",, "Alteracao de Maquina" )[ 1 ]
	EndIf
EndIf

Return lRET

/*FUNÇÃO ABAIXO SEM UTILIDADE*/
***************

Static Function ATUALIZA()

***************

dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )
oDlg1:cCaption := "Situacao atual da producao de extrusoras - Dia: " + Dtoc( dDIA )
If xMV_PAR01 == 1
 	If ! Empty( xMV_PAR02 )
 		 Mostra( xMV_PAR02, "01" )
 	Endif
 	If ! Empty( xMV_PAR03 )
 		 Mostra( xMV_PAR03, "02" )
 	Endif
 	If ! Empty( xMV_PAR04 )
 		 Mostra( xMV_PAR04, "03" )
 	Endif
EndIf
Return NIL
/*FUNÇÃO ACIMA SEM UTILIDADE*/

/*FUNÇÃO ABAIXO SEM UTILIDADE*/
***************

Static Function Mostra( cMAQ, cNUM )

***************

SB1->( DbSetOrder( 1 ) )
SC2->( DbSetOrder( 1 ) )
cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( Date() ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + cMAQ + "' AND Z00.Z00_APARA = ' ' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )
TCQUERY cQUERY NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )
Z00X->( DbGotop() )
nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
nTURNO1   := nTURNO2   := nTURNO3   := 0
nPRODDKG  := 0
cOP       := Space( 11 )
Do While ! Z00X->( Eof() )
   SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
   SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	 If Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		 nTURNO1KG += Z00X->Z00_PESO
		 nPRODDKG  += Z00X->Z00_PESO
	 ElseIf Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		 nTURNO2KG += Z00X->Z00_PESO
		 nPRODDKG  += Z00X->Z00_PESO
	 ElseIf ( Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( Z00X->Z00_DATA == dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		nTURNO3KG += Z00X->Z00_PESO
		nPRODDKG  += Z00X->Z00_PESO
	 EndIf
	 cOP := Z00X->Z00_OP
	 Z00X->( DbSkip() )
EndDo
Z00X->( DbCloseArea() )
If ! Empty( cOP )
	cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT,Sum( Z00_PESO + Z00_PESCAP ) AS PESO "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND "
	cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "Z00X"
	SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	oOP&cNUM:cCaption      := Left( cOP, 6 )
	oPROGKG&cNUM:cCaption  := Trans( SC2->C2_QUANT / ( 1 + ( nPVarOp / 100 ) ), "@E 999999.99" )
	oPRODKG&cNUM:cCaption  := Trans( Z00X->PESO, "@E 999999.99" )
	oPROD&cNUM:cCaption    := SC2->C2_PRODUTO
	oDESCR1&cNUM:cCaption  := Left( SB1->B1_DESC, 29 )
	oDESCR2&cNUM:cCaption  := SubStr( SB1->B1_DESC, 30, 20 )
	Z00X->( DbCloseArea() )
EndIf
oMAQ&cNUM:cCaption     := cMAQ
oTURN1KG&cNUM:cCaption := Trans( nTURNO1KG, "@E 999999.99" )
oTURN2KG&cNUM:cCaption := Trans( nTURNO2KG, "@E 999999.99" )
oTURN3KG&cNUM:cCaption := Trans( nTURNO3KG, "@E 999999.99" )
oPRODDKG&cNUM:cCaption := Trans( nPRODDKG,  "@E 999999.99" )

Return NIL
/*FUNÇÃO ACIMA SEM UTILIDADE*/

***************

Static Function PROXSEQ()

***************
Local cSeq := ""
cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo

Return cSEQ

***************

Static Function ValidPerg()

***************

PutSx1( "MONMQ2", '01', 'Setor              ?', '', '', 'mv_ch1', 'N', 01, 0, 0, 'G', '', ''   , '', '', 'mv_par01', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '02', 'Maquina 1 Setor 1  ?', '', '', 'mv_ch2', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '03', 'Maquina 2 Setor 1  ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '04', 'Maquina 3 Setor 1  ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )

Return NIL

***************

Static Function endOP( cOPx )

***************
/*
Obs.: O SD3 já chega posicionado no registro que deve ser alterado.
*/
Local lMsErroAuto := .F.
Local aMata250 := {}
Local nRec := SD3->( recno() )
Local nIdx := SD3->( indexOrd() )
//dbSelectArea('SD3')
SD3->( dbSetOrder(1) )

if ! SD3->( dbSeek( xFilial('SD3') + padr(alltrim(cOPx),13) + SC2->C2_PRODUTO, .T. ) )
	msgbox( "Impossível encontrar a OP "+ alltrim(cOPx) +"!" )
	msgbox( "ENCERRAMENTO ABORTADO ! ! !" )
	SD3->( dbGoTo( nRec ) )
	SD3->( dbSetOrder( nIdx ) )
	Return
endIf
msgBox("A OP "+cOPx+" foi encerrada com sucesso!")
Private l250Auto := .T.
Private lIntQual := .F.
Private LPERDINF := .T. 
Private mv_par03 := 2
Private dDataFec := getMV('MV_ULMES')
Private LDELOPSC := getMV('MV_DELOPSC') == 'S'
Private LPRODAUT := getMV('MV_PRODAUT')

A250Encer('SD3', SD3->( recno() ), 5 )

SD3->( dbGoTo( nRec ) )
SD3->( dbSetOrder( nIdx ) )

Return

***************

Static Function  cancOP( cOP )

***************
Local cQuery := "select * from "+retSqlName('SB1')+" where B1_FILIAL = '"+xFilial('SB1')+"' "
	  cQuery += "and B1_COD = '"+SC2->C2_PRODUTO+"' and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPZ"
_TMPZ->( dbGoTop() )
if  _TMPZ->( EoF() )
	_TMPZ->( dbCloseArea() )
	msgAlert("O encerramento da OP foi abortado, pois não foi encontrado o cadastro do produto "+alltrim(SC2->C2_PRODUTO)+".")
	Return
endIf
if MsgBox( OemToAnsi( "Deseja encerrar a OP :"+alltrim(cOP)+" ("+alltrim(SB1->B1_DESC)+") " ),"Escolha", "YESNO" )
	endOP( cOP )
endIf
_TMPZ->( dbCloseArea() )
/*26/01/09 O seek no b1 não está funcionando, não tenho idéia porque*/
/*dbSelectArea('SB1')
if !SB1->( dbSeek( xFilial('SB1') + SC2->C2_PRODUTO ), .F. )

endIf
if MsgBox( OemToAnsi( "Deseja encerrar a OP :"+alltrim(cOP)+" ("+alltrim(SB1->B1_DESC)+") " ),"Escolha", "YESNO" )
	endOP( cOP )
endIf*/
//Atualiza()
Return

***************

Static Function taraTub()

***************

local oDlg1,oCBox1,oGrp1,oSBtn1,oSBtn2
local nAt := 0
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 139,330,352,682,"Tara dos tubetes",,,,,,,,,.T.,,, )
oCBox1     := TComboBox():New( 028,049,,{"","40 - 2,05  kg","40 - 2,70  kg","50 - 2,55  kg","65 - 3,30  kg","65 - 4,45  kg","80 - 4,40  kg","80 - 5,40  kg","100- 5,50  kg","126- 6,40  kg","156- 7,90  kg","156- 10,50 kg"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oGrp1      := TGroup():New( 004,004,092,168,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBtn1     := SButton():New( 064,040,1,{ || nAt := oCBox1:nAt, oDlg1:End() },oGrp1,,"", )
oSBtn2     := SButton():New( 064,108,2,{ || nAt := 0         , oDlg1:End() },oGrp1,,"", )

oDlg1:Activate(,,,.T.)

Return nAt

***************

Static Function fPesqOp(cOP)

***************

Local lRET := .T.
Local cMaq := ""

If Len( AllTrim( cOP ) ) < 6
  MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
  Return .F.
Endif
If Len( AllTrim( cOP ) ) < 11
   SC2->( DbSeek( xFilial( "SC2" ) + Left( cOP, 6 ), .T. ) )
   Do While SC2->C2_NUM == Left( cOP, 6 )
      If Left( SC2->C2_PRODUTO, 2 ) == 'PI' .and. SC2->C2_SEQPAI $ '   *001'
         cOP := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
         Exit
      EndIf
      SC2->( DbSkip() )
   EndDo
   If SC2->C2_NUM <> Left( cOP, 6 )
      MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
      Return ''
   Endif
Endif
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	Return ''
Else
	If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
		If ! SB1->B1_TIPO $ "PI"
			MsgAlert( OemToAnsi( "Esta OP nao‚ de bobina" ) )
			Return ''
		EndIf
	Else
		MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
		Return ''
	EndIf
	If lRET .and. ! Empty( SC2->C2_DATRF )
		MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
		Return ''
	EndIf
EndIf
If lRET
	If ! Empty( SC2->C2_RECURSO )
		cMAQ := SC2->C2_RECURSO
	EndIf
EndIf
Return cOP
/*****************************************
* Fim do trecho para a manipulação da OP *
*****************************************/

***************

Static Function mostraKG( nPeso, cOP )

***************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local oFont1,oFont2,oDlg1,oGrp1,oSay1,oSay2,oBtn1,oBtn2
Local lRet := .F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1 := TFont():New( "Arial Black",0,-67,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2 := TFont():New( "Arial Black",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1  := MSDialog():New( 193,297,457,826,"Pesar Bobina",,,.F.,,,,,,.T.,,,.F. )
oGrp1  := TGroup():New( 003,004,126,259,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1  := TSay():New( 019,026,{|| transform( nPeso, "@E 999,999.99" ) },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,218,045)
oSay2  := TSay():New( 076,026,{||"PI01201 - BOBINA P/ HAMBURGUER 72 (18X18 )"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,218,014)
oBtn1  := TButton():New( 104,080,"&Pesar !",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || lRet := .T., oDlg1:end() }
oBtn2  := TButton():New( 104,144,"&Cancelar !",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || lRet := .F., oDlg1:end() }
oDlg1:Activate(,,,.T.)

Return lRet