#include "protheus.ch"
#include "topconn.ch"                               
// |���������������������������������|�������������| 
// | AUTOR:Rubem Duarte Oliota       |  28/01/2010 |
// |�����������������������������������������������|
// | PROGRAMA:FATR008                              |
// |�����������������������������������������������|
// | -Impress�o de informativo                     |
//  �����������������������������������������������
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
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"�   "+cPara+"                                                                                         " ,oFont02, 300, , , 0 )
Ini+=nLin                             
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"     Venho  por meio  deste  informar que , nesta data  est� sendo                                  " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"Enviado   por   Vsa .  empresa   a   NFe.   " +cNF+ "   do cliente:                           " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+""+alltrim(cCli)+",                                                                                 " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"Localidade : "+  cLoc  +" - "+upper(cUF)+", onde  conforme  nosso  acordo  em                                        " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"tabela   o  prazo  de  entrega  da   mesma    ser�    no    dia                           " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+""+dtoc(dData)+",  e  que  o  referido  cliente  tem   hor�rio   para" ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"receber  as  Notas  Fiscais  que  � de 07:00hs as 11:00hs e que o                                   " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"caminh�o deve esperar no p�tio da mesma.                                                            " ,oFont02, 300, , , 0 )
Ini+=nLin
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"     Pede-se  tamb�m que toda entrega destinada ao cliente acima                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"citado, caso haja alguma dificuldade no recebimento que seja nos                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"comunicado, pois com o carro ainda no p�tio poderemos intervir e                                    " ,oFont02, 300, , , 0 )
oObject:SAY( Ini+=nLin, 15,   SPACE(TAB)+"at� mesmo agilizar o recebimento.                                                                   " ,oFont02, 300, , , 0 )
//TAB-=5
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15, " " ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Joao Emanuel                                                             "  ,oFont02, 300, , , 0 )
                     oObject:SAY( Ini+=nLin, 15,   SPACE(30)+"Supervisor de Log�stica                                                             "  ,oFont02, 300, , , 0 )
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
        
                    � _______________________

                       Venho  por  meio  deste  informar que, nesta data est� sendo
                   enviado  por   Vsa.   empresa  a  NFe.  ___________  do cliente:
                   _________________________________,
                   localidade:_________________,  onde  conforme  nosso  acordo  em
                   tabela   o   prazo   de   entrega   da   mesma   ser�   no   dia
                   _____/_____/_____,  e  que  o  referido cliente tem hor�rio para
                   receber  as  Notas  Fiscais  que � de 07:00hs as 11:00hs e que o
                   caminh�o deve esperar no p�tio da mesma.

                      Pede-se tamb�m que toda entrega  destinada ao  cliente  acima
                   citado, caso haja alguma dificuldade no recebimento que seja nos
                   comunicado, pois com o carro ainda no p�tio poderemos intervir e
                   at� mesmo agilizar o recebimento.

                                         Jaciara Linhares
                                         Ger.de Log�stica
                                          (83) 3048-1319 
                                          (83) 
*/ 