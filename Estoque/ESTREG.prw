#include "protheus.ch"
#include "topconn.ch"


User Function ESTREG()

Pergunte("ESTATP",.T.)

DbSelectArea("SB1")
cFiltro := "B1_COD>=mv_par01.and.B1_COD<=mv_par02.and.B1_ATIVO='S'"
cChave  := "B1_FILIAL+B1_COD"
cIndSB1 := CriaTrab( nil, .F. )
IndRegua( "SB1", cIndSB1, cChave, , cFiltro, "Selecionando produtos...")
//SetRegua( SB1->( Lastrec() ) )
SB1->( DBGoTop() )

/*DBSelectArea("SD1")
cFiltro := "D1_COD>=mv_par01.and.D1_COD<=mv_par02.and.D1_TES!='133'.and.D1_TIPO='N'.and.D1_PEDIDO!=' '"
cChave  := "D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA"
cIndSD1 := CriaTrab( nil, .F. )
IndRegua( "SD1", cIndSD1, cChave, , cFiltro, "Atualizando precos...")
SD1->( DBGoTop() )
SetRegua( SD1->( Lastrec() ) )*/

Do while ! SB1->( EoF() )

	SB1->( dbSkip() )
	IncRegua()

EndDo

Return Nil
