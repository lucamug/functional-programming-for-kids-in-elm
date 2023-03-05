module Components.Textarea exposing (view)

import Element exposing (..)
import Element.Border as Border
import Html
import Html.Attributes


view : String -> Element msg
view value =
    el [ width fill, Border.width 1, Border.color <| rgba 0 0 0 0.15 ] <|
        html <|
            Html.textarea
                [ Html.Attributes.value value
                , Html.Attributes.style "white-space" "nowrap"
                , Html.Attributes.style "width" "100%"
                , Html.Attributes.style "height" "500px"
                , Html.Attributes.style "font-size" "16px"
                , Html.Attributes.style "border" "0px"
                , Html.Attributes.style "padding" "20px"
                , Html.Attributes.style "box-sizing" "border-box"
                ]
                []
