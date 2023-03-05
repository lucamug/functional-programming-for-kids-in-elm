module Pages.Home exposing (view)

import Element exposing (..)
import Element.Font as Font
import Playground
import Types.Model


view : Types.Model.Model -> Element msg
view model =
    column
        [ centerX
        , height (maximum 800 <| fill)
        , paddingXY 20 100
        , spacing 20
        ]
        [ paragraph [ Font.size 30 ] [ text "Under Construction" ]
        , paragraph [] [ text "A collection of resources for teaching and learning Functional Programming, for begineers." ]
        ]
