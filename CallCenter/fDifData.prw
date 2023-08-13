//-------------------------------------------------------------
User Function fDifData( dDataIni,dDataFim,cHoraIni,cHorafim )
//-------------------------------------------------------------

Local dDataI
Local dDataF
Local cHoraI
Local cHoraF 
Local nDifdia := 0
Local nDifhora:= 0
Local cElap1
Local cElap2
Local cHoraspassou := ""
Local nHoraspassou := 0
Local cMeiaNoite
Local cDozeHoras
Local cElap
Local cH
Local nHorastotal  := 0
Local fa := 0

set date brit

dDataI := dDataIni 
dDataF := dDataFim 
cHoraI := cHoraIni 
cHoraF := cHoraFim 

cMeiaNoite := "24:00:00"
cDozeHoras := "12:00:00"
cElap := ""
cH    := ""


nDifdia := (dDataF - dDataI)

If nDifdia = 0
	cElap1 := ElapTime( cHoraI, cHoraF ) 
	nHoraspassou := 0

Elseif nDifdia >= 1
	
	For fa := 1 to nDifdia
		cH     := cHoraI
		cElap  := ElapTime(cH,cMeiaNoite) 
		cHoraspassou := cElap
		nHoraspassou += Val(cHoraspassou)
		cHoraI := cDozeHoras	
		
	Next
	
	cElap1 := Elaptime(cHoraI,cHoraF)

Endif

nHorastotal := Val(cElap1) + nHoraspassou


Return(nHorastotal)