#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCPE()    º Autor ³ MP8 IDE            º Data ³  22/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Registro de controle da produção e do estoque, modelo 3.   º±±
±±º          ³ Relatório solicitado por Porto.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCPE1()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Registro de Controle da Produção e do Estoque"
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
Private cString 		 := ""
Private cCodigs			 := "'AAA044','AAA045','AAA062','AAA134',"+;
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************


Local cCodAnt  := cMes := " "
Local nNotNeg := nEstoque := nTotal  := 0
Local k := 1
Private aArray1  := {}
Private cNumOp := '00131100000'

cQuery := "select  SD3.D3_OP, SD3.D3_COD, sum(SD3.D3_QUANT) TOTAL, SD3.D3_EMISSAO, SD3.D3_TM "
cQuery += "from	"+ retSqlName('SD3') +" SD3 "
//cQuery += "from	SD3010 SD3 "
cQuery += "where   SD3.D3_EMISSAO between '20060101' and '20061231' "
//cQuery += "and SD3.D3_COD in ("+cCodigs+") and SD3.D3_OP != '' "
cQuery += "and SD3.D3_COD in ('ADA011') and SD3.D3_OP != '' "
cQuery += "and SD3.D3_FILIAL = '"+ xFilial('SD3') +"' and SD3.D_E_L_E_T_ != '*' "
cQuery += "group by SD3.D3_OP, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_TM "
cQuery += "having sum(SD3.D3_QUANT) > 0 "
cQuery += "order by SD3.D3_EMISSAO, SD3.D3_COD "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', "D3_EMISSAO", "S")
TMP->( dbGoTop() )

do while( !TMP->( EoF() ) )
	aAdd(aArray1, { 'D3', TMP->D3_OP, TMP->D3_COD, TMP->TOTAL, TMP->D3_EMISSAO, TMP->D3_TM} )
	TMP->( dbSkip() )
endDo
TMP->( dbCloseArea() )

cQuery2 := "select	SD2.D2_DOC, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_CF, SD2.D2_CONTA, SD2.D2_IPI, SD2.D2_TIPO "
cQuery2 += "from	"+ retSqlName('SD2') +" SD2 "
//cQuery2 += "where		SD2.D2_EMISSAO between '20060101' and '20061231' and SD2.D2_SERIE = 'UNI' and SD2.D2_COD in ("+cCodigs+") "
cQuery2 += "where		SD2.D2_EMISSAO between '20060101' and '20061231' and SD2.D2_SERIE in ('UNI','0') and SD2.D2_COD in ('ADA011') "
cQuery2 += "and 		SD2.D2_FILIAL = '"+ xFilial('SD2') +"' and SD2.D_E_L_E_T_ != '*' "
cQuery2 += "order by SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_DOC "
cQuery2 := changeQuery( cQuery2 )
TCQUERY cQuery2 NEW ALIAS "TMP2"
TMP2->( dbGoTop() )

do while( !TMP2->( EoF() ) )
	aAdd(aArray1, { 'D2', TMP2->D2_DOC, TMP2->D2_COD, TMP2->D2_QUANT, TMP2->D2_EMISSAO,;
	TMP2->D2_SERIE, TMP2->D2_CONTA, TMP2->D2_CF, TMP2->D2_IPI, TMP2->D2_TIPO } )
	TMP2->( dbSkip() )
endDo
TMP2->( dbCloseArea() )

cQuery3 := "select	SD1.D1_DOC, SD1.D1_COD, SD1.D1_QUANT, SD1.D1_TOTAL, SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_CF, SD1.D1_CONTA, SD1.D1_IPI "
cQuery3 += "from	"+ retSqlName('SD1') +" SD1 "
cQuery3 += "where	SD1.D1_DTDIGIT between '20060101' and '20061231' "
//cQuery3 += "and SD1.D1_FILIAL = '"+ xFilial('SD1') +"' and SD1.D_E_L_E_T_ != '*' and SD1.D1_COD in ("+cCodigs+") "
cQuery3 += "and SD1.D1_FILIAL = '"+ xFilial('SD1') +"' and SD1.D_E_L_E_T_ != '*' and SD1.D1_COD in ('ADA011') "
cQuery3 += "order by SD1.D1_COD, SD1.D1_DTDIGIT, SD1.D1_DOC "
cQuery3 := changeQuery( cQuery3 )
TCQUERY cQuery3 NEW ALIAS "TMP3"
TMP3->( dbGoTop() )

