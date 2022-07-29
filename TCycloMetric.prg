#include "fivewin.ch"


// TCyclometric class for Italian Lottery


#define darkgray    nRgb(169,169,169)
#define darkorange  nRgb(255,140,0)
#define darkred     nRgb(139,0,0)
#define lightblue   nRgb(173,216,230)

#define TA_CENTER         6
#define COLOR_BTNFACE 15
#define PS_SOLID   0


/*
Copyright (c) 2022 <Falconi Silvio>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/




CLASS TCyclometric FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   DATA nDiametro
   DATA oFont,oBold
   DATA apos  AS ARRAY

   DATA lShowNumbers AS LOGICAL init .T.
   DATA nDimPenCircle,nDimPenLine

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nDiametro) CONSTRUCTOR
   METHOD Init( hDlg )
   METHOD End() INLINE if( ::hWnd == 0, ::Destroy(), Super:End() )
   METHOD Destroy()
   METHOD Display()
   METHOD Paint()
   METHOD Line( nTop, nLeft, nBottom, nRight, oPen )
   METHOD Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel,lTransparent, nAlign )
   METHOD Distance(num1,num2)
   METHOD Distance_Multiple(num1,num2,num3,num4,num5)
   METHOD Say_distance(num1,num2)
ENDCLASS

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nDiametro,;
   lDesign,lShowNumbers,nDimPenCircle,nDimPenLine ) CLASS  TCyclometric

DEFAULT  nDiametro     := 200             ,;
         nHeight       := 200             ,;
         nLeft         := 10              ,;
         nTop          := 10              ,;
         nWidth        := 200             ,;
         lDesign       := .f.             ,;
         lShowNumbers  := .t.             ,;
         nDimPenCircle := 1               ,;
         nDimPenLine   := 1               ,;
         oWnd          := GetWndDefault()

 ::nId         := ::GetNewId()
 ::nTop        := nTop
 ::nLeft       := nLeft
 ::nBottom     := nTop + nHeight - 1
 ::nRight      := nLeft + nWidth - 1

 ::oWnd        := oWnd
 ::lDrag       = lDesign
 ::oBrush := TBrush():New(,GetSysColor(COLOR_BTNFACE) )
 ::apos := {}

 ::nDiametro   =  nDiametro

 ::oFont     = TFont():New( "Tahoma", 0, -10 )
 ::oBold     = TFont():New( "Verdana", 0, -10, , .t. )

 ::nStyle   := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_CLIPSIBLINGS )
 ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )

 ::lShowNumbers  := lShowNumbers
 ::nDimPenCircle := nDimPenCircle
 ::nDimPenLine   := nDimPenLine

   if ! Empty( oWnd:hWnd )
       ::Create()
       ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif

   if lDesign
      ::CheckDots()
   endif
   Return self

//--------------------------------------------------------------------------------------------------------//
METHOD Init( hDlg ) CLASS  TCyclometric

   Super:Init( hDlg )

   return nil
//--------------------------------------------------------------------------------------------------------//
METHOD Destroy() CLASS  TCyclometric
   if ::hWnd != 0
      ::Super:Destroy()
   endif
return nil
//--------------------------------------------------------//
METHOD Display() CLASS  TCyclometric
   ::BeginPaint()
   ::Paint()
   ::EndPaint()
return 0
//--------------------------------------------------------//


METHOD Paint() CLASS  TCyclometric
   local nI
   local  nRaggio := (::nDiametro/2)
   local  xCent   := ::nLeft+nRaggio
   local  yCent   := ::nTop+nRaggio
   local  aTcPen := array(4)
   local  nTotalNumbers := 90
   local step_fi := PI() / 4.5 / 10  // add by Jimmy
   local hDc:=::getDc(), nDeltaR
   local nRaggioSay,nY2,nX2


    aTcPen[1] := CREATEPEN( PS_SOLID, ::nDimPenCircle, darkgray )
    aTcPen[2] := CREATEPEN( PS_SOLID, ::nDimPenLine, darkred )



     //draw the circle
    Ellipse(hDC,::nLeft,::nTop,::nLeft+::nDiametro,::nTop+ ::nDiametro,aTcPen[1])


   //draw the numbers
   nYOffset = ::oFont:nHeight / 2
   nXOffset = ::oFont:nWidth / 2
   nDeltaR := ::oFont:nHeight

   FOR nI = 1 TO nTotalNumbers
      nAngolo := 2* Pgreco() / nTotalNumbers * ( nI - 1 )
      nY := INT( nRaggio * SIN(( ni-22.5) * step_fi ) + yCent)
      nX := INT( nRaggio * COS(( ni-22.5) * step_fi ) + xCent)

      // small  circles
      Ellipse(hDC, nX,nY ,nX-3,nY+3,aTcPen[2])

     // Save the positions of numbers
      aadd( ::apos , {nI,nY,nX} )



      If ::lShowNumbers
         nRaggioSay := (::nDiametro/2) + 10
         nY2 := INT( nRaggioSay * SIN(( ni-22.5) * step_fi ) + yCent)
         nX2 := INT( nRaggioSay * COS(( ni-22.5) * step_fi ) + xCent)
        ::Say( nY2 - nYOffset, nX2 - 0, hb_ntoc( nI,0 ),CLR_RED , , ::oFont, .t.,.t., TA_CENTER )
      Endif

    //Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel, lTransparent, nAlign )
NEXT




  ::ReleaseDC()

   return nil
//--------------------------------------------------------------//
STAT FUNC Pgreco(); RETURN (3.1415926536)
//--------------------------------------------------------------//

METHOD Line( nTop, nLeft, nBottom, nRight, nColor,nspessore ) CLASS  TCyclometric

 *  local hPen := if( oPen = nil, 0, oPen:hPen )

 local  oPen := CreatePen(PS_SOLID, nspessore, nColor  )

 local   hOldPen
 ::GetDC()
   hOldPen := SelectObject( ::hDC, oPen )
   MoveTo( ::hDC, nLeft, nTop )
   LineTo( ::hDC, nRight, nBottom, oPen )
  SelectObject( ::hDC, hOldPen )
   ::ReleaseDC()

return nil
//--------------------------------------------------------------//
METHOD Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel,;
            lTransparent, nAlign ) CLASS  TCyclometric

   DEFAULT nClrFore := ::nClrText,;
           nClrBack := ::nClrPane,;
           oFont    := ::oFont,;
           lPixel   := .f.,;
           lTransparent := .f.

   if ValType( nClrFore ) == "C"      //  xBase Color string
      nClrBack = nClrFore
      nClrFore = nGetForeRGB( nClrFore )
      nClrBack = nGetBackRGB( nClrBack )
   endif

   ::GetDC()

   DEFAULT nAlign := GetTextAlign( ::hDC )

   WSay( ::hWnd, ::hDC, nRow, nCol, cValToChar( cText ), nClrFore, nClrBack,;
         If( oFont != nil, oFont:hFont, 0 ), lPixel, lTransparent, nAlign )

   ::ReleaseDC()

return nil
//--------------------------------------------------------------//

METHOD Distance(num1,num2)  CLASS  TCyclometric
   local  aNumpos := ::apos
   local nAt1,nAt2
   local oPen,hOldPen
   local aRect:= {}
   local nDistanza,nYOffset,nXOffset, nY,nX

  // xbrowser aNumpos

   nAt1:= AScan( aNumpos, { | a | a[1] = num1 } )
   nAt2:= AScan( aNumpos, { | a | a[1] = num2 } )

   aRect:= {aNumpos[nAt1][2],aNumpos[nAt1][3],aNumpos[nAt2][2],aNumpos[nAt2][3]}

   ::line( aRect[1],aRect[2],aRect[3],aRect[4], CLR_RED)


   // draw the distance number
         IF num2>num1
             nDistanza:= num2-num1
          else
             nDistanza:= num1-num2
          Endif
          If nDistanza > 45
            nDistanza:= 90-nDistanza
         Endif

       nYOffset = ::oFont:nHeight / 2
       nXOffset = ::oFont:nWidth / 2

       nY  := aRect[2]
       nX  := aRect[4]

  ::Say( nY - nYOffset, nX - nXOffset, LTRIM( STRzero( nDistanza,2 ) ), , , ::oFont, .t.,;
            .t., nil )

   return nil

 //--------------------------------------------------------------//

 METHOD Distance_Multiple(num1,num2,num3,num4,num5,nColor)  CLASS  TCyclometric
   local  aNumpos := ::apos
   local nAt1,nAt2,nAt3,nAt4,nAt5
   local oPen,hOldPen
   local aRect:= {}
   local nDistanza,nYOffset,nXOffset, nY,nX
   local  nRaggio := (::nDiametro/2)
   local  xCent   := ::nLeft+nRaggio
   local  yCent   := ::nTop+nRaggio
   local aPoints   := array(5)

   local aGrad := { | lInvert | If( lInvert, ;
         { { 1/3, nColor, nColor }, ;
           { 2/3, nColor, nColor }  ;
         }, ;
         { { 1/2, nColor, nColor }, ;
           { 1/2, nColor, nColor }  ;
         } ) }

 *  xbrowser aNumpos

   nAt1:= AScan( aNumpos, { | a | a[1] = num1 } )
   nAt2:= AScan( aNumpos, { | a | a[1] = num2 } )
   nAt3:= AScan( aNumpos, { | a | a[1] = num3 } )
   nAt4:= AScan( aNumpos, { | a | a[1] = num4 } )
   nAt5:= AScan( aNumpos, { | a | a[1] = num5 } )


     aPoints [5]  := {aNumpos[nAt5][2], aNumpos[nAt5][3]}
     aPoints [4]  := {aNumpos[nAt4][2], aNumpos[nAt4][3]}
     aPoints [3]  := {aNumpos[nAt3][2], aNumpos[nAt3][3]}
     aPoints [2]  := {aNumpos[nAt2][2], aNumpos[nAt2][3]}
     aPoints [1]  := {aNumpos[nAt1][2], aNumpos[nAt1][3]}


     ::line( aPoints [1][1],aPoints [1][2],aPoints [2][1],aPoints [2][2], nColor,::nDimPenLine)

     ::Say_distance(num1,num2)

     ::line( aPoints [2][1],aPoints [2][2],aPoints [3][1],aPoints [3][2], nColor,::nDimPenLine)

     ::Say_distance(num2,num3)

     ::line( aPoints [3][1],aPoints [3][2],aPoints [4][1],aPoints [4][2], nColor,::nDimPenLine)

     ::Say_distance(num3,num4)

     ::line( aPoints [4][1],aPoints [4][2],aPoints [5][1],aPoints [5][2], nColor,::nDimPenLine)

     ::Say_distance(num4,num5)


     ::line( aPoints [5][1],aPoints [5][2],aPoints [1][1],aPoints [1][2], nColor,::nDimPenLine)

     ::Say_distance(num5,num1)



     FillRectEx( ::hDC, aPoints, aGrad)


      ::ReleaseDC()
     return nil

//-----------------------------------------------------------------------//
 METHOD Say_distance(num1,num2) CLASS  TCyclometric
  local nDistanza:= 0
   local nAt1,nAt2
   local  aNumpos := ::apos
   local aRect:= {}
   local nYOffset,nXOffset, nY,nX

   //calc the distance
    IF num2>num1
             nDistanza:= num2-num1
          else
             nDistanza:= num1-num2
          Endif
          If nDistanza > 45
            nDistanza:= 90-nDistanza
         Endif

  // Print the distance
       nYOffset = ::oFont:nHeight / 2
       nXOffset = ::oFont:nWidth / 2


   nAt1:= AScan( aNumpos, { | a | a[1] = num1 } )
   nAt2:= AScan( aNumpos, { | a | a[1] = num2 } )



   IF aNumpos[nAt1][3] > aNumpos[nAt2][3]
      nX := aNumpos[nAt2][3] + ( aNumpos[nAt1][3] - aNumpos[nAt2][3] ) /2
   ELSE
      nX := aNumpos[nAt1][3] + ( aNumpos[nAt2][3] - aNumpos[nAt1][3] ) /2
   ENDIF

   IF aNumpos[nAt1][2] > aNumpos[nAt2][2]
      nY := aNumpos[nAt2][2] + ( aNumpos[nAt1][2] - aNumpos[nAt2][2] ) /2
   ELSE
      nY := aNumpos[nAt1][2] + ( aNumpos[nAt2][2] - aNumpos[nAt1][2] ) /2
   ENDIF

   ::Say( nY - nYOffset, nX - 0, LTRIM( STRzero( nDistanza,2 ) ),darkorange , , ::oFont, .t.,.t., nil )

return Nil

