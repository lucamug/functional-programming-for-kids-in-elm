module Tutorials.Physics2D.Main exposing (main, pointsInit, view)

import Browser
import Browser.Events
import Canvas
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Color
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


type alias Model =
    { count : Float
    , points : List Point
    }


type Msg
    = Frame Float


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0, points = pointsInit }, Cmd.none )
        , view = \model -> view model.points
        , update = update
        , subscriptions = \model -> Browser.Events.onAnimationFrameDelta Frame
        }


width : number
width =
    400


height : number
height =
    400


size : number
size =
    30


w : number
w =
    width - size


h : number
h =
    height - size


centerX : Float
centerX =
    width / 2


centerY : Float
centerY =
    height / 2


view : List Point -> Html msg
view points =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        -- [ div [ style "position" "fixed" ] [ text <| Debug.toString model ]
        [ Canvas.toHtml
            ( width, height )
            []
            -- []
            [ clearScreen
            , render points
            ]
        ]


type alias Point =
    { xOld : Float
    , yOld : Float
    , x : Float
    , y : Float
    , color : Color.Color
    }


pointsInit : List Point
pointsInit =
    [ { x = 90
      , y = 94
      , xOld = 75
      , yOld = 100
      , color = Color.red
      }
    , { x = 95
      , y = 103
      , xOld = 75
      , yOld = 150
      , color = Color.yellow
      }
    , { x = 80
      , y = 120
      , xOld = 75
      , yOld = 130
      , color = Color.orange
      }
    , { x = 55
      , y = 112
      , xOld = 75
      , yOld = 130
      , color = Color.white
      }
    , { x = 183
      , y = 188
      , xOld = 75
      , yOld = 130
      , color = Color.lightBlue
      }
    , { x = 186
      , y = 198
      , xOld = 75
      , yOld = 130
      , color = Color.darkBlue
      }
    , { x = 350
      , y = 208
      , xOld = 50
      , yOld = 208.1
      , color = Color.blue
      }
    ]


const :
    { bounce : Float
    , friction : Float
    , gravity : Float
    }
const =
    { bounce = 0.5
    , gravity = 0.1
    , friction = 0.99
    }


updatePoints : List Point -> List Point
updatePoints points =
    List.map
        (\p ->
            let
                vx =
                    (p.x - p.xOld) * const.friction

                vy =
                    (p.y - p.yOld) * const.friction

                x1 =
                    p.x + vx

                y1 =
                    p.y + vy + const.gravity

                ( x, xOld ) =
                    if x1 > w then
                        ( w, w + vx * const.bounce )

                    else if x1 < 0 then
                        ( 0, vx * const.bounce )

                    else
                        ( x1, p.x )

                ( y, yOld ) =
                    if y1 > h then
                        ( h, h + vy * const.bounce )

                    else if y1 < 0 then
                        ( 0, vy * const.bounce )

                    else
                        ( y1, p.y )
            in
            { x = x
            , y = y
            , xOld = xOld
            , yOld = yOld
            , color = p.color
            }
        )
        points


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Frame _ ->
            ( { model
                | count = model.count + 1
                , points =
                    -- if modBy 5 (round model.count) == 0 then
                    --     updatePoints model.points
                    --
                    -- else
                    --     model.points
                    updatePoints model.points
              }
            , Cmd.none
            )


clearScreen : Canvas.Renderable
clearScreen =
    Canvas.shapes [ fill Color.darkCharcoal ] [ Canvas.rect ( 0, 0 ) width height ]


render : List Point -> Canvas.Renderable
render points =
    Canvas.group []
        (List.concat <|
            List.map
                (\p ->
                    -- [ Canvas.shapes [ Canvas.Settings.fill Color.black ] [ Canvas.rect ( p.xOld, p.yOld ) size size ]
                    -- [ Canvas.shapes [ Canvas.Settings.fill p.color ] [ Canvas.circle ( p.x, p.y ) size ]
                    [ Canvas.shapes [ Canvas.Settings.fill p.color ] [ Canvas.rect ( p.x, p.y ) size size ]
                    ]
                )
                points
        )



-- render2 : Float -> Canvas.Renderable
-- render2 count =
--     let
--         size =
--             width / 3
--
--         x =
--             -(size / 2)
--
--         y =
--             -(size / 2)
--
--         rotation =
--             degrees (count * 2)
--
--         hue =
--             toFloat (count / 4 |> floor |> modBy 100) / 100
--     in
--     shapes
--         [ transform
--             [ translate centerX centerY
--             , rotate rotation
--             ]
--         , fill (Color.hsl hue 0.3 0.7)
--         ]
--         [ rect ( x, y ) size size ]
