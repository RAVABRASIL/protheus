User function INFANT()

Public _aQtdAnt:={}  

nRecno := SC6->( Recno() )
// Posiciona no Pedido 
DbSelectArea("SC6")
DbSetOrder(1)
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
cNum:=SC6->C6_NUM 		

while !SC6->(EOF()) .AND. SC6->C6_NUM=cNum  
      aAdd( _aQtdAnt, { SC6->C6_PREPED, SC6->C6_PRODUTO, SC6->C6_QTDVEN } )
      SC6->(dbSkip())
Enddo
SC6->( dbGoto( nRecno ) )
Return