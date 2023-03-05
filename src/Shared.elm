module Shared exposing
    ( Env
    , br
    , cardLink
    , errorMessage
    , extLink
    , headerHeight
    , linkAttrsInline
    , monospace
    , paddingLeftBody
    , pageSkeleton
    , preventDefault
    , screenshotsHost
    , sizeL
    , underConstruction
    , widthSideMenu
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Material.Icons
import Material.Icons.Types
import Route
import Style


br : Element msg
br =
    html <| Html.br [] []


monospace : Attribute msg
monospace =
    Font.family [ Font.typeface "Fira Code" ]


extLink : List (Attribute msg) -> { label : String, url : String } -> Element msg
extLink attrs { label, url } =
    newTabLink (linkAttrsInline ++ attrs)
        { label =
            paragraph []
                [ text (label ++ " ⬀") ]
        , url = url
        }


underConstruction : Element msg
underConstruction =
    row [ spacing 10, centerX ]
        [ el [] <| html <| Material.Icons.handyman 34 Material.Icons.Types.Inherit
        , el [ Font.size 24, Font.light ] <| text "Under Construction"
        , el [] <| html <| Material.Icons.handyman 34 Material.Icons.Types.Inherit
        ]


screenshotsHost : String
screenshotsHost =
    "http://127.0.0.1:8081/"


errorMessage : String -> String
errorMessage string =
    "Error: [" ++ string ++ "] not found"


type alias Env =
    { commit : String
    , version : String
    , service : String
    , tenant : String
    }


pageSkeleton :
    { listParagraph : List (Element msg)
    , maybeSecondaryTitle : Maybe String
    , notification : List (Element msg)
    , route : Route.Route
    , theRest : List (Element msg)
    }
    -> Element msg
pageSkeleton args =
    let
        icon : Material.Icons.Types.Icon msg
        icon =
            Route.toIcon args.route

        title : String
        title =
            Route.toTitle args.route
    in
    column
        (card
            ++ [ height fill
               , width fill
               , spacing 10
               , paddingEach { bottom = 100, left = 20, right = 20, top = 20 }
               ]
        )
        ((if List.length args.notification == 0 then
            []

          else
            [ column
                [ Background.color <| Style.color.sideMenuFont
                , padding 20
                , width fill
                , Font.center
                , Border.width 1
                , Border.color <| rgba 0 0 0 0.1
                , Border.rounded 5
                ]
                args.notification
            ]
         )
            ++ (case args.maybeSecondaryTitle of
                    Just secondaryTitle ->
                        [ link (linkAttrsInline ++ [ Font.color <| rgb 0 0 0 ])
                            { label =
                                row [ spacing 20, padding 20, alpha 0.4, mouseOver [ alpha 1 ] ]
                                    [ el [ alignTop ] <| html <| icon 25 Material.Icons.Types.Inherit
                                    , paragraph
                                        [ Font.size 20
                                        , Font.bold
                                        , htmlAttribute <| Html.Attributes.style "overflow-wrap" "anywhere"
                                        ]
                                        [ text title ]
                                    ]
                            , url = Route.toLocationHref args.route
                            }
                        , paragraph [ Font.size 35, Font.center ] [ text secondaryTitle ]
                        ]

                    Nothing ->
                        [ row [ centerX, spacing 20, padding 50 ]
                            [ el [ alignTop ] <| html <| icon 40 Material.Icons.Types.Inherit
                            , paragraph
                                [ Font.size 35
                                , Font.bold
                                , htmlAttribute <| Html.Attributes.style "overflow-wrap" "anywhere"
                                , htmlAttribute <| Html.Attributes.style "letter-spacing" "1px"
                                ]
                                [ text title ]
                            ]
                        ]
               )
            ++ [ paragraph [ Font.center, width (maximum 600 <| fill), centerX, paddingEach { bottom = 50, left = 0, right = 0, top = 0 } ]
                    args.listParagraph
               ]
            ++ args.theRest
        )


headerHeight : number
headerHeight =
    60


sizeL : number
sizeL =
    260


sizeM : number
sizeM =
    110


widthSideMenu : { a | isSideMenuOpen : Bool, isSmallScreen : Bool } -> number
widthSideMenu model =
    if model.isSideMenuOpen then
        sizeL

    else if model.isSmallScreen then
        0

    else
        sizeM


paddingLeftBody : { a | isSideMenuOpen : Bool, isSmallScreen : Bool } -> number
paddingLeftBody model =
    if model.isSmallScreen then
        0

    else if model.isSideMenuOpen then
        sizeL

    else
        sizeM


card : List (Attribute msg)
card =
    [ Border.width 1
    , Border.rounded 10
    , Border.color <| rgba 0 0 0 0.1
    , Background.color <| Style.color.backgroundMiddle
    , padding 20
    , width fill
    ]


cardLink : List (Attribute msg)
cardLink =
    [ Border.width 1
    , Border.rounded 10
    , Border.color <| rgba 0 0 0 0.1

    -- Same effect as https://paulbricman.com/reflections/translation-is-pervasive
    , mouseOver
        [ Border.shadow { blur = 20, color = rgba 0 0 0 0.15, offset = ( 0, 6 ), size = 0 }
        , Border.color <| rgba 0 0 0 0.3
        , moveUp 3
        ]
    , htmlAttribute <| Html.Attributes.style "transition" "all 200ms linear"
    , Background.color <| Style.color.backgroundMiddle
    , padding 20
    , width fill
    ]


linkAttrsInline : List (Attribute msg)
linkAttrsInline =
    [ mouseOver
        [ Background.color Style.color.sideMenuBackgroundSelected
        , Font.color <| Style.color.sideMenuFont
        ]
    , htmlAttribute <| Html.Attributes.style "transition" "background .1s linear"
    , Font.color Style.color.sideMenuBackgroundSelected
    , Border.width 0
    , Border.rounded 5
    , paddingXY 4 3
    , moveLeft 4
    ]


preventDefault : msg -> Html.Attribute msg
preventDefault href =
    Html.Events.preventDefaultOn "click" (Json.Decode.succeed ( href, True ))
