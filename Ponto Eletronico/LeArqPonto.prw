#include "rwmake.ch"

User Function LeArqPon()

	cDLL     := "zap.dll"
	nHandle  := ExecInDllOpen( cDLL )

	if nHandle = -1
	  MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	  Return NIL
	EndIf

	cRETDLL := ExecInDLLRun( nHandle, 1, "01/09/2006,05/09/2006" )
	ExecInDLLClose( nHandle )
	MsgAlert( cRETDLL )

Return NIL

/*
  where
    (Data >= :FromDate) and
    (Data <= :ToDate)
*/
