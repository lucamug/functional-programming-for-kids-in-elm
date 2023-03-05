module Components.SideMenu exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes
import Material.Icons.Types
import Route
import Shared
import Style
import Types.Model


view : Types.Model.Model -> { b | msgPushUrl : String -> msg } -> Element msg
view model args2 =
    let
        paddingSize : number
        paddingSize =
            if model.isSideMenuOpen then
                20

            else
                10

        paddingTop : number
        paddingTop =
            if model.isSideMenuOpen then
                60

            else
                30
    in
    column
        [ width fill
        , paddingEach { bottom = paddingSize, left = paddingSize, right = paddingSize, top = paddingTop }
        , spacing 0
        ]
        ([ paragraph [ width shrink, Font.size 14, moveUp 58, moveRight 80, Font.light, htmlAttribute <| Html.Attributes.style "letter-spacing" "3px" ]
            -- [ List.head model.datasets.folders
            --     |> Maybe.map
            --         (\folderMetadata ->
            --             folderMetadata.version
            --                 ++ "_"
            --                 ++ String.left 4
            --                     folderMetadata.commit
            --         )
            --     |> Maybe.withDefault "Error"
            --     |> text
            -- ]
            [ text <| model.env.version ++ "_" ++ String.left 4 model.env.commit ]
         ]
            ++ List.map (\routeData -> rowMenu model args2 routeData) Route.routesData
        )


separator : Element msg
separator =
    el
        [ alpha 0.5
        , paddingEach { bottom = 10, left = 20, right = 20, top = 10 }
        , width fill
        ]
    <|
        el [ Border.width 1, width fill ] <|
            text ""


rowMenu :
    Types.Model.Model
    -> { b | msgPushUrl : String -> msg }
    ->
        { c
            | icon : Int -> Material.Icons.Types.Coloring -> Html.Html msg
            , route : Route.Route
        }
    -> Element msg
rowMenu model { msgPushUrl } routeData =
    let
        locationHref : String
        locationHref =
            Route.toLocationHref routeData.route

        paddingLeftRight : number
        paddingLeftRight =
            if model.isSideMenuOpen then
                28

            else
                10

        paddingTopBottom : number
        paddingTopBottom =
            15

        colorPortal : Style.Colors
        colorPortal =
            Style.color
    in
    link
        ([ paddingEach
            { bottom = paddingTopBottom
            , left = paddingLeftRight
            , right = paddingLeftRight
            , top = paddingTopBottom
            }
         , mouseOver [ Background.color colorPortal.sideMenuBackgroundOver ]
         , Border.rounded 10
         , width fill
         , htmlAttribute <| Shared.preventDefault (msgPushUrl locationHref)
         , htmlAttribute <| Html.Attributes.style "transition" "background-color 100ms linear"
         ]
            ++ (if Route.removePayload model.route == routeData.route then
                    [ Background.color colorPortal.sideMenuBackgroundSelected
                    , mouseOver [ Background.color colorPortal.sideMenuBackgroundSelected ]
                    ]

                else
                    []
               )
        )
        { label =
            if model.isSideMenuOpen then
                row [ spacing 26 ]
                    [ el [] <| html <| routeData.icon 26 Material.Icons.Types.Inherit
                    , paragraph [ Font.size 18 ]
                        [ text <| Route.toTitle routeData.route ]
                    ]

            else
                column [ spacing 5, width fill ]
                    [ el [ centerX ] <| html <| routeData.icon 34 Material.Icons.Types.Inherit
                    , paragraph [ Font.size 12, width fill, Font.center ]
                        [ text <| Route.toTitle routeData.route ]
                    ]
        , url = locationHref
        }
