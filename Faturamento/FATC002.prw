#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  14/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATC002()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Posicao de vendas Caixa"
Local cPict          := ""
Local titulo         := "Posicao de vendas Caixa"
Local nLin           := 80

Local Cabec1         := ""                                                         	
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATC002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATC002" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

SetPrvt("dDatMax")

Pergunte("FATC002",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATC002",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo:= alltrim("Posicao de vendas Caixa")
if !empty(MV_PAR04) .and. empty(MV_PAR05)
    Titulo +=" - So a UF: "+MV_PAR04
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
    Titulo +=" - Menos a UF: "+MV_PAR05
endIf

If !empty(MV_PAR06) // Representante
   Titulo +=+" - "+alltrim(MV_PAR06)+" - "+Posicione("SA3",1,xFilial('SA3') + MV_PAR06,"A3_NREDUZ") 
elseif !empty(MV_PAR07) //Coordenador
   Titulo +=" - Coordenador - "+posicione("SA3",1,xFilial('SA3') + MV_PAR07,"A3_NREDUZ") 
elseif !empty(MV_PAR08)  //Gerente
   Titulo +=" - Gerente - "+posicione("SA3",1,xFilial('SA3') + MV_PAR08,"A3_NREDUZ") 
else
   Titulo +="Diretoria"
endif             
             


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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/10/09   º±±
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
Local nFator:=nMargem:=nCusto:=0
local TotUN:=TotUN1:=TotUN2:=TotUN3:=TotUN4:=TotUN5:=TotUN6:=TotUN7:=TotUN8:=TotUN9:=TotUN10:=TotUN11:=TotUN12:=TotUN13:=TotUN14:=TotUN15:=TotUN16:=TotUN17:=TotUN18:=TotUN19:=TotUN20:=TotUN21:=0 
local TotUN22:=TotUN23:=TotUN24:=TotUN25:=TotUN26:=TotUN27:=0
local TotR:=TotR1:=TotR2:=TotR3:=TotR4:=TotR5:=TotR6:=TotR7:=TotR8:=TotR9:=TotR10:=TotR11:=TotR12:=TotR13:=TotR14:=TotR15:=TotR16:=TotR17:=TotR18:=TotR19:=TotR20:=TotR21:=0 
local TotR22:=TotR23:=TotR24:=TotR25:=TotR26:=TotR27:=0
Local cCod:=cData:=''
Local _aProd:={}
local aMES := { 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out',;
'Nov', 'Dez' }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua( 0 )

cQry:="SELECT B1_COD FROM "+retSqlName("SB1")+" SB1 WHERE B1_FILIAL='"+xFilial('SB1')+"' AND LEN(B1_COD)<=7 "
cQry+="AND B1_SETOR='39'AND B1_ATIVO='S' AND B1_TIPO='PA' AND  SB1.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "AUUX"

AUUX->( dbGoTop() )
Do While ! AUUX->( EoF() )                // DIA,UN,R$,MARGEM,QUANT
   aAdd( _aProd,{ alltrim(AUUX->B1_COD) ,{ }  }  )  
   IncRegua() 
   AUUX->(dbSkip())	
EndDo
AUUX->(DbCloseArea())

cQry:="SELECT DISTINCT(D2_EMISSAO) "
cQry+="FROM "
cQry+=retSqlName("SD2")+" SD2 WITH (NOLOCK), "
cQry+=retSqlName("SB1")+" SB1 WITH (NOLOCK), "
cQry+=retSqlName("SF2")+" SF2 WITH (NOLOCK), "
cQry+=retSqlName("SA3")+" SA3 WITH (NOLOCK) "
cQry+="WHERE D2_EMISSAO BETWEEN '"+StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01'+"' AND '" +StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'31'+ "' "  
cQry+="AND SB1.B1_SETOR = '39' " // SOMENTE CAIXA 

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQry += "AND SF2.F2_EST = '"+MV_PAR04+"' "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQry += "AND SF2.F2_EST != '"+MV_PAR05+"' "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQry += "AND SF2.F2_EST = '"+MV_PAR04+"' AND SF2.F2_EST != '"+MV_PAR05+"' "
endIf

cQry+=" AND RTRIM(F2_VEND1) = RTRIM(A3_COD) "
If !Empty(MV_PAR06)
	cQry += " AND RTRIM(A3_COD) LIKE ('"+ Alltrim(MV_PAR06) + "%' )"
elseif !Empty(MV_PAR07)//Coordenador
	//cQuery += " AND RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR12) + "%' )"+LF 
    cQry += " AND ( RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR07) + "%')  OR RTRIM(F2_VEND1) LIKE ('" + Alltrim(MV_PAR07) + "%') )"
elseif !Empty(MV_PAR08) //Gerente	
	cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR08) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "
	cQry +=       " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR08) + "%' ) ) "
endif


/*
If !empty(MV_PAR06) // Representante
    cQry += "AND SF2.F2_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") "
elseif !empty(MV_PAR07)//Coordenador
    cQry += "AND EXISTS( SELECT A3_SUPER "
    cQry += "          FROM "+RetSqlName("SA3")+" "
    cQry += "          WHERE A3_COD = SF2.F2_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' ) "
elseif !empty(MV_PAR08)//Gerente
    cQry += " AND SF2.F2_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQry += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQry += "and SA3.D_E_L_E_T_ != '*' )  "
Endif
*/

//cQry+="AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_TIPO = 'N' " 
cQry+="AND D2_TIPO = 'N' " 

//cQry+="AND RTRIM(D2_COD) NOT IN ('187','188','189','190','200','210')  "
//cQry+="AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949')  "
cQry+="AND D2_TP!='AP'"
cQry+="AND RTRIM(D2_CF) IN ('5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116' )  "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD  "
cQry+="AND SB1.D_E_L_E_T_ = ''  "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  "
// COLOCADO EM 16/10/2012 -- colocado pra ficar igual ao consulta 
//cQry+="AND D2_CLIENTE != '031732' " // --Despreza faturamento entre FILIAIS 
cQry+="AND D2_CLIENTE NOT IN ('031732','031733') " // --Despreza faturamento entre FILIAIS 
//
cQry+="AND F2_DUPL <> ' '  "
cQry+="AND F2_FILIAL=D2_FILIAL "
//cQry+="AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' "
cQry+="AND SF2.D_E_L_E_T_ = '' "
//cQry+="AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' "
cQry+="AND SD2.D_E_L_E_T_ = '' "
//cQry+="AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' "
cQry+="AND SA3.D_E_L_E_T_ = '' "
//cQry+="AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="ORDER BY D2_EMISSAO  "

TCQUERY cQry NEW ALIAS "TMPX"

If ! TMPX->( EoF() )    
	for _y:=1 to Len(_aProd)
	 TMPX->( dbGoTop() ) 
	  Do While ! TMPX->( EoF() )    
	    aAdd( _aProd[_y][2],{ TMPX->D2_EMISSAO,0,0,0,0 } )
	    IncRegua() 
	    TMPX->(dbSkip())
	  Enddo
	Next
Endif
TMPX->(DbCloseArea())

