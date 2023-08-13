#INCLUDE "FIVEWIN.CH"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO17    º Autor ³ AP6 IDE            º Data ³  13/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************

User Function fEtiIn()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ETIQUETA INFECTANTE"
Local cPict          := ""
Local titulo         := "ETIQUETA INFECTANTE"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "fEtiIn" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fEtiIn" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//Pergunte("FETIIN",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FETIIN",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/



/* sem o logo 

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


LOCAL aEtiq := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nVolume := MV_PAR02 
nVolume -=1

While nVolume != -1

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
      //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

Aadd(aEtiq,'CT~~CD,~CC^~CT~')
Aadd(aEtiq,'^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ')
Aadd(aEtiq,'^XA')
Aadd(aEtiq,'^MMT')
Aadd(aEtiq,'^PW815')
Aadd(aEtiq,'^LL2318')
Aadd(aEtiq,'^LS0')

IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT188,2114^A0B,224,256^FH\^FD110^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT188,2114^A0B,224,256^FH\^FD100^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT188,2114^A0B,224,256^FH\^FD50^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT188,2114^A0B,224,256^FH\^FD30^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT188,2114^A0B,224,256^FH\^FD15^FS')
ENDIF

IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT387,2046^A0B,82,84^FH\^FD33 Kg^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT387,2046^A0B,82,84^FH\^FD30 Kg^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT387,2046^A0B,82,84^FH\^FD15 Kg^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT387,2046^A0B,82,84^FH\^FD09 Kg^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT387,2046^A0B,82,84^FH\^FD4.5 Kg^FS')
ENDIF




Aadd(aEtiq,'^FT292,2097^A0B,82,84^FH\^FD  Litros ^FS')
IF MV_PAR01=1 // 110
  Aadd(aEtiq,'^FT444,1837^A0B,31,31^FH\^FDCont\82m 110 Sacos ^FS')
ELSEIF MV_PAR01=2   //100
  Aadd(aEtiq,'^FT444,1837^A0B,31,31^FH\^FDCont\82m 100 Sacos ^FS')
ELSEIF MV_PAR01=3   //50
  Aadd(aEtiq,'^FT444,1837^A0B,31,31^FH\^FDCont\82m 50 Sacos ^FS')
ELSEIF MV_PAR01=4   //30
  Aadd(aEtiq,'^FT444,1837^A0B,31,31^FH\^FDCont\82m 30 Sacos ^FS')
ELSEIF MV_PAR01=5   //15
  Aadd(aEtiq,'^FT444,1837^A0B,31,31^FH\^FDCont\82m 15 Sacos ^FS')
ENDIF




IF MV_PAR01=1 // 110
  Aadd(aEtiq,'^FT494,1976^A0B,31,31^FH\^FDDimens\E4es : 80 Cm X 100 Cm ^FS')
ELSEIF MV_PAR01=2   //100
  Aadd(aEtiq,'^FT494,1976^A0B,31,31^FH\^FDDimens\E4es : 75 Cm X 105 Cm ^FS')
ELSEIF MV_PAR01=3   //50
  Aadd(aEtiq,'^FT494,1976^A0B,31,31^FH\^FDDimens\E4es : 63 Cm X 80 Cm ^FS')
ELSEIF MV_PAR01=4   //30
  Aadd(aEtiq,'^FT494,1976^A0B,31,31^FH\^FDDimens\E4es : 59 Cm X 62 Cm ^FS')
ELSEIF MV_PAR01=5   //15
  Aadd(aEtiq,'^FT494,1976^A0B,31,31^FH\^FDDimens\E4es : 39 Cm X 58 Cm ^FS')
ENDIF


Aadd(aEtiq,'^FT553,2303^A0B,45,45^FH\^FDRava Embalagens^FS')
Aadd(aEtiq,'^FT603,2305^A0B,25,28^FH\^FDRua Jos\82 Ger\93nimo da Silva Filho (Ded\82), ^FS')
Aadd(aEtiq,'^FT634,2305^A0B,25,28^FH\^FD66 Bairro Renascer Cabedelo - PB ^FS')
Aadd(aEtiq,'^FT665,2305^A0B,25,28^FH\^FDCEP: 58310-000^FS')
Aadd(aEtiq,'^FT696,2305^A0B,25,28^FH\^FDAtendimento ao Cliente : 0800-7271915^FS')
Aadd(aEtiq,'^FT727,2305^A0B,25,28^FH\^FDTelefax: (83) 3048-1315^FS')
Aadd(aEtiq,'^FT758,2305^A0B,25,28^FH\^FDEmail: Sac@ravaembalagens.com.br^FS')
Aadd(aEtiq,'^FT789,2305^A0B,25,28^FH\^FDCnpj:41.150.160/0001-02^FS')
Aadd(aEtiq,'^FT194,1523^A0B,90,76^FB418,1,0,C^FH\^FDSACO ^FS')
Aadd(aEtiq,'^FT307,1523^A0B,90,76^FB418,1,0,C^FH\^FDPARA ^FS')
Aadd(aEtiq,'^FT420,1523^A0B,90,76^FB418,1,0,C^FH\^FDRES\D6DUO ^FS')
Aadd(aEtiq,'^FT533,1523^A0B,90,76^FB418,1,0,C^FH\^FDINFECTANTE ^FS')
Aadd(aEtiq,'^FT82,897^A0B,51,45^FH\^FDINFORMA\80\E5ES IMPORTANTES:^FS')
Aadd(aEtiq,'^FT254,1048^A0B,37,36^FH\^FDQu\A1mico Respons\A0vel : Val\82ria Peregrino Brito CRQ N\F8 01.201.360^FS')
Aadd(aEtiq,'^FT398,1048^A0B,37,36^FH\^FDRegistro do Produto na Anvisa N\F8 80056810004^FS')
Aadd(aEtiq,'^FT326,1048^A0B,37,36^FH\^FDAutoriza\87\C6o no minist\82rio da Sa\A3de N\F8 8005681^FS')
Aadd(aEtiq,'^FT534,1048^A0B,37,36^FH\^FDUso exclusivo para acondicionamento de res\A1duo infectante^FS')
Aadd(aEtiq,'^FT607,1048^A0B,37,36^FH\^FDSaco n\C6o adequado a conte\A3do perfurante ^FS')
Aadd(aEtiq,'^FT679,1048^A0B,37,36^FH\^FD Manter fora de alcance de crian\87as^FS')
Aadd(aEtiq,'^FT751,1048^A0B,37,36^FH\^FDComposi\87\C6o: Polietileno e Pigmentos^FS')
Aadd(aEtiq,'^FT464,1048^A0B,31,31^FH\^FDProduto de acordo com a legisla\87\C6o: NBR 9191 / NBR 7500 / RDC N\F8 16/2013^FS')
Aadd(aEtiq,'^FT182,1048^A0B,37,36^FH\^FDFabricado por:  41.150.160/0001-02 www.ravaembalagens.com.br^FS')
Aadd(aEtiq,'^FO112,215^GB0,748,3^FS')
Aadd(aEtiq,'^PQ1,0,1,Y^XZ')


	   For I:= 1 TO Len(aEtiq)
	 	    
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
			 	    
	 	    @nLin,000 PSAY aEtiq[I]
	        nLin := nLin + 1 // Avanca a linha de impressao
	   Next I

	   nVolume--	   
	   aEtiq := {}

EndDo



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
*/


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

LOCAL aEtiq := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nVolume := MV_PAR02 
nVolume -=1

While nVolume != -1

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
      //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

Aadd(aEtiq,'CT~~CD,~CC^~CT~')
Aadd(aEtiq,'^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ')
Aadd(aEtiq,'~DG000.GRF,21632,052,')
Aadd(aEtiq,',:::::::::::::::::::::::::::::::::::::::::::::hM01,hM0380,hM07C0,hM0HE0,hL01FF0,hL03EB8,hL07C7C,hL0F83E,hK01F01F,')
Aadd(aEtiq,'hK03A00FA0,hK07C003E0,hK0F8003E8,hJ01F0H01F0,hJ03A0020FA,hJ07E0I07E,hJ0E80I01E80,hI01F0J01F80,hI03A0K0FA0,hI03E0K03E0,')
Aadd(aEtiq,'hI0EA0K03E0,hH01F0M0F8,hH03A0M0BA,hH03E0M03E,hH0HEN03F80,hH0F80N0F,hG03A0O03E0,hG03E0O03E0,hG0AE0P0F8,hG0F80P0F8,h02B80P0FA,')
Aadd(aEtiq,'h03E0Q03F,h02C0R0F80,h0780R0780,gY02B80R07A0,gY01F0S03E0,gY06E0T0F8,gY07C0T07C,gX02B80T03E,gX01F0U03E,gX0AE0V0F80,gX0F80V07C0,')
Aadd(aEtiq,'gW02B80V03E0,gW01F0W03E0,gW03E0X0F8,gW0780X07C,gV02F80X03E,gV01F0Y01F,gV03E0g0F80,gV07C0g07C0,gV0F80g03E0,gU01F0gG01F0,gU03E0gH0F8,')
Aadd(aEtiq,'gU07C0gH07C,gU0F80gH03E,gT01F0gI01F,gT03E0gJ0F80,gT07C0gJ07C0,gT0F80gJ03E0,gS01F0gK01F0,gS03E0gL0F8,gS07C0gL07C,gS0FA0gJ0203E,gR01F0gM01F,')
Aadd(aEtiq,'gR03E0gN0F80,gR07C0gN07C0,gR0F80gN03E0,gQ01F80gN01F0,gQ03E0gP0F8,gQ03E0gP07C,gQ0F80gP03A,gQ0F80gP01F,gP03E80gQ0F80,gP03E0gR07C0,gP07A0gR03E0,')
Aadd(aEtiq,'gP0F80gR01F0,gO03E80gS0F8,gO03E0gT07C,gO0BA0gG080O0203A20,gO0F80g01C0Q01F,gN02E80g0F80R0F80,gN03E0g03F80R03E0,gN03A0Y02FF80R03A0,gN0F80Y07FF0L0140J01F0,')
Aadd(aEtiq,'gM01F80X03FF80H038280E0K0F8,gM03F0Y07FF0I078381C0K03E,gM03A0X03FA3A0H038383E0K03A,gM0FC0X07FC380H078381C0L0F,gM0F80X07E0380H028380E0L0E80,')
Aadd(aEtiq,'gL03E0Y07C0380H078381C0L03E0,gL03A0Y07BA380H038380E0L03B8,gL07C0Y07FF780H078381C0M0F8,gL0F80g0HFE80H038380E0M0F8,gK01F0gG01FF80H078381C0M03E,')
Aadd(aEtiq,'gJ023E0g0203BB80038382E0M03B80,gK07C0gI07FC007FIFC0N0F80,gK0F80gI02F8003FEFFE0N0F80,gJ01F0gK03C003FIFC0N03E0,gJ03E0gK028003BFHFE0N03A0,gJ07C0hK0FC,')
Aadd(aEtiq,'gJ0F80hK07C,gI01F0gI0H15740W03E,gI03A0gH07FBFB800280S03B,gI07C0gH07FIFC00380T0F80,gI0F80gH07FIF800380T03E0,gH01F0gI0H510J0380T03E0,gH03E0gQ0380T03B8,')
Aadd(aEtiq,'gH07C0gQ0380U0F8,gH0F80gQ038AIAR0BE,gG01F0gM010I03FIFE0Q03F,gG03A0gJ02E01A0H03BBFBE0Q03B80,gG07C0gJ01E01F0H03FIFE0R0FC0,gG0F80gJ03E03F8002AJAS0BE0,')
Aadd(aEtiq,'g01F0gK03F01F800380V03E0,g03E0gK038003A00380V02B8,g07C0gK078001C003C0W07C,g0F80gK078003C00380W03E,g0F0gL070H01C00380W03F,Y03A0gL038003E00280W02B80,')
Aadd(aEtiq,'Y07C0gL070H01C0gH07C0,Y0E80gL078003C0gH03E0,X01F0gM07C00380gH01F0,X03B0gM03E02F8002ABHBE0T02B8,X07C0gM01FIFI03FIFE0U07C,X0F80P0A80U0HEFE0H02FIFE0U03E,')
Aadd(aEtiq,'W01F0O017FF0U07FFC0H03FF7FE0U01F,W03A0N02BHBHAT023FEA0H02022BA0U02B80,W03E0N07FFC0gL03F0W07C0,W0F80M02AAE0gM0FE0W03E0,V01F80M07FF80gL01F0X01F0,')
Aadd(aEtiq,'V03A0M02BBA0gM0BA0Y0B8,V03E0M03FFC0g0H540H01FC0Y07C,V03C0M0IA80W07FIFC0H03F80Y03E,V0F80L01FHFY07FIFC0H0FE0g01F,U03B80L03BAA0M080O03FHFBE003BAIAY0F80,')
Aadd(aEtiq,'U03E0M07FFC0M040R01FC003FIFE0X07C0,U06E0M0EAA80M020R03F8003FEFFE0X03E0,U07C0L01FHF80M030R07E0H03FIFE0X01F0,T03B80L03BAB80M0380P03B80H02AHAH2g0FA,')
Aadd(aEtiq,'T03E0M03FHFO0180P07E0gO07C,T03E0M02AHAP080P0FE0gO03E,T0780M07FFE0N01C0O03F0O020Y01F,T0B820L0BABA20L020A0N02BA020H020H02E0Y02FA0,')
Aadd(aEtiq,'S01E0L07FIFC0O0E0N01F80N07E0g07C0,S03E0K0AEAIAE0O0A0N03FAFFE0J03EE0g03E0,S0780J01FKFC0O0F0N07FIFC0J07FC0g01F0,S0B80J0JBABAA0O0B80M03BIBE0I03BB80gG0F8,')
Aadd(aEtiq,'R01F0J01FLFC540M0F80M07FIFC0I07FC0gH07C,R03E0J0NA86AF80K0A80V0BFFE0gH03E,R07C0I01FMFC7FHFL0F80U01FF1C0gH01F,R0B80I03BBABABAB83ABBA0J0A80O02002003FA1A0gI0FA0,')
Aadd(aEtiq,'Q01F0J07FMFC7FHFE0J0FC0R0C003F01C0gI07C0,Q03E0J0EAMA82AIA80I0AC0Q03E003E81E0gI03E0,Q07C0I01FNFC7FIFC0H01FC0P01FC003FF1C0gI01F8,')
Aadd(aEtiq,'Q0B80I03BMBHA3BIBA0H03BA0P0HBA002FBBE0gJ0FA,P01F0J07FNFC007FHFI01FC0O01FF0I01FFC0gJ07C,P03E0J0EBA002EAIAH02EAB8002AE0O0HFA0J0BFE80gI03E,')
Aadd(aEtiq,'P07C0I01FC0I03FHFE0H03FFC007FC0L0107FFC0K07FE0gJ0F80,P0B80I03BA020H0IBA2002BAA022BA0L0H3FBBA0H02002BA0gJ0FA0,O01F0J03C0K07FHFJ07FE007FC0L0H7FC1C0L07E0gJ07C0,')
Aadd(aEtiq,'O03E0J0280J0A2AAB80H02AA00AAE0L0E3E8380M0E0gJ03E0,O07C0J030J01F1FHFJ01FF00FFC0L047C01C0H01C0H030gJ01F0,O0F80J0A0J03B83BAA0I0HB83BBA0L0E3BA380H03C0gO07A,')
Aadd(aEtiq,'N01F0K040J03FC3FFC0I07F83FFC0L071FF9C0H01C0gH040K07C,N03E0K080J02AE2AHAJ0HA8AHAC0L038BFF80H03C0Y0A03F80J03E80,N03C0J0180J07FC1FHFJ03E0FHFC0L0101FFC0H03C0X01C07FE0J01F,')
Aadd(aEtiq,'N0B80J0180J03A80BHB80H03A3BAB80K020H03BB8003C20220T03A0BHB80J0FA0,M01F0K010K0HFH07F0L07FHF80P07FC001FIFE0T07E1FHF80J03E0,')
Aadd(aEtiq,'M03E0K020K0HA80EE0L0JA80Q0FE003EEFFE0T0FE3E8F80J03E8,M07C0Q01FF00780K07FIF80Q01C001FJFU0783803C0J01F8,M0F80K020J02AA0038023A2BABIB80R0A003BFHFE0T0F03803E0K0FA,')
Aadd(aEtiq,'M0F80Q01FE0030H01FMFW01C0X0F07803C0K03E,L03E0R03AA0020I0NAO0280K03C0X0F02803E0K03E,L07C0R01FC0L07FKFE0N0380K01C0X0703803C0K07C,L0B80R03BA2020I0ABHBABAA0N0380020H03C0X07A3A0B80J02B8,')
Aadd(aEtiq,'L0F80R01FC0L07FKFC0N0380K01C0X07F1FHFC0J01F0,K03E80R02AE0L0MA80N0280K03C0X03FJF80J03E0,K07E0S03FC0L07FKFE0N0380gL01FJFL07C0,K03A0S03AA0020I0KBABA0N03AJAgJ0FBHBE0K0B80,')
Aadd(aEtiq,'K01F0S01FC0L0NFO03FIFC0gI03FHFL01F,L0F80R03AA0020I0AEAJAB80M03EFHFE0H028060W0HA80K03E,L0780R01FE0030H01F17FJFO03FIFE0H030070gL07C,L03E0L020K0BA00380020203ABAB80M03AHAH2I0F80BE0gK0B8,')
Aadd(aEtiq,'L01F0S0HFH07C0L0JF80M0380K01F807E0gJ01F0,M0F80K020K0AB80EA80I0282AHA80M0280L0E802E0gJ03E0,M07C0K010K07F007FFC0H03C1FHFC0M0380K01C0H0F0gJ07C0,')
Aadd(aEtiq,'M03E0K030K0HA80BHB80H03A0BHBA0M0380K03E0H0B0gJ0B80,M01F0L080J07FC1FHFJ07FC3FFC0M03C0K01C0H0F0gI01F,N0F80K080J02AC3AHAJ0EA83AAE0M0380K03C0H0F0gI03E,')
Aadd(aEtiq,'N07C0K040J03F83FFC0I0HF01FFE0U03C0H0F0gI07C,N03E0K020J03BA3BAA0H02AB80ABA20T03E002F0gG020B8,N01F0K070J01C07FF80H01FF007FE0P01C0H01C0H0F0gH01F0,')
Aadd(aEtiq,'O0F80J0280J083AAB80H0IAH02AA0N030FF80H0E803E0gH03E0,O07C0J01E0K03FHFJ07FE003FE0N0F0FFC0H0HF1FC0gH07C0,O03E0J02B80I02BHBA0H03ABA003BA0N0B0BFE0H0BFFBA0gH0F80,')
Aadd(aEtiq,'O01F0K0FC0I01FHFE0H07FF8001FE0M01F1F1E0H03FHFgI01F,P0F80J0EBA002EAIAH0BAHA80H0HAN03E1E0E0I0HFE0gH03E,P07C0J03FHF7FJFE3FIFE0I0FE0M03C1E0E0I0150gI07C,')
Aadd(aEtiq,'P03E0J03BABABABABA3ABABA0I0BA0M0383E0A0gO0B8,P01F0J01FNFC3FIFC0I0FC0M0383C0E0gN01F0,Q0F80J0EAMAE2AIA80I0AE0M0282C0E0L080g03E0,Q07C0J03FMFC3FHFC0J07C0M038780E001C0H0F0g07C0,')
Aadd(aEtiq,'Q03A0J03BHBABHBHA2BAA80J0A80M03A382A003E1E0F0g0FA0,Q01F0K0NFC7FFC0K07C0M01CF83C001C1C0F0Y01F,R0F80J0NAE2EA80K0E80M03FF8FE001C1E0E0Y03E,')
Aadd(aEtiq,'R07C0J01FLFC10N0780M01FF0FC001C1E070Y03E,R03A0K03BBABABA20H020J0B820L023A0B0H03E1A2B0Y0FA,S0F80K0LFE0O070R040H01C1C0F0X01F8,S0F80K02EAJAP0A0V01C1E0F0X03E8,')
Aadd(aEtiq,'S07C0L017FHFE0O0F0V01C1E070X03E0,S03A0M023BBA0O0A0V03A1A0B0X03E0,T0F80M03FHFP0C0Q01F0H01C1C070X0F80,T0F80M03AHA80N080O0BA3F8001EAEAF0W03E80,')
Aadd(aEtiq,'T07C0M01FHF80M010P07E7FC001FJFX03E,T03A0M02ABAA0M0320N02BAFBE003FBFBF0W03E,T01F0N07FFC0M010O01FFE1E001FJFX0FC,U0FC0M02AHAN020O03E3E0E0H0KAW03E8,')
Aadd(aEtiq,'U07E0M01FHFY03C1C0E0gJ03E0,U03A0M02BHB80L080O0383E0A0gJ03A0,U01F80M07FFC0W01C1C0E0gJ0780,V0F80M02AAE0W03C1C0E0H080g0F80,V03E0M01FHF80V03C1C0E001C0Y03E,')
Aadd(aEtiq,'V03A0N03BAA0V0383E2A002A0E0W03E,W0F80M01FHFW01C1C0E001C0E0W0F8,W0F80N0JAV03EBEAE0H0E0E0W0F8,W03E0N01FHFC0T03FJFH01C0E0V01F0,W03B0O02BBAA0S03BIBA0H0A0A0V03E0,')
Aadd(aEtiq,'X0F80gM01FIFE001C0E0V0FC0,X0FE0gM02AHAH8I0E0E0V0F80,X03E0gU01C0E0U01F,X03B0gV0A2A2A0S03E,Y0F80gT01FJFT07C,Y0AE0gU0FEFEF0S0F8,Y03F0gL01FIFI01FJFS01F0,Y02B0gL03BIB80H0BAIAS03E0,')
Aadd(aEtiq,'g0FC0gK01FIFC0g07C0,g0BE0gK03FFEFE0g0F80,g03F0gO01F0Y01F,g02B80gO0B0W0203E,gG0F80gO0F0L050Q07C,gG03E0gO0F0H0FEHEF0Q0F8,gG03F0gO07001FJFQ01F0,')
Aadd(aEtiq,'gG02B80gN0B0H0JFB0P03E0,gH0780gN0F0H04007F0P07C0,gH07E0gN0E0K0FE0P0F80,gH01F0gI0I1H7E0J03F0P01F,gH02B80gH03FBFBE0J0FE0P03A,gI07C0gH01FIFC0I01FC0P07C,')
Aadd(aEtiq,'gI02E0gH01FIF80I03E80P0F8,gI03F0gH01FHFL07E0P01F0,gI02F80gP03B80P03E0,gJ07C0gP07E0Q07C0,gJ03E0gP0FEAAF80M0E80,gJ03F0gK050H01FJFN01F,gJ02B80gG0283B80H0KBN03A20,')
Aadd(aEtiq,'gK07C0gG0787FC0H0JFD0M07C,gK03E0gG0F8FFE0H080Q0E8,gK01F0g01F8F1F0T01F8,gK02B80g0A8A0B0T03B0,gL07C0Y01C1E0F0T03E0,gL03E0Y03C1E0F0H0ABFHF80K0E80,')
Aadd(aEtiq,'gL01F0Y01C1E070H0KFM0F,gL02F80X03C3E0F0H0KB20J03B,gM07C0X01C1C070H0KFL03E,gM02E0X03C2E0F0H0KAL0FE,gM01F0X01F7C1F0R01F0,gN0F80X0BF83A0R03B0,gN07C0X0HF07C0R03F0,')
Aadd(aEtiq,'gN03E0X0BE8780R0AE0,gN01F0X01C070S0F80,gO0FA0g020R03A20,gO07C0gT03E,gO03E0gT03E,gO01F0gT07C,gP0FA0gR03B8,gP07C0gR03E0,gP03E0gR02E0,gP01F0gR07C0,gQ0F80gP02B80,')
Aadd(aEtiq,'gQ07C0gP03E,gQ03E0gP03E,gQ01F0gP07C,gR0F80gO0B8,gR07C0gN01F0,gR03E0gN02E0,gR01F0gN0780,gS0FA0gL02B80,gS07C0gL01F,gS03E0gL03E,gS01F0gL07C,gT0FA0gK0B8,gT03E0gJ01F0,')
Aadd(aEtiq,'gT03E0gJ03E0,gT01F0gJ07C0,gU0FA0gI0B80,gU03E0gH01F,gU03F0gH03E,gU01F0gH07C,gV0FA0gG0FA,gV03E0g01F0,gV02F0g03E0,gW0F0g07E0,gW0FA0Y0FA0,gW07E0X01F,')
Aadd(aEtiq,'gX0F80W03E,:gX0FA0W0FA,gX03E0W0F8,gX03E80U03E8,gY07C0U03E0,gY03E0U0FA0,gY03E0U0F80,gY02F80S03E80,h07C0S07C,h03E0S0FA,h03E0S0F8,h02F80Q03F8,hG0F80Q03F0,')
Aadd(aEtiq,'h023E020O07A0,hG01E0Q0F80,hH0F80O02F80,hH0780O03F,hH03E0O03A,hH01F0O0F8,hI0F80N0F8,hI07C0M03F0,hI03A0M03A0,hI01F0M0FC0,hJ0F80L0F80,hJ07C0K03F,hJ03E0K03E,')
Aadd(aEtiq,'hJ01F0K07C,hK0F80J0F8,hK07C0I01F0,hJ023A02003A0,hK01F0I07C0,hL0F80H0F80,hL07C001F,hL03A003E,hL01F007C,hM0F80F8,hM07C1F0,hM03A3A0,hM01F7C0,hN0HF80,hN07F,hN03A,')
Aadd(aEtiq,'hN01C,hO08,,hN020,,:::::::::::::::::::^XA')
Aadd(aEtiq,'^MMT')
Aadd(aEtiq,'^PW815')
Aadd(aEtiq,'^LL2318')
Aadd(aEtiq,'^LS0')
Aadd(aEtiq,'^FT32,2304^XG000.GRF,1,1^FS')

IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT217,1910^A0B,202,256^FH\^FD110^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT217,1910^A0B,202,256^FH\^FD100^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT217,1910^A0B,202,256^FH\^FD50^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT217,1910^A0B,202,256^FH\^FD30^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT217,1910^A0B,202,256^FH\^FD15^FS')
ENDIF


IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT387,1821^A0B,82,74^FH\^FD33 Kg^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT387,1821^A0B,82,74^FH\^FD30 Kg^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT387,1821^A0B,82,74^FH\^FD15 Kg^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT387,1821^A0B,82,74^FH\^FD09 Kg^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT387,1821^A0B,82,74^FH\^FD4.5 Kg^FS')
ENDIF

Aadd(aEtiq,'^FT292,1871^A0B,82,84^FH\^FD  Litros ^FS')

IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT444,1768^A0B,31,31^FH\^FDCont\82m 110 Sacos ^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT444,1768^A0B,31,31^FH\^FDCont\82m 100 Sacos ^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT444,1768^A0B,31,31^FH\^FDCont\82m 50 Sacos ^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT444,1768^A0B,31,31^FH\^FDCont\82m 30 Sacos ^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT444,1768^A0B,31,31^FH\^FDCont\82m 15 Sacos ^FS')
ENDIF


IF MV_PAR01=1 // 110
   Aadd(aEtiq,'^FT494,1907^A0B,31,31^FH\^FDDimens\E4es : 80 Cm X 100 Cm ^FS')
