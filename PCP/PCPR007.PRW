#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

// _______________________________________________________________________
//| Programa  |  PCPR007                                Data: 25/01/2010  |
//|¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
//| Autor     |  Rubem Duarte Oliota	                                  |
//|¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
//| Uso       | Controle de Qualidade                                     |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


User Function PCPR007()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle de Qualidade"
Local cPict          := ""
Local titulo         := "Controle de Qualidade"
Local nLin           := 0       //10       20         30       40        50        60        70        80         90       100       110       120       130       140       150       160       170       180       190       200       210
                       //123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|
Local Cabec1         := ""
Local Cabec2         := ""

Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR007" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "" 


if !Pergunte("PCPR07",.T.) 
return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"PCPR07",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/01/10   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
//±±º          ³ monta a janela com a regua de processamento.               º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ Programa principal                                         º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''
Local cQry2:=''
Local cQry3:='' 
Local aQry:={"","",""}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTurno:={"a','A","b','B","c','C"}//,"A','B','C"} 
cQry:=""
// ao debugar pode se pegar a QUERY ja identada
// para usar no SQL Server
aCampo:={;
         "LMAEX" ,"LMACS" ,"LMEEX" ,"LMECS" ,"ESPMA" ,"ESPME" ,"COMPMA","COMPME",;
         "BCSACL","BCSACT","BCSADS","SLDFRI","SLDQUE","ABA"   ,"IMPDES","QNTMA" ,"QNTME" ,;
         "SANF"  ,"PREGA" ,"MALSEL","IMPERF","EMBIMP","EMBAMA","EMBAME","FARDO"          ,;
         "AMOSTR","FARDAO","PACOTE","TON"   ,"ROLOS" ,;
         "BLOCAD","ALCFIN","ALCRUI","ALCCOR","ALINHA","SLDMAN","SLDAR" ,"APAREN","PICOTE",;
         "DISTMA","DISTME","SLDH2O" ;
        }    


cQry+=" select "+chr(13)
cQry+="      Z49_MAQ MAQ              " +chr(13)  //  
for x:=1 to len(aCampo)
cQry+="      ,SUM(Z49_"+aCampo[x]+"  ) "+aCampo[x]+"  " +chr(13)  // aCampo {} 
next x                                      
cQry+=" from " +RetSqlName("Z49")+" Z49 "+chr(13) 
cQry+=" where" +chr(13)
cQry+="     Z49_MESANO  =  '"+strtran(mv_par01,"/","")+"'  AND "+chr(13)
cQry+="     Z49_TURNO  in ('"+(aTURNO[mv_par02] )+"') AND "+chr(13) 
cQry+="     D_E_L_E_T_ = ''                                    "+chr(13)
cQry+="     Group by     Z49_MAQ                               "+chr(13)
TCQUERY cQry NEW ALIAS "AUX1" 


   
aCampo2:={;
         "LMAEX" ,"LMACS" ,"LMEEX" ,"LMECS" ,;
         "ESPMA" ,"ESPME" ,"COMPMA","COMPME","BCSACL" ,"BCSACT","BCSADS",;
         "SLDFRI","SLDQUE","ABA"   ,"IMPDES","QNTMA"  ,"QNTME" ,;
         "SANF"  ,"PREGA" ,"TON"   ,"MALSEL", "IMPERF","EMBIMP","EMBAMA","EMBAME",;
         "APAREN","DISTMA","DISTME","PICOTE","SLDMAN","SLDAR","SLDH2O",;
         "BLOCAD","ALCFIN","ALCRUI","ALCCOR","ALINHA",;
         "FARDO" ,"AMOSTR","FARDAO","PACOTE","ROLOS";
        } 
           
 aMAQ:={"","","",""}
                       
for x:=1 to len(aMAQ	)
  aMAQ[x]:=" select  "+chr(13)
  aMAQ[x]+="       Z49_MAQ MAQ " +chr(13)
 // aMAQ[x]+="       SUM(Z49_"+aCampo2[1]+"   ) "+aCampo2[1]+" " +chr(13)           
   for y:=1 to len(aCampo2)
    aMAQ[x]+="     ,SUM(Z49_"+aCampo2[y]+"   ) "+aCampo2[y]+" " +chr(13) 
   next y 
  aMAQ[x]+=" from Z49020 Z49 "+chr(13) 
  aMAQ[x]+=" where           "+chr(13) 
  aMAQ[x]+="     Z49_MESANO  =  '"+strtran(mv_par01,"/","")+ "'  AND "+chr(13) 
     if x!=4 
  aMAQ[x]+="     Z49_TURNO  in ('"+(aTURNO[x] )+ "') AND "+chr(13)
    endif 
    if x==4 
  aMAQ[x]+="     Z49_TURNO  in ('a','A','b','B','c','C') AND "+chr(13)
    endif 
  aMAQ[x]+="     D_E_L_E_T_ = '' "+chr(13)
  aMAQ[x]+=" group by Z49_MAQ"+chr(13)  

  TCQUERY aMAQ[x] NEW ALIAS "MAQ"+alltrim(str(x))    
 Next x

                           
                                      //Continuar essa QUERY GRAFICO GERAL...
cQry3:=" select  "+chr(13)
//cQry3+="       Z49_MAQ  " +chr(13)
cQry3+="     SUM(Z49_"+aCampo2[1]+"   ) "+aCampo2[1]+" " +chr(13)              
for x:=2 to len(aCampo2)
cQry3+="     ,SUM(Z49_"+aCampo2[x]+"   ) "+aCampo2[x]+" " +chr(13) 
next x 
cQry3+=" from Z49020 Z49 "+chr(13) 
cQry3+=" where           "+chr(13) 
cQry3+="     Z49_MESANO  =  '"+strtran(mv_par01,"/","")+ "'  AND "+chr(13) 
cQry3+="     Z49_MAQ not like ('P0%') AND "+chr(13) 
cQry3+="     D_E_L_E_T_ = '' "+chr(13) 
//cQry3+=" group by Z49_MAQ"+chr(13) 
TCQUERY cQry3 NEW ALIAS "TUR4" 




    
    
for x:=1 to len(aTURNO)
  aQry[x]:=" select  "+chr(13)
