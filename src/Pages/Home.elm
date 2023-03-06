module Pages.Home exposing (view)

import Element exposing (..)
import Element.Font as Font
import Playground
import Types.Model


view : Types.Model.Model -> Element msg
view model =
    column
        [ centerX
        , width (maximum 600 <| fill)
        , paddingXY 20 100
        , spacing 20
        , Font.center
        , height fill
        ]
        [ paragraph [] [ text "Under Construction" ]
        , paragraph [ Font.size 30 ] [ text "A collection of resources for teaching and learning Functional Programming, for begineers." ]
        ]
