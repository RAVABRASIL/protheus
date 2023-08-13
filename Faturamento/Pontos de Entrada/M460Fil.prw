#Include "Rwmake.ch"


//*****************************************************************************************
// Descricao -> Ponto de entrada executado para filtrar o SC9 no programa que gera a 
//               nota fiscal
// Usado na geracao da nota fiscal / Autora Fl�via Rocha  / Data 27/11/2008
//*****************************************************************************************
USER FUNCTION M460Fil() 

Local cFiltraC9 := "" 


cFiltraC9 := "DTOS(C9_DATALIB) > '20000101' "


//cFiltraC9 := "DTOS(C9_DATALIB) <'20110120' .AND. SC9->(RECNO()) <= 146932"


//cFiltraC9 := "ALLTRIM(C9_PEDIDO) >= '047351' .AND. ALLTRIM(C9_PEDIDO) <='051023' " 



/*
cFiltraC9 := "ALLTRIM(C9_PEDIDO) $ '048781/048782/048783/048784/048785/048845/048846/048847/048848/048849/049105/049536/049570 "
cFiltraC9 += "/049660/049662/049751/049757/049818/049842/049858/049885/049923/049924/049925/049926/049949/049965/050001/050003/050004"
cFiltraC9 += "/050036/050038/050047/050064/050102/050111/050120/050147/050181/050182/050183/050184/050185/050186/050187/050189/050190/050191/050249"
cFiltraC9 += "/050253/050257/050259/050264/050272/050286/050289/050336/050338/050346/050349/050360/050375/050393/050430/050433/050438/050439"
cFiltraC9 += "/050446/050448/050449/050450/050451/050452/050461/050482/050488/050492/050509/050522/050538/050539/050565/050568/050578/050583/050603"
cFiltraC9 += "/050604/050610/050614/050616/050633/050640/050647/050653/050657/050661/050662/050664/050666/050668/050669/050681/050683/050684/050686/050687"
cFiltraC9 += "/050691/050693/050694/050697/050700/050703/050704/050713/050714/050716/050717/050718/050722/050731/050732/050733/050746/050747/050751/050753"
cFiltraC9 += "/050756/050758/050767/050770/050780/050783/050793/050794/050795/050796/050797/050799/050800/050801/050803/050808/050809/050810/050812/050814"
cFiltraC9 += "/050817/050818/050819/050822/050823/050824/050825/050829/050832/050833/050834/050835/050836/050838/050839/050840/050841/050842/050843/050844"
cFiltraC9 += "/050846/050847/050848/050849/050850/050851/050852/050853/050854/050855/050857/050859/050863/050866/050867/050870/050871/050874/050875/050876"
cFiltraC9 += "/050877/050878/050879/050883/050884/050886/050887/050888/050889/050891/050893/050900/050901/050902/050907/050914/050916/050920/050921/050922"
cFiltraC9 += "/050923/050927/050928/050929/050931/050933/050934/050935/050936/050938/050939/050940/050941/050942/050943/050944/050946/050947/050948/050950"
cFiltraC9 += "/050951/050953/050954/050955/050956/050957/050958/050959/050960/050962/050963/050964/050965/050966/050967/050968/050969/050971/050972/050973"
cFiltraC9 += "/050974/050976/050978/050979/050980/050981/050982/050983/050984/050985/050986/050987/050988/050989/050991/050992/050993/050994/050995/050996"
cFiltraC9 += "/050997/050998/050999/051000/051002/051003/051004/051005/051006/051007/051009/051010/051011/051013/051014/051015/051016/051017/051018/051019"
cFiltraC9 += "/051020/051021/051022/051023'"
*/

Return(cFiltraC9)