//  aQry[x]+="       Z49_MAQ  " +chr(13) 
  aQry[x]+="       SUM(Z49_"+aCampo2[1]+"   ) "+aCampo2[1]+" " +chr(13)           
   for y:=2 to len(aCampo2)
    aQry[x]+="     ,SUM(Z49_"+aCampo2[y]+"   ) "+aCampo2[y]+" " +chr(13) 
   next y 
  aQry[x]+=" from Z49020 Z49 "+chr(13) 
  aQry[x]+=" where           "+chr(13) 
  aQry[x]+="     Z49_MESANO  =  '"+strtran(mv_par01,"/","")+ "'  AND "+chr(13) 
  aQry[x]+="     Z49_MAQ not like ('P0%') AND "+chr(13) 
  aQry[x]+="     Z49_TURNO  in ('"+(aTURNO[x] )+ "') AND "+chr(13) 
  aQry[x]+="     D_E_L_E_T_ = '' "+chr(13) 
//  aQry[x]+=" group by Z49_MAQ"+chr(13) 
  TCQUERY aQry[x] NEW ALIAS "TUR"+alltrim(str(x))    
 Next x   
    
    


AUX1->(dbGoTop())
if AUX1->(EOF()) 
AUX1-> ( DbCloseArea() )
SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()
Return    
endif
SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
ImpMAqs(@Titulo,@Cabec1,@Cabec2,@NomeProg,@Tamanho,@nTipo,@nLin,.T.)
 
 AUX1-> ( DbCloseArea() ) 

   aMAQ:={"MAQ1->","MAQ2->","MAQ3->","MAQ4->"}

  ImpPERIODO(@Titulo,@Cabec1,@Cabec2,@NomeProg,@Tamanho,@nTipo,@nLin,aMAQ)  
  
  MAQ1-> ( DbCloseArea() )
  MAQ2-> ( DbCloseArea() )
  MAQ3-> ( DbCloseArea() )
  MAQ4-> ( DbCloseArea() )
 // MAQ1-> ( DbCloseArea() )
      
        
                 
  aQry:={"TUR1->","TUR2->","TUR3->","TUR4->"} 
  Cabec1:="GRAFICO GERAL                      A                             B                             C                        A + B + C"
  Cabec2:="MOTIVO                           Erros      %                  Erros      %                  Erros     %                  Erros       %        "
  
  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
  nLin := 9
  ImpGeral(@nLin,aQry)
 // &("TUR"+alltrim(str(z))+"-> ( DbCloseArea() )")
   
    for z:=1 to len(aQry)
 &("TUR"+alltrim(str(z))+"-> ( DbCloseArea() )")     
   next z
           




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

// FUNÇÕES   









**************************************************************************
Static Function ImpMAqs(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,lGeral)
**************************************************************************
Local C0E0 := S0 := P0 := 0  
Cabec1 := " MAQ |LARGMAIOR|LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA| IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL" 
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin:=8  
TAB:=3   
                 
//     " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA |IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL"
 cDIV:="    |          |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |      |       |       |       |      |       |       |       |      "
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
//     " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|ROLOS |PREGA |MALSEL|IMPERF|EMBAMA| EMBAME| FARDO |AMOSTR |FARDAO|TOTAL"
cDIV2:="    |          |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |      |       |       |       |      |     "
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//     " MAQ|LARGMAIOR |LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|AMOSTR|ALCCOR|PACOTE| TOTAL "  
cDIV3:="    |          |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |       "
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                 
       

While AUX1->( !EOF() )   

