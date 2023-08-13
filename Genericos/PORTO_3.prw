#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCPE()    บ Autor ณ MP8 IDE            บ Data ณ  22/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Registro de controle da produ็ใo e do estoque, modelo 3.   บฑฑ
ฑฑบ          ณ Relat๓rio solicitado por Porto.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RCPE3()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Registro de Controle da Produ็ใo e do Estoque"
Local cPict          := ""
Local titulo       	 := "Registro de Controle da Producao e do Estoque"
Local nLin         	 := 80

Local Cabec1       	 := "                                                                                            REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 		 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "RCPE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt     	 := Space(10)
Private cbcont     	 := 00
Private CONTFL    	 := 01
Private m_pag     	 := 01
Private wnrel     	 := "PORTO" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""
Private cCodigs		 := "'AAA044','AAA045','AAA062','AAA134',"+;
"'AAA137','AAA145','AAAR062','AAAR145','AAB044','AAB147','AABR044','AAC004','AAC042','AAC043','AAC060','AAC133',"+;
"'AAC136','AAC146','AAC241','AACR042','AACR060','AACR146','AC0001','AC0002','AC0003','ADA011','ADA110','ADA143',"+;
"'ADA144','ADA244','ADA283','ADAR011','ADAR110','ADAR143','ADAR144','ADAR283','ADB012','ADB144','ADB146','ADBR144',"+;
"'ADBR146','ADC010','ADC016','ADC108','ADC142','ADC145','ADC150','ADC182','ADC243','ADC245','ADC282','ADCR010',"+;
"'ADCR016','ADCR108','ADCR142','ADCR145','ADCR243','ADCR282','ADFA0635','ADFA1663','ADFB1665','ADFC1664','AFA035',"+;
"'AFA163','AFAR035','AFAR163','AFB036','AFB165','AFBR036','AFBR165','AFC034','AFC164','AFCR034','AFCR164','AHA038',"+;
"'AHA121','AHAR038','AHAR121','AHB039','AHB122','AHBR039','AHBR122','AHC037','AHC120','AHCR037','AHCR120','AJA041',"+;
"'AJA151','AJAR151','AJB042','AJC040','AJC150','AJCR040','AJCR150','BDA174','BDC173','BDC174','BDC274','BDL170','BEA177',"+;
"'BGA180','BGC179','BGC184','BGC284','BIA183','BIC182','BIC183','BIC184','BIC284','BKA186','BKC185','BKC285','CAA001',"+;
"'CAB001','CAB131','CAB231','CAB333','CAB420','CAB430','CAB431','CAB433','CAB604','CAB610','CAB634','CAB643','CAB655',"+;
"'CAD001','CAD004','CAD011','CAD231','CAD430','CAE001','CAE003','CAF001','CAF003','CDB001','CDB004','CDB114','CDB124',"+;
"'CDB314','CDB498','CDB499','CDB603','CDB630','CDB641','CDB703','CDD002','CDD499','CDD699','CEB119','CEB129','CEB130',"+;
"'CEB319','CEB629','CED136','CGB001','CGB105','CGB115','CGB125','CGB315','CGB452','CGB453','CGB602','CGB639','CGB802',"+;
"'CGD002','CGD453','CIB001','CIB004','CIB106','CIB116','CIB126','CIB316','CIB432','CIB433','CIB601','CIB632','CIB801',"+;
"'CID432','CID433','CID645','CKB001','CKB107','CKB117','CKB127','CKB317','CKB417','CKB418','CKB600','CKB610','CKB633',"+;
"'CKD002','CKD418','CTG006','CTG007','CTG008','CTG010','DDA019','DDA196','DDA601','DDAR021','DDAR023','DDAR190','DDAR196',"+;
"'DDAR605','DDC264','DDCR196','DGA013','DGA198','DGA602','DGAR015','DGAR017','DGAR191','DGAR198','DGAR606','DGCR191',"+;
"'DGCR198','DIA007','DIA199','DIA603','DIAR009','DIAR011','DIAR192','DIAR199','DIAR607','DICR199','DKA001','DKA200',"+;
"'DKA604','DKAR003','DKAR005','DKAR193','DKAR200','DKAR608','DKB001','DKCR200','EAA049','EAA288','EAAR051','EAAR053',"+;
"'EAAR288','EAC050','EAC289','EACR052','EDA043','EDA233','EDAR045','EDAR047','EDAR133','EDAR233','EDC044','EDC056',"+;
"'EDC214','EDC218','EDC604','EDCR046','EDCR048','EGA037','EGA234','EGAR039','EGAR041','EGAR134','EGAR234','EGC038',"+;
"'EGC055','EGC215','EGC217','EGC602','EGCR040','EIA031','EIA235','EIAR033','EIAR035','EIAR135','EIAR235','EIC032',"+;
"'EIC216','EIC601','EICR034','EKA025','EKA236','EKAR027','EKAR029','EKAR136','EKAR236','EKC026','EKC217','EKC600',"+;
"'EKCR028','GUB290','JYB211','ME0101','ME0103','ME0106','ME0205','ME0207','ME0208','ME0209','ME0211','ME0212','ME0213',"+;
"'ME0214','ME0501','ME0502','ME0503','ME0504','ME0505','ME0506','ME0507','ME0508','ME0522','ME0523','ME0524','ME0525',"+;
"'ME0526','ME0527','ME0528','ME0531','ME0537','ME0539','ME0540','ME0541','ME0542','ME0550','ME0551','ME0552','ME0554',"+;
"'ME0556','ME0603','ME0605','ME0606','ME0607','ME0608','ME0609','ME0611','ME0612','ME0617','ME0619','ME0620','ME0621',"+;
"'ME0622','ME0623','ME0624','ME0626','ME0628','ME0629','ME0631','ME0636','ME0637','ME0639','ME0640','ME0641','ME0700',"+;
"'ME0701','ME0702','ME0703','ME0704','ME0705','ME0706','ME0707','ME0708','ME0709','ME0710','ME0711','ME0712','ME0713',"+;
"'ME0714','ME0715','ME0716','ME0717','ME0718','ME0719','ME0720','ME0721','ME0722','ME0723','ME0724','ME0725','ME0726',"+;
"'ME0727','ME0728','ME0729','ME0730','ME0731','ME0732','ME0733','ME0800','ME0801','ME0802','ME0803','ME0804','ME0805',"+;
"'ME0807','ME0809','ME0810','MP0102','MP0104','MP0105','MP0106','MP0110','MP0202','MP0204','MP0206','MP0207','MP0208',"+;
"'MP0211','MP0222','MP0223','MP0401','MP0402','MP0403','MP0404','MP0406','MP0413','MP0605','MP0606','MP0607','MP0608',"+;
"'MP0611','MP0614','MP0620','MP0623','MP0636','MP0637','PI01701','PI01801','PI01804','PI02003','PI02202','PI02204',"+;
"'PI02902','PI03203','PI03601','PI03603','PI03903','PI04204','PI04415','PI04418','PI04760','PI04761','PI04785',"+;
"'PI04792','PI04794','PI04795','PI04797','PI04798','PI05301','PI05710','PI05762','PI05764','PI05765','PI05802',"+;
"'PI05924','PI05925','PI05982','PI05984','PI05999','PI06052','PI06077','PI06082','PI06083','PI06085','PI06090'"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  22/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************