do while( !TMP3->( EoF() ) )
	aAdd(aArray1, { 'D1' ,TMP3->D1_DOC, TMP3->D1_COD, TMP3->D1_QUANT, TMP3->D1_DTDIGIT,;
	TMP3->D1_SERIE, TMP3->D1_CONTA, TMP3->D1_CF, TMP3->D1_IPI } )
	TMP3->( dbSkip() )
endDo
TMP3->( dbCloseArea() )
aSort(aArray1,,,{|x,y| x[3]+x[5] < y[3]+y[5]} )

//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       180       190       200       210       220
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cCabec0 := "PRODUTO          |                                                                                 |          UNIDADE          |                        CLASSIFICACAO FISCAL                     |      |      |           |"
cCabec1 := "                 |                                                                                 |                           |                                                                 |      |      |           |"
cCabec2 := "           DOCUMENTO             |              LANCAMENTO              |                   ENTRADAS                           |  IPI   |                   SAIDAS                                       |  ESTOQUE  | OBS |"
cCabec3 := "Especie|Serie|  Numero   | Data  |Registros Fiscais|   Codificacao      |        Producao(Qtd)           |Diversas|   Valor    |        |          Producao (Qtd)          |Diversas|    Valor   | Ipi   |           |     |"
cCabec4 := "       |Subs.|           |Dia|Mes|RE/RS| Nº |Folhas| Contabil   | Fiscal| No estabelec. | Em outro estab.|  QTD.  |            |        |   No estabelec. | Em outro estab.|   QTD. |            |       |           |     |"


//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//"PRODUTO              |                                                                             |          UNIDADE          |                        CLASSIFICACAO FISCAL                     |      |      |           |"
//"                     |                                                                             |                           |                                                                 |      |      |           |"
//"           DOCUMENTO             |              LANCAMENTO              |                   ENTRADAS                             | IPI  |                   SAIDAS                                       |  ESTOQUE  | OBS |"
//"Especie|Serie|  Numero   | Data  |Registros Fiscais|   Codificacao      |        Producao(Qtd)           | Diversas |   Valor    |      |          Producao (Qtd)          |Diversas| Valor      | Ipi   |           |     |"
//"       |Subs.|           |Dia|Mes|RE/RS| Nº |Folhas| Contabil   | Fiscal| No estabelec. | Em outro estab.|   QTD.   |            |      |   No estabelec. | Em outro estab.|   QTD. |            |       |           |     |"
setRegua( len( aArray1 ) )