C0E0++

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
      if upper(substr(AUX1->MAQ,1,2)) $ ("C0") .and.upper( substr(AUX1->MAQ,3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA| IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL" 
      endif 
    
      if upper(substr(AUX1->MAQ,1,2)) $ ("P0") .and.upper( substr(AUX1->MAQ,3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|AMOSTR|ALCCOR|PACOTE| TOTAL " 
      endif 
    
      if upper(substr(AUX1->MAQ,1,2)) $ ("S0") .and.upper( substr(AUX1->MAQ,3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|ROLOS |PREGA |MALSEL|IMPERF|EMBAMA| EMBAME| FARDO |AMOSTR |FARDAO|TOTAL" 
      endif 
      
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
//           10        20        30        40        50        60        70        80         90       100       110       120       130       140       150       160       170       180       190       200       210
//  123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|
// " MAQ|LARGMAIOR| LARGMENOR| ESPMA| ESPME| COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA| IMPDES| QNTMA| QNTME| SANF| PREGA| MALSEL| MPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL"
   
    if upper(substr(AUX1->MAQ,1,2)) $ ("P0") .and.upper( substr(AUX1->MAQ,3,1))!='0' .and. P0 ==0 
      @++nLin,00 PSAY     replicate("¯",limite)
      Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|PREGA |MALSEL|IMPERF|EMBAMA|EMBAME| FARDO |AMOSTR |FARDAO |ROLOS |TOTAL" 
        
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      P0:=1
    endif
    
    
    if upper(substr(AUX1->MAQ,1,2)) $ ("S0") .and.upper( substr(AUX1->MAQ,3,1))!='0' .and. S0 ==0 
      @++nLin,00 PSAY     replicate("¯",limite)
      Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|ALCCOR|AMOSTR|PACOTE| TOTAL " 
      
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      S0:=1
    endif 
  IniDados(AUX1->MAQ,@nLin,@lGeral)//dados comuns a todos
    
  ImpDados(AUX1->MAQ,@nLin,@lGeral)//verifica os dados para imprimir
  
  
   IncRegua()
   AUX1->  ( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo
 @++nLin,00 PSAY     replicate("¯",limite)
      

  

 
return


***************
static function Calcula(nPar1,nPar2)
***************  
return  iif(IFdiv(nPar1,nPar2 ) ,ImpDiv(nPar1,nPar2)," 0") +"%"   
      

***************
static function IFdiv(nPar1,nPar2)
***************
return (nPar1  !=0 .AND. nPar2 !=0)
       

***************
static function ImpDiv(nPar1,nPar2)
***************
return (alltrim(str(round((npar1 /npar2 )*100,2))))
                                                     


***************
static function DIV(cMaq)
***************

   if upper(substr(cMaq,1,2)) $ ("C0") .and.upper( substr(cMaq,3,1))!='0'  
   return cDiv  
   endif     
   
   if upper(substr(cMaq,1,2)) $ ("P0")    .and.upper( substr(cMaq,3,1))!='0'  
   return cDiv2  
   endif 
   
   if upper(substr(cMaq,1,2)) $ ("S0")    .and.upper( substr(cMaq,3,1))!='0'  
   return cDiv3  
   endif  
   
   
return Nil
   
   
***************
static function ImpDados(cMaq,nLin)
***************        

if upper(substr(cMaq,1,2)) $ ("C0") .and.upper( substr(cMaq,3,1))!='0'
   DadosCS(@nLin)
   endif
   if upper(substr(cMaq,1,2)) $ ("S0") .and.upper( substr(cMaq,3,1))!='0'
   DadosSA(@nLin)    
   endif
   if upper(substr(cMaq,1,2)) $ ("P0") .and.upper( substr(cMaq,3,1))!='0'
   DadosPC(@nLin)    
   endif
return Nil                      




***************
static function DadosCS(nLin)
***************  

Local aPos  :={;
          58,66,74,82,90,104,;
         112,118,126,132,138,146,154,;
         162,170,177,185,192,200;
        }
Local aDados:={;
          AUX1->BCSACL , AUX1->BCSACT , AUX1->BCSADS , AUX1->SLDFRI , AUX1->SLDQUE , AUX1->IMPDES ,        ;
          AUX1->QNTMA  , AUX1->QNTME  , AUX1->SANF   , AUX1->PREGA  , AUX1->MALSEL , AUX1->IMPERF , AUX1->EMBIMP,;
          AUX1->EMBAMA , AUX1->EMBAME , AUX1->FARDO  , AUX1->AMOSTR , AUX1->FARDAO , AUX1->PACOTE ;
        }
        
    for x:=1 to len (aDados) 
    @nLin,aPos[x]  PSAY      alltrim(str(aDados[x]))
     
    next x
     
   nX1:=;
     ;//AUX1->LMAEX+AUX1->LMACS       + ;
        AUX1->LMEEX+AUX1->LMECS       + ;
        AUX1->ESPMA  + AUX1->ESPME  + ;
        AUX1->COMPMA + AUX1->COMPME + ;
        AUX1->BCSACL + AUX1->BCSACT + AUX1->BCSADS+;
        AUX1->SLDFRI + AUX1->SLDQUE + ;
        AUX1->ABA    + AUX1->IMPDES + ;
        AUX1->QNTMA  + AUX1->QNTME  + ;
        AUX1->SANF   + AUX1->PREGA  + ;
        AUX1->MALSEL + ; 
        AUX1->IMPERF + AUX1->EMBIMP + ;
        AUX1->EMBAMA + AUX1->EMBAME 
        
   nX2:=AUX1->FARDO  + AUX1->AMOSTR + ;
        AUX1->FARDAO + AUX1->PACOTE     
 
   @nLin,207  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"  
// percentual     
   ImpTodos(@nLin)// dados comuns a todos 
 
aPos  :={;
           57, 65, 73, 81, 89,103,111,117,;
          125,131,138,145,153,161,169;
        }  
aDados:={;
         AUX1->BCSACL, AUX1->BCSACT , AUX1->BCSADS , AUX1->SLDFRI , AUX1->SLDQUE , AUX1->IMPDES , AUX1->QNTMA  , AUX1->QNTME ,;
         AUX1->SANF  , AUX1->PREGA  , AUX1->MALSEL , AUX1->IMPERF , AUX1->EMBIMP , AUX1->EMBAMA , AUX1->EMBAME ;
        } 
              
      for x:=1 to len (aDados)  
        if    x==11 .or. x==12
          @nLin,aPos[x]   PSAY    Calcula(aDados[x], AUX1->FARDO )
 
        else
          @nLin,aPos[x]   PSAY    Calcula(aDados[x], AUX1->AMOSTR )
           
        endif 
   next x 
return NIl


                

***************
static function DadosPC(nLin)  
***************   

Local aPos  :={;
          58, 66, 74, 82, 90,104,112,118,;
         125,132,139,146,154,162,170,177;
        }
Local aDados:={;
        AUX1->APAREN , AUX1->SLDH2O , AUX1->SLDAR , AUX1->SLDMAN , AUX1->PICOTE , AUX1->DISTMA , AUX1->DISTME , AUX1->PREGA,;
        AUX1->MALSEL , AUX1->IMPERF ,AUX1->EMBAMA , AUX1->EMBAME , AUX1->FARDO  , AUX1->AMOSTR , AUX1->FARDAO , AUX1->ROLOS ;
        } 
        
 for x:=1 to len(aDados)   
  @nLin,aPos[x]   PSAY    alltrim(str(aDados[x]))
 next x
     
   nX1:=;
      ;//AUX1->LMAEX+AUX1->LMACS    + ;
        AUX1->LMEEX+AUX1->LMECS     + ;
        AUX1->ESPMA  + AUX1->ESPME  + ;
        AUX1->COMPMA + AUX1->COMPME + ;
        AUX1->ABA    + ;
        AUX1->APAREN + ;
        AUX1->DISTMA + AUX1->DISTME + ;
        AUX1->PICOTE + AUX1->SLDMAN + ;
        AUX1->SLDAR  + AUX1->SLDH2O + ;
        AUX1->PREGA  + ;
        AUX1->MALSEL + ;
        AUX1->IMPERF + ;
        AUX1->EMBAMA + AUX1->EMBAME
        
   nX2:= AUX1->FARDO  + ;
         AUX1->AMOSTR + ;
         AUX1->FARDAO + ;
         AUX1->ROLOS     

   @nLin,184  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"

// percentual     
   ImpTodos(@nLin)// dados comuns a todos 

aPos  :={;
          57, 65, 73, 81, 89,103,111,;
         117,124,131,138,145;
        }
aDados:={;
        AUX1->APAREN,AUX1->SLDH2O,AUX1->SLDAR,AUX1->SLDMAN,AUX1->PICOTE,AUX1->DISTMA,AUX1->DISTME,;
        AUX1->PREGA,AUX1->MALSEL,AUX1->IMPERF,AUX1->EMBAMA ,AUX1->EMBAME;
        }      
        
   for x:=1 to len (aDados)  
        if    x==9 .or. x==10
          @nLin,aPos[x]   PSAY    Calcula(aDados[x], AUX1->FARDO )
           
        elseif x==11 .or. x==12
          @nLin,aPos[x]   PSAY    Calcula(aDados[x], AUX1->ROLOS )  
          
        else
          @nLin,aPos[x]   PSAY    Calcula(aDados[x], AUX1->AMOSTR )
           
        endif 
   next x  
   
return Nil        

***************
static function DadosSA(nLin)
***************
Local aPos  :={;
           58, 66, 74, 82, 90,104,;
          113,119,126,132,139;
         }
Local aDados:={;
          AUX1->ALCFIN , AUX1->ALCRUI ,  AUX1->BLOCAD ,AUX1->SLDFRI , AUX1->SLDQUE , AUX1->ALINHA  ,;
          AUX1->QNTMA  , AUX1->QNTME  , AUX1->ALCCOR  , AUX1->AMOSTR, AUX1->PACOTE;
         } 
         
   for x:=1 to len(aDados)   
    @nLin,aPos[x]   PSAY      alltrim(str(aDados[x])) 
   next x
    
   nX1:=;
        AUX1->LMAEX+AUX1->LMACS     + ;
        AUX1->LMEEX+AUX1->LMECS     + ;
        AUX1->ESPMA  + AUX1->ESPME  + ;
        AUX1->COMPMA + AUX1->COMPME + ;
        AUX1->ABA    +;
        AUX1->ALCCOR + AUX1->ALCFIN + AUX1->ALCRUI + ;
        AUX1->SLDQUE + AUX1->SLDFRI + ;
        AUX1->QNTMA  + AUX1->QNTME  + ;
        AUX1->TON    + ;
        AUX1->BLOCAD + ;
        AUX1->ALINHA  
        
   nX2:= AUX1->AMOSTR + AUX1->PACOTE     

   @nLin,147  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"   
   
// percentual     
   ImpTodos(@nLin)// dados comuns a todos 
   
 aPos  :={;
          57 , 65,73,;
          81, 89,103,;
          112,118,125;
         }
 aDados:={;
          AUX1->ALCFIN , AUX1->ALCRUI ,  AUX1->BLOCAD ,;
          AUX1->SLDFRI , AUX1->SLDQUE , AUX1->ALINHA  ,;
          AUX1->QNTMA  , AUX1->QNTME  , AUX1->ALCCOR  ;
         } 
         
 for x:=1 to len (aDados)  
    if x==7 .or. x==8  
     @nLin,aPos[x]   PSAY  Calcula( aDados[x] , AUX1->PACOTE )
    else
     @nLin,aPos[x]   PSAY  Calcula( aDados[x] , AUX1->AMOSTR )   
    endif 
 next x
  
   return NIl           

*****************************************
static function IniDados(cMaq,nLin,lGeral)
*****************************************  



Local aPos:={6,17,27,34,41,49,97}  
  
Local aDados:={;
                AUX1->LMAEX+AUX1->LMACS,;
                AUX1->LMEEX+AUX1->LMECS,;
                AUX1->ESPMA,AUX1->ESPME,;
                AUX1->COMPMA,AUX1->COMPME,AUX1->ABA;
              } 
  

  @nLin,00 PSAY     replicate("_",limite)   
  @++nLin,00   PSAY DIV(AUX1->MAQ)
   //@nLin,00 PSAY     replicate("¯",limite)
   @nLin,00   PSAY      alltrim(AUX1->MAQ )       //esta em todos 

 for x:=1 to len (aDados)       
  @nLin,aPos[x]   PSAY      alltrim(str(aDados[x]))        
 next x      

return 

*******************************
static function ImpTodos( nLin)
*******************************

Local aPos  :={;
               06,17,;
               27,34,;
               41,49,;
               97;
              }
         
Local aDados:={;
               AUX1->LMAEX + AUX1->LMACS,;
               AUX1->LMEEX + AUX1->LMECS,;
               AUX1->ESPMA , AUX1->ESPME,;   
               AUX1->COMPMA, AUX1->COMPME,;
               AUX1->ABA;
              } 

   @++nLin,00 PSAY    DIV(AUX1->MAQ)
   
 for x:=1 to len(aDados)                                                                                                                                                                                        
  @nLin,apos[x]   PSAY    Calcula(aDados[x], AUX1->AMOSTR )
 next x
   
   return Nil        
                                      










*******************************
static function ImpGeral(nLin,aAlias)
*******************************
Local aCampos1:={;
         "LMAEX +"+aAlias[1]+"LMACS" ,"LMEEX+ "+aAlias[1]+"LMECS" ,;
         "ESPMA" ,"ESPME" ,"COMPMA","COMPME",;
         "BCSACL","BCSACT","BCSADS","SLDFRI",;
         "SLDQUE","ABA"   ,"IMPDES","QNTMA" ,;
         "QNTME" ,"SANF"  ,"PREGA" ,"TON"   ,;
         "MALSEL","IMPERF","EMBIMP","EMBAMA",;
         "EMBAME","BLOCAD","ALCFIN","ALCRUI",;
         "ALCCOR","ALINHA","FARDO" ,"AMOSTR",;
         "FARDAO","PACOTE";
        }
Local aCampos2:={;
         "LMAEX +"+aAlias[2]+"LMACS" ,"LMEEX+ "+aAlias[2]+"LMECS" ,;
         "ESPMA" ,"ESPME" ,"COMPMA","COMPME",;
         "BCSACL","BCSACT","BCSADS","SLDFRI",;
         "SLDQUE","ABA"   ,"IMPDES","QNTMA" ,;
         "QNTME" ,"SANF"  ,"PREGA" ,"TON"   ,;
         "MALSEL","IMPERF","EMBIMP","EMBAMA",;
         "EMBAME","BLOCAD","ALCFIN","ALCRUI",;
         "ALCCOR","ALINHA","FARDO" ,"AMOSTR",;
         "FARDAO","PACOTE";
        }
        
Local aCampos3:={;
         "LMAEX +"+aAlias[3]+"LMACS" ,"LMEEX+ "+aAlias[3]+"LMECS" ,;
         "ESPMA" ,"ESPME" ,"COMPMA","COMPME",;
         "BCSACL","BCSACT","BCSADS","SLDFRI",;
         "SLDQUE","ABA"   ,"IMPDES","QNTMA" ,;
         "QNTME" ,"SANF"  ,"PREGA" ,"TON"   ,;
         "MALSEL","IMPERF","EMBIMP","EMBAMA",;
         "EMBAME","BLOCAD","ALCFIN","ALCRUI",;
         "ALCCOR","ALINHA","FARDO" ,"AMOSTR",;
         "FARDAO","PACOTE";
        }
        
Local aCampos4:={;
         "LMAEX +"+aAlias[4]+"LMACS" ,"LMEEX+ "+aAlias[4]+"LMECS" ,;
         "ESPMA" ,"ESPME" ,"COMPMA","COMPME",;
         "BCSACL","BCSACT","BCSADS","SLDFRI",;
         "SLDQUE","ABA"   ,"IMPDES","QNTMA" ,;
         "QNTME" ,"SANF"  ,"PREGA" ,"TON"   ,;
         "MALSEL","IMPERF","EMBIMP","EMBAMA",;
         "EMBAME","BLOCAD","ALCFIN","ALCRUI",;
         "ALCCOR","ALINHA","FARDO" ,"AMOSTR",;
         "FARDAO","PACOTE";
        }
      

Local aNomes:={;
"LARGURA MAIOR  ","LARGURA MENOR  " ,;
"ESPESSURA MAIOR"        ,"ESPESSURA MENOR"           ,"COMPRIMENTO MAIOR"         ,"COMPRIMENTO MENOR",;
"BOCA DE SACO COLADA"    ,"BOCA DO SACO CORTADA"      ,"BOCA DE SACO DESFIADA"     ,"SOLDA FRIA",;
"SOLDA QUENTE"           , "ABA"                      ,"IMPRESSÃO DESCENTRALIZADA ", "QUANTIDADE MAIOR"  ,;
"QUANTIDADE MENOR"       ,"SANFONA"                   ,"PREGAS"                    ,"TONALIDADE",;
"PCTS MAL SELADOS"       ,"PCTS IMPERFEITOS"          ,"EMB. IMPERFEITA"           ,"EMBALAGEM Á MENOS",;
"EMBALAGEM Á MAIS"       ,"BLOCADOR"                  ,"ALÇA FINA"                 ,"ALÇA RUÌDA",;
"ALÇA CORTADA"           ,"ALINHAMENTO"               ,"QUANTIDADE DE PC DO FARDOS","QUANTIDADE DE AMOSTRAS",;
"QUANTIDADE DE FARDO"    ,"QUANTIDADE DE PACOTES";
        } 
 
Local aDados1:={} 
Local aDados2:={} 
Local aDados3:={} 
Local aDados4:={} 
         
         for x:=1 to Len(aNomes)
           aadd(aDados1,(aAlias[1]+aCampos1[x]+""))
           aadd(aDados2,(aAlias[2]+aCampos2[x]+""))
           aadd(aDados3,(aAlias[3]+aCampos3[x]+""))
           aadd(aDados4,(aAlias[4]+aCampos4[x]+""))
           &(aAlias[1]+"(dbGoTop())")
           &(aAlias[2]+"(dbGoTop())")
           &(aAlias[3]+"(dbGoTop())")
           &(aAlias[4]+"(dbGoTop())")
         next x

  @nLin++,00 PSAY     replicate("_",limite-69)
 for x:=1 to len(aDados1)                                                                                                                                                                                        
   
   if      x== 29 
    @nLin++,00 PSAY     replicate("_",limite-69) 
   endif
  @nLin,00   PSAY    aNomes[x] 
  @nLin,30   PSAY    "|" 
  @nLin,34   PSAY    alltrim(str(&(aDados1[x])))
  @nLin,40   PSAY    "|"                        
  //44 x1
  @nLin,60   PSAY    "|"
  @nLin,64   PSAY    alltrim(str(&(aDados2[x])))
  @nLin,70   PSAY    "|"                   
  //74 x2
  @nLin,90   PSAY    "|"
  @nLin,94   PSAY    alltrim(str(&(aDados3[x])))
  @nLin,100   PSAY    "|"  
  //104 x3
  @nLin,120   PSAY    "|"
  @nLin,124   PSAY    alltrim(str(&(aDados4[x])))
  @nLin,130   PSAY    "|" 
  //134
  @nLin,150   PSAY    "|"
 IF x<29 
  ImpCampos1(x,@nLin,;
                    &(aDados1[x]),&(aDados2[x]),&(aDados3[x]),&(aDados4[x]),;
                    aDados1,aDados2,aDados3,aDados4)
 ELSE
  ImpCampos2(x,@nLin,aDados1,aDados2,aDados3,aDados4)  
 ENDIF
 
  @nLin,00 PSAY     replicate("_",limite-69) 
  nLin++
 
 next x   
 
 
 return Nil
 
*******************************
static Function ImpCampos1(x,nLin,nDado1,nDado2,nDado3,nDado4,aDados1,aDados2,aDados3,aDados4) 
*******************************
aPOS:={44,74,104,134}
 if      x== 14  .or. x== 15  
    @nLin,aPOS[1]   PSAY    Calcula(nDado1, &(aDados1[32]) )
    @nLin,aPOS[2]   PSAY    Calcula(nDado2, &(aDados2[32]) )
    @nLin,aPOS[3]   PSAY    Calcula(nDado3, &(aDados3[32]) )
    @nLin,aPOS[4]   PSAY    Calcula(nDado4, &(aDados4[32]) )
    
   elseif x== 19  .or. x== 20
    @nLin,aPOS[1]   PSAY    Calcula(nDado1, &(aDados1[29]) )
    @nLin,aPOS[2]   PSAY    Calcula(nDado2, &(aDados2[29]) )
    @nLin,aPOS[3]   PSAY    Calcula(nDado3, &(aDados3[29]) )
    @nLin,aPOS[4]   PSAY    Calcula(nDado4, &(aDados4[29]) )
    
   elseif x>= 21  .and.  x<=23 
    @nLin,aPOS[1]   PSAY    Calcula(nDado1, &(aDados1[31]) )
    @nLin,aPOS[2]   PSAY    Calcula(nDado2, &(aDados2[31]) )
    @nLin,aPOS[3]   PSAY    Calcula(nDado3, &(aDados3[31]) )
    @nLin,aPOS[4]   PSAY    Calcula(nDado4, &(aDados4[31]) )
    
   else
    @nLin,aPOS[1]   PSAY    Calcula(nDado1 ,&(aDados1[30]) ) 
    @nLin,aPOS[2]   PSAY    Calcula(nDado2, &(aDados2[30]) )
    @nLin,aPOS[3]   PSAY    Calcula(nDado3, &(aDados3[30]) )
    @nLin,aPOS[4]   PSAY    Calcula(nDado4, &(aDados4[30]) ) 
    
  endif  
  
  return
  
  
  
  
*******************************
static Function ImpCampos2(x,nLin,aDados1,aDados2,aDados3,aDados4 )
*******************************
aPOS:={44,74,104,134}
nSoma1:=nSoma2:=nSoma3:=nSoma4:=0
   if      x== 29 
    @nLin,aPOS[1]   PSAY    Calcula(&(aDados1[19])+&(aDados1[20]), &(aDados1[29]))
    @nLin,aPOS[2]   PSAY    Calcula(&(aDados2[19])+&(aDados2[20]), &(aDados2[29]))
    @nLin,aPOS[3]   PSAY    Calcula(&(aDados3[19])+&(aDados3[20]), &(aDados3[29]))
    @nLin,aPOS[4]   PSAY    Calcula(&(aDados4[19])+&(aDados4[20]), &(aDados4[29]))
    endif  

    if      x== 30 
         for y:=1 to Len(aDados1)
          if y<>14 .and.   y<>15 .and.  y<>19 .and.   y<>20 .and.  y<>21 .and.   y<>22 .and.  y<>23 .and. y<29  
          nSoma1+= &(aDados1[y])
          nSoma2+= &(aDados2[y])
          nSoma3+= &(aDados3[y])
          nSoma4+= &(aDados4[y])
          endif
         next y
    @nLin,aPOS[1]   PSAY    Calcula(nSoma1, &(aDados1[30]) )
    @nLin,aPOS[2]   PSAY    Calcula(nSoma2, &(aDados2[30]) )
    @nLin,aPOS[3]   PSAY    Calcula(nSoma3, &(aDados3[30]) )
    @nLin,aPOS[4]   PSAY    Calcula(nSoma4, &(aDados4[30]) )
   endif   
 
   if      x== 31  
    @nLin,aPOS[1]   PSAY    Calcula(&(aDados1[21])+&(aDados1[22])+&(aDados1[23]), &(aDados1[31]) )
    @nLin,aPOS[2]   PSAY    Calcula(&(aDados2[21])+&(aDados2[22])+&(aDados2[23]), &(aDados2[31]) )
    @nLin,aPOS[3]   PSAY    Calcula(&(aDados3[21])+&(aDados3[22])+&(aDados3[23]), &(aDados3[31]) )
    @nLin,aPOS[4]   PSAY    Calcula(&(aDados4[21])+&(aDados4[22])+&(aDados4[23]), &(aDados4[31]) )
 endif
 
 if      x== 32  
    @nLin,aPOS[1]   PSAY    Calcula(&(aDados1[14])+&(aDados1[15]), &(aDados1[32]) )
    @nLin,aPOS[2]   PSAY    Calcula(&(aDados2[14])+&(aDados2[15]), &(aDados2[32]) )
    @nLin,aPOS[3]   PSAY    Calcula(&(aDados3[14])+&(aDados3[15]), &(aDados3[32]) )
    @nLin,aPOS[4]   PSAY    Calcula(&(aDados4[14])+&(aDados4[15]), &(aDados4[32]) )
 endif 
  
return Nil 






*********************************************************************************
Static function ImpPERIODO(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin,aMAQ)    
*********************************************************************************


Local C0E0 := S0 := P0 := 0  
Cabec1 := " MAQ|LARGMAIOR| LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA| IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL" 
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin:=8  
TAB:=3   
                 
//     " MAQ |LARGMAIOR|LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA |IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL"
 cDIV:="     |         |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |      |       |       |       |      |       |       |       |      "
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
//     " MAQ |LARGMAIOR|LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|ROLOS |PREGA |MALSEL|IMPERF|EMBAMA| EMBAME| FARDO |AMOSTR |FARDAO|TOTAL"
cDIV2:="     |         |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |      |       |       |       |      |     "
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//     " MAQ |LARGMAIOR|LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|AMOSTR|ALCCOR|PACOTE| TOTAL "  
cDIV3:="     |         |         |      |      |      |       |       |       |       |       |       |      |      |      |      |      |      |      |       "
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                 
       

While MAQ1->( !EOF() )  

C0E0++

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
      if upper(substr(&(aMAQ[1]+"MAQ"),1,2)) $ ("C0") .and.upper( substr(&(aMAQ[1]+"MAQ"),3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| BCSACL| BCSACT| BCSADS| SLDFRI| SLDQUE|  ABA| IMPDES| QNTMA| QNTME| SANF |PREGA |MALSEL|IMPERF| EMBIMP| EMBAMA| EMBAME| FARDO| AMOSTR| FARDAO| PACOTE| TOTAL" 
      endif 
    
      if upper(substr(&(aMAQ[1]+"MAQ"),1,2)) $ ("P0") .and.upper( substr(&(aMAQ[1]+"MAQ"),3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|AMOSTR|ALCCOR|PACOTE| TOTAL " 
      endif 
    
      if upper(substr(&(aMAQ[1]+"MAQ"),1,2)) $ ("S0") .and.upper( substr(&(aMAQ[1]+"MAQ"),3,1))!='0' 
       Cabec1 := " MAQ|LARGMAIOR |LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|ROLOS |PREGA |MALSEL|IMPERF|EMBAMA| EMBAME| FARDO |AMOSTR |FARDAO|TOTAL" 
      endif 
      
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
 
    if upper(substr(&(aMAQ[1]+"MAQ"),1,2)) $ ("P0") .and.upper( substr(&(aMAQ[1]+"MAQ"),3,1))!='0' .and. P0 ==0 
      @++nLin,00 PSAY     replicate("¯",limite)
      Cabec1 := " MAQ|LARGMAIOR| LARGMENOR| ESPMA| ESPME|COMPMA| COMPME| APAREN| SLDH2O| SLDAR | SLDMAN| PICOTE|  ABA |DISTMA|DISTME|PREGA |MALSEL|IMPERF|EMBAMA|EMBAME| FARDO |AMOSTR |FARDAO |ROLOS |TOTAL" 
        
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      P0:=1
    endif
    
    
    if upper(substr(&(aMAQ[1]+"MAQ"),1,2)) $ ("S0") .and.upper( substr(&(aMAQ[1]+"MAQ"),3,1))!='0' .and. S0 ==0 
      @++nLin,00 PSAY     replicate("¯",limite)
      Cabec1 := " MAQ|LARGMAIOR| LARGMENOR| ESPMA|ESPME |COMPMA| COMPME|ALCFIN | ALCRUI|BLOCAD |SLDFRI |SLDQUE |  ABA |ALINHA| QNTMA| QNTME|ALCCOR|AMOSTR|PACOTE| TOTAL " 
      
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8 
      S0:=1
    endif     
    
    


  aPos:={8,17,27,34,41,49,97}  
  
  aDados1:={;
                MAQ1->LMAEX+MAQ1->LMACS,;
                MAQ1->LMEEX+MAQ1->LMECS,;
                MAQ1->ESPMA,MAQ1->ESPME,;
                MAQ1->COMPMA,MAQ1->COMPME,MAQ1->ABA;
              }
  aDados2:={;
                MAQ2->LMAEX+MAQ2->LMACS,;
                MAQ2->LMEEX+MAQ2->LMECS,;
                MAQ2->ESPMA,MAQ2->ESPME,;
                MAQ2->COMPMA,MAQ2->COMPME,MAQ2->ABA;
              }
               
  aDados3:={;
                MAQ3->LMAEX+MAQ3->LMACS,;
                MAQ3->LMEEX+MAQ3->LMECS,;
                MAQ3->ESPMA,MAQ3->ESPME,;
                MAQ3->COMPMA,MAQ3->COMPME,MAQ3->ABA;
              }  
  aDados4:={;
                MAQ4->LMAEX+MAQ4->LMACS,;
                MAQ4->LMEEX+MAQ4->LMECS,;
                MAQ4->ESPMA,MAQ4->ESPME,;
                MAQ4->COMPMA,MAQ4->COMPME,MAQ4->ABA;
              }
  IniDados2(aMAQ,aDados1,aDados2,aDados3,aDados4,aPos,@nLin)//dados comuns a todos
    
 // ImpDados2(aMAQ,aDados1,aDados2,aDados3,aDados4,@nLin)//verifica os dados para imprimir
  
  
   IncRegua()
   MAQ1->( dbSkip()) // Avanca o ponteiro do registro no arquivo
   MAQ2->( dbSkip()) // Avanca o ponteiro do registro no arquivo
   MAQ3->( dbSkip()) // Avanca o ponteiro do registro no arquivo
   MAQ4->( dbSkip()) // Avanca o ponteiro do registro no arquivo
   
EndDo
 @++nLin,00 PSAY     replicate("¯",limite)
return Nil 
 

*****************************************
static function IniDados2(aMAQ,aDados1,aDados2,aDados3,aDados4,aPos,nLin)
*****************************************  
                  
  @nLin,00 PSAY     replicate("_",limite)   
  @++nLin,00   PSAY DIV(&(aMAQ[1]+"MAQ"))
  @nLin,00   PSAY      alltrim(&(aMAQ[1]+"MAQ") )       //esta em todos 
   
@nLin,(4)   PSAY  "A" 
 for x:=1 to len (aDados1)       
  @nLin,aPos[x]-1   PSAY           CALCULA(aDados1[x],MAQ1->AMOSTR)   
 next x  
 ImpDados2(aMAQ[1],nLin)//verifica os dados para imprimir
 // DadosCS2(aMAQ[1],nLin) 
  
    
  @++nLin,00   PSAY DIV(&(aMAQ[1]+"MAQ"))                          
  @nLin,(5)   PSAY  "B"  
  for x:=1 to len (aDados2)       
  @nLin,aPos[x]    PSAY          CALCULA(aDados2[x],MAQ2->AMOSTR)
  next x 
  ImpDados2(aMAQ[2],nLin)//verifica os dados para imprimir
 //DadosCS2(aMAQ[2],nLin)  
   
   
 @++nLin,00   PSAY DIV(&(aMAQ[1]+"MAQ"))                        
 @nLin,(5)   PSAY  "C"  
  for x:=1 to len (aDados3)       
  @nLin,aPos[x]    PSAY           CALCULA(aDados3[x],MAQ3->AMOSTR) 
  next x  
   ImpDados2(aMAQ[3],nLin)//verifica os dados para imprimir
 //DadosCS2(aMAQ[3],nLin)    
   
    @nLin,05 PSAY     replicate("_",(limite-4))
  @++nLin,00   PSAY DIV(&(aMAQ[1]+"MAQ"))
 // @nLin,00 PSAY     replicate("_",limite)  
  @nLin,(5)   PSAY  "T"  
  for x:=1 to len (aDados4)       
  @nLin,aPos[x]   PSAY           CALCULA(aDados4[x],MAQ4->AMOSTR) 
  next x 
   ImpDados2(aMAQ[4],nLin)//verifica os dados para imprimir
 //DadosCS2(aMAQ[4],nLin)
 
   
  
return 


            
***************
static function ImpDados2(cMAQ,nLin)
***************        

if upper(substr(&(cMAQ+"MAQ"),1,2)) $ ("C0") .and.upper( substr(&(cMAQ+"MAQ"),3,1))!='0'
   DadosCS2(cMAQ,nLin)
   endif
   if upper(substr(&(cMAQ+"MAQ"),1,2)) $ ("S0") .and.upper( substr(&(cMAQ+"MAQ"),3,1))!='0'
   DadosSA2(cMAQ,@nLin)    
   endif
   if upper(substr(&(cMAQ+"MAQ"),1,2)) $ ("P0") .and.upper( substr(&(cMAQ+"MAQ"),3,1))!='0'
   DadosPC2(cMAQ,@nLin)    
   endif
return Nil 


   







               




***************
static function DadosCS2(cMaq,nLin)
***************  

Local aPos  :={;
          58,66,74,82,90,104,;
         112,118,126,132,138,145,154,;
         162,170,177,185,192,200;
        }
Local aDados1:={;
          cMaq+"BCSACL" , cMaq+"BCSACT" , cMaq+"BCSADS" , cMaq+"SLDFRI" , cMaq+"SLDQUE" , cMaq+"IMPDES" ,        ;
          cMaq+"QNTMA"  , cMaq+"QNTME"  , cMaq+"SANF"   , cMaq+"PREGA"  , cMaq+"MALSEL" , cMaq+"IMPERF" , cMaq+"EMBIMP",;
          cMaq+"EMBAMA" , cMaq+"EMBAME" , cMaq+"FARDO"  , cMaq+"AMOSTR" , cMaq+"FARDAO" , cMaq+"PACOTE" ;
        }    
                  
                  
      
for x:=1 to len (aDados1)  
     
    if x== 7 .or. x==8  
      if cMaq=="MAQ4->"
        @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->PACOTE)
        else
        @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),&(cMaq+"PACOTE"))
      endif
      
      
    elseif x== 11   .or. x==12 
      if cMaq=="MAQ4->"
       @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->FARDO)
       else
       @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),&(cMaq+"FARDO"))
      endif
      
      
    elseif x>= 13   .and. x<=15  
      if cMaq=="MAQ4->"
       @nLin,aPos[x]  PSAY     CALCULA(&(aDados1[x]),MAQ4->FARDAO)
       else
       @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),&(cMaq+"FARDAO"))
      endif
              
      
    elseif x>=16 .and. x<=19 
      @nLin,aPos[x]  PSAY     alltrim(str(&(aDados1[x])))
       
    else  
      if cMaq=="MAQ4->"
       @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->AMOSTR)
       else
       @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),&(cMaq+"AMOSTR")) 
      endif
    endif 
    
next x
  if cMaq!="MAQ4->"
   nX1:=;
     ;//MAQ4->LMAEX+MAQ4->LMACS       + ;
        &(cMaq+"LMEEX")  + &(cMaq+"LMECS" ) +;
        &(cMaq+"ESPMA" ) + &(cMaq+"ESPME" ) + ;
        &(cMaq+"COMPMA") + &(cMaq+"COMPME") + ;
        &(cMaq+"BCSACL") + &(cMaq+"BCSACT") + &(cMaq+"BCSADS")+;
        &(cMaq+"SLDFRI") + &(cMaq+"SLDQUE") + ;
        &(cMaq+"ABA"   ) + &(cMaq+"IMPDES") + ;
        &(cMaq+"QNTMA" ) + &(cMaq+"QNTME" ) + ;
        &(cMaq+"SANF"  ) + &(cMaq+"PREGA" ) + ;
        &(cMaq+"MALSEL") + ; 
        &(cMaq+"IMPERF") + &(cMaq+"EMBIMP") + ;
        &(cMaq+"EMBAMA") + &(cMaq+"EMBAME") 
        
   nX2:=&(cMaq+"FARDO" ) + &(cMaq+"AMOSTR") + ;
        &(cMaq+"FARDAO") + &(cMaq+"PACOTE")     
 
   @nLin,207  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"   
   
  endif
   
  
