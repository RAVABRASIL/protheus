#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR047   º Autor ³ Eurivan Marques    º Data ³  31/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio do controle de ligações para clientes            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Comercial Rava                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
***********************
User Function FATR047()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Controle de Ligações "
Local cPict  := ""
Local titulo := "Controle de Ligações "
Local nLin   := 80

Local Cabec1        := "" //"Assistente            Cliente Loja Data Hora Mensagem"
Local Cabec2        := ""
Local imprime       := .T.
Private aOrd        := {"Assistente","Data+Hora","Cliente"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "FATR47"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR047" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "Z51"

oPerg1(cPerg)
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************
Local aMemo := {}
Local cQuery
Local cQryOrd
Local cQuebra
Local cMemHis := ""
Local nOrdem

nOrdem := aReturn[8]                                                
if nOrdem == 1                                                      
   cQryOrd := "   Z95_USUARI "
elseif nOrdem == 2
   cQryOrd := "   Z95_DATA+Z95_HORA "
elseif nOrdem ==3
   cQryOrd := "   Z95_CLIENT+Z95_LOJA "
endif

SetRegua(0)

cQuery := "SELECT "
cQuery += "   Z95_CLIENT, Z95_LOJA, A1_NOME, Z95_DATA, Z95_HORA, Z95_USUARI, Z95_MEMO "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z95")+" Z95, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE "
if !Empty(MV_PAR01)
   cQuery += "   Z95_CLIENT = '"+MV_PAR01+"' AND "
   if !Empty(MV_PAR02)
      cQuery += "   Z95_LOJA   = '"+MV_PAR02+"' AND "
   endif
endif      
if !Empty(MV_PAR03)
   cQuery += "   A1_EST = '"+MV_PAR03+"' AND "
endif
if !Empty(MV_PAR04)   
   cQuery += "   Z95_USUARI = '"+MV_PAR04+"' AND "
endif   
cQuery += "   Z95_CLIENT = A1_COD AND Z95_LOJA = A1_LOJA AND "
cQuery += "   Z95_DATA BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"' AND "
cQuery += "   Z95.D_E_L_E_T_ <> '*' AND "
cQuery += "   SA1.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += cQryOrd

TCQUERY cQuery NEW ALIAS "LIGX"

while !LIGX->(EOF())

   if lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      exit
   endif
  
   if nOrdem == 1                                                      
      cQuebra := LIGX->Z95_USUARI
   elseif nOrdem == 2
      cQuebra := LIGX->(Z95_DATA)
   elseif nOrdem ==3
      cQuebra := LIGX->(Z95_CLIENT)
   endif   

   if ( nLin + Len(aMemo) ) > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
   endif
   
   @nLin,00 PSAY aOrd[nOrdem]+" - "+if(nOrdem==1,Alltrim(UPPER(UsrRetName(cQuebra))),if(nOrdem==3,Alltrim(Posicione("SA1",1,xFilial("SA1")+cQuebra,"A1_NOME")),cQuebra)) 
   nLin++
   @nLin,00 PSAY Replicate("-",80)
   nLin++ // Avanca a linha de impressao
      
   while !LIGX->(EOF()) .and.;
         if(nOrdem==1, cQuebra==LIGX->Z95_USUARI,if(nOrdem==2,cQuebra==LIGX->(Z95_DATA),cQuebra==LIGX->(Z95_CLIENT) ))
      aMemo := wordWrap( MSMM(LIGX->Z95_MEMO),80)

      if ( nLin + Len(aMemo) ) > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
         nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
      endif

      @nLin,00 PSAY "Ocorrida em: "+DTOC( STOD( LIGX->Z95_DATA ) )+" - "+LIGX->Z95_HORA; nLin++     
      @nLin,00 PSAY "Adicionado por: "+Alltrim(UsrRetName(LIGX->Z95_USUARI)); nLin++
      for _nX := 1 to Len(aMemo)
         @nLin,00 PSAY if(_nX==1,"Mensagem: "+aMemo[_nX],aMemo[_nX]) 
         nLin++
      next _nX
      @nLin,00 PSAY Replicate("-",80); nLin++ // Avanca a linha de impressao
      LIGX->(DbSkip())
   end   
end

if Select("LIGX") > 0
	DbSelectArea("LIGX")
	DbCloseArea()
endif

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


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
*****************************
Static Function oPerg1(cPerg)
*****************************

Local aHelpPor := {}

PutSx1( cPerg,'01','Cliente ?','','','mv_ch1','C',6,0,0,'G','','SA1','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'02','Loja ?','','','mv_ch2','C',2,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'03','UF ?','','','mv_ch3','C',2,0,0,'G','','12','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'04','Assistente ?','','','mv_ch4','C',6,0,0,'G','','USR','','','mv_par04','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'05','Data De ?','','','mv_ch5','D',8,0,0,'G','','','','','mv_par05','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'06','Data Ate ?','','','mv_ch6','D',8,0,0,'G','','','','','mv_par06','','','','','','','','','','','','','','','','',aHelpPor,{},{} )


Return


***************************************
Static Function wordWrap(cText, nRegua)
***************************************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, alltrim(cTemp) )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet   