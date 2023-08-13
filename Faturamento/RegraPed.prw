#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REGRAPED  ºAutor  ³Eurivan Marques     º Data ³  12/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida Pedido de Venda                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************
User Function RegraPed()
************************
Local lOk := .T.


//if TemSac()
//Retirado em 26/06/09
//   if Avista()
//      if !ColFab()
//         Aviso("Bloqueio","Para venda de Sacola não será permitido informar transportadora. A coleta será feita pelo cliente.",{"OK"})
//         lOk := .F.
//      endif
/*
      //Comentado a partir de 01/04/2009
      if !SN()
         Aviso("Bloqueio","Para venda de Sacola a modalidade não poderá ser UNI. Mude o codigo do vendedor para 'VD'",{"OK"})
         lOk := .F.
      endif
*/      
      //Sacola nao poderá ser faturado SN, somente 4DD
      //Incluido a partir de 01/04/2009
      
      /*  CHAMADO 001629 A PEDIDO DE MARCOS 
      if SN()
         Aviso("Bloqueio","Para venda de Sacola a modalidade deverá ser 4DD.",{"OK"})
         lOk := .F.
      endif
      */
      
//   else
//      Aviso("Bloqueio","Para venda de Sacola a condição de pagamento deverá ser '012' (A VISTA).",{"OK"})    
//      lOk := .F.
//   endif
//   Return lOK
//endif


	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE))
	if SN() .or. M->C5_DESC1 > 0 
	   if SA1->A1_BLQXDD == "S"
	   //      if !Cli6DD()    
	   		If  alltrim(upper(FunName())) != "FATC019"
	            Aviso("Bloqueio","Cliente bloqueado para venda xDD.",{"OK"})  
	            Return .F.
	   		Endif
	   endif   
	endif


return lOk

//FR - 28/04/2011 - CHAMADO 002040 - Marcos
/*
*****************************
User Function fValidXDD(cCliente)
***************************** 
Local lValido := .T.
  

//esta função será chamada assim que digitado o código do cliente, para que
//o usuário não tenha que completar todo o pedido e haver a validação só no fim (botão OK)

DbSelectArea("SA1")
DbSetOrder(1)
SA1->(DbSeek(xFilial("SA1")+ cCliente  ))
If SA1->A1_BLQXDD == "S"
   //Aviso("Bloqueio","Cliente bloqueado para venda xDD.",{"OK"})  
   Alert( "Cliente bloqueado para venda xDD." )     
    //lValido := .T.
Endif 

Return (lValido)  
*/

//FR - 08/08/2011 - CHAMADO 002203 - Ruben Castedo
*****************************************
User Function RegraPAGO(cCliente ) //, cLoja)
***************************************** 
Local lValido := .T.
Local cQuery  := "" 
Local LF	  := CHR(13) + CHR(10) 
Local nDias	  := 0

//MSGBOX("ENTROU REGRA PAGO")

cQuery := " SELECT Top 1 " + LF
cQuery == " E1_CLIENTE, E1_LOJA, E1_EMISSAO, " + LF  
cQuery += " CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112) - CONVERT(datetime,E1_EMISSAO,112)AS FLOAT) as DIAS
cQuery += " FROM " + RetSqlName("SE1") + " SE1  " + LF
cQuery += " WHERE   " + LF
cQuery += " CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112) - CONVERT(datetime,E1_EMISSAO,112)AS FLOAT)>120  " + LF
cQuery += " AND E1_CLIENTE= '" + Alltrim(cCliente) + "' " + LF
//cQuery += " AND E1_LOJA= '" + Alltrim(cLoja) + "' " + LF
cQuery += " AND E1_BAIXA ='' " + LF
cQuery += " AND E1_TIPO='NF' " + LF
cQuery += " AND SE1.D_E_L_E_T_!='*' " + LF 
cQuery += " ORDER BY DIAS DESC " + LF

MemoWrite("C:\Temp\SE1_cli.sql", cQuery )
//query pra validar se o cli tem nf sem pagar há mais de 120 dias