return NIl
                          
        
        
        
        
        
    ***************
static function DadosPC2(cMaq,nLin)  
***************   

Local aPos  :={;
          58, 66, 74, 82, 90,104,112,118,;
         125,131,139,146,154,162,170,177;
        }
Local aDados1:={;
        cMaq+"APAREN" , cMaq+"SLDH2O" , cMaq+"SLDAR" , cMaq+"SLDMAN" , cMaq+"PICOTE" , cMaq+"DISTMA" , cMaq+"DISTME" , cMaq+"PREGA",;
        cMaq+"MALSEL" , cMaq+"IMPERF" ,cMaq+"EMBAMA" , cMaq+"EMBAME" , cMaq+"FARDO " , cMaq+"AMOSTR" , cMaq+"FARDAO" , cMaq+"ROLOS" ;
        } 
        
        
   for x:=1 to len (aDados1)  
        if    x==9 .or. x==10
           if cMaq=="MAQ4->"
             @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->FARDO)
             else
             @nLin,aPos[x]   PSAY    CALCULA(&(aDados1[x]),&(cMaq+"FARDO") )
            endif
        elseif x==11 .or. x==12
           if cMaq=="MAQ4->"
             @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->ROLOS)
             else
             @nLin,aPos[x]   PSAY    CALCULA(&(aDados1[x]),&(cMaq+"ROLOS") )  
          endif
          elseif x>=13 .and. x<=16
          @nLin,aPos[x]   PSAY    alltrim(str(&(aDados1[x])))
          
        else
           if cMaq=="MAQ4->"
             @nLin,aPos[x]  PSAY      CALCULA(&(aDados1[x]),MAQ4->AMOSTR)
             else
             @nLin,aPos[x]   PSAY    CALCULA(&(aDados1[x]),&(cMaq+"AMOSTR") )
           endif
        endif 
   next x  
    if cMaq!="MAQ4->"   
   nX1:=;
      ;//&(cMaq+"LMAEX+&(cMaq+"LMACS    + ;
        &(cMaq+"LMEEX + "+cMaq+"LMECS")     + ;
        &(cMaq+"ESPMA")  + &(cMaq+"ESPME")  + ;
        &(cMaq+"COMPMA") + &(cMaq+"COMPME") + ;
        &(cMaq+"ABA")    + ;
        &(cMaq+"APAREN") + ;
        &(cMaq+"DISTMA") + &(cMaq+"DISTME") + ;
        &(cMaq+"PICOTE") + &(cMaq+"SLDMAN") + ;
        &(cMaq+"SLDAR")  + &(cMaq+"SLDH2O") + ;
        &(cMaq+"PREGA")  + ;
        &(cMaq+"MALSEL") + ;
        &(cMaq+"IMPERF") + ;
        &(cMaq+"EMBAMA") + &(cMaq+"EMBAME")
        
   nX2:= &(cMaq+"FARDO")  + ;
         &(cMaq+"AMOSTR") + ;
         &(cMaq+"FARDAO") + ;
         &(cMaq+"ROLOS")     

   @nLin,184  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"
   endif
    

   
