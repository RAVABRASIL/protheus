#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     º Autor ³ AP6 IDE            º Data ³  22/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ESTR001()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise de Produto"
Local cPict          := ""
Local titulo         := "Analise de Produto"
Local nLin           := 80

Local Cabec1         := "Codigo  Dt.Solic Produto          Descricao                                           Previsao de Vendas R$                 1º Mes           2º Mes         3º Mes           4º Mes           5º Mes         6º Mes "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "ESTR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

if !U_Senha2("15",1)[1]
   Return
Endif

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/09/09   º±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


cQry:="SELECT Z47_NUM,B1_COD,B1_DESC,Z47_PREVEN,Z47_DATA, CAST('"+Dtos( DDATABASE )+"'-CAST(Z47_DATA AS DATETIME) AS INT ) AS DIAS  "
cQry+="FROM "+retSqlName("Z47")+" Z47  "
cQry+="JOIN "+retSqlName("SB1")+" SB1 ON Z47_PROD = B1_COD   "
cQry+="WHERE   "
cQry+="Z47.D_E_L_E_T_ != '*'   "
cQry+="AND Z47_FILIAL='"+xFilial('Z47')+"'  " 
cQry+="AND Z47_STATUS='X' " // Produto Criado
cQry+="AND B1_ATIVO='S' "
cQry+="AND B1_ANAPROD='N' "
cQry+="ORDER BY DIAS "  
TCQUERY cQry NEW ALIAS "TMPZ"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TMPZ->( dbGoTop() )
count to nREGTOT while ! TMPZ->( EoF() )
SetRegua( nREGTOT )
TMPZ->( DBGoTop() )

While TMPZ->( !EOF() )

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
    if TMPZ->DIAS<180
       @nLin,00 PSAY " Menos de 6 Meses "
       nLin+=2
    endIf 
    
    While TMPZ->( !EOF() ) .AND. TMPZ->DIAS<180
         
         If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
         Endif
         
         @nLin++,00 PSAY TMPZ->Z47_NUM+SPACE(2)+DTOC(STOD(TMPZ->Z47_DATA))+SPACE(2)+TMPZ->B1_COD+SPACE(2)+TMPZ->B1_DESC+SPACE(2)+TMPZ->Z47_PREVEN+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][1][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][2][2],'@E 999,999,999.99')+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][3][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][4][2],'@E 999,999,999.99')+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][5][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][6][2],'@E 999,999,999.99')
         
         IncRegua()
         TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo

    enddo
    
    nLin+=2
    @nLin,00 PSAY " Mais e Igual a 6 Meses "
    nLin+=2 
    
    While TMPZ->( !EOF() ) .AND. TMPZ->DIAS>=180
         
         If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
         Endif

         @nLin++,00 PSAY TMPZ->Z47_NUM+SPACE(2)+DTOC(STOD(TMPZ->Z47_DATA))+SPACE(2)+TMPZ->B1_COD+SPACE(2)+TMPZ->B1_DESC+SPACE(2)+TMPZ->Z47_PREVEN+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][1][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][2][2],'@E 999,999,999.99')+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][3][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][4][2],'@E 999,999,999.99')+SPACE(2)+;
         TRANSFORM(SEISMES(TMPZ->B1_COD)[1][5][2],'@E 999,999,999.99')+SPACE(2)+TRANSFORM(SEISMES(TMPZ->B1_COD)[1][6][2],'@E 999,999,999.99')
         
         IncRegua()
         TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo

    enddo


EndDo

TMPZ->( DbCloseArea() )

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


**************
                  
Static Function SEISMES(cProd)

***************

Local cQry:=''
Local aRet:={}
Local dDataI  := FirstDay(STOD(TMPZ->Z47_DATA))
Local dDataF  := LastDay(STOD(TMPZ->Z47_DATA)+150) 
// Povoa o vetor 
aAdd( aRet,  { {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)),2))  ,0 },;
              {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)+30 ),2)),0 },;
              {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)+60 ),2)),0 },;
              {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)+90 ),2)),0 },;
              {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)+120 ),2)),0 },;
              {alltrim(strzero(Month( STOD(TMPZ->Z47_DATA)+150 ),2)),0 }   }  )

cQry:="SELECT  MES=MONTH(D2_EMISSAO) ,VALOR=SUM(D2_TOTAL) " 
cQry+="FROM "+retSqlName("SD2")+" SD2 WITH (NOLOCK), "+retSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE D2_EMISSAO BETWEEN '"+Dtos( dDataI)+"' AND '"+Dtos( dDataF )+"' "
cQry+="AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_TIPO = 'N' "  
cQry+="AND RTRIM(D2_COD) NOT IN ('187','188','189','190') " 
cQry+="AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949')  "
cQry+="AND SD2.D_E_L_E_T_ = '' "   
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  "
cQry+="AND F2_DUPL <> ' ' "  
cQry+="AND SF2.D_E_L_E_T_ = ''  "  
cQry+="AND D2_COD='"+cProd+"' "
cQry+="GROUP BY MONTH(D2_EMISSAO)  "
cQry+="ORDER BY MES "
TCQUERY cQry NEW ALIAS "AUUX" 

AUUX->( Dbgotop() )

If AUUX->( !EOF() )
   While   AUUX->( !EOF() )
      nIdx  := aScan(aRet[1], {|t| t[1]==alltrim(str(AUUX->MES)) } )
	  If nIdx>0
		 aRet[1][nIdx][2]:=AUUX->VALOR	  
	  Endif
	  AUUX->(dbSkip())			  	
   EndDo
Endif

AUUX->(DBCloseArea())

Return aRet




