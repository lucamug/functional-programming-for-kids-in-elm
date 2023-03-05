module Components.Playground exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Material.Icons
import Material.Icons.Types


view : Bool -> Maybe msg -> Html.Html msg -> Element.Element msg
view animationPaused maybeMsgToggleAnimationPause playground =
    let
        mainPart =
            Element.el
                [ Border.width 1
                , Border.color <| Element.rgba 0 0 0 0.1
                , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 10, color = Element.rgba 0 0 0 0.03 }
                , Background.color <| Element.rgb 1 1 1
                , Element.width <| Element.px 400
                , Element.height <| Element.px 300

                -- , Element.inFront <|
                --     case maybeMsgToggleAnimationPause of
                --         Just _ ->
                --             Element.el [ Element.alignRight ] <|
                --                 Element.html <|
                --                     (if animationPaused then
                --                         Material.Icons.play_arrow
                --
                --                      else
                --                         Material.Icons.pause
                --                     )
                --                         30
                --                         Material.Icons.Types.Inherit
                --
                --         Nothing ->
                --             Element.none
                ]
            <|
                Element.html <|
                    playground
    in
    case maybeMsgToggleAnimationPause of
        Just msgToggleAnimationPause ->
            Input.button [ Element.centerX ]
                { onPress = Just msgToggleAnimationPause
                , label = mainPart
                }

        Nothing ->
            mainPart