//cQry:="SELECT QUANT=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0)  "
//cQry+="ELSE ROUND(SUM(D2_QUANT),0,1) END, "
cQry:="SELECT QUANT=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  "
cQry+="ELSE D2_QUANT-D2_QTDEDEV END), "
//cQry+="VALOR=ROUND(SUM(D2_TOTAL),0,1), "
cQry+="VALOR=SUM(D2_TOTAL), "
cQry+="D2_EMISSAO,D2_COD  "
cQry+="FROM "
cQry+=retSqlName("SD2")+" SD2 WITH (NOLOCK), "
cQry+=retSqlName("SB1")+" SB1 WITH (NOLOCK), "
cQry+=retSqlName("SF2")+" SF2 WITH (NOLOCK), "
cQry+=retSqlName("SA3")+" SA3 WITH (NOLOCK) "
cQry+="WHERE D2_EMISSAO BETWEEN '"+StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01'+"' AND '" +StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'31'+ "' "  
cQry+="AND SB1.B1_SETOR = '39' " // SOMENTE CAIXA 

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQry += "AND SF2.F2_EST = '"+MV_PAR04+"' "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQry += "AND SF2.F2_EST != '"+MV_PAR05+"' "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQry += "AND SF2.F2_EST = '"+MV_PAR04+"' AND SF2.F2_EST != '"+MV_PAR05+"' "
endIf

cQry+=" AND RTRIM(F2_VEND1) = RTRIM(A3_COD) "
If !Empty(MV_PAR06)
	cQry += " AND RTRIM(A3_COD) LIKE ('"+ Alltrim(MV_PAR06) + "%' )"
elseif !Empty(MV_PAR07)//Coordenador
	//cQuery += " AND RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR12) + "%' )"+LF 
    cQry += " AND ( RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR07) + "%')  OR RTRIM(F2_VEND1) LIKE ('" + Alltrim(MV_PAR07) + "%') )"
elseif !Empty(MV_PAR08) //Gerente	
	cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR08) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "
	cQry +=       " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR08) + "%' ) ) "
endif

/*
If !empty(MV_PAR06) // Representante
    cQry += "AND SF2.F2_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") "
elseif !empty(MV_PAR07)//Coordenador
    cQry += "AND  EXISTS( SELECT A3_SUPER "
    cQry += "          FROM "+RetSqlName("SA3")+" "
    cQry += "          WHERE A3_COD = SF2.F2_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' )  "
elseif !empty(MV_PAR08)//Gerente
    cQry += "AND SF2.F2_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQry += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQry += "and SA3.D_E_L_E_T_ != '*' )  "
Endif
*/

//cQry+="AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_TIPO = 'N' " 
cQry+="AND D2_TIPO = 'N' " 

//cQry+="AND RTRIM(D2_COD) NOT IN ('187','188','189','190','200','210')  "
cQry+="AND D2_TP!='AP'"
cQry+="AND RTRIM(D2_CF) IN ('5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116' )  "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD  "
cQry+="AND SB1.D_E_L_E_T_ = ''  "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  "
// COLOCADO EM 16/10/2012 -- colocado pra ficar igual ao consulta 
//cQry+="AND D2_CLIENTE != '031732' " // --Despreza faturamento entre FILIAIS 
cQry+="AND D2_CLIENTE NOT IN ('031732','031733') " // --Despreza faturamento entre FILIAIS 
//
cQry+="AND F2_DUPL <> ' '  "

/*
cQry+="AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' "
cQry+="AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' "
cQry+="AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' "
cQry+="AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' "
*/
cQry+="AND F2_FILIAL=D2_FILIAL "
cQry+="AND SF2.D_E_L_E_T_ = '' "
cQry+="AND SD2.D_E_L_E_T_ = '' "
cQry+="AND SA3.D_E_L_E_T_ = '' "
cQry+="AND SB1.D_E_L_E_T_ = '' "


//cQry+="GROUP BY D2_SERIE, F2_VEND1,D2_EMISSAO,D2_COD  "
cQry+="GROUP BY D2_EMISSAO,D2_COD  "
cQry+="ORDER BY D2_COD,D2_EMISSAO "
TCQUERY cQry NEW ALIAS "TMPZ"


Do While ! TMPZ->( EoF() )    
  cCod:=TMPZ->D2_COD
  nIdx  := aScan(_aProd, {|t| t[1]== alltrim(U_transgen(TMPZ->D2_COD))  } )
  If  nIdx>0
	  Do While ! TMPZ->( EoF() ) .AND. TMPZ->D2_COD=cCod     
	     cData:=TMPZ->D2_EMISSAO
	     nIdx2 := aScan( _aProd[nIdx][2], {|x| x[1]== cData } )   
	     If  nIdx2>0
		     Do While ! TMPZ->( EoF() ) .AND. TMPZ->D2_COD=cCod .AND. TMPZ->D2_EMISSAO=cData               		
			    _aProd[nIdx][2][nIdx2][2]+=TMPZ->QUANT
			    _aProd[nIdx][2][nIdx2][3]+=TMPZ->VALOR	  
		        IncRegua() 
		        TMPZ->(dbSkip())			   
		     EndDo
		        // Margem 
			    nFator:= _aProd[nIdx][2][nIdx2][3]/_aProd[nIdx][2][nIdx2][2]
		   	    nCusto:= Posicione("SB5",1,xFilial('SB5')+ _aProd[nIdx][1],"B5_CUSTO")  
		   	   // nMargem:=iif(nFator > 0, ( (nFator*100/iif(nCusto>0,nCusto,1) ) ) - 100,0) 
		       // novo calculo da margem : (preco de venda - custo/preco de venda) *100  
		        nMargem:= ((nFator-nCusto)/nFator)*100
		        _aProd[nIdx][2][nIdx2][4]:=nMargem
		        _aProd[nIdx][2][nIdx2][5]:=nFator
	     Else
	         IncRegua() 
             TMPZ->(dbSkip())
	     Endif
	  EndDo   
  Else
     IncRegua() 
     TMPZ->(dbSkip())
  Endif	
EndDo