return Nil            
        
        
        
        
        
        
        
        

***************
static function DadosSA2(cMaq,nLin)
***************
Local aPos  :={;
           58, 66, 74, 82, 90,104,;
          113,119,126,132,139;
         }
 
         
 Local aDados:={;
          cMaq+"ALCFIN" , cMaq+"ALCRUI" , cMaq+"BLOCAD"  ,cMaq+"SLDFRI" , cMaq+"SLDQUE" , cMaq+"ALINHA"  ,;
          cMaq+"QNTMA"  , cMaq+"QNTME"  , cMaq+"ALCCOR"  ,cMaq+"AMOSTR" , cMaq+"PACOTE";
         } 
         
for x:=1 to len (aDados)  
    if     x==7 .or. x==8  
     @nLin,aPos[x]   PSAY  Calcula( &(aDados[x]) , &(cMaq+"PACOTE" ) )
    elseif x==10 .or. x==11 
     @nLin,aPos[x]   PSAY  alltrim(str(&(aDados[x])))  
    else
     @nLin,aPos[x]   PSAY  Calcula( &(aDados[x]) , &(cMaq+"AMOSTR" ) )  
    endif 
 next x
      
    if cMaq!="MAQ4->"
   nX1:=;
        &(cMaq+"LMAEX" ) + &(cMaq+"LMACS" ) + ;
        &(cMaq+"LMEEX" ) + &(cMaq+"LMECS" ) + ;
        &(cMaq+"ESPMA" ) + &(cMaq+"ESPME" ) + ;
        &(cMaq+"COMPMA") + &(cMaq+"COMPME") + ;
        &(cMaq+"ABA"   ) + ;
        &(cMaq+"ALCCOR") + &(cMaq+"ALCFIN") + &(cMaq+"ALCRUI") + ;
        &(cMaq+"SLDQUE") + &(cMaq+"SLDFRI") + ;
        &(cMaq+"QNTMA" ) + &(cMaq+"QNTME" ) + ;
        &(cMaq+"TON"   ) + ;
        &(cMaq+"BLOCAD") + ;
        &(cMaq+"ALINHA")  
        
   nX2:=&(cMaq+"AMOSTR") + &(cMaq+"PACOTE")     

   @nLin,147  PSAY  iif(nX1  !=0 .and. nX2 !=0 ,alltrim(str(round((nX1/nX2)*100,2)))," 0")+"%"   
   
endif
 
  
   return NIl           


      

