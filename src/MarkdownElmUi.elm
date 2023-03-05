module MarkdownElmUi exposing (stringToElement)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html
import Html.Attributes
import Markdown.Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Material.Icons.Types
import Parser
import Parser.Advanced
import Route
import Shared
import Style
import SyntaxHighlight


stringToElement : String -> Element msg
stringToElement markdownInput =
    case markdownInput |> Markdown.Parser.parse |> Result.mapError deadEndsToString |> Result.andThen (\ast -> Markdown.Renderer.render elmUiRenderer ast) of
        Err errors ->
            paragraph [] [ text errors ]

        Ok rendered ->
            column [ spacing 25, width fill ] rendered


deadEndsToString : List (Parser.Advanced.DeadEnd String Parser.Problem) -> String
deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


paragraphSpacing : Attribute msg
paragraphSpacing =
    spacing 15


elmUiRenderer : Markdown.Renderer.Renderer (Element msg)
elmUiRenderer =
    { blockQuote =
        \children ->
            column
                [ Border.widthEach { bottom = 0, left = 10, right = 0, top = 0 }
                , padding 10
                , Border.color (rgb255 145 145 145)
                , Background.color (rgb255 245 245 245)
                ]
                children
    , codeBlock = codeBlock
    , codeSpan = code
    , emphasis = \content -> row [ Font.italic ] content
    , hardLineBreak = html <| Html.br [] []
    , heading = heading
    , html = Markdown.Html.oneOf []
    , image =
        \i ->
            case i.title of
                Just _ ->
                    image [ width fill ] { description = i.alt, src = i.src }

                Nothing ->
                    image [ width fill ] { description = i.alt, src = i.src }
    , link =
        \{ destination } body ->
            newTabLink Shared.linkAttrsInline
                { label = paragraph [] body
                , url = destination
                }
    , orderedList = orderedList
    , paragraph = paragraph [ paragraphSpacing ]
    , strikethrough = \content -> row [ Font.strike ] content
    , strong = \content -> row [ Font.bold ] content
    , table = column []
    , tableBody = column []
    , tableCell = \_ children -> paragraph [] children
    , tableHeader = column []
    , tableHeaderCell = \_ children -> paragraph [] children
    , tableRow = row []
    , text = text
    , thematicBreak = none
    , unorderedList = unorderedList
    }


orderedList : Int -> List (List (Element msg)) -> Element msg
orderedList startingIndex items =
    column [ spacing 15 ]
        (items
            |> List.indexedMap
                (\index itemBlocks ->
                    row [ spacing 5 ]
                        [ row [ width fill, spacing 15 ]
                            (el
                                [ alignTop
                                , Font.size 26
                                , Background.color Style.color.sideMenuBackgroundSelected
                                , Font.color Style.color.sideMenuFont
                                , paddingEach { bottom = 10, left = 17, right = 17, top = 10 }
                                , Border.rounded 40
                                ]
                                (text (String.fromInt (index + startingIndex)))
                                :: [ paragraph [] itemBlocks ]
                            )
                        ]
                )
        )


unorderedList : List (Markdown.Block.ListItem (Element msg)) -> Element msg
unorderedList items =
    column [ spacing 15, paddingEach { bottom = 0, left = 20, right = 0, top = 0 } ]
        (List.map
            (\(Markdown.Block.ListItem task children) ->
                row [ alignTop, spacing 10 ]
                    [ case task of
                        Markdown.Block.CompletedTask ->
                            Input.defaultCheckbox True

                        Markdown.Block.IncompleteTask ->
                            Input.defaultCheckbox False

                        Markdown.Block.NoTask ->
                            el [ alignTop ] <| text "●"
                    , paragraph [ spacing 10 ] children
                    ]
            )
            items
        )


code : String -> Element msg
code snippet =
    paragraph
        [ Background.color (rgba 0 0 0 0.04)
        , Border.rounded 2
        , paddingXY 5 3
        , Shared.monospace
        , htmlAttribute (Html.Attributes.style "overflow-wrap" "anywhere")
        ]
        [ text snippet ]


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    let
        a : Result (List Parser.DeadEnd) SyntaxHighlight.HCode
        a =
            SyntaxHighlight.elm details.body

        b : Html.Html msg
        b =
            case a of
                Ok hcode ->
                    SyntaxHighlight.toBlockHtml Nothing hcode

                Err _ ->
                    Html.text "Error parsing Elm code"
    in
    el
        [ Background.color (rgba 0 0 0 0.85)
        , htmlAttribute (Html.Attributes.style "white-space" "pre")
        , centerX
        , width (maximum 800 <| fill)

        -- , inFront <|
        --     row [ moveDown 20, moveRight 30, spacing 10, alpha 0.8 ]
        --         [ el
        --             [ width <| px 15
        --             , height <| px 15
        --             , Background.color <| rgb 0.8 0 0
        --             , Border.rounded 50
        --             ]
        --             none
        --         , el
        --             [ width <| px 15
        --             , height <| px 15
        --             , Background.color <| rgb 1 0.8 0
        --             , Border.rounded 50
        --             ]
        --             none
        --         , el
        --             [ width <| px 15
        --             , height <| px 15
        --             , Background.color <| rgb 0 0.8 0
        --             , Border.rounded 50
        --             ]
        --             none
        --         ]
        --
        -- , padding 20
        , Shared.monospace
        , Border.rounded 15
        , clip
        , paddingEach { top = 10, right = 0, bottom = 10, left = 0 }
        ]
        -- (text details.body)
        (html <| b)


heading : { children : List (Element msg), level : Markdown.Block.HeadingLevel, rawText : String } -> Element msg
heading { children, level, rawText } =
    row
        [ width fill
        , Font.size
            (case level of
                Markdown.Block.H1 ->
                    30

                Markdown.Block.H2 ->
                    24

                _ ->
                    20
            )
        , Font.bold
        , Region.heading (Markdown.Block.headingLevelToInt level)
        , htmlAttribute (Html.Attributes.attribute "name" (rawTextToId rawText))
        , htmlAttribute (Html.Attributes.id (rawTextToId rawText))
        , Border.widthEach
            { bottom =
                case level of
                    Markdown.Block.H1 ->
                        0

                    Markdown.Block.H2 ->
                        2

                    _ ->
                        0
            , left = 0
            , right = 0
            , top = 0
            }
        , Border.color <| rgba 0 0 0 0.3
        , paddingEach
            { bottom = 8
            , left = 0
            , right = 0
            , top =
                case level of
                    Markdown.Block.H1 ->
                        50

                    Markdown.Block.H2 ->
                        100

                    _ ->
                        10
            }
        ]
        (case Route.fromTitle rawText of
            Just route ->
                [ headingSpecial route ]

            Nothing ->
                children
        )


headingSpecial : Route.Route -> Element msg
headingSpecial route =
    row [ spacing 10 ]
        [ el [] <| html (Route.toIcon route 24 Material.Icons.Types.Inherit)
        , paragraph [] [ text (Route.toTitle route) ]
        ]


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower
