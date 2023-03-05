module Pages.Robot exposing (view)

import Color
import Components.Characteristics
import Components.Playground
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html
import MarkdownElmUi
import Material.Icons
import Material.Icons.Types
import Playground exposing (..)
import Route
import Shared
import Time
import Types.Model


view : Types.Model.Model -> msg -> Element.Element msg
view model msgToggleAnimationPause =
    Shared.pageSkeleton
        { listParagraph = []
        , maybeSecondaryTitle = Nothing
        , notification = []
        , route = Route.RouteRobot
        , theRest =
            [ Element.column
                [ Element.spacing 50
                , Element.width (Element.maximum 800 <| Element.fill)
                , Element.centerX
                ]
                [ Components.Characteristics.view

                -- , Element.el [] <| MarkdownElmUi.stringToElement "Let's build together this animation from scratch using the [**Elm Playground**](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) library!"
                , Components.Playground.view model.animationPaused (Just msgToggleAnimationPause) <| animationView_ screen (posixToTime model.posix) all
                , Element.el [ Element.width Element.fill ] <| MarkdownElmUi.stringToElement markdown
                ]
            ]
        }


main : Program () Animation Msg
main =
    animation all


screen : Screen
screen =
    { width = 800
    , height = 600
    , top = 300
    , left = -400
    , right = 400
    , bottom = -300
    }



-- https://ellie-app.com/kBRffJt8Yq4a1
-- https://ellie-app.com/kChn92mtVgca1


speed : number
speed =
    1


all : Time -> List Shape
all time =
    -- Road
    [ rectangle lightBlue 1200 900
    , group
        (List.map
            (\index ->
                polygon
                    (if modBy 2 index == 0 then
                        yellow

                     else
                        darkYellow
                    )
                    [ ( 0, 0 ), ( 180, 0 ), ( 180 + 140, 120 ), ( 140, 120 ) ]
                    |> moveRight (toFloat index * 180)
            )
            (List.range 0 7)
        )
        |> move ((spin (-0.3 * speed) time - 900) * 1) -300

    -- Shadow
    , oval darkBrown (wave 200 400 (speed / 2) time) 40
        |> move -100 (wave -260 -250 (speed / 2) time)
        |> fade 0.3

    -- Robot
    , group
        -- Head
        [ group
            [ circle yellow 15
                |> moveUp 180
            , rectangle yellow 10 50
                |> moveUp 160
            , rectangle darkGray 150 140
                |> moveUp 70

            -- face
            , group
                [ circle darkBrown 15
                    |> moveLeft 10
                , circle darkBrown 15
                    |> moveRight 50
                , circle darkBrown 15
                    |> moveDown 40
                , circle darkBrown 15
                    |> moveRight 40
                    |> moveDown 40
                , rectangle darkBrown 50 30
                    |> moveDown 40
                    |> moveRight 20
                ]
                |> moveUp 80
            ]
            -- |> rotate (wave -5 5 1 time)
            |> moveUp 70

        -- Leg
        , leg Left time purple darkPurple darkRed
            |> move 25 -30
        , arm Left time
            |> move 25 30

        -- Body
        , rectangle gray 150 150

        -- Leg
        , leg Right time lightPurple purple red
            |> move -15 -30
        , arm Right time
            |> move -15 30
        ]
        |> rotate (wave 0 -15 (speed / 2) time)
        |> move -100 (wave -15 -85 (speed / 2) time)
    ]


type Side
    = Left
    | Right


arm : Side -> Time -> Shape
arm side time =
    -- Arms
    group
        [ rectangle lightPurple 30 100
            |> moveDown 75
        , circle purple 30

        -- Hand
        , polygon lightYellow
            [ ( -10, 0 )
            , ( -10, -20 )
            , ( -5, -20 )
            , ( -5, -5 )
            , ( 5, -5 )
            , ( 5, -20 )
            , ( 10, -20 )
            , ( 10, 0 )
            ]
            |> moveDown 120
            |> scale 3
        ]
        |> rotate
            (case side of
                Left ->
                    wave -40 60 speed time

                Right ->
                    wave 60 -40 speed time
            )


leg : Side -> Time -> Color -> Color -> Color -> Shape
leg side time color1 color2 color3 =
    -- Leg
    group
        -- Upper leg
        [ rectangle color1 50 50
            |> moveDown 43
        , circle color2 30

        -- Lower leg
        , group
            [ rectangle color1 50 50
                |> moveDown 44
            , circle color2 30

            -- Feets
            , rectangle color3 100 40
                |> moveDown 90
                |> rotate
                    (case side of
                        Left ->
                            zigzag 0 -60 speed time

                        Right ->
                            zigzag -60 0 speed time
                    )
            ]
            |> moveDown 86
            |> rotate
                (case side of
                    Left ->
                        zigzag 0 -100 speed time

                    Right ->
                        zigzag -100 0 speed time
                )
        ]
        |> moveDown 20
        |> rotate
            (case side of
                Left ->
                    wave 80 -40 speed time

                Right ->
                    wave -40 80 speed time
            )


markdown : String
markdown =
    """# Step 2
    
Let's add some animation to the entire object.

```elm
module Main exposing (main)

import Playground exposing (..)

main =
    animation view

view time =
    [ group
        [ rectangle red 300 80
            |> moveUp 50
        , octagon darkGray 36
            |> moveLeft 100
            |> rotate (spin 2 time)
        , octagon darkGray 36
            |> moveRight 100
            |> rotate (spin 2 time)
        ]
        |> moveUp (wave -20 20 1 time)
        |> rotate (wave -10 10 1.4 time)
    ]
```

"""
