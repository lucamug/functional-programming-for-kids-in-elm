module Pages.Car exposing (view)

import Color
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
        , route = Route.RouteCar
        , theRest =
            [ Element.column
                [ Element.spacing 50
                , Element.width (Element.maximum 600 <| Element.fill)
                , Element.centerX
                ]
                [ Element.el [] <| MarkdownElmUi.stringToElement "Let's build together this animation from scratch using the [**Elm Playground**](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) library!"
                , Components.Playground.view model.animationPaused (Just msgToggleAnimationPause) <| animationView_ screen (posixToTime model.posix) all
                , Components.Playground.view model.animationPaused (Just msgToggleAnimationPause) <| animationView_ screen (posixToTime model.posix) viewAnimation1
                , Element.el [ Element.width Element.fill ] <| MarkdownElmUi.stringToElement markdown
                , Components.Playground.view model.animationPaused (Just msgToggleAnimationPause) <| animationView_ screen (posixToTime model.posix) viewAnimation2
                ]
            ]
        }


main : Program () Animation Msg
main =
    animation viewAnimation2


screen : Screen
screen =
    { width = 800
    , height = 600
    , top = 300
    , left = -400
    , right = 400
    , bottom = -300
    }


viewAnimation1 : Time -> List Shape
viewAnimation1 time =
    [ rectangle red 300 80
        |> moveUp 50
    , pentagon red 100
        |> rotate 180
        |> moveUp 110
    , octagon darkGray 36
        |> moveLeft 100
        |> rotate (spin 3 time)
    , octagon darkGray 36
        |> moveRight 100
        |> rotate (spin 3 time)
    ]


viewAnimation2 : Time -> List Shape
viewAnimation2 time =
    [ group
        [ rectangle red 300 80
            |> moveUp 50
        , octagon darkGray 36
            |> moveLeft 100
            |> rotate (spin 3 time)
        , octagon darkGray 36
            |> moveRight 100
            |> rotate (spin 3 time)
        ]
        |> moveUp (wave -10 10 2 time)
        |> rotate (wave -5 5 2.4 time)
    ]



-- https://ellie-app.com/kChq4rMJB6Za1


triangleIsosceles : Color -> Float -> Float -> Shape
triangleIsosceles color x y =
    polygon color [ ( -x / 2, 0 ), ( x / 2, 0 ), ( 0, y ) ]


dayNight : Float
dayNight =
    5


all : Time -> List Shape
all time =
    -- the sky
    [ group
        [ rectangle lightBlue 1400 600
        , rectangle black 1400 600
            |> fade (zigzag 0 1 dayNight time)
        ]
        |> moveUp 250

    -- the stars
    , image 1000 800 "images/stars.png"
        |> fade (zigzag 0 1 dayNight time)

    -- Sun and Moon
    , group
        -- the Sun
        [ circle yellow 50
            |> moveDown 280

        -- the Moon
        , group
            [ circle white 50
            , group
                [ circle lightBlue 50
                , circle black 50
                    |> fade (zigzag 0 1 dayNight time)
                ]
                |> moveLeft 30
            ]
            |> moveUp 280
        ]
        |> rotate (spin -dayNight time)

    -- the ground
    , group
        [ circle brown 3000
        , circle darkCharcoal 3000
            |> fade (zigzag 0 1 dayNight time)
        ]
        |> moveDown 2950

    -- the cloud
    , group
        [ circle grey 50
        , circle grey 40
            |> moveRight 50
        , oval grey 200 60
            |> moveDown 20
            |> moveRight 20
        ]
        |> fade 0.95
        |> move ((spin -40 time - 180) * 3) 200

    -- the tree in the background
    , group
        [ triangleIsosceles darkGreen 80 180
        , rectangle darkBrown 20 30
            |> moveDown 15
        ]
        |> move ((spin -5 time - 180) * 3) 0

    -- the car's shadow
    , oval black 350 40
        |> fade 0.2
        |> move -100 -170

    -- the car
    , group
        [ group
            -- the car's flasher
            [ oval lightYellow 25 40
            , oval darkBlue 25 40
                |> fade (zigzag 1 0 1 time)
            ]
            |> moveUp 190
            |> moveRight 35

        -- the car's light beam
        , triangleIsosceles lightYellow 80 180
            |> move 850 65
            |> rotate 90
            |> scale 4
            |> fade (zigzag 0 0.5 dayNight time)

        -- the car's body
        , rectangle red 350 80
            |> moveUp 50
        , pentagon red 100
            |> rotate 180
            |> moveUp 110

        -- the car's wheels
        , octagon black 50
            |> moveLeft 100
            |> rotate (spin -1.5 time)
        , octagon black 50
            |> moveRight 100
            |> rotate (spin -1.5 time)
        ]
        |> move -100 -130
        |> rotate (wave -0.5 0.5 0.2 time)

    -- the tree in the foreground
    , group
        [ triangleIsosceles green 80 180
        , rectangle lightBrown 20 30
            |> moveDown 15
        ]
        |> scale 3
        |> move ((spin -2.5 time - 180) * 3) -150
    ]


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

Outcome:
"""
