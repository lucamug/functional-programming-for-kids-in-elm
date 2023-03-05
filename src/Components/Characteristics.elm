module Components.Characteristics exposing (view)

import Element exposing (..)
import Element.Border as Border
import Shared


view : Element msg
view =
    column
        [ width (maximum 800 <| fill)
        , Border.width 1
        , padding 10
        , spacing 10
        ]
        [ row [] [ el [ width <| px 150 ] <| text "Built with", text "Elm, elm-playground" ]
        , row [] [ el [ width <| px 150 ] <| text "Rendered using", text "SVG" ]
        , row [] [ el [ width <| px 150 ] <| text "Complexity", text "Medium" ]
        , row [] [ el [ width <| px 150 ] <| text "Ellie", Shared.extLink [] { label = "kChn92mtVgca1", url = "https://ellie-app.com/kChn92mtVgca1" } ]
        ]