If Select("SE1X") > 0
	DbSelectArea("SE1X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE1X"

SE1X->( DbGoTop() )

While SE1X->( !EOF() )
	nDias := SE1X->DIAS	
	SE1X->(Dbskip())
Enddo

If nDias > 120
	MsgInfo("O Cliente possui pendência no Financeiro !" , "INCLUSÃO NÃO PERMITIDA" )
	lValido := .F.
Endif


Return (lValido)


//Funcao que verifica se a condicao de pagamento no pedido de venda eh 012 a vista
************************
Static Function Avista()
************************
return Alltrim(M->C5_CONDPAG) == "012"


//Funcao que verifica se a coleta sera na Fabrica, ou seja, sem tranportadora
************************
Static Function ColFab()
************************
return Empty(M->C5_TRANSP) .or. Alltrim(M->C5_TRANSP) == '024' 


//Funcao que verifica se a modalidade da venda eh SSNN
********************
Static Function SN()
********************
return "VD" $ M->C5_VEND1
//return "VD" $ M->C5_VEND1 .AND. M->C5_DESC <> 40


//Funcao que verifica se existe produtos do grupo 'sacola' no pedido de venda
************************
Static Function TemSac()
************************
local lTem := .F.
Local _nX
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Local nPosDel  := Len(aHeader)+1

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

for _nX := 1 to Len(aCols)
   if !aCols[_nX,nPosDel]
      SB1->(DbSeek(xFilial("SB1")+aCols[_nX,nPosProd]))
      if Alltrim(SB1->B1_GRUPO) $ "G/H"
         lTem := .T.
         exit       
      endif
   endif
next

return lTem

//Funcao que verifica se o cliente podera comprar na modalidade 6DD
************************
Static Function Cli6DD()
************************
Local lOk := .T.
Local aCli := {"000300","002410","002768","002737","002794","002430","004385","002020",;
               "002800","002709","002711","001605","002525",;
               "002675","002708","002691","002733","004369","002177",;
               "002765","001168","000043","001104","002681",;
               "000730","002248","002750","002671","002629","001132",;
               "001051","002214","001056","001188","001079","002788",;
               "001967","002757","000091","002719","002756","001215",;
               "001175","004372","004386","000117","002660","004387","000127",;
               "002696","002209","002717","000967","002743","002033","002657",;
               "002634","002591","000733","001975","004281","002741","000598","002706",;
               "002457","002704","000393","001638","001464","002264","002105",;
               "002122","002803","002663","001458","002734","004374","002550",;
               "002265","000604","002695",;
               "002466","002725","004347",;
               "002228",;
               "004348",;
               "001110",;
               "002842",;
               "002162","002492",;
               "000212",;
               "002771"}
            
//             "002466","002725","004347"} //Retirado  em  31/01/08 solicitado por Marcos/Janderley
//             "002466","002725","004347"} //Bloqueado em  19/05/08 solicitado por Flavia
//             "002228"}                   //Retirado em   07/02/08 solicitado por Marcos/Janderley
//             "002228"}                   //Bloqueado em  19/05/08 solicitado por Flavia                      
//             "004348"}                   //Retirado em   11/02/08 solicitado por Marcos/Janderley
//             "004348"}                   //Bloqueado em  19/05/08 solicitado por Flavia
//             "001110"}                   //Retirado em   13/02/08 solicitado por Marcos/Janderley
//             "001110"}                   //Bloqueado em  19/05/08 solicitado por Flavia
//             "002842"}				   //Retirado em   14/02/08 solicitado por Marcos/Janderley
//             "002842"}				   //Bloqueado em  16/05/08 solicitado por Flavia
//             "002162","002492"}	       //Retirado em   22/02/08 solicitado por Marcos/Janderley
//             "002162","002492"}	       //Bloqueado em  19/05/08 solicitado por Flavia          
//             "000212"}	               //Retirado em   26/02/08 solicitado por Marcos/Janderley
//             "000212"}	               //Bloqueado em  19/05/08 solicitado por Flavia
//             "002771"}                   //Retirado em   29/02/08 solicitado por Marcos/Janderley
//             "002771"}                   //Bloqueado em  19/05/08 solicitado por Flavia
//             "002197","002759","001358"} //Retirado em   24/03/08 solicitado por Marcos/Janderley
//             "002699"}                   //Retirado em   26/03/08 solicitado por Marcos/Janderley/Figueiredo
//			   "002611"}				   //Retirado em   26/03/08 solicitado por Marcos/Janderley
//             "001097","002498"}          //Retirado em   28/03/08 solicitado por Marcos/Janderley
//             "000109"                    //Retirado em   03/04/08 solicitado por Marcos/Janderley
//             "004384","002174"           //Retirado em   04/04/08 solicitado por Marcos/Janderley
//             "001728"                    //Retirado em   11/04/08 solicitado por Marcos/Janderley
//             "001588"                    //Retirado em   14/04/08 solicitado por Marcos/Janderley
//             "002449"                    //Retirado em   22/04/08 solicitado por Marcos/Janderley
//             "004314"                    //Retirado em   23/04/08 solicitado por Marcos/Janderley
//			   "002113",				   //Retirado em   02/05/08 solicitado por Marcos/Janderley
//             "002042"                    //Retirado em   13/05/08 solicitado por Janderley
//             "004379"                    //Retirado em   27/05/08 solicitado por Figueiredo (Flavia so hoje)


//Cliente(s) Novo(s) liberado(s)
//002856     Liberado em  04/03/08 solicitado por Marcos/Janderley
//002829     Liberado em  13/05/08 solicitado por Marcos/Janderley A1_PRICOM = 25/01/2008
//002831     Liberado em  13/05/08 solicitado por Marcos/Janderley A1_PRICOM = 29/01/2008
//002820     Liberado em  13/05/08 solicitado por Marcos/Janderley A1_PRICOM =   /  /    
//002863     Liberado em  14/05/08 solicitado por Marcos/Janderley A1_PRICOM =   /  /    
//002922     Liberado em  27/05/08 solicitado por Marcos/Janderley A1_PRICOM = 16/05/2008 (Flavia somente hoje) 

//Clientes antigos Bloqueados depois
//             "002611" //Bloqueado em 18/03/2008 solicitado por Alcineide autorizado por Marcelo

Local nCli := aScan(aCli,{|x| x == M->C5_CLIENTE})
DbSelectArea("SA1")
DbSetOrder(1)
SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE))
//Se nao eh um cliente novo e nao faz parte na lista acima
lOk := ( !Empty(SA1->A1_PRICOM) .and. SA1->A1_PRICOM < CTOD("10/01/08") .AND. nCli == 0 )

return lOk