TMPZ->(DbCloseArea())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                                                           
For _x:=1 to Len(_aProd)
                                                        
    Cabec1:="Codigo"+iif(1>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][1][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][1][1],5,2))] )+iif(2>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][2][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][2][1],5,2))] )+iif(3>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][3][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][3][1],5,2))] );
                   +iif(4>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][4][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][4][1],5,2))] )+iif(5>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][5][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][5][1],5,2))] )+iif(6>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][6][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][6][1],5,2))] );
                   +iif(7>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][7][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][7][1],5,2))] )+iif(8>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][8][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][8][1],5,2))] )+iif(9>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][9][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][9][1],5,2))] );                   
                   +iif(10>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][10][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][10][1],5,2))] )+iif(11>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][11][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][11][1],5,2))] )+iif(12>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][12][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][12][1],5,2))] ); 
                   +iif(13>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][13][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][13][1],5,2))] )+iif(14>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][14][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][14][1],5,2))] )+iif(15>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][15][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][15][1],5,2))] );
                   +iif(16>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][16][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][16][1],5,2))] )+iif(17>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][17][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][17][1],5,2))] )+iif(18>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][18][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][18][1],5,2))] ); 
                   +iif(19>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][19][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][19][1],5,2))] )+iif(20>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][20][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][20][1],5,2))] )+iif(21>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][21][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][21][1],5,2))] );       
                   +iif(22>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][22][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][22][1],5,2))] )+iif(23>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][23][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][23][1],5,2))] )+iif(24>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][24][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][24][1],5,2))] );                    
                   +iif(25>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][25][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][25][1],5,2))] )+iif(26>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][26][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][26][1],5,2))] )+iif(27>Len(_aProd[_x][2]),'',+space(2)+substr(_aProd[_x][2][27][1],7,2)+'/'+aMES[val(substr(_aProd[_x][2][27][1],5,2))] );
                   +space(2)+'Total'  

   
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
      nLin := 8
   Endif


   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    
    
    TotPrdR:=0   // total produto Real
    aEval( _aProd[_x][2], { |a| TotPrdR  += a[3] } )
    
    TotPrdQ:=0   // total produto Quantidate
    aEval( _aProd[_x][2], { |a| TotPrdQ  += a[2] } )
    
    
    
    //Produto
    @nLin++,00 PSAY _aProd[_x][1]+" - "+posicione("SB1",1,xFilial('SB1') + _aProd[_x][1],"B1_DESC")  
    //nLin++
    //UN    
   @nLin++,00 PSAY "UN    "+iif(1>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][1][2], '@E 999,999'))+iif(2>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][2][2], '@E 999,999'))+iif(3>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][3][2], '@E 999,999'));
                   +iif(4>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][4][2], '@E 999,999'))+iif(5>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][5][2], '@E 999,999'))+iif(6>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][6][2], '@E 999,999'));
                   +iif(7>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][7][2], '@E 999,999'))+iif(8>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][8][2], '@E 999,999'))+iif(9>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][9][2], '@E 999,999'));
                   +iif(10>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][10][2], '@E 999,999'))+iif(11>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][11][2], '@E 999,999'))+iif(12>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][12][2], '@E 999,999'));
                   +iif(13>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][13][2], '@E 999,999'))+iif(14>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][14][2], '@E 999,999'))+iif(15>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][15][2], '@E 999,999'));
                   +iif(16>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][16][2], '@E 999,999'))+iif(17>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][17][2], '@E 999,999'))+iif(18>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][18][2], '@E 999,999'));
                   +iif(19>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][19][2], '@E 999,999'))+iif(20>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][20][2], '@E 999,999'))+iif(21>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][21][2], '@E 999,999'));
                   +iif(22>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][22][2], '@E 999,999'))+iif(23>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][23][2], '@E 999,999'))+iif(24>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][24][2], '@E 999,999'));
                   +iif(25>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][25][2], '@E 999,999'))+iif(26>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][26][2], '@E 999,999'))+iif(27>Len(_aProd[_x][2]),'',+space(1)+TransForm(_aProd[_x][2][27][2], '@E 999,999'));
                   +space(1)+TransForm(TotPrdQ, '@E 999,999')
    
    //R$
    @nLin++,00 PSAY "R$    "+iif(1>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][1][3], '@E 999,999'))+iif(2>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][2][3], '@E 999,999'))+iif(3>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][3][3], '@E 999,999'));
                   +iif(4>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][4][3], '@E 999,999'))+iif(5>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][5][3], '@E 999,999'))+iif(6>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][6][3], '@E 999,999'));
                   +iif(7>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][7][3], '@E 999,999'))+iif(8>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][8][3], '@E 999,999'))+iif(9>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][9][3], '@E 999,999'));
                   +iif(10>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][10][3], '@E 999,999'))+iif(11>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][11][3], '@E 999,999'))+iif(12>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][12][3], '@E 999,999'));
                   +iif(13>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][13][3], '@E 999,999'))+iif(14>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][14][3], '@E 999,999'))+iif(15>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][15][3], '@E 999,999'));
                   +iif(16>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][16][3], '@E 999,999'))+iif(17>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][17][3], '@E 999,999'))+iif(18>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][18][3], '@E 999,999'));
                   +iif(19>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][19][3], '@E 999,999'))+iif(20>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][20][3], '@E 999,999'))+iif(21>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][21][3], '@E 999,999'));
                   +iif(22>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][22][3], '@E 999,999'))+iif(23>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][23][3], '@E 999,999'))+iif(24>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][24][3], '@E 999,999'));
                   +iif(25>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][25][3], '@E 999,999'))+iif(26>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][26][3], '@E 999,999'))+iif(27>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][27][3], '@E 999,999'));
                   +space(1)+TransForm(TotPrdR, '@E 999,999')
    //Margem
   nCusto:=Posicione("SB5",1,xFilial('SB5') + _aProd[_x][1] ,"B5_CUSTO")
   nFator:=TotPrdR/TotPrdQ
//+space(1)+TransForm( iif( (TotPrdR/TotPrdQ ) > 0, ( ( (TotPrdR/TotPrdQ )*100/iif(nCusto>0,nCusto,1) ) ) - 100,0)  , '@E 999.999')
   @nLin++,00 PSAY  "Margem"+iif(1>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][1][4], '@E 9999.99'))+iif(2>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][2][4],   '@E 9999.99'))+iif(3>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][3][4],   '@E 9999.99'));
                   +iif(4>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][4][4],          '@E 9999.99'))+iif(5>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][5][4],   '@E 9999.99'))+iif(6>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][6][4],   '@E 9999.99'));
                   +iif(7>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][7][4],          '@E 9999.99'))+iif(8>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][8][4],   '@E 9999.99'))+iif(9>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][9][4],   '@E 9999.99'));
                   +iif(10>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][10][4],        '@E 9999.99'))+iif(11>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][11][4], '@E 9999.99'))+iif(12>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][12][4], '@E 9999.99'));
                   +iif(13>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][13][4],        '@E 9999.99'))+iif(14>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][14][4], '@E 9999.99'))+iif(15>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][15][4], '@E 9999.99'));
                   +iif(16>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][16][4],        '@E 9999.99'))+iif(17>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][17][4], '@E 9999.99'))+iif(18>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][18][4], '@E 9999.99'));
                   +iif(19>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][19][4],        '@E 9999.99'))+iif(20>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][20][4], '@E 9999.99'))+iif(21>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][21][4], '@E 9999.99'));
                   +iif(22>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][22][4],        '@E 9999.99'))+iif(23>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][23][4], '@E 9999.99'))+iif(24>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][24][4], '@E 9999.99'));
                   +iif(25>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][25][4],        '@E 9999.99'))+iif(26>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][26][4], '@E 9999.99'))+iif(27>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][27][4], '@E 9999.99'));
                   +space(1)+TransForm( (( nFator - nCusto) / nFator)*100  , '@E 9999.99')
