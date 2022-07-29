#include "fivewin.ch"
#include "constant.ch"

// TCyclometric class for Italian Lottery






Function Test()
  local oCicloMetric
  local aCicloSmall:=array(11)
  local oDlg,oFont,oBold
  local oBtnPos,oBtnClose
  local nBottom   := 43
  local nRight    := 120
  local nWidth    := Max( nRight * DLG_CHARPIX_W, 180 )
  local nHeight   := nBottom * DLG_CHARPIX_H
  local cUrl:="http://www.televideo.rai.it/televideo/pub/solotesto.jsp?pagina=786"
  local adata:=TestUrl( cUrl )
  local oBrw
  local aColors:= {GetBackColor('blanchedalmond'),;
                   GetBackColor('bisque'),;
                   GetBackColor('blueviolet'),;
                   GetBackColor('chocolate'),;
                   GetBackColor('darkcyan'),;
                   GetBackColor('darkmagenta'),;
                   GetBackColor('firebrick'),;
                   GetBackColor('honeydew'),;
                   GetBackColor('lightcoral'),;
                   GetBackColor('palevioletred'),;
                   GetBackColor('seagreen')}





   DEFINE FONT oFont NAME "TAHOMA" SIZE 0,-10
   DEFINE FONT oBold NAME "TAHOMA" SIZE 0,-12  BOLD

   DEFINE DIALOG oDlg SIZE  nWidth, nHeight  ;
      PIXEL TRUEPIXEL  FONT oFont   ;  //RESIZABLE
      TiTle "Manage Ciclometric"


     @ 200,500 XBROWSE oBrw OF oDlg SIZE 300,250 PIXEL NOBORDER;
      COLS 1,2,3,4,5,6;
      HEADERS "Ruota", "E1", "E2", "E3", "E4", "E5" ;
      SIZES  80,30,30,30,30,30  ;
      ARRAY adata ;
      CELL LINES

    WITH OBJECT oBrw
      :nRowHeight    := 20
      :nClrBorder := CLR_GRAY
      :lDrawBorder := .t.
      :nColorBox := CLR_HRED

      :lHeader             := .f.
      :lHscroll            := .f.
      :lvscroll            := .f.
      :l2007               := .F.
      :l2015               := .t.

      :nStretchCol         := STRETCHCOL_WIDEST
      :lAllowRowSizing     := .F.
      :lAllowColSwapping   := .F.
      :lAllowColHiding     := .F.
      :lRecordSelector     := .F.
      :nColDividerStyle    := LINESTYLE_LIGHTGRAY
      :nRowDividerStyle    := LINESTYLE_LIGHTGRAY
      :bClrStd := { || { CLR_BLACK, If( oBrw:KeyNo % 2 == 0, GetBackColor('lightblue') , CLR_WHITE ) } }

      :bChange  := { ||Showform(oBrw:nArrayAt,oCicloMetric,aColors,oBrw) }

      :CreateFromCode()
   End








 //------------------------------------------------------------------------//
    //Big Circle
   oCicloMetric:= TCyclometric():New(90,15,510,510, oDlg,380)
   oCicloMetric:lShowNumbers:=.t.
   oCicloMetric:nDimPenCircle:= 3
   oCicloMetric:nDimPenLine:= 3



   @ 100,10 BUTTON oBtnClose PROMPT "Close" of oDlg  SIZE 80,22 ACTION oDlg:End()
   @ 100,10 BUTTON oBtnPos PROMPT "Test position" of oDlg  SIZE 80,22 ;
    ACTION NIL // Mostra_Form(aCicloSmall,aColors,oBrw)







     oDlg:bResized := <||
     local oRect := oDlg:GetCliRect()
        oBtnClose:nLeft    := oRect:nRight - 100
        oBtnClose:nTop     := oRect:nBottom - 45
        oBtnPos:nLeft      := oRect:nLeft +10
        oBtnPos:nTop       := oRect:nBottom - 45

                 RETURN NIL
                       >



   ACTIVATE DIALOG oDlg CENTERED ;
   ON INIT (aCicloSmall:=Mostra_Ciclo_Ruote(oBrw,oDlg,aCicloSmall) ,;
                        Eval(oDlg:bResized))

   RELEASE FONT oFont, oBold
   Return nil

//---------------------------------------------------------------------------//

