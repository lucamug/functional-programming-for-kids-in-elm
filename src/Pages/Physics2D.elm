module Pages.Physics2D exposing (view)

import Color
import Element exposing (..)
import Element.Font as Font
import Html
import MarkdownElmUi
import Route
import Shared
import TurtleGraphics exposing (..)
import Tutorials.Physics2D.Main


view : List Tutorials.Physics2D.Main.Point -> Element msg
view points =
    Shared.pageSkeleton
        { listParagraph = []
        , maybeSecondaryTitle = Nothing
        , notification = []
        , route = Route.RoutePhysics2D
        , theRest =
            [ column [ spacing 50, centerX ]
                [ el [ centerX ] <| html <| Tutorials.Physics2D.Main.view points
                , Element.el [ Element.width Element.fill ] <| MarkdownElmUi.stringToElement markdown
                , el [ centerX, Font.size 20 ] <| text "Under Construction"
                ]
            ]
        }


markdown : String
markdown =
    """
# The code

```
updatePoints : List Point -> List Point
updatePoints points =
    List.map
        (\\p ->
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
```
"""