// fator 
   @nLin++,00 PSAY  "Fator"+iif(1>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][1][5], '@E 9999.99'))+iif(2>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][2][5],   '@E 9999.99'))+iif(3>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][3][5],   '@E 9999.99'));
                   +iif(4>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][4][5],          '@E 9999.99'))+iif(5>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][5][5],   '@E 9999.99'))+iif(6>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][6][5],   '@E 9999.99'));
                   +iif(7>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][7][5],          '@E 9999.99'))+iif(8>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][8][5],   '@E 9999.99'))+iif(9>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][9][5],   '@E 9999.99'));
                   +iif(10>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][10][5],        '@E 9999.99'))+iif(11>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][11][5], '@E 9999.99'))+iif(12>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][12][5], '@E 9999.99'));
                   +iif(13>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][13][5],        '@E 9999.99'))+iif(14>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][14][5], '@E 9999.99'))+iif(15>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][15][5], '@E 9999.99'));
                   +iif(16>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][16][5],        '@E 9999.99'))+iif(17>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][17][5], '@E 9999.99'))+iif(18>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][18][5], '@E 9999.99'));
                   +iif(19>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][19][5],        '@E 9999.99'))+iif(20>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][20][5], '@E 9999.99'))+iif(21>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][21][5], '@E 9999.99'));
                   +iif(22>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][22][5],        '@E 9999.99'))+iif(23>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][23][5], '@E 9999.99'))+iif(24>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][24][5], '@E 9999.99'));
                   +iif(25>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][25][5],        '@E 9999.99'))+iif(26>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][26][5], '@E 9999.99'))+iif(27>Len(_aProd[_x][2]),'',+space(1)+TransForm( _aProd[_x][2][27][5], '@E 9999.99'));
                   +space(1)+TransForm( nFator   , '@E 9999.99')





   nLin++   
   //Total UN
   TotUN1+= iif(1>Len(_aProd[_x][2]),0,_aProd[_x][2][1][2])
   TotUN2+=iif(2>Len(_aProd[_x][2]),0,_aProd[_x][2][2][2])
   TotUN3+=iif(3>Len(_aProd[_x][2]),0,_aProd[_x][2][3][2])
   TotUN4+=iif(4>Len(_aProd[_x][2]),0,_aProd[_x][2][4][2])
   TotUN5+=iif(5>Len(_aProd[_x][2]),0,_aProd[_x][2][5][2])
   TotUN6+=iif(6>Len(_aProd[_x][2]),0,_aProd[_x][2][6][2])
   TotUN7+=iif(7>Len(_aProd[_x][2]),0,_aProd[_x][2][7][2])
   TotUN8+=iif(8>Len(_aProd[_x][2]),0,_aProd[_x][2][8][2])
   TotUN9+=iif(9>Len(_aProd[_x][2]),0,_aProd[_x][2][9][2])
   TotUN10+=iif(10>Len(_aProd[_x][2]),0,_aProd[_x][2][10][2])
   TotUN11+=iif(11>Len(_aProd[_x][2]),0,_aProd[_x][2][11][2])
   TotUN12+=iif(12>Len(_aProd[_x][2]),0,_aProd[_x][2][12][2])
   TotUN13+=iif(13>Len(_aProd[_x][2]),0,_aProd[_x][2][13][2])
   TotUN14+=iif(14>Len(_aProd[_x][2]),0,_aProd[_x][2][14][2])
   TotUN15+=iif(15>Len(_aProd[_x][2]),0,_aProd[_x][2][15][2])
   TotUN16+=iif(16>Len(_aProd[_x][2]),0,_aProd[_x][2][16][2])
   TotUN17+=iif(17>Len(_aProd[_x][2]),0,_aProd[_x][2][17][2])
   TotUN18+=iif(18>Len(_aProd[_x][2]),0,_aProd[_x][2][18][2])
   TotUN19+=iif(19>Len(_aProd[_x][2]),0,_aProd[_x][2][19][2])
   TotUN20+=iif(20>Len(_aProd[_x][2]),0,_aProd[_x][2][20][2])
   TotUN21+=iif(21>Len(_aProd[_x][2]),0,_aProd[_x][2][21][2])
   TotUN22+=iif(22>Len(_aProd[_x][2]),0,_aProd[_x][2][22][2])
   TotUN23+=iif(23>Len(_aProd[_x][2]),0,_aProd[_x][2][23][2])
   TotUN24+=iif(24>Len(_aProd[_x][2]),0,_aProd[_x][2][24][2])
   TotUN25+=iif(25>Len(_aProd[_x][2]),0,_aProd[_x][2][25][2])
   TotUN26+=iif(26>Len(_aProd[_x][2]),0,_aProd[_x][2][26][2])
   TotUN27+=iif(27>Len(_aProd[_x][2]),0,_aProd[_x][2][27][2])
   //Total R$
   TotR1+=iif(1>Len(_aProd[_x][2]),0,_aProd[_x][2][1][3])
   TotR2+=iif(2>Len(_aProd[_x][2]  ),0,_aProd[_x][2][2][3])
   TotR3+=iif(3>Len(_aProd[_x][2]),0,_aProd[_x][2][3][3])
   TotR4+=iif(4>Len(_aProd[_x][2]),0,_aProd[_x][2][4][3])
   TotR5+=iif(5>Len(_aProd[_x][2]),0,_aProd[_x][2][5][3])
   TotR6+=iif(6>Len(_aProd[_x][2]),0,_aProd[_x][2][6][3])
   TotR7+=iif(7>Len(_aProd[_x][2]),0,_aProd[_x][2][7][3])
   TotR8+=iif(8>Len(_aProd[_x][2]),0,_aProd[_x][2][8][3])
   TotR9+=iif(9>Len(_aProd[_x][2]),0,_aProd[_x][2][9][3])
   TotR10+=iif(10>Len(_aProd[_x][2]),0,_aProd[_x][2][10][3])
   TotR11+=iif(11>Len(_aProd[_x][2]),0,_aProd[_x][2][11][3])
   TotR12+=iif(12>Len(_aProd[_x][2]),0,_aProd[_x][2][12][3])
   TotR13+=iif(13>Len(_aProd[_x][2]),0,_aProd[_x][2][13][3])
   TotR14+=iif(14>Len(_aProd[_x][2]),0,_aProd[_x][2][14][3])
   TotR15+=iif(15>Len(_aProd[_x][2]),0,_aProd[_x][2][15][3])
   TotR16+=iif(16>Len(_aProd[_x][2]),0,_aProd[_x][2][16][3])
   TotR17+=iif(17>Len(_aProd[_x][2]),0,_aProd[_x][2][17][3])
   TotR18+=iif(18>Len(_aProd[_x][2]),0,_aProd[_x][2][18][3])
   TotR19+=iif(19>Len(_aProd[_x][2]),0,_aProd[_x][2][19][3])
   TotR20+=iif(20>Len(_aProd[_x][2]),0,_aProd[_x][2][20][3])
   TotR21+=iif(21>Len(_aProd[_x][2]),0,_aProd[_x][2][21][3])
   TotR22+=iif(22>Len(_aProd[_x][2]),0,_aProd[_x][2][22][3])
   TotR23+=iif(23>Len(_aProd[_x][2]),0,_aProd[_x][2][23][3])
   TotR24+=iif(24>Len(_aProd[_x][2]),0,_aProd[_x][2][24][3])
   TotR25+=iif(25>Len(_aProd[_x][2]),0,_aProd[_x][2][25][3])
   TotR26+=iif(26>Len(_aProd[_x][2]),0,_aProd[_x][2][26][3])
   TotR27+=iif(27>Len(_aProd[_x][2]),0,_aProd[_x][2][27][3])
Next

