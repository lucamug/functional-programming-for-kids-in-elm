module Pages.TurtleTree exposing (view)

import Color
import Element exposing (..)
import Html
import MarkdownElmUi
import Route
import Shared
import TurtleGraphics exposing (..)


view : Element msg
view =
    Shared.pageSkeleton
        { listParagraph = []
        , maybeSecondaryTitle = Nothing
        , notification = []
        , route = Route.RouteTurtleTree
        , theRest =
            [ el [ centerX ] <| html <| tree
            , MarkdownElmUi.stringToElement treeCode
            ]
        }


squareSpiral : Html.Html msg
squareSpiral =
    let
        iter : Int -> Float -> List Command
        iter n dist =
            case n of
                0 ->
                    []

                _ ->
                    iter (n - 1) (dist + 2.5)
                        |> List.append
                            [ turn 89.5
                            , move dist
                            , rotateHue 0.002
                            , increaseAlpha -0.005
                            , increaseWidth 0.02
                            ]
    in
    iter 200 1.0
        |> branch
        |> List.singleton
        |> List.append
            [ increaseRed -1
            , increaseGreen 1
            , increaseBlue -1
            ]
        |> branch
        |> render Color.darkCharcoal


tree : Html.Html msg
tree =
    let
        iter : Float -> Command
        iter distance =
            let
                angle =
                    distance * 2
            in
            if distance > 0 then
                branch
                    [ move 40
                    , increaseWidth -1
                    , increaseRed -0.04
                    , increaseGreen 0.04
                    , increaseBlue -0.04
                    , turn angle
                    , iter (distance - 1)
                    , turn (-2 * angle)
                    , iter (distance - 1)
                    ]

            else
                branch []
    in
    iter 11
        |> List.singleton
        |> List.append
            [ turn 90
            , increaseWidth 10
            , increaseRed 0.65
            , increaseGreen 0.15
            , increaseBlue 0.15
            ]
        |> branch
        |> render Color.white


treeCode : String
treeCode =
    """
# The code

```tree : Html.Html msg
tree =
    let
        iter : Float -> Command
        iter distance =
            let
                angle =
                    distance * 2
            in
            if distance > 0 then
                branch
                    [ move 40
                    , increaseWidth -1
                    , increaseRed -0.04
                    , increaseGreen 0.04
                    , increaseBlue -0.04
                    , turn angle
                    , iter (distance - 1)
                    , turn (-2 * angle)
                    , iter (distance - 1)
                    ]

            else
                branch []
    in
    iter 11
        |> List.singleton
        |> List.append
            [ turn 90
            , increaseWidth 10
            , increaseRed 0.65
            , increaseGreen 0.15
            , increaseBlue 0.15
            ]
        |> branch
        |> render Color.white
```
"""