for X:= 1 to len( aArray1 )
	
	If lAbortPrint
		@Prow() + 1,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	if ( cMes != substr(aArray1[X][5],5,2) ) .OR. ( cMes == substr(aArray1[X][5],5,2) .AND. (cCodAnt != aArray1[X][3]) )
		@Prow() + 1,026 PSAY "Total do mes "+ cMes +" :"
		@Prow() 	 ,048 PSAY Transform( nTotal,"@E 999,999.99" )
		nTotal := 0//estoque mensal
		if cCodAnt != aArray1[X][3] //zerando o cálculo do estoque do novo produto
			aArRet := marreta( X ); k := 1
			nEstoque := saldoIni( alltrim(aArray1[X][3]) )//0//estoque total do produto
		endIf
	endIf
	
	if (cCodAnt != aArray1[X][3]) .OR. (Prow() > 55) //colocar o bloco abaixo dentro de uma função
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		@Prow() + 1,000 PSAY cCabec0
		@Prow() + 1,000 PSAY cCabec1
		dbSelectArea('SB1')
		SB1->( dbSetOrder( 1 ) )
		SB1->( dbSeek( xFilial('SB1') + aArray1[X][3] ) )
		@Prow()    ,000 PSAY alltrim(aArray1[X][3])
		@Prow()		 ,023 PSAY alltrim(SB1->B1_DESC)
		@Prow()		 ,111 PSAY alltrim(SB1->B1_UM)
		@Prow() + 1,000 PSAY Repl('-',220)
		SB1->( dbCloseArea() )
		@Prow() + 1,000 PSAY cCabec2
		@Prow() + 1,000 PSAY cCabec3
		@Prow() + 1,000 PSAY cCabec4
		@Prow() + 1,000 PSAY Repl('-',220)
	endIf
	
	if aArray1[X][1] == 'D3'
		if len(aArRet) = 0
			@Prow() + 1,002 PSAY 'OP'
			@Prow()		 ,014 PSAY transform( aArray1[X][2], "@E 99999999999")//documento
			@Prow()    ,026 PSAY substr(aArray1[X][5],7,2) //dia
			@Prow()    ,030 PSAY substr(aArray1[X][5],5,2) //mes
			@Prow()		 ,036 PSAY iif(aArray1[X][6] < '500', 'RE', 'RS')
			@Prow()    ,iif(aArray1[X][6] < '500', 074, 140); //apenas define a coluna
			PSAY Transform( aArray1[X][4],"@E 999,999.99" )
			iif(aArray1[X][6] < '500', {nTotal 	 += aArray1[X][4],nEstoque += aArray1[X][4]},;
			{nTotal 	 -= aArray1[X][4],nEstoque -= aArray1[X][4]})
			@Prow()   ,203 PSAY Transform( nEstoque, "@E 999,999.99" )
		else
			@Prow() + 1,002 PSAY 'OP'
			@Prow()		 ,014 PSAY transform( aArray1[X][2], "@E 99999999999")//documento
			@Prow()    ,026 PSAY substr(aArray1[X][5],7,2) //dia
			@Prow()    ,030 PSAY substr(aArray1[X][5],5,2) //mes
			@Prow()		 ,036 PSAY iif(aArray1[X][6] < '500', 'RE', 'RS')
			nTemp := aArray1[X][4] + aArRet[k][2] //nTemp é utilizada para marretar o valor do estoque mensal e total
			@Prow()    ,iif(aArray1[X][6] < '500', 074, 140); //apenas define a coluna
			PSAY Transform( aArray1[X][4] + aArRet[k][2],"@E 999,999.99" )//somando com o valor marretado em arret
			iif(aArray1[X][6] < '500', {nTotal += nTemp,nEstoque += nTemp},;
			{nTotal -= nTemp,nEstoque -= nTemp})
			@Prow()   ,203 PSAY Transform( nEstoque, "@E 999,999.99" )
			
			k++//andando o índice da marreta
		endIf
	elseIf aArray1[X][1] == 'D2'
		@Prow() + 1,002 PSAY 'NF'
		@Prow()		 ,014 PSAY transform( aArray1[X][2], "@E 99999999999")//documento
		@Prow()    ,026 PSAY substr(aArray1[X][5],7,2)//dia
		@Prow()    ,030 PSAY substr(aArray1[X][5],5,2)//mes
		@Prow()		 ,036 PSAY 'RS'
		@Prow()		 ,053 PSAY aArray1[X][7] 				 //Conta contabil
		@Prow()		 ,067 PSAY alltrim(aArray1[X][8]) //Codigo fiscal
		@Prow()    ,140 PSAY Transform( aArray1[X][4],"@E 999,999.99" ) //Quantidade vendida do item
		@Prow()    ,196 PSAY Transform( aArray1[X][9],"@E 99.99" )			 //IPI
		nTotal 	 -= aArray1[X][4]
		nEstoque -= aArray1[X][4]
		@Prow()    ,203 PSAY Transform( nEstoque, "@E 999,999.99" )
	elseIf aArray1[X][1] == 'D1'
		@Prow() + 1,002 PSAY 'NF'
		@Prow()	   ,014 PSAY transform( aArray1[X][2], "@E 99999999999")//documento
		@Prow()    ,026 PSAY substr(aArray1[X][5],7,2)//dia
		@Prow()    ,030 PSAY substr(aArray1[X][5],5,2)//mes
		@Prow()		 ,036 PSAY 'RE'
		@Prow()		 ,053 PSAY aArray1[X][7]					//Conta contabil
		@Prow()		 ,067 PSAY alltrim(aArray1[X][8])//Codigo fiscal
		@Prow()    ,078 PSAY Transform( aArray1[X][4],"@E 999,999.99" ) //Quantidade devolvida do item
		@Prow()    ,131 PSAY Transform( aArray1[X][9],"@E 99.99" ) 		  //IPI
		nTotal 	 += aArray1[X][4]
		nEstoque += aArray1[X][4]
		@Prow()    ,203 PSAY Transform( nEstoque, "@E 999,999.99" )
	endIf
	cMes := substr(aArray1[X][5],5,2)
	cCodAnt := aArray1[X][3]
	incRegua()
	
