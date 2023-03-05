module Components.Footer exposing (view)

import Element exposing (..)
import Element.Font as Font


view : Element msg
view =
    wrappedRow
        [ Font.size 14
        , padding 10
        , spacing 10
        , Font.color <| rgba 0 0 0 0.5
        , centerX
        ]
        [ newTabLink [] { label = text "Elm", url = "https://elm-lang.org/" }
        , text "⬩"
        , newTabLink [] { label = text "Elmcraft", url = "https://elmcraft.org/" }
        ]
