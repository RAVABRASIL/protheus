#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MT200PAI()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

SB1->( DBSetOrder(1) )
SB5->( DBSetOrder(1) )
If SB5->( DBSeek(xFilial("SB5")+SG1->G1_COMP ) )
   If SB1->( DBSeek(xFilial("SB1")+SG1->G1_COMP ) )
      If SB1->B1_TIPO == 'ME'
         AVISO('M E N S A G E M','Quant. Material de Embalagem -> '+Transf( (SB5->B5_COMPR*SB5->B5_LARG*SB5->B5_ESPESS*SB5->B5_DENSIDA)/1000,"@E 999.999999" ),{"OK"})
      Endif
   Endif
Endif
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __RETURN(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
