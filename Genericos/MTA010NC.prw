#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA010NC  บ Autor ณ MP10 IDE            บ Data ณ  16/07/2010บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada no cadastro de produtos, ao escolher      บฑฑ
ฑฑบ          ณ a op็ใo "C๓pia", o programa irแ copiar todos os campos,    บฑฑ
ฑฑบ            exceto os campos mencionados no array do ponto de entrada   ฑฑบ
ฑฑบ			   abaixo.													   ฑฑบ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cadastro de Produtos  - CำPIA DE PRODUTOS                  บฑฑ
// Autoria   : Flแvia Rocha                                                //
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MTA010NC() 

//Este ponto de entrada irแ impedir a c๓pia do campo "Entra MRP" (B1_MRP) para um
// novo cadastro

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


Local aCpoNC := {}

AAdd( aCpoNC, 'B1_MRP' )

AAdd( aCpoNC, 'B1_UCOM' )
AAdd( aCpoNC, 'B1_DATREF' )
AAdd( aCpoNC, 'B1_UREV' )
AAdd( aCpoNC, 'B1_CONINI' )
AAdd( aCpoNC, 'B1_CODBAR' )
AAdd( aCpoNC, 'B1_NATUREZ' )
AAdd( aCpoNC, 'B1_TIPCAR' )
AAdd( aCpoNC, 'B1_EMIN' )
AAdd( aCpoNC, 'B1_EMINCX' )
AAdd( aCpoNC, 'B1_ESTSEG' )
AAdd( aCpoNC, 'B1_ESTSEGX' )
AAdd( aCpoNC, 'B1_LE' )
AAdd( aCpoNC, 'B1_MRP' )
AAdd( aCpoNC, 'B1_RAVACQ' )
AAdd( aCpoNC, 'B1_POSIPI' )   //FR - 04/09/12 - Solicitado por Eurivan

Return (aCpoNC)


