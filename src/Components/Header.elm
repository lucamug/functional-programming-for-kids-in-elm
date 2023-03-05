module Components.Header exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Material.Icons
import Material.Icons.Types
import Route
import Shared
import Style
import Types.Model


view :
    Types.Model.Model
    -> { b | msgOnPress : msg, msgPushUrl : String -> msg }
    -> Element msg
view model args2 =
    let
        locationHref : String
        locationHref =
            Route.toLocationHref Route.RouteHome
    in
    row
        [ spacing 35
        , width fill
        , Background.color Style.color.sideMenuBackground
        , Font.color Style.color.sideMenuFont
        , height fill
        , paddingEach { bottom = 0, left = 15, right = 0, top = 0 }
        , height <| px Shared.headerHeight
        ]
        [ Input.button [ centerY ]
            { label =
                el
                    [ mouseOver [ Background.color Style.color.sideMenuBackgroundOver ]
                    , paddingEach { bottom = 5, left = 5, right = 5, top = 5 }
                    , Border.rounded 10
                    ]
                <|
                    html <|
                        if model.isSideMenuOpen then
                            Material.Icons.menu_open 34 Material.Icons.Types.Inherit

                        else
                            Material.Icons.menu 34 Material.Icons.Types.Inherit
            , onPress = Just args2.msgOnPress
            }
        , link
            [ htmlAttribute <| Shared.preventDefault (args2.msgPushUrl locationHref)
            , mouseOver [ Background.color Style.color.sideMenuBackgroundOver ]
            , paddingEach { bottom = 2, left = 3, right = 3, top = 2 }
            , Border.rounded 10
            ]
            { label =
                el
                    [ Font.size 28
                    , Font.bold
                    ]
                <|
                    text <|
                        "Functional Programming for Kids, in Elm"
            , url = locationHref
            }
        ]
