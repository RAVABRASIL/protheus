******************************************************
User Function MetaDia( Meta, nReal, nDUtil, nDCorri  )
******************************************************

Local nPerc5   := SuperGetMV("RV_PERC5", .F., 12.5)/100 // Percentual para os 5 primeiros dias
Local nPercP   := SuperGetMV("RV_PERCP", .F., 66.0)/100 // Percentual para os dias entre o sexto e o penultimo
Local nPercU   := SuperGetMV("RV_PERCU", .F., 21.5)/100 // Percentual para o ultimo dia
Local nMeta    := nNMeta := 0
Local nMeta5   := (Meta*nPerc5)/5            // Meta diaria para os 5 primeiros dias
Local nMetaP   := (Meta*nPercP)/(nDUtil-6)    // Meta diaria entre o sexto e o penultimo dia
Local nMetaU   := nMeta*nPercU               // Meta para o ultimo dia
Local nDifAcum := nIdealAcum := 0 
Local nAjuste5 := nAjusteP := nAjusteU := 0
Local nDias5   := nDiasP := nDiasU := 0
Local aRet     := {0,0,0,0}

if nDCorri <= 5
   nMeta := nMeta5*nDCorri
elseif nDCorri > 5 .and. nDCorri < nDUtil
   nMeta := (nMeta5*5)+(nMetaP*(nDCorri-5))
else
   nMeta := (nMeta5*5)+(nMetaP*(nDCorri-6))+nMetaU
endif   
   
nDifAcum := nMeta - nReal

if nDifAcum > 0 
   nAjuste5 := nDifAcum * nPerc5
endif

if nDCorri < 5
   nDias5 := 5 - nDCorri
endif  

if nDifAcum > 0 
   nAjusteP := nDifAcum * nPercP
endif

if nDCorri < (nDUtil - 1)
   nDiasP := nDUtil - nDCorri - nDias5 - 1
endif  

if nDifAcum > 0 
   nAjusteU := nDifAcum * nPercU
endif

if nDCorri < nDUtil
   nDiasU := 1
endif  

if nDCorri < 5
   nNMeta := nMeta5 + ( nAjuste5/nDias5 )
elseif nDCorri < (nDUtil-1) 
   nNMeta := nMetaP + nAjuste5 + (nAjusteP/nDiasP )
else
   nNMeta := nAjuste5 + nAjusteP + nAjusteU
endif   

return { nMeta, nDifAcum, nNMeta }