***********************************************
User Function MetaDiaria( nMeta, nDias, aReal )
***********************************************

Local nPerc5   := 12.5 //SuperGetMV("RV_PERC5", .F., 12.5) // Percentual para os 5 primeiros dias
Local nPercP   := 66.0 //SuperGetMV("RV_PERCP", .F., 66.0) // Percentual para os dias entre o sexto e o penultimo
Local nPercU   := 21.5 //SuperGetMV("RV_PERCU", .F., 21.5) // Percentual para o ultimo dia
Local nMeta5   := (nMeta*(nPerc5/100))/5            // Meta diaria para os 5 primeiros dias
Local nMetaP   := (nMeta*(nPercP/100))/(nDias-6)    // Meta diaria entre o sexto e o penultimo dia
Local nMetaU   :=  nMeta*(nPercU/100)               // Meta para o ultimo dia
Local nDifAcum := nIdealAcum := nAjuste := 0
Local aRet     := {}
Local _nX

for _nX := 1 to nDias
   
   Aadd( aRet, {_nX,0,0,0,0,0,0} )
   if _nX <= 5
      aRet[_nX,2] := nMeta5
   elseif _nX > 5 .and. _nX < nDias
      aRet[_nX,2] := nMetaP
   else
      aRet[_nX,2] := nMetaU
   endif
   
   if ValType( aReal ) == "A"
      if Len(aReal) >= _nX
         nIdealAcum  += aRet[_nX,2] // Ideal Acumulado
         aRet[_nX,3] := nIdealAcum  // Atualizo o ideal acumulado
         aRet[_nX,4] := aReal[_nX]  // Atualizo o realizado no dia
         aRet[_nX,5] := aRet[_nX,2] - aRet[_nX,4] // Diferenca Meta e Realizado      
         nDifAcum    += aRet[_nX,5] // Diferenca acumulada
      endif      
   endif
   
next _nX
// Calculo do ajuste e da Nova Meta
for _nX := 1 to nDias
   nAjuste := 0
   if aRet[_nX,4] = 0 .and. nDifAcum > 0 .and. aRet[_nX,2] > 0 
      if _nX <= 5
         nAjuste := nDifAcum*(nPerc5/100)/( 5-ContaReal(aReal,1,5) )
      elseif _nX > 5 .and. _nX < nDias
         if ContaReal( aReal, 1, nDias ) < 5
            nAjuste := nDifAcum*(nPercP/100)         
         else
            nAjuste := nDifAcum*( (nPerc5+nPercP)/100 )
         endif
         nAjuste := nAjuste / ( nDias-6-ContaReal( aReal, 6, nDias ) )         
      else
         if ContaReal( aReal, 1, nDias ) < ( nDias-1 )
            nAjuste := nDifAcum*(nPercU/100)
         else
            nAjuste := nDifAcum         
         endif   
      endif   
      aRet[_nX,6] := nAjuste         
   endif

   if nAjuste > 0 
      aRet[_nX,7] := aRet[_nX,2] + nAjuste
   elseif nDifAcum <= 0 
      aRet[_nX,7] := aRet[_nX,2]      
   else   
      aRet[_nX,7] := aRet[_nX,4]         
   endif         
next _nX

return aRet


**********************************************
static function ContaReal( aReal, nIni, nFim )
**********************************************
Local nRet := 0

if nIni <= Len(aReal)
   if nFim > Len(aReal)
      nRet := Len(aReal) - nIni + 1
   else
      nRet := nFim - nIni + 1   
   endif
endif

return nRet