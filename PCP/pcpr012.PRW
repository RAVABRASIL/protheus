#include "rwmake.ch"    
#include "topconn.ch"  


User Function PCPR012()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle de Parada de Maquina "
Local cPict          := ""
Local titulo         := "Resumo da Produção "
Local nLin           := 80
                      
Local Cabec1         := " "
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd           := {}  


public    nInc:=14 ,aResumo:={"Fabrica de Plastico","Fabrica de Caixa","Extrusoras","Costura"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR012" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


if !Pergunte("PCPR012",.T.) 
return 

endif


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
 
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//------------------------------------------------
Cabec(Titulo,".","",NomeProg,Tamanho,nTipo) 
nLin :=10
top_consulta(1,@nLin) 
complemento(@nLin)
@nLin+=5

top_consulta(2,@nLin) 
@nLin+=5

top_consulta(3,@nLin)  
@nLin+=5

top_consulta(4,@nLin)   
//------------------------------------------------

SET DEVICE TO SCREEN
 
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return      

     
Static Function Consulta(nInt)
cQ:=" select                                                                      " + CHR(10)
cQ+=" Z70_COD    COD    ,Z70_TIPO TIPO     , Z70_LINHA LINHA   ,                  " + CHR(10)
cQ+=" Z70_DIAUT  DIAUT  ,Z70_DIATAB DIATAB , Z70_METDIA METDIA ,                  " + CHR(10)
cQ+=" Z70_PRODIA PRODIA ,Z70_DTREC DTREC   , Z70_HRREC HRREC   ,Z70_USUREC USUREC " + CHR(10)
cQ+=" FROM "+ RetSqlName( "Z70" ) +" Z70 "                                         
//cQ+=" where Z70_DTREC="+dtos(dDatabase)                                             + CHR(10)
cQ+=" where Z70_DTREC between "+ dtos(MV_PAR01)+ " and "+dtos(MV_PAR02 )            + CHR(10)

cQ+=" and Z70_TIPO='"+alltrim(str(nInt))+"'"                                        + CHR(10)
cQ+=" and D_E_L_E_T_=' '"                                                           + CHR(10)
cQ+=" ORDER BY  Z70_LINHA                                                         " + CHR(10)
                                   
Return cQ      













***************
static function top_consulta(nInt,nLin)
***************
cQry:=Consulta(nInt)
TCQUERY cQry NEW ALIAS "AUX1"
          
              //    TOTAIS
nTMtmes   :=0 //   meta mes
nTMtDia   :=0 //   meta dia
nTAcmMes  :=0 //   acumulado mes
nTProACmes:=0 //   produzido mes
nTDifQnt  :=0 //   diferenca na quantidade
ntProDia  :=0 //   produzido no dia
x:=0

nInc:=14
nDiaTU := 0
nDiaTab:= 0  
if(AUX1->( EOF() )) 
AUX1->(DBCLOSEAREA())
return
endif
While AUX1->( !EOF() )  

if x==0
AUX1->( dbGoTop() ) 
nDiaUT := AUX1->DIAUT
nDiaTab:=AUX1->DIATAB   
@nLin,0  PSAY aResumo[nInt]
@nLin,40  PSAY 'Dias Uteis: ' +alltrim(str(AUX1->DIAUT  ))
@nLin,60 PSAY 'Dias Trabalhados: '+alltrim(str(AUX1->DIATAB ))
x:=1
nLin++  
ini:=0                                                      
@nLin,INI PSAY IIF(AUX1->TIPO!=3,"TURNO","EXTRUSORA")	
@nLin,INI+=nInc PSAY "Meta Do Mes"	
@nLin,INI+=nInc PSAY "Meta Do Dia"	
@nLin,INI+=nInc PSAY "Meta Acum"	
@nLin,INI+=nInc PSAY "Prod Acum"	
@nLin,INI+=nInc PSAY "Dif - Quant"	
@nLin,INI+=nInc PSAY "Dia Restante"		
@nLin,INI+=nInc PSAY "Prod No Dia "
  nLin++
endif


ini:=0   
 
      cLinha:=alltrim(upper(AUX1->LINHA))
     nMTMES:=AUX1->METDIA*AUX1->DIAUT 
     nMTDIA:=AUX1->METDIA
     nMTACU:=(nMtDia*DIAUT)/AUX1->DIAUT*AUX1->DIATAB
     @nLin,ini     PSAY  iif(cLinha=='A',"1ª Turno",iif(cLinha=='B',"2ª Turno",iif(cLinha=='C',"3ª Turno",cLinha)))
     @nLin,ini+=nInc PSAY  alltrim(str(nMtMes))
     @nLin,ini+=nInc PSAY  alltrim(str(nMtDia))
     @nLin,ini+=nInc PSAY /*'MTACU='+*/alltrim(str(nMtAcu)) 
         
        cQry:=""
		cQry+=" select sum(Z70_PRODIA) ACM                                     " +CHR(10)
		cQry+=" FROM "+ RetSqlName( "Z70" ) +" Z70                             " +CHR(10)
		//cQry+=" where "                                                          +CHR(10)
		//cQry+="	    datepart(MM,Z70_DTREC)=datepart(MM,'"+dtos(dDatabase)+"')" +CHR(10)
		//cQry+=" and datepart(yy,Z70_DTREC)=datepart(yy,'"+dtos(dDatabase)+"')" +CHR(10)
		/*
		 cQry+=" where                                                         " +CHR(10)
		 cQry+="	    month(Z70_DTREC)=month('"+dtos(dDatabase)+"')          " +CHR(10)
	     cQry+=" and year(Z70_DTREC)=year('"+dtos(dDatabase)+"')               " +CHR(10)
         cQry+=" and day(Z70_DTREC) between 1 and  day('"+dtos(dDatabase)+"' ) " +CHR(10)
		*/
		cQry+=" where                                                         " +CHR(10)
		cQry+="   Z70_DTREC  between "+substr(dtos(MV_PAR02),1,6)+"01  and  "+dtos(MV_PAR02)+"    " +CHR(10)
		
		cQry+=" and Z70_TIPO= '"+alltrim(str(AUX1->TIPO) ) + "'"                 +CHR(10)
		cQry+=" AND Z70_LINHA="+valtoSql(AUX1->LINHA)                            +CHR(10) 
		cQRY+=" and D_E_L_E_T_=' '"                                              + CHR(10)
		TCQUERY cQry NEW ALIAS "AUX3"
		 
		nPROACM:=AUX3->ACM
		@nLin,ini+=nInc PSAY /*'PROACM='+*/alltrim(str(nPROACM)) //prod acumulado 
		
	   	nDIF:= nPROACM - nMtAcu
	   //	nDIF:=nMtAcu-nPROACM
	    @nLin,ini+=nInc PSAY /*'DIF='+*/alltrim(str(nDIF))     
	    
	 nDiamDia:=AUX1->DIAUT-AUX1->DIATAB 
     	        
     @nLin,ini+=nInc PSAY /*'STATUS='+*/iif(nDIF <0,  alltrim(str( int(((nMTMES)-nPROACM) /(nDiamDia)))),"OK") 
     AUX3->(DBCLOSEAREA())
     nPRODIA:=AUX1->PRODIA 
     @nLin,ini+=nInc PSAY /*'PRODIA='*+*/alltrim(str(nPRODIA))  
     
nTMtmes   += nMTMES   //   meta mes
nTMtDia   += nMtDia   //   meta dia
nTAcmMes  +=  nMtacu  //   acumulado mes
nTProACmes+=  nPROACM //   produzido mes
nTDifQnt  +=  nDIF    //   diferenca na quantidade
ntProDia  +=  nPRODIA //   produzido no dia
     
     
     nLin++
AUX1->(dbskip())          
EndDo 
@nLin,0 PSAY replicate("_",120)
nLin++
ini:=0  
@nLin,INI PSAY "TOTAL "
     @nLin,ini+=nInc PSAY  alltrim(str(nTMtmes))
     @nLin,ini+=nInc PSAY  alltrim(str(nTMtDia))
     @nLin,ini+=nInc PSAY  alltrim(str(nTMtmes/nDiaUT*nDiaTab)) 
     @nLin,ini+=nInc PSAY  alltrim(str(nTProACmes))
     nTDif:=nTProACmes-nTAcmMes  
	 @nLin,ini+=nInc PSAY  alltrim(str(nTProACmes-nTAcmMes))     
	    
	 nTDiamDia:=nDiaUT-nDIATAB    
     @nLin,ini+=nInc PSAY  iif(nTDif <0,  alltrim(str( int(((nTMtmes)-nTProACmes) /(nTDiamDia)))),"OK") 
     @nLin,ini+=nInc PSAY  alltrim(str(ntProDia))  
 
AUX1->(DBCLOSEAREA())
 

return  






static function Complemento(nLin)

cQry:=" " 
cQry+=" select                                                                " + chr(10)
cQry+=" Z71_COD   COD  ,Z71_APARAP APARAP ,Z71_RPCS  RPCS,                    " + chr(10)
cQry+=" Z71_RPUTZ RPUTZ,Z71_APCS   APCS   ,Z71_APEXT APEXT,                   " + chr(10)
cQry+=" Z71_APUTZ APUTZ,Z71_APTST  APTST  ,Z71_RPCSA PRCSA ,Z71_RPUTZA RPUTZA " + chr(10)
cQry+=" FROM " + RetSqlName( "Z71" ) +" Z71 "                                   + chr(10)
cQry+=" where                                                                 " + chr(10)
cQry+=" Z71_COD=(                                                             " + chr(10)
cQry+="          SELECT Z70_COD FROM "+ RetSqlName( "Z70" ) +" Z70 "            + chr(10)
cQry+="          WHERE Z70_DTREC="+dtos(dDatabase)                              + chr(10)
cQry+="          and Z70_TIPO='1'                                             " + chr(10)
cQry+="          AND Z70_LINHA='C'                                            " + chr(10)
cQRY+="          and D_E_L_E_T_=' '"                                             + CHR(10)
cQry+="         )                                                             " + chr(10)



TCQUERY cQry NEW ALIAS "AUX2"
ini:=0
nLin+=2  

While AUX2->( !EOF() )
ini:=0  
@nLin,ini         PSAY "Apara :"+alltrim(str(round(AUX2->APARAP,2)))+" %"
@nLin,ini+=nInc*2 PSAY "Apara Cs:"+alltrim(str(AUX2->APCS ))
@nLin,ini+=nInc*2 PSAY "Reprovacao Cs Atual:"+alltrim(str(AUX2->PRCSA ))
ini:=0 
nLin++

@nLin,ini         PSAY "Reprovacao Cs:"+alltrim(str(AUX2->RPCS ))
@nLin,ini+=nInc*2 PSAY "Apara Ext:"+alltrim(str(AUX2->APEXT ))
@nLin,ini+=nInc*2 PSAY "Reprovacao UTZ atual:"+alltrim(str(AUX2->RPUTZA ))
ini:=0  
nLin++

@nLin,ini         PSAY "Reprovacao UTZ:"+alltrim(str(AUX2->RPUTZ ))
@nLin,ini+=nInc*2 PSAY "Apara UTZ:"+alltrim(str(AUX2->APUTZ ))
		cQry:=""
		cQry+=" select sum(Z70_PRODIA) ACM                                     " +CHR(10)
		cQry+=" FROM "+ RetSqlName( "Z70" ) +" Z70                             " +CHR(10)
		cQry+=" where datepart(MM,Z70_DTREC)=datepart(MM,'"+dtos(dDatabase)+"')" +CHR(10)
		cQry+=" and Z70_TIPO= '3'"                       +CHR(10)  
		cQRY+=" and D_E_L_E_T_=' '"                                                            + CHR(10)
		TCQUERY cQry NEW ALIAS "AUX4"   
		nSomaAP:= AUX2->APCS+AUX2->APEXT+AUX2->APUTZ-AUX2->APTST 
		@nLin,ini+=nInc*2 PSAY "Apara Atual "+ alltrim(str(round(nSomaAP/(AUX2->APEXT+AUX4->ACM)*100,2)))+" %"
		 AUX4->(DBCLOSEAREA())
		ini:=0
		nLin++ 

@nLin,ini+=nInc*2 PSAY "Apara Teste:"+ alltrim(str(AUX2->APTST )) 
ini:=0
nLin++
   
   

@nLin,ini+=nInc*2 PSAY "Apara Total:"+ alltrim(str(AUX2->APCS+AUX2->APEXT+AUX2->APUTZ ))
 
nLin++
AUX2->(dbskip())          
EndDo 
AUX2->(DBCLOSEAREA())



return