Local cCodAnt  := cMes := " "
Local nEstoque := nTotSai := nTotEnt := 0
Local _aStru := {}
Local _cTemp
Local nLin := 80

Private cNumOp01 := '10131108325'
Private cNumOp02 := '10131110450'
Private cNumOp03 := '10131122548'
Private cNumOp04 := '10131133244'
Private cNumOp05 := '10131142547'
Private cNumOp06 := '10131155287'
Private cNumOp07 := '10131161247'
Private cNumOp08 := '10131168500'
Private cNumOp09 := '10131171574'
Private cNumOp10 := '10131181109'
Private cNumOp11 := '10131190026'
Private cNumOp12 := '10131201215'

aadd( _aStru , {"DOC"       , "C" , 06 , 00 } )
aadd( _aStru , {"PROD"      , "C" , 15 , 00 } )
aadd( _aStru , {"QUANTD3"   , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTIN"   , "N" , 14 , 02 } )
aadd( _aStru , {"SALDO"     , "N" , 14 , 02 } )
aadd( _aStru , {"DIFSLD"    , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTD1"   , "N" , 14 , 02 } )
aadd( _aStru , {"QUANTD2"   , "N" , 14 , 02 } )
aadd( _aStru , {"EMISSAO"   , "C" , 08 , 00 } )
aadd( _aStru , {"SERIE"     , "C" , 03 , 00 } )
aadd( _aStru , {"CONTA"     , "C" , 10 , 00 } )
aadd( _aStru , {"CFOP"      , "C" , 04 , 00 } )
aadd( _aStru , {"TMOP"      , "C" , 03 , 00 } )
aadd( _aStru , {"TMIN"      , "C" , 03 , 00 } )
aadd( _aStru , {"BASEIPI"   , "N" , 14 , 02 } )
aadd( _aStru , {"VALIPI"    , "N" , 14 , 02 } )
aadd( _aStru , {"TPPRO"     , "C" , 02 , 00 } )
aadd( _aStru , {"TIPO"      , "C" , 01 , 00 } )

_cTemp := CriaTrab( _aSTRU, .T. )
Use (_cTemp) Alias TMP New Exclusive
Index On PROD+EMISSAO To (_cTemp)


SetRegua(0)

cQuery := "select  SD3.D3_OP, SD3.D3_COD, sum(SD3.D3_QUANT) TOTAL, SD3.D3_EMISSAO, SD3.D3_TM, SB1.B1_TIPO AS D3_TIPO "
cQuery += "from	"+ retSqlName('SD3') +" SD3, "+ retSqlName('SB1') +" SB1 "
cQuery += "where   SD3.D3_EMISSAO between '20060101' and '20061231' "
cQuery += "and SD3.D3_COD = SB1.B1_COD "
cQuery += "and SD3.D3_COD in ("+cCodigs+") and SD3.D3_OP != '' "
//cQuery += "and SB1.B1_TIPO <> 'PA' "
//cQuery += "and SD3.D3_COD in ('AAA145') and SD3.D3_OP != '' "
cQuery += "and SD3.D3_FILIAL = '"+ xFilial('SD3') +"' and SD3.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*'"
cQuery += "group by SD3.D3_OP, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_TM, SB1.B1_TIPO "
cQuery += "having sum(SD3.D3_QUANT) > 0 "
cQuery += "order by SD3.D3_EMISSAO, SD3.D3_COD "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPX"
TCSetField( 'TMPX', "D3_EMISSAO", "D")
TMPX->( dbGoTop() )

do while( !TMPX->( EoF() ) )
    TMP->( DBAppend() )
	TMP->DOC     := TMPX->D3_OP
	TMP->PROD    := TMPX->D3_COD
	TMP->QUANTD3 := TMPX->TOTAL
	TMP->QUANTD1 := 0
	TMP->QUANTD2 := 0
	TMP->EMISSAO := DTOS(TMPX->D3_EMISSAO)
	TMP->SERIE   := ""
	TMP->CONTA   := ""
	TMP->TMOP    := TMPX->D3_TM
	TMP->BASEIPI := 0
	TMP->VALIPI  := 0	
	TMP->TIPO    := ""
    TMP->TPPRO   := TMPX->D3_TIPO
    TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()	
endDo
TMPX->( dbCloseArea() )

cQuery := "select	SD2.D2_DOC, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_CF, SD2.D2_CONTA, SD2.D2_TOTAL, SD2.D2_BASEIPI, SD2.D2_VALIPI, SD2.D2_TIPO, SB1.B1_TIPO AS D2_TP "
cQuery += "from	"+ retSqlName('SD2') +" SD2, "+retSqlName('SB1') +" SB1 "
//cQuery += "where		SD2.D2_EMISSAO between '20060101' and '20061231' and SD2.D2_SERIE = 'UNI' and ( SD2.D2_COD in ("+cCodigs+") OR LEN(SD2.D2_COD) > 7 ) "
cQuery += "where		SD2.D2_EMISSAO between '20060101' and '20061231' and SD2.D2_SERIE in ('UNI','0') and ( SD2.D2_COD in ("+cCodigs+") OR LEN(SD2.D2_COD) > 7 ) "
cQuery += "and SD2.D2_COD = SB1.B1_COD "
//cQuery += "and SB1.B1_TIPO <> 'PA' "
//cQuery += "where		SD2.D2_EMISSAO between '20060101' and '20061231' and SD2.D2_SERIE = 'UNI' and SD2.D2_COD in ('AAA145') "
cQuery += "and 		SD2.D2_FILIAL = '"+ xFilial('SD2') +"' and SD2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_DOC "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPX"
TCSetField( 'TMPX', "D2_EMISSAO", "D")

TMPX->( dbGoTop() )

do while( !TMPX->( EoF() ) )
   TMP->( DBAppend() )
	TMP->DOC     := TMPX->D2_DOC
	TMP->PROD    := TMPX->D2_COD
	TMP->QUANTD3 := 0
	TMP->QUANTD1 := 0
	TMP->QUANTD2 := TMPX->D2_QUANT
	TMP->EMISSAO := DTOS(TMPX->D2_EMISSAO)
	TMP->SERIE   := TMPX->D2_SERIE
	TMP->CONTA   := TMPX->D2_CONTA
	TMP->CFOP    := TMPX->D2_CF
	TMP->BASEIPI := IIF(TMPX->D2_BASEIPI=0,TMPX->D2_TOTAL,TMPX->D2_BASEIPI)
	TMP->VALIPI  := TMPX->D2_VALIPI
	TMP->TIPO    := TMPX->D2_TIPO
   TMP->TPPRO   := TMPX->D2_TP
   TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()	
endDo
TMPX->( dbCloseArea() )

cQuery := "select	SD1.D1_DOC, SD1.D1_COD, SD1.D1_QUANT, SD1.D1_TOTAL, SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_CF, SD1.D1_CONTA, SD1.D1_TOTAL, SD1.D1_BASEIPI, SD1.D1_VALIPI, SD1.D1_TIPO, SB1.B1_TIPO AS D1_TP "
cQuery += "from	"+ retSqlName('SD1') +" SD1, "+ retSqlName('SB1') +" SB1 "
//cQuery += "where	SD1.D1_DTDIGIT between '20060101' and '20061231' and SD1.D1_SERIE = 'UNI' and ( SD1.D1_COD in ("+cCodigs+") OR LEN(SD1.D1_COD) > 7 ) "
cQuery += "where	SD1.D1_DTDIGIT between '20060101' and '20061231' and SD1.D1_SERIE in ('UNI','0') and ( SD1.D1_COD in ("+cCodigs+") OR LEN(SD1.D1_COD) > 7 ) "
cQuery += "and SD1.D1_COD = SB1.B1_COD "
cQuery += "and SD1.D1_FILIAL = '"+ xFilial('SD1') +"' and SD1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
//cQuery += "and SB1.B1_TIPO <> 'PA' "
//cQuery += "and SD1.D1_FILIAL = '"+ xFilial('SD1') +"' and SD1.D_E_L_E_T_ != '*' and SD1.D1_COD in ('AAA145') "
cQuery += "order by SD1.D1_COD, SD1.D1_DTDIGIT, SD1.D1_DOC "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( dbGoTop() )

TCSetField( 'TMPX', "D1_DTDIGIT", "D")

do while( !TMPX->( EoF() ) ) .and. nI > 0 
   TMP->( DBAppend() )
	TMP->DOC     := TMPX->D1_DOC
	TMP->PROD    := TMPX->D1_COD
	TMP->QUANTD3 := 0
	TMP->QUANTD1 := TMPX->D1_QUANT
	TMP->QUANTD2 := 0
	TMP->EMISSAO := DTOS(TMPX->D1_DTDIGIT)
	TMP->SERIE   := TMPX->D1_SERIE
	TMP->CONTA   := TMPX->D1_CONTA
	TMP->CFOP    := TMPX->D1_CF
	TMP->BASEIPI := IIF(TMPX->D1_BASEIPI=0,TMPX->D1_TOTAL,TMPX->D1_BASEIPI)
	TMP->VALIPI  := TMPX->D1_VALIPI	
	TMP->TIPO    := TMPX->D1_TIPO
   TMP->TPPRO   := TMPX->D1_TP
   TMP->( DBCommit() )
	TMPX->( dbSkip() )
	incRegua()	
endDo

TMPX->( dbCloseArea() )

Marreta()

          //         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cCabec0 := "PRODUTO          |                                                                                 |          UNIDADE          |                        CLASSIFICACAO FISCAL                     |      |      |           |"
cCabec1 := "                 |                                                                                 |                           |                                                                 |      |      |           |"
cCabec2 := "           DOCUMENTO             |              LANCAMENTO              |                   ENTRADAS                         |    IPI   |                   SAIDAS                                       |  ESTOQUE  | OBS |"
cCabec3 := "Especie|Serie|  Numero   | Data  |Registros Fiscais|   Codificacao      |        Producao(Qtd)       |  Diversas  |   Valor  |          |          Producao (Qtd)      |  Diversas  |    Valor |   Ipi   |                 |"
cCabec4 := "       |Subs.|           |Dia|Mes|RE/RS| No |Folhas| Contabil   | Fiscal| No estabelec. | Em out.est.|    QTD.    |          |          |   No estabelec. | Em out.est.|     QTD.   |          |         |                 |"


DbSelectArea("TMP")
TMP->(DbGotop())

while !TMP->(EOF())
	
	if lAbortPrint
		@Prow() + 1,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	endif
	
	if (cCodAnt != TMP->PROD) .OR. (nLin > 55) //colocar o bloco abaixo dentro de uma fun็ใo
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1

		@ nLin,000 PSAY cCabec0
		nLin += 1
		@ nLin ,000 PSAY cCabec1
		dbSelectArea('SB1')
		SB1->( dbSetOrder( 1 ) )
		SB1->( dbSeek( xFilial('SB1') + TMP->PROD ) )
		@ nLin    ,000 PSAY alltrim(TMP->PROD)
		@ nLin	 ,023 PSAY alltrim(SB1->B1_DESC)
		@ nLin	 ,111 PSAY alltrim(SB1->B1_UM)
		nLin += 1
		@ nLin ,000 PSAY Repl('-',220)
		SB1->( dbCloseArea() )
		nLin += 1
		@ nLin,000 PSAY cCabec2
		nLin += 1
		@ nLin,000 PSAY cCabec3
		nLin += 1
		@ nLin,000 PSAY cCabec4
		nLin += 1
		@ nLin,000 PSAY Repl('-',220)
	endIf

	nTotEnt := nTotSai := 0 //estoque mensal
	if cCodAnt != TMP->PROD //zerando o cแlculo do estoque do novo produto
		nEstoque := saldo( TMP->PROD, 1)  //estoque total do produto
	endIf
	
	cMes := substr(TMP->EMISSAO,5,2)
	cCodAnt := TMP->PROD
	
	while !TMP->(EOF()) .AND. cCodAnt == TMP->PROD .AND. cMes == substr(TMP->EMISSAO,5,2)
		if nLin > 55 
   		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			@ nLin,000 PSAY cCabec0
			nLin += 1
			@ nLin ,000 PSAY cCabec1
			dbSelectArea('SB1')
			SB1->( dbSetOrder( 1 ) )
			SB1->( dbSeek( xFilial('SB1') + TMP->PROD ) )
			@ nLin    ,000 PSAY alltrim(TMP->PROD)
			@ nLin	 ,023 PSAY alltrim(SB1->B1_DESC)
			@ nLin	 ,111 PSAY alltrim(SB1->B1_UM)
			nLin += 1
			@ nLin ,000 PSAY Repl('-',220)
			SB1->( dbCloseArea() )
			nLin += 1
			@ nLin,000 PSAY cCabec2
			nLin += 1
			@ nLin,000 PSAY cCabec3
			nLin += 1
			@ nLin,000 PSAY cCabec4
			nLin += 1
			@ nLin,000 PSAY Repl('-',220)
		endif
		
		if TMP->QUANTD3 > 0		
         nLin += 1
			if Len(AllTrim(TMP->PROD)) < 7
  			   @ nLin, 002 PSAY "OP"
			   
				if TMP->QUANTD1 = 0 .AND. TMP->QUANTD2 = 0
					@ nLin, 014 PSAY TMP->DOC  //documento
  		      else 		         
  		         &("cNumOp"+cMes) := Soma1( &("cNumOp"+cMes) )
					@ nLin, 014 PSAY &("cNumOp"+cMes)  //documento  		         
  		      endif
         else
			   @ nLin, 002 PSAY "  "		
			endif
			
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2) //dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2) //mes
			
			if TMP->TMOP < '500'
   			@ nLin, 036 PSAY "RE"
   		else
   			@ nLin, 036 PSAY "RS"   			
         endif
			
			if Len(AllTrim(TMP->PROD)) < 7
	  		   if TMP->TMOP > '499'
	     			@ nLin, 137 PSAY Transform( TMP->QUANTD3,"@E 9,999,999.99" )   			      		
   			else
      			@ nLin, 073 PSAY Transform( TMP->QUANTD3,"@E 9,999,999.99" )
      		endif	
   		else
	  		   if TMP->TMOP > '499'
        			@ nLin, 168 PSAY Transform( TMP->QUANTD3,"@E 999,999.99" )   			
     			else
               @ nLin, 089 PSAY Transform( TMP->QUANTD3,"@E 999,999.99" )   			
            endif   
			endif
			
			if TMP->TMOP < '500'		
   			nEstoque += TMP->QUANTD3
	   		nTotEnt  += TMP->QUANTD3
			else
   			nEstoque -= TMP->QUANTD3
	   		nTotSai  += TMP->QUANTD3
			endif
			
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif

		if TMP->QUANTIN > 0
   		nLin += 1
			@ nLin, 002 PSAY "  "
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2) //dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2) //mes
			@ nLin, 036 PSAY iif(Alltrim(TMP->TMIN) < "500", "RE", "RS")
			if Alltrim(TMP->TMIN) < "500"
			   @ nLin, 089	PSAY Transform( TMP->QUANTIN,"@E 999,999.99" )
			else
			   @ nLin, 168	PSAY Transform( TMP->QUANTIN,"@E 999,999.99" )			   
			endif   
			if Alltrim(TMP->TMIN) < "500"
			   nEstoque += (TMP->QUANTIN)
   			nTotEnt  += TMP->QUANTIN
			else
			   nEstoque -= (TMP->QUANTIN)
   			nTotSai  += TMP->QUANTIN	
			endif   
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif

		If TMP->QUANTD2 > 0
   		nLin += 1
			@ nLin, 002 PSAY "NF"
			@ nLin, 014 PSAY AllTrim(TMP->DOC) //documento
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2)//dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2)//mes
			@ nLin, 036 PSAY "RS"
			@ nLin, 052 PSAY SUBSTR(TMP->CONTA,1,10) 				 //Conta contabil
			@ nLin, 065 PSAY Alltrim(TMP->CFOP) //Codigo fiscal
			@ nLin, 137 PSAY Transform( TMP->QUANTD2,"@E 999,999.99" ) //Quantidade vendida do item
			@ nLin, 181 PSAY Transform( TMP->BASEIPI,"@E 999,999.99" )			 //IPI
			@ nLin, 192 PSAY Transform( TMP->VALIPI,"@E 9,999.99" )			 //IPI
			nEstoque -= TMP->QUANTD2
			nTotSai  += TMP->QUANTD2
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endif 

		If TMP->QUANTD1 > 0
   		nLin += 1
			@ nLin, 002 PSAY "NF"
			@ nLin, 014 PSAY AllTrim(TMP->DOC) //documento
			@ nLin, 026 PSAY substr(TMP->EMISSAO,7,2)//dia
			@ nLin, 030 PSAY substr(TMP->EMISSAO,5,2)//mes
			@ nLin, 036 PSAY "RE"
			@ nLin, 052 PSAY SUBS(TMP->CONTA,1,10)					//Conta contabil
			@ nLin, 065 PSAY alltrim(TMP->CFOP)//Codigo fiscal
			@ nLin, 073 PSAY Transform( TMP->QUANTD1,"@E 999,999,999.99" ) //Quantidade devolvida do item
			@ nLin, 115 PSAY Transform( TMP->BASEIPI,"@E 999,999.99" ) 		  //BASE IPI
			@ nLin, 126 PSAY Transform( TMP->VALIPI,"@E 9,999.99" ) 		  //VALOR IPI
			nEstoque += TMP->QUANTD1
			nTotEnt  += TMP->QUANTD1
			@ nLin, 202 PSAY Transform( nEstoque, "@E 999,999,999.99" )
		endIf
		incRegua()
		TMP->(DbSkip())
	end
	nLin += 1
	@ nLin, 026 PSAY "Totais do mes "+ cMes

	@ nLin, 048 PSAY "Entradas:  " + Transform( nTotEnt,"@E 999,999.99" )
	@ nLin, 075 PSAY "Saidas:  " + Transform( nTotSai,"@E 999,999.99" )
end

TMP->(DbCloseArea())

//__CopyFIle(_cTemp+".DBF", "C:\"+_ctemp+".XLS")

Ferase(_cTemp+".DBF")
Ferase(_cTemp+OrdBagExt())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************
Static Function marreta()
***************

local cProd
local nInv := nDifSld := nSldPro := nSldIni := nSldFim := 0
local nSldMov := nEntAc := nD3 := nTotD3 := nTotD1 := nTotD2 := 0
local cData

DbSelectArea("TMP")
DbSetOrder(1)

TMP->(DbGotop())

while !TMP->(EOF())
	cProd   := TMP->PROD
   nSldPro := Saldo( cProd, 1 )
	nSldFim := Saldo( cProd, 2 )
	nDifSld := 0
	nReg := TMP->(Recno())
	
	while !TMP->(EOF()) .AND. cProd = TMP->PROD
		cData  := TMP->EMISSAO
		while !TMP->(EOF()) .AND. cProd = TMP->PROD .AND. TMP->EMISSAO = cData
			//Ajuste para naum ficar negativo o saldo da movimentacao
  			if TMP->TMOP > '499'
  	   		   nSldPro += (TMP->QUANTD1-TMP->QUANTD3-TMP->QUANTD2)+nDifSld                
            else
    			nSldPro += (TMP->QUANTD3+TMP->QUANTD1-TMP->QUANTD2)+nDifSld //original
  	   	    endif
  	   		
			if nSldPro < 0 
 				nDifSld := ABS( nSldPro ) //original
			    if TMP->TMOP > '499'
   			       nD3     := TMP->QUANTD3 - ABS( nSldPro )
		        else
				   nD3     := ABS( nSldPro ) + TMP->QUANTD3 //original
				endif   
			else
				nDifSld := 0
				nD3     := TMP->QUANTD3
			endif
			
			RecLock("TMP",.F.)
			TMP->SALDO    := nSldPro+nDifSld		
			TMP->QUANTD3  := nD3
			TMP->DIFSLD   := nDifSld
			MsUnLock()
			TMP->(DbSkip())
      	   IncRegua()
		end
	end
    nReg := TMP->(Recno())

	TMP->(DbSkip(-1))	

	if TMP->SALDO # nSldFim
   	   nDifSld := TMP->SALDO - nSldFim 	
       RecLock("TMP",.F.)
	   TMP->QUANTIN := ABS(nDifSld)
   	   if nDifSld > 0
		  TMP->TMIN    := "500"
	   else
		  TMP->TMIN    := "100"		   	
   	   endif
       MSUnlock()
   endif
   TMP->(dbGoto(nReg))
end

Return 



***************
Static Function Saldo( cCod, nTipo )
***************

Local nSaldo := 0
cQuery := "select Quant_05, Quant_06 from TEMPOR where CODIGO = '"+  cCod + "' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPR"
TMPR->( dbGoTop() )
nSaldo := iif( nTipo = 1, TMPR->Quant_05, TMPR->Quant_06 )
TMPR->(	dbCloseArea() )

Return nSaldo