NEXT
@Prow() + 1,026 PSAY "Total do mes "+ cMes +" :"
@Prow() 	 ,048 PSAY Transform( nTotal,"@E 999,999.99" )

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************

Static Function marreta( nInd )

***************

Local aOP := {}
Local aReturn := {}
Local cQuery := cCod := ''
Local y := nInd, j := i := nQtd05 := nQtd06 := nCount := nTotaliz := nTotaliz2 := nTotOP := 0

cQuery := "select * from TEMPOR where CODIGO = '"+  aArray1[y][3] + "' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->(  dbGoTop() )
nQtd05 := TMP->Quant_05; nQtd06 := TMP->Quant_06
TMP->(	dbCloseArea() )

cCod := aArray1[y][3]
do while cCod == aArray1[y][3]
	iif(aArray1[y][1] == 'D3',;
	iif(aArray1[y][6]<'500',{nTotaliz += aArray1[y][4],nTotOP += aArray1[y][4],;
	aAdd(aOP, {aArray1[y][2],aArray1[y][4]/*,y*/})},;
	{nTotaliz -= aArray1[y][4],nTotOP -= aArray1[y][4],;
	aAdd(aOP,{aArray1[y][2],aArray1[y][4]/*,y*/})}),;
	iif(aArray1[y][1] == 'D2',nTotaliz -= aArray1[y][4], iif(aArray1[y][1] == 'D1',nTotaliz += aArray1[y][4], )))
	
	if nTotaliz < 0 .AND.	len(aOP) >= 1
		/*
		Problemas:
		- Se meu nTotOP estiver negativo;
		- Se minha última OP for uma saída;
		-
		*/
		nIdx := aScan( aArray1, { |aVal| aVal[2] == aOP[len(aOP)][1] })
		if nTotOP < 0
			nTotOP  += aOP[len(aOP)][2]
		else
			nTotOP  -= aOP[len(aOP)][2]
		endIf
		if aOP[len(aOP)][2] < 0
			nTotaliz := nTotaliz + aOP[len(aOP)][2]
		else
			nTotaliz := nTotaliz - aOP[len(aOP)][2]
		endIf
		aOP[len(aOP)][2] += abs(aArray1[y][4])
		nTotOP 	 += aOP[len(aOP)][2]
		nTotaliz += aOP[len(aOP)][2]
		aArray1[nIdx][4] := aOP[len(aOP)][2]
		
	elseIf nTotaliz < 0 .AND.	len(aOP) == 0 //criar uma op
		cNumOp := Soma1( cNumOp )
		//OP    //Cod. Produto //Quantidade		//Dt. Emissao  //TM
		aAdd(aArray1, { 'D3', cNumOp, aArray1[y][3], aArray1[y][4], aArray1[y][5], '000'} )
		aSort(aArray1,,,{|x,y| x[3]+x[5] < y[3]+y[5]} )
		nTotaliz := aArray1[y][4]//nTotaliz := 3 // - aOP[len(aOP)][2]))
		nTotOP	 := aArray1[y][4]//nTotOP   := 3 // - aOP[len(aOP)][2]))
		aAdd(aOP, { cNumOp, aArray1[y][4]/*, len(aArray1) + 1*/ } )
	endIf
	
	y++
	if y > len(aArray1)
		y--
		cCod := 'XXXXXXXX'
	endIf
endDo
/*nTotaliz += nQtd05;*/ nDif := (nTotaliz - (nQtd06 - nQtd05))
for i := 1 to len(aOP)
	aAdd( aReturn, { aOP[i][1], ((aOP[i][2]*nDif) / nTotOP) } )
Next

Return aReturn

***************

Static Function saldoIni( cCod )

***************

Local nSaldo := 0
cQuery := "select * from TEMPOR where CODIGO = '"+  cCod + "' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->(  dbGoTop() )
nSaldo := TMP->Quant_05
TMP->(	dbCloseArea() )

Return nSaldo
