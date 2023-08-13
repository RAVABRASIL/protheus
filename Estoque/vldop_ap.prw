#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function VALIDAOP()    // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

SetPrvt( "NORD,cOP" )

nORD1 := SC2->( IndexOrd() )  //Fornece a ordem de abertura do arquivo de �ndice corrente.
nORD2 := SD3->( IndexOrd() )
SC2->( DbSetOrder( 1 ) )   //Ativa o �ndice aberto como �ndice mestre do banco de dados.
SD3->( DbSetOrder( 1 ) )
cOP := Left( M->D3_OP, 8 )  //Extrai os 8 primeiros caracteres retirados do n�mero da OP.
SC2->( Dbseek( xFilial( "SC2" ) + cOP, .T. ) )  //Pesquisa o registro do BD indexado atrav�s da chave especificada.
Do While .F. .and. SubStr( M->D3_OP, 9, 3 ) == "001" .and. SC2->C2_NUM + SC2->C2_ITEM == cOP
   If Left( SC2->C2_PRODUTO, 2 ) == "PI"
      SD3->( Dbseek( xFilial( "SD3" ) + cOP + SC2->C2_SEQUEN, .T. ) )
      If cOP + SC2->C2_SEQUEN <> SD3->D3_OP
         MsgBox( "Producao do PI desta OP ainda nao foi lancada", " INFO", "STOP" )
         Return .F.
      EndIf
   EndIf
   SC2->( DbSkip() )
EndDo
SC2->( DbSetOrder( nORD1 ) )
SD3->( DbSetOrder( nORD2 ) )
Return .T.