/*@nLin++,00 PSAY space(7)+iif(1>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(2>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(3>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(4>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(5>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(6>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(7>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(8>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(9>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(10>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(11>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(12>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(13>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(14>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(15>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(16>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(17>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(18>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(19>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(20>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(21>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+iif(22>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(23>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(24>Len(_aProd[1][2]),'',replicate('-',7));    
                        +space(1)+iif(25>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(26>Len(_aProd[1][2]),'',replicate('-',7))+space(1)+iif(27>Len(_aProd[1][2]),'',replicate('-',7));
                        +space(1)+replicate('-',7)

@nLin++,00 PSAY "Total "

TotUN:=TotUN1+TotUN2+TotUN3+TotUN4+TotUN5+TotUN6+TotUN7+TotUN8+TotUN9+TotUN10+TotUN11+TotUN12+TotUN13+TotUN14+TotUN15+TotUN16+TotUN17+TotUN18+TotUN19+TotUN20+TotUN21+TotUN22+TotUN23+TotUN24+TotUN25+TotUN26+TotUN27
TotR:=TotR1+TotR2+TotR3+TotR4+TotR5+TotR6+TotR7+TotR8+TotR9+TotR10+TotR11+TotR12+TotR13+TotR14+TotR15+TotR16+TotR17+TotR18+TotR19+TotR20+TotR21+TotR22+TotR23+TotR24+TotR25+TotR26+TotR27 

@nLin++,00 PSAY "UN    "+space(1)+iif(1>Len(_aProd[1][2]),'',TransForm( TotUN1, '@E 999,999'))+space(1)+iif(2>Len(_aProd[1][2]),'',TransForm( TotUN2, '@E 999,999'))+space(1)+iif(3>Len(_aProd[1][2]),'',TransForm( TotUN3, '@E 999,999'));
                        +space(1)+iif(4>Len(_aProd[1][2]),'',TransForm( TotUN4, '@E 999,999'))+space(1)+iif(5>Len(_aProd[1][2]),'',TransForm( TotUN5, '@E 999,999'))+space(1)+iif(6>Len(_aProd[1][2]),'',TransForm( TotUN6, '@E 999,999'));
                        +space(1)+iif(7>Len(_aProd[1][2]),'',TransForm( TotUN7, '@E 999,999'))+space(1)+iif(8>Len(_aProd[1][2]),'',TransForm( TotUN8, '@E 999,999'))+space(1)+iif(9>Len(_aProd[1][2]),'',TransForm( TotUN9, '@E 999,999'));
                        +space(1)+iif(10>Len(_aProd[1][2]),'',TransForm( TotUN10, '@E 999,999'))+space(1)+iif(11>Len(_aProd[1][2]),'',TransForm( TotUN11, '@E 999,999'))+space(1)+iif(12>Len(_aProd[1][2]),'',TransForm( TotUN12, '@E 999,999'));
                        +space(1)+iif(13>Len(_aProd[1][2]),'',TransForm( TotUN13, '@E 999,999'))+space(1)+iif(14>Len(_aProd[1][2]),'',TransForm( TotUN14, '@E 999,999'))+space(1)+iif(15>Len(_aProd[1][2]),'',TransForm( TotUN15, '@E 999,999'));
                        +space(1)+iif(16>Len(_aProd[1][2]),'',TransForm( TotUN16, '@E 999,999'))+space(1)+iif(17>Len(_aProd[1][2]),'',TransForm( TotUN17, '@E 999,999'))+space(1)+iif(18>Len(_aProd[1][2]),'',TransForm( TotUN18, '@E 999,999'));
                        +space(1)+iif(19>Len(_aProd[1][2]),'',TransForm( TotUN19, '@E 999,999'))+space(1)+iif(20>Len(_aProd[1][2]),'',TransForm( TotUN20, '@E 999,999'))+space(1)+iif(21>Len(_aProd[1][2]),'',TransForm( TotUN21, '@E 999,999'));
                        +space(1)+iif(22>Len(_aProd[1][2]),'',TransForm( TotUN22, '@E 999,999'))+space(1)+iif(23>Len(_aProd[1][2]),'',TransForm( TotUN23, '@E 999,999'))+space(1)+iif(24>Len(_aProd[1][2]),'',TransForm( TotUN24, '@E 999,999'));
                        +space(1)+iif(25>Len(_aProd[1][2]),'',TransForm( TotUN25, '@E 999,999'))+space(1)+iif(26>Len(_aProd[1][2]),'',TransForm( TotUN26, '@E 999,999'))+space(1)+iif(27>Len(_aProd[1][2]),'',TransForm( TotUN27, '@E 999,999'));
                        +space(1)+TransForm( TotUN, '@E 999,999')
                        

@nLin++,00 PSAY "R$    "+space(1)+iif(1>Len(_aProd[1][2]),'',TransForm( TotR1, '@E 999,999'))+space(1)+iif(2>Len(_aProd[1][2]),'',TransForm( TotR2, '@E 999,999'))+space(1)+iif(3>Len(_aProd[1][2]),'',TransForm( TotR3, '@E 999,999'));
                        +space(1)+iif(4>Len(_aProd[1][2]),'',TransForm( TotR4, '@E 999,999'))+space(1)+iif(5>Len(_aProd[1][2]),'',TransForm( TotR5, '@E 999,999'))+space(1)+iif(6>Len(_aProd[1][2]),'',TransForm( TotR6, '@E 999,999'));
                        +space(1)+iif(7>Len(_aProd[1][2]),'',TransForm( TotR7, '@E 999,999'))+space(1)+iif(8>Len(_aProd[1][2]),'',TransForm( TotR8, '@E 999,999'))+space(1)+iif(9>Len(_aProd[1][2]),'',TransForm( TotR9, '@E 999,999'));
                        +space(1)+iif(10>Len(_aProd[1][2]),'',TransForm( TotR10, '@E 999,999'))+space(1)+iif(11>Len(_aProd[1][2]),'',TransForm( TotR11, '@E 999,999'))+space(1)+iif(12>Len(_aProd[1][2]),'',TransForm( TotR12, '@E 999,999'));
                        +space(1)+iif(13>Len(_aProd[1][2]),'',TransForm( TotR13, '@E 999,999'))+space(1)+iif(14>Len(_aProd[1][2]),'',TransForm( TotR14, '@E 999,999'))+space(1)+iif(15>Len(_aProd[1][2]),'',TransForm( TotR15, '@E 999,999'));
                        +space(1)+iif(16>Len(_aProd[1][2]),'',TransForm( TotR16, '@E 999,999'))+space(1)+iif(17>Len(_aProd[1][2]),'',TransForm( TotR17, '@E 999,999'))+space(1)+iif(18>Len(_aProd[1][2]),'',TransForm( TotR18, '@E 999,999'));
                        +space(1)+iif(19>Len(_aProd[1][2]),'',TransForm( TotR19, '@E 999,999'))+space(1)+iif(20>Len(_aProd[1][2]),'',TransForm( TotR20, '@E 999,999'))+space(1)+iif(21>Len(_aProd[1][2]),'',TransForm( TotR21, '@E 999,999'));
                        +space(1)+iif(22>Len(_aProd[1][2]),'',TransForm( TotR22, '@E 999,999'))+space(1)+iif(23>Len(_aProd[1][2]),'',TransForm( TotR23, '@E 999,999'))+space(1)+iif(24>Len(_aProd[1][2]),'',TransForm( TotR24, '@E 999,999'));
                        +space(1)+iif(25>Len(_aProd[1][2]),'',TransForm( TotR25, '@E 999,999'))+space(1)+iif(26>Len(_aProd[1][2]),'',TransForm( TotR26, '@E 999,999'))+space(1)+iif(27>Len(_aProd[1][2]),'',TransForm( TotR27, '@E 999,999'));
                        +space(1)+TransForm( TotR, '@E 999,999')*/