Function Showform(nRecord,oCiclo,aColors,oBrw)
   local aNumeri:= {}
   local atemp:= {}
   local cText
   local num1,num2,num3,num4,num5


   nColor:=aColors[ nRecord ]

   AAdd(atemp,oBrw:aArrayData[ nRecord ] )

   cText:=atemp[1][1]  //text
   num1 :=atemp[1][2]
   num2 :=atemp[1][3]
   num3 :=atemp[1][4]
   num4 :=atemp[1][5]
   num5 :=atemp[1][6]

    aNumeri := {num1,num2,num3,num4,num5}

   ASort( aNumeri, nil, nil, { |x,y| x < y } )

   num1 :=aNumeri[1]
   num2 :=aNumeri[2]
   num3 :=aNumeri[3]
   num4 :=aNumeri[4]
   num5 :=aNumeri[5]
    oCiclo:Paint()
   oCiclo:Distance_Multiple(val(num1),val(num2),val(num3),val(num4),val(num5),nColor,oCiclo:apos)

   Return nil
//-----------------------------------------------------------------------------------------/

  Function TestUrl( cUrl )
        local cRet:=""
        local cData:=""
        local cFile := "test.txt"
        local cBuff
        local nHndl
        local aShow:={}
        local nI

        IF IsInternet()
               cRet := WebPageContents( cUrl )
               cData := WebPageContents( cUrl )
        if Empty( cRet )
          ? "Invalid URL"
       else
            //per la data estrazione
            cData := subStr( cData, at( "ALMANACCO",  cData )+9 )
            cData := allTrim( subStr( cData, 1, at("BARI",  cData ) -1 ) )

            // per il blocco Bari - Nazionale
            cRet := subStr( cRet, at( "BARI", cRet ) )
            cRet := allTrim( subStr( cRet, 1, at( "Controlla", cRet ) - 1 ) )

            nHndl := fCreate( cFile )
            fWrite( nHndl, cRet )
            fClose( nHndl )
            IF ( nHndl := fOpen( cFile ) ) < 1
                msgStop( "UNABLE TO OPEN: " + cFile  )
            ELSE
                aShow := {}
                WHILE hb_fReadLine( nHndl, @cBuff, chr( 10 ) ) == 0
                    cBuff := allTrim( cBuff )
                    IF ! empty( cBuff )
                        aAdd( aShow, {} )
                        aAdd( aTail( aShow ), subStr( cBuff, 1, 11 ) )
                        FOR nI := 12 TO 28 STEP 4
                            aAdd( aTail( aShow ), subStr( cBuff, nI, 2 ) )
                        NEXT
                    ENDIF
                ENDDO
                * xBrowse( aShow )
                ferase(cfile)
                return aShow
            ENDIF
         endif
      else
         MsgAlert("Controlla la connessione su internet!","EasyLotto")
          endif
          return nil




//--------------------------------------------------//
  Function Mostra_Ciclo_Ruote(oBrw,oDlg,aCicloMetric)
     local nRuote:= 11,n

     local nRow,nCol
     local nDia,nHeight,nWidth
     Local aRuote  := {"Bari","Cagliari","Firenze","Genova",;
                       "Milano","Napoli","Palermo","Roma","Torino",;
                        "Venezia","Nazionale"}
     local aNum:= {}

     nRow:= 5
     nCol:= 10
     nDia:= 80
     nHeight:=nDia+15
     nWidth:= nDia+10
     For n= 1 to 3
        aCicloMetric[n]:= TCyclometric():New(nRow,nCol,nWidth,nHeight, oDlg,nDia)
        aCicloMetric[n]:lShowNumbers:=.f.
        aCicloMetric[n]:nDimPenCircle:= 1
        @ nHeight+8,nWidth-20 say aRuote[n] size 55,10 PIXEL OF oDlg
        nCol+=45+n
        nWidth+=nCol

     next
     return aCicloMetric




Function Mostra_Form(aCicloMetric,aColors,oBrw)
  local n
   For n= 1 to len(aCicloMetric)
     aNum:= Give_Numbers(oBrw,n)

       nColor:=aColors[ n ]
       num1 :=val(aNum[1])
       num2 :=val(aNum[2])
       num3 :=val(aNum[3])
       num4 :=val(aNum[4])
       num5 :=val(aNum[5])

       aCicloMetric[n]:Distance_Multiple(num1,num2,num3,num4,num5,nColor)

    next
   return nil



  Function Give_Numbers(oBrw,nrecord)
   local aNumeri:= {}
   local atemp:= {}
   local cText
   local num1,num2,num3,num4,num5

   AAdd(atemp,oBrw:aArrayData[ nRecord ] )

   cText:=atemp[1][1]  //text
   num1 :=atemp[1][2]
   num2 :=atemp[1][3]
   num3 :=atemp[1][4]
   num4 :=atemp[1][5]
   num5 :=atemp[1][6]

    aNumeri := {num1,num2,num3,num4,num5}

   ASort( aNumeri, nil, nil, { |x,y| x < y } )

   num1 :=aNumeri[1]
   num2 :=aNumeri[2]
   num3 :=aNumeri[3]
   num4 :=aNumeri[4]
   num5 :=aNumeri[5]

   Return aNumeri









