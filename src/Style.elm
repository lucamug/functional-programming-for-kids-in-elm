module Style exposing
    ( Colors
    , color
    , css
    )

import Element exposing (..)


type alias Colors =
    { backgroundBelow : Color
    , backgroundMiddle : Color
    , backgroundTop : Color
    , opaqueCover : Color
    , sideMenuBackground : Color
    , sideMenuBackgroundOver : Color
    , sideMenuBackgroundSelected : Color
    , sideMenuFont : Color
    }


color : Colors
color =
    { backgroundBelow = rgb 0.9 0.9 0.9
    , backgroundMiddle = rgb 0.95 0.95 0.95
    , backgroundTop = rgb 1 1 1
    , opaqueCover = rgba 0 0 0 0.5
    , sideMenuBackground = rgb255 15 23 43
    , sideMenuBackgroundOver = rgb255 55 63 93
    , sideMenuBackgroundSelected = rgb255 80 69 230
    , sideMenuFont = rgb 1 1 0.5
    }


css : String
css =
    """
.mouseOverZIndex:hover {z-index: 1;}
/* https://github.com/mdgriffith/elm-ui/issues/57 */
.s.r > s:first-of-type.accx { flex-grow: 0 !important; }
.s.r > s:last-of-type.accx { flex-grow: 0 !important; }
.cx > .wrp { justify-content: center !important; }
pre.elmsh {line-height: 20px; margin:0; padding: 30px} code.elmsh {font-family: 'Fira Code'}
"""