//                        
@nLin++,00 PSAY space(7)+iif(1>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(2>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(3>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(4>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(5>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(6>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(7>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(8>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(9>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(10>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(11>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(12>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(13>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(14>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(15>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(16>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(17>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(18>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(19>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(20>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(21>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +iif(22>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(23>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(24>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));    
                        +iif(25>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(26>Len(_aProd[1][2]),'',+space(1)+replicate('-',7))+iif(27>Len(_aProd[1][2]),'',+space(1)+replicate('-',7));
                        +space(1)+replicate('-',7)

@nLin++,00 PSAY "Total "

TotUN:=TotUN1+TotUN2+TotUN3+TotUN4+TotUN5+TotUN6+TotUN7+TotUN8+TotUN9+TotUN10+TotUN11+TotUN12+TotUN13+TotUN14+TotUN15+TotUN16+TotUN17+TotUN18+TotUN19+TotUN20+TotUN21+TotUN22+TotUN23+TotUN24+TotUN25+TotUN26+TotUN27
TotR:=TotR1+TotR2+TotR3+TotR4+TotR5+TotR6+TotR7+TotR8+TotR9+TotR10+TotR11+TotR12+TotR13+TotR14+TotR15+TotR16+TotR17+TotR18+TotR19+TotR20+TotR21+TotR22+TotR23+TotR24+TotR25+TotR26+TotR27 

@nLin++,00 PSAY "UN    "+iif(1>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN1, '@E 999,999'))+iif(2>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN2, '@E 999,999'))+iif(3>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN3, '@E 999,999'));
                        +iif(4>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN4, '@E 999,999'))+iif(5>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN5, '@E 999,999'))+iif(6>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN6, '@E 999,999'));
                        +iif(7>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN7, '@E 999,999'))+iif(8>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN8, '@E 999,999'))+iif(9>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN9, '@E 999,999'));
                        +iif(10>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN10, '@E 999,999'))+iif(11>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN11, '@E 999,999'))+iif(12>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN12, '@E 999,999'));
                        +iif(13>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN13, '@E 999,999'))+iif(14>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN14, '@E 999,999'))+iif(15>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN15, '@E 999,999'));
                        +iif(16>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN16, '@E 999,999'))+iif(17>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN17, '@E 999,999'))+iif(18>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN18, '@E 999,999'));
                        +iif(19>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN19, '@E 999,999'))+iif(20>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN20, '@E 999,999'))+iif(21>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN21, '@E 999,999'));
                        +iif(22>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN22, '@E 999,999'))+iif(23>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN23, '@E 999,999'))+iif(24>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN24, '@E 999,999'));
                        +iif(25>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN25, '@E 999,999'))+iif(26>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN26, '@E 999,999'))+iif(27>Len(_aProd[1][2]),'',+space(1)+TransForm( TotUN27, '@E 999,999'));
                        +space(1)+TransForm( TotUN, '@E 999,999')
                        

@nLin++,00 PSAY "R$    "+iif(1>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR1, '@E 999,999'))+iif(2>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR2, '@E 999,999'))+iif(3>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR3, '@E 999,999'));
                        +iif(4>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR4, '@E 999,999'))+iif(5>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR5, '@E 999,999'))+iif(6>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR6, '@E 999,999'));
                        +iif(7>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR7, '@E 999,999'))+iif(8>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR8, '@E 999,999'))+iif(9>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR9, '@E 999,999'));
                        +iif(10>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR10, '@E 999,999'))+iif(11>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR11, '@E 999,999'))+iif(12>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR12, '@E 999,999'));
                        +iif(13>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR13, '@E 999,999'))+iif(14>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR14, '@E 999,999'))+iif(15>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR15, '@E 999,999'));
                        +iif(16>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR16, '@E 999,999'))+iif(17>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR17, '@E 999,999'))+iif(18>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR18, '@E 999,999'));
                        +iif(19>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR19, '@E 999,999'))+iif(20>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR20, '@E 999,999'))+iif(21>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR21, '@E 999,999'));
                        +iif(22>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR22, '@E 999,999'))+iif(23>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR23, '@E 999,999'))+iif(24>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR24, '@E 999,999'));
                        +iif(25>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR25, '@E 999,999'))+iif(26>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR26, '@E 999,999'))+iif(27>Len(_aProd[1][2]),'',+space(1)+TransForm( TotR27, '@E 999,999'));
                        +space(1)+TransForm( TotR, '@E 999,999')
//                        

//Informacoes Adcionais( Carteira,bonificacao,meta...)
@nLin++
@nLin++, 000 pSay "CARTEIRA PROGRAMADA UN: " +TransForm( round(Carteira( .F.,1 )[1][1],0), '@E 9,999,999' )+space(6)+"BONIFICAÇÕES        UN: " +transform( round(Bonifica()[2],0), '@E 9,999,999' )+space(6)+"VENDIDO NO MÊS       UN: "+ TransForm( round(pddMes()[1][1],0), "@E 9,999,999" )+space(6)+"PEDIDOS DE HOJE     UM: " + TransForm( iif(PediDia()[1][1]>0,ROUND(PediDia()[1][1],0),0), '@E 9,999' )  
@nLin++, 000 pSay "                    R$: " +TransForm( Carteira( .F.,1 )[1][2], '@E 9,999,999.99' )      +space(3)+"                    R$: " +transform( Bonifica()[1], '@E 9,999,999.99' )+space(3)+"                     R$: "+ TransForm( pddMes()[1][2], "@E 9,999,999.99" )+space(3)+"                    R$: " + TransForm( iif(PediDia()[1][2]>0,PediDia()[1][2],0), '@E 9,999,999.99' )
@nLin++

@nLin++, 000 pSay "CARTEIRA IMEDIATA   UN: " +TransForm( ROUND(Carteira( .F.,2 )[1][1],0), '@E 9,999,999' )+space(6)+"TOTAL GERAL         UN: " +transform( ROUND(TotUN+Carteira( .F.,2 )[1][1],0), '@E 9,999,999' )+space(6)+"META                 UN: " +transform( iif(!EMPTY(MV_PAR06),ROUND(meta(MV_PAR06)[1],0),iif(!EMPTY(MV_PAR07),ROUND(metaC(MV_PAR07)[1],0),iif(!EMPTY(MV_PAR08),ROUND(metaG(MV_PAR08)[1],0),ROUND(MV_PAR02,0)))), '@E 9,999,999' )+space(6)+"MEDIA DE DIAS PEDIDOS EM CARTEIRA " + transform( media(), '@E 999.99')  
@nLin++, 000 pSay "                    R$: " +TransForm( Carteira( .F.,2 )[1][2], '@E 9,999,999.99' )      +space(3)+"                    R$: " +transform( TotR +Carteira( .F.,2 )[1][2], '@E 9,999,999.99' )+space(3)+"                     R$: " +transform( iif(!EMPTY(MV_PAR06),meta(MV_PAR06)[2],iif(!EMPTY(MV_PAR07),metaC(MV_PAR07)[2],iif(!EMPTY(MV_PAR08),metaG(MV_PAR08)[2],MV_PAR03))), '@E 9,999,999.99' )+space(3)+"N. DIAS DO PEDIDO COM MAIS TEMPO EM CARTEIRA: " + iif( !empty(dDatMax),alltrim(str(dDataBase - dDatMax)), "0") + " dias"    

