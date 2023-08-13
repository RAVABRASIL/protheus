#include "protheus.ch"
#include "topconn.ch"                               
// |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯| 
// | AUTOR:Rubem Duarte Oliota       |  28/01/2010 |
// |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
// | PROGRAMA:FATR008                              |
// |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
// | -Impressão de informativo                     |
//  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*************
USER FUNCTION FATR010(oObject,cPara ,cNF ,cCli ,cLoc,cUF,dData )
*************
 
     
//oFont01 	:= TFont():New('Verdana'    ,37,37,.F.,.T.,5,.T.,5,.F.,.F.)
oFont01     := TFont():New('Verdana'    ,0,-16,,.T.,0,,400,.F.,.F.,,,,,, )

oFont02     := TFont():New('Verdana'    ,0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
//oFont02 	:= TFont():New('Verdana'    ,17,17,.F.,.T.,5,.T.,5,.F.,.F.)

MsAguarde( { || runReport(@oObject,@cPara,@cNF,@cCli,@cLoc,@cUF,@dData) }, "Aguarde. . .", "Gerando o Informativo ..." )
RETURN
     
 
***************
STATIC Function runReport(oObject,cPara,cNF,cCli,cLoc,cUF,dData)
***************
//
LOCAL nLin:=25
LOCAL Ini:=200
LOCAL TAB:=0


//oObject:SetPortrait()
Local cStartPath := GetSrvProfString("Startpath","")
Local cNameFile	 := "TOPEMAIL"

cStartPath := AjuBarPath(cStartPath)
cNameFile := cStartPath+cNameFile+".bmp"


 
  oObject:StartPage()  
 
 oObject:SayBitmap( 100,25,cNameFile,500,100)
                                                                                                    
 oObject:SAY( Ini+=nLin, 55,  SPACE(40)+"Cabedelo-PB "+dtoc(dDataBase)+"                                                                    " ,oFont02, 300, , , 0 )
 oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"INFORMATIVO URGENTE                                                                                " ,oFont01, 300, , , 0 )
Ini+=nLin
//TAB+=5
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"À   "+cPara+"                                                                                         " ,oFont02, 300, , , 0 )
Ini+=nLin                             
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"     Venho  por meio  deste  informar que , nesta data  está sendo                                  " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"Enviado   por   Vsa .  empresa   a   NFe.   " +cNF+ "   do cliente:                           " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+""+alltrim(cCli)+",                                                                                 " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"Localidade : "+  cLoc  +" - "+upper(cUF)+", onde  conforme  nosso  acordo  em                                        " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"tabela   o  prazo  de  entrega  da   mesma    será    no    dia                           " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+""+dtoc(dData)+",  e  que  o  referido  cliente  tem   horário   para" ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"receber  as  Notas  Fiscais  que  é de 07:00hs as 11:00hs e que o                                   " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"caminhão deve esperar no pátio da mesma.                                                            " ,oFont02, 300, , , 0 )
Ini+=nLin
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"     Pede-se  também que toda entrega destinada ao cliente acima                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"citado, caso haja alguma dificuldade no recebimento que seja nos                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"comunicado, pois com o carro ainda no pátio poderemos intervir e                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"até mesmo agilizar o recebimento.                                                                   " ,oFont02, 300, , , 0 )
//TAB-=5
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Joao Emanuel                                                             "  ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Supervisor de Logística                                                             "  ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Tel: (83) 3048-1321                                                          "  ,oFont02, 300, , , 0 )
					 oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Cel: (83) 9134-9659                                                          "  ,oFont02, 300, , , 0 )                     
	
 //   oObject:Preview()
  oObject:EndPage()
RETURN

/*------------------------------------Resultado da Impressao-----------------------------------------------------
                  _______________________________________________________________
                  |                                                               \
                  |                           RAVA                                 \
                  \                        embalagens                              |
                   \_______________________________________________________________|   
       
                                                    Cabedelo-PB, _____/_____/______
                                     INFORMATIVO URGENTE
        
                    À _______________________

                       Venho  por  meio  deste  informar que, nesta data está sendo
                   enviado  por   Vsa.   empresa  a  NFe.  ___________  do cliente:
                   _________________________________,
                   localidade:_________________,  onde  conforme  nosso  acordo  em
                   tabela   o   prazo   de   entrega   da   mesma   será   no   dia
                   _____/_____/_____,  e  que  o  referido cliente tem horário para
                   receber  as  Notas  Fiscais  que é de 07:00hs as 11:00hs e que o
                   caminhão deve esperar no pátio da mesma.

                      Pede-se também que toda entrega  destinada ao  cliente  acima
                   citado, caso haja alguma dificuldade no recebimento que seja nos
                   comunicado, pois com o carro ainda no pátio poderemos intervir e
                   até mesmo agilizar o recebimento.

                                         Jaciara Linhares
                                         Ger.de Logística
                                          (83) 3048-1319 
                                          (83) 
*/ 