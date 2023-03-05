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


view : Element msg
view =
    Shared.pageSkeleton
        { listParagraph = []
        , maybeSecondaryTitle = Nothing
        , notification = []
        , route = Route.RoutePhysics2D
        , theRest =
            [ column [ spacing 50, centerX ]
                [ el [ centerX, Font.size 30 ] <| text "Under Construction"
                , el [] <| html <| Tutorials.Physics2D.Main.view Tutorials.Physics2D.Main.pointsInit
                ]
            ]
        }
