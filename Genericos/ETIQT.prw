#Include "protheus.ch"
#Include "topconn.ch"

*************

User Function ETIQT()

*************

  processa( { || eitque() } )

return


***************

static Function eitque()

***************
aImp := {}
aRet := {}
aRET := u_senha2( "10", 1, "Transformação de produtos" )
if ! aRET[1]
  return
endIf
nHandle := nCont := 0
cQuery := "select Z00_STATUS,Z00_CODIGO, Z00_CODBAR from Z00020 where Z00_FILIAL = '" + xFilial('Z00') + "' and Z00_STATUS in ('F') and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
do while ! TMP->( EoF() )
  Aadd( aIMP, { "B" + iif( alltrim( TMP->Z00_STATUS ) == 'F',"Produto: ", iif(alltrim( TMP->Z00_STATUS ) == 'S',"Amostra: ","Incompleto: ") ) +;
              AllTrim( TMP->Z00_CODIGO ), alltrim ( TMP->Z00_CODBAR ), alltrim( TMP->Z00_STATUS ) } )
  nCont++
  TMP->( dbSkip() )
endDo
for x := 1 to nCont //len( aImp )
  If x > 1
    Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
  EndIf
If Abre_Impress()
  Inc_Linha( aIMP[ x, 1 ], .T. )
  Inc_Linha( aIMP[ x, 2 ], .F. )
  Fecha_Impress()
  // Pausa a cada etiqueta
EndIf
next

if msgYesNo("Reimprimir etiquetas ?")
	if u_senha2( "08", 2 )[1]
		  for x := 1 to nCont
		    If x > 1
              Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
		    EndIf
		    If Abre_Impress()
		      Inc_Linha( aIMP[ x, 1 ], .T. )
		      Inc_Linha( aIMP[ x, 2 ], .F. )
		      Fecha_Impress()
		    // Pausa a cada etiqueta
		    EndIf
		  next
	endIF
endIf
dbSelectArea('Z00')
Z00->( dbSetOrder( 7 ) )
for x := 1 to nCont
  Z00->( dbSeek( xFilial('Z00') + aIMP[ x, 2 ] ) )
  RecLock( "Z00" , .F.)                                                       //amostras
  Z00->Z00_STATUS := ' '//iif( aIMP[ x, 3 ] == "F", "",iif( aIMP[ x, 3 ] == "C", "P", "SP") )
  Z00->( msUnlock() )
next  
Z00->( dbCloseArea() )

TMP->( dbCloseArea() )

return

***************

Static Function Abre_Impress()

***************
cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, '3' )
Return .T.

***************

Static Function Inc_Linha( cIMP, lPRIMLINHA )

***************
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL

***************

Static Function Fecha_Impress()

***************
ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL

***************

Static Function Reimprime()

***************
aUSUARIO := u_senha2( "01", 2 )
If ! aUSUARIO[ 1 ]
	Return
EndIf
For nCONT := 1 To Len( aIMP )
		If Abre_Impress()
			 Inc_Linha( aIMP[ nCONT, 2 ], .T. )
			 Inc_Linha( aIMP[ nCONT, 4 ], .F. )
			 Fecha_Impress()
			 // Pausa a cada etiqueta
			 If Len( aIMP ) > 1 .and. nCONT <> Len( aIMP )
				  Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
			 EndIf
		EndIf
Next
Return NIL