// estoque caixa
@nLin++
@nLin++, 000 pSay "ESTOQUE DE CAIXA: "+TransForm( round(estcaixa(),0), "@E 9,999,999" )+" UN"

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

Static Function Carteira( lDia, nTipo )

***************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar

Local aRet := {}

Default nTipo := 0

cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS CARTEIRA_UN, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cCart += "" + RetSqlName( "SA1" ) + " SA1 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cCart += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cCart += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT, AMOSTRA
cCart += "C6_CLI NOT IN ('031732','031733') and " // DESPREZA ENTRE FILIAIS
cCart += "SB1.B1_SETOR= '39' AND "// Caixa

cCart += " SC5.C5_FILIAL = SC6.C6_FILIAL AND " 
cCart += " SC6.C6_FILIAL = SC9.C9_FILIAL AND " 

If !empty(MV_PAR06) // Representante
    cCart += "SC5.C5_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") AND "
elseif !empty(MV_PAR07)//Coordenador
    cCart += "EXISTS( SELECT A3_SUPER "
    cCart += "          FROM "+RetSqlName("SA3")+" "
    cCart += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR08)//Gerente
    cCart += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cCart += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cCart += "and SA3.D_E_L_E_T_ != '*' ) AND  "
Endif

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cCart += "SA1.A1_EST = '"+MV_PAR04+"' AND "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cCart += "SA1.A1_EST != '"+MV_PAR05+"' AND "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cCart += "SA1.A1_EST = '"+MV_PAR04+"' AND SA1.A1_EST != '"+MV_PAR05+"' AND "
endIf