ELSEIF MV_PAR01=2   //100
   Aadd(aEtiq,'^FT494,1907^A0B,31,31^FH\^FDDimens\E4es : 75 Cm X 105 Cm ^FS')
ELSEIF MV_PAR01=3   //50
   Aadd(aEtiq,'^FT494,1907^A0B,31,31^FH\^FDDimens\E4es : 63 Cm X 80 Cm ^FS')
ELSEIF MV_PAR01=4   //30
   Aadd(aEtiq,'^FT494,1907^A0B,31,31^FH\^FDDimens\E4es : 59 Cm X 62 Cm ^FS')
ELSEIF MV_PAR01=5   //15
   Aadd(aEtiq,'^FT494,1907^A0B,31,31^FH\^FDDimens\E4es : 39 Cm X 58 Cm ^FS')
ENDIF

Aadd(aEtiq,'^FT553,2303^A0B,45,45^FH\^FDRava Embalagens^FS')
Aadd(aEtiq,'^FT603,2305^A0B,25,28^FH\^FDRua Jos\82 Ger\93nimo da Silva Filho (Ded\82), ^FS')
Aadd(aEtiq,'^FT634,2305^A0B,25,28^FH\^FD66 Bairro Renascer Cabedelo - PB ^FS')
Aadd(aEtiq,'^FT665,2305^A0B,25,28^FH\^FDCEP: 58310-000^FS')
Aadd(aEtiq,'^FT696,2305^A0B,25,28^FH\^FDAtendimento ao Cliente : 0800-7271915^FS')
Aadd(aEtiq,'^FT727,2305^A0B,25,28^FH\^FDTelefax: (83) 3048-1315^FS')
Aadd(aEtiq,'^FT758,2305^A0B,25,28^FH\^FDEmail: Sac@ravaembalagens.com.br^FS')
Aadd(aEtiq,'^FT789,2305^A0B,25,28^FH\^FDCnpj:41.150.160/0001-02^FS')
Aadd(aEtiq,'^FT194,1494^A0B,90,76^FB418,1,0,C^FH\^FDSACO ^FS')
Aadd(aEtiq,'^FT307,1494^A0B,90,76^FB418,1,0,C^FH\^FDPARA ^FS')
Aadd(aEtiq,'^FT420,1494^A0B,90,76^FB418,1,0,C^FH\^FDRES\D6DUO ^FS')
Aadd(aEtiq,'^FT533,1494^A0B,90,76^FB418,1,0,C^FH\^FDINFECTANTE ^FS')
Aadd(aEtiq,'^FT82,897^A0B,51,45^FH\^FDINFORMA\80\E5ES IMPORTANTES:^FS')
Aadd(aEtiq,'^FT254,1048^A0B,37,36^FH\^FDQu\A1mico Respons\A0vel : Val\82ria Peregrino Brito CRQ N\F8 01.201.360^FS')
Aadd(aEtiq,'^FT398,1048^A0B,37,36^FH\^FDRegistro do Produto na Anvisa N\F8 80056810004^FS')
Aadd(aEtiq,'^FT326,1048^A0B,37,36^FH\^FDAutoriza\87\C6o no minist\82rio da Sa\A3de N\F8 8005681^FS')
Aadd(aEtiq,'^FT534,1048^A0B,37,36^FH\^FDUso exclusivo para acondicionamento de res\A1duo infectante^FS')
Aadd(aEtiq,'^FT607,1048^A0B,37,36^FH\^FDSaco n\C6o adequado a conte\A3do perfurante ^FS')
Aadd(aEtiq,'^FT679,1048^A0B,37,36^FH\^FD Manter fora de alcance de crian\87as^FS')
Aadd(aEtiq,'^FT751,1048^A0B,37,36^FH\^FDComposi\87\C6o: Polietileno e Pigmentos^FS')
Aadd(aEtiq,'^FT464,1048^A0B,31,31^FH\^FDProduto de acordo com a legisla\87\C6o: NBR 9191 / NBR 7500 / RDC N\F8 16/2013^FS')
Aadd(aEtiq,'^FT182,1048^A0B,37,36^FH\^FDFabricado por:  41.150.160/0001-02 www.ravaembalagens.com.br^FS')
Aadd(aEtiq,'^FO112,215^GB0,748,3^FS')
Aadd(aEtiq,'^PQ1,0,1,Y^XZ')
Aadd(aEtiq,'^XA^ID000.GRF^FS^XZ')



	   For I:= 1 TO Len(aEtiq)
	 	    
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
			 	    
	 	    @nLin,000 PSAY aEtiq[I]
	        nLin := nLin + 1 // Avanca a linha de impressao
	   Next I

	   nVolume--	   
	   aEtiq := {}

EndDo



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