if nTipo = 1
  cCart += "SC5.C5_ENTREG > '"+Dtos(lastday(StoD(StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01')))  + "' and "
elseif nTipo = 2
  cCart += "SC5.C5_ENTREG <= '"+ Dtos(lastday(StoD(StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01'))) + "' and "
endif

/*
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cCart += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' '  "
*/

cCart += "SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.D_E_L_E_T_ = ' ' AND "
cCart += "SA1.D_E_L_E_T_ = ' ' "


cCart := ChangeQuery( cCart )
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")

If ! CARX->( EOF() )
   //So pego a Data do pedido mais antigo se for para carteira imediata
   if nTipo = 2
	  dDatMax := CARX->DAT
   endif
   aAdd( aRet, { CARX->CARTEIRA_UN, CARX->CARTEIRA_RS } )
Endif

CARX->( DbCloseArea() )

Return aRet



***************

Static Function PediDia()

***************
//Atualizado para filtrar estados
local cQuery := ''
local aRet := {}

cQuery += "select isnull(sum(C6_QTDVEN * C6_PRUNIT),0) CARTEIRA_RS, isnull(SUM( SC6.C6_QTDVEN ),0) AS CARTEIRA_UN "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1 "
//cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND "
cQuery += "where  A1_FILIAL = '"+xFilial('SA1')+"' AND "
cQuery += "SC5.C5_EMISSAO = '"+DTOS(dDatabase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR = '39' AND " //Caixa 

cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA  AND "

cQuery += " SC5.C5_FILIAL = SC6.C6_FILIAL AND " 
cQuery += "C6_CLI NOT IN ('031732','031733') AND "

If !empty(MV_PAR06) // Representante
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") AND "
elseif !empty(MV_PAR07)//Coordenador
    cQuery += "EXISTS( SELECT A3_SUPER "
    cQuery += "          FROM "+RetSqlName("SA3")+" "
    cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR08)//Gerente
    cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQuery += "and SA3.D_E_L_E_T_ != '*' )  AND "
Endif


if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST != '"+MV_PAR04+"' AND "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND SA1.A1_EST != '"+MV_PAR05+"' AND "
endIf

cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMPP'
TMPP->( dbGoTop() )

if ! TMPP->( EoF() )
	aAdd( aRet, { TMPP->CARTEIRA_UN, TMPP->CARTEIRA_RS } )
endIf
TMPP->( dbCloseArea() )

Return aRet

***************

Static Function bonifica()

***************

Local cQuery := ""
Local aRet   := {0,0}

cQuery += "select sum(D2_TOTAL) TOTAL_RS, sum(D2_QUANT-D2_QTDEDEV ) TOTAL_UN "
cQuery += "from "+retSqlName('SD2')+" SD2, "+retSqlName('SB1')+" SB1, "+retSqlName('SA1')+" SA1, "+retSqlName('SC5')+" SC5 "
cQuery += "where SD2.D2_TES = '514' and month(D2_EMISSAO) = '"+strZero(val(MV_PAR01),2)+"' and year(D2_EMISSAO) = '"+strZero(year(dDataBase),4)+"' "
cQuery += "and SD2.D2_COD = SB1.B1_COD and D2_PEDIDO = C5_NUM AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
//cQuery += "D2_FILIAL = '"+xFilial('SD2')+"' and B1_FILIAL = '"+xFilial('SB1')+"' and C5_FILIAL = '"+xFilial('SC5')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and "

cQuery += "SB1.B1_SETOR = '39'  AND " // Caixa 
cQuery += "D2_FILIAL=C5_FILIAL AND "
cQuery += "D2_CLIENTE NOT IN ('031732','031733') AND "

If !empty(MV_PAR06) // Representante
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") AND "
elseif !empty(MV_PAR07)//Coordenador
    cQuery += "EXISTS( SELECT A3_SUPER "
    cQuery += "          FROM "+RetSqlName("SA3")+" "
    cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' )  AND "
elseif !empty(MV_PAR08)//Gerente
    cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQuery += "and SA3.D_E_L_E_T_ != '*' )  AND "
Endif

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST != '"+MV_PAR05+"' AND "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND SA1.A1_EST != '"+MV_PAR05+"' AND "
endIf 

cQuery += "SD2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )

if _TMPK->( !EoF() )
	aRet[1]+= _TMPK->TOTAL_RS
	aRet[2]+= _TMPK->TOTAL_UN
endIf
_TMPK->( dbCloseArea() )
Return aRet

***************

Static Function meta(cVend)

***************
Local aRet   := {0,0}
Local cQuery := ''

cQuery := "select  Z7_VALOR,Z7_KILO from "+retSqlName("SZ7")+" where Z7_REPRESE = '"+cVend+"' "+;
				"and Z7_FILIAL = '"+xFilial('SZ7')+"' and D_E_L_E_T_ != '*' "+;
				"and Z7_TIPO ='CX' "+;
				"and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "+;
				"and substring(Z7_MESANO,3,6) = '"+ StrZero(Year(dDATABASE),4)+"'  "
				
				
TCQUERY cQuery NEW ALIAS '_TMPY'
_TMPY->( dbGoTop() )
if _TMPY->( !EoF() )  
   aRet[1]:=_TMPY->Z7_KILO
   aRet[2]:=_TMPY->Z7_VALOR
endIf
_TMPY->( dbCloseArea() )

Return aRet
***************

Static Function pddMes()

***************

Local cQuery := ""
Local aRet   := {}

cQuery += "select sum(C6_VALOR) TOTALRS, sum(C6_QTDVEN) TOTALUN "
cQuery += "from "+retSqlName('SC6')+" SC6, "+retSqlName('SC5')+" SC5, "+retSqlName('SB1')+" SB1, "+retSqlName('SA1')+" SA1, "+retSqlName('SF4')+" SF4 "
cQuery += "where C5_EMISSAO between '"+StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01'+"' and '"+Dtos(lastday(StoD(StrZero(Year(dDATABASE),4)+STRZERO(val(MV_PAR01),2)+'01')))+"' "
cQuery += "and C6_PRODUTO = B1_COD and C6_NUM = C5_NUM and C5_TIPO = 'N' "
cQuery += "AND B1_COD NOT in ('187','188','189','190','200','210') "
cQuery += "and F4_DUPLIC = 'S' and C6_TES = F4_CODIGO "
cQuery += "and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "

cQuery += "SB1.B1_SETOR = '39' AND " // Caixa 

If !empty(MV_PAR06) // Representante
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") AND "
elseif !empty(MV_PAR07)//Coordenador
    cQuery += " EXISTS( SELECT A3_SUPER "
    cQuery += "          FROM "+RetSqlName("SA3")+" "
    cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR08)//Gerente
    cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST != '"+MV_PAR05+"' AND "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND SA1.A1_EST != '"+MV_PAR05+"' AND "
endIf 

//cQuery += "C5_FILIAL = '"+xFilial('SC5')+"' and B1_FILIAL = '"+xFilial('SB1')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and C6_FILIAL = '"+xFilial('SC6')+"' "
cQuery += "C5_FILIAL =C6_FILIAL  AND C6_CLI NOT IN ('031732','031733') "
cQuery += "and SC6.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "

TCQUERY cQuery NEW ALIAS '_TMPZA'

_TMPZA->( dbGoTop() )

If !_TMPZA->(EoF())
	aAdd( aRet, { _TMPZA->TOTALUN, _TMPZA->TOTALRS } )
endif

_TMPZA->( dbCloseArea() )

Return aRet

***************

Static Function  media()

***************

local cQuery := ''
Local nDias := nDif := nCount := 0

cQuery := "SELECT distinct SC5.C5_NUM, SC5.C5_ENTREG "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cQuery += " " + RetSqlName( "SA1" )+ " SA1 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "

cQuery += "C5_FILIAL=C6_FILIAL AND "
cQuery += "C6_CLI NOT IN ('031732','031733') AND "

//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR = '39' AND " //  Caixa 

If !empty(MV_PAR06) // Representante
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR06+"','"+alltrim(MV_PAR06) +"VD'"+") AND "
elseif !empty(MV_PAR07)//Coordenador
    cQuery += " EXISTS( SELECT A3_SUPER "
    cQuery += "          FROM "+RetSqlName("SA3")+" "
    cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR07+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR08)//Gerente
    cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
    cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR08+"'  and SA3.D_E_L_E_T_ != '*' )  "
    cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif

if !empty(MV_PAR04) .and. empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND "
elseIf empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST != '"+MV_PAR05+"' AND "
elseIf !empty(MV_PAR04) .and. !empty(MV_PAR05)
	cQuery += "SA1.A1_EST = '"+MV_PAR04+"' AND SA1.A1_EST != '"+MV_PAR05+"' AND "
endIf 
/*
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
*/

cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' "


cQuery += "order by SC5.C5_NUM "


TCQUERY cQuery NEW ALIAS 'TMP'
TCSetField( 'TMP', 'C5_ENTREG', 'D' )
TMP->( dbGoTop() )

do while  ! TMP->( EoF() )
	nDias := dDataBase - TMP->C5_ENTREG	
	if nDias >= 0
	   	nDif += nDias
	   	nCount++
	endIf
	TMP->( dbSkip() )
endDo                                                          	

TMP->( dbCloseArea() )

return iif( nCount == 0, 0, nDif/nCount )




***************

Static Function metaC(cSuper)

***************
Local aRet   := {0,0}
Local cQuery := ""

cQuery :="select  SUM(Z7_VALOR) Z7_VALOR,SUM(Z7_KILO) Z7_KILO "  
cQuery +="from "+retSqlName("SZ7")+" SZ7 ,"+retSqlName("SA3")+" SA3 "
cQuery +="where A3_COD = Z7_REPRESE  "
cQuery +="AND A3_SUPER = '"+cSuper+"' "
cQuery +="and SZ7.D_E_L_E_T_ != '*' "
cQuery +="and Z7_TIPO ='CX' "
cQuery +="and SA3.D_E_L_E_T_ != '*' "
cQuery +="and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "
cQuery +="and substring(Z7_MESANO,3,6) = '"+ StrZero(Year(dDATABASE),4)+"'  "

TCQUERY cQuery NEW ALIAS '_TMPY'

_TMPY->( dbGoTop() )
if ! EMPTY(_TMPY->Z7_VALOR)   
    aRet[1]:=_TMPY->Z7_KILO
endIf
if ! EMPTY(_TMPY->Z7_KILO)   
   aRet[2]:=_TMPY->Z7_VALOR
endIf

_TMPY->( dbCloseArea() )

Return aRet


***************

Static Function metaG(cGeren)

***************
Local aRet   := {0,0}
Local cQuery := ""

cQuery :="select SUM(Z7_VALOR) Z7_VALOR,SUM(Z7_KILO) Z7_KILO "
cQuery +="from "+retSqlName("SZ7")+" SZ7 "
cQuery +="where Z7_REPRESE IN (SELECT A3_COD FROM SA3010 SA3 WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+cGeren+"'  and SA3.D_E_L_E_T_ != '*' )  and SA3.D_E_L_E_T_ != '*'  ) "
cQuery +="and SZ7.D_E_L_E_T_ != '*' "
cQuery +="and Z7_TIPO ='CX' "
cQuery +="and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "
cQuery +="and substring(Z7_MESANO,3,6) = '"+ StrZero(Year(dDATABASE),4)+"'  "
TCQUERY cQuery NEW ALIAS '_TMPY'

_TMPY->( dbGoTop() )
if ! EMPTY(_TMPY->Z7_VALOR)   
    aRet[1]:=_TMPY->Z7_KILO
endIf
if ! EMPTY(_TMPY->Z7_KILO)   
   aRet[2]:=_TMPY->Z7_VALOR
endIf
_TMPY->( dbCloseArea() )

Return aRet


*************************
static function estcaixa()
*************************

local cQuery 
local nEst

cQuery := "SELECT ISNULL(SUM(SB2.B2_QATU / SB1.B1_CONV),0) AS ESTOQUE "
cQuery += "FROM "+RetSqlName("SB2")+" SB2 WITH (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 WITH (NOLOCK) "
cQuery += "WHERE SB2.B2_COD = SB1.B1_COD AND SB2.B2_LOCAL = '01'"
cQuery += "AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA' "
cQuery += "AND LEN(SB1.B1_COD) <= 7 "
cQuery += "AND SB1.B1_SETOR = '39' "

//cQuery += "AND SB2.B2_FILIAL = "+ValToSql(xFilial("SB2"))+" AND SB2.D_E_L_E_T_ = '' "
//cQuery += "AND SB1.B1_FILIAL = "+ValToSql(xFilial("SB1"))+" AND SB1.D_E_L_E_T_ = '' "

TCQUERY cQuery NEW ALIAS "B2X"

nEst := B2X->ESTOQUE

B2X->(DbCloseArea())

return nEst

